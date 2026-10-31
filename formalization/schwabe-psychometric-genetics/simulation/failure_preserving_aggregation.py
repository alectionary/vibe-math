"""Deterministic specifications for future source-count summaries; no fitting.

Caller supplies predeclared requested IDs. Missing records remain unclassified.
This module does not certify diagnostics or compute chain HPDs.
"""
import math
import statistics
from scipy.stats import beta


def aggregate(requested_ids, records, alpha=.05, family_size=12):
    ids = tuple(requested_ids)
    if not ids or len(set(ids)) != len(ids):
        raise ValueError('Nonempty unique requested IDs required')
    if not 0 < alpha < 1 or type(family_size) is not int or family_size < 1:
        raise ValueError('Invalid interval specification')
    by_id = {}
    for row in records:
        key = row['id']
        if key not in ids or key in by_id:
            raise ValueError('Unknown or duplicate record')
        by_id[key] = row
    means, sds = [], []
    detected = nondetected = 0
    for row in by_id.values():
        if row.get('gate_valid') is not True:
            continue
        mean, sd = row.get('posterior_mean'), row.get('posterior_sd')
        if (type(mean) not in (float, int) or type(sd) not in (float, int)
                or not math.isfinite(mean) or not math.isfinite(sd) or sd < 0):
            raise ValueError('Gate-valid record requires finite mean and nonnegative SD')
        means.append(mean)
        sds.append(sd)
        decision = row.get('stable_hpd_decision')
        if decision in ('positive', 'negative'):
            detected += 1
        elif decision == 'includes_zero':
            nondetected += 1
        elif decision is not None:
            raise ValueError('Invalid HPD classification')
    n = len(ids)
    unknown = n - detected - nondetected
    def interval(level):
        lo = 0. if detected == 0 else float(beta.ppf(level/2, detected, n-detected+1))
        upper_count = detected + unknown
        hi = 1. if upper_count == n else float(beta.ppf(1-level/2, upper_count+1, n-upper_count))
        return [lo, hi]
    return {
        'requested': n, 'recorded': len(by_id), 'missing': n-len(by_id),
        'valid_recovery': len(means), 'complete_recovery': len(means) == n,
        'classified_detections': detected, 'classified_nondetections': nondetected,
        'unclassified': unknown, 'realized_detection_bounds': [detected/n, (detected+unknown)/n],
        'binomial_interval': interval(alpha), 'familywise_interval': interval(alpha/family_size),
        'provisional_mean_posterior_mean': statistics.mean(means) if means else None,
        'provisional_sd_posterior_means': statistics.stdev(means) if len(means)>1 else None,
        'provisional_mean_posterior_sd': statistics.mean(sds) if sds else None,
        'scope': 'Conditional-on-valid recovery summaries; requested denominator retained. No original source-count target is completed by fixtures.'
    }
