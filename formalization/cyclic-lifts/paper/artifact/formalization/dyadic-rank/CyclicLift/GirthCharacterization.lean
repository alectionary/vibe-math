module

public import CyclicLift.SixCharacterization

@[expose] public section
namespace CyclicLift
variable {I J : Type*} {r : ℕ}

/-- A commuting mixed-block square gives an eight-edge walk for arbitrary exponents.
The four check projections are the corners of a rectangle. -/
def mixedEight (B : I → J → ZMod r) (i0 i1 : I) (j0 j1 k : J) (l : I) :
    (xGraph B).Walk (.inr (i0,j0), B i0 k - B l j0)
      (.inr (i0,j0), B i0 k - B l j0) :=
  eightWalk
    (b := (.inl (.inl (k,j0)), -B l j0))
    (c := (.inr (i1,j0), B i1 k - B l j0))
    (d := (.inl (.inr (i1,l)), B i1 k))
    (e := (.inr (i1,j1), B i1 k - B l j1))
    (f := (.inl (.inl (k,j1)), -B l j1))
    (g := (.inr (i0,j1), B i0 k - B l j1))
    (h := (.inl (.inr (i0,l)), B i0 k))
    (by simp [xGraph, check_variable_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, variable_check_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, check_variable_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, variable_check_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, check_variable_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, variable_check_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, check_variable_adj, xSupport, xLabel]; abel)
    (by simp [xGraph, variable_check_adj, xSupport, xLabel]; abel)

/-- Distinct selected rows and columns make the mixed walk a native simple cycle. -/
theorem mixedEight_isCycle (B : I → J → ZMod r) (i0 i1 : I) (j0 j1 k : J) (l : I)
    (hi : i0 ≠ i1) (hj : j0 ≠ j1) : (mixedEight B i0 i1 j0 j1 k l).IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp [mixedEight, eightWalk, SimpleGraph.Walk.isPath_def, hj, Ne.symm hi, Ne.symm hj]
  · change 3 ≤ 8; omega

@[simp] theorem mixedEight_length (B : I → J → ZMod r) (i0 i1 : I) (j0 j1 k : J) (l : I) :
    (mixedEight B i0 i1 j0 j1 k l).length = 8 := rfl

/-- Explicit eight-cycle bound with witnesses of two rows and two columns. -/
theorem xGraph_girth_le_eight (B : I → J → ZMod r) (i0 i1 : I) (j0 j1 : J)
    (hi : i0 ≠ i1) (hj : j0 ≠ j1) : (xGraph B).girth ≤ 8 := by
  simpa using (mixedEight_isCycle B i0 i1 j0 j1 j0 i0 hi hj).girth_le_length

/-- Exact girth eight iff neither a four-cycle nor a six-cycle occurs.
The explicit mixed eight-cycle supplies the upper bound and excludes acyclicity. -/
theorem xGraph_girth_eq_eight_iff_no_short (B : I → J → ZMod r)
    (i0 i1 : I) (j0 j1 : J) (hi : i0 ≠ i1) (hj : j0 ≠ j1) :
    (xGraph B).girth = 8 ↔ ¬HasFourCycle (xGraph B) ∧ ¬HasSixCycle (xGraph B) := by
  constructor
  · intro hg
    constructor
    · intro h4
      obtain ⟨a,p,hp,hl⟩ := (hasFourCycle_iff_native _).mp h4
      have hle := hp.girth_le_length
      omega
    · intro h6
      obtain ⟨a,p,hp,hl⟩ := (hasSixCycle_iff_native _).mp h6
      have hle := hp.girth_le_length
      omega
  · rintro ⟨h4,h6⟩
    exact girth_eq_eight_of_short_cycles _ (tannerColoring _ _) h4 h6
      (mixedEight B i0 i1 j0 j1 j0 i0) (mixedEight_isCycle B i0 i1 j0 j1 j0 i0 hi hj)
      (mixedEight_length B i0 i1 j0 j1 j0 i0)

/-- Full entrywise characterization for the all-permutation-block P34 X construction.
No normalization, connectedness, coprimality or primality hypothesis is needed. -/
theorem xGraph_girth_eq_eight_iff (B : I → J → ZMod r)
    (i0 i1 : I) (j0 j1 : J) (hi : i0 ≠ i1) (hj : j0 ≠ j1) :
    (xGraph B).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseHexagon B a b c d e f ≠ 0) := by
  rw [xGraph_girth_eq_eight_iff_no_short B i0 i1 j0 j1 hi hj,
    xGraph_hasFourCycle_iff, xGraph_hasSixCycle_iff]
  simp only [not_exists, not_and]

/-- The entrywise characterization for the actual expanded binary matrix's Tanner graph. -/
theorem matrixTanner_hX_girth_eq_eight_iff (B : I → J → ZMod r)
    (i0 i1 : I) (j0 j1 : J) (hi : i0 ≠ i1) (hj : j0 ≠ j1) :
    (matrixTanner (hX B)).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseHexagon B a b c d e f ≠ 0) := by
  rw [← xGraph_eq_matrixTanner]
  exact xGraph_girth_eq_eight_iff B i0 i1 j0 j1 hi hj

/-- The six-edge obstruction is a compatibility condition on two 2-by-2 rectangles. -/
theorem baseHexagon_eq_rectangle_add (B : I → J → ZMod r)
    (i0 i1 i2 : I) (j0 j1 j2 : J) :
    baseHexagon B i0 i1 i2 j0 j1 j2 =
      baseRectangle B i0 i1 j0 j1 + baseRectangle B i1 i2 j0 j2 := by
  unfold baseHexagon baseRectangle
  abel

/-- An equivalent complete criterion expressed using only 2-by-2 rectangle voltages. -/
theorem xGraph_girth_eq_eight_iff_rectangles (B : I → J → ZMod r)
    (i0 i1 : I) (j0 j1 : J) (hi : i0 ≠ i1) (hj : j0 ≠ j1) :
    (xGraph B).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseRectangle B a b d e + baseRectangle B b c d f ≠ 0) := by
  simpa only [baseHexagon_eq_rectangle_add] using
    xGraph_girth_eq_eight_iff B i0 i1 j0 j1 hi hj

/-- Every nontrivial row/column type yields an actual eight-cycle, not merely girth ≤ 8. -/
theorem xGraph_exists_eight_cycle [Nontrivial I] [Nontrivial J] (B : I → J → ZMod r) :
    ∃ a, ∃ p : (xGraph B).Walk a a, p.IsCycle ∧ p.length = 8 := by
  obtain ⟨i0,i1,hi⟩ := exists_pair_ne I
  obtain ⟨j0,j1,hj⟩ := exists_pair_ne J
  exact ⟨_,mixedEight B i0 i1 j0 j1 j0 i0,
    mixedEight_isCycle B i0 i1 j0 j1 j0 i0 hi hj, mixedEight_length B i0 i1 j0 j1 j0 i0⟩

/-- Extended girth bound, retaining the explicit guarantee that the graph is not acyclic. -/
theorem xGraph_egirth_le_eight [Nontrivial I] [Nontrivial J] (B : I → J → ZMod r) :
    (xGraph B).egirth ≤ 8 := by
  obtain ⟨a,p,hp,hl⟩ := xGraph_exists_eight_cycle B
  simpa [hl] using hp.egirth_le_length

/-- Public arbitrary-dimension criterion: nontrivial types express at least two rows/columns. -/
theorem xGraph_girth_characterization [Nontrivial I] [Nontrivial J]
    (B : I → J → ZMod r) :
    (xGraph B).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseHexagon B a b c d e f ≠ 0) := by
  obtain ⟨i0,i1,hi⟩ := exists_pair_ne I
  obtain ⟨j0,j1,hj⟩ := exists_pair_ne J
  exact xGraph_girth_eq_eight_iff B i0 i1 j0 j1 hi hj

/-- Public exact characterization for the expanded binary parity-check matrix. -/
theorem matrixTanner_hX_girth_characterization [Nontrivial I] [Nontrivial J]
    (B : I → J → ZMod r) :
    (matrixTanner (hX B)).girth = 8 ↔
      (∀ a b c d, a ≠ b → c ≠ d → baseRectangle B a b c d ≠ 0) ∧
      (∀ a b c d e f, a ≠ b → b ≠ c → a ≠ c → d ≠ e → e ≠ f → d ≠ f →
        baseHexagon B a b c d e f ≠ 0) := by
  rw [← xGraph_eq_matrixTanner]
  exact xGraph_girth_characterization B

end CyclicLift
