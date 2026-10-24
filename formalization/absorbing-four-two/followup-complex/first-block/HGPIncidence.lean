import PairFormulaCore
import Mathlib.Data.Fintype.Sum
import Mathlib.Data.Fintype.Prod
set_option maxHeartbeats 0
namespace HGPIncidence
open PairFormula
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

/-- The X incidence of an ordinary hypergraph product. H2 is the transpose
factor's column neighborhood map. -/
def columns (H1 : U → Finset C) (H2 : E → Finset D) :
    Sum (U × D) (C × E) → Finset (C × D)
  | .inl (u,a) => (H1 u) ×ˢ {a}
  | .inr (c,b) => {c} ×ˢ (H2 b)

theorem left_left (H1 : U → Finset C) (H2 : E → Finset D) (u v : U) (a b : D) :
    (columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inl (v,b))).Nonempty ↔
      a = b ∧ (H1 u ∩ H1 v).Nonempty := by
  constructor
  · rintro ⟨⟨c,t⟩,hc⟩
    have h : (c ∈ H1 u ∧ t=a) ∧ (c ∈ H1 v ∧ t=b) := by simpa [columns,eq_comm,and_comm,and_left_comm,and_assoc] using hc
    exact ⟨h.1.2.symm.trans h.2.2,⟨c,Finset.mem_inter.mpr ⟨h.1.1,h.2.1⟩⟩⟩
  · rintro ⟨rfl,c,hc⟩
    refine ⟨(c,a),?_⟩
    simpa [columns] using hc

theorem left_right (H1 : U → Finset C) (H2 : E → Finset D) (u : U) (a : D) (c : C) (b : E) :
    (columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inr (c,b))).Nonempty ↔
      c ∈ H1 u ∧ a ∈ H2 b := by
  constructor
  · rintro ⟨⟨d,t⟩,hc⟩
    have h : (d ∈ H1 u ∧ t=a) ∧ (d=c ∧ t ∈ H2 b) := by simpa [columns,eq_comm,and_comm,and_left_comm,and_assoc] using hc
    exact ⟨h.2.1 ▸ h.1.1,h.1.2 ▸ h.2.2⟩
  · intro h
    exact ⟨(c,a),by simpa [columns] using h⟩

theorem right_right (H1 : U → Finset C) (H2 : E → Finset D) (c d : C) (a b : E) :
    (columns H1 H2 (.inr (c,a)) ∩ columns H1 H2 (.inr (d,b))).Nonempty ↔
      c = d ∧ (H2 a ∩ H2 b).Nonempty := by
  constructor
  · rintro ⟨⟨r,t⟩,hc⟩
    have h : (r=c ∧ t ∈ H2 a) ∧ (r=d ∧ t ∈ H2 b) := by simpa [columns,eq_comm,and_comm,and_left_comm,and_assoc] using hc
    exact ⟨h.1.1.symm.trans h.2.1,⟨t,Finset.mem_inter.mpr ⟨h.1.2,h.2.2⟩⟩⟩
  · rintro ⟨rfl,t,ht⟩
    exact ⟨(c,t),by simpa [columns] using ht⟩

/-- A mixed left/right central edge is never in a proper six-cycle. The
statement does not need cubicity or a girth assumption. -/
theorem mixed_properCommon_empty (H1 : U → Finset C) (H2 : E → Finset D)
    (u : U) (a : D) (c : C) (b : E)
    (hc : (columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inr (c,b))).Nonempty) :
    properCommon (columns H1 H2) (.inl (u,a)) (.inr (c,b)) = ∅ := by
  have hcentral := (left_right H1 H2 u a c b).mp hc
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro w hw
  have h := (Finset.mem_filter.mp hw).2
  cases w with
  | inl w =>
    rcases w with ⟨s,t⟩
    have hleft := (left_left H1 H2 u s a t).mp h.2.2.1
    have hright := (left_right H1 H2 s t c b).mp (by
      simpa only [Finset.inter_comm] using h.2.2.2.1)
    apply h.2.2.2.2
    refine ⟨(c,a),?_⟩
    simp [columns,hcentral.1,hcentral.2,hright.1,hright.2,hleft.1]
  | inr w =>
    rcases w with ⟨d,e⟩
    have hleft := (left_right H1 H2 u a d e).mp h.2.2.1
    have hright := (right_right H1 H2 c d b e).mp h.2.2.2.1
    apply h.2.2.2.2
    refine ⟨(c,a),?_⟩
    simp [columns,hcentral.1,hcentral.2,hleft.1,hleft.2,hright.1]

#print axioms mixed_properCommon_empty
end HGPIncidence
