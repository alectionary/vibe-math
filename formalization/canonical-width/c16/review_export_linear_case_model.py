#!/usr/bin/env python3
"""Mechanical, read-only review of the selected-case linear exporter."""
import ast
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def read(p):
    return json.loads(Path(p).read_text())


def dump(node):
    return ast.dump(node, include_attributes=False)


class Normalize(ast.NodeTransformer):
    def visit_Constant(self, node):
        if node.value == 'export_linear_case_model.py':
            return ast.copy_location(ast.Constant('case_floor_integer_lp_probe.py'), node)
        return node

    def visit_Assign(self, node):
        # These two additions only record offsets already used by pack().
        if len(node.targets) == 1:
            t = node.targets[0]
            if isinstance(t, ast.Name) and t.id == 'packed_offsets':
                assert isinstance(node.value, ast.Dict) and not node.value.keys
                return None
            if isinstance(t, ast.Subscript) and isinstance(t.value, ast.Name) and t.value.id == 'packed_offsets':
                assert dump(t.slice) == dump(ast.parse('variable.id', mode='eval').body)
                assert isinstance(node.value, ast.Name) and node.value.id == 'offset'
                return None
        return self.generic_visit(node)


def tree(path):
    t = ast.parse(Path(path).read_text())
    if isinstance(t.body[0], ast.Expr) and isinstance(t.body[0].value, ast.Constant):
        t.body.pop(0)
    return Normalize().visit(t)


def first_savez_prefix(body):
    for i, node in enumerate(body):
        if (isinstance(node, ast.Expr) and isinstance(node.value, ast.Call)
                and isinstance(node.value.func, ast.Attribute)
                and isinstance(node.value.func.value, ast.Name)
                and node.value.func.value.id == 'np'
                and node.value.func.attr == 'savez_compressed'):
            return body[:i + 1]
    raise AssertionError('No linear export boundary')


def main():
    output = ROOT/'two-basis-results/sourcecase323200-linear22-export-independent-review.json'
    assert not output.exists()
    paths = ['case_floor_integer_lp_probe.py', 'export_linear_case_model.py',
             'run_integer_case_followup_lp.py', 'run_export_linear_case_model.py',
             'review_export_linear_case_model.py', 'semantic_linear_case_rows.py',
             'verify_semantic_linear_case_dual.py',
             'coupling-results/sourcecase323200-linear22-frozen.json',
             'coupling-results/sourcecase323200-linear22-exit.json',
             'coupling-results/sourcecase323200-linear22.json',
             'two-basis-results/sourcecase323200-semantic22-independent.json']
    hashes = {p: sha(ROOT/p) for p in paths}
    old, new = [tree(ROOT/p) for p in paths[:2]]
    old_main = next(n for n in old.body if isinstance(n, ast.FunctionDef) and n.name == 'main')
    new_main = next(n for n in new.body if isinstance(n, ast.FunctionDef) and n.name == 'main')
    old_prefix, new_prefix = map(first_savez_prefix, [old_main.body, new_main.body])
    assert list(map(dump, old_prefix)) == list(map(dump, new_prefix))
    old_main.body = []
    new_main.body = []
    assert dump(old) == dump(new)
    assert dump(tree(ROOT/paths[2])) == dump(tree(ROOT/paths[3]))
    raw = ast.parse((ROOT/'export_linear_case_model.py').read_text())
    assert not any(isinstance(n, ast.Call) and isinstance(n.func, ast.Attribute)
                   and n.func.attr in ('run', 'solve', 'getDualRay') for n in ast.walk(raw))
    assert any(isinstance(n, ast.Assert) and dump(n.test) == dump(ast.parse('not witness_only', mode='eval').body)
               for n in ast.walk(raw))
    frozen = read(ROOT/paths[7]); exit_record = read(ROOT/paths[8]); report = read(ROOT/paths[9]); semantic = read(ROOT/paths[10])
    assert all(sha(ROOT/p) == h for p, h in frozen['input_and_source_hashes'].items())
    assert exit_record['returncode'] == 0 and not exit_record['outer_timeout']
    assert all(exit_record['sources_unchanged'].values())
    assert exit_record['frozen_sha256'] == sha(ROOT/paths[7])
    assert frozen['mode'] == 'necessary_zero_margin' and all(v == 0 for v in frozen['effective_margins'].values())
    assert report['status'] == 'EXPORTED_NUMERIC_LINEAR_NECESSARY_CASE_MODEL'
    assert report['zero_artificial_margins'] and report['owner_map_warm_literal_identity']
    assert semantic['status'] == 'PASS_EXACT_SEMANTIC_CASE_MODEL_CONSTRUCTION'
    assert semantic['consumer_sha256'] == hashes['verify_semantic_linear_case_dual.py']
    assert semantic['semantic_compiler_sha256'] == hashes['semantic_linear_case_rows.py']
    assert semantic['frozen_sha256'] == sha(ROOT/paths[7])
    assert semantic['numeric_correspondence']['status'] == 'PASS_COMPLETE_NUMERIC_ROW_CORRESPONDENCE'
    for key in ['variables', 'equalities', 'inequalities']:
        assert semantic[key] == report[key]
    assert not semantic['selected_source_case_excluded'] and not report['source_anchor_excluded']
    out = dict(status='PASS_SELECTED_CASE_LINEAR_EXPORT_REVIEW', source_hashes=hashes,
               frozen_input_bindings_checked=len(frozen['input_and_source_hashes']),
               model_prefix_ast_equal_after_two_offset_recording_assignments=True,
               model_prefix_top_level_statements=len(old_prefix),
               unchanged_non_main_code=True,
               wrapper_ast_equal_after_exporter_filename_substitution=True,
               exporter_has_no_solver_call=True, zero_margin_assertion=True,
               complete_numeric_to_semantic_row_correspondence_receipt=paths[10],
               variables=semantic['variables'], equalities=semantic['equalities'], inequalities=semantic['inequalities'],
               selected_case=[32, 32, 0], true_floor='1/16',
               semantic_digest=semantic['semantic_digest'], source_C16_answered=False,
               selected_source_case_excluded=False,
               scope='Review of a necessary linear relaxation and its coordinate export. Exact semantic source rows are separately reconstructed; there is no solver result or real Farkas certificate in this review.')
    assert all(sha(ROOT/p) == h for p, h in hashes.items())
    output.write_text(json.dumps(out, indent=2, sort_keys=True)+'\n')
    print(output.relative_to(ROOT), sha(output), out['status'])


if __name__ == '__main__':
    main()
