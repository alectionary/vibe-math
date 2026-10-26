import SourceNormal
set_option maxHeartbeats 0
namespace TruncatedDistance
open TannerSix
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def doubleChecks (E : V → C → Prop) [DecidableRel E] (T : Finset V) : Finset C :=
  Finset.univ.filter (fun c => (T.filter (fun v => E v c)).card=2)

lemma double_check_pair (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (c : doubleChecks E T) :
    ∃ v w : {v // v∈T}, v≠w ∧ E v.1 c.1 ∧ E w.1 c.1 := by
  have hc := (Finset.mem_filter.mp c.2).2
  obtain ⟨v,w,hvw,he⟩ := Finset.card_eq_two.mp hc
  have hv : v∈T ∧ E v c.1 := Finset.mem_filter.mp (show v∈T.filter (fun z => E z c.1) by rw [he];simp)
  have hw : w∈T ∧ E w c.1 := Finset.mem_filter.mp (show w∈T.filter (fun z => E z c.1) by rw [he];simp)
  exact ⟨⟨v,hv.1⟩,⟨w,hw.1⟩,fun h => hvw (congrArg Subtype.val h),hv.2,hw.2⟩

noncomputable def checkPair (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (c : doubleChecks E T) : {v // v∈T} × {v // v∈T} :=
  let v := Classical.choose (double_check_pair E T c)
  (v, Classical.choose (Classical.choose_spec (double_check_pair E T c)))

lemma checkPair_spec (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (c : doubleChecks E T) :
    (checkPair E T c).1≠(checkPair E T c).2 ∧
      E (checkPair E T c).1.1 c.1 ∧ E (checkPair E T c).2.1 c.1 := by
  exact Classical.choose_spec (Classical.choose_spec (double_check_pair E T c))

noncomputable def doubleCheckEdge (E : V → C → Prop) [DecidableRel E] (T : Finset V)
    (c : doubleChecks E T) : (normalGraph E T).edgeFinset := by
  classical
  refine ⟨s((checkPair E T c).1,(checkPair E T c).2),SimpleGraph.mem_edgeFinset.mpr ?_⟩
  change (normalGraph E T).Adj _ _
  exact ⟨(checkPair_spec E T c).1,c.1,(checkPair_spec E T c).2⟩

lemma doubleCheckEdge_injective (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (T : Finset V) : Function.Injective (doubleCheckEdge E T) := by
  classical
  intro c d he
  have hp := congrArg Subtype.val he
  change s((checkPair E T c).1,(checkPair E T c).2) =
    s((checkPair E T d).1,(checkPair E T d).2) at hp
  have hc := checkPair_spec E T c
  have hd := checkPair_spec E T d
  by_contra hn
  have hcd : c.1≠d.1 := fun h => hn (Subtype.ext h)
  have hvw : (checkPair E T c).1.1≠(checkPair E T c).2.1 :=
    fun h => hc.1 (Subtype.ext h)
  rcases Sym2.mk_eq_mk_iff.mp hp with h|h
  · have ha := congrArg (fun q => q.1.1) h
    have hb := congrArg (fun q => q.2.1) h
    exact h4 _ _ c.1 d.1 hvw hcd hc.2.1 hc.2.2
      (by simpa only [hb] using hd.2.2) (by simpa only [ha] using hd.2.1)
  · have ha := congrArg (fun q => q.1.1) h
    have hb := congrArg (fun q => q.2.1) h
    exact h4 _ _ c.1 d.1 hvw hcd hc.2.1 hc.2.2
      (by simpa only [hb,Prod.swap] using hd.2.1) (by simpa only [ha,Prod.swap] using hd.2.2)

theorem double_checks_le_edges (E : V → C → Prop) [DecidableRel E]
    (h4 : NoFour E) (T : Finset V) :
    (doubleChecks E T).card≤(normalGraph E T).edgeFinset.card := by
  classical
  simpa only [Fintype.card_coe] using Fintype.card_le_of_injective (doubleCheckEdge E T)
    (doubleCheckEdge_injective E h4 T)

#print axioms double_checks_le_edges
end TruncatedDistance
