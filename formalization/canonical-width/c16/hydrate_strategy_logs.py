#!/usr/bin/env python3
"""Restore losslessly archived theory logs at their frozen metadata paths."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--manifest', type=Path, required=True)
    a = p.parse_args()
    for r in json.loads(a.manifest.read_text())['records']:
        archive = (a.manifest.parent/r['archive_file']).read_bytes()
        assert sha(archive) == r['archive_sha256'] and len(archive) == r['archive_bytes']
        raw = gzip.decompress(archive)
        assert sha(raw) == r['raw_sha256'] and len(raw) == r['raw_bytes']
        destination = a.manifest.parent/r['raw_file']
        if destination.exists():
            assert destination.read_bytes() == raw
        else:
            destination.write_bytes(raw)
        print(destination.name, r['raw_sha256'], flush=True)


if __name__ == '__main__':
    main()
