#!/usr/bin/env python3
"""Probe: count-based splitting versus the single-literal ladder.

For a base cube C (literals) and a group of variables V (one orbit's 8
sub-orbit variables on one side), solve C & (|V| = k) for k = 0..|V|, with
"exactly k" written directly as clauses on V (no auxiliary variables):
at most k is a clause (-v...) for every (k+1)-subset; at least k is a
clause (v...) for every (|V|-k+1)-subset. These cubes partition C.

  cardtest.py --cube 97,98,... --group 457-464 --jobs 2 --limit 1800 --out results.json
"""
import argparse, itertools, json, subprocess, time
from pathlib import Path
from cnc import BASE, BASE_SHA, WORK, load_base, sha


def exactly(V, k):
    cl = [[-v for v in S] for S in itertools.combinations(V, k + 1)] if k < len(V) else []
    if k > 0:
        cl += [list(S) for S in itertools.combinations(V, len(V) - k + 1)]
    return cl


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--kissat', default='/root/kissat/build/kissat')
    ap.add_argument('--cube', required=True)
    ap.add_argument('--group', required=True, help='a-b inclusive variable range')
    ap.add_argument('--jobs', type=int, default=2)
    ap.add_argument('--limit', type=int, default=1800)
    ap.add_argument('--out', required=True)
    args = ap.parse_args()
    assert sha(BASE) == BASE_SHA
    cube = [int(x) for x in args.cube.split(',')]
    a, b = map(int, args.group.split('-')); V = list(range(a, b + 1))
    nv, nc, body = load_base()
    d = WORK / 'cardtest'; d.mkdir(parents=True, exist_ok=True)
    jobs = list(range(len(V) + 1)); running = {}; res = {}
    while jobs or running:
        while jobs and len(running) < args.jobs:
            k = jobs.pop(0); extra = [[l] for l in cube] + exactly(V, k)
            cnf = d / f'k{k}.cnf'
            with open(cnf, 'wb') as f:
                f.write(f'p cnf {nv} {nc + len(extra)}\n'.encode()); f.write(body)
                for c in extra: f.write((' '.join(map(str, c)) + ' 0\n').encode())
            log = (d / f'k{k}.log').open('w')
            running[k] = (subprocess.Popen(['nice', '-n', '19', args.kissat, f'--time={args.limit}', '-q', str(cnf)],
                                           stdout=log, stderr=subprocess.STDOUT), time.monotonic(), log)
        time.sleep(0.5)
        for k, (p, t, log) in list(running.items()):
            c = p.poll()
            if c is None: continue
            log.close(); res[k] = {'code': c, 'seconds': round(time.monotonic() - t, 2),
                                   'result': {10: 'SAT', 20: 'UNSAT'}.get(c, 'UNKNOWN')}
            print(k, res[k], flush=True); del running[k]
            Path(args.out).write_text(json.dumps({'cube': cube, 'group': V, 'results': res}, indent=1) + '\n')
    print('total', round(sum(r['seconds'] for r in res.values()), 1))


if __name__ == '__main__':
    main()
