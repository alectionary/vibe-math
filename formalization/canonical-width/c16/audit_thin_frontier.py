#!/usr/bin/env python3
"""Read-only application of the proved three-thin condition to frozen leaves."""
from pathlib import Path
import argparse,gzip,json,hashlib
from itertools import product
from verify_inverse_lift import vp,mp,outer,shifts

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--archive',type=Path,default=Path(__file__).parent/'six-hours-results/frontier/campaign.json.gz');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();root=Path(__file__).parent;source=json.loads((root/'inversion-results/normal-form.json').read_text());q=source['dictionary'];labels={}
 for side in ['X','Z']:
  lookup={mp(v):i for i,v in enumerate(source['tensor'][side+'_tensor_coordinates'])};lab=[None]*720
  for i,c in product(range(9),range(5)):
   v=outer(vp(q['X_left_dictionary'][i]),vp(q['X_right_factors'][c])) if side=='X' else outer(vp(q['Z_left_factors'][c]),vp(q['Z_right_dictionary'][i]))
   for z in shifts(v):
    j=lookup[z];assert lab[j] is None;lab[j]=c
  assert None not in lab;labels[side]=lab
 with gzip.open(a.archive,'rt') as f:d=json.load(f)
 for name,digest in d['source_sha256'].items():assert hashlib.sha256((root/name).read_bytes()).hexdigest()==digest
 m=d['manifest'];unresolved=m['unresolved_ids'];cuts=[];hist={}
 masks={s:[sum((labels[s][i]==c)<<i for i in range(720)) for c in range(5)] for s in ['X','Z']}
 for ident in unresolved:
  p=d['inputs'][str(ident)].split();assert p[0]=='TASK';n=int(p[5]);assert len(p)==6+2*n and int(p[1])==128-n;potential=[]
  for side,col,off in [('X',3,0),('Z',4,1)]:
   candidates=int(p[col],16);fixed=[int(p[6+2*j+off]) for j in range(n)];fm=sum(1<<i for i in fixed);possible=candidates|fm;families=[c for c in range(5) if possible&masks[side][c]];potential.append(families)
  key=str(tuple(map(len,potential)));hist[key]=hist.get(key,0)+1
  if min(map(len,potential))<3:cuts.append({'id':ident,'remaining':int(p[1]),'possible_X_thin':potential[0],'possible_Z_thin':potential[1]})
 r={'status':'PASS','scope':'Frozen unresolved leaves screened only by the separately certified necessary three-thin condition; no tree resumed','archive_SHA256':hashlib.sha256(a.archive.read_bytes()).hexdigest(),'unresolved_leaves_screened':len(unresolved),'newly_excluded_leaf_count':len(cuts),'remaining_unexcluded_leaves':len(unresolved)-len(cuts),'family_count_histogram':hist,'excluded_leaves':cuts,'source_C16_answered':False,'global_runtime_speedup_demonstrated':False};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='excluded_leaves'}))
if __name__=='__main__':main()
