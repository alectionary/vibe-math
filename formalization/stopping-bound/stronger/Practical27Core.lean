import JointMatrices
import MomentBound
import MomentReplacement
namespace Practical27
open Matrix Finset StoppingSpectral StoppingMoment
abbrev G := ZMod 27
abbrev V := Bool × G
def S : Finset G := {0,1,3,11}
def T : Finset G := {0,5,12,18}
abbrev E := JointSidon.E S T
def HX (R : Type*) [Zero R] [One R] : Matrix G V R := JointSidon.X R S T
def HZ : Matrix G V (ZMod 2) := JointSidon.Z S T
set_option maxRecDepth 100000
set_option maxHeartbeats 0
lemma cardS : S.card=4 := by decide +kernel
lemma cardT : T.card=4 := by decide +kernel
/-- Complete finite check of the actual incidence matrix, not a search premise. -/
lemma linearity : ∀ v w : V, v≠w → PartitionStopping.overlap E v w ≤ 1 := by decide +kernel
lemma degree (v : V) : (PartitionStopping.neighbors E v).card=4 := by
  rw [JointSidon.degree,cardS,cardT]
  split <;> rfl
lemma row_degree (c : G) : rowWeight E c=8 := by
  have h := JointSidon.row_weight S T c
  simpa only [rowWeight,JointSidon.binary_incidence,cardS,cardT] using h
lemma real_matrix : H E=HX ℝ := by
  ext c v
  exact (JointSidon.entry _ S T v c).symm

theorem fourth_moment : (∑ i,(eigs (HX ℝ) i)^2)=2376 := by
  have h := moment_of_overlap_one E linearity
  rw [real_matrix] at h
  simp_rw [degree,row_degree] at h
  norm_num only [sum_const,card_univ,Fintype.card_prod,Fintype.card_bool,ZMod.card,
    nsmul_eq_mul,Nat.cast_ofNat] at h
  linarith

end Practical27
