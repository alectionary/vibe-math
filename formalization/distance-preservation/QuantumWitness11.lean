import QuantumRows11
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace Source11
open BinaryWords
def quantumWitness : BitVec 275 := 7067389944110605749759358838096262005820938878864744263789423881588047873#275
def separator : BitVec 275 := 36011204832921599#275
theorem witness_kernel : ∀ c, dot (zRow c) quantumWitness = false := by
  simp only [z_data_bridge]
  apply forall_fin_of_all
  decide +kernel
#print axioms witness_kernel
theorem separator_kernel : ∀ c, dot separator (xRow c) = false := by
  simp only [x_data_bridge]
  apply forall_fin_of_all
  decide +kernel
#print axioms separator_kernel
theorem separates : dot separator quantumWitness = true := by decide +kernel
theorem witness_nontrivial : ¬ InRowSpan xRow quantumWitness := not_in_row_span xRow separator quantumWitness separator_kernel separates
theorem witness_weight : quantumWitness.cpop.toNat = 11 := by decide +kernel
def classicalWitness : BitVec 44 := 30232757315#44
theorem classical_witness_kernel : ClassicalKernel classicalWitness := by
  unfold ClassicalKernel
  apply forall_fin_of_all
  decide +kernel
theorem classical_witness_weight : classicalWitness.cpop.toNat = 12 := by decide +kernel

#print axioms witness_nontrivial
#print axioms witness_kernel
end Source11
