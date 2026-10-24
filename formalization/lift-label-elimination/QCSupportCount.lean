import SumCounting
import QCRegularity
import QCSectorElimination
import PaschHGPCount

set_option maxHeartbeats 0
namespace QCSupportCount
open GlobalCounting PaschKernelCount VoltageQCIncidence
variable {U C E G : Type*} [DecidableEq U] [DecidableEq C] [DecidableEq E]
  [DecidableEq G] [Fintype U] [Fintype C] [Fintype E] [Fintype G] [AddCommGroup G]

lemma empty_count {A D : Type*} [Fintype A] [Fintype D] [DecidableEq A] [DecidableEq D]
    [IsEmpty A] (H : A → Finset D) : count40 H=0 := by
  have hu : (Finset.univ : Finset A)=∅ :=
    Finset.eq_empty_iff_forall_notMem.mpr (fun a _ => isEmptyElim a)
  have hf : (fourSupports : Finset (Finset A))=∅ := by
    unfold fourSupports
    apply Finset.powersetCard_eq_empty.mpr
    rw [hu,Finset.card_empty]; decide
  unfold count40
  rw [hf]
  rfl

/-- Independent check-type fibers contribute one scalar support count each. -/
theorem right_fiber_count (B : E → Finset G)
    (hd : ∀ a, (B a).card=3)
    (hl : ∀ a b, a≠b → (B a ∩ B b).card≤1) :
    count40 (fun r : C × E => {r.1} ×ˢ B r.2)=Fintype.card C*count40 B := by
  let H0 : Empty → Finset C := fun v => isEmptyElim v
  let F := HGPIncidence.columns H0 B
  have hs : ∀ T : FourSupport (Sum (Empty × G) (C × E)), elementary40Check F T.val →
      T.val.toRight=∅ ∨ T.val.toLeft=∅ := by
    intro T _
    right
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro a _
    exact isEmptyElim a.1
  have hp := PaschHGPCount.count40_product H0 B
    (fun v => isEmptyElim v) hd (fun v => isEmptyElim v) hl
  have hg := SumCounting.count_partition F hs
  rw [empty_count (fun u : Empty × G => F (.inl u))] at hg
  simp only [zero_add] at hg
  rw [empty_count H0,mul_zero,zero_add] at hp
  exact hg.symm.trans hp

theorem sector_property (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (hdH : ∀ u, (H u).card=3) (hdB : ∀ e, (B e).card=3)
    (hlH : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (hlB : ∀ a b, a≠b → (B a ∩ B b).card≤1)
    (T : FourSupport (Sum (U × G) (C × E)))
    (hT : elementary40Check (columns H z B) T.val) :
    T.val.toRight=∅ ∨ T.val.toLeft=∅ := by
  let f : Fin 4 → Sum (U × G) (C × E) := fun i => (label T i).val
  have hf : Function.Injective f := by
    intro i j hij
    exact (label T).injective (Subtype.ext hij)
  have hd := fun i => QCRegularity.cubic H z B hdH hdB (f i)
  have hl : ∀ i j, i≠j → (columns H z B (f i) ∩ columns H z B (f j)).card≤1 :=
    fun i j hij => QCRegularity.linear H z B hlH hlB _ _ (fun h => hij (hf h))
  have he : PaschClassification.EvenChecks (fun i => columns H z B (f i)) :=
    ((local_elementary40_iff _ T).mp hT).2
  rcases QCSectorElimination.same_sector H z B hlH f hf hd hl he with hs | hs
  · left
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro r hr
    have hm : Sum.inr r∈T.val := Finset.mem_toRight.mp hr
    let i := (label T).symm ⟨Sum.inr r,hm⟩
    have hi : f i=Sum.inr r := by simp [f,i]
    obtain ⟨v,hv⟩ := hs i
    rw [hi] at hv
    cases hv
  · right
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro v hv
    have hm : Sum.inl v∈T.val := Finset.mem_toLeft.mp hv
    let i := (label T).symm ⟨Sum.inl v,hm⟩
    have hi : f i=Sum.inl v := by simp [f,i]
    obtain ⟨r,hr⟩ := hs i
    rw [hi] at hr
    cases hr

/-- Full arbitrary-voltage scalar-right count, with unordered support convention. -/
theorem count40_full (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (hdH : ∀ u, (H u).card=3) (hdB : ∀ e, (B e).card=3)
    (hlH : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (hlB : ∀ a b, a≠b → (B a ∩ B b).card≤1) :
    count40 (columns H z B)=count40 (PaschLiftProjection.columns H z)+
      Fintype.card C*count40 B := by
  have h := SumCounting.count_partition (columns H z B) (sector_property H z B hdH hdB hlH hlB)
  change count40 (columns H z B)=count40 (PaschLiftProjection.columns H z)+
    count40 (fun r : C × E => {r.1} ×ˢ B r.2) at h
  rwa [right_fiber_count B hdB hlB] at h

#print axioms right_fiber_count
#print axioms sector_property
#print axioms count40_full
end QCSupportCount
