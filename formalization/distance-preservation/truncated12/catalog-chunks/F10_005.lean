import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_5000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5000 : checkCertificateFast 10 5000 fastCert10_5000=true := by decide +kernel
def fastCert10_5001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5001 : checkCertificateFast 10 5001 fastCert10_5001=true := by decide +kernel
def fastCert10_5002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5002 : checkCertificateFast 10 5002 fastCert10_5002=true := by decide +kernel
def fastCert10_5003 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5003 : checkCertificateFast 10 5003 fastCert10_5003=true := by decide +kernel
def fastCert10_5004 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5004 : checkCertificateFast 10 5004 fastCert10_5004=true := by decide +kernel
def fastCert10_5005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5005 : checkCertificateFast 10 5005 fastCert10_5005=true := by decide +kernel
def fastCert10_5006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5006 : checkCertificateFast 10 5006 fastCert10_5006=true := by decide +kernel
def fastCert10_5007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5007 : checkCertificateFast 10 5007 fastCert10_5007=true := by decide +kernel
def fastCert10_5008 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5008 : checkCertificateFast 10 5008 fastCert10_5008=true := by decide +kernel
def fastCert10_5009 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5009 : checkCertificateFast 10 5009 fastCert10_5009=true := by decide +kernel
def fastCert10_5010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5010 : checkCertificateFast 10 5010 fastCert10_5010=true := by decide +kernel
def fastCert10_5011 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5011 : checkCertificateFast 10 5011 fastCert10_5011=true := by decide +kernel
def fastCert10_5012 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5012 : checkCertificateFast 10 5012 fastCert10_5012=true := by decide +kernel
def fastCert10_5013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5013 : checkCertificateFast 10 5013 fastCert10_5013=true := by decide +kernel
def fastCert10_5014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5014 : checkCertificateFast 10 5014 fastCert10_5014=true := by decide +kernel
def fastCert10_5015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5015 : checkCertificateFast 10 5015 fastCert10_5015=true := by decide +kernel
def fastCert10_5016 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5016 : checkCertificateFast 10 5016 fastCert10_5016=true := by decide +kernel
def fastCert10_5017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5017 : checkCertificateFast 10 5017 fastCert10_5017=true := by decide +kernel
def fastCert10_5018 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5018 : checkCertificateFast 10 5018 fastCert10_5018=true := by decide +kernel
def fastCert10_5019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5019 : checkCertificateFast 10 5019 fastCert10_5019=true := by decide +kernel
def fastCert10_5020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5020 : checkCertificateFast 10 5020 fastCert10_5020=true := by decide +kernel
def fastCert10_5021 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5021 : checkCertificateFast 10 5021 fastCert10_5021=true := by decide +kernel
def fastCert10_5022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5022 : checkCertificateFast 10 5022 fastCert10_5022=true := by decide +kernel
def fastCert10_5023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5023 : checkCertificateFast 10 5023 fastCert10_5023=true := by decide +kernel
def fastCert10_5024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5024 : checkCertificateFast 10 5024 fastCert10_5024=true := by decide +kernel
def fastCert10_5025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5025 : checkCertificateFast 10 5025 fastCert10_5025=true := by decide +kernel
def fastCert10_5026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5026 : checkCertificateFast 10 5026 fastCert10_5026=true := by decide +kernel
def fastCert10_5027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5027 : checkCertificateFast 10 5027 fastCert10_5027=true := by decide +kernel
def fastCert10_5028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5028 : checkCertificateFast 10 5028 fastCert10_5028=true := by decide +kernel
def fastCert10_5029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5029 : checkCertificateFast 10 5029 fastCert10_5029=true := by decide +kernel
def fastCert10_5030 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5030 : checkCertificateFast 10 5030 fastCert10_5030=true := by decide +kernel
def fastCert10_5031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5031 : checkCertificateFast 10 5031 fastCert10_5031=true := by decide +kernel
def fastCert10_5032 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5032 : checkCertificateFast 10 5032 fastCert10_5032=true := by decide +kernel
def fastCert10_5033 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5033 : checkCertificateFast 10 5033 fastCert10_5033=true := by decide +kernel
def fastCert10_5034 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5034 : checkCertificateFast 10 5034 fastCert10_5034=true := by decide +kernel
def fastCert10_5035 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5035 : checkCertificateFast 10 5035 fastCert10_5035=true := by decide +kernel
def fastCert10_5036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5036 : checkCertificateFast 10 5036 fastCert10_5036=true := by decide +kernel
def fastCert10_5037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5037 : checkCertificateFast 10 5037 fastCert10_5037=true := by decide +kernel
def fastCert10_5038 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5038 : checkCertificateFast 10 5038 fastCert10_5038=true := by decide +kernel
def fastCert10_5039 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5039 : checkCertificateFast 10 5039 fastCert10_5039=true := by decide +kernel
def fastCert10_5040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5040 : checkCertificateFast 10 5040 fastCert10_5040=true := by decide +kernel
def fastCert10_5041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5041 : checkCertificateFast 10 5041 fastCert10_5041=true := by decide +kernel
def fastCert10_5042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5042 : checkCertificateFast 10 5042 fastCert10_5042=true := by decide +kernel
def fastCert10_5043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5043 : checkCertificateFast 10 5043 fastCert10_5043=true := by decide +kernel
def fastCert10_5044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5044 : checkCertificateFast 10 5044 fastCert10_5044=true := by decide +kernel
def fastCert10_5045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5045 : checkCertificateFast 10 5045 fastCert10_5045=true := by decide +kernel
def fastCert10_5046 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5046 : checkCertificateFast 10 5046 fastCert10_5046=true := by decide +kernel
def fastCert10_5047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5047 : checkCertificateFast 10 5047 fastCert10_5047=true := by decide +kernel
def fastCert10_5048 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5048 : checkCertificateFast 10 5048 fastCert10_5048=true := by decide +kernel
def fastCert10_5049 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5049 : checkCertificateFast 10 5049 fastCert10_5049=true := by decide +kernel
def fastCert10_5050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5050 : checkCertificateFast 10 5050 fastCert10_5050=true := by decide +kernel
def fastCert10_5051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5051 : checkCertificateFast 10 5051 fastCert10_5051=true := by decide +kernel
def fastCert10_5052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5052 : checkCertificateFast 10 5052 fastCert10_5052=true := by decide +kernel
def fastCert10_5053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5053 : checkCertificateFast 10 5053 fastCert10_5053=true := by decide +kernel
def fastCert10_5054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5054 : checkCertificateFast 10 5054 fastCert10_5054=true := by decide +kernel
def fastCert10_5055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5055 : checkCertificateFast 10 5055 fastCert10_5055=true := by decide +kernel
def fastCert10_5056 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5056 : checkCertificateFast 10 5056 fastCert10_5056=true := by decide +kernel
def fastCert10_5057 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5057 : checkCertificateFast 10 5057 fastCert10_5057=true := by decide +kernel
def fastCert10_5058 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5058 : checkCertificateFast 10 5058 fastCert10_5058=true := by decide +kernel
def fastCert10_5059 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5059 : checkCertificateFast 10 5059 fastCert10_5059=true := by decide +kernel
def fastCert10_5060 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5060 : checkCertificateFast 10 5060 fastCert10_5060=true := by decide +kernel
def fastCert10_5061 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5061 : checkCertificateFast 10 5061 fastCert10_5061=true := by decide +kernel
def fastCert10_5062 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5062 : checkCertificateFast 10 5062 fastCert10_5062=true := by decide +kernel
def fastCert10_5063 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5063 : checkCertificateFast 10 5063 fastCert10_5063=true := by decide +kernel
def fastCert10_5064 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5064 : checkCertificateFast 10 5064 fastCert10_5064=true := by decide +kernel
def fastCert10_5065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5065 : checkCertificateFast 10 5065 fastCert10_5065=true := by decide +kernel
def fastCert10_5066 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5066 : checkCertificateFast 10 5066 fastCert10_5066=true := by decide +kernel
def fastCert10_5067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5067 : checkCertificateFast 10 5067 fastCert10_5067=true := by decide +kernel
def fastCert10_5068 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5068 : checkCertificateFast 10 5068 fastCert10_5068=true := by decide +kernel
def fastCert10_5069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5069 : checkCertificateFast 10 5069 fastCert10_5069=true := by decide +kernel
def fastCert10_5070 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5070 : checkCertificateFast 10 5070 fastCert10_5070=true := by decide +kernel
def fastCert10_5071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5071 : checkCertificateFast 10 5071 fastCert10_5071=true := by decide +kernel
def fastCert10_5072 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5072 : checkCertificateFast 10 5072 fastCert10_5072=true := by decide +kernel
def fastCert10_5073 : Certificate := ⟨18,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5073 : checkCertificateFast 10 5073 fastCert10_5073=true := by decide +kernel
def fastCert10_5074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5074 : checkCertificateFast 10 5074 fastCert10_5074=true := by decide +kernel
def fastCert10_5075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5075 : checkCertificateFast 10 5075 fastCert10_5075=true := by decide +kernel
def fastCert10_5076 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5076 : checkCertificateFast 10 5076 fastCert10_5076=true := by decide +kernel
def fastCert10_5077 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5077 : checkCertificateFast 10 5077 fastCert10_5077=true := by decide +kernel
def fastCert10_5078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5078 : checkCertificateFast 10 5078 fastCert10_5078=true := by decide +kernel
def fastCert10_5079 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5079 : checkCertificateFast 10 5079 fastCert10_5079=true := by decide +kernel
def fastCert10_5080 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_5080 : checkCertificateFast 10 5080 fastCert10_5080=true := by decide +kernel
def fastCert10_5081 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5081 : checkCertificateFast 10 5081 fastCert10_5081=true := by decide +kernel
def fastCert10_5082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5082 : checkCertificateFast 10 5082 fastCert10_5082=true := by decide +kernel
def fastCert10_5083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5083 : checkCertificateFast 10 5083 fastCert10_5083=true := by decide +kernel
def fastCert10_5084 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_5084 : checkCertificateFast 10 5084 fastCert10_5084=true := by decide +kernel
def fastCert10_5085 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5085 : checkCertificateFast 10 5085 fastCert10_5085=true := by decide +kernel
def fastCert10_5086 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5086 : checkCertificateFast 10 5086 fastCert10_5086=true := by decide +kernel
def fastCert10_5087 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5087 : checkCertificateFast 10 5087 fastCert10_5087=true := by decide +kernel
def fastCert10_5088 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5088 : checkCertificateFast 10 5088 fastCert10_5088=true := by decide +kernel
def fastCert10_5089 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5089 : checkCertificateFast 10 5089 fastCert10_5089=true := by decide +kernel
def fastCert10_5090 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5090 : checkCertificateFast 10 5090 fastCert10_5090=true := by decide +kernel
def fastCert10_5091 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5091 : checkCertificateFast 10 5091 fastCert10_5091=true := by decide +kernel
def fastCert10_5092 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5092 : checkCertificateFast 10 5092 fastCert10_5092=true := by decide +kernel
def fastCert10_5093 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5093 : checkCertificateFast 10 5093 fastCert10_5093=true := by decide +kernel
def fastCert10_5094 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5094 : checkCertificateFast 10 5094 fastCert10_5094=true := by decide +kernel
def fastCert10_5095 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5095 : checkCertificateFast 10 5095 fastCert10_5095=true := by decide +kernel
def fastCert10_5096 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_5096 : checkCertificateFast 10 5096 fastCert10_5096=true := by decide +kernel
def fastCert10_5097 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5097 : checkCertificateFast 10 5097 fastCert10_5097=true := by decide +kernel
def fastCert10_5098 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_5098 : checkCertificateFast 10 5098 fastCert10_5098=true := by decide +kernel
def fastCert10_5099 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5099 : checkCertificateFast 10 5099 fastCert10_5099=true := by decide +kernel
def fastCert10_5100 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5100 : checkCertificateFast 10 5100 fastCert10_5100=true := by decide +kernel
def fastCert10_5101 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5101 : checkCertificateFast 10 5101 fastCert10_5101=true := by decide +kernel
def fastCert10_5102 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5102 : checkCertificateFast 10 5102 fastCert10_5102=true := by decide +kernel
def fastCert10_5103 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5103 : checkCertificateFast 10 5103 fastCert10_5103=true := by decide +kernel
def fastCert10_5104 : Certificate := ⟨28,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5104 : checkCertificateFast 10 5104 fastCert10_5104=true := by decide +kernel
def fastCert10_5105 : Certificate := ⟨28,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5105 : checkCertificateFast 10 5105 fastCert10_5105=true := by decide +kernel
def fastCert10_5106 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5106 : checkCertificateFast 10 5106 fastCert10_5106=true := by decide +kernel
def fastCert10_5107 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5107 : checkCertificateFast 10 5107 fastCert10_5107=true := by decide +kernel
def fastCert10_5108 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5108 : checkCertificateFast 10 5108 fastCert10_5108=true := by decide +kernel
def fastCert10_5109 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5109 : checkCertificateFast 10 5109 fastCert10_5109=true := by decide +kernel
def fastCert10_5110 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5110 : checkCertificateFast 10 5110 fastCert10_5110=true := by decide +kernel
def fastCert10_5111 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5111 : checkCertificateFast 10 5111 fastCert10_5111=true := by decide +kernel
def fastCert10_5112 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5112 : checkCertificateFast 10 5112 fastCert10_5112=true := by decide +kernel
def fastCert10_5113 : Certificate := ⟨23,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5113 : checkCertificateFast 10 5113 fastCert10_5113=true := by decide +kernel
def fastCert10_5114 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5114 : checkCertificateFast 10 5114 fastCert10_5114=true := by decide +kernel
def fastCert10_5115 : Certificate := ⟨23,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5115 : checkCertificateFast 10 5115 fastCert10_5115=true := by decide +kernel
def fastCert10_5116 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5116 : checkCertificateFast 10 5116 fastCert10_5116=true := by decide +kernel
def fastCert10_5117 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5117 : checkCertificateFast 10 5117 fastCert10_5117=true := by decide +kernel
def fastCert10_5118 : Certificate := ⟨28,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5118 : checkCertificateFast 10 5118 fastCert10_5118=true := by decide +kernel
def fastCert10_5119 : Certificate := ⟨4,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=1 then (-1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_5119 : checkCertificateFast 10 5119 fastCert10_5119=true := by decide +kernel
def fastCert10_5120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5120 : checkCertificateFast 10 5120 fastCert10_5120=true := by decide +kernel
def fastCert10_5121 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5121 : checkCertificateFast 10 5121 fastCert10_5121=true := by decide +kernel
def fastCert10_5122 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5122 : checkCertificateFast 10 5122 fastCert10_5122=true := by decide +kernel
def fastCert10_5123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5123 : checkCertificateFast 10 5123 fastCert10_5123=true := by decide +kernel
def fastCert10_5124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5124 : checkCertificateFast 10 5124 fastCert10_5124=true := by decide +kernel
def fastCert10_5125 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5125 : checkCertificateFast 10 5125 fastCert10_5125=true := by decide +kernel
def fastCert10_5126 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5126 : checkCertificateFast 10 5126 fastCert10_5126=true := by decide +kernel
def fastCert10_5127 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5127 : checkCertificateFast 10 5127 fastCert10_5127=true := by decide +kernel
def fastCert10_5128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5128 : checkCertificateFast 10 5128 fastCert10_5128=true := by decide +kernel
def fastCert10_5129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5129 : checkCertificateFast 10 5129 fastCert10_5129=true := by decide +kernel
def fastCert10_5130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5130 : checkCertificateFast 10 5130 fastCert10_5130=true := by decide +kernel
def fastCert10_5131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5131 : checkCertificateFast 10 5131 fastCert10_5131=true := by decide +kernel
def fastCert10_5132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5132 : checkCertificateFast 10 5132 fastCert10_5132=true := by decide +kernel
def fastCert10_5133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5133 : checkCertificateFast 10 5133 fastCert10_5133=true := by decide +kernel
def fastCert10_5134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5134 : checkCertificateFast 10 5134 fastCert10_5134=true := by decide +kernel
def fastCert10_5135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5135 : checkCertificateFast 10 5135 fastCert10_5135=true := by decide +kernel
def fastCert10_5136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5136 : checkCertificateFast 10 5136 fastCert10_5136=true := by decide +kernel
def fastCert10_5137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5137 : checkCertificateFast 10 5137 fastCert10_5137=true := by decide +kernel
def fastCert10_5138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_5138 : checkCertificateFast 10 5138 fastCert10_5138=true := by decide +kernel
def fastCert10_5139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5139 : checkCertificateFast 10 5139 fastCert10_5139=true := by decide +kernel
def fastCert10_5140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5140 : checkCertificateFast 10 5140 fastCert10_5140=true := by decide +kernel
def fastCert10_5141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5141 : checkCertificateFast 10 5141 fastCert10_5141=true := by decide +kernel
def fastCert10_5142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5142 : checkCertificateFast 10 5142 fastCert10_5142=true := by decide +kernel
def fastCert10_5143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5143 : checkCertificateFast 10 5143 fastCert10_5143=true := by decide +kernel
def fastCert10_5144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5144 : checkCertificateFast 10 5144 fastCert10_5144=true := by decide +kernel
def fastCert10_5145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5145 : checkCertificateFast 10 5145 fastCert10_5145=true := by decide +kernel
def fastCert10_5146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5146 : checkCertificateFast 10 5146 fastCert10_5146=true := by decide +kernel
def fastCert10_5147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5147 : checkCertificateFast 10 5147 fastCert10_5147=true := by decide +kernel
def fastCert10_5148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5148 : checkCertificateFast 10 5148 fastCert10_5148=true := by decide +kernel
def fastCert10_5149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5149 : checkCertificateFast 10 5149 fastCert10_5149=true := by decide +kernel
def fastCert10_5150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5150 : checkCertificateFast 10 5150 fastCert10_5150=true := by decide +kernel
def fastCert10_5151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5151 : checkCertificateFast 10 5151 fastCert10_5151=true := by decide +kernel
def fastCert10_5152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5152 : checkCertificateFast 10 5152 fastCert10_5152=true := by decide +kernel
def fastCert10_5153 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5153 : checkCertificateFast 10 5153 fastCert10_5153=true := by decide +kernel
def fastCert10_5154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5154 : checkCertificateFast 10 5154 fastCert10_5154=true := by decide +kernel
def fastCert10_5155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5155 : checkCertificateFast 10 5155 fastCert10_5155=true := by decide +kernel
def fastCert10_5156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5156 : checkCertificateFast 10 5156 fastCert10_5156=true := by decide +kernel
def fastCert10_5157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5157 : checkCertificateFast 10 5157 fastCert10_5157=true := by decide +kernel
def fastCert10_5158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5158 : checkCertificateFast 10 5158 fastCert10_5158=true := by decide +kernel
def fastCert10_5159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5159 : checkCertificateFast 10 5159 fastCert10_5159=true := by decide +kernel
def fastCert10_5160 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5160 : checkCertificateFast 10 5160 fastCert10_5160=true := by decide +kernel
def fastCert10_5161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5161 : checkCertificateFast 10 5161 fastCert10_5161=true := by decide +kernel
def fastCert10_5162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5162 : checkCertificateFast 10 5162 fastCert10_5162=true := by decide +kernel
def fastCert10_5163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5163 : checkCertificateFast 10 5163 fastCert10_5163=true := by decide +kernel
def fastCert10_5164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5164 : checkCertificateFast 10 5164 fastCert10_5164=true := by decide +kernel
def fastCert10_5165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5165 : checkCertificateFast 10 5165 fastCert10_5165=true := by decide +kernel
def fastCert10_5166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5166 : checkCertificateFast 10 5166 fastCert10_5166=true := by decide +kernel
def fastCert10_5167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5167 : checkCertificateFast 10 5167 fastCert10_5167=true := by decide +kernel
def fastCert10_5168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5168 : checkCertificateFast 10 5168 fastCert10_5168=true := by decide +kernel
def fastCert10_5169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5169 : checkCertificateFast 10 5169 fastCert10_5169=true := by decide +kernel
def fastCert10_5170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5170 : checkCertificateFast 10 5170 fastCert10_5170=true := by decide +kernel
def fastCert10_5171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5171 : checkCertificateFast 10 5171 fastCert10_5171=true := by decide +kernel
def fastCert10_5172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5172 : checkCertificateFast 10 5172 fastCert10_5172=true := by decide +kernel
def fastCert10_5173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5173 : checkCertificateFast 10 5173 fastCert10_5173=true := by decide +kernel
def fastCert10_5174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5174 : checkCertificateFast 10 5174 fastCert10_5174=true := by decide +kernel
def fastCert10_5175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5175 : checkCertificateFast 10 5175 fastCert10_5175=true := by decide +kernel
def fastCert10_5176 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5176 : checkCertificateFast 10 5176 fastCert10_5176=true := by decide +kernel
def fastCert10_5177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5177 : checkCertificateFast 10 5177 fastCert10_5177=true := by decide +kernel
def fastCert10_5178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5178 : checkCertificateFast 10 5178 fastCert10_5178=true := by decide +kernel
def fastCert10_5179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5179 : checkCertificateFast 10 5179 fastCert10_5179=true := by decide +kernel
def fastCert10_5180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5180 : checkCertificateFast 10 5180 fastCert10_5180=true := by decide +kernel
def fastCert10_5181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5181 : checkCertificateFast 10 5181 fastCert10_5181=true := by decide +kernel
def fastCert10_5182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5182 : checkCertificateFast 10 5182 fastCert10_5182=true := by decide +kernel
def fastCert10_5183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5183 : checkCertificateFast 10 5183 fastCert10_5183=true := by decide +kernel
def fastCert10_5184 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5184 : checkCertificateFast 10 5184 fastCert10_5184=true := by decide +kernel
def fastCert10_5185 : Certificate := ⟨12,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5185 : checkCertificateFast 10 5185 fastCert10_5185=true := by decide +kernel
def fastCert10_5186 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5186 : checkCertificateFast 10 5186 fastCert10_5186=true := by decide +kernel
def fastCert10_5187 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5187 : checkCertificateFast 10 5187 fastCert10_5187=true := by decide +kernel
def fastCert10_5188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5188 : checkCertificateFast 10 5188 fastCert10_5188=true := by decide +kernel
def fastCert10_5189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5189 : checkCertificateFast 10 5189 fastCert10_5189=true := by decide +kernel
def fastCert10_5190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5190 : checkCertificateFast 10 5190 fastCert10_5190=true := by decide +kernel
def fastCert10_5191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5191 : checkCertificateFast 10 5191 fastCert10_5191=true := by decide +kernel
def fastCert10_5192 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5192 : checkCertificateFast 10 5192 fastCert10_5192=true := by decide +kernel
def fastCert10_5193 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5193 : checkCertificateFast 10 5193 fastCert10_5193=true := by decide +kernel
def fastCert10_5194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5194 : checkCertificateFast 10 5194 fastCert10_5194=true := by decide +kernel
def fastCert10_5195 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5195 : checkCertificateFast 10 5195 fastCert10_5195=true := by decide +kernel
def fastCert10_5196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5196 : checkCertificateFast 10 5196 fastCert10_5196=true := by decide +kernel
def fastCert10_5197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5197 : checkCertificateFast 10 5197 fastCert10_5197=true := by decide +kernel
def fastCert10_5198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5198 : checkCertificateFast 10 5198 fastCert10_5198=true := by decide +kernel
def fastCert10_5199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5199 : checkCertificateFast 10 5199 fastCert10_5199=true := by decide +kernel
def fastCert10_5200 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5200 : checkCertificateFast 10 5200 fastCert10_5200=true := by decide +kernel
def fastCert10_5201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5201 : checkCertificateFast 10 5201 fastCert10_5201=true := by decide +kernel
def fastCert10_5202 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5202 : checkCertificateFast 10 5202 fastCert10_5202=true := by decide +kernel
def fastCert10_5203 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5203 : checkCertificateFast 10 5203 fastCert10_5203=true := by decide +kernel
def fastCert10_5204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5204 : checkCertificateFast 10 5204 fastCert10_5204=true := by decide +kernel
def fastCert10_5205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5205 : checkCertificateFast 10 5205 fastCert10_5205=true := by decide +kernel
def fastCert10_5206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5206 : checkCertificateFast 10 5206 fastCert10_5206=true := by decide +kernel
def fastCert10_5207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5207 : checkCertificateFast 10 5207 fastCert10_5207=true := by decide +kernel
def fastCert10_5208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5208 : checkCertificateFast 10 5208 fastCert10_5208=true := by decide +kernel
def fastCert10_5209 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5209 : checkCertificateFast 10 5209 fastCert10_5209=true := by decide +kernel
def fastCert10_5210 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5210 : checkCertificateFast 10 5210 fastCert10_5210=true := by decide +kernel
def fastCert10_5211 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5211 : checkCertificateFast 10 5211 fastCert10_5211=true := by decide +kernel
def fastCert10_5212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5212 : checkCertificateFast 10 5212 fastCert10_5212=true := by decide +kernel
def fastCert10_5213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5213 : checkCertificateFast 10 5213 fastCert10_5213=true := by decide +kernel
def fastCert10_5214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5214 : checkCertificateFast 10 5214 fastCert10_5214=true := by decide +kernel
def fastCert10_5215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5215 : checkCertificateFast 10 5215 fastCert10_5215=true := by decide +kernel
def fastCert10_5216 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5216 : checkCertificateFast 10 5216 fastCert10_5216=true := by decide +kernel
def fastCert10_5217 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5217 : checkCertificateFast 10 5217 fastCert10_5217=true := by decide +kernel
def fastCert10_5218 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5218 : checkCertificateFast 10 5218 fastCert10_5218=true := by decide +kernel
def fastCert10_5219 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5219 : checkCertificateFast 10 5219 fastCert10_5219=true := by decide +kernel
def fastCert10_5220 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5220 : checkCertificateFast 10 5220 fastCert10_5220=true := by decide +kernel
def fastCert10_5221 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5221 : checkCertificateFast 10 5221 fastCert10_5221=true := by decide +kernel
def fastCert10_5222 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5222 : checkCertificateFast 10 5222 fastCert10_5222=true := by decide +kernel
def fastCert10_5223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5223 : checkCertificateFast 10 5223 fastCert10_5223=true := by decide +kernel
def fastCert10_5224 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5224 : checkCertificateFast 10 5224 fastCert10_5224=true := by decide +kernel
def fastCert10_5225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5225 : checkCertificateFast 10 5225 fastCert10_5225=true := by decide +kernel
def fastCert10_5226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5226 : checkCertificateFast 10 5226 fastCert10_5226=true := by decide +kernel
def fastCert10_5227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5227 : checkCertificateFast 10 5227 fastCert10_5227=true := by decide +kernel
def fastCert10_5228 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5228 : checkCertificateFast 10 5228 fastCert10_5228=true := by decide +kernel
def fastCert10_5229 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5229 : checkCertificateFast 10 5229 fastCert10_5229=true := by decide +kernel
def fastCert10_5230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5230 : checkCertificateFast 10 5230 fastCert10_5230=true := by decide +kernel
def fastCert10_5231 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5231 : checkCertificateFast 10 5231 fastCert10_5231=true := by decide +kernel
def fastCert10_5232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5232 : checkCertificateFast 10 5232 fastCert10_5232=true := by decide +kernel
def fastCert10_5233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5233 : checkCertificateFast 10 5233 fastCert10_5233=true := by decide +kernel
def fastCert10_5234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5234 : checkCertificateFast 10 5234 fastCert10_5234=true := by decide +kernel
def fastCert10_5235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5235 : checkCertificateFast 10 5235 fastCert10_5235=true := by decide +kernel
def fastCert10_5236 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5236 : checkCertificateFast 10 5236 fastCert10_5236=true := by decide +kernel
def fastCert10_5237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5237 : checkCertificateFast 10 5237 fastCert10_5237=true := by decide +kernel
def fastCert10_5238 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5238 : checkCertificateFast 10 5238 fastCert10_5238=true := by decide +kernel
def fastCert10_5239 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5239 : checkCertificateFast 10 5239 fastCert10_5239=true := by decide +kernel
def fastCert10_5240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5240 : checkCertificateFast 10 5240 fastCert10_5240=true := by decide +kernel
def fastCert10_5241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5241 : checkCertificateFast 10 5241 fastCert10_5241=true := by decide +kernel
def fastCert10_5242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5242 : checkCertificateFast 10 5242 fastCert10_5242=true := by decide +kernel
def fastCert10_5243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5243 : checkCertificateFast 10 5243 fastCert10_5243=true := by decide +kernel
def fastCert10_5244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5244 : checkCertificateFast 10 5244 fastCert10_5244=true := by decide +kernel
def fastCert10_5245 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5245 : checkCertificateFast 10 5245 fastCert10_5245=true := by decide +kernel
def fastCert10_5246 : Certificate := ⟨12,fun t i => if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5246 : checkCertificateFast 10 5246 fastCert10_5246=true := by decide +kernel
def fastCert10_5247 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5247 : checkCertificateFast 10 5247 fastCert10_5247=true := by decide +kernel
def fastCert10_5248 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5248 : checkCertificateFast 10 5248 fastCert10_5248=true := by decide +kernel
def fastCert10_5249 : Certificate := ⟨14,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5249 : checkCertificateFast 10 5249 fastCert10_5249=true := by decide +kernel
def fastCert10_5250 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5250 : checkCertificateFast 10 5250 fastCert10_5250=true := by decide +kernel
def fastCert10_5251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5251 : checkCertificateFast 10 5251 fastCert10_5251=true := by decide +kernel
def fastCert10_5252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5252 : checkCertificateFast 10 5252 fastCert10_5252=true := by decide +kernel
def fastCert10_5253 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5253 : checkCertificateFast 10 5253 fastCert10_5253=true := by decide +kernel
def fastCert10_5254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5254 : checkCertificateFast 10 5254 fastCert10_5254=true := by decide +kernel
def fastCert10_5255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5255 : checkCertificateFast 10 5255 fastCert10_5255=true := by decide +kernel
def fastCert10_5256 : Certificate := ⟨37,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5256 : checkCertificateFast 10 5256 fastCert10_5256=true := by decide +kernel
def fastCert10_5257 : Certificate := ⟨25,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5257 : checkCertificateFast 10 5257 fastCert10_5257=true := by decide +kernel
def fastCert10_5258 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5258 : checkCertificateFast 10 5258 fastCert10_5258=true := by decide +kernel
def fastCert10_5259 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5259 : checkCertificateFast 10 5259 fastCert10_5259=true := by decide +kernel
def fastCert10_5260 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5260 : checkCertificateFast 10 5260 fastCert10_5260=true := by decide +kernel
def fastCert10_5261 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5261 : checkCertificateFast 10 5261 fastCert10_5261=true := by decide +kernel
def fastCert10_5262 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5262 : checkCertificateFast 10 5262 fastCert10_5262=true := by decide +kernel
def fastCert10_5263 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5263 : checkCertificateFast 10 5263 fastCert10_5263=true := by decide +kernel
def fastCert10_5264 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5264 : checkCertificateFast 10 5264 fastCert10_5264=true := by decide +kernel
def fastCert10_5265 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5265 : checkCertificateFast 10 5265 fastCert10_5265=true := by decide +kernel
def fastCert10_5266 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5266 : checkCertificateFast 10 5266 fastCert10_5266=true := by decide +kernel
def fastCert10_5267 : Certificate := ⟨12,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5267 : checkCertificateFast 10 5267 fastCert10_5267=true := by decide +kernel
def fastCert10_5268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5268 : checkCertificateFast 10 5268 fastCert10_5268=true := by decide +kernel
def fastCert10_5269 : Certificate := ⟨15,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5269 : checkCertificateFast 10 5269 fastCert10_5269=true := by decide +kernel
def fastCert10_5270 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5270 : checkCertificateFast 10 5270 fastCert10_5270=true := by decide +kernel
def fastCert10_5271 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5271 : checkCertificateFast 10 5271 fastCert10_5271=true := by decide +kernel
def fastCert10_5272 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5272 : checkCertificateFast 10 5272 fastCert10_5272=true := by decide +kernel
def fastCert10_5273 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5273 : checkCertificateFast 10 5273 fastCert10_5273=true := by decide +kernel
def fastCert10_5274 : Certificate := ⟨28,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5274 : checkCertificateFast 10 5274 fastCert10_5274=true := by decide +kernel
def fastCert10_5275 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5275 : checkCertificateFast 10 5275 fastCert10_5275=true := by decide +kernel
def fastCert10_5276 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5276 : checkCertificateFast 10 5276 fastCert10_5276=true := by decide +kernel
def fastCert10_5277 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5277 : checkCertificateFast 10 5277 fastCert10_5277=true := by decide +kernel
def fastCert10_5278 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5278 : checkCertificateFast 10 5278 fastCert10_5278=true := by decide +kernel
def fastCert10_5279 : Certificate := ⟨35,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5279 : checkCertificateFast 10 5279 fastCert10_5279=true := by decide +kernel
def fastCert10_5280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5280 : checkCertificateFast 10 5280 fastCert10_5280=true := by decide +kernel
def fastCert10_5281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5281 : checkCertificateFast 10 5281 fastCert10_5281=true := by decide +kernel
def fastCert10_5282 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5282 : checkCertificateFast 10 5282 fastCert10_5282=true := by decide +kernel
def fastCert10_5283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5283 : checkCertificateFast 10 5283 fastCert10_5283=true := by decide +kernel
def fastCert10_5284 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5284 : checkCertificateFast 10 5284 fastCert10_5284=true := by decide +kernel
def fastCert10_5285 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5285 : checkCertificateFast 10 5285 fastCert10_5285=true := by decide +kernel
def fastCert10_5286 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5286 : checkCertificateFast 10 5286 fastCert10_5286=true := by decide +kernel
def fastCert10_5287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5287 : checkCertificateFast 10 5287 fastCert10_5287=true := by decide +kernel
def fastCert10_5288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5288 : checkCertificateFast 10 5288 fastCert10_5288=true := by decide +kernel
def fastCert10_5289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5289 : checkCertificateFast 10 5289 fastCert10_5289=true := by decide +kernel
def fastCert10_5290 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5290 : checkCertificateFast 10 5290 fastCert10_5290=true := by decide +kernel
def fastCert10_5291 : Certificate := ⟨19,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5291 : checkCertificateFast 10 5291 fastCert10_5291=true := by decide +kernel
def fastCert10_5292 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5292 : checkCertificateFast 10 5292 fastCert10_5292=true := by decide +kernel
def fastCert10_5293 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5293 : checkCertificateFast 10 5293 fastCert10_5293=true := by decide +kernel
def fastCert10_5294 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5294 : checkCertificateFast 10 5294 fastCert10_5294=true := by decide +kernel
def fastCert10_5295 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5295 : checkCertificateFast 10 5295 fastCert10_5295=true := by decide +kernel
def fastCert10_5296 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5296 : checkCertificateFast 10 5296 fastCert10_5296=true := by decide +kernel
def fastCert10_5297 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5297 : checkCertificateFast 10 5297 fastCert10_5297=true := by decide +kernel
def fastCert10_5298 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5298 : checkCertificateFast 10 5298 fastCert10_5298=true := by decide +kernel
def fastCert10_5299 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5299 : checkCertificateFast 10 5299 fastCert10_5299=true := by decide +kernel
def fastCert10_5300 : Certificate := ⟨36,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5300 : checkCertificateFast 10 5300 fastCert10_5300=true := by decide +kernel
def fastCert10_5301 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5301 : checkCertificateFast 10 5301 fastCert10_5301=true := by decide +kernel
def fastCert10_5302 : Certificate := ⟨27,fun t i => if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5302 : checkCertificateFast 10 5302 fastCert10_5302=true := by decide +kernel
def fastCert10_5303 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5303 : checkCertificateFast 10 5303 fastCert10_5303=true := by decide +kernel
def fastCert10_5304 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5304 : checkCertificateFast 10 5304 fastCert10_5304=true := by decide +kernel
def fastCert10_5305 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5305 : checkCertificateFast 10 5305 fastCert10_5305=true := by decide +kernel
def fastCert10_5306 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5306 : checkCertificateFast 10 5306 fastCert10_5306=true := by decide +kernel
def fastCert10_5307 : Certificate := ⟨34,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5307 : checkCertificateFast 10 5307 fastCert10_5307=true := by decide +kernel
def fastCert10_5308 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5308 : checkCertificateFast 10 5308 fastCert10_5308=true := by decide +kernel
def fastCert10_5309 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5309 : checkCertificateFast 10 5309 fastCert10_5309=true := by decide +kernel
def fastCert10_5310 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5310 : checkCertificateFast 10 5310 fastCert10_5310=true := by decide +kernel
def fastCert10_5311 : Certificate := ⟨27,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5311 : checkCertificateFast 10 5311 fastCert10_5311=true := by decide +kernel
def fastCert10_5312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5312 : checkCertificateFast 10 5312 fastCert10_5312=true := by decide +kernel
def fastCert10_5313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5313 : checkCertificateFast 10 5313 fastCert10_5313=true := by decide +kernel
def fastCert10_5314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5314 : checkCertificateFast 10 5314 fastCert10_5314=true := by decide +kernel
def fastCert10_5315 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5315 : checkCertificateFast 10 5315 fastCert10_5315=true := by decide +kernel
def fastCert10_5316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5316 : checkCertificateFast 10 5316 fastCert10_5316=true := by decide +kernel
def fastCert10_5317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5317 : checkCertificateFast 10 5317 fastCert10_5317=true := by decide +kernel
def fastCert10_5318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5318 : checkCertificateFast 10 5318 fastCert10_5318=true := by decide +kernel
def fastCert10_5319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5319 : checkCertificateFast 10 5319 fastCert10_5319=true := by decide +kernel
def fastCert10_5320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5320 : checkCertificateFast 10 5320 fastCert10_5320=true := by decide +kernel
def fastCert10_5321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5321 : checkCertificateFast 10 5321 fastCert10_5321=true := by decide +kernel
def fastCert10_5322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5322 : checkCertificateFast 10 5322 fastCert10_5322=true := by decide +kernel
def fastCert10_5323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5323 : checkCertificateFast 10 5323 fastCert10_5323=true := by decide +kernel
def fastCert10_5324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5324 : checkCertificateFast 10 5324 fastCert10_5324=true := by decide +kernel
def fastCert10_5325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5325 : checkCertificateFast 10 5325 fastCert10_5325=true := by decide +kernel
def fastCert10_5326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5326 : checkCertificateFast 10 5326 fastCert10_5326=true := by decide +kernel
def fastCert10_5327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5327 : checkCertificateFast 10 5327 fastCert10_5327=true := by decide +kernel
def fastCert10_5328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5328 : checkCertificateFast 10 5328 fastCert10_5328=true := by decide +kernel
def fastCert10_5329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5329 : checkCertificateFast 10 5329 fastCert10_5329=true := by decide +kernel
def fastCert10_5330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-6) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (4) else if t=0 ∧ i=7 then (-4) else if t=0 ∧ i=9 then (-6) else if t=0 ∧ i=10 then (9) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (-6) else if t=0 ∧ i=14 then (6) else if t=0 ∧ i=15 then (6) else 0⟩
theorem fastCase10_5330 : checkCertificateFast 10 5330 fastCert10_5330=true := by decide +kernel
def fastCert10_5331 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5331 : checkCertificateFast 10 5331 fastCert10_5331=true := by decide +kernel
def fastCert10_5332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5332 : checkCertificateFast 10 5332 fastCert10_5332=true := by decide +kernel
def fastCert10_5333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5333 : checkCertificateFast 10 5333 fastCert10_5333=true := by decide +kernel
def fastCert10_5334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5334 : checkCertificateFast 10 5334 fastCert10_5334=true := by decide +kernel
def fastCert10_5335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5335 : checkCertificateFast 10 5335 fastCert10_5335=true := by decide +kernel
def fastCert10_5336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5336 : checkCertificateFast 10 5336 fastCert10_5336=true := by decide +kernel
def fastCert10_5337 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5337 : checkCertificateFast 10 5337 fastCert10_5337=true := by decide +kernel
def fastCert10_5338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5338 : checkCertificateFast 10 5338 fastCert10_5338=true := by decide +kernel
def fastCert10_5339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=16 then (-3) else 0⟩
theorem fastCase10_5339 : checkCertificateFast 10 5339 fastCert10_5339=true := by decide +kernel
def fastCert10_5340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5340 : checkCertificateFast 10 5340 fastCert10_5340=true := by decide +kernel
def fastCert10_5341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5341 : checkCertificateFast 10 5341 fastCert10_5341=true := by decide +kernel
def fastCert10_5342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5342 : checkCertificateFast 10 5342 fastCert10_5342=true := by decide +kernel
def fastCert10_5343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5343 : checkCertificateFast 10 5343 fastCert10_5343=true := by decide +kernel
def fastCert10_5344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5344 : checkCertificateFast 10 5344 fastCert10_5344=true := by decide +kernel
def fastCert10_5345 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5345 : checkCertificateFast 10 5345 fastCert10_5345=true := by decide +kernel
def fastCert10_5346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5346 : checkCertificateFast 10 5346 fastCert10_5346=true := by decide +kernel
def fastCert10_5347 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5347 : checkCertificateFast 10 5347 fastCert10_5347=true := by decide +kernel
def fastCert10_5348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5348 : checkCertificateFast 10 5348 fastCert10_5348=true := by decide +kernel
def fastCert10_5349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5349 : checkCertificateFast 10 5349 fastCert10_5349=true := by decide +kernel
def fastCert10_5350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5350 : checkCertificateFast 10 5350 fastCert10_5350=true := by decide +kernel
def fastCert10_5351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5351 : checkCertificateFast 10 5351 fastCert10_5351=true := by decide +kernel
def fastCert10_5352 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5352 : checkCertificateFast 10 5352 fastCert10_5352=true := by decide +kernel
def fastCert10_5353 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5353 : checkCertificateFast 10 5353 fastCert10_5353=true := by decide +kernel
def fastCert10_5354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5354 : checkCertificateFast 10 5354 fastCert10_5354=true := by decide +kernel
def fastCert10_5355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5355 : checkCertificateFast 10 5355 fastCert10_5355=true := by decide +kernel
def fastCert10_5356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5356 : checkCertificateFast 10 5356 fastCert10_5356=true := by decide +kernel
def fastCert10_5357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5357 : checkCertificateFast 10 5357 fastCert10_5357=true := by decide +kernel
def fastCert10_5358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5358 : checkCertificateFast 10 5358 fastCert10_5358=true := by decide +kernel
def fastCert10_5359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5359 : checkCertificateFast 10 5359 fastCert10_5359=true := by decide +kernel
def fastCert10_5360 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5360 : checkCertificateFast 10 5360 fastCert10_5360=true := by decide +kernel
def fastCert10_5361 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5361 : checkCertificateFast 10 5361 fastCert10_5361=true := by decide +kernel
def fastCert10_5362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (3) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5362 : checkCertificateFast 10 5362 fastCert10_5362=true := by decide +kernel
def fastCert10_5363 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5363 : checkCertificateFast 10 5363 fastCert10_5363=true := by decide +kernel
def fastCert10_5364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5364 : checkCertificateFast 10 5364 fastCert10_5364=true := by decide +kernel
def fastCert10_5365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5365 : checkCertificateFast 10 5365 fastCert10_5365=true := by decide +kernel
def fastCert10_5366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5366 : checkCertificateFast 10 5366 fastCert10_5366=true := by decide +kernel
def fastCert10_5367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5367 : checkCertificateFast 10 5367 fastCert10_5367=true := by decide +kernel
def fastCert10_5368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5368 : checkCertificateFast 10 5368 fastCert10_5368=true := by decide +kernel
def fastCert10_5369 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5369 : checkCertificateFast 10 5369 fastCert10_5369=true := by decide +kernel
def fastCert10_5370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5370 : checkCertificateFast 10 5370 fastCert10_5370=true := by decide +kernel
def fastCert10_5371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5371 : checkCertificateFast 10 5371 fastCert10_5371=true := by decide +kernel
def fastCert10_5372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5372 : checkCertificateFast 10 5372 fastCert10_5372=true := by decide +kernel
def fastCert10_5373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5373 : checkCertificateFast 10 5373 fastCert10_5373=true := by decide +kernel
def fastCert10_5374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5374 : checkCertificateFast 10 5374 fastCert10_5374=true := by decide +kernel
def fastCert10_5375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5375 : checkCertificateFast 10 5375 fastCert10_5375=true := by decide +kernel
def fastCert10_5376 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5376 : checkCertificateFast 10 5376 fastCert10_5376=true := by decide +kernel
def fastCert10_5377 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5377 : checkCertificateFast 10 5377 fastCert10_5377=true := by decide +kernel
def fastCert10_5378 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5378 : checkCertificateFast 10 5378 fastCert10_5378=true := by decide +kernel
def fastCert10_5379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5379 : checkCertificateFast 10 5379 fastCert10_5379=true := by decide +kernel
def fastCert10_5380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5380 : checkCertificateFast 10 5380 fastCert10_5380=true := by decide +kernel
def fastCert10_5381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5381 : checkCertificateFast 10 5381 fastCert10_5381=true := by decide +kernel
def fastCert10_5382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5382 : checkCertificateFast 10 5382 fastCert10_5382=true := by decide +kernel
def fastCert10_5383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5383 : checkCertificateFast 10 5383 fastCert10_5383=true := by decide +kernel
def fastCert10_5384 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5384 : checkCertificateFast 10 5384 fastCert10_5384=true := by decide +kernel
def fastCert10_5385 : Certificate := ⟨25,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5385 : checkCertificateFast 10 5385 fastCert10_5385=true := by decide +kernel
def fastCert10_5386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5386 : checkCertificateFast 10 5386 fastCert10_5386=true := by decide +kernel
def fastCert10_5387 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5387 : checkCertificateFast 10 5387 fastCert10_5387=true := by decide +kernel
def fastCert10_5388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5388 : checkCertificateFast 10 5388 fastCert10_5388=true := by decide +kernel
def fastCert10_5389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5389 : checkCertificateFast 10 5389 fastCert10_5389=true := by decide +kernel
def fastCert10_5390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5390 : checkCertificateFast 10 5390 fastCert10_5390=true := by decide +kernel
def fastCert10_5391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5391 : checkCertificateFast 10 5391 fastCert10_5391=true := by decide +kernel
def fastCert10_5392 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5392 : checkCertificateFast 10 5392 fastCert10_5392=true := by decide +kernel
def fastCert10_5393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5393 : checkCertificateFast 10 5393 fastCert10_5393=true := by decide +kernel
def fastCert10_5394 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5394 : checkCertificateFast 10 5394 fastCert10_5394=true := by decide +kernel
def fastCert10_5395 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5395 : checkCertificateFast 10 5395 fastCert10_5395=true := by decide +kernel
def fastCert10_5396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5396 : checkCertificateFast 10 5396 fastCert10_5396=true := by decide +kernel
def fastCert10_5397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5397 : checkCertificateFast 10 5397 fastCert10_5397=true := by decide +kernel
def fastCert10_5398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5398 : checkCertificateFast 10 5398 fastCert10_5398=true := by decide +kernel
def fastCert10_5399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5399 : checkCertificateFast 10 5399 fastCert10_5399=true := by decide +kernel
def fastCert10_5400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5400 : checkCertificateFast 10 5400 fastCert10_5400=true := by decide +kernel
def fastCert10_5401 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5401 : checkCertificateFast 10 5401 fastCert10_5401=true := by decide +kernel
def fastCert10_5402 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5402 : checkCertificateFast 10 5402 fastCert10_5402=true := by decide +kernel
def fastCert10_5403 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5403 : checkCertificateFast 10 5403 fastCert10_5403=true := by decide +kernel
def fastCert10_5404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5404 : checkCertificateFast 10 5404 fastCert10_5404=true := by decide +kernel
def fastCert10_5405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5405 : checkCertificateFast 10 5405 fastCert10_5405=true := by decide +kernel
def fastCert10_5406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5406 : checkCertificateFast 10 5406 fastCert10_5406=true := by decide +kernel
def fastCert10_5407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5407 : checkCertificateFast 10 5407 fastCert10_5407=true := by decide +kernel
def fastCert10_5408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5408 : checkCertificateFast 10 5408 fastCert10_5408=true := by decide +kernel
def fastCert10_5409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5409 : checkCertificateFast 10 5409 fastCert10_5409=true := by decide +kernel
def fastCert10_5410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5410 : checkCertificateFast 10 5410 fastCert10_5410=true := by decide +kernel
def fastCert10_5411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5411 : checkCertificateFast 10 5411 fastCert10_5411=true := by decide +kernel
def fastCert10_5412 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5412 : checkCertificateFast 10 5412 fastCert10_5412=true := by decide +kernel
def fastCert10_5413 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5413 : checkCertificateFast 10 5413 fastCert10_5413=true := by decide +kernel
def fastCert10_5414 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5414 : checkCertificateFast 10 5414 fastCert10_5414=true := by decide +kernel
def fastCert10_5415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5415 : checkCertificateFast 10 5415 fastCert10_5415=true := by decide +kernel
def fastCert10_5416 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5416 : checkCertificateFast 10 5416 fastCert10_5416=true := by decide +kernel
def fastCert10_5417 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5417 : checkCertificateFast 10 5417 fastCert10_5417=true := by decide +kernel
def fastCert10_5418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5418 : checkCertificateFast 10 5418 fastCert10_5418=true := by decide +kernel
def fastCert10_5419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5419 : checkCertificateFast 10 5419 fastCert10_5419=true := by decide +kernel
def fastCert10_5420 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5420 : checkCertificateFast 10 5420 fastCert10_5420=true := by decide +kernel
def fastCert10_5421 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5421 : checkCertificateFast 10 5421 fastCert10_5421=true := by decide +kernel
def fastCert10_5422 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5422 : checkCertificateFast 10 5422 fastCert10_5422=true := by decide +kernel
def fastCert10_5423 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5423 : checkCertificateFast 10 5423 fastCert10_5423=true := by decide +kernel
def fastCert10_5424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5424 : checkCertificateFast 10 5424 fastCert10_5424=true := by decide +kernel
def fastCert10_5425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5425 : checkCertificateFast 10 5425 fastCert10_5425=true := by decide +kernel
def fastCert10_5426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5426 : checkCertificateFast 10 5426 fastCert10_5426=true := by decide +kernel
def fastCert10_5427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5427 : checkCertificateFast 10 5427 fastCert10_5427=true := by decide +kernel
def fastCert10_5428 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5428 : checkCertificateFast 10 5428 fastCert10_5428=true := by decide +kernel
def fastCert10_5429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5429 : checkCertificateFast 10 5429 fastCert10_5429=true := by decide +kernel
def fastCert10_5430 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5430 : checkCertificateFast 10 5430 fastCert10_5430=true := by decide +kernel
def fastCert10_5431 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5431 : checkCertificateFast 10 5431 fastCert10_5431=true := by decide +kernel
def fastCert10_5432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5432 : checkCertificateFast 10 5432 fastCert10_5432=true := by decide +kernel
def fastCert10_5433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5433 : checkCertificateFast 10 5433 fastCert10_5433=true := by decide +kernel
def fastCert10_5434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5434 : checkCertificateFast 10 5434 fastCert10_5434=true := by decide +kernel
def fastCert10_5435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5435 : checkCertificateFast 10 5435 fastCert10_5435=true := by decide +kernel
def fastCert10_5436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5436 : checkCertificateFast 10 5436 fastCert10_5436=true := by decide +kernel
def fastCert10_5437 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5437 : checkCertificateFast 10 5437 fastCert10_5437=true := by decide +kernel
def fastCert10_5438 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5438 : checkCertificateFast 10 5438 fastCert10_5438=true := by decide +kernel
def fastCert10_5439 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5439 : checkCertificateFast 10 5439 fastCert10_5439=true := by decide +kernel
def fastCert10_5440 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5440 : checkCertificateFast 10 5440 fastCert10_5440=true := by decide +kernel
def fastCert10_5441 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5441 : checkCertificateFast 10 5441 fastCert10_5441=true := by decide +kernel
def fastCert10_5442 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5442 : checkCertificateFast 10 5442 fastCert10_5442=true := by decide +kernel
def fastCert10_5443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5443 : checkCertificateFast 10 5443 fastCert10_5443=true := by decide +kernel
def fastCert10_5444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5444 : checkCertificateFast 10 5444 fastCert10_5444=true := by decide +kernel
def fastCert10_5445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5445 : checkCertificateFast 10 5445 fastCert10_5445=true := by decide +kernel
def fastCert10_5446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5446 : checkCertificateFast 10 5446 fastCert10_5446=true := by decide +kernel
def fastCert10_5447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5447 : checkCertificateFast 10 5447 fastCert10_5447=true := by decide +kernel
def fastCert10_5448 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5448 : checkCertificateFast 10 5448 fastCert10_5448=true := by decide +kernel
def fastCert10_5449 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5449 : checkCertificateFast 10 5449 fastCert10_5449=true := by decide +kernel
def fastCert10_5450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5450 : checkCertificateFast 10 5450 fastCert10_5450=true := by decide +kernel
def fastCert10_5451 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5451 : checkCertificateFast 10 5451 fastCert10_5451=true := by decide +kernel
def fastCert10_5452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5452 : checkCertificateFast 10 5452 fastCert10_5452=true := by decide +kernel
def fastCert10_5453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5453 : checkCertificateFast 10 5453 fastCert10_5453=true := by decide +kernel
def fastCert10_5454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5454 : checkCertificateFast 10 5454 fastCert10_5454=true := by decide +kernel
def fastCert10_5455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5455 : checkCertificateFast 10 5455 fastCert10_5455=true := by decide +kernel
def fastCert10_5456 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5456 : checkCertificateFast 10 5456 fastCert10_5456=true := by decide +kernel
def fastCert10_5457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5457 : checkCertificateFast 10 5457 fastCert10_5457=true := by decide +kernel
def fastCert10_5458 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5458 : checkCertificateFast 10 5458 fastCert10_5458=true := by decide +kernel
def fastCert10_5459 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5459 : checkCertificateFast 10 5459 fastCert10_5459=true := by decide +kernel
def fastCert10_5460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5460 : checkCertificateFast 10 5460 fastCert10_5460=true := by decide +kernel
def fastCert10_5461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5461 : checkCertificateFast 10 5461 fastCert10_5461=true := by decide +kernel
def fastCert10_5462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5462 : checkCertificateFast 10 5462 fastCert10_5462=true := by decide +kernel
def fastCert10_5463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5463 : checkCertificateFast 10 5463 fastCert10_5463=true := by decide +kernel
def fastCert10_5464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5464 : checkCertificateFast 10 5464 fastCert10_5464=true := by decide +kernel
def fastCert10_5465 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5465 : checkCertificateFast 10 5465 fastCert10_5465=true := by decide +kernel
def fastCert10_5466 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5466 : checkCertificateFast 10 5466 fastCert10_5466=true := by decide +kernel
def fastCert10_5467 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5467 : checkCertificateFast 10 5467 fastCert10_5467=true := by decide +kernel
def fastCert10_5468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5468 : checkCertificateFast 10 5468 fastCert10_5468=true := by decide +kernel
def fastCert10_5469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5469 : checkCertificateFast 10 5469 fastCert10_5469=true := by decide +kernel
def fastCert10_5470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5470 : checkCertificateFast 10 5470 fastCert10_5470=true := by decide +kernel
def fastCert10_5471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5471 : checkCertificateFast 10 5471 fastCert10_5471=true := by decide +kernel
def fastCert10_5472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5472 : checkCertificateFast 10 5472 fastCert10_5472=true := by decide +kernel
def fastCert10_5473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5473 : checkCertificateFast 10 5473 fastCert10_5473=true := by decide +kernel
def fastCert10_5474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5474 : checkCertificateFast 10 5474 fastCert10_5474=true := by decide +kernel
def fastCert10_5475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5475 : checkCertificateFast 10 5475 fastCert10_5475=true := by decide +kernel
def fastCert10_5476 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5476 : checkCertificateFast 10 5476 fastCert10_5476=true := by decide +kernel
def fastCert10_5477 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5477 : checkCertificateFast 10 5477 fastCert10_5477=true := by decide +kernel
def fastCert10_5478 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5478 : checkCertificateFast 10 5478 fastCert10_5478=true := by decide +kernel
def fastCert10_5479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5479 : checkCertificateFast 10 5479 fastCert10_5479=true := by decide +kernel
def fastCert10_5480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5480 : checkCertificateFast 10 5480 fastCert10_5480=true := by decide +kernel
def fastCert10_5481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5481 : checkCertificateFast 10 5481 fastCert10_5481=true := by decide +kernel
def fastCert10_5482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5482 : checkCertificateFast 10 5482 fastCert10_5482=true := by decide +kernel
def fastCert10_5483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5483 : checkCertificateFast 10 5483 fastCert10_5483=true := by decide +kernel
def fastCert10_5484 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5484 : checkCertificateFast 10 5484 fastCert10_5484=true := by decide +kernel
def fastCert10_5485 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5485 : checkCertificateFast 10 5485 fastCert10_5485=true := by decide +kernel
def fastCert10_5486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5486 : checkCertificateFast 10 5486 fastCert10_5486=true := by decide +kernel
def fastCert10_5487 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5487 : checkCertificateFast 10 5487 fastCert10_5487=true := by decide +kernel
def fastCert10_5488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5488 : checkCertificateFast 10 5488 fastCert10_5488=true := by decide +kernel
def fastCert10_5489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5489 : checkCertificateFast 10 5489 fastCert10_5489=true := by decide +kernel
def fastCert10_5490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5490 : checkCertificateFast 10 5490 fastCert10_5490=true := by decide +kernel
def fastCert10_5491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5491 : checkCertificateFast 10 5491 fastCert10_5491=true := by decide +kernel
def fastCert10_5492 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5492 : checkCertificateFast 10 5492 fastCert10_5492=true := by decide +kernel
def fastCert10_5493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5493 : checkCertificateFast 10 5493 fastCert10_5493=true := by decide +kernel
def fastCert10_5494 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5494 : checkCertificateFast 10 5494 fastCert10_5494=true := by decide +kernel
def fastCert10_5495 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5495 : checkCertificateFast 10 5495 fastCert10_5495=true := by decide +kernel
def fastCert10_5496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5496 : checkCertificateFast 10 5496 fastCert10_5496=true := by decide +kernel
def fastCert10_5497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5497 : checkCertificateFast 10 5497 fastCert10_5497=true := by decide +kernel
def fastCert10_5498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5498 : checkCertificateFast 10 5498 fastCert10_5498=true := by decide +kernel
def fastCert10_5499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5499 : checkCertificateFast 10 5499 fastCert10_5499=true := by decide +kernel
def fastCert10_5500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5500 : checkCertificateFast 10 5500 fastCert10_5500=true := by decide +kernel
def fastCert10_5501 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5501 : checkCertificateFast 10 5501 fastCert10_5501=true := by decide +kernel
def fastCert10_5502 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5502 : checkCertificateFast 10 5502 fastCert10_5502=true := by decide +kernel
def fastCert10_5503 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5503 : checkCertificateFast 10 5503 fastCert10_5503=true := by decide +kernel
def fastCert10_5504 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5504 : checkCertificateFast 10 5504 fastCert10_5504=true := by decide +kernel
def fastCert10_5505 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5505 : checkCertificateFast 10 5505 fastCert10_5505=true := by decide +kernel
def fastCert10_5506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5506 : checkCertificateFast 10 5506 fastCert10_5506=true := by decide +kernel
def fastCert10_5507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5507 : checkCertificateFast 10 5507 fastCert10_5507=true := by decide +kernel
def fastCert10_5508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5508 : checkCertificateFast 10 5508 fastCert10_5508=true := by decide +kernel
def fastCert10_5509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5509 : checkCertificateFast 10 5509 fastCert10_5509=true := by decide +kernel
def fastCert10_5510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5510 : checkCertificateFast 10 5510 fastCert10_5510=true := by decide +kernel
def fastCert10_5511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5511 : checkCertificateFast 10 5511 fastCert10_5511=true := by decide +kernel
def fastCert10_5512 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5512 : checkCertificateFast 10 5512 fastCert10_5512=true := by decide +kernel
def fastCert10_5513 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5513 : checkCertificateFast 10 5513 fastCert10_5513=true := by decide +kernel
def fastCert10_5514 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5514 : checkCertificateFast 10 5514 fastCert10_5514=true := by decide +kernel
def fastCert10_5515 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5515 : checkCertificateFast 10 5515 fastCert10_5515=true := by decide +kernel
def fastCert10_5516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5516 : checkCertificateFast 10 5516 fastCert10_5516=true := by decide +kernel
def fastCert10_5517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5517 : checkCertificateFast 10 5517 fastCert10_5517=true := by decide +kernel
def fastCert10_5518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5518 : checkCertificateFast 10 5518 fastCert10_5518=true := by decide +kernel
def fastCert10_5519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5519 : checkCertificateFast 10 5519 fastCert10_5519=true := by decide +kernel
def fastCert10_5520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5520 : checkCertificateFast 10 5520 fastCert10_5520=true := by decide +kernel
def fastCert10_5521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5521 : checkCertificateFast 10 5521 fastCert10_5521=true := by decide +kernel
def fastCert10_5522 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5522 : checkCertificateFast 10 5522 fastCert10_5522=true := by decide +kernel
def fastCert10_5523 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5523 : checkCertificateFast 10 5523 fastCert10_5523=true := by decide +kernel
def fastCert10_5524 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5524 : checkCertificateFast 10 5524 fastCert10_5524=true := by decide +kernel
def fastCert10_5525 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5525 : checkCertificateFast 10 5525 fastCert10_5525=true := by decide +kernel
def fastCert10_5526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5526 : checkCertificateFast 10 5526 fastCert10_5526=true := by decide +kernel
def fastCert10_5527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5527 : checkCertificateFast 10 5527 fastCert10_5527=true := by decide +kernel
def fastCert10_5528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5528 : checkCertificateFast 10 5528 fastCert10_5528=true := by decide +kernel
def fastCert10_5529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5529 : checkCertificateFast 10 5529 fastCert10_5529=true := by decide +kernel
def fastCert10_5530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5530 : checkCertificateFast 10 5530 fastCert10_5530=true := by decide +kernel
def fastCert10_5531 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_5531 : checkCertificateFast 10 5531 fastCert10_5531=true := by decide +kernel
def fastCert10_5532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5532 : checkCertificateFast 10 5532 fastCert10_5532=true := by decide +kernel
def fastCert10_5533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5533 : checkCertificateFast 10 5533 fastCert10_5533=true := by decide +kernel
def fastCert10_5534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5534 : checkCertificateFast 10 5534 fastCert10_5534=true := by decide +kernel
def fastCert10_5535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5535 : checkCertificateFast 10 5535 fastCert10_5535=true := by decide +kernel
def fastCert10_5536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5536 : checkCertificateFast 10 5536 fastCert10_5536=true := by decide +kernel
def fastCert10_5537 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5537 : checkCertificateFast 10 5537 fastCert10_5537=true := by decide +kernel
def fastCert10_5538 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5538 : checkCertificateFast 10 5538 fastCert10_5538=true := by decide +kernel
def fastCert10_5539 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5539 : checkCertificateFast 10 5539 fastCert10_5539=true := by decide +kernel
def fastCert10_5540 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5540 : checkCertificateFast 10 5540 fastCert10_5540=true := by decide +kernel
def fastCert10_5541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5541 : checkCertificateFast 10 5541 fastCert10_5541=true := by decide +kernel
def fastCert10_5542 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5542 : checkCertificateFast 10 5542 fastCert10_5542=true := by decide +kernel
def fastCert10_5543 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5543 : checkCertificateFast 10 5543 fastCert10_5543=true := by decide +kernel
def fastCert10_5544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5544 : checkCertificateFast 10 5544 fastCert10_5544=true := by decide +kernel
def fastCert10_5545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5545 : checkCertificateFast 10 5545 fastCert10_5545=true := by decide +kernel
def fastCert10_5546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5546 : checkCertificateFast 10 5546 fastCert10_5546=true := by decide +kernel
def fastCert10_5547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5547 : checkCertificateFast 10 5547 fastCert10_5547=true := by decide +kernel
def fastCert10_5548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5548 : checkCertificateFast 10 5548 fastCert10_5548=true := by decide +kernel
def fastCert10_5549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5549 : checkCertificateFast 10 5549 fastCert10_5549=true := by decide +kernel
def fastCert10_5550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5550 : checkCertificateFast 10 5550 fastCert10_5550=true := by decide +kernel
def fastCert10_5551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5551 : checkCertificateFast 10 5551 fastCert10_5551=true := by decide +kernel
def fastCert10_5552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5552 : checkCertificateFast 10 5552 fastCert10_5552=true := by decide +kernel
def fastCert10_5553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5553 : checkCertificateFast 10 5553 fastCert10_5553=true := by decide +kernel
def fastCert10_5554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5554 : checkCertificateFast 10 5554 fastCert10_5554=true := by decide +kernel
def fastCert10_5555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5555 : checkCertificateFast 10 5555 fastCert10_5555=true := by decide +kernel
def fastCert10_5556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5556 : checkCertificateFast 10 5556 fastCert10_5556=true := by decide +kernel
def fastCert10_5557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5557 : checkCertificateFast 10 5557 fastCert10_5557=true := by decide +kernel
def fastCert10_5558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5558 : checkCertificateFast 10 5558 fastCert10_5558=true := by decide +kernel
def fastCert10_5559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5559 : checkCertificateFast 10 5559 fastCert10_5559=true := by decide +kernel
def fastCert10_5560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5560 : checkCertificateFast 10 5560 fastCert10_5560=true := by decide +kernel
def fastCert10_5561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5561 : checkCertificateFast 10 5561 fastCert10_5561=true := by decide +kernel
def fastCert10_5562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5562 : checkCertificateFast 10 5562 fastCert10_5562=true := by decide +kernel
def fastCert10_5563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5563 : checkCertificateFast 10 5563 fastCert10_5563=true := by decide +kernel
def fastCert10_5564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5564 : checkCertificateFast 10 5564 fastCert10_5564=true := by decide +kernel
def fastCert10_5565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5565 : checkCertificateFast 10 5565 fastCert10_5565=true := by decide +kernel
def fastCert10_5566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5566 : checkCertificateFast 10 5566 fastCert10_5566=true := by decide +kernel
def fastCert10_5567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5567 : checkCertificateFast 10 5567 fastCert10_5567=true := by decide +kernel
def fastCert10_5568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5568 : checkCertificateFast 10 5568 fastCert10_5568=true := by decide +kernel
def fastCert10_5569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5569 : checkCertificateFast 10 5569 fastCert10_5569=true := by decide +kernel
def fastCert10_5570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5570 : checkCertificateFast 10 5570 fastCert10_5570=true := by decide +kernel
def fastCert10_5571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5571 : checkCertificateFast 10 5571 fastCert10_5571=true := by decide +kernel
def fastCert10_5572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5572 : checkCertificateFast 10 5572 fastCert10_5572=true := by decide +kernel
def fastCert10_5573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5573 : checkCertificateFast 10 5573 fastCert10_5573=true := by decide +kernel
def fastCert10_5574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5574 : checkCertificateFast 10 5574 fastCert10_5574=true := by decide +kernel
def fastCert10_5575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5575 : checkCertificateFast 10 5575 fastCert10_5575=true := by decide +kernel
def fastCert10_5576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5576 : checkCertificateFast 10 5576 fastCert10_5576=true := by decide +kernel
def fastCert10_5577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5577 : checkCertificateFast 10 5577 fastCert10_5577=true := by decide +kernel
def fastCert10_5578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5578 : checkCertificateFast 10 5578 fastCert10_5578=true := by decide +kernel
def fastCert10_5579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5579 : checkCertificateFast 10 5579 fastCert10_5579=true := by decide +kernel
def fastCert10_5580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5580 : checkCertificateFast 10 5580 fastCert10_5580=true := by decide +kernel
def fastCert10_5581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5581 : checkCertificateFast 10 5581 fastCert10_5581=true := by decide +kernel
def fastCert10_5582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5582 : checkCertificateFast 10 5582 fastCert10_5582=true := by decide +kernel
def fastCert10_5583 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5583 : checkCertificateFast 10 5583 fastCert10_5583=true := by decide +kernel
def fastCert10_5584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5584 : checkCertificateFast 10 5584 fastCert10_5584=true := by decide +kernel
def fastCert10_5585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5585 : checkCertificateFast 10 5585 fastCert10_5585=true := by decide +kernel
def fastCert10_5586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5586 : checkCertificateFast 10 5586 fastCert10_5586=true := by decide +kernel
def fastCert10_5587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5587 : checkCertificateFast 10 5587 fastCert10_5587=true := by decide +kernel
def fastCert10_5588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5588 : checkCertificateFast 10 5588 fastCert10_5588=true := by decide +kernel
def fastCert10_5589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5589 : checkCertificateFast 10 5589 fastCert10_5589=true := by decide +kernel
def fastCert10_5590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5590 : checkCertificateFast 10 5590 fastCert10_5590=true := by decide +kernel
def fastCert10_5591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5591 : checkCertificateFast 10 5591 fastCert10_5591=true := by decide +kernel
def fastCert10_5592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5592 : checkCertificateFast 10 5592 fastCert10_5592=true := by decide +kernel
def fastCert10_5593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5593 : checkCertificateFast 10 5593 fastCert10_5593=true := by decide +kernel
def fastCert10_5594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5594 : checkCertificateFast 10 5594 fastCert10_5594=true := by decide +kernel
def fastCert10_5595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5595 : checkCertificateFast 10 5595 fastCert10_5595=true := by decide +kernel
def fastCert10_5596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5596 : checkCertificateFast 10 5596 fastCert10_5596=true := by decide +kernel
def fastCert10_5597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5597 : checkCertificateFast 10 5597 fastCert10_5597=true := by decide +kernel
def fastCert10_5598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5598 : checkCertificateFast 10 5598 fastCert10_5598=true := by decide +kernel
def fastCert10_5599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5599 : checkCertificateFast 10 5599 fastCert10_5599=true := by decide +kernel
def fastCert10_5600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5600 : checkCertificateFast 10 5600 fastCert10_5600=true := by decide +kernel
def fastCert10_5601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5601 : checkCertificateFast 10 5601 fastCert10_5601=true := by decide +kernel
def fastCert10_5602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5602 : checkCertificateFast 10 5602 fastCert10_5602=true := by decide +kernel
def fastCert10_5603 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5603 : checkCertificateFast 10 5603 fastCert10_5603=true := by decide +kernel
def fastCert10_5604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5604 : checkCertificateFast 10 5604 fastCert10_5604=true := by decide +kernel
def fastCert10_5605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5605 : checkCertificateFast 10 5605 fastCert10_5605=true := by decide +kernel
def fastCert10_5606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5606 : checkCertificateFast 10 5606 fastCert10_5606=true := by decide +kernel
def fastCert10_5607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5607 : checkCertificateFast 10 5607 fastCert10_5607=true := by decide +kernel
def fastCert10_5608 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5608 : checkCertificateFast 10 5608 fastCert10_5608=true := by decide +kernel
def fastCert10_5609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5609 : checkCertificateFast 10 5609 fastCert10_5609=true := by decide +kernel
def fastCert10_5610 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5610 : checkCertificateFast 10 5610 fastCert10_5610=true := by decide +kernel
def fastCert10_5611 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5611 : checkCertificateFast 10 5611 fastCert10_5611=true := by decide +kernel
def fastCert10_5612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5612 : checkCertificateFast 10 5612 fastCert10_5612=true := by decide +kernel
def fastCert10_5613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5613 : checkCertificateFast 10 5613 fastCert10_5613=true := by decide +kernel
def fastCert10_5614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5614 : checkCertificateFast 10 5614 fastCert10_5614=true := by decide +kernel
def fastCert10_5615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5615 : checkCertificateFast 10 5615 fastCert10_5615=true := by decide +kernel
def fastCert10_5616 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5616 : checkCertificateFast 10 5616 fastCert10_5616=true := by decide +kernel
def fastCert10_5617 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5617 : checkCertificateFast 10 5617 fastCert10_5617=true := by decide +kernel
def fastCert10_5618 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5618 : checkCertificateFast 10 5618 fastCert10_5618=true := by decide +kernel
def fastCert10_5619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5619 : checkCertificateFast 10 5619 fastCert10_5619=true := by decide +kernel
def fastCert10_5620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5620 : checkCertificateFast 10 5620 fastCert10_5620=true := by decide +kernel
def fastCert10_5621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5621 : checkCertificateFast 10 5621 fastCert10_5621=true := by decide +kernel
def fastCert10_5622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5622 : checkCertificateFast 10 5622 fastCert10_5622=true := by decide +kernel
def fastCert10_5623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5623 : checkCertificateFast 10 5623 fastCert10_5623=true := by decide +kernel
def fastCert10_5624 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5624 : checkCertificateFast 10 5624 fastCert10_5624=true := by decide +kernel
def fastCert10_5625 : Certificate := ⟨12,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5625 : checkCertificateFast 10 5625 fastCert10_5625=true := by decide +kernel
def fastCert10_5626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5626 : checkCertificateFast 10 5626 fastCert10_5626=true := by decide +kernel
def fastCert10_5627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5627 : checkCertificateFast 10 5627 fastCert10_5627=true := by decide +kernel
def fastCert10_5628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5628 : checkCertificateFast 10 5628 fastCert10_5628=true := by decide +kernel
def fastCert10_5629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5629 : checkCertificateFast 10 5629 fastCert10_5629=true := by decide +kernel
def fastCert10_5630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5630 : checkCertificateFast 10 5630 fastCert10_5630=true := by decide +kernel
def fastCert10_5631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5631 : checkCertificateFast 10 5631 fastCert10_5631=true := by decide +kernel
def fastCert10_5632 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5632 : checkCertificateFast 10 5632 fastCert10_5632=true := by decide +kernel
def fastCert10_5633 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5633 : checkCertificateFast 10 5633 fastCert10_5633=true := by decide +kernel
def fastCert10_5634 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5634 : checkCertificateFast 10 5634 fastCert10_5634=true := by decide +kernel
def fastCert10_5635 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5635 : checkCertificateFast 10 5635 fastCert10_5635=true := by decide +kernel
def fastCert10_5636 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5636 : checkCertificateFast 10 5636 fastCert10_5636=true := by decide +kernel
def fastCert10_5637 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5637 : checkCertificateFast 10 5637 fastCert10_5637=true := by decide +kernel
def fastCert10_5638 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5638 : checkCertificateFast 10 5638 fastCert10_5638=true := by decide +kernel
def fastCert10_5639 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5639 : checkCertificateFast 10 5639 fastCert10_5639=true := by decide +kernel
def fastCert10_5640 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5640 : checkCertificateFast 10 5640 fastCert10_5640=true := by decide +kernel
def fastCert10_5641 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5641 : checkCertificateFast 10 5641 fastCert10_5641=true := by decide +kernel
def fastCert10_5642 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5642 : checkCertificateFast 10 5642 fastCert10_5642=true := by decide +kernel
def fastCert10_5643 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5643 : checkCertificateFast 10 5643 fastCert10_5643=true := by decide +kernel
def fastCert10_5644 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5644 : checkCertificateFast 10 5644 fastCert10_5644=true := by decide +kernel
def fastCert10_5645 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5645 : checkCertificateFast 10 5645 fastCert10_5645=true := by decide +kernel
def fastCert10_5646 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5646 : checkCertificateFast 10 5646 fastCert10_5646=true := by decide +kernel
def fastCert10_5647 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5647 : checkCertificateFast 10 5647 fastCert10_5647=true := by decide +kernel
def fastCert10_5648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5648 : checkCertificateFast 10 5648 fastCert10_5648=true := by decide +kernel
def fastCert10_5649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5649 : checkCertificateFast 10 5649 fastCert10_5649=true := by decide +kernel
def fastCert10_5650 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5650 : checkCertificateFast 10 5650 fastCert10_5650=true := by decide +kernel
def fastCert10_5651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5651 : checkCertificateFast 10 5651 fastCert10_5651=true := by decide +kernel
def fastCert10_5652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5652 : checkCertificateFast 10 5652 fastCert10_5652=true := by decide +kernel
def fastCert10_5653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (3) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5653 : checkCertificateFast 10 5653 fastCert10_5653=true := by decide +kernel
def fastCert10_5654 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5654 : checkCertificateFast 10 5654 fastCert10_5654=true := by decide +kernel
def fastCert10_5655 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5655 : checkCertificateFast 10 5655 fastCert10_5655=true := by decide +kernel
def fastCert10_5656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5656 : checkCertificateFast 10 5656 fastCert10_5656=true := by decide +kernel
def fastCert10_5657 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_5657 : checkCertificateFast 10 5657 fastCert10_5657=true := by decide +kernel
def fastCert10_5658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5658 : checkCertificateFast 10 5658 fastCert10_5658=true := by decide +kernel
def fastCert10_5659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5659 : checkCertificateFast 10 5659 fastCert10_5659=true := by decide +kernel
def fastCert10_5660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5660 : checkCertificateFast 10 5660 fastCert10_5660=true := by decide +kernel
def fastCert10_5661 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5661 : checkCertificateFast 10 5661 fastCert10_5661=true := by decide +kernel
def fastCert10_5662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5662 : checkCertificateFast 10 5662 fastCert10_5662=true := by decide +kernel
def fastCert10_5663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5663 : checkCertificateFast 10 5663 fastCert10_5663=true := by decide +kernel
def fastCert10_5664 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_5664 : checkCertificateFast 10 5664 fastCert10_5664=true := by decide +kernel
def fastCert10_5665 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5665 : checkCertificateFast 10 5665 fastCert10_5665=true := by decide +kernel
def fastCert10_5666 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_5666 : checkCertificateFast 10 5666 fastCert10_5666=true := by decide +kernel
def fastCert10_5667 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5667 : checkCertificateFast 10 5667 fastCert10_5667=true := by decide +kernel
def fastCert10_5668 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5668 : checkCertificateFast 10 5668 fastCert10_5668=true := by decide +kernel
def fastCert10_5669 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5669 : checkCertificateFast 10 5669 fastCert10_5669=true := by decide +kernel
def fastCert10_5670 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5670 : checkCertificateFast 10 5670 fastCert10_5670=true := by decide +kernel
def fastCert10_5671 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5671 : checkCertificateFast 10 5671 fastCert10_5671=true := by decide +kernel
def fastCert10_5672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-4) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-3) else 0⟩
theorem fastCase10_5672 : checkCertificateFast 10 5672 fastCert10_5672=true := by decide +kernel
def fastCert10_5673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5673 : checkCertificateFast 10 5673 fastCert10_5673=true := by decide +kernel
def fastCert10_5674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-4) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-3) else 0⟩
theorem fastCase10_5674 : checkCertificateFast 10 5674 fastCert10_5674=true := by decide +kernel
def fastCert10_5675 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5675 : checkCertificateFast 10 5675 fastCert10_5675=true := by decide +kernel
def fastCert10_5676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5676 : checkCertificateFast 10 5676 fastCert10_5676=true := by decide +kernel
def fastCert10_5677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5677 : checkCertificateFast 10 5677 fastCert10_5677=true := by decide +kernel
def fastCert10_5678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5678 : checkCertificateFast 10 5678 fastCert10_5678=true := by decide +kernel
def fastCert10_5679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5679 : checkCertificateFast 10 5679 fastCert10_5679=true := by decide +kernel
def fastCert10_5680 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (4) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-8) else if t=0 ∧ i=6 then (5) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (5) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (4) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=16 then (-5) else 0⟩
theorem fastCase10_5680 : checkCertificateFast 10 5680 fastCert10_5680=true := by decide +kernel
def fastCert10_5681 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5681 : checkCertificateFast 10 5681 fastCert10_5681=true := by decide +kernel
def fastCert10_5682 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5682 : checkCertificateFast 10 5682 fastCert10_5682=true := by decide +kernel
def fastCert10_5683 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5683 : checkCertificateFast 10 5683 fastCert10_5683=true := by decide +kernel
def fastCert10_5684 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5684 : checkCertificateFast 10 5684 fastCert10_5684=true := by decide +kernel
def fastCert10_5685 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5685 : checkCertificateFast 10 5685 fastCert10_5685=true := by decide +kernel
def fastCert10_5686 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5686 : checkCertificateFast 10 5686 fastCert10_5686=true := by decide +kernel
def fastCert10_5687 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5687 : checkCertificateFast 10 5687 fastCert10_5687=true := by decide +kernel
def fastCert10_5688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-4) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=16 then (3) else 0⟩
theorem fastCase10_5688 : checkCertificateFast 10 5688 fastCert10_5688=true := by decide +kernel
def fastCert10_5689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5689 : checkCertificateFast 10 5689 fastCert10_5689=true := by decide +kernel
def fastCert10_5690 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5690 : checkCertificateFast 10 5690 fastCert10_5690=true := by decide +kernel
def fastCert10_5691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5691 : checkCertificateFast 10 5691 fastCert10_5691=true := by decide +kernel
def fastCert10_5692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5692 : checkCertificateFast 10 5692 fastCert10_5692=true := by decide +kernel
def fastCert10_5693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5693 : checkCertificateFast 10 5693 fastCert10_5693=true := by decide +kernel
def fastCert10_5694 : Certificate := ⟨8,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5694 : checkCertificateFast 10 5694 fastCert10_5694=true := by decide +kernel
def fastCert10_5695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5695 : checkCertificateFast 10 5695 fastCert10_5695=true := by decide +kernel
def fastCert10_5696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5696 : checkCertificateFast 10 5696 fastCert10_5696=true := by decide +kernel
def fastCert10_5697 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5697 : checkCertificateFast 10 5697 fastCert10_5697=true := by decide +kernel
def fastCert10_5698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5698 : checkCertificateFast 10 5698 fastCert10_5698=true := by decide +kernel
def fastCert10_5699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5699 : checkCertificateFast 10 5699 fastCert10_5699=true := by decide +kernel
def fastCert10_5700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5700 : checkCertificateFast 10 5700 fastCert10_5700=true := by decide +kernel
def fastCert10_5701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5701 : checkCertificateFast 10 5701 fastCert10_5701=true := by decide +kernel
def fastCert10_5702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5702 : checkCertificateFast 10 5702 fastCert10_5702=true := by decide +kernel
def fastCert10_5703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5703 : checkCertificateFast 10 5703 fastCert10_5703=true := by decide +kernel
def fastCert10_5704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5704 : checkCertificateFast 10 5704 fastCert10_5704=true := by decide +kernel
def fastCert10_5705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5705 : checkCertificateFast 10 5705 fastCert10_5705=true := by decide +kernel
def fastCert10_5706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5706 : checkCertificateFast 10 5706 fastCert10_5706=true := by decide +kernel
def fastCert10_5707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5707 : checkCertificateFast 10 5707 fastCert10_5707=true := by decide +kernel
def fastCert10_5708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5708 : checkCertificateFast 10 5708 fastCert10_5708=true := by decide +kernel
def fastCert10_5709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5709 : checkCertificateFast 10 5709 fastCert10_5709=true := by decide +kernel
def fastCert10_5710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5710 : checkCertificateFast 10 5710 fastCert10_5710=true := by decide +kernel
def fastCert10_5711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5711 : checkCertificateFast 10 5711 fastCert10_5711=true := by decide +kernel
def fastCert10_5712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5712 : checkCertificateFast 10 5712 fastCert10_5712=true := by decide +kernel
def fastCert10_5713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5713 : checkCertificateFast 10 5713 fastCert10_5713=true := by decide +kernel
def fastCert10_5714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5714 : checkCertificateFast 10 5714 fastCert10_5714=true := by decide +kernel
def fastCert10_5715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5715 : checkCertificateFast 10 5715 fastCert10_5715=true := by decide +kernel
def fastCert10_5716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5716 : checkCertificateFast 10 5716 fastCert10_5716=true := by decide +kernel
def fastCert10_5717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5717 : checkCertificateFast 10 5717 fastCert10_5717=true := by decide +kernel
def fastCert10_5718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5718 : checkCertificateFast 10 5718 fastCert10_5718=true := by decide +kernel
def fastCert10_5719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5719 : checkCertificateFast 10 5719 fastCert10_5719=true := by decide +kernel
def fastCert10_5720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5720 : checkCertificateFast 10 5720 fastCert10_5720=true := by decide +kernel
def fastCert10_5721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5721 : checkCertificateFast 10 5721 fastCert10_5721=true := by decide +kernel
def fastCert10_5722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5722 : checkCertificateFast 10 5722 fastCert10_5722=true := by decide +kernel
def fastCert10_5723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_5723 : checkCertificateFast 10 5723 fastCert10_5723=true := by decide +kernel
def fastCert10_5724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5724 : checkCertificateFast 10 5724 fastCert10_5724=true := by decide +kernel
def fastCert10_5725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5725 : checkCertificateFast 10 5725 fastCert10_5725=true := by decide +kernel
def fastCert10_5726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5726 : checkCertificateFast 10 5726 fastCert10_5726=true := by decide +kernel
def fastCert10_5727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5727 : checkCertificateFast 10 5727 fastCert10_5727=true := by decide +kernel
def fastCert10_5728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5728 : checkCertificateFast 10 5728 fastCert10_5728=true := by decide +kernel
def fastCert10_5729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5729 : checkCertificateFast 10 5729 fastCert10_5729=true := by decide +kernel
def fastCert10_5730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5730 : checkCertificateFast 10 5730 fastCert10_5730=true := by decide +kernel
def fastCert10_5731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5731 : checkCertificateFast 10 5731 fastCert10_5731=true := by decide +kernel
def fastCert10_5732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5732 : checkCertificateFast 10 5732 fastCert10_5732=true := by decide +kernel
def fastCert10_5733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5733 : checkCertificateFast 10 5733 fastCert10_5733=true := by decide +kernel
def fastCert10_5734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5734 : checkCertificateFast 10 5734 fastCert10_5734=true := by decide +kernel
def fastCert10_5735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5735 : checkCertificateFast 10 5735 fastCert10_5735=true := by decide +kernel
def fastCert10_5736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5736 : checkCertificateFast 10 5736 fastCert10_5736=true := by decide +kernel
def fastCert10_5737 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5737 : checkCertificateFast 10 5737 fastCert10_5737=true := by decide +kernel
def fastCert10_5738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5738 : checkCertificateFast 10 5738 fastCert10_5738=true := by decide +kernel
def fastCert10_5739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5739 : checkCertificateFast 10 5739 fastCert10_5739=true := by decide +kernel
def fastCert10_5740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5740 : checkCertificateFast 10 5740 fastCert10_5740=true := by decide +kernel
def fastCert10_5741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5741 : checkCertificateFast 10 5741 fastCert10_5741=true := by decide +kernel
def fastCert10_5742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5742 : checkCertificateFast 10 5742 fastCert10_5742=true := by decide +kernel
def fastCert10_5743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5743 : checkCertificateFast 10 5743 fastCert10_5743=true := by decide +kernel
def fastCert10_5744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5744 : checkCertificateFast 10 5744 fastCert10_5744=true := by decide +kernel
def fastCert10_5745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5745 : checkCertificateFast 10 5745 fastCert10_5745=true := by decide +kernel
def fastCert10_5746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5746 : checkCertificateFast 10 5746 fastCert10_5746=true := by decide +kernel
def fastCert10_5747 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5747 : checkCertificateFast 10 5747 fastCert10_5747=true := by decide +kernel
def fastCert10_5748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5748 : checkCertificateFast 10 5748 fastCert10_5748=true := by decide +kernel
def fastCert10_5749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5749 : checkCertificateFast 10 5749 fastCert10_5749=true := by decide +kernel
def fastCert10_5750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5750 : checkCertificateFast 10 5750 fastCert10_5750=true := by decide +kernel
def fastCert10_5751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5751 : checkCertificateFast 10 5751 fastCert10_5751=true := by decide +kernel
def fastCert10_5752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5752 : checkCertificateFast 10 5752 fastCert10_5752=true := by decide +kernel
def fastCert10_5753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5753 : checkCertificateFast 10 5753 fastCert10_5753=true := by decide +kernel
def fastCert10_5754 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5754 : checkCertificateFast 10 5754 fastCert10_5754=true := by decide +kernel
def fastCert10_5755 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_5755 : checkCertificateFast 10 5755 fastCert10_5755=true := by decide +kernel
def fastCert10_5756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5756 : checkCertificateFast 10 5756 fastCert10_5756=true := by decide +kernel
def fastCert10_5757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5757 : checkCertificateFast 10 5757 fastCert10_5757=true := by decide +kernel
def fastCert10_5758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5758 : checkCertificateFast 10 5758 fastCert10_5758=true := by decide +kernel
def fastCert10_5759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5759 : checkCertificateFast 10 5759 fastCert10_5759=true := by decide +kernel
def fastCert10_5760 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5760 : checkCertificateFast 10 5760 fastCert10_5760=true := by decide +kernel
def fastCert10_5761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5761 : checkCertificateFast 10 5761 fastCert10_5761=true := by decide +kernel
def fastCert10_5762 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5762 : checkCertificateFast 10 5762 fastCert10_5762=true := by decide +kernel
def fastCert10_5763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5763 : checkCertificateFast 10 5763 fastCert10_5763=true := by decide +kernel
def fastCert10_5764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5764 : checkCertificateFast 10 5764 fastCert10_5764=true := by decide +kernel
def fastCert10_5765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5765 : checkCertificateFast 10 5765 fastCert10_5765=true := by decide +kernel
def fastCert10_5766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5766 : checkCertificateFast 10 5766 fastCert10_5766=true := by decide +kernel
def fastCert10_5767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-28) else if t=0 ∧ i=1 then (21) else if t=0 ∧ i=2 then (-5) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-14) else if t=0 ∧ i=5 then (-18) else if t=0 ∧ i=6 then (21) else if t=0 ∧ i=7 then (21) else if t=0 ∧ i=8 then (-5) else if t=0 ∧ i=9 then (-5) else if t=0 ∧ i=10 then (-10) else if t=0 ∧ i=11 then (42) else if t=0 ∧ i=12 then (-10) else if t=0 ∧ i=13 then (-42) else if t=0 ∧ i=15 then (10) else 0⟩
theorem fastCase10_5767 : checkCertificateFast 10 5767 fastCert10_5767=true := by decide +kernel
def fastCert10_5768 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5768 : checkCertificateFast 10 5768 fastCert10_5768=true := by decide +kernel
def fastCert10_5769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5769 : checkCertificateFast 10 5769 fastCert10_5769=true := by decide +kernel
def fastCert10_5770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5770 : checkCertificateFast 10 5770 fastCert10_5770=true := by decide +kernel
def fastCert10_5771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5771 : checkCertificateFast 10 5771 fastCert10_5771=true := by decide +kernel
def fastCert10_5772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5772 : checkCertificateFast 10 5772 fastCert10_5772=true := by decide +kernel
def fastCert10_5773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5773 : checkCertificateFast 10 5773 fastCert10_5773=true := by decide +kernel
def fastCert10_5774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5774 : checkCertificateFast 10 5774 fastCert10_5774=true := by decide +kernel
def fastCert10_5775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5775 : checkCertificateFast 10 5775 fastCert10_5775=true := by decide +kernel
def fastCert10_5776 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5776 : checkCertificateFast 10 5776 fastCert10_5776=true := by decide +kernel
def fastCert10_5777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5777 : checkCertificateFast 10 5777 fastCert10_5777=true := by decide +kernel
def fastCert10_5778 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5778 : checkCertificateFast 10 5778 fastCert10_5778=true := by decide +kernel
def fastCert10_5779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5779 : checkCertificateFast 10 5779 fastCert10_5779=true := by decide +kernel
def fastCert10_5780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5780 : checkCertificateFast 10 5780 fastCert10_5780=true := by decide +kernel
def fastCert10_5781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5781 : checkCertificateFast 10 5781 fastCert10_5781=true := by decide +kernel
def fastCert10_5782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5782 : checkCertificateFast 10 5782 fastCert10_5782=true := by decide +kernel
def fastCert10_5783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5783 : checkCertificateFast 10 5783 fastCert10_5783=true := by decide +kernel
def fastCert10_5784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5784 : checkCertificateFast 10 5784 fastCert10_5784=true := by decide +kernel
def fastCert10_5785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5785 : checkCertificateFast 10 5785 fastCert10_5785=true := by decide +kernel
def fastCert10_5786 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5786 : checkCertificateFast 10 5786 fastCert10_5786=true := by decide +kernel
def fastCert10_5787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5787 : checkCertificateFast 10 5787 fastCert10_5787=true := by decide +kernel
def fastCert10_5788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5788 : checkCertificateFast 10 5788 fastCert10_5788=true := by decide +kernel
def fastCert10_5789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5789 : checkCertificateFast 10 5789 fastCert10_5789=true := by decide +kernel
def fastCert10_5790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5790 : checkCertificateFast 10 5790 fastCert10_5790=true := by decide +kernel
def fastCert10_5791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5791 : checkCertificateFast 10 5791 fastCert10_5791=true := by decide +kernel
def fastCert10_5792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5792 : checkCertificateFast 10 5792 fastCert10_5792=true := by decide +kernel
def fastCert10_5793 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5793 : checkCertificateFast 10 5793 fastCert10_5793=true := by decide +kernel
def fastCert10_5794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5794 : checkCertificateFast 10 5794 fastCert10_5794=true := by decide +kernel
def fastCert10_5795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5795 : checkCertificateFast 10 5795 fastCert10_5795=true := by decide +kernel
def fastCert10_5796 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5796 : checkCertificateFast 10 5796 fastCert10_5796=true := by decide +kernel
def fastCert10_5797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5797 : checkCertificateFast 10 5797 fastCert10_5797=true := by decide +kernel
def fastCert10_5798 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5798 : checkCertificateFast 10 5798 fastCert10_5798=true := by decide +kernel
def fastCert10_5799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5799 : checkCertificateFast 10 5799 fastCert10_5799=true := by decide +kernel
def fastCert10_5800 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5800 : checkCertificateFast 10 5800 fastCert10_5800=true := by decide +kernel
def fastCert10_5801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5801 : checkCertificateFast 10 5801 fastCert10_5801=true := by decide +kernel
def fastCert10_5802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5802 : checkCertificateFast 10 5802 fastCert10_5802=true := by decide +kernel
def fastCert10_5803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5803 : checkCertificateFast 10 5803 fastCert10_5803=true := by decide +kernel
def fastCert10_5804 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5804 : checkCertificateFast 10 5804 fastCert10_5804=true := by decide +kernel
def fastCert10_5805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5805 : checkCertificateFast 10 5805 fastCert10_5805=true := by decide +kernel
def fastCert10_5806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5806 : checkCertificateFast 10 5806 fastCert10_5806=true := by decide +kernel
def fastCert10_5807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5807 : checkCertificateFast 10 5807 fastCert10_5807=true := by decide +kernel
def fastCert10_5808 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5808 : checkCertificateFast 10 5808 fastCert10_5808=true := by decide +kernel
def fastCert10_5809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5809 : checkCertificateFast 10 5809 fastCert10_5809=true := by decide +kernel
def fastCert10_5810 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5810 : checkCertificateFast 10 5810 fastCert10_5810=true := by decide +kernel
def fastCert10_5811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5811 : checkCertificateFast 10 5811 fastCert10_5811=true := by decide +kernel
def fastCert10_5812 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5812 : checkCertificateFast 10 5812 fastCert10_5812=true := by decide +kernel
def fastCert10_5813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5813 : checkCertificateFast 10 5813 fastCert10_5813=true := by decide +kernel
def fastCert10_5814 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5814 : checkCertificateFast 10 5814 fastCert10_5814=true := by decide +kernel
def fastCert10_5815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5815 : checkCertificateFast 10 5815 fastCert10_5815=true := by decide +kernel
def fastCert10_5816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5816 : checkCertificateFast 10 5816 fastCert10_5816=true := by decide +kernel
def fastCert10_5817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5817 : checkCertificateFast 10 5817 fastCert10_5817=true := by decide +kernel
def fastCert10_5818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5818 : checkCertificateFast 10 5818 fastCert10_5818=true := by decide +kernel
def fastCert10_5819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5819 : checkCertificateFast 10 5819 fastCert10_5819=true := by decide +kernel
def fastCert10_5820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5820 : checkCertificateFast 10 5820 fastCert10_5820=true := by decide +kernel
def fastCert10_5821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5821 : checkCertificateFast 10 5821 fastCert10_5821=true := by decide +kernel
def fastCert10_5822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5822 : checkCertificateFast 10 5822 fastCert10_5822=true := by decide +kernel
def fastCert10_5823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5823 : checkCertificateFast 10 5823 fastCert10_5823=true := by decide +kernel
def fastCert10_5824 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5824 : checkCertificateFast 10 5824 fastCert10_5824=true := by decide +kernel
def fastCert10_5825 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5825 : checkCertificateFast 10 5825 fastCert10_5825=true := by decide +kernel
def fastCert10_5826 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5826 : checkCertificateFast 10 5826 fastCert10_5826=true := by decide +kernel
def fastCert10_5827 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5827 : checkCertificateFast 10 5827 fastCert10_5827=true := by decide +kernel
def fastCert10_5828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5828 : checkCertificateFast 10 5828 fastCert10_5828=true := by decide +kernel
def fastCert10_5829 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5829 : checkCertificateFast 10 5829 fastCert10_5829=true := by decide +kernel
def fastCert10_5830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5830 : checkCertificateFast 10 5830 fastCert10_5830=true := by decide +kernel
def fastCert10_5831 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5831 : checkCertificateFast 10 5831 fastCert10_5831=true := by decide +kernel
def fastCert10_5832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5832 : checkCertificateFast 10 5832 fastCert10_5832=true := by decide +kernel
def fastCert10_5833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5833 : checkCertificateFast 10 5833 fastCert10_5833=true := by decide +kernel
def fastCert10_5834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5834 : checkCertificateFast 10 5834 fastCert10_5834=true := by decide +kernel
def fastCert10_5835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5835 : checkCertificateFast 10 5835 fastCert10_5835=true := by decide +kernel
def fastCert10_5836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5836 : checkCertificateFast 10 5836 fastCert10_5836=true := by decide +kernel
def fastCert10_5837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5837 : checkCertificateFast 10 5837 fastCert10_5837=true := by decide +kernel
def fastCert10_5838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5838 : checkCertificateFast 10 5838 fastCert10_5838=true := by decide +kernel
def fastCert10_5839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5839 : checkCertificateFast 10 5839 fastCert10_5839=true := by decide +kernel
def fastCert10_5840 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5840 : checkCertificateFast 10 5840 fastCert10_5840=true := by decide +kernel
def fastCert10_5841 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5841 : checkCertificateFast 10 5841 fastCert10_5841=true := by decide +kernel
def fastCert10_5842 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5842 : checkCertificateFast 10 5842 fastCert10_5842=true := by decide +kernel
def fastCert10_5843 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5843 : checkCertificateFast 10 5843 fastCert10_5843=true := by decide +kernel
def fastCert10_5844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5844 : checkCertificateFast 10 5844 fastCert10_5844=true := by decide +kernel
def fastCert10_5845 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5845 : checkCertificateFast 10 5845 fastCert10_5845=true := by decide +kernel
def fastCert10_5846 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5846 : checkCertificateFast 10 5846 fastCert10_5846=true := by decide +kernel
def fastCert10_5847 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5847 : checkCertificateFast 10 5847 fastCert10_5847=true := by decide +kernel
def fastCert10_5848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5848 : checkCertificateFast 10 5848 fastCert10_5848=true := by decide +kernel
def fastCert10_5849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5849 : checkCertificateFast 10 5849 fastCert10_5849=true := by decide +kernel
def fastCert10_5850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5850 : checkCertificateFast 10 5850 fastCert10_5850=true := by decide +kernel
def fastCert10_5851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5851 : checkCertificateFast 10 5851 fastCert10_5851=true := by decide +kernel
def fastCert10_5852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5852 : checkCertificateFast 10 5852 fastCert10_5852=true := by decide +kernel
def fastCert10_5853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5853 : checkCertificateFast 10 5853 fastCert10_5853=true := by decide +kernel
def fastCert10_5854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5854 : checkCertificateFast 10 5854 fastCert10_5854=true := by decide +kernel
def fastCert10_5855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5855 : checkCertificateFast 10 5855 fastCert10_5855=true := by decide +kernel
def fastCert10_5856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5856 : checkCertificateFast 10 5856 fastCert10_5856=true := by decide +kernel
def fastCert10_5857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5857 : checkCertificateFast 10 5857 fastCert10_5857=true := by decide +kernel
def fastCert10_5858 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5858 : checkCertificateFast 10 5858 fastCert10_5858=true := by decide +kernel
def fastCert10_5859 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5859 : checkCertificateFast 10 5859 fastCert10_5859=true := by decide +kernel
def fastCert10_5860 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5860 : checkCertificateFast 10 5860 fastCert10_5860=true := by decide +kernel
def fastCert10_5861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5861 : checkCertificateFast 10 5861 fastCert10_5861=true := by decide +kernel
def fastCert10_5862 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5862 : checkCertificateFast 10 5862 fastCert10_5862=true := by decide +kernel
def fastCert10_5863 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5863 : checkCertificateFast 10 5863 fastCert10_5863=true := by decide +kernel
def fastCert10_5864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5864 : checkCertificateFast 10 5864 fastCert10_5864=true := by decide +kernel
def fastCert10_5865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5865 : checkCertificateFast 10 5865 fastCert10_5865=true := by decide +kernel
def fastCert10_5866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5866 : checkCertificateFast 10 5866 fastCert10_5866=true := by decide +kernel
def fastCert10_5867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5867 : checkCertificateFast 10 5867 fastCert10_5867=true := by decide +kernel
def fastCert10_5868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5868 : checkCertificateFast 10 5868 fastCert10_5868=true := by decide +kernel
def fastCert10_5869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5869 : checkCertificateFast 10 5869 fastCert10_5869=true := by decide +kernel
def fastCert10_5870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5870 : checkCertificateFast 10 5870 fastCert10_5870=true := by decide +kernel
def fastCert10_5871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5871 : checkCertificateFast 10 5871 fastCert10_5871=true := by decide +kernel
def fastCert10_5872 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5872 : checkCertificateFast 10 5872 fastCert10_5872=true := by decide +kernel
def fastCert10_5873 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5873 : checkCertificateFast 10 5873 fastCert10_5873=true := by decide +kernel
def fastCert10_5874 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5874 : checkCertificateFast 10 5874 fastCert10_5874=true := by decide +kernel
def fastCert10_5875 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5875 : checkCertificateFast 10 5875 fastCert10_5875=true := by decide +kernel
def fastCert10_5876 : Certificate := ⟨38,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5876 : checkCertificateFast 10 5876 fastCert10_5876=true := by decide +kernel
def fastCert10_5877 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5877 : checkCertificateFast 10 5877 fastCert10_5877=true := by decide +kernel
def fastCert10_5878 : Certificate := ⟨10,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5878 : checkCertificateFast 10 5878 fastCert10_5878=true := by decide +kernel
def fastCert10_5879 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5879 : checkCertificateFast 10 5879 fastCert10_5879=true := by decide +kernel
def fastCert10_5880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5880 : checkCertificateFast 10 5880 fastCert10_5880=true := by decide +kernel
def fastCert10_5881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5881 : checkCertificateFast 10 5881 fastCert10_5881=true := by decide +kernel
def fastCert10_5882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5882 : checkCertificateFast 10 5882 fastCert10_5882=true := by decide +kernel
def fastCert10_5883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5883 : checkCertificateFast 10 5883 fastCert10_5883=true := by decide +kernel
def fastCert10_5884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5884 : checkCertificateFast 10 5884 fastCert10_5884=true := by decide +kernel
def fastCert10_5885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5885 : checkCertificateFast 10 5885 fastCert10_5885=true := by decide +kernel
def fastCert10_5886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5886 : checkCertificateFast 10 5886 fastCert10_5886=true := by decide +kernel
def fastCert10_5887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5887 : checkCertificateFast 10 5887 fastCert10_5887=true := by decide +kernel
def fastCert10_5888 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-7) else if t=0 ∧ i=1 then (7) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=5 then (-5) else if t=0 ∧ i=6 then (6) else if t=0 ∧ i=7 then (7) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (11) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-13) else if t=0 ∧ i=15 then (4) else 0⟩
theorem fastCase10_5888 : checkCertificateFast 10 5888 fastCert10_5888=true := by decide +kernel
def fastCert10_5889 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5889 : checkCertificateFast 10 5889 fastCert10_5889=true := by decide +kernel
def fastCert10_5890 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5890 : checkCertificateFast 10 5890 fastCert10_5890=true := by decide +kernel
def fastCert10_5891 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5891 : checkCertificateFast 10 5891 fastCert10_5891=true := by decide +kernel
def fastCert10_5892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5892 : checkCertificateFast 10 5892 fastCert10_5892=true := by decide +kernel
def fastCert10_5893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (4) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5893 : checkCertificateFast 10 5893 fastCert10_5893=true := by decide +kernel
def fastCert10_5894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5894 : checkCertificateFast 10 5894 fastCert10_5894=true := by decide +kernel
def fastCert10_5895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_5895 : checkCertificateFast 10 5895 fastCert10_5895=true := by decide +kernel
def fastCert10_5896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5896 : checkCertificateFast 10 5896 fastCert10_5896=true := by decide +kernel
def fastCert10_5897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5897 : checkCertificateFast 10 5897 fastCert10_5897=true := by decide +kernel
def fastCert10_5898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5898 : checkCertificateFast 10 5898 fastCert10_5898=true := by decide +kernel
def fastCert10_5899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5899 : checkCertificateFast 10 5899 fastCert10_5899=true := by decide +kernel
def fastCert10_5900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5900 : checkCertificateFast 10 5900 fastCert10_5900=true := by decide +kernel
def fastCert10_5901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5901 : checkCertificateFast 10 5901 fastCert10_5901=true := by decide +kernel
def fastCert10_5902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5902 : checkCertificateFast 10 5902 fastCert10_5902=true := by decide +kernel
def fastCert10_5903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5903 : checkCertificateFast 10 5903 fastCert10_5903=true := by decide +kernel
def fastCert10_5904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5904 : checkCertificateFast 10 5904 fastCert10_5904=true := by decide +kernel
def fastCert10_5905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5905 : checkCertificateFast 10 5905 fastCert10_5905=true := by decide +kernel
def fastCert10_5906 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-4) else 0⟩
theorem fastCase10_5906 : checkCertificateFast 10 5906 fastCert10_5906=true := by decide +kernel
def fastCert10_5907 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5907 : checkCertificateFast 10 5907 fastCert10_5907=true := by decide +kernel
def fastCert10_5908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5908 : checkCertificateFast 10 5908 fastCert10_5908=true := by decide +kernel
def fastCert10_5909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_5909 : checkCertificateFast 10 5909 fastCert10_5909=true := by decide +kernel
def fastCert10_5910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5910 : checkCertificateFast 10 5910 fastCert10_5910=true := by decide +kernel
def fastCert10_5911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5911 : checkCertificateFast 10 5911 fastCert10_5911=true := by decide +kernel
def fastCert10_5912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5912 : checkCertificateFast 10 5912 fastCert10_5912=true := by decide +kernel
def fastCert10_5913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5913 : checkCertificateFast 10 5913 fastCert10_5913=true := by decide +kernel
def fastCert10_5914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5914 : checkCertificateFast 10 5914 fastCert10_5914=true := by decide +kernel
def fastCert10_5915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5915 : checkCertificateFast 10 5915 fastCert10_5915=true := by decide +kernel
def fastCert10_5916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5916 : checkCertificateFast 10 5916 fastCert10_5916=true := by decide +kernel
def fastCert10_5917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5917 : checkCertificateFast 10 5917 fastCert10_5917=true := by decide +kernel
def fastCert10_5918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5918 : checkCertificateFast 10 5918 fastCert10_5918=true := by decide +kernel
def fastCert10_5919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_5919 : checkCertificateFast 10 5919 fastCert10_5919=true := by decide +kernel
def fastCert10_5920 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5920 : checkCertificateFast 10 5920 fastCert10_5920=true := by decide +kernel
def fastCert10_5921 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5921 : checkCertificateFast 10 5921 fastCert10_5921=true := by decide +kernel
def fastCert10_5922 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_5922 : checkCertificateFast 10 5922 fastCert10_5922=true := by decide +kernel
def fastCert10_5923 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5923 : checkCertificateFast 10 5923 fastCert10_5923=true := by decide +kernel
def fastCert10_5924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5924 : checkCertificateFast 10 5924 fastCert10_5924=true := by decide +kernel
def fastCert10_5925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5925 : checkCertificateFast 10 5925 fastCert10_5925=true := by decide +kernel
def fastCert10_5926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5926 : checkCertificateFast 10 5926 fastCert10_5926=true := by decide +kernel
def fastCert10_5927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5927 : checkCertificateFast 10 5927 fastCert10_5927=true := by decide +kernel
def fastCert10_5928 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5928 : checkCertificateFast 10 5928 fastCert10_5928=true := by decide +kernel
def fastCert10_5929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5929 : checkCertificateFast 10 5929 fastCert10_5929=true := by decide +kernel
def fastCert10_5930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5930 : checkCertificateFast 10 5930 fastCert10_5930=true := by decide +kernel
def fastCert10_5931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5931 : checkCertificateFast 10 5931 fastCert10_5931=true := by decide +kernel
def fastCert10_5932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5932 : checkCertificateFast 10 5932 fastCert10_5932=true := by decide +kernel
def fastCert10_5933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5933 : checkCertificateFast 10 5933 fastCert10_5933=true := by decide +kernel
def fastCert10_5934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_5934 : checkCertificateFast 10 5934 fastCert10_5934=true := by decide +kernel
def fastCert10_5935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5935 : checkCertificateFast 10 5935 fastCert10_5935=true := by decide +kernel
def fastCert10_5936 : Certificate := ⟨39,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5936 : checkCertificateFast 10 5936 fastCert10_5936=true := by decide +kernel
def fastCert10_5937 : Certificate := ⟨20,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5937 : checkCertificateFast 10 5937 fastCert10_5937=true := by decide +kernel
def fastCert10_5938 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5938 : checkCertificateFast 10 5938 fastCert10_5938=true := by decide +kernel
def fastCert10_5939 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5939 : checkCertificateFast 10 5939 fastCert10_5939=true := by decide +kernel
def fastCert10_5940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5940 : checkCertificateFast 10 5940 fastCert10_5940=true := by decide +kernel
def fastCert10_5941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_5941 : checkCertificateFast 10 5941 fastCert10_5941=true := by decide +kernel
def fastCert10_5942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_5942 : checkCertificateFast 10 5942 fastCert10_5942=true := by decide +kernel
def fastCert10_5943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5943 : checkCertificateFast 10 5943 fastCert10_5943=true := by decide +kernel
def fastCert10_5944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5944 : checkCertificateFast 10 5944 fastCert10_5944=true := by decide +kernel
def fastCert10_5945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5945 : checkCertificateFast 10 5945 fastCert10_5945=true := by decide +kernel
def fastCert10_5946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5946 : checkCertificateFast 10 5946 fastCert10_5946=true := by decide +kernel
def fastCert10_5947 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5947 : checkCertificateFast 10 5947 fastCert10_5947=true := by decide +kernel
def fastCert10_5948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5948 : checkCertificateFast 10 5948 fastCert10_5948=true := by decide +kernel
def fastCert10_5949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5949 : checkCertificateFast 10 5949 fastCert10_5949=true := by decide +kernel
def fastCert10_5950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_5950 : checkCertificateFast 10 5950 fastCert10_5950=true := by decide +kernel
def fastCert10_5951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_5951 : checkCertificateFast 10 5951 fastCert10_5951=true := by decide +kernel
def fastCert10_5952 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5952 : checkCertificateFast 10 5952 fastCert10_5952=true := by decide +kernel
def fastCert10_5953 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5953 : checkCertificateFast 10 5953 fastCert10_5953=true := by decide +kernel
def fastCert10_5954 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5954 : checkCertificateFast 10 5954 fastCert10_5954=true := by decide +kernel
def fastCert10_5955 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5955 : checkCertificateFast 10 5955 fastCert10_5955=true := by decide +kernel
def fastCert10_5956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5956 : checkCertificateFast 10 5956 fastCert10_5956=true := by decide +kernel
def fastCert10_5957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5957 : checkCertificateFast 10 5957 fastCert10_5957=true := by decide +kernel
def fastCert10_5958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5958 : checkCertificateFast 10 5958 fastCert10_5958=true := by decide +kernel
def fastCert10_5959 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5959 : checkCertificateFast 10 5959 fastCert10_5959=true := by decide +kernel
def fastCert10_5960 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5960 : checkCertificateFast 10 5960 fastCert10_5960=true := by decide +kernel
def fastCert10_5961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5961 : checkCertificateFast 10 5961 fastCert10_5961=true := by decide +kernel
def fastCert10_5962 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5962 : checkCertificateFast 10 5962 fastCert10_5962=true := by decide +kernel
def fastCert10_5963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5963 : checkCertificateFast 10 5963 fastCert10_5963=true := by decide +kernel
def fastCert10_5964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_5964 : checkCertificateFast 10 5964 fastCert10_5964=true := by decide +kernel
def fastCert10_5965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5965 : checkCertificateFast 10 5965 fastCert10_5965=true := by decide +kernel
def fastCert10_5966 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5966 : checkCertificateFast 10 5966 fastCert10_5966=true := by decide +kernel
def fastCert10_5967 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5967 : checkCertificateFast 10 5967 fastCert10_5967=true := by decide +kernel
def fastCert10_5968 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5968 : checkCertificateFast 10 5968 fastCert10_5968=true := by decide +kernel
def fastCert10_5969 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5969 : checkCertificateFast 10 5969 fastCert10_5969=true := by decide +kernel
def fastCert10_5970 : Certificate := ⟨22,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5970 : checkCertificateFast 10 5970 fastCert10_5970=true := by decide +kernel
def fastCert10_5971 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5971 : checkCertificateFast 10 5971 fastCert10_5971=true := by decide +kernel
def fastCert10_5972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_5972 : checkCertificateFast 10 5972 fastCert10_5972=true := by decide +kernel
def fastCert10_5973 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5973 : checkCertificateFast 10 5973 fastCert10_5973=true := by decide +kernel
def fastCert10_5974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5974 : checkCertificateFast 10 5974 fastCert10_5974=true := by decide +kernel
def fastCert10_5975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5975 : checkCertificateFast 10 5975 fastCert10_5975=true := by decide +kernel
def fastCert10_5976 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5976 : checkCertificateFast 10 5976 fastCert10_5976=true := by decide +kernel
def fastCert10_5977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5977 : checkCertificateFast 10 5977 fastCert10_5977=true := by decide +kernel
def fastCert10_5978 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5978 : checkCertificateFast 10 5978 fastCert10_5978=true := by decide +kernel
def fastCert10_5979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5979 : checkCertificateFast 10 5979 fastCert10_5979=true := by decide +kernel
def fastCert10_5980 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5980 : checkCertificateFast 10 5980 fastCert10_5980=true := by decide +kernel
def fastCert10_5981 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5981 : checkCertificateFast 10 5981 fastCert10_5981=true := by decide +kernel
def fastCert10_5982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5982 : checkCertificateFast 10 5982 fastCert10_5982=true := by decide +kernel
def fastCert10_5983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_5983 : checkCertificateFast 10 5983 fastCert10_5983=true := by decide +kernel
def fastCert10_5984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5984 : checkCertificateFast 10 5984 fastCert10_5984=true := by decide +kernel
def fastCert10_5985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5985 : checkCertificateFast 10 5985 fastCert10_5985=true := by decide +kernel
def fastCert10_5986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5986 : checkCertificateFast 10 5986 fastCert10_5986=true := by decide +kernel
def fastCert10_5987 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5987 : checkCertificateFast 10 5987 fastCert10_5987=true := by decide +kernel
def fastCert10_5988 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_5988 : checkCertificateFast 10 5988 fastCert10_5988=true := by decide +kernel
def fastCert10_5989 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5989 : checkCertificateFast 10 5989 fastCert10_5989=true := by decide +kernel
def fastCert10_5990 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5990 : checkCertificateFast 10 5990 fastCert10_5990=true := by decide +kernel
def fastCert10_5991 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5991 : checkCertificateFast 10 5991 fastCert10_5991=true := by decide +kernel
def fastCert10_5992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5992 : checkCertificateFast 10 5992 fastCert10_5992=true := by decide +kernel
def fastCert10_5993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5993 : checkCertificateFast 10 5993 fastCert10_5993=true := by decide +kernel
def fastCert10_5994 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_5994 : checkCertificateFast 10 5994 fastCert10_5994=true := by decide +kernel
def fastCert10_5995 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5995 : checkCertificateFast 10 5995 fastCert10_5995=true := by decide +kernel
def fastCert10_5996 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_5996 : checkCertificateFast 10 5996 fastCert10_5996=true := by decide +kernel
def fastCert10_5997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5997 : checkCertificateFast 10 5997 fastCert10_5997=true := by decide +kernel
def fastCert10_5998 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_5998 : checkCertificateFast 10 5998 fastCert10_5998=true := by decide +kernel
def fastCert10_5999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_5999 : checkCertificateFast 10 5999 fastCert10_5999=true := by decide +kernel
theorem aggregate_F10_005 : (checkCertificateFast 10 5000 fastCert10_5000=true) ∧ (checkCertificateFast 10 5001 fastCert10_5001=true) ∧ (checkCertificateFast 10 5002 fastCert10_5002=true) ∧ (checkCertificateFast 10 5003 fastCert10_5003=true) ∧ (checkCertificateFast 10 5004 fastCert10_5004=true) ∧ (checkCertificateFast 10 5005 fastCert10_5005=true) ∧ (checkCertificateFast 10 5006 fastCert10_5006=true) ∧ (checkCertificateFast 10 5007 fastCert10_5007=true) ∧ (checkCertificateFast 10 5008 fastCert10_5008=true) ∧ (checkCertificateFast 10 5009 fastCert10_5009=true) ∧ (checkCertificateFast 10 5010 fastCert10_5010=true) ∧ (checkCertificateFast 10 5011 fastCert10_5011=true) ∧ (checkCertificateFast 10 5012 fastCert10_5012=true) ∧ (checkCertificateFast 10 5013 fastCert10_5013=true) ∧ (checkCertificateFast 10 5014 fastCert10_5014=true) ∧ (checkCertificateFast 10 5015 fastCert10_5015=true) ∧ (checkCertificateFast 10 5016 fastCert10_5016=true) ∧ (checkCertificateFast 10 5017 fastCert10_5017=true) ∧ (checkCertificateFast 10 5018 fastCert10_5018=true) ∧ (checkCertificateFast 10 5019 fastCert10_5019=true) ∧ (checkCertificateFast 10 5020 fastCert10_5020=true) ∧ (checkCertificateFast 10 5021 fastCert10_5021=true) ∧ (checkCertificateFast 10 5022 fastCert10_5022=true) ∧ (checkCertificateFast 10 5023 fastCert10_5023=true) ∧ (checkCertificateFast 10 5024 fastCert10_5024=true) ∧ (checkCertificateFast 10 5025 fastCert10_5025=true) ∧ (checkCertificateFast 10 5026 fastCert10_5026=true) ∧ (checkCertificateFast 10 5027 fastCert10_5027=true) ∧ (checkCertificateFast 10 5028 fastCert10_5028=true) ∧ (checkCertificateFast 10 5029 fastCert10_5029=true) ∧ (checkCertificateFast 10 5030 fastCert10_5030=true) ∧ (checkCertificateFast 10 5031 fastCert10_5031=true) ∧ (checkCertificateFast 10 5032 fastCert10_5032=true) ∧ (checkCertificateFast 10 5033 fastCert10_5033=true) ∧ (checkCertificateFast 10 5034 fastCert10_5034=true) ∧ (checkCertificateFast 10 5035 fastCert10_5035=true) ∧ (checkCertificateFast 10 5036 fastCert10_5036=true) ∧ (checkCertificateFast 10 5037 fastCert10_5037=true) ∧ (checkCertificateFast 10 5038 fastCert10_5038=true) ∧ (checkCertificateFast 10 5039 fastCert10_5039=true) ∧ (checkCertificateFast 10 5040 fastCert10_5040=true) ∧ (checkCertificateFast 10 5041 fastCert10_5041=true) ∧ (checkCertificateFast 10 5042 fastCert10_5042=true) ∧ (checkCertificateFast 10 5043 fastCert10_5043=true) ∧ (checkCertificateFast 10 5044 fastCert10_5044=true) ∧ (checkCertificateFast 10 5045 fastCert10_5045=true) ∧ (checkCertificateFast 10 5046 fastCert10_5046=true) ∧ (checkCertificateFast 10 5047 fastCert10_5047=true) ∧ (checkCertificateFast 10 5048 fastCert10_5048=true) ∧ (checkCertificateFast 10 5049 fastCert10_5049=true) ∧ (checkCertificateFast 10 5050 fastCert10_5050=true) ∧ (checkCertificateFast 10 5051 fastCert10_5051=true) ∧ (checkCertificateFast 10 5052 fastCert10_5052=true) ∧ (checkCertificateFast 10 5053 fastCert10_5053=true) ∧ (checkCertificateFast 10 5054 fastCert10_5054=true) ∧ (checkCertificateFast 10 5055 fastCert10_5055=true) ∧ (checkCertificateFast 10 5056 fastCert10_5056=true) ∧ (checkCertificateFast 10 5057 fastCert10_5057=true) ∧ (checkCertificateFast 10 5058 fastCert10_5058=true) ∧ (checkCertificateFast 10 5059 fastCert10_5059=true) ∧ (checkCertificateFast 10 5060 fastCert10_5060=true) ∧ (checkCertificateFast 10 5061 fastCert10_5061=true) ∧ (checkCertificateFast 10 5062 fastCert10_5062=true) ∧ (checkCertificateFast 10 5063 fastCert10_5063=true) ∧ (checkCertificateFast 10 5064 fastCert10_5064=true) ∧ (checkCertificateFast 10 5065 fastCert10_5065=true) ∧ (checkCertificateFast 10 5066 fastCert10_5066=true) ∧ (checkCertificateFast 10 5067 fastCert10_5067=true) ∧ (checkCertificateFast 10 5068 fastCert10_5068=true) ∧ (checkCertificateFast 10 5069 fastCert10_5069=true) ∧ (checkCertificateFast 10 5070 fastCert10_5070=true) ∧ (checkCertificateFast 10 5071 fastCert10_5071=true) ∧ (checkCertificateFast 10 5072 fastCert10_5072=true) ∧ (checkCertificateFast 10 5073 fastCert10_5073=true) ∧ (checkCertificateFast 10 5074 fastCert10_5074=true) ∧ (checkCertificateFast 10 5075 fastCert10_5075=true) ∧ (checkCertificateFast 10 5076 fastCert10_5076=true) ∧ (checkCertificateFast 10 5077 fastCert10_5077=true) ∧ (checkCertificateFast 10 5078 fastCert10_5078=true) ∧ (checkCertificateFast 10 5079 fastCert10_5079=true) ∧ (checkCertificateFast 10 5080 fastCert10_5080=true) ∧ (checkCertificateFast 10 5081 fastCert10_5081=true) ∧ (checkCertificateFast 10 5082 fastCert10_5082=true) ∧ (checkCertificateFast 10 5083 fastCert10_5083=true) ∧ (checkCertificateFast 10 5084 fastCert10_5084=true) ∧ (checkCertificateFast 10 5085 fastCert10_5085=true) ∧ (checkCertificateFast 10 5086 fastCert10_5086=true) ∧ (checkCertificateFast 10 5087 fastCert10_5087=true) ∧ (checkCertificateFast 10 5088 fastCert10_5088=true) ∧ (checkCertificateFast 10 5089 fastCert10_5089=true) ∧ (checkCertificateFast 10 5090 fastCert10_5090=true) ∧ (checkCertificateFast 10 5091 fastCert10_5091=true) ∧ (checkCertificateFast 10 5092 fastCert10_5092=true) ∧ (checkCertificateFast 10 5093 fastCert10_5093=true) ∧ (checkCertificateFast 10 5094 fastCert10_5094=true) ∧ (checkCertificateFast 10 5095 fastCert10_5095=true) ∧ (checkCertificateFast 10 5096 fastCert10_5096=true) ∧ (checkCertificateFast 10 5097 fastCert10_5097=true) ∧ (checkCertificateFast 10 5098 fastCert10_5098=true) ∧ (checkCertificateFast 10 5099 fastCert10_5099=true) ∧ (checkCertificateFast 10 5100 fastCert10_5100=true) ∧ (checkCertificateFast 10 5101 fastCert10_5101=true) ∧ (checkCertificateFast 10 5102 fastCert10_5102=true) ∧ (checkCertificateFast 10 5103 fastCert10_5103=true) ∧ (checkCertificateFast 10 5104 fastCert10_5104=true) ∧ (checkCertificateFast 10 5105 fastCert10_5105=true) ∧ (checkCertificateFast 10 5106 fastCert10_5106=true) ∧ (checkCertificateFast 10 5107 fastCert10_5107=true) ∧ (checkCertificateFast 10 5108 fastCert10_5108=true) ∧ (checkCertificateFast 10 5109 fastCert10_5109=true) ∧ (checkCertificateFast 10 5110 fastCert10_5110=true) ∧ (checkCertificateFast 10 5111 fastCert10_5111=true) ∧ (checkCertificateFast 10 5112 fastCert10_5112=true) ∧ (checkCertificateFast 10 5113 fastCert10_5113=true) ∧ (checkCertificateFast 10 5114 fastCert10_5114=true) ∧ (checkCertificateFast 10 5115 fastCert10_5115=true) ∧ (checkCertificateFast 10 5116 fastCert10_5116=true) ∧ (checkCertificateFast 10 5117 fastCert10_5117=true) ∧ (checkCertificateFast 10 5118 fastCert10_5118=true) ∧ (checkCertificateFast 10 5119 fastCert10_5119=true) ∧ (checkCertificateFast 10 5120 fastCert10_5120=true) ∧ (checkCertificateFast 10 5121 fastCert10_5121=true) ∧ (checkCertificateFast 10 5122 fastCert10_5122=true) ∧ (checkCertificateFast 10 5123 fastCert10_5123=true) ∧ (checkCertificateFast 10 5124 fastCert10_5124=true) ∧ (checkCertificateFast 10 5125 fastCert10_5125=true) ∧ (checkCertificateFast 10 5126 fastCert10_5126=true) ∧ (checkCertificateFast 10 5127 fastCert10_5127=true) ∧ (checkCertificateFast 10 5128 fastCert10_5128=true) ∧ (checkCertificateFast 10 5129 fastCert10_5129=true) ∧ (checkCertificateFast 10 5130 fastCert10_5130=true) ∧ (checkCertificateFast 10 5131 fastCert10_5131=true) ∧ (checkCertificateFast 10 5132 fastCert10_5132=true) ∧ (checkCertificateFast 10 5133 fastCert10_5133=true) ∧ (checkCertificateFast 10 5134 fastCert10_5134=true) ∧ (checkCertificateFast 10 5135 fastCert10_5135=true) ∧ (checkCertificateFast 10 5136 fastCert10_5136=true) ∧ (checkCertificateFast 10 5137 fastCert10_5137=true) ∧ (checkCertificateFast 10 5138 fastCert10_5138=true) ∧ (checkCertificateFast 10 5139 fastCert10_5139=true) ∧ (checkCertificateFast 10 5140 fastCert10_5140=true) ∧ (checkCertificateFast 10 5141 fastCert10_5141=true) ∧ (checkCertificateFast 10 5142 fastCert10_5142=true) ∧ (checkCertificateFast 10 5143 fastCert10_5143=true) ∧ (checkCertificateFast 10 5144 fastCert10_5144=true) ∧ (checkCertificateFast 10 5145 fastCert10_5145=true) ∧ (checkCertificateFast 10 5146 fastCert10_5146=true) ∧ (checkCertificateFast 10 5147 fastCert10_5147=true) ∧ (checkCertificateFast 10 5148 fastCert10_5148=true) ∧ (checkCertificateFast 10 5149 fastCert10_5149=true) ∧ (checkCertificateFast 10 5150 fastCert10_5150=true) ∧ (checkCertificateFast 10 5151 fastCert10_5151=true) ∧ (checkCertificateFast 10 5152 fastCert10_5152=true) ∧ (checkCertificateFast 10 5153 fastCert10_5153=true) ∧ (checkCertificateFast 10 5154 fastCert10_5154=true) ∧ (checkCertificateFast 10 5155 fastCert10_5155=true) ∧ (checkCertificateFast 10 5156 fastCert10_5156=true) ∧ (checkCertificateFast 10 5157 fastCert10_5157=true) ∧ (checkCertificateFast 10 5158 fastCert10_5158=true) ∧ (checkCertificateFast 10 5159 fastCert10_5159=true) ∧ (checkCertificateFast 10 5160 fastCert10_5160=true) ∧ (checkCertificateFast 10 5161 fastCert10_5161=true) ∧ (checkCertificateFast 10 5162 fastCert10_5162=true) ∧ (checkCertificateFast 10 5163 fastCert10_5163=true) ∧ (checkCertificateFast 10 5164 fastCert10_5164=true) ∧ (checkCertificateFast 10 5165 fastCert10_5165=true) ∧ (checkCertificateFast 10 5166 fastCert10_5166=true) ∧ (checkCertificateFast 10 5167 fastCert10_5167=true) ∧ (checkCertificateFast 10 5168 fastCert10_5168=true) ∧ (checkCertificateFast 10 5169 fastCert10_5169=true) ∧ (checkCertificateFast 10 5170 fastCert10_5170=true) ∧ (checkCertificateFast 10 5171 fastCert10_5171=true) ∧ (checkCertificateFast 10 5172 fastCert10_5172=true) ∧ (checkCertificateFast 10 5173 fastCert10_5173=true) ∧ (checkCertificateFast 10 5174 fastCert10_5174=true) ∧ (checkCertificateFast 10 5175 fastCert10_5175=true) ∧ (checkCertificateFast 10 5176 fastCert10_5176=true) ∧ (checkCertificateFast 10 5177 fastCert10_5177=true) ∧ (checkCertificateFast 10 5178 fastCert10_5178=true) ∧ (checkCertificateFast 10 5179 fastCert10_5179=true) ∧ (checkCertificateFast 10 5180 fastCert10_5180=true) ∧ (checkCertificateFast 10 5181 fastCert10_5181=true) ∧ (checkCertificateFast 10 5182 fastCert10_5182=true) ∧ (checkCertificateFast 10 5183 fastCert10_5183=true) ∧ (checkCertificateFast 10 5184 fastCert10_5184=true) ∧ (checkCertificateFast 10 5185 fastCert10_5185=true) ∧ (checkCertificateFast 10 5186 fastCert10_5186=true) ∧ (checkCertificateFast 10 5187 fastCert10_5187=true) ∧ (checkCertificateFast 10 5188 fastCert10_5188=true) ∧ (checkCertificateFast 10 5189 fastCert10_5189=true) ∧ (checkCertificateFast 10 5190 fastCert10_5190=true) ∧ (checkCertificateFast 10 5191 fastCert10_5191=true) ∧ (checkCertificateFast 10 5192 fastCert10_5192=true) ∧ (checkCertificateFast 10 5193 fastCert10_5193=true) ∧ (checkCertificateFast 10 5194 fastCert10_5194=true) ∧ (checkCertificateFast 10 5195 fastCert10_5195=true) ∧ (checkCertificateFast 10 5196 fastCert10_5196=true) ∧ (checkCertificateFast 10 5197 fastCert10_5197=true) ∧ (checkCertificateFast 10 5198 fastCert10_5198=true) ∧ (checkCertificateFast 10 5199 fastCert10_5199=true) ∧ (checkCertificateFast 10 5200 fastCert10_5200=true) ∧ (checkCertificateFast 10 5201 fastCert10_5201=true) ∧ (checkCertificateFast 10 5202 fastCert10_5202=true) ∧ (checkCertificateFast 10 5203 fastCert10_5203=true) ∧ (checkCertificateFast 10 5204 fastCert10_5204=true) ∧ (checkCertificateFast 10 5205 fastCert10_5205=true) ∧ (checkCertificateFast 10 5206 fastCert10_5206=true) ∧ (checkCertificateFast 10 5207 fastCert10_5207=true) ∧ (checkCertificateFast 10 5208 fastCert10_5208=true) ∧ (checkCertificateFast 10 5209 fastCert10_5209=true) ∧ (checkCertificateFast 10 5210 fastCert10_5210=true) ∧ (checkCertificateFast 10 5211 fastCert10_5211=true) ∧ (checkCertificateFast 10 5212 fastCert10_5212=true) ∧ (checkCertificateFast 10 5213 fastCert10_5213=true) ∧ (checkCertificateFast 10 5214 fastCert10_5214=true) ∧ (checkCertificateFast 10 5215 fastCert10_5215=true) ∧ (checkCertificateFast 10 5216 fastCert10_5216=true) ∧ (checkCertificateFast 10 5217 fastCert10_5217=true) ∧ (checkCertificateFast 10 5218 fastCert10_5218=true) ∧ (checkCertificateFast 10 5219 fastCert10_5219=true) ∧ (checkCertificateFast 10 5220 fastCert10_5220=true) ∧ (checkCertificateFast 10 5221 fastCert10_5221=true) ∧ (checkCertificateFast 10 5222 fastCert10_5222=true) ∧ (checkCertificateFast 10 5223 fastCert10_5223=true) ∧ (checkCertificateFast 10 5224 fastCert10_5224=true) ∧ (checkCertificateFast 10 5225 fastCert10_5225=true) ∧ (checkCertificateFast 10 5226 fastCert10_5226=true) ∧ (checkCertificateFast 10 5227 fastCert10_5227=true) ∧ (checkCertificateFast 10 5228 fastCert10_5228=true) ∧ (checkCertificateFast 10 5229 fastCert10_5229=true) ∧ (checkCertificateFast 10 5230 fastCert10_5230=true) ∧ (checkCertificateFast 10 5231 fastCert10_5231=true) ∧ (checkCertificateFast 10 5232 fastCert10_5232=true) ∧ (checkCertificateFast 10 5233 fastCert10_5233=true) ∧ (checkCertificateFast 10 5234 fastCert10_5234=true) ∧ (checkCertificateFast 10 5235 fastCert10_5235=true) ∧ (checkCertificateFast 10 5236 fastCert10_5236=true) ∧ (checkCertificateFast 10 5237 fastCert10_5237=true) ∧ (checkCertificateFast 10 5238 fastCert10_5238=true) ∧ (checkCertificateFast 10 5239 fastCert10_5239=true) ∧ (checkCertificateFast 10 5240 fastCert10_5240=true) ∧ (checkCertificateFast 10 5241 fastCert10_5241=true) ∧ (checkCertificateFast 10 5242 fastCert10_5242=true) ∧ (checkCertificateFast 10 5243 fastCert10_5243=true) ∧ (checkCertificateFast 10 5244 fastCert10_5244=true) ∧ (checkCertificateFast 10 5245 fastCert10_5245=true) ∧ (checkCertificateFast 10 5246 fastCert10_5246=true) ∧ (checkCertificateFast 10 5247 fastCert10_5247=true) ∧ (checkCertificateFast 10 5248 fastCert10_5248=true) ∧ (checkCertificateFast 10 5249 fastCert10_5249=true) ∧ (checkCertificateFast 10 5250 fastCert10_5250=true) ∧ (checkCertificateFast 10 5251 fastCert10_5251=true) ∧ (checkCertificateFast 10 5252 fastCert10_5252=true) ∧ (checkCertificateFast 10 5253 fastCert10_5253=true) ∧ (checkCertificateFast 10 5254 fastCert10_5254=true) ∧ (checkCertificateFast 10 5255 fastCert10_5255=true) ∧ (checkCertificateFast 10 5256 fastCert10_5256=true) ∧ (checkCertificateFast 10 5257 fastCert10_5257=true) ∧ (checkCertificateFast 10 5258 fastCert10_5258=true) ∧ (checkCertificateFast 10 5259 fastCert10_5259=true) ∧ (checkCertificateFast 10 5260 fastCert10_5260=true) ∧ (checkCertificateFast 10 5261 fastCert10_5261=true) ∧ (checkCertificateFast 10 5262 fastCert10_5262=true) ∧ (checkCertificateFast 10 5263 fastCert10_5263=true) ∧ (checkCertificateFast 10 5264 fastCert10_5264=true) ∧ (checkCertificateFast 10 5265 fastCert10_5265=true) ∧ (checkCertificateFast 10 5266 fastCert10_5266=true) ∧ (checkCertificateFast 10 5267 fastCert10_5267=true) ∧ (checkCertificateFast 10 5268 fastCert10_5268=true) ∧ (checkCertificateFast 10 5269 fastCert10_5269=true) ∧ (checkCertificateFast 10 5270 fastCert10_5270=true) ∧ (checkCertificateFast 10 5271 fastCert10_5271=true) ∧ (checkCertificateFast 10 5272 fastCert10_5272=true) ∧ (checkCertificateFast 10 5273 fastCert10_5273=true) ∧ (checkCertificateFast 10 5274 fastCert10_5274=true) ∧ (checkCertificateFast 10 5275 fastCert10_5275=true) ∧ (checkCertificateFast 10 5276 fastCert10_5276=true) ∧ (checkCertificateFast 10 5277 fastCert10_5277=true) ∧ (checkCertificateFast 10 5278 fastCert10_5278=true) ∧ (checkCertificateFast 10 5279 fastCert10_5279=true) ∧ (checkCertificateFast 10 5280 fastCert10_5280=true) ∧ (checkCertificateFast 10 5281 fastCert10_5281=true) ∧ (checkCertificateFast 10 5282 fastCert10_5282=true) ∧ (checkCertificateFast 10 5283 fastCert10_5283=true) ∧ (checkCertificateFast 10 5284 fastCert10_5284=true) ∧ (checkCertificateFast 10 5285 fastCert10_5285=true) ∧ (checkCertificateFast 10 5286 fastCert10_5286=true) ∧ (checkCertificateFast 10 5287 fastCert10_5287=true) ∧ (checkCertificateFast 10 5288 fastCert10_5288=true) ∧ (checkCertificateFast 10 5289 fastCert10_5289=true) ∧ (checkCertificateFast 10 5290 fastCert10_5290=true) ∧ (checkCertificateFast 10 5291 fastCert10_5291=true) ∧ (checkCertificateFast 10 5292 fastCert10_5292=true) ∧ (checkCertificateFast 10 5293 fastCert10_5293=true) ∧ (checkCertificateFast 10 5294 fastCert10_5294=true) ∧ (checkCertificateFast 10 5295 fastCert10_5295=true) ∧ (checkCertificateFast 10 5296 fastCert10_5296=true) ∧ (checkCertificateFast 10 5297 fastCert10_5297=true) ∧ (checkCertificateFast 10 5298 fastCert10_5298=true) ∧ (checkCertificateFast 10 5299 fastCert10_5299=true) ∧ (checkCertificateFast 10 5300 fastCert10_5300=true) ∧ (checkCertificateFast 10 5301 fastCert10_5301=true) ∧ (checkCertificateFast 10 5302 fastCert10_5302=true) ∧ (checkCertificateFast 10 5303 fastCert10_5303=true) ∧ (checkCertificateFast 10 5304 fastCert10_5304=true) ∧ (checkCertificateFast 10 5305 fastCert10_5305=true) ∧ (checkCertificateFast 10 5306 fastCert10_5306=true) ∧ (checkCertificateFast 10 5307 fastCert10_5307=true) ∧ (checkCertificateFast 10 5308 fastCert10_5308=true) ∧ (checkCertificateFast 10 5309 fastCert10_5309=true) ∧ (checkCertificateFast 10 5310 fastCert10_5310=true) ∧ (checkCertificateFast 10 5311 fastCert10_5311=true) ∧ (checkCertificateFast 10 5312 fastCert10_5312=true) ∧ (checkCertificateFast 10 5313 fastCert10_5313=true) ∧ (checkCertificateFast 10 5314 fastCert10_5314=true) ∧ (checkCertificateFast 10 5315 fastCert10_5315=true) ∧ (checkCertificateFast 10 5316 fastCert10_5316=true) ∧ (checkCertificateFast 10 5317 fastCert10_5317=true) ∧ (checkCertificateFast 10 5318 fastCert10_5318=true) ∧ (checkCertificateFast 10 5319 fastCert10_5319=true) ∧ (checkCertificateFast 10 5320 fastCert10_5320=true) ∧ (checkCertificateFast 10 5321 fastCert10_5321=true) ∧ (checkCertificateFast 10 5322 fastCert10_5322=true) ∧ (checkCertificateFast 10 5323 fastCert10_5323=true) ∧ (checkCertificateFast 10 5324 fastCert10_5324=true) ∧ (checkCertificateFast 10 5325 fastCert10_5325=true) ∧ (checkCertificateFast 10 5326 fastCert10_5326=true) ∧ (checkCertificateFast 10 5327 fastCert10_5327=true) ∧ (checkCertificateFast 10 5328 fastCert10_5328=true) ∧ (checkCertificateFast 10 5329 fastCert10_5329=true) ∧ (checkCertificateFast 10 5330 fastCert10_5330=true) ∧ (checkCertificateFast 10 5331 fastCert10_5331=true) ∧ (checkCertificateFast 10 5332 fastCert10_5332=true) ∧ (checkCertificateFast 10 5333 fastCert10_5333=true) ∧ (checkCertificateFast 10 5334 fastCert10_5334=true) ∧ (checkCertificateFast 10 5335 fastCert10_5335=true) ∧ (checkCertificateFast 10 5336 fastCert10_5336=true) ∧ (checkCertificateFast 10 5337 fastCert10_5337=true) ∧ (checkCertificateFast 10 5338 fastCert10_5338=true) ∧ (checkCertificateFast 10 5339 fastCert10_5339=true) ∧ (checkCertificateFast 10 5340 fastCert10_5340=true) ∧ (checkCertificateFast 10 5341 fastCert10_5341=true) ∧ (checkCertificateFast 10 5342 fastCert10_5342=true) ∧ (checkCertificateFast 10 5343 fastCert10_5343=true) ∧ (checkCertificateFast 10 5344 fastCert10_5344=true) ∧ (checkCertificateFast 10 5345 fastCert10_5345=true) ∧ (checkCertificateFast 10 5346 fastCert10_5346=true) ∧ (checkCertificateFast 10 5347 fastCert10_5347=true) ∧ (checkCertificateFast 10 5348 fastCert10_5348=true) ∧ (checkCertificateFast 10 5349 fastCert10_5349=true) ∧ (checkCertificateFast 10 5350 fastCert10_5350=true) ∧ (checkCertificateFast 10 5351 fastCert10_5351=true) ∧ (checkCertificateFast 10 5352 fastCert10_5352=true) ∧ (checkCertificateFast 10 5353 fastCert10_5353=true) ∧ (checkCertificateFast 10 5354 fastCert10_5354=true) ∧ (checkCertificateFast 10 5355 fastCert10_5355=true) ∧ (checkCertificateFast 10 5356 fastCert10_5356=true) ∧ (checkCertificateFast 10 5357 fastCert10_5357=true) ∧ (checkCertificateFast 10 5358 fastCert10_5358=true) ∧ (checkCertificateFast 10 5359 fastCert10_5359=true) ∧ (checkCertificateFast 10 5360 fastCert10_5360=true) ∧ (checkCertificateFast 10 5361 fastCert10_5361=true) ∧ (checkCertificateFast 10 5362 fastCert10_5362=true) ∧ (checkCertificateFast 10 5363 fastCert10_5363=true) ∧ (checkCertificateFast 10 5364 fastCert10_5364=true) ∧ (checkCertificateFast 10 5365 fastCert10_5365=true) ∧ (checkCertificateFast 10 5366 fastCert10_5366=true) ∧ (checkCertificateFast 10 5367 fastCert10_5367=true) ∧ (checkCertificateFast 10 5368 fastCert10_5368=true) ∧ (checkCertificateFast 10 5369 fastCert10_5369=true) ∧ (checkCertificateFast 10 5370 fastCert10_5370=true) ∧ (checkCertificateFast 10 5371 fastCert10_5371=true) ∧ (checkCertificateFast 10 5372 fastCert10_5372=true) ∧ (checkCertificateFast 10 5373 fastCert10_5373=true) ∧ (checkCertificateFast 10 5374 fastCert10_5374=true) ∧ (checkCertificateFast 10 5375 fastCert10_5375=true) ∧ (checkCertificateFast 10 5376 fastCert10_5376=true) ∧ (checkCertificateFast 10 5377 fastCert10_5377=true) ∧ (checkCertificateFast 10 5378 fastCert10_5378=true) ∧ (checkCertificateFast 10 5379 fastCert10_5379=true) ∧ (checkCertificateFast 10 5380 fastCert10_5380=true) ∧ (checkCertificateFast 10 5381 fastCert10_5381=true) ∧ (checkCertificateFast 10 5382 fastCert10_5382=true) ∧ (checkCertificateFast 10 5383 fastCert10_5383=true) ∧ (checkCertificateFast 10 5384 fastCert10_5384=true) ∧ (checkCertificateFast 10 5385 fastCert10_5385=true) ∧ (checkCertificateFast 10 5386 fastCert10_5386=true) ∧ (checkCertificateFast 10 5387 fastCert10_5387=true) ∧ (checkCertificateFast 10 5388 fastCert10_5388=true) ∧ (checkCertificateFast 10 5389 fastCert10_5389=true) ∧ (checkCertificateFast 10 5390 fastCert10_5390=true) ∧ (checkCertificateFast 10 5391 fastCert10_5391=true) ∧ (checkCertificateFast 10 5392 fastCert10_5392=true) ∧ (checkCertificateFast 10 5393 fastCert10_5393=true) ∧ (checkCertificateFast 10 5394 fastCert10_5394=true) ∧ (checkCertificateFast 10 5395 fastCert10_5395=true) ∧ (checkCertificateFast 10 5396 fastCert10_5396=true) ∧ (checkCertificateFast 10 5397 fastCert10_5397=true) ∧ (checkCertificateFast 10 5398 fastCert10_5398=true) ∧ (checkCertificateFast 10 5399 fastCert10_5399=true) ∧ (checkCertificateFast 10 5400 fastCert10_5400=true) ∧ (checkCertificateFast 10 5401 fastCert10_5401=true) ∧ (checkCertificateFast 10 5402 fastCert10_5402=true) ∧ (checkCertificateFast 10 5403 fastCert10_5403=true) ∧ (checkCertificateFast 10 5404 fastCert10_5404=true) ∧ (checkCertificateFast 10 5405 fastCert10_5405=true) ∧ (checkCertificateFast 10 5406 fastCert10_5406=true) ∧ (checkCertificateFast 10 5407 fastCert10_5407=true) ∧ (checkCertificateFast 10 5408 fastCert10_5408=true) ∧ (checkCertificateFast 10 5409 fastCert10_5409=true) ∧ (checkCertificateFast 10 5410 fastCert10_5410=true) ∧ (checkCertificateFast 10 5411 fastCert10_5411=true) ∧ (checkCertificateFast 10 5412 fastCert10_5412=true) ∧ (checkCertificateFast 10 5413 fastCert10_5413=true) ∧ (checkCertificateFast 10 5414 fastCert10_5414=true) ∧ (checkCertificateFast 10 5415 fastCert10_5415=true) ∧ (checkCertificateFast 10 5416 fastCert10_5416=true) ∧ (checkCertificateFast 10 5417 fastCert10_5417=true) ∧ (checkCertificateFast 10 5418 fastCert10_5418=true) ∧ (checkCertificateFast 10 5419 fastCert10_5419=true) ∧ (checkCertificateFast 10 5420 fastCert10_5420=true) ∧ (checkCertificateFast 10 5421 fastCert10_5421=true) ∧ (checkCertificateFast 10 5422 fastCert10_5422=true) ∧ (checkCertificateFast 10 5423 fastCert10_5423=true) ∧ (checkCertificateFast 10 5424 fastCert10_5424=true) ∧ (checkCertificateFast 10 5425 fastCert10_5425=true) ∧ (checkCertificateFast 10 5426 fastCert10_5426=true) ∧ (checkCertificateFast 10 5427 fastCert10_5427=true) ∧ (checkCertificateFast 10 5428 fastCert10_5428=true) ∧ (checkCertificateFast 10 5429 fastCert10_5429=true) ∧ (checkCertificateFast 10 5430 fastCert10_5430=true) ∧ (checkCertificateFast 10 5431 fastCert10_5431=true) ∧ (checkCertificateFast 10 5432 fastCert10_5432=true) ∧ (checkCertificateFast 10 5433 fastCert10_5433=true) ∧ (checkCertificateFast 10 5434 fastCert10_5434=true) ∧ (checkCertificateFast 10 5435 fastCert10_5435=true) ∧ (checkCertificateFast 10 5436 fastCert10_5436=true) ∧ (checkCertificateFast 10 5437 fastCert10_5437=true) ∧ (checkCertificateFast 10 5438 fastCert10_5438=true) ∧ (checkCertificateFast 10 5439 fastCert10_5439=true) ∧ (checkCertificateFast 10 5440 fastCert10_5440=true) ∧ (checkCertificateFast 10 5441 fastCert10_5441=true) ∧ (checkCertificateFast 10 5442 fastCert10_5442=true) ∧ (checkCertificateFast 10 5443 fastCert10_5443=true) ∧ (checkCertificateFast 10 5444 fastCert10_5444=true) ∧ (checkCertificateFast 10 5445 fastCert10_5445=true) ∧ (checkCertificateFast 10 5446 fastCert10_5446=true) ∧ (checkCertificateFast 10 5447 fastCert10_5447=true) ∧ (checkCertificateFast 10 5448 fastCert10_5448=true) ∧ (checkCertificateFast 10 5449 fastCert10_5449=true) ∧ (checkCertificateFast 10 5450 fastCert10_5450=true) ∧ (checkCertificateFast 10 5451 fastCert10_5451=true) ∧ (checkCertificateFast 10 5452 fastCert10_5452=true) ∧ (checkCertificateFast 10 5453 fastCert10_5453=true) ∧ (checkCertificateFast 10 5454 fastCert10_5454=true) ∧ (checkCertificateFast 10 5455 fastCert10_5455=true) ∧ (checkCertificateFast 10 5456 fastCert10_5456=true) ∧ (checkCertificateFast 10 5457 fastCert10_5457=true) ∧ (checkCertificateFast 10 5458 fastCert10_5458=true) ∧ (checkCertificateFast 10 5459 fastCert10_5459=true) ∧ (checkCertificateFast 10 5460 fastCert10_5460=true) ∧ (checkCertificateFast 10 5461 fastCert10_5461=true) ∧ (checkCertificateFast 10 5462 fastCert10_5462=true) ∧ (checkCertificateFast 10 5463 fastCert10_5463=true) ∧ (checkCertificateFast 10 5464 fastCert10_5464=true) ∧ (checkCertificateFast 10 5465 fastCert10_5465=true) ∧ (checkCertificateFast 10 5466 fastCert10_5466=true) ∧ (checkCertificateFast 10 5467 fastCert10_5467=true) ∧ (checkCertificateFast 10 5468 fastCert10_5468=true) ∧ (checkCertificateFast 10 5469 fastCert10_5469=true) ∧ (checkCertificateFast 10 5470 fastCert10_5470=true) ∧ (checkCertificateFast 10 5471 fastCert10_5471=true) ∧ (checkCertificateFast 10 5472 fastCert10_5472=true) ∧ (checkCertificateFast 10 5473 fastCert10_5473=true) ∧ (checkCertificateFast 10 5474 fastCert10_5474=true) ∧ (checkCertificateFast 10 5475 fastCert10_5475=true) ∧ (checkCertificateFast 10 5476 fastCert10_5476=true) ∧ (checkCertificateFast 10 5477 fastCert10_5477=true) ∧ (checkCertificateFast 10 5478 fastCert10_5478=true) ∧ (checkCertificateFast 10 5479 fastCert10_5479=true) ∧ (checkCertificateFast 10 5480 fastCert10_5480=true) ∧ (checkCertificateFast 10 5481 fastCert10_5481=true) ∧ (checkCertificateFast 10 5482 fastCert10_5482=true) ∧ (checkCertificateFast 10 5483 fastCert10_5483=true) ∧ (checkCertificateFast 10 5484 fastCert10_5484=true) ∧ (checkCertificateFast 10 5485 fastCert10_5485=true) ∧ (checkCertificateFast 10 5486 fastCert10_5486=true) ∧ (checkCertificateFast 10 5487 fastCert10_5487=true) ∧ (checkCertificateFast 10 5488 fastCert10_5488=true) ∧ (checkCertificateFast 10 5489 fastCert10_5489=true) ∧ (checkCertificateFast 10 5490 fastCert10_5490=true) ∧ (checkCertificateFast 10 5491 fastCert10_5491=true) ∧ (checkCertificateFast 10 5492 fastCert10_5492=true) ∧ (checkCertificateFast 10 5493 fastCert10_5493=true) ∧ (checkCertificateFast 10 5494 fastCert10_5494=true) ∧ (checkCertificateFast 10 5495 fastCert10_5495=true) ∧ (checkCertificateFast 10 5496 fastCert10_5496=true) ∧ (checkCertificateFast 10 5497 fastCert10_5497=true) ∧ (checkCertificateFast 10 5498 fastCert10_5498=true) ∧ (checkCertificateFast 10 5499 fastCert10_5499=true) ∧ (checkCertificateFast 10 5500 fastCert10_5500=true) ∧ (checkCertificateFast 10 5501 fastCert10_5501=true) ∧ (checkCertificateFast 10 5502 fastCert10_5502=true) ∧ (checkCertificateFast 10 5503 fastCert10_5503=true) ∧ (checkCertificateFast 10 5504 fastCert10_5504=true) ∧ (checkCertificateFast 10 5505 fastCert10_5505=true) ∧ (checkCertificateFast 10 5506 fastCert10_5506=true) ∧ (checkCertificateFast 10 5507 fastCert10_5507=true) ∧ (checkCertificateFast 10 5508 fastCert10_5508=true) ∧ (checkCertificateFast 10 5509 fastCert10_5509=true) ∧ (checkCertificateFast 10 5510 fastCert10_5510=true) ∧ (checkCertificateFast 10 5511 fastCert10_5511=true) ∧ (checkCertificateFast 10 5512 fastCert10_5512=true) ∧ (checkCertificateFast 10 5513 fastCert10_5513=true) ∧ (checkCertificateFast 10 5514 fastCert10_5514=true) ∧ (checkCertificateFast 10 5515 fastCert10_5515=true) ∧ (checkCertificateFast 10 5516 fastCert10_5516=true) ∧ (checkCertificateFast 10 5517 fastCert10_5517=true) ∧ (checkCertificateFast 10 5518 fastCert10_5518=true) ∧ (checkCertificateFast 10 5519 fastCert10_5519=true) ∧ (checkCertificateFast 10 5520 fastCert10_5520=true) ∧ (checkCertificateFast 10 5521 fastCert10_5521=true) ∧ (checkCertificateFast 10 5522 fastCert10_5522=true) ∧ (checkCertificateFast 10 5523 fastCert10_5523=true) ∧ (checkCertificateFast 10 5524 fastCert10_5524=true) ∧ (checkCertificateFast 10 5525 fastCert10_5525=true) ∧ (checkCertificateFast 10 5526 fastCert10_5526=true) ∧ (checkCertificateFast 10 5527 fastCert10_5527=true) ∧ (checkCertificateFast 10 5528 fastCert10_5528=true) ∧ (checkCertificateFast 10 5529 fastCert10_5529=true) ∧ (checkCertificateFast 10 5530 fastCert10_5530=true) ∧ (checkCertificateFast 10 5531 fastCert10_5531=true) ∧ (checkCertificateFast 10 5532 fastCert10_5532=true) ∧ (checkCertificateFast 10 5533 fastCert10_5533=true) ∧ (checkCertificateFast 10 5534 fastCert10_5534=true) ∧ (checkCertificateFast 10 5535 fastCert10_5535=true) ∧ (checkCertificateFast 10 5536 fastCert10_5536=true) ∧ (checkCertificateFast 10 5537 fastCert10_5537=true) ∧ (checkCertificateFast 10 5538 fastCert10_5538=true) ∧ (checkCertificateFast 10 5539 fastCert10_5539=true) ∧ (checkCertificateFast 10 5540 fastCert10_5540=true) ∧ (checkCertificateFast 10 5541 fastCert10_5541=true) ∧ (checkCertificateFast 10 5542 fastCert10_5542=true) ∧ (checkCertificateFast 10 5543 fastCert10_5543=true) ∧ (checkCertificateFast 10 5544 fastCert10_5544=true) ∧ (checkCertificateFast 10 5545 fastCert10_5545=true) ∧ (checkCertificateFast 10 5546 fastCert10_5546=true) ∧ (checkCertificateFast 10 5547 fastCert10_5547=true) ∧ (checkCertificateFast 10 5548 fastCert10_5548=true) ∧ (checkCertificateFast 10 5549 fastCert10_5549=true) ∧ (checkCertificateFast 10 5550 fastCert10_5550=true) ∧ (checkCertificateFast 10 5551 fastCert10_5551=true) ∧ (checkCertificateFast 10 5552 fastCert10_5552=true) ∧ (checkCertificateFast 10 5553 fastCert10_5553=true) ∧ (checkCertificateFast 10 5554 fastCert10_5554=true) ∧ (checkCertificateFast 10 5555 fastCert10_5555=true) ∧ (checkCertificateFast 10 5556 fastCert10_5556=true) ∧ (checkCertificateFast 10 5557 fastCert10_5557=true) ∧ (checkCertificateFast 10 5558 fastCert10_5558=true) ∧ (checkCertificateFast 10 5559 fastCert10_5559=true) ∧ (checkCertificateFast 10 5560 fastCert10_5560=true) ∧ (checkCertificateFast 10 5561 fastCert10_5561=true) ∧ (checkCertificateFast 10 5562 fastCert10_5562=true) ∧ (checkCertificateFast 10 5563 fastCert10_5563=true) ∧ (checkCertificateFast 10 5564 fastCert10_5564=true) ∧ (checkCertificateFast 10 5565 fastCert10_5565=true) ∧ (checkCertificateFast 10 5566 fastCert10_5566=true) ∧ (checkCertificateFast 10 5567 fastCert10_5567=true) ∧ (checkCertificateFast 10 5568 fastCert10_5568=true) ∧ (checkCertificateFast 10 5569 fastCert10_5569=true) ∧ (checkCertificateFast 10 5570 fastCert10_5570=true) ∧ (checkCertificateFast 10 5571 fastCert10_5571=true) ∧ (checkCertificateFast 10 5572 fastCert10_5572=true) ∧ (checkCertificateFast 10 5573 fastCert10_5573=true) ∧ (checkCertificateFast 10 5574 fastCert10_5574=true) ∧ (checkCertificateFast 10 5575 fastCert10_5575=true) ∧ (checkCertificateFast 10 5576 fastCert10_5576=true) ∧ (checkCertificateFast 10 5577 fastCert10_5577=true) ∧ (checkCertificateFast 10 5578 fastCert10_5578=true) ∧ (checkCertificateFast 10 5579 fastCert10_5579=true) ∧ (checkCertificateFast 10 5580 fastCert10_5580=true) ∧ (checkCertificateFast 10 5581 fastCert10_5581=true) ∧ (checkCertificateFast 10 5582 fastCert10_5582=true) ∧ (checkCertificateFast 10 5583 fastCert10_5583=true) ∧ (checkCertificateFast 10 5584 fastCert10_5584=true) ∧ (checkCertificateFast 10 5585 fastCert10_5585=true) ∧ (checkCertificateFast 10 5586 fastCert10_5586=true) ∧ (checkCertificateFast 10 5587 fastCert10_5587=true) ∧ (checkCertificateFast 10 5588 fastCert10_5588=true) ∧ (checkCertificateFast 10 5589 fastCert10_5589=true) ∧ (checkCertificateFast 10 5590 fastCert10_5590=true) ∧ (checkCertificateFast 10 5591 fastCert10_5591=true) ∧ (checkCertificateFast 10 5592 fastCert10_5592=true) ∧ (checkCertificateFast 10 5593 fastCert10_5593=true) ∧ (checkCertificateFast 10 5594 fastCert10_5594=true) ∧ (checkCertificateFast 10 5595 fastCert10_5595=true) ∧ (checkCertificateFast 10 5596 fastCert10_5596=true) ∧ (checkCertificateFast 10 5597 fastCert10_5597=true) ∧ (checkCertificateFast 10 5598 fastCert10_5598=true) ∧ (checkCertificateFast 10 5599 fastCert10_5599=true) ∧ (checkCertificateFast 10 5600 fastCert10_5600=true) ∧ (checkCertificateFast 10 5601 fastCert10_5601=true) ∧ (checkCertificateFast 10 5602 fastCert10_5602=true) ∧ (checkCertificateFast 10 5603 fastCert10_5603=true) ∧ (checkCertificateFast 10 5604 fastCert10_5604=true) ∧ (checkCertificateFast 10 5605 fastCert10_5605=true) ∧ (checkCertificateFast 10 5606 fastCert10_5606=true) ∧ (checkCertificateFast 10 5607 fastCert10_5607=true) ∧ (checkCertificateFast 10 5608 fastCert10_5608=true) ∧ (checkCertificateFast 10 5609 fastCert10_5609=true) ∧ (checkCertificateFast 10 5610 fastCert10_5610=true) ∧ (checkCertificateFast 10 5611 fastCert10_5611=true) ∧ (checkCertificateFast 10 5612 fastCert10_5612=true) ∧ (checkCertificateFast 10 5613 fastCert10_5613=true) ∧ (checkCertificateFast 10 5614 fastCert10_5614=true) ∧ (checkCertificateFast 10 5615 fastCert10_5615=true) ∧ (checkCertificateFast 10 5616 fastCert10_5616=true) ∧ (checkCertificateFast 10 5617 fastCert10_5617=true) ∧ (checkCertificateFast 10 5618 fastCert10_5618=true) ∧ (checkCertificateFast 10 5619 fastCert10_5619=true) ∧ (checkCertificateFast 10 5620 fastCert10_5620=true) ∧ (checkCertificateFast 10 5621 fastCert10_5621=true) ∧ (checkCertificateFast 10 5622 fastCert10_5622=true) ∧ (checkCertificateFast 10 5623 fastCert10_5623=true) ∧ (checkCertificateFast 10 5624 fastCert10_5624=true) ∧ (checkCertificateFast 10 5625 fastCert10_5625=true) ∧ (checkCertificateFast 10 5626 fastCert10_5626=true) ∧ (checkCertificateFast 10 5627 fastCert10_5627=true) ∧ (checkCertificateFast 10 5628 fastCert10_5628=true) ∧ (checkCertificateFast 10 5629 fastCert10_5629=true) ∧ (checkCertificateFast 10 5630 fastCert10_5630=true) ∧ (checkCertificateFast 10 5631 fastCert10_5631=true) ∧ (checkCertificateFast 10 5632 fastCert10_5632=true) ∧ (checkCertificateFast 10 5633 fastCert10_5633=true) ∧ (checkCertificateFast 10 5634 fastCert10_5634=true) ∧ (checkCertificateFast 10 5635 fastCert10_5635=true) ∧ (checkCertificateFast 10 5636 fastCert10_5636=true) ∧ (checkCertificateFast 10 5637 fastCert10_5637=true) ∧ (checkCertificateFast 10 5638 fastCert10_5638=true) ∧ (checkCertificateFast 10 5639 fastCert10_5639=true) ∧ (checkCertificateFast 10 5640 fastCert10_5640=true) ∧ (checkCertificateFast 10 5641 fastCert10_5641=true) ∧ (checkCertificateFast 10 5642 fastCert10_5642=true) ∧ (checkCertificateFast 10 5643 fastCert10_5643=true) ∧ (checkCertificateFast 10 5644 fastCert10_5644=true) ∧ (checkCertificateFast 10 5645 fastCert10_5645=true) ∧ (checkCertificateFast 10 5646 fastCert10_5646=true) ∧ (checkCertificateFast 10 5647 fastCert10_5647=true) ∧ (checkCertificateFast 10 5648 fastCert10_5648=true) ∧ (checkCertificateFast 10 5649 fastCert10_5649=true) ∧ (checkCertificateFast 10 5650 fastCert10_5650=true) ∧ (checkCertificateFast 10 5651 fastCert10_5651=true) ∧ (checkCertificateFast 10 5652 fastCert10_5652=true) ∧ (checkCertificateFast 10 5653 fastCert10_5653=true) ∧ (checkCertificateFast 10 5654 fastCert10_5654=true) ∧ (checkCertificateFast 10 5655 fastCert10_5655=true) ∧ (checkCertificateFast 10 5656 fastCert10_5656=true) ∧ (checkCertificateFast 10 5657 fastCert10_5657=true) ∧ (checkCertificateFast 10 5658 fastCert10_5658=true) ∧ (checkCertificateFast 10 5659 fastCert10_5659=true) ∧ (checkCertificateFast 10 5660 fastCert10_5660=true) ∧ (checkCertificateFast 10 5661 fastCert10_5661=true) ∧ (checkCertificateFast 10 5662 fastCert10_5662=true) ∧ (checkCertificateFast 10 5663 fastCert10_5663=true) ∧ (checkCertificateFast 10 5664 fastCert10_5664=true) ∧ (checkCertificateFast 10 5665 fastCert10_5665=true) ∧ (checkCertificateFast 10 5666 fastCert10_5666=true) ∧ (checkCertificateFast 10 5667 fastCert10_5667=true) ∧ (checkCertificateFast 10 5668 fastCert10_5668=true) ∧ (checkCertificateFast 10 5669 fastCert10_5669=true) ∧ (checkCertificateFast 10 5670 fastCert10_5670=true) ∧ (checkCertificateFast 10 5671 fastCert10_5671=true) ∧ (checkCertificateFast 10 5672 fastCert10_5672=true) ∧ (checkCertificateFast 10 5673 fastCert10_5673=true) ∧ (checkCertificateFast 10 5674 fastCert10_5674=true) ∧ (checkCertificateFast 10 5675 fastCert10_5675=true) ∧ (checkCertificateFast 10 5676 fastCert10_5676=true) ∧ (checkCertificateFast 10 5677 fastCert10_5677=true) ∧ (checkCertificateFast 10 5678 fastCert10_5678=true) ∧ (checkCertificateFast 10 5679 fastCert10_5679=true) ∧ (checkCertificateFast 10 5680 fastCert10_5680=true) ∧ (checkCertificateFast 10 5681 fastCert10_5681=true) ∧ (checkCertificateFast 10 5682 fastCert10_5682=true) ∧ (checkCertificateFast 10 5683 fastCert10_5683=true) ∧ (checkCertificateFast 10 5684 fastCert10_5684=true) ∧ (checkCertificateFast 10 5685 fastCert10_5685=true) ∧ (checkCertificateFast 10 5686 fastCert10_5686=true) ∧ (checkCertificateFast 10 5687 fastCert10_5687=true) ∧ (checkCertificateFast 10 5688 fastCert10_5688=true) ∧ (checkCertificateFast 10 5689 fastCert10_5689=true) ∧ (checkCertificateFast 10 5690 fastCert10_5690=true) ∧ (checkCertificateFast 10 5691 fastCert10_5691=true) ∧ (checkCertificateFast 10 5692 fastCert10_5692=true) ∧ (checkCertificateFast 10 5693 fastCert10_5693=true) ∧ (checkCertificateFast 10 5694 fastCert10_5694=true) ∧ (checkCertificateFast 10 5695 fastCert10_5695=true) ∧ (checkCertificateFast 10 5696 fastCert10_5696=true) ∧ (checkCertificateFast 10 5697 fastCert10_5697=true) ∧ (checkCertificateFast 10 5698 fastCert10_5698=true) ∧ (checkCertificateFast 10 5699 fastCert10_5699=true) ∧ (checkCertificateFast 10 5700 fastCert10_5700=true) ∧ (checkCertificateFast 10 5701 fastCert10_5701=true) ∧ (checkCertificateFast 10 5702 fastCert10_5702=true) ∧ (checkCertificateFast 10 5703 fastCert10_5703=true) ∧ (checkCertificateFast 10 5704 fastCert10_5704=true) ∧ (checkCertificateFast 10 5705 fastCert10_5705=true) ∧ (checkCertificateFast 10 5706 fastCert10_5706=true) ∧ (checkCertificateFast 10 5707 fastCert10_5707=true) ∧ (checkCertificateFast 10 5708 fastCert10_5708=true) ∧ (checkCertificateFast 10 5709 fastCert10_5709=true) ∧ (checkCertificateFast 10 5710 fastCert10_5710=true) ∧ (checkCertificateFast 10 5711 fastCert10_5711=true) ∧ (checkCertificateFast 10 5712 fastCert10_5712=true) ∧ (checkCertificateFast 10 5713 fastCert10_5713=true) ∧ (checkCertificateFast 10 5714 fastCert10_5714=true) ∧ (checkCertificateFast 10 5715 fastCert10_5715=true) ∧ (checkCertificateFast 10 5716 fastCert10_5716=true) ∧ (checkCertificateFast 10 5717 fastCert10_5717=true) ∧ (checkCertificateFast 10 5718 fastCert10_5718=true) ∧ (checkCertificateFast 10 5719 fastCert10_5719=true) ∧ (checkCertificateFast 10 5720 fastCert10_5720=true) ∧ (checkCertificateFast 10 5721 fastCert10_5721=true) ∧ (checkCertificateFast 10 5722 fastCert10_5722=true) ∧ (checkCertificateFast 10 5723 fastCert10_5723=true) ∧ (checkCertificateFast 10 5724 fastCert10_5724=true) ∧ (checkCertificateFast 10 5725 fastCert10_5725=true) ∧ (checkCertificateFast 10 5726 fastCert10_5726=true) ∧ (checkCertificateFast 10 5727 fastCert10_5727=true) ∧ (checkCertificateFast 10 5728 fastCert10_5728=true) ∧ (checkCertificateFast 10 5729 fastCert10_5729=true) ∧ (checkCertificateFast 10 5730 fastCert10_5730=true) ∧ (checkCertificateFast 10 5731 fastCert10_5731=true) ∧ (checkCertificateFast 10 5732 fastCert10_5732=true) ∧ (checkCertificateFast 10 5733 fastCert10_5733=true) ∧ (checkCertificateFast 10 5734 fastCert10_5734=true) ∧ (checkCertificateFast 10 5735 fastCert10_5735=true) ∧ (checkCertificateFast 10 5736 fastCert10_5736=true) ∧ (checkCertificateFast 10 5737 fastCert10_5737=true) ∧ (checkCertificateFast 10 5738 fastCert10_5738=true) ∧ (checkCertificateFast 10 5739 fastCert10_5739=true) ∧ (checkCertificateFast 10 5740 fastCert10_5740=true) ∧ (checkCertificateFast 10 5741 fastCert10_5741=true) ∧ (checkCertificateFast 10 5742 fastCert10_5742=true) ∧ (checkCertificateFast 10 5743 fastCert10_5743=true) ∧ (checkCertificateFast 10 5744 fastCert10_5744=true) ∧ (checkCertificateFast 10 5745 fastCert10_5745=true) ∧ (checkCertificateFast 10 5746 fastCert10_5746=true) ∧ (checkCertificateFast 10 5747 fastCert10_5747=true) ∧ (checkCertificateFast 10 5748 fastCert10_5748=true) ∧ (checkCertificateFast 10 5749 fastCert10_5749=true) ∧ (checkCertificateFast 10 5750 fastCert10_5750=true) ∧ (checkCertificateFast 10 5751 fastCert10_5751=true) ∧ (checkCertificateFast 10 5752 fastCert10_5752=true) ∧ (checkCertificateFast 10 5753 fastCert10_5753=true) ∧ (checkCertificateFast 10 5754 fastCert10_5754=true) ∧ (checkCertificateFast 10 5755 fastCert10_5755=true) ∧ (checkCertificateFast 10 5756 fastCert10_5756=true) ∧ (checkCertificateFast 10 5757 fastCert10_5757=true) ∧ (checkCertificateFast 10 5758 fastCert10_5758=true) ∧ (checkCertificateFast 10 5759 fastCert10_5759=true) ∧ (checkCertificateFast 10 5760 fastCert10_5760=true) ∧ (checkCertificateFast 10 5761 fastCert10_5761=true) ∧ (checkCertificateFast 10 5762 fastCert10_5762=true) ∧ (checkCertificateFast 10 5763 fastCert10_5763=true) ∧ (checkCertificateFast 10 5764 fastCert10_5764=true) ∧ (checkCertificateFast 10 5765 fastCert10_5765=true) ∧ (checkCertificateFast 10 5766 fastCert10_5766=true) ∧ (checkCertificateFast 10 5767 fastCert10_5767=true) ∧ (checkCertificateFast 10 5768 fastCert10_5768=true) ∧ (checkCertificateFast 10 5769 fastCert10_5769=true) ∧ (checkCertificateFast 10 5770 fastCert10_5770=true) ∧ (checkCertificateFast 10 5771 fastCert10_5771=true) ∧ (checkCertificateFast 10 5772 fastCert10_5772=true) ∧ (checkCertificateFast 10 5773 fastCert10_5773=true) ∧ (checkCertificateFast 10 5774 fastCert10_5774=true) ∧ (checkCertificateFast 10 5775 fastCert10_5775=true) ∧ (checkCertificateFast 10 5776 fastCert10_5776=true) ∧ (checkCertificateFast 10 5777 fastCert10_5777=true) ∧ (checkCertificateFast 10 5778 fastCert10_5778=true) ∧ (checkCertificateFast 10 5779 fastCert10_5779=true) ∧ (checkCertificateFast 10 5780 fastCert10_5780=true) ∧ (checkCertificateFast 10 5781 fastCert10_5781=true) ∧ (checkCertificateFast 10 5782 fastCert10_5782=true) ∧ (checkCertificateFast 10 5783 fastCert10_5783=true) ∧ (checkCertificateFast 10 5784 fastCert10_5784=true) ∧ (checkCertificateFast 10 5785 fastCert10_5785=true) ∧ (checkCertificateFast 10 5786 fastCert10_5786=true) ∧ (checkCertificateFast 10 5787 fastCert10_5787=true) ∧ (checkCertificateFast 10 5788 fastCert10_5788=true) ∧ (checkCertificateFast 10 5789 fastCert10_5789=true) ∧ (checkCertificateFast 10 5790 fastCert10_5790=true) ∧ (checkCertificateFast 10 5791 fastCert10_5791=true) ∧ (checkCertificateFast 10 5792 fastCert10_5792=true) ∧ (checkCertificateFast 10 5793 fastCert10_5793=true) ∧ (checkCertificateFast 10 5794 fastCert10_5794=true) ∧ (checkCertificateFast 10 5795 fastCert10_5795=true) ∧ (checkCertificateFast 10 5796 fastCert10_5796=true) ∧ (checkCertificateFast 10 5797 fastCert10_5797=true) ∧ (checkCertificateFast 10 5798 fastCert10_5798=true) ∧ (checkCertificateFast 10 5799 fastCert10_5799=true) ∧ (checkCertificateFast 10 5800 fastCert10_5800=true) ∧ (checkCertificateFast 10 5801 fastCert10_5801=true) ∧ (checkCertificateFast 10 5802 fastCert10_5802=true) ∧ (checkCertificateFast 10 5803 fastCert10_5803=true) ∧ (checkCertificateFast 10 5804 fastCert10_5804=true) ∧ (checkCertificateFast 10 5805 fastCert10_5805=true) ∧ (checkCertificateFast 10 5806 fastCert10_5806=true) ∧ (checkCertificateFast 10 5807 fastCert10_5807=true) ∧ (checkCertificateFast 10 5808 fastCert10_5808=true) ∧ (checkCertificateFast 10 5809 fastCert10_5809=true) ∧ (checkCertificateFast 10 5810 fastCert10_5810=true) ∧ (checkCertificateFast 10 5811 fastCert10_5811=true) ∧ (checkCertificateFast 10 5812 fastCert10_5812=true) ∧ (checkCertificateFast 10 5813 fastCert10_5813=true) ∧ (checkCertificateFast 10 5814 fastCert10_5814=true) ∧ (checkCertificateFast 10 5815 fastCert10_5815=true) ∧ (checkCertificateFast 10 5816 fastCert10_5816=true) ∧ (checkCertificateFast 10 5817 fastCert10_5817=true) ∧ (checkCertificateFast 10 5818 fastCert10_5818=true) ∧ (checkCertificateFast 10 5819 fastCert10_5819=true) ∧ (checkCertificateFast 10 5820 fastCert10_5820=true) ∧ (checkCertificateFast 10 5821 fastCert10_5821=true) ∧ (checkCertificateFast 10 5822 fastCert10_5822=true) ∧ (checkCertificateFast 10 5823 fastCert10_5823=true) ∧ (checkCertificateFast 10 5824 fastCert10_5824=true) ∧ (checkCertificateFast 10 5825 fastCert10_5825=true) ∧ (checkCertificateFast 10 5826 fastCert10_5826=true) ∧ (checkCertificateFast 10 5827 fastCert10_5827=true) ∧ (checkCertificateFast 10 5828 fastCert10_5828=true) ∧ (checkCertificateFast 10 5829 fastCert10_5829=true) ∧ (checkCertificateFast 10 5830 fastCert10_5830=true) ∧ (checkCertificateFast 10 5831 fastCert10_5831=true) ∧ (checkCertificateFast 10 5832 fastCert10_5832=true) ∧ (checkCertificateFast 10 5833 fastCert10_5833=true) ∧ (checkCertificateFast 10 5834 fastCert10_5834=true) ∧ (checkCertificateFast 10 5835 fastCert10_5835=true) ∧ (checkCertificateFast 10 5836 fastCert10_5836=true) ∧ (checkCertificateFast 10 5837 fastCert10_5837=true) ∧ (checkCertificateFast 10 5838 fastCert10_5838=true) ∧ (checkCertificateFast 10 5839 fastCert10_5839=true) ∧ (checkCertificateFast 10 5840 fastCert10_5840=true) ∧ (checkCertificateFast 10 5841 fastCert10_5841=true) ∧ (checkCertificateFast 10 5842 fastCert10_5842=true) ∧ (checkCertificateFast 10 5843 fastCert10_5843=true) ∧ (checkCertificateFast 10 5844 fastCert10_5844=true) ∧ (checkCertificateFast 10 5845 fastCert10_5845=true) ∧ (checkCertificateFast 10 5846 fastCert10_5846=true) ∧ (checkCertificateFast 10 5847 fastCert10_5847=true) ∧ (checkCertificateFast 10 5848 fastCert10_5848=true) ∧ (checkCertificateFast 10 5849 fastCert10_5849=true) ∧ (checkCertificateFast 10 5850 fastCert10_5850=true) ∧ (checkCertificateFast 10 5851 fastCert10_5851=true) ∧ (checkCertificateFast 10 5852 fastCert10_5852=true) ∧ (checkCertificateFast 10 5853 fastCert10_5853=true) ∧ (checkCertificateFast 10 5854 fastCert10_5854=true) ∧ (checkCertificateFast 10 5855 fastCert10_5855=true) ∧ (checkCertificateFast 10 5856 fastCert10_5856=true) ∧ (checkCertificateFast 10 5857 fastCert10_5857=true) ∧ (checkCertificateFast 10 5858 fastCert10_5858=true) ∧ (checkCertificateFast 10 5859 fastCert10_5859=true) ∧ (checkCertificateFast 10 5860 fastCert10_5860=true) ∧ (checkCertificateFast 10 5861 fastCert10_5861=true) ∧ (checkCertificateFast 10 5862 fastCert10_5862=true) ∧ (checkCertificateFast 10 5863 fastCert10_5863=true) ∧ (checkCertificateFast 10 5864 fastCert10_5864=true) ∧ (checkCertificateFast 10 5865 fastCert10_5865=true) ∧ (checkCertificateFast 10 5866 fastCert10_5866=true) ∧ (checkCertificateFast 10 5867 fastCert10_5867=true) ∧ (checkCertificateFast 10 5868 fastCert10_5868=true) ∧ (checkCertificateFast 10 5869 fastCert10_5869=true) ∧ (checkCertificateFast 10 5870 fastCert10_5870=true) ∧ (checkCertificateFast 10 5871 fastCert10_5871=true) ∧ (checkCertificateFast 10 5872 fastCert10_5872=true) ∧ (checkCertificateFast 10 5873 fastCert10_5873=true) ∧ (checkCertificateFast 10 5874 fastCert10_5874=true) ∧ (checkCertificateFast 10 5875 fastCert10_5875=true) ∧ (checkCertificateFast 10 5876 fastCert10_5876=true) ∧ (checkCertificateFast 10 5877 fastCert10_5877=true) ∧ (checkCertificateFast 10 5878 fastCert10_5878=true) ∧ (checkCertificateFast 10 5879 fastCert10_5879=true) ∧ (checkCertificateFast 10 5880 fastCert10_5880=true) ∧ (checkCertificateFast 10 5881 fastCert10_5881=true) ∧ (checkCertificateFast 10 5882 fastCert10_5882=true) ∧ (checkCertificateFast 10 5883 fastCert10_5883=true) ∧ (checkCertificateFast 10 5884 fastCert10_5884=true) ∧ (checkCertificateFast 10 5885 fastCert10_5885=true) ∧ (checkCertificateFast 10 5886 fastCert10_5886=true) ∧ (checkCertificateFast 10 5887 fastCert10_5887=true) ∧ (checkCertificateFast 10 5888 fastCert10_5888=true) ∧ (checkCertificateFast 10 5889 fastCert10_5889=true) ∧ (checkCertificateFast 10 5890 fastCert10_5890=true) ∧ (checkCertificateFast 10 5891 fastCert10_5891=true) ∧ (checkCertificateFast 10 5892 fastCert10_5892=true) ∧ (checkCertificateFast 10 5893 fastCert10_5893=true) ∧ (checkCertificateFast 10 5894 fastCert10_5894=true) ∧ (checkCertificateFast 10 5895 fastCert10_5895=true) ∧ (checkCertificateFast 10 5896 fastCert10_5896=true) ∧ (checkCertificateFast 10 5897 fastCert10_5897=true) ∧ (checkCertificateFast 10 5898 fastCert10_5898=true) ∧ (checkCertificateFast 10 5899 fastCert10_5899=true) ∧ (checkCertificateFast 10 5900 fastCert10_5900=true) ∧ (checkCertificateFast 10 5901 fastCert10_5901=true) ∧ (checkCertificateFast 10 5902 fastCert10_5902=true) ∧ (checkCertificateFast 10 5903 fastCert10_5903=true) ∧ (checkCertificateFast 10 5904 fastCert10_5904=true) ∧ (checkCertificateFast 10 5905 fastCert10_5905=true) ∧ (checkCertificateFast 10 5906 fastCert10_5906=true) ∧ (checkCertificateFast 10 5907 fastCert10_5907=true) ∧ (checkCertificateFast 10 5908 fastCert10_5908=true) ∧ (checkCertificateFast 10 5909 fastCert10_5909=true) ∧ (checkCertificateFast 10 5910 fastCert10_5910=true) ∧ (checkCertificateFast 10 5911 fastCert10_5911=true) ∧ (checkCertificateFast 10 5912 fastCert10_5912=true) ∧ (checkCertificateFast 10 5913 fastCert10_5913=true) ∧ (checkCertificateFast 10 5914 fastCert10_5914=true) ∧ (checkCertificateFast 10 5915 fastCert10_5915=true) ∧ (checkCertificateFast 10 5916 fastCert10_5916=true) ∧ (checkCertificateFast 10 5917 fastCert10_5917=true) ∧ (checkCertificateFast 10 5918 fastCert10_5918=true) ∧ (checkCertificateFast 10 5919 fastCert10_5919=true) ∧ (checkCertificateFast 10 5920 fastCert10_5920=true) ∧ (checkCertificateFast 10 5921 fastCert10_5921=true) ∧ (checkCertificateFast 10 5922 fastCert10_5922=true) ∧ (checkCertificateFast 10 5923 fastCert10_5923=true) ∧ (checkCertificateFast 10 5924 fastCert10_5924=true) ∧ (checkCertificateFast 10 5925 fastCert10_5925=true) ∧ (checkCertificateFast 10 5926 fastCert10_5926=true) ∧ (checkCertificateFast 10 5927 fastCert10_5927=true) ∧ (checkCertificateFast 10 5928 fastCert10_5928=true) ∧ (checkCertificateFast 10 5929 fastCert10_5929=true) ∧ (checkCertificateFast 10 5930 fastCert10_5930=true) ∧ (checkCertificateFast 10 5931 fastCert10_5931=true) ∧ (checkCertificateFast 10 5932 fastCert10_5932=true) ∧ (checkCertificateFast 10 5933 fastCert10_5933=true) ∧ (checkCertificateFast 10 5934 fastCert10_5934=true) ∧ (checkCertificateFast 10 5935 fastCert10_5935=true) ∧ (checkCertificateFast 10 5936 fastCert10_5936=true) ∧ (checkCertificateFast 10 5937 fastCert10_5937=true) ∧ (checkCertificateFast 10 5938 fastCert10_5938=true) ∧ (checkCertificateFast 10 5939 fastCert10_5939=true) ∧ (checkCertificateFast 10 5940 fastCert10_5940=true) ∧ (checkCertificateFast 10 5941 fastCert10_5941=true) ∧ (checkCertificateFast 10 5942 fastCert10_5942=true) ∧ (checkCertificateFast 10 5943 fastCert10_5943=true) ∧ (checkCertificateFast 10 5944 fastCert10_5944=true) ∧ (checkCertificateFast 10 5945 fastCert10_5945=true) ∧ (checkCertificateFast 10 5946 fastCert10_5946=true) ∧ (checkCertificateFast 10 5947 fastCert10_5947=true) ∧ (checkCertificateFast 10 5948 fastCert10_5948=true) ∧ (checkCertificateFast 10 5949 fastCert10_5949=true) ∧ (checkCertificateFast 10 5950 fastCert10_5950=true) ∧ (checkCertificateFast 10 5951 fastCert10_5951=true) ∧ (checkCertificateFast 10 5952 fastCert10_5952=true) ∧ (checkCertificateFast 10 5953 fastCert10_5953=true) ∧ (checkCertificateFast 10 5954 fastCert10_5954=true) ∧ (checkCertificateFast 10 5955 fastCert10_5955=true) ∧ (checkCertificateFast 10 5956 fastCert10_5956=true) ∧ (checkCertificateFast 10 5957 fastCert10_5957=true) ∧ (checkCertificateFast 10 5958 fastCert10_5958=true) ∧ (checkCertificateFast 10 5959 fastCert10_5959=true) ∧ (checkCertificateFast 10 5960 fastCert10_5960=true) ∧ (checkCertificateFast 10 5961 fastCert10_5961=true) ∧ (checkCertificateFast 10 5962 fastCert10_5962=true) ∧ (checkCertificateFast 10 5963 fastCert10_5963=true) ∧ (checkCertificateFast 10 5964 fastCert10_5964=true) ∧ (checkCertificateFast 10 5965 fastCert10_5965=true) ∧ (checkCertificateFast 10 5966 fastCert10_5966=true) ∧ (checkCertificateFast 10 5967 fastCert10_5967=true) ∧ (checkCertificateFast 10 5968 fastCert10_5968=true) ∧ (checkCertificateFast 10 5969 fastCert10_5969=true) ∧ (checkCertificateFast 10 5970 fastCert10_5970=true) ∧ (checkCertificateFast 10 5971 fastCert10_5971=true) ∧ (checkCertificateFast 10 5972 fastCert10_5972=true) ∧ (checkCertificateFast 10 5973 fastCert10_5973=true) ∧ (checkCertificateFast 10 5974 fastCert10_5974=true) ∧ (checkCertificateFast 10 5975 fastCert10_5975=true) ∧ (checkCertificateFast 10 5976 fastCert10_5976=true) ∧ (checkCertificateFast 10 5977 fastCert10_5977=true) ∧ (checkCertificateFast 10 5978 fastCert10_5978=true) ∧ (checkCertificateFast 10 5979 fastCert10_5979=true) ∧ (checkCertificateFast 10 5980 fastCert10_5980=true) ∧ (checkCertificateFast 10 5981 fastCert10_5981=true) ∧ (checkCertificateFast 10 5982 fastCert10_5982=true) ∧ (checkCertificateFast 10 5983 fastCert10_5983=true) ∧ (checkCertificateFast 10 5984 fastCert10_5984=true) ∧ (checkCertificateFast 10 5985 fastCert10_5985=true) ∧ (checkCertificateFast 10 5986 fastCert10_5986=true) ∧ (checkCertificateFast 10 5987 fastCert10_5987=true) ∧ (checkCertificateFast 10 5988 fastCert10_5988=true) ∧ (checkCertificateFast 10 5989 fastCert10_5989=true) ∧ (checkCertificateFast 10 5990 fastCert10_5990=true) ∧ (checkCertificateFast 10 5991 fastCert10_5991=true) ∧ (checkCertificateFast 10 5992 fastCert10_5992=true) ∧ (checkCertificateFast 10 5993 fastCert10_5993=true) ∧ (checkCertificateFast 10 5994 fastCert10_5994=true) ∧ (checkCertificateFast 10 5995 fastCert10_5995=true) ∧ (checkCertificateFast 10 5996 fastCert10_5996=true) ∧ (checkCertificateFast 10 5997 fastCert10_5997=true) ∧ (checkCertificateFast 10 5998 fastCert10_5998=true) ∧ (checkCertificateFast 10 5999 fastCert10_5999=true) :=
  ⟨fastCase10_5000,fastCase10_5001,fastCase10_5002,fastCase10_5003,fastCase10_5004,fastCase10_5005,fastCase10_5006,fastCase10_5007,fastCase10_5008,fastCase10_5009,fastCase10_5010,fastCase10_5011,fastCase10_5012,fastCase10_5013,fastCase10_5014,fastCase10_5015,fastCase10_5016,fastCase10_5017,fastCase10_5018,fastCase10_5019,fastCase10_5020,fastCase10_5021,fastCase10_5022,fastCase10_5023,fastCase10_5024,fastCase10_5025,fastCase10_5026,fastCase10_5027,fastCase10_5028,fastCase10_5029,fastCase10_5030,fastCase10_5031,fastCase10_5032,fastCase10_5033,fastCase10_5034,fastCase10_5035,fastCase10_5036,fastCase10_5037,fastCase10_5038,fastCase10_5039,fastCase10_5040,fastCase10_5041,fastCase10_5042,fastCase10_5043,fastCase10_5044,fastCase10_5045,fastCase10_5046,fastCase10_5047,fastCase10_5048,fastCase10_5049,fastCase10_5050,fastCase10_5051,fastCase10_5052,fastCase10_5053,fastCase10_5054,fastCase10_5055,fastCase10_5056,fastCase10_5057,fastCase10_5058,fastCase10_5059,fastCase10_5060,fastCase10_5061,fastCase10_5062,fastCase10_5063,fastCase10_5064,fastCase10_5065,fastCase10_5066,fastCase10_5067,fastCase10_5068,fastCase10_5069,fastCase10_5070,fastCase10_5071,fastCase10_5072,fastCase10_5073,fastCase10_5074,fastCase10_5075,fastCase10_5076,fastCase10_5077,fastCase10_5078,fastCase10_5079,fastCase10_5080,fastCase10_5081,fastCase10_5082,fastCase10_5083,fastCase10_5084,fastCase10_5085,fastCase10_5086,fastCase10_5087,fastCase10_5088,fastCase10_5089,fastCase10_5090,fastCase10_5091,fastCase10_5092,fastCase10_5093,fastCase10_5094,fastCase10_5095,fastCase10_5096,fastCase10_5097,fastCase10_5098,fastCase10_5099,fastCase10_5100,fastCase10_5101,fastCase10_5102,fastCase10_5103,fastCase10_5104,fastCase10_5105,fastCase10_5106,fastCase10_5107,fastCase10_5108,fastCase10_5109,fastCase10_5110,fastCase10_5111,fastCase10_5112,fastCase10_5113,fastCase10_5114,fastCase10_5115,fastCase10_5116,fastCase10_5117,fastCase10_5118,fastCase10_5119,fastCase10_5120,fastCase10_5121,fastCase10_5122,fastCase10_5123,fastCase10_5124,fastCase10_5125,fastCase10_5126,fastCase10_5127,fastCase10_5128,fastCase10_5129,fastCase10_5130,fastCase10_5131,fastCase10_5132,fastCase10_5133,fastCase10_5134,fastCase10_5135,fastCase10_5136,fastCase10_5137,fastCase10_5138,fastCase10_5139,fastCase10_5140,fastCase10_5141,fastCase10_5142,fastCase10_5143,fastCase10_5144,fastCase10_5145,fastCase10_5146,fastCase10_5147,fastCase10_5148,fastCase10_5149,fastCase10_5150,fastCase10_5151,fastCase10_5152,fastCase10_5153,fastCase10_5154,fastCase10_5155,fastCase10_5156,fastCase10_5157,fastCase10_5158,fastCase10_5159,fastCase10_5160,fastCase10_5161,fastCase10_5162,fastCase10_5163,fastCase10_5164,fastCase10_5165,fastCase10_5166,fastCase10_5167,fastCase10_5168,fastCase10_5169,fastCase10_5170,fastCase10_5171,fastCase10_5172,fastCase10_5173,fastCase10_5174,fastCase10_5175,fastCase10_5176,fastCase10_5177,fastCase10_5178,fastCase10_5179,fastCase10_5180,fastCase10_5181,fastCase10_5182,fastCase10_5183,fastCase10_5184,fastCase10_5185,fastCase10_5186,fastCase10_5187,fastCase10_5188,fastCase10_5189,fastCase10_5190,fastCase10_5191,fastCase10_5192,fastCase10_5193,fastCase10_5194,fastCase10_5195,fastCase10_5196,fastCase10_5197,fastCase10_5198,fastCase10_5199,fastCase10_5200,fastCase10_5201,fastCase10_5202,fastCase10_5203,fastCase10_5204,fastCase10_5205,fastCase10_5206,fastCase10_5207,fastCase10_5208,fastCase10_5209,fastCase10_5210,fastCase10_5211,fastCase10_5212,fastCase10_5213,fastCase10_5214,fastCase10_5215,fastCase10_5216,fastCase10_5217,fastCase10_5218,fastCase10_5219,fastCase10_5220,fastCase10_5221,fastCase10_5222,fastCase10_5223,fastCase10_5224,fastCase10_5225,fastCase10_5226,fastCase10_5227,fastCase10_5228,fastCase10_5229,fastCase10_5230,fastCase10_5231,fastCase10_5232,fastCase10_5233,fastCase10_5234,fastCase10_5235,fastCase10_5236,fastCase10_5237,fastCase10_5238,fastCase10_5239,fastCase10_5240,fastCase10_5241,fastCase10_5242,fastCase10_5243,fastCase10_5244,fastCase10_5245,fastCase10_5246,fastCase10_5247,fastCase10_5248,fastCase10_5249,fastCase10_5250,fastCase10_5251,fastCase10_5252,fastCase10_5253,fastCase10_5254,fastCase10_5255,fastCase10_5256,fastCase10_5257,fastCase10_5258,fastCase10_5259,fastCase10_5260,fastCase10_5261,fastCase10_5262,fastCase10_5263,fastCase10_5264,fastCase10_5265,fastCase10_5266,fastCase10_5267,fastCase10_5268,fastCase10_5269,fastCase10_5270,fastCase10_5271,fastCase10_5272,fastCase10_5273,fastCase10_5274,fastCase10_5275,fastCase10_5276,fastCase10_5277,fastCase10_5278,fastCase10_5279,fastCase10_5280,fastCase10_5281,fastCase10_5282,fastCase10_5283,fastCase10_5284,fastCase10_5285,fastCase10_5286,fastCase10_5287,fastCase10_5288,fastCase10_5289,fastCase10_5290,fastCase10_5291,fastCase10_5292,fastCase10_5293,fastCase10_5294,fastCase10_5295,fastCase10_5296,fastCase10_5297,fastCase10_5298,fastCase10_5299,fastCase10_5300,fastCase10_5301,fastCase10_5302,fastCase10_5303,fastCase10_5304,fastCase10_5305,fastCase10_5306,fastCase10_5307,fastCase10_5308,fastCase10_5309,fastCase10_5310,fastCase10_5311,fastCase10_5312,fastCase10_5313,fastCase10_5314,fastCase10_5315,fastCase10_5316,fastCase10_5317,fastCase10_5318,fastCase10_5319,fastCase10_5320,fastCase10_5321,fastCase10_5322,fastCase10_5323,fastCase10_5324,fastCase10_5325,fastCase10_5326,fastCase10_5327,fastCase10_5328,fastCase10_5329,fastCase10_5330,fastCase10_5331,fastCase10_5332,fastCase10_5333,fastCase10_5334,fastCase10_5335,fastCase10_5336,fastCase10_5337,fastCase10_5338,fastCase10_5339,fastCase10_5340,fastCase10_5341,fastCase10_5342,fastCase10_5343,fastCase10_5344,fastCase10_5345,fastCase10_5346,fastCase10_5347,fastCase10_5348,fastCase10_5349,fastCase10_5350,fastCase10_5351,fastCase10_5352,fastCase10_5353,fastCase10_5354,fastCase10_5355,fastCase10_5356,fastCase10_5357,fastCase10_5358,fastCase10_5359,fastCase10_5360,fastCase10_5361,fastCase10_5362,fastCase10_5363,fastCase10_5364,fastCase10_5365,fastCase10_5366,fastCase10_5367,fastCase10_5368,fastCase10_5369,fastCase10_5370,fastCase10_5371,fastCase10_5372,fastCase10_5373,fastCase10_5374,fastCase10_5375,fastCase10_5376,fastCase10_5377,fastCase10_5378,fastCase10_5379,fastCase10_5380,fastCase10_5381,fastCase10_5382,fastCase10_5383,fastCase10_5384,fastCase10_5385,fastCase10_5386,fastCase10_5387,fastCase10_5388,fastCase10_5389,fastCase10_5390,fastCase10_5391,fastCase10_5392,fastCase10_5393,fastCase10_5394,fastCase10_5395,fastCase10_5396,fastCase10_5397,fastCase10_5398,fastCase10_5399,fastCase10_5400,fastCase10_5401,fastCase10_5402,fastCase10_5403,fastCase10_5404,fastCase10_5405,fastCase10_5406,fastCase10_5407,fastCase10_5408,fastCase10_5409,fastCase10_5410,fastCase10_5411,fastCase10_5412,fastCase10_5413,fastCase10_5414,fastCase10_5415,fastCase10_5416,fastCase10_5417,fastCase10_5418,fastCase10_5419,fastCase10_5420,fastCase10_5421,fastCase10_5422,fastCase10_5423,fastCase10_5424,fastCase10_5425,fastCase10_5426,fastCase10_5427,fastCase10_5428,fastCase10_5429,fastCase10_5430,fastCase10_5431,fastCase10_5432,fastCase10_5433,fastCase10_5434,fastCase10_5435,fastCase10_5436,fastCase10_5437,fastCase10_5438,fastCase10_5439,fastCase10_5440,fastCase10_5441,fastCase10_5442,fastCase10_5443,fastCase10_5444,fastCase10_5445,fastCase10_5446,fastCase10_5447,fastCase10_5448,fastCase10_5449,fastCase10_5450,fastCase10_5451,fastCase10_5452,fastCase10_5453,fastCase10_5454,fastCase10_5455,fastCase10_5456,fastCase10_5457,fastCase10_5458,fastCase10_5459,fastCase10_5460,fastCase10_5461,fastCase10_5462,fastCase10_5463,fastCase10_5464,fastCase10_5465,fastCase10_5466,fastCase10_5467,fastCase10_5468,fastCase10_5469,fastCase10_5470,fastCase10_5471,fastCase10_5472,fastCase10_5473,fastCase10_5474,fastCase10_5475,fastCase10_5476,fastCase10_5477,fastCase10_5478,fastCase10_5479,fastCase10_5480,fastCase10_5481,fastCase10_5482,fastCase10_5483,fastCase10_5484,fastCase10_5485,fastCase10_5486,fastCase10_5487,fastCase10_5488,fastCase10_5489,fastCase10_5490,fastCase10_5491,fastCase10_5492,fastCase10_5493,fastCase10_5494,fastCase10_5495,fastCase10_5496,fastCase10_5497,fastCase10_5498,fastCase10_5499,fastCase10_5500,fastCase10_5501,fastCase10_5502,fastCase10_5503,fastCase10_5504,fastCase10_5505,fastCase10_5506,fastCase10_5507,fastCase10_5508,fastCase10_5509,fastCase10_5510,fastCase10_5511,fastCase10_5512,fastCase10_5513,fastCase10_5514,fastCase10_5515,fastCase10_5516,fastCase10_5517,fastCase10_5518,fastCase10_5519,fastCase10_5520,fastCase10_5521,fastCase10_5522,fastCase10_5523,fastCase10_5524,fastCase10_5525,fastCase10_5526,fastCase10_5527,fastCase10_5528,fastCase10_5529,fastCase10_5530,fastCase10_5531,fastCase10_5532,fastCase10_5533,fastCase10_5534,fastCase10_5535,fastCase10_5536,fastCase10_5537,fastCase10_5538,fastCase10_5539,fastCase10_5540,fastCase10_5541,fastCase10_5542,fastCase10_5543,fastCase10_5544,fastCase10_5545,fastCase10_5546,fastCase10_5547,fastCase10_5548,fastCase10_5549,fastCase10_5550,fastCase10_5551,fastCase10_5552,fastCase10_5553,fastCase10_5554,fastCase10_5555,fastCase10_5556,fastCase10_5557,fastCase10_5558,fastCase10_5559,fastCase10_5560,fastCase10_5561,fastCase10_5562,fastCase10_5563,fastCase10_5564,fastCase10_5565,fastCase10_5566,fastCase10_5567,fastCase10_5568,fastCase10_5569,fastCase10_5570,fastCase10_5571,fastCase10_5572,fastCase10_5573,fastCase10_5574,fastCase10_5575,fastCase10_5576,fastCase10_5577,fastCase10_5578,fastCase10_5579,fastCase10_5580,fastCase10_5581,fastCase10_5582,fastCase10_5583,fastCase10_5584,fastCase10_5585,fastCase10_5586,fastCase10_5587,fastCase10_5588,fastCase10_5589,fastCase10_5590,fastCase10_5591,fastCase10_5592,fastCase10_5593,fastCase10_5594,fastCase10_5595,fastCase10_5596,fastCase10_5597,fastCase10_5598,fastCase10_5599,fastCase10_5600,fastCase10_5601,fastCase10_5602,fastCase10_5603,fastCase10_5604,fastCase10_5605,fastCase10_5606,fastCase10_5607,fastCase10_5608,fastCase10_5609,fastCase10_5610,fastCase10_5611,fastCase10_5612,fastCase10_5613,fastCase10_5614,fastCase10_5615,fastCase10_5616,fastCase10_5617,fastCase10_5618,fastCase10_5619,fastCase10_5620,fastCase10_5621,fastCase10_5622,fastCase10_5623,fastCase10_5624,fastCase10_5625,fastCase10_5626,fastCase10_5627,fastCase10_5628,fastCase10_5629,fastCase10_5630,fastCase10_5631,fastCase10_5632,fastCase10_5633,fastCase10_5634,fastCase10_5635,fastCase10_5636,fastCase10_5637,fastCase10_5638,fastCase10_5639,fastCase10_5640,fastCase10_5641,fastCase10_5642,fastCase10_5643,fastCase10_5644,fastCase10_5645,fastCase10_5646,fastCase10_5647,fastCase10_5648,fastCase10_5649,fastCase10_5650,fastCase10_5651,fastCase10_5652,fastCase10_5653,fastCase10_5654,fastCase10_5655,fastCase10_5656,fastCase10_5657,fastCase10_5658,fastCase10_5659,fastCase10_5660,fastCase10_5661,fastCase10_5662,fastCase10_5663,fastCase10_5664,fastCase10_5665,fastCase10_5666,fastCase10_5667,fastCase10_5668,fastCase10_5669,fastCase10_5670,fastCase10_5671,fastCase10_5672,fastCase10_5673,fastCase10_5674,fastCase10_5675,fastCase10_5676,fastCase10_5677,fastCase10_5678,fastCase10_5679,fastCase10_5680,fastCase10_5681,fastCase10_5682,fastCase10_5683,fastCase10_5684,fastCase10_5685,fastCase10_5686,fastCase10_5687,fastCase10_5688,fastCase10_5689,fastCase10_5690,fastCase10_5691,fastCase10_5692,fastCase10_5693,fastCase10_5694,fastCase10_5695,fastCase10_5696,fastCase10_5697,fastCase10_5698,fastCase10_5699,fastCase10_5700,fastCase10_5701,fastCase10_5702,fastCase10_5703,fastCase10_5704,fastCase10_5705,fastCase10_5706,fastCase10_5707,fastCase10_5708,fastCase10_5709,fastCase10_5710,fastCase10_5711,fastCase10_5712,fastCase10_5713,fastCase10_5714,fastCase10_5715,fastCase10_5716,fastCase10_5717,fastCase10_5718,fastCase10_5719,fastCase10_5720,fastCase10_5721,fastCase10_5722,fastCase10_5723,fastCase10_5724,fastCase10_5725,fastCase10_5726,fastCase10_5727,fastCase10_5728,fastCase10_5729,fastCase10_5730,fastCase10_5731,fastCase10_5732,fastCase10_5733,fastCase10_5734,fastCase10_5735,fastCase10_5736,fastCase10_5737,fastCase10_5738,fastCase10_5739,fastCase10_5740,fastCase10_5741,fastCase10_5742,fastCase10_5743,fastCase10_5744,fastCase10_5745,fastCase10_5746,fastCase10_5747,fastCase10_5748,fastCase10_5749,fastCase10_5750,fastCase10_5751,fastCase10_5752,fastCase10_5753,fastCase10_5754,fastCase10_5755,fastCase10_5756,fastCase10_5757,fastCase10_5758,fastCase10_5759,fastCase10_5760,fastCase10_5761,fastCase10_5762,fastCase10_5763,fastCase10_5764,fastCase10_5765,fastCase10_5766,fastCase10_5767,fastCase10_5768,fastCase10_5769,fastCase10_5770,fastCase10_5771,fastCase10_5772,fastCase10_5773,fastCase10_5774,fastCase10_5775,fastCase10_5776,fastCase10_5777,fastCase10_5778,fastCase10_5779,fastCase10_5780,fastCase10_5781,fastCase10_5782,fastCase10_5783,fastCase10_5784,fastCase10_5785,fastCase10_5786,fastCase10_5787,fastCase10_5788,fastCase10_5789,fastCase10_5790,fastCase10_5791,fastCase10_5792,fastCase10_5793,fastCase10_5794,fastCase10_5795,fastCase10_5796,fastCase10_5797,fastCase10_5798,fastCase10_5799,fastCase10_5800,fastCase10_5801,fastCase10_5802,fastCase10_5803,fastCase10_5804,fastCase10_5805,fastCase10_5806,fastCase10_5807,fastCase10_5808,fastCase10_5809,fastCase10_5810,fastCase10_5811,fastCase10_5812,fastCase10_5813,fastCase10_5814,fastCase10_5815,fastCase10_5816,fastCase10_5817,fastCase10_5818,fastCase10_5819,fastCase10_5820,fastCase10_5821,fastCase10_5822,fastCase10_5823,fastCase10_5824,fastCase10_5825,fastCase10_5826,fastCase10_5827,fastCase10_5828,fastCase10_5829,fastCase10_5830,fastCase10_5831,fastCase10_5832,fastCase10_5833,fastCase10_5834,fastCase10_5835,fastCase10_5836,fastCase10_5837,fastCase10_5838,fastCase10_5839,fastCase10_5840,fastCase10_5841,fastCase10_5842,fastCase10_5843,fastCase10_5844,fastCase10_5845,fastCase10_5846,fastCase10_5847,fastCase10_5848,fastCase10_5849,fastCase10_5850,fastCase10_5851,fastCase10_5852,fastCase10_5853,fastCase10_5854,fastCase10_5855,fastCase10_5856,fastCase10_5857,fastCase10_5858,fastCase10_5859,fastCase10_5860,fastCase10_5861,fastCase10_5862,fastCase10_5863,fastCase10_5864,fastCase10_5865,fastCase10_5866,fastCase10_5867,fastCase10_5868,fastCase10_5869,fastCase10_5870,fastCase10_5871,fastCase10_5872,fastCase10_5873,fastCase10_5874,fastCase10_5875,fastCase10_5876,fastCase10_5877,fastCase10_5878,fastCase10_5879,fastCase10_5880,fastCase10_5881,fastCase10_5882,fastCase10_5883,fastCase10_5884,fastCase10_5885,fastCase10_5886,fastCase10_5887,fastCase10_5888,fastCase10_5889,fastCase10_5890,fastCase10_5891,fastCase10_5892,fastCase10_5893,fastCase10_5894,fastCase10_5895,fastCase10_5896,fastCase10_5897,fastCase10_5898,fastCase10_5899,fastCase10_5900,fastCase10_5901,fastCase10_5902,fastCase10_5903,fastCase10_5904,fastCase10_5905,fastCase10_5906,fastCase10_5907,fastCase10_5908,fastCase10_5909,fastCase10_5910,fastCase10_5911,fastCase10_5912,fastCase10_5913,fastCase10_5914,fastCase10_5915,fastCase10_5916,fastCase10_5917,fastCase10_5918,fastCase10_5919,fastCase10_5920,fastCase10_5921,fastCase10_5922,fastCase10_5923,fastCase10_5924,fastCase10_5925,fastCase10_5926,fastCase10_5927,fastCase10_5928,fastCase10_5929,fastCase10_5930,fastCase10_5931,fastCase10_5932,fastCase10_5933,fastCase10_5934,fastCase10_5935,fastCase10_5936,fastCase10_5937,fastCase10_5938,fastCase10_5939,fastCase10_5940,fastCase10_5941,fastCase10_5942,fastCase10_5943,fastCase10_5944,fastCase10_5945,fastCase10_5946,fastCase10_5947,fastCase10_5948,fastCase10_5949,fastCase10_5950,fastCase10_5951,fastCase10_5952,fastCase10_5953,fastCase10_5954,fastCase10_5955,fastCase10_5956,fastCase10_5957,fastCase10_5958,fastCase10_5959,fastCase10_5960,fastCase10_5961,fastCase10_5962,fastCase10_5963,fastCase10_5964,fastCase10_5965,fastCase10_5966,fastCase10_5967,fastCase10_5968,fastCase10_5969,fastCase10_5970,fastCase10_5971,fastCase10_5972,fastCase10_5973,fastCase10_5974,fastCase10_5975,fastCase10_5976,fastCase10_5977,fastCase10_5978,fastCase10_5979,fastCase10_5980,fastCase10_5981,fastCase10_5982,fastCase10_5983,fastCase10_5984,fastCase10_5985,fastCase10_5986,fastCase10_5987,fastCase10_5988,fastCase10_5989,fastCase10_5990,fastCase10_5991,fastCase10_5992,fastCase10_5993,fastCase10_5994,fastCase10_5995,fastCase10_5996,fastCase10_5997,fastCase10_5998,fastCase10_5999⟩
#print axioms aggregate_F10_005
end KernelCatalog
