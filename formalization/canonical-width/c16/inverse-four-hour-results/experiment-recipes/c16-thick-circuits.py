from pathlib import Path
import sys,json,time
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from inverse_block_sat import circuits
from verify_inverse_lift import vp,vshifts
root=Path('/private/tmp');s=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));out={};start=time.monotonic()
for side,key in [('X','X_left_dictionary'),('Z','Z_right_dictionary')]:
 V=[v for a in map(vp,s['dictionary'][key]) for v in vshifts(a)];cs=circuits(V,6)
 normalize=lambda t:min(tuple(sorted((i//16)*16+(i%16+h)%16 for i in t)) for h in range(16))
 reps=sorted({normalize(t) for t in cs});out[side]=reps;print(side,'counts',{str(k):sum(len(c)==k for c in cs) for k in range(3,7)},'orbits',len(reps),'seconds',time.monotonic()-start,flush=True)
(root/'c16-new-thick-circuits6.json').write_text(json.dumps(out)+'\n')
