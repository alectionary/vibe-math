#!/usr/bin/env python3
"""Peer review and supplemental independent affine-span checks.

The accepted physical consumer covers all forest edges/completeness. This review
checks the modular rank independently, samples literal full-basis exchanges,
and tests every upper annihilator directly on entire physical domain buckets.
"""
from fractions import Fraction as Q
import json
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, domains, target, rank
from audit_two_sided_full_basis_endpoint import check_basis


def main():
    output=ROOT/'two-basis-results/two-basis-affine-components-peer-review.json'; assert not output.exists()
    certpath=ROOT/'two-basis-results/two-basis-affine-components-32x27-point15.json'
    receiptpath=ROOT/'two-basis-results/two-basis-affine-components-32x27-point15-independent.json'
    seedpath=ROOT/'two-basis-results/two-basis-structure-nearest-32x27-point15.json'
    seedreceiptpath=ROOT/'two-basis-results/two-basis-structure-nearest-32x27-point15-independent.json'
    point=ROOT/'coupling-results/integer-witness15-rational.json.gz'
    d,receipt,seed,seedreceipt=map(read,[certpath,receiptpath,seedpath,seedreceiptpath])
    assert receipt['status']=='PASS_EXACT_COMPLETE_SECTOR_AFFINE_SPANS'
    assert receipt['certificate_sha256']==sha(certpath) and receipt['consumer_sha256']==sha(ROOT/'two_basis_affine_verify.py')
    assert receipt['point_sha256']==d['point_sha256']==seed['point_sha256']==sha(point)
    assert receipt['lambda_seed_sha256']==d['lambda_seed_sha256']==sha(seedpath)
    assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items())
    assert all(sha(ROOT/p)==h for p,h in receipt['consumer_dependencies'].items())
    assert d['producer_sha256']==sha(ROOT/'two_basis_affine_components.py')
    assert seedreceipt['status']=='PASS_EXACT_NEAREST_LOCAL_BOX_LAMBDA_L1_OPTIMUM'
    assert seedreceipt['candidate_sha256']==sha(seedpath)
    lam=list(map(Q,d['lambda_masses'])); assert lam==list(map(Q,seed['lambda_masses'])) and min(lam)>=0 and sum(lam)==1
    xx,zz=d['X_anchors'],d['Z_anchors'];X,Z,bridge=physical_source();dd=domains(X,Z,xx,zz);full=target(point,xx,zz)
    assert all(q['feasible'] for q in dd)
    for k in range(11):
        def low(m):
            b=[m>>i&1 for i in range(4)]
            return [1,*b,*[b[i]*b[j] for i in range(4) for j in range(i+1,4)]][k]
        assert sum(lam[m]*low(m) for m in range(16))==full[k]
    reports={}; samples=[]; bounds_checked=0
    for side,U,offset in [('X',X,0),('Z',Z,720)]:
        records=d['sectors'][side]['patterns'];assert len(records)==16
        b=full[11+offset:731+offset]+[full[1451+1440*i+offset+j] for i in range(4) for j in range(720)]
        for m,r in enumerate(records):
            check_basis(U,dd[m][side],r['base_indices'])
            assert len(r['zero_components'])==1 and not r['zero_loops']
            for kind in ['zero_forest_edges','owner_star_edges']:
                edges=r[kind]
                for k in sorted(set([0,len(edges)//2,len(edges)-1])) if edges else []:
                    old,new=edges[k]; basis=list(r['base_indices']);assert old in basis and new not in basis
                    basis.remove(old);basis.append(new);check_basis(U,dd[m][side],basis)
                    samples.append(dict(side=side,mask=m,kind=kind,edge_index=k,old=old,new=new))
        reports[side]={}
        for label,span in d['sectors'][side]['spans'].items():
            patterns=span['patterns'];expected=list(range(16)) if label=='all_patterns' else [m for m,l in enumerate(lam) if l]
            assert patterns==expected
            bits=[]
            for m in patterns:
                blocks=[0]+[i+1 for i in range(4) if m>>i&1]
                for old,new in records[m]['zero_forest_edges']+records[m]['owner_star_edges']:
                    assert old!=new
                    bits.append(sum((1<<(720*i+old))+(1<<(720*i+new)) for i in blocks))
            lower=rank(bits);assert lower==span['rank']==span['GF2_rank_lower_bound']==3583 and len(bits)==span['generator_count']
            normals=[{int(j):Q(v) for j,v in r['coefficients'].items()} for r in span['annihilator_tests']]
            assert len(normals)==17 and len(span['free_indices'])==17
            assert all(all(n.get(j,0)==int(i==k) for i,j in enumerate(span['free_indices'])) for k,n in enumerate(normals))
            assert all(set(n.values())=={Q(1)} for n in normals) and sorted(j for n in normals for j in n)==list(range(3600))
            for n,saved in zip(normals,span['annihilator_tests']):
                h=[]
                for m in range(16):
                    sd=dd[m][side];w=[sum(n.get(720*i+j,0) for i in [0]+[k+1 for k in range(4) if m>>k&1]) for j in range(720)]
                    value=sum(w[j] for j in records[m]['base_indices']);h.append(value)
                    if m not in patterns:continue
                    # Direct constancy on the entire free zero pool and every owner bin
                    # proves this annihilator, independently of certificate components.
                    vals={w[j] for j in sd['zero_free']};assert len(vals)==1
                    universal=sum(w[j] for j in sd['zero_forced'])+(sd['zero_required']-len(sd['zero_forced']))*next(iter(vals))
                    for bucket in sd['bins']:
                        vals={w[j] for j in bucket};assert len(vals)==1;universal+=next(iter(vals))
                    assert universal==value;bounds_checked+=1
                left=sum(v*b[j] for j,v in n.items());right=sum(l*v for l,v in zip(lam,h))
                assert left==right==Q(saved['target_value'])==Q(saved['lambda_base_value']) and Q(saved['residual'])==0
                assert list(map(Q,saved['pattern_base_values']))==h
            reports[side][label]=dict(exact_mod2_rank_lower_bound=lower,independent_universal_null_vectors=17,
                exact_real_affine_dimension=3600-17,target_annihilator_residuals_zero=17,generators=len(bits))
    out=dict(status='PASS_PEER_REVIEW_COMPLETE_AUXILIARY_AFFINE_SPANS',source_C16_answered=False,
        reviewer_sha256=sha(__file__),certificate_sha256=sha(certpath),physical_consumer_receipt_sha256=sha(receiptpath),
        physical_consumer_sha256=sha(ROOT/'two_basis_affine_verify.py'),theorem_note_sha256=sha(ROOT/'two_basis_affine_review.md'),
        point_sha256=sha(point),lambda_seed_sha256=sha(seedpath),lambda_seed_receipt_sha256=sha(seedreceiptpath),
        source_hashes=d['source_hashes'],physical_symmetry_bridge=bridge,sectors=reports,
        exact_lambda_low_moment_equations=11,universal_pattern_annihilator_checks=bounds_checked,
        sampled_literal_full_basis_exchanges=samples,all_reference_full_bases_checked=32,
        complete_physical_forest_verification_in_dependency=True,
        proof_review=[
          'Each physical nonbasis zero vector has a unique representation in F plus C. Dropping F coefficients is exact contraction by all forced zero vectors.',
          'Nonzero fundamental coefficients certify literal basis exchanges. The consumer checks every such edge lies within a saved forest component and every forest edge is one of these exchanges.',
          'Component basis-coordinate supports are disjoint; their spans form a direct sum, so every contracted basis has the fixed component count. Tree exchanges span all zero-sum directions. This proves completeness for all bases, not merely the search archive.',
          'Distinct unit evaluation signatures make owner choices independent of the contracted zero basis, giving a direct sum with one-choice owner bins.',
          'Lifting differences by (1,m0,m1,m2,m3) and summing positive-lambda direction spaces gives the complete Minkowski affine direction span. Zero-lambda patterns contribute no directions.',
          'A nonzero minor modulo2 is a nonzero integer minor, so rank3583 modulo2 is a rational/real lower bound. Seventeen independently checked universal annihilators give the matching real upper bound.',
          'The all16-pattern span has the same rank as the actual11-positive-pattern span; no extra equality follows from the five zero masses for this frozen seed.'
        ],
        cosmetic_note_erratum='The frozen prose spells the receipt status PASS_EX ACT_COMPLETE_SECTOR_AFFINE_SPANS once; actual receipt status is PASS_EXACT_COMPLETE_SECTOR_AFFINE_SPANS.',
        scope='Exact affine hull of this specified auxiliary conditional-sector full-basis relaxation at the frozen point15 law. Zero target affine residual establishes affine consistency only. It proves no convex membership, allocation, source frame, case exclusion, or column-count lower bound.')
    output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ('sampled_literal_full_basis_exchanges','source_hashes','proof_review')},indent=2))

if __name__=='__main__':main()
