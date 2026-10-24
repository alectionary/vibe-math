import HGPGramObstruction
import Mathlib.Data.ZMod.Basic
set_option maxHeartbeats 0
namespace HGPCSS
open HGPIncidence
open scoped BigOperators
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

def X (H1 : U → Finset C) (H2 : E → Finset D) (r : C × D)
    (v : Sum (U × D) (C × E)) : ZMod 2 := if r ∈ columns H1 H2 v then 1 else 0

def Z (H1 : U → Finset C) (H2 : E → Finset D) (r : U × E) :
    Sum (U × D) (C × E) → ZMod 2
  | .inl (u,a) => if r.1=u ∧ a ∈ H2 r.2 then 1 else 0
  | .inr (c,b) => if c ∈ H1 r.1 ∧ r.2=b then 1 else 0

theorem commute (H1 : U → Finset C) (H2 : E → Finset D) (r : C × D) (s : U × E) :
    ∑ v, X H1 H2 r v * Z H1 H2 s v = 0 := by
  rcases r with ⟨c,a⟩
  rcases s with ⟨u,b⟩
  have hl (v : U) (t : D) :
      X H1 H2 (c,a) (.inl (v,t)) * Z H1 H2 (u,b) (.inl (v,t)) =
      if v=u then (if t=a then (if c ∈ H1 u ∧ a ∈ H2 b then (1 : ZMod 2) else 0) else 0) else 0 := by
    by_cases hv : v=u
    · subst v
      by_cases ht : t=a
      · subst t; by_cases hc : c ∈ H1 u <;> by_cases ha : a ∈ H2 b <;> simp [X,Z,columns,hc,ha]
      · simp [X,Z,columns,ht,Ne.symm ht]
    · simp [X,Z,columns,hv,Ne.symm hv]
  have hr (d : C) (e : E) :
      X H1 H2 (c,a) (.inr (d,e)) * Z H1 H2 (u,b) (.inr (d,e)) =
      if d=c then (if e=b then (if c ∈ H1 u ∧ a ∈ H2 b then (1 : ZMod 2) else 0) else 0) else 0 := by
    by_cases hd : d=c
    · subst d
      by_cases he : e=b
      · subst e; by_cases hc : c ∈ H1 u <;> by_cases ha : a ∈ H2 b <;> simp [X,Z,columns,hc,ha]
      · simp [X,Z,columns,he,Ne.symm he]
    · simp [X,Z,columns,hd,Ne.symm hd]
  simp only [Fintype.sum_sum_type,Fintype.sum_prod_type]
  simp_rw [hl,hr]
  by_cases h : c ∈ H1 u ∧ a ∈ H2 b <;> simp [h] <;> decide

#print axioms commute
end HGPCSS
