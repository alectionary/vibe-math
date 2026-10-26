import SourceProfiles
set_option maxHeartbeats 0
namespace TruncatedDistance

/-- Saturation of all off-marker upper bounds forces equality pointwise. -/
theorem off_marker_value {n : ℕ} (f : Fin n → ℕ) (m : Fin n) (marker common : ℕ)
    (hm : f m=marker) (hle : ∀ j,j≠m → f j≤common)
    (hs : (∑ j,f j)=marker+(n-1)*common) : ∀ j,j≠m → f j=common := by
  classical
  let g := fun j : Fin n => if j=m then marker else common
  have hg : (∑ j,g j)=marker+(n-1)*common := by
    have he := Finset.sum_erase_add Finset.univ g (Finset.mem_univ m)
    have hc : (Finset.univ.erase m).card=n-1 := by simp
    have hsum : (∑ j ∈ Finset.univ.erase m,g j)=(n-1)*common := by
      calc
        _ = ∑ j ∈ Finset.univ.erase m,common := by
          apply Finset.sum_congr rfl
          intro j hj
          exact if_neg (Finset.ne_of_mem_erase hj)
        _ = _ := by simp [hc]
    have hgm : g m=marker := if_pos rfl
    rw [hsum,hgm] at he
    omega
  have hfg (j : Fin n) (_ : j∈Finset.univ) : f j≤g j := by
    by_cases hj : j=m
    · subst j;simp [g,hm]
    · simpa only [g,if_neg hj] using hle j hj
  have he : ∀ j∈Finset.univ,f j=g j := (Finset.sum_eq_sum_iff_of_le hfg).mp (hs.trans hg.symm)
  intro j hj
  simpa only [g,if_neg hj] using he j (Finset.mem_univ j)

theorem ten_left_marker (f : Fin 4 → ℕ) (h : sortedCounts f=[2,2,2,0]) :
    ∃ m,f m=0 ∧ ∀ j,j≠m → f j=2 := by
  obtain ⟨m,hm⟩ := (sortedCounts_mem f 0).mp (by rw [h];simp)
  have hs : (∑ j,f j)=6 := by rw [← sortedCounts_sum,h];rfl
  have hmem (j : Fin 4) : f j=2 ∨ f j=0 := by
    have hh := (sortedCounts_mem f (f j)).mpr ⟨j,rfl⟩
    rw [h] at hh
    simpa using hh
  exact ⟨m,hm,off_marker_value f m 0 2 hm (by intro j hj;rcases hmem j with h|h <;> omega) (by omega)⟩

theorem ten_right_marker (f : Fin 3 → ℕ) (h : sortedCounts f=[2,2,0]) :
    ∃ m,f m=0 ∧ ∀ i,i≠m → f i=2 := by
  obtain ⟨m,hm⟩ := (sortedCounts_mem f 0).mp (by rw [h];simp)
  have hs : (∑ i,f i)=4 := by rw [← sortedCounts_sum,h];rfl
  have hmem (i : Fin 3) : f i=2 ∨ f i=0 := by
    have hh := (sortedCounts_mem f (f i)).mpr ⟨i,rfl⟩
    rw [h] at hh
    simpa using hh
  exact ⟨m,hm,off_marker_value f m 0 2 hm (by intro i hi;rcases hmem i with h|h <;> omega) (by omega)⟩

theorem eleven_left_marker (f : Fin 4 → ℕ) (h : sortedCounts f=[5,1,1,1]) :
    ∃ m,f m=5 ∧ ∀ j,j≠m → f j=1 := by
  obtain ⟨m,hm⟩ := (sortedCounts_mem f 5).mp (by rw [h];simp)
  have hs : (∑ j,f j)=8 := by rw [← sortedCounts_sum,h];rfl
  have hmem (j : Fin 4) : f j=5 ∨ f j=1 := by
    have hh := (sortedCounts_mem f (f j)).mpr ⟨j,rfl⟩
    rw [h] at hh
    simpa using hh
  have hle (j : Fin 4) (hj : j≠m) : f j≤1 := by
    rcases hmem j with h5|h1
    · have hp : f j+f m≤∑ k,f k := by
        have he : (∑ k∈({j,m} : Finset (Fin 4)),f k)≤∑ k,f k := Finset.sum_le_sum_of_subset_of_nonneg
          (show ({j,m} : Finset (Fin 4))⊆Finset.univ from Finset.subset_univ _) (fun _ _ _ => Nat.zero_le _)
        simpa [hj] using he
      omega
    · omega
  exact ⟨m,hm,off_marker_value f m 5 1 hm hle (by omega)⟩

theorem all_singleton_counts {n : ℕ} (f : Fin n → ℕ)
    (h : ∀ a∈sortedCounts f,a=1) : ∀ j,f j=1 := by
  intro j
  exact h _ ((sortedCounts_mem f (f j)).mpr ⟨j,rfl⟩)

#print axioms ten_left_marker
#print axioms eleven_left_marker
end TruncatedDistance
