import MatchingRows
import TargetObstructions
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- An actual source realization of the decoder's complete matching pattern.
Constructing this witness from every small support is a separate coverage step. -/
structure PatternRealization (e : Fin 3 → Fin 4 → ZMod L) (w p : ℕ) where
  qubits : Fin w → Qubit L
  checks : (r : Fin 18) → r.val<edgeCount w → SourceModel.ZCheck L
  left_bound : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,(edge w p r.val).a<w
  right_bound : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,(edge w p r.val).b<w
  labels : ∀ v : Fin w,VertexLabel (vertex w p v.val) (qubits v)
  check_column : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,(edge w p r.val).j=(checks r hr).1.1.val
  check_row : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,(edge w p r.val).i=(checks r hr).1.2.val
  left_edge : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,
    ZEdge e (qubits ⟨(edge w p r.val).a,left_bound r hr⟩) (checks r hr)
  right_edge : ∀ r : Fin 18,∀ hr : r.val<edgeCount w,
    ZEdge e (qubits ⟨(edge w p r.val).b,right_bound r hr⟩) (checks r hr)

def realizationVector (e : Fin 3 → Fin 4 → ZMod L) (w : ℕ) (q : Fin w → Qubit L)
    (j : Fin (w+6)) : ZMod L :=
  if h : j.val<6 then sourceExponents e ⟨j.val,h⟩ else
    qubitFiber (q ⟨j.val-6,by have := j.isLt;omega⟩)

theorem realization_prefix (e : Fin 3 → Fin 4 → ZMod L) (w : ℕ) (q : Fin w → Qubit L) :
    prefixSix (realizationVector e w q)=sourceExponents e := by
  funext k
  simp [prefixSix,realizationVector,k.isLt]

theorem realization_fiber (e : Fin 3 → Fin 4 → ZMod L) (w : ℕ) (q : Fin w → Qubit L) (v : Fin w) :
    realizationVector e w q (fiberIndex v)=qubitFiber (q v) := by
  have hn : ¬6+v.val<6 := by omega
  simp [realizationVector,fiberIndex,hn]

theorem realization_rows_zero (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0) (w p : ℕ)
    (h : PatternRealization e w p) :
    ∀ r : Fin 18,integerDot (sourceRow w p r) (realizationVector e w h.qubits)=0 := by
  intro r
  by_cases hr : r.val<edgeCount w
  · exact actual_matching_row_zero e hR0 hC0 w p r hr (h.left_bound r hr) (h.right_bound r hr)
      _ _ (h.checks r hr) (h.check_column r hr) (h.check_row r hr)
      (h.labels _) (h.labels _) (h.left_edge r hr) (h.right_edge r hr)
      _ (realization_prefix e w h.qubits) (realization_fiber e w h.qubits _) (realization_fiber e w h.qubits _)
  · simp [sourceRow,hr,integerDot]

/-- Every certified pattern is excluded in the actual source incidence model,
with the additional classical-distance comparison exactly for the six
weight-ten torsion alternatives. This is conditional on pattern realization;
it does not assert that all small logical supports have been encoded. -/
theorem certified_pattern_has_no_source_realization
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D) (w p : ℕ) (c : Certificate)
    (hc : checkCertificateFast w p c=true)
    (hExtra : needsClassicalBound c.kind → 10<D) : ¬Nonempty (PatternRealization e w p) := by
  rintro ⟨h⟩
  have hkind : c.kind<64 := of_decide_eq_true
    ((Bool.and_eq_true_iff.mp ((Bool.and_eq_true_iff.mp hc).1)).2)
  have hz := checked_fast_equations w p c hc (realizationVector e w h.qubits)
    (realization_rows_zero e hR0 hC0 w p h)
  apply source_target_obstruction e h4 h6 hR0 hC0 hCP hP D hC ⟨c.kind,hkind⟩ hExtra
  intro t
  have ht := hz t
  change integerDot (extendSix w (targetVector c.kind t.val)) (realizationVector e w h.qubits)=0 at ht
  rw [dot_extendSix,realization_prefix] at ht
  simpa only [targetForm,sourceVars,sourceExponents] using ht

#print axioms realization_rows_zero
#print axioms certified_pattern_has_no_source_realization
end TruncatedDistance
