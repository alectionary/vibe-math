#!/usr/bin/env python3
"""Our exact algebra for Chapter2 fixed-parameter latent moments; no item integration."""
import json
from pathlib import Path
import sympy as s
va,vc,ve=s.symbols('va vc ve',positive=True)
b,t=s.symbols('beta t',real=True)
mgf=s.exp(va*t*t/2)
R=ve*mgf.subs(t,b)
T=va+vc+R
km,kd=va+vc,va/2+vc
m3=3*ve*s.diff(mgf,t).subs(t,b)
checks={}
checks['gaussian_mgf_derivative']=s.simplify(s.diff(mgf,t)-va*t*mgf)==0
checks['third_central_moment']=s.simplify(m3-3*va*b*R)==0
ar=2*(km-kd);cr=2*kd-km;rr=T-ar-cr;br=m3/(3*ar*rr)
checks['recover_va']=s.simplify(ar-va)==0
checks['recover_vc']=s.simplify(cr-vc)==0
checks['recover_R']=s.simplify(rr-R)==0
checks['recover_beta']=s.simplify(br-b)==0
checks['recover_ve']=s.simplify(rr*s.exp(-br*br*ar/2)-ve)==0
checks['beta_zero_gaussian_variance']=s.simplify(T.subs(b,0)-(va+vc+ve))==0
checks['beta_zero_third_moment']=m3.subs(b,0)==0
checks['va_zero_beta_disappears']=s.simplify(R.subs(va,0)-ve)==0 and m3.subs(va,0)==0
x,h,z=s.symbols('x h z',real=True)
# Conditional on genetic/common effects x=A+C and h=sqrt(ve*exp(beta*A)),
# integrate cubic in independent standard normal Z using its exact first3moments.
cubic=s.Poly(s.expand((x+h*z)**3),z)
normal_moments={0:s.Integer(1),1:s.Integer(0),2:s.Integer(1),3:s.Integer(0)}
conditional=sum(coef*normal_moments[power[0]] for power,coef in cubic.terms())
checks['conditional_cubic']=s.simplify(conditional-(x**3+3*x*h*h))==0
# Conditional cross residual expectation uses E[Z1 Z2]=0 even if h1=h2.
z1,z2,h1,h2,x1,x2=s.symbols('z1 z2 h1 h2 x1 x2')
poly=s.Poly((x1+h1*z1)*(x2+h2*z2),z1,z2)
conditional_cross=sum(coef*normal_moments[powers[0]]*normal_moments[powers[1]] for powers,coef in poly.terms())
checks['conditional_cross_covariance']=s.simplify(conditional_cross-x1*x2)==0
examples=[]
for beta in [s.Rational(-2,3),s.Integer(0),s.Rational(2,3)]:
 vals={va:s.Rational(3,2),vc:s.Rational(1,4),ve:s.Rational(2,5),b:beta}
 got=[s.simplify(q.subs(vals)) for q in [ar,cr,br,rr*s.exp(-br*br*ar/2)]]
 assert got==[vals[va],vals[vc],beta,vals[ve]]
 examples.append({'beta':str(beta),'R':str(R.subs(vals)),'third_central_moment':str(m3.subs(vals)),'recovered':[str(v) for v in got]})
checks['positive_negative_zero_exact_witnesses']=True
assert all(checks.values())
result={'purpose':'Our exact fixed-parameter latent-moment algebra; conditional independence and Gaussian moments are proved/discussed in the accompanying ordinary proof. No finite item-response identification asserted.','checks':checks,'all_passed':True,'exact_examples':examples,'sympy_version':s.__version__,'model_fits':0,'numerical_integration':0,'monte_carlo':0}
out=Path(__file__).resolve().parents[1]/'outputs/non-gaussian-latent-moment-checks.json'
out.write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'output':str(out),'checks_passed':len(checks)}))
