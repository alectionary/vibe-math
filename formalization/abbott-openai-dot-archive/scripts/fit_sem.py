#!/usr/bin/env python3
"""Normal-theory covariance ML on published rounded correlations, never raw data.

Sigma = L [diag(psi) + B Phi B'] L' + Theta.
First-order item groups have marker loading 1; higher-order and external
factor variances are 1. Free means contribute equally and are profiled out.
The objective is log|Sigma| + tr(S Sigma^-1) - log|S| - p.
"""
from pathlib import Path
import argparse, json, time, platform
import numpy as np
import pandas as pd
import scipy
from scipy.optimize import minimize, check_grad
from scipy.linalg import cho_factor, cho_solve
ROOT=Path(__file__).resolve().parents[1]
SPEC=json.loads((ROOT/'sources/model_specifications.json').read_text())

class Model:
    def __init__(self, kind='refined', external=False):
        groups={k:list(v) for k,v in SPEC['revised_groups'].items()}
        if kind=='all':
            groups={k:[k+str(i) for i in (range(2,6) if k=='CTELAB' else range(1,5))] for k in groups}
        if kind=='held':
            groups={k:[k+str(i) for i in (range(2,4) if k=='CTELAB' else range(1,4))] for k in groups}
        if kind in ('implied_structure','implied_indicators'):
            groups['CTFLUE']=['CTFLUE1','CTFLUE2']
            groups['CTFLEX']=['CTFLEX1','CTFLEX2','CTFLEX3','CTFLEX4']
            groups['CTORIG']=['CTORIG1','CTORIG3','CTORIG4']
            groups['CTELAB']=['CTELAB2','CTELAB4','CTELAB5']
            if kind=='implied_structure':groups['CTFLUE']+=groups.pop('CTFLEX')
        self.kind=kind; self.external=external; self.groups=groups
        self.first=list(groups); self.g=len(groups); self.general=kind=='general'
        self.h=1 if self.general else 2
        ext=SPEC['external_groups'] if external else {}
        self.latents=self.first+list(ext); self.names=sum(list(groups.values()),[])+sum(list(ext.values()),[])
        self.p=len(self.names); self.q=self.h+len(ext); self.k=len(self.latents)
        self.L0=np.zeros((self.p,self.k)); self.B0=np.zeros((self.k,self.q))
        self.parameters=[]; self.start=[]; self.bounds=[]
        def add(typ,i,j,val,bound,label):
            self.parameters.append((typ,i,j,label)); self.start.append(val); self.bounds.append(bound)
        for k,(factor,items) in enumerate(groups.items()):
            for t,item in enumerate(items):
                i=self.names.index(item)
                if t==0:self.L0[i,k]=1
                else:add('L',i,k,.8,(-5,5),f'{factor}=~{item}')
        for e,(factor,items) in enumerate(ext.items()):
            k=self.g+e; self.B0[k,self.h+e]=1
            for item in items:
                i=self.names.index(item); s=-1 if item in ('Open2','Open3','Open4') else 1
                add('L',i,k,.7*s,(-5,5),f'{factor}=~{item}')
        for k,factor in enumerate(self.first):
            add('psi',k,k,.25,(1e-8,5),f'{factor} disturbance')
            h=0 if self.general or factor.startswith('CT') else 1
            add('B',k,h,.7,(1e-7,5),f'{"common" if self.general else ["CTSE","CPSE"][h]}=~{factor}')
        for i in range(self.q):
            for j in range(i):add('phi',i,j,.65 if (i,j)==(1,0) else .4,(-.9999,.9999),f'higher correlation {i},{j}')
        for i,item in enumerate(self.names):add('theta',i,i,.4,(1e-8,5),f'{item} residual')
        pairs=[] if kind=='unrefined' else list(SPEC['refined_residual_covariances'])
        if external:pairs+=SPEC['external_residual_covariances']
        # Appendix J p258 Held syntax has no core residual covariances.
        if kind=='held':pairs=[]
        # A residual covariance is absent when either indicator is a saturated
        # auxiliary, since the whole covariance with that indicator is free.
        for a,b in pairs:
            if a in self.names and b in self.names:
                i,j=self.names.index(a),self.names.index(b)
                add('theta',i,j,0,(-2,2),f'{a}~~{b}')
        self.start=np.asarray(self.start); self.npar=len(self.start)
        self.df=self.p*(self.p+1)//2-self.npar
    def matrices(self,x):
        L=self.L0.copy(); B=self.B0.copy(); phi=np.eye(self.q); psi=np.zeros(self.k); theta=np.zeros((self.p,self.p))
        for v,(typ,i,j,_) in zip(x,self.parameters):
            if typ=='L':L[i,j]=v
            elif typ=='B':B[i,j]=v
            elif typ=='phi':phi[i,j]=phi[j,i]=v
            elif typ=='psi':psi[i]=v
            elif typ=='theta':theta[i,j]=theta[j,i]=v
        C=np.diag(psi)+B@phi@B.T
        sigma=L@C@L.T+theta
        return sigma,L,B,phi,psi,theta,C
    def objective(self,x,S,gradient=True):
        sigma,L,B,phi,psi,theta,C=self.matrices(x)
        try:
            chol=cho_factor(sigma,lower=True); cho_factor(phi,lower=True)
        except np.linalg.LinAlgError:return (1e10,np.zeros_like(x)) if gradient else 1e10
        inv=cho_solve(chol,np.eye(self.p))
        value=2*np.log(np.diag(chol[0])).sum()+np.trace(S@inv)-np.linalg.slogdet(S)[1]-self.p
        if not gradient:return value
        G=inv-inv@S@inv
        LC=L@C; LB=L@B; BP=B@phi
        grad=[]
        for typ,i,j,_ in self.parameters:
            if typ=='L':d=2*(G@LC)[i,j]
            elif typ=='psi':d=L[:,i]@G@L[:,i]
            elif typ=='B':d=2*L[:,i]@G@(L@BP[:,j])
            elif typ=='phi':d=2*LB[:,i]@G@LB[:,j]
            else:d=G[i,i] if i==j else 2*G[i,j]
            grad.append(d)
        return value,np.array(grad)
    def fit(self,S,start=None,method='L-BFGS-B',numerical=False):
        start=self.start.copy() if start is None else start.copy()
        fun=(lambda x:self.objective(x,S,False)) if numerical else (lambda x:self.objective(x,S,True))
        options={'maxiter':3000,'ftol':1e-13,'gtol':1e-8,'maxls':50} if method=='L-BFGS-B' else {'maxiter':2500,'ftol':1e-12}
        t=time.perf_counter()
        r=minimize(fun,start,method=method,jac=None if numerical else True,bounds=self.bounds,options=options)
        r.elapsed=time.perf_counter()-t
        return r
    def summarize(self,r,S,n=296):
        sigma,L,B,phi,psi,theta,C=self.matrices(r.x)
        F=self.objective(r.x,S,False); chi=n*F; base=-n*np.linalg.slogdet(S)[1]; basedf=self.p*(self.p-1)//2
        residual=(S-sigma)/np.sqrt(np.outer(np.diag(S),np.diag(S)))
        standardized_loadings=L*np.sqrt(np.diag(C))[None,:]/np.sqrt(np.diag(sigma))[:,None]
        standardized_higher=B[:self.g,:self.h]/np.sqrt(np.diag(C)[:self.g])[:,None]
        return dict(model=self.kind,external=self.external,n=n,p=self.p,parameters=self.npar,df=self.df,F=F,chi_square_ML=chi,
          CFI_ML=1-max(chi-self.df,0)/max(chi-self.df,base-basedf,0),RMSEA_ML=np.sqrt(max((chi-self.df)/(self.df*n),0)),
          SRMR=float(np.sqrt(np.mean(residual[np.tril_indices(self.p)]**2))),AIC_relative_same_observables=chi-2*self.df,
          latent_correlation=phi.tolist(),first_order_names=self.first,observed_names=self.names,
          standardized_loadings=standardized_loadings.tolist(),standardized_higher=standardized_higher.tolist(),
          success=bool(r.success),message=str(r.message),iterations=int(r.nit),elapsed_seconds=r.elapsed,
          max_abs_gradient=float(abs(self.objective(r.x,S)[1]).max()),min_eigen_sigma=float(np.linalg.eigvalsh(sigma).min()),
          min_eigen_theta=float(np.linalg.eigvalsh(theta).min()),min_eigen_phi=float(np.linalg.eigvalsh(phi).min()),
          solution=r.x.tolist(),parameter_labels=[z[3] for z in self.parameters])

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--quick',action='store_true'); args=ap.parse_args()
    R=pd.read_csv(ROOT/'sources/table_3_2.csv',index_col=0)
    configurations=[('unrefined',False),('refined',False),('general',False),('refined',True),('all',True),('held',True),('implied_structure',True),('implied_indicators',True)]
    records=[]; checks=[]; solutions={}
    for kind,external in configurations:
        model=Model(kind,external); S=R.loc[model.names,model.names].to_numpy()
        # Check formula/analytic gradient against independent finite differences.
        grad_error=check_grad(lambda x:model.objective(x,S,False),lambda x:model.objective(x,S)[1],model.start)
        r=model.fit(S); out=model.summarize(r,S)
        # A second constrained optimizer from a distinct deterministic start.
        start=model.start.copy(); start[:]=start*.95
        r2=model.fit(S,start=start,method='SLSQP'); out2=model.summarize(r2,S)
        if r2.fun<r.fun:r,r2=r2,r; out,out2=out2,out
        records.append(out); solutions[kind+('_external' if external else '')]=out
        checks.append(dict(model=kind,external=external,gradient_L2_error=grad_error,second_optimizer_F=out2['F'],delta_F=abs(out['F']-out2['F']),second_optimizer_success=out2['success'],second_max_abs_gradient=out2['max_abs_gradient']))
        print(kind,external,'df',model.df,'chi',out['chi_square_ML'],'CFI',out['CFI_ML'],'rho',out['latent_correlation'][1][0] if model.q>1 else 1,'sec',out['elapsed_seconds'],'check dF',checks[-1]['delta_F'],flush=True)
    payload=dict(scope='Rounded-summary normal-theory ML sensitivity reconstruction; not original MLR/FIML',sample_note='Table3.2 n296, original FIML n308; no raw observations generated',software=dict(python=platform.python_version(),numpy=np.__version__,scipy=scipy.__version__,pandas=pd.__version__),models=records,verification=checks)
    (ROOT/'outputs/sem_fits.json').write_text(json.dumps(payload,indent=2)+'\n')
    columns=['model','external','n','p','parameters','df','F','chi_square_ML','CFI_ML','RMSEA_ML','SRMR','AIC_relative_same_observables','success','max_abs_gradient','elapsed_seconds']
    pd.DataFrame([{k:r[k] for k in columns} for r in records]).to_csv(ROOT/'outputs/sem_fits.csv',index=False)
if __name__=='__main__':main()
