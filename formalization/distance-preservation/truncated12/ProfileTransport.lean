import GroupTransport
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

/-- Exactly the strengthened normalized source tests and both actual classical
lower-bound predicates used in the bounded follow-up. -/
structure DistanceCriterion (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) : Prop where
  no_four : NoFour (CEdge e)
  no_six : NoSix (CEdge e)
  row_zero : ∀ j,e 0 j=0
  column_zero : ∀ i,e i 0=0
  no_column_partition : NoColumnPartition e
  no_triple_row : NoTripleRow e
  classical_bound : ClassicalAtLeast e D
  transpose_bound : TransposeAtLeast e D

def normPermE (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3))
    (c : Equiv.Perm (Fin 4)) := normalizeAt (permE e r c) 0 0

def normPermU (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) :=
  gaugeU (permU u c) (normalColumnShift (permE e r c))

def normPermV (e : Fin 3 → Fin 4 → ZMod L) (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :=
  gaugeV (permV v r) (normalRowShift (permE e r c))

theorem normPerm_criterion (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ)
    (h : DistanceCriterion e D) (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) :
    DistanceCriterion (normPermE e r c) D := by
  have ht := renormalized_entry_tests e h.row_zero h.no_column_partition h.no_triple_row r c
  exact {
    no_four := normalization_no_four _ 0 0 (perm_no_four e r c h.no_four)
    no_six := normalization_no_six _ 0 0 (perm_no_six e r c h.no_six)
    row_zero := fun j => normalizeAt_row _ 0 0 j
    column_zero := fun i => normalizeAt_column _ 0 0 i
    no_column_partition := ht.1
    no_triple_row := ht.2
    classical_bound := normalization_classical_bound _ 0 0 D (permutation_classical_bound e r c D h.classical_bound)
    transpose_bound := normalization_transpose_bound _ 0 0 D (permutation_transpose_bound e r c D h.transpose_bound)
  }

theorem normPerm_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ a,(∑ q,GeneralLP.HZ e a q*GeneralLP.join u v q)=0) :
    ∀ a,(∑ q,GeneralLP.HZ (normPermE e r c) a q*
      GeneralLP.join (normPermU e r c u) (normPermV e r c v) q)=0 := by
  unfold normPermE normPermU normPermV
  rw [normalize_is_gauge]
  exact gauge_source_kernel _ _ _ _ _ (perm_source_kernel e r c u v hk)

theorem normPerm_span (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.InSpanX (normPermE e r c) (normPermU e r c u) (normPermV e r c v) ↔
      GeneralLP.InSpanX e u v := by
  unfold normPermE normPermU normPermV
  rw [normalize_is_gauge,full_span_gauge_iff]
  exact perm_source_span_iff e r c u v

theorem normPerm_weight (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    (CoverWeight.support (GeneralLP.join (normPermU e r c u) (normPermV e r c v))).card=
      (CoverWeight.support (GeneralLP.join u v)).card := by
  unfold normPermU normPermV
  rw [gauge_weight,perm_source_weight]

theorem normPerm_left_count (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) :
    leftCount (normPermU e r c u) j=leftCount u (c j) := by
  unfold normPermU
  rw [gauge_left_count,perm_left_count]

theorem normPerm_right_count (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4))
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) :
    rightCount (normPermV e r c v) i=rightCount v (r i) := by
  unfold normPermV
  rw [gauge_right_count,perm_right_count]

#print axioms normPerm_criterion
#print axioms normPerm_kernel
#print axioms normPerm_span
#print axioms normPerm_weight
end TruncatedDistance
