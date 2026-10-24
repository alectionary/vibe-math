import StarKernelCertificate
import PaschLiftCriterion

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace StarElimination
open FourColumnClassification PaschRootClassification PaschCubicTrade StarKernelCertificate

/-- A generic image-of-support bridge, so the finite base kernel certificate
applies to four distinct projected variables without fixing their order. -/
theorem projected_support (g : Fin 4 → Fin 10) (hg : Function.Injective g)
    (he : PaschClassification.EvenChecks (fun i => baseA (g i))) :
    Finset.univ.image g=({0,1,2,3} : Finset (Fin 10)) := by
  let S := Finset.univ.image g
  have hc : S.card=4 := by simp [S,Finset.card_image_of_injective _ hg]
  have hs : S∈kernelSupports := by
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_powerset.mpr (Finset.subset_univ _),?_⟩
    intro c
    have eqs : GlobalCounting.selected baseA S c = (support (fun i => baseA (g i)) c).image g := by
      ext v
      simp only [GlobalCounting.selected,S,Finset.mem_filter,Finset.mem_image,Finset.mem_univ,
        true_and,mem_support]
      constructor
      · rintro ⟨⟨i,rfl⟩,h⟩
        exact ⟨i,h,rfl⟩
      · rintro ⟨i,h,rfl⟩
        exact ⟨⟨i,rfl⟩,h⟩
    rw [eqs,Finset.card_image_of_injective _ hg]
    exact he c
  rw [complete_kernel] at hs
  simp only [listedKernel,Finset.mem_insert,Finset.mem_singleton] at hs
  rcases hs with h | h | h | h | h | h | h | h
  · rw [h] at hc; contradiction
  · exact h
  all_goals rw [h] at hc; norm_num at hc

variable {G : Type*} [DecidableEq G] [Fintype G] [AddCommGroup G]
def labels (a : G) (v c : Fin 10) : G :=
  if (v=0 ∧ c=0) ∨ (v=4 ∧ c=6) then a else 0

/-- Any four-variable binary dependency in this actual star cover forces the
changed edge label to vanish. It therefore eliminates every left-cover Pasch
for every nonzero label over any finite additive commutative group. -/
theorem even_forces_label_zero (a : G) (f : Fin 4 → Fin 10 × G)
    (hf : Function.Injective f)
    (he : PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns baseA (labels a) (f i))) : a=0 := by
  have proj := PaschLiftProjection.zero_syndrome_projects baseA (labels a)
    cubic_A linear_A f hf he
  let g : Fin 4 → Fin 10 := fun i => (f i).1
  let x : Fin 4 → G := fun i => (f i).2
  have himage := projected_support g proj.1 proj.2
  have hi0 : (0 : Fin 10)∈Finset.univ.image g := by rw [himage]; simp
  have hi1 : (1 : Fin 10)∈Finset.univ.image g := by rw [himage]; simp
  have hi2 : (2 : Fin 10)∈Finset.univ.image g := by rw [himage]; simp
  obtain ⟨i0,_,h0⟩ := Finset.mem_image.mp hi0
  obtain ⟨i1,_,h1⟩ := Finset.mem_image.mp hi1
  obtain ⟨i2,_,h2⟩ := Finset.mem_image.mp hi2
  have neq01 : i0≠i1 := by intro h; rw [h] at h0; omega
  have neq02 : i0≠i2 := by intro h; rw [h] at h0; omega
  have neq12 : i1≠i2 := by intro h; rw [h] at h1; omega
  have hd := fun i => PaschLiftProjection.cubic baseA (labels a) cubic_A (f i)
  have hlin : ∀ i j : Fin 4, i≠j →
      (PaschLiftProjection.columns baseA (labels a) (f i) ∩
      PaschLiftProjection.columns baseA (labels a) (f j)).card≤1 :=
    fun i j hij => PaschLiftProjection.linear baseA (labels a) linear_A _ _ (fun h => hij (hf h))
  have helem := PaschClassification.even_checks_elementary _ hd hlin he
  have hp := (elementary_pair_complete_iff _ hd hlin helem).mpr he
  let H : Fin 4 → Finset (Fin 10) := fun i => baseA (g i)
  let z : Fin 4 → Fin 10 → G := fun i c => labels a (g i) c
  have pc (i j : Fin 4) (hij : i≠j) :
      (PaschLiftProjection.columns H z (i,x i) ∩
      PaschLiftProjection.columns H z (j,x j)).Nonempty := by
    exact hp i j hij
  have c01 : H i0 ∩ H i1={(0 : Fin 10)} := by simp [H,h0,h1,baseA]
  have c02 : H i0 ∩ H i2={(1 : Fin 10)} := by simp [H,h0,h2,baseA]
  have c12 : H i1 ∩ H i2={(3 : Fin 10)} := by simp [H,h1,h2,baseA]
  have e01 := (PaschLiftCriterion.adjacent_iff H z x i0 i1 0 c01).mp (pc i0 i1 neq01)
  have e02 := (PaschLiftCriterion.adjacent_iff H z x i0 i2 1 c02).mp (pc i0 i2 neq02)
  have e12 := (PaschLiftCriterion.adjacent_iff H z x i1 i2 3 c12).mp (pc i1 i2 neq12)
  simp [z,labels,h0,h1] at e01
  simp [z,labels,h0,h2] at e02
  simp [z,labels,h1,h2] at e12
  calc
    a=x i1-x i0 := e01.symm
    _=(x i2-x i0)-(x i2-x i1) := by abel
    _=0 := by rw [e02,e12]; abel

theorem nonzero_eliminates (a : G) (ha : a≠0) (f : Fin 4 → Fin 10 × G)
    (hf : Function.Injective f) :
    ¬ PaschClassification.EvenChecks
      (fun i => PaschLiftProjection.columns baseA (labels a) (f i)) :=
  fun he => ha (even_forces_label_zero a f hf he)

#print axioms projected_support
#print axioms even_forces_label_zero
#print axioms nonzero_eliminates
end StarElimination
