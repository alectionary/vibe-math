#!/usr/bin/env python3
"""Copy an accepted exact joint allocation into frozen per-sector schemas.

No optimization, rounding, denominator reduction or value repair is performed.
The existing independent closed-rank consumer still gates each exported sector.
"""
import os
assert os.nice(0)==19, 'verified nice19 required before imports'
from pathlib import Path
from fractions import Fraction as Q
import argparse, gzip, hashlib, json, time
from verify_two_sided_full_basis_oracle import target

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--joint',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();c,r=read(a.joint),read(a.receipt)
    jf=a.joint.with_name(a.joint.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');f=read(jf)
    assert c['status']=='EXACT_JOINT_FIXED_ALLOCATION_REQUIRES_REPLAY'
    assert r['status']=='PASS_EXACT_JOINT_FIXED_ALLOCATION_LISTED_RANK_AND_STAR_ROWS'
    assert r['consumer_sha256']==sha(ROOT/'verify_two_basis_joint_fixed_star.py')
    assert sha(a.joint)==r['certificate_sha256'] and c['frozen_sha256']==r['frozen_sha256']==sha(jf)
    assert sha(a.point)==f['point_sha256']==r['point_sha256']
    assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
    assert all(sha(ROOT/p)==h for p,h in c['source_bindings'].items())
    assert all(sha(ROOT/p)==h for p,h in r['source_hashes'].items())
    full=target(a.point,f['X_anchors'],f['Z_anchors']);outputs=[]
    for side in ['X','Z']:
        oldp=ROOT/f[side.lower()+'_config'];old=read(oldp)
        assert old['point_sha256']==sha(a.point) and old['side']==side
        assert old['lambda_masses']==f['lambda_masses']
        assert all(sha(ROOT/p)==h for p,h in old['source_hashes'].items())
        source={**old['source_hashes'],**f['source_hashes'],**r['source_hashes'],**c['source_bindings']}
        for p in [a.joint,a.receipt,jf,a.point,Path(__file__),ROOT/'verify_two_basis_joint_fixed_star.py']:
            p=p.resolve();assert p.is_relative_to(ROOT);source[str(p.relative_to(ROOT))]=sha(p)
        assert all(sha(ROOT/p)==h for p,h in source.items())
        frozen=dict(old,status='FROZEN_EXACT_SECTOR_EXTRACTION_FROM_JOINT',source_hashes=source,
            joint_certificate=str(a.joint),joint_certificate_sha256=sha(a.joint),
            joint_receipt=str(a.receipt),joint_receipt_sha256=sha(a.receipt),
            joint_frozen=str(jf),joint_frozen_sha256=sha(jf),
            extraction='Exact copy of rational strings; no rounding or repair')
        prefix=Path(str(a.prefix)+'-'+side);fp=Path(str(prefix)+'.frozen.json');cp=Path(str(prefix)+'.json.gz')
        assert not fp.exists() and not cp.exists()
        y=c['exact_allocations'][side];assert len(y)==16 and all(len(row)==720 for row in y)
        assert all(type(v)is str and str(Q(v))==v for row in y for v in row)
        lam=list(map(Q,old['lambda_masses']));slack=[lam[row['mask']]*row['contraction_rank']-sum(Q(y[row['mask']][j]) for j in row['indices']) for row in old['rank_rows']]
        assert min(slack)>=0
        off=720*int(side=='Z');b=full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)]
        fp.write_text(json.dumps(frozen,indent=2)+'\n')
        out=dict(status='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY',frozen_sha256=sha(fp),
            joint_certificate_sha256=sha(a.joint),joint_receipt_sha256=sha(a.receipt),
            exact_allocations=y,sector_target=list(map(str,b)),prior_rank_row_count=len(slack),
            exact_rank_failures=[],exact_box_failures=[],minimum_exact_rank_slack=str(min(slack)),
            rounding_performed=False,source_C16_answered=False)
        cp.write_bytes(gzip.compress((json.dumps(out,indent=2)+'\n').encode(),mtime=0))
        outputs.append(dict(side=side,certificate=str(cp),certificate_sha256=sha(cp),frozen_sha256=sha(fp)))
    report=Path(str(a.prefix)+'-extraction.json');assert not report.exists()
    report.write_text(json.dumps(dict(status='EXACT_JOINT_SECTOR_EXTRACTION_REQUIRES_REPLAY',
        producer_sha256=sha(__file__),joint_certificate_sha256=sha(a.joint),outputs=outputs,
        rational_values_copied=23040,rounding_performed=False,nice=os.nice(0),elapsed_seconds=time.monotonic()-start,
        source_C16_answered=False),indent=2)+'\n');print(report.read_text(),flush=True)
if __name__=='__main__':main()
