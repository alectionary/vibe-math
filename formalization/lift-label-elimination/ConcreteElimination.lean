import FinitePaschRepresentatives
import CountRepresentatives
import LiteralLabelCounts
import LabelEncoding

set_option maxHeartbeats 0
namespace ConcreteElimination
open FinitePaschRepresentatives
open scoped BigOperators
variable (N : ℕ) [NeZero N]

theorem star_raw_iff (z : Fin 30 → ZMod N) :
    Eliminates StarVoltageData.H (StarVoltageData.labelsRaw z) ↔
      ¬PaschVoltage.Balanced (StarVoltageData.dRaw z 0) := by
  have h := eliminates_iff StarVoltageData.H (StarVoltageData.labelsRaw z)
    PaschCubicTrade.cubic_A PaschCubicTrade.linear_A StarVoltageData.variableAt
    StarVoltageData.rep_injective StarVoltageData.checks StarVoltageData.rep_even
    StarVoltageData.pair_checks StarVoltageData.complete_supports
  constructor
  · intro he; exact h.mp he 0
  · intro he; apply h.mpr; intro r; fin_cases r; exact he

theorem star_slice_iff (z : Fin 11 → ZMod N) :
    Eliminates StarVoltageData.H (StarVoltageData.labelsGauge z) ↔
      ¬PaschVoltage.Balanced (StarVoltageData.dGauge z 0) := by
  have h := eliminates_iff StarVoltageData.H (StarVoltageData.labelsGauge z)
    PaschCubicTrade.cubic_A PaschCubicTrade.linear_A StarVoltageData.variableAt
    StarVoltageData.rep_injective StarVoltageData.checks StarVoltageData.rep_even
    StarVoltageData.pair_checks StarVoltageData.complete_supports
  constructor
  · intro he; exact h.mp he 0
  · intro he; apply h.mpr; intro r; fin_cases r; exact he

theorem triangle_raw_iff (z : Fin 30 → ZMod N) :
    Eliminates TriangleVoltageData.H (TriangleVoltageData.labelsRaw z) ↔
      ∀ r, ¬PaschVoltage.Balanced (TriangleVoltageData.dRaw z r) :=
  eliminates_iff TriangleVoltageData.H (TriangleVoltageData.labelsRaw z)
    PaschCubicTrade.cubic_B PaschCubicTrade.linear_B TriangleVoltageData.variableAt
    TriangleVoltageData.rep_injective TriangleVoltageData.checks TriangleVoltageData.rep_even
    TriangleVoltageData.pair_checks TriangleVoltageData.complete_supports

theorem triangle_slice_iff (z : Fin 11 → ZMod N) :
    Eliminates TriangleVoltageData.H (TriangleVoltageData.labelsGauge z) ↔
      ∀ r, ¬PaschVoltage.Balanced (TriangleVoltageData.dGauge z r) :=
  eliminates_iff TriangleVoltageData.H (TriangleVoltageData.labelsGauge z)
    PaschCubicTrade.cubic_B PaschCubicTrade.linear_B TriangleVoltageData.variableAt
    TriangleVoltageData.rep_injective TriangleVoltageData.checks TriangleVoltageData.rep_even
    TriangleVoltageData.pair_checks TriangleVoltageData.complete_supports

theorem star_raw_count :
    (Nat.card {z : Fin 30 → ZMod N // Eliminates StarVoltageData.H (StarVoltageData.labelsRaw z)} : ℤ)=
      (N : ℤ)^30-(N : ℤ)^27 := by
  rw [Nat.card_congr (Equiv.subtypeEquivRight (star_raw_iff N))]
  exact LiteralLabelCounts.star_raw_avoiding N

theorem star_slice_count :
    (Nat.card {z : Fin 11 → ZMod N // Eliminates StarVoltageData.H (StarVoltageData.labelsGauge z)} : ℤ)=
      (N : ℤ)^11-(N : ℤ)^8 := by
  rw [Nat.card_congr (Equiv.subtypeEquivRight (star_slice_iff N))]
  exact LiteralLabelCounts.star_gauge_avoiding N

lemma none_iff (P : Fin 5 → Prop) [DecidablePred P] :
    (∀ r, ¬P r) ↔ (Finset.univ.filter P).card=0 := by
  simp only [Finset.card_eq_zero,Finset.filter_eq_empty_iff,Finset.mem_univ,true_implies]

theorem triangle_raw_count :
    (Nat.card {z : Fin 30 → ZMod N // Eliminates TriangleVoltageData.H (TriangleVoltageData.labelsRaw z)} : ℤ)=
      (N : ℤ)^30-5*(N : ℤ)^27+10*(N : ℤ)^24-10*(N : ℤ)^21+4*(N : ℤ)^19 := by
  classical
  have he (z : Fin 30 → ZMod N) := (triangle_raw_iff N z).trans
    (none_iff (fun r => PaschVoltage.Balanced (TriangleVoltageData.dRaw z r)))
  rw [Nat.card_congr (Equiv.subtypeEquivRight he)]
  calc
    _=(N : ℤ)^19*HistogramPolynomials.polynomial N 0 := LiteralLabelCounts.triangle_raw_histogram N 0
    _=_ := by norm_num [HistogramPolynomials.polynomial] <;> ring

theorem triangle_slice_count :
    (Nat.card {z : Fin 11 → ZMod N // Eliminates TriangleVoltageData.H (TriangleVoltageData.labelsGauge z)} : ℤ)=
      HistogramPolynomials.polynomial N 0 := by
  classical
  have he (z : Fin 11 → ZMod N) := (triangle_slice_iff N z).trans
    (none_iff (fun r => PaschVoltage.Balanced (TriangleVoltageData.dGauge z r)))
  rw [Nat.card_congr (Equiv.subtypeEquivRight he)]
  exact LiteralLabelCounts.triangle_gauge_histogram N 0

theorem star_support_count (z : Fin 30 → ZMod N) :
    PaschKernelCount.count40 (PaschLiftProjection.columns StarVoltageData.H (StarVoltageData.labelsRaw z))=
      N*Nat.card {r : Fin 1 // PaschVoltage.Balanced (StarVoltageData.dRaw z r)} := by
  have h := CountRepresentatives.count40_representatives StarVoltageData.H (StarVoltageData.labelsRaw z)
    PaschCubicTrade.cubic_A PaschCubicTrade.linear_A StarVoltageData.variableAt
    StarVoltageData.rep_injective StarVoltageData.checks StarVoltageData.rep_even
    StarVoltageData.pair_checks StarVoltageData.repSet_injective StarVoltageData.complete_supports
  simpa only [Nat.card_eq_fintype_card,ZMod.card,StarVoltageData.dRaw] using h

theorem triangle_support_count (z : Fin 30 → ZMod N) :
    PaschKernelCount.count40 (PaschLiftProjection.columns TriangleVoltageData.H (TriangleVoltageData.labelsRaw z))=
      N*Nat.card {r : Fin 5 // PaschVoltage.Balanced (TriangleVoltageData.dRaw z r)} := by
  have h := CountRepresentatives.count40_representatives TriangleVoltageData.H (TriangleVoltageData.labelsRaw z)
    PaschCubicTrade.cubic_B PaschCubicTrade.linear_B TriangleVoltageData.variableAt
    TriangleVoltageData.rep_injective TriangleVoltageData.checks TriangleVoltageData.rep_even
    TriangleVoltageData.pair_checks TriangleVoltageData.repSet_injective TriangleVoltageData.complete_supports
  simpa only [Nat.card_eq_fintype_card,ZMod.card,TriangleVoltageData.dRaw] using h

#print axioms star_raw_iff
#print axioms triangle_raw_iff
#print axioms star_raw_count
#print axioms triangle_raw_count
#print axioms star_support_count
#print axioms triangle_support_count
end ConcreteElimination
