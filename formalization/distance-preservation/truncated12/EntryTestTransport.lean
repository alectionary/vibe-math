import TargetObstructions
import PermuteSource
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : ℕ} [NeZero L]

theorem normalize_no_column_partition (e : Fin 3 → Fin 4 → ZMod L)
    (z : Fin 3) (hz : ∀ j,e z j=0) (r : Fin 3) (h : Fin 4)
    (hCP : NoColumnPartition e) : NoColumnPartition (normalizeAt e r h) := by
  intro a b c d hab hac had hbc hbd hcd hn
  apply hCP a b c d hab hac had hbc hbd hcd
  intro i
  have hzero : columnForm e z a b c d=0 := by simp [columnForm,hz]
  have hbase := hn z
  have hi := hn i
  rw [normalized_column_form,hzero] at hbase
  rw [normalized_column_form] at hi
  linear_combination hi-hbase

theorem normalize_no_triple_row (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3) (h : Fin 4) (hP : NoTripleRow e) : NoTripleRow (normalizeAt e r h) := by
  intro i j k hij hik hjk a b c hab hac hbc hn
  exact hP i j k hij hik hjk a b c hab hac hbc
    ⟨(normalized_partial_row_equality e r h i j k a b).mp hn.1,
     (normalized_partial_row_equality e r h i j k a c).mp hn.2⟩

theorem permutation_no_column_partition (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (p : Equiv.Perm (Fin 4))
    (hCP : NoColumnPartition e) : NoColumnPartition (permE e r p) := by
  intro a b c d hab hac had hbc hbd hcd hn
  apply hCP (p a) (p b) (p c) (p d)
    (fun h => hab (p.injective h)) (fun h => hac (p.injective h))
    (fun h => had (p.injective h)) (fun h => hbc (p.injective h))
    (fun h => hbd (p.injective h)) (fun h => hcd (p.injective h))
  intro i
  simpa only [columnForm,permE,Equiv.apply_symm_apply] using hn (r.symm i)

theorem permutation_no_triple_row (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (p : Equiv.Perm (Fin 4))
    (hP : NoTripleRow e) : NoTripleRow (permE e r p) := by
  intro i j k hij hik hjk a b c hab hac hbc hn
  exact hP (r i) (r j) (r k)
    (fun h => hij (r.injective h)) (fun h => hik (r.injective h)) (fun h => hjk (r.injective h))
    (p a) (p b) (p c)
    (fun h => hab (p.injective h)) (fun h => hac (p.injective h)) (fun h => hbc (p.injective h)) hn

/-- After arbitrary row/column relabeling, normalize at the new first row and
column. Both exact entry tests survive, using the relocated original zero row. -/
theorem renormalized_entry_tests (e : Fin 3 → Fin 4 → ZMod L)
    (h0 : ∀ j,e 0 j=0) (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (r : Equiv.Perm (Fin 3)) (p : Equiv.Perm (Fin 4)) :
    NoColumnPartition (normalizeAt (permE e r p) 0 0) ∧
      NoTripleRow (normalizeAt (permE e r p) 0 0) := by
  constructor
  · apply normalize_no_column_partition _ (r.symm 0) _ 0 0
      (permutation_no_column_partition e r p hCP)
    intro j
    simp [permE,h0]
  · exact normalize_no_triple_row _ 0 0 (permutation_no_triple_row e r p hP)

#print axioms renormalized_entry_tests
end TruncatedDistance
