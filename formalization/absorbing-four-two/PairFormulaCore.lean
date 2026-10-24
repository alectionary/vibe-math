import PairEnergy

open scoped BigOperators

namespace PairFormula

variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def centralPairs (H : V → Finset C) : Finset (V × V) :=
  (Finset.univ ×ˢ Finset.univ).filter
    (fun p => p.1 ≠ p.2 ∧ (H p.1 ∩ H p.2).Nonempty)

/-- Third variables completing a six-cycle at the central pair. The last
condition excludes triangles induced by a single check. -/
def properCommon (H : V → Finset C) (u v : V) : Finset V :=
  Finset.univ.filter (fun w =>
    w ≠ u ∧ w ≠ v ∧ (H u ∩ H w).Nonempty ∧ (H v ∩ H w).Nonempty ∧
    ¬ (H u ∩ H v ∩ H w).Nonempty)

def rootPairSum (H : V → Finset C) : ℕ :=
  ∑ p ∈ centralPairs H, (PairEnergy.missingPairs H (properCommon H p.1 p.2)).card

def quadraticSum (H : V → Finset C) : ℕ :=
  ∑ p ∈ centralPairs H,
    ((properCommon H p.1 p.2).card^2 + 2 * (properCommon H p.1 p.2).card)

def energySum (H : V → Finset C) : ℕ :=
  ∑ p ∈ centralPairs H, PairEnergy.energy H (properCommon H p.1 p.2)

theorem rootPairSum_add_energySum (H : V → Finset C)
    (hd : ∀ v, (H v).card = 3)
    (h4 : ∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) :
    rootPairSum H + energySum H = quadraticSum H := by
  unfold rootPairSum energySum quadraticSum
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro p hp
  exact PairEnergy.missing_pair_energy_identity H hd h4 _

end PairFormula
