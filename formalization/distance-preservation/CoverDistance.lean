import CyclicCover
set_option maxHeartbeats 0
namespace CoverDistance
variable {A B : Type*} [AddCommGroup A] [AddCommGroup B]
  [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]

/-- Binary cover projection gives the lower bound min(d,2s). The two cases
are nonzero parity projection and total cancellation in every occupied fiber. -/
theorem lower_bound (p : A →+ B) (e : Fin 3 → Fin 4 → A) (d s : Nat)
    (hcode : ∀ y : CyclicCover.Word B, CyclicCover.Kernel (fun i j => p (e i j)) y →
      y≠0 → d≤(CoverWeight.support y).card)
    (hstop : ∀ T : Finset (Fin 4 × B), SmallStopping.Stopping
      (CyclicCover.Adjacent (fun i j => p (e i j))) T → s≤T.card)
    (x : CyclicCover.Word A) (hx : CyclicCover.Kernel e x) (hn : x≠0) :
    min d (2*s) ≤ (CoverWeight.support x).card := by
  let y := CoverWeight.push (CyclicCover.project p) x
  by_cases hy : y=0
  · have hs := hstop _ (CyclicCover.projected_support_stopping p e x hx hn)
    have hw := CoverWeight.zero_push_weight_doubles (CyclicCover.project p) x hy
    exact (Nat.min_le_right d (2*s)).trans ((Nat.mul_le_mul_left 2 hs).trans hw)
  · have hd := hcode y (CyclicCover.kernel_push p e x hx) hy
    have hw := CoverWeight.push_weight_le (CyclicCover.project p) x
    change (CoverWeight.support y).card ≤ (CoverWeight.support x).card at hw
    exact (Nat.min_le_left d (2*s)).trans (hd.trans hw)

#print axioms lower_bound
end CoverDistance
