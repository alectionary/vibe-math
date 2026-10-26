import ElevenEncoding
import CatalogExclusion11
import ConstantRows
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

theorem lowColumn_injective : Function.Injective lowColumn := by
  intro a b he
  exact Fin.ext (congrArg (fun j : Fin 4 => j.val) he)

/-- Full source-level treatment of the canonical mixed weight-eleven profile,
including the constant-label stabilizer case and actual injective support map. -/
theorem source_canonical_eleven_stabilizer
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hD : 10<D) (hC : ClassicalAtLeast e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (hU : ∀ j : Fin 3,leftCount u (lowColumn j)=1)
    (hU3 : leftCount u 3=5) (hV : ∀ i,rightCount v i=1) :
    GeneralLP.InSpanX e u v := by
  obtain ⟨K,S,H,T,hu,hv,hmatch,hcase⟩ := actual_singleton_label_alternative e h4 u v hk
    lowColumn lowColumn_injective hU hV
  rcases hcase with ⟨K₀,H₀,hK,hH⟩|⟨hK,hH⟩
  · have hu' : ∀ j k s,u (lowColumn j) k s=if k=K₀ ∧ s=S j then 1 else 0 := by
      simpa only [hK] using hu
    have hv' : ∀ i l t,v l i t=if l=H₀ ∧ t=T i then 1 else 0 := by
      simpa only [hH] using hv
    obtain ⟨z,hleft,hright⟩ := constant_singleton_rows e u v hk lowColumn K₀ H₀ S T hu' hv'
    apply single_exception_cancellation e D (by omega) hC u (rowU e H₀ K₀ z)
      v (rowV e H₀ K₀ z) hk (source_row_full_span e H₀ K₀ z) 3 (by omega)
      (by rw [source_row_left_count]) _ hright
    intro j hj
    have hlt : j.val<3 := by
      have hbound := j.isLt
      have hn : j.val≠3 := fun he => hj (Fin.ext he)
      omega
    let j' : Fin 3 := ⟨j.val,hlt⟩
    have he : lowColumn j'=j := Fin.ext rfl
    simpa only [he] using hleft j'
  · obtain ⟨n⟩ := actual_k23_numbering e h4 h6 u v hk hw hU3 hV
    obtain ⟨c⟩ := actual_k23_internal_checks e h4 h6 u v hk hw n
    obtain ⟨d⟩ := actual_eleven_geometry e h4 h6 u v hk hw n c K S H T hK hH hmatch hv
    obtain ⟨p,hp⟩ := eleven_geometry_encodes e d
    exact False.elim (no_eleven_pattern_realization e h4 h6 hR0 hC0 hCP hP D hD hC p hp)

#print axioms source_canonical_eleven_stabilizer
end TruncatedDistance
