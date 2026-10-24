import GlobalCounting

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace ClassicalConfiguration
open FourColumnClassification

/-- The C14 configuration in Grannell--Griggs--Mendelsohn (1995), Figure 2,
with lines as variable nodes and points as checks. Labels are our own. -/
def c14 : Fin 4 → Finset (Fin 7)
  | 0 => {0,1,2}
  | 1 => {0,3,4}
  | 2 => {1,3,5}
  | 3 => {2,4,6}

/-- Beezer's Definition 3.1: every block contains more than t nontrivial
points, where a point is nontrivial when its configuration degree is ≥2. -/
def Generator (t : ℕ) (cols : Fin 4 → Finset (Fin 7)) : Prop :=
  ∀ i, t < ((cols i).filter (fun c => 2 ≤ (support cols c).card)).card

instance (t : ℕ) (cols : Fin 4 → Finset (Fin 7)) : Decidable (Generator t cols) :=
  inferInstanceAs (Decidable (∀ i,
    t < ((cols i).filter (fun c => 2 ≤ (support cols c).card)).card))

theorem c14_elementary42 : GlobalCounting.elementary42Check c14 Finset.univ := by
  decide

theorem c14_absorbing : Absorbing c14 := by
  unfold Absorbing
  decide

theorem c14_count : GlobalCounting.count42 c14 = 1 := by
  decide

/-- A regular three-uniform incidence structure is a 1-design. C14 is
itself a generator here, so Beezer's non-generator reduction does not
compute this count from other generator counts in the general setting. -/
theorem c14_generator_one : Generator 1 c14 := by
  decide

/-- In a complete Steiner triple system the design strength is t=2.
Here C14 is a non-generator; the classical reduction to Pasch counts applies. -/
theorem c14_not_generator_two : ¬ Generator 2 c14 := by
  decide

#print axioms c14_elementary42
#print axioms c14_absorbing
#print axioms c14_count
#print axioms c14_generator_one
#print axioms c14_not_generator_two
end ClassicalConfiguration
