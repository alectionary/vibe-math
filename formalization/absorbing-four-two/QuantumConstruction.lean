import GramCounterexample12
import FastQuantumData
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace SmallQuantum

/-- Entry of [A tensor I_7 | I_12 tensor B^T], with B given by 1+x+x^3.
The column neighborhoods use the source's transpose convention. -/
def quantumXEntry (base : Fin 12 → Finset (Fin 12)) (c : C) (v : V) : Bool :=
  if h : v.val < 84 then
    decide (c.val % 7 = v.val % 7 ∧
      (⟨c.val / 7, by have := c.isLt; omega⟩ : Fin 12) ∈
        base ⟨v.val / 7, by omega⟩)
  else
    decide (c.val / 7 = (v.val-84) / 7 ∧
      (v.val % 7 + 7 - c.val % 7) % 7 ∈ ({0,1,3} : Finset ℕ))

def quantumXColumns (base : Fin 12 → Finset (Fin 12)) (v : V) : Finset C :=
  Finset.univ.filter (fun c => quantumXEntry base c v = true)

theorem constructed_XA : quantumXColumns Absorbing42Small.baseA = XAfast := by
  have h : ∀ v c, quantumXEntry Absorbing42Small.baseA c v = true ↔ c ∈ XAfast v := by decide
  funext v
  ext c
  simpa [quantumXColumns] using h v c

theorem constructed_XB : quantumXColumns Absorbing42Small.baseB = XBfast := by
  have h : ∀ v c, quantumXEntry Absorbing42Small.baseB c v = true ↔ c ∈ XBfast v := by decide
  funext v
  ext c
  simpa [quantumXColumns] using h v c

#print axioms constructed_XA
#print axioms constructed_XB
end SmallQuantum
