module

public import IncidenceFamilyCore
public import IncidenceSource
public import Mathlib.LinearAlgebra.Matrix.Circulant

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
namespace Incidence.Family
variable {n : ℕ}
/-- Circulant P^s, in the paper's row-minus-column convention. -/
def P (s i j : ZMod n) : ℕ := if i = j+s then 1 else 0

/-- Expanded A=x^27 I_7+S_7+x^54 S_7^2, exactly Example 3.2. -/
def A (c v : Check n) : ℕ :=
  (if c.1 = v.1 then P 27 c.2 v.2 else 0) +
  (if c.1 = v.1+1 then P 0 c.2 v.2 else 0) +
  (if c.1 = v.1+2 then P 54 c.2 v.2 else 0)

def B (i j : ZMod n) : ℕ := P 0 i j + P 1 i j + P 6 i j

/-- The actual two-block expanded X matrix. false=left, true=right. -/
def HX (c : Check n) (v : Var n) : ℕ :=
  if v.1 then (if c.1 = v.2.1 then B v.2.2 c.2 else 0) else A c v.2

def HZ (c : Check n) (v : Var n) : ℕ :=
  if v.1 then A v.2 c else (if c.1 = v.2.1 then B c.2 v.2.2 else 0)

lemma col_nodup (h : 63 ∣ n) (v : Var n) : (col v).Nodup := by
  have hm : ((col v).map (projC h)).Nodup := by
    rw [project_col]; exact Incidence.col_nodup _
  exact List.Nodup.of_map (projC h) hm

lemma P_transpose (s f g : ZMod n) : P s f g = if g = f-s then 1 else 0 := by
  simp [P, eq_sub_iff_add_eq, eq_comm]

lemma HX_count (c : Check n) (v : Var n) : HX c v = (col v).countP (· = c) := by
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

lemma HX_incidence (h : 63 ∣ n) (v : Var n) (c : Check n) : HX c v = 1 ↔ E v c := by
  rw [HX_count]
  have hn := col_nodup h v
  have hp : (fun x : Check n => decide (x = c)) = (fun x => x == c) := by
    funext x
    exact (Bool.beq_eq_decide_eq x c).symm
  rw [hp, ← List.count_eq_countP]
  by_cases h : c ∈ col v
  · simp_all [E, List.count_eq_one_of_mem hn h]
  · simp [List.count_eq_zero.mpr h, E, h]



lemma HX_binary (h : 63 ∣ n) (c : Check n) (v : Var n) : HX c v = 0 ∨ HX c v = 1 := by
  rw [HX_count]
  have hn := col_nodup h v
  have hp : (fun x : Check n => decide (x = c)) = (fun x => x == c) := by
    funext x; exact (Bool.beq_eq_decide_eq x c).symm
  rw [hp,← List.count_eq_countP]
  have hl := List.nodup_iff_count_le_one.mp hn c
  omega

lemma HZ_row_count (v : Var n) : HZ (0,0) v = sixList.countP (· = v) := by
  rcases v with ⟨b,j,f⟩
  cases b
  · simp only [HZ,B,P_transpose,sixList,Bool.false_eq_true,↓reduceIte,
      List.countP_cons,List.countP_nil,decide_eq_true_eq,Prod.mk.injEq,zero_sub,sub_zero]
    by_cases h : j = 0
    · subst j; simp [eq_comm,add_comm,add_left_comm,add_assoc]
    · have h' : (0:ZMod 7) ≠ j := Ne.symm h
      simp [h,h']
  · simp only [HZ,A,P,sixList,↓reduceIte,List.countP_cons,List.countP_nil,
      decide_eq_true_eq,Prod.mk.injEq,zero_add]
    by_cases h0 : j = 0 <;> by_cases h1 : j = 1 <;> by_cases h2 : j = 2 <;>
      simp_all +decide [eq_comm,add_comm,add_left_comm,add_assoc]

lemma sixList_nodup (h : 63 ∣ n) : (@sixList n).Nodup := by
  apply List.Nodup.of_map (projV h)
  rw [project_sixList]
  decide +kernel

/-- The upper witness is the actual companion-check row, not an arbitrary kernel vector. -/
theorem six_is_HZ_row (h : 63 ∣ n) (v : Var n) : v ∈ six ↔ HZ (0,0) v = 1 := by
  rw [HZ_row_count]
  have hp : (fun x : Var n => decide (x = v)) = (fun x => x == v) := by
    funext x; exact (Bool.beq_eq_decide_eq x v).symm
  rw [hp,← List.count_eq_countP]
  by_cases hm : v ∈ (@sixList n)
  · simp [six,hm,List.count_eq_one_of_mem (sixList_nodup h) hm]
  · simp [six,hm,List.count_eq_zero.mpr hm]

end Incidence.Family
