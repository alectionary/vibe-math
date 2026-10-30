#!/usr/bin/env python3
"""Versioned fixed-owner residual rank preparation and one bounded worker.

No physical query is launched by importing this module or by preparation.
The worker requires a separately accepted preparation/tiny review. Endpoint
claims require an independent physical consumer.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse, gzip, hashlib, json, os, time

ROOT=Path(__file__).resolve().parent
THREAD_KEYS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
             'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')

def runtime_guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREAD_KEYS)

def sha(p): return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    raw=(ROOT/p).read_bytes()
    return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,data):
    path=ROOT/p; assert not path.exists(), ('immutable output exists',str(p))
    raw=(json.dumps(data,sort_keys=True,indent=2)+'\n').encode()
    path.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)

def basis_rows(vectors):
    rows={}
    for v in vectors:
        assert type(v)is int and v>=0
        while v:
            p=v.bit_length()-1
            if p not in rows: rows[p]=v;break
            v^=rows[p]
    return rows

def rank(vectors):return len(basis_rows(vectors))
def reduced(v,rows):
    for p in sorted(rows,reverse=True):
        if v>>p&1:v^=rows[p]
    return v

def make_problem(vectors,neighbors,z,t,a,lam):
    """Exact generic adapter. It intentionally requires a feasible face."""
    vectors=list(vectors);n=len(vectors);neighbors=list(neighbors)
    assert neighbors==sorted(set(neighbors)) and all(type(j)is int and 0<=j<n for j in neighbors)
    assert all(type(v)is int and v>=0 for v in vectors)
    z,t=list(map(Q,z)),list(map(Q,t));a,lam=Q(a),Q(lam)
    assert len(z)==len(t)==n and lam>0 and 0<=a<=lam
    R=rank(vectors);assert R>0
    assert all(0<=q<=lam for q in z) and sum(z)==R*lam
    N=set(neighbors);H=[j for j in range(n) if j not in N]
    rowsH=basis_rows(vectors[j] for j in H);assert len(rowsH)==R-1
    G=[j for j in neighbors if reduced(vectors[j],rowsH)]
    assert G
    assert all(0<=q<=z[j] for j,q in enumerate(t)) and sum(t)==a
    assert all(not t[j] for j in range(n) if j not in G)
    dummy=n;bit=1<<max((v.bit_length() for v in vectors),default=0)
    selected=[v if j not in N else 0 for j,v in enumerate(vectors)]+[bit]
    residual=vectors+[0]
    assert rank(selected)==rank(residual)==R
    target=[(z[j]-t[j])/lam for j in range(n)]+[a/lam]
    masses=[a/lam,1-a/lam]
    assert all(v>=0 for v in target) and sum(target)==R
    return dict(original_vectors=vectors,neighbors=neighbors,annihilator_indices=H,
                effective_owner_indices=G,original_rank=R,annihilator_rank=R-1,
                dummy_index=dummy,dummy_bit=bit,vectors_by_color=[selected,residual],
                lambda_mass=lam,probe_mass=a,raw_allocation=z,raw_owner_probabilities=t,
                normalized_target=target,color_masses=masses)

def translate_cut(problem,indices):
    n=problem['dummy_index'];indices=list(indices)
    assert indices==sorted(set(indices)) and all(type(j)is int and 0<=j<=n for j in indices)
    S=[j for j in indices if j<n];N=set(problem['neighbors']);H=set(problem['annihilator_indices'])
    v=problem['original_vectors'];r0=rank(v[j] for j in S);rH=rank(v[j] for j in S if j in H)
    a,lam=problem['probe_mass'],problem['lambda_mass'];z,t=problem['raw_allocation'],problem['raw_owner_probabilities']
    raw=sum(z[j]-t[j] for j in S)+(r0-rH)*a-r0*lam
    selected_rank=rH+int(n in indices);residual_rank=r0
    normalized=sum(problem['normalized_target'][j] for j in indices)-sum(m*r for m,r in zip(problem['color_masses'],[selected_rank,residual_rank]))
    assert raw==lam*normalized
    G=set(problem['effective_owner_indices']);r1=rH+int(bool(set(S)&G))
    old=sum(z[j] for j in S)+(r0-r1)*a-r0*lam
    gain=a*int(bool(set(S)&G))-sum(t[j] for j in S if j in N)
    assert gain>=0 and raw-old==gain
    return dict(indices=S,neighbor_indices=[j for j in S if j in N],
                original_rank=r0,restricted_rank=rH,selected_face_rank=r1,
                probe_coefficient=r0-rH,lambda_coefficient=-r0,
                raw_violation=str(raw),normalized_violation=str(normalized),
                old_split_raw_violation=str(old),fixed_owner_improvement=str(gain),
                specifically_uses_fixed_owner_distribution=raw>0 and old<=0,
                dummy_in_solver_subset=n in indices,
                solver_ranks=[selected_rank,residual_rank],
                inequality='sum_S z - sum_(S intersect N) t + (r0-rH)*a - r0*lambda <= 0')

def encode_problem(p):
    return dict(original_vectors_hex=[hex(v) for v in p['original_vectors']],
                neighbors=p['neighbors'],annihilator_indices=p['annihilator_indices'],
                effective_owner_indices=p['effective_owner_indices'],original_rank=p['original_rank'],
                annihilator_rank=p['annihilator_rank'],dummy_index=p['dummy_index'],dummy_bit_hex=hex(p['dummy_bit']),
                vectors_by_color_hex=[[hex(v) for v in row] for row in p['vectors_by_color']],
                lambda_mass=str(p['lambda_mass']),probe_mass=str(p['probe_mass']),
                raw_allocation=list(map(str,p['raw_allocation'])),raw_owner_probabilities=list(map(str,p['raw_owner_probabilities'])),
                normalized_target=list(map(str,p['normalized_target'])),color_masses=list(map(str,p['color_masses'])))

def decode_problem(p):
    q=make_problem([int(v,16) for v in p['original_vectors_hex']],p['neighbors'],p['raw_allocation'],p['raw_owner_probabilities'],p['probe_mass'],p['lambda_mass'])
    assert encode_problem(q)==p
    return q

def membership_gate(path,side,mask,Y,lam,point_sha,bindings):
    receipt=read(path)
    assert receipt['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE'
    assert receipt['side']==side and receipt['selected_mask']==mask and receipt['point_sha256']==point_sha
    assert receipt['endpoint']['local_mask_membership_proved'] is True
    assert receipt['consumer_sha256']==sha('two_basis_structure_verify_physical_push_closed.py')
    for p,h in {**receipt['source_hashes'],**receipt['dependencies']}.items():
        assert sha(p)==h;bindings[p]=h
    matches=[p for p,h in receipt['source_hashes'].items() if h==receipt['allocation_sha256']]
    assert matches
    allocation=read(matches[0]);assert list(map(Q,allocation['exact_allocations'][mask]))==Y
    fp=matches[0].removesuffix('.json.gz').removesuffix('.json')+'.frozen.json'
    frozen=read(fp);assert Q(frozen['lambda_masses'][mask])==lam
    assert allocation['frozen_sha256']==sha(fp)
    bindings[str(path)]=sha(path);bindings[fp]=sha(fp)

def prepare(args):
    from verify_two_sided_full_basis_oracle import physical_source
    from colored_physical_domain_representation_draft import source_domain,represent
    c=read(args.certificate);r=read(args.receipt)
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['certificate_sha256']==sha(args.certificate)
    assert r['consumer_sha256']==sha('verify_owner_capacity_joint_literal.py')
    assert r['point_sha256']==c['point_sha256']==sha(c['point'])
    bindings={str(args.certificate):sha(args.certificate),str(args.receipt):sha(args.receipt)}
    for p,h in {**c['source_bindings'],**r['source_hashes'],**r['dependencies']}.items():
        assert sha(p)==h;bindings[p]=h
    assert sha(c['semantic'])==c['semantic_sha256']==r['model_sha256']
    M=read(c['semantic'])['model'];meta=M['owner_flow_extension'];m=args.mask
    assert type(m)is int and 0<=m<16
    probe_side=args.probe_side;side='Z' if probe_side=='X' else 'X';i=args.probe
    assert any(s['side']==probe_side and s['probe']==i for s in meta['stars'])
    lam=Q(c['lambda_masses'][m]);Y={s:list(map(Q,c['exact_allocations'][s][m])) for s in ('X','Z')}
    a=Y[probe_side][i];assert lam>0 and a>0
    for s,path in [('X',args.membership_X),('Z',args.membership_Z)]:
        membership_gate(path,s,m,Y[s],lam,c['point_sha256'],bindings)
    X,Z,bridge=physical_source();pools={'X':X,'Z':Z};U,V=pools[side],pools[probe_side]
    own=M[side+'_anchors'];opp=M[probe_side+'_anchors'];offset=0 if side=='X' else 2;otheroff=2-offset
    specs=dict(selected_opposite=sorted(j for k,j in enumerate(opp) if m>>(otheroff+k)&1),
               selected_own=sorted(j for k,j in enumerate(own) if m>>(offset+k)&1),
               absent_own=sorted(j for k,j in enumerate(own) if not(m>>(offset+k)&1)))
    assert i not in opp and V[i] and all(V[i]!=V[j] for j in specs['selected_opposite'])
    domain=source_domain(U,V,dimension=128,**specs);assert domain['feasible']
    augmented=source_domain(U,V,dimension=128,**dict(specs,selected_opposite=sorted(specs['selected_opposite']+[i])))
    assert augmented['feasible']
    proxy=represent(U,domain);N=[j for j,v in enumerate(U) if (v&V[i]).bit_count()%2]
    params=list(map(Q,c['exact_parameters']));t=[Q(0)]*720;seen=[]
    for mm,x,z,var in meta['cells']:
        if mm==m and (x if probe_side=='X' else z)==i:
            j=z if probe_side=='X' else x;t[j]=params[var];seen.append(j)
    assert sorted(seen)==N
    assert all(max(Q(0),a+Y[side][j]-lam)<=t[j]<=min(a,Y[side][j]) for j in N)
    problem=make_problem(proxy['vectors'],N,Y[side],t,a,lam)
    tiny=read(args.tiny_receipt)
    assert tiny['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_TINY_CONTROLS'
    assert tiny['producer_sha256']==sha(Path(__file__).name)
    for p,h in tiny['source_hashes'].items():assert sha(p)==h;bindings[p]=h
    names=[Path(__file__).name,'exact_colored_matroid_push_relabel_draft.py',
           'colored_physical_domain_representation_draft.py','verify_two_sided_full_basis_oracle.py',
           'verify_owner_capacity_joint_literal.py','two_basis_structure_verify_physical_push_closed.py',
           'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',c['semantic'],
           'OWNER-FLOW-FIXED-NEIGHBOR-RANK.md',str(args.tiny_receipt)]
    bindings.update({p:sha(p) for p in names})
    out=dict(status='FROZEN_FIXED_OWNER_RESIDUAL_RANK_QUERY_REQUIRES_PREPARATION_REPLAY',
             source_hashes=bindings,certificate=str(args.certificate),receipt=str(args.receipt),
             semantic=c['semantic'],point=c['point'],point_sha256=c['point_sha256'],
             mask=m,probe_side=probe_side,probe=i,side=side,X_anchors=M['X_anchors'],Z_anchors=M['Z_anchors'],
             domain_specs=specs,augmented_domain_specs=dict(specs,selected_opposite=sorted(specs['selected_opposite']+[i])),
             problem=encode_problem(problem),source_bridge=bridge,
             membership_receipts={'X':str(args.membership_X),'Z':str(args.membership_Z)},
             tiny_receipt=str(args.tiny_receipt),solver_caps=dict(seconds=args.seconds,maximum_steps=1000000,maximum_bases=5000),
             priority=19,threads=1,physical_query_launched=False,
             scope='One selected pattern/probe, retaining its accepted complete owner flow; no source-frame or global-target conclusion.')
    write(args.output,out);print(json.dumps(dict(status=out['status'],output=str(args.output),sha256=sha(args.output),mask=m,probe=i,side=side)),flush=True)

def worker(args):
    f=read(args.frozen);review=read(args.preparation_receipt)
    assert review['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION'
    assert review['frozen_sha256']==sha(args.frozen)
    for p,h in f['source_hashes'].items():assert sha(p)==h
    for p,h in review['source_hashes'].items():assert sha(p)==h
    problem=decode_problem(f['problem'])
    from exact_colored_matroid_push_relabel_draft import solve
    e=solve(problem['vectors_by_color'],problem['color_masses'],problem['normalized_target'],**f['solver_caps'])
    cut=None
    if e['violated_weighted_rank'] is not None:
        cut=translate_cut(problem,e['violated_weighted_rank']['indices'])
        assert Q(cut['normalized_violation'])==Q(e['violated_weighted_rank']['exact_violation'])>0
        assert cut['solver_ranks']==e['violated_weighted_rank']['ranks_by_color']
    out=dict(status='FIXED_OWNER_RESIDUAL_RANK_ENDPOINT_REQUIRES_REPLAY',frozen_sha256=sha(args.frozen),
             preparation_receipt_sha256=sha(args.preparation_receipt),endpoint=e,translated_cut=cut,
             global_target_exclusion_proved=False,source_C16_answered=False,priority=19)
    write(args.output,out);print(json.dumps(dict(status=e['status'],seconds=e['seconds'],translated_cut=cut)),flush=True)

def main():
    runtime_guard();p=argparse.ArgumentParser();sub=p.add_subparsers(dest='mode',required=True)
    a=sub.add_parser('prepare')
    for name in ('certificate','receipt','membership-X','membership-Z','tiny-receipt','output'):a.add_argument('--'+name,type=Path,required=True)
    a.add_argument('--mask',type=int,required=True);a.add_argument('--probe-side',choices=['X','Z'],required=True);a.add_argument('--probe',type=int,required=True)
    a.add_argument('--seconds',type=float,default=30)
    a=sub.add_parser('worker')
    for name in ('frozen','preparation-receipt','output'):a.add_argument('--'+name,type=Path,required=True)
    args=p.parse_args();assert args.mode!='prepare' or 0<args.seconds<=60
    globals()[args.mode](args)

if __name__=='__main__':main()
