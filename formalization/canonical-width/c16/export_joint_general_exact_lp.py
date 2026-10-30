"""Exact LP export for the independently reviewed shared-law model.

Optional zero-tau equations select one law; their presence explicitly prevents
claiming a general-law exclusion. Rank additions are checked in physical
coordinates for every pattern. Star additions use the reviewed source adapter.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import json
import os
import time

from two_basis_joint_general_star import (
    ROOT, sha, read, decode_model, lift_model, append_stars, row_expression,
    encode, term, probability_bound_guard,
)
from verify_two_sided_full_basis_oracle import physical_source, domains, rank
from export_joint_fixed_exact_lp import write_row


def prepare_model(model_path, model_receipt, point, stars, ranks):
    receipt, raw = read(model_receipt), read(model_path)
    assert receipt['status'] == 'PASS_EXACT_GENERAL_SHARED_LAW_MODEL'
    assert receipt['model_sha256'] == sha(model_path)
    assert receipt['consumer_sha256'] == sha(ROOT/'verify_two_basis_joint_general.py')
    assert receipt['point_sha256'] == raw['point_sha256'] == sha(point)
    assert all(sha(ROOT/p) == h for p, h in raw['source_hashes'].items())
    model, features = lift_model(decode_model(raw), point)
    append_stars(model, stars)
    X, Z, _ = physical_source()
    dd = domains(X, Z, model['X_anchors'], model['Z_anchors'])
    additions = []
    for bank_path, receipt_path in ranks:
        bank, checked = read(bank_path), read(receipt_path)
        assert checked['bank_sha256'] == sha(bank_path)
        assert checked['status'] in ['PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS',
                                     'PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS']
        assert bank['X_anchors'] == model['X_anchors'] and bank['Z_anchors'] == model['Z_anchors']
        side = bank['side']; assert side in ['X', 'Z']
        assert all(sha(ROOT/p) == h for p, h in bank['source_hashes'].items())
        U = X if side == 'X' else Z
        sector = model['sectors'][side]
        sector['rank_rows'] = list(sector['rank_rows'])
        keys = {(r['mask'], tuple(r['indices'])) for r in sector['rank_rows']}
        count = 0
        for row in bank['cuts']:
            m, F, S, r = [row[k] for k in ['mask', 'forced_zero_indices', 'indices', 'contraction_rank']]
            assert type(m) is int and 0 <= m < 16 and type(r) is int and r >= 0
            assert F == dd[m][side]['zero_forced'] and rank(U[j] for j in F) == len(F)
            assert S == sorted(set(S)) and set(S) <= set(dd[m][side]['zero_free'])
            assert rank(U[j] for j in F+S)-len(F) == r
            key = m, tuple(S)
            if key in keys:
                continue
            keys.add(key)
            sector['rank_rows'].append({k: row[k] for k in
                                       ['mask', 'forced_zero_indices', 'indices', 'contraction_rank']})
            model['inequalities'].append(dict(kind='rank', side=side,
                                              rank_index=len(sector['rank_rows'])-1))
            count += 1
        additions.append(dict(bank=str(bank_path), bank_sha256=sha(bank_path),
                              receipt=str(receipt_path), receipt_sha256=sha(receipt_path),
                              added_rows=count, all_literal_physical_ranks_rechecked=True))
        model['source_hashes'].update(bank['source_hashes'])
        model['source_hashes'].update({str(p): sha(p) for p in [bank_path, receipt_path]})
    model['additional_rank_bindings'] = additions
    model['source_hashes'].update({str(p): sha(p) for p in [model_path, model_receipt, point]})
    probability_bound_guard(model)
    return model, features


def semantic_rows(model, features, pin_zero_tau):
    for kind, relation in [('equalities', '='), ('inequalities', '<=')]:
        for index, descriptor in enumerate(model[kind]):
            expression = row_expression(model, descriptor)
            constant = sum((v*features[j] for j, v in expression[0].items()), Q(0))
            yield kind, index, relation, expression, constant
    if pin_zero_tau:
        for j, variable in enumerate(model['variables']):
            if variable['kind'] == 'tau':
                yield 'zero_tau', j, '=', term(1, j), Q(0)


def replay_text(path, rows, n):
    tokens = path.read_text().split()
    assert tokens[:7] == ['Minimize', 'obj:', '+', '0', 'x0', 'Subject', 'To']
    cursor = 7
    for name, relation, coefficients, rhs in rows:
        assert tokens[cursor] == name+':' ; cursor += 1
        seen = {}
        while tokens[cursor] in ['+', '-']:
            value = Q(tokens[cursor+1]) * (1 if tokens[cursor] == '+' else -1)
            var = tokens[cursor+2]; assert var.startswith('x') and 0 <= int(var[1:]) < n
            j = int(var[1:]); seen[j] = seen.get(j, Q(0)) + value; cursor += 3
        assert tokens[cursor] == relation and Q(tokens[cursor+1]) == rhs; cursor += 2
        assert {j: v for j, v in seen.items() if v} == coefficients
    assert tokens[cursor] == 'Bounds'; cursor += 1
    for j in range(n):
        assert tokens[cursor:cursor+2] == ['x'+str(j), 'free']; cursor += 2
    assert tokens[cursor:] == ['End']


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--model', type=Path, required=True)
    ap.add_argument('--model-receipt', type=Path, required=True)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--star-bank', type=Path, action='append', default=[])
    ap.add_argument('--star-receipt', type=Path, action='append', default=[])
    ap.add_argument('--rank-bank', type=Path, action='append', default=[])
    ap.add_argument('--rank-receipt', type=Path, action='append', default=[])
    ap.add_argument('--pin-zero-tau', action='store_true')
    ap.add_argument('--prefix', type=Path, required=True)
    a = ap.parse_args(); start = time.monotonic()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    assert len(a.star_bank) == len(a.star_receipt) and len(a.rank_bank) == len(a.rank_receipt)
    paths = {k: Path(str(a.prefix)+suffix) for k, suffix in
             [('lp', '.lp'), ('model', '.model.json.gz'), ('manifest', '.json')]}
    assert not any(p.exists() for p in paths.values())
    model, features = prepare_model(a.model, a.model_receipt, a.point,
                                    list(zip(a.star_bank, a.star_receipt)),
                                    list(zip(a.rank_bank, a.rank_receipt)))
    model['source_hashes']['export_joint_general_exact_lp.py'] = sha(Path(__file__))
    n = len(model['variables']); rows = []; labels = []
    with paths['lp'].open('w') as stream:
        stream.write('Minimize\n obj: + 0 x0\nSubject To\n')
        for kind, index, relation, expression, constant in semantic_rows(model, features, a.pin_zero_tau):
            name = kind+str(index)
            write_row(stream, name, expression[1], -constant, relation)
            rows.append((name, relation, expression[1], -constant))
            labels.append(dict(name=name, kind=kind, index=index))
        stream.write('Bounds\n')
        for j in range(n): stream.write(' x'+str(j)+' free\n')
        stream.write('End\n')
    replay_text(paths['lp'], rows, n)
    saved = dict(status='EXACT_GENERAL_JOINT_LP_EXPORT_REQUIRE_REPLAY',
                 model=encode(model), feature_values=list(map(str, features)),
                 point=str(a.point), point_sha256=sha(a.point),
                 zero_tau_pins=a.pin_zero_tau, row_labels=labels,
                 semantic_relaxation='fixed_zero_high_law' if a.pin_zero_tau else 'general_shared_law')
    paths['model'].write_bytes(gzip.compress((json.dumps(saved)+'\n').encode(), mtime=0))
    out = dict(status='PASS_EXACT_GENERAL_LP_FRACTION_TEXT_ROUNDTRIP',
               lp=str(paths['lp']), lp_sha256=sha(paths['lp']), lp_bytes=paths['lp'].stat().st_size,
               semantic=str(paths['model']), semantic_sha256=sha(paths['model']),
               variable_count=n, row_count=len(rows), nonzeros=sum(len(r[2]) for r in rows),
               base_equalities=len(model['equalities']), inequalities=len(model['inequalities']),
               zero_tau_pins=a.pin_zero_tau, source_sha256=sha(Path(__file__)),
               nice=os.getpriority(os.PRIO_PROCESS, 0), elapsed_seconds=time.monotonic()-start,
               source_C16_answered=False,
               scope='Exact finite general-law relaxation, or explicitly pinned law; no optimizer result.')
    paths['manifest'].write_text(json.dumps(out, indent=2)+'\n')
    print(out, flush=True)


if __name__ == '__main__':
    main()
