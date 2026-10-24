import PaschLiftCriterion
import PaschKernelCount

set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace FanoCarryCertificate
open FourColumnClassification

def base (v : Fin 7) : Finset (Fin 7) :=
  match v.val with
  | 0 => {0,4,6}
  | 1 => {0,1,5}
  | 2 => {1,2,6}
  | 3 => {0,2,3}
  | 4 => {1,3,4}
  | 5 => {2,4,5}
  | _ => {3,5,6}

def representatives : Finset (Finset (Fin 7)) :=
  {{0,1,2,5},{0,1,4,6},{0,2,3,4},{0,3,5,6},{1,2,3,6},{1,3,4,5},{2,4,5,6}}

theorem cubic : ∀ v, (base v).card=3 := by decide
theorem linear : ∀ u v, u≠v → (base u ∩ base v).card≤1 := by decide

/-- All unordered four-supports, not just a proposed list of witnesses. -/
theorem complete_list :
    ((GlobalCounting.fourSupports : Finset (Finset (Fin 7))).filter
      (PaschKernelCount.elementary40Check base))=representatives := by decide

def variableAt (r : Fin 7) (i : Fin 4) : Fin 7 :=
  match r.val,i.val with
  | 0,0 => 0
  | 0,1 => 1
  | 0,2 => 2
  | 0,3 => 5
  | 1,0 => 0
  | 1,1 => 1
  | 1,2 => 4
  | 1,3 => 6
  | 2,0 => 0
  | 2,1 => 2
  | 2,2 => 3
  | 2,3 => 4
  | 3,0 => 0
  | 3,1 => 3
  | 3,2 => 5
  | 3,3 => 6
  | 4,0 => 1
  | 4,1 => 2
  | 4,2 => 3
  | 4,3 => 6
  | 5,0 => 1
  | 5,1 => 3
  | 5,2 => 4
  | 5,3 => 5
  | 6,0 => 2
  | 6,1 => 4
  | 6,2 => 5
  | 6,3 => 6
  | _,_ => 0

def checks (r : Fin 7) (e : Fin 6) : Fin 7 :=
  match r.val,e.val with
  | 0,0 => 0
  | 0,1 => 6
  | 0,2 => 4
  | 0,3 => 1
  | 0,4 => 5
  | 0,5 => 2
  | 1,0 => 0
  | 1,1 => 4
  | 1,2 => 6
  | 1,3 => 1
  | 1,4 => 5
  | 1,5 => 3
  | 2,0 => 6
  | 2,1 => 0
  | 2,2 => 4
  | 2,3 => 2
  | 2,4 => 1
  | 2,5 => 3
  | 3,0 => 0
  | 3,1 => 4
  | 3,2 => 6
  | 3,3 => 2
  | 3,4 => 3
  | 3,5 => 5
  | 4,0 => 1
  | 4,1 => 0
  | 4,2 => 5
  | 4,3 => 2
  | 4,4 => 6
  | 4,5 => 3
  | 5,0 => 0
  | 5,1 => 1
  | 5,2 => 5
  | 5,3 => 3
  | 5,4 => 2
  | 5,5 => 4
  | 6,0 => 1
  | 6,1 => 2
  | 6,2 => 6
  | 6,3 => 4
  | 6,4 => 3
  | 6,5 => 5
  | _,_ => 0

def carry (v c : Fin 7) : ℤ :=
  if (v=0 ∧ (c=4 ∨ c=6)) ∨ (v=1 ∧ c=5) ∨ (v=2 ∧ c=6) then -1 else 0

def localBase (r : Fin 7) (i : Fin 4) := base (variableAt r i)
def localLabels (r : Fin 7) (i : Fin 4) (c : Fin 7) := carry (variableAt r i) c

theorem representatives_injective : ∀ r, Function.Injective (variableAt r) := by decide

theorem pair_checks : ∀ r,
    localBase r 0 ∩ localBase r 1={checks r 0} ∧
    localBase r 0 ∩ localBase r 2={checks r 1} ∧
    localBase r 0 ∩ localBase r 3={checks r 2} ∧
    localBase r 1 ∩ localBase r 2={checks r 3} ∧
    localBase r 1 ∩ localBase r 3={checks r 4} ∧
    localBase r 2 ∩ localBase r 3={checks r 5} := by decide

def d (r : Fin 7) := PaschLiftCriterion.differences (localLabels r) (checks r)

def residuals (r : Fin 7) : Fin 3 → ℤ := fun i => match i.val with
  | 0 => d r 0+d r 3-d r 1
  | 1 => d r 0+d r 4-d r 2
  | _ => d r 1+d r 5-d r 2

/-- A literal integer unit occurs for every one of the seven representatives.
Modulo every q>=2 it stays nonzero, so that representative is unbalanced. -/
theorem unit_cycle_for_every_representative : ∀ r, ∃ i, residuals r i=1 := by decide

def modLabels (q : ℕ) (r : Fin 7) (i : Fin 4) (c : Fin 7) : ZMod q :=
  (localLabels r i c : ZMod q)

theorem difference_cast (q : ℕ) (r : Fin 7) (e : Fin 6) :
    PaschLiftCriterion.differences (modLabels q r) (checks r) e=(d r e : ZMod q) := by
  fin_cases e <;> simp [PaschLiftCriterion.differences,modLabels,d]

/-- Every canonical Fano Pasch is killed in every q-fold carry lift, q>=2. -/
theorem every_representative_unbalanced (q : ℕ) (hq : 2≤q) (r : Fin 7) :
    ¬ PaschVoltage.Balanced (PaschLiftCriterion.differences (modLabels q r) (checks r)) := by
  intro h
  have h1 : (d r 0 : ZMod q)+(d r 3 : ZMod q)=(d r 1 : ZMod q) := by
    simpa only [difference_cast] using h.1
  have h2 : (d r 0 : ZMod q)+(d r 4 : ZMod q)=(d r 2 : ZMod q) := by
    simpa only [difference_cast] using h.2.1
  have h3 : (d r 1 : ZMod q)+(d r 5 : ZMod q)=(d r 2 : ZMod q) := by
    simpa only [difference_cast] using h.2.2
  have hz : ∀ i, (residuals r i : ZMod q)=0 := by
    intro i
    fin_cases i
    · simp only [residuals,Int.cast_sub,Int.cast_add]
      exact sub_eq_zero.mpr h1
    · simp only [residuals,Int.cast_sub,Int.cast_add]
      exact sub_eq_zero.mpr h2
    · simp only [residuals,Int.cast_sub,Int.cast_add]
      exact sub_eq_zero.mpr h3
  obtain ⟨i,hi⟩ := unit_cycle_for_every_representative r
  have hone : (1 : ZMod q)=0 := by simpa only [hi,Int.cast_one] using hz i
  have hdvd : q∣1 := (ZMod.natCast_eq_zero_iff 1 q).mp (by simpa only [Nat.cast_one] using hone)
  have := Nat.dvd_one.mp hdvd
  omega

#print axioms cubic
#print axioms linear
#print axioms complete_list
#print axioms representatives_injective
#print axioms pair_checks
#print axioms unit_cycle_for_every_representative
#print axioms every_representative_unbalanced
end FanoCarryCertificate
