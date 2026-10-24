import ComplexCharacter

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {N : ℕ} [NeZero N]
variable {P R : Type*} [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

/-- Squared Euclidean norm of the full rectangular evaluated matrix applied to
the proper common-neighbor indicator, summed over frequencies and checks. -/
noncomputable def rootNormEnergy (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) : ℝ :=
  if (p,0) ≠ (q,d) ∧
      (CyclicNormalization.incidence sockets (p,0) ∩
       CyclicNormalization.incidence sockets (q,d)).Nonempty then
    ∑ r : R, ∑ j : ZMod N,
      ‖transformedAction ZMod.stdAddChar sockets
        (indicator (PairFormula.properCommon (CyclicNormalization.incidence sockets) (p,0) (q,d))) j r‖ ^ 2
  else 0

noncomputable def normalizedNormEnergy (sockets : P → Finset (R × ZMod N)) : ℝ :=
  ∑ p : P, ∑ q : P, ∑ d : ZMod N, rootNormEnergy sockets p q d

theorem rootNormEnergy_coe (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) :
    (rootNormEnergy sockets p q d : ℂ) =
      rootFrequencyEnergy ZMod.stdAddChar sockets p q d := by
  classical
  unfold rootNormEnergy rootFrequencyEnergy
  split_ifs <;> simp only [Complex.ofReal_sum, Complex.ofReal_zero, star_mul_eq_norm_sq]

theorem normalizedNormEnergy_coe (sockets : P → Finset (R × ZMod N)) :
    (normalizedNormEnergy sockets : ℂ) =
      normalizedFrequencyEnergy ZMod.stdAddChar sockets := by
  unfold normalizedNormEnergy normalizedFrequencyEnergy
  simp only [Complex.ofReal_sum, rootNormEnergy_coe]

/-- The exact standard-complex Fourier count, now expressed over the reals
using ordinary squared complex norms. Every positive lift size is allowed. -/
theorem complex_cyclic_count_identity (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    4 * (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : ℝ) +
      normalizedNormEnergy sockets =
      (N : ℝ) * (CyclicNormalization.normalizedQuadratic sockets : ℝ) := by
  have h := cyclic_Fourier_count_identity ZMod.stdAddChar
    ZMod.injective_stdAddChar standard_character_star sockets hd h4
  rw [← normalizedNormEnergy_coe] at h
  apply Complex.ofReal_injective
  simpa only [Complex.ofReal_add, Complex.ofReal_mul, Complex.ofReal_ofNat,
    Complex.ofReal_natCast, ZMod.card] using h

theorem complex_cyclic_count_formula (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : ℝ) =
      ((N : ℝ) * (CyclicNormalization.normalizedQuadratic sockets : ℝ) -
        normalizedNormEnergy sockets) / 4 := by
  apply (eq_div_iff (by norm_num : (4 : ℝ) ≠ 0)).mpr
  apply (eq_sub_iff_add_eq).mpr
  simpa only [mul_comm] using complex_cyclic_count_identity sockets hd h4

#print axioms rootNormEnergy_coe
#print axioms normalizedNormEnergy_coe
#print axioms complex_cyclic_count_identity
#print axioms complex_cyclic_count_formula
end AbsorbingFourier
