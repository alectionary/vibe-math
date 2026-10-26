import LocalMantel
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix

/-- The five-vertex equality case follows from the full equality statement of
Turán's theorem. The graph on the right has parts {0,2,4} and {1,3}. -/
theorem five_vertices_six_edges {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) [DecidableRel G.Adj] (htri : G.CliqueFree 3)
    (hV : Fintype.card V=5) (hE : G.edgeFinset.card=6) :
    Nonempty (G ≃g SimpleGraph.turanGraph 5 2) := by
  classical
  have hmax : G.IsTuranMaximal 2 := by
    refine ⟨htri,?_⟩
    intro H _ hH
    have h := triangle_free_edge_bound H hH
    rw [hV] at h
    norm_num at h
    omega
  rw [← hV]
  exact hmax.nonempty_iso_turanGraph

variable {L : ℕ} [NeZero L]

theorem exceptional_group_is_k23 (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (j : Fin 4) (hU : leftCount u j=5) (hV : ∀ i,rightCount v i=1) :
    Nonempty (normalGraph (ZEdge e) (leftSupport u j) ≃g SimpleGraph.turanGraph 5 2) := by
  classical
  have hS := leftSupport_subset u v j
  have htri : (normalGraph (ZEdge e) (leftSupport u j)).CliqueFree 3 :=
    SimpleGraph.CliqueFree.comap (normal_subset_embedding (ZEdge e) hS).isContained
      (source_normal_clique_free e h4 h6 (GeneralLP.join u v) hk hw)
  have hlo : 6≤(normalGraph (ZEdge e) (leftSupport u j)).edgeFinset.card := by
    calc
      6 = ∑ i : Fin 3,(leftCount u j-rightCount v i)/2 := by simp [hU,hV]
      _ ≤ ∑ i : Fin 3,(Finset.univ.filter (fun t : ZMod L =>
          ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card=2)).card :=
        Finset.sum_le_sum (fun i _ => source_left_pair_lower_bound e h4 h6 u v hk hw j i)
      _ ≤ (doubleChecks (ZEdge e) (leftSupport u j)).card := left_bucket_pairs_le_all e _ j
      _ ≤ (normalGraph (ZEdge e) (leftSupport u j)).edgeFinset.card :=
        double_checks_le_edges (ZEdge e) (quantum_no_four e h4) _
  have hhi := source_subset_edge_bound e h4 h6 (GeneralLP.join u v) hk hw _ hS
  have hcard : Fintype.card (leftSupport u j)=5 := by simpa only [Fintype.card_coe,leftSupport_card] using hU
  apply five_vertices_six_edges _ htri hcard
  simp only [leftSupport_card,hU] at hhi
  omega

#print axioms exceptional_group_is_k23
end TruncatedDistance
