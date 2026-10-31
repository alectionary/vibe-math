#!/usr/bin/env python3
"""Independent physical preparation and literal fixed-owner endpoint replay.

No discovery producer, representation producer, or colored solver is imported.
Rank-cut acceptance uses the elementary unique-owner removal inequality. The
stronger face identity is checked separately for colored membership equivalence.
"""
from fractions import Fraction as Q
from pathlib import Path
import argparse, copy, gzip, hashlib, json, os, time
from verify_colored_physical_endpoint_draft import (
    rank, checked_indices, rebuild_domain, physical_domain_rank, check_full_basis)
from verify_two_sided_full_basis_oracle import physical_source

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
         'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p):return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def write(p,obj):
    p=ROOT/p;assert not p.exists();p.write_text(json.dumps(obj,sort_keys=True,indent=2)+'\n')
def bound(sources):
    for p,h in sources.items():assert sha(p)==h,(p,h)
def low_rows(vectors):
    rows={}
    for v in vectors:
        while v:
            p=v&-v
            if p in rows:v^=rows[p]
            else:rows[p]=v;break
    return rows
def reduce(v,rows):
    for p in sorted(rows):
        if v&p:v^=rows[p]
    return v
def independent_proxy(U,d):
    F,E,bins=d['F'],d['E'],d['bins'];k=len(F)+len(bins);rows=low_rows(U[j] for j in F)
    out=[0]*len(U)
    for i,j in enumerate(F):out[j]=1<<i
    for j in E:out[j]=reduce(U[j],rows)<<k
    for i,B in enumerate(bins):
        for j in B:out[j]=1<<(len(F)+i)
    return out
def verify_proxy(U,d,V):
    """Prove all-subset equivalence, not just some matching rank queries."""
    F,E,bins=d['F'],d['E'],d['bins'];k=len(F)+len(bins)
    assert len(V)==len(U) and all(type(v)is int and v>=0 for v in V)
    rows=low_rows(U[j] for j in F);q=[]
    pieces=set(F+E)|{j for B in bins for j in B}
    for j in range(len(U)):
        if j not in pieces:assert V[j]==0
    for i,j in enumerate(F):assert V[j]==1<<i
    for i,B in enumerate(bins):
        for j in B:assert V[j]==1<<(len(F)+i)
    for j in E:
        assert V[j]&((1<<k)-1)==0
        v=V[j]>>k;assert v<1<<128 and reduce(v^U[j],rows)==0;q.append(v)
    assert rank(q)==d['zero_rank']-len(F)
    assert rank(q+[U[j] for j in F])==rank(q)+len(F)
    assert rank(V)==128
    return dict(quotient_equivalence_columns=len(E),private_coloops=len(F),parallel_owner_bins=len(bins),
                all_subset_rank_equivalence_proved=True)
def coordinates(V,B):
    rows={}
    for k,j in enumerate(B):
        v=V[j];c=1<<k
        while v:
            p=v&-v
            if p in rows:v^=rows[p][0];c^=rows[p][1]
            else:rows[p]=(v,c);break
        assert v
    out=[]
    for v in V:
        c=0
        while v:
            p=v&-v;assert p in rows
            v^=rows[p][0];c^=rows[p][1]
        out.append(c)
    return out
def common_representation(V,W):
    rows={};B=[]
    for j,v in enumerate(V):
        r=reduce(v,rows)
        if r:rows[r&-r]=r;B.append(j)
    assert len(B)==128 and rank(W[j] for j in B)==128
    assert coordinates(V,B)==coordinates(W,B)
    return B

def context(f):
    assert f['status']=='FROZEN_FIXED_OWNER_RESIDUAL_RANK_QUERY_REQUIRES_PREPARATION_REPLAY'
    bound(f['source_hashes']);c=read(f['certificate']);r=read(f['receipt'])
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['certificate_sha256']==sha(f['certificate']) and r['consumer_sha256']==sha('verify_owner_capacity_joint_literal.py')
    bound(c['source_bindings']);bound(r['source_hashes']);bound(r['dependencies'])
    assert c['semantic']==f['semantic'] and c['semantic_sha256']==r['model_sha256']==sha(f['semantic'])
    assert c['point']==f['point'] and c['point_sha256']==r['point_sha256']==f['point_sha256']==sha(f['point'])
    M=read(f['semantic'])['model'];meta=M['owner_flow_extension']
    m=f['mask'];assert type(m)is int and 0<=m<16
    ps=f['probe_side'];assert ps in ('X','Z');side='Z' if ps=='X' else 'X';assert f['side']==side
    i=f['probe'];assert type(i)is int and 0<=i<720
    assert any(s['side']==ps and s['probe']==i for s in meta['stars'])
    assert f['X_anchors']==M['X_anchors'] and f['Z_anchors']==M['Z_anchors']
    lam=Q(c['lambda_masses'][m]);Y={s:list(map(Q,c['exact_allocations'][s][m])) for s in ('X','Z')}
    a=Y[ps][i];assert lam>0 and 0<a<=lam
    for s,rp in f['membership_receipts'].items():
        rr=read(rp);assert rr['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE'
        assert rr['side']==s and rr['selected_mask']==m and rr['point_sha256']==f['point_sha256']
        assert rr['endpoint']['local_mask_membership_proved'] is True
        assert rr['consumer_sha256']==sha('two_basis_structure_verify_physical_push_closed.py')
        bound(rr['source_hashes']);bound(rr['dependencies'])
        paths=[p for p,h in rr['source_hashes'].items() if h==rr['allocation_sha256']];assert paths
        cc=read(paths[0]);assert list(map(Q,cc['exact_allocations'][m]))==Y[s]
        fp=paths[0].removesuffix('.json.gz').removesuffix('.json')+'.frozen.json'
        assert cc['frozen_sha256']==sha(fp) and Q(read(fp)['lambda_masses'][m])==lam
    assert set(f['membership_receipts'])=={'X','Z'}
    tiny=read(f['tiny_receipt']);assert tiny['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_TINY_CONTROLS'
    assert tiny['producer_sha256']==sha('fixed_owner_residual_rank.py')
    assert tiny['consumer_sha256']==sha('verify_fixed_owner_residual_tiny.py');bound(tiny['source_hashes'])
    X,Z,bridge=physical_source();assert bridge==f['source_bridge'];pools={'X':X,'Z':Z};U,O=pools[side],pools[ps]
    off=0 if side=='X' else 2;other=2-off
    spec=dict(selected_opposite=sorted(j for k,j in enumerate(M[ps+'_anchors']) if m>>(other+k)&1),
              selected_own=sorted(j for k,j in enumerate(M[side+'_anchors']) if m>>(off+k)&1),
              absent_own=sorted(j for k,j in enumerate(M[side+'_anchors']) if not(m>>(off+k)&1)))
    aug=dict(spec,selected_opposite=sorted(spec['selected_opposite']+[i]))
    assert i not in M[ps+'_anchors'] and spec==f['domain_specs'] and aug==f['augmented_domain_specs']
    d=rebuild_domain(U,O,spec,128);da=rebuild_domain(U,O,aug,128);assert d['feasible'] and da['feasible']
    N={j for j in range(720) if (U[j]&O[i]).bit_count()%2};H=set(range(720))-N
    params=list(map(Q,c['exact_parameters']));t=[Q(0)]*720;seen=[]
    for mm,x,z,var in meta['cells']:
        if mm==m and (x if ps=='X' else z)==i:
            j=z if ps=='X' else x;seen.append(j);t[j]=params[var]
    assert sorted(seen)==sorted(N) and len(seen)==len(N)
    assert sum(t)==a and all(max(Q(0),a+Y[side][j]-lam)<=t[j]<=min(a,Y[side][j]) for j in N)
    p=f['problem'];V=[int(v,16) for v in p['original_vectors_hex']];proxyproof=verify_proxy(U,d,V)
    assert p['neighbors']==sorted(N) and p['annihilator_indices']==sorted(H)
    rH=physical_domain_rank(U,d,sorted(H));assert rH==127==p['annihilator_rank'] and p['original_rank']==128
    G={j for j in N if physical_domain_rank(U,d,sorted(H|{j}))==128}
    assert G and p['effective_owner_indices']==sorted(G)
    assert all(t[j]==0 for j in range(720) if j not in G)
    assert Q(p['lambda_mass'])==lam and Q(p['probe_mass'])==a
    assert list(map(Q,p['raw_allocation']))==Y[side] and list(map(Q,p['raw_owner_probabilities']))==t
    bit=1<<max(v.bit_length() for v in V);assert int(p['dummy_bit_hex'],16)==bit and p['dummy_index']==720
    vv=[[v if j in H else 0 for j,v in enumerate(V)]+[bit],V+[0]]
    assert [[int(v,16) for v in row] for row in p['vectors_by_color_hex']]==vv
    q=[(z-t[j])/lam for j,z in enumerate(Y[side])]+[a/lam];masses=[a/lam,1-a/lam]
    assert list(map(Q,p['normalized_target']))==q and list(map(Q,p['color_masses']))==masses
    assert min(q)>=0 and sum(q)==128 and all(0<=z<=lam for z in Y[side])
    # A complete all-subset binary representation isomorphism proves the face,
    # rather than inferring it from a few sampled ranks or existing mixtures.
    face=[V[j] if j in H else bit if j in G else 0 for j in range(720)]
    augmented=independent_proxy(U,da);verify_proxy(U,da,augmented)
    faceB=common_representation(face,augmented);check_full_basis(U,O,da,faceB)
    return dict(f=f,U=U,O=O,d=d,da=da,N=N,H=H,G=G,z=Y[side],t=t,a=a,lam=lam,q=q,masses=masses,
                proxy_proof=proxyproof,face_common_basis=faceB)

def physical_cut(p,indices):
    A=checked_indices(indices,721);dummy=720 in A;S=[j for j in A if j<720]
    r0=physical_domain_rank(p['U'],p['d'],S)
    rH=physical_domain_rank(p['U'],p['d'],sorted(set(S)&p['H']))
    r1=physical_domain_rank(p['U'],p['da'],S)
    assert r1==rH+bool(set(S)&p['G'])
    raw=sum(p['z'][j]-p['t'][j] for j in S)+(r0-rH)*p['a']-r0*p['lam']
    old=sum(p['z'][j] for j in S)+(r0-r1)*p['a']-r0*p['lam']
    gain=p['a']*bool(set(S)&p['G'])-sum(p['t'][j] for j in set(S)&p['N'])
    assert raw-old==gain>=0
    return dict(indices=S,neighbor_indices=sorted(set(S)&p['N']),original_rank=r0,restricted_rank=rH,
                selected_face_rank=r1,probe_coefficient=r0-rH,lambda_coefficient=-r0,
                raw_violation=str(raw),normalized_violation=str(raw/p['lam']),old_split_raw_violation=str(old),
                fixed_owner_improvement=str(gain),specifically_uses_fixed_owner_distribution=raw>0 and old<=0,
                dummy_in_solver_subset=dummy,solver_ranks=[rH+dummy,r0],
                inequality='sum_S z - sum_(S intersect N) t + (r0-rH)*a - r0*lambda <= 0')

def check_endpoint(p,c):
    assert c['status']=='FIXED_OWNER_RESIDUAL_RANK_ENDPOINT_REQUIRES_REPLAY'
    e=c['endpoint'];D=int(e['denominator']);assert D>0
    assert e['ground_size']==721 and e['common_rank']==128 and e['color_count']==2
    assert e['full_ranks_by_color']==[128,128] and list(map(Q,e['color_masses']))==p['masses']
    assert all((v*D).denominator==1 for v in p['q']+p['masses'])
    target=[int(v*D) for v in p['q']];cm=[int(v*D) for v in p['masses']]
    assert list(map(int,e['target_numerators']))==target and list(map(int,e['color_mass_numerators']))==cm
    assert e['positive_mass_colors']==[j for j in range(2) if cm[j]] and e['zero_mass_colors']==[j for j in range(2) if not cm[j]]
    got=[0]*721;mass=[0,0];seen=set();firstG=min(p['G'])
    for b in e['bases']:
        co=b['color'];assert type(co)is int and co in (0,1) and cm[co]>0
        B=checked_indices(b['indices'],721);assert len(B)==128
        if co==0:
            assert 720 in B;J=[j for j in B if j<720]
            assert set(J)<=p['H'] and rank(p['U'][j] for j in J)==127
            assert physical_domain_rank(p['U'],p['d'],J)==127
            check_full_basis(p['U'],p['O'],p['da'],sorted(J+[firstG]))
        else:
            assert 720 not in B;check_full_basis(p['U'],p['O'],p['d'],B)
        key=co,tuple(B);assert key not in seen;seen.add(key)
        w=int(b['weight_numerator']);assert str(w)==b['weight_numerator'] and w>0;mass[co]+=w
        for j in B:got[j]+=w
    assert mass==cm==list(map(int,e['achieved_color_mass_numerators']))
    assert got==list(map(int,e['achieved_numerators'])) and sum(got)==128*D
    assert e.get('maximum_active_bases',len(seen))<=5000
    status=e['status'];cut=e['violated_weighted_rank'];literal=None
    if status=='EXACT_COLORED_BASE_MIXTURE':assert got==target and cut is None and c['translated_cut'] is None
    elif status=='EXACT_WEIGHTED_RANK_VIOLATION':
        literal=physical_cut(p,cut['indices']);assert literal==c['translated_cut']
        assert Q(literal['raw_violation'])>0 and literal['solver_ranks']==cut['ranks_by_color']
        weighted=sum(w*r for w,r in zip(cm,literal['solver_ranks']));left=sum(target[j] for j in cut['indices'])
        assert int(cut['weighted_rank_numerator'])==weighted and Q(cut['weighted_rank'])==Q(weighted,D)
        assert Q(cut['target_mass'])==Q(left,D) and Q(cut['exact_violation'])==Q(left-weighted,D)==Q(literal['normalized_violation'])
    else:assert status=='BOUNDED_COLORED_PUSH_RELABEL_INCONCLUSIVE' and cut is None and c['translated_cut'] is None
    return dict(endpoint_status=status,literal_colored_bases_checked=len(seen),literal_coordinates_checked=721,
                exact_fixed_owner_membership=status=='EXACT_COLORED_BASE_MIXTURE',literal_rank_cut=literal,
                source_valid_cut_proof='Unique owner removal and independent residual subset ranks; no face theorem needed for necessity.',
                proxy_ranks_used_for_endpoint_acceptance=False,global_target_exclusion_proved=False,source_C16_answered=False)

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['prepare','endpoint','screen'])
    ap.add_argument('--frozen',required=True);ap.add_argument('--preparation-receipt');ap.add_argument('--certificate');ap.add_argument('--output',required=True);args=ap.parse_args()
    f=read(args.frozen);p=context(f);mutants=[]
    sources={**f['source_hashes'],args.frozen:sha(args.frozen),Path(__file__).name:sha(Path(__file__).name),
             'verify_colored_physical_endpoint_draft.py':sha('verify_colored_physical_endpoint_draft.py')}
    if args.mode=='prepare':
        for name,change in [('wrong_raw_probe',lambda x:x['problem'].__setitem__('probe_mass','0')),
                            ('wrong_flow',lambda x:x['problem']['raw_owner_probabilities'].__setitem__(min(p['N']),'1')),
                            ('wrong_proxy',lambda x:x['problem']['original_vectors_hex'].__setitem__(0,'0x0'))]:
            bad=copy.deepcopy(f);change(bad)
            try:context(bad)
            except (AssertionError,ValueError,KeyError):mutants.append(name)
            else:raise AssertionError(('accepted mutation',name))
        out=dict(status='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION',mask=f['mask'],probe=f['probe'],side=f['side'],
                 original_rank=128,restricted_rank=127,effective_owner_count=len(p['G']),
                 physical_proxy_proof=p['proxy_proof'],augmented_face_all_subset_identity_proved=True,
                 face_common_basis=p['face_common_basis'],actual_owner_flow_retained=True,
                 both_sector_mask_membership_receipts_checked=True,corruptions_rejected=mutants,physical_query_launched=False)
    else:
        pr=read(args.preparation_receipt);assert pr['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION'
        assert pr['frozen_sha256']==sha(args.frozen) and pr['consumer_sha256']==sha(Path(__file__).name);bound(pr['source_hashes'])
        c=read(args.certificate);assert c['frozen_sha256']==sha(args.frozen)
        if args.mode=='endpoint':
            assert c['preparation_receipt_sha256']==sha(args.preparation_receipt);out=check_endpoint(p,c)
            for label in ('negative_weight','wrong_marginal','wrong_cut_or_target'):
                bad=copy.deepcopy(c)
                if label=='negative_weight':bad['endpoint']['bases'][0]['weight_numerator']='-1'
                elif label=='wrong_marginal':bad['endpoint']['achieved_numerators'][0]=str(int(bad['endpoint']['achieved_numerators'][0])+1)
                elif bad['translated_cut'] is not None:bad['translated_cut']['restricted_rank']+=1
                else:bad['endpoint']['target_numerators'][0]=str(int(bad['endpoint']['target_numerators'][0])+1)
                try:check_endpoint(p,bad)
                except (AssertionError,ValueError,KeyError,IndexError):mutants.append(label)
                else:raise AssertionError(('accepted mutation',label))
            out.update(status='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PHYSICAL_ENDPOINT',corruptions_rejected=mutants)
        else:
            raise AssertionError('Screen schema must be independently frozen in a separate consumer version.')
        out.update(certificate_sha256=sha(args.certificate));sources[args.certificate]=sha(args.certificate)
        sources[args.preparation_receipt]=sha(args.preparation_receipt)
    out.update(frozen_sha256=sha(args.frozen),consumer_sha256=sha(Path(__file__).name),point_sha256=f['point_sha256'],
               source_hashes=sources,priority=19,elapsed_seconds=time.monotonic()-start,
               scope='One fixed law/pattern/probe and its retained flow. No whole source-frame or global moment exclusion.')
    write(args.output,out);print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','face_common_basis')},sort_keys=True))
if __name__=='__main__':main()
