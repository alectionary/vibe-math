import PaschSTS13

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators
namespace PaschSTS13
open PaschKernelCount PaschGlobalCount

def rowMassA (u : Fin 26) : ℕ :=
  match u.val with
  | 0 => 6
  | 1 => 18
  | 2 => 6
  | 3 => 18
  | 4 => 18
  | 5 => 6
  | 6 => 6
  | 7 => 18
  | 8 => 18
  | 9 => 18
  | 10 => 6
  | 11 => 6
  | 12 => 18
  | 13 => 18
  | 14 => 6
  | 15 => 6
  | 16 => 18
  | 17 => 18
  | 18 => 6
  | 19 => 18
  | 20 => 18
  | 21 => 6
  | 22 => 18
  | 23 => 6
  | 24 => 6
  | 25 => 6
  | _ => 0

theorem row_certificate_A (u : Fin 26) :
    (∑ v : Fin 26, PaschCyclicCount.rootTerm40 baseA u v) = rowMassA u := by
  fin_cases u <;> decide

theorem root_mass_A : rootSum40 baseA = 312 := by
  rw [PaschCyclicCount.rootSum40_univ]
  simp_rw [row_certificate_A]
  decide

def rowMassB (u : Fin 26) : ℕ :=
  match u.val with
  | 0 => 6
  | 1 => 12
  | 2 => 6
  | 3 => 6
  | 4 => 18
  | 5 => 0
  | 6 => 6
  | 7 => 12
  | 8 => 6
  | 9 => 12
  | 10 => 6
  | 11 => 6
  | 12 => 12
  | 13 => 6
  | 14 => 6
  | 15 => 6
  | 16 => 6
  | 17 => 12
  | 18 => 6
  | 19 => 12
  | 20 => 6
  | 21 => 0
  | 22 => 12
  | 23 => 6
  | 24 => 6
  | 25 => 0
  | _ => 0

theorem row_certificate_B (u : Fin 26) :
    (∑ v : Fin 26, PaschCyclicCount.rootTerm40 baseB u v) = rowMassB u := by
  fin_cases u <;> decide

theorem root_mass_B : rootSum40 baseB = 192 := by
  rw [PaschCyclicCount.rootSum40_univ]
  simp_rw [row_certificate_B]
  decide


theorem count_A : count40 baseA = 13 := by
  have h := rootSum40_eq baseA cubic_A linear_A
  rw [root_mass_A] at h
  omega

theorem count_B : count40 baseB = 8 := by
  have h := rootSum40_eq baseB cubic_B linear_B
  rw [root_mass_B] at h
  omega

theorem hgp_count_A : count40 (HGPIncidence.columns baseA FanoBlock.columns) = 182 := by
  rw [PaschHGPCount.count40_product baseA FanoBlock.columns cubic_A FanoBlock.cubic linear_A FanoBlock.linear,
    count_A,PaschConsumers.fano_count]
  norm_num

theorem hgp_count_B : count40 (HGPIncidence.columns baseB FanoBlock.columns) = 147 := by
  rw [PaschHGPCount.count40_product baseB FanoBlock.columns cubic_B FanoBlock.cubic linear_B FanoBlock.linear,
    count_B,PaschConsumers.fano_count]
  norm_num

#print axioms count_A
#print axioms count_B
#print axioms hgp_count_A
#print axioms hgp_count_B
end PaschSTS13
