#!/usr/bin/env python3
"""Exact point evaluation of accepted full-basis rows with literal target check."""
from pathlib import Path
from fractions import Fraction
import argparse, json, time
from accepted_full_partner_rows import matrix
from verify_projected_profile_moment_rows import point_vector, row_residuals
from verify_full_partner_projection import read, sha, ROOT


def target_features(owner, orbit):
    # Direct expanded owner indexing, independent of the compiler's folding.
    def moment(side, h, i, j):
        if h > 8:
            h, i, j = 16-h, j, i
        return owner[45+(0 if side == 'S' else 9*2025)+2025*h+45*i+j]
    return [Fraction(1),16*owner[orbit]]+[16*moment('S',h,orbit,orbit) for h in range(1,9)]+[16*owner[j] for j in range(45)]+[16*moment('T',h,orbit,j) for j in range(45) for h in range(16)]


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--banks',type=Path,nargs='+',required=True);ap.add_argument('--replays',type=Path,nargs='+',required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--require-feasible',action='store_true');ap.add_argument('--expect-violation',type=Fraction);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    M,rhs,metadata=matrix(a.banks,a.replays)
    owner=point_vector(a.point)
    residuals=row_residuals(M,rhs,owner)
    literal=[]
    for path in a.banks:
        bank=read(path);features=target_features(owner,bank['orbit'])
        for cut in bank['cuts']:
            literal.append(sum(c*x for c,x in zip(cut['coefficients'],features))-cut['upper_bound'])
    assert literal==residuals
    maximum=max(residuals,default=Fraction(0));feasible=all(v<=0 for v in residuals)
    if a.expect_violation is not None:assert maximum==a.expect_violation
    out={'status':'PASS' if feasible else 'VIOLATED_ACCEPTED_ROWS','source_C16_answered':False,'point_sha256':sha(a.point),'rows_checked':len(residuals),'exact_residuals':list(map(str,residuals)),'max_exact_residual':str(maximum),'all_literal_feature_and_compiled_row_values_agree':True,'banks':metadata,'consumer_sha256':sha(Path(__file__)),'dependencies':{p:sha(ROOT/p) for p in ['accepted_full_partner_rows.py','verify_full_partner_projection.py','verify_projected_profile_moment_rows.py']},'elapsed_seconds':time.monotonic()-start,'scope':'Exact feasibility of these accepted source-necessary linear moment rows only.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ('banks','dependencies')},flush=True)
    if a.require_feasible:assert feasible


if __name__=='__main__':main()
