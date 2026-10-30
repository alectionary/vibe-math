#!/usr/bin/env python3
"""Frozen bounded rounding/threshold screen with fresh exact full supports."""
from pathlib import Path
from fractions import Fraction
import gzip,hashlib,json,sys,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from full_partner_native import NativeFullPartnerBatch
from verify_full_partner_projection import read,point_data,weights,local_score,FEATURE_LAYOUT
from verify_full_partner_basis_oracle import rebuild_domain,check_support
from verify_algebraic_model import physical
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def write(p,value):
 assert not p.exists();raw=(json.dumps(value,indent=2)+'\n').encode();p.write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def nearest(q):
 # Symmetric nearest integer, ties away fromzero; exact and frozen.
 sign=-1 if q<0 else 1;q=abs(q);return sign*((2*q.numerator+q.denominator)//(2*q.denominator))
def main():
 start=time.monotonic();parent=ROOT/'coupling-results/native775-witness9-recovered.json.gz';receipt=ROOT/'coupling-results/native775-witness9-recovered-independent.json';point=ROOT/'coupling-results/anchor-witness9-rational.json.gz';source=read(parent);assert read(receipt)['bank_sha256']==sha(parent) and read(receipt)['status']=='PASS'
 sources=set(source['source_hashes'])|{str(p.relative_to(ROOT)) for p in (parent,receipt,Path(__file__),ROOT/'verify_full_partner_projection.py',ROOT/'verify_full_partner_basis_oracle.py')};hashes={p:sha(ROOT/p) for p in sorted(sources)};reps=source['representatives'];_,target=point_data(point,32);cohorts=[]
 for index,cut in enumerate(source['cuts']):
  raw=cut['coefficients'];scale=max(map(abs,raw));assert scale==1<<24
  for k in (1,2,4,8,16,32,64,128,256,512):
   rounded=[nearest(Fraction(v*k,scale)) for v in raw];cohorts.append(dict(kind='rounded',parent_cut=index,scale=k,coefficients=rounded))
   if k in (128,256,512):
    for threshold in (1,2):cohorts.append(dict(kind='rounded_then_thresholded',parent_cut=index,scale=k,threshold=threshold,coefficients=[v if abs(v)>threshold else 0 for v in rounded]))
  for denominator in (1024,512,256,128,64,32,16):
   cohorts.append(dict(kind='raw_thresholded',parent_cut=index,scale=scale,threshold_fraction=f'1/{denominator}',coefficients=[v if abs(v)*denominator>scale else 0 for v in raw]))
 frozen=dict(status='FROZEN_BEFORE_SIMPLIFICATION_SCREEN',source_C16_answered=False,parent_bank_sha256=sha(parent),parent_receipt_sha256=sha(receipt),point_sha256=sha(point),source_hashes=hashes,orbit=32,feature_layout=FEATURE_LAYOUT,allowed_masks=4597,representatives=reps,raw_normals=[c['coefficients'] for c in source['cuts']],cohorts=cohorts,rounding_rule='Exact nearest integer, ties away fromzero',scope='Every rounded or thresholded vector is a new functional, proved only by fresh exact global support. Opposite raw signs receive independent prefix-rank support checks; affine identity requires zero support range.')
 write(ROOT/'coupling-results/native775-witness9-simplify.frozen.json',frozen);batch=NativeFullPartnerBatch(reps);rows=[];cuts=[];seen={}
 for cohort in cohorts:
  c=cohort['coefficients'];key=tuple(c)
  if key in seen:rows.append({k:v for k,v in cohort.items() if k!='coefficients'}|dict(duplicate_of=seen[key]));continue
  seen[key]=len(rows);priced=batch.price(c);upper=int(max(priced['full_values']));exact=sum(a*b for a,b in zip(c,target));gap=exact-upper
  row={k:v for k,v in cohort.items() if k!='coefficients'}|dict(upper_bound=upper,exact_target=str(exact),exact_gap=str(gap),normalized_gap=float(gap/cohort['scale']),nonzero_coefficients=sum(v!=0 for v in c),max_abs_coefficient=max(map(abs,c)),positive=gap>0);rows.append(row);print(row,flush=True)
  if gap>0:
   records=[]
   for i,m in enumerate(reps):
    B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();records.append(dict(mask=m,support_value=int(priced['values'][i]),full_value=int(priced['full_values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nz],owner_indices=B[nz:]))
   cuts.append(dict(coefficients=c,upper_bound=upper,exact_target_value=str(exact),exact_violation=str(gap),pricing_scale=cohort['scale'],support_records=records,simplification=row))
 # Negative raw normals require no target violation; independently prove both
 # endpoint support values, then explicitly test whether the interval collapses.
 X,Z,_=physical();domains=[rebuild_domain(X,Z,[512+h for h in range(16) if m>>h&1],128) for m in reps];signs=[]
 for parent_index,old in enumerate(source['cuts']):
  endpoints=[]
  for sign in (1,-1):
   c=[sign*v for v in old['coefficients']];priced=batch.price(c);prefixes=0
   for i,m in enumerate(reps):
    B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();w=weights(m,c);r=dict(status='EXACT_FULL_PARTNER_BASIS_SUPPORT',value=int(priced['values'][i]),selected_Z_indices=B,zero_basis_indices=B[:nz],owner_indices=B[nz:]);prefixes+=check_support(Z,[512+h for h in range(16) if m>>h&1],128,domains[i],w,r);assert int(priced['full_values'][i])==local_score(m,c)+r['value']
   endpoints.append(dict(sign=sign,upper_bound=int(max(priced['full_values'])),prefix_rank_checks=prefixes))
  lo=-endpoints[1]['upper_bound'];hi=endpoints[0]['upper_bound'];assert hi==old['upper_bound'];signs.append(dict(parent_cut=parent_index,minimum=lo,maximum=hi,range_width=hi-lo,normalized_range_width=float(Fraction(hi-lo,1<<24)),affine_identity=lo==hi,independent_sign_supports=endpoints))
 bank=dict(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SIMPLIFIED_SEPARATOR_FOUND',source_C16_answered=False,feature_layout=FEATURE_LAYOUT,orbit=32,point_sha256=sha(point),allowed_masks=4597,representatives=reps,source_hashes=hashes,cuts=cuts,parent_bank_sha256=sha(parent),scope=frozen['scope']);path=ROOT/'coupling-results/native775-witness9-simplified.json.gz';write(path,bank)
 diagnostics=dict(status='EXACT_SIMPLIFICATION_SCREEN_COMPLETE_PENDING_CUT_ACCEPTANCE' if cuts else 'EXACT_BOUNDED_NO_SIMPLIFIED_SEPARATOR',source_C16_answered=False,bank_sha256=sha(path),point_sha256=sha(point),source_hashes=hashes,rows=rows,positive_cut_count=len(cuts),raw_sign_ranges=signs,elapsed_seconds=time.monotonic()-start,scope=frozen['scope']);write(ROOT/'coupling-results/native775-witness9-simplify-diagnostic.json',diagnostics);print('POSITIVE COUNT',len(cuts),'SIGN RANGES',signs,flush=True)
if __name__=='__main__':main()
