#!/usr/bin/env python3
"""Exact all-mask controls for the separate safe-pricing overflow wrapper."""
from pathlib import Path
import argparse,hashlib,json,time
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_safe_pricing import support_all
from full_partner_projection import mask_universe,support_all as reference
from full_partner_basis_oracle import FullPartnerBasisOracle
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists();start=time.monotonic();_,reps=mask_universe(32)
    oracle=FullPartnerBasisOracle();domains=[(m,oracle.prepare(32,m)) for m in reps];batch=IntegerPhaseWeightBatch(reps)
    bank=ROOT/'coupling-results/full-partner-projection-wolfe-witness2.json';c=json.loads(bank.read_text())['cuts'][0]['coefficients']
    cohorts=[('accepted_Wolfe_coefficients',c,'exact_int64_batch'),
             ('huge_signed_integer_control',[0]*10+[((j%3)-1)*(1<<67) for j in range(765)],'exact_python_integer_overflow_fallback')]
    paths=['full_partner_safe_pricing.py','verify_full_partner_safe_pricing.py','full_partner_batched_weights.py',
           'full_partner_projection.py','full_partner_projection_features.py','full_partner_basis_oracle.py',
           'pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz',
           'algebraic-results/hulls-16-rank.json.gz','coupling-results/full-partner-projection-wolfe-witness2.json']
    hashes={p:sha(ROOT/p) for p in paths};frozen={'source_hashes':hashes,'cohorts':[{'name':n,'coefficients':w,'expected_mode':m} for n,w,m in cohorts],'representatives':reps}
    fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n');records=[]
    for name,coefficients,expected in cohorts:
        result,mode=support_all(oracle,domains,coefficients,batch,return_mode=True);old=reference(oracle,domains,coefficients)
        assert mode==expected and result==old
        records.append({'cohort':name,'mode':mode,'all291_values_witnesses_features_match':True,'exact_global_support':str(result[0])})
    rejected=[]
    for name,bad in [('floating_coefficients',[0.5]*775),('wrong_length',[0]*774)]:
        try:support_all(oracle,domains,bad,batch)
        except (TypeError,ValueError):rejected.append(name)
        else:raise AssertionError(name+' incorrectlyfellback')
    assert all(sha(ROOT/p)==digest for p,digest in hashes.items())
    out={'status':'PASS','source_C16_answered':False,'frozen_sha256':sha(fp),'source_hashes':hashes,'records':records,
         'malformed_input_rejections':rejected,'elapsed_seconds':time.monotonic()-start,
         'scope':'Exact batch/fallback value,witness,andfeature controls only; the source-cut independent consumer remains unchanged.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))

if __name__=='__main__':main()
