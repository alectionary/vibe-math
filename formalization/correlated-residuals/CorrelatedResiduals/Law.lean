/-
Almost-sure consistency of the equation-(7) plug-in estimator.

Mathlib's strong law (`ProbabilityTheory.strong_law_ae_real`) needs only
pairwise independence, identical distribution, and integrability. Applied to
the coordinate products of an i.i.d. sample in `ℝ³ × ℝ³`, it gives almost-sure
convergence of every empirical second-moment entry. Finite second moments of
the coordinates imply those products are integrable, by Hölder; finite fourth
moments do as well on a probability space, since `L⁴ ⊂ L²` there. Either
hypothesis, together with the population blocks equaling `sigma θ`, feeds
`plug_in_consistent`.
-/

import CorrelatedResiduals.Consistency
import Mathlib.Data.ENNReal.Holder
import Mathlib.MeasureTheory.Function.L1Space.Integrable
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Function.LpSeminorm.CompareExp
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.Probability.StrongLaw

open Filter Finset Matrix MeasureTheory ProbabilityTheory Topology

namespace CorrelatedResiduals

/-- Endogenous coordinate on the left, exogenous coordinate on the right. -/
abbrev Idx := Fin 3 ⊕ Fin 3

def gram (z : Idx → ℝ) : Matrix Idx Idx ℝ :=
  fun a b => z a * z b

noncomputable def empiricGram {Ω : Type*} (Z : ℕ → Ω → Idx → ℝ) (n : ℕ) (ω : Ω) :
    Matrix Idx Idx ℝ :=
  (n : ℝ)⁻¹ • ∑ i ∈ range n, gram (Z i ω)

noncomputable def popGram {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (Z : Ω → Idx → ℝ) :
    Matrix Idx Idx ℝ :=
  fun a b => ∫ ω, Z ω a * Z ω b ∂μ

def blockYY (A : Matrix Idx Idx ℝ) : M3 :=
  fun i j => A (.inl i) (.inl j)

def blockYX (A : Matrix Idx Idx ℝ) : M3 :=
  fun i j => A (.inl i) (.inr j)

def blockXX (A : Matrix Idx Idx ℝ) : M3 :=
  fun i j => A (.inr i) (.inr j)

noncomputable def sampleCov {Ω : Type*} (Z : ℕ → Ω → Idx → ℝ) (n : ℕ) (ω : Ω) : Cov :=
  { yy := blockYY (empiricGram Z n ω)
    yx := blockYX (empiricGram Z n ω)
    xx := blockXX (empiricGram Z n ω) }

lemma holderTriple_two_two : ENNReal.HolderTriple 2 2 1 := by
  have hR : Real.HolderTriple 2 2 1 := ⟨by norm_num, by norm_num, by norm_num⟩
  have hnn : NNReal.HolderTriple 2 2 1 :=
    (NNReal.holderTriple_coe_iff (p := 2) (q := 2) (r := 1)).1 hR
  exact (ENNReal.holderTriple_coe_iff (p := 2) (q := 2) (r := 1) one_ne_zero).2 hnn

/-- Square-integrable coordinates have an integrable product. -/
lemma integrable_mul_of_memLp_two {Ω : Type*} {m : MeasurableSpace Ω} {μ : Measure Ω}
    {f g : Ω → ℝ} (hf : MemLp f 2 μ) (hg : MemLp g 2 μ) : Integrable (f * g) μ := by
  haveI := holderTriple_two_two
  exact MemLp.integrable_mul hf hg

/-- On a probability space, finite fourth moments give the same integrability. -/
lemma integrable_mul_of_memLp_four {Ω : Type*} {m : MeasurableSpace Ω} {μ : Measure Ω}
    [IsProbabilityMeasure μ] {f g : Ω → ℝ} (hf : MemLp f 4 μ) (hg : MemLp g 4 μ) :
    Integrable (f * g) μ := by
  have h24 : (2 : ENNReal) ≤ 4 := by norm_num
  exact integrable_mul_of_memLp_two (hf.mono_exponent h24) (hg.mono_exponent h24)

lemma empiricGram_apply {Ω : Type*} (Z : ℕ → Ω → Idx → ℝ) (n : ℕ) (ω : Ω) (a b : Idx) :
    empiricGram Z n ω a b = (∑ i ∈ range n, Z i ω a * Z i ω b) / (n : ℝ) := by
  unfold empiricGram gram
  rw [Pi.smul_apply, Pi.smul_apply, smul_eq_mul, Finset.sum_apply, Finset.sum_apply,
    div_eq_mul_inv, mul_comm]

lemma coordMul_measurable (a b : Idx) : Measurable fun z : Idx → ℝ => z a * z b :=
  (measurable_pi_apply a).mul (measurable_pi_apply b)

lemma strong_entry {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    (Z : ℕ → Ω → Idx → ℝ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (hint : ∀ a b : Idx, Integrable (fun ω => Z 0 ω a * Z 0 ω b) μ)
    (a b : Idx) :
    ∀ᵐ ω ∂μ, Tendsto (fun n => empiricGram Z n ω a b) atTop
      (𝓝 (∫ ω, Z 0 ω a * Z 0 ω b ∂μ)) := by
  let X : ℕ → Ω → ℝ := fun i ω => Z i ω a * Z i ω b
  have hφ : Measurable fun z : Idx → ℝ => z a * z b := coordMul_measurable a b
  have hXindep : Pairwise fun i j => IndepFun (X i) (X j) μ := by
    intro i j hij
    simpa [X, Function.comp_def] using (hindep hij).comp hφ hφ
  have hXident : ∀ i, IdentDistrib (X i) (X 0) μ μ := by
    intro i
    simpa [X, Function.comp_def] using (hident i).comp hφ
  have hintX : Integrable (X 0) μ := by simpa [X] using hint a b
  filter_upwards [strong_law_ae_real X hintX hXindep hXident] with ω hω
  have hfun : (fun n => empiricGram Z n ω a b) =
      fun n => (∑ i ∈ range n, X i ω) / (n : ℝ) := by
    funext n
    simpa [X] using empiricGram_apply Z n ω a b
  rw [hfun]
  simpa [X] using hω

lemma strong_gram {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    (Z : ℕ → Ω → Idx → ℝ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (hint : ∀ a b : Idx, Integrable (fun ω => Z 0 ω a * Z 0 ω b) μ) :
    ∀ᵐ ω ∂μ, Tendsto (fun n => empiricGram Z n ω) atTop (𝓝 (popGram μ (Z 0))) := by
  have hent : ∀ p : Idx × Idx, ∀ᵐ ω ∂μ,
      Tendsto (fun n => empiricGram Z n ω p.1 p.2) atTop
        (𝓝 (popGram μ (Z 0) p.1 p.2)) := by
    intro p
    simpa [popGram] using strong_entry Z hindep hident hint p.1 p.2
  filter_upwards [ae_all_iff.mpr hent] with ω hω
  rw [tendsto_pi_nhds]
  intro a
  rw [tendsto_pi_nhds]
  intro b
  exact hω (a, b)

lemma tendsto_blockYY {f : ℕ → Matrix Idx Idx ℝ} {A : Matrix Idx Idx ℝ}
    (h : Tendsto f atTop (𝓝 A)) :
    Tendsto (fun n => blockYY (f n)) atTop (𝓝 (blockYY A)) := by
  rw [tendsto_pi_nhds]
  intro i
  rw [tendsto_pi_nhds]
  intro j
  simpa [blockYY] using ((h.apply_nhds (.inl i)).apply_nhds (.inl j))

lemma tendsto_blockYX {f : ℕ → Matrix Idx Idx ℝ} {A : Matrix Idx Idx ℝ}
    (h : Tendsto f atTop (𝓝 A)) :
    Tendsto (fun n => blockYX (f n)) atTop (𝓝 (blockYX A)) := by
  rw [tendsto_pi_nhds]
  intro i
  rw [tendsto_pi_nhds]
  intro j
  simpa [blockYX] using ((h.apply_nhds (.inl i)).apply_nhds (.inr j))

lemma tendsto_blockXX {f : ℕ → Matrix Idx Idx ℝ} {A : Matrix Idx Idx ℝ}
    (h : Tendsto f atTop (𝓝 A)) :
    Tendsto (fun n => blockXX (f n)) atTop (𝓝 (blockXX A)) := by
  rw [tendsto_pi_nhds]
  intro i
  rw [tendsto_pi_nhds]
  intro j
  simpa [blockXX] using ((h.apply_nhds (.inr i)).apply_nhds (.inr j))

lemma blockYY_pop {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {Z : Ω → Idx → ℝ} {θ : Params}
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z ω (.inl i) * Z ω (.inl j) ∂μ = (sigma θ).yy i j) :
    blockYY (popGram μ Z) = (sigma θ).yy := by
  ext i j
  simpa [blockYY, popGram] using hyy i j

lemma blockYX_pop {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {Z : Ω → Idx → ℝ} {θ : Params}
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z ω (.inl i) * Z ω (.inr j) ∂μ = (sigma θ).yx i j) :
    blockYX (popGram μ Z) = (sigma θ).yx := by
  ext i j
  simpa [blockYX, popGram] using hyx i j

lemma blockXX_pop {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {Z : Ω → Idx → ℝ} {θ : Params}
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z ω (.inr i) * Z ω (.inr j) ∂μ = (sigma θ).xx i j) :
    blockXX (popGram μ Z) = (sigma θ).xx := by
  ext i j
  simpa [blockXX, popGram] using hxx i j

/-- Pairwise i.i.d. samples with integrable coordinate products are consistent for `recover`. -/
theorem plug_in_consistent_ae {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Params} (hθ : OnDomain θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (hint : ∀ a b : Idx, Integrable (fun ω => Z 0 ω a * Z 0 ω b) μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = (sigma θ).yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = (sigma θ).yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = (sigma θ).xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recover (sampleCov Z n ω)).b12, (recover (sampleCov Z n ω)).b13,
          (recover (sampleCov Z n ω)).b23, (recover (sampleCov Z n ω)).v1,
          (recover (sampleCov Z n ω)).v2, (recover (sampleCov Z n ω)).v3,
          (recover (sampleCov Z n ω)).gamma, (recover (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.gamma, θ.phi)) := by
  filter_upwards [strong_gram Z hindep hident hint] with ω hω
  have hyy' : Tendsto (fun n => (sampleCov Z n ω).yy) atTop (nhds (sigma θ).yy) := by
    simpa [sampleCov, blockYY_pop hyy] using tendsto_blockYY hω
  have hyx' : Tendsto (fun n => (sampleCov Z n ω).yx) atTop (nhds (sigma θ).yx) := by
    simpa [sampleCov, blockYX_pop hyx] using tendsto_blockYX hω
  have hxx' : Tendsto (fun n => (sampleCov Z n ω).xx) atTop (nhds (sigma θ).xx) := by
    simpa [sampleCov, blockXX_pop hxx] using tendsto_blockXX hω
  exact plug_in_consistent hθ hyy' hyx' hxx'

/-- The same conclusion from finite second moments of each coordinate. -/
theorem plug_in_consistent_ae_of_second {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Params} (hθ : OnDomain θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (h2 : ∀ a : Idx, MemLp (fun ω => Z 0 ω a) 2 μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = (sigma θ).yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = (sigma θ).yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = (sigma θ).xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recover (sampleCov Z n ω)).b12, (recover (sampleCov Z n ω)).b13,
          (recover (sampleCov Z n ω)).b23, (recover (sampleCov Z n ω)).v1,
          (recover (sampleCov Z n ω)).v2, (recover (sampleCov Z n ω)).v3,
          (recover (sampleCov Z n ω)).gamma, (recover (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.gamma, θ.phi)) :=
  plug_in_consistent_ae hθ hindep hident
    (fun a b => integrable_mul_of_memLp_two (h2 a) (h2 b)) hyy hyx hxx

/-- The same conclusion from finite fourth moments on a probability space. -/
theorem plug_in_consistent_ae_of_fourth {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {Z : ℕ → Ω → Idx → ℝ} {θ : Params} (hθ : OnDomain θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (h4 : ∀ a : Idx, MemLp (fun ω => Z 0 ω a) 4 μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = (sigma θ).yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = (sigma θ).yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = (sigma θ).xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recover (sampleCov Z n ω)).b12, (recover (sampleCov Z n ω)).b13,
          (recover (sampleCov Z n ω)).b23, (recover (sampleCov Z n ω)).v1,
          (recover (sampleCov Z n ω)).v2, (recover (sampleCov Z n ω)).v3,
          (recover (sampleCov Z n ω)).gamma, (recover (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.gamma, θ.phi)) :=
  plug_in_consistent_ae hθ hindep hident
    (fun a b => integrable_mul_of_memLp_four (h4 a) (h4 b)) hyy hyx hxx

end CorrelatedResiduals
