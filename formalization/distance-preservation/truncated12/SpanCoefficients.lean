import GaugeTransport
import GeneralSymmetry
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

/-- The coefficient description ranges over every source stabilizer row. -/
theorem full_span_coefficients (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.InSpanX e u v ↔ ∃ w : Fin 3 → Fin 4 → ZMod L → ZMod 2,
      u=GeneralLP.stabilizerLeft e w ∧ v=GeneralLP.stabilizerRight e w := by
  constructor
  · rintro ⟨w,hw⟩
    refine ⟨fun i j s => w ((i,j),s),?_,?_⟩
    · funext j k s
      exact (hw (.inl ((j,k),s))).trans
        (GeneralLP.x_span_left e (fun i j s => w ((i,j),s)) j k s)
    · funext l i s
      exact (hw (.inr ((l,i),s))).trans
        (GeneralLP.x_span_right e (fun i j s => w ((i,j),s)) l i s)
  · rintro ⟨w,rfl,rfl⟩
    refine ⟨fun c => w c.1.1 c.1.2 c.2,?_⟩
    rintro (⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩)
    · exact (GeneralLP.x_span_left e w j k s).symm
    · exact (GeneralLP.x_span_right e w l i s).symm

theorem gauge_preserves_full_span (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (h : GeneralLP.InSpanX e u v) :
    GeneralLP.InSpanX (gaugeE e r c) (gaugeU u c) (gaugeV v r) := by
  obtain ⟨w,rfl,rfl⟩ := (full_span_coefficients e u v).mp h
  apply (full_span_coefficients _ _ _).mpr
  refine ⟨gaugeW w r c,?_,?_⟩
  · funext j k s
    exact (gauge_span_left e r c w j k s).symm
  · funext l i s
    exact (gauge_span_right e r c w l i s).symm

theorem full_span_gauge_iff (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    GeneralLP.InSpanX (gaugeE e r c) (gaugeU u c) (gaugeV v r) ↔
      GeneralLP.InSpanX e u v := by
  constructor
  · intro h
    have hi := gauge_preserves_full_span (gaugeE e r c) (fun i => -r i) (fun j => -c j)
      (gaugeU u c) (gaugeV v r) h
    have he : gaugeE (gaugeE e r c) (fun i => -r i) (fun j => -c j)=e := by
      funext i j
      unfold gaugeE
      ring
    have hu : gaugeU (gaugeU u c) (fun j => -c j)=u := by
      funext j k s
      unfold gaugeU
      congr 1
      ring
    have hv : gaugeV (gaugeV v r) (fun i => -r i)=v := by
      funext l i s
      unfold gaugeV
      congr 1
      ring
    simpa only [he,hu,hv] using hi
  · exact gauge_preserves_full_span e r c u v

#print axioms full_span_coefficients
#print axioms full_span_gauge_iff
end TruncatedDistance
