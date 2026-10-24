import LabelHistograms
import StarVoltageData
import TriangleVoltageData
import StarCertificates
import FiniteEventArithmetic

set_option maxHeartbeats 0
namespace LiteralLabelCounts
open scoped BigOperators
open CycleKernelBridge EventHistogram HistogramPolynomials
variable (N : ℕ) [NeZero N]

/-- These balance events use the actual thirty-edge label assignment of the star base. -/
theorem star_raw_event :
    Nat.card {z : Fin 30 → ZMod N // PaschVoltage.Balanced (StarVoltageData.dRaw z 0)}=N^27 := by
  have he (z : Fin 30 → ZMod N) : PaschVoltage.Balanced (StarVoltageData.dRaw z 0) ↔
      Events CycleData.starRaw {0} z := by
    simp only [StarVoltageData.balancedRaw,Events,Finset.mem_singleton,forall_eq]
  exact (Nat.card_congr (Equiv.subtypeEquivRight he)).trans (ConnectStarRaw1.actual_count N)

theorem star_gauge_event :
    Nat.card {z : Fin 11 → ZMod N // PaschVoltage.Balanced (StarVoltageData.dGauge z 0)}=N^8 := by
  have he (z : Fin 11 → ZMod N) : PaschVoltage.Balanced (StarVoltageData.dGauge z 0) ↔
      Events CycleData.starGauge {0} z := by
    simp only [StarVoltageData.balancedGauge,Events,Finset.mem_singleton,forall_eq]
  exact (Nat.card_congr (Equiv.subtypeEquivRight he)).trans (ConnectStarGauge1.actual_count N)

theorem star_raw_avoiding :
    (Nat.card {z : Fin 30 → ZMod N // ¬PaschVoltage.Balanced (StarVoltageData.dRaw z 0)} : ℤ)=
      (N : ℤ)^30-(N : ℤ)^27 := by
  classical
  rw [FiniteEventArithmetic.avoid_one,star_raw_event,Nat.card_eq_fintype_card,Fintype.card_fun,
    ZMod.card,Fintype.card_fin,Nat.cast_pow]
  simp only [Nat.cast_pow]

theorem star_gauge_avoiding :
    (Nat.card {z : Fin 11 → ZMod N // ¬PaschVoltage.Balanced (StarVoltageData.dGauge z 0)} : ℤ)=
      (N : ℤ)^11-(N : ℤ)^8 := by
  classical
  rw [FiniteEventArithmetic.avoid_one,star_gauge_event,Nat.card_eq_fintype_card,Fintype.card_fun,
    ZMod.card,Fintype.card_fin,Nat.cast_pow]
  simp only [Nat.cast_pow]

/-- The full histogram for the actual triangle-base balance tests, not surrogate predicates. -/
theorem triangle_raw_histogram (j : Fin 6) :
    (Nat.card {z : Fin 30 → ZMod N //
      (Finset.univ.filter (fun i : Fin 5 => PaschVoltage.Balanced (TriangleVoltageData.dRaw z i))).card=j.val} : ℤ)=
      (N : ℤ)^19*polynomial N j := by
  classical
  have he (z : Fin 30 → ZMod N) :
      (Finset.univ.filter (fun i : Fin 5 => PaschVoltage.Balanced (TriangleVoltageData.dRaw z i))).card=j.val ↔
      (trueSet (LabelHistograms.eventsRaw N z)).card=j.val := by
    have hset : (Finset.univ.filter (fun i : Fin 5 =>
        PaschVoltage.Balanced (TriangleVoltageData.dRaw z i)))=
        trueSet (LabelHistograms.eventsRaw N z) := by
      unfold trueSet
      apply Finset.filter_congr
      intro i _
      simp only [LabelHistograms.eventsRaw,TriangleVoltageData.balancedRaw,decide_eq_true_eq]
    rw [hset]
  rw [Nat.card_congr (Equiv.subtypeEquivRight he),Nat.card_eq_fintype_card,Fintype.card_subtype]
  exact LabelHistograms.triangle_raw_histogram N j

theorem triangle_gauge_histogram (j : Fin 6) :
    (Nat.card {z : Fin 11 → ZMod N //
      (Finset.univ.filter (fun i : Fin 5 => PaschVoltage.Balanced (TriangleVoltageData.dGauge z i))).card=j.val} : ℤ)=
      polynomial N j := by
  classical
  have he (z : Fin 11 → ZMod N) :
      (Finset.univ.filter (fun i : Fin 5 => PaschVoltage.Balanced (TriangleVoltageData.dGauge z i))).card=j.val ↔
      (trueSet (LabelHistograms.eventsGauge N z)).card=j.val := by
    have hset : (Finset.univ.filter (fun i : Fin 5 =>
        PaschVoltage.Balanced (TriangleVoltageData.dGauge z i)))=
        trueSet (LabelHistograms.eventsGauge N z) := by
      unfold trueSet
      apply Finset.filter_congr
      intro i _
      simp only [LabelHistograms.eventsGauge,TriangleVoltageData.balancedGauge,decide_eq_true_eq]
    rw [hset]
  rw [Nat.card_congr (Equiv.subtypeEquivRight he),Nat.card_eq_fintype_card,Fintype.card_subtype]
  exact LabelHistograms.triangle_gauge_histogram N j

#print axioms star_raw_avoiding
#print axioms star_gauge_avoiding
#print axioms triangle_raw_histogram
#print axioms triangle_gauge_histogram
end LiteralLabelCounts
