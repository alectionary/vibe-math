import HGPSpectral
import IncidenceEquivalence
import QuantumConstruction
import Mathlib.Logic.Equiv.Fin.Basic
set_option maxHeartbeats 0
set_option maxRecDepth 10000
namespace QuantumReindex

def checkEquiv : (Fin 12 × Fin 7) ≃ Fin 84 := finProdFinEquiv

def variableEquiv : Sum (Fin 12 × Fin 7) (Fin 12 × Fin 7) ≃ Fin 168 :=
  (Equiv.sumCongr (finProdFinEquiv : (Fin 12 × Fin 7) ≃ Fin 84)
    (finProdFinEquiv : (Fin 12 × Fin 7) ≃ Fin 84)).trans finSumFinEquiv

theorem source_A_bridge : ∀ v,
    SmallQuantum.quantumXColumns Absorbing42Small.baseA (variableEquiv v) =
      (HGPCounts.Concrete.XA v).image checkEquiv := by decide

theorem source_B_bridge : ∀ v,
    SmallQuantum.quantumXColumns Absorbing42Small.baseB (variableEquiv v) =
      (HGPCounts.Concrete.XB v).image checkEquiv := by decide

theorem source_A_count :
    GlobalCounting.count42 (SmallQuantum.quantumXColumns Absorbing42Small.baseA) = 49 := by
  rw [← IncidenceEquivalence.count42_eq HGPCounts.Concrete.XA _ variableEquiv checkEquiv source_A_bridge]
  exact HGPCounts.Concrete.full_A_count

theorem source_B_count :
    GlobalCounting.count42 (SmallQuantum.quantumXColumns Absorbing42Small.baseB) = 35 := by
  rw [← IncidenceEquivalence.count42_eq HGPCounts.Concrete.XB _ variableEquiv checkEquiv source_B_bridge]
  exact HGPCounts.Concrete.full_B_count

theorem literal_A_count : GlobalCounting.count42 SmallQuantum.XA = 49 := by
  have h := source_A_count
  rw [SmallQuantum.constructed_XA,SmallQuantum.XAfast_eq] at h
  exact h

theorem literal_B_count : GlobalCounting.count42 SmallQuantum.XB = 35 := by
  have h := source_B_count
  rw [SmallQuantum.constructed_XB,SmallQuantum.XBfast_eq] at h
  exact h

#print axioms source_A_bridge
#print axioms source_B_bridge
#print axioms literal_A_count
#print axioms literal_B_count
end QuantumReindex
