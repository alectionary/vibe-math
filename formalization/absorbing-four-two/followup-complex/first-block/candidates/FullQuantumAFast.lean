import FastQuantumData
import PairRootBridge
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace SmallQuantum
 theorem degree_A : ∀ v, (XAfast v).card = 3 := by decide
 theorem no_four_A : ∀ u v, u ≠ v → ((XAfast u) ∩ (XAfast v)).card ≤ 1 := by decide
 theorem root_mass_Afast : PairFormula.rootPairSum XAfast = 196 := by decide
 theorem full_count_Afast : GlobalCounting.count42 XAfast = 49 := by
   have h := PairRootBridge.rootPairSum_eq_four_count42 XAfast degree_A no_four_A
   rw [root_mass_Afast] at h
   omega
 theorem full_count_A : GlobalCounting.count42 XA = 49 := by
   rw [← XAfast_eq]
   exact full_count_Afast
 #print axioms degree_A
 #print axioms no_four_A
 #print axioms root_mass_Afast
 #print axioms full_count_A
end SmallQuantum
