import JointSidon
namespace JointSidon
open Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def CrossUnique (S T : Finset G) : Prop :=
  ∀ a ∈ S, ∀ b ∈ T, ∀ c ∈ S, ∀ d ∈ T, a+b=c+d → a=c ∧ b=d
/-- Separate Sidon supports and unique mixed sums suffice; disjoint supports
and a Sidon union are unnecessary. -/
theorem separate_overlap_one (S T : Finset G)
    (hS : SidonStopping.IsSidon S) (hT : SidonStopping.IsSidon T)
    (hcross : CrossUnique S T) (v w : Bool × G) (hne : v ≠ w) :
    PartitionStopping.overlap (E S T) v w ≤ 1 := by
  apply card_le_one.mpr
  intro c hc d hdc
  have hcv := (mem_filter.mp (mem_inter.mp hc).1).2
  have hcw := (mem_filter.mp (mem_inter.mp hc).2).2
  have hdv := (mem_filter.mp (mem_inter.mp hdc).1).2
  have hdw := (mem_filter.mp (mem_inter.mp hdc).2).2
  rcases v with ⟨b,v⟩
  rcases w with ⟨e,w⟩
  cases b <;> cases e
  · have hh := hS (c-v) hcv (d-w) hdw (d-v) hdv (c-w) hcw (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hne (by congr 1; simpa using h1))
  · have hh := hcross (c-v) hcv (w-c) hcw (d-v) hdv (w-d) hdw (by abel)
    simpa using hh.1
  · have hh := hcross (c-w) hcw (v-c) hcv (d-w) hdw (v-d) hdv (by abel)
    simpa using hh.1
  · have hh := hT (v-c) hcv (w-d) hdw (v-d) hdv (w-c) hcw (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hne (by congr 1; simpa using h1))
end JointSidon
