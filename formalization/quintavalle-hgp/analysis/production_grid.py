"""Checkpointed single-shot grid on the archived matrices.

Source plots use at least 10,000 Monte Carlo trials and include a point when
it has at least 25 failures. This driver always requests 10,000 trials. It
does not stop early, and it does not change the pinned decoder order.

The Release binary takes about 1.8 seconds per toric L=11 trial. A full
sustainable (N=8) grid at L=9 and L=11 would pass 24 wall-clock hours on
4 cores, so those points are listed as not_run rather than started.
Code capacity (one perfect syndrome, depth 0) is run for every archived
size up to toric L=11 and surface L=9. Surface files stop at L=9.
"""
import json
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import upstream_runs

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT / 'vendor' / 'single_shot_3D_HGP'
CHECKPOINT = ROOT / 'results' / 'production_checkpoint.jsonl'
SUMMARY = ROOT / 'results' / 'production_grid.json'
TRIALS = 10000
WORKERS = 4
# Toric L=11 capacity is about 1.8 s/trial; allow margin over 5 hours.
LIMIT = 8 * 3600

CAPACITY_P = [0.10, 0.12, 0.14, 0.16, 0.18, 0.20, 0.21, 0.215, 0.22, 0.23, 0.24]
FIGURE2_Q = [0.005, 0.01, 0.02, 0.03, 0.05, 0.1]
SUSTAINABLE_P = [0.02, 0.025, 0.03, 0.035]


def jobs():
    planned = []
    seed = 910000
    def add(**kwargs):
        nonlocal seed
        seed += 1
        planned.append(dict(trials=TRIALS, seed=seed, **kwargs))
    for topology, sizes in (('toric3D', [5, 7, 9, 11]), ('surface3D', [3, 5, 7, 9])):
        for size in sizes:
            for p in CAPACITY_P:
                add(family='code_capacity', topology=topology, size=size, p=p, q=0.0,
                    depth=0, repair=False)
    for q in FIGURE2_Q:
        for repair in (False, True):
            add(family='figure2_l5', topology='toric3D', size=5, p=0.1, q=q,
                depth=1, repair=repair)
    for topology, sizes in (('toric3D', [5, 7]), ('surface3D', [5, 7])):
        for size in sizes:
            for p in SUSTAINABLE_P:
                # Surface archives have no lmx/mxlmx, so the subroutine cannot run.
                repair = topology == 'toric3D'
                add(family='sustainable_n8', topology=topology, size=size, p=p, q=p,
                    depth=8, repair=repair)
    def weight(job):
        size_cost = {11: 100, 9: 40, 7: 8, 5: 2, 3: 1}[job['size']]
        depth_cost = {0: 1, 1: 3, 8: 12}[job['depth']]
        return size_cost * depth_cost
    planned.sort(key=weight, reverse=True)
    return planned


NOT_RUN = [
    {
        'family': 'sustainable_n8',
        'topology': 'toric3D',
        'sizes': [9, 11],
        'reason': 'Release timing is 0.23 s/trial at toric L=9 depth 0 and 1.76 s/trial at toric L=11 depth 0. Eight noisy rounds scale that by about 11, so one 10,000-trial L=11 point is about 54 CPU-hours. The full p-grid at L=9 and L=11 exceeds 24 wall-clock hours on 4 cores.',
        'cost_estimate': 'About 54 CPU-hours per toric L=11, N=8, 10,000-trial point; about 7 CPU-hours per toric L=9 point.',
        'decision': 'Not run. Code capacity at these sizes is running; the sustainable N=8 grid is limited to L=5 and L=7.',
        'tractable': False,
    },
    {
        'family': 'code_capacity',
        'topology': 'surface3D',
        'sizes': [11],
        'reason': 'The archive has surface matrices through L=9 only. surface3D_11_hx.alist is absent.',
        'missing_input': 'surface L=11 hx, lx, and mx matrices',
        'looked_in': 'vendor/single_shot_3D_HGP/codes/surface3D',
    },
    {
        'family': 'mwpm_strategy',
        'reason': 'The second published decoder uses MWPM for syndrome repair. That implementation is not in the pinned repository.',
        'missing_input': 'MWPM syndrome-repair decoder',
        'looked_in': 'vendor/single_shot_3D_HGP and its bp_osd subtree',
    },
]


def label_of(job):
    return (f"{job['topology']}_L{job['size']}_p{job['p']}_q{job['q']}"
            f"_N{job['depth']}_repair{int(job['repair'])}_seed{job['seed']}")


def finished():
    done = {}
    if CHECKPOINT.exists():
        for line in CHECKPOINT.read_text().splitlines():
            if not line.strip():
                continue
            row = json.loads(line)
            if row.get('status') == 'completed' and row.get('completed') == row.get('requested'):
                done[row['label']] = row
    return done


def execute(job):
    result = upstream_runs.run(
        REPO, job['topology'], job['size'], job['p'], job['q'], job['depth'],
        job['trials'], job['repair'], job['seed'], limit=LIMIT)
    result.update(family=job['family'], topology=job['topology'], size=job['size'],
                  p=job['p'], q=job['q'], depth=job['depth'], repair=job['repair'],
                  seed=job['seed'],
                  meets_source_inclusion=result.get('failures', 0) >= 25 and result.get('completed') == TRIALS)
    return result


def main():
    done = finished()
    pending = [job for job in jobs() if label_of(job) not in done]
    print(f'pending {len(pending)} of {len(pending)+len(done)}', flush=True)
    CHECKPOINT.parent.mkdir(parents=True, exist_ok=True)
    if pending:
        with ProcessPoolExecutor(max_workers=WORKERS) as pool:
            futures = [pool.submit(execute, job) for job in pending]
            for future in as_completed(futures):
                row = future.result()
                with CHECKPOINT.open('a') as handle:
                    handle.write(json.dumps(row) + '\n')
                print(row['label'], row['status'], row.get('failures'), flush=True)
    rows = list(finished().values())
    SUMMARY.write_text(json.dumps({
        'trials': TRIALS,
        'inclusion_rule': 'Source plots use eta >= 10000 and show points with at least 25 failures.',
        'decoder': 'Pinned BP+OSD, osd_order 50, methods from the topology demo input.',
        'workers': WORKERS,
        'completed': len(rows),
        'not_run': NOT_RUN,
        'rows': rows,
    }, indent=2) + '\n')
    print(f'wrote {len(rows)} rows', flush=True)


if __name__ == '__main__':
    main()
