import OddSupport

/-! Exact project-derived existence questions. No existence or nonexistence
proof for even supports is asserted. The actual common check list is used in
all graph incidences, messages and stabilizer spaces. -/
namespace CSSOddSupport.Question
set_option maxHeartbeats 0

abbrev Check (rows : List (Word n)) := Fin rows.length
abbrev Msg (rows : List (Word n)) := Check rows → Fin n → Bool

def rowAt (rows : List (Word n)) (c : Check rows) : Word n := rows[c.val]
def adj (rows : List (Word n)) (c : Check rows) (v : Fin n) : Bool := rowAt rows c v

def parity (bs : List Bool) : Bool := bs.foldr Bool.xor false

def majority (bs : List Bool) : Bool := decide (bs.length < 2 * bs.countP id)

def checkUpdate (rows : List (Word n)) (s : List Bool) (x : Msg rows) : Msg rows :=
  fun c v => adj rows c v && Bool.xor (s[c.val]?.getD false)
    (parity ((List.finRange n).map (fun u => adj rows c u && (u != v) && x c u)))

def hard (rows : List (Word n)) (y : Msg rows) : Word n :=
  fun v => majority (((List.finRange rows.length).filter (fun c => adj rows c v)).map (fun c => y c v))

def variableUpdate (rows : List (Word n)) (y : Msg rows) : Msg rows :=
  fun c v => adj rows c v && majority
    (((List.finRange rows.length).filter (fun d => adj rows d v && (d != c))).map (fun d => y d v))

def edgeSyndrome (rows : List (Word n)) (x : Msg rows) : List Bool :=
  (List.finRange rows.length).map (fun c =>
    parity ((List.finRange n).map (fun v => adj rows c v && x c v)))

def variables (rows : List (Word n)) (s : List Bool) : Nat → Msg rows
  | 0 => fun _ _ => false
  | t+1 => variableUpdate rows (checkUpdate rows s (variables rows s t))

def output (rows : List (Word n)) (s : List Bool) : Nat → Word n
  | 0 => zero
  | t+1 => hard rows (checkUpdate rows s (variables rows s t))

def hardAccept (rows : List (Word n)) (s : List Bool) : Nat → Prop
  | 0 => s = syndrome rows zero
  | t+1 => syndrome rows (output rows s (t+1)) = s

def edgeAccept (rows : List (Word n)) (s : List Bool) : Nat → Prop
  | 0 => s = syndrome rows zero
  | t+1 => edgeSyndrome rows (variables rows s (t+1)) = s

def FirstAccept (accept : Nat → Prop) (t : Nat) : Prop :=
  accept t ∧ ∀ u, u < t → ¬ accept u

def Success (rows : List (Word n)) (accept : List Bool → Nat → Prop) (e : Word n) : Prop :=
  ∃ t, FirstAccept (accept (syndrome rows e)) t ∧
    Span rows (xor e (output rows (syndrome rows e) t))

def HardSuccess (rows : List (Word n)) (e : Word n) : Prop := Success rows (hardAccept rows) e
def EdgeSuccess (rows : List (Word n)) (e : Word n) : Prop := Success rows (edgeAccept rows) e

def OneStepSuccess (rows : List (Word n)) (e : Word n) : Prop :=
  let s := syndrome rows e
  if s = syndrome rows zero then Span rows e else
    syndrome rows (output rows s 1) = s ∧ edgeSyndrome rows (variables rows s 1) = s ∧
      Span rows (xor e (output rows s 1))

abbrev Node (n : Nat) (rows : List (Word n)) := Sum (Fin n) (Check rows)

def Edge (rows : List (Word n)) : Node n rows → Node n rows → Prop
  | .inl v, .inr c => adj rows c v = true
  | .inr c, .inl v => adj rows c v = true
  | _, _ => False

inductive Walk (rows : List (Word n)) : Node n rows → Node n rows → Prop
  | nil (u : Node n rows) : Walk rows u u
  | cons {u v w : Node n rows} : Edge rows u v → Walk rows v w → Walk rows u w

def Connected (rows : List (Word n)) : Prop := ∀ u v : Node n rows, Walk rows u v

def LogicalPair (rows : List (Word n)) : Prop :=
  ∃ x z : Word n, LogicalZ rows rows x ∧ LogicalZ rows rows z ∧ dot x z = true

def ones : Word n := fun _ => true

structure Structural (rows : List (Word n)) (a : Word n) : Prop where
  css : CSS rows rows
  distinctChecks : rows.Pairwise (fun x y => x ≠ y)
  absorbing : Absorbing rows a
  zeroOddChecks : bValue rows a = 0
  properSupport : weight a < n
  positiveLogical : LogicalPair rows
  connected : Connected rows
  noProductCut : ∀ cut : Word n, cut ≠ zero → cut ≠ ones → ¬ SplitsAcross rows rows cut

def FullCandidate (rows : List (Word n)) (a : Word n) : Prop :=
  Structural rows a ∧ ∀ e, Supported e a → HardSuccess rows e ∧ EdgeSuccess rows e

def OneStepCandidate (rows : List (Word n)) (a : Word n) : Prop :=
  Structural rows a ∧ ∀ e, Supported e a → OneStepSuccess rows e

-- Primary question and the explicitly stronger finite verification benchmark.
def FullQuestion : Prop := ∃ n, ∃ rows : List (Word n), ∃ a : Word n, FullCandidate rows a

def EvenFullQuestion : Prop := ∃ n, ∃ rows : List (Word n), ∃ a : Word n,
  FullCandidate rows a ∧ weight a % 2 = 0

def OneStepQuestion : Prop := ∃ n, ∃ rows : List (Word n), ∃ a : Word n, OneStepCandidate rows a

theorem first_accept_at_zero {accept : Nat → Prop} {t : Nat}
  (hzero : accept 0) (h : FirstAccept accept t) : t = 0 := by
  by_cases ht : t = 0
  · exact ht
  · have hlt : 0 < t := by omega
    exact False.elim (h.2 0 hlt hzero)

theorem zero_syndrome_hard_success_iff (rows : List (Word n)) (a : Word n)
  (hzero : ZeroSyndrome rows a) : HardSuccess rows a ↔ Span rows a := by
  have hs := zero_syndrome_equal rows a hzero
  constructor
  · rintro ⟨t,ht,hr⟩
    have h0 : hardAccept rows (syndrome rows a) 0 := hs
    have ht0 := first_accept_at_zero h0 ht
    simpa [ht0, output, xor_zero_right] using hr
  · intro ha
    refine ⟨0,⟨hs,?_⟩,?_⟩
    · intro u hu
      omega
    · simpa [output, xor_zero_right] using ha

theorem zero_syndrome_edge_success_iff (rows : List (Word n)) (a : Word n)
  (hzero : ZeroSyndrome rows a) : EdgeSuccess rows a ↔ Span rows a := by
  have hs := zero_syndrome_equal rows a hzero
  constructor
  · rintro ⟨t,ht,hr⟩
    have h0 : edgeAccept rows (syndrome rows a) 0 := hs
    have ht0 := first_accept_at_zero h0 ht
    simpa [ht0, output, xor_zero_right] using hr
  · intro ha
    refine ⟨0,⟨hs,?_⟩,?_⟩
    · intro u hu
      omega
    · simpa [output, xor_zero_right] using ha

theorem one_step_hard_success (rows : List (Word n)) (a : Word n)
  (h : OneStepSuccess rows a) : HardSuccess rows a := by
  unfold OneStepSuccess at h
  dsimp only at h
  by_cases hs : syndrome rows a = syndrome rows zero
  · have ha : Span rows a := by simpa [hs] using h
    refine ⟨0,⟨hs,?_⟩,?_⟩
    · intro u hu
      omega
    · simpa [output, xor_zero_right] using ha
  · have ha := h
    simp only [hs, ite_false] at ha
    refine ⟨1,⟨ha.1,?_⟩,ha.2.2⟩
    intro u hu
    have hu0 : u = 0 := by omega
    subst u
    exact hs

theorem one_step_edge_success (rows : List (Word n)) (a : Word n)
  (h : OneStepSuccess rows a) : EdgeSuccess rows a := by
  unfold OneStepSuccess at h
  dsimp only at h
  by_cases hs : syndrome rows a = syndrome rows zero
  · have ha : Span rows a := by simpa [hs] using h
    refine ⟨0,⟨hs,?_⟩,?_⟩
    · intro u hu
      omega
    · simpa [output, xor_zero_right] using ha
  · have ha := h
    simp only [hs, ite_false] at ha
    refine ⟨1,⟨ha.2.1,?_⟩,ha.2.2⟩
    intro u hu
    have hu0 : u = 0 := by omega
    subst u
    exact hs

theorem one_step_candidate_full {rows : List (Word n)} {a : Word n}
  (h : OneStepCandidate rows a) : FullCandidate rows a := by
  refine ⟨h.1,?_⟩
  intro e he
  exact ⟨one_step_hard_success rows e (h.2 e he), one_step_edge_success rows e (h.2 e he)⟩

def NoSupportedLogical (rows : List (Word n)) (a : Word n) : Prop :=
  ∀ e, Supported e a → ZeroSyndrome rows e → Span rows e

theorem full_candidate_no_supported_logical {rows : List (Word n)} {a : Word n}
  (h : FullCandidate rows a) : NoSupportedLogical rows a := by
  intro e he hz
  exact (zero_syndrome_hard_success_iff rows e hz).mp (h.2 e he).1

theorem full_candidate_support_even {rows : List (Word n)} {a : Word n}
  (h : FullCandidate rows a) : weight a % 2 = 0 := by
  have hz := (zero_b_iff_zero_syndrome rows a).mp h.1.zeroOddChecks
  have ha := (zero_syndrome_hard_success_iff rows a hz).mp (h.2 a (self_supported a)).1
  exact equal_spans_even_stabilizers h.1.css (identical_rows_same_span rows) ha

theorem full_question_iff_even : FullQuestion ↔ EvenFullQuestion := by
  constructor
  · rintro ⟨n,rows,a,h⟩
    exact ⟨n,rows,a,h,full_candidate_support_even h⟩
  · rintro ⟨n,rows,a,h,_⟩
    exact ⟨n,rows,a,h⟩

theorem benchmark_implies_full : OneStepQuestion → FullQuestion := by
  rintro ⟨n,rows,a,h⟩
  exact ⟨n,rows,a,one_step_candidate_full h⟩

end CSSOddSupport.Question
