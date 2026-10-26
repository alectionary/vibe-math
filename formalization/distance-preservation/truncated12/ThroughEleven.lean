import Coverage10
import TwelveConditional
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- Every actual source kernel word below min(D,12) is a full stabilizer.
All finite catalog coverage is discharged by kernel-checked closed proofs. -/
theorem source_kernel_below_twelve_is_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (h : DistanceCriterion e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ a,(∑ q,GeneralLP.HZ e a q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card<min D 12) :
    GeneralLP.InSpanX e u v :=
  source_kernel_below_twelve_of_coverage complete_coverage10 e D h u v hk hw

theorem source_x_bound_twelve
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (h : DistanceCriterion e D)
    (x : Qubit L → ZMod 2) (hx : pureX e x) : min D 12≤(CoverWeight.support x).card :=
  source_x_bound_twelve_of_coverage complete_coverage10 e D h x hx

/-- The exact normalized strengthened criterion implies the ordinary Pauli
union-weight bound min(D,12), for arbitrary cyclic modulus and both full spans.
The classical/transpose predicates retain the zero-kernel infinity convention. -/
theorem source_pauli_bound_twelve
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D) (hT : TransposeAtLeast e D)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c,(∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) :
    min D 12≤((CoverWeight.support x)∪(CoverWeight.support z)).card :=
  source_pauli_bound_twelve_of_coverage complete_coverage10 e D
    ⟨h4,h6,hR0,hC0,hCP,hP,hC,hT⟩ x z hx hz hn

#print axioms source_kernel_below_twelve_is_stabilizer
#print axioms source_x_bound_twelve
#print axioms source_pauli_bound_twelve
end TruncatedDistance
