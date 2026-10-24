import PaschKernelCount

set_option maxHeartbeats 0
namespace BinarySupportEquiv
open scoped BigOperators
open Matrix
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def bitSupport (x : V → ZMod 2) : Finset V := Finset.univ.filter (fun v => x v=1)

theorem indicator_support (x : V → ZMod 2) :
    PaschKernelCount.supportIndicator (bitSupport x)=x := by
  funext v
  have hb : ∀ a : ZMod 2, a=0 ∨ a=1 := by decide
  rcases hb (x v) with h | h <;> simp [PaschKernelCount.supportIndicator,bitSupport,h]

theorem support_indicator (S : Finset V) :
    bitSupport (PaschKernelCount.supportIndicator S)=S := by
  ext v
  simp [bitSupport,PaschKernelCount.supportIndicator]

def equivalence (H : V → Finset C) :
    {x : V → ZMod 2 // ∀ c, ((PaschKernelCount.checkMatrix H) *ᵥ x) c=0} ≃
      {S : Finset V // ∀ c, (GlobalCounting.selected H S c).card%2=0} where
  toFun x := ⟨bitSupport x.val,by
    intro c
    have h := x.prop c
    rw [← indicator_support x.val,PaschKernelCount.matrix_indicator_eq_selected] at h
    exact Nat.mod_eq_zero_of_dvd ((ZMod.natCast_eq_zero_iff _ _).mp h)⟩
  invFun S := ⟨PaschKernelCount.supportIndicator S.val,by
    intro c
    rw [PaschKernelCount.matrix_indicator_eq_selected]
    exact (ZMod.natCast_eq_zero_iff _ _).mpr (Nat.dvd_of_mod_eq_zero (S.prop c))⟩
  left_inv x := Subtype.ext (indicator_support x.val)
  right_inv S := Subtype.ext (support_indicator S.val)

#print axioms equivalence
end BinarySupportEquiv
