#!/usr/bin/env python3
"""Reconstruct full old/new variables or lift a pinned-law exact dual."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,json,os,time
from owner_k22_capacity_extension import ROOT,sha,read,decode,empty,plus,unpack,evaluate,center_atoms
from export_owner_star_capacity_lp import semantic_rows
from read_soplex_exact_output_v2 import read_named_rational
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',required=True);ap.add_argument('--solver-frozen',required=True);ap.add_argument('--output',required=True)
    ap.add_argument('--parent-projection');g=ap.add_mutually_exclusive_group(required=True);g.add_argument('--primal');g.add_argument('--farkas');a=ap.parse_args();start=time.monotonic();assert not Path(a.output).exists()
    m=read(a.manifest);w=read(m['semantic']);f=read(a.solver_frozen)
    assert m['status']=='PASS_EXACT_OWNER_K22_CAPACITY_LP_TEXT_ROUNDTRIP' and f['status']=='FROZEN_SINGLE_EXACT_OWNER_K22_CAPACITY_SOPLEX_TRIAL'
    assert f['input_manifest_sha256']==sha(a.manifest) and f['input_lp_sha256']==m['lp_sha256']==sha(m['lp']) and f['semantic_sha256']==m['semantic_sha256']==sha(m['semantic'])
    prep=read(f['preparation_receipt']);assert sha(f['preparation_receipt'])==f['preparation_receipt_sha256']
    assert prep['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL' and prep['manifest_sha256']==sha(a.manifest) and prep['consumer_sha256']==sha('verify_owner_k22_capacity_extension.py')
    assert all(sha(p)==h for p,h in w['source_hashes'].items())
    saved=read(w['parent_semantic']);M=decode(saved['model']);features=list(map(Q,saved['feature_values']));mapping=read(w['parent_mapping']);face=read(w['parent_face_manifest']);full=read(w['parent_full_manifest'])
    assert w['zero_tau_pins'] is f['zero_tau_pins'] is True
    oldrows=list(semantic_rows(M,features,True));rows=[(kind+str(i),rel,e) for kind,i,rel,e,c in oldrows]
    assert len(rows)==98730
    rows.extend((r['name'],r['relation'],unpack(r['expression'])) for r in w['appended_rows']);assert len(rows)==98868
    byname={name:i for i,(name,rel,e) in enumerate(rows)};assert len(byname)==len(rows)
    keep=mapping['retained_variables']+list(range(22481,22513));assert len(keep)==12655
    sources={p:sha(p) for p in [a.manifest,m['semantic'],a.solver_frozen,f['preparation_receipt'],w['parent_mapping'],w['parent_semantic'],w['parent_full_manifest'],w['parent_face_manifest'],
             Path(__file__).name,'owner_k22_capacity_extension.py','read_soplex_exact_output_v2.py']}
    out=dict(manifest=a.manifest,manifest_sha256=sha(a.manifest),semantic=m['semantic'],semantic_sha256=m['semantic_sha256'],
             solver_frozen=a.solver_frozen,solver_frozen_sha256=sha(a.solver_frozen),preparation_receipt=f['preparation_receipt'],preparation_receipt_sha256=sha(f['preparation_receipt']),
             point=saved['point'],point_sha256=saved['point_sha256'],zero_tau_pins=True,source_C16_answered=False)
    if a.primal:
        assert a.parent_projection and not Path(a.parent_projection).exists();assert '-X='+str(Path(a.primal).resolve()) in f['command']
        raw=read_named_rational(a.primal,['x'+str(i) for i in range(12655)]);params=[Q(0)]*22513
        for i,j in enumerate(keep):params[j]=raw['x'+str(i)]
        for name,rel,e in rows:
            value=evaluate(e,features,params);assert value==0 if rel=='=' else value<=0,(name,str(value))
        lam=[evaluate(e,features,params) for e in M['lambda_expressions']]
        Y={s:[[evaluate(e,features,params) for e in row] for row in M['sectors'][s]['allocations']] for s in 'XZ'}
        sources[a.primal]=sha(a.primal)
        parent=dict(status='EXACT_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION_REQUIRES_REPLAY',manifest=w['parent_full_manifest'],manifest_sha256=sha(w['parent_full_manifest']),
            semantic=w['parent_semantic'],semantic_sha256=sha(w['parent_semantic']),preparation_receipt=face['preparation_receipt'],preparation_receipt_sha256=sha(face['preparation_receipt']),
            face_manifest=w['parent_face_manifest'],face_manifest_sha256=sha(w['parent_face_manifest']),point=saved['point'],point_sha256=saved['point_sha256'],zero_tau_pins=True,
            exact_parameters=list(map(str,params[:22481])),lambda_masses=list(map(str,lam)),exact_allocations={s:[list(map(str,row)) for row in Y[s]] for s in 'XZ'},
            source_bindings=sources,derived_from_extended_manifest=a.manifest,derived_from_extended_primal=a.primal,
            original_parent_solver_not_rerun=True,source_C16_answered=False,
            scope='Literal old-model projection of a new complete8-event endpoint; no claim that the old solver produced these parameters.')
        Path(a.parent_projection).write_text(json.dumps(parent,sort_keys=True,indent=2)+'\n')
        atoms=[[str(evaluate(center_atoms(M,mask).get(c,empty()),features,params)) for c in range(16)] for mask in range(16)]
        out.update(status='EXACT_OWNER_K22_CAPACITY_ALLOCATION_REQUIRES_REPLAY',exact_parameters=list(map(str,params)),
            lambda_masses=list(map(str,lam)),exact_allocations=parent['exact_allocations'],center_atoms=atoms,
            parent_projection=a.parent_projection,parent_projection_sha256=sha(a.parent_projection),full_rows_checked=len(rows),
            same_sector_pair_masses={s:[str(params[22481+2*mask+i]) for mask in range(16)] for i,s in enumerate('XZ')},
            scope='Pinned-law finite capacity allocation with a complete shared8-event law; independent full parent and new-atom replay required.')
        sources[a.parent_projection]=sha(a.parent_projection)
    else:
        assert '-Y='+str(Path(a.farkas).resolve()) in f['command']
        reduced_names=mapping['retained_rows']+[r['name'] for r in w['appended_rows']]
        named=read_named_rational(a.farkas,reduced_names,'farkas');proof=None;attempts=[]
        for sign in (-1,1):
            weights={name:sign*q for name,q in named.items() if q}
            if any(q<0 for name,q in weights.items() if rows[byname[name]][1]=='<='):continue
            total=empty()
            for name,q in weights.items():total=plus(total,rows[byname[name]][2],q)
            assert not any(total[1].get(j,Q(0)) for j in keep)
            additions=[]
            def add(name,q):
                nonlocal total
                assert rows[byname[name]][1]=='=' or q>=0
                weights[name]=weights.get(name,Q(0))+q
                if not weights[name]:del weights[name]
                total=plus(total,rows[byname[name]][2],q);additions.append([name,str(q)])
            for record in mapping['eliminated']:
                if record['reason']=='explicit_zero_tau_pin':continue
                residual=total[1].get(record['variable'],Q(0))
                if residual:
                    for name,q in record['lower'] if residual>0 else record['upper']:add(name,abs(residual)*Q(q))
                    assert record['variable'] not in total[1]
            for record in mapping['eliminated']:
                if record['reason']=='explicit_zero_tau_pin':
                    residual=total[1].get(record['variable'],Q(0))
                    if residual:add(record['pin'],-residual)
            assert not total[1]
            gap=sum((q*features[j] for j,q in total[0].items()),Q(0));attempts.append(dict(sign=sign,gap=str(gap)))
            if gap>0:
                proof=dict(row_multipliers=[[name,str(q)] for name,q in sorted(weights.items())],owner_target_coefficients=[[j,str(q)] for j,q in sorted(total[0].items())],
                           exact_gap=str(gap),exact_cancellation=True,lift_additions=additions,pin_rows_used=[name for name in weights if name.startswith('zero_tau')]);break
        assert proof is not None,attempts
        out.update(status='EXACT_OWNER_K22_CAPACITY_FARKAS_REQUIRES_REPLAY',proof=proof,attempts=attempts,global_target_excluded=False,
                   scope='Candidate exact contradiction of the pinned-law extension only; no pin-free/source-global inference claimed.')
        sources[a.farkas]=sha(a.farkas)
    out['source_bindings']=sources;out['elapsed_seconds']=time.monotonic()-start
    Path(a.output).write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ('source_bindings','exact_parameters','exact_allocations','center_atoms','proof','same_sector_pair_masses')})
if __name__=='__main__':main()
