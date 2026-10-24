import ComplexQuantumSockets
import ComplexRootFormula
import QuantumReindex

set_option maxHeartbeats 0
set_option maxRecDepth 100000
set_option backward.isDefEq.respectTransparency.types false
open scoped BigOperators
namespace ComplexQuantumWitness
open AbsorbingFourier ComplexQuantum
abbrev G := ZMod 7
abbrev P := Sum (Fin 12) (Fin 12)
abbrev R := Fin 12

/-- Transposed sockets of b(x)=1+x+x³. -/
def rightOffsets : Finset G := {0,-1,-3}
def sockets (base : Absorbing42Small.Incidence) := sourceSockets base rightOffsets

def variableEquiv : (P × G) ≃ Sum (Fin 12 × Fin 7) (Fin 12 × Fin 7) where
  toFun
    | (.inl u,a) => .inl (u,a)
    | (.inr c,a) => .inr (c,a)
  invFun
    | .inl (u,a) => (.inl u,a)
    | .inr (c,a) => (.inr c,a)
  left_inv := by rintro ⟨p,a⟩; cases p <;> rfl
  right_inv := by intro v; cases v <;> rfl

theorem right_offsets_incidence (a : G) :
    FanoBlock.columns a = rightOffsets.image (fun e => a+e) := by
  have h : ∀ a : G, FanoBlock.columns a = rightOffsets.image (fun e => a+e) := by decide
  exact h a

/-- Actual incidence, with the same transpose convention as the source's
168-column matrix; the variable map only distributes a product over a sum. -/
theorem source_incidence_bridge (base : Absorbing42Small.Incidence) (v : P × G) :
    HGPIncidence.columns base FanoBlock.columns (variableEquiv v) =
      CyclicNormalization.incidence (sockets base) v := by
  rcases v with ⟨p,a⟩
  cases p with
  | inl u =>
    change (base u) ×ˢ {a} = _
    change (base u) ×ˢ {a} = ((base u).image (fun c => (c, (0 : G)))).image
      (CyclicNormalization.shift R a)
    rw [Finset.image_image]
    ext ⟨r,t⟩
    simp only [Finset.mem_product, Finset.mem_singleton, Finset.mem_image,
      Function.comp_apply, CyclicNormalization.shift_apply, add_zero, Prod.mk.injEq]
    constructor
    · rintro ⟨hr,rfl⟩
      exact ⟨r,hr,rfl,rfl⟩
    · rintro ⟨s,hs,hsr,hat⟩
      exact ⟨hsr ▸ hs,hat.symm⟩
  | inr c =>
    change {c} ×ˢ FanoBlock.columns a = _
    rw [right_offsets_incidence]
    change {c} ×ˢ rightOffsets.image (fun e => a+e) =
      (rightOffsets.image (fun e => (c,e))).image (CyclicNormalization.shift R a)
    rw [Finset.image_image]
    ext ⟨r,t⟩
    simp only [Finset.mem_product, Finset.mem_singleton, Finset.mem_image,
      Function.comp_apply, CyclicNormalization.shift_apply, Prod.mk.injEq]
    constructor
    · rintro ⟨rfl,e,he,het⟩
      exact ⟨e,he,rfl,het⟩
    · rintro ⟨e,he,hcr,het⟩
      exact ⟨hcr.symm,e,he,het⟩

theorem socket_count_eq (base : Absorbing42Small.Incidence) :
    GlobalCounting.count42 (CyclicNormalization.incidence (sockets base)) =
      GlobalCounting.count42 (HGPIncidence.columns base FanoBlock.columns) := by
  apply IncidenceEquivalence.count42_eq _ _ variableEquiv (Equiv.refl _)
  intro v
  have hi := Finset.image_id (s := CyclicNormalization.incidence (sockets base) v)
  exact (source_incidence_bridge base v).trans hi.symm

theorem count_A : GlobalCounting.count42
    (CyclicNormalization.incidence (sockets Absorbing42Small.baseA)) = 49 := by
  rw [socket_count_eq]
  exact HGPCounts.Concrete.full_A_count

theorem count_B : GlobalCounting.count42
    (CyclicNormalization.incidence (sockets Absorbing42Small.baseB)) = 35 := by
  rw [socket_count_eq]
  exact HGPCounts.Concrete.full_B_count

theorem literal_A_bridge (v : P × G) :
    SmallQuantum.quantumXColumns Absorbing42Small.baseA
        (QuantumReindex.variableEquiv (variableEquiv v)) =
      (CyclicNormalization.incidence (sockets Absorbing42Small.baseA) v).image
        QuantumReindex.checkEquiv := by
  rw [QuantumReindex.source_A_bridge, ← source_incidence_bridge]
  rfl

theorem literal_B_bridge (v : P × G) :
    SmallQuantum.quantumXColumns Absorbing42Small.baseB
        (QuantumReindex.variableEquiv (variableEquiv v)) =
      (CyclicNormalization.incidence (sockets Absorbing42Small.baseB) v).image
        QuantumReindex.checkEquiv := by
  rw [QuantumReindex.source_B_bridge, ← source_incidence_bridge]
  rfl

noncomputable def beta (j : G) : ℂ :=
  1 + ZMod.stdAddChar j + ZMod.stdAddChar (3*j)

theorem right_eval_beta (j : G) :
    GBReflection.eval ZMod.stdAddChar rightOffsets j = beta j := by
  unfold GBReflection.eval rightOffsets
  rw [Finset.sum_insert (by decide), Finset.sum_insert (by decide), Finset.sum_singleton]
  simp only [mul_zero, neg_zero, AddChar.map_zero_eq_one, mul_neg, mul_one, neg_neg]
  rw [mul_comm j 3]
  simp only [beta, add_assoc]

/-- The right block is b(omega^j), with a positive exponent because the
binary right block was transposed. This checks the potential sign ambiguity. -/
theorem beta_eq_polynomial (j : G) :
    beta j = 1 + standardRoot 7 ^ j.val + standardRoot 7 ^ (3*j.val) := by
  have h3 : ZMod.stdAddChar (3*j) = (ZMod.stdAddChar j)^3 := by
    simpa only [nsmul_eq_mul, Nat.cast_ofNat] using (ZMod.stdAddChar (N := 7)).map_nsmul_eq_pow 3 j
  simp only [beta, h3, standard_character_eq_power, ← pow_mul, Nat.mul_comm]

noncomputable def fullM (base : Absorbing42Small.Incidence) (j : G) (c d : R) : ℂ :=
  ∑ p : P, evaluatedMatrix ZMod.stdAddChar (sockets base) j c p *
    star (evaluatedMatrix ZMod.stdAddChar (sockets base) j d p)

theorem fullM_eq (base : Absorbing42Small.Incidence) (j : G) (c d : R) :
    fullM base j c d = HGPSpectral.M base (beta j) c d := by
  simp only [fullM, sockets, source_evaluated_eq_D, right_eval_beta, HGPSpectral.M]

theorem identical_actual_complex_M : fullM Absorbing42Small.baseA = fullM Absorbing42Small.baseB := by
  funext j c d
  simp only [fullM_eq]
  exact congrFun (congrFun (congrFun (HGPSpectral.identical_all_evaluated_M beta) j) c) d

theorem no_actual_complex_M_only_count :
    ¬ ∃ f : (G → R → R → ℂ) → ℕ,
      f (fullM Absorbing42Small.baseA) = GlobalCounting.count42
        (CyclicNormalization.incidence (sockets Absorbing42Small.baseA)) ∧
      f (fullM Absorbing42Small.baseB) = GlobalCounting.count42
        (CyclicNormalization.incidence (sockets Absorbing42Small.baseB)) := by
  rintro ⟨f,ha,hb⟩
  rw [identical_actual_complex_M, count_A] at ha
  rw [count_B] at hb
  omega

#print axioms source_incidence_bridge
#print axioms literal_A_bridge
#print axioms literal_B_bridge
#print axioms count_A
#print axioms count_B
#print axioms beta_eq_polynomial
#print axioms identical_actual_complex_M
#print axioms no_actual_complex_M_only_count
end ComplexQuantumWitness
