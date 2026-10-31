#!/usr/bin/env python3
"""Exact local cohort comparison after both physical source consumers pass."""
from pathlib import Path
import argparse,hashlib,json
ROOT=Path(__file__).resolve().parent
def closure(record):
 b=bytearray(65536)
 for c in record['minimal_bad_certificates']:b[c['mask']]=1
 for m in range(65536):
  if b[m]:continue
  v=m
  while v:
   low=v&-v;v-=low
   if b[m^low]:b[m]=1;break
 return b
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=ROOT/'algebraic-results';oldpath=p/'orbit-rank-profiles.json';newpath=p/'anchor48-rank-profiles.json';old=json.loads(oldpath.read_text());new=json.loads(newpath.read_text());anchor=new['conditioned_on_anchor'];assert anchor==[48,48]
 for file,report in [(oldpath,p/'orbit-rank-profiles-independent.json'),(newpath,p/'anchor48-rank-profiles-independent.json')]:
  r=json.loads(report.read_text());assert r['status']=='PASS' and r['orbits_checked']==45 and r['certificate_sha256']==hashlib.sha256(file.read_bytes()).hexdigest()
 records=[];totals=[0,0]
 for r,s in zip(old['records'],new['records']):
  assert r['orbit']==s['orbit'];o=r['orbit'];B=closure(r);C=closure(s);eligible=s['eligible_mask'];before=after=0
  for m in range(65536):
   if m&~eligible:continue
   physical=m|(1 if o==3 else 0)
   if o==12 and physical.bit_count()>11:continue
   if B[physical]:assert C[m];continue
   before+=1;after+=not C[m]
  records.append({'orbit':o,'old_profiles_after_anchor_availability':before,'conditioned_rank_survivors':after,'additional_exclusions':before-after});totals[0]+=before;totals[1]+=after
 out={'status':'PASS','source_C16_answered':False,'anchor':anchor,'old_profiles_after_anchor_availability':totals[0],'conditioned_rank_survivors':totals[1],'additional_exclusions':totals[0]-totals[1],'every_old_nogood_still_covered':True,'both_physical_certificate_hashes_bound':True,'records':records,'scope':'Local one-orbit profiles only. Includes the fixed X phase in its own orbit and the prior critical cap11 in both cohorts. This is not a global case reduction.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'})
if __name__=='__main__':main()
