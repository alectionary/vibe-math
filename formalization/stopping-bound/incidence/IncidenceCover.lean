module

public import IncidenceCore

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence

/-- A graph cover projects stopping supports to stopping supports. Local
injectivity is essential: two selected neighbors must project distinctly. -/
theorem stopping_cover_image
    {V C W D : Type*} [DecidableEq V] [DecidableEq C] [DecidableEq W] [DecidableEq D]
    (E : V → C → Prop) [DecidableRel E]
    (F : W → D → Prop) [DecidableRel F]
    (p : V → W) (q : C → D)
    (maps : ∀ v c, E v c → F (p v) (q c))
    (lifts : ∀ v d, F (p v) d → ∃ c, E v c ∧ q c = d)
    (local_inj : ∀ v w c, E v c → E w c → p v = p w → v = w)
    (T : Finset V) (hT : Stopping E T) : Stopping F (T.image p) := by
  classical
  refine ⟨hT.1.image p, ?_⟩
  intro d hd
  obtain ⟨u,hu⟩ := Finset.card_eq_one.mp hd
  have hu_mem : u ∈ (T.image p).filter (fun w => F w d) := by rw [hu]; simp
  obtain ⟨v,hv,hpv⟩ := Finset.mem_image.mp (Finset.mem_filter.mp hu_mem).1
  have hF : F (p v) d := by simpa [hpv] using (Finset.mem_filter.mp hu_mem).2
  obtain ⟨c,hvc,hq⟩ := lifts v d hF
  have hext : (({v} : Finset V).filter (fun w => E w c)).card = 1 := by
    have heq : ({v} : Finset V).filter (fun w => E w c) = {v} := by
      apply Finset.filter_eq_self.mpr
      intro w hw
      have hwv : w = v := by simpa using hw
      simpa [hwv] using hvc
    rw [heq]; simp
  obtain ⟨w,hw,hwv,hwc⟩ := stopping_extension E T {v} hT (Finset.singleton_subset_iff.mpr hv) c hext
  have hpw_mem : p w ∈ (T.image p).filter (fun a => F a d) := by
    exact Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨w,hw,rfl⟩, by simpa [hq] using maps w c hwc⟩
  have hpw : p w = u := by simpa [hu] using hpw_mem
  have heq := local_inj v w c hvc hwc (hpv.trans hpw.symm)
  exact hwv (by simp [heq])

end Incidence
