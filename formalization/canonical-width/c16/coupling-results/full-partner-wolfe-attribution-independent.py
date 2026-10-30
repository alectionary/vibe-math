#!/usr/bin/env python3
"""Matched exact support attribution, independently using physical pools."""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
import hashlib, json, sys, time
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from verify_algebraic_model import physical
from verify_full_partner_projection import read, weights, local_score
from verify_full_partner_basis_oracle import dimension, extend, rebuild_domain
from weighted_matroid_separator import insert


def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()


start = time.monotonic()
output = ROOT/'coupling-results/full-partner-wolfe-attribution-independent.json'
assert not output.exists()
bankpath = ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json'
receiptpath = ROOT/'coupling-results/full-partner-projection-wolfe-witness2-independent.json'
bank, receipt = read(bankpath), read(receiptpath)
assert receipt['status'] == 'PASS' and receipt['bank_sha256'] == sha(bankpath)
cut = bank['cuts'][0]; c = cut['coefficients']; X, Z, pairing = physical()
assert len(c) == 775 and all(type(x) is int for x in c)
prefix_checks = 0


def basis(pool, w, rank):
    global prefix_checks
    order = sorted(pool, key=lambda j: (-w[j], j))
    high, chosen = {}, []
    for j in order:
        old = len(high); insert(high, Z[j])
        if len(high) != old: chosen.append(j)
    assert len(high) == len(chosen) == rank and dimension(Z[j] for j in chosen) == rank
    low, ranks = {}, []
    for j in order:
        extend(low, Z[j]); ranks.append(len(low))
    prefix_checks += len(order)
    upper = (w[order[-1]]*rank if order else 0)+sum((w[order[t]]-w[order[t+1]])*ranks[t] for t in range(len(order)-1))
    value = sum(w[j] for j in chosen)
    assert value == upper
    return value, chosen


profiles = read(ROOT/'algebraic-results/hulls-16-rank.json.gz')
caps = {r['orbit']: max(s['moments'][0] for s in r['shapes']) for r in profiles['records']}
pairbank = read(ROOT/'moment-resumption-results/all-pair-word-cuts.json')
edges = sorted({tuple(sorted(16*(j//16)+(j%16+h) % 16 for j in r['indices'])) for r in pairbank['cuts'] for h in range(16)})
records = []
for r in cut['support_records']:
    mask = r['mask']; phases = [h for h in range(16) if mask >> h & 1]
    w, local = weights(mask, c), local_score(mask, c)
    domain = rebuild_domain(X, Z, [512+h for h in phases], 128)
    assert domain['status'] == 'FULL_PARTNER_BASIS_DOMAIN'
    eligible = domain['zero']+sum(domain['bins'], [])
    owner = [max(b, key=lambda j: (w[j], -j)) for b in domain['bins']]
    zero_value, zero_basis = basis(domain['zero'], w, 128-len(phases))
    full = local+zero_value+sum(w[j] for j in owner)
    assert full == r['full_value']
    values = {'full_compatible_basis': full,
              'unrestricted_128_count': local+sum(sorted(w, reverse=True)[:128]),
              'unrestricted_full_Z_basis': local+basis(range(720), w, 128)[0],
              'eligible_128_count': local+sum(sorted((w[j] for j in eligible), reverse=True)[:128]),
              'eligible_full_Z_basis_without_unique_owners': local+basis(eligible, w, 128)[0],
              'exact_owners_zero_count_without_rank': local+sum(w[j] for j in owner)+sum(sorted((w[j] for j in domain['zero']), reverse=True)[:128-len(phases)]),
              'eligible_positive_hinges': local+sum(max(0, w[j]) for j in eligible)}
    singleton = []
    for h in phases:
        d = rebuild_domain(X, Z, [512+h], 128)
        value, chosen = basis(d['zero'], w, 127)
        unit = max(d['bins'][0], key=lambda j: (w[j], -j))
        singleton.append({'anchor_phase': h, 'upper': local+value+w[unit]})
    values['best_singleton_full_basis_bound'] = min(s['upper'] for s in singleton) if singleton else values['unrestricted_full_Z_basis']
    chosen = set(r['selected_Z_indices']); counts = Counter(j//16 for j in chosen)
    records.append({'mask': mask, 'values': values, 'singleton_bounds': singleton,
                    'saved_optimizer_orbit_cap_violations': [{'orbit': j, 'count': counts[j], 'cap': caps[j]} for j in range(45) if counts[j] > caps[j]],
                    'saved_optimizer_forbidden_pairs': [list(e) for e in edges if set(e) <= chosen]})
maximum = {key: max(r['values'][key] for r in records) for key in records[0]['values']}
assert maximum['full_compatible_basis'] == cut['upper_bound']
oldpath = ROOT/'coupling-results/full-partner-wolfe-cut-attribution.json'
old = read(oldpath)
assert old['global_bounds'] == {'full_basis': maximum['full_compatible_basis'],
       'cardinality_and_required_owners_without_rank': maximum['exact_owners_zero_count_without_rank'],
       'separate_eligible_hinges': maximum['eligible_positive_hinges']}
latticepath = ROOT/'coupling-results/full-partner-singleton-witness2-independent.json'
lattice = read(latticepath)
assert lattice['status'] == 'PASS_ALL_SINGLETON_CONDITIONAL_Z_RANK_INEQUALITIES' and lattice['point_sha256'] == bank['point_sha256']
out = {'status': 'PASS_MATCHED_SUPPORT_ATTRIBUTION_AND_SINGLETON_RANK_BARRIER', 'source_C16_answered': False,
       'bank_sha256': sha(bankpath), 'accepted_cut_receipt_sha256': sha(receiptpath),
       'prior_attribution_sha256': sha(oldpath), 'singleton_all_rank_receipt_sha256': sha(latticepath),
       'identical_coefficients_in_all_models': True, 'global_bounds': maximum,
       'global_maximizing_masks': {key: [r['mask'] for r in records if r['values'][key] == value] for key, value in maximum.items()},
       'exact_target_value': cut['exact_target_value'], 'pricing_scale': cut['pricing_scale'],
       'scaled_gaps': {key: str((Q(cut['exact_target_value'])-value)/cut['pricing_scale']) for key, value in maximum.items()},
       'physical_prefix_ranks_checked': prefix_checks,
       'strict_joint_vs_singleton_envelope_classes': sum(r['values']['best_singleton_full_basis_bound'] > r['values']['full_compatible_basis'] for r in records),
       'saved_optimizer_cap_violations': sum(bool(r['saved_optimizer_orbit_cap_violations']) for r in records),
       'saved_optimizer_forbidden_pair_violations': sum(bool(r['saved_optimizer_forbidden_pairs']) for r in records),
       'records': records, 'consumer_sha256': sha(Path(__file__)), 'elapsed_seconds': time.monotonic()-start,
       'scope': 'The accepted form needs joint profile-conditioned basis support: all matched weaker bounds fail separation, and witness2 satisfies every singleton orbit32 conditional cross-rank inequality by a separate exact lattice certificate. These tests do not identify a full source obstruction or frame.'}
output.write_text(json.dumps(out, indent=2)+'\n')
print(json.dumps({k: out[k] for k in ('status', 'global_bounds', 'physical_prefix_ranks_checked', 'strict_joint_vs_singleton_envelope_classes', 'elapsed_seconds')}))
