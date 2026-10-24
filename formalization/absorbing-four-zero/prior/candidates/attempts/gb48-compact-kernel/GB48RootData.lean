import CyclicNormalization
import Mathlib.Data.ZMod.Basic
set_option maxHeartbeats 0
set_option maxRecDepth 100000
set_option Elab.async false
namespace GB48RootData
open CyclicNormalization PairFormula
abbrev G := ZMod 24
abbrev V := Fin 2 × G
abbrev C := Fin 1 × G
attribute [local irreducible] CyclicNormalization.rootTerm GlobalCounting.count42
def socketsA (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,14)}
def socketsB (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,8)}
def HA : V → Finset C := incidence socketsA
def HB : V → Finset C := incidence socketsB
theorem cubic (s : Fin 2 → Finset C) (hs : ∀ p, (s p).card=3) :
    ∀ v, (incidence s v).card=3 := by
  intro v
  rw [incidence, Finset.card_image_of_injective _ (shift (Fin 1) v.2).injective]
  exact hs v.1
theorem cubic_A : ∀ v, (HA v).card=3 := cubic socketsA (by decide +kernel)
theorem cubic_B : ∀ v, (HB v).card=3 := cubic socketsB (by decide +kernel)
theorem linear_from_normalized (s : Fin 2 → Finset C)
    (hn : ∀ p q (d : G), (p,0) ≠ (q,d) →
      (incidence s (p,0) ∩ incidence s (q,d)).card ≤ 1) :
    ∀ u v, u ≠ v → (incidence s u ∩ incidence s v).card ≤ 1 := by
  rintro ⟨p,a⟩ ⟨q,b⟩ huv
  have he : (p,(0 : G)) ≠ (q,-a+b) := by
    intro h
    have hp : p=q := congrArg Prod.fst h
    have hab : (0 : G) = -a+b := congrArg Prod.snd h
    have hb : b=a := by
      have hh := congrArg (fun x : G => a+x) hab
      simpa only [add_zero, ← add_assoc, add_neg_cancel, zero_add] using hh.symm
    exact huv (by simp only [hp,hb])
  have h := hn p q (-a+b) he
  have hi : incidence s (p,0) ∩ incidence s (q,-a+b) =
      (incidence s (p,a) ∩ incidence s (q,b)).image (shift (Fin 1) (-a)) := by
    rw [Finset.image_inter _ _ (shift (Fin 1) (-a)).injective]
    rw [← incidence_shift, ← incidence_shift]
    simp only [shift_apply, neg_add_cancel]
  rw [hi, Finset.card_image_of_injective _ (shift (Fin 1) (-a)).injective] at h
  exact h
theorem linear_A : ∀ u v, u≠v → (HA u ∩ HA v).card ≤ 1 :=
  linear_from_normalized socketsA (by decide +kernel)
theorem linear_B : ∀ u v, u≠v → (HB u ∩ HB v).card ≤ 1 :=
  linear_from_normalized socketsB (by decide +kernel)

/-- Exact finite kernel check over 96 normalized root representatives. -/
theorem normalized_A : normalizedSum socketsA = 32 := by decide +kernel

theorem count_A : GlobalCounting.count42 HA = 192 := by
  have h := cyclic_count_identity socketsA cubic_A linear_A
  rw [normalized_A] at h
  change 4 * GlobalCounting.count42 HA = 24 * 32 at h
  exact Nat.eq_of_mul_eq_mul_left (n:=4) (by decide +kernel) h

#print axioms normalized_A
#print axioms count_A

/-- Exact finite kernel check over 96 normalized root representatives. -/
theorem normalized_B : normalizedSum socketsB = 12 := by decide +kernel

theorem count_B : GlobalCounting.count42 HB = 72 := by
  have h := cyclic_count_identity socketsB cubic_B linear_B
  rw [normalized_B] at h
  change 4 * GlobalCounting.count42 HB = 24 * 12 at h
  exact Nat.eq_of_mul_eq_mul_left (n:=4) (by decide +kernel) h

#print axioms normalized_B
#print axioms count_B

#print axioms cubic_A
#print axioms linear_A
#print axioms cubic_B
#print axioms linear_B
end GB48RootData
