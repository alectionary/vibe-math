#!/usr/bin/env python3
"""Exploit the exact zero-pool face before greedy basis separation.

Conditioning on selected X_a leaves exactly127 selected Z vectors orthogonal
to X_a; they form a basis of its127-dimensional hyperplane. Their convex hull
can be separated without wasting projection iterations on off-face bases.
"""
from pathlib import Path
import argparse,hashlib,json,time
import numpy as np
from corrective_matroid_separator import separate
from verify_weighted_matroid_cuts import rank
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--candidate',type=Path,required=True);ap.add_argument('--iterations',type=int,default=600);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();z=np.load(a.candidate);X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];p=z['p'];M={h:z[f'T{h}'] for h in range(9)};M.update({h:M[16-h].T for h in range(9,16)});cuts=[];records=[]
 for anchor in range(45):
  if time.monotonic()-start>a.seconds:break
  if p[anchor]<=1e-10:continue
  ids=[j for j,v in enumerate(Z) if not (X[16*anchor]&v).bit_count()%2];V=[Z[j] for j in ids];r=rank(V);assert r==127
  x=np.array([M[j%16][anchor,j//16] for j in ids])/p[anchor];cut,diag=separate(V,x,iterations=a.iterations)
  record={'sector':'T','anchor_orbit':anchor,'zero_pool_size':len(ids),'zero_pool_rank':r,'normalized_zero_pool_mass':float(x.sum()),**diag};records.append(record)
  if cut:
   cut['indices']=sorted(ids[j] for j in cut['indices']);cut.update(sector='T',anchor_orbit=anchor,mandatory_index=None,candidate_violation=cut['normalized_candidate_violation']*float(p[anchor]),zero_pool_face=True);cuts.append(cut)
  print(anchor,diag,'size',len(cut['indices']) if cut else None,flush=True)
 out={'status':'CANDIDATE_RANK_CUTS','source_C16_answered':False,'candidate_sha256':hashlib.sha256(a.candidate.read_bytes()).hexdigest(),'separator_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'iterations_per_anchor_cap':a.iterations,'outer_seconds':a.seconds,'records':records,'cuts':cuts,'elapsed_seconds':time.monotonic()-start,'scope':'Opposite-sector conditional zero-pool face only. Exact rank replay still required; bounded nonseparation is not membership. Final cuts have ordinary physical rank bounds and do not rely on floating projection accuracy.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('CUTS',len(cuts),'seconds',out['elapsed_seconds'],flush=True)
if __name__=='__main__':main()
