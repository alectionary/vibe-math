import PaschCubicTrade

set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace StarKernelCertificate
open PaschCubicTrade

def kernelSupports : Finset (Finset (Fin 10)) :=
  (Finset.univ : Finset (Fin 10)).powerset.filter
    (fun S => ∀ c, (GlobalCounting.selected baseA S c).card % 2=0)

def listedKernel : Finset (Finset (Fin 10)) :=
  {∅,{0,1,2,3},{0,1,5,6,7,8},{0,2,4,6,7,9},{0,3,4,5,8,9},
    {1,2,4,5,8,9},{1,3,4,6,7,9},{2,3,5,6,7,8}}

/-- Complete binary kernel, not merely selected example dependencies. -/
theorem complete_kernel : kernelSupports=listedKernel := by decide

theorem kernel_card : kernelSupports.card=8 := by rw [complete_kernel]; decide

def logicalBase : Finset (Fin 10) := {2,3,5,6,7,8}

theorem logical_base_even : ∀ c,
    (GlobalCounting.selected baseA logicalBase c).card % 2=0 := by decide

theorem logical_base_size : logicalBase.card=6 := by decide

theorem avoids_modified_variables : (0 : Fin 10) ∉ logicalBase ∧ (4 : Fin 10) ∉ logicalBase := by decide

#print axioms complete_kernel
#print axioms kernel_card
#print axioms logical_base_even
#print axioms logical_base_size
#print axioms avoids_modified_variables
end StarKernelCertificate
