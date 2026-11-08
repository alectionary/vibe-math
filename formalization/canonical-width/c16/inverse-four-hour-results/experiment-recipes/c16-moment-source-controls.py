from pathlib import Path
import sys,json,itertools,copy
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from moment_circuit_cuts import source_vectors,validate
from moment_triangle_cuts import literal_control
from verify_inverse_lift import mp,parts,cyclic,F
from audit_pools import exchange
from verify_partial_frame import shift,mask
root=Path('/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16');source=json.load(open(root/'inversion-results/normal-form.json'));V={s:source_vectors(source,s) for s in ['X','Z']};indices={s:{v:i for i,v in enumerate(V[s])} for s in V};reps=json.load(open('/private/tmp/c16-new-structured-circuits6.json'));checked=0
for side in ['X','Z']:
 for S in reps[side]:validate({'sector':side,'circuit':S},source,V[side]);checked+=1
physical=json.load(open(root/'physical-pool-source.json'));zp=[shift(mask(v),h) for v in physical['Z_orbit_representatives'] for h in range(16)];xp=[exchange(v) for v in zp];ix={v:i for i,v in enumerate(xp)};iz={v:i for i,v in enumerate(zp)};sx=list(map(mp,source['tensor']['X_tensor_coordinates']));sz=list(map(mp,source['tensor']['Z_tensor_coordinates']));pairs=[(sx[ix[mask(p['X'])]],sz[iz[mask(p['Z'])]]) for p in json.load(open(root/'partial-frame-88.json'))['pairs']];masks=[0]*90
word=lambda v:[(a>>h&1)|((b>>h&1)<<1) for a,b in map(cyclic,parts(v)) for h in range(16)];xt=[word(x) for x,z in pairs];zt=[word(z) for x,z in pairs];assert all(sum((F[a][b]>>1)&1 for a,b in zip(x,z))%2==(i==j) for i,x in enumerate(xt) for j,z in enumerate(zt))
for x,z in pairs:
 for side,v,offset in [('X',x,0),('Z',z,45)]:i=indices[side][v];masks[offset+i//16]|=1<<(i%16)
p=[v.bit_count() for v in masks];C={h:[[(a&(((b>>h)|(b<<(16-h)))&65535)).bit_count() for b in masks] for a in masks] for h in range(16)};count=0
for side in ['X','Z']:
 offset=0 if side=='X' else 45
 for S in reps[side]:
  for phase in range(16):
   for i in range(90):assert sum(C[(v%16+phase)%16][i][offset+v//16] for v in S)<=(len(S)-1)*p[i];count+=1
triangles=json.load(open('/private/tmp/c16-new-global-triangle-cuts.json'))
for t in triangles:
 i,j,k=[t[v] for v in ['i','j','k']];h,l=[t[v] for v in ['h','l']];a,b,c=C[h][i][j],C[l][i][k],C[(l-h)%16][j][k]
 assert (a+b-c<=p[i]) if t['kind']==0 else (p[i]+p[j]+p[k]-a-b-c<=16)
rejected=[]
for side in ['X','Z']:
 bad={'sector':side,'circuit':reps[side][0].copy()};bad['circuit'][0]=(bad['circuit'][0]+1)%720
 try:validate(bad,source,V[side])
 except AssertionError:rejected.append(side)
 else:raise AssertionError('Invalid circuit accepted')
r={'status':'PASS','literal_Boolean_triangle_control':literal_control(),'source_circuit_orbits_verified':checked,'physical88_literal_Gram_pairings':7744,'physical88_conditional_circuit_controls':count,'physical88_triangle_controls':len(triangles),'invalid_source_circuit_rejections':rejected,'source_C16_answered':False};Path('/private/tmp/c16-new-joint-source-controls.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True)
