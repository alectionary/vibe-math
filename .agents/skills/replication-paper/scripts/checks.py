"""Checks for a replication comparison.

The functions are the rules a note has to apply before it gives a
verdict: round to the printed precision, keep scope in its own field,
withhold a verdict from an incomparable pair, and refuse to treat
recovery of a printed expression as the documented procedure.
`replication_plan_errors` is the done check for REPLICATION-PLAN.yaml.

Run from the repository root:

    python3 .agents/skills/replication-paper/scripts/checks.py
    python3 .agents/skills/replication-paper/scripts/checks.py captions FILE
    python3 .agents/skills/replication-paper/scripts/checks.py seeds FILE
"""

from __future__ import annotations

import json
import re
import subprocess
import sys
from decimal import Decimal, ROUND_HALF_UP, getcontext
from pathlib import Path

import yaml

getcontext().prec = 80

NUMERICAL = ("match", "close", "mismatch")
SCOPE = ("exact", "limited", "unavailable")
LEDGER_STATUS = ("followed", "departed", "not applicable")
PLAN_STATUSES = (
    "replicated",
    "partly",
    "mismatch",
    "not_attempted",
    "input_unavailable",
)
PLAN_KINDS = (
    "study",
    "chapter",
    "research_question",
    "hypothesis",
    "analysis",
    "arm",
    "condition",
    "headline",
)
_CLAIM_RANK = {"blocked": 0, "not_replicated": 1, "partly": 2, "replicated": 3}
_NEGATION = re.compile(r"\b(?:not|never|no|without)\b|n't", re.I)
_QUALIFIED_REPLICATION = re.compile(
    r"\b(?:partly|partially)\s+replicat(?:e|ed)\b"
    r"|\bnot\s+replicat(?:e|ed)\b"
    r"|\bfailed\s+to\s+replicate\b"
    r"|\b(?:could\s+not|cannot|can\s+not|unable\s+to)\s+replicat(?:e|ed)\b",
    re.I,
)
_FULL_CLAIM = re.compile(
    r"\bfull(?:y)? replicat\w*"
    r"|\bcomplete replication\b"
    r"|\bcompletely replicat\w*"
    r"|\breplicat\w* (?:of )?the (?:entire|whole|full) (?:dissertation|design)\b"
    r"|\b(?:entire|whole|full) (?:dissertation|design) (?:was |is |has been )?replicat\w*"
    r"|\breplicated every (?:condition|arm|analysis|setting|table|hypothesis|hypotheses|research question)s?\b"
    r"|\breplicated all (?:of )?(?:the )?(?:conditions|arms|analyses|settings|tables|hypotheses|hypothesis|research questions|research question)\b"
    r"|\bevery (?:condition|arm|analysis|setting|table|hypothesis|hypotheses|research question)s? (?:was |were |is |are )?replicat\w*",
    re.I,
)
_NUMBER = r"(?:[A-Za-z]\d*|\d+)(?:\.\d+)*"
_CAPTION_SPECS = (
    ("appendix_table", re.compile(rf"\bAppendix\s+Table\s+({_NUMBER})\b", re.I)),
    ("table", re.compile(rf"\bTable\s+({_NUMBER})\b", re.I)),
    ("figure", re.compile(rf"\bFigure\s+({_NUMBER})\b", re.I)),
    ("equation", re.compile(r"\bEquation\s+\(?(\d+(?:\.\d+)*)\)?", re.I)),
    ("hypothesis", re.compile(r"\bHypothesis\s+(\d+[A-Za-z]?)\b", re.I)),
    ("research_question", re.compile(r"\bResearch\s+Question\s+(\d+[A-Za-z]?)\b", re.I)),
)

# Indices whose usual definition changes when a robust correction is
# applied. SRMR from correlation residuals does not.
ROBUST_SENSITIVE = ("chisq", "chi-square", "cfi", "tli", "rmsea")
VARIABLE_SENSITIVE = ROBUST_SENSITIVE + ("srmr", "aic")

# https://www.statmodel.com/chidiff.shtml
# T is the scaled MLM, MLR, or WLSM chi-square. c is the scaling
# correction printed for that model. T*c is the normal-theory chi-square.
# Satorra and Bentler (2001), Psychometrika 66, 507-514, put that
# normal-theory difference in the numerator.
MPLUS_DIFFERENCE_URL = "https://www.statmodel.com/chidiff.shtml"
SB2001 = "Satorra and Bentler (2001), Psychometrika 66, 507-514"

COMPARABILITY_FIELDS = (
    "estimator",
    "missingness",
    "n",
    "normalizer",
    "mean_structure",
    "variable_set",
    "df",
    "baseline",
    "robust_correction",
    "fit_index",
)


def _decimal(value) -> Decimal:
    return Decimal(str(value))


def numerical_verdict(published, ours, decimals: int, close_ulps: int = 1) -> str:
    """Match if `ours` rounds half up to `published` at `decimals`.

    Close if it does not, and the absolute gap is at most `close_ulps`
    units in the last printed place. Otherwise mismatch.
    """
    if decimals < 0:
        raise ValueError("decimals must be non-negative")
    published_d = _decimal(published)
    ours_d = _decimal(ours)
    quantum = Decimal(1).scaleb(-decimals)
    rounded = ours_d.quantize(quantum, rounding=ROUND_HALF_UP)
    printed = published_d.quantize(quantum, rounding=ROUND_HALF_UP)
    if rounded == printed:
        return "match"
    if abs(ours_d - published_d) <= Decimal(close_ulps) * quantum:
        return "close"
    return "mismatch"


def two_axis(published, ours, decimals: int, scope: str, close_ulps: int = 1) -> dict:
    """Numerical verdict and scope, kept in separate fields."""
    if scope not in SCOPE:
        raise ValueError(f"scope must be one of {SCOPE}")
    numerical = numerical_verdict(published, ours, decimals, close_ulps=close_ulps)
    return {
        "numerical": numerical,
        "scope": scope,
        "decimals": decimals,
        "verdict": None,
    }


def _robust_class(record: dict) -> str:
    label = str(record.get("robust_correction", "none")).strip().lower()
    estimator = str(record.get("estimator", "")).strip().lower()
    if label in ("", "none", "ml", "plain", "wishart"):
        if estimator in ("mlr", "mlm", "mlmv", "wlsm", "wlsmv"):
            return "robust"
        return "plain"
    return "robust"


def comparability(left: dict, right: dict, index: str) -> dict:
    """Return a flag instead of a verdict when the sides are not comparable.

    `index` is the statistic being compared, such as `cfi` or `srmr`.
    """
    missing = []
    for side_name, record in (("left", left), ("right", right)):
        for field in COMPARABILITY_FIELDS:
            if field not in record or record[field] in (None, ""):
                missing.append(f"{side_name}.{field}")
    if missing:
        return {
            "verdict_allowed": False,
            "numerical": None,
            "flag": "comparability record incomplete: " + ", ".join(missing),
        }

    index_key = index.strip().lower()
    reasons = []
    if index_key in ROBUST_SENSITIVE and _robust_class(left) != _robust_class(right):
        reasons.append(
            "plain maximum likelihood against a robust "
            f"{index_key}"
        )
    if index_key in VARIABLE_SENSITIVE and left["variable_set"] != right["variable_set"]:
        reasons.append(
            "different observed-variable sets "
            f"({left['variable_set']} against {right['variable_set']})"
        )
    if left["normalizer"] != right["normalizer"] and index_key in ("chisq", "chi-square", "aic"):
        reasons.append(
            f"N against N-1 ({left['normalizer']} against {right['normalizer']})"
        )
    if reasons:
        return {
            "verdict_allowed": False,
            "numerical": None,
            "flag": "; ".join(reasons),
        }
    return {"verdict_allowed": True, "numerical": None, "flag": None}


def scaled_chi_square_difference(t0, df0, c0, t1, df1, c1) -> dict:
    """Documented Satorra-Bentler difference, and the other expression.

    `t0` and `t1` are scaled chi-squares. `c0` and `c1` are the scaling
    corrections for which `t * c` is the normal-theory chi-square.
    The nested model is the first argument.
    """
    t0, df0, c0 = _decimal(t0), _decimal(df0), _decimal(c0)
    t1, df1, c1 = _decimal(t1), _decimal(df1), _decimal(c1)
    df = df0 - df1
    if df == 0:
        raise ValueError("the models have the same degrees of freedom")
    cd = (df0 * c0 - df1 * c1) / df
    documented = (t0 * c0 - t1 * c1) / cd
    arithmetic_recovery = (t0 - t1) / cd
    return {
        "cd": cd,
        "df": df,
        "documented": documented,
        "arithmetic_recovery": arithmetic_recovery,
        "source": MPLUS_DIFFERENCE_URL,
        "procedure": SB2001,
        "t_definition": (
            "T is the scaled chi-square. c is the scaling correction. "
            "The documented numerator is T*c, the normal-theory chi-square."
        ),
    }


def procedure_comparison(printed, result: dict, decimals: int) -> dict:
    """Judge the printed value against the documented statistic only.

    A match of `arithmetic_recovery` is reported and is not a match of
    the procedure.
    """
    documented = numerical_verdict(printed, result["documented"], decimals)
    recovered = numerical_verdict(printed, result["arithmetic_recovery"], decimals)
    return {
        "procedure_numerical": documented,
        "arithmetic_recovery_numerical": recovered,
        "procedure_validated": documented == "match",
        "df": result["df"],
        "documented": result["documented"],
        "arithmetic_recovery": result["arithmetic_recovery"],
    }


def validate_ledger(rows: list) -> list:
    """Return a list of problems. An empty list means the ledger is usable."""
    problems = []
    if not rows:
        problems.append("ledger is empty")
        return problems
    for i, row in enumerate(rows):
        status = row.get("status")
        if status not in LEDGER_STATUS:
            problems.append(f"row {i}: status must be one of {LEDGER_STATUS}")
            continue
        if not str(row.get("requirement", "")).strip():
            problems.append(f"row {i}: requirement is blank")
        if not str(row.get("evidence", "")).strip():
            problems.append(f"row {i}: evidence is blank")
        if status == "departed" and not str(row.get("justification", "")).strip():
            problems.append(f"row {i}: a departure needs a justification")
    return problems


def _show(value: Decimal) -> str:
    text = format(value, "f")
    if "." in text:
        text = text.rstrip("0").rstrip(".")
    return text


def _nonempty(value) -> bool:
    return isinstance(value, str) and bool(value.strip())


def _norm(value) -> str:
    if not isinstance(value, str):
        return ""
    return re.sub(r"\s+", " ", value).strip()


def _id_ok(value) -> bool:
    return isinstance(value, str) and bool(value) and value == value.strip() and not any(ch.isspace() for ch in value)


def load_plan(text: str) -> dict:
    """Parse a replication plan. The same text always yields the same mapping."""
    try:
        data = yaml.safe_load(text)
    except yaml.YAMLError as exc:
        raise ValueError("invalid YAML") from exc
    if not isinstance(data, dict):
        raise ValueError("plan must be a YAML mapping")
    return data


def read_source_text(path: Path) -> str:
    """Read a text file, or a PDF through `pdftotext -layout`."""
    path = Path(path)
    if path.suffix.lower() != ".pdf":
        return path.read_text(encoding="utf-8")
    try:
        completed = subprocess.run(
            ["pdftotext", "-layout", "-enc", "UTF-8", str(path), "-"],
            check=False,
            capture_output=True,
        )
    except FileNotFoundError as exc:
        raise RuntimeError("pdftotext is not installed") from exc
    if completed.returncode != 0:
        detail = completed.stderr.decode(errors="replace").strip() or "pdftotext failed"
        raise RuntimeError(detail)
    return completed.stdout.decode("utf-8", errors="replace")


def _is_headline(part: dict, errors: list | None = None, label: str = "") -> bool:
    flagged = part.get("kind") == "headline"
    if "headline" in part:
        flag = part.get("headline")
        if type(flag) is not bool:
            if errors is not None:
                errors.append(f"{label}: headline must be true or false")
        elif flag:
            flagged = True
    return flagged


def _structure(data: dict, prefix: str, errors: list) -> list:
    if data.get("schema_version") != 1:
        errors.append(f"{prefix}: schema_version 1 required")
    for key in ("dissertation", "source_locator"):
        if not _nonempty(data.get(key)):
            errors.append(f"{prefix}: {key} required")
    raw = data.get("parts")
    if not isinstance(raw, list) or not raw:
        errors.append(f"{prefix}: parts required")
        raw = []
    parts = []
    seen = set()
    for index, part in enumerate(raw):
        if not isinstance(part, dict):
            errors.append(f"{prefix} parts[{index}]: mapping required")
            continue
        ident = part.get("id")
        label = f"part {ident}" if _id_ok(ident) else f"{prefix} parts[{index}]"
        if not _id_ok(ident):
            errors.append(f"{label}: id required")
        elif ident in seen:
            errors.append(f"part {ident}: duplicate id")
            continue
        else:
            seen.add(ident)
        if part.get("kind") not in PLAN_KINDS:
            errors.append(f"{label}: kind must be one of {', '.join(PLAN_KINDS)}")
        if not _nonempty(part.get("label")):
            errors.append(f"{label}: label required")
        if not _nonempty(part.get("plan")):
            errors.append(f"{label}: plan note required")
        _is_headline(part, errors, label)
        parts.append(part)
    if not any(_is_headline(part) for part in parts):
        errors.append(f"{prefix}: a headline part is required")
    return parts


def _design_value(part: dict):
    if "design_count" not in part:
        return None
    value = part.get("design_count")
    if type(value) is int and value >= 1:
        return value
    return None


LIMIT_KINDS = (
    "input_unavailable",
    "not_run",
    "theorem_finite_only",
    "out_of_scope",
)
_GENERIC_REASON = (
    "see named artifacts and limitations",
    "see named artifacts",
    "finite or documentary coverage only",
    "universal and full-design conclusions not independently established",
    "required full-design inputs or production estimates not obtained",
    "pilots and inventory are not fitted results",
    "documentary inventory completed",
    "independent proof/resource-count analysis or production fit not executed",
)
_COST_WORD = re.compile(
    r"\b(?:cpu|wall(?:-clock)?|hours?|minutes?|seconds?|cost|estimate|approximately|about|cores?|parallel(?:ized)?|time|runtime|compute)\b|\d+(?:\.\d+)?",
    re.I,
)


def _evidence_paths(value):
    if not isinstance(value, str):
        return []
    return [item.strip() for item in re.split(r"[;\n]+", value) if item.strip()]


def _reason_is_generic(reason: str) -> bool:
    folded = _norm(reason).casefold()
    if not folded:
        return True
    for phrase in _GENERIC_REASON:
        folded = folded.replace(phrase, " ")
    folded = re.sub(r"[^a-z0-9]+", " ", folded).strip()
    return len(folded) < 24


def _cost_only(text: str) -> bool:
    stripped = _COST_WORD.sub(" ", _norm(text).casefold())
    stripped = re.sub(r"[^a-z]+", " ", stripped).strip()
    return len(stripped) < 12


def _limit_entries(part):
    raw = part.get("limit_kind")
    if isinstance(raw, str):
        raw = [raw]
    if not isinstance(raw, list) or not raw:
        return None
    entries = []
    for item in raw:
        if isinstance(item, str):
            entries.append({"kind": item})
        elif isinstance(item, dict) and isinstance(item.get("kind"), str):
            entries.append(item)
        else:
            entries.append({"kind": None})
    return entries


def _detail(entry, part, key):
    if key in entry and entry.get(key) is not None:
        return entry.get(key)
    return part.get(key)


def _sufficient_statistics_errors(label: str, record) -> list:
    """A missing data file is not missing evidence until the printed summaries were checked.

    Means, SDs, correlation or covariance matrices, and sample sizes printed in the
    source often reproduce a regression, SEM or mediation model without raw data.
    `sufficient_statistics` records that search: {found, what, sufficient, why}.
    For an input that is not data (software, a proof), set {applies: false, why}.
    """
    if not isinstance(record, dict):
        return [f"{label}: input_unavailable requires sufficient_statistics "
                "{found, what, sufficient, why}: check whether printed means, SDs, "
                "correlation or covariance matrices and Ns reproduce the analysis"]
    if record.get("applies") is False:
        if not _nonempty(record.get("why")):
            return [f"{label}: sufficient_statistics applies: false requires why"]
        return []
    errors = []
    for key in ("found", "sufficient"):
        if type(record.get(key)) is not bool:
            errors.append(f"{label}: sufficient_statistics.{key} must be true or false")
    for key in ("what", "why"):
        if not _nonempty(record.get(key)):
            errors.append(f"{label}: sufficient_statistics.{key} is required")
    if record.get("sufficient") is True:
        errors.append(f"{label}: the printed statistics are sufficient; reproduce the "
                      "analysis from them instead of marking the input unavailable")
    return errors


VALUE_SOURCES = ("table", "text", "figure_digitized", "figure_not_digitized")


def published_evidence_errors(plan) -> list:
    """Every published quantity the paper compares against names where its value came from.

    A comparison read from prose ("near zero") when a figure plots the values is
    weaker than one read from the figure. `plotted_in` lists the figures that plot
    the quantity; such an item must be read from a table or a digitized figure, or
    say why the figure was not digitized and that the person was told.
    """
    items = plan.get("published_evidence") if isinstance(plan, dict) else None
    if not isinstance(items, list) or not items:
        return ["plan: requires published_evidence: one entry per published "
                "quantity compared, with location, quantity, value_source and plotted_in"]
    errors = []
    seen = set()
    for index, item in enumerate(items):
        if not isinstance(item, dict):
            errors.append(f"published_evidence[{index}]: mapping required")
            continue
        ident = item.get("id")
        label = f"published_evidence {ident}" if _id_ok(ident) else f"published_evidence[{index}]"
        if not _id_ok(ident):
            errors.append(f"{label}: id required")
        elif ident in seen:
            errors.append(f"{label}: id is repeated")
        seen.add(ident)
        for key in ("location", "quantity"):
            if not _nonempty(item.get(key)):
                errors.append(f"{label}: {key} is required")
        if item.get("agreement") not in ("agree", "disagree", "not_compared"):
            errors.append(f"{label}: agreement must be agree, disagree or not_compared "
                          "(each disagree is analysed in DISAGREEMENTS.yaml)")
        source = item.get("value_source")
        if source not in VALUE_SOURCES:
            errors.append(f"{label}: value_source must be one of {', '.join(VALUE_SOURCES)}")
            continue
        plotted = item.get("plotted_in")
        if plotted is None or not isinstance(plotted, list):
            errors.append(f"{label}: plotted_in must list the figures that plot this quantity ([] if none)")
            plotted = []
        if source == "figure_digitized":
            if not _nonempty(item.get("digitized_file")):
                errors.append(f"{label}: figure_digitized requires digitized_file")
            if not _nonempty(item.get("reading_error")):
                errors.append(f"{label}: figure_digitized requires reading_error (data units)")
        if source == "figure_not_digitized":
            report = item.get("reported_to_person")
            if not _nonempty(item.get("reason")):
                errors.append(f"{label}: figure_not_digitized requires a reason")
            if not isinstance(report, dict) or not all(
                    _nonempty(report.get(key)) for key in ("date", "channel", "summary")):
                errors.append(f"{label}: figure_not_digitized requires reported_to_person "
                              "{date, channel, summary}")
        if source == "text" and plotted:
            errors.append(f"{label}: read from prose while {', '.join(map(str, plotted))} plots it; "
                          "digitize the figure (scripts/digitize.py) or record figure_not_digitized "
                          "with the reason and reported_to_person")
    return errors


def _limit_kind_errors(parts) -> list:
    """Reject stock reasons, shared evidence, and incomplete not_run decisions.

    Applies to every plan. A status other than
    ``replicated`` needs one or more limit kinds, each with its own facts.
    """
    errors = []
    reasons = {}
    evidence_sets = {}
    for part in parts:
        ident = part.get("id")
        if not _id_ok(ident):
            continue
        label = f"part {ident}"
        status = part.get("status")
        if status == "replicated":
            continue
        if status not in PLAN_STATUSES:
            continue
        entries = _limit_entries(part)
        if entries is None:
            # Disagreement from a complete run is a result, not a limit. A `mismatch` or
            # `partly` part that declares `run_complete: true` still needs its own reason
            # and evidence (checked below) but no limit kind. A reduced run (run_count
            # below design_count) is a limit and keeps the requirement.
            run, denom = part.get("run_count"), part.get("design_count")
            reduced = isinstance(run, int) and isinstance(denom, int) and run < denom
            complete = part.get("run_complete") is True and status in ("mismatch", "partly")
            if not complete or reduced:
                errors.append(f"{label}: limit_kind required when status is not replicated")
            entries = []
        seen_kinds = []
        for entry in entries:
            kind = entry.get("kind")
            if kind not in LIMIT_KINDS:
                errors.append(f"{label}: limit_kind must be one of {', '.join(LIMIT_KINDS)}")
                continue
            if kind in seen_kinds:
                errors.append(f"{label}: limit_kind {kind} is repeated")
                continue
            seen_kinds.append(kind)
            if kind in ("input_unavailable", "not_run"):
                report = _detail(entry, part, "reported_to_person")
                if not isinstance(report, dict) or not all(
                        _nonempty(report.get(key)) for key in ("date", "channel", "summary")):
                    errors.append(f"{label}: {kind} requires reported_to_person "
                                  "{date, channel, summary}: a blocked part is the person's decision")
            if kind == "input_unavailable":
                if not _nonempty(_detail(entry, part, "missing_input")):
                    errors.append(f"{label}: input_unavailable requires missing_input")
                if not _nonempty(_detail(entry, part, "looked_in")):
                    errors.append(f"{label}: input_unavailable requires looked_in")
                errors.extend(_sufficient_statistics_errors(label, _detail(entry, part, "sufficient_statistics")))
            elif kind == "not_run":
                estimate = _detail(entry, part, "cost_estimate")
                decision = _detail(entry, part, "decision")
                tractable = _detail(entry, part, "tractable")
                if not _nonempty(estimate):
                    errors.append(f"{label}: not_run requires a cost_estimate")
                if not _nonempty(decision):
                    errors.append(f"{label}: not_run requires a decision")
                if type(tractable) is not bool:
                    errors.append(f"{label}: not_run requires tractable true or false")
                elif tractable:
                    decision_by = _detail(entry, part, "decision_by")
                    decision_reason = _detail(entry, part, "decision_reason")
                    # An explicit project decision may decline a tractable part for resources.
                    # Cost alone, with no recorded decider, still fails.
                    if decision_by not in (None, "project"):
                        errors.append(f"{label}: decision_by must be project for a recorded resource decision")
                    project_decision = (
                        decision_by == "project"
                        and _nonempty(decision_reason)
                        and not _reason_is_generic(decision_reason)
                    )
                    if decision_by == "project" and not project_decision:
                        errors.append(f"{label}: a project resource decision requires a decision_reason")
                    if not project_decision:
                        justification = _detail(entry, part, "justification")
                        if not _nonempty(justification) or _cost_only(justification) or (
                            _nonempty(estimate) and _norm(justification).casefold() == _norm(estimate).casefold()
                        ):
                            errors.append(
                                f"{label}: compute cost alone is not acceptable when the part is tractable"
                            )
            elif kind == "theorem_finite_only":
                if not _nonempty(_detail(entry, part, "finite_checks")):
                    errors.append(f"{label}: theorem_finite_only requires finite_checks")
            elif kind == "out_of_scope":
                if not _nonempty(_detail(entry, part, "scope_reason")):
                    errors.append(f"{label}: out_of_scope requires scope_reason")
        reason = part.get("reason")
        if isinstance(reason, str) and _nonempty(reason):
            if _reason_is_generic(reason):
                errors.append(f"{label}: reason is a generic template")
            key = _norm(reason).casefold()
            reasons.setdefault(key, []).append(ident)
        paths = _evidence_paths(part.get("evidence"))
        if len(paths) != len(set(paths)):
            errors.append(f"{label}: evidence path is repeated")
        unique = tuple(dict.fromkeys(paths))
        if unique:
            evidence_sets.setdefault(unique, []).append(ident)
    for idents in reasons.values():
        if len(idents) > 1:
            for ident in idents:
                others = ", ".join(item for item in idents if item != ident)
                errors.append(f"part {ident}: reason duplicates {others}")
    for idents in evidence_sets.values():
        if len(idents) > 1:
            for ident in idents:
                others = ", ".join(item for item in idents if item != ident)
                errors.append(f"part {ident}: evidence is not part-specific; shared with {others}")
    return errors


def _part_ceiling(status, reduced: bool) -> str:
    if status in ("not_attempted", "input_unavailable") or status not in PLAN_STATUSES:
        return "blocked"
    if status == "mismatch":
        return "not_replicated"
    if status == "partly" or reduced:
        return "partly"
    if status == "replicated":
        return "replicated"
    return "blocked"


def _sentences(text: str) -> list:
    flat = re.sub(r"\s+", " ", text).strip()
    if not flat:
        return []
    return [part for part in re.split(r"(?<=[.!?])\s+", flat) if part.strip()]


def _visible_prose(paper: str) -> str:
    if "\\begin{abstract}" in paper or "\\documentclass" in paper or "\\section" in paper:
        return re.sub(r"(?<!\\)%.*", "", paper)
    return paper


def _split_abstract(paper: str):
    patterns = (
        re.compile(r"\\begin\{abstract\}(.*?)\\end\{abstract\}", re.S | re.I),
        re.compile(r"(?ms)^#{1,3}[ \t]+Abstract[ \t]*\n(.*?)(?=^#{1,3}[ \t]+\S|\Z)"),
        re.compile(r"(?ms)^Abstract[ \t]*\n+(.+?)(?:\n[ \t]*\n|\Z)"),
    )
    for pattern in patterns:
        match = pattern.search(paper)
        if not match:
            continue
        abstract = match.group(1).strip()
        body = (paper[: match.start()] + paper[match.end() :]).strip()
        return (abstract or None), body
    return None, paper


def _strongest_claim(sentence: str):
    scrubbed = _QUALIFIED_REPLICATION.sub(" ", sentence)
    for match in re.finditer(r"\breplicat(?:e|ed)\b", scrubbed, re.I):
        window = scrubbed[max(0, match.start() - 60) : match.start()]
        if _NEGATION.search(window):
            continue
        return "replicated"
    if re.search(r"\b(?:partly|partially)\s+replicat(?:e|ed)\b", sentence, re.I):
        return "partly"
    if re.search(r"\bnot\s+replicat(?:e|ed)\b|\bfailed\s+to\s+replicate\b", sentence, re.I):
        return "not_replicated"
    if re.search(
        r"\b(?:could\s+not|cannot|can\s+not|unable\s+to)\s+replicat(?:e|ed)\b|\bnot\s+established\b",
        sentence,
        re.I,
    ):
        return "blocked"
    return None


def _pattern_hits(text: str, pattern: re.Pattern) -> list:
    found = []
    for sentence in _sentences(text):
        for match in pattern.finditer(sentence):
            window = sentence[max(0, match.start() - 60) : match.start()]
            if _NEGATION.search(window):
                continue
            phrase = re.sub(r"\s+", " ", match.group()).strip()
            if phrase not in found:
                found.append(phrase)
    return found


def _coverage_language_errors(recorded: list, removals: list, paper: str) -> list:
    errors = []
    visible = _visible_prose(paper)
    abstract, body = _split_abstract(visible)
    headlines = [item for item in recorded if item["headline"]]
    full = bool(recorded) and not removals and all(item["fully"] for item in recorded)
    if not full:
        for phrase in _pattern_hits(visible, _FULL_CLAIM):
            errors.append(f"paper: coverage claim overstates the plan ({phrase})")
    phrases = []
    for item in recorded:
        if item["run"] is not None and item["denom"] is not None and item["run"] < item["denom"]:
            phrase = (item["run"], item["denom"])
            if phrase not in phrases:
                phrases.append(phrase)
    if not abstract:
        errors.append("paper: abstract required")
    elif headlines:
        ceiling = min((_CLAIM_RANK[item["ceiling"]] for item in headlines))
        ceiling_name = next(name for name, rank in _CLAIM_RANK.items() if rank == ceiling)
        first = _sentences(abstract)
        claim = _strongest_claim(first[0] if first else abstract)
        if claim is not None and _CLAIM_RANK[claim] > ceiling:
            errors.append(
                f"paper: abstract verdict overstates the plan ({claim}; plan allows {ceiling_name})"
            )
    if headlines:
        ceiling = min((_CLAIM_RANK[item["ceiling"]] for item in headlines))
        ceiling_name = next(name for name, rank in _CLAIM_RANK.items() if rank == ceiling)
        for sentence in _sentences(visible):
            if not re.search(r"\bheadline\b", sentence, re.I):
                continue
            claim = _strongest_claim(sentence)
            if claim is not None and _CLAIM_RANK[claim] > ceiling:
                message = (
                    "paper: headline wording overstates the plan "
                    f"({claim}; plan allows {ceiling_name})"
                )
                if message not in errors:
                    errors.append(message)
    if phrases and abstract:
        for run, denom in phrases:
            phrase = f"{run} of {denom}"
            pattern = re.compile(rf"(?<!\d){run} of {denom}(?!\d)")
            if pattern.search(abstract) is None:
                errors.append(f"paper: abstract omits exact count {phrase}")
            if pattern.search(body) is None:
                errors.append(f"paper: body omits exact count {phrase}")
    return errors


def replication_plan_errors(plan, baseline, paper, *, baseline_error=None, paper_error=None) -> list:
    """Return done-check failures for a replication plan.

    `baseline` is the first committed plan. The same inputs always return
    the same errors, in part order. A reduced run is `run_count` below the
    larger of the current and first-committed `design_count`.
    """
    if not isinstance(plan, dict):
        return ["plan: mapping required"]
    errors = []
    current_parts = _structure(plan, "plan", errors)
    baseline_parts = []
    if isinstance(baseline, dict):
        baseline_parts = _structure(baseline, "baseline", errors)
    elif baseline_error:
        errors.append(baseline_error)
    else:
        errors.append("plan: first committed version is required")

    if "removals" not in plan:
        removals = []
    elif not isinstance(plan.get("removals"), list):
        errors.append("plan: removals must be a list")
        removals = []
    else:
        removals = plan["removals"]

    baseline_by_id = {}
    baseline_ids = []
    for part in baseline_parts:
        ident = part.get("id")
        if _id_ok(ident) and ident not in baseline_by_id:
            baseline_by_id[ident] = part
            baseline_ids.append(ident)
    current_ids = []
    for part in current_parts:
        ident = part.get("id")
        if _id_ok(ident) and ident not in current_ids:
            current_ids.append(ident)

    removal_by_id = {}
    for index, item in enumerate(removals):
        if not isinstance(item, dict):
            errors.append(f"removals[{index}]: mapping required")
            continue
        ident = item.get("id")
        if not _id_ok(ident):
            errors.append(f"removals[{index}]: id required")
            continue
        if ident in removal_by_id:
            errors.append(f"removal {ident}: duplicate id")
            continue
        removal_by_id[ident] = item
    if isinstance(baseline, dict):
        for ident in baseline_ids:
            if ident not in current_ids:
                item = removal_by_id.get(ident)
                if item is None or not _nonempty(item.get("reason")):
                    errors.append(f"part {ident}: removed without a recorded reason")
        for ident, item in removal_by_id.items():
            if ident not in baseline_ids:
                errors.append(f"removal {ident}: not in the first committed plan")
            elif ident in current_ids:
                errors.append(f"part {ident}: listed as removed but still present")

    recorded = []
    for part in current_parts:
        ident = part.get("id")
        if not _id_ok(ident):
            continue
        label = f"part {ident}"
        base = baseline_by_id.get(ident)
        if base is not None:
            changed = []
            if _norm(part.get("plan")) != _norm(base.get("plan")):
                changed.append("plan")
            if part.get("kind") != base.get("kind"):
                changed.append("kind")
            if _norm(part.get("label")) != _norm(base.get("label")):
                changed.append("label")
            if _design_value(part) != _design_value(base) and (
                "design_count" in part or "design_count" in base
            ):
                changed.append("design_count")
            if changed and not _nonempty(part.get("plan_change_reason")):
                errors.append(
                    f"{label}: changed since the first commit without a plan_change_reason "
                    f"({', '.join(changed)})"
                )
        status = part.get("status")
        if status not in PLAN_STATUSES:
            errors.append(f"{label}: status must be one of {', '.join(PLAN_STATUSES)}")
        elif status != "replicated" and not _nonempty(part.get("reason")):
            errors.append(f"{label}: {status} requires a reason")
        if "reason" in part and part.get("reason") is not None and not isinstance(part.get("reason"), str):
            errors.append(f"{label}: reason must be text")
        if not _nonempty(part.get("evidence")):
            errors.append(f"{label}: evidence required")
        denom_values = []
        for side in (part, base):
            if isinstance(side, dict) and type(side.get("design_count")) is int and side["design_count"] >= 1:
                denom_values.append(side["design_count"])
        denom = max(denom_values) if denom_values else None
        run = part.get("run_count") if "run_count" in part else None
        run_value = None
        has_design_key = "design_count" in part or (isinstance(base, dict) and "design_count" in base)
        if denom is None and "run_count" in part and not has_design_key:
            errors.append(f"{label}: design_count required when run_count is set")
        if "design_count" in part and _design_value(part) is None:
            errors.append(f"{label}: design_count must be a positive integer")
        if denom is not None and "run_count" not in part:
            errors.append(f"{label}: run_count required")
        if "run_count" in part and (type(run) is not int or run < 0):
            errors.append(f"{label}: run_count must be a non-negative integer")
        elif "run_count" in part and denom is not None:
            run_value = run
            if run > denom:
                errors.append(f"{label}: run_count exceeds design_count")
        reduced = run_value is not None and denom is not None and run_value < denom
        if reduced and status == "replicated":
            errors.append(
                f"{label}: status replicated overstates a reduced run ({run_value} of {denom})"
            )
        if reduced:
            block = part.get("subset_justification")
            if not isinstance(block, dict):
                errors.append(f"{label}: subset_justification required")
            else:
                for key in ("cost_estimate", "attempted"):
                    if not _nonempty(block.get(key)):
                        errors.append(f"{label}: subset_justification.{key} required")
        counts_open = denom is not None and run_value is None
        recorded.append(
            {
                "headline": _is_headline(part),
                "fully": status == "replicated" and not reduced and not counts_open,
                "ceiling": _part_ceiling(status, reduced or counts_open),
                "run": run_value,
                "denom": denom,
            }
        )

    # One plan format: every check applies to every plan. A `limit_schema` key in
    # an older plan is ignored; it switches nothing on or off.
    errors.extend(_limit_kind_errors(current_parts))
    errors.extend(published_evidence_errors(plan))
    if paper_error:
        errors.append(paper_error)
    elif not isinstance(paper, str):
        errors.append("plan: paper text is required")
    else:
        errors.extend(_coverage_language_errors(recorded, removals, paper))
    return errors


def _line_hints(line: str) -> list:
    candidates = []
    for priority, (kind, pattern) in enumerate(_CAPTION_SPECS):
        for match in pattern.finditer(line):
            candidates.append((match.start(), match.end(), priority, kind, match.group(1)))
    chosen = []
    last_end = -1
    for start, end, _priority, kind, number in sorted(candidates, key=lambda item: (item[0], item[2], item[1])):
        if start < last_end:
            continue
        chosen.append((start, end, kind, number))
        last_end = end
    hints = []
    for index, (start, end, kind, number) in enumerate(chosen):
        nxt = chosen[index + 1][0] if index + 1 < len(chosen) else len(line)
        caption = re.sub(r"\s+", " ", line[end:nxt]).strip()
        caption = re.sub(r"^[\s.:)\-]+", "", caption).strip()
        if kind == "table" and number[:1].isalpha():
            kind = "appendix_table"
        hints.append({"kind": kind, "number": number, "caption": caption})
    return hints


def caption_hints(text: str) -> list:
    """Optional, deterministic caption hints. Not a coverage inventory.

    Page breaks are the form feeds `pdftotext` writes. The same text always
    returns the same list, ordered by page, kind, number, and id.
    """
    found = []
    seen = set()
    pages = text.split("\f")
    for page_number, page in enumerate(pages, start=1):
        for line in page.splitlines():
            for hint in _line_hints(line):
                key = (hint["kind"], hint["number"])
                if key in seen:
                    continue
                seen.add(key)
                item = {
                    "id": f"{hint['kind']}:{hint['number']}",
                    "kind": hint["kind"],
                    "number": hint["number"],
                    "page": page_number,
                    "caption": hint["caption"],
                }
                found.append(item)
    found.sort(key=lambda item: (item["page"], item["kind"], item["number"], item["id"]))
    return found


SEED_PATTERNS = (
    ("R", re.compile(r"\bset\.seed\s*\(\s*([^)]*)\)")),
    ("R", re.compile(r"\bRNGkind\s*\(")),
    ("Python", re.compile(r"\b(?:np\.)?random\.(?:seed|default_rng|SeedSequence)\s*\(\s*([^)]*)\)")),
    ("SAS", re.compile(r"\bcall\s+streaminit\s*\(\s*([^)]*)\)", re.I)),
    ("SAS", re.compile(r"\bseed\s*=\s*(\d+)", re.I)),
    ("Mplus", re.compile(r"\bSEED\s*=\s*(\d+)\s*;")),
    ("Stata", re.compile(r"\bset\s+seed\s+(\d+)")),
    ("Julia/MATLAB", re.compile(r"\b(?:Random\.seed!|rng)\s*\(\s*([^)]*)\)")),
)


def seed_hints(text: str) -> list:
    """Seeds and RNG settings in a source's printed code.

    Seeded code means the source's own software can reproduce its data exactly.
    A fallback to another engine then loses exact reproduction, which makes it a
    blocker to put to the person, not a choice to make silently.
    """
    found = []
    for number, line in enumerate(text.splitlines(), start=1):
        for language, pattern in SEED_PATTERNS:
            match = pattern.search(line)
            if match:
                found.append({"line": number, "language": language, "text": line.strip()[:160]})
                break
    return found


def _seeds_main(argv: list) -> None:
    if len(argv) != 1:
        raise SystemExit("usage: checks.py seeds FILE")
    try:
        hints = seed_hints(read_source_text(Path(argv[0])))
    except (OSError, UnicodeError, RuntimeError) as exc:
        raise SystemExit(f"seeds: {exc}") from exc
    json.dump({"seeded": bool(hints), "hints": hints}, sys.stdout, indent=2)
    sys.stdout.write("\n")


def _captions_main(argv: list) -> None:
    if len(argv) != 1:
        raise SystemExit("usage: checks.py captions FILE")
    path = Path(argv[0])
    try:
        hints = caption_hints(read_source_text(path))
    except (OSError, UnicodeError, RuntimeError) as exc:
        raise SystemExit(f"captions: {exc}") from exc
    json.dump(hints, sys.stdout, indent=2)
    sys.stdout.write("\n")


def main(argv=None) -> None:
    args = list(sys.argv[1:] if argv is None else argv)
    if args[:1] == ["captions"]:
        _captions_main(args[1:])
        return
    if args[:1] == ["seeds"]:
        _seeds_main(args[1:])
        return
    if args:
        raise SystemExit("usage: checks.py [captions FILE | seeds FILE]")
    fixture = Path(__file__).resolve().parents[1] / "fixtures" / "abbott_regression.json"
    data = json.loads(fixture.read_text())
    pair = data["scaled_difference"]["initial_versus_refined"]
    result = scaled_chi_square_difference(
        pair["t0"], pair["df0"], pair["c0"], pair["t1"], pair["df1"], pair["c1"]
    )
    judged = procedure_comparison(pair["printed"], result, pair["decimals"])
    rounding = data["rounding_match"]
    axes = two_axis(
        rounding["published"], rounding["ours"], rounding["decimals"], rounding["scope"]
    )
    blocked = data["incomparable"][0]
    flag = comparability(blocked["left"], blocked["right"], blocked["index"])
    print("numerical", json.dumps(axes))
    print("documented_difference", _show(result["documented"]))
    print("arithmetic_recovery", _show(result["arithmetic_recovery"]))
    print("procedure_validated", judged["procedure_validated"])
    print("incomparable_flag", flag["flag"])
    print("incomparable_numerical", flag["numerical"])


if __name__ == "__main__":
    main()
