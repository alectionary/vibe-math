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

def orStep (f : Nat → Bool) (i acc : Nat) : Nat :=
  if f i then acc ||| (1 <<< i) else acc

lemma testBit_orStep (f : Nat → Bool) (acc i j : Nat) :
    (orStep f i acc).testBit j = (acc.testBit j || (f i && decide (i = j))) := by
  unfold orStep
  by_cases hf : f i = true
  · rw [if_pos hf, Nat.testBit_or, testBit_shift_one]
    cases acc.testBit j <;> simp [hf]
  · have hf' : f i = false := by cases h : f i <;> simp_all
    rw [if_neg (by simp [hf'])]
    simp [hf']

lemma orGo_bit (f : Nat → Bool) (t j acc : Nat) (hj : j < 720) (ht : t ≤ 720)
    (hacc : acc.testBit j = if t ≤ j then false else f j) :
    (foldN.go 720 (orStep f) t acc).testBit j = f j := by
  induction h : 720 - t generalizing t acc with
  | zero =>
    rw [foldN_step, if_pos (by omega : t ≥ 720)]
    have hnj : ¬ t ≤ j := by omega
    simp [hacc, hnj]
  | succ d ih =>
    have ht' : t < 720 := by omega
    rw [foldN_step, if_neg (by omega : ¬ t ≥ 720)]
    have hle : t + 1 ≤ 720 := by omega
    have hdec : 720 - (t + 1) = d := by omega
    have hacc' : (orStep f t acc).testBit j = if t + 1 ≤ j then false else f j := by
      rw [testBit_orStep]
      by_cases htj : t = j
      · simp [hacc, htj, Nat.le_refl, Nat.lt_succ_self]
      · by_cases hle' : t ≤ j
        · have hgt : t + 1 ≤ j := by omega
          simp [hacc, hle', htj, hgt]
        · have hlt : ¬ t + 1 ≤ j := by omega
          simp [hacc, hle', hlt, htj]
    exact ih (t + 1) (orStep f t acc) hle hacc' hdec

theorem buildOneRow_bit (i j : Nat) (hj : j < 720) :
    (buildOneRow x z i).testBit j = par128 (x.getD i 0 &&& z.getD j 0) := by
  unfold buildOneRow foldN
  have heq :
      (let xi := x.getD i 0;
        foldN.go 720 (fun j acc => if par128 (xi &&& z.getD j 0) = true then acc ||| (1 <<< j) else acc) 0 0)
        = foldN.go 720 (orStep (fun j => par128 (x.getD i 0 &&& z.getD j 0))) 0 0 := by
    rfl
  rw [heq]
  exact orGo_bit (fun j => par128 (x.getD i 0 &&& z.getD j 0)) 0 j 0 hj (Nat.zero_le _) (by simp)

theorem buildGRow_bit (i j : Nat) (hi : i < 720) (hj : j < 720) :
    ((buildGRow x z).getD i 0).testBit j = par128 (x.getD i 0 &&& z.getD j 0) := by
  have hs : i < (buildGRow x z).size := by simp [buildGRow, hi]
  have hget : (buildGRow x z).getD i 0 = (buildGRow x z)[i] := by simp [Array.getD, hs]
  have hrow : (buildGRow x z)[i] = buildOneRow x z i := by
    simp [buildGRow, Array.getElem_ofFn]
  rw [hget, hrow]
  exact buildOneRow_bit x z i j hj

theorem buildCol_bit (gRow : Array Nat) (i j : Nat) (hi : i < 720) (hj : j < 720) :
    ((buildCol gRow).getD j 0).testBit i = (gRow.getD i 0).testBit j := by
  have hs : j < (buildCol gRow).size := by simp [buildCol, hj]
  have hget : (buildCol gRow).getD j 0 = (buildCol gRow)[j] := by simp [Array.getD, hs]
  have heq : (buildCol gRow)[j] =
      foldN.go 720 (orStep (fun a => (gRow.getD a 0).testBit j)) 0 0 := by
    simp [buildCol, Array.getElem_ofFn, foldN]
    rfl
  rw [hget, heq]
  exact orGo_bit (fun a => (gRow.getD a 0).testBit j) 0 i 0 hi (Nat.zero_le _) (by simp)

lemma foldl_pairOr (ps : List (Nat × Nat)) (xSide : Bool) (acc bit : Nat) :
    ps.foldl (fun a p => a ||| (1 <<< if xSide then p.1 else p.2)) (acc ||| bit) =
      ps.foldl (fun a p => a ||| (1 <<< if xSide then p.1 else p.2)) acc ||| bit := by
  induction ps generalizing acc with
  | nil => simp
  | cons p ps ih =>
    simp only [List.foldl_cons]
    have hstep :
        ((acc ||| bit) ||| (1 <<< if xSide then p.1 else p.2)) =
          (acc ||| (1 <<< if xSide then p.1 else p.2)) ||| bit := by
      rw [Nat.or_assoc, Nat.or_comm bit, ← Nat.or_assoc]
    rw [hstep, ih]

lemma pairMask_cons (p : Nat × Nat) (ps : List (Nat × Nat)) (xSide : Bool) :
    pairMask (p :: ps) xSide =
      pairMask ps xSide ||| (1 <<< if xSide then p.1 else p.2) := by
  unfold pairMask
  simp only [List.foldl_cons]
  exact foldl_pairOr ps xSide 0 (1 <<< if xSide then p.1 else p.2)

theorem pairMask_testBit (ps : List (Nat × Nat)) (xSide : Bool) (k : Nat) :
    (pairMask ps xSide).testBit k = true ↔
      ∃ p ∈ ps, (if xSide then p.1 else p.2) = k := by
  induction ps with
  | nil => simp [pairMask]
  | cons p ps ih =>
    rw [pairMask_cons, Nat.testBit_or, testBit_shift_one]
    simp only [Bool.or_eq_true, decide_eq_true_eq]
    rw [ih]
    constructor
    · rintro (⟨q, hq, hkq⟩ | hk)
      · exact ⟨q, List.mem_cons_of_mem _ hq, hkq⟩
      · exact ⟨p, List.mem_cons_self, hk⟩
    · rintro ⟨q, hq, hk⟩
      rcases List.mem_cons.mp hq with rfl | hq
      · exact Or.inr hk
      · exact Or.inl ⟨q, hq, hk⟩

theorem xmask_testBit (t : Table) (q k : Nat) (hq : q < t.nI) :
    ((buildMasks t).1.getD q 0).testBit k = true ↔ ∃ p ∈ t.pairs q, p.1 = k := by
  have hs : q < (buildMasks t).1.size := by simp [buildMasks, hq]
  have hget : (buildMasks t).1.getD q 0 = (buildMasks t).1[q] := by simp [Array.getD, hs]
  have hmask : (buildMasks t).1[q] = pairMask (t.pairs q) true := by
    simp [buildMasks, Array.getElem_ofFn]
  rw [hget, hmask, pairMask_testBit]
  simp

theorem zmask_testBit (t : Table) (q k : Nat) (hq : q < t.nI) :
    ((buildMasks t).2.getD q 0).testBit k = true ↔ ∃ p ∈ t.pairs q, p.2 = k := by
  have hs : q < (buildMasks t).2.size := by simp [buildMasks, hq]
  have hget : (buildMasks t).2.getD q 0 = (buildMasks t).2[q] := by simp [Array.getD, hs]
  have hmask : (buildMasks t).2[q] = pairMask (t.pairs q) false := by
    simp [buildMasks, Array.getElem_ofFn]
  rw [hget, hmask, pairMask_testBit]
  simp

lemma packGo_bit (row : Nat) (cols : Array Nat) (t acc k : Nat)
    (hk : k < cols.size) (ht : t ≤ cols.size)
    (hacc : acc.testBit k = if t ≤ k then false else row.testBit (cols.getD k 0)) :
    (packRow.go row cols t acc).testBit k = row.testBit (cols.getD k 0) := by
  induction h : cols.size - t generalizing t acc with
  | zero =>
    rw [packRow.go.eq_1, if_pos (by omega : t ≥ cols.size)]
    have hnj : ¬ t ≤ k := by omega
    simp [hacc, hnj]
  | succ d ih =>
    have ht' : t < cols.size := by omega
    rw [packRow.go.eq_1, if_neg (by omega : ¬ t ≥ cols.size)]
    have hle : t + 1 ≤ cols.size := by omega
    have hdec : cols.size - (t + 1) = d := by omega
    have hacc' :
        (if row.testBit (cols.getD t 0) = true then acc ||| (1 <<< t) else acc).testBit k =
          if t + 1 ≤ k then false else row.testBit (cols.getD k 0) := by
      by_cases hb : row.testBit (cols.getD t 0) = true
      · rw [if_pos hb, Nat.testBit_or, testBit_shift_one]
        by_cases htk : t = k
        · subst htk
          rw [if_neg (Nat.not_succ_le_self t), decide_eq_true rfl, Bool.or_true]
          exact hb.symm
        · by_cases hle' : t ≤ k
          · have hgt : t + 1 ≤ k := by omega
            simp [hacc, hle', hgt, decide_eq_false htk, Bool.or_false]
          · have hlt : ¬ t + 1 ≤ k := by omega
            simp [hacc, hle', hlt, decide_eq_false htk, Bool.or_false]
      · have hb' : row.testBit (cols.getD t 0) = false := by
          cases hbit : row.testBit (cols.getD t 0)
          · rfl
          · exact absurd hbit hb
        rw [if_neg hb]
        by_cases htk : t = k
        · subst htk
          rw [if_neg (Nat.not_succ_le_self t), hacc, if_pos (Nat.le_refl t)]
          exact hb'.symm
        · by_cases hle' : t ≤ k
          · have hgt : t + 1 ≤ k := by omega
            simp [hacc, hle', hgt]
          · have hlt : ¬ t + 1 ≤ k := by omega
            simp [hacc, hle', hlt]
    have hzeta :
        (let j := cols.getD t 0;
          packRow.go row cols (t + 1)
            (if row.testBit j = true then acc ||| (1 <<< t) else acc)).testBit k =
          (packRow.go row cols (t + 1)
            (if row.testBit (cols.getD t 0) = true then acc ||| (1 <<< t) else acc)).testBit k := by
      rfl
    rw [hzeta]
    exact ih (t + 1) (if row.testBit (cols.getD t 0) = true then acc ||| (1 <<< t) else acc)
      hle hacc' hdec

theorem packRow_testBit (row : Nat) (cols : Array Nat) (k : Nat) (hk : k < cols.size) :
    (packRow row cols).testBit k = row.testBit (cols.getD k 0) := by
  unfold packRow
  exact packGo_bit row cols 0 0 k hk (Nat.zero_le _) (by simp)

lemma setBits_go_mem (mask t : Nat) (acc : Array Nat) (i : Nat) (ht : t ≤ 720)
    (hacc : ∀ j, j ∈ acc.toList ↔ j < t ∧ mask.testBit j = true) :
    i ∈ (setBits.go mask t acc).toList ↔ i < 720 ∧ mask.testBit i = true := by
  induction h : 720 - t generalizing t acc with
  | zero =>
    rw [setBits.go.eq_1, if_pos (by omega : t ≥ 720)]
    have hi : i < 720 → i < t := by intro; omega
    constructor
    · intro hm
      have ⟨hlt, hb⟩ := (hacc i).mp hm
      exact ⟨Nat.lt_of_lt_of_le hlt ht, hb⟩
    · intro ⟨hlt, hb⟩
      exact (hacc i).mpr ⟨hi hlt, hb⟩
  | succ d ih =>
    have ht' : t < 720 := by omega
    rw [setBits.go.eq_1, if_neg (by omega : ¬ t ≥ 720)]
    have hle : t + 1 ≤ 720 := by omega
    have hdec : 720 - (t + 1) = d := by omega
    by_cases hb : mask.testBit t = true
    · rw [if_pos hb]
      apply ih (t + 1) (acc.push t) hle _ hdec
      intro j
      simp only [Array.toList_push, List.mem_append, List.mem_singleton, hacc]
      constructor
      · intro h
        rcases h with ⟨hj, hbit⟩ | hjt
        · exact ⟨Nat.lt_succ_of_lt hj, hbit⟩
        · cases hjt
          exact ⟨Nat.lt_succ_self _, hb⟩
      · intro ⟨hj, hbit⟩
        rcases Nat.lt_succ_iff_lt_or_eq.mp hj with hlt | hjt
        · exact Or.inl ⟨hlt, hbit⟩
        · cases hjt
          exact Or.inr rfl
    · have hb' : mask.testBit t = false := by
        cases hbit : mask.testBit t
        · rfl
        · exact absurd hbit hb
      rw [if_neg (by simp [hb'])]
      apply ih (t + 1) acc hle _ hdec
      intro j
      simp only [hacc]
      constructor
      · intro ⟨hj, hbit⟩
        exact ⟨Nat.lt_succ_of_lt hj, hbit⟩
      · intro ⟨hj, hbit⟩
        rcases Nat.lt_succ_iff_lt_or_eq.mp hj with hlt | hjt
        · exact ⟨hlt, hbit⟩
        · cases hjt
          simp [hb'] at hbit

theorem setBits_mem (mask i : Nat) :
    i ∈ (setBits mask).toList ↔ i < 720 ∧ mask.testBit i = true := by
  unfold setBits
  exact setBits_go_mem mask 0 #[] i (Nat.zero_le _) (by simp)

end C16Frames.CertInvariant
