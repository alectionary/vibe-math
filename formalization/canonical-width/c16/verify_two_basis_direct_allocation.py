#!/usr/bin/env python3
"""Independent literal acceptance of a direct count/box allocation.

This verifies all retained marginals and bucket equalities, but intentionally
does not assert membership in any zero-matroid base polytope.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains,target

ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())

def check_allocation(y,lam,dd,b):
 assert len(y)==16 and all(len(row)==720 for row in y)
 assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
 got=[sum(y[m][j] for m in range(16)) for j in range(720)]
 got += [sum(y[m][j] for m in range(16) if m&(1<<i)) for i in range(4) for j in range(720)]
 assert got==b
 fixed_checks=owner_checks=zero_checks=0
 for m,d in enumerate(dd):
  assert d['feasible']
  allowed=set(d['zero_forced'])|set(d['zero_free'])|{j for bin in d['bins'] for j in bin}
  assert sum(y[m])==128*lam[m]
  for j,v in enumerate(y[m]):
   assert 0<=v<=lam[m]
   if j not in allowed:assert v==0;fixed_checks+=1
   if j in d['forced']:assert v==lam[m];fixed_checks+=1
  assert sum(y[m][j] for j in [*d['zero_forced'],*d['zero_free']])==d['zero_required']*lam[m];zero_checks+=1
  for bin in d['bins']:assert sum(y[m][j] for j in bin)==lam[m];owner_checks+=1
 return dict(feature_equalities=3600,box_coordinates=11520,pattern_cardinality_equations=16,
             fixed_coordinate_checks=fixed_checks,zero_bucket_equations=zero_checks,owner_bucket_equations=owner_checks)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic()
 bank=read(a.certificate);stem=a.certificate.name.removesuffix('.json.gz').removesuffix('.json');fp=a.certificate.with_name(stem+'.frozen.json');f=read(fp)
 assert bank['status']=='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY' and bank['frozen_sha256']==sha(fp)
 assert f['point_sha256']==sha(a.point) and all(sha(ROOT/p)==h for p,h in f['source_hashes'].items())
 X,Z,_=physical_source();xx,zz,side=f['X_anchors'],f['Z_anchors'],f['side'];dd=[r[side] for r in domains(X,Z,xx,zz)]
 lam=list(map(Q,f['lambda_masses']));full=target(a.point,xx,zz);offset=720*int(side=='Z')
 b=full[11+offset:731+offset]+[full[1451+1440*i+offset+j] for i in range(4) for j in range(720)]
 assert list(map(Q,bank['sector_target']))==b
 for k,mask in enumerate([0,1,2,4,8,3,5,9,6,10,12]):assert sum(lam[m] for m in range(16) if m&mask==mask)==full[k]
 y=[list(map(Q,row)) for row in bank['exact_allocations']];checks=check_allocation(y,lam,dd,b)
 for face in f['local_face_fixes']:
  j,m,v=face['vector'],face['mask'],list(map(int,face['normal']));assert len(v)==5
  wanted=[b[720*k+j] for k in range(5)];upper=Q(0)
  for q,d in enumerate(dd):
   dot=v[0]+sum(v[i+1] for i in range(4) if q>>i&1)
   allowed=set(d['zero_forced'])|set(d['zero_free'])|{z for bin in d['bins'] for z in bin}
   upper+=lam[q]*(dot if j in d['forced'] else max(0,dot) if j in allowed else 0)
  assert sum(a0*b0 for a0,b0 in zip(v,wanted))==upper
  dot=v[0]+sum(v[i+1] for i in range(4) if m>>i&1);assert dot
  assert y[m][j]==Q(face['value'])==(lam[m] if dot>0 else 0)
 # Each mutation is evaluated from scratch; no producer reconstruction used.
 rejected=[]
 for label,mutate in [('negative coordinate',lambda z:z[0].__setitem__(0,Q(-1))),
                      ('changed marginal',lambda z:z[0].__setitem__(0,z[0][0]+Q(1,1<<50))),
                      ('changed selected anchor',lambda z:z[15].__setitem__(xx[0] if side=='X' else zz[0],Q(1)))]:
  z=[list(row) for row in y];mutate(z)
  try:check_allocation(z,lam,dd,b)
  except AssertionError:rejected.append(label)
  else:raise AssertionError('corruption accepted')
 out=dict(status='PASS_EXACT_DIRECT_PATTERN_COUNT_ALLOCATION',source_C16_answered=False,
          certificate_sha256=sha(a.certificate),frozen_sha256=sha(fp),point_sha256=sha(a.point),
          consumer_sha256=sha(__file__),physical_consumer_sha256=sha(ROOT/'verify_two_sided_full_basis_oracle.py'),
          X_anchors=xx,Z_anchors=zz,side=side,checks=checks,anchor_moment_equalities=11,
          exact_local_face_fixes_checked=len(f['local_face_fixes']),corruption_controls=rejected,
          full_zero_matroid_membership_proved=False,source_frame_proved=False,
          elapsed_seconds=time.monotonic()-start,
          scope='Exact common-pattern count/box allocation only; zero-matroid rank inequalities remain unchecked.')
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)

if __name__=='__main__':main()
