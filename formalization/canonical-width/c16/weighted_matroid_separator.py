#!/usr/bin/env python3
"""Discover conditional rank inequalities with greedy basis-oracle projections.

Numerical projection only proposes subsets. Every saved bound is an exact
binary rank, independently replayable without the projection algorithm.
"""
from pathlib import Path
import argparse,hashlib,json,time
import numpy as np
ROOT=Path(__file__).resolve().parent

def insert(piv,v):
 while v:
  p=v.bit_length()-1
  if p not in piv:piv[p]=v;return True
  v^=piv[p]
 return False

def greedy(vectors,weights,mandatory=None):
 piv={};chosen=[]
 if mandatory is not None:assert insert(piv,vectors[mandatory]);chosen=[mandatory]
 for i in sorted(range(len(vectors)),key=lambda i:(-weights[i],i)):
  if i==mandatory:continue
  if insert(piv,vectors[i]):chosen.append(i)
 return chosen

def prefix_cut(vectors,weights,x,mandatory=None,tolerance=1e-5):
 piv={};has=False;total=0.0;ids=[];best=None
 if mandatory is not None:assert insert(piv,vectors[mandatory])
 for i in sorted(range(len(vectors)),key=lambda i:(-weights[i],i)):
  ids.append(i);total+=float(x[i]);insert(piv,vectors[i]);has|=i==mandatory
  bound=len(piv)-(1 if mandatory is not None and not has else 0)
  violation=total-bound
  if violation>tolerance and (best is None or violation>best['normalized_candidate_violation']):best={'indices':sorted(ids),'bound':bound,'normalized_candidate_violation':violation,'augmented_rank':len(piv),'mandatory_in_subset':bool(has)}
 return best

def separate(vectors,x,mandatory=None,iterations=200,tolerance=1e-5):
 n=len(vectors);chosen=greedy(vectors,x,mandatory);z=np.zeros(n);z[chosen]=1;vertices={tuple(sorted(chosen)):1.0};best=None;lastgap=None
 for it in range(iterations+1):
  c=x-z
  # Check both the current residual and the original fractional ordering.
  cut=prefix_cut(vectors,x if it==0 else c,x,mandatory,tolerance)
  if cut is not None:cut.update(iteration=it,projection_iterations=it);return cut,{'iterations':it,'cut_found':True,'basis_vertices':len(vertices)}
  key=tuple(sorted(greedy(vectors,c,mandatory)));v=np.zeros(n);v[list(key)]=1;fw=v-z;fwgap=float(c@fw);lastgap=fwgap
  if fwgap<1e-10:break
  away_key=min(vertices,key=lambda k:sum(c[list(k)]));w=np.zeros(n);w[list(away_key)]=1;away=z-w;awaygap=float(c@away)
  use_away=awaygap>fwgap and vertices[away_key]<1-1e-12
  direction=away if use_away else fw;limit=vertices[away_key]/(1-vertices[away_key]) if use_away else 1.0;step=min(limit,max(0.0,float(c@direction)/float(direction@direction)))
  if step<1e-14:break
  if use_away:
   vertices={k:alpha*(1+step) for k,alpha in vertices.items()};vertices[away_key]-=step
  else:
   vertices={k:alpha*(1-step) for k,alpha in vertices.items()};vertices[key]=vertices.get(key,0.0)+step
  vertices={k:alpha for k,alpha in vertices.items() if alpha>1e-13};z+=step*direction
 return None,{'iterations':it,'cut_found':False,'basis_vertices':len(vertices),'last_FW_gap':lastgap,'projection_distance':float(np.linalg.norm(x-z))}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--iterations',type=int,default=200);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();arrays=np.load(a.candidate);p=arrays['p'];pools=[[int(v,16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in 'xz'];cuts=[];records=[]
 for side in 'ST':
  for anchor in range(45):
   if time.monotonic()-start>a.seconds:break
   if p[anchor]<=1e-10:continue
   M={h:arrays[f'{side}{h}'] for h in range(9)};M.update({h:M[16-h].T for h in range(9,16)});x=np.array([M[h][anchor,o] for o in range(45) for h in range(16)])/p[anchor];mandatory=16*anchor if side=='S' else None
   cut,diag=separate(pools[0 if side=='S' else 1],x,mandatory,a.iterations)
   record={'sector':side,'anchor_orbit':anchor,'first_moment':float(p[anchor]),**diag};records.append(record)
   if cut:
    cut.update(sector=side,anchor_orbit=anchor,mandatory_index=mandatory,candidate_violation=cut['normalized_candidate_violation']*float(p[anchor]));cuts.append(cut)
   print(side,anchor,diag,'cut_size',len(cut['indices']) if cut else None,flush=True)
  if time.monotonic()-start>a.seconds:break
 out={'status':'CANDIDATE_RANK_CUTS','source_C16_answered':False,'candidate_sha256':hashlib.sha256(a.candidate.read_bytes()).hexdigest(),'source_hashes':{f'pools/{side}coords.txt':hashlib.sha256((ROOT/f'pools/{side}coords.txt').read_bytes()).hexdigest() for side in 'xz'},'iterations_per_anchor_cap':a.iterations,'outer_seconds':a.seconds,'records':records,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,'scope':'Bounded numerical greedy-basis projection proposes conditional rank subsets. Exact rank replay required before model use. Nonseparation does not prove matroid-polytope membership or source completion.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('CUTS',len(cuts),'seconds',out['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
