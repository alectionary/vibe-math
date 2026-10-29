"""Record whether the preferred SEM engine is available.

Preferred engine: R, with lavaan, and OpenMx as the second optimizer.
The script uses the Python standard library so the same file runs on
Linux and on macOS. It does not call GNU-only commands.

From the repository root:

    python3 .agents/skills/replication-paper/scripts/preflight.py

Exit 0 when lavaan and OpenMx can be loaded, or when a fallback record
supplies a justification and a separate validation. Exit 2 when the
preferred engine is missing and the fallback is absent or incomplete.
"""

from __future__ import annotations

import argparse
import json
import platform
import shutil
import subprocess
import sys


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


def main(argv=None) -> int:
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
