#!/usr/bin/env python3
"""Bind the added half-turn clauses to independently checked physical nogoods.

The prior half-turn encoder is a separate dependency. This consumer establishes
only that the added clauses are exactly the claimed valid restrictions.
"""
from pathlib import Path
import argparse,gzip,hashlib,json,time

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--base',type=Path,required=True);ap.add_argument('--cnf',type=Path,required=True);ap.add_argument('--profiles',type=Path,required=True);ap.add_argument('--replay',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();raw=a.profiles.read_bytes();source=gzip.decompress(raw) if a.profiles.suffix=='.gz' else raw;d=json.loads(source);r=json.loads(a.replay.read_text());assert r['status']=='PASS' and r['certificate_sha256']==hashlib.sha256(raw).hexdigest() and r['orbits_checked']==45
 base=a.base.read_text().splitlines();actual=a.cnf.read_text().splitlines();bh=base[0].split();ah=actual[0].split();assert bh[:2]==ah[:2]==['p','cnf'] and bh[2]==ah[2];assert actual[1:len(base)]==base[1:];extra=[];physical_witnesses=0
 for record in d['records']:
  o=record['orbit'];projected=set()
  for cert in record['minimal_bad_certificates']:
   H=cert['mask'];Q=sum(1<<h for h in range(8) if H & ((1<<h)|(1<<(h+8))));assert all((Q>>(h%8))&1 for h in range(16) if H>>h&1);projected.add(Q);physical_witnesses+=1
  for Q in sorted(projected):
   if any(R!=Q and R&Q==R for R in projected):continue
   for side in [0,1]:extra.append(' '.join(str(-(side*360+o*8+h+1)) for h in range(8) if Q>>h&1)+' 0')
 assert actual[len(base):]==extra and int(ah[3])==int(bh[3])+len(extra)
 out={'status':'PASS','source_C16_answered':False,'restricted_to_halfturn':True,'added_clauses_checked':len(extra),'physical_nogoods_consumed':physical_witnesses,'base_sha256':hashlib.sha256(a.base.read_bytes()).hexdigest(),'cnf_sha256':hashlib.sha256(a.cnf.read_bytes()).hexdigest(),'source_replay_sha256':hashlib.sha256(a.replay.read_bytes()).hexdigest(),'scope':'Each half-turn selected phase represents both original phases h and h+8; projected clauses forbid a physical nogood. Does not establish UNSAT or independently validate the earlier base encoder.','elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
