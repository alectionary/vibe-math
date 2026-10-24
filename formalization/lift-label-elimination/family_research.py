"""Finite certificates used in the written all-q CSS-family proof."""
from pathlib import Path
import json,sys
from research import edges,pasches,cycle_rows,BASES
from quantum_witness import rank,matrices,transpose,count,basis_rows,reduce_word
P=Path(__file__).resolve().parent
def main():
 B=[{(t-e)%7 for e in [0,1,3]} for t in range(7)];es=edges(B)
 z=[next((r-e)//7 for e in [0,1,3] if (r-e)%7==c) for r,c in es]
 residuals=[{'support':s,'cycle_residuals':[sum(a*b for a,b in zip(r,z)) for r in cycle_rows(B,s)]} for s in pasches(B)]
 assert len(residuals)==7 and all(any(abs(x)==1 for x in r['cycle_residuals']) for r in residuals)
 base=BASES['star'];Hrows=transpose(base,10);assert rank(Hrows)==7
 vs=[2,3,5,6,7,8];assert all(sum(c in base[v] for v in vs)%2==0 for c in range(10));assert not {0,4}&set(vs)
 records=[]
 for q in [2,3,4]:
  N=7*q;zz=[7 if (v,c) in [(0,0),(4,6)] else 0 for v,c in edges(base)];X,Z=matrices(base,zz,N);rx,rz=transpose(X,10*N),transpose(Z,10*N)
  cx,cz=count(X),count(Z);ranks=[rank(rx),rank(rz)];assert cx==cz==0 and ranks==[10*N-9]*2
  support=[v*N for v in vs];word=sum(1<<v for v in support)
  assert all((r&word).bit_count()%2==0 for r in rx) and reduce_word(word,basis_rows(rz))
  records.append(dict(q=q,N=N,n=20*N,rank_X=ranks[0],rank_Z=ranks[1],k=18,N40_X=cx,N40_Z=cz,logical_support=support))
 out=dict(evidence='written_general_family_proof_with_exact_finite_ingredients_and_three_consumers',claim='For every integer q>=2, the specified star-base labels7 at (0,0),(4,6), N=7q, b=1+x+x^3, give a CSS [[140q,18,6]] model with no elementary (4,0) supports in either Tanner graph.',B7_base=[sorted(s) for s in B],carry_edges=es,integer_carry_labels=z,B7_Pasch_cycle_residuals=residuals,base_binary_rank=7,base_weight_six_dependency=vs,consumers=records)
 (P/'family-results.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)
if __name__=='__main__':main()
