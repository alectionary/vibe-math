"""Fixed one-million-pair replication; leaves original artifacts unchanged."""
from collections import Counter
from pathlib import Path
import hashlib
import json
import math
import random
import subprocess
import tempfile
import time
import benchmark_decoding as b

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
N, SEED, P, BATCH = 1000000, 20261025, .04, 20000
NAMES = ['previous_best', 'minimum_4']


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run():
    prior_path = HERE/'distance-matched-selection.json'
    prior = json.loads(prior_path.read_text())
    for relative, digest in prior['sha256'].items():
        assert sha(ROOT/relative) == digest, relative
    paths = [Path(__file__), HERE/'benchmark_decoding.py', HERE/'minsum.cpp',
             prior_path, HERE/'distance-matched-results.json',
             HERE.parent/'MILLION-PAIRED-PROTOCOL.md']
    frozen = dict(status='settings_frozen_before_followup_outcomes',
                  codes=prior['codes'], trials=N, seed=SEED, probability=P,
                  batch_size=BATCH, max_iterations=100, alpha=.8,
                  primary_contrast='minimum_4 minus previous_best',
                  sha256={str(p.relative_to(ROOT)): sha(p) for p in paths})
    selection_path = HERE/'million-paired-selection.json'
    selection_path.write_text(json.dumps(frozen, indent=2)+'\n')
    selection_sha = sha(selection_path)
    selected = {}
    for name in NAMES:
        meta = frozen['codes'][name]
        assert (meta['d_x'], meta['d_z'], meta['n'], meta['k']) == (10,10,252,10)
        hx, hz, checked = b.construction(meta['B'], meta['r'])
        assert all(meta[k] == v for k,v in checked.items())
        selected[name] = hx, hz, checked
    rng = random.Random(SEED)
    stream = hashlib.sha256()
    flags = {name: bytearray() for name in NAMES}
    synflags = {name: bytearray() for name in NAMES}
    counts = {name: Counter() for name in NAMES}
    batches, replays = [], []
    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix='cyclic-million-') as temp:
        binary = Path(temp)/'minsum'
        subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
        checks = b.validate(binary, selected)
        # Prove batching does not change frame outcomes, using separate noise.
        test_rng = random.Random(719371)
        test = [(P,b.bit_string(test_rng.getrandbits(252),252)) for _ in range(12)]
        for name,(hx,hz,_) in selected.items():
            whole = b.engine(binary,hx,252,test)
            split = b.engine(binary,hx,252,test[:5])+b.engine(binary,hx,252,test[5:])
            assert whole == split
        for offset in range(0,N,BATCH):
            size = min(BATCH,N-offset)
            trials = [(P,''.join('1' if rng.random()<P else '0' for _ in range(252)))
                      for _ in range(size)]
            payload = '\n'.join(e for _,e in trials).encode()
            if offset:
                stream.update(b'\n')
            stream.update(payload)
            batch = dict(offset=offset, trials=size, error_sha256=hashlib.sha256(payload).hexdigest(), arms={})
            for name,(hx,hz,_) in selected.items():
                xp, zp = list(map(b.rowmask,hx)), b.basis(hz)
                outcomes = b.engine(binary,hx,252,trials)
                local = Counter()
                for j,((_,e),(it,matched,estimate)) in enumerate(zip(trials,outcomes)):
                    residual = b.string_mask(e)^b.string_mask(estimate)
                    assert matched == (not any(b.syndrome(xp,residual)))
                    ok = b.in_span(residual,zp)
                    assert not ok or matched
                    local['exact_recovery'] += residual == 0
                    local['stabilizer_equivalent_success'] += ok and residual != 0
                    local['syndrome_failure'] += not matched
                    local['matched_logical_failure'] += matched and not ok
                    local['iteration_sum'] += it
                    local['matched_iteration_sum'] += it if matched else 0
                    flags[name].append(not ok)
                    synflags[name].append(not matched)
                    # Replay actual fresh outcomes at both sides of batch boundaries.
                    if offset in (0, BATCH, N-BATCH) and j in (0, size-1):
                        expected = b.reference_decode(hx,252,e,P,100,.8)
                        assert (it,matched,estimate) == expected
                        replays.append(dict(design=name,index=offset+j,error=e,
                                            iterations=it,matched=matched,estimate=estimate))
                counts[name].update(local)
                batch['arms'][name] = dict(local)
            batches.append(batch)
            print(f'{offset+size}/{N} pairs; failures '+
                  ', '.join(f'{name}={sum(flags[name])}' for name in NAMES)+
                  f'; elapsed {time.monotonic()-started:.1f}s',flush=True)
    results = []
    for name in NAMES:
        c = counts[name]
        assert sum(c[k] for k in ('exact_recovery','stabilizer_equivalent_success',
                                 'syndrome_failure','matched_logical_failure')) == N
        fail = sum(flags[name])
        results.append(dict(design=name,p=P,trials=N,failure_count=fail,failure_rate=fail/N,
                            wilson_95_interval=b.wilson(fail,N),**c,
                            mean_iterations=c['iteration_sum']/N,
                            mean_iterations_given_syndrome_match=c['matched_iteration_sum']/(N-c['syndrome_failure']),
                            error_stream_sha256=stream.hexdigest(),
                            failure_flags_zlib_base64=b.pack(flags[name]),
                            syndrome_failure_flags_zlib_base64=b.pack(synflags[name])))
    a,c = (flags[name] for name in NAMES)
    better = sum(x and not y for x,y in zip(a,c))
    worse = sum(y and not x for x,y in zip(a,c))
    delta = (worse-better)/N
    se = math.sqrt((better+worse-N*delta*delta)/(N*(N-1)))
    z = 1.959963984540054
    contrast = dict(design='minimum_4',reference_design='previous_best',p=P,trials=N,
                    reference_failed_design_succeeded=better,
                    reference_succeeded_design_failed=worse,
                    failure_rate_difference=delta,standard_error=se,
                    paired_normal_95_interval=[delta-z*se,delta+z*se])
    for relative,digest in frozen['sha256'].items():
        assert sha(ROOT/relative) == digest
    assert sha(selection_path) == selection_sha
    out = dict(status='fixed_one_million_pair_independent_replication',
               selection_sha256=selection_sha,seed=SEED,probability=P,
               independent_noise_patterns=N,decoder_executions=2*N,
               scope='One Pauli sector, perfect syndrome, fixed decoder, both exact [[252,10,10]].',
               decoder_checks=checks,batch_invariance_checks=24,
               actual_stream_reference_checks=replays,results=results,
               paired_comparison=contrast,batches=batches,
               elapsed_seconds=time.monotonic()-started)
    (HERE/'million-paired-results.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(contrast,indent=2),flush=True)


if __name__ == '__main__':
    run()
