import BucketCounts
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

theorem source_check_unique (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (q r : Qubit L) (hqr : q≠r)
    (c d : SourceModel.ZCheck L)
    (hqc : ZEdge e q c) (hrc : ZEdge e r c)
    (hqd : ZEdge e q d) (hrd : ZEdge e r d) : c=d := by
  by_contra hcd
  exact quantum_no_four e h4 q r c d hqr hcd hqc hrc hrd hqd

theorem source_partner (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11)
    (q : Qubit L) (hq : x q≠0) (c : SourceModel.ZCheck L) (hc : ZEdge e q c) :
    ∃ r,r≠q ∧ x r≠0 ∧ ZEdge e r c := by
  classical
  let S := (CoverWeight.support x).filter (fun r => ZEdge e r c)
  have hmem : q∈S := Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr ⟨Finset.mem_univ _,hq⟩,hc⟩
  have hpos : 0<S.card := Finset.card_pos.mpr ⟨q,hmem⟩
  have htwo : S.card=2 := by
    rcases source_kernel_zero_or_two e h4 h6 x hk hw c with h|h <;> change S.card=_ at h <;> omega
  obtain ⟨a,b,hab,hs⟩ := Finset.card_eq_two.mp htwo
  have hqcase : q=a ∨ q=b := by rw [hs] at hmem;simpa using hmem
  have ha : a∈S := by rw [hs];simp
  have hb : b∈S := by rw [hs];simp
  rcases hqcase with rfl|rfl
  · have hm := Finset.mem_filter.mp hb
    exact ⟨b,hab.symm,(Finset.mem_filter.mp hm.1).2,hm.2⟩
  · have hm := Finset.mem_filter.mp ha
    exact ⟨a,hab,(Finset.mem_filter.mp hm.1).2,hm.2⟩

theorem source_pair_row_colors_distinct (e : Fin 3 → Fin 4 → ZMod L)
    (q : Qubit L) (j k : Fin 4) (s : ZMod L) (hq : q=.inl ((j,k),s))
    (c d : SourceModel.ZCheck L) (hc : ZEdge e q c) (hd : ZEdge e q d)
    (hi : c.1.2=d.1.2) : c=d := by
  subst q
  have hjc := hc.1
  have hjd := hd.1
  apply Prod.ext
  · exact Prod.ext (hjc.trans hjd.symm) hi
  · have h1 := hc.2
    have h2 := hd.2
    change c.2=s+e c.1.2 k at h1
    change d.2=s+e d.1.2 k at h2
    rw [h1,h2,hi]

#print axioms source_check_unique
#print axioms source_partner
end TruncatedDistance
