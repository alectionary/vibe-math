#!/usr/bin/env python3
"""Reject consumer-domain and hostname-derived addresses on new commits.

The check covers the author email, the committer email, and every address in
the commit message, including trailers such as Co-authored-by and
Signed-off-by. Noreply addresses are allowed on a real mail domain, including
GitHub's noreply@github.com committer on web merges and users.noreply.github.com.
A noreply local part does not allow a hostname-derived domain.

Hostname-derived means a single-label host (Git's user@hostname fallback), a
domain whose last label is local, lan, home, localdomain, or internal, or a
domain that names a Mac machine. Only the requested range is read. Published
history is not scanned.

Usage:
  python3 scripts/check_commit_emails.py commit-msg --message-file PATH \\
      --author-ident "$(git var GIT_AUTHOR_IDENT)" \\
      --committer-ident "$(git var GIT_COMMITTER_IDENT)"
  python3 scripts/check_commit_emails.py range BASE..HEAD
  python3 scripts/check_commit_emails.py pre-push --remote-name origin
  python3 scripts/check_commit_emails.py ci
"""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys

EXACT_DOMAINS = frozenset(
    {
        "gmail.com",
        "googlemail.com",
        "msn.com",
        "icloud.com",
        "me.com",
        "aol.com",
        "proton.me",
        "protonmail.com",
    }
)
# hotmail.*, outlook.*, live.*, yahoo.* — the label, not a longer word.
WILDCARD_LABELS = frozenset({"hotmail", "outlook", "live", "yahoo"})

# A following period is sentence punctuation, not part of the domain.
# The final label may be a bare host with no dot.
EMAIL_RE = re.compile(
    r"(?<![A-Za-z0-9._%+\-])"
    r"([A-Za-z0-9](?:[A-Za-z0-9._%+\-]{0,62}[A-Za-z0-9])?)"
    r"@"
    r"((?:[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?\.)*"
    r"[A-Za-z0-9](?:[A-Za-z0-9\-]{0,61}[A-Za-z0-9])?)"
    r"(?![A-Za-z0-9\-])"
)
# Built by concatenation so this file does not itself contain a machine name.
_LABEL_A = "mac" + "book"
_LABEL_B = "i" + "mac"
_LABEL_C = "mac" + "mini"
HOST_SUFFIXES = frozenset({"local", "lan", "home", "localdomain", "internal"})
TRAILER_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9-]*:")
IDENT_RE = re.compile(r"<([^<>]+)>")


class CheckerError(Exception):
    """The range could not be checked. The message has no email address."""


def split_email(email: str) -> tuple[str, str]:
    text = email.strip().lower()
    if text.startswith("<") and text.endswith(">"):
        text = text[1:-1].strip()
    if "@" not in text:
        return "", ""
    local, domain = text.rsplit("@", 1)
    return local.strip(), domain.rstrip(".").strip()


def is_noreply(email: str) -> bool:
    """True for a noreply mailbox or a GitHub noreply domain."""
    local, domain = split_email(email)
    if not local or not domain:
        return False
    base = local.split("+", 1)[0]
    if base == "noreply":
        return True
    return domain == "noreply.github.com" or domain.endswith(".noreply.github.com")


def is_consumer_domain(domain: str) -> bool:
    domain = domain.lower().rstrip(".")
    if not domain or "." not in domain:
        return False
    if domain in EXACT_DOMAINS:
        return True
    for exact in EXACT_DOMAINS:
        if domain.endswith("." + exact):
            return True
    labels = domain.split(".")
    return any(label in WILDCARD_LABELS for label in labels[:-1])


def is_hostname_domain(domain: str) -> bool:
    """True when a domain is a machine hostname rather than a public mailbox.

    A bare host has a single label and no real top-level domain. Special-use
    suffixes are matched only as the last label. Machine-name labels are
    matched from the parts assembled above.
    """
    domain = domain.lower().rstrip(".")
    if not domain or not any(ch.isalpha() for ch in domain):
        return False
    labels = [label for label in domain.split(".") if label]
    if not labels:
        return False
    if len(labels) == 1:
        return len(labels[0]) >= 2
    if labels[-1] in HOST_SUFFIXES:
        return True
    for index, label in enumerate(labels):
        if _LABEL_A in label:
            return True
        pieces = label.split("-")
        if _LABEL_B in pieces or _LABEL_C in pieces or ("mac" in pieces and "mini" in pieces):
            return True
        if label == "mac" and index + 1 < len(labels) and labels[index + 1] == "mini":
            return True
    return False


def block_reason(email: str) -> str | None:
    """Return why an address is rejected, or None when it is allowed."""
    local, domain = split_email(email)
    if not local or not domain:
        return None
    if is_hostname_domain(domain):
        return "hostname-derived"
    if is_noreply(email):
        return None
    if is_consumer_domain(domain):
        return "consumer-domain"
    return None


def is_blocked_email(email: str) -> bool:
    return block_reason(email) is not None


def email_from_ident(ident: str) -> str:
    match = IDENT_RE.search(ident or "")
    if not match or "@" not in match.group(1):
        raise CheckerError("could not parse an email address from the git ident")
    return match.group(1).strip()


def message_hits(message: str) -> list[tuple[str, str, int]]:
    """Blocked addresses in a message, as (trailer|message, email, line)."""
    hits: list[tuple[str, str, int]] = []
    seen: set[str] = set()
    lines = message.splitlines()
    for match in EMAIL_RE.finditer(message):
        email = f"{match.group(1)}@{match.group(2)}"
        key = email.lower()
        if key in seen:
            continue
        seen.add(key)
        if not is_blocked_email(email):
            continue
        line_no = message[: match.start()].count("\n") + 1
        line = lines[line_no - 1] if line_no <= len(lines) else ""
        kind = "trailer" if TRAILER_RE.match(line.strip()) else "message"
        hits.append((kind, email, line_no))
    return hits


def _address_phrase(reason: str) -> str:
    if reason == "hostname-derived":
        return "a hostname-derived address"
    return "a consumer-domain address"


def _role_phrase(reason: str, role: str) -> str:
    if reason == "hostname-derived":
        return f"{role} email is hostname-derived"
    return f"{role} email uses a consumer domain"


def commit_errors(label: str, author: str, committer: str, message: str) -> list[str]:
    errors: list[str] = []
    for role, email in (("author", author), ("committer", committer)):
        reason = block_reason(email)
        if reason:
            errors.append(f"{label}: {_role_phrase(reason, role)} ({email})")
    for kind, email, line_no in message_hits(message):
        where = "trailer" if kind == "trailer" else "message"
        reason = block_reason(email) or "consumer-domain"
        errors.append(
            f"{label}: {where} contains {_address_phrase(reason)} ({email}) at line {line_no}"
        )
    return errors


def git(repo: str, *args: str, input_text: str | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "-C", repo, *args],
        input=input_text,
        capture_output=True,
        text=True,
        check=False,
    )


def commit_exists(repo: str, rev: str) -> bool:
    if not rev:
        return False
    result = git(repo, "cat-file", "-e", f"{rev}^{{commit}}")
    return result.returncode == 0


def load_commit(repo: str, sha: str) -> tuple[str, str, str]:
    result = git(repo, "show", "-s", "--format=%ae%x00%ce%x00%B", sha)
    if result.returncode != 0:
        raise CheckerError(result.stderr.strip() or f"cannot read commit {sha}")
    author, committer, message = result.stdout.split("\x00", 2)
    return author.strip(), committer.strip(), message


def rev_list(repo: str, *args: str, input_text: str | None = None) -> list[str]:
    result = git(repo, "rev-list", *args, input_text=input_text)
    if result.returncode != 0:
        raise CheckerError(result.stderr.strip() or "git rev-list failed")
    return [line for line in result.stdout.splitlines() if line]


def check_shas(repo: str, shas: list[str]) -> list[str]:
    errors: list[str] = []
    for sha in shas:
        author, committer, message = load_commit(repo, sha)
        errors.extend(commit_errors(sha, author, committer, message))
    return errors


def is_zero_sha(sha: str) -> bool:
    return bool(sha) and set(sha) == {"0"}


def commits_in_push(repo: str, remote_name: str, lines: list[str]) -> list[str]:
    """Commits introduced by a pre-push stdin listing.

    An update uses remote..local. A new ref excludes every tip already stored
    under refs/remotes/<remote>, so commits that are already published are not
    checked again.
    """
    ordered: list[str] = []
    seen: set[str] = set()
    for raw in lines:
        parts = raw.split()
        if len(parts) != 4:
            continue
        _local_ref, local_sha, _remote_ref, remote_sha = parts
        if is_zero_sha(local_sha):
            continue
        if is_zero_sha(remote_sha):
            tips = rev_list_excludes(repo, remote_name)
            found = rev_list(repo, "--stdin", input_text=_exclude_input(local_sha, tips))
        else:
            found = rev_list(repo, f"{remote_sha}..{local_sha}")
        for sha in found:
            if sha not in seen:
                seen.add(sha)
                ordered.append(sha)
    return ordered


def rev_list_excludes(repo: str, remote_name: str) -> list[str]:
    result = git(repo, "for-each-ref", "--format=%(objectname)", f"refs/remotes/{remote_name}")
    if result.returncode != 0:
        raise CheckerError(result.stderr.strip() or "git for-each-ref failed")
    tips = [line for line in result.stdout.splitlines() if line]
    if not tips:
        raise CheckerError(
            f"pre-push: {remote_name} has no remote-tracking refs; "
            "fetch it first so already-published history is not rechecked"
        )
    return tips


def _exclude_input(local_sha: str, excludes: list[str]) -> str:
    return local_sha + "\n" + "".join(f"^{sha}\n" for sha in excludes)


def merge_base_default(repo: str, head: str, default_branch: str) -> str:
    for candidate in (f"origin/{default_branch}", default_branch, f"refs/remotes/origin/{default_branch}"):
        if not commit_exists(repo, candidate):
            continue
        result = git(repo, "merge-base", candidate, head)
        if result.returncode == 0 and result.stdout.strip():
            return result.stdout.strip()
    raise CheckerError(
        f"cannot find {default_branch} to limit the commit range; "
        "fetch the default branch so published history is not rechecked"
    )


def resolve_ci_range(
    repo: str,
    event_name: str,
    *,
    pr_base: str = "",
    pr_head: str = "",
    push_before: str = "",
    push_after: str = "",
    default_branch: str = "master",
) -> tuple[str, str] | None:
    """Return (base, head) for base..head, or None when there is nothing to check.

    pull_request uses the pull request's base and head. A branch push uses
    before..after. A new branch, or a before tip that is not in this clone,
    uses the merge-base with the default branch so published history is excluded.
    Deleting a branch checks nothing.
    """
    if event_name == "pull_request":
        if not pr_base or not pr_head:
            raise CheckerError("pull_request event is missing base or head sha")
        return pr_base, pr_head
    if event_name != "push":
        raise CheckerError(f"unsupported event {event_name}")
    if not push_after or is_zero_sha(push_after):
        return None
    if not push_before or is_zero_sha(push_before) or not commit_exists(repo, push_before):
        return merge_base_default(repo, push_after, default_branch), push_after
    return push_before, push_after


def report(errors: list[str], count: int, *, quiet_ok: bool) -> int:
    if errors:
        print("\n".join(errors), file=sys.stderr)
        print(f"blocked addresses in {len(errors)} place(s) across {count} commit(s)", file=sys.stderr)
        return 1
    if not quiet_ok:
        print(f"checked {count} commit(s)")
    return 0


def cmd_commit_msg(args: argparse.Namespace) -> int:
    try:
        author = email_from_ident(args.author_ident)
        committer = email_from_ident(args.committer_ident)
    except CheckerError as exc:
        print(f"commit-msg: {exc}", file=sys.stderr)
        return 2
    try:
        message = open(args.message_file, encoding="utf-8").read()
    except OSError as exc:
        print(f"commit-msg: {exc}", file=sys.stderr)
        return 2
    errors = commit_errors("this commit", author, committer, message)
    return report(errors, 1, quiet_ok=True)


def cmd_range(args: argparse.Namespace) -> int:
    try:
        shas = rev_list(args.repo, args.rev_range)
        errors = check_shas(args.repo, shas)
    except CheckerError as exc:
        print(f"range: {exc}", file=sys.stderr)
        return 2
    return report(errors, len(shas), quiet_ok=False)


def cmd_pre_push(args: argparse.Namespace) -> int:
    lines = sys.stdin.read().splitlines()
    try:
        shas = commits_in_push(args.repo, args.remote_name, lines)
        errors = check_shas(args.repo, shas)
    except CheckerError as exc:
        print(f"pre-push: {exc}", file=sys.stderr)
        return 2
    return report(errors, len(shas), quiet_ok=False)


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
            print("checked 0 commit(s)")
            return 0
        base, head = resolved
        if not commit_exists(args.repo, base) or not commit_exists(args.repo, head):
            raise CheckerError(f"commit range is not available in this clone ({base}..{head})")
        shas = rev_list(args.repo, f"{base}..{head}")
        errors = check_shas(args.repo, shas)
    except CheckerError as exc:
        print(f"ci: {exc}", file=sys.stderr)
        return 2
    return report(errors, len(shas), quiet_ok=False)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="cmd", required=True)

    commit_msg = sub.add_parser("commit-msg", help="check a commit message and both idents")
    commit_msg.add_argument("--message-file", required=True)
    commit_msg.add_argument("--author-ident", required=True)
    commit_msg.add_argument("--committer-ident", required=True)
    commit_msg.set_defaults(func=cmd_commit_msg)

    rev_range = sub.add_parser("range", help="check commits in a git revision range")
    rev_range.add_argument("rev_range")
    rev_range.add_argument("--repo", default=".")
    rev_range.set_defaults(func=cmd_range)

    pre_push = sub.add_parser("pre-push", help="check ranges from pre-push stdin")
    pre_push.add_argument("--repo", default=".")
    pre_push.add_argument("--remote-name", default="origin")
    pre_push.set_defaults(func=cmd_pre_push)

    ci = sub.add_parser("ci", help="check the GitHub Actions push or pull_request range")
    ci.add_argument("--repo", default=".")
    ci.set_defaults(func=cmd_ci)
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
