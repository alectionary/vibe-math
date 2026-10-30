import Std

/- Exact restricted-incidence kernels on periodic chains and planes.
   These definitions are difference checks, not a theorem about an arbitrary graph. -/
namespace Pesah

def next (i : Fin (n + 1)) : Fin (n + 1) :=
  ⟨(i.val + 1) % (n + 1), Nat.mod_lt _ (Nat.zero_lt_succ n)⟩

theorem next_castSucc (i : Fin n) : next i.castSucc = i.succ := by
  apply Fin.ext
  simp [next, Nat.mod_eq_of_lt (show i.val + 1 < n + 1 from by omega)]

def difference (e : Fin (n + 1) → Bool) (i : Fin (n + 1)) : Bool := e (next i) ^^ e i

theorem xor_false_iff (a b : Bool) : ((a ^^ b) = false) ↔ a = b := by
  cases a <;> cases b <;> decide

theorem cyclic_kernel_constant (e : Fin (n + 1) → Bool) :
    (∀ i, difference e i = false) ↔ (∀ i, e i = e 0) := by
  constructor
  · intro h i
    induction i using Fin.induction with
    | zero => rfl
    | succ i ih =>
      have hi := (xor_false_iff _ _).mp (h i.castSucc)
      change e (next i.castSucc) = e i.castSucc at hi
      rw [next_castSucc] at hi
      exact hi.trans ih
  · intro h i
    unfold difference
    rw [h (next i), h i]
    exact Bool.xor_self _

-- A field on LxLxL restricted to first-axis edges has L² independent chains.
def chainSyndrome (e : Fin (n + 1) → Fin (n + 1) → Fin (n + 1) → Bool)
    (x y z : Fin (n + 1)) : Bool := e (next x) y z ^^ e x y z

theorem chain_kernel (e : Fin (n + 1) → Fin (n + 1) → Fin (n + 1) → Bool) :
    (∀ x y z, chainSyndrome e x y z = false) ↔
    (∃ c : Fin (n + 1) → Fin (n + 1) → Bool, ∀ x y z, e x y z = c y z) := by
  constructor
  · intro h
    refine ⟨fun y z => e 0 y z, ?_⟩
    intro x y z
    exact (cyclic_kernel_constant (fun t => e t y z)).mp (fun t => h t y z) x
  · rintro ⟨c, hc⟩ x y z
    simp [chainSyndrome, hc]

-- Restricted first-axis face checks compare adjacent parallel edges in y and z.
def planeSyndromeY (e : Fin (n + 1) → Fin (n + 1) → Fin (n + 1) → Bool)
    (x y z : Fin (n + 1)) : Bool := e x (next y) z ^^ e x y z
def planeSyndromeZ (e : Fin (n + 1) → Fin (n + 1) → Fin (n + 1) → Bool)
    (x y z : Fin (n + 1)) : Bool := e x y (next z) ^^ e x y z

theorem plane_kernel (e : Fin (n + 1) → Fin (n + 1) → Fin (n + 1) → Bool) :
    (∀ x y z, planeSyndromeY e x y z = false ∧ planeSyndromeZ e x y z = false) ↔
    (∃ c : Fin (n + 1) → Bool, ∀ x y z, e x y z = c x) := by
  constructor
  · intro h
    refine ⟨fun x => e x 0 0, ?_⟩
    intro x y z
    have hy := (cyclic_kernel_constant (fun t => e x t z)).mp (fun t => (h x t z).1) y
    have hz := (cyclic_kernel_constant (fun t => e x 0 t)).mp (fun t => (h x 0 t).2) z
    exact hy.trans hz
  · rintro ⟨c, hc⟩ x y z
    simp [planeSyndromeY, planeSyndromeZ, hc]

-- Every triangle has exactly one first-axis edge in the source's restricted
-- model. This direct-observation model is injective; the incidence bridge
-- must establish that the actual triangles supply each such coordinate.
def observedTriangle (e : α → Bool) (i : α) : Bool := e i
theorem singleton_triangle_injective (e f : α → Bool)
    (h : ∀ i, observedTriangle e i = observedTriangle f i) : e = f := by
  funext i
  exact h i

#print axioms chain_kernel
#print axioms plane_kernel
#print axioms singleton_triangle_injective
end Pesah
