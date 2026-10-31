from pathlib import Path
import sys,json,numpy as np
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from rectangular_moment_sdp import source_patterns
root=Path('/private/tmp');s=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));patterns=np.array(source_patterns(s,list(range(5))),dtype=np.uint16);q=np.load(root/'c16-new-lattice-source-moments.npz');p=q['first'];C={h:q[f'C{h}'] for h in range(9)};C.update({h:C[16-h].T for h in range(9,16)});idx=np.arange(720);a=idx//16;h=idx%16;A=((patterns[a[:,None],a[None,:]]>>((h[None,:]-h[:,None])%16))&1).astype(float)
FX=np.array([[C[phase][i,45+j] for j in range(45) for phase in range(16)] for i in range(45)])*A[::16,:];FZ=np.array([[C[phase][45+i,j] for j in range(45) for phase in range(16)] for i in range(45)])*A[:,::16].T;common=[FX@A.T,FZ@A];cuts=[];maximum=0
for side in range(2):
 for i in range(45):
  for k in range(720):
   if k==16*i:continue
   v=float(C[k%16][45*side+i,45*side+k//16]+common[side][i,k]-p[45*side+i]);maximum=max(maximum,v)
   if v>1e-5:cuts.append({'i':45*side+i,'k':45*side+k//16,'l':k%16,'violation':v})
cuts.sort(key=lambda c:c['violation'],reverse=True);r={'maximum_violation':maximum,'violated_cuts':len(cuts),'cuts':cuts[:5000],'source_C16_answered':False};(root/'c16-new-owner-moment-screen.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({k:v for k,v in r.items() if k!='cuts'}),flush=True)
