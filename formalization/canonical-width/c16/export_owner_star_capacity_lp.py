"""Prepare exact capacity-version LP from the independently accepted flow model.

No solve; pins remain an optional explicit export choice outside the model.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,json,os,time
from export_joint_general_exact_lp import replay_text
from export_joint_fixed_exact_lp import write_row
from two_basis_owner_star_capacity import ROOT,sha,read,encode,decode,term,append_capacities,row_expression,probability_bound_guard

def semantic_rows(model,features,pin_zero_tau):
    for kind,relation in [('equalities','='),('inequalities','<=')]:
        for i,d in enumerate(model[kind]):
            e=row_expression(model,d);constant=sum((c*features[j] for j,c in e[0].items()),Q(0))
            yield kind,i,relation,e,constant
    if pin_zero_tau:
        for j,v in enumerate(model['variables']):
            if v['kind']=='tau':yield 'zero_tau',j,'=',term(1,j),Q(0)

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    ap=argparse.ArgumentParser();ap.add_argument('--parent-manifest',type=Path,required=True)
    ap.add_argument('--parent-receipt',type=Path,required=True);ap.add_argument('--pin-zero-tau',action='store_true');ap.add_argument('--prefix',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();deadline=start+120
    paths={k:Path(str(a.prefix)+suffix) for k,suffix in [('lp','.lp'),('model','.model.json.gz'),('manifest','.json')]};assert not any(p.exists() for p in paths.values())
    pm,pr=read(a.parent_manifest),read(a.parent_receipt)
    assert pm['status']=='PASS_EXACT_OWNER_FLOW_LP_FRACTION_TEXT_ROUNDTRIP'
    assert pr['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_MODEL'
    assert pr['consumer_sha256']==sha(ROOT/'verify_owner_star_flow_extension.py')
    assert pr['manifest_sha256']==sha(a.parent_manifest) and pr['point_sha256']==pm['point_sha256']
    assert all(sha(ROOT/p)==h for p,h in pr['source_hashes'].items())
    parent=Path(pm['semantic']);assert sha(parent)==pm['semantic_sha256']==pr['model_sha256']
    assert sha(pm['lp'])==pm['lp_sha256'];saved=read(parent);base=decode(saved['model'])
    assert all(sha(ROOT/p)==h for p,h in base['source_hashes'].items())
    model=append_capacities(base);features=list(map(Q,saved['feature_values']));probability_bound_guard(model)
    model['status']='PREPARED_COMPLETE_SELECTED_OWNER_FLOW_AND_CAPACITY_MODEL_NO_SOLVE'
    for p in [Path(__file__),ROOT/'two_basis_owner_star_capacity.py',ROOT/'verify_owner_star_flow_extension.py',a.parent_manifest,a.parent_receipt,parent]:
        model['source_hashes'][str(p.resolve().relative_to(ROOT))]=sha(p)
    n=len(model['variables']);rows=[];labels=[]
    assert n==22481 and len(model['owner_capacity_extension']['rows'])==1328
    with paths['lp'].open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for kind,i,rel,e,constant in semantic_rows(model,features,a.pin_zero_tau):
            name=kind+str(i);write_row(stream,name,e[1],-constant,rel);rows.append((name,rel,e[1],-constant));labels.append(dict(name=name,kind=kind,index=i))
            if len(rows)%1000==0:assert time.monotonic()<deadline
        stream.write('Bounds\n')
        for j in range(n):stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    replay_text(paths['lp'],rows,n);assert len(rows)<=100000 and time.monotonic()<deadline
    assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())
    data=dict(status='EXACT_COMPLETE_OWNER_FLOW_LP_EXPORT_REQUIRE_REPLAY',model=encode(model),feature_values=saved['feature_values'],
        point=saved['point'],point_sha256=saved['point_sha256'],zero_tau_pins=a.pin_zero_tau,row_labels=labels,
        semantic_relaxation='fixed_zero_high_law_with_shared_owner_flows_and_capacities' if a.pin_zero_tau else 'general_shared_law_with_shared_owner_flows_and_capacities')
    paths['model'].write_bytes(gzip.compress((json.dumps(data,separators=(',',':'))+'\n').encode(),mtime=0))
    out=dict(status='PASS_EXACT_OWNER_FLOW_CAPACITY_LP_FRACTION_TEXT_ROUNDTRIP',lp=str(paths['lp']),lp_sha256=sha(paths['lp']),lp_bytes=paths['lp'].stat().st_size,
        semantic=str(paths['model']),semantic_sha256=sha(paths['model']),point_sha256=saved['point_sha256'],source_sha256=sha(__file__),capacity_source_sha256=sha(ROOT/'two_basis_owner_star_capacity.py'),
        parent_manifest=str(a.parent_manifest),parent_manifest_sha256=sha(a.parent_manifest),parent_receipt=str(a.parent_receipt),parent_receipt_sha256=sha(a.parent_receipt),
        variable_count=n,row_count=len(rows),equalities=len(model['equalities']),inequalities=len(model['inequalities']),nonzeros=sum(len(r[2]) for r in rows),capacity_rows=1328,
        zero_tau_pins=a.pin_zero_tau,all_sixteen_patterns=True,nice=19,elapsed_seconds=time.monotonic()-start,solver_run=False,independent_acceptance=False,source_C16_answered=False)
    paths['manifest'].write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))

if __name__=='__main__':main()
