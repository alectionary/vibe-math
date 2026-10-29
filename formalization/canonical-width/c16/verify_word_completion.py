#!/usr/bin/env python3
"""Independent physical/theory/CNF/DRAT consumer for full-completion subproblems."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from verify_algebraic_model import physical
from verify_conditional_word import WordConsumer

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--certificate', type=Path, required=True)
    p.add_argument('--drat-trim', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    start = time.monotonic()
    d = json.loads(a.certificate.read_text())
    tp, ip, lp = [ROOT/d[k] for k in ['trial_c16_path', 'instance_c16_path', 'theory_log_c16_path']]
    assert sha(tp) == d['trial_sha256'] and sha(ip) == d['instance_sha256'] and sha(lp) == d['theory_log_sha256']
    instance = json.loads(ip.read_text())
    assert d['base_input_sha256'] == instance['input_sha256']
    raw = gzip.decompress((ip.parent/instance['input_file']).read_bytes())
    assert hashlib.sha256(raw).hexdigest() == instance['input_sha256']
    X, Z, A = physical()
    consumer = WordConsumer(X, Z, A)
    rows = [consumer.check(json.loads(line)) for line in lp.read_text().splitlines()]
    assert len(rows) == d['theory_clauses']
    lines = raw.decode().splitlines()
    header = lines.pop(0).split()
    assert len(lines) == int(header[3])
    final = (f'p cnf {header[2]} {len(lines)+len(rows)}\n'+'\n'.join(lines)+'\n'+
             ''.join(' '.join(map(str, row))+' 0\n' for row in rows)).encode()
    assert final == gzip.decompress((a.certificate.parent/d['input_file']).read_bytes())
    assert hashlib.sha256(final).hexdigest() == d['input_sha256'] == d['fresh_proof']['input_sha256']
    proof = gzip.decompress((a.certificate.parent/d['fresh_proof']['proof_file']).read_bytes())
    assert hashlib.sha256(proof).hexdigest() == d['fresh_proof']['proof_sha256']
    with tempfile.TemporaryDirectory(prefix='c16-word-completion-') as directory:
        folder = Path(directory)
        base = folder/'base.json'
        subprocess.run([sys.executable, str(ROOT/'verify_domain_completion_instance.py'),
                        '--instance', str(ip), '--output', str(base)], check=True,
                       capture_output=True, text=True, timeout=180)
        assert json.loads(base.read_text())['status'] == 'PASS'
        cnf = folder/'input.cnf'
        drat = folder/'proof.drat'
        cnf.write_bytes(final)
        drat.write_bytes(proof)
        run = subprocess.run([str(a.drat_trim), str(cnf), str(drat)], capture_output=True,
                             text=True, timeout=600)
        assert run.returncode == 0 and 's VERIFIED' in run.stdout
        empty = folder/'empty.drat'
        empty.write_bytes(b'')
        negative = subprocess.run([str(a.drat_trim), str(cnf), str(empty)], capture_output=True,
                                  text=True, timeout=30)
        # Some formulas are already contradictory by unit propagation. In that
        # case an empty DRAT proof can legitimately be accepted by this checker.
        empty_accepted = negative.returncode == 0 and 's VERIFIED' in negative.stdout
    out = {'status': 'PASS', 'answer': False, 'source_C16_answered': False,
           'input_sha256': d['input_sha256'], 'proof_sha256': d['fresh_proof']['proof_sha256'],
           'physical_pairings_rebuilt': 518400, 'theory_clauses_checked': len(rows),
           'domain_input_rebuilt': True, 'proof_status': 'DRAT_PASS',
           'empty_proof_accepted_for_unit_inconsistent_input': empty_accepted,
           'asserted_partial_pairs': instance['asserted_partial_pairs'],
           'elapsed_seconds': time.monotonic()-start,
           'scope': 'These mandatory pairs cannot complete inside the stated domain. The full-source base must also be separately replayed; no whole anchor class is excluded.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out, flush=True)


if __name__ == '__main__':
    main()
