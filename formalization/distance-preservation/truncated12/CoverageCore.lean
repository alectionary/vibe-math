import FastCatalogChecker
import Lean
set_option maxHeartbeats 0
namespace KernelCatalog

/-- Quantified finite coverage, using checked certificates as witnesses. -/
def Covered (w start count : Nat) : Prop :=
  ∀ p : Fin count,∃ c : Certificate,checkCertificateFast w (start+p.val) c=true

theorem covered_single (w start : Nat) (c : Certificate)
    (h : checkCertificateFast w start c=true) : Covered w start 1 := by
  intro p
  have hp : p.val=0 := by omega
  refine ⟨c,?_⟩
  simpa only [hp,Nat.add_zero] using h

theorem covered_append (w start a b : Nat)
    (ha : Covered w start a) (hb : Covered w (start+a) b) : Covered w start (a+b) := by
  intro p
  by_cases h : p.val<a
  · exact ha ⟨p.val,h⟩
  · have ht : p.val-a<b := by have := p.isLt;omega
    obtain ⟨c,hc⟩ := hb ⟨p.val-a,ht⟩
    refine ⟨c,?_⟩
    have he : start+a+(p.val-a)=start+p.val := by omega
    simpa only [he] using hc

#print axioms covered_single
#print axioms covered_append
end KernelCatalog
