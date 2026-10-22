import Mathlib.Algebra.Module.Injective
import Mathlib.RingTheory.Nullstellensatz
import Mathlib.Topology.ContinuousMap.Bounded.ArzelaAscoli
import Mathlib.RingTheory.Ideal.MinimalPrime.Basic
import Mathlib.Analysis.InnerProductSpace.LaxMilgram

-- Check existing background declarations; this file supplies no new dissertation proofs.
#check Module.Baer.iff_injective
#print axioms Module.Baer.iff_injective
#check Ideal.sInf_minimalPrimes
#print axioms Ideal.sInf_minimalPrimes
#check MvPolynomial.vanishingIdeal_zeroLocus_eq_radical
#print axioms MvPolynomial.vanishingIdeal_zeroLocus_eq_radical
#check BoundedContinuousFunction.arzela_ascoli
#print axioms BoundedContinuousFunction.arzela_ascoli
#check IsCoercive.continuousLinearEquivOfBilin
#print axioms IsCoercive.continuousLinearEquivOfBilin
