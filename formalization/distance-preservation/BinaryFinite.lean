import BinaryWords
import Mathlib.Tactic
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace BinaryFinite
open BinaryWords
def pack44 (f : Fin 44 → Bool) : BitVec 44 := BitVec.ofBoolListLE [f 0, f 1, f 2, f 3, f 4, f 5, f 6, f 7, f 8, f 9, f 10, f 11, f 12, f 13, f 14, f 15, f 16, f 17, f 18, f 19, f 20, f 21, f 22, f 23, f 24, f 25, f 26, f 27, f 28, f 29, f 30, f 31, f 32, f 33, f 34, f 35, f 36, f 37, f 38, f 39, f 40, f 41, f 42, f 43]
theorem pack44_bit (f : Fin 44 → Bool) (i : Fin 44) : (pack44 f).getLsbD i.val = f i := by
  fin_cases i <;> simp only [pack44,BitVec.getLsbD_ofBoolListLE,List.getD_cons_zero,List.getD_cons_succ] <;> rfl
theorem cpop_list (bs : List Bool) : (BitVec.ofBoolListLE bs).cpop.toNat = bs.countP id := by
  induction bs with
  | nil => rfl
  | cons b bs ih =>
    change ((BitVec.ofBoolListLE bs).concat b).cpop.toNat = (b :: bs).countP id
    rw [BitVec.toNat_cpop_concat,ih,List.countP_cons]
    cases b <;> simp [Nat.add_comm]

theorem countP_ofFn {n : Nat} (f : Fin n → Bool) :
    (List.ofFn f).countP id = ∑ i : Fin n, if f i then 1 else 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
    simp only [List.ofFn_succ,List.countP_cons,Fin.sum_univ_succ,ih,id_eq]
    exact Nat.add_comm _ _

theorem pack44_weight (f : Fin 44 → Bool) : (pack44 f).cpop.toNat = (Finset.univ.filter (fun i => f i)).card := by
  unfold pack44
  rw [cpop_list]
  change (List.ofFn f).countP id = _
  rw [countP_ofFn,Finset.card_eq_sum_ones,Finset.sum_filter]
theorem xor_false_iff_even {A : Type*} (is : List A) (f : A → Bool) : is.foldr (fun a b => f a ^^ b) false = false ↔ is.countP f % 2 = 0 := by
  induction is with
  | nil => simp
  | cons a is ih =>
    simp only [List.foldr_cons,List.countP_cons]
    cases h : f a <;> cases ht : is.foldr (fun a b => f a ^^ b) false <;> simp_all
    all_goals omega
#print axioms pack44_weight
#print axioms xor_false_iff_even
end BinaryFinite
