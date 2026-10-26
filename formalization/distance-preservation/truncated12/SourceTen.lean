import TenEncoding
import CoverageCore
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- The finite coverage premise is independent, explicit catalog evidence.
The final distance theorem must instantiate it with the completed kernel replay. -/
theorem source_canonical_ten_impossible_of_coverage
    (hCoverage : Covered 10 0 124416)
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hD : 10<D) (hC : ClassicalAtLeast e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hU0 : leftCount u 0=0) (hV0 : rightCount v 0=0)
    (hU : ∀ j : Fin 3,leftCount u j.succ=2)
    (hV : ∀ i : Fin 2,rightCount v i.succ=2) : False := by
  obtain ⟨p,hp⟩ := actual_canonical_ten_support_encodes e h4 hR0 hC0 u v hk hU0 hV0 hU hV
  obtain ⟨c,hc⟩ := hCoverage p
  simp only [Nat.zero_add] at hc
  exact certified_pattern_has_no_source_realization e h4 h6 hR0 hC0 hCP hP D hC
    10 p.val c hc (fun _ => hD) hp

#print axioms source_canonical_ten_impossible_of_coverage
end TruncatedDistance
