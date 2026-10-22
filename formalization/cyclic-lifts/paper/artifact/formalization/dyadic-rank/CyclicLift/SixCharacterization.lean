module

public import CyclicLift.ShortCycles

@[expose] public section
namespace CyclicLift
variable {V C A : Type*} [AddCommGroup A]

/-- Over a fixed check, projection is injective on neighboring variables. -/
theorem neighboring_variables_project_injective (E : V → C → Prop) (s : V → C → A)
    {v w : V} {c : C} {a b d : A}
    (h : (tannerLift E s).Adj (.inl v,a) (.inr c,b))
    (h' : (tannerLift E s).Adj (.inl w,d) (.inr c,b)) (hvw : v = w) :
    ((Sum.inl v : V ⊕ C),a) = (Sum.inl w,d) := by
  subst w
  have ha : a = d := add_right_cancel (h.2.symm.trans h'.2)
  subst d
  rfl

/-- Six distinct lifted vertices force distinct projected triples on both sides.
Every pair in either triple shares a neighbor; permutation fibers exclude a collapse. -/
theorem hexagon_of_six_edges (E : V → C → Prop) (s : V → C → A)
    {v0 v1 v2 : V} {c0 c1 c2 : C} {a b d e f g : A}
    (h0 : (tannerLift E s).Adj (.inl v0,a) (.inr c0,b))
    (h1 : (tannerLift E s).Adj (.inr c0,b) (.inl v1,d))
    (h2 : (tannerLift E s).Adj (.inl v1,d) (.inr c1,e))
    (h3 : (tannerLift E s).Adj (.inr c1,e) (.inl v2,f))
    (h4 : (tannerLift E s).Adj (.inl v2,f) (.inr c2,g))
    (h5 : (tannerLift E s).Adj (.inr c2,g) (.inl v0,a))
    (hn : [((Sum.inl v0 : V ⊕ C),a),(.inr c0,b),(.inl v1,d),
      (.inr c1,e),(.inl v2,f),(.inr c2,g)].Nodup) :
    v0 ≠ v1 ∧ v1 ≠ v2 ∧ v0 ≠ v2 ∧ c0 ≠ c1 ∧ c1 ≠ c2 ∧ c0 ≠ c2 ∧
      hexagonVoltage s v0 v1 v2 c0 c1 c2 = 0 := by
  have hd := hn
  simp only [List.nodup_cons, List.mem_cons, List.not_mem_nil, not_or,
    not_false_eq_true, List.nodup_nil, and_true] at hd
  refine ⟨?_,?_,?_,?_,?_,?_,?_⟩
  · intro h; exact hd.1.2.1 (neighboring_variables_project_injective E s h0 h1.symm h)
  · intro h; exact hd.2.2.1.2.1 (neighboring_variables_project_injective E s h2 h3.symm h)
  · intro h; exact hd.1.2.2.2.1 (neighboring_variables_project_injective E s h5.symm h4 h)
  · intro h; exact hd.2.1.2.1 (neighboring_checks_project_injective E s h1.symm h2 h)
  · intro h; exact hd.2.2.2.1.2 (neighboring_checks_project_injective E s h3.symm h4 h)
  · intro h; exact hd.2.1.2.2.2 (neighboring_checks_project_injective E s h0 h5.symm h)
  · have hh := (bipartite E s).endpoint_fiber (sixWalk h0 h1 h2 h3 h4 h5)
    change a = a + (s v0 c0 + (-s v1 c0 + (s v1 c1 +
      (-s v2 c1 + (s v2 c2 + (-s v0 c2 + 0)))))) at hh
    simpa only [hexagonVoltage, sub_eq_add_neg, add_assoc, add_zero] using
      (add_eq_left.mp hh.symm)

/-- Complete simple-six-cycle criterion for sparse permutation lifts.
Unlike longer cycles, a simple six-cycle cannot repeat a projected vertex on either side. -/
theorem hasSixCycle_iff_hexagon (E : V → C → Prop) (s : V → C → A) :
    HasSixCycle (tannerLift E s) ↔ ∃ v0 v1 v2 c0 c1 c2,
      v0 ≠ v1 ∧ v1 ≠ v2 ∧ v0 ≠ v2 ∧ c0 ≠ c1 ∧ c1 ≠ c2 ∧ c0 ≠ c2 ∧
      E v0 c0 ∧ E v1 c0 ∧ E v1 c1 ∧ E v2 c1 ∧ E v2 c2 ∧ E v0 c2 ∧
      hexagonVoltage s v0 v1 v2 c0 c1 c2 = 0 := by
  constructor
  · rintro ⟨⟨a,af⟩,⟨b,bf⟩,⟨c,cf⟩,⟨d,df⟩,⟨e,ef⟩,⟨f,ff⟩,
      hab,hbc,hcd,hde,hef,hfa,hn⟩
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;>
      try { simp only [not_variable_variable_adj, not_check_check_adj] at hab hbc hcd hde hef hfa }
    · obtain ⟨hv01,hv12,hv02,hc01,hc12,hc02,hz⟩ :=
        hexagon_of_six_edges E s hab hbc hcd hde hef hfa hn
      exact ⟨_,_,_,_,_,_,hv01,hv12,hv02,hc01,hc12,hc02,
        hab.1,hbc.1,hcd.1,hde.1,hef.1,hfa.1,hz⟩
    · have hrot := List.nodup_append_comm.mpr
        (show ([(Sum.inr _,af)] ++ [(Sum.inl _,bf),(Sum.inr _,cf),(Sum.inl _,df),
          (Sum.inr _,ef),(Sum.inl _,ff)]).Nodup from hn)
      obtain ⟨hv01,hv12,hv02,hc01,hc12,hc02,hz⟩ :=
        hexagon_of_six_edges E s hbc hcd hde hef hfa hab hrot
      exact ⟨_,_,_,_,_,_,hv01,hv12,hv02,hc01,hc12,hc02,
        hbc.1,hcd.1,hde.1,hef.1,hfa.1,hab.1,hz⟩
  · rintro ⟨v0,v1,v2,c0,c1,c2,hv01,hv12,hv02,hc01,hc12,hc02,
      h00,h10,h11,h21,h22,h02,hz⟩
    obtain ⟨q,hq,hl⟩ := hexagon_gives_six_cycle E s v0 v1 v2 c0 c1 c2 0
      hv01 hv12 hv02 hc01 hc12 hc02 h00 h10 h11 h21 h22 h02 hz
    exact (hasSixCycle_iff_native _).mpr ⟨_,q,hq,hl⟩

variable {I J : Type*} {r : ℕ}

/-- Alternating sum of an ordinary base hexagon, in row/column coordinates. -/
def baseHexagon (B : I → J → ZMod r) (i0 i1 i2 : I) (j0 j1 j2 : J) : ZMod r :=
  B i0 j0 - B i0 j1 + B i1 j1 - B i1 j2 + B i2 j2 - B i2 j0

/-- All six-cycles of the lifted-product X graph come from one variable-block family.
Mixed families would identify two base checks. Both pure families reduce to base hexagons. -/
theorem xGraph_hasSixCycle_iff (B : I → J → ZMod r) :
    HasSixCycle (xGraph B) ↔ ∃ i0 i1 i2 j0 j1 j2,
      i0 ≠ i1 ∧ i1 ≠ i2 ∧ i0 ≠ i2 ∧ j0 ≠ j1 ∧ j1 ≠ j2 ∧ j0 ≠ j2 ∧
      baseHexagon B i0 i1 i2 j0 j1 j2 = 0 := by
  change HasSixCycle (tannerLift xSupport (xLabel B)) ↔ _
  rw [hasSixCycle_iff_hexagon]
  constructor
  · rintro ⟨v0,v1,v2,⟨i0,j0⟩,⟨i1,j1⟩,⟨i2,j2⟩,
      hv01,hv12,hv02,hc01,hc12,hc02,h00,h10,h11,h21,h22,h02,hz⟩
    rcases v0 with ⟨k0,t0⟩ | ⟨t0,l0⟩ <;>
      rcases v1 with ⟨k1,t1⟩ | ⟨t1,l1⟩ <;>
      rcases v2 with ⟨k2,t2⟩ | ⟨t2,l2⟩ <;>
      simp only [xSupport] at h00 h10 h11 h21 h22 h02
    · subst j0; subst t1; subst j1; subst t2; subst j2
      refine ⟨i0,i1,i2,k0,k1,k2,?_,?_,?_,?_,?_,?_,hz⟩
      · intro h; subst i1; exact hc01 rfl
      · intro h; subst i2; exact hc12 rfl
      · intro h; subst i2; exact hc02 rfl
      · intro h; subst k1; exact hv01 rfl
      · intro h; subst k2; exact hv12 rfl
      · intro h; subst k2; exact hv02 rfl
    · exact False.elim (hc12 (by apply Prod.ext <;> grind))
    · exact False.elim (hc01 (by apply Prod.ext <;> grind))
    · exact False.elim (hc02 (by apply Prod.ext <;> grind))
    · exact False.elim (hc02 (by apply Prod.ext <;> grind))
    · exact False.elim (hc01 (by apply Prod.ext <;> grind))
    · exact False.elim (hc12 (by apply Prod.ext <;> grind))
    · subst i0; subst t1; subst i1; subst t2; subst i2
      refine ⟨l0,l2,l1,j0,j2,j1,?_,?_,?_,?_,?_,?_,?_⟩
      · intro h; subst l2; exact hv02 rfl
      · intro h; subst l2; exact hv12 rfl
      · intro h; subst l1; exact hv01 rfl
      · intro h; subst j2; exact hc02 rfl
      · intro h; subst j2; exact hc12 rfl
      · intro h; subst j1; exact hc01 rfl
      · have he : hexagonVoltage (xLabel B) (.inr (t0,l0)) (.inr (t0,l1))
            (.inr (t0,l2)) (t0,j0) (t0,j1) (t0,j2) =
            -baseHexagon B l0 l2 l1 j0 j2 j1 := by
          simp only [hexagonVoltage, xLabel, baseHexagon, sub_eq_add_neg,
            neg_add_rev, neg_neg]
          abel
        rw [he, neg_eq_zero] at hz
        exact hz
  · rintro ⟨i0,i1,i2,j0,j1,j2,hi01,hi12,hi02,hj01,hj12,hj02,hz⟩
    refine ⟨.inl (j0,j0),.inl (j1,j0),.inl (j2,j0),
      (i0,j0),(i1,j0),(i2,j0),?_,?_,?_,?_,?_,?_,rfl,rfl,rfl,rfl,rfl,rfl,hz⟩
    · intro h; exact hj01 (congrArg Prod.fst (Sum.inl.inj h))
    · intro h; exact hj12 (congrArg Prod.fst (Sum.inl.inj h))
    · intro h; exact hj02 (congrArg Prod.fst (Sum.inl.inj h))
    · intro h; exact hi01 (congrArg Prod.fst h)
    · intro h; exact hi12 (congrArg Prod.fst h)
    · intro h; exact hi02 (congrArg Prod.fst h)

/-- Native simple-cycle form of the complete source-matrix six-cycle test. -/
theorem xGraph_native_sixCycle_iff (B : I → J → ZMod r) :
    (∃ v, ∃ p : (xGraph B).Walk v v, p.IsCycle ∧ p.length = 6) ↔
      ∃ i0 i1 i2 j0 j1 j2, i0 ≠ i1 ∧ i1 ≠ i2 ∧ i0 ≠ i2 ∧
        j0 ≠ j1 ∧ j1 ≠ j2 ∧ j0 ≠ j2 ∧ baseHexagon B i0 i1 i2 j0 j1 j2 = 0 := by
  rw [← hasSixCycle_iff_native, xGraph_hasSixCycle_iff]

end CyclicLift
