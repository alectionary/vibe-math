import SmallStopping
import FamilySource11
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace FamilyStopping11
open BinaryWords SmallStopping
def col (v : Fin 44) : List (Fin 33) := (List.finRange 3).map (fun i => ⟨11*i.val + (v.val%11 + FamilyBase11.exponent i.val (v.val/11))%11, by have := i.isLt; have := Nat.mod_lt (v.val%11 + FamilyBase11.exponent i.val (v.val/11)) (by decide : 0<11); omega⟩)
def row (c : Fin 33) : List (Fin 44) := (List.finRange 4).map (fun j => ⟨11*j.val+(c.val%11+11-FamilyBase11.exponent (c.val/11) j.val)%11,by have := j.isLt; have := Nat.mod_lt (c.val%11+11-FamilyBase11.exponent (c.val/11) j.val) (by decide : 0<11); omega⟩)
def E (v : Fin 44) (c : Fin 33) : Prop := c ∈ col v
instance : DecidableRel E := fun _ _ => inferInstanceAs (Decidable (_ ∈ _))
theorem row_complete : ∀ v c, E v c → v ∈ row c := by
  apply forall_fin_two_of_all
  decide +kernel
def pick (S : List (Fin 44)) : Option (Fin 33) := (S.flatMap col).find? (fun c => (S.countP (fun v => E v c)) == 1)
theorem pick_singleton (S : List (Fin 44)) (hn : S.Nodup) (c : Fin 33) (h : pick S = some c) : (S.toFinset.filter (fun v => E v c)).card = 1 := by
  rw [hn.card_eq_countP]
  have := List.find?_some h
  simpa using this
theorem root_0 : survivesList pick row 4 [0] = false := by decide +kernel
theorem root_1 : survivesList pick row 4 [1] = false := by decide +kernel
theorem root_2 : survivesList pick row 4 [2] = false := by decide +kernel
theorem root_3 : survivesList pick row 4 [3] = false := by decide +kernel
theorem root_4 : survivesList pick row 4 [4] = false := by decide +kernel
theorem root_5 : survivesList pick row 4 [5] = false := by decide +kernel
theorem root_6 : survivesList pick row 4 [6] = false := by decide +kernel
theorem root_7 : survivesList pick row 4 [7] = false := by decide +kernel
theorem root_8 : survivesList pick row 4 [8] = false := by decide +kernel
theorem root_9 : survivesList pick row 4 [9] = false := by decide +kernel
theorem root_10 : survivesList pick row 4 [10] = false := by decide +kernel
theorem root_11 : survivesList pick row 4 [11] = false := by decide +kernel
theorem root_12 : survivesList pick row 4 [12] = false := by decide +kernel
theorem root_13 : survivesList pick row 4 [13] = false := by decide +kernel
theorem root_14 : survivesList pick row 4 [14] = false := by decide +kernel
theorem root_15 : survivesList pick row 4 [15] = false := by decide +kernel
theorem root_16 : survivesList pick row 4 [16] = false := by decide +kernel
theorem root_17 : survivesList pick row 4 [17] = false := by decide +kernel
theorem root_18 : survivesList pick row 4 [18] = false := by decide +kernel
theorem root_19 : survivesList pick row 4 [19] = false := by decide +kernel
theorem root_20 : survivesList pick row 4 [20] = false := by decide +kernel
theorem root_21 : survivesList pick row 4 [21] = false := by decide +kernel
theorem root_22 : survivesList pick row 4 [22] = false := by decide +kernel
theorem root_23 : survivesList pick row 4 [23] = false := by decide +kernel
theorem root_24 : survivesList pick row 4 [24] = false := by decide +kernel
theorem root_25 : survivesList pick row 4 [25] = false := by decide +kernel
theorem root_26 : survivesList pick row 4 [26] = false := by decide +kernel
theorem root_27 : survivesList pick row 4 [27] = false := by decide +kernel
theorem root_28 : survivesList pick row 4 [28] = false := by decide +kernel
theorem root_29 : survivesList pick row 4 [29] = false := by decide +kernel
theorem root_30 : survivesList pick row 4 [30] = false := by decide +kernel
theorem root_31 : survivesList pick row 4 [31] = false := by decide +kernel
theorem root_32 : survivesList pick row 4 [32] = false := by decide +kernel
theorem root_33 : survivesList pick row 4 [33] = false := by decide +kernel
theorem root_34 : survivesList pick row 4 [34] = false := by decide +kernel
theorem root_35 : survivesList pick row 4 [35] = false := by decide +kernel
theorem root_36 : survivesList pick row 4 [36] = false := by decide +kernel
theorem root_37 : survivesList pick row 4 [37] = false := by decide +kernel
theorem root_38 : survivesList pick row 4 [38] = false := by decide +kernel
theorem root_39 : survivesList pick row 4 [39] = false := by decide +kernel
theorem root_40 : survivesList pick row 4 [40] = false := by decide +kernel
theorem root_41 : survivesList pick row 4 [41] = false := by decide +kernel
theorem root_42 : survivesList pick row 4 [42] = false := by decide +kernel
theorem root_43 : survivesList pick row 4 [43] = false := by decide +kernel
theorem roots_reject (v : Fin 44) : survivesList pick row 4 [v] = false := by
  fin_cases v
  · exact root_0
  · exact root_1
  · exact root_2
  · exact root_3
  · exact root_4
  · exact root_5
  · exact root_6
  · exact root_7
  · exact root_8
  · exact root_9
  · exact root_10
  · exact root_11
  · exact root_12
  · exact root_13
  · exact root_14
  · exact root_15
  · exact root_16
  · exact root_17
  · exact root_18
  · exact root_19
  · exact root_20
  · exact root_21
  · exact root_22
  · exact root_23
  · exact root_24
  · exact root_25
  · exact root_26
  · exact root_27
  · exact root_28
  · exact root_29
  · exact root_30
  · exact root_31
  · exact root_32
  · exact root_33
  · exact root_34
  · exact root_35
  · exact root_36
  · exact root_37
  · exact root_38
  · exact root_39
  · exact root_40
  · exact root_41
  · exact root_42
  · exact root_43
theorem stopping_lower_six (T : Finset (Fin 44)) (hT : Stopping E T) : 6 ≤ T.card := by
  obtain ⟨v,hv⟩ := hT.1
  by_contra hn
  have hc : T.card ≤ [v].length+4 := by simp only [List.length_singleton]; omega
  have h := survivesList_of_stopping E pick row pick_singleton row_complete 4 [v] T hT (by simp) (by simpa using hv) hc
  rw [roots_reject] at h
  contradiction
#print axioms stopping_lower_six
end FamilyStopping11
