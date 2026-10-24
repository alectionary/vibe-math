import SidonStopping
import Mathlib.Basic.Real.Basic
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def coeff (R : Type*) [Zero R] [One R] (S : Finset G) (g : G) : R := if g ∈ S then 1 else 0
def X (R : Type*) [Zero R] [One R] (S : Finset G) : Matrix G (Bool × G) R :=
  GramStopping.paired (circulant (coeff R S))
def BadX (R : Type*) [Zero R] [One R] (S : Finset G) : Matrix G (Bool × G) R :=
  GramStopping.doubled (circulant (coeff R S))
def BadZ (S : Finset G) : Matrix G (Bool × G) (ZMod 2) :=
  GramStopping.doubled (circulant (coeff (ZMod 2) S))ᵀ

theorem entry (R : Type*) [Zero R] [One R] (S : Finset G) (v : Bool × G) (c : G) :
    X R S c v = if E S v c then 1 else 0 := by
  rcases v with ⟨b,j⟩
  cases b <;> rfl

theorem binary_incidence (S : Finset G) (v : Bool × G) (c : G) :
    X (ZMod 2) S c v = 1 ↔ E S v c := by
  rw [entry]
  split <;> simp_all

theorem css (S : Finset G) : X (ZMod 2) S * (X (ZMod 2) S)ᵀ = 0 :=
  GramStopping.paired_css _
theorem bad_css (S : Finset G) : BadX (ZMod 2) S * (BadZ S)ᵀ = 0 :=
  GramStopping.doubled_css _
theorem gram_equal (S : Finset G) : X ℝ S * (X ℝ S)ᵀ = BadX ℝ S * (BadX ℝ S)ᵀ :=
  GramStopping.circulant_gram_equal _

theorem column_weight (S : Finset G) (v : Bool × G) :
    (univ.filter (fun c => X (ZMod 2) S c v = 1)).card = S.card := by
  simpa only [binary_incidence,PartitionStopping.neighbors] using degree S v

/-- The row support has one translate of S in each block. -/
theorem row_weight (S : Finset G) (c : G) :
    (univ.filter (fun v => X (ZMod 2) S c v = 1)).card = 2*S.card := by
  classical
  let f : Bool × G → Bool × G := fun v => (v.1,if v.1 then c+v.2 else c-v.2)
  have hinj : Function.Injective f := by
    rintro ⟨b,v⟩ ⟨d,w⟩ he
    have hb : b=d := congrArg Prod.fst he
    subst d
    have hp := congrArg Prod.snd he
    cases b <;> simp_all [f]
  have heq : univ.filter (fun v => X (ZMod 2) S c v = 1) = ((univ : Finset Bool) ×ˢ S).image f := by
    ext v
    rcases v with ⟨b,j⟩
    simp only [mem_filter,mem_univ,true_and,binary_incidence,mem_image,mem_product]
    constructor
    · intro hv
      cases b
      · exact ⟨(false,c-j),hv,by simp [f]⟩
      · exact ⟨(true,j-c),hv,by simp [f,add_comm]⟩
    · rintro ⟨⟨d,s⟩,hs,he⟩
      have hb : d=b := congrArg Prod.fst he
      subst d
      cases b <;> simp_all [f,E] <;> simpa [← he,add_comm] using hs
  rw [heq,card_image_of_injective _ hinj,card_product]
  simp

theorem coefficient_sum (S : Finset G) : ∑ j, coeff (ZMod 2) S j = (S.card : ZMod 2) := by
  simp [coeff,← sum_filter]

lemma left_row_sum (S : Finset G) (c : G) :
    (∑ j, X (ZMod 2) S c (false,j)) = (S.card : ZMod 2) := by
  change (∑ j, coeff (ZMod 2) S (c-j)) = _
  rw [← coefficient_sum S]
  exact Fintype.sum_equiv (Equiv.subLeft c) _ _ (fun _ => rfl)

def leftParity (x : Bool × G → ZMod 2) : ZMod 2 := ∑ j, x (false,j)
def leftOnes : Bool × G → ZMod 2 := fun v => if v.1 then 0 else 1

theorem leftOnes_kernel (S : Finset G) (heven : Even S.card) :
    (X (ZMod 2) S).mulVec (leftOnes (G := G)) = 0 := by
  have hz : (S.card : ZMod 2) = 0 := by
    rw [ZMod.natCast_eq_zero_iff]
    exact even_iff_two_dvd.mp heven
  funext c
  simp only [Matrix.mulVec,dotProduct,leftOnes]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,Bool.false_eq_true,↓reduceIte,mul_zero,mul_one,sum_const_zero,add_zero,zero_add]
  exact (left_row_sum S c).trans hz

theorem stabilizer_parity (S : Finset G) (heven : Even S.card) (a : G → ZMod 2) :
    leftParity ((X (ZMod 2) S)ᵀ.mulVec a) = 0 := by
  have hz : (S.card : ZMod 2) = 0 := by
    rw [ZMod.natCast_eq_zero_iff]
    exact even_iff_two_dvd.mp heven
  unfold leftParity
  simp only [Matrix.mulVec,dotProduct,transpose_apply]
  rw [sum_comm]
  simp_rw [← sum_mul,left_row_sum,hz,zero_mul]
  simp

theorem leftOnes_not_stabilizer (S : Finset G) (heven : Even S.card)
    (hodd : Odd (Fintype.card G)) :
    ¬ ∃ a : G → ZMod 2, (X (ZMod 2) S)ᵀ.mulVec a = leftOnes (G := G) := by
  rintro ⟨a,ha⟩
  have hp := stabilizer_parity S heven a
  rw [ha] at hp
  have hsum : leftParity (leftOnes (G := G)) = (Fintype.card G : ZMod 2) := by
    simp [leftParity,leftOnes]
  rw [hsum,ZMod.natCast_eq_zero_iff] at hp
  exact (Nat.not_even_iff_odd.mpr hodd) (even_iff_two_dvd.mpr hp)
end SidonStopping
