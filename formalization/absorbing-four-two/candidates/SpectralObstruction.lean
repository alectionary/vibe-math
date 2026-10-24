import FullQuantumAFast
import FullQuantumBFast
import QuantumConstruction
set_option maxHeartbeats 0
namespace SmallQuantum

/-- For constant binary base labels, every source Fourier matrix is the
integer base Gram matrix plus the scalar |b(omega^j)|^2 on the diagonal.
Leaving that common scalar arbitrary makes equality hold for every frequency
and every coefficient semiring, including the source complex specialization. -/
def sourceSpectralData {K : Type*} [Semiring K]
    (base : Absorbing42Small.Incidence) (scalar : Fin 7 → K) :
    Fin 7 → Fin 12 → Fin 12 → K :=
  fun j c d => (Absorbing42Small.checkGram base c d : K) +
    if c = d then scalar j else 0

theorem source_spectral_data_equal {K : Type*} [Semiring K] (scalar : Fin 7 → K) :
    sourceSpectralData Absorbing42Small.baseA scalar =
      sourceSpectralData Absorbing42Small.baseB scalar := by
  funext j c d
  unfold sourceSpectralData
  rw [Absorbing42Small.same_check_gram]

theorem no_source_spectral_only_count {K : Type*} [Semiring K] (scalar : Fin 7 → K) :
    ¬ ∃ f : (Fin 7 → Fin 12 → Fin 12 → K) → ℕ,
      ∀ base : Absorbing42Small.Incidence,
        Absorbing42Small.CubicLinear base →
        f (sourceSpectralData base scalar) =
          GlobalCounting.count42 (quantumXColumns base) := by
  rintro ⟨f,hf⟩
  have ha := hf Absorbing42Small.baseA Absorbing42Small.baseA_cubic_linear
  have hb := hf Absorbing42Small.baseB Absorbing42Small.baseB_cubic_linear
  rw [source_spectral_data_equal,constructed_XA,full_count_Afast] at ha
  rw [constructed_XB,full_count_Bfast] at hb
  omega

#print axioms source_spectral_data_equal
#print axioms no_source_spectral_only_count
end SmallQuantum
