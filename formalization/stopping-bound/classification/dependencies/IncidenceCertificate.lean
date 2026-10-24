module

public import IncidenceFamily
public import IncidenceCSS
public import IncidenceDegrees
public import IncidenceSpectral

@[expose] public section
set_option linter.unusedSimpArgs false
set_option linter.unusedSectionVars false
open Matrix
namespace Incidence.Family

/-- The single finite-code family contract. t is any positive natural number.
The graph is the actual binary CSS check matrix. No logical k or d is asserted. -/
theorem positive_family (t : ℕ) [NeZero t] :
    Fintype.card (Var (63*t)) = 882*t ∧
    Fintype.card (Check (63*t)) = 441*t ∧
    (∀ v : Var (63*t), (Finset.univ.filter (fun c => HX c v = 1)).card = 3) ∧
    (∀ c : Check (63*t), (Finset.univ.filter (fun v => HX c v = 1)).card = 6) ∧
    HX2 (n := 63*t) * (HZ2 (n := 63*t))ᵀ = 0 ∧
    (∀ T : Finset (Var (63*t)), Stopping (fun v c => HX2 c v = 1) T → 6 ≤ T.card) ∧
    ∃ T : Finset (Var (63*t)), Stopping (fun v c => HX2 c v = 1) T ∧ T.card = 6 := by
  have hd : 63 ∣ 63*t := dvd_mul_right 63 t
  refine ⟨?_,?_,column_weight hd,row_weight hd,css,?_,?_⟩
  · rw [(dimensions (n := 63*t)).1]; omega
  · rw [(dimensions (n := 63*t)).2]; omega
  · intro T hT
    apply lower_six hd T
    simpa only [Stopping,HX2_incidence hd] using hT
  · refine ⟨six,?_,six_card hd⟩
    simpa only [Stopping,HX2_incidence hd] using (six_stopping (n := 63*t))

/-- The paper's 882-column instance is t=1 in the same binary-matrix semantics. -/
theorem source_B1_stopping_distance_six :
    (∀ T : Finset (Var 63), Stopping (fun v c => HX2 c v = 1) T → 6 ≤ T.card) ∧
    ∃ T : Finset (Var 63), Stopping (fun v c => HX2 c v = 1) T ∧ T.card = 6 := by
  simpa using (positive_family 1).2.2.2.2.2

end Incidence.Family
