import FamilyWords
import CyclicCover
import Mathlib.Logic.Relation
set_option maxHeartbeats 0
namespace FamilyConnected
variable {L : Nat} [NeZero L]
abbrev Var (L : Nat) := Fin 4 × ZMod L
abbrev Check (L : Nat) := Fin 3 × ZMod L
abbrev Vertex (L : Nat) := Var L ⊕ Check L

def e (i : Fin 3) (j : Fin 4) : ZMod L := FamilyWords.exponent i j
abbrev E := CyclicCover.Adjacent (e (L := L))
inductive Step : Vertex L → Vertex L → Prop
  | vc {v : Var L} {c : Check L} : E v c → Step (.inl v) (.inr c)
  | cv {v : Var L} {c : Check L} : E v c → Step (.inr c) (.inl v)
abbrev Reach := Relation.ReflTransGen (Step (L := L))

theorem via (v w : Var L) (c : Check L) (hv : E v c) (hw : E w c) :
    Reach (.inl v) (.inl w) :=
  (Relation.ReflTransGen.single (Step.vc hv)).trans
    (Relation.ReflTransGen.single (Step.cv hw))

theorem same_fiber (i j : Fin 4) (s : ZMod L) : Reach (.inl (i,s)) (.inl (j,s)) := by
  apply via (i,s) (j,s) (0,s) <;>
    fin_cases i <;> fin_cases j <;> simp [E,CyclicCover.Adjacent,e,FamilyWords.exponent]

theorem shift (s : ZMod L) : Reach (.inl (0,s)) (.inl (0,s+1)) := by
  apply (same_fiber 0 1 s).trans
  apply via (1,s) (0,s+1) (1,s+1) <;>
    norm_num [E,CyclicCover.Adjacent,e,FamilyWords.exponent]

theorem nat_shift (s : ZMod L) (n : Nat) : Reach (.inl (0,s)) (.inl (0,s+(n : ZMod L))) := by
  induction n with
  | zero => simpa using (Relation.ReflTransGen.refl : Reach (.inl (0,s)) (.inl (0,s)))
  | succ n ih => simpa [Nat.cast_succ,add_assoc] using ih.trans (shift (s+(n : ZMod L)))

theorem vars_connected (v w : Var L) : Reach (.inl v) (.inl w) := by
  have h := nat_shift v.2 (w.2-v.2).val
  rw [ZMod.natCast_zmod_val] at h
  simp only [add_sub_cancel] at h
  exact ((same_fiber v.1 0 v.2).trans h).trans (same_fiber 0 w.1 w.2)

theorem column_zero (c : Check L) : E (0,c.2) c := by
  rcases c with ⟨i,s⟩
  fin_cases i <;> norm_num [E,CyclicCover.Adjacent,e,FamilyWords.exponent]

/-- Every two vertices of the actual classical Tanner graph are joined by a walk. -/
theorem connected (a b : Vertex L) : Reach a b := by
  cases a with
  | inl v =>
    cases b with
    | inl w => exact vars_connected v w
    | inr c => exact (vars_connected v (0,c.2)).trans (.single (.vc (column_zero c)))
  | inr c =>
    cases b with
    | inl v => exact (Relation.ReflTransGen.single (.cv (column_zero c))).trans (vars_connected (0,c.2) v)
    | inr d => exact ((Relation.ReflTransGen.single (.cv (column_zero c))).trans
        (vars_connected (0,c.2) (0,d.2))).trans (.single (.vc (column_zero d)))

#print axioms connected
end FamilyConnected
