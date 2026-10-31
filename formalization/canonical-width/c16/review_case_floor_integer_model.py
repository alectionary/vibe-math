#!/usr/bin/env python3
"""Read-only AST/source review of the case-floor necessary-model copy."""
from copy import deepcopy
from pathlib import Path
from fractions import Fraction as Q
import argparse
import ast
import difflib
import json
from verify_two_sided_full_basis_oracle import ROOT, sha, read, physical_source, point_owner, coordinate


def assignment_name(statement):
    if isinstance(statement, ast.Assign) and len(statement.targets) == 1 and isinstance(statement.targets[0], ast.Name):
        return statement.targets[0].id
    return None


class StripCaseMetadata(ast.NodeTransformer):
    def visit_Dict(self, node):
        node = self.generic_visit(node)
        keep = [not (isinstance(key, ast.Constant) and key.value == 'case_condition') for key in node.keys]
        node.keys = [key for key, yes in zip(node.keys, keep) if yes]
        node.values = [value for value, yes in zip(node.values, keep) if yes]
        return node

    def visit_Assign(self, node):
        if len(node.targets) == 1 and isinstance(node.targets[0], ast.Subscript):
            target = node.targets[0]
            if isinstance(target.value, ast.Name) and target.value.id == 'out' and isinstance(target.slice, ast.Constant):
                if target.slice.value in ('numeric_case_moment', 'numeric_case_floor_slack'):
                    return None
        return self.generic_visit(node)


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--bridge', type=Path, required=True); ap.add_argument('--replay', type=Path, required=True); ap.add_argument('--point', type=Path, required=True); ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args(); assert not a.output.exists()
    old_path = ROOT/'unified_integer_coupling_model.py'; new_path = ROOT/'case_floor_integer_coupling_model.py'
    before, after = old_path.read_text(), new_path.read_text()
    difference = ''.join(difflib.unified_diff(before.splitlines(True), after.splitlines(True), fromfile=old_path.name, tofile=new_path.name))
    diff_path = ROOT/'two-basis-results/case-floor-integer-model-copy.diff'; assert difference == diff_path.read_text()
    baseline, candidate = ast.parse(before), ast.parse(after)
    candidate.body[0] = deepcopy(baseline.body[0])
    main_function = next(node for node in candidate.body if isinstance(node, ast.FunctionDef) and node.name == 'main')
    stripped = []; removed_args = []; in_case_block = False; removed_statements = []
    for statement in main_function.body:
        if isinstance(statement, ast.Expr) and isinstance(statement.value, ast.Call):
            call = statement.value
            if isinstance(call.func, ast.Attribute) and call.func.attr == 'add_argument' and call.args and isinstance(call.args[0], ast.Constant):
                if call.args[0].value in ('--case', '--case-bridge', '--case-replay'):
                    removed_args.append(call.args[0].value); continue
        if assignment_name(statement) == 'bridge':
            in_case_block = True
        if in_case_block:
            removed_statements.append(ast.unparse(statement))
            if assignment_name(statement) == 'scope':
                in_case_block = False
            continue
        stripped.append(statement)
    assert removed_args == ['--case', '--case-bridge', '--case-replay'] and not in_case_block
    main_function.body = stripped; candidate = StripCaseMetadata().visit(candidate)
    assert ast.dump(candidate, include_attributes=False) == ast.dump(baseline, include_attributes=False)
    assert "con.append(T[ch][ci, cj] >= 1 / case_orbit_size)" in removed_statements
    bridge, replay = read(a.bridge), read(a.replay)
    assert bridge['status'] == 'PASS_SELECTED_PAIR_MOMENT_BRIDGE'
    assert replay['status'] == 'PASS' and replay['bridge_sha256'] == sha(a.bridge)
    assert replay['consumer_sha256'] == sha(ROOT/'verify_cover_case_moment_bridge.py')
    assert all(sha(ROOT/p) == h for p, h in bridge['source_hashes'].items())
    X, Z, symmetry = physical_source(); owner = point_owner(a.point)
    cases = read(ROOT/'transfer-results/cover-405.json')['cases']; assert len(cases) == len(bridge['records']) == 405
    floors = {}; selected = None
    for cover, record in zip(cases, bridge['records']):
        i, j, h = cover['orbit_tuple']; assert record['case'] == [i, j, h]
        x, z = 16*i, 16*j+h; assert (X[x] & Z[z]).bit_count() & 1
        literal = sum(int(16*i+t == x and 16*j+(t+h) % 16 == z)+int(16*i+t == z and 16*j+(t+h) % 16 == x) for t in range(16))
        floor = Q(literal, 32); assert floor == Q(record['necessary_floor']) == Q(1, record['edge_orbit_size'])
        col = coordinate('T', h, i, j); assert col == record['owner_coordinate']
        assert record['owner_inequality'] == dict(indices=[col], coefficients=[-record['edge_orbit_size']], rhs=-1)
        floors[str(floor)] = floors.get(str(floor), 0)+1
        if [i, j, h] == [32, 32, 0]:
            selected = dict(case=[i, j, h], X_index=x, Z_index=z, owner_column=col, floor=str(floor),
                            previous_exact_point_moment=str(owner[col]), previous_exact_point_floor_slack=str(owner[col]-floor))
    assert selected and selected['floor'] == '1/16' and floors == {'1/32':390, '1/16':15}
    result = dict(status='PASS_CASE_FLOOR_COPY_SEMANTICS_SOURCE_NECESSITY', source_C16_answered=False,
                  reviewer_sha256=sha(__file__), baseline_sha256=sha(old_path), case_model_sha256=sha(new_path), diff_sha256=sha(diff_path),
                  bridge_sha256=sha(a.bridge), bridge_replay_sha256=sha(a.replay), point_sha256=sha(a.point),
                  physical_consumer_sha256=sha(ROOT/'verify_two_sided_full_basis_oracle.py'), physical_symmetry_bridge=symmetry,
                  inherited_AST_identical_after_removing_declared_case_additions=True,
                  new_arguments=removed_args, new_case_block=removed_statements, all_cover_case_floors_rederived=405,
                  floor_histogram=floors, selected_case=selected,
                  necessary_execution_condition='Allthree artificial margins(PSD,Boolean,projected)zero; --certificate-margin remains forbidden. Actual command/flags must be checked against its frozen execution manifest.',
                  exact_dyadic_floor=True, warm_point_is_initialization_only=True,
                  feasibility_scope='An exact feasible moment certificate preserves this case relaxation; it is not a physical source frame.',
                  obstruction_scope='A source exclusion needs independently replayed exact infeasibility for the original zero-margin source-necessary rows, including exact Fourier/cyclotomic PSD meanings. A floating canonicalA dual alone is insufficient. Apositive-margin failure cannot exclude a source case.',
                  scientific_case_exclusions_claimed=0)
    a.output.write_text(json.dumps(result, indent=2)+'\n'); print(json.dumps(result, indent=2), flush=True)


if __name__ == '__main__':
    main()
