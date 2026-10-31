#!/usr/bin/env python3
"""Exact L1 phase-I LP on one immutable physical basis archive; no solve."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--parent-manifest',type=Path,required=True);ap.add_argument('--parent-receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    parent=read(a.parent_manifest);receipt=read(a.parent_receipt)
    assert parent['status']=='EXACT_SINGLETON_ARCHIVE_LP_REQUIRES_TEXT_REPLAY'
    assert receipt['status']=='PASS_EXACT_SINGLETON_ARCHIVE_LP_TEXT_AND_PHYSICAL_COLUMNS'
    assert receipt['manifest_sha256']==sha(a.parent_manifest) and receipt['consumer_sha256']==sha(ROOT/'verify_singleton_archive_cg.py')
    assert sha(parent['semantic'])==parent['semantic_sha256']==receipt['semantic_sha256']
    assert sha(parent['lp'])==parent['lp_sha256']==receipt['lp_sha256']
    s=read(parent['semantic']);assert all(sha(ROOT/p)==h for p,h in s['source_hashes'].items())
    B=s['physical_bases'];E=s['physical_zero_ground_indices'];q=list(map(Q,s['conditional_target']));n=len(B);m=len(E);N=n+2*m
    assert n==3225 and s['anchor_orbit']==15 and s['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    assert B and all(len(b)==len(set(b))==127 and set(b)<=set(E) for b in B)
    assert sum(q[j] for j in E)==127 and all(0<=q[j]<=1 for j in E)
    incidence={j:[] for j in E}
    for i,b in enumerate(B):
        for j in b:incidence[j].append(i)
    lp=Path(str(a.prefix)+'.lp');manifest=Path(str(a.prefix)+'.json');assert not lp.exists() and not manifest.exists()
    with lp.open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0 '+' '.join('+ 1 x'+str(i) for i in range(n,N))+'\nSubject To\n')
        stream.write(' mass: '+' '.join('+ 1 x'+str(i) for i in range(n))+' = 1\n')
        for k,j in enumerate(E):
            terms=' '.join('+ 1 x'+str(i) for i in incidence[j])
            stream.write(f' q{j}: {terms} + 1 x{n+k} - 1 x{n+m+k} = {q[j]}\n')
        for i in range(N):stream.write(f' n{i}: - 1 x{i} <= 0\n')
        stream.write('Bounds\n')
        for i in range(N):stream.write(f' x{i} free\n')
        stream.write('End\n')
    # A literal feasible phase-I reference exists without trusting any solver.
    first=set(B[0]);plus=[max(Q(0),q[j]-int(j in first)) for j in E]
    minus=[max(Q(0),int(j in first)-q[j]) for j in E]
    assert all(Q(int(j in first))+plus[k]-minus[k]==q[j] for k,j in enumerate(E))
    peer=ROOT/'two-basis-results/singleton-phase-one-peer-review.json';review=read(peer)
    assert review['status']=='PASS_READ_ONLY_EXACT_SINGLETON_PHASE_ONE_MATHEMATICAL_REVIEW'
    assert all(sha(ROOT/p)==h for p,h in review['source_hashes'].items())
    sources=dict(s['source_hashes'])
    for path in [a.parent_manifest,a.parent_receipt,Path(parent['semantic']),Path(parent['lp']),Path(__file__),
                 ROOT/'verify_singleton_phase_one.py',peer,ROOT/'SINGLETON-PHASE-ONE.md']:
        sources[str(path.resolve().relative_to(ROOT))]=sha(path)
    result=dict(status='EXACT_SINGLETON_PHASE_ONE_LP_REQUIRES_REPLAY',parent_manifest=str(a.parent_manifest),parent_manifest_sha256=sha(a.parent_manifest),
                parent_receipt=str(a.parent_receipt),parent_receipt_sha256=sha(a.parent_receipt),
                parent_semantic=parent['semantic'],parent_semantic_sha256=parent['semantic_sha256'],
                lp=str(lp),lp_sha256=sha(lp),lp_bytes=lp.stat().st_size,variable_count=N,basis_count=n,ground_count=m,row_count=1+m+N,
                constraint_nonzeros=129*n+4*m,objective_nonzeros=2*m,positive_slack_offset=n,negative_slack_offset=n+m,
                point_sha256=s['point_sha256'],anchor_orbit=s['anchor_orbit'],source_hashes=sources,producer_sha256=sha(__file__),
                peer_receipt=str(peer.relative_to(ROOT)),peer_receipt_sha256=sha(peer),proof_note='SINGLETON-PHASE-ONE.md',proof_note_sha256=sha(ROOT/'SINGLETON-PHASE-ONE.md'),
                feasible_reference=dict(basis_column=0,positive_slacks=list(map(str,plus)),negative_slacks=list(map(str,minus)),exact_objective=str(sum(plus)+sum(minus))),
                original_columns_unchanged=True,new_physical_columns_generated=False,solver_executed=False,
                source_C16_answered=False,nice=19,threads=1,elapsed_seconds=time.monotonic()-start)
    manifest.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ('source_hashes','feasible_reference')}),flush=True)
if __name__=='__main__':main()
