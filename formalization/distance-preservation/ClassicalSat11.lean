import Std.Tactic.BVDecide
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace DistancePreservation11
def ClassicalChecks (x : BitVec 44) : Prop :=
  (x.getLsbD 0 ^^ x.getLsbD 11 ^^ x.getLsbD 22 ^^ x.getLsbD 33) = false ∧
  (x.getLsbD 1 ^^ x.getLsbD 12 ^^ x.getLsbD 23 ^^ x.getLsbD 34) = false ∧
  (x.getLsbD 2 ^^ x.getLsbD 13 ^^ x.getLsbD 24 ^^ x.getLsbD 35) = false ∧
  (x.getLsbD 3 ^^ x.getLsbD 14 ^^ x.getLsbD 25 ^^ x.getLsbD 36) = false ∧
  (x.getLsbD 4 ^^ x.getLsbD 15 ^^ x.getLsbD 26 ^^ x.getLsbD 37) = false ∧
  (x.getLsbD 5 ^^ x.getLsbD 16 ^^ x.getLsbD 27 ^^ x.getLsbD 38) = false ∧
  (x.getLsbD 6 ^^ x.getLsbD 17 ^^ x.getLsbD 28 ^^ x.getLsbD 39) = false ∧
  (x.getLsbD 7 ^^ x.getLsbD 18 ^^ x.getLsbD 29 ^^ x.getLsbD 40) = false ∧
  (x.getLsbD 8 ^^ x.getLsbD 19 ^^ x.getLsbD 30 ^^ x.getLsbD 41) = false ∧
  (x.getLsbD 9 ^^ x.getLsbD 20 ^^ x.getLsbD 31 ^^ x.getLsbD 42) = false ∧
  (x.getLsbD 10 ^^ x.getLsbD 21 ^^ x.getLsbD 32 ^^ x.getLsbD 43) = false ∧
  (x.getLsbD 0 ^^ x.getLsbD 14 ^^ x.getLsbD 26 ^^ x.getLsbD 42) = false ∧
  (x.getLsbD 1 ^^ x.getLsbD 15 ^^ x.getLsbD 27 ^^ x.getLsbD 43) = false ∧
  (x.getLsbD 2 ^^ x.getLsbD 16 ^^ x.getLsbD 28 ^^ x.getLsbD 33) = false ∧
  (x.getLsbD 3 ^^ x.getLsbD 17 ^^ x.getLsbD 29 ^^ x.getLsbD 34) = false ∧
  (x.getLsbD 4 ^^ x.getLsbD 18 ^^ x.getLsbD 30 ^^ x.getLsbD 35) = false ∧
  (x.getLsbD 5 ^^ x.getLsbD 19 ^^ x.getLsbD 31 ^^ x.getLsbD 36) = false ∧
  (x.getLsbD 6 ^^ x.getLsbD 20 ^^ x.getLsbD 32 ^^ x.getLsbD 37) = false ∧
  (x.getLsbD 7 ^^ x.getLsbD 21 ^^ x.getLsbD 22 ^^ x.getLsbD 38) = false ∧
  (x.getLsbD 8 ^^ x.getLsbD 11 ^^ x.getLsbD 23 ^^ x.getLsbD 39) = false ∧
  (x.getLsbD 9 ^^ x.getLsbD 12 ^^ x.getLsbD 24 ^^ x.getLsbD 40) = false ∧
  (x.getLsbD 10 ^^ x.getLsbD 13 ^^ x.getLsbD 25 ^^ x.getLsbD 41) = false ∧
  (x.getLsbD 0 ^^ x.getLsbD 17 ^^ x.getLsbD 30 ^^ x.getLsbD 43) = false ∧
  (x.getLsbD 1 ^^ x.getLsbD 18 ^^ x.getLsbD 31 ^^ x.getLsbD 33) = false ∧
  (x.getLsbD 2 ^^ x.getLsbD 19 ^^ x.getLsbD 32 ^^ x.getLsbD 34) = false ∧
  (x.getLsbD 3 ^^ x.getLsbD 20 ^^ x.getLsbD 22 ^^ x.getLsbD 35) = false ∧
  (x.getLsbD 4 ^^ x.getLsbD 21 ^^ x.getLsbD 23 ^^ x.getLsbD 36) = false ∧
  (x.getLsbD 5 ^^ x.getLsbD 11 ^^ x.getLsbD 24 ^^ x.getLsbD 37) = false ∧
  (x.getLsbD 6 ^^ x.getLsbD 12 ^^ x.getLsbD 25 ^^ x.getLsbD 38) = false ∧
  (x.getLsbD 7 ^^ x.getLsbD 13 ^^ x.getLsbD 26 ^^ x.getLsbD 39) = false ∧
  (x.getLsbD 8 ^^ x.getLsbD 14 ^^ x.getLsbD 27 ^^ x.getLsbD 40) = false ∧
  (x.getLsbD 9 ^^ x.getLsbD 15 ^^ x.getLsbD 28 ^^ x.getLsbD 41) = false ∧
  (x.getLsbD 10 ^^ x.getLsbD 16 ^^ x.getLsbD 29 ^^ x.getLsbD 42) = false

theorem classical_lower (x : BitVec 44) (h : ClassicalChecks x) :
    x = 0 ∨ (12 : BitVec 44) ≤ x.cpop := by
  simp only [ClassicalChecks] at h
  bv_decide (config := { timeout := 300 })

#print axioms classical_lower
end DistancePreservation11
