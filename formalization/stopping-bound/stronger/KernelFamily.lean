import PowersFamily
import KernelStopping
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
theorem binary_kernel_stopping (S : Finset G) (x : Bool × G → ZMod 2)
    (hx : x ≠ 0) (hk : (X (ZMod 2) S).mulVec x = 0) :
    Incidence.Stopping (E S) (BinaryStopping.support x) := by
  have he : BinaryStopping.matrix (E S) = X (ZMod 2) S := by
    ext c v
    exact (entry _ S v c).symm
  apply BinaryStopping.kernel_stopping (E S) x hx
  simpa only [he] using hk

theorem kernel_weight_bound (S : Finset G) (hs : IsSidon S)
    (x : Bool × G → ZMod 2) (hx : x ≠ 0) (hk : (X (ZMod 2) S).mulVec x = 0) :
    2*(S.card+1) ≤ 3*(BinaryStopping.support x).card :=
  stopping_bound S hs _ (binary_kernel_stopping S x hx hk)
end SidonStopping

namespace PowersThree
open Matrix
theorem growing_kernel_weight (d t : ℕ) [NeZero (liftLength d t)]
    (x : Bool × ZMod (liftLength d t) → ZMod 2) (hx : x ≠ 0)
    (hk : (SidonStopping.X (ZMod 2) (support (2*d) (liftLength d t))).mulVec x = 0) :
    d+1 ≤ (BinaryStopping.support x).card :=
  arbitrary_fixed_guarantee d t _ (SidonStopping.binary_kernel_stopping _ x hx hk)
end PowersThree
