import HGPCounts
set_option maxHeartbeats 0
open scoped BigOperators
namespace HGPGramObstruction
open HGPIncidence HGPCounts
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

def checkGram {V R : Type*} [Fintype V] [DecidableEq R]
    (H : V → Finset R) (c d : R) : ℕ :=
  ∑ v : V, if c ∈ H v ∧ d ∈ H v then 1 else 0

theorem gram_product (H1 : U → Finset C) (H2 : E → Finset D) (c d : C) (a b : D) :
    checkGram (columns H1 H2) (c,a) (d,b) =
      (if a=b then checkGram H1 c d else 0) + (if c=d then checkGram H2 a b else 0) := by
  have hl (u : U) (t : D) :
      (if (c,a) ∈ columns H1 H2 (.inl (u,t)) ∧ (d,b) ∈ columns H1 H2 (.inl (u,t)) then (1 : ℕ) else 0) =
      if a=b then (if t=a then (if c ∈ H1 u ∧ d ∈ H1 u then 1 else 0) else 0) else 0 := by
    by_cases hab : a=b
    · subst b
      by_cases hta : t=a
      · subst t; simp [columns]
      · simp [columns,hta,Ne.symm hta]
    · by_cases hta : t=a
      · subst t; simp [columns,hab,Ne.symm hab]
      · simp [columns,hta,Ne.symm hta]
  have hr (r : C) (e : E) :
      (if (c,a) ∈ columns H1 H2 (.inr (r,e)) ∧ (d,b) ∈ columns H1 H2 (.inr (r,e)) then (1 : ℕ) else 0) =
      if c=d then (if r=c then (if a ∈ H2 e ∧ b ∈ H2 e then 1 else 0) else 0) else 0 := by
    by_cases hcd : c=d
    · subst d
      by_cases hrc : r=c
      · subst r; simp [columns]
      · simp [columns,hrc,Ne.symm hrc]
    · by_cases hrc : r=c
      · subst r; simp [columns,hcd,Ne.symm hcd]
      · simp [columns,hrc,Ne.symm hrc]
  simp only [checkGram,Fintype.sum_sum_type,Fintype.sum_prod_type]
  simp_rw [hl,hr]
  by_cases hab : a=b <;> by_cases hcd : c=d <;> simp [hab,hcd]

theorem base_gram_bridge (H : Absorbing42Small.Incidence) :
    checkGram H = Absorbing42Small.checkGram H := by
  funext c d
  unfold checkGram Absorbing42Small.checkGram
  rw [← Finset.sum_filter]
  simp

theorem same_full_gram : checkGram Concrete.XA = checkGram Concrete.XB := by
  funext x y
  rcases x with ⟨c,a⟩
  rcases y with ⟨d,b⟩
  unfold Concrete.XA Concrete.XB
  rw [gram_product,gram_product,base_gram_bridge,base_gram_bridge,
    Absorbing42Small.same_check_gram]

/-- Full 168-variable tensor-incidence obstruction, using a structural count
proof instead of a large finite kernel reduction. -/
theorem no_full_gram_only_count :
    ¬ ∃ f : ((Fin 12 × Fin 7) → (Fin 12 × Fin 7) → ℕ) → ℕ,
      ∀ H : Sum (Fin 12 × Fin 7) (Fin 12 × Fin 7) → Finset (Fin 12 × Fin 7),
        (∀ v, (H v).card=3) →
        (∀ u v, u≠v → (H u ∩ H v).card ≤ 1) →
        f (checkGram H) = GlobalCounting.count42 H := by
  rintro ⟨f,hf⟩
  have ha := hf Concrete.XA
    (cubic _ _ Absorbing42Small.baseA_cubic_linear.1 FanoBlock.cubic)
    (linear _ _ Absorbing42Small.baseA_cubic_linear.2.2 FanoBlock.linear)
  have hb := hf Concrete.XB
    (cubic _ _ Absorbing42Small.baseB_cubic_linear.1 FanoBlock.cubic)
    (linear _ _ Absorbing42Small.baseB_cubic_linear.2.2 FanoBlock.linear)
  rw [same_full_gram,Concrete.full_A_count] at ha
  rw [Concrete.full_B_count] at hb
  omega

def sourceSpectralData {K : Type*} [Semiring K]
    (base : Absorbing42Small.Incidence) (scalar : Fin 7 → K) :
    Fin 7 → Fin 12 → Fin 12 → K :=
  fun j c d => (Absorbing42Small.checkGram base c d : K) + if c=d then scalar j else 0

theorem same_source_spectral_data {K : Type*} [Semiring K] (scalar : Fin 7 → K) :
    sourceSpectralData Absorbing42Small.baseA scalar = sourceSpectralData Absorbing42Small.baseB scalar := by
  funext j c d
  unfold sourceSpectralData
  rw [Absorbing42Small.same_check_gram]

theorem no_source_spectral_only_count {K : Type*} [Semiring K] (scalar : Fin 7 → K) :
    ¬ ∃ f : (Fin 7 → Fin 12 → Fin 12 → K) → ℕ,
      ∀ base : Absorbing42Small.Incidence, Absorbing42Small.CubicLinear base →
        f (sourceSpectralData base scalar) = GlobalCounting.count42 (columns base FanoBlock.columns) := by
  rintro ⟨f,hf⟩
  have ha := hf Absorbing42Small.baseA Absorbing42Small.baseA_cubic_linear
  have hb := hf Absorbing42Small.baseB Absorbing42Small.baseB_cubic_linear
  rw [same_source_spectral_data] at ha
  change f (sourceSpectralData Absorbing42Small.baseB scalar) = GlobalCounting.count42 Concrete.XA at ha
  change f (sourceSpectralData Absorbing42Small.baseB scalar) = GlobalCounting.count42 Concrete.XB at hb
  rw [Concrete.full_A_count] at ha
  rw [Concrete.full_B_count] at hb
  omega

#print axioms same_full_gram
#print axioms no_full_gram_only_count
#print axioms same_source_spectral_data
#print axioms no_source_spectral_only_count
end HGPGramObstruction
