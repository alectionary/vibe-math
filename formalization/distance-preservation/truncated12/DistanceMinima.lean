import PauliBridge
import PureDistance
import Mathlib.Data.ENat.Lattice
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

def sourceClassicalHasWeight (e : Fin 3 → Fin 4 → ZMod L) (n : ℕ) : Prop :=
  ∃ x : Fin 4 × ZMod L → ZMod 2,
    (∀ a,(∑ q,GeneralLP.C e a q*x q)=0) ∧ x≠0 ∧ (CoverWeight.support x).card=n

noncomputable instance (e : Fin 3 → Fin 4 → ZMod L) : DecidablePred (sourceClassicalHasWeight e) :=
  fun _ => Classical.propDecidable _

theorem source_classical_weight_exists (e : Fin 3 → Fin 4 → ZMod L) :
    ∃ n,sourceClassicalHasWeight e n := by
  obtain ⟨x,hk,hn⟩ := GeneralLP.nonzero_classical_exists e
  exact ⟨(CoverWeight.support x).card,x,hk,hn,rfl⟩

noncomputable def sourceClassicalDistance (e : Fin 3 → Fin 4 → ZMod L) : ℕ :=
  Nat.find (source_classical_weight_exists e)

theorem source_classical_minimum_realized (e : Fin 3 → Fin 4 → ZMod L) :
    sourceClassicalHasWeight e (sourceClassicalDistance e) :=
  Nat.find_spec (source_classical_weight_exists e)

theorem source_classical_minimum_lower (e : Fin 3 → Fin 4 → ZMod L) :
    ClassicalAtLeast e (sourceClassicalDistance e) := by
  intro x hk hn
  exact Nat.find_min' (source_classical_weight_exists e) ⟨x,hk,hn,rfl⟩

def sourceTransposeHasWeight (e : Fin 3 → Fin 4 → ZMod L) (n : ℕ∞) : Prop :=
  ∃ y : Fin 3 × ZMod L → ZMod 2,
    (∀ q,(∑ a,GeneralLP.C e a q*y a)=0) ∧ y≠0 ∧ n=((CoverWeight.support y).card : ℕ∞)

noncomputable def sourceTransposeDistance (e : Fin 3 → Fin 4 → ZMod L) : ℕ∞ :=
  sInf {n | sourceTransposeHasWeight e n}

theorem source_transpose_zero_kernel_infinity (e : Fin 3 → Fin 4 → ZMod L)
    (hz : ∀ y : Fin 3 × ZMod L → ZMod 2,
      (∀ q,(∑ a,GeneralLP.C e a q*y a)=0) → y=0) : sourceTransposeDistance e=⊤ := by
  have hempty : {n | sourceTransposeHasWeight e n}=(∅ : Set ℕ∞) := by
    ext n
    constructor
    · rintro ⟨y,hk,hn,he⟩
      exact False.elim (hn (hz y hk))
    · intro hn
      exact False.elim (Set.notMem_empty n hn)
  unfold sourceTransposeDistance
  rw [hempty,sInf_empty]

theorem source_transpose_comparison_lower (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ)
    (hD : (D : ℕ∞)≤sourceTransposeDistance e) : TransposeAtLeast e D := by
  intro y hk hn
  have hy : sourceTransposeDistance e≤((CoverWeight.support y).card : ℕ∞) :=
    sInf_le (show sourceTransposeHasWeight e ((CoverWeight.support y).card : ℕ∞) from ⟨y,hk,hn,rfl⟩)
  exact_mod_cast hD.trans hy

def sourceQuantumHasWeight (e : Fin 3 → Fin 4 → ZMod L) (n : ℕ∞) : Prop :=
  ∃ x z : Qubit L → ZMod 2,
    (∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0) ∧
    (∀ c,(∑ q,GeneralLP.HX e c q*z q)=0) ∧
    ¬(fullSpanX e x ∧ fullSpanZ e z) ∧
    n=(((CoverWeight.support x)∪(CoverWeight.support z)).card : ℕ∞)

/-- Ordinary Pauli distance over the two full stabilizer spans, with infinity
when the quotient has no nontrivial Pauli pair. Positive CSS dimension makes
this the usual finite minimum; the lower-bound theorem also covers infinity. -/
noncomputable def sourceQuantumDistance (e : Fin 3 → Fin 4 → ZMod L) : ℕ∞ :=
  sInf {n | sourceQuantumHasWeight e n}

theorem source_quantum_minimum_upper (e : Fin 3 → Fin 4 → ZMod L)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c,(∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) :
    sourceQuantumDistance e≤(((CoverWeight.support x)∪(CoverWeight.support z)).card : ℕ∞) :=
  sInf_le (show sourceQuantumHasWeight e _ from ⟨x,z,hx,hz,hn,rfl⟩)

theorem source_quantum_finite_of_logical (e : Fin 3 → Fin 4 → ZMod L)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c,(∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) : sourceQuantumDistance e<⊤ :=
  lt_of_le_of_lt (source_quantum_minimum_upper e x z hx hz hn) (by simp)

theorem source_quantum_minimum_lower_iff (e : Fin 3 → Fin 4 → ZMod L) (b : ℕ) :
    (b : ℕ∞)≤sourceQuantumDistance e ↔
      ∀ x z : Qubit L → ZMod 2,
        (∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0) →
        (∀ c,(∑ q,GeneralLP.HX e c q*z q)=0) →
        ¬(fullSpanX e x ∧ fullSpanZ e z) →
        b≤((CoverWeight.support x)∪(CoverWeight.support z)).card := by
  constructor
  · intro hb x z hx hz hn
    have hq : sourceQuantumDistance e≤(((CoverWeight.support x)∪(CoverWeight.support z)).card : ℕ∞) :=
      sInf_le (show sourceQuantumHasWeight e _ from ⟨x,z,hx,hz,hn,rfl⟩)
    exact_mod_cast hb.trans hq
  · intro h
    apply le_sInf
    rintro n ⟨x,z,hx,hz,hn,rfl⟩
    exact_mod_cast h x z hx hz hn

#print axioms source_classical_minimum_realized
#print axioms source_classical_minimum_lower
#print axioms source_transpose_zero_kernel_infinity
#print axioms source_quantum_minimum_lower_iff
end TruncatedDistance
