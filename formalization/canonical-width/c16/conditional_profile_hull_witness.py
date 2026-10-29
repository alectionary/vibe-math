#!/usr/bin/env python3
"""Exact local convex decompositions conditional on one selected source X.

LP is only a discovery aid. Every retained decomposition is checked with rational
arithmetic, independently of the LP status or its floating residuals. This does
not construct a joint distribution, matching or source frame.
"""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor,as_completed
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,subprocess,sys,time,warnings
import numpy as np
from scipy.optimize import linprog,OptimizeWarning
from scipy.linalg import qr
from flint import fmpq,fmpq_mat
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent
warnings.filterwarnings('ignore',message='Unrecognized options detected.*',category=OptimizeWarning)

def allowed(record,anchor,sector):
 n=np.arange(65536,dtype=np.int64);eligible=record.get('eligible_mask',65535);bad=(n&~eligible)!=0
 bad[np.array([r['mask'] for r in record['minimal_bad_certificates']],dtype=np.int64)]=True
 for h in range(16):
  view=bad.reshape(-1,2,1<<h);view[:,1,:]|=view[:,0,:]
 if record['orbit']==12:
  pop=np.array([int(m).bit_count() for m in n],dtype=np.int8);bad|=pop>11-int(sector=='X' and anchor==12)
 return np.flatnonzero(~bad)

def target(values,index,m,i,o,sector,eligible):
 p=values[index['p',i]];assert p>0
 return [values[m('S' if sector=='X' else 'T',h,i,o)]/p if eligible>>h&1 else fmpq(0) for h in range(16)]

def check(weights,masks,q,allowed_masks):
 assert len(weights)==len(masks)>0 and len(set(masks))==len(masks);assert all(w>=0 for w in weights) and sum(weights)==1;assert all(v in allowed_masks for v in masks)
 for h in range(16):assert sum(w for w,H in zip(weights,masks) if H>>h&1)==q[h],('phase',h)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--condition-value',type=int,choices=[0,1],default=1);ap.add_argument('--unconditional-profiles',type=Path);ap.add_argument('--x-cohort',type=Path,required=True);ap.add_argument('--z-cohort',type=Path,required=True);ap.add_argument('--x-replay',type=Path,required=True);ap.add_argument('--z-replay',type=Path,required=True);ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--anchors',type=int,default=45);ap.add_argument('--workers',type=int,default=2);ap.add_argument('--seconds',type=float,default=1200);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();deadline=start+a.seconds;assert 1<=a.anchors<=45;hulls=json.loads(gzip.decompress(a.hulls.read_bytes()));_,index,m=layout(hulls);point=json.loads(gzip.decompress(a.point.read_bytes()));values=list(map(fmpq,point['values']));sources={};reports={};records=[]
 for sector,cp,rp in [('X',a.x_cohort,a.x_replay),('Z',a.z_cohort,a.z_replay)]:
  sources[sector]=(cp,json.loads(cp.read_text()));reports[sector]=json.loads(rp.read_text());assert sources[sector][1]['status']=='COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY' and reports[sector]['status']=='PASS' and reports[sector].get('selected_quotient_sector','X')==sector
  assert len(reports[sector]['records'])==45
 source_hashes={key:hashlib.sha256(p.read_bytes()).hexdigest() for key,p in [('point',a.point),('x-cohort',a.x_cohort),('z-cohort',a.z_cohort),('x-replay',a.x_replay),('z-replay',a.z_replay),('hulls',a.hulls)]}
 unconditional=None
 if a.condition_value==0:
  assert a.unconditional_profiles;raw=a.unconditional_profiles.read_bytes();unconditional=json.loads(gzip.decompress(raw) if a.unconditional_profiles.suffix=='.gz' else raw);source_hashes['unconditional_profiles']=hashlib.sha256(raw).hexdigest()
 frozen=json.loads(gzip.decompress(a.certificate.read_bytes())) if a.verify_only else None
 if frozen:assert frozen['input_hashes']==source_hashes and frozen.get('anchor_condition_value',1)==a.condition_value
 def task(i,sector):
  cp,d=sources[sector];r=next(r for r in d['records'] if r['orbit']==i)
  if a.condition_value:
   proof=cp.parent/r['certificate_file'];assert hashlib.sha256(proof.read_bytes()).hexdigest()==r['certificate_sha256'];replay=reports[sector]['records'][i];assert replay['orbit']==i and replay['certificate_sha256']==r['certificate_sha256'];pinned=cp.parent/replay['report_file'];assert hashlib.sha256(pinned.read_bytes()).hexdigest()==replay['report_sha256'];profile=json.loads(gzip.decompress(proof.read_bytes()))
  else:profile=unconditional;r={'certificate_sha256':source_hashes['unconditional_profiles']}
  out=[]
  for row in profile['records']:
   if time.monotonic()>deadline:return {'anchor_orbit':i,'sector':sector,'status':'TIME_LIMIT','records':out}
   o=row['orbit'];eligible=row.get('eligible_mask',65535);masks=allowed(row,i if a.condition_value else -1,sector)
   if a.condition_value:q=target(values,index,m,i,o,sector,eligible)
   else:
    denominator=1-values[index['p',i]];assert denominator>0;q=[(values[index['p',o]]-values[m('S' if sector=='X' else 'T',h,i,o)])/denominator for h in range(16)]
   phases=[h for h in range(16) if eligible>>h&1]
   if a.verify_only:
    entry=next(x for x in frozen['records'] if x['anchor_orbit']==i and x['sector']==sector);r0=next(x for x in entry['records'] if x['orbit']==o);chosen=r0['masks'];weights=list(map(fmpq,r0['weights']))
   else:
    B=np.vstack([np.ones(len(masks)),*[((masks>>h)&1).astype(float) for h in phases]]);b=[fmpq(1)]+[q[h] for h in phases]
    run=linprog(np.zeros(len(masks)),A_eq=B,b_eq=np.array(list(map(float,b))),bounds=(0,None),method='highs-ds',options={'threads':1,'time_limit':min(20,max(.1,deadline-time.monotonic())),'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9})
    if not run.success:return {'anchor_orbit':i,'sector':sector,'status':'NUMERIC_INFEASIBLE_OR_UNKNOWN','orbit':o,'LP_status':run.status,'LP_message':run.message,'records':out}
    support=np.flatnonzero(run.x>1e-11);chosen=list(map(int,masks[support]));A=B[:,support];k=len(support);assert 0<k<=len(b);_,R,piv=qr(A.T,pivoting=True,mode='economic');rows=piv[:k];assert abs(R[k-1,k-1])>1e-8;weights=list(fmpq_mat(A[rows,:].astype(np.int64).tolist()).solve(fmpq_mat([[b[j]] for j in rows])))
   valid_masks=set(map(int,masks));check(weights,chosen,q,valid_masks)
   if o==0:
    changed=chosen.copy();k=next(k for k,w in enumerate(weights) if w>0);changed[k]^=1<<phases[0]
    try:check(weights,changed,q,valid_masks)
    except AssertionError:pass
    else:raise AssertionError('corrupt phase mask accepted')
   out.append({'orbit':o,'masks':chosen,'weights':list(map(str,weights)),'unexcluded_phase_masks':len(masks)})
  return {'anchor_orbit':i,'sector':sector,'status':'PASS','source_certificate_sha256':r['certificate_sha256'],'records':out}
 with ThreadPoolExecutor(max_workers=a.workers) as pool:
  for f in as_completed([pool.submit(task,i,s) for i in range(a.anchors) for s in ['X','Z']]):
   r=f.result();records.append(r);print('LOCAL CONDITIONAL HULL',len(records),r['anchor_orbit'],r['sector'],r['status'],'seconds',round(time.monotonic()-start,2),flush=True)
   if not a.verify_only:a.certificate.write_bytes(gzip.compress((json.dumps({'status':'CANDIDATE_LOCAL_DECOMPOSITIONS','source_C16_answered':False,'anchor_condition_value':a.condition_value,'records':records,'input_hashes':source_hashes},separators=(',',':'))+'\n').encode(),mtime=0))
 passed=len(records)==2*a.anchors and all(r['status']=='PASS' for r in records);out={'status':'PASS' if passed else 'INCOMPLETE_OR_FAILED','source_C16_answered':False,'anchors_checked':a.anchors,'anchor_condition_value':a.condition_value,'sector_rows_checked':len(records),'local_decompositions_checked':sum(len(r['records']) for r in records if r['status']=='PASS'),'exact_weights_nonnegative':passed,'all16_conditional_first_moments_checked':passed,'corrupt_phase_negative_controls_rejected':sum(any(row['orbit']==0 for row in r['records']) for r in records),'input_hashes':source_hashes,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':('Condition on Xa=1 using the quotient rank-profile families. ' if a.condition_value else 'Condition on Xa=0 using the original unconditioned rank-profile families. ')+'Each conditional one-orbit first-moment vector is a convex combination of phase masks unexcluded by the complete certified rank nogoods, with prior critical cap. Separate local decompositions need not combine into a joint distribution or full frame. Physical negative-witness replay and source-point PSD certificate are separate dependencies.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='input_hashes'},flush=True)
if __name__=='__main__':main()
