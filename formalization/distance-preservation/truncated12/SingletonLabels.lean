import IntegerSoundness
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : ℕ} [NeZero L]
variable {J I : Type*}

theorem repeated_column_labels_force_rows_constant
    (e : Fin 3 → Fin 4 → ZMod L) (h4 : TannerSix.NoFour (CEdge e))
    (a : J → Fin 4) (ha : Function.Injective a) (b : I → Fin 3)
    (k : J → Fin 4) (l : I → Fin 3) (s : J → ZMod L) (t : I → ZMod L)
    (hc : ∀ j i, s j+e (b i) (k j)=t i-e (l i) (a j))
    (j j' : J) (hjj : j≠j') (hkk : k j=k j') : ∀ i i', l i=l i' := by
  intro i i'
  apply column_differences_injective e h4 (a j) (a j') (fun h => hjj (ha h))
  have h1 := hc j i
  have h2 := hc j' i
  have h3 := hc j i'
  have h4' := hc j' i'
  rw [hkk] at h1 h3
  linear_combination h1-h2-h3+h4'

theorem repeated_row_labels_force_columns_constant
    (e : Fin 3 → Fin 4 → ZMod L) (h4 : TannerSix.NoFour (CEdge e))
    (a : J → Fin 4) (b : I → Fin 3) (hb : Function.Injective b)
    (k : J → Fin 4) (l : I → Fin 3) (s : J → ZMod L) (t : I → ZMod L)
    (hc : ∀ j i, s j+e (b i) (k j)=t i-e (l i) (a j))
    (i i' : I) (hii : i≠i') (hll : l i=l i') : ∀ j j', k j=k j' := by
  intro j j'
  apply row_differences_injective e h4 (b i) (b i') (fun h => hii (hb h))
  have h1 := hc j i
  have h2 := hc j i'
  have h3 := hc j' i
  have h4' := hc j' i'
  rw [hll] at h1 h3
  linear_combination h1-h2-h3+h4'

/-- Singleton cross-matching does not permit intermediate label degeneracies:
there is either one constant label on each side or both label maps inject. -/
theorem singleton_labels_constant_or_injective [Nonempty J] [Nontrivial J]
    [Nonempty I] [Nontrivial I]
    (e : Fin 3 → Fin 4 → ZMod L) (h4 : TannerSix.NoFour (CEdge e))
    (a : J → Fin 4) (ha : Function.Injective a)
    (b : I → Fin 3) (hb : Function.Injective b)
    (k : J → Fin 4) (l : I → Fin 3) (s : J → ZMod L) (t : I → ZMod L)
    (hc : ∀ j i, s j+e (b i) (k j)=t i-e (l i) (a j)) :
    (∃ K H, (∀ j,k j=K) ∧ (∀ i,l i=H)) ∨
      (Function.Injective k ∧ Function.Injective l) := by
  classical
  by_cases hk : Function.Injective k
  · right
    refine ⟨hk,?_⟩
    intro i i' he
    by_contra hn
    have hconst := repeated_row_labels_force_columns_constant e h4 a b hb k l s t hc i i' hn he
    obtain ⟨j,j',hjj⟩ := exists_pair_ne J
    exact hjj (hk (hconst j j'))
  · left
    obtain ⟨j,j',hkk,hjj⟩ := Function.not_injective_iff.mp hk
    have hconst := repeated_column_labels_force_rows_constant e h4 a ha b k l s t hc j j' hjj hkk
    obtain ⟨i,i',hii⟩ := exists_pair_ne I
    have hkconst := repeated_row_labels_force_columns_constant e h4 a b hb k l s t hc i i' hii (hconst i i')
    exact ⟨k j,l i,(fun q => hkconst q j),(fun q => hconst q i)⟩

/-- The constant-label fiber equations are exactly the shifted support of one
source stabilizer row; source support equality is a separate finite-set step. -/
theorem constant_label_fibers [Nonempty J] [Nonempty I]
    (e : Fin 3 → Fin 4 → ZMod L) (a : J → Fin 4) (b : I → Fin 3)
    (K : Fin 4) (H : Fin 3) (s : J → ZMod L) (t : I → ZMod L)
    (hc : ∀ j i, s j+e (b i) K=t i-e H (a j)) :
    ∃ z, (∀ j,s j=z-e H (a j)) ∧ (∀ i,t i=z+e (b i) K) := by
  classical
  let j₀ : J := Classical.arbitrary J
  let i₀ : I := Classical.arbitrary I
  refine ⟨s j₀+e H (a j₀),?_,?_⟩
  · intro j
    have h1 := hc j i₀
    have h2 := hc j₀ i₀
    linear_combination h1-h2
  · intro i
    have h := hc j₀ i
    linear_combination -h

#print axioms singleton_labels_constant_or_injective
#print axioms constant_label_fibers
end TruncatedDistance
