"""Solver-free controls and exact local dimension count for variable shared law."""
from pathlib import Path
from fractions import Fraction as Q
from collections import Counter
from flint import fmpz_mat
import argparse,hashlib,json,time
from two_basis_structure import lambda_affine,lambda_values,generator,LOW,HIGH
from two_basis_structure_direct_allocation import status_table
from verify_two_sided_full_basis_oracle import physical_source,domains,target
ROOT=Path(__file__).resolve().parent
H=[m for m in range(16) if m.bit_count()>=2]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def recover(b,high):
 y={m:Q(high[m]) for m in H}
 for i in range(4):y[1<<i]=b[i+1]-sum(y[m] for m in H if m>>i&1)
 y[0]=b[0]-sum(b[1:])+sum((m.bit_count()-1)*y[m] for m in H)
 return [y[m] for m in range(16)]
def controls():
 checked=0
 for seed in range(128):
  masses=[Q(((m+1)*(seed+3)%17)+1) for m in range(16)];mass=sum(masses);lam=[v/mass for v in masses];mom=[sum(lam[m] for m in range(16) if m&s==s) for s in LOW+HIGH];assert lambda_values(mom[:11],mom[11:])==lam
  for j in range(8):
   # Arbitrary structural forbidden/free/forced statuses; explicit feasible law.
   status=[((seed*13+m*7+j*5)%3)-1 for m in range(16)];y=[Q(0) if s<0 else l if s>0 else l*Q(((m+j+seed)%5),4) for m,(s,l) in enumerate(zip(status,lam))];b=[sum(y)]+[sum(y[m] for m in range(16) if m>>i&1) for i in range(4)];assert recover(b,dict(enumerate(y)))==y;checked+=1
 # A fixed-law tight face is not uniformly tight: y=P0*P1 has a high-mass
 # term under a variable law, even though that coordinate vanishes on a face.
 high={m:Q(0) for m in H};high[15]=Q(1);assert recover([Q(1)]*5,high)==[Q(int(m==15)) for m in range(16)]
 return dict(exact_local_reconstructions=checked,mobius_laws_checked=128,nonzero_quad_mass_boundary=True)
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();xx,zz=[80,512],[186,433];X,Z,_=physical_source();full=target(a.point,xx,zz);base,C=lambda_affine(full[:11]);result=[];allconstraints=[]
 for side in 'XZ':
  dd=[d[side] for d in domains(X,Z,xx,zz)];assert all(d['feasible'] for d in dd);status=status_table(dd);off=720*int(side=='Z');b=full[11+off:731+off]+[full[1451+1440*i+off+j] for i in range(4) for j in range(720)];groups=Counter(tuple(s) for s in status);classes=[];constraints=[];count=0
  for ss,n in groups.items():
   F=[m for m,z in enumerate(ss) if z==0];G=[generator(m) for m in F];r=int(fmpz_mat(G).rank()) if G else 0;count+=n*(len(F)-r);classes.append(dict(status=list(ss),vectors=n,free_pattern_coordinates=len(F),moment_rank=r,remaining_local_variables=len(F)-r));N,k=fmpz_mat(G).nullspace() if G else (fmpz_mat([[int(i==j) for j in range(5)] for i in range(5)]),5)
   for col in range(k):
    v=[int(N[i,col]) for i in range(5)];h=[sum(x*y for x,y in zip(v,generator(m))) if ss[m]==1 else 0 for m in range(16)];rhs=sum(h[m]*base[m] for m in range(16));coeff=[sum(h[m]*C[m][q] for m in range(16)) for q in range(5)]
    for j,s in enumerate(status):
     if tuple(s)==ss:
      const=sum(v[i]*b[720*i+j] for i in range(5))-rhs;assert const==0
    if any(coeff):constraints.append(coeff)
  allconstraints.extend(constraints);result.append(dict(side=side,local_variables=count,classes=classes,global_tau_consistency_rows=constraints,all_pattern_bucket_rows=sum(1+len(d['bins']) for d in dd)))
 out=dict(status='PASS_EXACT_GENERAL_SHARED_LAW_ELIMINATION_CONTROLS',producer_sha256=sha(__file__),point_sha256=sha(a.point),X_anchors=xx,Z_anchors=zz,controls=controls(),sectors=result,shared_high_moment_variables=5,total_reduced_variables=5+sum(r['local_variables'] for r in result),global_tau_equality_rank=int(fmpz_mat(allconstraints).rank()) if allconstraints else 0,source_hashes={p:sha(ROOT/p) for p in ['two_basis_structure.py','two_basis_structure_direct_allocation.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},lp_run=False,feasibility_claim=False,source_C16_answered=False,elapsed_seconds=time.monotonic()-start);a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['source_hashes','sectors']},flush=True)
if __name__=='__main__':main()
