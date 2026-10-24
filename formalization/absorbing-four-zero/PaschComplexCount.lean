import PaschCyclicCount
import ComplexRootFormula

set_option maxHeartbeats 0
open scoped BigOperators
namespace PaschComplexCount
open PaschKernelCount PaschCyclicCount CyclicNormalization AbsorbingFourier
variable {N : ℕ} [NeZero N]
variable {P R : Type*} [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

/-- Fourier energy is inherited from the preserved standard-complex bridge. -/
theorem complex_count40_identity (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    24 * (count40 (incidence sockets) : ℝ) +
      (N : ℝ) * (normalizedCorrection40 sockets : ℝ) =
      ∑ p : P, ∑ q : P, ∑ d : ZMod N, rootVectorEnergy sockets p q d := by
  have h := congrArg (fun n : ℕ => (n : ℝ))
    (cyclic_corrected_count40_identity sockets hd h4)
  simp only [Nat.cast_add,Nat.cast_mul,Nat.cast_ofNat,ZMod.card] at h
  rw [h]
  unfold normalizedEnergy
  simp only [Nat.cast_sum,Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro q hq
  apply Finset.sum_congr rfl
  intro d hdmem
  exact (complex_root_parseval sockets p q d).symm

noncomputable def complexRootSummand40 (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) : ℝ :=
  if (p,0) ≠ (q,d) ∧
      (incidence sockets (p,0) ∩ incidence sockets (q,d)).Nonempty then
    let W := PairFormula.properCommon (incidence sockets) (p,0) (q,d)
    (1 / (N : ℝ)) * ∑ j : ZMod N, ‖evaluatedVector sockets W j‖ ^ 2 -
      (PaschRootEnergy.rootCheckEnergy (incidence sockets) W
        (incidence sockets (p,0) ∪ incidence sockets (q,d)) : ℝ) - (W.card : ℝ)
  else 0

theorem complexRootSummand40_eq (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) :
    complexRootSummand40 sockets p q d = rootVectorEnergy sockets p q d / (N : ℝ) -
      (correctionTerm40 (incidence sockets) (p,0) (q,d) : ℝ) := by
  unfold complexRootSummand40 rootVectorEnergy correctionTerm40
  split_ifs <;> simp only [Nat.cast_add,Nat.cast_zero,zero_div,sub_zero]
  ring

/-- Literal standard-complex formula for every positive lift size, including
N=1, even and composite N. The rectangular evaluated matrix and root indicator
are the actual socket objects; no M_j-only replacement is made. -/
theorem complex_root_count40_formula (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v → (incidence sockets u ∩ incidence sockets v).card ≤ 1) :
    (count40 (incidence sockets) : ℝ) = ((N : ℝ) / 24) *
      ∑ p : P, ∑ q : P, ∑ d : ZMod N, complexRootSummand40 sockets p q d := by
  have h := complex_count40_identity sockets hd h4
  simp only [complexRootSummand40_eq,Finset.sum_sub_distrib,← Finset.sum_div,
    normalizedCorrection40,Nat.cast_sum] at *
  have hn : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (NeZero.ne N)
  field_simp
  <;> nlinarith [h]

#print axioms complex_count40_identity
#print axioms complexRootSummand40_eq
#print axioms complex_root_count40_formula
end PaschComplexCount
