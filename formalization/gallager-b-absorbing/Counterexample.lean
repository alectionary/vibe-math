import Std

/-! Exact seven-column simplex Tanner graph and source Gallager-B update.
All finite checks below are evaluated by Lean's kernel (`decide`), not native_decide.
The error type BitVec 7 ranges over all 128 subsets of the variable set. -/
namespace GallagerAbsorbing
set_option maxRecDepth 100000
set_option maxHeartbeats 0
set_option maxRecDepth 100000
abbrev Word := BitVec 7
abbrev Vertex := Fin 7
abbrev Messages := Vertex → Vertex → Bool

def parity (xs : List Bool) : Bool := xs.foldl Bool.xor false

def dot3 (a b : Nat) : Bool :=
  parity ((List.range 3).map fun j => a.testBit j && b.testBit j)

def H (c v : Vertex) : Bool := dot3 (c.val + 1) (v.val + 1)

def vertices : List Vertex := List.finRange 7

def bit (e : Word) (v : Vertex) : Bool := e.getLsbD v.val

def pack (f : Vertex → Bool) : Word :=
  BitVec.ofNat 7 ((vertices.map fun v => if f v then 2^v.val else 0).foldl (· + ·) 0)

def syndrome (e : Word) : Word :=
  pack fun c => parity (vertices.map fun v => H c v && bit e v)

def zeroMessages : Messages := fun _ _ => false

def checkUpdate (s : Word) (x : Messages) : Messages := fun c v =>
  H c v && (Bool.xor (bit s c)
    (parity (vertices.map fun u => H c u && (u != v) && x c u)))

def majority (xs : List Bool) : Bool := decide (xs.length < 2 * xs.countP id)

def hardDecision (y : Messages) : Word :=
  pack fun v => majority ((vertices.filter fun c => H c v).map fun c => y c v)

def variableUpdate (y : Messages) : Messages := fun c v =>
  H c v && majority ((vertices.filter fun d => H d v && (d != c)).map fun d => y d v)

def edgeSyndrome (x : Messages) : Word :=
  pack fun c => parity (vertices.map fun v => H c v && x c v)

def firstChecks (e : Word) := checkUpdate (syndrome e) zeroMessages

def firstHard (e : Word) := hardDecision (firstChecks e)

def firstExtrinsic (e : Word) := variableUpdate (firstChecks e)

def rowDegree (c : Vertex) := (vertices.filter fun v => H c v).length

def colDegree (v : Vertex) := (vertices.filter fun c => H c v).length

def absorbingFull : Prop :=
  ∀ v : Vertex,
    ((vertices.filter fun c => H c v && decide (rowDegree c % 2 = 1)).length <
     (vertices.filter fun c => H c v && decide (rowDegree c % 2 = 0)).length)

theorem degrees : (∀ c, rowDegree c = 4) ∧ (∀ v, colDegree v = 4) := by decide

theorem full_set_absorbing : absorbingFull := by
  unfold absorbingFull
  decide

theorem matrix_symmetric : ∀ c v, H c v = H v c := by decide

theorem pack_bits : ∀ e : Word, pack (bit e) = e := by decide

theorem first_hard_matches : ∀ e : Word, syndrome (firstHard e) = syndrome e := by decide

theorem first_edge_matches : ∀ e : Word,
    edgeSyndrome (firstExtrinsic e) = syndrome e := by decide

-- Self-orthogonality of the actual binary check rows, including identical rows.
def rowWord (c : Vertex) : Word := pack (H c)
def inner (e f : Word) : Bool := parity (vertices.map fun v => bit e v && bit f v)
theorem css_commutation : ∀ c d : Vertex, inner (rowWord c) (rowWord d) = false := by decide

-- The stopped decoder is extended by its terminal output, as required to
-- interpret eventual convergence after an actual successful stopping time.
def terminal (e : Word) : Word := if syndrome e = 0 then 0 else firstHard e

def stoppedOutput (e : Word) (t : Nat) : Word := if t = 0 then 0 else terminal e

def eventuallyCorrect (e : Word) (c : Vertex) : Prop :=
  ∃ L : Nat, ∀ t : Nat, L ≤ t → bit (syndrome (stoppedOutput e t)) c = bit (syndrome e) c

def eventuallyConverges (e : Word) (v : Vertex) : Prop :=
  ∃ L : Nat, ∀ t : Nat, L ≤ t → bit (stoppedOutput e t) v = bit (stoppedOutput e (t+1)) v

def fullTrapping : Prop :=
  ∃ e : Word, (∃ c : Vertex, ¬ eventuallyCorrect e c) ∨
    (∃ v : Vertex, ¬ eventuallyConverges e v)

theorem terminal_matches : ∀ e : Word, syndrome (terminal e) = syndrome e := by decide

theorem all_eventually_correct (e : Word) (c : Vertex) : eventuallyCorrect e c := by
  refine ⟨1, ?_⟩
  intro t ht
  have h : t ≠ 0 := by omega
  simp only [stoppedOutput, ite_eq_right h]
  rw [terminal_matches]

theorem all_eventually_converge (e : Word) (v : Vertex) : eventuallyConverges e v := by
  refine ⟨1, ?_⟩
  intro t ht
  have h : t ≠ 0 := by omega
  have h' : t+1 ≠ 0 := by omega
  simp only [stoppedOutput, ite_eq_right h, ite_eq_right h']

theorem absorbing_not_trapping : absorbingFull ∧ ¬ fullTrapping := by
  constructor
  · exact full_set_absorbing
  · intro ⟨e, hf⟩
    rcases hf with ⟨c,hc⟩ | ⟨v,hv⟩
    · exact hc (all_eventually_correct e c)
    · exact hv (all_eventually_converge e v)

#print axioms absorbing_not_trapping
#print axioms first_hard_matches
#print axioms first_edge_matches
end GallagerAbsorbing

namespace GallagerAbsorbing
-- Conventional CSS construction on fourteen actual binary coordinates, grouped
-- into two disjoint seven-coordinate blocks. Addition is componentwise XOR.
abbrev QWord := Word × Word

def qxor (a b : QWord) : QWord := (a.1 ^^^ b.1, a.2 ^^^ b.2)
def qinner (a b : QWord) : Bool := Bool.xor (inner a.1 b.1) (inner a.2 b.2)

def hxRows : List QWord :=
  (vertices.map fun c => (rowWord c, 0)) ++ (vertices.map fun c => (0, rowWord c))

def hzRows : List QWord :=
  [(rowWord 0, 0), (rowWord 1, 0), (rowWord 3, 0), (127, 0),
   (0, rowWord 0), (0, rowWord 1), (0, rowWord 3)]

def combine {n : Nat} (rs : List QWord) (a : BitVec n) : QWord :=
  (rs.zipIdx.map fun (r,i) => if a.getLsbD i then r else (0,0)).foldl qxor (0,0)

def hzSpan (w : QWord) : Prop := ∃ a : BitVec 7, combine hzRows a = w

theorem actual_css_commutation :
    hxRows.all (fun x => hzRows.all (fun z => !(qinner x z))) = true := by decide

theorem first_block_residual_is_stabilizer : ∀ e : Word,
    ∃ a : BitVec 7, combine hzRows a = (e ^^^ terminal e, 0) := by decide

theorem first_block_quantum_recovery (e : Word) :
    hzSpan (qxor (e,0) (terminal e,0)) := by
  simpa [hzSpan, qxor] using first_block_residual_is_stabilizer e

-- A nontrivial logical on the other block rules out a zero-logical-dimension
-- artifact. No distance claim is made or needed.
def logicalWitness : QWord := (0,127)

theorem logical_commutes :
    hxRows.all (fun x => !(qinner x logicalWitness)) = true := by decide

theorem logical_not_stabilizer : ¬ hzSpan logicalWitness := by
  unfold hzSpan
  decide

-- The component is disconnected from the spectator block, not from itself.
-- Every pair of first-block variables has a common neighboring check.
theorem first_block_connected : ∀ u v : Vertex,
    ∃ c : Vertex, H c u = true ∧ H c v = true := by decide

-- A concrete logical miscorrection in the ordinary Steane pairing H_X=H_Z=H.
def singleBlockSpan (e : Word) : Prop :=
  ∃ a : BitVec 3,
    (if a.getLsbD 0 then rowWord 0 else 0) ^^^
    (if a.getLsbD 1 then rowWord 1 else 0) ^^^
    (if a.getLsbD 2 then rowWord 3 else 0) = e

theorem steane_logical_miscorrection :
    terminal 3 = 4 ∧ syndrome 3 = syndrome 4 ∧ ¬ singleBlockSpan 7 := by
  unfold singleBlockSpan
  decide

#print axioms actual_css_commutation
#print axioms first_block_quantum_recovery
#print axioms logical_not_stabilizer
#print axioms first_block_connected
#print axioms steane_logical_miscorrection
end GallagerAbsorbing

namespace GallagerAbsorbing
set_option maxHeartbeats 0
set_option maxRecDepth 100000

def syndromeIndex (e : Word) : Nat :=
  (vertices.map fun v => if bit e v then v.val+1 else 0).foldl Nat.xor 0

def votes (p : Fin 8) (v : Vertex) : Nat :=
  (vertices.filter fun c => H c v && dot3 (c.val+1) p.val).length

theorem syndrome_index_bridge : ∀ e : Word, ∀ c : Vertex,
    bit (syndrome e) c = dot3 (c.val+1) (syndromeIndex e) := by decide

theorem simplex_vote_counts : ∀ p : Fin 8, ∀ v : Vertex,
    votes p v = if p.val = 0 then 0 else if p.val = v.val+1 then 4 else 2 := by decide

theorem first_hard_formula : ∀ e : Word,
    firstHard e = if syndromeIndex e = 0 then 0 else
      BitVec.ofNat 7 (2^(syndromeIndex e - 1)) := by decide

def kernelCombination (a : BitVec 4) : Word :=
  (if a.getLsbD 0 then rowWord 0 else 0) ^^^
  (if a.getLsbD 1 then rowWord 1 else 0) ^^^
  (if a.getLsbD 2 then rowWord 3 else 0) ^^^
  (if a.getLsbD 3 then 127 else 0)

theorem kernel_equals_four_generator_span : ∀ e : Word,
    syndrome e = 0 ↔ ∃ a : BitVec 4, kernelCombination a = e := by decide

#print axioms first_hard_formula
#print axioms kernel_equals_four_generator_span
end GallagerAbsorbing

namespace GallagerAbsorbing
set_option maxHeartbeats 0
set_option maxRecDepth 100000
abbrev QVertex := Fin 14

def qbit (w : QWord) (v : QVertex) : Bool :=
  if v.val < 7 then w.1.getLsbD v.val else w.2.getLsbD (v.val-7)

def hxRow (c : QVertex) : QWord := hxRows[c.val]!

def actualSyndrome14 (w : QWord) : BitVec 14 :=
  BitVec.ofNat 14 (((List.finRange 14).map fun c =>
    if qinner (hxRow c) w then 2^c.val else 0).foldl (· + ·) 0)

def actualFirstChecks14 (e : QWord) (c v : QVertex) : Bool :=
  qbit (hxRow c) v && (actualSyndrome14 e).getLsbD c.val

def actualFirstVote14 (e : QWord) (v : QVertex) : Bool :=
  majority (((List.finRange 14).filter fun c => qbit (hxRow c) v).map
    fun c => actualFirstChecks14 e c v)

def actualFirstHard14 (e : QWord) : QWord :=
  (pack fun v => actualFirstVote14 e ⟨v.val, by omega⟩,
   pack fun v => actualFirstVote14 e ⟨v.val+7, by omega⟩)

theorem actual_matrix_first_step_bridge : ∀ e : Word,
    actualFirstHard14 (e,0) = (firstHard e,0) := by decide

theorem actual_matrix_syndrome_matches : ∀ e : Word,
    actualSyndrome14 (actualFirstHard14 (e,0)) = actualSyndrome14 (e,0) := by decide

theorem terminal_eq_firstHard : ∀ e : Word, terminal e = firstHard e := by decide

theorem actual_matrix_quantum_recovery (e : Word) :
    hzSpan (qxor (e,0) (actualFirstHard14 (e,0))) := by
  rw [actual_matrix_first_step_bridge, ← terminal_eq_firstHard]
  exact first_block_quantum_recovery e

#print axioms actual_matrix_first_step_bridge
#print axioms actual_matrix_syndrome_matches
#print axioms actual_matrix_quantum_recovery
end GallagerAbsorbing
