import SocketFourier
import Mathlib.Data.ZMod.Basic
set_option maxHeartbeats 0
namespace GBReflection
open scoped BigOperators
variable {G K : Type*} [Fintype G] [DecidableEq G] [CommRing G]
    [CommRing K] [IsDomain K] [StarRing K]

def eval (ψ : AddChar G K) (s : Finset G) (j : G) : K := ∑ e ∈ s, ψ (-(j*e))

theorem reflected_eval (ψ : AddChar G K) (hs : ∀ a, star (ψ a)=ψ (-a))
    (s : Finset G) (c j : G) :
    eval ψ (s.image (fun e => c-e)) j = ψ (-(j*c)) * star (eval ψ s j) := by
  unfold eval
  rw [Finset.sum_image]
  · simp only [star_sum,hs,neg_neg,Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro e he
    rw [← AddChar.map_add_eq_mul]
    congr 1
    ring
  · intro a _ b _ h
    have hh := congrArg (fun x => c-x) h
    simpa using hh

theorem phase_unit (ψ : AddChar G K) (hs : ∀ a, star (ψ a)=ψ (-a)) (t : G) :
    ψ t * star (ψ t) = 1 := by
  rw [hs,← AddChar.map_add_eq_mul]
  simp

theorem reflected_norm (ψ : AddChar G K) (hs : ∀ a, star (ψ a)=ψ (-a))
    (s : Finset G) (c j : G) :
    eval ψ (s.image (fun e => c-e)) j * star (eval ψ (s.image (fun e => c-e)) j) =
      eval ψ s j * star (eval ψ s j) := by
  rw [reflected_eval ψ hs]
  simp only [star_mul',star_star]
  calc
    _ = (ψ (-(j*c)) * star (ψ (-(j*c)))) * (eval ψ s j * star (eval ψ s j)) := by ring
    _ = _ := by rw [phase_unit ψ hs]; ring

def rightA : Finset (ZMod 24) := {0,22,14}
def rightB : Finset (ZMod 24) := {0,22,8}
theorem rightB_reflection : rightB = rightA.image (fun e => (22 : ZMod 24)-e) := by decide

def scalarM (ψ : AddChar (ZMod 24) K) (s : Finset (ZMod 24)) (j : ZMod 24) : K :=
  eval ψ {0,1,5} j * star (eval ψ {0,1,5} j) + eval ψ s j * star (eval ψ s j)

theorem all_scalar_M_equal (ψ : AddChar (ZMod 24) K)
    (hs : ∀ a, star (ψ a)=ψ (-a)) : scalarM ψ rightA = scalarM ψ rightB := by
  funext j
  unfold scalarM
  rw [rightB_reflection,reflected_norm ψ hs]

#print axioms reflected_eval
#print axioms all_scalar_M_equal
end GBReflection
