import PaschKernelCount
import Mathlib.Data.Matrix.Block
import Mathlib.Tactic.Abel

set_option maxHeartbeats 0
namespace CyclicCSSCommute
open Matrix
open scoped BigOperators
variable {V C G R : Type*} [Fintype V] [Fintype C] [Fintype G]
  [DecidableEq V] [DecidableEq C] [DecidableEq G] [AddCommGroup G] [CommRing R]

def fromCols {m n p : Type*} (A : Matrix m n R) (B : Matrix m p R) : Matrix m (n ⊕ p) R :=
  fun i j => Sum.elim (A i) (B i) j

def fromRows {m n p : Type*} (A : Matrix m p R) (B : Matrix n p R) : Matrix (m ⊕ n) p R :=
  fun i j => Sum.elim (fun r => A r j) (fun r => B r j) i

theorem block_product {m n p l : Type*} [Fintype n] [Fintype p]
    (A : Matrix m n R) (B : Matrix m p R) (C : Matrix n l R) (D : Matrix p l R) :
    fromCols A B*fromRows C D=A*C+B*D := by
  ext i j
  simp [Matrix.mul_apply,Fintype.sum_sum_type,fromCols,fromRows]

def cover (H : V → Finset C) (z : V → C → G) : Matrix (C × G) (V × G) R :=
  fun a b => if a.1∈H b.1 ∧ a.2=b.2+z b.1 a.1 then 1 else 0

def translation (K : Type*) [DecidableEq K] (h : G) : Matrix (K × G) (K × G) R :=
  fun a b => if a.1=b.1 ∧ a.2=b.2+h then 1 else 0

lemma eq_add_iff (s a h : G) : s=a+h ↔ a=s-h := by
  constructor <;> intro he
  · rw [he]; abel
  · rw [he]; abel

lemma eq_sub_iff (s a h : G) : s=a-h ↔ a=s+h := by
  constructor <;> intro he
  · rw [he]; abel
  · rw [he]; abel

/-- Arbitrary monomial cover entries commute with a common fiber translation. -/
theorem commute_translation (H : V → Finset C) (z : V → C → G) (h : G) :
    (cover H z : Matrix (C × G) (V × G) R)*translation V h=
      translation C h*cover H z := by
  ext a b
  rcases a with ⟨c,s⟩
  rcases b with ⟨v,t⟩
  have hl : ((cover H z*translation V h : Matrix (C × G) (V × G) R)) (c,s) (v,t)=
      if c∈H v ∧ s=(t+h)+z v c then 1 else 0 := by
    simp [Matrix.mul_apply,Fintype.sum_prod_type,cover,translation,
      mul_ite,ite_and,Finset.sum_ite_eq',Finset.sum_ite_eq]
  have hr : ((translation C h*cover H z : Matrix (C × G) (V × G) R)) (c,s) (v,t)=
      if c∈H v ∧ s-h=t+z v c then 1 else 0 := by
    have ht (d : C) (a : G) :
        (translation C h : Matrix (C × G) (C × G) R) (c,s) (d,a)=
          if d=c ∧ a=s-h then 1 else 0 := by
      simp only [translation]
      congr 1
      apply propext
      constructor
      · rintro ⟨hcd,hsa⟩; exact ⟨hcd.symm,(eq_add_iff s a h).mp hsa⟩
      · rintro ⟨hdc,has⟩; exact ⟨hdc.symm,(eq_add_iff s a h).mpr has⟩
    simp only [Matrix.mul_apply,Fintype.sum_prod_type]
    simp_rw [ht]
    simp [ite_mul,ite_and,Finset.sum_ite_eq',Finset.sum_ite_eq,cover,eq_comm]
  rw [hl,hr]
  congr 1
  apply propext
  constructor
  · rintro ⟨hc,he⟩
    refine ⟨hc,?_⟩
    rw [he]; abel
  · rintro ⟨hc,he⟩
    refine ⟨hc,?_⟩
    calc
      s=(s-h)+h := by abel
      _=(t+z v c)+h := by rw [he]
      _=(t+h)+z v c := by abel

def scalar (K : Type*) [DecidableEq K] (h k : G) : Matrix (K × G) (K × G) R :=
  translation K 0+translation K h+translation K k

theorem commute_scalar (H : V → Finset C) (z : V → C → G) (h k : G) :
    (cover H z : Matrix (C × G) (V × G) R)*scalar V h k=
      scalar C h k*cover H z := by
  simp only [scalar,Matrix.mul_add,Matrix.add_mul,commute_translation]

/-- The two actual sparse binary blocks form commuting CSS checks. -/
theorem css_commutes (H : V → Finset C) (z : V → C → G) (h k : G) :
    fromCols (cover H z : Matrix (C × G) (V × G) (ZMod 2)) (scalar (R := ZMod 2) C h k) *
      fromRows (scalar (R := ZMod 2) V h k) (cover (R := ZMod 2) H z)=0 := by
  rw [block_product,commute_scalar]
  ext i j
  exact (show ∀ x : ZMod 2, x+x=0 by decide) _

#print axioms commute_translation
#print axioms css_commutes
end CyclicCSSCommute
