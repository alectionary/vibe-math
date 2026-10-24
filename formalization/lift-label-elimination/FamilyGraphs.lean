import FamilyRank
import GraphMatrices
import QCRegularity
import QCSectorElimination
import KernelFourBridge
import StarDuality

set_option maxHeartbeats 0
namespace FamilyGraphs
open Matrix FamilyRank GraphMatrices SparseCSSMatrices
open CyclicRecurrence
variable (q : ℕ) [NeZero q]

def graphX := minusGraph (7*q) PaschCubicTrade.baseA (labels q)
def rawZ := plusGraph (7*q) (dual PaschCubicTrade.baseA) (inverseLabels (labels q))
def graphZ (w : Qubits q) := rawZ q (Sum.swap w)

theorem checkX (hq : 2≤q) : PaschKernelCount.checkMatrix (graphX q)=X q :=
  minus_matrix (7*q) (by omega) _ _

theorem checkZ (hq : 2≤q) : PaschKernelCount.checkMatrix (graphZ q)=Z q := by
  have h : PaschKernelCount.checkMatrix (graphZ q)=
      (PaschKernelCount.checkMatrix (rawZ q)).submatrix id Sum.swap := rfl
  rw [h]
  change (PaschKernelCount.checkMatrix (plusGraph (7*q) (dual PaschCubicTrade.baseA)
    (inverseLabels (labels q)))).submatrix id Sum.swap=Z q
  rw [plus_matrix (7*q) (by omega)]
  exact (z_as_swapped_x (7*q) _ _).symm

theorem dual_cubic : ∀ c, ((dual PaschCubicTrade.baseA) c).card=3 := by decide

theorem dual_linear : ∀ c d : Fin 10, c≠d →
    ((dual PaschCubicTrade.baseA) c ∩ (dual PaschCubicTrade.baseA) d).card≤1 := by decide

theorem seven_nonzero (hq : 2≤q) : (7 : ZMod (7*q))≠0 := by
  intro h
  have hh := ScalarIncidence.cast_small_injective (7*q) 7 0 (by omega) (by omega) (by simpa only [Nat.cast_ofNat,Nat.cast_zero] using h)
  omega

theorem cubicX (hq : 2≤q) (w : Qubits q) : (graphX q w).card=3 :=
  QCRegularity.cubic _ _ _ PaschCubicTrade.cubic_A (ScalarIncidence.cubic (7*q) (by omega)) w

theorem cubicZ (hq : 2≤q) (w : Qubits q) : (graphZ q w).card=3 :=
  QCRegularity.cubic _ _ _ dual_cubic (ScalarTranspose.cubic (7*q) (by omega)) (Sum.swap w)

theorem linearX (hq : 2≤q) (v w : Qubits q) (hvw : v≠w) :
    (graphX q v ∩ graphX q w).card≤1 :=
  QCRegularity.linear _ _ _ PaschCubicTrade.linear_A
    (ScalarIncidence.linear (7*q) (by omega)) v w hvw

theorem linearZ (hq : 2≤q) (v w : Qubits q) (hvw : v≠w) :
    (graphZ q v ∩ graphZ q w).card≤1 :=
  QCRegularity.linear _ _ _ dual_linear (ScalarTranspose.linear (7*q) (by omega))
    (Sum.swap v) (Sum.swap w) (fun h => hvw (by simpa only [Sum.swap_swap] using congrArg Sum.swap h))

theorem no_fourX (hq : 2≤q) (f : Fin 4 → Qubits q) (hf : Function.Injective f) :
    ¬ PaschClassification.EvenChecks (fun i => graphX q (f i)) := by
  apply QCSectorElimination.no_four_dependency PaschCubicTrade.baseA (labels q)
    (ScalarIncidence.columns (7*q)) PaschCubicTrade.linear_A
    (StarElimination.nonzero_eliminates 7 (seven_nonzero q hq))
    (ScalarIncidence.no_four_dependency q hq) f hf
    (fun i => cubicX q hq (f i)) (fun i j hij => linearX q hq _ _ (fun h => hij (hf h)))

theorem no_fourZ (hq : 2≤q) (f : Fin 4 → Qubits q) (hf : Function.Injective f) :
    ¬ PaschClassification.EvenChecks (fun i => graphZ q (f i)) := by
  have hleft : ∀ g : Fin 4 → Fin 10 × ZMod (7*q), Function.Injective g →
      ¬ PaschClassification.EvenChecks
        (fun i => PaschLiftProjection.columns (dual PaschCubicTrade.baseA)
          (inverseLabels (labels q)) (g i)) := by
    intro g hg
    exact StarDuality.dual_nonzero_eliminates 7 (seven_nonzero q hq) g hg
  apply QCSectorElimination.no_four_dependency (dual PaschCubicTrade.baseA)
    (inverseLabels (labels q)) (ScalarTranspose.columns (7*q)) dual_linear hleft
    (ScalarTranspose.no_four_dependency q hq) (fun i => Sum.swap (f i))
    (fun i j h => hf (by simpa only [Sum.swap_swap] using congrArg Sum.swap h))
    (fun i => cubicZ q hq (f i))
    (fun i j hij => linearZ q hq _ _ (fun h => hij (hf h)))

theorem kernel_lowerX (hq : 2≤q) (x : Qubits q → F) (hx : X q*ᵥx=0) (hn : x≠0) :
    6≤BinaryDistance.weight x := by
  rw [← checkX q hq] at hx
  exact KernelFourBridge.lower_bound (graphX q) (cubicX q hq) (linearX q hq)
    (no_fourX q hq) x hx hn

theorem kernel_lowerZ (hq : 2≤q) (x : Qubits q → F) (hx : Z q*ᵥx=0) (hn : x≠0) :
    6≤BinaryDistance.weight x := by
  rw [← checkZ q hq] at hx
  exact KernelFourBridge.lower_bound (graphZ q) (cubicZ q hq) (linearZ q hq)
    (no_fourZ q hq) x hx hn

#print axioms checkX
#print axioms checkZ
#print axioms cubicX
#print axioms linearX
#print axioms no_fourX
#print axioms no_fourZ
#print axioms kernel_lowerX
#print axioms kernel_lowerZ
end FamilyGraphs
