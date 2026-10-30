#!/usr/bin/env python3
"""Source/data closure for exact joint extraction and one completed cohort.

Includes LP, primal, dual and basis text files when referenced; no suffix filter
silently drops new exact-solver artifacts. External files are listed
separately and retain their hashes, rather than masquerading as repository data.
"""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
import argparse
import ast
from collections import Counter
import gzip
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p = Path(p)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_bytes())

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--prefix', type=Path, required=True)
    ap.add_argument('--extra-seed', action='append', default=[])
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    assert not a.output.exists()
    report = read(str(a.prefix)+'.json')
    assert report['status'] == 'BOUNDED_EXACT_JOINT_SEPARATION_COHORT_FINISHED'
    rank_report = read(report['rank_batch'])
    assert rank_report['status'] in ['ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED',
                                    'BOUNDED_TWO_SECTOR_GATE_STOPPED']
    pending, seen, external, checks = [], set(), {}, []

    def path_for(value):
        if not isinstance(value, str) or len(value) > 4096 or '\n' in value:
            return None
        p = Path(value)
        if not p.is_absolute(): p = ROOT/p
        try:
            return p.resolve() if p.is_file() else None
        except OSError:
            return None

    def candidate(value):
        p = path_for(value)
        if p is None: return
        if p.is_relative_to(ROOT):
            name = str(p.relative_to(ROOT))
            if name not in seen: pending.append(name)
        else:
            external[str(p)] = dict(path=str(p), sha256=sha(p), bytes=p.stat().st_size)

    def walk(value):
        if isinstance(value, dict):
            for k, v in value.items():
                candidate(k)
                p = path_for(k)
                if p and isinstance(v, str) and len(v) == 64 and all(c in '0123456789abcdef' for c in v):
                    assert sha(p) == v, p
                    checks.append(str(p))
                if isinstance(k, str) and k.endswith('_sha256'):
                    p = path_for(value.get(k.removesuffix('_sha256')))
                    if p:
                        assert sha(p) == v, p
                        checks.append(str(p))
                walk(v)
        elif isinstance(value, list):
            for item in value: walk(item)
        else: candidate(value)

    for pattern in [a.prefix.name+'*', 'joint-soplex0-sector-point22*',
                    'joint-fixed-star-soplex0-point22*']:
        for p in a.prefix.parent.glob(pattern):
            if p.is_file(): candidate(str(p))
    for seed in [__file__, *a.extra_seed]: candidate(seed)
    while pending:
        name = pending.pop()
        if name in seen: continue
        seen.add(name)
        assert len(seen) < 10000
        p = ROOT/name
        if p.suffix == '.py':
            for node in ast.walk(ast.parse(p.read_text())):
                if isinstance(node, ast.Constant): candidate(node.value)
                modules = ([node.module] if isinstance(node, ast.ImportFrom) else
                           [v.name for v in node.names] if isinstance(node, ast.Import) else [])
                for module in modules:
                    if module: candidate(module.split('.')[0]+'.py')
        if p.suffix == '.json' or name.endswith('.json.gz'):
            walk(read(p))
            stem = name.removesuffix('.json.gz').removesuffix('.json')
            candidate(stem+'.frozen.json')
    files = [dict(path=n, sha256=sha(ROOT/n), bytes=(ROOT/n).stat().st_size)
             for n in sorted(seen)]
    star = read(report['star_bank'])
    receipt = read(report['star_receipt'])
    assert receipt['bank_sha256'] == sha(report['star_bank'])
    out = dict(status='FROZEN_EXACT_JOINT_SEPARATION_SOURCE_DATA_CLOSURE',
               source_root=str(ROOT), source_data_closure=files,
               total_files=len(files), total_bytes=sum(r['bytes'] for r in files),
               external_file_dependencies=list(external.values()),
               existing_file_hash_bindings_checked=len(checks),
               cohort_report_sha256=sha(str(a.prefix)+'.json'),
               star_probes=star['probes_checked'], star_cuts=len(star['cuts']),
               rank_patterns=len(rank_report['outcomes']),
               rank_counts=dict(Counter(r['solver_status'] for r in rank_report['outcomes'])),
               exact_values_preserved=True, automatic_repair_performed=False,
               source_C16_answered=False, fixed_allocation_only=True,
               nice=19, producer_sha256=sha(__file__))
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: v for k, v in out.items()
                      if k not in ['source_data_closure', 'external_file_dependencies']}))

if __name__ == '__main__': main()
