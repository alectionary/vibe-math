import FinitePaschRepresentatives
import SupportVoltageCount

set_option maxHeartbeats 0
namespace CountRepresentatives
open GlobalCounting PaschKernelCount SupportVoltageCount
open FinitePaschRepresentatives
variable {U C G R : Type*} [Fintype U] [Fintype C] [Fintype G] [Fintype R]
  [DecidableEq U] [DecidableEq C] [DecidableEq G] [DecidableEq R] [AddCommGroup G]

noncomputable def repSupport (v : Fin 4 → U) (hv : Function.Injective v) : FourSupport U :=
  ⟨Finset.univ.image v,Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,by
    rw [Finset.card_image_of_injective _ hv]; exact Fintype.card_fin 4⟩⟩

theorem canonical_image (S : FourSupport U) :
    Finset.univ.image (fun i : Fin 4 => (label S i).val)=S.val := by
  ext u
  constructor
  · rintro hu
    obtain ⟨i,_,hi⟩ := Finset.mem_image.mp hu
    exact hi ▸ (label S i).prop
  · intro hu
    refine Finset.mem_image.mpr ⟨(label S).symm ⟨u,hu⟩,Finset.mem_univ _,?_⟩
    simp

theorem has_offset_good (H : U → Finset C) (z : U → C → G)
    (hd : ∀ u, (H u).card=3) (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (S : FourSupport U) (hs : HasEvenOffset H z S) : S.val∈SumCounting.good H := by
  obtain ⟨x,hx⟩ := hs
  have hf : Function.Injective (fun i : Fin 4 => ((label S i).val,x i)) :=
    UnorderedSections.graph_injective S x
  have hp := PaschLiftProjection.zero_syndrome_projects H z hd hl _ hf hx
  have hbase : PaschClassification.EvenChecks (localCols H S) := hp.2
  have he := (PaschClassification.elementary40_iff_even (localCols H S)
    (local_degree H hd S) (local_linear H hl S)).mpr hbase
  exact (SumCounting.mem_good H S.val).mpr ⟨support_card S,(local_elementary40_iff H S).mpr he⟩

variable (H : U → Finset C) (z : U → C → G)
    (hd : ∀ u, (H u).card=3) (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (v : R → Fin 4 → U) (hv : ∀ r, Function.Injective (v r))
    (c : R → Fin 6 → C)
    (he : ∀ r, PaschClassification.EvenChecks (fun i => H (v r i)))
    (hc : ∀ r, PairChecks H (v r) (c r))

include hd hl he hc in
theorem rep_offset_iff (r : R) :
    HasEvenOffset H z (repSupport (v r) (hv r)) ↔
      PaschVoltage.Balanced (PaschLiftCriterion.differences (fun i d => z (v r i) d) (c r)) := by
  let S := repSupport (v r) (hv r)
  have hf : Function.Injective (fun i : Fin 4 => (label S i).val) := by
    intro i j hij
    exact (label S).injective (Subtype.ext hij)
  have hi : Finset.univ.image (fun i : Fin 4 => (label S i).val)=Finset.univ.image (v r) :=
    canonical_image S
  exact (PaschReindex.offsets_exist_iff H z _ (v r) hf (hv r) hi).trans
    (local_exists_iff H z hd hl (v r) (hv r) (c r) (he r) (hc r))

noncomputable def balancedSupportEquiv
    (huniq : Function.Injective (fun r => Finset.univ.image (v r)))
    (hcomplete : SumCounting.good H=(Finset.univ : Finset R).image (fun r => Finset.univ.image (v r))) :
    {r : R // PaschVoltage.Balanced (PaschLiftCriterion.differences (fun i d => z (v r i) d) (c r))} ≃
      {S : FourSupport U // HasEvenOffset H z S} := by
  let f := fun r : {r : R // PaschVoltage.Balanced
    (PaschLiftCriterion.differences (fun i d => z (v r i) d) (c r))} =>
      (⟨repSupport (v r.val) (hv r.val),
        (rep_offset_iff H z hd hl v hv c he hc r.val).mpr r.prop⟩ :
          {S : FourSupport U // HasEvenOffset H z S})
  apply Equiv.ofBijective f
  constructor
  · intro a b hab
    apply Subtype.ext
    apply huniq
    exact congrArg (fun t => t.val.val) hab
  · intro S
    have hS := has_offset_good H z hd hl S.val S.prop
    rw [hcomplete] at hS
    obtain ⟨r,_,hr⟩ := Finset.mem_image.mp hS
    have hrep : repSupport (v r) (hv r)=S.val := Subtype.ext hr
    have hp : HasEvenOffset H z (repSupport (v r) (hv r)) := by rw [hrep]; exact S.prop
    refine ⟨⟨r,(rep_offset_iff H z hd hl v hv c he hc r).mp hp⟩,?_⟩
    exact Subtype.ext hrep

include hd hl hv he hc in
/-- Exact unordered support count indexed by any complete, nonredundant list
of ordered base representatives. Reordering is proved, not assumed. -/
theorem count40_representatives
    (huniq : Function.Injective (fun r => Finset.univ.image (v r)))
    (hcomplete : SumCounting.good H=(Finset.univ : Finset R).image (fun r => Finset.univ.image (v r))) :
    count40 (PaschLiftProjection.columns H z)=Nat.card G*
      Nat.card {r : R // PaschVoltage.Balanced
        (PaschLiftCriterion.differences (fun i d => z (v r i) d) (c r))} := by
  classical
  rw [unordered_voltage_count H z hd hl]
  have hn : (∑ S : FourSupport U, if HasEvenOffset H z S then 1 else 0)=
      Nat.card {S : FourSupport U // HasEvenOffset H z S} := by
    rw [Nat.card_eq_fintype_card,Fintype.card_subtype,Finset.card_eq_sum_ones,Finset.sum_filter]
  rw [hn,Nat.card_congr (balancedSupportEquiv H z hd hl v hv c he hc huniq hcomplete).symm]

#print axioms rep_offset_iff
#print axioms balancedSupportEquiv
#print axioms count40_representatives
end CountRepresentatives
