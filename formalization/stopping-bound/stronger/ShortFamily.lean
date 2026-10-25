import ShortFamilySupports
import JointMatrices
import JointKernel
import MomentReplacement
namespace ShortFamily
open Matrix Finset StoppingSpectral StoppingMoment
variable {n : ℕ} [NeZero n]
abbrev E := JointSidon.E (S n) (T n)
def HX (R : Type*) [Zero R] [One R] : Matrix (ZMod n) (Bool × ZMod n) R :=
  JointSidon.X R (S n) (T n)
def HZ : Matrix (ZMod n) (Bool × ZMod n) (ZMod 2) := JointSidon.Z (S n) (T n)
lemma linearity (hn : 37≤n) : ∀ v w : Bool × ZMod n,v≠w → PartitionStopping.overlap (E (n := n)) v w≤1 :=
  JointSidon.separate_overlap_one _ _ (sidonS n hn) (sidonT n hn) (cross n hn)
lemma swapped_linearity (hn : 37≤n) : ∀ v w : Bool × ZMod n,v≠w →
    PartitionStopping.overlap (JointSidon.E (T n) (S n)) v w≤1 :=
  JointSidon.separate_overlap_one _ _ (sidonT n hn) (sidonS n hn) (cross_swap n hn)
lemma degree (hn : 37≤n) (v : Bool × ZMod n) : (PartitionStopping.neighbors (E (n := n)) v).card=4 := by
  rw [JointSidon.degree,cardS n hn,cardT n hn]
  split <;> rfl
lemma row_degree (hn : 37≤n) (c : ZMod n) : rowWeight (E (n := n)) c=8 := by
  have h := JointSidon.row_weight (S n) (T n) c
  simpa only [rowWeight,JointSidon.binary_incidence,cardS n hn,cardT n hn] using h
lemma real_matrix : H (E (n := n))=HX (n := n) ℝ := by
  ext c v
  exact (JointSidon.entry _ _ _ v c).symm

theorem fourth_moment (hn : 37≤n) : (∑ i,(eigs (HX (n := n) ℝ) i)^2)=88*(n:ℝ) := by
  have h := moment_of_overlap_one (E (n := n)) (linearity hn)
  rw [real_matrix] at h
  simp_rw [degree hn,row_degree hn] at h
  simp only [sum_const,card_univ,Fintype.card_prod,Fintype.card_bool,ZMod.card,
    nsmul_eq_mul,Nat.cast_mul,Nat.cast_ofNat] at h
  nlinarith

theorem source_stopping_five (hn : 37≤n) (U : Finset (Bool × ZMod n))
    (hU : Incidence.Stopping (fun v c => HX (n := n) (ZMod 2) c v=1) U) : 5≤U.card := by
  refine regular_spectral_bound (E (n := n)) 4 8 (degree hn) (row_degree hn) ?_ U ?_
  · rw [real_matrix,fourth_moment hn]
    simp only [Fintype.card_prod,Fintype.card_bool,ZMod.card,Nat.cast_mul,Nat.cast_ofNat]
    ring
  · simpa only [HX,Incidence.Stopping,JointSidon.binary_incidence] using hU

theorem replacement_value (hn : 37≤n) :
    regularReplacement n (2*n) 4 8 (∑ i,(eigs (HX (n := n) ℝ) i)^2)=5 := by
  rw [fourth_moment hn]
  unfold regularReplacement
  split_ifs with he
  · norm_num
  · exfalso
    apply he
    push_cast
    ring

theorem nontrivial_code (hn : 37≤n) (ho : Odd n) :
    HX (n := n) (ZMod 2)*(HZ (n := n))ᵀ=0 ∧
    (HX (n := n) (ZMod 2)).mulVec (SidonStopping.leftOnes (G := ZMod n))=0 ∧
    (¬ ∃ a,(HZ (n := n))ᵀ.mulVec a=SidonStopping.leftOnes) := by
  exact ⟨JointSidon.css _ _,JointSidon.left_kernel _ _ (by rw [cardS n hn];decide),
    JointSidon.left_not_stabilizer _ _ (by rw [cardT n hn];decide) (by simpa using ho)⟩

theorem both_sector_kernel_bounds (hn : 37≤n) :
    (∀ x : Bool × ZMod n → ZMod 2,x≠0 → (HX (n := n) (ZMod 2)).mulVec x=0 →
      5≤(BinaryStopping.support x).card) ∧
    (∀ x : Bool × ZMod n → ZMod 2,x≠0 → (HZ (n := n)).mulVec x=0 →
      5≤(BinaryStopping.support x).card) := by
  constructor
  · intro x hx hk
    exact source_stopping_five hn _ (by
      simpa only [Incidence.Stopping,JointSidon.binary_incidence,HX] using
        JointSidon.binary_kernel_stopping (S n) (T n) x hx hk)
  · intro x hx hk
    have hs := JointSidon.binary_kernel_stopping (T n) (S n) x hx hk
    have hh := PartitionStopping.uniform_overlap_bound _ _ hs 4 1
      (fun v _ => by rw [JointSidon.degree,cardT n hn,cardS n hn];split <;> omega)
      (fun v _ w _ he => swapped_linearity hn v w he)
    simpa using hh

theorem arbitrary_lengths (B : ℕ) : ∃ n,0<n ∧ Odd n ∧ 37≤n ∧ B<2*n := by
  refine ⟨37*(2*B+1),by omega,?_,by omega,by omega⟩
  exact (show Odd (37:ℕ) by decide).mul ⟨B,by omega⟩
end ShortFamily
