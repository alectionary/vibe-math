import HistogramPolynomials
import Mathlib.Tactic.NormNum

set_option maxHeartbeats 0
namespace PositiveLabelCounts
open HistogramPolynomials

theorem cube_bound (N : ℕ) (hN : 2≤N) : (8 : ℤ)≤(N : ℤ)^3 := by
  have h := Int.ofNat_le.mpr (Nat.pow_le_pow_left hN 3)
  norm_num only [Nat.cast_pow,Nat.cast_ofNat] at h
  exact h

theorem star_positive (N : ℕ) (hN : 2≤N) : (0 : ℤ)<(N : ℤ)^30-(N : ℤ)^27 := by
  have hn : (0 : ℤ)<N := by omega
  have hc := cube_bound N hN
  have hp : (0 : ℤ)<(N : ℤ)^27*((N : ℤ)^3-1) :=
    mul_pos (pow_pos hn _) (by omega)
  convert hp using 1 <;> ring

theorem triangle_gauge_positive (N : ℕ) (hN : 2≤N) : 0<polynomial (N : ℤ) 0 := by
  have hc := cube_bound N hN
  have h8 : (0 : ℤ)≤(N : ℤ)^8 := pow_nonneg (Int.natCast_nonneg N) _
  have h2 : (0 : ℤ)≤(N : ℤ)^2 := pow_nonneg (Int.natCast_nonneg N) _
  have ha : (0 : ℤ)≤(N : ℤ)^8*((N : ℤ)^3-5) := mul_nonneg h8 (by omega)
  have hb : (0 : ℤ)≤10*(N : ℤ)^2*((N : ℤ)^3-1) :=
    mul_nonneg (mul_nonneg (by decide) h2) (by omega)
  have he : polynomial (N : ℤ) 0=(N : ℤ)^8*((N : ℤ)^3-5)+
      10*(N : ℤ)^2*((N : ℤ)^3-1)+4 := by norm_num [polynomial] <;> ring
  rw [he]
  omega

theorem triangle_raw_positive (N : ℕ) (hN : 2≤N) :
    0<(N : ℤ)^19*polynomial (N : ℤ) 0 := by
  have hn : (0 : ℤ)<N := by omega
  exact mul_pos (pow_pos hn _) (triangle_gauge_positive N hN)

theorem trivial_fiber_boundaries :
    polynomial (1 : ℤ) 0=0 ∧ (1 : ℤ)^30-(1 : ℤ)^27=0 := by
  norm_num [polynomial]

#print axioms star_positive
#print axioms triangle_gauge_positive
#print axioms triangle_raw_positive
#print axioms trivial_fiber_boundaries
end PositiveLabelCounts
