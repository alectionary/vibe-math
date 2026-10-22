module

public import CyclicLift.LiftedProduct
public import Mathlib.Combinatorics.SimpleGraph.Girth
public import Mathlib.Combinatorics.SimpleGraph.Coloring.Constructions

@[expose] public section
namespace CyclicLift

def sixWalk {W : Type*} {G : SimpleGraph W} {a b c d e f : W}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d)
    (hde : G.Adj d e) (hef : G.Adj e f) (hfa : G.Adj f a) : G.Walk a a :=
  .cons hab (.cons hbc (.cons hcd (.cons hde (.cons hef (.cons hfa .nil)))))

/-- Distinct lifted vertices turn the explicit six-edge walk into a simple cycle. -/
theorem sixWalk_isCycle {W : Type*} {G : SimpleGraph W} {a b c d e f : W}
    (hab : G.Adj a b) (hbc : G.Adj b c) (hcd : G.Adj c d)
    (hde : G.Adj d e) (hef : G.Adj e f) (hfa : G.Adj f a)
    (hn : [a,b,c,d,e,f].Nodup) : (sixWalk hab hbc hcd hde hef hfa).IsCycle := by
  rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
  constructor
  · rw [SimpleGraph.Walk.isPath_def]
    change [b,c,d,e,f,a].Nodup
    simpa using List.nodup_append_comm.mpr (show ([a] ++ [b,c,d,e,f]).Nodup from hn)
  · change 3 ≤ 6; omega

/-- An explicit six-vertex description, with distinctness in the lifted graph. -/
def HasSixCycle {W : Type*} (G : SimpleGraph W) : Prop :=
  ∃ a b c d e f, G.Adj a b ∧ G.Adj b c ∧ G.Adj c d ∧
    G.Adj d e ∧ G.Adj e f ∧ G.Adj f a ∧ [a,b,c,d,e,f].Nodup

theorem hasSixCycle_iff_native {W : Type*} (G : SimpleGraph W) :
    HasSixCycle G ↔ ∃ a, ∃ p : G.Walk a a, p.IsCycle ∧ p.length = 6 := by
  constructor
  · rintro ⟨a,b,c,d,e,f,hab,hbc,hcd,hde,hef,hfa,hn⟩
    refine ⟨a, sixWalk hab hbc hcd hde hef hfa, ?_, rfl⟩
    rw [SimpleGraph.Walk.isCycle_iff_isPath_tail_and_le_length]
    constructor
    · rw [SimpleGraph.Walk.isPath_def]
      change [b,c,d,e,f,a].Nodup
      simpa [List.nodup_cons, and_comm, and_left_comm, and_assoc, ne_comm] using hn
    · change 3 ≤ 6; omega
  · rintro ⟨a,p,hp,hl⟩
    have hi (i j : ℕ) (hi : i < 6) (hj : j < 6) (hne : i ≠ j) :
        p.getVert i ≠ p.getVert j := by
      intro h
      exact hne (hp.getVert_injOn' (by change i ≤ p.length - 1; omega)
        (by change j ≤ p.length - 1; omega) h)
    refine ⟨p.getVert 0,p.getVert 1,p.getVert 2,p.getVert 3,p.getVert 4,p.getVert 5,
      p.adj_getVert_succ (by omega),p.adj_getVert_succ (by omega),
      p.adj_getVert_succ (by omega),p.adj_getVert_succ (by omega),
      p.adj_getVert_succ (by omega), ?_, ?_⟩
    · simpa [← hl] using p.adj_getVert_succ (i := 5) (by omega)
    · simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, not_or,
        not_false_eq_true, List.nodup_nil, and_true]
      exact ⟨⟨hi 0 1 (by omega) (by omega) (by omega),
          hi 0 2 (by omega) (by omega) (by omega),
          hi 0 3 (by omega) (by omega) (by omega),
          hi 0 4 (by omega) (by omega) (by omega),
          hi 0 5 (by omega) (by omega) (by omega)⟩,
        ⟨hi 1 2 (by omega) (by omega) (by omega),
          hi 1 3 (by omega) (by omega) (by omega),
          hi 1 4 (by omega) (by omega) (by omega),
          hi 1 5 (by omega) (by omega) (by omega)⟩,
        ⟨hi 2 3 (by omega) (by omega) (by omega),
          hi 2 4 (by omega) (by omega) (by omega),
          hi 2 5 (by omega) (by omega) (by omega)⟩,
        ⟨hi 3 4 (by omega) (by omega) (by omega),
          hi 3 5 (by omega) (by omega) (by omega)⟩,
        hi 4 5 (by omega) (by omega) (by omega)⟩

variable {V C A : Type*} [AddCommGroup A]

/-- Alternating label sum around v0-c0-v1-c1-v2-c2-v0. -/
def hexagonVoltage (s : V → C → A) (v0 v1 v2 : V) (c0 c1 c2 : C) : A :=
  s v0 c0 - s v1 c0 + s v1 c1 - s v2 c1 + s v2 c2 - s v0 c2

/-- Exact closure test for a prescribed supported six-edge base walk.
Repeated base vertices are allowed here: closure alone is not simplicity. -/
theorem hexagon_closes_iff (E : V → C → Prop) (s : V → C → A)
    (v0 v1 v2 : V) (c0 c1 c2 : C) (a : A)
    (h00 : E v0 c0) (h10 : E v1 c0) (h11 : E v1 c1)
    (h21 : E v2 c1) (h22 : E v2 c2) (h02 : E v0 c2) :
    (∃ q : (tannerLift E s).Walk (.inl v0,a) (.inl v0,a),
      q.map (bipartite E s).projection =
        sixWalk (G := (bipartite E s).base) (a := Sum.inl v0) (b := Sum.inr c0)
          (c := Sum.inl v1) (d := Sum.inr c1) (e := Sum.inl v2) (f := Sum.inr c2)
          h00 h10 h11 h21 h22 h02) ↔ hexagonVoltage s v0 v1 v2 c0 c1 c2 = 0 := by
  rw [(bipartite E s).closed_lift_projects_iff]
  simp [sixWalk, VoltageGraph.displacement, bipartite, bipartiteVoltage,
    hexagonVoltage, sub_eq_add_neg, add_assoc]

/-- A zero-voltage hexagon on three distinct variables and checks lifts to a simple six-cycle. -/
theorem hexagon_gives_six_cycle (E : V → C → Prop) (s : V → C → A)
    (v0 v1 v2 : V) (c0 c1 c2 : C) (a : A)
    (hv01 : v0 ≠ v1) (hv12 : v1 ≠ v2) (hv02 : v0 ≠ v2)
    (hc01 : c0 ≠ c1) (hc12 : c1 ≠ c2) (hc02 : c0 ≠ c2)
    (h00 : E v0 c0) (h10 : E v1 c0) (h11 : E v1 c1)
    (h21 : E v2 c1) (h22 : E v2 c2) (h02 : E v0 c2)
    (hz : hexagonVoltage s v0 v1 v2 c0 c1 c2 = 0) :
    ∃ q : (tannerLift E s).Walk (.inl v0,a) (.inl v0,a), q.IsCycle ∧ q.length = 6 := by
  obtain ⟨q,hq⟩ := (hexagon_closes_iff E s v0 v1 v2 c0 c1 c2 a
    h00 h10 h11 h21 h22 h02).mpr hz
  have hp := sixWalk_isCycle (G := (bipartite E s).base) (a := Sum.inl v0)
    (b := Sum.inr c0) (c := Sum.inl v1) (d := Sum.inr c1) (e := Sum.inl v2)
    (f := Sum.inr c2) h00 h10 h11 h21 h22 h02
    (by simp [hv01,hv12,hv02,hc01,hc12,hc02])
  refine ⟨q, SimpleGraph.Walk.IsCycle.of_map (hq.symm ▸ hp), ?_⟩
  have hlen := congrArg SimpleGraph.Walk.length hq
  change (q.map _).length = 6 at hlen
  simpa only [SimpleGraph.Walk.length_map] using hlen

/-- Over a fixed variable, projection is injective on neighboring checks. -/
theorem neighboring_checks_project_injective (E : V → C → Prop) (s : V → C → A)
    {v : V} {c d : C} {a b e : A}
    (h : (tannerLift E s).Adj (.inl v,a) (.inr c,b))
    (h' : (tannerLift E s).Adj (.inl v,a) (.inr d,e)) (hcd : c = d) :
    ((Sum.inr c : V ⊕ C),b) = (Sum.inr d,e) := by
  subst d
  have hb : b = e := h.2.trans h'.2.symm
  subst e
  rfl

/-- A check-side triangle obstruction excludes all native six-cycles.
The hypothesis concerns base checks; fiber injectivity justifies its use. -/
theorem no_six_of_check_triangle_free (E : V → C → Prop) (s : V → C → A)
    (ht : ∀ v0 v1 v2 c0 c1 c2,
      E v0 c0 → E v0 c1 → E v1 c1 → E v1 c2 → E v2 c2 → E v2 c0 →
      c0 = c1 ∨ c1 = c2 ∨ c0 = c2) :
    ¬ HasSixCycle (tannerLift E s) := by
  rintro ⟨⟨a,af⟩,⟨b,bf⟩,⟨c,cf⟩,⟨d,df⟩,⟨e,ef⟩,⟨f,ff⟩,
    hab,hbc,hcd,hde,hef,hfa,hn⟩
  have core {v0 v1 v2 : V} {c0 c1 c2 : C} {a b c d e f : A}
      (h0 : (tannerLift E s).Adj (.inr c0,a) (.inl v0,b))
      (h1 : (tannerLift E s).Adj (.inl v0,b) (.inr c1,c))
      (h2 : (tannerLift E s).Adj (.inr c1,c) (.inl v1,d))
      (h3 : (tannerLift E s).Adj (.inl v1,d) (.inr c2,e))
      (h4 : (tannerLift E s).Adj (.inr c2,e) (.inl v2,f))
      (h5 : (tannerLift E s).Adj (.inl v2,f) (.inr c0,a))
      (hn : [((Sum.inr c0 : V ⊕ C),a),(.inl v0,b),(.inr c1,c),
        (.inl v1,d),(.inr c2,e),(.inl v2,f)].Nodup) : False := by
    have hdistinct := hn
    simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, not_or,
        not_false_eq_true, List.nodup_nil, and_true] at hdistinct
    have hc01 : ((Sum.inr c0 : V ⊕ C),a) ≠ (.inr c1,c) := hdistinct.1.2.1
    have hc12 : ((Sum.inr c1 : V ⊕ C),c) ≠ (.inr c2,e) := hdistinct.2.2.1.2.1
    have hc02 : ((Sum.inr c0 : V ⊕ C),a) ≠ (.inr c2,e) := hdistinct.1.2.2.2.1
    rcases ht v0 v1 v2 c0 c1 c2 h0.1 h1.1 h2.1 h3.1 h4.1 h5.1 with h | h | h
    · exact hc01 (neighboring_checks_project_injective E s h0.symm h1 h)
    · exact hc12 (neighboring_checks_project_injective E s h2.symm h3 h)
    · exact hc02 (neighboring_checks_project_injective E s h5 h4.symm h)
  cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
    try { simp only [not_variable_variable_adj, not_check_check_adj] at hab hbc hcd hde hef hfa }
  · have hrot := List.nodup_append_comm.mpr
      (show ([(Sum.inl _,af)] ++ [(Sum.inr _,bf),(Sum.inl _,cf),
        (Sum.inr _,df),(Sum.inl _,ef),(Sum.inr _,ff)]).Nodup from hn)
    exact core hbc hcd hde hef hfa hab hrot
  · exact core hab hbc hcd hde hef hfa hn

/-- The explicit variable/check coloring of a Tanner lift. -/
def tannerColoring (E : V → C → Prop) (s : V → C → A) :
    (tannerLift E s).Coloring Bool :=
  .mk (fun x => x.1.isLeft) (by
    rintro ⟨x,a⟩ ⟨y,b⟩ h
    cases x <;> cases y <;>
      simp_all [tannerLift, VoltageGraph.lift, bipartite, bipartiteBase])

/-- Native girth equals eight once odd cycles, four-cycles and six-cycles are excluded
and a simple eight-cycle is exhibited. -/
theorem girth_eq_eight_of_short_cycles {W : Type*} (G : SimpleGraph W)
    (color : G.Coloring Bool) (h4 : ¬HasFourCycle G) (h6 : ¬HasSixCycle G)
    {a : W} (p : G.Walk a a) (hp : p.IsCycle) (hl : p.length = 8) : G.girth = 8 := by
  have hacyc : ¬ G.IsAcyclic := fun h => h p hp
  obtain ⟨b,q,hq,hg⟩ := SimpleGraph.exists_girth_eq_length.mpr hacyc
  have hle := hp.girth_le_length
  have hmin := hq.three_le_length
  have heven : Even q.length := (color.even_length_iff_congr q).mpr Iff.rfl
  have hn4 : q.length ≠ 4 := by
    intro h
    exact h4 ((hasFourCycle_iff_native G).mpr ⟨b,q,hq,h⟩)
  have hn6 : q.length ≠ 6 := by
    intro h
    exact h6 ((hasSixCycle_iff_native G).mpr ⟨b,q,hq,h⟩)
  obtain ⟨k,hk⟩ := heven
  omega

end CyclicLift
