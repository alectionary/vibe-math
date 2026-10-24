import PaschRootEnergy

set_option maxHeartbeats 0
open scoped BigOperators
open FourColumnClassification
namespace PaschRootClassification
variable {C : Type*} [Fintype C] [DecidableEq C]

/-- A complete normal graph, with actual pair-check incidences. -/
def PairComplete (N : I → Finset C) : Prop :=
  ∀ i j, i ≠ j → (N i ∩ N j).Nonempty

theorem elementary_pair_complete_iff (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1)
    (he : ∀ c, (support N c).card ≤ 2) :
    PairComplete N ↔ PaschClassification.EvenChecks N := by
  constructor
  · intro hp
    have hone : ∀ i j, i ≠ j → count N {i,j} = 1 := by
      intro i j hij
      unfold count
      rw [pair_cell_eq_inter N he hij]
      have hpos := Finset.card_pos.mpr (hp i j hij)
      have hle := h4 i j hij
      omega
    obtain ⟨h0,h1,h2,h3⟩ := degree_equations N he hd
    have h01 := hone 0 1 (by decide)
    have h02 := hone 0 2 (by decide)
    have h03 := hone 0 3 (by decide)
    have h12 := hone 1 2 (by decide)
    have h13 := hone 1 3 (by decide)
    have h23 := hone 2 3 (by decide)
    have hsing : count N {0}+count N {1}+count N {2}+count N {3}=0 := by omega
    have ho := odd_partition N he
    have hz : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)) = ∅ := by
      apply Finset.card_eq_zero.mp
      have ho' : (Finset.univ.filter (fun c => (support N c).card % 2 = 1)).card =
          count N {0}+count N {1}+count N {2}+count N {3} := by
        simpa [singletons,and_assoc,Nat.add_assoc] using ho
      exact ho'.trans hsing
    intro c
    have hnot : ¬ (support N c).card % 2 = 1 := by
      intro hc
      have hm : c ∈ Finset.univ.filter (fun c => (support N c).card % 2 = 1) := by simp [hc]
      rw [hz] at hm
      exact Finset.notMem_empty c hm
    omega
  · intro hv
    obtain ⟨h01,h02,h03,h12,h13,h23⟩ := PaschClassification.pasch_pair_cells N hd h4 hv
    have hone : ∀ i j : I, i ≠ j → count N {i,j} = 1 := by
      intro i j hij
      fin_cases i <;> fin_cases j <;> first
      | exact (hij rfl).elim
      | exact h01
      | exact h02
      | exact h03
      | exact h12
      | exact h13
      | exact h23
      | (rw [Finset.pair_comm]; exact h01)
      | (rw [Finset.pair_comm]; exact h02)
      | (rw [Finset.pair_comm]; exact h03)
      | (rw [Finset.pair_comm]; exact h12)
      | (rw [Finset.pair_comm]; exact h13)
      | (rw [Finset.pair_comm]; exact h23)
      | simpa only [Finset.pair_comm] using h01
      | simpa only [Finset.pair_comm] using h02
      | simpa only [Finset.pair_comm] using h03
      | simpa only [Finset.pair_comm] using h12
      | simpa only [Finset.pair_comm] using h13
      | simpa only [Finset.pair_comm] using h23
    intro i j hij
    apply Finset.card_pos.mp
    have hh := hone i j hij
    unfold count at hh
    rw [pair_cell_eq_inter N he hij] at hh
    omega

def Raw40 (N : I → Finset C) : Prop :=
  (N 0 ∩ N 1).Nonempty ∧
  2 ∈ PairFormula.properCommon N 0 1 ∧
  3 ∈ PairFormula.properCommon N 0 1 ∧
  (PaschRootEnergy.outsideCols N (N 0 ∪ N 1) 2 ∩
   PaschRootEnergy.outsideCols N (N 0 ∪ N 1) 3).Nonempty

instance (N : I → Finset C) : Decidable (Raw40 N) :=
  inferInstanceAs (Decidable ((N 0 ∩ N 1).Nonempty ∧
  2 ∈ PairFormula.properCommon N 0 1 ∧
  3 ∈ PairFormula.properCommon N 0 1 ∧
  (PaschRootEnergy.outsideCols N (N 0 ∪ N 1) 2 ∩
   PaschRootEnergy.outsideCols N (N 0 ∪ N 1) 3).Nonempty))

theorem singleton_inter_outside (A B R : Finset C)
    (hle : (A ∩ B).card ≤ 1) (hx : ((A \ R) ∩ (B \ R)).Nonempty) :
    ∀ c ∈ A ∩ B, c ∉ R := by
  obtain ⟨d,hd⟩ := hx
  obtain ⟨hdA,hdR⟩ := Finset.mem_sdiff.mp (Finset.mem_inter.mp hd).1
  have hdB := (Finset.mem_sdiff.mp (Finset.mem_inter.mp hd).2).1
  intro c hc
  have hsub : ({d} : Finset C) ⊆ A ∩ B := by simp [hdA,hdB]
  have heq : ({d} : Finset C) = A ∩ B :=
    Finset.eq_of_subset_of_card_le hsub (by simpa using hle)
  rw [← heq] at hc
  simpa only [Finset.mem_singleton.mp hc] using hdR

theorem finite_four_triples : ∀ T : Finset I,
    ¬ (0 ∈ T ∧ 1 ∈ T ∧ 2 ∈ T) →
    ¬ (0 ∈ T ∧ 1 ∈ T ∧ 3 ∈ T) →
    ¬ (0 ∈ T ∧ 2 ∈ T ∧ 3 ∈ T) →
    ¬ (1 ∈ T ∧ 2 ∈ T ∧ 3 ∈ T) → T.card ≤ 2 := by decide

theorem raw40_elementary (N : I → Finset C)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1)
    (hr : Raw40 N) : ∀ c, (support N c).card ≤ 2 := by
  obtain ⟨h01,hw,hz,hout⟩ := hr
  obtain ⟨_,_,h02,h12,ht2⟩ := (Finset.mem_filter.mp hw).2
  obtain ⟨_,_,h03,h13,ht3⟩ := (Finset.mem_filter.mp hz).2
  have hclean := singleton_inter_outside (N 2) (N 3) (N 0 ∪ N 1)
    (h4 2 3 (by decide)) hout
  intro c
  apply finite_four_triples
  · simp only [mem_support]
    rintro ⟨h0,h1,h2⟩
    exact ht2 ⟨c,by simp [h0,h1,h2]⟩
  · simp only [mem_support]
    rintro ⟨h0,h1,h3⟩
    exact ht3 ⟨c,by simp [h0,h1,h3]⟩
  · simp only [mem_support]
    rintro ⟨h0,h2,h3⟩
    exact hclean c (Finset.mem_inter.mpr ⟨h2,h3⟩) (Finset.mem_union_left _ h0)
  · simp only [mem_support]
    rintro ⟨h1,h2,h3⟩
    exact hclean c (Finset.mem_inter.mpr ⟨h2,h3⟩) (Finset.mem_union_right _ h1)

theorem raw40_pair_complete (N : I → Finset C) (hr : Raw40 N) : PairComplete N := by
  obtain ⟨h01,hw,hz,⟨c,hc⟩⟩ := hr
  obtain ⟨_,_,h02,h12,_⟩ := (Finset.mem_filter.mp hw).2
  obtain ⟨_,_,h03,h13,_⟩ := (Finset.mem_filter.mp hz).2
  have h23 : (N 2 ∩ N 3).Nonempty := by
    exact ⟨c,Finset.mem_inter.mpr
      ⟨(Finset.mem_sdiff.mp (Finset.mem_inter.mp hc).1).1,
       (Finset.mem_sdiff.mp (Finset.mem_inter.mp hc).2).1⟩⟩
  intro i j hij
  fin_cases i <;> fin_cases j <;> first
    | exact (hij rfl).elim
    | exact h01
    | exact h02
    | exact h03
    | exact h12
    | exact h13
    | exact h23
    | (rw [Finset.inter_comm]; exact h01)
    | (rw [Finset.inter_comm]; exact h02)
    | (rw [Finset.inter_comm]; exact h03)
    | (rw [Finset.inter_comm]; exact h12)
    | (rw [Finset.inter_comm]; exact h13)
    | (rw [Finset.inter_comm]; exact h23)
    | simpa only [Finset.inter_comm] using h01
    | simpa only [Finset.inter_comm] using h02
    | simpa only [Finset.inter_comm] using h03
    | simpa only [Finset.inter_comm] using h12
    | simpa only [Finset.inter_comm] using h13
    | simpa only [Finset.inter_comm] using h23

/-- The root condition uses six distinct check incidences, not only a projected K4. -/
theorem raw40_iff_even (N : I → Finset C)
    (hd : ∀ i, (N i).card = 3)
    (h4 : ∀ i j, i ≠ j → (N i ∩ N j).card ≤ 1) :
    Raw40 N ↔ PaschClassification.EvenChecks N := by
  constructor
  · intro hr
    exact (elementary_pair_complete_iff N hd h4 (raw40_elementary N h4 hr)).mp
      (raw40_pair_complete N hr)
  · intro hv
    have he := PaschClassification.even_checks_elementary N hd h4 hv
    have hp := (elementary_pair_complete_iff N hd h4 he).mpr hv
    have ht2 := triple_empty N he (i:=0) (j:=1) (k:=2) (by decide) (by decide) (by decide)
    have ht3 := triple_empty N he (i:=0) (j:=1) (k:=3) (by decide) (by decide) (by decide)
    refine ⟨hp 0 1 (by decide),?_,?_,?_⟩
    · simp only [PairFormula.properCommon,Finset.mem_filter,Finset.mem_univ,true_and]
      exact ⟨by decide,by decide,hp 0 2 (by decide),hp 1 2 (by decide),ht2⟩
    · simp only [PairFormula.properCommon,Finset.mem_filter,Finset.mem_univ,true_and]
      exact ⟨by decide,by decide,hp 0 3 (by decide),hp 1 3 (by decide),ht3⟩
    · obtain ⟨c,hc⟩ := hp 2 3 (by decide)
      have ht0 := triple_empty N he (i:=2) (j:=3) (k:=0) (by decide) (by decide) (by decide)
      have ht1 := triple_empty N he (i:=2) (j:=3) (k:=1) (by decide) (by decide) (by decide)
      have hnot : c ∉ N 0 ∪ N 1 := by
        intro hm
        rcases Finset.mem_union.mp hm with h0 | h1
        · exact ht0 ⟨c,Finset.mem_inter.mpr ⟨hc,h0⟩⟩
        · exact ht1 ⟨c,Finset.mem_inter.mpr ⟨hc,h1⟩⟩
      exact ⟨c,Finset.mem_inter.mpr
        ⟨Finset.mem_sdiff.mpr ⟨(Finset.mem_inter.mp hc).1,hnot⟩,
         Finset.mem_sdiff.mpr ⟨(Finset.mem_inter.mp hc).2,hnot⟩⟩⟩

#print axioms raw40_iff_even
#print axioms raw40_elementary
end PaschRootClassification
