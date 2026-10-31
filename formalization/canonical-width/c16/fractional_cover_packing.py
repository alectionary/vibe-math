#!/usr/bin/env python3
"""Exact fractional-packing lower bound for the original signature-cover test."""
from pathlib import Path
import argparse,hashlib,json,math,time,warnings
from verify_anchored_cover_chain import physical,canonical
ROOT=Path(__file__).resolve().parent

def verify(data):
 A,C,pos,sig=physical();D=data['denominator'];assert isinstance(D,int) and D>0;loads=[0]*len(C);total=0
 for r in data['weighted_witnesses']:
  weight=r['weight_numerator'];assert isinstance(weight,int) and weight>0;pairs=r['pairs'];value=0
  for k,(i,j) in enumerate(pairs):
   assert (i,j) in sig and sig[i,j];value^=sig[i,j]
   for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
  assert value==65535;support={pos[canonical(i,j)] for i,j in pairs};assert support==set(r['support_class_indices'])
  for i in support:loads[i]+=weight
  total+=weight
 assert all(v<=D for v in loads)
 return {'weighted_partial_witnesses':len(data['weighted_witnesses']),'classes':len(C),'packing_numerator':total,'packing_denominator':D,'integer_cover_size_lower_bound':(total+D-1)//D,'largest_class_load_numerator':max(loads)}

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
 if a.verify_only:data=json.loads(a.certificate.read_text())
 else:
  import numpy as np
  from scipy.optimize import linprog,OptimizeWarning
  from scipy.sparse import coo_matrix
  warnings.filterwarnings('ignore',message='Unrecognized options detected.*',category=OptimizeWarning);assert a.chain;A,C,pos,sig=physical();chain=json.loads(a.chain.read_text());witnesses=chain['seed_witnesses']+[r['counterexample_edges'] for r in chain['records'] if r['answer'] is True];by={}
  for pairs in witnesses:by.setdefault(tuple(sorted({pos[canonical(i,j)] for i,j in pairs})),pairs)
  supports=sorted(by);ii=[];jj=[]
  for j,S in enumerate(supports):
   for i in S:ii.append(i);jj.append(j)
  B=coo_matrix((np.ones(len(ii)),(ii,jj)),shape=(518,len(supports))).tocsc();run=linprog(-np.ones(len(supports)),A_ub=B,b_ub=np.ones(518),bounds=(0,None),method='highs-ds',options={'threads':1,'time_limit':30});assert run.success;D=1000000;n=[max(0,math.floor(float(x)*D)) for x in run.x];loads=[sum(n[j] for j,S in enumerate(supports) if i in S) for i in range(518)]
  for i in range(518):
   if loads[i]>D:
    excess=loads[i]-D;j=max((j for j,S in enumerate(supports) if i in S),key=lambda j:n[j]);assert n[j]>=excess;n[j]-=excess
    for k in supports[j]:loads[k]-=excess
  data={'status':'CANDIDATE_FRACTIONAL_SIGNATURE_COVER_PACKING','source_C16_answered':False,'denominator':D,'weighted_witnesses':[{'weight_numerator':n[j],'support_class_indices':list(S),'pairs':by[S]} for j,S in enumerate(supports) if n[j]],'source_chain_sha256':hashlib.sha256(a.chain.read_bytes()).hexdigest()};a.certificate.write_text(json.dumps(data,indent=2)+'\n')
 result=verify(data);bad=json.loads(json.dumps(data));bad['weighted_witnesses'][0]['weight_numerator']=data['denominator']+1
 try:verify(bad)
 except AssertionError:pass
 else:raise AssertionError('overloaded class capacity accepted')
 result.update(status='PASS_EXACT_PACKING_LOWER_BOUND',source_C16_answered=False,overloaded_weight_negative_control_rejected=True,certificate_sha256=hashlib.sha256(a.certificate.read_bytes()).hexdigest(),elapsed_seconds=time.monotonic()-start,scope='Every cover certified by excluding all compatible partial matchings with the original16-signature target must meet each retained witness support. Fractional load at most1 per class gives this lower bound. It does not bound arbitrary full-frame covers, decide width, prove the upper cover optimal or estimate search time.');a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
