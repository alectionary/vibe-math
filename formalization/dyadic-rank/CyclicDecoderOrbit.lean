import CyclicDecoderPersistence
namespace CyclicDecoderOrbit
open CyclicDecoderPersistence

theorem prior_clipping_identity :
    CyclicMergedMessages.clip CyclicMergedMessages.prior = CyclicMergedMessages.prior := by decide +kernel

theorem orbit_add {S : Type*} (f : S → S) (x : S) (n m : Nat) :
    orbit f x (n+m) = orbit f (orbit f x n) m := by
  induction m with
  | zero => rfl
  | succ m ih =>
    change f (orbit f x (n+m)) = f (orbit f (orbit f x n) m)
    exact congrArg f ih
end CyclicDecoderOrbit
