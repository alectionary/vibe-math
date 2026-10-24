import PaschRootClassification
import PaschVoltage

set_option maxHeartbeats 0
open FourColumnClassification PaschRootClassification
namespace PaschLiftProjection
variable {U C G : Type*} [DecidableEq U] [DecidableEq C] [DecidableEq G]
  [Fintype C] [Fintype G] [AddCommGroup G]

def columns (H : U → Finset C) (z : U → C → G) (v : U × G) : Finset (C × G) :=
  (H v.1).image (fun c => (c,v.2+z v.1 c))

theorem mem_columns (H : U → Finset C) (z : U → C → G) (v : U × G) (c : C) (t : G) :
    (c,t) ∈ columns H z v ↔ c ∈ H v.1 ∧ t=v.2+z v.1 c := by
  simp [columns,Prod.mk.injEq,eq_comm]

theorem same_type_adjacent (H : U → Finset C) (z : U → C → G)
    (u v : U × G) (hp : u.1=v.1)
    (ha : (columns H z u ∩ columns H z v).Nonempty) : u=v := by
  obtain ⟨⟨c,t⟩,hc⟩ := ha
  obtain ⟨hu,hv⟩ := Finset.mem_inter.mp hc
  have hut := (mem_columns H z u c t).mp hu
  have hvt := (mem_columns H z v c t).mp hv
  apply Prod.ext hp
  have h := hut.2.symm.trans hvt.2
  rw [← hp] at h
  exact add_right_cancel h

theorem first_injective (H : U → Finset C) (z : U → C → G) (u : U × G) :
    Set.InjOn Prod.fst (↑(columns H z u) : Set (C × G)) := by
  rintro ⟨c,t⟩ hc ⟨d,s⟩ hd h
  change c=d at h
  subst d
  have hts := ((mem_columns H z u c t).mp hc).2.trans
    ((mem_columns H z u c s).mp hd).2.symm
  exact congrArg (fun t : G => (c,t)) hts

theorem linear (H : U → Finset C) (z : U → C → G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (u v : U × G) (huv : u≠v) :
    (columns H z u ∩ columns H z v).card≤1 := by
  by_cases hp : u.1=v.1
  · have hempty : columns H z u ∩ columns H z v=∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro q hq
      exact huv (same_type_adjacent H z u v hp ⟨q,hq⟩)
    rw [hempty]; simp
  · have hinj : Set.InjOn Prod.fst (↑(columns H z u ∩ columns H z v) : Set (C × G)) := by
      intro x hx y hy hxy
      exact first_injective H z u (Finset.mem_inter.mp hx).1 (Finset.mem_inter.mp hy).1 hxy
    have hsub : (columns H z u ∩ columns H z v).image Prod.fst ⊆ H u.1 ∩ H v.1 := by
      intro c hc
      obtain ⟨⟨d,t⟩,hd,hc⟩ := Finset.mem_image.mp hc
      change d=c at hc
      subst d
      obtain ⟨hu,hv⟩ := Finset.mem_inter.mp hd
      exact Finset.mem_inter.mpr
        ⟨((mem_columns H z u c t).mp hu).1,((mem_columns H z v c t).mp hv).1⟩
    calc
      _=((columns H z u ∩ columns H z v).image Prod.fst).card :=
        (Finset.card_image_of_injOn hinj).symm
      _≤(H u.1 ∩ H v.1).card := Finset.card_le_card hsub
      _≤1 := h4 _ _ hp

theorem cubic (H : U → Finset C) (z : U → C → G) (hd : ∀ v, (H v).card=3)
    (u : U × G) : (columns H z u).card=3 := by
  unfold columns
  rw [Finset.card_image_of_injective]
  · exact hd u.1
  · intro c d h
    exact congrArg Prod.fst h

theorem projected_injective (H : U → Finset C) (z : U → C → G)
    (f : I → U × G) (hf : Function.Injective f)
    (ha : PairComplete (fun i => columns H z (f i))) :
    Function.Injective (fun i => (f i).1) := by
  intro i j hij
  by_contra hne
  exact hne (hf (same_type_adjacent H z (f i) (f j) hij (ha i j hne)))

theorem projected_pair_complete (H : U → Finset C) (z : U → C → G)
    (f : I → U × G) (ha : PairComplete (fun i => columns H z (f i))) :
    PairComplete (fun i => H (f i).1) := by
  intro i j hij
  obtain ⟨⟨c,t⟩,hc⟩ := ha i j hij
  obtain ⟨hi,hj⟩ := Finset.mem_inter.mp hc
  exact ⟨c,Finset.mem_inter.mpr
    ⟨((mem_columns H z (f i) c t).mp hi).1,((mem_columns H z (f j) c t).mp hj).1⟩⟩

theorem projected_check_unique (H : U → Finset C)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (u v : U) (huv : u≠v) (c d : C)
    (hc : c∈H u ∩ H v) (hd : d∈H u ∩ H v) : c=d := by
  exact Finset.card_le_one.mp (h4 u v huv) c hc d hd

/-- A genuine lifted Pasch projects to a genuine base Pasch. In particular
repeated variable types or a projected degree-three check cannot hide one. -/
theorem projected_elementary (H : U → Finset C) (z : U → C → G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (f : I → U × G) (hf : Function.Injective f)
    (ha : PairComplete (fun i => columns H z (f i)))
    (he : ∀ q, (support (fun i => columns H z (f i)) q).card≤2) :
    ∀ c, (support (fun i => H (f i).1) c).card≤2 := by
  have hi := projected_injective H z f hf ha
  intro c
  by_contra hc
  have hlarge : 2<(support (fun i => H (f i).1) c).card := by omega
  obtain ⟨i,j,k,him,hjm,hkm,hij,hik,hjk⟩ := Finset.two_lt_card_iff.mp hlarge
  have hic := (mem_support (fun i => H (f i).1) c i).mp him
  have hjc := (mem_support (fun i => H (f i).1) c j).mp hjm
  have hkc := (mem_support (fun i => H (f i).1) c k).mp hkm
  obtain ⟨⟨d,t⟩,hdt⟩ := ha i j hij
  obtain ⟨hdi,hdj⟩ := Finset.mem_inter.mp hdt
  have di := (mem_columns H z (f i) d t).mp hdi
  have dj := (mem_columns H z (f j) d t).mp hdj
  have hdc : d=c := projected_check_unique H h4 _ _ (fun h => hij (hi h)) _ _
    (Finset.mem_inter.mpr ⟨di.1,dj.1⟩) (Finset.mem_inter.mpr ⟨hic,hjc⟩)
  subst d
  obtain ⟨⟨d,s⟩,hds⟩ := ha i k hik
  obtain ⟨hdi',hdk⟩ := Finset.mem_inter.mp hds
  have di' := (mem_columns H z (f i) d s).mp hdi'
  have dk := (mem_columns H z (f k) d s).mp hdk
  have hdc : d=c := projected_check_unique H h4 _ _ (fun h => hik (hi h)) _ _
    (Finset.mem_inter.mpr ⟨di'.1,dk.1⟩) (Finset.mem_inter.mpr ⟨hic,hkc⟩)
  subst d
  have hts : t=s := di.2.trans di'.2.symm
  subst s
  have hsub : ({i,j,k} : Finset I) ⊆ support (fun i => columns H z (f i)) (c,t) := by
    intro a ham
    simp only [Finset.mem_insert,Finset.mem_singleton] at ham
    rcases ham with rfl | rfl | rfl
    · exact (mem_support _ _ _).mpr hdi
    · exact (mem_support _ _ _).mpr hdj
    · exact (mem_support _ _ _).mpr hdk
  have hcard : ({i,j,k} : Finset I).card=3 := by simp [hij,hik,hjk]
  have hle := (Finset.card_le_card hsub).trans (he (c,t))
  omega

theorem projected_even (H : U → Finset C) (z : U → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (f : I → U × G) (hf : Function.Injective f)
    (ha : PairComplete (fun i => columns H z (f i)))
    (he : ∀ q, (support (fun i => columns H z (f i)) q).card≤2) :
    PaschClassification.EvenChecks (fun i => H (f i).1) := by
  have hi := projected_injective H z f hf ha
  apply (elementary_pair_complete_iff (fun i => H (f i).1)
    (fun i => hd _) (fun i j hij => h4 _ _ (fun h => hij (hi h)))
    (projected_elementary H z h4 f hf ha he)).mp
  exact projected_pair_complete H z f ha

theorem zero_syndrome_projects (H : U → Finset C) (z : U → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (f : I → U × G) (hf : Function.Injective f)
    (heven : PaschClassification.EvenChecks (fun i => columns H z (f i))) :
    Function.Injective (fun i => (f i).1) ∧
      PaschClassification.EvenChecks (fun i => H (f i).1) := by
  have hd' := fun i => cubic H z hd (f i)
  have h4' : ∀ i j : I, i≠j →
      (columns H z (f i) ∩ columns H z (f j)).card≤1 :=
    fun i j hij => linear H z h4 (f i) (f j) (fun h => hij (hf h))
  have he := PaschClassification.even_checks_elementary _ hd' h4' heven
  have ha := (elementary_pair_complete_iff _ hd' h4' he).mpr heven
  exact ⟨projected_injective H z f hf ha,projected_even H z hd h4 f hf ha he⟩

#print axioms projected_injective
#print axioms projected_elementary
#print axioms projected_even
#print axioms zero_syndrome_projects
end PaschLiftProjection
