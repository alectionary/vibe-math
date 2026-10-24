module

public import IncidenceCore

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence

/-- Circulant P^s, in the paper's row-minus-column convention. -/
def P (s i j : ZMod 63) : ℕ := if i = j+s then 1 else 0

/-- Expanded A=x^27 I_7+S_7+x^54 S_7^2, exactly Example 3.2. -/
def A (c v : Check) : ℕ :=
  (if c.1 = v.1 then P 27 c.2 v.2 else 0) +
  (if c.1 = v.1+1 then P 0 c.2 v.2 else 0) +
  (if c.1 = v.1+2 then P 54 c.2 v.2 else 0)

def B (i j : ZMod 63) : ℕ := P 0 i j + P 1 i j + P 6 i j

/-- The actual two-block expanded X matrix. false=left, true=right. -/
def HX (c : Check) (v : Var) : ℕ :=
  if v.1 then (if c.1 = v.2.1 then B v.2.2 c.2 else 0) else A c v.2

def HZ (c : Check) (v : Var) : ℕ :=
  if v.1 then A v.2 c else (if c.1 = v.2.1 then B c.2 v.2.2 else 0)

lemma col_nodup : ∀ v : Var, (col v).Nodup := by decide +kernel

lemma point_indicator {R F : Type*} [DecidableEq R] [DecidableEq F]
    (i j : R) (g f : F) :
    (if i = j then (if g = f then (1:ℕ) else 0) else 0) =
      (if (j,f) = (i,g) then 1 else 0) := by
  by_cases hi : i = j <;> by_cases hg : g = f <;> simp_all [Prod.mk.injEq, eq_comm]

lemma P_transpose (s f g : ZMod 63) : P s f g = if g = f-s then 1 else 0 := by
  simp [P, eq_sub_iff_add_eq, eq_comm]

lemma HX_count (c : Check) (v : Var) : HX c v = (col v).countP (· = c) := by
  rcases v with ⟨b,j,f⟩
  rcases c with ⟨i,g⟩
  cases b
  · simp only [HX, A, P, col, Bool.false_eq_true, ↓reduceIte,
      List.countP_cons, List.countP_nil, Nat.add_zero, add_zero]
    simp only [point_indicator, decide_eq_true_eq]
    omega
  · simp only [HX, B, P_transpose, col, ↓reduceIte, sub_zero,
      List.countP_cons, List.countP_nil, Nat.add_zero]
    by_cases hi : i = j
    · subst i; simp [eq_comm, add_comm, add_left_comm, add_assoc]
    · have hji : j ≠ i := Ne.symm hi
      simp [hi,hji]

lemma HX_incidence (v : Var) (c : Check) : HX c v = 1 ↔ E v c := by
  rw [HX_count]
  have hn := col_nodup v
  have hp : (fun x : Check => decide (x = c)) = (fun x => x == c) := by
    funext x
    exact (Bool.beq_eq_decide_eq x c).symm
  rw [hp, ← List.count_eq_countP]
  by_cases h : c ∈ col v
  · simp_all [E, List.count_eq_one_of_mem hn h]
  · simp [List.count_eq_zero.mpr h, E, h]

/-- A particular H_Z generator, row (0,0), with its actual six qubits. -/
def six : Finset Var :=
  {(false,0,0), (false,0,-1), (false,0,-6),
   (true,0,27), (true,1,0), (true,2,54)}

theorem six_card : six.card = 6 := by decide +kernel

theorem six_profile : ∀ c : Check,
    (six.filter (fun v => E v c)).card = 0 ∨ (six.filter (fun v => E v c)).card = 2 := by
  decide +kernel

theorem six_stopping : Stopping E six := by
  refine ⟨by simp [six], ?_⟩
  intro c
  rcases six_profile c with h | h <;> omega

theorem six_is_HZ_row : ∀ v : Var, v ∈ six ↔ HZ (0,0) v = 1 := by
  decide +kernel

theorem dimensions : Fintype.card Var = 882 ∧ Fintype.card Check = 441 := by decide +kernel
end Incidence
