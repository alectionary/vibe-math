import ThroughEleven
import DistanceMinima
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : ℕ} [NeZero L]

/-- Literal source-distance statement, with the transpose infinity convention
and the complete Pauli quotient. No finite-catalog premise remains. -/
theorem source_distance_bound_twelve
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (hT : (sourceClassicalDistance e : ℕ∞)≤sourceTransposeDistance e) :
    ((min (sourceClassicalDistance e) 12 : ℕ) : ℕ∞)≤sourceQuantumDistance e := by
  apply (source_quantum_minimum_lower_iff e _).mpr
  exact source_pauli_bound_twelve e h4 h6 hR0 hC0 hCP hP (sourceClassicalDistance e)
    (source_classical_minimum_lower e) (source_transpose_comparison_lower e _ hT)

#print axioms source_distance_bound_twelve
end TruncatedDistance
