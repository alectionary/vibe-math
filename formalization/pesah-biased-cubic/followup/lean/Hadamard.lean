import Std

/- Binary Pauli labels modulo global phase. No lattice-size or CSS assumptions.
   Commutation is the XOR sum of local symplectic products over every qubit.
   This file does not claim a Hilbert-space dimension or lattice distance formula. -/
namespace Pesah
abbrev Pauli (n : Nat) := Fin n → Bool × Bool
abbrev Mask (n : Nat) := Fin n → Bool

def hadamard (m : Mask n) (v : Pauli n) : Pauli n :=
  fun i => if m i then ((v i).2, (v i).1) else v i

def localSym (a b : Bool × Bool) : Bool := (a.1 && b.2) ^^ (a.2 && b.1)
def symplectic (v w : Pauli n) : Bool :=
  (List.finRange n).foldr (fun i acc => localSym (v i) (w i) ^^ acc) false

def weight (v : Pauli n) : Nat :=
  (List.finRange n).foldr (fun i acc => (if (v i).1 || (v i).2 then 1 else 0) + acc) 0

def add (v w : Pauli n) : Pauli n := fun i => ((v i).1 ^^ (w i).1, (v i).2 ^^ (w i).2)
def zero : Pauli n := fun _ => (false, false)

theorem hadamard_involutive (m : Mask n) (v : Pauli n) :
    hadamard m (hadamard m v) = v := by
  funext i
  cases h : m i <;> simp [hadamard, h]

theorem localSym_preserved (m : Mask n) (v w : Pauli n) (i : Fin n) :
    localSym (hadamard m v i) (hadamard m w i) = localSym (v i) (w i) := by
  cases h : m i <;> simp [hadamard, localSym, h, Bool.xor_comm]

theorem support_preserved (m : Mask n) (v : Pauli n) (i : Fin n) :
    ((hadamard m v i).1 || (hadamard m v i).2) = ((v i).1 || (v i).2) := by
  cases h : m i <;> simp [hadamard, h, Bool.or_comm]

theorem symplectic_preserved (m : Mask n) (v w : Pauli n) :
    symplectic (hadamard m v) (hadamard m w) = symplectic v w := by
  unfold symplectic
  have h : (fun i acc => localSym (hadamard m v i) (hadamard m w i) ^^ acc) =
      (fun i acc => localSym (v i) (w i) ^^ acc) := by
    funext i acc
    rw [localSym_preserved]
  rw [h]

theorem weight_preserved (m : Mask n) (v : Pauli n) :
    weight (hadamard m v) = weight v := by
  unfold weight
  have hs : (fun (i : Fin n) (acc : Nat) => (if (hadamard m v i).1 || (hadamard m v i).2 then 1 else 0) + acc) =
      (fun (i : Fin n) (acc : Nat) => (if (v i).1 || (v i).2 then 1 else 0) + acc) := by
    funext i acc
    rw [support_preserved]
  rw [hs]

theorem add_preserved (m : Mask n) (v w : Pauli n) :
    hadamard m (add v w) = add (hadamard m v) (hadamard m w) := by
  funext i
  cases h : m i <;> simp [hadamard, add, h]

theorem zero_preserved (m : Mask n) : hadamard m zero = zero := by
  funext i
  cases h : m i <;> simp [hadamard, zero, h]

abbrev Code (n : Nat) := Pauli n → Prop
-- Image under this involution, represented without existential witnesses.
def transformed (m : Mask n) (C : Code n) : Code n := fun v => C (hadamard m v)
def normalizer (C : Code n) (v : Pauli n) : Prop := ∀ s, C s → symplectic v s = false
def logical (C : Code n) (v : Pauli n) : Prop := normalizer C v ∧ ¬ C v
def distanceAtLeast (C : Code n) (d : Nat) : Prop := ∀ v, logical C v → d ≤ weight v

theorem membership_preserved (m : Mask n) (C : Code n) (v : Pauli n) :
    transformed m C (hadamard m v) ↔ C v := by
  simp [transformed, hadamard_involutive]

theorem normalizer_preserved (m : Mask n) (C : Code n) (v : Pauli n) :
    normalizer (transformed m C) (hadamard m v) ↔ normalizer C v := by
  constructor
  · intro hv s hs
    have hs' : transformed m C (hadamard m s) := (membership_preserved m C s).mpr hs
    have h := hv (hadamard m s) hs'
    simpa only [symplectic_preserved] using h
  · intro hv s hs
    have h := hv (hadamard m s) hs
    have eq := symplectic_preserved m v (hadamard m s)
    rw [hadamard_involutive] at eq
    rw [eq]
    exact h

theorem logical_preserved (m : Mask n) (C : Code n) (v : Pauli n) :
    logical (transformed m C) (hadamard m v) ↔ logical C v := by
  simp only [logical, normalizer_preserved, membership_preserved]

theorem distanceAtLeast_preserved (m : Mask n) (C : Code n) (d : Nat) :
    distanceAtLeast (transformed m C) d ↔ distanceAtLeast C d := by
  constructor
  · intro h v hv
    have h' := h (hadamard m v) ((logical_preserved m C v).mpr hv)
    simpa only [weight_preserved] using h'
  · intro h v hv
    have hv' : logical C (hadamard m v) := by
      apply (logical_preserved m C (hadamard m v)).mp
      simpa only [hadamard_involutive] using hv
    have h' := h (hadamard m v) hv'
    simpa only [weight_preserved] using h'


theorem hadamard_injective (m : Mask n) {v w : Pauli n}
    (h : hadamard m v = hadamard m w) : v = w := by
  have hh := congrArg (hadamard m) h
  simpa only [hadamard_involutive] using hh

def sameClass (C : Code n) (v w : Pauli n) : Prop := C (add v w)
theorem sameClass_preserved (m : Mask n) (C : Code n) (v w : Pauli n) :
    sameClass (transformed m C) (hadamard m v) (hadamard m w) ↔ sameClass C v w := by
  simp only [sameClass, ← add_preserved, membership_preserved]

def stabilizer (C : Code n) : Prop :=
  C zero ∧ (∀ v w, C v → C w → C (add v w)) ∧ (∀ v w, C v → C w → symplectic v w = false)

theorem stabilizer_forward (m : Mask n) (C : Code n) (h : stabilizer C) :
    stabilizer (transformed m C) := by
  refine ⟨?_, ?_, ?_⟩
  · simpa [transformed, zero_preserved] using h.1
  · intro v w hv hw
    change C (hadamard m (add v w))
    rw [add_preserved]
    exact h.2.1 _ _ hv hw
  · intro v w hv hw
    have hs := h.2.2 _ _ hv hw
    simpa only [symplectic_preserved] using hs

theorem transformed_twice (m : Mask n) (C : Code n) : transformed m (transformed m C) = C := by
  funext v
  simp [transformed, hadamard_involutive]

theorem stabilizer_preserved (m : Mask n) (C : Code n) :
    stabilizer (transformed m C) ↔ stabilizer C := by
  constructor
  · intro h
    have hh := stabilizer_forward m (transformed m C) h
    simpa only [transformed_twice] using hh
  · exact stabilizer_forward m C

def lincomb : List Bool → List (Pauli n) → Pauli n
  | [], _ => zero
  | _, [] => zero
  | c :: cs, g :: gs => add (if c then g else zero) (lincomb cs gs)

theorem lincomb_preserved (m : Mask n) (cs : List Bool) (gs : List (Pauli n)) :
    hadamard m (lincomb cs gs) = lincomb cs (gs.map (hadamard m)) := by
  induction cs generalizing gs with
  | nil => simp [lincomb, zero_preserved]
  | cons c cs ih =>
    cases gs with
    | nil => simp [lincomb, zero_preserved]
    | cons g gs => cases c <;> simp [lincomb, add_preserved, zero_preserved, ih]

def span (gs : List (Pauli n)) (v : Pauli n) : Prop :=
  ∃ cs : List Bool, cs.length = gs.length ∧ lincomb cs gs = v

def independent (gs : List (Pauli n)) : Prop :=
  ∀ cs : List Bool, cs.length = gs.length → lincomb cs gs = zero → ∀ b ∈ cs, b = false

def basis (C : Code n) (gs : List (Pauli n)) : Prop :=
  independent gs ∧ ∀ v, C v ↔ span gs v

theorem span_preserved (m : Mask n) (gs : List (Pauli n)) (v : Pauli n) :
    span (gs.map (hadamard m)) (hadamard m v) ↔ span gs v := by
  constructor
  · rintro ⟨cs, hlen, hv⟩
    refine ⟨cs, by simpa using hlen, ?_⟩
    apply hadamard_injective m
    rw [lincomb_preserved]
    exact hv
  · rintro ⟨cs, hlen, hv⟩
    refine ⟨cs, by simpa using hlen, ?_⟩
    rw [← lincomb_preserved, hv]

theorem independent_forward (m : Mask n) (gs : List (Pauli n)) (h : independent gs) :
    independent (gs.map (hadamard m)) := by
  intro cs hlen hv
  apply h cs (by simpa using hlen)
  apply hadamard_injective m
  rw [lincomb_preserved, zero_preserved]
  exact hv

theorem basis_forward (m : Mask n) (C : Code n) (gs : List (Pauli n)) (h : basis C gs) :
    basis (transformed m C) (gs.map (hadamard m)) := by
  refine ⟨independent_forward m gs h.1, ?_⟩
  intro v
  have hs := span_preserved m gs (hadamard m v)
  rw [hadamard_involutive] at hs
  exact (h.2 (hadamard m v)).trans hs.symm

def rankWitness (C : Code n) (r : Nat) : Prop :=
  ∃ gs : List (Pauli n), basis C gs ∧ gs.length = r

-- Binary stabilizer parameter n-r=k; existence is not assumed for arbitrary predicates.
def encodedQubits (C : Code n) (k : Nat) : Prop := ∃ r, rankWitness C r ∧ n = r + k

theorem rankWitness_forward (m : Mask n) (C : Code n) (r : Nat) (h : rankWitness C r) :
    rankWitness (transformed m C) r := by
  rcases h with ⟨gs, hb, hlen⟩
  exact ⟨gs.map (hadamard m), basis_forward m C gs hb, by simpa using hlen⟩

theorem rankWitness_preserved (m : Mask n) (C : Code n) (r : Nat) :
    rankWitness (transformed m C) r ↔ rankWitness C r := by
  constructor
  · intro h
    have hh := rankWitness_forward m (transformed m C) r h
    simpa only [transformed_twice] using hh
  · exact rankWitness_forward m C r

theorem encodedQubits_preserved (m : Mask n) (C : Code n) (k : Nat) :
    encodedQubits (transformed m C) k ↔ encodedQubits C k := by
  simp only [encodedQubits, rankWitness_preserved]

def distanceExact (C : Code n) (d : Nat) : Prop :=
  distanceAtLeast C d ∧ ∃ v, logical C v ∧ weight v = d

theorem distanceExact_forward (m : Mask n) (C : Code n) (d : Nat) (h : distanceExact C d) :
    distanceExact (transformed m C) d := by
  refine ⟨(distanceAtLeast_preserved m C d).mpr h.1, ?_⟩
  rcases h.2 with ⟨v, hv, hw⟩
  exact ⟨hadamard m v, (logical_preserved m C v).mpr hv, by simpa only [weight_preserved] using hw⟩

theorem distanceExact_preserved (m : Mask n) (C : Code n) (d : Nat) :
    distanceExact (transformed m C) d ↔ distanceExact C d := by
  constructor
  · intro h
    have hh := distanceExact_forward m (transformed m C) d h
    simpa only [transformed_twice] using hh
  · exact distanceExact_forward m C d

-- Full n,k,d preservation within the explicitly defined binary stabilizer model.
theorem binary_parameters_preserved (m : Mask n) (C : Code n) (k d : Nat) :
    (stabilizer (transformed m C) ∧ encodedQubits (transformed m C) k ∧ distanceExact (transformed m C) d) ↔
    (stabilizer C ∧ encodedQubits C k ∧ distanceExact C d) := by
  simp only [stabilizer_preserved, encodedQubits_preserved, distanceExact_preserved]

#print axioms binary_parameters_preserved
#print axioms distanceAtLeast_preserved
#print axioms sameClass_preserved
end Pesah
