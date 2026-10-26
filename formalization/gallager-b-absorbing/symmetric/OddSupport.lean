import Std

/-! General binary CSS parity obstruction. The physical length and both finite
check lists are arbitrary. No finite enumeration of codes or decoders is used. -/
namespace CSSOddSupport
set_option maxHeartbeats 0

abbrev Word (n : Nat) := Fin n → Bool

def zero : Word n := fun _ => false
def xor (x y : Word n) : Word n := fun i => Bool.xor (x i) (y i)

def dotOn (coords : List α) (x y : α → Bool) : Bool :=
  match coords with
  | [] => false
  | i :: rest => Bool.xor (x i && y i) (dotOn rest x y)

def dot (x y : Word n) : Bool := dotOn (List.finRange n) x y

def weightOn (coords : List α) (x : α → Bool) : Nat := (coords.filter x).length

def weight (x : Word n) : Nat := weightOn (List.finRange n) x

def Odd (x : Word n) : Prop := weight x % 2 = 1

theorem bool_and_xor (a b c : Bool) :
  ((Bool.xor a b) && c) = Bool.xor (a && c) (b && c) := by decide +revert

theorem xor_shuffle (a b c d : Bool) :
  Bool.xor (Bool.xor a b) (Bool.xor c d) =
    Bool.xor (Bool.xor a c) (Bool.xor b d) := by decide +revert

theorem dotOn_comm (coords : List α) (x y : α → Bool) :
  dotOn coords x y = dotOn coords y x := by
  induction coords with
  | nil => rfl
  | cons i rest ih => simp only [dotOn, Bool.and_comm, ih]

theorem dot_comm (x y : Word n) : dot x y = dot y x := dotOn_comm _ _ _

theorem dotOn_zero_left (coords : List α) (x : α → Bool) :
  dotOn coords (fun _ => false) x = false := by
  induction coords with
  | nil => rfl
  | cons i rest ih => simp [dotOn, ih]

theorem dot_zero_left (x : Word n) : dot zero x = false := dotOn_zero_left _ _

theorem dot_zero_right (x : Word n) : dot x zero = false := by
  rw [dot_comm, dot_zero_left]

theorem dotOn_xor_left (coords : List α) (x y z : α → Bool) :
  dotOn coords (fun i => Bool.xor (x i) (y i)) z =
    Bool.xor (dotOn coords x z) (dotOn coords y z) := by
  induction coords with
  | nil => rfl
  | cons i rest ih =>
    simp only [dotOn, bool_and_xor, ih]
    exact xor_shuffle _ _ _ _

theorem dot_xor_left (x y z : Word n) :
  dot (xor x y) z = Bool.xor (dot x z) (dot y z) := dotOn_xor_left _ _ _ _

theorem dot_xor_right (x y z : Word n) :
  dot x (xor y z) = Bool.xor (dot x y) (dot x z) := by
  rw [dot_comm x, dot_xor_left, dot_comm y x, dot_comm z x]

theorem parity_succ (k : Nat) :
  Bool.xor true (decide (k % 2 = 1)) = decide ((k + 1) % 2 = 1) := by
  have h : k % 2 = 0 ∨ k % 2 = 1 := by omega
  rcases h with h | h <;> simp [Nat.add_mod, h]

theorem dotOn_self_weight (coords : List α) (x : α → Bool) :
  dotOn coords x x = decide (weightOn coords x % 2 = 1) := by
  induction coords with
  | nil => rfl
  | cons i rest ih =>
    rw [dotOn, ih]
    cases hx : x i with
    | false =>
      have hw : weightOn (i :: rest) x = weightOn rest x := by simp [weightOn, hx]
      rw [hw]
      exact Bool.false_xor _
    | true =>
      have hw : weightOn (i :: rest) x = weightOn rest x + 1 := by simp [weightOn, hx]
      rw [hw]
      exact parity_succ (weightOn rest x)

theorem dot_self_weight (x : Word n) :
  dot x x = decide (weight x % 2 = 1) := dotOn_self_weight _ _

theorem odd_dot_self (x : Word n) (h : Odd x) : dot x x = true := by
  rw [dot_self_weight]
  exact decide_eq_true h

-- The least set containing the actual rows and closed under binary addition.
inductive Span (rows : List (Word n)) : Word n → Prop
  | zero : Span rows zero
  | row {r : Word n} : r ∈ rows → Span rows r
  | xor {x y : Word n} : Span rows x → Span rows y → Span rows (xor x y)

theorem span_minimal {rows : List (Word n)} {P : Word n → Prop}
  (hzero : P zero) (hrows : ∀ r, r ∈ rows → P r)
  (hxor : ∀ x y, P x → P y → P (xor x y))
  {w : Word n} (hw : Span rows w) : P w := by
  induction hw with
  | zero => exact hzero
  | row hr => exact hrows _ hr
  | xor hx hy ihx ihy => exact hxor _ _ ihx ihy

def CSS (hx hz : List (Word n)) : Prop :=
  ∀ x, x ∈ hx → ∀ z, z ∈ hz → dot x z = false

def SameSpan (hx hz : List (Word n)) : Prop :=
  ∀ w, Span hx w ↔ Span hz w

theorem row_orthogonal_span {rows : List (Word n)} (x : Word n)
  (h : ∀ z, z ∈ rows → dot x z = false)
  {z : Word n} (hz : Span rows z) : dot x z = false := by
  induction hz with
  | zero => exact dot_zero_right x
  | row hr => exact h _ hr
  | xor hu hv ihu ihv => rw [dot_xor_right, ihu, ihv]; rfl

theorem css_spans_commute {hx hz : List (Word n)} (hcss : CSS hx hz)
  {x z : Word n} (hX : Span hx x) (hZ : Span hz z) : dot x z = false := by
  induction hX with
  | zero => exact dot_zero_left z
  | row hr => exact row_orthogonal_span _ (hcss _ hr) hZ
  | xor hu hv ihu ihv => rw [dot_xor_left, ihu, ihv]; rfl

theorem equal_spans_self_orthogonal {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz)
  {w : Word n} (hw : Span hz w) : dot w w = false := by
  exact css_spans_commute hcss ((hsame w).mpr hw) hw

theorem equal_spans_even_stabilizers {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz)
  {w : Word n} (hw : Span hz w) : weight w % 2 = 0 := by
  have h := equal_spans_self_orthogonal hcss hsame hw
  rw [dot_self_weight] at h
  have hn : ¬ weight w % 2 = 1 := by simpa using h
  omega

theorem odd_not_stabilizer {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz)
  (a : Word n) (hodd : Odd a) : ¬ Span hz a := by
  intro ha
  have h0 := equal_spans_self_orthogonal hcss hsame ha
  have h1 := odd_dot_self a hodd
  rw [h1] at h0
  contradiction

def ZeroSyndrome (rows : List (Word n)) (a : Word n) : Prop :=
  ∀ r, r ∈ rows → dot r a = false

def LogicalZ (hx hz : List (Word n)) (a : Word n) : Prop :=
  ZeroSyndrome hx a ∧ ¬ Span hz a

def oddChecks (rows : List (Word n)) (a : Word n) : List (Word n) :=
  rows.filter (fun r => dot r a)

def bValue (rows : List (Word n)) (a : Word n) : Nat := (oddChecks rows a).length

theorem zero_b_iff_zero_syndrome (rows : List (Word n)) (a : Word n) :
  bValue rows a = 0 ↔ ZeroSyndrome rows a := by
  simp [bValue, oddChecks, List.filter_eq_nil_iff, ZeroSyndrome]

theorem odd_zero_syndrome_logical {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hodd : Odd a) (hzero : ZeroSyndrome hx a) : LogicalZ hx hz a := by
  exact ⟨hzero, odd_not_stabilizer hcss hsame a hodd⟩

theorem odd_zero_b_logical {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hodd : Odd a) (hb : bValue hx a = 0) : LogicalZ hx hz a := by
  exact odd_zero_syndrome_logical hcss hsame a hodd
    ((zero_b_iff_zero_syndrome hx a).mp hb)

theorem identical_rows_same_span (rows : List (Word n)) : SameSpan rows rows := by
  intro w
  rfl

theorem identical_matrix_odd_zero_b {rows : List (Word n)}
  (hcss : CSS rows rows) (a : Word n)
  (hodd : Odd a) (hb : bValue rows a = 0) : LogicalZ rows rows a := by
  exact odd_zero_b_logical hcss (identical_rows_same_span rows) a hodd hb

def syndrome (rows : List (Word n)) (a : Word n) : List Bool :=
  rows.map (fun r => dot r a)

theorem zero_syndrome_equal (rows : List (Word n)) (a : Word n)
  (h : ZeroSyndrome rows a) : syndrome rows a = syndrome rows zero := by
  apply List.map_congr_left
  intro r hr
  rw [h r hr, dot_zero_right]

theorem xor_zero_left (x : Word n) : xor zero x = x := by
  funext i
  simp [xor, zero]

theorem xor_cancel_right (x y : Word n) : xor (xor x y) y = x := by
  funext i
  change Bool.xor (Bool.xor (x i) (y i)) (y i) = x i
  cases x i <;> cases y i <;> rfl

-- A decoder sees the syndrome only, and success is modulo the entire Z span.
abbrev Decoder (n : Nat) := List Bool → Word n

def Corrects (hx hz : List (Word n)) (decoder : Decoder n) (e : Word n) : Prop :=
  Span hz (xor e (decoder (syndrome hx e)))

theorem cannot_correct_identity_and_odd_support {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hodd : Odd a) (hzero : ZeroSyndrome hx a) (decoder : Decoder n) :
  ¬ (Corrects hx hz decoder zero ∧ Corrects hx hz decoder a) := by
  intro ⟨h0,ha⟩
  unfold Corrects at h0 ha
  rw [xor_zero_left] at h0
  rw [zero_syndrome_equal hx a hzero] at ha
  have hr := Span.xor ha h0
  rw [xor_cancel_right] at hr
  exact odd_not_stabilizer hcss hsame a hodd hr

def Supported (e a : Word n) : Prop := ∀ i, e i = true → a i = true

def CorrectsSupported (hx hz : List (Word n)) (decoder : Decoder n) (a : Word n) : Prop :=
  ∀ e, Supported e a → Corrects hx hz decoder e

theorem zero_supported (a : Word n) : Supported zero a := by
  intro i h
  contradiction

theorem self_supported (a : Word n) : Supported a a := by
  intro i h
  exact h

theorem no_universal_supported_recovery {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hodd : Odd a) (hb : bValue hx a = 0) (decoder : Decoder n) :
  ¬ CorrectsSupported hx hz decoder a := by
  intro hall
  exact cannot_correct_identity_and_odd_support hcss hsame a hodd
    ((zero_b_iff_zero_syndrome hx a).mp hb) decoder
    ⟨hall zero (zero_supported a), hall a (self_supported a)⟩

-- Induced check degree is the Hamming weight of the coordinate intersection.
def intersectionWeight (x y : Word n) : Nat := weight (fun i => x i && y i)

theorem dotOn_intersection_self (coords : List α) (x y : α → Bool) :
  dotOn coords x y = dotOn coords (fun i => x i && y i) (fun i => x i && y i) := by
  induction coords with
  | nil => rfl
  | cons i rest ih => simp only [dotOn, Bool.and_self, ih]

theorem dot_intersection_weight (x y : Word n) :
  dot x y = decide (intersectionWeight x y % 2 = 1) := by
  unfold dot
  rw [dotOn_intersection_self, dotOn_self_weight]
  rfl

theorem dot_false_iff_even_intersection (x y : Word n) :
  dot x y = false ↔ intersectionWeight x y % 2 = 0 := by
  rw [dot_intersection_weight]
  constructor
  · intro h
    have hn : ¬ intersectionWeight x y % 2 = 1 := by simpa using h
    omega
  · intro h
    simp [h]

theorem zero_b_iff_induced_even (rows : List (Word n)) (a : Word n) :
  bValue rows a = 0 ↔ ∀ r, r ∈ rows → intersectionWeight r a % 2 = 0 := by
  rw [zero_b_iff_zero_syndrome]
  constructor
  · intro h r hr
    exact (dot_false_iff_even_intersection r a).mp (h r hr)
  · intro h r hr
    exact (dot_false_iff_even_intersection r a).mpr (h r hr)

def oddNeighborCount (rows : List (Word n)) (a : Word n) (i : Fin n) : Nat :=
  (rows.filter (fun r => r i && dot r a)).length

def evenNeighborCount (rows : List (Word n)) (a : Word n) (i : Fin n) : Nat :=
  (rows.filter (fun r => r i && !(dot r a))).length

def Absorbing (rows : List (Word n)) (a : Word n) : Prop :=
  0 < weight a ∧ ∀ i, a i = true → oddNeighborCount rows a i < evenNeighborCount rows a i

theorem odd_absorbing_no_recovery {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (_habs : Absorbing hx a) (hodd : Odd a) (hb : bValue hx a = 0)
  (decoder : Decoder n) : ¬ CorrectsSupported hx hz decoder a := by
  exact no_universal_supported_recovery hcss hsame a hodd hb decoder

theorem odd_stabilizer_forbids_equal_spaces {hx hz : List (Word n)}
  (hcss : CSS hx hz) (a : Word n) (ha : Span hz a) (hodd : Odd a) :
  ¬ SameSpan hx hz := by
  intro hs
  exact odd_not_stabilizer hcss hs a hodd ha

-- The common-matrix presentation retains the original X decoding rows.
theorem common_matrix_css {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) : CSS hx hx := by
  intro x hxmem z hzmem
  exact css_spans_commute hcss (Span.row hxmem) ((hsame z).mp (Span.row hzmem))

theorem common_matrix_recovery_iff {hx hz : List (Word n)}
  (hsame : SameSpan hx hz) (decoder : Decoder n) (e : Word n) :
  Corrects hx hz decoder e ↔ Corrects hx hx decoder e := by
  exact (hsame _).symm

theorem common_matrix_supported_recovery_iff {hx hz : List (Word n)}
  (hsame : SameSpan hx hz) (decoder : Decoder n) (a : Word n) :
  CorrectsSupported hx hz decoder a ↔ CorrectsSupported hx hx decoder a := by
  constructor
  · intro h e he
    exact (common_matrix_recovery_iff hsame decoder e).mp (h e he)
  · intro h e he
    exact (common_matrix_recovery_iff hsame decoder e).mpr (h e he)

def Stabilizer (hx hz : List (Word n)) (p : Word n × Word n) : Prop :=
  Span hx p.1 ∧ Span hz p.2

def restrict (w cut : Word n) : Word n := fun i => w i && cut i

def SplitsAcross (hx hz : List (Word n)) (cut : Word n) : Prop :=
  ∀ p, Stabilizer hx hz p → Stabilizer hx hz (restrict p.1 cut, restrict p.2 cut)

theorem common_matrix_stabilizer_iff {hx hz : List (Word n)}
  (hsame : SameSpan hx hz) (p : Word n × Word n) :
  Stabilizer hx hz p ↔ Stabilizer hx hx p := by
  exact and_congr Iff.rfl (hsame p.2).symm

theorem common_matrix_product_cut_iff {hx hz : List (Word n)}
  (hsame : SameSpan hx hz) (cut : Word n) :
  SplitsAcross hx hz cut ↔ SplitsAcross hx hx cut := by
  constructor
  · intro h p hp
    exact (common_matrix_stabilizer_iff hsame _).mp
      (h p ((common_matrix_stabilizer_iff hsame p).mpr hp))
  · intro h p hp
    exact (common_matrix_stabilizer_iff hsame _).mpr
      (h p ((common_matrix_stabilizer_iff hsame p).mp hp))

-- For a common matrix, the same syndrome recovery map can decode both components.
def CorrectsPauli (rows : List (Word n)) (decoder : Decoder n) (e : Word n × Word n) : Prop :=
  Stabilizer rows rows
    (xor e.1 (decoder (syndrome rows e.1)), xor e.2 (decoder (syndrome rows e.2)))

theorem common_matrix_both_sectors {rows : List (Word n)} (decoder : Decoder n)
  (a : Word n) (h : CorrectsSupported rows rows decoder a)
  (e : Word n × Word n) (hx : Supported e.1 a) (hz : Supported e.2 a) :
  CorrectsPauli rows decoder e := by
  exact ⟨h e.1 hx, h e.2 hz⟩

theorem successful_zero_b_support_even {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hb : bValue hx a = 0) (decoder : Decoder n)
  (h : CorrectsSupported hx hz decoder a) : weight a % 2 = 0 := by
  have hn : ¬ Odd a := by
    intro ho
    exact no_universal_supported_recovery hcss hsame a ho hb decoder h
  unfold Odd at hn
  omega

theorem xor_zero_right (x : Word n) : xor x zero = x := by
  funext i
  exact Bool.xor_false _

theorem css_iff_check_all (hx hz : List (Word n)) :
  CSS hx hz ↔ (hx.all (fun x => hz.all (fun z => !(dot x z)))) = true := by
  simp [CSS, List.all_eq_true]

theorem zero_stopping_decoder_fails_odd_support {hx hz : List (Word n)}
  (hcss : CSS hx hz) (hsame : SameSpan hx hz) (a : Word n)
  (hodd : Odd a) (hzero : ZeroSyndrome hx a) (decoder : Decoder n)
  (hstop : decoder (syndrome hx zero) = zero) : ¬ Corrects hx hz decoder a := by
  intro hc
  unfold Corrects at hc
  rw [zero_syndrome_equal hx a hzero, hstop, xor_zero_right] at hc
  exact odd_not_stabilizer hcss hsame a hodd hc

end CSSOddSupport
