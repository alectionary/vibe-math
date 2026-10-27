/-
Orthogonality and population values of the four-group contrasts in Jeffries
(2024), Table 2.2 and equations (3.3)–(3.5).

Codes are the printed columns. Group order is (1, 2, 3, 4). The data-generating
latent means are (1, 3/5, 4/5, 2/5). A defined contrast is the mean of the two
groups coded `+1`, minus the mean of the two groups coded `-1`.
-/

import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace LatentContrasts

abbrev V := Fin 4 → ℚ

def dot (a b : V) : ℚ :=
  a 0 * b 0 + a 1 * b 1 + a 2 * b 2 + a 3 * b 3

def wdot (n a b : V) : ℚ :=
  n 0 * a 0 * b 0 + n 1 * a 1 * b 1 + n 2 * a 2 * b 2 + n 3 * a 3 * b 3

/-- Table 2.2, column C1. -/
def c1 : V
  | 0 => -1
  | 1 => 1
  | 2 => -1
  | 3 => 1

/-- Table 2.2, column C2. -/
def c2 : V
  | 0 => -1
  | 1 => -1
  | 2 => 1
  | 3 => 1

/-- Table 2.2, column C3. -/
def c3 : V
  | 0 => 1
  | 1 => -1
  | 2 => -1
  | 3 => 1

/-- Chapter III latent means `α = (1, 0.6, 0.8, 0.4)`. -/
def kappa : V
  | 0 => 1
  | 1 => 3 / 5
  | 2 => 4 / 5
  | 3 => 2 / 5

/-- Marker rescaling by the data-generating loading `0.7`. -/
def marker (a : V) : V
  | i => (7 / 10) * a i

def ones : V
  | _ => 1

def nEqual (n : ℚ) : V
  | _ => n

/-- The dissertation's imbalance pattern: two equal large groups, then two equal small groups. -/
def nPattern (a b : ℚ) : V
  | 0 => a
  | 1 => a
  | 2 => b
  | 3 => b

theorem pattern_breaks_only_c1_c3 (a b : ℚ) :
    wdot (nPattern a b) c1 c2 = 0 ∧ wdot (nPattern a b) c2 c3 = 0 ∧
      wdot (nPattern a b) c1 c3 = 2 * (b - a) := by
  refine And.intro ?_ (And.intro ?_ ?_)
  · simp only [wdot, nPattern, c1, c2]; ring
  · simp only [wdot, nPattern, c2, c3]; ring
  · simp only [wdot, nPattern, c1, c3]; ring

/-- Condition 2 at `N = 240`: proportions 35, 35, 15, 15 percent. -/
def nCond2 : V
  | 0 => 84
  | 1 => 84
  | 2 => 36
  | 3 => 36

/-- Condition 3 at `N = 240`: proportions 45, 45, 5, 5 percent. -/
def nCond3 : V
  | 0 => 108
  | 1 => 108
  | 2 => 12
  | 3 => 12

/-- Mean of the `+1` groups minus mean of the `-1` groups. -/
def defined (code a : V) : ℚ :=
  ((if code 0 = 1 then a 0 else 0) + (if code 1 = 1 then a 1 else 0) +
      (if code 2 = 1 then a 2 else 0) + (if code 3 = 1 then a 3 else 0)) /
      2 -
    ((if code 0 = -1 then a 0 else 0) + (if code 1 = -1 then a 1 else 0) +
        (if code 2 = -1 then a 2 else 0) + (if code 3 = -1 then a 3 else 0)) /
      2

theorem column_sums_zero :
    dot c1 ones = 0 ∧ dot c2 ones = 0 ∧ dot c3 ones = 0 := by
  native_decide

theorem unweighted_cross_products_zero :
    dot c1 c2 = 0 ∧ dot c1 c3 = 0 ∧ dot c2 c3 = 0 := by
  native_decide

theorem balanced_weights_stay_orthogonal (n : ℚ) :
    wdot (nEqual n) c1 c2 = 0 ∧ wdot (nEqual n) c1 c3 = 0 ∧
      wdot (nEqual n) c2 c3 = 0 := by
  refine And.intro ?_ (And.intro ?_ ?_)
  · simp only [wdot, nEqual, c1, c2]; ring
  · simp only [wdot, nEqual, c1, c3]; ring
  · simp only [wdot, nEqual, c2, c3]; ring

theorem cond2_only_c1_c3_fails :
    wdot nCond2 c1 c2 = 0 ∧ wdot nCond2 c2 c3 = 0 ∧ wdot nCond2 c1 c3 = -96 := by
  native_decide

theorem cond3_only_c1_c3_fails :
    wdot nCond3 c1 c2 = 0 ∧ wdot nCond3 c2 c3 = 0 ∧ wdot nCond3 c1 c3 = -192 := by
  native_decide

theorem population_defined_contrasts :
    defined c1 kappa = -2 / 5 ∧ defined c2 kappa = -1 / 5 ∧ defined c3 kappa = 0 := by
  native_decide

theorem contrast_three_is_null_while_means_differ :
    kappa 0 ≠ kappa 1 ∧ defined c3 kappa = 0 := by
  native_decide

theorem marker_contrasts :
    defined c1 (marker kappa) = -7 / 25 ∧ defined c2 (marker kappa) = -7 / 50 ∧
      defined c3 (marker kappa) = 0 := by
  native_decide

/-- Treatment codes: `0` on the Table 2.2 entry `-1`, and `1` on `+1`. -/
def d1 : V
  | 0 => 0
  | 1 => 1
  | 2 => 0
  | 3 => 1

def d2 : V
  | 0 => 0
  | 1 => 0
  | 2 => 1
  | 3 => 1

def d3 : V
  | 0 => 1
  | 1 => 0
  | 2 => 0
  | 3 => 1

/-- The saturated mean `α + b1 d1 + b2 d2 + b3 d3` at the printed coefficients. -/
def saturated (i : Fin 4) : ℚ :=
  1 + (-2 / 5) * d1 i + (-1 / 5) * d2 i + 0 * d3 i

theorem treatment_coefficients_match_defined_contrasts :
    saturated 0 = kappa 0 ∧ saturated 1 = kappa 1 ∧ saturated 2 = kappa 2 ∧
      saturated 3 = kappa 3 := by
  native_decide

end LatentContrasts
