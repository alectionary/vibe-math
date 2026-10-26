import SparseCatalogChecker
namespace KernelCatalog
/-- The same source matching rows on natural indices, avoiding dependent
finite-index proof terms during closed kernel normalization. -/
def sourceRowNat (w p r c : Nat) : Int :=
  if r<edgeCount w then
    let e := edge w p r
    if c<6 then
      offsetCoefficient (vertex w p e.a) e.j e.i c -
        offsetCoefficient (vertex w p e.b) e.j e.i c
    else (if c=6+e.a then 1 else 0)-(if c=6+e.b then 1 else 0)
  else 0

def dotNat18 (f : Nat → Int) : Int := f 0+f 1+f 2+f 3+f 4+f 5+f 6+f 7+f 8+f 9+f 10+f 11+f 12+f 13+f 14+f 15+f 16+f 17

def certificateTargetNat (c : Certificate) (t j : Nat) : Int :=
  if j<6 then targetValue c.kind t j else 0

def checkCertificateFast (w p : Nat) (c : Certificate) : Bool :=
  decide (w=7 ∨ w=10 ∨ w=11) && decide (p<patternCount w) && decide (c.kind<64) &&
    (List.range (targetArity c.kind)).all (fun t =>
      (List.range (w+6)).all (fun j => decide
        (certificateTargetNat c t j=dotNat18 (fun i => sparseProduct (c.coeff t i) (sourceRowNat w p i j)))))
end KernelCatalog
