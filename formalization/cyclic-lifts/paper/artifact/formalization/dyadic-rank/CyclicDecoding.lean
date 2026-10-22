module

public import CyclicLift

@[expose] public section
open CyclicLift

namespace CyclicDecoding

/-- Two distinct variables cannot share two checks in a four-cycle-free graph. -/
theorem common_checks_card_le_one {V C : Type*} [Fintype C] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E]
    (h : ¬HasFourCycle (bipartiteBase E)) (v w : V) (hne : v ≠ w) :
    ((Finset.univ.filter (E v)) ∩ (Finset.univ.filter (E w))).card ≤ 1 := by
  by_contra hn
  have hlt : 1 < ((Finset.univ.filter (E v)) ∩
      (Finset.univ.filter (E w))).card := by omega
  obtain ⟨c, hc, d, hd, hcd⟩ := Finset.one_lt_card.mp hlt
  simp only [Finset.mem_inter, Finset.mem_filter, Finset.mem_univ, true_and] at hc hd
  exact h ⟨Sum.inl v, Sum.inr c, Sum.inl w, Sum.inr d,
    hc.1, hc.2, hd.2, hd.1, fun he => hne (Sum.inl.inj he),
    fun he => hcd (Sum.inr.inj he)⟩

/-- For two binary errors, odd checks are precisely the symmetric difference
of their neighborhoods; at most one common check cancels at most two edges. -/
theorem two_error_syndrome_lower_bound {C : Type*} [DecidableEq C]
    (N M : Finset C) (h : (N ∩ M).card ≤ 1) :
    N.card + M.card - 2 ≤ (N \ M).card + (M \ N).card := by
  have hN := Finset.card_sdiff_add_card_inter N M
  have hM := Finset.card_sdiff_add_card_inter M N
  rw [Finset.inter_comm M N] at hM
  omega

/-- A four-cycle-free Tanner graph exposes at least d(v)+d(w)-2 odd
checks when precisely the two distinct variables v and w are in error. -/
theorem no_four_two_error_bound {V C : Type*} [Fintype C] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E]
    (h : ¬HasFourCycle (bipartiteBase E)) (v w : V) (hne : v ≠ w) :
    (Finset.univ.filter (E v)).card + (Finset.univ.filter (E w)).card - 2 ≤
      ((Finset.univ.filter (E v)) \ (Finset.univ.filter (E w))).card +
      ((Finset.univ.filter (E w)) \ (Finset.univ.filter (E v))).card :=
  two_error_syndrome_lower_bound _ _ (common_checks_card_le_one E h v w hne)

abbrev Var := XVariable (Fin 3) (Fin 3) × ZMod 7
abbrev Check := XCheck (Fin 3) (Fin 3) × ZMod 7

/-- Computable incidence for the already verified sevenBase binary matrix. -/
def incidence (v : Var) (c : Check) : Bool :=
  match v.1 with
  | .inl p => decide (p.2 = c.1.2 ∧ c.2 = v.2 + sevenBase c.1.1 p.1)
  | .inr p => decide (p.1 = c.1.1 ∧ c.2 = v.2 - sevenBase p.2 c.1.2)

theorem incidence_iff_matrix_entry (v : Var) (c : Check) :
    incidence v c = true ↔ hX sevenBase c v ≠ 0 := by
  rcases v with ⟨v, a⟩
  rcases c with ⟨c, b⟩
  rw [hX_ne_zero_iff]
  cases v <;> simp [incidence, xSupport, xLabel, sub_eq_add_neg]

def inducedDegree (S : Finset Var) (c : Check) : ℕ :=
  (S.filter (fun v => incidence v c = true)).card

def oddNeighbors (S : Finset Var) (v : Var) : Finset Check :=
  Finset.univ.filter (fun c => incidence v c = true ∧ inducedDegree S c % 2 = 1)

def evenNeighbors (S : Finset Var) (v : Var) : Finset Check :=
  Finset.univ.filter (fun c => incidence v c = true ∧ inducedDegree S c % 2 = 0)

def IsAbsorbing (S : Finset Var) : Prop :=
  ∀ v ∈ S, (oddNeighbors S v).card < (evenNeighbors S v).card

def fourSet : Finset Var :=
  {(.inl (0,0),0), (.inl (0,1),0), (.inr (0,0),0), (.inr (1,0),0)}

def sixSet : Finset Var :=
  {(.inl (0,0),0), (.inl (0,1),0), (.inl (0,2),0),
   (.inr (0,0),0), (.inr (1,0),0), (.inr (2,0),0)}

set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Four cycle variables form an elementary (4,4) absorbing set: every
variable has two even and one odd neighbor, and checks have degrees 0,1,2. -/
theorem fourSet_certificate : fourSet.card = 4 ∧
    (Finset.univ.filter (fun c => inducedDegree fourSet c = 1)).card = 4 ∧
    (Finset.univ.filter (fun c => inducedDegree fourSet c = 2)).card = 4 ∧
    (∀ c, inducedDegree fourSet c ≤ 2) ∧
    (∀ v ∈ fourSet, (oddNeighbors fourSet v).card = 1 ∧
      (evenNeighbors fourSet v).card = 2) := by decide

theorem fourSet_absorbing : IsAbsorbing fourSet := by
  intro v hv
  obtain ⟨ho, he⟩ := fourSet_certificate.2.2.2.2 v hv
  omega

/-- A weight-six zero-syndrome stopping support. Its nine neighboring
checks have degree two; this is not a quantum logical-distance claim. -/
theorem sixSet_certificate : sixSet.card = 6 ∧
    (Finset.univ.filter (fun c => inducedDegree sixSet c = 2)).card = 9 ∧
    (∀ c, inducedDegree sixSet c = 0 ∨ inducedDegree sixSet c = 2) ∧
    (∀ v ∈ sixSet, (oddNeighbors sixSet v).card = 0 ∧
      (evenNeighbors sixSet v).card = 3) := by decide

theorem sixSet_absorbing : IsAbsorbing sixSet := by
  intro v hv
  obtain ⟨ho, he⟩ := sixSet_certificate.2.2.2 v hv
  omega

#print axioms common_checks_card_le_one
#print axioms two_error_syndrome_lower_bound
#print axioms no_four_two_error_bound
#print axioms incidence_iff_matrix_entry
#print axioms fourSet_certificate
#print axioms fourSet_absorbing
#print axioms sixSet_certificate
#print axioms sixSet_absorbing

end CyclicDecoding
