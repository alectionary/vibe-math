import FullQuantumAFast
import FullQuantumBFast
import QuantumRows
import QuantumConstruction
set_option maxHeartbeats 0
namespace SmallQuantum

def actualCheckGram (H : V → Finset C) (c d : C) : ℕ :=
  (Finset.univ.filter (fun v => c ∈ H v ∧ d ∈ H v)).card

theorem actual_same_full_gram : actualCheckGram XAfast = actualCheckGram XBfast := by
  funext c d
  have ha : Finset.univ.filter (fun v => c ∈ XAfast v ∧ d ∈ XAfast v) = rowXA c ∩ rowXA d := by
    rw [rowXA_correct,rowXA_correct]
    ext v
    simp
  have hb : Finset.univ.filter (fun v => c ∈ XBfast v ∧ d ∈ XBfast v) = rowXB c ∩ rowXB d := by
    rw [rowXB_correct,rowXB_correct]
    ext v
    simp
  unfold actualCheckGram
  rw [ha,hb]
  exact same_full_gram c d

theorem source_construction_counts :
    GlobalCounting.count42 (quantumXColumns Absorbing42Small.baseA) = 49 ∧
    GlobalCounting.count42 (quantumXColumns Absorbing42Small.baseB) = 35 := by
  rw [constructed_XA,constructed_XB]
  exact ⟨full_count_Afast,full_count_Bfast⟩

theorem no_full_gram_only_count :
    ¬ ∃ f : (C → C → ℕ) → ℕ,
      ∀ H : V → Finset C,
        (∀ v, (H v).card = 3) →
        (∀ u v, u ≠ v → (H u ∩ H v).card ≤ 1) →
        f (actualCheckGram H) = GlobalCounting.count42 H := by
  rintro ⟨f,hf⟩
  have ha := hf XAfast degree_A no_four_A
  have hb := hf XBfast degree_B no_four_B
  rw [actual_same_full_gram,full_count_Afast] at ha
  rw [full_count_Bfast] at hb
  omega

#print axioms actual_same_full_gram
#print axioms source_construction_counts
#print axioms no_full_gram_only_count
end SmallQuantum
