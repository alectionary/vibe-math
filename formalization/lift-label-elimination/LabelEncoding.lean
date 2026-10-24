import StarVoltageData
import TriangleVoltageData

set_option maxHeartbeats 0
namespace LabelEncoding
variable {R : Type*} [CommRing R]

theorem star_raw_edges (z : Fin 30 → R) : ∀ i : Fin 30,
    StarVoltageData.labelsRaw z (StarVoltageData.edges i).1 (StarVoltageData.edges i).2=z i := by
  intro i; fin_cases i <;> rfl

theorem triangle_raw_edges (z : Fin 30 → R) : ∀ i : Fin 30,
    TriangleVoltageData.labelsRaw z (TriangleVoltageData.edges i).1 (TriangleVoltageData.edges i).2=z i := by
  intro i; fin_cases i <;> rfl

theorem star_raw_injective : Function.Injective (StarVoltageData.labelsRaw (R := R)) := by
  intro z w h
  funext i
  rw [← star_raw_edges z i,← star_raw_edges w i,h]

theorem triangle_raw_injective : Function.Injective (TriangleVoltageData.labelsRaw (R := R)) := by
  intro z w h
  funext i
  rw [← triangle_raw_edges z i,← triangle_raw_edges w i,h]

theorem star_covers_edges (w : Fin 10 → Fin 10 → R) (v c : Fin 10) (hc : c∈StarVoltageData.H v) :
    StarVoltageData.labelsRaw (fun i => w (StarVoltageData.edges i).1 (StarVoltageData.edges i).2) v c=w v c := by
  obtain ⟨i,hi⟩ := StarVoltageData.edges_complete v c hc
  have h := star_raw_edges (fun i => w (StarVoltageData.edges i).1 (StarVoltageData.edges i).2) i
  simpa only [hi,Prod.fst,Prod.snd] using h

theorem triangle_covers_edges (w : Fin 10 → Fin 10 → R) (v c : Fin 10) (hc : c∈TriangleVoltageData.H v) :
    TriangleVoltageData.labelsRaw (fun i => w (TriangleVoltageData.edges i).1 (TriangleVoltageData.edges i).2) v c=w v c := by
  obtain ⟨i,hi⟩ := TriangleVoltageData.edges_complete v c hc
  have h := triangle_raw_edges (fun i => w (TriangleVoltageData.edges i).1 (TriangleVoltageData.edges i).2) i
  simpa only [hi,Prod.fst,Prod.snd] using h

def starPositions (j : Fin 11) : Fin 30 :=
  match j.val with
  | 0 => 7 | 1 => 10 | 2 => 11 | 3 => 16 | 4 => 19 | 5 => 22
  | 6 => 23 | 7 => 25 | 8 => 26 | 9 => 28 | _ => 29

def trianglePositions (j : Fin 11) : Fin 30 :=
  match j.val with
  | 0 => 8 | 1 => 10 | 2 => 11 | 3 => 16 | 4 => 19 | 5 => 22
  | 6 => 23 | 7 => 25 | 8 => 26 | 9 => 28 | _ => 29

theorem positions_injective : Function.Injective starPositions ∧ Function.Injective trianglePositions := by decide

theorem star_slice_positions (z : Fin 11 → R) : ∀ j : Fin 11,
    StarVoltageData.labelsGauge z (StarVoltageData.edges (starPositions j)).1
      (StarVoltageData.edges (starPositions j)).2=z j := by
  intro j; fin_cases j <;> rfl

theorem triangle_slice_positions (z : Fin 11 → R) : ∀ j : Fin 11,
    TriangleVoltageData.labelsGauge z (TriangleVoltageData.edges (trianglePositions j)).1
      (TriangleVoltageData.edges (trianglePositions j)).2=z j := by
  intro j; fin_cases j <;> rfl

theorem star_slice_injective : Function.Injective (StarVoltageData.labelsGauge (R := R)) := by
  intro z w h
  funext i
  rw [← star_slice_positions z i,← star_slice_positions w i,h]

theorem triangle_slice_injective : Function.Injective (TriangleVoltageData.labelsGauge (R := R)) := by
  intro z w h
  funext i
  rw [← triangle_slice_positions z i,← triangle_slice_positions w i,h]

#print axioms star_raw_edges
#print axioms triangle_raw_edges
#print axioms star_covers_edges
#print axioms triangle_covers_edges
#print axioms star_slice_injective
#print axioms triangle_slice_injective
end LabelEncoding
