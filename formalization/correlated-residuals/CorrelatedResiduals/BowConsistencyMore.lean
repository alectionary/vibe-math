/-
Almost-sure consistency for the other two bow-free plug-ins.
-/

import CorrelatedResiduals.BowConsistency

open Filter Matrix MeasureTheory ProbabilityTheory Topology

namespace CorrelatedResiduals

/-! ### Bow01: missing edge `(0,1)` -/

noncomputable def bow01V3 (Ω : M3) : ℝ := Ω 2 2

noncomputable def bow01B13 (Ω : M3) : ℝ := Ω 0 2 / bow01V3 Ω

noncomputable def bow01B23 (Ω : M3) : ℝ := Ω 1 2 / bow01V3 Ω

noncomputable def bow01V1 (Ω : M3) : ℝ := Ω 0 0 - bow01B13 Ω ^ 2 * bow01V3 Ω

noncomputable def bow01V2 (Ω : M3) : ℝ := Ω 1 1 - bow01B23 Ω ^ 2 * bow01V3 Ω

noncomputable def bow01C (Ω : M3) : ℝ :=
  Ω 0 1 - bow01B13 Ω * bow01B23 Ω * bow01V3 Ω

noncomputable def bow01BMat (Ω : M3) : M3 :=
  !![0, 0, bow01B13 Ω; 0, 0, bow01B23 Ω; 0, 0, 0]

noncomputable def bow01Gamma (Ω yx xx : M3) : M3 :=
  (1 - bow01BMat Ω) * yx * xx⁻¹

lemma readBow01_coefs (Ω : M3) :
    readBow01 Ω = (bow01B13 Ω, bow01B23 Ω, bow01V1 Ω, bow01V2 Ω, bow01V3 Ω, bow01C Ω) := by
  unfold readBow01 bow01B13 bow01B23 bow01V1 bow01V2 bow01V3 bow01C
  rfl

lemma recoverBow01_fields (cov : Cov) :
    (recoverBow01 cov).b13 = bow01B13 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).b23 = bow01B23 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).v1 = bow01V1 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).v2 = bow01V2 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).v3 = bow01V3 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).c = bow01C (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow01 cov).gamma =
        bow01Gamma (schurAt cov.yy cov.yx cov.xx) cov.yx cov.xx ∧
      (recoverBow01 cov).phi = cov.xx := by
  have hread := readBow01_coefs (cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ)
  unfold recoverBow01 bow01Gamma bow01BMat schurAt
  dsimp
  rw [hread]
  dsimp
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

lemma continuous_bow01V3 : Continuous bow01V3 := by
  unfold bow01V3
  exact continuous_entry 2 2

lemma continuousAt_bow01B13 {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01B13 Ω := by
  unfold bow01B13 bow01V3
  exact (continuous_entry 0 2).continuousAt.div (continuous_entry 2 2).continuousAt h3

lemma continuousAt_bow01B23 {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01B23 Ω := by
  unfold bow01B23 bow01V3
  exact (continuous_entry 1 2).continuousAt.div (continuous_entry 2 2).continuousAt h3

lemma continuousAt_bow01V1 {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01V1 Ω := by
  unfold bow01V1
  exact (continuous_entry 0 0).continuousAt.sub
    (((continuousAt_bow01B13 h3).pow 2).mul continuous_bow01V3.continuousAt)

lemma continuousAt_bow01V2 {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01V2 Ω := by
  unfold bow01V2
  exact (continuous_entry 1 1).continuousAt.sub
    (((continuousAt_bow01B23 h3).pow 2).mul continuous_bow01V3.continuousAt)

lemma continuousAt_bow01C {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01C Ω := by
  unfold bow01C
  exact (continuous_entry 0 1).continuousAt.sub
    (((continuousAt_bow01B13 h3).mul (continuousAt_bow01B23 h3)).mul
      continuous_bow01V3.continuousAt)

lemma continuousAt_bow01BMat {Ω : M3} (h3 : bow01V3 Ω ≠ 0) : ContinuousAt bow01BMat Ω := by
  refine continuousAt_of_entries fun i j => ?_
  fin_cases i <;> fin_cases j <;> simp [bow01BMat]
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_bow01B13 h3
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_bow01B23 h3
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const

lemma schurAt_bow01 (θ : Bow01) (hφ : θ.phi.PosDef) :
    schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx = θ.omega := by
  simpa [Bow01.sigma, Bow01.omega, schurAt] using
    schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ

theorem bow01_continuous_mapping {S : ℕ → Cov} {cov : Cov}
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds cov.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds cov.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx))
    (hφ : IsUnit cov.xx.det)
    (h3 : bow01V3 (schurAt cov.yy cov.yx cov.xx) ≠ 0) :
    Tendsto (fun n =>
        ((recoverBow01 (S n)).b13, (recoverBow01 (S n)).b23, (recoverBow01 (S n)).v1,
          (recoverBow01 (S n)).v2, (recoverBow01 (S n)).v3, (recoverBow01 (S n)).c,
          (recoverBow01 (S n)).gamma, (recoverBow01 (S n)).phi))
      atTop
      (nhds
        ((recoverBow01 cov).b13, (recoverBow01 cov).b23, (recoverBow01 cov).v1,
          (recoverBow01 cov).v2, (recoverBow01 cov).v3, (recoverBow01 cov).c,
          (recoverBow01 cov).gamma, (recoverBow01 cov).phi)) := by
  let Ωp : M3 × M3 × M3 → M3 := fun p => schurAt p.1 p.2.1 p.2.2
  have hblocks := tendsto_cov_blocks hyy hyx hxx
  have hΩ : ContinuousAt Ωp (cov.yy, cov.yx, cov.xx) := continuousAt_schur hφ
  have hb13 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01B13 h3) hΩ).tendsto.comp hblocks
  have hb23 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01B23 h3) hΩ).tendsto.comp hblocks
  have hv1 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01V1 h3) hΩ).tendsto.comp hblocks
  have hv2 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01V2 h3) hΩ).tendsto.comp hblocks
  have hv3 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      continuous_bow01V3.continuousAt hΩ).tendsto.comp hblocks
  have hc :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01C h3) hΩ).tendsto.comp hblocks
  have hγ : ContinuousAt (fun p : M3 × M3 × M3 => bow01Gamma (Ωp p) p.2.1 p.2.2)
      (cov.yy, cov.yx, cov.xx) := by
    have hB := ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow01BMat h3) hΩ
    have hone : ContinuousAt (fun p : M3 × M3 × M3 => (1 : M3) - bow01BMat (Ωp p))
        (cov.yy, cov.yx, cov.xx) :=
      continuousAt_const.sub hB
    have hyx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.1) (cov.yy, cov.yx, cov.xx) :=
      (continuous_fst.comp continuous_snd).continuousAt
    have hxx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2) (cov.yy, cov.yx, cov.xx) :=
      (continuous_snd.comp continuous_snd).continuousAt
    have hinv := ContinuousAt.comp' (f := fun p : M3 × M3 × M3 => p.2.2)
      (x := (cov.yy, cov.yx, cov.xx)) (continuousAt_matrix_inv_of_det hφ) hxx'
    unfold bow01Gamma
    exact (hone.mul hyx').mul hinv
  have hgamma := hγ.tendsto.comp hblocks
  have hcoef :
      Tendsto (fun n =>
          (bow01B13 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01B23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01C (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01Gamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx))
        atTop
        (nhds
          (bow01B13 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01B23 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01V1 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01V2 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01V3 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01C (Ωp (cov.yy, cov.yx, cov.xx)),
            bow01Gamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx,
            cov.xx)) := by
    simp only [nhds_prod_eq]
    exact hb13.prodMk (hb23.prodMk (hv1.prodMk
      (hv2.prodMk (hv3.prodMk (hc.prodMk (hgamma.prodMk hxx))))))
  have htransport :
      (fun n =>
          ((recoverBow01 (S n)).b13, (recoverBow01 (S n)).b23, (recoverBow01 (S n)).v1,
            (recoverBow01 (S n)).v2, (recoverBow01 (S n)).v3, (recoverBow01 (S n)).c,
            (recoverBow01 (S n)).gamma, (recoverBow01 (S n)).phi)) =
        fun n =>
          (bow01B13 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01B23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01V3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01C (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow01Gamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx) := by
    funext n
    obtain ⟨hb13s, hb23s, hv1s, hv2s, hv3s, hcs, hγs, hφs⟩ := recoverBow01_fields (S n)
    simp [hb13s, hb23s, hv1s, hv2s, hv3s, hcs, hγs, hφs, Ωp]
  have hlimit :
      ((recoverBow01 cov).b13, (recoverBow01 cov).b23, (recoverBow01 cov).v1,
          (recoverBow01 cov).v2, (recoverBow01 cov).v3, (recoverBow01 cov).c,
          (recoverBow01 cov).gamma, (recoverBow01 cov).phi) =
        (bow01B13 (Ωp (cov.yy, cov.yx, cov.xx)), bow01B23 (Ωp (cov.yy, cov.yx, cov.xx)),
          bow01V1 (Ωp (cov.yy, cov.yx, cov.xx)), bow01V2 (Ωp (cov.yy, cov.yx, cov.xx)),
          bow01V3 (Ωp (cov.yy, cov.yx, cov.xx)), bow01C (Ωp (cov.yy, cov.yx, cov.xx)),
          bow01Gamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx, cov.xx) := by
    obtain ⟨hb13c, hb23c, hv1c, hv2c, hv3c, hcc, hγc, hφc⟩ := recoverBow01_fields cov
    simp [hb13c, hb23c, hv1c, hv2c, hv3c, hcc, hγc, hφc, Ωp]
  rw [htransport, hlimit]
  exact hcoef

theorem plug_in_bow01_consistent {S : ℕ → Cov} {θ : Bow01} (hθ : OnBow01 θ)
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds θ.sigma.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds θ.sigma.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds θ.sigma.xx)) :
    Tendsto (fun n =>
        ((recoverBow01 (S n)).b13, (recoverBow01 (S n)).b23, (recoverBow01 (S n)).v1,
          (recoverBow01 (S n)).v2, (recoverBow01 (S n)).v3, (recoverBow01 (S n)).c,
          (recoverBow01 (S n)).gamma, (recoverBow01 (S n)).phi))
      atTop
      (nhds (θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  have hθ0 := hθ
  obtain ⟨hN, hφ⟩ := hθ
  have hunit : IsUnit θ.sigma.xx.det := by
    simpa [Bow01.sigma] using (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  have hschur := schurAt_bow01 θ hφ
  have h3 : bow01V3 (schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx) ≠ 0 := by
    rw [hschur, bow01V3, Bow01.omega_22]
    exact (Bow01.v3_pos θ hN).ne'
  simpa [recover_bow01 θ hθ0] using bow01_continuous_mapping hyy hyx hxx hunit h3

theorem plug_in_bow01_consistent_ae {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Bow01} (hθ : OnBow01 θ)
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
        ((recoverBow01 (sampleCov Z n ω)).b13, (recoverBow01 (sampleCov Z n ω)).b23,
          (recoverBow01 (sampleCov Z n ω)).v1, (recoverBow01 (sampleCov Z n ω)).v2,
          (recoverBow01 (sampleCov Z n ω)).v3, (recoverBow01 (sampleCov Z n ω)).c,
          (recoverBow01 (sampleCov Z n ω)).gamma, (recoverBow01 (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  filter_upwards [strong_gram Z hindep hident hint] with ω hω
  have hyy' : Tendsto (fun n => (sampleCov Z n ω).yy) atTop (nhds θ.sigma.yy) := by
    have hpop : blockYY (popGram μ (Z 0)) = θ.sigma.yy := by
      ext i j; simpa [blockYY, popGram] using hyy i j
    simpa [sampleCov, hpop] using tendsto_blockYY hω
  have hyx' : Tendsto (fun n => (sampleCov Z n ω).yx) atTop (nhds θ.sigma.yx) := by
    have hpop : blockYX (popGram μ (Z 0)) = θ.sigma.yx := by
      ext i j; simpa [blockYX, popGram] using hyx i j
    simpa [sampleCov, hpop] using tendsto_blockYX hω
  have hxx' : Tendsto (fun n => (sampleCov Z n ω).xx) atTop (nhds θ.sigma.xx) := by
    have hpop : blockXX (popGram μ (Z 0)) = θ.sigma.xx := by
      ext i j; simpa [blockXX, popGram] using hxx i j
    simpa [sampleCov, hpop] using tendsto_blockXX hω
  exact plug_in_bow01_consistent hθ hyy' hyx' hxx'

/-! ### Bow23: missing edge `(1,2)` -/

noncomputable def bow23V2 (Ω : M3) : ℝ := Ω 1 1
noncomputable def bow23V3 (Ω : M3) : ℝ := Ω 2 2
noncomputable def bow23C (Ω : M3) : ℝ := Ω 1 2
noncomputable def bow23Den (Ω : M3) : ℝ := bow23V2 Ω * bow23V3 Ω - bow23C Ω ^ 2
noncomputable def bow23B12 (Ω : M3) : ℝ :=
  (Ω 0 1 * bow23V3 Ω - Ω 0 2 * bow23C Ω) / bow23Den Ω
noncomputable def bow23B13 (Ω : M3) : ℝ :=
  (Ω 0 2 * bow23V2 Ω - Ω 0 1 * bow23C Ω) / bow23Den Ω
noncomputable def bow23V1 (Ω : M3) : ℝ :=
  Ω 0 0 - bow23B12 Ω * Ω 0 1 - bow23B13 Ω * Ω 0 2
noncomputable def bow23BMat (Ω : M3) : M3 :=
  !![0, bow23B12 Ω, bow23B13 Ω; 0, 0, 0; 0, 0, 0]
noncomputable def bow23Gamma (Ω yx xx : M3) : M3 :=
  (1 - bow23BMat Ω) * yx * xx⁻¹

lemma readBow23_coefs (Ω : M3) :
    readBow23 Ω =
      (bow23B12 Ω, bow23B13 Ω, bow23V1 Ω, bow23V2 Ω, bow23V3 Ω, bow23C Ω) := by
  unfold readBow23 bow23B12 bow23B13 bow23V1 bow23V2 bow23V3 bow23C bow23Den
  rfl

lemma recoverBow23_fields (cov : Cov) :
    (recoverBow23 cov).b12 = bow23B12 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).b13 = bow23B13 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).v1 = bow23V1 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).v2 = bow23V2 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).v3 = bow23V3 (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).c = bow23C (schurAt cov.yy cov.yx cov.xx) ∧
      (recoverBow23 cov).gamma =
        bow23Gamma (schurAt cov.yy cov.yx cov.xx) cov.yx cov.xx ∧
      (recoverBow23 cov).phi = cov.xx := by
  have hread := readBow23_coefs (cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ)
  unfold recoverBow23 bow23Gamma bow23BMat schurAt
  dsimp
  rw [hread]
  dsimp
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

lemma continuous_bow23Den : Continuous bow23Den := by
  unfold bow23Den bow23V2 bow23V3 bow23C
  exact ((continuous_entry 1 1).mul (continuous_entry 2 2)).sub ((continuous_entry 1 2).pow 2)

lemma continuousAt_bow23B12 {Ω : M3} (hden : bow23Den Ω ≠ 0) : ContinuousAt bow23B12 Ω := by
  unfold bow23B12 bow23V3 bow23C
  refine ContinuousAt.div ?_ continuous_bow23Den.continuousAt hden
  exact ((continuous_entry 0 1).continuousAt.mul (continuous_entry 2 2).continuousAt).sub
    ((continuous_entry 0 2).continuousAt.mul (continuous_entry 1 2).continuousAt)

lemma continuousAt_bow23B13 {Ω : M3} (hden : bow23Den Ω ≠ 0) : ContinuousAt bow23B13 Ω := by
  unfold bow23B13 bow23V2 bow23C
  refine ContinuousAt.div ?_ continuous_bow23Den.continuousAt hden
  exact ((continuous_entry 0 2).continuousAt.mul (continuous_entry 1 1).continuousAt).sub
    ((continuous_entry 0 1).continuousAt.mul (continuous_entry 1 2).continuousAt)

lemma continuousAt_bow23V1 {Ω : M3} (hden : bow23Den Ω ≠ 0) : ContinuousAt bow23V1 Ω := by
  unfold bow23V1
  exact ((continuous_entry 0 0).continuousAt.sub
      ((continuousAt_bow23B12 hden).mul (continuous_entry 0 1).continuousAt)).sub
    ((continuousAt_bow23B13 hden).mul (continuous_entry 0 2).continuousAt)

lemma continuous_bow23V2 : Continuous bow23V2 := by
  unfold bow23V2; exact continuous_entry 1 1

lemma continuous_bow23V3 : Continuous bow23V3 := by
  unfold bow23V3; exact continuous_entry 2 2

lemma continuous_bow23C : Continuous bow23C := by
  unfold bow23C; exact continuous_entry 1 2

lemma continuousAt_bow23BMat {Ω : M3} (hden : bow23Den Ω ≠ 0) : ContinuousAt bow23BMat Ω := by
  refine continuousAt_of_entries fun i j => ?_
  fin_cases i <;> fin_cases j <;> simp [bow23BMat]
  · exact continuousAt_const
  · exact continuousAt_bow23B12 hden
  · exact continuousAt_bow23B13 hden
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const

lemma schurAt_bow23 (θ : Bow23) (hφ : θ.phi.PosDef) :
    schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx = θ.omega := by
  simpa [Bow23.sigma, Bow23.omega, schurAt] using
    schur_noise (L := θ.L) (G := θ.gamma) (Φ := θ.phi) (N := θ.noise) hφ

lemma bow23Den_omega (θ : Bow23) : bow23Den θ.omega = θ.v2 * θ.v3 - θ.c ^ 2 := by
  unfold bow23Den bow23V2 bow23V3 bow23C
  rw [Bow23.omega_11, Bow23.omega_22, Bow23.omega_12]

theorem bow23_continuous_mapping {S : ℕ → Cov} {cov : Cov}
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds cov.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds cov.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx))
    (hφ : IsUnit cov.xx.det)
    (hden : bow23Den (schurAt cov.yy cov.yx cov.xx) ≠ 0) :
    Tendsto (fun n =>
        ((recoverBow23 (S n)).b12, (recoverBow23 (S n)).b13, (recoverBow23 (S n)).v1,
          (recoverBow23 (S n)).v2, (recoverBow23 (S n)).v3, (recoverBow23 (S n)).c,
          (recoverBow23 (S n)).gamma, (recoverBow23 (S n)).phi))
      atTop
      (nhds
        ((recoverBow23 cov).b12, (recoverBow23 cov).b13, (recoverBow23 cov).v1,
          (recoverBow23 cov).v2, (recoverBow23 cov).v3, (recoverBow23 cov).c,
          (recoverBow23 cov).gamma, (recoverBow23 cov).phi)) := by
  let Ωp : M3 × M3 × M3 → M3 := fun p => schurAt p.1 p.2.1 p.2.2
  have hblocks := tendsto_cov_blocks hyy hyx hxx
  have hΩ : ContinuousAt Ωp (cov.yy, cov.yx, cov.xx) := continuousAt_schur hφ
  have hb12 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow23B12 hden) hΩ).tendsto.comp hblocks
  have hb13 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow23B13 hden) hΩ).tendsto.comp hblocks
  have hv1 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow23V1 hden) hΩ).tendsto.comp hblocks
  have hv2 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      continuous_bow23V2.continuousAt hΩ).tendsto.comp hblocks
  have hv3 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      continuous_bow23V3.continuousAt hΩ).tendsto.comp hblocks
  have hc :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      continuous_bow23C.continuousAt hΩ).tendsto.comp hblocks
  have hγ : ContinuousAt (fun p : M3 × M3 × M3 => bow23Gamma (Ωp p) p.2.1 p.2.2)
      (cov.yy, cov.yx, cov.xx) := by
    have hB := ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bow23BMat hden) hΩ
    have hone : ContinuousAt (fun p : M3 × M3 × M3 => (1 : M3) - bow23BMat (Ωp p))
        (cov.yy, cov.yx, cov.xx) :=
      continuousAt_const.sub hB
    have hyx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.1) (cov.yy, cov.yx, cov.xx) :=
      (continuous_fst.comp continuous_snd).continuousAt
    have hxx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2) (cov.yy, cov.yx, cov.xx) :=
      (continuous_snd.comp continuous_snd).continuousAt
    have hinv := ContinuousAt.comp' (f := fun p : M3 × M3 × M3 => p.2.2)
      (x := (cov.yy, cov.yx, cov.xx)) (continuousAt_matrix_inv_of_det hφ) hxx'
    unfold bow23Gamma
    exact (hone.mul hyx').mul hinv
  have hgamma := hγ.tendsto.comp hblocks
  have hcoef :
      Tendsto (fun n =>
          (bow23B12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23B13 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23C (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23Gamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx))
        atTop
        (nhds
          (bow23B12 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23B13 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23V1 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23V2 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23V3 (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23C (Ωp (cov.yy, cov.yx, cov.xx)),
            bow23Gamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx,
            cov.xx)) := by
    simp only [nhds_prod_eq]
    exact hb12.prodMk (hb13.prodMk (hv1.prodMk
      (hv2.prodMk (hv3.prodMk (hc.prodMk (hgamma.prodMk hxx))))))
  have htransport :
      (fun n =>
          ((recoverBow23 (S n)).b12, (recoverBow23 (S n)).b13, (recoverBow23 (S n)).v1,
            (recoverBow23 (S n)).v2, (recoverBow23 (S n)).v3, (recoverBow23 (S n)).c,
            (recoverBow23 (S n)).gamma, (recoverBow23 (S n)).phi)) =
        fun n =>
          (bow23B12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23B13 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23V3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23C (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            bow23Gamma (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx) := by
    funext n
    obtain ⟨hb12s, hb13s, hv1s, hv2s, hv3s, hcs, hγs, hφs⟩ := recoverBow23_fields (S n)
    simp [hb12s, hb13s, hv1s, hv2s, hv3s, hcs, hγs, hφs, Ωp]
  have hlimit :
      ((recoverBow23 cov).b12, (recoverBow23 cov).b13, (recoverBow23 cov).v1,
          (recoverBow23 cov).v2, (recoverBow23 cov).v3, (recoverBow23 cov).c,
          (recoverBow23 cov).gamma, (recoverBow23 cov).phi) =
        (bow23B12 (Ωp (cov.yy, cov.yx, cov.xx)), bow23B13 (Ωp (cov.yy, cov.yx, cov.xx)),
          bow23V1 (Ωp (cov.yy, cov.yx, cov.xx)), bow23V2 (Ωp (cov.yy, cov.yx, cov.xx)),
          bow23V3 (Ωp (cov.yy, cov.yx, cov.xx)), bow23C (Ωp (cov.yy, cov.yx, cov.xx)),
          bow23Gamma (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx, cov.xx) := by
    obtain ⟨hb12c, hb13c, hv1c, hv2c, hv3c, hcc, hγc, hφc⟩ := recoverBow23_fields cov
    simp [hb12c, hb13c, hv1c, hv2c, hv3c, hcc, hγc, hφc, Ωp]
  rw [htransport, hlimit]
  exact hcoef

theorem plug_in_bow23_consistent {S : ℕ → Cov} {θ : Bow23} (hθ : OnBow23 θ)
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds θ.sigma.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds θ.sigma.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds θ.sigma.xx)) :
    Tendsto (fun n =>
        ((recoverBow23 (S n)).b12, (recoverBow23 (S n)).b13, (recoverBow23 (S n)).v1,
          (recoverBow23 (S n)).v2, (recoverBow23 (S n)).v3, (recoverBow23 (S n)).c,
          (recoverBow23 (S n)).gamma, (recoverBow23 (S n)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  have hθ0 := hθ
  obtain ⟨hN, hφ⟩ := hθ
  have hunit : IsUnit θ.sigma.xx.det := by
    simpa [Bow23.sigma] using (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  have hschur := schurAt_bow23 θ hφ
  have hden : bow23Den (schurAt θ.sigma.yy θ.sigma.yx θ.sigma.xx) ≠ 0 := by
    rw [hschur, bow23Den_omega]
    exact (Bow23.den_pos θ hN).ne'
  simpa [recover_bow23 θ hθ0] using bow23_continuous_mapping hyy hyx hxx hunit hden

theorem plug_in_bow23_consistent_ae {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {Z : ℕ → Ω → Idx → ℝ} {θ : Bow23} (hθ : OnBow23 θ)
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
        ((recoverBow23 (sampleCov Z n ω)).b12, (recoverBow23 (sampleCov Z n ω)).b13,
          (recoverBow23 (sampleCov Z n ω)).v1, (recoverBow23 (sampleCov Z n ω)).v2,
          (recoverBow23 (sampleCov Z n ω)).v3, (recoverBow23 (sampleCov Z n ω)).c,
          (recoverBow23 (sampleCov Z n ω)).gamma, (recoverBow23 (sampleCov Z n ω)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.v1, θ.v2, θ.v3, θ.c, θ.gamma, θ.phi)) := by
  filter_upwards [strong_gram Z hindep hident hint] with ω hω
  have hyy' : Tendsto (fun n => (sampleCov Z n ω).yy) atTop (nhds θ.sigma.yy) := by
    have hpop : blockYY (popGram μ (Z 0)) = θ.sigma.yy := by
      ext i j; simpa [blockYY, popGram] using hyy i j
    simpa [sampleCov, hpop] using tendsto_blockYY hω
  have hyx' : Tendsto (fun n => (sampleCov Z n ω).yx) atTop (nhds θ.sigma.yx) := by
    have hpop : blockYX (popGram μ (Z 0)) = θ.sigma.yx := by
      ext i j; simpa [blockYX, popGram] using hyx i j
    simpa [sampleCov, hpop] using tendsto_blockYX hω
  have hxx' : Tendsto (fun n => (sampleCov Z n ω).xx) atTop (nhds θ.sigma.xx) := by
    have hpop : blockXX (popGram μ (Z 0)) = θ.sigma.xx := by
      ext i j; simpa [blockXX, popGram] using hxx i j
    simpa [sampleCov, hpop] using tendsto_blockXX hω
  exact plug_in_bow23_consistent hθ hyy' hyx' hxx'

end CorrelatedResiduals
