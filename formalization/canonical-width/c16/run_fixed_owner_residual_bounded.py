#!/usr/bin/env python3
"""One externally bounded fixed-owner query after independent input gates."""
from pathlib import Path
import argparse,os,subprocess,sys,time
from fixed_owner_residual_rank import ROOT,runtime_guard,read,sha,write

def main():
    runtime_guard();ap=argparse.ArgumentParser();ap.add_argument('--frozen',type=Path,required=True)
    ap.add_argument('--preparation-receipt',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True)
    ap.add_argument('--external-seconds',type=float,default=60);a=ap.parse_args()
    assert 0<a.external_seconds<=120
    f=read(a.frozen);r=read(a.preparation_receipt)
    assert r['status']=='PASS_INDEPENDENT_FIXED_OWNER_RESIDUAL_PREPARATION' and r['frozen_sha256']==sha(a.frozen)
    assert f['status']=='FROZEN_FIXED_OWNER_RESIDUAL_RANK_QUERY_REQUIRES_PREPARATION_REPLAY'
    assert 0<f['solver_caps']['seconds']<a.external_seconds
    for p,h in {**f['source_hashes'],**r['source_hashes']}.items():assert sha(p)==h
    paths={k:Path(str(a.prefix)+suffix) for k,suffix in [('endpoint','.json.gz'),('log','.log'),('frozen','.run-frozen.json'),('exit','.run.json')]}
    assert all(not (ROOT/p).exists() for p in paths.values())
    command=[sys.executable,'-B',str(ROOT/'fixed_owner_residual_rank.py'),'worker','--frozen',str(a.frozen),'--preparation-receipt',str(a.preparation_receipt),'--output',str(paths['endpoint'])]
    sources={str(a.frozen):sha(a.frozen),str(a.preparation_receipt):sha(a.preparation_receipt),Path(__file__).name:sha(Path(__file__).name),'fixed_owner_residual_rank.py':sha('fixed_owner_residual_rank.py'),'exact_colored_matroid_push_relabel_draft.py':sha('exact_colored_matroid_push_relabel_draft.py')}
    write(paths['frozen'],dict(status='FROZEN_SINGLE_BOUNDED_FIXED_OWNER_QUERY',source_hashes=sources,
           command=command,executable=str(Path(sys.executable).resolve()),executable_sha256=sha(Path(sys.executable).resolve()),
           priority=os.getpriority(os.PRIO_PROCESS,0),threads=1,external_seconds=a.external_seconds,
           solver_caps=f['solver_caps'],automatic_retries=0))
    started=time.monotonic()
    with (ROOT/paths['log']).open('x') as log:
        child=subprocess.Popen(command,cwd=ROOT,env=os.environ.copy(),stdout=log,stderr=subprocess.STDOUT)
        timed_out=False
        try:code=child.wait(timeout=a.external_seconds)
        except subprocess.TimeoutExpired:
            timed_out=True;child.kill();code=child.wait()
    result=dict(status='BOUNDED_FIXED_OWNER_QUERY_PROCESS_FINISHED',returncode=code,external_timeout=timed_out,
                child_pid=child.pid,elapsed_seconds=time.monotonic()-started,priority=19,threads=1,
                run_frozen_sha256=sha(paths['frozen']),log_sha256=sha(paths['log']),endpoint_present=(ROOT/paths['endpoint']).exists(),
                endpoint_acceptance_claimed=False,automatic_retry=False)
    if result['endpoint_present']:
        c=read(paths['endpoint']);result.update(endpoint_sha256=sha(paths['endpoint']),candidate_status=c['endpoint']['status'])
    write(paths['exit'],result);print(result,flush=True)

if __name__=='__main__':main()
