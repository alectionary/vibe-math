import PaschReindex40
import PaschHGPCount
import ComplexQuantumWitness

set_option maxHeartbeats 0
set_option backward.isDefEq.respectTransparency.types false
open scoped BigOperators
namespace PaschQuantumBridge
open PaschKernelCount AbsorbingFourier
abbrev G := ZMod 7
variable {U C : Type*} [Fintype U] [Fintype C] [DecidableEq U] [DecidableEq C]

def sockets (base : U → Finset C) :=
  ComplexQuantum.sourceSockets base ComplexQuantumWitness.rightOffsets

def variableEquiv : (Sum U C × G) ≃ Sum (U × Fin 7) (C × Fin 7) where
  toFun
    | (.inl u,a) => .inl (u,a)
    | (.inr c,a) => .inr (c,a)
  invFun
    | .inl (u,a) => (.inl u,a)
    | .inr (c,a) => (.inr c,a)
  left_inv := by rintro ⟨p,a⟩; cases p <;> rfl
  right_inv := by intro v; cases v <;> rfl

/-- HX=[A tensor I7 | I tensor B^T], B=1+x+x^3, with no square-base assumption. -/
theorem source_incidence_bridge (base : U → Finset C) (v : Sum U C × G) :
    HGPIncidence.columns base FanoBlock.columns (variableEquiv v) =
      CyclicNormalization.incidence (sockets base) v := by
  rcases v with ⟨p,a⟩
  cases p with
  | inl u =>
    change (base u) ×ˢ {a} = _
    change (base u) ×ˢ {a} = ((base u).image (fun c => (c, (0 : G)))).image
      (CyclicNormalization.shift C a)
    rw [Finset.image_image]
    ext ⟨r,t⟩
    simp only [Finset.mem_product, Finset.mem_singleton, Finset.mem_image,
      Function.comp_apply, CyclicNormalization.shift_apply, add_zero, Prod.mk.injEq]
    constructor
    · rintro ⟨hr,rfl⟩; exact ⟨r,hr,rfl,rfl⟩
    · rintro ⟨s,hs,hsr,hat⟩; exact ⟨hsr ▸ hs,hat.symm⟩
  | inr c =>
    change {c} ×ˢ FanoBlock.columns a = _
    rw [ComplexQuantumWitness.right_offsets_incidence]
    change {c} ×ˢ ComplexQuantumWitness.rightOffsets.image (fun e => a+e) =
      (ComplexQuantumWitness.rightOffsets.image (fun e => (c,e))).image (CyclicNormalization.shift C a)
    rw [Finset.image_image]
    ext ⟨r,t⟩
    simp only [Finset.mem_product, Finset.mem_singleton, Finset.mem_image,
      Function.comp_apply, CyclicNormalization.shift_apply, Prod.mk.injEq]
    constructor
    · rintro ⟨rfl,e,he,het⟩; exact ⟨e,he,rfl,het⟩
    · rintro ⟨e,he,hcr,het⟩; exact ⟨hcr.symm,e,he,het⟩

theorem socket_count40_eq (base : U → Finset C) :
    count40 (CyclicNormalization.incidence (sockets base)) =
      count40 (HGPIncidence.columns base FanoBlock.columns) := by
  apply PaschReindex40.count40_eq _ _ variableEquiv (Equiv.refl _)
  intro v
  have hi := Finset.image_id (s := CyclicNormalization.incidence (sockets base) v)
  exact (source_incidence_bridge base v).trans hi.symm

theorem socket_cubic (base : U → Finset C) (hd : ∀ u, (base u).card = 3) :
    ∀ v, (CyclicNormalization.incidence (sockets base) v).card = 3 := by
  intro v
  have h := congrArg Finset.card (source_incidence_bridge base v)
  exact h.symm.trans (HGPCounts.cubic base FanoBlock.columns hd FanoBlock.cubic (variableEquiv v))

theorem socket_linear (base : U → Finset C)
    (h4 : ∀ u v, u ≠ v → (base u ∩ base v).card ≤ 1) :
    ∀ u v, u ≠ v → (CyclicNormalization.incidence (sockets base) u ∩
      CyclicNormalization.incidence (sockets base) v).card ≤ 1 := by
  intro u v huv
  have he := congrArg Finset.card
    (congrArg₂ (fun (A B : Finset (C × G)) => A ∩ B)
      (source_incidence_bridge base u) (source_incidence_bridge base v))
  rw [← he]
  exact HGPCounts.linear base FanoBlock.columns h4 FanoBlock.linear _ _
    (fun h => huv (variableEquiv.injective h))

noncomputable def fullM (base : U → Finset C) (j : G) (c d : C) : ℂ :=
  ∑ p : Sum U C, evaluatedMatrix ZMod.stdAddChar (sockets base) j c p *
    star (evaluatedMatrix ZMod.stdAddChar (sockets base) j d p)

theorem fullM_eq (base : U → Finset C) (j : G) (c d : C) :
    fullM base j c d = HGPSpectral.M base (ComplexQuantumWitness.beta j) c d := by
  simp only [fullM,sockets,ComplexQuantum.source_evaluated_eq_D,
    ComplexQuantumWitness.right_eval_beta,HGPSpectral.M]

theorem fullM_eq_of_Gram (A B : U → Finset C)
    (hG : HGPGramObstruction.checkGram A = HGPGramObstruction.checkGram B) :
    fullM A = fullM B := by
  funext j c d
  simp only [fullM_eq,HGPSpectral.M_eq_gram]
  rw [hG]

#print axioms source_incidence_bridge
#print axioms socket_count40_eq
#print axioms fullM_eq_of_Gram
end PaschQuantumBridge
