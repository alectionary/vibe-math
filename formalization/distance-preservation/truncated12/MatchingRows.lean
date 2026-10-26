import KernelCatalog
import ActualIncidence
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog

variable {A : Type*} [AddCommGroup A]
def prefixSix {w : ℕ} (x : Fin (w+6) → A) (k : Fin 6) : A := x ⟨k.val,by omega⟩
def extendSix (w : ℕ) (a : Fin 6 → Int) (j : Fin (w+6)) : Int :=
  if h : j.val<6 then a ⟨j.val,h⟩ else 0
def fiberIndex {w : ℕ} (v : Fin w) : Fin (w+6) := ⟨6+v.val,by omega⟩
def fiberBasis (w : ℕ) (v : Fin w) (j : Fin (w+6)) : Int :=
  if j.val=6+v.val then 1 else 0

theorem integerDot_add {n : ℕ} (a b : Fin n → Int) (x : Fin n → A) :
    integerDot (fun j => a j+b j) x=integerDot a x+integerDot b x := by
  simp [integerDot,add_zsmul,Finset.sum_add_distrib]
theorem integerDot_sub {n : ℕ} (a b : Fin n → Int) (x : Fin n → A) :
    integerDot (fun j => a j-b j) x=integerDot a x-integerDot b x := by
  unfold integerDot
  simp only [sub_zsmul]
  simp only [Finset.sum_add_distrib,Finset.sum_neg_distrib,sub_eq_add_neg]
theorem integerDot_neg {n : ℕ} (a : Fin n → Int) (x : Fin n → A) :
    integerDot (fun j => -a j) x= -integerDot a x := by
  simp [integerDot]

theorem dot_extendSix (w : ℕ) (a : Fin 6 → Int) (x : Fin (w+6) → A) :
    integerDot (extendSix w a) x=integerDot a (prefixSix x) := by
  classical
  unfold integerDot
  calc
    _ = ∑ j ∈ Finset.univ.filter (fun j : Fin (w+6) => j.val<6),extendSix w a j • x j := by
      symm
      apply Finset.sum_subset (Finset.filter_subset _ _)
      intro j hj hn
      have hnot : ¬j.val<6 := fun h => hn (Finset.mem_filter.mpr ⟨hj,h⟩)
      simp [extendSix,hnot]
    _ = _ := by
      refine Finset.sum_bij (fun j hj => (⟨j.val,(Finset.mem_filter.mp hj).2⟩ : Fin 6)) ?_ ?_ ?_ ?_
      · intro j hj;exact Finset.mem_univ _
      · intro j hj k hk he
        apply Fin.ext
        exact congrArg (fun z : Fin 6 => z.val) he
      · intro k hk
        refine ⟨⟨k.val,by omega⟩,Finset.mem_filter.mpr ⟨Finset.mem_univ _,k.isLt⟩,?_⟩
        exact Fin.ext rfl
      · intro j hj
        simp only [extendSix,dif_pos (Finset.mem_filter.mp hj).2]
        rfl

theorem dot_fiberBasis (w : ℕ) (v : Fin w) (x : Fin (w+6) → A) :
    integerDot (fiberBasis w v) x=x (fiberIndex v) := by
  have he (j : Fin (w+6)) : j.val=6+v.val ↔ j=fiberIndex v := by
    constructor
    · intro h;exact Fin.ext h
    · intro h;exact congrArg Fin.val h
  simp [integerDot,fiberBasis,he,ite_smul]

theorem matching_row_dot (w p : ℕ) (r : Fin 18) (hr : r.val<edgeCount w)
    (ha : (edge w p r.val).a<w) (hb : (edge w p r.val).b<w)
    (x : Fin (w+6) → A) :
    integerDot (sourceRow w p r) x=
      integerDot (fun k : Fin 6 =>
        offsetCoefficient (vertex w p (edge w p r.val).a) (edge w p r.val).j (edge w p r.val).i k.val-
        offsetCoefficient (vertex w p (edge w p r.val).b) (edge w p r.val).j (edge w p r.val).i k.val)
        (prefixSix x)+x (fiberIndex ⟨(edge w p r.val).a,ha⟩)-x (fiberIndex ⟨(edge w p r.val).b,hb⟩) := by
  let a : Fin w := ⟨(edge w p r.val).a,ha⟩
  let b : Fin w := ⟨(edge w p r.val).b,hb⟩
  let off := fun k : Fin 6 =>
    offsetCoefficient (vertex w p (edge w p r.val).a) (edge w p r.val).j (edge w p r.val).i k.val-
    offsetCoefficient (vertex w p (edge w p r.val).b) (edge w p r.val).j (edge w p r.val).i k.val
  have hrow : sourceRow w p r=fun j => extendSix w off j+fiberBasis w a j-fiberBasis w b j := by
    funext j
    by_cases hj : j.val<6
    · have hja : j.val≠6+(edge w p r.val).a := by omega
      have hjb : j.val≠6+(edge w p r.val).b := by omega
      simp [sourceRow,hr,extendSix,fiberBasis,hj,hja,hjb,a,b,off]
    · simp [sourceRow,hr,extendSix,fiberBasis,hj,a,b]
  rw [hrow,integerDot_sub,integerDot_add,dot_extendSix,dot_fiberBasis,dot_fiberBasis]

variable {L : ℕ} [NeZero L]
def sourceExponents (e : Fin 3 → Fin 4 → ZMod L) : Fin 6 → ZMod L :=
  ![e 1 1,e 1 2,e 1 3,e 2 1,e 2 2,e 2 3]
def qubitFiber : Qubit L → ZMod L
  | .inl (_,s) => s
  | .inr (_,s) => s
def qubitOffset (e : Fin 3 → Fin 4 → ZMod L) (q : Qubit L) (j : Fin 4) (i : Fin 3) : ZMod L :=
  match q with
  | .inl ((_,k),_) => e i k
  | .inr ((l,_),_) => -e l j
def VertexLabel (v : Vertex) (q : Qubit L) : Prop :=
  match q with
  | .inl ((j,k),_) => v.left=true ∧ v.a=j.val ∧ v.b=k.val
  | .inr ((l,i),_) => v.left=false ∧ v.a=l.val ∧ v.b=i.val

theorem source_entry_linearized (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0) (i : Fin 3) (j : Fin 4) :
    integerDot (fun k : Fin 6 => entryCoefficient i.val j.val k.val) (sourceExponents e)=e i j := by
  fin_cases i <;> fin_cases j <;>
    simp [integerDot,entryCoefficient,sourceExponents,Fin.sum_univ_succ,hR0,hC0]

theorem source_offset_linearized (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (v : Vertex) (q : Qubit L) (j : Fin 4) (i : Fin 3) (hl : VertexLabel v q) :
    integerDot (fun k : Fin 6 => offsetCoefficient v j.val i.val k.val) (sourceExponents e)=qubitOffset e q j i := by
  rcases q with ⟨⟨a,b⟩,s⟩|⟨⟨l,h⟩,s⟩
  · obtain ⟨hleft,ha,hb⟩ := hl
    simpa [offsetCoefficient,hleft,hb,qubitOffset] using source_entry_linearized e hR0 hC0 i b
  · obtain ⟨hleft,ha,hb⟩ := hl
    simp only [offsetCoefficient,hleft,Bool.false_eq_true,ite_false,ha,qubitOffset]
    rw [integerDot_neg,source_entry_linearized e hR0 hC0 l j]

theorem source_edge_fiber (e : Fin 3 → Fin 4 → ZMod L) (q : Qubit L)
    (c : SourceModel.ZCheck L) (he : ZEdge e q c) :
    qubitFiber q+qubitOffset e q c.1.1 c.1.2=c.2 := by
  rcases q with ⟨⟨j,k⟩,s⟩|⟨⟨l,i⟩,s⟩
  · exact he.2.symm
  · change s+(-e l c.1.1)=c.2
    have h : s=c.2+e l c.1.1 := he.2
    linear_combination h

/-- An actual pair of source incidences supplies the full integer matching row,
including its fiber columns. No abstract graph equation is substituted. -/
theorem actual_matching_row_zero (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (w p : ℕ) (r : Fin 18) (hr : r.val<edgeCount w)
    (ha : (edge w p r.val).a<w) (hb : (edge w p r.val).b<w)
    (q₁ q₂ : Qubit L) (c : SourceModel.ZCheck L)
    (hj : (edge w p r.val).j=c.1.1.val) (hi : (edge w p r.val).i=c.1.2.val)
    (hl₁ : VertexLabel (vertex w p (edge w p r.val).a) q₁)
    (hl₂ : VertexLabel (vertex w p (edge w p r.val).b) q₂)
    (he₁ : ZEdge e q₁ c) (he₂ : ZEdge e q₂ c)
    (x : Fin (w+6) → ZMod L) (hx : prefixSix x=sourceExponents e)
    (hx₁ : x (fiberIndex ⟨(edge w p r.val).a,ha⟩)=qubitFiber q₁)
    (hx₂ : x (fiberIndex ⟨(edge w p r.val).b,hb⟩)=qubitFiber q₂) :
    integerDot (sourceRow w p r) x=0 := by
  rw [matching_row_dot w p r hr ha hb x,hx,integerDot_sub,hj,hi]
  rw [source_offset_linearized e hR0 hC0 _ q₁ _ _ hl₁,
    source_offset_linearized e hR0 hC0 _ q₂ _ _ hl₂,hx₁,hx₂]
  have h₁ := source_edge_fiber e q₁ c he₁
  have h₂ := source_edge_fiber e q₂ c he₂
  linear_combination h₁-h₂

#print axioms actual_matching_row_zero
end TruncatedDistance
