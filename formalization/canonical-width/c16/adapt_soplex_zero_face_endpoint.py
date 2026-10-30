"""Reconstruct a full owner-capacity primal or lift a reduced exact Farkas ray.

The final certificate uses only the immutable full semantic variables/rows.
Independent acceptance never relies on the presolver's omitted coordinates.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse, json, os, time
from two_basis_owner_star_capacity import ROOT,sha,read,decode,empty,plus
from export_owner_star_capacity_lp import semantic_rows
from read_soplex_exact_output import read_named_rational


def evaluate(e,features,parameters):
    return sum((c*features[j] for j,c in e[0].items()),Q(0))+sum(
        (c*parameters[j] for j,c in e[1].items()),Q(0))


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--face-manifest',type=Path,required=True)
    ap.add_argument('--solver-frozen',type=Path,required=True)
    choice=ap.add_mutually_exclusive_group(required=True)
    choice.add_argument('--primal',type=Path);choice.add_argument('--farkas',type=Path)
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS,0)==19 and not a.output.exists()
    face,solver=read(a.face_manifest),read(a.solver_frozen)
    assert face['status']=='PASS_EXACT_ZERO_FACE_LP_TEXT_ROUNDTRIP'
    assert solver['status']=='FROZEN_SINGLE_EXACT_ZERO_FACE_SOPLEX_TRIAL'
    assert solver['input_manifest_sha256']==sha(a.face_manifest)
    assert solver['input_lp_sha256']==face['lp_sha256']==sha(face['lp'])
    assert solver['mapping_sha256']==face['mapping_sha256']==sha(face['mapping'])
    face_check_path=Path(solver['preparation_receipt']);face_check=read(face_check_path)
    assert solver['preparation_receipt_sha256']==sha(face_check_path)
    assert face_check['status']=='PASS_EXACT_OWNER_CAPACITY_ZERO_FACE_REDUCTION'
    assert face_check['manifest_sha256']==sha(a.face_manifest)
    assert face_check['mapping_sha256']==face['mapping_sha256']
    assert face_check['consumer_sha256']==sha('verify_owner_capacity_zero_face.py')
    mapping=read(face['mapping']);manifest_path=Path(face['full_manifest']);manifest=read(manifest_path)
    assert face['full_manifest_sha256']==mapping['full_manifest_sha256']==sha(manifest_path)
    assert solver['semantic_sha256']==face_check['semantic_sha256']==face['semantic_sha256']==manifest['semantic_sha256']==sha(manifest['semantic'])
    prep_path=Path(face['preparation_receipt']);prep=read(prep_path)
    assert face['preparation_receipt_sha256']==mapping['preparation_receipt_sha256']==sha(prep_path)
    assert prep['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL'
    assert prep['manifest_sha256']==sha(manifest_path) and prep['model_sha256']==manifest['semantic_sha256']
    assert prep['consumer_sha256']==sha('verify_owner_star_capacity_extension.py')
    saved=read(manifest['semantic']);model=decode(saved['model'])
    assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items())
    assert all(sha(ROOT/p)==h for p,h in mapping['source_hashes'].items())
    assert saved['point_sha256']==sha(saved['point'])
    assert saved['zero_tau_pins']==mapping['zero_tau_pins']==face['zero_tau_pins']==solver['zero_tau_pins'] is True
    features=list(map(Q,saved['feature_values']))
    rows=list(semantic_rows(model,features,True));names=[r[0]+str(r[1]) for r in rows]
    byname={name:i for i,name in enumerate(names)};assert len(byname)==len(rows)
    retained=mapping['retained_variables'];omitted=mapping['eliminated']
    assert sorted(retained+[e['variable'] for e in omitted])==list(range(len(model['variables'])))
    paths=[a.face_manifest,a.solver_frozen,face_check_path,Path(face['mapping']),
           manifest_path,prep_path,Path(manifest['semantic']),Path(__file__),
           Path('read_soplex_exact_output.py'),Path('verify_owner_capacity_zero_face.py'),
           Path('verify_owner_star_capacity_extension.py')]
    out=dict(manifest=str(manifest_path),manifest_sha256=sha(manifest_path),semantic=manifest['semantic'],
             semantic_sha256=manifest['semantic_sha256'],preparation_receipt=str(prep_path),
             preparation_receipt_sha256=sha(prep_path),face_manifest=str(a.face_manifest),
             face_manifest_sha256=sha(a.face_manifest),point=saved['point'],point_sha256=saved['point_sha256'],
             zero_tau_pins=True,source_C16_answered=False,nice=19)
    if a.primal:
        assert '-X='+str(a.primal.resolve()) in solver['command']
        values=read_named_rational(a.primal,['x'+str(i) for i in range(len(retained))])
        parameters=[Q(0)]*len(model['variables'])
        for i,old in enumerate(retained):parameters[old]=values['x'+str(i)]
        slacks=[]
        for kind,index,relation,e,_ in rows:
            v=evaluate(e,features,parameters)
            assert v==0 if relation=='=' else v<=0,(kind,index,str(v))
            if relation=='<=':slacks.append(-v)
        lam=[evaluate(e,features,parameters) for e in model['lambda_expressions']]
        Y={s:[[evaluate(e,features,parameters) for e in row] for row in model['sectors'][s]['allocations']] for s in 'XZ'}
        out.update(status='EXACT_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION_REQUIRES_REPLAY',
                   lambda_masses=list(map(str,lam)),exact_allocations={s:[list(map(str,row)) for row in Y[s]] for s in 'XZ'},
                   exact_parameters=list(map(str,parameters)),exact_rows_checked=len(rows),
                   minimum_exact_slack=str(min(slacks)),reconstructed_zero_coordinates=len(omitted),
                   maximum_parameter_denominator_bits=max(q.denominator.bit_length() for q in parameters),
                   scope='Exact full finite owner-flow/capacity relaxation at the pinned law; independent physical replay required.')
        paths.append(a.primal)
    else:
        assert '-Y='+str(a.farkas.resolve()) in solver['command']
        named=read_named_rational(a.farkas,mapping['retained_rows'],'farkas')
        attempts=[];proof=None
        for orientation in (-1,1):
            weights={byname[name]:orientation*q for name,q in named.items() if q}
            if any(w<0 for i,w in weights.items() if rows[i][2]=='<='):
                attempts.append(dict(orientation=orientation,status='NEGATIVE_INEQUALITY_MULTIPLIER'));continue
            combined=empty()
            for i,w in weights.items():combined=plus(combined,rows[i][3],w)
            assert not any(combined[1].get(i,Q(0)) for i in retained),'reduced ray does not cancel retained variables'
            additions=[]
            def add_weight(name,w,reason):
                nonlocal combined
                i=byname[name];assert rows[i][2]=='=' or w>=0
                weights[i]=weights.get(i,Q(0))+w
                if weights[i]==0:del weights[i]
                combined=plus(combined,rows[i][3],w)
                additions.append(dict(row=i,weight=str(w),reason=reason))
            for record in omitted:
                if record['reason']=='explicit_zero_tau_pin':continue
                j=record['variable'];r=combined[1].get(j,Q(0))
                if not r:continue
                branch=record['lower'] if r>0 else record['upper']
                for name,w in branch:add_weight(name,abs(r)*Q(w),'zero_probability_'+str(j))
                assert not combined[1].get(j,Q(0))
            for record in omitted:
                if record['reason']!='explicit_zero_tau_pin':continue
                r=combined[1].get(record['variable'],Q(0))
                if r:add_weight(record['pin'],-r,'explicit_law_pin')
            assert not combined[1],'full ray still has residual variables'
            assert all(w>=0 for i,w in weights.items() if rows[i][2]=='<=')
            gap=sum((c*features[j] for j,c in combined[0].items()),Q(0))
            attempts.append(dict(orientation=orientation,exact_gap=str(gap),lift_additions=len(additions)))
            if gap>0:
                proof=dict(exact_gap=str(gap),row_multipliers=[[i,str(w)] for i,w in sorted(weights.items())],
                           owner_target_coefficients=[[j,str(w)] for j,w in sorted(combined[0].items())],
                           exact_cancellation=True)
                out.update(lift_additions=additions,orientation=orientation);break
        assert proof is not None,attempts
        out.update(status='EXACT_OWNER_FLOW_CAPACITY_JOINT_FARKAS_REQUIRES_REPLAY',proof=proof,attempts=attempts,
                   scope='Exact full source-row Farkas lift; law-pin dependence and independent replay determine scope.')
        paths.append(a.farkas)
    out['source_bindings']={str(p):sha(p) for p in paths}
    out['elapsed_seconds']=time.monotonic()-start
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:v for k,v in out.items() if k not in ('exact_allocations','exact_parameters','proof','lift_additions','source_bindings')}),flush=True)


if __name__=='__main__':main()
