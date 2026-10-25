import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.BooleanAlgebra
import Mathlib.Data.Finset.SymmDiff
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace CircuitSearch
variable {V C : Type*} [DecidableEq V] [DecidableEq C]

def EvenChecks (E : V → C → Prop) [DecidableRel E] (T : Finset V) : Prop :=
  ∀ c, (T.filter (fun v => E v c)).card % 2 = 0

def Circuit (E : V → C → Prop) [DecidableRel E] (T : Finset V) : Prop :=
  T.Nonempty ∧ EvenChecks E T ∧
    ∀ U, U ⊆ T → U.Nonempty → EvenChecks E U → U = T

theorem odd_extension (E : V → C → Prop) [DecidableRel E]
    (S T : Finset V) (hST : S ⊆ T) (hT : EvenChecks E T) (c : C)
    (hodd : (S.filter (fun v => E v c)).card % 2 = 1) :
    ∃ v, v ∈ T ∧ v ∉ S ∧ E v c := by
  by_contra hn
  have he : T.filter (fun v => E v c) = S.filter (fun v => E v c) := by
    ext v
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hv,he⟩
      exact ⟨by by_contra hs; exact hn ⟨v,hv,hs,he⟩,he⟩
    · rintro ⟨hv,he⟩; exact ⟨hST hv,he⟩
  have hz := hT c
  rw [he,hodd] at hz
  contradiction

/-- An executable complete circuit search; a closed support is checked at every depth. -/
def certifies (pick : List V → Option C) (row : C → List V)
    (good : List V → Bool) (n : Nat) : List V → Bool :=
  Nat.rec (fun S => match pick S with | none => good S | some _ => true)
    (fun _ recur S => match pick S with
      | none => good S
      | some c => (row c).all (fun v => if v ∈ S then true else recur (v :: S))) n

theorem certifies_sound (E : V → C → Prop) [DecidableRel E]
    (pick : List V → Option C) (row : C → List V) (good : List V → Bool)
    (P : Finset V → Prop)
    (hp : ∀ S, S.Nodup → ∀ c, pick S = some c →
      (S.toFinset.filter (fun v => E v c)).card % 2 = 1)
    (hz : ∀ S, S.Nodup → pick S = none → EvenChecks E S.toFinset)
    (hr : ∀ v c, E v c → v ∈ row c)
    (hg : ∀ S, S.Nodup → good S = true → P S.toFinset)
    (n : Nat) (S : List V) (T : Finset V) (hT : Circuit E T)
    (hnd : S.Nodup) (hne : S ≠ []) (hST : S.toFinset ⊆ T)
    (hcard : T.card ≤ S.length+n) (hcert : certifies pick row good n S = true) : P T := by
  induction n generalizing S with
  | zero =>
    have heq : S.toFinset = T := Finset.eq_of_subset_of_card_le hST (by
      rw [List.toFinset_card_of_nodup hnd]; omega)
    cases h : pick S with
    | none =>
      rw [← heq]
      apply hg S hnd
      simpa [certifies,h] using hcert
    | some c =>
      have ho := hp S hnd c h
      have he := hT.2.1 c
      rw [← heq,ho] at he
      contradiction
  | succ n ih =>
    cases h : pick S with
    | none =>
      have hsne : S.toFinset.Nonempty := by
        obtain ⟨a,as,rfl⟩ := List.exists_cons_of_ne_nil hne
        exact ⟨a,by simp⟩
      have heq := hT.2.2 S.toFinset hST hsne (hz S hnd h)
      rw [← heq]
      apply hg S hnd
      simpa [certifies,h] using hcert
    | some c =>
      obtain ⟨v,hvT,hvS,hvc⟩ := odd_extension E S.toFinset T hST hT.2.1 c (hp S hnd c h)
      have hvs : v ∉ S := by simpa using hvS
      simp only [certifies,h,List.all_eq_true] at hcert
      have hc := hcert v (hr v c hvc)
      simp only [hvs, ↓reduceIte] at hc
      apply ih (v :: S) (List.nodup_cons.mpr ⟨hvs,hnd⟩) (by simp)
      · simpa using Finset.insert_subset hvT hST
      · simp only [List.length_cons]; omega
      · exact hc

#print axioms certifies_sound
end CircuitSearch
