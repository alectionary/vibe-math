import CyclicRecurrence
import Mathlib.Logic.Equiv.Fin.Basic

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace ScalarWeight
open CyclicRecurrence

variable (q : ℕ) [NeZero q]

def grid (a : Fin q × Fin 7) : ZMod (7*q) :=
  ((a.2.val+7*a.1.val : ℕ) : ZMod (7*q))

theorem grid_lt (a : Fin q × Fin 7) : a.2.val+7*a.1.val<7*q := by
  have := a.1.isLt
  have := a.2.isLt
  omega

theorem grid_injective : Function.Injective (grid q) := by
  rintro ⟨s,r⟩ ⟨t,u⟩ h
  have hs := ZMod.val_natCast_of_lt (grid_lt q (s,r))
  have ht := ZMod.val_natCast_of_lt (grid_lt q (t,u))
  have he := congrArg ZMod.val h
  change (((r.val+7*s.val : ℕ) : ZMod (7*q))).val=
    (((u.val+7*t.val : ℕ) : ZMod (7*q))).val at he
  rw [hs,ht] at he
  have hr := r.isLt
  have hu := u.isLt
  exact Prod.ext (Fin.ext (by omega)) (Fin.ext (by omega))

theorem grid_surjective : Function.Surjective (grid q) := by
  intro t
  have ht := ZMod.val_lt t
  let s : Fin q := ⟨t.val/7,by omega⟩
  let r : Fin 7 := ⟨t.val%7,Nat.mod_lt _ (by decide)⟩
  refine ⟨(s,r),?_⟩
  change (((t.val%7+7*(t.val/7) : ℕ) : ZMod (7*q)))=t
  rw [Nat.mod_add_div,ZMod.natCast_zmod_val]

noncomputable def gridEquiv : Fin q × Fin 7 ≃ ZMod (7*q) :=
  Equiv.ofBijective (grid q) ⟨grid_injective q,grid_surjective q⟩

theorem grid_mod_seven (a : Fin q × Fin 7) :
    ZMod.castHom (dvd_mul_right 7 q) (ZMod 7) (grid q a)=(a.2.val : ZMod 7) := by
  change (ZMod.castHom (dvd_mul_right 7 q) (ZMod 7))
    ((a.2.val+7*a.1.val : ℕ) : ZMod (7*q))=_
  rw [map_natCast,Nat.cast_add,Nat.cast_mul]
  have hz : (7 : ZMod 7)=0 := by decide
  simp only [Nat.cast_ofNat]
  rw [hz,zero_mul,add_zero]

theorem pattern_weight : ∀ a : Fin 3 → F, a≠0 →
    (Finset.univ.filter (fun r : Fin 7 => pattern a (r.val : ZMod 7)≠0)).card=4 := by decide

theorem kernel_value (f : ZMod (7*q) → F) (hf : ScalarCondition (7*q) f)
    (a : Fin q × Fin 7) :
    f (grid q a)=pattern (fun i : Fin 3 => f (i.val : ZMod (7*q))) (a.2.val : ZMod 7) := by
  have he := congrFun (kernel_unique (7*q) (dvd_mul_right 7 q) f hf) (grid q a)
  change f (grid q a)=pattern _ ((ZMod.castHom (dvd_mul_right 7 q) (ZMod 7)) (grid q a)) at he
  rw [grid_mod_seven] at he
  exact he

/-- Every nonzero scalar kernel word has weight four per seven-coordinate block. -/
theorem kernel_weight (f : ZMod (7*q) → F) (hf : ScalarCondition (7*q) f) (hn : f≠0) :
    Nat.card {t : ZMod (7*q) // f t≠0}=4*q := by
  classical
  let a : Fin 3 → F := fun i => f (i.val : ZMod (7*q))
  have ha : a≠0 := by
    intro ha
    apply hn
    funext t
    have he := congrFun (kernel_unique (7*q) (dvd_mul_right 7 q) f hf) t
    change f t=pattern a ((ZMod.castHom (dvd_mul_right 7 q) (ZMod 7)) t) at he
    rw [ha] at he
    have hz : ∀ r : ZMod 7, pattern (0 : Fin 3 → F) r=0 := by decide
    exact he.trans (hz _)
  let e1 : {t : ZMod (7*q) // f t≠0} ≃
      {p : Fin q × Fin 7 // pattern a (p.2.val : ZMod 7)≠0} :=
    (Equiv.subtypeEquiv (gridEquiv q) (fun p => by
      change pattern a (p.2.val : ZMod 7)≠0 ↔ f (grid q p)≠0
      rw [kernel_value q f hf])).symm
  let e2 : {p : Fin q × Fin 7 // pattern a (p.2.val : ZMod 7)≠0} ≃
      Fin q × {r : Fin 7 // pattern a (r.val : ZMod 7)≠0} := {
    toFun := fun p => (p.val.1,⟨p.val.2,p.prop⟩)
    invFun := fun p => ⟨(p.1,p.2.val),p.2.prop⟩
    left_inv := fun _ => rfl
    right_inv := fun _ => rfl }
  rw [Nat.card_congr (e1.trans e2),Nat.card_eq_fintype_card,Fintype.card_prod,
    Fintype.card_fin,Fintype.card_subtype,pattern_weight a ha,Nat.mul_comm]

#print axioms gridEquiv
#print axioms pattern_weight
#print axioms kernel_weight
end ScalarWeight
