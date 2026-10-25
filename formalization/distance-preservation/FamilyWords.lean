import Mathlib.Data.ZMod.Basic
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Algebra.CharP.Two
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace FamilyWords
open scoped Matrix CharTwo
variable {L : Nat}

def exponent : Fin 3 → Fin 4 → ℤ := !![0,0,0,0; 0,1,5,3; 0,2,10,7]
def delta (a t : ZMod L) : ZMod 2 := if t = a then 1 else 0

lemma delta_sub (a t e : ZMod L) : delta a (t-e) = delta (a+e) t := by
  simp [delta, sub_eq_iff_eq_add]
lemma delta_add (a t e : ZMod L) : delta a (t+e) = delta (a-e) t := by
  simp [delta, eq_sub_iff_add_eq]

def U (i j : Fin 4) (s : ZMod L) : ZMod 2 :=
  !![delta 0 s,0,0,0;
     0,delta (-2) s,0,0;
     0,0,delta (-10) s,0;
     delta (-2) s,delta (-4) s + delta (-2) s,delta (-7) s,delta (-4) s] i j
def V (i j : Fin 3) (s : ZMod L) : ZMod 2 :=
  !![0,0,delta 0 s; 0,delta 0 s,0; delta 0 s,0,0] i j

/-- Coefficient form of equation (9)'s H_Z kernel condition. -/
def Syndrome (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (j : Fin 4) (i : Fin 3) (t : ZMod L) : ZMod 2 :=
  (∑ k : Fin 4, u j k (t - (exponent i k : ZMod L))) +
  (∑ l : Fin 3, v l i (t + (exponent l j : ZMod L)))

theorem witness_kernel (j : Fin 4) (i : Fin 3) (t : ZMod L) : Syndrome U V j i t = 0 := by
  fin_cases j <;> fin_cases i <;>
    norm_num [Syndrome,U,V,exponent,Fin.sum_univ_succ,delta_sub,delta_add,
      add_comm,add_left_comm,add_assoc]

variable [NeZero L]

def augmentation (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) : ZMod 2 :=
  (∑ s, u 0 0 s) + (∑ s, u 1 0 s)

/-- The entire first block of H_X^T w, for arbitrary binary check coefficients w. -/
def stabilizerLeft (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (i j : Fin 4) (s : ZMod L) : ZMod 2 :=
  ∑ k : Fin 3, w k j (s + (exponent k i : ZMod L))

def stabilizerRight (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (i j : Fin 3) (s : ZMod L) : ZMod 2 :=
  ∑ k : Fin 4, w i k (s - (exponent j k : ZMod L))

/-- H_Z H_X^T=0 for the coefficient form of the source construction. -/
theorem css_commutation (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    Syndrome (stabilizerLeft w) (stabilizerRight w) j i t = 0 := by
  unfold Syndrome stabilizerLeft stabilizerRight
  simp_rw [sub_add_eq_add_sub]
  rw [Finset.sum_comm]
  exact CharTwo.add_self_eq_zero _

lemma sum_shift (f : ZMod L → ZMod 2) (a : ZMod L) :
    (∑ s, f (s+a)) = ∑ s, f s :=
  Fintype.sum_equiv (Equiv.addRight a) _ _ (fun _ => rfl)

theorem augmentation_stabilizer (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) :
    augmentation (stabilizerLeft w) = 0 := by
  have h (i : Fin 4) : (∑ s, stabilizerLeft w i 0 s) = ∑ k, ∑ s, w k 0 s := by
    unfold stabilizerLeft
    rw [Finset.sum_comm]
    simp_rw [sum_shift]
  unfold augmentation
  rw [h 0,h 1]
  exact CharTwo.add_self_eq_zero _

theorem augmentation_witness : augmentation (U (L := L)) = 1 := by
  simp [augmentation,U,delta]

theorem witness_nontrivial : ¬ ∃ w : Fin 3 → Fin 4 → ZMod L → ZMod 2,
    U = stabilizerLeft w := by
  rintro ⟨w,hw⟩
  have h1 := augmentation_witness (L := L)
  rw [hw,augmentation_stabilizer] at h1
  exact zero_ne_one h1

abbrev Qubit (L : Nat) := ((Fin 4 × Fin 4) × ZMod L) ⊕ ((Fin 3 × Fin 3) × ZMod L)
def word (q : Qubit L) : ZMod 2 := match q with
  | .inl ((i,j),s) => U i j s
  | .inr ((i,j),s) => V i j s
def supportList : List (Qubit L) :=
  [.inl ((0,0),0),.inl ((1,1),-2),.inl ((2,2),-10),
   .inl ((3,0),-2),.inl ((3,1),-4),.inl ((3,1),-2),
   .inl ((3,2),-7),.inl ((3,3),-4),
   .inr ((0,2),0),.inr ((1,1),0),.inr ((2,0),0)]
def support : Finset (Qubit L) := Finset.univ.filter (fun q => word q ≠ 0)

theorem word_zero_outside (q : Qubit L) (hq : q ∉ supportList) : word q = 0 := by
  cases q with
  | inl p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    fin_cases i <;> fin_cases j <;> simp_all [word,U,supportList,delta]
  | inr p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    fin_cases i <;> fin_cases j <;> simp_all [word,V,supportList,delta]

theorem witness_weight_le : (support (L := L)).card ≤ 11 := by
  have hs : support ⊆ (supportList (L := L)).toFinset := by
    intro q hq
    simp only [support,Finset.mem_filter,Finset.mem_univ,true_and] at hq
    by_contra hn
    have hn' : q ∉ supportList := by simpa using hn
    exact hq (word_zero_outside q hn')
  have h := Finset.card_le_card hs
  have hl := List.toFinset_card_le (l := supportList (L := L))
  have he : (supportList (L := L)).length = 11 := rfl
  omega

#print axioms witness_kernel
#print axioms witness_nontrivial
#print axioms witness_weight_le
#print axioms css_commutation
end FamilyWords
