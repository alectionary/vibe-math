#!/usr/bin/env python3
"""Replay every source and SAT-proof dependency of a strategy cover.

Run from a clean checkout. Outputs go to a new directory, preserving all
immutable canonical receipts. A hash-binding check alone is not a proof replay.
"""
from pathlib import Path
import argparse
import concurrent.futures
import hashlib
import json
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--cover', type=Path, default=ROOT/'strategy-results/cover-411.json')
    p.add_argument('--drat-trim', type=Path, required=True)
    p.add_argument('--output-directory', type=Path, required=True)
    p.add_argument('--workers', type=int, default=2)
    a = p.parse_args()
    assert 1 <= a.workers <= 4
    a.output_directory.mkdir(parents=True, exist_ok=False)
    tasks = []
    seen = set()

    def visit(path):
        path = path.resolve()
        assert path not in seen
        seen.add(path)
        d = json.loads(path.read_text())
        if 'parent_cover_file' in d:
            visit(path.parent/d['parent_cover_file'])
            for item in d['accepted_anchor_proofs']:
                tasks.append((path.parent/item['metadata_file'],
                              path.parent/item['replay_file'],
                              'verify_kept_anchor_domain_signature_long.py'))
        else:
            assert d['new_case_count'] == 417
            tasks.append((ROOT/'algebraic-results/exchange/chain.json',
                          path.parent/d['parent_replay_file'],
                          'verify_cover_exchanges.py'))
            tasks.append((ROOT/'strategy-results/closure-cover-extension.json',
                          path.parent/d['new_conditional_replay_file'],
                          'verify_adaptive_rank_signature.py'))

    visit(a.cover)
    start = time.monotonic()

    def replay(task):
        source, canonical, script = task
        output = a.output_directory/(source.stem+'-fresh.json')
        log = output.with_suffix('.log')
        flag = '--chain' if script == 'verify_cover_exchanges.py' else '--certificate'
        cmd = [sys.executable, str(ROOT/script), flag, str(source),
               '--drat-trim', str(a.drat_trim), '--output', str(output)]
        began = time.monotonic()
        with log.open('w') as stream:
            completed = subprocess.run(cmd, stdout=stream, stderr=subprocess.STDOUT,
                                       timeout=1200)
        assert completed.returncode == 0, str(log)
        fresh = json.loads(output.read_text())
        old = json.loads(canonical.read_text())
        assert fresh['status'] == old['status'] == 'PASS'
        fields = ['input_sha256', 'proof_sha256', 'answer', 'new_case_count',
                  'base_chain_fully_replayed', 'new_anchored_proofs_checked',
                  'physical_pairings_rebuilt', 'old_rank_certificates_replayed',
                  'domain_signature_restriction_checked', 'new_cuts_checked',
                  'signature_circuits_checked', 'physical_forced_coloop_covectors_checked']
        compared = [k for k in fields if k in old]
        for k in compared:
            assert fresh[k] == old[k], (source.name, k)
        if old.get('answer') is False:
            assert fresh['proof_status'].startswith('DRAT_PASS')
        record = {'status': 'PASS', 'source': str(source.relative_to(ROOT)),
                  'source_sha256': sha(source), 'consumer': script,
                  'consumer_sha256': sha(ROOT/script),
                  'canonical_receipt': str(canonical.relative_to(ROOT)),
                  'canonical_receipt_sha256': sha(canonical),
                  'fresh_receipt': output.name, 'fresh_receipt_sha256': sha(output),
                  'fields_compared': compared, 'seconds': time.monotonic()-began}
        print(json.dumps(record), flush=True)
        return record

    with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers) as pool:
        records = list(pool.map(replay, tasks))
    from verify_strategy_cover_union import check_cover
    result = check_cover(a.cover)
    result.pop('retained')
    git = subprocess.check_output(['git', '-C', str(ROOT), 'rev-parse', 'HEAD'], text=True).strip()
    out = {'status': 'PASS', 'source_C16_answered': False, 'git_revision': git,
           'python': sys.version, 'drat_trim_sha256': sha(a.drat_trim),
           'cover_sha256': sha(a.cover), 'all_recursive_source_and_DRAT_replays': True,
           'records': records, 'cover': result, 'elapsed_seconds': time.monotonic()-start,
           'scope': 'Fresh source reconstruction and ordinary DRAT replay for every dependency of the sufficient cover; no full source anchor is excluded.'}
    (a.output_directory/'manifest.json').write_text(json.dumps(out, indent=2)+'\n')
    print('PASS: fully replayed sufficient cover', result['case_count'], flush=True)


if __name__ == '__main__':
    main()
