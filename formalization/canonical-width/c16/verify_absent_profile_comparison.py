#!/usr/bin/env python3
"""Complete mask comparison for one source-vector deletion pilot."""
from pathlib import Path
import argparse,gzip,hashlib,json
import numpy as np
from verify_quotient_restriction_identity import bad

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--original',type=Path,required=True);ap.add_argument('--deleted',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();old=json.loads(a.original.read_text());new=json.loads(gzip.decompress(a.deleted.read_bytes()));records=[];assert new['conditioned_on_X_absent']==336 and len(old['records'])==len(new['records'])==45
 for r,s in zip(old['records'],new['records']):
  assert r['orbit']==s['orbit'];x,y=bad(r),bad(s);assert not np.any(x&~y);records.append({'orbit':r['orbit'],'old_rank_survivors':int(sum(~x)),'new_rank_survivors':int(sum(~y)),'newly_excluded':int(sum(y&~x))})
 out={'status':'PASS_EXACT_MASK_COMPARISON','source_C16_answered':False,'fixed_absent_X_index':336,'old_sha256':hashlib.sha256(a.original.read_bytes()).hexdigest(),'new_sha256':hashlib.sha256(a.deleted.read_bytes()).hexdigest(),'newly_excluded_masks':sum(r['newly_excluded'] for r in records),'records':records,'scope':'One deleted-vector pilot only. Physical witnesses are separate replay dependencies; the other44 normalized deletion cases are not established.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k!='records'})
if __name__=='__main__':main()
