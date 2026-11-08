#!/usr/bin/env python3
"""Frozen 22-pattern capacity-endpoint rank cohort; 600s total, no star scan."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ("OPENBLAS_NUM_THREADS","OMP_NUM_THREADS","MKL_NUM_THREADS","VECLIB_MAXIMUM_THREADS","NUMEXPR_NUM_THREADS","BLIS_NUM_THREADS"):
    os.environ[_k]="1"
from pathlib import Path
from types import SimpleNamespace
import argparse, hashlib, json, os, signal, subprocess, sys, time
from two_basis_physical_push_relabel_closed import prepare, read, write

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
    ap=argparse.ArgumentParser();ap.add_argument('--config',type=Path,required=True);ap.add_argument('--output-prefix',type=Path,required=True)
    a=ap.parse_args();start=time.monotonic();deadline=start+600;c=read(a.config)
    provenance=read(c['provenance_receipt']);assert provenance['status']=='PASS_EXACT_CAPACITY_JOINT_TO_SECTOR_HANDOFF'
    assert provenance['consumer_sha256']==sha(ROOT/'verify_capacity_joint_sector_handoff.py') and provenance['rounding_performed'] is False
    assert provenance['literal_rational_strings_compared']=={'X':11520,'Z':11520}
    assert all(sha(ROOT/p)==h for p,h in provenance['source_hashes'].items())
    consumer=Path(c['consumer']);matched=read(c['matched_receipt']);comparison=read(c['matched_comparison'])
    assert consumer.name=='two_basis_structure_verify_physical_push_closed.py'
    assert matched['status'] in ['PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE','PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION']
    assert matched['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_push_early.py') and matched['certificate_sha256']==sha(c['matched_certificate'])
    assert comparison['status']=='PASS_IDENTICAL_COLD_INPUT_AND_INITIAL_BASIS' and comparison['new_independent_receipt_sha256']==sha(c['matched_receipt'])
    sources=dict(provenance['source_hashes']);sources[c['provenance_receipt']]=sha(c['provenance_receipt']);cohort=[];prepared={}
    for side in ['X','Z']:
        s=c['sectors'][side]
        args=SimpleNamespace(allocation=Path(s['allocation']),receipt=Path(s['receipt']),point=Path(c['point']),
            tiny_receipt=Path(c['tiny_receipt']),mask=0,seconds=60,maximum_bases=5000)
        f=prepare(args);assert f['side']==side;prepared[side]=f;sources.update(f['source_hashes'])
        patterns=[d['mask'] for d in f['prepared_positive_patterns']]
        assert patterns==[0,1,2,3,4,5,6,8,9,10,12];cohort.extend((side,m) for m in patterns)
    assert [(d['mask'],d['lambda_mass']) for d in prepared['X']['prepared_positive_patterns']]==[(d['mask'],d['lambda_mass']) for d in prepared['Z']['prepared_positive_patterns']]
    for p in [a.config,consumer,Path(c['matched_certificate']),Path(c['matched_receipt']),Path(c['matched_comparison']),Path(__file__)]:
        p=p.resolve();assert p.is_relative_to(ROOT);sources[str(p.relative_to(ROOT))]=sha(p)
    frozen=dict(status='FROZEN_CAPACITY_ENDPOINT_TWO_SECTOR_RANK_COHORT',source_hashes=sources,
        config_sha256=sha(a.config),point_sha256=sha(c['point']),cohort=cohort,
        solver_seconds_per_pattern=60,external_seconds_per_pattern=90,external_total_seconds=600,
        maximum_active_zero_bases=5000,source_C16_answered=False)
    fp=Path(str(a.output_prefix)+'.frozen.json');write(fp,frozen)
    journal=Path(str(a.output_prefix)+'.progress.jsonl');assert not journal.exists()
    env=dict(os.environ,OPENBLAS_NUM_THREADS='1',OMP_NUM_THREADS='1',MKL_NUM_THREADS='1',VECLIB_MAXIMUM_THREADS='1',PYTHONDONTWRITEBYTECODE='1')
    outcomes=[];stop=None
    for side,m in cohort:
        if deadline-time.monotonic()<120:stop='INSUFFICIENT_TOTAL_BUDGET_FOR_NEXT_PATTERN';break
        assert all(sha(ROOT/p)==h for p,h in sources.items());s=c['sectors'][side]
        prefix=Path(str(a.output_prefix)+f'-{side}-m{m:02d}')
        command=[sys.executable,'-B','two_basis_physical_push_relabel_closed.py',
            '--allocation',s['allocation'],'--receipt',s['receipt'],'--point',c['point'],
            '--tiny-receipt',c['tiny_receipt'],'--mask',str(m),'--seconds','60','--maximum-bases','5000','--output-prefix',str(prefix)]
        log=Path(str(prefix)+'.supervisor.log');assert not log.exists();code,elapsed=bounded(command,log,90,env)
        record=dict(side=side,mask=m,runner_returncode=code,runner_seconds=elapsed,supervisor_log_sha256=sha(log))
        bank=Path(str(prefix)+'.json.gz');receipt=Path(str(prefix)+'-independent.json')
        if code!=0 or not bank.exists():stop='RUNNER_OR_ENDPOINT_FAILURE'
        else:
            endpoint=read(bank);record.update(certificate=str(bank),certificate_sha256=sha(bank),solver_status=endpoint['solver_endpoint']['status'])
            replay=[sys.executable,'-B',str(consumer),'--certificate',str(bank),'--point',c['point'],'--output',str(receipt)]
            replaylog=Path(str(prefix)+'.replay.log');ccode,celapsed=bounded(replay,replaylog,min(30,max(.1,deadline-time.monotonic())),env)
            record.update(consumer_returncode=ccode,consumer_seconds=celapsed,replay_log_sha256=sha(replaylog))
            if ccode!=0 or not receipt.exists():stop='INDEPENDENT_ENDPOINT_REPLAY_FAILURE'
            else:
                r=read(receipt);assert r['certificate_sha256']==sha(bank) and r['consumer_sha256']==sha(consumer)
                assert r['allocation_sha256']==sha(s['allocation']) and r['point_sha256']==sha(c['point']) and r['side']==side and r['selected_mask']==m
                record.update(receipt=str(receipt),receipt_sha256=sha(receipt),independent_status=r['status'])
        outcomes.append(record)
        with journal.open('a') as stream:stream.write(json.dumps(record)+'\n')
        print(json.dumps(record),flush=True)
        if stop:break
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    done={(r['side'],r['mask']) for r in outcomes}
    out=dict(status='ALL_COHORT_ENDPOINTS_INDEPENDENTLY_REPLAYED' if len(outcomes)==22 and not stop else 'BOUNDED_TWO_SECTOR_GATE_STOPPED',
        frozen_sha256=sha(fp),outcomes=outcomes,stop_reason=stop,unqueried_patterns=[list(q) for q in cohort if q not in done],
        elapsed_seconds=time.monotonic()-start,source_C16_answered=False,two_sector_membership_proved=False,
        scope='Literal local mixtures, local rank cuts or bounded states, at one fixed allocation. A local rank obstruction does not exclude all allocations or the global moment point.')
    write(Path(str(a.output_prefix)+'.json'),out);print(json.dumps(out),flush=True)
if __name__=='__main__':main()

