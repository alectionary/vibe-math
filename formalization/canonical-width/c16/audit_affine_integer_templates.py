#!/usr/bin/env python3
"""Finite exact parameter coverage for ±1 Boolean affine integer forms.

No physical placements, optimization, separation or source-frame search.
"""
from collections import Counter
from fractions import Fraction as Q
from math import comb
from pathlib import Path
import json
from verify_two_sided_full_basis_oracle import ROOT,sha,read


def polynomial(weights,c):
    p=Counter({():Q(c*(c-1),2)})
    for i,w in enumerate(weights):p[(i,)]+=c*w+Q(w*(w-1),2)
    for i,w in enumerate(weights):
        for j,v in enumerate(weights[:i]):p[(j,i)]+=w*v
    return {k:v for k,v in p.items() if v}

def add(p,q,factor=1):
    r=Counter(p)
    for k,v in q.items():r[k]+=factor*v
    return {k:v for k,v in r.items() if v}

def multiply(p,q):
    r=Counter()
    for a,u in p.items():
        for b,v in q.items():r[tuple(sorted(set(a+b)))]+=u*v
    return {k:v for k,v in r.items() if v}

def literal_poly(i,complement):return {():1,(i,):-1} if complement else {(i,):1}

def pair_bound_decomposition(weights,s,opposite=False):
    literals=[literal_poly(i,(w<0)^opposite) for i,w in enumerate(weights)]
    out={():Q(s*(s-1),2)} if s>1 else {}
    for i,L in enumerate(literals):
        out=add(out,L,s)
        for M in literals[:i]:out=add(out,multiply(L,M))
    return out

def canonical(k,q,c):
    t=q-c
    if t<=0 or t>=k-1:return None
    qq,tt=min((q,t),(k-q,k-1-t),key=lambda z:(z[1],z[0]))
    return (k,qq,qq-tt)

def main():
    outpath=ROOT/'two-basis-results/affine-integer-template-coverage.json';assert not outpath.exists()
    rows=[];hist={};reflection=decomposition=rangechecks=truthpairs=0;booleanassignments=0
    for k in range(3,13):
        reps=set()
        for q in range(k+1):
            w=[1]*(k-q)+[-1]*q
            for t in range(1,k-1):reps.add(canonical(k,q,q-t))
            # Both trivial tails have polynomial identities of degree at most2
            # in s. Three exact values certify every coefficient identity in s.
            for s in [0,1,2]:
                assert polynomial(w,q+s)==pair_bound_decomposition(w,s);decomposition+=1
                t=k-1+s;assert polynomial(w,q-t)==pair_bound_decomposition(w,s,opposite=True);decomposition+=1
            for c in range(-2*k,2*k+2):
                assert polynomial(w,c)==polynomial([-v for v in w],1-c);reflection+=1
                t=q-c;r=canonical(k,q,c)
                if r is None:assert t<=0 or t>=k-1
                else:
                    _,qq,cc=r;tt=qq-cc
                    assert 1<=tt<=k-2 and (tt<k-1-tt or tt==k-1-tt and qq<=k-qq)
                    assert r==canonical(k,k-q,1-c)
                rangechecks+=1
        hist[k]=len(reps)
        for _,q,c in sorted(reps,key=lambda r:(r[1]-r[2],r[1])):
            p=k-q;t=q-c;w=[1]*p+[-1]*q;coverage=0
            for positive in range(p+1):
                for negative in range(q+1):
                    L=c+positive-negative;assert L*(L-1)>=0
                    coverage+=comb(p,positive)*comb(q,negative);truthpairs+=1
            assert coverage==2**k;booleanassignments+=coverage
            rows.append(dict(template_id=len(rows),arity=k,positive_weights=p,negative_weights=q,constant=c,threshold=t,weights=w,
                             reflected_parameters=dict(negative_weights=k-q,constant=1-c,threshold=k-1-t),
                             complete_three_event_family=(k==3)))
    expected={3:2,4:5,5:9,6:14,7:20,8:27,9:35,10:44,11:54,12:65}
    assert hist==expected and len(rows)==275
    # Match only the explicitly inspected physical template banks/commands.
    current=read(ROOT/'two-basis-results/unbalanced-integer-witness18-frozen.json');attempted=set();outside=[]
    for command in current['commands']:
        weights=list(map(int,command[3].split(',')));c=int(command[7])
        if all(abs(w)==1 for w in weights):attempted.add(canonical(len(weights),sum(w<0 for w in weights),c))
        else:outside.append(dict(weights=weights,constant=c))
    balanced={(k,(k-1)//2,0) for k in [5,7,9,11]};triples={(3,0,-1),(3,1,0)}
    known=attempted|balanced|triples;assert len(attempted)==5 and len(known)==11
    for r in rows:
        key=(r['arity'],r['negative_weights'],r['constant'])
        r['covered_parameter_class_by_inspected_odd_templates_or_new_scout_or_complete_triples']=key in known
    proof=[
      'Let q be the number of negative weights, Yi=Xi at positive positions and Yi=1-Xi at negative positions. Then N=sumYi and L=c+sum wiXi=N-t with t=q-c. This is an algebraic rewrite; complemented literals are not identified with physical pool events.',
      'The literal range is0<=N<=k. If t<=0, put s=-t. Then choose(L,2)=sum_{i<j}YiYj+s sumYi+choose(s,2), a nonnegative combination of pair Frechet/marginal inequalities and a nonnegative integer constant.',
      'If t>=k-1, replace L by1-L and N byk-N. The same formula applies with s=t-k+1. Thus only1<=t<=k-2 need retained templates; no unsupported modulus/cardinality reduction is used.',
      'choose(L,2)=choose(1-L,2) exactly. This changes q to k-q and t to k-1-t, or c to1-c and every weight sign. Event permutations preserve a sign-count class. Choose the smaller threshold, and at the middle threshold choose q<=floor(k/2).',
      'For k3 the two representatives are(c=-1,allpositive), the union row, and(c=0,two positive/one negative), a triangle row. Existing complete triple closure covers all their placements.',
      'The275 representatives cover these parameter choices only, not event placements. They are not asserted to be irredundant, facet-defining, or all integer-weight forms.273 representatives remain after removing the two classes already disposed by triple closure.'
    ]
    out=dict(status='PASS_EXACT_AFFINE_TEMPLATE_PARAMETER_COVERAGE',source_C16_answered=False,auditor_sha256=sha(__file__),arity_range=[3,12],allowed_weights=[-1,1],constant_domain='allintegers',canonical_templates=rows,canonical_count=275,count_after_complete_triples=273,count_by_arity=hist,
      exact_reflection_polynomial_checks=reflection,exact_trivial_tail_decomposition_checks=decomposition,constant_range_controls=rangechecks,truth_count_pair_checks=truthpairs,Boolean_assignments_covered_by_multiplicity=booleanassignments,
      inspected_parameter_classes_present=len(known),inspected_current_unbalanced_pm1_classes=len(attempted),current_unbalanced_templates_outside_pm1_scope=outside,
      inspected_scout_frozen_sha256=sha(ROOT/'two-basis-results/unbalanced-integer-witness18-frozen.json'),proof=proof,
      cardinality_caveat='Each physical sector selects128 of720 events. N_A=128-N_(pool\\A) is a valid full-support rewrite, but generally replaces a k<=12 support by708ormore selectors. Adding128 to c alone is not an equivalence. Bit complements1-Xi are valid algebraic literals but no complement-event lookup or source-frame complement symmetry is assumed. The separate-sector count scout may eliminate one full count group because it permits arbitrary integer coefficients and carries the induced constant shift exactly.',
      immediate_small_parameter_cohort=[r for r in rows if r['arity']==4],
      next_even_arity_and_offset_cohort=[r for r in rows if r['arity']in[4,6,8,10,12] and (r['constant']!=0 or not r['covered_parameter_class_by_inspected_odd_templates_or_new_scout_or_complete_triples'])],
      no_scout_or_solver_run=True,source_case_excluded=False,scope='Exact finite parameter quotient and range-dominance proof for arity3..12 ±1 affine Boolean integer forms. This does not certify completeness of any sampled placements or of the global source relaxation.')
    outpath.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','canonical_count','count_after_complete_triples','count_by_arity','exact_reflection_polynomial_checks','exact_trivial_tail_decomposition_checks','truth_count_pair_checks','Boolean_assignments_covered_by_multiplicity']},indent=2))

if __name__=='__main__':main()
