import SocketIncidence
set_option maxHeartbeats 0
open scoped BigOperators
namespace AbsorbingFourier
variable {G K P R : Type*} [Fintype G] [DecidableEq G] [CommRing G]
    [Field K] [CharZero K] [StarRing K]
    [Fintype P] [DecidableEq P] [Fintype R] [DecidableEq R]

def rootFrequencyEnergy (ψ : AddChar G K) (sockets : P → Finset (R × G))
    (p q : P) (d : G) : K :=
  if (p,0) ≠ (q,d) ∧
      (CyclicNormalization.incidence sockets (p,0) ∩
       CyclicNormalization.incidence sockets (q,d)).Nonempty then
    ∑ r : R, ∑ j : G,
      star (transformedAction ψ sockets
        (indicator (PairFormula.properCommon (CyclicNormalization.incidence sockets) (p,0) (q,d))) j r) *
      transformedAction ψ sockets
        (indicator (PairFormula.properCommon (CyclicNormalization.incidence sockets) (p,0) (q,d))) j r
  else 0

def normalizedFrequencyEnergy (ψ : AddChar G K) (sockets : P → Finset (R × G)) : K :=
  ∑ p : P, ∑ q : P, ∑ d : G, rootFrequencyEnergy ψ sockets p q d

theorem rootFrequencyEnergy_eq (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G))
    (p q : P) (d : G) :
    rootFrequencyEnergy ψ sockets p q d = (Fintype.card G : K) *
      (CyclicNormalization.energyTerm (CyclicNormalization.incidence sockets) (p,0) (q,d) : K) := by
  unfold rootFrequencyEnergy CyclicNormalization.energyTerm
  split_ifs
  · exact Fourier_energy ψ hinj hstar sockets _
  · simp

theorem normalizedFrequencyEnergy_eq (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G)) :
    normalizedFrequencyEnergy ψ sockets =
      (Fintype.card G : K) * (CyclicNormalization.normalizedEnergy sockets : K) := by
  unfold normalizedFrequencyEnergy CyclicNormalization.normalizedEnergy
  simp_rw [rootFrequencyEnergy_eq ψ hinj hstar, Nat.cast_sum, Finset.mul_sum]

/-- Exact corrected Fourier identity, with the full evaluated incidence matrix
and proper common-neighbor indicators. No floating-point or prime-lift premise. -/
theorem cyclic_Fourier_count_identity (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    4 * (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : K) +
      normalizedFrequencyEnergy ψ sockets =
      (Fintype.card G : K) * (CyclicNormalization.normalizedQuadratic sockets : K) := by
  rw [normalizedFrequencyEnergy_eq ψ hinj hstar]
  have h := congrArg (fun n : ℕ => (n : K))
    (CyclicNormalization.cyclic_corrected_count_identity sockets hd h4)
  simpa only [Nat.cast_add,Nat.cast_mul,Nat.cast_ofNat] using h

theorem cyclic_Fourier_count_formula (ψ : AddChar G K) (hinj : Function.Injective ψ)
    (hstar : ∀ a, star (ψ a) = ψ (-a)) (sockets : P → Finset (R × G))
    (hd : ∀ v, (CyclicNormalization.incidence sockets v).card = 3)
    (h4 : ∀ u v, u ≠ v →
      (CyclicNormalization.incidence sockets u ∩ CyclicNormalization.incidence sockets v).card ≤ 1) :
    (GlobalCounting.count42 (CyclicNormalization.incidence sockets) : K) =
      ((Fintype.card G : K) * (CyclicNormalization.normalizedQuadratic sockets : K) -
        normalizedFrequencyEnergy ψ sockets) / 4 := by
  apply (eq_div_iff (by norm_num : (4 : K) ≠ 0)).mpr
  apply (eq_sub_iff_add_eq).mpr
  simpa only [mul_comm] using cyclic_Fourier_count_identity ψ hinj hstar sockets hd h4

#print axioms cyclic_Fourier_count_identity
#print axioms cyclic_Fourier_count_formula
end AbsorbingFourier
