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
      resBit res c k ^^ (decide (c = t) && xi.testBit t && zj.testBit k) := by
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

end C16Frames.CertInvariant
