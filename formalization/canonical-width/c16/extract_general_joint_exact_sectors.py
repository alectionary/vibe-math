#!/usr/bin/env python3
"""Exact pinned-general joint allocation -> existing narrower sector schemas.

Copies rational strings without rounding. Child records check the older 4229
listed ranks, not all parent ranks or star rows; the parent proof remains bound.
Only the same exact pinned law/point as each supplied old config is supported.
"""
import os
assert os.nice(0) == 19, 'verified nice19 required before imports'
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import hashlib
import json
import time
from verify_two_sided_full_basis_oracle import target

ROOT = Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p = Path(p)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_bytes())
def rankkey(r):
    return (r['mask'], tuple(r['forced_zero_indices']), tuple(r['indices']), r['contraction_rank'])
def merged(*maps):
    out = {}
    for data in maps:
        for key, value in data.items():
            assert key not in out or out[key] == value
            assert sha(ROOT/key) == value
            out[key] = value
    return out

def main():
    ap = argparse.ArgumentParser()
    for name in ['joint', 'receipt', 'point', 'X-config', 'Z-config', 'prefix']:
        ap.add_argument('--'+name, type=Path, required=True)
    a = ap.parse_args(); start = time.monotonic()
    c, r = read(a.joint), read(a.receipt)
    assert c['status'] == 'EXACT_GENERAL_JOINT_ALLOCATION_REQUIRES_REPLAY'
    assert r['status'] == 'PASS_EXACT_LITERAL_GENERAL_JOINT_ALLOCATION'
    assert r['consumer_sha256'] == sha(ROOT/'verify_joint_general_literal.py')
    assert r['certificate_sha256'] == sha(a.joint)
    assert c['point_sha256'] == r['point_sha256'] == sha(a.point)
    assert c['zero_tau_pins'] is r['zero_tau_pins'] is True
    manifest = read(c['manifest'])
    assert c['manifest_sha256'] == r['manifest_sha256'] == sha(c['manifest'])
    assert c['semantic_sha256'] == r['semantic_sha256'] == sha(manifest['semantic'])
    saved = read(manifest['semantic']); model = saved['model']
    assert saved['zero_tau_pins'] is True
    assert model['point_sha256'] == sha(a.point)
    parent_scope = dict(rank_rows=r['rank_rows_checked'], star_rows=r['star_rows_checked'],
                        zero_tau_pins=True, finite_listed_relaxation_only=True)
    full = target(a.point, model['X_anchors'], model['Z_anchors'])
    outputs = []
    for side in ['X', 'Z']:
        oldp = getattr(a, side+'_config'); old = read(oldp)
        assert old['side'] == side and old['point_sha256'] == sha(a.point)
        assert old['X_anchors'] == model['X_anchors'] and old['Z_anchors'] == model['Z_anchors']
        assert old['lambda_masses'] == c['lambda_masses']
        assert {rankkey(row) for row in old['rank_rows']} <= {
            rankkey(row) for row in model['sectors'][side]['rank_rows']}
        source = merged(old['source_hashes'], model['source_hashes'], r['source_hashes'],
                        r['dependencies'], c['source_bindings'])
        for p in [a.joint, a.receipt, a.point, oldp, Path(c['manifest']),
                  Path(manifest['semantic']), Path(__file__), ROOT/'verify_joint_general_literal.py']:
            p = p.resolve(); assert p.is_relative_to(ROOT)
            key = str(p.relative_to(ROOT))
            assert key not in source or source[key] == sha(p)
            source[key] = sha(p)
        y = c['exact_allocations'][side]
        assert len(y) == 16 and all(len(row) == 720 for row in y)
        assert all(type(v) is str and str(Q(v)) == v for row in y for v in row)
        lam = list(map(Q, old['lambda_masses']))
        slacks = [lam[row['mask']]*row['contraction_rank']-
                  sum(Q(y[row['mask']][j]) for j in row['indices']) for row in old['rank_rows']]
        assert min(slacks) >= 0
        child_scope = dict(rank_rows=len(slacks), star_rows=0,
                           narrower_than_parent=True,
                           note='Old sector schema checks only its listed ranks; parent proof remains independently bound.')
        frozen = dict(old, status='FROZEN_EXACT_SECTOR_EXTRACTION_FROM_GENERAL_JOINT',
            source_hashes=source, joint_certificate=str(a.joint), joint_certificate_sha256=sha(a.joint),
            joint_receipt=str(a.receipt), joint_receipt_sha256=sha(a.receipt),
            joint_manifest=c['manifest'], joint_manifest_sha256=sha(c['manifest']),
            joint_semantic=manifest['semantic'], joint_semantic_sha256=sha(manifest['semantic']),
            parent_scope=parent_scope, child_scope=child_scope,
            extraction='Exact copy of all rational strings; no rounding, reduction, or repair')
        prefix = Path(str(a.prefix)+'-'+side)
        fp, cp = Path(str(prefix)+'.frozen.json'), Path(str(prefix)+'.json.gz')
        assert not fp.exists() and not cp.exists()
        fp.write_text(json.dumps(frozen, indent=2)+'\n')
        off = 720*int(side == 'Z')
        b = full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)]
        out = dict(status='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY', frozen_sha256=sha(fp),
            joint_certificate_sha256=sha(a.joint), joint_receipt_sha256=sha(a.receipt),
            exact_allocations=y, sector_target=list(map(str, b)), prior_rank_row_count=len(slacks),
            exact_rank_failures=[], exact_box_failures=[], minimum_exact_rank_slack=str(min(slacks)),
            parent_scope=parent_scope, child_scope=child_scope, rounding_performed=False,
            source_C16_answered=False)
        cp.write_bytes(gzip.compress((json.dumps(out, indent=2)+'\n').encode(), mtime=0))
        outputs.append(dict(side=side, certificate=str(cp), certificate_sha256=sha(cp),
                            frozen_sha256=sha(fp), child_rank_rows=len(slacks)))
    report = Path(str(a.prefix)+'-extraction.json'); assert not report.exists()
    report.write_text(json.dumps(dict(status='EXACT_GENERAL_JOINT_SECTOR_EXTRACTION_REQUIRES_REPLAY',
        producer_sha256=sha(__file__), joint_certificate_sha256=sha(a.joint), outputs=outputs,
        rational_values_copied=23040, rounding_performed=False, parent_scope=parent_scope,
        total_child_rank_rows=sum(x['child_rank_rows'] for x in outputs),
        nice=os.nice(0), elapsed_seconds=time.monotonic()-start, source_C16_answered=False), indent=2)+'\n')
    print(report.read_text(), flush=True)

if __name__ == '__main__': main()
