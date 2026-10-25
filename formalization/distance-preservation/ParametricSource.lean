import ParametricWords
import GeneralLPPhysical
set_option maxHeartbeats 0
namespace ParametricWords
variable {L : Nat} [NeZero L]

/-- The full source-matrix obstruction, including CSS commutation, arbitrary
stabilizer coefficients and physical-coordinate Hamming weight. -/
theorem source_parametric_obstruction (a b : ZMod L) :
    (∀ c : GeneralLP.XCheck L, ∀ d : GeneralLP.ZCheck L,
      (∑ q, GeneralLP.HZ (e a b) d q * GeneralLP.HX (e a b) c q)=0) ∧
    GeneralLP.LogicalX (e a b) (U a b) V ∧
    (CoverWeight.support (GeneralLP.join (U a b) V)).card≤11 :=
  ⟨GeneralLP.css_commutation (e a b),parametric_obstruction a b⟩

#print axioms source_parametric_obstruction
end ParametricWords
