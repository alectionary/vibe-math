module

public import CyclicLift
public import Mathlib.Combinatorics.SimpleGraph.Walk.Counting

@[expose] public section

open CyclicLift
namespace DyadicForbidden

set_option backward.isDefEq.respectTransparency.types false

variable {V A : Type*} [AddCommGroup A]

/-- Explicit vertex/fiber trace obtained by accumulating oriented base labels. -/
def trace (L : VoltageGraph V A) {u v : V} (p : L.base.Walk u v) (a : A) : List (V × A) :=
  match p with
  | .nil => [(u,a)]
  | .cons' u v _ _ q => (u,a) :: trace L q (a + L.voltage u v)

/-- Construct the actual native walk whose vertices are recorded by `trace`. -/
def liftedWalk (L : VoltageGraph V A) {u v : V} (p : L.base.Walk u v) (a : A) :
    L.lift.Walk (u,a) (v,a + L.displacement p) :=
  match p with
  | .nil' u => (.nil : L.lift.Walk (u,a) (u,a)).copy rfl (by simp)
  | .cons' u v w h q =>
    (SimpleGraph.Walk.cons (show L.lift.Adj (u,a) (v,a+L.voltage u v) from ⟨h,rfl⟩)
      (liftedWalk L q (a+L.voltage u v))).copy rfl (by simp [add_assoc])

theorem liftedWalk_support (L : VoltageGraph V A) {u v : V} (p : L.base.Walk u v) (a : A) :
    (liftedWalk L p a).support = trace L p a := by
  induction p generalizing a with
  | nil => simp only [liftedWalk, SimpleGraph.Walk.support_copy, SimpleGraph.Walk.support_nil, trace]
  | @cons u v w h p ih =>
    change ((SimpleGraph.Walk.cons _ (liftedWalk L p (a+L.voltage u v))).copy _ _).support =
      (u,a) :: trace L p (a+L.voltage u v)
    rw [SimpleGraph.Walk.support_copy,SimpleGraph.Walk.support_cons,ih]

theorem liftedWalk_length (L : VoltageGraph V A) {u v : V} (p : L.base.Walk u v) (a : A) :
    (liftedWalk L p a).length = p.length := by
  induction p generalizing a with
  | nil => simp only [liftedWalk, SimpleGraph.Walk.length_copy, SimpleGraph.Walk.length_nil]
  | @cons u v w h p ih =>
    change ((SimpleGraph.Walk.cons _ (liftedWalk L p (a+L.voltage u v))).copy _ _).length = p.length+1
    rw [SimpleGraph.Walk.length_copy,SimpleGraph.Walk.length_cons,ih]

/-- Projecting any native lifted walk and accumulating its labels recovers
its complete vertex trace, not just its final fiber. -/
theorem trace_project (L : VoltageGraph V A) {x y : V × A} (q : L.lift.Walk x y) :
    trace L (q.map L.projection) x.2 = q.support := by
  induction q with
  | nil => rfl
  | @cons x y z h q ih =>
    change x :: trace L (q.map L.projection) (x.2 + L.voltage x.1 y.1) = x :: q.support
    rw [← h.2, ih]

/-- Translation of the initial fiber translates every vertex's fiber. -/
theorem trace_shift (L : VoltageGraph V A) {u v : V} (p : L.base.Walk u v) (a b : A) :
    trace L p (a+b) = (trace L p b).map (fun x => (x.1,a+x.2)) := by
  induction p generalizing b with
  | nil => rfl
  | @cons u v w h p ih =>
    change (u,a+b) :: trace L p (a+b+L.voltage u v) =
      (u,a+b) :: (trace L p (b+L.voltage u v)).map (fun x => (x.1,a+x.2))
    rw [add_assoc, ih]

theorem trace_tail_nodup_zero_iff (L : VoltageGraph V A) {u v : V}
    (p : L.base.Walk u v) (a : A) :
    (trace L p 0).tail.Nodup ↔ (trace L p a).tail.Nodup := by
  have hi : Function.Injective (fun x : V × A => (x.1,a+x.2)) := by
    rintro ⟨x,b⟩ ⟨y,c⟩ h
    simpa only [Prod.mk.injEq,add_left_cancel_iff] using h
  have ht := trace_shift L p a 0
  simp only [add_zero] at ht
  rw [ht, ← List.map_tail, List.nodup_map_iff hi]

/-- A checkable base-word certificate: zero total voltage, no repeated
vertices in the accumulated trace's tail, and a nondegenerate cycle length.
There is no native lifted-cycle predicate in this definition. -/
def GoodWord (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u) : Prop :=
  L.displacement p = 0 ∧ (trace L p 0).tail.Nodup ∧ 3 ≤ p.length

/-- Exact soundness: a valid voltage/prefix certificate constructs a native simple cycle. -/
theorem goodWord_sound (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u)
    (h : GoodWord L p) (a : A) :
    ∃ q : L.lift.Walk (u,a) (u,a), q.IsCycle ∧ q.length = p.length := by
  let q := liftedWalk L p a
  have he : (u,a+L.displacement p) = (u,a) := by rw [h.1,add_zero]
  refine ⟨q.copy rfl he, ?_, ?_⟩
  · rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
    constructor
    · rw [SimpleGraph.Walk.isPath_def]
      rw [SimpleGraph.Walk.support_tail_of_not_nil]
      · simpa [q, liftedWalk_support] using (trace_tail_nodup_zero_iff L p a).mp h.2.1
      · intro hn
        have hl : (q.copy rfl he).length = 0 := SimpleGraph.Walk.length_eq_zero_iff.mpr hn
        simp only [SimpleGraph.Walk.length_copy] at hl
        have hlen := liftedWalk_length L p a
        change q.length = p.length at hlen
        have hh := h.2.2
        omega
    · simpa [q,liftedWalk_length] using h.2.2
  · simp [q,liftedWalk_length]

/-- Exact completeness: every native lifted simple cycle supplies a valid
base-word certificate. Translation invariance lets the checker use fiber zero. -/
theorem goodWord_complete (L : VoltageGraph V A) {x : V × A}
    (q : L.lift.Walk x x) (hq : q.IsCycle) : GoodWord L (q.map L.projection) := by
  refine ⟨?_, ?_, ?_⟩
  · exact (L.closed_lift_projects_iff (q.map L.projection) x.2).mp ⟨q,rfl⟩
  · apply (trace_tail_nodup_zero_iff L (q.map L.projection) x.2).mpr
    rw [trace_project]
    rw [← SimpleGraph.Walk.support_tail_of_not_nil q hq.not_nil]
    exact hq.isPath_tail.support_nodup
  · rw [SimpleGraph.Walk.length_map L.projection q]
    exact hq.three_le_length

/-- A graph-level bounded-cycle property uses explicit cycles. Acyclic
Mathlib graphs have natural girth zero, which must not count as forbidden. -/
def BoundedCycle {W : Type*} (G : SimpleGraph W) (g : ℕ) : Prop :=
  ∃ u, ∃ q : G.Walk u u, q.IsCycle ∧ q.length ≤ g

/-- The complete base-word procedure. In a finite base graph only finitely
many walks have length at most the fixed bound. -/
def PatternForbidden (L : VoltageGraph V A) (g : ℕ) : Prop :=
  ∃ u, ∃ p : L.base.Walk u u, GoodWord L p ∧ p.length ≤ g

/-- General forbidden-pattern completeness, for every length bound and
additive voltage group. This is not a finite certificate or an assumed
closed-walk-to-simple-cycle implication. -/
theorem forbidden_complete (L : VoltageGraph V A) (g : ℕ) :
    PatternForbidden L g ↔ BoundedCycle L.lift g := by
  constructor
  · rintro ⟨u,p,hp,hg⟩
    obtain ⟨q,hq,hl⟩ := goodWord_sound L p hp 0
    exact ⟨(u,0),q,hq,hl ▸ hg⟩
  · rintro ⟨x,q,hq,hg⟩
    have hh : (q.map L.projection).length ≤ g := (SimpleGraph.Walk.length_map L.projection q).le.trans hg
    exact ⟨L.projection x,q.map L.projection,goodWord_complete L q hq,hh⟩

/-- Exact-length variant: the prefix distinctness test excludes a repeated
shorter cycle even when the final voltage is zero. -/
theorem exact_cycle_complete (L : VoltageGraph V A) (n : ℕ) :
    (∃ u, ∃ p : L.base.Walk u u, GoodWord L p ∧ p.length = n) ↔
    (∃ x, ∃ q : L.lift.Walk x x, q.IsCycle ∧ q.length = n) := by
  constructor
  · rintro ⟨u,p,hp,hl⟩
    obtain ⟨q,hq,hql⟩ := goodWord_sound L p hp 0
    exact ⟨(u,0),q,hq,hql.trans hl⟩
  · rintro ⟨x,q,hq,hl⟩
    have hh := (SimpleGraph.Walk.length_map L.projection q).trans hl
    exact ⟨L.projection x,q.map L.projection,goodWord_complete L q hq,hh⟩

section FiniteChecker
variable [Fintype V] [DecidableEq V] [DecidableEq A]

/-- The computable arithmetic/prefix test; it does not inspect a lifted graph. -/
def wordCheck (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u) : Bool :=
  decide (L.displacement p = 0) && decide (trace L p 0 |>.tail.Nodup) && decide (3 ≤ p.length)

omit [Fintype V] in
@[simp] theorem wordCheck_iff (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u) :
    wordCheck L p = true ↔ GoodWord L p := by
  simp [wordCheck, GoodWord, and_assoc]

/-- A terminating checker enumerating bounded base walks with Mathlib's
finite walk enumeration, rather than enumerating lifted graphs or cycles. -/
def completeCheck (L : VoltageGraph V A) [DecidableRel L.base.Adj] (g : ℕ) : Bool :=
  @decide (∃ u : V, ∃ p ∈ L.base.finsetWalkLengthLT (g+1) u u, wordCheck L p = true)
    (@Fintype.decidableExistsFintype V
      (fun u => ∃ p ∈ L.base.finsetWalkLengthLT (g+1) u u, wordCheck L p = true)
      (fun _u => Finset.decidableExistsAndFinset) inferInstance)

theorem completeCheck_iff_pattern (L : VoltageGraph V A) [DecidableRel L.base.Adj] (g : ℕ) :
    completeCheck L g = true ↔ PatternForbidden L g := by
  simp only [completeCheck,decide_eq_true_eq,
    SimpleGraph.mem_finsetWalkLengthLT_iff,wordCheck_iff]
  constructor
  · rintro ⟨u,p,hlt,hp⟩
    exact ⟨u,p,hp,by omega⟩
  · rintro ⟨u,p,hp,hle⟩
    exact ⟨u,p,by omega,hp⟩

/-- Full algorithm correctness, not just the semantics of an existential
certificate. The base graph and the label group can have arbitrary size. -/
theorem completeCheck_spec (L : VoltageGraph V A) [DecidableRel L.base.Adj] (g : ℕ) :
    completeCheck L g = true ↔ BoundedCycle L.lift g := by
  rw [completeCheck_iff_pattern,forbidden_complete]

end FiniteChecker

section MatrixBridge
variable {X C : Type*}

/-- Binary parity-check matrix of a supported permutation-block array.
Rows are check/fiber pairs; columns are variable/fiber pairs. -/
noncomputable def binaryExpansion (E : X → C → Prop) (s : X → C → A) :
    Matrix (C × A) (X × A) (ZMod 2) := by
  classical
  exact fun c v => if E v.1 c.1 ∧ c.2 = v.2 + s v.1 c.1 then 1 else 0

/-- The proof's voltage graph is precisely the Tanner graph of the binary
matrix, including absent blocks. This bridge has no code-specific premise. -/
theorem lift_eq_binaryTanner (E : X → C → Prop) (s : X → C → A) :
    tannerLift E s = matrixTanner (binaryExpansion E s) := by
  classical
  ext ⟨x,a⟩ ⟨y,b⟩
  cases x <;> cases y <;>
    simp [matrixTanner,binaryExpansion,variable_check_adj,check_variable_adj]

variable [DecidableEq X] [DecidableEq C]

def filled (B : X × C → Option A) (slot : X × C) (a : A) : X × C → Option A :=
  Function.update B slot (some a)

def active (B : X × C → Option A) (v : X) (c : C) : Prop := (B (v,c)).isSome = true

def label (B : X × C → Option A) (v : X) (c : C) : A := (B (v,c)).getD 0

/-- Explicit symbolic forbidden labels for inserting a full permutation block.
All supported bounded words are examined, including multiple occurrences
of the inserted block and any preexisting cycle. -/
def ForbiddenLabels (B : X × C → Option A) (slot : X × C) (g : ℕ) : Set A :=
  {a | PatternForbidden (bipartite (active (filled B slot a)) (label (filled B slot a))) g}

/-- Source-model completeness for partial single-permutation-block arrays.
Specialize A to Fin ell → ZMod 2 for P11's dyadic labels. -/
theorem forbidden_labels_matrix_complete (B : X × C → Option A) (slot : X × C)
    (g : ℕ) (a : A) :
    a ∈ ForbiddenLabels B slot g ↔
    BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
      (label (filled B slot a)))) g := by
  change PatternForbidden _ g ↔ _
  rw [forbidden_complete]
  change BoundedCycle (tannerLift _ _) g ↔ _
  rw [lift_eq_binaryTanner]

/-- Both requested thresholds are covered without dimension restrictions. -/
theorem six_eight_complete (B : X × C → Option A) (slot : X × C) (a : A) :
    (a ∈ ForbiddenLabels B slot 6 ↔
      BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
        (label (filled B slot a)))) 6) ∧
    (a ∈ ForbiddenLabels B slot 8 ↔
      BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
        (label (filled B slot a)))) 8) :=
  ⟨forbidden_labels_matrix_complete B slot 6 a, forbidden_labels_matrix_complete B slot 8 a⟩

/-- Explicitly specialize the group to bit vectors, not cyclic ZMod (2^ell). -/
theorem dyadic_threshold_complete (ell : ℕ)
    (B : X × C → Option (Fin ell → ZMod 2)) (slot : X × C)
    (g : ℕ) (a : Fin ell → ZMod 2) :
    a ∈ ForbiddenLabels B slot g ↔
    BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
      (label (filled B slot a)))) g :=
  forbidden_labels_matrix_complete B slot g a

instance decidableBipartiteBase (E : X → C → Prop) [DecidableRel E] :
    DecidableRel (bipartiteBase E).Adj := by
  intro x y
  cases x <;> cases y <;> dsimp [bipartiteBase] <;> infer_instance

variable [Fintype X] [Fintype C] [DecidableEq A]

/-- Executable candidate-label checker for partial permutation-block arrays. -/
def forbiddenCheck (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A) : Bool := by
  letI : DecidableRel (active (filled B slot a)) := fun v c => by
    unfold active
    infer_instance
  letI : DecidableRel (bipartite (active (filled B slot a)) (label (filled B slot a))).base.Adj :=
    decidableBipartiteBase _
  exact completeCheck (bipartite (active (filled B slot a)) (label (filled B slot a))) g

theorem forbiddenCheck_spec (B : X × C → Option A) (slot : X × C)
    (g : ℕ) (a : A) :
    forbiddenCheck B slot g a = true ↔
    BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
      (label (filled B slot a)))) g := by
  unfold forbiddenCheck
  rw [completeCheck_spec]
  change BoundedCycle (tannerLift _ _) g ↔ _
  rw [lift_eq_binaryTanner]

end MatrixBridge

section SourceRowPatterns

/-- P11's 21 row-pattern representatives preceding Theorem A.6, with
h,i,j,k represented by 0,1,2,3. This list uses its own ordering. -/
def sourceRows (m : Fin 21) : Fin 4 → Fin 4 :=
  ![![0,1,0,1], ![0,1,0,2], ![0,1,0,3], ![0,2,0,2], ![0,2,0,3],
    ![0,3,0,3], ![0,2,1,2], ![0,2,1,3], ![0,3,1,3], ![0,1,2,1],
    ![0,1,2,3], ![0,1,3,1], ![0,1,3,2], ![0,2,3,2], ![0,3,2,3],
    ![1,2,1,2], ![1,2,1,3], ![1,3,1,3], ![1,3,2,3], ![1,2,3,2],
    ![2,3,2,3]] m

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
/-- Every cyclically adjacent-distinct four-step row word over four
ordered rows is a rotation or reversal of a displayed source pattern.
This does not certify the source's multiplicity formulas or an implementation. -/
theorem source_row_patterns_complete : ∀ r : Fin 4 → Fin 4,
    (∀ i : Fin 4, r i ≠ r (i+1)) ↔
    ∃ m : Fin 21, ∃ shift : Fin 4, ∃ rev : Bool,
      ∀ i : Fin 4, r i = sourceRows m (if rev then shift-i else shift+i) := by decide

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem proper_row_word_count :
    ((Finset.univ : Finset (Fin 4 → Fin 4)).filter
      (fun r => decide (∀ i : Fin 4, r i ≠ r (i+1)) = true)).card = 84 := by decide

end SourceRowPatterns

section SmallObstructions

/-- Ordinary 2x2 Tanner protograph, not the earlier lifted-product construction. -/
def twoBase : SimpleGraph (Fin 2 ⊕ Fin 2) := bipartiteBase (fun _ _ => True)

def rectangle : twoBase.Walk (.inr 0) (.inr 0) :=
  fourWalk (b:=.inl 0) (c:=.inr 1) (d:=.inl 1) trivial trivial trivial trivial

def bitLabels (v c : Fin 2) : ZMod 2 := if v = 1 ∧ c = 1 then 1 else 0

def bitLift : VoltageGraph (Fin 2 ⊕ Fin 2) (ZMod 2) := bipartite (fun _ _ => True) bitLabels

def zeroLift : VoltageGraph (Fin 2 ⊕ Fin 2) (ZMod 2) := bipartite (fun _ _ => True) (fun _ _ => 0)

/-- A nonzero rectangle displacement has order two, so traversing it twice
produces a simple eight-cycle with two occurrences of the variable slot. -/
theorem repeated_rectangle_good : GoodWord bitLift (rectangle.append rectangle) := by
  unfold GoodWord
  decide

theorem repeated_rectangle_native_eight :
    ∃ q : bitLift.lift.Walk (.inr 0,0) (.inr 0,0), q.IsCycle ∧ q.length = 8 := by
  obtain ⟨q,hq,hl⟩ := goodWord_sound bitLift (rectangle.append rectangle) repeated_rectangle_good 0
  exact ⟨q,hq,hl⟩

/-- Zero displacement of a repeated rectangle does not alone certify a
simple eight-cycle: with all labels zero it repeats a four-cycle. -/
theorem zero_repeated_rectangle_not_simple :
    zeroLift.displacement (rectangle.append rectangle) = 0 ∧
    ¬GoodWord zeroLift (rectangle.append rectangle) := by
  unfold GoodWord
  decide

/-- Direct execution checks the parity-sensitive example through the same
terminating checker whose general specification was proved above. -/
def threeZeroBlocks : Fin 2 × Fin 2 → Option (ZMod 2) :=
  fun slot => if slot = (1,1) then none else some 0

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem executable_counterexample :
    forbiddenCheck threeZeroBlocks (1,1) 4 0 = true ∧
    forbiddenCheck threeZeroBlocks (1,1) 4 1 = false ∧
    forbiddenCheck threeZeroBlocks (1,1) 6 1 = false ∧
    forbiddenCheck threeZeroBlocks (1,1) 8 1 = true := by decide

end SmallObstructions

#print axioms liftedWalk_support
#print axioms liftedWalk_length
#print axioms trace_project
#print axioms trace_shift
#print axioms trace_tail_nodup_zero_iff
#print axioms goodWord_sound
#print axioms goodWord_complete
#print axioms forbidden_complete
#print axioms exact_cycle_complete
#print axioms wordCheck_iff
#print axioms completeCheck_iff_pattern
#print axioms completeCheck_spec
#print axioms lift_eq_binaryTanner
#print axioms forbidden_labels_matrix_complete
#print axioms six_eight_complete
#print axioms dyadic_threshold_complete
#print axioms forbiddenCheck_spec
#print axioms repeated_rectangle_good
#print axioms repeated_rectangle_native_eight
#print axioms zero_repeated_rectangle_not_simple
#print axioms executable_counterexample
#print axioms source_row_patterns_complete
#print axioms proper_row_word_count

end DyadicForbidden
