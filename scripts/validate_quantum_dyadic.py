"""Audit literal P11 CSS pairs, exact quotient distance and quantum outcomes."""
from collections import Counter
from itertools import combinations
from pathlib import Path
import base64
import hashlib
import json
import subprocess
import sys
import tempfile
import zlib

sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
P = R/'formalization/dyadic-performance'
sys.path.insert(0, str(P/'search'))
import pilot as p
import quantum_css as q
import quantum_benchmark as b


def low_basis(rows):
    out = {}
    for row in rows:
        while row:
            pivot = row & -row
            if pivot in out:
                row ^= out[pivot]
            else:
                out[pivot] = row
                break
    return out


def low_member(word, basis):
    while word:
        pivot = word & -word
        if pivot not in basis:
            return False
        word ^= basis[pivot]
    return True


def brute_spectrum(vn, stabilizer_rows):
    columns = [sum(1 << c for c in cs) for cs in vn]
    stabilizers = low_basis(stabilizer_rows)
    counts = {str(w): {'stabilizer': 0, 'logical': 0} for w in range(1, 5)}
    for w in range(1, 5):
        for support in combinations(range(len(vn)), w):
            syndrome = 0
            for v in support:
                syndrome ^= columns[v]
            if not syndrome:
                word = sum(1 << v for v in support)
                counts[str(w)]['stabilizer' if low_member(word, stabilizers) else 'logical'] += 1
    return counts


def unpack(value):
    raw = zlib.decompress(base64.b64decode(value))
    assert len(raw) == 625
    return [int(bit) for bit in ''.join(f'{byte:08b}' for byte in raw)]


s = json.loads((P/'search/quantum-selection.json').read_text())
d = json.loads((P/'search/quantum-results.json').read_text())
assert s['status'] == 'literal_css_selections_frozen_before_quantum_decoding'
assert d['status'] == 'literal_P11_CSS_two_sector_stabilizer_quotient_experiment'
assert d['selection_sha256'] == hashlib.sha256((P/'search/quantum-selection.json').read_bytes()).hexdigest()
for name, sha in s['sha256'].items():
    assert hashlib.sha256((R/name).read_bytes()).hexdigest() == sha, name
assert len(s['families']) == len(d['families']) == 2
unique_selections, all_candidates = 0, 0
with tempfile.TemporaryDirectory(prefix='quantum-css-audit-') as temp:
    binary = Path(temp)/'metrics'
    subprocess.run(['c++', '-std=c++17', '-O2', str(P/'search/graph_metrics.cpp'), '-o', str(binary)], check=True)
    assert b.graph_counter_checks(binary) == 2
    for fi, (family, outcomes) in enumerate(zip(s['families'], d['families'])):
        config = family['configuration']
        assert config == b.FAMILIES[fi] and outcomes['configuration'] == config
        assert len(family['calibration']) == 24 and len(family['pools']) == 16
        assert family['attempted'] == 408+sum(family['rejected'].values())
        scale = b.scaling(family['calibration'])
        assert scale['mean_log1p'] == family['scaling']['mean_log1p']
        assert scale['std_log1p'] == family['scaling']['std_log1p']
        for j, std in enumerate(scale['std_log1p']):
            values = {b.feature_values(c)[j] for c in family['calibration']}
            assert (std == 0) == (len(values) == 1), 'constant feature regression'
        parameters_seen = set()
        codes = family['calibration']+[c for pool in family['pools'] for c in pool['candidates']]
        for code_index, code in enumerate(codes):
            parameters = code['parameters']
            key = json.dumps(parameters, sort_keys=True)
            assert key not in parameters_seen
            parameters_seen.add(key)
            bx, bz = q.arrays(config['family'], parameters)
            assert (bx, bz) == (code['bx'], code['bz']) and q.block_commutes(bx, bz)
            # Independent direct transcription of the displayed source arrays.
            if config['family'] == '3.11':
                a, c, e, g, i, k = parameters['x']
                expected = [[0,a,0,c,0,e,0,g,0,i,0,k], [k,0,a,0,c,0,e,0,g,0,i,0],
                            [0,k,0,i,0,g,0,e,0,c,0,a], [a,0,k,0,i,0,g,0,e,0,c,0]]
                assert bx == bz == expected
            else:
                x, y, tau = parameters['x'], parameters['y'], parameters['tau']
                for row in range(4):
                    order = []
                    for column in range(4):
                        index = column
                        for _ in range(row):
                            index = tau[index]
                        order.append(index)
                    assert bx[row] == [x[(j+row)%4] for j in range(4)]+[y[(j+row)%4] for j in range(4)]
                    assert bz[row] == [y[j] for j in order]+[x[j] for j in order]
            hx, hz, vx, vz = q.expansion(bx, bz, config['ell'])
            assert p.connected(hx, vx) and p.connected(hz, vz)
            assert all(len(cs) == 4 for cs in vx+vz)
            xm, zm = list(map(p.decoder.rowmask, hx)), list(map(p.decoder.rowmask, hz))
            xb, zb = low_basis(xm), low_basis(zm)
            assert len(xb) == len(zb) == code['rank_x'] == code['rank_z'] == config['rank']
            assert len(vx)-len(xb)-len(zb) == code['k'] == config['k'] > 0
            assert len(vx) == code['n'] == config['n']
            assert code['d_x'] == code['d_z'] == 4
            for graph, vn, rows, stab, logical in ((code['graph_x'], vx, zm, zb, code['logical_z']),
                                                   (code['graph_z'], vz, xm, xb, code['logical_x'])):
                assert logical['distance_if_at_most_four'] == 4
                witness = logical['logical_witness']
                assert len(set(witness)) == 4
                word = sum(1 << v for v in witness)
                assert not low_member(word, stab)
                assert all(sum(c in vn[v] for v in witness) % 2 == 0 for c in range(len(hx)))
                assert all(logical['kernel_supports'][str(w)]['logical'] == 0 for w in (1, 2, 3))
                for w in (2, 3, 4):
                    zero_count = sum(entry['count'] for entry in graph['absorbing_spectrum'] if entry['a'] == w and entry['b'] == 0)
                    assert zero_count == sum(logical['kernel_supports'][str(w)].values())
                assert graph['absorbing_features'] == p.abs_features(graph['absorbing_spectrum'])
                assert graph['cycles'][0] == sum(len(set(vn[a]) & set(vn[c]))*(len(set(vn[a]) & set(vn[c]))-1)//2
                                                for a, c in combinations(range(len(vn)), 2))
                if code_index == 0:
                    assert brute_spectrum(vn, rows) == logical['kernel_supports']
            if code_index == 0:
                px, pz = p.decoder.basis(xm), p.decoder.basis(zm)
                # Products of generators must succeed, including supports not displayed as rows.
                assert b.success(xm[0] ^ xm[1], zm[0] ^ zm[1], px, pz)
                assert not b.success(sum(1 << v for v in code['logical_x']['logical_witness']), 0, px, pz)
                assert not b.success(0, sum(1 << v for v in code['logical_z']['logical_witness']), px, pz)
                assert p.cycle_counts(hx, vx) == code['graph_x']['cycles']
                assert p.absorbing(vx) == code['graph_x']['absorbing_spectrum']
            assert code['cycles_total'] == [a+c for a, c in zip(code['graph_x']['cycles'], code['graph_z']['cycles'])]
            assert code['absorbing_features_total'] == [a+c for a, c in zip(code['graph_x']['absorbing_features'], code['graph_z']['absorbing_features'])]
            for raw_row in xm:
                assert low_member(raw_row, xb)
            for raw_row in zm:
                assert low_member(raw_row, zb)
        for pool, decoded in zip(family['pools'], outcomes['pools']):
            assert len(pool['candidates']) == 24 and pool['id'] == decoded['id']
            assert pool['selected']['baseline'] == 0
            assert pool['selected']['cycle_first'] == min(range(24), key=lambda i: (pool['candidates'][i]['cycles_total'], i))
            for c in pool['candidates']:
                assert c['scores'] == b.scores(c, scale)
            for arm in ('absorbing', 'joint', 'cycle_aggregate'):
                assert pool['selected'][arm] == min(range(24), key=lambda i: (pool['candidates'][i]['scores'][arm], i))
            selected_ids = set(pool['selected'].values())
            unique_selections += len(selected_ids)
            for code_id in selected_ids:
                code = pool['candidates'][code_id]
                hx, hz, vx, vz = q.expansion(code['bx'], code['bz'], config['ell'])
                assert b.graph_metrics(binary, hx, vx) == code['graph_x']
                assert b.graph_metrics(binary, hz, vz) == code['graph_z']
            samples = b.noise_samples(fi, pool['id'])
            for prob, errors in samples.items():
                assert hashlib.sha256(''.join(x+z for x, z in errors).encode()).hexdigest() == decoded['sample_sha256'][str(prob)]
            for conditions in decoded['arms'].values():
                for a in conditions:
                    fail = unpack(a['failure_bitmap_zlib_base64'])
                    exact = unpack(a['exact_failure_bitmap_zlib_base64'])
                    logical = unpack(a['logical_failure_bitmap_zlib_base64'])
                    syndrome = unpack(a['syndrome_failure_bitmap_zlib_base64'])
                    assert a['frames'] == 5000
                    assert sum(fail) == a['failures'] == sum(logical)+sum(syndrome)
                    assert sum(exact) == a['exact_failures']
                    assert sum(logical) == a['logical_syndrome_matched_failures']
                    assert sum(syndrome) == a['syndrome_failures']
                    assert a['nonexact_stabilizer_successes'] == sum(exact)-sum(fail)
                    assert all(f == (l or sy) and (not f or e) for f, l, sy, e in zip(fail, logical, syndrome, exact))
                    assert a['quantum_fer'] == sum(fail)/5000 and a['wilson95'] == p.wilson(sum(fail), 5000)
                    assert all(not f for (x,z),f in zip(samples[a['p']],fail) if '1' not in x+z)
            for left, right in combinations(b.ARMS, 2):
                if pool['selected'][left] == pool['selected'][right]:
                    assert decoded['arms'][left] == decoded['arms'][right]
        all_candidates += sum(len(pool['candidates']) for pool in family['pools'])
assert all_candidates == 768
assert d['nominal_arm_frame_evaluations'] == 4800000
assert d['actual_quantum_frames'] == unique_selections*30000
assert d['actual_sector_decoder_executions'] == 2*d['actual_quantum_frames']
assert d['decoder_reference_checks'] == 8*unique_selections
assert d['stabilizer_logical_scoring_tests'] == 4*unique_selections
assert d['analysis'] == b.analyze(d['families'])
print(f'Quantum P11: 768 candidates plus 48 calibration examples; literal CSS source arrays, '
      f'exact quantum distances and dimensions, {d["actual_sector_decoder_executions"]} sector decodes, '
      'stabilizer-quotient scoring, selections, spectra and paired contrasts pass.')
