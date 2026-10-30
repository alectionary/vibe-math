import CubicPotential
namespace Pesah.Potential

def sumN (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n+1 => sumN f n + f n

def lineWeight (e : Nat → Bool) (L : Nat) := sumN (fun i => if e i then 1 else 0) L

theorem nonzero_parity_weight (f : Nat → Bool) (L : Nat) (h : xorPrefix f L = true) :
    1 ≤ lineWeight f L := by
  induction L with
  | zero => simp [xorPrefix] at h
  | succ L ih =>
    unfold lineWeight
    rw [sumN]
    cases hf : f L
    · have hh : xorPrefix f L = true := by simpa [xorPrefix,hf] using h
      have hw := ih hh
      simpa [lineWeight,hf] using hw
    · simp

theorem sumN_lower (f : Nat → Nat) (N k : Nat) (h : ∀ i, i<N → k ≤ f i) :
    N*k ≤ sumN f N := by
  induction N with
  | zero => simp [sumN]
  | succ N ih =>
    have ha := ih (fun i hi => h i (by omega))
    have hb := h N (by omega)
    simp only [sumN,Nat.succ_mul]
    omega

def xWeight (e : Field) (L : Nat) := sumN (fun y => sumN (fun z => lineWeight (fun x => e x y z) L) L) L
def yWeight (e : Field) (L : Nat) := sumN (fun x => sumN (fun z => lineWeight (fun y => e x y z) L) L) L
def zWeight (e : Field) (L : Nat) := sumN (fun x => sumN (fun y => lineWeight (fun z => e x y z) L) L) L
def edgeWeight (a : Cochain) (L : Nat) := xWeight a.x L + yWeight a.y L + zWeight a.z L

theorem parallel_loop_flux (L : Nat) (ex ey ez : Field)
    (hc : Closed ex ey ez) (hx : Periodic L ex) (hy : Periodic L ey) (hz : Periodic L ez) :
    (∀ y z, xorPrefix (fun i => ex i y z) L = xorPrefix (fun i => ex i 0 0) L) ∧
    (∀ x z, xorPrefix (fun i => ey x i z) L = xorPrefix (fun i => ey 0 i 0) L) ∧
    (∀ x y, xorPrefix (fun i => ez x y i) L = xorPrefix (fun i => ez 0 0 i) L) := by
  let u := potential ex ey ez
  have hu : Exact ex ey ez u := fun x y z => ⟨potential_x ex ey ez hc x y z,
    potential_y ex ey ez hc x y z, potential_z ex ey ez x y z⟩
  have hp := period_obstructions L ex ey ez u hu hx hy hz
  refine ⟨?_,?_,?_⟩
  · intro y z
    rw [prefix_derivative (fun i => u i y z) _ (fun i => (hu i y z).1)]
    have hh := (hp 0 y z).1
    simpa [u,potential,xorPrefix] using hh
  · intro x z
    rw [prefix_derivative (fun i => u x i z) _ (fun i => (hu x i z).2.1)]
    have hh := (hp x 0 z).2.1
    simpa [u,potential,xorPrefix] using hh
  · intro x y
    rw [prefix_derivative (fun i => u x y i) _ (fun i => (hu x y i).2.2)]
    have hh := (hp x y 0).2.2
    simpa [u,potential,xorPrefix] using hh

theorem grid_lines_lower (f : Nat → Nat → Nat) (L : Nat)
    (h : ∀ i j, 1 ≤ f i j) : L*L ≤ sumN (fun i => sumN (fun j => f i j) L) L := by
  apply sumN_lower
  intro i _
  have hh := sumN_lower (fun j => f i j) L 1 (fun j _ => h i j)
  simpa using hh

theorem nontrivial_closed_weight (L : Nat) (a : Cochain)
    (hc : Closed a.x a.y a.z) (hx : Periodic L a.x) (hy : Periodic L a.y) (hz : Periodic L a.z)
    (hn : Holonomy L a ≠ (false,false,false)) : L*L ≤ edgeWeight a L := by
  have hp := parallel_loop_flux L a.x a.y a.z hc hx hy hz
  have bits : xorPrefix (fun i => a.x i 0 0) L = true ∨
      xorPrefix (fun i => a.y 0 i 0) L = true ∨ xorPrefix (fun i => a.z 0 0 i) L = true := by
    unfold Holonomy at hn
    cases h1 : xorPrefix (fun i => a.x i 0 0) L <;>
      cases h2 : xorPrefix (fun i => a.y 0 i 0) L <;>
      cases h3 : xorPrefix (fun i => a.z 0 0 i) L <;> simp_all
  rcases bits with h | h | h
  · have hb : L*L ≤ xWeight a.x L := grid_lines_lower _ L (fun y z => nonzero_parity_weight _ L ((hp.1 y z).trans h))
    unfold edgeWeight; omega
  · have hb : L*L ≤ yWeight a.y L := grid_lines_lower _ L (fun x z => nonzero_parity_weight _ L ((hp.2.1 x z).trans h))
    unfold edgeWeight; omega
  · have hb : L*L ≤ zWeight a.z L := grid_lines_lower _ L (fun x y => nonzero_parity_weight _ L ((hp.2.2 x y).trans h))
    unfold edgeWeight; omega
theorem sumN_congr_below (f g : Nat → Nat) (N : Nat)
    (h : ∀ i, i<N → f i = g i) : sumN f N = sumN g N := by
  induction N with
  | zero => rfl
  | succ N ih => rw [sumN,sumN,ih (fun i hi => h i (by omega)),h N (by omega)]

theorem sumN_constant (k N : Nat) : sumN (fun _ => k) N = N*k := by
  induction N with
  | zero => simp [sumN]
  | succ N ih => simp [sumN,ih,Nat.succ_mul]

theorem singleton_weight (n : Nat) : sumN (fun i => if i=0 then 1 else 0) (n+1) = 1 := by
  induction n with
  | zero => simp [sumN]
  | succ n ih => rw [sumN,ih]; simp

theorem seam_line_weight (n : Nat) : lineWeight (seam (n+1) true) (n+1) = 1 := by
  unfold lineWeight
  calc
    sumN (fun i => if seam (n+1) true i then 1 else 0) (n+1) =
        sumN (fun i => if i=0 then 1 else 0) (n+1) := by
      apply sumN_congr_below
      intro i hi
      simp [seam,Nat.mod_eq_of_lt hi]
    _ = 1 := singleton_weight n

theorem prefix_false (N : Nat) : xorPrefix (fun _ => false) N = false := by
  induction N with
  | zero => rfl
  | succ N ih => simp [xorPrefix,ih]

def seamRepresentative (n : Nat) : Cochain :=
  ⟨(fun x _ _ => seam (n+1) true x), (fun _ _ _ => false), (fun _ _ _ => false)⟩

theorem seam_representative_weight (n : Nat) : edgeWeight (seamRepresentative n) (n+1) = (n+1)*(n+1) := by
  simp only [edgeWeight,xWeight,yWeight,zWeight,seamRepresentative,seam_line_weight]
  simp [lineWeight,sumN_constant]

theorem seam_representative_nontrivial (n : Nat) :
    Holonomy (n+1) (seamRepresentative n) = (true,false,false) := by
  simp [Holonomy,seamRepresentative,seam_holonomy,prefix_false]

-- Exact minimum weight of a nonzero cohomology class in this periodic
-- coordinate model. The separate source-code and quantum-parameter bridges
-- must not be omitted when interpreting this as the dissertation's Z distance.
theorem minimum_nontrivial_cocycle_weight (n : Nat) :
    (∀ a : Cochain, Closed a.x a.y a.z → Periodic (n+1) a.x →
      Periodic (n+1) a.y → Periodic (n+1) a.z →
      Holonomy (n+1) a ≠ (false,false,false) → (n+1)*(n+1) ≤ edgeWeight a (n+1)) ∧
    (∃ a : Cochain, Closed a.x a.y a.z ∧ Periodic (n+1) a.x ∧
      Periodic (n+1) a.y ∧ Periodic (n+1) a.z ∧ Holonomy (n+1) a ≠ (false,false,false) ∧
      edgeWeight a (n+1) = (n+1)*(n+1)) := by
  refine ⟨fun a hc hx hy hz hn => nontrivial_closed_weight (n+1) a hc hx hy hz hn,
    ⟨seamRepresentative n, ?_, ?_, ?_, ?_, ?_, seam_representative_weight n⟩⟩
  · simp [Closed,seamRepresentative]
  · intro x y z; simp [seamRepresentative,seam_period]
  · intro x y z; simp [seamRepresentative]
  · intro x y z; simp [seamRepresentative]
  · rw [seam_representative_nontrivial]; decide

#print axioms minimum_nontrivial_cocycle_weight
#print axioms nontrivial_closed_weight
end Pesah.Potential
