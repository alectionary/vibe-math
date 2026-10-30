"""Exact fraction LP export of the cumulative four-center owner-flow extension.

No solve. Optional zero-tau pins are outside the source-valid general model.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,json,os,time
from export_joint_general_exact_lp import prepare_model,replay_text
from export_joint_fixed_exact_lp import write_row
from two_basis_owner_star_extension import (
    ROOT,sha,read,encode,term,append_owner_flows,row_expression,probability_bound_guard,
)

def cumulative_banks():
    stars=[];ranks=[]
    for stem in ['conditional-owner-star-original-point22','conditional-owner-star-closedrank-point22',
                 'joint-soplex0-separation-point22-stars','joint-general-refine1-separation-point22-stars']:
        stars.append((Path('two-basis-results/'+stem+'.json.gz'),Path('two-basis-results/'+stem+'-independent.json')))
    for stem in ['two-basis-point22-{}-second-closed-rank-bank','joint-soplex0-point22-{}-closed-rank-bank',
                 'joint-general-refine1-point22-{}-closed-rank-bank']:
        for side in 'XZ':
            name='two-basis-results/'+stem.format(side)
            ranks.append((Path(name+'.json'),Path(name+'-independent.json')))
    return stars,ranks

def semantic_rows(model,features,pin_zero_tau):
    for kind,relation in [('equalities','='),('inequalities','<=')]:
        for index,descriptor in enumerate(model[kind]):
            e=row_expression(model,descriptor);constant=sum((v*features[j] for j,v in e[0].items()),Q(0))
            yield kind,index,relation,e,constant
    if pin_zero_tau:
        for j,variable in enumerate(model['variables']):
            if variable['kind']=='tau':yield 'zero_tau',j,'=',term(1,j),Q(0)

def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    ap=argparse.ArgumentParser();ap.add_argument('--selection',type=Path,required=True)
    ap.add_argument('--pin-zero-tau',action='store_true');ap.add_argument('--prefix',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();deadline=start+120
    paths={k:Path(str(a.prefix)+suffix) for k,suffix in [('lp','.lp'),('model','.model.json.gz'),('manifest','.json')]}
    assert not any(p.exists() for p in paths.values())
    source_model=Path('two-basis-results/two-basis-joint-general-point22.json.gz')
    source_receipt=Path('two-basis-results/two-basis-joint-general-point22-independent.json')
    point=Path('coupling-results/two-basis-integer-witness22-rational.json.gz');stars,ranks=cumulative_banks()
    base,features=prepare_model(source_model,source_receipt,point,stars,ranks)
    selection=read(a.selection);assert selection['point_sha256']==sha(point)
    assert selection['cohort_sha256']==sha(selection['cohort']) and selection['cohort_receipt_sha256']==sha(selection['cohort_receipt'])
    X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    model=append_owner_flows(base,[tuple(p) for p in selection['probes']],X,Z)
    model['status']='PREPARED_COMPLETE_SELECTED_OWNER_STAR_FLOW_EXTENSION_NO_SOLVE'
    for p in [Path(__file__),ROOT/'two_basis_owner_star_extension.py',ROOT/'export_joint_general_exact_lp.py',
              ROOT/'export_joint_fixed_exact_lp.py',a.selection,Path(selection['cohort']),Path(selection['cohort_receipt'])]:
        model['source_hashes'][str(p.resolve().relative_to(ROOT))]=sha(p)
    probability_bound_guard(model);n=len(model['variables']);rows=[];labels=[]
    assert n<=30000 and len(model['inequalities'])<=100000
    with paths['lp'].open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for kind,index,relation,e,constant in semantic_rows(model,features,a.pin_zero_tau):
            name=kind+str(index);write_row(stream,name,e[1],-constant,relation)
            rows.append((name,relation,e[1],-constant));labels.append(dict(name=name,kind=kind,index=index))
            if len(rows)%1000==0:assert time.monotonic()<deadline,'preparation120s cap'
        stream.write('Bounds\n')
        for j in range(n):stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    replay_text(paths['lp'],rows,n)
    assert len(rows)<=100000
    assert time.monotonic()<deadline,'preparation120s cap'
    assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())
    saved=dict(status='EXACT_COMPLETE_OWNER_FLOW_LP_EXPORT_REQUIRE_REPLAY',model=encode(model),
        feature_values=list(map(str,features)),point=str(point),point_sha256=sha(point),zero_tau_pins=a.pin_zero_tau,
        row_labels=labels,semantic_relaxation='fixed_zero_high_law_with_shared_owner_flows' if a.pin_zero_tau else 'general_shared_law_with_shared_owner_flows')
    paths['model'].write_bytes(gzip.compress((json.dumps(saved,separators=(',',':'))+'\n').encode(),mtime=0))
    meta=model['owner_flow_extension']
    out=dict(status='PASS_EXACT_OWNER_FLOW_LP_FRACTION_TEXT_ROUNDTRIP',lp=str(paths['lp']),lp_sha256=sha(paths['lp']),
        lp_bytes=paths['lp'].stat().st_size,semantic=str(paths['model']),semantic_sha256=sha(paths['model']),
        source_sha256=sha(__file__),extension_source_sha256=sha(ROOT/'two_basis_owner_star_extension.py'),
        selection=str(a.selection),selection_sha256=sha(a.selection),point_sha256=sha(point),
        variable_count=n,base_variables=meta['base_variable_count'],joint_variables=len(meta['cells']),
        row_count=len(rows),base_equalities=len(model['equalities']),inequalities=len(model['inequalities']),
        nonzeros=sum(len(r[2]) for r in rows),base_inequalities=meta['base_inequality_count'],
        stars=len(model['star_rows']),rank_rows={side:len(model['sectors'][side]['rank_rows']) for side in 'XZ'},
        probes=selection['probes'],physical_edges=len(meta['physical_pairs']),shared_edges=meta['shared_edges'],
        structural_zero_cells=len(meta['structural_zeros']),zero_tau_pins=a.pin_zero_tau,all_sixteen_patterns=True,
        nice=19,elapsed_seconds=time.monotonic()-start,independent_acceptance=False,solver_run=False,source_C16_answered=False,
        scope='Exact text roundtrip of a source-valid shared owner-flow model; optional law pins explicitly outside the general model. Await independent preparation consumer before solving.')
    paths['manifest'].write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))

if __name__=='__main__':main()
