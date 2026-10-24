import HGPGramObstruction
import CyclicNormalization
import Mathlib.Data.ZMod.Basic
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace GB48
open CyclicNormalization
abbrev G := ZMod 24
abbrev V := Fin 2 × G
abbrev C := Fin 1 × G

/-- a=1+x+x^5, b=1+x^2+x^10; right sockets use the transpose sign. -/
def socketsA (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,14)}

/-- Same a, and b'=1+x^2+x^16=x^2 b(x^-1), modulo x^24-1. -/
def socketsB (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,8)}

def HA : V → Finset C := incidence socketsA
def HB : V → Finset C := incidence socketsB

theorem cubic_A : ∀ v, (HA v).card=3 := by decide
theorem cubic_B : ∀ v, (HB v).card=3 := by decide
theorem linear_A : ∀ u v, u≠v → (HA u ∩ HA v).card ≤ 1 := by decide
theorem linear_B : ∀ u v, u≠v → (HB u ∩ HB v).card ≤ 1 := by decide

theorem normalized_A : normalizedSum socketsA = 32 := by decide
theorem normalized_B : normalizedSum socketsB = 12 := by decide

theorem count_A : GlobalCounting.count42 HA = 192 := by
  have h := cyclic_count_identity socketsA cubic_A linear_A
  rw [normalized_A] at h
  change 4 * GlobalCounting.count42 HA = 24 * 32 at h
  omega

theorem count_B : GlobalCounting.count42 HB = 72 := by
  have h := cyclic_count_identity socketsB cubic_B linear_B
  rw [normalized_B] at h
  change 4 * GlobalCounting.count42 HB = 24 * 12 at h
  omega

theorem same_check_Gram : HGPGramObstruction.checkGram HA = HGPGramObstruction.checkGram HB := by
  funext c d
  have h : ∀ c d, HGPGramObstruction.checkGram HA c d = HGPGramObstruction.checkGram HB c d := by decide
  exact h c d

theorem no_Gram_only_count :
    ¬ ∃ f : (C → C → ℕ) → ℕ, ∀ H : V → Finset C,
      (∀ v, (H v).card=3) → (∀ u v, u≠v → (H u ∩ H v).card≤1) →
      f (HGPGramObstruction.checkGram H) = GlobalCounting.count42 H := by
  rintro ⟨f,hf⟩
  have ha := hf HA cubic_A linear_A
  have hb := hf HB cubic_B linear_B
  rw [same_check_Gram,count_A] at ha
  rw [count_B] at hb
  omega

#print axioms count_A
#print axioms count_B
#print axioms same_check_Gram
#print axioms no_Gram_only_count
end GB48
