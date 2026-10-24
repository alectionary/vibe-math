import PairRootBridge
import Mathlib.Algebra.Group.Basic

set_option maxHeartbeats 0
open scoped BigOperators
open PairFormula

namespace CyclicNormalization

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def rootTerm (H : V → Finset C) (u v : V) : ℕ :=
  if u ≠ v ∧ (H u ∩ H v).Nonempty then
    (PairEnergy.missingPairs H (properCommon H u v)).card else 0

theorem rootSum_univ (H : V → Finset C) :
    rootPairSum H = ∑ u : V, ∑ v : V, rootTerm H u v := by
  simp only [rootPairSum, centralPairs, Finset.sum_filter, Finset.sum_product, rootTerm]

theorem rootTerm_equiv (H : V → Finset C) (e : V ≃ V)
    (hp : ∀ u v, (H (e u) ∩ H (e v)).Nonempty ↔ (H u ∩ H v).Nonempty)
    (ht : ∀ u v w, (H (e u) ∩ H (e v) ∩ H (e w)).Nonempty ↔
       (H u ∩ H v ∩ H w).Nonempty) (u v : V) :
    rootTerm H (e u) (e v) = rootTerm H u v := by
  have hw : ∀ w, e w ∈ properCommon H (e u) (e v) ↔ w ∈ properCommon H u v := by
    intro w
    simp only [properCommon, Finset.mem_filter, Finset.mem_univ, true_and,
      e.injective.ne_iff, hp, ht]
  have hm : ∀ x : V × V,
      (e x.1,e x.2) ∈ PairEnergy.missingPairs H (properCommon H (e u) (e v)) ↔
      x ∈ PairEnergy.missingPairs H (properCommon H u v) := by
    intro x
    simp only [PairEnergy.missingPairs, Finset.mem_filter, Finset.mem_product,
      hw, e.injective.ne_iff, hp]
  have hc : (PairEnergy.missingPairs H (properCommon H u v)).card =
      (PairEnergy.missingPairs H (properCommon H (e u) (e v))).card := by
    apply Finset.card_bij (fun x _ => (e x.1,e x.2))
    · intro x hx
      exact (hm x).mpr hx
    · intro x hx y hy hxy
      exact Prod.ext (e.injective (congrArg Prod.fst hxy))
        (e.injective (congrArg Prod.snd hxy))
    · intro y hy
      refine ⟨(e.symm y.1,e.symm y.2), ?_, ?_⟩
      · apply (hm _).mp
        simpa using hy
      · simp
  simp only [rootTerm,e.injective.ne_iff,hp]
  rw [hc]

section Cyclic
variable {P R G : Type*} [Fintype P] [Fintype R] [Fintype G]
    [DecidableEq P] [DecidableEq R] [DecidableEq G] [AddCommGroup G]

def shift (T : Type*) (g : G) : T × G ≃ T × G where
  toFun x := (x.1,g+x.2)
  invFun x := (x.1,-g+x.2)
  left_inv x := by simp
  right_inv x := by simp

@[simp] theorem shift_apply (T : Type*) (g : G) (x : T × G) :
    shift T g x = (x.1,g+x.2) := rfl

def incidence (sockets : P → Finset (R × G)) (v : P × G) : Finset (R × G) :=
  (sockets v.1).image (shift R v.2)

theorem incidence_shift (sockets : P → Finset (R × G)) (g : G) (v : P × G) :
    incidence sockets (shift P g v) = (incidence sockets v).image (shift R g) := by
  simp only [incidence,shift_apply,Finset.image_image]
  congr 1
  funext x
  simp [Function.comp_def,add_assoc]

theorem rootTerm_shift (sockets : P → Finset (R × G)) (g : G) (u v : P × G) :
    rootTerm (incidence sockets) (shift P g u) (shift P g v) =
      rootTerm (incidence sockets) u v := by
  apply rootTerm_equiv _ (shift P g)
  · intro x y
    rw [incidence_shift,incidence_shift, ← Finset.image_inter _ _ (shift R g).injective]
    exact Finset.image_nonempty
  · intro x y z
    rw [incidence_shift,incidence_shift,incidence_shift,
      ← Finset.image_inter _ _ (shift R g).injective,
      ← Finset.image_inter _ _ (shift R g).injective]
    exact Finset.image_nonempty

theorem rootTerm_normalize (sockets : P → Finset (R × G)) (p q : P) (a b : G) :
    rootTerm (incidence sockets) (p,a) (q,b) =
      rootTerm (incidence sockets) (p,0) (q,-a+b) := by
  have h := rootTerm_shift sockets (-a) (p,a) (q,b)
  simpa using h.symm

def normalizedSum (sockets : P → Finset (R × G)) : ℕ :=
  ∑ p : P, ∑ q : P, ∑ d : G, rootTerm (incidence sockets) (p,0) (q,d)

theorem rootSum_eq_card_mul_normalized (sockets : P → Finset (R × G)) :
    rootPairSum (incidence sockets) = Fintype.card G * normalizedSum sockets := by
  rw [rootSum_univ]
  simp only [Fintype.sum_prod_type]
  have hn : (∑ p : P, ∑ a : G, ∑ q : P, ∑ b : G,
      rootTerm (incidence sockets) (p,a) (q,b)) =
      ∑ p : P, ∑ a : G, ∑ q : P, ∑ b : G,
        rootTerm (incidence sockets) (p,0) (q,-a+b) := by
    apply Finset.sum_congr rfl
    intro p hp
    apply Finset.sum_congr rfl
    intro a ha
    apply Finset.sum_congr rfl
    intro q hq
    apply Finset.sum_congr rfl
    intro b hb
    exact rootTerm_normalize sockets p q a b
  rw [hn]
  have hi : ∀ p a q, (∑ b : G, rootTerm (incidence sockets) (p,0) (q,-a+b)) =
      ∑ d : G, rootTerm (incidence sockets) (p,0) (q,d) := by
    intro p a q
    let e : G ≃ G :=
      { toFun := fun b => -a+b
        invFun := fun d => a+d
        left_inv := by intro b; simp
        right_inv := by intro d; simp }
    exact Equiv.sum_comp e (fun d : G => rootTerm (incidence sockets) (p,0) (q,d))
  simp_rw [hi]
  simp [normalizedSum, Finset.mul_sum, Nat.mul_comm]

theorem cyclic_count_identity (sockets : P → Finset (R × G))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    4 * GlobalCounting.count42 (incidence sockets) =
      Fintype.card G * normalizedSum sockets := by
  rw [← PairRootBridge.rootPairSum_eq_four_count42 _ hd h4]
  exact rootSum_eq_card_mul_normalized sockets

def energyTerm (H : V → Finset C) (u v : V) : ℕ :=
  if u ≠ v ∧ (H u ∩ H v).Nonempty then
    PairEnergy.energy H (properCommon H u v) else 0

def quadraticTerm (H : V → Finset C) (u v : V) : ℕ :=
  if u ≠ v ∧ (H u ∩ H v).Nonempty then
    (properCommon H u v).card^2 + 2 * (properCommon H u v).card else 0

theorem rootTerm_add_energyTerm (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) (u v : V) :
    rootTerm H u v + energyTerm H u v = quadraticTerm H u v := by
  unfold rootTerm energyTerm quadraticTerm
  split_ifs
  · exact PairEnergy.missing_pair_energy_identity H hd h4 _
  · rfl

def normalizedEnergy (sockets : P → Finset (R × G)) : ℕ :=
  ∑ p : P, ∑ q : P, ∑ d : G, energyTerm (incidence sockets) (p,0) (q,d)

def normalizedQuadratic (sockets : P → Finset (R × G)) : ℕ :=
  ∑ p : P, ∑ q : P, ∑ d : G, quadraticTerm (incidence sockets) (p,0) (q,d)

theorem cyclic_corrected_count_identity (sockets : P → Finset (R × G))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    4 * GlobalCounting.count42 (incidence sockets) +
      Fintype.card G * normalizedEnergy sockets =
        Fintype.card G * normalizedQuadratic sockets := by
  rw [cyclic_count_identity sockets hd h4, ← Nat.mul_add]
  congr 1
  unfold normalizedSum normalizedEnergy normalizedQuadratic
  simp_rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro q hq
  apply Finset.sum_congr rfl
  intro d hdmem
  exact rootTerm_add_energyTerm _ hd h4 _ _

#print axioms cyclic_count_identity
#print axioms cyclic_corrected_count_identity
end Cyclic
end CyclicNormalization
