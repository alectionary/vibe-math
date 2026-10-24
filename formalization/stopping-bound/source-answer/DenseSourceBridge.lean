module
public import SourceQuestionAnswer
@[expose] public section
open Matrix
namespace StoppingSpectral.DenseSource

def support : Finset (ZMod 2) := {0,1}
lemma support_univ : support = Finset.univ := by decide +kernel

def B : Matrix (ZMod 2) (ZMod 2) ℝ := supportCirculant support
def A : Matrix (Fin 1 × ZMod 2) (Fin 1 × ZMod 2) ℝ := fun i j => B i.2 j.2

def H : Matrix (Fin 1 × ZMod 2)
    ((Fin 1 × ZMod 2) ⊕ (Fin 1 × ZMod 2)) ℝ := scalarFactorMatrix A B
lemma B_one (i j : ZMod 2) : B i j = 1 := by
  simp [B,supportCirculant,support_univ]
lemma H_one (i : Fin 1 × ZMod 2)
    (j : (Fin 1 × ZMod 2) ⊕ (Fin 1 × ZMod 2)) : H i j = 1 := by
  rcases j with j | j
  · simp [H,scalarFactorMatrix,A,B_one]
  · have h : i.1 = j.1 := Subsingleton.elim _ _
    simp [H,scalarFactorMatrix,h,B_one]

noncomputable def rowEquiv : (Fin 1 × ZMod 2) ≃ Fin 2 :=
  Fintype.equivOfCardEq (by simp)
noncomputable def colEquiv :
    ((Fin 1 × ZMod 2) ⊕ (Fin 1 × ZMod 2)) ≃ Fin 4 :=
  Fintype.equivOfCardEq (by simp)

/-- Actual scalar-factor expansion under bijective row and column relabeling. -/
noncomputable def expanded : Matrix (Fin 2) (Fin 4) ℝ :=
  fun i j => H (rowEquiv.symm i) (colEquiv.symm j)
lemma expanded_eq : expanded = denseExample := by
  ext i j
  exact H_one _ _

noncomputable def binary : Matrix (Fin 2) (Fin 4) (ZMod 2) :=
  fun i j => if expanded i j = 1 then 1 else 0
lemma binary_eq : binary = denseExampleBinary := by
  ext i j
  simp [binary,expanded_eq,denseExample,denseExampleBinary]

/-- Companion block form [I_1 tensor B | A^T] from the same constituents. -/
def HZ : Matrix (Fin 1 × ZMod 2)
    ((Fin 1 × ZMod 2) ⊕ (Fin 1 × ZMod 2)) ℝ :=
  fun i j => match j with
    | Sum.inl j => if i.1 = j.1 then B i.2 j.2 else 0
    | Sum.inr j => A j i
lemma HZ_one (i : Fin 1 × ZMod 2)
    (j : (Fin 1 × ZMod 2) ⊕ (Fin 1 × ZMod 2)) : HZ i j = 1 := by
  rcases j with j | j
  · have h : i.1 = j.1 := Subsingleton.elim _ _
    simp [HZ,h,B_one]
  · simp [HZ,A,B_one]
noncomputable def binaryZ : Matrix (Fin 2) (Fin 4) (ZMod 2) :=
  fun i j => if HZ (rowEquiv.symm i) (colEquiv.symm j) = 1 then 1 else 0
lemma binaryZ_eq : binaryZ = denseExampleBinary := by
  ext i j
  simp [binaryZ,HZ_one,denseExampleBinary]
lemma column_weight (j : Fin 4) : (∑ i, expanded i j) = 2 := by
  rw [expanded_eq]
  norm_num [denseExample,Fin.sum_univ_succ]
lemma row_weight (i : Fin 2) : (∑ j, expanded i j) = 4 := by
  rw [expanded_eq]
  norm_num [denseExample,Fin.sum_univ_succ]

/-- Source-circulant, expanded-spectrum, roots, CSS and stopping consumer. -/
theorem source_certificate :
    B = supportCirculant ({0,1} : Finset (ZMod 2)) ∧
    expanded = denseExample ∧ binary = denseExampleBinary ∧
    binaryZ = denseExampleBinary ∧
    (∀ j, (∑ i, expanded i j) = 2) ∧ (∀ i, (∑ j, expanded i j) = 4) ∧
    eigs expanded ⟨1,by norm_num⟩ = 0 ∧
    eigs expanded ⟨1,by norm_num⟩ < (2:ℝ)/2 ∧
    sourceSmallRoot 2 2 (eigs expanded ⟨1,by norm_num⟩) = 0 ∧
    sourceLargeRoot 2 2 (eigs expanded ⟨1,by norm_num⟩) = 2 ∧
    binary * binaryZᵀ = 0 ∧
    (∀ S, IsStopping expanded S ↔ 2 ≤ S.card) := by
  refine ⟨rfl,expanded_eq,binary_eq,binaryZ_eq,column_weight,row_weight,?_,?_,?_,?_,?_,?_⟩
  · rw [expanded_eq]; exact denseExample_second
  · rw [expanded_eq,denseExample_second]; norm_num
  · rw [expanded_eq,denseExample_second]; rw [sourceSmallRoot_eq 2 2 0 (by norm_num) (by norm_num)]; norm_num
  · rw [expanded_eq,denseExample_second]; rw [sourceLargeRoot_eq 2 2 0 (by norm_num) (by norm_num)]; norm_num
  · rw [binary_eq,binaryZ_eq]; exact denseExample_css
  · rw [expanded_eq]; exact denseExample_stopping
end StoppingSpectral.DenseSource
