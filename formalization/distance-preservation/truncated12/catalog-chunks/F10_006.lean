import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_6000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6000 : checkCertificateFast 10 6000 fastCert10_6000=true := by decide +kernel
def fastCert10_6001 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6001 : checkCertificateFast 10 6001 fastCert10_6001=true := by decide +kernel
def fastCert10_6002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6002 : checkCertificateFast 10 6002 fastCert10_6002=true := by decide +kernel
def fastCert10_6003 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6003 : checkCertificateFast 10 6003 fastCert10_6003=true := by decide +kernel
def fastCert10_6004 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6004 : checkCertificateFast 10 6004 fastCert10_6004=true := by decide +kernel
def fastCert10_6005 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6005 : checkCertificateFast 10 6005 fastCert10_6005=true := by decide +kernel
def fastCert10_6006 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6006 : checkCertificateFast 10 6006 fastCert10_6006=true := by decide +kernel
def fastCert10_6007 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6007 : checkCertificateFast 10 6007 fastCert10_6007=true := by decide +kernel
def fastCert10_6008 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6008 : checkCertificateFast 10 6008 fastCert10_6008=true := by decide +kernel
def fastCert10_6009 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6009 : checkCertificateFast 10 6009 fastCert10_6009=true := by decide +kernel
def fastCert10_6010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6010 : checkCertificateFast 10 6010 fastCert10_6010=true := by decide +kernel
def fastCert10_6011 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6011 : checkCertificateFast 10 6011 fastCert10_6011=true := by decide +kernel
def fastCert10_6012 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6012 : checkCertificateFast 10 6012 fastCert10_6012=true := by decide +kernel
def fastCert10_6013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6013 : checkCertificateFast 10 6013 fastCert10_6013=true := by decide +kernel
def fastCert10_6014 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6014 : checkCertificateFast 10 6014 fastCert10_6014=true := by decide +kernel
def fastCert10_6015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6015 : checkCertificateFast 10 6015 fastCert10_6015=true := by decide +kernel
def fastCert10_6016 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6016 : checkCertificateFast 10 6016 fastCert10_6016=true := by decide +kernel
def fastCert10_6017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6017 : checkCertificateFast 10 6017 fastCert10_6017=true := by decide +kernel
def fastCert10_6018 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6018 : checkCertificateFast 10 6018 fastCert10_6018=true := by decide +kernel
def fastCert10_6019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6019 : checkCertificateFast 10 6019 fastCert10_6019=true := by decide +kernel
def fastCert10_6020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6020 : checkCertificateFast 10 6020 fastCert10_6020=true := by decide +kernel
def fastCert10_6021 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6021 : checkCertificateFast 10 6021 fastCert10_6021=true := by decide +kernel
def fastCert10_6022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6022 : checkCertificateFast 10 6022 fastCert10_6022=true := by decide +kernel
def fastCert10_6023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6023 : checkCertificateFast 10 6023 fastCert10_6023=true := by decide +kernel
def fastCert10_6024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6024 : checkCertificateFast 10 6024 fastCert10_6024=true := by decide +kernel
def fastCert10_6025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6025 : checkCertificateFast 10 6025 fastCert10_6025=true := by decide +kernel
def fastCert10_6026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6026 : checkCertificateFast 10 6026 fastCert10_6026=true := by decide +kernel
def fastCert10_6027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6027 : checkCertificateFast 10 6027 fastCert10_6027=true := by decide +kernel
def fastCert10_6028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6028 : checkCertificateFast 10 6028 fastCert10_6028=true := by decide +kernel
def fastCert10_6029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6029 : checkCertificateFast 10 6029 fastCert10_6029=true := by decide +kernel
def fastCert10_6030 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6030 : checkCertificateFast 10 6030 fastCert10_6030=true := by decide +kernel
def fastCert10_6031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6031 : checkCertificateFast 10 6031 fastCert10_6031=true := by decide +kernel
def fastCert10_6032 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6032 : checkCertificateFast 10 6032 fastCert10_6032=true := by decide +kernel
def fastCert10_6033 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6033 : checkCertificateFast 10 6033 fastCert10_6033=true := by decide +kernel
def fastCert10_6034 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6034 : checkCertificateFast 10 6034 fastCert10_6034=true := by decide +kernel
def fastCert10_6035 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6035 : checkCertificateFast 10 6035 fastCert10_6035=true := by decide +kernel
def fastCert10_6036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6036 : checkCertificateFast 10 6036 fastCert10_6036=true := by decide +kernel
def fastCert10_6037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6037 : checkCertificateFast 10 6037 fastCert10_6037=true := by decide +kernel
def fastCert10_6038 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6038 : checkCertificateFast 10 6038 fastCert10_6038=true := by decide +kernel
def fastCert10_6039 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6039 : checkCertificateFast 10 6039 fastCert10_6039=true := by decide +kernel
def fastCert10_6040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6040 : checkCertificateFast 10 6040 fastCert10_6040=true := by decide +kernel
def fastCert10_6041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6041 : checkCertificateFast 10 6041 fastCert10_6041=true := by decide +kernel
def fastCert10_6042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6042 : checkCertificateFast 10 6042 fastCert10_6042=true := by decide +kernel
def fastCert10_6043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6043 : checkCertificateFast 10 6043 fastCert10_6043=true := by decide +kernel
def fastCert10_6044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6044 : checkCertificateFast 10 6044 fastCert10_6044=true := by decide +kernel
def fastCert10_6045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6045 : checkCertificateFast 10 6045 fastCert10_6045=true := by decide +kernel
def fastCert10_6046 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6046 : checkCertificateFast 10 6046 fastCert10_6046=true := by decide +kernel
def fastCert10_6047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6047 : checkCertificateFast 10 6047 fastCert10_6047=true := by decide +kernel
def fastCert10_6048 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6048 : checkCertificateFast 10 6048 fastCert10_6048=true := by decide +kernel
def fastCert10_6049 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6049 : checkCertificateFast 10 6049 fastCert10_6049=true := by decide +kernel
def fastCert10_6050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6050 : checkCertificateFast 10 6050 fastCert10_6050=true := by decide +kernel
def fastCert10_6051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6051 : checkCertificateFast 10 6051 fastCert10_6051=true := by decide +kernel
def fastCert10_6052 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6052 : checkCertificateFast 10 6052 fastCert10_6052=true := by decide +kernel
def fastCert10_6053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6053 : checkCertificateFast 10 6053 fastCert10_6053=true := by decide +kernel
def fastCert10_6054 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6054 : checkCertificateFast 10 6054 fastCert10_6054=true := by decide +kernel
def fastCert10_6055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6055 : checkCertificateFast 10 6055 fastCert10_6055=true := by decide +kernel
def fastCert10_6056 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6056 : checkCertificateFast 10 6056 fastCert10_6056=true := by decide +kernel
def fastCert10_6057 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6057 : checkCertificateFast 10 6057 fastCert10_6057=true := by decide +kernel
def fastCert10_6058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6058 : checkCertificateFast 10 6058 fastCert10_6058=true := by decide +kernel
def fastCert10_6059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6059 : checkCertificateFast 10 6059 fastCert10_6059=true := by decide +kernel
def fastCert10_6060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6060 : checkCertificateFast 10 6060 fastCert10_6060=true := by decide +kernel
def fastCert10_6061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6061 : checkCertificateFast 10 6061 fastCert10_6061=true := by decide +kernel
def fastCert10_6062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6062 : checkCertificateFast 10 6062 fastCert10_6062=true := by decide +kernel
def fastCert10_6063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6063 : checkCertificateFast 10 6063 fastCert10_6063=true := by decide +kernel
def fastCert10_6064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6064 : checkCertificateFast 10 6064 fastCert10_6064=true := by decide +kernel
def fastCert10_6065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6065 : checkCertificateFast 10 6065 fastCert10_6065=true := by decide +kernel
def fastCert10_6066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6066 : checkCertificateFast 10 6066 fastCert10_6066=true := by decide +kernel
def fastCert10_6067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6067 : checkCertificateFast 10 6067 fastCert10_6067=true := by decide +kernel
def fastCert10_6068 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6068 : checkCertificateFast 10 6068 fastCert10_6068=true := by decide +kernel
def fastCert10_6069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6069 : checkCertificateFast 10 6069 fastCert10_6069=true := by decide +kernel
def fastCert10_6070 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6070 : checkCertificateFast 10 6070 fastCert10_6070=true := by decide +kernel
def fastCert10_6071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6071 : checkCertificateFast 10 6071 fastCert10_6071=true := by decide +kernel
def fastCert10_6072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6072 : checkCertificateFast 10 6072 fastCert10_6072=true := by decide +kernel
def fastCert10_6073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6073 : checkCertificateFast 10 6073 fastCert10_6073=true := by decide +kernel
def fastCert10_6074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6074 : checkCertificateFast 10 6074 fastCert10_6074=true := by decide +kernel
def fastCert10_6075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6075 : checkCertificateFast 10 6075 fastCert10_6075=true := by decide +kernel
def fastCert10_6076 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6076 : checkCertificateFast 10 6076 fastCert10_6076=true := by decide +kernel
def fastCert10_6077 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6077 : checkCertificateFast 10 6077 fastCert10_6077=true := by decide +kernel
def fastCert10_6078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6078 : checkCertificateFast 10 6078 fastCert10_6078=true := by decide +kernel
def fastCert10_6079 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6079 : checkCertificateFast 10 6079 fastCert10_6079=true := by decide +kernel
def fastCert10_6080 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6080 : checkCertificateFast 10 6080 fastCert10_6080=true := by decide +kernel
def fastCert10_6081 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6081 : checkCertificateFast 10 6081 fastCert10_6081=true := by decide +kernel
def fastCert10_6082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6082 : checkCertificateFast 10 6082 fastCert10_6082=true := by decide +kernel
def fastCert10_6083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6083 : checkCertificateFast 10 6083 fastCert10_6083=true := by decide +kernel
def fastCert10_6084 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6084 : checkCertificateFast 10 6084 fastCert10_6084=true := by decide +kernel
def fastCert10_6085 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6085 : checkCertificateFast 10 6085 fastCert10_6085=true := by decide +kernel
def fastCert10_6086 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6086 : checkCertificateFast 10 6086 fastCert10_6086=true := by decide +kernel
def fastCert10_6087 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6087 : checkCertificateFast 10 6087 fastCert10_6087=true := by decide +kernel
def fastCert10_6088 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6088 : checkCertificateFast 10 6088 fastCert10_6088=true := by decide +kernel
def fastCert10_6089 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6089 : checkCertificateFast 10 6089 fastCert10_6089=true := by decide +kernel
def fastCert10_6090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6090 : checkCertificateFast 10 6090 fastCert10_6090=true := by decide +kernel
def fastCert10_6091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6091 : checkCertificateFast 10 6091 fastCert10_6091=true := by decide +kernel
def fastCert10_6092 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6092 : checkCertificateFast 10 6092 fastCert10_6092=true := by decide +kernel
def fastCert10_6093 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6093 : checkCertificateFast 10 6093 fastCert10_6093=true := by decide +kernel
def fastCert10_6094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6094 : checkCertificateFast 10 6094 fastCert10_6094=true := by decide +kernel
def fastCert10_6095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6095 : checkCertificateFast 10 6095 fastCert10_6095=true := by decide +kernel
def fastCert10_6096 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6096 : checkCertificateFast 10 6096 fastCert10_6096=true := by decide +kernel
def fastCert10_6097 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6097 : checkCertificateFast 10 6097 fastCert10_6097=true := by decide +kernel
def fastCert10_6098 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6098 : checkCertificateFast 10 6098 fastCert10_6098=true := by decide +kernel
def fastCert10_6099 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6099 : checkCertificateFast 10 6099 fastCert10_6099=true := by decide +kernel
def fastCert10_6100 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6100 : checkCertificateFast 10 6100 fastCert10_6100=true := by decide +kernel
def fastCert10_6101 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6101 : checkCertificateFast 10 6101 fastCert10_6101=true := by decide +kernel
def fastCert10_6102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6102 : checkCertificateFast 10 6102 fastCert10_6102=true := by decide +kernel
def fastCert10_6103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6103 : checkCertificateFast 10 6103 fastCert10_6103=true := by decide +kernel
def fastCert10_6104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6104 : checkCertificateFast 10 6104 fastCert10_6104=true := by decide +kernel
def fastCert10_6105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6105 : checkCertificateFast 10 6105 fastCert10_6105=true := by decide +kernel
def fastCert10_6106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6106 : checkCertificateFast 10 6106 fastCert10_6106=true := by decide +kernel
def fastCert10_6107 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6107 : checkCertificateFast 10 6107 fastCert10_6107=true := by decide +kernel
def fastCert10_6108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6108 : checkCertificateFast 10 6108 fastCert10_6108=true := by decide +kernel
def fastCert10_6109 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6109 : checkCertificateFast 10 6109 fastCert10_6109=true := by decide +kernel
def fastCert10_6110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6110 : checkCertificateFast 10 6110 fastCert10_6110=true := by decide +kernel
def fastCert10_6111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6111 : checkCertificateFast 10 6111 fastCert10_6111=true := by decide +kernel
def fastCert10_6112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6112 : checkCertificateFast 10 6112 fastCert10_6112=true := by decide +kernel
def fastCert10_6113 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6113 : checkCertificateFast 10 6113 fastCert10_6113=true := by decide +kernel
def fastCert10_6114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6114 : checkCertificateFast 10 6114 fastCert10_6114=true := by decide +kernel
def fastCert10_6115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6115 : checkCertificateFast 10 6115 fastCert10_6115=true := by decide +kernel
def fastCert10_6116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6116 : checkCertificateFast 10 6116 fastCert10_6116=true := by decide +kernel
def fastCert10_6117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6117 : checkCertificateFast 10 6117 fastCert10_6117=true := by decide +kernel
def fastCert10_6118 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6118 : checkCertificateFast 10 6118 fastCert10_6118=true := by decide +kernel
def fastCert10_6119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6119 : checkCertificateFast 10 6119 fastCert10_6119=true := by decide +kernel
def fastCert10_6120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6120 : checkCertificateFast 10 6120 fastCert10_6120=true := by decide +kernel
def fastCert10_6121 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6121 : checkCertificateFast 10 6121 fastCert10_6121=true := by decide +kernel
def fastCert10_6122 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6122 : checkCertificateFast 10 6122 fastCert10_6122=true := by decide +kernel
def fastCert10_6123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6123 : checkCertificateFast 10 6123 fastCert10_6123=true := by decide +kernel
def fastCert10_6124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6124 : checkCertificateFast 10 6124 fastCert10_6124=true := by decide +kernel
def fastCert10_6125 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6125 : checkCertificateFast 10 6125 fastCert10_6125=true := by decide +kernel
def fastCert10_6126 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6126 : checkCertificateFast 10 6126 fastCert10_6126=true := by decide +kernel
def fastCert10_6127 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6127 : checkCertificateFast 10 6127 fastCert10_6127=true := by decide +kernel
def fastCert10_6128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6128 : checkCertificateFast 10 6128 fastCert10_6128=true := by decide +kernel
def fastCert10_6129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6129 : checkCertificateFast 10 6129 fastCert10_6129=true := by decide +kernel
def fastCert10_6130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6130 : checkCertificateFast 10 6130 fastCert10_6130=true := by decide +kernel
def fastCert10_6131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6131 : checkCertificateFast 10 6131 fastCert10_6131=true := by decide +kernel
def fastCert10_6132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6132 : checkCertificateFast 10 6132 fastCert10_6132=true := by decide +kernel
def fastCert10_6133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6133 : checkCertificateFast 10 6133 fastCert10_6133=true := by decide +kernel
def fastCert10_6134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6134 : checkCertificateFast 10 6134 fastCert10_6134=true := by decide +kernel
def fastCert10_6135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6135 : checkCertificateFast 10 6135 fastCert10_6135=true := by decide +kernel
def fastCert10_6136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6136 : checkCertificateFast 10 6136 fastCert10_6136=true := by decide +kernel
def fastCert10_6137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6137 : checkCertificateFast 10 6137 fastCert10_6137=true := by decide +kernel
def fastCert10_6138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6138 : checkCertificateFast 10 6138 fastCert10_6138=true := by decide +kernel
def fastCert10_6139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6139 : checkCertificateFast 10 6139 fastCert10_6139=true := by decide +kernel
def fastCert10_6140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6140 : checkCertificateFast 10 6140 fastCert10_6140=true := by decide +kernel
def fastCert10_6141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6141 : checkCertificateFast 10 6141 fastCert10_6141=true := by decide +kernel
def fastCert10_6142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6142 : checkCertificateFast 10 6142 fastCert10_6142=true := by decide +kernel
def fastCert10_6143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6143 : checkCertificateFast 10 6143 fastCert10_6143=true := by decide +kernel
def fastCert10_6144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6144 : checkCertificateFast 10 6144 fastCert10_6144=true := by decide +kernel
def fastCert10_6145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6145 : checkCertificateFast 10 6145 fastCert10_6145=true := by decide +kernel
def fastCert10_6146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6146 : checkCertificateFast 10 6146 fastCert10_6146=true := by decide +kernel
def fastCert10_6147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6147 : checkCertificateFast 10 6147 fastCert10_6147=true := by decide +kernel
def fastCert10_6148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6148 : checkCertificateFast 10 6148 fastCert10_6148=true := by decide +kernel
def fastCert10_6149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6149 : checkCertificateFast 10 6149 fastCert10_6149=true := by decide +kernel
def fastCert10_6150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6150 : checkCertificateFast 10 6150 fastCert10_6150=true := by decide +kernel
def fastCert10_6151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6151 : checkCertificateFast 10 6151 fastCert10_6151=true := by decide +kernel
def fastCert10_6152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6152 : checkCertificateFast 10 6152 fastCert10_6152=true := by decide +kernel
def fastCert10_6153 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6153 : checkCertificateFast 10 6153 fastCert10_6153=true := by decide +kernel
def fastCert10_6154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6154 : checkCertificateFast 10 6154 fastCert10_6154=true := by decide +kernel
def fastCert10_6155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6155 : checkCertificateFast 10 6155 fastCert10_6155=true := by decide +kernel
def fastCert10_6156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6156 : checkCertificateFast 10 6156 fastCert10_6156=true := by decide +kernel
def fastCert10_6157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6157 : checkCertificateFast 10 6157 fastCert10_6157=true := by decide +kernel
def fastCert10_6158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6158 : checkCertificateFast 10 6158 fastCert10_6158=true := by decide +kernel
def fastCert10_6159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6159 : checkCertificateFast 10 6159 fastCert10_6159=true := by decide +kernel
def fastCert10_6160 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6160 : checkCertificateFast 10 6160 fastCert10_6160=true := by decide +kernel
def fastCert10_6161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6161 : checkCertificateFast 10 6161 fastCert10_6161=true := by decide +kernel
def fastCert10_6162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6162 : checkCertificateFast 10 6162 fastCert10_6162=true := by decide +kernel
def fastCert10_6163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6163 : checkCertificateFast 10 6163 fastCert10_6163=true := by decide +kernel
def fastCert10_6164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6164 : checkCertificateFast 10 6164 fastCert10_6164=true := by decide +kernel
def fastCert10_6165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6165 : checkCertificateFast 10 6165 fastCert10_6165=true := by decide +kernel
def fastCert10_6166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6166 : checkCertificateFast 10 6166 fastCert10_6166=true := by decide +kernel
def fastCert10_6167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6167 : checkCertificateFast 10 6167 fastCert10_6167=true := by decide +kernel
def fastCert10_6168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6168 : checkCertificateFast 10 6168 fastCert10_6168=true := by decide +kernel
def fastCert10_6169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6169 : checkCertificateFast 10 6169 fastCert10_6169=true := by decide +kernel
def fastCert10_6170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6170 : checkCertificateFast 10 6170 fastCert10_6170=true := by decide +kernel
def fastCert10_6171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6171 : checkCertificateFast 10 6171 fastCert10_6171=true := by decide +kernel
def fastCert10_6172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6172 : checkCertificateFast 10 6172 fastCert10_6172=true := by decide +kernel
def fastCert10_6173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6173 : checkCertificateFast 10 6173 fastCert10_6173=true := by decide +kernel
def fastCert10_6174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6174 : checkCertificateFast 10 6174 fastCert10_6174=true := by decide +kernel
def fastCert10_6175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6175 : checkCertificateFast 10 6175 fastCert10_6175=true := by decide +kernel
def fastCert10_6176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6176 : checkCertificateFast 10 6176 fastCert10_6176=true := by decide +kernel
def fastCert10_6177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6177 : checkCertificateFast 10 6177 fastCert10_6177=true := by decide +kernel
def fastCert10_6178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6178 : checkCertificateFast 10 6178 fastCert10_6178=true := by decide +kernel
def fastCert10_6179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6179 : checkCertificateFast 10 6179 fastCert10_6179=true := by decide +kernel
def fastCert10_6180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6180 : checkCertificateFast 10 6180 fastCert10_6180=true := by decide +kernel
def fastCert10_6181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6181 : checkCertificateFast 10 6181 fastCert10_6181=true := by decide +kernel
def fastCert10_6182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6182 : checkCertificateFast 10 6182 fastCert10_6182=true := by decide +kernel
def fastCert10_6183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6183 : checkCertificateFast 10 6183 fastCert10_6183=true := by decide +kernel
def fastCert10_6184 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6184 : checkCertificateFast 10 6184 fastCert10_6184=true := by decide +kernel
def fastCert10_6185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6185 : checkCertificateFast 10 6185 fastCert10_6185=true := by decide +kernel
def fastCert10_6186 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (4) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (4) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-4) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6186 : checkCertificateFast 10 6186 fastCert10_6186=true := by decide +kernel
def fastCert10_6187 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6187 : checkCertificateFast 10 6187 fastCert10_6187=true := by decide +kernel
def fastCert10_6188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6188 : checkCertificateFast 10 6188 fastCert10_6188=true := by decide +kernel
def fastCert10_6189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6189 : checkCertificateFast 10 6189 fastCert10_6189=true := by decide +kernel
def fastCert10_6190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6190 : checkCertificateFast 10 6190 fastCert10_6190=true := by decide +kernel
def fastCert10_6191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6191 : checkCertificateFast 10 6191 fastCert10_6191=true := by decide +kernel
def fastCert10_6192 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6192 : checkCertificateFast 10 6192 fastCert10_6192=true := by decide +kernel
def fastCert10_6193 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6193 : checkCertificateFast 10 6193 fastCert10_6193=true := by decide +kernel
def fastCert10_6194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6194 : checkCertificateFast 10 6194 fastCert10_6194=true := by decide +kernel
def fastCert10_6195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6195 : checkCertificateFast 10 6195 fastCert10_6195=true := by decide +kernel
def fastCert10_6196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6196 : checkCertificateFast 10 6196 fastCert10_6196=true := by decide +kernel
def fastCert10_6197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6197 : checkCertificateFast 10 6197 fastCert10_6197=true := by decide +kernel
def fastCert10_6198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6198 : checkCertificateFast 10 6198 fastCert10_6198=true := by decide +kernel
def fastCert10_6199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6199 : checkCertificateFast 10 6199 fastCert10_6199=true := by decide +kernel
def fastCert10_6200 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (4) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-4) else 0⟩
theorem fastCase10_6200 : checkCertificateFast 10 6200 fastCert10_6200=true := by decide +kernel
def fastCert10_6201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6201 : checkCertificateFast 10 6201 fastCert10_6201=true := by decide +kernel
def fastCert10_6202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6202 : checkCertificateFast 10 6202 fastCert10_6202=true := by decide +kernel
def fastCert10_6203 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6203 : checkCertificateFast 10 6203 fastCert10_6203=true := by decide +kernel
def fastCert10_6204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6204 : checkCertificateFast 10 6204 fastCert10_6204=true := by decide +kernel
def fastCert10_6205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6205 : checkCertificateFast 10 6205 fastCert10_6205=true := by decide +kernel
def fastCert10_6206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6206 : checkCertificateFast 10 6206 fastCert10_6206=true := by decide +kernel
def fastCert10_6207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6207 : checkCertificateFast 10 6207 fastCert10_6207=true := by decide +kernel
def fastCert10_6208 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6208 : checkCertificateFast 10 6208 fastCert10_6208=true := by decide +kernel
def fastCert10_6209 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6209 : checkCertificateFast 10 6209 fastCert10_6209=true := by decide +kernel
def fastCert10_6210 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6210 : checkCertificateFast 10 6210 fastCert10_6210=true := by decide +kernel
def fastCert10_6211 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6211 : checkCertificateFast 10 6211 fastCert10_6211=true := by decide +kernel
def fastCert10_6212 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6212 : checkCertificateFast 10 6212 fastCert10_6212=true := by decide +kernel
def fastCert10_6213 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6213 : checkCertificateFast 10 6213 fastCert10_6213=true := by decide +kernel
def fastCert10_6214 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6214 : checkCertificateFast 10 6214 fastCert10_6214=true := by decide +kernel
def fastCert10_6215 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6215 : checkCertificateFast 10 6215 fastCert10_6215=true := by decide +kernel
def fastCert10_6216 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6216 : checkCertificateFast 10 6216 fastCert10_6216=true := by decide +kernel
def fastCert10_6217 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6217 : checkCertificateFast 10 6217 fastCert10_6217=true := by decide +kernel
def fastCert10_6218 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6218 : checkCertificateFast 10 6218 fastCert10_6218=true := by decide +kernel
def fastCert10_6219 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6219 : checkCertificateFast 10 6219 fastCert10_6219=true := by decide +kernel
def fastCert10_6220 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6220 : checkCertificateFast 10 6220 fastCert10_6220=true := by decide +kernel
def fastCert10_6221 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6221 : checkCertificateFast 10 6221 fastCert10_6221=true := by decide +kernel
def fastCert10_6222 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6222 : checkCertificateFast 10 6222 fastCert10_6222=true := by decide +kernel
def fastCert10_6223 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6223 : checkCertificateFast 10 6223 fastCert10_6223=true := by decide +kernel
def fastCert10_6224 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6224 : checkCertificateFast 10 6224 fastCert10_6224=true := by decide +kernel
def fastCert10_6225 : Certificate := ⟨18,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6225 : checkCertificateFast 10 6225 fastCert10_6225=true := by decide +kernel
def fastCert10_6226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6226 : checkCertificateFast 10 6226 fastCert10_6226=true := by decide +kernel
def fastCert10_6227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6227 : checkCertificateFast 10 6227 fastCert10_6227=true := by decide +kernel
def fastCert10_6228 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6228 : checkCertificateFast 10 6228 fastCert10_6228=true := by decide +kernel
def fastCert10_6229 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6229 : checkCertificateFast 10 6229 fastCert10_6229=true := by decide +kernel
def fastCert10_6230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6230 : checkCertificateFast 10 6230 fastCert10_6230=true := by decide +kernel
def fastCert10_6231 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6231 : checkCertificateFast 10 6231 fastCert10_6231=true := by decide +kernel
def fastCert10_6232 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6232 : checkCertificateFast 10 6232 fastCert10_6232=true := by decide +kernel
def fastCert10_6233 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6233 : checkCertificateFast 10 6233 fastCert10_6233=true := by decide +kernel
def fastCert10_6234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6234 : checkCertificateFast 10 6234 fastCert10_6234=true := by decide +kernel
def fastCert10_6235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6235 : checkCertificateFast 10 6235 fastCert10_6235=true := by decide +kernel
def fastCert10_6236 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6236 : checkCertificateFast 10 6236 fastCert10_6236=true := by decide +kernel
def fastCert10_6237 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6237 : checkCertificateFast 10 6237 fastCert10_6237=true := by decide +kernel
def fastCert10_6238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6238 : checkCertificateFast 10 6238 fastCert10_6238=true := by decide +kernel
def fastCert10_6239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6239 : checkCertificateFast 10 6239 fastCert10_6239=true := by decide +kernel
def fastCert10_6240 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6240 : checkCertificateFast 10 6240 fastCert10_6240=true := by decide +kernel
def fastCert10_6241 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6241 : checkCertificateFast 10 6241 fastCert10_6241=true := by decide +kernel
def fastCert10_6242 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6242 : checkCertificateFast 10 6242 fastCert10_6242=true := by decide +kernel
def fastCert10_6243 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6243 : checkCertificateFast 10 6243 fastCert10_6243=true := by decide +kernel
def fastCert10_6244 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6244 : checkCertificateFast 10 6244 fastCert10_6244=true := by decide +kernel
def fastCert10_6245 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6245 : checkCertificateFast 10 6245 fastCert10_6245=true := by decide +kernel
def fastCert10_6246 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6246 : checkCertificateFast 10 6246 fastCert10_6246=true := by decide +kernel
def fastCert10_6247 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6247 : checkCertificateFast 10 6247 fastCert10_6247=true := by decide +kernel
def fastCert10_6248 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6248 : checkCertificateFast 10 6248 fastCert10_6248=true := by decide +kernel
def fastCert10_6249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6249 : checkCertificateFast 10 6249 fastCert10_6249=true := by decide +kernel
def fastCert10_6250 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6250 : checkCertificateFast 10 6250 fastCert10_6250=true := by decide +kernel
def fastCert10_6251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6251 : checkCertificateFast 10 6251 fastCert10_6251=true := by decide +kernel
def fastCert10_6252 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6252 : checkCertificateFast 10 6252 fastCert10_6252=true := by decide +kernel
def fastCert10_6253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6253 : checkCertificateFast 10 6253 fastCert10_6253=true := by decide +kernel
def fastCert10_6254 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6254 : checkCertificateFast 10 6254 fastCert10_6254=true := by decide +kernel
def fastCert10_6255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6255 : checkCertificateFast 10 6255 fastCert10_6255=true := by decide +kernel
def fastCert10_6256 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6256 : checkCertificateFast 10 6256 fastCert10_6256=true := by decide +kernel
def fastCert10_6257 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6257 : checkCertificateFast 10 6257 fastCert10_6257=true := by decide +kernel
def fastCert10_6258 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6258 : checkCertificateFast 10 6258 fastCert10_6258=true := by decide +kernel
def fastCert10_6259 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6259 : checkCertificateFast 10 6259 fastCert10_6259=true := by decide +kernel
def fastCert10_6260 : Certificate := ⟨18,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6260 : checkCertificateFast 10 6260 fastCert10_6260=true := by decide +kernel
def fastCert10_6261 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6261 : checkCertificateFast 10 6261 fastCert10_6261=true := by decide +kernel
def fastCert10_6262 : Certificate := ⟨18,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6262 : checkCertificateFast 10 6262 fastCert10_6262=true := by decide +kernel
def fastCert10_6263 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6263 : checkCertificateFast 10 6263 fastCert10_6263=true := by decide +kernel
def fastCert10_6264 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6264 : checkCertificateFast 10 6264 fastCert10_6264=true := by decide +kernel
def fastCert10_6265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6265 : checkCertificateFast 10 6265 fastCert10_6265=true := by decide +kernel
def fastCert10_6266 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6266 : checkCertificateFast 10 6266 fastCert10_6266=true := by decide +kernel
def fastCert10_6267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6267 : checkCertificateFast 10 6267 fastCert10_6267=true := by decide +kernel
def fastCert10_6268 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6268 : checkCertificateFast 10 6268 fastCert10_6268=true := by decide +kernel
def fastCert10_6269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6269 : checkCertificateFast 10 6269 fastCert10_6269=true := by decide +kernel
def fastCert10_6270 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6270 : checkCertificateFast 10 6270 fastCert10_6270=true := by decide +kernel
def fastCert10_6271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6271 : checkCertificateFast 10 6271 fastCert10_6271=true := by decide +kernel
def fastCert10_6272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6272 : checkCertificateFast 10 6272 fastCert10_6272=true := by decide +kernel
def fastCert10_6273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6273 : checkCertificateFast 10 6273 fastCert10_6273=true := by decide +kernel
def fastCert10_6274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6274 : checkCertificateFast 10 6274 fastCert10_6274=true := by decide +kernel
def fastCert10_6275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6275 : checkCertificateFast 10 6275 fastCert10_6275=true := by decide +kernel
def fastCert10_6276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6276 : checkCertificateFast 10 6276 fastCert10_6276=true := by decide +kernel
def fastCert10_6277 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6277 : checkCertificateFast 10 6277 fastCert10_6277=true := by decide +kernel
def fastCert10_6278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6278 : checkCertificateFast 10 6278 fastCert10_6278=true := by decide +kernel
def fastCert10_6279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6279 : checkCertificateFast 10 6279 fastCert10_6279=true := by decide +kernel
def fastCert10_6280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6280 : checkCertificateFast 10 6280 fastCert10_6280=true := by decide +kernel
def fastCert10_6281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6281 : checkCertificateFast 10 6281 fastCert10_6281=true := by decide +kernel
def fastCert10_6282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6282 : checkCertificateFast 10 6282 fastCert10_6282=true := by decide +kernel
def fastCert10_6283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6283 : checkCertificateFast 10 6283 fastCert10_6283=true := by decide +kernel
def fastCert10_6284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6284 : checkCertificateFast 10 6284 fastCert10_6284=true := by decide +kernel
def fastCert10_6285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6285 : checkCertificateFast 10 6285 fastCert10_6285=true := by decide +kernel
def fastCert10_6286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6286 : checkCertificateFast 10 6286 fastCert10_6286=true := by decide +kernel
def fastCert10_6287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6287 : checkCertificateFast 10 6287 fastCert10_6287=true := by decide +kernel
def fastCert10_6288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6288 : checkCertificateFast 10 6288 fastCert10_6288=true := by decide +kernel
def fastCert10_6289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6289 : checkCertificateFast 10 6289 fastCert10_6289=true := by decide +kernel
def fastCert10_6290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_6290 : checkCertificateFast 10 6290 fastCert10_6290=true := by decide +kernel
def fastCert10_6291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6291 : checkCertificateFast 10 6291 fastCert10_6291=true := by decide +kernel
def fastCert10_6292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6292 : checkCertificateFast 10 6292 fastCert10_6292=true := by decide +kernel
def fastCert10_6293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6293 : checkCertificateFast 10 6293 fastCert10_6293=true := by decide +kernel
def fastCert10_6294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6294 : checkCertificateFast 10 6294 fastCert10_6294=true := by decide +kernel
def fastCert10_6295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6295 : checkCertificateFast 10 6295 fastCert10_6295=true := by decide +kernel
def fastCert10_6296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6296 : checkCertificateFast 10 6296 fastCert10_6296=true := by decide +kernel
def fastCert10_6297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6297 : checkCertificateFast 10 6297 fastCert10_6297=true := by decide +kernel
def fastCert10_6298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6298 : checkCertificateFast 10 6298 fastCert10_6298=true := by decide +kernel
def fastCert10_6299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6299 : checkCertificateFast 10 6299 fastCert10_6299=true := by decide +kernel
def fastCert10_6300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6300 : checkCertificateFast 10 6300 fastCert10_6300=true := by decide +kernel
def fastCert10_6301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6301 : checkCertificateFast 10 6301 fastCert10_6301=true := by decide +kernel
def fastCert10_6302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6302 : checkCertificateFast 10 6302 fastCert10_6302=true := by decide +kernel
def fastCert10_6303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6303 : checkCertificateFast 10 6303 fastCert10_6303=true := by decide +kernel
def fastCert10_6304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6304 : checkCertificateFast 10 6304 fastCert10_6304=true := by decide +kernel
def fastCert10_6305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6305 : checkCertificateFast 10 6305 fastCert10_6305=true := by decide +kernel
def fastCert10_6306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6306 : checkCertificateFast 10 6306 fastCert10_6306=true := by decide +kernel
def fastCert10_6307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6307 : checkCertificateFast 10 6307 fastCert10_6307=true := by decide +kernel
def fastCert10_6308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6308 : checkCertificateFast 10 6308 fastCert10_6308=true := by decide +kernel
def fastCert10_6309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6309 : checkCertificateFast 10 6309 fastCert10_6309=true := by decide +kernel
def fastCert10_6310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6310 : checkCertificateFast 10 6310 fastCert10_6310=true := by decide +kernel
def fastCert10_6311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6311 : checkCertificateFast 10 6311 fastCert10_6311=true := by decide +kernel
def fastCert10_6312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6312 : checkCertificateFast 10 6312 fastCert10_6312=true := by decide +kernel
def fastCert10_6313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6313 : checkCertificateFast 10 6313 fastCert10_6313=true := by decide +kernel
def fastCert10_6314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6314 : checkCertificateFast 10 6314 fastCert10_6314=true := by decide +kernel
def fastCert10_6315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6315 : checkCertificateFast 10 6315 fastCert10_6315=true := by decide +kernel
def fastCert10_6316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6316 : checkCertificateFast 10 6316 fastCert10_6316=true := by decide +kernel
def fastCert10_6317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6317 : checkCertificateFast 10 6317 fastCert10_6317=true := by decide +kernel
def fastCert10_6318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6318 : checkCertificateFast 10 6318 fastCert10_6318=true := by decide +kernel
def fastCert10_6319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6319 : checkCertificateFast 10 6319 fastCert10_6319=true := by decide +kernel
def fastCert10_6320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6320 : checkCertificateFast 10 6320 fastCert10_6320=true := by decide +kernel
def fastCert10_6321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6321 : checkCertificateFast 10 6321 fastCert10_6321=true := by decide +kernel
def fastCert10_6322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6322 : checkCertificateFast 10 6322 fastCert10_6322=true := by decide +kernel
def fastCert10_6323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_6323 : checkCertificateFast 10 6323 fastCert10_6323=true := by decide +kernel
def fastCert10_6324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6324 : checkCertificateFast 10 6324 fastCert10_6324=true := by decide +kernel
def fastCert10_6325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6325 : checkCertificateFast 10 6325 fastCert10_6325=true := by decide +kernel
def fastCert10_6326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6326 : checkCertificateFast 10 6326 fastCert10_6326=true := by decide +kernel
def fastCert10_6327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6327 : checkCertificateFast 10 6327 fastCert10_6327=true := by decide +kernel
def fastCert10_6328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (6) else if t=0 ∧ i=4 then (10) else if t=0 ∧ i=5 then (14) else if t=0 ∧ i=8 then (-16) else if t=0 ∧ i=9 then (-8) else if t=0 ∧ i=10 then (5) else if t=0 ∧ i=11 then (-11) else if t=0 ∧ i=12 then (-13) else if t=0 ∧ i=15 then (16) else if t=0 ∧ i=16 then (8) else 0⟩
theorem fastCase10_6328 : checkCertificateFast 10 6328 fastCert10_6328=true := by decide +kernel
def fastCert10_6329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6329 : checkCertificateFast 10 6329 fastCert10_6329=true := by decide +kernel
def fastCert10_6330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_6330 : checkCertificateFast 10 6330 fastCert10_6330=true := by decide +kernel
def fastCert10_6331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6331 : checkCertificateFast 10 6331 fastCert10_6331=true := by decide +kernel
def fastCert10_6332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6332 : checkCertificateFast 10 6332 fastCert10_6332=true := by decide +kernel
def fastCert10_6333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6333 : checkCertificateFast 10 6333 fastCert10_6333=true := by decide +kernel
def fastCert10_6334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6334 : checkCertificateFast 10 6334 fastCert10_6334=true := by decide +kernel
def fastCert10_6335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6335 : checkCertificateFast 10 6335 fastCert10_6335=true := by decide +kernel
def fastCert10_6336 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6336 : checkCertificateFast 10 6336 fastCert10_6336=true := by decide +kernel
def fastCert10_6337 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6337 : checkCertificateFast 10 6337 fastCert10_6337=true := by decide +kernel
def fastCert10_6338 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6338 : checkCertificateFast 10 6338 fastCert10_6338=true := by decide +kernel
def fastCert10_6339 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6339 : checkCertificateFast 10 6339 fastCert10_6339=true := by decide +kernel
def fastCert10_6340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6340 : checkCertificateFast 10 6340 fastCert10_6340=true := by decide +kernel
def fastCert10_6341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (8) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-7) else if t=0 ∧ i=11 then (7) else if t=0 ∧ i=13 then (-7) else if t=0 ∧ i=14 then (-4) else if t=0 ∧ i=15 then (4) else 0⟩
theorem fastCase10_6341 : checkCertificateFast 10 6341 fastCert10_6341=true := by decide +kernel
def fastCert10_6342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6342 : checkCertificateFast 10 6342 fastCert10_6342=true := by decide +kernel
def fastCert10_6343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6343 : checkCertificateFast 10 6343 fastCert10_6343=true := by decide +kernel
def fastCert10_6344 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6344 : checkCertificateFast 10 6344 fastCert10_6344=true := by decide +kernel
def fastCert10_6345 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6345 : checkCertificateFast 10 6345 fastCert10_6345=true := by decide +kernel
def fastCert10_6346 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6346 : checkCertificateFast 10 6346 fastCert10_6346=true := by decide +kernel
def fastCert10_6347 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6347 : checkCertificateFast 10 6347 fastCert10_6347=true := by decide +kernel
def fastCert10_6348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6348 : checkCertificateFast 10 6348 fastCert10_6348=true := by decide +kernel
def fastCert10_6349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6349 : checkCertificateFast 10 6349 fastCert10_6349=true := by decide +kernel
def fastCert10_6350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6350 : checkCertificateFast 10 6350 fastCert10_6350=true := by decide +kernel
def fastCert10_6351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6351 : checkCertificateFast 10 6351 fastCert10_6351=true := by decide +kernel
def fastCert10_6352 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6352 : checkCertificateFast 10 6352 fastCert10_6352=true := by decide +kernel
def fastCert10_6353 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6353 : checkCertificateFast 10 6353 fastCert10_6353=true := by decide +kernel
def fastCert10_6354 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6354 : checkCertificateFast 10 6354 fastCert10_6354=true := by decide +kernel
def fastCert10_6355 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6355 : checkCertificateFast 10 6355 fastCert10_6355=true := by decide +kernel
def fastCert10_6356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6356 : checkCertificateFast 10 6356 fastCert10_6356=true := by decide +kernel
def fastCert10_6357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6357 : checkCertificateFast 10 6357 fastCert10_6357=true := by decide +kernel
def fastCert10_6358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6358 : checkCertificateFast 10 6358 fastCert10_6358=true := by decide +kernel
def fastCert10_6359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6359 : checkCertificateFast 10 6359 fastCert10_6359=true := by decide +kernel
def fastCert10_6360 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6360 : checkCertificateFast 10 6360 fastCert10_6360=true := by decide +kernel
def fastCert10_6361 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6361 : checkCertificateFast 10 6361 fastCert10_6361=true := by decide +kernel
def fastCert10_6362 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6362 : checkCertificateFast 10 6362 fastCert10_6362=true := by decide +kernel
def fastCert10_6363 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6363 : checkCertificateFast 10 6363 fastCert10_6363=true := by decide +kernel
def fastCert10_6364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6364 : checkCertificateFast 10 6364 fastCert10_6364=true := by decide +kernel
def fastCert10_6365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6365 : checkCertificateFast 10 6365 fastCert10_6365=true := by decide +kernel
def fastCert10_6366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6366 : checkCertificateFast 10 6366 fastCert10_6366=true := by decide +kernel
def fastCert10_6367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6367 : checkCertificateFast 10 6367 fastCert10_6367=true := by decide +kernel
def fastCert10_6368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6368 : checkCertificateFast 10 6368 fastCert10_6368=true := by decide +kernel
def fastCert10_6369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-4) else if t=0 ∧ i=15 then (4) else 0⟩
theorem fastCase10_6369 : checkCertificateFast 10 6369 fastCert10_6369=true := by decide +kernel
def fastCert10_6370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6370 : checkCertificateFast 10 6370 fastCert10_6370=true := by decide +kernel
def fastCert10_6371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6371 : checkCertificateFast 10 6371 fastCert10_6371=true := by decide +kernel
def fastCert10_6372 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6372 : checkCertificateFast 10 6372 fastCert10_6372=true := by decide +kernel
def fastCert10_6373 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6373 : checkCertificateFast 10 6373 fastCert10_6373=true := by decide +kernel
def fastCert10_6374 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6374 : checkCertificateFast 10 6374 fastCert10_6374=true := by decide +kernel
def fastCert10_6375 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6375 : checkCertificateFast 10 6375 fastCert10_6375=true := by decide +kernel
def fastCert10_6376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6376 : checkCertificateFast 10 6376 fastCert10_6376=true := by decide +kernel
def fastCert10_6377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6377 : checkCertificateFast 10 6377 fastCert10_6377=true := by decide +kernel
def fastCert10_6378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6378 : checkCertificateFast 10 6378 fastCert10_6378=true := by decide +kernel
def fastCert10_6379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6379 : checkCertificateFast 10 6379 fastCert10_6379=true := by decide +kernel
def fastCert10_6380 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6380 : checkCertificateFast 10 6380 fastCert10_6380=true := by decide +kernel
def fastCert10_6381 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6381 : checkCertificateFast 10 6381 fastCert10_6381=true := by decide +kernel
def fastCert10_6382 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6382 : checkCertificateFast 10 6382 fastCert10_6382=true := by decide +kernel
def fastCert10_6383 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6383 : checkCertificateFast 10 6383 fastCert10_6383=true := by decide +kernel
def fastCert10_6384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6384 : checkCertificateFast 10 6384 fastCert10_6384=true := by decide +kernel
def fastCert10_6385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6385 : checkCertificateFast 10 6385 fastCert10_6385=true := by decide +kernel
def fastCert10_6386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6386 : checkCertificateFast 10 6386 fastCert10_6386=true := by decide +kernel
def fastCert10_6387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6387 : checkCertificateFast 10 6387 fastCert10_6387=true := by decide +kernel
def fastCert10_6388 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6388 : checkCertificateFast 10 6388 fastCert10_6388=true := by decide +kernel
def fastCert10_6389 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6389 : checkCertificateFast 10 6389 fastCert10_6389=true := by decide +kernel
def fastCert10_6390 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6390 : checkCertificateFast 10 6390 fastCert10_6390=true := by decide +kernel
def fastCert10_6391 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6391 : checkCertificateFast 10 6391 fastCert10_6391=true := by decide +kernel
def fastCert10_6392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6392 : checkCertificateFast 10 6392 fastCert10_6392=true := by decide +kernel
def fastCert10_6393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6393 : checkCertificateFast 10 6393 fastCert10_6393=true := by decide +kernel
def fastCert10_6394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6394 : checkCertificateFast 10 6394 fastCert10_6394=true := by decide +kernel
def fastCert10_6395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6395 : checkCertificateFast 10 6395 fastCert10_6395=true := by decide +kernel
def fastCert10_6396 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6396 : checkCertificateFast 10 6396 fastCert10_6396=true := by decide +kernel
def fastCert10_6397 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6397 : checkCertificateFast 10 6397 fastCert10_6397=true := by decide +kernel
def fastCert10_6398 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6398 : checkCertificateFast 10 6398 fastCert10_6398=true := by decide +kernel
def fastCert10_6399 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6399 : checkCertificateFast 10 6399 fastCert10_6399=true := by decide +kernel
def fastCert10_6400 : Certificate := ⟨25,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6400 : checkCertificateFast 10 6400 fastCert10_6400=true := by decide +kernel
def fastCert10_6401 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6401 : checkCertificateFast 10 6401 fastCert10_6401=true := by decide +kernel
def fastCert10_6402 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6402 : checkCertificateFast 10 6402 fastCert10_6402=true := by decide +kernel
def fastCert10_6403 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6403 : checkCertificateFast 10 6403 fastCert10_6403=true := by decide +kernel
def fastCert10_6404 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6404 : checkCertificateFast 10 6404 fastCert10_6404=true := by decide +kernel
def fastCert10_6405 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6405 : checkCertificateFast 10 6405 fastCert10_6405=true := by decide +kernel
def fastCert10_6406 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6406 : checkCertificateFast 10 6406 fastCert10_6406=true := by decide +kernel
def fastCert10_6407 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6407 : checkCertificateFast 10 6407 fastCert10_6407=true := by decide +kernel
def fastCert10_6408 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6408 : checkCertificateFast 10 6408 fastCert10_6408=true := by decide +kernel
def fastCert10_6409 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6409 : checkCertificateFast 10 6409 fastCert10_6409=true := by decide +kernel
def fastCert10_6410 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6410 : checkCertificateFast 10 6410 fastCert10_6410=true := by decide +kernel
def fastCert10_6411 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6411 : checkCertificateFast 10 6411 fastCert10_6411=true := by decide +kernel
def fastCert10_6412 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6412 : checkCertificateFast 10 6412 fastCert10_6412=true := by decide +kernel
def fastCert10_6413 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6413 : checkCertificateFast 10 6413 fastCert10_6413=true := by decide +kernel
def fastCert10_6414 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6414 : checkCertificateFast 10 6414 fastCert10_6414=true := by decide +kernel
def fastCert10_6415 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6415 : checkCertificateFast 10 6415 fastCert10_6415=true := by decide +kernel
def fastCert10_6416 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6416 : checkCertificateFast 10 6416 fastCert10_6416=true := by decide +kernel
def fastCert10_6417 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6417 : checkCertificateFast 10 6417 fastCert10_6417=true := by decide +kernel
def fastCert10_6418 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6418 : checkCertificateFast 10 6418 fastCert10_6418=true := by decide +kernel
def fastCert10_6419 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6419 : checkCertificateFast 10 6419 fastCert10_6419=true := by decide +kernel
def fastCert10_6420 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6420 : checkCertificateFast 10 6420 fastCert10_6420=true := by decide +kernel
def fastCert10_6421 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6421 : checkCertificateFast 10 6421 fastCert10_6421=true := by decide +kernel
def fastCert10_6422 : Certificate := ⟨35,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6422 : checkCertificateFast 10 6422 fastCert10_6422=true := by decide +kernel
def fastCert10_6423 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6423 : checkCertificateFast 10 6423 fastCert10_6423=true := by decide +kernel
def fastCert10_6424 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6424 : checkCertificateFast 10 6424 fastCert10_6424=true := by decide +kernel
def fastCert10_6425 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6425 : checkCertificateFast 10 6425 fastCert10_6425=true := by decide +kernel
def fastCert10_6426 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6426 : checkCertificateFast 10 6426 fastCert10_6426=true := by decide +kernel
def fastCert10_6427 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6427 : checkCertificateFast 10 6427 fastCert10_6427=true := by decide +kernel
def fastCert10_6428 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6428 : checkCertificateFast 10 6428 fastCert10_6428=true := by decide +kernel
def fastCert10_6429 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6429 : checkCertificateFast 10 6429 fastCert10_6429=true := by decide +kernel
def fastCert10_6430 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6430 : checkCertificateFast 10 6430 fastCert10_6430=true := by decide +kernel
def fastCert10_6431 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6431 : checkCertificateFast 10 6431 fastCert10_6431=true := by decide +kernel
def fastCert10_6432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6432 : checkCertificateFast 10 6432 fastCert10_6432=true := by decide +kernel
def fastCert10_6433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6433 : checkCertificateFast 10 6433 fastCert10_6433=true := by decide +kernel
def fastCert10_6434 : Certificate := ⟨19,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6434 : checkCertificateFast 10 6434 fastCert10_6434=true := by decide +kernel
def fastCert10_6435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6435 : checkCertificateFast 10 6435 fastCert10_6435=true := by decide +kernel
def fastCert10_6436 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6436 : checkCertificateFast 10 6436 fastCert10_6436=true := by decide +kernel
def fastCert10_6437 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6437 : checkCertificateFast 10 6437 fastCert10_6437=true := by decide +kernel
def fastCert10_6438 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6438 : checkCertificateFast 10 6438 fastCert10_6438=true := by decide +kernel
def fastCert10_6439 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6439 : checkCertificateFast 10 6439 fastCert10_6439=true := by decide +kernel
def fastCert10_6440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6440 : checkCertificateFast 10 6440 fastCert10_6440=true := by decide +kernel
def fastCert10_6441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6441 : checkCertificateFast 10 6441 fastCert10_6441=true := by decide +kernel
def fastCert10_6442 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6442 : checkCertificateFast 10 6442 fastCert10_6442=true := by decide +kernel
def fastCert10_6443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6443 : checkCertificateFast 10 6443 fastCert10_6443=true := by decide +kernel
def fastCert10_6444 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6444 : checkCertificateFast 10 6444 fastCert10_6444=true := by decide +kernel
def fastCert10_6445 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6445 : checkCertificateFast 10 6445 fastCert10_6445=true := by decide +kernel
def fastCert10_6446 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6446 : checkCertificateFast 10 6446 fastCert10_6446=true := by decide +kernel
def fastCert10_6447 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6447 : checkCertificateFast 10 6447 fastCert10_6447=true := by decide +kernel
def fastCert10_6448 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6448 : checkCertificateFast 10 6448 fastCert10_6448=true := by decide +kernel
def fastCert10_6449 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6449 : checkCertificateFast 10 6449 fastCert10_6449=true := by decide +kernel
def fastCert10_6450 : Certificate := ⟨40,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6450 : checkCertificateFast 10 6450 fastCert10_6450=true := by decide +kernel
def fastCert10_6451 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6451 : checkCertificateFast 10 6451 fastCert10_6451=true := by decide +kernel
def fastCert10_6452 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6452 : checkCertificateFast 10 6452 fastCert10_6452=true := by decide +kernel
def fastCert10_6453 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6453 : checkCertificateFast 10 6453 fastCert10_6453=true := by decide +kernel
def fastCert10_6454 : Certificate := ⟨10,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6454 : checkCertificateFast 10 6454 fastCert10_6454=true := by decide +kernel
def fastCert10_6455 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6455 : checkCertificateFast 10 6455 fastCert10_6455=true := by decide +kernel
def fastCert10_6456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6456 : checkCertificateFast 10 6456 fastCert10_6456=true := by decide +kernel
def fastCert10_6457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6457 : checkCertificateFast 10 6457 fastCert10_6457=true := by decide +kernel
def fastCert10_6458 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6458 : checkCertificateFast 10 6458 fastCert10_6458=true := by decide +kernel
def fastCert10_6459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6459 : checkCertificateFast 10 6459 fastCert10_6459=true := by decide +kernel
def fastCert10_6460 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6460 : checkCertificateFast 10 6460 fastCert10_6460=true := by decide +kernel
def fastCert10_6461 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6461 : checkCertificateFast 10 6461 fastCert10_6461=true := by decide +kernel
def fastCert10_6462 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6462 : checkCertificateFast 10 6462 fastCert10_6462=true := by decide +kernel
def fastCert10_6463 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6463 : checkCertificateFast 10 6463 fastCert10_6463=true := by decide +kernel
def fastCert10_6464 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6464 : checkCertificateFast 10 6464 fastCert10_6464=true := by decide +kernel
def fastCert10_6465 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6465 : checkCertificateFast 10 6465 fastCert10_6465=true := by decide +kernel
def fastCert10_6466 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6466 : checkCertificateFast 10 6466 fastCert10_6466=true := by decide +kernel
def fastCert10_6467 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6467 : checkCertificateFast 10 6467 fastCert10_6467=true := by decide +kernel
def fastCert10_6468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6468 : checkCertificateFast 10 6468 fastCert10_6468=true := by decide +kernel
def fastCert10_6469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6469 : checkCertificateFast 10 6469 fastCert10_6469=true := by decide +kernel
def fastCert10_6470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6470 : checkCertificateFast 10 6470 fastCert10_6470=true := by decide +kernel
def fastCert10_6471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6471 : checkCertificateFast 10 6471 fastCert10_6471=true := by decide +kernel
def fastCert10_6472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6472 : checkCertificateFast 10 6472 fastCert10_6472=true := by decide +kernel
def fastCert10_6473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6473 : checkCertificateFast 10 6473 fastCert10_6473=true := by decide +kernel
def fastCert10_6474 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6474 : checkCertificateFast 10 6474 fastCert10_6474=true := by decide +kernel
def fastCert10_6475 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6475 : checkCertificateFast 10 6475 fastCert10_6475=true := by decide +kernel
def fastCert10_6476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6476 : checkCertificateFast 10 6476 fastCert10_6476=true := by decide +kernel
def fastCert10_6477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6477 : checkCertificateFast 10 6477 fastCert10_6477=true := by decide +kernel
def fastCert10_6478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6478 : checkCertificateFast 10 6478 fastCert10_6478=true := by decide +kernel
def fastCert10_6479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6479 : checkCertificateFast 10 6479 fastCert10_6479=true := by decide +kernel
def fastCert10_6480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6480 : checkCertificateFast 10 6480 fastCert10_6480=true := by decide +kernel
def fastCert10_6481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6481 : checkCertificateFast 10 6481 fastCert10_6481=true := by decide +kernel
def fastCert10_6482 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6482 : checkCertificateFast 10 6482 fastCert10_6482=true := by decide +kernel
def fastCert10_6483 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6483 : checkCertificateFast 10 6483 fastCert10_6483=true := by decide +kernel
def fastCert10_6484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6484 : checkCertificateFast 10 6484 fastCert10_6484=true := by decide +kernel
def fastCert10_6485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6485 : checkCertificateFast 10 6485 fastCert10_6485=true := by decide +kernel
def fastCert10_6486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6486 : checkCertificateFast 10 6486 fastCert10_6486=true := by decide +kernel
def fastCert10_6487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6487 : checkCertificateFast 10 6487 fastCert10_6487=true := by decide +kernel
def fastCert10_6488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6488 : checkCertificateFast 10 6488 fastCert10_6488=true := by decide +kernel
def fastCert10_6489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6489 : checkCertificateFast 10 6489 fastCert10_6489=true := by decide +kernel
def fastCert10_6490 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6490 : checkCertificateFast 10 6490 fastCert10_6490=true := by decide +kernel
def fastCert10_6491 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6491 : checkCertificateFast 10 6491 fastCert10_6491=true := by decide +kernel
def fastCert10_6492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6492 : checkCertificateFast 10 6492 fastCert10_6492=true := by decide +kernel
def fastCert10_6493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6493 : checkCertificateFast 10 6493 fastCert10_6493=true := by decide +kernel
def fastCert10_6494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6494 : checkCertificateFast 10 6494 fastCert10_6494=true := by decide +kernel
def fastCert10_6495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6495 : checkCertificateFast 10 6495 fastCert10_6495=true := by decide +kernel
def fastCert10_6496 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6496 : checkCertificateFast 10 6496 fastCert10_6496=true := by decide +kernel
def fastCert10_6497 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6497 : checkCertificateFast 10 6497 fastCert10_6497=true := by decide +kernel
def fastCert10_6498 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6498 : checkCertificateFast 10 6498 fastCert10_6498=true := by decide +kernel
def fastCert10_6499 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6499 : checkCertificateFast 10 6499 fastCert10_6499=true := by decide +kernel
def fastCert10_6500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6500 : checkCertificateFast 10 6500 fastCert10_6500=true := by decide +kernel
def fastCert10_6501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6501 : checkCertificateFast 10 6501 fastCert10_6501=true := by decide +kernel
def fastCert10_6502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (4) else if t=0 ∧ i=15 then (-4) else 0⟩
theorem fastCase10_6502 : checkCertificateFast 10 6502 fastCert10_6502=true := by decide +kernel
def fastCert10_6503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6503 : checkCertificateFast 10 6503 fastCert10_6503=true := by decide +kernel
def fastCert10_6504 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6504 : checkCertificateFast 10 6504 fastCert10_6504=true := by decide +kernel
def fastCert10_6505 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6505 : checkCertificateFast 10 6505 fastCert10_6505=true := by decide +kernel
def fastCert10_6506 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6506 : checkCertificateFast 10 6506 fastCert10_6506=true := by decide +kernel
def fastCert10_6507 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6507 : checkCertificateFast 10 6507 fastCert10_6507=true := by decide +kernel
def fastCert10_6508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6508 : checkCertificateFast 10 6508 fastCert10_6508=true := by decide +kernel
def fastCert10_6509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6509 : checkCertificateFast 10 6509 fastCert10_6509=true := by decide +kernel
def fastCert10_6510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6510 : checkCertificateFast 10 6510 fastCert10_6510=true := by decide +kernel
def fastCert10_6511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6511 : checkCertificateFast 10 6511 fastCert10_6511=true := by decide +kernel
def fastCert10_6512 : Certificate := ⟨41,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6512 : checkCertificateFast 10 6512 fastCert10_6512=true := by decide +kernel
def fastCert10_6513 : Certificate := ⟨8,fun t i => if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6513 : checkCertificateFast 10 6513 fastCert10_6513=true := by decide +kernel
def fastCert10_6514 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6514 : checkCertificateFast 10 6514 fastCert10_6514=true := by decide +kernel
def fastCert10_6515 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6515 : checkCertificateFast 10 6515 fastCert10_6515=true := by decide +kernel
def fastCert10_6516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6516 : checkCertificateFast 10 6516 fastCert10_6516=true := by decide +kernel
def fastCert10_6517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6517 : checkCertificateFast 10 6517 fastCert10_6517=true := by decide +kernel
def fastCert10_6518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6518 : checkCertificateFast 10 6518 fastCert10_6518=true := by decide +kernel
def fastCert10_6519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6519 : checkCertificateFast 10 6519 fastCert10_6519=true := by decide +kernel
def fastCert10_6520 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6520 : checkCertificateFast 10 6520 fastCert10_6520=true := by decide +kernel
def fastCert10_6521 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6521 : checkCertificateFast 10 6521 fastCert10_6521=true := by decide +kernel
def fastCert10_6522 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6522 : checkCertificateFast 10 6522 fastCert10_6522=true := by decide +kernel
def fastCert10_6523 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6523 : checkCertificateFast 10 6523 fastCert10_6523=true := by decide +kernel
def fastCert10_6524 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6524 : checkCertificateFast 10 6524 fastCert10_6524=true := by decide +kernel
def fastCert10_6525 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6525 : checkCertificateFast 10 6525 fastCert10_6525=true := by decide +kernel
def fastCert10_6526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6526 : checkCertificateFast 10 6526 fastCert10_6526=true := by decide +kernel
def fastCert10_6527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6527 : checkCertificateFast 10 6527 fastCert10_6527=true := by decide +kernel
def fastCert10_6528 : Certificate := ⟨25,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6528 : checkCertificateFast 10 6528 fastCert10_6528=true := by decide +kernel
def fastCert10_6529 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6529 : checkCertificateFast 10 6529 fastCert10_6529=true := by decide +kernel
def fastCert10_6530 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6530 : checkCertificateFast 10 6530 fastCert10_6530=true := by decide +kernel
def fastCert10_6531 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6531 : checkCertificateFast 10 6531 fastCert10_6531=true := by decide +kernel
def fastCert10_6532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6532 : checkCertificateFast 10 6532 fastCert10_6532=true := by decide +kernel
def fastCert10_6533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6533 : checkCertificateFast 10 6533 fastCert10_6533=true := by decide +kernel
def fastCert10_6534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6534 : checkCertificateFast 10 6534 fastCert10_6534=true := by decide +kernel
def fastCert10_6535 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6535 : checkCertificateFast 10 6535 fastCert10_6535=true := by decide +kernel
def fastCert10_6536 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6536 : checkCertificateFast 10 6536 fastCert10_6536=true := by decide +kernel
def fastCert10_6537 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6537 : checkCertificateFast 10 6537 fastCert10_6537=true := by decide +kernel
def fastCert10_6538 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6538 : checkCertificateFast 10 6538 fastCert10_6538=true := by decide +kernel
def fastCert10_6539 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6539 : checkCertificateFast 10 6539 fastCert10_6539=true := by decide +kernel
def fastCert10_6540 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6540 : checkCertificateFast 10 6540 fastCert10_6540=true := by decide +kernel
def fastCert10_6541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6541 : checkCertificateFast 10 6541 fastCert10_6541=true := by decide +kernel
def fastCert10_6542 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6542 : checkCertificateFast 10 6542 fastCert10_6542=true := by decide +kernel
def fastCert10_6543 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6543 : checkCertificateFast 10 6543 fastCert10_6543=true := by decide +kernel
def fastCert10_6544 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6544 : checkCertificateFast 10 6544 fastCert10_6544=true := by decide +kernel
def fastCert10_6545 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6545 : checkCertificateFast 10 6545 fastCert10_6545=true := by decide +kernel
def fastCert10_6546 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_6546 : checkCertificateFast 10 6546 fastCert10_6546=true := by decide +kernel
def fastCert10_6547 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6547 : checkCertificateFast 10 6547 fastCert10_6547=true := by decide +kernel
def fastCert10_6548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6548 : checkCertificateFast 10 6548 fastCert10_6548=true := by decide +kernel
def fastCert10_6549 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6549 : checkCertificateFast 10 6549 fastCert10_6549=true := by decide +kernel
def fastCert10_6550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6550 : checkCertificateFast 10 6550 fastCert10_6550=true := by decide +kernel
def fastCert10_6551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6551 : checkCertificateFast 10 6551 fastCert10_6551=true := by decide +kernel
def fastCert10_6552 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6552 : checkCertificateFast 10 6552 fastCert10_6552=true := by decide +kernel
def fastCert10_6553 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6553 : checkCertificateFast 10 6553 fastCert10_6553=true := by decide +kernel
def fastCert10_6554 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6554 : checkCertificateFast 10 6554 fastCert10_6554=true := by decide +kernel
def fastCert10_6555 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6555 : checkCertificateFast 10 6555 fastCert10_6555=true := by decide +kernel
def fastCert10_6556 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6556 : checkCertificateFast 10 6556 fastCert10_6556=true := by decide +kernel
def fastCert10_6557 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6557 : checkCertificateFast 10 6557 fastCert10_6557=true := by decide +kernel
def fastCert10_6558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6558 : checkCertificateFast 10 6558 fastCert10_6558=true := by decide +kernel
def fastCert10_6559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6559 : checkCertificateFast 10 6559 fastCert10_6559=true := by decide +kernel
def fastCert10_6560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6560 : checkCertificateFast 10 6560 fastCert10_6560=true := by decide +kernel
def fastCert10_6561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6561 : checkCertificateFast 10 6561 fastCert10_6561=true := by decide +kernel
def fastCert10_6562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6562 : checkCertificateFast 10 6562 fastCert10_6562=true := by decide +kernel
def fastCert10_6563 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6563 : checkCertificateFast 10 6563 fastCert10_6563=true := by decide +kernel
def fastCert10_6564 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6564 : checkCertificateFast 10 6564 fastCert10_6564=true := by decide +kernel
def fastCert10_6565 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6565 : checkCertificateFast 10 6565 fastCert10_6565=true := by decide +kernel
def fastCert10_6566 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6566 : checkCertificateFast 10 6566 fastCert10_6566=true := by decide +kernel
def fastCert10_6567 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6567 : checkCertificateFast 10 6567 fastCert10_6567=true := by decide +kernel
def fastCert10_6568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6568 : checkCertificateFast 10 6568 fastCert10_6568=true := by decide +kernel
def fastCert10_6569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6569 : checkCertificateFast 10 6569 fastCert10_6569=true := by decide +kernel
def fastCert10_6570 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6570 : checkCertificateFast 10 6570 fastCert10_6570=true := by decide +kernel
def fastCert10_6571 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6571 : checkCertificateFast 10 6571 fastCert10_6571=true := by decide +kernel
def fastCert10_6572 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6572 : checkCertificateFast 10 6572 fastCert10_6572=true := by decide +kernel
def fastCert10_6573 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6573 : checkCertificateFast 10 6573 fastCert10_6573=true := by decide +kernel
def fastCert10_6574 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6574 : checkCertificateFast 10 6574 fastCert10_6574=true := by decide +kernel
def fastCert10_6575 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6575 : checkCertificateFast 10 6575 fastCert10_6575=true := by decide +kernel
def fastCert10_6576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6576 : checkCertificateFast 10 6576 fastCert10_6576=true := by decide +kernel
def fastCert10_6577 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6577 : checkCertificateFast 10 6577 fastCert10_6577=true := by decide +kernel
def fastCert10_6578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6578 : checkCertificateFast 10 6578 fastCert10_6578=true := by decide +kernel
def fastCert10_6579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6579 : checkCertificateFast 10 6579 fastCert10_6579=true := by decide +kernel
def fastCert10_6580 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6580 : checkCertificateFast 10 6580 fastCert10_6580=true := by decide +kernel
def fastCert10_6581 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6581 : checkCertificateFast 10 6581 fastCert10_6581=true := by decide +kernel
def fastCert10_6582 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6582 : checkCertificateFast 10 6582 fastCert10_6582=true := by decide +kernel
def fastCert10_6583 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6583 : checkCertificateFast 10 6583 fastCert10_6583=true := by decide +kernel
def fastCert10_6584 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6584 : checkCertificateFast 10 6584 fastCert10_6584=true := by decide +kernel
def fastCert10_6585 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6585 : checkCertificateFast 10 6585 fastCert10_6585=true := by decide +kernel
def fastCert10_6586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6586 : checkCertificateFast 10 6586 fastCert10_6586=true := by decide +kernel
def fastCert10_6587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6587 : checkCertificateFast 10 6587 fastCert10_6587=true := by decide +kernel
def fastCert10_6588 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6588 : checkCertificateFast 10 6588 fastCert10_6588=true := by decide +kernel
def fastCert10_6589 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6589 : checkCertificateFast 10 6589 fastCert10_6589=true := by decide +kernel
def fastCert10_6590 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6590 : checkCertificateFast 10 6590 fastCert10_6590=true := by decide +kernel
def fastCert10_6591 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6591 : checkCertificateFast 10 6591 fastCert10_6591=true := by decide +kernel
def fastCert10_6592 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6592 : checkCertificateFast 10 6592 fastCert10_6592=true := by decide +kernel
def fastCert10_6593 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6593 : checkCertificateFast 10 6593 fastCert10_6593=true := by decide +kernel
def fastCert10_6594 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6594 : checkCertificateFast 10 6594 fastCert10_6594=true := by decide +kernel
def fastCert10_6595 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6595 : checkCertificateFast 10 6595 fastCert10_6595=true := by decide +kernel
def fastCert10_6596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6596 : checkCertificateFast 10 6596 fastCert10_6596=true := by decide +kernel
def fastCert10_6597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6597 : checkCertificateFast 10 6597 fastCert10_6597=true := by decide +kernel
def fastCert10_6598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6598 : checkCertificateFast 10 6598 fastCert10_6598=true := by decide +kernel
def fastCert10_6599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6599 : checkCertificateFast 10 6599 fastCert10_6599=true := by decide +kernel
def fastCert10_6600 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6600 : checkCertificateFast 10 6600 fastCert10_6600=true := by decide +kernel
def fastCert10_6601 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6601 : checkCertificateFast 10 6601 fastCert10_6601=true := by decide +kernel
def fastCert10_6602 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6602 : checkCertificateFast 10 6602 fastCert10_6602=true := by decide +kernel
def fastCert10_6603 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6603 : checkCertificateFast 10 6603 fastCert10_6603=true := by decide +kernel
def fastCert10_6604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (4) else if t=0 ∧ i=8 then (-4) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-3) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6604 : checkCertificateFast 10 6604 fastCert10_6604=true := by decide +kernel
def fastCert10_6605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6605 : checkCertificateFast 10 6605 fastCert10_6605=true := by decide +kernel
def fastCert10_6606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6606 : checkCertificateFast 10 6606 fastCert10_6606=true := by decide +kernel
def fastCert10_6607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6607 : checkCertificateFast 10 6607 fastCert10_6607=true := by decide +kernel
def fastCert10_6608 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6608 : checkCertificateFast 10 6608 fastCert10_6608=true := by decide +kernel
def fastCert10_6609 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6609 : checkCertificateFast 10 6609 fastCert10_6609=true := by decide +kernel
def fastCert10_6610 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6610 : checkCertificateFast 10 6610 fastCert10_6610=true := by decide +kernel
def fastCert10_6611 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6611 : checkCertificateFast 10 6611 fastCert10_6611=true := by decide +kernel
def fastCert10_6612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6612 : checkCertificateFast 10 6612 fastCert10_6612=true := by decide +kernel
def fastCert10_6613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6613 : checkCertificateFast 10 6613 fastCert10_6613=true := by decide +kernel
def fastCert10_6614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6614 : checkCertificateFast 10 6614 fastCert10_6614=true := by decide +kernel
def fastCert10_6615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6615 : checkCertificateFast 10 6615 fastCert10_6615=true := by decide +kernel
def fastCert10_6616 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6616 : checkCertificateFast 10 6616 fastCert10_6616=true := by decide +kernel
def fastCert10_6617 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6617 : checkCertificateFast 10 6617 fastCert10_6617=true := by decide +kernel
def fastCert10_6618 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-3) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6618 : checkCertificateFast 10 6618 fastCert10_6618=true := by decide +kernel
def fastCert10_6619 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6619 : checkCertificateFast 10 6619 fastCert10_6619=true := by decide +kernel
def fastCert10_6620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6620 : checkCertificateFast 10 6620 fastCert10_6620=true := by decide +kernel
def fastCert10_6621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6621 : checkCertificateFast 10 6621 fastCert10_6621=true := by decide +kernel
def fastCert10_6622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6622 : checkCertificateFast 10 6622 fastCert10_6622=true := by decide +kernel
def fastCert10_6623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6623 : checkCertificateFast 10 6623 fastCert10_6623=true := by decide +kernel
def fastCert10_6624 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6624 : checkCertificateFast 10 6624 fastCert10_6624=true := by decide +kernel
def fastCert10_6625 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6625 : checkCertificateFast 10 6625 fastCert10_6625=true := by decide +kernel
def fastCert10_6626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6626 : checkCertificateFast 10 6626 fastCert10_6626=true := by decide +kernel
def fastCert10_6627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6627 : checkCertificateFast 10 6627 fastCert10_6627=true := by decide +kernel
def fastCert10_6628 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6628 : checkCertificateFast 10 6628 fastCert10_6628=true := by decide +kernel
def fastCert10_6629 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6629 : checkCertificateFast 10 6629 fastCert10_6629=true := by decide +kernel
def fastCert10_6630 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6630 : checkCertificateFast 10 6630 fastCert10_6630=true := by decide +kernel
def fastCert10_6631 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6631 : checkCertificateFast 10 6631 fastCert10_6631=true := by decide +kernel
def fastCert10_6632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6632 : checkCertificateFast 10 6632 fastCert10_6632=true := by decide +kernel
def fastCert10_6633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6633 : checkCertificateFast 10 6633 fastCert10_6633=true := by decide +kernel
def fastCert10_6634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6634 : checkCertificateFast 10 6634 fastCert10_6634=true := by decide +kernel
def fastCert10_6635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6635 : checkCertificateFast 10 6635 fastCert10_6635=true := by decide +kernel
def fastCert10_6636 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6636 : checkCertificateFast 10 6636 fastCert10_6636=true := by decide +kernel
def fastCert10_6637 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6637 : checkCertificateFast 10 6637 fastCert10_6637=true := by decide +kernel
def fastCert10_6638 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6638 : checkCertificateFast 10 6638 fastCert10_6638=true := by decide +kernel
def fastCert10_6639 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6639 : checkCertificateFast 10 6639 fastCert10_6639=true := by decide +kernel
def fastCert10_6640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6640 : checkCertificateFast 10 6640 fastCert10_6640=true := by decide +kernel
def fastCert10_6641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6641 : checkCertificateFast 10 6641 fastCert10_6641=true := by decide +kernel
def fastCert10_6642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6642 : checkCertificateFast 10 6642 fastCert10_6642=true := by decide +kernel
def fastCert10_6643 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6643 : checkCertificateFast 10 6643 fastCert10_6643=true := by decide +kernel
def fastCert10_6644 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6644 : checkCertificateFast 10 6644 fastCert10_6644=true := by decide +kernel
def fastCert10_6645 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6645 : checkCertificateFast 10 6645 fastCert10_6645=true := by decide +kernel
def fastCert10_6646 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_6646 : checkCertificateFast 10 6646 fastCert10_6646=true := by decide +kernel
def fastCert10_6647 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6647 : checkCertificateFast 10 6647 fastCert10_6647=true := by decide +kernel
def fastCert10_6648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6648 : checkCertificateFast 10 6648 fastCert10_6648=true := by decide +kernel
def fastCert10_6649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6649 : checkCertificateFast 10 6649 fastCert10_6649=true := by decide +kernel
def fastCert10_6650 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6650 : checkCertificateFast 10 6650 fastCert10_6650=true := by decide +kernel
def fastCert10_6651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6651 : checkCertificateFast 10 6651 fastCert10_6651=true := by decide +kernel
def fastCert10_6652 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6652 : checkCertificateFast 10 6652 fastCert10_6652=true := by decide +kernel
def fastCert10_6653 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6653 : checkCertificateFast 10 6653 fastCert10_6653=true := by decide +kernel
def fastCert10_6654 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6654 : checkCertificateFast 10 6654 fastCert10_6654=true := by decide +kernel
def fastCert10_6655 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6655 : checkCertificateFast 10 6655 fastCert10_6655=true := by decide +kernel
def fastCert10_6656 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6656 : checkCertificateFast 10 6656 fastCert10_6656=true := by decide +kernel
def fastCert10_6657 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6657 : checkCertificateFast 10 6657 fastCert10_6657=true := by decide +kernel
def fastCert10_6658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6658 : checkCertificateFast 10 6658 fastCert10_6658=true := by decide +kernel
def fastCert10_6659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6659 : checkCertificateFast 10 6659 fastCert10_6659=true := by decide +kernel
def fastCert10_6660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-4) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6660 : checkCertificateFast 10 6660 fastCert10_6660=true := by decide +kernel
def fastCert10_6661 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6661 : checkCertificateFast 10 6661 fastCert10_6661=true := by decide +kernel
def fastCert10_6662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6662 : checkCertificateFast 10 6662 fastCert10_6662=true := by decide +kernel
def fastCert10_6663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6663 : checkCertificateFast 10 6663 fastCert10_6663=true := by decide +kernel
def fastCert10_6664 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6664 : checkCertificateFast 10 6664 fastCert10_6664=true := by decide +kernel
def fastCert10_6665 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6665 : checkCertificateFast 10 6665 fastCert10_6665=true := by decide +kernel
def fastCert10_6666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6666 : checkCertificateFast 10 6666 fastCert10_6666=true := by decide +kernel
def fastCert10_6667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6667 : checkCertificateFast 10 6667 fastCert10_6667=true := by decide +kernel
def fastCert10_6668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6668 : checkCertificateFast 10 6668 fastCert10_6668=true := by decide +kernel
def fastCert10_6669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6669 : checkCertificateFast 10 6669 fastCert10_6669=true := by decide +kernel
def fastCert10_6670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6670 : checkCertificateFast 10 6670 fastCert10_6670=true := by decide +kernel
def fastCert10_6671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6671 : checkCertificateFast 10 6671 fastCert10_6671=true := by decide +kernel
def fastCert10_6672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6672 : checkCertificateFast 10 6672 fastCert10_6672=true := by decide +kernel
def fastCert10_6673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6673 : checkCertificateFast 10 6673 fastCert10_6673=true := by decide +kernel
def fastCert10_6674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6674 : checkCertificateFast 10 6674 fastCert10_6674=true := by decide +kernel
def fastCert10_6675 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6675 : checkCertificateFast 10 6675 fastCert10_6675=true := by decide +kernel
def fastCert10_6676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6676 : checkCertificateFast 10 6676 fastCert10_6676=true := by decide +kernel
def fastCert10_6677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6677 : checkCertificateFast 10 6677 fastCert10_6677=true := by decide +kernel
def fastCert10_6678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6678 : checkCertificateFast 10 6678 fastCert10_6678=true := by decide +kernel
def fastCert10_6679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6679 : checkCertificateFast 10 6679 fastCert10_6679=true := by decide +kernel
def fastCert10_6680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6680 : checkCertificateFast 10 6680 fastCert10_6680=true := by decide +kernel
def fastCert10_6681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6681 : checkCertificateFast 10 6681 fastCert10_6681=true := by decide +kernel
def fastCert10_6682 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6682 : checkCertificateFast 10 6682 fastCert10_6682=true := by decide +kernel
def fastCert10_6683 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6683 : checkCertificateFast 10 6683 fastCert10_6683=true := by decide +kernel
def fastCert10_6684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6684 : checkCertificateFast 10 6684 fastCert10_6684=true := by decide +kernel
def fastCert10_6685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6685 : checkCertificateFast 10 6685 fastCert10_6685=true := by decide +kernel
def fastCert10_6686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6686 : checkCertificateFast 10 6686 fastCert10_6686=true := by decide +kernel
def fastCert10_6687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6687 : checkCertificateFast 10 6687 fastCert10_6687=true := by decide +kernel
def fastCert10_6688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6688 : checkCertificateFast 10 6688 fastCert10_6688=true := by decide +kernel
def fastCert10_6689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6689 : checkCertificateFast 10 6689 fastCert10_6689=true := by decide +kernel
def fastCert10_6690 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6690 : checkCertificateFast 10 6690 fastCert10_6690=true := by decide +kernel
def fastCert10_6691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6691 : checkCertificateFast 10 6691 fastCert10_6691=true := by decide +kernel
def fastCert10_6692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6692 : checkCertificateFast 10 6692 fastCert10_6692=true := by decide +kernel
def fastCert10_6693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6693 : checkCertificateFast 10 6693 fastCert10_6693=true := by decide +kernel
def fastCert10_6694 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6694 : checkCertificateFast 10 6694 fastCert10_6694=true := by decide +kernel
def fastCert10_6695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6695 : checkCertificateFast 10 6695 fastCert10_6695=true := by decide +kernel
def fastCert10_6696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6696 : checkCertificateFast 10 6696 fastCert10_6696=true := by decide +kernel
def fastCert10_6697 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6697 : checkCertificateFast 10 6697 fastCert10_6697=true := by decide +kernel
def fastCert10_6698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6698 : checkCertificateFast 10 6698 fastCert10_6698=true := by decide +kernel
def fastCert10_6699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6699 : checkCertificateFast 10 6699 fastCert10_6699=true := by decide +kernel
def fastCert10_6700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6700 : checkCertificateFast 10 6700 fastCert10_6700=true := by decide +kernel
def fastCert10_6701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6701 : checkCertificateFast 10 6701 fastCert10_6701=true := by decide +kernel
def fastCert10_6702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6702 : checkCertificateFast 10 6702 fastCert10_6702=true := by decide +kernel
def fastCert10_6703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6703 : checkCertificateFast 10 6703 fastCert10_6703=true := by decide +kernel
def fastCert10_6704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6704 : checkCertificateFast 10 6704 fastCert10_6704=true := by decide +kernel
def fastCert10_6705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6705 : checkCertificateFast 10 6705 fastCert10_6705=true := by decide +kernel
def fastCert10_6706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6706 : checkCertificateFast 10 6706 fastCert10_6706=true := by decide +kernel
def fastCert10_6707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6707 : checkCertificateFast 10 6707 fastCert10_6707=true := by decide +kernel
def fastCert10_6708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6708 : checkCertificateFast 10 6708 fastCert10_6708=true := by decide +kernel
def fastCert10_6709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6709 : checkCertificateFast 10 6709 fastCert10_6709=true := by decide +kernel
def fastCert10_6710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6710 : checkCertificateFast 10 6710 fastCert10_6710=true := by decide +kernel
def fastCert10_6711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6711 : checkCertificateFast 10 6711 fastCert10_6711=true := by decide +kernel
def fastCert10_6712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6712 : checkCertificateFast 10 6712 fastCert10_6712=true := by decide +kernel
def fastCert10_6713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6713 : checkCertificateFast 10 6713 fastCert10_6713=true := by decide +kernel
def fastCert10_6714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6714 : checkCertificateFast 10 6714 fastCert10_6714=true := by decide +kernel
def fastCert10_6715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6715 : checkCertificateFast 10 6715 fastCert10_6715=true := by decide +kernel
def fastCert10_6716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6716 : checkCertificateFast 10 6716 fastCert10_6716=true := by decide +kernel
def fastCert10_6717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6717 : checkCertificateFast 10 6717 fastCert10_6717=true := by decide +kernel
def fastCert10_6718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6718 : checkCertificateFast 10 6718 fastCert10_6718=true := by decide +kernel
def fastCert10_6719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6719 : checkCertificateFast 10 6719 fastCert10_6719=true := by decide +kernel
def fastCert10_6720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6720 : checkCertificateFast 10 6720 fastCert10_6720=true := by decide +kernel
def fastCert10_6721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6721 : checkCertificateFast 10 6721 fastCert10_6721=true := by decide +kernel
def fastCert10_6722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6722 : checkCertificateFast 10 6722 fastCert10_6722=true := by decide +kernel
def fastCert10_6723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6723 : checkCertificateFast 10 6723 fastCert10_6723=true := by decide +kernel
def fastCert10_6724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6724 : checkCertificateFast 10 6724 fastCert10_6724=true := by decide +kernel
def fastCert10_6725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6725 : checkCertificateFast 10 6725 fastCert10_6725=true := by decide +kernel
def fastCert10_6726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6726 : checkCertificateFast 10 6726 fastCert10_6726=true := by decide +kernel
def fastCert10_6727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6727 : checkCertificateFast 10 6727 fastCert10_6727=true := by decide +kernel
def fastCert10_6728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6728 : checkCertificateFast 10 6728 fastCert10_6728=true := by decide +kernel
def fastCert10_6729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6729 : checkCertificateFast 10 6729 fastCert10_6729=true := by decide +kernel
def fastCert10_6730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6730 : checkCertificateFast 10 6730 fastCert10_6730=true := by decide +kernel
def fastCert10_6731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6731 : checkCertificateFast 10 6731 fastCert10_6731=true := by decide +kernel
def fastCert10_6732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6732 : checkCertificateFast 10 6732 fastCert10_6732=true := by decide +kernel
def fastCert10_6733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6733 : checkCertificateFast 10 6733 fastCert10_6733=true := by decide +kernel
def fastCert10_6734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6734 : checkCertificateFast 10 6734 fastCert10_6734=true := by decide +kernel
def fastCert10_6735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6735 : checkCertificateFast 10 6735 fastCert10_6735=true := by decide +kernel
def fastCert10_6736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6736 : checkCertificateFast 10 6736 fastCert10_6736=true := by decide +kernel
def fastCert10_6737 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6737 : checkCertificateFast 10 6737 fastCert10_6737=true := by decide +kernel
def fastCert10_6738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6738 : checkCertificateFast 10 6738 fastCert10_6738=true := by decide +kernel
def fastCert10_6739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6739 : checkCertificateFast 10 6739 fastCert10_6739=true := by decide +kernel
def fastCert10_6740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6740 : checkCertificateFast 10 6740 fastCert10_6740=true := by decide +kernel
def fastCert10_6741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6741 : checkCertificateFast 10 6741 fastCert10_6741=true := by decide +kernel
def fastCert10_6742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6742 : checkCertificateFast 10 6742 fastCert10_6742=true := by decide +kernel
def fastCert10_6743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6743 : checkCertificateFast 10 6743 fastCert10_6743=true := by decide +kernel
def fastCert10_6744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6744 : checkCertificateFast 10 6744 fastCert10_6744=true := by decide +kernel
def fastCert10_6745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6745 : checkCertificateFast 10 6745 fastCert10_6745=true := by decide +kernel
def fastCert10_6746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6746 : checkCertificateFast 10 6746 fastCert10_6746=true := by decide +kernel
def fastCert10_6747 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6747 : checkCertificateFast 10 6747 fastCert10_6747=true := by decide +kernel
def fastCert10_6748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6748 : checkCertificateFast 10 6748 fastCert10_6748=true := by decide +kernel
def fastCert10_6749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6749 : checkCertificateFast 10 6749 fastCert10_6749=true := by decide +kernel
def fastCert10_6750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6750 : checkCertificateFast 10 6750 fastCert10_6750=true := by decide +kernel
def fastCert10_6751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6751 : checkCertificateFast 10 6751 fastCert10_6751=true := by decide +kernel
def fastCert10_6752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6752 : checkCertificateFast 10 6752 fastCert10_6752=true := by decide +kernel
def fastCert10_6753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6753 : checkCertificateFast 10 6753 fastCert10_6753=true := by decide +kernel
def fastCert10_6754 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6754 : checkCertificateFast 10 6754 fastCert10_6754=true := by decide +kernel
def fastCert10_6755 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6755 : checkCertificateFast 10 6755 fastCert10_6755=true := by decide +kernel
def fastCert10_6756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6756 : checkCertificateFast 10 6756 fastCert10_6756=true := by decide +kernel
def fastCert10_6757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6757 : checkCertificateFast 10 6757 fastCert10_6757=true := by decide +kernel
def fastCert10_6758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6758 : checkCertificateFast 10 6758 fastCert10_6758=true := by decide +kernel
def fastCert10_6759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6759 : checkCertificateFast 10 6759 fastCert10_6759=true := by decide +kernel
def fastCert10_6760 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6760 : checkCertificateFast 10 6760 fastCert10_6760=true := by decide +kernel
def fastCert10_6761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6761 : checkCertificateFast 10 6761 fastCert10_6761=true := by decide +kernel
def fastCert10_6762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6762 : checkCertificateFast 10 6762 fastCert10_6762=true := by decide +kernel
def fastCert10_6763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6763 : checkCertificateFast 10 6763 fastCert10_6763=true := by decide +kernel
def fastCert10_6764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6764 : checkCertificateFast 10 6764 fastCert10_6764=true := by decide +kernel
def fastCert10_6765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6765 : checkCertificateFast 10 6765 fastCert10_6765=true := by decide +kernel
def fastCert10_6766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6766 : checkCertificateFast 10 6766 fastCert10_6766=true := by decide +kernel
def fastCert10_6767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6767 : checkCertificateFast 10 6767 fastCert10_6767=true := by decide +kernel
def fastCert10_6768 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6768 : checkCertificateFast 10 6768 fastCert10_6768=true := by decide +kernel
def fastCert10_6769 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6769 : checkCertificateFast 10 6769 fastCert10_6769=true := by decide +kernel
def fastCert10_6770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6770 : checkCertificateFast 10 6770 fastCert10_6770=true := by decide +kernel
def fastCert10_6771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6771 : checkCertificateFast 10 6771 fastCert10_6771=true := by decide +kernel
def fastCert10_6772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6772 : checkCertificateFast 10 6772 fastCert10_6772=true := by decide +kernel
def fastCert10_6773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6773 : checkCertificateFast 10 6773 fastCert10_6773=true := by decide +kernel
def fastCert10_6774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6774 : checkCertificateFast 10 6774 fastCert10_6774=true := by decide +kernel
def fastCert10_6775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6775 : checkCertificateFast 10 6775 fastCert10_6775=true := by decide +kernel
def fastCert10_6776 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6776 : checkCertificateFast 10 6776 fastCert10_6776=true := by decide +kernel
def fastCert10_6777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6777 : checkCertificateFast 10 6777 fastCert10_6777=true := by decide +kernel
def fastCert10_6778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6778 : checkCertificateFast 10 6778 fastCert10_6778=true := by decide +kernel
def fastCert10_6779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6779 : checkCertificateFast 10 6779 fastCert10_6779=true := by decide +kernel
def fastCert10_6780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6780 : checkCertificateFast 10 6780 fastCert10_6780=true := by decide +kernel
def fastCert10_6781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6781 : checkCertificateFast 10 6781 fastCert10_6781=true := by decide +kernel
def fastCert10_6782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6782 : checkCertificateFast 10 6782 fastCert10_6782=true := by decide +kernel
def fastCert10_6783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6783 : checkCertificateFast 10 6783 fastCert10_6783=true := by decide +kernel
def fastCert10_6784 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6784 : checkCertificateFast 10 6784 fastCert10_6784=true := by decide +kernel
def fastCert10_6785 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6785 : checkCertificateFast 10 6785 fastCert10_6785=true := by decide +kernel
def fastCert10_6786 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6786 : checkCertificateFast 10 6786 fastCert10_6786=true := by decide +kernel
def fastCert10_6787 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6787 : checkCertificateFast 10 6787 fastCert10_6787=true := by decide +kernel
def fastCert10_6788 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6788 : checkCertificateFast 10 6788 fastCert10_6788=true := by decide +kernel
def fastCert10_6789 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6789 : checkCertificateFast 10 6789 fastCert10_6789=true := by decide +kernel
def fastCert10_6790 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6790 : checkCertificateFast 10 6790 fastCert10_6790=true := by decide +kernel
def fastCert10_6791 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6791 : checkCertificateFast 10 6791 fastCert10_6791=true := by decide +kernel
def fastCert10_6792 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6792 : checkCertificateFast 10 6792 fastCert10_6792=true := by decide +kernel
def fastCert10_6793 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6793 : checkCertificateFast 10 6793 fastCert10_6793=true := by decide +kernel
def fastCert10_6794 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6794 : checkCertificateFast 10 6794 fastCert10_6794=true := by decide +kernel
def fastCert10_6795 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6795 : checkCertificateFast 10 6795 fastCert10_6795=true := by decide +kernel
def fastCert10_6796 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6796 : checkCertificateFast 10 6796 fastCert10_6796=true := by decide +kernel
def fastCert10_6797 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_6797 : checkCertificateFast 10 6797 fastCert10_6797=true := by decide +kernel
def fastCert10_6798 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6798 : checkCertificateFast 10 6798 fastCert10_6798=true := by decide +kernel
def fastCert10_6799 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6799 : checkCertificateFast 10 6799 fastCert10_6799=true := by decide +kernel
def fastCert10_6800 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6800 : checkCertificateFast 10 6800 fastCert10_6800=true := by decide +kernel
def fastCert10_6801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6801 : checkCertificateFast 10 6801 fastCert10_6801=true := by decide +kernel
def fastCert10_6802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6802 : checkCertificateFast 10 6802 fastCert10_6802=true := by decide +kernel
def fastCert10_6803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6803 : checkCertificateFast 10 6803 fastCert10_6803=true := by decide +kernel
def fastCert10_6804 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6804 : checkCertificateFast 10 6804 fastCert10_6804=true := by decide +kernel
def fastCert10_6805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6805 : checkCertificateFast 10 6805 fastCert10_6805=true := by decide +kernel
def fastCert10_6806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6806 : checkCertificateFast 10 6806 fastCert10_6806=true := by decide +kernel
def fastCert10_6807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6807 : checkCertificateFast 10 6807 fastCert10_6807=true := by decide +kernel
def fastCert10_6808 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6808 : checkCertificateFast 10 6808 fastCert10_6808=true := by decide +kernel
def fastCert10_6809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6809 : checkCertificateFast 10 6809 fastCert10_6809=true := by decide +kernel
def fastCert10_6810 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6810 : checkCertificateFast 10 6810 fastCert10_6810=true := by decide +kernel
def fastCert10_6811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6811 : checkCertificateFast 10 6811 fastCert10_6811=true := by decide +kernel
def fastCert10_6812 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_6812 : checkCertificateFast 10 6812 fastCert10_6812=true := by decide +kernel
def fastCert10_6813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6813 : checkCertificateFast 10 6813 fastCert10_6813=true := by decide +kernel
def fastCert10_6814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6814 : checkCertificateFast 10 6814 fastCert10_6814=true := by decide +kernel
def fastCert10_6815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6815 : checkCertificateFast 10 6815 fastCert10_6815=true := by decide +kernel
def fastCert10_6816 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6816 : checkCertificateFast 10 6816 fastCert10_6816=true := by decide +kernel
def fastCert10_6817 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6817 : checkCertificateFast 10 6817 fastCert10_6817=true := by decide +kernel
def fastCert10_6818 : Certificate := ⟨12,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6818 : checkCertificateFast 10 6818 fastCert10_6818=true := by decide +kernel
def fastCert10_6819 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6819 : checkCertificateFast 10 6819 fastCert10_6819=true := by decide +kernel
def fastCert10_6820 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6820 : checkCertificateFast 10 6820 fastCert10_6820=true := by decide +kernel
def fastCert10_6821 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6821 : checkCertificateFast 10 6821 fastCert10_6821=true := by decide +kernel
def fastCert10_6822 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6822 : checkCertificateFast 10 6822 fastCert10_6822=true := by decide +kernel
def fastCert10_6823 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6823 : checkCertificateFast 10 6823 fastCert10_6823=true := by decide +kernel
def fastCert10_6824 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6824 : checkCertificateFast 10 6824 fastCert10_6824=true := by decide +kernel
def fastCert10_6825 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6825 : checkCertificateFast 10 6825 fastCert10_6825=true := by decide +kernel
def fastCert10_6826 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6826 : checkCertificateFast 10 6826 fastCert10_6826=true := by decide +kernel
def fastCert10_6827 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6827 : checkCertificateFast 10 6827 fastCert10_6827=true := by decide +kernel
def fastCert10_6828 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6828 : checkCertificateFast 10 6828 fastCert10_6828=true := by decide +kernel
def fastCert10_6829 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6829 : checkCertificateFast 10 6829 fastCert10_6829=true := by decide +kernel
def fastCert10_6830 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6830 : checkCertificateFast 10 6830 fastCert10_6830=true := by decide +kernel
def fastCert10_6831 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6831 : checkCertificateFast 10 6831 fastCert10_6831=true := by decide +kernel
def fastCert10_6832 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6832 : checkCertificateFast 10 6832 fastCert10_6832=true := by decide +kernel
def fastCert10_6833 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6833 : checkCertificateFast 10 6833 fastCert10_6833=true := by decide +kernel
def fastCert10_6834 : Certificate := ⟨7,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6834 : checkCertificateFast 10 6834 fastCert10_6834=true := by decide +kernel
def fastCert10_6835 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6835 : checkCertificateFast 10 6835 fastCert10_6835=true := by decide +kernel
def fastCert10_6836 : Certificate := ⟨7,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6836 : checkCertificateFast 10 6836 fastCert10_6836=true := by decide +kernel
def fastCert10_6837 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6837 : checkCertificateFast 10 6837 fastCert10_6837=true := by decide +kernel
def fastCert10_6838 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6838 : checkCertificateFast 10 6838 fastCert10_6838=true := by decide +kernel
def fastCert10_6839 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6839 : checkCertificateFast 10 6839 fastCert10_6839=true := by decide +kernel
def fastCert10_6840 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6840 : checkCertificateFast 10 6840 fastCert10_6840=true := by decide +kernel
def fastCert10_6841 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-3) else 0⟩
theorem fastCase10_6841 : checkCertificateFast 10 6841 fastCert10_6841=true := by decide +kernel
def fastCert10_6842 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6842 : checkCertificateFast 10 6842 fastCert10_6842=true := by decide +kernel
def fastCert10_6843 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6843 : checkCertificateFast 10 6843 fastCert10_6843=true := by decide +kernel
def fastCert10_6844 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_6844 : checkCertificateFast 10 6844 fastCert10_6844=true := by decide +kernel
def fastCert10_6845 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6845 : checkCertificateFast 10 6845 fastCert10_6845=true := by decide +kernel
def fastCert10_6846 : Certificate := ⟨37,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6846 : checkCertificateFast 10 6846 fastCert10_6846=true := by decide +kernel
def fastCert10_6847 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6847 : checkCertificateFast 10 6847 fastCert10_6847=true := by decide +kernel
def fastCert10_6848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_6848 : checkCertificateFast 10 6848 fastCert10_6848=true := by decide +kernel
def fastCert10_6849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6849 : checkCertificateFast 10 6849 fastCert10_6849=true := by decide +kernel
def fastCert10_6850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6850 : checkCertificateFast 10 6850 fastCert10_6850=true := by decide +kernel
def fastCert10_6851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6851 : checkCertificateFast 10 6851 fastCert10_6851=true := by decide +kernel
def fastCert10_6852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6852 : checkCertificateFast 10 6852 fastCert10_6852=true := by decide +kernel
def fastCert10_6853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6853 : checkCertificateFast 10 6853 fastCert10_6853=true := by decide +kernel
def fastCert10_6854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6854 : checkCertificateFast 10 6854 fastCert10_6854=true := by decide +kernel
def fastCert10_6855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6855 : checkCertificateFast 10 6855 fastCert10_6855=true := by decide +kernel
def fastCert10_6856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6856 : checkCertificateFast 10 6856 fastCert10_6856=true := by decide +kernel
def fastCert10_6857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6857 : checkCertificateFast 10 6857 fastCert10_6857=true := by decide +kernel
def fastCert10_6858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6858 : checkCertificateFast 10 6858 fastCert10_6858=true := by decide +kernel
def fastCert10_6859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_6859 : checkCertificateFast 10 6859 fastCert10_6859=true := by decide +kernel
def fastCert10_6860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6860 : checkCertificateFast 10 6860 fastCert10_6860=true := by decide +kernel
def fastCert10_6861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6861 : checkCertificateFast 10 6861 fastCert10_6861=true := by decide +kernel
def fastCert10_6862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6862 : checkCertificateFast 10 6862 fastCert10_6862=true := by decide +kernel
def fastCert10_6863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6863 : checkCertificateFast 10 6863 fastCert10_6863=true := by decide +kernel
def fastCert10_6864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6864 : checkCertificateFast 10 6864 fastCert10_6864=true := by decide +kernel
def fastCert10_6865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6865 : checkCertificateFast 10 6865 fastCert10_6865=true := by decide +kernel
def fastCert10_6866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_6866 : checkCertificateFast 10 6866 fastCert10_6866=true := by decide +kernel
def fastCert10_6867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6867 : checkCertificateFast 10 6867 fastCert10_6867=true := by decide +kernel
def fastCert10_6868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6868 : checkCertificateFast 10 6868 fastCert10_6868=true := by decide +kernel
def fastCert10_6869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6869 : checkCertificateFast 10 6869 fastCert10_6869=true := by decide +kernel
def fastCert10_6870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6870 : checkCertificateFast 10 6870 fastCert10_6870=true := by decide +kernel
def fastCert10_6871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6871 : checkCertificateFast 10 6871 fastCert10_6871=true := by decide +kernel
def fastCert10_6872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6872 : checkCertificateFast 10 6872 fastCert10_6872=true := by decide +kernel
def fastCert10_6873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6873 : checkCertificateFast 10 6873 fastCert10_6873=true := by decide +kernel
def fastCert10_6874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6874 : checkCertificateFast 10 6874 fastCert10_6874=true := by decide +kernel
def fastCert10_6875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_6875 : checkCertificateFast 10 6875 fastCert10_6875=true := by decide +kernel
def fastCert10_6876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6876 : checkCertificateFast 10 6876 fastCert10_6876=true := by decide +kernel
def fastCert10_6877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6877 : checkCertificateFast 10 6877 fastCert10_6877=true := by decide +kernel
def fastCert10_6878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6878 : checkCertificateFast 10 6878 fastCert10_6878=true := by decide +kernel
def fastCert10_6879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6879 : checkCertificateFast 10 6879 fastCert10_6879=true := by decide +kernel
def fastCert10_6880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6880 : checkCertificateFast 10 6880 fastCert10_6880=true := by decide +kernel
def fastCert10_6881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6881 : checkCertificateFast 10 6881 fastCert10_6881=true := by decide +kernel
def fastCert10_6882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6882 : checkCertificateFast 10 6882 fastCert10_6882=true := by decide +kernel
def fastCert10_6883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6883 : checkCertificateFast 10 6883 fastCert10_6883=true := by decide +kernel
def fastCert10_6884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6884 : checkCertificateFast 10 6884 fastCert10_6884=true := by decide +kernel
def fastCert10_6885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6885 : checkCertificateFast 10 6885 fastCert10_6885=true := by decide +kernel
def fastCert10_6886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6886 : checkCertificateFast 10 6886 fastCert10_6886=true := by decide +kernel
def fastCert10_6887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6887 : checkCertificateFast 10 6887 fastCert10_6887=true := by decide +kernel
def fastCert10_6888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6888 : checkCertificateFast 10 6888 fastCert10_6888=true := by decide +kernel
def fastCert10_6889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6889 : checkCertificateFast 10 6889 fastCert10_6889=true := by decide +kernel
def fastCert10_6890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6890 : checkCertificateFast 10 6890 fastCert10_6890=true := by decide +kernel
def fastCert10_6891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_6891 : checkCertificateFast 10 6891 fastCert10_6891=true := by decide +kernel
def fastCert10_6892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6892 : checkCertificateFast 10 6892 fastCert10_6892=true := by decide +kernel
def fastCert10_6893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6893 : checkCertificateFast 10 6893 fastCert10_6893=true := by decide +kernel
def fastCert10_6894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6894 : checkCertificateFast 10 6894 fastCert10_6894=true := by decide +kernel
def fastCert10_6895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6895 : checkCertificateFast 10 6895 fastCert10_6895=true := by decide +kernel
def fastCert10_6896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6896 : checkCertificateFast 10 6896 fastCert10_6896=true := by decide +kernel
def fastCert10_6897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6897 : checkCertificateFast 10 6897 fastCert10_6897=true := by decide +kernel
def fastCert10_6898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_6898 : checkCertificateFast 10 6898 fastCert10_6898=true := by decide +kernel
def fastCert10_6899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_6899 : checkCertificateFast 10 6899 fastCert10_6899=true := by decide +kernel
def fastCert10_6900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6900 : checkCertificateFast 10 6900 fastCert10_6900=true := by decide +kernel
def fastCert10_6901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6901 : checkCertificateFast 10 6901 fastCert10_6901=true := by decide +kernel
def fastCert10_6902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6902 : checkCertificateFast 10 6902 fastCert10_6902=true := by decide +kernel
def fastCert10_6903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6903 : checkCertificateFast 10 6903 fastCert10_6903=true := by decide +kernel
def fastCert10_6904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (6) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (-4) else if t=0 ∧ i=8 then (-4) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-7) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (4) else if t=0 ∧ i=15 then (4) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6904 : checkCertificateFast 10 6904 fastCert10_6904=true := by decide +kernel
def fastCert10_6905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_6905 : checkCertificateFast 10 6905 fastCert10_6905=true := by decide +kernel
def fastCert10_6906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_6906 : checkCertificateFast 10 6906 fastCert10_6906=true := by decide +kernel
def fastCert10_6907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6907 : checkCertificateFast 10 6907 fastCert10_6907=true := by decide +kernel
def fastCert10_6908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6908 : checkCertificateFast 10 6908 fastCert10_6908=true := by decide +kernel
def fastCert10_6909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6909 : checkCertificateFast 10 6909 fastCert10_6909=true := by decide +kernel
def fastCert10_6910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6910 : checkCertificateFast 10 6910 fastCert10_6910=true := by decide +kernel
def fastCert10_6911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_6911 : checkCertificateFast 10 6911 fastCert10_6911=true := by decide +kernel
def fastCert10_6912 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6912 : checkCertificateFast 10 6912 fastCert10_6912=true := by decide +kernel
def fastCert10_6913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6913 : checkCertificateFast 10 6913 fastCert10_6913=true := by decide +kernel
def fastCert10_6914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6914 : checkCertificateFast 10 6914 fastCert10_6914=true := by decide +kernel
def fastCert10_6915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6915 : checkCertificateFast 10 6915 fastCert10_6915=true := by decide +kernel
def fastCert10_6916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6916 : checkCertificateFast 10 6916 fastCert10_6916=true := by decide +kernel
def fastCert10_6917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6917 : checkCertificateFast 10 6917 fastCert10_6917=true := by decide +kernel
def fastCert10_6918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6918 : checkCertificateFast 10 6918 fastCert10_6918=true := by decide +kernel
def fastCert10_6919 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6919 : checkCertificateFast 10 6919 fastCert10_6919=true := by decide +kernel
def fastCert10_6920 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6920 : checkCertificateFast 10 6920 fastCert10_6920=true := by decide +kernel
def fastCert10_6921 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6921 : checkCertificateFast 10 6921 fastCert10_6921=true := by decide +kernel
def fastCert10_6922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6922 : checkCertificateFast 10 6922 fastCert10_6922=true := by decide +kernel
def fastCert10_6923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6923 : checkCertificateFast 10 6923 fastCert10_6923=true := by decide +kernel
def fastCert10_6924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6924 : checkCertificateFast 10 6924 fastCert10_6924=true := by decide +kernel
def fastCert10_6925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6925 : checkCertificateFast 10 6925 fastCert10_6925=true := by decide +kernel
def fastCert10_6926 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6926 : checkCertificateFast 10 6926 fastCert10_6926=true := by decide +kernel
def fastCert10_6927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6927 : checkCertificateFast 10 6927 fastCert10_6927=true := by decide +kernel
def fastCert10_6928 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6928 : checkCertificateFast 10 6928 fastCert10_6928=true := by decide +kernel
def fastCert10_6929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6929 : checkCertificateFast 10 6929 fastCert10_6929=true := by decide +kernel
def fastCert10_6930 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6930 : checkCertificateFast 10 6930 fastCert10_6930=true := by decide +kernel
def fastCert10_6931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6931 : checkCertificateFast 10 6931 fastCert10_6931=true := by decide +kernel
def fastCert10_6932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6932 : checkCertificateFast 10 6932 fastCert10_6932=true := by decide +kernel
def fastCert10_6933 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6933 : checkCertificateFast 10 6933 fastCert10_6933=true := by decide +kernel
def fastCert10_6934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6934 : checkCertificateFast 10 6934 fastCert10_6934=true := by decide +kernel
def fastCert10_6935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6935 : checkCertificateFast 10 6935 fastCert10_6935=true := by decide +kernel
def fastCert10_6936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6936 : checkCertificateFast 10 6936 fastCert10_6936=true := by decide +kernel
def fastCert10_6937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6937 : checkCertificateFast 10 6937 fastCert10_6937=true := by decide +kernel
def fastCert10_6938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6938 : checkCertificateFast 10 6938 fastCert10_6938=true := by decide +kernel
def fastCert10_6939 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6939 : checkCertificateFast 10 6939 fastCert10_6939=true := by decide +kernel
def fastCert10_6940 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6940 : checkCertificateFast 10 6940 fastCert10_6940=true := by decide +kernel
def fastCert10_6941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6941 : checkCertificateFast 10 6941 fastCert10_6941=true := by decide +kernel
def fastCert10_6942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6942 : checkCertificateFast 10 6942 fastCert10_6942=true := by decide +kernel
def fastCert10_6943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6943 : checkCertificateFast 10 6943 fastCert10_6943=true := by decide +kernel
def fastCert10_6944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6944 : checkCertificateFast 10 6944 fastCert10_6944=true := by decide +kernel
def fastCert10_6945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6945 : checkCertificateFast 10 6945 fastCert10_6945=true := by decide +kernel
def fastCert10_6946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6946 : checkCertificateFast 10 6946 fastCert10_6946=true := by decide +kernel
def fastCert10_6947 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6947 : checkCertificateFast 10 6947 fastCert10_6947=true := by decide +kernel
def fastCert10_6948 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6948 : checkCertificateFast 10 6948 fastCert10_6948=true := by decide +kernel
def fastCert10_6949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6949 : checkCertificateFast 10 6949 fastCert10_6949=true := by decide +kernel
def fastCert10_6950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6950 : checkCertificateFast 10 6950 fastCert10_6950=true := by decide +kernel
def fastCert10_6951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6951 : checkCertificateFast 10 6951 fastCert10_6951=true := by decide +kernel
def fastCert10_6952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6952 : checkCertificateFast 10 6952 fastCert10_6952=true := by decide +kernel
def fastCert10_6953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6953 : checkCertificateFast 10 6953 fastCert10_6953=true := by decide +kernel
def fastCert10_6954 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6954 : checkCertificateFast 10 6954 fastCert10_6954=true := by decide +kernel
def fastCert10_6955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6955 : checkCertificateFast 10 6955 fastCert10_6955=true := by decide +kernel
def fastCert10_6956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6956 : checkCertificateFast 10 6956 fastCert10_6956=true := by decide +kernel
def fastCert10_6957 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6957 : checkCertificateFast 10 6957 fastCert10_6957=true := by decide +kernel
def fastCert10_6958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6958 : checkCertificateFast 10 6958 fastCert10_6958=true := by decide +kernel
def fastCert10_6959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6959 : checkCertificateFast 10 6959 fastCert10_6959=true := by decide +kernel
def fastCert10_6960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6960 : checkCertificateFast 10 6960 fastCert10_6960=true := by decide +kernel
def fastCert10_6961 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6961 : checkCertificateFast 10 6961 fastCert10_6961=true := by decide +kernel
def fastCert10_6962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6962 : checkCertificateFast 10 6962 fastCert10_6962=true := by decide +kernel
def fastCert10_6963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6963 : checkCertificateFast 10 6963 fastCert10_6963=true := by decide +kernel
def fastCert10_6964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6964 : checkCertificateFast 10 6964 fastCert10_6964=true := by decide +kernel
def fastCert10_6965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6965 : checkCertificateFast 10 6965 fastCert10_6965=true := by decide +kernel
def fastCert10_6966 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_6966 : checkCertificateFast 10 6966 fastCert10_6966=true := by decide +kernel
def fastCert10_6967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6967 : checkCertificateFast 10 6967 fastCert10_6967=true := by decide +kernel
def fastCert10_6968 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6968 : checkCertificateFast 10 6968 fastCert10_6968=true := by decide +kernel
def fastCert10_6969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6969 : checkCertificateFast 10 6969 fastCert10_6969=true := by decide +kernel
def fastCert10_6970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_6970 : checkCertificateFast 10 6970 fastCert10_6970=true := by decide +kernel
def fastCert10_6971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6971 : checkCertificateFast 10 6971 fastCert10_6971=true := by decide +kernel
def fastCert10_6972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6972 : checkCertificateFast 10 6972 fastCert10_6972=true := by decide +kernel
def fastCert10_6973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6973 : checkCertificateFast 10 6973 fastCert10_6973=true := by decide +kernel
def fastCert10_6974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6974 : checkCertificateFast 10 6974 fastCert10_6974=true := by decide +kernel
def fastCert10_6975 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6975 : checkCertificateFast 10 6975 fastCert10_6975=true := by decide +kernel
def fastCert10_6976 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6976 : checkCertificateFast 10 6976 fastCert10_6976=true := by decide +kernel
def fastCert10_6977 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6977 : checkCertificateFast 10 6977 fastCert10_6977=true := by decide +kernel
def fastCert10_6978 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6978 : checkCertificateFast 10 6978 fastCert10_6978=true := by decide +kernel
def fastCert10_6979 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6979 : checkCertificateFast 10 6979 fastCert10_6979=true := by decide +kernel
def fastCert10_6980 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6980 : checkCertificateFast 10 6980 fastCert10_6980=true := by decide +kernel
def fastCert10_6981 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6981 : checkCertificateFast 10 6981 fastCert10_6981=true := by decide +kernel
def fastCert10_6982 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6982 : checkCertificateFast 10 6982 fastCert10_6982=true := by decide +kernel
def fastCert10_6983 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_6983 : checkCertificateFast 10 6983 fastCert10_6983=true := by decide +kernel
def fastCert10_6984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6984 : checkCertificateFast 10 6984 fastCert10_6984=true := by decide +kernel
def fastCert10_6985 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=16 then (4) else 0⟩
theorem fastCase10_6985 : checkCertificateFast 10 6985 fastCert10_6985=true := by decide +kernel
def fastCert10_6986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6986 : checkCertificateFast 10 6986 fastCert10_6986=true := by decide +kernel
def fastCert10_6987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_6987 : checkCertificateFast 10 6987 fastCert10_6987=true := by decide +kernel
def fastCert10_6988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6988 : checkCertificateFast 10 6988 fastCert10_6988=true := by decide +kernel
def fastCert10_6989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_6989 : checkCertificateFast 10 6989 fastCert10_6989=true := by decide +kernel
def fastCert10_6990 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6990 : checkCertificateFast 10 6990 fastCert10_6990=true := by decide +kernel
def fastCert10_6991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6991 : checkCertificateFast 10 6991 fastCert10_6991=true := by decide +kernel
def fastCert10_6992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6992 : checkCertificateFast 10 6992 fastCert10_6992=true := by decide +kernel
def fastCert10_6993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_6993 : checkCertificateFast 10 6993 fastCert10_6993=true := by decide +kernel
def fastCert10_6994 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-3) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-4) else if t=0 ∧ i=16 then (4) else 0⟩
theorem fastCase10_6994 : checkCertificateFast 10 6994 fastCert10_6994=true := by decide +kernel
def fastCert10_6995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_6995 : checkCertificateFast 10 6995 fastCert10_6995=true := by decide +kernel
def fastCert10_6996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_6996 : checkCertificateFast 10 6996 fastCert10_6996=true := by decide +kernel
def fastCert10_6997 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_6997 : checkCertificateFast 10 6997 fastCert10_6997=true := by decide +kernel
def fastCert10_6998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6998 : checkCertificateFast 10 6998 fastCert10_6998=true := by decide +kernel
def fastCert10_6999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_6999 : checkCertificateFast 10 6999 fastCert10_6999=true := by decide +kernel
theorem aggregate_F10_006 : (checkCertificateFast 10 6000 fastCert10_6000=true) ∧ (checkCertificateFast 10 6001 fastCert10_6001=true) ∧ (checkCertificateFast 10 6002 fastCert10_6002=true) ∧ (checkCertificateFast 10 6003 fastCert10_6003=true) ∧ (checkCertificateFast 10 6004 fastCert10_6004=true) ∧ (checkCertificateFast 10 6005 fastCert10_6005=true) ∧ (checkCertificateFast 10 6006 fastCert10_6006=true) ∧ (checkCertificateFast 10 6007 fastCert10_6007=true) ∧ (checkCertificateFast 10 6008 fastCert10_6008=true) ∧ (checkCertificateFast 10 6009 fastCert10_6009=true) ∧ (checkCertificateFast 10 6010 fastCert10_6010=true) ∧ (checkCertificateFast 10 6011 fastCert10_6011=true) ∧ (checkCertificateFast 10 6012 fastCert10_6012=true) ∧ (checkCertificateFast 10 6013 fastCert10_6013=true) ∧ (checkCertificateFast 10 6014 fastCert10_6014=true) ∧ (checkCertificateFast 10 6015 fastCert10_6015=true) ∧ (checkCertificateFast 10 6016 fastCert10_6016=true) ∧ (checkCertificateFast 10 6017 fastCert10_6017=true) ∧ (checkCertificateFast 10 6018 fastCert10_6018=true) ∧ (checkCertificateFast 10 6019 fastCert10_6019=true) ∧ (checkCertificateFast 10 6020 fastCert10_6020=true) ∧ (checkCertificateFast 10 6021 fastCert10_6021=true) ∧ (checkCertificateFast 10 6022 fastCert10_6022=true) ∧ (checkCertificateFast 10 6023 fastCert10_6023=true) ∧ (checkCertificateFast 10 6024 fastCert10_6024=true) ∧ (checkCertificateFast 10 6025 fastCert10_6025=true) ∧ (checkCertificateFast 10 6026 fastCert10_6026=true) ∧ (checkCertificateFast 10 6027 fastCert10_6027=true) ∧ (checkCertificateFast 10 6028 fastCert10_6028=true) ∧ (checkCertificateFast 10 6029 fastCert10_6029=true) ∧ (checkCertificateFast 10 6030 fastCert10_6030=true) ∧ (checkCertificateFast 10 6031 fastCert10_6031=true) ∧ (checkCertificateFast 10 6032 fastCert10_6032=true) ∧ (checkCertificateFast 10 6033 fastCert10_6033=true) ∧ (checkCertificateFast 10 6034 fastCert10_6034=true) ∧ (checkCertificateFast 10 6035 fastCert10_6035=true) ∧ (checkCertificateFast 10 6036 fastCert10_6036=true) ∧ (checkCertificateFast 10 6037 fastCert10_6037=true) ∧ (checkCertificateFast 10 6038 fastCert10_6038=true) ∧ (checkCertificateFast 10 6039 fastCert10_6039=true) ∧ (checkCertificateFast 10 6040 fastCert10_6040=true) ∧ (checkCertificateFast 10 6041 fastCert10_6041=true) ∧ (checkCertificateFast 10 6042 fastCert10_6042=true) ∧ (checkCertificateFast 10 6043 fastCert10_6043=true) ∧ (checkCertificateFast 10 6044 fastCert10_6044=true) ∧ (checkCertificateFast 10 6045 fastCert10_6045=true) ∧ (checkCertificateFast 10 6046 fastCert10_6046=true) ∧ (checkCertificateFast 10 6047 fastCert10_6047=true) ∧ (checkCertificateFast 10 6048 fastCert10_6048=true) ∧ (checkCertificateFast 10 6049 fastCert10_6049=true) ∧ (checkCertificateFast 10 6050 fastCert10_6050=true) ∧ (checkCertificateFast 10 6051 fastCert10_6051=true) ∧ (checkCertificateFast 10 6052 fastCert10_6052=true) ∧ (checkCertificateFast 10 6053 fastCert10_6053=true) ∧ (checkCertificateFast 10 6054 fastCert10_6054=true) ∧ (checkCertificateFast 10 6055 fastCert10_6055=true) ∧ (checkCertificateFast 10 6056 fastCert10_6056=true) ∧ (checkCertificateFast 10 6057 fastCert10_6057=true) ∧ (checkCertificateFast 10 6058 fastCert10_6058=true) ∧ (checkCertificateFast 10 6059 fastCert10_6059=true) ∧ (checkCertificateFast 10 6060 fastCert10_6060=true) ∧ (checkCertificateFast 10 6061 fastCert10_6061=true) ∧ (checkCertificateFast 10 6062 fastCert10_6062=true) ∧ (checkCertificateFast 10 6063 fastCert10_6063=true) ∧ (checkCertificateFast 10 6064 fastCert10_6064=true) ∧ (checkCertificateFast 10 6065 fastCert10_6065=true) ∧ (checkCertificateFast 10 6066 fastCert10_6066=true) ∧ (checkCertificateFast 10 6067 fastCert10_6067=true) ∧ (checkCertificateFast 10 6068 fastCert10_6068=true) ∧ (checkCertificateFast 10 6069 fastCert10_6069=true) ∧ (checkCertificateFast 10 6070 fastCert10_6070=true) ∧ (checkCertificateFast 10 6071 fastCert10_6071=true) ∧ (checkCertificateFast 10 6072 fastCert10_6072=true) ∧ (checkCertificateFast 10 6073 fastCert10_6073=true) ∧ (checkCertificateFast 10 6074 fastCert10_6074=true) ∧ (checkCertificateFast 10 6075 fastCert10_6075=true) ∧ (checkCertificateFast 10 6076 fastCert10_6076=true) ∧ (checkCertificateFast 10 6077 fastCert10_6077=true) ∧ (checkCertificateFast 10 6078 fastCert10_6078=true) ∧ (checkCertificateFast 10 6079 fastCert10_6079=true) ∧ (checkCertificateFast 10 6080 fastCert10_6080=true) ∧ (checkCertificateFast 10 6081 fastCert10_6081=true) ∧ (checkCertificateFast 10 6082 fastCert10_6082=true) ∧ (checkCertificateFast 10 6083 fastCert10_6083=true) ∧ (checkCertificateFast 10 6084 fastCert10_6084=true) ∧ (checkCertificateFast 10 6085 fastCert10_6085=true) ∧ (checkCertificateFast 10 6086 fastCert10_6086=true) ∧ (checkCertificateFast 10 6087 fastCert10_6087=true) ∧ (checkCertificateFast 10 6088 fastCert10_6088=true) ∧ (checkCertificateFast 10 6089 fastCert10_6089=true) ∧ (checkCertificateFast 10 6090 fastCert10_6090=true) ∧ (checkCertificateFast 10 6091 fastCert10_6091=true) ∧ (checkCertificateFast 10 6092 fastCert10_6092=true) ∧ (checkCertificateFast 10 6093 fastCert10_6093=true) ∧ (checkCertificateFast 10 6094 fastCert10_6094=true) ∧ (checkCertificateFast 10 6095 fastCert10_6095=true) ∧ (checkCertificateFast 10 6096 fastCert10_6096=true) ∧ (checkCertificateFast 10 6097 fastCert10_6097=true) ∧ (checkCertificateFast 10 6098 fastCert10_6098=true) ∧ (checkCertificateFast 10 6099 fastCert10_6099=true) ∧ (checkCertificateFast 10 6100 fastCert10_6100=true) ∧ (checkCertificateFast 10 6101 fastCert10_6101=true) ∧ (checkCertificateFast 10 6102 fastCert10_6102=true) ∧ (checkCertificateFast 10 6103 fastCert10_6103=true) ∧ (checkCertificateFast 10 6104 fastCert10_6104=true) ∧ (checkCertificateFast 10 6105 fastCert10_6105=true) ∧ (checkCertificateFast 10 6106 fastCert10_6106=true) ∧ (checkCertificateFast 10 6107 fastCert10_6107=true) ∧ (checkCertificateFast 10 6108 fastCert10_6108=true) ∧ (checkCertificateFast 10 6109 fastCert10_6109=true) ∧ (checkCertificateFast 10 6110 fastCert10_6110=true) ∧ (checkCertificateFast 10 6111 fastCert10_6111=true) ∧ (checkCertificateFast 10 6112 fastCert10_6112=true) ∧ (checkCertificateFast 10 6113 fastCert10_6113=true) ∧ (checkCertificateFast 10 6114 fastCert10_6114=true) ∧ (checkCertificateFast 10 6115 fastCert10_6115=true) ∧ (checkCertificateFast 10 6116 fastCert10_6116=true) ∧ (checkCertificateFast 10 6117 fastCert10_6117=true) ∧ (checkCertificateFast 10 6118 fastCert10_6118=true) ∧ (checkCertificateFast 10 6119 fastCert10_6119=true) ∧ (checkCertificateFast 10 6120 fastCert10_6120=true) ∧ (checkCertificateFast 10 6121 fastCert10_6121=true) ∧ (checkCertificateFast 10 6122 fastCert10_6122=true) ∧ (checkCertificateFast 10 6123 fastCert10_6123=true) ∧ (checkCertificateFast 10 6124 fastCert10_6124=true) ∧ (checkCertificateFast 10 6125 fastCert10_6125=true) ∧ (checkCertificateFast 10 6126 fastCert10_6126=true) ∧ (checkCertificateFast 10 6127 fastCert10_6127=true) ∧ (checkCertificateFast 10 6128 fastCert10_6128=true) ∧ (checkCertificateFast 10 6129 fastCert10_6129=true) ∧ (checkCertificateFast 10 6130 fastCert10_6130=true) ∧ (checkCertificateFast 10 6131 fastCert10_6131=true) ∧ (checkCertificateFast 10 6132 fastCert10_6132=true) ∧ (checkCertificateFast 10 6133 fastCert10_6133=true) ∧ (checkCertificateFast 10 6134 fastCert10_6134=true) ∧ (checkCertificateFast 10 6135 fastCert10_6135=true) ∧ (checkCertificateFast 10 6136 fastCert10_6136=true) ∧ (checkCertificateFast 10 6137 fastCert10_6137=true) ∧ (checkCertificateFast 10 6138 fastCert10_6138=true) ∧ (checkCertificateFast 10 6139 fastCert10_6139=true) ∧ (checkCertificateFast 10 6140 fastCert10_6140=true) ∧ (checkCertificateFast 10 6141 fastCert10_6141=true) ∧ (checkCertificateFast 10 6142 fastCert10_6142=true) ∧ (checkCertificateFast 10 6143 fastCert10_6143=true) ∧ (checkCertificateFast 10 6144 fastCert10_6144=true) ∧ (checkCertificateFast 10 6145 fastCert10_6145=true) ∧ (checkCertificateFast 10 6146 fastCert10_6146=true) ∧ (checkCertificateFast 10 6147 fastCert10_6147=true) ∧ (checkCertificateFast 10 6148 fastCert10_6148=true) ∧ (checkCertificateFast 10 6149 fastCert10_6149=true) ∧ (checkCertificateFast 10 6150 fastCert10_6150=true) ∧ (checkCertificateFast 10 6151 fastCert10_6151=true) ∧ (checkCertificateFast 10 6152 fastCert10_6152=true) ∧ (checkCertificateFast 10 6153 fastCert10_6153=true) ∧ (checkCertificateFast 10 6154 fastCert10_6154=true) ∧ (checkCertificateFast 10 6155 fastCert10_6155=true) ∧ (checkCertificateFast 10 6156 fastCert10_6156=true) ∧ (checkCertificateFast 10 6157 fastCert10_6157=true) ∧ (checkCertificateFast 10 6158 fastCert10_6158=true) ∧ (checkCertificateFast 10 6159 fastCert10_6159=true) ∧ (checkCertificateFast 10 6160 fastCert10_6160=true) ∧ (checkCertificateFast 10 6161 fastCert10_6161=true) ∧ (checkCertificateFast 10 6162 fastCert10_6162=true) ∧ (checkCertificateFast 10 6163 fastCert10_6163=true) ∧ (checkCertificateFast 10 6164 fastCert10_6164=true) ∧ (checkCertificateFast 10 6165 fastCert10_6165=true) ∧ (checkCertificateFast 10 6166 fastCert10_6166=true) ∧ (checkCertificateFast 10 6167 fastCert10_6167=true) ∧ (checkCertificateFast 10 6168 fastCert10_6168=true) ∧ (checkCertificateFast 10 6169 fastCert10_6169=true) ∧ (checkCertificateFast 10 6170 fastCert10_6170=true) ∧ (checkCertificateFast 10 6171 fastCert10_6171=true) ∧ (checkCertificateFast 10 6172 fastCert10_6172=true) ∧ (checkCertificateFast 10 6173 fastCert10_6173=true) ∧ (checkCertificateFast 10 6174 fastCert10_6174=true) ∧ (checkCertificateFast 10 6175 fastCert10_6175=true) ∧ (checkCertificateFast 10 6176 fastCert10_6176=true) ∧ (checkCertificateFast 10 6177 fastCert10_6177=true) ∧ (checkCertificateFast 10 6178 fastCert10_6178=true) ∧ (checkCertificateFast 10 6179 fastCert10_6179=true) ∧ (checkCertificateFast 10 6180 fastCert10_6180=true) ∧ (checkCertificateFast 10 6181 fastCert10_6181=true) ∧ (checkCertificateFast 10 6182 fastCert10_6182=true) ∧ (checkCertificateFast 10 6183 fastCert10_6183=true) ∧ (checkCertificateFast 10 6184 fastCert10_6184=true) ∧ (checkCertificateFast 10 6185 fastCert10_6185=true) ∧ (checkCertificateFast 10 6186 fastCert10_6186=true) ∧ (checkCertificateFast 10 6187 fastCert10_6187=true) ∧ (checkCertificateFast 10 6188 fastCert10_6188=true) ∧ (checkCertificateFast 10 6189 fastCert10_6189=true) ∧ (checkCertificateFast 10 6190 fastCert10_6190=true) ∧ (checkCertificateFast 10 6191 fastCert10_6191=true) ∧ (checkCertificateFast 10 6192 fastCert10_6192=true) ∧ (checkCertificateFast 10 6193 fastCert10_6193=true) ∧ (checkCertificateFast 10 6194 fastCert10_6194=true) ∧ (checkCertificateFast 10 6195 fastCert10_6195=true) ∧ (checkCertificateFast 10 6196 fastCert10_6196=true) ∧ (checkCertificateFast 10 6197 fastCert10_6197=true) ∧ (checkCertificateFast 10 6198 fastCert10_6198=true) ∧ (checkCertificateFast 10 6199 fastCert10_6199=true) ∧ (checkCertificateFast 10 6200 fastCert10_6200=true) ∧ (checkCertificateFast 10 6201 fastCert10_6201=true) ∧ (checkCertificateFast 10 6202 fastCert10_6202=true) ∧ (checkCertificateFast 10 6203 fastCert10_6203=true) ∧ (checkCertificateFast 10 6204 fastCert10_6204=true) ∧ (checkCertificateFast 10 6205 fastCert10_6205=true) ∧ (checkCertificateFast 10 6206 fastCert10_6206=true) ∧ (checkCertificateFast 10 6207 fastCert10_6207=true) ∧ (checkCertificateFast 10 6208 fastCert10_6208=true) ∧ (checkCertificateFast 10 6209 fastCert10_6209=true) ∧ (checkCertificateFast 10 6210 fastCert10_6210=true) ∧ (checkCertificateFast 10 6211 fastCert10_6211=true) ∧ (checkCertificateFast 10 6212 fastCert10_6212=true) ∧ (checkCertificateFast 10 6213 fastCert10_6213=true) ∧ (checkCertificateFast 10 6214 fastCert10_6214=true) ∧ (checkCertificateFast 10 6215 fastCert10_6215=true) ∧ (checkCertificateFast 10 6216 fastCert10_6216=true) ∧ (checkCertificateFast 10 6217 fastCert10_6217=true) ∧ (checkCertificateFast 10 6218 fastCert10_6218=true) ∧ (checkCertificateFast 10 6219 fastCert10_6219=true) ∧ (checkCertificateFast 10 6220 fastCert10_6220=true) ∧ (checkCertificateFast 10 6221 fastCert10_6221=true) ∧ (checkCertificateFast 10 6222 fastCert10_6222=true) ∧ (checkCertificateFast 10 6223 fastCert10_6223=true) ∧ (checkCertificateFast 10 6224 fastCert10_6224=true) ∧ (checkCertificateFast 10 6225 fastCert10_6225=true) ∧ (checkCertificateFast 10 6226 fastCert10_6226=true) ∧ (checkCertificateFast 10 6227 fastCert10_6227=true) ∧ (checkCertificateFast 10 6228 fastCert10_6228=true) ∧ (checkCertificateFast 10 6229 fastCert10_6229=true) ∧ (checkCertificateFast 10 6230 fastCert10_6230=true) ∧ (checkCertificateFast 10 6231 fastCert10_6231=true) ∧ (checkCertificateFast 10 6232 fastCert10_6232=true) ∧ (checkCertificateFast 10 6233 fastCert10_6233=true) ∧ (checkCertificateFast 10 6234 fastCert10_6234=true) ∧ (checkCertificateFast 10 6235 fastCert10_6235=true) ∧ (checkCertificateFast 10 6236 fastCert10_6236=true) ∧ (checkCertificateFast 10 6237 fastCert10_6237=true) ∧ (checkCertificateFast 10 6238 fastCert10_6238=true) ∧ (checkCertificateFast 10 6239 fastCert10_6239=true) ∧ (checkCertificateFast 10 6240 fastCert10_6240=true) ∧ (checkCertificateFast 10 6241 fastCert10_6241=true) ∧ (checkCertificateFast 10 6242 fastCert10_6242=true) ∧ (checkCertificateFast 10 6243 fastCert10_6243=true) ∧ (checkCertificateFast 10 6244 fastCert10_6244=true) ∧ (checkCertificateFast 10 6245 fastCert10_6245=true) ∧ (checkCertificateFast 10 6246 fastCert10_6246=true) ∧ (checkCertificateFast 10 6247 fastCert10_6247=true) ∧ (checkCertificateFast 10 6248 fastCert10_6248=true) ∧ (checkCertificateFast 10 6249 fastCert10_6249=true) ∧ (checkCertificateFast 10 6250 fastCert10_6250=true) ∧ (checkCertificateFast 10 6251 fastCert10_6251=true) ∧ (checkCertificateFast 10 6252 fastCert10_6252=true) ∧ (checkCertificateFast 10 6253 fastCert10_6253=true) ∧ (checkCertificateFast 10 6254 fastCert10_6254=true) ∧ (checkCertificateFast 10 6255 fastCert10_6255=true) ∧ (checkCertificateFast 10 6256 fastCert10_6256=true) ∧ (checkCertificateFast 10 6257 fastCert10_6257=true) ∧ (checkCertificateFast 10 6258 fastCert10_6258=true) ∧ (checkCertificateFast 10 6259 fastCert10_6259=true) ∧ (checkCertificateFast 10 6260 fastCert10_6260=true) ∧ (checkCertificateFast 10 6261 fastCert10_6261=true) ∧ (checkCertificateFast 10 6262 fastCert10_6262=true) ∧ (checkCertificateFast 10 6263 fastCert10_6263=true) ∧ (checkCertificateFast 10 6264 fastCert10_6264=true) ∧ (checkCertificateFast 10 6265 fastCert10_6265=true) ∧ (checkCertificateFast 10 6266 fastCert10_6266=true) ∧ (checkCertificateFast 10 6267 fastCert10_6267=true) ∧ (checkCertificateFast 10 6268 fastCert10_6268=true) ∧ (checkCertificateFast 10 6269 fastCert10_6269=true) ∧ (checkCertificateFast 10 6270 fastCert10_6270=true) ∧ (checkCertificateFast 10 6271 fastCert10_6271=true) ∧ (checkCertificateFast 10 6272 fastCert10_6272=true) ∧ (checkCertificateFast 10 6273 fastCert10_6273=true) ∧ (checkCertificateFast 10 6274 fastCert10_6274=true) ∧ (checkCertificateFast 10 6275 fastCert10_6275=true) ∧ (checkCertificateFast 10 6276 fastCert10_6276=true) ∧ (checkCertificateFast 10 6277 fastCert10_6277=true) ∧ (checkCertificateFast 10 6278 fastCert10_6278=true) ∧ (checkCertificateFast 10 6279 fastCert10_6279=true) ∧ (checkCertificateFast 10 6280 fastCert10_6280=true) ∧ (checkCertificateFast 10 6281 fastCert10_6281=true) ∧ (checkCertificateFast 10 6282 fastCert10_6282=true) ∧ (checkCertificateFast 10 6283 fastCert10_6283=true) ∧ (checkCertificateFast 10 6284 fastCert10_6284=true) ∧ (checkCertificateFast 10 6285 fastCert10_6285=true) ∧ (checkCertificateFast 10 6286 fastCert10_6286=true) ∧ (checkCertificateFast 10 6287 fastCert10_6287=true) ∧ (checkCertificateFast 10 6288 fastCert10_6288=true) ∧ (checkCertificateFast 10 6289 fastCert10_6289=true) ∧ (checkCertificateFast 10 6290 fastCert10_6290=true) ∧ (checkCertificateFast 10 6291 fastCert10_6291=true) ∧ (checkCertificateFast 10 6292 fastCert10_6292=true) ∧ (checkCertificateFast 10 6293 fastCert10_6293=true) ∧ (checkCertificateFast 10 6294 fastCert10_6294=true) ∧ (checkCertificateFast 10 6295 fastCert10_6295=true) ∧ (checkCertificateFast 10 6296 fastCert10_6296=true) ∧ (checkCertificateFast 10 6297 fastCert10_6297=true) ∧ (checkCertificateFast 10 6298 fastCert10_6298=true) ∧ (checkCertificateFast 10 6299 fastCert10_6299=true) ∧ (checkCertificateFast 10 6300 fastCert10_6300=true) ∧ (checkCertificateFast 10 6301 fastCert10_6301=true) ∧ (checkCertificateFast 10 6302 fastCert10_6302=true) ∧ (checkCertificateFast 10 6303 fastCert10_6303=true) ∧ (checkCertificateFast 10 6304 fastCert10_6304=true) ∧ (checkCertificateFast 10 6305 fastCert10_6305=true) ∧ (checkCertificateFast 10 6306 fastCert10_6306=true) ∧ (checkCertificateFast 10 6307 fastCert10_6307=true) ∧ (checkCertificateFast 10 6308 fastCert10_6308=true) ∧ (checkCertificateFast 10 6309 fastCert10_6309=true) ∧ (checkCertificateFast 10 6310 fastCert10_6310=true) ∧ (checkCertificateFast 10 6311 fastCert10_6311=true) ∧ (checkCertificateFast 10 6312 fastCert10_6312=true) ∧ (checkCertificateFast 10 6313 fastCert10_6313=true) ∧ (checkCertificateFast 10 6314 fastCert10_6314=true) ∧ (checkCertificateFast 10 6315 fastCert10_6315=true) ∧ (checkCertificateFast 10 6316 fastCert10_6316=true) ∧ (checkCertificateFast 10 6317 fastCert10_6317=true) ∧ (checkCertificateFast 10 6318 fastCert10_6318=true) ∧ (checkCertificateFast 10 6319 fastCert10_6319=true) ∧ (checkCertificateFast 10 6320 fastCert10_6320=true) ∧ (checkCertificateFast 10 6321 fastCert10_6321=true) ∧ (checkCertificateFast 10 6322 fastCert10_6322=true) ∧ (checkCertificateFast 10 6323 fastCert10_6323=true) ∧ (checkCertificateFast 10 6324 fastCert10_6324=true) ∧ (checkCertificateFast 10 6325 fastCert10_6325=true) ∧ (checkCertificateFast 10 6326 fastCert10_6326=true) ∧ (checkCertificateFast 10 6327 fastCert10_6327=true) ∧ (checkCertificateFast 10 6328 fastCert10_6328=true) ∧ (checkCertificateFast 10 6329 fastCert10_6329=true) ∧ (checkCertificateFast 10 6330 fastCert10_6330=true) ∧ (checkCertificateFast 10 6331 fastCert10_6331=true) ∧ (checkCertificateFast 10 6332 fastCert10_6332=true) ∧ (checkCertificateFast 10 6333 fastCert10_6333=true) ∧ (checkCertificateFast 10 6334 fastCert10_6334=true) ∧ (checkCertificateFast 10 6335 fastCert10_6335=true) ∧ (checkCertificateFast 10 6336 fastCert10_6336=true) ∧ (checkCertificateFast 10 6337 fastCert10_6337=true) ∧ (checkCertificateFast 10 6338 fastCert10_6338=true) ∧ (checkCertificateFast 10 6339 fastCert10_6339=true) ∧ (checkCertificateFast 10 6340 fastCert10_6340=true) ∧ (checkCertificateFast 10 6341 fastCert10_6341=true) ∧ (checkCertificateFast 10 6342 fastCert10_6342=true) ∧ (checkCertificateFast 10 6343 fastCert10_6343=true) ∧ (checkCertificateFast 10 6344 fastCert10_6344=true) ∧ (checkCertificateFast 10 6345 fastCert10_6345=true) ∧ (checkCertificateFast 10 6346 fastCert10_6346=true) ∧ (checkCertificateFast 10 6347 fastCert10_6347=true) ∧ (checkCertificateFast 10 6348 fastCert10_6348=true) ∧ (checkCertificateFast 10 6349 fastCert10_6349=true) ∧ (checkCertificateFast 10 6350 fastCert10_6350=true) ∧ (checkCertificateFast 10 6351 fastCert10_6351=true) ∧ (checkCertificateFast 10 6352 fastCert10_6352=true) ∧ (checkCertificateFast 10 6353 fastCert10_6353=true) ∧ (checkCertificateFast 10 6354 fastCert10_6354=true) ∧ (checkCertificateFast 10 6355 fastCert10_6355=true) ∧ (checkCertificateFast 10 6356 fastCert10_6356=true) ∧ (checkCertificateFast 10 6357 fastCert10_6357=true) ∧ (checkCertificateFast 10 6358 fastCert10_6358=true) ∧ (checkCertificateFast 10 6359 fastCert10_6359=true) ∧ (checkCertificateFast 10 6360 fastCert10_6360=true) ∧ (checkCertificateFast 10 6361 fastCert10_6361=true) ∧ (checkCertificateFast 10 6362 fastCert10_6362=true) ∧ (checkCertificateFast 10 6363 fastCert10_6363=true) ∧ (checkCertificateFast 10 6364 fastCert10_6364=true) ∧ (checkCertificateFast 10 6365 fastCert10_6365=true) ∧ (checkCertificateFast 10 6366 fastCert10_6366=true) ∧ (checkCertificateFast 10 6367 fastCert10_6367=true) ∧ (checkCertificateFast 10 6368 fastCert10_6368=true) ∧ (checkCertificateFast 10 6369 fastCert10_6369=true) ∧ (checkCertificateFast 10 6370 fastCert10_6370=true) ∧ (checkCertificateFast 10 6371 fastCert10_6371=true) ∧ (checkCertificateFast 10 6372 fastCert10_6372=true) ∧ (checkCertificateFast 10 6373 fastCert10_6373=true) ∧ (checkCertificateFast 10 6374 fastCert10_6374=true) ∧ (checkCertificateFast 10 6375 fastCert10_6375=true) ∧ (checkCertificateFast 10 6376 fastCert10_6376=true) ∧ (checkCertificateFast 10 6377 fastCert10_6377=true) ∧ (checkCertificateFast 10 6378 fastCert10_6378=true) ∧ (checkCertificateFast 10 6379 fastCert10_6379=true) ∧ (checkCertificateFast 10 6380 fastCert10_6380=true) ∧ (checkCertificateFast 10 6381 fastCert10_6381=true) ∧ (checkCertificateFast 10 6382 fastCert10_6382=true) ∧ (checkCertificateFast 10 6383 fastCert10_6383=true) ∧ (checkCertificateFast 10 6384 fastCert10_6384=true) ∧ (checkCertificateFast 10 6385 fastCert10_6385=true) ∧ (checkCertificateFast 10 6386 fastCert10_6386=true) ∧ (checkCertificateFast 10 6387 fastCert10_6387=true) ∧ (checkCertificateFast 10 6388 fastCert10_6388=true) ∧ (checkCertificateFast 10 6389 fastCert10_6389=true) ∧ (checkCertificateFast 10 6390 fastCert10_6390=true) ∧ (checkCertificateFast 10 6391 fastCert10_6391=true) ∧ (checkCertificateFast 10 6392 fastCert10_6392=true) ∧ (checkCertificateFast 10 6393 fastCert10_6393=true) ∧ (checkCertificateFast 10 6394 fastCert10_6394=true) ∧ (checkCertificateFast 10 6395 fastCert10_6395=true) ∧ (checkCertificateFast 10 6396 fastCert10_6396=true) ∧ (checkCertificateFast 10 6397 fastCert10_6397=true) ∧ (checkCertificateFast 10 6398 fastCert10_6398=true) ∧ (checkCertificateFast 10 6399 fastCert10_6399=true) ∧ (checkCertificateFast 10 6400 fastCert10_6400=true) ∧ (checkCertificateFast 10 6401 fastCert10_6401=true) ∧ (checkCertificateFast 10 6402 fastCert10_6402=true) ∧ (checkCertificateFast 10 6403 fastCert10_6403=true) ∧ (checkCertificateFast 10 6404 fastCert10_6404=true) ∧ (checkCertificateFast 10 6405 fastCert10_6405=true) ∧ (checkCertificateFast 10 6406 fastCert10_6406=true) ∧ (checkCertificateFast 10 6407 fastCert10_6407=true) ∧ (checkCertificateFast 10 6408 fastCert10_6408=true) ∧ (checkCertificateFast 10 6409 fastCert10_6409=true) ∧ (checkCertificateFast 10 6410 fastCert10_6410=true) ∧ (checkCertificateFast 10 6411 fastCert10_6411=true) ∧ (checkCertificateFast 10 6412 fastCert10_6412=true) ∧ (checkCertificateFast 10 6413 fastCert10_6413=true) ∧ (checkCertificateFast 10 6414 fastCert10_6414=true) ∧ (checkCertificateFast 10 6415 fastCert10_6415=true) ∧ (checkCertificateFast 10 6416 fastCert10_6416=true) ∧ (checkCertificateFast 10 6417 fastCert10_6417=true) ∧ (checkCertificateFast 10 6418 fastCert10_6418=true) ∧ (checkCertificateFast 10 6419 fastCert10_6419=true) ∧ (checkCertificateFast 10 6420 fastCert10_6420=true) ∧ (checkCertificateFast 10 6421 fastCert10_6421=true) ∧ (checkCertificateFast 10 6422 fastCert10_6422=true) ∧ (checkCertificateFast 10 6423 fastCert10_6423=true) ∧ (checkCertificateFast 10 6424 fastCert10_6424=true) ∧ (checkCertificateFast 10 6425 fastCert10_6425=true) ∧ (checkCertificateFast 10 6426 fastCert10_6426=true) ∧ (checkCertificateFast 10 6427 fastCert10_6427=true) ∧ (checkCertificateFast 10 6428 fastCert10_6428=true) ∧ (checkCertificateFast 10 6429 fastCert10_6429=true) ∧ (checkCertificateFast 10 6430 fastCert10_6430=true) ∧ (checkCertificateFast 10 6431 fastCert10_6431=true) ∧ (checkCertificateFast 10 6432 fastCert10_6432=true) ∧ (checkCertificateFast 10 6433 fastCert10_6433=true) ∧ (checkCertificateFast 10 6434 fastCert10_6434=true) ∧ (checkCertificateFast 10 6435 fastCert10_6435=true) ∧ (checkCertificateFast 10 6436 fastCert10_6436=true) ∧ (checkCertificateFast 10 6437 fastCert10_6437=true) ∧ (checkCertificateFast 10 6438 fastCert10_6438=true) ∧ (checkCertificateFast 10 6439 fastCert10_6439=true) ∧ (checkCertificateFast 10 6440 fastCert10_6440=true) ∧ (checkCertificateFast 10 6441 fastCert10_6441=true) ∧ (checkCertificateFast 10 6442 fastCert10_6442=true) ∧ (checkCertificateFast 10 6443 fastCert10_6443=true) ∧ (checkCertificateFast 10 6444 fastCert10_6444=true) ∧ (checkCertificateFast 10 6445 fastCert10_6445=true) ∧ (checkCertificateFast 10 6446 fastCert10_6446=true) ∧ (checkCertificateFast 10 6447 fastCert10_6447=true) ∧ (checkCertificateFast 10 6448 fastCert10_6448=true) ∧ (checkCertificateFast 10 6449 fastCert10_6449=true) ∧ (checkCertificateFast 10 6450 fastCert10_6450=true) ∧ (checkCertificateFast 10 6451 fastCert10_6451=true) ∧ (checkCertificateFast 10 6452 fastCert10_6452=true) ∧ (checkCertificateFast 10 6453 fastCert10_6453=true) ∧ (checkCertificateFast 10 6454 fastCert10_6454=true) ∧ (checkCertificateFast 10 6455 fastCert10_6455=true) ∧ (checkCertificateFast 10 6456 fastCert10_6456=true) ∧ (checkCertificateFast 10 6457 fastCert10_6457=true) ∧ (checkCertificateFast 10 6458 fastCert10_6458=true) ∧ (checkCertificateFast 10 6459 fastCert10_6459=true) ∧ (checkCertificateFast 10 6460 fastCert10_6460=true) ∧ (checkCertificateFast 10 6461 fastCert10_6461=true) ∧ (checkCertificateFast 10 6462 fastCert10_6462=true) ∧ (checkCertificateFast 10 6463 fastCert10_6463=true) ∧ (checkCertificateFast 10 6464 fastCert10_6464=true) ∧ (checkCertificateFast 10 6465 fastCert10_6465=true) ∧ (checkCertificateFast 10 6466 fastCert10_6466=true) ∧ (checkCertificateFast 10 6467 fastCert10_6467=true) ∧ (checkCertificateFast 10 6468 fastCert10_6468=true) ∧ (checkCertificateFast 10 6469 fastCert10_6469=true) ∧ (checkCertificateFast 10 6470 fastCert10_6470=true) ∧ (checkCertificateFast 10 6471 fastCert10_6471=true) ∧ (checkCertificateFast 10 6472 fastCert10_6472=true) ∧ (checkCertificateFast 10 6473 fastCert10_6473=true) ∧ (checkCertificateFast 10 6474 fastCert10_6474=true) ∧ (checkCertificateFast 10 6475 fastCert10_6475=true) ∧ (checkCertificateFast 10 6476 fastCert10_6476=true) ∧ (checkCertificateFast 10 6477 fastCert10_6477=true) ∧ (checkCertificateFast 10 6478 fastCert10_6478=true) ∧ (checkCertificateFast 10 6479 fastCert10_6479=true) ∧ (checkCertificateFast 10 6480 fastCert10_6480=true) ∧ (checkCertificateFast 10 6481 fastCert10_6481=true) ∧ (checkCertificateFast 10 6482 fastCert10_6482=true) ∧ (checkCertificateFast 10 6483 fastCert10_6483=true) ∧ (checkCertificateFast 10 6484 fastCert10_6484=true) ∧ (checkCertificateFast 10 6485 fastCert10_6485=true) ∧ (checkCertificateFast 10 6486 fastCert10_6486=true) ∧ (checkCertificateFast 10 6487 fastCert10_6487=true) ∧ (checkCertificateFast 10 6488 fastCert10_6488=true) ∧ (checkCertificateFast 10 6489 fastCert10_6489=true) ∧ (checkCertificateFast 10 6490 fastCert10_6490=true) ∧ (checkCertificateFast 10 6491 fastCert10_6491=true) ∧ (checkCertificateFast 10 6492 fastCert10_6492=true) ∧ (checkCertificateFast 10 6493 fastCert10_6493=true) ∧ (checkCertificateFast 10 6494 fastCert10_6494=true) ∧ (checkCertificateFast 10 6495 fastCert10_6495=true) ∧ (checkCertificateFast 10 6496 fastCert10_6496=true) ∧ (checkCertificateFast 10 6497 fastCert10_6497=true) ∧ (checkCertificateFast 10 6498 fastCert10_6498=true) ∧ (checkCertificateFast 10 6499 fastCert10_6499=true) ∧ (checkCertificateFast 10 6500 fastCert10_6500=true) ∧ (checkCertificateFast 10 6501 fastCert10_6501=true) ∧ (checkCertificateFast 10 6502 fastCert10_6502=true) ∧ (checkCertificateFast 10 6503 fastCert10_6503=true) ∧ (checkCertificateFast 10 6504 fastCert10_6504=true) ∧ (checkCertificateFast 10 6505 fastCert10_6505=true) ∧ (checkCertificateFast 10 6506 fastCert10_6506=true) ∧ (checkCertificateFast 10 6507 fastCert10_6507=true) ∧ (checkCertificateFast 10 6508 fastCert10_6508=true) ∧ (checkCertificateFast 10 6509 fastCert10_6509=true) ∧ (checkCertificateFast 10 6510 fastCert10_6510=true) ∧ (checkCertificateFast 10 6511 fastCert10_6511=true) ∧ (checkCertificateFast 10 6512 fastCert10_6512=true) ∧ (checkCertificateFast 10 6513 fastCert10_6513=true) ∧ (checkCertificateFast 10 6514 fastCert10_6514=true) ∧ (checkCertificateFast 10 6515 fastCert10_6515=true) ∧ (checkCertificateFast 10 6516 fastCert10_6516=true) ∧ (checkCertificateFast 10 6517 fastCert10_6517=true) ∧ (checkCertificateFast 10 6518 fastCert10_6518=true) ∧ (checkCertificateFast 10 6519 fastCert10_6519=true) ∧ (checkCertificateFast 10 6520 fastCert10_6520=true) ∧ (checkCertificateFast 10 6521 fastCert10_6521=true) ∧ (checkCertificateFast 10 6522 fastCert10_6522=true) ∧ (checkCertificateFast 10 6523 fastCert10_6523=true) ∧ (checkCertificateFast 10 6524 fastCert10_6524=true) ∧ (checkCertificateFast 10 6525 fastCert10_6525=true) ∧ (checkCertificateFast 10 6526 fastCert10_6526=true) ∧ (checkCertificateFast 10 6527 fastCert10_6527=true) ∧ (checkCertificateFast 10 6528 fastCert10_6528=true) ∧ (checkCertificateFast 10 6529 fastCert10_6529=true) ∧ (checkCertificateFast 10 6530 fastCert10_6530=true) ∧ (checkCertificateFast 10 6531 fastCert10_6531=true) ∧ (checkCertificateFast 10 6532 fastCert10_6532=true) ∧ (checkCertificateFast 10 6533 fastCert10_6533=true) ∧ (checkCertificateFast 10 6534 fastCert10_6534=true) ∧ (checkCertificateFast 10 6535 fastCert10_6535=true) ∧ (checkCertificateFast 10 6536 fastCert10_6536=true) ∧ (checkCertificateFast 10 6537 fastCert10_6537=true) ∧ (checkCertificateFast 10 6538 fastCert10_6538=true) ∧ (checkCertificateFast 10 6539 fastCert10_6539=true) ∧ (checkCertificateFast 10 6540 fastCert10_6540=true) ∧ (checkCertificateFast 10 6541 fastCert10_6541=true) ∧ (checkCertificateFast 10 6542 fastCert10_6542=true) ∧ (checkCertificateFast 10 6543 fastCert10_6543=true) ∧ (checkCertificateFast 10 6544 fastCert10_6544=true) ∧ (checkCertificateFast 10 6545 fastCert10_6545=true) ∧ (checkCertificateFast 10 6546 fastCert10_6546=true) ∧ (checkCertificateFast 10 6547 fastCert10_6547=true) ∧ (checkCertificateFast 10 6548 fastCert10_6548=true) ∧ (checkCertificateFast 10 6549 fastCert10_6549=true) ∧ (checkCertificateFast 10 6550 fastCert10_6550=true) ∧ (checkCertificateFast 10 6551 fastCert10_6551=true) ∧ (checkCertificateFast 10 6552 fastCert10_6552=true) ∧ (checkCertificateFast 10 6553 fastCert10_6553=true) ∧ (checkCertificateFast 10 6554 fastCert10_6554=true) ∧ (checkCertificateFast 10 6555 fastCert10_6555=true) ∧ (checkCertificateFast 10 6556 fastCert10_6556=true) ∧ (checkCertificateFast 10 6557 fastCert10_6557=true) ∧ (checkCertificateFast 10 6558 fastCert10_6558=true) ∧ (checkCertificateFast 10 6559 fastCert10_6559=true) ∧ (checkCertificateFast 10 6560 fastCert10_6560=true) ∧ (checkCertificateFast 10 6561 fastCert10_6561=true) ∧ (checkCertificateFast 10 6562 fastCert10_6562=true) ∧ (checkCertificateFast 10 6563 fastCert10_6563=true) ∧ (checkCertificateFast 10 6564 fastCert10_6564=true) ∧ (checkCertificateFast 10 6565 fastCert10_6565=true) ∧ (checkCertificateFast 10 6566 fastCert10_6566=true) ∧ (checkCertificateFast 10 6567 fastCert10_6567=true) ∧ (checkCertificateFast 10 6568 fastCert10_6568=true) ∧ (checkCertificateFast 10 6569 fastCert10_6569=true) ∧ (checkCertificateFast 10 6570 fastCert10_6570=true) ∧ (checkCertificateFast 10 6571 fastCert10_6571=true) ∧ (checkCertificateFast 10 6572 fastCert10_6572=true) ∧ (checkCertificateFast 10 6573 fastCert10_6573=true) ∧ (checkCertificateFast 10 6574 fastCert10_6574=true) ∧ (checkCertificateFast 10 6575 fastCert10_6575=true) ∧ (checkCertificateFast 10 6576 fastCert10_6576=true) ∧ (checkCertificateFast 10 6577 fastCert10_6577=true) ∧ (checkCertificateFast 10 6578 fastCert10_6578=true) ∧ (checkCertificateFast 10 6579 fastCert10_6579=true) ∧ (checkCertificateFast 10 6580 fastCert10_6580=true) ∧ (checkCertificateFast 10 6581 fastCert10_6581=true) ∧ (checkCertificateFast 10 6582 fastCert10_6582=true) ∧ (checkCertificateFast 10 6583 fastCert10_6583=true) ∧ (checkCertificateFast 10 6584 fastCert10_6584=true) ∧ (checkCertificateFast 10 6585 fastCert10_6585=true) ∧ (checkCertificateFast 10 6586 fastCert10_6586=true) ∧ (checkCertificateFast 10 6587 fastCert10_6587=true) ∧ (checkCertificateFast 10 6588 fastCert10_6588=true) ∧ (checkCertificateFast 10 6589 fastCert10_6589=true) ∧ (checkCertificateFast 10 6590 fastCert10_6590=true) ∧ (checkCertificateFast 10 6591 fastCert10_6591=true) ∧ (checkCertificateFast 10 6592 fastCert10_6592=true) ∧ (checkCertificateFast 10 6593 fastCert10_6593=true) ∧ (checkCertificateFast 10 6594 fastCert10_6594=true) ∧ (checkCertificateFast 10 6595 fastCert10_6595=true) ∧ (checkCertificateFast 10 6596 fastCert10_6596=true) ∧ (checkCertificateFast 10 6597 fastCert10_6597=true) ∧ (checkCertificateFast 10 6598 fastCert10_6598=true) ∧ (checkCertificateFast 10 6599 fastCert10_6599=true) ∧ (checkCertificateFast 10 6600 fastCert10_6600=true) ∧ (checkCertificateFast 10 6601 fastCert10_6601=true) ∧ (checkCertificateFast 10 6602 fastCert10_6602=true) ∧ (checkCertificateFast 10 6603 fastCert10_6603=true) ∧ (checkCertificateFast 10 6604 fastCert10_6604=true) ∧ (checkCertificateFast 10 6605 fastCert10_6605=true) ∧ (checkCertificateFast 10 6606 fastCert10_6606=true) ∧ (checkCertificateFast 10 6607 fastCert10_6607=true) ∧ (checkCertificateFast 10 6608 fastCert10_6608=true) ∧ (checkCertificateFast 10 6609 fastCert10_6609=true) ∧ (checkCertificateFast 10 6610 fastCert10_6610=true) ∧ (checkCertificateFast 10 6611 fastCert10_6611=true) ∧ (checkCertificateFast 10 6612 fastCert10_6612=true) ∧ (checkCertificateFast 10 6613 fastCert10_6613=true) ∧ (checkCertificateFast 10 6614 fastCert10_6614=true) ∧ (checkCertificateFast 10 6615 fastCert10_6615=true) ∧ (checkCertificateFast 10 6616 fastCert10_6616=true) ∧ (checkCertificateFast 10 6617 fastCert10_6617=true) ∧ (checkCertificateFast 10 6618 fastCert10_6618=true) ∧ (checkCertificateFast 10 6619 fastCert10_6619=true) ∧ (checkCertificateFast 10 6620 fastCert10_6620=true) ∧ (checkCertificateFast 10 6621 fastCert10_6621=true) ∧ (checkCertificateFast 10 6622 fastCert10_6622=true) ∧ (checkCertificateFast 10 6623 fastCert10_6623=true) ∧ (checkCertificateFast 10 6624 fastCert10_6624=true) ∧ (checkCertificateFast 10 6625 fastCert10_6625=true) ∧ (checkCertificateFast 10 6626 fastCert10_6626=true) ∧ (checkCertificateFast 10 6627 fastCert10_6627=true) ∧ (checkCertificateFast 10 6628 fastCert10_6628=true) ∧ (checkCertificateFast 10 6629 fastCert10_6629=true) ∧ (checkCertificateFast 10 6630 fastCert10_6630=true) ∧ (checkCertificateFast 10 6631 fastCert10_6631=true) ∧ (checkCertificateFast 10 6632 fastCert10_6632=true) ∧ (checkCertificateFast 10 6633 fastCert10_6633=true) ∧ (checkCertificateFast 10 6634 fastCert10_6634=true) ∧ (checkCertificateFast 10 6635 fastCert10_6635=true) ∧ (checkCertificateFast 10 6636 fastCert10_6636=true) ∧ (checkCertificateFast 10 6637 fastCert10_6637=true) ∧ (checkCertificateFast 10 6638 fastCert10_6638=true) ∧ (checkCertificateFast 10 6639 fastCert10_6639=true) ∧ (checkCertificateFast 10 6640 fastCert10_6640=true) ∧ (checkCertificateFast 10 6641 fastCert10_6641=true) ∧ (checkCertificateFast 10 6642 fastCert10_6642=true) ∧ (checkCertificateFast 10 6643 fastCert10_6643=true) ∧ (checkCertificateFast 10 6644 fastCert10_6644=true) ∧ (checkCertificateFast 10 6645 fastCert10_6645=true) ∧ (checkCertificateFast 10 6646 fastCert10_6646=true) ∧ (checkCertificateFast 10 6647 fastCert10_6647=true) ∧ (checkCertificateFast 10 6648 fastCert10_6648=true) ∧ (checkCertificateFast 10 6649 fastCert10_6649=true) ∧ (checkCertificateFast 10 6650 fastCert10_6650=true) ∧ (checkCertificateFast 10 6651 fastCert10_6651=true) ∧ (checkCertificateFast 10 6652 fastCert10_6652=true) ∧ (checkCertificateFast 10 6653 fastCert10_6653=true) ∧ (checkCertificateFast 10 6654 fastCert10_6654=true) ∧ (checkCertificateFast 10 6655 fastCert10_6655=true) ∧ (checkCertificateFast 10 6656 fastCert10_6656=true) ∧ (checkCertificateFast 10 6657 fastCert10_6657=true) ∧ (checkCertificateFast 10 6658 fastCert10_6658=true) ∧ (checkCertificateFast 10 6659 fastCert10_6659=true) ∧ (checkCertificateFast 10 6660 fastCert10_6660=true) ∧ (checkCertificateFast 10 6661 fastCert10_6661=true) ∧ (checkCertificateFast 10 6662 fastCert10_6662=true) ∧ (checkCertificateFast 10 6663 fastCert10_6663=true) ∧ (checkCertificateFast 10 6664 fastCert10_6664=true) ∧ (checkCertificateFast 10 6665 fastCert10_6665=true) ∧ (checkCertificateFast 10 6666 fastCert10_6666=true) ∧ (checkCertificateFast 10 6667 fastCert10_6667=true) ∧ (checkCertificateFast 10 6668 fastCert10_6668=true) ∧ (checkCertificateFast 10 6669 fastCert10_6669=true) ∧ (checkCertificateFast 10 6670 fastCert10_6670=true) ∧ (checkCertificateFast 10 6671 fastCert10_6671=true) ∧ (checkCertificateFast 10 6672 fastCert10_6672=true) ∧ (checkCertificateFast 10 6673 fastCert10_6673=true) ∧ (checkCertificateFast 10 6674 fastCert10_6674=true) ∧ (checkCertificateFast 10 6675 fastCert10_6675=true) ∧ (checkCertificateFast 10 6676 fastCert10_6676=true) ∧ (checkCertificateFast 10 6677 fastCert10_6677=true) ∧ (checkCertificateFast 10 6678 fastCert10_6678=true) ∧ (checkCertificateFast 10 6679 fastCert10_6679=true) ∧ (checkCertificateFast 10 6680 fastCert10_6680=true) ∧ (checkCertificateFast 10 6681 fastCert10_6681=true) ∧ (checkCertificateFast 10 6682 fastCert10_6682=true) ∧ (checkCertificateFast 10 6683 fastCert10_6683=true) ∧ (checkCertificateFast 10 6684 fastCert10_6684=true) ∧ (checkCertificateFast 10 6685 fastCert10_6685=true) ∧ (checkCertificateFast 10 6686 fastCert10_6686=true) ∧ (checkCertificateFast 10 6687 fastCert10_6687=true) ∧ (checkCertificateFast 10 6688 fastCert10_6688=true) ∧ (checkCertificateFast 10 6689 fastCert10_6689=true) ∧ (checkCertificateFast 10 6690 fastCert10_6690=true) ∧ (checkCertificateFast 10 6691 fastCert10_6691=true) ∧ (checkCertificateFast 10 6692 fastCert10_6692=true) ∧ (checkCertificateFast 10 6693 fastCert10_6693=true) ∧ (checkCertificateFast 10 6694 fastCert10_6694=true) ∧ (checkCertificateFast 10 6695 fastCert10_6695=true) ∧ (checkCertificateFast 10 6696 fastCert10_6696=true) ∧ (checkCertificateFast 10 6697 fastCert10_6697=true) ∧ (checkCertificateFast 10 6698 fastCert10_6698=true) ∧ (checkCertificateFast 10 6699 fastCert10_6699=true) ∧ (checkCertificateFast 10 6700 fastCert10_6700=true) ∧ (checkCertificateFast 10 6701 fastCert10_6701=true) ∧ (checkCertificateFast 10 6702 fastCert10_6702=true) ∧ (checkCertificateFast 10 6703 fastCert10_6703=true) ∧ (checkCertificateFast 10 6704 fastCert10_6704=true) ∧ (checkCertificateFast 10 6705 fastCert10_6705=true) ∧ (checkCertificateFast 10 6706 fastCert10_6706=true) ∧ (checkCertificateFast 10 6707 fastCert10_6707=true) ∧ (checkCertificateFast 10 6708 fastCert10_6708=true) ∧ (checkCertificateFast 10 6709 fastCert10_6709=true) ∧ (checkCertificateFast 10 6710 fastCert10_6710=true) ∧ (checkCertificateFast 10 6711 fastCert10_6711=true) ∧ (checkCertificateFast 10 6712 fastCert10_6712=true) ∧ (checkCertificateFast 10 6713 fastCert10_6713=true) ∧ (checkCertificateFast 10 6714 fastCert10_6714=true) ∧ (checkCertificateFast 10 6715 fastCert10_6715=true) ∧ (checkCertificateFast 10 6716 fastCert10_6716=true) ∧ (checkCertificateFast 10 6717 fastCert10_6717=true) ∧ (checkCertificateFast 10 6718 fastCert10_6718=true) ∧ (checkCertificateFast 10 6719 fastCert10_6719=true) ∧ (checkCertificateFast 10 6720 fastCert10_6720=true) ∧ (checkCertificateFast 10 6721 fastCert10_6721=true) ∧ (checkCertificateFast 10 6722 fastCert10_6722=true) ∧ (checkCertificateFast 10 6723 fastCert10_6723=true) ∧ (checkCertificateFast 10 6724 fastCert10_6724=true) ∧ (checkCertificateFast 10 6725 fastCert10_6725=true) ∧ (checkCertificateFast 10 6726 fastCert10_6726=true) ∧ (checkCertificateFast 10 6727 fastCert10_6727=true) ∧ (checkCertificateFast 10 6728 fastCert10_6728=true) ∧ (checkCertificateFast 10 6729 fastCert10_6729=true) ∧ (checkCertificateFast 10 6730 fastCert10_6730=true) ∧ (checkCertificateFast 10 6731 fastCert10_6731=true) ∧ (checkCertificateFast 10 6732 fastCert10_6732=true) ∧ (checkCertificateFast 10 6733 fastCert10_6733=true) ∧ (checkCertificateFast 10 6734 fastCert10_6734=true) ∧ (checkCertificateFast 10 6735 fastCert10_6735=true) ∧ (checkCertificateFast 10 6736 fastCert10_6736=true) ∧ (checkCertificateFast 10 6737 fastCert10_6737=true) ∧ (checkCertificateFast 10 6738 fastCert10_6738=true) ∧ (checkCertificateFast 10 6739 fastCert10_6739=true) ∧ (checkCertificateFast 10 6740 fastCert10_6740=true) ∧ (checkCertificateFast 10 6741 fastCert10_6741=true) ∧ (checkCertificateFast 10 6742 fastCert10_6742=true) ∧ (checkCertificateFast 10 6743 fastCert10_6743=true) ∧ (checkCertificateFast 10 6744 fastCert10_6744=true) ∧ (checkCertificateFast 10 6745 fastCert10_6745=true) ∧ (checkCertificateFast 10 6746 fastCert10_6746=true) ∧ (checkCertificateFast 10 6747 fastCert10_6747=true) ∧ (checkCertificateFast 10 6748 fastCert10_6748=true) ∧ (checkCertificateFast 10 6749 fastCert10_6749=true) ∧ (checkCertificateFast 10 6750 fastCert10_6750=true) ∧ (checkCertificateFast 10 6751 fastCert10_6751=true) ∧ (checkCertificateFast 10 6752 fastCert10_6752=true) ∧ (checkCertificateFast 10 6753 fastCert10_6753=true) ∧ (checkCertificateFast 10 6754 fastCert10_6754=true) ∧ (checkCertificateFast 10 6755 fastCert10_6755=true) ∧ (checkCertificateFast 10 6756 fastCert10_6756=true) ∧ (checkCertificateFast 10 6757 fastCert10_6757=true) ∧ (checkCertificateFast 10 6758 fastCert10_6758=true) ∧ (checkCertificateFast 10 6759 fastCert10_6759=true) ∧ (checkCertificateFast 10 6760 fastCert10_6760=true) ∧ (checkCertificateFast 10 6761 fastCert10_6761=true) ∧ (checkCertificateFast 10 6762 fastCert10_6762=true) ∧ (checkCertificateFast 10 6763 fastCert10_6763=true) ∧ (checkCertificateFast 10 6764 fastCert10_6764=true) ∧ (checkCertificateFast 10 6765 fastCert10_6765=true) ∧ (checkCertificateFast 10 6766 fastCert10_6766=true) ∧ (checkCertificateFast 10 6767 fastCert10_6767=true) ∧ (checkCertificateFast 10 6768 fastCert10_6768=true) ∧ (checkCertificateFast 10 6769 fastCert10_6769=true) ∧ (checkCertificateFast 10 6770 fastCert10_6770=true) ∧ (checkCertificateFast 10 6771 fastCert10_6771=true) ∧ (checkCertificateFast 10 6772 fastCert10_6772=true) ∧ (checkCertificateFast 10 6773 fastCert10_6773=true) ∧ (checkCertificateFast 10 6774 fastCert10_6774=true) ∧ (checkCertificateFast 10 6775 fastCert10_6775=true) ∧ (checkCertificateFast 10 6776 fastCert10_6776=true) ∧ (checkCertificateFast 10 6777 fastCert10_6777=true) ∧ (checkCertificateFast 10 6778 fastCert10_6778=true) ∧ (checkCertificateFast 10 6779 fastCert10_6779=true) ∧ (checkCertificateFast 10 6780 fastCert10_6780=true) ∧ (checkCertificateFast 10 6781 fastCert10_6781=true) ∧ (checkCertificateFast 10 6782 fastCert10_6782=true) ∧ (checkCertificateFast 10 6783 fastCert10_6783=true) ∧ (checkCertificateFast 10 6784 fastCert10_6784=true) ∧ (checkCertificateFast 10 6785 fastCert10_6785=true) ∧ (checkCertificateFast 10 6786 fastCert10_6786=true) ∧ (checkCertificateFast 10 6787 fastCert10_6787=true) ∧ (checkCertificateFast 10 6788 fastCert10_6788=true) ∧ (checkCertificateFast 10 6789 fastCert10_6789=true) ∧ (checkCertificateFast 10 6790 fastCert10_6790=true) ∧ (checkCertificateFast 10 6791 fastCert10_6791=true) ∧ (checkCertificateFast 10 6792 fastCert10_6792=true) ∧ (checkCertificateFast 10 6793 fastCert10_6793=true) ∧ (checkCertificateFast 10 6794 fastCert10_6794=true) ∧ (checkCertificateFast 10 6795 fastCert10_6795=true) ∧ (checkCertificateFast 10 6796 fastCert10_6796=true) ∧ (checkCertificateFast 10 6797 fastCert10_6797=true) ∧ (checkCertificateFast 10 6798 fastCert10_6798=true) ∧ (checkCertificateFast 10 6799 fastCert10_6799=true) ∧ (checkCertificateFast 10 6800 fastCert10_6800=true) ∧ (checkCertificateFast 10 6801 fastCert10_6801=true) ∧ (checkCertificateFast 10 6802 fastCert10_6802=true) ∧ (checkCertificateFast 10 6803 fastCert10_6803=true) ∧ (checkCertificateFast 10 6804 fastCert10_6804=true) ∧ (checkCertificateFast 10 6805 fastCert10_6805=true) ∧ (checkCertificateFast 10 6806 fastCert10_6806=true) ∧ (checkCertificateFast 10 6807 fastCert10_6807=true) ∧ (checkCertificateFast 10 6808 fastCert10_6808=true) ∧ (checkCertificateFast 10 6809 fastCert10_6809=true) ∧ (checkCertificateFast 10 6810 fastCert10_6810=true) ∧ (checkCertificateFast 10 6811 fastCert10_6811=true) ∧ (checkCertificateFast 10 6812 fastCert10_6812=true) ∧ (checkCertificateFast 10 6813 fastCert10_6813=true) ∧ (checkCertificateFast 10 6814 fastCert10_6814=true) ∧ (checkCertificateFast 10 6815 fastCert10_6815=true) ∧ (checkCertificateFast 10 6816 fastCert10_6816=true) ∧ (checkCertificateFast 10 6817 fastCert10_6817=true) ∧ (checkCertificateFast 10 6818 fastCert10_6818=true) ∧ (checkCertificateFast 10 6819 fastCert10_6819=true) ∧ (checkCertificateFast 10 6820 fastCert10_6820=true) ∧ (checkCertificateFast 10 6821 fastCert10_6821=true) ∧ (checkCertificateFast 10 6822 fastCert10_6822=true) ∧ (checkCertificateFast 10 6823 fastCert10_6823=true) ∧ (checkCertificateFast 10 6824 fastCert10_6824=true) ∧ (checkCertificateFast 10 6825 fastCert10_6825=true) ∧ (checkCertificateFast 10 6826 fastCert10_6826=true) ∧ (checkCertificateFast 10 6827 fastCert10_6827=true) ∧ (checkCertificateFast 10 6828 fastCert10_6828=true) ∧ (checkCertificateFast 10 6829 fastCert10_6829=true) ∧ (checkCertificateFast 10 6830 fastCert10_6830=true) ∧ (checkCertificateFast 10 6831 fastCert10_6831=true) ∧ (checkCertificateFast 10 6832 fastCert10_6832=true) ∧ (checkCertificateFast 10 6833 fastCert10_6833=true) ∧ (checkCertificateFast 10 6834 fastCert10_6834=true) ∧ (checkCertificateFast 10 6835 fastCert10_6835=true) ∧ (checkCertificateFast 10 6836 fastCert10_6836=true) ∧ (checkCertificateFast 10 6837 fastCert10_6837=true) ∧ (checkCertificateFast 10 6838 fastCert10_6838=true) ∧ (checkCertificateFast 10 6839 fastCert10_6839=true) ∧ (checkCertificateFast 10 6840 fastCert10_6840=true) ∧ (checkCertificateFast 10 6841 fastCert10_6841=true) ∧ (checkCertificateFast 10 6842 fastCert10_6842=true) ∧ (checkCertificateFast 10 6843 fastCert10_6843=true) ∧ (checkCertificateFast 10 6844 fastCert10_6844=true) ∧ (checkCertificateFast 10 6845 fastCert10_6845=true) ∧ (checkCertificateFast 10 6846 fastCert10_6846=true) ∧ (checkCertificateFast 10 6847 fastCert10_6847=true) ∧ (checkCertificateFast 10 6848 fastCert10_6848=true) ∧ (checkCertificateFast 10 6849 fastCert10_6849=true) ∧ (checkCertificateFast 10 6850 fastCert10_6850=true) ∧ (checkCertificateFast 10 6851 fastCert10_6851=true) ∧ (checkCertificateFast 10 6852 fastCert10_6852=true) ∧ (checkCertificateFast 10 6853 fastCert10_6853=true) ∧ (checkCertificateFast 10 6854 fastCert10_6854=true) ∧ (checkCertificateFast 10 6855 fastCert10_6855=true) ∧ (checkCertificateFast 10 6856 fastCert10_6856=true) ∧ (checkCertificateFast 10 6857 fastCert10_6857=true) ∧ (checkCertificateFast 10 6858 fastCert10_6858=true) ∧ (checkCertificateFast 10 6859 fastCert10_6859=true) ∧ (checkCertificateFast 10 6860 fastCert10_6860=true) ∧ (checkCertificateFast 10 6861 fastCert10_6861=true) ∧ (checkCertificateFast 10 6862 fastCert10_6862=true) ∧ (checkCertificateFast 10 6863 fastCert10_6863=true) ∧ (checkCertificateFast 10 6864 fastCert10_6864=true) ∧ (checkCertificateFast 10 6865 fastCert10_6865=true) ∧ (checkCertificateFast 10 6866 fastCert10_6866=true) ∧ (checkCertificateFast 10 6867 fastCert10_6867=true) ∧ (checkCertificateFast 10 6868 fastCert10_6868=true) ∧ (checkCertificateFast 10 6869 fastCert10_6869=true) ∧ (checkCertificateFast 10 6870 fastCert10_6870=true) ∧ (checkCertificateFast 10 6871 fastCert10_6871=true) ∧ (checkCertificateFast 10 6872 fastCert10_6872=true) ∧ (checkCertificateFast 10 6873 fastCert10_6873=true) ∧ (checkCertificateFast 10 6874 fastCert10_6874=true) ∧ (checkCertificateFast 10 6875 fastCert10_6875=true) ∧ (checkCertificateFast 10 6876 fastCert10_6876=true) ∧ (checkCertificateFast 10 6877 fastCert10_6877=true) ∧ (checkCertificateFast 10 6878 fastCert10_6878=true) ∧ (checkCertificateFast 10 6879 fastCert10_6879=true) ∧ (checkCertificateFast 10 6880 fastCert10_6880=true) ∧ (checkCertificateFast 10 6881 fastCert10_6881=true) ∧ (checkCertificateFast 10 6882 fastCert10_6882=true) ∧ (checkCertificateFast 10 6883 fastCert10_6883=true) ∧ (checkCertificateFast 10 6884 fastCert10_6884=true) ∧ (checkCertificateFast 10 6885 fastCert10_6885=true) ∧ (checkCertificateFast 10 6886 fastCert10_6886=true) ∧ (checkCertificateFast 10 6887 fastCert10_6887=true) ∧ (checkCertificateFast 10 6888 fastCert10_6888=true) ∧ (checkCertificateFast 10 6889 fastCert10_6889=true) ∧ (checkCertificateFast 10 6890 fastCert10_6890=true) ∧ (checkCertificateFast 10 6891 fastCert10_6891=true) ∧ (checkCertificateFast 10 6892 fastCert10_6892=true) ∧ (checkCertificateFast 10 6893 fastCert10_6893=true) ∧ (checkCertificateFast 10 6894 fastCert10_6894=true) ∧ (checkCertificateFast 10 6895 fastCert10_6895=true) ∧ (checkCertificateFast 10 6896 fastCert10_6896=true) ∧ (checkCertificateFast 10 6897 fastCert10_6897=true) ∧ (checkCertificateFast 10 6898 fastCert10_6898=true) ∧ (checkCertificateFast 10 6899 fastCert10_6899=true) ∧ (checkCertificateFast 10 6900 fastCert10_6900=true) ∧ (checkCertificateFast 10 6901 fastCert10_6901=true) ∧ (checkCertificateFast 10 6902 fastCert10_6902=true) ∧ (checkCertificateFast 10 6903 fastCert10_6903=true) ∧ (checkCertificateFast 10 6904 fastCert10_6904=true) ∧ (checkCertificateFast 10 6905 fastCert10_6905=true) ∧ (checkCertificateFast 10 6906 fastCert10_6906=true) ∧ (checkCertificateFast 10 6907 fastCert10_6907=true) ∧ (checkCertificateFast 10 6908 fastCert10_6908=true) ∧ (checkCertificateFast 10 6909 fastCert10_6909=true) ∧ (checkCertificateFast 10 6910 fastCert10_6910=true) ∧ (checkCertificateFast 10 6911 fastCert10_6911=true) ∧ (checkCertificateFast 10 6912 fastCert10_6912=true) ∧ (checkCertificateFast 10 6913 fastCert10_6913=true) ∧ (checkCertificateFast 10 6914 fastCert10_6914=true) ∧ (checkCertificateFast 10 6915 fastCert10_6915=true) ∧ (checkCertificateFast 10 6916 fastCert10_6916=true) ∧ (checkCertificateFast 10 6917 fastCert10_6917=true) ∧ (checkCertificateFast 10 6918 fastCert10_6918=true) ∧ (checkCertificateFast 10 6919 fastCert10_6919=true) ∧ (checkCertificateFast 10 6920 fastCert10_6920=true) ∧ (checkCertificateFast 10 6921 fastCert10_6921=true) ∧ (checkCertificateFast 10 6922 fastCert10_6922=true) ∧ (checkCertificateFast 10 6923 fastCert10_6923=true) ∧ (checkCertificateFast 10 6924 fastCert10_6924=true) ∧ (checkCertificateFast 10 6925 fastCert10_6925=true) ∧ (checkCertificateFast 10 6926 fastCert10_6926=true) ∧ (checkCertificateFast 10 6927 fastCert10_6927=true) ∧ (checkCertificateFast 10 6928 fastCert10_6928=true) ∧ (checkCertificateFast 10 6929 fastCert10_6929=true) ∧ (checkCertificateFast 10 6930 fastCert10_6930=true) ∧ (checkCertificateFast 10 6931 fastCert10_6931=true) ∧ (checkCertificateFast 10 6932 fastCert10_6932=true) ∧ (checkCertificateFast 10 6933 fastCert10_6933=true) ∧ (checkCertificateFast 10 6934 fastCert10_6934=true) ∧ (checkCertificateFast 10 6935 fastCert10_6935=true) ∧ (checkCertificateFast 10 6936 fastCert10_6936=true) ∧ (checkCertificateFast 10 6937 fastCert10_6937=true) ∧ (checkCertificateFast 10 6938 fastCert10_6938=true) ∧ (checkCertificateFast 10 6939 fastCert10_6939=true) ∧ (checkCertificateFast 10 6940 fastCert10_6940=true) ∧ (checkCertificateFast 10 6941 fastCert10_6941=true) ∧ (checkCertificateFast 10 6942 fastCert10_6942=true) ∧ (checkCertificateFast 10 6943 fastCert10_6943=true) ∧ (checkCertificateFast 10 6944 fastCert10_6944=true) ∧ (checkCertificateFast 10 6945 fastCert10_6945=true) ∧ (checkCertificateFast 10 6946 fastCert10_6946=true) ∧ (checkCertificateFast 10 6947 fastCert10_6947=true) ∧ (checkCertificateFast 10 6948 fastCert10_6948=true) ∧ (checkCertificateFast 10 6949 fastCert10_6949=true) ∧ (checkCertificateFast 10 6950 fastCert10_6950=true) ∧ (checkCertificateFast 10 6951 fastCert10_6951=true) ∧ (checkCertificateFast 10 6952 fastCert10_6952=true) ∧ (checkCertificateFast 10 6953 fastCert10_6953=true) ∧ (checkCertificateFast 10 6954 fastCert10_6954=true) ∧ (checkCertificateFast 10 6955 fastCert10_6955=true) ∧ (checkCertificateFast 10 6956 fastCert10_6956=true) ∧ (checkCertificateFast 10 6957 fastCert10_6957=true) ∧ (checkCertificateFast 10 6958 fastCert10_6958=true) ∧ (checkCertificateFast 10 6959 fastCert10_6959=true) ∧ (checkCertificateFast 10 6960 fastCert10_6960=true) ∧ (checkCertificateFast 10 6961 fastCert10_6961=true) ∧ (checkCertificateFast 10 6962 fastCert10_6962=true) ∧ (checkCertificateFast 10 6963 fastCert10_6963=true) ∧ (checkCertificateFast 10 6964 fastCert10_6964=true) ∧ (checkCertificateFast 10 6965 fastCert10_6965=true) ∧ (checkCertificateFast 10 6966 fastCert10_6966=true) ∧ (checkCertificateFast 10 6967 fastCert10_6967=true) ∧ (checkCertificateFast 10 6968 fastCert10_6968=true) ∧ (checkCertificateFast 10 6969 fastCert10_6969=true) ∧ (checkCertificateFast 10 6970 fastCert10_6970=true) ∧ (checkCertificateFast 10 6971 fastCert10_6971=true) ∧ (checkCertificateFast 10 6972 fastCert10_6972=true) ∧ (checkCertificateFast 10 6973 fastCert10_6973=true) ∧ (checkCertificateFast 10 6974 fastCert10_6974=true) ∧ (checkCertificateFast 10 6975 fastCert10_6975=true) ∧ (checkCertificateFast 10 6976 fastCert10_6976=true) ∧ (checkCertificateFast 10 6977 fastCert10_6977=true) ∧ (checkCertificateFast 10 6978 fastCert10_6978=true) ∧ (checkCertificateFast 10 6979 fastCert10_6979=true) ∧ (checkCertificateFast 10 6980 fastCert10_6980=true) ∧ (checkCertificateFast 10 6981 fastCert10_6981=true) ∧ (checkCertificateFast 10 6982 fastCert10_6982=true) ∧ (checkCertificateFast 10 6983 fastCert10_6983=true) ∧ (checkCertificateFast 10 6984 fastCert10_6984=true) ∧ (checkCertificateFast 10 6985 fastCert10_6985=true) ∧ (checkCertificateFast 10 6986 fastCert10_6986=true) ∧ (checkCertificateFast 10 6987 fastCert10_6987=true) ∧ (checkCertificateFast 10 6988 fastCert10_6988=true) ∧ (checkCertificateFast 10 6989 fastCert10_6989=true) ∧ (checkCertificateFast 10 6990 fastCert10_6990=true) ∧ (checkCertificateFast 10 6991 fastCert10_6991=true) ∧ (checkCertificateFast 10 6992 fastCert10_6992=true) ∧ (checkCertificateFast 10 6993 fastCert10_6993=true) ∧ (checkCertificateFast 10 6994 fastCert10_6994=true) ∧ (checkCertificateFast 10 6995 fastCert10_6995=true) ∧ (checkCertificateFast 10 6996 fastCert10_6996=true) ∧ (checkCertificateFast 10 6997 fastCert10_6997=true) ∧ (checkCertificateFast 10 6998 fastCert10_6998=true) ∧ (checkCertificateFast 10 6999 fastCert10_6999=true) :=
  ⟨fastCase10_6000,fastCase10_6001,fastCase10_6002,fastCase10_6003,fastCase10_6004,fastCase10_6005,fastCase10_6006,fastCase10_6007,fastCase10_6008,fastCase10_6009,fastCase10_6010,fastCase10_6011,fastCase10_6012,fastCase10_6013,fastCase10_6014,fastCase10_6015,fastCase10_6016,fastCase10_6017,fastCase10_6018,fastCase10_6019,fastCase10_6020,fastCase10_6021,fastCase10_6022,fastCase10_6023,fastCase10_6024,fastCase10_6025,fastCase10_6026,fastCase10_6027,fastCase10_6028,fastCase10_6029,fastCase10_6030,fastCase10_6031,fastCase10_6032,fastCase10_6033,fastCase10_6034,fastCase10_6035,fastCase10_6036,fastCase10_6037,fastCase10_6038,fastCase10_6039,fastCase10_6040,fastCase10_6041,fastCase10_6042,fastCase10_6043,fastCase10_6044,fastCase10_6045,fastCase10_6046,fastCase10_6047,fastCase10_6048,fastCase10_6049,fastCase10_6050,fastCase10_6051,fastCase10_6052,fastCase10_6053,fastCase10_6054,fastCase10_6055,fastCase10_6056,fastCase10_6057,fastCase10_6058,fastCase10_6059,fastCase10_6060,fastCase10_6061,fastCase10_6062,fastCase10_6063,fastCase10_6064,fastCase10_6065,fastCase10_6066,fastCase10_6067,fastCase10_6068,fastCase10_6069,fastCase10_6070,fastCase10_6071,fastCase10_6072,fastCase10_6073,fastCase10_6074,fastCase10_6075,fastCase10_6076,fastCase10_6077,fastCase10_6078,fastCase10_6079,fastCase10_6080,fastCase10_6081,fastCase10_6082,fastCase10_6083,fastCase10_6084,fastCase10_6085,fastCase10_6086,fastCase10_6087,fastCase10_6088,fastCase10_6089,fastCase10_6090,fastCase10_6091,fastCase10_6092,fastCase10_6093,fastCase10_6094,fastCase10_6095,fastCase10_6096,fastCase10_6097,fastCase10_6098,fastCase10_6099,fastCase10_6100,fastCase10_6101,fastCase10_6102,fastCase10_6103,fastCase10_6104,fastCase10_6105,fastCase10_6106,fastCase10_6107,fastCase10_6108,fastCase10_6109,fastCase10_6110,fastCase10_6111,fastCase10_6112,fastCase10_6113,fastCase10_6114,fastCase10_6115,fastCase10_6116,fastCase10_6117,fastCase10_6118,fastCase10_6119,fastCase10_6120,fastCase10_6121,fastCase10_6122,fastCase10_6123,fastCase10_6124,fastCase10_6125,fastCase10_6126,fastCase10_6127,fastCase10_6128,fastCase10_6129,fastCase10_6130,fastCase10_6131,fastCase10_6132,fastCase10_6133,fastCase10_6134,fastCase10_6135,fastCase10_6136,fastCase10_6137,fastCase10_6138,fastCase10_6139,fastCase10_6140,fastCase10_6141,fastCase10_6142,fastCase10_6143,fastCase10_6144,fastCase10_6145,fastCase10_6146,fastCase10_6147,fastCase10_6148,fastCase10_6149,fastCase10_6150,fastCase10_6151,fastCase10_6152,fastCase10_6153,fastCase10_6154,fastCase10_6155,fastCase10_6156,fastCase10_6157,fastCase10_6158,fastCase10_6159,fastCase10_6160,fastCase10_6161,fastCase10_6162,fastCase10_6163,fastCase10_6164,fastCase10_6165,fastCase10_6166,fastCase10_6167,fastCase10_6168,fastCase10_6169,fastCase10_6170,fastCase10_6171,fastCase10_6172,fastCase10_6173,fastCase10_6174,fastCase10_6175,fastCase10_6176,fastCase10_6177,fastCase10_6178,fastCase10_6179,fastCase10_6180,fastCase10_6181,fastCase10_6182,fastCase10_6183,fastCase10_6184,fastCase10_6185,fastCase10_6186,fastCase10_6187,fastCase10_6188,fastCase10_6189,fastCase10_6190,fastCase10_6191,fastCase10_6192,fastCase10_6193,fastCase10_6194,fastCase10_6195,fastCase10_6196,fastCase10_6197,fastCase10_6198,fastCase10_6199,fastCase10_6200,fastCase10_6201,fastCase10_6202,fastCase10_6203,fastCase10_6204,fastCase10_6205,fastCase10_6206,fastCase10_6207,fastCase10_6208,fastCase10_6209,fastCase10_6210,fastCase10_6211,fastCase10_6212,fastCase10_6213,fastCase10_6214,fastCase10_6215,fastCase10_6216,fastCase10_6217,fastCase10_6218,fastCase10_6219,fastCase10_6220,fastCase10_6221,fastCase10_6222,fastCase10_6223,fastCase10_6224,fastCase10_6225,fastCase10_6226,fastCase10_6227,fastCase10_6228,fastCase10_6229,fastCase10_6230,fastCase10_6231,fastCase10_6232,fastCase10_6233,fastCase10_6234,fastCase10_6235,fastCase10_6236,fastCase10_6237,fastCase10_6238,fastCase10_6239,fastCase10_6240,fastCase10_6241,fastCase10_6242,fastCase10_6243,fastCase10_6244,fastCase10_6245,fastCase10_6246,fastCase10_6247,fastCase10_6248,fastCase10_6249,fastCase10_6250,fastCase10_6251,fastCase10_6252,fastCase10_6253,fastCase10_6254,fastCase10_6255,fastCase10_6256,fastCase10_6257,fastCase10_6258,fastCase10_6259,fastCase10_6260,fastCase10_6261,fastCase10_6262,fastCase10_6263,fastCase10_6264,fastCase10_6265,fastCase10_6266,fastCase10_6267,fastCase10_6268,fastCase10_6269,fastCase10_6270,fastCase10_6271,fastCase10_6272,fastCase10_6273,fastCase10_6274,fastCase10_6275,fastCase10_6276,fastCase10_6277,fastCase10_6278,fastCase10_6279,fastCase10_6280,fastCase10_6281,fastCase10_6282,fastCase10_6283,fastCase10_6284,fastCase10_6285,fastCase10_6286,fastCase10_6287,fastCase10_6288,fastCase10_6289,fastCase10_6290,fastCase10_6291,fastCase10_6292,fastCase10_6293,fastCase10_6294,fastCase10_6295,fastCase10_6296,fastCase10_6297,fastCase10_6298,fastCase10_6299,fastCase10_6300,fastCase10_6301,fastCase10_6302,fastCase10_6303,fastCase10_6304,fastCase10_6305,fastCase10_6306,fastCase10_6307,fastCase10_6308,fastCase10_6309,fastCase10_6310,fastCase10_6311,fastCase10_6312,fastCase10_6313,fastCase10_6314,fastCase10_6315,fastCase10_6316,fastCase10_6317,fastCase10_6318,fastCase10_6319,fastCase10_6320,fastCase10_6321,fastCase10_6322,fastCase10_6323,fastCase10_6324,fastCase10_6325,fastCase10_6326,fastCase10_6327,fastCase10_6328,fastCase10_6329,fastCase10_6330,fastCase10_6331,fastCase10_6332,fastCase10_6333,fastCase10_6334,fastCase10_6335,fastCase10_6336,fastCase10_6337,fastCase10_6338,fastCase10_6339,fastCase10_6340,fastCase10_6341,fastCase10_6342,fastCase10_6343,fastCase10_6344,fastCase10_6345,fastCase10_6346,fastCase10_6347,fastCase10_6348,fastCase10_6349,fastCase10_6350,fastCase10_6351,fastCase10_6352,fastCase10_6353,fastCase10_6354,fastCase10_6355,fastCase10_6356,fastCase10_6357,fastCase10_6358,fastCase10_6359,fastCase10_6360,fastCase10_6361,fastCase10_6362,fastCase10_6363,fastCase10_6364,fastCase10_6365,fastCase10_6366,fastCase10_6367,fastCase10_6368,fastCase10_6369,fastCase10_6370,fastCase10_6371,fastCase10_6372,fastCase10_6373,fastCase10_6374,fastCase10_6375,fastCase10_6376,fastCase10_6377,fastCase10_6378,fastCase10_6379,fastCase10_6380,fastCase10_6381,fastCase10_6382,fastCase10_6383,fastCase10_6384,fastCase10_6385,fastCase10_6386,fastCase10_6387,fastCase10_6388,fastCase10_6389,fastCase10_6390,fastCase10_6391,fastCase10_6392,fastCase10_6393,fastCase10_6394,fastCase10_6395,fastCase10_6396,fastCase10_6397,fastCase10_6398,fastCase10_6399,fastCase10_6400,fastCase10_6401,fastCase10_6402,fastCase10_6403,fastCase10_6404,fastCase10_6405,fastCase10_6406,fastCase10_6407,fastCase10_6408,fastCase10_6409,fastCase10_6410,fastCase10_6411,fastCase10_6412,fastCase10_6413,fastCase10_6414,fastCase10_6415,fastCase10_6416,fastCase10_6417,fastCase10_6418,fastCase10_6419,fastCase10_6420,fastCase10_6421,fastCase10_6422,fastCase10_6423,fastCase10_6424,fastCase10_6425,fastCase10_6426,fastCase10_6427,fastCase10_6428,fastCase10_6429,fastCase10_6430,fastCase10_6431,fastCase10_6432,fastCase10_6433,fastCase10_6434,fastCase10_6435,fastCase10_6436,fastCase10_6437,fastCase10_6438,fastCase10_6439,fastCase10_6440,fastCase10_6441,fastCase10_6442,fastCase10_6443,fastCase10_6444,fastCase10_6445,fastCase10_6446,fastCase10_6447,fastCase10_6448,fastCase10_6449,fastCase10_6450,fastCase10_6451,fastCase10_6452,fastCase10_6453,fastCase10_6454,fastCase10_6455,fastCase10_6456,fastCase10_6457,fastCase10_6458,fastCase10_6459,fastCase10_6460,fastCase10_6461,fastCase10_6462,fastCase10_6463,fastCase10_6464,fastCase10_6465,fastCase10_6466,fastCase10_6467,fastCase10_6468,fastCase10_6469,fastCase10_6470,fastCase10_6471,fastCase10_6472,fastCase10_6473,fastCase10_6474,fastCase10_6475,fastCase10_6476,fastCase10_6477,fastCase10_6478,fastCase10_6479,fastCase10_6480,fastCase10_6481,fastCase10_6482,fastCase10_6483,fastCase10_6484,fastCase10_6485,fastCase10_6486,fastCase10_6487,fastCase10_6488,fastCase10_6489,fastCase10_6490,fastCase10_6491,fastCase10_6492,fastCase10_6493,fastCase10_6494,fastCase10_6495,fastCase10_6496,fastCase10_6497,fastCase10_6498,fastCase10_6499,fastCase10_6500,fastCase10_6501,fastCase10_6502,fastCase10_6503,fastCase10_6504,fastCase10_6505,fastCase10_6506,fastCase10_6507,fastCase10_6508,fastCase10_6509,fastCase10_6510,fastCase10_6511,fastCase10_6512,fastCase10_6513,fastCase10_6514,fastCase10_6515,fastCase10_6516,fastCase10_6517,fastCase10_6518,fastCase10_6519,fastCase10_6520,fastCase10_6521,fastCase10_6522,fastCase10_6523,fastCase10_6524,fastCase10_6525,fastCase10_6526,fastCase10_6527,fastCase10_6528,fastCase10_6529,fastCase10_6530,fastCase10_6531,fastCase10_6532,fastCase10_6533,fastCase10_6534,fastCase10_6535,fastCase10_6536,fastCase10_6537,fastCase10_6538,fastCase10_6539,fastCase10_6540,fastCase10_6541,fastCase10_6542,fastCase10_6543,fastCase10_6544,fastCase10_6545,fastCase10_6546,fastCase10_6547,fastCase10_6548,fastCase10_6549,fastCase10_6550,fastCase10_6551,fastCase10_6552,fastCase10_6553,fastCase10_6554,fastCase10_6555,fastCase10_6556,fastCase10_6557,fastCase10_6558,fastCase10_6559,fastCase10_6560,fastCase10_6561,fastCase10_6562,fastCase10_6563,fastCase10_6564,fastCase10_6565,fastCase10_6566,fastCase10_6567,fastCase10_6568,fastCase10_6569,fastCase10_6570,fastCase10_6571,fastCase10_6572,fastCase10_6573,fastCase10_6574,fastCase10_6575,fastCase10_6576,fastCase10_6577,fastCase10_6578,fastCase10_6579,fastCase10_6580,fastCase10_6581,fastCase10_6582,fastCase10_6583,fastCase10_6584,fastCase10_6585,fastCase10_6586,fastCase10_6587,fastCase10_6588,fastCase10_6589,fastCase10_6590,fastCase10_6591,fastCase10_6592,fastCase10_6593,fastCase10_6594,fastCase10_6595,fastCase10_6596,fastCase10_6597,fastCase10_6598,fastCase10_6599,fastCase10_6600,fastCase10_6601,fastCase10_6602,fastCase10_6603,fastCase10_6604,fastCase10_6605,fastCase10_6606,fastCase10_6607,fastCase10_6608,fastCase10_6609,fastCase10_6610,fastCase10_6611,fastCase10_6612,fastCase10_6613,fastCase10_6614,fastCase10_6615,fastCase10_6616,fastCase10_6617,fastCase10_6618,fastCase10_6619,fastCase10_6620,fastCase10_6621,fastCase10_6622,fastCase10_6623,fastCase10_6624,fastCase10_6625,fastCase10_6626,fastCase10_6627,fastCase10_6628,fastCase10_6629,fastCase10_6630,fastCase10_6631,fastCase10_6632,fastCase10_6633,fastCase10_6634,fastCase10_6635,fastCase10_6636,fastCase10_6637,fastCase10_6638,fastCase10_6639,fastCase10_6640,fastCase10_6641,fastCase10_6642,fastCase10_6643,fastCase10_6644,fastCase10_6645,fastCase10_6646,fastCase10_6647,fastCase10_6648,fastCase10_6649,fastCase10_6650,fastCase10_6651,fastCase10_6652,fastCase10_6653,fastCase10_6654,fastCase10_6655,fastCase10_6656,fastCase10_6657,fastCase10_6658,fastCase10_6659,fastCase10_6660,fastCase10_6661,fastCase10_6662,fastCase10_6663,fastCase10_6664,fastCase10_6665,fastCase10_6666,fastCase10_6667,fastCase10_6668,fastCase10_6669,fastCase10_6670,fastCase10_6671,fastCase10_6672,fastCase10_6673,fastCase10_6674,fastCase10_6675,fastCase10_6676,fastCase10_6677,fastCase10_6678,fastCase10_6679,fastCase10_6680,fastCase10_6681,fastCase10_6682,fastCase10_6683,fastCase10_6684,fastCase10_6685,fastCase10_6686,fastCase10_6687,fastCase10_6688,fastCase10_6689,fastCase10_6690,fastCase10_6691,fastCase10_6692,fastCase10_6693,fastCase10_6694,fastCase10_6695,fastCase10_6696,fastCase10_6697,fastCase10_6698,fastCase10_6699,fastCase10_6700,fastCase10_6701,fastCase10_6702,fastCase10_6703,fastCase10_6704,fastCase10_6705,fastCase10_6706,fastCase10_6707,fastCase10_6708,fastCase10_6709,fastCase10_6710,fastCase10_6711,fastCase10_6712,fastCase10_6713,fastCase10_6714,fastCase10_6715,fastCase10_6716,fastCase10_6717,fastCase10_6718,fastCase10_6719,fastCase10_6720,fastCase10_6721,fastCase10_6722,fastCase10_6723,fastCase10_6724,fastCase10_6725,fastCase10_6726,fastCase10_6727,fastCase10_6728,fastCase10_6729,fastCase10_6730,fastCase10_6731,fastCase10_6732,fastCase10_6733,fastCase10_6734,fastCase10_6735,fastCase10_6736,fastCase10_6737,fastCase10_6738,fastCase10_6739,fastCase10_6740,fastCase10_6741,fastCase10_6742,fastCase10_6743,fastCase10_6744,fastCase10_6745,fastCase10_6746,fastCase10_6747,fastCase10_6748,fastCase10_6749,fastCase10_6750,fastCase10_6751,fastCase10_6752,fastCase10_6753,fastCase10_6754,fastCase10_6755,fastCase10_6756,fastCase10_6757,fastCase10_6758,fastCase10_6759,fastCase10_6760,fastCase10_6761,fastCase10_6762,fastCase10_6763,fastCase10_6764,fastCase10_6765,fastCase10_6766,fastCase10_6767,fastCase10_6768,fastCase10_6769,fastCase10_6770,fastCase10_6771,fastCase10_6772,fastCase10_6773,fastCase10_6774,fastCase10_6775,fastCase10_6776,fastCase10_6777,fastCase10_6778,fastCase10_6779,fastCase10_6780,fastCase10_6781,fastCase10_6782,fastCase10_6783,fastCase10_6784,fastCase10_6785,fastCase10_6786,fastCase10_6787,fastCase10_6788,fastCase10_6789,fastCase10_6790,fastCase10_6791,fastCase10_6792,fastCase10_6793,fastCase10_6794,fastCase10_6795,fastCase10_6796,fastCase10_6797,fastCase10_6798,fastCase10_6799,fastCase10_6800,fastCase10_6801,fastCase10_6802,fastCase10_6803,fastCase10_6804,fastCase10_6805,fastCase10_6806,fastCase10_6807,fastCase10_6808,fastCase10_6809,fastCase10_6810,fastCase10_6811,fastCase10_6812,fastCase10_6813,fastCase10_6814,fastCase10_6815,fastCase10_6816,fastCase10_6817,fastCase10_6818,fastCase10_6819,fastCase10_6820,fastCase10_6821,fastCase10_6822,fastCase10_6823,fastCase10_6824,fastCase10_6825,fastCase10_6826,fastCase10_6827,fastCase10_6828,fastCase10_6829,fastCase10_6830,fastCase10_6831,fastCase10_6832,fastCase10_6833,fastCase10_6834,fastCase10_6835,fastCase10_6836,fastCase10_6837,fastCase10_6838,fastCase10_6839,fastCase10_6840,fastCase10_6841,fastCase10_6842,fastCase10_6843,fastCase10_6844,fastCase10_6845,fastCase10_6846,fastCase10_6847,fastCase10_6848,fastCase10_6849,fastCase10_6850,fastCase10_6851,fastCase10_6852,fastCase10_6853,fastCase10_6854,fastCase10_6855,fastCase10_6856,fastCase10_6857,fastCase10_6858,fastCase10_6859,fastCase10_6860,fastCase10_6861,fastCase10_6862,fastCase10_6863,fastCase10_6864,fastCase10_6865,fastCase10_6866,fastCase10_6867,fastCase10_6868,fastCase10_6869,fastCase10_6870,fastCase10_6871,fastCase10_6872,fastCase10_6873,fastCase10_6874,fastCase10_6875,fastCase10_6876,fastCase10_6877,fastCase10_6878,fastCase10_6879,fastCase10_6880,fastCase10_6881,fastCase10_6882,fastCase10_6883,fastCase10_6884,fastCase10_6885,fastCase10_6886,fastCase10_6887,fastCase10_6888,fastCase10_6889,fastCase10_6890,fastCase10_6891,fastCase10_6892,fastCase10_6893,fastCase10_6894,fastCase10_6895,fastCase10_6896,fastCase10_6897,fastCase10_6898,fastCase10_6899,fastCase10_6900,fastCase10_6901,fastCase10_6902,fastCase10_6903,fastCase10_6904,fastCase10_6905,fastCase10_6906,fastCase10_6907,fastCase10_6908,fastCase10_6909,fastCase10_6910,fastCase10_6911,fastCase10_6912,fastCase10_6913,fastCase10_6914,fastCase10_6915,fastCase10_6916,fastCase10_6917,fastCase10_6918,fastCase10_6919,fastCase10_6920,fastCase10_6921,fastCase10_6922,fastCase10_6923,fastCase10_6924,fastCase10_6925,fastCase10_6926,fastCase10_6927,fastCase10_6928,fastCase10_6929,fastCase10_6930,fastCase10_6931,fastCase10_6932,fastCase10_6933,fastCase10_6934,fastCase10_6935,fastCase10_6936,fastCase10_6937,fastCase10_6938,fastCase10_6939,fastCase10_6940,fastCase10_6941,fastCase10_6942,fastCase10_6943,fastCase10_6944,fastCase10_6945,fastCase10_6946,fastCase10_6947,fastCase10_6948,fastCase10_6949,fastCase10_6950,fastCase10_6951,fastCase10_6952,fastCase10_6953,fastCase10_6954,fastCase10_6955,fastCase10_6956,fastCase10_6957,fastCase10_6958,fastCase10_6959,fastCase10_6960,fastCase10_6961,fastCase10_6962,fastCase10_6963,fastCase10_6964,fastCase10_6965,fastCase10_6966,fastCase10_6967,fastCase10_6968,fastCase10_6969,fastCase10_6970,fastCase10_6971,fastCase10_6972,fastCase10_6973,fastCase10_6974,fastCase10_6975,fastCase10_6976,fastCase10_6977,fastCase10_6978,fastCase10_6979,fastCase10_6980,fastCase10_6981,fastCase10_6982,fastCase10_6983,fastCase10_6984,fastCase10_6985,fastCase10_6986,fastCase10_6987,fastCase10_6988,fastCase10_6989,fastCase10_6990,fastCase10_6991,fastCase10_6992,fastCase10_6993,fastCase10_6994,fastCase10_6995,fastCase10_6996,fastCase10_6997,fastCase10_6998,fastCase10_6999⟩
#print axioms aggregate_F10_006
end KernelCatalog
