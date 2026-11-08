#!/usr/bin/env python3
"""Independent exact Boolean truth tables and physical32-action row compiler."""
from pathlib import Path
from collections import Counter
from fractions import Fraction
from itertools import product
import argparse,hashlib,json,random,time
import numpy as np
from scipy.sparse import csr_matrix
from verify_full_partner_projection import point_data
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def compile_row(cut):
 e,w,c=cut['events'],cut['weights'],cut['constant'];assert type(c)is int and len(e)==len(w) and 0<len(e)<=12 and len(set(e))==len(e) and all(type(v)is int and 0<=v<1440 for v in e) and all(type(v)is int for v in w)
 r=Counter()
 for t,(a,u) in enumerate(zip(e,w)):
  ai=(a%720)//16;r[ai]-=c*u+u*(u-1)//2
  for b,v in zip(e[:t],w[:t]):
   sa,aa=divmod(a,720);sb,bb=divmod(b,720);i,ph=divmod(aa,16);j,qh=divmod(bb,16);h=(qh-ph)%16
   if h>8:h,i,j=16-h,j,i
   if h in (0,8) and i>j:i,j=j,i
   column=i if sa==sb and h==0 and i==j else 45+(0 if sa==sb else 18225)+h*2025+45*i+j
   r[column]-=u*v
 return dict(sorted((j,v) for j,v in r.items() if v)),c*(c-1)//2

def matrix(banks,replays):
 assert len(banks)==len(replays);ii=[];jj=[];vv=[];rhs=[];meta=[]
 for p,rp in zip(banks,replays):
  b=json.loads(Path(p).read_text());r=json.loads(Path(rp).read_text());assert r['status']=='PASS' and r['bank_sha256']==sha(p) and r['consumer_sha256']==sha(Path(__file__)) and r['cuts_checked']==len(b['cuts']) and r['source_hashes']==b['source_hashes'];assert all(sha(ROOT/q)==v for q,v in b['source_hashes'].items())
  for k,c in enumerate(b['cuts']):
   row,h=compile_row(c)
   for j,v in row.items():ii.append(len(rhs));jj.append(j);vv.append(v)
   rhs.append(h);meta.append({'family':'physical_integer_form','certificate_sha256':sha(p),'replay_sha256':sha(rp),'cut_index':k})
 return csr_matrix((np.array(vv,dtype=np.int64),(ii,jj)),shape=(len(rhs),36495)),np.array(rhs,dtype=np.int64),meta

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();bank=json.loads(a.bank.read_text());assert bank['status']=='EXACT_PHYSICAL_INTEGER_FORM_CANDIDATE' and bank['point_sha256']==sha(a.point);assert all(sha(ROOT/p)==v for p,v in bank['source_hashes'].items());owner,_=point_data(a.point,32);from physical_integer_form_rows import compile_row as producer
 truth=0;results=[];compiled=[]
 for cut in bank['cuts']:
  row,rhs=compile_row(cut);assert (row,rhs)==producer(cut);gap=sum(v*owner[j] for j,v in row.items())-rhs;assert gap==Fraction(cut['exact_violation'])>0;compiled.append((row,rhs))
  for bits in product([0,1],repeat=len(cut['events'])):
   L=cut['constant']+sum(v*b for v,b in zip(cut['weights'],bits));assert L*(L-1)>=0;truth+=1
  results.append({'exact_violation':str(gap),'owner_nonzeros':len(row)})
 rng=random.Random(202610300940);literal=0
 for probability in [0,1,.05,.2,.5]:
  sectors=[np.array([int(rng.random()<probability) for _ in range(720)]).reshape(45,16) for _ in range(2)];o=np.zeros(36495,dtype=np.int64);scores=[0]*len(compiled)
  for swap in [0,1]:
   for shift in range(16):
    A,B=[np.roll(sectors[(s+swap)%2],shift,axis=1) for s in range(2)];o[:45]+=A[:,0]
    for h in range(9):o[45+2025*h:45+2025*(h+1)]+=np.outer(A[:,0],A[:,h]).ravel();o[18270+2025*h:18270+2025*(h+1)]+=np.outer(A[:,0],B[:,h]).ravel()
    bits=np.r_[A.ravel(),B.ravel()]
    for k,c in enumerate(bank['cuts']):L=c['constant']+sum(v*int(bits[e]) for e,v in zip(c['events'],c['weights']));scores[k]-=L*(L-1)//2
  for (row,rhs),score in zip(compiled,scores):assert sum(v*int(o[j]) for j,v in row.items())-32*rhs==score;literal+=1
 bad=0
 for patch in [{'weights':[1.0]*5},{'constant':0.0},{'events':[1440,1,2,3,4]},{'events':[1,1,2,3,4]}]:
  c={**bank['cuts'][0],**patch}
  try:compile_row(c)
  except (AssertionError,TypeError,ValueError):bad+=1
  else:raise AssertionError('invalid input accepted')
 out={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'source_hashes':bank['source_hashes'],'cuts_checked':len(results),'results':results,'Boolean_truth_assignments':truth,'literal_32_action_checks':literal,'invalid_inputs_rejected':bad,'elapsed_seconds':time.monotonic()-start,'scope':'Universalinteger-form Booleaninequalities, exactphysicalmomenttranslation andpositivegap; no sourceobstruction.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['source_hashes','results']},flush=True)
if __name__=='__main__':main()
