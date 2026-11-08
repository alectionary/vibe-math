#!/usr/bin/env python3
"""Literal rational residual audit of saved floating two-sidedcountprimals."""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,time
import numpy as np
from verify_two_sided_anchor_count import read,domain,columns,feature,N
from verify_algebraic_model import physical
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();b=read(a.bank);assert b['status']=='NUMERICAL_TWO_SIDED_COUNT_EXTENSION_FEASIBLE';assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());point=ROOT/b['point_c16_path'];assert sha(point)==b['point_sha256'];z=np.load(a.bank.with_suffix('.npz'));x=[Fraction(float(t)) for t in z['x']];labels=[tuple([str(r[0]),int(r[1]),int(r[2])]) for r in z['variables']];assert len(x)==len(labels)==b['variables'];assert len(set(labels))==len(labels);lookup=dict(zip(labels,x));lam=[lookup['lambda',m,-1] for m in range(16)];X,Z,A=physical();target=[Fraction(1) if j is None else point_vector(point)[j] for j in []] # owner isloaded oncebelow
 owner=point_vector(point);target=[Fraction(1) if j is None else owner[j] for j in columns(b['X_anchors'],b['Z_anchors'])];totals=[Fraction(0)]*N;bucketres=[];upper=[];expected={('lambda',m,-1) for m in range(16)};invalidmass=[]
 for m in range(16):
  d=domain(X,Z,b['X_anchors'],b['Z_anchors'],m)
  if d is None:invalidmass.append(lam[m]);continue
  fixed,buckets=d;u=[Fraction(0)]*1440
  for j in fixed:u[j]=lam[m]
  for take,free in buckets:
   vals=[]
   for j in free:
    key=('y',m,j);expected.add(key);value=lookup[key];u[j]=value;vals.append(value);upper.append(value-lam[m])
   bucketres.append(sum(vals)-take*lam[m])
  local=feature(m,[])[:11]
  for k,v in enumerate(local):totals[k]+=v*lam[m]
  for j,v in enumerate(u):
   totals[11+j]+=v
   for k in range(4):
    if m>>k&1:totals[1451+1440*k+j]+=v
 assert expected==set(labels);res=[v-t for v,t in zip(totals,target)];maxf=max(map(abs,res));maxb=max(map(abs,bucketres));maxu=max([Fraction(0),*upper]);minimum=min(x);exact=not any(res) and not any(bucketres) and not any(invalidmass) and maxu==0 and minimum>=0
 assert maxf<Fraction(1,10**8) and maxb<Fraction(1,10**8) and maxu<Fraction(1,10**8) and minimum>-Fraction(1,10**8)
 out={'status':'PASS_LITERAL_NUMERICAL_PRIMAL_AUDIT','source_C16_answered':False,'exact_count_membership':exact,'bank_sha256':sha(a.bank),'archive_sha256':sha(a.bank.with_suffix('.npz')),'point_sha256':sha(point),'consumer_sha256':sha(__file__),'independent_domain_consumer_sha256':sha(ROOT/'verify_two_sided_anchor_count.py'),'variables_checked':len(x),'features_checked':len(res),'bucket_equalities_checked':len(bucketres),'upper_bounds_checked':len(upper),'maximum_exact_binary_float_feature_residual':str(maxf),'maximum_exact_binary_float_bucket_residual':str(maxb),'maximum_exact_binary_float_upper_violation':str(maxu),'minimum_exact_binary_float_variable':str(minimum),'nonzero_feature_residuals':sum(v!=0 for v in res),'nonzero_bucket_residuals':sum(v!=0 for v in bucketres),'seconds':time.monotonic()-start,'scope':'Allstoredfloats convertedexactly torationalnumbers, then everyliteralpattern/fullpoolmoment/count equation andbound recomputed. Nonzeroresidual means noexactmembershipclaim. Nozero-rankorunanchoredcrosspairconditions arepresent.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
