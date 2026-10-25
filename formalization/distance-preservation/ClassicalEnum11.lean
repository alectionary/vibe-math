import BinaryWords
set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace ClassicalCertificate11
def encode (c : BitVec 13) : BitVec 44 :=
  (if c.getLsbD 0 then 4194303#44 else 0#44) ^^^
  (if c.getLsbD 1 then 8585742335#44 else 0#44) ^^^
  (if c.getLsbD 2 then 9987976129#44 else 0#44) ^^^
  (if c.getLsbD 3 then 19974793341#44 else 0#44) ^^^
  (if c.getLsbD 4 then 37359823098#44 else 0#44) ^^^
  (if c.getLsbD 5 then 71309240820#44 else 0#44) ^^^
  (if c.getLsbD 6 then 140849359848#44 else 0#44) ^^^
  (if c.getLsbD 7 then 276644581423#44 else 0#44) ^^^
  (if c.getLsbD 8 then 553289162846#44 else 0#44) ^^^
  (if c.getLsbD 9 then 1101034862780#44 else 0#44) ^^^
  (if c.getLsbD 10 then 2202069725560#44 else 0#44) ^^^
  (if c.getLsbD 11 then 4400543505136#44 else 0#44) ^^^
  (if c.getLsbD 12 then 8799688969696#44 else 0#44)
def goodBlock (b : Nat) : Bool := (List.range 128).all fun a =>
  let x := encode (BitVec.ofNat 13 (128*b+a))
  (x == 0#44) || decide ((12 : BitVec 44) ≤ x.cpop)
theorem block_0 : goodBlock 0 = true := by decide +kernel
theorem block_1 : goodBlock 1 = true := by decide +kernel
theorem block_2 : goodBlock 2 = true := by decide +kernel
theorem block_3 : goodBlock 3 = true := by decide +kernel
theorem block_4 : goodBlock 4 = true := by decide +kernel
theorem block_5 : goodBlock 5 = true := by decide +kernel
theorem block_6 : goodBlock 6 = true := by decide +kernel
theorem block_7 : goodBlock 7 = true := by decide +kernel
theorem block_8 : goodBlock 8 = true := by decide +kernel
theorem block_9 : goodBlock 9 = true := by decide +kernel
theorem block_10 : goodBlock 10 = true := by decide +kernel
theorem block_11 : goodBlock 11 = true := by decide +kernel
theorem block_12 : goodBlock 12 = true := by decide +kernel
theorem block_13 : goodBlock 13 = true := by decide +kernel
theorem block_14 : goodBlock 14 = true := by decide +kernel
theorem block_15 : goodBlock 15 = true := by decide +kernel
theorem block_16 : goodBlock 16 = true := by decide +kernel
theorem block_17 : goodBlock 17 = true := by decide +kernel
theorem block_18 : goodBlock 18 = true := by decide +kernel
theorem block_19 : goodBlock 19 = true := by decide +kernel
theorem block_20 : goodBlock 20 = true := by decide +kernel
theorem block_21 : goodBlock 21 = true := by decide +kernel
theorem block_22 : goodBlock 22 = true := by decide +kernel
theorem block_23 : goodBlock 23 = true := by decide +kernel
theorem block_24 : goodBlock 24 = true := by decide +kernel
theorem block_25 : goodBlock 25 = true := by decide +kernel
theorem block_26 : goodBlock 26 = true := by decide +kernel
theorem block_27 : goodBlock 27 = true := by decide +kernel
theorem block_28 : goodBlock 28 = true := by decide +kernel
theorem block_29 : goodBlock 29 = true := by decide +kernel
theorem block_30 : goodBlock 30 = true := by decide +kernel
theorem block_31 : goodBlock 31 = true := by decide +kernel
theorem block_32 : goodBlock 32 = true := by decide +kernel
theorem block_33 : goodBlock 33 = true := by decide +kernel
theorem block_34 : goodBlock 34 = true := by decide +kernel
theorem block_35 : goodBlock 35 = true := by decide +kernel
theorem block_36 : goodBlock 36 = true := by decide +kernel
theorem block_37 : goodBlock 37 = true := by decide +kernel
theorem block_38 : goodBlock 38 = true := by decide +kernel
theorem block_39 : goodBlock 39 = true := by decide +kernel
theorem block_40 : goodBlock 40 = true := by decide +kernel
theorem block_41 : goodBlock 41 = true := by decide +kernel
theorem block_42 : goodBlock 42 = true := by decide +kernel
theorem block_43 : goodBlock 43 = true := by decide +kernel
theorem block_44 : goodBlock 44 = true := by decide +kernel
theorem block_45 : goodBlock 45 = true := by decide +kernel
theorem block_46 : goodBlock 46 = true := by decide +kernel
theorem block_47 : goodBlock 47 = true := by decide +kernel
theorem block_48 : goodBlock 48 = true := by decide +kernel
theorem block_49 : goodBlock 49 = true := by decide +kernel
theorem block_50 : goodBlock 50 = true := by decide +kernel
theorem block_51 : goodBlock 51 = true := by decide +kernel
theorem block_52 : goodBlock 52 = true := by decide +kernel
theorem block_53 : goodBlock 53 = true := by decide +kernel
theorem block_54 : goodBlock 54 = true := by decide +kernel
theorem block_55 : goodBlock 55 = true := by decide +kernel
theorem block_56 : goodBlock 56 = true := by decide +kernel
theorem block_57 : goodBlock 57 = true := by decide +kernel
theorem block_58 : goodBlock 58 = true := by decide +kernel
theorem block_59 : goodBlock 59 = true := by decide +kernel
theorem block_60 : goodBlock 60 = true := by decide +kernel
theorem block_61 : goodBlock 61 = true := by decide +kernel
theorem block_62 : goodBlock 62 = true := by decide +kernel
theorem block_63 : goodBlock 63 = true := by decide +kernel
end ClassicalCertificate11
