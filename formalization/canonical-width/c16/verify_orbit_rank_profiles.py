#!/usr/bin/env python3
"""Direct physical witness consumer for one-orbit full-basis exclusions.

Replays only witnesses, not the discovery rank computation. Surviving profiles
are unexcluded by these cuts, never asserted completable to a physical frame.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();assert all((A[i]>>j&1)==(A[j]>>i&1) for i in range(720) for j in range(720));raw=a.certificate.read_bytes();d=json.loads(gzip.decompress(raw) if a.certificate.suffix=='.gz' else raw);records=[];totals=[0,0,0];negative_empty=negative_span=0
 for r in d['records']:
  if not r['complete']:continue
  orbit=r['orbit'];vectors=X[16*orbit:16*orbit+16];piv={}
  for h,v in enumerate(vectors):
   tag=1<<h
   while v:
    b=v&-v
    if b not in piv:piv[b]=(v,tag);break
    w,t=piv[b];v^=w;tag^=t
   assert v,'orbit must be independent'
  assert len(piv)==16
  def coefficients(v):
   tag=0
   while v:
    b=v&-v
    if b not in piv:return None
    w,t=piv[b];v^=w;tag^=t
   return tag
  profiles=[sum((A[16*orbit+h]>>j&1)<<h for h in range(16)) for j in range(720)];cache={}
  def verify(mask,kind,w):
   assert 0<mask<65536 and 0<w<(1<<128)
   if w not in cache:cache[w]=(coefficients(w),[p for p,z in zip(profiles,Z) if (w&z).bit_count()%2])
   coef,anti=cache[w]
   if kind=='zero_rank':
    assert coef is None or coef&~mask,'w lies in selected X span'
    assert all(p&mask for p in anti),'w fails to annihilate zero domain'
   else:
    assert kind=='missing_private'
    assert all((p&mask).bit_count()>1 for p in anti),'w fails to annihilate eligible domain'
  bad=bytearray(65536);kinds={}
  for c in r['minimal_bad_certificates']:
   mask=c['mask'];kind=c['kind'];assert not bad[mask];w=int(c['annihilator_hex'],16);verify(mask,kind,w);bad[mask]=1;kinds[kind]=kinds.get(kind,0)+1
   if negative_empty==0:
    try:verify(mask,kind,0)
    except AssertionError:negative_empty=1
    else:raise AssertionError('zero witness accepted')
   if kind=='zero_rank' and negative_span==0:
    try:verify(mask,kind,vectors[(mask&-mask).bit_length()-1])
    except AssertionError:negative_span=1
    else:raise AssertionError('selected X span witness accepted')
  # Exact basic count/owner baseline via subset-zeta sums of physical profiles.
  freq=[0]*65536
  for p in profiles:freq[p]+=1
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
   k=mask.bit_count();complement=65535^mask;zero=freq[complement];basic=zero>=128-k
   if basic:
    v=mask
    while v:
     bit=v&-v;v-=bit
     if freq[complement|bit]==zero:basic=False;break
   baseline+=basic;cut_baseline+=basic and bool(bad[mask])
   if not bad[mask]:assert basic;allowed[k]+=1;survivors+=1
  cap=max(k for k,n in enumerate(allowed) if n);assert allowed==r['survivors_by_weight'] and cap==r['maximum_surviving_count'];assert not bad[r['maximum_example_mask']]
  records.append({'orbit':orbit,'full_frame_count_upper_bound':cap,'minimal_witnesses_checked':len(r['minimal_bad_certificates']),'witness_kinds':kinds,'basic_count_owner_profiles':baseline,'profiles_unexcluded_by_rank_cuts':survivors,'additional_basic_profiles_excluded':cut_baseline,'survivors_by_weight':allowed});totals[0]+=baseline;totals[1]+=survivors;totals[2]+=cut_baseline
  print('PHYSICAL ORBIT',orbit,'cap',cap,'profile reduction',baseline,'->',survivors,flush=True)
 assert len({r['orbit'] for r in records})==len(records)==d['completed_orbits'];assert totals[0]-totals[1]==totals[2]
 out={'status':'PASS','source_C16_answered':False,'certificate_sha256':hashlib.sha256(raw).hexdigest(),'physical_pairings_rebuilt':518400,'orbits_checked':len(records),'phase_masks_per_orbit':65536,'basic_count_owner_profiles':totals[0],'profiles_unexcluded_by_rank_cuts':totals[1],'additional_basic_profiles_excluded':totals[2],'empty_witness_rejected':bool(negative_empty),'span_witness_rejected':bool(negative_span),'sector_transfer':'All518400 physical pairings equal their transpose, so index exchange transports every necessary phase restriction to Z.','records':records,'elapsed_seconds':time.monotonic()-start,'scope':'Certified full-frame upper bounds and phase nogoods. Basic count/owner profile comparison is local to one cyclic orbit. The counts are not global frame counts or a number of solved retained anchors. Unexcluded masks are not certified completable.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS profile totals',totals,flush=True)
if __name__=='__main__':main()
