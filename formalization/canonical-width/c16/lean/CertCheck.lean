import CertSound

open Matrix C16Frames C16Frames.CertRun C16Frames.CertSound C16Frames.PoolBridge C16Frames.Pools

namespace C16Frames.CertCheck

/-! Pair frames, as in the certificate specification, and their relation to `IsFrame`. -/

def poolG (i j : Fin 720) : Bool :=
  par128 (xArr.getD i.1 0 &&& zArr.getD j.1 0)

def IsPairFrame (F : Finset (Fin 720 × Fin 720)) : Prop :=
  (∀ p ∈ F, ∀ q ∈ F, p.1 = q.1 → p = q) ∧
  (∀ p ∈ F, ∀ q ∈ F, p.2 = q.2 → p = q) ∧
  (∀ p ∈ F, ∀ q ∈ F, poolG p.1 q.2 = decide (p = q))

lemma poolG_true_iff (i j : Fin 720) : poolG i j = true ↔ G i j = 1 := by
  have h := G_bool i j
  cases hp : poolG i j
  · have hfalse : par128 (xArr.getD i.1 0 &&& zArr.getD j.1 0) = false := by simpa [poolG] using hp
    rw [hfalse] at h
    constructor
    · intro htrue
      simp [poolG] at htrue
    · intro hG
      have : decide (G i j = 1) = true := by simp [hG]
      rw [this] at h
      cases h
  · have htrue : par128 (xArr.getD i.1 0 &&& zArr.getD j.1 0) = true := by simpa [poolG] using hp
    rw [htrue] at h
    constructor
    · intro _
      simpa using h.symm
    · intro _
      rfl

theorem isPairFrame_isFrame {F : Finset (Fin 720 × Fin 720)} (hF : IsPairFrame F) :
    IsFrame G (F.image Prod.fst) (F.image Prod.snd) F.card := by
  rcases hF with ⟨hX, hZ, hG⟩
  have hS : (F.image Prod.fst).card = F.card := by
    rw [Finset.card_image_iff]
    intro p hp q hq hpq
    exact hX p hp q hq hpq
  refine ⟨hS, ?_, ?_⟩
  · intro i hi
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
    have hpos : poolG p.1 p.2 = true := by
      have hdec := hG p hp p hp
      simpa using hdec
    have hone : G p.1 p.2 ≠ 0 := by
      have h1 : G p.1 p.2 = 1 := (poolG_true_iff p.1 p.2).mp hpos
      rw [h1]
      decide
    refine ⟨p.2, ⟨Finset.mem_image_of_mem _ hp, hone⟩, ?_⟩
    intro j hj
    rcases hj with ⟨hjT, hjG⟩
    obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hjT
    have h1 : G p.1 q.2 = 1 := zmod2_eq_one_of_ne_zero _ hjG
    have hbit : poolG p.1 q.2 = true := (poolG_true_iff p.1 q.2).mpr h1
    have hdec := hG p hp q hq
    rw [hbit] at hdec
    have : p = q := by simpa using hdec
    simp [this]
  · intro j hj
    obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hj
    have hpos : poolG q.1 q.2 = true := by
      have hdec := hG q hq q hq
      simpa using hdec
    have hone : G q.1 q.2 ≠ 0 := by
      have h1 : G q.1 q.2 = 1 := (poolG_true_iff q.1 q.2).mp hpos
      rw [h1]
      decide
    refine ⟨q.1, ⟨Finset.mem_image_of_mem _ hq, hone⟩, ?_⟩
    intro i hi
    rcases hi with ⟨hiS, hiG⟩
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hiS
    have h1 : G p.1 q.2 = 1 := zmod2_eq_one_of_ne_zero _ hiG
    have hbit : poolG p.1 q.2 = true := (poolG_true_iff p.1 q.2).mpr h1
    have hdec := hG p hp q hq
    rw [hbit] at hdec
    have : p = q := by simpa using hdec
    simp [this]

/-- Swapping every pair does not change the set iff the two vertex sets are equal.
Together with `fixed_swap_iff`, a swap-invariant pair set is an `s`-fixed frame. -/
theorem swap_image_iff_vertex {F : Finset (Fin 720 × Fin 720)} :
    F.image Prod.swap = F →
      (F.image Prod.snd, F.image Prod.fst) = (F.image Prod.fst, F.image Prod.snd) := by
  intro h
  have hS : F.image Prod.fst = F.image Prod.snd := by
    ext i
    constructor
    · intro hi
      obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
      have hswap : Prod.swap p ∈ F := by
        have : Prod.swap p ∈ F.image Prod.swap := Finset.mem_image_of_mem _ hp
        simpa [h] using this
      exact Finset.mem_image_of_mem Prod.snd hswap
    · intro hi
      obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
      have hswap : Prod.swap p ∈ F := by
        have : Prod.swap p ∈ F.image Prod.swap := Finset.mem_image_of_mem _ hp
        simpa [h] using this
      exact Finset.mem_image_of_mem Prod.fst hswap
  exact (fixed_swap_iff (F.image Prod.fst) (F.image Prod.snd)).mpr hS

end C16Frames.CertCheck
