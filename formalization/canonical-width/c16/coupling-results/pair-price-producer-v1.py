#!/usr/bin/env python3
"""Certified upper bounds for full partner bases avoiding known forbidden pairs.

For arbitrary nonnegative edge prices lambda and any pair-avoiding basis B,
  w(B) <= max_basis (w-deg(lambda))(B) + sum(lambda).
The maximum on the right is the exact full-partner greedy support. Numerical
LPs only propose prices; the returned upper bound uses exact rational prices
and an exact greedy call. No optimality or source frame existence is asserted.
"""
from pathlib import Path
from fractions import Fraction
import argparse, collections, hashlib, json, time
import numpy as np
from scipy.optimize import linprog
from full_partner_basis_oracle import FullPartnerBasisOracle

ROOT = Path(__file__).resolve().parent
def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def forbidden_edges(root=ROOT):
    bank = root / 'moment-resumption-results/all-pair-word-cuts.json'
    receipt = root / 'moment-resumption-results/all-pair-moment-faces.json'
    cuts = json.loads(bank.read_text())['cuts']
    replay = json.loads(receipt.read_text())
    assert replay['status'] == 'PASS' and replay['source_pair_bank_sha256'] == sha(bank)
    assert replay['physical_cyclic_and_sector_pairing_symmetries_checked']
    assert len(cuts) == 4 and all(len(c['indices']) == 2 for c in cuts)
    edges = sorted({tuple(sorted(16*(j//16)+(j%16+h)%16 for j in c['indices']))
                    for c in cuts for h in range(16)})
    for h in range(16):
        assert {tuple(sorted(16*(j//16)+(j%16+h)%16 for j in e)) for e in edges} == set(edges)
    return edges

def exact_bound(oracle, domain, weights, edges, prices):
    prices = [Fraction(p) for p in prices]
    assert len(prices) == len(edges) and min(prices, default=0) >= 0
    adjusted = list(map(Fraction, weights))
    for (i, j), price in zip(edges, prices):
        adjusted[i] -= price
        adjusted[j] -= price
    support = oracle.support(domain, adjusted)
    assert support['status'] == 'EXACT_FULL_PARTNER_BASIS_SUPPORT'
    chosen = set(support['selected_Z_indices'])
    return {'upper': support['value'] + sum(prices), 'support': support,
            'prices': prices, 'adjusted_weights': adjusted,
            'counts': [int(i in chosen) + int(j in chosen) for i, j in edges],
            'raw_weight': sum(Fraction(weights[j]) for j in chosen)}

def optimize_bound(oracle, domain, weights, edges, rounds=30, denominator=1024):
    start = time.monotonic()
    first = exact_bound(oracle, domain, weights, edges, [0]*len(edges))
    best = first
    rows, rhs, seen, history = [], [], set(), []
    proposed = first
    for iteration in range(rounds):
        signature = tuple(proposed['counts'])
        key = signature, proposed['raw_weight']
        if key not in seen:
            seen.add(key)
            # t >= raw_weight - sum(lambda_e * count_e).
            rows.append([-v for v in signature] + [-1])
            rhs.append(-float(proposed['raw_weight']))
        objective = [1]*len(edges) + [1]
        result = linprog(objective, A_ub=np.array(rows), b_ub=rhs,
                         bounds=[(0, None)]*len(edges)+[(None, None)], method='highs')
        if not result.success:
            history.append({'iteration': iteration, 'LP_status': result.status})
            break
        prices = [Fraction(max(0., float(v))).limit_denominator(denominator) for v in result.x[:-1]]
        proposed = exact_bound(oracle, domain, weights, edges, prices)
        if proposed['upper'] < best['upper']:
            best = proposed
        history.append({'iteration': iteration, 'LP_lower_approximation': float(result.fun),
                        'exact_upper': str(proposed['upper']), 'best_exact_upper': str(best['upper'])})
        if float(best['upper']) - result.fun < 1e-8:
            break
    return {'status': 'EXACT_LAGRANGE_UPPER_BOUND', 'upper': str(best['upper']),
            'unrestricted_upper': str(first['upper']),
            'improvement': str(first['upper']-best['upper']),
            'edge_prices': list(map(str, best['prices'])),
            'greedy_basis': list(best['support']['selected_Z_indices']),
            'greedy_adjusted_value': str(best['support']['value']),
            'rounds': len(history), 'history': history,
            'seconds': time.monotonic()-start,
            'scope': 'Certified upper bound only; pricing optimality and pair-avoiding basis existence are not asserted.'}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--rounds', type=int, default=30)
    ap.add_argument('--masks', type=int, default=12)
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    frozen_source = ROOT / 'coupling-results/full-partner-orbit32.frozen.json'
    source = json.loads(frozen_source.read_text())
    oracle = FullPartnerBasisOracle()
    edges = forbidden_edges()
    masks = source['representatives'][:args.masks]
    weights = source['weight_sets']
    if isinstance(weights, dict):
        cohorts = list(weights.items())
    else:
        cohorts = [(str(i), w) for i, w in enumerate(weights)]
    frozen = {'status': 'FROZEN_BEFORE_PAIR_PRICE_COHORT', 'masks': masks,
              'weight_source_sha256': sha(frozen_source), 'edges': edges,
              'source_hashes': {p: sha(ROOT/p) for p in [
                  'full_partner_pair_lagrange.py', 'full_partner_basis_oracle.py',
                  'moment-resumption-results/all-pair-word-cuts.json',
                  'moment-resumption-results/all-pair-moment-faces.json']},
              'rounds': args.rounds, 'scope': 'Diagnostic fixed weight cohort, not a projected source separator.'}
    args.output.with_suffix('.frozen.json').write_text(json.dumps(frozen, indent=2)+'\n')
    records = []
    for mask in masks:
        domain = oracle.prepare(32, mask)
        for name, weight in cohorts:
            if isinstance(weight, dict):
                weight = weight['weights']
            rec = optimize_bound(oracle, domain, weight, edges, args.rounds)
            rec.update(mask=mask, cohort=name)
            records.append(rec)
            print({'mask': mask, 'cohort': name, 'improvement': rec['improvement'], 'seconds': rec['seconds']}, flush=True)
    summary = {'status': 'EXACT_UPPER_BOUND_CANDIDATES', 'source_C16_answered': False,
               'frozen_sha256': sha(args.output.with_suffix('.frozen.json')), 'records': records,
               'improved': sum(Fraction(r['improvement']) > 0 for r in records),
               'scope': 'Independent consumer still required; no source or projected-membership conclusion.'}
    args.output.write_text(json.dumps(summary, indent=2)+'\n')

if __name__ == '__main__':
    main()
