"""For block subsets B, decide whether V_B has a frame made of pool vectors supported in B.
Splitting lemma (THEORY-NOTES section 4): a frame containing 16|B| pairs local to B splits as a local frame
of V_B plus a local frame of V_{B'}. Uses la/gen_instance.py support + la/la_dfs3 (-l -f); Knuth estimate
first, exhaustive run only if the estimate is small."""
import itertools, json, subprocess, sys
from pathlib import Path
here = Path(__file__).resolve().parent; la = here.parent / 'la'; (here / 'inst').mkdir(exist_ok=True)
res = {}
for r in range(1, 8):
    for B in itertools.combinations(range(8), r):
        name = ''.join(map(str, B)); inst = here / 'inst' / f's{name}.txt'
        subprocess.run([sys.executable, str(la / 'gen_instance.py'), 'support', ','.join(map(str, B)), str(inst)], check=True, capture_output=True)
        head = inst.read_text().split('\n', 1)[0].split()
        nx, nz = int(head[0]), int(head[1])
        if nx < 16 * r or nz < 16 * r:
            res[name] = {'status': 'COMPLETE', 'frames': 0, 'reason': f'too few local vectors ({nx}, {nz} < {16*r})'}; continue
        k = subprocess.run(['nice', '-n', '10', str(la / 'la_dfs3'), '-l', '-f', '-k', '200', str(inst)], capture_output=True, text=True, timeout=600)
        est = json.loads(k.stdout.strip().splitlines()[-1])
        if est['mean_tree'] > 2e6 or est['max'] > 2e7:
            res[name] = {'status': 'SKIPPED', 'knuth_mean': est['mean_tree']}; continue
        run = subprocess.run(['nice', '-n', '10', str(la / 'la_dfs3'), '-l', '-f', '-1', str(inst)], capture_output=True, text=True, timeout=1800)
        out = json.loads(run.stdout.strip().splitlines()[-1])
        res[name] = {'status': out['status'], 'frames': out['frames'], 'nodes': out['nodes'], 'nx': nx, 'nz': nz}
        print(name, res[name], flush=True)
        inst.unlink()
json.dump(res, open(here / 'local_frames.json', 'w'), indent=1)
