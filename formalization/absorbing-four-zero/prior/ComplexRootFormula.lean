import ComplexMatrixCount

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {N : ℕ} [NeZero N]
variable {P R : Type*} [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

theorem complex_root_parseval (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) :
    rootVectorEnergy sockets p q d = (N : ℝ) *
      (CyclicNormalization.energyTerm (CyclicNormalization.incidence sockets) (p,0) (q,d) : ℝ) := by
  rw [rootVectorEnergy_eq]
  apply Complex.ofReal_injective
  simpa only [rootNormEnergy_coe, Complex.ofReal_mul, Complex.ofReal_natCast, ZMod.card]
    using rootFrequencyEnergy_eq ZMod.stdAddChar ZMod.injective_stdAddChar
      standard_character_star sockets p q d

noncomputable def complexRootSummand (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) : ℝ :=
  if (p,0) ≠ (q,d) ∧
      (CyclicNormalization.incidence sockets (p,0) ∩
       CyclicNormalization.incidence sockets (q,d)).Nonempty then
    let W := PairFormula.properCommon (CyclicNormalization.incidence sockets) (p,0) (q,d)
    (W.card : ℝ)^2 + 2 * (W.card : ℝ) -
      (1 / (N : ℝ)) * ∑ j : ZMod N, ‖evaluatedVector sockets W j‖ ^ 2
  else 0

theorem complexRootSummand_eq (sockets : P → Finset (R × ZMod N))
    (p q : P) (d : ZMod N) :
    complexRootSummand sockets p q d =
      (CyclicNormalization.quadraticTerm (CyclicNormalization.incidence sockets) (p,0) (q,d) : ℝ) -
        rootVectorEnergy sockets p q d / (N : ℝ) := by
  classical
  unfold complexRootSummand CyclicNormalization.quadraticTerm rootVectorEnergy
  split_ifs <;> simp only [Nat.cast_add, Nat.cast_pow, Nat.cast_mul, Nat.cast_ofNat,
    Nat.cast_zero, zero_div, sub_zero]
  ring

/-- Literal per-root form: N/4 times t²+2t minus the unnormalized Fourier
energy divided by N. The indicator and the full rectangular matrix are fixed
by sockets; no eigenvalue-only data is substituted. -/
theorem complex_root_count_formula (sockets : P → Finset (R × ZMod N))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : ℝ) =
      ((N : ℝ) / 4) * ∑ p : P, ∑ q : P, ∑ d : ZMod N,
        complexRootSummand sockets p q d := by
  rw [complex_matrix_count_formula sockets hd h4]
  simp only [complexRootSummand_eq, Finset.sum_sub_distrib, ← Finset.sum_div]
  simp only [CyclicNormalization.normalizedQuadratic, Nat.cast_sum]
  have hn : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (NeZero.ne N)
  field_simp
  <;> ring

#print axioms complex_root_parseval
#print axioms complexRootSummand_eq
#print axioms complex_root_count_formula
end AbsorbingFourier
