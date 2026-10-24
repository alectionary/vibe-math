import PaschCyclicCount
import HGPCounts

set_option maxHeartbeats 0
open scoped BigOperators
namespace PaschHGPCount
open PaschKernelCount PaschGlobalCount PaschRootEnergy PaschCyclicCount
open PairFormula PairEnergy HGPIncidence HGPPatterns
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

section Image
variable {V' C' : Type*} [DecidableEq V'] [DecidableEq C']
theorem adjacent_card_image (H : U → Finset C) (H' : V' → Finset C')
    (f : U → V') (hi : Function.Injective f)
    (ha : ∀ u v, (H' (f u) ∩ H' (f v)).Nonempty ↔ (H u ∩ H v).Nonempty)
    (W : Finset U) :
    (adjacentPairs H' (W.image f)).card = (adjacentPairs H W).card := by
  symm
  apply Finset.card_bij (fun p _ => (f p.1,f p.2))
  · intro p hp
    simp only [adjacentPairs,Finset.mem_filter,Finset.mem_product] at hp
    obtain ⟨⟨hu,hv⟩,hne,hn⟩ := hp
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_product.mpr ⟨Finset.mem_image.mpr ⟨p.1,hu,rfl⟩,
      Finset.mem_image.mpr ⟨p.2,hv,rfl⟩⟩,?_,(ha _ _).mpr hn⟩
    exact fun he => hne (hi he)
  · intro x hx y hy he
    exact Prod.ext (hi (congrArg Prod.fst he)) (hi (congrArg Prod.snd he))
  · rintro ⟨x,y⟩ hp
    simp only [adjacentPairs,Finset.mem_filter,Finset.mem_product] at hp
    obtain ⟨⟨hx,hy⟩,hne,hn⟩ := hp
    obtain ⟨u,hu,rfl⟩ := Finset.mem_image.mp hx
    obtain ⟨v,hv,rfl⟩ := Finset.mem_image.mp hy
    refine ⟨(u,v),Finset.mem_filter.mpr
      ⟨Finset.mem_product.mpr ⟨hu,hv⟩,?_,(ha _ _).mp hn⟩,rfl⟩
    exact fun he => hne (congrArg f he)
end Image

theorem outside_left (H1 : U → Finset C) (H2 : E → Finset D)
    (u v w : U) (a : D) :
    outsideCols (columns H1 H2)
      (columns H1 H2 (.inl (u,a)) ∪ columns H1 H2 (.inl (v,a))) (.inl (w,a)) =
      (outsideCols H1 (H1 u ∪ H1 v) w) ×ˢ {a} := by
  ext x
  rcases x with ⟨c,t⟩
  simp only [outsideCols,columns,Finset.mem_sdiff,Finset.mem_union,
    Finset.mem_product,Finset.mem_singleton]
  tauto

theorem outside_right (H1 : U → Finset C) (H2 : E → Finset D)
    (c : C) (a b w : E) :
    outsideCols (columns H1 H2)
      (columns H1 H2 (.inr (c,a)) ∪ columns H1 H2 (.inr (c,b))) (.inr (c,w)) =
      {c} ×ˢ (outsideCols H2 (H2 a ∪ H2 b) w) := by
  ext x
  rcases x with ⟨d,t⟩
  simp only [outsideCols,columns,Finset.mem_sdiff,Finset.mem_union,
    Finset.mem_product,Finset.mem_singleton]
  tauto

theorem term_left40 (H1 : U → Finset C) (H2 : E → Finset D) (u v : U) (a b : D) :
    rootTerm40 (columns H1 H2) (.inl (u,a)) (.inl (v,b)) =
      if a=b then rootTerm40 H1 u v else 0 := by
  by_cases hab : a=b
  · subst b
    have hc : (localPaschPairs (columns H1 H2) (.inl (u,a)) (.inl (v,a))).card =
        (localPaschPairs H1 u v).card := by
      unfold localPaschPairs
      rw [common_left]
      apply adjacent_card_image _ _ (fun w => Sum.inl (w,a))
      · intro s t he; exact congrArg Prod.fst (Sum.inl.inj he)
      · intro s t
        rw [outside_left,outside_left,← Finset.inter_product]
        simp
    simp [rootTerm40,left_left,hc]
  · simp [rootTerm40,left_left,hab]

theorem term_right40 (H1 : U → Finset C) (H2 : E → Finset D) (c d : C) (a b : E) :
    rootTerm40 (columns H1 H2) (.inr (c,a)) (.inr (d,b)) =
      if c=d then rootTerm40 H2 a b else 0 := by
  by_cases hcd : c=d
  · subst d
    have hc : (localPaschPairs (columns H1 H2) (.inr (c,a)) (.inr (c,b))).card =
        (localPaschPairs H2 a b).card := by
      unfold localPaschPairs
      rw [common_right]
      apply adjacent_card_image _ _ (fun w => Sum.inr (c,w))
      · intro s t he; exact congrArg Prod.snd (Sum.inr.inj he)
      · intro s t
        rw [outside_right,outside_right,← Finset.product_inter]
        simp
    simp [rootTerm40,right_right,hc]
  · simp [rootTerm40,right_right,hcd]

theorem term_mixed40 (H1 : U → Finset C) (H2 : E → Finset D) (u : U) (a : D) (c : C) (b : E) :
    rootTerm40 (columns H1 H2) (.inl (u,a)) (.inr (c,b)) = 0 := by
  unfold rootTerm40
  split_ifs with hc
  · unfold localPaschPairs
    rw [mixed_properCommon_empty H1 H2 u a c b hc.2]
    simp [adjacentPairs]
  · rfl

theorem term40_comm {V' C' : Type*} [Fintype V'] [DecidableEq V'] [DecidableEq C']
    (H : V' → Finset C') (u v : V') : rootTerm40 H u v = rootTerm40 H v u := by
  have hw : properCommon H u v = properCommon H v u := by
    ext w
    simp [properCommon,Finset.inter_comm,and_comm,and_left_comm,and_assoc]
  simp [rootTerm40,localPaschPairs,hw,Finset.inter_comm,Finset.union_comm,ne_comm]

theorem root_mass40_product (H1 : U → Finset C) (H2 : E → Finset D) :
    rootSum40 (columns H1 H2) = Fintype.card D * rootSum40 H1 +
      Fintype.card C * rootSum40 H2 := by
  have hm (c : C) (b : E) (u : U) (a : D) :
      rootTerm40 (columns H1 H2) (.inr (c,b)) (.inl (u,a)) = 0 := by
    rw [term40_comm]
    exact term_mixed40 H1 H2 u a c b
  simp only [rootSum40_univ,Fintype.sum_sum_type,Fintype.sum_prod_type]
  simp_rw [term_left40,term_right40,term_mixed40,hm]
  simp [Finset.sum_add_distrib,Finset.mul_sum,Nat.mul_comm]

/-- Every Pasch lies in one factor fiber. Mixed-sector six-cycles are excluded
by the actual product incidence, with no appeal to a projected graph alone. -/
theorem count40_product (H1 : U → Finset C) (H2 : E → Finset D)
    (hd1 : ∀ u, (H1 u).card=3) (hd2 : ∀ a, (H2 a).card=3)
    (h41 : ∀ u v, u≠v → (H1 u ∩ H1 v).card ≤ 1)
    (h42 : ∀ a b, a≠b → (H2 a ∩ H2 b).card ≤ 1) :
    count40 (columns H1 H2) = Fintype.card D * count40 H1 + Fintype.card C * count40 H2 := by
  have h := root_mass40_product H1 H2
  rw [rootSum40_eq _ (HGPCounts.cubic H1 H2 hd1 hd2) (HGPCounts.linear H1 H2 h41 h42),
    rootSum40_eq _ hd1 h41,rootSum40_eq _ hd2 h42] at h
  apply Nat.eq_of_mul_eq_mul_left (by decide : 0<24)
  calc
    24 * count40 (columns H1 H2) = _ := h
    _ = 24 * (Fintype.card D * count40 H1 + Fintype.card C * count40 H2) := by ring

#print axioms count40_product
#print axioms root_mass40_product
end PaschHGPCount
