#!/usr/bin/env python3
"""Close the one complete8-event capacity repair and its exact parent replay."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,os,time
ROOT=Path(__file__).resolve().parent
def main():
    assert os.getpriority(os.PRIO_PROCESS,0)==19
    for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
    ap=argparse.ArgumentParser();ap.add_argument('--output',required=True);a=ap.parse_args();dest=ROOT/a.output;assert not dest.exists();start=time.monotonic();cache={};inputs={};bindings=0
    def sha(p):
        p=Path(p);p=p if p.is_absolute() else ROOT/p
        if p not in cache:cache[p]=hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(p):
        b=(ROOT/p).read_bytes();return json.loads(gzip.decompress(b) if str(p).endswith('.gz') else b)
    prefix='two-basis-results/joint-owner-k22-eight-point22'
    manifest=read(prefix+'.json');prep=read(prefix+'-independent.json');run=read(prefix+'-solve.json');frozen=read(prefix+'-solve.frozen.json')
    c=read(prefix+'-exact.json');r=read(prefix+'-exact-independent.json');parent=read(prefix+'-parent-independent.json')
    assert prep['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL'
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION' and parent['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['certificate_sha256']==sha(prefix+'-exact.json') and parent['certificate_sha256']==sha(prefix+'-parent-projection.json')
    assert r['manifest_sha256']==prep['manifest_sha256']==sha(prefix+'.json')
    assert r['new_rows_checked']==138 and r['global_eight_features_checked']==37 and r['positive_global_atoms']==47
    assert run['reported_solver_status']=='problem is solved [optimal]' and run['returncode']==0 and run['external_stop'] is None
    assert frozen['internal_seconds']==60 and frozen['external_seconds']==90 and frozen['zero_tau_pins'] is True
    for item in run['outputs'].values():assert sha(item['path'])==item['sha256']
    # Matched attribution: evaluate the accepted old auxiliary row at the new
    # endpoint, retaining exactly its original branches and coefficients.
    oldpath='two-basis-results/joint-owner-capacity-zero-face-point22-exact.json';old=read(oldpath)
    bankpath='two-basis-results/owner-k22-conditional-union-point22.json';bank=read(bankpath);cut=bank['cuts'][0]
    wrapper=read(manifest['semantic']);M=read(wrapper['parent_semantic'])['model'];meta=M['owner_flow_extension'];pairs={tuple(p):i for i,p in enumerate(meta['physical_pairs'])}
    from verify_two_sided_full_basis_oracle import point_owner
    owner=point_owner(c['point'])
    def row_value(cc):
        lam=list(map(Q,cc['lambda_masses']));Y={s:[list(map(Q,row)) for row in cc['exact_allocations'][s]] for s in 'XZ'};p=list(map(Q,cc['exact_parameters']))
        v=sum((Q(w)*lam[m] for m,w in cut['lambda_coefficients']),Q(0))
        for side in 'XZ':v+=sum((Q(w)*Y[side][m][j] for m,j,w in cut['y'+side+'_coefficients']),Q(0))
        v+=sum((Q(w)*p[meta['base_variable_count']+len(pairs)*m+pairs[x,z]] for m,x,z,w in cut['t_coefficients']),Q(0))
        v+=sum((Q(w)*owner[j] for j,w in cut['owner_coefficients']),Q(0));return v-Q(cut['rhs'])
    oldgap=row_value(old);newgap=row_value(c);assert oldgap==Q(cut['exact_violation'])>0 and newgap<=0
    same_law=list(map(Q,old['lambda_masses']))==list(map(Q,c['lambda_masses']));assert same_law
    comparison_path=prefix+'-matched-union.json';assert not (ROOT/comparison_path).exists()
    comparison=dict(status='PASS_EXACT_MATCHED_AUXILIARY_UNION_REPAIR',old_allocation=oldpath,old_allocation_sha256=sha(oldpath),
        new_allocation=prefix+'-exact.json',new_allocation_sha256=sha(prefix+'-exact.json'),cut_bank=bankpath,cut_bank_sha256=sha(bankpath),
        old_exact_violation=str(oldgap),new_exact_violation=str(newgap),same_exact_pattern_law=same_law,
        fixed_old_branches=True,source_C16_answered=False,scope='The same accepted auxiliary row is repaired by changing allocations/flows while retaining the pinned pattern law.')
    (ROOT/comparison_path).write_text(json.dumps(comparison,sort_keys=True,indent=2)+'\n')
    names=set(str(p.relative_to(ROOT)) for p in ROOT.glob(prefix+'*') if p.is_file())
    names.update([Path(__file__).name,'owner_k22_capacity_extension.py','export_owner_k22_capacity_lp.py','run_owner_k22_capacity_soplex.py',
        'adapt_owner_k22_capacity_endpoint.py','verify_owner_k22_capacity_extension.py','verify_owner_k22_capacity_endpoint.py',
        'OWNER-K22-CAPACITY-EXTENSION.md','OWNER-K22-CAPACITY-RESULT.md',
        'two-basis-results/owner-k22-eight-capacity-source-peer-review.json','two-basis-results/owner-k22-capacity-endpoint-controls.json'])
    for p in sorted(names):
        sha(p)
        if not p.endswith(('.json','.json.gz')):continue
        obj=read(p)
        for key in ('source_hashes','dependencies','source_bindings'):
            for name,h in obj.get(key,{}).items():
                assert isinstance(h,str) and sha(name)==h,(p,name);bindings+=1
                if name in inputs:assert inputs[name]==h
                inputs[name]=h
    repository_inputs={};external_inputs={}
    for name,h in inputs.items():
        p=Path(name);p=p if p.is_absolute() else ROOT/p
        try:relative=str(p.relative_to(ROOT))
        except ValueError:external_inputs[str(p)]=h
        else:
            if relative in repository_inputs:assert repository_inputs[relative]==h
            repository_inputs[relative]=h
    for name,h in frozen['runtime_files'].items():assert sha(name)==h;external_inputs[name]=h
    out=dict(status='PASS_COMPLETE_SHARED_EIGHT_EVENT_CAPACITY_GATE_CLOSURE',
        files=[dict(path=p,sha256=sha(p),bytes=(ROOT/p).stat().st_size) for p in sorted(names)],
        input_bindings=inputs,repository_input_bindings=repository_inputs,external_runtime_bindings=external_inputs,input_bindings_checked=bindings,
        point_sha256=c['point_sha256'],reduced_variables=12655,full_variables=22513,reduced_rows=64835,full_rows=98868,
        old_full_rows_retained=98730,new_rows=138,conditional_atoms=176,forbidden_atoms_zero=24,global_features=37,positive_global_atoms=47,
        complete_shared_eight_event_law=True,old_parent_literal_replay=True,same_pinned_pattern_law=True,
        exact_auxiliary_union_repaired=True,new_exact_union_violation=str(newgap),all_subset_rank_membership_claimed=False,
        source_C16_answered=False,physical_source_frame=False,global_target_excluded=False,
        solver_calls=1,solver_wall_seconds=run['seconds'],no_automatic_retry=True,owned_processes_remaining=False,
        checkpoint_copy_rule='Union files with repository_input_bindings; external runtime files remain external. Preserve inherited transitive source closure.',
        transitive_import_closure_claimed=False,priority=19,elapsed_seconds=time.monotonic()-start)
    dest.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(dict(status=out['status'],files=len(names),bindings=bindings,sha256=sha(dest),new_union_gap=str(newgap),seconds=out['elapsed_seconds']))
if __name__=='__main__':main()
