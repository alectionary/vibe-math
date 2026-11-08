"""Check that a replication PR description links the built primary PDF.

The description needs two GitHub blob links to the delivery record's primary
PDF. One is reviewable now: its ref is a 40-hex commit or the head branch.
The other uses master for that same path. This does not fetch either URL.
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

_BLOB = re.compile(
    r'https://github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/blob/([^\s<>)\]"\']+)',
    re.I)
_SHA = re.compile(r'^[0-9a-f]{40}$')


def _toplevel(root):
    completed = subprocess.run(
        ['git', '-C', str(root), 'rev-parse', '--show-toplevel'],
        check=False, capture_output=True, text=True)
    if completed.returncode != 0:
        return None
    return Path(completed.stdout.strip()).resolve()


def primary_repo_path(record, root):
    """Repository path of the delivery record's primary PDF."""
    if not isinstance(record, dict):
        raise ValueError('delivery record required')
    primary = record.get('primary')
    rel = primary.get('path') if isinstance(primary, dict) else None
    if not isinstance(rel, str) or not rel.strip():
        raise ValueError('primary PDF path required')
    parts = Path(rel).parts
    if rel.startswith('/') or any(part in ('', '.', '..') for part in parts):
        raise ValueError('primary PDF path required')
    if not rel.endswith('.pdf'):
        raise ValueError('primary PDF path required')
    study = Path(root).resolve()
    full = (study / rel).resolve()
    top = _toplevel(study)
    if top is not None:
        try:
            return full.relative_to(top).as_posix()
        except ValueError:
            raise ValueError('primary PDF path is outside the repository') from None
    return Path(rel).as_posix()


def description_errors(body, record, root, head_branch=None):
    """Return failures for a missing reviewable link, master link, or path mismatch."""
    try:
        expected = primary_repo_path(record, root)
    except (TypeError, ValueError, OSError):
        return ['pr: delivery record primary PDF path required']
    if not isinstance(body, str) or not body.strip():
        return ['pr: description text required']
    repository = record.get('repository') if isinstance(record, dict) else None
    head = head_branch.strip() if isinstance(head_branch, str) else ''
    reviewable = False
    master = False
    for match in _BLOB.finditer(body):
        owner, repo, tail = match.group(1), match.group(2), match.group(3).rstrip('.,;:')
        if isinstance(repository, str) and repository and f'{owner}/{repo}'.lower() != repository.lower():
            continue
        if tail != expected and not tail.endswith('/' + expected):
            continue
        ref = tail[: -len(expected)].rstrip('/')
        if ref == 'master':
            master = True
        elif _SHA.fullmatch(ref) or (head and ref == head):
            reviewable = True
    errors = []
    if not reviewable:
        errors.append('pr: reviewable primary PDF link required')
    if not master:
        errors.append('pr: master primary PDF link required')
    return errors


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--body', help='PR description file. Stdin is used when omitted.')
    parser.add_argument('--record', required=True, help='Delivery record JSON.')
    parser.add_argument('--root', required=True, help='Study directory inside the repository.')
    parser.add_argument('--head-branch', help='Head branch accepted in place of a 40-hex pin.')
    args = parser.parse_args(argv)
    if args.body:
        body = Path(args.body).read_text(encoding='utf-8')
    else:
        body = sys.stdin.read()
    record = json.loads(Path(args.record).read_text(encoding='utf-8'))
    errors = description_errors(body, record, args.root, head_branch=args.head_branch)
    json.dump({'accepted': not errors, 'errors': errors}, sys.stdout, indent=2)
    sys.stdout.write('\n')
    return 0 if not errors else 2


if __name__ == '__main__':
    sys.exit(main())
