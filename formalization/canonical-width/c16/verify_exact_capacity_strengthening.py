#!/usr/bin/env python3
"""Exact separation of the earlier certified basic SDP point by new cuts."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,subprocess,sys,tempfile,time
from verify_algebraic_model import physical
from verify_moment_certificate import verify
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();old=ROOT/'structural-results/c16-structural-sdp-certified.rational.json.gz';oldbytes=old.read_bytes();data=json.loads(gzip.decompress(oldbytes));X,Z,A=physical()
 for side,values in [('x',X),('z',Z)]:assert values==[int(v,16) for v in (ROOT/f'pools/{side}coords.txt').read_text().split()]
 assert all((A[i]>>j&1)==(A[j]>>i&1) for i in range(720) for j in range(720));oldcheck=verify(data,ROOT);assert oldcheck['status']=='PASS'
 source=ROOT/'algebraic-results/orbit-rank-profiles.json'
 with tempfile.TemporaryDirectory(prefix='c16-exact-strengthening-') as folder:
  report=Path(folder)/'profile.json';subprocess.run([sys.executable,str(ROOT/'verify_orbit_rank_profiles.py'),'--certificate',str(source),'--output',str(report)],check=True,capture_output=True,text=True,timeout=180);capsource=json.loads(report.read_text());assert capsource['status']=='PASS' and capsource['orbits_checked']==45
 first=list(map(Q,data['p']));C={int(h):[[Q(v) for v in row] for row in M] for h,M in data['C'].items()}
 for h in range(9,16):C[h]=list(map(list,zip(*C[16-h])))
 caps=[min(r['full_frame_count_upper_bound'],11 if r['orbit']==12 else 16) for r in capsource['records']];bad=[];average_bad=[]
 for i in range(90):
  for sector in [0,45]:
   for o in range(45):
    lhs=sum(C[h][i][sector+o] for h in range(16));rhs=caps[o]*first[i]
    if lhs>rhs:bad.append({'anchor_type':i,'counted_type':sector+o,'bound':caps[o],'lhs':str(lhs),'rhs':str(rhs),'positive_gap':str(lhs-rhs)})
 for i in range(45):
  p=(first[i]+first[45+i])/2
  for kind in ['same_sector','cross_sector']:
   for o in range(45):
    lhs=sum((C[h][i][o]+C[h][45+i][45+o])/2 if kind=='same_sector' else (C[h][i][45+o]+C[h][45+i][o])/2 for h in range(16));rhs=caps[o]*p
    if lhs>rhs:average_bad.append({'anchor_orbit':i,'counted_orbit':o,'kind':kind,'bound':caps[o],'lhs':str(lhs),'rhs':str(rhs),'positive_gap':str(lhs-rhs)})
 assert bad
 out={'status':'PASS_EXACT_STRICT_STRENGTHENING','source_C16_answered':False,'old_point_sha256':hashlib.sha256(oldbytes).hexdigest(),'old_point_full_rational_and_interval_PSD_replay':oldcheck['evidence'],'source_phase_witnesses_replayed':True,'source_phase_certificate_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'earlier_certified_basic_point_violations':len(bad),'sector_exchange_averaged_old_point_violations':len(average_bad),'violations':bad,'averaged_violations':average_bad,'elapsed_seconds':time.monotonic()-start,'scope':'New source-valid occupancy RLT cuts exclude an exactly certified feasible point of the earlier basic relaxation. This does not establish infeasibility of the strengthened relaxation or answer the original C16 question.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('PASS exact old-point violations',len(bad),'exchange-average violations',len(average_bad),flush=True)
if __name__=='__main__':main()
