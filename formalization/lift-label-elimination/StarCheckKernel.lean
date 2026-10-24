import StructuredKernel
import StarKernelCertificate
import BinarySupportEquiv

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace StarCheckKernel
open CyclicRecurrence StructuredKernel
open scoped BigOperators
open Matrix

def base : Matrix (Fin 10) (Fin 10) F :=
  fun c v => if c ∈ PaschCubicTrade.baseA v then 1 else 0

theorem matrix_support_card (H : Fin 10 → Finset (Fin 10)) :
    Nat.card {x : Fin 10 → F // BaseCondition (PaschKernelCount.checkMatrix H) x}=
      ((Finset.univ : Finset (Fin 10)).powerset.filter
        (fun S => ∀ c, (GlobalCounting.selected H S c).card%2=0)).card := by
  change Nat.card {x : Fin 10 → F // ∀ c,
    ((PaschKernelCount.checkMatrix H) *ᵥ x) c=0}=_
  rw [Nat.card_congr (BinarySupportEquiv.equivalence H),Nat.card_eq_fintype_card]
  apply Fintype.card_of_subtype
  intro S
  simp only [Finset.mem_filter,Finset.mem_powerset,Finset.subset_univ,true_and]

theorem base_kernel_card :
    Nat.card {x : Fin 10 → F // BaseCondition base x}=8 := by
  have h := matrix_support_card PaschCubicTrade.baseA
  exact h.trans StarKernelCertificate.kernel_card

def dualH (v : Fin 10) : Finset (Fin 10) :=
  Finset.univ.filter (fun c => v ∈ PaschCubicTrade.baseA c)

theorem dual_matrix : PaschKernelCount.checkMatrix dualH=base.transpose := by
  ext c v
  simp [PaschKernelCount.checkMatrix,dualH,base,Matrix.transpose_apply]

theorem dual_support_card :
    ((Finset.univ : Finset (Fin 10)).powerset.filter
      (fun S => ∀ c, (GlobalCounting.selected dualH S c).card%2=0)).card=8 := by decide

theorem transposed_kernel_card :
    Nat.card {x : Fin 10 → F // BaseCondition base.transpose x}=8 := by
  rw [← dual_matrix]
  exact (matrix_support_card dualH).trans dual_support_card

variable (N : ℕ) [NeZero N]

def TwistedCondition (B : Matrix (Fin 10) (Fin 10) F)
    (z : Fin 10 → Fin 10 → Bool) (f : Fin 10 → ZMod N → F) : Prop :=
  (∀ v, ScalarCondition N (f v)) ∧
  ∀ t c, ∑ v, B c v*f v (t+if z c v then 7 else 0)=0

theorem untwist (h7 : 7 ∣ N) (B : Matrix (Fin 10) (Fin 10) F)
    (z : Fin 10 → Fin 10 → Bool) (f : Fin 10 → ZMod N → F) :
    TwistedCondition N B z f ↔ Condition N B f := by
  have hs (hf : ∀ v, ScalarCondition N (f v)) : ∀ t c v,
      f v (t+if z c v then 7 else 0)=f v t := by
    intro t c v
    cases h : z c v with
    | false => simp only [Bool.false_eq_true, ↓reduceIte, add_zero]
    | true => simpa only [↓reduceIte] using shift_seven N h7 (f v) (hf v) t
  constructor
  · rintro ⟨hf,he⟩
    refine ⟨hf,?_⟩
    intro t c
    simpa only [hs hf] using he t c
  · rintro ⟨hf,he⟩
    refine ⟨hf,?_⟩
    intro t c
    simpa only [hs hf] using he t c

theorem actual_equation_kernel_card (h7 : 7 ∣ N)
    (B : Matrix (Fin 10) (Fin 10) F)
    (hb : Nat.card {x : Fin 10 → F // BaseCondition B x}=8)
    (z : Fin 10 → Fin 10 → Bool) :
    Nat.card {f : Fin 10 → ZMod N → F // TwistedCondition N B z f}=512 := by
  rw [Nat.card_congr (Equiv.subtypeEquivRight (untwist N h7 B z)),
    StructuredKernel.kernel_card N h7 B, hb]
  decide

theorem star_kernel_512 (h7 : 7 ∣ N) (z : Fin 10 → Fin 10 → Bool) :
    Nat.card {f : Fin 10 → ZMod N → F // TwistedCondition N base z f}=512 :=
  actual_equation_kernel_card N h7 base base_kernel_card z

theorem dual_kernel_512 (h7 : 7 ∣ N) (z : Fin 10 → Fin 10 → Bool) :
    Nat.card {f : Fin 10 → ZMod N → F // TwistedCondition N base.transpose z f}=512 :=
  actual_equation_kernel_card N h7 base.transpose transposed_kernel_card z

#print axioms base_kernel_card
#print axioms transposed_kernel_card
#print axioms untwist
#print axioms star_kernel_512
#print axioms dual_kernel_512
end StarCheckKernel
