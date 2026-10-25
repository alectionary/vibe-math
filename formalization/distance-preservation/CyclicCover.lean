import CoverWeight
import SmallStopping
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace CyclicCover
variable {A B : Type*} [AddCommGroup A] [AddCommGroup B]
  [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]

abbrev Word (A : Type*) := Fin 4 × A → ZMod 2
def project (p : A →+ B) (v : Fin 4 × A) : Fin 4 × B := (v.1,p v.2)
def boundary (e : Fin 3 → Fin 4 → A) (x : Word A) (c : Fin 3 × A) : ZMod 2 :=
  ∑ j : Fin 4, x (j,c.2-e c.1 j)
def Kernel (e : Fin 3 → Fin 4 → A) (x : Word A) : Prop := ∀ c, boundary e x c = 0
def Adjacent (e : Fin 3 → Fin 4 → A) (v : Fin 4 × A) (c : Fin 3 × A) : Prop :=
  c.2 = v.2 + e c.1 v.1
instance (e : Fin 3 → Fin 4 → A) : DecidableRel (Adjacent e) :=
  fun _ _ => inferInstanceAs (Decidable (_ = _))

lemma push_apply (p : A →+ B) (x : Word A) (j : Fin 4) (t : B) :
    CoverWeight.push (project p) x (j,t) = ∑ s, if p s = t then x (j,s) else 0 := by
  unfold CoverWeight.push
  rw [Fintype.sum_prod_type]
  fin_cases j <;> simp [project,Fin.sum_univ_succ,Prod.mk.injEq]

lemma fiber_shift (p : A →+ B) (f : A → ZMod 2) (t : B) (e : A) :
    (∑ s, if p s = t-p e then f s else 0) =
    ∑ s, if p s = t then f (s-e) else 0 := by
  symm
  apply Fintype.sum_equiv (Equiv.subRight e) _ _
  intro s
  simp only [Equiv.subRight_apply,map_sub,sub_left_inj]

theorem boundary_push (p : A →+ B) (e : Fin 3 → Fin 4 → A) (x : Word A) (c : Fin 3 × B) :
    boundary (fun i j => p (e i j)) (CoverWeight.push (project p) x) c =
    ∑ s, if p s = c.2 then boundary e x (c.1,s) else 0 := by
  unfold boundary
  simp_rw [push_apply,fiber_shift]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro s hs
  by_cases h : p s = c.2 <;> simp [h]

theorem kernel_push (p : A →+ B) (e : Fin 3 → Fin 4 → A) (x : Word A) (hx : Kernel e x) :
    Kernel (fun i j => p (e i j)) (CoverWeight.push (project p) x) := by
  intro c
  rw [boundary_push]
  have hh : ∀ c, boundary e x c = 0 := hx
  simp only [hh,ite_self,Finset.sum_const_zero]

theorem stopping_of_partners {V C : Type*} [DecidableEq V] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E] (T : Finset V) (hne : T.Nonempty)
    (hp : ∀ v ∈ T, ∀ c, E v c → ∃ w ∈ T, w ≠ v ∧ E w c) : SmallStopping.Stopping E T := by
  refine ⟨hne,?_⟩
  intro c hc
  obtain ⟨v,hv⟩ := Finset.card_eq_one.mp hc
  have hv0 : v ∈ T.filter (fun z => E z c) := by
    rw [hv]
    exact Finset.mem_singleton_self v
  have hv' : v ∈ T ∧ E v c := Finset.mem_filter.mp hv0
  obtain ⟨w,hw,hne,hE⟩ := hp v hv'.1 c hv'.2
  have hm : w ∈ T.filter (fun z => E z c) := Finset.mem_filter.mpr ⟨hw,hE⟩
  rw [hv] at hm
  exact hne (Finset.mem_singleton.mp hm)

/-- Projected support is stopping even when its binary projection cancels. -/
theorem projected_support_stopping (p : A →+ B) (e : Fin 3 → Fin 4 → A)
    (x : Word A) (hx : Kernel e x) (hn : x ≠ 0) :
    SmallStopping.Stopping (Adjacent (fun i j => p (e i j)))
      ((CoverWeight.support x).image (project p)) := by
  have hs : (CoverWeight.support x).Nonempty := by
    by_contra h
    apply hn
    funext v
    by_contra hv
    change x v ≠ 0 at hv
    exact h ⟨v,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hv⟩⟩
  apply stopping_of_partners _ _ (hs.image _)
  intro v hv c hc
  obtain ⟨w,hw,rfl⟩ := Finset.mem_image.mp hv
  have hwnz : x w ≠ 0 := (Finset.mem_filter.mp hw).2
  let d : Fin 3 × A := (c.1,w.2+e c.1 w.1)
  have hk : ∃ k : Fin 4, k ≠ w.1 ∧ x (k,d.2-e c.1 k) ≠ 0 := by
    by_contra h
    push Not at h
    have he : boundary e x d = x w := by
      unfold boundary
      rw [Finset.sum_eq_single w.1]
      · simp [d]
      · intro k hk hne
        exact h k hne
      · simp
    exact hwnz (he.symm.trans (hx d))
  obtain ⟨k,hkw,hkx⟩ := hk
  refine ⟨project p (k,d.2-e c.1 k),Finset.mem_image.mpr ⟨_,by simp [CoverWeight.support,hkx],rfl⟩,?_,?_⟩
  · intro h
    exact hkw (congrArg Prod.fst h)
  · simpa [Adjacent,project,d,map_sub,map_add] using hc

#print axioms kernel_push
#print axioms projected_support_stopping
end CyclicCover
