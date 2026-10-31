#!/usr/bin/env python3
"""Exact four-center source rows and a conditional K2,2 pair-law diagnostic.

No optimizer, no new source rows accepted, and no full-law/frame claim.
"""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
from itertools import combinations
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
def read(p):
    b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def coordinate(a,b):
    sa,a=divmod(a,720);sb,b=divmod(b,720);i,t=divmod(a,16);j,u=divmod(b,16);h=(u-t)%16
    if sa==sb and a==b:return i
    if h>8:h,i,j=16-h,j,i
    if h in (0,8) and i>j:i,j=j,i
    return 45+(0 if sa==sb else 18225)+2025*h+45*i+j
def atoms(p,pairs,mass):
    q={mask:Q(0) for mask in range(16)}
    for (i,j),v in pairs.items():q[(1<<i)|(1<<j)]=v
    for i,v in enumerate(p):q[1<<i]=v-sum(x for ij,x in pairs.items() if i in ij)
    q[0]=mass-sum(p)+sum(pairs.values())
    assert sum(q.values())==mass
    assert [sum(v for m,v in q.items() if m>>i&1) for i in range(4)]==p
    assert {ij:sum(v for m,v in q.items() if all(m>>i&1 for i in ij)) for ij in pairs}==pairs
    return q
def allocate(rows,sx,sz):
    # Exact two-resource allocation in rectangles clipped by x+z>=L.
    if any(r['ux']<0 or r['uz']<0 or r['L']>r['ux']+r['uz'] for r in rows):return None
    x=[max(Q(0),r['L']-r['uz']) for r in rows]
    if not sum(x)<=sx<=sum(r['ux'] for r in rows):return None
    remaining=sx-sum(x)
    for phase in (0,1):
        for i,r in enumerate(rows):
            cap=(min(r['ux'],max(Q(0),r['L'])) if phase==0 else r['ux'])-x[i]
            d=min(remaining,max(Q(0),cap));x[i]+=d;remaining-=d
    assert remaining==0
    z=[max(Q(0),r['L']-x[i]) for i,r in enumerate(rows)]
    if not sum(z)<=sz<=sum(r['uz'] for r in rows):return None
    remaining=sz-sum(z)
    for i,r in enumerate(rows):d=min(remaining,r['uz']-z[i]);z[i]+=d;remaining-=d
    assert remaining==0 and sum(x)==sx and sum(z)==sz
    assert all(0<=x[i]<=r['ux'] and 0<=z[i]<=r['uz'] and x[i]+z[i]>=r['L'] for i,r in enumerate(rows))
    return list(zip(x,z))
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);a=ap.parse_args();assert not (ROOT/a.output).exists();start=time.monotonic()
    from verify_two_sided_full_basis_oracle import point_owner
    from physical_integer_form_rows import compile_row
    point='coupling-results/two-basis-integer-witness22-rational.json.gz'
    cert='two-basis-results/joint-owner-capacity-zero-face-point22-exact.json'
    receipt='two-basis-results/joint-owner-capacity-zero-face-point22-exact-independent.json'
    c=read(cert);rr=read(receipt);assert rr['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert rr['certificate_sha256']==sha(cert) and rr['point_sha256']==sha(point)==c['point_sha256']
    assert sha(c['semantic'])==c['semantic_sha256'];M=read(c['semantic'])['model'];meta=M['owner_flow_extension']
    owner=point_owner(point);X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    xx=[614,281];zz=[51,83];events=xx+[720+j for j in zz]
    assert all((X[i]&Z[j]).bit_count()%2 for i in xx for j in zz)
    p=[owner[e%720//16] for e in events];pairs={ij:owner[coordinate(events[ij[0]],events[ij[1]])] for ij in combinations(range(4),2)}
    global_atoms=atoms(p,pairs,Q(1));assert min(global_atoms.values())>=0
    owner_rows=[]
    for side,centers,U,V in [('X',xx,X,Z),('Z',zz,Z,X)]:
        for i,k in (centers,centers[::-1]):
            common=[j for j in range(720) if (U[i]&V[j]).bit_count()%2 and (U[k]&V[j]).bit_count()%2]
            own=i if side=='X' else 720+i;other=k if side=='X' else 720+k
            terms=Counter({i//16:-1});terms[coordinate(own,other)]+=1
            for j in common:terms[coordinate(own,720+j if side=='X' else j)]+=1
            value=sum(v*owner[t] for t,v in terms.items());assert value<=0
            owner_rows.append(dict(side=side,probe=i,other=k,common_neighbors=common,row=[[j,v] for j,v in sorted(terms.items()) if v],exact_slack=str(-value),already_enforced_family='physical_owner_moment_matrix.py'))
    row,rhs=compile_row(dict(events=events,weights=[1]*4,constant=-1))
    assert rhs==1 and Q(rhs)-sum(v*owner[j] for j,v in row.items())==global_atoms[0]
    # Check the universal empty polynomial on every Boolean input. K2,2
    # permits exactly the subsets of cardinality at most two.
    for bits in range(16):
        n=bits.bit_count();assert 1-n+n*(n-1)//2==(n-1)*(n-2)//2>=0
        allowed=not any(all(bits>>i&1 for i in triple) for triple in combinations(range(4),3))
        assert allowed==(n<=2)
    Y={s:[list(map(Q,r)) for r in c['exact_allocations'][s]] for s in 'XZ'};lam=list(map(Q,c['lambda_masses']));params=list(map(Q,c['exact_parameters']))
    edge_id={tuple(e):i for i,e in enumerate(meta['physical_pairs'])};n=meta['base_variable_count'];E=len(edge_id)
    rows=[]
    for m in range(16):
        pp=[Y['X'][m][i] for i in xx]+[Y['Z'][m][j] for j in zz]
        cross={(i,j+2):params[n+m*E+edge_id[xx[i],zz[j]]] for i in range(2) for j in range(2)}
        ux=min(pp[i]-sum(v for ij,v in cross.items() if i in ij) for i in (0,1))
        uz=min(pp[i]-sum(v for ij,v in cross.items() if i in ij) for i in (2,3))
        L=sum(pp)-sum(cross.values())-lam[m]
        rows.append(dict(mask=m,p=pp,cross=cross,ux=ux,uz=uz,L=L))
    sx=pairs[0,1];sz=pairs[2,3]
    margins=dict(X_lower=sx-sum(max(Q(0),r['L']-r['uz']) for r in rows),
                 X_upper=sum(r['ux'] for r in rows)-sx,
                 Z_lower=sz-sum(max(Q(0),r['L']-r['ux']) for r in rows),
                 Z_upper=sum(r['uz'] for r in rows)-sz,
                 joint_lower=sx+sz-sum(max(Q(0),r['L']) for r in rows))
    feasible=all(r['ux']>=0 and r['uz']>=0 and r['L']<=r['ux']+r['uz'] for r in rows) and min(margins.values())>=0
    allocation=allocate(rows,sx,sz);assert (allocation is not None)==feasible
    conditional=[]
    if allocation is not None:
        for r,(x,z) in zip(rows,allocation):
            pp=dict(r['cross']);pp[0,1]=x;pp[2,3]=z;aa=atoms(r['p'],pp,lam[r['mask']]);assert min(aa.values())>=0
            conditional.append(dict(mask=r['mask'],same_sector_X=str(x),same_sector_Z=str(z),atoms=[str(aa[m]) for m in range(16)]))
        assert sum(Q(r['same_sector_X']) for r in conditional)==sx and sum(Q(r['same_sector_Z']) for r in conditional)==sz
    sources=[Path(__file__).name,point,cert,receipt,c['semantic'],'physical_owner_moment_matrix.py','physical_integer_form_rows.py','verify_two_sided_full_basis_oracle.py','pools/xcoords.txt','pools/zcoords.txt','unified_integer_coupling_model.py']
    out=dict(status='EXACT_FIXED_CENTER_OWNER_AND_K22_AUDIT',events=events,point_sha256=sha(point),
             source_hashes={s:sha(s) for s in sources},physical_K22=True,owner_rows=owner_rows,
             global_atoms=[str(global_atoms[m]) for m in range(16)],global_joint_law_feasible=True,
             empty_row_integer_form=dict(events=events,weights=[1]*4,constant=-1),empty_row_exact_slack=str(global_atoms[0]),
             conditional_pair_law_feasible=feasible,conditional_same_sector_margins={k:str(v) for k,v in margins.items()},
             conditional_bounds=[dict(mask=r['mask'],X_upper=str(r['ux']),Z_upper=str(r['uz']),joint_lower=str(r['L'])) for r in rows],
             conditional_atoms=conditional,conditioned_patterns=16,exact_atom_checks=16*len(conditional),
             universal_empty_polynomial_controls=16,source_C16_answered=False,solver_launched=False,
             scope='Only the fixed four-center pair law, and its compatibility with the accepted conditional allocations/edge moments. No full source law, basis coupling, or source obstruction.',
             priority=19,elapsed_seconds=time.monotonic()-start)
    (ROOT/a.output).write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print({k:out[k] for k in ('status','global_joint_law_feasible','empty_row_exact_slack','conditional_pair_law_feasible','conditional_same_sector_margins','elapsed_seconds')})
if __name__=='__main__':main()
