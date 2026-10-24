import SumCounting
import PaschReindex

set_option maxHeartbeats 0
namespace FinitePaschRepresentatives
open FourColumnClassification GlobalCounting PaschKernelCount
variable {U C G R : Type*} [Fintype U] [Fintype C] [Fintype G] [Fintype R]
  [DecidableEq U] [DecidableEq C] [DecidableEq G] [DecidableEq R] [AddCommGroup G]

def Eliminates (H : U → Finset C) (z : U → C → G) : Prop :=
  ∀ f : Fin 4 → U × G, Function.Injective f →
    ¬ PaschClassification.EvenChecks (fun i => PaschLiftProjection.columns H z (f i))

def PairChecks (H : U → Finset C) (v : Fin 4 → U) (c : Fin 6 → C) : Prop :=
  H (v 0) ∩ H (v 1)={c 0} ∧ H (v 0) ∩ H (v 2)={c 1} ∧
  H (v 0) ∩ H (v 3)={c 2} ∧ H (v 1) ∩ H (v 2)={c 3} ∧
  H (v 1) ∩ H (v 3)={c 4} ∧ H (v 2) ∩ H (v 3)={c 5}

theorem image_selected_card (H : U → Finset C) (g : Fin 4 → U)
    (hg : Function.Injective g) (c : C) :
    (selected H (Finset.univ.image g) c).card=(support (fun i => H (g i)) c).card := by
  have he : selected H (Finset.univ.image g) c=(support (fun i => H (g i)) c).image g := by
    ext v
    simp only [selected,Finset.mem_filter,Finset.mem_image,Finset.mem_univ,true_and,mem_support]
    constructor
    · rintro ⟨⟨i,rfl⟩,h⟩; exact ⟨i,h,rfl⟩
    · rintro ⟨i,h,rfl⟩; exact ⟨⟨i,rfl⟩,h⟩
  rw [he,Finset.card_image_of_injective _ hg]

theorem local_exists_iff (H : U → Finset C) (z : U → C → G)
    (hd : ∀ u, (H u).card=3)
    (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (v : Fin 4 → U) (hv : Function.Injective v) (c : Fin 6 → C)
    (he : PaschClassification.EvenChecks (fun i => H (v i))) (hc : PairChecks H v c) :
    (∃ x : Fin 4 → G, PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z (v i,x i))) ↔
      PaschVoltage.Balanced (PaschLiftCriterion.differences (fun i d => z (v i) d) c) := by
  let H4 : Fin 4 → Finset C := fun i => H (v i)
  let z4 : Fin 4 → C → G := fun i d => z (v i) d
  have hd4 : ∀ i, (H4 i).card=3 := fun i => hd _
  have hl4 : ∀ i j, i≠j → (H4 i ∩ H4 j).card≤1 :=
    fun i j hij => hl _ _ (fun h => hij (hv h))
  have he4 := PaschClassification.even_checks_elementary H4 hd4 hl4 he
  rcases hc with ⟨h0,h1,h2,h3,h4,h5⟩
  have hx (x : Fin 4 → G) := PaschLiftCriterion.actual_even_iff_compatible H4 z4 c hd4 hl4 he4
    h0 h1 h2 h3 h4 h5 x
  exact (exists_congr hx).trans (PaschVoltage.exists_compatible_iff _)

/-- A complete finite list of base Pasches reduces the actual lift-elimination
question to its literal voltage tests. Projection, reordering and the source
incidence appear explicitly in this theorem. -/
theorem eliminates_iff (H : U → Finset C) (z : U → C → G)
    (hd : ∀ u, (H u).card=3)
    (hl : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (v : R → Fin 4 → U) (hv : ∀ r, Function.Injective (v r))
    (c : R → Fin 6 → C)
    (he : ∀ r, PaschClassification.EvenChecks (fun i => H (v r i)))
    (hc : ∀ r, PairChecks H (v r) (c r))
    (hcomplete : SumCounting.good H=(Finset.univ : Finset R).image (fun r => Finset.univ.image (v r))) :
    Eliminates H z ↔ ∀ r, ¬ PaschVoltage.Balanced
      (PaschLiftCriterion.differences (fun i d => z (v r i) d) (c r)) := by
  constructor
  · intro h r hr
    obtain ⟨x,hx⟩ := (local_exists_iff H z hd hl (v r) (hv r) (c r) (he r) (hc r)).mpr hr
    exact h (fun i => (v r i,x i))
      (fun i j hij => hv r (congrArg Prod.fst hij)) hx
  · intro h f hf hfEven
    have hp := PaschLiftProjection.zero_syndrome_projects H z hd hl f hf hfEven
    let g : Fin 4 → U := fun i => (f i).1
    let x : Fin 4 → G := fun i => (f i).2
    have hd4 : ∀ i, (H (g i)).card=3 := fun i => hd _
    have hl4 : ∀ i j, i≠j → (H (g i) ∩ H (g j)).card≤1 :=
      fun i j hij => hl _ _ (fun heq => hij (hp.1 heq))
    have helem := PaschClassification.even_checks_elementary _ hd4 hl4 hp.2
    have hS : (Finset.univ.image g)∈SumCounting.good H := by
      apply (SumCounting.mem_good _ _).mpr
      refine ⟨?_,?_,?_⟩
      · rw [Finset.card_image_of_injective (f := g) _ hp.1]
        exact Fintype.card_fin 4
      · intro d; rw [image_selected_card H g hp.1]; exact helem d
      · intro d; rw [image_selected_card H g hp.1]; exact hp.2 d
    rw [hcomplete] at hS
    obtain ⟨r,_,hr⟩ := Finset.mem_image.mp hS
    have hx : PaschClassification.EvenChecks
        (fun i => PaschLiftProjection.columns H z (g i,x i)) := hfEven
    obtain ⟨y,hy⟩ := (PaschReindex.offsets_exist_iff H z g (v r) hp.1 (hv r) hr.symm).mp ⟨x,hx⟩
    exact h r ((local_exists_iff H z hd hl (v r) (hv r) (c r) (he r) (hc r)).mp ⟨y,hy⟩)

#print axioms local_exists_iff
#print axioms eliminates_iff
end FinitePaschRepresentatives
