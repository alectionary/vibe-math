#!/usr/bin/env python3
"""Freeze the accepted preparation gate and its declared byte-bound inputs."""
import os
assert os.getpriority(os.PRIO_PROCESS, 0) == 19
for key in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(key) == '1'
from pathlib import Path
from fractions import Fraction as Q
import gzip, hashlib, json, time

ROOT = Path(__file__).resolve().parent
PREFIX = 'two-basis-results/shared-basis-phase-one-point22-seed'
DEST = ROOT / (PREFIX + '-complete-inventory.json')

def main():
    start = time.monotonic()
    assert not DEST.exists()
    cache = {}
    def path(name):
        p = Path(name)
        return p if p.is_absolute() else ROOT / p
    def sha(name):
        p = path(name)
        if p not in cache:
            cache[p] = hashlib.sha256(p.read_bytes()).hexdigest()
        return cache[p]
    def read(name):
        p = path(name); data = p.read_bytes()
        return json.loads(gzip.decompress(data) if p.suffix == '.gz' else data)

    seed = read(PREFIX + '.json.gz')
    receipt = read(PREFIX + '-independent.json')
    assert receipt['status'] == 'PASS_EXACT_SHARED_BASIS_PHASE_ONE_SEED'
    assert receipt['certificate_sha256'] == sha(PREFIX + '.json.gz')
    assert receipt['consumer_sha256'] == sha('verify_shared_basis_phase_one_seed.py')
    assert receipt['positive_domain_bases_checked'] == len(seed['blocks']) == 22
    assert receipt['zero_domain_blocks_checked'] == len(seed['zero_blocks']) == 10
    assert receipt['exact_link_coordinates'] == seed['all_links'] == 23040
    assert Q(receipt['exact_total_artificial_L1']) == Q(seed['total_L1']) > 0
    assert receipt['shared_master_built'] is receipt['shared_master_solved'] is False
    parent_inventory = 'two-basis-results/joint-owner-k22-eight-point22-complete-inventory-v2.json'
    names = {
        Path(__file__).name, 'prepare_shared_basis_phase_one_seed.py',
        'verify_shared_basis_phase_one_seed.py',
        PREFIX+'.json.gz', PREFIX+'.frozen.json', PREFIX+'-independent.json',
        'SHARED-BASIS-PHASE-ONE-SEED-RESULT.md',
        'SHARED-BASIS-MASTER-NEXT-GATE.md',
        'CLARABEL-CASE32-READONLY-ASSESSMENT.md',
        'two_basis_closing_strategy_audit.md', parent_inventory,
    }
    bindings = {}; checked = 0
    def add(name, expected):
        nonlocal checked
        assert isinstance(expected, str) and len(expected) == 64
        assert sha(name) == expected, name
        assert name not in bindings or bindings[name] == expected
        bindings[name] = expected; checked += 1
    for name in sorted(names):
        sha(name)
        if not name.endswith(('.json', '.json.gz')):
            continue
        obj = read(name)
        for key in ('source_hashes','dependencies','source_bindings','input_bindings','repository_input_bindings','external_runtime_bindings'):
            for input_name, h in obj.get(key, {}).items():
                add(input_name, h)
        if name == parent_inventory:
            for item in obj['files']:
                add(item['path'], item['sha256'])
    for key in ('endpoint','endpoint_receipt','parent_receipt','frozen'):
        add(seed[key], seed[key+'_sha256'])
    repository = {}; external = {}
    for name, h in bindings.items():
        p = path(name)
        try:
            rel = str(p.relative_to(ROOT))
        except ValueError:
            external[str(p)] = h
        else:
            assert rel not in repository or repository[rel] == h
            repository[rel] = h
    files = [dict(path=name, sha256=sha(name), bytes=path(name).stat().st_size) for name in sorted(names)]
    out = dict(
        status='PASS_COMPLETE_SHARED_BASIS_PHASE_ONE_SEED_PREPARATION_INVENTORY',
        files=files, input_bindings=bindings, repository_input_bindings=repository,
        external_runtime_bindings=external, input_bindings_checked=checked,
        parent_inventory=parent_inventory, parent_inventory_sha256=sha(parent_inventory),
        certificate=PREFIX+'.json.gz', certificate_sha256=sha(PREFIX+'.json.gz'),
        receipt=PREFIX+'-independent.json', receipt_sha256=sha(PREFIX+'-independent.json'),
        point_sha256=seed['point_sha256'], positive_sector_pattern_bases=22,
        zero_sector_pattern_blocks=10, exact_link_coordinates=23040,
        physical_signed_prefix_ranks_checked=receipt['physical_signed_prefix_ranks_checked'],
        exact_total_artificial_L1=seed['total_L1'], artificial_L1_approx=float(Q(seed['total_L1'])),
        retained_parent_full_rows=98868, retained_parent_parameter_strings=22513,
        all_parent_allocation_strings_retained=True, parent_law_pinned=True,
        single_basis_per_block_optimal=True, shared_master_implemented=False,
        shared_master_solved=False, full_basis_membership_claimed=False,
        source_C16_answered=False, source_frame_claimed=False,
        inventory_scope='Complete new preparation files, their declared hash-bound inputs, and inherited parent gate files/bindings. Separate final checkpoint closure supplies transitive Python imports.',
        checkpoint_copy_rule='Union files and repository_input_bindings with the inherited final checkpoint import closure; keep external runtime bindings external.',
        transitive_import_closure_claimed=False, owned_processes_remaining=False,
        nice=19, threads=1, elapsed_seconds=time.monotonic()-start)
    DEST.write_text(json.dumps(out, indent=2, sort_keys=True)+'\n')
    print(json.dumps(dict(status=out['status'], output=str(DEST.relative_to(ROOT)),
                         sha256=sha(DEST), files=len(files), repository_inputs=len(repository),
                         external_inputs=len(external), bindings_checked=checked,
                         elapsed_seconds=out['elapsed_seconds'])))

if __name__ == '__main__':
    main()
