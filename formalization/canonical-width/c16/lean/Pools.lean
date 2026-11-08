/-
Bridge from the concrete C16 pools to the abstract statements of `C16Frames`.

The 720 + 720 pool vectors are read from `PoolData.lean`, generated from
`pools/xcoords.txt` and `pools/zcoords.txt` by `gen_pool_data.py` (file hashes in its header).
Facts about the concrete 720 × 720 pairing matrix are checked by `native_decide`, which
additionally trusts the Lean compiler (axiom `Lean.ofReduceBool`).
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Field.ZMod
import Mathlib.Data.Matrix.Mul
import C16Frames
import PoolData

open Matrix C16Frames.Pools

namespace C16Frames.PoolBridge

instance : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩

/-- Coordinates of a 128-bit integer as a vector over `𝔽₂`. -/
def toVec (v : Nat) : Fin 128 → ZMod 2 := fun c => if v.testBit c then 1 else 0

/-- Pool vectors: `X i`, `Z j` for `i j : Fin 720`. -/
def X (i : Fin 720) : Fin 128 → ZMod 2 := toVec (xArr.getD i 0)
def Z (j : Fin 720) : Fin 128 → ZMod 2 := toVec (zArr.getD j 0)

/-- The anticommutation (pairing) matrix `G i j = ⟨x_i, z_j⟩`. -/
def G (i j : Fin 720) : ZMod 2 := X i ⬝ᵥ Z j

set_option maxRecDepth 10000 in
theorem xArr_size : xArr.size = 720 := by rfl
set_option maxRecDepth 10000 in
theorem zArr_size : zArr.size = 720 := by rfl

/-- The cyclic shift `T` on pool indices: `16a + t ↦ 16a + (t+1 mod 16)`. -/
def rotIdx (k : ℕ) (i : Fin 720) : Fin 720 :=
  ⟨16 * (i.1 / 16) + (i.1 % 16 + k) % 16, by omega⟩

/-- The shift `T` on logical coordinates: each 16-bit block rotated by one position. -/
def rotCoord (k : ℕ) (c : Fin 128) : Fin 128 :=
  ⟨16 * (c.1 / 16) + (c.1 % 16 + k) % 16, by omega⟩

/-- Pool data are `T`-orbits: entry `T i` is the image of entry `i` under the coordinate shift. -/
theorem X_rot : ∀ i : Fin 720, ∀ c : Fin 128, X (rotIdx 1 i) (rotCoord 1 c) = X i c := by
  native_decide
theorem Z_rot : ∀ j : Fin 720, ∀ c : Fin 128, Z (rotIdx 1 j) (rotCoord 1 c) = Z j c := by
  native_decide

/-- `G` is symmetric (used for the side exchange `s`). -/
theorem G_symm : ∀ i j : Fin 720, G i j = G j i := by native_decide

/-- `G` is invariant under the shift `T`. -/
theorem G_rot : ∀ i j : Fin 720, G (rotIdx 1 i) (rotIdx 1 j) = G i j := by native_decide

/-- `T` as a permutation of pool indices. -/
def rotEquiv : Fin 720 ≃ Fin 720 where
  toFun := rotIdx 1
  invFun := rotIdx 15
  left_inv := by
    intro i
    apply Fin.ext
    simp only [rotIdx]
    have := i.isLt
    omega
  right_inv := by
    intro i
    apply Fin.ext
    simp only [rotIdx]
    have := i.isLt
    omega

/-- `T⁸` on indices is an involution. -/
def tau8 : Fin 720 ≃ Fin 720 where
  toFun := rotIdx 8
  invFun := rotIdx 8
  left_inv := by
    intro i
    apply Fin.ext
    simp only [rotIdx]
    have := i.isLt
    omega
  right_inv := by
    intro i
    apply Fin.ext
    simp only [rotIdx]
    have := i.isLt
    omega

theorem tau8_invol : ∀ i : Fin 720, tau8 (tau8 i) = i := tau8.left_inv

/-- `G` as the product of the pool matrices. -/
theorem G_eq_mul : (Matrix.of fun i c => X i c) * (Matrix.of fun j c => Z j c)ᵀ = Matrix.of G := by
  ext i j
  simp [Matrix.mul_apply, G, dotProduct]

/-- Reduction, size bound for these pools: an induced matching in `G` has at most 128 pairs. -/
theorem pool_matching_le_128 {m : ℕ} (S T : Fin m → Fin 720)
    (h : (Matrix.of G).submatrix S T = 1) : m ≤ 128 :=
  induced_matching_le_dim (Matrix.of fun i c => X i c) (Matrix.of fun j c => Z j c) S T
    (by rw [G_eq_mul]; exact h)

/-- The shift `T` maps pool frames to pool frames. -/
theorem frame_rot {S T : Finset (Fin 720)} {k : ℕ} (hF : IsFrame G S T k) :
    IsFrame G (S.map rotEquiv.toEmbedding) (T.map rotEquiv.toEmbedding) k :=
  IsFrame.map rotEquiv rotEquiv (fun i j => G_rot i j) hF

/-- The side exchange `s` maps pool frames to pool frames. -/
theorem frame_swap {S T : Finset (Fin 720)} {k : ℕ} (hF : IsFrame G S T k) (hT : T.card = k) :
    IsFrame G T S k :=
  IsFrame.swap G_symm hF hT

/-- Lemma (classes) (iii) for these pools: a frame is fixed by `s T⁸` iff `T = τ S`. -/
theorem fixed_sT8_iff (S T : Finset (Fin 720)) :
    ((T.map tau8.toEmbedding, S.map tau8.toEmbedding) = (S, T)) ↔ T = S.map tau8.toEmbedding :=
  fixed_swapHalf_iff tau8 tau8_invol S T

end C16Frames.PoolBridge
