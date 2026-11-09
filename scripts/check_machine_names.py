#!/usr/bin/env python3
"""Reject machine hostnames in staged or changed tracked files.

A finding is a `.local` hostname or a Mac machine-name token. A programming
name such as `self.local` or `Family.local` is not a hostname: every label is
an identifier and none contains a hyphen. A hyphenated name is a hostname.
An address at `@` is a hostname even when the label has no hyphen. `remote..local`
is git revision syntax (a double dot), not a hostname.

The pattern names themselves may appear in CONTRIBUTING.md, AGENTS.md, and
README.md. A longer name in those files still fails. Test modules are not
exempt. This file builds the needles by concatenation so it does not contain
them.

Gzip members and zip members are inflated and scanned. Published history is
not scanned: pre-commit reads the index, and ci reads the files that differ
between the push or pull-request endpoints.

Usage:
  python3 scripts/check_machine_names.py pre-commit
  python3 scripts/check_machine_names.py ci
  python3 scripts/check_machine_names.py paths FILE...
"""

from __future__ import annotations

import argparse
import gzip
import io
import os
import re
import subprocess
import sys
import zipfile

from check_commit_emails import CheckerError, resolve_ci_range

# Concatenated so this source does not contain the machine-name needles.
_LABEL_A = b"mac" + b"book"
_LABEL_B = b"i" + b"mac"
_LABEL_C = b"mac" + b"[-_. ]?" + b"mini"

_RE_A = re.compile(
    rb"(?i)(?<![A-Za-z0-9])[A-Za-z0-9._-]*" + _LABEL_A + rb"[A-Za-z0-9._-]*"
)
_RE_B = re.compile(
    rb"(?i)(?<![A-Za-z0-9])(?:[A-Za-z0-9]+-)*"
    + _LABEL_B
    + rb"(?:-[A-Za-z0-9]+)*(?:\.[A-Za-z0-9-]+)*(?![A-Za-z0-9])"
)
_RE_C = re.compile(
    rb"(?i)(?<![A-Za-z0-9])(?:[A-Za-z0-9]+-)*"
    + _LABEL_C
    + rb"(?:-[A-Za-z0-9]+)*(?:\.[A-Za-z0-9-]+)*(?![A-Za-z0-9])"
)
MACHINE_RES = (_RE_A, _RE_B, _RE_C)
_IDENT_RE = re.compile(rb"[A-Za-z_][A-Za-z0-9_]*\Z")
_LOCAL = b".local"

# Documented allowlist.
# Span excerpts suppress a finding only when the finding sits entirely inside
# that excerpt. `remote..local` is the git range wording in the email checker.
# Documentation files may name a pattern token by itself; a longer machine
# name on those pages is still a finding.
SPAN_EXEMPTIONS: tuple[tuple[str, str], ...] = (
    ("scripts/check_commit_emails.py", "remote..local"),
)
DOC_FILES = frozenset({"CONTRIBUTING.md", "AGENTS.md", "README.md"})
DOC_TOKENS = frozenset(
    {
        "mac" + "book",
        "i" + "mac",
        "mac" + "-mini",
        "mac" + " mini",
        "mac" + "mini",
    }
)
ZIP_MEMBER_LIMIT = 64 * 1024 * 1024


def norm_path(path: str) -> str:
    return path.replace("\\", "/").lstrip("./")


def git_bytes(repo: str, *args: str) -> subprocess.CompletedProcess[bytes]:
    return subprocess.run(
        ["git", "-C", repo, *args],
        capture_output=True,
        check=False,
    )


def z_paths(blob: bytes) -> list[str]:
    return [item.decode("utf-8", "surrogateescape") for item in blob.split(b"\0") if item]


def _machine_spans(data: bytes) -> list[tuple[int, int]]:
    spans: list[tuple[int, int]] = []
    for pattern in MACHINE_RES:
        for match in pattern.finditer(data):
            spans.append((match.start(), match.end()))
    return spans


def _is_machine_token(token: bytes) -> bool:
    return any(pattern.search(token) for pattern in MACHINE_RES)


def _expand_local_token(data: bytes, dot_index: int) -> tuple[int, bytes] | None:
    """Return the hostname ending at `.local`, or None when there is no label."""
    labels_rev: list[bytes] = []
    cursor = dot_index
    start = dot_index
    while True:
        begin = cursor
        while begin > 0 and (data[begin - 1 : begin].isalnum() or data[begin - 1 : begin] == b"-"):
            begin -= 1
        if begin == cursor:
            break
        label = data[begin:cursor]
        if label.startswith(b"-") or label.endswith(b"-"):
            break
        labels_rev.append(label)
        start = begin
        if begin >= 2 and data[begin - 1 : begin] == b"." and data[begin - 2 : begin - 1] != b".":
            cursor = begin - 1
            continue
        break
    if not labels_rev:
        return None
    token = b".".join(reversed(labels_rev)) + data[dot_index : dot_index + len(_LOCAL)]
    return start, token


def _is_code_local(token: bytes) -> bool:
    """True for `self.local` or `Module.Name.local`, with no hyphen."""
    labels = token.split(b".")
    if len(labels) < 2 or labels[-1].lower() != b"local":
        return False
    names = labels[:-1]
    if any(b"-" in label for label in names):
        return False
    if any(_IDENT_RE.fullmatch(label) is None for label in names):
        return False
    return not _is_machine_token(token)


def _local_spans(data: bytes) -> list[tuple[int, int]]:
    spans: list[tuple[int, int]] = []
    lowered = data.lower()
    cursor = 0
    while True:
        index = lowered.find(_LOCAL, cursor)
        if index < 0:
            break
        after = index + len(_LOCAL)
        nxt = data[after : after + 1]
        if nxt.isalnum() or nxt in b"_-":
            cursor = index + 1
            continue
        expanded = _expand_local_token(data, index)
        cursor = after
        if expanded is None:
            continue
        start, token = expanded
        preceded_by_at = start > 0 and data[start - 1 : start] == b"@"
        if _is_code_local(token) and not preceded_by_at:
            continue
        spans.append((start, after))
    return spans


def _suppressed(path: str, data: bytes, start: int, end: int) -> bool:
    rel = norm_path(path)
    snippet = data[start:end].decode("utf-8", "replace").lower()
    if rel in DOC_FILES and snippet in DOC_TOKENS:
        return True
    for rule_path, excerpt in SPAN_EXEMPTIONS:
        if norm_path(rule_path) != rel:
            continue
        needle = excerpt.encode("utf-8")
        search = 0
        while True:
            at = data.find(needle, search)
            if at < 0:
                break
            if at <= start and end <= at + len(needle):
                return True
            search = at + 1
    return False


def _merge(spans: list[tuple[int, int]]) -> list[tuple[int, int]]:
    if not spans:
        return []
    ordered = sorted(spans)
    merged = [ordered[0]]
    for start, end in ordered[1:]:
        prev_start, prev_end = merged[-1]
        if start <= prev_end:
            merged[-1] = (prev_start, max(prev_end, end))
        else:
            merged.append((start, end))
    return merged


def payloads(data: bytes) -> list[tuple[str, bytes]]:
    found: list[tuple[str, bytes]] = [("", data)]
    if data.startswith(b"\x1f\x8b"):
        try:
            found.append(("gzip", gzip.decompress(data)))
        except (OSError, EOFError, gzip.BadGzipFile):
            pass
    if len(data) >= 2 and data[:2] == b"PK":
        try:
            with zipfile.ZipFile(io.BytesIO(data)) as archive:
                for info in archive.infolist():
                    if info.is_dir() or info.file_size > ZIP_MEMBER_LIMIT:
                        continue
                    found.append((f"zip:{info.filename}", archive.read(info)))
        except zipfile.BadZipFile:
            pass
    return found


def scan_bytes(path: str, data: bytes) -> list[str]:
    """Findings for one blob, as `path:line: machine hostname '...'`."""
    findings: list[str] = []
    for label, payload in payloads(data):
        spans = [
            (start, end)
            for start, end in _merge(_local_spans(payload) + _machine_spans(payload))
            if not _suppressed(path, payload, start, end)
        ]
        where = path if not label else f"{path} ({label})"
        for start, end in spans:
            line = payload[:start].count(b"\n") + 1
            text = payload[start:end].decode("utf-8", "replace")
            findings.append(f"{where}:{line}: machine hostname {text!r}")
    return findings


def report(findings: list[str], count: int, *, quiet_ok: bool) -> int:
    if findings:
        print("\n".join(findings), file=sys.stderr)
        print(
            f"machine hostnames in {len(findings)} place(s) across {count} file(s)",
            file=sys.stderr,
        )
        return 1
    if not quiet_ok:
        print(f"checked {count} file(s)")
    return 0


def _blob_findings(repo: str, path: str, spec: str) -> list[str]:
    result = git_bytes(repo, "show", spec)
    if result.returncode != 0:
        detail = result.stderr.decode("utf-8", "replace").strip() or f"cannot read {spec}"
        raise CheckerError(detail)
    return scan_bytes(path, result.stdout)


def cmd_pre_commit(args: argparse.Namespace) -> int:
    listed = git_bytes(args.repo, "diff", "--cached", "--name-only", "-z", "--diff-filter=ACMR")
    if listed.returncode != 0:
        print(listed.stderr.decode("utf-8", "replace"), file=sys.stderr)
        return 2
    paths = z_paths(listed.stdout)
    try:
        findings: list[str] = []
        for path in paths:
            findings.extend(_blob_findings(args.repo, path, f":{path}"))
    except CheckerError as exc:
        print(f"pre-commit: {exc}", file=sys.stderr)
        return 2
    return report(findings, len(paths), quiet_ok=True)


def cmd_ci(args: argparse.Namespace) -> int:
    event = os.environ.get("GITHUB_EVENT_NAME", "")
    try:
        resolved = resolve_ci_range(
            args.repo,
            event,
            pr_base=os.environ.get("PR_BASE", ""),
            pr_head=os.environ.get("PR_HEAD", ""),
            push_before=os.environ.get("PUSH_BEFORE", ""),
            push_after=os.environ.get("PUSH_AFTER", ""),
            default_branch=os.environ.get("DEFAULT_BRANCH", "master"),
        )
        if resolved is None:
            print("checked 0 file(s)")
            return 0
        base, head = resolved
        listed = git_bytes(args.repo, "diff", "--name-only", "-z", "--diff-filter=ACMR", base, head)
        if listed.returncode != 0:
            detail = listed.stderr.decode("utf-8", "replace").strip() or "git diff failed"
            raise CheckerError(detail)
        paths = z_paths(listed.stdout)
        findings: list[str] = []
        for path in paths:
            findings.extend(_blob_findings(args.repo, path, f"{head}:{path}"))
    except CheckerError as exc:
        print(f"ci: {exc}", file=sys.stderr)
        return 2
    return report(findings, len(paths), quiet_ok=False)


def cmd_paths(args: argparse.Namespace) -> int:
    findings: list[str] = []
    root = args.repo
    for path in args.paths:
        full = path if os.path.isabs(path) else os.path.join(root, path)
        try:
            data = open(full, "rb").read()
        except OSError as exc:
            print(f"paths: {exc}", file=sys.stderr)
            return 2
        findings.extend(scan_bytes(path, data))
    return report(findings, len(args.paths), quiet_ok=False)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="cmd", required=True)

    pre_commit = sub.add_parser("pre-commit", help="check staged tracked files")
    pre_commit.add_argument("--repo", default=".")
    pre_commit.set_defaults(func=cmd_pre_commit)

    ci = sub.add_parser("ci", help="check files changed in the GitHub Actions range")
    ci.add_argument("--repo", default=".")
    ci.set_defaults(func=cmd_ci)

    paths = sub.add_parser("paths", help="check specific worktree files")
    paths.add_argument("paths", nargs="+")
    paths.add_argument("--repo", default=".")
    paths.set_defaults(func=cmd_paths)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
