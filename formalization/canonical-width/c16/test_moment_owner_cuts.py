from pathlib import Path
import sys,json,copy,itertools
ROOT=Path(__file__).parent
sys.path.insert(0,str(ROOT))
from rank_moment_dual import patterns_from_source
from moment_owner_cuts import coefficients,common_events,neighbor_polynomials
from moment_circuit_cuts import source_vectors
from verify_two_thin_obstruction import tbits,tracecov
from block_moment_dual import layout
from verify_inverse_lift import mp
from audit_pools import exchange
from verify_partial_frame import mask,shift
import argparse,gzip
ap=argparse.ArgumentParser();ap.add_argument('--cuts',type=Path,default=ROOT/'inverse-four-hour-results/all-owner-cuts.json.gz');ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();root=ROOT;source=json.load(open(root/'inversion-results/normal-form.json'));patterns=patterns_from_source(source,list(range(5)));V={s:source_vectors(source,s) for s in ['X','Z']};xt=list(map(tbits,V['X']));zc=list(map(tracecov,V['Z']));neighborsX=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(zc)) for x in xt];neighborsZ=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(xt)) for z in zc];owners=json.loads(gzip.decompress(a.cuts.read_bytes()) if a.cuts.suffix=='.gz' else a.cuts.read_bytes());neighbor_cache=neighbor_polynomials(patterns);p,C,N=layout(90,16);reverse={v:('p',i) for i,v in enumerate(p)}
for h in range(16):
 for i in range(90):
  for j in range(90):reverse.setdefault(C[h][i][j],('C',h,i,j))
physical=json.load(open(root/'physical-pool-source.json'));zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp];ix={v:i for i,v in enumerate(xp)};iz={v:i for i,v in enumerate(zp)};sx=list(map(mp,source['tensor']['X_tensor_coordinates']));sz=list(map(mp,source['tensor']['Z_tensor_coordinates']));index={side:{v:i for i,v in enumerate(V[side])} for side in V};masks=[0]*90
for pair in json.load(open(root/'partial-frame-88.json'))['pairs']:
 for side,v,offset in [('X',sx[ix[mask(pair['X'])]],0),('Z',sz[iz[mask(pair['Z'])]],45)]:j=index[side][v];masks[offset+j//16]|=1<<(j%16)
def moment(j):
 key=reverse[j]
 if key[0]=='p':return masks[key[1]].bit_count()
 _,h,i,k=key;b=masks[k];return (masks[i]&(((b>>h)|(b<<(16-h)))&65535)).bit_count()
source_common_checks=0
for cut in owners:
 i,k,l=[cut[t] for t in ['i','k','l']];side='X' if i<45 else 'Z';offset=0 if side=='X' else 45;other=45-offset;neighbors=neighborsX if side=='X' else neighborsZ;common=neighbors[(i-offset)*16]&neighbors[(k-offset)*16+l];expected={(other+j//16,j%16) for j in range(720) if common>>j&1};actual=set(common_events(cut,patterns,neighbors=neighbor_cache));assert actual==expected;source_common_checks+=720
 row,rhs=coefficients(cut,patterns,p,C,neighbors=neighbor_cache);assert sum(a*moment(j) for j,a in row)<=16*rhs
 # Direct realization check under all16 translations of the physical frame.
 for h in range(16):
  ai=masks[i]>>h&1;ak=masks[k]>>((h+l)%16)&1;flow=sum(ai*(masks[j]>>((h+phase)%16)&1) for j,phase in actual);assert ai*ak+flow<=ai
rejected=[]
for kind in ['same_leaf','opposite_leaf','phase_out_of_range']:
 bad=copy.deepcopy(owners[0])
 if kind=='same_leaf':bad['k']=bad['i'];bad['l']=0
 if kind=='opposite_leaf':bad['k']=(bad['i']+45)%90
 if kind=='phase_out_of_range':bad['l']=16
 try:common_events(bad,patterns,neighbors=neighbor_cache)
 except AssertionError:rejected.append(kind)
 else:raise AssertionError('Invalid owner cut accepted')
# Exhaustive small graph controls, each with a full known canonical matching.
literal=0
for n in range(1,5):
 for bits in range(1<<(n*n)):
  A=[[bits>>(i*n+j)&1 for j in range(n)] for i in range(n)]
  for X in range(1<<n):
   for Z in range(1<<n):
    if any(X>>i&1 and sum(Z>>j&1 for j in range(n) if A[i][j])!=1 for i in range(n)):continue
    if any(Z>>j&1 and sum(X>>i&1 for i in range(n) if A[i][j])!=1 for j in range(n)):continue
    for i in range(n):
     for k in range(n):
      if i==k:continue
      common=[j for j in range(n) if A[i][j] and A[k][j]];assert (X>>i&1)*(X>>k&1)+sum((X>>i&1)*(Z>>j&1) for j in common)<=(X>>i&1);literal+=1
  if n==4 and bits>=1000:break
r={'status':'PASS','source_owner_cuts':len(owners),'independent_source_common_neighbor_sets_compared':len(owners),'physical88_exact_averaged_owner_controls':len(owners),'physical88_direct_translations':16*len(owners),'small_graph_canonical_matching_controls':literal,'invalid_owner_inputs_rejected':rejected,'small_graph_scope':'All graphs through3+3 vertices; first1001 graphs on4+4 vertices. Every canonical matching selector in those graphs is checked.','source_C16_answered':False};a.output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
