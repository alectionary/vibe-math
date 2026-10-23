module

public import DyadicForbidden

@[expose] public section
open CyclicLift
namespace DyadicForbidden

set_option backward.isDefEq.respectTransparency.types false

/-- Nonbacktracking: consecutive unoriented edges differ. The source also
requires taillessness; the weaker condition suffices for threshold soundness. -/
def Reduced {V : Type*} {G : SimpleGraph V} {u v : V} (p : G.Walk u v) : Prop :=
  p.edges.IsChain (· ≠ ·)

/-- A reduced walk is a path or contains a simple cycle no longer than itself.
In particular this does not assert that a reduced closed walk is itself simple. -/
theorem reduced_path_or_boundedCycle {V : Type*} {G : SimpleGraph V} {u v : V}
    (p : G.Walk u v) (hr : Reduced p) : p.IsPath ∨ BoundedCycle G p.length := by
  classical
  induction p with
  | nil => exact Or.inl (by simp)
  | @cons u v w h q ih =>
    unfold Reduced at hr
    have hc := List.isChain_cons.mp (SimpleGraph.Walk.edges_cons _ _ ▸ hr)
    rcases ih hc.2 with hp | ⟨x,c,hc,hl⟩
    · by_cases hu : u ∈ q.support
      · right
        refine ⟨u, (q.takeUntil u hu).cons h, ?_, ?_⟩
        · apply (SimpleGraph.Walk.cons_isCycle_iff ..).mpr
          refine ⟨hp.takeUntil hu, ?_⟩
          intro he
          rcases q.length.eq_zero_or_pos with hq | hq
          · have hn := SimpleGraph.Walk.length_eq_zero_iff.mp hq
            have huv : u = v := by simpa [SimpleGraph.Walk.nil_iff_support_eq.mp hn] using hu
            exact h.ne huv
          · apply hc.1 s(u,v) ?_ rfl
            rw [← q.cons_tail_eq (by simpa [SimpleGraph.Walk.not_nil_iff_lt_length] using hq)]
            have hs := (hp.takeUntil hu).eq_snd_of_mem_edges (Sym2.eq_swap ▸ he)
            simp [hs, SimpleGraph.Walk.snd_takeUntil h.ne]
        · simpa using Nat.add_le_add_right (q.length_takeUntil_le_length hu) 1
      · exact Or.inl ((SimpleGraph.Walk.cons_isPath_iff ..).mpr ⟨hp,hu⟩)
    · right
      exact ⟨x,c,hc,by simpa using Nat.le_trans hl (Nat.le_add_right q.length 1)⟩

theorem reduced_closed_boundedCycle {V : Type*} {G : SimpleGraph V} {u : V}
    (p : G.Walk u u) (hr : Reduced p) (hn : ¬p.Nil) : BoundedCycle G p.length := by
  rcases reduced_path_or_boundedCycle p hr with hp | hc
  · exact (hn (SimpleGraph.Walk.isPath_iff_nil.mp hp)).elim
  · exact hc

theorem reduced_cons_cons {V : Type*} {G : SimpleGraph V} {u v w z : V}
    (h : G.Adj u v) (k : G.Adj v w) (p : G.Walk w z) :
    Reduced (p.cons k |>.cons h) ↔ u ≠ w ∧ Reduced (p.cons k) := by
  simp [Reduced, SimpleGraph.Walk.edges_cons, List.isChain_cons_cons,
    h.ne]

/-- Requiring the doubled walk to be reduced also tests the closing junction,
so this is exactly tailless nonbacktracking for a nonempty closed walk. -/
def TBC {V : Type*} {G : SimpleGraph V} {u : V} (p : G.Walk u u) : Prop :=
  ¬p.Nil ∧ Reduced (p.append p)

theorem cycle_tbc {V : Type*} {G : SimpleGraph V} {u : V}
    (p : G.Walk u u) (hp : p.IsCycle) : TBC p := by
  refine ⟨hp.not_nil, ?_⟩
  unfold Reduced
  rw [SimpleGraph.Walk.edges_append, List.isChain_append]
  refine ⟨hp.isTrail.edges_nodup.isChain, hp.isTrail.edges_nodup.isChain, ?_⟩
  intro e he f hf hef
  obtain ⟨he',rfl⟩ := List.mem_getLast?_eq_getLast he
  have hn : p.edges ≠ [] := SimpleGraph.Walk.edges_eq_nil.not.mpr hp.not_nil
  have hf' : f = p.edges.head hn := by
    symm
    simpa [List.head?_eq_some_head hn] using hf
  rw [hf'] at hef
  rw [SimpleGraph.Walk.getLast_edges_eq_mk_penultimate_end,
    SimpleGraph.Walk.head_edges_eq_mk_start_snd] at hef
  rcases Sym2.eq_iff.mp hef with h | h
  · exact hp.snd_ne_penultimate (h.2.symm.trans h.1.symm)
  · exact hp.snd_ne_penultimate h.1.symm

variable {V A : Type*} [AddCommGroup A]

/-- Projection reflects equality of the two endpoints of a two-edge lifted
walk: a single permutation per base edge has a unique lifted neighbor. -/
theorem two_step_fiber_unique (L : VoltageGraph V A) {x y z : V × A}
    (h : L.lift.Adj x y) (k : L.lift.Adj y z) (he : x.1 = z.1) : x = z := by
  apply Prod.ext he
  have hz : z.2 = x.2 := by
    calc
      z.2 = y.2 + L.voltage y.1 z.1 := k.2
      _ = (x.2 + L.voltage x.1 y.1) + (-L.voltage x.1 y.1) := by
        rw [h.2, ← he, L.reverse y.1 x.1]
        simp
      _ = x.2 := by abel
  exact hz.symm

theorem reduced_project_iff (L : VoltageGraph V A) {x y : V × A}
    (p : L.lift.Walk x y) : Reduced (p.map L.projection) ↔ Reduced p := by
  induction p with
  | nil => simp [Reduced]
  | @cons x y z h p ih =>
    cases p with
    | nil => simp [Reduced]
    | @cons y w z k p =>
      simp only [SimpleGraph.Walk.map_cons, reduced_cons_cons] at ih ⊢
      constructor
      · rintro ⟨he,hr⟩
        exact ⟨fun hh => he (congrArg Prod.fst hh), ih.mp hr⟩
      · rintro ⟨he,hr⟩
        exact ⟨fun hh => he (two_step_fiber_unique L h k hh), ih.mpr hr⟩

/-- Literal zero-voltage, nonbacktracking forbidden-pattern contract.
Unlike GoodWord, this definition contains no simplicity/prefix test. -/
def SourceForbidden (L : VoltageGraph V A) (g : ℕ) : Prop :=
  ∃ u, ∃ p : L.base.Walk u u,
    Reduced p ∧ ¬p.Nil ∧ L.displacement p = 0 ∧ p.length ≤ g

/-- Closed nonbacktracking voltage words and simple cycles give exactly the
same cumulative forbidden set, even when exact-length counts differ. -/
theorem source_forbidden_complete (L : VoltageGraph V A) (g : ℕ) :
    SourceForbidden L g ↔ BoundedCycle L.lift g := by
  constructor
  · rintro ⟨u,p,hr,hn,hzero,hg⟩
    obtain ⟨q,hmap⟩ := (L.closed_lift_projects_iff p 0).mpr hzero
    have hq : Reduced q := (reduced_project_iff L q).mp (hmap ▸ hr)
    have hlen : q.length = p.length := by
      calc
        q.length = (q.map L.projection).length := (SimpleGraph.Walk.length_map L.projection q).symm
        _ = p.length := congrArg SimpleGraph.Walk.length hmap
    have hqn : ¬q.Nil := by
      intro he
      have : p.length = 0 := by
        rw [← hlen, SimpleGraph.Walk.length_eq_zero_iff.mpr he]
      exact hn (SimpleGraph.Walk.length_eq_zero_iff.mp this)
    obtain ⟨x,c,hc,hl⟩ := reduced_closed_boundedCycle q hq hqn
    exact ⟨x,c,hc,hl.trans (hlen ▸ hg)⟩
  · rintro ⟨x,q,hq,hg⟩
    refine ⟨L.projection x,q.map L.projection,?_,?_,?_,?_⟩
    · exact (reduced_project_iff L q).mpr hq.isTrail.edges_nodup.isChain
    · intro he
      have hz : (q.map L.projection).length = 0 := SimpleGraph.Walk.length_eq_zero_iff.mpr he
      rw [SimpleGraph.Walk.length_map] at hz
      have : q.length = 0 := hz
      exact hq.not_nil (SimpleGraph.Walk.length_eq_zero_iff.mp this)
    · exact (L.closed_lift_projects_iff (q.map L.projection) x.2).mp ⟨q,rfl⟩
    · rw [SimpleGraph.Walk.length_map]
      exact hg

theorem source_forbidden_iff_prefix (L : VoltageGraph V A) (g : ℕ) :
    SourceForbidden L g ↔ PatternForbidden L g := by
  rw [source_forbidden_complete, forbidden_complete]

section RowRelabeling
variable {C : Type*} [DecidableEq C]

/-- Encode a visited row by its first occurrence among the four positions. -/
def rowEncode (r : Fin 4 → C) (x : C) : Fin 4 :=
  if x = r 0 then 0 else if x = r 1 then 1 else if x = r 2 then 2 else 3

theorem rowEncode_decode (r : Fin 4 → C) (i : Fin 4) : r (rowEncode r (r i)) = r i := by
  fin_cases i <;> simp only [rowEncode] <;> split_ifs <;> simp_all

/-- The finite 21-pattern certificate applies to arbitrary row types and
dimensions, by relabeling the at most four visited rows. No multiplicity or
ordered-enumeration identity is asserted here. -/
theorem arbitrary_row_patterns_complete (r : Fin 4 → C)
    (hr : ∀ i : Fin 4, r i ≠ r (i+1)) :
    ∃ m : Fin 21, ∃ shift : Fin 4, ∃ rev : Bool,
      ∀ i : Fin 4, r i = r (sourceRows m (if rev then shift-i else shift+i)) := by
  have hc : ∀ i : Fin 4, rowEncode r (r i) ≠ rowEncode r (r (i+1)) := by
    intro i he
    apply hr i
    calc
      r i = r (rowEncode r (r i)) := (rowEncode_decode r i).symm
      _ = r (rowEncode r (r (i+1))) := congrArg r he
      _ = r (i+1) := rowEncode_decode r (i+1)
  obtain ⟨m,s,v,h⟩ := (source_row_patterns_complete (fun i => rowEncode r (r i))).mp hc
  refine ⟨m,s,v,fun i => ?_⟩
  rw [← h i]
  exact (rowEncode_decode r i).symm

end RowRelabeling

theorem tbc_project_iff (L : VoltageGraph V A) {x : V × A}
    (p : L.lift.Walk x x) : TBC (p.map L.projection) ↔ TBC p := by
  unfold TBC
  rw [SimpleGraph.Walk.nil_map_iff, ← SimpleGraph.Walk.map_append, reduced_project_iff]

def SourceTBCForbidden (L : VoltageGraph V A) (g : ℕ) : Prop :=
  ∃ u, ∃ p : L.base.Walk u u, TBC p ∧ L.displacement p = 0 ∧ p.length ≤ g

theorem source_tbc_complete (L : VoltageGraph V A) (g : ℕ) :
    SourceTBCForbidden L g ↔ BoundedCycle L.lift g := by
  constructor
  · rintro ⟨u,p,⟨hn,hr⟩,hz,hg⟩
    apply (source_forbidden_complete L g).mp
    refine ⟨u,p,?_,hn,hz,hg⟩
    unfold Reduced at hr ⊢
    exact (List.isChain_append.mp (SimpleGraph.Walk.edges_append p p ▸ hr)).1
  · rintro ⟨x,q,hq,hg⟩
    refine ⟨L.projection x,q.map L.projection,
      (tbc_project_iff L q).mpr (cycle_tbc q hq),?_,?_⟩
    · exact (L.closed_lift_projects_iff (q.map L.projection) x.2).mp ⟨q,rfl⟩
    · rw [SimpleGraph.Walk.length_map]
      exact hg

section SourceChecker
variable [Fintype V] [DecidableEq V] [DecidableEq A]

def sourceWordCheck (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u) : Bool :=
  decide (¬p.Nil) && decide ((p.append p).edges.IsChain (· ≠ ·)) &&
    decide (L.displacement p = 0)

omit [Fintype V] in
theorem sourceWordCheck_iff (L : VoltageGraph V A) {u : V} (p : L.base.Walk u u) :
    sourceWordCheck L p = true ↔ TBC p ∧ L.displacement p = 0 := by
  simp [sourceWordCheck, TBC, Reduced, and_assoc]

/-- Executable reconstruction of P11's cumulative zero-sum TBC-word rule.
Every supported pattern up to the threshold is included; no prefix test. -/
def sourceCheck (L : VoltageGraph V A) [DecidableRel L.base.Adj] (g : ℕ) : Bool :=
  @decide (∃ u : V, ∃ p ∈ L.base.finsetWalkLengthLT (g+1) u u, sourceWordCheck L p = true)
    (@Fintype.decidableExistsFintype V
      (fun u => ∃ p ∈ L.base.finsetWalkLengthLT (g+1) u u, sourceWordCheck L p = true)
      (fun _u => Finset.decidableExistsAndFinset) inferInstance)

theorem sourceCheck_iff (L : VoltageGraph V A) [DecidableRel L.base.Adj] (g : ℕ) :
    sourceCheck L g = true ↔ SourceTBCForbidden L g := by
  simp only [sourceCheck,decide_eq_true_eq,
    SimpleGraph.mem_finsetWalkLengthLT_iff,sourceWordCheck_iff]
  constructor
  · rintro ⟨u,p,hl,ht,hz⟩
    exact ⟨u,p,ht,hz,by omega⟩
  · rintro ⟨u,p,ht,hz,hl⟩
    exact ⟨u,p,by omega,ht,hz⟩

theorem sourceCheck_eq_completeCheck (L : VoltageGraph V A)
    [DecidableRel L.base.Adj] (g : ℕ) : sourceCheck L g = completeCheck L g := by
  apply Bool.eq_iff_iff.mpr
  rw [sourceCheck_iff,source_tbc_complete,completeCheck_spec]

end SourceChecker

section MatrixSource
variable {X C : Type*} [DecidableEq X] [DecidableEq C]
  [Fintype X] [Fintype C] [DecidableEq A]

def sourceForbiddenCheck (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A) : Bool := by
  letI : DecidableRel (active (filled B slot a)) := fun v c => by
    unfold active
    infer_instance
  letI : DecidableRel (bipartite (active (filled B slot a)) (label (filled B slot a))).base.Adj :=
    decidableBipartiteBase _
  exact sourceCheck (bipartite (active (filled B slot a)) (label (filled B slot a))) g

theorem sourceForbiddenCheck_eq (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A) :
    sourceForbiddenCheck B slot g a = forbiddenCheck B slot g a := by
  unfold sourceForbiddenCheck forbiddenCheck
  let : DecidableRel (active (filled B slot a)) := fun v c => by
    unfold active
    infer_instance
  let : DecidableRel (bipartite (active (filled B slot a)) (label (filled B slot a))).base.Adj :=
    decidableBipartiteBase _
  exact sourceCheck_eq_completeCheck _ _

theorem sourceForbiddenCheck_spec (B : X × C → Option A) (slot : X × C) (g : ℕ) (a : A) :
    sourceForbiddenCheck B slot g a = true ↔
    BoundedCycle (matrixTanner (binaryExpansion (active (filled B slot a))
      (label (filled B slot a)))) g := by
  rw [sourceForbiddenCheck_eq,forbiddenCheck_spec]

theorem source_dyadic_six_eight (ell : ℕ)
    (B : X × C → Option (Fin ell → ZMod 2)) (slot : X × C)
    (g : ℕ) (a : Fin ell → ZMod 2) :
    sourceForbiddenCheck B slot g a = forbiddenCheck B slot g a :=
  sourceForbiddenCheck_eq B slot g a

end MatrixSource

#print axioms reduced_path_or_boundedCycle
#print axioms reduced_closed_boundedCycle
#print axioms reduced_cons_cons
#print axioms cycle_tbc
#print axioms two_step_fiber_unique
#print axioms reduced_project_iff
#print axioms source_forbidden_complete
#print axioms source_forbidden_iff_prefix
#print axioms rowEncode_decode
#print axioms arbitrary_row_patterns_complete
#print axioms tbc_project_iff
#print axioms source_tbc_complete
#print axioms sourceWordCheck_iff
#print axioms sourceCheck_iff
#print axioms sourceCheck_eq_completeCheck
#print axioms sourceForbiddenCheck_eq
#print axioms sourceForbiddenCheck_spec
#print axioms source_dyadic_six_eight

end DyadicForbidden
