import CertValue

set_option maxHeartbeats 0

theorem swap_check_ok : C16Frames.CertRun.checkOk = true := by
  native_decide
