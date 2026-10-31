#!/usr/bin/env python3
"""Reject corrupted normal-form certificates before accepting derived claims."""
import argparse,copy,json
from pathlib import Path
from verify_pool_inverse_structure import verify

if __name__=='__main__':
 ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();data=json.loads(args.certificate.read_text());root=Path(__file__).parent;checks=[]
 for name in ['coordinate','tensor_point','thin_functional','rank_profile','sector_exchange']:
  d=copy.deepcopy(data)
  if name=='coordinate':d['tensor']['binary_ring_coordinate_change'][0][0]^=1
  if name=='tensor_point':d['tensor']['X_tensor_coordinates'][0][0][0]^=1
  if name=='thin_functional':d['span_constraints']['thin_factors']['X']['trace_functional_q'][0][1]^=1
  if name=='sector_exchange':d['sector_exchange']['P_columns'][0][0][0]^=1
  if name=='rank_profile':d['span_constraints']['type_spans']['X']['type_rank_profile'][7]+=1
  try:verify(d,root)
  except AssertionError:checks.append({'mutation':name,'rejected':True})
  else:raise AssertionError('Corrupt certificate accepted: '+name)
 r={'status':'PASS','negative_certificate_controls':checks};args.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r))
