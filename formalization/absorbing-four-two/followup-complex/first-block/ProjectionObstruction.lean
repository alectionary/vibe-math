import GlobalCounting
import Mathlib.Data.Fintype.Prod
set_option maxHeartbeats 0
namespace ProjectionObstruction

/-- An induced diamond in the global variable projection whose apparent
triangle on variables 0,1,2 is actually one degree-three check. -/
def columns (v : Fin 4) : Finset (Fin 8) :=
  match v.val with
  | 0 => {0,1,3}
  | 1 => {0,2,4}
  | 2 => {0,5,6}
  | _ => {1,2,7}

def projectedEdges : Finset (Fin 4 × Fin 4) :=
  (Finset.univ ×ˢ Finset.univ).filter
    (fun p => p.1.val < p.2.val ∧ (columns p.1 ∩ columns p.2).Nonempty)

theorem cubic : ∀ v, (columns v).card = 3 := by decide

theorem no_four : ∀ u v, u ≠ v → (columns u ∩ columns v).card ≤ 1 := by decide

theorem five_projected_edges : projectedEdges.card = 5 := by decide

theorem induced_degree_three : (GlobalCounting.selected columns Finset.univ 0).card = 3 := by decide

theorem count42_zero : GlobalCounting.count42 columns = 0 := by decide

#print axioms five_projected_edges
#print axioms induced_degree_three
#print axioms count42_zero
end ProjectionObstruction
