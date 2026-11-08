import CertSound

open Matrix C16Frames C16Frames.CertRun C16Frames.CertSound

namespace C16Frames.CertInvariant

/-! Semantics of the Boolean checker. Everything is generic in the arrays. -/

variable (x z : Array Nat)

def bitContrib (i j c k : Nat) : ZMod 2 :=
  if (x.getD i 0).testBit c && (z.getD j 0).testBit k then 1 else 0

def Msum (ps : List (Nat × Nat)) (c k : Nat) : ZMod 2 :=
  (ps.map fun p => bitContrib x z p.1 p.2 c k).sum

lemma bitZ_false : bitZ false = 0 := by simp [bitZ]

lemma bitZ_true : bitZ true = 1 := by simp [bitZ]

lemma covers_aux (ps : List (Nat × Nat)) (acc : Bool) (c k : Nat) :
    bitZ (ps.foldl (fun a p =>
      a ^^ ((x.getD p.1 0).testBit c && (z.getD p.2 0).testBit k)) acc)
      = bitZ acc + Msum x z ps c k := by
  induction ps generalizing acc with
  | nil => simp [Msum, bitZ_false]
  | cons p ps ih =>
    simp only [List.foldl_cons, List.map_cons, List.sum_cons, Msum, bitZ_xor, ih]
    have hbit : bitZ ((x.getD p.1 0).testBit c && (z.getD p.2 0).testBit k) =
        bitContrib x z p.1 p.2 c k := by
      simp [bitContrib, bitZ]
    rw [hbit]
    abel

theorem covers_true_iff (ps : List (Nat × Nat)) (c k : Nat) :
    covers x z ps c k = true ↔ Msum x z ps c k = 1 := by
  unfold covers
  have h := covers_aux x z ps false c k
  simp only [bitZ_false, zero_add] at h
  constructor
  · intro ht
    rw [ht, bitZ_true] at h
    exact h.symm
  · intro hm
    have : bitZ (ps.foldl (fun a p =>
        a ^^ ((x.getD p.1 0).testBit c && (z.getD p.2 0).testBit k)) false) = 1 := by
      rw [h, hm]
    exact (bitZ_eq_one _).1 this

def resZ (res : Array Nat) (c k : Nat) : ZMod 2 :=
  bitZ (resBit res c k)

def itemsSum (t : Table) (U : List Nat) (c k : Nat) : ZMod 2 :=
  (U.map fun q => Msum x z (t.pairs q) c k).sum

def lenSum (t : Table) (U : List Nat) : Nat :=
  (U.map (itemLen t)).sum

lemma itemLen_eq_pairs (t : Table) (q : Nat) :
    itemLen t q = (t.pairs q).length := by
  simp [itemLen, Table.pairs, List.length_map, List.length_range]

/-- A list of pairs is a partial frame for the Boolean pairing. -/
def IsPartial (ps : List (Nat × Nat)) : Prop :=
  (∀ p ∈ ps, ∀ q ∈ ps, p.1 = q.1 → p = q) ∧
  (∀ p ∈ ps, ∀ q ∈ ps, p.2 = q.2 → p = q) ∧
  (∀ p ∈ ps, ∀ q ∈ ps,
    par128 (x.getD p.1 0 &&& z.getD q.2 0) = decide (p = q))

lemma testBit_shift_one (i j : Nat) : ((1 <<< i).testBit j) = decide (i = j) := by
  have : (1 <<< i) = 2 ^ i := by simp [Nat.shiftLeft_eq]
  rw [this, Nat.testBit_two_pow, eq_comm]

lemma idRes_bit (c k : Nat) (hc : c < 128) (_hk : k < 128) :
    resBit idRes c k = decide (c = k) := by
  have hc' : c < idRes.size := by simp [idRes, hc]
  simp only [resBit]
  have hget : idRes.getD c 0 = idRes[c] := by simp [Array.getD, hc']
  rw [hget]
  have hval : idRes[c] = 1 <<< c := by simp [idRes, Array.getElem_ofFn]
  rw [hval, testBit_shift_one]

lemma resBit_aset (res : Array Nat) (i v c k : Nat) (hc : c < res.size) :
    resBit (aset res i v) c k =
      if c = i then v.testBit k else resBit res c k := by
  unfold aset resBit
  by_cases hi : i < res.size
  · simp only [hi, dite_true]
    by_cases hci : c = i
    · subst hci
      have hcset : c < (res.set c v hi).size := by simpa using hc
      have hset : (res.set c v hi)[c] = v := Array.getElem_set_self hi
      simp [Array.getD, hcset, hset, hc]
    · have hcset : c < (res.set i v hi).size := by simpa using hc
      have hne : i ≠ c := Ne.symm hci
      have hset : (res.set i v hi)[c] = res[c] := Array.getElem_set_ne hi hc hne
      simp [Array.getD, hcset, hc, hset, hci]
  · simp only [hi, dite_false]
    have hne : c ≠ i := by
      intro h
      subst h
      exact hi hc
    simp [hne]

lemma foldN_step {α : Type} (n i : Nat) (acc : α) (f : Nat → α → α) :
    foldN.go n f i acc = if i ≥ n then acc else foldN.go n f (i + 1) (f i acc) := by
  rw [foldN.go.eq_1]

private def xorF (xi zj : Nat) : Nat → Array Nat → Array Nat :=
  fun c r => if xi.testBit c then aset r c ((r.getD c 0) ^^^ zj) else r

lemma not_decide_xor_eq (a b : Bool) : (¬ decide ((a ^^ b) = a)) = b := by
  cases a <;> cases b <;> decide

lemma xor_step_bit (res : Array Nat) (xi zj c k t : Nat)
    (hs : res.size = 128) (hc : c < 128) (hk : k < 128) (ht : t < 128) :
    resBit (xorF xi zj t res) c k =
      (resBit res c k ^^ (decide (c = t) && xi.testBit t && zj.testBit k)) := by
  unfold xorF resBit aset
  have htc : t < res.size := by omega
  have hcc : c < res.size := by omega
  by_cases hx : xi.testBit t = true <;> by_cases hct : c = t
  · subst hct
    cases ha : (res[c].testBit k) <;> cases hb : zj.testBit k <;>
      simp [hx, htc, hcc, Array.getElem_set_self, Nat.testBit_xor, ha, hb]
  · simp [hx, hct, htc, hcc, Array.getElem_set_ne htc hcc (Ne.symm hct)]
  · simp [hx]
  · simp [hx]

lemma xor_go (xi zj t : Nat) (res0 res : Array Nat)
    (_hs0 : res0.size = 128) (hs : res.size = 128) (ht : t ≤ 128)
    (hinv : ∀ c k, c < 128 → k < 128 →
      resBit res c k =
        (resBit res0 c k ^^ (decide (c < t) && xi.testBit c && zj.testBit k))) :
    ∀ c k, c < 128 → k < 128 →
      resBit (foldN.go 128 (xorF xi zj) t res) c k =
        (resBit res0 c k ^^ (xi.testBit c && zj.testBit k)) := by
  induction h : 128 - t generalizing t res with
  | zero =>
    have ht' : t = 128 := by omega
    intro c k hc hk
    rw [foldN_step, if_pos (by omega : t ≥ 128)]
    have hc' : decide (c < t) = true := by simp [ht', hc]
    have hbit := hinv c k hc hk
    rw [hc'] at hbit
    simpa [Bool.true_and] using hbit
  | succ d ih =>
    have ht' : t < 128 := by omega
    rw [foldN_step, if_neg (by omega : ¬ t ≥ 128)]
    have hs' : (xorF xi zj t res).size = 128 := by
      unfold xorF
      by_cases hx : xi.testBit t = true
      · simp only [hx, ite_true]
        unfold aset
        have htlt : t < res.size := by omega
        rw [hs] at htlt
        simp [htlt, Array.size_set, hs]
      · have hx' : xi.testBit t = false := by
          cases hb : xi.testBit t
          · rfl
          · exact absurd hb hx
        simp [hx', hs]
    have hle : t + 1 ≤ 128 := by omega
    suffices hinv' : ∀ c k, c < 128 → k < 128 →
        resBit (xorF xi zj t res) c k =
          (resBit res0 c k ^^ (decide (c < t + 1) && xi.testBit c && zj.testBit k)) by
      have hdec : 128 - (t + 1) = d := by omega
      exact ih (t + 1) (xorF xi zj t res) hs' hle hinv' hdec
    intro c k hc hk
    rw [xor_step_bit res xi zj c k t hs hc hk ht', hinv c k hc hk]
    by_cases hct : c = t
    · subst hct
      have h0 : decide (c < c) = false := by simp
      have h1 : decide (c < c + 1) = true := by simp [Nat.lt_succ_self]
      have he : decide (c = c) = true := by simp
      rw [h0, h1, he]
      simp only [Bool.false_xor, Bool.xor_false, Bool.and_true, Bool.true_and,
        Bool.false_and, Bool.and_false]
    · have h0 : decide (c = t) = false := by simpa [decide_eq_false_iff_not] using hct
      have hlt : decide (c < t) = decide (c < t + 1) := by
        by_cases h1 : c < t
        · simp [h1, Nat.lt_succ_of_le (Nat.le_of_lt h1)]
        · simp [h1, show ¬ c < t + 1 by omega]
      rw [h0, hlt]
      simp only [Bool.false_and, Bool.and_false, Bool.xor_false, Bool.xor_assoc]

lemma xorGo_size (xi zj t : Nat) (res : Array Nat)
    (hs : res.size = 128) (ht : t ≤ 128) :
    (foldN.go 128 (xorF xi zj) t res).size = 128 := by
  induction h : 128 - t generalizing t res with
  | zero =>
    rw [foldN_step, if_pos (by omega : t ≥ 128)]
    exact hs
  | succ d ih =>
    have ht' : t < 128 := by omega
    rw [foldN_step, if_neg (by omega : ¬ t ≥ 128)]
    have hs1 : (xorF xi zj t res).size = 128 := by
      unfold xorF
      by_cases hx : xi.testBit t = true
      · simp only [hx, ite_true]
        unfold aset
        have htlt : t < res.size := by omega
        rw [hs] at htlt
        simp [htlt, Array.size_set, hs]
      · have hx' : xi.testBit t = false := by
          cases hb : xi.testBit t
          · rfl
          · exact absurd hb hx
        simp [hx', hs]
    have hle : t + 1 ≤ 128 := by omega
    exact ih (t + 1) (xorF xi zj t res) hs1 hle (by omega)

lemma onePair_bit (xi zj : Nat) (res : Array Nat) (c k : Nat)
    (hs : res.size = 128) (hc : c < 128) (hk : k < 128) :
    resBit (foldN 128 res (xorF xi zj)) c k =
      (resBit res c k ^^ (xi.testBit c && zj.testBit k)) := by
  have h := xor_go xi zj 0 res res hs hs (Nat.zero_le _)
    (by intro c k hc hk; simp) c k hc hk
  simpa [foldN] using h

lemma onePair_resZ (i j : Nat) (res : Array Nat) (c k : Nat)
    (hs : res.size = 128) (hc : c < 128) (hk : k < 128) :
    resZ (foldN 128 res (xorF (x.getD i 0) (z.getD j 0))) c k =
      resZ res c k + bitContrib x z i j c k := by
  have h := onePair_bit (x.getD i 0) (z.getD j 0) res c k hs hc hk
  simp only [resZ]
  rw [h, bitZ_xor]
  simp [bitContrib, bitZ]

theorem addPairs_resZ (pairs : List (Nat × Nat)) (res : Array Nat) (c k : Nat)
    (hs : res.size = 128) (hc : c < 128) (hk : k < 128) :
    resZ (addPairs x z res pairs) c k = resZ res c k + Msum x z pairs c k := by
  induction pairs generalizing res with
  | nil => simp [addPairs, Msum]
  | cons p ps ih =>
    have hstep := onePair_resZ x z p.1 p.2 res c k hs hc hk
    have hcons : addPairs x z res (p :: ps) =
        addPairs x z (foldN 128 res (xorF (x.getD p.1 0) (z.getD p.2 0))) ps := by
      unfold addPairs xorF
      simp only [List.foldl_cons]
    have hs' : (foldN 128 res (xorF (x.getD p.1 0) (z.getD p.2 0))).size = 128 := by
      simpa [foldN] using xorGo_size (x.getD p.1 0) (z.getD p.2 0) 0 res hs (Nat.zero_le _)
    rw [hcons, ih _ hs', hstep]
    simp [Msum, List.map_cons, List.sum_cons, add_assoc]

end C16Frames.CertInvariant
