#!/usr/bin/env python3
"""Select source-proved conditional phase nogoods violated by a numeric point."""
from pathlib import Path
import argparse,hashlib,json
import numpy as np
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--profiles',type=Path,nargs='+',required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--max-cuts',type=int,default=500);ap.add_argument('--tolerance',type=float,default=1e-4);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();point=np.load(a.point);p=point['p'];S={h:point[f'S{h}'] for h in range(9)}
 for h in range(9,16):S[h]=S[16-h].T
 tested=0;violations=[];maximum=-float('inf');sources=[]
 for path in a.profiles:
  raw=path.read_bytes();d=json.loads(raw);anchor=d['conditioned_on_X_index'];assert anchor%16==0;sources.append({'file':path.name,'sha256':hashlib.sha256(raw).hexdigest(),'anchor_X_index':anchor})
  for r in d['records']:
   o=r['orbit']
   for index,c in enumerate(r['minimal_bad_certificates']):
    mask=c['mask'];value=sum(S[h][anchor//16,o] for h in range(16) if mask>>h&1)-(mask.bit_count()-1)*p[anchor//16];tested+=1;maximum=max(maximum,float(value))
    if value>a.tolerance:violations.append({'anchor_X_index':anchor,'orbit':o,'mask':mask,'source_file':path.name,'source_certificate_index':index,'numeric_violation':float(value)})
 violations.sort(key=lambda r:(-r['numeric_violation'],r['anchor_X_index'],r['orbit'],r['mask']));cuts=violations[:a.max_cuts];out={'status':'NUMERIC_POINT_SEPARATION_COMPLETE','source_C16_answered':False,'point_file':a.point.name,'point_sha256':hashlib.sha256(a.point.read_bytes()).hexdigest(),'sources':sources,'valid_source_nogoods_tested':tested,'violations_above_tolerance':len(violations),'maximum_numeric_violation':maximum,'tolerance':a.tolerance,'cuts':cuts,'scope':'Selection by floating arithmetic only; selected inequalities still require physical witness replay. No statement of exact relaxation feasibility or full-frame existence.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['cuts','sources']})
if __name__=='__main__':main()
