import SourceDistance
import SourceCoordinates
set_option maxHeartbeats 0
namespace SourceWordBridge
variable {L : Nat} [NeZero L]
open FamilyWords SourceModel

def Kernel {Row : Type*} [Fintype Row] (H : Row → Qubit L → ZMod 2) (w : Qubit L → ZMod 2) :=
  ∀ c, ∑ q, H c q * w q = 0

def InSpan {Row : Type*} [Fintype Row] (H : Row → Qubit L → ZMod 2) (w : Qubit L → ZMod 2) :=
  ∃ a : Row → ZMod 2, ∀ q, w q = ∑ c, a c * H c q

def QuantumHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ w : Qubit L → ZMod 2,
    ((Kernel HZ w ∧ ¬ InSpan HX w) ∨ (Kernel HX w ∧ ¬ InSpan HZ w)) ∧
      (CoverWeight.support w).card = n

theorem block_weight_iff (n : Nat) : QuantumHasWeight L n ↔ SourceDistance.QuantumHasWeight L n := by
  constructor
  · rintro ⟨w,hw,hn⟩
    obtain ⟨u,v,rfl⟩ := SourceModel.join_surjective w
    exact ⟨u,v,hw,hn⟩
  · rintro ⟨u,v,hw,hn⟩
    exact ⟨SourceModel.join u v,hw,hn⟩

theorem quantum_weight_iff (n : Nat) : QuantumHasWeight L n ↔ DistanceFamily.QuantumHasWeight L n :=
  (block_weight_iff n).trans (SourceDistance.quantum_weight_iff n)

noncomputable instance : DecidablePred (QuantumHasWeight L) := fun _ => Classical.propDecidable _
noncomputable instance : DecidablePred (SourceDistance.ClassicalHasWeight L) := fun _ => Classical.propDecidable _

theorem quantum_exists : ∃ n, QuantumHasWeight L n := by
  obtain ⟨n,hn⟩ := DistanceFamily.quantum_exists (L := L)
  exact ⟨n,(quantum_weight_iff n).mpr hn⟩

theorem classical_exists : ∃ n, SourceDistance.ClassicalHasWeight L n := by
  obtain ⟨n,hn⟩ := DistanceFamily.classical_exists (L := L)
  exact ⟨n,(SourceDistance.classical_weight_iff n).mpr hn⟩

noncomputable def quantumDistance (L : Nat) [NeZero L] : Nat := Nat.find (quantum_exists (L := L))
noncomputable def classicalDistance (L : Nat) [NeZero L] : Nat := Nat.find (classical_exists (L := L))

theorem quantum_distance_eq : quantumDistance L = DistanceFamily.quantumDistance L := by
  apply Nat.le_antisymm
  · exact Nat.find_min' _ ((quantum_weight_iff _).mpr (Nat.find_spec (DistanceFamily.quantum_exists (L := L))))
  · exact Nat.find_min' _ ((quantum_weight_iff _).mp (Nat.find_spec (quantum_exists (L := L))))

theorem classical_distance_eq : classicalDistance L = DistanceFamily.classicalDistance L := by
  apply Nat.le_antisymm
  · exact Nat.find_min' _ ((SourceDistance.classical_weight_iff _).mpr (Nat.find_spec (DistanceFamily.classical_exists (L := L))))
  · exact Nat.find_min' _ ((SourceDistance.classical_weight_iff _).mp (Nat.find_spec (classical_exists (L := L))))

/-- Distances minimize over ALL source binary words and full row spans. -/
theorem source_distance_drop (hL : 11 ∣ L) :
    quantumDistance L ≤ 11 ∧ 12 ≤ classicalDistance L ∧ quantumDistance L < classicalDistance L := by
  rw [quantum_distance_eq,classical_distance_eq]
  exact ⟨DistanceFamily.quantum_distance_upper,DistanceFamily.classical_distance_lower hL,
    DistanceFamily.distance_drop hL⟩

/-- Commutation of the actual source coefficient matrices, not merely of a
finite sampled expansion. -/
theorem css_commutation (a : XCheck L) (b : ZCheck L) :
    (∑ q, HZ b q * HX a q) = 0 := by
  let w : Fin 3 → Fin 4 → ZMod L → ZMod 2 := fun i j s => if ((i,j),s)=a then 1 else 0
  have he : ∀ q, SourceModel.join (stabilizerLeft w) (stabilizerRight w) q = HX a q := by
    intro q
    cases q with
    | inl p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      change stabilizerLeft w i j s = _
      rw [← x_span_left w i j s]
      simp [w]
    | inr p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      change stabilizerRight w i j s = _
      rw [← x_span_right w i j s]
      simp [w]
  calc
    (∑ q, HZ b q * HX a q) =
      ∑ q, HZ b q * SourceModel.join (stabilizerLeft w) (stabilizerRight w) q := by simp only [he]
    _ = Syndrome (stabilizerLeft w) (stabilizerRight w) b.1.1 b.1.2 b.2 := z_action _ _ _ _ _
    _ = 0 := FamilyWords.css_commutation w _ _ _

#print axioms quantum_weight_iff
#print axioms source_distance_drop
#print axioms css_commutation
end SourceWordBridge
