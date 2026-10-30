#!/usr/bin/env python3
"""Exact evaluation of full-basis rows, including orbit-general and priced rows."""
from pathlib import Path
from fractions import Fraction
import argparse,json,time
from accepted_multi_orbit_rows import matrix
from verify_projected_profile_moment_rows import point_vector,row_residuals
from verify_basis_coupling_rows import target_features
from verify_full_partner_projection import read,sha,ROOT


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--banks',type=Path,nargs='+',required=True);ap.add_argument('--replays',type=Path,nargs='+',required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--require-feasible',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    M,rhs,metadata=matrix(a.banks,a.replays);owner=point_vector(a.point);residuals=row_residuals(M,rhs,owner);literal=[]
    for path in a.banks:
        bank=read(path)
        if bank['status']=='EXACT_PRICED_SUPPORT_CANDIDATE':
            frozen=read(path.with_suffix('.frozen.json'));features=target_features(owner,frozen['orbit']);row=metadata[len(literal)]
            literal.append(row['integer_scaling']*(sum(c*x for c,x in zip(frozen['coefficients'],features))-Fraction(bank['upper_bound'])))
        else:
            features=target_features(owner,bank['orbit'])
            for cut in bank['cuts']:literal.append(sum(c*x for c,x in zip(cut['coefficients'],features))-Fraction(cut['upper_bound']))
    assert literal==residuals;feasible=all(v<=0 for v in residuals)
    out={'status':'PASS' if feasible else 'VIOLATED_ACCEPTED_ROWS','source_C16_answered':False,'point_sha256':sha(a.point),'rows_checked':len(residuals),'exact_residuals':list(map(str,residuals)),'all_literal_feature_and_compiled_row_values_agree':True,'banks':metadata,'consumer_sha256':sha(Path(__file__)),'dependencies':{p:sha(ROOT/p) for p in ['accepted_multi_orbit_rows.py','verify_basis_coupling_rows.py','verify_projected_profile_moment_rows.py']},'elapsed_seconds':time.monotonic()-start,'scope':'Exact feasibility of the listed source-necessary linear moment rows; source question remains open.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ('banks','dependencies','exact_residuals')},flush=True)
    if a.require_feasible:assert feasible

if __name__=='__main__':main()
