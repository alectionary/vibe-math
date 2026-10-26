import BucketCounts
import TorsionClassical
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

/-- Predicate form of a binary classical distance lower bound. It also gives
exactly the infinity convention when the classical kernel is zero. -/
def ClassicalAtLeast (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) : Prop :=
  ∀ x : (Fin 4 × ZMod L) → ZMod 2,
    (∀ a, (∑ q,GeneralLP.C e a q*x q)=0) → x≠0 → D≤(CoverWeight.support x).card

def TransposeAtLeast (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) : Prop :=
  ∀ y : (Fin 3 × ZMod L) → ZMod 2,
    (∀ q, (∑ a,GeneralLP.C e a q*y a)=0) → y≠0 → D≤(CoverWeight.support y).card

theorem pure_left_zero_below_classical (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ)
    (hC : ClassicalAtLeast e D) (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join u 0 q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u 0)).card<D) : u=0 := by
  have hz (j : Fin 4) : (fun p : Fin 4 × ZMod L => u j p.1 p.2)=0 := by
    by_contra hn
    have hlo := hC _ (pure_left_source_kernel e u hk j) hn
    have hsub := Finset.card_le_card (leftSupport_subset u 0 j)
    rw [leftSupport_card] at hsub
    change D≤leftCount u j at hlo
    omega
  funext j k s
  exact congrFun (hz j) (k,s)

theorem pure_right_zero_below_transpose (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ)
    (hT : TransposeAtLeast e D) (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c, (∑ q,GeneralLP.HZ e c q*GeneralLP.join 0 v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join 0 v)).card<D) : v=0 := by
  have hz (i : Fin 3) : (fun p : Fin 3 × ZMod L => v p.1 i p.2)=0 := by
    by_contra hn
    have hlo := hT _ (pure_right_transpose_kernel e v hk i) hn
    have hsub := Finset.card_le_card (rightSupport_subset 0 v i)
    rw [rightSupport_card] at hsub
    change D≤rightCount v i at hlo
    omega
  funext l i s
  exact congrFun (hz i) (l,s)

theorem torsion5_forces_classical_bound (e : Fin 3 → Fin 4 → ZMod L)
    (D : ℕ) (hC : ClassicalAtLeast e D) (c : Fin 4) (hc : c≠0)
    (h0 : ∀ i,e i 0=0) (ht : ∀ i,5 • e i c=0) : D≤10 := by
  obtain ⟨x,hk,hn,hw⟩ := source_classical_word_le10 e c hc h0 ht
  exact (hC x hk hn).trans hw

#print axioms pure_left_zero_below_classical
#print axioms pure_right_zero_below_transpose
#print axioms torsion5_forces_classical_bound
end TruncatedDistance
