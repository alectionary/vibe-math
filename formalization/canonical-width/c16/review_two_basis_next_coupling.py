#!/usr/bin/env python3
"""Read-only endpoint inventory and tiny mutual-owner versus Hall controls."""
from pathlib import Path
from itertools import combinations,permutations
from collections import Counter
from fractions import Fraction
import hashlib,json

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):return json.loads(Path(p).read_text())
def rank(vs):
    piv={}
    for v in vs:
        while v and v.bit_length()in piv:v^=piv[v.bit_length()]
        if v:piv[v.bit_length()]=v
    return len(piv)

def main():
    output=ROOT/'two-basis-results/next-coupling-owner-star-strategy-review.json';assert not output.exists()
    paths=['review_two_basis_next_coupling.py','two_sided_full_basis_next_gate.md','two_sided_full_basis_oracle.py','two_basis_overlap.md','two_basis_structure_point22_review.md',
           'two-basis-results/two-basis-push-relabel-early-point22.json','two-basis-results/two-basis-push-relabel-early-point22-config.json','coupling-results/two-basis-integer-witness22-rational.json.gz',
           'two-basis-results/two-basis-point22-local-allocation-closure.json','pools/xcoords.txt','pools/zcoords.txt']
    hashes={p:sha(ROOT/p)for p in paths};cohort=read(ROOT/paths[5]);assert cohort['status']=='ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED';config=read(ROOT/paths[6]);point_sha=hashes[paths[7]]
    outcomes=[]
    for o in cohort['outcomes']:
        cp,rp=o['certificate'],o['receipt'];r=read(ROOT/rp)
        assert sha(ROOT/cp)==o['certificate_sha256']==r['certificate_sha256']and sha(ROOT/rp)==o['receipt_sha256']
        assert r['point_sha256']==point_sha and r['status']==o['independent_status']
        assert not r['all_patterns_membership_proved']and not r['two_sector_membership_proved']and not r['source_C16_answered']
        if o['solver_status']=='EXACT_RANK_VIOLATION':assert Fraction(r['endpoint']['physical_rank_cut']['exact_raw_violation'])>0
        else:assert r['endpoint']['local_mask_membership_proved']and r['endpoint']['exact_raw_L1_residual']=='0'
        hashes[cp]=sha(ROOT/cp);hashes[rp]=sha(ROOT/rp)
        outcomes.append(dict(side=o['side'],mask=o['mask'],status=o['solver_status']))
    for side in ['X','Z']:
        rp=config['sectors'][side]['mask0_receipt'];r=read(ROOT/rp)
        assert r['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE'and r['point_sha256']==point_sha and r['selected_mask']==0
        assert not r['all_patterns_membership_proved']and not r['two_sector_membership_proved']
        hashes[rp]=sha(ROOT/rp);outcomes.append(dict(side=side,mask=0,status='EXACT_BASE_MIXTURE'))
    assert Counter(o['status']for o in outcomes)==dict(EXACT_BASE_MIXTURE=7,EXACT_RANK_VIOLATION=15)
    controls=[]
    for d in [1,2,3]:
        bases=[b for b in combinations(range(1,1<<d),d)if rank(b)==d];hall=dual=star=0
        for X in bases:
            compatible=0
            for Z in bases:
                A=[[((x&z).bit_count()%2)for z in Z]for x in X]
                matching=any(all(A[i][p[i]]for i in range(d))for p in permutations(range(d)));assert matching;hall+=1
                isdual=all(sum(row)==1 for row in A)and all(sum(A[i][j]for i in range(d))==1 for j in range(d))
                # At deterministic marginals y_X=y_Z=lambda=1, every edge's
                # Frechet lower bound is1. The owner row total is exactly1.
                starok=all(sum(row)<=1 for row in A);assert starok==isdual
                dual+=isdual;star+=starok;compatible+=isdual
            assert compatible==1
        controls.append(dict(dimension=d,bases=len(bases),basis_pairs=len(bases)**2,Hall_feasible_pairs=hall,unique_dual_pairs=dual,Frechet_owner_star_feasible_pairs=star))
    X,Z=[[int(v,16)for v in (ROOT/f'pools/{s}coords.txt').read_text().split()]for s in 'xz']
    degrees=[sum((x&z).bit_count()%2 for z in Z)for x in X]
    out=dict(status='PASS_BOUNDED_NEXT_COUPLING_STRATEGY_REVIEW',source_hashes=hashes,point_sha256=point_sha,
             point22_fixed_allocation_status=dict(exact_sector_pattern_mixtures=7,positive_higher_rank_allocation_cuts=15,full_conditional_membership=False,outcomes=outcomes),
             tiny_exhaustive_basis_pair_controls=controls,physical_pairing_one_edges=sum(degrees),physical_X_star_degree_range=[min(degrees),max(degrees)],
             next_gate='Conditional owner-star transport with Frechet lower bounds and prescribed global pairing-one cross moments; free shared lambda required before projected point obstruction.',
             literature_search_needed=False,new_solver_run=False,source_C16_answered=False,selected_source_case_excluded=False,
             scope='Read-only inventory binding and mathematical next-gate review. Tiny controls illustrate strictness beyond independent bases; they do not establish a C16 point violation or full source obstruction.')
    assert all(sha(ROOT/p)==h for p,h in hashes.items());output.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(output.relative_to(ROOT),sha(output))
if __name__=='__main__':main()
