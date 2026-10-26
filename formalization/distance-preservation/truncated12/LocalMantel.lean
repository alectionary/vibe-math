import BucketSums
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

lemma left_bucket_pairs_le_all (e : Fin 3 → Fin 4 → ZMod L)
    (S : Finset (Qubit L)) (j : Fin 4) :
    (∑ i : Fin 3, (Finset.univ.filter (fun t : ZMod L =>
      (S.filter (fun q => ZEdge e q ((j,i),t))).card=2)).card)≤
      (doubleChecks (ZEdge e) S).card := by
  classical
  calc
    _ ≤ ∑ j' : Fin 4, ∑ i : Fin 3,(Finset.univ.filter (fun t : ZMod L =>
        (S.filter (fun q => ZEdge e q ((j',i),t))).card=2)).card := by
      exact Finset.single_le_sum (f := fun j' : Fin 4 => ∑ i : Fin 3,
        (Finset.univ.filter (fun t : ZMod L =>
          (S.filter (fun q => ZEdge e q ((j',i),t))).card=2)).card)
        (fun _ _ => Nat.zero_le _) (Finset.mem_univ j)
    _ = _ := by simp only [doubleChecks,Finset.card_filter,Fintype.sum_prod_type]

lemma right_bucket_pairs_le_all (e : Fin 3 → Fin 4 → ZMod L)
    (S : Finset (Qubit L)) (i : Fin 3) :
    (∑ j : Fin 4, (Finset.univ.filter (fun t : ZMod L =>
      (S.filter (fun q => ZEdge e q ((j,i),t))).card=2)).card)≤
      (doubleChecks (ZEdge e) S).card := by
  classical
  calc
    _ ≤ ∑ i' : Fin 3, ∑ j : Fin 4,(Finset.univ.filter (fun t : ZMod L =>
        (S.filter (fun q => ZEdge e q ((j,i'),t))).card=2)).card := by
      exact Finset.single_le_sum (f := fun i' : Fin 3 => ∑ j : Fin 4,
        (Finset.univ.filter (fun t : ZMod L =>
          (S.filter (fun q => ZEdge e q ((j,i'),t))).card=2)).card)
        (fun _ _ => Nat.zero_le _) (Finset.mem_univ i)
    _ = _ := by
      rw [Finset.sum_comm]
      simp only [doubleChecks,Finset.card_filter,Fintype.sum_prod_type]

theorem source_left_local_mantel (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11) (j : Fin 4) :
    (∑ i : Fin 3, (leftCount u j-rightCount v i)/2)≤(leftCount u j)^2/4 := by
  classical
  calc
    _ ≤ ∑ i : Fin 3, (Finset.univ.filter (fun t : ZMod L =>
        ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card=2)).card :=
      Finset.sum_le_sum (fun i _ => source_left_pair_lower_bound e h4 h6 u v hk hw j i)
    _ ≤ (doubleChecks (ZEdge e) (leftSupport u j)).card :=
      left_bucket_pairs_le_all e _ j
    _ ≤ (normalGraph (ZEdge e) (leftSupport u j)).edgeFinset.card :=
      double_checks_le_edges (ZEdge e) (quantum_no_four e h4) _
    _ ≤ (leftSupport u j).card^2/4 :=
      source_subset_edge_bound e h4 h6 (GeneralLP.join u v) hk hw _ (leftSupport_subset u v j)
    _ = _ := by rw [leftSupport_card]

theorem source_right_local_mantel (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11) (i : Fin 3) :
    (∑ j : Fin 4, (rightCount v i-leftCount u j)/2)≤(rightCount v i)^2/4 := by
  classical
  calc
    _ ≤ ∑ j : Fin 4, (Finset.univ.filter (fun t : ZMod L =>
        ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card=2)).card :=
      Finset.sum_le_sum (fun j _ => source_right_pair_lower_bound e h4 h6 u v hk hw j i)
    _ ≤ (doubleChecks (ZEdge e) (rightSupport v i)).card :=
      right_bucket_pairs_le_all e _ i
    _ ≤ (normalGraph (ZEdge e) (rightSupport v i)).edgeFinset.card :=
      double_checks_le_edges (ZEdge e) (quantum_no_four e h4) _
    _ ≤ (rightSupport v i).card^2/4 :=
      source_subset_edge_bound e h4 h6 (GeneralLP.join u v) hk hw _ (rightSupport_subset u v i)
    _ = _ := by rw [rightSupport_card]

#print axioms source_left_local_mantel
#print axioms source_right_local_mantel
end TruncatedDistance
