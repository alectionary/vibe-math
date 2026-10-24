import CyclicNormalization
import Mathlib.Tactic.Abel
set_option maxHeartbeats 0
namespace SocketCompletion
open CyclicNormalization
variable {P R G : Type*} [Fintype P] [Fintype R] [Fintype G]
    [DecidableEq P] [DecidableEq R] [DecidableEq G] [AddCommGroup G]

/-- Construction-only completion: enumerate variable types and pairs of their
occupied sockets, solving the fiber coordinate instead of enumerating it. -/
def completions (sockets : P → Finset (R × G)) (x y : R × G) : Finset (P × G) :=
  Finset.univ.biUnion (fun p =>
    (((sockets p) ×ˢ (sockets p)).filter (fun ef =>
      ef.1.1=x.1 ∧ ef.2.1=y.1 ∧ x.2-ef.1.2+ef.2.2=y.2)).image
      (fun ef => (p,x.2-ef.1.2)))

theorem mem_incidence (sockets : P → Finset (R × G)) (p : P) (t : G) (x : R × G) :
    x ∈ incidence sockets (p,t) ↔ (x.1,x.2-t) ∈ sockets p := by
  rcases x with ⟨r,a⟩
  constructor
  · intro hx
    obtain ⟨⟨s,e⟩,he,hx⟩ := Finset.mem_image.mp hx
    have hs : s=r := congrArg Prod.fst hx
    have ht : t+e=a := congrArg Prod.snd hx
    have heq : e=a-t := by rw [← ht]; abel
    simpa [hs,heq] using he
  · intro hx
    apply Finset.mem_image.mpr
    refine ⟨(r,a-t),hx,?_⟩
    simp [shift_apply,add_comm]

theorem completions_correct (sockets : P → Finset (R × G)) (x y : R × G) (w : P × G) :
    w ∈ completions sockets x y ↔ x ∈ incidence sockets w ∧ y ∈ incidence sockets w := by
  rcases w with ⟨p,t⟩
  constructor
  · intro hw
    obtain ⟨q,_,hwq⟩ := Finset.mem_biUnion.mp hw
    obtain ⟨ef,hef,heq⟩ := Finset.mem_image.mp hwq
    have hq : q=p := congrArg Prod.fst heq
    subst q
    have ht : x.2-ef.1.2=t := congrArg Prod.snd heq
    have hm := (Finset.mem_filter.mp hef)
    have hs := Finset.mem_product.mp hm.1
    rcases hm.2 with ⟨hr,hsr,hcoord⟩
    constructor
    · rw [mem_incidence]
      have he : x.2-t=ef.1.2 := by rw [← ht]; abel
      simpa [← hr,he] using hs.1
    · rw [mem_incidence]
      have he : y.2-t=ef.2.2 := by rw [← hcoord,ht]; abel
      simpa [← hsr,he] using hs.2
  · rintro ⟨hx,hy⟩
    rw [mem_incidence] at hx hy
    apply Finset.mem_biUnion.mpr
    refine ⟨p,Finset.mem_univ _,Finset.mem_image.mpr ?_⟩
    refine ⟨((x.1,x.2-t),(y.1,y.2-t)),Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨hx,hy⟩,?_⟩,?_⟩
    · refine ⟨rfl,rfl,?_⟩
      dsimp
      abel
    · dsimp
      congr 1
      abel

theorem completions_unique (sockets : P → Finset (R × G))
    (h4 : ∀ u v, u≠v → (incidence sockets u ∩ incidence sockets v).card ≤ 1)
    (x y : R × G) (hxy : x≠y) : (completions sockets x y).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro u hu v hv
  by_contra huv
  have hu' := (completions_correct sockets x y u).mp hu
  have hv' := (completions_correct sockets x y v).mp hv
  have hsub : ({x,y} : Finset (R × G)) ⊆ incidence sockets u ∩ incidence sockets v := by
    intro z hz
    simp only [Finset.mem_insert,Finset.mem_singleton] at hz
    rcases hz with rfl | rfl
    · exact Finset.mem_inter.mpr ⟨hu'.1,hv'.1⟩
    · exact Finset.mem_inter.mpr ⟨hu'.2,hv'.2⟩
  have hc := Finset.card_le_card hsub
  have hp : ({x,y} : Finset (R × G)).card=2 := by simp [hxy]
  have hm := h4 u v huv
  omega

#print axioms completions_correct
#print axioms completions_unique
end SocketCompletion
