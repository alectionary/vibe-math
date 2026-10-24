import SidonStopping
import Mathlib.Algebra.Order.GroupWithZero.Basic
namespace PowersThree
open Finset

lemma sorted_sum_unique (a b c d : ℕ) (hab : a ≤ b) (hcd : c ≤ d)
    (he : 3^a + 3^b = 3^c + 3^d) : a=c ∧ b=d := by
  have hpow (i j : ℕ) (hij : i ≤ j) : 3^i ≤ 3^j := pow_le_pow_right₀ (by omega) hij
  have hn1 : 0 ≤ (3:ℕ)^a := Nat.zero_le _
  have hn2 : 0 ≤ (3:ℕ)^b := Nat.zero_le _
  have hn3 : 0 ≤ (3:ℕ)^c := Nat.zero_le _
  have hn4 : 0 ≤ (3:ℕ)^d := Nat.zero_le _
  have hb : b=d := by
    by_contra hn
    rcases lt_or_gt_of_ne hn with hbd | hdb
    · have hp := hpow (b+1) d hbd
      have ha := hpow a b hab
      have hpos : 0 < 3^b := pow_pos (by omega) _
      rw [pow_succ] at hp
      omega
    · have hp := hpow (d+1) b hdb
      have hc := hpow c d hcd
      have hpos : 0 < 3^d := pow_pos (by omega) _
      rw [pow_succ] at hp
      omega
  subst d
  have ha : 3^a = 3^c := by omega
  exact ⟨(pow_right_strictMono₀ (by omega : (1:ℕ)<3)).injective ha,rfl⟩

/-- Base three avoids carries even when the two summands coincide. -/
theorem sum_unique (a b c d : ℕ) (he : 3^a+3^b=3^c+3^d) :
    (a=c ∧ b=d) ∨ (a=d ∧ b=c) := by
  by_cases hab : a ≤ b <;> by_cases hcd : c ≤ d
  · exact Or.inl (sorted_sum_unique a b c d hab hcd he)
  · have h := sorted_sum_unique a b d c hab (by omega) (by omega)
    exact Or.inr h
  · have h := sorted_sum_unique b a c d (by omega) hcd (by omega)
    exact Or.inr ⟨h.2,h.1⟩
  · have h := sorted_sum_unique b a d c (by omega) (by omega) (by omega)
    exact Or.inl ⟨h.2,h.1⟩

lemma pair_lt (γ n a b : ℕ) (hn : 3^γ ≤ n) (ha : a < γ) (hb : b < γ) :
    3^a+3^b<n := by
  have hγ : γ = (γ-1)+1 := by omega
  have h1 : 3^a ≤ 3^(γ-1) := pow_le_pow_right₀ (by omega) (by omega)
  have h2 : 3^b ≤ 3^(γ-1) := pow_le_pow_right₀ (by omega) (by omega)
  have hp : 0 < 3^(γ-1) := pow_pos (by omega) _
  rw [hγ,pow_succ] at hn
  omega

def support (γ n : ℕ) : Finset (ZMod n) := (range γ).image (fun i => (3^i : ℕ))

lemma cast_sum_injective {n : ℕ} (a b c d : ℕ)
    (hab : a+b<n) (hcd : c+d<n)
    (he : (a:ZMod n)+b=(c:ZMod n)+d) : a+b=c+d := by
  letI : NeZero n := ⟨by omega⟩
  have hcast : ((a+b:ℕ):ZMod n) = ((c+d:ℕ):ZMod n) := by simpa using he
  have hv := congrArg ZMod.val hcast
  rw [ZMod.val_natCast,ZMod.val_natCast,Nat.mod_eq_of_lt hab,Nat.mod_eq_of_lt hcd] at hv
  exact hv

theorem sidon (γ n : ℕ) (hn : 3^γ ≤ n) : SidonStopping.IsSidon (support γ n) := by
  intro a ha b hb c hc d hd he
  obtain ⟨i,hi,rfl⟩ := mem_image.mp ha
  obtain ⟨j,hj,rfl⟩ := mem_image.mp hb
  obtain ⟨k,hk,rfl⟩ := mem_image.mp hc
  obtain ⟨l,hl,rfl⟩ := mem_image.mp hd
  have hnat := cast_sum_injective (3^i) (3^j) (3^k) (3^l)
    (pair_lt γ n i j hn (mem_range.mp hi) (mem_range.mp hj))
    (pair_lt γ n k l hn (mem_range.mp hk) (mem_range.mp hl)) he
  rcases sum_unique i j k l hnat with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact Or.inl ⟨rfl,rfl⟩
  · exact Or.inr ⟨rfl,rfl⟩

theorem support_card (γ n : ℕ) (hn : 3^γ ≤ n) : (support γ n).card = γ := by
  unfold support
  rw [card_image_of_injOn,card_range]
  intro i hi j hj he
  have hi' := pair_lt γ n i i hn (mem_range.mp hi) (mem_range.mp hi)
  have hj' := pair_lt γ n j j hn (mem_range.mp hj) (mem_range.mp hj)
  letI : NeZero n := ⟨by have := pow_pos (by omega : 0 < (3:ℕ)) γ; omega⟩
  change ((3^i:ℕ):ZMod n) = ((3^j:ℕ):ZMod n) at he
  have hv := congrArg ZMod.val he
  have hepow : 3^i = 3^j := by
    rw [ZMod.val_natCast,ZMod.val_natCast,Nat.mod_eq_of_lt (by omega : 3^i<n),
      Nat.mod_eq_of_lt (by omega : 3^j<n)] at hv
    exact hv
  exact (pow_right_strictMono₀ (by omega : (1:ℕ)<3)).injective hepow
end PowersThree
