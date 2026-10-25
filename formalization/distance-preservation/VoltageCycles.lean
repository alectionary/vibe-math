import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace VoltageCycles
variable {m n L : Nat}
abbrev Check (m L : Nat) := Fin m × ZMod L
abbrev Variable (n L : Nat) := Fin n × ZMod L

/-- The entry convention is P^e(row,col)=1 iff row=col+e. -/
def Edge (E : Fin m → Fin n → ZMod L) (r : Check m L) (c : Variable n L) : Prop :=
  r.2 = c.2 + E r.1 c.1

theorem check_base_ne (E : Fin m → Fin n → ZMod L)
    {a b : Check m L} {v : Variable n L} (hab : a ≠ b)
    (ha : Edge E a v) (hb : Edge E b v) : a.1 ≠ b.1 := by
  intro h
  apply hab
  apply Prod.ext h
  exact ha.trans (by simpa [Edge, h] using hb.symm)

theorem variable_base_ne (E : Fin m → Fin n → ZMod L)
    {a b : Variable n L} {v : Check m L} (hab : a ≠ b)
    (ha : Edge E v a) (hb : Edge E v b) : a.1 ≠ b.1 := by
  intro h
  apply hab
  apply Prod.ext h
  have he : a.2 + E v.1 a.1 = b.2 + E v.1 a.1 :=
    ha.symm.trans (by simpa [Edge, h] using hb)
  exact add_right_cancel he

def NoFourVoltage (E : Fin m → Fin n → ZMod L) : Prop :=
  ∀ i j a b, i ≠ j → a ≠ b → E i a - E j a + E j b - E i b ≠ 0

def NoSixVoltage (E : Fin m → Fin n → ZMod L) : Prop :=
  ∀ i j k a b c, i ≠ j → j ≠ k → k ≠ i → a ≠ b → b ≠ c → c ≠ a →
    E i a - E j a + E j b - E k b + E k c - E i c ≠ 0

/-- No simple alternating four-cycle in the actual cyclic lift. -/
theorem no_four (E : Fin m → Fin n → ZMod L) (hE : NoFourVoltage E)
    (i j : Check m L) (a b : Variable n L) (hij : i ≠ j) (hab : a ≠ b)
    (h0 : Edge E i a) (h1 : Edge E j a) (h2 : Edge E j b) (h3 : Edge E i b) : False := by
  apply hE i.1 j.1 a.1 b.1 (check_base_ne E hij h0 h1) (variable_base_ne E hab h1 h2)
  unfold Edge at h0 h1 h2 h3
  linear_combination -h0 + h1 - h2 + h3

/-- No simple alternating six-cycle in the actual cyclic lift. -/
theorem no_six (E : Fin m → Fin n → ZMod L) (hE : NoSixVoltage E)
    (i j k : Check m L) (a b c : Variable n L)
    (hij : i ≠ j) (hjk : j ≠ k) (hki : k ≠ i)
    (hab : a ≠ b) (hbc : b ≠ c) (hca : c ≠ a)
    (h0 : Edge E i a) (h1 : Edge E j a) (h2 : Edge E j b)
    (h3 : Edge E k b) (h4 : Edge E k c) (h5 : Edge E i c) : False := by
  apply hE i.1 j.1 k.1 a.1 b.1 c.1
    (check_base_ne E hij h0 h1) (check_base_ne E hjk h2 h3) (check_base_ne E hki h4 h5)
    (variable_base_ne E hab h1 h2) (variable_base_ne E hbc h3 h4) (variable_base_ne E hca h5 h0)
  unfold Edge at h0 h1 h2 h3 h4 h5
  linear_combination -h0 + h1 - h2 + h3 - h4 + h5

#print axioms no_four
#print axioms no_six
end VoltageCycles
