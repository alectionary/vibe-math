import SourceTen
import SourceEleven
import ProfileTransport
import CountCanonical
import PauliBridge
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]

/-- Full source reduction, conditional only on the independent finite weight-ten
certificate coverage. The published full theorem must discharge that premise. -/
theorem source_kernel_below_twelve_of_coverage
    (hCoverage : Covered 10 0 124416)
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (h : DistanceCriterion e D)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ a,(∑ q,GeneralLP.HZ e a q*GeneralLP.join u v q)=0)
    (hw : (CoverWeight.support (GeneralLP.join u v)).card<min D 12) :
    GeneralLP.InSpanX e u v := by
  have hwD := (lt_min_iff.mp hw).1
  have hw12 := (lt_min_iff.mp hw).2
  by_cases hU : 0<∑ j,leftCount u j
  · by_cases hV : 0<∑ i,rightCount v i
    · rcases source_mixed_count_profiles e h.no_four h.no_six u v hk (by omega) hU hV with h7|h10|h11
      · apply source_seven_singleton_profile_stabilizer e h.no_four h.no_six h.row_zero h.column_zero
          h.no_column_partition h.no_triple_row u v hk
        · intro j
          have hm := (sortedCounts_mem (leftCount u) (leftCount u j)).mpr ⟨j,rfl⟩
          have he : sortedCounts (leftCount u)=[1,1,1,1] := congrArg Prod.fst h7
          rw [he] at hm
          simpa using hm
        · intro i
          have hm := (sortedCounts_mem (rightCount v) (rightCount v i)).mpr ⟨i,rfl⟩
          have he : sortedCounts (rightCount v)=[1,1,1] := congrArg Prod.snd h7
          rw [he] at hm
          simpa using hm
      · have ha : sortedCounts (leftCount u)=[2,2,2,0] := congrArg Prod.fst h10
        have hb : sortedCounts (rightCount v)=[2,2,0] := congrArg Prod.snd h10
        have hweight : (CoverWeight.support (GeneralLP.join u v)).card=10 := by
          rw [support_weight_counts,← sortedCounts_sum (leftCount u),← sortedCounts_sum (rightCount v),ha,hb]
          rfl
        have hD : 10<D := by omega
        obtain ⟨j₀,hj₀,hjrest⟩ := ten_left_marker (leftCount u) ha
        obtain ⟨i₀,hi₀,hirest⟩ := ten_right_marker (rightCount v) hb
        let r : Equiv.Perm (Fin 3) := Equiv.swap 0 i₀
        let c : Equiv.Perm (Fin 4) := Equiv.swap 0 j₀
        have hr0 : r 0=i₀ := Equiv.swap_apply_left _ _
        have hc0 : c 0=j₀ := Equiv.swap_apply_left _ _
        let e' := normPermE e r c
        let u' := normPermU e r c u
        let v' := normPermV e r c v
        have h' : DistanceCriterion e' D := normPerm_criterion e D h r c
        have hk' := normPerm_kernel e r c u v hk
        have hU0' : leftCount u' 0=0 := by
          change leftCount (normPermU e r c u) 0=0
          rw [normPerm_left_count,hc0]
          exact hj₀
        have hV0' : rightCount v' 0=0 := by
          change rightCount (normPermV e r c v) 0=0
          rw [normPerm_right_count,hr0]
          exact hi₀
        have hU' (j : Fin 3) : leftCount u' j.succ=2 := by
          change leftCount (normPermU e r c u) j.succ=2
          rw [normPerm_left_count]
          apply hjrest
          intro he
          have hj : j.succ=0 := c.injective (he.trans hc0.symm)
          simpa using hj
        have hV' (i : Fin 2) : rightCount v' i.succ=2 := by
          change rightCount (normPermV e r c v) i.succ=2
          rw [normPerm_right_count]
          apply hirest
          intro he
          have hi : i.succ=0 := r.injective (he.trans hr0.symm)
          simpa using hi
        exact False.elim (source_canonical_ten_impossible_of_coverage hCoverage e'
          h'.no_four h'.no_six h'.row_zero h'.column_zero h'.no_column_partition h'.no_triple_row
          D hD h'.classical_bound u' v' hk' hU0' hV0' hU' hV')
      · have ha : sortedCounts (leftCount u)=[5,1,1,1] := congrArg Prod.fst h11
        have hb : sortedCounts (rightCount v)=[1,1,1] := congrArg Prod.snd h11
        have hweight : (CoverWeight.support (GeneralLP.join u v)).card=11 := by
          rw [support_weight_counts,← sortedCounts_sum (leftCount u),← sortedCounts_sum (rightCount v),ha,hb]
          rfl
        have hD : 10<D := by omega
        obtain ⟨j₀,hj₀,hjrest⟩ := eleven_left_marker (leftCount u) ha
        have hV1 (i : Fin 3) : rightCount v i=1 := by
          have hm := (sortedCounts_mem (rightCount v) (rightCount v i)).mpr ⟨i,rfl⟩
          rw [hb] at hm
          simpa using hm
        let r : Equiv.Perm (Fin 3) := Equiv.refl _
        let c : Equiv.Perm (Fin 4) := Equiv.swap 3 j₀
        have hc3 : c 3=j₀ := Equiv.swap_apply_left _ _
        let e' := normPermE e r c
        let u' := normPermU e r c u
        let v' := normPermV e r c v
        have h' : DistanceCriterion e' D := normPerm_criterion e D h r c
        have hk' := normPerm_kernel e r c u v hk
        have hw' : (CoverWeight.support (GeneralLP.join u' v')).card≤11 := by
          change (CoverWeight.support (GeneralLP.join (normPermU e r c u) (normPermV e r c v))).card≤11
          rw [normPerm_weight]
          omega
        have hU3' : leftCount u' 3=5 := by
          change leftCount (normPermU e r c u) 3=5
          rw [normPerm_left_count,hc3]
          exact hj₀
        have hU' (j : Fin 3) : leftCount u' (lowColumn j)=1 := by
          change leftCount (normPermU e r c u) (lowColumn j)=1
          rw [normPerm_left_count]
          apply hjrest
          intro he
          have hj : lowColumn j=3 := c.injective (he.trans hc3.symm)
          have hv := congrArg (fun z : Fin 4 => z.val) hj
          change j.val=3 at hv
          have := j.isLt
          omega
        have hV' (i : Fin 3) : rightCount v' i=1 := by
          change rightCount (normPermV e r c v) i=1
          rw [normPerm_right_count]
          exact hV1 _
        have hs := source_canonical_eleven_stabilizer e' h'.no_four h'.no_six h'.row_zero h'.column_zero
          h'.no_column_partition h'.no_triple_row D hD h'.classical_bound u' v' hk' hw' hU' hU3' hV'
        exact (normPerm_span e r c u v).mp hs
    · have hv : v=0 := right_zero_of_count_sum_zero v (by omega)
      subst v
      have hu := pure_left_zero_below_classical e D h.classical_bound u hk hwD
      rw [hu]
      exact zero_full_source_span e
  · have hu : u=0 := left_zero_of_count_sum_zero u (by omega)
    subst u
    have hv := pure_right_zero_below_transpose e D h.transpose_bound v hk hwD
    rw [hv]
    exact zero_full_source_span e

theorem source_x_bound_twelve_of_coverage (hCoverage : Covered 10 0 124416)
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (h : DistanceCriterion e D)
    (x : Qubit L → ZMod 2) (hx : pureX e x) : min D 12≤(CoverWeight.support x).card := by
  by_contra hn
  let u := fun j k s => x (.inl ((j,k),s))
  let v := fun l i s => x (.inr ((l,i),s))
  have hj : GeneralLP.join u v=x := by funext q;cases q <;> rfl
  have hs := source_kernel_below_twelve_of_coverage hCoverage e D h u v
    (by simpa only [hj] using hx.1) (by rw [hj];omega)
  apply hx.2
  obtain ⟨w,hw⟩ := hs
  exact ⟨w,by simpa only [hj] using hw⟩

theorem source_pauli_bound_twelve_of_coverage (hCoverage : Covered 10 0 124416)
    (e : Fin 3 → Fin 4 → ZMod L) (D : ℕ) (h : DistanceCriterion e D)
    (x z : Qubit L → ZMod 2)
    (hx : ∀ c,(∑ q,GeneralLP.HZ e c q*x q)=0)
    (hz : ∀ c,(∑ q,GeneralLP.HX e c q*z q)=0)
    (hn : ¬(fullSpanX e x ∧ fullSpanZ e z)) :
    min D 12≤((CoverWeight.support x)∪(CoverWeight.support z)).card :=
  pauli_bound_of_x_bound e (min D 12) (source_x_bound_twelve_of_coverage hCoverage e D h) x z hx hz hn

#print axioms source_kernel_below_twelve_of_coverage
#print axioms source_pauli_bound_twelve_of_coverage
end TruncatedDistance
