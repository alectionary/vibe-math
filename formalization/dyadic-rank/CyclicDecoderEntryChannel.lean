import Mathlib.Data.Rat.Defs
import Mathlib.Data.List.Count
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

/-! Exact finite Bernoulli averaging supporting the channel calculation.
The Walsh-to-actual-decoder truth tables are computationally checked outside
Lean; this file proves the independent-bit parity moment, not those tables. -/
namespace CyclicDecoderEntryChannel

def average (p : ℚ) : Nat → (List Bool → ℚ) → ℚ
  | 0, f => f []
  | n+1, f => (1-p) * average p n (fun xs => f (false::xs)) +
      p * average p n (fun xs => f (true::xs))

def character : List Bool → List Bool → ℚ
  | [], _ => 1
  | _::_, [] => 1
  | selected::mask, bit::bits =>
      (if selected && bit then -1 else 1) * character mask bits

theorem average_const (p c : ℚ) (n : Nat) :
    average p n (fun _ => c) = c := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [average, ih]; ring

theorem average_add (p : ℚ) (n : Nat) (f g : List Bool → ℚ) :
    average p n (fun xs => f xs + g xs) = average p n f + average p n g := by
  induction n generalizing f g with
  | zero => rfl
  | succ n ih => simp only [average, ih]; ring

theorem average_smul (p c : ℚ) (n : Nat) (f : List Bool → ℚ) :
    average p n (fun xs => c * f xs) = c * average p n f := by
  induction n generalizing f with
  | zero => rfl
  | succ n ih => simp only [average, ih]; ring

theorem average_neg (p : ℚ) (n : Nat) (f : List Bool → ℚ) :
    average p n (fun xs => -f xs) = -average p n f := by
  simpa using average_smul p (-1) n f

/-- Independent Bernoulli parity character, with no restriction on unselected bits. -/
theorem parity_moment (p : ℚ) (mask : List Bool) :
    average p mask.length (character mask) = (1-2*p) ^ (mask.count true) := by
  induction mask with
  | nil => simp [average, character]
  | cons a mask ih =>
    cases a <;> simp [average, character, average_neg, ih, pow_succ] <;> ring

def oddIndicator (mask bits : List Bool) : ℚ :=
  (1-character mask bits)/2

/-- Probability of an odd parity in the finite independent-bit model. -/
theorem odd_probability (p : ℚ) (mask : List Bool) :
    average p mask.length (oddIndicator mask) =
      (1-(1-2*p)^(mask.count true))/2 := by
  have point : oddIndicator mask = fun bits =>
      (1/2 : ℚ) * 1 + (-1/2 : ℚ) * character mask bits := by
    funext bits
    unfold oddIndicator
    ring
  rw [point, average_add, average_smul, average_smul, average_const, parity_moment]
  ring

def xorMask (a b : List Bool) : List Bool := List.zipWith Bool.xor a b

theorem xorMask_length (a b : List Bool) (same : a.length = b.length) :
    (xorMask a b).length = a.length := by
  simp [xorMask, List.length_zipWith, same]

theorem character_xor (a b bits : List Bool) (same : a.length = b.length) :
    character (xorMask a b) bits = character a bits * character b bits := by
  induction a generalizing b bits with
  | nil =>
    cases b with
    | nil => simp [xorMask, character]
    | cons b rest => simp at same
  | cons a mask ih =>
    cases b with
    | nil => simp at same
    | cons b rest =>
      have ht : mask.length = rest.length := by simpa using same
      cases bits with
      | nil => simp [xorMask, character]
      | cons bit bits =>
        have tail : character (List.zipWith Bool.xor mask rest) bits =
            character mask bits * character rest bits := ih rest bits ht
        cases a <;> cases b <;> cases bit <;>
          simp [xorMask, character, tail]

theorem product_moment (p : ℚ) (a b : List Bool) (same : a.length = b.length) :
    average p a.length (fun bits => character a bits * character b bits) =
      (1-2*p)^((xorMask a b).count true) := by
  have point : (fun bits => character a bits * character b bits) =
      character (xorMask a b) := by
    funext bits
    exact (character_xor a b bits same).symm
  rw [point, ← xorMask_length a b same]
  exact parity_moment p _

def tripleOdd (a b c bits : List Bool) : ℚ :=
  oddIndicator a bits * oddIndicator b bits * oddIndicator c bits

/-- Inclusion-exclusion on the three parity characters, with all overlap
correlations retained in XOR support sizes. No independent-syndrome assumption. -/
theorem triple_odd_probability (p : ℚ) (a b c : List Bool)
    (hab : a.length = b.length) (hac : a.length = c.length) :
    average p a.length (tripleOdd a b c) =
      (1-(1-2*p)^(a.count true)-(1-2*p)^(b.count true)-(1-2*p)^(c.count true)
        +(1-2*p)^((xorMask a b).count true)
        +(1-2*p)^((xorMask a c).count true)
        +(1-2*p)^((xorMask b c).count true)
        -(1-2*p)^((xorMask (xorMask a b) c).count true))/8 := by
  have point : tripleOdd a b c = fun bits =>
      (1/8 : ℚ)*1 + (-1/8 : ℚ)*character a bits +
      (-1/8 : ℚ)*character b bits + (-1/8 : ℚ)*character c bits +
      (1/8 : ℚ)*character (xorMask a b) bits +
      (1/8 : ℚ)*character (xorMask a c) bits +
      (1/8 : ℚ)*character (xorMask b c) bits +
      (-1/8 : ℚ)*character (xorMask (xorMask a b) c) bits := by
    funext bits
    rw [character_xor a b bits hab, character_xor a c bits hac,
      character_xor b c bits (hab.symm.trans hac),
      character_xor (xorMask a b) c bits ((xorMask_length a b hab).trans hac),
      character_xor a b bits hab]
    unfold tripleOdd oddIndicator
    ring
  rw [point]
  simp only [average_add, average_smul, average_const]
  have mb : average p a.length (character b) = (1-2*p)^(b.count true) := by
    rw [hab]; exact parity_moment p b
  have mc : average p a.length (character c) = (1-2*p)^(c.count true) := by
    rw [hac]; exact parity_moment p c
  have mab : average p a.length (character (xorMask a b)) =
      (1-2*p)^((xorMask a b).count true) := by
    rw [← xorMask_length a b hab]; exact parity_moment p _
  have mac : average p a.length (character (xorMask a c)) =
      (1-2*p)^((xorMask a c).count true) := by
    rw [← xorMask_length a c hac]; exact parity_moment p _
  have mbc : average p a.length (character (xorMask b c)) =
      (1-2*p)^((xorMask b c).count true) := by
    rw [hab, ← xorMask_length b c (hab.symm.trans hac)]; exact parity_moment p _
  have mabc : average p a.length (character (xorMask (xorMask a b) c)) =
      (1-2*p)^((xorMask (xorMask a b) c).count true) := by
    have hlen : (xorMask (xorMask a b) c).length = a.length :=
      (xorMask_length _ _ ((xorMask_length a b hab).trans hac)).trans (xorMask_length a b hab)
    rw [← hlen]; exact parity_moment p _
  rw [parity_moment, mb, mc, mab, mac, mbc, mabc]
  ring

end CyclicDecoderEntryChannel
#print axioms CyclicDecoderEntryChannel.parity_moment
#print axioms CyclicDecoderEntryChannel.odd_probability
#print axioms CyclicDecoderEntryChannel.triple_odd_probability
