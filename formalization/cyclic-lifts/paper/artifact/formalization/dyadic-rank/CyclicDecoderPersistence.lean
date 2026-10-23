import CyclicMergedMessages

/-! Deterministic persistence certificates for the fixed min-sum decoder.
Reachability from the channel error is supplied separately by independent replay.
An interval certificate concerns the remaining fixed horizon, not causation. -/
set_option maxRecDepth 20000
set_option maxHeartbeats 8000000
namespace CyclicDecoderPersistence
open CyclicMergedMessages

/-- Check a finite family with a Boolean list fold, avoiding nested dependent deciders. -/
theorem checked_all {n : Nat} (p : Fin n → Prop) [DecidablePred p]
    (h : (List.finRange n).all (fun i => decide (p i)) = true) : ∀ i, p i := by
  intro i
  have hi : decide (p i) = true := List.all_eq_true.mp h i (by simp)
  exact of_decide_eq_true hi

def orbit {S : Type*} (step : S → S) (x : S) : Nat → S
  | 0 => x
  | n+1 => step (orbit step x n)

/-- A forward-closed rejecting region prevents any subsequent acceptance. -/
theorem invariant_rejects {S : Type*} (step : S → S) (accept : S → Prop)
    (region : S → Prop) (x : S) (hx : region x)
    (closed : ∀ y, region y → region (step y))
    (rejects : ∀ y, region y → ¬accept y) :
    ∀ n, ¬accept (orbit step x n) := by
  have h : ∀ n, region (orbit step x n) := by
    intro n
    induction n with
    | zero => exact hx
    | succ n ih => exact closed _ ih
  exact fun n => rejects _ (h n)

/-- An exact fixed incoming-message state with a rejected output is permanent. -/
theorem fixed_point_rejects {S : Type*} (step : S → S) (accept : S → Prop)
    (x : S) (fixed : step x = x) (rejected : ¬accept x) :
    ∀ n, ¬accept (orbit step x n) := by
  apply invariant_rejects step accept (· = x) x rfl
  · intro y hy
    simpa [hy] using fixed
  · intro y hy
    simpa [hy] using rejected

/-- A finite closed collection of rejected message states is a periodic trap. -/
theorem closed_states_reject {S : Type*} (step : S → S) (accept : S → Prop)
    (states : List S) (x : S) (hx : x ∈ states)
    (closed : ∀ y ∈ states, step y ∈ states)
    (rejected : ∀ y ∈ states, ¬accept y) :
    ∀ n, ¬accept (orbit step x n) :=
  invariant_rejects step accept (· ∈ states) x hx closed rejected

/-- Time-dependent enclosures can certify the entire remaining finite horizon. -/
theorem horizon_rejects {S : Type*} (step : S → S) (accept : S → Prop)
    (region : Nat → S → Prop) (x : S) (horizon : Nat)
    (initial : region 0 x)
    (encloses : ∀ k, k < horizon → ∀ y, region k y → region (k+1) (step y))
    (rejects : ∀ k, k ≤ horizon → ∀ y, region k y → ¬accept y) :
    ∀ k, k ≤ horizon → ¬accept (orbit step x k) := by
  have h : ∀ k, k ≤ horizon → region k (orbit step x k) := by
    intro k
    induction k with
    | zero => intro _; exact initial
    | succ k ih =>
      intro hk
      exact encloses k (by omega) _ (ih (by omega))
  exact fun k hk => rejects k hk _ (h k hk)

structure Interval where
  lo : Int
  hi : Int
  deriving DecidableEq, Repr, Inhabited

def In (b : Interval) (x : Int) : Prop := b.lo ≤ x ∧ x ≤ b.hi
instance (b : Interval) (x : Int) : Decidable (In b x) := inferInstanceAs (Decidable (_ ∧ _))

def absLower (b : Interval) : Nat :=
  if b.lo ≤ 0 ∧ 0 ≤ b.hi then 0 else min b.lo.natAbs b.hi.natAbs

def absUpper (b : Interval) : Nat := max b.lo.natAbs b.hi.natAbs

set_option maxHeartbeats 200000 in
theorem abs_bounds (b : Interval) (x : Int) (hx : In b x) :
    absLower b ≤ x.natAbs ∧ x.natAbs ≤ absUpper b := by
  have hp (z : Int) (hz : 0 ≤ z) : (z.natAbs : Int) = z := Int.natAbs_of_nonneg hz
  have hn (z : Int) (hz : z ≤ 0) : (z.natAbs : Int) = -z := by
    rw [Int.natCast_natAbs, abs_of_nonpos hz]
  unfold absLower absUpper
  unfold In at hx
  split_ifs with cross
  · constructor
    · omega
    · by_cases xpos : 0 ≤ x
      · have hxi := hp x xpos
        have hhi := hp b.hi cross.2
        omega
      · have hxi := hn x (by omega)
        have hlo := hn b.lo cross.1
        omega
  · by_cases lpos : 0 ≤ b.lo
    · have xpos : 0 ≤ x := by omega
      have hipos : 0 ≤ b.hi := by omega
      have hl := hp b.lo lpos
      have hx' := hp x xpos
      have hh := hp b.hi hipos
      constructor <;> omega
    · have hineg : b.hi < 0 := by omega
      have hl := hn b.lo (by omega)
      have hx' := hn x (by omega)
      have hh := hn b.hi (by omega)
      constructor <;> omega

def lowerMagnitude : List Interval → Nat
  | [] => sentinel
  | b :: bs => min (absLower b) (lowerMagnitude bs)

def upperMagnitude : List Interval → Nat
  | [] => sentinel
  | b :: bs => min (absUpper b) (upperMagnitude bs)

def signRange (b : Interval) : Option Bool :=
  if b.hi < 0 then some true else if 0 ≤ b.lo then some false else none

def xorKnown : Option Bool → Option Bool → Option Bool
  | some a, some b => some (a ^^ b)
  | _, _ => none

def knownSign : List Interval → Option Bool
  | [] => some false
  | b :: bs => xorKnown (signRange b) (knownSign bs)

def intervalCheck (s : Bool) (bs : List Interval) : Interval :=
  let lo := (CyclicMergedMessages.normalize (lowerMagnitude bs) : Int)
  let hi := (CyclicMergedMessages.normalize (upperMagnitude bs) : Int)
  match knownSign bs with
  | none => ⟨-hi, hi⟩
  | some p => if s ^^ p then ⟨-hi, -lo⟩ else ⟨lo, hi⟩

theorem magnitude_bounds {xs : List Int} {bs : List Interval}
    (h : List.Forall₂ (fun x b => In b x) xs bs) :
    lowerMagnitude bs ≤ magnitude xs ∧ magnitude xs ≤ upperMagnitude bs := by
  induction h with
  | nil => exact ⟨le_rfl, le_rfl⟩
  | @cons x b xs bs hx h ih =>
    obtain ⟨hl, hu⟩ := abs_bounds b x hx
    exact ⟨min_le_min hl ih.1, min_le_min hu ih.2⟩

theorem signRange_sound (b : Interval) (x : Int) (hx : In b x)
    (p : Bool) (h : signRange b = some p) : decide (x < 0) = p := by
  unfold signRange at h
  split_ifs at h with neg nonneg
  · have hp : p = true := by simpa using h.symm
    subst p
    simp only [decide_eq_true_eq]
    unfold In at hx
    omega
  · have hp : p = false := by simpa using h.symm
    subst p
    simp only [decide_eq_false_iff_not]
    unfold In at hx
    omega

theorem knownSign_sound {xs : List Int} {bs : List Interval}
    (h : List.Forall₂ (fun x b => In b x) xs bs) :
    ∀ p, knownSign bs = some p → signs xs = p := by
  induction h with
  | nil => intro p hp; simpa [knownSign, signs] using hp
  | @cons x b xs bs hx h ih =>
    intro p hp
    cases hb : signRange b with
    | none => simp [knownSign, hb, xorKnown] at hp
    | some u =>
      cases ht : knownSign bs with
      | none => simp [knownSign, hb, ht, xorKnown] at hp
      | some v =>
        have hp' : (u ^^ v) = p := by simpa [knownSign, hb, ht, xorKnown] using hp
        rw [signs, signRange_sound b x hx u hb, ih v ht]
        exact hp'

/-- The interval check update encloses the exact sign/minimum/rounding update. -/
theorem intervalCheck_sound (s : Bool) {xs : List Int} {bs : List Interval}
    (h : List.Forall₂ (fun x b => In b x) xs bs) :
    In (intervalCheck s bs) (check s xs) := by
  obtain ⟨hl, hu⟩ := magnitude_bounds h
  have hnl := normalize_mono hl
  have hnu := normalize_mono hu
  unfold intervalCheck
  cases hp : knownSign bs with
  | none =>
    simp only [In, check]
    cases t : (s ^^ signs xs) <;> simp only [signed, Bool.false_eq_true, ↓reduceIte] <;>
      constructor <;> omega
  | some p =>
    have hs := knownSign_sound h p hp
    simp only [In, check, hs]
    cases t : (s ^^ p) <;> simp only [signed, Bool.false_eq_true, ↓reduceIte] <;>
      constructor <;> omega

section Decoder
variable {E V C : Type*} [DecidableEq E]

structure Decoder (E V C : Type*) where
  checks : C → List E
  incident : V → List E
  edgeCheck : E → C
  edgeVariable : E → V
  rows : C → List V

def incomingEdges (d : Decoder E V C) (e : E) : List E :=
  (d.checks (d.edgeCheck e)).filter (· != e)

def variableOthers (d : Decoder E V C) (e : E) : List E :=
  (d.incident (d.edgeVariable e)).filter (· != e)

def messages (d : Decoder E V C) (s : C → Bool) (q : E → Int) (e : E) : Int :=
  check (s (d.edgeCheck e)) ((incomingEdges d e).map q)

def posterior (d : Decoder E V C) (s : C → Bool) (q : E → Int) (v : V) : Int :=
  prior + ((d.incident v).map (messages d s q)).sum

def next (d : Decoder E V C) (s : C → Bool) (q : E → Int) (e : E) : Int :=
  clip (prior + ((variableOthers d e).map (messages d s q)).sum)

theorem sum_filter_self (es : List E) (e : E) (f : E → Int)
    (unique : es.Nodup) (present : e ∈ es) :
    (es.map f).sum = f e + ((es.filter (· != e)).map f).sum := by
  induction es with
  | nil => simp at present
  | cons a es ih =>
    have un := List.nodup_cons.mp unique
    by_cases same : a = e
    · subst a
      have filtered : es.filter (· != e) = es := by
        apply List.filter_eq_self.mpr
        intro b hb
        simp only [bne_iff_ne]
        intro eq
        exact un.1 (eq ▸ hb)
      simp [filtered]
    · have mem : e ∈ es := (List.mem_cons.mp present).resolve_left (Ne.symm same)
      have rest := ih un.2 mem
      simp only [List.map_cons, List.sum_cons, List.filter_cons, bne_iff_ne,
        ite_eq_left same, List.map_cons, List.sum_cons]
      omega

/-- With the actual unique incident-edge lists, excluded-edge and posterior-minus-own agree. -/
theorem next_eq_posterior_sub (d : Decoder E V C) (s : C → Bool) (q : E → Int)
    (e : E) (unique : (d.incident (d.edgeVariable e)).Nodup)
    (present : e ∈ d.incident (d.edgeVariable e)) :
    next d s q e = clip (posterior d s q (d.edgeVariable e) - messages d s q e) := by
  have h := sum_filter_self (d.incident (d.edgeVariable e)) e (messages d s q) unique present
  unfold next variableOthers posterior
  congr 1
  omega

def Accept (d : Decoder E V C) (s : C → Bool) (q : E → Int) : Prop :=
  ∀ c, signs ((d.rows c).map (posterior d s q)) = s c

def boxMessages (d : Decoder E V C) (s : C → Bool) (box : E → Interval) (e : E) : Interval :=
  intervalCheck (s (d.edgeCheck e)) ((incomingEdges d e).map box)

def sumBox (bs : List Interval) : Interval :=
  ⟨prior + (bs.map Interval.lo).sum, prior + (bs.map Interval.hi).sum⟩

def boxPosterior (d : Decoder E V C) (s : C → Bool) (box : E → Interval) (v : V) : Interval :=
  sumBox ((d.incident v).map (boxMessages d s box))

def boxNext (d : Decoder E V C) (s : C → Bool) (box : E → Interval) (e : E) : Interval :=
  let p := sumBox ((variableOthers d e).map (boxMessages d s box))
  ⟨clip p.lo, clip p.hi⟩

def InBox (box : E → Interval) (q : E → Int) : Prop := ∀ e, In (box e) (q e)

theorem forall₂_mapped {A : Type*} (xs : List A) (f : A → Int) (g : A → Interval)
    (h : ∀ a, In (g a) (f a)) :
    List.Forall₂ (fun x b => In b x) (xs.map f) (xs.map g) := by
  induction xs with
  | nil => exact .nil
  | cons a xs ih => exact .cons (h a) ih

theorem sum_bounds {xs : List Int} {bs : List Interval}
    (h : List.Forall₂ (fun x b => In b x) xs bs) :
    (bs.map Interval.lo).sum ≤ xs.sum ∧ xs.sum ≤ (bs.map Interval.hi).sum := by
  induction h with
  | nil => exact ⟨le_rfl, le_rfl⟩
  | @cons x b xs bs hx h ih =>
    simp only [List.map_cons, List.sum_cons]
    unfold In at hx
    constructor <;> omega

theorem clip_mono {a b : Int} (h : a ≤ b) : clip a ≤ clip b := by
  unfold clip
  exact max_le_max_left _ (min_le_min_left _ h)

theorem boxMessages_sound (d : Decoder E V C) (s : C → Bool)
    (box : E → Interval) (q : E → Int) (h : InBox box q) (e : E) :
    In (boxMessages d s box e) (messages d s q e) :=
  intervalCheck_sound _ (forall₂_mapped _ q box h)

theorem boxPosterior_sound (d : Decoder E V C) (s : C → Bool)
    (box : E → Interval) (q : E → Int) (h : InBox box q) (v : V) :
    In (boxPosterior d s box v) (posterior d s q v) := by
  obtain ⟨hl, hu⟩ := sum_bounds
    (forall₂_mapped (d.incident v) (messages d s q) (boxMessages d s box)
      (boxMessages_sound d s box q h))
  change prior + _ ≤ prior + _ ∧ prior + _ ≤ prior + _
  constructor <;> omega

/-- One interval propagation step encloses every exact decoder update. -/
theorem boxNext_sound (d : Decoder E V C) (s : C → Bool)
    (box : E → Interval) (q : E → Int) (h : InBox box q) :
    InBox (boxNext d s box) (next d s q) := by
  intro e
  obtain ⟨hl, hu⟩ := sum_bounds
    (forall₂_mapped (variableOthers d e) (messages d s q) (boxMessages d s box)
      (boxMessages_sound d s box q h))
  change clip (prior + _) ≤ clip (prior + _) ∧ clip (prior + _) ≤ clip (prior + _)
  constructor <;> apply clip_mono <;> omega

/-- A uniformly wrong parity check rejects every state in the box. -/
theorem box_check_rejects (d : Decoder E V C) (s : C → Bool)
    (box : E → Interval) (q : E → Int) (h : InBox box q)
    (c : C) (p : Bool)
    (known : knownSign ((d.rows c).map (boxPosterior d s box)) = some p)
    (wrong : p ≠ s c) : ¬Accept d s q := by
  intro accepted
  apply wrong
  have hs := knownSign_sound
    (forall₂_mapped (d.rows c) (posterior d s q) (boxPosterior d s box)
      (boxPosterior_sound d s box q h)) p known
  exact hs.symm.trans (accepted c)

/-- An invariant message box with a uniformly wrong check is an infinite trap. -/
theorem invariant_box_rejects (d : Decoder E V C) (s : C → Bool)
    (box : E → Interval) (q : E → Int) (initial : InBox box q)
    (encloses : ∀ e, (box e).lo ≤ (boxNext d s box e).lo ∧
      (boxNext d s box e).hi ≤ (box e).hi)
    (c : C) (p : Bool)
    (known : knownSign ((d.rows c).map (boxPosterior d s box)) = some p)
    (wrong : p ≠ s c) : ∀ n, ¬Accept d s (orbit (next d s) q n) := by
  apply invariant_rejects (next d s) (Accept d s) (InBox box) q initial
  · intro y hy e
    have hs := boxNext_sound d s box y hy e
    exact ⟨le_trans (encloses e).1 hs.1, le_trans hs.2 (encloses e).2⟩
  · intro y hy
    exact box_check_rejects d s box y hy c p known wrong

/-- The exact trajectory stays in a supplied sound sequence of interval boxes. -/
theorem tube_contains (d : Decoder E V C) (s : C → Bool)
    (boxes : Nat → E → Interval) (q : E → Int) (horizon : Nat)
    (initial : InBox (boxes 0) q)
    (encloses : ∀ k, k < horizon → ∀ e,
      (boxes (k+1) e).lo ≤ (boxNext d s (boxes k) e).lo ∧
      (boxNext d s (boxes k) e).hi ≤ (boxes (k+1) e).hi) :
    ∀ k, k ≤ horizon → InBox (boxes k) (orbit (next d s) q k) := by
  intro k
  induction k with
  | zero => intro _; exact initial
  | succ k ih =>
    intro hk e
    have hs := boxNext_sound d s (boxes k) (orbit (next d s) q k) (ih (by omega)) e
    have hb := encloses k (by omega) e
    exact ⟨le_trans hb.1 hs.1, le_trans hs.2 hb.2⟩

/-- Sound time-varying enclosures plus rejecting checks certify all remaining updates. -/
theorem tube_rejects (d : Decoder E V C) (s : C → Bool)
    (boxes : Nat → E → Interval) (q : E → Int) (horizon : Nat)
    (initial : InBox (boxes 0) q)
    (encloses : ∀ k, k < horizon → ∀ e,
      (boxes (k+1) e).lo ≤ (boxNext d s (boxes k) e).lo ∧
      (boxNext d s (boxes k) e).hi ≤ (boxes (k+1) e).hi)
    (rejects : ∀ k, k ≤ horizon → ∃ c p,
      knownSign ((d.rows c).map (boxPosterior d s (boxes k))) = some p ∧ p ≠ s c) :
    ∀ k, k ≤ horizon → ¬Accept d s (orbit (next d s) q k) := by
  apply horizon_rejects (next d s) (Accept d s) (fun k => InBox (boxes k)) q horizon initial
  · intro k hk y hy e
    have hstep := boxNext_sound d s (boxes k) y hy e
    have hb := encloses k hk e
    exact ⟨le_trans hb.1 hstep.1, le_trans hstep.2 hb.2⟩
  · intro k hk y hy
    obtain ⟨c, p, known, wrong⟩ := rejects k hk
    exact box_check_rejects d s (boxes k) y hy c p known wrong

end Decoder

end CyclicDecoderPersistence
#print axioms CyclicDecoderPersistence.invariant_rejects
#print axioms CyclicDecoderPersistence.closed_states_reject
#print axioms CyclicDecoderPersistence.intervalCheck_sound
#print axioms CyclicDecoderPersistence.boxNext_sound
#print axioms CyclicDecoderPersistence.tube_rejects

#print axioms CyclicDecoderPersistence.invariant_box_rejects
