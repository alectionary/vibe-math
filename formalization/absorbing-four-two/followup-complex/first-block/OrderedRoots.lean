import GlobalCounting

set_option maxHeartbeats 0
set_option maxRecDepth 100000
open scoped BigOperators
open FourColumnClassification GlobalCounting

namespace OrderedRoots

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def embeddingSupport (f : I ↪ V) : Finset V := Finset.univ.image f

theorem embeddingSupport_card (f : I ↪ V) : (embeddingSupport f).card = 4 := by
  simp [embeddingSupport,Finset.card_image_of_injective _ f.injective]

def supportOf (f : I ↪ V) : FourSupport V :=
  ⟨embeddingSupport f, Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,embeddingSupport_card f⟩⟩

noncomputable def toEmbedding (S : FourSupport V) (p : Equiv.Perm I) : I ↪ V where
  toFun i := (label S (p i)).val
  inj' := by
    intro i j h
    apply p.injective
    apply (label S).injective
    exact Subtype.ext h

theorem support_toEmbedding (S : FourSupport V) (p : Equiv.Perm I) :
    supportOf (toEmbedding S p) = S := by
  apply Subtype.ext
  apply Finset.eq_of_subset_of_card_le
  · intro v hv
    obtain ⟨i,hi,rfl⟩ := Finset.mem_image.mp hv
    exact (label S (p i)).property
  · change S.val.card ≤ (embeddingSupport (toEmbedding S p)).card
    rw [support_card,embeddingSupport_card]

theorem mem_embeddingSupport (f : I ↪ V) (i : I) : f i ∈ embeddingSupport f :=
  Finset.mem_image.mpr ⟨i,Finset.mem_univ _,rfl⟩

noncomputable def fromEmbeddingPerm (f : I ↪ V) : Equiv.Perm I :=
  Equiv.ofBijective
    (fun i => (label (supportOf f)).symm ⟨f i,mem_embeddingSupport f i⟩)
    (by
      have hi : Function.Injective
          (fun i => (label (supportOf f)).symm ⟨f i,mem_embeddingSupport f i⟩) := by
        intro i j hij
        have hs := (label (supportOf f)).symm.injective hij
        exact f.injective (congrArg Subtype.val hs)
      exact ⟨hi,Finite.injective_iff_surjective.mp hi⟩)

theorem to_from_embedding (f : I ↪ V) :
    toEmbedding (supportOf f) (fromEmbeddingPerm f) = f := by
  ext i
  change ((label (supportOf f)) ((label (supportOf f)).symm
    ⟨f i,mem_embeddingSupport f i⟩)).val = f i
  simp

theorem labelled_bijective : Function.Bijective
    (fun x : Σ S : FourSupport V, Equiv.Perm I => toEmbedding x.1 x.2) := by
  constructor
  · rintro ⟨S,p⟩ ⟨T,q⟩ h
    have hST : S = T := by
      calc
        S = supportOf (toEmbedding S p) := (support_toEmbedding S p).symm
        _ = supportOf (toEmbedding T q) := congrArg supportOf h
        _ = T := support_toEmbedding T q
    subst T
    have hpq : p = q := by
      apply Equiv.ext
      intro i
      apply (label S).injective
      apply Subtype.ext
      exact congrArg (fun f : I ↪ V => f i) h
    subst q
    rfl
  · intro f
    exact ⟨⟨supportOf f,fromEmbeddingPerm f⟩,to_from_embedding f⟩

noncomputable def labelledEquiv : (Σ S : FourSupport V, Equiv.Perm I) ≃ (I ↪ V) :=
  Equiv.ofBijective (fun x => toEmbedding x.1 x.2) labelled_bijective

def RootEmbedding (H : V → Finset C) (f : I ↪ V) : Prop :=
  RawRoot (fun i => H (f i)) (Equiv.refl I)

instance (H : V → Finset C) (f : I ↪ V) : Decidable (RootEmbedding H f) :=
  inferInstanceAs (Decidable (RawRoot (fun i => H (f i)) (Equiv.refl I)))

theorem labelled_root_iff (H : V → Finset C) (S : FourSupport V) (p : Equiv.Perm I) :
    RawRoot (localCols H S) p ↔ RootEmbedding H (toEmbedding S p) := Iff.rfl

noncomputable def labelledRootEquiv (H : V → Finset C) :
    {x : Σ S : FourSupport V, Equiv.Perm I // RawRoot (localCols H x.1) x.2} ≃
    {f : I ↪ V // RootEmbedding H f} :=
  labelledEquiv.subtypeEquiv (fun x => labelled_root_iff H x.1 x.2)

noncomputable def sigmaRootEquiv (H : V → Finset C) :
    (Σ S : FourSupport V, {p : Equiv.Perm I // RawRoot (localCols H S) p}) ≃
    {x : Σ S : FourSupport V, Equiv.Perm I // RawRoot (localCols H x.1) x.2} where
  toFun x := ⟨⟨x.1,x.2.val⟩,x.2.property⟩
  invFun x := ⟨x.val.1,⟨x.val.2,x.property⟩⟩
  left_inv := by rintro ⟨S,p,hp⟩; rfl
  right_inv := by rintro ⟨⟨S,p⟩,hp⟩; rfl

theorem card_ordered_roots_eq_rootSum (H : V → Finset C) :
    Fintype.card {f : I ↪ V // RootEmbedding H f} = rootSum H := by
  classical
  have he := (sigmaRootEquiv H).trans (labelledRootEquiv H)
  rw [← Fintype.card_congr he,Fintype.card_sigma]
  unfold rootSum
  apply Finset.sum_congr rfl
  intro S hS
  rw [Fintype.card_subtype]
  rfl

theorem ordered_roots_eq_four_count42 (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ v w, v ≠ w → ((H v) ∩ (H w)).card ≤ 1) :
    Fintype.card {f : I ↪ V // RootEmbedding H f} = 4 * count42 H := by
  rw [card_ordered_roots_eq_rootSum]
  exact rootSum_eq_four_count42 H hd h4

#print axioms ordered_roots_eq_four_count42

end OrderedRoots
