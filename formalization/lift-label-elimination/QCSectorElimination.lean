import VoltageQCIncidence

set_option maxHeartbeats 0
namespace QCSectorElimination
open FourColumnClassification PaschRootClassification PairFormula VoltageQCIncidence
variable {U C E G : Type*} [DecidableEq U] [DecidableEq C] [DecidableEq E]
  [DecidableEq G] [Fintype U] [Fintype C] [Fintype E] [Fintype G] [AddCommGroup G]

theorem no_mixed_pair (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (f : Fin 4 → Sum (U × G) (C × E)) (hf : Function.Injective f)
    (hd : ∀ i, (columns H z B (f i)).card=3)
    (hl : ∀ i j, i≠j → (columns H z B (f i) ∩ columns H z B (f j)).card≤1)
    (he : PaschClassification.EvenChecks (fun i => columns H z B (f i)))
    (i j : Fin 4) (v : U × G) (r : C × E)
    (hi : f i=Sum.inl v) (hj : f j=Sum.inr r) : False := by
  have hij : i≠j := by intro h; rw [h,hj] at hi; cases hi
  have hel := PaschClassification.even_checks_elementary _ hd hl he
  have hp := (elementary_pair_complete_iff _ hd hl hel).mpr he
  have hk : ∀ i j : Fin 4, ∃ k, k≠i ∧ k≠j := by decide
  obtain ⟨k,hki,hkj⟩ := hk i j
  have hroot : (columns H z B (.inl v) ∩ columns H z B (.inr r)).Nonempty := by
    rw [← hi,← hj]; exact hp i j hij
  have hempty := mixed_properCommon_empty H z B h4 v.1 v.2 r.1 r.2 hroot
  have hmem : f k∈properCommon (columns H z B) (.inl v) (.inr r) := by
    rw [← hi,← hj]
    simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and]
    exact ⟨fun h => hki (hf h),fun h => hkj (hf h),
      hp i k hki.symm,hp j k hkj.symm,
      triple_empty _ hel hij hki.symm hkj.symm⟩
  rw [hempty] at hmem
  exact Finset.notMem_empty _ hmem

theorem same_sector (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (f : Fin 4 → Sum (U × G) (C × E)) (hf : Function.Injective f)
    (hd : ∀ i, (columns H z B (f i)).card=3)
    (hl : ∀ i j, i≠j → (columns H z B (f i) ∩ columns H z B (f j)).card≤1)
    (he : PaschClassification.EvenChecks (fun i => columns H z B (f i))) :
    (∀ i, ∃ v, f i=Sum.inl v) ∨ (∀ i, ∃ r, f i=Sum.inr r) := by
  cases h0 : f 0 with
  | inl v =>
    left
    intro i
    cases hi : f i with
    | inl w => exact ⟨w,rfl⟩
    | inr r => exact False.elim (no_mixed_pair H z B h4 f hf hd hl he 0 i v r h0 hi)
  | inr r =>
    right
    intro i
    cases hi : f i with
    | inr s => exact ⟨s,rfl⟩
    | inl v => exact False.elim (no_mixed_pair H z B h4 f hf hd hl he i 0 v r hi h0)

/-- Eliminating four-dependencies in both factors eliminates them in the full
scalar-right incidence. All hypotheses are on the actual factor columns. -/
theorem no_four_dependency (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (hleft : ∀ g : Fin 4 → U × G, Function.Injective g →
      ¬ PaschClassification.EvenChecks (fun i => PaschLiftProjection.columns H z (g i)))
    (hright : ∀ g : Fin 4 → E, Function.Injective g →
      ¬ PaschClassification.EvenChecks (fun i => B (g i)))
    (f : Fin 4 → Sum (U × G) (C × E)) (hf : Function.Injective f)
    (hd : ∀ i, (columns H z B (f i)).card=3)
    (hl : ∀ i j, i≠j → (columns H z B (f i) ∩ columns H z B (f j)).card≤1) :
    ¬ PaschClassification.EvenChecks (fun i => columns H z B (f i)) := by
  classical
  intro he
  rcases same_sector H z B h4 f hf hd hl he with hs | hs
  · choose g hg using hs
    have hg' : Function.Injective g := by
      intro i j hij
      apply hf
      rw [hg i,hg j,hij]
    apply hleft g hg'
    simpa only [hg,columns] using he
  · choose g hg using hs
    have hel := PaschClassification.even_checks_elementary _ hd hl he
    have hp := (elementary_pair_complete_iff _ hd hl hel).mpr he
    have hc : ∀ i, (g i).1=(g 0).1 := by
      intro i
      by_cases hi : i=0
      · rw [hi]
      · have ha := hp i 0 hi
        change (columns H z B (f i) ∩ columns H z B (f 0)).Nonempty at ha
        rw [hg i,hg 0] at ha
        exact ((right_right H z B (g i).1 (g 0).1 (g i).2 (g 0).2).mp ha).1
    have hgi : Function.Injective (fun i => (g i).2) := by
      intro i j hij
      apply hf
      rw [hg i,hg j]
      exact congrArg Sum.inr (Prod.ext ((hc i).trans (hc j).symm) hij)
    apply hright (fun i => (g i).2) hgi
    have hcol : (fun i => columns H z B (f i))=
        (fun i => {(g 0).1} ×ˢ B (g i).2) := by
      funext i
      rw [hg i]
      change {(g i).1} ×ˢ B (g i).2 = _
      rw [hc i]
    rw [hcol] at he
    intro t
    simpa only [support,Finset.mem_product,Finset.mem_singleton,Prod.fst,Prod.snd,
      and_true,true_and] using he ((g 0).1,t)

#print axioms no_mixed_pair
#print axioms same_sector
#print axioms no_four_dependency
end QCSectorElimination
