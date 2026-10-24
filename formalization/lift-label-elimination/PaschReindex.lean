import PaschLiftCriterion

set_option maxHeartbeats 0
namespace PaschReindex
open FourColumnClassification
variable {C : Type*} [Fintype C] [DecidableEq C]

theorem support_card (K : Fin 4 → Finset C) (e : Fin 4 ≃ Fin 4) (c : C) :
    (support (fun i => K (e i)) c).card=(support K c).card := by
  apply Finset.card_bij (fun i _ => e i)
  · intro i hi
    exact (mem_support K c (e i)).mpr ((mem_support (fun i => K (e i)) c i).mp hi)
  · intro i _ j _ hij
    exact e.injective hij
  · intro j hj
    refine ⟨e.symm j,?_,e.apply_symm_apply j⟩
    apply (mem_support _ _ _).mpr
    simpa only [e.apply_symm_apply] using (mem_support _ _ _).mp hj

theorem even_iff (K : Fin 4 → Finset C) (e : Fin 4 ≃ Fin 4) :
    PaschClassification.EvenChecks (fun i => K (e i)) ↔ PaschClassification.EvenChecks K := by
  simp only [PaschClassification.EvenChecks,support_card]

variable {V G : Type*} [Fintype V] [Fintype G] [DecidableEq V] [DecidableEq G] [AddCommGroup G]

theorem offsets_one_direction (H : V → Finset C) (z : V → C → G)
    (f g : Fin 4 → V) (hg : Function.Injective g)
    (himage : Finset.univ.image f=Finset.univ.image g)
    (x : Fin 4 → G)
    (hx : PaschClassification.EvenChecks (fun i => PaschLiftProjection.columns H z (f i,x i))) :
    ∃ y : Fin 4 → G, PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z (g i,y i)) := by
  classical
  have hp : ∀ i, ∃ j, f j=g i := by
    intro i
    have hm : g i∈Finset.univ.image f := by rw [himage]; exact Finset.mem_image.mpr ⟨i,Finset.mem_univ _,rfl⟩
    obtain ⟨j,_,hj⟩ := Finset.mem_image.mp hm
    exact ⟨j,hj⟩
  choose p hp using hp
  have hi : Function.Injective p := by
    intro i j hij
    apply hg
    rw [← hp i,← hp j,hij]
  let e : Fin 4 ≃ Fin 4 := Equiv.ofBijective p ⟨hi,Finite.surjective_of_injective hi⟩
  have he := (even_iff (fun i => PaschLiftProjection.columns H z (f i,x i)) e).mpr hx
  refine ⟨fun i => x (p i),?_⟩
  change PaschClassification.EvenChecks
    (fun i => PaschLiftProjection.columns H z (f (p i),x (p i))) at he
  simpa only [hp] using he

theorem offsets_exist_iff (H : V → Finset C) (z : V → C → G)
    (f g : Fin 4 → V) (hf : Function.Injective f) (hg : Function.Injective g)
    (himage : Finset.univ.image f=Finset.univ.image g) :
    (∃ x : Fin 4 → G, PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z (f i,x i))) ↔
    (∃ y : Fin 4 → G, PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns H z (g i,y i))) := by
  constructor
  · rintro ⟨x,hx⟩
    exact offsets_one_direction H z f g hg himage x hx
  · rintro ⟨y,hy⟩
    exact offsets_one_direction H z g f hf himage.symm y hy

#print axioms even_iff
#print axioms offsets_exist_iff
end PaschReindex
