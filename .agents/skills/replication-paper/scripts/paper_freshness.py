"""Is the paper a reviewer sees up to date with the study's evidence?

A study keeps producing evidence after its paper is written: new runs, digitized
figures, disagreement tests, plan updates. When that evidence is committed and
pushed but the paper is not revised, a reviewer reads a paper that is behind the
work. This module makes that state visible and checkable.

    python3 paper_freshness.py check --root STUDY
    python3 paper_freshness.py commits --root STUDY --since REV
    python3 paper_freshness.py pr --root STUDY --pr N [--repo owner/repo] [--fix]

`check` re-hashes everything the paper was written from and reports one state:

- ``current``: the packet, the packet's build inputs, the writer's inputs and the
  paper outputs all match their recorded hashes, no committed evidence file is
  missing from the writer's inputs, and the writer worked in a fresh context;
- ``draft``: nothing is stale, but the paper was written in the research context
  (``context: shared``) and still needs an isolated writing pass;
- ``stale``: something the paper was written from changed, or new evidence was
  never read by the writer. Each reason is listed as ``paper stale: ...``.

`commits` requires a ``Paper:`` trailer on every commit since REV that changes
the study outside ``paper/``: ``Paper: updated``, ``Paper: pending`` or
``Paper: not-needed <reason>``. It is the deterministic record that each push
considered the paper.

`pr` requires a pull request whose paper is not ``current`` to be a draft whose
description starts with the note ``> **Draft: the paper is ahead of its review.**``;
``--fix`` converts it to draft (the note is written by hand, since it says what
is behind).

Exit codes: 0 current or passing, 3 draft (check only), 1 stale or failing.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

# Committed evidence the paper is expected to have read. Paths are relative to
# the study root; a directory covers every tracked file below it.
EVIDENCE = ("REPLICATION-PLAN.yaml", "DISAGREEMENTS.yaml", "results", "source-values")
DRAFT_NOTE = "> **Draft: the paper is ahead of its review.**"
TRAILER = re.compile(r"^Paper:\s*(updated(\s.*)?|pending(\s.*)?|not-needed\s+\S.*)$", re.M | re.I)


def _sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _load(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None


def _tracked(root: Path) -> list[str]:
    try:
        out = subprocess.run(["git", "-C", str(root), "ls-files", "-z", "--", "."],
                             capture_output=True, check=True).stdout.decode("utf-8", "replace")
    except (OSError, subprocess.CalledProcessError):
        return []
    return [n for n in out.split("\0") if n]


def manifest_path(root: Path) -> Path | None:
    record = _load(root / "delivery-record.json") or {}
    named = (record.get("writer_manifest") or {}).get("path") if isinstance(record, dict) else None
    for candidate in ([named] if named else []) + ["writer-manifest.json"]:
        if (root / candidate).is_file():
            return root / candidate
    return None


def _hash_errors(root: Path, entries, label: str, skip_missing=False) -> list[str]:
    out = []
    for entry in entries or []:
        if not isinstance(entry, dict) or not entry.get("path") or not entry.get("sha256"):
            continue
        path = root / entry["path"]
        if not path.is_file():
            if not skip_missing:
                out.append(f"{label} {entry['path']} is missing")
            continue
        if _sha(path) != entry["sha256"]:
            out.append(f"{label} {entry['path']} changed")
    return out


def freshness(root) -> dict:
    """State of the paper against the evidence: current, draft, stale or absent."""
    root = Path(root).resolve()
    result = {"state": "absent", "stale": [], "draft": [], "manifest": None}
    mpath = manifest_path(root)
    if mpath is None:
        return result
    result["manifest"] = str(mpath.relative_to(root))
    manifest = _load(mpath)
    if not isinstance(manifest, dict):
        result["state"] = "stale"
        result["stale"].append("paper stale: writer manifest is unreadable")
        return result
    stale = result["stale"]

    # The packet and the inputs it was built from.
    packet_path = root / "evidence-packet.json"
    record = _load(root / "delivery-record.json") or {}
    named = (record.get("packet") or {}).get("path") if isinstance(record, dict) else None
    if named:
        packet_path = root / named
    if manifest.get("packet_sha256") and packet_path.is_file() \
            and _sha(packet_path) != manifest["packet_sha256"]:
        stale.append(f"paper stale: {packet_path.relative_to(root)} changed after the paper was written")
    packet = _load(packet_path) if packet_path.is_file() else None
    if isinstance(packet, dict):
        # A source PDF that is not in git is legitimately absent here.
        stale.extend("paper stale: packet input " + e.split(" ", 2)[2]
                     for e in _hash_errors(root, packet.get("artifacts"), "x x", skip_missing=True))

    # The writer's inputs and outputs.
    stale.extend("paper stale: writer input " + e.split(" ", 2)[2]
                 for e in _hash_errors(root, manifest.get("inputs"), "x x"))
    stale.extend("paper stale: paper output " + e.split(" ", 2)[2]
                 + " (edited after the writer manifest was recorded)"
                 for e in _hash_errors(root, manifest.get("outputs"), "x x"))

    # Committed evidence the writer never read.
    read = {e.get("path") for e in manifest.get("inputs") or [] if isinstance(e, dict)}
    if isinstance(packet, dict):
        read |= {e.get("path") for e in packet.get("artifacts") or [] if isinstance(e, dict)}
    for name in _tracked(root):
        if any(name == ev or name.startswith(ev.rstrip("/") + "/") for ev in EVIDENCE) and name not in read:
            stale.append(f"paper stale: {name} is committed evidence the writer did not read")

    # The code revision the paper names must contain the evidence it was written from.
    rev = manifest.get("code_revision")
    if rev and isinstance(packet, dict):
        stale.extend(code_revision_errors(root, rev, packet.get("artifacts") or []))
    elif isinstance(packet, dict) and manifest.get("context") == "fresh":
        stale.append("paper stale: writer manifest has no code_revision (the commit holding the code and "
                     "evidence the paper names for reproduction)")

    if manifest.get("context") != "fresh":
        result["draft"].append(
            f"paper: written with context {manifest.get('context')!r}; a draft pending an isolated writing pass")
    result["state"] = "stale" if stale else ("draft" if result["draft"] else "current")
    return result


def code_revision_errors(root: Path, rev: str, artifacts) -> list[str]:
    """Each packet artifact tracked in git must have the same bytes at `rev` as in the working tree."""
    try:
        top = subprocess.run(["git", "-C", str(root), "rev-parse", "--show-toplevel"],
                             capture_output=True, text=True, check=True).stdout.strip()
        subprocess.run(["git", "-C", top, "cat-file", "-e", f"{rev}^{{commit}}"], capture_output=True, check=True)
    except (OSError, subprocess.CalledProcessError):
        return [f"paper stale: code_revision {rev} is not a commit in this repository"]
    rel = Path(root).resolve().relative_to(Path(top).resolve())
    tracked = set(_tracked(root))
    out = []
    for entry in artifacts:
        path = entry.get("path") if isinstance(entry, dict) else None
        if not path or path not in tracked:
            continue  # untracked inputs (a local source PDF) cannot be pinned to a revision
        spec = f"{rev}:{(rel / path).as_posix()}" if str(rel) != "." else f"{rev}:{path}"
        got = subprocess.run(["git", "-C", top, "show", spec], capture_output=True)
        if got.returncode != 0:
            out.append(f"paper stale: {path} is not in code_revision {rev[:12]}")
        elif hashlib.sha256(got.stdout).hexdigest() != _sha(root / path):
            out.append(f"paper stale: {path} changed after code_revision {rev[:12]}")
    return out


def commit_errors(root, since: str) -> list[str]:
    """Every commit since `since` that changes the study outside paper/ has a Paper: trailer."""
    root = Path(root).resolve()
    top = subprocess.run(["git", "-C", str(root), "rev-parse", "--show-toplevel"],
                         capture_output=True, text=True, check=True).stdout.strip()
    rel = str(root.relative_to(Path(top).resolve()))
    revs = subprocess.run(["git", "-C", top, "rev-list", f"{since}..HEAD", "--", rel],
                          capture_output=True, text=True, check=True).stdout.split()
    errors = []
    for rev in revs:
        files = subprocess.run(["git", "-C", top, "diff-tree", "--no-commit-id", "--name-only", "-r", rev, "--", rel],
                               capture_output=True, text=True, check=True).stdout.split()
        prefix = "" if rel == "." else rel + "/"
        if all(f.startswith(prefix + "paper/") for f in files):
            continue  # a paper-only commit is the update itself
        message = subprocess.run(["git", "-C", top, "log", "-1", "--format=%B", rev],
                                 capture_output=True, text=True, check=True).stdout
        if not TRAILER.search(message):
            subject = message.splitlines()[0] if message else ""
            errors.append(f"commit {rev[:8]} ({subject}) changes the study without a "
                          "'Paper: updated|pending|not-needed <reason>' trailer")
    return errors


def pr_errors(root, number: int, repo: str, fix=False) -> list[str]:
    state = freshness(root)
    if state["state"] in ("current", "absent"):
        return []
    pr = json.loads(subprocess.run(["gh", "api", f"repos/{repo}/pulls/{number}"],
                                   capture_output=True, text=True, check=True).stdout)
    errors = []
    if not pr.get("draft"):
        if fix:
            subprocess.run(["gh", "api", "-X", "POST", f"repos/{repo}/pulls/{number}/ccr/convert_to_draft"],
                           capture_output=True, check=True)
        else:
            errors.append(f"pr #{number}: the paper is {state['state']} but the pull request is not a draft")
    if not (pr.get("body") or "").lstrip().startswith(DRAFT_NOTE):
        errors.append(f"pr #{number}: the description must open with '{DRAFT_NOTE}' and say what is behind")
    return errors


def _repo_default(root) -> str:
    url = subprocess.run(["git", "-C", str(root), "remote", "get-url", "origin"],
                         capture_output=True, text=True).stdout.strip()
    m = re.search(r"github\.com[/:]([^/]+/[^/.]+)", url)
    return m.group(1) if m else ""


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    sub = parser.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("check")
    c.add_argument("--root", required=True)
    k = sub.add_parser("commits")
    k.add_argument("--root", required=True)
    k.add_argument("--since", required=True)
    p = sub.add_parser("pr")
    p.add_argument("--root", required=True)
    p.add_argument("--pr", type=int, required=True)
    p.add_argument("--repo")
    p.add_argument("--fix", action="store_true")
    args = parser.parse_args(argv)
    if args.cmd == "check":
        state = freshness(args.root)
        print(json.dumps(state, indent=2))
        return {"current": 0, "absent": 0, "draft": 3}.get(state["state"], 1)
    if args.cmd == "commits":
        errors = commit_errors(args.root, args.since)
    else:
        errors = pr_errors(args.root, args.pr, args.repo or _repo_default(args.root), args.fix)
    print(json.dumps({"accepted": not errors, "errors": errors}, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
