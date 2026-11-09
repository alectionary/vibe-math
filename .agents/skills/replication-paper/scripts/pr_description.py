"""Check that a replication PR description links the built primary PDF, clickably.

The description needs two links to the delivery record's primary PDF: one
reviewable now (its ref is a 40-hex commit or the head branch) and one on
master for the same path. A link may point at the PDF itself (a GitHub blob,
github.com raw or raw.githubusercontent.com URL) or at the folder that holds
it (a GitHub tree URL), which is one click from the file.

Text checks are not enough: a link can be posted correctly and still be stored
or rendered as code (some posting routes wrap links to PDFs in backticks). So
`--pr N` fetches the pull request as GitHub stores and renders it and requires
every link it counts to be a real anchor in the rendered HTML, and no link to
the primary PDF to sit inside code. Run it after every edit of the description.

    python3 pr_description.py --record delivery-record.json --root STUDY --body pr-body.md
    python3 pr_description.py --record delivery-record.json --root STUDY --pr 90 [--repo owner/repo]
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

_BLOB = re.compile(
    r'https://(?:github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/(blob|raw|tree)/'
    r'|raw\.githubusercontent\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/)([^\s<>)\]"\'`]+)',
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


def primary_links(text, expected, repository=None):
    """Yield (url, ref) for links to the primary PDF or to its folder."""
    folder = expected.rsplit('/', 1)[0]
    for match in _BLOB.finditer(text or ''):
        owner = match.group(1) or match.group(4)
        repo = match.group(2) or match.group(5)
        kind = (match.group(3) or 'raw').lower()
        tail = match.group(6).rstrip('.,;:')
        if isinstance(repository, str) and repository and f'{owner}/{repo}'.lower() != repository.lower():
            continue
        target = folder if kind == 'tree' else expected
        if tail != target and not tail.endswith('/' + target):
            continue
        yield match.group(0).rstrip('.,;:'), tail[: -len(target)].rstrip('/')


def rendered_errors(body, html, record, root):
    """Every counted link must be an <a href> in GitHub's rendering, and none may sit in code."""
    try:
        expected = primary_repo_path(record, root)
    except (TypeError, ValueError, OSError):
        return ['pr: delivery record primary PDF path required']
    repository = record.get('repository') if isinstance(record, dict) else None
    hrefs = set(re.findall(r'<a [^>]*href="([^"]+)"', html or ''))
    errors = []
    for url, _ref in primary_links(body, expected, repository):
        if url not in hrefs:
            errors.append(f'pr: {url} is in the description but is not a clickable link on GitHub')
    for code in re.findall(r'<code[^>]*>(.*?)</code>', html or '', flags=re.S):
        if any(True for _ in primary_links(code, expected, repository)):
            errors.append('pr: a link to the primary PDF is rendered as code, not as a link '
                          '(link the folder instead, or ask the person to add the PDF link in the web editor)')
            break
    return errors


def fetch_pull_request(repo, number):
    """Body and rendered HTML of a pull request, as GitHub stores them (needs gh)."""
    out = subprocess.run(['gh', 'api', f'repos/{repo}/pulls/{number}', '-H',
                          'Accept: application/vnd.github.full+json'],
                         check=True, capture_output=True, text=True).stdout
    data = json.loads(out)
    return data.get('body') or '', data.get('body_html') or ''


def live_errors(repo, number, record, root, head_branch=None):
    body, html = fetch_pull_request(repo, number)
    return description_errors(body, record, root, head_branch=head_branch) + rendered_errors(body, html, record, root)


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
    for match, ref in primary_links(body, expected, repository):
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
    parser.add_argument('--pr', type=int, help='Check the live pull request as GitHub stores and renders it.')
    parser.add_argument('--repo', help='owner/repo for --pr (default: the delivery record repository).')
    args = parser.parse_args(argv)
    record = json.loads(Path(args.record).read_text(encoding='utf-8'))
    if args.pr:
        repo = args.repo or record.get('repository')
        errors = live_errors(repo, args.pr, record, args.root, head_branch=args.head_branch)
        json.dump({'accepted': not errors, 'errors': errors}, sys.stdout, indent=2)
        sys.stdout.write('\n')
        return 0 if not errors else 2
    if args.body:
        body = Path(args.body).read_text(encoding='utf-8')
    else:
        body = sys.stdin.read()
    errors = description_errors(body, record, args.root, head_branch=args.head_branch)
    json.dump({'accepted': not errors, 'errors': errors}, sys.stdout, indent=2)
    sys.stdout.write('\n')
    return 0 if not errors else 2


if __name__ == '__main__':
    sys.exit(main())
