#!/usr/bin/env python3
"""Freeze the complete orbit40 singleton search, exactLP, pricing and terminal proof closure."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
import ast
import gzip
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BASE = 'two-basis-results/owner-flow-capacity-zero-face-inventory.json'
OUT = 'two-basis-results/singleton-global-point22-o40-complete-inventory.json'

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    assert not (ROOT/OUT).exists()
    base = json.loads((ROOT/BASE).read_text())
    assert not base['binding_mismatches'] and not base['missing_bound_files']
    inherited = base['files']
    names = set()
    for directory, _, files in os.walk(ROOT):
        names.update(str((Path(directory)/name).relative_to(ROOT)) for name in files)
    pending = [BASE, str(Path(__file__).relative_to(ROOT)),
               'singleton_global_point22_o40.md', 'singleton_global_point22_o40_membership.md',
               'run_singleton_exact_column_gate.py', 'export_singleton_cg_terminal.py',
               'two-basis-results/singleton-exact-cg-independent-review.json']
    for pattern in ('singleton-global-point22-o40*', 'singleton-archive-point22-o40*', 'singleton-cg-point22-o40*'):
        pending.extend(str(p.relative_to(ROOT)) for p in (ROOT/'two-basis-results').glob(pattern))
    terminal=json.loads((ROOT/'two-basis-results/singleton-cg-point22-o40-terminal-independent.json').read_text())
    assert terminal['status']=='PASS_DIRECT_TERMINAL_SINGLETON_BASIS_MIXTURE_REVIEW' and terminal['exact_marginals']==720 and terminal['anchor_orbit']==40
    seen, added, checked, external = set(), {}, set(), {}

    def local(value):
        if not isinstance(value, str) or len(value) > 4096 or '\n' in value:
            return None
        p = Path(os.path.normpath(value))
        if p.is_absolute():
            if p.is_relative_to(ROOT): value = str(p.relative_to(ROOT))
            else: return None
        else: value = str(p)
        return value if value in names else None

    def enqueue(value, expected=None):
        name = local(value)
        if name:
            if expected is not None:
                assert sha(ROOT/name) == expected, name
                checked.add(name)
            pending.append(name)
        elif isinstance(value, str) and value.startswith('/') and len(value) < 4096:
            p = Path(value)
            if p.is_file():
                digest = sha(p)
                if expected is not None: assert digest == expected
                external[value] = dict(sha256=digest, bytes=p.stat().st_size)

    def walk(value):
        if isinstance(value, dict):
            for key, item in value.items():
                ishash = isinstance(item, str) and len(item) == 64 and all(c in '0123456789abcdef' for c in item)
                enqueue(key, item if ishash else None)
                if isinstance(key, str) and key.endswith('_sha256'):
                    partner = value.get(key[:-7])
                    if isinstance(partner, str): enqueue(partner, item)
                walk(item)
        elif isinstance(value, list):
            for item in value: walk(item)
        else: enqueue(value)

    while pending:
        name = pending.pop()
        if name in seen: continue
        seen.add(name)
        p = ROOT/name
        digest = sha(p)
        if name in inherited:
            assert inherited[name]['sha256'] == digest, name
            checked.add(name)
            continue
        added[name] = dict(sha256=digest, bytes=p.stat().st_size)
        if name == BASE: continue  # Immutable inherited closure is bound above.
        if name.endswith('.json') or name.endswith('.json.gz'):
            walk(json.loads(gzip.decompress(p.read_bytes()) if name.endswith('.gz') else p.read_bytes()))
        if name.endswith('.py'):
            for node in ast.walk(ast.parse(p.read_text())):
                if isinstance(node, ast.Constant): enqueue(node.value)
                modules = ([node.module] if isinstance(node, ast.ImportFrom) else
                           [v.name for v in node.names] if isinstance(node, ast.Import) else [])
                for module in modules:
                    if module: enqueue(module.split('.')[0]+'.py')
    output = dict(status='FROZEN_COMPLETE_ORBIT40_SELECTED_T_MEMBERSHIP_CLOSURE',
                  inherited_inventory=BASE, inherited_inventory_sha256=sha(ROOT/BASE),
                  inherited_file_count=len(inherited), additional_files=added,
                  additional_file_count=len(added),
                  additional_bytes=sum(v['bytes'] for v in added.values()),
                  existing_dependencies_rechecked=sorted(checked),
                  external_file_dependencies=external, nice=19,
                  source_C16_answered=False, exact_selected_T_membership=True, anchor_orbit=40,
                  terminal_receipt='two-basis-results/singleton-cg-point22-o40-terminal-independent.json',
                  terminal_receipt_sha256=sha(ROOT/'two-basis-results/singleton-cg-point22-o40-terminal-independent.json'),
                  positive_zero_bases=terminal['zero_bases'], unit_probabilities=terminal['unit_probabilities'],
                  physical_full_frame=False, absent_conditioning_proved=False,
                  initial_partial_state_and_archive_infeasibility_preserved=True,
                  producer_sha256=sha(__file__))
    (ROOT/OUT).write_text(json.dumps(output, indent=2)+'\n')
    print(json.dumps({k:v for k,v in output.items() if k not in
                      ('additional_files','existing_dependencies_rechecked','external_file_dependencies')}))

if __name__ == '__main__': main()
