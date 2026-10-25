import SourceModel
set_option maxHeartbeats 0
namespace GeneralLP
variable {L : Nat} [NeZero L]
open FamilyWords
abbrev XCheck (L : Nat) := SourceModel.XCheck L
abbrev ZCheck (L : Nat) := SourceModel.ZCheck L
abbrev P := SourceModel.P (L := L)
abbrev join := SourceModel.join (L := L)

def HX (e : Fin 3 → Fin 4 → ZMod L) (c : XCheck L) (q : Qubit L) : ZMod 2 := match q with
  | .inl ((i,j),s) => if c.1.2=j then P (e c.1.1 i) c.2 s else 0
  | .inr ((i,j),s) => if c.1.1=i then P (-e j c.1.2) c.2 s else 0

def HZ (e : Fin 3 → Fin 4 → ZMod L) (c : ZCheck L) (q : Qubit L) : ZMod 2 := match q with
  | .inl ((i,j),s) => if c.1.1=i then P (e c.1.2 j) c.2 s else 0
  | .inr ((i,j),s) => if c.1.2=j then P (-e i c.1.1) c.2 s else 0

def Syndrome (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (j : Fin 4) (i : Fin 3) (t : ZMod L) : ZMod 2 :=
  (∑ k : Fin 4, u j k (t-e i k)) + (∑ l : Fin 3, v l i (t+e l j))

def stabilizerLeft (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 4) (s : ZMod L) : ZMod 2 :=
  ∑ k : Fin 3, w k j (s+e k i)

def stabilizerRight (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 3) (s : ZMod L) : ZMod 2 :=
  ∑ k : Fin 4, w i k (s-e j k)

theorem z_action (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    (∑ q, HZ e ((j,i),t) q * join u v q) = Syndrome e u v j i t := by
  rw [Fintype.sum_sum_type]
  simp only [Fintype.sum_prod_type,HZ,join,SourceModel.join]
  simp_rw [ite_mul,zero_mul]
  simp only [Finset.sum_ite_irrel,Finset.sum_const_zero]
  simp_rw [SourceModel.P_action]
  simp [Syndrome,sub_neg_eq_add]

theorem x_span_left (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 4) (s : ZMod L) :
    (∑ c : XCheck L, w c.1.1 c.1.2 c.2 * HX e c (.inl ((i,j),s))) = stabilizerLeft e w i j s := by
  simp only [Fintype.sum_prod_type,HX]
  simp_rw [mul_ite,mul_zero]
  simp [P,SourceModel.P,stabilizerLeft]

theorem x_span_right (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 3) (s : ZMod L) :
    (∑ c : XCheck L, w c.1.1 c.1.2 c.2 * HX e c (.inr ((i,j),s))) = stabilizerRight e w i j s := by
  simp only [Fintype.sum_prod_type,HX]
  simp_rw [mul_ite,mul_zero]
  simp [P,SourceModel.P,stabilizerRight,sub_eq_add_neg]

theorem coefficient_commutation (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    Syndrome e (stabilizerLeft e w) (stabilizerRight e w) j i t=0 := by
  unfold Syndrome stabilizerLeft stabilizerRight
  simp_rw [sub_add_eq_add_sub]
  rw [Finset.sum_comm]
  exact CharTwo.add_self_eq_zero _

def InSpanX (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  ∃ w : XCheck L → ZMod 2, ∀ q, join u v q=∑ c, w c*HX e c q

def LogicalX (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  (∀ c : ZCheck L, ∑ q, HZ e c q*join u v q=0) ∧ ¬ InSpanX e u v

theorem augmentation_stabilizer (e : Fin 3 → Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) :
    FamilyWords.augmentation (stabilizerLeft e w)=0 := by
  have h (i : Fin 4) : (∑ s, stabilizerLeft e w i 0 s)=∑ k, ∑ s, w k 0 s := by
    unfold stabilizerLeft
    rw [Finset.sum_comm]
    simp_rw [FamilyWords.sum_shift]
  unfold FamilyWords.augmentation
  rw [h 0,h 1]
  exact CharTwo.add_self_eq_zero _

theorem full_span_left (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (h : InSpanX e u v) : ∃ w, u=stabilizerLeft e w := by
  obtain ⟨w,hw⟩ := h
  refine ⟨(fun i j s => w ((i,j),s)),?_⟩
  funext i j s
  exact (hw (.inl ((i,j),s))).trans (x_span_left e (fun a b t => w ((a,b),t)) i j s)

#print axioms z_action
#print axioms coefficient_commutation
#print axioms augmentation_stabilizer
#print axioms full_span_left
end GeneralLP
