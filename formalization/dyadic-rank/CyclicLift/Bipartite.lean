module

public import CyclicLift.Basic

@[expose] public section

namespace CyclicLift

variable {V C A : Type*} [AddCommGroup A]

/-- The base graph has variable vertices on the left and check vertices on the right. -/
def bipartiteBase (E : V → C → Prop) : SimpleGraph (V ⊕ C) where
  Adj x y := match x, y with
    | .inl v, .inr c => E v c
    | .inr c, .inl v => E v c
    | _, _ => False
  symm := ⟨by intro x y h; cases x <;> cases y <;> exact h⟩
  loopless := ⟨by intro x; cases x <;> exact not_false⟩

/-- Positive labels go from variables to checks, as in P34 Equation (2.1). -/
def bipartiteVoltage (s : V → C → A) : (V ⊕ C) → (V ⊕ C) → A
  | .inl v, .inr c => s v c
  | .inr c, .inl v => -s v c
  | _, _ => 0

def bipartite (E : V → C → Prop) (s : V → C → A) : VoltageGraph (V ⊕ C) A where
  base := bipartiteBase E
  voltage := bipartiteVoltage s
  reverse := by intro u v; cases u <;> cases v <;> simp [bipartiteVoltage]

abbrev tannerLift (E : V → C → Prop) (s : V → C → A) := (bipartite E s).lift

@[simp] theorem variable_check_adj (E : V → C → Prop) (s : V → C → A)
    (v : V) (c : C) (a b : A) :
    (tannerLift E s).Adj (.inl v, a) (.inr c, b) ↔ E v c ∧ b = a + s v c := Iff.rfl

@[simp] theorem check_variable_adj (E : V → C → Prop) (s : V → C → A)
    (v : V) (c : C) (a b : A) :
    (tannerLift E s).Adj (.inr c, b) (.inl v, a) ↔ E v c ∧ b = a + s v c := by
  rw [SimpleGraph.adj_comm]
  rfl

@[simp] theorem not_variable_variable_adj (E : V → C → Prop) (s : V → C → A)
    (v w : V) (a b : A) : ¬(tannerLift E s).Adj (.inl v, a) (.inl w, b) :=
  fun h => h.1

@[simp] theorem not_check_check_adj (E : V → C → Prop) (s : V → C → A)
    (c d : C) (a b : A) : ¬(tannerLift E s).Adj (.inr c, a) (.inr d, b) :=
  fun h => h.1

/-- The oriented voltage around v0-c0-v1-c1-v0. -/
def rectangleVoltage (s : V → C → A) (v0 v1 : V) (c0 c1 : C) : A :=
  s v0 c0 - s v1 c0 + s v1 c1 - s v0 c1

/-- A supported rectangle closes in the lift exactly when its alternating label sum vanishes.
Distinctness is deliberately absent: closure alone does not assert a simple cycle. -/
theorem rectangle_closes_iff (E : V → C → Prop) (s : V → C → A)
    (v0 v1 : V) (c0 c1 : C) (a : A)
    (h00 : E v0 c0) (h10 : E v1 c0) (h11 : E v1 c1) (h01 : E v0 c1) :
    (∃ b d e, (tannerLift E s).Adj (.inl v0, a) (.inr c0, b) ∧
      (tannerLift E s).Adj (.inr c0, b) (.inl v1, d) ∧
      (tannerLift E s).Adj (.inl v1, d) (.inr c1, e) ∧
      (tannerLift E s).Adj (.inr c1, e) (.inl v0, a)) ↔
      rectangleVoltage s v0 v1 c0 c1 = 0 := by
  simp only [variable_check_adj, check_variable_adj]
  constructor
  · rintro ⟨b, d, e, ⟨_, hb⟩, ⟨_, hd⟩, ⟨_, he⟩, ⟨_, ha⟩⟩
    have hda : d = a + s v0 c0 - s v1 c0 := by
      apply eq_sub_iff_add_eq.mpr
      rw [← hb]
      exact hd.symm
    have hz : a + rectangleVoltage s v0 v1 c0 c1 = a := by
      calc
        _ = (a + s v0 c0 - s v1 c0) + s v1 c1 - s v0 c1 := by
          unfold rectangleVoltage; abel
        _ = d + s v1 c1 - s v0 c1 := by rw [← hda]
        _ = a := by rw [← he, ha]; simp
    exact add_eq_left.mp hz
  · intro hz
    have hsum : s v0 c0 - s v1 c0 + s v1 c1 = s v0 c1 :=
      sub_eq_zero.mp hz
    refine ⟨a + s v0 c0, a + s v0 c0 - s v1 c0,
      (a + s v0 c0 - s v1 c0) + s v1 c1,
      ⟨h00, rfl⟩, ⟨h10, ?_⟩, ⟨h11, rfl⟩, ⟨h01, ?_⟩⟩
    · abel
    · calc
        _ = a + (s v0 c0 - s v1 c0 + s v1 c1) := by abel
        _ = _ := by rw [hsum]

/-- A supported rectangle with distinct variables and checks and zero voltage gives
an actual Mathlib simple cycle of length four, not merely a closed walk. -/
theorem rectangle_gives_four_cycle (E : V → C → Prop) (s : V → C → A)
    (v0 v1 : V) (c0 c1 : C) (a : A)
    (hv : v0 ≠ v1) (hc : c0 ≠ c1)
    (h00 : E v0 c0) (h10 : E v1 c0) (h11 : E v1 c1) (h01 : E v0 c1)
    (hz : rectangleVoltage s v0 v1 c0 c1 = 0) :
    ∃ p : (tannerLift E s).Walk (.inl v0, a) (.inl v0, a),
      p.IsCycle ∧ p.length = 4 := by
  obtain ⟨b, d, e, hab, hbc, hcd, hda⟩ :=
    (rectangle_closes_iff E s v0 v1 c0 c1 a h00 h10 h11 h01).mpr hz
  refine ⟨fourWalk hab hbc hcd hda, fourWalk_isCycle hab hbc hcd hda ?_ ?_, rfl⟩
  · intro h; exact hv (Sum.inl.inj (congrArg Prod.fst h))
  · intro h; exact hc (Sum.inr.inj (congrArg Prod.fst h))

/-- A genuine alternating four-cycle cannot identify either pair of base vertices:
permutation fibers would then identify the corresponding lifted vertices as well. -/
theorem rectangle_of_four_edges (E : V → C → Prop) (s : V → C → A)
    {v0 v1 : V} {c0 c1 : C} {a b d e : A}
    (hab : (tannerLift E s).Adj (.inl v0, a) (.inr c0, b))
    (hbc : (tannerLift E s).Adj (.inr c0, b) (.inl v1, d))
    (hcd : (tannerLift E s).Adj (.inl v1, d) (.inr c1, e))
    (hda : (tannerLift E s).Adj (.inr c1, e) (.inl v0, a))
    (hvd : ((Sum.inl v0 : V ⊕ C), a) ≠ (Sum.inl v1, d))
    (hce : ((Sum.inr c0 : V ⊕ C), b) ≠ (Sum.inr c1, e)) :
    v0 ≠ v1 ∧ c0 ≠ c1 ∧ rectangleVoltage s v0 v1 c0 c1 = 0 := by
  have h0 := (variable_check_adj E s v0 c0 a b).mp hab
  have h1 := (check_variable_adj E s v1 c0 d b).mp hbc
  have h2 := (variable_check_adj E s v1 c1 d e).mp hcd
  have h3 := (check_variable_adj E s v0 c1 a e).mp hda
  refine ⟨?_, ?_, ?_⟩
  · intro hv
    subst v1
    have had : a = d := add_right_cancel (h0.2.symm.trans h1.2)
    exact hvd (by subst d; rfl)
  · intro hc
    subst c1
    have hbe : b = e := h0.2.trans h3.2.symm
    exact hce (by subst e; rfl)
  · exact (rectangle_closes_iff E s v0 v1 c0 c1 a h0.1 h1.1 h2.1 h3.1).mp
      ⟨b, d, e, hab, hbc, hcd, hda⟩

/-- Complete four-cycle criterion, including sparse support and all fiber choices. -/
theorem hasFourCycle_iff_rectangle (E : V → C → Prop) (s : V → C → A) :
    HasFourCycle (tannerLift E s) ↔
      ∃ v0 v1 c0 c1, v0 ≠ v1 ∧ c0 ≠ c1 ∧ E v0 c0 ∧ E v1 c0 ∧
        E v1 c1 ∧ E v0 c1 ∧ rectangleVoltage s v0 v1 c0 c1 = 0 := by
  constructor
  · rintro ⟨⟨x, a⟩, ⟨y, b⟩, ⟨z, d⟩, ⟨w, e⟩, hab, hbc, hcd, hda, hxd, hye⟩
    cases x <;> cases y <;> cases z <;> cases w <;>
      try { simp only [not_variable_variable_adj, not_check_check_adj] at hab hbc hcd hda }
    · obtain ⟨hv, hc, hz⟩ := rectangle_of_four_edges E s hab hbc hcd hda hxd hye
      exact ⟨_, _, _, _, hv, hc, hab.1, hbc.1, hcd.1, hda.1, hz⟩
    · obtain ⟨hv, hc, hz⟩ := rectangle_of_four_edges E s hbc hcd hda hab hye (Ne.symm hxd)
      exact ⟨_, _, _, _, hv, hc, hbc.1, hcd.1, hda.1, hab.1, hz⟩
  · rintro ⟨v0, v1, c0, c1, hv, hc, h00, h10, h11, h01, hz⟩
    obtain ⟨b, d, e, hab, hbc, hcd, hda⟩ :=
      (rectangle_closes_iff E s v0 v1 c0 c1 0 h00 h10 h11 h01).mpr hz
    refine ⟨(.inl v0, 0), (.inr c0, b), (.inl v1, d), (.inr c1, e),
      hab, hbc, hcd, hda, ?_, ?_⟩
    · intro h; exact hv (Sum.inl.inj (congrArg Prod.fst h))
    · intro h; exact hc (Sum.inr.inj (congrArg Prod.fst h))

end CyclicLift
