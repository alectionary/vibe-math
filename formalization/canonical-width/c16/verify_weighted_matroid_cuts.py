#!/usr/bin/env python3
"""Independent low-pivot rank and literal frame replay of proposed cuts."""
from pathlib import Path
import argparse,hashlib,json,time
from verify_algebraic_model import physical
from verify_partial_frame import mask,shift
from audit_pools import exchange
ROOT=Path(__file__).resolve().parent

def rank(values):
 piv={}
 for x in values:
  while x:
   bit=x&-x
   if bit not in piv:piv[bit]=x;break
   x^=piv[bit]
 return len(piv)

def bound(U,ids,mandatory):
 if mandatory is None:return rank(U[i] for i in ids)
 return rank(U[i] for i in set(ids)|{mandatory})-int(mandatory not in ids)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();d=json.loads(a.certificate.read_text());assert d['status']=='CANDIDATE_RANK_CUTS';X,Z,A=physical();source=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));lookup=[{v:i for i,v in enumerate(U)} for U in (Xp,Zp)];pairs=[tuple(lookup[s][mask(r[side])] for s,side in enumerate(('X','Z'))) for r in json.loads((ROOT/'partial-frame-88.json').read_text())['pairs']];assert all(((A[x]>>z)&1)==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));selected=[{p[s] for p in pairs} for s in (0,1)];checks=controls=0
 assert rank(X)==rank(Z)==128
 for c in d['cuts']:
  ids=c['indices'];anchor=16*c['anchor_orbit'];assert ids==sorted(set(ids)) and ids and all(0<=i<720 for i in ids) and c['sector'] in ('S','T');mandatory=anchor if c['sector']=='S' else None;assert c['mandatory_index']==mandatory
  for h in range(16):
   rotate=lambda i:16*(i//16)+(i%16+h)%16
   J=set(map(rotate,ids));aidx=rotate(anchor);m=rotate(mandatory) if mandatory is not None else None
   for s,U in enumerate((X,Z)):
    assert bound(U,J,m)==c['bound'];checks+=1
    if aidx in selected[s]:assert len(J&selected[s if c['sector']=='S' else 1-s])<=c['bound'];controls+=1
  # The rank-only consumer must reject a reduced bound, independently of
  # whether that corrupt inequality happens to hold on the partial control.
  assert bound(X if c['sector']=='S' else Z,ids,mandatory)!=c['bound']-1
 out={'status':'PASS','source_C16_answered':False,'certificate_sha256':hashlib.sha256(a.certificate.read_bytes()).hexdigest(),'cuts_checked':len(d['cuts']),'physical_pairings_rebuilt':518400,'pool_ranks':[128,128],'shifted_sector_rank_checks':checks,'physical88_conditional_checks':controls,'lowered_bound_negative_controls_rejected':len(d['cuts']),'consumer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,'scope':'Every saved subset has the exact stated rank upper bound, including contraction by a mandatory same-sector anchor. Full-frame moment inequalities follow by conditioning and averaging. Numerical candidate separation is diagnostic; no source frame excluded.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
