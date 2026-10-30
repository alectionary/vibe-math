import CubicIncidence
import CubicPotential
namespace Pesah

def coord (n t : Nat) : Fin (n+1) := ⟨t % (n+1), Nat.mod_lt _ (Nat.zero_lt_succ n)⟩
def siteOfNat (n x y z : Nat) : Site n := (coord n x,coord n y,coord n z)
theorem coord_period (n t : Nat) : coord n (t+(n+1)) = coord n t := by
  apply Fin.ext
  simp [coord]
theorem next_coord (n t : Nat) : next (coord n t) = coord n (t+1) := by
  apply Fin.ext
  simp [next,coord,Nat.add_mod]
theorem coord_val (i : Fin (n+1)) : coord n i.val = i := by
  apply Fin.ext
  simp [coord,Nat.mod_eq_of_lt i.isLt]

def liftEdges (e : Edges n) : Potential.Cochain :=
  ⟨(fun x y z => e 0 (siteOfNat n x y z)),
   (fun x y z => e 1 (siteOfNat n x y z)),
   (fun x y z => e 2 (siteOfNat n x y z))⟩
def liftVertices (u : Site n → Bool) : Potential.Field := fun x y z => u (siteOfNat n x y z)

theorem lifts_periodic (e : Edges n) : Potential.Periodic (n+1) (liftEdges e).x ∧
    Potential.Periodic (n+1) (liftEdges e).y ∧ Potential.Periodic (n+1) (liftEdges e).z := by
  simp [Potential.Periodic,liftEdges,siteOfNat,coord_period]
theorem vertices_periodic (u : Site n → Bool) : Potential.Periodic (n+1) (liftVertices u) := by
  simp [Potential.Periodic,liftVertices,siteOfNat,coord_period]

theorem square_closed_iff (a b c d : Bool) :
    (((a ^^ b) ^^ (c ^^ d)) = false) ↔ ((d ^^ b) = (c ^^ a)) := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem finite_closed_lifts (e : Edges n)
    (h : ∀ v, faceXY e v = false ∧ faceXZ e v = false ∧ faceYZ e v = false) :
    Potential.Closed (liftEdges e).x (liftEdges e).y (liftEdges e).z := by
  refine ⟨?_,?_,?_⟩
  · intro x y z
    have hh := (square_closed_iff _ _ _ _).mp ((h (siteOfNat n x y z)).1)
    simpa [liftEdges,siteOfNat,sx,sy,next_coord] using hh
  · intro x y z
    have hh := (square_closed_iff _ _ _ _).mp ((h (siteOfNat n x y z)).2.1)
    simpa [liftEdges,siteOfNat,sx,sz,next_coord] using hh
  · intro x y z
    have hh := (square_closed_iff _ _ _ _).mp ((h (siteOfNat n x y z)).2.2)
    simpa [liftEdges,siteOfNat,sy,sz,next_coord] using hh

theorem finite_gradient_lifts (u : Site n → Bool) :
    Potential.Exact (liftEdges (gradient u)).x (liftEdges (gradient u)).y
      (liftEdges (gradient u)).z (liftVertices u) := by
  intro x y z
  simp [liftEdges,liftVertices,gradient,siteOfNat,sx,sy,sz,next_coord,Bool.xor_comm]

theorem periodic_fin_next (f : Nat → Bool) (h : ∀ t, f (t+(n+1)) = f t) (i : Fin (n+1)) :
    f (next i).val = f (i.val+1) := by
  by_cases hi : i.val = n
  · have hh := h 0
    simpa [next,hi] using hh.symm
  · have ht : i.val+1 < n+1 := by omega
    simp [next,Nat.mod_eq_of_lt ht]

def restrictVertices (u : Potential.Field) : Site n → Bool := fun v => u v.1.val v.2.1.val v.2.2.val

theorem periodic_potential_restricts (e : Edges n) (u : Potential.Field)
    (hu : Potential.Exact (liftEdges e).x (liftEdges e).y (liftEdges e).z u)
    (hp : Potential.Periodic (n+1) u) : gradient (restrictVertices u) = e := by
  funext a v
  have hh := hu v.1.val v.2.1.val v.2.2.val
  have hx := periodic_fin_next (fun t => u t v.2.1.val v.2.2.val) (fun t => (hp t v.2.1.val v.2.2.val).1) v.1
  have hy := periodic_fin_next (fun t => u v.1.val t v.2.2.val) (fun t => (hp v.1.val t v.2.2.val).2.1) v.2.1
  have hz := periodic_fin_next (fun t => u v.1.val v.2.1.val t) (fun t => (hp v.1.val v.2.1.val t).2.2) v.2.2
  have he0 : (u (v.1.val+1) v.2.1.val v.2.2.val ^^ u v.1.val v.2.1.val v.2.2.val) = e 0 v := by
    simpa [liftEdges,siteOfNat,coord_val] using hh.1
  have he1 : (u v.1.val (v.2.1.val+1) v.2.2.val ^^ u v.1.val v.2.1.val v.2.2.val) = e 1 v := by
    simpa [liftEdges,siteOfNat,coord_val] using hh.2.1
  have he2 : (u v.1.val v.2.1.val (v.2.2.val+1) ^^ u v.1.val v.2.1.val v.2.2.val) = e 2 v := by
    simpa [liftEdges,siteOfNat,coord_val] using hh.2.2
  by_cases h0 : a=0
  · subst a; simpa [gradient,restrictVertices,sx,hx,Bool.xor_comm] using he0
  · by_cases h1 : a=1
    · subst a; simpa [gradient,restrictVertices,sy,hy,Bool.xor_comm] using he1
    · have h2 : a=2 := by apply Fin.ext; simp only [Fin.ext_iff] at h0 h1; omega
      subst a; simpa [gradient,restrictVertices,sz,hz,Bool.xor_comm] using he2

theorem finite_exact_iff_zero_holonomy (e : Edges n)
    (hc : ∀ v, faceXY e v = false ∧ faceXZ e v = false ∧ faceYZ e v = false) :
    (∃ u : Site n → Bool, gradient u = e) ↔ Potential.ZeroHolonomy (n+1) (liftEdges e).x (liftEdges e).y (liftEdges e).z := by
  have hper := lifts_periodic e
  have criterion := Potential.periodic_potential_iff (n+1) _ _ _ (finite_closed_lifts e hc) hper.1 hper.2.1 hper.2.2
  constructor
  · rintro ⟨u,he⟩
    apply criterion.mp
    refine ⟨liftVertices u, ?_, vertices_periodic u⟩
    simpa [← he] using finite_gradient_lifts u
  · intro hz
    obtain ⟨u,hu,hp⟩ := criterion.mpr hz
    exact ⟨restrictVertices u,periodic_potential_restricts e u hu hp⟩
#print axioms finite_exact_iff_zero_holonomy
end Pesah
