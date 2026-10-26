import TenRealization
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- Actual canonical weight-ten geometry is covered by the exact finite decoder. -/
theorem ten_geometry_encodes
    (e : Fin 3 → Fin 4 → ZMod L)
    (hR0 : ∀ k,e 0 k=0) (hC0 : ∀ l,e l 0=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (d : TenGeometry e u v) :
    ∃ p : Fin 124416,Nonempty (PatternRealization e 10 p.val) := by
  classical
  choose c hc using (fun j => ordered_column_pair_complete (d.K j 0) (d.K j 1) (d.orderedK j))
  choose r hr using (fun i => ordered_row_pair_complete (d.H i 0) (d.H i 1) (d.orderedH i))
  have hK (j : Fin 3) (a : Fin 2) : columnPairValue (c j).val a.val=(d.K j a).val := by
    fin_cases a
    · exact (hc j).1
    · exact (hc j).2
  have hH (i : Fin 2) (a : Fin 2) : rowPairValue (r i).val a.val=(d.H i a).val := by
    fin_cases a
    · exact (hr i).1
    · exact (hr i).2
  let flips : Fin 6 → Fin 2 := ![d.flip 0 0,d.flip 0 1,d.flip 0 2,d.flip 1 0,d.flip 1 1,d.flip 1 2]
  obtain ⟨bits,hbits⟩ := six_binary_flips_complete flips
  have hflip (i : Fin 2) (j : Fin 3) : flip10 (tenRank c r bits) i.val j.val=(d.flip i j).val := by
    rw [tenRank_flip]
    fin_cases i <;> fin_cases j
    · simpa [flips] using hbits 0
    · simpa [flips] using hbits 1
    · simpa [flips] using hbits 2
    · simpa [flips] using hbits 3
    · simpa [flips] using hbits 4
    · simpa [flips] using hbits 5
  exact ⟨⟨tenRank c r bits,tenRank_bound c r bits⟩,
    ⟨ten_realization_of_geometry d hR0 hC0 c r bits hK hH hflip⟩⟩

theorem actual_canonical_ten_support_encodes
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : TannerSix.NoFour (CEdge e))
    (hR0 : ∀ k,e 0 k=0) (hC0 : ∀ l,e l 0=0)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ c,(∑ q,GeneralLP.HZ e c q*GeneralLP.join u v q)=0)
    (hU0 : leftCount u 0=0) (hV0 : rightCount v 0=0)
    (hU : ∀ j : Fin 3,leftCount u j.succ=2)
    (hV : ∀ i : Fin 2,rightCount v i.succ=2) :
    ∃ p : Fin 124416,Nonempty (PatternRealization e 10 p.val) := by
  obtain ⟨d⟩ := source_ten_geometry e h4 hR0 hC0 u v hk hU0 hV0 hU hV
  exact ten_geometry_encodes e hR0 hC0 u v d

#print axioms ten_geometry_encodes
#print axioms actual_canonical_ten_support_encodes
end TruncatedDistance
