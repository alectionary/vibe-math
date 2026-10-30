"""Original numerical checks and reconstructed illustrations; no raw-data refits."""
import json, pathlib, math
import numpy as np
import matplotlib;matplotlib.use('Agg')
import matplotlib.pyplot as plt
rng=np.random.default_rng(305);out={}
# Independent covariance generator for Ch2: direct MVN versus R hierarchical construction.
n=200000;a=rng.multivariate_normal([0,0],[[.5,.25],[.25,.5]],n);c=rng.normal(0,math.sqrt(.3),(n,1));e=rng.normal(0,math.sqrt(.2),(n,2));theta=a+c+e
out['ch2_covariance']={'expected_DZ':[[1,.55],[.55,1]],'generated':np.cov(theta.T).tolist(),'N':n,'shared':'Same model/design; Python MVN differs from R conditional generator; no independent empirical data.'}
out['delta']={str(d):math.log(d)/math.sqrt(.5) for d in [1,1.3,1.5,1.7]}
out['figure1_3_qualitative']={'assumed_difficulties':[-.5,.5],'check':'For every theta in [-3,3], logistic(theta+.5)>logistic(theta-.5); at theta=b probability .5. Exact source simulated item difficulties/seeds unavailable.','passed':bool(np.all(1/(1+np.exp(-np.linspace(-3,3,101)-.5)) > 1/(1+np.exp(-np.linspace(-3,3,101)+.5))))}
p=.5;eps=1e-5;prob=lambda t:1/(1+math.exp(-2*t));derivative=(prob(eps)-prob(-eps))/(2*eps)
out['eq3_4_information']={'setting':'slope a=2; theta=b=0','literal_printed_P_times_1minusP':p*(1-p),'finite_difference_score_information':derivative**2/(p*(1-p)),'expected_a_squared_P_times_1minusP':1.,'limit':'Printed expression agrees when a=1; actual Figure3.2 implementation not obtained.'}
# Printed posterior means inserted into nonlinear expressions: not posterior summaries.
out['ch3_summary_reconstruction']={'E_SD_ratio':math.exp(2.0837*math.sqrt(.0552)),'C_SD_ratio':math.exp(2.6159*math.sqrt(.0552)),'h2_ratio_of_means':.0552/(.0552+.0054+.0151),'source_h2_mean':.7286}
out['ch4_summary_reconstruction']={'h2_item_ratio_of_means':.43/(.43+.29+.07),'source_h2_mean':.54,'h2_sum_ratio_of_means':.64/(.64+.35+.53),'source_h2_sum_mean':.42,'beta1_item_minus_sum':-2.81-.10,'gamma1_item_minus_sum':.54-(-2.21)}
# Eq4.6--4.9 as rendered at zero theta and thresholds; AppendixB softmax separately.
out['ch4_probability_check']={'setting':'theta=0; alpha=1; beta1=beta2=0','printed_equation_probabilities':[.5,.5,.25],'printed_sum':1.25,'appendixB_softmax':[1/3]*3,'appendixB_sum':1.0,'scope':'Counterexample to literal printed expressions; not a test of fitted data/model implementation.'}
# Binary moderator sign ambiguity: two paths, identical endpoint covariance.
b2=.5;b3=.2;alternative=-2*b2-b3
out['appendixC_check']={'b2':b2,'b3':b3,'alternative_b3':alternative,'variance_at_M0':[b2*b2]*2,'variance_at_M1':[(b2+b3)**2,(b2+alternative)**2],'loglinear_unique_endpoints':[math.log(.25),math.log(.49/.25)],'limit':'Identified endpoint variances do not prove global likelihood uniqueness or identify a continuous-moderator path at all M.'}
# Chapter6 algebra independently by linear transformation of latent covariance.
for q in range(2,6):
 W=np.full((q,q),.1);np.fill_diagonal(W,1);B=np.full((q,q),.5);np.fill_diagonal(B,1);S=W+B;b=np.full(q,math.sqrt(.64/(q*(2+.6*(q-1)))))
 X=np.block([[S,B],[B,S]]);res=np.array([[1,.55],[.55,1]])
 base=np.zeros((2+2*q,2+2*q));base[:2,:2]=res;base[2:,2:]=X
 transform=np.eye(2+2*q);transform[0,2:2+q]=b;transform[1,2+q:]=b
 covariance=transform@base@transform.T
 out[f'ch6_covariance_q{q}']={'variance':float(covariance[0,0]),'explained_fraction':.64/1.64,'min_eigenvalue':float(np.linalg.eigvalsh(covariance).min()),'beta':b.tolist(),'expected_y_crosscov_DZ':float(.55+b@B@b),'computed_y_crosscov_DZ':float(covariance[0,1])}
out['ch6_missing_arithmetic']={'missing_covariates':533+417+482,'denominator':1980*4,'percent':100*1432/7920,'remaining_after_deletion':1980-496,'remaining_percent':100*1484/1980,'source_phenotype_missing':120,'sum_of_stated_reasons':66+33+6+2+23,'interpretation':'Reasons may overlap; not proof of a data error.'}
fig,axs=plt.subplots(1,2,figsize=(9,3.6))
for ax,h in zip(axs,[1,.5]):
 A=rng.normal(0,math.sqrt(h),10000);P=A+rng.normal(0,math.sqrt(1-h),10000);ax.scatter(A,P,s=1,alpha=.12);ax.set(title=f'Figure 7.1 reconstruction: h²={h}',xlabel='Genetic value',ylabel='Phenotypic value');out[f'ch7_correlation_h{h}']={'expected':math.sqrt(h),'ours':float(np.corrcoef(A,P)[0,1]),'N':10000}
fig.tight_layout();fig.savefig('outputs/ch7-illustration.pdf');plt.close(fig)
fig,axs=plt.subplots(1,2,figsize=(9,3.6))
for ax,label,va,vc,ve,g,b in [(axs[0],'Ch3 mathematics',.0552,.0054,.0151,2.6159,2.0837),(axs[1],'Ch4 liberalism',.43,.29,.07,.54,-2.81)]:
 A=np.linspace(-2*math.sqrt(va),2*math.sqrt(va),100);ax.plot(A,vc*np.exp(g*A),label='Shared environment');ax.plot(A,ve*np.exp(b*A),label='Unique environment');ax.set(title=label,xlabel='Genetic value',ylabel='Conditional variance');ax.legend(fontsize=8)
fig.suptitle('Published mean-parameter reconstructions; no posterior bands');fig.tight_layout();fig.savefig('outputs/conditional-variance.pdf');plt.close(fig)
A=rng.normal(0,math.sqrt(.0552),10000);C=rng.normal(size=10000)*np.sqrt(.0054*np.exp(2.6159*A));E=rng.normal(size=(10000,2))*np.sqrt(.0151*np.exp(2.0837*A))[:,None];T=A[:,None]+C[:,None]+E
fig,ax=plt.subplots(figsize=(4.5,4));ax.scatter(T[:,0],T[:,1],s=1,alpha=.15);ax.set(xlabel='Twin 1 latent trait',ylabel='Twin 2 latent trait',title='Figure 3.1 reconstruction: 10,000 MZ pairs');fig.tight_layout();fig.savefig('outputs/ch3-mz-illustration.pdf');plt.close(fig)
out['ch3_simulated_pairs']={'N':10000,'mean_assumption':0,'correlation':float(np.corrcoef(T.T)[0,1]),'scope':'Published mean-parameter reconstruction; source random seed and joint-posterior credible band unavailable'}
pathlib.Path('outputs/analytic-checks.json').write_text(json.dumps(out,indent=2))
