import PaschHGPCount
import PaschConsumers
import HGPGramObstruction
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace PaschSTS13
open PaschKernelCount PaschGlobalCount
-- Same previously credited STS(13) trade from the earlier research blocks.

def baseA (v : Fin 26) : Finset (Fin 13) :=
  match v.val with
  | 0 => {0,1,4}
  | 1 => {0,2,7}
  | 2 => {0,3,12}
  | 3 => {0,5,11}
  | 4 => {0,6,8}
  | 5 => {0,9,10}
  | 6 => {1,2,5}
  | 7 => {1,3,8}
  | 8 => {1,6,12}
  | 9 => {1,7,9}
  | 10 => {1,10,11}
  | 11 => {2,3,6}
  | 12 => {2,4,9}
  | 13 => {2,8,10}
  | 14 => {2,11,12}
  | 15 => {3,4,7}
  | 16 => {3,5,10}
  | 17 => {3,9,11}
  | 18 => {4,5,8}
  | 19 => {4,6,11}
  | 20 => {4,10,12}
  | 21 => {5,6,9}
  | 22 => {5,7,12}
  | 23 => {6,7,10}
  | 24 => {7,8,11}
  | 25 => {8,9,12}
  | _ => ∅

theorem cubic_A : ∀ v, (baseA v).card = 3 := by decide
theorem linear_A : ∀ u v, u ≠ v → (baseA u ∩ baseA v).card ≤ 1 := by decide

def baseB (v : Fin 26) : Finset (Fin 13) :=
  match v.val with
  | 0 => {0,1,4}
  | 1 => {0,2,7}
  | 2 => {0,3,12}
  | 3 => {0,5,11}
  | 4 => {0,6,8}
  | 5 => {0,9,10}
  | 6 => {1,2,5}
  | 7 => {1,3,8}
  | 8 => {1,6,12}
  | 9 => {1,7,9}
  | 10 => {1,10,11}
  | 11 => {2,3,6}
  | 12 => {2,4,9}
  | 13 => {2,8,10}
  | 14 => {2,11,12}
  | 15 => {3,4,10}
  | 16 => {3,5,7}
  | 17 => {3,9,11}
  | 18 => {4,5,8}
  | 19 => {4,6,11}
  | 20 => {4,7,12}
  | 21 => {5,6,9}
  | 22 => {5,10,12}
  | 23 => {6,7,10}
  | 24 => {7,8,11}
  | 25 => {8,9,12}
  | _ => ∅

theorem cubic_B : ∀ v, (baseB v).card = 3 := by decide
theorem linear_B : ∀ u v, u ≠ v → (baseB u ∩ baseB v).card ≤ 1 := by decide

theorem equal_point_Gram : HGPGramObstruction.checkGram baseA = HGPGramObstruction.checkGram baseB := by
  funext c d
  have h : ∀ c d, HGPGramObstruction.checkGram baseA c d = HGPGramObstruction.checkGram baseB c d := by decide
  exact h c d

#print axioms equal_point_Gram
end PaschSTS13
