"""Original algebraic/numerical check; no fitting, sampling or engine modification."""
import itertools,math,json,hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[1]
def softplus(x):return max(x,0)+math.log1p(math.exp(-abs(x)))
def log_joint(theta,b,y):return sum(v*(theta-d)-softplus(theta-d) for d,v in zip(b,y))
def log_score(theta,b,s):
    # Elementary-symmetric coefficients of exp(-difficulty); small fixed fixture.
    c=[1.]+[0.]*len(b)
    for j,d in enumerate(b):
        for k in range(j+1,0,-1):c[k]+=math.exp(-d)*c[k-1]
    return s*theta+math.log(c[s])-sum(softplus(theta-d) for d in b)
b=[-1.2,-.3,.7,1.8];thetas=[-5.,-1.,0.,.7,4.];errors=[]
for y in itertools.product([0,1],repeat=len(b)):
    s=sum(y)
    for t in thetas:
        errors.append(abs((log_joint(t,b,y)-log_joint(0.,b,y))-(log_score(t,b,s)-log_score(0.,b,s))))
normalization=[abs(sum(math.exp(log_score(t,b,s)) for s in range(len(b)+1))-1) for t in thetas]
assert max(errors)<1e-12 and max(normalization)<1e-12
x={'kind':'exact factorization with floating-point fixture checks','model_fits':0,'patterns':16,'theta_contrast_checks':len(errors),'max_abs_loglikelihood_contrast_error':max(errors),'max_abs_score_pmf_normalization_error':max(normalization),'scope':'Known fixed Rasch difficulties and local independence; summed-score probability mass is exact, not Gaussian sum-score approximation. No computational speed or convergence claim.','script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
p=root/'outputs/rasch-sufficiency-check.json';p.write_text(json.dumps(x,indent=2)+'\n');print(json.dumps(x))
