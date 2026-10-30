import Hadamard
import CyclicKernel

namespace Pesah
-- Python pauli.py swaps the first n//3 entries, n=3*L^3.
def firstAxisMask (L : Nat) : Mask (3 * L^3) := fun i => decide (i.val < L^3)

theorem first_axis_parameters (L k d : Nat) (C : Code (3 * L^3)) :
    (stabilizer (transformed (firstAxisMask L) C) ∧
      encodedQubits (transformed (firstAxisMask L) C) k ∧
      distanceExact (transformed (firstAxisMask L) C) d) ↔
    (stabilizer C ∧ encodedQubits C k ∧ distanceExact C d) :=
  binary_parameters_preserved (firstAxisMask L) C k d

theorem python_first_third (L : Nat) : (3 * L^3) / 3 = L^3 := by omega

theorem masked_coordinate (L : Nat) (v : Pauli (3 * L^3)) (i : Fin (3 * L^3))
    (h : i.val < L^3) : hadamard (firstAxisMask L) v i = ((v i).2, (v i).1) := by
  simp [hadamard, firstAxisMask, h]

theorem unmasked_coordinate (L : Nat) (v : Pauli (3 * L^3)) (i : Fin (3 * L^3))
    (h : ¬ i.val < L^3) : hadamard (firstAxisMask L) v i = v i := by
  simp [hadamard, firstAxisMask, h]

-- Restricted corner-triangle formula from geometry.py: for first-axis-only
-- error, the other two terms vanish. Orientation 0 has baseX=false;
-- orientation 2 has baseX=true. Thus choosing baseX=vertex parity exposes
-- the unshifted edge at each vertex. `previous` and parity are arbitrary:
-- the statement in particular applies to every even periodic lattice.
def restrictedCorner (previous : α → α) (parity : α → Bool)
    (e : α → Bool) (baseX : Bool) (v : α) : Bool :=
  e (if baseX ^^ parity v then previous v else v)

theorem corner_exposes_coordinate (previous : α → α) (parity : α → Bool)
    (e : α → Bool) (v : α) : restrictedCorner previous parity e (parity v) v = e v := by
  simp [restrictedCorner]

theorem actual_two_corner_family_injective (previous : α → α) (parity : α → Bool)
    (e f : α → Bool)
    (h : ∀ b v, restrictedCorner previous parity e b v = restrictedCorner previous parity f b v) : e = f := by
  funext v
  simpa only [corner_exposes_coordinate] using h (parity v) v

#print axioms first_axis_parameters
#print axioms actual_two_corner_family_injective
end Pesah
