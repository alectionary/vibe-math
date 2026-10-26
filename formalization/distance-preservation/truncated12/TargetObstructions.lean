import SourceCycleFacts
import PureDistance
import PackedTablesAudit
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace TruncatedDistance
open FamilyWords TannerSix KernelCatalog
variable {L : ℕ} [NeZero L]

def NoColumnPartition (e : Fin 3 → Fin 4 → ZMod L) : Prop :=
  ∀ a b c d : Fin 4,a≠b → a≠c → a≠d → b≠c → b≠d → c≠d →
    ¬(∀ i,columnForm e i a b c d=0)
def NoTripleRow (e : Fin 3 → Fin 4 → ZMod L) : Prop :=
  ∀ i j k : Fin 3,i≠j → i≠k → j≠k → ∀ a b c : Fin 4,
    a≠b → a≠c → b≠c →
      ¬(rowForm e i j k a=rowForm e i j k b ∧ rowForm e i j k a=rowForm e i j k c)
def sourceVars (e : Fin 3 → Fin 4 → ZMod L) : Fin 6 → ZMod L :=
  ![e 1 1,e 1 2,e 1 3,e 2 1,e 2 2,e 2 3]
def targetVector (p t : ℕ) (k : Fin 6) : Int := targetValue p t k.val
def targetForm (e : Fin 3 → Fin 4 → ZMod L) (p t : ℕ) : ZMod L :=
  integerDot (targetVector p t) (sourceVars e)
def needsClassicalBound (p : ℕ) : Prop := p=48 ∨ p=49 ∨ p=52
instance (p : ℕ) : Decidable (needsClassicalBound p) := by unfold needsClassicalBound;infer_instance


theorem vector_0_0 : targetVector 0 0=![(-2),0,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_0_1 : targetVector 0 1=![0,(-2),0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_0_2 : targetVector 0 2=![0,0,(-2),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_1_0 : targetVector 1 0=![1,0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_1_1 : targetVector 1 1=![0,1,0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_2_0 : targetVector 2 0=![1,0,0,(-2),0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_2_1 : targetVector 2 1=![0,1,0,0,(-2),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_3_0 : targetVector 3 0=![1,0,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_4_0 : targetVector 4 0=![(-2),0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_4_1 : targetVector 4 1=![0,(-2),0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_5_0 : targetVector 5 0=![(-2),0,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_5_1 : targetVector 5 1=![0,0,0,(-2),0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_6_0 : targetVector 6 0=![0,1,(-1),0,(-1),1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_7_0 : targetVector 7 0=![0,(-1),1,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_8_0 : targetVector 8 0=![0,0,0,0,(-1),1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_9_0 : targetVector 9 0=![0,0,(-2),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_9_1 : targetVector 9 1=![0,0,0,0,0,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_10_0 : targetVector 10 0=![1,(-1),0,(-1),1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_11_0 : targetVector 11 0=![(-1),1,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_12_0 : targetVector 12 0=![0,0,1,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_13_0 : targetVector 13 0=![0,0,0,(-1),1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_14_0 : targetVector 14 0=![1,0,0,(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_15_0 : targetVector 15 0=![1,0,0,(-1),1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_16_0 : targetVector 16 0=![0,(-2),0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_16_1 : targetVector 16 1=![0,0,0,0,(-2),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_17_0 : targetVector 17 0=![1,0,(-1),(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_18_0 : targetVector 18 0=![(-1),0,1,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_19_0 : targetVector 19 0=![0,1,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_20_0 : targetVector 20 0=![0,0,0,(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_21_0 : targetVector 21 0=![0,2,(-2),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_21_1 : targetVector 21 1=![0,0,0,0,2,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_22_0 : targetVector 22 0=![(-1),0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_23_0 : targetVector 23 0=![0,0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_24_0 : targetVector 24 0=![1,(-1),(-1),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_24_1 : targetVector 24 1=![0,0,0,1,(-1),(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_25_0 : targetVector 25 0=![0,(-1),0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_26_0 : targetVector 26 0=![0,0,0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_27_0 : targetVector 27 0=![0,0,(-1),0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_28_0 : targetVector 28 0=![0,0,0,0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_29_0 : targetVector 29 0=![2,0,(-2),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_29_1 : targetVector 29 1=![0,0,0,2,0,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_30_0 : targetVector 30 0=![(-1),1,(-1),0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_30_1 : targetVector 30 1=![0,0,0,(-1),1,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_31_0 : targetVector 31 0=![2,(-2),0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_31_1 : targetVector 31 1=![0,0,0,2,(-2),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_32_0 : targetVector 32 0=![(-1),(-1),1,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_32_1 : targetVector 32 1=![0,0,0,(-1),(-1),1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_33_0 : targetVector 33 0=![(-1),0,0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_34_0 : targetVector 34 0=![0,0,1,1,0,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_35_0 : targetVector 35 0=![0,1,0,1,(-1),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_36_0 : targetVector 36 0=![0,0,1,0,1,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_37_0 : targetVector 37 0=![0,1,0,0,(-1),1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_38_0 : targetVector 38 0=![1,(-1),0,(-1),0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_39_0 : targetVector 39 0=![0,0,(-1),1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_40_0 : targetVector 40 0=![(-1),1,0,0,(-1),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_41_0 : targetVector 41 0=![0,0,(-1),0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_42_0 : targetVector 42 0=![1,0,(-1),(-1),0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_43_0 : targetVector 43 0=![0,(-1),0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_44_0 : targetVector 44 0=![(-1),0,0,0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_45_0 : targetVector 45 0=![(-1),0,1,0,0,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_46_0 : targetVector 46 0=![0,(-1),0,0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_47_0 : targetVector 47 0=![(-1),1,0,0,(-1),1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_48_0 : targetVector 48 0=![0,5,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_48_1 : targetVector 48 1=![0,0,0,0,5,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_49_0 : targetVector 49 0=![0,0,5,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_49_1 : targetVector 49 1=![0,0,0,0,0,5] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_50_0 : targetVector 50 0=![0,1,(-1),0,(-1),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_51_0 : targetVector 51 0=![0,(-1),1,0,0,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_52_0 : targetVector 52 0=![5,0,0,0,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_52_1 : targetVector 52 1=![0,0,0,5,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_53_0 : targetVector 53 0=![(-1),0,1,0,1,(-1)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_54_0 : targetVector 54 0=![(-1),1,0,2,(-2),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_54_1 : targetVector 54 1=![(-1),0,1,2,0,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_55_0 : targetVector 55 0=![2,(-2),0,(-1),1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_55_1 : targetVector 55 1=![2,0,(-2),(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_56_0 : targetVector 56 0=![(-1),1,0,(-1),1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_56_1 : targetVector 56 1=![(-1),0,1,(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_57_0 : targetVector 57 0=![1,0,0,(-2),0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_57_1 : targetVector 57 1=![0,0,1,0,0,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_58_0 : targetVector 58 0=![(-2),0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_58_1 : targetVector 58 1=![0,0,(-2),0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_59_0 : targetVector 59 0=![1,0,0,1,0,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_59_1 : targetVector 59 1=![0,0,1,0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_60_0 : targetVector 60 0=![1,(-1),0,(-1),0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_61_0 : targetVector 61 0=![0,1,0,0,(-2),0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_61_1 : targetVector 61 1=![0,0,1,0,0,(-2)] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_62_0 : targetVector 62 0=![0,(-2),0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_62_1 : targetVector 62 1=![0,0,(-2),0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_63_0 : targetVector 63 0=![0,1,0,0,1,0] := by
  funext k
  fin_cases k <;> decide +kernel

theorem vector_63_1 : targetVector 63 1=![0,0,1,0,0,1] := by
  funext k
  fin_cases k <;> decide +kernel

theorem obstruction_0
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 0 → 10<D)
    (hz : ∀ t : Fin (targetArity 0),targetForm e 0 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 0 0) (sourceVars e)=0 at h0
  rw [vector_0_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 0 1) (sourceVars e)=0 at h1
  rw [vector_0_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  have h2 := hz ⟨2,by decide +kernel⟩
  change integerDot (targetVector 0 2) (sourceVars e)=0 at h2
  rw [vector_0_2] at h2
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h2
  apply row_small_torsion_impossible e h4 2 (by decide) (by decide) 0 1 (by decide)
  intro j
  fin_cases j
  · simp [hC0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 0 1-e 1 1)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 0 2-e 1 2)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 0 3-e 1 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h2 | linear_combination -h2

theorem obstruction_1
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 1 → 10<D)
    (hz : ∀ t : Fin (targetArity 1),targetForm e 1 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 1 0) (sourceVars e)=0 at h0
  rw [vector_1_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 1 1) (sourceVars e)=0 at h1
  rw [vector_1_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 1 2 0 (by decide) (by decide) (by decide) 0 1 2 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_2
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 2 → 10<D)
    (hz : ∀ t : Fin (targetArity 2),targetForm e 2 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 2 0) (sourceVars e)=0 at h0
  rw [vector_2_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 2 1) (sourceVars e)=0 at h1
  rw [vector_2_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 1 2 (by decide) (by decide) (by decide) 0 1 2 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_3
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 3 → 10<D)
    (hz : ∀ t : Fin (targetArity 3),targetForm e 3 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 3 0) (sourceVars e)=0 at h0
  rw [vector_3_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 0 1 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_4
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 4 → 10<D)
    (hz : ∀ t : Fin (targetArity 4),targetForm e 4 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 4 0) (sourceVars e)=0 at h0
  rw [vector_4_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 4 1) (sourceVars e)=0 at h1
  rw [vector_4_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 2 1 (by decide) (by decide) (by decide) 0 1 2 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_5
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 5 → 10<D)
    (hz : ∀ t : Fin (targetArity 5),targetForm e 5 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 5 0) (sourceVars e)=0 at h0
  rw [vector_5_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 5 1) (sourceVars e)=0 at h1
  rw [vector_5_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 0 1 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 0-e 1 1)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 0-e 2 1)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_6
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 6 → 10<D)
    (hz : ∀ t : Fin (targetArity 6),targetForm e 6 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 6 0) (sourceVars e)=0 at h0
  rw [vector_6_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 2 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_7
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 7 → 10<D)
    (hz : ∀ t : Fin (targetArity 7),targetForm e 7 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 7 0) (sourceVars e)=0 at h0
  rw [vector_7_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 2 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_8
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 8 → 10<D)
    (hz : ∀ t : Fin (targetArity 8),targetForm e 8 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 8 0) (sourceVars e)=0 at h0
  rw [vector_8_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 2 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_9
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 9 → 10<D)
    (hz : ∀ t : Fin (targetArity 9),targetForm e 9 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 9 0) (sourceVars e)=0 at h0
  rw [vector_9_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 9 1) (sourceVars e)=0 at h1
  rw [vector_9_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 0 3 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 0-e 1 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 0-e 2 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_10
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 10 → 10<D)
    (hz : ∀ t : Fin (targetArity 10),targetForm e 10 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 10 0) (sourceVars e)=0 at h0
  rw [vector_10_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 1 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_11
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 11 → 10<D)
    (hz : ∀ t : Fin (targetArity 11),targetForm e 11 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 11 0) (sourceVars e)=0 at h0
  rw [vector_11_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 1 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_12
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 12 → 10<D)
    (hz : ∀ t : Fin (targetArity 12),targetForm e 12 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 12 0) (sourceVars e)=0 at h0
  rw [vector_12_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 0 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_13
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 13 → 10<D)
    (hz : ∀ t : Fin (targetArity 13),targetForm e 13 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 13 0) (sourceVars e)=0 at h0
  rw [vector_13_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 1 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_14
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 14 → 10<D)
    (hz : ∀ t : Fin (targetArity 14),targetForm e 14 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 14 0) (sourceVars e)=0 at h0
  rw [vector_14_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 1 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_15
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 15 → 10<D)
    (hz : ∀ t : Fin (targetArity 15),targetForm e 15 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 15 0) (sourceVars e)=0 at h0
  rw [vector_15_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 1 2 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_16
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 16 → 10<D)
    (hz : ∀ t : Fin (targetArity 16),targetForm e 16 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 16 0) (sourceVars e)=0 at h0
  rw [vector_16_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 16 1) (sourceVars e)=0 at h1
  rw [vector_16_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 0 2 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 0-e 1 2)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 0-e 2 2)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_17
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 17 → 10<D)
    (hz : ∀ t : Fin (targetArity 17),targetForm e 17 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 17 0) (sourceVars e)=0 at h0
  rw [vector_17_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 1 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_18
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 18 → 10<D)
    (hz : ∀ t : Fin (targetArity 18),targetForm e 18 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 18 0) (sourceVars e)=0 at h0
  rw [vector_18_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 1 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_19
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 19 → 10<D)
    (hz : ∀ t : Fin (targetArity 19),targetForm e 19 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 19 0) (sourceVars e)=0 at h0
  rw [vector_19_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 1 (by decide) 0 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_20
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 20 → 10<D)
    (hz : ∀ t : Fin (targetArity 20),targetForm e 20 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 20 0) (sourceVars e)=0 at h0
  rw [vector_20_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 1 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_21
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 21 → 10<D)
    (hz : ∀ t : Fin (targetArity 21),targetForm e 21 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 21 0) (sourceVars e)=0 at h0
  rw [vector_21_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 21 1) (sourceVars e)=0 at h1
  rw [vector_21_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 2 3 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 2-e 1 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 2-e 2 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_22
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 22 → 10<D)
    (hz : ∀ t : Fin (targetArity 22),targetForm e 22 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 22 0) (sourceVars e)=0 at h0
  rw [vector_22_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 0 1 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_23
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 23 → 10<D)
    (hz : ∀ t : Fin (targetArity 23),targetForm e 23 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 23 0) (sourceVars e)=0 at h0
  rw [vector_23_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 0 1 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_24
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 24 → 10<D)
    (hz : ∀ t : Fin (targetArity 24),targetForm e 24 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 24 0) (sourceVars e)=0 at h0
  rw [vector_24_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 24 1) (sourceVars e)=0 at h1
  rw [vector_24_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hCP 0 1 2 3 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  intro i
  fin_cases i
  · simp [columnForm,hR0]
  · change columnForm e 1 0 1 2 3=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · change columnForm e 2 0 1 2 3=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_25
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 25 → 10<D)
    (hz : ∀ t : Fin (targetArity 25),targetForm e 25 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 25 0) (sourceVars e)=0 at h0
  rw [vector_25_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 0 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_26
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 26 → 10<D)
    (hz : ∀ t : Fin (targetArity 26),targetForm e 26 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 26 0) (sourceVars e)=0 at h0
  rw [vector_26_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 0 2 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_27
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 27 → 10<D)
    (hz : ∀ t : Fin (targetArity 27),targetForm e 27 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 27 0) (sourceVars e)=0 at h0
  rw [vector_27_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 1 2 (by decide) 0 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_28
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 28 → 10<D)
    (hz : ∀ t : Fin (targetArity 28),targetForm e 28 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 28 0) (sourceVars e)=0 at h0
  rw [vector_28_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_four_form_nonzero e h4 0 2 (by decide) 0 3 (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_29
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 29 → 10<D)
    (hz : ∀ t : Fin (targetArity 29),targetForm e 29 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 29 0) (sourceVars e)=0 at h0
  rw [vector_29_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 29 1) (sourceVars e)=0 at h1
  rw [vector_29_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 1 3 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 1-e 1 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 1-e 2 3)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_30
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 30 → 10<D)
    (hz : ∀ t : Fin (targetArity 30),targetForm e 30 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 30 0) (sourceVars e)=0 at h0
  rw [vector_30_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 30 1) (sourceVars e)=0 at h1
  rw [vector_30_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hCP 0 2 1 3 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  intro i
  fin_cases i
  · simp [columnForm,hR0]
  · change columnForm e 1 0 2 1 3=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · change columnForm e 2 0 2 1 3=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_31
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 31 → 10<D)
    (hz : ∀ t : Fin (targetArity 31),targetForm e 31 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 31 0) (sourceVars e)=0 at h0
  rw [vector_31_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 31 1) (sourceVars e)=0 at h1
  rw [vector_31_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply column_two_torsion_impossible e h4 1 2 (by decide)
  intro i
  fin_cases i
  · simp [hR0]
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 1 1-e 1 2)=0
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · simp only [nsmul_eq_mul]
    change (2 : ZMod L)*(e 2 1-e 2 2)=0
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_32
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 32 → 10<D)
    (hz : ∀ t : Fin (targetArity 32),targetForm e 32 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 32 0) (sourceVars e)=0 at h0
  rw [vector_32_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 32 1) (sourceVars e)=0 at h1
  rw [vector_32_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hCP 0 3 1 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)
  intro i
  fin_cases i
  · simp [columnForm,hR0]
  · change columnForm e 1 0 3 1 2=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h0 | linear_combination -h0
  · change columnForm e 2 0 3 1 2=0
    unfold columnForm
    try simp only [hR0,hC0]
    first | linear_combination h1 | linear_combination -h1

theorem obstruction_33
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 33 → 10<D)
    (hz : ∀ t : Fin (targetArity 33),targetForm e 33 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 33 0) (sourceVars e)=0 at h0
  rw [vector_33_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 0 2 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_34
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 34 → 10<D)
    (hz : ∀ t : Fin (targetArity 34),targetForm e 34 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 34 0) (sourceVars e)=0 at h0
  rw [vector_34_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 3 1 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_35
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 35 → 10<D)
    (hz : ∀ t : Fin (targetArity 35),targetForm e 35 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 35 0) (sourceVars e)=0 at h0
  rw [vector_35_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 2 1 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_36
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 36 → 10<D)
    (hz : ∀ t : Fin (targetArity 36),targetForm e 36 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 36 0) (sourceVars e)=0 at h0
  rw [vector_36_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 3 2 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_37
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 37 → 10<D)
    (hz : ∀ t : Fin (targetArity 37),targetForm e 37 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 37 0) (sourceVars e)=0 at h0
  rw [vector_37_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 0 2 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_38
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 38 → 10<D)
    (hz : ∀ t : Fin (targetArity 38),targetForm e 38 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 38 0) (sourceVars e)=0 at h0
  rw [vector_38_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 2 1 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_39
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 39 → 10<D)
    (hz : ∀ t : Fin (targetArity 39),targetForm e 39 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 39 0) (sourceVars e)=0 at h0
  rw [vector_39_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 3 0 1 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_40
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 40 → 10<D)
    (hz : ∀ t : Fin (targetArity 40),targetForm e 40 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 40 0) (sourceVars e)=0 at h0
  rw [vector_40_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 2 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_41
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 41 → 10<D)
    (hz : ∀ t : Fin (targetArity 41),targetForm e 41 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 41 0) (sourceVars e)=0 at h0
  rw [vector_41_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 3 0 2 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_42
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 42 → 10<D)
    (hz : ∀ t : Fin (targetArity 42),targetForm e 42 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 42 0) (sourceVars e)=0 at h0
  rw [vector_42_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 3 1 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_43
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 43 → 10<D)
    (hz : ∀ t : Fin (targetArity 43),targetForm e 43 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 43 0) (sourceVars e)=0 at h0
  rw [vector_43_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 2 0 1 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_44
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 44 → 10<D)
    (hz : ∀ t : Fin (targetArity 44),targetForm e 44 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 44 0) (sourceVars e)=0 at h0
  rw [vector_44_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 0 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_45
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 45 → 10<D)
    (hz : ∀ t : Fin (targetArity 45),targetForm e 45 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 45 0) (sourceVars e)=0 at h0
  rw [vector_45_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 3 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_46
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 46 → 10<D)
    (hz : ∀ t : Fin (targetArity 46),targetForm e 46 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 46 0) (sourceVars e)=0 at h0
  rw [vector_46_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 2 0 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_47
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 47 → 10<D)
    (hz : ∀ t : Fin (targetArity 47),targetForm e 47 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 47 0) (sourceVars e)=0 at h0
  rw [vector_47_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 2 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_48
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 48 → 10<D)
    (hz : ∀ t : Fin (targetArity 48),targetForm e 48 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 48 0) (sourceVars e)=0 at h0
  rw [vector_48_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 48 1) (sourceVars e)=0 at h1
  rw [vector_48_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  have hsmall : D≤10 := torsion5_forces_classical_bound e D hC 2 (by decide) hC0 (by
    intro i
    fin_cases i
    · simp [hR0]
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 1 2=0
      first | linear_combination h0 | linear_combination -h0
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 2 2=0
      first | linear_combination h1 | linear_combination -h1)
  have hlarge : 10<D := hExtra (by decide +kernel)
  omega

theorem obstruction_49
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 49 → 10<D)
    (hz : ∀ t : Fin (targetArity 49),targetForm e 49 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 49 0) (sourceVars e)=0 at h0
  rw [vector_49_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 49 1) (sourceVars e)=0 at h1
  rw [vector_49_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  have hsmall : D≤10 := torsion5_forces_classical_bound e D hC 3 (by decide) hC0 (by
    intro i
    fin_cases i
    · simp [hR0]
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 1 3=0
      first | linear_combination h0 | linear_combination -h0
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 2 3=0
      first | linear_combination h1 | linear_combination -h1)
  have hlarge : 10<D := hExtra (by decide +kernel)
  omega

theorem obstruction_50
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 50 → 10<D)
    (hz : ∀ t : Fin (targetArity 50),targetForm e 50 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 50 0) (sourceVars e)=0 at h0
  rw [vector_50_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 3 2 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_51
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 51 → 10<D)
    (hz : ∀ t : Fin (targetArity 51),targetForm e 51 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 51 0) (sourceVars e)=0 at h0
  rw [vector_51_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 2 3 0 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_52
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 52 → 10<D)
    (hz : ∀ t : Fin (targetArity 52),targetForm e 52 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 52 0) (sourceVars e)=0 at h0
  rw [vector_52_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 52 1) (sourceVars e)=0 at h1
  rw [vector_52_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  have hsmall : D≤10 := torsion5_forces_classical_bound e D hC 1 (by decide) hC0 (by
    intro i
    fin_cases i
    · simp [hR0]
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 1 1=0
      first | linear_combination h0 | linear_combination -h0
    · simp only [nsmul_eq_mul]
      change (5 : ZMod L)*e 2 1=0
      first | linear_combination h1 | linear_combination -h1)
  have hlarge : 10<D := hExtra (by decide +kernel)
  omega

theorem obstruction_53
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 53 → 10<D)
    (hz : ∀ t : Fin (targetArity 53),targetForm e 53 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 53 0) (sourceVars e)=0 at h0
  rw [vector_53_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 1 3 2 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_54
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 54 → 10<D)
    (hz : ∀ t : Fin (targetArity 54),targetForm e 54 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 54 0) (sourceVars e)=0 at h0
  rw [vector_54_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 54 1) (sourceVars e)=0 at h1
  rw [vector_54_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 1 2 (by decide) (by decide) (by decide) 1 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_55
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 55 → 10<D)
    (hz : ∀ t : Fin (targetArity 55),targetForm e 55 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 55 0) (sourceVars e)=0 at h0
  rw [vector_55_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 55 1) (sourceVars e)=0 at h1
  rw [vector_55_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 2 1 (by decide) (by decide) (by decide) 1 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_56
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 56 → 10<D)
    (hz : ∀ t : Fin (targetArity 56),targetForm e 56 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 56 0) (sourceVars e)=0 at h0
  rw [vector_56_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 56 1) (sourceVars e)=0 at h1
  rw [vector_56_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 1 2 0 (by decide) (by decide) (by decide) 1 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_57
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 57 → 10<D)
    (hz : ∀ t : Fin (targetArity 57),targetForm e 57 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 57 0) (sourceVars e)=0 at h0
  rw [vector_57_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 57 1) (sourceVars e)=0 at h1
  rw [vector_57_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 1 2 (by decide) (by decide) (by decide) 0 1 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_58
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 58 → 10<D)
    (hz : ∀ t : Fin (targetArity 58),targetForm e 58 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 58 0) (sourceVars e)=0 at h0
  rw [vector_58_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 58 1) (sourceVars e)=0 at h1
  rw [vector_58_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 2 1 (by decide) (by decide) (by decide) 0 1 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_59
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 59 → 10<D)
    (hz : ∀ t : Fin (targetArity 59),targetForm e 59 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 59 0) (sourceVars e)=0 at h0
  rw [vector_59_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 59 1) (sourceVars e)=0 at h1
  rw [vector_59_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 1 2 0 (by decide) (by decide) (by decide) 0 1 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_60
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 60 → 10<D)
    (hz : ∀ t : Fin (targetArity 60),targetForm e 60 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 60 0) (sourceVars e)=0 at h0
  rw [vector_60_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  apply source_six_form_nonzero e h6 hR0 2 1 3 (by decide) (by decide) (by decide)
  try simp only [hR0,hC0]
  first | linear_combination h0 | linear_combination -h0

theorem obstruction_61
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 61 → 10<D)
    (hz : ∀ t : Fin (targetArity 61),targetForm e 61 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 61 0) (sourceVars e)=0 at h0
  rw [vector_61_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 61 1) (sourceVars e)=0 at h1
  rw [vector_61_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 1 2 (by decide) (by decide) (by decide) 0 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_62
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 62 → 10<D)
    (hz : ∀ t : Fin (targetArity 62),targetForm e 62 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 62 0) (sourceVars e)=0 at h0
  rw [vector_62_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 62 1) (sourceVars e)=0 at h1
  rw [vector_62_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 0 2 1 (by decide) (by decide) (by decide) 0 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem obstruction_63
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (hExtra : needsClassicalBound 63 → 10<D)
    (hz : ∀ t : Fin (targetArity 63),targetForm e 63 t.val=0) : False := by
  have h0 := hz ⟨0,by decide +kernel⟩
  change integerDot (targetVector 63 0) (sourceVars e)=0 at h0
  rw [vector_63_0] at h0
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h0
  have h1 := hz ⟨1,by decide +kernel⟩
  change integerDot (targetVector 63 1) (sourceVars e)=0 at h1
  rw [vector_63_1] at h1
  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h1
  apply hP 1 2 0 (by decide) (by decide) (by decide) 0 2 3 (by decide) (by decide) (by decide)
  constructor
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h0 | linear_combination h0
  · unfold rowForm
    try simp only [hR0,hC0]
    first | linear_combination -h1 | linear_combination h1

theorem source_target_obstruction
    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
    (p : Fin 64) (hExtra : needsClassicalBound p.val → 10<D)
    (hz : ∀ t : Fin (targetArity p.val),targetForm e p.val t.val=0) : False := by
  fin_cases p
  · exact obstruction_0 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_1 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_2 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_3 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_4 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_5 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_6 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_7 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_8 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_9 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_10 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_11 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_12 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_13 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_14 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_15 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_16 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_17 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_18 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_19 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_20 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_21 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_22 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_23 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_24 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_25 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_26 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_27 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_28 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_29 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_30 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_31 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_32 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_33 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_34 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_35 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_36 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_37 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_38 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_39 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_40 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_41 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_42 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_43 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_44 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_45 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_46 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_47 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_48 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_49 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_50 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_51 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_52 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_53 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_54 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_55 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_56 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_57 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_58 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_59 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_60 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_61 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_62 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
  · exact obstruction_63 e h4 h6 hR0 hC0 hCP hP D hC hExtra hz
#print axioms source_target_obstruction
end TruncatedDistance
