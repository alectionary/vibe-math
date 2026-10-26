import SourceNormal
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

def embedLeft (j : Fin 4) : (Fin 4 × ZMod L) ↪ Qubit L where
  toFun p := Sum.inl ((j,p.1),p.2)
  inj' := by rintro ⟨k,s⟩ ⟨k',s'⟩ h;simpa using h

def embedRight (i : Fin 3) : (Fin 3 × ZMod L) ↪ Qubit L where
  toFun p := Sum.inr ((p.1,i),p.2)
  inj' := by rintro ⟨l,s⟩ ⟨l',s'⟩ h;simpa using h

def leftSupport (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) : Finset (Qubit L) :=
  (CoverWeight.support (fun p : Fin 4 × ZMod L => u j p.1 p.2)).map (embedLeft j)
def rightSupport (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) : Finset (Qubit L) :=
  (CoverWeight.support (fun p : Fin 3 × ZMod L => v p.1 i p.2)).map (embedRight i)

@[simp] theorem leftSupport_card (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) :
    (leftSupport u j).card=leftCount u j := Finset.card_map _
@[simp] theorem rightSupport_card (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) :
    (rightSupport v i).card=rightCount v i := Finset.card_map _

@[simp] lemma left_mem_leftSupport (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (j j' k : Fin 4) (s : ZMod L) :
    Sum.inl ((j',k),s)∈leftSupport u j ↔ j'=j ∧ u j k s≠0 := by
  rw [leftSupport,Finset.mem_map]
  change (∃ p : Fin 4 × ZMod L, p∈CoverWeight.support (fun p => u j p.1 p.2) ∧
    Sum.inl ((j,p.1),p.2)=Sum.inl ((j',k),s)) ↔ _
  simp only [CoverWeight.support,Finset.mem_filter,Finset.mem_univ,true_and,
    Prod.exists,Sum.inl.injEq,Prod.mk.injEq]
  constructor
  · rintro ⟨a,b,hu,⟨hj,hk⟩,hs⟩
    subst a;subst b;subst j'
    exact ⟨rfl,hu⟩
  · rintro ⟨rfl,hu⟩
    exact ⟨k,s,hu,⟨rfl,rfl⟩,rfl⟩
@[simp] lemma right_mem_leftSupport (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (j : Fin 4) (l i : Fin 3) (s : ZMod L) :
    Sum.inr ((l,i),s)∉leftSupport u j := by
  simp [leftSupport,Finset.mem_map,embedLeft,Function.Embedding.coeFn_mk]
@[simp] lemma right_mem_rightSupport (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (i i' l : Fin 3) (s : ZMod L) :
    Sum.inr ((l,i'),s)∈rightSupport v i ↔ i'=i ∧ v l i s≠0 := by
  rw [rightSupport,Finset.mem_map]
  change (∃ p : Fin 3 × ZMod L, p∈CoverWeight.support (fun p => v p.1 i p.2) ∧
    Sum.inr ((p.1,i),p.2)=Sum.inr ((l,i'),s)) ↔ _
  simp only [CoverWeight.support,Finset.mem_filter,Finset.mem_univ,true_and,
    Prod.exists,Sum.inr.injEq,Prod.mk.injEq]
  constructor
  · rintro ⟨a,b,hv,⟨hl,hi⟩,hs⟩
    subst a;subst b;subst i'
    exact ⟨rfl,hv⟩
  · rintro ⟨rfl,hv⟩
    exact ⟨l,s,hv,⟨rfl,rfl⟩,rfl⟩
@[simp] lemma left_mem_rightSupport (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (i : Fin 3) (j k : Fin 4) (s : ZMod L) :
    Sum.inl ((j,k),s)∉rightSupport v i := by
  simp [rightSupport,Finset.mem_map,embedRight,Function.Embedding.coeFn_mk]

theorem leftSupport_subset (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) :
    leftSupport u j⊆CoverWeight.support (GeneralLP.join u v) := by
  intro q hq
  rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i⟩,s⟩
  · obtain ⟨rfl,hu⟩ := (left_mem_leftSupport u j j' k s).mp hq
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,hu⟩
  · exact False.elim (right_mem_leftSupport u j l i s hq)

theorem rightSupport_subset (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) :
    rightSupport v i⊆CoverWeight.support (GeneralLP.join u v) := by
  intro q hq
  rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i'⟩,s⟩
  · exact False.elim (left_mem_rightSupport v i j k s hq)
  · obtain ⟨rfl,hv⟩ := (right_mem_rightSupport v i i' l s).mp hq
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,hv⟩

@[simp] lemma mem_join_left (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j k : Fin 4) (s : ZMod L) :
    Sum.inl ((j,k),s)∈CoverWeight.support (GeneralLP.join u v) ↔ u j k s≠0 := by
  rw [CoverWeight.support,Finset.mem_filter]
  simp only [Finset.mem_univ,true_and]
  rfl
@[simp] lemma mem_join_right (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (l i : Fin 3) (s : ZMod L) :
    Sum.inr ((l,i),s)∈CoverWeight.support (GeneralLP.join u v) ↔ v l i s≠0 := by
  rw [CoverWeight.support,Finset.mem_filter]
  simp only [Finset.mem_univ,true_and]
  rfl

theorem bucket_support_eq (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    (CoverWeight.support (GeneralLP.join u v)).filter (fun q => ZEdge e q ((j,i),t)) =
      ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))) ∪
      ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))) := by
  ext q
  simp only [Finset.mem_filter,Finset.mem_union]
  rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i'⟩,s⟩ <;>
    simp only [mem_join_left,mem_join_right,ZEdge,CEdge,left_mem_leftSupport,
      right_mem_rightSupport,right_mem_leftSupport,left_mem_rightSupport,
      false_and,or_false,false_or] <;> aesop

theorem left_right_disjoint (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) :
    Disjoint (leftSupport u j) (rightSupport v i) := by
  apply Finset.disjoint_left.mpr
  intro q hl hr
  rcases q with ⟨⟨j',k⟩,s⟩|⟨⟨l,i'⟩,s⟩
  · exact left_mem_rightSupport v i j' k s hr
  · exact right_mem_leftSupport u j l i' s hl

theorem bucket_card_eq (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    ((CoverWeight.support (GeneralLP.join u v)).filter (fun q => ZEdge e q ((j,i),t))).card =
      ((leftSupport u j).filter (fun q => ZEdge e q ((j,i),t))).card+
      ((rightSupport v i).filter (fun q => ZEdge e q ((j,i),t))).card := by
  rw [bucket_support_eq,Finset.card_union_of_disjoint]
  exact Finset.disjoint_filter_filter (left_right_disjoint u v j i)

#print axioms bucket_card_eq
end TruncatedDistance
