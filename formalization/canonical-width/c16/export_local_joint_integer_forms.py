#!/usr/bin/env python3
"""Exact polynomial-identical export of the two stopped local-hull candidates.

This is a producer conversion, not an independent acceptance receipt.
"""
from pathlib import Path
from itertools import combinations
from fractions import Fraction as Q
import json
from verify_two_sided_full_basis_oracle import ROOT,sha,read,point_owner
from physical_integer_form_rows import compile_row

def main():
    source=ROOT/'two-basis-results/local-joint-targeted-matched-v1.json';original=read(source)
    assert original['status']=='EXACT_LOCAL_JOINT_CUT_CANDIDATES' and len(original['cuts'])==2 and original['LPs_run']==3
    point=ROOT/'coupling-results/sourcecase323200-homotopy2-rational.json.gz';owner=point_owner(point);cuts=[];proofs=[]
    for k,c in enumerate(original['cuts']):
        E=c['events'];n=len(E);coeff=c['coefficients'];assert c['bound']==c['matched_unfiltered_bound']==coeff[0]==0
        assert c['point_sha256']==sha(point) and not c['physical_filter_needed_for_this_separation']
        pairs=list(combinations(range(n),2));quadratic=dict(zip(pairs,coeff[n+1:]));active=sorted(set(i for i,v in enumerate(coeff[1:n+1]) if v)|{i for p,v in quadratic.items() if v for i in p})
        first=active[0];w={first:1}
        for i in active[1:]:w[i]=-quadratic[(first,i)]
        assert set(w.values())=={-1,1}
        assert all(coeff[1+i]==-w.get(i,0)*(w.get(i,0)-1)//2 for i in range(n))
        assert all(v==-w.get(i,0)*w.get(j,0) for (i,j),v in quadratic.items())
        cut=dict(events=[E[i] for i in active],weights=[w[i] for i in active],constant=0,exact_violation=c['exact_violation'])
        row,rhs=compile_row(cut);assert [[j,v] for j,v in row.items()]==c['owner_row_terms'] and rhs==c['owner_rhs']==0
        assert sum(v*owner[j] for j,v in row.items())-rhs==Q(c['exact_violation'])>0
        cuts.append(cut);proofs.append(dict(local_cut_index=k,active_local_indices=active,integer_form_events=cut['events'],integer_form_weights=cut['weights'],constant=0,exact_coefficient_identity='local polynomial = -L(L-1)/2',all_full_polynomial_coefficients_matched=1+n+len(pairs),compiled_owner_row_identical=True,physical_filter_required=False))
    sources={p:sha(ROOT/p) for p in ['export_local_joint_integer_forms.py','local_joint_targeted_probe.py','physical_integer_form_rows.py','verify_two_sided_full_basis_oracle.py','pools/xcoords.txt','pools/zcoords.txt','physical-pool-source.json','two-basis-results/local-joint-targeted-matched-v1.json','two-basis-results/local-joint-targeted-matched-v1.frozen.json']}
    bank=dict(status='EXACT_PHYSICAL_INTEGER_FORM_CANDIDATE',source_C16_answered=False,point_sha256=sha(point),source_hashes=sources,cuts=cuts,
        derivation='Unfiltered local Boolean hull discovery; both exact normals simplify to unbalanced integer forms. No physical mask restriction is used in these final rows.')
    output=ROOT/'two-basis-results/local-joint-targeted-integer-forms.json';proof=ROOT/'two-basis-results/local-joint-targeted-integer-conversion.json';assert not output.exists() and not proof.exists()
    output.write_text(json.dumps(bank,indent=2)+'\n')
    result=dict(status='EXACT_POLYNOMIAL_IDENTICAL_CANDIDATE_CONVERSION',source_C16_answered=False,producer_sha256=sha(__file__),local_candidate_sha256=sha(source),integer_bank_sha256=sha(output),point_sha256=sha(point),results=proofs,independent_acceptance_required=True,scope='Producer-side exact coefficient identity only. Use existing independent physical integer-form consumer and symbolic32-action review before model integration.')
    proof.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

if __name__=='__main__':main()
