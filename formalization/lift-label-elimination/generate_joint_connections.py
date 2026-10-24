from pathlib import Path
P=Path(__file__).resolve().parent
for nf,conn,r,k,offset,chosen in [('NFStarRaw1','ConnectJointFirst',3,27,0,'{0}'),('NFDualRaw1','ConnectJointDual',3,27,1,'{1}'),('NFJointRaw1','ConnectJointBoth',6,24,0,'{0,1}')]:
 s=[f'import {nf}','import JointCycleData','import CycleKernelBridge','set_option maxHeartbeats 0','set_option maxRecDepth 1000000',f'namespace {conn}',f'open {nf}',f'def chosen : Finset (Fin 2) := {chosen}',
 f'def columns : (Fin {r} ⊕ Fin {k}) ≃ Fin 30 := finSumFinEquiv',
 f'def rowAt : (Fin {r} ⊕ Fin 0) → Fin 2 × Fin 3 := fun m =>',
 f' (⟨ix m / 3+{offset},by cases m with',
 '   | inl i => fin_cases i <;> decide','   | inr i => exact Fin.elim0 i',
 ' ⟩,⟨ix m % 3,Nat.mod_lt _ (by decide)⟩)',
 'theorem rows_match : ∀ m k, A m (columns.symm k)=JointCycleData.rows (rowAt m).1 (rowAt m).2 k := by decide',
 'theorem rows_complete : ∀ i j, i∈chosen ↔ ∃ m, rowAt m=(i,j) := by decide',
 'theorem actual_count (N : ℕ) [NeZero N] :',
 f' Nat.card {{z : Fin 30 → ZMod N // CycleKernelBridge.Events JointCycleData.rows chosen z}}=N^{k} := by',
 ' have e1 := CycleKernelBridge.eventsEquiv (R := ZMod N) JointCycleData.rows chosen',
 '   (A.submatrix id columns.symm) rowAt rows_match rows_complete',
 ' have e2 := CycleKernelBridge.columnEquiv (A.map (Int.castRingHom (ZMod N))) columns.symm',
 f' exact (Nat.card_congr (e1.trans e2)).trans ({nf}.count N)',
 '#print axioms actual_count',f'end {conn}']
 (P/(conn+'.lean')).write_text('\n'.join(s)+'\n')
