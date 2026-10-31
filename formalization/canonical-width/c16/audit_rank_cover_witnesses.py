#!/usr/bin/env python3
"""Exact frozen witness comparison for the rank-strengthened cover criterion."""
from pathlib import Path
import argparse,gzip,hashlib,json,time
from verify_anchored_cover_chain import physical,canonical
from verify_algebraic_model import physical as vectors
from small_conditional_rank_cuts import verify
from rank_cover_cuts import family,violation,CUTS

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--chain',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();X,Z,AA=vectors();data=json.loads(gzip.decompress(CUTS.read_bytes()))
 for c in data['cuts']:verify(X,Z,AA,c)
 A,C,pos,sig=physical();assert A==AA;F=family();d=json.loads(a.chain.read_text());by={}
 for pairs in d['seed_witnesses']+[r['counterexample_edges'] for r in d['records'] if r['answer'] is True]:
  value=0
  for k,(i,j) in enumerate(pairs):
   assert sig[i,j];value^=sig[i,j]
   for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
  assert value==65535;key=tuple(sorted({pos[canonical(i,j)] for i,j in pairs}));by.setdefault(key,pairs)
 records=[]
 for S,pairs in sorted(by.items()):records.append({'support_class_indices':list(S),'pairs':pairs,'rank_violation':violation(pairs,F)})
 n=sum(r['rank_violation'] is not None for r in records);out={'status':'PASS_EXACT_FROZEN_COMPARISON','source_C16_answered':False,'cohort_supports':len(records),'source_rank_witnesses_replayed':len(data['cuts']),'translated_X_nogoods':len(F),'partial_witnesses_rejected_by_rank_rules':n,'rank_compatible_witnesses':len(records)-n,'chain_sha256':hashlib.sha256(a.chain.read_bytes()).hexdigest(),'rank_certificate_sha256':hashlib.sha256(CUTS.read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'records':records,'scope':'Every original positive witness is physically replayed. Rejection concerns full-frame extendibility under the source rank rules, not validity as an arbitrary partial matching. This is not a smaller cover or measured runtime gain.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'},flush=True)
if __name__=='__main__':main()
