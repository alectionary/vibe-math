"""Exact zero-face size/map diagnostic only; no LP export and no solve."""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import argparse,gzip,json,os,time

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):os.environ[k]='1'
    from two_basis_owner_star_capacity import ROOT,sha,read,decode,probability_bound_guard
    from two_basis_owner_star_extension import coordinate
    from export_owner_star_capacity_lp import semantic_rows
    ap=argparse.ArgumentParser();ap.add_argument('--semantic',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    start=time.monotonic();assert not a.output.exists();saved=read(a.semantic);model=decode(saved['model'])
    assert saved['zero_tau_pins'] is True
    assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())
    probability_bound_guard(model);features=list(map(Q,saved['feature_values']));meta=model['owner_flow_extension'];n=len(model['variables']);reasons={}
    tau={i for i,v in enumerate(model['variables']) if v['kind']=='tau'};assert tau==set(range(5))
    zero_masks=[]
    for m,e in enumerate(model['lambda_expressions']):
        assert set(e[1])<=tau
        c=sum((v*features[j] for j,v in e[0].items()),Q(0))
        if c==0:zero_masks.append(m)
        else:assert c>0
    assert zero_masks==[7,11,13,14,15]
    for i,v in enumerate(model['variables']):
        why=[]
        if i in tau:why.append(dict(kind='zero_tau_pin',row='zero_tau'+str(i)))
        if v['kind'] in ('allocation','owner_joint') and v['mask'] in zero_masks:
            why.append(dict(kind='zero_lambda_mask',mask=v['mask'],proof='lambda exactzero from pins; literal probability boxes force y and t zero'))
        if why:reasons[i]=why
    structural_index={(d['mask'],d['edge']):i for i,d in enumerate(model['inequalities']) if d['kind']=='owner_flow_bound' and d['bound']=='structural_zero'}
    E=len(meta['physical_pairs'])
    for z in meta['structural_zeros']:
        m,edge=z['mask'],z['edge'];i=meta['base_variable_count']+m*E+edge
        reasons.setdefault(i,[]).append(dict(kind='structural_owner_zero',mask=m,edge=edge,upper_row='inequalities'+str(structural_index[m,edge])))
    fixed=set(reasons);remaining=[i for i in range(n) if i not in fixed];inverse={i:j for j,i in enumerate(remaining)}
    extraT={}
    for edge,(x,z) in enumerate(meta['physical_pairs']):
        if features[coordinate(x,z)+1]==0:
            for m in range(16):
                i=meta['base_variable_count']+m*E+edge
                if i not in fixed:extraT[i]=dict(kind='zero_unconditional_T',edge=edge,owner_coordinate=coordinate(x,z))
    stats={};rowmap=[]
    for label,zeros in [('requested_exact_face',fixed),('with_optional_zero_T_columns',fixed|set(extraT))]:
        counts=Counter();nonzeros=0;contradictions=[];ri=0
        for kind,index,relation,e,c in semantic_rows(model,features,True):
            row={j:v for j,v in e[1].items() if j not in zeros};name=kind+str(index)
            if not row:
                if c==0:state='drop_identically_zero';counts[state]+=1
                elif relation=='<=' and c<0:state='drop_exact_constant_tautology';counts[state]+=1
                else:state='exact_constant_contradiction';contradictions.append(dict(row=name,relation=relation,constant=str(c)));counts[state]+=1
                newindex=None
            else:state='retain';newindex=ri;ri+=1;nonzeros+=len(row);counts['retained_'+relation]+=1
            if label=='requested_exact_face':rowmap.append(dict(original_row=name,action=state,reduced_row_index=newindex))
        stats[label]=dict(variables=n-len(zeros),fixed_zero_variables=len(zeros),rows=ri,nonzeros=nonzeros,counts=dict(counts),constant_contradictions=contradictions)
    result=dict(status='EXACT_OWNER_FLOW_ZERO_FACE_COUNT_NO_EXPORT_NO_SOLVE',semantic=str(a.semantic),semantic_sha256=sha(a.semantic),producer_sha256=sha(__file__),point_sha256=saved['point_sha256'],
        mandatory_zero_lambda_patterns=zero_masks,original_variables=n,original_rows=len(rowmap),counts=stats,
        zero_reason_counts=dict(Counter(r['kind'] for rs in reasons.values() for r in rs)),
        fixed_zero_variables=[dict(index=i,reasons=reasons[i])for i in sorted(reasons)],
        reduced_to_full=remaining,full_to_reduced=[inverse.get(i,-1) for i in range(n)],row_map=rowmap,
        optional_extra_zero_T_variables=[dict(index=i,reason=r)for i,r in sorted(extraT.items())],
        scope='Counts and explicit zero map only. Root owns reduced export/full-parameter reconstruction. A successful reduced primal must replay all original semantic rows after zero insertion; duals must lift removed-variable residuals with exact bound/pin rows.',
        zero_tau_pins_required=True,source_C16_answered=False,solver_run=False,elapsed_seconds=time.monotonic()-start)
    a.output.write_bytes(gzip.compress((json.dumps(result,separators=(',',':'))+'\n').encode(),mtime=0))
    print(json.dumps({k:result[k] for k in ['status','mandatory_zero_lambda_patterns','original_variables','original_rows','counts','zero_reason_counts','elapsed_seconds']},indent=2))
if __name__=='__main__':main()
