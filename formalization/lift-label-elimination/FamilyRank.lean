import SparseCSSMatrices
import StarElimination
import StarCheckKernel

set_option maxHeartbeats 0
namespace FamilyRank
open Matrix CyclicRecurrence SparseCSSMatrices
open scoped BigOperators
variable (q : ℕ) [NeZero q]

abbrev Length := 7*q
abbrev Qubits := Sum (Fin 10 × ZMod (7*q)) (Fin 10 × ZMod (7*q))

def labels : Fin 10 → Fin 10 → ZMod (7*q) := StarElimination.labels 7

def X : Matrix (Fin 10 × ZMod (7*q)) (Qubits q) F :=
  checksX PaschCubicTrade.baseA (labels q) (-1) (-3)

def Z : Matrix (Fin 10 × ZMod (7*q)) (Qubits q) F :=
  checksZ PaschCubicTrade.baseA (labels q) (-1) (-3)

theorem css : X q*(Z q).transpose=0 :=
  SparseCSSMatrices.css_commutes _ _ _ _

theorem label_cast (v c : Fin 10) :
    ZMod.castHom (dvd_mul_right 7 q) (ZMod 7) (labels q v c)=0 := by
  unfold labels StarElimination.labels
  split_ifs <;> simp only [map_ofNat,map_zero]
  all_goals decide

theorem base_transpose : SparseCSS.base PaschCubicTrade.baseA=StarCheckKernel.base.transpose := rfl

theorem dual_base : SparseCSS.base (dual PaschCubicTrade.baseA)=StarCheckKernel.base := by
  ext c v
  simp [SparseCSS.base,dual,StarCheckKernel.base]

theorem x_kernel : Nat.card {f : Fin 10 × ZMod (7*q) → F // (X q).transpose*ᵥf=0}=512 := by
  change Nat.card {f : Fin 10 × ZMod (7*q) → F //
    (checksX PaschCubicTrade.baseA (labels q) (-1) (-3) : Matrix _ _ F).transpose*ᵥf=0}=512
  rw [x_adjoint]
  rw [SparseCSS.kernel_card (7*q) (dvd_mul_right 7 q) _ _ (label_cast q) false,
    base_transpose,StarCheckKernel.transposed_kernel_card]
  decide

theorem z_kernel : Nat.card {f : Fin 10 × ZMod (7*q) → F // (Z q).transpose*ᵥf=0}=512 := by
  let A := SparseCSS.adjoint (7*q) (dual PaschCubicTrade.baseA) (inverseLabels (labels q)) true
  have he (f : Fin 10 × ZMod (7*q) → F) : (Z q).transpose*ᵥf=0 ↔ A*ᵥf=0 := by
    change (checksZ PaschCubicTrade.baseA (labels q) (-1) (-3) : Matrix _ _ F).transpose*ᵥf=0 ↔ _
    rw [z_swapped_adjoint]
    change (fun w => (A*ᵥf) (Sum.swap w))=0 ↔ A*ᵥf=0
    constructor
    · intro h
      funext a
      have hh := congrFun h (Sum.swap a)
      simpa only [Function.comp_def,Sum.swap_swap,Pi.zero_apply] using hh
    · intro h
      rw [h]
      rfl
  rw [Nat.card_congr (Equiv.subtypeEquivRight he)]
  change Nat.card {f : Fin 10 × ZMod (7*q) → F // A*ᵥf=0}=512
  have hz (c v : Fin 10) :
      ZMod.castHom (dvd_mul_right 7 q) (ZMod 7) (inverseLabels (labels q) c v)=0 := by
    simpa only [inverseLabels,map_neg,neg_zero] using congrArg Neg.neg (label_cast q v c)
  rw [SparseCSS.kernel_card (7*q) (dvd_mul_right 7 q) _ _ hz true,
    dual_base,StarCheckKernel.base_kernel_card]
  decide

theorem rankX : (X q).rank+9=70*q := by
  simpa only [Fintype.card_prod,Fintype.card_fin,ZMod.card,show 10*(7*q)=70*q by omega]
    using RankFromKernel.check_rank (X q) (x_kernel q)

theorem rankZ : (Z q).rank+9=70*q := by
  simpa only [Fintype.card_prod,Fintype.card_fin,ZMod.card,show 10*(7*q)=70*q by omega]
    using RankFromKernel.check_rank (Z q) (z_kernel q)

theorem length : Fintype.card (Qubits q)=140*q := by
  simp only [Qubits,Fintype.card_sum,Fintype.card_prod,Fintype.card_fin,ZMod.card]
  omega

/-- Binary CSS dimension formula, for these actual matrices and all q>0. -/
theorem dimension : Fintype.card (Qubits q)-(X q).rank-(Z q).rank=18 := by
  have hx := rankX q
  have hz := rankZ q
  have hq := NeZero.ne q
  rw [length]
  omega

#print axioms css
#print axioms x_kernel
#print axioms z_kernel
#print axioms rankX
#print axioms rankZ
#print axioms dimension
end FamilyRank
