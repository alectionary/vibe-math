import Practical27
import SeparateSidon
import JointKernel
namespace Practical27
open Finset
set_option maxRecDepth 100000
set_option maxHeartbeats 0
lemma sidonS : SidonStopping.IsSidon S := by
  unfold SidonStopping.IsSidon
  decide +kernel
lemma sidonT : SidonStopping.IsSidon T := by
  unfold SidonStopping.IsSidon
  decide +kernel
lemma mixed_unique : JointSidon.CrossUnique S T := by
  unfold JointSidon.CrossUnique
  decide +kernel
lemma swapped_linearity : ∀ v w : V,v≠w →
    PartitionStopping.overlap (JointSidon.E T S) v w≤1 := by
  apply JointSidon.separate_overlap_one T S sidonT sidonS
  intro a ha b hb c hc d hd he
  have h := mixed_unique b hb a ha d hd c hc (by simpa only [add_comm] using he)
  exact ⟨h.2,h.1⟩
theorem both_sector_kernel_bounds :
    (∀ x : V → ZMod 2,x≠0 → (HX (ZMod 2)).mulVec x=0 →
      5≤(BinaryStopping.support x).card) ∧
    (∀ x : V → ZMod 2,x≠0 → HZ.mulVec x=0 →
      5≤(BinaryStopping.support x).card) := by
  constructor
  · intro x hx hk
    apply source_stopping_five
    simpa only [Incidence.Stopping,JointSidon.binary_incidence,HX] using
      JointSidon.binary_kernel_stopping S T x hx hk
  · intro x hx hk
    have hs := JointSidon.binary_kernel_stopping T S x hx hk
    have hh := PartitionStopping.uniform_overlap_bound _ _ hs 4 1
      (fun v _ => by rw [JointSidon.degree,cardT,cardS];split <;> omega)
      (fun v _ w _ he => swapped_linearity v w he)
    simpa using hh
end Practical27
