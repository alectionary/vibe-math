/- Adapted with namespace/import changes from the permitted read-only branch
 independent/c16-lean-cert-20261107, CertSound.lean (Grok/xAI).
 This proves bit/rank bridges only, not certificate soundness. -/
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.Field.ZMod
import Mathlib.LinearAlgebra.Matrix.Rank
import C16Frames
import CertGPTBits

open Matrix C16Frames

namespace C16Frames.CertGPT

instance : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩

/-- Generic coordinate conversion, independent of the concrete arrays. -/
def toVec (v : Nat) : Fin 128 → ZMod 2 := fun c => if v.testBit c then 1 else 0

/-! ## Parity of a bit vector -/

def bitParity : Nat → Nat → Bool
  | _, 0 => false
  | v, n + 1 => bitParity v n ^^ v.testBit n

def bitZ (b : Bool) : ZMod 2 := if b then 1 else 0

lemma bitZ_xor (a b : Bool) : bitZ (a ^^ b) = bitZ a + bitZ b := by
  cases a <;> cases b <;> rfl

lemma bitZ_eq_one (b : Bool) : bitZ b = 1 ↔ b = true := by
  cases b <;> simp [bitZ]

theorem bitParity_add (v a b : Nat) :
    bitParity v (a + b) = (bitParity v a ^^ bitParity (v >>> a) b) := by
  induction b with
  | zero => simp [bitParity]
  | succ b ih =>
    rw [Nat.add_succ, bitParity, ih, bitParity, Nat.testBit_shiftRight]
    cases bitParity v a <;> cases bitParity (v >>> a) b <;>
      cases v.testBit (a + b) <;> rfl

theorem bitParity_xor_le (v s n : Nat) (hn : n ≤ s) :
    bitParity (v ^^^ (v >>> s)) n = (bitParity v n ^^ bitParity (v >>> s) n) := by
  induction n with
  | zero => simp [bitParity]
  | succ n ih =>
    rw [bitParity, bitParity, bitParity, ih (Nat.le_of_succ_le hn), Nat.testBit_xor,
      Nat.testBit_shiftRight]
    simp [Bool.xor_assoc, Bool.xor_comm, Bool.xor_left_comm]

theorem bitParity_mask (v s n : Nat) (hn : n ≤ s) :
    bitParity (v &&& (2 ^ s - 1)) n = bitParity v n := by
  induction n with
  | zero => simp [bitParity]
  | succ n ih =>
    rw [bitParity, bitParity, ih (Nat.le_of_succ_le hn), Nat.testBit_and,
      Nat.testBit_two_pow_sub_one]
    have : n < s := Nat.lt_of_lt_of_le (Nat.lt_succ_self n) hn
    simp [this]

theorem bitParity_fold (v s : Nat) :
    bitParity (v ^^^ (v >>> s)) s = bitParity v (s + s) := by
  rw [bitParity_xor_le v s s le_rfl, ← bitParity_add]

theorem par128_eq_bitParity (v : Nat) : par128 v = bitParity v 128 := by
  simp only [par128]
  have h64 : bitParity (((v ^^^ (v >>> 64)) &&& (2 ^ 64 - 1))) 64 = bitParity v 128 := by
    rw [bitParity_mask _ 64 64 le_rfl, bitParity_fold]
  -- successive folds, named so the lets in `par128` can be replayed
  set v1 : Nat := (v ^^^ (v >>> 64)) &&& (2 ^ 64 - 1) with hv1
  have h32 : bitParity (v1 ^^^ (v1 >>> 32)) 32 = bitParity v1 64 := bitParity_fold v1 32
  set v2 : Nat := v1 ^^^ (v1 >>> 32) with hv2
  have h16 : bitParity (v2 ^^^ (v2 >>> 16)) 16 = bitParity v2 32 := bitParity_fold v2 16
  set v3 : Nat := v2 ^^^ (v2 >>> 16) with hv3
  have h8 : bitParity (v3 ^^^ (v3 >>> 8)) 8 = bitParity v3 16 := bitParity_fold v3 8
  set v4 : Nat := v3 ^^^ (v3 >>> 8) with hv4
  have h4 : bitParity (v4 ^^^ (v4 >>> 4)) 4 = bitParity v4 8 := bitParity_fold v4 4
  set v5 : Nat := v4 ^^^ (v4 >>> 4) with hv5
  have h2 : bitParity (v5 ^^^ (v5 >>> 2)) 2 = bitParity v5 4 := bitParity_fold v5 2
  set v6 : Nat := v5 ^^^ (v5 >>> 2) with hv6
  have h1 : bitParity (v6 ^^^ (v6 >>> 1)) 1 = bitParity v6 2 := bitParity_fold v6 1
  set v7 : Nat := v6 ^^^ (v6 >>> 1) with hv7
  have hbit : bitParity v7 1 = v7.testBit 0 := by simp [bitParity]
  have chain : bitParity v7 1 = bitParity v 128 := by
    rw [h1, h2, h4, h8, h16, h32, h64]
  rw [Bool.beq_eq_decide_eq, ← Nat.testBit_zero, ← hbit, chain]

def zsum (v n : Nat) : ZMod 2 :=
  match n with
  | 0 => 0
  | n + 1 => zsum v n + bitZ (v.testBit n)

theorem zsum_eq_bit (v n : Nat) : zsum v n = bitZ (bitParity v n) := by
  induction n with
  | zero => simp [zsum, bitParity, bitZ]
  | succ n ih =>
    rw [zsum, bitParity, ih, bitZ_xor]

theorem zsum_eq_sum (v n : Nat) :
    zsum v n = ∑ i : Fin n, bitZ (v.testBit i.1) := by
  induction n with
  | zero => simp [zsum]
  | succ n ih =>
    rw [zsum, Fin.sum_univ_castSucc, ih]
    simp [Fin.val_last]

theorem dot_eq_bitZ (a b : Nat) :
    toVec a ⬝ᵥ toVec b = bitZ (bitParity (a &&& b) 128) := by
  rw [← zsum_eq_bit, zsum_eq_sum]
  simp only [dotProduct, toVec]
  refine Finset.sum_congr rfl ?_
  intro i _
  simp only [Nat.testBit_and, bitZ]
  cases ha : a.testBit i.1 <;> cases hb : b.testBit i.1 <;> simp

theorem par_iff_dot (a b : Nat) :
    par128 (a &&& b) = true ↔ toVec a ⬝ᵥ toVec b = 1 := by
  rw [par128_eq_bitParity, dot_eq_bitZ, bitZ_eq_one]

lemma bool_eq_decide {b : Bool} {p : Prop} [Decidable p] (h : b = true ↔ p) : b = decide p := by
  cases b
  · simp
    exact fun hp => h.mpr hp |> False.elim ∘ (by simpa using h.mp)
  · simp [h.mp rfl]

/-- Generic parity-to-Gram bridge; instantiate with any two pool entries. -/
theorem gram_bool (a b : Nat) :
    par128 (a &&& b) = decide (toVec a ⬝ᵥ toVec b = 1) :=
  bool_eq_decide (par_iff_dot a b)

/-! ## Bit Gaussian elimination is an upper bound on matrix rank -/

def toV (n row : Nat) : Fin n → ZMod 2 :=
  fun i => if row.testBit i.1 then 1 else 0

lemma add_self_z (a : ZMod 2) : a + a = 0 := by
  fin_cases a <;> rfl

lemma toV_add_self {n : Nat} (v : Nat) : toV n v + toV n v = 0 := by
  funext i
  simp [toV, add_self_z]

lemma toV_xor {n a b : Nat} : toV n (a ^^^ b) = toV n a + toV n b := by
  funext i
  simp only [toV, Nat.testBit_xor, Pi.add_apply]
  cases a.testBit i.1 <;> cases b.testBit i.1 <;> simp [add_self_z]

lemma toV_zero {n : Nat} : toV n 0 = 0 := by
  funext i; simp [toV]

def elimFrom (pivs : Array Nat) (k r : Nat) : Nat :=
  if k ≥ pivs.size then r
  else
    let p := pivs.getD k 0
    let r := if p != 0 && r.testBit p.log2 then r ^^^ p else r
    elimFrom pivs (k + 1) r
termination_by pivs.size - k

theorem elim_go (pivs : Array Nat) (k r : Nat) : elimPiv.go pivs k r = elimFrom pivs k r := by
  rw [elimPiv.go.eq_1, elimFrom.eq_1]
  by_cases hk : k ≥ pivs.size
  · simp [hk]
  · simp [hk]
    exact elim_go pivs (k + 1)
      (if ¬(pivs[k]?).getD 0 = 0 ∧ r.testBit ((pivs[k]?).getD 0).log2 = true then
        r ^^^ (pivs[k]?).getD 0 else r)
termination_by pivs.size - k
decreasing_by omega

theorem elimPiv_eq (r : Nat) (pivs : Array Nat) : elimPiv r pivs = elimFrom pivs 0 r := by
  unfold elimPiv
  exact elim_go pivs 0 r

def tailSpan (n : Nat) (pivs : Array Nat) (k : Nat) : Submodule (ZMod 2) (Fin n → ZMod 2) :=
  Submodule.span (ZMod 2) {v | ∃ i, k ≤ i ∧ i < pivs.size ∧ v = toV n (pivs.getD i 0)}

lemma tailSpan_mono {n : Nat} (pivs : Array Nat) {k : Nat} :
    tailSpan n pivs (k + 1) ≤ tailSpan n pivs k := by
  refine Submodule.span_mono ?_
  rintro v ⟨i, hik, hi, rfl⟩
  exact ⟨i, Nat.le_trans (Nat.le_succ k) hik, hi, rfl⟩

lemma tailSpan_head {n : Nat} (pivs : Array Nat) {k : Nat} (hk : k < pivs.size) :
    toV n (pivs.getD k 0) ∈ tailSpan n pivs k := by
  refine Submodule.subset_span ⟨k, le_rfl, hk, rfl⟩

lemma toV_elimFrom_add {n : Nat} (pivs : Array Nat) (k r : Nat) :
    toV n (elimFrom pivs k r) + toV n r ∈ tailSpan n pivs k := by
  induction h : pivs.size - k generalizing k r with
  | zero =>
    have hk : pivs.size ≤ k := by omega
    rw [elimFrom]
    simp only [hk, ite_true]
    rw [toV_add_self]
    exact Submodule.zero_mem _
  | succ d ih =>
    rw [elimFrom]
    split
    · rename_i hk
      rw [toV_add_self]
      exact Submodule.zero_mem _
    · rename_i hk
      -- `hk : ¬ k ≥ pivs.size`. The branch value is the `if` inside `elimFrom`.
      have hk' : k < pivs.size := Nat.lt_of_not_ge hk
      -- Apply the induction hypothesis to whichever value the branch computed.
      revert hk
      intro hk
      -- Re-open the definition's second branch by cases on the Boolean condition.
      by_cases hc :
          (pivs.getD k 0 != 0 && r.testBit (pivs.getD k 0).log2) = true
      · simp only [hc, ite_true]
        have hih := ih (k + 1) (r ^^^ pivs.getD k 0) (by omega)
        have htail := tailSpan_mono (n := n) (pivs := pivs) (k := k) hih
        rw [toV_xor] at htail
        have hhead := tailSpan_head (n := n) pivs hk'
        have hmem := (tailSpan n pivs k).add_mem htail hhead
        have heq :
            toV n (elimFrom pivs (k + 1) (r ^^^ pivs.getD k 0)) + toV n r =
              toV n (elimFrom pivs (k + 1) (r ^^^ pivs.getD k 0)) +
                (toV n r + toV n (pivs.getD k 0)) + toV n (pivs.getD k 0) := by
          funext i
          simp only [Pi.add_apply]
          set ev : ZMod 2 := toV n (elimFrom pivs (k + 1) (r ^^^ pivs.getD k 0)) i
          set rv : ZMod 2 := toV n r i
          set pv : ZMod 2 := toV n (pivs.getD k 0) i
          calc
            ev + rv = ev + rv + 0 := by rw [add_zero]
            _ = ev + rv + (pv + pv) := by rw [← add_self_z pv]
            _ = ev + (rv + (pv + pv)) := by rw [add_assoc]
            _ = ev + ((rv + pv) + pv) := by rw [← add_assoc rv pv pv]
            _ = ev + (rv + pv) + pv := by rw [← add_assoc]
        rw [heq]
        exact hmem
      · have hih := ih (k + 1) r (by omega)
        have htail := tailSpan_mono (n := n) (pivs := pivs) (k := k) hih
        simp only [hc, ite_false] at *
        exact htail

def geStep (pivs : Array Nat) (r : Nat) : Array Nat :=
  let r' := elimPiv r pivs
  if r' == 0 then pivs else pivs.push r'

lemma getD_push_lt (a : Array Nat) (x i : Nat) (hi : i < a.size) :
    (a.push x).getD i 0 = a.getD i 0 := by
  have he : (a.push x)[i]'(by simp; omega) = a[i] := Array.getElem_push_lt (xs := a) (x := x) (i := i) hi
  simp [Array.getD, hi, he]
  intro h
  omega

lemma getD_push_last (a : Array Nat) (x : Nat) : (a.push x).getD a.size 0 = x := by
  simp [Array.getD, Array.getElem?_push_size]

lemma geCount_foldl (rows : Array Nat) :
    geCount rows = (rows.foldl geStep (#[] : Array Nat)).size := by
  unfold geCount geStep
  rfl

lemma row_mem_span_fold {n : Nat} (rows : List Nat) (pivs : Array Nat)
    (done : List Nat) (hdone : ∀ r ∈ done, toV n r ∈ tailSpan n pivs 0) :
    ∀ r ∈ done ++ rows, toV n r ∈ tailSpan n (rows.foldl geStep pivs) 0 := by
  induction rows generalizing pivs done with
  | nil => simpa
  | cons r rs ih =>
    intro x hx
    have hstep : toV n r ∈ tailSpan n (geStep pivs r) 0 := by
      have hmem := toV_elimFrom_add (n := n) pivs 0 r
      rw [← elimPiv_eq] at hmem
      unfold geStep
      by_cases hz : elimPiv r pivs == 0
      · have hz0 : elimPiv r pivs = 0 := by simpa using hz
        simp [hz, hz0, toV_zero] at hmem ⊢
        exact hmem
      · simp [hz]
        -- `toV r = toV (elim r) + (toV (elim r) + toV r)` and the second summand is in the old span
        have hpush : tailSpan n pivs 0 ≤ tailSpan n (pivs.push (elimPiv r pivs)) 0 := by
          refine Submodule.span_mono ?_
          rintro v ⟨i, hik, hi, rfl⟩
          refine ⟨i, hik, Nat.lt_trans hi (by simp), ?_⟩
          rw [getD_push_lt _ _ _ hi]
        have hold := hpush hmem
        have hnew : toV n (elimPiv r pivs) ∈ tailSpan n (pivs.push (elimPiv r pivs)) 0 := by
          refine Submodule.subset_span ⟨pivs.size, by simp, by simp, ?_⟩
          simp [getD_push_last]
        have : toV n r = toV n (elimPiv r pivs) + (toV n (elimPiv r pivs) + toV n r) := by
          funext i
          simp only [Pi.add_apply]
          set ev : ZMod 2 := toV n (elimPiv r pivs) i
          set rv : ZMod 2 := toV n r i
          calc
            rv = rv + 0 := by rw [add_zero]
            _ = rv + (ev + ev) := by rw [← add_self_z ev]
            _ = (ev + ev) + rv := by rw [add_comm]
            _ = ev + (ev + rv) := by rw [add_assoc]
        rw [this]
        exact (tailSpan n (pivs.push (elimPiv r pivs)) 0).add_mem hnew hold
    have hdone' : ∀ y ∈ done ++ [r], toV n y ∈ tailSpan n (geStep pivs r) 0 := by
      intro y hy
      simp at hy
      rcases hy with hy | rfl
      · -- old rows stay in the span after one step
        have hold : toV n y ∈ tailSpan n pivs 0 := hdone y hy
        unfold geStep
        by_cases hz : elimPiv r pivs == 0
        · simpa [hz] using hold
        · simp [hz]
          refine Submodule.span_mono ?_ hold
          rintro v ⟨i, hik, hi, rfl⟩
          refine ⟨i, hik, Nat.lt_trans hi (by simp), ?_⟩
          rw [getD_push_lt _ _ _ hi]
      · exact hstep
    have hx' : x ∈ (done ++ [r]) ++ rs := by simpa [List.append_assoc] using hx
    simpa [List.foldl] using ih (geStep pivs r) (done ++ [r]) hdone' x hx'

lemma rows_mem_geSpan {n : Nat} (rows : Array Nat) :
    ∀ i : Fin rows.size, toV n rows[i] ∈ tailSpan n (rows.foldl geStep #[]) 0 := by
  intro i
  have hmem : rows[i] ∈ rows.toList := by
    simpa [Array.getElem_toList] using
      List.get_mem rows.toList ⟨i.1, by simpa [Array.length_toList] using i.isLt⟩
  have h := row_mem_span_fold (n := n) rows.toList #[] [] (by simp) rows[i] hmem
  simpa [Array.foldl_toList] using h

lemma finrank_tail_le (n : Nat) (pivs : Array Nat) :
    Module.finrank (ZMod 2) (tailSpan n pivs 0) ≤ pivs.size := by
  classical
  let S : Set (Fin n → ZMod 2) := Set.range fun i : Fin pivs.size => toV n (pivs.getD i.1 0)
  have hle : tailSpan n pivs 0 ≤ Submodule.span (ZMod 2) S := by
    refine Submodule.span_mono ?_
    rintro v ⟨i, _, hi, rfl⟩
    exact ⟨⟨i, hi⟩, rfl⟩
  refine (Submodule.finrank_mono hle).trans ?_
  have hcard : S.toFinset.card ≤ pivs.size := by
    simpa [Set.toFinset_card] using
      Fintype.card_range_le (fun i : Fin pivs.size => toV n (pivs.getD i.1 0))
  exact (finrank_span_le_card (s := S)).trans hcard

theorem matrixRank_le_geCount {n : Nat} (rows : Array Nat) :
    (Matrix.of fun i : Fin rows.size => fun j : Fin n => toV n rows[i] j).rank ≤
      geCount rows := by
  have hr := Matrix.rank_eq_finrank_span_row (Matrix.of fun i : Fin rows.size => fun j : Fin n => toV n rows[i] j)
  rw [hr, geCount_foldl]
  refine (Submodule.finrank_mono ?_).trans (finrank_tail_le n (rows.foldl geStep #[]))
  rw [Submodule.span_le]
  rintro _ ⟨i, rfl⟩
  simpa [Matrix.of_apply] using rows_mem_geSpan (n := n) rows i


#print axioms gram_bool
#print axioms matrixRank_le_geCount
end C16Frames.CertGPT

