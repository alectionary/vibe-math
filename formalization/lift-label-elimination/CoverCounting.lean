import UnorderedSections
import PaschLiftCriterion

set_option maxHeartbeats 0
namespace CoverCounting
open GlobalCounting UnorderedSections PaschKernelCount FourColumnClassification
variable {V C G : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G]

theorem subtype_count (H : V → Finset C) :
    count40 H=Nat.card {S : FourSupport V // elementary40Check H S.val} := by
  classical
  let e : {S // S∈(fourSupports : Finset (Finset V)).filter (elementary40Check H)} ≃
      {S : FourSupport V // elementary40Check H S.val} := {
    toFun := fun S => ⟨⟨S.val,(Finset.mem_filter.mp S.prop).1⟩,(Finset.mem_filter.mp S.prop).2⟩
    invFun := fun S => ⟨S.val.val,Finset.mem_filter.mpr ⟨S.val.prop,S.prop⟩⟩
    left_inv := fun _ => rfl
    right_inv := fun _ => rfl }
  rw [← Nat.card_congr e,Nat.card_eq_fintype_card,Fintype.card_coe]
  rfl

theorem support_fst_injective (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1)
    (T : FourSupport (V × G))
    (hT : elementary40Check (PaschLiftProjection.columns H z) T.val) :
    Set.InjOn Prod.fst (↑T.val : Set (V × G)) := by
  let f : Fin 4 → V × G := fun i => (label T i).val
  have hf : Function.Injective f := by
    intro i j hij
    exact (label T).injective (Subtype.ext hij)
  have he : PaschClassification.EvenChecks (fun i => PaschLiftProjection.columns H z (f i)) :=
    ((local_elementary40_iff _ T).mp hT).2
  have hp := (PaschLiftProjection.zero_syndrome_projects H z hd h4 f hf he).1
  intro a ha b hb hab
  let i := (label T).symm ⟨a,ha⟩
  let j := (label T).symm ⟨b,hb⟩
  have hi : f i=a := by simp [f,i]
  have hj : f j=b := by simp [f,j]
  have hij : i=j := hp (by change (f i).1=(f j).1; rw [hi,hj]; exact hab)
  rw [← hi,← hj,hij]

/-- Exact unordered partition for the actual cover; no multiplicity factor is omitted. -/
theorem unordered_partition (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1) :
    count40 (PaschLiftProjection.columns H z)=
      ∑ S : FourSupport V, Nat.card {x : Fin 4 → G //
        elementary40Check (PaschLiftProjection.columns H z) (graph S x)} := by
  rw [subtype_count]
  exact partition_count _ (support_fst_injective H z hd h4)

theorem selected_graph_card (H : V → Finset C) (z : V → C → G)
    (S : FourSupport V) (x : Fin 4 → G) (a : C × G) :
    (GlobalCounting.selected (PaschLiftProjection.columns H z) (graph S x) a).card=
      (support (fun i => PaschLiftProjection.columns H z ((label S i).val,x i)) a).card := by
  symm
  apply Finset.card_bij (fun i _ => ((label S i).val,x i))
  · intro i hi
    exact Finset.mem_filter.mpr ⟨(mem_graph S x _ _).mpr ⟨i,rfl,rfl⟩,
      (mem_support _ _ _).mp hi⟩
  · intro i _ j _ hij
    exact graph_injective S x hij
  · intro a ha
    obtain ⟨i,hi,hxi⟩ := (mem_graph S x a.1 a.2).mp (Finset.mem_filter.mp ha).1
    have he : ((label S i).val,x i)=a := Prod.ext hi hxi
    refine ⟨i,?_,he⟩
    apply (mem_support _ _ _).mpr
    rw [he]
    exact (Finset.mem_filter.mp ha).2

theorem graph_elementary_iff (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1)
    (S : FourSupport V) (x : Fin 4 → G) :
    elementary40Check (PaschLiftProjection.columns H z) (graph S x) ↔
      PaschClassification.EvenChecks
        (fun i => PaschLiftProjection.columns H z ((label S i).val,x i)) := by
  have hd' := fun i => PaschLiftProjection.cubic H z hd ((label S i).val,x i)
  have h4' : ∀ i j : Fin 4, i≠j →
      (PaschLiftProjection.columns H z ((label S i).val,x i) ∩
        PaschLiftProjection.columns H z ((label S j).val,x j)).card≤1 := by
    intro i j hij
    exact PaschLiftProjection.linear H z h4 _ _ (fun h => hij (graph_injective S x h))
  rw [← PaschClassification.elementary40_iff_even _ hd' h4']
  simp only [elementary40Check,PaschClassification.Elementary40,
    PaschClassification.EvenChecks,selected_graph_card]

theorem count_eq_sum_offsets (H : V → Finset C) (z : V → C → G)
    (hd : ∀ v, (H v).card=3)
    (h4 : ∀ v w, v≠w → (H v ∩ H w).card≤1) :
    count40 (PaschLiftProjection.columns H z)=
      ∑ S : FourSupport V, Nat.card {x : Fin 4 → G //
        PaschClassification.EvenChecks
          (fun i => PaschLiftProjection.columns H z ((label S i).val,x i))} := by
  rw [unordered_partition H z hd h4]
  apply Finset.sum_congr rfl
  intro S _
  exact Nat.card_congr (Equiv.subtypeEquivRight (graph_elementary_iff H z hd h4 S))

#print axioms support_fst_injective
#print axioms unordered_partition
#print axioms graph_elementary_iff
#print axioms count_eq_sum_offsets
end CoverCounting
