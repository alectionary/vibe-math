"""Record whether the preferred SEM engine is available, and run the plan done check.

Preferred engine: R, with lavaan, and OpenMx as the second optimizer.
The script uses the Python standard library so the same file runs on
Linux and on macOS. It does not call GNU-only commands.

From the repository root:

    python3 .agents/skills/replication-paper/scripts/preflight.py
    python3 .agents/skills/replication-paper/scripts/preflight.py done \
        --plan REPLICATION-PLAN.yaml --paper paper/paper.tex --root STUDY_ROOT

Exit 0 when lavaan and OpenMx can be loaded, or when a fallback record
supplies a justification and a separate validation. Exit 2 when the
preferred engine is missing and the fallback is absent or incomplete.
`done` exits 0 when the replication plan passes, and 2 when it does not.
"""

from __future__ import annotations

import argparse
import json
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

import checks
import pdf_links
import source_acquisition


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
    if not name or not justification or not validation:
        return {
            "accepted": False,
            "engine": name or None,
            "fallback": True,
            "os": record.get("os"),
            "missing": missing,
            "reason": (
                "a fallback needs a name, a justification, and an "
                "independent validation"
            ),
        }
    return {
        "accepted": True,
        "engine": name,
        "fallback": True,
        "os": record.get("os"),
        "missing": missing,
        "reason": None,
        "justification": justification,
        "independent_validation": validation,
    }


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
    completed = _git(
        root,
        "log",
        "--follow",
        "--diff-filter=A",
        "--format=%H",
        "--name-status",
        "--",
        relative,
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
    }
    if not plan_path.is_file():
        errors.append("plan: file is missing")
        result["accepted"] = False
        return result
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
    if paper_text is not None:
        try:
            errors.extend(
                'links: ' + item if not item.startswith('links:') else item
                for item in pdf_links.branch_target_errors(
                    paper_text, root, inventory=pdf_links.load_inventory_symbols(root))
            )
        except (OSError, RuntimeError) as exc:
            errors.append('links: branch target check failed: ' + type(exc).__name__)
        errors.extend(source_acquisition.acquisition_errors(root, paper_text))
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
    result["accepted"] = not errors
    return result


def done_main(argv) -> int:
    parser = argparse.ArgumentParser(description="Check a replication plan against its first commit and the paper.")
    parser.add_argument("--plan", required=True)
    parser.add_argument("--paper", required=True)
    parser.add_argument("--root", required=True)
    parser.add_argument("--analysis", action="append", default=[])
    args = parser.parse_args(argv)
    decision = done_check(args.root, args.plan, args.paper, args.analysis)
    json.dump(decision, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0 if decision["accepted"] else 2


def main(argv=None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    if argv[:1] == ["done"]:
        return done_main(argv[1:])
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--fallback",
        help="JSON file with name, justification, and independent_validation",
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
