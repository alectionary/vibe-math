import FamilyPauliDistance
import SparseRowDegrees
import CoverCounting

set_option maxHeartbeats 0
namespace FamilyTheorem
open Matrix FamilyRank FamilyGraphs CyclicRecurrence
variable (q : ℕ) [NeZero q]

theorem rowX (hq : 2≤q) (a : Fin 10 × ZMod (7*q)) :
    SparseRowDegrees.rowWeight (X q) a=6 :=
  SparseRowDegrees.x_row_minus (7*q) (by omega) PaschCubicTrade.baseA (labels q)
    FamilyGraphs.dual_cubic a

theorem rowZ (hq : 2≤q) (a : Fin 10 × ZMod (7*q)) :
    SparseRowDegrees.rowWeight (Z q) a=6 :=
  SparseRowDegrees.z_row_minus (7*q) (by omega) PaschCubicTrade.baseA (labels q)
    PaschCubicTrade.cubic_A a

theorem zero_count {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]
    (H : V → Finset C)
    (hn : ∀ f : Fin 4 → V, Function.Injective f →
      ¬PaschClassification.EvenChecks (fun i => H (f i))) : PaschKernelCount.count40 H=0 := by
  classical
  rw [CoverCounting.subtype_count,Nat.card_eq_fintype_card]
  apply Fintype.card_eq_zero_iff.mpr
  refine ⟨fun S => ?_⟩
  let f : Fin 4 → V := fun i => (GlobalCounting.label S.val i).val
  have hf : Function.Injective f := by
    intro i j hij
    exact (GlobalCounting.label S.val).injective (Subtype.ext hij)
  exact hn f hf ((PaschKernelCount.local_elementary40_iff H S.val).mp S.prop).2

theorem countX (hq : 2≤q) : PaschKernelCount.count40 (graphX q)=0 :=
  zero_count _ (no_fourX q hq)

theorem countZ (hq : 2≤q) : PaschKernelCount.count40 (graphZ q)=0 :=
  zero_count _ (no_fourZ q hq)

/-- The literal matrices give a binary CSS [[140*q,18,6]] family for every q≥2.
Regularity and the absence of both Tanner four-cycles and four-column even
supports are assertions about their explicit incidence graphs. -/
theorem family (hq : 2≤q) :
    X q*(Z q).transpose=0 ∧
    Fintype.card (Qubits q)=140*q ∧
    Fintype.card (Qubits q)-(X q).rank-(Z q).rank=18 ∧
    ((∀ x z : Qubits q → F, FamilyPauliDistance.Logical q x z →
      6≤FamilyPauliDistance.pauliWeight q x z) ∧
      (FamilyPauliDistance.Logical q 0 (FamilyLogical.word q) ∧
       FamilyPauliDistance.pauliWeight q 0 (FamilyLogical.word q)=6)) ∧
    (∀ w, (graphX q w).card=3 ∧ (graphZ q w).card=3) ∧
    (∀ a, SparseRowDegrees.rowWeight (X q) a=6 ∧ SparseRowDegrees.rowWeight (Z q) a=6) ∧
    (∀ v w, v≠w → (graphX q v ∩ graphX q w).card≤1 ∧
      (graphZ q v ∩ graphZ q w).card≤1) ∧
    (∀ f : Fin 4 → Qubits q, Function.Injective f →
      ¬PaschClassification.EvenChecks (fun i => graphX q (f i)) ∧
      ¬PaschClassification.EvenChecks (fun i => graphZ q (f i))) := by
  exact ⟨FamilyRank.css q,FamilyRank.length q,FamilyRank.dimension q,
    FamilyPauliDistance.distance_six q hq,
    fun w => ⟨cubicX q hq w,cubicZ q hq w⟩,
    fun a => ⟨rowX q hq a,rowZ q hq a⟩,
    fun v w h => ⟨linearX q hq v w h,linearZ q hq v w h⟩,
    fun f h => ⟨no_fourX q hq f h,no_fourZ q hq f h⟩⟩

#print axioms rowX
#print axioms rowZ
#print axioms countX
#print axioms countZ
#print axioms family
end FamilyTheorem
