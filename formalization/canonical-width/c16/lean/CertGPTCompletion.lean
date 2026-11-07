import CertGPTSound
import CertGPTFrameCheck
import CertGPTRankLeaf
import Mathlib.Data.List.Nodup

namespace C16Frames.CertGPT

/-- Flatten the remaining item indices into their actual ordered pairs. -/
def pairsOf (d : Instance) (qs : List Nat) : List Pair :=
  qs.flatMap fun q => d.items[q]!.toList

/-- Concrete mathematical completion invariant. The witness is the *remaining*
item list, so choosing q passes `qs.erase q` to the child. -/
structure Completion (d : Instance) (s : SearchState) (qs : List Nat) : Prop where
  idsNodup : qs.Nodup
  live : ∀ q ∈ qs, q ∈ s.live
  itemBound : ∀ q ∈ qs, q < d.items.size
  pairBounds : ∀ p ∈ pairsOf d qs, p.1 < d.x.size ∧ p.2 < d.z.size
  pairsNodup : (pairsOf d qs).Nodup
  frame : IsPairFrame (gramField d) (pairsOf d qs).toFinset
  disjoint : ∀ q ∈ qs, ∀ r ∈ qs, q ≠ r → Disjoint (pairSet d.items[q]!) (pairSet d.items[r]!)
  count : pairCount d qs = s.need
  residual : ∀ c, c < 128 → ∀ k, k < 128 →
    bit s.residual[c]! k = paritySum (fun q => cov d q c k) qs

theorem pairsOf_length (d : Instance) (qs : List Nat) :
    (pairsOf d qs).length = pairCount d qs := by
  simp [pairsOf, pairCount, List.length_flatMap]

theorem pairsOf_mem {d : Instance} {qs : List Nat} {q : Nat} {p : Pair}
    (hq : q ∈ qs) (hp : p ∈ d.items[q]!) : p ∈ pairsOf d qs := by
  exact List.mem_flatMap.mpr ⟨q, hq, Array.mem_toList_iff.mpr hp⟩

theorem pairsOf_mono (d : Instance) {qs rs : List Nat} (h : ∀ q ∈ qs, q ∈ rs) :
    ∀ p ∈ pairsOf d qs, p ∈ pairsOf d rs := by
  intro p hp
  obtain ⟨q,hq,hp⟩ := List.mem_flatMap.mp hp
  exact List.mem_flatMap.mpr ⟨q,h q hq,hp⟩

/-- Distinct remaining items are mutually orthogonal and use distinct indices. -/
theorem Completion.compatible {d : Instance} {s : SearchState} {qs : List Nat}
    (h : Completion d s qs) {q r : Nat} (hq : q ∈ qs) (hr : r ∈ qs) (hne : r ≠ q)
    {p t : Pair} (hp : p ∈ d.items[r]!) (ht : t ∈ d.items[q]!) :
    p.1 ≠ t.1 ∧ p.2 ≠ t.2 ∧ gram d p.1 t.2 = false ∧ gram d t.1 p.2 = false := by
  have hpF : p ∈ (pairsOf d qs).toFinset := List.mem_toFinset.mpr (pairsOf_mem hr hp)
  have htF : t ∈ (pairsOf d qs).toFinset := List.mem_toFinset.mpr (pairsOf_mem hq ht)
  have hpt : p ≠ t := by
    intro heq
    have hd := Finset.disjoint_left.mp (h.disjoint r hr q hq hne)
    exact hd (by simpa [pairSet] using hp) (by simpa [pairSet, heq] using ht)
  refine ⟨fun he => hpt (h.frame.1 p hpF t htF he),
    fun he => hpt (h.frame.2.1 p hpF t htF he), ?_, ?_⟩
  · have hg := h.frame.2.2 p hpF t htF
    simpa [gramField, hpt] using hg
  · have hg := h.frame.2.2 t htF p hpF
    simpa [gramField, Ne.symm hpt] using hg

/-- Every semantic completion containing the chosen live item passes to the
computed child, with exactly that item removed from the witness. -/
theorem Completion.next {d : Instance} {s : SearchState} {qs : List Nat}
    (h : Completion d s qs) (q : Nat) (hq : q ∈ qs) (done : List Nat)
    (hdone : ∀ r, r ∈ done → r ∉ qs) :
    Completion d (childState d s q done.toArray) (qs.erase q) := by
  have hsub : ∀ r, r ∈ qs.erase q → r ∈ qs := fun _ => List.mem_of_mem_erase
  have hpsub := pairsOf_mono d hsub
  refine ⟨h.idsNodup.sublist List.erase_sublist, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro r hr
    have hrq : r ≠ q := by
      intro he
      subst r
      exact h.idsNodup.not_mem_erase hr
    apply mem_child_live d s q r done.toArray (h.live r (hsub r hr)) hrq
    · intro hd
      exact hdone r (by simpa using hd) (hsub r hr)
    · intro p hp t ht
      exact h.compatible hq (hsub r hr) hrq hp ht
  · intro r hr
    exact h.itemBound r (hsub r hr)
  · intro p hp
    exact h.pairBounds p (hpsub p hp)
  · have hn := List.nodup_flatMap.mp h.pairsNodup
    exact List.nodup_flatMap.mpr ⟨fun r hr => hn.1 r (hsub r hr),
      hn.2.sublist List.erase_sublist⟩
  · apply h.frame.mono
    intro p hp
    exact List.mem_toFinset.mpr (hpsub p (List.mem_toFinset.mp hp))
  · intro r hr t ht hrt
    exact h.disjoint r (hsub r hr) t (hsub t ht) hrt
  · exact child_pairCount d s q done.toArray qs hq h.count
  · intro c hc k hk
    rw [childState_residual_bit d s q done.toArray c k hc]
    exact residual_remove_member (fun q => cov d q c k) q qs (bit s.residual[c]! k)
      hq (h.residual c hc k hk)

/-- All semantic obligations for the actual executable operations are proved.
No frame-exclusion assumption or certificate acceptance is used here. -/
theorem completionRulesSound (d : Instance) :
    RulesSound (concreteRules d) (Completion d) (fun qs q => q ∈ qs) := by
  constructor
  · intro s qs h hcheck
    apply rankLeaf_contradiction d s (pairsOf d qs).toFinset h.frame
    · rw [List.toFinset_card_of_nodup h.pairsNodup, pairsOf_length, h.count]
    · intro p hp
      obtain ⟨q,hq,hp⟩ := List.mem_flatMap.mp (List.mem_toFinset.mp hp)
      exact ⟨q,h.live q hq,Array.mem_toList_iff.mp hp⟩
    · exact hcheck
  · intro s qs e h hcheck
    have hc := hcheck
    simp only [concreteRules, Bool.and_eq_true, decide_eq_true_eq] at hc
    obtain ⟨⟨⟨hc,hk⟩,_⟩,_⟩ := hc
    exact concrete_empty_contradiction d s e.1 e.2 qs h.live
      (h.residual e.1 hc e.2 hk) hcheck
  · intro s qs e children h hcheck
    have hc := hcheck
    simp only [concreteRules, Bool.and_eq_true, decide_eq_true_eq] at hc
    obtain ⟨⟨⟨hc,hk⟩,_⟩,_⟩ := hc
    exact concrete_branch_covers_remaining d s e.1 e.2 qs children h.live
      (h.residual e.1 hc e.2 hk) hcheck
  · intro s qs q h hq _ hlarge
    exact concrete_large_contradiction d s qs q hq h.count hlarge
  · intro s qs done q h hq _ hdone
    exact ⟨qs.erase q, h.next q hq done hdone⟩

/-- The accepted concrete checker excludes every concrete completion. -/
theorem checkViaKernel_no_completion (d : Instance) (tokens : Array Nat)
    (accepted : checkViaKernel d tokens = true) :
    ¬ ∃ qs, Completion d
      {need := 128, residual := (Array.range 128).map (fun c => 1 <<< c),
       live := Array.range d.items.size} qs :=
  checkViaKernel_sound d tokens (Completion d) (fun qs q => q ∈ qs)
    (completionRulesSound d) accepted

#print axioms completionRulesSound
#print axioms checkViaKernel_no_completion
#print axioms Completion.next

end C16Frames.CertGPT
