#!/usr/bin/env python3
"""Check reuse of original negative profiles in the opposite X-only quotient.

For S in Xa-perp, the original opposite zero domain contains Xa; projection
modulo Xa lowers its rank and the ambient dimension by exactly one. Private
profiles are unchanged. Thus these two necessity tests restrict directly.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time
import numpy as np

def bad(record):
 n=np.arange(65536,dtype=np.int64);out=(n&~record.get('eligible_mask',65535))!=0;out[np.array([c['mask'] for c in record['minimal_bad_certificates']],dtype=np.int64)]=True
 for h in range(16):
  v=out.reshape(-1,2,1<<h);v[:,1,:]|=v[:,0,:]
 return out

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--original',type=Path,required=True);ap.add_argument('--cohort',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();raw=a.original.read_bytes();d=json.loads(gzip.decompress(raw) if a.original.suffix=='.gz' else raw);original={r['orbit']:bad(r) for r in d['records']};cohort=json.loads(a.cohort.read_text());assert cohort['status']=='COMPLETE_GENERATION_REQUIRES_PHYSICAL_REPLAY' and cohort['selected_quotient_sector']=='Z';masks=np.arange(65536,dtype=np.int64);rows=0
 for r in cohort['records']:
  p=a.cohort.parent/r['certificate_file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==r['certificate_sha256'];q=json.loads(gzip.decompress(p.read_bytes()));assert q['selected_quotient_sector']=='Z'
  for record in q['records']:
   expected=original[record['orbit']]|((masks&~record.get('eligible_mask',65535))!=0);assert np.array_equal(expected,bad(record)),(r['orbit'],record['orbit']);rows+=1
 assert rows==45*45
 out={'status':'PASS','source_C16_answered':False,'conditional_orbit_rows_checked':rows,'phase_mask_comparisons':rows*65536,'families_identical':True,'original_sha256':hashlib.sha256(raw).hexdigest(),'cohort_sha256':hashlib.sha256(a.cohort.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'The opposite-side X-only quotient zero-rank/private-partner survivor families equal the original families restricted to eligible annihilating phases. The written projection lemma supplies the general implication; these exact tables check its instance and encoding. Does not transfer the fixed-X-side stronger family or establish a source frame.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
