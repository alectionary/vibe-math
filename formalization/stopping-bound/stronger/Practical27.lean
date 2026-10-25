import Practical27Core
namespace Practical27
open Matrix Finset StoppingSpectral StoppingMoment
theorem source_stopping_five (U : Finset V)
    (hU : Incidence.Stopping (fun v c => HX (ZMod 2) c v=1) U) : 5≤U.card := by
  refine regular_spectral_bound E 4 8 degree row_degree ?_ U ?_
  · rw [real_matrix,fourth_moment]
    norm_num
  · simpa only [HX,Incidence.Stopping,JointSidon.binary_incidence] using hU

theorem replacement_value : regularReplacement 27 54 4 8 (∑ i,(eigs (HX ℝ) i)^2)=5 := by
  rw [fourth_moment]
  norm_num [regularReplacement]

theorem nontrivial_code : HX (ZMod 2)*HZᵀ=0 ∧
    (HX (ZMod 2)).mulVec (SidonStopping.leftOnes (G := G))=0 ∧
    (¬ ∃ a,HZᵀ.mulVec a=SidonStopping.leftOnes) := by
  exact ⟨JointSidon.css S T,JointSidon.left_kernel S T (by rw [cardS];decide),
    JointSidon.left_not_stabilizer S T (by rw [cardT];decide) (by decide)⟩
end Practical27
