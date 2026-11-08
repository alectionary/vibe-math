#!/usr/bin/env python3
"""Mechanical review of the weaker-floor continuation copy."""
import ast
import difflib
import json
from fractions import Fraction as Q
from verify_two_sided_full_basis_oracle import ROOT, sha, read

class Normalize(ast.NodeTransformer):
    def __init__(self):self.arg=0;self.gate=0;self.multiplier_uses=0;self.metadata=0
    def visit_Expr(self,node):
        if isinstance(node.value,ast.Call) and isinstance(node.value.func,ast.Attribute) and node.value.func.attr=='add_argument' and node.value.args and isinstance(node.value.args[0],ast.Constant) and node.value.args[0].value=='--floor-multiplier':
            assert any(k.arg=='required' and ast.literal_eval(k.value) is True for k in node.value.keywords)
            self.arg+=1;return None
        return self.generic_visit(node)
    def visit_Assert(self,node):
        if ast.unparse(node.test)=='a.floor_multiplier in (1 / 16, 1 / 8, 1 / 4, 1 / 2, 3 / 4, 1)':self.gate+=1;return None
        return self.generic_visit(node)
    def visit_Dict(self,node):
        keep=[not(isinstance(k,ast.Constant) and k.value in ('trial_floor_multiplier','trial_floor')) for k in node.keys]
        self.metadata+=sum(not b for b in keep); node.keys=[k for k,b in zip(node.keys,keep) if b];node.values=[v for v,b in zip(node.values,keep) if b]
        return self.generic_visit(node)
    def visit_Attribute(self,node):
        if isinstance(node.value,ast.Name) and node.value.id=='a' and node.attr=='floor_multiplier':self.multiplier_uses+=1;return ast.Constant(1)
        return self.generic_visit(node)

def main():
    outpath=ROOT/'two-basis-results/case-floor-homotopy-model-independent-review.json';assert not outpath.exists()
    baseline=ROOT/'case_floor_integer_coupling_model.py'; new=ROOT/'case_floor_integer_coupling_homotopy.py'; diff=ROOT/'two-basis-results/case-floor-homotopy-model.diff'
    assert ''.join(difflib.unified_diff(baseline.read_text().splitlines(True),new.read_text().splitlines(True),fromfile=baseline.name,tofile=new.name))==diff.read_text()
    normal=Normalize(); candidate=normal.visit(ast.parse(new.read_text())); assert (normal.arg,normal.gate,normal.multiplier_uses,normal.metadata)==(1,1,2,2)
    assert ast.dump(candidate,include_attributes=False)==ast.dump(ast.parse(baseline.read_text()),include_attributes=False)
    parent_path=ROOT/'two-basis-results/case-floor-integer-model-independent-review.json';parent=read(parent_path);assert parent['case_model_sha256']==sha(baseline)
    levels=[Q(1,16),Q(1,8),Q(1,4),Q(1,2),Q(3,4),Q(1)]
    assert all(0<v<=1 and Q.from_float(float(v))==v for v in levels)
    out=dict(status='PASS_WEAKER_FLOOR_CONTINUATION_COPY',source_C16_answered=False,reviewer_sha256=sha(__file__),baseline_sha256=sha(baseline),homotopy_model_sha256=sha(new),diff_sha256=sha(diff),case_source_review_sha256=sha(parent_path),
      complete_AST_identical_after_declared_floor_changes=True,exact_dyadic_multipliers=list(map(str,levels)),case32_trial_floors=[str(v/16) for v in levels],source_floor='1/16',
      no_other_model_or_solver_change=True,execution_flags_not_replayed=True,
      zero_margin_semantics='For 0<multiplier<=1 the trial floor is weaker than the true selected-case floor, so the zero-margin model remains source-necessary. Exact infeasibility of this weaker model would exclude the case; feasibility below multiplier1 does not establish the true-floor relaxation.',
      positive_margin_semantics='Positive PSD/Boolean/projected margins turn this into a sufficient interior witness search. Failure, including exact infeasibility, cannot exclude source cases. Exact feasible points still require full original-row recovery and the true floor for a true-case relaxation barrier.',
      source_frame_claimed=False,source_case_excluded=False)
    outpath.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
if __name__=='__main__':main()
