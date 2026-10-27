/-
Almost-sure consistency of the three bow-free plug-in estimators.

Each `recoverBow*` is continuous at a positive-definite parameter point,
because its only divisions are by the pivot or the trailing minor, both
nonzero there. The strong law in `Law.lean` supplies the block convergence,
and the population left inverse identifies the limit.
-/

import CorrelatedResiduals.BowFree
import CorrelatedResiduals.BowMissing
import CorrelatedResiduals.Law

open Filter Matrix MeasureTheory ProbabilityTheory Topology

namespace CorrelatedResiduals

lemma tendsto_cov_blocks {S : ℕ → Cov} {cov : Cov}
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds cov.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds cov.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx)) :
    Tendsto (fun n => ((S n).yy, (S n).yx, (S n).xx)) atTop
      (nhds (cov.yy, cov.yx, cov.xx)) := by
  rw [nhds_prod_eq, nhds_prod_eq]
  exact hyy.prodMk (hyx.prodMk hxx)

/-! ### Bow: missing edge `(0,2)` -/

noncomputable def bowV3 (Ω : M3) : ℝ := Ω 2 2

noncomputable def bowB23 (Ω : M3) : ℝ := Ω 1 2 / bowV3 Ω

noncomputable def bowDen (Ω : M3) : ℝ := Ω 1 1 * Ω 2 2 - Ω 1 2 ^ 2

noncomputable def bowV2 (Ω : M3) : ℝ := bowDen Ω / bowV3 Ω

noncomputable def bowB12 (Ω : M3) : ℝ :=
  (Ω 0 1 * Ω 2 2 - Ω 0 2 * Ω 1 2) / bowDen Ω

noncomputable def bowC (Ω : M3) : ℝ :=
  (Ω 0 2 * Ω 1 1 - Ω 0 1 * Ω 1 2) * Ω 2 2 / bowDen Ω

noncomputable def bowV1 (Ω : M3) : ℝ :=
  Ω 0 0 - bowB12 Ω ^ 2 * bowV2 Ω - 2 * bowB12 Ω * bowB23 Ω * bowC Ω -
    bowB12 Ω ^ 2 * bowB23 Ω ^ 2 * bowV3 Ω

noncomputable def bowBMat (Ω : M3) : M3 :=
  !![0, bowB12 Ω, 0; 0, 0, bowB23 Ω; 0, 0, 0]

noncomputable def bowGamma (Ω yx xx : M3) : M3 :=
  (1 - bowBMat Ω) * yx * xx⁻¹

lemma readBow_coefs (Ω : M3) :
    readBow Ω = (bowB12 Ω, bowB23 Ω, bowV1 Ω, bowV2 Ω, bowV3 Ω, bowC Ω) := by
  unfold readBow bowB12 bowB23 bowV1 bowV2 bowV3 bowC bowDen
  rfl

lemma recoverBow_fields (cov : Cov) :
    (recoverBow cov).b12 = bowB12 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).b23 = bowB23 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).v1 = bowV1 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).v2 = bowV2 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).v3 = bowV3 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).c = bowC (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow cov).gamma =
        bowGamma (schurAt cov.yy cov.yx cov.xx) cov.yx cov.xx ∧
      (recoverBow cov).phi = cov.xx := by
  have hread := readBow_coefs (cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ)
  unfold recoverBow bowGamma bowBMat schurAt
  dsimp
  rw [hread]
  dsimp
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

lemma continuousAt_bowB23 {Ω : M3} (h3 : bowV3 Ω ≠ 0) : ContinuousAt bowB23 Ω := by
  unfold bowB23 bowV3
  exact (continuous_entry 1 2).continuousAt.div (continuous_entry 2 2).continuousAt h3

lemma continuous_bowDen : Continuous bowDen := by
  unfold bowDen
  exact ((continuous_entry 1 1).mul (continuous_entry 2 2)).sub ((continuous_entry 1 2).pow 2)

lemma continuous_bowV3 : Continuous bowV3 := by
  unfold bowV3
  exact continuous_entry 2 2

lemma continuousAt_bowV2 {Ω : M3} (h3 : bowV3 Ω ≠ 0) : ContinuousAt bowV2 Ω := by
  unfold bowV2
  exact continuous_bowDen.continuousAt.div continuous_bowV3.continuousAt h3

lemma continuousAt_bowB12 {Ω : M3} (hden : bowDen Ω ≠ 0) : ContinuousAt bowB12 Ω := by
  unfold bowB12
  refine ContinuousAt.div ?_ continuous_bowDen.continuousAt hden
  exact ((continuous_entry 0 1).continuousAt.mul (continuous_entry 2 2).continuousAt).sub
    ((continuous_entry 0 2).continuousAt.mul (continuous_entry 1 2).continuousAt)

lemma continuousAt_bowC {Ω : M3} (hden : bowDen Ω ≠ 0) : ContinuousAt bowC Ω := by
  unfold bowC
  refine ContinuousAt.div ?_ continuous_bowDen.continuousAt hden
  exact (((continuous_entry 0 2).continuousAt.mul (continuous_entry 1 1).continuousAt).sub
      ((continuous_entry 0 1).continuousAt.mul (continuous_entry 1 2).continuousAt)).mul
    (continuous_entry 2 2).continuousAt

lemma continuousAt_bowV1 {Ω : M3} (h3 : bowV3 Ω ≠ 0) (hden : bowDen Ω ≠ 0) :
    ContinuousAt bowV1 Ω := by
  unfold bowV1
  exact (((continuous_entry 0 0).continuousAt.sub
        (((continuousAt_bowB12 hden).pow 2).mul (continuousAt_bowV2 h3))).sub
      ((((continuousAt_const.mul (continuousAt_bowB12 hden)).mul
            (continuousAt_bowB23 h3)).mul (continuousAt_bowC hden)))).sub
    ((((continuousAt_bowB12 hden).pow 2).mul ((continuousAt_bowB23 h3).pow 2)).mul
      continuous_bowV3.continuousAt)

lemma continuousAt_bowBMat {Ω : M3} (h3 : bowV3 Ω ≠ 0) (hden : bowDen Ω ≠ 0) :
    ContinuousAt bowBMat Ω := by
  refine continuousAt_of_entries fun i j => ?_
  fin_cases i <;> fin_cases j <;> simp [bowBMat]
  · exact continuousAt_const
  · exact continuousAt_bowB12 hden
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_bowB23 h3
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const

lemma schurAt_bow (θ : Bow) (hφ : θ.phi.PosDef) :
    schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx = θ.omega := by
  simpa [Bow.sigma, Bow.omega, schurAt] using
    schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ

lemma bowDen_omega (θ : Bow) : bowDen θ.omega = θ.v2 * θ.v3 := by
  unfold bowDen
  rw [Bow.omega_11, Bow.omega_22, Bow.omega_12]
  ring

theorem bow_continuous_mapping {S : ℕ → Cov} {cov : Cov}
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds cov.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds cov.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx))
    (hφ : IsUnit cov.xx.det)
    (h3 : bowV3 (schurAt cov.yy cov.yx cov.xx) ≠ 0)
    (hden : bowDen (schurAt cov.yy cov.yx cov.xx) ≠ 0) :
    Tendsto (fun n =>
        ((recoverBow (S n)).b12, (recoverBow (S n)).b23, (recoverBow (S n)).v1,
          (recoverBow (S n)).v2, (recoverBow (S n)).v3, (recoverBow (S n)).c,
          (recoverBow (S n)).gamma, (recoverBow (S n)).phi))
      atTop
      (nhds
        ((recoverBow cov).b12, (recoverBow cov).b23, (recoverBow cov).v1,
          (recoverBow cov).v2, (recoverBow cov).v3, (recoverBow cov).c,
          (recoverBow cov).gamma, (recoverBow cov).phi)) := by
  let Ωp : M3 × M3 × M3 → M3 := fun p => schurAt p.1 p.2.1 p.2.2
  have hblocks := tendsto_cov_blocks hyy hyx hxx
  have hΩ : ContinuousAt Ωp (cov.yy, cov.yx, cov.xx) := continuousAt_schur hφ
  have hb12 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowB12 hden) hΩ).tendsto.comp hblocks
  have hb23 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowB23 h3) hΩ).tendsto.comp hblocks
  have hv1 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowV1 h3 hden) hΩ).tendsto.comp hblocks
  have hv2 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowV2 h3) hΩ).tendsto.comp hblocks
  have hv3 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      continuous_bowV3.continuousAt hΩ).tendsto.comp hblocks
  have hc :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowC hden) hΩ).tendsto.comp hblocks
  have hγ : ContinuousAt (fun p : M3 × M3 × M3 => bowGamma (Ωp p) p.2.1 p.2.2)
      (cov.yy, cov.yx, cov.xx) := by
    have hB := ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bowBMat h3 hden) hΩ
    have hone : ContinuousAt (fun p : M3 × M3 × M3 => (1 : M3) - bowBMat (Ωp p))
        (cov.yy, cov.yx, cov.xx) :=
      continuousAt_const.sub hB
    have hyx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.1) (cov.yy, cov.yx, cov.xx) :=
      (continuous_fst.comp continuous_snd).continuousAt
    have hxx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2) (cov.yy, cov.yx, cov.xx) :=
      (continuous_snd.comp continuous_snd).continuousAt
    have hinv := ContinuousAt.comp' (f := fun p : M3 × M3 × M3 => p.2.2)
      (x := (cov.yy, cov.yx, cov.xx)) (continuousAt_matrix_inv_of_det hφ) hxx'
    unfold bowGamma
    exact (hone.mul hyx').mul hinv
  have hgamma := hγ.tendsto.comp hblocks
  have hphi : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx) := hxx
  have hcoef :
      Tendsto (fun n =>
          (bowB12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowB23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowC (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowGamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx))
        atTop
        (nhds
          (bowB12 (Ωp (cov.yy, cov.yx, cov.xx)),
            bowB23 (Ωp (cov.yy, cov.yx, cov.xx)),
            bowV1 (Ωp (cov.yy, cov.yx, cov.xx)),
            bowV2 (Ωp (cov.yy, cov.yx, cov.xx)),
            bowV3 (Ωp (cov.yy, cov.yx, cov.xx)),
            bowC (Ωp (cov.yy, cov.yx, cov.xx)),
            bowGamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx,
            cov.xx)) := by
    simp only [nhds_prod_eq]
    exact hb12.prodMk (hb23.prodMk (hv1.prodMk
      (hv2.prodMk (hv3.prodMk (hc.prodMk (hgamma.prodMk hphi))))))
  have htransport :
      (fun n =>
          ((recoverBow (S n)).b12, (recoverBow (S n)).b23, (recoverBow (S n)).v1,
            (recoverBow (S n)).v2, (recoverBow (S n)).v3, (recoverBow (S n)).c,
            (recoverBow (S n)).gamma, (recoverBow (S n)).phi)) =
        fun n =>
          (bowB12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowB23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowV3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowC (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bowGamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx) := by
    funext n
    obtain ⟨hb12s, hb23s, hv1s, hv2s, hv3s, hcs, hγs, hφs⟩ := recoverBow_fields (S n)
    simp [hb12s, hb23s, hv1s, hv2s, hv3s, hcs, hγs, hφs, Ωp]
  have hlimit :
      ((recoverBow cov).b12, (recoverBow cov).b23, (recoverBow cov).v1,
          (recoverBow cov).v2, (recoverBow cov).v3, (recoverBow cov).c,
          (recoverBow cov).gamma, (recoverBow cov).phi) =
        (bowB12 (Ωp (cov.yy, cov.yx, cov.xx)), bowB23 (Ωp (cov.yy, cov.yx, cov.xx)),
          bowV1 (Ωp (cov.yy, cov.yx, cov.xx)), bowV2 (Ωp (cov.yy, cov.yx, cov.xx)),
          bowV3 (Ωp (cov.yy, cov.yx, cov.xx)), bowC (Ωp (cov.yy, cov.yx, cov.xx)),
          bowGamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx, cov.xx) := by
    obtain ⟨hb12c, hb23c, hv1c, hv2c, hv3c, hcc, hγc, hφc⟩ := recoverBow_fields cov
    simp [hb12c, hb23c, hv1c, hv2c, hv3c, hcc, hγc, hφc, Ωp]
  rw [htransport, hlimit]
  exact hcoef

theorem plug_in_bow_consistent {S : ℕ → Cov} {θ : Bow} (hθ : OnBow θ)
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds θ.sigma.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds θ.sigma.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds θ.sigma.xx)) :
    Tendsto (fun n =>
        ((recoverBow (S n)).b12, (recoverBow (S n)).b23, (recoverBow (S n)).v1,
          (recoverBow (S n)).v2, (recoverBow (S n)).v3, (recoverBow (S n)).c,
          (recoverBow (S n)).gamma, (recoverBow (S n)).phi))
      atTop
      (nhds (θ.b12, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  have hθ0 := hθ
  obtain ⟨hN, hφ⟩ := hθ
  have hunit : IsUnit θ.sigma.xx.det := by
    simpa [Bow.sigma] using (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  have hschur := schurAt_bow θ hφ
  have h3 : bowV3 (schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx) ≠ 0 := by
    rw [hschur, bowV3, Bow.omega_22]
    exact (Bow.v3_pos θ hN).ne'
  have hden : bowDen (schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx) ≠ 0 := by
    rw [hschur, bowDen_omega]
    exact mul_ne_zero (Bow.v2_pos θ hN).ne' (Bow.v3_pos θ hN).ne'
  have hmap := bow_continuous_mapping hyy hyx hxx hunit h3 hden
  have hid := recover_bow θ hθ0
  simpa [hid] using hmap

theorem plug_in_bow_consistent_ae {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Bow} (hθ : OnBow θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (hint : ∀ a b : Idx, Integrable (fun ω => Z 0 ω a * Z 0 ω b) μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = θ.sigma.yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = θ.sigma.yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = θ.sigma.xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recoverBow (sampleCov Z n ω)).b12, (recoverBow (sampleCov Z n ω)).b23,
          (recoverBow (sampleCov Z n ω)).v1, (recoverBow (sampleCov Z n ω)).v2,
          (recoverBow (sampleCov Z n ω)).v3, (recoverBow (sampleCov Z n ω)).c,
          (recoverBow (sampleCov Z n ω)).gamma, (recoverBow (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  filter_upwards [strong_gram Z hindep hident hint] with ω hω
  have hyy' : Tendsto (fun n => (sampleCov Z n ω).yy) atTop (nhds θ.sigma.yy) := by
    have hpop : blockYY (popGram μ (Z 0)) = θ.sigma.yy := by
      ext i j
      simpa [blockYY, popGram] using hyy i j
    simpa [sampleCov, hpop] using tendsto_blockYY hω
  have hyx' : Tendsto (fun n => (sampleCov Z n ω).yx) atTop (nhds θ.sigma.yx) := by
    have hpop : blockYX (popGram μ (Z 0)) = θ.sigma.yx := by
      ext i j
      simpa [blockYX, popGram] using hyx i j
    simpa [sampleCov, hpop] using tendsto_blockYX hω
  have hxx' : Tendsto (fun n => (sampleCov Z n ω).xx) atTop (nhds θ.sigma.xx) := by
    have hpop : blockXX (popGram μ (Z 0)) = θ.sigma.xx := by
      ext i j
      simpa [blockXX, popGram] using hxx i j
    simpa [sampleCov, hpop] using tendsto_blockXX hω
  exact plug_in_bow_consistent hθ hyy' hyx' hxx'

theorem plug_in_bow_consistent_ae_of_second {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Bow} (hθ : OnBow θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (h2 : ∀ a : Idx, MemLp (fun ω => Z 0 ω a) 2 μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = θ.sigma.yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = θ.sigma.yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = θ.sigma.xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recoverBow (sampleCov Z n ω)).b12, (recoverBow (sampleCov Z n ω)).b23,
          (recoverBow (sampleCov Z n ω)).v1, (recoverBow (sampleCov Z n ω)).v2,
          (recoverBow (sampleCov Z n ω)).v3, (recoverBow (sampleCov Z n ω)).c,
          (recoverBow (sampleCov Z n ω)).gamma, (recoverBow (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) :=
  plug_in_bow_consistent_ae hθ hindep hident
    (fun a b => integrable_mul_of_memLp_two (h2 a) (h2 b)) hyy hyx hxx

theorem plug_in_bow_consistent_ae_of_fourth {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {Z : ℕ → Ω → Idx → ℝ} {θ : Bow} (hθ : OnBow θ)
    (hindep : Pairwise fun i j => IndepFun (Z i) (Z j) μ)
    (hident : ∀ i, IdentDistrib (Z i) (Z 0) μ μ)
    (h4 : ∀ a : Idx, MemLp (fun ω => Z 0 ω a) 4 μ)
    (hyy : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inl j) ∂μ = θ.sigma.yy i j)
    (hyx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inl i) * Z 0 ω (.inr j) ∂μ = θ.sigma.yx i j)
    (hxx : ∀ i j : Fin 3,
      ∫ ω, Z 0 ω (.inr i) * Z 0 ω (.inr j) ∂μ = θ.sigma.xx i j) :
    ∀ᵐ ω ∂μ, Tendsto (fun n =>
        ((recoverBow (sampleCov Z n ω)).b12, (recoverBow (sampleCov Z n ω)).b23,
          (recoverBow (sampleCov Z n ω)).v1, (recoverBow (sampleCov Z n ω)).v2,
          (recoverBow (sampleCov Z n ω)).v3, (recoverBow (sampleCov Z n ω)).c,
          (recoverBow (sampleCov Z n ω)).gamma, (recoverBow (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) :=
  plug_in_bow_consistent_ae hθ hindep hident
    (fun a b => integrable_mul_of_memLp_four (h4 a) (h4 b)) hyy hyx hxx

end CorrelatedResiduals
