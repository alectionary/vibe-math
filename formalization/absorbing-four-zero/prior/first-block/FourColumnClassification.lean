import Mathlib.Data.Finset.Powerset
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Fintype.Powerset
import Mathlib.Data.Fintype.Perm
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.NormNum

set_option maxRecDepth 100000
set_option maxHeartbeats 0

open scoped BigOperators

namespace FourColumnClassification

abbrev I := Fin 4

variable {C : Type*} [Fintype C] [DecidableEq C]

def support (N : I → Finset C) (c : C) : Finset I :=
  Finset.univ.filter (fun i => c ∈ N i)

def cell (N : I → Finset C) (T : Finset I) : Finset C :=
  Finset.univ.filter (fun c => support N c = T)

def count (N : I → Finset C) (T : Finset I) : ℕ := (cell N T).card

def singletons : Finset (Finset I) := {{0},{1},{2},{3}}

def rowPatterns (i : I) : Finset (Finset I) :=
  singletons.filter (fun T => i ∈ T) ∪
  (Finset.univ.powersetCard 2).filter (fun T => i ∈ T)

theorem finite_row_patterns : ∀ (T : Finset I) (i : I),
    T.card ≤ 2 → (i ∈ T ↔ T ∈ rowPatterns i) := by decide

theorem finite_odd_patterns : ∀ (T : Finset I),
    T.card ≤ 2 → (T.card % 2 = 1 ↔ T ∈ singletons) := by decide

theorem finite_member_pattern : ∀ (T : Finset I) (i : I),
    T ∈ rowPatterns i → i ∈ T := by decide

theorem finite_member_singleton : ∀ (T : Finset I),
    T ∈ singletons → T.card % 2 = 1 := by decide

@[simp] theorem mem_support (N : I → Finset C) (c : C) (i : I) :
    i ∈ support N c ↔ c ∈ N i := by simp [support]

@[simp] theorem mem_cell (N : I → Finset C) (c : C) (T : Finset I) :
    c ∈ cell N T ↔ support N c = T := by simp [cell]

theorem degree_partition (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) (i : I) :
    (N i).card = ∑ T ∈ rowPatterns i, count N T := by
  have hmap : (N i : Set C).MapsTo (support N) (rowPatterns i) := by
    intro c hc
    exact (finite_row_patterns (support N c) i (he c)).mp (by simpa using hc)
  rw [Finset.card_eq_sum_card_fiberwise hmap]
  apply Finset.sum_congr rfl
  intro T hT
  unfold count
  congr 1
  ext c
  simp only [Finset.mem_filter, mem_cell]
  constructor
  · exact And.right
  · intro h
    refine ⟨?_, h⟩
    have hi := finite_member_pattern T i hT
    rw [← h] at hi
    exact (mem_support N c i).mp hi

theorem odd_partition (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) :
    (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card =
    ∑ T ∈ singletons, count N T := by
  have hmap : ((Finset.univ.filter (fun c => (support N c).card % 2 = 1)) : Set C).MapsTo
      (support N) singletons := by
    intro c hc
    exact (finite_odd_patterns (support N c) (he c)).mp (Finset.mem_filter.mp hc).2
  rw [Finset.card_eq_sum_card_fiberwise hmap]
  apply Finset.sum_congr rfl
  intro T hT
  unfold count
  congr 1
  ext c
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, mem_cell]
  constructor
  · exact And.right
  · intro h
    exact ⟨by rw [h]; exact finite_member_singleton T hT, h⟩

theorem pair_count_le_one (N : I → Finset C)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    {i j : I} (hij : i ≠ j) : count N {i,j} ≤ 1 := by
  apply (Finset.card_le_card ?_).trans (h4 i j hij)
  intro c hc
  have h := (mem_cell N c {i,j}).mp hc
  apply Finset.mem_inter.mpr
  constructor
  · apply (mem_support N c i).mp
    rw [h]
    simp
  · apply (mem_support N c j).mp
    rw [h]
    simp

theorem degree_equations (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3) :
    count N {0} + count N {0,1} + count N {0,2} + count N {0,3} = 3 ∧
    count N {1} + count N {0,1} + count N {1,2} + count N {1,3} = 3 ∧
    count N {2} + count N {0,2} + count N {1,2} + count N {2,3} = 3 ∧
    count N {3} + count N {0,3} + count N {1,3} + count N {2,3} = 3 := by
  have h0 := degree_partition N he 0
  have h1 := degree_partition N he 1
  have h2 := degree_partition N he 2
  have h3 := degree_partition N he 3
  have r0 : rowPatterns 0 = {{0},{0,1},{0,2},{0,3}} := by decide
  have r1 : rowPatterns 1 = {{1},{0,1},{1,2},{1,3}} := by decide
  have r2 : rowPatterns 2 = {{2},{0,2},{1,2},{2,3}} := by decide
  have r3 : rowPatterns 3 = {{3},{0,3},{1,3},{2,3}} := by decide
  rw [r0] at h0
  rw [r1] at h1
  rw [r2] at h2
  rw [r3] at h3
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h0
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h1
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h2
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h3
  rw [hd 0] at h0
  rw [hd 1] at h1
  rw [hd 2] at h2
  rw [hd 3] at h3
  omega

theorem odd_equation (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    count N {0} + count N {1} + count N {2} + count N {3} = 2 := by
  have h := odd_partition N he
  rw [ho] at h
  unfold singletons at h
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h
  omega

/-- The normal graph has exactly five edges. This counts checks with their
actual incidences, rather than assuming a projected diamond is elementary. -/
theorem five_pair_checks (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    count N {0,1} + count N {0,2} + count N {0,3} +
    count N {1,2} + count N {1,3} + count N {2,3} = 5 := by
  obtain ⟨h0,h1,h2,h3⟩ := degree_equations N he hd
  have hodd := odd_equation N he ho
  omega

/-- In a four-variable cubic elementary configuration with exactly two odd
checks and no four-cycle, neither odd check can occur at the same variable.
Consequently the absorbing-majority condition follows automatically. -/
theorem singleton_at_most_one (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    ∀ i : I, count N {i} ≤ 1 := by
  obtain ⟨h0,h1,h2,h3⟩ := degree_equations N he hd
  have hsum := five_pair_checks N he hd ho
  have h01 := pair_count_le_one N h4 (i:=0) (j:=1) (by decide)
  have h02 := pair_count_le_one N h4 (i:=0) (j:=2) (by decide)
  have h03 := pair_count_le_one N h4 (i:=0) (j:=3) (by decide)
  have h12 := pair_count_le_one N h4 (i:=1) (j:=2) (by decide)
  have h13 := pair_count_le_one N h4 (i:=1) (j:=3) (by decide)
  have h23 := pair_count_le_one N h4 (i:=2) (j:=3) (by decide)
  intro i
  fin_cases i
  · exact (show count N {0} ≤ 1 by omega)
  · exact (show count N {1} ≤ 1 by omega)
  · exact (show count N {2} ≤ 1 by omega)
  · exact (show count N {3} ≤ 1 by omega)

theorem finite_odd_at : ∀ (T : Finset I) (i : I),
    T.card ≤ 2 → ((i ∈ T ∧ T.card % 2 = 1) ↔ T = {i}) := by decide

theorem odd_at_eq_cell (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) (i : I) :
    ((N i).filter (fun c => (support N c).card % 2 = 1)) = cell N {i} := by
  ext c
  simp only [Finset.mem_filter, mem_cell]
  rw [← mem_support N c i]
  exact finite_odd_at (support N c) i (he c)

def evenAt (N : I → Finset C) (i : I) : Finset C :=
  (N i).filter (fun c => (support N c).card % 2 = 0)

def oddAt (N : I → Finset C) (i : I) : Finset C :=
  (N i).filter (fun c => (support N c).card % 2 = 1)

def Absorbing (N : I → Finset C) : Prop :=
  ∀ i, (oddAt N i).card < (evenAt N i).card

theorem odd_even_partition (N : I → Finset C) (i : I) :
    (oddAt N i).card + (evenAt N i).card = (N i).card := by
  have h : evenAt N i = (N i) \ oddAt N i := by
    ext c
    simp only [evenAt, oddAt, Finset.mem_filter, Finset.mem_sdiff]
    constructor
    · rintro ⟨hc, hm⟩
      exact ⟨hc, by rintro ⟨_, hn⟩; omega⟩
    · rintro ⟨hc, hn⟩
      refine ⟨hc, ?_⟩
      have hm := Nat.mod_two_eq_zero_or_one (support N c).card
      rcases hm with hm | hm
      · exact hm
      · exact False.elim (hn ⟨hc, hm⟩)
  rw [h]
  have hs : oddAt N i ⊆ N i := Finset.filter_subset _ _
  have hcard := Finset.card_sdiff_add_card_eq_card hs
  omega

theorem elementary_42_is_absorbing (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    Absorbing N := by
  intro i
  have hone := singleton_at_most_one N he hd h4 ho i
  have hc : (oddAt N i).card = count N {i} := by
    unfold oddAt count
    rw [odd_at_eq_cell N he i]
  have hp := odd_even_partition N i
  rw [hd i] at hp
  rw [← hc] at hone
  omega

/-- Exactly one pair is absent; all five remaining pair checks occur once. -/
theorem six_diamond_cases (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    (count N {0,1} = 0 ∧ count N {0,2} = 1 ∧ count N {0,3} = 1 ∧ count N {1,2} = 1 ∧ count N {1,3} = 1 ∧ count N {2,3} = 1) ∨
    (count N {0,1} = 1 ∧ count N {0,2} = 0 ∧ count N {0,3} = 1 ∧ count N {1,2} = 1 ∧ count N {1,3} = 1 ∧ count N {2,3} = 1) ∨
    (count N {0,1} = 1 ∧ count N {0,2} = 1 ∧ count N {0,3} = 0 ∧ count N {1,2} = 1 ∧ count N {1,3} = 1 ∧ count N {2,3} = 1) ∨
    (count N {0,1} = 1 ∧ count N {0,2} = 1 ∧ count N {0,3} = 1 ∧ count N {1,2} = 0 ∧ count N {1,3} = 1 ∧ count N {2,3} = 1) ∨
    (count N {0,1} = 1 ∧ count N {0,2} = 1 ∧ count N {0,3} = 1 ∧ count N {1,2} = 1 ∧ count N {1,3} = 0 ∧ count N {2,3} = 1) ∨
    (count N {0,1} = 1 ∧ count N {0,2} = 1 ∧ count N {0,3} = 1 ∧ count N {1,2} = 1 ∧ count N {1,3} = 1 ∧ count N {2,3} = 0) := by
  have hsum := five_pair_checks N he hd ho
  have h01 := pair_count_le_one N h4 (i:=0) (j:=1) (by decide)
  have h02 := pair_count_le_one N h4 (i:=0) (j:=2) (by decide)
  have h03 := pair_count_le_one N h4 (i:=0) (j:=3) (by decide)
  have h12 := pair_count_le_one N h4 (i:=1) (j:=2) (by decide)
  have h13 := pair_count_le_one N h4 (i:=1) (j:=3) (by decide)
  have h23 := pair_count_le_one N h4 (i:=2) (j:=3) (by decide)
  omega


/-- The actual shared-check graph on four selected variables. -/
def normalEdges (N : I → Finset C) : Finset (Finset I) :=
  (Finset.univ.powersetCard 2).filter (fun T => (cell N T).Nonempty)

def RootOn (P : Finset (Finset I)) (p : Equiv.Perm I) : Prop :=
  {p 0,p 1} ∈ P ∧ {p 0,p 2} ∈ P ∧ {p 1,p 2} ∈ P ∧
  {p 0,p 3} ∈ P ∧ {p 1,p 3} ∈ P ∧ {p 2,p 3} ∉ P

instance (P : Finset (Finset I)) (p : Equiv.Perm I) : Decidable (RootOn P p) :=
  inferInstanceAs (Decidable ({p 0,p 1} ∈ P ∧ {p 0,p 2} ∈ P ∧ {p 1,p 2} ∈ P ∧
  {p 0,p 3} ∈ P ∧ {p 1,p 3} ∈ P ∧ {p 2,p 3} ∉ P))

def normalRootCount (P : Finset (Finset I)) : ℕ :=
  (Finset.univ.filter (RootOn P)).card

theorem finite_root_multiplicity :
    ∀ P ∈ (Finset.univ.powersetCard 2 : Finset (Finset I)).powerset,
      normalRootCount P = if P.card = 5 then 4 else 0 := by
  have h : ∀ P : (Finset.univ.powersetCard 2 : Finset (Finset I)).powerset,
      normalRootCount P.val = if P.val.card = 5 then 4 else 0 := by decide
  intro P hP
  exact h ⟨P,hP⟩

/-- Shared checks really are pair cells when no selected check has degree > 2. -/
theorem pair_cell_eq_inter (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) {i j : I} (hij : i ≠ j) :
    cell N {i,j} = N i ∩ N j := by
  ext c
  simp only [mem_cell, Finset.mem_inter]
  constructor
  · intro h
    constructor
    · apply (mem_support N c i).mp
      rw [h]
      simp
    · apply (mem_support N c j).mp
      rw [h]
      simp
  · rintro ⟨hi,hj⟩
    have hsub : ({i,j} : Finset I) ⊆ support N c := by
      intro x hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      rcases hx with rfl | rfl
      · simpa only [mem_support] using hi
      · simpa only [mem_support] using hj
    exact (Finset.eq_of_subset_of_card_le hsub (by simpa [hij] using he c)).symm

theorem finite_pair_list : (Finset.univ.powersetCard 2 : Finset (Finset I)) =
    {{0,1},{0,2},{0,3},{1,2},{1,3},{2,3}} := by decide

theorem normal_edge_count (N : I → Finset C)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1) :
    (normalEdges N).card =
      count N {0,1} + count N {0,2} + count N {0,3} +
      count N {1,2} + count N {1,3} + count N {2,3} := by
  have indicator (i j : I) (hij : i ≠ j) :
      (if (cell N {i,j}).Nonempty then 1 else 0) = count N {i,j} := by
    have h := pair_count_le_one N h4 hij
    unfold count at h ⊢
    by_cases hp : (cell N {i,j}).Nonempty
    · have hpos := Finset.card_pos.mpr hp
      simp [hp]
      omega
    · have hz := Finset.not_nonempty_iff_eq_empty.mp hp
      simp [hp,hz]
  unfold normalEdges
  rw [Finset.card_eq_sum_ones, Finset.sum_filter, finite_pair_list]
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton]
  rw [indicator 0 1 (by decide), indicator 0 2 (by decide),
      indicator 0 3 (by decide), indicator 1 2 (by decide),
      indicator 1 3 (by decide), indicator 2 3 (by decide)]
  omega

theorem local_root_count (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    normalRootCount (normalEdges N) = 4 := by
  have hn : (normalEdges N).card = 5 := by
    rw [normal_edge_count N h4]
    exact five_pair_checks N he hd ho
  have hm : normalEdges N ∈ (Finset.univ.powersetCard 2 : Finset (Finset I)).powerset :=
    Finset.mem_powerset.mpr (Finset.filter_subset _ _)
  simpa [hn] using finite_root_multiplicity (normalEdges N) hm


def RawRoot (N : I → Finset C) (p : Equiv.Perm I) : Prop :=
  (N (p 0) ∩ N (p 1)).Nonempty ∧
  (N (p 0) ∩ N (p 2)).Nonempty ∧
  (N (p 1) ∩ N (p 2)).Nonempty ∧
  (N (p 0) ∩ N (p 3)).Nonempty ∧
  (N (p 1) ∩ N (p 3)).Nonempty ∧
  ¬ (N (p 2) ∩ N (p 3)).Nonempty ∧
  ¬ (N (p 0) ∩ N (p 1) ∩ N (p 2)).Nonempty ∧
  ¬ (N (p 0) ∩ N (p 1) ∩ N (p 3)).Nonempty

instance (N : I → Finset C) (p : Equiv.Perm I) : Decidable (RawRoot N p) :=
  inferInstanceAs (Decidable ((N (p 0) ∩ N (p 1)).Nonempty ∧
  (N (p 0) ∩ N (p 2)).Nonempty ∧ (N (p 1) ∩ N (p 2)).Nonempty ∧
  (N (p 0) ∩ N (p 3)).Nonempty ∧ (N (p 1) ∩ N (p 3)).Nonempty ∧
  ¬ (N (p 2) ∩ N (p 3)).Nonempty ∧
  ¬ (N (p 0) ∩ N (p 1) ∩ N (p 2)).Nonempty ∧
  ¬ (N (p 0) ∩ N (p 1) ∩ N (p 3)).Nonempty))

def rawRootCount (N : I → Finset C) : ℕ :=
  (Finset.univ.filter (RawRoot N)).card

theorem finite_triple_prohibition : ∀ T : Finset I,
    ¬ (0 ∈ T ∧ 1 ∈ T ∧ 2 ∈ T) →
    ¬ (0 ∈ T ∧ 1 ∈ T ∧ 3 ∈ T) →
    ¬ (2 ∈ T ∧ 3 ∈ T) → T.card ≤ 2 := by decide

theorem support_card_perm (N : I → Finset C) (p : Equiv.Perm I) (c : C) :
    (support (fun i => N (p i)) c).card = (support N c).card := by
  apply Finset.card_bij (fun i _ => p i)
  · intro i hi
    simpa only [mem_support] using hi
  · intro i hi j hj hij
    exact p.injective hij
  · intro j hj
    refine ⟨p.symm j, ?_, by simp⟩
    simpa only [mem_support, Equiv.apply_symm_apply] using hj

/-- The proper-triangle and missing-leaf-edge exclusions force elementarity.
This is the incidence correction that an unlabelled projected diamond misses. -/
theorem root_implies_elementary (N : I → Finset C) (p : Equiv.Perm I)
    (hr : RawRoot N p) : ∀ c, (support N c).card ≤ 2 := by
  obtain ⟨h01,h02,h12,h03,h13,h23,ht2,ht3⟩ := hr
  intro c
  have h := finite_triple_prohibition (support (fun i => N (p i)) c)
  have ht2' : ¬ (0 ∈ support (fun i => N (p i)) c ∧
      1 ∈ support (fun i => N (p i)) c ∧ 2 ∈ support (fun i => N (p i)) c) := by
    simp only [mem_support]
    rintro ⟨h0,h1,h2⟩
    exact ht2 ⟨c, by simp [h0,h1,h2]⟩
  have ht3' : ¬ (0 ∈ support (fun i => N (p i)) c ∧
      1 ∈ support (fun i => N (p i)) c ∧ 3 ∈ support (fun i => N (p i)) c) := by
    simp only [mem_support]
    rintro ⟨h0,h1,h3⟩
    exact ht3 ⟨c, by simp [h0,h1,h3]⟩
  have h23' : ¬ (2 ∈ support (fun i => N (p i)) c ∧
      3 ∈ support (fun i => N (p i)) c) := by
    simp only [mem_support]
    rintro ⟨h2,h3⟩
    exact h23 ⟨c, by simp [h2,h3]⟩
  have hc := h ht2' ht3' h23'
  rwa [support_card_perm] at hc

theorem perm_ne (p : Equiv.Perm I) {i j : I} (h : i ≠ j) : p i ≠ p j :=
  fun he => h (p.injective he)

theorem triple_empty (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    {i j k : I} (hij : i ≠ j) (hik : i ≠ k) (hjk : j ≠ k) :
    ¬ (N i ∩ N j ∩ N k).Nonempty := by
  rintro ⟨c,hc⟩
  have hcs : c ∈ N i ∧ c ∈ N j ∧ c ∈ N k := by simpa [and_assoc] using hc
  have hsub : ({i,j,k} : Finset I) ⊆ support N c := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl | rfl
    · simpa only [mem_support] using hcs.1
    · simpa only [mem_support] using hcs.2.1
    · simpa only [mem_support] using hcs.2.2
  have hcard : 3 ≤ (support N c).card := by
    simpa [hij,hik,hjk] using Finset.card_le_card hsub
  have := he c
  omega

theorem rawRoot_iff_normal (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) (p : Equiv.Perm I) :
    RawRoot N p ↔ RootOn (normalEdges N) p := by
  have mem_pair (i j : I) (hij : i ≠ j) :
      {p i,p j} ∈ normalEdges N ↔ (N (p i) ∩ N (p j)).Nonempty := by
    have hmem : ({p i,p j} : Finset I) ∈ Finset.univ.powersetCard 2 := by
      simp [Finset.mem_powersetCard, perm_ne p hij]
    simp only [normalEdges, Finset.mem_filter, hmem, true_and,
      pair_cell_eq_inter N he (perm_ne p hij)]
  have ht2 := triple_empty N he (perm_ne p (i:=0) (j:=1) (by decide))
    (perm_ne p (i:=0) (j:=2) (by decide)) (perm_ne p (i:=1) (j:=2) (by decide))
  have ht3 := triple_empty N he (perm_ne p (i:=0) (j:=1) (by decide))
    (perm_ne p (i:=0) (j:=3) (by decide)) (perm_ne p (i:=1) (j:=3) (by decide))
  unfold RawRoot RootOn
  rw [mem_pair 0 1 (by decide), mem_pair 0 2 (by decide), mem_pair 1 2 (by decide),
    mem_pair 0 3 (by decide), mem_pair 1 3 (by decide), mem_pair 2 3 (by decide)]
  simp only [ht2,ht3,not_false_eq_true,and_true]

theorem rawRootCount_eq_normal (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) :
    rawRootCount N = normalRootCount (normalEdges N) := by
  unfold rawRootCount normalRootCount
  congr 1
  ext p
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, rawRoot_iff_normal N he p]

theorem no_raw_roots_if_not_elementary (N : I → Finset C)
    (he : ¬ ∀ c, (support N c).card ≤ 2) : rawRootCount N = 0 := by
  have h : Finset.univ.filter (RawRoot N) = ∅ := by
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro p hp
    exact he (root_implies_elementary N p (Finset.mem_filter.mp hp).2)
  simp [rawRootCount,h]

theorem raw_root_multiplicity_42 (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1)
    (ho : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2) :
    rawRootCount N = 4 := by
  rw [rawRootCount_eq_normal N he]
  exact local_root_count N he hd h4 ho


theorem odd_number_eq_singletons (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2) :
    (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card =
      count N {0} + count N {1} + count N {2} + count N {3} := by
  have h := odd_partition N he
  unfold singletons at h
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide),
      Finset.sum_insert (by decide), Finset.sum_singleton] at h
  omega

theorem normal_five_iff_odd_two (N : I → Finset C)
    (he : ∀ c, (support N c).card ≤ 2)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1) :
    (normalEdges N).card = 5 ↔
      (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2 := by
  obtain ⟨h0,h1,h2,h3⟩ := degree_equations N he hd
  have hp := normal_edge_count N h4
  have hs := odd_number_eq_singletons N he
  omega

/-- Complete local multiplicity, including the zero case for every other
four-variable configuration. The majority predicate is the actual parity-check
predicate on the given columns. -/
theorem exact_local_multiplicity (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → ((N i) ∩ (N j)).card ≤ 1) :
    rawRootCount N = if
      (∀ c, (support N c).card ≤ 2) ∧
      (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card = 2
      then 4 else 0 := by
  by_cases he : ∀ c, (support N c).card ≤ 2
  · rw [rawRootCount_eq_normal N he]
    have hm : normalEdges N ∈ (Finset.univ.powersetCard 2 : Finset (Finset I)).powerset :=
      Finset.mem_powerset.mpr (Finset.filter_subset _ _)
    have h := finite_root_multiplicity (normalEdges N) hm
    simpa [normal_five_iff_odd_two N he hd h4,he] using h
  · rw [no_raw_roots_if_not_elementary N he]
    simp only [he,false_and,ite_false]

#print axioms exact_local_multiplicity

#print axioms degree_partition
#print axioms odd_partition
#print axioms five_pair_checks
#print axioms elementary_42_is_absorbing
#print axioms six_diamond_cases
#print axioms local_root_count
#print axioms root_implies_elementary
#print axioms raw_root_multiplicity_42

end FourColumnClassification
