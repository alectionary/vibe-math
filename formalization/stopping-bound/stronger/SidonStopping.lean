import PartitionBound
import GramObstruction
namespace SidonStopping
open Finset
variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

def IsSidon (S : Finset G) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, ∀ c ∈ S, ∀ d ∈ S, a+b=c+d →
    (a=c ∧ b=d) ∨ (a=d ∧ b=c)
def E (S : Finset G) (v : Bool × G) (c : G) : Prop :=
  if v.1 then v.2-c ∈ S else c-v.2 ∈ S
instance (S : Finset G) : DecidableRel (E S) := fun v c =>
  inferInstanceAs (Decidable (if v.1 then v.2-c ∈ S else c-v.2 ∈ S))

theorem same_overlap (S : Finset G) (hs : IsSidon S) (b : Bool)
    (v w : G) (hvw : v ≠ w) :
    PartitionStopping.overlap (E S) (b,v) (b,w) ≤ 1 := by
  apply card_le_one.mpr
  intro c hc d hd
  have hcv := (mem_filter.mp (mem_inter.mp hc).1).2
  have hcw := (mem_filter.mp (mem_inter.mp hc).2).2
  have hdv := (mem_filter.mp (mem_inter.mp hd).1).2
  have hdw := (mem_filter.mp (mem_inter.mp hd).2).2
  cases b
  · have hh := hs (c-v) hcv (d-w) hdw (d-v) hdv (c-w) hcw (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hvw (by simpa using h1))
  · have hh := hs (v-c) hcv (w-d) hdw (v-d) hdv (w-c) hcw (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hvw (by simpa using h1))

theorem cross_overlap (S : Finset G) (hs : IsSidon S) (v w : G) :
    PartitionStopping.overlap (E S) (false,v) (true,w) ≤ 2 := by
  classical
  let U := PartitionStopping.neighbors (E S) (false,v) ∩
    PartitionStopping.neighbors (E S) (true,w)
  change U.card ≤ 2
  by_cases hu : U.Nonempty
  · obtain ⟨c0,hc0⟩ := hu
    have ha := (mem_filter.mp (mem_inter.mp hc0).1).2
    have hb := (mem_filter.mp (mem_inter.mp hc0).2).2
    have hsub : U ⊆ {c0,v+w-c0} := by
      intro c hc
      have hc1 := (mem_filter.mp (mem_inter.mp hc).1).2
      have hc2 := (mem_filter.mp (mem_inter.mp hc).2).2
      have hh := hs (c-v) hc1 (w-c) hc2 (c0-v) ha (w-c0) hb (by abel)
      apply mem_insert.mpr
      rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
      · left; simpa using h1
      · right
        apply mem_singleton.mpr
        calc
          c = (c-v)+v := by abel
          _ = (w-c0)+v := congrArg (fun x => x+v) h1
          _ = v+w-c0 := by abel
    exact (card_le_card hsub).trans (by have hh := card_insert_le c0 {v+w-c0}; simpa using hh)
  · rw [not_nonempty_iff_eq_empty.mp hu]
    simp

theorem overlap_bound (S : Finset G) (hs : IsSidon S)
    (v w : Bool × G) (hne : v ≠ w) :
    PartitionStopping.overlap (E S) v w ≤ if v.1 = w.1 then 1 else 2 := by
  rcases v with ⟨b,v⟩
  rcases w with ⟨d,w⟩
  cases b <;> cases d
  · exact same_overlap S hs false v w (by simpa using hne)
  · exact cross_overlap S hs v w
  · have hh := cross_overlap S hs w v
    simpa [PartitionStopping.overlap,inter_comm] using hh
  · exact same_overlap S hs true v w (by simpa using hne)

theorem degree (S : Finset G) (v : Bool × G) :
    (PartitionStopping.neighbors (E S) v).card = S.card := by
  classical
  rcases v with ⟨b,j⟩
  cases b
  · have heq : PartitionStopping.neighbors (E S) (false,j) = S.image (fun s => s+j) := by
      ext c
      simp only [PartitionStopping.neighbors,mem_filter,mem_univ,true_and,E,Bool.false_eq_true,
        ↓reduceIte,mem_image]
      exact ⟨fun h => ⟨c-j,h,by abel⟩,fun ⟨s,hs,he⟩ => by simpa [← he] using hs⟩
    rw [heq,card_image_of_injective _ (add_left_injective j)]
  · have heq : PartitionStopping.neighbors (E S) (true,j) = S.image (fun s => j-s) := by
      ext c
      simp only [PartitionStopping.neighbors,mem_filter,mem_univ,true_and,E,↓reduceIte,mem_image]
      exact ⟨fun h => ⟨j-c,h,by abel⟩,fun ⟨s,hs,he⟩ => by simpa [← he] using hs⟩
    rw [heq,card_image_of_injective _ (sub_right_injective : Function.Injective (fun s : G => j-s))]

theorem stopping_bound (S : Finset G) (hs : IsSidon S)
    (T : Finset (Bool × G)) (hT : Incidence.Stopping (E S) T) :
    2 * (S.card + 1) ≤ 3 * T.card := by
  have h := PartitionStopping.partition_bound (E S) Prod.fst T hT S.card 1 2 (by omega)
    (fun v _ => by rw [degree]) (fun v _ w _ he => overlap_bound S hs v w he)
  exact h
end SidonStopping
