import JointPowers
import KernelStopping
namespace JointSidon
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
lemma binary_kernel_stopping (S T : Finset G) (x : Bool × G → ZMod 2)
    (hx : x ≠ 0) (hk : (X (ZMod 2) S T).mulVec x = 0) :
    Incidence.Stopping (E S T) (BinaryStopping.support x) := by
  have he : BinaryStopping.matrix (E S T) = X (ZMod 2) S T := by
    ext c v
    exact (entry _ S T v c).symm
  apply BinaryStopping.kernel_stopping (E S T) x hx
  simpa only [he] using hk
lemma kernel_weight_bound (S T : Finset G) (hs : SidonStopping.IsSidon (S ∪ T))
    (hd : Disjoint S T) (hc : S.card=T.card) (x : Bool × G → ZMod 2)
    (hx : x ≠ 0) (hk : (X (ZMod 2) S T).mulVec x = 0) :
    S.card+1 ≤ (BinaryStopping.support x).card :=
  stopping_bound S T hs hd hc _ (binary_kernel_stopping S T x hx hk)
end JointSidon
namespace JointPowers
open Matrix
/-- Both CSS sectors have the indicated kernel-weight lower bound. -/
theorem both_sector_bounds (γ n : ℕ) [NeZero n] (hn : 3^(2*γ) ≤ n) :
    (∀ x : Bool × ZMod n → ZMod 2, x ≠ 0 →
      (JointSidon.X (ZMod 2) (leftMarks γ n) (rightMarks γ n)).mulVec x = 0 →
      γ+1 ≤ (BinaryStopping.support x).card) ∧
    (∀ x : Bool × ZMod n → ZMod 2, x ≠ 0 →
      (JointSidon.Z (leftMarks γ n) (rightMarks γ n)).mulVec x = 0 →
      γ+1 ≤ (BinaryStopping.support x).card) := by
  constructor
  · intro x hx hk
    have h := JointSidon.kernel_weight_bound _ _ (joint_sidon γ n hn) (disjoint_marks γ n hn)
      (by rw [left_card γ n hn,right_card γ n hn]) x hx hk
    simpa only [left_card γ n hn] using h
  · intro x hx hk
    have hs : SidonStopping.IsSidon (rightMarks γ n ∪ leftMarks γ n) := by
      simpa only [Finset.union_comm] using joint_sidon γ n hn
    have h := JointSidon.kernel_weight_bound _ _ hs (disjoint_marks γ n hn).symm
      (by rw [left_card γ n hn,right_card γ n hn]) x hx hk
    simpa only [right_card γ n hn] using h
end JointPowers
