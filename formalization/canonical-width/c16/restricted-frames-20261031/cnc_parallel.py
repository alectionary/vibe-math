#!/usr/bin/env python3
"""Parallel front end for cnc.py: the same cube tree, state file and statuses,
but up to --jobs Kissat processes run at once on independent leaves.

Only the coordinator writes work/cnc/state.json, after every finished cube, so
the run can be stopped (Ctrl-C) and restarted at any time; cubes that were
running are simply re-run. Modes are as in cnc.py ('search' = no proofs).

  python3 cnc_parallel.py --kissat K --drat-trim D --jobs 6 --mode search
"""
import argparse, json, os, signal, subprocess, sys, time
from pathlib import Path
import cnc
from cnc import WORK, BASE, BASE_SHA, check_tree, decode, load_base, save, sha, split_order, write_cube_cnf


def new_children(state, key, order):
    n = state['nodes'][key]; v = order[n['depth']]; kids = []
    for lit in (v, -v):
        cid = str(state['next_id']); state['next_id'] += 1
        state['nodes'][cid] = {'cube': n['cube'] + [lit], 'depth': n['depth'] + 1}
        kids.append(cid)
    n['split_var'] = v; n['children'] = kids; n['status_before_split'] = 'UNKNOWN_TIME_LIMIT'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--kissat', required=True)
    ap.add_argument('--drat-trim', required=True)
    ap.add_argument('--jobs', type=int, default=max(1, (os.cpu_count() or 2) - 1))
    ap.add_argument('--cube-seconds', type=int, default=300)
    ap.add_argument('--mode', choices=['search', 'certify'], default='search')
    ap.add_argument('--proof-factor', type=float, default=4.0)
    ap.add_argument('--wall', type=int, default=10 ** 9)
    ap.add_argument('--whole-depth', type=int, default=None,
                    help='solve every unfinished node at this depth whole (no further splitting); an UNSAT result collapses its subtree')
    args = ap.parse_args()
    assert sha(BASE) == BASE_SHA, 'base CNF hash mismatch'
    state = json.loads((WORK / 'state.json').read_text())
    order = state['split_order']; assert order == split_order()
    nv, nc, body = load_base()
    want = 'UNSAT_UNPROVED' if args.mode == 'certify' else None
    running = {}   # key -> dict(proc, phase, start, files)
    t0 = time.monotonic(); stopping = False

    def stop(*_):
        nonlocal stopping; stopping = True
    signal.signal(signal.SIGINT, stop); signal.signal(signal.SIGTERM, stop)

    def launch(key):
        n = state['nodes'][key]; tag = f'w{key}'
        cnf = WORK / f'{tag}.cnf'; proof = WORK / f'{tag}.drat'; log = WORK / f'{tag}.log'
        write_cube_cnf(cnf, nv, nc, body, n['cube'])
        limit = args.cube_seconds if args.mode == 'search' else int(3 * n['solve_seconds']) + 120
        cmd = ['nice', '-n', '10', args.kissat, f'--time={limit}', '-q', str(cnf)] + ([str(proof)] if args.mode == 'certify' else [])
        out = log.open('w')
        running[key] = dict(proc=subprocess.Popen(cmd, stdout=out, stderr=subprocess.STDOUT), out=out, phase='solve',
                            start=time.monotonic(), cnf=cnf, proof=proof, log=log, limit=limit)

    def cleanup(r):
        for f in (r['cnf'], r['proof'], r['log']):
            Path(f).unlink(missing_ok=True)

    while True:
        leaves = check_tree(state)
        if any(state['nodes'][k].get('status') == 'SAT' for k in leaves):
            stopping = True
        if not stopping and time.monotonic() - t0 < args.wall:
            if args.whole_depth is not None and args.mode == 'search':
                open_leaf = {k for k in leaves if 'status' not in state['nodes'][k]}
                def unfinished(k):
                    n = state['nodes'][k]
                    if 'children' not in n:
                        return k in open_leaf
                    return any(unfinished(c) for c in n['children'])
                todo = [k for k, n in state['nodes'].items() if n['depth'] == args.whole_depth and not n.get('whole_timeout')
                        and k not in running and unfinished(k)]
            else:
                todo = [k for k in leaves if state['nodes'][k].get('status') == want and k not in running]
            todo.sort(key=lambda k: (state['nodes'][k]['depth'], int(k)))
            while todo and len(running) < args.jobs:
                launch(todo.pop(0))
        if not running:
            break
        time.sleep(0.5)
        for key, r in list(running.items()):
            code = r['proc'].poll()
            if stopping and code is None:
                r['proc'].terminate(); r['proc'].wait(); r['out'].close(); cleanup(r); del running[key]; continue
            if code is None:
                continue
            r['out'].close(); n = state['nodes'][key]; secs = round(time.monotonic() - r['start'], 2)
            if r['phase'] == 'check':
                text = Path(r['checklog']).read_text()
                n['proof_check_seconds'] = secs
                n['status'] = 'UNSAT_CHECKED' if code == 0 and 's VERIFIED' in text else 'UNSAT_CERTIFY_FAILED'
                Path(r['checklog']).unlink(missing_ok=True); cleanup(r); del running[key]
            else:
                text = r['log'].read_text()
                if args.mode == 'certify':
                    n['certify_solve_seconds'] = secs
                else:
                    n['solve_seconds'] = secs; n['time_limit'] = r['limit']
                if code == 20 and 's UNSATISFIABLE' in text and args.mode == 'search':
                    if 'children' in n:   # whole-node solve: the node itself is now a closed leaf
                        n['collapsed_children'] = n.pop('children'); n['collapsed_split_var'] = n.pop('split_var')
                    n['status'] = 'UNSAT_UNPROVED'; cleanup(r); del running[key]
                elif code == 20 and 's UNSATISFIABLE' in text:
                    n['proof_bytes'] = r['proof'].stat().st_size; n['proof_sha256'] = sha(r['proof'])
                    checklog = WORK / f'w{key}.check'; out = checklog.open('w')
                    r.update(proc=subprocess.Popen(['nice', '-n', '10', args.drat_trim, str(r['cnf']), str(r['proof'])],
                                                   stdout=out, stderr=subprocess.STDOUT),
                             out=out, phase='check', start=time.monotonic(), checklog=checklog)
                elif code == 10 and 's SATISFIABLE' in text:
                    model = {int(s) for line in text.splitlines() if line.startswith('v ') for s in line[2:].split() if int(s) > 0}
                    pairs = decode(model)
                    (WORK / 'witness.json').write_text(json.dumps({'cube': n['cube'], 'pool_pairs': pairs}) + '\n')
                    n['status'] = 'SAT'; cleanup(r); del running[key]
                elif args.mode == 'certify':
                    n['certify_note'] = f'proof run returned {code}'; n['status'] = 'UNSAT_CERTIFY_FAILED'; cleanup(r); del running[key]
                elif args.whole_depth is not None:
                    n['whole_timeout'] = r['limit']
                    if 'children' not in n:
                        new_children(state, key, order)
                    cleanup(r); del running[key]
                else:
                    new_children(state, key, order); cleanup(r); del running[key]
            save(state)
            leaves = check_tree(state)
            counts = {}
            for k in leaves:
                s = state['nodes'][k].get('status', 'OPEN'); counts[s] = counts.get(s, 0) + 1
            print(time.strftime('%H:%M:%S'), f'cube {key} d{n["depth"]} -> {n.get("status", "SPLIT")} {secs}s |',
                  json.dumps(counts), f'running {len(running)}', flush=True)
    leaves = check_tree(state)
    counts = {}
    for k in leaves:
        s = state['nodes'][k].get('status', 'OPEN'); counts[s] = counts.get(s, 0) + 1
    print('FINAL', json.dumps(counts), flush=True)


if __name__ == '__main__':
    main()
