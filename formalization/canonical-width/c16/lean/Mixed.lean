/-
Part B: mixed operators reduce to pure ones (source Appendix C.3; `INDEPENDENT-ENUMERATION.md`).

A Pauli on `n` qubits is a pair `(a, b)` (X part, Z part) over `𝔽₂`, with symplectic form
`ω((a,b),(a',b')) = a·b' + b·a'`. For a CSS code with X-stabilizer space `SX` and
Z-stabilizer space `SZ`, a logical operator commutes with all stabilizers: `a ⊥ SZ`, `b ⊥ SX`.

If each operator of a canonical frame has a trivial (stabilizer) component, replacing every
operator by its other, pure component keeps every pairing, never enlarges supports, and pairs
each X-type operator with a Z-type one. For `C^LP_{16,9}` the hypothesis holds for operators of
weight at most 17: both components cannot be nontrivial, because any nontrivial X and Z
logicals together cover at least 26 > 17 qubits (`μ_XZ = 26`, exact finite computation in
`INDEPENDENT-ENUMERATION.md`). That computed fact is a hypothesis here, not a Lean proof.
-/
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.ZMod.Basic

namespace C16Frames.Mixed

variable {n : ℕ}

abbrev V (n : ℕ) := Fin n → ZMod 2

/-- Symplectic form on Paulis `(X part, Z part)`. -/
def ω (p q : V n × V n) : ZMod 2 := p.1 ⬝ᵥ q.2 + p.2 ⬝ᵥ q.1

/-- `p` commutes with every stabilizer. -/
def IsLogical (SX SZ : Submodule (ZMod 2) (V n)) (p : V n × V n) : Prop :=
  (∀ s ∈ SZ, p.1 ⬝ᵥ s = 0) ∧ (∀ s ∈ SX, p.2 ⬝ᵥ s = 0)

/-- Which component is trivial: `xType` means the Z part is a stabilizer, and vice versa. -/
inductive Kind | xType | zType
deriving DecidableEq

/-- `p` has a trivial component of the given kind. -/
def HasKind (SX SZ : Submodule (ZMod 2) (V n)) (p : V n × V n) : Kind → Prop
  | .xType => p.2 ∈ SZ
  | .zType => p.1 ∈ SX

/-- The pure component left after dropping the trivial one. -/
def pure (p : V n × V n) : Kind → V n × V n
  | .xType => (p.1, 0)
  | .zType => (0, p.2)

/-- Dropping trivial components preserves every pairing between logical operators. -/
theorem ω_pure (SX SZ : Submodule (ZMod 2) (V n)) {p q : V n × V n} {k l : Kind}
    (hp : IsLogical SX SZ p) (hq : IsLogical SX SZ q)
    (hpk : HasKind SX SZ p k) (hql : HasKind SX SZ q l) :
    ω (pure p k) (pure q l) = ω p q := by
  obtain ⟨hp1, hp2⟩ := hp
  obtain ⟨hq1, hq2⟩ := hq
  cases k <;> cases l <;> simp only [HasKind] at hpk hql <;> simp only [ω, pure]
  · -- both X-type: p.2, q.2 ∈ SZ
    rw [hp1 _ hql, dotProduct_comm p.2, hq1 _ hpk]; simp
  · -- p X-type, q Z-type: p.2 ∈ SZ, q.1 ∈ SX
    rw [dotProduct_comm p.2, hq1 _ hpk]; simp
  · -- p Z-type, q X-type: p.1 ∈ SX, q.2 ∈ SZ
    rw [hp1 _ hql]; simp
  · -- both Z-type: p.1, q.1 ∈ SX
    rw [dotProduct_comm p.1, hq2 _ hpk, hp2 _ hql]; simp

/-- Support of a Pauli: qubits where either part is nonzero. -/
def supp (p : V n × V n) : Finset (Fin n) := Finset.univ.filter fun q => p.1 q ≠ 0 ∨ p.2 q ≠ 0

/-- Dropping a component never enlarges the support (so never increases weight). -/
theorem supp_pure_subset (p : V n × V n) (k : Kind) : supp (pure p k) ⊆ supp p := by
  intro q hq
  cases k <;> simp_all [supp, pure]

theorem card_supp_pure_le (p : V n × V n) (k : Kind) : (supp (pure p k)).card ≤ (supp p).card :=
  Finset.card_le_card (supp_pure_subset p k)

/-- Two pure operators of the same type commute. Hence in a canonical pair `ω(P, Q) = 1` the
pure components have opposite types: one X-type and one Z-type. -/
theorem kinds_differ_of_anticommute (SX SZ : Submodule (ZMod 2) (V n)) {p q : V n × V n}
    {k l : Kind} (hp : IsLogical SX SZ p) (hq : IsLogical SX SZ q)
    (hpk : HasKind SX SZ p k) (hql : HasKind SX SZ q l) (h : ω p q = 1) : k ≠ l := by
  intro hkl
  subst hkl
  rw [← ω_pure SX SZ hp hq hpk hql] at h
  cases k <;> simp [ω, pure] at h

/-- Reduction: if every operator of a frame `(P i, Q j)` with `ω (P i) (Q j) = δᵢⱼ` and
`ω (P i) (P j) = ω (Q i) (Q j) = 0` has a trivial component, the pure components form a frame
with the same pairings, no larger supports, and each pair split into one X-type and one Z-type
operator. -/
theorem pure_frame {m : ℕ} (SX SZ : Submodule (ZMod 2) (V n)) (P Q : Fin m → V n × V n)
    (kP kQ : Fin m → Kind) (hPl : ∀ i, IsLogical SX SZ (P i)) (hQl : ∀ i, IsLogical SX SZ (Q i))
    (hPk : ∀ i, HasKind SX SZ (P i) (kP i)) (hQk : ∀ i, HasKind SX SZ (Q i) (kQ i))
    (hPQ : ∀ i j, ω (P i) (Q j) = if i = j then 1 else 0)
    (hPP : ∀ i j, ω (P i) (P j) = 0) (hQQ : ∀ i j, ω (Q i) (Q j) = 0) :
    (∀ i j, ω (pure (P i) (kP i)) (pure (Q j) (kQ j)) = if i = j then 1 else 0) ∧
    (∀ i j, ω (pure (P i) (kP i)) (pure (P j) (kP j)) = 0) ∧
    (∀ i j, ω (pure (Q i) (kQ i)) (pure (Q j) (kQ j)) = 0) ∧
    (∀ i, kP i ≠ kQ i) ∧
    (∀ i, (supp (pure (P i) (kP i))).card ≤ (supp (P i)).card ∧
          (supp (pure (Q i) (kQ i))).card ≤ (supp (Q i)).card) := by
  refine ⟨fun i j => ?_, fun i j => ?_, fun i j => ?_, fun i => ?_, fun i => ⟨?_, ?_⟩⟩
  · rw [ω_pure SX SZ (hPl i) (hQl j) (hPk i) (hQk j), hPQ]
  · rw [ω_pure SX SZ (hPl i) (hPl j) (hPk i) (hPk j), hPP]
  · rw [ω_pure SX SZ (hQl i) (hQl j) (hQk i) (hQk j), hQQ]
  · exact kinds_differ_of_anticommute SX SZ (hPl i) (hQl i) (hPk i) (hQk i) (by simpa using hPQ i i)
  · exact card_supp_pure_le _ _
  · exact card_supp_pure_le _ _

end C16Frames.Mixed
