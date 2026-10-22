module

public import Mathlib.Combinatorics.SimpleGraph.Paths
public import Mathlib.Data.ZMod.Basic
public import Mathlib.Tactic.Abel

@[expose] public section

namespace CyclicLift

/-- An additive voltage assignment; traversing an edge backwards negates its label. -/
structure VoltageGraph (V A : Type*) [AddCommGroup A] where
  base : SimpleGraph V
  voltage : V → V → A
  reverse : ∀ u v, voltage v u = -voltage u v

variable {V A : Type*} [AddCommGroup A]

/-- The lifted adjacency uses the convention: destination fiber = source fiber + voltage. -/
def VoltageGraph.lift (L : VoltageGraph V A) : SimpleGraph (V × A) where
  Adj x y := L.base.Adj x.1 y.1 ∧ y.2 = x.2 + L.voltage x.1 y.1
  symm := ⟨by
    intro x y h
    refine ⟨h.1.symm, ?_⟩
    rw [L.reverse, h.2]
    simp [add_assoc]⟩
  loopless := ⟨by
    intro x h
    exact L.base.ne_of_adj h.1 rfl⟩

/-- Forgetting the fiber is a graph homomorphism. -/
def VoltageGraph.projection (L : VoltageGraph V A) : L.lift →g L.base where
  toFun := Prod.fst
  map_rel' := fun h => h.1

/-- Oriented label sum of an actual base-graph walk. -/
def VoltageGraph.displacement (L : VoltageGraph V A) {u v : V} : L.base.Walk u v → A
  | .nil => 0
  | .cons' u v _ _ w => L.voltage u v + L.displacement w

@[simp] theorem VoltageGraph.displacement_nil (L : VoltageGraph V A) (u : V) :
    L.displacement (.nil : L.base.Walk u u) = 0 := rfl

@[simp] theorem VoltageGraph.displacement_cons (L : VoltageGraph V A) {u v w : V}
    (h : L.base.Adj u v) (p : L.base.Walk v w) :
    L.displacement (.cons h p) = L.voltage u v + L.displacement p := rfl

/-- Every lifted walk ends at its initial fiber plus the voltage of its projection. -/
theorem VoltageGraph.endpoint_fiber (L : VoltageGraph V A) {x y : V × A}
    (p : L.lift.Walk x y) :
    y.2 = x.2 + L.displacement (p.map L.projection) := by
  induction p with
  | nil => simp
  | @cons x y z h p ih =>
    change z.2 = x.2 + (L.voltage x.1 y.1 + L.displacement (p.map L.projection))
    rw [ih, h.2, add_assoc]

/-- Zero projected displacement is exactly equality of endpoint fibers.
The endpoints' base vertices need not agree; closed-walk applications must also check them. -/
theorem VoltageGraph.same_fiber_iff (L : VoltageGraph V A) {x y : V × A}
    (p : L.lift.Walk x y) :
    y.2 = x.2 ↔ L.displacement (p.map L.projection) = 0 := by
  rw [L.endpoint_fiber p]
  exact add_eq_left

/-- A prescribed base walk has a lift with the predicted endpoint.
This existence result does not assert simplicity of the lifted walk. -/
theorem VoltageGraph.lift_walk_exists (L : VoltageGraph V A) {u v : V}
    (p : L.base.Walk u v) (a : A) :
    Nonempty (L.lift.Walk (u, a) (v, a + L.displacement p)) := by
  induction p generalizing a with
  | nil => simpa using (show Nonempty (L.lift.Walk (_, a) (_, a)) from ⟨.nil⟩)
  | @cons u v w h p ih =>
    obtain ⟨q⟩ := ih (a + L.voltage u v)
    have edge : L.lift.Adj (u, a) (v, a + L.voltage u v) := ⟨h, rfl⟩
    simpa [add_assoc] using (show Nonempty (L.lift.Walk (u, a)
      (w, (a + L.voltage u v) + L.displacement p)) from ⟨.cons edge q⟩)

/-- The constructed lift projects to the prescribed walk, rather than just sharing endpoints. -/
theorem VoltageGraph.lift_walk_projects (L : VoltageGraph V A) {u v : V}
    (p : L.base.Walk u v) (a : A) :
    ∃ q : L.lift.Walk (u, a) (v, a + L.displacement p), q.map L.projection = p := by
  induction p generalizing a with
  | @nil u =>
    refine ⟨(.nil : L.lift.Walk (u, a) (u, a)).copy rfl (by simp), ?_⟩
    rw [SimpleGraph.Walk.map_copy]
    rfl
  | @cons u v w h p ih =>
    obtain ⟨q, hq⟩ := ih (a + L.voltage u v)
    have edge : L.lift.Adj (u, a) (v, a + L.voltage u v) := ⟨h, rfl⟩
    have heq : (w, (a + L.voltage u v) + L.displacement p) =
        (w, a + L.displacement (.cons h p)) := by simp [add_assoc]
    refine ⟨(SimpleGraph.Walk.cons edge q).copy rfl heq, ?_⟩
    rw [SimpleGraph.Walk.map_copy]
    change (SimpleGraph.Walk.cons h (q.map L.projection)).copy rfl rfl = .cons h p
    simpa using congrArg (SimpleGraph.Walk.cons h) hq

/-- A zero-displacement closed base walk admits a closed lifted walk. -/
theorem VoltageGraph.closed_lift_exists (L : VoltageGraph V A) {u : V}
    (p : L.base.Walk u u) (h : L.displacement p = 0) (a : A) :
    Nonempty (L.lift.Walk (u, a) (u, a)) := by
  simpa [h] using L.lift_walk_exists p a

/-- A prescribed closed base walk has a closed lift at any chosen fiber iff its voltage is zero. -/
theorem VoltageGraph.closed_lift_projects_iff (L : VoltageGraph V A) {u : V}
    (p : L.base.Walk u u) (a : A) :
    (∃ q : L.lift.Walk (u, a) (u, a), q.map L.projection = p) ↔
      L.displacement p = 0 := by
  constructor
  · rintro ⟨q, hq⟩
    have hh := L.endpoint_fiber q
    change a = a + L.displacement (q.map L.projection) at hh
    rw [hq] at hh
    exact add_eq_left.mp hh.symm
  · intro h
    obtain ⟨q, hq⟩ := L.lift_walk_projects p a
    have heq : (u, a + L.displacement p) = (u, a) := by simp [h]
    refine ⟨q.copy rfl heq, ?_⟩
    rw [SimpleGraph.Walk.map_copy]
    change (q.map L.projection).copy rfl rfl = p
    simpa using hq

/-- Label sums compose additively along consecutive walks. -/
theorem VoltageGraph.displacement_append (L : VoltageGraph V A) {u v w : V}
    (p : L.base.Walk u v) (q : L.base.Walk v w) :
    L.displacement (p.append q) = L.displacement p + L.displacement q := by
  induction p with
  | nil => simp
  | @cons u v z h p ih =>
    change L.voltage u v + L.displacement (p.append q) =
      (L.voltage u v + L.displacement p) + L.displacement q
    rw [ih q, add_assoc]

/-- A four-edge closed walk, with simplicity handled separately. -/
def fourWalk {W : Type*} {G : SimpleGraph W} {a b c d : W}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d) (hda : G.Adj d a) :
    G.Walk a a := .cons hab (.cons hbc (.cons hcd (.cons hda .nil)))

/-- In a simple graph, opposite-vertex inequalities make this four-edge walk a cycle. -/
theorem fourWalk_isCycle {W : Type*} {G : SimpleGraph W} {a b c d : W}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d) (hda : G.Adj d a)
    (hac : a ≠ c) (hbd : b ≠ d) : (fourWalk hab hbc hcd hda).IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · simp [fourWalk, SimpleGraph.Walk.isPath_def, Ne.symm hab.ne, hbc.ne, hcd.ne,
      hda.ne, hbd, Ne.symm hac]
  · simp [fourWalk]

/-- A four-cycle specified by its four cyclically ordered vertices. -/
def HasFourCycle {W : Type*} (G : SimpleGraph W) : Prop :=
  ∃ a b c d, G.Adj a b ∧ G.Adj b c ∧ G.Adj c d ∧ G.Adj d a ∧ a ≠ c ∧ b ≠ d

/-- The vertex formulation supplies a native Mathlib simple cycle of length four. -/
theorem HasFourCycle.native {W : Type*} {G : SimpleGraph W} (h : HasFourCycle G) :
    ∃ a, ∃ p : G.Walk a a, p.IsCycle ∧ p.length = 4 := by
  obtain ⟨a, b, c, d, hab, hbc, hcd, hda, hac, hbd⟩ := h
  exact ⟨a, fourWalk hab hbc hcd hda,
    fourWalk_isCycle hab hbc hcd hda hac hbd, rfl⟩

/-- The four-vertex predicate is equivalent to a native simple cycle of length four. -/
theorem hasFourCycle_iff_native {W : Type*} (G : SimpleGraph W) :
    HasFourCycle G ↔ ∃ a, ∃ p : G.Walk a a, p.IsCycle ∧ p.length = 4 := by
  refine ⟨HasFourCycle.native, ?_⟩
  rintro ⟨a, p, hp, hl⟩
  refine ⟨p.getVert 0, p.getVert 1, p.getVert 2, p.getVert 3,
    p.adj_getVert_succ (by omega), p.adj_getVert_succ (by omega),
    p.adj_getVert_succ (by omega), ?_, ?_, ?_⟩
  · simpa [← hl] using p.adj_getVert_succ (i := 3) (by omega)
  · intro h
    have := hp.getVert_injOn' (by change 0 ≤ p.length - 1; omega)
      (by change 2 ≤ p.length - 1; omega) h
    omega
  · intro h
    have := hp.getVert_injOn' (by change 1 ≤ p.length - 1; omega)
      (by change 3 ≤ p.length - 1; omega) h
    omega

end CyclicLift
