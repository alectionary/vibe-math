"""Emit explicit integer matrices; Lean checks every inverse and normal-form identity."""
import json
from pathlib import Path
P=Path(__file__).resolve().parent

def eye(n):return [[int(i==j) for j in range(n)] for i in range(n)]
def apply(a,op):
 t=op[0];i=op[1]
 if t=='rs':a[i],a[op[2]]=a[op[2]],a[i]
 elif t=='cs':
  for row in a:row[i],row[op[2]]=row[op[2]],row[i]
 elif t=='rn':a[i]=[-x for x in a[i]]
 elif t=='ra':
  j,q=op[2:];a[i]=[x+q*y for x,y in zip(a[i],a[j])]
 elif t=='ca':
  j,q=op[2:]
  for row in a:row[i]+=q*row[j]
 else:raise ValueError(op)
def inv(op):return op[:3]+[-op[3]] if op[0] in ('ra','ca') else op[:]
def mats(m,n,ops):
 U=eye(m);Ui=eye(m);V=eye(n);Vi=eye(n)
 for op in ops:apply(U if op[0].startswith('r') else V,op)
 for op in reversed(ops):apply(Ui if op[0].startswith('r') else Vi,inv(op))
 return U,Ui,V,Vi
# Emit one module per base/mask so the kernel work is independently bounded.
def main():
 records=[]
 for base in json.loads((P/'results.json').read_text())['bases']:
  for c in base['intersection_certificates']:
   for scope,n,A,cert in [('Raw',30,c['matrix'],c['full_certificate']),('Gauge',11,c['gauge_matrix'],c['gauge_certificate'])]:
    r=cert['rank'];m=len(A);l=m-r;k=n-r
    name='NF'+base['name'].title()+scope+str(c['mask'])
    U,Ui,V,Vi=mats(m,n,cert['operations'])
    s=['import NormalFormCount','set_option maxRecDepth 1000000','set_option maxHeartbeats 0',f'namespace {name}',
       'def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)',
       'def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=',
       '  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0']
    for label,arr,lr,kr in [('A',A,l,k),('U',U,l,l),('Ui',Ui,l,l),('V',V,k,k),('Vi',Vi,k,k)]:
     s += [f'def {label} : Matrix (Fin {r} ⊕ Fin {lr}) (Fin {r} ⊕ Fin {kr}) ℤ :=',
           '  data '+str(arr).replace(' ','')]
    s+=['theorem inverseU : Ui*U=1 := by decide','theorem inverseV : V*Vi=1 := by decide',
        'theorem inverseVi : Vi*V=1 := by decide',
        f'theorem normal : U*A*V=NormalFormCount.diagonal {r} {l} {k} := by decide',
        f'theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^{k} :=',
        f'  NormalFormCount.count_integer N {r} {l} {k} A U Ui V Vi inverseU inverseV inverseVi normal',
        '#print axioms normal','#print axioms count',f'end {name}']
    (P/(name+'.lean')).write_text('\n'.join(s)+'\n')
    records.append(dict(module=name,base=base['name'],scope=scope,mask=c['mask'],rank=r,rows=m,cols=n))
 (P/'normal-form-index.json').write_text(json.dumps(records,indent=2)+'\n')

if __name__=='__main__':main()
