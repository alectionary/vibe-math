#!/usr/bin/env python3
"""Independent RAM covariance, numerical-derivative fit, and auxiliary profiling.
No observations are simulated. The algebraic fixture is a covariance matrix only.
"""
import json,sys,time
from pathlib import Path
import numpy as np
import pandas as pd
from scipy.optimize import minimize
from scipy.optimize._numdiff import approx_derivative
from fit_sem import Model,ROOT

def ram_covariance(model,x):
    """Directed-path RAM formulation independent of Model.matrices().
    Node order: observed, first-order, then unit-variance higher/external.
    """
    p,g,q=model.p,model.g,model.q
    d=p+g+q
    A=np.zeros((d,d)); P=np.zeros((d,d))
    # Primary group's marker loadings; external factors have free loadings.
    for j,(factor,items) in enumerate(model.groups.items()):
        A[model.names.index(items[0]),p+j]=1.
    P[p+g:,p+g:]=np.eye(q)
    for v,(typ,i,j,_) in zip(x,model.parameters):
        if typ=='L':
            parent=p+j if j<g else p+g+model.h+(j-g)
            A[i,parent]=v
        elif typ=='B':A[p+i,p+g+j]=v
        elif typ=='psi':P[p+i,p+i]=v
        elif typ=='phi':P[p+g+i,p+g+j]=P[p+g+j,p+g+i]=v
        elif typ=='theta':P[i,j]=P[j,i]=v
    T=np.linalg.inv(np.eye(d)-A)
    return (T@P@T.T)[:p,:p]

def discrepancy(S,Sigma):
    """Normal ML discrepancy computed with slogdet/solve, not Cholesky."""
    ss,ls=np.linalg.slogdet(S); sm,lm=np.linalg.slogdet(Sigma)
    if ss!=1 or sm!=1:return 1e10
    return float(lm+np.trace(np.linalg.solve(Sigma,S))-ls-len(S))

def profiled_joint(S,core_sigma,p):
    """Extend constrained core Sigma via empirical auxiliary conditional law."""
    X=S[:p,:p]; C=S[:p,p:]; D=S[p:,p:]
    beta=np.linalg.solve(X,C)
    omega=D-C.T@beta
    return np.block([[core_sigma,core_sigma@beta],
                     [beta.T@core_sigma,omega+beta.T@core_sigma@beta]])

def main():
    table=pd.read_csv(ROOT/'sources/table_3_2.csv',index_col=0)
    runs=json.loads((ROOT/'outputs/sem_fits.json').read_text())['models']
    result=[]; rng=np.random.default_rng(8675309)
    for run in runs:
        t=time.perf_counter(); model=Model(run['model'],run['external']); x=np.array(run['solution'])
        S=table.loc[model.names,model.names].to_numpy()
        ram=ram_covariance(model,x); direct=model.matrices(x)[0]
        ind_obj=lambda z:discrepancy(S,ram_covariance(model,z))
        start=x+rng.normal(size=len(x))*.005
        start=np.clip(start,*np.array(model.bounds).T)
        # Different covariance expression; optimizer estimates its own gradient.
        independent=minimize(ind_obj,start,method='L-BFGS-B',bounds=model.bounds,
                             options={'maxiter':3000,'ftol':1e-13,'gtol':1e-7,'maxls':50})
        numerical_grad=approx_derivative(lambda z:np.array([ind_obj(z)]),x,method='3-point').ravel()
        analytic_grad=model.objective(x,S)[1]
        lower=np.tril_indices(model.p)
        jac=approx_derivative(lambda z:ram_covariance(model,z)[lower],x,method='3-point')
        singular=np.linalg.svd(jac,compute_uv=False)
        core_theta=model.matrices(x)[5]
        auxiliary=None
        if run['external']:
            aux=[s for s in table.index[:35] if s not in model.names]
            order=model.names+aux; Sfull=table.loc[order,order].to_numpy()
            full=profiled_joint(Sfull,ram,model.p)
            marginal_F=discrepancy(S,ram); joint_F=discrepancy(Sfull,full)
            # If all cross-covariances are assigned only to measurement errors,
            # residual PSD is a separate condition from observed-covariance PSD.
            fulltheta=full.copy(); fulltheta[:model.p,:model.p]=core_theta
            full_npar=model.npar+model.p*len(aux)+len(aux)*(len(aux)+1)//2
            auxiliary=dict(auxiliary_names=aux,core_F=marginal_F,full_F=joint_F,
                abs_F_difference=abs(marginal_F-joint_F),full_df=35*36//2-full_npar,
                full_npar_covariance=full_npar,min_eigen_full_sigma=float(np.linalg.eigvalsh(full).min()),
                min_eigen_residual_only_aux_theta=float(np.linalg.eigvalsh(fulltheta).min()),
                qualification='Exact observed-covariance profile identity; does not certify joint latent residual PSD under a residual-only auxiliary representation.')
        # ML conversion of an unbiased sample covariance multiplies it by
        # (N-1)/N. This model family is closed under a common scale change.
        c=295/296
        scaled_x=x.copy()
        for i,(typ,a,b,_) in enumerate(model.parameters):
            if typ in ('theta','psi'):scaled_x[i]*=c
            elif typ=='B' or (typ=='L' and b>=model.g):scaled_x[i]*=np.sqrt(c)
        scaled_cov=ram_covariance(model,scaled_x)
        scaling=dict(covariance_multiplier=c,
            max_abs_scaled_covariance_error=float(np.max(abs(scaled_cov-c*ram))),
            abs_discrepancy_change=abs(discrepancy(c*S,scaled_cov)-discrepancy(S,ram)),
            chi_square_N295=295*run['F'],chi_square_N296=296*run['F'],
            chi_square_N308=308*run['F'],
            AIC_relative_N295=295*run['F']-2*model.df,
            AIC_relative_N296=296*run['F']-2*model.df,
            AIC_relative_N308=308*run['F']-2*model.df,
            caveat='Changing multiplier to308 does not reconstruct FIML or missing-data likelihood.')
        assert scaling['max_abs_scaled_covariance_error']<1e-12
        assert scaling['abs_discrepancy_change']<1e-10
        # Covariance-only fixture establishes algebra and solver behavior; not participants.
        fixture=model.matrices(model.start)[0]
        fixture_F=discrepancy(fixture,ram_covariance(model,model.start))
        record=dict(model=run['model'],external=run['external'],df=model.df,
          max_abs_covariance_difference=float(np.max(abs(ram-direct))),
          objective_difference=abs(discrepancy(S,ram)-run['F']),
          independent_optimizer_F=float(independent.fun),independent_delta_F=abs(float(independent.fun)-run['F']),
          independent_success=bool(independent.success),independent_message=str(independent.message),
          max_abs_gradient_difference=float(max(abs(analytic_grad-numerical_grad))),
          covariance_jacobian_rank=int(np.linalg.matrix_rank(jac)),npar=model.npar,
          smallest_jacobian_singular_value=float(singular[-1]),
          min_eigen_core_theta=float(np.linalg.eigvalsh(core_theta).min()),
          algebraic_fixture_F=fixture_F,auxiliary_profile=auxiliary,
          normalization_sensitivity=scaling,elapsed_seconds=time.perf_counter()-t)
        assert record['max_abs_covariance_difference']<1e-12
        assert record['objective_difference']<1e-10
        assert record['independent_delta_F']<1e-7
        assert record['max_abs_gradient_difference']<1e-6
        assert record['covariance_jacobian_rank']==model.npar
        assert abs(fixture_F)<1e-12
        if auxiliary:assert auxiliary['abs_F_difference']<1e-10 and auxiliary['full_df']==model.df
        result.append(record)
        print(run['model'],run['external'], 'ind dF',record['independent_delta_F'],'rank',record['covariance_jacobian_rank'],'seconds',record['elapsed_seconds'],flush=True)
    expected=[181,178,179,326,536,311,327,326]
    assert [r['df'] for r in result]==expected
    payload={'seed':8675309,'scope':'Independent algebra/optimization checks of published-correlation ML, not original-data validation.',
      'software':json.loads((ROOT/'outputs/sem_fits.json').read_text())['software'],
      'published_df_order':expected,'all_assertions_passed':True,'models':result}
    (ROOT/'outputs/sem_verification.json').write_text(json.dumps(payload,indent=2)+'\n')
if __name__=='__main__':main()
