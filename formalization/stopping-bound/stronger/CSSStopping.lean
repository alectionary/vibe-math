import KernelStopping
import SidonMatrices
namespace BinaryStopping
open Matrix Finset
variable {V C D : Type*} [Fintype V] [DecidableEq V] [DecidableEq C]
/-- A nonzero companion-check row is a stopping support. This is the known
stabilizer mechanism, now checked against the same binary stopping definition. -/
theorem css_row_stopping (E : V → C → Prop) [DecidableRel E]
    (Z : Matrix D V (ZMod 2)) (hcss : matrix E * Zᵀ = 0)
    (d : D) (hne : (fun v => Z d v) ≠ 0) :
    Incidence.Stopping E (support (fun v => Z d v)) := by
  apply kernel_stopping E _ hne
  funext c
  have h := congrFun (congrFun hcss c) d
  simpa only [Matrix.mul_apply,Matrix.transpose_apply,Matrix.mulVec,dotProduct,
    Matrix.zero_apply,Pi.zero_apply] using h
end BinaryStopping

namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
theorem row_stopping (S : Finset G) (hne : S.Nonempty) (c : G) :
    let T := BinaryStopping.support (fun v => X (ZMod 2) S c v)
    Incidence.Stopping (E S) T ∧ T.card = 2*S.card := by
  dsimp only
  have he : BinaryStopping.matrix (E S) = X (ZMod 2) S := by
    ext d v
    exact (entry _ S v d).symm
  have hrne : (fun v => X (ZMod 2) S c v) ≠ 0 := by
    obtain ⟨s,hs⟩ := hne
    intro hz
    have hh := congrFun hz (false,c-s)
    have hx : X (ZMod 2) S c (false,c-s) = 1 := by
      rw [entry]
      simp [E,hs]
    rw [hx] at hh
    exact (by decide : (1:ZMod 2) ≠ 0) hh
  constructor
  · apply BinaryStopping.css_row_stopping (E S) (X (ZMod 2) S) _ c hrne
    rw [he]
    exact css S
  · have hi (v : Bool × G) : X (ZMod 2) S c v ≠ 0 ↔ X (ZMod 2) S c v = 1 := by
      exact (show ∀ x : ZMod 2, x ≠ 0 ↔ x = 1 by decide) _
    simpa only [BinaryStopping.support,hi] using row_weight S c
end SidonStopping
