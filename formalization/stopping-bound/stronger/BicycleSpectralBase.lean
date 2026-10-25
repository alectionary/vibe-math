import BicycleMatrices
import SpectralPlane
namespace Bicycle.SpectralBase
open Matrix StoppingSpectral StoppingPlane Finset
abbrev C := ZMod 39
abbrev V := Bool × C
def HInt : Matrix C V ℤ := Family.HX ℤ
def HR : Matrix C V ℝ := Family.HX ℝ
def uZ (c : C) : ℤ := if c.val < 13 then 1 else 0
def vZ (c : C) : ℤ := if 13 ≤ c.val ∧ c.val < 26 then 1 else 0
def normZ (x : C → ℤ) : ℤ := ∑ c, (x c)^2
def dotZ (x y : C → ℤ) : ℤ := ∑ c, x c*y c
def enZ (x : C → ℤ) : ℤ := ∑ v, (∑ c, HInt c v*x c)^2
def crossZ (x y : C → ℤ) : ℤ := ∑ v, (∑ c,HInt c v*x c)*(∑ c,HInt c v*y c)
set_option maxRecDepth 100000
set_option maxHeartbeats 0
lemma norm_u : normZ uZ = 13 := by decide +kernel
lemma norm_v : normZ vZ = 13 := by decide +kernel
lemma dot_uv : dotZ uZ vZ = 0 := by decide +kernel
lemma energy_u : enZ uZ = 332 := by decide +kernel
lemma energy_v : enZ vZ = 332 := by decide +kernel
lemma cross_uv : crossZ uZ vZ = 42 := by decide +kernel

def uR (c : C) : ℝ := uZ c
def vR (c : C) : ℝ := vZ c
lemma matrix_cast (c : C) (v : V) : HR c v = (HInt c v : ℝ) := by
  simp only [HR,HInt,Family.HX_entry]
  split <;> simp
lemma norm_cast (x : C → ℤ) : normSq (fun c => (x c : ℝ)) = (normZ x : ℝ) := by
  simp [normSq,normZ]
lemma dot_cast (x y : C → ℤ) : innerForm (fun c => (x c : ℝ)) (fun c => (y c : ℝ)) = (dotZ x y : ℝ) := by
  simp [innerForm,dotZ]
lemma energy_cast (x : C → ℤ) : energy HR (fun c => (x c : ℝ)) = (enZ x : ℝ) := by
  simp [energy,enZ,matrix_cast]
lemma cross_cast (x y : C → ℤ) : gramForm HR (fun c => (x c : ℝ)) (fun c => (y c : ℝ)) = (crossZ x y : ℝ) := by
  simp [gramForm,crossZ,matrix_cast]

theorem second_lower : (290:ℝ)/13 ≤ eigs HR ⟨1,by decide⟩ := by
  apply StoppingPlane.second_lower HR (by decide) uR vR 13 332 42
  · norm_num
  · norm_num
  · change normSq (fun c => (uZ c : ℝ)) = 13
    rw [norm_cast,norm_u]; norm_num
  · change normSq (fun c => (vZ c : ℝ)) = 13
    rw [norm_cast,norm_v]; norm_num
  · change innerForm (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 0
    rw [dot_cast,dot_uv]; norm_num
  · change energy HR (fun c => (uZ c : ℝ)) = 332
    rw [energy_cast,energy_u]; norm_num
  · change energy HR (fun c => (vZ c : ℝ)) = 332
    rw [energy_cast,energy_v]; norm_num
  · change gramForm HR (fun c => (uZ c : ℝ)) (fun c => (vZ c : ℝ)) = 42
    rw [cross_cast,cross_uv]; norm_num
  · norm_num

theorem zhu_chugg_negative (hgap : eigs HR ⟨1,by decide⟩ < 32) :
    let s := eigs HR ⟨1,by decide⟩
    78*(8-s)/(32-s) < 0 ∧ 156*(14-s)/(8*(32-s)) < 0 := by
  dsimp
  have hs := second_lower
  constructor
  · apply div_neg_of_neg_of_pos
    · nlinarith
    · linarith
  · apply div_neg_of_neg_of_pos
    · nlinarith
    · positivity
end Bicycle.SpectralBase
