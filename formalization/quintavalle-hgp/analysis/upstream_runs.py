"""Run pinned original BP+OSD x2 software; never label pilots as thresholds."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import time

ROOT = Path(__file__).resolve().parents[1]


def run(repo, topology, size, p, q, depth, trials, repair, seed, limit=120):
    label = f'{topology}_L{size}_p{p}_q{q}_N{depth}_repair{int(repair)}_seed{seed}'
    out = ROOT / 'results' / 'original' / label
    out.mkdir(parents=True, exist_ok=True)
    inp = json.loads((repo / f'sim_scripts/{topology}_input_demo.json').read_text())
    inp.update(target_runs=trials, distance_label=size, code_label=label,
               bit_error_rate=p, syndrome_error_rate=q, sustained_threshold_depth=depth,
               failure_mode_subroutine=repair, input_seed=seed)
    for field in ['hx', 'lx', 'mx', 'lmx', 'mxlmx']:
        if field+'_filename' in inp:
            inp[field+'_filename'] = f'codes/{topology}/{topology}_{size}_{field}.alist'
    input_file = out/'input.json'
    input_file.write_text(json.dumps(inp, indent=2)+'\n')
    # A repeated run must never read a stale prior timestamped output.
    prior = {x: x.stat().st_mtime_ns for x in out.glob("*.json") if x.name != "input.json"}
    start = time.monotonic()
    with (out/'run.log').open('w') as log:
        try:
            proc = subprocess.run([str(repo/'build/single_shot_hgp3d'), str(input_file), str(out)], cwd=repo, stdout=log, stderr=subprocess.STDOUT, timeout=limit)
            status = 'completed' if proc.returncode == 0 else f'exit_{proc.returncode}'
        except subprocess.TimeoutExpired:
            status = 'timeout'
    elapsed = time.monotonic()-start
    raw = sorted((x for x in out.glob('*.json') if x.name != 'input.json'
                  and (x not in prior or x.stat().st_mtime_ns != prior[x])),
                 key=lambda x: x.stat().st_mtime_ns, reverse=True)
    data = json.loads(raw[0].read_text()) if raw else {}
    result = dict(label=label,status=status,elapsed_seconds=elapsed,requested=trials,
                  completed=data.get('run_count',0), failures=data.get('run_count',0)-data.get('osdw_success_count',0),
                  rate=data.get('osdw_ler'),settings=inp,raw_files=[str(x.relative_to(ROOT)) for x in raw])
    return result


if __name__ == '__main__':
    ap=argparse.ArgumentParser();ap.add_argument('repo',type=Path);ap.add_argument('--suite',action='store_true');a=ap.parse_args()
    if a.suite:
        # Reconstructed diagnostic grid: explicitly NOT an original-grid replication.
        jobs=[('toric3D',5,.1,q,1,10000,repair,20261103+100*i+int(repair))
              for i,q in enumerate([.005,.01,.02,.03]) for repair in [False,True]]
    else:
        jobs=[(top,size,.03,.03,8,10,top=='toric3D',20261103+i)
              for i,(top,size) in enumerate([('surface3D',5),('toric3D',5),('surface3D',11),('toric3D',11)])]
    results=[]
    for job in jobs:
        result=run(a.repo.resolve(),*job,limit=180)
        results.append(result)
        print(json.dumps(result),flush=True)
        (ROOT/'results'/('original_diagnostic_grid.json' if a.suite else 'original_pilots.json')).write_text(json.dumps(results,indent=2)+'\n')
