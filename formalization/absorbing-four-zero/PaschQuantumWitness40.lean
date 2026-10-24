import PaschQuantumBridge
import PaschSTS13Counts
import PaschComplexCount

set_option maxHeartbeats 0
open scoped BigOperators
namespace PaschQuantumWitness40
open PaschKernelCount PaschQuantumBridge PaschComplexCount
abbrev P := Sum (Fin 26) (Fin 13)
abbrev R := Fin 13
abbrev G := ZMod 7

theorem source_count_A : count40
    (CyclicNormalization.incidence (sockets PaschSTS13.baseA)) = 182 := by
  rw [socket_count40_eq]
  exact PaschSTS13.hgp_count_A

theorem source_count_B : count40
    (CyclicNormalization.incidence (sockets PaschSTS13.baseB)) = 147 := by
  rw [socket_count40_eq]
  exact PaschSTS13.hgp_count_B

theorem identical_actual_complex_M :
    fullM PaschSTS13.baseA = fullM PaschSTS13.baseB :=
  fullM_eq_of_Gram _ _ PaschSTS13.equal_point_Gram

/-- The entire list of evaluated Hermitian matrices, not just eigenvalues,
fails to determine the actual (4,0) count in this source-family pair. -/
theorem no_actual_complex_M_only_count40 :
    ¬ ∃ f : (G → R → R → ℂ) → ℕ,
      f (fullM PaschSTS13.baseA) = count40
        (CyclicNormalization.incidence (sockets PaschSTS13.baseA)) ∧
      f (fullM PaschSTS13.baseB) = count40
        (CyclicNormalization.incidence (sockets PaschSTS13.baseB)) := by
  rintro ⟨f,ha,hb⟩
  rw [identical_actual_complex_M,source_count_A] at ha
  rw [source_count_B] at hb
  omega

theorem actual_A_complex_formula :
    (182 : ℝ) = (7 / 24 : ℝ) * ∑ p : P, ∑ q : P, ∑ d : G,
      complexRootSummand40 (sockets PaschSTS13.baseA) p q d := by
  have h := complex_root_count40_formula (sockets PaschSTS13.baseA)
    (socket_cubic _ PaschSTS13.cubic_A) (socket_linear _ PaschSTS13.linear_A)
  simpa only [source_count_A,Nat.cast_ofNat] using h

theorem actual_B_complex_formula :
    (147 : ℝ) = (7 / 24 : ℝ) * ∑ p : P, ∑ q : P, ∑ d : G,
      complexRootSummand40 (sockets PaschSTS13.baseB) p q d := by
  have h := complex_root_count40_formula (sockets PaschSTS13.baseB)
    (socket_cubic _ PaschSTS13.cubic_B) (socket_linear _ PaschSTS13.linear_B)
  simpa only [source_count_B,Nat.cast_ofNat] using h

theorem actual_binary_kernel_A : weightFourKernelCount
    (CyclicNormalization.incidence (sockets PaschSTS13.baseA)) = 182 := by
  rw [← count40_eq_weightFourKernelCount _ (socket_cubic _ PaschSTS13.cubic_A)
    (socket_linear _ PaschSTS13.linear_A)]
  exact source_count_A

theorem actual_binary_kernel_B : weightFourKernelCount
    (CyclicNormalization.incidence (sockets PaschSTS13.baseB)) = 147 := by
  rw [← count40_eq_weightFourKernelCount _ (socket_cubic _ PaschSTS13.cubic_B)
    (socket_linear _ PaschSTS13.linear_B)]
  exact source_count_B

theorem dimensions : Fintype.card (P × G) = 273 ∧ Fintype.card (R × G) = 91 := by
  norm_num [P,R,G,Fintype.card_prod,Fintype.card_sum]

theorem product_CSS_A (r : Fin 13 × Fin 7) (s : Fin 26 × Fin 7) :
    ∑ v, HGPCSS.X PaschSTS13.baseA FanoBlock.columns r v *
      HGPCSS.Z PaschSTS13.baseA FanoBlock.columns s v = 0 :=
  HGPCSS.commute _ _ r s

theorem product_CSS_B (r : Fin 13 × Fin 7) (s : Fin 26 × Fin 7) :
    ∑ v, HGPCSS.X PaschSTS13.baseB FanoBlock.columns r v *
      HGPCSS.Z PaschSTS13.baseB FanoBlock.columns s v = 0 :=
  HGPCSS.commute _ _ r s

#print axioms source_count_A
#print axioms source_count_B
#print axioms identical_actual_complex_M
#print axioms no_actual_complex_M_only_count40
#print axioms actual_A_complex_formula
#print axioms actual_B_complex_formula
#print axioms actual_binary_kernel_A
#print axioms product_CSS_A
end PaschQuantumWitness40
