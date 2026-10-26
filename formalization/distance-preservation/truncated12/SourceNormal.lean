import NormalGraph
import BlockCounts
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

theorem source_normal_clique_free (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2) (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11) :
    (normalGraph (ZEdge e) (CoverWeight.support x)).CliqueFree 3 := by
  exact normal_clique_free (ZEdge e) (quantum_no_six e h6) _
    (source_kernel_zero_or_two e h4 h6 x hk hw)

noncomputable def normal_subset_embedding {V C : Type*} [DecidableEq V]
    (E : V → C → Prop) {S T : Finset V} (h : S⊆T) :
    normalGraph E S ↪g normalGraph E T where
  toFun v := ⟨v.1,h v.2⟩
  inj' := by
    intro v w he
    exact Subtype.ext (congrArg (fun q : {q // q∈T} => q.1) he)
  map_rel_iff' := by
    intro v w
    change ((⟨v.1,h v.2⟩ : {q // q∈T})≠⟨w.1,h w.2⟩ ∧ ∃ c,E v.1 c ∧ E w.1 c) ↔
      (v≠w ∧ ∃ c,E v.1 c ∧ E w.1 c)
    constructor
    · rintro ⟨hn,c,hv,hw⟩
      refine ⟨?_,c,hv,hw⟩
      intro he
      subst w
      exact hn rfl
    · rintro ⟨hn,c,hv,hw⟩
      refine ⟨?_,c,hv,hw⟩
      intro he
      exact hn (Subtype.ext (congrArg (fun q : {q // q∈T} => q.1) he))

theorem source_subset_edge_bound (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (x : Qubit L → ZMod 2) (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*x q)=0)
    (hw : (CoverWeight.support x).card≤11) (S : Finset (Qubit L))
    (hS : S⊆CoverWeight.support x) :
    (normalGraph (ZEdge e) S).edgeFinset.card≤S.card^2/4 := by
  classical
  have hT := source_normal_clique_free e h4 h6 x hk hw
  have htri : (normalGraph (ZEdge e) S).CliqueFree 3 :=
    SimpleGraph.CliqueFree.comap (normal_subset_embedding (ZEdge e) hS).isContained hT
  simpa using triangle_free_edge_bound (normalGraph (ZEdge e) S) htri

theorem pure_left_source_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u 0 q)=0) (j : Fin 4) :
    ∀ a : Fin 3 × ZMod L, (∑ q,GeneralLP.C e a q*u j q.1 q.2)=0 := by
  intro a
  rw [GeneralLP.classical_action]
  have h := (GeneralLP.z_action e u 0 j a.1 a.2).symm.trans (hk ((j,a.1),a.2))
  simpa [GeneralLP.Syndrome,CyclicCover.boundary] using h

theorem pure_right_transpose_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join 0 v q)=0) (i : Fin 3) :
    ∀ q : Fin 4 × ZMod L, (∑ a,GeneralLP.C e a q*v a.1 i a.2)=0 := by
  intro q
  have h := (GeneralLP.z_action e 0 v q.1 i q.2).symm.trans (hk ((q.1,i),q.2))
  simpa [GeneralLP.Syndrome,GeneralLP.C,GeneralLP.P,SourceModel.P,Fintype.sum_prod_type] using h

#print axioms source_subset_edge_bound
#print axioms pure_left_source_kernel
#print axioms pure_right_transpose_kernel
end TruncatedDistance
