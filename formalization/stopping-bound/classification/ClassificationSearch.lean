module
public import IncidenceList
@[expose] public section
set_option linter.unusedSectionVars false
namespace Incidence
variable {V C : Type*} [DecidableEq V] [DecidableEq C]

/-- All extensions either cannot stop at the target size or have the requested form.
A premature stop rejects this certificate; no unstated minimality premise is needed. -/
def classifiesList (pick : List V → Option C) (row : C → List V)
    (good : List V → Bool) (n : ℕ) : List V → Bool :=
  Nat.rec (fun S => match pick S with | none => good S | some _ => true)
    (fun _ recur S => match pick S with
      | none => false
      | some c => (row c).all (fun v => bif decide (v ∈ S) then true else recur (v :: S))) n

theorem classifiesList_succ (pick : List V → Option C) (row : C → List V)
    (good : List V → Bool) (n : ℕ) (S : List V) :
    classifiesList pick row good (n+1) S =
      (match pick S with
        | none => false
        | some c => (row c).all (fun v => bif decide (v ∈ S) then true
          else classifiesList pick row good n (v :: S))) := by rfl

theorem classifiesList_step_of_children
    (pick : List V → Option C) (row : C → List V) (good : List V → Bool)
    (n : ℕ) (S : List V) (c : C) (hp : pick S = some c)
    (hc : ∀ v ∈ row c, v ∉ S → classifiesList pick row good n (v :: S) = true) :
    classifiesList pick row good (n+1) S = true := by
  rw [classifiesList_succ,hp]
  apply List.all_eq_true.mpr
  intro v hv
  by_cases hm : v ∈ S
  · simp only [hm,decide_true,Bool.cond_true]
  · simpa only [hm,decide_false,Bool.cond_false] using hc v hv hm

theorem classifiesList_sound (E : V → C → Prop) [DecidableRel E]
    (pick : List V → Option C) (row : C → List V) (good : List V → Bool)
    (P : Finset V → Prop)
    (hp : ∀ S, S.Nodup → ∀ c, pick S = some c →
      (S.toFinset.filter (fun v => E v c)).card = 1)
    (hr : ∀ v c, E v c → v ∈ row c)
    (hg : ∀ S, S.Nodup → good S = true → P S.toFinset)
    (n : ℕ) (S : List V) (T : Finset V) (hT : Stopping E T)
    (hnd : S.Nodup) (hST : S.toFinset ⊆ T)
    (hcard : T.card ≤ S.length+n)
    (hcert : classifiesList pick row good n S = true) : P T := by
  induction n generalizing S with
  | zero =>
    have heq : S.toFinset = T := Finset.eq_of_subset_of_card_le hST (by
      rw [List.toFinset_card_of_nodup hnd]; omega)
    cases h : pick S with
    | none =>
      rw [← heq]
      apply hg S hnd
      simpa [classifiesList,h] using hcert
    | some c =>
      exact False.elim (hT.2 c (by rw [← heq]; exact hp S hnd c h))
  | succ n ih =>
    cases h : pick S with
    | none => simp [classifiesList,h] at hcert
    | some c =>
      obtain ⟨v,hvT,hvS,hvc⟩ := stopping_extension E T S.toFinset hT hST c (hp S hnd c h)
      have hvs : v ∉ S := by simpa using hvS
      simp only [classifiesList,h,List.all_eq_true] at hcert
      have hc := hcert v (hr v c hvc)
      simp only [hvs,decide_false,Bool.cond_false] at hc
      apply ih (v :: S) (List.nodup_cons.mpr ⟨hvs,hnd⟩)
      · simpa using Finset.insert_subset hvT hST
      · simp only [List.length_cons]; omega
      · exact hc
end Incidence
