import FamilySource11
import Mathlib.Data.Fintype.Fin
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace FamilyClassical11
open BinaryWords FamilyBase11

theorem all_blocks (b : Fin 64) : goodBlock b.val = true := by
  fin_cases b
  · exact block_0
  · exact block_1
  · exact block_2
  · exact block_3
  · exact block_4
  · exact block_5
  · exact block_6
  · exact block_7
  · exact block_8
  · exact block_9
  · exact block_10
  · exact block_11
  · exact block_12
  · exact block_13
  · exact block_14
  · exact block_15
  · exact block_16
  · exact block_17
  · exact block_18
  · exact block_19
  · exact block_20
  · exact block_21
  · exact block_22
  · exact block_23
  · exact block_24
  · exact block_25
  · exact block_26
  · exact block_27
  · exact block_28
  · exact block_29
  · exact block_30
  · exact block_31
  · exact block_32
  · exact block_33
  · exact block_34
  · exact block_35
  · exact block_36
  · exact block_37
  · exact block_38
  · exact block_39
  · exact block_40
  · exact block_41
  · exact block_42
  · exact block_43
  · exact block_44
  · exact block_45
  · exact block_46
  · exact block_47
  · exact block_48
  · exact block_49
  · exact block_50
  · exact block_51
  · exact block_52
  · exact block_53
  · exact block_54
  · exact block_55
  · exact block_56
  · exact block_57
  · exact block_58
  · exact block_59
  · exact block_60
  · exact block_61
  · exact block_62
  · exact block_63

theorem encoded_lower (c : BitVec 13) : encode c = 0 ∨ 12 ≤ (encode c).cpop.toNat := by
  have hc : c.toNat < 8192 := c.isLt
  have hb : c.toNat / 128 < 64 := by omega
  have h := all_blocks ⟨c.toNat / 128, hb⟩
  unfold goodBlock at h
  have hh := List.all_eq_true.mp h (c.toNat % 128) (List.mem_range.mpr (Nat.mod_lt _ (by decide)))
  have he : 128*(c.toNat/128)+c.toNat%128 = c.toNat := by omega
  rw [he, BitVec.ofNat_toNat] at hh
  have hp : encode c = 0#44 ∨ (12 : BitVec 44) ≤ (encode c).cpop := by simpa using hh
  rcases hp with hp | hp
  · exact Or.inl hp
  · exact Or.inr hp

theorem actual_classical_lower (x : BitVec 44) (h : ClassicalKernel x) :
    x = 0 ∨ 12 ≤ x.cpop.toNat := by
  rw [kernel_reconstruct x h]
  exact encoded_lower _

#print axioms actual_classical_lower
end FamilyClassical11
