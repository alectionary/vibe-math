import CertRun
import SwapCert
import PoolData

namespace C16Frames.CertRun

def swapTable : Table :=
  decodeTable SwapCert.itemHex

/-- Item table agrees with the swap orbits of partial frames read off the pool arrays. -/
def itemsOk : Bool :=
  itemsMatch C16Frames.Pools.xArr C16Frames.Pools.zArr swapTable

/-- The swap certificate stream is accepted. -/
def checkOk : Bool :=
  check C16Frames.Pools.xArr C16Frames.Pools.zArr swapTable (decodeHex SwapCert.certHex)

def certificateOk : Bool :=
  itemsOk && checkOk

end C16Frames.CertRun
