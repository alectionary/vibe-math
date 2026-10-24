import IncidenceList
import PartitionBound
import Mathlib.Tactic.Linarith
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace Bicycle
abbrev Check := ZMod 39
abbrev Var := Bool × Check

def col (v : Var) : List Check :=
  if v.1 then [v.2,v.2-1,v.2-4,v.2-6] else [v.2,v.2+1,v.2+4,v.2+6]
def E (v : Var) (c : Check) : Prop := c ∈ col v
instance : DecidableRel E := fun _ _ => inferInstanceAs (Decidable (_ ∈ _))
def row (c : Check) : List Var :=
  [(false,c),(false,c-1),(false,c-4),(false,c-6),
   (true,c),(true,c+1),(true,c+4),(true,c+6)]
lemma row_complete (v : Var) (c : Check) (h : E v c) : v ∈ row c := by
  rcases v with ⟨b,j⟩
  cases b <;> simp only [E,col,Bool.false_eq_true,↓reduceIte,List.mem_cons,
    List.not_mem_nil,or_false] at h
  all_goals rcases h with h | h | h | h
  all_goals subst c
  all_goals simp [row,sub_eq_add_neg,add_assoc,add_comm,add_left_comm]

def pick (S : List Var) : Option Check :=
  (S.flatMap col).find? (fun c => (S.countP (fun v => E v c)) == 1)
lemma pick_singleton (S : List Var) (hn : S.Nodup) (c : Check) (h : pick S = some c) :
    (S.toFinset.filter (fun v => E v c)).card = 1 := by
  rw [hn.card_eq_countP]
  have := List.find?_some h
  simpa using this

def shiftV (t : Check) : Var ≃ Var where
  toFun v := (v.1,v.2+t)
  invFun v := (v.1,v.2-t)
  left_inv v := by simp
  right_inv v := by simp

def shiftC (t : Check) : Check ≃ Check where
  toFun c := c+t
  invFun c := c-t
  left_inv c := by simp
  right_inv c := by simp
lemma shift_incidence (t : Check) (v : Var) (c : Check) :
    E (shiftV t v) (shiftC t c) ↔ E v c := by
  have hcol : col (shiftV t v) = (col v).map (shiftC t) := by
    rcases v with ⟨b,j⟩
    cases b <;> simp [col,shiftV,shiftC,add_comm,add_left_comm,add_assoc,sub_eq_add_neg]
  change shiftC t c ∈ col (shiftV t v) ↔ c ∈ col v
  rw [hcol]
  simp only [List.mem_map,Equiv.apply_eq_iff_eq]
  simp

end Bicycle
