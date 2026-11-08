#!/usr/bin/env python3
"""Bounded ten-variable mask-feature optimization for fixed T-anchor forms.

Full-basis and separate eligible-anchor hinge supports are computed on identical
physical domains. Exact recovered candidates have all291 support witnesses;
independent consumer acceptance is required. Numerical optimum differences are
not declared exact optimality proofs.
"""
from pathlib import Path
from fractions import Fraction
from functools import reduce
import argparse
import hashlib
import json
import math
import time

import numpy as np
from scipy.optimize import linprog

from full_partner_projection import mask_universe, support_all, sha
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import candidate_weights, column_features, mask_score, moment_target
from verify_projected_profile_moment_rows import point_vector

ROOT = Path(__file__).resolve().parent


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--templates', type=Path, nargs='+', default=[
        ROOT/'moment-resumption-results/common-profile32-projected-pruned.json',
        ROOT/'coupling-results/joint-anchor-matched-exact.json',
        ROOT/'coupling-results/joint-anchor-conditional-exact.json'])
    ap.add_argument('--output', type=Path, required=True)
    args = ap.parse_args()
    assert not args.output.exists()
    start = time.monotonic()
    allowed, representatives = mask_universe(32)
    target = moment_target(point_vector(args.point))
    oracle = FullPartnerBasisOracle()
    domains = [(p, oracle.prepare(32, p)) for p in representatives]
    A = np.array([column_features(p, ())[:10] for p in representatives], dtype=np.int64)
    source_paths = ['full_partner_projection_templates.py', 'full_partner_projection.py',
                    'full_partner_projection_features.py', 'full_partner_basis_oracle.py',
                    'verify_projected_profile_moment_rows.py', 'projected_profile_moment_matrix.py',
                    'physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
                    'algebraic-results/orbit-rank-profiles.json.gz', 'algebraic-results/hulls-16-rank.json.gz',
                    'moment-resumption-results/symmetry-bridge-independent.json',
                    'coupling-results/full-partner-orbit32-independent.json']
    sources = {p: sha(ROOT/p) for p in source_paths}
    sources.update({str(p.resolve().relative_to(ROOT.resolve())): sha(p) for p in args.templates})
    reports, cuts, seen = [], [], {}
    for path in args.templates:
        bank = json.loads(path.read_text())
        for cut_index, old in enumerate(bank['cuts']):
            fixed = [0]*775
            for (side, j), coefficients in zip(bank['anchors'], old['anchor_coefficients']):
                if side != 'T':
                    continue
                fixed[10+j] += coefficients[0]
                for h in range(16):
                    fixed[55+16*j+(-h)%16] += coefficients[h+1]
            divisor = reduce(math.gcd, (abs(v) for v in fixed), 0)
            assert divisor > 0
            fixed = [v//divisor for v in fixed]
            key = tuple(fixed)
            if key in seen:
                reports.append({'template': str(path), 'cut_index': cut_index,
                                'same_normalized_T_forms_as': seen[key]})
                continue
            seen[key] = str(path)
            _, records, _ = support_all(oracle, domains, fixed)
            full = [r['support_value'] for r in records]
            hinge = []
            for p, domain in domains:
                w = candidate_weights(p, fixed)
                eligible = list(domain['zero_indices']) + [j for group in domain['owner_bins'] for j in group]
                hinge.append(sum(max(0, w[j]) for j in eligible))
            report = {'template': str(path), 'cut_index': cut_index,
                      'normalizing_T_form_gcd': divisor,
                      'full_vs_hinge_strict_masks': sum(a < b for a,b in zip(full,hinge)),
                      'maximum_mask_support_improvement': max(b-a for a,b in zip(full,hinge)),
                      'LP_runs': []}
            reports.append(report)
            anchor_target = sum(c*t for c,t in zip(fixed,target))
            for family, support in [('full_basis', full), ('separate_hinge', hinge)]:
                lp = linprog(-np.array(list(map(float,target[:10]))), A_ub=A,
                             b_ub=-np.array(support, dtype=float), bounds=[(None,None)]*10,
                             method='highs', options={'time_limit':30})
                rec = {'family':family, 'numeric_status':int(lp.status),
                       'numeric_message':lp.message,
                       'numeric_optimal_violation':float(anchor_target)-float(lp.fun) if lp.fun is not None else None,
                       'recovered_candidates':[]}
                report['LP_runs'].append(rec)
                if lp.status != 0:
                    continue
                best = None
                for scale in (1,16,256,4096,65536):
                    c = [v*scale for v in fixed]
                    c[1:10] = [int(np.rint(v*scale)) for v in lp.x[1:10]]
                    c[0] = 0
                    bound = max(mask_score(p,c)+scale*s for (p,_),s in zip(domains,support))
                    divisor2 = reduce(math.gcd, (abs(v) for v in [*c,bound]), 0) or 1
                    c = [v//divisor2 for v in c]
                    bound //= divisor2
                    effective_scale = scale//divisor2
                    value = sum(a*b for a,b in zip(c,target));gap=value-bound
                    hbound = max(mask_score(p,c)+effective_scale*s for (p,_),s in zip(domains,hinge))
                    fbound = max(mask_score(p,c)+effective_scale*s for (p,_),s in zip(domains,full))
                    detail = {'scale':scale,'effective_scale':effective_scale,'upper_bound':bound,
                              'exact_violation':str(gap),'normalized_violation':str(gap/effective_scale),
                              'same_coefficients_full_bound':fbound,'same_coefficients_hinge_bound':hbound,
                              'exact_constant_gain_full_over_hinge':hbound-fbound}
                    rec['recovered_candidates'].append(detail)
                    if family=='full_basis' and gap>0 and (best is None or gap/effective_scale>best[0]):
                        support_records = [{**r,'support_value':r['support_value']*effective_scale,
                            'full_value':mask_score(r['mask'],c)+r['support_value']*effective_scale} for r in records]
                        best=(gap/effective_scale, {'coefficients':c,'upper_bound':bound,
                             'exact_target_value':str(value),'exact_violation':str(gap),
                             'pricing_scale':effective_scale,'support_records':support_records,
                             'origin':{'template':str(path),'mask_feature_optimization':'ten-variable numerical LP with exact integer support recovery'},
                             'matched_same_coefficients_hinge_bound':hbound,
                             'matched_exact_constant_gain':hbound-bound})
                if best is not None:
                    cuts.append(best[1])
            print(json.dumps(report),flush=True)
    assert all(sha(ROOT/p)==v for p,v in sources.items())
    result={'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND',
            'source_C16_answered':False,'orbit':32,
            'feature_layout':'1,k,C1..C8,n[45],d[45,16].ravel(C)',
            'point_sha256':sha(args.point),'source_hashes':sources,
            'allowed_masks':len(allowed),'representatives':representatives,
            'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
            'template_reports':reports,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,
            'scope':'Fixed T-form projected support probe with exact recovered candidate bounds. Independent support/translation replay is required for positive cuts; numerical no-separation is not membership. Same-coefficient hinge comparison separates support gain from changing unconditional coefficients.'}
    args.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'status':result['status'],'cuts':len(cuts),'elapsed_seconds':result['elapsed_seconds']}),flush=True)


if __name__=='__main__':
    main()
