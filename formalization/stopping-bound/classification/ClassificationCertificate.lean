module
public import Classification
public import IncidenceCertificate
@[expose] public section
set_option linter.unusedSimpArgs false
namespace Incidence.Classification
open Incidence

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
/-- No nontrivial coordinate translation preserves the six-point support. -/
theorem normalized_center_certificate : ∀ c : Check,
    (rowList c).all (fun v => decide (v ∈ rowList (0,0))) = true → c = (0,0) := by
  decide +kernel

lemma rowSupport_eq_zero (c : Check) (h : rowSupport c = rowSupport (0,0)) : c = (0,0) := by
  apply normalized_center_certificate c
  apply List.all_eq_true.mpr
  intro v hv
  have hv' : v ∈ rowSupport c := by simpa [rowSupport] using hv
  rw [h] at hv'
  simpa [rowSupport] using hv'

theorem rowSupport_injective : Function.Injective rowSupport := by
  intro c d h
  have hh := congrArg (fun S : Finset Var => S.image (shiftV (-d))) h
  rw [shift_rowSupport,shift_rowSupport,add_neg_cancel] at hh
  have hz := rowSupport_eq_zero _ hh
  apply Prod.ext
  · apply sub_eq_zero.mp
    simpa [sub_eq_add_neg] using congrArg Prod.fst hz
  · apply sub_eq_zero.mp
    simpa [sub_eq_add_neg] using congrArg Prod.snd hz

/-- The translation action on the classified supports is free. -/
theorem translation_free (c t : Check)
    (h : (rowSupport c).image (shiftV t) = rowSupport c) : t = (0,0) := by
  rw [shift_rowSupport] at h
  have e := rowSupport_injective h
  apply Prod.ext
  · apply add_left_cancel (a := c.1)
    simpa using congrArg Prod.fst e
  · apply add_left_cancel (a := c.2)
    simpa using congrArg Prod.snd e

theorem classification_iff (T : Finset Var) :
    (Stopping E T ∧ T.card = 6) ↔ ∃ c : Check, T = rowSupport c := by
  constructor
  · rintro ⟨hs,h6⟩; exact size_six_classification T hs h6
  · rintro ⟨c,rfl⟩; exact ⟨rowSupport_stopping c,rowSupport_card c⟩

theorem unique_center (T : Finset Var) (hs : Stopping E T) (h6 : T.card = 6) :
    ∃! c : Check, T = rowSupport c := by
  obtain ⟨c,hc⟩ := size_six_classification T hs h6
  refine ⟨c,hc,?_⟩
  intro d hd
  exact rowSupport_injective (hd.symm.trans hc)

def minimumSupports : Finset (Finset Var) := Finset.univ.image rowSupport

theorem mem_minimumSupports (T : Finset Var) :
    T ∈ minimumSupports ↔ Stopping E T ∧ T.card = 6 := by
  simp only [minimumSupports,Finset.mem_image,Finset.mem_univ,true_and]
  rw [classification_iff]
  exact ⟨fun ⟨c,hc⟩ => ⟨c,hc.symm⟩,fun ⟨c,hc⟩ => ⟨c,hc.symm⟩⟩

theorem minimumSupports_card : minimumSupports.card = 441 := by
  rw [minimumSupports,Finset.card_image_of_injective _ rowSupport_injective,Finset.card_univ]
  exact Incidence.dimensions.2

theorem single_translation_orbit (T : Finset Var) :
    (Stopping E T ∧ T.card = 6) ↔ ∃ c : Check, T = six.image (shiftV c) := by
  simpa only [rowSupport_image] using classification_iff T

lemma HZ_shift (t : Check) (c : Check) (v : Var) :
    HZ (shiftC t c) (shiftV t v) = HZ c v := by
  rcases v with ⟨b,j,f⟩
  cases b <;>
    simp [HZ,A,B,P,shiftC,shiftV,
      add_right_comm c.1 t.1 1,add_right_comm c.1 t.1 2,
      add_right_comm c.2 t.2 27,add_right_comm c.2 t.2 54,
      add_right_comm f t.2 1,add_right_comm f t.2 6]

theorem rowSupport_HZ (c : Check) (v : Var) :
    v ∈ rowSupport c ↔ HZ c v = 1 := by
  have hs := HZ_shift c (0,0) (shiftV (-c) v)
  have hback : shiftV c (shiftV (-c) v) = v := by simp [shiftV,add_assoc]
  have hc : shiftC c (0,0) = c := by simp [shiftC]
  rw [hback,hc] at hs
  rw [rowSupport_image]
  have hv : v ∈ six.image (shiftV c) ↔ shiftV (-c) v ∈ six := by
    rw [Finset.mem_image]
    constructor
    · rintro ⟨u,hu,rfl⟩
      simpa [shiftV,add_assoc] using hu
    · intro hu;exact ⟨shiftV (-c) v,hu,hback⟩
  rw [hv,six_is_HZ_row,hs]

lemma HZ_binary (c : Check) (v : Var) : HZ c v = 0 ∨ HZ c v = 1 := by
  have hbase : ∀ w : Var, HZ (0,0) w = 0 ∨ HZ (0,0) w = 1 := by decide +kernel
  have hs := HZ_shift c (0,0) (shiftV (-c) v)
  have hback : shiftV c (shiftV (-c) v) = v := by simp [shiftV,add_assoc]
  have hc : shiftC c (0,0) = c := by simp [shiftC]
  rw [hback,hc] at hs
  rcases hbase (shiftV (-c) v) with h | h
  · exact Or.inl (hs.trans h)
  · exact Or.inr (hs.trans h)

/-- Actual binary source matrix, exactly the t=1 member of the previous family. -/
theorem binary_source_classification (T : Finset Var) :
    (Stopping (fun v c => Incidence.Family.HX2 (n := 63) c v = 1) T ∧ T.card = 6) ↔
      ∃! c : Check, T = Finset.univ.filter (fun v => Incidence.Family.HZ2 (n := 63) c v = 1) := by
  have hx : ∀ v c, Incidence.Family.HX2 (n := 63) c v = 1 ↔ E v c := by
    intro v c
    simpa only [E,col,Incidence.Family.E,Incidence.Family.col] using
      Incidence.Family.HX2_incidence (n := 63) (dvd_refl 63) v c
  have hz : ∀ c : Check,
      rowSupport c = Finset.univ.filter (fun v => Incidence.Family.HZ2 (n := 63) c v = 1) := by
    intro c
    apply Finset.ext
    intro v
    constructor
    · intro hv
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ v,?_⟩
      have hn := (rowSupport_HZ c v).mp hv
      change (HZ c v : ZMod 2) = 1
      simp only [hn,Nat.cast_one]
    · intro hv
      have hm := (Finset.mem_filter.mp hv).2
      apply (rowSupport_HZ c v).mpr
      change (HZ c v : ZMod 2) = 1 at hm
      rcases HZ_binary c v with h | h
      · simp [h] at hm
      · exact h
  simp only [Stopping,hx]
  constructor
  · rintro ⟨hs,h6⟩
    obtain ⟨c,hc,hu⟩ := unique_center T hs h6
    refine ⟨c,?_,?_⟩
    · exact hc.trans (hz c)
    · intro d hd;apply hu d;exact hd.trans (hz d).symm
  · rintro ⟨c,hc,_⟩
    exact (classification_iff T).mpr ⟨c,hc.trans (hz c).symm⟩

theorem rowSupport_profile (c d : Check) :
    ((rowSupport c).filter (fun v => E v d)).card = 0 ∨
    ((rowSupport c).filter (fun v => E v d)).card = 2 := by
  obtain ⟨d,rfl⟩ := (shiftC c).surjective d
  rw [rowSupport_image,Finset.filter_image]
  simp only [shift_incidence c]
  rw [Finset.card_image_of_injective _ (shiftV c).injective]
  exact six_profile d

theorem rowSupport_sides (c : Check) :
    ((rowSupport c).filter (fun v => v.1 = false)).card = 3 ∧
    ((rowSupport c).filter (fun v => v.1 = true)).card = 3 := by
  have hb : (six.filter (fun v => v.1 = false)).card = 3 ∧
      (six.filter (fun v => v.1 = true)).card = 3 := by decide +kernel
  have hp (b : Bool) :
      ((rowSupport c).filter (fun v => v.1 = b)).card =
        (six.filter (fun v => v.1 = b)).card := by
    rw [rowSupport_image,Finset.filter_image]
    change ((six.filter (fun v => v.1 = b)).image (shiftV c)).card = _
    rw [Finset.card_image_of_injective _ (shiftV c).injective]
  rwa [hp false,hp true]

/-- Minimum supports are elementary with three variables on each matrix side.
These are consequences, not hypotheses of the exhaustive classification. -/
theorem minimum_structure (T : Finset Var) (hs : Stopping E T) (h6 : T.card = 6) :
    (T.filter (fun v => v.1 = false)).card = 3 ∧
    (T.filter (fun v => v.1 = true)).card = 3 ∧
    ∀ d : Check, (T.filter (fun v => E v d)).card = 0 ∨
      (T.filter (fun v => E v d)).card = 2 := by
  obtain ⟨c,rfl⟩ := size_six_classification T hs h6
  exact ⟨(rowSupport_sides c).1,(rowSupport_sides c).2,rowSupport_profile c⟩

theorem mem_minimumSupports_binary (T : Finset Var) :
    T ∈ minimumSupports ↔
      Stopping (fun v c => Incidence.Family.HX2 (n := 63) c v = 1) T ∧ T.card = 6 := by
  rw [mem_minimumSupports]
  have hx : ∀ v c, Incidence.Family.HX2 (n := 63) c v = 1 ↔ E v c := by
    intro v c
    simpa only [E,col,Incidence.Family.E,Incidence.Family.col] using
      Incidence.Family.HX2_incidence (n := 63) (dvd_refl 63) v c
  simp only [Stopping,hx]

/-- Single consumer contract: counted family equals ALL actual binary size-six
stopping supports, and each is the support of a unique actual binary Z-check row. -/
theorem source_complete_certificate :
    minimumSupports.card = 441 ∧
    (∀ T : Finset Var, T ∈ minimumSupports ↔
      Stopping (fun v c => Incidence.Family.HX2 (n := 63) c v = 1) T ∧ T.card = 6) ∧
    (∀ T : Finset Var,
      (Stopping (fun v c => Incidence.Family.HX2 (n := 63) c v = 1) T ∧ T.card = 6) ↔
      ∃! c : Check, T = Finset.univ.filter (fun v => Incidence.Family.HZ2 (n := 63) c v = 1)) := by
  exact ⟨minimumSupports_card,mem_minimumSupports_binary,binary_source_classification⟩

theorem binary_source_structure (T : Finset Var)
    (hs : Stopping (fun v c => Incidence.Family.HX2 (n := 63) c v = 1) T)
    (h6 : T.card = 6) :
    (T.filter (fun v => v.1 = false)).card = 3 ∧
    (T.filter (fun v => v.1 = true)).card = 3 ∧
    ∀ d : Check, (T.filter (fun v => Incidence.Family.HX2 (n := 63) d v = 1)).card = 0 ∨
      (T.filter (fun v => Incidence.Family.HX2 (n := 63) d v = 1)).card = 2 := by
  have hx : ∀ v c, Incidence.Family.HX2 (n := 63) c v = 1 ↔ E v c := by
    intro v c
    simpa only [E,col,Incidence.Family.E,Incidence.Family.col] using
      Incidence.Family.HX2_incidence (n := 63) (dvd_refl 63) v c
  have he : Stopping E T := by simpa only [Stopping,hx] using hs
  simpa only [hx] using minimum_structure T he h6
end Incidence.Classification
