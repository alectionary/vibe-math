#!/usr/bin/env python3
"""Frozen ten-minute45-anchor singleton cross-rank attribution cohort."""
from pathlib import Path
import hashlib, json, os, subprocess, sys, time
ROOT = Path(__file__).resolve().parents[1]
PYTHON = sys.executable
R = ROOT/'coupling-results'
POINT = R/'multi-witness8-rational.json.gz'
EXPECTED_POINT = '7b5c1df2bc4c7790dc569b6d6920cde6cc28341e1aaf5622c18f384cee74c930'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    start = time.monotonic()
    output = R/'full-partner-singleton-rest29-witness8.json'
    frozen_path = R/'full-partner-singleton-rest29-witness8.frozen.json'
    assert not output.exists() and not frozen_path.exists() and sha(POINT) == EXPECTED_POINT
    scripts = ['full-partner-singleton-wolfe-generic.py', 'full-partner-singleton-exact-wolfe-generic.py',
               'full-partner-singleton-independent-generic.py', 'full-partner-singleton-rest29.py']
    frozen = {'status': 'FROZEN_REMAINING29_ANCHOR_SINGLETON_RANK_COHORT', 'source_C16_answered': False,
              'point_sha256': sha(POINT), 'accepted_point_check_summary_sha256': sha(R/'multi-witness8-checks-summary.json'),
              'source_hashes': {s: sha(R/s) for s in scripts}, 'anchor_orbits': list(range(16, 45)),
              'outer_seconds': 600, 'column_cap_per_anchor': 2000,
              'scope': 'All present-conditioned cross-sector rank inequalities for each stated anchor only. No absent conditioning, same-sector ranks, joint-profile membership, or full source frame claim.'}
    frozen_path.write_text(json.dumps(frozen, indent=2)+'\n')
    summary = {**frozen, 'frozen_sha256': sha(frozen_path), 'status': 'RUNNING', 'records': []}
    env = dict(os.environ, PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1')

    def run(script, arguments, log, seconds):
        with log.open('w') as handle:
            try:
                call = subprocess.run([PYTHON, str(R/script), *map(str, arguments)], cwd=ROOT, env=env,
                                      stdout=handle, stderr=subprocess.STDOUT, timeout=max(1, seconds))
                return call.returncode
            except subprocess.TimeoutExpired:
                return 'OUTER_TIMEOUT'

    for orbit in range(16, 45):
        remaining = 600-(time.monotonic()-start)
        if remaining <= 2: break
        budget = remaining/(45-orbit)
        stem = R/f'full-partner-singleton-rest29-witness8-o{orbit:02d}'
        numeric = stem.with_name(stem.name+'-wolfe.json')
        numeric_cap = min(20., max(1., budget*.60))
        rc = run('full-partner-singleton-wolfe-generic.py', ['--point', POINT, '--orbit', orbit,
                 '--output', numeric, '--seconds', numeric_cap, '--column-cap', 2000],
                 stem.with_name(stem.name+'-wolfe.log'), remaining)
        record = {'anchor_orbit': orbit, 'numeric_returncode': rc, 'numeric_seconds_cap': numeric_cap}
        if rc != 0:
            record['status'] = 'NUMERIC_STAGE_FAILED'; summary['records'].append(record)
            output.write_text(json.dumps(summary, indent=2)+'\n'); print(json.dumps(record), flush=True); continue
        n = json.loads(numeric.read_text()); record['numeric_status'] = n['status']; record['numeric_sha256'] = sha(numeric)
        candidate = numeric
        if n['status'] == 'BOUNDED_INCONCLUSIVE':
            remaining = 600-(time.monotonic()-start)
            if remaining <= 2: record['status'] = 'OUTER_TIME_LIMIT'; summary['records'].append(record); break
            exact = stem.with_name(stem.name+'-exact.json')
            exact_cap = min(30., max(1., (remaining/(45-orbit))*.35))
            rc = run('full-partner-singleton-exact-wolfe-generic.py', ['--point', POINT, '--orbit', orbit,
                     '--seed', numeric, '--output', exact, '--seconds', exact_cap],
                     stem.with_name(stem.name+'-exact.log'), remaining)
            record.update(exact_returncode=rc, exact_seconds_cap=exact_cap)
            if rc != 0:
                record['status'] = 'EXACT_STAGE_FAILED'; summary['records'].append(record)
                output.write_text(json.dumps(summary, indent=2)+'\n'); print(json.dumps(record), flush=True); continue
            n = json.loads(exact.read_text()); candidate = exact
        record.update(candidate_path=str(candidate.relative_to(ROOT)), candidate_sha256=sha(candidate), candidate_status=n['status'])
        if n['status'] == 'BOUNDED_INCONCLUSIVE':
            record['status'] = 'BOUNDED_INCONCLUSIVE'
        else:
            receipt = stem.with_name(stem.name+'-independent.json')
            rc = run('full-partner-singleton-independent-generic.py', ['--certificate', candidate, '--point', POINT,
                     '--output', receipt], stem.with_name(stem.name+'-independent.log'), 600-(time.monotonic()-start))
            record['independent_returncode'] = rc
            if rc == 0:
                accepted = json.loads(receipt.read_text())
                record.update(status=accepted['status'], independent_sha256=sha(receipt),
                              independent_path=str(receipt.relative_to(ROOT)))
                if 'approximate_lattice_scaled_error' in accepted:
                    record['lattice_scaled_error'] = accepted['approximate_lattice_scaled_error']
            else:
                record['status'] = 'INDEPENDENT_REPLAY_FAILED'
        summary['records'].append(record)
        output.write_text(json.dumps(summary, indent=2)+'\n'); print(json.dumps(record), flush=True)
        if record['status'] == 'PASS_EXACT_CONDITIONAL_RANK_CUT':
            summary['status'] = 'EXACT_RANK_CUT_FOUND_STOPPED'; break
    accepted_statuses = {'PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES', 'PASS_EXACT_SINGLETON_CONDITIONAL_MATROID_MEMBERSHIP'}
    summary['anchors_passed_all_ranks'] = sum(r['status'] in accepted_statuses for r in summary['records'])
    if summary['status'] != 'EXACT_RANK_CUT_FOUND_STOPPED':
        summary['status'] = 'ALL_REMAINING29_SINGLETON_CROSS_RANK_LAWS_CERTIFIED' if summary['anchors_passed_all_ranks'] == 29 else 'BOUNDED_COHORT_NOT_COMPLETE'
    summary.update(elapsed_seconds=time.monotonic()-start, anchors_completed=len(summary['records']))
    assert all(sha(R/name) == digest for name, digest in frozen['source_hashes'].items())
    output.write_text(json.dumps(summary, indent=2)+'\n')
    print(json.dumps({k: summary[k] for k in ('status', 'anchors_passed_all_ranks', 'anchors_completed', 'elapsed_seconds')}))


if __name__ == '__main__':
    main()
