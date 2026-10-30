#!/usr/bin/env python3
"""One bounded cohort at an exact pinned-general joint allocation.

No target rounding, adaptive allocation repair, or LP solve occurs here.
All scientific operations use frozen producers and independent consumers.
"""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19, 'Research process must be nice19'
for _name in ['OPENBLAS_NUM_THREADS', 'OMP_NUM_THREADS', 'MKL_NUM_THREADS',
              'VECLIB_MAXIMUM_THREADS', 'NUMEXPR_NUM_THREADS', 'BLIS_NUM_THREADS']:
    os.environ[_name] = '1'
os.environ['PYTHONDONTWRITEBYTECODE'] = '1'

import argparse
import gzip
import hashlib
import json
from pathlib import Path
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def read(path):
    path = Path(path)
    return json.loads(gzip.decompress(path.read_bytes()) if path.suffix == '.gz'
                      else path.read_text())
def write(path, data):
    assert not path.exists(), path
    path.write_text(json.dumps(data, indent=2)+'\n')

def bounded(name, command, cap, prefix):
    log = Path(str(prefix)+'-'+name+'.log')
    assert not log.exists()
    started = time.monotonic()
    with log.open('w') as stream:
        process = subprocess.Popen(command, cwd=ROOT, env=os.environ.copy(),
                                   stdout=stream, stderr=subprocess.STDOUT,
                                   start_new_session=True)
        assert os.getpriority(os.PRIO_PROCESS, process.pid) == 19
        print(name, 'PID', process.pid, 'nice19', flush=True)
        try:
            code = process.wait(timeout=cap)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()
            code = 'EXTERNAL_TIME_LIMIT'
    record = dict(name=name, command=command, returncode=code,
                  external_cap_seconds=cap, elapsed_seconds=time.monotonic()-started,
                  log=str(log), log_sha256=sha(log), nice=19)
    write(Path(str(prefix)+'-'+name+'-exit.json'), record)
    return record

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=Path, required=True)
    parser.add_argument('--provenance-receipt', type=Path, required=True)
    parser.add_argument('--prefix', type=Path, required=True)
    args = parser.parse_args()
    started = time.monotonic()
    config, provenance = read(args.config), read(args.provenance_receipt)
    assert provenance['status'] == 'PASS_EXACT_GENERAL_JOINT_TO_SECTOR_HANDOFF'
    assert provenance['consumer_sha256'] == sha('verify_general_joint_sector_handoff.py')
    assert provenance['rounding_performed'] is False
    assert provenance['literal_rational_strings_compared'] == {'X': 11520, 'Z': 11520}
    assert all(sha(path) == value for path, value in provenance['source_hashes'].items())
    paths = [args.config, args.provenance_receipt, Path(__file__),
             Path('conditional_owner_star_v2.py'), Path('verify_conditional_owner_star_v2.py'),
             Path('two_basis_physical_closed_batch.py'),
             Path('two_basis_physical_push_relabel_closed.py'),
             Path('two_basis_structure_verify_physical_push_closed.py')]
    for side in ['X', 'Z']:
        entry = config['sectors'][side]
        paths.extend(Path(entry[k]) for k in ['allocation', 'receipt'])
        checked = read(entry['receipt'])
        assert checked['status'] == 'PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS'
        assert checked['certificate_sha256'] == sha(entry['allocation'])
        assert checked['point_sha256'] == sha(config['point'])
    sources = {**provenance['source_hashes'], **{str(path): sha(path) for path in paths}}
    frozen = dict(status='FROZEN_EXACT_GENERAL_JOINT_SEPARATION_COHORT', source_hashes=sources,
                  point_sha256=sha(config['point']), star_internal_seconds=300,
                  rank_internal_seconds_per_pattern=60, rank_external_total_seconds=1500,
                  exact_values_preserved=True, no_automatic_repair=True, nice=19,
                  scope='Fixed exact allocation only; neither source nor target membership follows.')
    frozen_path = Path(str(args.prefix)+'.frozen.json')
    write(frozen_path, frozen)
    star = Path(str(args.prefix)+'-stars.json.gz')
    star_receipt = Path(str(args.prefix)+'-stars-independent.json')
    rank_prefix = Path(str(args.prefix)+'-ranks')
    command = [sys.executable, '-B', 'conditional_owner_star_v2.py', '--point', config['point']]
    for side in ['X', 'Z']:
        for key in ['allocation', 'receipt']:
            command += ['--'+side+'-'+key, config['sectors'][side][key]]
    command += ['--seconds', '300', '--output', str(star)]
    records = [bounded('stars', command, 330, args.prefix)]
    stop = None
    if records[-1]['returncode'] != 0 or not star.exists():
        stop = 'STAR_PRODUCER_FAILURE_OR_EXTERNAL_CAP'
    else:
        records.append(bounded('star-replay', [sys.executable, '-B',
            'verify_conditional_owner_star_v2.py', '--bank', str(star),
            '--output', str(star_receipt)], 180, args.prefix))
        if records[-1]['returncode'] != 0 or not star_receipt.exists():
            stop = 'STAR_INDEPENDENT_REPLAY_FAILURE'
        else:
            result = read(star_receipt)
            assert result['status'] == 'PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
            assert result['bank_sha256'] == sha(star)
    if stop is None:
        assert all(sha(path) == value for path, value in sources.items())
        records.append(bounded('ranks', [sys.executable, '-B',
            'two_basis_physical_closed_batch.py', '--config', str(args.config),
            '--output-prefix', str(rank_prefix)], 1530, args.prefix))
        if records[-1]['returncode'] != 0:
            stop = 'RANK_BATCH_FAILURE_OR_EXTERNAL_CAP'
    assert all(sha(path) == value for path, value in sources.items())
    output = dict(status='BOUNDED_EXACT_JOINT_SEPARATION_COHORT_FINISHED' if stop is None
                  else 'BOUNDED_EXACT_JOINT_SEPARATION_COHORT_STOPPED',
                  frozen_sha256=sha(frozen_path), jobs=records, stop_reason=stop,
                  elapsed_seconds=time.monotonic()-started, nice=19,
                  star_bank=str(star), star_receipt=str(star_receipt),
                  rank_batch=str(rank_prefix)+'.json', source_C16_answered=False,
                  fixed_allocation_only=True, no_automatic_repair=True)
    write(Path(str(args.prefix)+'.json'), output)
    print(json.dumps(output), flush=True)

if __name__ == '__main__': main()

