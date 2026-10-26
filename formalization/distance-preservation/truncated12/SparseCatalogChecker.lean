import CatalogChecker
namespace KernelCatalog
/-- Explicit integer coefficients avoid repeatedly decoding packed data inside
kernel normalization. Their generation is untrusted: the checker tests them. -/
structure Certificate where
  kind : Nat
  coeff : Nat → Nat → Int

def certificateTarget (w : Nat) (c : Certificate) (t : Fin (targetArity c.kind))
    (j : Fin (w+6)) : Int := if j.val<6 then targetValue c.kind t.val j.val else 0

def sparseProduct (a b : Int) : Int := if a=0 then 0 else a*b

def checkCertificate (w p : Nat) (c : Certificate) : Bool :=
  decide (w=7 ∨ w=10 ∨ w=11) && decide (p<patternCount w) && decide (c.kind<64) &&
    decide (∀ t : Fin (targetArity c.kind), ∀ j : Fin (w+6),
      certificateTarget w c t j=dot18 (fun i => sparseProduct (c.coeff t.val i.val) (sourceRow w p i j)))
end KernelCatalog
