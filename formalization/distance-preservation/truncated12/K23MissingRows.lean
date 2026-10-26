import K23Colors
import FiniteLabels
set_option maxHeartbeats 0
namespace TruncatedDistance

def thirdRow (a b : Fin 3) : Fin 3 := ⟨(6-a.val-b.val)%3,Nat.mod_lt _ (by decide)⟩

theorem thirdRow_distinct : ∀ a b : Fin 3,a≠b → thirdRow a b≠a ∧ thirdRow a b≠b := by decide +kernel

theorem thirdRow_injective : ∀ a b : Fin 3 → Fin 3,
    Function.Injective a → Function.Injective b → (∀ i,a i≠b i) →
      Function.Injective (fun i => thirdRow (a i) (b i)) := by decide +kernel

variable {L : ℕ} [NeZero L]
variable {e : Fin 3 → Fin 4 → ZMod L}
variable {u : Fin 4 → Fin 4 → ZMod L → ZMod 2}
variable {n : K23Numbering e u}

def missingRow (c : K23InternalChecks e u n) (b : Fin 3) : Fin 3 :=
  thirdRow (c.check 0 b).1.2 (c.check 1 b).1.2

theorem missingRow_injective (c : K23InternalChecks e u n) : Function.Injective (missingRow c) :=
  thirdRow_injective _ _ (c.center_colors 0) (c.center_colors 1) c.leaf_colors

noncomputable def missingRowEquiv (c : K23InternalChecks e u n) : Equiv.Perm (Fin 3) :=
  Equiv.ofBijective (missingRow c) ((Fintype.bijective_iff_injective_and_card _).mpr
    ⟨missingRow_injective c,rfl⟩)

noncomputable def leafByRow (c : K23InternalChecks e u n) (i : Fin 3) : Fin 3 :=
  (missingRowEquiv c).symm i

theorem leafByRow_missing (c : K23InternalChecks e u n) (i : Fin 3) :
    missingRow c (leafByRow c i)=i := (missingRowEquiv c).apply_symm_apply i

theorem leafByRow_colors (c : K23InternalChecks e u n) (i : Fin 3) :
    (c.check 0 (leafByRow c i)).1.2≠i ∧ (c.check 1 (leafByRow c i)).1.2≠i := by
  have h := thirdRow_distinct (c.check 0 (leafByRow c i)).1.2 (c.check 1 (leafByRow c i)).1.2
    (c.leaf_colors (leafByRow c i))
  change missingRow c (leafByRow c i)≠_ ∧ missingRow c (leafByRow c i)≠_ at h
  rw [leafByRow_missing] at h
  exact ⟨h.1.symm,h.2.symm⟩

theorem row_orientations (c : K23InternalChecks e u n) :
    (∀ i : Fin 3,(c.check 0 (leafByRow c i)).1.2.val=(i.val+1)%3 ∧
      (c.check 1 (leafByRow c i)).1.2.val=(i.val+2)%3) ∨
    (∀ i : Fin 3,(c.check 0 (leafByRow c i)).1.2.val=(i.val+2)%3 ∧
      (c.check 1 (leafByRow c i)).1.2.val=(i.val+1)%3) := by
  apply two_row_color_orientations
  · exact (c.center_colors 0).comp (missingRowEquiv c).symm.injective
  · exact (c.center_colors 1).comp (missingRowEquiv c).symm.injective
  · intro i
    exact ⟨(leafByRow_colors c i).1,(leafByRow_colors c i).2,c.leaf_colors _⟩

#print axioms leafByRow_colors
#print axioms row_orientations
end TruncatedDistance
