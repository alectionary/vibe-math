import ComplexQuantumWitness

set_option maxHeartbeats 0
set_option backward.isDefEq.respectTransparency.types false
open scoped BigOperators
namespace ComplexQuantumFormula
open AbsorbingFourier ComplexQuantumWitness

theorem socket_cubic (base : Absorbing42Small.Incidence)
    (hb : Absorbing42Small.CubicLinear base) :
    ∀ v, (CyclicNormalization.incidence (sockets base) v).card = 3 := by
  intro v
  have h := congrArg Finset.card (source_incidence_bridge base v)
  exact h.symm.trans (HGPCounts.cubic base FanoBlock.columns hb.1 FanoBlock.cubic (variableEquiv v))

theorem socket_linear (base : Absorbing42Small.Incidence)
    (hb : Absorbing42Small.CubicLinear base) :
    ∀ u v, u ≠ v →
      (CyclicNormalization.incidence (sockets base) u ∩
       CyclicNormalization.incidence (sockets base) v).card ≤ 1 := by
  intro u v huv
  have he := congrArg Finset.card
    (congrArg₂ (fun (A B : Finset (R × G)) => A ∩ B)
      (source_incidence_bridge base u) (source_incidence_bridge base v))
  rw [← he]
  exact HGPCounts.linear base FanoBlock.columns hb.2.2 FanoBlock.linear _ _
    (fun h => huv (variableEquiv.injective h))

/-- The general standard-complex formula applies to the actual A witness,
with every cubic/no-four-cycle premise discharged by the binary model. -/
theorem actual_A_complex_formula :
    (49 : ℝ) = (7 / 4 : ℝ) * ∑ p : P, ∑ q : P, ∑ d : G,
      complexRootSummand (sockets Absorbing42Small.baseA) p q d := by
  have h := complex_root_count_formula (sockets Absorbing42Small.baseA)
    (socket_cubic _ Absorbing42Small.baseA_cubic_linear)
    (socket_linear _ Absorbing42Small.baseA_cubic_linear)
  simpa only [count_A, Nat.cast_ofNat] using h

theorem actual_B_complex_formula :
    (35 : ℝ) = (7 / 4 : ℝ) * ∑ p : P, ∑ q : P, ∑ d : G,
      complexRootSummand (sockets Absorbing42Small.baseB) p q d := by
  have h := complex_root_count_formula (sockets Absorbing42Small.baseB)
    (socket_cubic _ Absorbing42Small.baseB_cubic_linear)
    (socket_linear _ Absorbing42Small.baseB_cubic_linear)
  simpa only [count_B, Nat.cast_ofNat] using h

#print axioms socket_cubic
#print axioms socket_linear
#print axioms actual_A_complex_formula
#print axioms actual_B_complex_formula
end ComplexQuantumFormula
