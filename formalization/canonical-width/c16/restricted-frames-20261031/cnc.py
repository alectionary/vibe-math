#!/usr/bin/env python3
"""Resumable cube-and-conquer driver for the half-turn (order-2) C16 CNF.

The base CNF is produced by the frozen ../subgroup_frame.py --order 2
--encode-only (with pysat_shim/). A cube is a list of literals. A cube is
conquered by appending the literals as unit clauses and running Kissat with a
per-cube time limit and a DRAT proof:

  - UNSAT: the proof is checked by drat-trim against the cube CNF, then deleted
    (its SHA-256 and size are kept). The cube is closed.
  - SAT: the model is decoded with the same checks as subgroup_frame.py and
    the 128 pool pairs are written to work/cnc/witness.json.
  - unknown (time limit): the cube is split on the next variable of the split
    order into  cube+[v]  and  cube+[-v].

The cubes form a binary tree. Every split replaces a node by its two children,
so the leaves always cover every assignment. `check_tree()` re-verifies that
independently from the recorded tree. The base CNF is UNSAT iff every leaf
is closed with a checked proof.

State is kept in work/cnc/state.json and written after every cube, so the
driver can be killed at any time and restarted.

Usage: cnc.py --kissat K --drat-trim D [--cube-seconds 900] [--wall 6600]
"""
import argparse, hashlib, json, os, subprocess, sys, time
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent                       # formalization/canonical-width/c16
WORK = HERE / 'work' / 'cnc'
BASE = HERE / 'work' / 'sub' / 'o2.cnf'
BASE_SHA = 'dc2b1d0d8b5e123d88b566ef77e2746173a0c4e4c8f2659efd402e7c41dc0452'
if os.environ.get('C16_CNC') == 'o12':   # orbit-12-first symmetry breaking (subgroup_frame_o12.py)
    WORK = HERE / 'work' / 'cnc-o12'
    BASE = HERE / 'work' / 'o12' / 'o12.cnf'
    BASE_SHA = '470ce05d4ae9e607a91cd56677fc5b9d1abb427928d335c838681d689ca48211'
L, d = 2, 8
m = 45 * d                               # orbit variables per sector


def split_order():
    """Primary orbit variables, most constrained first: the critical orbit 12
    (X then Z), then the remaining orbits interleaved X/Z by orbit index."""
    order = [12 * d + p + 1 for p in range(d)] + [m + 12 * d + p + 1 for p in range(d)]
    for a in range(45):
        if a == 12:
            continue
        for p in range(d):
            order += [a * d + p + 1, m + a * d + p + 1]
    return order


def sha(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1 << 22), b''):
            h.update(chunk)
    return h.hexdigest()


def load_base():
    text = BASE.read_bytes()
    first, rest = text.split(b'\n', 1)
    _, _, nv, nc = first.split()
    return int(nv), int(nc), rest


def write_cube_cnf(path, nv, nc, body, cube):
    with open(path, 'wb') as f:
        f.write(f'p cnf {nv} {nc + len(cube)}\n'.encode())
        f.write(body)
        for lit in cube:
            f.write(f'{lit} 0\n'.encode())


def patterns():
    X = [int(v, 16) for v in (ROOT / 'pools/xcoords.txt').read_text().split()]
    Z = [int(v, 16) for v in (ROOT / 'pools/zcoords.txt').read_text().split()]
    P = [[sum((bin(X[16 * a + p] & Z[16 * b + q + d * h]).count('1') % 2) << h for h in range(L))
          for b in range(45) for q in range(d)] for a in range(45) for p in range(d)]
    return X, Z, P


def decode(model):
    """Same decoding and checks as subgroup_frame.py; returns 128 pool pairs."""
    X, Z, P = patterns()
    target = 128 // L
    cx = [i for i in range(m) if i + 1 in model]
    cz = [j for j in range(m) if m + j + 1 in model]
    assert len(cx) == len(cz) == target
    pairs = []
    for i in cx:
        partners = [j for j in cz if P[i][j]]
        assert len(partners) == 1
        j = partners[0]; f = P[i][j]; assert bin(f).count('1') == 1; h = f.bit_length() - 1
        for s in range(L):
            pairs.append([16 * (i // d) + i % d + d * s, 16 * (j // d) + j % d + d * ((s + h) % L)])
    assert len(pairs) == 128
    assert all(bin(X[i] & Z[j]).count('1') % 2 == (a == b)
               for a, (i, _) in enumerate(pairs) for b, (_, j) in enumerate(pairs))
    return pairs


def check_tree(state):
    """The leaves of the recorded tree partition the assignment space."""
    nodes = state['nodes']
    def walk(k, prefix):
        n = nodes[k]
        assert n['cube'] == prefix, (k, n['cube'], prefix)
        if 'children' not in n:
            return [k]
        v = n['split_var']; a, b = n['children']
        assert nodes[a]['cube'] == prefix + [v] and nodes[b]['cube'] == prefix + [-v]
        return walk(a, prefix + [v]) + walk(b, prefix + [-v])
    return walk('0', [])


def save(state):
    tmp = WORK / 'state.json.tmp'
    tmp.write_text(json.dumps(state, indent=1) + '\n')
    os.replace(tmp, WORK / 'state.json')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--kissat', required=True)
    ap.add_argument('--drat-trim', required=True)
    ap.add_argument('--cube-seconds', type=int, default=900)
    ap.add_argument('--proof-factor', type=float, default=4.0)
    ap.add_argument('--mode', choices=['search', 'certify', 'both'], default='both',
                    help='search: no proofs, UNSAT leaves become UNSAT_UNPROVED; certify: re-solve those with proofs and check them; both: prove and check during search')
    ap.add_argument('--deep-first', action='store_true', help='take the deepest open cube first (probes whether splitting helps)')
    ap.add_argument('--initial-depth', type=int, default=8)
    ap.add_argument('--wall', type=int, default=6600, help='stop starting new cubes after this many seconds')
    args = ap.parse_args()
    WORK.mkdir(parents=True, exist_ok=True)
    assert sha(BASE) == BASE_SHA, 'base CNF hash mismatch'
    order = split_order()
    sp = WORK / 'state.json'
    if sp.exists():
        state = json.loads(sp.read_text())
    else:
        state = {'base_cnf_sha256': BASE_SHA, 'split_order': order, 'nodes': {'0': {'cube': [], 'depth': 0}}, 'next_id': 1}
        # Pre-split the root on the first `initial-depth` split variables.
        frontier = ['0']
        for k in range(args.initial_depth):
            new = []
            for key in frontier:
                n = state['nodes'][key]; v = order[n['depth']]
                kids = []
                for lit in (v, -v):
                    cid = str(state['next_id']); state['next_id'] += 1
                    state['nodes'][cid] = {'cube': n['cube'] + [lit], 'depth': n['depth'] + 1}
                    kids.append(cid)
                n['split_var'] = v; n['children'] = kids; new += kids
            frontier = new
        save(state)
    nv, nc, body = load_base()
    t0 = time.monotonic()
    while time.monotonic() - t0 < args.wall:
        leaves = check_tree(state)
        if any(state['nodes'][k].get('status') == 'SAT' for k in leaves):
            break
        want = 'UNSAT_UNPROVED' if args.mode == 'certify' else None
        todo = [k for k in leaves if state['nodes'][k].get('status') == want]
        if not todo:
            break
        key = min(todo, key=lambda k: ((-1 if args.deep_first else 1) * state['nodes'][k]['depth'], int(k)))
        n = state['nodes'][key]
        cnf = WORK / 'cube.cnf'; proof = WORK / 'cube.drat'; log = WORK / 'cube.log'
        write_cube_cnf(cnf, nv, nc, body, n['cube'])
        limit = args.cube_seconds if args.mode != 'certify' else int(3 * n['solve_seconds']) + 120
        prove = args.mode != 'search'
        start = time.monotonic()
        with log.open('w') as out:
            try:
                code = subprocess.run(['nice', '-n', '19', args.kissat, f'--time={limit}', '-q', str(cnf)] + ([str(proof)] if prove else []),
                                      stdout=out, stderr=subprocess.STDOUT, timeout=limit + 30).returncode
            except subprocess.TimeoutExpired:
                code = -15
        secs = round(time.monotonic() - start, 2)
        if args.mode == 'certify':
            n['certify_solve_seconds'] = secs
        else:
            n['solve_seconds'] = secs; n['time_limit'] = limit
        text = log.read_text()
        if code == 20 and 's UNSATISFIABLE' in text and not prove:
            n['status'] = 'UNSAT_UNPROVED'
        elif code == 20 and 's UNSATISFIABLE' in text:
            n['proof_bytes'] = proof.stat().st_size; n['proof_sha256'] = sha(proof)
            pstart = time.monotonic()
            try:
                chk = subprocess.run(['nice', '-n', '19', args.drat_trim, str(cnf), str(proof)], capture_output=True, text=True,
                                     timeout=int(args.proof_factor * secs) + 300)
                ok = chk.returncode == 0 and 's VERIFIED' in (chk.stdout + chk.stderr)
            except subprocess.TimeoutExpired:
                ok = False
            n['proof_check_seconds'] = round(time.monotonic() - pstart, 2)
            n['status'] = 'UNSAT_CHECKED' if ok else 'UNSAT_UNCHECKED'
        elif code == 10 and 's SATISFIABLE' in text:
            model = {int(s) for line in text.splitlines() if line.startswith('v ') for s in line[2:].split() if int(s) > 0}
            pairs = decode(model)
            (WORK / 'witness.json').write_text(json.dumps({'cube': n['cube'], 'pool_pairs': pairs}) + '\n')
            n['status'] = 'SAT'
        elif args.mode == 'certify':
            n['certify_note'] = f'proof run returned {code}'; n['status'] = 'UNSAT_CERTIFY_FAILED'
        else:
            v = order[n['depth']]; kids = []
            for lit in (v, -v):
                cid = str(state['next_id']); state['next_id'] += 1
                state['nodes'][cid] = {'cube': n['cube'] + [lit], 'depth': n['depth'] + 1}
                kids.append(cid)
            n['split_var'] = v; n['children'] = kids; n['status_before_split'] = 'UNKNOWN_TIME_LIMIT'
        proof.unlink(missing_ok=True)
        save(state)
        leaves = check_tree(state)
        closed = sum(state['nodes'][k].get('status') == 'UNSAT_CHECKED' for k in leaves)
        print(f"cube {key} depth {n['depth']} -> {n.get('status', 'SPLIT')} in {n['solve_seconds']}s "
              f"(+{n.get('proof_check_seconds', 0)}s check); leaves {len(leaves)}, closed {closed}", flush=True)
    leaves = check_tree(state)
    summary = {s: sum(state['nodes'][k].get('status', 'OPEN') == s for k in leaves)
               for s in ['UNSAT_CHECKED', 'UNSAT_UNPROVED', 'UNSAT_UNCHECKED', 'SAT', 'OPEN']}
    summary['leaves'] = len(leaves)
    summary['solve_seconds_total'] = round(sum(n.get('solve_seconds', 0) for n in state['nodes'].values()), 1)
    summary['check_seconds_total'] = round(sum(n.get('proof_check_seconds', 0) for n in state['nodes'].values()), 1)
    print(json.dumps(summary), flush=True)


if __name__ == '__main__':
    main()
