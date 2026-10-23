"""Verify the early-entry continuation without generating new scientific data.

Historical manifests belong to their publication commits. This manifest binds
the new documents, proofs, frozen analyses and independent validation records.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, math, re, runpy, subprocess, sys

ROOT = Path(__file__).resolve().parents[1]
HERE = ROOT / 'formalization/cyclic-lifts'
SEARCH = HERE / 'search'
MANIFEST = HERE / 'entry-verification.json'
DOCUMENTS = {
    'README.md', 'PUBLICATION-STATUS.md', 'formalization/cyclic-lifts/README.md',
    'formalization/cyclic-lifts/LOOP-HOLDOUT.md',
    'formalization/cyclic-lifts/search/report_loop_holdout.py',
}

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def read(name):
    return json.loads((SEARCH / name).read_text())

def historical(commit, rel):
    packet = json.loads(subprocess.check_output(
        ['git', 'show', commit + ':' + rel], cwd=ROOT, text=True))
    for path, digest in packet['sha256'].items():
        raw = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)
        assert hashlib.sha256(raw).hexdigest() == digest, (commit, path)
        if path not in DOCUMENTS:
            assert sha(ROOT / path) == digest, ('changed prior artifact', path)
    return len(packet['sha256'])

def verify():
    # This checks old scientific inputs and proof records, without requiring
    # current documentation to match an older publication manifest.
    runpy.run_path(str(ROOT / 'scripts/verify_cyclic_loop_artifacts.py'))['verify']()
    history = {
        '888beeb': historical('888beeb', 'formalization/cyclic-lifts/loop-holdout-verification.json'),
        '223f58d': historical('223f58d', 'formalization/cyclic-lifts/loop-literature-verification.json'),
    }
    for name, prefix in [('entry-dynamics-selection.json', ROOT),
                         ('entry-initial-selection.json', SEARCH),
                         ('entry-confirm-selection.json', ROOT)]:
        selection = read(name)
        for rel, digest in selection['sha256'].items():
            assert sha(prefix / rel) == digest, (name, rel)
    for selection, result in [('entry-dynamics-selection.json', 'entry-dynamics-development.json'),
                              ('entry-initial-selection.json', 'entry-initial-development.json')]:
        assert read(selection)['development_sha256'] == sha(SEARCH / result)
    confirmation = read('entry-confirm-results.json')
    assert confirmation['selection_sha256'] == sha(SEARCH / 'entry-confirm-selection.json')
    assert confirmation['new_independent_noise_patterns'] == 2_000_000
    assert confirmation['primary_decoder_executions'] == 4_000_000
    assert confirmation['stock_controls'] == 128
    expected_status = {
        'entry-dynamics-validation.json': 'entry_diagnostics_independently_verified',
        'entry-expectation-validation.json': 'exact_expectation_independently_matches_physical_bit_convolution',
        'entry-confirm-validation.json': 'fresh_entry_confirmation_independently_verified',
        'entry-progress-validation.json': 'entry_progress_and_graph_tables_independently_verified',
    }
    for name, status in expected_status.items():
        assert read(name)['status'] == status, name
    assert read('entry-confirm-validation.json')['independent_patterns_regenerated'] == 2_000_000
    assert read('entry-confirm-validation.json')['terminal_outcomes_reconstructed'] == 4_000_000
    assert read('entry-confirm-validation.json')['independent_full_trajectory_controls'] == 48
    assert read('entry-progress-validation.json')['paired_feature_rows_checked'] == 4_000_000
    assert read('entry-expectation-validation.json')['stratum_expectations_verified'] == 208
    bias = read('entry-bit-bias.json')
    assert bias['status'] == 'exact_first_bit_error_bias_by_independent_physical_convolution'
    assert bias['vertices_checked'] == 24 and bias['new_noise_patterns'] == 0
    for record in bias['records']:
        assert record['exact_expected_total_bit_error_gap'] == [19615473454422387900276592128, 227373675443232059478759765625]
        assert all(v['exact_gap'] == [1634622787868532325023049344, 227373675443232059478759765625] for v in record['vertices'])
    assert read('entry-soft-controls.json')['status'] == 'exploratory_soft_only_baseline_control'
    subprocess.run([sys.executable, '-B', str(SEARCH / 'entry_delayed_entry.py'), '--verify'], cwd=ROOT, check=True)
    bernstein = read('entry-bernstein.json')
    assert bernstein['source_sha256'] == sha(SEARCH / 'entry-confirm-results.json')
    assert bernstein['one_sided_events'] == 8 and bernstein['new_noise_patterns'] == 0
    for record in bernstein['records']:
        raw = next(x for x in confirmation['records'] if x['design'] == record['design'])
        radius = 0
        for labels in [['00'], ['01', '10', '11']]:
            groups = [raw['groups'][key] for key in labels]
            n = sum(g['trials'] for g in groups)
            total = sum(g['lost'] - g['gained'] for g in groups)
            squares = sum(g['lost'] + g['gained'] for g in groups)
            variance = (squares - total * total / n) / (n - 1)
            radius += math.sqrt(2 * variance * math.log(320) / n) + 14 * math.log(320) / (3 * (n - 1))
        d = raw['interaction']['difference']
        assert all(math.isclose(a, b, abs_tol=1e-15) for a, b in zip([d-radius, d+radius], record['simultaneous_95_interval']))
        assert record['simultaneous_95_interval'][0] > 0
    stock = read('entry-stock-replay-validation.json')
    assert stock['decoder_runs_checked'] == 4_000_000
    assert stock['status'] == 'every_fresh_terminal_outcome_reproduced_by_unmodified_decoder'
    builds = read('entry-lean-build-results.json')
    assert builds['status'] == 'all_entry_modules_passed'
    assert len(builds['modules']) == 11
    for record in builds['modules']:
        assert record['status'] == 'passed'
        assert sha(ROOT / record['source']) == record['source_sha256'], record['module']
        assert sha(ROOT / record['log']) == record['log_sha256'], record['module']
        source = (ROOT / record['log']).read_text()
        assert 'error:' not in source and 'sorryAx' not in source, record['module']
    allowed = {'propext', 'Classical.choice', 'Quot.sound'}
    audit = (HERE / 'entry-final-axioms.log').read_text()
    groups = re.findall(r'depends on axioms:\s*\[([^]]*)\]', audit, re.S)
    assert len(groups) >= 20
    for group in groups:
        assert {x.strip() for x in group.split(',')} <= allowed, group
    for path in (ROOT / 'formalization/dyadic-rank').glob('CyclicDecoderEntry*.lean'):
        assert not re.search(r'\b(?:sorry|admit|native_decide)\b|^\s*axiom\s|skipKernelTC',
                             path.read_text(), re.M), path.name
    # Independent arithmetic checks on the report's exhaustive paired partition.
    progress = read('entry-progress-results.json')['records']
    for r in confirmation['records']:
        p = next(x for x in progress if x['mode'] == 'confirmation' and x['design'] == r['design'])
        net = sum(v['merged_syndrome'] - v['original_syndrome'] for v in r['groups'].values())
        assert sum(v['trials'] for v in p['hard_groups'].values()) == 1_000_000
        assert sum(v['net'] for v in p['hard_groups'].values()) == net
        assert net == {'previous_best': 985, 'minimum_4': 1210}[r['design']]
        assert p['hard_groups']['soft_only']['net'] == {'previous_best': 451, 'minimum_4': 571}[r['design']]
        assert r['interaction']['bonferroni_simultaneous_95_interval'][0] > 0
    print('Historical snapshots, frozen inputs, numerical checks and Lean chain PASS', flush=True)
    return history, builds

def owned_paths():
    paths = set(subprocess.check_output(['git', 'diff', '--name-only'], cwd=ROOT, text=True).splitlines())
    paths.update(subprocess.check_output(['git', 'ls-files', '--others', '--exclude-standard'], cwd=ROOT, text=True).splitlines())
    return sorted(rel for rel in paths if ROOT / rel != MANIFEST
                  and rel != 'formalization/cyclic-lifts/entry-artifact-checks.log'
                  and (rel in DOCUMENTS or rel.startswith((
                      'formalization/cyclic-lifts/ENTRY-', 'formalization/cyclic-lifts/entry-',
                      'formalization/cyclic-lifts/search/entry',
                      'formalization/dyadic-rank/CyclicDecoderEntry',
                      'scripts/check_cyclic_entry_', 'scripts/replay_cyclic_entry_',
                      'scripts/validate_cyclic_entry_', 'scripts/verify_cyclic_entry_'))))

def content_checks(paths):
    for rel in paths:
        path = ROOT / rel
        source = path.read_text()
        assert not re.search(r'/(?:Users|home)/|[A-Za-z0-9._%+-]+@(?:gmail|outlook|icloud)\.com', source, re.I), rel
        if path.suffix == '.py': compile(source, rel, 'exec')
        if path.suffix == '.json': json.loads(source)
        if path.suffix == '.md':
            for link in re.findall(r'\]\(([^)]+)\)', source):
                if '://' not in link and not link.startswith('#'):
                    target = path.parent / link.split('#')[0]
                    if target == MANIFEST and '--write-manifest' in sys.argv: continue
                    assert target.exists(), (rel, link)
    subprocess.run(['git', 'diff', '--check'], cwd=ROOT, check=True)
    print('Artifact syntax, privacy, Markdown links and whitespace PASS', flush=True)

def run():
    history, builds = verify()
    if '--write-manifest' in sys.argv:
        paths = owned_paths()
        content_checks(paths)
        packet = dict(
            checked_at_utc=datetime.now(timezone.utc).isoformat(),
            status='entry_dynamics_frozen_confirmation_and_lean_proofs_verified',
            research_window=dict(started_at_utc='2026-10-23T21:59:26Z', deadline_utc='2026-10-23T22:59:26Z'),
            previous_public_commit=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
            historical_artifact_counts=history,
            new_independent_errors=2_000_000, primary_decodes=4_000_000,
            full_stock_decodes_independently_replayed=4_000_000,
            independent_full_trajectory_controls=48,
            expectation_stratum_checks=208,
            old_and_new_feature_rows_checked=4_000_000,
            primary_simultaneous_interactions_positive=2,
            small_support_countercheck_inputs=17_352,
            new_completed_inventory_targets=0,
            lean_toolchain=(ROOT / 'formalization/dyadic-rank/lean-toolchain').read_text().strip(),
            proof_checks=builds['modules'],
            scope='Exact initial onset, actual-graph locality and possible propagation, finite gate probabilities, and complete retained-example entry/stopping proofs. Replicated raw activity interaction attenuates under secondary hardness controls. Descriptive soft-only net counts are not failure certificates or causal mediation; aggregate explanation remains incomplete.',
            sha256={rel: sha(ROOT / rel) for rel in paths})
        MANIFEST.write_text(json.dumps(packet, indent=2) + '\n')
        print('Current entry verification manifest written', flush=True)
    else:
        packet = json.loads(MANIFEST.read_text())
        content_checks(packet['sha256'])
        for rel, digest in packet['sha256'].items():
            assert sha(ROOT / rel) == digest, rel
        print('All current manifest hashes PASS', flush=True)

if __name__ == '__main__': run()
