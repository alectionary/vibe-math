import CoverCounting

set_option maxHeartbeats 0
namespace SupportVoltageCount
open GlobalCounting FourColumnClassification PaschRootClassification
variable {V C G : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G]

lemma pair_singleton (H : Fin 4 → Finset C) (hd : ∀ i, (H i).card=3)
    (h4 : ∀ i j, i≠j → (H i ∩ H j).card≤1)
    (he : PaschClassification.EvenChecks H) (i j : Fin 4) (hij : i≠j) :
    ∃ c, H i ∩ H j={c} := by
  have hel := PaschClassification.even_checks_elementary H hd h4 he
  have hp := (elementary_pair_complete_iff H hd h4 hel).mpr he
  have hc : (H i ∩ H j).card=1 := by
    have hpos := Finset.card_pos.mpr (hp i j hij)
    have hle := h4 i j hij
    omega
  exact Finset.card_eq_one.mp hc

def HasEvenOffset (H : V → Finset C) (z : V → C → G) (S : FourSupport V) : Prop :=
  ∃ x : Fin 4 → G, PaschClassification.EvenChecks
    (fun i => PaschLiftProjection.columns H z ((label S i).val,x i))

noncomputable instance (H : V → Finset C) (z : V → C → G) (S : FourSupport V) :
    Decidable (HasEvenOffset H z S) := Classical.propDecidable _

theorem offset_count (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1) (S : FourSupport V) :
    Nat.card {x : Fin 4 → G // PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z ((label S i).val,x i))} =
      if HasEvenOffset H z S then Nat.card G else 0 := by
  classical
  by_cases hex : HasEvenOffset H z S
  · rw [if_pos hex]
    obtain ⟨x,hx⟩ := hex
    let H4 : Fin 4 → Finset C := fun i => H ((label S i).val)
    let z4 : Fin 4 → C → G := fun i c => z ((label S i).val) c
    have hd4 : ∀ i, (H4 i).card=3 := fun i => hd _
    have h44 : ∀ i j, i≠j → (H4 i ∩ H4 j).card≤1 := by
      intro i j hij
      apply h4
      exact fun h => hij ((label S).injective (Subtype.ext h))
    have hf : Function.Injective (fun i => ((label S i).val,x i)) :=
      UnorderedSections.graph_injective S x
    have hbase : PaschClassification.EvenChecks H4 :=
      (PaschLiftProjection.zero_syndrome_projects H z hd h4 _ hf hx).2
    have hel := PaschClassification.even_checks_elementary H4 hd4 h44 hbase
    obtain ⟨c0,h0⟩ := pair_singleton H4 hd4 h44 hbase 0 1 (by decide)
    obtain ⟨c1,h1⟩ := pair_singleton H4 hd4 h44 hbase 0 2 (by decide)
    obtain ⟨c2,h2⟩ := pair_singleton H4 hd4 h44 hbase 0 3 (by decide)
    obtain ⟨c3,h3⟩ := pair_singleton H4 hd4 h44 hbase 1 2 (by decide)
    obtain ⟨c4,h4c⟩ := pair_singleton H4 hd4 h44 hbase 1 3 (by decide)
    obtain ⟨c5,h5⟩ := pair_singleton H4 hd4 h44 hbase 2 3 (by decide)
    let cs : Fin 6 → C := fun e => match e.val with
      | 0 => c0 | 1 => c1 | 2 => c2 | 3 => c3 | 4 => c4 | _ => c5
    have hb : PaschVoltage.Balanced (PaschLiftCriterion.differences z4 cs) :=
      PaschVoltage.compatible_implies_balanced _ x
        ((PaschLiftCriterion.actual_even_iff_compatible H4 z4 cs hd4 h44 hel
          h0 h1 h2 h3 h4c h5 x).mp hx)
    have hc := PaschLiftCriterion.actual_even_offset_count H4 z4 cs hd4 h44 hel
      h0 h1 h2 h3 h4c h5
    rw [if_pos hb] at hc
    exact hc
  · rw [if_neg hex]
    letI : IsEmpty {x : Fin 4 → G // PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z ((label S i).val,x i))} :=
      ⟨fun x => hex ⟨x.val,x.prop⟩⟩
    exact Nat.card_of_isEmpty

/-- The complete all-N count for unordered supports of an ordinary monomial lift. -/
theorem unordered_voltage_count (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1) :
    PaschKernelCount.count40 (PaschLiftProjection.columns H z)=
      Nat.card G * ∑ S : FourSupport V, if HasEvenOffset H z S then 1 else 0 := by
  classical
  rw [CoverCounting.count_eq_sum_offsets H z hd h4, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro S _
  rw [offset_count H z hd h4 S]
  split_ifs <;> simp

#print axioms offset_count
#print axioms unordered_voltage_count
end SupportVoltageCount
