#!/usr/bin/env python3
"""Exact feasibility on a frozen physical singleton basis archive; no pricing."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p);assert not p.exists();raw=(json.dumps(d,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if p.suffix=='.gz' else raw)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--endpoint',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    c=read(a.endpoint);r=read(a.receipt);fp=a.endpoint.with_name(a.endpoint.name.removesuffix('.json.gz')+'.frozen.json');f=read(fp)
    assert r['status']=='PASS_EXACT_GLOBAL_SINGLETON_PARTIAL_STATE'
    assert r['certificate_sha256']==sha(a.endpoint) and r['frozen_sha256']==c['frozen_sha256']==sha(fp)
    assert r['consumer_sha256']==sha(ROOT/'verify_singleton_global_rank_early.py')
    assert c['source_hashes']==f['source_hashes'] and all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
    B=[b['indices'] for b in c['zero_bases']];assert len({tuple(b) for b in B})==len(B)
    E=f['physical_zero_ground_indices'];q=list(map(Q,c['conditional_target']));n=len(B)
    columns={j:[] for j in E}
    for b,J in enumerate(B):
        assert len(J)==127 and J==sorted(set(J))
        for j in J:columns[j].append(b)
    lp=Path(str(a.prefix)+'.lp');assert not lp.exists()
    with lp.open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        stream.write(' mass: '+' '.join('+ 1 x'+str(b) for b in range(n))+' = 1\n')
        for j in E:
            terms=' '.join('+ 1 x'+str(b) for b in columns[j]) or '+ 0 x0'
            stream.write(f' q{j}: {terms} = {q[j]}\n')
        for b in range(n):stream.write(f' n{b}: - 1 x{b} <= 0\n')
        stream.write('Bounds\n')
        for b in range(n):stream.write(f' x{b} free\n')
        stream.write('End\n')
    sources=dict(f['source_hashes'])
    for p in [a.endpoint,a.receipt,fp,Path(__file__),ROOT/'verify_singleton_archive_lp.py',ROOT/'read_soplex_exact_output.py']:
        sources[str(p.resolve().relative_to(ROOT))]=sha(p)
    semantic=Path(str(a.prefix)+'.model.json.gz')
    model=dict(status='FROZEN_SINGLETON_PHYSICAL_BASIS_ARCHIVE',source_hashes=sources,
               endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),endpoint_receipt=str(a.receipt),endpoint_receipt_sha256=sha(a.receipt),
               point=f['point_path'],point_sha256=f['point_sha256'],anchor_orbit=f['anchor_orbit'],
               conditional_probability=f['conditional_probability'],conditional_target=c['conditional_target'],
               physical_zero_ground_indices=E,physical_bases=B,unit_probabilities=c['unit_probabilities'],
               variable_count=n,equality_count=1+len(E),nonnegative_row_count=n,
               scope='Convex hull of this fixed archive only; infeasibility is not a global rank cut.')
    write(semantic,model)
    manifest=dict(status='EXACT_SINGLETON_ARCHIVE_LP_REQUIRES_TEXT_REPLAY',semantic=str(semantic),semantic_sha256=sha(semantic),
                  lp=str(lp),lp_sha256=sha(lp),variable_count=n,row_count=1+len(E)+n,
                  nonzeros=n+127*n+n,point_sha256=f['point_sha256'],source_sha256=sha(__file__),
                  elapsed_seconds=time.monotonic()-start,source_C16_answered=False)
    write(Path(str(a.prefix)+'.json'),manifest);print(json.dumps(manifest),flush=True)
if __name__=='__main__':main()
