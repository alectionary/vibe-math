module
public import Spectral
@[expose] public section
open Matrix
namespace StoppingSpectral

/-- Universal answer for the actual scalar-factor model used by Proposition5.1.
No choice of its positive dimensions, binary regular entries or degrees can
make the source large root exceed two while satisfying its spectral gap.
The one-row case also checks the small-branch exclusion for EVERY stopping set. -/
theorem source_parameter_question_negative
    {C F : Type*} [Fintype C] [DecidableEq C] [Nonempty C]
    [Fintype F] [DecidableEq F] [Nonempty F]
    (r γ k : ℕ) (hr : 0 < r) (hγ : 0 < γ)
    (A : Matrix (Fin r × F) (C × F) ℝ) (B : Matrix F F ℝ)
    (hm : 2 ≤ Fintype.card (Fin r × F))
    (hbin : ∀ i j, scalarFactorMatrix A B i j = 0 ∨ scalarFactorMatrix A B i j = 1)
    (hcol : ∀ j, ∑ i, scalarFactorMatrix A B i j = (γ : ℝ))
    (hrow : ∀ i, ∑ j, scalarFactorMatrix A B i j = (k : ℝ))
    (hgap : eigs (scalarFactorMatrix A B) ⟨1,hm⟩ < (γ : ℝ)/2) :
    r = 1 ∧
    (1 < sourceLargeRoot (Fintype.card (Fin r × F)) γ
      (eigs (scalarFactorMatrix A B) ⟨1,hm⟩)) ∧
    (sourceLargeRoot (Fintype.card (Fin r × F)) γ
      (eigs (scalarFactorMatrix A B) ⟨1,hm⟩) ≤ 2) ∧
    ∀ S, IsStopping (scalarFactorMatrix A B) S →
      2 ≤ S.card ∧
      sourceSmallRoot (Fintype.card (Fin r × F)) γ
        (eigs (scalarFactorMatrix A B) ⟨1,hm⟩) < (S.card : ℝ) ∧
      sourceLargeRoot (Fintype.card (Fin r × F)) γ
        (eigs (scalarFactorMatrix A B) ⟨1,hm⟩) ≤ (S.card : ℝ) := by
  by_cases h1 : r = 1
  · subst r
    have hF : 2 ≤ Fintype.card F := by simpa using hm
    have hg : (0:ℝ) < γ := by exact_mod_cast hγ
    have hh := scalar_one_row_source_obstruction A B (γ:ℝ) k hF hg hbin hcol hrow hgap
    refine ⟨rfl,?_,?_,?_⟩
    · simpa using hh.2.1
    · simpa using hh.2.2.1
    · simpa using hh.2.2.2
  · have h2 : 2 ≤ Fintype.card (Fin r) := by simpa using (show 2 ≤ r by omega)
    exact False.elim (qc_scalar_factor_no_source_regime A B γ h2 hγ hcol hgap)

/-- Direct NONEXISTENCE statement: a useful source root above two is impossible.
This is a universally quantified proof, not a failed example search. -/
theorem no_parameters_give_source_improvement
    {C F : Type*} [Fintype C] [DecidableEq C] [Nonempty C]
    [Fintype F] [DecidableEq F] [Nonempty F]
    (r γ k : ℕ) (hr : 0 < r) (hγ : 0 < γ)
    (A : Matrix (Fin r × F) (C × F) ℝ) (B : Matrix F F ℝ)
    (hm : 2 ≤ Fintype.card (Fin r × F))
    (hbin : ∀ i j, scalarFactorMatrix A B i j = 0 ∨ scalarFactorMatrix A B i j = 1)
    (hcol : ∀ j, ∑ i, scalarFactorMatrix A B i j = (γ : ℝ))
    (hrow : ∀ i, ∑ j, scalarFactorMatrix A B i j = (k : ℝ)) :
    ¬ (eigs (scalarFactorMatrix A B) ⟨1,hm⟩ < (γ : ℝ)/2 ∧
      2 < sourceLargeRoot (Fintype.card (Fin r × F)) γ
        (eigs (scalarFactorMatrix A B) ⟨1,hm⟩)) := by
  rintro ⟨hgap,huseful⟩
  have h := source_parameter_question_negative r γ k hr hγ A B hm hbin hcol hrow hgap
  exact (not_lt_of_ge h.2.2.1) huseful
end StoppingSpectral
