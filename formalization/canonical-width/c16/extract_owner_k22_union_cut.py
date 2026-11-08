#!/usr/bin/env python3
"""Extract and literally control one conditional union obstruction; no solve."""
from pathlib import Path
from fractions import Fraction as Q
from itertools import product
import gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
def read(p):
    b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def coord(a,b):
    i,t=divmod(a,16);j,u=divmod(b,16);h=(u-t)%16
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    return 45+2025*h+45*i+j
def exact_allocate(rows,sx,sz):
    # Constructive proof: allocate X first where it decreases the required Z.
    x=[max(Q(0),L-Uz) for Ux,Uz,L in rows]
    if not sum(x)<=sx<=sum(Ux for Ux,Uz,L in rows):return None
    left=sx-sum(x)
    for useful in (True,False):
        for i,(Ux,Uz,L) in enumerate(rows):
            upper=min(Ux,L) if useful else Ux
            delta=min(left,max(Q(0),upper-x[i]));x[i]+=delta;left-=delta
    if left:return None
    z=[max(Q(0),L-x[i]) for i,(Ux,Uz,L) in enumerate(rows)]
    if not sum(z)<=sz<=sum(Uz for Ux,Uz,L in rows):return None
    left=sz-sum(z)
    for i,(Ux,Uz,L) in enumerate(rows):delta=min(left,Uz-z[i]);z[i]+=delta;left-=delta
    assert left==0 and sum(x)==sx and sum(z)==sz
    assert all(0<=x[i]<=Ux and 0<=z[i]<=Uz and x[i]+z[i]>=L for i,(Ux,Uz,L) in enumerate(rows))
    return list(zip(x,z))
def criterion(rows,sx,sz):
    return (all(Ux>=0 and Uz>=0 and 0<=L<=Ux+Uz for Ux,Uz,L in rows)
        and sum(max(0,L-Uz) for Ux,Uz,L in rows)<=sx<=sum(Ux for Ux,Uz,L in rows)
        and sum(max(0,L-Ux) for Ux,Uz,L in rows)<=sz<=sum(Uz for Ux,Uz,L in rows)
        and sx+sz>=sum(L for Ux,Uz,L in rows))
def small_controls():
    # Independent two-polygon intersection: x2=sx-x1,z2=sz-z1.
    # The remaining feasible set is a rectangle intersected with a sum interval.
    shapes=[(Q(x,2),Q(z,2),Q(L,2)) for x in range(3) for z in range(3) for L in range(x+z+1)]
    checked=0;feasible=0
    for A,B in product(shapes,repeat=2):
        for sx,sz in product([Q(i,2) for i in range(-1,6)],repeat=2):
            Ux,Uz,L=A;Vx,Vz,K=B
            lx=max(Q(0),sx-Vx);ux=min(Ux,sx);lz=max(Q(0),sz-Vz);uz=min(Uz,sz)
            independent=lx<=ux and lz<=uz and max(lx+lz,L)<=min(ux+uz,sx+sz-K)
            claimed=criterion([A,B],sx,sz);assert claimed==independent
            witness=exact_allocate([A,B],sx,sz);assert (witness is not None)==independent
            checked+=1;feasible+=independent
    # Three-pattern rational cases also replay every produced witness literally.
    three=0
    for A in shapes[::4]:
        rows=[A,(Q(2,3),Q(3,5),Q(1,2)),(Q(1,7),Q(2,7),Q(3,7))]
        for sx,sz in product([Q(i,7) for i in range(12)],repeat=2):
            witness=exact_allocate(rows,sx,sz);assert (witness is not None)==criterion(rows,sx,sz);three+=1
    return dict(two_pattern_exact_intersection_checks=checked,two_pattern_feasible_cases=feasible,
                three_pattern_rational_constructive_checks=three)
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    start=time.monotonic();outpath='two-basis-results/owner-k22-conditional-union-point22.json';assert not (ROOT/outpath).exists()
    from verify_two_sided_full_basis_oracle import point_owner
    point='coupling-results/two-basis-integer-witness22-rational.json.gz';cert='two-basis-results/joint-owner-capacity-zero-face-point22-exact.json';receipt='two-basis-results/joint-owner-capacity-zero-face-point22-exact-independent.json'
    audit='two-basis-results/owner-global-k22-point22-audit.json';c=read(cert);r=read(receipt);a=read(audit)
    assert r['certificate_sha256']==sha(cert) and r['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['point_sha256']==sha(point)==c['point_sha256'] and a['point_sha256']==sha(point)
    assert sha(c['semantic'])==c['semantic_sha256'];meta=read(c['semantic'])['model']['owner_flow_extension']
    Y={s:[list(map(Q,row)) for row in c['exact_allocations'][s]] for s in 'XZ'};lam=list(map(Q,c['lambda_masses']));params=list(map(Q,c['exact_parameters']));owner=point_owner(point)
    pairs={tuple(p):i for i,p in enumerate(meta['physical_pairs'])};E=len(pairs);n=meta['base_variable_count'];xx=[614,281];zz=[51,83]
    def t(m,x,z):return params[n+m*E+pairs[x,z]]
    active=[];gap=-owner[coord(*xx)]
    for m in range(16):
        candidates=[(Y['X'][m][xx[0]]+Y['X'][m][xx[1]]+Y['Z'][m][z]-lam[m]-t(m,xx[0],z)-t(m,xx[1],z),z) for z in zz]
        value,z=max(candidates,key=lambda p:(p[0],-p[1]))
        if value>0:active.append(dict(mask=m,Z_index=z,lower_bound=str(value)));gap+=value
    assert [x['mask'] for x in active]==[2,9]
    assert gap==-Q(a['conditional_same_sector_margins']['X_lower'])>0
    terms=dict(lambda_coefficients=[[d['mask'],-1] for d in active],
               yX_coefficients=[[d['mask'],x,1] for d in active for x in xx],
               yZ_coefficients=[[d['mask'],d['Z_index'],1] for d in active],
               t_coefficients=[[d['mask'],x,d['Z_index'],-1] for d in active for x in xx],
               owner_coefficients=[[coord(*xx),-1]],rhs=0)
    literal=Q(0)
    for m,w in terms['lambda_coefficients']:literal+=w*lam[m]
    for m,j,w in terms['yX_coefficients']:literal+=w*Y['X'][m][j]
    for m,j,w in terms['yZ_coefficients']:literal+=w*Y['Z'][m][j]
    for m,x,z,w in terms['t_coefficients']:literal+=w*t(m,x,z)
    for j,w in terms['owner_coefficients']:literal+=w*owner[j]
    assert literal==gap
    # All16 anchor patterns times all16 arbitrary center assignments. This
    # proves validity even without the physical K2,2 hypothesis.
    controls=0;maxrow=None;wrong_sign_rejected=False
    for m,bits in product(range(16),repeat=2):
        x,k,z,l=[bits>>i&1 for i in range(4)];zzvalue={51:z,83:l}
        lhs=-x*k
        for d in active:
            if d['mask']==m:
                v=zzvalue[d['Z_index']];lhs+=x+k+v-1-x*v-k*v
        assert lhs<=0;maxrow=lhs if maxrow is None else max(maxrow,lhs);controls+=1
        wrong_sign_rejected|=(lhs+2*x*k>0)
    assert maxrow==0 and wrong_sign_rejected
    # Independent literal K2,2 restrictions: any3 selected centers give one
    # vertex two selected opposite neighbors, and every<=2 subset is permitted.
    matching_controls=0
    for bits in range(16):
        x,k,z,l=[bits>>i&1 for i in range(4)]
        allowed=not ((x and z+l>1) or (k and z+l>1) or (z and x+k>1) or (l and x+k>1))
        assert allowed==(bits.bit_count()<=2);matching_controls+=1
    finite=small_controls()
    sources=[Path(__file__).name,point,cert,receipt,c['semantic'],audit,'audit_owner_global_k22.py','verify_two_sided_full_basis_oracle.py']
    out=dict(status='EXACT_CONDITIONAL_BOOLEAN_UNION_CUT_CANDIDATE',source_hashes={p:sha(p) for p in sources},
             point_sha256=sha(point),allocation_sha256=sha(cert),cuts=[dict(**terms,active_choices=active,exact_violation=str(gap),proof_kind='conditional_boolean_union_with_global_same_sector_pair_total')],
             literal_pattern_center_assignments_checked=controls,literal_K22_assignments_checked=matching_controls,
             wrong_global_pair_sign_mutant_rejected=wrong_sign_rejected,complete_pair_law_controls=finite,
             global_moment_point_excluded=False,provided_allocation_excluded=True,source_C16_answered=False,
             scope='A source-valid auxiliary row rejects only this accepted allocation. K2,2 is not needed for this row; complete conditional K2,2 law additionally uses its at-most-two support.',
             priority=19,elapsed_seconds=time.monotonic()-start)
    (ROOT/outpath).write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(dict(status=out['status'],active=active,gap=float(gap),controls=finite,sha256=sha(outpath),seconds=out['elapsed_seconds']))
if __name__=='__main__':main()
