from pathlib import Path
import json
from generate_normal_forms import mats
from research import unit_reduce
P=Path(__file__).resolve().parent
joint=json.loads((P/'joint-star.json').read_text());J=joint['matrix']
records=[]
for name,A in [('NFDualRaw1',J[3:]),('NFJointRaw1',J)]:
 cert=unit_reduce(A,30);r=cert['rank'];m=len(A);l=m-r;k=30-r
 U,Ui,V,Vi=mats(m,30,cert['operations'])
 s=['import NormalFormCount','set_option maxRecDepth 1000000','set_option maxHeartbeats 0',f'namespace {name}',
      'def ix {r k : ℕ} : Fin r ⊕ Fin k → ℕ := Sum.elim Fin.val (fun j => r+j.val)',
      'def data (a : List (List ℤ)) {r l k : ℕ} : Matrix (Fin r ⊕ Fin l) (Fin r ⊕ Fin k) ℤ :=',
      '  fun i j => (a[ix i]?.getD [])[ix j]?.getD 0']
 for label,arr,lr,kr in [('A',A,l,k),('U',U,l,l),('Ui',Ui,l,l),('V',V,k,k),('Vi',Vi,k,k)]:
  s += [f'def {label} : Matrix (Fin {r} ⊕ Fin {lr}) (Fin {r} ⊕ Fin {kr}) ℤ :=','  data '+str(arr).replace(' ','')]
 s+=['theorem inverseU : Ui*U=1 := by decide','theorem inverseV : V*Vi=1 := by decide',
       'theorem inverseVi : Vi*V=1 := by decide',
       f'theorem normal : U*A*V=NormalFormCount.diagonal {r} {l} {k} := by decide',
       f'theorem count (N : ℕ) [NeZero N] : Nat.card (IntegerKernel.Kernel (A.map (Int.castRingHom (ZMod N))))=N^{k} :=',
       f'  NormalFormCount.count_integer N {r} {l} {k} A U Ui V Vi inverseU inverseV inverseVi normal',
       '#print axioms normal','#print axioms count',f'end {name}']
 (P/(name+'.lean')).write_text('\n'.join(s)+'\n')
 records.append(dict(module=name,rank=r,rows=m,cols=30))
s=['import CycleData','import SparseCSSMatrices','import StarVoltageData','import Mathlib.Tactic.NormNum','import Mathlib.Tactic.Ring','namespace JointCycleData','open scoped BigOperators',
 'def rows : Fin 2 → Fin 3 → Fin 30 → ℤ :=', '  CycleData.get3 '+str([J[:3],J[3:]]).replace(' ',''),
 'def dualH := SparseCSSMatrices.dual PaschCubicTrade.baseA',
 'def variableAt (i : Fin 4) : Fin 10 := ⟨i.val+6,by omega⟩',
 'def checks : Fin 6 → Fin 10 := fun e => match e.val with']
base=joint['dual_base'];ss=joint['dual_supports'][0]
assert ss==[6,7,8,9]
cc=[next(iter(set(base[u])&set(base[v]))) for u,v in [(6,7),(6,8),(6,9),(7,8),(7,9),(8,9)]]
for i,c in enumerate(cc):s+=[f' | {i} => {c}']
s+=[' | _ => 0','variable {R : Type*} [CommRing R]',
 'def d (z : Fin 30 → R) := PaschLiftCriterion.differences',
 '  (fun i c => -StarVoltageData.labelsRaw z c (variableAt i)) checks',
 'def residual (z : Fin 30 → R) (j : Fin 3) : R := match j.val with',
 ' | 0 => d z 0+d z 3-d z 1',' | 1 => d z 0+d z 4-d z 2',' | _ => d z 1+d z 5-d z 2',
 'theorem dual_rows (z : Fin 30 → R) (j : Fin 3) :',
 ' (∑ k, (rows 1 j k : R)*z k)=residual z j := by',
 ' fin_cases j <;> norm_num [rows,CycleData.get3,residual,d,PaschLiftCriterion.differences,',
 '   variableAt,checks,StarVoltageData.labelsRaw,Fin.sum_univ_succ] <;> ring',
 'theorem dual_balanced (z : Fin 30 → R) : PaschVoltage.Balanced (d z) ↔',
 ' ∀ j : Fin 3, ∑ k, (rows 1 j k : R)*z k=0 := by',
 ' simp_rw [dual_rows]',' constructor',
 ' · rintro ⟨a,b,c⟩ j; fin_cases j <;> simp only [residual]',
 '   · exact sub_eq_zero.mpr a','   · exact sub_eq_zero.mpr b','   · exact sub_eq_zero.mpr c',
 ' · intro h; exact ⟨sub_eq_zero.mp (h 0),sub_eq_zero.mp (h 1),sub_eq_zero.mp (h 2)⟩',
 '#print axioms dual_rows','#print axioms dual_balanced','end JointCycleData']
(P/'JointCycleData.lean').write_text('\n'.join(s)+'\n')
(P/'joint-normal-form-index.json').write_text(json.dumps(records,indent=2)+'\n')
