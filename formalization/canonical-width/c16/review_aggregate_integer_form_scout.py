#!/usr/bin/env python3
"""Bounded semantic/layout controls for aggregate LLL discovery reports.

No LLL, scout or solver is rerun. The saved transforms are absent, so their
reported short-vector minima are not independently recomputed here.
"""
from collections import Counter
from fractions import Fraction as Q
from pathlib import Path
import json
import math
from verify_two_sided_full_basis_oracle import ROOT,sha,read,point_owner,coordinate,physical_source
from verify_projected_profile_moment_rows import point_vector


def pair(s,o,h,t,p,k):
    if s==t and o==p and h==k:return o
    return coordinate('S' if s==t else 'T',(k-h)%16,o,p)


def quad(G,z):return sum(z[i]*G[i][j]*z[j] for i in range(len(z)) for j in range(len(z)))


def main():
    output=ROOT/'two-basis-results/aggregate-integer-form-scout-independent-review.json';assert not output.exists()
    point=ROOT/'coupling-results/two-basis-integer-witness18-rational.json.gz';owner=point_owner(point);assert owner==point_vector(point) and len(owner)==36495
    compact=list(map(Q,read(point)['values']));bad=[i for i,(a,b) in enumerate(zip(compact[:36495],owner)) if a!=b];assert bad
    invalidpath=ROOT/'two-basis-results/aggregate-lll-phase1-point18-invalid-attempt.json';invalid=read(invalidpath)
    assert invalid['status']=='DISCARDED_INVALID_COORDINATE_INPUT' and invalid['producer_sha256']==sha(ROOT/'aggregate_integer_form_scout.py')
    X,Z,physical=physical_source();D=math.lcm(*(v.denominator for v in owner));vi=[int(v*D) for v in owner]
    summaries=[];phase_checks=literal_checks=embedding_checks=0
    for q in [1,2,4]:
        path=ROOT/f'two-basis-results/aggregate-lll-phase{q}-point18-v2.json';report=read(path);frozenpath=path.with_suffix('.frozen.json');frozen=read(frozenpath)
        assert report['status']=='BOUNDED_AGGREGATE_LLL_NO_CUT' and not report['cuts'] and report['frozen_sha256']==sha(frozenpath)
        for key,value in frozen.items():
            if key!='status':assert report[key]==value
        assert report['point_sha256']==sha(point) and report['producer_sha256']==sha(ROOT/'aggregate_integer_form_scout_v2.py')
        assert report['point_loader_sha256']==sha(ROOT/'verify_projected_profile_moment_rows.py') and report['coordinate_sha256']==sha(ROOT/'physical_integer_form_rows.py')
        groups=[(s,o,r) for s in range(2) for o in range(45) for r in range(q) if (o,r)!=(44,q-1)]
        assert report['groups']==[list(g) for g in groups] and report['gram_dimension']==90*q-1 and Q(report['denominator'])==D
        n=16//q
        for r in range(q):
            for u in range(q):
                difference=Counter((k-h)%16 for h in range(r,16,q) for k in range(u,16,q))
                assert difference==Counter({h:n for h in range((u-r)%q,16,q)});phase_checks+=1
                for s,t in [(0,0),(0,1),(1,0),(1,1)]:
                    for o,p in [(0,0),(0,44),(12,32),(32,27),(44,44)]:
                        literal=sum(vi[pair(s,o,h,t,p,k)] for h in range(r,16,q) for k in range(u,16,q))
                        derived=n*sum(vi[pair(s,o,0,t,p,h)] for h in range((u-r)%q,16,q))
                        assert literal==derived;literal_checks+=1
        # Exact block-embedding identity on a target-derived sub-Gram, with
        # several signed odd k. This is a polynomial identity for arbitrary G.
        selected=groups[:3]+groups[-3:];g=[[D]+[n*vi[o] for s,o,r in selected]]
        for s,o,r in selected:
            g.append([n*vi[o]]+[n*sum(vi[pair(s,o,0,t,p,h)] for h in range((u-r)%q,16,q)) for t,p,u in selected])
        assert all(g[i][j]==g[j][i] for i in range(len(g)) for j in range(len(g)))
        disc=[[v+int(i==j) for j,v in enumerate(row)] for i,row in enumerate(g)]
        for den in [4,16,64]:
            assert D%(den*den)==0
            E=[[4*v for v in row]+[2*row[0]] for row in disc]+[[2*v for v in disc[0]]+[disc[0][0]+D//(den*den)]]
            for k in [-3,-1,1,3]:
                z=[((2*i+q)%5)-2 for i in range(len(g))];w=[*z,k]
                doubled=[2*v+(k if i==0 else 0) for i,v in enumerate(z)]
                assert quad(E,w)==quad(disc,doubled)+D*k*k//(den*den)
                c=z[0]+(k+1)//2;affine=[c,*z[1:]]
                value=quad(g,affine)-sum(affine[j]*g[0][j] for j in range(len(g)))
                reflected=[1-c,*[-v for v in z[1:]]]
                assert value==quad(g,reflected)-sum(reflected[j]*g[0][j] for j in range(len(g)))
                assert all(doubled[i]==2*affine[i]-int(i==0) for i in range(len(g)));embedding_checks+=1
        assert [r['alpha_denominator'] for r in report['records']]==[4,16,64]
        assert all(r['exact_congruence_verified'] and not r['new_candidate_ids'] and (r['minimum_integer_form_value']is None or Q(r['minimum_integer_form_value'])>=0) for r in report['records'])
        summaries.append(dict(phase_modulus=q,report_sha256=sha(path),frozen_sha256=sha(frozenpath),gram_dimension=report['gram_dimension'],reported_seconds=report['seconds'],reported_odd_rows=[r['odd_rows'] for r in report['records']],cuts=0,LLL_transforms_independently_replayed=False))
    out=dict(status='PASS_AGGREGATE_MAPPING_AND_DISCOVERY_SEMANTICS_NO_CUT',source_C16_answered=False,reviewer_sha256=sha(__file__),producer_v2_sha256=sha(ROOT/'aggregate_integer_form_scout_v2.py'),point_sha256=sha(point),physical_symmetry_bridge=physical,
        independent_owner_loader_coordinates_compared=36495,phase_difference_multiplicity_identities=phase_checks,literal_group_moment_checks=literal_checks,exact_block_embedding_and_reflection_controls=embedding_checks,
        discarded_v1_attempt_sha256=sha(invalidpath),v1_wrong_layout_coordinate_mismatches=len(bad),v1_first_wrong_owner_coordinate=bad[0],v1_any_cut_accepted=False,reports=summaries,
        proof_review=[
          'For group N_(s,o,r)=sum_{h=r modq}X_(s,o,h), E[N]=n p_o with n=16/q. Every relative phase delta congruentu-r modq occurs exactlyn times, hence E[N_i N_j]=n sum_delta S_or_T(delta,o,p), including the diagonal self-indicator terms.',
          'The expanded36495-owner loader is required: compact certificate values contain symmetric upper triangles and then profile weights. The old direct prefix was not that layout.',
          'Omitting one count group per sector loses no arbitrary integer affine count form: N_omitted=128-sumN_other, so eliminating its integer weight shifts c by128 times that weight and subtracts that weight from all remaining sector coefficients. This is an exact full-cardinality substitution, not a sparse ±1-template or event-complement equivalence.',
          'For an embedding row(z,k), the Gram value is(2z+k e0)^T(G+I)(2z+k e0)+D k²/alpha_den². Oddk gives the integer affine vector a=z+(k+1)e0/2, with2a-e0=2z+k e0.',
          'The ridge and embedding penalty are discovery devices only. The proposed gap is computed from the original exactG as -(a^T G a-a^T G e0)/(2D); reflectiona→e0-a preserves it exactly.',
          'Group counts are integer but not Boolean. Their diagonal second moments must remain E[N_i²]; an eventual compiler must expand each count into physical indicators or derive the group polynomial directly, rather than substituteN_i²=N_i.',
          'No-cut at three LLL embeddings checks only the inspected odd transform rows. It is neither complete count-form separation nor target convex membership. Saved reports do not containU, so this review does not independently reproduce the reported LLL congruences or short-vector minima.'
        ],
        future_positive_acceptance_gate='Preserve integer constant and every group weight; independently expand physical indicator coefficients, reconstruct all diagonal/cross count moments, check exact rational gap and symbolic32-action translation. Large expanded supports need a general integer-form consumer, since the existing literal-event consumer caps arity12.',
        scope='Layout, phase-count translation, embedding algebra and scope review of bounded negative discovery. No new scout/LLL/solver run, accepted aggregate row, source frame or case exclusion.')
    output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['proof_review']},indent=2))

if __name__=='__main__':main()
