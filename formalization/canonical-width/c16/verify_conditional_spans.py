#!/usr/bin/env python3
"""Replay positive full-inverse spans from the physical pools, without elimination."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_algebraic_model import physical
ROOT=Path(__file__).resolve().parent

def replay(X,Z,A,d,drop=False):
 a,b=d['anchor'];assert A[a]>>b&1 and d['target_in_span'] is True
 pairs=d['span_combination'][:-1] if drop else d['span_combination']
 assert len(pairs)==len(set(map(tuple,pairs)))
 grouped={}
 for i,j in pairs:
  assert i!=a and j!=b and A[i]>>j&1 and not A[i]>>b&1 and not A[a]>>j&1
  grouped[i]=grouped.get(i,0)^Z[j]
 rows=[0]*128
 for i,z in grouped.items():
  v=X[i]
  while v:
   low=v&-v;k=low.bit_length()-1;rows[k]^=z;v^=low
 expected=[(1<<k)^(Z[b] if X[a]>>k&1 else 0) for k in range(128)]
 assert rows==expected,'outer-product XOR differs from residual identity'
 return len(pairs)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--survey',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,A=physical();survey=json.loads(a.survey.read_text());cases=json.loads((ROOT/'theory-loop-results/final-independent.json').read_text())['cases'];expected={r['id']:[r['X_index'],r['Z_index']] for r in cases};records=[]
 for record in survey['records']:
  if record['status']!='FINISHED':continue
  p=a.survey.parent/record['certificate_file'];raw=p.read_bytes();d=json.loads(raw);assert d['anchor']==expected[record['id']]
  count=replay(X,Z,A,d)
  try:replay(X,Z,A,d,True)
  except AssertionError:pass
  else:raise AssertionError('dropped-term corruption accepted')
  records.append({'id':record['id'],'anchor':d['anchor'],'positive_atoms_checked':count,'certificate_sha256':hashlib.sha256(raw).hexdigest()})
 assert len({r['id'] for r in records})==len(records)
 out={'status':'PASS','source_C16_answered':False,'physical_pairings_rebuilt':518400,'retained_cases_total':len(expected),'positive_span_certificates_checked':len(records),'all_retained_cases_checked':len(records)==len(expected),'dropped_term_negative_controls_rejected':len(records),'records':records,'elapsed_seconds':time.monotonic()-start,'scope':'The residual identity lies in the unrestricted binary span of anchor-compatible atoms. Thus no linear inverse-identity separator can exclude these anchors. The combinations need not satisfy mutual compatibility, so no full frame or completed source case follows. Producer rank values are not consumed.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS positive spans',len(records),flush=True)
if __name__=='__main__':main()
