import ParametricSource
import CoverDistance
import FamilyBaseDistance
import FamilyTreeStopping
set_option maxHeartbeats 0
namespace ParametricProjection
variable {L : Nat} [NeZero L]

def RowPairing (e : Fin 3 → Fin 4 → ZMod L) : Prop := ∃ i j k : Fin 3,
  i≠j ∧ j≠k ∧ k≠i ∧ ∀ c, e i c+e j c=e k c+e k c

def ColumnPairing (e : Fin 3 → Fin 4 → ZMod L) : Prop := ∃ a b c d : Fin 4,
  a≠b ∧ a≠c ∧ a≠d ∧ b≠c ∧ b≠d ∧ c≠d ∧ ∀ i, e i a+e i b=e i c+e i d

theorem projected_exponents (p : ZMod L →+ ZMod 11) (a b : ZMod L)
    (ha : p a=1) (hb : p b=5) :
    (fun i j => p (ParametricWords.e a b i j))=FamilyBaseGraph.e := by
  have pm2 (x : ZMod L) : p (2*x)=2*p x := by simp [two_mul,map_add]
  have pm3 (x : ZMod L) : p (3*x)=3*p x := by
    have h : 3*x=x+x+x := by ring
    rw [h,map_add,map_add]
    ring
  funext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [ParametricWords.e,FamilyBaseGraph.e,FamilyWords.exponent,map_zero,map_add,pm2,pm3,ha,hb]

theorem no_four (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5) :
    VoltageCycles.NoFourVoltage (ParametricWords.e a b) := by
  have he := projected_exponents p a b ha hb
  have hp (i j) : p (ParametricWords.e a b i j)=FamilyBaseGraph.e i j := congrFun (congrFun he i) j
  intro i j c d hij hcd hz
  have h:=congrArg p hz
  simp only [map_add,map_sub,map_zero,hp] at h
  exact FamilyNoShort.base_no_four i j c d hij hcd h

theorem no_six (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5) :
    VoltageCycles.NoSixVoltage (ParametricWords.e a b) := by
  have he := projected_exponents p a b ha hb
  have hp (i j) : p (ParametricWords.e a b i j)=FamilyBaseGraph.e i j := congrFun (congrFun he i) j
  intro i j k c d f hij hjk hki hcd hdf hfc hz
  have h:=congrArg p hz
  simp only [map_add,map_sub,map_zero,hp] at h
  exact FamilyNoShort.base_no_six i j k c d f hij hjk hki hcd hdf hfc h

theorem no_row_pairing (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5) :
    ¬ RowPairing (ParametricWords.e a b) := by
  have he := projected_exponents p a b ha hb
  have hp (i j) : p (ParametricWords.e a b i j)=FamilyBaseGraph.e i j := congrFun (congrFun he i) j
  rintro ⟨i,j,k,hij,hjk,hki,h⟩
  apply FamilyNoShort.base_no_row_pairing
  refine ⟨i,j,k,hij,hjk,hki,?_⟩
  intro c
  have hh:=congrArg p (h c)
  simpa only [map_add,hp,FamilyBaseGraph.e,FamilyNoShort.e] using hh

theorem no_column_pairing (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5) :
    ¬ ColumnPairing (ParametricWords.e a b) := by
  have he := projected_exponents p a b ha hb
  have hp (i j) : p (ParametricWords.e a b i j)=FamilyBaseGraph.e i j := congrFun (congrFun he i) j
  rintro ⟨i,j,k,l,hij,hik,hil,hjk,hjl,hkl,h⟩
  apply FamilyNoShort.base_no_column_pairing
  refine ⟨i,j,k,l,hij,hik,hil,hjk,hjl,hkl,?_⟩
  intro c
  have hh:=congrArg p (h c)
  simpa only [map_add,hp,FamilyBaseGraph.e,FamilyNoShort.e] using hh

theorem classical_lower (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5)
    (x : CyclicCover.Word (ZMod L)) (hx : CyclicCover.Kernel (ParametricWords.e a b) x) (hn : x≠0) :
    12≤(CoverWeight.support x).card := by
  have he:=projected_exponents p a b ha hb
  apply CoverDistance.lower_bound p (ParametricWords.e a b) 12 6 _ _ x hx hn
  · intro y hy hny
    rw [he] at hy
    exact FamilyBaseGraph.code_lower_twelve y hy hny
  · intro T hT
    rw [he] at hT
    exact FamilyTreeStopping.base_stopping_six T hT

theorem actual_classical_lower (p : ZMod L →+ ZMod 11) (a b : ZMod L)
    (ha : p a=1) (hb : p b=5) (x : CyclicCover.Word (ZMod L))
    (hx : ∀ c, ∑ v, GeneralLP.C (ParametricWords.e a b) c v*x v=0) (hn : x≠0) :
    12≤(CoverWeight.support x).card :=
  classical_lower p a b ha hb x
    (fun c => (GeneralLP.classical_action (ParametricWords.e a b) x c).symm.trans (hx c)) hn

/-- The source-matched obstruction persists whenever the parameter pair maps
to(1,5) in the11-fold base. These are arithmetic hypotheses, not distance premises. -/
theorem projected_counterfamily (p : ZMod L →+ ZMod 11) (a b : ZMod L) (ha : p a=1) (hb : p b=5) :
    VoltageCycles.NoFourVoltage (ParametricWords.e a b) ∧
    VoltageCycles.NoSixVoltage (ParametricWords.e a b) ∧
    ¬ RowPairing (ParametricWords.e a b) ∧ ¬ ColumnPairing (ParametricWords.e a b) ∧
    (∀ x : CyclicCover.Word (ZMod L),
      (∀ c, ∑ v, GeneralLP.C (ParametricWords.e a b) c v*x v=0) →
      x≠0 → 12≤(CoverWeight.support x).card) ∧
    GeneralLP.LogicalX (ParametricWords.e a b) (ParametricWords.U a b) ParametricWords.V ∧
    (CoverWeight.support (GeneralLP.join (ParametricWords.U a b) ParametricWords.V)).card≤11 :=
  ⟨no_four p a b ha hb,no_six p a b ha hb,no_row_pairing p a b ha hb,
    no_column_pairing p a b ha hb,actual_classical_lower p a b ha hb,
    ParametricWords.parametric_obstruction a b⟩

/-- A concrete cyclic parameter condition: reduce a,b to1,5 modulo11. -/
theorem cyclic_congruence_counterfamily (hL : 11 ∣ L) (a b : ZMod L)
    (ha : ZMod.castHom hL (ZMod 11) a=1) (hb : ZMod.castHom hL (ZMod 11) b=5) :
    VoltageCycles.NoFourVoltage (ParametricWords.e a b) ∧
    VoltageCycles.NoSixVoltage (ParametricWords.e a b) ∧
    ¬ RowPairing (ParametricWords.e a b) ∧ ¬ ColumnPairing (ParametricWords.e a b) ∧
    (∀ x : CyclicCover.Word (ZMod L),
      (∀ c, ∑ v, GeneralLP.C (ParametricWords.e a b) c v*x v=0) →
      x≠0 → 12≤(CoverWeight.support x).card) ∧
    GeneralLP.LogicalX (ParametricWords.e a b) (ParametricWords.U a b) ParametricWords.V ∧
    (CoverWeight.support (GeneralLP.join (ParametricWords.U a b) ParametricWords.V)).card≤11 :=
  projected_counterfamily (ZMod.castHom hL (ZMod 11)).toAddMonoidHom a b ha hb

#print axioms projected_exponents
#print axioms classical_lower
#print axioms projected_counterfamily
#print axioms cyclic_congruence_counterfamily
end ParametricProjection
