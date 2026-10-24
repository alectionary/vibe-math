import VoltageQCIncidence

set_option maxHeartbeats 0
namespace QCRegularity
open VoltageQCIncidence
variable {U C E G : Type*} [DecidableEq U] [DecidableEq C] [DecidableEq E]
  [DecidableEq G] [Fintype U] [Fintype C] [Fintype E] [Fintype G] [AddCommGroup G]

theorem cubic (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (hdH : ∀ u, (H u).card=3) (hdB : ∀ e, (B e).card=3)
    (v : Sum (U × G) (C × E)) : (columns H z B v).card=3 := by
  cases v with
  | inl v => exact PaschLiftProjection.cubic H z hdH v
  | inr v => simp [columns,Finset.card_product,hdB]

theorem mixed_linear (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (v : U × G) (r : C × E) :
    (columns H z B (.inl v) ∩ columns H z B (.inr r)).card≤1 := by
  apply Finset.card_le_one.mpr
  intro a ha b hb
  have hal := (Finset.mem_inter.mp ha).1
  have hbl := (Finset.mem_inter.mp hb).1
  have har : a.1=r.1 ∧ a.2∈B r.2 := by
    simpa only [columns,Finset.mem_product,Finset.mem_singleton] using (Finset.mem_inter.mp ha).2
  have hbr : b.1=r.1 ∧ b.2∈B r.2 := by
    simpa only [columns,Finset.mem_product,Finset.mem_singleton] using (Finset.mem_inter.mp hb).2
  have hal' := (PaschLiftProjection.mem_columns H z v a.1 a.2).mp hal
  have hbl' := (PaschLiftProjection.mem_columns H z v b.1 b.2).mp hbl
  exact Prod.ext (har.1.trans hbr.1.symm) (by rw [hal'.2,hbl'.2,har.1,hbr.1])

theorem right_linear (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4B : ∀ a b, a≠b → (B a ∩ B b).card≤1)
    (v w : C × E) (hvw : v≠w) :
    (columns H z B (.inr v) ∩ columns H z B (.inr w)).card≤1 := by
  by_cases hc : v.1=w.1
  · have he : v.2≠w.2 := fun h => hvw (Prod.ext hc h)
    change (({v.1} ×ˢ B v.2) ∩ ({w.1} ×ˢ B w.2)).card≤1
    rw [hc,← Finset.product_inter,Finset.card_product,Finset.card_singleton,one_mul]
    exact h4B _ _ he
  · have hh : columns H z B (.inr v) ∩ columns H z B (.inr w)=∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro a ha
      have hv : a.1=v.1 := by
        exact Finset.mem_singleton.mp (Finset.mem_product.mp (Finset.mem_inter.mp ha).1).1
      have hw : a.1=w.1 := by
        exact Finset.mem_singleton.mp (Finset.mem_product.mp (Finset.mem_inter.mp ha).2).1
      exact hc (hv.symm.trans hw)
    rw [hh]; exact Nat.zero_le _

theorem linear (H : U → Finset C) (z : U → C → G) (B : E → Finset G)
    (h4H : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (h4B : ∀ a b, a≠b → (B a ∩ B b).card≤1)
    (v w : Sum (U × G) (C × E)) (hvw : v≠w) :
    (columns H z B v ∩ columns H z B w).card≤1 := by
  cases v with
  | inl v =>
    cases w with
    | inl w => exact PaschLiftProjection.linear H z h4H v w (fun h => hvw (congrArg Sum.inl h))
    | inr w => exact mixed_linear H z B v w
  | inr v =>
    cases w with
    | inl w => rw [Finset.inter_comm]; exact mixed_linear H z B w v
    | inr w => exact right_linear H z B h4B v w (fun h => hvw (congrArg Sum.inr h))

#print axioms cubic
#print axioms linear
end QCRegularity
