import PaschRootClassification
import PairRootBridge

set_option maxHeartbeats 0
open scoped BigOperators
open FourColumnClassification GlobalCounting OrderedRoots PairRootBridge PaschKernelCount
namespace PaschGlobalCount
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]
open PaschRootClassification PaschRootEnergy PairFormula

def RootEmbedding40 (H : V → Finset C) (f : I ↪ V) : Prop :=
  Raw40 (fun i => H (f i))

instance (H : V → Finset C) (f : I ↪ V) : Decidable (RootEmbedding40 H f) :=
  inferInstanceAs (Decidable (Raw40 (fun i => H (f i))))

theorem labelled_raw40_iff (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1)
    (S : FourSupport V) (p : Equiv.Perm I) :
    RootEmbedding40 H (toEmbedding S p) ↔ elementary40Check H S.val := by
  rw [local_elementary40_iff,PaschClassification.elementary40_iff_even _
    (local_degree H hd S) (local_linear H h4 S)]
  unfold RootEmbedding40
  rw [raw40_iff_even]
  · unfold PaschClassification.EvenChecks
    change (∀ c, (support (fun i => localCols H S (p i)) c).card % 2 = 0) ↔ _
    simp only [support_card_perm]
  · intro i; exact hd _
  · intro i j hij
    apply h4
    intro heq
    exact hij ((toEmbedding S p).injective heq)

noncomputable def sigmaRoot40Equiv (H : V → Finset C) :
    (Σ S : FourSupport V, {p : Equiv.Perm I // RootEmbedding40 H (toEmbedding S p)}) ≃
    {f : I ↪ V // RootEmbedding40 H f} :=
  let e : (Σ S : FourSupport V, {p : Equiv.Perm I // RootEmbedding40 H (toEmbedding S p)}) ≃
      {x : Σ S : FourSupport V, Equiv.Perm I // RootEmbedding40 H (toEmbedding x.1 x.2)} :=
    { toFun := fun x => ⟨⟨x.1,x.2.val⟩,x.2.property⟩
      invFun := fun x => ⟨x.val.1,⟨x.val.2,x.property⟩⟩
      left_inv := by rintro ⟨S,p,hp⟩; rfl
      right_inv := by rintro ⟨⟨S,p⟩,hp⟩; rfl }
  e.trans (labelledEquiv.subtypeEquiv (fun _ => Iff.rfl))

theorem support_filter40_card (H : V → Finset C) :
    (Finset.univ.filter (fun S : FourSupport V => elementary40Check H S.val)).card = count40 H := by
  unfold count40
  apply Finset.card_bij (fun S _ => S.val)
  · intro S hS
    exact Finset.mem_filter.mpr ⟨S.property,(Finset.mem_filter.mp hS).2⟩
  · intro S hS T hT heq
    exact Subtype.ext heq
  · intro S hS
    refine ⟨⟨S,(Finset.mem_filter.mp hS).1⟩, ?_, rfl⟩
    exact Finset.mem_filter.mpr ⟨Finset.mem_univ _,(Finset.mem_filter.mp hS).2⟩

/-- All24 orderings of each actual Pasch support are counted. -/
theorem ordered_roots40_eq (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) :
    Fintype.card {f : I ↪ V // RootEmbedding40 H f} = 24 * count40 H := by
  classical
  rw [← Fintype.card_congr (sigmaRoot40Equiv H),Fintype.card_sigma]
  simp_rw [Fintype.card_subtype,labelled_raw40_iff H hd h4]
  have h24 : Fintype.card (Equiv.Perm I) = 24 := by decide
  have hc : ∀ S : FourSupport V,
      ((Finset.univ : Finset (Equiv.Perm I)).filter (fun _ => elementary40Check H S.val)).card =
      if elementary40Check H S.val then 24 else 0 := by
    intro S
    by_cases hs : elementary40Check H S.val <;> simp [hs,h24]
  simp_rw [hc]
  rw [Finset.sum_ite]
  simp only [Finset.sum_const,Finset.sum_const_zero,add_zero,Nat.nsmul_eq_mul]
  rw [support_filter40_card]
  omega

def QuadGood40 (H : V → Finset C) (q : Quad V) : Prop :=
  [q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup ∧
  (H q.1 ∩ H q.2.1).Nonempty ∧
  q.2.2.1 ∈ properCommon H q.1 q.2.1 ∧
  q.2.2.2 ∈ properCommon H q.1 q.2.1 ∧
  (outsideCols H (H q.1 ∪ H q.2.1) q.2.2.1 ∩
   outsideCols H (H q.1 ∪ H q.2.1) q.2.2.2).Nonempty

instance (H : V → Finset C) (q : Quad V) : Decidable (QuadGood40 H q) :=
  inferInstanceAs (Decidable ([q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup ∧
  (H q.1 ∩ H q.2.1).Nonempty ∧
  q.2.2.1 ∈ properCommon H q.1 q.2.1 ∧ q.2.2.2 ∈ properCommon H q.1 q.2.1 ∧
  (outsideCols H (H q.1 ∪ H q.2.1) q.2.2.1 ∩
   outsideCols H (H q.1 ∪ H q.2.1) q.2.2.2).Nonempty))

theorem quad_embedding40 (H : V → Finset C) (q : Quad V)
    (hn : [q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup) :
    QuadGood40 H q ↔ RootEmbedding40 H (embeddingOfQuad q hn) := by
  rcases q with ⟨u,v,w,z⟩
  have hne : u ≠ v ∧ u ≠ w ∧ u ≠ z ∧ v ≠ w ∧ v ≠ z ∧ w ≠ z := by
    simpa [and_assoc] using hn
  change QuadGood40 H (u,v,w,z) ↔ Raw40 (fun i => H (quadFun (u,v,w,z) i))
  simp [QuadGood40,Raw40,properCommon,quadFun,outsideCols,
    hne.1,hne.2.1,hne.2.2.1,hne.2.2.2.1,hne.2.2.2.2.1,hne.2.2.2.2.2,
    hne.2.1.symm,hne.2.2.2.1.symm,hne.2.2.1.symm,hne.2.2.2.2.1.symm,and_assoc]

noncomputable def quadEmbedding40Equiv (H : V → Finset C) :
    {q : Quad V // QuadGood40 H q} ≃ {f : I ↪ V // RootEmbedding40 H f} where
  toFun q := ⟨embeddingOfQuad q.val q.property.1,
    (quad_embedding40 H q.val q.property.1).mp q.property⟩
  invFun f := ⟨quadOfEmbedding f.val,by
    have hn := quadOfEmbedding_nodup f.val
    apply (quad_embedding40 H _ hn).mpr
    have he : embeddingOfQuad (quadOfEmbedding f.val) hn = f.val := by
      apply Function.Embedding.ext
      intro i
      exact congrFun (quadFun_embedding f.val) i
    rw [he]
    exact f.property⟩
  left_inv := by
    rintro ⟨⟨u,v,w,z⟩,h⟩
    rfl
  right_inv := by
    intro f
    apply Subtype.ext
    apply Function.Embedding.ext
    intro i
    exact congrFun (quadFun_embedding f.val) i

abbrev RootData40 (H : V → Finset C) :=
  Σ p : centralPairs H, ↥(localPaschPairs H p.val.1 p.val.2)

def dataOfQuad40 (H : V → Finset C) (q : {q : Quad V // QuadGood40 H q}) : RootData40 H := by
  rcases q with ⟨⟨u,v,w,z⟩,⟨hnd,h01,hw,hz,hout⟩⟩
  have hn : u ≠ v ∧ u ≠ w ∧ u ≠ z ∧ v ≠ w ∧ v ≠ z ∧ w ≠ z := by
    simpa [and_assoc] using hnd
  have hp : (u,v) ∈ centralPairs H := by
    simp only [centralPairs,Finset.mem_filter,Finset.mem_product,Finset.mem_univ,true_and]
    exact ⟨hn.1,h01⟩
  exact ⟨⟨(u,v),hp⟩,⟨(w,z),Finset.mem_filter.mpr
    ⟨Finset.mem_product.mpr ⟨hw,hz⟩,hn.2.2.2.2.2,hout⟩⟩⟩

def quadOfData40 (H : V → Finset C) (d : RootData40 H) : {q : Quad V // QuadGood40 H q} := by
  rcases d with ⟨⟨⟨u,v⟩,hp⟩,⟨⟨w,z⟩,hl⟩⟩
  have hp' : u ≠ v ∧ (H u ∩ H v).Nonempty := (Finset.mem_filter.mp hp).2
  obtain ⟨hwz,hwz'⟩ := Finset.mem_filter.mp hl
  obtain ⟨hw,hz⟩ := Finset.mem_product.mp hwz
  obtain ⟨hwz,hout⟩ := hwz'
  obtain ⟨hwu,hwv,_,_,_⟩ := (Finset.mem_filter.mp hw).2
  obtain ⟨hzu,hzv,_,_,_⟩ := (Finset.mem_filter.mp hz).2
  refine ⟨(u,v,w,z),?_,hp'.2,hw,hz,hout⟩
  simp [hp'.1,hwu.symm,hzu.symm,hwv.symm,hzv.symm,hwz]

def quadData40Equiv (H : V → Finset C) : {q : Quad V // QuadGood40 H q} ≃ RootData40 H where
  toFun := dataOfQuad40 H
  invFun := quadOfData40 H
  left_inv := by rintro ⟨⟨u,v,w,z⟩,h⟩; rfl
  right_inv := by rintro ⟨⟨⟨u,v⟩,hp⟩,⟨⟨w,z⟩,hl⟩⟩; rfl

def rootSum40 (H : V → Finset C) : ℕ :=
  ∑ p ∈ centralPairs H, (localPaschPairs H p.1 p.2).card

theorem rootSum40_eq (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) :
    rootSum40 H = 24 * count40 H := by
  have hc : Fintype.card (RootData40 H) = rootSum40 H := by
    rw [Fintype.card_sigma]
    simp only [Fintype.card_coe]
    exact Finset.sum_coe_sort (s := centralPairs H)
      (f := fun p : V × V => (localPaschPairs H p.1 p.2).card)
  rw [← hc,← Fintype.card_congr (quadData40Equiv H),
    Fintype.card_congr (quadEmbedding40Equiv H)]
  exact ordered_roots40_eq H hd h4

/-- Full incidence formula, all roots and actual support multiplicity included. -/
theorem count40_energy_identity (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) :
    24 * count40 H +
      (∑ p ∈ centralPairs H, (rootCheckEnergy H (properCommon H p.1 p.2) (H p.1 ∪ H p.2) +
        (properCommon H p.1 p.2).card)) = PairFormula.energySum H := by
  rw [← rootSum40_eq H hd h4]
  unfold rootSum40 PairFormula.energySum
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  rw [local_energy_identity H hd h4]
  omega

#print axioms ordered_roots40_eq
#print axioms rootSum40_eq
#print axioms count40_energy_identity
end PaschGlobalCount
