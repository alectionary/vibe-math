/-
Theorem `thm:aut` of the paper: the automorphism group of the anticommutation graph of the
C16 pools is exactly `⟨T⟩ × ⟨s⟩ ≅ C₁₆ × C₂` (32 elements).

Vertices are `Fin 1440`: `i < 720` is X pool vector `i`, `720 + j` is Z pool vector `j`. The
argument is colour refinement (1-dimensional Weisfeiler–Leman):
* refinement is equivariant, so every automorphism preserves every refined colouring
  (`col_iter_equiv`, a proof);
* three rounds from the constant colouring put vertex `0` in a class of 32 vertices, each the
  image of `0` under one of the 32 known automorphisms (`class_v0`, by `native_decide`);
* after vertex `0` is individualised, four rounds give a discrete colouring (`dM_id`, by
  `native_decide`), so an automorphism fixing vertex `0` is the identity.
The refinement theory is proved for an arbitrary finite graph (`aut_of_certificate`), so the
kernel never has to evaluate the concrete 1440-vertex arrays; only the two computed facts
mention them. The computational facts use `native_decide` and so also trust the Lean compiler.
-/
import Mathlib.Data.Finset.Sort
import Mathlib.Data.Fintype.Basic
import Pools

namespace C16Frames.Aut
open C16Frames.Pools

abbrev V := Fin 1440

/-! ### The graph -/

/-- Parity of the low 128 bits of `v`, by folding with shifts and xors. -/
def par128 (v : Nat) : Bool :=
  let v := (v ^^^ (v >>> 64)) &&& (2 ^ 64 - 1)
  let v := v ^^^ (v >>> 32); let v := v ^^^ (v >>> 16); let v := v ^^^ (v >>> 8)
  let v := v ^^^ (v >>> 4); let v := v ^^^ (v >>> 2); let v := v ^^^ (v >>> 1)
  v % 2 == 1

/-- Parity of `⟨a, b⟩` over the 128 coordinates. -/
def parity (a b : Nat) : Bool := par128 (a &&& b)

def adjNat (u v : Nat) : Bool :=
  if u < 720 ∧ 720 ≤ v then parity (xArr.getD u 0) (zArr.getD (v - 720) 0)
  else if v < 720 ∧ 720 ≤ u then parity (xArr.getD v 0) (zArr.getD (u - 720) 0)
  else false

/-- Adjacency of the bipartite anticommutation graph. -/
def adj (u v : V) : Bool := adjNat u v

/-- `adj` is the pairing matrix `G` of `Pools.lean` between the two sides, and there are no
edges inside a side. -/
theorem adj_spec : ∀ i j : Fin 720,
    adj (Fin.castAdd 720 i) (Fin.natAdd 720 j) = decide (PoolBridge.G i j = 1) := by
  native_decide

theorem adj_comm (u v : V) : adj u v = adj v u := by
  unfold adj adjNat
  split_ifs <;> first | (exfalso; omega) | rfl

theorem adj_same_X (i j : Fin 720) : adj (Fin.castAdd 720 i) (Fin.castAdd 720 j) = false := by
  unfold adj adjNat
  simp only [Fin.val_castAdd]
  split_ifs <;> first | (exfalso; omega) | rfl

theorem adj_same_Z (i j : Fin 720) : adj (Fin.natAdd 720 i) (Fin.natAdd 720 j) = false := by
  unfold adj adjNat
  simp only [Fin.val_natAdd]
  split_ifs <;> first | (exfalso; omega) | rfl

/-! ### The 32 known automorphisms: `T^k`, optionally after the side exchange `s` -/

/-- `gmap b k`: exchange sides if `b`, then rotate every orbit by `k`. -/
def gmap (b : Bool) (k : Fin 16) (u : V) : V :=
  let u' : V := if b then ⟨(u.1 + 720) % 1440, Nat.mod_lt _ (by norm_num)⟩ else u
  ⟨16 * (u'.1 / 16) + (u'.1 % 16 + k.1) % 16, by have := u'.isLt; omega⟩

def ginv (b : Bool) (k : Fin 16) (u : V) : V := gmap b ⟨(16 - k.1) % 16, by omega⟩ u

theorem gmap_ginv : ∀ b k u, gmap b k (ginv b k u) = u := by native_decide
theorem ginv_gmap : ∀ b k u, ginv b k (gmap b k u) = u := by native_decide

/-- The generators: the shift `T` and the side exchange `s`. -/
def rot1 (u : V) : V := gmap false 1 u
def swp (u : V) : V := gmap true 0 u

theorem rot1_aut : ∀ u w, adj (rot1 u) (rot1 w) = adj u w := by native_decide
theorem swp_aut : ∀ u w, adj (swp u) (swp w) = adj u w := by native_decide

/-- `gmap b k = T^k ∘ s^b`. -/
theorem gmap_eq : ∀ (b : Bool) (k : Fin 16) (u : V),
    gmap b k u = rot1^[k.1] (if b then swp u else u) := by native_decide

theorem iter_aut (f : V → V) (hf : ∀ u w, adj (f u) (f w) = adj u w) (n : ℕ) :
    ∀ u w, adj (f^[n] u) (f^[n] w) = adj u w := by
  induction n with
  | zero => intro u w; rfl
  | succ n ih => intro u w; rw [Function.iterate_succ_apply', Function.iterate_succ_apply', hf, ih]

/-- Each of the 32 maps is an automorphism. -/
theorem gmap_aut (b : Bool) (k : Fin 16) (u w : V) : adj (gmap b k u) (gmap b k w) = adj u w := by
  rw [gmap_eq, gmap_eq, iter_aut rot1 rot1_aut]
  cases b
  · rfl
  · exact swp_aut u w

/-- The 32 maps are distinct (already on vertex `0`). -/
theorem gmap_distinct : ∀ b k b' k', gmap b k 0 = gmap b' k' 0 → b = b' ∧ k = k' := by
  native_decide

/-! ### Colour refinement on an arbitrary finite graph, and its equivariance -/

section Refinement
variable {n : ℕ} (G : Fin n → Fin n → Bool)

/-- Colour of `v` in the colouring stored as an array. -/
def col (a : Array ℕ) (v : Fin n) : ℕ := a.getD v 0

/-- Signature: own colour and the sorted list of neighbour colours. -/
def sig (c : Fin n → ℕ) (v : Fin n) : ℕ × List ℕ :=
  (c v, ((Finset.univ.filter (fun w => G v w = true)).val.map c).sort (· ≤ ·))

/-- All signatures, computed once per round. -/
@[noinline] def sigsOf (a : Array ℕ) : Array (ℕ × List ℕ) := Array.ofFn (sig G (col a))

/-- First position of a signature. -/
def firstIdx (s : Array (ℕ × List ℕ)) (t : ℕ × List ℕ) : ℕ := s.toList.findIdx (· == t)

/-- One refinement round: the new colour of `v` is the first position with the same signature. -/
def refineA (a : Array ℕ) : Array ℕ :=
  let s := sigsOf G a
  s.map (firstIdx s)

def zeros (n : ℕ) : Array ℕ := Array.replicate n 0

/-- Individualise `v0`: give it colour `0` and shift every other colour up by one. -/
def indiv (a : Array ℕ) (v0 : Fin n) : Array ℕ :=
  Array.ofFn fun v : Fin n => if v = v0 then 0 else col a v + 1

theorem col_refineA (a : Array ℕ) (v : Fin n) :
    col (refineA G a) v = firstIdx (sigsOf G a) (sig G (col a) v) := by
  show ((sigsOf G a).map (firstIdx (sigsOf G a))).getD v.1 0 = _
  rw [Array.getD_eq_getD_getElem?, Array.getElem?_map]
  unfold sigsOf
  rw [Array.getElem?_ofFn, dif_pos v.2, Option.map_some, Option.getD_some]

theorem col_zeros (v : Fin n) : col (zeros n) v = 0 := by
  unfold col zeros
  rw [Array.getD_eq_getD_getElem?, Array.getElem?_replicate, if_pos v.2, Option.getD_some]

theorem col_indiv (a : Array ℕ) (v0 v : Fin n) :
    col (indiv a v0) v = if v = v0 then 0 else col a v + 1 := by
  conv_lhs => unfold col indiv
  rw [Array.getD_eq_getD_getElem?, Array.getElem?_ofFn, dif_pos v.2, Option.getD_some]

section equivariance
variable {G} (φ : Equiv.Perm (Fin n)) (hφ : ∀ u w, G (φ u) (φ w) = G u w)
include hφ

theorem sig_equiv (c : Fin n → ℕ) (hc : ∀ v, c (φ v) = c v) (v : Fin n) :
    sig G c (φ v) = sig G c v := by
  have hset : Finset.univ.filter (fun w => G (φ v) w = true) =
      (Finset.univ.filter (fun w => G v w = true)).map φ.toEmbedding := by
    ext w
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_map,
      Equiv.coe_toEmbedding]
    constructor
    · intro h
      exact ⟨φ.symm w, by rw [← hφ, Equiv.apply_symm_apply]; exact h, by simp⟩
    · rintro ⟨a, ha, rfl⟩
      rw [hφ]; exact ha
  have hc' : c ∘ φ = c := funext hc
  unfold sig
  simp only [hc, hset, Finset.map_val, Multiset.map_map, Equiv.coe_toEmbedding, hc']

theorem col_refineA_equiv (a : Array ℕ) (ha : ∀ v, col a (φ v) = col a v) (v : Fin n) :
    col (refineA G a) (φ v) = col (refineA G a) v := by
  rw [col_refineA, col_refineA, sig_equiv φ hφ _ ha]

theorem col_iter_equiv (k : ℕ) (a : Array ℕ) (ha : ∀ v, col a (φ v) = col a v) (v : Fin n) :
    col ((refineA G)^[k] a) (φ v) = col ((refineA G)^[k] a) v := by
  induction k generalizing v with
  | zero => exact ha v
  | succ k ih =>
    simp only [Function.iterate_succ_apply']
    exact col_refineA_equiv φ hφ _ ih v

end equivariance

/-- **Certificate theorem.** Suppose `g i` (with inverses `ginv i`) are automorphisms, `K` rounds
of refinement put `v0` in a class consisting of images of `v0` under the `g i`, and after
individualising `v0`, `M` more rounds give every vertex its own index as colour. Then every
automorphism is one of the `g i`. -/
theorem aut_of_certificate {ι : Type} (g ginv : ι → Fin n → Fin n)
    (hgi : ∀ i u, g i (ginv i u) = u) (hig : ∀ i u, ginv i (g i u) = u)
    (hgaut : ∀ i u w, G (g i u) (g i w) = G u w) (K M : ℕ) (v0 : Fin n)
    (hclass : ∀ u, col ((refineA G)^[K] (zeros n)) u = col ((refineA G)^[K] (zeros n)) v0 →
      ∃ i, g i v0 = u)
    (hdisc : ∀ u : Fin n, col ((refineA G)^[M] (indiv ((refineA G)^[K] (zeros n)) v0)) u = u.1)
    (φ : Equiv.Perm (Fin n)) (hφ : ∀ u w, G (φ u) (φ w) = G u w) :
    ∃ i, ∀ u, φ u = g i u := by
  have hK : ∀ ψ : Equiv.Perm (Fin n), (∀ u w, G (ψ u) (ψ w) = G u w) →
      ∀ v, col ((refineA G)^[K] (zeros n)) (ψ v) = col ((refineA G)^[K] (zeros n)) v :=
    fun ψ hψ v => col_iter_equiv ψ hψ K _ (fun v => by rw [col_zeros, col_zeros]) v
  obtain ⟨i, hi⟩ := hclass (φ v0) (hK φ hφ v0)
  -- `ψ = (g i)⁻¹ ∘ φ` is an automorphism fixing `v0`.
  let ψ : Equiv.Perm (Fin n) := φ.trans ⟨ginv i, g i, fun u => hgi i u, fun u => hig i u⟩
  have hginv : ∀ u w, G (ginv i u) (ginv i w) = G u w := fun u w => by
    rw [← hgaut i, hgi, hgi]
  have hψ : ∀ u w, G (ψ u) (ψ w) = G u w := fun u w => by
    simp only [ψ, Equiv.trans_apply, Equiv.coe_fn_mk, hginv, hφ]
  have hψ0 : ψ v0 = v0 := by simp only [ψ, Equiv.trans_apply, Equiv.coe_fn_mk, ← hi, hig]
  have hd0 : ∀ v, col (indiv ((refineA G)^[K] (zeros n)) v0) (ψ v) =
      col (indiv ((refineA G)^[K] (zeros n)) v0) v := fun v => by
    rw [col_indiv, col_indiv, hK ψ hψ v]
    have : ψ v = v0 ↔ v = v0 := ⟨fun h => ψ.injective (h.trans hψ0.symm), fun h => h ▸ hψ0⟩
    simp only [this]
  have hid : ∀ u, ψ u = u := fun u => by
    have := col_iter_equiv ψ hψ M _ hd0 u
    rw [hdisc, hdisc] at this
    exact Fin.ext this
  refine ⟨i, fun u => ?_⟩
  have h := hid u
  simp only [ψ, Equiv.trans_apply, Equiv.coe_fn_mk] at h
  calc φ u = g i (ginv i (φ u)) := (hgi i _).symm
    _ = g i u := by rw [h]

end Refinement

/-! ### The computation for the C16 graph -/

/-- Stable colouring of the whole graph (sides may be exchanged): 45 classes of size 32. -/
def cK : Array ℕ := (refineA adj)^[3] (zeros 1440)
/-- After individualising vertex `0`, four more rounds. -/
def dM : Array ℕ := (refineA adj)^[4] (indiv cK (0 : V))

/-- The colour class of vertex `0` is its orbit under the 32 known automorphisms. -/
theorem class_v0 : ∀ u : V, col cK u = col cK (0 : V) → ∃ i : Bool × Fin 16, gmap i.1 i.2 0 = u := by
  native_decide

/-- After individualising vertex `0`, refinement separates all 1440 vertices: each vertex's
colour is its own index (colours are first positions of signatures). -/
theorem dM_id : ∀ v : V, col dM v = v.1 := by native_decide

/-! ### The theorem -/

/-- **Theorem `thm:aut`.** Every automorphism of the anticommutation graph (a permutation of the
1440 vertices preserving adjacency, possibly exchanging the two sides) is one of the 32 maps
`gmap b k = T^k ∘ s^b`. Together with `gmap_aut` and `gmap_distinct`, the automorphism group has
exactly 32 elements. -/
theorem aut_classification (φ : Equiv.Perm V) (hφ : ∀ u w, adj (φ u) (φ w) = adj u w) :
    ∃ b : Bool, ∃ k : Fin 16, ∀ u, φ u = gmap b k u := by
  obtain ⟨i, hi⟩ := aut_of_certificate adj (fun i : Bool × Fin 16 => gmap i.1 i.2)
    (fun i => ginv i.1 i.2) (fun i u => gmap_ginv i.1 i.2 u) (fun i u => ginv_gmap i.1 i.2 u)
    (fun i u w => gmap_aut i.1 i.2 u w) 3 4 0 class_v0 dM_id φ hφ
  exact ⟨i.1, i.2, hi⟩

end C16Frames.Aut
