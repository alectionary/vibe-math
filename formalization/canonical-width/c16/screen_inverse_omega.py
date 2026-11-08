from pathlib import Path
import sys,json,time
from collections import Counter
from pool_inverse_structure import matvec,words,pack
import argparse
ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args();root=Path(__file__).parent;d=json.loads(args.certificate.read_text())['dictionary'];Omega=d['Omega_original_coordinates'];X=[int(v,16) for v in (root/'pools/xcoords.txt').read_text().split()];Z=[int(v,16) for v in (root/'pools/zcoords.txt').read_text().split()];OX=[pack(matvec(Omega,words(v))) for v in X]
rows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X];brows=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in OX];columns=[sum(((row>>j)&1)<<i for i,row in enumerate(rows)) for j in range(720)];bcolumns=[sum(((row>>j)&1)<<i for i,row in enumerate(brows)) for j in range(720)];zero=[];hist=Counter();start=time.monotonic()
for i,row in enumerate(rows):
 if i%16:continue # common cyclic action covers every pair orbit.
 J=brows[i]&~row
 for j in range(720):
  if not row>>j&1:continue
  I=bcolumns[j]&~columns[j];count=0
  while I:
   bit=I&-I;I^=bit;k=bit.bit_length()-1;count+=(rows[k]&J).bit_count()
  hist[count]+=1
  if not count:zero.append((i,j))
r={'pair_orbits':sum(hist.values()),'zero_neighbor_orbits':zero,'minimum_auxiliary_degree':min(hist),'maximum_auxiliary_degree':max(hist),'degree_histogram':dict(hist),'seconds':time.monotonic()-start,'scope':'All common-translation pair orbits; absence of zero-neighbor vertices gives no full-frame existence conclusion.'};args.output.write_text(json.dumps(r,indent=2)+'\n');print({k:v for k,v in r.items() if k!='degree_histogram'})
