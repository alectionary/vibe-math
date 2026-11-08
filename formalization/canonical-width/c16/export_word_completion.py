#!/usr/bin/env python3
"""Export a full-completion trial plus its recorded theory clauses to plain CNF."""
from pathlib import Path
import argparse
import gzip
import hashlib
import json

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--trial', type=Path, required=True)
    p.add_argument('--output', type=Path, required=True)
    a = p.parse_args()
    trial = json.loads(a.trial.read_text())
    assert trial['answer'] is False
    instance_path = ROOT/trial['instance_c16_path']
    instance = json.loads(instance_path.read_text())
    raw = gzip.decompress((instance_path.parent/instance['input_file']).read_bytes())
    assert hashlib.sha256(raw).hexdigest() == trial['input_sha256'] == instance['input_sha256']
    log = a.trial.parent/trial['lemma_file']
    assert sha(log) == trial['lemma_file_sha256']
    rows = [json.loads(line)['clause'] for line in log.read_text().splitlines()]
    lines = raw.decode().splitlines()
    header = lines.pop(0).split()
    assert len(lines) == int(header[3])
    final = (f'p cnf {header[2]} {len(lines)+len(rows)}\n'+'\n'.join(lines)+'\n'+
             ''.join(' '.join(map(str, row))+' 0\n' for row in rows)).encode()
    dest = a.output.with_suffix('.cnf.gz')
    dest.write_bytes(gzip.compress(final, mtime=0))
    out = {'status': 'EXPORTED_REQUIRES_INDEPENDENT_REPLAY', 'answer': False,
           'source_C16_answered': False, 'trial_c16_path': str(a.trial.resolve().relative_to(ROOT)),
           'trial_sha256': sha(a.trial), 'instance_c16_path': trial['instance_c16_path'],
           'instance_sha256': sha(instance_path), 'base_input_sha256': instance['input_sha256'],
           'theory_log_c16_path': str(log.resolve().relative_to(ROOT)), 'theory_log_sha256': sha(log),
           'theory_clauses': len(rows), 'input_file': dest.name,
           'input_sha256': hashlib.sha256(final).hexdigest(),
           'scope': 'Conditional full128-completion only; does not exclude the entire selected-pair class.'}
    a.output.write_text(json.dumps(out, indent=2)+'\n')


if __name__ == '__main__':
    main()
