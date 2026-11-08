import CertGPTFrameCheck

namespace C16Frames.CertGPT

 theorem samePairSet_iff (a b : Array Pair) :
    samePairSet a b = true ↔ pairSet a = pairSet b := by
  simp only [samePairSet, Bool.and_eq_true, Array.all_eq_true', Array.contains_iff_mem]
  constructor
  · rintro ⟨hab, hba⟩
    ext p
    simp only [pairSet, List.mem_toFinset, Array.mem_toList_iff]
    exact ⟨hab p, hba p⟩
  · intro h
    constructor
    · intro p hp
      have hp' : p ∈ pairSet a := by simpa [pairSet] using hp
      rw [h] at hp'
      simpa [pairSet] using hp'
    · intro p hp
      have hp' : p ∈ pairSet b := by simpa [pairSet] using hp
      rw [← h] at hp'
      simpa [pairSet] using hp'

 theorem validateItems_swap_coverage (d : Instance)
    (h : validateItems d "swap" = true) : swapCoverage d = true := by
  simp only [validateItems, Bool.and_eq_true, bne_self_eq_false, Bool.false_or] at h
  exact h.2

 theorem swapCoverage_complete (d : Instance) (h : swapCoverage d = true)
    (i j : Nat) (hi : i < d.x.size) (hj : j < d.z.size)
    (hp : partialFrame d (orbit "swap" i j) = true) :
    ∃ u, u < d.items.size ∧ pairSet d.items[u]! = swapOrbit (i,j) := by
  have hh := (Array.all_eq_true'.mp h) i (Array.mem_range.mpr hi)
  have hh := (Array.all_eq_true'.mp hh) j (Array.mem_range.mpr hj)
  simp only [hp, Bool.not_true, Bool.false_or] at hh
  obtain ⟨u, hu, he⟩ := Array.any_eq_true.mp hh
  refine ⟨u, hu, ?_⟩
  rw [getElem!_pos d.items u hu]
  exact (samePairSet_iff _ _).mp he |>.trans (pairSet_orbit_swap i j)

 theorem frame_swap_orbit_accepted (d : Instance) (F : Finset Pair)
    (hf : IsPairFrame (gramField d) F) (hs : F.image Prod.swap = F)
    (hb : ∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size)
    {p : Pair} (hp : p ∈ F) : partialFrame d (orbit "swap" p.1 p.2) = true := by
  apply partialFrame_complete
  · by_cases he : p.1 = p.2 <;> simp [orbit, he]
  · by_cases he : p.1 = p.2 <;> simp [orbit, he, Prod.ext_iff]
  · rw [pairSet_orbit_swap]
    intro q hq
    exact hb q (swapOrbit_subset hs hp hq)
  · rw [pairSet_orbit_swap]
    exact swap_orbit_partialFrame hf hs hp

 theorem validated_frame_orbit_in_table (d : Instance) (F : Finset Pair)
    (hv : validateItems d "swap" = true)
    (hf : IsPairFrame (gramField d) F) (hs : F.image Prod.swap = F)
    (hb : ∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size)
    {p : Pair} (hp : p ∈ F) :
    ∃ u, u < d.items.size ∧ pairSet d.items[u]! = swapOrbit p := by
  exact swapCoverage_complete d (validateItems_swap_coverage d hv) p.1 p.2
    (hb p hp).1 (hb p hp).2 (frame_swap_orbit_accepted d F hf hs hb hp)

theorem validateItems_partialFrame (d : Instance) (kind : String)
    (h : validateItems d kind = true) {u : Nat} (hu : u < d.items.size) :
    partialFrame d d.items[u]! = true := by
  simp only [validateItems, Bool.and_eq_true] at h
  have hh := Array.all_eq_true.mp h.1.2 u hu
  simpa only [getElem!_pos d.items u hu] using hh

/-- Actual table indices partition any bounded swap-invariant pair frame. -/
theorem validated_frame_table_partition (d : Instance) (F : Finset Pair)
    (hv : validateItems d "swap" = true)
    (hf : IsPairFrame (gramField d) F) (hs : F.image Prod.swap = F)
    (hb : ∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size) :
    ∃ U : Finset Nat,
      (∀ u ∈ U, u < d.items.size) ∧
      U.biUnion (fun u => pairSet d.items[u]!) = F ∧
      (∀ u ∈ U, ∀ v ∈ U, u ≠ v → Disjoint (pairSet d.items[u]!) (pairSet d.items[v]!)) := by
  classical
  let O := F.image swapOrbit
  have hc : ∀ o : ↥O, ∃ u, u < d.items.size ∧ pairSet d.items[u]! = o.val := by
    intro o
    obtain ⟨p, hp, he⟩ := Finset.mem_image.mp o.property
    rw [← he]
    exact validated_frame_orbit_in_table d F hv hf hs hb hp
  choose f hfb hfe using hc
  let U := Finset.univ.image f
  refine ⟨U, ?_, ?_, ?_⟩
  · intro u hu
    obtain ⟨o, _, rfl⟩ := Finset.mem_image.mp hu
    exact hfb o
  · ext p
    constructor
    · intro hp
      obtain ⟨u, hu, hp⟩ := Finset.mem_biUnion.mp hp
      obtain ⟨o, _, rfl⟩ := Finset.mem_image.mp hu
      rw [hfe o] at hp
      obtain ⟨q, hq, he⟩ := Finset.mem_image.mp o.property
      rw [← he] at hp
      exact swapOrbit_subset hs hq hp
    · intro hp
      let o : ↥O := ⟨swapOrbit p, Finset.mem_image_of_mem _ hp⟩
      refine Finset.mem_biUnion.mpr ⟨f o, Finset.mem_image_of_mem _ (Finset.mem_univ _), ?_⟩
      rw [hfe o]
      simp [o]
  · intro u hu v hvv hne
    obtain ⟨o, _, rfl⟩ := Finset.mem_image.mp hu
    obtain ⟨o', _, rfl⟩ := Finset.mem_image.mp hvv
    rw [hfe o, hfe o']
    apply (swap_orbit_decomposition hs).2 o.val o.property o'.val o'.property
    intro he
    exact hne (congrArg f (Subtype.ext he))

/-- A list-form partition suitable for the recursive completion invariant. -/
theorem validated_frame_table_list (d : Instance) (F : Finset Pair)
    (hv : validateItems d "swap" = true)
    (hf : IsPairFrame (gramField d) F) (hs : F.image Prod.swap = F)
    (hb : ∀ p ∈ F, p.1 < d.x.size ∧ p.2 < d.z.size) :
    ∃ remaining : List Nat,
      remaining.Nodup ∧ (∀ u ∈ remaining, u < d.items.size) ∧
      (remaining.flatMap (fun u => d.items[u]!.toList)).Nodup ∧
      (remaining.flatMap (fun u => d.items[u]!.toList)).toFinset = F ∧
      (∀ u ∈ remaining, ∀ v ∈ remaining, u ≠ v →
        Disjoint (pairSet d.items[u]!) (pairSet d.items[v]!)) := by
  classical
  obtain ⟨U, hbound, hcover, hdisj⟩ := validated_frame_table_partition d F hv hf hs hb
  refine ⟨U.toList, U.nodup_toList, ?_, ?_, ?_, ?_⟩
  · simpa only [Finset.mem_toList] using hbound
  · apply List.nodup_flatMap.mpr
    constructor
    · intro u hu
      exact partialFrame_nodup d _ (validateItems_partialFrame d "swap" hv
        (hbound u (Finset.mem_toList.mp hu)))
    · apply List.Pairwise.imp_of_mem _ U.nodup_toList
      intro u v hu hvv huv
      have hh := hdisj u (Finset.mem_toList.mp hu) v (Finset.mem_toList.mp hvv) huv
      intro p hpu hpv
      exact Finset.disjoint_left.mp hh
        (by simpa only [pairSet, List.mem_toFinset] using hpu)
        (by simpa only [pairSet, List.mem_toFinset] using hpv)
  · ext p
    rw [← hcover]
    simp only [List.mem_toFinset, List.mem_flatMap, Finset.mem_toList, Finset.mem_biUnion,
      pairSet]
  · simpa only [Finset.mem_toList] using hdisj

#print axioms validated_frame_table_partition

end C16Frames.CertGPT
