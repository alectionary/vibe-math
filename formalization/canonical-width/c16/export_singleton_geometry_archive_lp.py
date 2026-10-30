#!/usr/bin/env python3
"""Exact LP text from an independently accepted GEOMETRY_SEED; no solve."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    raw=(ROOT/p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,o):
    p=ROOT/p;assert not p.exists();raw=(json.dumps(o,sort_keys=True,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--seed',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    c,r=read(a.seed),read(a.receipt)
    assert c['status']=='GEOMETRY_SEED' and c['seed_kind']=='LEGACY_PHYSICAL_COLUMNS_ONLY'
    assert r['status']=='PASS_EXACT_SINGLETON_GEOMETRY_SEED' and r['seed_sha256']==sha(a.seed)
    assert r['consumer_sha256']==sha('verify_singleton_geometry_seed.py') and r['point_sha256']==c['point_sha256']
    for p,h in {**c['source_hashes'],**r['source_hashes']}.items():assert sha(p)==h
    B=c['physical_bases'];E=c['physical_zero_ground_indices'];q=list(map(Q,c['conditional_target']));n=len(B)
    supports={j:[] for j in E}
    for i,b in enumerate(B):
        for j in b:supports[j].append(i)
    lp=Path(str(a.prefix)+'.lp');assert not (ROOT/lp).exists()
    with (ROOT/lp).open('x') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        stream.write(' mass: '+' '.join('+ 1 x'+str(i) for i in range(n))+' = 1\n')
        for j in E:stream.write(' q'+str(j)+': '+(' '.join('+ 1 x'+str(i) for i in supports[j]) or '+ 0 x0')+' = '+str(q[j])+'\n')
        for i in range(n):stream.write(f' n{i}: - 1 x{i} <= 0\n')
        stream.write('Bounds\n')
        for i in range(n):stream.write(f' x{i} free\n')
        stream.write('End\n')
    sources=dict(c['source_hashes']);sources.update(r['source_hashes'])
    for p in [str(a.seed),str(a.receipt),Path(__file__).name,'verify_singleton_geometry_seed.py','read_soplex_exact_output.py']:sources[p]=sha(p)
    semantic=Path(str(a.prefix)+'.model.json.gz')
    model=dict(status='FROZEN_SINGLETON_GEOMETRY_BASIS_ARCHIVE',seed_kind='GEOMETRY_SEED',source_hashes=sources,
               geometry_seed=str(a.seed),geometry_seed_sha256=sha(a.seed),geometry_receipt=str(a.receipt),geometry_receipt_sha256=sha(a.receipt),
               point=c['point'],point_sha256=c['point_sha256'],anchor_orbit=c['anchor_orbit'],conditional_probability=c['conditional_probability'],
               conditional_target=c['conditional_target'],physical_zero_ground_indices=E,physical_bases=B,unit_probabilities=c['unit_probabilities'],
               variable_count=n,equality_count=1+len(E),nonnegative_row_count=n,old_weights_used=False,old_target_claims_used=False,
               scope='Geometry-only physical columns with fresh target. No present-target mixture or partial-state claim; fixed archive infeasibility is not a source cut.')
    write(semantic,model)
    manifest=dict(status='EXACT_SINGLETON_GEOMETRY_ARCHIVE_LP_REQUIRES_TEXT_REPLAY',semantic=str(semantic),semantic_sha256=sha(semantic),
                  lp=str(lp),lp_sha256=sha(lp),variable_count=n,row_count=n+1+len(E),nonzeros=129*n,
                  point_sha256=c['point_sha256'],anchor_orbit=c['anchor_orbit'],source_sha256=sha(Path(__file__).name),
                  elapsed_seconds=time.monotonic()-start,solver_launched=False,source_C16_answered=False)
    write(Path(str(a.prefix)+'.json'),manifest);print(dict(status=manifest['status'],variables=n,rows=manifest['row_count'],seconds=manifest['elapsed_seconds']),flush=True)
if __name__=='__main__':main()
