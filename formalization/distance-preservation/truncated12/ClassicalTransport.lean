import PureDistance
import Normalization
import PermuteSource
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords
variable {L : ℕ} [NeZero L]

/-- Coordinate equivalences preserve the actual binary classical lower-bound
predicate, including its zero-kernel/infinite-distance convention. -/
theorem classical_bound_relabel (e f : Fin 3 → Fin 4 → ZMod L)
    (a : (Fin 3 × ZMod L) ≃ (Fin 3 × ZMod L))
    (v : (Fin 4 × ZMod L) ≃ (Fin 4 × ZMod L))
    (hM : ∀ c q,GeneralLP.C f c q=GeneralLP.C e (a c) (v q))
    (D : ℕ) (hD : ClassicalAtLeast e D) : ClassicalAtLeast f D := by
  intro x hk hn
  let y := fun q => x (v.symm q)
  have hy : ∀ c,(∑ q,GeneralLP.C e c q*y q)=0 := by
    intro c
    have ht := hk (a.symm c)
    simp only [hM,Equiv.apply_symm_apply] at ht
    have he := Fintype.sum_equiv v
      (fun q => GeneralLP.C e c (v q)*x q)
      (fun q => GeneralLP.C e c q*y q) (fun q => by simp [y])
    exact he.symm.trans ht
  have hny : y≠0 := by
    intro hz
    apply hn
    funext q
    have ht := congrFun hz (v q)
    simpa [y] using ht
  have hw : (CoverWeight.support y).card=(CoverWeight.support x).card := by
    exact Finset.card_equiv v.symm (fun q => by simp [CoverWeight.support,y])
  rw [← hw]
  exact hD y hy hny

theorem transpose_bound_relabel (e f : Fin 3 → Fin 4 → ZMod L)
    (a : (Fin 3 × ZMod L) ≃ (Fin 3 × ZMod L))
    (v : (Fin 4 × ZMod L) ≃ (Fin 4 × ZMod L))
    (hM : ∀ c q,GeneralLP.C f c q=GeneralLP.C e (a c) (v q))
    (D : ℕ) (hD : TransposeAtLeast e D) : TransposeAtLeast f D := by
  intro x hk hn
  let y := fun c => x (a.symm c)
  have hy : ∀ q,(∑ c,GeneralLP.C e c q*y c)=0 := by
    intro q
    have ht := hk (v.symm q)
    simp only [hM,Equiv.apply_symm_apply] at ht
    have he := Fintype.sum_equiv a
      (fun c => GeneralLP.C e (a c) q*x c)
      (fun c => GeneralLP.C e c q*y c) (fun c => by simp [y])
    exact he.symm.trans ht
  have hny : y≠0 := by
    intro hz
    apply hn
    funext c
    have ht := congrFun hz (a c)
    simpa [y] using ht
  have hw : (CoverWeight.support y).card=(CoverWeight.support x).card := by
    exact Finset.card_equiv a.symm (fun c => by simp [CoverWeight.support,y])
  rw [← hw]
  exact hD y hy hny

theorem normalization_c_matrix (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3) (h : Fin 4) (a : Fin 3 × ZMod L) (v : Fin 4 × ZMod L) :
    GeneralLP.C (normalizeAt e r h) a v=
      GeneralLP.C e (normalizationCheck e r h a) (normalizationVariable e r v) := by
  classical
  by_cases hn : CEdge (normalizeAt e r h) v a
  · have ho := (normalization_incidence e r h v a).mp hn
    simp only [CEdge] at hn ho
    simp [GeneralLP.C,GeneralLP.P,SourceModel.P,hn,ho]
  · have ho : ¬CEdge e (normalizationVariable e r v) (normalizationCheck e r h a) :=
      fun he => hn ((normalization_incidence e r h v a).mpr he)
    simp only [CEdge] at hn ho
    simp [GeneralLP.C,GeneralLP.P,SourceModel.P,hn,ho]

theorem normalization_classical_bound (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3) (h : Fin 4) (D : ℕ) (hD : ClassicalAtLeast e D) :
    ClassicalAtLeast (normalizeAt e r h) D :=
  classical_bound_relabel e _ (normalizationCheck e r h) (normalizationVariable e r)
    (normalization_c_matrix e r h) D hD

theorem normalization_transpose_bound (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3) (h : Fin 4) (D : ℕ) (hD : TransposeAtLeast e D) :
    TransposeAtLeast (normalizeAt e r h) D :=
  transpose_bound_relabel e _ (normalizationCheck e r h) (normalizationVariable e r)
    (normalization_c_matrix e r h) D hD

theorem permutation_classical_bound (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) (D : ℕ) (hD : ClassicalAtLeast e D) :
    ClassicalAtLeast (permE e r c) D :=
  classical_bound_relabel e _ (permCCheck r) (permCVariable c) (fun _ _ => rfl) D hD

theorem permutation_transpose_bound (e : Fin 3 → Fin 4 → ZMod L)
    (r : Equiv.Perm (Fin 3)) (c : Equiv.Perm (Fin 4)) (D : ℕ) (hD : TransposeAtLeast e D) :
    TransposeAtLeast (permE e r c) D :=
  transpose_bound_relabel e _ (permCCheck r) (permCVariable c) (fun _ _ => rfl) D hD

#print axioms normalization_classical_bound
#print axioms normalization_transpose_bound
#print axioms permutation_classical_bound
#print axioms permutation_transpose_bound
end TruncatedDistance
