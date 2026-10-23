"""Validate P11 artifact provenance and independent finite regressions.

Use --recheck-lean for fresh kernel checking; the default audits the saved log.
The finite search is separately reproducible with search/scan.py.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import re
import subprocess
import sys

sys.dont_write_bytecode = True
R = Path(__file__).resolve().parent.parent
P = R / 'formalization/dyadic-forbidden'
L = R / 'formalization/dyadic-rank'
args = argparse.ArgumentParser(description=__doc__)
args.add_argument('--recheck-lean', action='store_true')
options = args.parse_args()
v = json.loads((P / 'verification.json').read_text())
assert v['lean_exit_code'] == 0
assert v['constructive_procedure_complete']
assert not v['authors_routine_equivalence_proved']
assert v['source_target_marked_fully_resolved']
assert v['build_exit_code'] == 0
for name, sha in v['sha256'].items():
    assert hashlib.sha256((R / name).read_bytes()).hexdigest() == sha, name

source = (L / 'DyadicForbidden.lean').read_text()
code = re.sub(r'/\-.*?\-/', '', source, flags=re.S)
code = re.sub(r'--[^\n]*', '', code)
assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe)\b', code)
names = {'DyadicForbidden.' + n for n in re.findall(
    r'^(?:@\[[^\n]*\]\s*)?theorem\s+([\w.\']+)', code, re.M)}
audited = {'DyadicForbidden.' + n for n in re.findall(r'^#print axioms (\S+)', code, re.M)}
assert names == audited == set(v['declaration_axioms'])
assert len(names) == v['audited_declarations'] == 23

def check_log(log, expected=None):
    assert not re.search(r'\b(error|warning|sorryAx)\b', log)
    reports = {}
    for name, axioms, empty in re.findall(
        r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|(does not depend on any axioms))", log):
        reports[name] = [] if empty else [a.strip() for a in axioms.split(',') if a.strip()]
    assert reports == (v['declaration_axioms'] if expected is None else expected)
    assert all(set(a) <= {'propext', 'Classical.choice', 'Quot.sound'} for a in reports.values())

check_log((P / 'lean-checks.log').read_text())
if options.recheck_lean:
    result = subprocess.run(['lake', '-f', 'lakefile-forbidden.toml', 'env', 'lean',
                             '-o', '.lake/build/lib/lean/DyadicForbidden.olean',
                             'DyadicForbidden.lean'], cwd=L, capture_output=True, text=True)
    assert result.returncode == 0, result.stdout + result.stderr
    check_log(result.stdout + result.stderr)

comparison = v['source_comparison']
assert comparison['lean_exit_code'] == 0
assert comparison['general_tbc_checker_equivalence_verified']
assert comparison['source_cycle_contract_answered']
assert not comparison['authors_software_identity_verified']
assert comparison['literal_optimized_enumerator_bridge_in_lean']
extra_source = (L / 'DyadicForbiddenSource.lean').read_text()
extra_code = re.sub(r'/\-.*?\-/', '', extra_source, flags=re.S)
extra_code = re.sub(r'--[^\n]*', '', extra_code)
assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe)\b', extra_code)
extra_names = {'DyadicForbidden.' + n for n in re.findall(
    r'^(?:@\[[^\n]*\]\s*)?theorem\s+([\w.\']+)', extra_code, re.M)}
extra_audited = {'DyadicForbidden.' + n for n in re.findall(r'^#print axioms (\S+)', extra_code, re.M)}
assert extra_names == extra_audited == set(comparison['declaration_axioms'])
assert len(extra_names) == comparison['audited_declarations'] == 18
assert len(extra_names | names) == 41
check_log((P / 'source-lean-checks.log').read_text(), comparison['declaration_axioms'])
if options.recheck_lean:
    result = subprocess.run(['lake', '-f', 'lakefile-forbidden.toml', 'env', 'lean',
                             '-o', '.lake/build/lib/lean/DyadicForbiddenSource.olean',
                             'DyadicForbiddenSource.lean'], cwd=L, capture_output=True, text=True)
    assert result.returncode == 0, result.stdout + result.stderr
    check_log(result.stdout + result.stderr, comparison['declaration_axioms'])

def audit_module(filename, prefix, record, logname):
    text = (L / filename).read_text()
    stripped = re.sub(r'/\-.*?\-/', '', text, flags=re.S)
    stripped = re.sub(r'--[^\n]*', '', stripped)
    assert not re.search(r'\b(sorry|admit|sorryAx|native_decide|axiom|unsafe)\b', stripped)
    declarations = {prefix + n for n in re.findall(
        r'^(?:@\[[^\n]*\]\s*)?theorem\s+([\w.\']+)', stripped, re.M)}
    printed = {prefix + n for n in re.findall(r'^#print axioms (\S+)', stripped, re.M)}
    assert declarations == printed == set(record['declaration_axioms'])
    assert len(declarations) == record['audited_declarations']
    assert record['lean_exit_code'] == 0
    check_log((P / logname).read_text(), record['declaration_axioms'])
    if options.recheck_lean:
        command = ['lake', '-f', 'lakefile-forbidden.toml', 'env', 'lean']
        if not filename.endswith('Checks.lean'):
            command += ['-o', '.lake/build/lib/lean/' + filename.removesuffix('.lean') + '.olean']
        result = subprocess.run(command + [filename], cwd=L, capture_output=True, text=True)
        assert result.returncode == 0, result.stdout + result.stderr
        check_log(result.stdout + result.stderr, record['declaration_axioms'])
    return declarations

appendix = v['appendix_enumeration']
assert appendix['literal_optimized_enumerator_bridge_in_lean']
assert appendix['printed_row_classes'] == 21 and appendix['printed_half_path_sums'] == 42
appendix_names = audit_module('DyadicForbiddenAppendix.lean', 'DyadicForbidden.Appendix.',
                             appendix, 'appendix-lean-checks.log')
execution = v['execution_checks']
execution_names = audit_module('DyadicForbiddenAppendixChecks.lean', 'DyadicForbidden.AppendixChecks.',
                              execution, 'appendix-execution-checks.log')
assert len(appendix_names) == 49 and len(execution_names) == 2
assert len(names | extra_names | appendix_names) == v['audited_library_declarations'] == 90
assert len(names | extra_names | appendix_names | execution_names) == v['audited_declarations_total'] == 92
all_reports = dict(v['declaration_axioms'], **comparison['declaration_axioms'],
                   **appendix['declaration_axioms'], **execution['declaration_axioms'])
build_log = (P / 'build.log').read_text()
assert 'Build completed successfully' in build_log and '/Users/' not in build_log
check_log(build_log, all_reports)

# Check that the printed-order source data agree with the earlier certified
# row-class list. The compiler separately proves these identities in Lean.
appendix_text = (L / 'DyadicForbiddenAppendix.lean').read_text()
index_text = appendix_text.split('def PrintedIndex', 1)[1].split('def PrintedRows', 1)[0]
printed_index = list(map(int, re.search(r'!\[([\d,]+)\]', index_text).group(1).split(',')))
assert printed_index == [0,1,2,3,4,5,6,7,8,9,10,14,11,12,13,15,16,17,18,19,20]

spec = importlib.util.spec_from_file_location('dyadic_forbidden_scan', P / 'search/scan.py')
scan = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scan)
sys.path.insert(0, str(P / 'search'))
import source_compare
source_results = json.loads((P / 'search/source-results.json').read_text())
assert source_results['partial_arrays'] == 1043
assert source_results['candidate_label_threshold_checks'] == 21168
assert source_results['reconstructed_prefix_direct_mismatches'] == 0
assert source_results['diagnostic_forbidden'] == {'4':[0], '6':[0], '8':[0,1]}
results = json.loads((P / 'search/results.json').read_text())
assert scan.source_pattern_audit() == results['source_row_pattern_audit']
literal = source.split('def sourceRows', 1)[1].split('set_option', 1)[0]
lean_rows = [tuple(map(int, row.split(',')))
             for row in re.findall(r'!\[([0-3],[0-3],[0-3],[0-3])\]', literal)]
assert lean_rows == scan.SOURCE_ROWS
for name, positions in [('LeftTriple',(0,1,2)), ('RightTriple',(0,3,2))]:
    literal = appendix_text.split('def ' + name, 1)[1].split('theorem' if name == 'RightTriple' else 'def RightTriple', 1)[0]
    triples = [tuple(map(int, row.split(',')))
               for row in re.findall(r'!\[([0-3],[0-3],[0-3])\]', literal)]
    assert triples == [tuple(lean_rows[m][i] for i in positions) for m in printed_index]
assert results['partial_arrays'] == 1043
assert results['families'] == {'exhaustive_2x2':889, 'exhaustive_normalized_3x3':64,
                              'sampled_3x3_4x4':90}
assert results['candidate_label_bound_checks'] == 21168
assert results['complete_prefix_checker_mismatches'] == 0
assert results['bounds'] == [4, 6, 8]
for row in results['independent_exact_cycle_checks']:
    for length, expected in row['cycle_counts'].items():
        length = int(length)
        count = len(scan.exact_cycles_dfs(scan.graph(row['B'], row['ell']), length))
        assert count == expected
        assert count * length == len(scan.word_cycles(row['B'], length)) * (1 << row['ell'])
    girth = scan.girth(scan.graph(row['B'], row['ell']))
    for bound in (4,6,8):
        assert any(source_compare.source_presence(row['B'], k) for k in (4,6,8) if k <= bound) == (
            girth is not None and girth <= bound)
B, slot = [[0,0],[0,None]], (1,1)
assert scan.forbidden(B, slot, 1, 8) == ({0,1}, {0,1})
assert scan.odd_occurrence_rule(B, slot, 1, 8) == {0}
assert scan.girth(scan.graph(scan.replace(B, slot, 0), 1)) == 4
assert scan.girth(scan.graph(scan.replace(B, slot, 1), 1)) == 8
inventory = json.loads((R / 'literature/open-problems.json').read_text())
# Inventory schemas may wrap entries in a top-level object.
entries = inventory if isinstance(inventory, list) else inventory['entries']
target = next(row for row in entries if row['id'] == 'L-P11-forbidden')
assert target['verified_artifact']['source'].endswith('/DyadicForbiddenAppendix.lean')
assert target['lean_proof_status'] == 'verified_complete_lean_proof'
assert target['source_comparison']['cycle_contract_answered']
assert target['source_comparison']['full_source_specific_lean_coverage_promoted']
print('P11: 90 library declaration audits and two kernel execution checks; full literal appendix correspondence, build, source data and regressions pass.')
