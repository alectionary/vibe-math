#!/usr/bin/env python3
"""Direct physical witness consumer for one-orbit full-basis exclusions.

Replays only witnesses, not the discovery rank computation. Surviving profiles
are unexcluded by these cuts, never asserted completable to a physical frame.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--quotient-metadata',type=Path);ap.add_argument('--absent-X-index',type=int);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();qd=None
 if a.quotient_metadata:
  from verify_anchor_quotient import quotient
  X,Z,A,qd=quotient(a.quotient_metadata)
  if not qd.get('fixed_X_only',False):assert qd['anchor'][0]==qd['anchor'][1]
 else:X,Z,A=physical()
 if not qd or not qd.get('fixed_X_only',False):assert all((A[i]>>j&1)==(A[j]>>i&1) for i in range(720) for j in range(720))
 raw=a.certificate.read_bytes();d=json.loads(gzip.decompress(raw) if a.certificate.suffix=='.gz' else raw);N=d.get('ambient_dimension',128);assert N==(127 if qd else 128);records=[];totals=[0,0,0];negative_empty=negative_span=0
 if qd:
  assert d['quotient_metadata_sha256']==hashlib.sha256(a.quotient_metadata.read_bytes()).hexdigest()
  if qd.get('fixed_X_only',False):assert d.get('conditioned_on_X_index')==qd['anchor'][0]
  else:assert d.get('conditioned_on_anchor')==qd['anchor']
 selected_sector=d.get('selected_quotient_sector','X');assert selected_sector in ['X','Z']
 if a.absent_X_index is not None:
  assert qd is None and N==128 and selected_sector=='Z' and 0<=a.absent_X_index<720 and d['conditioned_on_X_absent']==a.absent_X_index
  X,Z=Z,X;Z[a.absent_X_index]=0;A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
 elif selected_sector=='Z':
  assert qd and qd.get('fixed_X_only',False)
  X,Z=Z,X;A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
 for r in d['records']:
  if not r['complete']:continue
  orbit=r['orbit'];assert 0<=orbit<45;vectors=X[16*orbit:16*orbit+16];eligible=sum(bool(v)<<h for h,v in enumerate(vectors));piv={};assert eligible==r.get('eligible_mask',65535)
  for h,v in enumerate(vectors):
   if not v:continue
   tag=1<<h
   while v:
    b=v&-v
    if b not in piv:piv[b]=(v,tag);break
    w,t=piv[b];v^=w;tag^=t
   if not v:assert qd and qd.get('fixed_X_only',False)
  independent=len(piv)==eligible.bit_count()
  if not (qd and qd.get('fixed_X_only',False)):assert independent
  def coefficients(v):
   tag=0
   while v:
    b=v&-v
    if b not in piv:return None
    w,t=piv[b];v^=w;tag^=t
   return tag
  profiles=[sum((A[16*orbit+h]>>j&1)<<h for h in range(16)) for j in range(720)];cache={}
  def verify(mask,kind,w):
   assert 0<=mask<65536 and not mask&~eligible and 0<w<(1<<N)
   if w not in cache:cache[w]=(coefficients(w),[p for p,z in zip(profiles,Z) if (w&z).bit_count()%2])
   coef,anti=cache[w]
   if kind=='zero_rank':
    if independent:assert coef is None or coef&~mask,'w lies in selected X span'
    else:
     rows={}
     for h,v in enumerate(vectors):
      if not mask>>h&1:continue
      while v:
       low=v&-v
       if low not in rows:rows[low]=v;break
       v^=rows[low]
     rem=w
     while rem:
      low=rem&-rem
      if low not in rows:break
      rem^=rows[low]
     assert rem,'w lies in selected projected X span'
    assert all(p&mask for p in anti),'w fails to annihilate zero domain'
   else:
    assert kind=='missing_private'
    assert all((p&mask).bit_count()>1 for p in anti),'w fails to annihilate eligible domain'
  bad=bytearray(bool(mask&~eligible) for mask in range(65536));kinds={}
  for c in r['minimal_bad_certificates']:
   mask=c['mask'];kind=c['kind'];assert not bad[mask];w=int(c['annihilator_hex'],16);verify(mask,kind,w);bad[mask]=1;kinds[kind]=kinds.get(kind,0)+1
   if negative_empty==0:
    try:verify(mask,kind,0)
    except AssertionError:negative_empty=1
    else:raise AssertionError('zero witness accepted')
   if kind=='zero_rank' and mask and negative_span==0:
    try:verify(mask,kind,vectors[(mask&-mask).bit_length()-1])
    except AssertionError:negative_span=1
    else:raise AssertionError('selected X span witness accepted')
  # Exact basic count/owner baseline via subset-zeta sums of physical profiles.
  freq=[0]*65536
  for p,z in zip(profiles,Z):
   if z:freq[p]+=1
  for h in range(16):
   bit=1<<h
   for low in range(0,65536,2*bit):
    for mask in range(low+bit,low+2*bit):freq[mask]+=freq[mask-bit]
  allowed=[0]*17;baseline=0;survivors=0;cut_baseline=0
  for mask in range(65536):
   if not bad[mask]:
    v=mask
    while v:
     bit=v&-v;v-=bit
     if bad[mask^bit]:bad[mask]=1;break
   k=mask.bit_count();complement=65535^mask;zero=freq[complement];basic=not mask&~eligible and zero>=N-k
   if basic:
    v=mask
    while v:
     bit=v&-v;v-=bit
     if freq[complement|bit]==zero:basic=False;break
   baseline+=basic;cut_baseline+=basic and bool(bad[mask])
   if not bad[mask]:assert basic;allowed[k]+=1;survivors+=1
  cap=max((k for k,n in enumerate(allowed) if n),default=-1);assert allowed==r['survivors_by_weight'] and cap==r['maximum_surviving_count'];assert (not bad[r['maximum_example_mask']]) if cap>=0 else bad[0]
  records.append({'orbit':orbit,'eligible_mask':eligible,'full_frame_count_upper_bound':cap,'minimal_witnesses_checked':len(r['minimal_bad_certificates']),'witness_kinds':kinds,'basic_count_owner_profiles':baseline,'profiles_unexcluded_by_rank_cuts':survivors,'additional_basic_profiles_excluded':cut_baseline,'survivors_by_weight':allowed});totals[0]+=baseline;totals[1]+=survivors;totals[2]+=cut_baseline
  print('PHYSICAL ORBIT',orbit,'cap',cap,'profile reduction',baseline,'->',survivors,flush=True)
 assert len({r['orbit'] for r in records})==len(records)==d['completed_orbits'];assert totals[0]-totals[1]==totals[2]
 out={'status':'PASS','source_C16_answered':False,'conditioned_on_anchor':qd['anchor'] if qd and not qd.get('fixed_X_only',False) else None,'conditioned_on_X_index':qd['anchor'][0] if qd and qd.get('fixed_X_only',False) else None,'conditioned_on_X_absent':a.absent_X_index,'selected_quotient_sector':selected_sector,'effective_dimension':N,'quotient_metadata_sha256':hashlib.sha256(a.quotient_metadata.read_bytes()).hexdigest() if qd else None,'certificate_sha256':hashlib.sha256(raw).hexdigest(),'physical_pairings_rebuilt':518400,'orbits_checked':len(records),'phase_masks_per_orbit':65536,'basic_count_owner_profiles':totals[0],'profiles_unexcluded_by_rank_cuts':totals[1],'additional_basic_profiles_excluded':totals[2],'empty_witness_rejected':bool(negative_empty),'span_witness_rejected':bool(negative_span),'sector_transfer':'Original physical transpose and cyclic symmetry checked. X-only conditioning transfers to the corresponding Z-only conditioning. Fixed-pair conditioning transfers within the equal-index anchor.','records':records,'elapsed_seconds':time.monotonic()-start,'scope':('The original X dictionary omits the stated absent vector. ' if a.absent_X_index is not None else '')+'Certified full-frame upper bounds and phase nogoods, restricted to the stated X-only or fixed-pair condition when present. Local counts are not global frame counts or a number of solved retained anchors. Unexcluded masks are not certified completable.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS profile totals',totals,flush=True)
if __name__=='__main__':main()
