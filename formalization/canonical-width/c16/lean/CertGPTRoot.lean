import CertGPTItemTable
import CertGPTCompletion
import CertGPTSound
import CertGPTRank

namespace C16Frames.CertGPT
open Matrix

 theorem bitZ_injective : Function.Injective bitZ := by
  intro a b h
  cases a <;> cases b <;> simp_all [bitZ]

 theorem bitZ_and (a b : Bool) : bitZ (a && b) = bitZ a * bitZ b := by
  cases a <;> cases b <;> rfl

 theorem bitZ_paritySum {α : Type} (f : α → Bool) (xs : List α) :
    bitZ (paritySum f xs) = (xs.map (fun p => bitZ (f p))).sum := by
  induction xs with
  | nil => rfl
  | cons a as ih =>
    change bitZ (f a ^^ paritySum f as) = _
    rw [bitZ_xor, ih]
    rfl

 theorem paritySum_flatMap {α β : Type} (f : β → Bool) (g : α → List β) (xs : List α) :
    paritySum f (xs.flatMap g) = paritySum (fun a => paritySum f (g a)) xs := by
  induction xs with
  | nil => rfl
  | cons a as ih => simp only [List.flatMap_cons, paritySum_append, ih, paritySum]

 theorem cov_parity_flat (d : Instance) (qs : List Nat) (c k : Nat) :
    paritySum (fun q => cov d q c k) qs = paritySum
      (fun p : Pair => bit d.x[p.1]! c && bit d.z[p.2]! k)
      (qs.flatMap (fun q => d.items[q]!.toList)) := by
  rw [paritySum_flatMap]
  congr 1
  funext q
  exact cov_eq_paritySum d q c k

 theorem list_sum_eq_finset_sum {α : Type} [DecidableEq α] (f : α → ZMod 2)
    (xs : List α) (h : xs.Nodup) : (xs.map f).sum = ∑ p ∈ xs.toFinset, f p := by
  induction xs with
  | nil => simp
  | cons a as ih =>
    have hh := List.nodup_cons.mp h
    simp [hh.1, ih hh.2]

 theorem root_residual_of_identity (d : Instance) (qs : List Nat)
    (hn : (qs.flatMap (fun q => d.items[q]!.toList)).Nodup)
    (hid : ∀ c k : Fin 128,
      (∑ p ∈ (qs.flatMap (fun q => d.items[q]!.toList)).toFinset,
        toVec d.x[p.1]! c * toVec d.z[p.2]! k) = if c = k then 1 else 0) :
    ∀ c, c < 128 → ∀ k, k < 128 →
      bit ((Array.range 128).map (fun c => 1 <<< c))[c]! k =
        paritySum (fun q => cov d q c k) qs := by
  intro c hc k hk
  apply bitZ_injective
  rw [cov_parity_flat, bitZ_paritySum, list_sum_eq_finset_sum _ _ hn]
  have hh := hid ⟨c,hc⟩ ⟨k,hk⟩
  have he : ∀ p : Pair,
      bitZ (bit d.x[p.1]! c && bit d.z[p.2]! k) =
        toVec d.x[p.1]! ⟨c,hc⟩ * toVec d.z[p.2]! ⟨k,hk⟩ := by
    intro p
    rw [bitZ_and]
    simp only [bit_eq_testBit, bitZ, toVec]
  simp_rw [he]
  rw [hh]
  simp [bit_eq_testBit, bitZ, Nat.one_shiftLeft, Nat.testBit_two_pow, hc]

/-- The exact initial state of both certificate checkers. -/
def rootState (d : Instance) : SearchState :=
  {need := 128, residual := (Array.range 128).map (fun c => 1 <<< c),
   live := Array.range d.items.size}

 theorem frame_root_completion (d : Instance) (F : Finset Pair)
    (hv : validateItems d "swap" = true)
    (hf : IsPairFrame (gramField d) F) (hs : F.image Prod.swap = F)
    (hb : ∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size)
    (hc : F.card = 128) : ∃ qs, Completion d (rootState d) qs := by
  obtain ⟨qs, hid, hi, hn, he, hd⟩ := validated_frame_table_list d F hv hf hs hb
  have hcount : pairCount d qs = 128 := by
    rw [← pairsOf_length]
    have hh := List.toFinset_card_of_nodup hn
    rw [he, hc] at hh
    exact hh.symm
  have hfdot : IsPairFrame
      (fun i j => ∑ c : Fin 128, toVec d.x[i]! c * toVec d.z[j]! c) F := by
    have hg : (fun i j => ∑ c : Fin 128, toVec d.x[i]! c * toVec d.z[j]! c) = gramField d := by
      funext i j
      change (toVec d.x[i]! ⬝ᵥ toVec d.z[j]!) = bitZ (par128 (d.x[i]! &&& d.z[j]!))
      rw [par128_eq_bitParity]
      exact dot_eq_bitZ _ _
    rw [hg]
    exact hf
  have houter := pairFrame_identity (fun i => toVec d.x[i]!) (fun j => toVec d.z[j]!) F hc hfdot
  refine ⟨qs, ⟨hid, ?_, hi, ?_, hn, ?_, hd, hcount, ?_⟩⟩
  · intro q hq
    exact Array.mem_range.mpr (hi q hq)
  · intro p hp
    apply hb p
    rw [← he]
    exact List.mem_toFinset.mpr hp
  · simpa only [pairsOf, he] using hf
  · apply root_residual_of_identity d qs hn
    simpa only [he] using houter

/-- Unconditional semantic soundness for bounded swap-invariant pair frames.
Both hypotheses are executable checks, not assumptions of mathematical completeness. -/
theorem no_swap_frame_of_check (d : Instance) (tokens : Array Nat)
    (itemsOK : validateItems d "swap" = true) (accepted : checkViaKernel d tokens = true) :
    ¬ ∃ F : Finset Pair,
      IsPairFrame (gramField d) F ∧ F.card = 128 ∧ F.image Prod.swap = F ∧
      (∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size) := by
  rintro ⟨F, hf, hc, hs, hb⟩
  exact checkViaKernel_no_completion d tokens accepted
    (frame_root_completion d F itemsOK hf hs hb hc)

#print axioms frame_root_completion
#print axioms no_swap_frame_of_check

end C16Frames.CertGPT
