import SidonMatrices
import CSSStopping
namespace JointSidon
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def E (S T : Finset G) (v : Bool × G) (c : G) : Prop :=
  if v.1 then v.2-c ∈ T else c-v.2 ∈ S
instance (S T : Finset G) : DecidableRel (E S T) := fun v c =>
  inferInstanceAs (Decidable (if v.1 then v.2-c ∈ T else c-v.2 ∈ S))
def joined {R : Type*} [Zero R] [One R] (A B : Matrix G G R) : Matrix G (Bool × G) R :=
  fun c v => if v.1 then B v.2 c else A c v.2
def X (R : Type*) [Zero R] [One R] (S T : Finset G) :=
  joined (circulant (SidonStopping.coeff R S)) (circulant (SidonStopping.coeff R T))
def Z (S T : Finset G) := X (ZMod 2) T S
lemma entry (R : Type*) [Zero R] [One R] (S T : Finset G) (v : Bool × G) (c : G) :
    X R S T c v = if E S T v c then 1 else 0 := by
  rcases v with ⟨b,j⟩
  cases b <;> rfl
lemma binary_incidence (S T : Finset G) (v : Bool × G) (c : G) :
    X (ZMod 2) S T c v = 1 ↔ E S T v c := by
  rw [entry]
  split <;> simp_all
lemma joined_product {R : Type*} [CommSemiring R] (A B : Matrix G G R) :
    joined A B * (joined B A)ᵀ = A*Bᵀ+Bᵀ*A := by
  ext c d
  simp only [mul_apply,transpose_apply,joined,add_apply]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_bool,Bool.false_eq_true,↓reduceIte]
  exact add_comm _ _
lemma css (S T : Finset G) : X (ZMod 2) S T * (Z S T)ᵀ = 0 := by
  simp only [Z,X]
  rw [joined_product,transpose_circulant,circulant_mul_comm]
  ext c d
  exact (show ∀ z : ZMod 2, z+z=0 by decide) _

lemma overlap_one (S T : Finset G) (hs : SidonStopping.IsSidon (S ∪ T))
    (hd : Disjoint S T) (v w : Bool × G) (hne : v ≠ w) :
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
  · have hh := hs (c-v) (mem_union_left T hcv) (d-w) (mem_union_left T hdw)
      (d-v) (mem_union_left T hdv) (c-w) (mem_union_left T hcw) (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hne (by congr 1; simpa using h1))
  · have hh := hs (c-v) (mem_union_left T hcv) (w-c) (mem_union_right S hcw)
      (d-v) (mem_union_left T hdv) (w-d) (mem_union_right S hdw) (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (Finset.disjoint_left.mp hd (h1 ▸ hcv) hdw)
  · have hh := hs (v-c) (mem_union_right S hcv) (c-w) (mem_union_left T hcw)
      (v-d) (mem_union_right S hdv) (d-w) (mem_union_left T hdw) (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (Finset.disjoint_left.mp hd hdw (h1 ▸ hcv))
  · have hh := hs (v-c) (mem_union_right S hcv) (w-d) (mem_union_right S hdw)
      (v-d) (mem_union_right S hdv) (w-c) (mem_union_right S hcw) (by abel)
    rcases hh with ⟨h1,_⟩ | ⟨h1,_⟩
    · simpa using h1
    · exact False.elim (hne (by congr 1; simpa using h1))

lemma degree (S T : Finset G) (v : Bool × G) :
    (PartitionStopping.neighbors (E S T) v).card = if v.1 then T.card else S.card := by
  rcases v with ⟨b,j⟩
  cases b
  · exact SidonStopping.degree S (false,j)
  · exact SidonStopping.degree T (true,j)

theorem stopping_bound (S T : Finset G) (hs : SidonStopping.IsSidon (S ∪ T))
    (hd : Disjoint S T) (hc : S.card=T.card)
    (U : Finset (Bool × G)) (hU : Incidence.Stopping (E S T) U) :
    S.card+1 ≤ U.card := by
  have h := PartitionStopping.uniform_overlap_bound (E S T) U hU S.card 1
    (fun v _ => by rw [degree]; split <;> omega)
    (fun v _ w _ hne => overlap_one S T hs hd v w hne)
  simpa using h
end JointSidon
