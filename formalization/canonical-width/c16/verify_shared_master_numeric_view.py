#!/usr/bin/env python3
"""Independent immutable rational-LP to IEEE-double view; no optimizer."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,time
import numpy as np
from verify_shared_master_common import guard,resolve,sha,read,bindings,Tokens,check_primal,exact_dual
from verify_shared_master_presolve_tiny import original_problem

def check_row(indices,values,lower,upper,coeff,relation,rhs):
    keys=sorted(coeff);assert indices.tolist()==keys
    assert np.array_equal(values,np.asarray([float(coeff[j]) for j in keys],dtype=np.float64))
    assert np.isfinite(values).all() and np.isfinite(float(rhs))
    assert upper==float(rhs)
    assert lower==(float(rhs) if relation=='=' else -np.inf)
    assert relation in ('=','<=')

def main():
    guard();ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True);ap.add_argument('--output',required=True);a=ap.parse_args();start=time.monotonic()
    out=resolve(a.output);assert not out.exists();v=read(a.manifest)
    assert v['status']=='FROZEN_SHARED_MASTER_FLOAT_VIEW_REQUIRES_REPLAY'
    for key in ('master_manifest','preparation_receipt','packet','names','tiny'):assert sha(v[key])==v[key+'_sha256']
    bindings(v['source_hashes']);m=read(v['master_manifest']);pr=read(v['preparation_receipt'])
    assert pr['status']=='PASS_EXACT_SHARED_BASIS_PHASE_ONE_MODEL' and pr['manifest_sha256']==v['master_manifest_sha256']
    assert pr['consumer_sha256']==sha('verify_shared_master_preparation.py');bindings(pr['dependencies'])
    assert sha(m['lp'])==m['lp_sha256']==pr['lp_sha256'] and sha(m['seed'])==m['seed_sha256']==pr['seed_sha256']
    names=read(v['names']);N=m['variable_count'];R=m['row_count'];NZ=m['nonzeros']
    assert v['variable_count']==N and v['row_count']==R and v['nonzeros']==NZ
    rows=names['row_names'];cols=names['variable_names']
    assert cols==['x'+str(j) for j in range(N)] and len(rows)==len(set(rows))==R
    arrays=np.load(resolve(v['packet']),allow_pickle=False)
    assert set(arrays.files)=={'row_start','indices','values','row_lower','row_upper','col_lower','col_upper','col_cost','seed'}
    starts,ind,val=[arrays[k] for k in ('row_start','indices','values')]
    assert starts.dtype==np.int64 and ind.dtype==np.int32 and val.dtype==np.float64
    assert starts.shape==(R+1,) and ind.shape==val.shape==(NZ,)
    assert starts[0]==0 and starts[-1]==NZ and np.all(starts[1:]>=starts[:-1])
    for key,n in [('row_lower',R),('row_upper',R),('col_lower',N),('col_upper',N),('col_cost',N),('seed',N)]:
        assert arrays[key].shape==(n,) and arrays[key].dtype==np.float64
    assert np.all(arrays['col_lower']==-np.inf) and np.all(arrays['col_upper']==np.inf)
    t=Tokens(m['lp']);t.expect('Minimize');t.expect('obj:');objective=t.expr(N)
    expected_cost=np.zeros(N,dtype=np.float64)
    for j,c in objective.items():expected_cost[j]=float(c)
    assert np.array_equal(arrays['col_cost'],expected_cost)
    t.expect('Subject');t.expect('To');equalities=0
    for i,name in enumerate(rows):
        t.expect(name+':');coeff=t.expr(N);relation=t.pop();rhs=Q(t.pop())
        lo,hi=int(starts[i]),int(starts[i+1]);check_row(ind[lo:hi],val[lo:hi],arrays['row_lower'][i],arrays['row_upper'][i],coeff,relation,rhs)
        equalities+=relation=='='
    t.expect('Bounds')
    for name in cols:t.expect(name);t.expect('free')
    t.expect('End');assert t.current is None;t.stream.close()
    seed=read(m['seed']);exactseed=seed['exact_parameters'];assert len(exactseed)==N
    assert np.array_equal(arrays['seed'],np.asarray([float(Q(v)) for v in exactseed],dtype=np.float64))
    assert np.isfinite(arrays['seed']).all() and np.isfinite(arrays['col_cost']).all()
    tiny=read(v['tiny']);assert tiny['status']=='PASS_NUMERIC_API_TINY_EXACT_BINARY_PRIMAL_DUAL_REQUIRES_REVIEW'
    tr,tf,tc=original_problem();tx=list(map(Q,tiny['primal']));td=dict(zip([r[0] for r in tr],map(Q,tiny['dual'])))
    assert len(tiny['primal'])==4 and len(tiny['dual'])==6 and tx==[Q(1,2),Q(1),Q(0),Q(1,2)]
    tobj,tn,ts=check_primal(tr,tf,tx,tc);assert tobj==Q(tiny['objective'])==Q(1,2)
    assert exact_dual(tr,tf,4,tc,td,tobj)[0]==1 and tiny['setSolution_accepted'] is True
    rejected=[]
    def reject(label,fn):
        try:fn()
        except (AssertionError,ValueError,IndexError):rejected.append(label)
        else:raise AssertionError(('accepted numeric-view mutation',label))
    coeff={0:Q(1),2:Q(-1,3)};ii=np.asarray([0,2],dtype=np.int32);vv=np.asarray([1,float(Q(-1,3))])
    check_row(ii,vv,-np.inf,float(Q(2,7)),coeff,'<=',Q(2,7))
    reject('wrong_column_map',lambda:check_row(np.asarray([1,2]),vv,-np.inf,float(Q(2,7)),coeff,'<=',Q(2,7)))
    reject('wrong_coefficient_sign',lambda:check_row(ii,-vv,-np.inf,float(Q(2,7)),coeff,'<=',Q(2,7)))
    reject('implicit_row_lower_bound',lambda:check_row(ii,vv,0,float(Q(2,7)),coeff,'<=',Q(2,7)))
    reject('altered_rhs',lambda:check_row(ii,vv,-np.inf,float(Q(2,7))+1,coeff,'<=',Q(2,7)))
    wrong=td.copy();wrong['parent']=0
    reject('tiny_wrong_original_row_dual',lambda:exact_dual(tr,tf,4,tc,wrong,tobj))
    result=dict(status='PASS_EXACT_TO_FLOAT_SHARED_MASTER_VIEW',manifest_sha256=sha(a.manifest),master_manifest_sha256=v['master_manifest_sha256'],
        preparation_receipt_sha256=v['preparation_receipt_sha256'],packet_sha256=v['packet_sha256'],names_sha256=v['names_sha256'],
        lp_sha256=m['lp_sha256'],tiny_sha256=v['tiny_sha256'],tiny_original_row_exact_objective='1/2',tiny_original_stationarity_checked=4,
        consumer_sha256=sha(Path(__file__).name),point_sha256=m['point_sha256'],rows_checked=R,variables_checked=N,
        coefficients_checked=NZ,equalities_checked=equalities,inequalities_checked=R-equalities,exact_seed_conversions_checked=N,
        conversion='Each stored float is exactly Python float(Fraction(the immutable rational LP token)); no tolerance or dropped coefficient.',
        row_names_unique=True,column_names_preserved=True,all_columns_explicitly_free=True,negative_controls=rejected,
        source_hashes=v['source_hashes'],dependencies={p:sha(p) for p in ['verify_shared_master_common.py','verify_shared_master_preparation.py','verify_shared_master_presolve_tiny.py']},
        numeric_solution_accepted=False,exact_optimality_claimed=False,source_C16_answered=False,solver_executed=False,
        nice=19,threads=1,elapsed_seconds=time.monotonic()-start)
    out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
