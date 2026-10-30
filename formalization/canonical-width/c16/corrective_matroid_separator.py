"""Bounded basis projection with periodic fully corrective simplex QPs.

Only rank-prefix cuts are accepted, by the separate exact consumer. Numerical
QP success or small distance never certifies matroid-polytope membership.
"""
import time
import numpy as np
from scipy.optimize import minimize
from weighted_matroid_separator import greedy,prefix_cut

def separate(vectors,x,mandatory=None,iterations=200,tolerance=1e-5):
 n=len(vectors);chosen=greedy(vectors,x,mandatory);z=np.zeros(n);z[chosen]=1;vertices={tuple(sorted(chosen)):1.0};lastgap=None;corrections=accepted=0;corrective_seconds=0.0
 for it in range(iterations+1):
  c=x-z;cut=prefix_cut(vectors,x if it==0 else c,x,mandatory,tolerance)
  if cut is not None:cut.update(iteration=it,projection_iterations=it);return cut,{'iterations':it,'cut_found':True,'basis_vertices':len(vertices),'corrective_QPs':corrections,'accepted_corrections':accepted,'corrective_seconds':corrective_seconds}
  key=tuple(sorted(greedy(vectors,c,mandatory)));v=np.zeros(n);v[list(key)]=1;fw=v-z;fwgap=float(c@fw);lastgap=fwgap
  if fwgap<1e-11:break
  away_key=min(vertices,key=lambda k:sum(c[list(k)]));w=np.zeros(n);w[list(away_key)]=1;away=z-w;awaygap=float(c@away);use_away=awaygap>fwgap and vertices[away_key]<1-1e-12;direction=away if use_away else fw;limit=vertices[away_key]/(1-vertices[away_key]) if use_away else 1.0;step=min(limit,max(0.0,float(c@direction)/float(direction@direction)))
  if step<1e-14:break
  if use_away:
   vertices={k:alpha*(1+step) for k,alpha in vertices.items()};vertices[away_key]-=step
  else:
   vertices={k:alpha*(1-step) for k,alpha in vertices.items()};vertices[key]=vertices.get(key,0.0)+step
  vertices={k:alpha for k,alpha in vertices.items() if alpha>1e-13};z+=step*direction
  if (it+1)%20==0 and len(vertices)>1:
   t=time.monotonic();keys=list(vertices);B=np.zeros((n,len(keys)))
   for j,k in enumerate(keys):B[list(k),j]=1
   W=B-x[:,None];Q=W.T@W;alpha=np.array([vertices[k] for k in keys]);alpha/=alpha.sum();old=float(alpha@Q@alpha);result=minimize(lambda a:0.5*float(a@Q@a),alpha,jac=lambda a:Q@a,method='SLSQP',bounds=[(0,1)]*len(keys),constraints=[{'type':'eq','fun':lambda a:float(a.sum()-1),'jac':lambda a:np.ones(len(a))}],options={'maxiter':120,'ftol':1e-13,'disp':False});corrections+=1
   proposal=np.maximum(np.asarray(result.x),0)
   if np.all(np.isfinite(proposal)) and proposal.sum()>0:
    proposal/=proposal.sum()
    if float(proposal@Q@proposal)<=old+1e-12:
     vertices={k:float(a) for k,a in zip(keys,proposal) if a>1e-13};total=sum(vertices.values());vertices={k:a/total for k,a in vertices.items()};z=sum((a*B[:,j] for j,k in enumerate(keys) if (a:=vertices.get(k,0))));accepted+=1
   corrective_seconds+=time.monotonic()-t
 return None,{'iterations':it,'cut_found':False,'basis_vertices':len(vertices),'last_FW_gap':lastgap,'projection_distance':float(np.linalg.norm(x-z)),'corrective_QPs':corrections,'accepted_corrections':accepted,'corrective_seconds':corrective_seconds}
