module
public import ClassificationBranches
@[expose] public section
namespace Incidence.Classification
open Incidence
attribute [local irreducible] classifiesList
/-- All ten kernel-checked children are combined by a generic proved rule. -/
theorem normalized_classification_certificate :
    ∀ b : Bool, classifiesList pickList row good 5 [(b,0,0)] = true := by
  intro b
  cases b
  · apply classifiesList_step_of_children pickList row good 4 [(false,0,0)] (0,27)
      (by decide +kernel)
    intro v hv hn
    simp only [row,List.mem_cons,List.not_mem_nil,or_false] at hv
    rcases hv with rfl | rfl | rfl | rfl | rfl | rfl
    · exact False.elim (hn (by simp))
    · exact branch_false_0
    · exact branch_false_1
    · exact branch_false_2
    · exact branch_false_3
    · exact branch_false_4
  · apply classifiesList_step_of_children pickList row good 4 [(true,0,0)] (0,0)
      (by decide +kernel)
    intro v hv hn
    simp only [row,List.mem_cons,List.not_mem_nil,or_false] at hv
    rcases hv with rfl | rfl | rfl | rfl | rfl | rfl
    · exact branch_true_0
    · exact branch_true_1
    · exact branch_true_2
    · exact False.elim (hn (by simp))
    · exact branch_true_3
    · exact branch_true_4
end Incidence.Classification
