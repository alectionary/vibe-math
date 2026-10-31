#!/usr/bin/env python3
"""Reassemble large compressed proof files from lossless size-limited chunks."""
from pathlib import Path
import argparse
import hashlib
import json


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--manifest', type=Path, required=True)
    a = p.parse_args()
    for record in json.loads(a.manifest.read_text())['records']:
        chunks = []
        for part in record['parts']:
            raw = (a.manifest.parent/part['file']).read_bytes()
            assert digest(raw) == part['sha256'] and len(raw) == part['bytes']
            chunks.append(raw)
        data = b''.join(chunks)
        assert digest(data) == record['sha256'] and len(data) == record['bytes']
        output = a.manifest.parent/record['file']
        if output.exists():
            assert output.read_bytes() == data
        else:
            output.write_bytes(data)
        print(output.name, record['sha256'], flush=True)


if __name__ == '__main__':
    main()
