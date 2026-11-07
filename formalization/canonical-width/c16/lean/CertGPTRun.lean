/- Native evaluation of the concrete, authenticated swap certificate.
   This is acceptance only, NOT the requested no_swap_frame theorem. -/
import CertGPTData
import CertGPTSwapData
namespace C16Frames.CertGPT
@[noinline] def swapCertificateOK : Bool :=
  match decodeText swapEncoded with
  | none => false
  | some (d,tokens) => validateItems d "swap" && checkViaKernel d tokens

theorem swap_check_ok : swapCertificateOK = true := by native_decide
#print axioms swap_check_ok
end C16Frames.CertGPT
