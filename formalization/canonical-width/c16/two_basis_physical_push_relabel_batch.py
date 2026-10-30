#!/usr/bin/env python3
"""One frozen sequential ten-pattern gate; replay every endpoint before next."""
from pathlib import Path
import argparse, hashlib, json, os, signal, subprocess, sys, time
from two_basis_physical_push_relabel_v2 import prepare, read, write

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def bounded(command,log,seconds,env):
    start=time.monotonic()
    with log.open('w') as stream:
        process=subprocess.Popen(command,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,start_new_session=True)
        try:code=process.wait(timeout=seconds)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid,signal.SIGKILL);process.wait();code='EXTERNAL_TIME_LIMIT'
    return code,time.monotonic()-start
def main():
    ap=argparse.ArgumentParser()
    for name in ['allocation','receipt','point','tiny-receipt','mask0-receipt','consumer','output-prefix']:
        ap.add_argument('--'+name,type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();deadline=start+900
    a.mask=0;a.seconds=60;a.maximum_bases=5000
    reference=prepare(a);r0=read(a.mask0_receipt)
    assert r0['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE' and r0['selected_mask']==0
    assert r0['allocation_sha256']==sha(a.allocation) and r0['point_sha256']==sha(a.point)
    assert r0['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_push.py')
    patterns=[d['mask'] for d in reference['prepared_positive_patterns'] if d['mask']]
    assert patterns==[1,2,3,4,5,6,8,9,10,12] and a.consumer.is_file()
    sources=dict(reference['source_hashes'])
    for p in [a.consumer,a.mask0_receipt,Path(__file__)]:
        p=p.resolve();assert p.is_relative_to(ROOT);sources[str(p.relative_to(ROOT))]=sha(p)
    frozen=dict(status='FROZEN_SEQUENTIAL_PHYSICAL_PATTERN_GATE',source_hashes=sources,
        allocation_sha256=sha(a.allocation),allocation_receipt_sha256=sha(a.receipt),point_sha256=sha(a.point),
        accepted_mask0_receipt_sha256=sha(a.mask0_receipt),patterns=patterns,
        solver_seconds_per_pattern=60,external_seconds_per_pattern=90,external_total_seconds=900,
        maximum_active_zero_bases=5000,consumer=str(a.consumer),source_C16_answered=False)
    fp=Path(str(a.output_prefix)+'.frozen.json');write(fp,frozen)
    journal=Path(str(a.output_prefix)+'.progress.jsonl');assert not journal.exists()
    env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
    outcomes=[];stop=None
    for m in patterns:
        if deadline-time.monotonic()<90:stop='INSUFFICIENT_TOTAL_BUDGET_FOR_NEXT_PATTERN';break
        assert all(sha(ROOT/p)==h for p,h in sources.items())
        prefix=Path(str(a.output_prefix)+f'-m{m:02d}')
        command=[sys.executable,'-B','two_basis_physical_push_relabel_v2.py',
            '--allocation',str(a.allocation),'--receipt',str(a.receipt),'--point',str(a.point),
            '--tiny-receipt',str(a.tiny_receipt),'--mask',str(m),'--seconds','60','--maximum-bases','5000','--output-prefix',str(prefix)]
        log=Path(str(prefix)+'.supervisor.log');assert not log.exists()
        code,elapsed=bounded(command,log,90,env)
        record=dict(mask=m,runner_returncode=code,runner_seconds=elapsed,supervisor_log_sha256=sha(log))
        bank=Path(str(prefix)+'.json.gz');receipt=Path(str(prefix)+'-independent.json')
        if code!=0 or not bank.exists():stop='RUNNER_OR_ENDPOINT_FAILURE'
        else:
            endpoint=read(bank);record.update(certificate=str(bank),certificate_sha256=sha(bank),solver_status=endpoint['solver_endpoint']['status'])
            replay=[sys.executable,'-B',str(a.consumer),'--certificate',str(bank),'--point',str(a.point),'--output',str(receipt)]
            replaylog=Path(str(prefix)+'.replay.log')
            ccode,celapsed=bounded(replay,replaylog,min(30,max(.1,deadline-time.monotonic())),env)
            record.update(consumer_returncode=ccode,consumer_seconds=celapsed,replay_log_sha256=sha(replaylog))
            if ccode!=0 or not receipt.exists():stop='INDEPENDENT_ENDPOINT_REPLAY_FAILURE'
            else:
                replayed=read(receipt)
                assert replayed['certificate_sha256']==sha(bank) and replayed['consumer_sha256']==sha(a.consumer)
                assert replayed['allocation_sha256']==sha(a.allocation) and replayed['point_sha256']==sha(a.point)
                record.update(receipt=str(receipt),receipt_sha256=sha(receipt),independent_status=replayed['status'])
        outcomes.append(record)
        with journal.open('a') as stream:stream.write(json.dumps(record)+'\n')
        print(json.dumps(record),flush=True)
        if stop:break
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    out=dict(status='ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED' if len(outcomes)==10 and not stop else 'BOUNDED_PHYSICAL_PATTERN_GATE_STOPPED',
        frozen_sha256=sha(fp),outcomes=outcomes,stop_reason=stop,
        unqueried_patterns=[m for m in patterns if m not in {r['mask'] for r in outcomes}],
        elapsed_seconds=time.monotonic()-start,source_C16_answered=False,
        all_Z_pattern_membership_candidate=len(outcomes)==10 and all(r.get('independent_status')=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE' for r in outcomes),
        aggregate_membership_requires_independent_replay=True,two_sector_membership_proved=False)
    write(Path(str(a.output_prefix)+'.json'),out);print(json.dumps(out),flush=True)
if __name__=='__main__':main()
