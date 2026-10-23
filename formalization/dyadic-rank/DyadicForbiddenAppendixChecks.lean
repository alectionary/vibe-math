module

public import DyadicForbiddenAppendix

@[expose] public section

namespace DyadicForbidden.AppendixChecks

open DyadicForbidden DyadicForbidden.Appendix

set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Kernel evaluation of the literal appendix enumerator, including the
even-occurrence doubled rectangle at threshold eight. -/
theorem appendix_execution :
    appendixForbiddenCheck threeZeroBlocks (1,1) 4 0 = true ∧
    appendixForbiddenCheck threeZeroBlocks (1,1) 4 1 = false ∧
    appendixForbiddenCheck threeZeroBlocks (1,1) 6 1 = false ∧
    appendixForbiddenCheck threeZeroBlocks (1,1) 8 1 = true := by decide

/-- The low-row boundary needs no fictitious four-row embedding. -/
theorem appendix_empty_rows :
    appendixCheck (fun (_ : Fin 1) (_ : Fin 0) => False)
      (fun _ _ => (0 : ZMod 2)) 8 = false := by decide

#print axioms appendix_execution
#print axioms appendix_empty_rows

end DyadicForbidden.AppendixChecks
