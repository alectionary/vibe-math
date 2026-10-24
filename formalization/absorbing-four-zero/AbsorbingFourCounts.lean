import PaschComplexCount
import PaschBeezerBridge
import PaschAbsorbingBridge
import PaschQuantumWitness40
import PaschDesignData
import PaschCubicTrade

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourCounts
open CyclicNormalization AbsorbingFourier PaschComplexCount
variable {N : ℕ} [NeZero N]
variable {P R : Type*} [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

/-- The two components of the source's four-variable question, with the
necessary full-incidence data and literal standard complex Fourier transform.
Counts are over actual unordered supports, and both absorbing conditions are
proved in the imported general classification modules. -/
theorem explicit_cubic_cyclic_four_counts (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    ((GlobalCounting.count42 (incidence sockets) : ℝ) = ((N : ℝ) / 4) *
      ∑ p : P, ∑ q : P, ∑ d : ZMod N, complexRootSummand sockets p q d) ∧
    ((PaschKernelCount.count40 (incidence sockets) : ℝ) = ((N : ℝ) / 24) *
      ∑ p : P, ∑ q : P, ∑ d : ZMod N, complexRootSummand40 sockets p q d) :=
  ⟨complex_root_count_formula sockets hd h4,complex_root_count40_formula sockets hd h4⟩

#print axioms explicit_cubic_cyclic_four_counts
end AbsorbingFourCounts

#print axioms PaschQuantumWitness40.no_actual_complex_M_only_count40
#print axioms PaschQuantumWitness40.actual_A_complex_formula
#print axioms PaschQuantumWitness40.actual_B_complex_formula
#print axioms PaschAbsorbingBridge.counted_support_is_absorbing40
#print axioms PaschCubicTrade.no_actual_complex_M_only_count40
#print axioms PaschCubicTrade.product_A_check_degree
