#!/usr/bin/env python3
"""Literal synthetic controls for dimension and ineligible-vector handling."""
from pathlib import Path
import argparse,json,subprocess,tempfile
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--binary',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();records=[]
 with tempfile.TemporaryDirectory(prefix='c16-profile-dimension-controls-') as folder:
  p=Path(folder)
  for missing in [False,True]:
   X=[1,0,2,4]+[0]*716;Z=[1,2]+([] if missing else [4]);Z +=[0]*(720-len(Z));xp=p/'x.txt';zp=p/'z.txt';out=p/'out.json';xp.write_text('\n'.join(f'{v:x}' for v in X)+'\n');zp.write_text('\n'.join(f'{v:x}' for v in Z)+'\n');run=subprocess.run([str(a.binary),str(xp),str(zp),str(out),'10','0','1','3'],capture_output=True,text=True,check=True,timeout=15);d=json.loads(out.read_text());r=d['records'][0];assert r['eligible_mask']==13 and r['complete'];assert r['maximum_surviving_count']==(-1 if missing else 3)
   if missing:assert r['minimal_bad_certificates'][0]['mask']==0 and int(r['minimal_bad_certificates'][0]['annihilator_hex'],16)==4 and sum(r['survivors_by_weight'])==0
   else:
    assert sum(r['survivors_by_weight'])==8 and not r['minimal_bad_certificates'];pairs=[(0,0),(2,1),(3,2)];assert all((X[i]&Z[j]).bit_count()%2==(s==t) for s,(i,_) in enumerate(pairs) for t,(_,j) in enumerate(pairs))
   records.append({'ambient_dimension':3,'missing_third_Z_direction':missing,'maximum_surviving_count':r['maximum_surviving_count'],'eligible_mask':r['eligible_mask'],'explicit_full_frame_control':not missing,'empty_selection_rank_obstruction_checked':missing})
  X=[1,1,2,4]+[0]*716;Z=[1,2,4]+[0]*717;xp=p/'dependent-x.txt';zp=p/'dependent-z.txt';out=p/'dependent.json';xp.write_text('\n'.join(f'{v:x}' for v in X)+'\n');zp.write_text('\n'.join(f'{v:x}' for v in Z)+'\n');subprocess.run([str(a.binary),str(xp),str(zp),str(out),'10','0','1','3'],capture_output=True,text=True,check=True,timeout=15);r=json.loads(out.read_text())['records'][0];assert r['eligible_mask']==15 and r['complete'] and r['maximum_surviving_count']==3 and sum(r['survivors_by_weight'])==12;assert any(c['mask']==3 and c['kind']=='missing_private' for c in r['minimal_bad_certificates']);records.append({'ambient_dimension':3,'dependent_projected_dictionary':True,'maximum_surviving_count':3,'surviving_masks_checked':12,'duplicate_pair_forbidden':True})
 a.output.write_text(json.dumps({'status':'PASS','source_C16_answered':False,'synthetic_only':True,'controls':records},indent=2)+'\n');print('PASS dimension/placeholder controls',len(records))
if __name__=='__main__':main()
