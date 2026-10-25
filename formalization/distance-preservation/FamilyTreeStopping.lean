import TannerSix
import FamilyBaseGraph
import FamilyNoShort
set_option maxHeartbeats 0
namespace FamilyTreeStopping
open FamilyBaseGraph

theorem no_four : TannerSix.NoFour E := by
  intro v w c d hvw hcd hvc hwc hwd hvd
  exact VoltageCycles.no_four (FamilyNoShort.e 11) FamilyNoShort.base_no_four
    c d v w hcd hvw hvc hvd hwd hwc

theorem no_six : TannerSix.NoSix E := by
  intro v w z c d f hvw hwz hzv hcd hdf hfc hvc hwc hwd hzd hzf hvf
  exact VoltageCycles.no_six (FamilyNoShort.e 11) FamilyNoShort.base_no_six
    c d f w z v hcd hdf hfc hwz hzv hvw hwc hwd hzd hzf hvf hvc

theorem three_checks : TannerSix.ThreeChecks E := by
  intro v
  refine ⟨(fun i => (i,v.2+e i v.1)),?_,?_⟩
  · intro i j h; exact congrArg Prod.fst h
  · intro i; rfl

/-- Structural proof of the same base stopping lower bound, independent of
its finite search certificate. The mathematical bound is classical. -/
theorem base_stopping_six (T : Finset Var) (hT : SmallStopping.Stopping E T) : 6≤T.card :=
  TannerSix.stopping_lower_six E no_four no_six three_checks T hT

#print axioms base_stopping_six
end FamilyTreeStopping
