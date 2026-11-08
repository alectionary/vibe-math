#!/usr/bin/env python3
"""Freeze and run a bounded coupled-moment trial, preserving failures."""
from pathlib import Path
import argparse,ast,datetime,gzip,hashlib,json,os,subprocess,sys,time
import importlib.metadata
ROOT=Path(__file__).resolve().parent

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def local_imports(path, found):
    if path in found:return
    found.add(path)
    for node in ast.walk(ast.parse(path.read_text())):
        modules=([node.module] if isinstance(node,ast.ImportFrom) else [a.name for a in node.names] if isinstance(node,ast.Import) else [])
        for module in modules:
            if module:
                candidate=ROOT/(module.split('.')[0]+'.py')
                if candidate.exists():local_imports(candidate,found)

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--name',required=True)
    ap.add_argument('--seconds',type=float,default=180)
    ap.add_argument('--outer-seconds',type=float,default=300)
    ap.add_argument('--witness-margin',type=float,default=0)
    ap.add_argument('--extra',nargs=argparse.REMAINDER,default=[])
    a=ap.parse_args();folder=ROOT/'coupling-results';folder.mkdir(exist_ok=True)
    output=folder/(a.name+'.json');frozen=folder/(a.name+'-frozen.json')
    assert not output.exists() and not frozen.exists()
    old='moment-resumption-results/'
    cmd=[sys.executable,'-u','unified_anchor_coupling_model.py',
         '--hulls','algebraic-results/hulls-16-rank.json.gz',
         '--capacity-cuts','algebraic-results/orbit-rank-profiles-independent.json',
         '--conditional-matrix','algebraic-results/conditional-capacity/independent.json',
         '--conditional-cross-matrix','algebraic-results/conditional-cross-capacity/independent.json',
         '--conditional-linear-cuts','algebraic-results/conditional-facets-round1-independent.json',old+'all-pair-moment-faces.json',
         '--forbidden-patterns','relevant-results/seed-cuts.json',old+'all-pair-word-cuts.json',
         '--active-cuts',old+'boolean-active1.json',
         '--matroid-cuts',old+'closed-rank-bank-augmented.json',old+'final-point-rank-probe.json',
         '--matroid-replays',old+'closed-rank-bank-augmented-independent.json',old+'final-point-rank-probe-independent.json',
         '--boolean-cuts',old+'consolidated-all-triples.json',old+'boolean-all-triples0.json',
         '--projected-cuts',old+'common-profile32-projected-pruned.json',
         '--projected-replays',old+'common-profile32-projected-pruned-independent.json',
         '--basis-cuts','coupling-results/full-partner-projection-wolfe-witness2.json',
         '--basis-replays','coupling-results/full-partner-projection-wolfe-witness2-independent.json',
         '--warm-point',old+'boolean-interior1.npz','--eps','1e-11','--iterations','100000',
         '--seconds',str(a.seconds),'--psd-interior-epsilon',str(a.witness_margin),
         '--boolean-margin',str(a.witness_margin/10),'--projected-margin',str(a.witness_margin/10),
         '--output',str(output.relative_to(ROOT)),*a.extra]
    modules=['unified_anchor_coupling_model.py','run_anchor_coupling_trial.py',
             'canonical_forbidden_moment_matrix.py','physical_owner_moment_matrix.py',
             'physical_circuit_moment_matrix.py','physical_legacy_linear_moments.py',
             'conditional_matroid_moment_matrix.py','complete_boolean_triples.py',
             'projected_profile_moment_matrix.py','verify_algebraic_model.py',
             'accepted_anchor_coupling_rows.py','accepted_full_partner_rows.py','verify_full_partner_projection.py',
             'verify_full_partner_projection_generic.py','verify_full_partner_orbit_cap_lagrange.py',
             'verify_full_partner_basis_oracle.py','verify_partial_frame.py','audit_pools.py','physical-pool-source.json',
             'algebraic-results/orbit-rank-profiles.json.gz',
             'pools/xcoords.txt','pools/zcoords.txt',old+'physical-rank-moment-bank.json',
             'block_moment_dual.py','moment_triangle_cuts.py','moment_integer_form_cuts.py',
             'inverse-four-hour-results/lattice-source-rankcuts.json.gz',
             'inverse-four-hour-results/rank-rectangle-X.json',
             'inverse-four-hour-results/rank-rectangle-Z.json',
             'inverse-four-hour-results/lattice-source-triangles.json.gz',
             'inverse-four-hour-results/lattice-source-integer-forms.json.gz']
    paths=modules+[x for x in cmd if x.endswith(('.json','.gz','.npz')) and x!=str(output.relative_to(ROOT))]
    closure=set()
    for path in modules:
        if path.endswith('.py'):local_imports(ROOT/path,closure)
    paths.extend(str(path.relative_to(ROOT)) for path in sorted(closure))
    pending=list(dict.fromkeys(paths));visited=set()
    while pending:
        path=pending.pop()
        if path in visited:continue
        visited.add(path)
        if not path.endswith(('.json','.json.gz')):continue
        raw=(ROOT/path).read_bytes();data=json.loads(gzip.decompress(raw) if path.endswith('.gz') else raw)
        if not isinstance(data,dict):continue
        extra=[]
        if data.get('status')=='EXACT_PRICED_SUPPORT_CANDIDATE':extra.append(str(Path(path).with_suffix('.frozen.json')))
        for key in ['source_hashes','dependencies']:
            if isinstance(data.get(key),dict):extra.extend(data[key])
        if 'profile_replay_path' in data:extra.append(data['profile_replay_path'])
        for dependency in extra:
            assert (ROOT/dependency).exists(),dependency
            paths.append(dependency)
            if dependency not in visited:pending.append(dependency)
    hashes={p:sha(ROOT/p) for p in dict.fromkeys(paths)}
    limits={k:'1' for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']}
    margin_flags=['--psd-interior-epsilon','--boolean-margin','--projected-margin']
    effective_margins={flag:float(cmd[max(i for i,v in enumerate(cmd) if v==flag)+1]) for flag in margin_flags}
    assert all(value>=0 for value in effective_margins.values())
    assert not any(any(token.startswith(flag+'=') for flag in margin_flags) for token in a.extra), 'Use separate flag and value for audited margin overrides'
    frozen.write_text(json.dumps({'status':'FROZEN_BEFORE_COUPLING_TRIAL','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                     'runtime':{'python':sys.version,'packages':{p:importlib.metadata.version(p) for p in ['numpy','scipy','cvxpy','scs']}},'command':cmd,'input_and_source_hashes':hashes,'thread_limits':limits,'outer_seconds':a.outer_seconds,
                     'source_C16_answered':False,'mode':'necessary_numeric' if not any(effective_margins.values()) else 'sufficient_witness_search',
                     'effective_margins':effective_margins,
                     'concurrent_context':'Other independent research/verification tasks may run; wall times are not matched speedup evidence.'},indent=2)+'\n')
    env=os.environ.copy();env.update(limits);start=time.monotonic()
    with (folder/(a.name+'.log')).open('w') as log:
        try:
            process=subprocess.run(cmd,cwd=ROOT,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=a.outer_seconds)
            result={'returncode':process.returncode,'outer_timeout':False}
        except subprocess.TimeoutExpired:result={'returncode':None,'outer_timeout':True}
    result.update(elapsed_seconds=time.monotonic()-start,finished_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  frozen_sha256=sha(frozen),sources_unchanged={p:sha(ROOT/p)==digest for p,digest in hashes.items()})
    (folder/(a.name+'-exit.json')).write_text(json.dumps(result,indent=2)+'\n')
    if output.exists():
        report=json.loads(output.read_text())
        if report.get('status')=='RUNNING':
            report['status']='UNKNOWN_OUTER_LIMIT' if result['outer_timeout'] else 'FAILED_BEFORE_RESULT'
            output.write_text(json.dumps(report,indent=2)+'\n')
    print({k:v for k,v in result.items() if k!='sources_unchanged'},flush=True)
    assert all(result['sources_unchanged'].values()),'A frozen dependency changed during the trial'

if __name__=='__main__':main()
