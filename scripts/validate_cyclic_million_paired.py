"""Reconstruct fresh streams, paired flags and all million-run summaries."""
from pathlib import Path
import base64
import hashlib
import json
import math
import random
import sys
import zlib
sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
S = R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def unpack(encoded,n):
    raw = zlib.decompress(base64.b64decode(encoded))
    assert len(raw) == (n+7)//8
    return bytearray(bool(raw[i//8] & (1 << (i%8))) for i in range(n))


s = json.loads((S/'million-paired-selection.json').read_text())
d = json.loads((S/'million-paired-results.json').read_text())
assert d['selection_sha256'] == sha(S/'million-paired-selection.json')
for rel,digest in s['sha256'].items():
    assert sha(R/rel) == digest, rel
old = json.loads((S/'distance-matched-selection.json').read_text())
for rel,digest in old['sha256'].items():
    assert sha(R/rel) == digest, rel
assert s['codes'] == old['codes']
assert s['seed'] == d['seed'] == 20261025
assert s['seed'] not in [old['seed']+1000003*i for i in range(3)]
assert s['probability'] == d['probability'] == .04
assert s['alpha'] == .8 and s['max_iterations'] == 100
n = s['trials']
assert n == d['independent_noise_patterns'] == 1000000
assert d['decoder_executions'] == 2*n
assert d['decoder_checks']['total_decoder_checks'] == 638
assert d['batch_invariance_checks'] == 24
assert len(d['actual_stream_reference_checks']) == 12
saved_errors = {r['index']:r['error'] for r in d['actual_stream_reference_checks']}
rng = random.Random(s['seed'])
stream = hashlib.sha256()
for batch in d['batches']:
    start,size = batch['offset'],batch['trials']
    assert start % s['batch_size'] == 0 and size == min(s['batch_size'],n-start)
    errors = [''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for _ in range(size)]
    for index,error in saved_errors.items():
        if start <= index < start+size:
            assert errors[index-start] == error
    payload = '\n'.join(errors).encode()
    assert hashlib.sha256(payload).hexdigest() == batch['error_sha256']
    if start:
        stream.update(b'\n')
    stream.update(payload)
assert [x['offset'] for x in d['batches']] == list(range(0,n,s['batch_size']))
outcomes = {}
for row in d['results']:
    name = row['design']
    assert name in s['codes'] and row['p'] == .04 and row['trials'] == n
    assert row['error_stream_sha256'] == stream.hexdigest()
    fail = unpack(row['failure_flags_zlib_base64'],n)
    syn = unpack(row['syndrome_failure_flags_zlib_base64'],n)
    assert sum(fail) == row['failure_count'] == row['syndrome_failure']+row['matched_logical_failure']
    assert sum(syn) == row['syndrome_failure'] and all(not a or z for a,z in zip(syn,fail))
    assert row['exact_recovery']+row['stabilizer_equivalent_success']+row['failure_count'] == n
    assert row['failure_rate'] == sum(fail)/n
    assert row['wilson_95_interval'] == b.wilson(sum(fail),n)
    assert row['mean_iterations'] == row['iteration_sum']/n
    assert row['mean_iterations_given_syndrome_match'] == row['matched_iteration_sum']/(n-sum(syn))
    for key in ('exact_recovery','stabilizer_equivalent_success','syndrome_failure',
                'matched_logical_failure','iteration_sum','matched_iteration_sum'):
        assert sum(batch['arms'][name][key] for batch in d['batches']) == row[key]
    for batch in d['batches']:
        start,end = batch['offset'],batch['offset']+batch['trials']
        c = batch['arms'][name]
        assert sum(fail[start:end]) == c['syndrome_failure']+c['matched_logical_failure']
        assert sum(syn[start:end]) == c['syndrome_failure']
    hx,hz,geometry = b.construction(s['codes'][name]['B'],s['codes'][name]['r'])
    assert all(s['codes'][name][k] == v for k,v in geometry.items())
    zp = b.basis(hz)
    for replay in d['actual_stream_reference_checks']:
        if replay['design'] != name:
            continue
        actual = (replay['iterations'],replay['matched'],replay['estimate'])
        assert actual == b.reference_decode(hx,252,replay['error'],.04,100,.8)
        residual = b.string_mask(replay['error'])^b.string_mask(replay['estimate'])
        assert bool(fail[replay['index']]) == (not b.in_span(residual,zp))
        assert bool(syn[replay['index']]) == (not replay['matched'])
    outcomes[name] = fail
a,z = outcomes['previous_best'],outcomes['minimum_4']
better = sum(x and not y for x,y in zip(a,z))
worse = sum(y and not x for x,y in zip(a,z))
delta = (worse-better)/n
se = math.sqrt((better+worse-n*delta**2)/(n*(n-1)))
c = d['paired_comparison']
assert c['reference_failed_design_succeeded'] == better
assert c['reference_succeeded_design_failed'] == worse
assert c['failure_rate_difference'] == delta and c['standard_error'] == se
assert c['paired_normal_95_interval'] == [delta-1.959963984540054*se,delta+1.959963984540054*se]
print('PASS: 1000000 regenerated fresh shared errors; both exact [[252,10,10]] codes; all batch/stream hashes, failure bitmaps, totals, intervals, and 12 reference replays; frozen original experiment unchanged.')
