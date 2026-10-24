import SocketFourier
set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {G K P R : Type*} [Fintype G] [DecidableEq G] [CommRing G]
    [CommRing K] [IsDomain K] [StarRing K]
    [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

/-- Ordinary multiplication by the binary incidence matrix defined by sockets. -/
def incidenceAction (sockets : P → Finset (R × G)) (f : P → G → K) (r : R) (t : G) : K :=
  ∑ p : P, ∑ a : G, if (r,t) ∈ CyclicNormalization.incidence sockets (p,a) then f p a else 0

theorem socketAction_eq_incidenceAction (sockets : P → Finset (R × G))
    (f : P → G → K) (r : R) (t : G) :
    socketAction sockets f r t = incidenceAction sockets f r t := by
  classical
  unfold socketAction incidenceAction
  apply Finset.sum_congr rfl
  intro p hp
  rw [← Finset.sum_filter, ← Finset.sum_filter]
  apply Finset.sum_bij (fun s _ => t-s.2)
  · intro s hs
    obtain ⟨hs,hrow⟩ := Finset.mem_filter.mp hs
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _,?_⟩
    apply Finset.mem_image.mpr
    refine ⟨s,hs,?_⟩
    simp [CyclicNormalization.shift_apply,hrow]
  · intro s hs z hz heq
    have hsrow := (Finset.mem_filter.mp hs).2
    have hzrow := (Finset.mem_filter.mp hz).2
    apply Prod.ext
    · exact hsrow.trans hzrow.symm
    · have he := congrArg (fun a : G => t-a) heq
      simpa using he
  · intro a ha
    have hac := (Finset.mem_filter.mp ha).2
    obtain ⟨s,hs,hsa⟩ := Finset.mem_image.mp hac
    have hrow : s.1 = r := congrArg Prod.fst hsa
    have htime : a+s.2 = t := congrArg Prod.snd hsa
    refine ⟨s,Finset.mem_filter.mpr ⟨hs,hrow⟩,?_⟩
    rw [← htime]
    simp
  · intro s hs
    rfl

def indicator (W : Finset (P × G)) (p : P) (a : G) : K :=
  if (p,a) ∈ W then 1 else 0

theorem incidenceAction_indicator (sockets : P → Finset (R × G))
    (W : Finset (P × G)) (r : R) (t : G) :
    incidenceAction sockets (indicator W) r t =
      (PairEnergy.degreeInto (CyclicNormalization.incidence sockets) W (r,t) : K) := by
  classical
  let H := CyclicNormalization.incidence sockets
  have hf : Finset.univ.filter (fun v => v ∈ W ∧ (r,t) ∈ H v) =
      W.filter (fun v => (r,t) ∈ H v) := by
    ext v
    simp
  have hn : PairEnergy.degreeInto H W (r,t) =
      ∑ v : P × G, if v ∈ W ∧ (r,t) ∈ H v then (1 : ℕ) else 0 := by
    rw [← Finset.sum_filter,hf]
    simp [PairEnergy.degreeInto]
  rw [show CyclicNormalization.incidence sockets = H from rfl,hn]
  simp only [Nat.cast_sum,Nat.cast_ite,Nat.cast_one,Nat.cast_zero,Fintype.sum_prod_type]
  unfold incidenceAction indicator
  apply Finset.sum_congr rfl
  intro p hp
  apply Finset.sum_congr rfl
  intro a ha
  by_cases hw : (p,a) ∈ W <;> by_cases hc : (r,t) ∈ H (p,a) <;> simp [hw,hc,H]

theorem Fourier_energy (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G))
    (W : Finset (P × G)) :
    (∑ r : R, ∑ j : G,
      star (transformedAction ψ sockets (indicator W) j r) *
        transformedAction ψ sockets (indicator W) j r) =
      (Fintype.card G : K) * (PairEnergy.energy (CyclicNormalization.incidence sockets) W : K) := by
  rw [socket_parseval ψ hinj hstar]
  simp_rw [socketAction_eq_incidenceAction,incidenceAction_indicator]
  simp only [PairEnergy.energy,Nat.cast_sum,Nat.cast_pow,Fintype.sum_prod_type,star_natCast]
  simp_rw [pow_two]

#print axioms socketAction_eq_incidenceAction
#print axioms incidenceAction_indicator
#print axioms Fourier_energy
end AbsorbingFourier
