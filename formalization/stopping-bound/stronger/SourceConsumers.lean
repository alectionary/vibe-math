import JointMomentFamily
import JointKernel
import PowersFamily
import GrowingFamily
namespace SourceConsumers
open Matrix Finset
/-- Actual F2 source matrices, rather than an assumed incidence certificate. -/
theorem actual_joint_family (γ n : ℕ) [NeZero n] (hn : 3^(2*γ) ≤ n)
    (he : Even γ) (ho : Odd n) :
    let S := JointPowers.leftMarks γ n
    let T := JointPowers.rightMarks γ n
    let HX := JointSidon.X (ZMod 2) S T
    let HZ := JointSidon.Z S T
    HX*HZᵀ=0 ∧
    (∀ v,(univ.filter (fun c => HX c v=1)).card=γ) ∧
    (∀ c,(univ.filter (fun v => HX c v=1)).card=2*γ) ∧
    (∑ i,(StoppingSpectral.eigs (JointSidon.X ℝ S T) i)^2)=2*(n:ℝ)*(γ:ℝ)*(3*(γ:ℝ)-1) ∧
    (∀ U : Finset (Bool × ZMod n), Incidence.Stopping (fun v c => HX c v=1) U → γ+1 ≤ U.card) ∧
    HX.mulVec (SidonStopping.leftOnes (G := ZMod n))=0 ∧
    (¬ ∃ a,HZᵀ.mulVec a=SidonStopping.leftOnes) := by
  dsimp only
  obtain ⟨hcss,hker,hspan⟩ := JointPowers.nontrivial_code γ n hn he ho
  refine ⟨hcss,?_,?_,JointPowers.fourth_moment hn,?_,hker,hspan⟩
  · intro v
    rw [JointSidon.column_weight,JointPowers.left_card γ n hn,JointPowers.right_card γ n hn]
    split <;> rfl
  · intro c
    rw [JointSidon.row_weight,JointPowers.left_card γ n hn,JointPowers.right_card γ n hn]
    omega
  · intro U hU
    apply JointPowers.spectral_stopping_bound hn U
    simpa only [Incidence.Stopping,JointSidon.binary_incidence] using hU

theorem arbitrary_joint_lengths (γ B : ℕ) :
    ∃ n, B<2*n ∧ 0<n ∧ Odd n ∧ 3^(2*γ)≤n := by
  obtain ⟨t,ht⟩ := PowersThree.lengths_unbounded γ B
  exact ⟨PowersThree.liftLength γ t,ht,PowersThree.lift_positive γ t,
    PowersThree.lift_odd γ t,PowersThree.lift_large γ t⟩

/-- Division-form source interpretation of the exact density certificate. -/
theorem growing_density (d : ℕ) :
    (2*(d:ℝ))/(3:ℝ)^(2*d) ≤ 1/(3:ℝ)^d := by
  apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
  have h : (2*(d:ℝ))*(3:ℝ)^d ≤ (3:ℝ)^(2*d) := by
    exact_mod_cast PowersThree.density_certificate d
  simpa only [one_mul] using h
end SourceConsumers
