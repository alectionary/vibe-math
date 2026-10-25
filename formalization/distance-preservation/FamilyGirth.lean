import FamilyNoShort
set_option maxHeartbeats 0
namespace FamilyGirth
variable {L : Nat} [NeZero L]
abbrev V := VoltageCycles.Variable 4 L
abbrev C := VoltageCycles.Check 3 L

def checks : List (C (L := L)) := [(0,0),(1,0),(2,1),(1,1)]
def variableVertices : List (V (L := L)) := [(0,0),(1,-1),(0,1),(1,0)]

theorem eight_distinct (hL : 11 ∣ L) :
    (checks (L := L)).Nodup ∧ (variableVertices (L := L)).Nodup := by
  have hl : 11 ≤ L := Nat.le_of_dvd (NeZero.pos L) hL
  letI : Fact (1<L) := ⟨by omega⟩
  simp [checks,variableVertices]

theorem eight_edges :
    VoltageCycles.Edge (FamilyNoShort.e L) (0,0) (0,0) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (1,0) (0,0) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (1,0) (1,-1) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (2,1) (1,-1) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (2,1) (0,1) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (1,1) (0,1) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (1,1) (1,0) ∧
    VoltageCycles.Edge (FamilyNoShort.e L) (0,0) (1,0) := by
  norm_num [VoltageCycles.Edge,FamilyNoShort.e,FamilyWords.exponent]

/-- No4/6 cycles and an explicit simple8-cycle in the actual Tanner incidence. -/
theorem exact_eight_certificate (hL : 11 ∣ L) :
    VoltageCycles.NoFourVoltage (FamilyNoShort.e L) ∧
    VoltageCycles.NoSixVoltage (FamilyNoShort.e L) ∧
    (checks (L := L)).Nodup ∧ (variableVertices (L := L)).Nodup :=
  ⟨FamilyNoShort.no_four hL,FamilyNoShort.no_six hL,(eight_distinct hL).1,(eight_distinct hL).2⟩

#print axioms eight_distinct
#print axioms eight_edges
#print axioms exact_eight_certificate
end FamilyGirth
