import NormalFormCount

set_option maxHeartbeats 0
namespace CycleKernelBridge
open Matrix
open scoped BigOperators
variable {R : Type*} [CommRing R]
variable {I J M K : Type*} [Fintype I] [Fintype J] [Fintype M] [Fintype K]
  [DecidableEq I] [DecidableEq J] [DecidableEq M] [DecidableEq K]

def Events (B : I → J → K → ℤ) (S : Finset I) (z : K → R) : Prop :=
  ∀ i∈S, ∀ j, ∑ k, (B i j k : R)*z k=0

variable (B : I → J → K → ℤ) (S : Finset I)
  (A : Matrix M K ℤ) (p : M → I × J)
  (hrows : ∀ m k, A m k=B (p m).1 (p m).2 k)
  (hrange : ∀ i j, i∈S ↔ ∃ m, p m=(i,j))

include hrows hrange in
theorem events_iff (z : K → R) :
    Events B S z ↔ (A.map (Int.castRingHom R))*ᵥz=0 := by
  have he (m : M) : ((A.map (Int.castRingHom R))*ᵥz) m=
      ∑ k, (B (p m).1 (p m).2 k : R)*z k := by
    change (∑ k, (A m k : R)*z k)=_
    simp_rw [hrows]
  constructor
  · intro hz
    funext m
    rw [he]
    exact hz (p m).1 ((hrange (p m).1 (p m).2).mpr ⟨m,rfl⟩) (p m).2
  · intro hz i hi j
    obtain ⟨m,hm⟩ := (hrange i j).mp hi
    have h := congrFun hz m
    rw [he,hm] at h
    exact h

noncomputable def eventsEquiv : {z : K → R // Events B S z} ≃
    IntegerKernel.Kernel (A.map (Int.castRingHom R)) :=
  Equiv.subtypeEquivRight (events_iff B S A p hrows hrange)

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- A column reindexing is a bijection of the actual solution sets. -/
def columnEquiv (A : Matrix M K R) (e : L ≃ K) :
    IntegerKernel.Kernel (A.submatrix id e) ≃ IntegerKernel.Kernel A where
  toFun x := ⟨x.val ∘ e.symm,by
    have h := x.prop
    rw [Matrix.submatrix_mulVec_equiv] at h
    exact h⟩
  invFun y := ⟨y.val ∘ e,by
    rw [Matrix.submatrix_mulVec_equiv]
    simpa only [Function.comp_def,Equiv.apply_symm_apply,id_eq] using y.prop⟩
  left_inv x := Subtype.ext (by funext l; simp)
  right_inv y := Subtype.ext (by funext k; simp)

#print axioms events_iff
#print axioms columnEquiv
end CycleKernelBridge
