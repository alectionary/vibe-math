import HGPIncidence
import CyclicNormalization
set_option maxHeartbeats 0
open scoped BigOperators
open PairFormula PairEnergy CyclicNormalization
namespace HGPPatterns
open HGPIncidence
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

theorem triple_left (H1 : U → Finset C) (H2 : E → Finset D) (u v w : U) (a b : D) :
    (columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inl (v,a)) ∩ columns H1 H2 (.inl (w,b))).Nonempty ↔
      a=b ∧ (H1 u ∩ H1 v ∩ H1 w).Nonempty := by
  constructor
  · rintro ⟨⟨c,t⟩,hc⟩
    have h : c ∈ H1 u ∧ c ∈ H1 v ∧ c ∈ H1 w ∧ t=a ∧ t=b := by
      simpa [columns,eq_comm,and_assoc,and_left_comm,and_comm] using hc
    exact ⟨h.2.2.2.1.symm.trans h.2.2.2.2,⟨c,by simp [h.1,h.2.1,h.2.2.1]⟩⟩
  · rintro ⟨rfl,c,hc⟩
    exact ⟨(c,a),by simpa [columns,eq_comm,and_assoc,and_left_comm,and_comm] using hc⟩

theorem triple_right (H1 : U → Finset C) (H2 : E → Finset D) (c d : C) (a b e : E) :
    (columns H1 H2 (.inr (c,a)) ∩ columns H1 H2 (.inr (c,b)) ∩ columns H1 H2 (.inr (d,e))).Nonempty ↔
      c=d ∧ (H2 a ∩ H2 b ∩ H2 e).Nonempty := by
  constructor
  · rintro ⟨⟨r,t⟩,hc⟩
    have h : r=c ∧ r=d ∧ t ∈ H2 a ∧ t ∈ H2 b ∧ t ∈ H2 e := by
      simpa [columns,eq_comm,and_assoc,and_left_comm,and_comm] using hc
    exact ⟨h.1.symm.trans h.2.1,⟨t,by simp [h.2.2.1,h.2.2.2.1,h.2.2.2.2]⟩⟩
  · rintro ⟨rfl,t,ht⟩
    exact ⟨(c,t),by simpa [columns,eq_comm,and_assoc,and_left_comm,and_comm] using ht⟩

theorem common_left (H1 : U → Finset C) (H2 : E → Finset D) (u v : U) (a : D) :
    properCommon (columns H1 H2) (.inl (u,a)) (.inl (v,a)) =
      (properCommon H1 u v).image (fun w => Sum.inl (w,a)) := by
  ext w
  cases w with
  | inl w =>
    rcases w with ⟨s,t⟩
    by_cases hat : a=t
    · subst t
      simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and,Finset.mem_image]
      simp only [left_left,triple_left]
      simp
    · simp [properCommon,Finset.mem_image,left_left,hat]
  | inr w =>
    rcases w with ⟨d,e⟩
    constructor
    · intro hw
      have h := (Finset.mem_filter.mp hw).2
      have hu := (left_right H1 H2 u a d e).mp h.2.2.1
      have hv := (left_right H1 H2 v a d e).mp h.2.2.2.1
      exact False.elim (h.2.2.2.2 ⟨(d,a),by simp [columns,hu.1,hu.2,hv.1]⟩)
    · intro hw
      obtain ⟨s,hs,he⟩ := Finset.mem_image.mp hw
      cases he

theorem common_right (H1 : U → Finset C) (H2 : E → Finset D) (c : C) (a b : E) :
    properCommon (columns H1 H2) (.inr (c,a)) (.inr (c,b)) =
      (properCommon H2 a b).image (fun w => Sum.inr (c,w)) := by
  ext w
  cases w with
  | inr w =>
    rcases w with ⟨d,e⟩
    by_cases hcd : c=d
    · subst d
      simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and,Finset.mem_image]
      simp only [right_right,triple_right]
      simp
    · simp [properCommon,Finset.mem_image,right_right,hcd]
  | inl w =>
    rcases w with ⟨u,t⟩
    constructor
    · intro hw
      have h := (Finset.mem_filter.mp hw).2
      have ha := (left_right H1 H2 u t c a).mp (by simpa only [Finset.inter_comm] using h.2.2.1)
      have hb := (left_right H1 H2 u t c b).mp (by simpa only [Finset.inter_comm] using h.2.2.2.1)
      exact False.elim (h.2.2.2.2 ⟨(c,t),by simp [columns,ha.1,ha.2,hb.2]⟩)
    · intro hw
      obtain ⟨s,hs,he⟩ := Finset.mem_image.mp hw
      cases he

section Image
variable {V' C' : Type*} [DecidableEq V'] [DecidableEq C']
theorem missing_card_image (H : U → Finset C) (H' : V' → Finset C')
    (f : U → V') (hi : Function.Injective f)
    (ha : ∀ u v, (H' (f u) ∩ H' (f v)).Nonempty ↔ (H u ∩ H v).Nonempty)
    (W : Finset U) :
    (missingPairs H' (W.image f)).card = (missingPairs H W).card := by
  symm
  apply Finset.card_bij (fun p _ => (f p.1,f p.2))
  · intro p hp
    simp only [missingPairs,Finset.mem_filter,Finset.mem_product] at hp
    obtain ⟨⟨hu,hv⟩,hne,hn⟩ := hp
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_product.mpr ⟨Finset.mem_image.mpr ⟨p.1,hu,rfl⟩,Finset.mem_image.mpr ⟨p.2,hv,rfl⟩⟩,?_,?_⟩
    · exact fun he => hne (hi he)
    · exact fun he => hn ((ha _ _).mp he)
  · intro x hx y hy he
    exact Prod.ext (hi (congrArg Prod.fst he)) (hi (congrArg Prod.snd he))
  · rintro ⟨x,y⟩ hp
    simp only [missingPairs,Finset.mem_filter,Finset.mem_product] at hp
    obtain ⟨⟨hx,hy⟩,hne,hn⟩ := hp
    obtain ⟨u,hu,rfl⟩ := Finset.mem_image.mp hx
    obtain ⟨v,hv,rfl⟩ := Finset.mem_image.mp hy
    refine ⟨(u,v),Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨hu,hv⟩,?_,?_⟩,rfl⟩
    · exact fun he => hne (congrArg f he)
    · exact fun he => hn ((ha _ _).mpr he)
end Image

theorem term_left (H1 : U → Finset C) (H2 : E → Finset D) (u v : U) (a b : D) :
    rootTerm (columns H1 H2) (.inl (u,a)) (.inl (v,b)) =
      if a=b then rootTerm H1 u v else 0 := by
  by_cases hab : a=b
  · subst b
    have hc : (missingPairs (columns H1 H2)
        (properCommon (columns H1 H2) (.inl (u,a)) (.inl (v,a)))).card =
        (missingPairs H1 (properCommon H1 u v)).card := by
      rw [common_left]
      apply missing_card_image H1 _ (fun w => Sum.inl (w,a))
      · intro s t he
        exact congrArg Prod.fst (Sum.inl.inj he)
      · intro s t
        simpa using left_left H1 H2 s t a a
    simp [rootTerm,left_left,hc]
  · simp [rootTerm,left_left,hab]

theorem term_right (H1 : U → Finset C) (H2 : E → Finset D) (c d : C) (a b : E) :
    rootTerm (columns H1 H2) (.inr (c,a)) (.inr (d,b)) =
      if c=d then rootTerm H2 a b else 0 := by
  by_cases hcd : c=d
  · subst d
    have hc : (missingPairs (columns H1 H2)
        (properCommon (columns H1 H2) (.inr (c,a)) (.inr (c,b)))).card =
        (missingPairs H2 (properCommon H2 a b)).card := by
      rw [common_right]
      apply missing_card_image H2 _ (fun w => Sum.inr (c,w))
      · intro s t he
        exact congrArg Prod.snd (Sum.inr.inj he)
      · intro s t
        simpa using right_right H1 H2 c c s t
    simp [rootTerm,right_right,hc]
  · simp [rootTerm,right_right,hcd]

theorem term_mixed (H1 : U → Finset C) (H2 : E → Finset D) (u : U) (a : D) (c : C) (b : E) :
    rootTerm (columns H1 H2) (.inl (u,a)) (.inr (c,b)) = 0 := by
  unfold rootTerm
  split_ifs with hc
  · rw [mixed_properCommon_empty H1 H2 u a c b hc.2]
    simp [missingPairs]
  · rfl

theorem term_comm {V' C' : Type*} [Fintype V'] [DecidableEq V'] [DecidableEq C']
    (H : V' → Finset C') (u v : V') : rootTerm H u v = rootTerm H v u := by
  have hw : properCommon H u v = properCommon H v u := by
    ext w
    simp [properCommon,Finset.inter_comm,and_comm,and_left_comm,and_assoc]
  simp [rootTerm,hw,Finset.inter_comm,ne_comm]

theorem root_mass_product (H1 : U → Finset C) (H2 : E → Finset D) :
    rootPairSum (columns H1 H2) = Fintype.card D * rootPairSum H1 +
      Fintype.card C * rootPairSum H2 := by
  have hm (c : C) (b : E) (u : U) (a : D) :
      rootTerm (columns H1 H2) (.inr (c,b)) (.inl (u,a)) = 0 := by
    rw [term_comm]
    exact term_mixed H1 H2 u a c b
  simp only [rootSum_univ,Fintype.sum_sum_type,Fintype.sum_prod_type]
  simp_rw [term_left,term_right,term_mixed,hm]
  simp [Finset.sum_add_distrib,Finset.mul_sum,Nat.mul_comm]

#print axioms common_left
#print axioms common_right
#print axioms root_mass_product
end HGPPatterns
