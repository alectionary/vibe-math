"""Record whether the preferred SEM engine is available, and run the plan done check.

Preferred engine: R, with lavaan, and OpenMx as the second optimizer.
The script uses the Python standard library so the same file runs on
Linux and on macOS. It does not call GNU-only commands.

From the repository root:

    python3 .agents/skills/replication-paper/scripts/preflight.py
    python3 .agents/skills/replication-paper/scripts/preflight.py done \
        --plan REPLICATION-PLAN.yaml --paper paper/paper.tex --root STUDY_ROOT

Exit 0 when lavaan and OpenMx can be loaded, or when a fallback record
supplies a justification, a separate validation, and, for a blocked source
path, the person's decision (see `fallback_errors`). Exit 2 when the
preferred engine is missing and the fallback is absent or incomplete.
`done` exits 0 when the study is complete, 3 when it is incomplete (no errors,
but neither the source PDF nor a committed inventory of it is available, as
recorded in `source_missing` with its fetch issue: it may be committed, but it
is not done), and 2 when it fails.
Every plan is checked the same way (there is one plan format): per-part
limit kinds, part-specific reasons and evidence, a not_run estimate and
decision, and the published-evidence inventory. A tractable not_run part is
accepted when `decision_by` is `project` and a `decision_reason` records the
resource decline.
Optional `--pr-body` and `--record` also check the PR description's primary
PDF links. Omit them and `done` does not read a description.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

import checks
import layout
import pdf_links
import disagreements
import commit_refs
import paper_freshness
import source_acquisition
import source_items
import check_citations


def probe(which=None, runner=None) -> dict:
    """Inspect the machine. `which` and `runner` are seams for tests.

    `which(name)` returns a path or None. `runner(argv)` returns an
    object with `returncode` and `stdout`, or raises OSError.
    """
    which = which or shutil.which
    if runner is None:
        def runner(argv):
            return subprocess.run(
                argv,
                check=False,
                capture_output=True,
                text=True,
                timeout=120,
            )

    record = {
        "os": platform.system(),
        "rscript": which("Rscript"),
        "r_version": None,
        "lavaan": None,
        "openmx": None,
        "error": None,
    }
    if not record["rscript"]:
        return record

    code = (
        'cat(R.version.string, "\\n", sep="")\n'
        'for (pkg in c("lavaan", "OpenMx")) {\n'
        '  ok <- requireNamespace(pkg, quietly=TRUE)\n'
        '  ver <- if (ok) as.character(packageVersion(pkg)) else "missing"\n'
        '  cat(pkg, "\\t", ver, "\\n", sep="")\n'
        '}\n'
    )
    try:
        completed = runner([record["rscript"], "--vanilla", "-e", code])
    except (OSError, subprocess.TimeoutExpired) as exc:
        record["error"] = str(exc)
        return record
    if completed.returncode != 0:
        record["error"] = (completed.stderr or completed.stdout or "").strip()
        return record
    lines = [line for line in completed.stdout.splitlines() if line.strip()]
    if lines:
        record["r_version"] = lines[0].strip()
    for line in lines[1:]:
        name, _, version = line.partition("\t")
        key = "lavaan" if name == "lavaan" else "openmx" if name == "OpenMx" else None
        if key is None:
            continue
        record[key] = None if version.strip() == "missing" else version.strip()
    return record


def preferred_ready(record: dict) -> bool:
    return bool(record.get("rscript") and record.get("lavaan") and record.get("openmx"))


def assess(record: dict, fallback: dict | None = None) -> dict:
    """Accept the preferred engine, or a justified and validated fallback."""
    if preferred_ready(record):
        return {
            "accepted": True,
            "engine": "lavaan+openmx",
            "fallback": False,
            "os": record.get("os"),
            "r_version": record.get("r_version"),
            "lavaan": record.get("lavaan"),
            "openmx": record.get("openmx"),
            "reason": None,
        }
    missing = [
        name
        for name, present in (
            ("Rscript", record.get("rscript")),
            ("lavaan", record.get("lavaan")),
            ("OpenMx", record.get("openmx")),
        )
        if not present
    ]
    if not fallback:
        return {
            "accepted": False,
            "engine": None,
            "fallback": True,
            "os": record.get("os"),
            "missing": missing,
            "reason": "preferred engine is missing and no fallback record was given",
        }
    justification = str(fallback.get("justification", "")).strip()
    validation = str(fallback.get("independent_validation", "")).strip()
    name = str(fallback.get("name", "")).strip()
    problems = fallback_errors(fallback)
    if problems:
        return {
            "accepted": False,
            "engine": name or None,
            "fallback": True,
            "os": record.get("os"),
            "missing": missing,
            "reason": "; ".join(problems),
        }
    return {
        "accepted": True,
        "engine": name,
        "fallback": True,
        "os": record.get("os"),
        "missing": missing,
        "reason": None,
        "kind": fallback.get("kind"),
        "exact_reproduction": fallback.get("exact_reproduction"),
        "decision": fallback.get("decision"),
        "justification": justification,
        "independent_validation": validation,
    }


FALLBACK_KINDS = ("blocked", "domain")
EXACT = ("possible", "not_possible", "unknown")


def _filled(value) -> bool:
    return isinstance(value, str) and bool(value.strip())


def fallback_errors(fallback: dict) -> list:
    """A fallback is a decision the person makes when the source's own path is blocked.

    Every record names what the source used and whether running that path could
    reproduce the source exactly (for example, seeded code in the source's
    software). A `blocked` fallback also says what is lost, which ways to unblock
    were considered, and who decided: `by: person` with the date, channel and a
    summary of what the person was told and chose. `by: unreachable` is accepted
    only when exact reproduction was not possible anyway. A `domain` fallback is a
    scientific choice (the preferred engine does not implement the model), not a
    workaround for something that failed to install.
    """
    if not isinstance(fallback, dict):
        return ["fallback record must be an object"]
    errors = []
    for key in ("name", "justification", "independent_validation", "source_path"):
        if not _filled(fallback.get(key)):
            errors.append(f"fallback needs {key}")
    kind = fallback.get("kind")
    if kind not in FALLBACK_KINDS:
        errors.append("fallback kind must be blocked (the source path could not be run here) "
                      "or domain (the preferred engine does not implement the model)")
    exact = fallback.get("exact_reproduction")
    if exact not in EXACT:
        errors.append("fallback needs exact_reproduction: possible, not_possible or unknown "
                      "(run checks.py seeds on the source text)")
    if not _filled(fallback.get("exact_reproduction_evidence")):
        errors.append("fallback needs exact_reproduction_evidence (e.g. the seeds found in the source code)")
    if kind != "blocked":
        return errors
    if not _filled(fallback.get("lost")):
        errors.append("blocked fallback needs lost: what the source path would give that the fallback cannot")
    options = fallback.get("unblock_options")
    if not isinstance(options, list) or not options or not all(
            isinstance(o, dict) and _filled(o.get("option")) and _filled(o.get("outcome")) for o in options):
        errors.append("blocked fallback needs unblock_options: [{option, outcome}] for each way of running the "
                      "source path that was considered (the person's own computer, network settings, another "
                      "host, a data agreement; never the original authors)")
    decision = fallback.get("decision")
    by = decision.get("by") if isinstance(decision, dict) else None
    if by == "person":
        for key in ("date", "channel", "summary"):
            if not _filled(decision.get(key)):
                errors.append(f"blocked fallback decision by the person needs {key}")
    elif by == "unreachable":
        if not _filled(decision.get("reason")):
            errors.append("blocked fallback decided without the person needs a reason they could not be reached")
        if exact != "not_possible":
            errors.append("a blocked path that could reproduce the source exactly (or might) cannot be given up "
                          "without the person's decision; ask them and record decision.by = person")
    else:
        errors.append("blocked fallback needs decision.by: person (the person was told and chose) or unreachable")
    return errors


def _git(root: Path, *args):
    return subprocess.run(
        ["git", "-C", str(root), "-c", "core.quotepath=false", *args],
        check=False,
        capture_output=True,
    )


def _additions(text: str) -> list:
    """Oldest commit is last. `git log` prints newest first."""
    found = []
    current = None
    for line in text.splitlines():
        if re.fullmatch(r"[0-9a-f]{40}", line):
            current = line
            continue
        match = re.match(r"A\t(.+)$", line)
        if match and current:
            found.append((current, match.group(1).strip()))
            current = None
    return found


def _toplevel(root: Path) -> Path:
    completed = _git(root, "rev-parse", "--show-toplevel")
    if completed.returncode != 0:
        raise RuntimeError("root is not inside a Git repository")
    return Path(completed.stdout.decode().strip())


def _relative(root: Path, path: Path) -> str:
    full = path if path.is_absolute() else root / path
    full = full.resolve()
    try:
        return full.relative_to(_toplevel(root).resolve()).as_posix()
    except ValueError as exc:
        raise RuntimeError("path is outside the Git repository") from exc


def first_addition(root: Path, path: Path):
    """Return (revision, historical path) for the first commit that added `path`."""
    root = Path(root)
    relative = _relative(root, path)
    # `git -C` pathspecs are relative to that directory; show/cat paths are not.
    from_root = ( _toplevel(root).resolve() / relative ).resolve().relative_to(root.resolve()).as_posix()
    completed = _git(
        root,
        "log",
        "--follow",
        "--diff-filter=A",
        "--format=%H",
        "--name-status",
        "--",
        from_root,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.decode(errors="replace").strip() or "git log failed")
    added = _additions(completed.stdout.decode())
    if not added:
        raise LookupError("path is not committed")
    return added[-1]


def first_commit(root: Path, path: Path):
    """Return (revision, text) for the first commit that added `path`."""
    revision, name = first_addition(root, path)
    shown = _git(root, "show", f"{revision}:{name}")
    if shown.returncode != 0:
        raise RuntimeError(shown.stderr.decode(errors="replace").strip() or "git show failed")
    return revision, shown.stdout.decode("utf-8")


def _strict_ancestor(root: Path, ancestor: str, descendant: str) -> bool:
    if ancestor == descendant:
        return False
    completed = _git(root, "merge-base", "--is-ancestor", ancestor, descendant)
    if completed.returncode == 0:
        return True
    if completed.returncode == 1:
        return False
    raise RuntimeError(completed.stderr.decode(errors="replace").strip() or "git merge-base failed")


def _display(root: Path, path: Path) -> str:
    full = path if path.is_absolute() else root / path
    try:
        return full.resolve().relative_to(root.resolve()).as_posix()
    except ValueError:
        return full.as_posix()


def fallback_records(root: Path):
    """Every JSON file in the study shaped like an engine fallback record.

    Found by content, not by name, so a record cannot skip the decision check by
    being left off a command line. Downloaded copies are ignored.
    """
    found = []
    for path in sorted(Path(root).rglob("*.json")):
        if "downloaded" in path.parts or ".git" in path.parts:
            continue
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, UnicodeError, ValueError):
            continue
        if isinstance(data, dict) and "independent_validation" in data and "justification" in data:
            found.append((path, data))
    return found


def _sha256(path) -> str:
    import hashlib

    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def source_gate(root, plan_obj, paper_text):
    """Check the study against its source's figures and tables. Returns (errors, incomplete).

    The source PDF may not be redistributable, so it need not be stored. What
    must be committed is the evidence read from it: `source_inventory`, the
    record written by `source_items.py inventory SOURCE.pdf --out FILE` (every
    figure and table caption, with the PDF's sha256 and page count), and the
    values read from each item (`source_items`).

    PDF present: it must match `source_sha256`, and a fresh inventory of it must
    equal the committed one. PDF absent: the committed inventory stands in for
    it, and the study can be complete. With neither the PDF nor a committed
    inventory, the plan must record `source_missing: {fetch_issue, since,
    reason}` and the study is `incomplete`: committed, but never done. A
    stand-in file is never acceptable; only the recorded sha256 counts.
    """
    locator = plan_obj.get("source_locator")
    if not isinstance(locator, str) or not locator.strip():
        return [], []           # _structure already reports a missing source_locator
    if not locator.lower().endswith(".pdf"):
        return [f"source: {locator} is not a PDF; the source gate reads figures and tables from the PDF"], []
    root = Path(root)
    source = Path(locator) if Path(locator).is_absolute() else root / locator
    missing = plan_obj.get("source_missing")
    expected = plan_obj.get("source_sha256")
    inv_name = plan_obj.get("source_inventory")
    errors = []
    record = None
    if inv_name is not None:
        try:
            record = source_items.load_inventory_record(root / str(inv_name))
        except (OSError, ValueError, json.JSONDecodeError):
            errors.append(f"source: source_inventory {inv_name} is missing or is not an inventory record")
    has_sha = isinstance(expected, str) and re.fullmatch(r"[0-9a-f]{64}", expected) is not None
    if record is not None and has_sha and record["source_sha256"] != expected:
        errors.append("source: source_inventory was made from a different PDF than source_sha256")

    if not source.is_file():
        if record is not None and not errors:
            if isinstance(missing, dict):
                errors.append("source: remove source_missing; the committed inventory and extracted values "
                              "stand in for the PDF")
            if not has_sha:
                errors.append("source: source_sha256 (64 hex) is required")
            items = record["items"]
            errors.extend(source_items.source_items_errors(plan_obj, items, root))
            errors.extend(source_items.cited_label_errors(paper_text, items))
            return errors, []
        if errors:
            return errors, []
        if not isinstance(missing, dict):
            return [f"source: {locator} is not here, and the plan has neither a source_inventory record "
                    "nor a source_missing record {fetch_issue, since, reason}"], []
        problems = []
        if type(missing.get("fetch_issue")) is not int or missing["fetch_issue"] < 1:
            problems.append("source_missing.fetch_issue must be the number of the open fetch issue")
        for key in ("since", "reason"):
            if not isinstance(missing.get(key), str) or not missing[key].strip():
                problems.append(f"source_missing.{key} is required")
        if problems:
            return [f"source: {p}" for p in problems], []
        return [], [f"source: {locator} is missing and no inventory of it was committed (fetch issue "
                    f"#{missing['fetch_issue']}, since {missing['since']}); its figures and tables cannot be checked"]

    if not has_sha:
        errors.append("source: source_sha256 (64 hex) is required so the PDF checked is the one used")
    elif _sha256(source) != expected:
        errors.append(f"source: {locator} does not match source_sha256; a different file is not the source")
        return errors, []
    try:
        items = source_items.inventory(source)
    except ImportError:
        return errors + ["source: PyMuPDF (fitz) is required to inventory the source's figures and tables"], []
    except Exception as exc:            # a damaged PDF must not pass silently
        return errors + [f"source: could not read {locator}: {type(exc).__name__}"], []
    if record is None and inv_name is None:
        errors.append("source: commit the inventory (source_items.py inventory SOURCE.pdf --out FILE) and "
                      "name it in source_inventory, so the study can be checked without the PDF")
    elif record is not None:
        def key(i):
            return (i["label"], i["page"], i.get("mode"), i.get("moments"))
        if sorted(map(key, record["items"])) != sorted(map(key, items)):
            errors.append("source: the committed source_inventory differs from a fresh inventory of the PDF; "
                          "regenerate it")
    errors.extend(source_items.source_items_errors(plan_obj, items, root))
    errors.extend(source_items.cited_label_errors(paper_text, items))
    return errors, []


THIRD_PARTY_SUFFIXES = (".pdf", ".docx", ".doc", ".epub", ".djvu")


def committed_document_errors(root) -> list:
    """Other authors' documents are never committed; the values read from them are.

    Any tracked PDF or word-processor file in the study outside `paper/` (where
    our own builds live) is reported, so a source PDF, a supplement or a
    downloaded article cannot slip into git. `git ls-files` sees only what is
    committed or staged; gitignored local copies are fine.
    """
    try:
        listed = subprocess.run(["git", "-C", str(root), "ls-files", "-z", "--", "."],
                                capture_output=True, check=True).stdout.decode("utf-8", "replace")
    except (OSError, subprocess.CalledProcessError):
        return []
    errors = []
    for name in filter(None, listed.split("\0")):
        parts = Path(name).parts
        if name.lower().endswith(THIRD_PARTY_SUFFIXES) and "paper" not in parts:
            errors.append(f"documents: {name} is committed; other authors' documents are not stored in git "
                          "(commit the values read from them, and their sha256, instead)")
    return errors


def done_check(root, plan, paper, analysis=None) -> dict:
    """Fail when the plan, its first commit, or the paper's coverage claims do not line up."""
    root = Path(root).resolve()
    plan_path = Path(plan) if Path(plan).is_absolute() else root / plan
    paper_path = Path(paper) if Path(paper).is_absolute() else root / paper
    errors = []
    result = {
        "accepted": False,
        "errors": errors,
        "plan": _display(root, plan_path),
        "paper": _display(root, paper_path),
        "baseline_revision": None,
        "incomplete": [],
        "status": "failing",
    }
    if not plan_path.is_file():
        errors.append("plan: file is missing")
        result["accepted"] = False
        return result
    for path, fallback in fallback_records(root):
        errors.extend(f"fallback {_display(root, path)}: {e}" for e in fallback_errors(fallback))
    try:
        plan_obj = checks.load_plan(plan_path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, ValueError):
        errors.append("plan: invalid YAML")
        plan_obj = None
    baseline_obj = None
    baseline_error = None
    revision = None
    try:
        revision, blob = first_commit(root, plan_path)
        result["baseline_revision"] = revision
        try:
            baseline_obj = checks.load_plan(blob)
        except ValueError:
            baseline_error = "baseline: invalid YAML"
    except LookupError:
        baseline_error = "plan: first committed version is required"
    except (RuntimeError, UnicodeError):
        baseline_error = "plan: baseline lookup failed"
    paper_text = None
    paper_error = None
    if not paper_path.is_file():
        paper_error = "paper: file is missing"
    else:
        try:
            paper_text = checks.read_source_text(paper_path)
        except (OSError, UnicodeError, RuntimeError):
            paper_error = "paper: unreadable"
    if plan_obj is not None:
        errors.extend(
            checks.replication_plan_errors(
                plan_obj,
                baseline_obj,
                paper_text,
                baseline_error=baseline_error,
                paper_error=paper_error,
            )
        )
    elif baseline_error:
        errors.append(baseline_error)
    if paper_error and plan_obj is None:
        errors.append(paper_error)
    errors.extend(committed_document_errors(root))
    if isinstance(plan_obj, dict):
        try:
            errors.extend(disagreements.disagreement_errors(plan_path.parent, plan_obj, paper_text))
        except ImportError:
            errors.append("disagreements: PyYAML is required to read DISAGREEMENTS.yaml")
    incomplete = result["incomplete"]
    if isinstance(plan_obj, dict):
        gate_errors, gate_incomplete = source_gate(root, plan_obj, paper_text)
        errors.extend(gate_errors)
        incomplete.extend(gate_incomplete)
    # The paper a reviewer reads must be written from the current evidence.
    fresh = paper_freshness.freshness(root)
    errors.extend(fresh["stale"])
    incomplete.extend(fresh["draft"])
    if paper_text is not None:
        citation_source = paper_path
        if paper_path.suffix.lower() == ".pdf":
            companion = paper_path.with_suffix(".tex")
            if companion.is_file():
                citation_source = companion
        inventory_present = (root / "citation-inventory.json").exists()
        staged_latex = citation_source.suffix.lower() == ".tex" and (root / "writer-manifest.json").is_file()
        if inventory_present or staged_latex:
            errors.extend(check_citations.study_errors(root, citation_source))
        try:
            errors.extend(
                'links: ' + item if not item.startswith('links:') else item
                for item in pdf_links.branch_target_errors(
                    paper_text, root, inventory=pdf_links.load_inventory_symbols(root))
            )
        except (OSError, RuntimeError) as exc:
            errors.append('links: branch target check failed: ' + type(exc).__name__)
        errors.extend(source_acquisition.acquisition_errors(root, paper_text))
        errors.extend(commit_refs.commit_reference_errors(paper_text, root))
        pdf = layout.paper_pdf(paper_path)
        errors.extend(layout.layout_errors(paper_text, paper_path, pdf))
        errors.extend(layout.title_errors(
            paper_text, paper_path, pdf, required=paper_path.suffix.lower() == ".tex" and (root / "writer-manifest.json").is_file()))
    if revision is not None:
        for item in analysis or []:
            analysis_path = Path(item) if Path(item).is_absolute() else root / item
            label = _display(root, analysis_path)
            if not analysis_path.is_file():
                errors.append(f"analysis {label}: file is missing")
                continue
            try:
                added_at, _name = first_addition(root, analysis_path)
            except LookupError:
                errors.append(f"analysis {label}: not committed")
                continue
            except (RuntimeError, UnicodeError):
                errors.append(f"analysis {label}: commit lookup failed")
                continue
            try:
                precedes = _strict_ancestor(root, revision, added_at)
            except RuntimeError:
                errors.append(f"analysis {label}: commit lookup failed")
                continue
            if not precedes:
                errors.append(f"analysis {label}: plan was not committed before this analysis")
    # complete: no errors and nothing missing. incomplete: no errors, but material
    # evidence (the source PDF) is missing and recorded, or the paper is a
    # shared-context draft pending an isolated writing pass. failing: anything
    # else, including a paper that is stale against the evidence.
    result["status"] = "failing" if errors else ("incomplete" if result["incomplete"] else "complete")
    result["accepted"] = result["status"] == "complete"
    return result


def _pr_description():
    spec = importlib.util.spec_from_file_location(
        'replication_pr_description', Path(__file__).with_name('pr_description.py'))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def done_main(argv) -> int:
    parser = argparse.ArgumentParser(description="Check a replication plan against its first commit and the paper.")
    parser.add_argument("--plan", required=True)
    parser.add_argument("--paper", required=True)
    parser.add_argument("--root", required=True)
    parser.add_argument("--analysis", action="append", default=[])
    parser.add_argument("--pr-body", help="PR description file. Checked with --record against the primary PDF.")
    parser.add_argument("--record", help="Delivery record JSON. Required with --pr-body.")
    parser.add_argument("--head-branch", help="Head branch accepted in place of a 40-hex PDF pin.")
    args = parser.parse_args(argv)
    decision = done_check(args.root, args.plan, args.paper, args.analysis)
    if args.pr_body or args.record:
        if not args.pr_body or not args.record:
            decision["errors"].append("pr: description and delivery record are both required")
        else:
            try:
                body = Path(args.pr_body).read_text(encoding="utf-8")
                record = json.loads(Path(args.record).read_text(encoding="utf-8"))
            except (OSError, UnicodeError, json.JSONDecodeError):
                decision["errors"].append("pr: description or delivery record is unreadable")
            else:
                decision["errors"].extend(_pr_description().description_errors(
                    body, record, args.root, head_branch=args.head_branch))
        if decision["errors"]:
            decision["status"] = "failing"
        decision["accepted"] = decision["status"] == "complete"
    json.dump(decision, sys.stdout, indent=2)
    sys.stdout.write("\n")
    # 0 complete; 3 incomplete (no errors, but material evidence is missing and
    # recorded, so the study may be committed but is not done); 2 failing.
    return {"complete": 0, "incomplete": 3}.get(decision["status"], 2)


def main(argv=None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    if argv[:1] == ["done"]:
        return done_main(argv[1:])
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--fallback",
        help="JSON fallback record (see fallback_errors for the required fields)",
    )
    args = parser.parse_args(argv)
    fallback = None
    if args.fallback:
        with open(args.fallback, encoding="utf-8") as handle:
            fallback = json.load(handle)
    decision = assess(probe(), fallback)
    json.dump(decision, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0 if decision["accepted"] else 2


if __name__ == "__main__":
    sys.exit(main())
