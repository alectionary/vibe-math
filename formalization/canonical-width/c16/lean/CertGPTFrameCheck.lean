import CertGPTCheck
import CertGPTFrames

namespace C16Frames.CertGPT

/-- The Boolean Gram matrix interpreted in F₂. The separate bit/parity bridge
connects this to the dot product of the supplied vectors. -/
def gramField (d : Instance) (i j : Nat) : ZMod 2 := if gram d i j then 1 else 0

def pairSet (q : Array Pair) : Finset Pair := q.toList.toFinset

theorem partialFrame_spec (d : Instance) (q : Array Pair)
    (h : partialFrame d q = true) :
    ∀ a, a < q.size →
      (q[a]!).1 < d.x.size ∧ (q[a]!).2 < d.z.size ∧
      ∀ b, b < q.size →
        gram d (q[a]!).1 (q[b]!).2 = (a == b) ∧
        (a = b ∨ ((q[a]!).1 ≠ (q[b]!).1 ∧ (q[a]!).2 ≠ (q[b]!).2)) := by
  rw [partialFrame, Bool.and_eq_true] at h
  simpa only [Array.all_eq_true', Array.mem_range, Bool.and_eq_true, Bool.or_eq_true,
    decide_eq_true_eq, beq_iff_eq, bne_iff_ne, and_assoc] using h.2

theorem mem_pairSet_iff (q : Array Pair) (p : Pair) :
    p ∈ pairSet q ↔ ∃ a, a < q.size ∧ q[a]! = p := by
  simp only [pairSet, List.mem_toFinset, Array.mem_toList_iff, Array.mem_iff_getElem]
  constructor
  · rintro ⟨a, ha, he⟩
    exact ⟨a, ha, by simpa only [getElem!_pos q a ha] using he⟩
  · rintro ⟨a, ha, he⟩
    exact ⟨a, ha, by simpa only [getElem!_pos q a ha] using he⟩

theorem partialFrame_indices_injective (d : Instance) (q : Array Pair)
    (h : partialFrame d q = true) {a b : Nat} (ha : a < q.size) (hb : b < q.size)
    (he : q[a]! = q[b]!) : a = b := by
  rcases (partialFrame_spec d q h a ha).2.2 b hb with ⟨_, hab | hne⟩
  · exact hab
  · exact False.elim (hne.1 (congrArg Prod.fst he))

/-- Every item accepted by the executable test is genuinely a partial pair frame. -/
theorem partialFrame_sound (d : Instance) (q : Array Pair)
    (h : partialFrame d q = true) : IsPairFrame (gramField d) (pairSet q) := by
  refine ⟨?_, ?_, ?_⟩
  · intro p hp r hr he
    obtain ⟨a, ha, rfl⟩ := (mem_pairSet_iff q p).mp hp
    obtain ⟨b, hb, rfl⟩ := (mem_pairSet_iff q r).mp hr
    rcases ((partialFrame_spec d q h a ha).2.2 b hb).2 with hab | hne
    · simp [hab]
    · exact False.elim (hne.1 he)
  · intro p hp r hr he
    obtain ⟨a, ha, rfl⟩ := (mem_pairSet_iff q p).mp hp
    obtain ⟨b, hb, rfl⟩ := (mem_pairSet_iff q r).mp hr
    rcases ((partialFrame_spec d q h a ha).2.2 b hb).2 with hab | hne
    · simp [hab]
    · exact False.elim (hne.2 he)
  · intro p hp r hr
    obtain ⟨a, ha, rfl⟩ := (mem_pairSet_iff q p).mp hp
    obtain ⟨b, hb, rfl⟩ := (mem_pairSet_iff q r).mp hr
    have hg := ((partialFrame_spec d q h a ha).2.2 b hb).1
    have he : q[a]! = q[b]! ↔ a = b := by
      constructor
      · exact partialFrame_indices_injective d q h ha hb
      · rintro rfl
        rfl
    simp only [gramField, hg, he, beq_iff_eq]

theorem partialFrame_nodup (d : Instance) (q : Array Pair)
    (h : partialFrame d q = true) : q.toList.Nodup := by
  apply List.nodup_iff_eq_of_getElem_eq.mpr
  intro a b ha hb he
  apply partialFrame_indices_injective d q h (by simpa using ha) (by simpa using hb)
  simpa only [Array.getElem_toList, getElem!_pos q a (by simpa using ha),
    getElem!_pos q b (by simpa using hb)] using he

theorem partialFrame_card (d : Instance) (q : Array Pair)
    (h : partialFrame d q = true) : (pairSet q).card = q.size := by
  simpa only [pairSet, Array.length_toList] using
    List.toFinset_card_of_nodup (partialFrame_nodup d q h)

theorem pairSet_orbit_swap (i j : Nat) :
    pairSet (orbit "swap" i j) = swapOrbit (i,j) := by
  by_cases h : i = j <;> simp [pairSet, orbit, swapOrbit, h]

/-- Completeness of the local item test under its representation preconditions. -/
theorem partialFrame_complete (d : Instance) (q : Array Pair)
    (hn : q.size ≠ 0) (hd : q.toList.Nodup)
    (hb : ∀ p ∈ pairSet q, p.1 < d.x.size ∧ p.2 < d.z.size)
    (hf : IsPairFrame (gramField d) (pairSet q)) : partialFrame d q = true := by
  rw [partialFrame, Bool.and_eq_true]
  constructor
  · simpa using hn
  · simp only [Array.all_eq_true', Array.mem_range, Bool.and_eq_true, Bool.or_eq_true,
      decide_eq_true_eq, beq_iff_eq, bne_iff_ne]
    intro a ha
    have hpa : q[a]! ∈ pairSet q := (mem_pairSet_iff q _).mpr ⟨a, ha, rfl⟩
    refine ⟨hb _ hpa, ?_⟩
    intro b hbb
    have hpb : q[b]! ∈ pairSet q := (mem_pairSet_iff q _).mpr ⟨b, hbb, rfl⟩
    have he : q[a]! = q[b]! ↔ a = b := by
      constructor
      · intro he
        apply hd.eq_of_getElem_eq (by simpa using ha) (by simpa using hbb)
        simpa only [Array.getElem_toList, getElem!_pos q a ha,
          getElem!_pos q b hbb] using he
      · rintro rfl
        rfl
    constructor
    · have hg := hf.2.2 _ hpa _ hpb
      simp only [he] at hg
      cases hbit : gram d (q[a]!).1 (q[b]!).2 <;>
        by_cases hab : a = b <;> simp_all [gramField]
    · by_cases hab : a = b
      · exact Or.inl hab
      · right
        constructor
        · intro hfst
          exact hab (he.mp (hf.1 _ hpa _ hpb hfst))
        · intro hsnd
          exact hab (he.mp (hf.2.1 _ hpa _ hpb hsnd))

#print axioms partialFrame_sound
#print axioms partialFrame_card
#print axioms pairSet_orbit_swap

end C16Frames.CertGPT
