import K23MissingRows
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

theorem k23_leaf_mod (b : Fin 3) : (k23Leaf b).val%2=0 := by
  fin_cases b <;> decide +kernel

theorem k23_odd_is_center : ∀ x : Fin 5,x.val%2=1 → ∃ a : Fin 2,x=k23Center a := by decide +kernel

theorem missingRow_not_internal {e : Fin 3 → Fin 4 → ZMod L}
    {u : Fin 4 → Fin 4 → ZMod L → ZMod 2} {n : K23Numbering e u}
    (c : K23InternalChecks e u n) (a : Fin 2) (i : Fin 3) :
    (c.check a (leafByRow c i)).1.2≠i := by
  fin_cases a
  · exact (leafByRow_colors c i).1
  · exact (leafByRow_colors c i).2

/-- At its missing row, each actual K2,3 leaf is paired with the actual right
singleton. An internal partner would reuse a forbidden row color. -/
theorem actual_leaf_cross_matches (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (n : K23Numbering e u) (c : K23InternalChecks e u n)
    (ell : Fin 3 → Fin 3) (t : Fin 3 → ZMod L)
    (hv : ∀ i l' t',v l' i t'=if l'=ell i ∧ t'=t i then 1 else 0)
    (i : Fin 3) :
    n.S (k23Leaf (leafByRow c i))+e i (n.K (k23Leaf (leafByRow c i)))=t i-e (ell i) 3 := by
  classical
  let b := leafByRow c i
  let z := n.S (k23Leaf b)+e i (n.K (k23Leaf b))
  let a : SourceModel.ZCheck L := ((3,i),z)
  have hqa : ZEdge e (numberedQubit n (k23Leaf b)) a := ⟨rfl,rfl⟩
  obtain ⟨q,hneq,hn,hq⟩ := source_partner e h4 h6 (GeneralLP.join u v) hk hw
    (numberedQubit n (k23Leaf b)) (n.nonzero _) a hqa
  rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i'⟩,s⟩
  · have hj : j=3 := hq.1.symm
    subst j
    have hnu : u 3 k s≠0 := hn
    obtain ⟨x,hK,hS⟩ := n.covers k s hnu
    have hpoint : numberedQubit n x=Sum.inl ((3,k),s) := by simp [numberedQubit,hK,hS]
    have hxi : k23Leaf b≠x := by
      intro he
      apply hneq
      rw [← hpoint,he]
    have hpar : (k23Leaf b).val%2≠x.val%2 := (n.adjacency _ _).mp
      ⟨hxi,a,hqa,by simpa only [hK,hS] using hq⟩
    rw [k23_leaf_mod] at hpar
    have hodd : x.val%2=1 := by omega
    obtain ⟨aa,hx⟩ := k23_odd_is_center x hodd
    subst x
    have hpoint' : Sum.inl ((3,k),s)=numberedQubit n (k23Center aa) := hpoint.symm
    have hecheck := source_check_unique e h4 (numberedQubit n (k23Leaf b))
      (numberedQubit n (k23Center aa))
      (fun he => k23_center_ne_leaf aa b ((numberedQubit_injective n he).symm))
      a (c.check aa b) hqa (by simpa only [hpoint'] using hq)
      (c.leaf_edge aa b) (c.center_edge aa b)
    have hi : i=(c.check aa b).1.2 := congrArg (fun d : SourceModel.ZCheck L => d.1.2) hecheck
    exact False.elim (missingRow_not_internal c aa i hi.symm)
  · have hi : i'=i := hq.1.symm
    subst i'
    have hns : v l i s≠0 := hn
    have he : l=ell i ∧ s=t i := by
      by_contra hh
      rw [hv,if_neg hh] at hns
      exact hns rfl
    rcases he with ⟨rfl,rfl⟩
    change z=t i-e (ell i) 3
    exact eq_sub_iff_add_eq.mpr hq.2.symm

#print axioms actual_leaf_cross_matches
end TruncatedDistance
