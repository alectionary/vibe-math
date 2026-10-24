import PaschLiftProjection
import PaschCyclicCount

set_option maxHeartbeats 0
namespace VoltageQCIncidence
open PairFormula PaschRootEnergy PaschGlobalCount PaschCyclicCount
variable {U C E G : Type*} [DecidableEq U] [DecidableEq C] [DecidableEq E]
  [DecidableEq G] [Fintype U] [Fintype C] [Fintype E] [Fintype G] [AddCommGroup G]

def columns (H : U → Finset C) (z : U → C → G) (B : E → Finset G) :
    Sum (U × G) (C × E) → Finset (C × G)
  | .inl v => PaschLiftProjection.columns H z v
  | .inr r => {r.1} ×ˢ B r.2

theorem left_right (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (v : U) (t : G) (c : C) (a : E) :
    (columns H z B (.inl (v,t)) ∩ columns H z B (.inr (c,a))).Nonempty ↔
      c∈H v ∧ t+z v c∈B a := by
  constructor
  · rintro ⟨⟨d,s⟩,h⟩
    obtain ⟨hl,hr⟩ := Finset.mem_inter.mp h
    have hl' := (PaschLiftProjection.mem_columns H z (v,t) d s).mp hl
    have hr' : d=c ∧ s∈B a := by simpa only [columns,Finset.mem_product,Finset.mem_singleton,Prod.fst,Prod.snd] using hr
    have hdc := hr'.1
    subst d
    exact ⟨hl'.1,hl'.2 ▸ hr'.2⟩
  · rintro ⟨hc,ht⟩
    refine ⟨(c,t+z v c),Finset.mem_inter.mpr ⟨?_,?_⟩⟩
    · exact (PaschLiftProjection.mem_columns H z (v,t) c _).mpr ⟨hc,rfl⟩
    · simp [columns,ht]

theorem right_right (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (c d : C) (a b : E) :
    (columns H z B (.inr (c,a)) ∩ columns H z B (.inr (d,b))).Nonempty ↔
      c=d ∧ (B a ∩ B b).Nonempty := by
  constructor
  · rintro ⟨⟨e,t⟩,h⟩
    have h' : e=c ∧ t∈B a ∧ e=d ∧ t∈B b := by simpa only [columns,Finset.mem_inter,Finset.mem_product,Finset.mem_singleton,Prod.fst,Prod.snd,and_assoc] using h
    exact ⟨h'.1.symm.trans h'.2.2.1,⟨t,Finset.mem_inter.mpr ⟨h'.2.1,h'.2.2.2⟩⟩⟩
  · rintro ⟨rfl,t,ht⟩
    exact ⟨(c,t),by simpa [columns] using ht⟩

/-- Adjacent mixed roots have no proper common neighbor, for arbitrary edge
voltages. Base linearity is essential; labels are not assumed constant. -/
theorem mixed_properCommon_empty (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (v : U) (t : G) (c : C) (a : E)
    (ha : (columns H z B (.inl (v,t)) ∩ columns H z B (.inr (c,a))).Nonempty) :
    properCommon (columns H z B) (.inl (v,t)) (.inr (c,a))=∅ := by
  have central := (left_right H z B v t c a).mp ha
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro w hw
  have h := (Finset.mem_filter.mp hw).2
  cases w with
  | inl w =>
    rcases w with ⟨u,s⟩
    have right : c∈H u ∧ s+z u c∈B a := by
      apply (left_right H z B u s c a).mp
      rw [Finset.inter_comm]
      exact h.2.2.2.1
    obtain ⟨⟨d,b⟩,hl⟩ := h.2.2.1
    obtain ⟨hv,hu⟩ := Finset.mem_inter.mp hl
    have hv' := (PaschLiftProjection.mem_columns H z (v,t) d b).mp hv
    have hu' := (PaschLiftProjection.mem_columns H z (u,s) d b).mp hu
    have huv : v≠u := by
      intro he
      have eqv := PaschLiftProjection.same_type_adjacent H z (v,t) (u,s) he ⟨(d,b),hl⟩
      exact h.1 (congrArg Sum.inl eqv.symm)
    have hdc : d=c := Finset.card_le_one.mp (h4 v u huv) d
      (Finset.mem_inter.mpr ⟨hv'.1,hu'.1⟩) c
      (Finset.mem_inter.mpr ⟨central.1,right.1⟩)
    subst d
    apply h.2.2.2.2
    refine ⟨(c,b),Finset.mem_inter.mpr ⟨Finset.mem_inter.mpr ⟨hv,?_⟩,hu⟩⟩
    simp [columns,hv'.2,central.2]
  | inr w =>
    rcases w with ⟨d,e⟩
    have left := (left_right H z B v t d e).mp h.2.2.1
    have rr := (right_right H z B c d a e).mp h.2.2.2.1
    have hdc := rr.1
    subst d
    apply h.2.2.2.2
    refine ⟨(c,t+z v c),?_⟩
    simp [columns,PaschLiftProjection.mem_columns,central.1,central.2,left.2]

theorem mixed_rootTerm40_zero (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (v : U) (t : G) (c : C) (a : E) :
    rootTerm40 (columns H z B) (.inl (v,t)) (.inr (c,a))=0 := by
  unfold rootTerm40
  split_ifs with h
  · unfold localPaschPairs
    rw [mixed_properCommon_empty H z B h4 v t c a h.2]
    simp [PairEnergy.adjacentPairs]
  · rfl

#print axioms left_right
#print axioms mixed_properCommon_empty
#print axioms mixed_rootTerm40_zero
end VoltageQCIncidence
