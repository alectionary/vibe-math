import FamilyRing
set_option maxHeartbeats 0
namespace ParametricRing
open scoped Matrix CharTwo
variable {R : Type*} [CommRing R] [CharP R 2]

def base (x : ℤ → R) (a b : ℤ) : Matrix (Fin 3) (Fin 4) R :=
  !![x 0,x 0,x 0,x 0;
     x 0,x a,x b,x (3*a);
     x 0,x (2*a),x (2*b),x (b+2*a)]

def star (x : ℤ → R) (a b : ℤ) : Matrix (Fin 4) (Fin 3) R :=
  !![x 0,x 0,x 0;
     x 0,x (-a),x (-2*a);
     x 0,x (-b),x (-2*b);
     x 0,x (-3*a),x (-(b+2*a))]

def U (x : ℤ → R) (a b : ℤ) : Matrix (Fin 4) (Fin 4) R :=
  !![x 0,0,0,0;
     0,x (-2*a),0,0;
     0,0,x (-2*b),0;
     x (-2*a),x (-4*a)+x (-2*a),x (-(b+2*a)),x (-4*a)]

def V (x : ℤ → R) : Matrix (Fin 3) (Fin 3) R :=
  !![0,0,x 0;0,x 0,0;x 0,0,0]

/-- The two-parameter mixed cycle identity, before any cyclic quotient. -/
theorem mixed_cycle (x : ℤ → R) (h0 : x 0=1)
    (hm : ∀ c d, x c*x d=x (c+d)) (a b : ℤ) :
    U x a b * (base x a b).transpose = star x a b * V x := by
  have ht : (2 : R)=0 := CharP.ofNat_eq_zero R 2
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [U,V,base,star,Matrix.mul_apply,Fin.sum_univ_succ,mul_add,add_mul,hm,h0]
  all_goals ring_nf
  all_goals simp only [ht,mul_zero,add_zero,zero_add]

#print axioms mixed_cycle
end ParametricRing
