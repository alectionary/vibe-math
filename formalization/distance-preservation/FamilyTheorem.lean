import CyclicCover
import FamilyBaseDistance
import FamilyNoShort

set_option maxHeartbeats 0
namespace DistanceFamily
variable {L : Nat} [NeZero L]

def liftE (i : Fin 3) (j : Fin 4) : ZMod L := FamilyWords.exponent i j

theorem classical_lower_twelve (hL : 11 ∣ L) (x : CyclicCover.Word (ZMod L))
    (hx : CyclicCover.Kernel liftE x) (hn : x ≠ 0) :
    12 ≤ (CoverWeight.support x).card := by
  let p : ZMod L →+ ZMod 11 := (ZMod.castHom hL (ZMod 11)).toAddMonoidHom
  have he : (fun i j => p (liftE i j)) = FamilyBaseGraph.e := by
    funext i j
    simp [p,liftE,FamilyBaseGraph.e]
  let y := CoverWeight.push (CyclicCover.project p) x
  by_cases hy : y = 0
  · have hs := CyclicCover.projected_support_stopping p liftE x hx hn
    rw [he] at hs
    change SmallStopping.Stopping FamilyBaseGraph.E
      ((CoverWeight.support x).image (CyclicCover.project p)) at hs
    have hl := FamilyBaseGraph.stopping_lower_six _ hs
    have hw := CoverWeight.zero_push_weight_doubles (CyclicCover.project p) x hy
    omega
  · have hk := CyclicCover.kernel_push p liftE x hx
    rw [he] at hk
    have hb : ∀ c, FamilyBaseGraph.boundary y c = 0 := hk
    have hl := FamilyBaseGraph.code_lower_twelve y hb hy
    have hw := CoverWeight.push_weight_le (CyclicCover.project p) x
    change (CoverWeight.support y).card ≤ (CoverWeight.support x).card at hw
    exact hl.trans hw

def join (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (q : FamilyWords.Qubit L) : ZMod 2 :=
  match q with | .inl ((i,j),s) => u i j s | .inr ((i,j),s) => v i j s
def transpose {n : Nat} (u : Fin n → Fin n → ZMod L → ZMod 2) := fun i j s => u j i s
def LogicalX (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  (∀ j i t, FamilyWords.Syndrome u v j i t = 0) ∧
    ¬ ∃ w, u = FamilyWords.stabilizerLeft w ∧ v = FamilyWords.stabilizerRight w

theorem explicit_logical : LogicalX (FamilyWords.U (L := L)) FamilyWords.V := by
  refine ⟨FamilyWords.witness_kernel,?_⟩
  rintro ⟨w,hu,hv⟩
  exact FamilyWords.witness_nontrivial ⟨w,hu⟩

theorem explicit_weight :
    (CoverWeight.support (join (FamilyWords.U (L := L)) FamilyWords.V)).card ≤ 11 :=
  FamilyWords.witness_weight_le

def fiberPair (v : Fin 4 × ZMod L) : ZMod 2 := if v.1 = 0 ∨ v.1 = 1 then 1 else 0
theorem fiberPair_kernel : CyclicCover.Kernel liftE (fiberPair (L := L)) := by
  intro c
  simp only [CyclicCover.boundary,fiberPair,Fin.sum_univ_succ,Fin.sum_univ_zero]
  have ht : (1+1 : ZMod 2) = 0 := by decide +kernel
  simpa using ht
theorem fiberPair_nonzero : fiberPair (L := L) ≠ 0 := by
  intro h
  have hh := congrFun h ((0 : Fin 4),(0 : ZMod L))
  norm_num [fiberPair] at hh

def ClassicalHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ x : CyclicCover.Word (ZMod L), CyclicCover.Kernel liftE x ∧ x ≠ 0 ∧
    (CoverWeight.support x).card = n
/-- Transposing both square qubit blocks exchanges the X and Z sectors
of equation (9); both sectors are included in the minimum. -/
def QuantumHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
    ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2,
      (LogicalX u v ∨ LogicalX (transpose u) (transpose v)) ∧
      (CoverWeight.support (join u v)).card = n
noncomputable instance : DecidablePred (ClassicalHasWeight L) := fun _ => Classical.propDecidable _
noncomputable instance : DecidablePred (QuantumHasWeight L) := fun _ => Classical.propDecidable _

theorem classical_exists : ∃ n, ClassicalHasWeight L n :=
  ⟨_,fiberPair,fiberPair_kernel,fiberPair_nonzero,rfl⟩
theorem quantum_exists : ∃ n, QuantumHasWeight L n :=
  ⟨_,FamilyWords.U,FamilyWords.V,Or.inl explicit_logical,rfl⟩
noncomputable def classicalDistance (L : Nat) [NeZero L] : Nat := Nat.find (classical_exists (L := L))
noncomputable def quantumDistance (L : Nat) [NeZero L] : Nat := Nat.find (quantum_exists (L := L))

theorem classical_distance_lower (hL : 11 ∣ L) : 12 ≤ classicalDistance L := by
  obtain ⟨x,hk,hn,hw⟩ := Nat.find_spec (classical_exists (L := L))
  have hl := classical_lower_twelve hL x hk hn
  change (CoverWeight.support x).card = classicalDistance L at hw
  omega
theorem quantum_distance_upper : quantumDistance L ≤ 11 := by
  have hq : QuantumHasWeight L
      (CoverWeight.support (join (FamilyWords.U (L := L)) FamilyWords.V)).card :=
    ⟨FamilyWords.U,FamilyWords.V,Or.inl explicit_logical,rfl⟩
  have hl : quantumDistance L ≤
      (CoverWeight.support (join (FamilyWords.U (L := L)) FamilyWords.V)).card := Nat.find_min' _ hq
  exact hl.trans explicit_weight

theorem distance_drop (hL : 11 ∣ L) : quantumDistance L < classicalDistance L := by
  have := classical_distance_lower hL
  have := quantum_distance_upper (L := L)
  omega

theorem infinite_counterfamily (hL : 11 ∣ L) :
    VoltageCycles.NoFourVoltage (FamilyNoShort.e L) ∧
    VoltageCycles.NoSixVoltage (FamilyNoShort.e L) ∧
    ¬ FamilyNoShort.RowPairing L ∧ ¬ FamilyNoShort.ColumnPairing L ∧
    quantumDistance L ≤ 11 ∧ 12 ≤ classicalDistance L :=
  ⟨FamilyNoShort.no_four hL,FamilyNoShort.no_six hL,FamilyNoShort.no_row_pairing hL,
    FamilyNoShort.no_column_pairing hL,quantum_distance_upper,classical_distance_lower hL⟩

#print axioms classical_lower_twelve
#print axioms quantum_distance_upper
#print axioms distance_drop
#print axioms infinite_counterfamily
end DistanceFamily
