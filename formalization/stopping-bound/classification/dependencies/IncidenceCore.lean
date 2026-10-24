module

public import Mathlib.Data.ZMod.Basic
public import Mathlib.Data.Finset.Card
public import Mathlib.Data.Fintype.Prod
public import Mathlib.Tactic.Push
public import Mathlib.Tactic.NormNum
public import Lean.Elab.Tactic.Omega

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false

namespace Incidence
variable {V C : Type*} [DecidableEq V] [DecidableEq C]

def Stopping (E : V → C → Prop) [DecidableRel E] (T : Finset V) : Prop :=
  T.Nonempty ∧ ∀ c, (T.filter (fun v => E v c)).card ≠ 1

lemma stopping_extension (E : V → C → Prop) [DecidableRel E]
    (T S : Finset V) (hT : Stopping E T) (hST : S ⊆ T)
    (c : C) (hc : (S.filter (fun v => E v c)).card = 1) :
    ∃ v ∈ T, v ∉ S ∧ E v c := by
  classical
  by_contra h
  push Not at h
  have heq : T.filter (fun v => E v c) = S.filter (fun v => E v c) := by
    ext v
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hv, he⟩
      exact ⟨by by_contra hn; exact h v hv hn he, he⟩
    · rintro ⟨hv, he⟩; exact ⟨hST hv, he⟩
  exact hT.2 c ((congrArg Finset.card heq).trans hc)

end Incidence

namespace Incidence
abbrev Check := ZMod 7 × ZMod 63
abbrev Var := Bool × Check

def col (v : Var) : List Check :=
  if v.1 then [(v.2.1,v.2.2), (v.2.1,v.2.2-1), (v.2.1,v.2.2-6)]
  else [(v.2.1,v.2.2+27), (v.2.1+1,v.2.2), (v.2.1+2,v.2.2+54)]

def E (v : Var) (c : Check) : Prop := c ∈ col v
instance : DecidableRel E := fun _ _ => inferInstanceAs (Decidable (_ ∈ _))

def row (c : Check) : List Var :=
  [(false,c.1,c.2-27), (false,c.1-1,c.2), (false,c.1-2,c.2-54),
   (true,c.1,c.2), (true,c.1,c.2+1), (true,c.1,c.2+6)]

lemma row_complete (v : Var) (c : Check) (h : E v c) : v ∈ row c := by
  rcases v with ⟨b,j,f⟩
  rcases c with ⟨i,g⟩
  cases b <;> simp only [E, col, Bool.false_eq_true, ↓reduceIte, List.mem_cons,
    List.not_mem_nil, or_false, Prod.mk.injEq] at h
  · rcases h with h | h | h
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
  · rcases h with h | h | h
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]
    · rcases h with ⟨rfl,rfl⟩; simp [row]

end Incidence

namespace Incidence

/-- Both cyclic coordinates translate the actual incidence graph. -/
def shiftV (t : Check) : Var ≃ Var where
  toFun v := (v.1,v.2.1+t.1,v.2.2+t.2)
  invFun v := (v.1,v.2.1-t.1,v.2.2-t.2)
  left_inv v := by simp
  right_inv v := by simp

def shiftC (t : Check) : Check ≃ Check where
  toFun c := (c.1+t.1,c.2+t.2)
  invFun c := (c.1-t.1,c.2-t.2)
  left_inv c := by simp
  right_inv c := by simp

lemma shift_incidence (t : Check) (v : Var) (c : Check) :
    E (shiftV t v) (shiftC t c) ↔ E v c := by
  have hcol : col (shiftV t v) = (col v).map (shiftC t) := by
    rcases v with ⟨b,j,f⟩
    cases b <;> simp [col,shiftV,shiftC,add_comm,add_left_comm,add_assoc,sub_eq_add_neg]
  change shiftC t c ∈ col (shiftV t v) ↔ c ∈ col v
  rw [hcol]
  simp only [List.mem_map, Equiv.apply_eq_iff_eq]
  simp

lemma stopping_image {V C : Type*} [DecidableEq V] [DecidableEq C] (E : V → C → Prop) [DecidableRel E]
    (e : V ≃ V) (f : C ≃ C) (he : ∀ v c, E (e v) (f c) ↔ E v c)
    (T : Finset V) (hT : Stopping E T) : Stopping E (T.image e) := by
  classical
  refine ⟨hT.1.image e, ?_⟩
  intro d
  obtain ⟨c,rfl⟩ := f.surjective d
  have heq : (T.image e).filter (fun v => E v (f c)) =
      (T.filter (fun v => E v c)).image e := by
    ext w
    simp only [Finset.mem_filter, Finset.mem_image]
    constructor
    · rintro ⟨⟨v,hv,rfl⟩,hvE⟩
      exact ⟨v,⟨hv,(he v c).mp hvE⟩,rfl⟩
    · rintro ⟨v,⟨hv,hvE⟩,rfl⟩
      exact ⟨⟨v,hv,rfl⟩,(he v c).mpr hvE⟩
  rw [heq, Finset.card_image_of_injective _ e.injective]
  exact hT.2 c

end Incidence
