import FamilyBaseGraph
import FamilyDistance11
import FamilyDotRows11
import BinaryFinite
import CoverWeight
set_option maxHeartbeats 0
namespace FamilyBaseGraph
open BinaryWords
def packWord (x : Var → ZMod 2) : BitVec 44 := BinaryFinite.pack44 (fun v => decide (x (varEquiv.symm v) ≠ 0))
theorem packWord_bit (x : Var → ZMod 2) (v : Fin 44) : (packWord x).getLsbD v.val = decide (x (varEquiv.symm v) ≠ 0) := BinaryFinite.pack44_bit _ v
theorem packWord_bit_nat (x : Var → ZMod 2) (v : Nat) (hv : v<44) :
    (packWord x).getLsbD v = decide (x (varEquiv.symm ⟨v,hv⟩) ≠ 0) :=
  packWord_bit x ⟨v,hv⟩
theorem bool_four (a b c d : ZMod 2) : (decide (a ≠ 0) ^^ (decide (b ≠ 0) ^^ (decide (c ≠ 0) ^^ decide (d ≠ 0)))) = false ↔ a+(b+(c+d))=0 := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;> decide +kernel
def boundary (x : Var → ZMod 2) (c : Check) : ZMod 2 := ∑ j : Fin 4, x (j,c.2-e c.1 j)
theorem kernel_row_0 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 0) (packWord x) = false ↔ boundary x (checkEquiv.symm 0) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 0 ^^ ((packWord x).getLsbD 11 ^^ ((packWord x).getLsbD 22 ^^ ((packWord x).getLsbD 33 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 0 (by decide), packWord_bit_nat x 11 (by decide), packWord_bit_nat x 22 (by decide), packWord_bit_nat x 33 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,0) ≠ 0) ^^ (decide (x (1,0) ≠ 0) ^^ (decide (x (2,0) ≠ 0) ^^ (decide (x (3,0) ≠ 0))))) = false ↔ x (0,0)+(x (1,0)+(x (2,0)+x (3,0))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_1 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 1) (packWord x) = false ↔ boundary x (checkEquiv.symm 1) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 1 ^^ ((packWord x).getLsbD 12 ^^ ((packWord x).getLsbD 23 ^^ ((packWord x).getLsbD 34 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 1 (by decide), packWord_bit_nat x 12 (by decide), packWord_bit_nat x 23 (by decide), packWord_bit_nat x 34 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,1) ≠ 0) ^^ (decide (x (1,1) ≠ 0) ^^ (decide (x (2,1) ≠ 0) ^^ (decide (x (3,1) ≠ 0))))) = false ↔ x (0,1)+(x (1,1)+(x (2,1)+x (3,1))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_2 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 2) (packWord x) = false ↔ boundary x (checkEquiv.symm 2) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 2 ^^ ((packWord x).getLsbD 13 ^^ ((packWord x).getLsbD 24 ^^ ((packWord x).getLsbD 35 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 2 (by decide), packWord_bit_nat x 13 (by decide), packWord_bit_nat x 24 (by decide), packWord_bit_nat x 35 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,2) ≠ 0) ^^ (decide (x (1,2) ≠ 0) ^^ (decide (x (2,2) ≠ 0) ^^ (decide (x (3,2) ≠ 0))))) = false ↔ x (0,2)+(x (1,2)+(x (2,2)+x (3,2))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_3 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 3) (packWord x) = false ↔ boundary x (checkEquiv.symm 3) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 3 ^^ ((packWord x).getLsbD 14 ^^ ((packWord x).getLsbD 25 ^^ ((packWord x).getLsbD 36 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 3 (by decide), packWord_bit_nat x 14 (by decide), packWord_bit_nat x 25 (by decide), packWord_bit_nat x 36 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,3) ≠ 0) ^^ (decide (x (1,3) ≠ 0) ^^ (decide (x (2,3) ≠ 0) ^^ (decide (x (3,3) ≠ 0))))) = false ↔ x (0,3)+(x (1,3)+(x (2,3)+x (3,3))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_4 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 4) (packWord x) = false ↔ boundary x (checkEquiv.symm 4) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 4 ^^ ((packWord x).getLsbD 15 ^^ ((packWord x).getLsbD 26 ^^ ((packWord x).getLsbD 37 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 4 (by decide), packWord_bit_nat x 15 (by decide), packWord_bit_nat x 26 (by decide), packWord_bit_nat x 37 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,4) ≠ 0) ^^ (decide (x (1,4) ≠ 0) ^^ (decide (x (2,4) ≠ 0) ^^ (decide (x (3,4) ≠ 0))))) = false ↔ x (0,4)+(x (1,4)+(x (2,4)+x (3,4))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_5 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 5) (packWord x) = false ↔ boundary x (checkEquiv.symm 5) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 5 ^^ ((packWord x).getLsbD 16 ^^ ((packWord x).getLsbD 27 ^^ ((packWord x).getLsbD 38 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 5 (by decide), packWord_bit_nat x 16 (by decide), packWord_bit_nat x 27 (by decide), packWord_bit_nat x 38 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,5) ≠ 0) ^^ (decide (x (1,5) ≠ 0) ^^ (decide (x (2,5) ≠ 0) ^^ (decide (x (3,5) ≠ 0))))) = false ↔ x (0,5)+(x (1,5)+(x (2,5)+x (3,5))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_6 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 6) (packWord x) = false ↔ boundary x (checkEquiv.symm 6) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 6 ^^ ((packWord x).getLsbD 17 ^^ ((packWord x).getLsbD 28 ^^ ((packWord x).getLsbD 39 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 6 (by decide), packWord_bit_nat x 17 (by decide), packWord_bit_nat x 28 (by decide), packWord_bit_nat x 39 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,6) ≠ 0) ^^ (decide (x (1,6) ≠ 0) ^^ (decide (x (2,6) ≠ 0) ^^ (decide (x (3,6) ≠ 0))))) = false ↔ x (0,6)+(x (1,6)+(x (2,6)+x (3,6))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_7 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 7) (packWord x) = false ↔ boundary x (checkEquiv.symm 7) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 7 ^^ ((packWord x).getLsbD 18 ^^ ((packWord x).getLsbD 29 ^^ ((packWord x).getLsbD 40 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 7 (by decide), packWord_bit_nat x 18 (by decide), packWord_bit_nat x 29 (by decide), packWord_bit_nat x 40 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,7) ≠ 0) ^^ (decide (x (1,7) ≠ 0) ^^ (decide (x (2,7) ≠ 0) ^^ (decide (x (3,7) ≠ 0))))) = false ↔ x (0,7)+(x (1,7)+(x (2,7)+x (3,7))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_8 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 8) (packWord x) = false ↔ boundary x (checkEquiv.symm 8) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 8 ^^ ((packWord x).getLsbD 19 ^^ ((packWord x).getLsbD 30 ^^ ((packWord x).getLsbD 41 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 8 (by decide), packWord_bit_nat x 19 (by decide), packWord_bit_nat x 30 (by decide), packWord_bit_nat x 41 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,8) ≠ 0) ^^ (decide (x (1,8) ≠ 0) ^^ (decide (x (2,8) ≠ 0) ^^ (decide (x (3,8) ≠ 0))))) = false ↔ x (0,8)+(x (1,8)+(x (2,8)+x (3,8))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_9 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 9) (packWord x) = false ↔ boundary x (checkEquiv.symm 9) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 9 ^^ ((packWord x).getLsbD 20 ^^ ((packWord x).getLsbD 31 ^^ ((packWord x).getLsbD 42 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 9 (by decide), packWord_bit_nat x 20 (by decide), packWord_bit_nat x 31 (by decide), packWord_bit_nat x 42 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,9) ≠ 0) ^^ (decide (x (1,9) ≠ 0) ^^ (decide (x (2,9) ≠ 0) ^^ (decide (x (3,9) ≠ 0))))) = false ↔ x (0,9)+(x (1,9)+(x (2,9)+x (3,9))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_10 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 10) (packWord x) = false ↔ boundary x (checkEquiv.symm 10) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 10 ^^ ((packWord x).getLsbD 21 ^^ ((packWord x).getLsbD 32 ^^ ((packWord x).getLsbD 43 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 10 (by decide), packWord_bit_nat x 21 (by decide), packWord_bit_nat x 32 (by decide), packWord_bit_nat x 43 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,10) ≠ 0) ^^ (decide (x (1,10) ≠ 0) ^^ (decide (x (2,10) ≠ 0) ^^ (decide (x (3,10) ≠ 0))))) = false ↔ x (0,10)+(x (1,10)+(x (2,10)+x (3,10))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_11 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 11) (packWord x) = false ↔ boundary x (checkEquiv.symm 11) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 0 ^^ ((packWord x).getLsbD 21 ^^ ((packWord x).getLsbD 28 ^^ ((packWord x).getLsbD 41 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 0 (by decide), packWord_bit_nat x 21 (by decide), packWord_bit_nat x 28 (by decide), packWord_bit_nat x 41 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,0) ≠ 0) ^^ (decide (x (1,10) ≠ 0) ^^ (decide (x (2,6) ≠ 0) ^^ (decide (x (3,8) ≠ 0))))) = false ↔ x (0,0)+(x (1,10)+(x (2,6)+x (3,8))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_12 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 12) (packWord x) = false ↔ boundary x (checkEquiv.symm 12) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 1 ^^ ((packWord x).getLsbD 11 ^^ ((packWord x).getLsbD 29 ^^ ((packWord x).getLsbD 42 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 1 (by decide), packWord_bit_nat x 11 (by decide), packWord_bit_nat x 29 (by decide), packWord_bit_nat x 42 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,1) ≠ 0) ^^ (decide (x (1,0) ≠ 0) ^^ (decide (x (2,7) ≠ 0) ^^ (decide (x (3,9) ≠ 0))))) = false ↔ x (0,1)+(x (1,0)+(x (2,7)+x (3,9))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_13 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 13) (packWord x) = false ↔ boundary x (checkEquiv.symm 13) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 2 ^^ ((packWord x).getLsbD 12 ^^ ((packWord x).getLsbD 30 ^^ ((packWord x).getLsbD 43 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 2 (by decide), packWord_bit_nat x 12 (by decide), packWord_bit_nat x 30 (by decide), packWord_bit_nat x 43 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,2) ≠ 0) ^^ (decide (x (1,1) ≠ 0) ^^ (decide (x (2,8) ≠ 0) ^^ (decide (x (3,10) ≠ 0))))) = false ↔ x (0,2)+(x (1,1)+(x (2,8)+x (3,10))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_14 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 14) (packWord x) = false ↔ boundary x (checkEquiv.symm 14) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 3 ^^ ((packWord x).getLsbD 13 ^^ ((packWord x).getLsbD 31 ^^ ((packWord x).getLsbD 33 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 3 (by decide), packWord_bit_nat x 13 (by decide), packWord_bit_nat x 31 (by decide), packWord_bit_nat x 33 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,3) ≠ 0) ^^ (decide (x (1,2) ≠ 0) ^^ (decide (x (2,9) ≠ 0) ^^ (decide (x (3,0) ≠ 0))))) = false ↔ x (0,3)+(x (1,2)+(x (2,9)+x (3,0))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_15 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 15) (packWord x) = false ↔ boundary x (checkEquiv.symm 15) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 4 ^^ ((packWord x).getLsbD 14 ^^ ((packWord x).getLsbD 32 ^^ ((packWord x).getLsbD 34 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 4 (by decide), packWord_bit_nat x 14 (by decide), packWord_bit_nat x 32 (by decide), packWord_bit_nat x 34 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,4) ≠ 0) ^^ (decide (x (1,3) ≠ 0) ^^ (decide (x (2,10) ≠ 0) ^^ (decide (x (3,1) ≠ 0))))) = false ↔ x (0,4)+(x (1,3)+(x (2,10)+x (3,1))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_16 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 16) (packWord x) = false ↔ boundary x (checkEquiv.symm 16) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 5 ^^ ((packWord x).getLsbD 15 ^^ ((packWord x).getLsbD 22 ^^ ((packWord x).getLsbD 35 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 5 (by decide), packWord_bit_nat x 15 (by decide), packWord_bit_nat x 22 (by decide), packWord_bit_nat x 35 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,5) ≠ 0) ^^ (decide (x (1,4) ≠ 0) ^^ (decide (x (2,0) ≠ 0) ^^ (decide (x (3,2) ≠ 0))))) = false ↔ x (0,5)+(x (1,4)+(x (2,0)+x (3,2))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_17 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 17) (packWord x) = false ↔ boundary x (checkEquiv.symm 17) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 6 ^^ ((packWord x).getLsbD 16 ^^ ((packWord x).getLsbD 23 ^^ ((packWord x).getLsbD 36 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 6 (by decide), packWord_bit_nat x 16 (by decide), packWord_bit_nat x 23 (by decide), packWord_bit_nat x 36 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,6) ≠ 0) ^^ (decide (x (1,5) ≠ 0) ^^ (decide (x (2,1) ≠ 0) ^^ (decide (x (3,3) ≠ 0))))) = false ↔ x (0,6)+(x (1,5)+(x (2,1)+x (3,3))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_18 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 18) (packWord x) = false ↔ boundary x (checkEquiv.symm 18) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 7 ^^ ((packWord x).getLsbD 17 ^^ ((packWord x).getLsbD 24 ^^ ((packWord x).getLsbD 37 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 7 (by decide), packWord_bit_nat x 17 (by decide), packWord_bit_nat x 24 (by decide), packWord_bit_nat x 37 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,7) ≠ 0) ^^ (decide (x (1,6) ≠ 0) ^^ (decide (x (2,2) ≠ 0) ^^ (decide (x (3,4) ≠ 0))))) = false ↔ x (0,7)+(x (1,6)+(x (2,2)+x (3,4))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_19 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 19) (packWord x) = false ↔ boundary x (checkEquiv.symm 19) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 8 ^^ ((packWord x).getLsbD 18 ^^ ((packWord x).getLsbD 25 ^^ ((packWord x).getLsbD 38 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 8 (by decide), packWord_bit_nat x 18 (by decide), packWord_bit_nat x 25 (by decide), packWord_bit_nat x 38 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,8) ≠ 0) ^^ (decide (x (1,7) ≠ 0) ^^ (decide (x (2,3) ≠ 0) ^^ (decide (x (3,5) ≠ 0))))) = false ↔ x (0,8)+(x (1,7)+(x (2,3)+x (3,5))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_20 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 20) (packWord x) = false ↔ boundary x (checkEquiv.symm 20) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 9 ^^ ((packWord x).getLsbD 19 ^^ ((packWord x).getLsbD 26 ^^ ((packWord x).getLsbD 39 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 9 (by decide), packWord_bit_nat x 19 (by decide), packWord_bit_nat x 26 (by decide), packWord_bit_nat x 39 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,9) ≠ 0) ^^ (decide (x (1,8) ≠ 0) ^^ (decide (x (2,4) ≠ 0) ^^ (decide (x (3,6) ≠ 0))))) = false ↔ x (0,9)+(x (1,8)+(x (2,4)+x (3,6))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_21 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 21) (packWord x) = false ↔ boundary x (checkEquiv.symm 21) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 10 ^^ ((packWord x).getLsbD 20 ^^ ((packWord x).getLsbD 27 ^^ ((packWord x).getLsbD 40 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 10 (by decide), packWord_bit_nat x 20 (by decide), packWord_bit_nat x 27 (by decide), packWord_bit_nat x 40 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,10) ≠ 0) ^^ (decide (x (1,9) ≠ 0) ^^ (decide (x (2,5) ≠ 0) ^^ (decide (x (3,7) ≠ 0))))) = false ↔ x (0,10)+(x (1,9)+(x (2,5)+x (3,7))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_22 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 22) (packWord x) = false ↔ boundary x (checkEquiv.symm 22) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 0 ^^ ((packWord x).getLsbD 20 ^^ ((packWord x).getLsbD 23 ^^ ((packWord x).getLsbD 37 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 0 (by decide), packWord_bit_nat x 20 (by decide), packWord_bit_nat x 23 (by decide), packWord_bit_nat x 37 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,0) ≠ 0) ^^ (decide (x (1,9) ≠ 0) ^^ (decide (x (2,1) ≠ 0) ^^ (decide (x (3,4) ≠ 0))))) = false ↔ x (0,0)+(x (1,9)+(x (2,1)+x (3,4))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_23 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 23) (packWord x) = false ↔ boundary x (checkEquiv.symm 23) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 1 ^^ ((packWord x).getLsbD 21 ^^ ((packWord x).getLsbD 24 ^^ ((packWord x).getLsbD 38 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 1 (by decide), packWord_bit_nat x 21 (by decide), packWord_bit_nat x 24 (by decide), packWord_bit_nat x 38 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,1) ≠ 0) ^^ (decide (x (1,10) ≠ 0) ^^ (decide (x (2,2) ≠ 0) ^^ (decide (x (3,5) ≠ 0))))) = false ↔ x (0,1)+(x (1,10)+(x (2,2)+x (3,5))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_24 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 24) (packWord x) = false ↔ boundary x (checkEquiv.symm 24) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 2 ^^ ((packWord x).getLsbD 11 ^^ ((packWord x).getLsbD 25 ^^ ((packWord x).getLsbD 39 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 2 (by decide), packWord_bit_nat x 11 (by decide), packWord_bit_nat x 25 (by decide), packWord_bit_nat x 39 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,2) ≠ 0) ^^ (decide (x (1,0) ≠ 0) ^^ (decide (x (2,3) ≠ 0) ^^ (decide (x (3,6) ≠ 0))))) = false ↔ x (0,2)+(x (1,0)+(x (2,3)+x (3,6))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_25 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 25) (packWord x) = false ↔ boundary x (checkEquiv.symm 25) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 3 ^^ ((packWord x).getLsbD 12 ^^ ((packWord x).getLsbD 26 ^^ ((packWord x).getLsbD 40 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 3 (by decide), packWord_bit_nat x 12 (by decide), packWord_bit_nat x 26 (by decide), packWord_bit_nat x 40 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,3) ≠ 0) ^^ (decide (x (1,1) ≠ 0) ^^ (decide (x (2,4) ≠ 0) ^^ (decide (x (3,7) ≠ 0))))) = false ↔ x (0,3)+(x (1,1)+(x (2,4)+x (3,7))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_26 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 26) (packWord x) = false ↔ boundary x (checkEquiv.symm 26) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 4 ^^ ((packWord x).getLsbD 13 ^^ ((packWord x).getLsbD 27 ^^ ((packWord x).getLsbD 41 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 4 (by decide), packWord_bit_nat x 13 (by decide), packWord_bit_nat x 27 (by decide), packWord_bit_nat x 41 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,4) ≠ 0) ^^ (decide (x (1,2) ≠ 0) ^^ (decide (x (2,5) ≠ 0) ^^ (decide (x (3,8) ≠ 0))))) = false ↔ x (0,4)+(x (1,2)+(x (2,5)+x (3,8))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_27 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 27) (packWord x) = false ↔ boundary x (checkEquiv.symm 27) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 5 ^^ ((packWord x).getLsbD 14 ^^ ((packWord x).getLsbD 28 ^^ ((packWord x).getLsbD 42 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 5 (by decide), packWord_bit_nat x 14 (by decide), packWord_bit_nat x 28 (by decide), packWord_bit_nat x 42 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,5) ≠ 0) ^^ (decide (x (1,3) ≠ 0) ^^ (decide (x (2,6) ≠ 0) ^^ (decide (x (3,9) ≠ 0))))) = false ↔ x (0,5)+(x (1,3)+(x (2,6)+x (3,9))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_28 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 28) (packWord x) = false ↔ boundary x (checkEquiv.symm 28) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 6 ^^ ((packWord x).getLsbD 15 ^^ ((packWord x).getLsbD 29 ^^ ((packWord x).getLsbD 43 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 6 (by decide), packWord_bit_nat x 15 (by decide), packWord_bit_nat x 29 (by decide), packWord_bit_nat x 43 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,6) ≠ 0) ^^ (decide (x (1,4) ≠ 0) ^^ (decide (x (2,7) ≠ 0) ^^ (decide (x (3,10) ≠ 0))))) = false ↔ x (0,6)+(x (1,4)+(x (2,7)+x (3,10))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_29 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 29) (packWord x) = false ↔ boundary x (checkEquiv.symm 29) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 7 ^^ ((packWord x).getLsbD 16 ^^ ((packWord x).getLsbD 30 ^^ ((packWord x).getLsbD 33 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 7 (by decide), packWord_bit_nat x 16 (by decide), packWord_bit_nat x 30 (by decide), packWord_bit_nat x 33 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,7) ≠ 0) ^^ (decide (x (1,5) ≠ 0) ^^ (decide (x (2,8) ≠ 0) ^^ (decide (x (3,0) ≠ 0))))) = false ↔ x (0,7)+(x (1,5)+(x (2,8)+x (3,0))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_30 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 30) (packWord x) = false ↔ boundary x (checkEquiv.symm 30) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 8 ^^ ((packWord x).getLsbD 17 ^^ ((packWord x).getLsbD 31 ^^ ((packWord x).getLsbD 34 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 8 (by decide), packWord_bit_nat x 17 (by decide), packWord_bit_nat x 31 (by decide), packWord_bit_nat x 34 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,8) ≠ 0) ^^ (decide (x (1,6) ≠ 0) ^^ (decide (x (2,9) ≠ 0) ^^ (decide (x (3,1) ≠ 0))))) = false ↔ x (0,8)+(x (1,6)+(x (2,9)+x (3,1))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_31 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 31) (packWord x) = false ↔ boundary x (checkEquiv.symm 31) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 9 ^^ ((packWord x).getLsbD 18 ^^ ((packWord x).getLsbD 32 ^^ ((packWord x).getLsbD 35 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 9 (by decide), packWord_bit_nat x 18 (by decide), packWord_bit_nat x 32 (by decide), packWord_bit_nat x 35 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,9) ≠ 0) ^^ (decide (x (1,7) ≠ 0) ^^ (decide (x (2,10) ≠ 0) ^^ (decide (x (3,2) ≠ 0))))) = false ↔ x (0,9)+(x (1,7)+(x (2,10)+x (3,2))) = 0
  exact bool_four _ _ _ _
theorem kernel_row_32 (x : Var → ZMod 2) : dot (FamilyBase11.classicalRow 32) (packWord x) = false ↔ boundary x (checkEquiv.symm 32) = 0 := by
  rw [FamilyBase11.dot_row]
  change ((packWord x).getLsbD 10 ^^ ((packWord x).getLsbD 19 ^^ ((packWord x).getLsbD 22 ^^ ((packWord x).getLsbD 36 ^^ false)))) = false ↔ _
  simp only [Bool.xor_false]
  rw [packWord_bit_nat x 10 (by decide), packWord_bit_nat x 19 (by decide), packWord_bit_nat x 22 (by decide), packWord_bit_nat x 36 (by decide)]
  simp only [boundary,Fin.sum_univ_succ,Fin.sum_univ_zero,add_zero]
  change (decide (x (0,10) ≠ 0) ^^ (decide (x (1,8) ≠ 0) ^^ (decide (x (2,0) ≠ 0) ^^ (decide (x (3,3) ≠ 0))))) = false ↔ x (0,10)+(x (1,8)+(x (2,0)+x (3,3))) = 0
  exact bool_four _ _ _ _
theorem kernel_row (x : Var → ZMod 2) (c : Fin 33) : dot (FamilyBase11.classicalRow c) (packWord x) = false ↔ boundary x (checkEquiv.symm c) = 0 := by
  fin_cases c
  · exact kernel_row_0 x
  · exact kernel_row_1 x
  · exact kernel_row_2 x
  · exact kernel_row_3 x
  · exact kernel_row_4 x
  · exact kernel_row_5 x
  · exact kernel_row_6 x
  · exact kernel_row_7 x
  · exact kernel_row_8 x
  · exact kernel_row_9 x
  · exact kernel_row_10 x
  · exact kernel_row_11 x
  · exact kernel_row_12 x
  · exact kernel_row_13 x
  · exact kernel_row_14 x
  · exact kernel_row_15 x
  · exact kernel_row_16 x
  · exact kernel_row_17 x
  · exact kernel_row_18 x
  · exact kernel_row_19 x
  · exact kernel_row_20 x
  · exact kernel_row_21 x
  · exact kernel_row_22 x
  · exact kernel_row_23 x
  · exact kernel_row_24 x
  · exact kernel_row_25 x
  · exact kernel_row_26 x
  · exact kernel_row_27 x
  · exact kernel_row_28 x
  · exact kernel_row_29 x
  · exact kernel_row_30 x
  · exact kernel_row_31 x
  · exact kernel_row_32 x
theorem packWord_weight (x : Var → ZMod 2) : (packWord x).cpop.toNat = (CoverWeight.support x).card := by
  unfold packWord
  rw [BinaryFinite.pack44_weight]
  exact Finset.card_equiv varEquiv.symm (fun v => by simp [CoverWeight.support])

theorem code_lower_twelve (x : Var → ZMod 2) (hx : ∀ c, boundary x c = 0) (hn : x ≠ 0) :
    12 ≤ (CoverWeight.support x).card := by
  have hk : FamilyBase11.ClassicalKernel (packWord x) := fun c => (kernel_row x c).mpr (hx _)
  have hp : packWord x ≠ 0 := by
    intro hz
    apply hn
    funext v
    have hb := packWord_bit x (varEquiv v)
    rw [hz] at hb
    have hh : decide (x v ≠ 0) = false := by simpa using hb.symm
    exact not_ne_iff.mp (of_decide_eq_false hh)
  rcases FamilyClassical11.actual_classical_lower (packWord x) hk with hz | hl
  · exact False.elim (hp hz)
  · rwa [packWord_weight] at hl
#print axioms code_lower_twelve
end FamilyBaseGraph
