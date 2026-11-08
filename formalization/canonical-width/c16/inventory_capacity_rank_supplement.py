#!/usr/bin/env python3
"""Add newly exported rank rows to an immutable accepted closure."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
import ast
import gzip
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BASE = 'two-basis-results/owner-flow-capacity-zero-face-inventory.json'
OUT = 'two-basis-results/joint-capacity-rank-closure-supplement.json'

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    assert not (ROOT/OUT).exists()
    base = json.loads((ROOT/BASE).read_text())
    assert not base['binding_mismatches'] and not base['missing_bound_files']
    inherited = base['files']
    names = set()
    for directory, _, files in os.walk(ROOT):
        names.update(str((Path(directory)/name).relative_to(ROOT)) for name in files)
    pending = [BASE, str(Path(__file__).relative_to(ROOT)),
               'inventory_capacity_rank_cohort.py',
               'TWO-PROBE-FOUR-FACE-NEXT-GATE.md',
               'two-basis-results/joint-capacity-closed-rank-replay.json',
               'two-basis-results/joint-capacity-inventory-timeout.json',
               'two-basis-results/joint-capacity-inventory.log']
    pending.extend(str(p.relative_to(ROOT)) for p in
                   (ROOT/'two-basis-results').glob('joint-capacity-point22-*-closed-rank-bank*'))
    seen, added, checked, external = set(), {}, set(), {}

    def local(value):
        if not isinstance(value, str) or len(value) > 4096 or '\n' in value:
            return None
        p = Path(os.path.normpath(value))
        if p.is_absolute():
            if p.is_relative_to(ROOT): value = str(p.relative_to(ROOT))
            else: return None
        else: value = str(p)
        return value if value in names else None

    def enqueue(value, expected=None):
        name = local(value)
        if name:
            if expected is not None:
                assert sha(ROOT/name) == expected, name
                checked.add(name)
            pending.append(name)
        elif isinstance(value, str) and value.startswith('/') and len(value) < 4096:
            p = Path(value)
            if p.is_file():
                digest = sha(p)
                if expected is not None: assert digest == expected
                external[value] = dict(sha256=digest, bytes=p.stat().st_size)

    def walk(value):
        if isinstance(value, dict):
            for key, item in value.items():
                ishash = isinstance(item, str) and len(item) == 64 and all(c in '0123456789abcdef' for c in item)
                enqueue(key, item if ishash else None)
                if isinstance(key, str) and key.endswith('_sha256'):
                    partner = value.get(key[:-7])
                    if isinstance(partner, str): enqueue(partner, item)
                walk(item)
        elif isinstance(value, list):
            for item in value: walk(item)
        else: enqueue(value)

    while pending:
        name = pending.pop()
        if name in seen: continue
        seen.add(name)
        p = ROOT/name
        digest = sha(p)
        if name in inherited:
            assert inherited[name]['sha256'] == digest, name
            checked.add(name)
            continue
        added[name] = dict(sha256=digest, bytes=p.stat().st_size)
        if name == BASE: continue  # Immutable inherited closure is bound above.
        if name.endswith('.json') or name.endswith('.json.gz'):
            walk(json.loads(gzip.decompress(p.read_bytes()) if name.endswith('.gz') else p.read_bytes()))
        if name.endswith('.py'):
            for node in ast.walk(ast.parse(p.read_text())):
                if isinstance(node, ast.Constant): enqueue(node.value)
                modules = ([node.module] if isinstance(node, ast.ImportFrom) else
                           [v.name for v in node.names] if isinstance(node, ast.Import) else [])
                for module in modules:
                    if module: enqueue(module.split('.')[0]+'.py')
    output = dict(status='FROZEN_ADDITIVE_CAPACITY_RANK_SOURCE_DATA_CLOSURE',
                  inherited_inventory=BASE, inherited_inventory_sha256=sha(ROOT/BASE),
                  inherited_file_count=len(inherited), additional_files=added,
                  additional_file_count=len(added),
                  additional_bytes=sum(v['bytes'] for v in added.values()),
                  existing_dependencies_rechecked=sorted(checked),
                  external_file_dependencies=external, nice=19,
                  source_C16_answered=False, no_new_solve=True,
                  producer_sha256=sha(__file__))
    (ROOT/OUT).write_text(json.dumps(output, indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k not in
                      ('additional_files','existing_dependencies_rechecked','external_file_dependencies')}))

if __name__ == '__main__': main()
