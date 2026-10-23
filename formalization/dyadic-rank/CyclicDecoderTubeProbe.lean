import CyclicDecoderTubeData.PreviousDevelopment
open CyclicDecoderPersistence CyclicDecoderTubeData
set_option maxRecDepth 100000
set_option maxHeartbeats 20000000
namespace CyclicDecoderTubeProbe
open PreviousDevelopment
theorem first_step : ∀ e : E,
    (boxes 1 e).lo ≤ (boxNext decoder target (boxes 0) e).lo ∧
    (boxNext decoder target (boxes 0) e).hi ≤ (boxes 1 e).hi := by apply checked_all; decide +kernel
#print axioms first_step
end CyclicDecoderTubeProbe
