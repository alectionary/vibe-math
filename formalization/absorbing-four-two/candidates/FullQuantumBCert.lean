import FastQuantumData
import PairRootBridge
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace SmallQuantum
 theorem degree_B : ∀ v, (XBfast v).card = 3 := by decide
 theorem no_four_B : ∀ u v, u ≠ v → ((XBfast u) ∩ (XBfast v)).card ≤ 1 := by decide
 theorem root_mass_Bfast : PairFormula.rootPairSum XBfast = 140 := by decide
 theorem full_count_Bfast : GlobalCounting.count42 XBfast = 35 := by
   have h := PairRootBridge.rootPairSum_eq_four_count42 XBfast degree_B no_four_B
   rw [root_mass_Bfast] at h
   omega
 theorem full_count_B : GlobalCounting.count42 XB = 35 := by
   rw [← XBfast_eq]
   exact full_count_Bfast
 #print axioms degree_B
 #print axioms no_four_B
 #print axioms root_mass_Bfast
 #print axioms full_count_B
end SmallQuantum
