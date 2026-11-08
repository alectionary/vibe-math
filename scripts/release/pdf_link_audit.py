#!/usr/bin/env python3
"""Audit the repository links in a built PDF against the repository itself.

  pdf_link_audit.py PAPER.pdf --repo OWNER/NAME [--git-dir DIR] [--default-ref HEAD]

For every link annotation into https://github.com/OWNER/NAME/(blob|tree)/REF/PATH[#Ln]:
  * REF = master/main or a branch name is checked at --default-ref (the revision that
    will become the default branch, normally HEAD before merging);
  * REF = a 40-hex commit is checked at that commit;
  * the path must exist with the right type (file for blob, directory for tree);
  * a #Ln anchor must be inside the file;
  * when the same path and line are linked both on the default branch and at a pinned
    commit, the anchored line must have the same text at both, so the two links show
    the same declaration.
Exit 0 when every link passes, 1 otherwise. Other links are listed but not checked.
Uses pypdf; replication-paper's pdf_links.py (PyMuPDF) is the stricter tool for
replication deliveries. Part of the verified-release skill.
"""
import argparse, re, subprocess, sys
from collections import defaultdict


def annotations(pdf):
    import pypdf
    reader = pypdf.PdfReader(pdf)
    for number, page in enumerate(reader.pages, 1):
        for annot in page.get('/Annots') or []:
            action = annot.get_object().get('/A')
            if action and '/URI' in action:
                yield number, str(action['/URI'])


def git(git_dir, *args):
    return subprocess.run(['git', '-C', git_dir, *args], capture_output=True, text=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('pdf')
    ap.add_argument('--repo', required=True)
    ap.add_argument('--git-dir', default='.')
    ap.add_argument('--default-ref', default='HEAD')
    a = ap.parse_args()
    pattern = re.compile(r'https://github\.com/' + re.escape(a.repo) + r'/(blob|tree)/([^#]*?)(?:/(.*?))?(?:#L(\d+))?$', re.I)
    failures, checked, other = [], 0, 0
    lines_at = defaultdict(dict)
    cache = {}
    for page, uri in annotations(a.pdf):
        m = pattern.match(uri)
        if not m:
            other += 1
            continue
        kind, ref_and_path, _, anchor = m.group(1), m.group(2), m.group(3), m.group(4)
        # split REF from PATH: a 40-hex commit, or a known branch-like prefix
        parts = ref_and_path.split('/') + ([m.group(3)] if m.group(3) else [])
        parts = '/'.join(parts).split('/')
        if re.fullmatch(r'[0-9a-f]{40}', parts[0]):
            rev, path, pinned = parts[0], '/'.join(parts[1:]), True
        else:
            # longest branch name that exists on the remote or locally; default to first component
            rev, path, pinned = a.default_ref, None, False
            for k in range(len(parts), 0, -1):
                name = '/'.join(parts[:k])
                if name in ('master', 'main') or git(a.git_dir, 'rev-parse', '--verify', '-q', f'refs/remotes/origin/{name}').returncode == 0:
                    path = '/'.join(parts[k:])
                    break
            if path is None:
                path = '/'.join(parts[1:])
        checked += 1
        key = (rev, path)
        if key not in cache:
            t = git(a.git_dir, 'cat-file', '-t', f'{rev}:{path}' if path else f'{rev}^{{tree}}').stdout.strip()
            text = git(a.git_dir, 'show', f'{rev}:{path}').stdout.split('\n') if t == 'blob' else None
            cache[key] = (t or 'missing', text)
        t, text = cache[key]
        want = 'blob' if kind == 'blob' else 'tree'
        if t != want:
            failures.append(f'p{page}: {uri}: expected {want}, found {t}')
            continue
        if anchor:
            n = int(anchor)
            if n > len(text):
                failures.append(f'p{page}: {uri}: line {n} beyond end ({len(text)} lines)')
                continue
            lines_at[(path, n)]['pinned' if pinned else 'default'] = (uri, text[n - 1])
    for (path, n), seen in lines_at.items():
        if len(seen) == 2 and seen['pinned'][1] != seen['default'][1]:
            failures.append(f'{path}#L{n}: default-branch and pinned lines differ: '
                            f'{seen["default"][1].strip()!r} vs {seen["pinned"][1].strip()!r}')
    for f in failures:
        print('FAIL', f)
    print(f'{checked} repository links checked, {len(failures)} failures, {other} other links not checked')
    sys.exit(1 if failures else 0)


if __name__ == '__main__':
    main()
