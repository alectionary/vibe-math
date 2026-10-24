import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Fintype.Card
import Mathlib.Tactic.NormNum

set_option maxRecDepth 1000000
set_option maxHeartbeats 0

namespace Absorbing42Small

abbrev Vertex := Fin 12
abbrev Check := Fin 12
abbrev Incidence := Vertex → Finset Check

def baseA (v : Vertex) : Finset Check :=
  match v.val with
  | 0 => {0,1,2}
  | 1 => {0,3,4}
  | 2 => {0,10,11}
  | 3 => {1,3,5}
  | 4 => {1,6,9}
  | 5 => {2,4,5}
  | 6 => {2,9,10}
  | 7 => {3,6,7}
  | 8 => {4,7,8}
  | 9 => {5,7,11}
  | 10 => {6,8,10}
  | 11 => {8,9,11}
  | _ => ∅

def baseB (v : Vertex) : Finset Check :=
  match v.val with
  | 0 => {0,1,3}
  | 1 => {0,2,4}
  | 2 => {0,10,11}
  | 3 => {1,2,5}
  | 4 => {1,6,9}
  | 5 => {2,9,10}
  | 6 => {3,4,5}
  | 7 => {3,6,7}
  | 8 => {4,7,8}
  | 9 => {5,7,11}
  | 10 => {6,8,10}
  | 11 => {8,9,11}
  | _ => ∅

def selected (H : Incidence) (S : Finset Vertex) (c : Check) : Finset Vertex :=
  S.filter (fun v => c ∈ H v)

def Elementary (H : Incidence) (S : Finset Vertex) : Prop :=
  ∀ c, (selected H S c).card ≤ 2

instance (H : Incidence) (S : Finset Vertex) : Decidable (Elementary H S) :=
  inferInstanceAs (Decidable (∀ c, (selected H S c).card ≤ 2))

def oddCount (H : Incidence) (S : Finset Vertex) : ℕ :=
  (Finset.univ.filter (fun c => (selected H S c).card % 2 = 1)).card

def Absorbing (H : Incidence) (S : Finset Vertex) : Prop :=
  S.Nonempty ∧ ∀ v ∈ S,
    ((H v).filter (fun c => (selected H S c).card % 2 = 0)).card >
    ((H v).filter (fun c => (selected H S c).card % 2 = 1)).card

instance (H : Incidence) (S : Finset Vertex) : Decidable (Absorbing H S) :=
  inferInstanceAs (Decidable (S.Nonempty ∧ ∀ v ∈ S,
    ((H v).filter (fun c => (selected H S c).card % 2 = 0)).card >
    ((H v).filter (fun c => (selected H S c).card % 2 = 1)).card))

def count42 (H : Incidence) : ℕ :=
  ((Finset.univ.powersetCard 4).filter
    (fun S => Elementary H S ∧ Absorbing H S ∧ oddCount H S = 2)).card

def checkGram (H : Incidence) (c d : Check) : ℕ :=
  (Finset.univ.filter (fun v => c ∈ H v ∧ d ∈ H v)).card

def CubicLinear (H : Incidence) : Prop :=
  (∀ v, (H v).card = 3) ∧
  (∀ c, (Finset.univ.filter (fun v => c ∈ H v)).card = 3) ∧
  (∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1)

instance (H : Incidence) : Decidable (CubicLinear H) :=
  inferInstanceAs (Decidable ((∀ v, (H v).card = 3) ∧
  (∀ c, (Finset.univ.filter (fun v => c ∈ H v)).card = 3) ∧
  (∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1)))

theorem baseA_cubic_linear : CubicLinear baseA := by decide

theorem baseB_cubic_linear : CubicLinear baseB := by decide

theorem same_check_gram : checkGram baseA = checkGram baseB := by
  funext c d
  have h : ∀ c d, checkGram baseA c d = checkGram baseB c d := by decide
  exact h c d

theorem baseA_count42 : count42 baseA = 7 := by decide

theorem baseB_count42 : count42 baseB = 5 := by decide

/-- The entire integer check-side Gram matrix, even with cubicity and no
four-cycles fixed, does not determine the exact elementary (4,2) count. -/
theorem no_gram_only_count :
    ¬ ∃ f : (Check → Check → ℕ) → ℕ,
      ∀ H : Incidence, CubicLinear H → f (checkGram H) = count42 H := by
  rintro ⟨f, hf⟩
  have ha := hf baseA baseA_cubic_linear
  have hb := hf baseB baseB_cubic_linear
  rw [same_check_gram, baseA_count42] at ha
  rw [baseB_count42] at hb
  omega

#print axioms baseA_cubic_linear
#print axioms baseB_cubic_linear
#print axioms same_check_gram
#print axioms baseA_count42
#print axioms baseB_count42
#print axioms no_gram_only_count

end Absorbing42Small
