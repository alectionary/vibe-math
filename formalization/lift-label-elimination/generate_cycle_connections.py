from pathlib import Path
import json
P=Path(__file__).resolve().parent
bases=json.loads((P/'results.json').read_text())['bases']
records=json.loads((P/'normal-form-index.json').read_text())
s=['import CycleKernelBridge','import Mathlib.Tactic.FinCases','import Mathlib.Logic.Equiv.Fin.Basic','set_option maxHeartbeats 0','set_option maxRecDepth 1000000','namespace CycleData',
'def get3 (a : List (List (List ℤ))) {p n : ℕ} (i : Fin p) (j : Fin 3) (k : Fin n) : ℤ :=',
'  (((a[i.val]?.getD [])[j.val]?.getD [])[k.val]?.getD 0)']
for b in bases:
 for scope,n in [('Raw',30),('Gauge',11)]:
  data=b['cycle_rows']
  if n==11:data=[[[row[k] for k in b['chord_edges']]for row in rows]for rows in data]
  s += [f'def {b["name"]}{scope} : Fin {len(data)} → Fin 3 → Fin {n} → ℤ :=',
        '  get3 '+str(data).replace(' ','')]
s+=['end CycleData'];(P/'CycleData.lean').write_text('\n'.join(s)+'\n')
for r in records:
 name=r['module'];b=next(b for b in bases if b['name']==r['base']);p=len(b['base_supports']);mask=r['mask'];selected=[i for i in range(p) if mask>>i&1];rank=r['rank'];l=r['rows']-rank;k=r['cols']-rank;M=f'(Fin {rank} ⊕ Fin {l})';K=f'(Fin {rank} ⊕ Fin {k})';n=r['cols'];rows=b['name']+r['scope'];conn='Connect'+name[2:]
 sm='{'+','.join(str(i)for i in selected)+'}' if selected else '∅'
 s=[f'import {name}','import CycleData','set_option maxHeartbeats 0','set_option maxRecDepth 1000000',f'namespace {conn}',f'open {name} CycleData',
  f'def chosen : Finset (Fin {p}) := {sm}',
  f'def columns : {K} ≃ Fin {n} := finSumFinEquiv',
  f'def rowAt : {M} → Fin {p} × Fin 3 := fun m =>',
  f'  (⟨([{",".join(str(i)for i in selected)}] : List ℕ)[ix m / 3]?.getD 0, by',
  '    cases m with',f'    | inl i => fin_cases i <;> decide' if rank else '    | inl i => exact Fin.elim0 i',
  f'    | inr i => fin_cases i <;> decide' if l else '    | inr i => exact Fin.elim0 i',
  '  ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)',
  f'theorem rows_match : ∀ m k, A m (columns.symm k)={rows} (rowAt m).1 (rowAt m).2 k := by decide',
  'theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide',
  f'theorem actual_count (N : ℕ) [NeZero N] :',
  f'    Nat.card {{z : Fin {n} → ZMod N // CycleKernelBridge.Events {rows} chosen z}}=N^{k} := by',
  f'  have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) {rows} chosen',
  '    (A.submatrix id columns.symm) rowAt rows_match rows_complete',
  '  have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm',
  f'  exact (Nat.card_congr (e1.trans e2)).trans ({name}.count N)',
  '#print axioms actual_count',f'end {conn}']
 (P/(conn+'.lean')).write_text('\n'.join(s)+'\n')
