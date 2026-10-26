import CatalogChecker
import FastCatalogChecker
import IntegerSoundness
set_option maxHeartbeats 0
namespace KernelCatalog

theorem dot18_eq_sum (f : Fin 18 → Int) : dot18 f=∑ i,f i := by
  simp [dot18,Fin.sum_univ_succ,add_assoc]

/-- The reflective check supplies exact integer identities to the already
proved additive-group soundness theorem. -/
theorem checked_equations {A : Type*} [AddCommGroup A] (w p code : Nat)
    (hc : checkOne w p code=true) (x : Fin (w+6) → A)
    (hr : ∀ i : Fin 18, TruncatedDistance.integerDot (sourceRow w p i) x=0) :
    ∀ t : Fin (arity code), TruncatedDistance.integerDot (target w code t) x=0 := by
  have hcert : ∀ t : Fin (arity code), ∀ j : Fin (w+6),
      target w code t j=∑ i : Fin 18, coefficient code t.val i.val * sourceRow w p i j := by
    have h := of_decide_eq_true ((Bool.and_eq_true_iff.mp hc).2)
    simpa only [dot18_eq_sum] using h
  intro t
  exact TruncatedDistance.integer_certificate_sound (sourceRow w p)
    (fun i => coefficient code t.val i.val) (target w code t) x hr (hcert t)

theorem checked_block_entry (w offset : Nat) (data : Array Nat)
    (h : checkBlock w offset data=true) (i : Fin data.size) :
    checkOne w (offset+i.val) data[i.val]! = true := by
  exact List.all_eq_true.mp h i.val (List.mem_range.mpr i.isLt)


theorem sourceRowNat_eq (w p : Nat) (r : Fin 18) (j : Fin (w+6)) :
    sourceRowNat w p r.val j.val=sourceRow w p r j := rfl

theorem dotNat18_eq_sum (f : Nat → Int) : dotNat18 f=∑ i : Fin 18,f i.val := by
  simp [dotNat18,Fin.sum_univ_succ,add_assoc]

theorem sparseProduct_eq (a b : Int) : sparseProduct a b=a*b := by
  by_cases h : a=0 <;> simp [sparseProduct,h]

/-- The Nat-indexed checker is interpreted in the same complete source matching
matrix. Its finite range loops prove every needed entry equation. -/
theorem checked_fast_equations {A : Type*} [AddCommGroup A]
    (w p : Nat) (c : Certificate) (hc : checkCertificateFast w p c=true)
    (x : Fin (w+6) → A)
    (hr : ∀ i : Fin 18, TruncatedDistance.integerDot (sourceRow w p i) x=0) :
    ∀ t : Fin (targetArity c.kind),
      TruncatedDistance.integerDot (certificateTarget w c t) x=0 := by
  have hcert (t : Fin (targetArity c.kind)) (j : Fin (w+6)) :
      certificateTarget w c t j=∑ i : Fin 18,c.coeff t.val i.val*sourceRow w p i j := by
    have ht := List.all_eq_true.mp ((Bool.and_eq_true_iff.mp hc).2)
      t.val (List.mem_range.mpr t.isLt)
    have hj := List.all_eq_true.mp ht j.val (List.mem_range.mpr j.isLt)
    have heq := of_decide_eq_true hj
    simpa only [certificateTarget,certificateTargetNat,dotNat18_eq_sum,
      sparseProduct_eq,sourceRowNat_eq] using heq
  intro t
  exact TruncatedDistance.integer_certificate_sound (sourceRow w p)
    (fun i => c.coeff t.val i.val) (certificateTarget w c t) x hr (hcert t)

#print axioms checked_fast_equations

#print axioms checked_equations
end KernelCatalog
