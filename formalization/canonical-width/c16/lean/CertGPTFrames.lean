import C16Frames
import Mathlib.Algebra.Field.ZMod

/-!
Generic pair-frame and swap-orbit bridges. The projection proof follows the public
`CertCheck.isPairFrame_isFrame` on branch `independent/c16-lean-cert-20261107`,
read without editing that branch, generalized here to arbitrary index types.
These lemmas do not assert certificate soundness or the concrete no-frame result.
-/
namespace C16Frames.CertGPT

open Matrix

variable {ι : Type*} [DecidableEq ι]

/-- A partial pair frame; the size constraint is intentionally separate. -/
def IsPairFrame (G : ι → ι → ZMod 2) (F : Finset (ι × ι)) : Prop :=
  (∀ p ∈ F, ∀ q ∈ F, p.1 = q.1 → p = q) ∧
  (∀ p ∈ F, ∀ q ∈ F, p.2 = q.2 → p = q) ∧
  (∀ p ∈ F, ∀ q ∈ F, G p.1 q.2 = if p = q then 1 else 0)

theorem IsPairFrame.mono {G : ι → ι → ZMod 2} {F E : Finset (ι × ι)}
    (h : IsPairFrame G F) (hEF : E ⊆ F) : IsPairFrame G E := by
  exact ⟨fun p hp q hq => h.1 p (hEF hp) q (hEF hq),
    fun p hp q hq => h.2.1 p (hEF hp) q (hEF hq),
    fun p hp q hq => h.2.2 p (hEF hp) q (hEF hq)⟩

theorem IsPairFrame.isFrame {G : ι → ι → ZMod 2} {F : Finset (ι × ι)}
    (h : IsPairFrame G F) :
    C16Frames.IsFrame G (F.image Prod.fst) (F.image Prod.snd) F.card := by
  rcases h with ⟨hx, hz, hg⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [Finset.card_image_iff]
    exact fun p hp q hq he => hx p hp q hq he
  · intro i hi
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
    refine ⟨p.2, ⟨Finset.mem_image_of_mem _ hp, ?_⟩, ?_⟩
    · simp [hg p hp p hp]
    · rintro j ⟨hj, hn⟩
      obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hj
      have he : p = q := by
        by_contra he
        exact hn (by simpa [he] using hg p hp q hq)
      simp [he]
  · intro j hj
    obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hj
    refine ⟨q.1, ⟨Finset.mem_image_of_mem _ hq, ?_⟩, ?_⟩
    · simp [hg q hq q hq]
    · rintro i ⟨hi, hn⟩
      obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
      have he : p = q := by
        by_contra he
        exact hn (by simpa [he] using hg p hp q hq)
      simp [he]

/-- The orbit under the order-two swap action, including fixed pairs. -/
def swapOrbit (p : ι × ι) : Finset (ι × ι) := {p, Prod.swap p}

@[simp] theorem mem_swapOrbit {p q : ι × ι} :
    q ∈ swapOrbit p ↔ q = p ∨ q = Prod.swap p := by
  simp [swapOrbit]

@[simp] theorem swapOrbit_swap (p : ι × ι) : swapOrbit (Prod.swap p) = swapOrbit p := by
  ext q
  simp [or_comm]

theorem swapOrbit_eq_of_mem {p q : ι × ι} (h : q ∈ swapOrbit p) :
    swapOrbit q = swapOrbit p := by
  rcases mem_swapOrbit.mp h with rfl | rfl
  · rfl
  · exact swapOrbit_swap p

theorem swapOrbit_disjoint {p q : ι × ι} (h : swapOrbit p ≠ swapOrbit q) :
    Disjoint (swapOrbit p) (swapOrbit q) := by
  apply Finset.disjoint_left.mpr
  intro r hrp hrq
  exact h ((swapOrbit_eq_of_mem hrp).symm.trans (swapOrbit_eq_of_mem hrq))

theorem swap_mem {F : Finset (ι × ι)} (h : F.image Prod.swap = F)
    {p : ι × ι} (hp : p ∈ F) : Prod.swap p ∈ F := by
  rw [← h]
  exact Finset.mem_image_of_mem _ hp

theorem swapOrbit_subset {F : Finset (ι × ι)} (h : F.image Prod.swap = F)
    {p : ι × ι} (hp : p ∈ F) : swapOrbit p ⊆ F := by
  intro q hq
  rcases mem_swapOrbit.mp hq with rfl | rfl
  · exact hp
  · exact swap_mem h hp

/-- The actual disjoint orbit decomposition, with no table-completeness assumption. -/
theorem swap_orbit_decomposition {F : Finset (ι × ι)}
    (h : F.image Prod.swap = F) :
    (F.image swapOrbit).biUnion id = F ∧
      ∀ a ∈ F.image swapOrbit, ∀ b ∈ F.image swapOrbit,
        a ≠ b → Disjoint a b := by
  constructor
  · ext p
    constructor
    · intro hp
      obtain ⟨o, ho, hp⟩ := Finset.mem_biUnion.mp hp
      obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp ho
      exact swapOrbit_subset h hq hp
    · intro hp
      exact Finset.mem_biUnion.mpr ⟨swapOrbit p, Finset.mem_image_of_mem _ hp,
        by simp⟩
  · intro a ha b hb hab
    obtain ⟨p, _, rfl⟩ := Finset.mem_image.mp ha
    obtain ⟨q, _, rfl⟩ := Finset.mem_image.mp hb
    exact swapOrbit_disjoint hab

theorem swap_orbit_partialFrame {G : ι → ι → ZMod 2} {F : Finset (ι × ι)}
    (hF : IsPairFrame G F) (h : F.image Prod.swap = F)
    {p : ι × ι} (hp : p ∈ F) : IsPairFrame G (swapOrbit p) :=
  hF.mono (swapOrbit_subset h hp)

theorem swap_fixed_vertex {F : Finset (ι × ι)} (h : F.image Prod.swap = F) :
    (F.image Prod.snd, F.image Prod.fst) = (F.image Prod.fst, F.image Prod.snd) := by
  apply (C16Frames.fixed_swap_iff _ _).mpr
  ext i
  constructor
  · rintro hi
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
    exact Finset.mem_image_of_mem Prod.snd (swap_mem h hp)
  · rintro hi
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hi
    exact Finset.mem_image_of_mem Prod.fst (swap_mem h hp)

/-- For a symmetric Gram matrix, equality of vertex sets also forces pairwise swap invariance. -/
theorem swap_image_of_vertex_eq {G : ι → ι → ZMod 2} {F : Finset (ι × ι)}
    (hF : IsPairFrame G F) (hG : ∀ i j, G i j = G j i)
    (hv : F.image Prod.fst = F.image Prod.snd) : F.image Prod.swap = F := by
  have closed : ∀ p ∈ F, Prod.swap p ∈ F := by
    intro p hp
    have hs : p.2 ∈ F.image Prod.fst := by
      rw [hv]
      exact Finset.mem_image_of_mem _ hp
    have ht : p.1 ∈ F.image Prod.snd := by
      rw [← hv]
      exact Finset.mem_image_of_mem _ hp
    obtain ⟨q, hq, heq⟩ := Finset.mem_image.mp hs
    obtain ⟨r, hr, her⟩ := Finset.mem_image.mp ht
    have hpos : G q.1 r.2 = 1 := by
      rw [heq, her, hG p.2 p.1]
      simpa using hF.2.2 p hp p hp
    have hqr : q = r := by
      by_contra hne
      have hh := hF.2.2 q hq r hr
      simp [hne, hpos] at hh
    have hswap : Prod.swap p = q := by
      apply Prod.ext
      · exact heq.symm
      · simpa [← hqr] using her.symm
    simpa [hswap] using hq
  ext p
  constructor
  · rintro hp
    obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hp
    exact closed q hq
  · intro hp
    exact Finset.mem_image.mpr ⟨Prod.swap p, closed p hp, by simp⟩

/-- Frame identity for an arbitrary enumeration of a full-size pair frame.
The enumeration is explicit to keep finite-cardinality casts out of the checker bridge. -/
theorem pairFrame_identity_enumerated {n : ℕ}
    (x z : ι → Fin n → ZMod 2) (F : Finset (ι × ι))
    (e : Fin n ≃ ↥F)
    (h : IsPairFrame (fun i j => ∑ c, x i c * z j c) F) :
    ∀ c k, (∑ a : Fin n, x (e a).val.1 c * z (e a).val.2 k) =
      if c = k then 1 else 0 := by
  let X : Matrix (Fin n) (Fin n) (ZMod 2) := fun a c => x (e a).val.1 c
  let Z : Matrix (Fin n) (Fin n) (ZMod 2) := fun a c => z (e a).val.2 c
  have hgram : X * Zᵀ = 1 := by
    ext a b
    change (∑ c, x (e a).val.1 c * z (e b).val.2 c) = if a = b then 1 else 0
    have hentry := h.2.2 (e a).val (e a).property (e b).val (e b).property
    dsimp only at hentry
    rw [hentry]
    have he : (e a).val = (e b).val ↔ a = b := by
      constructor
      · intro he
        exact e.injective (Subtype.ext he)
      · rintro rfl
        rfl
    simp only [he]
  have hid := (C16Frames.gram_one_iff_sum_outer X Z).mp hgram
  intro c k
  have hh := congrFun (congrFun hid c) k
  change (∑ a, x (e a).val.1 c * z (e a).val.2 k) = _ at hh
  exact hh

/-- The certificate residual identity stated directly on the finite set of pairs. -/
theorem pairFrame_identity {n : ℕ}
    (x z : ι → Fin n → ZMod 2) (F : Finset (ι × ι))
    (hc : F.card = n)
    (h : IsPairFrame (fun i j => ∑ c, x i c * z j c) F) :
    ∀ c k, (∑ p ∈ F, x p.1 c * z p.2 k) = if c = k then 1 else 0 := by
  classical
  let e : Fin n ≃ ↥F := (Finset.equivFinOfCardEq hc).symm
  intro c k
  have hid := pairFrame_identity_enumerated x z F e h c k
  have hs := e.sum_comp (fun p : ↥F => x p.val.1 c * z p.val.2 k)
  rw [hs] at hid
  exact (Finset.sum_coe_sort F (fun p : ι × ι => x p.1 c * z p.2 k)).symm.trans hid

#print axioms IsPairFrame.isFrame
#print axioms swap_orbit_decomposition
#print axioms swap_orbit_partialFrame
#print axioms pairFrame_identity_enumerated
#print axioms pairFrame_identity

end C16Frames.CertGPT
