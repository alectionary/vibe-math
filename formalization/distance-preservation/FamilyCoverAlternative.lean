import CoverDistance
import FamilyTreeStopping
import FamilyTheorem
set_option maxHeartbeats 0
namespace FamilyCoverAlternative
variable {L : Nat} [NeZero L]

/-- The full-family classical lower bound using the structural Tanner-tree
proof, independently of the finite stopping-set search certificate. -/
theorem classical_lower_twelve (hL : 11 ∣ L) (x : CyclicCover.Word (ZMod L))
    (hx : CyclicCover.Kernel DistanceFamily.liftE x) (hn : x≠0) :
    12≤(CoverWeight.support x).card := by
  let p : ZMod L →+ ZMod 11 := (ZMod.castHom hL (ZMod 11)).toAddMonoidHom
  have he : (fun i j => p (DistanceFamily.liftE i j)) = FamilyBaseGraph.e := by
    funext i j
    simp [p,DistanceFamily.liftE,FamilyBaseGraph.e]
  apply CoverDistance.lower_bound p DistanceFamily.liftE 12 6 _ _ x hx hn
  · intro y hy hny
    rw [he] at hy
    exact FamilyBaseGraph.code_lower_twelve y hy hny
  · intro T hT
    rw [he] at hT
    exact FamilyTreeStopping.base_stopping_six T hT

#print axioms classical_lower_twelve
end FamilyCoverAlternative
