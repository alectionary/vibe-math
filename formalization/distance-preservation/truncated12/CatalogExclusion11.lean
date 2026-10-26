import Coverage11
import PatternRealizations
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

theorem no_eleven_pattern_realization
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e)) (h6 : TannerSix.NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hD : 10<D) (hC : ClassicalAtLeast e D) (p : Fin 58752) :
    ¬Nonempty (PatternRealization e 11 p.val) := by
  obtain ⟨c,hc⟩ := complete_coverage11 p
  simp only [Nat.zero_add] at hc
  exact certified_pattern_has_no_source_realization e h4 h6 hR0 hC0 hCP hP D hC
    11 p.val c hc (fun _ => hD)

#print axioms no_eleven_pattern_realization
end TruncatedDistance
