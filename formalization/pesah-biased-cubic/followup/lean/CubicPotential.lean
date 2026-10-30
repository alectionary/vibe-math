import Std
namespace Pesah
namespace Potential

def xorPrefix (f : Nat → Bool) : Nat → Bool
  | 0 => false
  | n+1 => xorPrefix f n ^^ f n

theorem prefix_xor (f g : Nat → Bool) (n : Nat) :
    xorPrefix (fun i => f i ^^ g i) n = (xorPrefix f n ^^ xorPrefix g n) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [xorPrefix, ih]
    simp [xorPrefix, Bool.xor_left_comm, Bool.xor_comm]

theorem telescoping (q : Nat → Bool) (n : Nat) :
    xorPrefix (fun i => q (i+1) ^^ q i) n = (q n ^^ q 0) := by
  induction n with
  | zero => simp [xorPrefix]
  | succ n ih =>
    rw [xorPrefix, ih]
    simp [Bool.xor_left_comm, Bool.xor_comm]

theorem variation (f g q : Nat → Bool)
    (h : ∀ i, (f i ^^ g i) = (q (i+1) ^^ q i)) (n : Nat) :
    (xorPrefix f n ^^ xorPrefix g n) = (q n ^^ q 0) := by
  rw [← prefix_xor]
  have he : (fun i => f i ^^ g i) = (fun i => q (i+1) ^^ q i) := funext h
  rw [he, telescoping]

abbrev Field := Nat → Nat → Nat → Bool
-- Closed plaquette equations on the unwrapped nonnegative lattice.
def Closed (ex ey ez : Field) : Prop :=
  (∀ x y z, (ey (x+1) y z ^^ ey x y z) = (ex x (y+1) z ^^ ex x y z)) ∧
  (∀ x y z, (ez (x+1) y z ^^ ez x y z) = (ex x y (z+1) ^^ ex x y z)) ∧
  (∀ x y z, (ez x (y+1) z ^^ ez x y z) = (ey x y (z+1) ^^ ey x y z))

def potential (ex ey ez : Field) (x y z : Nat) : Bool :=
  (xorPrefix (fun i => ex i 0 0) x ^^ xorPrefix (fun i => ey x i 0) y) ^^ xorPrefix (fun i => ez x y i) z

theorem potential_z (ex ey ez : Field) (x y z : Nat) :
    (potential ex ey ez x y (z+1) ^^ potential ex ey ez x y z) = ez x y z := by
  simp [potential, xorPrefix, Bool.xor_left_comm, Bool.xor_comm]

theorem potential_y (ex ey ez : Field) (h : Closed ex ey ez) (x y z : Nat) :
    (potential ex ey ez x (y+1) z ^^ potential ex ey ez x y z) = ey x y z := by
  have hv := variation (fun i => ez x (y+1) i) (fun i => ez x y i) (fun i => ey x y i) (fun i => h.2.2 x y i) z
  simp only [potential, xorPrefix]
  have algebra (a b c d e : Bool) : (((a ^^ (b ^^ c)) ^^ d) ^^ ((a ^^ b) ^^ e)) = (c ^^ (d ^^ e)) := by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> decide
  rw [algebra, hv]
  simp [Bool.xor_left_comm, Bool.xor_comm]

theorem potential_x (ex ey ez : Field) (h : Closed ex ey ez) (x y z : Nat) :
    (potential ex ey ez (x+1) y z ^^ potential ex ey ez x y z) = ex x y z := by
  have hy := variation (fun i => ey (x+1) i 0) (fun i => ey x i 0) (fun i => ex x i 0) (fun i => h.1 x i 0) y
  have hz := variation (fun i => ez (x+1) y i) (fun i => ez x y i) (fun i => ex x y i) (fun i => h.2.1 x y i) z
  simp only [potential, xorPrefix]
  have algebra (a b c d e f : Bool) : ((((a ^^ b) ^^ c) ^^ d) ^^ ((a ^^ e) ^^ f)) = (b ^^ ((c ^^ e) ^^ (d ^^ f))) := by
    cases a <;> cases b <;> cases c <;> cases d <;> cases e <;> cases f <;> decide
  rw [algebra, hy, hz]
  simp [Bool.xor_left_comm, Bool.xor_comm]

-- Constructive exactness on the unwrapped lattice. Periodicity is NOT assumed
-- or concluded here: three torus holonomies are a separate obligation.
theorem closed_field_has_potential (ex ey ez : Field) (h : Closed ex ey ez) :
    ∃ u : Field, ∀ x y z,
      (u (x+1) y z ^^ u x y z) = ex x y z ∧
      (u x (y+1) z ^^ u x y z) = ey x y z ∧
      (u x y (z+1) ^^ u x y z) = ez x y z := by
  exact ⟨potential ex ey ez, fun x y z => ⟨potential_x ex ey ez h x y z,
    potential_y ex ey ez h x y z, potential_z ex ey ez x y z⟩⟩
def Exact (ex ey ez u : Field) : Prop := ∀ x y z,
  (u (x+1) y z ^^ u x y z) = ex x y z ∧
  (u x (y+1) z ^^ u x y z) = ey x y z ∧
  (u x y (z+1) ^^ u x y z) = ez x y z

theorem difference_step (a b c d : Bool) (h : (a ^^ b) = (c ^^ d)) :
    (a ^^ c) = (b ^^ d) := by
  cases a <;> cases b <;> cases c <;> cases d <;> simp_all

theorem same_gradient_constant (ex ey ez u v : Field)
    (hu : Exact ex ey ez u) (hv : Exact ex ey ez v) :
    ∀ x y z, (u x y z ^^ v x y z) = (u 0 0 0 ^^ v 0 0 0) := by
  have dx : ∀ x y z, (u (x+1) y z ^^ v (x+1) y z) = (u x y z ^^ v x y z) := by
    intro x y z
    exact difference_step _ _ _ _ ((hu x y z).1.trans (hv x y z).1.symm)
  have dy : ∀ x y z, (u x (y+1) z ^^ v x (y+1) z) = (u x y z ^^ v x y z) := by
    intro x y z
    exact difference_step _ _ _ _ ((hu x y z).2.1.trans (hv x y z).2.1.symm)
  have dz : ∀ x y z, (u x y (z+1) ^^ v x y (z+1)) = (u x y z ^^ v x y z) := by
    intro x y z
    exact difference_step _ _ _ _ ((hu x y z).2.2.trans (hv x y z).2.2.symm)
  have hz : ∀ z, (u 0 0 z ^^ v 0 0 z) = (u 0 0 0 ^^ v 0 0 0) := by
    intro z
    induction z with
    | zero => rfl
    | succ z ih => exact (dz 0 0 z).trans ih
  have hy : ∀ y z, (u 0 y z ^^ v 0 y z) = (u 0 0 0 ^^ v 0 0 0) := by
    intro y
    induction y with
    | zero => exact hz
    | succ y ih => intro z; exact (dy 0 y z).trans (ih z)
  intro x
  induction x with
  | zero => exact hy
  | succ x ih => intro y z; exact (dx x y z).trans (ih y z)

def Periodic (L : Nat) (f : Field) : Prop := ∀ x y z,
  f (x+L) y z = f x y z ∧ f x (y+L) z = f x y z ∧ f x y (z+L) = f x y z

theorem period_obstructions (L : Nat) (ex ey ez u : Field)
    (hu : Exact ex ey ez u) (hx : Periodic L ex) (hy : Periodic L ey) (hz : Periodic L ez) :
    ∀ x y z,
      (u (x+L) y z ^^ u x y z) = (u L 0 0 ^^ u 0 0 0) ∧
      (u x (y+L) z ^^ u x y z) = (u 0 L 0 ^^ u 0 0 0) ∧
      (u x y (z+L) ^^ u x y z) = (u 0 0 L ^^ u 0 0 0) := by
  have hux : Exact ex ey ez (fun x y z => u (x+L) y z) := by
    intro x y z
    have hh := hu (x+L) y z
    simpa [Nat.add_right_comm, (hx x y z).1, (hy x y z).1, (hz x y z).1] using hh
  have huy : Exact ex ey ez (fun x y z => u x (y+L) z) := by
    intro x y z
    have hh := hu x (y+L) z
    simpa [Nat.add_right_comm, (hx x y z).2.1, (hy x y z).2.1, (hz x y z).2.1] using hh
  have huz : Exact ex ey ez (fun x y z => u x y (z+L)) := by
    intro x y z
    have hh := hu x y (z+L)
    simpa [Nat.add_right_comm, (hx x y z).2.2, (hy x y z).2.2, (hz x y z).2.2] using hh
  intro x y z
  exact ⟨by simpa using same_gradient_constant ex ey ez _ u hux hu x y z,
    by simpa using same_gradient_constant ex ey ez _ u huy hu x y z,
    by simpa using same_gradient_constant ex ey ez _ u huz hu x y z⟩

theorem prefix_derivative (u e : Nat → Bool)
    (h : ∀ i, (u (i+1) ^^ u i) = e i) (L : Nat) :
    xorPrefix e L = (u L ^^ u 0) := by
  have he : e = (fun i => u (i+1) ^^ u i) := funext (fun i => (h i).symm)
  rw [he, telescoping]

theorem xor_zero_iff (a b : Bool) : ((a ^^ b) = false) ↔ a = b := by
  cases a <;> cases b <;> decide

def ZeroHolonomy (L : Nat) (ex ey ez : Field) : Prop :=
  xorPrefix (fun i => ex i 0 0) L = false ∧
  xorPrefix (fun i => ey 0 i 0) L = false ∧
  xorPrefix (fun i => ez 0 0 i) L = false

-- Exact zero-holonomy criterion for periodic binary cochains in this
-- coordinate model. Rank counts and minimum-weight consequences are separate.
theorem periodic_potential_iff (L : Nat) (ex ey ez : Field)
    (hc : Closed ex ey ez) (hx : Periodic L ex) (hy : Periodic L ey) (hz : Periodic L ez) :
    (∃ u : Field, Exact ex ey ez u ∧ Periodic L u) ↔ ZeroHolonomy L ex ey ez := by
  constructor
  · rintro ⟨u,hu,hp⟩
    have ax := prefix_derivative (fun i => u i 0 0) (fun i => ex i 0 0) (fun i => (hu i 0 0).1) L
    have ay := prefix_derivative (fun i => u 0 i 0) (fun i => ey 0 i 0) (fun i => (hu 0 i 0).2.1) L
    have az := prefix_derivative (fun i => u 0 0 i) (fun i => ez 0 0 i) (fun i => (hu 0 0 i).2.2) L
    have pp := hp 0 0 0
    simp only [Nat.zero_add] at pp
    exact ⟨by simpa [pp.1] using ax, by simpa [pp.2.1] using ay, by simpa [pp.2.2] using az⟩
  · intro hh
    let u := potential ex ey ez
    have hu : Exact ex ey ez u := fun x y z => ⟨potential_x ex ey ez hc x y z,
      potential_y ex ey ez hc x y z, potential_z ex ey ez x y z⟩
    refine ⟨u,hu,?_⟩
    intro x y z
    have hp := period_obstructions L ex ey ez u hu hx hy hz x y z
    have ax : (u L 0 0 ^^ u 0 0 0) = false := by simpa [u,potential,xorPrefix] using hh.1
    have ay : (u 0 L 0 ^^ u 0 0 0) = false := by simpa [u,potential,xorPrefix] using hh.2.1
    have az : (u 0 0 L ^^ u 0 0 0) = false := by simpa [u,potential,xorPrefix] using hh.2.2
    exact ⟨(xor_zero_iff _ _).mp (hp.1.trans ax), (xor_zero_iff _ _).mp (hp.2.1.trans ay),
      (xor_zero_iff _ _).mp (hp.2.2.trans az)⟩

theorem prefix_congr_below (f g : Nat → Bool) (N : Nat)
    (h : ∀ i, i < N → f i = g i) : xorPrefix f N = xorPrefix g N := by
  induction N with
  | zero => rfl
  | succ N ih =>
    rw [xorPrefix, xorPrefix, ih (fun i hi => h i (by omega)), h N (by omega)]

theorem prefix_singleton (b : Bool) (n : Nat) :
    xorPrefix (fun i => if i=0 then b else false) (n+1) = b := by
  induction n with
  | zero => simp [xorPrefix]
  | succ n ih => rw [xorPrefix, ih]; simp

def seam (L : Nat) (b : Bool) (x : Nat) : Bool := if x % L = 0 then b else false

theorem seam_period (L : Nat) (b : Bool) (x : Nat) : seam L b (x+L) = seam L b x := by
  simp [seam]

theorem seam_holonomy (n : Nat) (b : Bool) : xorPrefix (seam (n+1) b) (n+1) = b := by
  calc
    xorPrefix (seam (n+1) b) (n+1) = xorPrefix (fun i => if i=0 then b else false) (n+1) := by
      apply prefix_congr_below
      intro i hi
      simp [seam, Nat.mod_eq_of_lt hi]
    _ = b := prefix_singleton b n

-- A representative for each of the three independent cycle bits; its support
-- is a coordinate seam, not a constant field (which fails at even L).
theorem all_holonomies_realized (n : Nat) (a b c : Bool) :
    ∃ ex ey ez : Field,
      Closed ex ey ez ∧ Periodic (n+1) ex ∧ Periodic (n+1) ey ∧ Periodic (n+1) ez ∧
      xorPrefix (fun i => ex i 0 0) (n+1) = a ∧
      xorPrefix (fun i => ey 0 i 0) (n+1) = b ∧
      xorPrefix (fun i => ez 0 0 i) (n+1) = c := by
  refine ⟨(fun x _ _ => seam (n+1) a x), (fun _ y _ => seam (n+1) b y),
    (fun _ _ z => seam (n+1) c z), ?_, ?_, ?_, ?_, seam_holonomy n a, seam_holonomy n b, seam_holonomy n c⟩
  · simp [Closed]
  · intro x y z; simp [seam_period]
  · intro x y z; simp [seam_period]
  · intro x y z; simp [seam_period]

structure Cochain where
  x : Field
  y : Field
  z : Field

def plus (a b : Cochain) : Cochain :=
  ⟨(fun x y z => a.x x y z ^^ b.x x y z),
   (fun x y z => a.y x y z ^^ b.y x y z),
   (fun x y z => a.z x y z ^^ b.z x y z)⟩

def Holonomy (L : Nat) (a : Cochain) : Bool × Bool × Bool :=
  (xorPrefix (fun i => a.x i 0 0) L, xorPrefix (fun i => a.y 0 i 0) L,
   xorPrefix (fun i => a.z 0 0 i) L)

def Cohomologous (L : Nat) (a b : Cochain) : Prop :=
  ∃ u : Field, Exact (plus a b).x (plus a b).y (plus a b).z u ∧ Periodic L u

theorem xor_rearrange (a b c d : Bool) : ((a ^^ b) ^^ (c ^^ d)) = ((a ^^ c) ^^ (b ^^ d)) := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem plus_closed (a b : Cochain) (ha : Closed a.x a.y a.z) (hb : Closed b.x b.y b.z) :
    Closed (plus a b).x (plus a b).y (plus a b).z := by
  refine ⟨?_,?_,?_⟩
  · intro x y z
    simp only [plus, xor_rearrange, ha.1 x y z, hb.1 x y z]
  · intro x y z
    simp only [plus, xor_rearrange, ha.2.1 x y z, hb.2.1 x y z]
  · intro x y z
    simp only [plus, xor_rearrange, ha.2.2 x y z, hb.2.2 x y z]

theorem xor_periodic (L : Nat) (f g : Field) (hf : Periodic L f) (hg : Periodic L g) :
    Periodic L (fun x y z => f x y z ^^ g x y z) := by
  intro x y z
  simp only [(hf x y z).1, (hf x y z).2.1, (hf x y z).2.2,
    (hg x y z).1, (hg x y z).2.1, (hg x y z).2.2, and_self]

theorem cohomologous_iff_holonomy (L : Nat) (a b : Cochain)
    (ha : Closed a.x a.y a.z) (hb : Closed b.x b.y b.z)
    (ax : Periodic L a.x) (ay : Periodic L a.y) (az : Periodic L a.z)
    (bx : Periodic L b.x) (byh : Periodic L b.y) (bz : Periodic L b.z) :
    Cohomologous L a b ↔ Holonomy L a = Holonomy L b := by
  unfold Cohomologous
  rw [periodic_potential_iff L _ _ _ (plus_closed a b ha hb)
    (xor_periodic L _ _ ax bx) (xor_periodic L _ _ ay byh) (xor_periodic L _ _ az bz)]
  simp only [ZeroHolonomy, plus, prefix_xor, xor_zero_iff, Holonomy, Prod.mk.injEq]

-- Classification by exactly three Boolean cycle labels in the periodic
-- coordinate cochain model; no cardinal arithmetic or quantum distance claim.
theorem holonomy_classification (n : Nat) :
    (∀ a b : Cochain, Closed a.x a.y a.z → Closed b.x b.y b.z →
      Periodic (n+1) a.x → Periodic (n+1) a.y → Periodic (n+1) a.z →
      Periodic (n+1) b.x → Periodic (n+1) b.y → Periodic (n+1) b.z →
      (Cohomologous (n+1) a b ↔ Holonomy (n+1) a = Holonomy (n+1) b)) ∧
    (∀ label : Bool × Bool × Bool, ∃ a : Cochain,
      Closed a.x a.y a.z ∧ Periodic (n+1) a.x ∧ Periodic (n+1) a.y ∧ Periodic (n+1) a.z ∧
      Holonomy (n+1) a = label) := by
  refine ⟨fun a b ha hb ax ay az bx byh bz => cohomologous_iff_holonomy (n+1) a b ha hb ax ay az bx byh bz, ?_⟩
  intro label
  obtain ⟨ex,ey,ez,hc,hx,hy,hz,ha,hb,hd⟩ := all_holonomies_realized n label.1 label.2.1 label.2.2
  refine ⟨⟨ex,ey,ez⟩,hc,hx,hy,hz,?_⟩
  simp only [Holonomy,ha,hb,hd]

#print axioms holonomy_classification
#print axioms all_holonomies_realized
#print axioms periodic_potential_iff
#print axioms period_obstructions
#print axioms closed_field_has_potential
end Potential
end Pesah
