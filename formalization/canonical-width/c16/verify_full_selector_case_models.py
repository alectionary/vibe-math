#!/usr/bin/env python3
"""Independent literal CNF and physical-frame replay of a full-selector trial."""
from pathlib import Path
import argparse, gzip, hashlib, json, time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
ROOT = Path(__file__).resolve().parent

def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def read(p):
    p = Path(p)
    return json.loads(gzip.decompress(p.read_bytes()) if p.suffix == '.gz' else p.read_bytes())

def physical_pairs(xs, zs, X, Z):
    assert len(xs) == len(set(xs)) == len(zs) == len(set(zs)) == 128
    pairs = []
    for x in xs:
        partners = [z for z in zs if (X[x] & Z[z]).bit_count() % 2]
        assert len(partners) == 1
        pairs.append((x, partners[0]))
    assert len({z for x, z in pairs}) == 128
    assert all((X[x] & Z[z]).bit_count() % 2 == int(i == j)
               for i, (x, _) in enumerate(pairs) for j, (_, z) in enumerate(pairs))
    assert dimension(X[x] for x in xs) == dimension(Z[z] for z in zs) == 128
    return pairs

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--directory', type=Path, required=True)
    args = ap.parse_args()
    D = args.directory
    outpath = D / 'models-independent.json'
    assert not outpath.exists()
    start = time.monotonic()
    f, b, t = [read(D / n) for n in ['frozen.json.gz', 'bridge-controls.json', 'trials-summary.json']]
    assert b['status'] == 'PASS_NEW_BOOLEAN_CNF_BRIDGE_CONTROLS'
    assert b['model_kind'] == 'EXACT_FULL128_BY128_PHYSICAL_SELECTOR'
    assert b['frozen_sha256'] == sha(D / 'frozen.json.gz')
    assert all(sha(ROOT / p) == h for p, h in f['source_hashes'].items())
    assert all(sha(ROOT / p) == h for p, h in f['input_hashes'].items())
    assert t['input_frozen_sha256'] == sha(D / 'frozen.json.gz')
    X, Z, A = physical()
    records = []
    for arm in ['baseline', 'small64']:
        r = read(D / (arm + '-trial.json'))
        record = {'arm': arm, 'trial_sha256': sha(D / (arm + '-trial.json')), 'trial_status': r['status']}
        if r['status'] != 'SAT_FULL_FRAME_CANDIDATE':
            assert r['status'] in ['UNKNOWN_OUTER_SOLVE_WALL_LIMIT', 'UNSAT_UNREPLAYED_DISCOVERY']
            record.update(status='NO_MODEL_TO_ACCEPT', source_frame_verified=False, source_exclusion_accepted=False)
            records.append(record)
            continue
        mp = D / (arm + '-model.json.gz')
        assert r['model_sha256'] == sha(mp)
        model = read(mp)
        raw = gzip.decompress((D / (arm + '.cnf.gz')).read_bytes())
        lines = raw.decode().splitlines()
        _, _, nv, nc = lines[0].split()
        assert len(model) == len(set(abs(v) for v in model)) == int(nv)
        assert {abs(v) for v in model} == set(range(1, int(nv) + 1))
        positive = {v for v in model if v > 0}
        assert len(lines) - 1 == int(nc)
        for line in lines[1:]:
            row = list(map(int, line.split()))
            assert row[-1] == 0 and all(abs(v) <= int(nv) for v in row[:-1])
            assert any((v in positive) if v > 0 else (-v not in positive) for v in row[:-1])
        xs = [i for i in range(720) if i + 1 in positive]
        zs = [j for j in range(720) if j + 721 in positive]
        pairs = physical_pairs(xs, zs, X, Z)
        assert (512, 512) in pairs
        ps = [int(512 + h in xs) for h in range(16)]
        c = f['coefficients']
        value = c[0] + c[1] * sum(ps)
        value += sum(c[1 + h] * sum(ps[a] * ps[(a + h) % 16] for a in range(16)) for h in range(1, 9))
        value += sum(c[10 + j // 16] for j in zs)
        value += sum(c[55 + 16 * (j // 16) + (j % 16 - a) % 16] * ps[a] for j in zs for a in range(16))
        assert value <= f['bound']
        try:
            physical_pairs(xs[:-1], zs, X, Z)
        except AssertionError:
            pass
        else:
            raise AssertionError('Deleted selected vector accepted')
        record.update(status='PASS_128_PHYSICAL_DUAL_PAIRS', source_frame_verified=True,
                      source_exclusion_accepted=False, pairs=pairs, selected_X=xs, selected_Z=zs,
                      physical_pairings_checked=16384, rank_X=128, rank_Z=128,
                      literal_CNF_clauses_checked=int(nc), CNF_raw_sha256=hashlib.sha256(raw).hexdigest(),
                      model_sha256=sha(mp), cut_value=value, cut_bound=f['bound'],
                      deleted_vector_negative_control_rejected=True)
        records.append(record)
    found = any(r['source_frame_verified'] for r in records)
    out = dict(status='PASS_FULL_PHYSICAL_FRAME' if found else 'NO_SOURCE_ENDPOINT_ACCEPTED',
               source_C16_answered=found, source_exclusions_accepted=0, records=records,
               consumer_sha256=sha(__file__), frozen_sha256=sha(D / 'frozen.json.gz'),
               bridge_controls_sha256=sha(D / 'bridge-controls.json'),
               trials_summary_sha256=sha(D / 'trials-summary.json'), seconds=time.monotonic()-start)
    outpath.write_text(json.dumps(out, indent=2) + '\n')
    print(json.dumps(out), flush=True)

if __name__ == '__main__':
    main()
