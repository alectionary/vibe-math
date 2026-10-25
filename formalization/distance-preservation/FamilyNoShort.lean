import FamilyWords
import VoltageCycles

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace FamilyNoShort
def e (L : Nat) (i : Fin 3) (j : Fin 4) : ZMod L := FamilyWords.exponent i j

theorem base_no_four : VoltageCycles.NoFourVoltage (e 11) := by
  unfold VoltageCycles.NoFourVoltage
  decide +kernel
theorem base_no_six : VoltageCycles.NoSixVoltage (e 11) := by
  unfold VoltageCycles.NoSixVoltage
  decide +kernel

def RowPairing (L : Nat) : Prop := ∃ i j k : Fin 3,
  i ≠ j ∧ j ≠ k ∧ k ≠ i ∧ ∀ c, e L i c + e L j c = e L k c + e L k c
def ColumnPairing (L : Nat) : Prop := ∃ a b c d : Fin 4,
  a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d ∧
    ∀ i, e L i a + e L i b = e L i c + e L i d

theorem base_no_row_pairing : ¬ RowPairing 11 := by unfold RowPairing; decide +kernel
theorem base_no_column_pairing : ¬ ColumnPairing 11 := by unfold ColumnPairing; decide +kernel

variable {L : Nat}
theorem no_four (hL : 11 ∣ L) : VoltageCycles.NoFourVoltage (e L) := by
  intro i j a b hij hab hz
  have h := congrArg (ZMod.castHom hL (ZMod 11)) hz
  simp only [map_sub,map_add,map_zero,map_intCast,e] at h
  exact base_no_four i j a b hij hab h

theorem no_six (hL : 11 ∣ L) : VoltageCycles.NoSixVoltage (e L) := by
  intro i j k a b c hij hjk hki hab hbc hca hz
  have h := congrArg (ZMod.castHom hL (ZMod 11)) hz
  simp only [map_sub,map_add,map_zero,map_intCast,e] at h
  exact base_no_six i j k a b c hij hjk hki hab hbc hca h

theorem no_row_pairing (hL : 11 ∣ L) : ¬ RowPairing L := by
  rintro ⟨i,j,k,hij,hjk,hki,h⟩
  apply base_no_row_pairing
  refine ⟨i,j,k,hij,hjk,hki,?_⟩
  intro c
  have hh := congrArg (ZMod.castHom hL (ZMod 11)) (h c)
  simpa only [map_add,map_intCast,e] using hh

theorem no_column_pairing (hL : 11 ∣ L) : ¬ ColumnPairing L := by
  rintro ⟨a,b,c,d,hab,hac,had,hbc,hbd,hcd,h⟩
  apply base_no_column_pairing
  refine ⟨a,b,c,d,hab,hac,had,hbc,hbd,hcd,?_⟩
  intro i
  have hh := congrArg (ZMod.castHom hL (ZMod 11)) (h i)
  simpa only [map_add,map_intCast,e] using hh

#print axioms no_four
#print axioms no_six
#print axioms no_row_pairing
#print axioms no_column_pairing
end FamilyNoShort
