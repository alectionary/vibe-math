import FiniteFourier
import CyclicNormalization

set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {G K P R : Type*} [Fintype G] [DecidableEq G] [CommRing G]
    [CommRing K] [IsDomain K] [StarRing K] [Fintype P] [Fintype R] [DecidableEq R]

theorem dft_sum {I : Type*} [Fintype I] (ψ : AddChar G K) (F : I → G → K) (j : G) :
    dft ψ (fun a => ∑ i : I, F i a) j = ∑ i : I, dft ψ (F i) j := by
  simp only [dft,Finset.mul_sum]
  rw [Finset.sum_comm]

theorem dft_finset_sum {I : Type*} (s : Finset I) (ψ : AddChar G K)
    (F : I → G → K) (j : G) :
    dft ψ (fun a => ∑ i ∈ s, F i a) j = ∑ i ∈ s, dft ψ (F i) j := by
  simp only [dft,Finset.mul_sum]
  rw [Finset.sum_comm]

theorem dft_ite (ψ : AddChar G K) (Q : Prop) [Decidable Q] (f : G → K) (j : G) :
    dft ψ (fun a => if Q then f a else 0) j = if Q then dft ψ f j else 0 := by
  by_cases hQ : Q <;> simp [hQ,dft]

theorem dft_translate (ψ : AddChar G K) (f : G → K) (e j : G) :
    dft ψ (fun a => f (a-e)) j = ψ (-(j*e)) * dft ψ f j := by
  classical
  unfold dft
  have h := Equiv.sum_comp (Equiv.addLeft e)
    (fun a : G => ψ (-(j*a)) * f (a-e))
  rw [← h]
  have hp (a : G) : ψ (-(j*(e+a))) * f (e+a-e) =
      ψ (-(j*e)) * (ψ (-(j*a)) * f a) := by
    have hg : e+a-e = a := by ring
    rw [hg,mul_add,neg_add,AddChar.map_add_eq_mul]
    ring
  change (∑ a : G, ψ (-(j*(e+a))) * f (e+a-e)) = _
  simp_rw [hp]
  rw [Finset.mul_sum]

def socketAction (sockets : P → Finset (R × G)) (f : P → G → K) (r : R) (t : G) : K :=
  ∑ p : P, ∑ s ∈ sockets p, if s.1 = r then f p (t-s.2) else 0

def evaluatedMatrix (ψ : AddChar G K) (sockets : P → Finset (R × G))
    (j : G) (r : R) (p : P) : K :=
  ∑ s ∈ sockets p, if s.1 = r then ψ (-(j*s.2)) else 0

def transformedAction (ψ : AddChar G K) (sockets : P → Finset (R × G))
    (f : P → G → K) (j : G) (r : R) : K :=
  ∑ p : P, evaluatedMatrix ψ sockets j r p * dft ψ (f p) j

/-- Finite convolution becomes multiplication by the full evaluated rectangular
check matrix, retaining socket incidence data. -/
theorem dft_socketAction (ψ : AddChar G K) (sockets : P → Finset (R × G))
    (f : P → G → K) (r : R) (j : G) :
    dft ψ (socketAction sockets f r) j = transformedAction ψ sockets f j r := by
  unfold socketAction
  rw [dft_sum]
  simp_rw [dft_finset_sum,dft_ite,dft_translate]
  unfold transformedAction evaluatedMatrix
  simp only [Finset.sum_mul,ite_mul,zero_mul]

/-- Unnormalized Parseval for the socket-defined check action. The source's
complex norm-squared expression is the specialization star(z)*z=|z|^2. -/
theorem socket_parseval (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G))
    (f : P → G → K) :
    (∑ r : R, ∑ j : G,
      star (transformedAction ψ sockets f j r) * transformedAction ψ sockets f j r) =
      (Fintype.card G : K) * ∑ r : R, ∑ t : G,
        star (socketAction sockets f r t) * socketAction sockets f r t := by
  simp_rw [← dft_socketAction,parseval ψ hinj hstar]
  rw [Finset.mul_sum]

#print axioms dft_socketAction
#print axioms socket_parseval
end AbsorbingFourier
