module

public import CyclicLift.Bipartite
public import Mathlib.Data.Matrix.Basic

@[expose] public section

namespace CyclicLift

open scoped Classical

variable {I J : Type*} {r : ℕ}

/-- Variables of P34 B_X: n copies of n left variables, and m copies of m right variables. -/
abbrev XVariable (I J : Type*) := (J × J) ⊕ (I × I)
abbrev XCheck (I J : Type*) := I × J

/-- Support of [B tensor I_n | I_m tensor B*], for a base B with no zero blocks. -/
def xSupport : XVariable I J → XCheck I J → Prop
  | .inl v, c => v.2 = c.2
  | .inr v, c => v.1 = c.1

/-- B* transposes block indices and negates circulant exponents. -/
def xLabel (B : I → J → ZMod r) : XVariable I J → XCheck I J → ZMod r
  | .inl v, c => B c.1 v.1
  | .inr v, c => -B v.2 c.2

/-- The particular lifted-product Tanner graph in P34 Equation (2.3), X side. -/
def xGraph (B : I → J → ZMod r) := tannerLift xSupport (xLabel B)

/-- The (row,column) entry of P^epsilon. Rows are images of columns, as in P34. -/
noncomputable def permutationEntry (epsilon row col : ZMod r) : ZMod 2 :=
  if row = col + epsilon then 1 else 0

/-- Negating an exponent transposes its permutation block, validating the B* convention. -/
theorem permutationEntry_neg (epsilon row col : ZMod r) :
    permutationEntry (-epsilon) row col = permutationEntry epsilon col row := by
  have he : (row = col + -epsilon) ↔ col = row + epsilon := by
    constructor
    · intro h; rw [h]; simp [add_assoc]
    · intro h; rw [h]; simp [add_assoc]
  simp only [permutationEntry, he]

/-- Explicit binary block expansion of B_X, with all identity factors and B* signs visible. -/
noncomputable def hX (B : I → J → ZMod r) :
    Matrix (XCheck I J × ZMod r) (XVariable I J × ZMod r) (ZMod 2) :=
  fun c v => if xSupport v.1 c.1 then
    permutationEntry (xLabel B v.1 c.1) c.2 v.2 else 0

@[simp] theorem hX_left (B : I → J → ZMod r) (i : I) (j k j' : J) (a b : ZMod r) :
    hX B ((i, j), a) (.inl (k, j'), b) =
      if j' = j then permutationEntry (B i k) a b else 0 := rfl

@[simp] theorem hX_right (B : I → J → ZMod r) (i i' l : I) (j : J) (a b : ZMod r) :
    hX B ((i, j), a) (.inr (i', l), b) =
      if i' = i then permutationEntry (-B l j) a b else 0 := rfl

@[simp] theorem hX_ne_zero_iff (B : I → J → ZMod r)
    (v : XVariable I J) (c : XCheck I J) (a b : ZMod r) :
    hX B (c, b) (v, a) ≠ 0 ↔ xSupport v c ∧ b = a + xLabel B v c := by
  classical
  simp [hX, permutationEntry]

/-- A matrix's Tanner graph in the same sum/fiber indexing as the voltage lift. -/
def matrixTanner {V C A : Type*} (H : Matrix (C × A) (V × A) (ZMod 2)) :
    SimpleGraph ((V ⊕ C) × A) where
  Adj x y := match x.1, y.1 with
    | .inl v, .inr c => H (c, y.2) (v, x.2) ≠ 0
    | .inr c, .inl v => H (c, x.2) (v, y.2) ≠ 0
    | _, _ => False
  symm := ⟨by rintro ⟨x, a⟩ ⟨y, b⟩ h; cases x <;> cases y <;> exact h⟩
  loopless := ⟨by rintro ⟨x, a⟩; cases x <;> exact not_false⟩

/-- The graph used in the proofs is exactly the Tanner graph of the expanded binary matrix. -/
theorem xGraph_eq_matrixTanner (B : I → J → ZMod r) :
    xGraph B = matrixTanner (hX B) := by
  ext ⟨x, a⟩ ⟨y, b⟩
  cases x <;> cases y <;>
    simp [xGraph, matrixTanner, hX_ne_zero_iff]

/-- The obstruction for an ordinary B rectangle, written in the source row/column convention. -/
def baseRectangle (B : I → J → ZMod r) (i0 i1 : I) (j0 j1 : J) : ZMod r :=
  B i0 j0 - B i0 j1 + B i1 j1 - B i1 j0

/-- Every zero-voltage base rectangle embeds as a genuine four-cycle in G_HX. -/
theorem base_rectangle_gives_x_four_cycle (B : I → J → ZMod r)
    (i0 i1 : I) (j0 j1 fixed : J) (a : ZMod r)
    (hi : i0 ≠ i1) (hj : j0 ≠ j1) (hz : baseRectangle B i0 i1 j0 j1 = 0) :
    ∃ p : (xGraph B).Walk (.inl (.inl (j0, fixed)), a)
      (.inl (.inl (j0, fixed)), a), p.IsCycle ∧ p.length = 4 := by
  apply rectangle_gives_four_cycle xSupport (xLabel B)
    (.inl (j0, fixed)) (.inl (j1, fixed)) (i0, fixed) (i1, fixed) a
  · intro h; exact hj (congrArg Prod.fst (Sum.inl.inj h))
  · intro h; exact hi (congrArg Prod.fst h)
  · rfl
  · rfl
  · rfl
  · rfl
  · change B i0 j0 - B i0 j1 + B i1 j1 - B i1 j0 = 0
    exact hz

/-- Exactly the source's zero base rectangles characterize all four-cycles of G_HX.
Mixed left/right rectangles cannot create a four-cycle. -/
theorem xGraph_hasFourCycle_iff (B : I → J → ZMod r) :
    HasFourCycle (xGraph B) ↔ ∃ i0 i1 j0 j1,
      i0 ≠ i1 ∧ j0 ≠ j1 ∧ baseRectangle B i0 i1 j0 j1 = 0 := by
  change HasFourCycle (tannerLift xSupport (xLabel B)) ↔ _
  rw [hasFourCycle_iff_rectangle]
  constructor
  · rintro ⟨v0, v1, ⟨i0, j0⟩, ⟨i1, j1⟩, hv, hc, h00, h10, h11, h01, hz⟩
    rcases v0 with ⟨k0, t0⟩ | ⟨t0, l0⟩ <;>
      rcases v1 with ⟨k1, t1⟩ | ⟨t1, l1⟩
    · change t0 = j0 at h00
      change t1 = j0 at h10
      change t1 = j1 at h11
      subst j0; subst t1; subst j1
      refine ⟨i0, i1, k0, k1, ?_, ?_, hz⟩
      · intro h; subst i1; exact hc rfl
      · intro h; subst k1; exact hv rfl
    · exact False.elim (hc (Prod.ext (h10.symm.trans h11) (h00.symm.trans h01)))
    · exact False.elim (hc (Prod.ext (h00.symm.trans h01) (h10.symm.trans h11)))
    · change t0 = i0 at h00
      change t1 = i0 at h10
      change t1 = i1 at h11
      subst i0; subst t1; subst i1
      refine ⟨l0, l1, j0, j1, ?_, ?_, ?_⟩
      · intro h; subst l1; exact hv rfl
      · intro h; subst j1; exact hc rfl
      · have hn : rectangleVoltage (xLabel B) (.inr (t0, l0)) (.inr (t0, l1))
            (t0, j0) (t0, j1) = -baseRectangle B l0 l1 j0 j1 := by
          simp only [rectangleVoltage, xLabel, baseRectangle, sub_eq_add_neg,
            neg_add_rev, neg_neg]
          abel
        rw [hn, neg_eq_zero] at hz
        exact hz
  · rintro ⟨i0, i1, j0, j1, hi, hj, hz⟩
    refine ⟨.inl (j0, j0), .inl (j1, j0), (i0, j0), (i1, j0), ?_, ?_,
      rfl, rfl, rfl, rfl, hz⟩
    · intro h; exact hj (congrArg Prod.fst (Sum.inl.inj h))
    · intro h; exact hi (congrArg Prod.fst h)

/-- Native cycle form of the complete four-cycle test. -/
theorem xGraph_native_fourCycle_iff (B : I → J → ZMod r) :
    (∃ v, ∃ p : (xGraph B).Walk v v, p.IsCycle ∧ p.length = 4) ↔
      ∃ i0 i1 j0 j1, i0 ≠ i1 ∧ j0 ≠ j1 ∧ baseRectangle B i0 i1 j0 j1 = 0 := by
  rw [← hasFourCycle_iff_native, xGraph_hasFourCycle_iff]

/-- With positive modulus the model has exactly the paper's finite row dimension. -/
theorem hX_row_count [Fintype I] [Fintype J] [NeZero r] :
    Fintype.card (XCheck I J × ZMod r) = Fintype.card I * Fintype.card J * r := by
  simp [XCheck, Fintype.card_prod]

/-- The column count is (n^2 + m^2)r, with the two block families kept separate. -/
theorem hX_column_count [Fintype I] [Fintype J] [NeZero r] :
    Fintype.card (XVariable I J × ZMod r) =
      (Fintype.card J * Fintype.card J + Fintype.card I * Fintype.card I) * r := by
  simp [XVariable, Fintype.card_prod]

end CyclicLift
