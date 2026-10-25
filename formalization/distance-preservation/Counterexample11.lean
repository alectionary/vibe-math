import QuantumWitness11
import CSS11
import Hypotheses11

set_option maxHeartbeats 0
namespace Source11
open BinaryWords ClassicalCertificate11

def ClassicalHasWeight (w : Nat) : Prop :=
  ∃ x : BitVec 44, ClassicalKernel x ∧ x ≠ 0 ∧ x.cpop.toNat = w
def QuantumHasWeight (w : Nat) : Prop :=
  ∃ x : BitVec 275,
    (((∀ c, dot (zRow c) x = false) ∧ ¬ InRowSpan xRow x) ∨
     ((∀ c, dot (xRow c) x = false) ∧ ¬ InRowSpan zRow x)) ∧ x.cpop.toNat = w

noncomputable instance : DecidablePred ClassicalHasWeight := fun _ => Classical.propDecidable _
noncomputable instance : DecidablePred QuantumHasWeight := fun _ => Classical.propDecidable _

theorem classical_has_twelve : ClassicalHasWeight 12 := by
  refine ⟨classicalWitness, classical_witness_kernel, ?_, classical_witness_weight⟩
  intro h
  have hw := classical_witness_weight
  rw [h] at hw
  simp at hw
theorem quantum_has_eleven : QuantumHasWeight 11 :=
  ⟨quantumWitness, Or.inl ⟨witness_kernel,witness_nontrivial⟩,witness_weight⟩

noncomputable def classicalDistance : Nat := Nat.find (show ∃ w, ClassicalHasWeight w from ⟨12,classical_has_twelve⟩)
noncomputable def quantumDistance : Nat := Nat.find (show ∃ w, QuantumHasWeight w from ⟨11,quantum_has_eleven⟩)

theorem classical_distance_twelve : classicalDistance = 12 := by
  have hu : classicalDistance ≤ 12 := Nat.find_min' _ classical_has_twelve
  obtain ⟨x,hk,hn,hw⟩ := Nat.find_spec (show ∃ w, ClassicalHasWeight w from ⟨12,classical_has_twelve⟩)
  have hl := actual_classical_lower x hk
  rcases hl with hz | hl
  · exact False.elim (hn hz)
  · change x.cpop.toNat = classicalDistance at hw
    omega

theorem quantum_distance_at_most_eleven : quantumDistance ≤ 11 :=
  Nat.find_min' _ quantum_has_eleven

/-- The numerical distance-preservation conclusion fails for the source matrices. -/
theorem distance_drop : quantumDistance < classicalDistance := by
  rw [classical_distance_twelve]
  have := quantum_distance_at_most_eleven
  omega

/-- The finite obstruction to our proposed girth/pairing sufficient criterion. -/
theorem diagnostic_refuted :
    VoltageCycles.NoFourVoltage voltage ∧ VoltageCycles.NoSixVoltage voltage ∧
    ¬ RowPairing ∧ ¬ ColumnPairing ∧ classicalDistance = 12 ∧ quantumDistance ≤ 11 :=
  ⟨no_four_voltage,no_six_voltage,no_row_pairing,no_column_pairing,
    classical_distance_twelve,quantum_distance_at_most_eleven⟩

#print axioms classical_distance_twelve
#print axioms quantum_distance_at_most_eleven
#print axioms distance_drop
#print axioms diagnostic_refuted
end Source11
