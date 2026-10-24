import HistogramPolynomials
import StarCertificates
import TriangleRawCertificates0
import TriangleGaugeCertificates0
import TriangleRawCertificates1
import TriangleGaugeCertificates1
import TriangleRawCertificates2
import TriangleGaugeCertificates2
import TriangleRawCertificates3
import TriangleGaugeCertificates3
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace LabelHistograms
open scoped BigOperators
open CycleKernelBridge EventHistogram HistogramPolynomials CycleData
instance {p n N : ℕ} [NeZero N] (B : Fin p → Fin 3 → Fin n → ℤ)
    (S : Finset (Fin p)) (z : Fin n → ZMod N) : Decidable (Events B S z) :=
  inferInstanceAs (Decidable (∀ i∈S, ∀ j : Fin 3, ∑ k, (B i j k : ZMod N)*z k=0))

def eventsGauge (N : ℕ) [NeZero N] (z : Fin 11 → ZMod N) (i : Fin 5) : Bool :=
  decide (∀ j : Fin 3, ∑ k, (triangleGauge i j k : ZMod N)*z k=0)
theorem allGauge (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :
    Nat.card {z : Fin 11 → ZMod N // Events triangleGauge S z}=N^(11-rankOf S.card) := by
  have hlist : (Finset.univ : Finset (Finset (Fin 5)))={∅,{0},{1},{0,1},{2},{0,2},{1,2},{0,1,2},{3},{0,3},{1,3},{0,1,3},{2,3},{0,2,3},{1,2,3},{0,1,2,3},{4},{0,4},{1,4},{0,1,4},{2,4},{0,2,4},{1,2,4},{0,1,2,4},{3,4},{0,3,4},{1,3,4},{0,1,3,4},{2,3,4},{0,2,3,4},{1,2,3,4},{0,1,2,3,4}} := by decide
  have h := Finset.mem_univ S
  rw [hlist] at h
  simp only [Finset.mem_insert,Finset.mem_singleton] at h
  rcases h with h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h
  all_goals subst S
  · exact ConnectTriangleGauge0.actual_count N
  · exact ConnectTriangleGauge1.actual_count N
  · exact ConnectTriangleGauge2.actual_count N
  · exact ConnectTriangleGauge3.actual_count N
  · exact ConnectTriangleGauge4.actual_count N
  · exact ConnectTriangleGauge5.actual_count N
  · exact ConnectTriangleGauge6.actual_count N
  · exact ConnectTriangleGauge7.actual_count N
  · exact ConnectTriangleGauge8.actual_count N
  · exact ConnectTriangleGauge9.actual_count N
  · exact ConnectTriangleGauge10.actual_count N
  · exact ConnectTriangleGauge11.actual_count N
  · exact ConnectTriangleGauge12.actual_count N
  · exact ConnectTriangleGauge13.actual_count N
  · exact ConnectTriangleGauge14.actual_count N
  · exact ConnectTriangleGauge15.actual_count N
  · exact ConnectTriangleGauge16.actual_count N
  · exact ConnectTriangleGauge17.actual_count N
  · exact ConnectTriangleGauge18.actual_count N
  · exact ConnectTriangleGauge19.actual_count N
  · exact ConnectTriangleGauge20.actual_count N
  · exact ConnectTriangleGauge21.actual_count N
  · exact ConnectTriangleGauge22.actual_count N
  · exact ConnectTriangleGauge23.actual_count N
  · exact ConnectTriangleGauge24.actual_count N
  · exact ConnectTriangleGauge25.actual_count N
  · exact ConnectTriangleGauge26.actual_count N
  · exact ConnectTriangleGauge27.actual_count N
  · exact ConnectTriangleGauge28.actual_count N
  · exact ConnectTriangleGauge29.actual_count N
  · exact ConnectTriangleGauge30.actual_count N
  · exact ConnectTriangleGauge31.actual_count N
theorem intersectionsGauge (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :
    intersectionCount (eventsGauge N) S=N^(11-rankOf S.card) := by
  have h := allGauge N S
  rw [Nat.card_eq_fintype_card] at h
  rw [Fintype.card_subtype] at h
  rw [← h]
  unfold intersectionCount
  apply congrArg Finset.card
  apply Finset.filter_congr
  intro z _
  simp only [eventsGauge,Events,decide_eq_true_eq]
def eventsRaw (N : ℕ) [NeZero N] (z : Fin 30 → ZMod N) (i : Fin 5) : Bool :=
  decide (∀ j : Fin 3, ∑ k, (triangleRaw i j k : ZMod N)*z k=0)
theorem allRaw (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :
    Nat.card {z : Fin 30 → ZMod N // Events triangleRaw S z}=N^(30-rankOf S.card) := by
  have hlist : (Finset.univ : Finset (Finset (Fin 5)))={∅,{0},{1},{0,1},{2},{0,2},{1,2},{0,1,2},{3},{0,3},{1,3},{0,1,3},{2,3},{0,2,3},{1,2,3},{0,1,2,3},{4},{0,4},{1,4},{0,1,4},{2,4},{0,2,4},{1,2,4},{0,1,2,4},{3,4},{0,3,4},{1,3,4},{0,1,3,4},{2,3,4},{0,2,3,4},{1,2,3,4},{0,1,2,3,4}} := by decide
  have h := Finset.mem_univ S
  rw [hlist] at h
  simp only [Finset.mem_insert,Finset.mem_singleton] at h
  rcases h with h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h | h
  all_goals subst S
  · exact ConnectTriangleRaw0.actual_count N
  · exact ConnectTriangleRaw1.actual_count N
  · exact ConnectTriangleRaw2.actual_count N
  · exact ConnectTriangleRaw3.actual_count N
  · exact ConnectTriangleRaw4.actual_count N
  · exact ConnectTriangleRaw5.actual_count N
  · exact ConnectTriangleRaw6.actual_count N
  · exact ConnectTriangleRaw7.actual_count N
  · exact ConnectTriangleRaw8.actual_count N
  · exact ConnectTriangleRaw9.actual_count N
  · exact ConnectTriangleRaw10.actual_count N
  · exact ConnectTriangleRaw11.actual_count N
  · exact ConnectTriangleRaw12.actual_count N
  · exact ConnectTriangleRaw13.actual_count N
  · exact ConnectTriangleRaw14.actual_count N
  · exact ConnectTriangleRaw15.actual_count N
  · exact ConnectTriangleRaw16.actual_count N
  · exact ConnectTriangleRaw17.actual_count N
  · exact ConnectTriangleRaw18.actual_count N
  · exact ConnectTriangleRaw19.actual_count N
  · exact ConnectTriangleRaw20.actual_count N
  · exact ConnectTriangleRaw21.actual_count N
  · exact ConnectTriangleRaw22.actual_count N
  · exact ConnectTriangleRaw23.actual_count N
  · exact ConnectTriangleRaw24.actual_count N
  · exact ConnectTriangleRaw25.actual_count N
  · exact ConnectTriangleRaw26.actual_count N
  · exact ConnectTriangleRaw27.actual_count N
  · exact ConnectTriangleRaw28.actual_count N
  · exact ConnectTriangleRaw29.actual_count N
  · exact ConnectTriangleRaw30.actual_count N
  · exact ConnectTriangleRaw31.actual_count N
theorem intersectionsRaw (N : ℕ) [NeZero N] (S : Finset (Fin 5)) :
    intersectionCount (eventsRaw N) S=N^(30-rankOf S.card) := by
  have h := allRaw N S
  rw [Nat.card_eq_fintype_card] at h
  rw [Fintype.card_subtype] at h
  rw [← h]
  unfold intersectionCount
  apply congrArg Finset.card
  apply Finset.filter_congr
  intro z _
  simp only [eventsRaw,Events,decide_eq_true_eq]
theorem triangle_gauge_histogram (N : ℕ) [NeZero N] (j : Fin 6) :
    (histogram (eventsGauge N) j : ℤ)=polynomial N j :=
  histogram_formula (eventsGauge N) N (intersectionsGauge N) j
theorem power_factor (N : ℤ) (s : ℕ) : N^(30-rankOf s)=N^19*N^(11-rankOf s) := by
  have h : rankOf s≤11 := Nat.min_le_right _ _
  rw [show 30-rankOf s=19+(11-rankOf s) by omega,pow_add]
theorem triangle_raw_histogram (N : ℕ) [NeZero N] (j : Fin 6) :
    (histogram (eventsRaw N) j : ℤ)=(N : ℤ)^19*polynomial N j := by
  rw [inversion]
  simp_rw [intersectionsRaw N,Nat.cast_pow,power_factor]
  calc
    (∑ S : Finset (Fin 5), coefficient j S*((N : ℤ)^19*(N : ℤ)^(11-rankOf S.card))) =
        (N : ℤ)^19*∑ S : Finset (Fin 5), coefficient j S*(N : ℤ)^(11-rankOf S.card) := by
      rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intro S _; ring
    _=(N : ℤ)^19*polynomial N j := by rw [group_by_card,evaluate]
#print axioms allGauge
#print axioms allRaw
#print axioms triangle_gauge_histogram
#print axioms triangle_raw_histogram
end LabelHistograms
