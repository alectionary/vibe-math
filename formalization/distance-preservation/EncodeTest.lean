import ClassicalEnum11
open ClassicalCertificate11
set_option maxHeartbeats 0
example (c : BitVec 13) : (encode c).getLsbD 0 = (c.getLsbD 0 ^^ c.getLsbD 1 ^^ c.getLsbD 2 ^^ c.getLsbD 3) := by
 simp [encode, BitVec.getLsbD_xor, apply_ite, BitVec.getLsbD_ofNat, Bool.xor_assoc]
