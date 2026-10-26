import SupportPairs
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {A : Type*} [DecidableEq A]

theorem four_point_binary_matching (a₀ a₁ b₀ b₁ : A)
    (ha : a₀≠a₁) (hb : b₀≠b₁)
    (h : ∀ z,((if z=a₀ then 1 else 0)+(if z=a₁ then 1 else 0)+
      (if z=b₀ then 1 else 0)+(if z=b₁ then 1 else 0) : ZMod 2)=0) :
    (a₀=b₀ ∧ a₁=b₁) ∨ (a₀=b₁ ∧ a₁=b₀) := by
  by_cases h00 : a₀=b₀
  · left
    refine ⟨h00,?_⟩
    have h10 : a₁≠b₀ := fun he => ha (h00.trans he.symm)
    by_contra hn
    have ht := h a₁
    simp [ha.symm,h10,hn] at ht
  · right
    have h01 : a₀=b₁ := by
      by_contra hn
      have ht := h a₀
      simp [ha,h00,hn] at ht
    refine ⟨h01,?_⟩
    have h11 : a₁≠b₁ := fun he => ha (h01.trans he.symm)
    by_contra hn
    have ht := h a₁
    simp [ha.symm,hn,h11] at ht

theorem pair_indicator_add {B : Type*} [DecidableEq B]
    (a b k : A) (hab : a≠b) (s z : B) :
    (if (k=a ∨ k=b) ∧ z=s then (1 : ZMod 2) else 0)=
      (if k=a ∧ z=s then 1 else 0)+(if k=b ∧ z=s then 1 else 0) := by
  by_cases hka : k=a <;> by_cases hkb : k=b <;> by_cases hzs : z=s <;> simp_all

variable {L : ℕ} [NeZero L]

theorem source_left_pair_action (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (j a b : Fin 4) (i : Fin 3) (s z : ZMod L) (hab : a≠b)
    (hu : ∀ k t,u j k t=if (k=a ∨ k=b) ∧ t=s then 1 else 0) :
    (∑ k : Fin 4,u j k (z-e i k))=
      (if z=s+e i a then 1 else 0)+(if z=s+e i b then 1 else 0) := by
  simp_rw [hu,pair_indicator_add a b _ hab]
  rw [Finset.sum_add_distrib]
  simp [ite_and,sub_eq_iff_eq_add]

theorem source_right_pair_action (e : Fin 3 → Fin 4 → ZMod L)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (i a b : Fin 3) (j : Fin 4) (s z : ZMod L) (hab : a≠b)
    (hv : ∀ l t,v l i t=if (l=a ∨ l=b) ∧ t=s then 1 else 0) :
    (∑ l : Fin 3,v l i (z+e l j))=
      (if z=s-e a j then 1 else 0)+(if z=s-e b j then 1 else 0) := by
  simp_rw [hv,pair_indicator_add a b _ hab]
  rw [Finset.sum_add_distrib]
  simp [ite_and,eq_sub_iff_add_eq]

theorem source_pair_cross_matching (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e))
    (hR0 : ∀ k,e 0 k=0) (hC0 : ∀ l,e l 0=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (j : Fin 4) (hj : j≠0) (i : Fin 3) (hi : i≠0)
    (a b : Fin 4) (hab : a≠b) (l m : Fin 3) (hlm : l≠m)
    (s t : ZMod L)
    (hu : ∀ k z,u j k z=if (k=a ∨ k=b) ∧ z=s then 1 else 0)
    (hv : ∀ k z,v k i z=if (k=l ∨ k=m) ∧ z=t then 1 else 0) :
    ((s+e i a=t-e l j) ∧ (s+e i b=t-e m j)) ∨
      ((s+e i a=t-e m j) ∧ (s+e i b=t-e l j)) := by
  have hA : s+e i a≠s+e i b := by
    intro he
    apply hab
    apply row_differences_injective e h4 i 0 hi
    simpa only [hR0,sub_zero] using add_left_cancel he
  have hB : t-e l j≠t-e m j := by
    intro he
    apply hlm
    apply column_differences_injective e h4 j 0 hj
    simp only [hC0,sub_zero]
    linear_combination -he
  apply four_point_binary_matching _ _ _ _ hA hB
  intro z
  have hsy := (GeneralLP.z_action e u v j i z).symm.trans (hk ((j,i),z))
  change (∑ k : Fin 4,u j k (z-e i k))+(∑ l : Fin 3,v l i (z+e l j))=0 at hsy
  rw [source_left_pair_action e u j a b i s z hab hu,
    source_right_pair_action e v i l m j t z hlm hv] at hsy
  simpa only [add_assoc] using hsy

#print axioms source_pair_cross_matching
end TruncatedDistance
