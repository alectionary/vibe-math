import ParametricProjection
import SourceDistance
set_option maxHeartbeats 0
namespace ParametricSpecialization
variable {L : Nat} [NeZero L]

theorem exponent_matrix : ParametricWords.e (1 : ZMod L) 5=DistanceFamily.liftE := by
  funext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [ParametricWords.e,DistanceFamily.liftE,FamilyWords.exponent]

theorem HX_matrix : GeneralLP.HX (ParametricWords.e (1 : ZMod L) 5)=SourceModel.HX := by
  rw [exponent_matrix]
  funext c q
  cases q with
  | inl p => rcases p with ⟨⟨i,j⟩,s⟩; rfl
  | inr p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    simp [GeneralLP.HX,GeneralLP.P,SourceModel.HX,DistanceFamily.liftE]

theorem HZ_matrix : GeneralLP.HZ (ParametricWords.e (1 : ZMod L) 5)=SourceModel.HZ := by
  rw [exponent_matrix]
  funext c q
  cases q with
  | inl p => rcases p with ⟨⟨i,j⟩,s⟩; rfl
  | inr p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    simp [GeneralLP.HZ,GeneralLP.P,SourceModel.HZ,DistanceFamily.liftE]

theorem classical_matrix : GeneralLP.C (ParametricWords.e (1 : ZMod L) 5)=SourceDistance.C := by
  rw [exponent_matrix]
  rfl

theorem left_word : ParametricWords.U (1 : ZMod L) 5=FamilyWords.U := by
  funext i j s
  fin_cases i <;> fin_cases j <;> norm_num [ParametricWords.U,FamilyWords.U]

theorem logicalX (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.LogicalX (ParametricWords.e (1 : ZMod L) 5) u v ↔ SourceDistance.LogicalX u v := by
  simp only [GeneralLP.LogicalX,GeneralLP.InSpanX,SourceDistance.LogicalX,SourceModel.InSpanX,
    HX_matrix,HZ_matrix]

#print axioms exponent_matrix
#print axioms HX_matrix
#print axioms HZ_matrix
#print axioms classical_matrix
#print axioms left_word
#print axioms logicalX
end ParametricSpecialization
