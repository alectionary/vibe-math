"""Deterministic symbolic checks only: no sampling, fitting, or source-model edits."""
import hashlib,json
from pathlib import Path
import sympy as sp
root=Path(__file__).resolve().parents[1]
t,b,s=sp.symbols('theta b score',real=True)
a,v=sp.symbols('a v',real=True)
checks=[]
def check(name, expr):
    assert bool(expr),name
    checks.append(name)
p=1/(1+sp.exp(b-t));one=s*t-sp.log(1+sp.exp(t-b))
check('one_item_first_derivative',sp.simplify(sp.diff(one,t)-(s-p))==0)
check('one_item_second_derivative',sp.simplify(sp.diff(one,t,2)+p*(1-p))==0)
# Aggregate Hessian identities; d denotes the nonnegative item-likelihood curvature.
d=sp.symbols('d',nonnegative=True)
q=sp.Rational(1,10)
f2=sp.Rational(1,2)*a*a+q*v*v/2+a*v
h2=sp.hessian(f2,(a,v))+sp.diag(d,0)
check('C2_slice_Hessian',h2==sp.Matrix([[1+d,1],[1,q]]))
check('C2_determinant',sp.simplify(h2.det()-(q*(1+d)-1))==0)
d2=sp.Rational(120000,1002001) # 120 Bernoulli curvatures at exp(a)=1000,b=0.
check('C2_rational_fixture_negative_determinant',h2.det().subs(d,d2)<0)
check('C2_general_calibration_bound',h2.det().subs(d,sp.Rational(1,2))<0)
check('C2_explicit_negative_direction',((sp.Matrix([1,-10]).T*h2*sp.Matrix([1,-10]))[0]).subs(d,d2)<0)
f5=sp.exp(-v)*a*a/2+q*v*v/2+v/2
h5=sp.hessian(f5,(a,v))+sp.diag(d,0)
expected=sp.Matrix([[sp.exp(-v)+d,-a*sp.exp(-v)],[-a*sp.exp(-v),a*a*sp.exp(-v)/2+q]])
check('C5_slice_Hessian',sp.simplify(h5-expected)==sp.zeros(2))
check('C5_v0_determinant',sp.simplify(h5.det().subs(v,0)-(q-a*a/2+d*(a*a/2+q)))==0)
# exp(10)>2**10 from exp(1)>2, hence each logistic curvature at a=10,b=0 is <1/1024.
d5_upper=sp.Rational(120,1024)
check('C5_exact_fixture_determinant_upper_bound_negative',h5.det().subs({v:0,a:10,d:d5_upper})<0)
check('C5_general_calibration_bound_a1',h5.det().subs({v:0,a:1,d:sp.Rational(1,10)})<0)
check('C5_bound_determinant_decreases_in_positive_a',sp.simplify(sp.diff(h5.det().subs({v:0,d:sp.Rational(1,10)}),a)+sp.Rational(9,10)*a)==0)
# Explicit proper-Gaussian precision example. General SPD proof is written separately.
Q=sp.Matrix([[2,-1],[-1,2]])
check('Gaussian_precision_example_SPD',Q[0,0]>0 and Q.det()>0)
check('Gaussian_augmented_curvature_SPD',(Q+sp.diag(sp.Rational(1,4),0)).det()>0)
result={'scope':'Symbolic differentiation and exact rational witnesses supporting ordinary proofs; not Monte Carlo, model fitting, a multiple-maxima witness or a marginal likelihood theorem.','checks_passed':len(checks),'checks':checks,'C2_fixture_determinant':str(h2.det().subs(d,d2)),'C5_fixture_determinant_upper_bound':str(h5.det().subs({v:0,a:10,d:d5_upper})),'runtime':{'sympy':sp.__version__},'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'sampling_runs':0,'model_fits':0}
(root/'outputs/score-stage-concavity-checks.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
