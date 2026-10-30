#!/usr/bin/env python3
"""Independent original-row proof for the one presolve-on positive-L1 toy."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,time
from verify_shared_master_common import guard,resolve,sha,read,bindings,term,add,parse_lp,check_primal,exact_dual
from read_soplex_exact_output_v2 import read_named_rational

def original_problem():
    rows=[('parent',add(term(1,0),term(0,0,Q(-1,2))),'='),
          ('mass',add(term(1,1),term(0,0,-1)),'='),
          ('link',({},{0:Q(-1),1:Q(1),2:Q(1),3:Q(-1)}),'=')]
    rows.extend(('n'+str(j),term(1,j,-1),'<=') for j in range(1,4))
    return rows,[Q(1)],{2:Q(1),3:Q(1)}

def main():
    guard();ap=argparse.ArgumentParser()
    for k in ('manifest','primal','dual','solver-frozen','output'):ap.add_argument('--'+k,required=True)
    a=ap.parse_args();start=time.monotonic();out=resolve(a.output);assert not out.exists()
    m=read(a.manifest);assert m['status']=='EXACT_SHARED_MASTER_PRESOLVE_ONE_TINY_REQUIRES_REPLAY'
    assert m['variable_count']==4 and m['row_count']==6 and sha(m['lp'])==m['lp_sha256']
    bindings(m['source_hashes']);frozen=read(a.solver_frozen)
    assert frozen['input_manifest_sha256']==sha(a.manifest) and frozen['input_lp_sha256']==m['lp_sha256']
    command=frozen['command'];assert '-s1' in command and '-s0' not in command
    assert '-X='+str(resolve(a.primal)) in command and '-Y='+str(resolve(a.dual)) in command and str(resolve(m['lp'])) in command
    if 'source_hashes' in frozen:bindings(frozen['source_hashes'])
    rows,f,cost=original_problem();text=parse_lp(m['lp'],rows,f,4,cost)
    rawx=read_named_rational(resolve(a.primal),['x'+str(j) for j in range(4)])
    x=[rawx['x'+str(j)] for j in range(4)]
    rawdual=read_named_rational(resolve(a.dual),[r[0] for r in rows],'dual')
    objective,count,slack=check_primal(rows,f,x,cost)
    assert x==[Q(1,2),Q(1),Q(0),Q(1,2)] and objective==Q(1,2) and count==6
    sign,dual,dualobjective=exact_dual(rows,f,4,cost,rawdual,objective)
    assert dual==dict(parent=Q(-1),mass=Q(1),link=Q(-1),n1=Q(0),n2=Q(-2),n3=Q(0))
    rejected=[]
    def reject(label,fn):
        try:fn()
        except (AssertionError,ValueError,IndexError,KeyError):rejected.append(label)
        else:raise AssertionError(('accepted tiny corruption',label))
    wrong=x.copy();wrong[3]=Q(0);reject('missing_artificial_error',lambda:check_primal(rows,f,wrong,cost))
    wrong=x.copy();wrong[1]=-1;reject('negative_basis_weight',lambda:check_primal(rows,f,wrong,cost))
    bad=dict(dual);bad['parent']=0;reject('missing_original_parent_dual',lambda:exact_dual(rows,f,4,cost,bad,objective))
    bad=dict(dual);bad['n2']=2;reject('wrong_nonnegative_row_dual_sign',lambda:exact_dual(rows,f,4,cost,bad,objective))
    reject('false_zero_objective',lambda:exact_dual(rows,f,4,cost,dual,Q(0)))
    raw=resolve(m['lp']).read_text()
    reject('changed_objective_coefficient',lambda:parse_lp(None,rows,f,4,cost,raw.replace('+ 1 x2','+ 2 x2',1)))
    result=dict(status='PASS_EXACT_SHARED_MASTER_PRESOLVE_ONE_TINY_CONTROL',manifest_sha256=sha(a.manifest),lp_sha256=m['lp_sha256'],
        primal_sha256=sha(a.primal),dual_sha256=sha(a.dual),solver_frozen_sha256=sha(a.solver_frozen),
        consumer_sha256=sha(Path(__file__).name),parser_sha256=sha('read_soplex_exact_output_v2.py'),
        common_sha256=sha('verify_shared_master_common.py'),source_hashes=m['source_hashes'],
        original_rows_checked=6,all_free_variable_bounds_checked=4,explicit_nonnegative_rows=3,
        exact_primal=list(map(str,x)),normalized_dual_row_weights=[[k,str(v)] for k,v in dual.items()],dual_sign=sign,
        exact_objective=str(objective),exact_dual_objective=str(dualobjective),all_stationarity_equations_checked=4,
        presolve=1,postsolve_original_coordinate_proof=True,negative_controls=rejected,nice=19,threads=1,
        elapsed_seconds=time.monotonic()-start,main_master_solved=False,source_C16_answered=False,
        scope='Only the positive-L1 presolve/postsolve protocol is accepted; no main-master optimum or physical-source conclusion.')
    out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,sort_keys=True,indent=2)+'\n')
    print(json.dumps(result),flush=True)
if __name__=='__main__':main()
