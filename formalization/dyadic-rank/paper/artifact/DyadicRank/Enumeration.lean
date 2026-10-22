module

public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Data.Fintype.Pi
public import Mathlib.Tactic.FinCases

@[expose] public section

namespace DyadicRank

/-- Nondependent updates avoid transports along equalities of function indices. -/
def binaryAssignments {n : Type} [DecidableEq n] : List n → List (n → ZMod 2)
  | [] => [fun _ => 0]
  | a :: xs => (binaryAssignments xs).flatMap fun f =>
      [fun x => if x = a then 0 else f x, fun x => if x = a then 1 else f x]

theorem binaryValue (a : ZMod 2) : a = 0 ∨ a = 1 := by decide +revert +kernel

theorem mem_binaryAssignments {n : Type} [DecidableEq n] (xs : List n)
    (f : n → ZMod 2) (hz : ∀ x, x ∉ xs → f x = 0) : f ∈ binaryAssignments xs := by
  induction xs generalizing f with
  | nil =>
    have hf : f = fun _ => 0 := funext fun x => hz x (by simp)
    simp [binaryAssignments, hf]
  | cons a xs ih =>
    let g : n → ZMod 2 := fun x => if x = a then 0 else f x
    have hg : ∀ x, x ∉ xs → g x = 0 := by
      intro x hx
      by_cases ha : x = a
      · simp [g, ha]
      · simp [g, ha, hz x (by simp [ha, hx])]
    apply List.mem_flatMap.mpr
    refine ⟨g, ih g hg, ?_⟩
    rcases binaryValue (f a) with hv | hv
    · have hf : f = fun x => if x = a then 0 else g x := by
        funext x
        by_cases ha : x = a <;> simp_all [g]
      simp only [List.mem_cons, List.not_mem_nil, or_false]
      exact Or.inl hf
    · have hf : f = fun x => if x = a then 1 else g x := by
        funext x
        by_cases ha : x = a <;> simp_all [g]
      simp only [List.mem_cons, List.not_mem_nil, or_false]
      exact Or.inr hf

/-- An explicit complete list, avoiding a noncomputable choice of multiset order. -/
class BinaryIndex (n : Type) where
  values : List n
  complete : ∀ x, x ∈ values

instance (k : ℕ) : BinaryIndex (Fin k) where
  values := List.finRange k
  complete := by simp

instance (n : Type) [DecidableEq n] [BinaryIndex n] : BinaryIndex (n → ZMod 2) where
  values := binaryAssignments BinaryIndex.values
  complete f := mem_binaryAssignments _ f (by simp [BinaryIndex.complete])

/-- Same finite function space, with a kernel-reducible enumeration. -/
@[instance_reducible]
def binaryFunctionFintype (n : Type) [Fintype n] [DecidableEq n] [BinaryIndex n] :
    Fintype (n → ZMod 2) where
  elems := (binaryAssignments (BinaryIndex.values : List n)).toFinset
  complete f := by
    apply List.mem_toFinset.mpr
    exact mem_binaryAssignments _ f (by simp [BinaryIndex.complete])

end DyadicRank
