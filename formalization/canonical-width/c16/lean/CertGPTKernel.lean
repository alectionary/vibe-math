import Std
/-!
Generic, executable certificate-tree kernel. This module proves ONLY the generic
search recursion sound. The obligations in `RulesSound` must be proved from the
concrete frame mathematics before this yields a no-frame theorem.

Every C/K child must pass `eligible`; this allows the concrete implementation
to require that the item is still live, not previously chosen.

No shard support: S records and F records always reject. A successful call also
requires positive `need` and sufficient fuel. Child order is significant: each
previous item is appended to `done`, including K children.
-/

namespace C16Frames.CertGPT

inductive Tree (Item Entry : Type) where
  | rank
  | empty (entry : Entry)
  | branch (entry : Entry) (children : List (Item × Option (Tree Item Entry)))
  | shard
  | frame

structure Rules (State Item Entry : Type) where
  need : State → Nat
  rankOk : State → Bool
  emptyOk : State → Entry → Bool
  branchOk : State → Entry → List Item → Bool
  eligible : State → Item → Bool
  tooLarge : State → Item → Bool
  next : State → List Item → Item → State

/-- A missing subtree denotes K. S is deliberately not represented by K. -/
def checkChildren {State Item Entry : Type} (rules : Rules State Item Entry)
    (run : State → Tree Item Entry → Bool) (s : State) :
    List Item → List (Item × Option (Tree Item Entry)) → Bool
  | _, [] => true
  | done, (q, child) :: rest =>
      rules.eligible s q && ((match child with
       | none => rules.tooLarge s q
       | some t => run (rules.next s done q) t) &&
      checkChildren rules run s (done ++ [q]) rest)

/-- Fuel only limits resource use: exhaustion rejects, never accepts. -/
def check {State Item Entry : Type} (rules : Rules State Item Entry) :
    Nat → State → Tree Item Entry → Bool
  | 0, _, _ => false
  | fuel + 1, s, t =>
      if rules.need s == 0 then false else
      match t with
      | .rank => rules.rankOk s
      | .empty e => rules.emptyOk s e
      | .branch e children =>
          rules.branchOk s e (children.map Prod.fst) &&
          checkChildren rules (check rules fuel) s [] children
      | .shard => false
      | .frame => false

/-- Semantic obligations for a concrete implementation. These are hypotheses,
not axioms. In particular `branch_cover` must establish residual coverage and
`next_sound` must establish disjointness, orthogonality and residual updates. -/
structure RulesSound {State Item Entry Frame : Type}
    (rules : Rules State Item Entry) (Completes : State → Frame → Prop)
    (Contains : Frame → Item → Prop) : Prop where
  rank_sound : ∀ s f, Completes s f → rules.rankOk s = true → False
  empty_sound : ∀ s f e, Completes s f → rules.emptyOk s e = true → False
  branch_cover : ∀ s f e qs, Completes s f → rules.branchOk s e qs = true →
    ∃ q, q ∈ qs ∧ Contains f q
  large_sound : ∀ s f q, Completes s f → Contains f q → rules.eligible s q = true →
    rules.tooLarge s q = true → False
  next_sound : ∀ s f done q, Completes s f → Contains f q → rules.eligible s q = true →
    (∀ r, r ∈ done → ¬ Contains f r) → ∃ f', Completes (rules.next s done q) f'

private theorem checkChildren_sound {State Item Entry Frame : Type}
    (rules : Rules State Item Entry) (Completes : State → Frame → Prop)
    (Contains : Frame → Item → Prop) (sound : RulesSound rules Completes Contains)
    (run : State → Tree Item Entry → Bool)
    (run_sound : ∀ s t f, run s t = true → Completes s f → False)
    (s : State) (f : Frame) (hf : Completes s f) :
    ∀ (children : List (Item × Option (Tree Item Entry))) (done : List Item),
      (∀ r, r ∈ done → ¬ Contains f r) →
      checkChildren rules run s done children = true →
      (∃ q, q ∈ children.map Prod.fst ∧ Contains f q) → False := by
  intro children
  induction children with
  | nil =>
      intro done hd hc hex
      simp at hex
  | cons head rest ih =>
      rcases head with ⟨q, child⟩
      intro done hd hc hex
      have eligibleAndChecks := Bool.and_eq_true_iff.mp hc
      have he := eligibleAndChecks.1
      have checks := Bool.and_eq_true_iff.mp eligibleAndChecks.2
      by_cases hq : Contains f q
      · cases child with
        | none => exact sound.large_sound s f q hf hq he checks.1
        | some t =>
            obtain ⟨f', hf'⟩ := sound.next_sound s f done q hf hq he hd
            exact run_sound (rules.next s done q) t f' checks.1 hf'
      · apply ih (done ++ [q])
        · intro r hr
          rcases List.mem_append.mp hr with hr | hr
          · exact hd r hr
          · have heq : r = q := List.mem_singleton.mp hr
            simpa [heq] using hq
        · exact checks.2
        · rcases hex with ⟨r, hr, hrf⟩
          refine ⟨r, ?_, hrf⟩
          have hm : r = q ∨ r ∈ rest.map Prod.fst := by simpa using hr
          rcases hm with heq | hm
          · exact False.elim (hq (heq ▸ hrf))
          · exact hm

/-- Acceptance excludes every semantic completion, for arbitrary fuel and data.
Instantiating this theorem requires a proof of every `RulesSound` field. -/
theorem check_sound {State Item Entry Frame : Type}
    (rules : Rules State Item Entry) (Completes : State → Frame → Prop)
    (Contains : Frame → Item → Prop) (sound : RulesSound rules Completes Contains)
    (fuel : Nat) (s : State) (t : Tree Item Entry) (f : Frame)
    (accepted : check rules fuel s t = true) : ¬ Completes s f := by
  induction fuel generalizing s t f with
  | zero => simp [check] at accepted
  | succ fuel ih =>
      intro hf
      simp only [check] at accepted
      split at accepted
      · contradiction
      · cases t with
        | rank => exact sound.rank_sound s f hf accepted
        | empty e => exact sound.empty_sound s f e hf accepted
        | shard => contradiction
        | frame => contradiction
        | branch e children =>
            have checks := Bool.and_eq_true_iff.mp accepted
            exact checkChildren_sound rules Completes Contains sound (check rules fuel)
              (fun s t f hc hf => ih s t f hc hf) s f hf children []
              (by simp) checks.2 (sound.branch_cover s f e _ hf checks.1)

/-- Root-level form suitable for instantiation after all semantic bridges are proved. -/
theorem check_no_completion {State Item Entry Frame : Type}
    (rules : Rules State Item Entry) (Completes : State → Frame → Prop)
    (Contains : Frame → Item → Prop) (sound : RulesSound rules Completes Contains)
    (fuel : Nat) (s : State) (t : Tree Item Entry)
    (accepted : check rules fuel s t = true) : ¬ ∃ f, Completes s f := by
  rintro ⟨f, hf⟩
  exact check_sound rules Completes Contains sound fuel s t f accepted hf

/-- Found-frame records cannot certify nonexistence. -/
theorem check_frame_rejects {State Item Entry : Type} (rules : Rules State Item Entry)
    (fuel : Nat) (s : State) : check rules fuel s .frame = false := by
  cases fuel <;> simp [check]

/-- Skipped shards cannot certify nonexistence on their own. -/
theorem check_shard_rejects {State Item Entry : Type} (rules : Rules State Item Entry)
    (fuel : Nat) (s : State) : check rules fuel s .shard = false := by
  cases fuel <;> simp [check]

/-- A complete chosen frame is never accepted as a no-frame certificate. -/
theorem check_zero_need_rejects {State Item Entry : Type} (rules : Rules State Item Entry)
    (fuel : Nat) (s : State) (t : Tree Item Entry) (h : rules.need s = 0) :
    check rules fuel s t = false := by
  cases fuel <;> simp [check, h]

/- Operational regression tests only. These mock rules are not a frame model,
and no `RulesSound` instance is claimed for them. -/
private def mockRules : Rules Nat Nat Nat where
  need := id
  rankOk := fun s => s == 1
  emptyOk := fun _ e => e == 7
  branchOk := fun _ e qs => e == 7 && qs == [3, 4]
  eligible := fun _ q => q == 3 || q == 4
  tooLarge := fun s q => s < q
  next := fun _ done _ => if done.isEmpty then 1 else 2

private def mockTree : Tree Nat Nat :=
  .branch 7 [(3, some .rank), (4, some (.empty 7))]

example : checkChildren mockRules (fun _ _ => true) 1 [] [(9, none)] = false := by decide
example : check mockRules 2 5 mockTree = true := by decide
example : check mockRules 1 5 mockTree = false := by decide
example : check mockRules 0 5 mockTree = false := by decide
example : check mockRules 2 0 mockTree = false := by decide
example : check mockRules 2 5 (.branch 7 [(3, some .rank)]) = false := by decide
example : check mockRules 2 5 (.branch 7 [(3, none), (4, some (.empty 7))]) = false := by
  decide
example : check mockRules 2 5 (.branch 7 [(3, some .rank), (4, some .rank)]) = false := by
  decide
example : check mockRules 2 5 (.branch 7 [(3, some .rank), (4, some .shard)]) = false := by
  decide
example : check mockRules 2 5 (.branch 7 [(3, some .rank), (4, some .frame)]) = false := by
  decide

#print axioms check_sound
#print axioms check_no_completion

end C16Frames.CertGPT
