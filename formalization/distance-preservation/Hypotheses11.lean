import Source11
import VoltageCycles

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace Source11
def voltage (i : Fin 3) (j : Fin 4) : ZMod 11 := exponent i.val j.val

theorem no_four_voltage : VoltageCycles.NoFourVoltage voltage := by
  unfold VoltageCycles.NoFourVoltage
  decide +kernel
theorem no_six_voltage : VoltageCycles.NoSixVoltage voltage := by
  unfold VoltageCycles.NoSixVoltage
  decide +kernel

/-- Definition 5, specialized to three rows: one pair and one self-pair. -/
def RowPairing : Prop := ∃ i j k : Fin 3,
  i ≠ j ∧ j ≠ k ∧ k ≠ i ∧ ∀ c, voltage i c + voltage j c = voltage k c + voltage k c
/-- Definition 2, specialized to four columns: two disjoint pairs. -/
def ColumnPairing : Prop := ∃ a b c d : Fin 4,
  a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ b ≠ c ∧ b ≠ d ∧ c ≠ d ∧
    ∀ i, voltage i a + voltage i b = voltage i c + voltage i d

theorem no_row_pairing : ¬ RowPairing := by
  unfold RowPairing
  decide +kernel
theorem no_column_pairing : ¬ ColumnPairing := by
  unfold ColumnPairing
  decide +kernel

theorem no_four_cycle (i j : VoltageCycles.Check 3 11)
    (a b : VoltageCycles.Variable 4 11) (hij : i ≠ j) (hab : a ≠ b)
    (h0 : VoltageCycles.Edge voltage i a) (h1 : VoltageCycles.Edge voltage j a)
    (h2 : VoltageCycles.Edge voltage j b) (h3 : VoltageCycles.Edge voltage i b) : False :=
  VoltageCycles.no_four voltage no_four_voltage i j a b hij hab h0 h1 h2 h3

theorem no_six_cycle (i j k : VoltageCycles.Check 3 11)
    (a b c : VoltageCycles.Variable 4 11)
    (hij : i ≠ j) (hjk : j ≠ k) (hki : k ≠ i)
    (hab : a ≠ b) (hbc : b ≠ c) (hca : c ≠ a)
    (h0 : VoltageCycles.Edge voltage i a) (h1 : VoltageCycles.Edge voltage j a)
    (h2 : VoltageCycles.Edge voltage j b) (h3 : VoltageCycles.Edge voltage k b)
    (h4 : VoltageCycles.Edge voltage k c) (h5 : VoltageCycles.Edge voltage i c) : False :=
  VoltageCycles.no_six voltage no_six_voltage i j k a b c hij hjk hki hab hbc hca h0 h1 h2 h3 h4 h5

#print axioms no_four_cycle
#print axioms no_six_cycle
#print axioms no_row_pairing
#print axioms no_column_pairing
end Source11
