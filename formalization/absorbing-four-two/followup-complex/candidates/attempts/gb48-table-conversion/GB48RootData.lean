import CyclicNormalization
import Mathlib.Data.ZMod.Basic
set_option maxHeartbeats 0
set_option maxRecDepth 100000
set_option Elab.async false
namespace GB48RootData
open CyclicNormalization PairFormula
abbrev G := ZMod 24
abbrev V := Fin 2 × G
abbrev C := Fin 1 × G
attribute [local irreducible] CyclicNormalization.rootTerm GlobalCounting.count42
def socketsA (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,14)}
def socketsB (p : Fin 2) : Finset C :=
  if p=0 then {(0,0),(0,1),(0,5)} else {(0,0),(0,22),(0,8)}
def HA : V → Finset C := incidence socketsA
def HB : V → Finset C := incidence socketsB
theorem cubic (s : Fin 2 → Finset C) (hs : ∀ p, (s p).card=3) :
    ∀ v, (incidence s v).card=3 := by
  intro v
  rw [incidence, Finset.card_image_of_injective _ (shift (Fin 1) v.2).injective]
  exact hs v.1
theorem cubic_A : ∀ v, (HA v).card=3 := cubic socketsA (by decide +kernel)
theorem cubic_B : ∀ v, (HB v).card=3 := cubic socketsB (by decide +kernel)
theorem linear_from_normalized (s : Fin 2 → Finset C)
    (hn : ∀ p q (d : G), (p,0) ≠ (q,d) →
      (incidence s (p,0) ∩ incidence s (q,d)).card ≤ 1) :
    ∀ u v, u ≠ v → (incidence s u ∩ incidence s v).card ≤ 1 := by
  rintro ⟨p,a⟩ ⟨q,b⟩ huv
  have he : (p,(0 : G)) ≠ (q,-a+b) := by
    intro h
    have hp : p=q := congrArg Prod.fst h
    have hab : (0 : G) = -a+b := congrArg Prod.snd h
    have hb : b=a := by
      have hh := congrArg (fun x : G => a+x) hab
      simpa only [add_zero, ← add_assoc, add_neg_cancel, zero_add] using hh.symm
    exact huv (by simp only [hp,hb])
  have h := hn p q (-a+b) he
  have hi : incidence s (p,0) ∩ incidence s (q,-a+b) =
      (incidence s (p,a) ∩ incidence s (q,b)).image (shift (Fin 1) (-a)) := by
    rw [Finset.image_inter _ _ (shift (Fin 1) (-a)).injective]
    rw [← incidence_shift, ← incidence_shift]
    simp only [shift_apply, neg_add_cancel]
  rw [hi, Finset.card_image_of_injective _ (shift (Fin 1) (-a)).injective] at h
  exact h
theorem linear_A : ∀ u v, u≠v → (HA u ∩ HA v).card ≤ 1 :=
  linear_from_normalized socketsA (by decide +kernel)
theorem linear_B : ∀ u v, u≠v → (HB u ∩ HB v).card ≤ 1 :=
  linear_from_normalized socketsB (by decide +kernel)
#check linear_A
#check linear_B
private theorem A_root_0_0_0 :
    rootTerm HA (0,0) (0,0) = 0 := by decide +kernel
#check A_root_0_0_0
private theorem A_W_0_0_1 :
    properCommon HA (0,0) (0,1) = {(0,5),(1,2)} := by decide +kernel
private theorem A_root_0_0_1 :
    rootTerm HA (0,0) (0,1) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_1]
  decide +kernel
#check A_root_0_0_1
private theorem A_root_0_0_2 :
    rootTerm HA (0,0) (0,2) = 0 := by decide +kernel
#check A_root_0_0_2
private theorem A_root_0_0_3 :
    rootTerm HA (0,0) (0,3) = 0 := by decide +kernel
#check A_root_0_0_3
private theorem A_W_0_0_4 :
    properCommon HA (0,0) (0,4) = {(0,23),(1,11)} := by decide +kernel
private theorem A_root_0_0_4 :
    rootTerm HA (0,0) (0,4) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_4]
  decide +kernel
#check A_root_0_0_4
private theorem A_W_0_0_5 :
    properCommon HA (0,0) (0,5) = {(0,1),(1,10)} := by decide +kernel
private theorem A_root_0_0_5 :
    rootTerm HA (0,0) (0,5) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_5]
  decide +kernel
#check A_root_0_0_5
private theorem A_root_0_0_6 :
    rootTerm HA (0,0) (0,6) = 0 := by decide +kernel
#check A_root_0_0_6
private theorem A_root_0_0_7 :
    rootTerm HA (0,0) (0,7) = 0 := by decide +kernel
#check A_root_0_0_7
private theorem A_root_0_0_8 :
    rootTerm HA (0,0) (0,8) = 0 := by decide +kernel
#check A_root_0_0_8
private theorem A_root_0_0_9 :
    rootTerm HA (0,0) (0,9) = 0 := by decide +kernel
#check A_root_0_0_9
private theorem A_root_0_0_10 :
    rootTerm HA (0,0) (0,10) = 0 := by decide +kernel
#check A_root_0_0_10
private theorem A_root_0_0_11 :
    rootTerm HA (0,0) (0,11) = 0 := by decide +kernel
#check A_root_0_0_11
private theorem A_root_0_0_12 :
    rootTerm HA (0,0) (0,12) = 0 := by decide +kernel
#check A_root_0_0_12
private theorem A_root_0_0_13 :
    rootTerm HA (0,0) (0,13) = 0 := by decide +kernel
#check A_root_0_0_13
private theorem A_root_0_0_14 :
    rootTerm HA (0,0) (0,14) = 0 := by decide +kernel
#check A_root_0_0_14
private theorem A_root_0_0_15 :
    rootTerm HA (0,0) (0,15) = 0 := by decide +kernel
#check A_root_0_0_15
private theorem A_root_0_0_16 :
    rootTerm HA (0,0) (0,16) = 0 := by decide +kernel
#check A_root_0_0_16
private theorem A_root_0_0_17 :
    rootTerm HA (0,0) (0,17) = 0 := by decide +kernel
#check A_root_0_0_17
private theorem A_root_0_0_18 :
    rootTerm HA (0,0) (0,18) = 0 := by decide +kernel
#check A_root_0_0_18
private theorem A_W_0_0_19 :
    properCommon HA (0,0) (0,19) = {(0,20),(1,5)} := by decide +kernel
private theorem A_root_0_0_19 :
    rootTerm HA (0,0) (0,19) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_19]
  decide +kernel
#check A_root_0_0_19
private theorem A_W_0_0_20 :
    properCommon HA (0,0) (0,20) = {(0,19),(1,7)} := by decide +kernel
private theorem A_root_0_0_20 :
    rootTerm HA (0,0) (0,20) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_20]
  decide +kernel
#check A_root_0_0_20
private theorem A_root_0_0_21 :
    rootTerm HA (0,0) (0,21) = 0 := by decide +kernel
#check A_root_0_0_21
private theorem A_root_0_0_22 :
    rootTerm HA (0,0) (0,22) = 0 := by decide +kernel
#check A_root_0_0_22
private theorem A_W_0_0_23 :
    properCommon HA (0,0) (0,23) = {(0,4),(1,1)} := by decide +kernel
private theorem A_root_0_0_23 :
    rootTerm HA (0,0) (0,23) = 2 := by
  unfold rootTerm
  rw [A_W_0_0_23]
  decide +kernel
#check A_root_0_0_23
private theorem A_W_0_1_0 :
    properCommon HA (0,0) (1,0) = ∅ := by decide +kernel
private theorem A_root_0_1_0 :
    rootTerm HA (0,0) (1,0) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_0]
  decide +kernel
#check A_root_0_1_0
private theorem A_W_0_1_1 :
    properCommon HA (0,0) (1,1) = {(0,23),(1,15)} := by decide +kernel
private theorem A_root_0_1_1 :
    rootTerm HA (0,0) (1,1) = 2 := by
  unfold rootTerm
  rw [A_W_0_1_1]
  decide +kernel
#check A_root_0_1_1
private theorem A_W_0_1_2 :
    properCommon HA (0,0) (1,2) = {(0,1)} := by decide +kernel
private theorem A_root_0_1_2 :
    rootTerm HA (0,0) (1,2) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_2]
  decide +kernel
#check A_root_0_1_2
private theorem A_W_0_1_3 :
    properCommon HA (0,0) (1,3) = {(1,5)} := by decide +kernel
private theorem A_root_0_1_3 :
    rootTerm HA (0,0) (1,3) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_3]
  decide +kernel
#check A_root_0_1_3
private theorem A_root_0_1_4 :
    rootTerm HA (0,0) (1,4) = 0 := by decide +kernel
#check A_root_0_1_4
private theorem A_W_0_1_5 :
    properCommon HA (0,0) (1,5) = {(0,19),(1,3)} := by decide +kernel
private theorem A_root_0_1_5 :
    rootTerm HA (0,0) (1,5) = 2 := by
  unfold rootTerm
  rw [A_W_0_1_5]
  decide +kernel
#check A_root_0_1_5
private theorem A_root_0_1_6 :
    rootTerm HA (0,0) (1,6) = 0 := by decide +kernel
#check A_root_0_1_6
private theorem A_W_0_1_7 :
    properCommon HA (0,0) (1,7) = {(0,20)} := by decide +kernel
private theorem A_root_0_1_7 :
    rootTerm HA (0,0) (1,7) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_7]
  decide +kernel
#check A_root_0_1_7
private theorem A_root_0_1_8 :
    rootTerm HA (0,0) (1,8) = 0 := by decide +kernel
#check A_root_0_1_8
private theorem A_root_0_1_9 :
    rootTerm HA (0,0) (1,9) = 0 := by decide +kernel
#check A_root_0_1_9
private theorem A_W_0_1_10 :
    properCommon HA (0,0) (1,10) = {(0,5)} := by decide +kernel
private theorem A_root_0_1_10 :
    rootTerm HA (0,0) (1,10) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_10]
  decide +kernel
#check A_root_0_1_10
private theorem A_W_0_1_11 :
    properCommon HA (0,0) (1,11) = {(0,4)} := by decide +kernel
private theorem A_root_0_1_11 :
    rootTerm HA (0,0) (1,11) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_11]
  decide +kernel
#check A_root_0_1_11
private theorem A_root_0_1_12 :
    rootTerm HA (0,0) (1,12) = 0 := by decide +kernel
#check A_root_0_1_12
private theorem A_root_0_1_13 :
    rootTerm HA (0,0) (1,13) = 0 := by decide +kernel
#check A_root_0_1_13
private theorem A_root_0_1_14 :
    rootTerm HA (0,0) (1,14) = 0 := by decide +kernel
#check A_root_0_1_14
private theorem A_W_0_1_15 :
    properCommon HA (0,0) (1,15) = {(1,1)} := by decide +kernel
private theorem A_root_0_1_15 :
    rootTerm HA (0,0) (1,15) = 0 := by
  unfold rootTerm
  rw [A_W_0_1_15]
  decide +kernel
#check A_root_0_1_15
private theorem A_root_0_1_16 :
    rootTerm HA (0,0) (1,16) = 0 := by decide +kernel
#check A_root_0_1_16
private theorem A_root_0_1_17 :
    rootTerm HA (0,0) (1,17) = 0 := by decide +kernel
#check A_root_0_1_17
private theorem A_root_0_1_18 :
    rootTerm HA (0,0) (1,18) = 0 := by decide +kernel
#check A_root_0_1_18
private theorem A_root_0_1_19 :
    rootTerm HA (0,0) (1,19) = 0 := by decide +kernel
#check A_root_0_1_19
private theorem A_root_0_1_20 :
    rootTerm HA (0,0) (1,20) = 0 := by decide +kernel
#check A_root_0_1_20
private theorem A_root_0_1_21 :
    rootTerm HA (0,0) (1,21) = 0 := by decide +kernel
#check A_root_0_1_21
private theorem A_root_0_1_22 :
    rootTerm HA (0,0) (1,22) = 0 := by decide +kernel
#check A_root_0_1_22
private theorem A_root_0_1_23 :
    rootTerm HA (0,0) (1,23) = 0 := by decide +kernel
#check A_root_0_1_23
private theorem A_W_1_0_0 :
    properCommon HA (1,0) (0,0) = ∅ := by decide +kernel
private theorem A_root_1_0_0 :
    rootTerm HA (1,0) (0,0) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_0]
  decide +kernel
#check A_root_1_0_0
private theorem A_root_1_0_1 :
    rootTerm HA (1,0) (0,1) = 0 := by decide +kernel
#check A_root_1_0_1
private theorem A_root_1_0_2 :
    rootTerm HA (1,0) (0,2) = 0 := by decide +kernel
#check A_root_1_0_2
private theorem A_root_1_0_3 :
    rootTerm HA (1,0) (0,3) = 0 := by decide +kernel
#check A_root_1_0_3
private theorem A_root_1_0_4 :
    rootTerm HA (1,0) (0,4) = 0 := by decide +kernel
#check A_root_1_0_4
private theorem A_root_1_0_5 :
    rootTerm HA (1,0) (0,5) = 0 := by decide +kernel
#check A_root_1_0_5
private theorem A_root_1_0_6 :
    rootTerm HA (1,0) (0,6) = 0 := by decide +kernel
#check A_root_1_0_6
private theorem A_root_1_0_7 :
    rootTerm HA (1,0) (0,7) = 0 := by decide +kernel
#check A_root_1_0_7
private theorem A_root_1_0_8 :
    rootTerm HA (1,0) (0,8) = 0 := by decide +kernel
#check A_root_1_0_8
private theorem A_W_1_0_9 :
    properCommon HA (1,0) (0,9) = {(1,10)} := by decide +kernel
private theorem A_root_1_0_9 :
    rootTerm HA (1,0) (0,9) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_9]
  decide +kernel
#check A_root_1_0_9
private theorem A_root_1_0_10 :
    rootTerm HA (1,0) (0,10) = 0 := by decide +kernel
#check A_root_1_0_10
private theorem A_root_1_0_11 :
    rootTerm HA (1,0) (0,11) = 0 := by decide +kernel
#check A_root_1_0_11
private theorem A_root_1_0_12 :
    rootTerm HA (1,0) (0,12) = 0 := by decide +kernel
#check A_root_1_0_12
private theorem A_W_1_0_13 :
    properCommon HA (1,0) (0,13) = {(0,17)} := by decide +kernel
private theorem A_root_1_0_13 :
    rootTerm HA (1,0) (0,13) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_13]
  decide +kernel
#check A_root_1_0_13
private theorem A_W_1_0_14 :
    properCommon HA (1,0) (0,14) = {(0,19)} := by decide +kernel
private theorem A_root_1_0_14 :
    rootTerm HA (1,0) (0,14) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_14]
  decide +kernel
#check A_root_1_0_14
private theorem A_root_1_0_15 :
    rootTerm HA (1,0) (0,15) = 0 := by decide +kernel
#check A_root_1_0_15
private theorem A_root_1_0_16 :
    rootTerm HA (1,0) (0,16) = 0 := by decide +kernel
#check A_root_1_0_16
private theorem A_W_1_0_17 :
    properCommon HA (1,0) (0,17) = {(0,13)} := by decide +kernel
private theorem A_root_1_0_17 :
    rootTerm HA (1,0) (0,17) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_17]
  decide +kernel
#check A_root_1_0_17
private theorem A_root_1_0_18 :
    rootTerm HA (1,0) (0,18) = 0 := by decide +kernel
#check A_root_1_0_18
private theorem A_W_1_0_19 :
    properCommon HA (1,0) (0,19) = {(0,14),(1,22)} := by decide +kernel
private theorem A_root_1_0_19 :
    rootTerm HA (1,0) (0,19) = 2 := by
  unfold rootTerm
  rw [A_W_1_0_19]
  decide +kernel
#check A_root_1_0_19
private theorem A_root_1_0_20 :
    rootTerm HA (1,0) (0,20) = 0 := by decide +kernel
#check A_root_1_0_20
private theorem A_W_1_0_21 :
    properCommon HA (1,0) (0,21) = {(1,2)} := by decide +kernel
private theorem A_root_1_0_21 :
    rootTerm HA (1,0) (0,21) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_21]
  decide +kernel
#check A_root_1_0_21
private theorem A_W_1_0_22 :
    properCommon HA (1,0) (0,22) = {(0,23)} := by decide +kernel
private theorem A_root_1_0_22 :
    rootTerm HA (1,0) (0,22) = 0 := by
  unfold rootTerm
  rw [A_W_1_0_22]
  decide +kernel
#check A_root_1_0_22
private theorem A_W_1_0_23 :
    properCommon HA (1,0) (0,23) = {(0,22),(1,14)} := by decide +kernel
private theorem A_root_1_0_23 :
    rootTerm HA (1,0) (0,23) = 2 := by
  unfold rootTerm
  rw [A_W_1_0_23]
  decide +kernel
#check A_root_1_0_23
private theorem A_root_1_1_0 :
    rootTerm HA (1,0) (1,0) = 0 := by decide +kernel
#check A_root_1_1_0
private theorem A_root_1_1_1 :
    rootTerm HA (1,0) (1,1) = 0 := by decide +kernel
#check A_root_1_1_1
private theorem A_W_1_1_2 :
    properCommon HA (1,0) (1,2) = {(0,21),(1,16)} := by decide +kernel
private theorem A_root_1_1_2 :
    rootTerm HA (1,0) (1,2) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_2]
  decide +kernel
#check A_root_1_1_2
private theorem A_root_1_1_3 :
    rootTerm HA (1,0) (1,3) = 0 := by decide +kernel
#check A_root_1_1_3
private theorem A_root_1_1_4 :
    rootTerm HA (1,0) (1,4) = 0 := by decide +kernel
#check A_root_1_1_4
private theorem A_root_1_1_5 :
    rootTerm HA (1,0) (1,5) = 0 := by decide +kernel
#check A_root_1_1_5
private theorem A_root_1_1_6 :
    rootTerm HA (1,0) (1,6) = 0 := by decide +kernel
#check A_root_1_1_6
private theorem A_root_1_1_7 :
    rootTerm HA (1,0) (1,7) = 0 := by decide +kernel
#check A_root_1_1_7
private theorem A_W_1_1_8 :
    properCommon HA (1,0) (1,8) = {(1,10),(1,16)} := by decide +kernel
private theorem A_root_1_1_8 :
    rootTerm HA (1,0) (1,8) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_8]
  decide +kernel
#check A_root_1_1_8
private theorem A_root_1_1_9 :
    rootTerm HA (1,0) (1,9) = 0 := by decide +kernel
#check A_root_1_1_9
private theorem A_W_1_1_10 :
    properCommon HA (1,0) (1,10) = {(0,9),(1,8)} := by decide +kernel
private theorem A_root_1_1_10 :
    rootTerm HA (1,0) (1,10) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_10]
  decide +kernel
#check A_root_1_1_10
private theorem A_root_1_1_11 :
    rootTerm HA (1,0) (1,11) = 0 := by decide +kernel
#check A_root_1_1_11
private theorem A_root_1_1_12 :
    rootTerm HA (1,0) (1,12) = 0 := by decide +kernel
#check A_root_1_1_12
private theorem A_root_1_1_13 :
    rootTerm HA (1,0) (1,13) = 0 := by decide +kernel
#check A_root_1_1_13
private theorem A_W_1_1_14 :
    properCommon HA (1,0) (1,14) = {(0,23),(1,22)} := by decide +kernel
private theorem A_root_1_1_14 :
    rootTerm HA (1,0) (1,14) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_14]
  decide +kernel
#check A_root_1_1_14
private theorem A_root_1_1_15 :
    rootTerm HA (1,0) (1,15) = 0 := by decide +kernel
#check A_root_1_1_15
private theorem A_W_1_1_16 :
    properCommon HA (1,0) (1,16) = {(1,2),(1,8)} := by decide +kernel
private theorem A_root_1_1_16 :
    rootTerm HA (1,0) (1,16) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_16]
  decide +kernel
#check A_root_1_1_16
private theorem A_root_1_1_17 :
    rootTerm HA (1,0) (1,17) = 0 := by decide +kernel
#check A_root_1_1_17
private theorem A_root_1_1_18 :
    rootTerm HA (1,0) (1,18) = 0 := by decide +kernel
#check A_root_1_1_18
private theorem A_root_1_1_19 :
    rootTerm HA (1,0) (1,19) = 0 := by decide +kernel
#check A_root_1_1_19
private theorem A_root_1_1_20 :
    rootTerm HA (1,0) (1,20) = 0 := by decide +kernel
#check A_root_1_1_20
private theorem A_root_1_1_21 :
    rootTerm HA (1,0) (1,21) = 0 := by decide +kernel
#check A_root_1_1_21
private theorem A_W_1_1_22 :
    properCommon HA (1,0) (1,22) = {(0,19),(1,14)} := by decide +kernel
private theorem A_root_1_1_22 :
    rootTerm HA (1,0) (1,22) = 2 := by
  unfold rootTerm
  rw [A_W_1_1_22]
  decide +kernel
#check A_root_1_1_22
private theorem A_root_1_1_23 :
    rootTerm HA (1,0) (1,23) = 0 := by decide +kernel
#check A_root_1_1_23
def rootTableA (p q : Fin 2) (d : G) : ℕ :=
  match p.val,q.val,d.val with
  | 0,0,1 => 2
  | 0,0,4 => 2
  | 0,0,5 => 2
  | 0,0,19 => 2
  | 0,0,20 => 2
  | 0,0,23 => 2
  | 0,1,1 => 2
  | 0,1,5 => 2
  | 1,0,19 => 2
  | 1,0,23 => 2
  | 1,1,2 => 2
  | 1,1,8 => 2
  | 1,1,10 => 2
  | 1,1,14 => 2
  | 1,1,16 => 2
  | 1,1,22 => 2
  | _,_,_ => 0
theorem root_A_eq_table (p q : Fin 2) (d : G) :
    rootTerm HA (p,0) (q,d) = rootTableA p q d := by
  fin_cases p
  · fin_cases q
    · fin_cases d
      · change rootTerm HA (0,0) (0,0) = 0
        exact A_root_0_0_0
      · change rootTerm HA (0,0) (0,1) = 2
        exact A_root_0_0_1
      · change rootTerm HA (0,0) (0,2) = 0
        exact A_root_0_0_2
      · change rootTerm HA (0,0) (0,3) = 0
        exact A_root_0_0_3
      · change rootTerm HA (0,0) (0,4) = 2
        exact A_root_0_0_4
      · change rootTerm HA (0,0) (0,5) = 2
        exact A_root_0_0_5
      · change rootTerm HA (0,0) (0,6) = 0
        exact A_root_0_0_6
      · change rootTerm HA (0,0) (0,7) = 0
        exact A_root_0_0_7
      · change rootTerm HA (0,0) (0,8) = 0
        exact A_root_0_0_8
      · change rootTerm HA (0,0) (0,9) = 0
        exact A_root_0_0_9
      · change rootTerm HA (0,0) (0,10) = 0
        exact A_root_0_0_10
      · change rootTerm HA (0,0) (0,11) = 0
        exact A_root_0_0_11
      · change rootTerm HA (0,0) (0,12) = 0
        exact A_root_0_0_12
      · change rootTerm HA (0,0) (0,13) = 0
        exact A_root_0_0_13
      · change rootTerm HA (0,0) (0,14) = 0
        exact A_root_0_0_14
      · change rootTerm HA (0,0) (0,15) = 0
        exact A_root_0_0_15
      · change rootTerm HA (0,0) (0,16) = 0
        exact A_root_0_0_16
      · change rootTerm HA (0,0) (0,17) = 0
        exact A_root_0_0_17
      · change rootTerm HA (0,0) (0,18) = 0
        exact A_root_0_0_18
      · change rootTerm HA (0,0) (0,19) = 2
        exact A_root_0_0_19
      · change rootTerm HA (0,0) (0,20) = 2
        exact A_root_0_0_20
      · change rootTerm HA (0,0) (0,21) = 0
        exact A_root_0_0_21
      · change rootTerm HA (0,0) (0,22) = 0
        exact A_root_0_0_22
      · change rootTerm HA (0,0) (0,23) = 2
        exact A_root_0_0_23
    · fin_cases d
      · change rootTerm HA (0,0) (1,0) = 0
        exact A_root_0_1_0
      · change rootTerm HA (0,0) (1,1) = 2
        exact A_root_0_1_1
      · change rootTerm HA (0,0) (1,2) = 0
        exact A_root_0_1_2
      · change rootTerm HA (0,0) (1,3) = 0
        exact A_root_0_1_3
      · change rootTerm HA (0,0) (1,4) = 0
        exact A_root_0_1_4
      · change rootTerm HA (0,0) (1,5) = 2
        exact A_root_0_1_5
      · change rootTerm HA (0,0) (1,6) = 0
        exact A_root_0_1_6
      · change rootTerm HA (0,0) (1,7) = 0
        exact A_root_0_1_7
      · change rootTerm HA (0,0) (1,8) = 0
        exact A_root_0_1_8
      · change rootTerm HA (0,0) (1,9) = 0
        exact A_root_0_1_9
      · change rootTerm HA (0,0) (1,10) = 0
        exact A_root_0_1_10
      · change rootTerm HA (0,0) (1,11) = 0
        exact A_root_0_1_11
      · change rootTerm HA (0,0) (1,12) = 0
        exact A_root_0_1_12
      · change rootTerm HA (0,0) (1,13) = 0
        exact A_root_0_1_13
      · change rootTerm HA (0,0) (1,14) = 0
        exact A_root_0_1_14
      · change rootTerm HA (0,0) (1,15) = 0
        exact A_root_0_1_15
      · change rootTerm HA (0,0) (1,16) = 0
        exact A_root_0_1_16
      · change rootTerm HA (0,0) (1,17) = 0
        exact A_root_0_1_17
      · change rootTerm HA (0,0) (1,18) = 0
        exact A_root_0_1_18
      · change rootTerm HA (0,0) (1,19) = 0
        exact A_root_0_1_19
      · change rootTerm HA (0,0) (1,20) = 0
        exact A_root_0_1_20
      · change rootTerm HA (0,0) (1,21) = 0
        exact A_root_0_1_21
      · change rootTerm HA (0,0) (1,22) = 0
        exact A_root_0_1_22
      · change rootTerm HA (0,0) (1,23) = 0
        exact A_root_0_1_23
  · fin_cases q
    · fin_cases d
      · change rootTerm HA (1,0) (0,0) = 0
        exact A_root_1_0_0
      · change rootTerm HA (1,0) (0,1) = 0
        exact A_root_1_0_1
      · change rootTerm HA (1,0) (0,2) = 0
        exact A_root_1_0_2
      · change rootTerm HA (1,0) (0,3) = 0
        exact A_root_1_0_3
      · change rootTerm HA (1,0) (0,4) = 0
        exact A_root_1_0_4
      · change rootTerm HA (1,0) (0,5) = 0
        exact A_root_1_0_5
      · change rootTerm HA (1,0) (0,6) = 0
        exact A_root_1_0_6
      · change rootTerm HA (1,0) (0,7) = 0
        exact A_root_1_0_7
      · change rootTerm HA (1,0) (0,8) = 0
        exact A_root_1_0_8
      · change rootTerm HA (1,0) (0,9) = 0
        exact A_root_1_0_9
      · change rootTerm HA (1,0) (0,10) = 0
        exact A_root_1_0_10
      · change rootTerm HA (1,0) (0,11) = 0
        exact A_root_1_0_11
      · change rootTerm HA (1,0) (0,12) = 0
        exact A_root_1_0_12
      · change rootTerm HA (1,0) (0,13) = 0
        exact A_root_1_0_13
      · change rootTerm HA (1,0) (0,14) = 0
        exact A_root_1_0_14
      · change rootTerm HA (1,0) (0,15) = 0
        exact A_root_1_0_15
      · change rootTerm HA (1,0) (0,16) = 0
        exact A_root_1_0_16
      · change rootTerm HA (1,0) (0,17) = 0
        exact A_root_1_0_17
      · change rootTerm HA (1,0) (0,18) = 0
        exact A_root_1_0_18
      · change rootTerm HA (1,0) (0,19) = 2
        exact A_root_1_0_19
      · change rootTerm HA (1,0) (0,20) = 0
        exact A_root_1_0_20
      · change rootTerm HA (1,0) (0,21) = 0
        exact A_root_1_0_21
      · change rootTerm HA (1,0) (0,22) = 0
        exact A_root_1_0_22
      · change rootTerm HA (1,0) (0,23) = 2
        exact A_root_1_0_23
    · fin_cases d
      · change rootTerm HA (1,0) (1,0) = 0
        exact A_root_1_1_0
      · change rootTerm HA (1,0) (1,1) = 0
        exact A_root_1_1_1
      · change rootTerm HA (1,0) (1,2) = 2
        exact A_root_1_1_2
      · change rootTerm HA (1,0) (1,3) = 0
        exact A_root_1_1_3
      · change rootTerm HA (1,0) (1,4) = 0
        exact A_root_1_1_4
      · change rootTerm HA (1,0) (1,5) = 0
        exact A_root_1_1_5
      · change rootTerm HA (1,0) (1,6) = 0
        exact A_root_1_1_6
      · change rootTerm HA (1,0) (1,7) = 0
        exact A_root_1_1_7
      · change rootTerm HA (1,0) (1,8) = 2
        exact A_root_1_1_8
      · change rootTerm HA (1,0) (1,9) = 0
        exact A_root_1_1_9
      · change rootTerm HA (1,0) (1,10) = 2
        exact A_root_1_1_10
      · change rootTerm HA (1,0) (1,11) = 0
        exact A_root_1_1_11
      · change rootTerm HA (1,0) (1,12) = 0
        exact A_root_1_1_12
      · change rootTerm HA (1,0) (1,13) = 0
        exact A_root_1_1_13
      · change rootTerm HA (1,0) (1,14) = 2
        exact A_root_1_1_14
      · change rootTerm HA (1,0) (1,15) = 0
        exact A_root_1_1_15
      · change rootTerm HA (1,0) (1,16) = 2
        exact A_root_1_1_16
      · change rootTerm HA (1,0) (1,17) = 0
        exact A_root_1_1_17
      · change rootTerm HA (1,0) (1,18) = 0
        exact A_root_1_1_18
      · change rootTerm HA (1,0) (1,19) = 0
        exact A_root_1_1_19
      · change rootTerm HA (1,0) (1,20) = 0
        exact A_root_1_1_20
      · change rootTerm HA (1,0) (1,21) = 0
        exact A_root_1_1_21
      · change rootTerm HA (1,0) (1,22) = 2
        exact A_root_1_1_22
      · change rootTerm HA (1,0) (1,23) = 0
        exact A_root_1_1_23
theorem normalized_A : normalizedSum socketsA = 32 := by
  unfold normalizedSum
  simp_rw [show incidence socketsA = HA from rfl, root_A_eq_table]
  decide +kernel
theorem count_A : GlobalCounting.count42 HA = 192 := by
  have h := cyclic_count_identity socketsA cubic_A linear_A
  rw [normalized_A] at h
  change 4 * GlobalCounting.count42 HA = 24 * 32 at h
  exact Nat.eq_of_mul_eq_mul_left (n:=4) (by decide +kernel +kernel) h
#print axioms count_A
private theorem B_root_0_0_0 :
    rootTerm HB (0,0) (0,0) = 0 := by decide +kernel
#check B_root_0_0_0
private theorem B_W_0_0_1 :
    properCommon HB (0,0) (0,1) = {(0,5),(1,2)} := by decide +kernel
private theorem B_root_0_0_1 :
    rootTerm HB (0,0) (0,1) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_1]
  decide +kernel
#check B_root_0_0_1
private theorem B_root_0_0_2 :
    rootTerm HB (0,0) (0,2) = 0 := by decide +kernel
#check B_root_0_0_2
private theorem B_root_0_0_3 :
    rootTerm HB (0,0) (0,3) = 0 := by decide +kernel
#check B_root_0_0_3
private theorem B_W_0_0_4 :
    properCommon HB (0,0) (0,4) = {(0,23),(1,1)} := by decide +kernel
private theorem B_root_0_0_4 :
    rootTerm HB (0,0) (0,4) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_4]
  decide +kernel
#check B_root_0_0_4
private theorem B_W_0_0_5 :
    properCommon HB (0,0) (0,5) = {(0,1),(1,2)} := by decide +kernel
private theorem B_root_0_0_5 :
    rootTerm HB (0,0) (0,5) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_5]
  decide +kernel
#check B_root_0_0_5
private theorem B_root_0_0_6 :
    rootTerm HB (0,0) (0,6) = 0 := by decide +kernel
#check B_root_0_0_6
private theorem B_root_0_0_7 :
    rootTerm HB (0,0) (0,7) = 0 := by decide +kernel
#check B_root_0_0_7
private theorem B_root_0_0_8 :
    rootTerm HB (0,0) (0,8) = 0 := by decide +kernel
#check B_root_0_0_8
private theorem B_root_0_0_9 :
    rootTerm HB (0,0) (0,9) = 0 := by decide +kernel
#check B_root_0_0_9
private theorem B_root_0_0_10 :
    rootTerm HB (0,0) (0,10) = 0 := by decide +kernel
#check B_root_0_0_10
private theorem B_root_0_0_11 :
    rootTerm HB (0,0) (0,11) = 0 := by decide +kernel
#check B_root_0_0_11
private theorem B_root_0_0_12 :
    rootTerm HB (0,0) (0,12) = 0 := by decide +kernel
#check B_root_0_0_12
private theorem B_root_0_0_13 :
    rootTerm HB (0,0) (0,13) = 0 := by decide +kernel
#check B_root_0_0_13
private theorem B_root_0_0_14 :
    rootTerm HB (0,0) (0,14) = 0 := by decide +kernel
#check B_root_0_0_14
private theorem B_root_0_0_15 :
    rootTerm HB (0,0) (0,15) = 0 := by decide +kernel
#check B_root_0_0_15
private theorem B_root_0_0_16 :
    rootTerm HB (0,0) (0,16) = 0 := by decide +kernel
#check B_root_0_0_16
private theorem B_root_0_0_17 :
    rootTerm HB (0,0) (0,17) = 0 := by decide +kernel
#check B_root_0_0_17
private theorem B_root_0_0_18 :
    rootTerm HB (0,0) (0,18) = 0 := by decide +kernel
#check B_root_0_0_18
private theorem B_W_0_0_19 :
    properCommon HB (0,0) (0,19) = {(0,20),(1,21)} := by decide +kernel
private theorem B_root_0_0_19 :
    rootTerm HB (0,0) (0,19) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_19]
  decide +kernel
#check B_root_0_0_19
private theorem B_W_0_0_20 :
    properCommon HB (0,0) (0,20) = {(0,19),(1,21)} := by decide +kernel
private theorem B_root_0_0_20 :
    rootTerm HB (0,0) (0,20) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_20]
  decide +kernel
#check B_root_0_0_20
private theorem B_root_0_0_21 :
    rootTerm HB (0,0) (0,21) = 0 := by decide +kernel
#check B_root_0_0_21
private theorem B_root_0_0_22 :
    rootTerm HB (0,0) (0,22) = 0 := by decide +kernel
#check B_root_0_0_22
private theorem B_W_0_0_23 :
    properCommon HB (0,0) (0,23) = {(0,4),(1,1)} := by decide +kernel
private theorem B_root_0_0_23 :
    rootTerm HB (0,0) (0,23) = 0 := by
  unfold rootTerm
  rw [B_W_0_0_23]
  decide +kernel
#check B_root_0_0_23
private theorem B_W_0_1_0 :
    properCommon HB (0,0) (1,0) = ∅ := by decide +kernel
private theorem B_root_0_1_0 :
    rootTerm HB (0,0) (1,0) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_0]
  decide +kernel
#check B_root_0_1_0
private theorem B_W_0_1_1 :
    properCommon HB (0,0) (1,1) = {(0,4),(0,23)} := by decide +kernel
private theorem B_root_0_1_1 :
    rootTerm HB (0,0) (1,1) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_1]
  decide +kernel
#check B_root_0_1_1
private theorem B_W_0_1_2 :
    properCommon HB (0,0) (1,2) = {(0,1),(0,5)} := by decide +kernel
private theorem B_root_0_1_2 :
    rootTerm HB (0,0) (1,2) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_2]
  decide +kernel
#check B_root_0_1_2
private theorem B_W_0_1_3 :
    properCommon HB (0,0) (1,3) = {(1,5)} := by decide +kernel
private theorem B_root_0_1_3 :
    rootTerm HB (0,0) (1,3) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_3]
  decide +kernel
#check B_root_0_1_3
private theorem B_root_0_1_4 :
    rootTerm HB (0,0) (1,4) = 0 := by decide +kernel
#check B_root_0_1_4
private theorem B_W_0_1_5 :
    properCommon HB (0,0) (1,5) = {(1,3)} := by decide +kernel
private theorem B_root_0_1_5 :
    rootTerm HB (0,0) (1,5) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_5]
  decide +kernel
#check B_root_0_1_5
private theorem B_root_0_1_6 :
    rootTerm HB (0,0) (1,6) = 0 := by decide +kernel
#check B_root_0_1_6
private theorem B_W_0_1_7 :
    properCommon HB (0,0) (1,7) = {(1,17)} := by decide +kernel
private theorem B_root_0_1_7 :
    rootTerm HB (0,0) (1,7) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_7]
  decide +kernel
#check B_root_0_1_7
private theorem B_root_0_1_8 :
    rootTerm HB (0,0) (1,8) = 0 := by decide +kernel
#check B_root_0_1_8
private theorem B_root_0_1_9 :
    rootTerm HB (0,0) (1,9) = 0 := by decide +kernel
#check B_root_0_1_9
private theorem B_root_0_1_10 :
    rootTerm HB (0,0) (1,10) = 0 := by decide +kernel
#check B_root_0_1_10
private theorem B_root_0_1_11 :
    rootTerm HB (0,0) (1,11) = 0 := by decide +kernel
#check B_root_0_1_11
private theorem B_root_0_1_12 :
    rootTerm HB (0,0) (1,12) = 0 := by decide +kernel
#check B_root_0_1_12
private theorem B_root_0_1_13 :
    rootTerm HB (0,0) (1,13) = 0 := by decide +kernel
#check B_root_0_1_13
private theorem B_root_0_1_14 :
    rootTerm HB (0,0) (1,14) = 0 := by decide +kernel
#check B_root_0_1_14
private theorem B_root_0_1_15 :
    rootTerm HB (0,0) (1,15) = 0 := by decide +kernel
#check B_root_0_1_15
private theorem B_W_0_1_16 :
    properCommon HB (0,0) (1,16) = ∅ := by decide +kernel
private theorem B_root_0_1_16 :
    rootTerm HB (0,0) (1,16) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_16]
  decide +kernel
#check B_root_0_1_16
private theorem B_W_0_1_17 :
    properCommon HB (0,0) (1,17) = {(1,7)} := by decide +kernel
private theorem B_root_0_1_17 :
    rootTerm HB (0,0) (1,17) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_17]
  decide +kernel
#check B_root_0_1_17
private theorem B_root_0_1_18 :
    rootTerm HB (0,0) (1,18) = 0 := by decide +kernel
#check B_root_0_1_18
private theorem B_root_0_1_19 :
    rootTerm HB (0,0) (1,19) = 0 := by decide +kernel
#check B_root_0_1_19
private theorem B_root_0_1_20 :
    rootTerm HB (0,0) (1,20) = 0 := by decide +kernel
#check B_root_0_1_20
private theorem B_W_0_1_21 :
    properCommon HB (0,0) (1,21) = {(0,19),(0,20)} := by decide +kernel
private theorem B_root_0_1_21 :
    rootTerm HB (0,0) (1,21) = 0 := by
  unfold rootTerm
  rw [B_W_0_1_21]
  decide +kernel
#check B_root_0_1_21
private theorem B_root_0_1_22 :
    rootTerm HB (0,0) (1,22) = 0 := by decide +kernel
#check B_root_0_1_22
private theorem B_root_0_1_23 :
    rootTerm HB (0,0) (1,23) = 0 := by decide +kernel
#check B_root_0_1_23
private theorem B_W_1_0_0 :
    properCommon HB (1,0) (0,0) = ∅ := by decide +kernel
private theorem B_root_1_0_0 :
    rootTerm HB (1,0) (0,0) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_0]
  decide +kernel
#check B_root_1_0_0
private theorem B_root_1_0_1 :
    rootTerm HB (1,0) (0,1) = 0 := by decide +kernel
#check B_root_1_0_1
private theorem B_root_1_0_2 :
    rootTerm HB (1,0) (0,2) = 0 := by decide +kernel
#check B_root_1_0_2
private theorem B_W_1_0_3 :
    properCommon HB (1,0) (0,3) = {(0,22),(0,23)} := by decide +kernel
private theorem B_root_1_0_3 :
    rootTerm HB (1,0) (0,3) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_3]
  decide +kernel
#check B_root_1_0_3
private theorem B_root_1_0_4 :
    rootTerm HB (1,0) (0,4) = 0 := by decide +kernel
#check B_root_1_0_4
private theorem B_root_1_0_5 :
    rootTerm HB (1,0) (0,5) = 0 := by decide +kernel
#check B_root_1_0_5
private theorem B_root_1_0_6 :
    rootTerm HB (1,0) (0,6) = 0 := by decide +kernel
#check B_root_1_0_6
private theorem B_W_1_0_7 :
    properCommon HB (1,0) (0,7) = {(1,14)} := by decide +kernel
private theorem B_root_1_0_7 :
    rootTerm HB (1,0) (0,7) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_7]
  decide +kernel
#check B_root_1_0_7
private theorem B_W_1_0_8 :
    properCommon HB (1,0) (0,8) = ∅ := by decide +kernel
private theorem B_root_1_0_8 :
    rootTerm HB (1,0) (0,8) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_8]
  decide +kernel
#check B_root_1_0_8
private theorem B_root_1_0_9 :
    rootTerm HB (1,0) (0,9) = 0 := by decide +kernel
#check B_root_1_0_9
private theorem B_root_1_0_10 :
    rootTerm HB (1,0) (0,10) = 0 := by decide +kernel
#check B_root_1_0_10
private theorem B_root_1_0_11 :
    rootTerm HB (1,0) (0,11) = 0 := by decide +kernel
#check B_root_1_0_11
private theorem B_root_1_0_12 :
    rootTerm HB (1,0) (0,12) = 0 := by decide +kernel
#check B_root_1_0_12
private theorem B_root_1_0_13 :
    rootTerm HB (1,0) (0,13) = 0 := by decide +kernel
#check B_root_1_0_13
private theorem B_root_1_0_14 :
    rootTerm HB (1,0) (0,14) = 0 := by decide +kernel
#check B_root_1_0_14
private theorem B_root_1_0_15 :
    rootTerm HB (1,0) (0,15) = 0 := by decide +kernel
#check B_root_1_0_15
private theorem B_root_1_0_16 :
    rootTerm HB (1,0) (0,16) = 0 := by decide +kernel
#check B_root_1_0_16
private theorem B_W_1_0_17 :
    properCommon HB (1,0) (0,17) = {(1,10)} := by decide +kernel
private theorem B_root_1_0_17 :
    rootTerm HB (1,0) (0,17) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_17]
  decide +kernel
#check B_root_1_0_17
private theorem B_root_1_0_18 :
    rootTerm HB (1,0) (0,18) = 0 := by decide +kernel
#check B_root_1_0_18
private theorem B_W_1_0_19 :
    properCommon HB (1,0) (0,19) = {(1,22)} := by decide +kernel
private theorem B_root_1_0_19 :
    rootTerm HB (1,0) (0,19) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_19]
  decide +kernel
#check B_root_1_0_19
private theorem B_root_1_0_20 :
    rootTerm HB (1,0) (0,20) = 0 := by decide +kernel
#check B_root_1_0_20
private theorem B_W_1_0_21 :
    properCommon HB (1,0) (0,21) = {(1,2)} := by decide +kernel
private theorem B_root_1_0_21 :
    rootTerm HB (1,0) (0,21) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_21]
  decide +kernel
#check B_root_1_0_21
private theorem B_W_1_0_22 :
    properCommon HB (1,0) (0,22) = {(0,3),(0,23)} := by decide +kernel
private theorem B_root_1_0_22 :
    rootTerm HB (1,0) (0,22) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_22]
  decide +kernel
#check B_root_1_0_22
private theorem B_W_1_0_23 :
    properCommon HB (1,0) (0,23) = {(0,3),(0,22)} := by decide +kernel
private theorem B_root_1_0_23 :
    rootTerm HB (1,0) (0,23) = 0 := by
  unfold rootTerm
  rw [B_W_1_0_23]
  decide +kernel
#check B_root_1_0_23
private theorem B_root_1_1_0 :
    rootTerm HB (1,0) (1,0) = 0 := by decide +kernel
#check B_root_1_1_0
private theorem B_root_1_1_1 :
    rootTerm HB (1,0) (1,1) = 0 := by decide +kernel
#check B_root_1_1_1
private theorem B_W_1_1_2 :
    properCommon HB (1,0) (1,2) = {(0,21),(1,10)} := by decide +kernel
private theorem B_root_1_1_2 :
    rootTerm HB (1,0) (1,2) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_2]
  decide +kernel
#check B_root_1_1_2
private theorem B_root_1_1_3 :
    rootTerm HB (1,0) (1,3) = 0 := by decide +kernel
#check B_root_1_1_3
private theorem B_root_1_1_4 :
    rootTerm HB (1,0) (1,4) = 0 := by decide +kernel
#check B_root_1_1_4
private theorem B_root_1_1_5 :
    rootTerm HB (1,0) (1,5) = 0 := by decide +kernel
#check B_root_1_1_5
private theorem B_root_1_1_6 :
    rootTerm HB (1,0) (1,6) = 0 := by decide +kernel
#check B_root_1_1_6
private theorem B_root_1_1_7 :
    rootTerm HB (1,0) (1,7) = 0 := by decide +kernel
#check B_root_1_1_7
private theorem B_W_1_1_8 :
    properCommon HB (1,0) (1,8) = {(1,16),(1,22)} := by decide +kernel
private theorem B_root_1_1_8 :
    rootTerm HB (1,0) (1,8) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_8]
  decide +kernel
#check B_root_1_1_8
private theorem B_root_1_1_9 :
    rootTerm HB (1,0) (1,9) = 0 := by decide +kernel
#check B_root_1_1_9
private theorem B_W_1_1_10 :
    properCommon HB (1,0) (1,10) = {(0,17),(1,2)} := by decide +kernel
private theorem B_root_1_1_10 :
    rootTerm HB (1,0) (1,10) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_10]
  decide +kernel
#check B_root_1_1_10
private theorem B_root_1_1_11 :
    rootTerm HB (1,0) (1,11) = 0 := by decide +kernel
#check B_root_1_1_11
private theorem B_root_1_1_12 :
    rootTerm HB (1,0) (1,12) = 0 := by decide +kernel
#check B_root_1_1_12
private theorem B_root_1_1_13 :
    rootTerm HB (1,0) (1,13) = 0 := by decide +kernel
#check B_root_1_1_13
private theorem B_W_1_1_14 :
    properCommon HB (1,0) (1,14) = {(0,7),(1,16)} := by decide +kernel
private theorem B_root_1_1_14 :
    rootTerm HB (1,0) (1,14) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_14]
  decide +kernel
#check B_root_1_1_14
private theorem B_root_1_1_15 :
    rootTerm HB (1,0) (1,15) = 0 := by decide +kernel
#check B_root_1_1_15
private theorem B_W_1_1_16 :
    properCommon HB (1,0) (1,16) = {(1,8),(1,14)} := by decide +kernel
private theorem B_root_1_1_16 :
    rootTerm HB (1,0) (1,16) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_16]
  decide +kernel
#check B_root_1_1_16
private theorem B_root_1_1_17 :
    rootTerm HB (1,0) (1,17) = 0 := by decide +kernel
#check B_root_1_1_17
private theorem B_root_1_1_18 :
    rootTerm HB (1,0) (1,18) = 0 := by decide +kernel
#check B_root_1_1_18
private theorem B_root_1_1_19 :
    rootTerm HB (1,0) (1,19) = 0 := by decide +kernel
#check B_root_1_1_19
private theorem B_root_1_1_20 :
    rootTerm HB (1,0) (1,20) = 0 := by decide +kernel
#check B_root_1_1_20
private theorem B_root_1_1_21 :
    rootTerm HB (1,0) (1,21) = 0 := by decide +kernel
#check B_root_1_1_21
private theorem B_W_1_1_22 :
    properCommon HB (1,0) (1,22) = {(0,19),(1,8)} := by decide +kernel
private theorem B_root_1_1_22 :
    rootTerm HB (1,0) (1,22) = 2 := by
  unfold rootTerm
  rw [B_W_1_1_22]
  decide +kernel
#check B_root_1_1_22
private theorem B_root_1_1_23 :
    rootTerm HB (1,0) (1,23) = 0 := by decide +kernel
#check B_root_1_1_23
def rootTableB (p q : Fin 2) (d : G) : ℕ :=
  match p.val,q.val,d.val with
  | 1,1,2 => 2
  | 1,1,8 => 2
  | 1,1,10 => 2
  | 1,1,14 => 2
  | 1,1,16 => 2
  | 1,1,22 => 2
  | _,_,_ => 0
theorem root_B_eq_table (p q : Fin 2) (d : G) :
    rootTerm HB (p,0) (q,d) = rootTableB p q d := by
  fin_cases p
  · fin_cases q
    · fin_cases d
      · change rootTerm HB (0,0) (0,0) = 0
        exact B_root_0_0_0
      · change rootTerm HB (0,0) (0,1) = 0
        exact B_root_0_0_1
      · change rootTerm HB (0,0) (0,2) = 0
        exact B_root_0_0_2
      · change rootTerm HB (0,0) (0,3) = 0
        exact B_root_0_0_3
      · change rootTerm HB (0,0) (0,4) = 0
        exact B_root_0_0_4
      · change rootTerm HB (0,0) (0,5) = 0
        exact B_root_0_0_5
      · change rootTerm HB (0,0) (0,6) = 0
        exact B_root_0_0_6
      · change rootTerm HB (0,0) (0,7) = 0
        exact B_root_0_0_7
      · change rootTerm HB (0,0) (0,8) = 0
        exact B_root_0_0_8
      · change rootTerm HB (0,0) (0,9) = 0
        exact B_root_0_0_9
      · change rootTerm HB (0,0) (0,10) = 0
        exact B_root_0_0_10
      · change rootTerm HB (0,0) (0,11) = 0
        exact B_root_0_0_11
      · change rootTerm HB (0,0) (0,12) = 0
        exact B_root_0_0_12
      · change rootTerm HB (0,0) (0,13) = 0
        exact B_root_0_0_13
      · change rootTerm HB (0,0) (0,14) = 0
        exact B_root_0_0_14
      · change rootTerm HB (0,0) (0,15) = 0
        exact B_root_0_0_15
      · change rootTerm HB (0,0) (0,16) = 0
        exact B_root_0_0_16
      · change rootTerm HB (0,0) (0,17) = 0
        exact B_root_0_0_17
      · change rootTerm HB (0,0) (0,18) = 0
        exact B_root_0_0_18
      · change rootTerm HB (0,0) (0,19) = 0
        exact B_root_0_0_19
      · change rootTerm HB (0,0) (0,20) = 0
        exact B_root_0_0_20
      · change rootTerm HB (0,0) (0,21) = 0
        exact B_root_0_0_21
      · change rootTerm HB (0,0) (0,22) = 0
        exact B_root_0_0_22
      · change rootTerm HB (0,0) (0,23) = 0
        exact B_root_0_0_23
    · fin_cases d
      · change rootTerm HB (0,0) (1,0) = 0
        exact B_root_0_1_0
      · change rootTerm HB (0,0) (1,1) = 0
        exact B_root_0_1_1
      · change rootTerm HB (0,0) (1,2) = 0
        exact B_root_0_1_2
      · change rootTerm HB (0,0) (1,3) = 0
        exact B_root_0_1_3
      · change rootTerm HB (0,0) (1,4) = 0
        exact B_root_0_1_4
      · change rootTerm HB (0,0) (1,5) = 0
        exact B_root_0_1_5
      · change rootTerm HB (0,0) (1,6) = 0
        exact B_root_0_1_6
      · change rootTerm HB (0,0) (1,7) = 0
        exact B_root_0_1_7
      · change rootTerm HB (0,0) (1,8) = 0
        exact B_root_0_1_8
      · change rootTerm HB (0,0) (1,9) = 0
        exact B_root_0_1_9
      · change rootTerm HB (0,0) (1,10) = 0
        exact B_root_0_1_10
      · change rootTerm HB (0,0) (1,11) = 0
        exact B_root_0_1_11
      · change rootTerm HB (0,0) (1,12) = 0
        exact B_root_0_1_12
      · change rootTerm HB (0,0) (1,13) = 0
        exact B_root_0_1_13
      · change rootTerm HB (0,0) (1,14) = 0
        exact B_root_0_1_14
      · change rootTerm HB (0,0) (1,15) = 0
        exact B_root_0_1_15
      · change rootTerm HB (0,0) (1,16) = 0
        exact B_root_0_1_16
      · change rootTerm HB (0,0) (1,17) = 0
        exact B_root_0_1_17
      · change rootTerm HB (0,0) (1,18) = 0
        exact B_root_0_1_18
      · change rootTerm HB (0,0) (1,19) = 0
        exact B_root_0_1_19
      · change rootTerm HB (0,0) (1,20) = 0
        exact B_root_0_1_20
      · change rootTerm HB (0,0) (1,21) = 0
        exact B_root_0_1_21
      · change rootTerm HB (0,0) (1,22) = 0
        exact B_root_0_1_22
      · change rootTerm HB (0,0) (1,23) = 0
        exact B_root_0_1_23
  · fin_cases q
    · fin_cases d
      · change rootTerm HB (1,0) (0,0) = 0
        exact B_root_1_0_0
      · change rootTerm HB (1,0) (0,1) = 0
        exact B_root_1_0_1
      · change rootTerm HB (1,0) (0,2) = 0
        exact B_root_1_0_2
      · change rootTerm HB (1,0) (0,3) = 0
        exact B_root_1_0_3
      · change rootTerm HB (1,0) (0,4) = 0
        exact B_root_1_0_4
      · change rootTerm HB (1,0) (0,5) = 0
        exact B_root_1_0_5
      · change rootTerm HB (1,0) (0,6) = 0
        exact B_root_1_0_6
      · change rootTerm HB (1,0) (0,7) = 0
        exact B_root_1_0_7
      · change rootTerm HB (1,0) (0,8) = 0
        exact B_root_1_0_8
      · change rootTerm HB (1,0) (0,9) = 0
        exact B_root_1_0_9
      · change rootTerm HB (1,0) (0,10) = 0
        exact B_root_1_0_10
      · change rootTerm HB (1,0) (0,11) = 0
        exact B_root_1_0_11
      · change rootTerm HB (1,0) (0,12) = 0
        exact B_root_1_0_12
      · change rootTerm HB (1,0) (0,13) = 0
        exact B_root_1_0_13
      · change rootTerm HB (1,0) (0,14) = 0
        exact B_root_1_0_14
      · change rootTerm HB (1,0) (0,15) = 0
        exact B_root_1_0_15
      · change rootTerm HB (1,0) (0,16) = 0
        exact B_root_1_0_16
      · change rootTerm HB (1,0) (0,17) = 0
        exact B_root_1_0_17
      · change rootTerm HB (1,0) (0,18) = 0
        exact B_root_1_0_18
      · change rootTerm HB (1,0) (0,19) = 0
        exact B_root_1_0_19
      · change rootTerm HB (1,0) (0,20) = 0
        exact B_root_1_0_20
      · change rootTerm HB (1,0) (0,21) = 0
        exact B_root_1_0_21
      · change rootTerm HB (1,0) (0,22) = 0
        exact B_root_1_0_22
      · change rootTerm HB (1,0) (0,23) = 0
        exact B_root_1_0_23
    · fin_cases d
      · change rootTerm HB (1,0) (1,0) = 0
        exact B_root_1_1_0
      · change rootTerm HB (1,0) (1,1) = 0
        exact B_root_1_1_1
      · change rootTerm HB (1,0) (1,2) = 2
        exact B_root_1_1_2
      · change rootTerm HB (1,0) (1,3) = 0
        exact B_root_1_1_3
      · change rootTerm HB (1,0) (1,4) = 0
        exact B_root_1_1_4
      · change rootTerm HB (1,0) (1,5) = 0
        exact B_root_1_1_5
      · change rootTerm HB (1,0) (1,6) = 0
        exact B_root_1_1_6
      · change rootTerm HB (1,0) (1,7) = 0
        exact B_root_1_1_7
      · change rootTerm HB (1,0) (1,8) = 2
        exact B_root_1_1_8
      · change rootTerm HB (1,0) (1,9) = 0
        exact B_root_1_1_9
      · change rootTerm HB (1,0) (1,10) = 2
        exact B_root_1_1_10
      · change rootTerm HB (1,0) (1,11) = 0
        exact B_root_1_1_11
      · change rootTerm HB (1,0) (1,12) = 0
        exact B_root_1_1_12
      · change rootTerm HB (1,0) (1,13) = 0
        exact B_root_1_1_13
      · change rootTerm HB (1,0) (1,14) = 2
        exact B_root_1_1_14
      · change rootTerm HB (1,0) (1,15) = 0
        exact B_root_1_1_15
      · change rootTerm HB (1,0) (1,16) = 2
        exact B_root_1_1_16
      · change rootTerm HB (1,0) (1,17) = 0
        exact B_root_1_1_17
      · change rootTerm HB (1,0) (1,18) = 0
        exact B_root_1_1_18
      · change rootTerm HB (1,0) (1,19) = 0
        exact B_root_1_1_19
      · change rootTerm HB (1,0) (1,20) = 0
        exact B_root_1_1_20
      · change rootTerm HB (1,0) (1,21) = 0
        exact B_root_1_1_21
      · change rootTerm HB (1,0) (1,22) = 2
        exact B_root_1_1_22
      · change rootTerm HB (1,0) (1,23) = 0
        exact B_root_1_1_23
theorem normalized_B : normalizedSum socketsB = 12 := by
  unfold normalizedSum
  simp_rw [show incidence socketsB = HB from rfl, root_B_eq_table]
  decide +kernel
theorem count_B : GlobalCounting.count42 HB = 72 := by
  have h := cyclic_count_identity socketsB cubic_B linear_B
  rw [normalized_B] at h
  change 4 * GlobalCounting.count42 HB = 24 * 12 at h
  exact Nat.eq_of_mul_eq_mul_left (n:=4) (by decide +kernel +kernel) h
#print axioms count_B
end GB48RootData
