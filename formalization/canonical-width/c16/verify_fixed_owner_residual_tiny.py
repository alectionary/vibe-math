#!/usr/bin/env python3
"""Independent finite fixed-owner replay. No producer or solver import.

Ranks below use exhaustive binary spans, deliberately independent of the
producer's elimination and the physical consumer's low-pivot elimination.
"""
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path
import argparse, copy, gzip, hashlib, json, os, time

ROOT=Path(__file__).resolve().parent
THREADS=('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS',
         'VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS')
def guard():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    assert all(os.environ.get(k)=='1' for k in THREADS)
def sha(p): return hashlib.sha256((ROOT/p).read_bytes()).hexdigest()
def read(p):
    b=(ROOT/p).read_bytes()
    return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
def write(p,obj):
    p=ROOT/p; assert not p.exists()
    p.write_text(json.dumps(obj,sort_keys=True,indent=2)+'\n')
def span(v):
    s={0}
    for x in v:
        assert type(x)is int and x>=0
        s |= {u^x for u in s}
    return s
def rank(v):
    n=len(span(v)); assert n&(n-1)==0
    return n.bit_length()-1
def indices(v,n):
    assert v==sorted(set(v)) and all(type(j)is int and 0<=j<n for j in v)
    return v
def subset(mask,n): return [j for j in range(n) if mask>>j&1]

def problem(p):
    v=[int(x,16) for x in p['original_vectors_hex']]; n=len(v)
    N=set(indices(p['neighbors'],n)); H=set(range(n))-N
    R=rank(v); assert R>0 and p['original_rank']==R
    assert p['annihilator_indices']==sorted(H)
    sh=span(v[j] for j in H)
    assert len(sh)==1<<(R-1) and p['annihilator_rank']==R-1
    G={j for j in N if v[j] not in sh}
    assert G and p['effective_owner_indices']==sorted(G)
    z=list(map(Q,p['raw_allocation'])); t=list(map(Q,p['raw_owner_probabilities']))
    a,lam=Q(p['probe_mass']),Q(p['lambda_mass'])
    assert len(z)==len(t)==n and lam>0 and 0<=a<=lam
    assert all(0<=x<=lam for x in z) and sum(z)==R*lam
    assert all(0<=x<=z[j] for j,x in enumerate(t)) and sum(t)==a
    assert all(t[j]==0 for j in range(n) if j not in G)
    dummy=1<<max(x.bit_length() for x in v)
    assert p['dummy_index']==n and int(p['dummy_bit_hex'],16)==dummy
    vv=[[x if j in H else 0 for j,x in enumerate(v)]+[dummy],v+[0]]
    assert [[int(x,16) for x in row] for row in p['vectors_by_color_hex']]==vv
    q=[(z[j]-t[j])/lam for j in range(n)]+[a/lam]
    masses=[a/lam,1-a/lam]
    assert list(map(Q,p['normalized_target']))==q
    assert list(map(Q,p['color_masses']))==masses and sum(q)==R
    return dict(v=v,n=n,N=N,H=H,G=G,R=R,z=z,t=t,a=a,lam=lam,vv=vv,q=q,masses=masses)

def translated(p,S,dummy=False):
    S=set(S); r0=rank(p['v'][j] for j in S); rH=rank(p['v'][j] for j in S&p['H'])
    r1=rH+bool(S&p['G']); a,lam=p['a'],p['lam']
    raw=sum(p['z'][j]-p['t'][j] for j in S)+(r0-rH)*a-r0*lam
    old=sum(p['z'][j] for j in S)+(r0-r1)*a-r0*lam
    gain=a*bool(S&p['G'])-sum(p['t'][j] for j in S&p['N'])
    assert raw-old==gain and gain>=0
    return dict(indices=sorted(S),neighbor_indices=sorted(S&p['N']),original_rank=r0,
                restricted_rank=rH,selected_face_rank=r1,probe_coefficient=r0-rH,
                lambda_coefficient=-r0,raw_violation=str(raw),normalized_violation=str(raw/lam),
                old_split_raw_violation=str(old),fixed_owner_improvement=str(gain),
                specifically_uses_fixed_owner_distribution=raw>0 and old<=0,
                dummy_in_solver_subset=bool(dummy),solver_ranks=[rH+bool(dummy),r0],
                inequality='sum_S z - sum_(S intersect N) t + (r0-rH)*a - r0*lambda <= 0')

def endpoint(p,e):
    n,R=p['n']+1,p['R']; D=int(e['denominator']); assert D>0
    assert e['ground_size']==n and e['common_rank']==R and e['color_count']==2
    assert e['full_ranks_by_color']==[rank(v) for v in p['vv']]==[R,R]
    assert list(map(Q,e['color_masses']))==p['masses']
    assert all((x*D).denominator==1 for x in p['masses']+p['q'])
    cm=[int(x*D) for x in p['masses']]; target=[int(x*D) for x in p['q']]
    assert list(map(int,e['color_mass_numerators']))==cm
    assert list(map(int,e['target_numerators']))==target
    assert e['positive_mass_colors']==[c for c in range(2) if cm[c]]
    assert e['zero_mass_colors']==[c for c in range(2) if not cm[c]]
    actual=[0,0]; got=[0]*n; seen=set()
    for row in e['bases']:
        c=row['color']; assert type(c)is int and 0<=c<2 and cm[c]>0
        B=indices(row['indices'],n); assert len(B)==R and rank(p['vv'][c][j] for j in B)==R
        key=(c,tuple(B)); assert key not in seen;seen.add(key)
        w=int(row['weight_numerator']);assert w>0 and str(w)==row['weight_numerator']
        actual[c]+=w
        for j in B:got[j]+=w
    assert actual==cm==list(map(int,e['achieved_color_mass_numerators']))
    assert got==list(map(int,e['achieved_numerators']))
    if e['status']=='EXACT_COLORED_BASE_MIXTURE':
        assert got==target and e['violated_weighted_rank'] is None
    else:
        assert e['status']=='EXACT_WEIGHTED_RANK_VIOLATION'
        c=e['violated_weighted_rank'];S=indices(c['indices'],n)
        rr=[rank(v[j] for j in S) for v in p['vv']]
        bound=sum(x*r for x,r in zip(cm,rr));left=sum(target[j] for j in S)
        assert c['ranks_by_color']==rr and int(c['weighted_rank_numerator'])==bound
        assert Q(c['weighted_rank'])==Q(bound,D) and Q(c['target_mass'])==Q(left,D)
        assert Q(c['exact_violation'])==Q(left-bound,D)>0
        row=translated(p,[j for j in S if j<p['n']],p['n'] in S)
        assert Q(row['normalized_violation'])==Q(left-bound,D)
    return len(seen)

def face(p):
    # Every minimum-neighbor original basis factors into an H basis and one G.
    n,R=p['n'],p['R']; actual=set()
    for B in combinations(range(n),R):
        if rank(p['v'][j] for j in B)==R and len(set(B)&p['N'])==1:actual.add(B)
    expected={tuple(sorted(B+(j,))) for B in combinations(sorted(p['H']),R-1)
              if rank(p['v'][k] for k in B)==R-1 for j in p['G']}
    assert actual==expected and actual

def all_subsets(p,e):
    positive=0
    for mask in range(1<<(p['n']+1)):
        A=subset(mask,p['n']+1);S=[j for j in A if j<p['n']]
        row=translated(p,S,p['n'] in A)
        rr=[rank(v[j] for j in A) for v in p['vv']]
        gap=sum(p['q'][j] for j in A)-sum(m*r for m,r in zip(p['masses'],rr))
        assert rr==row['solver_ranks'] and gap==Q(row['raw_violation'])/p['lam']
        positive+=gap>0
    assert bool(positive)==(e['status']=='EXACT_WEIGHTED_RANK_VIOLATION')
    return 1<<(p['n']+1)

def strictness(b):
    c=next(c for c in b['cases'] if c.get('label')=='physical_rank3_fixed_owner_strictness')
    p=problem(c['problem']);s=b['strictness_fixture']
    assert p['v']==s['physical_vectors']==[1,2,4,5,6] and s['probe_vector']==4
    assert p['N']=={j for j,v in enumerate(p['v']) if (v&4).bit_count()%2}
    got=[Q(0)]*5;mass=Q(0);sel=Q(0)
    for kind in ('old_selected_law','old_residual_law'):
        for r in s[kind]:
            B=[p['v'].index(v) for v in r['vectors']];w=Q(r['weight'])
            assert w>0 and len(B)==3 and rank(r['vectors'])==3
            if kind=='old_selected_law':assert len(set(B)&p['N'])==1;sel+=w
            mass+=w
            for j in B:got[j]+=w
    assert mass==p['lam']==1 and sel==p['a']==Q(1,2) and got==p['z']
    assert all(max(Q(0),p['a']+p['z'][j]-p['lam'])<=p['t'][j]<=min(p['a'],p['z'][j]) for j in p['N'])
    row=translated(p,[0,2,3]);assert row==s['row']
    assert Q(row['raw_violation'])==Q(1,4) and Q(row['old_split_raw_violation'])==0
    return dict(old_colored_mixture=True,complete_one_star_flow=True,new_exact_gap='1/4',C16_strictness_claimed=False)

def main():
    guard();start=time.monotonic();ap=argparse.ArgumentParser()
    ap.add_argument('--bank',required=True);ap.add_argument('--output',required=True);args=ap.parse_args()
    b=read(args.bank);assert b['status']=='FIXED_OWNER_RESIDUAL_TINY_CONTROLS_REQUIRE_INDEPENDENT_REPLAY'
    for p,h in b['source_hashes'].items():assert sha(p)==h
    keys=set();checks=0;bases=0;statuses={}
    for c in b['cases']:
        p=problem(c['problem']);bases+=endpoint(p,c['endpoint']);checks+=all_subsets(p,c['endpoint'])
        key=(tuple(p['v']),tuple(sorted(p['N'])))
        if key not in keys:face(p);keys.add(key)
        st=c['endpoint']['status'];statuses[st]=statuses.get(st,0)+1
    strict=strictness(b)
    mutations=[]
    base=b['cases'][-1]
    for name,change in [
        ('wrong_original_rank',lambda c:c['problem'].__setitem__('original_rank',2)),
        ('wrong_dummy',lambda c:c['problem'].__setitem__('dummy_bit_hex','0x1')),
        ('wrong_target',lambda c:c['problem']['normalized_target'].__setitem__(0,'0')),
        ('wrong_owner_mass',lambda c:c['problem']['raw_owner_probabilities'].__setitem__(0,'1/8')),
        ('wrong_basis_weight',lambda c:c['endpoint']['bases'][0].__setitem__('weight_numerator','1')),
        ('wrong_cut_rank',lambda c:c['endpoint']['violated_weighted_rank']['ranks_by_color'].__setitem__(0,2)),
        ('wrong_cut_gap',lambda c:c['endpoint']['violated_weighted_rank'].__setitem__('exact_violation','1/2'))]:
        c=copy.deepcopy(base);change(c)
        try:endpoint(problem(c['problem']),c['endpoint'])
        except (AssertionError,ValueError,IndexError,KeyError):mutations.append(name)
        else:raise AssertionError(('accepted mutation',name))
    assert len(b['cases'])==420 and checks==b['counts']['all_subset_checks']==67552
    assert statuses==b['counts']['statuses']
    sources={**b['source_hashes'],args.bank:sha(args.bank),Path(__file__).name:sha(Path(__file__).name)}
    out=dict(status='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_TINY_CONTROLS',bank_sha256=sha(args.bank),
             producer_sha256=sha('fixed_owner_residual_rank.py'),consumer_sha256=sha(Path(__file__).name),
             source_hashes=sources,cases=len(b['cases']),all_subset_checks=checks,dummy_translations=checks,
             independently_factored_geometries=len(keys),literal_colored_bases_checked=bases,statuses=statuses,
             strictness_fixture=strict,corruptions_rejected=mutations,physical_queries=0,
             producer_imported=False,rank_method='exhaustive binary spans',priority=19,elapsed_seconds=time.monotonic()-start)
    write(args.output,out);print(json.dumps(out,sort_keys=True))
if __name__=='__main__':main()
