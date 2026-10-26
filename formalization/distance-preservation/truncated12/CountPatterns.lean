import Mathlib.Tactic
set_option maxHeartbeats 0
namespace TruncatedDistance

/-- Descending counts of one parity with a fixed length and total budget. -/
def descendingCounts : ℕ → ℕ → ℕ → ℕ → List (List ℕ)
  | 0,_,_,_ => [[]]
  | n+1,top,budget,p => (List.range (min top budget+1)).flatMap fun x =>
      if x%2=p then (descendingCounts n x (budget-x) p).map (x :: ·) else []

theorem mem_descendingCounts (xs : List ℕ) (n top budget p : ℕ)
    (hlen : xs.length=n) (hdesc : xs.Pairwise (· ≥ ·))
    (hbound : ∀ x∈xs, x≤top) (hpar : ∀ x∈xs, x%2=p)
    (hsum : xs.sum≤budget) : xs∈descendingCounts n top budget p := by
  induction xs generalizing n top budget with
  | nil =>
    have hn : n=0 := by simpa using hlen.symm
    subst n
    simp [descendingCounts]
  | cons x xs ih =>
    cases n with
    | zero => simp at hlen
    | succ n =>
      have hlen' : xs.length=n := by simpa using hlen
      have hd := List.pairwise_cons.mp hdesc
      have hx : x≤top := hbound x (by simp)
      have hxb : x≤budget := by simp only [List.sum_cons] at hsum; omega
      have hp : x%2=p := hpar x (by simp)
      have hm : x∈List.range (min top budget+1) := by
        simp only [List.mem_range]
        omega
      simp only [descendingCounts,List.mem_flatMap]
      refine ⟨x,hm,?_⟩
      rw [if_pos hp]
      apply List.mem_map.mpr
      refine ⟨xs,ih n x (budget-x) hlen' hd.2 hd.1 ?_ ?_,rfl⟩
      · intro y hy
        exact hpar y (by simp [hy])
      · simp only [List.sum_cons] at hsum
        omega

def countCases : List (List ℕ × List ℕ) :=
  (List.range 2).flatMap fun p =>
    ((descendingCounts 4 11 11 p).product (descendingCounts 3 11 11 p)).filter
      (fun ab => decide (0<ab.1.sum ∧ 0<ab.2.sum ∧ ab.1.sum+ab.2.sum≤11))

def localMantel (ab : List ℕ × List ℕ) : Bool :=
  (ab.1.all fun a => decide ((ab.2.map (fun b => (a-b)/2)).sum≤a*a/4)) &&
  (ab.2.all fun b => decide ((ab.1.map (fun a => (b-a)/2)).sum≤b*b/4))

def acceptedCounts (ab : List ℕ × List ℕ) : Bool := decide
  (ab=([1,1,1,1],[1,1,1]) ∨ ab=([2,2,2,0],[2,2,0]) ∨
   ab=([5,1,1,1],[1,1,1]))

theorem mem_countCases (a b : List ℕ) (p : ℕ) (hp : p<2)
    (ha : a.length=4) (hb : b.length=3)
    (had : a.Pairwise (· ≥ ·)) (hbd : b.Pairwise (· ≥ ·))
    (hab : ∀ x∈a, x≤11) (hbb : ∀ x∈b, x≤11)
    (hap : ∀ x∈a, x%2=p) (hbp : ∀ x∈b, x%2=p)
    (hapos : 0<a.sum) (hbpos : 0<b.sum) (hs : a.sum+b.sum≤11) :
    (a,b)∈countCases := by
  have hma := mem_descendingCounts a 4 11 11 p ha had hab hap (by omega)
  have hmb := mem_descendingCounts b 3 11 11 p hb hbd hbb hbp (by omega)
  simp only [countCases,List.mem_flatMap]
  refine ⟨p,List.mem_range.mpr hp,?_⟩
  simp only [List.mem_filter,decide_eq_true_eq]
  exact ⟨List.mem_product.mpr ⟨hma,hmb⟩,hapos,hbpos,hs⟩

theorem count_cases_length : countCases.length=44 := by decide +kernel

/-- The finite arithmetic classification is checked by the Lean kernel.
Local Mantel inequalities must still be proved for a concrete source support. -/
theorem count_cases_checked :
    countCases.all (fun ab => !localMantel ab || acceptedCounts ab)=true := by
  decide +kernel

theorem classified_of_mem_countCases (ab : List ℕ × List ℕ)
    (hm : ab∈countCases) (hM : localMantel ab=true) :
    ab=([1,1,1,1],[1,1,1]) ∨ ab=([2,2,2,0],[2,2,0]) ∨
      ab=([5,1,1,1],[1,1,1]) := by
  have h := List.all_eq_true.mp count_cases_checked ab hm
  simpa [hM,acceptedCounts] using h

#print axioms mem_descendingCounts
#print axioms count_cases_checked
#print axioms classified_of_mem_countCases
end TruncatedDistance
