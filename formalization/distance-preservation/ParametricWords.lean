import GeneralLP
import CoverWeight
set_option maxHeartbeats 0
namespace ParametricWords
open scoped Matrix CharTwo
variable {L : Nat} [NeZero L]
open FamilyWords

def e (a b : ZMod L) : Fin 3 → Fin 4 → ZMod L :=
  !![0,0,0,0;0,a,b,3*a;0,2*a,2*b,b+2*a]

def U (a b : ZMod L) (i j : Fin 4) (s : ZMod L) : ZMod 2 :=
  !![delta 0 s,0,0,0;
     0,delta (-2*a) s,0,0;
     0,0,delta (-2*b) s,0;
     delta (-2*a) s,delta (-4*a) s+delta (-2*a) s,delta (-(b+2*a)) s,delta (-4*a) s] i j

abbrev V : Fin 3 → Fin 3 → ZMod L → ZMod 2 := FamilyWords.V

theorem witness_kernel (a b : ZMod L) (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    GeneralLP.Syndrome (e a b) (U a b) V j i t=0 := by
  have ht : (2 : ZMod 2)=0 := by decide +kernel
  have hf : (4 : ZMod 2)=0 := by decide +kernel
  fin_cases j <;> fin_cases i <;>
    norm_num [GeneralLP.Syndrome,e,U,V,FamilyWords.V,Fin.sum_univ_succ,delta_sub,delta_add]
  all_goals ring_nf
  all_goals simp only [ht,hf,mul_zero,sub_zero,zero_sub,neg_zero,add_zero,zero_add]

theorem augmentation_witness (a b : ZMod L) : FamilyWords.augmentation (U a b)=1 := by
  simp [FamilyWords.augmentation,U,delta]

/-- Full source-kernel and full arbitrary-stabilizer-span statement. -/
theorem actual_logical (a b : ZMod L) : GeneralLP.LogicalX (e a b) (U a b) V := by
  constructor
  · intro c
    exact (GeneralLP.z_action (e a b) (U a b) V c.1.1 c.1.2 c.2).trans (witness_kernel a b _ _ _)
  · intro h
    obtain ⟨w,hw⟩ := GeneralLP.full_span_left (e a b) (U a b) V h
    have h1 := augmentation_witness a b
    rw [hw,GeneralLP.augmentation_stabilizer] at h1
    exact zero_ne_one h1

def supportList (a b : ZMod L) : List (Qubit L) :=
  [.inl ((0,0),0),.inl ((1,1),-2*a),.inl ((2,2),-2*b),
   .inl ((3,0),-2*a),.inl ((3,1),-4*a),.inl ((3,1),-2*a),
   .inl ((3,2),-(b+2*a)),.inl ((3,3),-4*a),
   .inr ((0,2),0),.inr ((1,1),0),.inr ((2,0),0)]

theorem zero_outside (a b : ZMod L) (q : Qubit L) (hq : q∉supportList a b) :
    GeneralLP.join (U a b) V q=0 := by
  cases q with
  | inl p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    fin_cases i <;> fin_cases j <;>
      simp_all [GeneralLP.join,SourceModel.join,U,supportList,delta]
  | inr p =>
    rcases p with ⟨⟨i,j⟩,s⟩
    fin_cases i <;> fin_cases j <;>
      simp_all [GeneralLP.join,SourceModel.join,V,FamilyWords.V,supportList,delta]

theorem weight_le (a b : ZMod L) :
    (CoverWeight.support (GeneralLP.join (U a b) V)).card≤11 := by
  have hs : CoverWeight.support (GeneralLP.join (U a b) V) ⊆ (supportList a b).toFinset := by
    intro q hq
    have hn : GeneralLP.join (U a b) V q≠0 := (Finset.mem_filter.mp hq).2
    by_contra h
    have hh : q∉supportList a b := by simpa using h
    exact hn (zero_outside a b q hh)
  have h := Finset.card_le_card hs
  have hl := List.toFinset_card_le (l := supportList a b)
  have he : (supportList a b).length=11 := rfl
  omega

/-- For every positive cyclic length and arbitrary parameters, this template
has a nontrivial actual source logical of weight at most11. -/
theorem parametric_obstruction (a b : ZMod L) :
    GeneralLP.LogicalX (e a b) (U a b) V ∧
    (CoverWeight.support (GeneralLP.join (U a b) V)).card≤11 :=
  ⟨actual_logical a b,weight_le a b⟩

#print axioms witness_kernel
#print axioms actual_logical
#print axioms weight_le
#print axioms parametric_obstruction
end ParametricWords
