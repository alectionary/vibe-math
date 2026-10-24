import GlobalCounting
set_option maxHeartbeats 0
namespace IncidenceEquivalence
open GlobalCounting
variable {V W C D : Type*} [Fintype V] [Fintype W] [Fintype C] [Fintype D]
    [DecidableEq V] [DecidableEq W] [DecidableEq C] [DecidableEq D]

theorem selected_card (H : V → Finset C) (K : W → Finset D) (e : V ≃ W) (f : C ≃ D)
    (hp : ∀ v, K (e v) = (H v).image f) (S : Finset V) (c : C) :
    (selected H S c).card = (selected K (S.image e) (f c)).card := by
  have hm (v : V) : f c ∈ K (e v) ↔ c ∈ H v := by simp [hp]
  apply Finset.card_bij (fun v _ => e v)
  · intro v hv
    have h := Finset.mem_filter.mp hv
    exact Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨v,h.1,rfl⟩,(hm v).mpr h.2⟩
  · intro v _ w _ h
    exact e.injective h
  · intro w hw
    have h := Finset.mem_filter.mp hw
    obtain ⟨v,hv,rfl⟩ := Finset.mem_image.mp h.1
    exact ⟨v,Finset.mem_filter.mpr ⟨hv,(hm v).mp h.2⟩,rfl⟩

theorem check_transfer (H : V → Finset C) (K : W → Finset D) (e : V ≃ W) (f : C ≃ D)
    (hp : ∀ v, K (e v) = (H v).image f) (S : Finset V) :
    elementary42Check H S ↔ elementary42Check K (S.image e) := by
  have hs := selected_card H K e f hp S
  have ho : (Finset.univ.filter (fun c => (selected H S c).card % 2=1)).card =
      (Finset.univ.filter (fun d => (selected K (S.image e) d).card % 2=1)).card := by
    apply Finset.card_bij (fun c _ => f c)
    · intro c hc
      simpa only [Finset.mem_filter,Finset.mem_univ,true_and,← hs c] using hc
    · intro c _ d _ h
      exact f.injective h
    · intro d hd
      refine ⟨f.symm d,?_,by simp⟩
      simpa only [Finset.mem_filter,Finset.mem_univ,true_and,hs (f.symm d),Equiv.apply_symm_apply] using hd
  constructor
  · rintro ⟨ha,hb⟩
    refine ⟨?_,ho ▸ hb⟩
    intro d
    simpa only [hs (f.symm d),Equiv.apply_symm_apply] using ha (f.symm d)
  · rintro ⟨ha,hb⟩
    refine ⟨?_,ho.symm ▸ hb⟩
    intro c
    simpa only [hs c] using ha (f c)

theorem count42_eq (H : V → Finset C) (K : W → Finset D) (e : V ≃ W) (f : C ≃ D)
    (hp : ∀ v, K (e v) = (H v).image f) : count42 H = count42 K := by
  unfold count42
  apply Finset.card_bij (fun S _ => S.image e)
  · intro S hS
    have h := Finset.mem_filter.mp hS
    apply Finset.mem_filter.mpr
    constructor
    · have hc := (Finset.mem_powersetCard.mp h.1).2
      apply Finset.mem_powersetCard.mpr
      exact ⟨Finset.subset_univ _,by simpa only [Finset.card_image_of_injective _ e.injective] using hc⟩
    · exact (check_transfer H K e f hp S).mp h.2
  · intro S _ T _ h
    have hh := congrArg (Finset.image e.symm) h
    simpa [Finset.image_image] using hh
  · intro T hT
    let S := T.image e.symm
    have hST : S.image e = T := by simp [S,Finset.image_image]
    refine ⟨S,?_,hST⟩
    have h := Finset.mem_filter.mp hT
    apply Finset.mem_filter.mpr
    constructor
    · have hc := (Finset.mem_powersetCard.mp h.1).2
      apply Finset.mem_powersetCard.mpr
      exact ⟨Finset.subset_univ _,by simpa only [S,Finset.card_image_of_injective _ e.symm.injective] using hc⟩
    · apply (check_transfer H K e f hp S).mpr
      simpa only [hST] using h.2

#print axioms count42_eq
end IncidenceEquivalence
