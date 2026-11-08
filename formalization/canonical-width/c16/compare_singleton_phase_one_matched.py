#!/usr/bin/env python3
"""Exact comparison of two independently accepted phase-I optima."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    os.environ[k]='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
    p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--old',type=Path,required=True);ap.add_argument('--new',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists()
    receipts=[read(a.old),read(a.new)];models=[]
    for path,d in zip((a.old,a.new),receipts):
        assert d['status']=='PASS_EXACT_SINGLETON_PHASE_ONE_OPTIMUM_AND_FULL_GREEDY_PRICING'
        assert d['consumer_sha256']==sha(ROOT/'verify_singleton_phase_one_v2.py')
        assert d['parser_sha256']==sha(ROOT/'read_soplex_exact_output_v2.py')
        assert sha(d['manifest'])==d['manifest_sha256']
        pm=read(d['manifest']);assert sha(pm['parent_manifest'])==pm['parent_manifest_sha256']
        archive=read(pm['parent_manifest']);assert sha(archive['semantic'])==archive['semantic_sha256']
        models.append(read(archive['semantic']))
    old,new=models
    assert len(old['physical_bases'])==3225 and len(new['physical_bases'])==3290
    assert new['physical_bases'][:3225]==old['physical_bases']
    for field in ('point_sha256','anchor_orbit','conditional_target','physical_zero_ground_indices','unit_probabilities'):
        assert old[field]==new[field],field
    before,after=(Q(d['exact_restricted_L1_distance']) for d in receipts)
    assert 0<=after<=before
    gap=Q(receipts[1]['pricing']['exact_global_separation_gap']);decrease=before-after
    result=dict(status='PASS_EXACT_MATCHED_PHASE_ONE_OBJECTIVE_COMPARISON',
                old_receipt=str(a.old),old_receipt_sha256=sha(a.old),new_receipt=str(a.new),new_receipt_sha256=sha(a.new),
                old_basis_count=3225,new_basis_count=3290,all_old_columns_and_exact_targets_retained=True,
                exact_old_L1_distance=str(before),exact_new_L1_distance=str(after),exact_decrease=str(decrease),
                exact_relative_decrease=str(decrease/before),strict_decrease=decrease>0,
                old_L1_approx=float(before),new_L1_approx=float(after),relative_decrease_approx=float(decrease/before),
                new_global_pricing_gap=str(gap),new_global_pricing_gap_approx=float(gap),
                new_positive_basis_count=receipts[1]['positive_basis_count'],full_singleton_membership=after==0,
                positive_global_gap=gap>0,matched_trial_lp_calls=1,no_automatic_retry=True,
                source_C16_answered=False,producer_sha256=sha(__file__),nice=19,threads=1)
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result),flush=True)
if __name__=='__main__':main()
