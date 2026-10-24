import OrderedRoots
import PairFormulaCore

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators
open FourColumnClassification GlobalCounting OrderedRoots PairFormula

namespace PairRootBridge

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

abbrev Quad (V : Type*) := V × V × V × V

def quadFun (q : Quad V) (i : I) : V :=
  match i.val with
  | 0 => q.1
  | 1 => q.2.1
  | 2 => q.2.2.1
  | _ => q.2.2.2

def QuadGood (H : V → Finset C) (q : Quad V) : Prop :=
  [q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup ∧ RawRoot (fun i => H (quadFun q i)) (Equiv.refl I)

instance (H : V → Finset C) (q : Quad V) : Decidable (QuadGood H q) :=
  inferInstanceAs (Decidable ([q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup ∧
    RawRoot (fun i => H (quadFun q i)) (Equiv.refl I)))

theorem quadGood_fields (H : V → Finset C) (u v w z : V) :
    QuadGood H (u,v,w,z) ↔
    [u,v,w,z].Nodup ∧ (H u ∩ H v).Nonempty ∧
      (H u ∩ H w).Nonempty ∧ (H v ∩ H w).Nonempty ∧
      (H u ∩ H z).Nonempty ∧ (H v ∩ H z).Nonempty ∧
      ¬ (H w ∩ H z).Nonempty ∧ ¬ (H u ∩ H v ∩ H w).Nonempty ∧
      ¬ (H u ∩ H v ∩ H z).Nonempty := Iff.rfl

def embeddingOfQuad (q : Quad V) (h : [q.1,q.2.1,q.2.2.1,q.2.2.2].Nodup) : I ↪ V where
  toFun := quadFun q
  inj' := by
    have hn : q.1 ≠ q.2.1 ∧ q.1 ≠ q.2.2.1 ∧ q.1 ≠ q.2.2.2 ∧
      q.2.1 ≠ q.2.2.1 ∧ q.2.1 ≠ q.2.2.2 ∧ q.2.2.1 ≠ q.2.2.2 := by
      simpa [and_assoc] using h
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all [quadFun]

def quadOfEmbedding (f : I ↪ V) : Quad V := (f 0,f 1,f 2,f 3)

theorem quadFun_embedding (f : I ↪ V) : quadFun (quadOfEmbedding f) = f := by
  funext i
  fin_cases i <;> rfl

theorem quadOfEmbedding_nodup (f : I ↪ V) : [f 0,f 1,f 2,f 3].Nodup := by
  have h : [(0 : I),1,2,3].Nodup := by decide
  simpa only [List.map_cons,List.map_nil] using h.map f.injective

def quadEmbeddingEquiv (H : V → Finset C) :
    {q : Quad V // QuadGood H q} ≃ {f : I ↪ V // RootEmbedding H f} where
  toFun q := ⟨embeddingOfQuad q.val q.property.1,q.property.2⟩
  invFun f := ⟨quadOfEmbedding f.val,by
    refine ⟨quadOfEmbedding_nodup f.val,?_⟩
    rw [quadFun_embedding]
    exact f.property⟩
  left_inv := by
    rintro ⟨⟨u,v,w,z⟩,h⟩
    rfl
  right_inv := by
    intro f
    apply Subtype.ext
    apply Function.Embedding.ext
    intro i
    fin_cases i <;> rfl

abbrev RootData (H : V → Finset C) :=
  Σ p : centralPairs H,
    ↥(PairEnergy.missingPairs H (properCommon H p.val.1 p.val.2))

def dataOfQuad (H : V → Finset C) (q : {q : Quad V // QuadGood H q}) : RootData H := by
  rcases q with ⟨⟨u,v,w,z⟩,hq⟩
  obtain ⟨hnd,h01,h02,h12,h03,h13,h23,ht2,ht3⟩ := (quadGood_fields H u v w z).mp hq
  have hn : u ≠ v ∧ u ≠ w ∧ u ≠ z ∧ v ≠ w ∧ v ≠ z ∧ w ≠ z := by
    simpa [and_assoc] using hnd
  have hp : (u,v) ∈ centralPairs H := by
    simp only [centralPairs,Finset.mem_filter,Finset.mem_product,Finset.mem_univ,true_and]
    exact ⟨hn.1,h01⟩
  have hw : w ∈ properCommon H u v := by
    simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and]
    exact ⟨hn.2.1.symm,hn.2.2.2.1.symm,h02,h12,ht2⟩
  have hz : z ∈ properCommon H u v := by
    simp only [properCommon,Finset.mem_filter,Finset.mem_univ,true_and]
    exact ⟨hn.2.2.1.symm,hn.2.2.2.2.1.symm,h03,h13,ht3⟩
  refine ⟨⟨(u,v),hp⟩,⟨(w,z),?_⟩⟩
  exact Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨hw,hz⟩,hn.2.2.2.2.2,h23⟩

def quadOfData (H : V → Finset C) (d : RootData H) : {q : Quad V // QuadGood H q} := by
  rcases d with ⟨⟨⟨u,v⟩,hp⟩,⟨⟨w,z⟩,hl⟩⟩
  have hp' : u ≠ v ∧ (H u ∩ H v).Nonempty := (Finset.mem_filter.mp hp).2
  obtain ⟨hwz,hwz'⟩ := Finset.mem_filter.mp hl
  obtain ⟨hw,hz⟩ := Finset.mem_product.mp hwz
  obtain ⟨hwz,h23⟩ := hwz'
  obtain ⟨hwu,hwv,h02,h12,ht2⟩ := (Finset.mem_filter.mp hw).2
  obtain ⟨hzu,hzv,h03,h13,ht3⟩ := (Finset.mem_filter.mp hz).2
  refine ⟨(u,v,w,z),?_⟩
  apply (quadGood_fields H u v w z).mpr
  refine ⟨?_,hp'.2,h02,h12,h03,h13,h23,ht2,ht3⟩
  simp [hp'.1,hwu.symm,hzu.symm,hwv.symm,hzv.symm,hwz]

def quadDataEquiv (H : V → Finset C) : {q : Quad V // QuadGood H q} ≃ RootData H where
  toFun := dataOfQuad H
  invFun := quadOfData H
  left_inv := by
    rintro ⟨⟨u,v,w,z⟩,h⟩
    rfl
  right_inv := by
    rintro ⟨⟨⟨u,v⟩,hp⟩,⟨⟨w,z⟩,hl⟩⟩
    rfl

theorem card_RootData (H : V → Finset C) : Fintype.card (RootData H) = rootPairSum H := by
  rw [Fintype.card_sigma]
  simp only [Fintype.card_coe]
  unfold rootPairSum
  exact Finset.sum_coe_sort (s := centralPairs H)
    (f := fun p : V × V => (PairEnergy.missingPairs H (properCommon H p.1 p.2)).card)

/-- The full ordered-root enumeration counts every actual elementary (4,2)
support exactly four times. -/
theorem rootPairSum_eq_four_count42 (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → (H v ∩ H w).card ≤ 1) :
    rootPairSum H = 4 * GlobalCounting.count42 H := by
  rw [← card_RootData]
  rw [← Fintype.card_congr (quadDataEquiv H)]
  rw [Fintype.card_congr (quadEmbeddingEquiv H)]
  exact ordered_roots_eq_four_count42 H hd h4

theorem corrected_count_identity (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → (H v ∩ H w).card ≤ 1) :
    4 * GlobalCounting.count42 H + energySum H = quadraticSum H := by
  rw [← rootPairSum_eq_four_count42 H hd h4]
  exact rootPairSum_add_energySum H hd h4

theorem count42_eq_rootPairSum_div_four (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → (H v ∩ H w).card ≤ 1) :
    GlobalCounting.count42 H = rootPairSum H / 4 := by
  rw [rootPairSum_eq_four_count42 H hd h4]
  omega

theorem count42_eq_corrected_energy (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → (H v ∩ H w).card ≤ 1) :
    GlobalCounting.count42 H = (quadraticSum H - energySum H) / 4 := by
  have h := corrected_count_identity H hd h4
  omega

#print axioms count42_eq_corrected_energy
#print axioms rootPairSum_eq_four_count42
#print axioms corrected_count_identity

end PairRootBridge
