import PaschDesignData
import PaschQuantumWitness40

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators
namespace PaschCubicTrade
open PaschKernelCount PaschGlobalCount PaschQuantumBridge PaschComplexCount

def baseA (v : Fin 10) : Finset (Fin 10) :=
  match v.val with
  | 0 => {0,1,2}
  | 1 => {0,3,4}
  | 2 => {1,3,5}
  | 3 => {2,4,5}
  | 4 => {0,6,7}
  | 5 => {1,6,8}
  | 6 => {2,6,9}
  | 7 => {3,7,8}
  | 8 => {4,7,9}
  | 9 => {5,8,9}
  | _ => ∅

def baseB (v : Fin 10) : Finset (Fin 10) :=
  match v.val with
  | 0 => {3,4,5}
  | 1 => {1,2,5}
  | 2 => {0,2,4}
  | 3 => {0,1,3}
  | 4 => {0,6,7}
  | 5 => {1,6,8}
  | 6 => {2,6,9}
  | 7 => {3,7,8}
  | 8 => {4,7,9}
  | 9 => {5,8,9}
  | _ => ∅

theorem cubic_A : ∀ v, (baseA v).card = 3 := by decide
theorem cubic_B : ∀ v, (baseB v).card = 3 := by decide
theorem linear_A : ∀ u v, u ≠ v → (baseA u ∩ baseA v).card ≤ 1 := by decide
theorem linear_B : ∀ u v, u ≠ v → (baseB u ∩ baseB v).card ≤ 1 := by decide
theorem equal_point_Gram : HGPGramObstruction.checkGram baseA =
    HGPGramObstruction.checkGram baseB := by
  funext c d
  have h : ∀ c d, HGPGramObstruction.checkGram baseA c d =
    HGPGramObstruction.checkGram baseB c d := by decide
  exact h c d

theorem diagonal_A : ∀ c : Fin 10, HGPGramObstruction.checkGram baseA c c = 3 := by decide
theorem diagonal_B (c : Fin 10) : HGPGramObstruction.checkGram baseB c c = 3 := by
  rw [← equal_point_Gram]; exact diagonal_A c

theorem root_mass_A : rootSum40 baseA = 24 := by
  rw [PaschCyclicCount.rootSum40_univ]
  decide
theorem root_mass_B : rootSum40 baseB = 120 := by
  rw [PaschCyclicCount.rootSum40_univ]
  decide
theorem count_A : count40 baseA = 1 := by
  have h := rootSum40_eq baseA cubic_A linear_A
  rw [root_mass_A] at h
  omega
theorem count_B : count40 baseB = 5 := by
  have h := rootSum40_eq baseB cubic_B linear_B
  rw [root_mass_B] at h
  omega

theorem hgp_count_A : count40 (HGPIncidence.columns baseA FanoBlock.columns) = 77 := by
  rw [PaschHGPCount.count40_product baseA FanoBlock.columns cubic_A FanoBlock.cubic
    linear_A FanoBlock.linear,count_A,PaschConsumers.fano_count]
  norm_num
theorem hgp_count_B : count40 (HGPIncidence.columns baseB FanoBlock.columns) = 105 := by
  rw [PaschHGPCount.count40_product baseB FanoBlock.columns cubic_B FanoBlock.cubic
    linear_B FanoBlock.linear,count_B,PaschConsumers.fano_count]
  norm_num

theorem source_count_A : count40 (CyclicNormalization.incidence (sockets baseA)) = 77 := by
  rw [socket_count40_eq]; exact hgp_count_A
theorem source_count_B : count40 (CyclicNormalization.incidence (sockets baseB)) = 105 := by
  rw [socket_count40_eq]; exact hgp_count_B
theorem identical_actual_complex_M : fullM baseA = fullM baseB :=
  fullM_eq_of_Gram _ _ equal_point_Gram
theorem no_actual_complex_M_only_count40 :
    ¬ ∃ f : (ZMod 7 → Fin 10 → Fin 10 → ℂ) → ℕ,
      f (fullM baseA) = count40 (CyclicNormalization.incidence (sockets baseA)) ∧
      f (fullM baseB) = count40 (CyclicNormalization.incidence (sockets baseB)) := by
  rintro ⟨f,ha,hb⟩
  rw [identical_actual_complex_M,source_count_A] at ha
  rw [source_count_B] at hb
  omega

theorem product_A_check_degree (c : Fin 10) (a : Fin 7) :
    HGPGramObstruction.checkGram (HGPIncidence.columns baseA FanoBlock.columns) (c,a) (c,a) = 6 := by
  rw [HGPGramObstruction.gram_product]
  simp [diagonal_A,PaschDesignData.fano_diagonal]
theorem product_B_check_degree (c : Fin 10) (a : Fin 7) :
    HGPGramObstruction.checkGram (HGPIncidence.columns baseB FanoBlock.columns) (c,a) (c,a) = 6 := by
  rw [HGPGramObstruction.gram_product]
  simp [diagonal_B,PaschDesignData.fano_diagonal]

theorem dimensions : Fintype.card (Sum (Fin 10) (Fin 10) × ZMod 7) = 140 ∧
    Fintype.card (Fin 10 × ZMod 7) = 70 := by
  norm_num [Fintype.card_prod,Fintype.card_sum]

theorem actual_A_complex_formula : (77 : ℝ) = (7 / 24 : ℝ) *
    ∑ p : Sum (Fin 10) (Fin 10), ∑ q : Sum (Fin 10) (Fin 10), ∑ d : ZMod 7,
      complexRootSummand40 (sockets baseA) p q d := by
  have h := complex_root_count40_formula (sockets baseA) (socket_cubic _ cubic_A)
    (socket_linear _ linear_A)
  simpa only [source_count_A,Nat.cast_ofNat] using h
theorem actual_B_complex_formula : (105 : ℝ) = (7 / 24 : ℝ) *
    ∑ p : Sum (Fin 10) (Fin 10), ∑ q : Sum (Fin 10) (Fin 10), ∑ d : ZMod 7,
      complexRootSummand40 (sockets baseB) p q d := by
  have h := complex_root_count40_formula (sockets baseB) (socket_cubic _ cubic_B)
    (socket_linear _ linear_B)
  simpa only [source_count_B,Nat.cast_ofNat] using h

#print axioms count_A
#print axioms count_B
#print axioms source_count_A
#print axioms source_count_B
#print axioms no_actual_complex_M_only_count40
#print axioms product_A_check_degree
#print axioms product_B_check_degree
#print axioms actual_A_complex_formula
#print axioms actual_B_complex_formula
end PaschCubicTrade
