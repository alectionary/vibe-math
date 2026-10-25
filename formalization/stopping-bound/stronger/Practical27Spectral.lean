import Practical27
import SpectralPlane
namespace Practical27.Spectral
open Matrix StoppingSpectral StoppingPlane Finset
abbrev C := ZMod 27
abbrev V := Bool × C
def HInt : Matrix C V ℤ := Practical27.HX ℤ
def HR : Matrix C V ℝ := Practical27.HX ℝ
def uZ (c : C) : ℤ := if c=0 ∨ c=8 then 1 else if c=4 ∨ c=12 then -1 else 0
def vZ (c : C) : ℤ := if c=20 ∨ c=1 then 1 else if c=24 ∨ c=5 then -1 else 0
def normZ (x : C → ℤ) : ℤ := ∑ c, (x c)^2
def dotZ (x y : C → ℤ) : ℤ := ∑ c, x c*y c
def enZ (x : C → ℤ) : ℤ := ∑ v, (∑ c, HInt c v*x c)^2
def crossZ (x y : C → ℤ) : ℤ := ∑ v, (∑ c,HInt c v*x c)*(∑ c,HInt c v*y c)
set_option maxRecDepth 100000
set_option maxHeartbeats 0
lemma norm_u : normZ uZ = 4 := by decide +kernel
lemma norm_v : normZ vZ = 4 := by decide +kernel
lemma dot_uv : dotZ uZ vZ = 0 := by decide +kernel
lemma energy_u : enZ uZ = 34 := by decide +kernel
lemma energy_v : enZ vZ = 34 := by decide +kernel
lemma cross_uv : crossZ uZ vZ = 0 := by decide +kernel

def uR (c : C) : ℝ := uZ c
def vR (c : C) : ℝ := vZ c
lemma matrix_cast (c : C) (v : V) : HR c v = (HInt c v : ℝ) := by
  simp only [HR,HInt,Practical27.HX,JointSidon.entry]
  split <;> simp
lemma norm_cast (x : C → ℤ) : normSq (fun c => (x c : ℝ)) = (normZ x : ℝ) := by
  simp [normSq,normZ]
lemma dot_cast (x y : C → ℤ) : innerForm (fun c => (x c : ℝ)) (fun c => (y c : ℝ)) = (dotZ x y : ℝ) := by
  simp [innerForm,dotZ]
lemma energy_cast (x : C → ℤ) : energy HR (fun c => (x c : ℝ)) = (enZ x : ℝ) := by
  simp [energy,enZ,matrix_cast]
lemma cross_cast (x y : C → ℤ) : gramForm HR (fun c => (x c : ℝ)) (fun c => (y c : ℝ)) = (crossZ x y : ℝ) := by
  simp [gramForm,crossZ,matrix_cast]

theorem second_lower : (17:ℝ)/2 ≤ eigs HR ⟨1,by decide⟩ := by
  apply StoppingPlane.second_lower HR (by decide) uR vR 4 34 0
  · norm_num
  · norm_num
  · change normSq (fun c => (uZ c : ℝ)) = 4
    rw [norm_cast,norm_u]; norm_num
  · change normSq (fun c => (vZ c : ℝ)) = 4
    rw [norm_cast,norm_v]; norm_num
  · change innerForm (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 0
    rw [dot_cast,dot_uv]; norm_num
  · change energy HR (fun c => (uZ c : ℝ)) = 34
    rw [energy_cast,energy_u]; norm_num
  · change energy HR (fun c => (vZ c : ℝ)) = 34
    rw [energy_cast,energy_v]; norm_num
  · change gramForm HR (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 0
    rw [cross_cast,cross_uv]; norm_num
  · norm_num

theorem zhu_chugg_comparison (hgap : eigs HR ⟨1,by decide⟩ < 32) :
    let s := eigs HR ⟨1,by decide⟩
    54*(8-s)/(32-s) < 0 ∧
      108*(14-s)/(8*(32-s)) ≤ (297:ℝ)/94 ∧ (297:ℝ)/94 < 4 := by
  dsimp
  have hs := second_lower
  refine ⟨?_,?_,by norm_num⟩
  · apply div_neg_of_neg_of_pos
    · nlinarith
    · linarith
  · apply (div_le_iff₀ (by positivity : 0 < 8*(32-eigs HR ⟨1,by decide⟩))).mpr
    nlinarith
end Practical27.Spectral
