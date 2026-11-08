#!/usr/bin/env python3
"""Write a JSON manifest (path, bytes, SHA-256, Git blob id) for files of a release.

  file_manifest.py OUT.json BASE PATTERN [PATTERN ...]

Paths in the manifest are relative to BASE. PATTERNs are globs relative to BASE
(use ** for recursion). The Git blob id is computed from the bytes, so it can be
compared with `git ls-tree` at the scientific revision without a checkout.
Part of the verified-release skill (.agents/skills/verified-release).
"""
import hashlib, json, sys
from pathlib import Path


def entry(path):
    data = path.read_bytes()
    blob = hashlib.sha1(b'blob %d\0' % len(data) + data).hexdigest()
    return {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest(), 'git_blob': blob}


def main(argv):
    if len(argv) < 4:
        sys.exit(__doc__)
    out, base, patterns = Path(argv[1]), Path(argv[2]).resolve(), argv[3:]
    files = sorted({p for pat in patterns for p in base.glob(pat) if p.is_file()})
    if not files:
        sys.exit('no files matched')
    manifest = {str(p.relative_to(base)): entry(p) for p in files}
    out.write_text(json.dumps(manifest, indent=1) + '\n')
    print(f'{out}: {len(manifest)} files')


if __name__ == '__main__':
    main(sys.argv)
