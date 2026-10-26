import FiniteLabels
import CatalogChecker
set_option maxHeartbeats 0
namespace TruncatedDistance
open KernelCatalog

def elevenRank (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) : Nat :=
  2448*c.val+408*r.val+2*labels.val+o.val

theorem elevenRank_bound (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) :
    elevenRank c r labels o<58752 := by
  unfold elevenRank
  have := c.isLt;have := r.isLt;have := labels.isLt;have := o.isLt
  omega

theorem elevenRank_columns (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) :
    elevenRank c r labels o/2448=c.val := by
  unfold elevenRank
  have := r.isLt;have := labels.isLt;have := o.isLt
  omega

theorem elevenRank_rows (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) :
    elevenRank c r labels o/408%6=r.val := by
  unfold elevenRank
  have := r.isLt;have := labels.isLt;have := o.isLt
  omega

theorem elevenRank_labels (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) :
    elevenRank c r labels o/2%204=labels.val := by
  unfold elevenRank
  have := labels.isLt;have := o.isLt
  omega

theorem elevenRank_orientation (c : Fin 24) (r : Fin 6) (labels : Fin 204) (o : Fin 2) :
    elevenRank c r labels o%2=o.val := by
  unfold elevenRank
  have := o.isLt
  omega

#print axioms elevenRank_columns
#print axioms elevenRank_labels
end TruncatedDistance
