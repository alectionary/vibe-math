import PaschGlobalCount
import CyclicNormalization

set_option maxHeartbeats 0
open scoped BigOperators
open PaschKernelCount PairFormula PaschRootEnergy PaschGlobalCount CyclicNormalization
namespace PaschCyclicCount
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def rootTerm40 (H : V → Finset C) (u v : V) : ℕ :=
  if u ≠ v ∧ (H u ∩ H v).Nonempty then (localPaschPairs H u v).card else 0

theorem rootSum40_univ (H : V → Finset C) :
    rootSum40 H = ∑ u : V, ∑ v : V, rootTerm40 H u v := by
  simp only [rootSum40,centralPairs,Finset.sum_filter,Finset.sum_product,rootTerm40]

theorem rootTerm40_equiv (H : V → Finset C) (e : V ≃ V) (f : C ≃ C)
    (hH : ∀ v, H (e v) = (H v).image f) (u v : V) :
    rootTerm40 H (e u) (e v) = rootTerm40 H u v := by
  have hp : ∀ x y, (H (e x) ∩ H (e y)).Nonempty ↔ (H x ∩ H y).Nonempty := by
    intro x y
    rw [hH,hH,← Finset.image_inter _ _ f.injective]
    exact Finset.image_nonempty
  have ht : ∀ x y z, (H (e x) ∩ H (e y) ∩ H (e z)).Nonempty ↔
      (H x ∩ H y ∩ H z).Nonempty := by
    intro x y z
    rw [hH,hH,hH,← Finset.image_inter _ _ f.injective,
      ← Finset.image_inter _ _ f.injective]
    exact Finset.image_nonempty
  have hw : ∀ w, e w ∈ properCommon H (e u) (e v) ↔ w ∈ properCommon H u v := by
    intro w
    simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and,e.injective.ne_iff,hp,ht]
  have hout : ∀ w, outsideCols H (H (e u) ∪ H (e v)) (e w) =
      (outsideCols H (H u ∪ H v) w).image f := by
    intro w
    unfold outsideCols
    rw [hH,hH,hH,← Finset.image_union,← Finset.image_sdiff _ _ f.injective]
  have ho : ∀ w z,
      (outsideCols H (H (e u) ∪ H (e v)) (e w) ∩
       outsideCols H (H (e u) ∪ H (e v)) (e z)).Nonempty ↔
      (outsideCols H (H u ∪ H v) w ∩ outsideCols H (H u ∪ H v) z).Nonempty := by
    intro w z
    rw [hout,hout,← Finset.image_inter _ _ f.injective]
    exact Finset.image_nonempty
  have hm : ∀ x : V × V, (e x.1,e x.2) ∈ localPaschPairs H (e u) (e v) ↔
      x ∈ localPaschPairs H u v := by
    intro x
    simp only [localPaschPairs,PairEnergy.adjacentPairs,Finset.mem_filter,
      Finset.mem_product,hw,e.injective.ne_iff,ho]
  have hc : (localPaschPairs H u v).card = (localPaschPairs H (e u) (e v)).card := by
    apply Finset.card_bij (fun x _ => (e x.1,e x.2))
    · intro x hx; exact (hm x).mpr hx
    · intro x hx y hy hxy
      exact Prod.ext (e.injective (congrArg Prod.fst hxy)) (e.injective (congrArg Prod.snd hxy))
    · intro y hy
      refine ⟨(e.symm y.1,e.symm y.2),?_,?_⟩
      · apply (hm _).mp; simpa using hy
      · simp
  simp only [rootTerm40,e.injective.ne_iff,hp]
  rw [hc]

section Cyclic
variable {P R G : Type*} [Fintype P] [Fintype R] [Fintype G]
    [DecidableEq P] [DecidableEq R] [DecidableEq G] [AddCommGroup G]

theorem rootTerm40_shift (sockets : P → Finset (R × G)) (g : G) (u v : P × G) :
    rootTerm40 (incidence sockets) (shift P g u) (shift P g v) =
      rootTerm40 (incidence sockets) u v :=
  rootTerm40_equiv _ (shift P g) (shift R g) (incidence_shift sockets g) u v

theorem rootTerm40_normalize (sockets : P → Finset (R × G)) (p q : P) (a b : G) :
    rootTerm40 (incidence sockets) (p,a) (q,b) =
      rootTerm40 (incidence sockets) (p,0) (q,-a+b) := by
  have h := rootTerm40_shift sockets (-a) (p,a) (q,b)
  simpa using h.symm

def normalized40 (sockets : P → Finset (R × G)) : ℕ :=
  ∑ p : P, ∑ q : P, ∑ d : G, rootTerm40 (incidence sockets) (p,0) (q,d)

theorem rootSum40_normalization (sockets : P → Finset (R × G)) :
    rootSum40 (incidence sockets) = Fintype.card G * normalized40 sockets := by
  rw [rootSum40_univ]
  simp only [Fintype.sum_prod_type]
  have hn : (∑ p : P, ∑ a : G, ∑ q : P, ∑ b : G,
      rootTerm40 (incidence sockets) (p,a) (q,b)) =
      ∑ p : P, ∑ a : G, ∑ q : P, ∑ b : G,
        rootTerm40 (incidence sockets) (p,0) (q,-a+b) := by
    apply Finset.sum_congr rfl
    intro p hp
    apply Finset.sum_congr rfl
    intro a ha
    apply Finset.sum_congr rfl
    intro q hq
    apply Finset.sum_congr rfl
    intro b hb
    exact rootTerm40_normalize sockets p q a b
  rw [hn]
  have hi : ∀ p a q, (∑ b : G, rootTerm40 (incidence sockets) (p,0) (q,-a+b)) =
      ∑ d : G, rootTerm40 (incidence sockets) (p,0) (q,d) := by
    intro p a q
    let e : G ≃ G :=
      { toFun := fun b => -a+b
        invFun := fun d => a+d
        left_inv := by intro b; simp
        right_inv := by intro d; simp }
    exact Equiv.sum_comp e (fun d : G => rootTerm40 (incidence sockets) (p,0) (q,d))
  simp_rw [hi]
  simp [normalized40,Finset.mul_sum,Nat.mul_comm]

theorem cyclic_count40_identity (sockets : P → Finset (R × G))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    24 * count40 (incidence sockets) = Fintype.card G * normalized40 sockets := by
  rw [← rootSum40_eq _ hd h4]
  exact rootSum40_normalization sockets

def correctionTerm40 (H : V → Finset C) (u v : V) : ℕ :=
  if u ≠ v ∧ (H u ∩ H v).Nonempty then
    rootCheckEnergy H (properCommon H u v) (H u ∪ H v) + (properCommon H u v).card else 0

def normalizedCorrection40 (sockets : P → Finset (R × G)) : ℕ :=
  ∑ p : P, ∑ q : P, ∑ d : G, correctionTerm40 (incidence sockets) (p,0) (q,d)

theorem rootTerm40_add_correction (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (u v : V) :
    rootTerm40 H u v + correctionTerm40 H u v = energyTerm H u v := by
  unfold rootTerm40 correctionTerm40 energyTerm
  split_ifs
  · rw [local_energy_identity H hd h4]
    omega
  · rfl

/-- Cyclic count with a normalization that remains valid for periodic supports. -/
theorem cyclic_corrected_count40_identity (sockets : P → Finset (R × G))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    24 * count40 (incidence sockets) + Fintype.card G * normalizedCorrection40 sockets =
      Fintype.card G * normalizedEnergy sockets := by
  rw [cyclic_count40_identity sockets hd h4,← Nat.mul_add]
  congr 1
  unfold normalized40 normalizedCorrection40 normalizedEnergy
  simp_rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro q hq
  apply Finset.sum_congr rfl
  intro d hdmem
  exact rootTerm40_add_correction _ hd h4 _ _

#print axioms cyclic_count40_identity
#print axioms cyclic_corrected_count40_identity
end Cyclic
end PaschCyclicCount
