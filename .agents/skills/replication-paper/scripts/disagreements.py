"""Every disagreement with the source gets theories, tests and a conclusion.

A disagreement is a plan part whose status is `mismatch` (or `partly` after a
complete run, `run_complete: true`), or a `published_evidence` entry marked
`agreement: disagree`. Each one must be covered by an entry in
`DISAGREEMENTS.yaml`, next to `REPLICATION-PLAN.yaml`:

    disagreements:
      - id: h-absent                      # also the paper's \\label{dis:h-absent}
        claim: what the source reports
        ours: what we find
        covers: [part or published_evidence ids]
        hypotheses:                       # at least two, one of them on our side
          - id: our-implementation
            side: ours                    # ours | source | neither
            statement: the theory
            prediction: what we would see if it were true
            test:
              method: how it was tested
              files: [committed outputs that show the result]
            result: what the test showed
            verdict: ruled_out            # supported | ruled_out | inconclusive | untested
          - ...
        conclusion: explained             # explained | partly_explained | unexplained
        whose: source                     # source | ours | both | neither | undetermined
        confidence: high                  # high | medium | low
        fixed_in: ...                     # required when whose is ours or both

The check is mechanical: every disagreement is covered; every entry has at
least two hypotheses, including one that the error is ours, which must be
tested; every tested hypothesis names committed files that exist; an untested
one says why and that the person was told; `explained` needs a supported
hypothesis and `unexplained` may not have one; `whose` must follow from the
supported hypotheses; an error of ours names its fix; and the paper carries
`\\label{dis:<id>}` for every entry, so each disagreement is discussed there.

    python3 disagreements.py check STUDY_DIR [PAPER.tex]
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

SIDES = ("ours", "source", "neither")
VERDICTS = ("supported", "ruled_out", "inconclusive", "untested")
CONCLUSIONS = ("explained", "partly_explained", "unexplained")
WHOSE = ("source", "ours", "both", "neither", "undetermined")
CONFIDENCE = ("high", "medium", "low")
AGREEMENT = ("agree", "disagree", "not_compared")
FILENAME = "DISAGREEMENTS.yaml"


def _text(value) -> bool:
    return isinstance(value, str) and len(value.strip()) >= 3


def triggers(plan) -> dict:
    """Disagreements the plan declares: {id: why}."""
    out = {}
    if not isinstance(plan, dict):
        return out
    for part in plan.get("parts") or []:
        if not isinstance(part, dict) or not isinstance(part.get("id"), str):
            continue
        status = part.get("status")
        if status == "mismatch" or (status == "partly" and part.get("run_complete") is True):
            out[part["id"]] = f"part status {status}"
    for item in plan.get("published_evidence") or []:
        if isinstance(item, dict) and item.get("agreement") == "disagree" and isinstance(item.get("id"), str):
            out[item["id"]] = "published evidence marked disagree"
    return out


def known_ids(plan) -> set:
    ids = set()
    for key in ("parts", "published_evidence"):
        for item in (plan.get(key) or []) if isinstance(plan, dict) else []:
            if isinstance(item, dict) and isinstance(item.get("id"), str):
                ids.add(item["id"])
    return ids


def agreement_errors(plan) -> list:
    """Each published_evidence entry says whether our result agrees with it."""
    errors = []
    for item in (plan.get("published_evidence") or []) if isinstance(plan, dict) else []:
        if isinstance(item, dict) and item.get("agreement") not in AGREEMENT:
            errors.append(f"published_evidence {item.get('id')}: agreement must be one of {', '.join(AGREEMENT)}")
    return errors


def entry_errors(entry, root: Path, known: set) -> list:
    if not isinstance(entry, dict) or not isinstance(entry.get("id"), str):
        return ["disagreements: each entry needs an id"]
    label = f"disagreement {entry['id']}"
    errors = []
    for key in ("claim", "ours"):
        if not _text(entry.get(key)):
            errors.append(f"{label}: {key} is required")
    covers = entry.get("covers")
    if not isinstance(covers, list) or not covers:
        errors.append(f"{label}: covers must list the plan parts or published_evidence ids it explains")
        covers = []
    for c in covers:
        if c not in known:
            errors.append(f"{label}: covers {c}, which is not a plan part or published_evidence id")
    hyps = entry.get("hypotheses")
    if not isinstance(hyps, list) or len(hyps) < 2:
        errors.append(f"{label}: at least two hypotheses are required (competing explanations)")
        hyps = hyps if isinstance(hyps, list) else []
    supported_sides = set()
    ours_tested = False
    seen = set()
    for h in hyps:
        if not isinstance(h, dict) or not isinstance(h.get("id"), str):
            errors.append(f"{label}: each hypothesis needs an id")
            continue
        hl = f"{label} hypothesis {h['id']}"
        if h["id"] in seen:
            errors.append(f"{hl}: id is repeated")
        seen.add(h["id"])
        side, verdict = h.get("side"), h.get("verdict")
        if side not in SIDES:
            errors.append(f"{hl}: side must be one of {', '.join(SIDES)}")
        if verdict not in VERDICTS:
            errors.append(f"{hl}: verdict must be one of {', '.join(VERDICTS)}")
        for key in ("statement", "prediction"):
            if not _text(h.get(key)):
                errors.append(f"{hl}: {key} is required (what would we see if this were true?)")
        if verdict == "untested":
            if not _text(h.get("untested_reason")):
                errors.append(f"{hl}: untested requires untested_reason")
            report = h.get("reported_to_person")
            if not isinstance(report, dict) or not all(_text(report.get(k)) for k in ("date", "channel", "summary")):
                errors.append(f"{hl}: untested requires reported_to_person {{date, channel, summary}}")
        elif verdict in VERDICTS:
            test = h.get("test")
            if not isinstance(test, dict) or not _text(test.get("method")):
                errors.append(f"{hl}: a tested hypothesis needs test.method")
            files = test.get("files") if isinstance(test, dict) else None
            if not isinstance(files, list) or not files:
                errors.append(f"{hl}: test.files must name the committed outputs that show the result")
            else:
                for f in files:
                    if not isinstance(f, str) or not (root / f).exists():
                        errors.append(f"{hl}: test file {f} does not exist")
            if not _text(h.get("result")):
                errors.append(f"{hl}: result is required")
            if side == "ours":
                ours_tested = True
            if verdict == "supported" and side in SIDES:
                supported_sides.add(side)
    if hyps and not ours_tested:
        errors.append(f"{label}: test at least one hypothesis that the error is ours (side: ours)")
    conclusion, whose = entry.get("conclusion"), entry.get("whose")
    if conclusion not in CONCLUSIONS:
        errors.append(f"{label}: conclusion must be one of {', '.join(CONCLUSIONS)}")
    if whose not in WHOSE:
        errors.append(f"{label}: whose must be one of {', '.join(WHOSE)}")
    if entry.get("confidence") not in CONFIDENCE:
        errors.append(f"{label}: confidence must be one of {', '.join(CONFIDENCE)}")
    if conclusion == "explained" and not supported_sides:
        errors.append(f"{label}: explained needs a supported hypothesis")
    if conclusion == "unexplained" and supported_sides:
        errors.append(f"{label}: a supported hypothesis means it is at least partly explained")
    if conclusion == "explained" and supported_sides and whose in WHOSE:
        expected = supported_sides.pop() if len(supported_sides) == 1 else None
        if expected is not None and whose != expected:
            errors.append(f"{label}: whose is {whose}, but the supported hypothesis is on the {expected} side")
        if expected is None and whose not in ("both", "undetermined"):
            errors.append(f"{label}: supported hypotheses on more than one side; whose must be both or undetermined")
    if whose in ("ours", "both") and not _text(entry.get("fixed_in")):
        errors.append(f"{label}: an error of ours needs fixed_in (the commit or file that fixes it)")
    return errors


def disagreement_errors(root, plan, paper_text) -> list:
    """All checks for one study. Returns a list of error strings."""
    import yaml

    root = Path(root)
    errors = []          # the agreement field itself is checked with published_evidence (checks.py)
    need = triggers(plan)
    path = root / FILENAME
    if not path.is_file():
        if need:
            errors.append(f"disagreements: {FILENAME} is required; uncovered: {', '.join(sorted(need))}")
        return errors
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except (OSError, yaml.YAMLError):
        return errors + [f"disagreements: {FILENAME} is not valid YAML"]
    entries = data.get("disagreements") if isinstance(data, dict) else None
    if not isinstance(entries, list):
        return errors + [f"disagreements: {FILENAME} needs a disagreements: list"]
    known = known_ids(plan)
    ids, covered = set(), set()
    for entry in entries:
        errors.extend(entry_errors(entry, root, known))
        if isinstance(entry, dict) and isinstance(entry.get("id"), str):
            if entry["id"] in ids:
                errors.append(f"disagreement {entry['id']}: id is repeated")
            ids.add(entry["id"])
            covered.update(c for c in entry.get("covers") or [] if isinstance(c, str))
    for t, why in sorted(need.items()):
        if t not in covered:
            errors.append(f"disagreements: {t} ({why}) is not covered by any entry in {FILENAME}")
    if paper_text is not None:
        for i in sorted(ids):
            if not re.search(r"\\label\{dis:" + re.escape(i) + r"\}", paper_text):
                errors.append(f"disagreement {i}: the paper has no \\label{{dis:{i}}}; discuss it there")
    return errors


def main(argv=None) -> int:
    import yaml

    args = list(sys.argv[1:] if argv is None else argv)
    if len(args) in (2, 3) and args[0] == "check":
        root = Path(args[1])
        plan = yaml.safe_load((root / "REPLICATION-PLAN.yaml").read_text(encoding="utf-8"))
        paper = Path(args[2]).read_text(encoding="utf-8") if len(args) == 3 else None
        errs = disagreement_errors(root, plan, paper)
        for e in errs:
            print(e)
        print(f"{len(errs)} problems")
        return 0 if not errs else 2
    sys.stderr.write(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main())
