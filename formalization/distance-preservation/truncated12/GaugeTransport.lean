import GeneralLP
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : Nat} [NeZero L]

def gaugeE (e : Fin 3 → Fin 4 → ZMod L) (r : Fin 3 → ZMod L)
    (c : Fin 4 → ZMod L) (i : Fin 3) (j : Fin 4) := e i j + r i + c j
def gaugeU (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (c : Fin 4 → ZMod L)
    (i j : Fin 4) (s : ZMod L) := u i j (s+c i+c j)
def gaugeV (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (r : Fin 3 → ZMod L)
    (i j : Fin 3) (s : ZMod L) := v i j (s-r i-r j)
def gaugeW (w : Fin 3 → Fin 4 → ZMod L → ZMod 2)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (i : Fin 3) (j : Fin 4) (s : ZMod L) := w i j (s-r i+c j)

theorem gauge_syndrome (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (j : Fin 4) (i : Fin 3) (t : ZMod L) :
    GeneralLP.Syndrome (gaugeE e r c) (gaugeU u c) (gaugeV v r) j i t =
      GeneralLP.Syndrome e u v j i (t-r i+c j) := by
  unfold GeneralLP.Syndrome gaugeE gaugeU gaugeV
  congr 1
  · apply Finset.sum_congr rfl
    intro k _
    congr 1
    ring
  · apply Finset.sum_congr rfl
    intro l _
    congr 1
    ring

theorem gauge_span_left (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 4) (s : ZMod L) :
    GeneralLP.stabilizerLeft (gaugeE e r c) (gaugeW w r c) i j s =
      gaugeU (GeneralLP.stabilizerLeft e w) c i j s := by
  unfold GeneralLP.stabilizerLeft gaugeE gaugeW gaugeU
  apply Finset.sum_congr rfl
  intro k _
  congr 1
  ring

theorem gauge_span_right (e : Fin 3 → Fin 4 → ZMod L)
    (r : Fin 3 → ZMod L) (c : Fin 4 → ZMod L)
    (w : Fin 3 → Fin 4 → ZMod L → ZMod 2) (i j : Fin 3) (s : ZMod L) :
    GeneralLP.stabilizerRight (gaugeE e r c) (gaugeW w r c) i j s =
      gaugeV (GeneralLP.stabilizerRight e w) r i j s := by
  unfold GeneralLP.stabilizerRight gaugeE gaugeW gaugeV
  apply Finset.sum_congr rfl
  intro k _
  congr 1
  ring

#print axioms gauge_syndrome
#print axioms gauge_span_left
#print axioms gauge_span_right
end TruncatedDistance
