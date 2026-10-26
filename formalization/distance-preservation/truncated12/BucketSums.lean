import BucketCounts
import SocketArithmetic
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords TannerSix
variable {L : ℕ} [NeZero L]

def leftFiber (e : Fin 3 → Fin 4 → ZMod L) (i : Fin 3) : Qubit L → ZMod L
  | .inl ((_,k),s) => s+e i k
  | .inr _ => 0

def rightFiber (e : Fin 3 → Fin 4 → ZMod L) (j : Fin 4) : Qubit L → ZMod L
  | .inl _ => 0
  | .inr ((l,_),s) => s-e l j

theorem left_bucket_sum (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) :
    (∑ t : ZMod L, ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card)=
      leftCount u j := by
  classical
  have he (t : ZMod L) : (leftSupport u j).filter (fun q => ZEdge e q ((j,i),t)) =
      (leftSupport u j).filter (fun q => leftFiber e i q=t) := by
    ext q
    simp only [Finset.mem_filter]
    rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i'⟩,s⟩
    · simp only [left_mem_leftSupport,ZEdge,CEdge,leftFiber]
      constructor
      · rintro ⟨⟨rfl,hu⟩,⟨_,ht⟩⟩;exact ⟨⟨rfl,hu⟩,ht.symm⟩
      · rintro ⟨⟨rfl,hu⟩,ht⟩;exact ⟨⟨rfl,hu⟩,rfl,ht.symm⟩
    · simp
  simp_rw [he]
  have h := Finset.sum_card_fiberwise_eq_card_filter (leftSupport u j)
    (Finset.univ : Finset (ZMod L)) (leftFiber e i)
  simpa using h

theorem right_bucket_sum (e : Fin 3 → Fin 4 → ZMod L)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) :
    (∑ t : ZMod L, ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card)=
      rightCount v i := by
  classical
  have he (t : ZMod L) : (rightSupport v i).filter (fun q => ZEdge e q ((j,i),t)) =
      (rightSupport v i).filter (fun q => rightFiber e j q=t) := by
    ext q
    simp only [Finset.mem_filter]
    rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i'⟩,s⟩
    · simp
    · simp only [right_mem_rightSupport,ZEdge,CEdge,rightFiber]
      constructor
      · rintro ⟨⟨rfl,hv⟩,⟨_,ht⟩⟩
        exact ⟨⟨rfl,hv⟩,sub_eq_iff_eq_add.mpr ht⟩
      · rintro ⟨⟨rfl,hv⟩,ht⟩
        exact ⟨⟨rfl,hv⟩,rfl,sub_eq_iff_eq_add.mp ht⟩
  simp_rw [he]
  have h := Finset.sum_card_fiberwise_eq_card_filter (rightSupport v i)
    (Finset.univ : Finset (ZMod L)) (rightFiber e j)
  simpa using h

/-- A complete source check contributes two U sockets, two V sockets, or one
of each. This derives a local pair lower bound from the actual kernel word. -/
theorem source_left_pair_lower_bound (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (j : Fin 4) (i : Fin 3) :
    (leftCount u j-rightCount v i)/2 ≤
      (Finset.univ.filter (fun t : ZMod L =>
        ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card=2)).card := by
  classical
  let a := fun t : ZMod L => ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card
  let b := fun t : ZMod L => ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card
  have hz (t : ZMod L) : a t+b t=0 ∨ a t+b t=2 := by
    have h := source_kernel_zero_or_two e h4 h6 (GeneralLP.join u v) hk hw ((j,i),t)
    simpa only [bucket_card_eq] using h
  have h := socket_pair_lower_bound a b hz
  simpa only [a,b,left_bucket_sum,right_bucket_sum] using h


theorem source_right_pair_lower_bound (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card≤11)
    (j : Fin 4) (i : Fin 3) :
    (rightCount v i-leftCount u j)/2 ≤
      (Finset.univ.filter (fun t : ZMod L =>
        ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card=2)).card := by
  classical
  let a := fun t : ZMod L => ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card
  let b := fun t : ZMod L => ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card
  have hz (t : ZMod L) : b t+a t=0 ∨ b t+a t=2 := by
    have h := source_kernel_zero_or_two e h4 h6 (GeneralLP.join u v) hk hw ((j,i),t)
    simpa only [bucket_card_eq,Nat.add_comm] using h
  have h := socket_pair_lower_bound b a hz
  simpa only [a,b,left_bucket_sum,right_bucket_sum] using h

#print axioms source_left_pair_lower_bound
end TruncatedDistance
