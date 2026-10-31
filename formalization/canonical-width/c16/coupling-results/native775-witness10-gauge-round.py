#!/usr/bin/env python3
"""Two literal owner/count identities, followed by independently repriced rounding."""
from pathlib import Path
from fractions import Fraction
import gzip,hashlib,json,sys,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from full_partner_native import NativeFullPartnerBatch
from verify_full_partner_projection import read,point_data,weights,local_score,FEATURE_LAYOUT
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from verify_algebraic_model import physical
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,x):
 assert not p.exists();b=(json.dumps(x,indent=2)+'\n').encode();p.write_bytes(gzip.compress(b,mtime=0) if str(p).endswith('.gz') else b)
def nearest(x):
 s=-1 if x<0 else 1;x=abs(x);return s*((2*x.numerator+x.denominator)//(2*x.denominator))
def main():
 start=time.monotonic();parent=ROOT/'coupling-results/native775-witness10.json.gz';receipt=ROOT/'coupling-results/native775-witness10-independent.json';point=ROOT/'coupling-results/anchor-witness10-rational.json.gz';bank=read(parent);assert read(receipt)['bank_sha256']==sha(parent) and read(receipt)['status']=='PASS';_,target=point_data(point,32);X,Z,_=physical();A=[(X[512]&z).bit_count()%2 for z in Z];reps=bank['representatives'];batch=NativeFullPartnerBatch(reps);domains=[rebuild_domain(X,Z,[512+h for h in range(16) if m>>h&1],128) for m in reps]
 identities=[]
 for name,multiple,body in [('all_cross_count',128,[1]*720),('physical_owner_count',1,A)]:
  c=[0]*775;c[1]=-multiple;c[55:]=body;assert sum(a*b for a,b in zip(c,target))==0
  proofs=[]
  for sign in (1,-1):
   signed=[sign*v for v in c];result=batch.price(signed);assert all(int(v)==0 for v in result['full_values']);prefixes=0
   for i,m in enumerate(reps):
    B=list(map(int,result['bases'][i]));nz=128-m.bit_count();w=weights(m,signed);r=dict(status='EXACT_FULL_PARTNER_BASIS_SUPPORT',value=int(result['values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nz],owner_indices=B[nz:]);prefixes+=check_support(Z,[512+h for h in range(16) if m>>h&1],128,domains[i],w,r);assert local_score(m,signed)+r['value']==0
   proofs.append(dict(sign=sign,upper_bound=0,prefix_rank_checks=prefixes))
  identities.append(dict(name=name,coefficients=c,exact_point_value='0',both_sign_support=proofs))
 cohorts=[]
 for idx,old in enumerate(bank['cuts']):
  raw=old['coefficients'];groups=[[v for a,v in zip(A,raw[55:]) if a==b] for b in (0,1)]
  for scheme in ('common_median','pairing_class_medians'):
   if scheme=='common_median':t0=t1=sorted(raw[55:])[360]
   else:t0,t1=[sorted(g)[len(g)//2] for g in groups]
   adjusted=raw.copy();adjusted[1]+=127*t0+t1;adjusted[55:]=[v-(t1 if a else t0) for a,v in zip(A,raw[55:])];scale=max(map(abs,adjusted));assert sum(a*b for a,b in zip(adjusted,target))==Fraction(old['exact_target_value']);priced=batch.price(adjusted);assert int(max(priced['full_values']))==old['upper_bound']
   for k in (1,2,4,8,16,32,64,128,256,512):cohorts.append(dict(parent_cut=idx,scheme=scheme,t0=t0,t1=t1,normalization_denominator=scale,scale=k,coefficients=[nearest(Fraction(v*k,scale)) for v in adjusted]))
 sources=set(bank['source_hashes'])|{str(p.relative_to(ROOT)) for p in (parent,receipt,Path(__file__),ROOT/'verify_full_partner_projection.py',ROOT/'verify_full_partner_basis_oracle.py')};hashes={p:sha(ROOT/p) for p in sorted(sources)}
 frozen=dict(status='FROZEN_BEFORE_GAUGE_ROUNDING',source_C16_answered=False,parent_bank_sha256=sha(parent),point_sha256=sha(point),source_hashes=hashes,identities=identities,physical_pairing_pattern=A,cohorts=cohorts,proof='EveryfullQbasis has128 vectors, hence sumd=128k. ExactlyoneQowner perselectedX gives sumA*d=k. Subtract t0 from pairing0 andt1 from pairing1 coefficients and add127t0+t1 tok. Bothidentities have independentzero support inbothsigns; this is not a fullaffine-hull claim.')
 write(ROOT/'coupling-results/native775-witness10-gauge-round.frozen.json',frozen);rows=[];cuts=[];seen={}
 for cohort in cohorts:
  c=cohort['coefficients'];key=tuple(c)
  if key in seen:rows.append({k:v for k,v in cohort.items() if k!='coefficients'}|dict(duplicate_of=seen[key]));continue
  seen[key]=len(rows);priced=batch.price(c);upper=int(max(priced['full_values']));exact=sum(a*b for a,b in zip(c,target));gap=exact-upper;row={k:v for k,v in cohort.items() if k!='coefficients'}|dict(upper_bound=upper,exact_target=str(exact),exact_gap=str(gap),normalized_gap=float(gap/cohort['scale']),nonzero_coefficients=sum(v!=0 for v in c),positive=gap>0);rows.append(row);print(row,flush=True)
  if gap>0:
   records=[]
   for i,m in enumerate(reps):
    B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();records.append(dict(mask=m,support_value=int(priced['values'][i]),full_value=int(priced['full_values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nz],owner_indices=B[nz:]))
   cuts.append(dict(coefficients=c,upper_bound=upper,exact_target_value=str(exact),exact_violation=str(gap),pricing_scale=cohort['scale'],support_records=records,simplification=row))
 out=dict(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_GAUGE_ROUNDED_SEPARATOR',source_C16_answered=False,feature_layout=FEATURE_LAYOUT,orbit=32,point_sha256=sha(point),allowed_masks=4597,representatives=reps,source_hashes=hashes,cuts=cuts,scope=frozen['proof']);p=ROOT/'coupling-results/native775-witness10-gauge-rounded.json.gz';write(p,out);write(ROOT/'coupling-results/native775-witness10-gauge-round-diagnostic.json',dict(status='EXACT_GAUGE_ROUNDING_COMPLETE',source_C16_answered=False,bank_sha256=sha(p),identities=identities,rows=rows,positive_cut_count=len(cuts),elapsed_seconds=time.monotonic()-start,scope=frozen['proof']));print('POSITIVE COUNT',len(cuts),flush=True)
if __name__=='__main__':main()
