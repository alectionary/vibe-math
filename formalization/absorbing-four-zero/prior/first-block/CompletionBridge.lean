import SocketCompletion
set_option maxHeartbeats 0
namespace CompletionBridge
open PairFormula CyclicNormalization SocketCompletion
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

theorem properCommon_iff_exclusive (H : V → Finset C)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card ≤ 1) (u v w : V) :
    w ∈ properCommon H u v ↔ ∃ x ∈ H u \ H v, ∃ y ∈ H v \ H u, x ∈ H w ∧ y ∈ H w := by
  constructor
  · intro hw
    have hp := (Finset.mem_filter.mp hw).2
    obtain ⟨x,hx⟩ := hp.2.2.1
    obtain ⟨y,hy⟩ := hp.2.2.2.1
    have hx' := Finset.mem_inter.mp hx
    have hy' := Finset.mem_inter.mp hy
    have hxn : x ∉ H v := by
      intro hxv
      exact hp.2.2.2.2 ⟨x,Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨hx'.1,hxv⟩,hx'.2⟩⟩
    have hyn : y ∉ H u := by
      intro hyu
      exact hp.2.2.2.2 ⟨y,Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨hyu,hy'.1⟩,hy'.2⟩⟩
    exact ⟨x,Finset.mem_sdiff.mpr ⟨hx'.1,hxn⟩,y,Finset.mem_sdiff.mpr ⟨hy'.1,hyn⟩,hx'.2,hy'.2⟩
  · rintro ⟨x,hx,y,hy,hxw,hyw⟩
    have hx' := Finset.mem_sdiff.mp hx
    have hy' := Finset.mem_sdiff.mp hy
    have hwu : w≠u := by intro h; subst w; exact hy'.2 hyw
    have hwv : w≠v := by intro h; subst w; exact hx'.2 hxw
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _,hwu,hwv,⟨x,Finset.mem_inter.mpr ⟨hx'.1,hxw⟩⟩,
      ⟨y,Finset.mem_inter.mpr ⟨hy'.1,hyw⟩⟩,?_⟩
    rintro ⟨c,hc⟩
    have hc' := Finset.mem_inter.mp hc
    have hcu := (Finset.mem_inter.mp hc'.1).1
    have hcv := (Finset.mem_inter.mp hc'.1).2
    have hxc : x≠c := by intro he; exact hx'.2 (he ▸ hcv)
    have hsub : ({x,c} : Finset C) ⊆ H u ∩ H w := by
      intro z hz
      simp only [Finset.mem_insert,Finset.mem_singleton] at hz
      rcases hz with rfl | rfl
      · exact Finset.mem_inter.mpr ⟨hx'.1,hxw⟩
      · exact Finset.mem_inter.mpr ⟨hcu,hc'.2⟩
    have hb := Finset.card_le_card hsub
    have hp : ({x,c} : Finset C).card=2 := by simp [hxc]
    have hm := h4 u w (Ne.symm hwu)
    omega

section Socket
variable {P R G : Type*} [Fintype P] [Fintype R] [Fintype G]
    [DecidableEq P] [DecidableEq R] [DecidableEq G] [AddCommGroup G]

def candidates (sockets : P → Finset (R × G)) (u v : P × G) : Finset (P × G) :=
  (incidence sockets u \ incidence sockets v).biUnion (fun x =>
    (incidence sockets v \ incidence sockets u).biUnion (fun y => completions sockets x y))

theorem candidates_eq_properCommon (sockets : P → Finset (R × G))
    (h4 : ∀ u v, u≠v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) (u v : P × G) :
    candidates sockets u v = properCommon (incidence sockets) u v := by
  ext w
  rw [properCommon_iff_exclusive _ h4]
  simp only [candidates,Finset.mem_biUnion,completions_correct]

#print axioms candidates_eq_properCommon
end Socket
end CompletionBridge
