#!/usr/bin/env python3
"""Source-bound, physical-rank acceptance of the single colored pilot."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_key)=='1'
from fractions import Fraction as Q
from pathlib import Path
import copy,gzip,hashlib,json,time
from verify_colored_physical_endpoint_draft import rebuild_domain,physical_domain_rank,check_endpoint
from verify_two_sided_full_basis_oracle import physical_source

ROOT=Path(__file__).resolve().parent
PREFIX='two-basis-results/colored-physical-point22-Z-m02-X614-v1'
def sha(p): return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    b=(ROOT/p).read_bytes(); return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)

def main():
    started=time.monotonic(); f=read(PREFIX+'.frozen.json'); c=read(PREFIX+'.json.gz')
    assert c['frozen_sha256']==sha(PREFIX+'.frozen.json')
    for p,h in f['source_hashes'].items(): assert sha(p)==h
    X,Z,bridge=physical_source()
    assert f['side']=='Z' and f['mask']==2 and f['probe_X']==614
    specs=[dict(selected_opposite=[512,614],selected_own=[],absent_own=[186,433]),dict(selected_opposite=[512],selected_own=[],absent_own=[186,433])]
    assert f['domain_specs']==specs
    fc={s:read(p+'.frozen.json') for s,p in f['allocations'].items()}
    cc={s:read(p+'.json.gz') for s,p in f['allocations'].items()}
    for s,p in f['allocations'].items():
        r=read(p+'-independent.json')
        assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert r['certificate_sha256']==sha(p+'.json.gz') and r['frozen_sha256']==sha(p+'.frozen.json')
        assert r['consumer_sha256']==sha('verify_two_basis_rank_geometry_allocation.py')
        assert r['point_sha256']==fc[s]['point_sha256']==f['point_sha256']==sha(f['point'])
    assert fc['X']['lambda_masses']==fc['Z']['lambda_masses']
    lam=Q(fc['Z']['lambda_masses'][2]); a=Q(cc['X']['exact_allocations'][2][614]); z=list(map(Q,cc['Z']['exact_allocations'][2]))
    masses=[a/lam,1-a/lam]; target=[v/lam for v in z]
    assert list(map(Q,f['color_masses']))==masses and list(map(Q,f['normalized_target']))==target
    assert list(map(Q,f['raw_Z_target']))==z and Q(f['lambda_mass'])==lam and Q(f['probe_raw_mass'])==a
    domains=[rebuild_domain(Z,X,s,128) for s in specs]; assert all(d['feasible'] for d in domains)
    literal=check_endpoint(Z,X,specs,masses,target,c['endpoint'],allow_inconclusive=True)
    endpoint=c['endpoint']; assert endpoint.get('maximum_active_bases',len(endpoint['bases']))<=5000
    J=[51,56,194,230,485,492,501,547,588,642,646]; assert f['known_J']==J
    assert all((X[614]&Z[j]).bit_count()%2 for j in J)
    ranks=[physical_domain_rank(Z,d,J) for d in domains]
    r1,r0=ranks
    plain=sum(z[j] for j in J)+(len(J)-1)*a-len(J)*lam
    split=sum(z[j] for j in J)+(r0-r1)*a-r0*lam
    assert plain==Q(f['known_plain_star_gap'])==Q(6268396875783,1125899906842624)
    assert split==lam*(sum(target[j] for j in J)-sum(w*r for w,r in zip(masses,ranks)))
    # Independently enumerate closure by the physical contraction/bin rank formula.
    # This is a finite 720-element rank replay, not a subset-search or new pilot.
    closures=[{j for j in range(720) if physical_domain_rank(Z,d,sorted(set(J)|{j}))==r} for d,r in zip(domains,ranks)]
    common=sorted(set.intersection(*closures)); assert common==f['proposed_common_closure']
    cranks=[physical_domain_rank(Z,d,common) for d in domains]; assert cranks==ranks
    common_gap=sum(z[j] for j in common)+(r0-r1)*a-r0*lam
    assert common_gap>=split
    # Necessary face identity; original zero-pool can span the probe annihilator.
    A={j for j in range(720) if (X[614]&Z[j]).bit_count()%2}; H=sorted(set(range(720))-A)
    rank0H=physical_domain_rank(Z,domains[1],H); assert rank0H==127
    face_controls=[]
    for S in (J,common,H,list(range(720))):
        ss=set(S)
        formula=physical_domain_rank(Z,domains[1],sorted(ss-set(A)))+physical_domain_rank(Z,domains[1],sorted(set(H)|(ss&A)))-rank0H
        actual=physical_domain_rank(Z,domains[0],sorted(ss)); assert formula==actual
        face_controls.append(dict(size=len(ss),augmented_rank=actual,face_rank=formula))
    mutants=[]
    for label in ('negative-weight','wrong-color-mass','wrong-achieved'):
        bad=copy.deepcopy(endpoint)
        if label=='negative-weight': bad['bases'][0]['weight_numerator']='-1'
        if label=='wrong-color-mass': bad['color_mass_numerators'][0]=str(int(bad['color_mass_numerators'][0])+1)
        if label=='wrong-achieved': bad['achieved_numerators'][0]=str(int(bad['achieved_numerators'][0])+1)
        try: check_endpoint(Z,X,specs,masses,target,bad,allow_inconclusive=True)
        except (AssertionError,ValueError,TypeError): mutants.append(label)
        else: raise AssertionError(('accepted mutant',label))
    raw_cut_gap=None
    if endpoint['violated_weighted_rank']:
        bad=copy.deepcopy(endpoint); bad['violated_weighted_rank']['ranks_by_color'][0]+=1
        try: check_endpoint(Z,X,specs,masses,target,bad,allow_inconclusive=True)
        except (AssertionError,ValueError,TypeError): mutants.append('wrong-cut-physical-rank')
        else: raise AssertionError('accepted wrong rank')
        raw_cut_gap=str(lam*Q(endpoint['violated_weighted_rank']['exact_violation']))
    out=dict(status='PASS_ONE_COLORED_PHYSICAL_PILOT',certificate_sha256=sha(PREFIX+'.json.gz'),
             frozen_sha256=sha(PREFIX+'.frozen.json'),consumer_sha256=sha(Path(__file__).name),
             source_hashes=f['source_hashes'],point_sha256=f['point_sha256'],physical_endpoint=literal,
             known_J=dict(indices=J,r0=r0,r1=r1,plain_star_raw_gap=str(plain),split_rank_raw_gap=str(split),strict_improvement=split>plain),
             common_closure=dict(indices=common,size=len(common),r0=r0,r1=r1,raw_gap=str(common_gap),strict_improvement=common_gap>split),
             original_H_rank=rank0H,face_formula_controls=face_controls,endpoint_raw_cut_gap=raw_cut_gap,
             mutants_rejected=mutants,priority=19,elapsed_seconds=time.monotonic()-started,
             scope='One local colored split test for the original point22 pattern2 allocation. No target moment exclusion, cross-pattern lift or C16 conclusion.')
    outpath=ROOT/(PREFIX+'-independent.json'); assert not outpath.exists();outpath.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({k:out[k] for k in ('status','known_J','endpoint_raw_cut_gap','elapsed_seconds')}))

if __name__=='__main__': main()
