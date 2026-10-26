import FiniteLabels
import CatalogChecker
set_option maxHeartbeats 0
namespace TruncatedDistance
open KernelCatalog

def tenRank (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64) : Nat :=
  64*(9*(36*(c 0).val+6*(c 1).val+(c 2).val)+(3*(r 0).val+(r 1).val))+bits.val

theorem tenRank_bound (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64) :
    tenRank c r bits<124416 := by
  unfold tenRank
  have := (c 0).isLt;have := (c 1).isLt;have := (c 2).isLt
  have := (r 0).isLt;have := (r 1).isLt;have := bits.isLt
  omega

theorem tenRank_mod (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64) :
    tenRank c r bits%64=bits.val := by
  unfold tenRank
  have := bits.isLt
  omega

theorem tenRank_columns (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64)
    (j : Fin 3) : column10 (tenRank c r bits) j.val=(c j).val := by
  have hdiv : tenRank c r bits/64=9*(36*(c 0).val+6*(c 1).val+(c 2).val)+(3*(r 0).val+(r 1).val) := by
    unfold tenRank
    have := bits.isLt
    omega
  have hq : tenRank c r bits/64/9=36*(c 0).val+6*(c 1).val+(c 2).val := by
    rw [hdiv]
    have := (r 0).isLt;have := (r 1).isLt
    omega
  have := (c 0).isLt;have := (c 1).isLt;have := (c 2).isLt
  fin_cases j
  · change (tenRank c r bits/64/9)/36=(c 0).val
    rw [hq]
    omega
  · change (tenRank c r bits/64/9)/6%6=(c 1).val
    rw [hq]
    omega
  · change (tenRank c r bits/64/9)%6=(c 2).val
    rw [hq]
    omega

theorem tenRank_rows (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64)
    (i : Fin 2) : row10 (tenRank c r bits) i.val=(r i).val := by
  have hdiv : tenRank c r bits/64=9*(36*(c 0).val+6*(c 1).val+(c 2).val)+(3*(r 0).val+(r 1).val) := by
    unfold tenRank
    have := bits.isLt
    omega
  have := (r 0).isLt;have := (r 1).isLt
  fin_cases i
  · change (tenRank c r bits/64)/3%3=(r 0).val
    rw [hdiv]
    omega
  · change (tenRank c r bits/64)%3=(r 1).val
    rw [hdiv]
    omega

theorem tenRank_flip (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64)
    (i j : Nat) : flip10 (tenRank c r bits) i j=(bits.val/(2^(5-(3*i+j))))%2 := by
  simp only [flip10,tenRank_mod]

#print axioms tenRank_bound
#print axioms tenRank_columns
#print axioms tenRank_rows
end TruncatedDistance
