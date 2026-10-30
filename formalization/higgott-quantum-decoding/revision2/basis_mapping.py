"""Explicit canonical pairing and boundary sensitivity; not published-path recovery."""
import sys,json
from pathlib import Path
import numpy as np,stim
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root))
from circuits import with_duration

def inverse(a):
 n=len(a);v=np.concatenate([a.copy(),np.eye(n,dtype=np.uint8)],axis=1)
 for j in range(n):
  k=next(i for i in range(j,n) if v[i,j]);v[[j,k]]=v[[k,j]]
  for i in range(n):
   if i!=j and v[i,j]:v[i]^=v[j]
 return v[:,n:]
def main():
 result=[]
 for tick in [7,43]:
  regs={}
  for b in ['X','Z']:
   path=next((root/'inputs/bolza').glob(f'*_l=1_*basis={b}*noise_model=SDEM3*'));c=with_duration(stim.Circuit(path.read_text()),48)
   regs[b]=[c.detecting_regions(targets=['L'],ticks=[tick])[stim.target_logical_observable_id(i)][tick] for i in range(4)]
  mat=np.array([[not x.commutes(z) for z in regs['Z']] for x in regs['X']],dtype=np.uint8);a=inverse(mat).T
  new=[]
  for row in a:
   z=stim.PauliString(16)
   for bit,old in zip(row,regs['Z']):
    if bit:z*=old
   new.append(z)
  assert all((not x.commutes(z))==(i==j) for i,x in enumerate(regs['X']) for j,z in enumerate(new))
  result.append(dict(tick=tick,cross_matrix=mat.tolist(),Z_transformation=a.tolist(),supplied_X=list(map(str,regs['X'])),supplied_Z=list(map(str,regs['Z'])),canonical_Z=list(map(str,new))))
 out=dict(checks=result,published_mapping_status='unresolved: no figure-to-circuit vertex correspondence recovered; canonical pairing is not the published representative mapping',boundary_scope='matching bulk phases at ticks 7 and 43; not an independent reconstruction of initial/final published readout paths')
 (Path(__file__).parent/'basis_mapping.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':main()
