#!/usr/bin/env python3
"""Our exact algebra checks supporting, not replacing, the accompanying proof."""
import json
from fractions import Fraction as F
from pathlib import Path
import sympy as sp

checks = {}
A, C, E = sp.symbols('A C E')
km, kd, t = A+C, A/2+C, A+C+E
checks['ace_inversion'] = all(sp.simplify(x-y)==0 for x,y in [(2*(km-kd),A),(2*kd-km,C),(t-km,E)])
m0,m1=sp.symbols('m0 m1')
checks['two_point_affine_determinant'] = sp.det(sp.Matrix([[1,m0],[1,m1]])) == m1-m0
# Exponential Wronskian factors into exp(sum(lambda)*m) times Vandermonde.
# These finite symbolic checks corroborate the written Rolle proof; they do not prove it.
for r in range(1,5):
    lam=sp.symbols('l:'+str(r))
    det=sp.det(sp.Matrix([[x**k for x in lam] for k in range(r)]))
    prod=sp.prod(lam[j]-lam[i] for i in range(r) for j in range(i+1,r))
    checks[f'vandermonde_{r}'] = sp.expand(det-prod)==0
mz, dz = (0,1,2,3), (4,5,6,7)
checks['example_disjoint_four_level_design'] = not(set(mz)&set(dz)) and len(set(mz))==len(set(dz))==4
rows=[]
for m in mz+dz:
    a,c,e=F(1,4)*2**m,F(1,8)*3**m,F(1,2)*5**m
    km,kd,t=a+c,a/2+c,a+c+e
    assert (2*(km-kd),2*kd-km,t-km)==(a,c,e)
    rows.append({'m':m,'A':str(a),'C':str(c),'E':str(e),'K_MZ':str(km),'K_DZ':str(kd),'T':str(t)})
checks['rational_design_covariance_inversion'] = True
checks['equal_slope_cancellation_example'] = sp.expand((A+C)-(C+A))==0
assert all(checks.values())
result={'purpose':'Our exact supporting algebra; general zero-count and identification proofs are ordinary written mathematics, not inferred from fixtures.', 'checks':checks,'all_passed':all(checks.values()),'rational_example':rows,'sympy_version':sp.__version__,'model_fits':0,'numerical_integration':0}
out=Path(__file__).resolve().parents[1]/'outputs/continuous-moderator-identification-checks.json'
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'output':str(out),'checks_passed':len(checks)}))
