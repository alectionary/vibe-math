#!/usr/bin/env python3
"""Freeze exact Lagrange upper bounds for all291 fixed-T-template mask classes.

These are certified upper-bound candidates, not pair-constrained optimal supports
or pair-avoiding witnesses. Independent physical/source replay is required.
"""
from pathlib import Path
from functools import reduce
from fractions import Fraction
import argparse
import hashlib
import json
import math
import time

from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_pair_lagrange import forbidden_edges, optimize_bound
from full_partner_projection_features import candidate_weights

ROOT=Path(__file__).resolve().parent

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--template',type=Path,default=ROOT/'moment-resumption-results/common-profile32-projected-pruned.json')
    ap.add_argument('--rounds',type=int,default=30)
    ap.add_argument('--seconds',type=float,default=300)
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists() and not a.output.with_suffix('.frozen.json').exists()
    start=time.monotonic();bank=json.loads(a.template.read_text());c=[0]*775
    for (side,j),coefs in zip(bank['anchors'],bank['cuts'][0]['anchor_coefficients']):
        if side=='T':
            c[10+j]+=coefs[0]
            for h in range(16):c[55+16*j+(-h)%16]+=coefs[h+1]
    divisor=reduce(math.gcd,(abs(v) for v in c),0);assert divisor>0;c=[v//divisor for v in c]
    sourcepath=ROOT/'coupling-results/full-partner-orbit32.frozen.json';source=json.loads(sourcepath.read_text())
    masks=source['representatives'];edges=forbidden_edges();oracle=FullPartnerBasisOracle()
    paths=['full_partner_pair_template.py','full_partner_pair_lagrange.py','full_partner_basis_oracle.py',
           'full_partner_projection_features.py','projected_profile_moment_matrix.py',
           'moment-resumption-results/all-pair-word-cuts.json','moment-resumption-results/all-pair-moment-faces.json',
           'coupling-results/pair-price-capped-independent.json',str(a.template.resolve().relative_to(ROOT.resolve()))]
    sources={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_PAIR_PRICE_COHORT','source_C16_answered':False,
            'masks':masks,'weight_source_sha256':sha(sourcepath),'edges':edges,'source_hashes':sources,
            'rounds':a.rounds,'seconds':a.seconds,'weight_mode':'affine_phase_template','cohort':'template',
            'coefficients':c,'template_bank_sha256':sha(a.template),
            'scope':'Fixed11T forms with exact covariant weights on291 representative masks. Lagrange upper bounds only; no pair-constrained support optimality or physical frame existence asserted.'}
    fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n')
    records=[];out={'status':'RUNNING','source_C16_answered':False,'frozen_sha256':sha(fp),'records':records}
    for mask in masks:
        if time.monotonic()-start>=a.seconds:break
        weights=candidate_weights(mask,c);record=optimize_bound(oracle,oracle.prepare(32,mask),weights,edges,a.rounds)
        record.update(mask=mask,cohort='template');records.append(record)
        print(json.dumps({'mask':mask,'improvement':record['improvement'],'rounds':record['rounds'],'seconds':record['seconds']}),flush=True)
        if len(records)%20==0:a.output.write_text(json.dumps(out,indent=2)+'\n')
    unchanged={p:sha(ROOT/p)==digest for p,digest in sources.items()};assert all(unchanged.values())
    out.update(status='EXACT_UPPER_BOUND_CANDIDATES' if len(records)==len(masks) else 'INCOMPLETE_TIME_LIMIT',
               improved=sum(Fraction(r['improvement'])>0 for r in records),
               maximum_improvement=str(max((Fraction(r['improvement']) for r in records),default=Fraction(0))),
               elapsed_seconds=time.monotonic()-start,source_files_unchanged=unchanged,
               scope=frozen['scope']+' Independent consumer acceptance required.')
    a.output.write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({k:out[k] for k in ('status','improved','maximum_improvement','elapsed_seconds')}),flush=True)


if __name__=='__main__':main()
