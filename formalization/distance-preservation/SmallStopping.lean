-- Generic search proof reused from the preceding stopping-bound project.
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Prod
import Mathlib.Tactic
set_option maxHeartbeats 0
namespace SmallStopping
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

end SmallStopping
namespace SmallStopping
variable {V C : Type*} [DecidableEq V] [DecidableEq C]
/-- List implementation avoids quotient sorting during kernel evaluation. -/
def survivesList (pick : List V → Option C) (row : C → List V) (n : ℕ) : List V → Bool :=
  Nat.rec (fun S => (pick S).isNone)
    (fun _ recur S => match pick S with
      | none => true
      | some c => (row c).any (fun v => bif decide (v ∈ S) then false else recur (v :: S))) n

theorem survivesList_of_stopping (E : V → C → Prop) [DecidableRel E]
    (pick : List V → Option C) (row : C → List V)
    (hp : ∀ S, S.Nodup → ∀ c, pick S = some c →
      (S.toFinset.filter (fun v => E v c)).card = 1)
    (hr : ∀ v c, E v c → v ∈ row c)
    (n : ℕ) (S : List V) (T : Finset V) (hT : Stopping E T)
    (hnd : S.Nodup) (hST : S.toFinset ⊆ T)
    (hcard : T.card ≤ S.length + n) : survivesList pick row n S = true := by
  induction n generalizing S with
  | zero =>
    have heq : S.toFinset = T := Finset.eq_of_subset_of_card_le hST (by
      rw [List.toFinset_card_of_nodup hnd]; omega)
    cases h : pick S with
    | none => simp [survivesList,h]
    | some c => exact False.elim (hT.2 c (by rw [← heq]; exact hp S hnd c h))
  | succ n ih =>
    cases h : pick S with
    | none => simp [survivesList,h]
    | some c =>
      obtain ⟨v,hvT,hvS,hvc⟩ := stopping_extension E T S.toFinset hT hST c (hp S hnd c h)
      have hvs : v ∉ S := by simpa using hvS
      simp only [survivesList,h,List.any_eq_true]
      refine ⟨v,hr v c hvc,?_⟩
      simp only [hvs, decide_false, Bool.cond_false]
      apply ih (v :: S) (List.nodup_cons.mpr ⟨hvs,hnd⟩)
      · simpa using Finset.insert_subset hvT hST
      · simp only [List.length_cons]; omega


end SmallStopping
