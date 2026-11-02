#!/usr/bin/env python3
"""Cloud helper: solve hard first-level pieces (those the Mac set aside with
whole_timeout) whole, two at a time, and record results in
work/cloud-closed.json for later merging into the Mac tree.
  cloudhard.py hard.json [--seconds 7000] [--jobs 2]
hard.json maps node id -> cube literals."""
import argparse, json, subprocess, time
from pathlib import Path
import cnc
ap = argparse.ArgumentParser(); ap.add_argument('hard'); ap.add_argument('--seconds', type=int, default=7000); ap.add_argument('--jobs', type=int, default=2)
a = ap.parse_args()
out = cnc.WORK / 'cloud-closed.json'
done = json.loads(out.read_text()) if out.exists() else {}
hard = json.loads(Path(a.hard).read_text())
todo = [k for k in sorted(hard, key=int) if k not in done][:a.jobs]
nv, nc, body = cnc.load_base(); P = {}
for k in todo:
    p = cnc.WORK / f'hard{k}.cnf'; cnc.write_cube_cnf(p, nv, nc, body, hard[k])
    P[k] = (subprocess.Popen(['nice', '-n', '19', '/root/kissat/build/kissat', f'--time={a.seconds}', str(p)],
                             stdout=open(cnc.WORK / f'hard{k}.log', 'w'), stderr=subprocess.STDOUT), p)
for k, (p, f) in P.items():
    c = p.wait(); log = (cnc.WORK / f'hard{k}.log').read_text()
    secs = float([l for l in log.splitlines() if 'process-time' in l][-1].split()[-2]) if 'process-time' in log else None
    st = {10: 'SAT', 20: 'UNSAT_UNPROVED'}.get(c, 'UNKNOWN')
    if st == 'SAT':
        model = {int(s) for l in log.splitlines() if l.startswith('v ') for s in l[2:].split() if int(s) > 0}
        (cnc.WORK / f'witness-cloud-{k}.json').write_text(json.dumps({'cube': hard[k], 'pool_pairs': cnc.decode(model)}) + '\n')
    done = json.loads(out.read_text()) if out.exists() else {}
    done[k] = {'cube': hard[k], 'status': st, 'process_seconds': secs, 'limit': a.seconds}
    out.write_text(json.dumps(done, indent=1) + '\n'); print(k, done[k], flush=True); f.unlink()
