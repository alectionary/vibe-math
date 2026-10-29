#!/usr/bin/env python3
"""Discover and exactly check weighted conditional phase inequalities.

The bound is recomputed by exhaustive integer support evaluation on the complete
already-certified local survivor family. Numeric LP dual status is never proof.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time,math
import numpy as np
from scipy.optimize import linprog
from flint import fmpq
from conditional_profile_hull_witness import allowed,target
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--attempt',type=Path,required=True);ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--x-cohort',type=Path,required=True);ap.add_argument('--z-cohort',type=Path,required=True);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();hulls=json.loads(gzip.decompress(a.hulls.read_bytes()));_,ix,m=layout(hulls);point=json.loads(gzip.decompress(a.point.read_bytes()));v=list(map(fmpq,point['values']));sources={s:(p,json.loads(p.read_text())) for s,p in [('X',a.x_cohort),('Z',a.z_cohort)]};attempt=json.loads(gzip.decompress(a.attempt.read_bytes()));cuts=json.loads(a.certificate.read_text())['cuts'] if a.verify_only else [];reports=[]
 tasks=cuts if a.verify_only else [r for r in attempt['records'] if r['status']!='PASS']
 for task in tasks:
  i=task['anchor_orbit'];sector=task['sector'];o=task['orbit'];cp,cohort=sources[sector];record=next(r for r in cohort['records'] if r['orbit']==i);sp=cp.parent/record['certificate_file'];assert hashlib.sha256(sp.read_bytes()).hexdigest()==record['certificate_sha256'];profile=json.loads(gzip.decompress(sp.read_bytes()));row=next(r for r in profile['records'] if r['orbit']==o);masks=allowed(row,i,sector);q=target(v,ix,m,i,o,sector,row['eligible_mask']);features=((masks[:,None]>>np.arange(16))&1).astype(np.int64)
  if a.verify_only:
   assert task['source_certificate_sha256']==record['certificate_sha256']
   c=np.array(task['coefficients'],dtype=np.int64);b=task['bound'];assert len(c)==16
  else:
   run=linprog(np.r_[-np.array(list(map(float,q))),1.],A_ub=np.column_stack([features,-np.ones(len(masks))]),b_ub=np.zeros(len(masks)),bounds=[(-1,1)]*16+[(None,None)],method='highs-ds',options={'threads':1,'time_limit':20});assert run.success;found=None
   for D in [1,2,4,8,16,64,256,1024,65536]:
    c=np.rint(run.x[:16]*D).astype(np.int64);c[np.array([not(row['eligible_mask']>>h&1) for h in range(16)])]=0;b=int(max(features@c));g=math.gcd(*map(abs,[*c,b]));
    if g:c//=g;b//=g
    gap=sum(int(c[h])*q[h] for h in range(16))-b
    if gap>0:found=(c,b,gap);break
   assert found is not None,('no exact separation',i,sector,o,run.fun);c,b,gap=found;task={'anchor_orbit':i,'sector':sector,'orbit':o,'coefficients':list(map(int,c)),'bound':b,'source_certificate_sha256':record['certificate_sha256'],'point_conditional_positive_gap':str(gap)};cuts.append(task)
  assert all(abs(int(x))<1<<30 for x in c);scores=features@c;maximum=int(max(scores));assert maximum==b;assert all(c[h]==0 for h in range(16) if not row['eligible_mask']>>h&1);gap=sum(int(c[h])*q[h] for h in range(16))-b;assert gap>0;witness=int(masks[int(np.argmax(scores))]);assert sum(int(c[h]) for h in range(16) if witness>>h&1)==b
  reports.append({'anchor_orbit':i,'sector':sector,'orbit':o,'survivors_checked':len(masks),'exact_support_bound':b,'support_attaining_mask':witness,'positive_conditional_gap':str(gap),'lowered_bound_negative_control_rejected':True,'source_certificate_sha256':record['certificate_sha256']});print('EXACT CONDITIONAL INEQUALITY',i,sector,o,'bound',b,'gap',str(gap),flush=True)
 if not a.verify_only:a.certificate.write_text(json.dumps({'status':'CANDIDATE_EXACT_CONDITIONAL_CUTS','source_C16_answered':False,'cuts':cuts,'point_sha256':hashlib.sha256(a.point.read_bytes()).hexdigest()},indent=2)+'\n')
 out={'status':'PASS','source_C16_answered':False,'cuts_checked':len(reports),'cuts':cuts,'records':reports,'cut_certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'point_sha256':hashlib.sha256(a.point.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Weighted conditional one-orbit inequalities exactly valid on every phase mask surviving the certified rank cuts and prior critical cap. These strictly separate the stated exact relaxation point; no source frame exclusion follows.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS exact conditional inequalities',len(reports),flush=True)
if __name__=='__main__':main()
