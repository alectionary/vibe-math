import GeneralSymmetry
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : Nat} [NeZero L]

def pureX (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) : Prop :=
  (∀ c, (∑ q, GeneralLP.HZ e c q*x q)=0) ∧ ¬fullSpanX e x
def pureZ (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) : Prop :=
  (∀ c, (∑ q, GeneralLP.HX e c q*x q)=0) ∧ ¬fullSpanZ e x

theorem pureX_iff_swap_pureZ (e : Fin 3 → Fin 4 → ZMod L) (x : Qubit L → ZMod 2) :
    pureX e x ↔ pureZ e (fun q => x (squareSwap q)) := by
  constructor
  · intro h
    exact ⟨(kernel_swap e x).mp h.1,fun hs => h.2 ((full_span_swap e x).mpr hs)⟩
  · intro h
    exact ⟨(kernel_swap e x).mpr h.1,fun hs => h.2 ((full_span_swap e x).mp hs)⟩

/-- A bound for the source X sector transfers to its full Z logical quotient. -/
theorem z_bound_of_x_bound (e : Fin 3 → Fin 4 → ZMod L) (b : ℕ)
    (hbound : ∀ x, pureX e x → b≤(CoverWeight.support x).card)
    (z : Qubit L → ZMod 2) (hz : pureZ e z) : b≤(CoverWeight.support z).card := by
  have hx : pureX e (fun q => z (squareSwap q)) := by
    apply (pureX_iff_swap_pureZ e _).mpr
    simpa only [squareSwap_twice] using hz
  exact (hbound _ hx).trans_eq (swap_weight z)

/-- A nontrivial binary Pauli pair has a nontrivial pure component no heavier
than its union support. All stabilizer row combinations are retained. -/
theorem pauli_bound_of_x_bound (e : Fin 3 → Fin 4 → ZMod L) (b : ℕ)
    (hbound : ∀ x, pureX e x → b≤(CoverWeight.support x).card)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c, (∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c, (∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) :
    b≤((CoverWeight.support x) ∪ (CoverWeight.support z)).card := by
  by_cases hs : fullSpanX e x
  · have hzn : ¬fullSpanZ e z := fun h => hn ⟨hs,h⟩
    exact (z_bound_of_x_bound e b hbound z ⟨hz,hzn⟩).trans
      (Finset.card_le_card Finset.subset_union_right)
  · exact (hbound x ⟨hx,hs⟩).trans (Finset.card_le_card Finset.subset_union_left)

#print axioms z_bound_of_x_bound
#print axioms pauli_bound_of_x_bound
end TruncatedDistance
