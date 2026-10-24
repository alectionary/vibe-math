import PaschSTS13

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace PaschSTS13
open PaschKernelCount PaschGlobalCount

theorem root_mass_A : rootSum40 baseA = 312 := by decide
theorem root_mass_B : rootSum40 baseB = 192 := by decide

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
