import CertGPTFrames

namespace C16Frames.CertGPT

variable {ι : Type*} [DecidableEq ι]

/-- The uniquely determined matching of an `(S,T)` frame. -/
def matchingPairs (G : ι → ι → ZMod 2) (S T : Finset ι) : Finset (ι × ι) :=
  (S ×ˢ T).filter (fun p => G p.1 p.2 ≠ 0)

omit [DecidableEq ι] in
@[simp] theorem mem_matchingPairs {G : ι → ι → ZMod 2} {S T : Finset ι} {p : ι × ι} :
    p ∈ matchingPairs G S T ↔ p.1 ∈ S ∧ p.2 ∈ T ∧ G p.1 p.2 ≠ 0 := by
  simp [matchingPairs, and_assoc]

/-- Converts the paper's vertex-set frame to its canonical pair matching. -/
theorem isFrame_pairFrame {G : ι → ι → ZMod 2} {S T : Finset ι} {n : Nat}
    (h : C16Frames.IsFrame G S T n) :
    ∃ F : Finset (ι × ι), IsPairFrame G F ∧ F.card = n ∧
      F.image Prod.fst = S ∧ F.image Prod.snd = T := by
  rcases h with ⟨hcard, hS, hT⟩
  let F := matchingPairs G S T
  have hx : ∀ p ∈ F, ∀ q ∈ F, p.1 = q.1 → p = q := by
    intro p hp q hq he
    obtain ⟨hpS, hpT, hgp⟩ := mem_matchingPairs.mp hp
    obtain ⟨hqS, hqT, hgq⟩ := mem_matchingPairs.mp hq
    obtain ⟨j, hj, hu⟩ := hS p.1 hpS
    have hpj := hu p.2 ⟨hpT, hgp⟩
    have hqj := hu q.2 ⟨hqT, by simpa only [he] using hgq⟩
    exact Prod.ext he (hpj.trans hqj.symm)
  have hz : ∀ p ∈ F, ∀ q ∈ F, p.2 = q.2 → p = q := by
    intro p hp q hq he
    obtain ⟨hpS, hpT, hgp⟩ := mem_matchingPairs.mp hp
    obtain ⟨hqS, hqT, hgq⟩ := mem_matchingPairs.mp hq
    obtain ⟨i, hi, hu⟩ := hT p.2 hpT
    have hpi := hu p.1 ⟨hpS, hgp⟩
    have hqi := hu q.1 ⟨hqS, by simpa only [he] using hgq⟩
    exact Prod.ext (hpi.trans hqi.symm) he
  have hfst : F.image Prod.fst = S := by
    ext i
    constructor
    · rintro hi
      obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
      exact (mem_matchingPairs.mp hp).1
    · intro hi
      obtain ⟨j, hj, _⟩ := hS i hi
      exact Finset.mem_image.mpr ⟨(i,j), mem_matchingPairs.mpr ⟨hi, hj⟩, rfl⟩
  have hsnd : F.image Prod.snd = T := by
    ext j
    constructor
    · rintro hj
      obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hj
      exact (mem_matchingPairs.mp hp).2.1
    · intro hj
      obtain ⟨i, hi, _⟩ := hT j hj
      exact Finset.mem_image.mpr ⟨(i,j), mem_matchingPairs.mpr ⟨hi.1, hj, hi.2⟩, rfl⟩
  refine ⟨F, ⟨hx, hz, ?_⟩, ?_, hfst, hsnd⟩
  · intro p hp q hq
    by_cases he : p = q
    · subst q
      simpa using C16Frames.zmod2_eq_one_of_ne_zero _ (mem_matchingPairs.mp hp).2.2
    · simp only [he, ite_false]
      by_contra hg
      obtain ⟨hpS, hpT, hgp⟩ := mem_matchingPairs.mp hp
      obtain ⟨hqS, hqT, hgq⟩ := mem_matchingPairs.mp hq
      obtain ⟨j, hj, hu⟩ := hS p.1 hpS
      have hpj := hu p.2 ⟨hpT,hgp⟩
      have hqj := hu q.2 ⟨hqT,hg⟩
      exact he (hz p hp q hq (hpj.trans hqj.symm))
  · have hc : (F.image Prod.fst).card = F.card := by
      rw [Finset.card_image_iff]
      exact hx
    rw [hfst, hcard] at hc
    exact hc.symm

/-- With symmetric Gram matrix, the pair matching of a swap-fixed vertex frame
is itself swap invariant. This is the bridge to `fixed_swap_iff`. -/
theorem swap_fixed_isFrame_pairFrame {G : ι → ι → ZMod 2} {S T : Finset ι} {n : Nat}
    (hG : ∀ i j, G i j = G j i) (h : C16Frames.IsFrame G S T n)
    (hfixed : (T,S) = (S,T)) :
    ∃ F : Finset (ι × ι), IsPairFrame G F ∧ F.card = n ∧ F.image Prod.swap = F := by
  obtain ⟨F, hf, hc, hx, hz⟩ := isFrame_pairFrame h
  refine ⟨F,hf,hc, swap_image_of_vertex_eq hf hG ?_⟩
  rw [hx, hz]
  exact (C16Frames.fixed_swap_iff S T).mp hfixed

/-- Any no-swap-pair-frame result transfers to the paper's `(S,T)` formulation. -/
theorem no_swap_vertex_frame_of_no_pair {G : ι → ι → ZMod 2} {n : Nat}
    (hG : ∀ i j, G i j = G j i)
    (hno : ¬ ∃ F : Finset (ι × ι), IsPairFrame G F ∧ F.card = n ∧ F.image Prod.swap = F) :
    ¬ ∃ S T : Finset ι, C16Frames.IsFrame G S T n ∧ (T,S) = (S,T) := by
  rintro ⟨S,T,h,hfixed⟩
  exact hno (swap_fixed_isFrame_pairFrame hG h hfixed)

#print axioms isFrame_pairFrame
#print axioms no_swap_vertex_frame_of_no_pair

end C16Frames.CertGPT
