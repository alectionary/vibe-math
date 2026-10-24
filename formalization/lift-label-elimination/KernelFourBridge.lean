import BinaryDistance

set_option maxHeartbeats 0
namespace KernelFourBridge
open GlobalCounting PaschKernelCount BinaryDistance BinarySupportEquiv Matrix
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

theorem no_weight_four (H : V → Finset C)
    (hn4 : ∀ f : Fin 4 → V, Function.Injective f →
      ¬ PaschClassification.EvenChecks (fun i => H (f i)))
    (x : V → ZMod 2) (hx : checkMatrix H*ᵥx=0) : weight x≠4 := by
  intro hw
  let S : FourSupport V := ⟨bitSupport x,
    Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _,hw⟩⟩
  let f : Fin 4 → V := fun i => (label S i).val
  have hf : Function.Injective f := by
    intro i j hij
    exact (label S).injective (Subtype.ext hij)
  apply hn4 f hf
  change PaschClassification.EvenChecks (localCols H S)
  intro c
  rw [support_selected_card]
  have hc := congrFun hx c
  rw [← indicator_support x,matrix_indicator_eq_selected] at hc
  exact Nat.mod_eq_zero_of_dvd ((ZMod.natCast_eq_zero_iff _ _).mp hc)

theorem lower_bound (H : V → Finset C) (hd : ∀ v, (H v).card=3)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (hn4 : ∀ f : Fin 4 → V, Function.Injective f →
      ¬ PaschClassification.EvenChecks (fun i => H (f i)))
    (x : V → ZMod 2) (hx : checkMatrix H*ᵥx=0) (hn : x≠0) : 6≤weight x :=
  BinaryDistance.lower_bound H hd h4 (no_weight_four H hn4) x hx hn

#print axioms no_weight_four
#print axioms lower_bound
end KernelFourBridge
