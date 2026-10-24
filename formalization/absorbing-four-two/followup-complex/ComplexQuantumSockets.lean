import ComplexDFT
import HGPSpectral
import GBReflection

set_option maxHeartbeats 0
open scoped BigOperators
namespace ComplexQuantum
open AbsorbingFourier
variable {U C G K : Type*} [DecidableEq C]
    [DecidableEq G] [CommRing G] [CommRing K]

/-- Polynomial sockets for [A | b(x)^T I], with the transpose sign already
included in the right-offset set. -/
def sourceSockets (base : U → Finset C) (right : Finset G) : Sum U C → Finset (C × G)
  | .inl u => (base u).image (fun c => (c,0))
  | .inr c => right.image (fun e => (c,e))

theorem source_evaluated_left (ψ : AddChar G K) (base : U → Finset C)
    (right : Finset G) (j : G) (r : C) (u : U) :
    evaluatedMatrix ψ (sourceSockets base right) j r (.inl u) =
      if r ∈ base u then 1 else 0 := by
  classical
  unfold evaluatedMatrix sourceSockets
  rw [Finset.sum_image]
  · simp
  · intro a _ b _ h
    exact congrArg Prod.fst h

theorem source_evaluated_right (ψ : AddChar G K) (base : U → Finset C)
    (right : Finset G) (j : G) (r c : C) :
    evaluatedMatrix ψ (sourceSockets base right) j r (.inr c) =
      if r = c then GBReflection.eval ψ right j else 0 := by
  unfold evaluatedMatrix sourceSockets
  rw [Finset.sum_image]
  · by_cases h : r=c
    · subst r
      simp [GBReflection.eval]
    · simp [h, Ne.symm h]
  · intro a _ b _ h
    exact congrArg Prod.snd h

/-- The source's rectangular evaluated matrix is obtained from the same
sockets that define its binary incidence matrix. -/
theorem source_evaluated_eq_D (ψ : AddChar G K) (base : U → Finset C)
    (right : Finset G) (j : G) :
    evaluatedMatrix ψ (sourceSockets base right) j =
      HGPSpectral.D base (GBReflection.eval ψ right j) := by
  funext r p
  cases p with
  | inl u => exact source_evaluated_left ψ base right j r u
  | inr c => exact source_evaluated_right ψ base right j r c

variable {N : ℕ} [NeZero N]

theorem standard_character_eq_power (a : ZMod N) :
    ZMod.stdAddChar a = standardRoot N ^ a.val := by
  have h := (ZMod.stdAddChar (N := N)).map_nsmul_eq_pow a.val (1 : ZMod N)
  simpa only [nsmul_eq_mul, mul_one, ZMod.natCast_zmod_val, standardRoot] using h

#print axioms source_evaluated_eq_D
#print axioms standard_character_eq_power
end ComplexQuantum
