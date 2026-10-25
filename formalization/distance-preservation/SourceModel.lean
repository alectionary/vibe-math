import FamilyWords
import CoverWeight

set_option maxHeartbeats 0
namespace SourceModel
variable {L : Nat} [NeZero L]
open FamilyWords
abbrev XCheck (L : Nat) := (Fin 3 × Fin 4) × ZMod L
abbrev ZCheck (L : Nat) := (Fin 4 × Fin 3) × ZMod L
/-- P^e(t,s)=1 exactly when t=s+e. -/
def P (e t s : ZMod L) : ZMod 2 := if t = s+e then 1 else 0
/-- Coefficients of [B tensor I4 | I3 tensor B*], equation (9). -/
def HX (c : XCheck L) (q : Qubit L) : ZMod 2 := match q with
  | .inl ((i,j),s) => if c.1.2 = j then P (exponent c.1.1 i) c.2 s else 0
  | .inr ((i,j),s) => if c.1.1 = i then P (-(exponent j c.1.2)) c.2 s else 0
/-- Coefficients of [I4 tensor B | B* tensor I3], equation (9). -/
def HZ (c : ZCheck L) (q : Qubit L) : ZMod 2 := match q with
  | .inl ((i,j),s) => if c.1.1 = i then P (exponent c.1.2 j) c.2 s else 0
  | .inr ((i,j),s) => if c.1.2 = j then P (-(exponent i c.1.1)) c.2 s else 0

def join (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (q : Qubit L) : ZMod 2 :=
  match q with | .inl ((i,j),s) => u i j s | .inr ((i,j),s) => v i j s

theorem P_action (e t : ZMod L) (f : ZMod L → ZMod 2) :
    (∑ s, P e t s * f s) = f (t-e) := by
  have h : ∀ s, t=s+e ↔ s=t-e := by
    intro s
    constructor
    · intro h; exact eq_sub_iff_add_eq.mpr h.symm
    · intro h; exact (eq_sub_iff_add_eq.mp h).symm
  simp [P,h]

theorem z_action (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    (∑ q, HZ ((j,i),t) q * join u v q) = Syndrome u v j i t := by
  rw [Fintype.sum_sum_type]
  simp only [Fintype.sum_prod_type,HZ,join]
  simp_rw [ite_mul,zero_mul]
  simp only [Finset.sum_ite_irrel,Finset.sum_const_zero,ite_true]
  simp_rw [P_action]
  simp [Syndrome,sub_neg_eq_add]

theorem x_span_left (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (i j : Fin 4) (s : ZMod L) :
    (∑ c : XCheck L, w c.1.1 c.1.2 c.2 * HX c (.inl ((i,j),s))) = stabilizerLeft w i j s := by
  simp only [Fintype.sum_prod_type,HX]
  simp_rw [mul_ite,mul_zero]
  simp [P,stabilizerLeft]

theorem x_span_right (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (i j : Fin 3) (s : ZMod L) :
    (∑ c : XCheck L, w c.1.1 c.1.2 c.2 * HX c (.inr ((i,j),s))) = stabilizerRight w i j s := by
  simp only [Fintype.sum_prod_type,HX]
  simp_rw [mul_ite,mul_zero]
  simp [P,stabilizerRight,sub_eq_add_neg]

#print axioms z_action
#print axioms x_span_left
#print axioms x_span_right
end SourceModel
