#!/usr/bin/env python3
"""Replay a deterministic affine repair and its box obstruction, no solver."""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
from two_basis_replay_paths import RecordedRoot
import argparse, gzip, hashlib, json, time
import numpy as np
from verify_two_sided_full_basis_oracle import physical_source, domains, target

ROOT=Path(__file__).resolve().parent
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def feature(y):
    return [sum(y[m][j] for m in range(16)) for j in range(720)]+[sum(y[m][j] for m in range(16) if m>>i&1) for i in range(4) for j in range(720)]
def affine(y,lam,dd):
    for m,d in enumerate(dd):
        assert sum(y[m])==128*lam[m]
        allowed=set(d['zero_forced'])|set(d['zero_free'])|{j for bucket in d['bins'] for j in bucket}
        for j in range(720):
            if j not in allowed: assert y[m][j]==0
            if j in d['forced']: assert y[m][j]==lam[m]
        assert sum(y[m][j] for j in d['zero_forced']+d['zero_free'])==d['zero_required']*lam[m]
        for bucket in d['bins']: assert sum(y[m][j] for j in bucket)==lam[m]
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True)
    ap.add_argument('--recorded-root',type=Path,required=True)
    a=ap.parse_args();paths=RecordedRoot(ROOT,a.recorded_root);assert sha(ROOT/'verify_two_basis_five_pattern_repair.py')=='c2f04df48f0614934d77d0ea7895c0c1edf1c64e85bb2e895415a7ba61c537b3';assert not a.output.exists();start=time.monotonic();c=read(a.certificate)
    assert c['status']=='EXACT_AFFINE_REPAIR_BOX_OBSTRUCTION' and c['point_sha256']==sha(a.point)
    assert c['producer_sha256']==sha(ROOT/'two_basis_structure_five_pattern_repair.py')
    assert all(sha(ROOT/p)==h for p,h in c['dependencies'].items())
    rp,rc=ROOT/c['input_report'],ROOT/c['input_receipt'];r,receipt=read(rp),read(rc)
    assert sha(rp)==c['input_report_sha256']==receipt['report_sha256'] and sha(rc)==c['input_receipt_sha256']
    assert receipt['status']=='PASS_FULL_FIXED_LAMBDA_ENDPOINT_INCONCLUSIVE'
    assert receipt['auditor_sha256']==sha(ROOT/'audit_two_basis_fixed_lambda_endpoint.py')
    archive=paths.resolve(r['columns_artifact']);assert sha(archive)==r['columns_sha256']==receipt['archive_sha256']
    z=np.load(archive);weights=[Q(float(v)) for v in z['master_mixture_weights']];assert min(weights)>=0
    denom=lcm(*(v.denominator for v in weights));W=[int(v*denom) for v in weights];total=sum(W);assert total>0
    lam=list(map(Q,c['lambda_masses']));assert lam==list(map(Q,r['lambda_masses']))
    y=[[Q(0)]*720 for _ in range(16)]
    initial=ROOT/r['initial_atom_source'];assert sha(initial)==r['initial_atom_sha256']
    for record in read(initial)['pattern_basis_records']:
        value=Q(W[0],total)*Q(record['weight'])
        for j in record['selected_indices']: y[record['mask']][j]+=value
    for m in range(16):
        counts=[0]*720
        for k,w in enumerate(W[1:],1):
            if w:
                for j in z['pattern_selected_indices'][k,m]: counts[int(j)]+=w
        y[m]=[value+lam[m]*Q(counts[j],total) for j,value in enumerate(y[m])]
    assert y==[list(map(Q,row)) for row in c['original_allocations']]
    full=target(a.point,c['X_anchors'],c['Z_anchors']);off=720*int(c['side']=='Z')
    b=full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)]
    assert b==list(map(Q,c['sector_target']));old=feature(y);d=[b[i]-old[i] for i in range(3600)]
    repaired=[row[:] for row in y]
    for i in range(4):
        for j in range(720): repaired[1<<i][j]+=d[720*(i+1)+j]
    for j in range(720): repaired[0][j]+=d[j]-sum(d[720*(i+1)+j] for i in range(4))
    assert repaired==[list(map(Q,row)) for row in c['repaired_allocations']] and feature(repaired)==b
    X,Z,_=physical_source();dd=[r[c['side']] for r in domains(X,Z,c['X_anchors'],c['Z_anchors'])]
    affine(y,lam,dd);affine(repaired,lam,dd)
    failures=[]
    for m in range(16):
        low=[j for j in range(720) if repaired[m][j]<0];high=[j for j in range(720) if repaired[m][j]>lam[m]]
        if low or high: failures.append(dict(mask=m,negative_indices=low,above_lambda_indices=high))
    assert sum(len(r['negative_indices'])+len(r['above_lambda_indices']) for r in failures)==c['total_coordinate_box_failures']>0
    for record in c['pattern_screens']:
        m=record['mask'];assert record['negative_indices']==[j for j,v in enumerate(repaired[m]) if v<0]
        assert record['above_lambda_indices']==[j for j,v in enumerate(repaired[m]) if v>lam[m]]
    out=dict(portable_replay=paths.evidence(),frozen_consumer_sha256=sha(ROOT/'verify_two_basis_five_pattern_repair.py'),status='PASS_EXACT_DETERMINISTIC_AFFINE_REPAIR_BOX_FAILURE',certificate_sha256=sha(a.certificate),
        point_sha256=sha(a.point),consumer_sha256=sha(__file__),input_report_sha256=sha(rp),input_receipt_sha256=sha(rc),
        normalized_input_mass=str(Q(total,denom)),exact_allocation_coordinates=11520,exact_target_equations=3600,
        box_failures=failures,total_box_failures=c['total_coordinate_box_failures'],
        minimum_repaired_coordinate=str(min(v for row in repaired for v in row)),
        full_hull_nonmembership_proved=False,source_C16_answered=False,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
