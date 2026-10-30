"""Check C5-1 algebra and a finite-sample MLE existence counterexample.

Run from the study root. Symbolic algebra and exact rational witnesses validate
these restricted statements; this is not a Lean proof or an identification proof
for the full marginal item-response model.
"""
import datetime, hashlib, json, pathlib, argparse, subprocess, tempfile
parser=argparse.ArgumentParser();parser.add_argument("--source-pdf");args=parser.parse_args()
if args.source_pdf:
 from PIL import Image
 source=pathlib.Path(args.source_pdf)
 assert hashlib.sha256(source.read_bytes()).hexdigest()=="67dd29d98bc440b96a197a1ef1771dd3611823bceba428a1f66829ca099d7d28"
 with tempfile.TemporaryDirectory()as temp:
  stem=str(pathlib.Path(temp)/"p72")
  subprocess.run(["pdftoppm","-f","81","-singlefile","-r","600","-png",str(source),stem],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
  scale=600/72
  Image.open(stem+".png").crop(tuple(int(x*scale)for x in (86,380,433.89,415))).save("evidence/p72-identification-claim.png")
import numpy as np
import sympy as sp
from scipy.special import expit
from numpy.polynomial.hermite import hermgauss

A,C,E,km,kd,v=sp.symbols('A C E k_m k_d v', real=True)
recover=(2*(km-kd),2*kd-km,v-km)
sub={km:A+C,kd:A/sp.Integer(2)+C,v:A+C+E}
assert [sp.simplify(x.subs(sub)-truth) for x,truth in zip(recover,(A,C,E))]==[0,0,0]
a,b,m=sp.symbols('a b m',real=True)
reflected=-2*a-b
binary_difference=sp.factor((a+b*m)**2-(a+reflected*m)**2)
assert sp.simplify(binary_difference-4*a*(a+b)*m*(1-m))==0
assert binary_difference.subs(m,0)==0 and binary_difference.subs(m,1)==0
witness={'a':sp.Rational(1,2),'b':sp.Rational(1,5),'reflected_b':sp.Rational(-6,5)}
values=[]
for mm in [sp.Rational(0),sp.Rational(1,2),sp.Rational(1)]:
 values.append({'M':str(mm),'original_variance':str((witness['a']+witness['b']*mm)**2),'reflected_variance':str((witness['a']+witness['reflected_b']*mm)**2)})
# Equality at three distinct moderator levels implies equality of degree<=2
# polynomials. Factoring in R[m], an integral domain, leaves only global +/-.
u,w=sp.symbols('u w',real=True)
assert sp.expand(((a-u)+(b-w)*m)*((a+u)+(b+w)*m)-((a+b*m)**2-(u+w*m)**2))==0
# Numerical quadrature illustrates the all-zero likelihood; the strict monotonic
# proof below does not rely on quadrature accuracy or a finite grid.
x,weights=hermgauss(60);z=np.stack(np.meshgrid(np.sqrt(2)*x,np.sqrt(2)*x,indexing='ij'),axis=-1).reshape(-1,2)
ww=np.outer(weights,weights).ravel()/np.pi
means=[0,-1,-4,-8,-16];illustration=[]
for mu in means:
 pair_probs=[]
 for rho in [.5,.375]: # A=.25,C=.25,E=.5; MZ/DZ latent covariance.
  zz=z@np.linalg.cholesky([[1,rho],[rho,1]]).T
  probs=np.prod(expit(np.array([-.5,.5])[None,None,:]-(mu+zz[:,:,None])),axis=(1,2))
  pair_probs.append(float(ww@probs))
 # One MZ and one DZ family at each binary moderator level; slopes/main effect0.
 likelihood=float(np.prod(np.square(pair_probs)))
 illustration.append({'mu':mu,'MZ_pair_probability':pair_probs[0],'DZ_pair_probability':pair_probs[1],'four_family_likelihood':likelihood})
assert all(0<r['four_family_likelihood']<1 for r in illustration)
assert all(a['four_family_likelihood']<b['four_family_likelihood']for a,b in zip(illustration,illustration[1:]))
record={
 'canonical_result':'C5-1',
 'status':'restricted algebra verified; unrestricted finite-sample unique-maximum assertion needs qualification; full observed-item identifiability remains unresolved',
 'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'source':{'thesis':'Schwabe (2016), Nature, Nurture and Item Response Theory','sha256':'67dd29d98bc440b96a197a1ef1771dd3611823bceba428a1f66829ca099d7d28','locators':['Chapter5 p72 Section5.1.2 (unique likelihood maximum claim)','pp75-76 Eqs5.3-5.15 (latent covariance model)','p84 (monotone logvariance curves)','AppendixC pp138-139 (binary argument and continuous extension)']},
 'contract':'C5-1 continuation: distinguish covariance-map injectivity, sign indeterminacy and finite-sample likelihood existence/uniqueness. Preserve broader item-model identification as unresolved.',
 'coordination':'Internal delegated audit within the already selected whole-dissertation branch. No new research issue, claim, PR or network mutation; parent explicitly prohibited network mutations.',
 'verified_statements':[
  {'name':'Latent covariance inversion','assumptions':'Known conditional latent phenotype variance V(m), both zygosity covariances K_MZ(m),K_DZ(m), common family moderator, equal A/C/E across zygosity, genetic correlations1/.5; model correctly specified and variances positive.','derivation':'V=A+C+E, K_MZ=A+C, K_DZ=A/2+C. Thus A=2(K_MZ-K_DZ), C=2K_DZ-K_MZ, E=V-K_MZ. Substitution gives the identity exactly.','verification':'SymPy simplifies each substituted difference to0.','limit':'This assumes latent covariance functions are identified/known; it does not prove their identifiability from finite binary item vectors.'},
  {'name':'Logvariance coefficients at two moderator levels','assumptions':'Two distinct m0,m1; known positive variance values V0,V1 for a component; V(m)=exp(beta0+beta1*m).','proof':'Take logs. The2x2 design matrix has determinant m1-m0≠0, hence beta1=(log(V1)-log(V0))/(m1-m0), beta0=log(V0)-beta1*m0 uniquely. Same argument covers continuous support containing two distinct levels, conditional on known variance function.','limit':'One moderator value does not identify both coefficients. Injectivity does not ensure a finite or unique likelihood maximum.'},
  {'name':'Binary path sign indeterminacy','assumptions':'Shared binary moderator0/1; component path a+b*m; variance is its square; no restriction requiring the path positive at both endpoints.','proof':'Replace b by -2a-b while keeping a fixed. Endpoints are a and -(a+b), so both squared endpoint values are unchanged. Global(a,b)→(-a,-b) is an additional symmetry. With nonzero a and a+b there are four sign combinations before restrictions; a>0 removes only the global pair. Degenerate zero endpoints can merge solutions.','symbolic_difference':str(binary_difference),'exact_witness':values,'limit':'Equality is for shared-moderator covariance endpoints, not arbitrary separate-twin moderator cross-products.'},
  {'name':'Continuous moderator qualification','assumptions':'Two affine paths agree after squaring at at least three distinct real moderator values.','proof':'Their squared difference is degree≤2 with at least three roots, so it is the zero polynomial. Its factorization is [(a-u)+(b-w)m][(a+u)+(b+w)m]. R[m] is an integral domain, so one affine factor is identically0: (u,w)=(a,b) or(-a,-b). If both intercepts are strictly positive, only equality remains.','verification':'Symbolic polynomial factorization identity passes; exact midpoint witness distinguishes the binary-only reflection:9/25 vs1/100.','limit':'Global sign ambiguity persists on continuous support unless a sign convention is imposed. This does not say the source global-sign statement is false, nor address all full-model likelihood modes.'},
  {'name':'Monotonicity of loglinear variance','proof':'d exp(beta0+beta1*m)/dm=beta1*exp(beta0+beta1*m), with strictly positive exponential. Thus increasing when beta1>0,decreasing when beta1<0,constant when beta1=0.','limit':'Monotonicity of a variance curve is unrelated to convexity/concavity of the marginal likelihood.'}
 ],
 'finite_sample_counterexample':{
  'target':'Unqualified assertion that the logvariance parametrization gives one finite maximum for every data set, p72; not an allegation about the empirical fits.',
  'data':'Any finite nonempty collection of twins with every observed Rasch item response0; include both MZ/DZ and both binary moderator levels if desired. Known finite item difficulties; finite model parameters with positive variances.',
  'proof':'Write each latent trait theta_ij=mu+Z_ij, with joint distribution of Z fixed when other parameters are fixed. Conditional probability of all observed zeros is Q(mu,Z)=product_ijk logistic(b_k-mu-Z_ij). Every factor lies strictly between0and1 and strictly increases as mu decreases, so E[Q] is strictly increasing as mu decreases for every finite parameter vector. By dominated convergence E[Q]→1 as mu→−infinity. At any finite mu,E[Q]<1. Hence the likelihood has supremum1 but no finite maximum; adjusting mu improves every finite candidate even in the full model. This disproves the unqualified existence-and-uniqueness implication, not population identifiability.',
  'Bayesian_limit':'A proper normal prior on mu changes the posterior objective; this likelihood counterexample neither proves posterior impropriety nor multimodality. Source Bayesian fits and population identification are separate questions.',
  'illustration':illustration,'quadrature_order_per_dimension':60,'illustration_not_proof':True},
 'remaining':['Establish injectivity of the full marginal item-response model under explicit calibration/support assumptions.','Analyze finite-sample interior likelihood stationary points under nondegenerate data; this counterexample does not show multiple maxima for the source samples.','Empirical posterior and production recovery remain dependent on missing data/converged chains.'],
 'verification':{'python':'3.12','sympy':sp.__version__,'exact_symbolic_assertions':'passed','rational_witness':'passed','finite_quadrature_monotonic_illustration':'passed','Lean_formalization':'not performed; ordinary written proof plus computer algebra, no formal certification claim'},
 'source_ink':{'path':'evidence/p72-identification-claim.png','page':'printed72/PDF81','render_dpi':600,'crop_points':[86,380,433.89,415],'sha256':hashlib.sha256(pathlib.Path('evidence/p72-identification-claim.png').read_bytes()).hexdigest(),'rights':'Limited attributed scholarly crop; copyright remains with Schwabe (2016); not full-source redistribution.'},
 'script':'simulation/identification_check.py'
}
pathlib.Path('provenance/identification-check.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'status':record['status'],'exact_witness':values,'likelihood_illustration':illustration},indent=2))
