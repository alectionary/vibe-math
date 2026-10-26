import PackedTables
import Mathlib.Tactic
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace TruncatedDistance
open KernelCatalog

/-- Completeness, not just validity, of the small index-label tables. -/
theorem permutation4_complete :
    ∀ f : Fin 4 → Fin 4, Function.Injective f →
      ∃ p : Fin 24, ∀ j : Fin 4, perm4Value p.val j.val=(f j).val := by decide +kernel

theorem permutation3_complete :
    ∀ f : Fin 3 → Fin 3, Function.Injective f →
      ∃ p : Fin 6, ∀ i : Fin 3, perm3Value p.val i.val=(f i).val := by decide +kernel

theorem injective_three_columns_complete :
    ∀ f : Fin 3 → Fin 4, Function.Injective f →
      ∃ p : Fin 24, ∀ j : Fin 3, perm4Value p.val j.val=(f j).val := by decide +kernel

theorem ordered_column_pair_complete :
    ∀ a b : Fin 4, a<b → ∃ p : Fin 6,
      columnPairValue p.val 0=a.val ∧ columnPairValue p.val 1=b.val := by decide +kernel

theorem ordered_row_pair_complete :
    ∀ a b : Fin 3, a<b → ∃ p : Fin 3,
      rowPairValue p.val 0=a.val ∧ rowPairValue p.val 1=b.val := by decide +kernel

theorem center_leaf_labels_complete :
    ∀ a b : Fin 4, ∀ f : Fin 3 → Fin 4, (∀ i, f i≠a ∧ f i≠b) →
      ∃ p : Fin 204, centerLeafValue p.val 0=a.val ∧ centerLeafValue p.val 1=b.val ∧
        (∀ i : Fin 3,centerLeafValue p.val (2+i.val)=(f i).val) := by decide +kernel

/-- A proper row coloring of K2,3, with leaves indexed by their missing row
color, has exactly the two cyclic orientations used by the catalog. -/
theorem two_row_color_orientations :
    ∀ a b : Fin 3 → Fin 3, Function.Injective a → Function.Injective b →
      (∀ i,a i≠i ∧ b i≠i ∧ a i≠b i) →
      (∀ i,(a i).val=(i.val+1)%3 ∧ (b i).val=(i.val+2)%3) ∨
      (∀ i,(a i).val=(i.val+2)%3 ∧ (b i).val=(i.val+1)%3) := by decide +kernel

theorem six_binary_flips_complete :
    ∀ f : Fin 6 → Fin 2, ∃ p : Fin 64,
      ∀ i : Fin 6,(p.val/(2^(5-i.val)))%2=(f i).val := by decide +kernel

#print axioms permutation4_complete
#print axioms permutation3_complete
#print axioms injective_three_columns_complete
#print axioms ordered_column_pair_complete
#print axioms ordered_row_pair_complete
#print axioms center_leaf_labels_complete
#print axioms two_row_color_orientations
#print axioms six_binary_flips_complete
end TruncatedDistance
