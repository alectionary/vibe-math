#!/usr/bin/env python3
"""Independent source-prefix and stored-data audit of the linear case probe.

This reviews a numerical diagnostic, not a semantic exact certificate. It does
not regenerate the full canonical matrix or interpret a floating ray as proof.
"""
from pathlib import Path
import ast
import json
import numpy as np
from scipy.sparse import load_npz
from verify_two_sided_full_basis_oracle import ROOT, sha, read


def assigned(node,name):
    return isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id==name for t in node.targets)


def prefix(tree,stop):
    function=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='main')
    index=next(i for i,n in enumerate(function.body) if stop(n))
    return ast.dump(ast.Module(body=function.body[:index],type_ignores=[]),include_attributes=False)


def main():
    output=ROOT/'two-basis-results/sourcecase323200-linear0-independent-review.json'; assert not output.exists()
    baseline=ROOT/'case_floor_integer_coupling_model.py'; probe=ROOT/'case_floor_integer_lp_probe.py'
    old,new=ast.parse(baseline.read_text()),ast.parse(probe.read_text())
    def is_gate(n): return isinstance(n,ast.Assert) and ast.unparse(n.test)=='not witness_only'
    assert prefix(old,lambda n:assigned(n,'args'))==prefix(new,is_gate)
    code=probe.read_text()
    snippets=["linear=canonical['A'][:zc+lc].tocsr()", "right=np.asarray(canonical['b'][:zc+lc])", "low[zc:]=-highspy.kHighsInf", "H.addVars(n,np.zeros(n),np.ones(n))", "H.addRows(linear.shape[0],low,right,linear.nnz", "assert filled==set(range(len(x0)))", "assert not witness_only"]
    assert all(s in code for s in snippets)
    parent_path=ROOT/'two-basis-results/case-floor-integer-model-independent-review.json'; parent=read(parent_path)
    assert parent['status']=='PASS_CASE_FLOOR_COPY_SEMANTICS_SOURCE_NECESSITY' and parent['case_model_sha256']==sha(baseline)
    stem=ROOT/'coupling-results/sourcecase323200-linear0'
    report_path=Path(str(stem)+'.json'); frozen_path=Path(str(stem)+'-frozen.json'); exit_path=Path(str(stem)+'-exit.json')
    report,frozen,ex=read(report_path),read(frozen_path),read(exit_path)
    assert ex['frozen_sha256']==sha(frozen_path) and ex['returncode']==0 and not ex['outer_timeout']
    assert frozen['mode']=='necessary_zero_margin' and all(v==0 for v in frozen['effective_margins'].values())
    command=frozen['command']; assert command[2]==probe.name and '--certificate-margin' not in command
    for flag in ['--psd-interior-epsilon','--boolean-margin','--projected-margin']:
        assert float(command[command.index(flag)+1])==0
    assert command[command.index('--case')+1:command.index('--case')+4]==['32','32','0']
    hashes=frozen['input_and_source_hashes']; assert all(sha(ROOT/p)==h for p,h in hashes.items())
    assert set(ex['sources_unchanged'])==set(hashes) and all(ex['sources_unchanged'].values())
    assert hashes[probe.name]==sha(probe)
    assert report['status']=='NUMERICAL_LINEAR_CASE_PROBE_ONLY' and not report['source_C16_answered'] and not report['source_anchor_excluded']
    assert report['solver_model_status']=='HighsModelStatus.kTimeLimit' and report['explicit_box']==[0,1]
    assert report['case_condition']['case']==[32,32,0] and report['case_condition']['necessary_floor']=='1/16'
    Apath=Path(str(stem)+'.linear-A.npz'); dpath=Path(str(stem)+'.linear-data.npz'); spath=Path(str(stem)+'.linear-solution.npz')
    A=load_npz(Apath).tocsr(); data=np.load(dpath,allow_pickle=False); sol=np.load(spath,allow_pickle=False)
    b,warm,x=data['rhs'],data['warm'],sol['x']; zc,lc=report['equalities'],report['inequalities']
    assert A.shape==(zc+lc,report['variables']) and A.nnz==report['nonzeros']
    assert b.shape==(zc+lc,) and warm.shape==x.shape==(A.shape[1],)
    assert np.isfinite(A.data).all() and np.isfinite(b).all() and np.isfinite(x).all() and np.isfinite(warm).all()
    residual=A@x-b
    measured={'equalities':float(np.max(abs(residual[:zc]),initial=0)), 'inequalities':float(np.max(residual[zc:],initial=0)), 'lower_box':float(max(0,-np.min(x))), 'upper_box':float(max(0,np.max(x)-1))}
    assert measured==report['numeric_residuals'] and min(measured.values())>1
    warm_audit_path=Path(str(stem)+'.warmstart.json'); warm_audit=read(warm_audit_path); wr=A@warm-b
    assert warm_audit['canonical_variables_mapped']==A.shape[1]
    assert float(np.max(abs(wr[:zc]),initial=0))==warm_audit['max_initial_equality_residual']
    assert float(np.max(wr[zc:],initial=0))==warm_audit['max_initial_linear_inequality_violation']
    assert warm_audit['warm_point_sha256']==sha(ROOT/command[command.index('--warm-point')+1])
    # 45x45 G principal,44x44 D0 principal, fourteen90x90 and two45x45 Fourier blocks.
    psd_dimensions=[45,44]+[90]*14+[45]*2
    assert sum(n*(n+1)//2 for n in psd_dimensions)==report['PSD_rows_omitted']==61425
    candidate_rows=[]
    for r in np.flatnonzero(np.diff(A.indptr)==1):
        if r>=zc and b[r]==-1/16 and A.data[A.indptr[r]]==-1:
            candidate_rows.append({'row':int(r),'canonical_column':int(A.indices[A.indptr[r]])})
    assert len(candidate_rows)==1
    out=dict(status='PASS_LINEAR_PROBE_SEMANTICS_INCONCLUSIVE',source_C16_answered=False,
      reviewer_sha256=sha(__file__),baseline_sha256=sha(baseline),probe_sha256=sha(probe),case_source_review_sha256=sha(parent_path),
      report_sha256=sha(report_path),frozen_sha256=sha(frozen_path),exit_sha256=sha(exit_path),
      archived_matrix_sha256=sha(Apath),archived_data_sha256=sha(dpath),archived_solution_sha256=sha(spath),
      frozen_input_source_bindings_checked=len(hashes),all_frozen_sources_unchanged=True,
      full_model_construction_and_canonical_pack_AST_prefix_identical=True,all_three_artificial_margins_zero=True,
      linear_projection={'equalities':zc,'inequalities':lc,'variables':A.shape[1],'nonzeros':A.nnz,'omitted_PSD_rows':report['PSD_rows_omitted'],'omitted_PSD_block_dimensions':psd_dimensions},
      one_literal_case_floor_row=candidate_rows[0],canonical_bounds_source_argument='Pack exhaustively covers p,S,T and profile weights. Boolean moments lie in[0,1]; nonnegative profile weights sum to1, so their[0,1] bounds are valid. No free lift or PSD slack coordinates remain.',
      signs='SCS Ax+s=b: zero cone gives Ax=b; nonnegative cone gives Ax<=b. The first zero+nonnegative rows retain these signs; all following PSD cone rows are omitted.',
      stored_numeric_residuals_independently_recomputed=measured,solver_status=report['solver_model_status'],
      solution_value_valid_means_feasible=False,solution_dual_valid_means_exact_certificate=False,
      exact_primal_accepted=False,exact_dual_accepted=False,source_case_excluded=False,
      canonical_matrix_regenerated=False,scope='Static complete construction-prefix comparison plus frozen-source and stored-matrix numerical replay. This bounded probe ended at time limit with an invalid primal. It neither proves feasibility nor infeasibility. Any future infeasibility requires exact semantic source-row reconstruction; floating canonical coefficients alone are not an exact C16 certificate.')
    output.write_text(json.dumps(out,indent=2)+'\n'); print(json.dumps(out,indent=2))

if __name__=='__main__':main()
