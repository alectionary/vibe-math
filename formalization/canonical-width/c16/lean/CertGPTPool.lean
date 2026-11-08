/- Separate inexpensive check tying decoded certificate vectors to generated pool data. -/
import CertGPTData
import CertGPTSwapData
import PoolData
namespace C16Frames.CertGPT
@[noinline] def swapPoolsOK : Bool :=
  match decodeText swapEncoded with
  | none => false
  | some (d,_) => d.x == C16Frames.Pools.xArr && d.z == C16Frames.Pools.zArr

theorem swap_pools_ok : swapPoolsOK = true := by native_decide
#print axioms swap_pools_ok
end C16Frames.CertGPT
