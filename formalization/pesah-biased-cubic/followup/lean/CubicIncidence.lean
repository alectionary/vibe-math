import CyclicKernel
namespace Pesah
abbrev Site (n : Nat) := Fin (n+1) × Fin (n+1) × Fin (n+1)
def sx (v : Site n) : Site n := (next v.1, v.2.1, v.2.2)
def sy (v : Site n) : Site n := (v.1, next v.2.1, v.2.2)
def sz (v : Site n) : Site n := (v.1, v.2.1, next v.2.2)
abbrev Edges (n : Nat) := Fin 3 → Site n → Bool
def gradient (u : Site n → Bool) : Edges n := fun a v =>
  if a = 0 then u v ^^ u (sx v) else if a = 1 then u v ^^ u (sy v) else u v ^^ u (sz v)
def faceXY (e : Edges n) (v : Site n) := (e 0 v ^^ e 1 v) ^^ (e 0 (sy v) ^^ e 1 (sx v))
def faceXZ (e : Edges n) (v : Site n) := (e 0 v ^^ e 2 v) ^^ (e 0 (sz v) ^^ e 2 (sx v))
def faceYZ (e : Edges n) (v : Site n) := (e 1 v ^^ e 2 v) ^^ (e 1 (sz v) ^^ e 2 (sy v))
theorem square_xor (a b c d : Bool) : (((a ^^ b) ^^ (a ^^ c)) ^^ ((c ^^ d) ^^ (b ^^ d))) = false := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide
-- Exact curl-gradient cancellation, corresponding to the binary incidence product.
theorem cubic_incidence_commutes (u : Site n → Bool) (v : Site n) :
    faceXY (gradient u) v = false ∧ faceXZ (gradient u) v = false ∧ faceYZ (gradient u) v = false := by
  simp only [faceXY, faceXZ, faceYZ, gradient]
  simp only [show (1 : Fin 3) ≠ 0 by decide,
    show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide, ↓reduceIte]
  have xy : sx (sy v) = sy (sx v) := rfl
  have xz : sx (sz v) = sz (sx v) := rfl
  have yz : sy (sz v) = sz (sy v) := rfl
  rw [xy, xz, yz]
  exact ⟨square_xor _ _ _ _, square_xor _ _ _ _, square_xor _ _ _ _⟩
def firstAxis (e : Site n → Bool) : Edges n := fun a v => if a = 0 then e v else false

theorem first_axis_faces (e : Site n → Bool) (v : Site n) :
    faceXY (firstAxis e) v = (e v ^^ e (sy v)) ∧
    faceXZ (firstAxis e) v = (e v ^^ e (sz v)) ∧
    faceYZ (firstAxis e) v = false := by
  simp [faceXY, faceXZ, faceYZ, firstAxis]

theorem actual_cubic_plane_kernel (e : Site n → Bool) :
    (∀ v, faceXY (firstAxis e) v = false ∧ faceXZ (firstAxis e) v = false ∧ faceYZ (firstAxis e) v = false) ↔
    (∃ c : Fin (n+1) → Bool, ∀ v, e v = c v.1) := by
  have h := plane_kernel (fun x y z => e (x,y,z))
  constructor
  · intro hs
    have hd : ∀ x y z, planeSyndromeY (fun x y z => e (x,y,z)) x y z = false ∧ planeSyndromeZ (fun x y z => e (x,y,z)) x y z = false := by
      intro x y z
      have hh := hs (x,y,z)
      simpa [faceXY, faceXZ, firstAxis, sy, sz, planeSyndromeY, planeSyndromeZ, Bool.xor_comm] using And.intro hh.1 hh.2.1
    obtain ⟨c,hc⟩ := h.mp hd
    exact ⟨c, fun v => hc v.1 v.2.1 v.2.2⟩
  · rintro ⟨c,hc⟩ v
    simp [faceXY, faceXZ, faceYZ, firstAxis, hc, sy, sz]
def previous (i : Fin (n+1)) : Fin (n+1) :=
  ⟨(i.val+n) % (n+1), Nat.mod_lt _ (Nat.zero_lt_succ n)⟩
theorem previous_next (i : Fin (n+1)) : previous (next i) = i := by
  apply Fin.ext
  change (((i.val+1) % (n+1) + n) % (n+1)) = i.val
  by_cases h : i.val = n
  · simp [h, Nat.mod_eq_of_lt (Nat.lt_succ_self n)]
  · have hi : i.val+1 < n+1 := by omega
    rw [Nat.mod_eq_of_lt hi]
    have he : i.val+1+n = i.val+(n+1) := by omega
    rw [he]
    simp [Nat.mod_eq_of_lt i.isLt]
def bx (v : Site n) : Site n := (previous v.1, v.2.1, v.2.2)
def byAxis (v : Site n) : Site n := (v.1, previous v.2.1, v.2.2)
def bz (v : Site n) : Site n := (v.1, v.2.1, previous v.2.2)
def vertexCheck (e : Edges n) (v : Site n) : Bool :=
  ((e 0 v ^^ e 0 (bx v)) ^^ (e 1 v ^^ e 1 (byAxis v))) ^^ (e 2 v ^^ e 2 (bz v))

theorem first_axis_vertex (e : Site n → Bool) (v : Site n) :
    vertexCheck (firstAxis e) v = (e v ^^ e (bx v)) := by
  simp [vertexCheck, firstAxis]

theorem actual_cubic_chain_kernel (e : Site n → Bool) :
    (∀ v, vertexCheck (firstAxis e) v = false) ↔
    (∃ c : Fin (n+1) → Fin (n+1) → Bool, ∀ v, e v = c v.2.1 v.2.2) := by
  constructor
  · intro hs
    have hd : ∀ x y z, chainSyndrome (fun x y z => e (x,y,z)) x y z = false := by
      intro x y z
      have hh := hs (next x,y,z)
      simpa [first_axis_vertex, bx, previous_next, chainSyndrome] using hh
    obtain ⟨c,hc⟩ := (chain_kernel (fun x y z => e (x,y,z))).mp hd
    exact ⟨c, fun v => hc v.1 v.2.1 v.2.2⟩
  · rintro ⟨c,hc⟩ v
    simp [first_axis_vertex, hc, bx]

theorem xor_exchange (a b c d : Bool) : ((a ^^ b) ^^ (c ^^ d)) = ((a ^^ c) ^^ (b ^^ d)) := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem chain_syndrome_classification (e f : Site n → Bool) :
    (∀ v, vertexCheck (firstAxis e) v = vertexCheck (firstAxis f) v) ↔
    (∃ c : Fin (n+1) → Fin (n+1) → Bool, ∀ v, (e v ^^ f v) = c v.2.1 v.2.2) := by
  rw [← actual_cubic_chain_kernel]
  constructor
  · intro h v
    have hh := (xor_false_iff _ _).mpr (h v)
    simpa only [first_axis_vertex, xor_exchange] using hh
  · intro h v
    apply (xor_false_iff _ _).mp
    simpa only [first_axis_vertex, xor_exchange] using h v

-- The free chain bits are unique: no hidden extra ambiguity in this parameterization.
theorem chain_parameter_unique (e : Site n → Bool)
    (c d : Fin (n+1) → Fin (n+1) → Bool)
    (hc : ∀ v, e v = c v.2.1 v.2.2) (hd : ∀ v, e v = d v.2.1 v.2.2) : c = d := by
  funext y z
  exact (hc (0,y,z)).symm.trans (hd (0,y,z))
theorem plane_parameter_unique (e : Site n → Bool)
    (c d : Fin (n+1) → Bool)
    (hc : ∀ v, e v = c v.1) (hd : ∀ v, e v = d v.1) : c = d := by
  funext x
  exact (hc (x,0,0)).symm.trans (hd (x,0,0))

theorem vertex_gradient_kernel (u : Site n → Bool) :
    (∀ a v, gradient u a v = false) ↔ (∀ v, u v = u (0,0,0)) := by
  constructor
  · intro h v
    have hx := (cyclic_kernel_constant (fun x => u (x,v.2.1,v.2.2))).mp (by
      intro x
      simpa [difference, gradient, sx, Bool.xor_comm] using h 0 (x,v.2.1,v.2.2)) v.1
    have hy := (cyclic_kernel_constant (fun y => u (0,y,v.2.2))).mp (by
      intro y
      simpa [difference, gradient, sy, Bool.xor_comm] using h 1 (0,y,v.2.2)) v.2.1
    have hz := (cyclic_kernel_constant (fun z => u (0,0,z))).mp (by
      intro z
      simpa [difference, gradient, sz, Bool.xor_comm] using h 2 (0,0,z)) v.2.2
    exact hx.trans (hy.trans hz)
  · intro h a v
    simp [gradient, h]

#print axioms vertex_gradient_kernel
#print axioms chain_syndrome_classification
#print axioms actual_cubic_chain_kernel
#print axioms cubic_incidence_commutes
#print axioms actual_cubic_plane_kernel
end Pesah
