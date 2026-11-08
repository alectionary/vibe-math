#!/usr/bin/env python3
"""Mechanical review of the zero-margin selected-moment maximization copy."""
import ast
import copy
import difflib
import json
from verify_two_sided_full_basis_oracle import ROOT, sha, read


def main():
    output=ROOT/'two-basis-results/case-floor-maximize-model-independent-review.json';assert not output.exists()
    old=ROOT/'case_floor_integer_coupling_homotopy.py';new=ROOT/'case_floor_integer_coupling_maximize.py'
    baseline,candidate=ast.parse(old.read_text()),ast.parse(new.read_text())
    basefun=next(n for n in baseline.body if isinstance(n,ast.FunctionDef) and n.name=='main')
    function=next(n for n in candidate.body if isinstance(n,ast.FunctionDef) and n.name=='main')
    def assignment(n,name):return isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id==name for t in n.targets)
    original_problem=next(n for n in basefun.body if assignment(n,'problem'));removed=0;objectives=0;metadata=0;body=[]
    for n in function.body:
        if isinstance(n,ast.Assert) and ast.unparse(n.test)=='not a.certificate_margin and a.psd_interior_epsilon == 0 and (a.boolean_margin == 0) and (a.projected_margin == 0)':removed+=1;continue
        if assignment(n,'problem'):
            assert ast.unparse(n.value)=='cp.Problem(cp.Maximize(T[ch][ci, cj]), con)';n=copy.deepcopy(original_problem);objectives+=1
        if assignment(n,'out') and isinstance(n.value,ast.Dict):
            keep=[not(isinstance(k,ast.Constant) and k.value=='objective_scope') for k in n.value.keys]
            metadata+=sum(not b for b in keep);n.value.keys=[k for k,b in zip(n.value.keys,keep) if b];n.value.values=[v for v,b in zip(n.value.values,keep) if b]
        body.append(n)
    function.body=body;assert (removed,objectives,metadata)==(1,1,1)
    assert ast.dump(baseline,include_attributes=False)==ast.dump(candidate,include_attributes=False)
    parent=ROOT/'two-basis-results/case-floor-homotopy-model-independent-review.json';assert read(parent)['homotopy_model_sha256']==sha(old)
    diff=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile=old.name,tofile=new.name))
    diffpath=ROOT/'two-basis-results/case-floor-maximize-independent.diff';assert not diffpath.exists();diffpath.write_text(diff)
    result=dict(status='PASS_ZERO_MARGIN_OBJECTIVE_ONLY_COPY',source_C16_answered=False,reviewer_sha256=sha(__file__),homotopy_model_sha256=sha(old),maximize_model_sha256=sha(new),review_diff_sha256=sha(diffpath),homotopy_semantic_review_sha256=sha(parent),
      complete_AST_identical_after_declared_objective_gate_and_metadata_changes=True,
      enforced_margins={'PSD':0,'Boolean':0,'projected':0},objective='maximize T[ch][ci,cj]',constraints_unchanged=True,
      exact_source_exclusion_criterion='An independently replayed exact semantic upper bound strictly below the true selected-pair floor excludes that case, because every selected source frame lies in the zero-margin relaxation and satisfies even the weaker trial floor.',
      exact_feasible_endpoint_criterion='A recovered point satisfying all listed exact source-necessary rows and the true floor is a barrier only for this finite case relaxation, not a physical source frame. A feasible value below the true floor does not establish this barrier.',
      numerical_status_is_proof=False,source_case_excluded=False,execution_endpoint_replayed=False,
      scope='Mechanical source semantics review only. Canonical floating duals or numerical objective estimates require exact semantic reconstruction before any upper-bound or case-exclusion claim.')
    output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))

if __name__=='__main__':main()
