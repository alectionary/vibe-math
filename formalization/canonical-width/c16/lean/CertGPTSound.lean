import CertGPTCheck

/-!
Residual algebra and live-item transition lemmas for the executable checker.
These are proved facts about its Boolean operations, not an assumption that
accepted trees are sound. The frame-to-residual invariant, bit-vector/matrix
rank bridge, and complete `RulesSound` instance remain separate obligations.
-/
namespace C16Frames.CertGPT

/-- Sum over F₂, represented by Boolean exclusive-or. -/
def paritySum {α : Type} (f : α → Bool) : List α → Bool
  | [] => false
  | a :: as => f a != paritySum f as

private theorem xor_assoc (a b c : Bool) : ((a != b) != c) = (a != (b != c)) := by
  cases a <;> cases b <;> cases c <;> decide

private theorem xor_cancel_left (a b : Bool) : (a != (a != b)) = b := by
  cases a <;> cases b <;> decide

/-- Executable accumulator fold computes the mathematical Boolean sum. -/
theorem foldl_xor_eq {α : Type} (f : α → Bool) (xs : List α) (b : Bool) :
    xs.foldl (fun acc a => acc != f a) b = (b != paritySum f xs) := by
  induction xs generalizing b with
  | nil => cases b <;> rfl
  | cons a as ih =>
      simp only [List.foldl_cons, paritySum, ih]
      exact xor_assoc b (f a) (paritySum f as)

/-- Item contribution `cov` is precisely the parity sum of its outer entries. -/
theorem cov_eq_paritySum (d : Instance) (q c k : Nat) :
    cov d q c k = paritySum
      (fun p : Pair => bit d.x[p.1]! c && bit d.z[p.2]! k) d.items[q]!.toList := by
  unfold cov
  rw [← Array.foldl_toList, foldl_xor_eq]
  cases paritySum (fun p : Pair => bit d.x[p.1]! c && bit d.z[p.2]! k)
    d.items[q]!.toList <;> rfl

theorem paritySum_append {α : Type} (f : α → Bool) (xs ys : List α) :
    paritySum f (xs ++ ys) = (paritySum f xs != paritySum f ys) := by
  induction xs with
  | nil => simp [paritySum]
  | cons a as ih =>
      simp only [List.cons_append, paritySum, ih]
      exact (xor_assoc (f a) (paritySum f as) (paritySum f ys)).symm

/-- Residual sums depend on the remaining set, not its enumeration order. -/
theorem paritySum_perm {α : Type} (f : α → Bool) {xs ys : List α}
    (h : xs.Perm ys) : paritySum f xs = paritySum f ys := by
  induction h with
  | nil => rfl
  | cons a h ih => simp only [paritySum, ih]
  | swap a b xs =>
      simp only [paritySum]
      cases f a <;> cases f b <;> cases paritySum f xs <;> rfl
  | trans h₁ h₂ ih₁ ih₂ => exact ih₁.trans ih₂

/-- A nonzero residual entry has a contributing remaining item. -/
theorem exists_of_paritySum_true {α : Type} (f : α → Bool) (xs : List α)
    (h : paritySum f xs = true) : ∃ a, a ∈ xs ∧ f a = true := by
  induction xs with
  | nil => contradiction
  | cons a as ih =>
      by_cases ha : f a = true
      · exact ⟨a, by simp, ha⟩
      · have haf : f a = false := Bool.eq_false_iff.mpr ha
        have hs : paritySum f as = true := by simpa [paritySum, haf] using h
        obtain ⟨b, hb, hbf⟩ := ih hs
        exact ⟨b, by simp [hb], hbf⟩

/-- Exact cardinality plus inclusion and no duplicates gives reverse coverage.
No duplicate-freeness assumption is needed for the covering list. -/
theorem list_coverage_of_length {α : Type} (qs covering : List α)
    (hnd : qs.Nodup) (hsub : ∀ q, q ∈ qs → q ∈ covering)
    (hlen : qs.length = covering.length) : ∀ q, q ∈ covering → q ∈ qs := by
  intro q hq
  classical
  apply Classical.byContradiction
  intro hn
  have hnd' : (q :: qs).Nodup := List.nodup_cons.mpr ⟨hn, hnd⟩
  have hsub' : q :: qs ⊆ covering := by
    intro r hr
    rcases List.mem_cons.mp hr with rfl | hr
    · exact hq
    · exact hsub r hr
  have h := hnd'.length_le_of_subset hsub'
  simp only [List.length_cons] at h
  omega

/-- The exact E/B covering list contains a remaining item whenever the residual
invariant holds. The invariant is an algebraic equality, not no-completion. -/
theorem residual_coverage (d : Instance) (s : SearchState) (c k : Nat)
    (remaining : List Nat)
    (hlive : ∀ q, q ∈ remaining → q ∈ s.live)
    (hresidual : bit s.residual[c]! k = paritySum (fun q => cov d q c k) remaining)
    (hentry : bit s.residual[c]! k = true) :
    ∃ q, q ∈ remaining ∧ q ∈ s.live.filter (fun q => cov d q c k) := by
  obtain ⟨q, hq, hcov⟩ := exists_of_paritySum_true (fun q => cov d q c k) remaining
    (hresidual ▸ hentry)
  exact ⟨q, hq, Array.mem_filter.mpr ⟨hlive q hq, hcov⟩⟩

/-- Empty-leaf rejection of any completion whose residual invariant holds. -/
theorem empty_contradiction (d : Instance) (s : SearchState) (c k : Nat)
    (remaining : List Nat)
    (hlive : ∀ q, q ∈ remaining → q ∈ s.live)
    (hresidual : bit s.residual[c]! k = paritySum (fun q => cov d q c k) remaining)
    (hentry : bit s.residual[c]! k = true)
    (hempty : (s.live.filter (fun q => cov d q c k)).isEmpty = true) : False := by
  obtain ⟨q, _, hq⟩ := residual_coverage d s c k remaining hlive hresidual hentry
  have heq : s.live.filter (fun q => cov d q c k) = #[] := Array.isEmpty_iff.mp hempty
  simp [heq] at hq

/-- Removing the chosen first contribution updates the residual by XOR. -/
theorem residual_remove_head {α : Type} (f : α → Bool) (q : α) (rest : List α)
    (r : Bool) (h : r = paritySum f (q :: rest)) :
    (r != f q) = paritySum f rest := by
  rw [h, paritySum]
  cases f q <;> cases paritySum f rest <;> rfl

/-- XORing the chosen item removes it from an arbitrary enumeration. -/
theorem residual_remove_member {α : Type} [BEq α] [LawfulBEq α]
    (f : α → Bool) (q : α) (remaining : List α) (r : Bool)
    (hq : q ∈ remaining) (h : r = paritySum f remaining) :
    (r != f q) = paritySum f (remaining.erase q) := by
  apply residual_remove_head f q (remaining.erase q) r
  exact h.trans (paritySum_perm f (List.perm_cons_erase hq))

/-- Item sizes in a completion sum to its remaining cardinality. -/
def pairCount (d : Instance) (remaining : List Nat) : Nat :=
  ((remaining.map fun q => d.items[q]!.size)).sum

theorem pairCount_perm (d : Instance) {xs ys : List Nat} (h : xs.Perm ys) :
    pairCount d xs = pairCount d ys := by
  induction h with
  | nil => rfl
  | cons a h ih => simpa [pairCount] using congrArg (d.items[a]!.size + ·) ih
  | swap a b xs => simp [pairCount, Nat.add_left_comm]
  | trans h₁ h₂ ih₁ ih₂ => exact ih₁.trans ih₂

/-- Removing a selected item subtracts exactly its number of pairs. -/
theorem pairCount_erase (d : Instance) (remaining : List Nat) (q : Nat)
    (hq : q ∈ remaining) :
    pairCount d (remaining.erase q) = pairCount d remaining - d.items[q]!.size := by
  have h := pairCount_perm d (List.perm_cons_erase hq)
  have hs : pairCount d remaining = d.items[q]!.size + pairCount d (remaining.erase q) := by
    simpa [pairCount] using h
  omega

/-- Any selected item fits the remaining pair count. This is the K-leaf argument. -/
theorem item_size_le_pairCount (d : Instance) (remaining : List Nat) (q : Nat)
    (hq : q ∈ remaining) : d.items[q]!.size ≤ pairCount d remaining := by
  induction remaining with
  | nil => simp at hq
  | cons a rest ih =>
      rcases List.mem_cons.mp hq with h | h
      · subst q
        simp [pairCount]
      · have hle := ih h
        simp only [pairCount, List.map_cons, List.sum_cons] at *
        omega

/-- Rejecting an oversized selected item is justified by cardinality alone. -/
theorem oversized_contradiction (d : Instance) (s : SearchState)
    (remaining : List Nat) (q : Nat) (hq : q ∈ remaining)
    (hcount : pairCount d remaining = s.need) (hlarge : s.need < d.items[q]!.size) : False := by
  have hle := item_size_le_pairCount d remaining q hq
  omega

/-- The live-item field is precisely the checked compatibility filter. -/
theorem childState_live (d : Instance) (s : SearchState) (q : Nat) (done : Array Nat) :
    (childState d s q done).live = s.live.filter (fun a => a != q && !done.contains a &&
      d.items[a]!.all (fun p => d.items[q]!.all fun t =>
        p.1 != t.1 && p.2 != t.2 && !gram d p.1 t.2 && !gram d t.1 p.2)) := by
  rfl

theorem childState_need (d : Instance) (s : SearchState) (q : Nat) (done : Array Nat) :
    (childState d s q done).need = s.need - d.items[q]!.size := rfl

/-- Cardinality invariant is preserved by the actual child's subtraction. -/
theorem child_pairCount (d : Instance) (s : SearchState) (q : Nat) (done : Array Nat)
    (remaining : List Nat) (hq : q ∈ remaining)
    (hcount : pairCount d remaining = s.need) :
    pairCount d (remaining.erase q) = (childState d s q done).need := by
  rw [pairCount_erase d remaining q hq, hcount, childState_need]

/-- A residual child preserves every remaining live item compatible with q
and excluded from neither q itself nor earlier siblings. -/
theorem mem_child_live (d : Instance) (s : SearchState) (q r : Nat) (done : Array Nat)
    (hr : r ∈ s.live) (hne : r ≠ q) (hdone : r ∉ done)
    (hcompat : ∀ p, p ∈ d.items[r]! → ∀ t, t ∈ d.items[q]! →
      p.1 ≠ t.1 ∧ p.2 ≠ t.2 ∧ gram d p.1 t.2 = false ∧ gram d t.1 p.2 = false) :
    r ∈ (childState d s q done).live := by
  rw [childState_live]
  apply Array.mem_filter.mpr
  refine ⟨hr, ?_⟩
  have hd : !done.contains r = true := by simp [hdone]
  simp only [Bool.and_eq_true, bne_iff_ne,
    Array.all_eq_true_iff_forall_mem]
  refine ⟨⟨hne, hd⟩, ?_⟩
  intro p hp t ht
  obtain ⟨h₁,h₂,h₃,h₄⟩ := hcompat p hp t ht
  simp [h₁, h₂, h₃, h₄]

/-- Direct connection of the concrete E check to the residual invariant. -/
theorem concrete_empty_contradiction (d : Instance) (s : SearchState) (c k : Nat)
    (remaining : List Nat)
    (hlive : ∀ q, q ∈ remaining → q ∈ s.live)
    (hresidual : bit s.residual[c]! k = paritySum (fun q => cov d q c k) remaining)
    (hcheck : (concreteRules d).emptyOk s (c,k) = true) : False := by
  simp only [concreteRules, Bool.and_eq_true] at hcheck
  obtain ⟨⟨⟨_, _⟩, hentry⟩, hn⟩ := hcheck
  obtain ⟨q, _, hq⟩ := residual_coverage d s c k remaining hlive hresidual hentry
  obtain ⟨hl, hc⟩ := Array.mem_filter.mp hq
  have ha : s.live.any (fun q => cov d q c k) = true := by
    apply Array.any_eq_true.mpr
    obtain ⟨i, hi, rfl⟩ := Array.mem_iff_getElem.mp hl
    exact ⟨i,hi,hc⟩
  simp [ha] at hn

/-- The concrete branch gate lists every covering item, exactly as required by
ordered sibling exclusion. This does not trust the producer's child order. -/
theorem concrete_branch_coverage (d : Instance) (s : SearchState) (c k : Nat)
    (qs : List Nat) (hcheck : (concreteRules d).branchOk s (c,k) qs = true) :
    ∀ q, q ∈ s.live.filter (fun q => cov d q c k) → q ∈ qs := by
  simp only [concreteRules, Bool.and_eq_true, beq_iff_eq, decide_eq_true_eq] at hcheck
  obtain ⟨⟨⟨_, _⟩, _⟩, ⟨⟨hlen, hsub⟩, hnd⟩⟩ := hcheck
  have hsublist : ∀ q, q ∈ qs → q ∈ (s.live.filter (fun q => cov d q c k)).toList := by
    intro q hq
    have hm := List.all_eq_true.mp hsub q hq
    exact Array.mem_toList_iff.mpr (Array.contains_iff_mem.mp hm)
  have hlenlist : qs.length = (s.live.filter (fun q => cov d q c k)).toList.length := by
    simpa only [Array.length_toList] using hlen
  intro q hq
  exact list_coverage_of_length qs _ hnd hsublist hlenlist q (Array.mem_toList_iff.mpr hq)

/-- Concrete B coverage from the mathematical residual invariant. -/
theorem concrete_branch_covers_remaining (d : Instance) (s : SearchState) (c k : Nat)
    (remaining qs : List Nat)
    (hlive : ∀ q, q ∈ remaining → q ∈ s.live)
    (hresidual : bit s.residual[c]! k = paritySum (fun q => cov d q c k) remaining)
    (hcheck : (concreteRules d).branchOk s (c,k) qs = true) :
    ∃ q, q ∈ qs ∧ q ∈ remaining := by
  have hc := hcheck
  simp only [concreteRules, Bool.and_eq_true] at hc
  obtain ⟨⟨⟨_, _⟩, hentry⟩, _⟩ := hc
  obtain ⟨q, hqr, hqc⟩ := residual_coverage d s c k remaining hlive hresidual hentry
  exact ⟨q, concrete_branch_coverage d s c k qs hcheck q hqc, hqr⟩

/-- Direct connection of the concrete K check to remaining cardinality. -/
theorem concrete_large_contradiction (d : Instance) (s : SearchState)
    (remaining : List Nat) (q : Nat) (hq : q ∈ remaining)
    (hcount : pairCount d remaining = s.need)
    (hcheck : (concreteRules d).tooLarge s q = true) : False := by
  exact oversized_contradiction d s remaining q hq hcount (of_decide_eq_true hcheck)

/-- Exact remaining obligation for the executable entrypoint. This theorem
connects successful parsing/evaluation to the proved generic recursion, but is
conditional on a concrete `RulesSound` proof; it is NOT `no_swap_frame`. -/
theorem checkViaKernel_sound {Frame : Type} (d : Instance) (tokens : Array Nat)
    (Completes : SearchState → Frame → Prop) (Contains : Frame → Nat → Prop)
    (sound : RulesSound (concreteRules d) Completes Contains)
    (accepted : checkViaKernel d tokens = true) :
    ¬ ∃ f, Completes
      {need := 128, residual := (Array.range 128).map (fun c => 1 <<< c),
       live := Array.range d.items.size} f := by
  unfold checkViaKernel at accepted
  split at accepted
  · contradiction
  · rename_i tree p hparse
    have checks := Bool.and_eq_true_iff.mp accepted
    exact check_no_completion (concreteRules d) Completes Contains sound 129 _ tree checks.2

#print axioms cov_eq_paritySum
#print axioms residual_coverage
#print axioms childState_live
#print axioms concrete_branch_covers_remaining
#print axioms checkViaKernel_sound

end C16Frames.CertGPT
