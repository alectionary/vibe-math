import CatalogChecker
namespace KernelCatalog
/-- Consume certificate literals directly. Array indexing repeatedly reconstructs
large array literals in kernel reduction, so the closed checker uses lists. -/
def checkList (w : Nat) : Nat → List Nat → Bool
  | _,[] => true
  | p,c::cs => checkOne w p c && checkList w (p+1) cs
end KernelCatalog
