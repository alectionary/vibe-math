#!/usr/bin/env python3
"""Build a declared source/data closure and replay frozen evidence in a copy."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
import argparse, ast, gzip, hashlib, json, os, re, shutil, subprocess, time
from two_basis_replay_paths import RecordedRoot

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def data(p):return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def jobs():
    out=[]
    for quad in ['32x27','27x32']:
        out.append((f'whole-{quad}', ['audit_two_sided_full_basis_endpoint_portable.py','--report',f'two-basis-results/two-sided-full-basis-{quad}-wolfe-point15.json']))
    for side in ['X','Z']:
        out.append((f'fixed-lambda-{side}', ['audit_two_basis_fixed_lambda_endpoint_portable.py','--report',f'two-basis-results/two-basis-fixed-lambda-wolfe-32x27-{side}-point15.json']))
        out.append((f'inner-initial-{side}', ['audit_two_basis_inner_initial_portable.py','--report',f'two-basis-results/two-basis-inner-32x27-{side}-point15.json']))
        out.append((f'phase-I-start-{side}', ['verify_two_basis_phase_I_start_portable.py','--initial',f'two-basis-results/two-basis-inner-v2-32x27-{side}-point15.initial-exact.json',
            '--reference',f'two-basis-results/two-basis-inner-32x27-{side}-point15-independent.json',
            '--reference-report',f'two-basis-results/two-basis-inner-32x27-{side}-point15.json']))
        out.append((f'five-pattern-{side}', ['verify_two_basis_five_pattern_repair_portable.py','--certificate',f'two-basis-results/two-basis-five-pattern-{side}-l2-point15.json.gz',
            '--point','coupling-results/integer-witness15-rational.json.gz']))
    out.append(('batch-IPM',['verify_two_basis_batch_ipm_portable.py','--report','two-basis-results/two-basis-batch-ipm-X-nearest-point15.json']))
    return out
def closure(seeds, recorded_root=ROOT):
    pending=list(seeds);seen=set()
    def candidate(value):
        if not isinstance(value,str) or not re.search(r'\.(?:py|json|gz|npz|txt|md)$',value):return
        p=Path(value)
        if p.is_absolute():
            if not p.is_relative_to(recorded_root):return
            p=p.relative_to(recorded_root)
        if '..' in p.parts:return
        try:exists=(ROOT/p).is_file()
        except OSError:return
        if exists and p.as_posix() not in seen:pending.append(p.as_posix())
    def walk(value):
        if isinstance(value,dict):
            for k,v in value.items():candidate(k);walk(v)
        elif isinstance(value,list):
            for v in value:walk(v)
        else:candidate(value)
    while pending:
        name=Path(pending.pop()).as_posix()
        if name in seen:continue
        p=ROOT/name;assert p.is_file() and p.resolve().is_relative_to(ROOT)
        seen.add(name);assert len(seen)<10000
        if p.suffix=='.py':
            for node in ast.walk(ast.parse(p.read_text())):
                if isinstance(node,ast.Constant) and isinstance(node.value,str):candidate(node.value)
                modules=([node.module] if isinstance(node,ast.ImportFrom) else [x.name for x in node.names] if isinstance(node,ast.Import) else [])
                for module in modules:
                    if module:candidate(module.split('.')[0]+'.py')
        if p.suffix=='.json' or str(p).endswith('.json.gz'):
            walk(data(p))
            stem=name.removesuffix('.json.gz').removesuffix('.json')
            candidate(stem+'.frozen.json')
            candidate(stem+'.lp-data.npz')
            for suffix in ['.initial-exact','.last-feasible-exact']:
                if stem.endswith(suffix):candidate(stem.removesuffix(suffix)+'.frozen.json')
    return sorted(seen)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--recorded-root',type=Path,required=True);ap.add_argument('--copy-root',type=Path,required=True);ap.add_argument('--output-dir',type=Path,required=True)
    a=ap.parse_args();assert not a.copy_root.exists() and not a.output_dir.exists();start=time.monotonic()
    cohort=jobs();seeds=[Path(__file__).name,'two_basis_replay_paths.py','two-basis-results/two-basis-portable-consumer-source-map.json',
        'physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/hulls-16-rank.json.gz']
    for _,args in cohort:
        seeds.extend(v for v in args if not v.startswith('--'))
    names=closure(seeds,a.recorded_root);files=[dict(path=n,sha256=sha(ROOT/n),bytes=(ROOT/n).stat().st_size) for n in names]
    assert sum(r['bytes'] for r in files)<500_000_000
    a.copy_root.mkdir(parents=True);a.output_dir.mkdir(parents=True)
    for r in files:
        destination=a.copy_root/r['path'];destination.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(ROOT/r['path'],destination);assert sha(destination)==r['sha256']
    # Exact path controls, including refusal to fall back to an existing old file.
    paths=RecordedRoot(a.copy_root,a.recorded_root);sample='two-basis-results/two-basis-fixed-lambda-wolfe-32x27-X-point15.columns.npz'
    assert paths.resolve(a.recorded_root/sample)==(a.copy_root/sample).resolve()
    assert paths.resolve(sample)==(a.copy_root/sample).resolve()
    rejected=[]
    for label,value in [('foreign absolute prefix','/private/tmp/undeclared-c16/file.npz'),('parent traversal','../file.npz')]:
        try:paths.resolve(value)
        except AssertionError:rejected.append(label)
        else:raise AssertionError('unsafe path mapping accepted')
    manifest=dict(status='FROZEN_PORTABLE_SOURCE_DATA_CLOSURE',source_root=str(ROOT),recorded_root=str(a.recorded_root),copy_root=str(a.copy_root.resolve()),
        files=files,total_files=len(files),total_bytes=sum(r['bytes'] for r in files),
        resolver_controls_rejected=rejected,cohort=[dict(name=n,arguments=args) for n,args in cohort],
        producer_sha256=sha(__file__),no_original_files_modified=True)
    (a.output_dir/'closure.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({'copied_files':len(files),'bytes':manifest['total_bytes']}),flush=True)
    temp=a.copy_root/'two-basis-results/portable-smoke-results';temp.mkdir()
    env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
    def run(job):
        name,args=job;output=temp/(name+'.json');log=temp/(name+'.log')
        command=['/private/tmp/c16-venv/bin/python','-B',*args,'--recorded-root',str(a.recorded_root),'--output',str(output)]
        t=time.monotonic()
        with log.open('w') as stream:
            try:r=subprocess.run(command,cwd=a.copy_root,env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=180);code=r.returncode
            except subprocess.TimeoutExpired:code='EXTERNAL_TIMEOUT_180_SECONDS'
        record=dict(name=name,returncode=code,elapsed_seconds=time.monotonic()-t,command=command)
        shutil.copy2(log,a.output_dir/log.name)
        if output.exists():
            shutil.copy2(output,a.output_dir/output.name);receipt=data(output)
            assert receipt['portable_replay']['current_root']==str(a.copy_root.resolve())
            assert receipt['portable_replay']['recorded_root']==str(a.recorded_root)
            record.update(receipt_sha256=sha(output),status=receipt['status'],path_rewrites=receipt['portable_replay']['explicit_rewrites'])
        print(json.dumps(record),flush=True);return record
    results=[]
    with ThreadPoolExecutor(max_workers=2) as pool:
        for future in as_completed([pool.submit(run,j) for j in cohort]):results.append(future.result())
    assert all(sha(ROOT/r['path'])==r['sha256'] for r in files),'a bound source changed during replay'
    passed=all(r['returncode']==0 and 'receipt_sha256' in r for r in results)
    summary=dict(status='PASS_CLEAN_COPY_PORTABLE_REPLAY' if passed else 'PORTABLE_REPLAY_REQUIRES_FOLLOWUP',
        closure_sha256=sha(a.output_dir/'closure.json'),source_data_files=len(files),source_data_bytes=manifest['total_bytes'],
        results=results,elapsed_seconds=time.monotonic()-start,source_C16_answered=False,
        scope='Only explicit declared-prefix path resolution changes. Frozen reports and consumers are unmodified; all original hash and physical checks remain.')
    (a.output_dir/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps({k:v for k,v in summary.items() if k!='results'}),flush=True)
    assert passed
if __name__=='__main__':main()
