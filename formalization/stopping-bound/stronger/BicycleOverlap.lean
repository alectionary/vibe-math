import BicycleDegrees
import BicycleBase
namespace Bicycle.Family
open Finset
variable {n : ℕ} [NeZero n]

theorem overlap_le_base (h : 39 ∣ n) (v w : Var n) :
    PartitionStopping.overlap E v w ≤
      PartitionStopping.overlap Bicycle.E (projV h v) (projV h w) := by
  classical
  let U := PartitionStopping.neighbors E v ∩ PartitionStopping.neighbors E w
  have hinj : Set.InjOn (projC h) (↑U : Set (Check n)) := by
    intro c hc d hd he
    exact column_local_inj h v c d
      (mem_filter.mp (mem_inter.mp hc).1).2
      (mem_filter.mp (mem_inter.mp hd).1).2 he
  have hsub : U.image (projC h) ⊆
      PartitionStopping.neighbors Bicycle.E (projV h v) ∩
        PartitionStopping.neighbors Bicycle.E (projV h w) := by
    intro d hd
    obtain ⟨c,hc,rfl⟩ := mem_image.mp hd
    have hcv := (mem_filter.mp (mem_inter.mp hc).1).2
    have hcw := (mem_filter.mp (mem_inter.mp hc).2).2
    exact mem_inter.mpr ⟨mem_filter.mpr ⟨mem_univ _,maps h v c hcv⟩,
      mem_filter.mpr ⟨mem_univ _,maps h w c hcw⟩⟩
  change U.card ≤ _
  rw [← card_image_of_injOn hinj]
  exact card_le_card hsub

theorem overlap_bound (h : 39 ∣ n) (v w : Var n) (hne : v ≠ w) :
    PartitionStopping.overlap E v w ≤ if v.1 = w.1 then 1 else 2 := by
  classical
  by_cases hp : projV h v = projV h w
  · have hzero : PartitionStopping.overlap E v w = 0 := by
      apply card_eq_zero.mpr
      apply eq_empty_iff_forall_notMem.mpr
      intro c hc
      exact hne (local_inj h v w c (mem_filter.mp (mem_inter.mp hc).1).2
        (mem_filter.mp (mem_inter.mp hc).2).2 hp)
    rw [hzero]
    exact Nat.zero_le _
  · have hb := Bicycle.overlap_bound (projV h v) (projV h w) hp
    have hl := overlap_le_base h v w
    change Nat.le _ _ at hb hl ⊢
    exact Nat.le_trans hl hb

theorem incidence_bound_four (h : 39 ∣ n) (T : Finset (Var n))
    (hT : Incidence.Stopping E T) : 4 ≤ T.card :=
  PartitionStopping.weight_four_bound E Prod.fst T hT
    (fun v _ => by rw [degree_four h]) (fun v _ w _ he => overlap_bound h v w he)
end Bicycle.Family
