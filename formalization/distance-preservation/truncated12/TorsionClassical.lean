import GeneralLPPhysical
import Mathlib.GroupTheory.SpecificGroups.Cyclic.Subgroup
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : Nat} [NeZero L]

def torsionSet (n : ℕ) : Finset (ZMod L) :=
  Finset.univ.filter (fun s => n • s = 0)

theorem torsion_card_le (n : ℕ) (hn : 0 < n) :
    (torsionSet (L := L) n).card ≤ n := by
  simpa [torsionSet] using
    (IsAddCyclic.card_nsmul_eq_zero_le (α := ZMod L) hn)

def torsionBit (n : ℕ) (s : ZMod L) : ZMod 2 := if n • s = 0 then 1 else 0

def torsionWord (n : ℕ) (c : Fin 4) (q : Fin 4 × ZMod L) : ZMod 2 :=
  (if q.1 = 0 then torsionBit n q.2 else 0) +
  (if q.1 = c then torsionBit n q.2 else 0)

theorem torsionBit_sub (n : ℕ) (s e : ZMod L) (he : n • e = 0) :
    torsionBit n (s-e) = torsionBit n s := by
  unfold torsionBit
  rw [nsmul_sub,he,sub_zero]

theorem torsionWord_nonzero (n : ℕ) (c : Fin 4) (hc : c ≠ 0) :
    torsionWord (L := L) n c ≠ 0 := by
  intro h
  have hz := congrFun h ((0 : Fin 4),(0 : ZMod L))
  simpa [torsionWord,torsionBit,hc.symm] using hz

theorem torsionWord_support (n : ℕ) (c : Fin 4) (hc : c ≠ 0) :
    CoverWeight.support (torsionWord (L := L) n c) =
      ({0,c} : Finset (Fin 4)) ×ˢ torsionSet n := by
  ext q
  rcases q with ⟨j,s⟩
  by_cases h0 : j=0
  · subst j
    simp [CoverWeight.support,torsionWord,torsionBit,torsionSet,hc.symm]
  · by_cases hcj : j=c
    · subst j
      simp [CoverWeight.support,torsionWord,torsionBit,torsionSet,hc]
    · simp [CoverWeight.support,torsionWord,torsionBit,torsionSet,h0,hcj]

theorem torsionWord_weight_le (n : ℕ) (hn : 0 < n) (c : Fin 4) (hc : c ≠ 0) :
    (CoverWeight.support (torsionWord (L := L) n c)).card ≤ 2*n := by
  rw [torsionWord_support n c hc,Finset.card_product]
  have hcard : ({0,c} : Finset (Fin 4)).card = 2 := by simp [hc.symm]
  rw [hcard]
  exact Nat.mul_le_mul_left 2 (torsion_card_le n hn)

/-- A torsion subgroup on two columns gives an actual source classical word.
The transpose model or a restricted stabilizer test is not used here. -/
theorem torsionWord_source_kernel (e : Fin 3 → Fin 4 → ZMod L)
    (n : ℕ) (c : Fin 4) (h0 : ∀ i, e i 0=0) (ht : ∀ i, n • e i c=0) :
    ∀ a : Fin 3 × ZMod L,
      (∑ q, GeneralLP.C e a q * torsionWord n c q)=0 := by
  intro a
  rw [GeneralLP.classical_action]
  unfold CyclicCover.boundary torsionWord
  simp only [Finset.sum_add_distrib]
  simp only [Finset.sum_ite_eq',Finset.mem_univ,if_true]
  rw [h0 a.1,sub_zero,torsionBit_sub n a.2 (e a.1 c) (ht a.1)]
  exact CharTwo.add_self_eq_zero _

theorem source_classical_word_le10 (e : Fin 3 → Fin 4 → ZMod L)
    (c : Fin 4) (hc : c ≠ 0) (h0 : ∀ i, e i 0=0)
    (ht : ∀ i, 5 • e i c=0) :
    ∃ x : (Fin 4 × ZMod L) → ZMod 2,
      (∀ a, (∑ q, GeneralLP.C e a q*x q)=0) ∧ x≠0 ∧
      (CoverWeight.support x).card≤10 := by
  refine ⟨torsionWord 5 c,torsionWord_source_kernel e 5 c h0 ht,
    torsionWord_nonzero 5 c hc,?_⟩
  simpa using torsionWord_weight_le (L := L) 5 (by decide) c hc

#print axioms torsion_card_le
#print axioms source_classical_word_le10
end TruncatedDistance
