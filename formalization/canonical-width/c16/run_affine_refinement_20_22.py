#!/usr/bin/env python3
"""At most two successors from point20 using the frozen275-template heuristic."""
from pathlib import Path
import datetime, hashlib, json, os, subprocess, sys

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def call(cmd, log, timeout):
    with Path(log).open('w') as f:
        subprocess.run(cmd,cwd=ROOT,stdout=f,stderr=subprocess.STDOUT,timeout=timeout,check=True)


def main():
    os.chdir(ROOT)
    for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:
        os.environ[k] = '1'
    prefix = 'two-basis-results/affine-refinement-20-22'
    frozen_path = Path(prefix+'-frozen.json')
    assert not frozen_path.exists()
    sources = [Path(__file__),'scout_affine_integer_templates.py','run_integer_coupling_trial.py',
               'check_integer_coupling_trial.py','two-basis-results/affine-integer-template-coverage.json',
               'coupling-results/two-basis-integer-witness20-frozen.json']
    frozen_path.write_text(json.dumps(dict(status='FROZEN_TWO_SUCCESSOR_AFFINE_REFRESH',
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_C16_answered=False,
        initial_point=20,maximum_successors=[21,22],source_hashes={str(p):sha(p) for p in sources},
        stop='First exact recovery failure, empty bounded scout, numerical trial failure or two successors.'),indent=2)+'\n')
    records = []
    stop = 'TWO_SUCCESSOR_LIMIT'
    for number in [20,21,22]:
        name = f'two-basis-integer-witness{number}'
        summary_path = Path(f'coupling-results/{name}-checks-summary.json')
        if not summary_path.exists():
            call([sys.executable,'-u','check_integer_coupling_trial.py','--name',name,'--direct-triples'],
                 prefix+f'-check{number}.log',600)
        summary = json.loads(summary_path.read_text())
        records.append(dict(point=number,checks=summary['status'],summary_sha256=sha(summary_path)))
        if summary['status'] != 'PASS_LISTED_RELAXATION':
            stop = 'EXACT_RECOVERY_FAILED'
            break
        print('EXACT_POINT_ACCEPTED',number,flush=True)
        if number == 22:
            break
        point = f'coupling-results/{name}-rational.json.gz'
        scout = f'two-basis-results/affine-template-point{number}'
        call([sys.executable,'-u','scout_affine_integer_templates.py','--point',point,'--prefix',scout,
              '--binary','/private/tmp/c16-higher-integer-forms','--restarts','100','--seconds','180',
              '--maximum-rows','1000'],scout+'.log',210)
        outcome = json.loads(Path(scout+'-summary.json').read_text())
        records[-1]['scout_rows'] = outcome['accepted_rows']
        print('SCOUT_ROWS',number,outcome['accepted_rows'],flush=True)
        if not outcome['accepted_rows']:
            stop = 'EMPTY_BOUNDED_SCOUT'
            break
        call([sys.executable,'review_higher_integer_form_rows.py','--bank',scout+'-bank.json',
              '--receipt',scout+'-independent.json','--point',point,'--output',scout+'-symbolic.json'],
              scout+'-symbolic.log',120)
        old = json.loads(Path(f'coupling-results/{name}-frozen.json').read_text())['command']
        flags = list(dict.fromkeys(t for t in old[3:] if t.startswith('--')))
        def vals(k):
            i = max(i for i,v in enumerate(old) if v == k)+1
            j = i
            while j < len(old) and not old[j].startswith('--'):
                j += 1
            return old[i:j]
        nextname = f'two-basis-integer-witness{number+1}'
        replacement = {'--basis-cuts':vals('--basis-cuts')+[scout+'-bank.json'],
            '--basis-replays':vals('--basis-replays')+[scout+'-independent.json'],
            '--warm-point':[f'coupling-results/{name}.npz'],
            '--output':[f'coupling-results/{nextname}.json'],'--seconds':['180']}
        extra = [v for k in flags for v in [k,*replacement.get(k,vals(k))]]
        cmd = [sys.executable,'-u','run_integer_coupling_trial.py','--name',nextname,
               '--seconds','180','--outer-seconds','300','--witness-margin','0','--extra',*extra]
        derived = Path(f'two-basis-results/integer-witness{number+1}-derived-command.json')
        assert not derived.exists()
        derived.write_text(json.dumps(dict(status='DERIVED_FROM_PRECEDING_ACCEPTED_COMMAND',
            command=cmd,source_C16_answered=False),indent=2)+'\n')
        call(cmd,prefix+f'-solve{number+1}.log',330)
        result = json.loads(Path(f'coupling-results/{nextname}.json').read_text())
        if result.get('max_constraint_violation',1) > 1e-7:
            stop = 'NUMERICAL_ENDPOINT_NOT_CREDIBLE'
            break
    Path(prefix+'-summary.json').write_text(json.dumps(dict(status='BOUNDED_REFINEMENT_FINISHED',
        source_C16_answered=False,stop_reason=stop,records=records,
        frozen_sha256=sha(frozen_path)),indent=2)+'\n')
    print(stop,flush=True)


if __name__ == '__main__':
    main()
