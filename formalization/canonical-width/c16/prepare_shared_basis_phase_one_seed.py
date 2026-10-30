#!/usr/bin/env python3
"""Prepare an exact physical-column/link-error start; no master or LP solve."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[key]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle,rank,json_exact,source_hashes
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def write(p,d):
    p=Path(p);assert not p.exists();raw=(json.dumps(json_exact(d),indent=2)+'\n').encode()
    p.write_bytes(gzip.compress(raw,mtime=0) if p.suffix=='.gz' else raw)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--endpoint',type=Path,required=True)
    ap.add_argument('--endpoint-receipt',type=Path,required=True);ap.add_argument('--parent-receipt',type=Path,required=True)
    ap.add_argument('--prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    c=read(a.endpoint);r=read(a.endpoint_receipt);parent=read(a.parent_receipt)
    assert c['status']=='EXACT_OWNER_K22_CAPACITY_ALLOCATION_REQUIRES_REPLAY'
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION'
    assert r['certificate_sha256']==sha(a.endpoint) and r['consumer_sha256']==sha(ROOT/'verify_owner_k22_capacity_endpoint.py')
    assert r['parent_receipt_sha256']==sha(a.parent_receipt)
    assert parent['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert parent['consumer_sha256']==sha(ROOT/'verify_owner_capacity_joint_literal.py')
    assert parent['certificate_sha256']==c['parent_projection_sha256']==sha(c['parent_projection'])
    assert c['zero_tau_pins'] is r['zero_tau_pins'] is parent['zero_tau_pins'] is True
    assert c['point_sha256']==r['point_sha256']==parent['point_sha256']=='4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f'
    assert len(c['exact_parameters'])==22513
    assert c['exact_parameters']==[str(Q(v)) for v in c['exact_parameters']]
    lam=list(map(Q,c['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    Y={s:[list(map(Q,row)) for row in c['exact_allocations'][s]] for s in 'XZ'}
    assert all(len(Y[s])==16 and all(len(row)==720 for row in Y[s]) for s in 'XZ')
    assert all(c['exact_allocations'][s]==[list(map(str,row)) for row in Y[s]] for s in 'XZ')
    positive=[m for m in range(16) if lam[m]];zeros=[m for m in range(16) if not lam[m]]
    assert positive==[0,1,2,3,4,5,6,8,9,10,12] and zeros==[7,11,13,14,15]
    for s in 'XZ':
        for m in range(16):
            assert all(0<=v<=lam[m] for v in Y[s][m]) and sum(Y[s][m])==128*lam[m]
    controls=ROOT/'two-basis-results/two-sided-full-basis-controls-v3-independent.json';cr=read(controls)
    assert cr['status']=='PASS' and cr['producer_sha256']==sha(ROOT/'two_sided_full_basis_oracle.py')
    assert cr['consumer_sha256']==sha(ROOT/'verify_two_sided_full_basis_oracle.py')
    sources=source_hashes()
    for table in (c['source_bindings'],r['source_hashes'],parent['source_hashes'],r['dependencies'],parent['dependencies']):
        for p,h in table.items():
            assert sha(ROOT/p)==h
            assert p not in sources or sources[p]==h;sources[p]=h
    for p in [a.endpoint,a.endpoint_receipt,a.parent_receipt,Path(c['parent_projection']),controls,
              Path(__file__),ROOT/'verify_owner_k22_capacity_endpoint.py',ROOT/'verify_owner_capacity_joint_literal.py',
              ROOT/'verify_two_sided_full_basis_oracle.py',ROOT/'SHARED-BASIS-MASTER-NEXT-GATE.md']:
        sources[str(p.resolve().relative_to(ROOT))]=sha(p)
    frozen_path=Path(str(a.prefix)+'.frozen.json');output=Path(str(a.prefix)+'.json.gz')
    assert not frozen_path.exists() and not output.exists()
    frozen=dict(status='FROZEN_SHARED_BASIS_PHASE_ONE_SEED_PREPARATION',source_hashes=sources,
                endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),endpoint_receipt=str(a.endpoint_receipt),endpoint_receipt_sha256=sha(a.endpoint_receipt),
                parent_receipt=str(a.parent_receipt),parent_receipt_sha256=sha(a.parent_receipt),
                X_anchors=[80,512],Z_anchors=[186,433],positive_masks=positive,zero_masks=zeros,
                basis_weights='Exact existing pattern mass; one full physical basis per positive sector-pattern.',
                pricing_weights='Exact parent allocation y[m,j]; no division by pattern mass or floating conversion.',
                expected_bases=22,expected_zero_blocks=10,parent_full_rows_retained=98868,
                master_implemented=False,optimization_run=False,source_C16_answered=False,nice=19,threads=1)
    write(frozen_path,frozen)
    oracle=TwoSidedFullBasisOracle();dd=oracle.prepare([80,512],[186,433])
    blocks=[];zero_blocks=[];sector_L1={s:Q(0) for s in 'XZ'}
    for m in range(16):
        if not lam[m]:
            for s in 'XZ':
                assert not any(Y[s][m]);zero_blocks.append(dict(side=s,mask=m,mass='0'))
            continue
        support=oracle.support_pattern(dd[m],Y['X'][m]+Y['Z'][m])
        assert support['status']=='EXACT_TWO_SIDED_PATTERN_BASIS_SUPPORT'
        for s in 'XZ':
            U=oracle.X if s=='X' else oracle.Z;result=support[s+'_support'];B=result['selected_indices'];chosen=set(B)
            assert len(B)==len(chosen)==rank(U[j] for j in B)==128
            score=sum(Y[s][m][j] for j in B);assert score==result['value']
            residual=[Y[s][m][j]-lam[m]*int(j in chosen) for j in range(720)]
            plus=[max(Q(0),v) for v in residual];minus=[max(Q(0),-v) for v in residual]
            assert all(lam[m]*int(j in chosen)+plus[j]-minus[j]==Y[s][m][j] for j in range(720))
            distance=sum(plus)+sum(minus);assert distance==256*lam[m]-2*score>=0
            sector_L1[s]+=distance
            blocks.append(dict(side=s,mask=m,mass=str(lam[m]),indices=B,weight=str(lam[m]),
                               positive_slack=list(map(str,plus)),negative_slack=list(map(str,minus)),
                               weighted_score=str(score),L1=str(distance),
                               zero_basis_indices=result['zero_basis_indices'],owner_indices=result['owner_indices']))
    assert len(blocks)==22 and len(zero_blocks)==10
    assert all(sum(Q(b['weight']) for b in blocks if b['side']==s)==1 for s in 'XZ')
    total=sum(sector_L1.values());assert 0<=total<=512
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    out=dict(status='EXACT_SHARED_BASIS_PHASE_ONE_SEED_REQUIRES_REPLAY',frozen=str(frozen_path),frozen_sha256=sha(frozen_path),source_hashes=sources,
             endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),endpoint_receipt=str(a.endpoint_receipt),endpoint_receipt_sha256=sha(a.endpoint_receipt),
             parent_receipt=str(a.parent_receipt),parent_receipt_sha256=sha(a.parent_receipt),point_sha256=c['point_sha256'],
             X_anchors=[80,512],Z_anchors=[186,433],lambda_masses=c['lambda_masses'],
             parent_exact_parameters=c['exact_parameters'],parent_exact_allocations=c['exact_allocations'],
             blocks=blocks,zero_blocks=zero_blocks,sector_L1={s:str(v) for s,v in sector_L1.items()},total_L1=str(total),
             unchanged_parent_full_rows=98868,parent_values_retained=True,all_links=23040,nonzero_block_links=15840,zero_block_links=7200,
             seed_only=True,master_implemented=False,optimization_run=False,full_basis_membership_of_parent_allocations=False,
             L1_single_basis_formula='256*lambda-2*sum(y[j] for j in chosen128basis)',
             source_C16_answered=False,unanchored_mutual_pairings_enforced=False,producer_sha256=sha(__file__),
             elapsed_seconds=time.monotonic()-start,nice=19,threads=1)
    write(output,out)
    print(json.dumps(dict(status=out['status'],output=str(output),sha256=sha(output),blocks=len(blocks),zero_blocks=len(zero_blocks),
                         sector_L1_approx={s:float(v) for s,v in sector_L1.items()},total_L1_approx=float(total),
                         elapsed_seconds=out['elapsed_seconds'],master_implemented=False,optimization_run=False)),flush=True)
if __name__=='__main__':main()
