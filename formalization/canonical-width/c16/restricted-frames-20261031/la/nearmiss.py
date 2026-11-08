#!/usr/bin/env python3
"""Exhaustive completion of dismantled near-miss partial frames.
  nearmiss.py INSTANCE FIXED_SOURCE OUTJSONL --drop D --trials K [--seed S] [--limit SEC] [--keep-mode random|nonmono]
Each trial keeps a random subset of the near-miss pairs (dropping D) and runs la_gen_x -l -p on it:
COMPLETE with frames = 0 means no frame contains the kept pairs."""
import argparse, json, random, subprocess, time
ap = argparse.ArgumentParser()
ap.add_argument('instance'); ap.add_argument('source'); ap.add_argument('out')
ap.add_argument('--drop', type=int, required=True); ap.add_argument('--trials', type=int, default=3)
ap.add_argument('--seed', type=int, default=0); ap.add_argument('--limit', type=int, default=300)
a = ap.parse_args()
pairs = [tuple(map(int, l.split())) for l in open(a.source) if l.strip()]
rnd = random.Random(a.seed)
for t in range(a.trials):
    keep = sorted(rnd.sample(pairs, len(pairs) - a.drop))
    tag = f'/tmp/nm-{a.drop}-{a.seed}-{t}'
    open(tag + '.fixed', 'w').write(''.join(f'{i} {j}\n' for i, j in keep))
    t0 = time.time()
    r = subprocess.run(['./la_gen_x', '-l', '-t', str(a.limit), '-o', tag + '.frames', '-p', tag + '.fixed', a.instance],
                       capture_output=True, text=True)
    res = json.loads(r.stdout)
    # FRAME lines list only the searched pairs; prepend the kept ones so each line is a whole frame
    frames = ''.join('FRAME ' + ' '.join(f'{i} {j}' for i, j in keep) + l[5:] + '\n'
                     for l in open(tag + '.frames').read().splitlines() if l.startswith('FRAME'))
    rec = {'source': a.source, 'drop': a.drop, 'seed': a.seed, 'trial': t, 'kept': keep, 'status': res['status'],
           'frames': res['frames'], 'nodes': res['nodes'], 'seconds': round(time.time() - t0, 1), 'frame_lines': frames.splitlines()[:3]}
    with open(a.out, 'a') as f: f.write(json.dumps(rec) + '\n')
    print(f"drop {a.drop} trial {t}: {res['status']} frames={res['frames']} nodes={res['nodes']} {rec['seconds']}s", flush=True)
