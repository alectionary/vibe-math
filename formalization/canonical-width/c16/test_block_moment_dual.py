#!/usr/bin/env python3
"""Source-witness and corrupted-certificate controls for the exact block dual."""
from pathlib import Path
from collections import defaultdict
import argparse,json,copy
from block_moment_dual import patterns_from_source,layout,source_constraints,verify
from verify_inverse_lift import vp,mp,outer,shifts,parts,MASK
from audit_pools import exchange
from verify_partial_frame import shift,mask

def main():
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();root=Path(__file__).parent;source=json.loads((root/'inversion-results/normal-form.json').read_text());cert=json.loads(a.certificate.read_text());q=source['dictionary'];A=list(map(vp,q['X_left_dictionary']));B=list(map(vp,q['X_right_factors']));C=list(map(vp,q['Z_left_factors']));D=list(map(vp,q['Z_right_dictionary']));mx={};mz={}
 for i,v in enumerate(A):
  for h,x in enumerate(shifts(outer(v,B[4]))):mx[x]=(i,h)
 for c in range(5):
  for j,d in enumerate([D[3],D[5]]):
   for h,z in enumerate(shifts(outer(C[c],d))):mz[z]=(2*c+j,h)
 physical=json.loads((root/'physical-pool-source.json').read_text());zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp];xi={v:i for i,v in enumerate(xp)};zi={v:i for i,v in enumerate(zp)};sx=list(map(mp,source['tensor']['X_tensor_coordinates']));sz=list(map(mp,source['tensor']['Z_tensor_coordinates']));masks=[0]*20;pairs=[]
 for pair in json.loads((root/'partial-frame-88.json').read_text())['pairs']:
  x=sx[xi[mask(pair['X'])]];z=sz[zi[mask(pair['Z'])]]
  if x not in mx:continue
  assert z in mz;i,h=mx[x];j,k=mz[z];masks[i]|=1<<h;masks[10+j]|=1<<k;pairs.append((x,z))
 assert len(pairs)==40;patterns=patterns_from_source(source,4);eq,ineq,(pidx,Cidx,V)=source_constraints(patterns,16,40);v=[None]*V
 for i in range(20):v[pidx[i]]=masks[i].bit_count()
 for h in range(9):
  for i in range(20):
   for j in range(20):
    val=sum((masks[i]>>u&1)*(masks[j]>>((u+h)%16)&1) for u in range(16));k=Cidx[h][i][j]
    if v[k] is None:v[k]=val
    else:assert v[k]==val
 assert None not in v and all(0<=w<=16 for w in v)
 for coeff,rhs in eq:assert sum(v[j]*c for j,c in coeff)==16*rhs
 for coeff,rhs in ineq:assert sum(v[j]*c for j,c in coeff)<=16*rhs
 controls=[]
 for mutation in ['pattern','inequality_sign','invalid_source_row','indefinite_dual']:
  d=copy.deepcopy(cert)
  if mutation=='pattern':d['patterns'][0][0]^=1
  if mutation=='inequality_sign':next(t for t in d['linear_terms'] if t['kind']=='ineq' and t['multiplier']>0)['multiplier']*=-1
  if mutation=='invalid_source_row':d['linear_terms'][0]['rhs']+=17
  if mutation=='indefinite_dual':d['constant']=-abs(d['constant'])-10*d['denominator']
  try:verify(d,source)
  except (AssertionError,ValueError,__import__('numpy').linalg.LinAlgError):controls.append({'mutation':mutation,'rejected':True})
  else:raise AssertionError('Corrupt dual accepted: '+mutation)
 r={'status':'PASS','known_physical_partial_pairs':40,'exact_positive_equality_rows':len(eq),'exact_positive_inequality_rows':len(ineq),'source_moment_variables':V,'certificate_negative_controls':controls};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
if __name__=='__main__':main()
