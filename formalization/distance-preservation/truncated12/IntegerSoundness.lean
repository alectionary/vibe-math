import TorsionClassical
import ActualIncidence
set_option maxHeartbeats 0
namespace TruncatedDistance

def integerDot {n : ℕ} {A : Type*} [AddCommGroup A]
    (a : Fin n → ℤ) (x : Fin n → A) : A := ∑ j, a j • x j

/-- Integer row identities imply equations in every additive group; no division,
primality assumption, floating point calculation or native oracle is used. -/
theorem integer_certificate_sound {m n : ℕ} {A : Type*} [AddCommGroup A]
    (M : Fin m → Fin n → ℤ) (a : Fin m → ℤ) (target : Fin n → ℤ)
    (x : Fin n → A) (hrows : ∀ i, integerDot (M i) x=0)
    (hcert : ∀ j, target j=∑ i, a i*M i j) : integerDot target x=0 := by
  change (∑ j, target j • x j)=0
  calc
    _ = ∑ j, ∑ i, (a i*M i j) • x j := by
      simp_rw [hcert,Finset.sum_smul]
    _ = ∑ i, a i • integerDot (M i) x := by
      rw [Finset.sum_comm]
      simp only [integerDot,Finset.smul_sum,mul_zsmul]
    _ = 0 := by simp [hrows]

variable {L : ℕ} [NeZero L]

theorem torsion_injective_impossible (n k : ℕ) (hn : 0<n) (hk : n<k)
    (f : Fin k → ZMod L) (hi : Function.Injective f) (ht : ∀ j, n • f j=0) : False := by
  have hs : Finset.univ.image f ⊆ torsionSet n := by
    intro s hs
    obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hs
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,ht j⟩
  have hc := Finset.card_le_card hs
  rw [Finset.card_image_of_injective _ hi] at hc
  have hb := torsion_card_le (L := L) n hn
  simp only [Finset.card_univ,Fintype.card_fin] at hc
  omega

theorem row_differences_injective (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (i k : Fin 3) (hik : i≠k) :
    Function.Injective (fun j : Fin 4 => e i j-e k j) := by
  intro a b he
  by_contra hab
  apply h4 (a,0) (b,e i a-e i b) (i,e i a) (k,e k a)
  · intro h;exact hab (congrArg Prod.fst h)
  · intro h;exact hik (congrArg Prod.fst h)
  · simp [CEdge]
  · simp [CEdge]
  · change e k a=e i a-e i b+e k b
    linear_combination -he
  · simp [CEdge]

theorem column_differences_injective (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (a b : Fin 4) (hab : a≠b) :
    Function.Injective (fun i : Fin 3 => e i a-e i b) := by
  intro i k he
  by_contra hik
  have hi := row_differences_injective e h4 i k hik
  have h : e i a-e k a=e i b-e k b := by linear_combination he
  exact hab (hi h)

theorem row_small_torsion_impossible (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (n : ℕ) (hn : 0<n) (hsmall : n≤3)
    (i k : Fin 3) (hik : i≠k) (ht : ∀ j, n • (e i j-e k j)=0) : False := by
  exact torsion_injective_impossible n 4 hn (by omega) _
    (row_differences_injective e h4 i k hik) ht

theorem column_two_torsion_impossible (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (a b : Fin 4) (hab : a≠b)
    (ht : ∀ i, 2 • (e i a-e i b)=0) : False := by
  exact torsion_injective_impossible 2 3 (by decide) (by decide) _
    (column_differences_injective e h4 a b hab) ht

#print axioms integer_certificate_sound
#print axioms row_small_torsion_impossible
#print axioms column_two_torsion_impossible
end TruncatedDistance
