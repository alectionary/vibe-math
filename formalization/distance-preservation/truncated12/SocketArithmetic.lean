import SocketEdges
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {C : Type*} [Fintype C] [DecidableEq C]

/-- A zero-or-two occupied check has either two U sockets, two V sockets,
or one of each. Summing gives the exact U socket identity. -/
theorem socket_sum_identity (a b : C → ℕ)
    (h : ∀ c, a c+b c=0 ∨ a c+b c=2) :
    (∑ c,a c)=2*(Finset.univ.filter (fun c => a c=2)).card+
      (Finset.univ.filter (fun c => a c=1)).card := by
  classical
  have hp (c : C) : a c=2*(if a c=2 then 1 else 0)+(if a c=1 then 1 else 0) := by
    have hc := h c
    split_ifs <;> omega
  calc
    (∑ c,a c) = ∑ c,(2*(if a c=2 then 1 else 0)+(if a c=1 then 1 else 0)) :=
      Finset.sum_congr rfl (fun c _ => hp c)
    _ = _ := by simp only [Finset.sum_add_distrib,← Finset.mul_sum,Finset.card_filter]

theorem cross_sockets_le (a b : C → ℕ)
    (h : ∀ c, a c+b c=0 ∨ a c+b c=2) :
    (Finset.univ.filter (fun c => a c=1)).card≤∑ c,b c := by
  classical
  rw [Finset.card_filter]
  apply Finset.sum_le_sum
  intro c _
  have hc := h c
  split_ifs <;> omega

theorem socket_pair_lower_bound (a b : C → ℕ)
    (h : ∀ c, a c+b c=0 ∨ a c+b c=2) :
    ((∑ c,a c)-(∑ c,b c))/2≤(Finset.univ.filter (fun c => a c=2)).card := by
  have hsum := socket_sum_identity a b h
  have hcross := cross_sockets_le a b h
  omega

#print axioms socket_sum_identity
#print axioms socket_pair_lower_bound
end TruncatedDistance
