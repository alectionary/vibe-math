import FamilyGraphs
import LogicalWitness

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace FamilyLogical
open Matrix FamilyRank SparseCSSMatrices CyclicCSSCommute CyclicRecurrence
open scoped BigOperators
variable (q : ℕ) [NeZero q]

def word : Qubits q → F
  | .inl (v,t) => if v∈StarKernelCertificate.logicalBase ∧ t=0 then 1 else 0
  | .inr _ => 0

def seed : Fin 3 → F := fun i => if i=0 then 1 else 0

def scalarWitness : ZMod (7*q) → F :=
  OrientedKernel.reverse (7*q) (candidate (7*q) (dvd_mul_right 7 q) seed)

def witness : Qubits q → F
  | .inl (v,t) => if v=2 then scalarWitness q t else 0
  | .inr _ => 0

theorem word_weight : BinaryDistance.weight (word q)=6 := by
  have hs : BinarySupportEquiv.bitSupport (word q)=
      StarKernelCertificate.logicalBase.image (fun v => (Sum.inl (v,0) : Qubits q)) := by
    ext w
    cases w with
    | inl a =>
      rcases a with ⟨v,t⟩
      simp [BinarySupportEquiv.bitSupport,word,Finset.mem_image,Prod.mk.injEq,eq_comm]
    | inr a =>
      constructor
      · intro hw
        have he := (Finset.mem_filter.mp hw).2
        change (0 : F)=1 at he
        exact (zero_ne_one he).elim
      · intro hw
        obtain ⟨u,_,hu⟩ := Finset.mem_image.mp hw
        cases hu
  have hi : Function.Injective (fun v : Fin 10 => (Sum.inl (v,0) : Qubits q)) := by
    intro v w h
    exact congrArg Prod.fst (Sum.inl.inj h)
  rw [BinaryDistance.weight,hs,Finset.card_image_of_injective _ hi]
  exact StarKernelCertificate.logical_base_size

theorem word_kernel : X q*ᵥword q=0 := by
  funext a
  rcases a with ⟨c,s⟩
  fin_cases c <;> by_cases hs : s=0 <;>
    simp [X,checksX,fromCols,cover,Matrix.mulVec,dotProduct,
      Fintype.sum_sum_type,Fintype.sum_prod_type,word,mul_ite,ite_mul,
      Fin.sum_univ_succ,StarKernelCertificate.logicalBase,PaschCubicTrade.baseA,
      labels,StarElimination.labels,hs]
  all_goals decide

theorem scalar_witness_minus : OrientedKernel.MinusCondition (7*q) (scalarWitness q) := by
  apply (OrientedKernel.minus_iff_reverse (7*q) _).mpr
  have he : OrientedKernel.reverse (7*q) (scalarWitness q)=
      candidate (7*q) (dvd_mul_right 7 q) seed := by
    funext t
    simp [scalarWitness,OrientedKernel.reverse]
  rw [he]
  exact candidate_condition _ _ _

theorem z_left_apply (g : Fin 10 × ZMod (7*q) → F) (a : Fin 10 × ZMod (7*q)) :
    (Z q*ᵥSum.elim g (fun _ => 0)) a=
      g (a.1,a.2)+g (a.1,a.2-1)+g (a.1,a.2-3) := by
  have he : (Z q*ᵥSum.elim g (fun _ => 0)) a=((X q).transpose*ᵥg) (.inr a) := by
    simp [Z,X,checksZ,checksX,fromRows,fromCols,Matrix.mulVec,dotProduct,
      Matrix.transpose_apply,Fintype.sum_sum_type]
  rw [he]
  change ((checksX PaschCubicTrade.baseA (labels q) (-1) (-3) : Matrix _ _ F).transpose*ᵥg) (.inr a)=_
  rw [x_adjoint]
  simpa [SparseCSS.shift] using SparseCSS.right_apply (7*q) PaschCubicTrade.baseA (labels q)
    false g a.1 a.2

theorem witness_kernel : Z q*ᵥwitness q=0 := by
  have he : witness q=Sum.elim (fun a : Fin 10 × ZMod (7*q) =>
      if a.1=2 then scalarWitness q a.2 else 0) (fun _ => 0) := by
    funext w
    cases w with
    | inl a => rcases a with ⟨v,t⟩; rfl
    | inr a => rfl
  rw [he]
  funext a
  rw [z_left_apply]
  by_cases hv : a.1=2
  · simpa only [hv,↓reduceIte,Pi.zero_apply] using scalar_witness_minus q a.2
  · simp [hv]

theorem pairing : dotProduct (word q) (witness q)=1 := by
  simp [dotProduct,word,witness,Fintype.sum_sum_type,Fintype.sum_prod_type,
    mul_ite,ite_mul,scalarWitness,OrientedKernel.reverse,candidate,pattern,seed,
    StarKernelCertificate.logicalBase,Finset.sum_ite_eq',Finset.sum_ite_eq]

theorem logical_nontrivial : word q∉LinearMap.range (Z q).transpose.mulVecLin :=
  LogicalWitness.not_in_row_space (Z q) (word q) (witness q) (witness_kernel q) (pairing q)

theorem distance_six (hq : 2≤q) :
    (∀ a : Qubits q → F,
      ((X q*ᵥa=0 ∧ a∉LinearMap.range (Z q).transpose.mulVecLin) ∨
       (Z q*ᵥa=0 ∧ a∉LinearMap.range (X q).transpose.mulVecLin)) → 6≤BinaryDistance.weight a) ∧
    (X q*ᵥword q=0 ∧ word q∉LinearMap.range (Z q).transpose.mulVecLin ∧
      BinaryDistance.weight (word q)=6) :=
  LogicalWitness.distance_six (X q) (Z q) (FamilyGraphs.kernel_lowerX q hq)
    (FamilyGraphs.kernel_lowerZ q hq) (word q) (word_kernel q) (logical_nontrivial q) (word_weight q)

#print axioms word_weight
#print axioms word_kernel
#print axioms witness_kernel
#print axioms pairing
#print axioms logical_nontrivial
#print axioms distance_six
end FamilyLogical
