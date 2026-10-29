#!/usr/bin/env python3
"""Lift small X-only quotient witnesses to direct original-coordinate cuts."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def in_span(v,rows):
 piv={}
 for x in rows:
  while x:
   b=x&-x
   if b not in piv:piv[b]=x;break
   x^=piv[b]
 while v:
  b=v&-v
  if b not in piv:return False
  v^=piv[b]
 return True

def verify(X,Z,A,cut):
 a=cut['anchor_X_index'];ids=cut['other_X_indices'];W=int(cut['original_annihilator_hex'],16);assert 1<=len(ids)<=3 and 0<W<1<<128 and a not in ids and len(set(ids))==len(ids)
 if cut['kind']=='zero_rank':assert not in_span(W,[X[a]]+[X[i] for i in ids])
 else:assert cut['kind']=='missing_private' and not in_span(W,[X[a]])
 count=0
 for j,z in enumerate(Z):
  if A[a]>>j&1:continue
  weight=sum((A[i]>>j)&1 for i in ids)
  if (weight==0 if cut['kind']=='zero_rank' else weight<=1):assert not (W&z).bit_count()%2;count+=1
 return count

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--cohort',type=Path,required=True);ap.add_argument('--replay',type=Path,required=True);ap.add_argument('--max-free-size',type=int,default=3);ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--verify-only',action='store_true');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();assert all((A[i]>>j&1)==(A[j]>>i&1)==(A[16*(i//16)+(i+1)%16]>>(16*(j//16)+(j+1)%16)&1) for i in range(720) for j in range(720));cohort=json.loads(a.cohort.read_text());rep=json.loads(a.replay.read_text());assert cohort['status']=='COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY' and rep['status']=='PASS' and rep.get('selected_quotient_sector','X')=='X';cuts=[]
 if a.verify_only:cuts=json.loads(gzip.decompress(a.certificate.read_bytes()))['cuts']
 else:
  for r in cohort['records']:
   fixed=16*r['orbit'];p=a.cohort.parent/r['certificate_file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==r['certificate_sha256'];d=json.loads(gzip.decompress(p.read_bytes()));meta=ROOT/r['quotient_metadata_c16_path'];md=json.loads(meta.read_text());assert hashlib.sha256(meta.read_bytes()).hexdigest()==d['quotient_metadata_sha256'];B=[X[i] for i in md['basis_X_pool_indices']]
   for row in d['records']:
    for c in row['minimal_bad_certificates']:
     if not 1<=c['mask'].bit_count()<=a.max_free_size:continue
     q=int(c['annihilator_hex'],16);W=0
     for k in range(127):
      if q>>k&1:W^=B[k+1]
     cuts.append({'anchor_X_index':fixed,'other_X_indices':[16*row['orbit']+h for h in range(16) if c['mask']>>h&1],'kind':c['kind'],'original_annihilator_hex':hex(W),'source_certificate_sha256':r['certificate_sha256'],'source_orbit':row['orbit'],'source_mask':c['mask']})
 counts={};checks=0
 for c in cuts:verify(X,Z,A,c);counts[len(c['other_X_indices'])+1]=counts.get(len(c['other_X_indices'])+1,0)+1;checks+=1
 assert cuts
 bad=dict(cuts[0]);bad['original_annihilator_hex']='0'
 try:verify(X,Z,A,bad)
 except AssertionError:pass
 else:raise AssertionError('zero witness accepted')
 if not a.verify_only:a.certificate.write_bytes(gzip.compress((json.dumps({'status':'CANDIDATE_ORIGINAL_SMALL_RANK_CUTS','cuts':cuts,'source_C16_answered':False},separators=(',',':'))+'\n').encode(),mtime=0))
 out={'status':'PASS','source_C16_answered':False,'direct_original_witnesses_checked':checks,'selected_X_nogoods_by_cardinality':counts,'physical_pairings_rebuilt':518400,'zero_witness_negative_control_rejected':True,'translation_and_sector_transfer_checked':True,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Every clause forbids the simultaneous selection of its stated2,3 or4 original X vectors in a full frame. Translate all indices and exchange sectors using the checked physical graph symmetries. These cuts are not restrictions on arbitrary partial frames.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
