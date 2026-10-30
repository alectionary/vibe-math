#!/usr/bin/env python3
"""Mechanical positive objective rescaling audit; no bound acceptance."""
import ast
import copy
import json
from fractions import Fraction as Q
from verify_two_sided_full_basis_oracle import ROOT,sha,read

def main():
    outpath=ROOT/'two-basis-results/case-floor-maximize-scaled-independent-review.json';assert not outpath.exists()
    old=ROOT/'case_floor_integer_coupling_maximize.py';new=ROOT/'case_floor_integer_coupling_maximize_scaled.py'
    baseline,candidate=ast.parse(old.read_text()),ast.parse(new.read_text());bf=next(n for n in baseline.body if isinstance(n,ast.FunctionDef) and n.name=='main');cf=next(n for n in candidate.body if isinstance(n,ast.FunctionDef) and n.name=='main')
    def assigned(n,name):return isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id==name for t in n.targets)
    original=next(n for n in bf.body if assigned(n,'problem'));problems=metadata=0
    for i,n in enumerate(cf.body):
        if assigned(n,'problem'):
            assert ast.unparse(n.value)=='cp.Problem(cp.Maximize(1e-06 * T[ch][ci, cj]), con)';cf.body[i]=copy.deepcopy(original);problems+=1
        if assigned(n,'out') and isinstance(n.value,ast.Dict):
            keep=[not(isinstance(k,ast.Constant) and k.value=='objective_scale') for k in n.value.keys]
            for k,v in zip(n.value.keys,n.value.values):
                if isinstance(k,ast.Constant) and k.value=='objective_scale':assert ast.literal_eval(v)==1e-6
            metadata+=sum(not x for x in keep);n.value.keys=[k for k,b in zip(n.value.keys,keep) if b];n.value.values=[v for v,b in zip(n.value.values,keep) if b]
    assert problems==metadata==1 and ast.dump(baseline,include_attributes=False)==ast.dump(candidate,include_attributes=False)
    review=ROOT/'two-basis-results/case-floor-maximize-model-independent-review.json';assert read(review)['maximize_model_sha256']==sha(old)
    out=dict(status='PASS_POSITIVE_OBJECTIVE_RESCALING_ONLY',source_C16_answered=False,reviewer_sha256=sha(__file__),unscaled_model_sha256=sha(old),scaled_model_sha256=sha(new),unscaled_semantic_review_sha256=sha(review),complete_AST_equal_after_objective_scalar_and_metadata_normalization=True,
        positive_float_scale=1e-6,exact_binary_float_scale=str(Q.from_float(1e-6)),constraints_and_zero_margin_gate_unchanged=True,
        scope='Multiplying the maximized moment by a positive scalar preserves the feasible set and exact optimizer. Reported numeric objective must be divided by the scale for comparison. No floating primal, dual or objective bound is accepted as an exact source certificate; any exact dual reconstruction must account for the actual frozen objective coefficient.',source_case_excluded=False)
    outpath.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
if __name__=='__main__':main()
