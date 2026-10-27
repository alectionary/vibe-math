/-
Continuous mapping for the equation-(7) plug-in estimator.

If the three empirical second-moment blocks converge to the blocks of a
positive-definite diagonal parameter point, every coordinate of `recover`
converges to that parameter. Convergence of the blocks is the weak law
applied entrywise; that probabilistic step is the hypothesis, not a proof
of the law of large numbers.
-/

import CorrelatedResiduals.Diagonal
import Mathlib.Topology.Algebra.GroupWithZero
import Mathlib.Topology.Instances.Matrix

open Matrix Filter Topology

namespace CorrelatedResiduals

noncomputable def schurAt (yy yx xx : M3) : M3 :=
  yy - yx * xx⁻¹ * yxᵀ

noncomputable def pivot3 (Ω : M3) : ℝ := Ω 2 2

noncomputable def coef23 (Ω : M3) : ℝ := Ω 1 2 / pivot3 Ω

noncomputable def coef13 (Ω : M3) : ℝ := Ω 0 2 / pivot3 Ω

noncomputable def pivot2 (Ω : M3) : ℝ :=
  Ω 1 1 - coef23 Ω ^ 2 * pivot3 Ω

noncomputable def coef12 (Ω : M3) : ℝ :=
  (Ω 0 1 - coef23 Ω * coef13 Ω * pivot3 Ω) / pivot2 Ω

noncomputable def coef13b (Ω : M3) : ℝ :=
  coef13 Ω - coef12 Ω * coef23 Ω

noncomputable def var1 (Ω : M3) : ℝ :=
  Ω 0 0 - coef12 Ω ^ 2 * pivot2 Ω - coef13 Ω ^ 2 * pivot3 Ω

noncomputable def bMatOf (Ω : M3) : M3 :=
  !![0, coef12 Ω, coef13b Ω;
     0, 0, coef23 Ω;
     0, 0, 0]

noncomputable def gammaAt (Ω yx xx : M3) : M3 :=
  (1 - bMatOf Ω) * yx * xx⁻¹

lemma continuous_entry (i j : Fin 3) : Continuous fun Ω : M3 => Ω i j :=
  continuous_apply_apply i j

lemma continuousAt_matrix_inv_of_det {xx : M3} (h : IsUnit xx.det) :
    ContinuousAt (fun A : M3 => A⁻¹) xx := by
  refine continuousAt_matrix_inv xx ?_
  rw [Ring.inverse_eq_inv']
  exact continuousAt_id.inv₀ h.ne_zero

lemma continuousAt_of_entries {X : Type*} [TopologicalSpace X] {f : X → M3} {x : X}
    (h : ∀ i j, ContinuousAt (fun y => f y i j) x) : ContinuousAt f x := by
  rw [continuousAt_pi]
  intro i
  rw [continuousAt_pi]
  intro j
  exact h i j

lemma continuousAt_schur {yy yx xx : M3} (h : IsUnit xx.det) :
    ContinuousAt (fun p : M3 × M3 × M3 => schurAt p.1 p.2.1 p.2.2) (yy, yx, xx) := by
  have hyy : ContinuousAt (fun p : M3 × M3 × M3 => p.1) (yy, yx, xx) :=
    continuous_fst.continuousAt
  have hyx : ContinuousAt (fun p : M3 × M3 × M3 => p.2.1) (yy, yx, xx) :=
    (continuous_fst.comp continuous_snd).continuousAt
  have hxx : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2) (yy, yx, xx) :=
    (continuous_snd.comp continuous_snd).continuousAt
  have hinv : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2⁻¹) (yy, yx, xx) :=
    (continuousAt_matrix_inv_of_det h).comp hxx
  have hyxt : ContinuousAt (fun p : M3 × M3 × M3 => (p.2.1)ᵀ) (yy, yx, xx) :=
    ContinuousAt.comp' (f := fun p : M3 × M3 × M3 => p.2.1) (x := (yy, yx, xx))
      (continuous_id.matrix_transpose.continuousAt (x := yx)) hyx
  unfold schurAt
  exact hyy.sub ((hyx.mul hinv).mul hyxt)

lemma continuousAt_coef23 {Ω : M3} (h3 : Ω 2 2 ≠ 0) : ContinuousAt coef23 Ω := by
  unfold coef23 pivot3
  exact (continuous_entry 1 2).continuousAt.div (continuous_entry 2 2).continuousAt h3

lemma continuousAt_coef13 {Ω : M3} (h3 : Ω 2 2 ≠ 0) : ContinuousAt coef13 Ω := by
  unfold coef13 pivot3
  exact (continuous_entry 0 2).continuousAt.div (continuous_entry 2 2).continuousAt h3

lemma continuousAt_pivot2 {Ω : M3} (h3 : Ω 2 2 ≠ 0) : ContinuousAt pivot2 Ω := by
  unfold pivot2
  exact (continuous_entry 1 1).continuousAt.sub
    (((continuousAt_coef23 h3).pow 2).mul (continuous_entry 2 2).continuousAt)

lemma continuousAt_coef12 {Ω : M3} (h3 : Ω 2 2 ≠ 0) (h2 : pivot2 Ω ≠ 0) :
    ContinuousAt coef12 Ω := by
  unfold coef12
  refine ContinuousAt.div ?_ (continuousAt_pivot2 h3) h2
  exact (continuous_entry 0 1).continuousAt.sub
    (((continuousAt_coef23 h3).mul (continuousAt_coef13 h3)).mul
      (continuous_entry 2 2).continuousAt)

lemma continuousAt_coef13b {Ω : M3} (h3 : Ω 2 2 ≠ 0) (h2 : pivot2 Ω ≠ 0) :
    ContinuousAt coef13b Ω := by
  unfold coef13b
  exact (continuousAt_coef13 h3).sub ((continuousAt_coef12 h3 h2).mul (continuousAt_coef23 h3))

lemma continuousAt_var1 {Ω : M3} (h3 : Ω 2 2 ≠ 0) (h2 : pivot2 Ω ≠ 0) :
    ContinuousAt var1 Ω := by
  unfold var1
  exact ((continuous_entry 0 0).continuousAt.sub
      (((continuousAt_coef12 h3 h2).pow 2).mul (continuousAt_pivot2 h3))).sub
    (((continuousAt_coef13 h3).pow 2).mul (continuous_entry 2 2).continuousAt)

lemma continuousAt_pivot3 : Continuous pivot3 := by
  unfold pivot3
  exact continuous_entry 2 2

lemma continuousAt_bMat {Ω : M3} (h3 : Ω 2 2 ≠ 0) (h2 : pivot2 Ω ≠ 0) :
    ContinuousAt bMatOf Ω := by
  refine continuousAt_of_entries fun i j => ?_
  fin_cases i <;> fin_cases j <;> simp [bMatOf]
  · exact continuousAt_const
  · exact continuousAt_coef12 h3 h2
  · exact continuousAt_coef13b h3 h2
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_coef23 h3
  · exact continuousAt_const
  · exact continuousAt_const
  · exact continuousAt_const

lemma readDiag_coefs (Ω : M3) :
    readDiag Ω = (coef12 Ω, coef13b Ω, coef23 Ω, var1 Ω, pivot2 Ω, pivot3 Ω) := by
  unfold readDiag coef12 coef13b coef23 var1 pivot2 coef13 pivot3
  rfl

lemma recover_fields (cov : Cov) :
    (recover cov).b12 = coef12 (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).b13 = coef13b (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).b23 = coef23 (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).v1 = var1 (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).v2 = pivot2 (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).v3 = pivot3 (schurAt cov.yy cov.yx cov.xx) ∧
      (recover cov).gamma =
        gammaAt (schurAt cov.yy cov.yx cov.xx) cov.yx cov.xx ∧
      (recover cov).phi = cov.xx := by
  have hread := readDiag_coefs (cov.yy - cov.yx * cov.xx⁻¹ * cov.yxᵀ)
  unfold recover gammaAt bMatOf schurAt
  dsimp
  rw [hread]
  dsimp
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

lemma pivot3_omega (θ : Params) : pivot3 (omega θ) = θ.v3 := by
  simp [pivot3, omega_22]

lemma pivot2_omega (θ : Params) (hv3 : 0 < θ.v3) : pivot2 (omega θ) = θ.v2 := by
  have hv3' : omega θ 2 2 ≠ 0 := by
    rw [omega_22]
    exact hv3.ne'
  unfold pivot2 coef23 pivot3
  rw [omega_11, omega_12, omega_22]
  field_simp [hv3']

lemma schurAt_sigma (θ : Params) (hφ : θ.phi.PosDef) :
    schurAt (sigma θ).yy (sigma θ).yx (sigma θ).xx = omega θ :=
  schur_omega θ hφ

/-- Convergence of the observed blocks passes through `recover`. -/
theorem recover_continuous_mapping {S : ℕ → Cov} {cov : Cov}
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds cov.yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds cov.yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx))
    (hφ : IsUnit cov.xx.det)
    (h3 : schurAt cov.yy cov.yx cov.xx 2 2 ≠ 0)
    (h2 : pivot2 (schurAt cov.yy cov.yx cov.xx) ≠ 0) :
    Tendsto (fun n =>
        ((recover (S n)).b12, (recover (S n)).b13, (recover (S n)).b23,
          (recover (S n)).v1, (recover (S n)).v2, (recover (S n)).v3,
          (recover (S n)).gamma, (recover (S n)).phi))
      atTop
      (nhds
        ((recover cov).b12, (recover cov).b13, (recover cov).b23,
          (recover cov).v1, (recover cov).v2, (recover cov).v3,
          (recover cov).gamma, (recover cov).phi)) := by
  let Ωp : M3 × M3 × M3 → M3 := fun p => schurAt p.1 p.2.1 p.2.2
  have hblocks :
      Tendsto (fun n => ((S n).yy, (S n).yx, (S n).xx)) atTop
        (nhds (cov.yy, cov.yx, cov.xx)) := by
    rw [nhds_prod_eq, nhds_prod_eq]
    exact hyy.prodMk (hyx.prodMk hxx)
  have hΩ : ContinuousAt Ωp (cov.yy, cov.yx, cov.xx) := continuousAt_schur hφ
  have hb12 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_coef12 h3 h2) hΩ).tendsto.comp hblocks
  have hb13 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_coef13b h3 h2) hΩ).tendsto.comp hblocks
  have hb23 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_coef23 h3) hΩ).tendsto.comp hblocks
  have hv1 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_var1 h3 h2) hΩ).tendsto.comp hblocks
  have hv2 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_pivot2 h3) hΩ).tendsto.comp hblocks
  have hv3 :=
    (ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_pivot3.continuousAt (x := schurAt cov.yy cov.yx cov.xx)) hΩ).tendsto.comp
      hblocks
  have hγ : ContinuousAt (fun p : M3 × M3 × M3 => gammaAt (Ωp p) p.2.1 p.2.2)
      (cov.yy, cov.yx, cov.xx) := by
    have hB := ContinuousAt.comp' (f := Ωp) (x := (cov.yy, cov.yx, cov.xx))
      (continuousAt_bMat h3 h2) hΩ
    have hone : ContinuousAt (fun p : M3 × M3 × M3 => (1 : M3) - bMatOf (Ωp p))
        (cov.yy, cov.yx, cov.xx) :=
      continuousAt_const.sub hB
    have hyx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.1) (cov.yy, cov.yx, cov.xx) :=
      (continuous_fst.comp continuous_snd).continuousAt
    have hxx' : ContinuousAt (fun p : M3 × M3 × M3 => p.2.2) (cov.yy, cov.yx, cov.xx) :=
      (continuous_snd.comp continuous_snd).continuousAt
    have hinv := ContinuousAt.comp' (f := fun p : M3 × M3 × M3 => p.2.2)
      (x := (cov.yy, cov.yx, cov.xx)) (continuousAt_matrix_inv_of_det hφ) hxx'
    unfold gammaAt
    exact (hone.mul hyx').mul hinv
  have hgamma := hγ.tendsto.comp hblocks
  have hphi : Tendsto (fun n => (S n).xx) atTop (nhds cov.xx) := hxx
  have hcoef :
      Tendsto (fun n =>
          (coef12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            coef13b (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            coef23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            var1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            pivot2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            pivot3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            gammaAt (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx))
        atTop
        (nhds
          (coef12 (Ωp (cov.yy, cov.yx, cov.xx)),
            coef13b (Ωp (cov.yy, cov.yx, cov.xx)),
            coef23 (Ωp (cov.yy, cov.yx, cov.xx)),
            var1 (Ωp (cov.yy, cov.yx, cov.xx)),
            pivot2 (Ωp (cov.yy, cov.yx, cov.xx)),
            pivot3 (Ωp (cov.yy, cov.yx, cov.xx)),
            gammaAt (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx,
            cov.xx)) := by
    simp only [nhds_prod_eq]
    exact hb12.prodMk (hb13.prodMk (hb23.prodMk
      (hv1.prodMk (hv2.prodMk (hv3.prodMk (hgamma.prodMk hphi))))))
  have htransport :
      (fun n =>
          ((recover (S n)).b12, (recover (S n)).b13, (recover (S n)).b23,
            (recover (S n)).v1, (recover (S n)).v2, (recover (S n)).v3,
            (recover (S n)).gamma, (recover (S n)).phi)) =
        fun n =>
          (coef12 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            coef13b (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            coef23 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            var1 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            pivot2 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            pivot3 (Ωp ((S n).yy, (S n).yx, (S n).xx)),
            gammaAt (Ωp ((S n).yy, (S n).yx, (S n).xx)) (S n).yx (S n).xx,
            (S n).xx) := by
    funext n
    obtain ⟨hb12s, hb13s, hb23s, hv1s, hv2s, hv3s, hγs, hφs⟩ := recover_fields (S n)
    simp [hb12s, hb13s, hb23s, hv1s, hv2s, hv3s, hγs, hφs, Ωp]
  have hlimit :
      ((recover cov).b12, (recover cov).b13, (recover cov).b23, (recover cov).v1,
          (recover cov).v2, (recover cov).v3, (recover cov).gamma, (recover cov).phi) =
        (coef12 (Ωp (cov.yy, cov.yx, cov.xx)), coef13b (Ωp (cov.yy, cov.yx, cov.xx)),
          coef23 (Ωp (cov.yy, cov.yx, cov.xx)), var1 (Ωp (cov.yy, cov.yx, cov.xx)),
          pivot2 (Ωp (cov.yy, cov.yx, cov.xx)), pivot3 (Ωp (cov.yy, cov.yx, cov.xx)),
          gammaAt (Ωp (cov.yy, cov.yx, cov.xx)) cov.yx cov.xx, cov.xx) := by
    obtain ⟨hb12c, hb13c, hb23c, hv1c, hv2c, hv3c, hγc, hφc⟩ := recover_fields cov
    simp [hb12c, hb13c, hb23c, hv1c, hv2c, hv3c, hγc, hφc, Ωp]
  rw [htransport, hlimit]
  exact hcoef

/-- On the positive-definite diagonal domain, block convergence implies consistency. -/
theorem plug_in_consistent {S : ℕ → Cov} {θ : Params} (hθ : OnDomain θ)
    (hyy : Tendsto (fun n => (S n).yy) atTop (nhds (sigma θ).yy))
    (hyx : Tendsto (fun n => (S n).yx) atTop (nhds (sigma θ).yx))
    (hxx : Tendsto (fun n => (S n).xx) atTop (nhds (sigma θ).xx)) :
    Tendsto (fun n =>
        ((recover (S n)).b12, (recover (S n)).b13, (recover (S n)).b23,
          (recover (S n)).v1, (recover (S n)).v2, (recover (S n)).v3,
          (recover (S n)).gamma, (recover (S n)).phi))
      atTop
      (nhds (θ.b12, θ.b13, θ.b23, θ.v1, θ.v2, θ.v3, θ.gamma, θ.phi)) := by
  have hv2 : 0 < θ.v2 := hθ.2.1
  have hv3 : 0 < θ.v3 := hθ.2.2.1
  have hφ : θ.phi.PosDef := hθ.2.2.2
  have hunit : IsUnit (sigma θ).xx.det := by
    simpa [sigma] using (isUnit_iff_isUnit_det θ.phi).1 hφ.isUnit
  have hschur : schurAt (sigma θ).yy (sigma θ).yx (sigma θ).xx = omega θ :=
    schurAt_sigma θ hφ
  have h3 : schurAt (sigma θ).yy (sigma θ).yx (sigma θ).xx 2 2 ≠ 0 := by
    rw [hschur]
    simpa [pivot3, omega_22] using hv3.ne'
  have h2 : pivot2 (schurAt (sigma θ).yy (sigma θ).yx (sigma θ).xx) ≠ 0 := by
    rw [hschur, pivot2_omega θ hv3]
    exact hv2.ne'
  have hmap := recover_continuous_mapping hyy hyx hxx hunit h3 h2
  have hid := recover_sigma θ hθ
  simpa [hid] using hmap

end CorrelatedResiduals
