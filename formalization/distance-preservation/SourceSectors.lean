import SourceModel
set_option maxHeartbeats 0
namespace SourceModel
variable {L : Nat} [NeZero L]
open FamilyWords

def transpose {n : Nat} (u : Fin n → Fin n → ZMod L → ZMod 2) := fun i j s => u j i s

theorem x_action (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) (j : Fin 4) (t : ZMod L) :
    (∑ q, HX ((i,j),t) q * join u v q) = Syndrome (transpose u) (transpose v) j i t := by
  rw [Fintype.sum_sum_type]
  simp only [Fintype.sum_prod_type,HX,join]
  simp_rw [ite_mul,zero_mul]
  simp only [Finset.sum_ite_irrel,Finset.sum_const_zero]
  simp_rw [P_action]
  simp [Syndrome,transpose,sub_neg_eq_add]

theorem z_span_left (w : Fin 4 → Fin 3 → ZMod L → ZMod 2)
    (i j : Fin 4) (s : ZMod L) :
    (∑ c : ZCheck L, w c.1.1 c.1.2 c.2 * HZ c (.inl ((i,j),s))) =
      stabilizerLeft (fun a b t => w b a t) j i s := by
  simp only [Fintype.sum_prod_type,HZ]
  simp_rw [mul_ite,mul_zero]
  simp [P,stabilizerLeft]

theorem z_span_right (w : Fin 4 → Fin 3 → ZMod L → ZMod 2)
    (i j : Fin 3) (s : ZMod L) :
    (∑ c : ZCheck L, w c.1.1 c.1.2 c.2 * HZ c (.inr ((i,j),s))) =
      stabilizerRight (fun a b t => w b a t) j i s := by
  simp only [Fintype.sum_prod_type,HZ]
  simp_rw [mul_ite,mul_zero]
  simp [P,stabilizerRight,sub_eq_add_neg]

def InSpanX (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  ∃ w : XCheck L → ZMod 2, ∀ q, join u v q = ∑ c, w c * HX c q

def InSpanZ (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  ∃ w : ZCheck L → ZMod 2, ∀ q, join u v q = ∑ c, w c * HZ c q

theorem inSpanX_iff (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    InSpanX u v ↔ ∃ w, u = stabilizerLeft w ∧ v = stabilizerRight w := by
  constructor
  · rintro ⟨w,hw⟩
    refine ⟨(fun i j s => w ((i,j),s)),?_,?_⟩
    · funext i j s
      exact (hw (.inl ((i,j),s))).trans (x_span_left (fun a b t => w ((a,b),t)) i j s)
    · funext i j s
      exact (hw (.inr ((i,j),s))).trans (x_span_right (fun a b t => w ((a,b),t)) i j s)
  · rintro ⟨w,rfl,rfl⟩
    refine ⟨(fun c => w c.1.1 c.1.2 c.2),?_⟩
    intro q
    cases q with
    | inl p => rcases p with ⟨⟨i,j⟩,s⟩; exact (x_span_left w i j s).symm
    | inr p => rcases p with ⟨⟨i,j⟩,s⟩; exact (x_span_right w i j s).symm

theorem inSpanZ_iff (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    InSpanZ u v ↔ ∃ w, transpose u = stabilizerLeft w ∧ transpose v = stabilizerRight w := by
  constructor
  · rintro ⟨w,hw⟩
    refine ⟨(fun i j s => w ((j,i),s)),?_,?_⟩
    · funext i j s
      exact (hw (.inl ((j,i),s))).trans (z_span_left (fun a b t => w ((a,b),t)) j i s)
    · funext i j s
      exact (hw (.inr ((j,i),s))).trans (z_span_right (fun a b t => w ((a,b),t)) j i s)
  · rintro ⟨w,hu,hv⟩
    refine ⟨(fun c => w c.1.2 c.1.1 c.2),?_⟩
    intro q
    cases q with
    | inl p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      have h := congrFun (congrFun (congrFun hu j) i) s
      exact h.trans (z_span_left (fun a b t => w b a t) i j s).symm
    | inr p =>
      rcases p with ⟨⟨i,j⟩,s⟩
      have h := congrFun (congrFun (congrFun hv j) i) s
      exact h.trans (z_span_right (fun a b t => w b a t) i j s).symm

#print axioms x_action
#print axioms z_span_left
#print axioms z_span_right
#print axioms inSpanX_iff
#print axioms inSpanZ_iff
end SourceModel
