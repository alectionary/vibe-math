import CatalogTables
import PackedTables
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
theorem perm4Value_audit : (∀ p : Fin 24, ∀ i : Fin 4, perm4Value p.val i.val=(permutations4[p.val]!)[i.val]!) := by decide +kernel
#print axioms perm4Value_audit
theorem perm3Value_audit : (∀ p : Fin 6, ∀ i : Fin 3, perm3Value p.val i.val=(permutations3[p.val]!)[i.val]!) := by decide +kernel
#print axioms perm3Value_audit
theorem centerLeafValue_audit : (∀ p : Fin 204, ∀ i : Fin 5, centerLeafValue p.val i.val=(centerLeaves[p.val]!)[i.val]!) := by decide +kernel
#print axioms centerLeafValue_audit
theorem targetArity_audit : (∀ p : Fin 64, targetArity p.val=(targets[p.val]!).size) := by decide +kernel
#print axioms targetArity_audit
theorem targetValue_audit : (∀ p : Fin 64, ∀ t : Fin (targetArity p.val), ∀ k : Fin 6, targetValue p.val t.val k.val=((targets[p.val]!)[t.val]!)[k.val]!) := by decide +kernel
#print axioms targetValue_audit
end KernelCatalog
