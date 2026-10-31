#!/usr/bin/env python3
"""Mechanical source review: solver scaling copy preserves case constraints."""
import ast
import difflib
import json
from pathlib import Path
from verify_two_sided_full_basis_oracle import ROOT, sha, read

class NormalizeSettings(ast.NodeTransformer):
    def __init__(self): self.solver_calls=0; self.metadata_edits=0
    def visit_Call(self,node):
        node=self.generic_visit(node)
        if isinstance(node.func,ast.Attribute) and isinstance(node.func.value,ast.Name) and node.func.value.id=='scs' and node.func.attr=='solve':
            keywords={k.arg:k for k in node.keywords}
            assert ast.literal_eval(keywords['scale'].value)==0.1
            assert ast.literal_eval(keywords['adaptive_scale'].value) is True
            keywords['scale'].value=ast.Constant(1e-6); keywords['adaptive_scale'].value=ast.Constant(False)
            self.solver_calls+=1
        return node
    def visit_Dict(self,node):
        node=self.generic_visit(node); keys=[k.value if isinstance(k,ast.Constant) else None for k in node.keys]
        if 'max_initial_equality_residual' in keys:
            for key,value in [('scale',0.1),('adaptive_scale',True)]: assert ast.literal_eval(node.values[keys.index(key)])==value
            node.values[keys.index('scale')]=ast.Constant(1e-6); node.values[keys.index('adaptive_scale')]=ast.Constant(False); self.metadata_edits+=1
        if 'initial_SCS_scale' in keys:
            i,j=keys.index('initial_SCS_scale'),keys.index('SCS_adaptive_scale')
            assert ast.literal_eval(node.values[i])==0.1 and ast.literal_eval(node.values[j]) is True
            node.keys[i]=ast.Constant('fixed_SCS_scale'); node.values[i]=ast.Constant(1e-6)
            del node.keys[j]; del node.values[j]; self.metadata_edits+=1
        return node

def main():
    output=ROOT/'two-basis-results/case-floor-scaled-model-independent-review.json'; assert not output.exists()
    old=ROOT/'case_floor_integer_coupling_model.py'; new=ROOT/'case_floor_integer_coupling_model_scaled.py'
    diff=ROOT/'two-basis-results/case-floor-scaled-model.diff'
    assert ''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile=old.name,tofile=new.name))==diff.read_text()
    baseline,candidate=ast.parse(old.read_text()),ast.parse(new.read_text()); transform=NormalizeSettings(); candidate=transform.visit(candidate)
    assert transform.solver_calls==1 and transform.metadata_edits==2
    assert ast.dump(baseline,include_attributes=False)==ast.dump(candidate,include_attributes=False)
    parent_path=ROOT/'two-basis-results/case-floor-integer-model-independent-review.json'; parent=read(parent_path)
    assert parent['status']=='PASS_CASE_FLOOR_COPY_SEMANTICS_SOURCE_NECESSITY' and parent['case_model_sha256']==sha(old)
    result=dict(status='PASS_SOLVER_SETTINGS_ONLY_COPY',source_C16_answered=False,reviewer_sha256=sha(__file__),
      baseline_sha256=sha(old),scaled_model_sha256=sha(new),diff_sha256=sha(diff),case_source_review_sha256=sha(parent_path),
      complete_AST_identical_after_normalizing_solver_settings_and_metadata=True,
      changed_solver_settings={'scale':[1e-6,0.1],'adaptive_scale':[False,True]},
      changed_output_metadata=['initial_SCS_scale','SCS_adaptive_scale'],all_source_constraints_and_objective_unchanged=True,
      actual_run_flags_checked=False,source_exclusion_claimed=False,
      scope='This copy changes SCS search settings and their reporting only. Search status and residuals are not an exact infeasibility certificate. A zero-margin execution remains necessary; positive-margin failure cannot exclude the selected source case.')
    output.write_text(json.dumps(result,indent=2)+'\n'); print(json.dumps(result,indent=2))

if __name__=='__main__':main()
