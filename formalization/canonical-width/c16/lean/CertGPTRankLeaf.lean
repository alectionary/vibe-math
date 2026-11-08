import CertGPTRank
import CertGPTFrameCheck

namespace C16Frames.CertGPT
set_option maxRecDepth 4096
set_option maxHeartbeats 2000000
open Matrix

theorem gramField_eq_dot (d : Instance) (i j : Nat) :
    gramField d i j = toVec d.x[i]! ⬝ᵥ toVec d.z[j]! := by
  change bitZ (par128 (d.x[i]! &&& d.z[j]!)) = _
  rw [par128_eq_bitParity]
  exact (dot_eq_bitZ _ _).symm

/-- Any list of X vectors containing a partial frame spans at least its size. -/
theorem pairFrame_card_le_geCount_x (d : Instance) (F : Finset Pair) (rows : Array Nat)
    (hf : IsPairFrame (gramField d) F)
    (hx : ∀ p ∈ F, d.x[p.1]! ∈ rows) : F.card ≤ geCount rows := by
  classical
  let e : Fin F.card ≃ ↥F := (Finset.equivFinOfCardEq rfl).symm
  have hex (a : Fin F.card) : ∃ i : Fin rows.size, rows[i] = d.x[(e a).val.1]! := by
    obtain ⟨i, hi, he⟩ := Array.mem_iff_getElem.mp (hx (e a).val (e a).property)
    exact ⟨⟨i,hi⟩,he⟩
  let S : Fin F.card → Fin rows.size := fun a => Classical.choose (hex a)
  have hs (a : Fin F.card) : rows[S a] = d.x[(e a).val.1]! := Classical.choose_spec (hex a)
  let X : Matrix (Fin rows.size) (Fin 128) (ZMod 2) := fun i => toVec rows[i]
  let Z : Matrix (Fin F.card) (Fin 128) (ZMod 2) := fun a => toVec d.z[(e a).val.2]!
  have hid : (X * Zᵀ).submatrix S id = 1 := by
    ext a b
    change (toVec rows[S a] ⬝ᵥ toVec d.z[(e b).val.2]!) = _
    rw [hs, ← gramField_eq_dot, hf.2.2 _ (e a).property _ (e b).property]
    rw [Matrix.one_apply]
    have he : (e a).val = (e b).val ↔ a = b :=
      ⟨fun h => e.injective (Subtype.ext h), fun h => by subst h; rfl⟩
    simp only [he]
  have hr := C16Frames.induced_matching_le_rank (X * Zᵀ) S id hid
  have hrx : (X * Zᵀ).rank ≤ X.rank := Matrix.rank_mul_le_left _ _
  exact hr.trans (hrx.trans (matrixRank_le_geCount (n := 128) rows))

/-- Any list of Z vectors containing a partial frame spans at least its size. -/
theorem pairFrame_card_le_geCount_z (d : Instance) (F : Finset Pair) (rows : Array Nat)
    (hf : IsPairFrame (gramField d) F)
    (hx : ∀ p ∈ F, d.z[p.2]! ∈ rows) : F.card ≤ geCount rows := by
  classical
  let e : Fin F.card ≃ ↥F := (Finset.equivFinOfCardEq rfl).symm
  have hex (a : Fin F.card) : ∃ i : Fin rows.size, rows[i] = d.z[(e a).val.2]! := by
    obtain ⟨i, hi, he⟩ := Array.mem_iff_getElem.mp (hx (e a).val (e a).property)
    exact ⟨⟨i,hi⟩,he⟩
  let S : Fin F.card → Fin rows.size := fun a => Classical.choose (hex a)
  have hs (a : Fin F.card) : rows[S a] = d.z[(e a).val.2]! := Classical.choose_spec (hex a)
  let X : Matrix (Fin rows.size) (Fin 128) (ZMod 2) := fun i => toVec rows[i]
  let Z : Matrix (Fin F.card) (Fin 128) (ZMod 2) := fun a => toVec d.x[(e a).val.1]!
  have hid : (X * Zᵀ).submatrix S id = 1 := by
    ext a b
    change (toVec rows[S a] ⬝ᵥ toVec d.x[(e b).val.1]!) = _
    rw [hs, dotProduct_comm, ← gramField_eq_dot, hf.2.2 _ (e b).property _ (e a).property]
    rw [Matrix.one_apply]
    have he : (e a).val = (e b).val ↔ a = b :=
      ⟨fun h => e.injective (Subtype.ext h), fun h => by subst h; rfl⟩
    simp only [eq_comm (a := (e b).val) (b := (e a).val), he]
  have hr := C16Frames.induced_matching_le_rank (X * Zᵀ) S id hid
  have hrx : (X * Zᵀ).rank ≤ X.rank := Matrix.rank_mul_le_left _ _
  exact hr.trans (hrx.trans (matrixRank_le_geCount (n := 128) rows))

/-- Concrete rank leaf contradicts a remaining partial frame of the required size. -/
theorem rankLeaf_contradiction (d : Instance) (s : SearchState) (F : Finset Pair)
    (hf : IsPairFrame (gramField d) F) (hc : F.card = s.need)
    (hcover : ∀ p ∈ F, ∃ q, q ∈ s.live ∧ p ∈ d.items[q]!)
    (h : rankLeaf d s = true) : False := by
  have hx : ∀ p ∈ F, d.x[p.1]! ∈ liveXRows d s := by
    intro p hp
    obtain ⟨q,hq,hp⟩ := hcover p hp
    exact Array.mem_flatMap.mpr ⟨q,hq,Array.mem_map.mpr ⟨p,hp,rfl⟩⟩
  have hz : ∀ p ∈ F, d.z[p.2]! ∈ liveZRows d s := by
    intro p hp
    obtain ⟨q,hq,hp⟩ := hcover p hp
    exact Array.mem_flatMap.mpr ⟨q,hq,Array.mem_map.mpr ⟨p,hp,rfl⟩⟩
  have hxl := pairFrame_card_le_geCount_x d F (liveXRows d s) hf hx
  have hzl := pairFrame_card_le_geCount_z d F (liveZRows d s) hf hz
  rw [hc] at hxl hzl
  simp only [rankLeaf, Bool.or_eq_true, decide_eq_true_eq] at h
  rcases h with h | h <;> omega

#print axioms rankLeaf_contradiction

end C16Frames.CertGPT
