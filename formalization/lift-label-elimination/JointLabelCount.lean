import JointCertificates
import FiniteEventArithmetic

set_option maxHeartbeats 0
namespace JointLabelCount
open scoped BigOperators
open CycleKernelBridge
variable (N : ℕ) [NeZero N]

def First (z : Fin 30 → ZMod N) := PaschVoltage.Balanced (StarVoltageData.dRaw z 0)
def Second (z : Fin 30 → ZMod N) := PaschVoltage.Balanced (JointCycleData.d z)

theorem first_iff (z : Fin 30 → ZMod N) : First N z ↔ Events JointCycleData.rows {0} z := by
  have hr : ∀ j k, JointCycleData.rows 0 j k=CycleData.starRaw 0 j k := by decide
  simp only [First,StarVoltageData.balancedRaw,Events,Finset.mem_singleton,forall_eq,hr]

theorem second_iff (z : Fin 30 → ZMod N) : Second N z ↔ Events JointCycleData.rows {1} z := by
  simp only [Second,JointCycleData.dual_balanced,Events,Finset.mem_singleton,forall_eq]

theorem both_iff (z : Fin 30 → ZMod N) :
    (First N z ∧ Second N z) ↔ Events JointCycleData.rows {0,1} z := by
  rw [first_iff,second_iff]
  simp only [Events,Finset.mem_singleton,Finset.mem_insert,forall_eq,forall_eq_or_imp,forall_and]

theorem first_count : Nat.card {z : Fin 30 → ZMod N // First N z}=N^27 :=
  (Nat.card_congr (Equiv.subtypeEquivRight (first_iff N))).trans (ConnectJointFirst.actual_count N)

theorem second_count : Nat.card {z : Fin 30 → ZMod N // Second N z}=N^27 :=
  (Nat.card_congr (Equiv.subtypeEquivRight (second_iff N))).trans (ConnectJointDual.actual_count N)

theorem both_count : Nat.card {z : Fin 30 → ZMod N // First N z ∧ Second N z}=N^24 :=
  (Nat.card_congr (Equiv.subtypeEquivRight (both_iff N))).trans (ConnectJointBoth.actual_count N)

/-- Exact all-N count of raw label arrays killing the star and dual-star balance events. -/
theorem avoiding_both : (Nat.card {z : Fin 30 → ZMod N // ¬First N z ∧ ¬Second N z} : ℤ)=
    (N : ℤ)^30-2*(N : ℤ)^27+(N : ℤ)^24 := by
  classical
  rw [FiniteEventArithmetic.avoid_two,first_count,second_count,both_count,
    Nat.card_eq_fintype_card,Fintype.card_fun,ZMod.card,Fintype.card_fin,Nat.cast_pow]
  simp only [Nat.cast_pow]
  ring

#print axioms first_count
#print axioms second_count
#print axioms both_count
#print axioms avoiding_both
end JointLabelCount
