#!/usr/bin/env python3
"""Finite exact controls of the dummy adapter; no physical query."""
from fractions import Fraction as Q
from itertools import combinations
from pathlib import Path
import argparse, copy, time
from fixed_owner_residual_rank import runtime_guard,rank,make_problem,encode_problem,decode_problem,translate_cut,sha,write
from exact_colored_matroid_push_relabel_draft import solve

def bases(vectors):
    R=rank(vectors)
    return [list(S) for S in combinations(range(len(vectors)),R) if rank(vectors[j] for j in S)==R]

def check_endpoint(p,e):
    n=p['dummy_index']+1;D=int(e['denominator']);mass=[0,0];achieved=[0]*n
    for b in e['bases']:
        c=b['color'];S=b['indices'];w=int(b['weight_numerator'])
        assert c in (0,1) and w>0 and S==sorted(set(S)) and len(S)==p['original_rank']
        assert rank(p['vectors_by_color'][c][j] for j in S)==p['original_rank']
        assert (p['dummy_index'] in S)==(c==0)
        mass[c]+=w
        for j in S:achieved[j]+=w
    assert [Q(w,D) for w in mass]==p['color_masses']
    assert achieved==list(map(int,e['achieved_numerators']))
    target=p['normalized_target'];maxgap=Q(0);subset_checks=0;translation_checks=0
    for bits in range(1<<n):
        S=[j for j in range(n) if bits>>j&1]
        gap=sum(target[j] for j in S)-sum(w*rank(V[j] for j in S) for w,V in zip(p['color_masses'],p['vectors_by_color']))
        row=translate_cut(p,S);assert Q(row['normalized_violation'])==gap
        subset_checks+=1;translation_checks+=1;maxgap=max(maxgap,gap)
    if e['status']=='EXACT_COLORED_BASE_MIXTURE':
        assert maxgap==0 and [Q(w,D) for w in achieved]==target
    elif e['status']=='EXACT_WEIGHTED_RANK_VIOLATION':
        row=translate_cut(p,e['violated_weighted_rank']['indices'])
        assert Q(row['normalized_violation'])==Q(e['violated_weighted_rank']['exact_violation'])>0 and maxgap>0
    else:raise AssertionError(('unexpected bounded tiny endpoint',e['status']))
    return subset_checks,translation_checks

def main():
    runtime_guard();ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    started=time.monotonic();cases=[];facechecks=subsets=translations=0;statuses={};dedup=set()
    pools=[[0,1,1],[1,2,3],[0,1,2,3],[1,2,3,1],[1,2,4,7],[1,2,3,4,5,6,7]]
    for V in pools:
        n=len(V);R=rank(V);BB=bases(V)
        for bits in range(1<<n):
            N=[j for j in range(n) if bits>>j&1];H=[j for j in range(n) if not(bits>>j&1)]
            if rank(V[j] for j in H)!=R-1:continue
            G=[j for j in N if rank([V[k] for k in H]+[V[j]])==R]
            if not G:continue
            HB=[list(B) for B in combinations(H,R-1) if rank(V[j] for j in B)==R-1]
            face=sorted(tuple(B) for B in BB if len(set(B)&set(N))==1)
            product=sorted(tuple(sorted(B+[g])) for B in HB for g in G)
            assert product==face;facechecks+=1
            scenarios=[]
            for alpha in (Q(0),Q(1,3),Q(1,2),Q(1)):
                BS=list(face[0]);BR=BB[-1];g=next(j for j in BS if j in N)
                z=[alpha*int(j in BS)+(1-alpha)*int(j in BR) for j in range(n)]
                t=[alpha*int(j==g) for j in range(n)];scenarios.append((alpha,z,t))
            # Original-basis targets with a fixed proposed owner can be outside
            # the two-color sum. Exhaustive subset ranks decide each tiny case.
            for B in BB[:3]:
                for g in sorted(set(B)&set(G))[:2]:
                    scenarios.append((Q(1,2),[Q(int(j in B)) for j in range(n)],[Q(1,2)*int(j==g) for j in range(n)]))
            for alpha,z,t in scenarios:
                lam=Q(2,7);p=make_problem(V,N,[lam*q for q in z],[lam*q for q in t],lam*alpha,lam)
                encoded=encode_problem(p);key=str(encoded)
                if key in dedup:continue
                dedup.add(key);e=solve(p['vectors_by_color'],p['color_masses'],p['normalized_target'],seconds=1,maximum_steps=10000,maximum_bases=100,verify_invariants=True)
                sc,tc=check_endpoint(p,e);subsets+=sc;translations+=tc;statuses[e['status']]=statuses.get(e['status'],0)+1
                cases.append(dict(problem=encoded,endpoint=e))
                assert time.monotonic()-started<90,'tiny controls discovery cap'
    # Root's physical GF(2)^3 fixture: old complete local split and all
    # one-probe owner/Frechet rows hold, but fixing the owner distribution
    # exposes a rank obstruction. Physical vectors, not indices, name laws.
    V=[1,2,4,5,6];N=[2,3,4];z=list(map(Q,['3/4','1/2','5/8','5/8','1/2']))
    t=list(map(Q,['0','0','1/8','1/8','1/4']));lam=Q(1);alpha=Q(1,2)
    old_selected=[([1,2,4],Q(1,4)),([1,2,5],Q(1,4))]
    old_residual=[([4,5,6],Q(1,4)),([1,4,6],Q(1,8)),([1,5,6],Q(1,8))]
    reconstructed=[Q(0)]*5
    for selected,law in [(True,old_selected),(False,old_residual)]:
        assert sum(w for B,w in law)==Q(1,2)
        for B,w in law:
            assert rank(B)==3
            if selected:assert sum((v&4).bit_count()%2 for v in B)==1
            for v in B:reconstructed[V.index(v)]+=w
    assert reconstructed==z
    assert all(max(Q(0),alpha+z[j]-1)<=t[j]<=min(alpha,z[j]) for j in N)
    p=make_problem(V,N,z,t,alpha,lam)
    e=solve(p['vectors_by_color'],p['color_masses'],p['normalized_target'],seconds=1,maximum_steps=10000,maximum_bases=100,verify_invariants=True)
    sc,tc=check_endpoint(p,e);subsets+=sc;translations+=tc;statuses[e['status']]=statuses.get(e['status'],0)+1
    fixture=translate_cut(p,[0,2,3]);assert Q(fixture['raw_violation'])==Q(1,4) and Q(fixture['old_split_raw_violation'])==0
    cases.append(dict(problem=encode_problem(p),endpoint=e,label='physical_rank3_fixed_owner_strictness'))
    rejected=[]
    for label in ('wrong-dummy-bit','wrong-target','wrong-owner-total','negative-owner'):
        q=copy.deepcopy(cases[-1]['problem'])
        if label=='wrong-dummy-bit':q['dummy_bit_hex']='0x0'
        elif label=='wrong-target':q['normalized_target'][0]=str(Q(q['normalized_target'][0])+1)
        elif label=='wrong-owner-total':q['probe_mass']=str(Q(q['probe_mass'])+Q(1,31))
        else:q['raw_owner_probabilities'][q['neighbors'][0]]='-1'
        try:decode_problem(q)
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(('accepted adapter mutant',label))
    out=dict(status='FIXED_OWNER_RESIDUAL_TINY_CONTROLS_REQUIRE_INDEPENDENT_REPLAY',cases=cases,
             counts=dict(cases=len(cases),face_factorizations=facechecks,all_subset_checks=subsets,dummy_translations=translations,statuses=statuses),
             corruptions_rejected=rejected,source_hashes={p:sha(p) for p in (Path(__file__).name,'fixed_owner_residual_rank.py','exact_colored_matroid_push_relabel_draft.py','OWNER-FLOW-FIXED-NEIGHBOR-RANK.md')},
             strictness_fixture=dict(physical_vectors=V,probe_vector=4,old_selected_law=[dict(vectors=B,weight=str(w)) for B,w in old_selected],old_residual_law=[dict(vectors=B,weight=str(w)) for B,w in old_residual],row=fixture,scope='Local rank-three interface, not a C16 source example.'),
             elapsed_seconds=time.monotonic()-started,physical_queries=0,priority=19)
    write(a.output,out);print({k:v for k,v in out.items() if k not in ('cases','source_hashes')},flush=True)

if __name__=='__main__':main()
