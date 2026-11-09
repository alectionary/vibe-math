"""The paper names no commits or branches of its own repository.

A replication paper presents the final product on master: its links go to
`blob/master` or `tree/master`, and its text does not pin the reader to one of
our commits or working branches. Commit pins belong in the delivery record and
the pull request, not in the paper.

`commit_reference_errors(paper_text, root)` reports:
- any hexadecimal token of 7-40 characters that resolves to a commit in this
  repository, wherever it appears;
- any 40-character hexadecimal token that is not labelled as a file hash
  (SHA-256, sha256, hash or checksum in the 40 characters before it);
- any name of a branch of this repository other than master (local or on origin);
- any same-repository GitHub URL whose ref is not master
  (`/blob/<ref>/`, `/tree/<ref>/`, `/commit/`, `/compare/`, raw.githubusercontent).

File hashes of sources (e.g. the SHA-256 of a dissertation PDF) are fine.

    python3 commit_refs.py PAPER.tex --root STUDY
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

HEX = re.compile(r"(?<![0-9A-Za-z])[0-9a-f]{7,40}(?![0-9A-Za-z])")
HASH_LABEL = re.compile(r"(sha-?256|sha-?1|hash|checksum|digest)", re.I)


def _git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args], capture_output=True, text=True)


def _repository(root):
    url = _git(root, "remote", "get-url", "origin").stdout.strip()
    m = re.search(r"github\.com[/:]([^/]+/[^/.\s]+?)(?:\.git)?$", url)
    return m.group(1) if m else None


def _branches(root):
    out = _git(root, "for-each-ref", "--format=%(refname:short)", "refs/heads", "refs/remotes/origin").stdout.split()
    names = {n[len("origin/"):] if n.startswith("origin/") else n for n in out}
    # Plain words ("results") could be ordinary prose; working branches carry "/" or "-".
    return {n for n in names if n not in ("master", "main", "HEAD", "origin", "") and ("/" in n or "-" in n)}


def commit_reference_errors(paper_text: str, root) -> list[str]:
    errors = []
    text = paper_text
    for m in HEX.finditer(text):
        token = m.group(0)
        if not re.search(r"[a-f]", token) or not re.search(r"[0-9]", token):
            continue
        is_commit = _git(root, "cat-file", "-t", token).stdout.strip() == "commit"
        labelled_hash = bool(HASH_LABEL.search(text[max(0, m.start() - 40):m.start()]))
        if is_commit:
            errors.append(f"commits: the paper names commit {token[:12]}; refer to master instead")
        elif len(token) == 40 and not labelled_hash:
            errors.append(f"commits: unlabelled 40-character hash {token[:12]} looks like a commit; "
                          "label file hashes as SHA-256 or remove it")
    plain = text.replace("\\_", "_")
    for name in sorted(_branches(root)):
        if len(name) >= 4 and re.search(r"(?<![\w/.-])" + re.escape(name) + r"(?![\w/-])", plain):
            errors.append(f"commits: the paper names branch {name}; refer to master instead")
    repo = _repository(root)
    if repo:
        r = re.escape(repo)
        for m in re.finditer(r"https?://(?:www\.)?github\.com/" + r + r"/(blob|tree|commit|compare)/([^/\s}]+)", plain, re.I):
            if m.group(1).lower() in ("commit", "compare") or m.group(2) != "master":
                errors.append(f"commits: link to /{m.group(1)}/{m.group(2)[:12]}; the paper links to master only")
        for m in re.finditer(r"https?://raw\.githubusercontent\.com/" + r + r"/([^/\s}]+)/", plain, re.I):
            if m.group(1) != "master":
                errors.append(f"commits: raw link pinned to {m.group(1)[:12]}; the paper links to master only")
    return list(dict.fromkeys(errors))


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    p.add_argument("paper")
    p.add_argument("--root", required=True)
    a = p.parse_args(argv)
    errors = commit_reference_errors(Path(a.paper).read_text(encoding="utf-8"), a.root)
    print(json.dumps({"accepted": not errors, "errors": errors}, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    sys.exit(main())
