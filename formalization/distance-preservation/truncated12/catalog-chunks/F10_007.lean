import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_7000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7000 : checkCertificateFast 10 7000 fastCert10_7000=true := by decide +kernel
def fastCert10_7001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7001 : checkCertificateFast 10 7001 fastCert10_7001=true := by decide +kernel
def fastCert10_7002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7002 : checkCertificateFast 10 7002 fastCert10_7002=true := by decide +kernel
def fastCert10_7003 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7003 : checkCertificateFast 10 7003 fastCert10_7003=true := by decide +kernel
def fastCert10_7004 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7004 : checkCertificateFast 10 7004 fastCert10_7004=true := by decide +kernel
def fastCert10_7005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7005 : checkCertificateFast 10 7005 fastCert10_7005=true := by decide +kernel
def fastCert10_7006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7006 : checkCertificateFast 10 7006 fastCert10_7006=true := by decide +kernel
def fastCert10_7007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7007 : checkCertificateFast 10 7007 fastCert10_7007=true := by decide +kernel
def fastCert10_7008 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7008 : checkCertificateFast 10 7008 fastCert10_7008=true := by decide +kernel
def fastCert10_7009 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7009 : checkCertificateFast 10 7009 fastCert10_7009=true := by decide +kernel
def fastCert10_7010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7010 : checkCertificateFast 10 7010 fastCert10_7010=true := by decide +kernel
def fastCert10_7011 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7011 : checkCertificateFast 10 7011 fastCert10_7011=true := by decide +kernel
def fastCert10_7012 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7012 : checkCertificateFast 10 7012 fastCert10_7012=true := by decide +kernel
def fastCert10_7013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7013 : checkCertificateFast 10 7013 fastCert10_7013=true := by decide +kernel
def fastCert10_7014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7014 : checkCertificateFast 10 7014 fastCert10_7014=true := by decide +kernel
def fastCert10_7015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7015 : checkCertificateFast 10 7015 fastCert10_7015=true := by decide +kernel
def fastCert10_7016 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7016 : checkCertificateFast 10 7016 fastCert10_7016=true := by decide +kernel
def fastCert10_7017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7017 : checkCertificateFast 10 7017 fastCert10_7017=true := by decide +kernel
def fastCert10_7018 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7018 : checkCertificateFast 10 7018 fastCert10_7018=true := by decide +kernel
def fastCert10_7019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7019 : checkCertificateFast 10 7019 fastCert10_7019=true := by decide +kernel
def fastCert10_7020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7020 : checkCertificateFast 10 7020 fastCert10_7020=true := by decide +kernel
def fastCert10_7021 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7021 : checkCertificateFast 10 7021 fastCert10_7021=true := by decide +kernel
def fastCert10_7022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7022 : checkCertificateFast 10 7022 fastCert10_7022=true := by decide +kernel
def fastCert10_7023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7023 : checkCertificateFast 10 7023 fastCert10_7023=true := by decide +kernel
def fastCert10_7024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7024 : checkCertificateFast 10 7024 fastCert10_7024=true := by decide +kernel
def fastCert10_7025 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-4) else 0⟩
theorem fastCase10_7025 : checkCertificateFast 10 7025 fastCert10_7025=true := by decide +kernel
def fastCert10_7026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7026 : checkCertificateFast 10 7026 fastCert10_7026=true := by decide +kernel
def fastCert10_7027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7027 : checkCertificateFast 10 7027 fastCert10_7027=true := by decide +kernel
def fastCert10_7028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7028 : checkCertificateFast 10 7028 fastCert10_7028=true := by decide +kernel
def fastCert10_7029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7029 : checkCertificateFast 10 7029 fastCert10_7029=true := by decide +kernel
def fastCert10_7030 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7030 : checkCertificateFast 10 7030 fastCert10_7030=true := by decide +kernel
def fastCert10_7031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7031 : checkCertificateFast 10 7031 fastCert10_7031=true := by decide +kernel
def fastCert10_7032 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7032 : checkCertificateFast 10 7032 fastCert10_7032=true := by decide +kernel
def fastCert10_7033 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7033 : checkCertificateFast 10 7033 fastCert10_7033=true := by decide +kernel
def fastCert10_7034 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7034 : checkCertificateFast 10 7034 fastCert10_7034=true := by decide +kernel
def fastCert10_7035 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7035 : checkCertificateFast 10 7035 fastCert10_7035=true := by decide +kernel
def fastCert10_7036 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7036 : checkCertificateFast 10 7036 fastCert10_7036=true := by decide +kernel
def fastCert10_7037 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7037 : checkCertificateFast 10 7037 fastCert10_7037=true := by decide +kernel
def fastCert10_7038 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7038 : checkCertificateFast 10 7038 fastCert10_7038=true := by decide +kernel
def fastCert10_7039 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7039 : checkCertificateFast 10 7039 fastCert10_7039=true := by decide +kernel
def fastCert10_7040 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7040 : checkCertificateFast 10 7040 fastCert10_7040=true := by decide +kernel
def fastCert10_7041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7041 : checkCertificateFast 10 7041 fastCert10_7041=true := by decide +kernel
def fastCert10_7042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7042 : checkCertificateFast 10 7042 fastCert10_7042=true := by decide +kernel
def fastCert10_7043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7043 : checkCertificateFast 10 7043 fastCert10_7043=true := by decide +kernel
def fastCert10_7044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7044 : checkCertificateFast 10 7044 fastCert10_7044=true := by decide +kernel
def fastCert10_7045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7045 : checkCertificateFast 10 7045 fastCert10_7045=true := by decide +kernel
def fastCert10_7046 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7046 : checkCertificateFast 10 7046 fastCert10_7046=true := by decide +kernel
def fastCert10_7047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7047 : checkCertificateFast 10 7047 fastCert10_7047=true := by decide +kernel
def fastCert10_7048 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7048 : checkCertificateFast 10 7048 fastCert10_7048=true := by decide +kernel
def fastCert10_7049 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7049 : checkCertificateFast 10 7049 fastCert10_7049=true := by decide +kernel
def fastCert10_7050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7050 : checkCertificateFast 10 7050 fastCert10_7050=true := by decide +kernel
def fastCert10_7051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7051 : checkCertificateFast 10 7051 fastCert10_7051=true := by decide +kernel
def fastCert10_7052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7052 : checkCertificateFast 10 7052 fastCert10_7052=true := by decide +kernel
def fastCert10_7053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7053 : checkCertificateFast 10 7053 fastCert10_7053=true := by decide +kernel
def fastCert10_7054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7054 : checkCertificateFast 10 7054 fastCert10_7054=true := by decide +kernel
def fastCert10_7055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7055 : checkCertificateFast 10 7055 fastCert10_7055=true := by decide +kernel
def fastCert10_7056 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7056 : checkCertificateFast 10 7056 fastCert10_7056=true := by decide +kernel
def fastCert10_7057 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7057 : checkCertificateFast 10 7057 fastCert10_7057=true := by decide +kernel
def fastCert10_7058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7058 : checkCertificateFast 10 7058 fastCert10_7058=true := by decide +kernel
def fastCert10_7059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7059 : checkCertificateFast 10 7059 fastCert10_7059=true := by decide +kernel
def fastCert10_7060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7060 : checkCertificateFast 10 7060 fastCert10_7060=true := by decide +kernel
def fastCert10_7061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7061 : checkCertificateFast 10 7061 fastCert10_7061=true := by decide +kernel
def fastCert10_7062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7062 : checkCertificateFast 10 7062 fastCert10_7062=true := by decide +kernel
def fastCert10_7063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7063 : checkCertificateFast 10 7063 fastCert10_7063=true := by decide +kernel
def fastCert10_7064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7064 : checkCertificateFast 10 7064 fastCert10_7064=true := by decide +kernel
def fastCert10_7065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7065 : checkCertificateFast 10 7065 fastCert10_7065=true := by decide +kernel
def fastCert10_7066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7066 : checkCertificateFast 10 7066 fastCert10_7066=true := by decide +kernel
def fastCert10_7067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7067 : checkCertificateFast 10 7067 fastCert10_7067=true := by decide +kernel
def fastCert10_7068 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7068 : checkCertificateFast 10 7068 fastCert10_7068=true := by decide +kernel
def fastCert10_7069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7069 : checkCertificateFast 10 7069 fastCert10_7069=true := by decide +kernel
def fastCert10_7070 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7070 : checkCertificateFast 10 7070 fastCert10_7070=true := by decide +kernel
def fastCert10_7071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7071 : checkCertificateFast 10 7071 fastCert10_7071=true := by decide +kernel
def fastCert10_7072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7072 : checkCertificateFast 10 7072 fastCert10_7072=true := by decide +kernel
def fastCert10_7073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7073 : checkCertificateFast 10 7073 fastCert10_7073=true := by decide +kernel
def fastCert10_7074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7074 : checkCertificateFast 10 7074 fastCert10_7074=true := by decide +kernel
def fastCert10_7075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7075 : checkCertificateFast 10 7075 fastCert10_7075=true := by decide +kernel
def fastCert10_7076 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7076 : checkCertificateFast 10 7076 fastCert10_7076=true := by decide +kernel
def fastCert10_7077 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7077 : checkCertificateFast 10 7077 fastCert10_7077=true := by decide +kernel
def fastCert10_7078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7078 : checkCertificateFast 10 7078 fastCert10_7078=true := by decide +kernel
def fastCert10_7079 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7079 : checkCertificateFast 10 7079 fastCert10_7079=true := by decide +kernel
def fastCert10_7080 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7080 : checkCertificateFast 10 7080 fastCert10_7080=true := by decide +kernel
def fastCert10_7081 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7081 : checkCertificateFast 10 7081 fastCert10_7081=true := by decide +kernel
def fastCert10_7082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7082 : checkCertificateFast 10 7082 fastCert10_7082=true := by decide +kernel
def fastCert10_7083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7083 : checkCertificateFast 10 7083 fastCert10_7083=true := by decide +kernel
def fastCert10_7084 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7084 : checkCertificateFast 10 7084 fastCert10_7084=true := by decide +kernel
def fastCert10_7085 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7085 : checkCertificateFast 10 7085 fastCert10_7085=true := by decide +kernel
def fastCert10_7086 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7086 : checkCertificateFast 10 7086 fastCert10_7086=true := by decide +kernel
def fastCert10_7087 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7087 : checkCertificateFast 10 7087 fastCert10_7087=true := by decide +kernel
def fastCert10_7088 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7088 : checkCertificateFast 10 7088 fastCert10_7088=true := by decide +kernel
def fastCert10_7089 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7089 : checkCertificateFast 10 7089 fastCert10_7089=true := by decide +kernel
def fastCert10_7090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7090 : checkCertificateFast 10 7090 fastCert10_7090=true := by decide +kernel
def fastCert10_7091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7091 : checkCertificateFast 10 7091 fastCert10_7091=true := by decide +kernel
def fastCert10_7092 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7092 : checkCertificateFast 10 7092 fastCert10_7092=true := by decide +kernel
def fastCert10_7093 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7093 : checkCertificateFast 10 7093 fastCert10_7093=true := by decide +kernel
def fastCert10_7094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7094 : checkCertificateFast 10 7094 fastCert10_7094=true := by decide +kernel
def fastCert10_7095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7095 : checkCertificateFast 10 7095 fastCert10_7095=true := by decide +kernel
def fastCert10_7096 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7096 : checkCertificateFast 10 7096 fastCert10_7096=true := by decide +kernel
def fastCert10_7097 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7097 : checkCertificateFast 10 7097 fastCert10_7097=true := by decide +kernel
def fastCert10_7098 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7098 : checkCertificateFast 10 7098 fastCert10_7098=true := by decide +kernel
def fastCert10_7099 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7099 : checkCertificateFast 10 7099 fastCert10_7099=true := by decide +kernel
def fastCert10_7100 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7100 : checkCertificateFast 10 7100 fastCert10_7100=true := by decide +kernel
def fastCert10_7101 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7101 : checkCertificateFast 10 7101 fastCert10_7101=true := by decide +kernel
def fastCert10_7102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7102 : checkCertificateFast 10 7102 fastCert10_7102=true := by decide +kernel
def fastCert10_7103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7103 : checkCertificateFast 10 7103 fastCert10_7103=true := by decide +kernel
def fastCert10_7104 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7104 : checkCertificateFast 10 7104 fastCert10_7104=true := by decide +kernel
def fastCert10_7105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7105 : checkCertificateFast 10 7105 fastCert10_7105=true := by decide +kernel
def fastCert10_7106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7106 : checkCertificateFast 10 7106 fastCert10_7106=true := by decide +kernel
def fastCert10_7107 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7107 : checkCertificateFast 10 7107 fastCert10_7107=true := by decide +kernel
def fastCert10_7108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7108 : checkCertificateFast 10 7108 fastCert10_7108=true := by decide +kernel
def fastCert10_7109 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7109 : checkCertificateFast 10 7109 fastCert10_7109=true := by decide +kernel
def fastCert10_7110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7110 : checkCertificateFast 10 7110 fastCert10_7110=true := by decide +kernel
def fastCert10_7111 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7111 : checkCertificateFast 10 7111 fastCert10_7111=true := by decide +kernel
def fastCert10_7112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7112 : checkCertificateFast 10 7112 fastCert10_7112=true := by decide +kernel
def fastCert10_7113 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7113 : checkCertificateFast 10 7113 fastCert10_7113=true := by decide +kernel
def fastCert10_7114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7114 : checkCertificateFast 10 7114 fastCert10_7114=true := by decide +kernel
def fastCert10_7115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7115 : checkCertificateFast 10 7115 fastCert10_7115=true := by decide +kernel
def fastCert10_7116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7116 : checkCertificateFast 10 7116 fastCert10_7116=true := by decide +kernel
def fastCert10_7117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7117 : checkCertificateFast 10 7117 fastCert10_7117=true := by decide +kernel
def fastCert10_7118 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7118 : checkCertificateFast 10 7118 fastCert10_7118=true := by decide +kernel
def fastCert10_7119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7119 : checkCertificateFast 10 7119 fastCert10_7119=true := by decide +kernel
def fastCert10_7120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7120 : checkCertificateFast 10 7120 fastCert10_7120=true := by decide +kernel
def fastCert10_7121 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7121 : checkCertificateFast 10 7121 fastCert10_7121=true := by decide +kernel
def fastCert10_7122 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7122 : checkCertificateFast 10 7122 fastCert10_7122=true := by decide +kernel
def fastCert10_7123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7123 : checkCertificateFast 10 7123 fastCert10_7123=true := by decide +kernel
def fastCert10_7124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7124 : checkCertificateFast 10 7124 fastCert10_7124=true := by decide +kernel
def fastCert10_7125 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7125 : checkCertificateFast 10 7125 fastCert10_7125=true := by decide +kernel
def fastCert10_7126 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7126 : checkCertificateFast 10 7126 fastCert10_7126=true := by decide +kernel
def fastCert10_7127 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7127 : checkCertificateFast 10 7127 fastCert10_7127=true := by decide +kernel
def fastCert10_7128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7128 : checkCertificateFast 10 7128 fastCert10_7128=true := by decide +kernel
def fastCert10_7129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7129 : checkCertificateFast 10 7129 fastCert10_7129=true := by decide +kernel
def fastCert10_7130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7130 : checkCertificateFast 10 7130 fastCert10_7130=true := by decide +kernel
def fastCert10_7131 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7131 : checkCertificateFast 10 7131 fastCert10_7131=true := by decide +kernel
def fastCert10_7132 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7132 : checkCertificateFast 10 7132 fastCert10_7132=true := by decide +kernel
def fastCert10_7133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7133 : checkCertificateFast 10 7133 fastCert10_7133=true := by decide +kernel
def fastCert10_7134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7134 : checkCertificateFast 10 7134 fastCert10_7134=true := by decide +kernel
def fastCert10_7135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7135 : checkCertificateFast 10 7135 fastCert10_7135=true := by decide +kernel
def fastCert10_7136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7136 : checkCertificateFast 10 7136 fastCert10_7136=true := by decide +kernel
def fastCert10_7137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7137 : checkCertificateFast 10 7137 fastCert10_7137=true := by decide +kernel
def fastCert10_7138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7138 : checkCertificateFast 10 7138 fastCert10_7138=true := by decide +kernel
def fastCert10_7139 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7139 : checkCertificateFast 10 7139 fastCert10_7139=true := by decide +kernel
def fastCert10_7140 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7140 : checkCertificateFast 10 7140 fastCert10_7140=true := by decide +kernel
def fastCert10_7141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7141 : checkCertificateFast 10 7141 fastCert10_7141=true := by decide +kernel
def fastCert10_7142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7142 : checkCertificateFast 10 7142 fastCert10_7142=true := by decide +kernel
def fastCert10_7143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7143 : checkCertificateFast 10 7143 fastCert10_7143=true := by decide +kernel
def fastCert10_7144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7144 : checkCertificateFast 10 7144 fastCert10_7144=true := by decide +kernel
def fastCert10_7145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7145 : checkCertificateFast 10 7145 fastCert10_7145=true := by decide +kernel
def fastCert10_7146 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7146 : checkCertificateFast 10 7146 fastCert10_7146=true := by decide +kernel
def fastCert10_7147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7147 : checkCertificateFast 10 7147 fastCert10_7147=true := by decide +kernel
def fastCert10_7148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7148 : checkCertificateFast 10 7148 fastCert10_7148=true := by decide +kernel
def fastCert10_7149 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7149 : checkCertificateFast 10 7149 fastCert10_7149=true := by decide +kernel
def fastCert10_7150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7150 : checkCertificateFast 10 7150 fastCert10_7150=true := by decide +kernel
def fastCert10_7151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7151 : checkCertificateFast 10 7151 fastCert10_7151=true := by decide +kernel
def fastCert10_7152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7152 : checkCertificateFast 10 7152 fastCert10_7152=true := by decide +kernel
def fastCert10_7153 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7153 : checkCertificateFast 10 7153 fastCert10_7153=true := by decide +kernel
def fastCert10_7154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7154 : checkCertificateFast 10 7154 fastCert10_7154=true := by decide +kernel
def fastCert10_7155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7155 : checkCertificateFast 10 7155 fastCert10_7155=true := by decide +kernel
def fastCert10_7156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7156 : checkCertificateFast 10 7156 fastCert10_7156=true := by decide +kernel
def fastCert10_7157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7157 : checkCertificateFast 10 7157 fastCert10_7157=true := by decide +kernel
def fastCert10_7158 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7158 : checkCertificateFast 10 7158 fastCert10_7158=true := by decide +kernel
def fastCert10_7159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7159 : checkCertificateFast 10 7159 fastCert10_7159=true := by decide +kernel
def fastCert10_7160 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7160 : checkCertificateFast 10 7160 fastCert10_7160=true := by decide +kernel
def fastCert10_7161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7161 : checkCertificateFast 10 7161 fastCert10_7161=true := by decide +kernel
def fastCert10_7162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7162 : checkCertificateFast 10 7162 fastCert10_7162=true := by decide +kernel
def fastCert10_7163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7163 : checkCertificateFast 10 7163 fastCert10_7163=true := by decide +kernel
def fastCert10_7164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7164 : checkCertificateFast 10 7164 fastCert10_7164=true := by decide +kernel
def fastCert10_7165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7165 : checkCertificateFast 10 7165 fastCert10_7165=true := by decide +kernel
def fastCert10_7166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7166 : checkCertificateFast 10 7166 fastCert10_7166=true := by decide +kernel
def fastCert10_7167 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7167 : checkCertificateFast 10 7167 fastCert10_7167=true := by decide +kernel
def fastCert10_7168 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7168 : checkCertificateFast 10 7168 fastCert10_7168=true := by decide +kernel
def fastCert10_7169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7169 : checkCertificateFast 10 7169 fastCert10_7169=true := by decide +kernel
def fastCert10_7170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7170 : checkCertificateFast 10 7170 fastCert10_7170=true := by decide +kernel
def fastCert10_7171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7171 : checkCertificateFast 10 7171 fastCert10_7171=true := by decide +kernel
def fastCert10_7172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7172 : checkCertificateFast 10 7172 fastCert10_7172=true := by decide +kernel
def fastCert10_7173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7173 : checkCertificateFast 10 7173 fastCert10_7173=true := by decide +kernel
def fastCert10_7174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7174 : checkCertificateFast 10 7174 fastCert10_7174=true := by decide +kernel
def fastCert10_7175 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7175 : checkCertificateFast 10 7175 fastCert10_7175=true := by decide +kernel
def fastCert10_7176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7176 : checkCertificateFast 10 7176 fastCert10_7176=true := by decide +kernel
def fastCert10_7177 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7177 : checkCertificateFast 10 7177 fastCert10_7177=true := by decide +kernel
def fastCert10_7178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7178 : checkCertificateFast 10 7178 fastCert10_7178=true := by decide +kernel
def fastCert10_7179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7179 : checkCertificateFast 10 7179 fastCert10_7179=true := by decide +kernel
def fastCert10_7180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7180 : checkCertificateFast 10 7180 fastCert10_7180=true := by decide +kernel
def fastCert10_7181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7181 : checkCertificateFast 10 7181 fastCert10_7181=true := by decide +kernel
def fastCert10_7182 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7182 : checkCertificateFast 10 7182 fastCert10_7182=true := by decide +kernel
def fastCert10_7183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7183 : checkCertificateFast 10 7183 fastCert10_7183=true := by decide +kernel
def fastCert10_7184 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7184 : checkCertificateFast 10 7184 fastCert10_7184=true := by decide +kernel
def fastCert10_7185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7185 : checkCertificateFast 10 7185 fastCert10_7185=true := by decide +kernel
def fastCert10_7186 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7186 : checkCertificateFast 10 7186 fastCert10_7186=true := by decide +kernel
def fastCert10_7187 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7187 : checkCertificateFast 10 7187 fastCert10_7187=true := by decide +kernel
def fastCert10_7188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7188 : checkCertificateFast 10 7188 fastCert10_7188=true := by decide +kernel
def fastCert10_7189 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7189 : checkCertificateFast 10 7189 fastCert10_7189=true := by decide +kernel
def fastCert10_7190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7190 : checkCertificateFast 10 7190 fastCert10_7190=true := by decide +kernel
def fastCert10_7191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7191 : checkCertificateFast 10 7191 fastCert10_7191=true := by decide +kernel
def fastCert10_7192 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7192 : checkCertificateFast 10 7192 fastCert10_7192=true := by decide +kernel
def fastCert10_7193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7193 : checkCertificateFast 10 7193 fastCert10_7193=true := by decide +kernel
def fastCert10_7194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7194 : checkCertificateFast 10 7194 fastCert10_7194=true := by decide +kernel
def fastCert10_7195 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7195 : checkCertificateFast 10 7195 fastCert10_7195=true := by decide +kernel
def fastCert10_7196 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7196 : checkCertificateFast 10 7196 fastCert10_7196=true := by decide +kernel
def fastCert10_7197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7197 : checkCertificateFast 10 7197 fastCert10_7197=true := by decide +kernel
def fastCert10_7198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7198 : checkCertificateFast 10 7198 fastCert10_7198=true := by decide +kernel
def fastCert10_7199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7199 : checkCertificateFast 10 7199 fastCert10_7199=true := by decide +kernel
def fastCert10_7200 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7200 : checkCertificateFast 10 7200 fastCert10_7200=true := by decide +kernel
def fastCert10_7201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7201 : checkCertificateFast 10 7201 fastCert10_7201=true := by decide +kernel
def fastCert10_7202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7202 : checkCertificateFast 10 7202 fastCert10_7202=true := by decide +kernel
def fastCert10_7203 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7203 : checkCertificateFast 10 7203 fastCert10_7203=true := by decide +kernel
def fastCert10_7204 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7204 : checkCertificateFast 10 7204 fastCert10_7204=true := by decide +kernel
def fastCert10_7205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7205 : checkCertificateFast 10 7205 fastCert10_7205=true := by decide +kernel
def fastCert10_7206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7206 : checkCertificateFast 10 7206 fastCert10_7206=true := by decide +kernel
def fastCert10_7207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7207 : checkCertificateFast 10 7207 fastCert10_7207=true := by decide +kernel
def fastCert10_7208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7208 : checkCertificateFast 10 7208 fastCert10_7208=true := by decide +kernel
def fastCert10_7209 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7209 : checkCertificateFast 10 7209 fastCert10_7209=true := by decide +kernel
def fastCert10_7210 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7210 : checkCertificateFast 10 7210 fastCert10_7210=true := by decide +kernel
def fastCert10_7211 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7211 : checkCertificateFast 10 7211 fastCert10_7211=true := by decide +kernel
def fastCert10_7212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7212 : checkCertificateFast 10 7212 fastCert10_7212=true := by decide +kernel
def fastCert10_7213 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7213 : checkCertificateFast 10 7213 fastCert10_7213=true := by decide +kernel
def fastCert10_7214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7214 : checkCertificateFast 10 7214 fastCert10_7214=true := by decide +kernel
def fastCert10_7215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7215 : checkCertificateFast 10 7215 fastCert10_7215=true := by decide +kernel
def fastCert10_7216 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7216 : checkCertificateFast 10 7216 fastCert10_7216=true := by decide +kernel
def fastCert10_7217 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7217 : checkCertificateFast 10 7217 fastCert10_7217=true := by decide +kernel
def fastCert10_7218 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7218 : checkCertificateFast 10 7218 fastCert10_7218=true := by decide +kernel
def fastCert10_7219 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7219 : checkCertificateFast 10 7219 fastCert10_7219=true := by decide +kernel
def fastCert10_7220 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7220 : checkCertificateFast 10 7220 fastCert10_7220=true := by decide +kernel
def fastCert10_7221 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7221 : checkCertificateFast 10 7221 fastCert10_7221=true := by decide +kernel
def fastCert10_7222 : Certificate := ⟨8,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7222 : checkCertificateFast 10 7222 fastCert10_7222=true := by decide +kernel
def fastCert10_7223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7223 : checkCertificateFast 10 7223 fastCert10_7223=true := by decide +kernel
def fastCert10_7224 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7224 : checkCertificateFast 10 7224 fastCert10_7224=true := by decide +kernel
def fastCert10_7225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7225 : checkCertificateFast 10 7225 fastCert10_7225=true := by decide +kernel
def fastCert10_7226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7226 : checkCertificateFast 10 7226 fastCert10_7226=true := by decide +kernel
def fastCert10_7227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7227 : checkCertificateFast 10 7227 fastCert10_7227=true := by decide +kernel
def fastCert10_7228 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7228 : checkCertificateFast 10 7228 fastCert10_7228=true := by decide +kernel
def fastCert10_7229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7229 : checkCertificateFast 10 7229 fastCert10_7229=true := by decide +kernel
def fastCert10_7230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7230 : checkCertificateFast 10 7230 fastCert10_7230=true := by decide +kernel
def fastCert10_7231 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7231 : checkCertificateFast 10 7231 fastCert10_7231=true := by decide +kernel
def fastCert10_7232 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7232 : checkCertificateFast 10 7232 fastCert10_7232=true := by decide +kernel
def fastCert10_7233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7233 : checkCertificateFast 10 7233 fastCert10_7233=true := by decide +kernel
def fastCert10_7234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7234 : checkCertificateFast 10 7234 fastCert10_7234=true := by decide +kernel
def fastCert10_7235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7235 : checkCertificateFast 10 7235 fastCert10_7235=true := by decide +kernel
def fastCert10_7236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7236 : checkCertificateFast 10 7236 fastCert10_7236=true := by decide +kernel
def fastCert10_7237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7237 : checkCertificateFast 10 7237 fastCert10_7237=true := by decide +kernel
def fastCert10_7238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7238 : checkCertificateFast 10 7238 fastCert10_7238=true := by decide +kernel
def fastCert10_7239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7239 : checkCertificateFast 10 7239 fastCert10_7239=true := by decide +kernel
def fastCert10_7240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7240 : checkCertificateFast 10 7240 fastCert10_7240=true := by decide +kernel
def fastCert10_7241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7241 : checkCertificateFast 10 7241 fastCert10_7241=true := by decide +kernel
def fastCert10_7242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7242 : checkCertificateFast 10 7242 fastCert10_7242=true := by decide +kernel
def fastCert10_7243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7243 : checkCertificateFast 10 7243 fastCert10_7243=true := by decide +kernel
def fastCert10_7244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7244 : checkCertificateFast 10 7244 fastCert10_7244=true := by decide +kernel
def fastCert10_7245 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7245 : checkCertificateFast 10 7245 fastCert10_7245=true := by decide +kernel
def fastCert10_7246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7246 : checkCertificateFast 10 7246 fastCert10_7246=true := by decide +kernel
def fastCert10_7247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7247 : checkCertificateFast 10 7247 fastCert10_7247=true := by decide +kernel
def fastCert10_7248 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7248 : checkCertificateFast 10 7248 fastCert10_7248=true := by decide +kernel
def fastCert10_7249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7249 : checkCertificateFast 10 7249 fastCert10_7249=true := by decide +kernel
def fastCert10_7250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7250 : checkCertificateFast 10 7250 fastCert10_7250=true := by decide +kernel
def fastCert10_7251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7251 : checkCertificateFast 10 7251 fastCert10_7251=true := by decide +kernel
def fastCert10_7252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7252 : checkCertificateFast 10 7252 fastCert10_7252=true := by decide +kernel
def fastCert10_7253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7253 : checkCertificateFast 10 7253 fastCert10_7253=true := by decide +kernel
def fastCert10_7254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7254 : checkCertificateFast 10 7254 fastCert10_7254=true := by decide +kernel
def fastCert10_7255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7255 : checkCertificateFast 10 7255 fastCert10_7255=true := by decide +kernel
def fastCert10_7256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7256 : checkCertificateFast 10 7256 fastCert10_7256=true := by decide +kernel
def fastCert10_7257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7257 : checkCertificateFast 10 7257 fastCert10_7257=true := by decide +kernel
def fastCert10_7258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7258 : checkCertificateFast 10 7258 fastCert10_7258=true := by decide +kernel
def fastCert10_7259 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7259 : checkCertificateFast 10 7259 fastCert10_7259=true := by decide +kernel
def fastCert10_7260 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7260 : checkCertificateFast 10 7260 fastCert10_7260=true := by decide +kernel
def fastCert10_7261 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7261 : checkCertificateFast 10 7261 fastCert10_7261=true := by decide +kernel
def fastCert10_7262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7262 : checkCertificateFast 10 7262 fastCert10_7262=true := by decide +kernel
def fastCert10_7263 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7263 : checkCertificateFast 10 7263 fastCert10_7263=true := by decide +kernel
def fastCert10_7264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7264 : checkCertificateFast 10 7264 fastCert10_7264=true := by decide +kernel
def fastCert10_7265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7265 : checkCertificateFast 10 7265 fastCert10_7265=true := by decide +kernel
def fastCert10_7266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7266 : checkCertificateFast 10 7266 fastCert10_7266=true := by decide +kernel
def fastCert10_7267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7267 : checkCertificateFast 10 7267 fastCert10_7267=true := by decide +kernel
def fastCert10_7268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7268 : checkCertificateFast 10 7268 fastCert10_7268=true := by decide +kernel
def fastCert10_7269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7269 : checkCertificateFast 10 7269 fastCert10_7269=true := by decide +kernel
def fastCert10_7270 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7270 : checkCertificateFast 10 7270 fastCert10_7270=true := by decide +kernel
def fastCert10_7271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7271 : checkCertificateFast 10 7271 fastCert10_7271=true := by decide +kernel
def fastCert10_7272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7272 : checkCertificateFast 10 7272 fastCert10_7272=true := by decide +kernel
def fastCert10_7273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7273 : checkCertificateFast 10 7273 fastCert10_7273=true := by decide +kernel
def fastCert10_7274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7274 : checkCertificateFast 10 7274 fastCert10_7274=true := by decide +kernel
def fastCert10_7275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7275 : checkCertificateFast 10 7275 fastCert10_7275=true := by decide +kernel
def fastCert10_7276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7276 : checkCertificateFast 10 7276 fastCert10_7276=true := by decide +kernel
def fastCert10_7277 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7277 : checkCertificateFast 10 7277 fastCert10_7277=true := by decide +kernel
def fastCert10_7278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7278 : checkCertificateFast 10 7278 fastCert10_7278=true := by decide +kernel
def fastCert10_7279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7279 : checkCertificateFast 10 7279 fastCert10_7279=true := by decide +kernel
def fastCert10_7280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7280 : checkCertificateFast 10 7280 fastCert10_7280=true := by decide +kernel
def fastCert10_7281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7281 : checkCertificateFast 10 7281 fastCert10_7281=true := by decide +kernel
def fastCert10_7282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7282 : checkCertificateFast 10 7282 fastCert10_7282=true := by decide +kernel
def fastCert10_7283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7283 : checkCertificateFast 10 7283 fastCert10_7283=true := by decide +kernel
def fastCert10_7284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7284 : checkCertificateFast 10 7284 fastCert10_7284=true := by decide +kernel
def fastCert10_7285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7285 : checkCertificateFast 10 7285 fastCert10_7285=true := by decide +kernel
def fastCert10_7286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7286 : checkCertificateFast 10 7286 fastCert10_7286=true := by decide +kernel
def fastCert10_7287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7287 : checkCertificateFast 10 7287 fastCert10_7287=true := by decide +kernel
def fastCert10_7288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7288 : checkCertificateFast 10 7288 fastCert10_7288=true := by decide +kernel
def fastCert10_7289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7289 : checkCertificateFast 10 7289 fastCert10_7289=true := by decide +kernel
def fastCert10_7290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7290 : checkCertificateFast 10 7290 fastCert10_7290=true := by decide +kernel
def fastCert10_7291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7291 : checkCertificateFast 10 7291 fastCert10_7291=true := by decide +kernel
def fastCert10_7292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7292 : checkCertificateFast 10 7292 fastCert10_7292=true := by decide +kernel
def fastCert10_7293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7293 : checkCertificateFast 10 7293 fastCert10_7293=true := by decide +kernel
def fastCert10_7294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7294 : checkCertificateFast 10 7294 fastCert10_7294=true := by decide +kernel
def fastCert10_7295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7295 : checkCertificateFast 10 7295 fastCert10_7295=true := by decide +kernel
def fastCert10_7296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7296 : checkCertificateFast 10 7296 fastCert10_7296=true := by decide +kernel
def fastCert10_7297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7297 : checkCertificateFast 10 7297 fastCert10_7297=true := by decide +kernel
def fastCert10_7298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7298 : checkCertificateFast 10 7298 fastCert10_7298=true := by decide +kernel
def fastCert10_7299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7299 : checkCertificateFast 10 7299 fastCert10_7299=true := by decide +kernel
def fastCert10_7300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7300 : checkCertificateFast 10 7300 fastCert10_7300=true := by decide +kernel
def fastCert10_7301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7301 : checkCertificateFast 10 7301 fastCert10_7301=true := by decide +kernel
def fastCert10_7302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7302 : checkCertificateFast 10 7302 fastCert10_7302=true := by decide +kernel
def fastCert10_7303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7303 : checkCertificateFast 10 7303 fastCert10_7303=true := by decide +kernel
def fastCert10_7304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7304 : checkCertificateFast 10 7304 fastCert10_7304=true := by decide +kernel
def fastCert10_7305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7305 : checkCertificateFast 10 7305 fastCert10_7305=true := by decide +kernel
def fastCert10_7306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7306 : checkCertificateFast 10 7306 fastCert10_7306=true := by decide +kernel
def fastCert10_7307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7307 : checkCertificateFast 10 7307 fastCert10_7307=true := by decide +kernel
def fastCert10_7308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7308 : checkCertificateFast 10 7308 fastCert10_7308=true := by decide +kernel
def fastCert10_7309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7309 : checkCertificateFast 10 7309 fastCert10_7309=true := by decide +kernel
def fastCert10_7310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7310 : checkCertificateFast 10 7310 fastCert10_7310=true := by decide +kernel
def fastCert10_7311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7311 : checkCertificateFast 10 7311 fastCert10_7311=true := by decide +kernel
def fastCert10_7312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7312 : checkCertificateFast 10 7312 fastCert10_7312=true := by decide +kernel
def fastCert10_7313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7313 : checkCertificateFast 10 7313 fastCert10_7313=true := by decide +kernel
def fastCert10_7314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7314 : checkCertificateFast 10 7314 fastCert10_7314=true := by decide +kernel
def fastCert10_7315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7315 : checkCertificateFast 10 7315 fastCert10_7315=true := by decide +kernel
def fastCert10_7316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7316 : checkCertificateFast 10 7316 fastCert10_7316=true := by decide +kernel
def fastCert10_7317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7317 : checkCertificateFast 10 7317 fastCert10_7317=true := by decide +kernel
def fastCert10_7318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7318 : checkCertificateFast 10 7318 fastCert10_7318=true := by decide +kernel
def fastCert10_7319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7319 : checkCertificateFast 10 7319 fastCert10_7319=true := by decide +kernel
def fastCert10_7320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7320 : checkCertificateFast 10 7320 fastCert10_7320=true := by decide +kernel
def fastCert10_7321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7321 : checkCertificateFast 10 7321 fastCert10_7321=true := by decide +kernel
def fastCert10_7322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7322 : checkCertificateFast 10 7322 fastCert10_7322=true := by decide +kernel
def fastCert10_7323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7323 : checkCertificateFast 10 7323 fastCert10_7323=true := by decide +kernel
def fastCert10_7324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7324 : checkCertificateFast 10 7324 fastCert10_7324=true := by decide +kernel
def fastCert10_7325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7325 : checkCertificateFast 10 7325 fastCert10_7325=true := by decide +kernel
def fastCert10_7326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7326 : checkCertificateFast 10 7326 fastCert10_7326=true := by decide +kernel
def fastCert10_7327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7327 : checkCertificateFast 10 7327 fastCert10_7327=true := by decide +kernel
def fastCert10_7328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7328 : checkCertificateFast 10 7328 fastCert10_7328=true := by decide +kernel
def fastCert10_7329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7329 : checkCertificateFast 10 7329 fastCert10_7329=true := by decide +kernel
def fastCert10_7330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7330 : checkCertificateFast 10 7330 fastCert10_7330=true := by decide +kernel
def fastCert10_7331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7331 : checkCertificateFast 10 7331 fastCert10_7331=true := by decide +kernel
def fastCert10_7332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7332 : checkCertificateFast 10 7332 fastCert10_7332=true := by decide +kernel
def fastCert10_7333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7333 : checkCertificateFast 10 7333 fastCert10_7333=true := by decide +kernel
def fastCert10_7334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7334 : checkCertificateFast 10 7334 fastCert10_7334=true := by decide +kernel
def fastCert10_7335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7335 : checkCertificateFast 10 7335 fastCert10_7335=true := by decide +kernel
def fastCert10_7336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_7336 : checkCertificateFast 10 7336 fastCert10_7336=true := by decide +kernel
def fastCert10_7337 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7337 : checkCertificateFast 10 7337 fastCert10_7337=true := by decide +kernel
def fastCert10_7338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7338 : checkCertificateFast 10 7338 fastCert10_7338=true := by decide +kernel
def fastCert10_7339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7339 : checkCertificateFast 10 7339 fastCert10_7339=true := by decide +kernel
def fastCert10_7340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7340 : checkCertificateFast 10 7340 fastCert10_7340=true := by decide +kernel
def fastCert10_7341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7341 : checkCertificateFast 10 7341 fastCert10_7341=true := by decide +kernel
def fastCert10_7342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7342 : checkCertificateFast 10 7342 fastCert10_7342=true := by decide +kernel
def fastCert10_7343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7343 : checkCertificateFast 10 7343 fastCert10_7343=true := by decide +kernel
def fastCert10_7344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7344 : checkCertificateFast 10 7344 fastCert10_7344=true := by decide +kernel
def fastCert10_7345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7345 : checkCertificateFast 10 7345 fastCert10_7345=true := by decide +kernel
def fastCert10_7346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7346 : checkCertificateFast 10 7346 fastCert10_7346=true := by decide +kernel
def fastCert10_7347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7347 : checkCertificateFast 10 7347 fastCert10_7347=true := by decide +kernel
def fastCert10_7348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7348 : checkCertificateFast 10 7348 fastCert10_7348=true := by decide +kernel
def fastCert10_7349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7349 : checkCertificateFast 10 7349 fastCert10_7349=true := by decide +kernel
def fastCert10_7350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7350 : checkCertificateFast 10 7350 fastCert10_7350=true := by decide +kernel
def fastCert10_7351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7351 : checkCertificateFast 10 7351 fastCert10_7351=true := by decide +kernel
def fastCert10_7352 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7352 : checkCertificateFast 10 7352 fastCert10_7352=true := by decide +kernel
def fastCert10_7353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7353 : checkCertificateFast 10 7353 fastCert10_7353=true := by decide +kernel
def fastCert10_7354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7354 : checkCertificateFast 10 7354 fastCert10_7354=true := by decide +kernel
def fastCert10_7355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7355 : checkCertificateFast 10 7355 fastCert10_7355=true := by decide +kernel
def fastCert10_7356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7356 : checkCertificateFast 10 7356 fastCert10_7356=true := by decide +kernel
def fastCert10_7357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7357 : checkCertificateFast 10 7357 fastCert10_7357=true := by decide +kernel
def fastCert10_7358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7358 : checkCertificateFast 10 7358 fastCert10_7358=true := by decide +kernel
def fastCert10_7359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7359 : checkCertificateFast 10 7359 fastCert10_7359=true := by decide +kernel
def fastCert10_7360 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7360 : checkCertificateFast 10 7360 fastCert10_7360=true := by decide +kernel
def fastCert10_7361 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7361 : checkCertificateFast 10 7361 fastCert10_7361=true := by decide +kernel
def fastCert10_7362 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7362 : checkCertificateFast 10 7362 fastCert10_7362=true := by decide +kernel
def fastCert10_7363 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7363 : checkCertificateFast 10 7363 fastCert10_7363=true := by decide +kernel
def fastCert10_7364 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7364 : checkCertificateFast 10 7364 fastCert10_7364=true := by decide +kernel
def fastCert10_7365 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7365 : checkCertificateFast 10 7365 fastCert10_7365=true := by decide +kernel
def fastCert10_7366 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7366 : checkCertificateFast 10 7366 fastCert10_7366=true := by decide +kernel
def fastCert10_7367 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7367 : checkCertificateFast 10 7367 fastCert10_7367=true := by decide +kernel
def fastCert10_7368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7368 : checkCertificateFast 10 7368 fastCert10_7368=true := by decide +kernel
def fastCert10_7369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7369 : checkCertificateFast 10 7369 fastCert10_7369=true := by decide +kernel
def fastCert10_7370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7370 : checkCertificateFast 10 7370 fastCert10_7370=true := by decide +kernel
def fastCert10_7371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7371 : checkCertificateFast 10 7371 fastCert10_7371=true := by decide +kernel
def fastCert10_7372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7372 : checkCertificateFast 10 7372 fastCert10_7372=true := by decide +kernel
def fastCert10_7373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7373 : checkCertificateFast 10 7373 fastCert10_7373=true := by decide +kernel
def fastCert10_7374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7374 : checkCertificateFast 10 7374 fastCert10_7374=true := by decide +kernel
def fastCert10_7375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7375 : checkCertificateFast 10 7375 fastCert10_7375=true := by decide +kernel
def fastCert10_7376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7376 : checkCertificateFast 10 7376 fastCert10_7376=true := by decide +kernel
def fastCert10_7377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7377 : checkCertificateFast 10 7377 fastCert10_7377=true := by decide +kernel
def fastCert10_7378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7378 : checkCertificateFast 10 7378 fastCert10_7378=true := by decide +kernel
def fastCert10_7379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7379 : checkCertificateFast 10 7379 fastCert10_7379=true := by decide +kernel
def fastCert10_7380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7380 : checkCertificateFast 10 7380 fastCert10_7380=true := by decide +kernel
def fastCert10_7381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7381 : checkCertificateFast 10 7381 fastCert10_7381=true := by decide +kernel
def fastCert10_7382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7382 : checkCertificateFast 10 7382 fastCert10_7382=true := by decide +kernel
def fastCert10_7383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7383 : checkCertificateFast 10 7383 fastCert10_7383=true := by decide +kernel
def fastCert10_7384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7384 : checkCertificateFast 10 7384 fastCert10_7384=true := by decide +kernel
def fastCert10_7385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7385 : checkCertificateFast 10 7385 fastCert10_7385=true := by decide +kernel
def fastCert10_7386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7386 : checkCertificateFast 10 7386 fastCert10_7386=true := by decide +kernel
def fastCert10_7387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7387 : checkCertificateFast 10 7387 fastCert10_7387=true := by decide +kernel
def fastCert10_7388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7388 : checkCertificateFast 10 7388 fastCert10_7388=true := by decide +kernel
def fastCert10_7389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7389 : checkCertificateFast 10 7389 fastCert10_7389=true := by decide +kernel
def fastCert10_7390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7390 : checkCertificateFast 10 7390 fastCert10_7390=true := by decide +kernel
def fastCert10_7391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7391 : checkCertificateFast 10 7391 fastCert10_7391=true := by decide +kernel
def fastCert10_7392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7392 : checkCertificateFast 10 7392 fastCert10_7392=true := by decide +kernel
def fastCert10_7393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7393 : checkCertificateFast 10 7393 fastCert10_7393=true := by decide +kernel
def fastCert10_7394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7394 : checkCertificateFast 10 7394 fastCert10_7394=true := by decide +kernel
def fastCert10_7395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_7395 : checkCertificateFast 10 7395 fastCert10_7395=true := by decide +kernel
def fastCert10_7396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7396 : checkCertificateFast 10 7396 fastCert10_7396=true := by decide +kernel
def fastCert10_7397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7397 : checkCertificateFast 10 7397 fastCert10_7397=true := by decide +kernel
def fastCert10_7398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7398 : checkCertificateFast 10 7398 fastCert10_7398=true := by decide +kernel
def fastCert10_7399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7399 : checkCertificateFast 10 7399 fastCert10_7399=true := by decide +kernel
def fastCert10_7400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-3) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (3) else 0⟩
theorem fastCase10_7400 : checkCertificateFast 10 7400 fastCert10_7400=true := by decide +kernel
def fastCert10_7401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7401 : checkCertificateFast 10 7401 fastCert10_7401=true := by decide +kernel
def fastCert10_7402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7402 : checkCertificateFast 10 7402 fastCert10_7402=true := by decide +kernel
def fastCert10_7403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (5) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (5) else if t=0 ∧ i=9 then (-5) else if t=0 ∧ i=10 then (6) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-5) else if t=0 ∧ i=16 then (5) else 0⟩
theorem fastCase10_7403 : checkCertificateFast 10 7403 fastCert10_7403=true := by decide +kernel
def fastCert10_7404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7404 : checkCertificateFast 10 7404 fastCert10_7404=true := by decide +kernel
def fastCert10_7405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7405 : checkCertificateFast 10 7405 fastCert10_7405=true := by decide +kernel
def fastCert10_7406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7406 : checkCertificateFast 10 7406 fastCert10_7406=true := by decide +kernel
def fastCert10_7407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7407 : checkCertificateFast 10 7407 fastCert10_7407=true := by decide +kernel
def fastCert10_7408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7408 : checkCertificateFast 10 7408 fastCert10_7408=true := by decide +kernel
def fastCert10_7409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_7409 : checkCertificateFast 10 7409 fastCert10_7409=true := by decide +kernel
def fastCert10_7410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7410 : checkCertificateFast 10 7410 fastCert10_7410=true := by decide +kernel
def fastCert10_7411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7411 : checkCertificateFast 10 7411 fastCert10_7411=true := by decide +kernel
def fastCert10_7412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7412 : checkCertificateFast 10 7412 fastCert10_7412=true := by decide +kernel
def fastCert10_7413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7413 : checkCertificateFast 10 7413 fastCert10_7413=true := by decide +kernel
def fastCert10_7414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7414 : checkCertificateFast 10 7414 fastCert10_7414=true := by decide +kernel
def fastCert10_7415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7415 : checkCertificateFast 10 7415 fastCert10_7415=true := by decide +kernel
def fastCert10_7416 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7416 : checkCertificateFast 10 7416 fastCert10_7416=true := by decide +kernel
def fastCert10_7417 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7417 : checkCertificateFast 10 7417 fastCert10_7417=true := by decide +kernel
def fastCert10_7418 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7418 : checkCertificateFast 10 7418 fastCert10_7418=true := by decide +kernel
def fastCert10_7419 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7419 : checkCertificateFast 10 7419 fastCert10_7419=true := by decide +kernel
def fastCert10_7420 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7420 : checkCertificateFast 10 7420 fastCert10_7420=true := by decide +kernel
def fastCert10_7421 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7421 : checkCertificateFast 10 7421 fastCert10_7421=true := by decide +kernel
def fastCert10_7422 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7422 : checkCertificateFast 10 7422 fastCert10_7422=true := by decide +kernel
def fastCert10_7423 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7423 : checkCertificateFast 10 7423 fastCert10_7423=true := by decide +kernel
def fastCert10_7424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7424 : checkCertificateFast 10 7424 fastCert10_7424=true := by decide +kernel
def fastCert10_7425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7425 : checkCertificateFast 10 7425 fastCert10_7425=true := by decide +kernel
def fastCert10_7426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7426 : checkCertificateFast 10 7426 fastCert10_7426=true := by decide +kernel
def fastCert10_7427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7427 : checkCertificateFast 10 7427 fastCert10_7427=true := by decide +kernel
def fastCert10_7428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7428 : checkCertificateFast 10 7428 fastCert10_7428=true := by decide +kernel
def fastCert10_7429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7429 : checkCertificateFast 10 7429 fastCert10_7429=true := by decide +kernel
def fastCert10_7430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7430 : checkCertificateFast 10 7430 fastCert10_7430=true := by decide +kernel
def fastCert10_7431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7431 : checkCertificateFast 10 7431 fastCert10_7431=true := by decide +kernel
def fastCert10_7432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7432 : checkCertificateFast 10 7432 fastCert10_7432=true := by decide +kernel
def fastCert10_7433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7433 : checkCertificateFast 10 7433 fastCert10_7433=true := by decide +kernel
def fastCert10_7434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7434 : checkCertificateFast 10 7434 fastCert10_7434=true := by decide +kernel
def fastCert10_7435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7435 : checkCertificateFast 10 7435 fastCert10_7435=true := by decide +kernel
def fastCert10_7436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7436 : checkCertificateFast 10 7436 fastCert10_7436=true := by decide +kernel
def fastCert10_7437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7437 : checkCertificateFast 10 7437 fastCert10_7437=true := by decide +kernel
def fastCert10_7438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7438 : checkCertificateFast 10 7438 fastCert10_7438=true := by decide +kernel
def fastCert10_7439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7439 : checkCertificateFast 10 7439 fastCert10_7439=true := by decide +kernel
def fastCert10_7440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7440 : checkCertificateFast 10 7440 fastCert10_7440=true := by decide +kernel
def fastCert10_7441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7441 : checkCertificateFast 10 7441 fastCert10_7441=true := by decide +kernel
def fastCert10_7442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7442 : checkCertificateFast 10 7442 fastCert10_7442=true := by decide +kernel
def fastCert10_7443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7443 : checkCertificateFast 10 7443 fastCert10_7443=true := by decide +kernel
def fastCert10_7444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7444 : checkCertificateFast 10 7444 fastCert10_7444=true := by decide +kernel
def fastCert10_7445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7445 : checkCertificateFast 10 7445 fastCert10_7445=true := by decide +kernel
def fastCert10_7446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7446 : checkCertificateFast 10 7446 fastCert10_7446=true := by decide +kernel
def fastCert10_7447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7447 : checkCertificateFast 10 7447 fastCert10_7447=true := by decide +kernel
def fastCert10_7448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7448 : checkCertificateFast 10 7448 fastCert10_7448=true := by decide +kernel
def fastCert10_7449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7449 : checkCertificateFast 10 7449 fastCert10_7449=true := by decide +kernel
def fastCert10_7450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7450 : checkCertificateFast 10 7450 fastCert10_7450=true := by decide +kernel
def fastCert10_7451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7451 : checkCertificateFast 10 7451 fastCert10_7451=true := by decide +kernel
def fastCert10_7452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7452 : checkCertificateFast 10 7452 fastCert10_7452=true := by decide +kernel
def fastCert10_7453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7453 : checkCertificateFast 10 7453 fastCert10_7453=true := by decide +kernel
def fastCert10_7454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7454 : checkCertificateFast 10 7454 fastCert10_7454=true := by decide +kernel
def fastCert10_7455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7455 : checkCertificateFast 10 7455 fastCert10_7455=true := by decide +kernel
def fastCert10_7456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7456 : checkCertificateFast 10 7456 fastCert10_7456=true := by decide +kernel
def fastCert10_7457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7457 : checkCertificateFast 10 7457 fastCert10_7457=true := by decide +kernel
def fastCert10_7458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7458 : checkCertificateFast 10 7458 fastCert10_7458=true := by decide +kernel
def fastCert10_7459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_7459 : checkCertificateFast 10 7459 fastCert10_7459=true := by decide +kernel
def fastCert10_7460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7460 : checkCertificateFast 10 7460 fastCert10_7460=true := by decide +kernel
def fastCert10_7461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7461 : checkCertificateFast 10 7461 fastCert10_7461=true := by decide +kernel
def fastCert10_7462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7462 : checkCertificateFast 10 7462 fastCert10_7462=true := by decide +kernel
def fastCert10_7463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7463 : checkCertificateFast 10 7463 fastCert10_7463=true := by decide +kernel
def fastCert10_7464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7464 : checkCertificateFast 10 7464 fastCert10_7464=true := by decide +kernel
def fastCert10_7465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7465 : checkCertificateFast 10 7465 fastCert10_7465=true := by decide +kernel
def fastCert10_7466 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7466 : checkCertificateFast 10 7466 fastCert10_7466=true := by decide +kernel
def fastCert10_7467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7467 : checkCertificateFast 10 7467 fastCert10_7467=true := by decide +kernel
def fastCert10_7468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7468 : checkCertificateFast 10 7468 fastCert10_7468=true := by decide +kernel
def fastCert10_7469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7469 : checkCertificateFast 10 7469 fastCert10_7469=true := by decide +kernel
def fastCert10_7470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7470 : checkCertificateFast 10 7470 fastCert10_7470=true := by decide +kernel
def fastCert10_7471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7471 : checkCertificateFast 10 7471 fastCert10_7471=true := by decide +kernel
def fastCert10_7472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7472 : checkCertificateFast 10 7472 fastCert10_7472=true := by decide +kernel
def fastCert10_7473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_7473 : checkCertificateFast 10 7473 fastCert10_7473=true := by decide +kernel
def fastCert10_7474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7474 : checkCertificateFast 10 7474 fastCert10_7474=true := by decide +kernel
def fastCert10_7475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_7475 : checkCertificateFast 10 7475 fastCert10_7475=true := by decide +kernel
def fastCert10_7476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7476 : checkCertificateFast 10 7476 fastCert10_7476=true := by decide +kernel
def fastCert10_7477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7477 : checkCertificateFast 10 7477 fastCert10_7477=true := by decide +kernel
def fastCert10_7478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7478 : checkCertificateFast 10 7478 fastCert10_7478=true := by decide +kernel
def fastCert10_7479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7479 : checkCertificateFast 10 7479 fastCert10_7479=true := by decide +kernel
def fastCert10_7480 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7480 : checkCertificateFast 10 7480 fastCert10_7480=true := by decide +kernel
def fastCert10_7481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7481 : checkCertificateFast 10 7481 fastCert10_7481=true := by decide +kernel
def fastCert10_7482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_7482 : checkCertificateFast 10 7482 fastCert10_7482=true := by decide +kernel
def fastCert10_7483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7483 : checkCertificateFast 10 7483 fastCert10_7483=true := by decide +kernel
def fastCert10_7484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7484 : checkCertificateFast 10 7484 fastCert10_7484=true := by decide +kernel
def fastCert10_7485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7485 : checkCertificateFast 10 7485 fastCert10_7485=true := by decide +kernel
def fastCert10_7486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7486 : checkCertificateFast 10 7486 fastCert10_7486=true := by decide +kernel
def fastCert10_7487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7487 : checkCertificateFast 10 7487 fastCert10_7487=true := by decide +kernel
def fastCert10_7488 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7488 : checkCertificateFast 10 7488 fastCert10_7488=true := by decide +kernel
def fastCert10_7489 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7489 : checkCertificateFast 10 7489 fastCert10_7489=true := by decide +kernel
def fastCert10_7490 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7490 : checkCertificateFast 10 7490 fastCert10_7490=true := by decide +kernel
def fastCert10_7491 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7491 : checkCertificateFast 10 7491 fastCert10_7491=true := by decide +kernel
def fastCert10_7492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7492 : checkCertificateFast 10 7492 fastCert10_7492=true := by decide +kernel
def fastCert10_7493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7493 : checkCertificateFast 10 7493 fastCert10_7493=true := by decide +kernel
def fastCert10_7494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7494 : checkCertificateFast 10 7494 fastCert10_7494=true := by decide +kernel
def fastCert10_7495 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7495 : checkCertificateFast 10 7495 fastCert10_7495=true := by decide +kernel
def fastCert10_7496 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7496 : checkCertificateFast 10 7496 fastCert10_7496=true := by decide +kernel
def fastCert10_7497 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7497 : checkCertificateFast 10 7497 fastCert10_7497=true := by decide +kernel
def fastCert10_7498 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7498 : checkCertificateFast 10 7498 fastCert10_7498=true := by decide +kernel
def fastCert10_7499 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7499 : checkCertificateFast 10 7499 fastCert10_7499=true := by decide +kernel
def fastCert10_7500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7500 : checkCertificateFast 10 7500 fastCert10_7500=true := by decide +kernel
def fastCert10_7501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7501 : checkCertificateFast 10 7501 fastCert10_7501=true := by decide +kernel
def fastCert10_7502 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7502 : checkCertificateFast 10 7502 fastCert10_7502=true := by decide +kernel
def fastCert10_7503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (5) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_7503 : checkCertificateFast 10 7503 fastCert10_7503=true := by decide +kernel
def fastCert10_7504 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7504 : checkCertificateFast 10 7504 fastCert10_7504=true := by decide +kernel
def fastCert10_7505 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7505 : checkCertificateFast 10 7505 fastCert10_7505=true := by decide +kernel
def fastCert10_7506 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7506 : checkCertificateFast 10 7506 fastCert10_7506=true := by decide +kernel
def fastCert10_7507 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7507 : checkCertificateFast 10 7507 fastCert10_7507=true := by decide +kernel
def fastCert10_7508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7508 : checkCertificateFast 10 7508 fastCert10_7508=true := by decide +kernel
def fastCert10_7509 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7509 : checkCertificateFast 10 7509 fastCert10_7509=true := by decide +kernel
def fastCert10_7510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7510 : checkCertificateFast 10 7510 fastCert10_7510=true := by decide +kernel
def fastCert10_7511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_7511 : checkCertificateFast 10 7511 fastCert10_7511=true := by decide +kernel
def fastCert10_7512 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7512 : checkCertificateFast 10 7512 fastCert10_7512=true := by decide +kernel
def fastCert10_7513 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7513 : checkCertificateFast 10 7513 fastCert10_7513=true := by decide +kernel
def fastCert10_7514 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7514 : checkCertificateFast 10 7514 fastCert10_7514=true := by decide +kernel
def fastCert10_7515 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7515 : checkCertificateFast 10 7515 fastCert10_7515=true := by decide +kernel
def fastCert10_7516 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7516 : checkCertificateFast 10 7516 fastCert10_7516=true := by decide +kernel
def fastCert10_7517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7517 : checkCertificateFast 10 7517 fastCert10_7517=true := by decide +kernel
def fastCert10_7518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7518 : checkCertificateFast 10 7518 fastCert10_7518=true := by decide +kernel
def fastCert10_7519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7519 : checkCertificateFast 10 7519 fastCert10_7519=true := by decide +kernel
def fastCert10_7520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7520 : checkCertificateFast 10 7520 fastCert10_7520=true := by decide +kernel
def fastCert10_7521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7521 : checkCertificateFast 10 7521 fastCert10_7521=true := by decide +kernel
def fastCert10_7522 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7522 : checkCertificateFast 10 7522 fastCert10_7522=true := by decide +kernel
def fastCert10_7523 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7523 : checkCertificateFast 10 7523 fastCert10_7523=true := by decide +kernel
def fastCert10_7524 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7524 : checkCertificateFast 10 7524 fastCert10_7524=true := by decide +kernel
def fastCert10_7525 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7525 : checkCertificateFast 10 7525 fastCert10_7525=true := by decide +kernel
def fastCert10_7526 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7526 : checkCertificateFast 10 7526 fastCert10_7526=true := by decide +kernel
def fastCert10_7527 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7527 : checkCertificateFast 10 7527 fastCert10_7527=true := by decide +kernel
def fastCert10_7528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_7528 : checkCertificateFast 10 7528 fastCert10_7528=true := by decide +kernel
def fastCert10_7529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7529 : checkCertificateFast 10 7529 fastCert10_7529=true := by decide +kernel
def fastCert10_7530 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7530 : checkCertificateFast 10 7530 fastCert10_7530=true := by decide +kernel
def fastCert10_7531 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7531 : checkCertificateFast 10 7531 fastCert10_7531=true := by decide +kernel
def fastCert10_7532 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7532 : checkCertificateFast 10 7532 fastCert10_7532=true := by decide +kernel
def fastCert10_7533 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7533 : checkCertificateFast 10 7533 fastCert10_7533=true := by decide +kernel
def fastCert10_7534 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7534 : checkCertificateFast 10 7534 fastCert10_7534=true := by decide +kernel
def fastCert10_7535 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7535 : checkCertificateFast 10 7535 fastCert10_7535=true := by decide +kernel
def fastCert10_7536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7536 : checkCertificateFast 10 7536 fastCert10_7536=true := by decide +kernel
def fastCert10_7537 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7537 : checkCertificateFast 10 7537 fastCert10_7537=true := by decide +kernel
def fastCert10_7538 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7538 : checkCertificateFast 10 7538 fastCert10_7538=true := by decide +kernel
def fastCert10_7539 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7539 : checkCertificateFast 10 7539 fastCert10_7539=true := by decide +kernel
def fastCert10_7540 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7540 : checkCertificateFast 10 7540 fastCert10_7540=true := by decide +kernel
def fastCert10_7541 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7541 : checkCertificateFast 10 7541 fastCert10_7541=true := by decide +kernel
def fastCert10_7542 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7542 : checkCertificateFast 10 7542 fastCert10_7542=true := by decide +kernel
def fastCert10_7543 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7543 : checkCertificateFast 10 7543 fastCert10_7543=true := by decide +kernel
def fastCert10_7544 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7544 : checkCertificateFast 10 7544 fastCert10_7544=true := by decide +kernel
def fastCert10_7545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7545 : checkCertificateFast 10 7545 fastCert10_7545=true := by decide +kernel
def fastCert10_7546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7546 : checkCertificateFast 10 7546 fastCert10_7546=true := by decide +kernel
def fastCert10_7547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7547 : checkCertificateFast 10 7547 fastCert10_7547=true := by decide +kernel
def fastCert10_7548 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7548 : checkCertificateFast 10 7548 fastCert10_7548=true := by decide +kernel
def fastCert10_7549 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7549 : checkCertificateFast 10 7549 fastCert10_7549=true := by decide +kernel
def fastCert10_7550 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7550 : checkCertificateFast 10 7550 fastCert10_7550=true := by decide +kernel
def fastCert10_7551 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7551 : checkCertificateFast 10 7551 fastCert10_7551=true := by decide +kernel
def fastCert10_7552 : Certificate := ⟨5,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=10 then (1) else if t=1 ∧ i=11 then (1) else if t=1 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7552 : checkCertificateFast 10 7552 fastCert10_7552=true := by decide +kernel
def fastCert10_7553 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7553 : checkCertificateFast 10 7553 fastCert10_7553=true := by decide +kernel
def fastCert10_7554 : Certificate := ⟨26,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7554 : checkCertificateFast 10 7554 fastCert10_7554=true := by decide +kernel
def fastCert10_7555 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7555 : checkCertificateFast 10 7555 fastCert10_7555=true := by decide +kernel
def fastCert10_7556 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7556 : checkCertificateFast 10 7556 fastCert10_7556=true := by decide +kernel
def fastCert10_7557 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7557 : checkCertificateFast 10 7557 fastCert10_7557=true := by decide +kernel
def fastCert10_7558 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7558 : checkCertificateFast 10 7558 fastCert10_7558=true := by decide +kernel
def fastCert10_7559 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7559 : checkCertificateFast 10 7559 fastCert10_7559=true := by decide +kernel
def fastCert10_7560 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7560 : checkCertificateFast 10 7560 fastCert10_7560=true := by decide +kernel
def fastCert10_7561 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7561 : checkCertificateFast 10 7561 fastCert10_7561=true := by decide +kernel
def fastCert10_7562 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7562 : checkCertificateFast 10 7562 fastCert10_7562=true := by decide +kernel
def fastCert10_7563 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7563 : checkCertificateFast 10 7563 fastCert10_7563=true := by decide +kernel
def fastCert10_7564 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7564 : checkCertificateFast 10 7564 fastCert10_7564=true := by decide +kernel
def fastCert10_7565 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7565 : checkCertificateFast 10 7565 fastCert10_7565=true := by decide +kernel
def fastCert10_7566 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7566 : checkCertificateFast 10 7566 fastCert10_7566=true := by decide +kernel
def fastCert10_7567 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7567 : checkCertificateFast 10 7567 fastCert10_7567=true := by decide +kernel
def fastCert10_7568 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7568 : checkCertificateFast 10 7568 fastCert10_7568=true := by decide +kernel
def fastCert10_7569 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7569 : checkCertificateFast 10 7569 fastCert10_7569=true := by decide +kernel
def fastCert10_7570 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7570 : checkCertificateFast 10 7570 fastCert10_7570=true := by decide +kernel
def fastCert10_7571 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7571 : checkCertificateFast 10 7571 fastCert10_7571=true := by decide +kernel
def fastCert10_7572 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7572 : checkCertificateFast 10 7572 fastCert10_7572=true := by decide +kernel
def fastCert10_7573 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7573 : checkCertificateFast 10 7573 fastCert10_7573=true := by decide +kernel
def fastCert10_7574 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7574 : checkCertificateFast 10 7574 fastCert10_7574=true := by decide +kernel
def fastCert10_7575 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7575 : checkCertificateFast 10 7575 fastCert10_7575=true := by decide +kernel
def fastCert10_7576 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7576 : checkCertificateFast 10 7576 fastCert10_7576=true := by decide +kernel
def fastCert10_7577 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7577 : checkCertificateFast 10 7577 fastCert10_7577=true := by decide +kernel
def fastCert10_7578 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7578 : checkCertificateFast 10 7578 fastCert10_7578=true := by decide +kernel
def fastCert10_7579 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7579 : checkCertificateFast 10 7579 fastCert10_7579=true := by decide +kernel
def fastCert10_7580 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7580 : checkCertificateFast 10 7580 fastCert10_7580=true := by decide +kernel
def fastCert10_7581 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7581 : checkCertificateFast 10 7581 fastCert10_7581=true := by decide +kernel
def fastCert10_7582 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7582 : checkCertificateFast 10 7582 fastCert10_7582=true := by decide +kernel
def fastCert10_7583 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7583 : checkCertificateFast 10 7583 fastCert10_7583=true := by decide +kernel
def fastCert10_7584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7584 : checkCertificateFast 10 7584 fastCert10_7584=true := by decide +kernel
def fastCert10_7585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7585 : checkCertificateFast 10 7585 fastCert10_7585=true := by decide +kernel
def fastCert10_7586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7586 : checkCertificateFast 10 7586 fastCert10_7586=true := by decide +kernel
def fastCert10_7587 : Certificate := ⟨8,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7587 : checkCertificateFast 10 7587 fastCert10_7587=true := by decide +kernel
def fastCert10_7588 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7588 : checkCertificateFast 10 7588 fastCert10_7588=true := by decide +kernel
def fastCert10_7589 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7589 : checkCertificateFast 10 7589 fastCert10_7589=true := by decide +kernel
def fastCert10_7590 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7590 : checkCertificateFast 10 7590 fastCert10_7590=true := by decide +kernel
def fastCert10_7591 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7591 : checkCertificateFast 10 7591 fastCert10_7591=true := by decide +kernel
def fastCert10_7592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_7592 : checkCertificateFast 10 7592 fastCert10_7592=true := by decide +kernel
def fastCert10_7593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7593 : checkCertificateFast 10 7593 fastCert10_7593=true := by decide +kernel
def fastCert10_7594 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7594 : checkCertificateFast 10 7594 fastCert10_7594=true := by decide +kernel
def fastCert10_7595 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7595 : checkCertificateFast 10 7595 fastCert10_7595=true := by decide +kernel
def fastCert10_7596 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7596 : checkCertificateFast 10 7596 fastCert10_7596=true := by decide +kernel
def fastCert10_7597 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7597 : checkCertificateFast 10 7597 fastCert10_7597=true := by decide +kernel
def fastCert10_7598 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7598 : checkCertificateFast 10 7598 fastCert10_7598=true := by decide +kernel
def fastCert10_7599 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7599 : checkCertificateFast 10 7599 fastCert10_7599=true := by decide +kernel
def fastCert10_7600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7600 : checkCertificateFast 10 7600 fastCert10_7600=true := by decide +kernel
def fastCert10_7601 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7601 : checkCertificateFast 10 7601 fastCert10_7601=true := by decide +kernel
def fastCert10_7602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7602 : checkCertificateFast 10 7602 fastCert10_7602=true := by decide +kernel
def fastCert10_7603 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7603 : checkCertificateFast 10 7603 fastCert10_7603=true := by decide +kernel
def fastCert10_7604 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7604 : checkCertificateFast 10 7604 fastCert10_7604=true := by decide +kernel
def fastCert10_7605 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7605 : checkCertificateFast 10 7605 fastCert10_7605=true := by decide +kernel
def fastCert10_7606 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7606 : checkCertificateFast 10 7606 fastCert10_7606=true := by decide +kernel
def fastCert10_7607 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7607 : checkCertificateFast 10 7607 fastCert10_7607=true := by decide +kernel
def fastCert10_7608 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7608 : checkCertificateFast 10 7608 fastCert10_7608=true := by decide +kernel
def fastCert10_7609 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7609 : checkCertificateFast 10 7609 fastCert10_7609=true := by decide +kernel
def fastCert10_7610 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7610 : checkCertificateFast 10 7610 fastCert10_7610=true := by decide +kernel
def fastCert10_7611 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7611 : checkCertificateFast 10 7611 fastCert10_7611=true := by decide +kernel
def fastCert10_7612 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7612 : checkCertificateFast 10 7612 fastCert10_7612=true := by decide +kernel
def fastCert10_7613 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7613 : checkCertificateFast 10 7613 fastCert10_7613=true := by decide +kernel
def fastCert10_7614 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7614 : checkCertificateFast 10 7614 fastCert10_7614=true := by decide +kernel
def fastCert10_7615 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7615 : checkCertificateFast 10 7615 fastCert10_7615=true := by decide +kernel
def fastCert10_7616 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7616 : checkCertificateFast 10 7616 fastCert10_7616=true := by decide +kernel
def fastCert10_7617 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7617 : checkCertificateFast 10 7617 fastCert10_7617=true := by decide +kernel
def fastCert10_7618 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7618 : checkCertificateFast 10 7618 fastCert10_7618=true := by decide +kernel
def fastCert10_7619 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7619 : checkCertificateFast 10 7619 fastCert10_7619=true := by decide +kernel
def fastCert10_7620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7620 : checkCertificateFast 10 7620 fastCert10_7620=true := by decide +kernel
def fastCert10_7621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7621 : checkCertificateFast 10 7621 fastCert10_7621=true := by decide +kernel
def fastCert10_7622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7622 : checkCertificateFast 10 7622 fastCert10_7622=true := by decide +kernel
def fastCert10_7623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7623 : checkCertificateFast 10 7623 fastCert10_7623=true := by decide +kernel
def fastCert10_7624 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (5) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_7624 : checkCertificateFast 10 7624 fastCert10_7624=true := by decide +kernel
def fastCert10_7625 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7625 : checkCertificateFast 10 7625 fastCert10_7625=true := by decide +kernel
def fastCert10_7626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7626 : checkCertificateFast 10 7626 fastCert10_7626=true := by decide +kernel
def fastCert10_7627 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7627 : checkCertificateFast 10 7627 fastCert10_7627=true := by decide +kernel
def fastCert10_7628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7628 : checkCertificateFast 10 7628 fastCert10_7628=true := by decide +kernel
def fastCert10_7629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7629 : checkCertificateFast 10 7629 fastCert10_7629=true := by decide +kernel
def fastCert10_7630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7630 : checkCertificateFast 10 7630 fastCert10_7630=true := by decide +kernel
def fastCert10_7631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7631 : checkCertificateFast 10 7631 fastCert10_7631=true := by decide +kernel
def fastCert10_7632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_7632 : checkCertificateFast 10 7632 fastCert10_7632=true := by decide +kernel
def fastCert10_7633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7633 : checkCertificateFast 10 7633 fastCert10_7633=true := by decide +kernel
def fastCert10_7634 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7634 : checkCertificateFast 10 7634 fastCert10_7634=true := by decide +kernel
def fastCert10_7635 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7635 : checkCertificateFast 10 7635 fastCert10_7635=true := by decide +kernel
def fastCert10_7636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7636 : checkCertificateFast 10 7636 fastCert10_7636=true := by decide +kernel
def fastCert10_7637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7637 : checkCertificateFast 10 7637 fastCert10_7637=true := by decide +kernel
def fastCert10_7638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7638 : checkCertificateFast 10 7638 fastCert10_7638=true := by decide +kernel
def fastCert10_7639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7639 : checkCertificateFast 10 7639 fastCert10_7639=true := by decide +kernel
def fastCert10_7640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7640 : checkCertificateFast 10 7640 fastCert10_7640=true := by decide +kernel
def fastCert10_7641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7641 : checkCertificateFast 10 7641 fastCert10_7641=true := by decide +kernel
def fastCert10_7642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7642 : checkCertificateFast 10 7642 fastCert10_7642=true := by decide +kernel
def fastCert10_7643 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7643 : checkCertificateFast 10 7643 fastCert10_7643=true := by decide +kernel
def fastCert10_7644 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7644 : checkCertificateFast 10 7644 fastCert10_7644=true := by decide +kernel
def fastCert10_7645 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7645 : checkCertificateFast 10 7645 fastCert10_7645=true := by decide +kernel
def fastCert10_7646 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7646 : checkCertificateFast 10 7646 fastCert10_7646=true := by decide +kernel
def fastCert10_7647 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7647 : checkCertificateFast 10 7647 fastCert10_7647=true := by decide +kernel
def fastCert10_7648 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7648 : checkCertificateFast 10 7648 fastCert10_7648=true := by decide +kernel
def fastCert10_7649 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7649 : checkCertificateFast 10 7649 fastCert10_7649=true := by decide +kernel
def fastCert10_7650 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7650 : checkCertificateFast 10 7650 fastCert10_7650=true := by decide +kernel
def fastCert10_7651 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7651 : checkCertificateFast 10 7651 fastCert10_7651=true := by decide +kernel
def fastCert10_7652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7652 : checkCertificateFast 10 7652 fastCert10_7652=true := by decide +kernel
def fastCert10_7653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7653 : checkCertificateFast 10 7653 fastCert10_7653=true := by decide +kernel
def fastCert10_7654 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7654 : checkCertificateFast 10 7654 fastCert10_7654=true := by decide +kernel
def fastCert10_7655 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7655 : checkCertificateFast 10 7655 fastCert10_7655=true := by decide +kernel
def fastCert10_7656 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7656 : checkCertificateFast 10 7656 fastCert10_7656=true := by decide +kernel
def fastCert10_7657 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7657 : checkCertificateFast 10 7657 fastCert10_7657=true := by decide +kernel
def fastCert10_7658 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7658 : checkCertificateFast 10 7658 fastCert10_7658=true := by decide +kernel
def fastCert10_7659 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7659 : checkCertificateFast 10 7659 fastCert10_7659=true := by decide +kernel
def fastCert10_7660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7660 : checkCertificateFast 10 7660 fastCert10_7660=true := by decide +kernel
def fastCert10_7661 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7661 : checkCertificateFast 10 7661 fastCert10_7661=true := by decide +kernel
def fastCert10_7662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7662 : checkCertificateFast 10 7662 fastCert10_7662=true := by decide +kernel
def fastCert10_7663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7663 : checkCertificateFast 10 7663 fastCert10_7663=true := by decide +kernel
def fastCert10_7664 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7664 : checkCertificateFast 10 7664 fastCert10_7664=true := by decide +kernel
def fastCert10_7665 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7665 : checkCertificateFast 10 7665 fastCert10_7665=true := by decide +kernel
def fastCert10_7666 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7666 : checkCertificateFast 10 7666 fastCert10_7666=true := by decide +kernel
def fastCert10_7667 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7667 : checkCertificateFast 10 7667 fastCert10_7667=true := by decide +kernel
def fastCert10_7668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7668 : checkCertificateFast 10 7668 fastCert10_7668=true := by decide +kernel
def fastCert10_7669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7669 : checkCertificateFast 10 7669 fastCert10_7669=true := by decide +kernel
def fastCert10_7670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7670 : checkCertificateFast 10 7670 fastCert10_7670=true := by decide +kernel
def fastCert10_7671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7671 : checkCertificateFast 10 7671 fastCert10_7671=true := by decide +kernel
def fastCert10_7672 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7672 : checkCertificateFast 10 7672 fastCert10_7672=true := by decide +kernel
def fastCert10_7673 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7673 : checkCertificateFast 10 7673 fastCert10_7673=true := by decide +kernel
def fastCert10_7674 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7674 : checkCertificateFast 10 7674 fastCert10_7674=true := by decide +kernel
def fastCert10_7675 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7675 : checkCertificateFast 10 7675 fastCert10_7675=true := by decide +kernel
def fastCert10_7676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7676 : checkCertificateFast 10 7676 fastCert10_7676=true := by decide +kernel
def fastCert10_7677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7677 : checkCertificateFast 10 7677 fastCert10_7677=true := by decide +kernel
def fastCert10_7678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7678 : checkCertificateFast 10 7678 fastCert10_7678=true := by decide +kernel
def fastCert10_7679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7679 : checkCertificateFast 10 7679 fastCert10_7679=true := by decide +kernel
def fastCert10_7680 : Certificate := ⟨6,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_7680 : checkCertificateFast 10 7680 fastCert10_7680=true := by decide +kernel
def fastCert10_7681 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7681 : checkCertificateFast 10 7681 fastCert10_7681=true := by decide +kernel
def fastCert10_7682 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7682 : checkCertificateFast 10 7682 fastCert10_7682=true := by decide +kernel
def fastCert10_7683 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7683 : checkCertificateFast 10 7683 fastCert10_7683=true := by decide +kernel
def fastCert10_7684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7684 : checkCertificateFast 10 7684 fastCert10_7684=true := by decide +kernel
def fastCert10_7685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7685 : checkCertificateFast 10 7685 fastCert10_7685=true := by decide +kernel
def fastCert10_7686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7686 : checkCertificateFast 10 7686 fastCert10_7686=true := by decide +kernel
def fastCert10_7687 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7687 : checkCertificateFast 10 7687 fastCert10_7687=true := by decide +kernel
def fastCert10_7688 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7688 : checkCertificateFast 10 7688 fastCert10_7688=true := by decide +kernel
def fastCert10_7689 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7689 : checkCertificateFast 10 7689 fastCert10_7689=true := by decide +kernel
def fastCert10_7690 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7690 : checkCertificateFast 10 7690 fastCert10_7690=true := by decide +kernel
def fastCert10_7691 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7691 : checkCertificateFast 10 7691 fastCert10_7691=true := by decide +kernel
def fastCert10_7692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_7692 : checkCertificateFast 10 7692 fastCert10_7692=true := by decide +kernel
def fastCert10_7693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7693 : checkCertificateFast 10 7693 fastCert10_7693=true := by decide +kernel
def fastCert10_7694 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7694 : checkCertificateFast 10 7694 fastCert10_7694=true := by decide +kernel
def fastCert10_7695 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7695 : checkCertificateFast 10 7695 fastCert10_7695=true := by decide +kernel
def fastCert10_7696 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7696 : checkCertificateFast 10 7696 fastCert10_7696=true := by decide +kernel
def fastCert10_7697 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7697 : checkCertificateFast 10 7697 fastCert10_7697=true := by decide +kernel
def fastCert10_7698 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7698 : checkCertificateFast 10 7698 fastCert10_7698=true := by decide +kernel
def fastCert10_7699 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7699 : checkCertificateFast 10 7699 fastCert10_7699=true := by decide +kernel
def fastCert10_7700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7700 : checkCertificateFast 10 7700 fastCert10_7700=true := by decide +kernel
def fastCert10_7701 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7701 : checkCertificateFast 10 7701 fastCert10_7701=true := by decide +kernel
def fastCert10_7702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7702 : checkCertificateFast 10 7702 fastCert10_7702=true := by decide +kernel
def fastCert10_7703 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7703 : checkCertificateFast 10 7703 fastCert10_7703=true := by decide +kernel
def fastCert10_7704 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7704 : checkCertificateFast 10 7704 fastCert10_7704=true := by decide +kernel
def fastCert10_7705 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7705 : checkCertificateFast 10 7705 fastCert10_7705=true := by decide +kernel
def fastCert10_7706 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7706 : checkCertificateFast 10 7706 fastCert10_7706=true := by decide +kernel
def fastCert10_7707 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7707 : checkCertificateFast 10 7707 fastCert10_7707=true := by decide +kernel
def fastCert10_7708 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7708 : checkCertificateFast 10 7708 fastCert10_7708=true := by decide +kernel
def fastCert10_7709 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7709 : checkCertificateFast 10 7709 fastCert10_7709=true := by decide +kernel
def fastCert10_7710 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7710 : checkCertificateFast 10 7710 fastCert10_7710=true := by decide +kernel
def fastCert10_7711 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7711 : checkCertificateFast 10 7711 fastCert10_7711=true := by decide +kernel
def fastCert10_7712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7712 : checkCertificateFast 10 7712 fastCert10_7712=true := by decide +kernel
def fastCert10_7713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7713 : checkCertificateFast 10 7713 fastCert10_7713=true := by decide +kernel
def fastCert10_7714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7714 : checkCertificateFast 10 7714 fastCert10_7714=true := by decide +kernel
def fastCert10_7715 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7715 : checkCertificateFast 10 7715 fastCert10_7715=true := by decide +kernel
def fastCert10_7716 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_7716 : checkCertificateFast 10 7716 fastCert10_7716=true := by decide +kernel
def fastCert10_7717 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7717 : checkCertificateFast 10 7717 fastCert10_7717=true := by decide +kernel
def fastCert10_7718 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7718 : checkCertificateFast 10 7718 fastCert10_7718=true := by decide +kernel
def fastCert10_7719 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7719 : checkCertificateFast 10 7719 fastCert10_7719=true := by decide +kernel
def fastCert10_7720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7720 : checkCertificateFast 10 7720 fastCert10_7720=true := by decide +kernel
def fastCert10_7721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7721 : checkCertificateFast 10 7721 fastCert10_7721=true := by decide +kernel
def fastCert10_7722 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7722 : checkCertificateFast 10 7722 fastCert10_7722=true := by decide +kernel
def fastCert10_7723 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7723 : checkCertificateFast 10 7723 fastCert10_7723=true := by decide +kernel
def fastCert10_7724 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7724 : checkCertificateFast 10 7724 fastCert10_7724=true := by decide +kernel
def fastCert10_7725 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7725 : checkCertificateFast 10 7725 fastCert10_7725=true := by decide +kernel
def fastCert10_7726 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7726 : checkCertificateFast 10 7726 fastCert10_7726=true := by decide +kernel
def fastCert10_7727 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7727 : checkCertificateFast 10 7727 fastCert10_7727=true := by decide +kernel
def fastCert10_7728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7728 : checkCertificateFast 10 7728 fastCert10_7728=true := by decide +kernel
def fastCert10_7729 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7729 : checkCertificateFast 10 7729 fastCert10_7729=true := by decide +kernel
def fastCert10_7730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7730 : checkCertificateFast 10 7730 fastCert10_7730=true := by decide +kernel
def fastCert10_7731 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7731 : checkCertificateFast 10 7731 fastCert10_7731=true := by decide +kernel
def fastCert10_7732 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7732 : checkCertificateFast 10 7732 fastCert10_7732=true := by decide +kernel
def fastCert10_7733 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7733 : checkCertificateFast 10 7733 fastCert10_7733=true := by decide +kernel
def fastCert10_7734 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7734 : checkCertificateFast 10 7734 fastCert10_7734=true := by decide +kernel
def fastCert10_7735 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7735 : checkCertificateFast 10 7735 fastCert10_7735=true := by decide +kernel
def fastCert10_7736 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7736 : checkCertificateFast 10 7736 fastCert10_7736=true := by decide +kernel
def fastCert10_7737 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7737 : checkCertificateFast 10 7737 fastCert10_7737=true := by decide +kernel
def fastCert10_7738 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7738 : checkCertificateFast 10 7738 fastCert10_7738=true := by decide +kernel
def fastCert10_7739 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_7739 : checkCertificateFast 10 7739 fastCert10_7739=true := by decide +kernel
def fastCert10_7740 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7740 : checkCertificateFast 10 7740 fastCert10_7740=true := by decide +kernel
def fastCert10_7741 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7741 : checkCertificateFast 10 7741 fastCert10_7741=true := by decide +kernel
def fastCert10_7742 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7742 : checkCertificateFast 10 7742 fastCert10_7742=true := by decide +kernel
def fastCert10_7743 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7743 : checkCertificateFast 10 7743 fastCert10_7743=true := by decide +kernel
def fastCert10_7744 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7744 : checkCertificateFast 10 7744 fastCert10_7744=true := by decide +kernel
def fastCert10_7745 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7745 : checkCertificateFast 10 7745 fastCert10_7745=true := by decide +kernel
def fastCert10_7746 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7746 : checkCertificateFast 10 7746 fastCert10_7746=true := by decide +kernel
def fastCert10_7747 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7747 : checkCertificateFast 10 7747 fastCert10_7747=true := by decide +kernel
def fastCert10_7748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7748 : checkCertificateFast 10 7748 fastCert10_7748=true := by decide +kernel
def fastCert10_7749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7749 : checkCertificateFast 10 7749 fastCert10_7749=true := by decide +kernel
def fastCert10_7750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7750 : checkCertificateFast 10 7750 fastCert10_7750=true := by decide +kernel
def fastCert10_7751 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7751 : checkCertificateFast 10 7751 fastCert10_7751=true := by decide +kernel
def fastCert10_7752 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7752 : checkCertificateFast 10 7752 fastCert10_7752=true := by decide +kernel
def fastCert10_7753 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7753 : checkCertificateFast 10 7753 fastCert10_7753=true := by decide +kernel
def fastCert10_7754 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7754 : checkCertificateFast 10 7754 fastCert10_7754=true := by decide +kernel
def fastCert10_7755 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7755 : checkCertificateFast 10 7755 fastCert10_7755=true := by decide +kernel
def fastCert10_7756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7756 : checkCertificateFast 10 7756 fastCert10_7756=true := by decide +kernel
def fastCert10_7757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7757 : checkCertificateFast 10 7757 fastCert10_7757=true := by decide +kernel
def fastCert10_7758 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7758 : checkCertificateFast 10 7758 fastCert10_7758=true := by decide +kernel
def fastCert10_7759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7759 : checkCertificateFast 10 7759 fastCert10_7759=true := by decide +kernel
def fastCert10_7760 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7760 : checkCertificateFast 10 7760 fastCert10_7760=true := by decide +kernel
def fastCert10_7761 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7761 : checkCertificateFast 10 7761 fastCert10_7761=true := by decide +kernel
def fastCert10_7762 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7762 : checkCertificateFast 10 7762 fastCert10_7762=true := by decide +kernel
def fastCert10_7763 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7763 : checkCertificateFast 10 7763 fastCert10_7763=true := by decide +kernel
def fastCert10_7764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7764 : checkCertificateFast 10 7764 fastCert10_7764=true := by decide +kernel
def fastCert10_7765 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7765 : checkCertificateFast 10 7765 fastCert10_7765=true := by decide +kernel
def fastCert10_7766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7766 : checkCertificateFast 10 7766 fastCert10_7766=true := by decide +kernel
def fastCert10_7767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7767 : checkCertificateFast 10 7767 fastCert10_7767=true := by decide +kernel
def fastCert10_7768 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7768 : checkCertificateFast 10 7768 fastCert10_7768=true := by decide +kernel
def fastCert10_7769 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7769 : checkCertificateFast 10 7769 fastCert10_7769=true := by decide +kernel
def fastCert10_7770 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7770 : checkCertificateFast 10 7770 fastCert10_7770=true := by decide +kernel
def fastCert10_7771 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7771 : checkCertificateFast 10 7771 fastCert10_7771=true := by decide +kernel
def fastCert10_7772 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7772 : checkCertificateFast 10 7772 fastCert10_7772=true := by decide +kernel
def fastCert10_7773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7773 : checkCertificateFast 10 7773 fastCert10_7773=true := by decide +kernel
def fastCert10_7774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7774 : checkCertificateFast 10 7774 fastCert10_7774=true := by decide +kernel
def fastCert10_7775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7775 : checkCertificateFast 10 7775 fastCert10_7775=true := by decide +kernel
def fastCert10_7776 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7776 : checkCertificateFast 10 7776 fastCert10_7776=true := by decide +kernel
def fastCert10_7777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7777 : checkCertificateFast 10 7777 fastCert10_7777=true := by decide +kernel
def fastCert10_7778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7778 : checkCertificateFast 10 7778 fastCert10_7778=true := by decide +kernel
def fastCert10_7779 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7779 : checkCertificateFast 10 7779 fastCert10_7779=true := by decide +kernel
def fastCert10_7780 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_7780 : checkCertificateFast 10 7780 fastCert10_7780=true := by decide +kernel
def fastCert10_7781 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7781 : checkCertificateFast 10 7781 fastCert10_7781=true := by decide +kernel
def fastCert10_7782 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7782 : checkCertificateFast 10 7782 fastCert10_7782=true := by decide +kernel
def fastCert10_7783 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7783 : checkCertificateFast 10 7783 fastCert10_7783=true := by decide +kernel
def fastCert10_7784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7784 : checkCertificateFast 10 7784 fastCert10_7784=true := by decide +kernel
def fastCert10_7785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7785 : checkCertificateFast 10 7785 fastCert10_7785=true := by decide +kernel
def fastCert10_7786 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7786 : checkCertificateFast 10 7786 fastCert10_7786=true := by decide +kernel
def fastCert10_7787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7787 : checkCertificateFast 10 7787 fastCert10_7787=true := by decide +kernel
def fastCert10_7788 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7788 : checkCertificateFast 10 7788 fastCert10_7788=true := by decide +kernel
def fastCert10_7789 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7789 : checkCertificateFast 10 7789 fastCert10_7789=true := by decide +kernel
def fastCert10_7790 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7790 : checkCertificateFast 10 7790 fastCert10_7790=true := by decide +kernel
def fastCert10_7791 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7791 : checkCertificateFast 10 7791 fastCert10_7791=true := by decide +kernel
def fastCert10_7792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7792 : checkCertificateFast 10 7792 fastCert10_7792=true := by decide +kernel
def fastCert10_7793 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7793 : checkCertificateFast 10 7793 fastCert10_7793=true := by decide +kernel
def fastCert10_7794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7794 : checkCertificateFast 10 7794 fastCert10_7794=true := by decide +kernel
def fastCert10_7795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7795 : checkCertificateFast 10 7795 fastCert10_7795=true := by decide +kernel
def fastCert10_7796 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7796 : checkCertificateFast 10 7796 fastCert10_7796=true := by decide +kernel
def fastCert10_7797 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7797 : checkCertificateFast 10 7797 fastCert10_7797=true := by decide +kernel
def fastCert10_7798 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7798 : checkCertificateFast 10 7798 fastCert10_7798=true := by decide +kernel
def fastCert10_7799 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7799 : checkCertificateFast 10 7799 fastCert10_7799=true := by decide +kernel
def fastCert10_7800 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7800 : checkCertificateFast 10 7800 fastCert10_7800=true := by decide +kernel
def fastCert10_7801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7801 : checkCertificateFast 10 7801 fastCert10_7801=true := by decide +kernel
def fastCert10_7802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7802 : checkCertificateFast 10 7802 fastCert10_7802=true := by decide +kernel
def fastCert10_7803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7803 : checkCertificateFast 10 7803 fastCert10_7803=true := by decide +kernel
def fastCert10_7804 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7804 : checkCertificateFast 10 7804 fastCert10_7804=true := by decide +kernel
def fastCert10_7805 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7805 : checkCertificateFast 10 7805 fastCert10_7805=true := by decide +kernel
def fastCert10_7806 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7806 : checkCertificateFast 10 7806 fastCert10_7806=true := by decide +kernel
def fastCert10_7807 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7807 : checkCertificateFast 10 7807 fastCert10_7807=true := by decide +kernel
def fastCert10_7808 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7808 : checkCertificateFast 10 7808 fastCert10_7808=true := by decide +kernel
def fastCert10_7809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7809 : checkCertificateFast 10 7809 fastCert10_7809=true := by decide +kernel
def fastCert10_7810 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7810 : checkCertificateFast 10 7810 fastCert10_7810=true := by decide +kernel
def fastCert10_7811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7811 : checkCertificateFast 10 7811 fastCert10_7811=true := by decide +kernel
def fastCert10_7812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7812 : checkCertificateFast 10 7812 fastCert10_7812=true := by decide +kernel
def fastCert10_7813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7813 : checkCertificateFast 10 7813 fastCert10_7813=true := by decide +kernel
def fastCert10_7814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7814 : checkCertificateFast 10 7814 fastCert10_7814=true := by decide +kernel
def fastCert10_7815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7815 : checkCertificateFast 10 7815 fastCert10_7815=true := by decide +kernel
def fastCert10_7816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7816 : checkCertificateFast 10 7816 fastCert10_7816=true := by decide +kernel
def fastCert10_7817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7817 : checkCertificateFast 10 7817 fastCert10_7817=true := by decide +kernel
def fastCert10_7818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_7818 : checkCertificateFast 10 7818 fastCert10_7818=true := by decide +kernel
def fastCert10_7819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7819 : checkCertificateFast 10 7819 fastCert10_7819=true := by decide +kernel
def fastCert10_7820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7820 : checkCertificateFast 10 7820 fastCert10_7820=true := by decide +kernel
def fastCert10_7821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7821 : checkCertificateFast 10 7821 fastCert10_7821=true := by decide +kernel
def fastCert10_7822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7822 : checkCertificateFast 10 7822 fastCert10_7822=true := by decide +kernel
def fastCert10_7823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7823 : checkCertificateFast 10 7823 fastCert10_7823=true := by decide +kernel
def fastCert10_7824 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7824 : checkCertificateFast 10 7824 fastCert10_7824=true := by decide +kernel
def fastCert10_7825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7825 : checkCertificateFast 10 7825 fastCert10_7825=true := by decide +kernel
def fastCert10_7826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7826 : checkCertificateFast 10 7826 fastCert10_7826=true := by decide +kernel
def fastCert10_7827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7827 : checkCertificateFast 10 7827 fastCert10_7827=true := by decide +kernel
def fastCert10_7828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7828 : checkCertificateFast 10 7828 fastCert10_7828=true := by decide +kernel
def fastCert10_7829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7829 : checkCertificateFast 10 7829 fastCert10_7829=true := by decide +kernel
def fastCert10_7830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7830 : checkCertificateFast 10 7830 fastCert10_7830=true := by decide +kernel
def fastCert10_7831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7831 : checkCertificateFast 10 7831 fastCert10_7831=true := by decide +kernel
def fastCert10_7832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7832 : checkCertificateFast 10 7832 fastCert10_7832=true := by decide +kernel
def fastCert10_7833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7833 : checkCertificateFast 10 7833 fastCert10_7833=true := by decide +kernel
def fastCert10_7834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7834 : checkCertificateFast 10 7834 fastCert10_7834=true := by decide +kernel
def fastCert10_7835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7835 : checkCertificateFast 10 7835 fastCert10_7835=true := by decide +kernel
def fastCert10_7836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7836 : checkCertificateFast 10 7836 fastCert10_7836=true := by decide +kernel
def fastCert10_7837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7837 : checkCertificateFast 10 7837 fastCert10_7837=true := by decide +kernel
def fastCert10_7838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7838 : checkCertificateFast 10 7838 fastCert10_7838=true := by decide +kernel
def fastCert10_7839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7839 : checkCertificateFast 10 7839 fastCert10_7839=true := by decide +kernel
def fastCert10_7840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7840 : checkCertificateFast 10 7840 fastCert10_7840=true := by decide +kernel
def fastCert10_7841 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7841 : checkCertificateFast 10 7841 fastCert10_7841=true := by decide +kernel
def fastCert10_7842 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7842 : checkCertificateFast 10 7842 fastCert10_7842=true := by decide +kernel
def fastCert10_7843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7843 : checkCertificateFast 10 7843 fastCert10_7843=true := by decide +kernel
def fastCert10_7844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7844 : checkCertificateFast 10 7844 fastCert10_7844=true := by decide +kernel
def fastCert10_7845 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7845 : checkCertificateFast 10 7845 fastCert10_7845=true := by decide +kernel
def fastCert10_7846 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7846 : checkCertificateFast 10 7846 fastCert10_7846=true := by decide +kernel
def fastCert10_7847 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7847 : checkCertificateFast 10 7847 fastCert10_7847=true := by decide +kernel
def fastCert10_7848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7848 : checkCertificateFast 10 7848 fastCert10_7848=true := by decide +kernel
def fastCert10_7849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7849 : checkCertificateFast 10 7849 fastCert10_7849=true := by decide +kernel
def fastCert10_7850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7850 : checkCertificateFast 10 7850 fastCert10_7850=true := by decide +kernel
def fastCert10_7851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7851 : checkCertificateFast 10 7851 fastCert10_7851=true := by decide +kernel
def fastCert10_7852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7852 : checkCertificateFast 10 7852 fastCert10_7852=true := by decide +kernel
def fastCert10_7853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7853 : checkCertificateFast 10 7853 fastCert10_7853=true := by decide +kernel
def fastCert10_7854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7854 : checkCertificateFast 10 7854 fastCert10_7854=true := by decide +kernel
def fastCert10_7855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7855 : checkCertificateFast 10 7855 fastCert10_7855=true := by decide +kernel
def fastCert10_7856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7856 : checkCertificateFast 10 7856 fastCert10_7856=true := by decide +kernel
def fastCert10_7857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7857 : checkCertificateFast 10 7857 fastCert10_7857=true := by decide +kernel
def fastCert10_7858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7858 : checkCertificateFast 10 7858 fastCert10_7858=true := by decide +kernel
def fastCert10_7859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7859 : checkCertificateFast 10 7859 fastCert10_7859=true := by decide +kernel
def fastCert10_7860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7860 : checkCertificateFast 10 7860 fastCert10_7860=true := by decide +kernel
def fastCert10_7861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7861 : checkCertificateFast 10 7861 fastCert10_7861=true := by decide +kernel
def fastCert10_7862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7862 : checkCertificateFast 10 7862 fastCert10_7862=true := by decide +kernel
def fastCert10_7863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7863 : checkCertificateFast 10 7863 fastCert10_7863=true := by decide +kernel
def fastCert10_7864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7864 : checkCertificateFast 10 7864 fastCert10_7864=true := by decide +kernel
def fastCert10_7865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7865 : checkCertificateFast 10 7865 fastCert10_7865=true := by decide +kernel
def fastCert10_7866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7866 : checkCertificateFast 10 7866 fastCert10_7866=true := by decide +kernel
def fastCert10_7867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7867 : checkCertificateFast 10 7867 fastCert10_7867=true := by decide +kernel
def fastCert10_7868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7868 : checkCertificateFast 10 7868 fastCert10_7868=true := by decide +kernel
def fastCert10_7869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7869 : checkCertificateFast 10 7869 fastCert10_7869=true := by decide +kernel
def fastCert10_7870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7870 : checkCertificateFast 10 7870 fastCert10_7870=true := by decide +kernel
def fastCert10_7871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7871 : checkCertificateFast 10 7871 fastCert10_7871=true := by decide +kernel
def fastCert10_7872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7872 : checkCertificateFast 10 7872 fastCert10_7872=true := by decide +kernel
def fastCert10_7873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7873 : checkCertificateFast 10 7873 fastCert10_7873=true := by decide +kernel
def fastCert10_7874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7874 : checkCertificateFast 10 7874 fastCert10_7874=true := by decide +kernel
def fastCert10_7875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7875 : checkCertificateFast 10 7875 fastCert10_7875=true := by decide +kernel
def fastCert10_7876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7876 : checkCertificateFast 10 7876 fastCert10_7876=true := by decide +kernel
def fastCert10_7877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7877 : checkCertificateFast 10 7877 fastCert10_7877=true := by decide +kernel
def fastCert10_7878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7878 : checkCertificateFast 10 7878 fastCert10_7878=true := by decide +kernel
def fastCert10_7879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7879 : checkCertificateFast 10 7879 fastCert10_7879=true := by decide +kernel
def fastCert10_7880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7880 : checkCertificateFast 10 7880 fastCert10_7880=true := by decide +kernel
def fastCert10_7881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7881 : checkCertificateFast 10 7881 fastCert10_7881=true := by decide +kernel
def fastCert10_7882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7882 : checkCertificateFast 10 7882 fastCert10_7882=true := by decide +kernel
def fastCert10_7883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7883 : checkCertificateFast 10 7883 fastCert10_7883=true := by decide +kernel
def fastCert10_7884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7884 : checkCertificateFast 10 7884 fastCert10_7884=true := by decide +kernel
def fastCert10_7885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7885 : checkCertificateFast 10 7885 fastCert10_7885=true := by decide +kernel
def fastCert10_7886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7886 : checkCertificateFast 10 7886 fastCert10_7886=true := by decide +kernel
def fastCert10_7887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7887 : checkCertificateFast 10 7887 fastCert10_7887=true := by decide +kernel
def fastCert10_7888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7888 : checkCertificateFast 10 7888 fastCert10_7888=true := by decide +kernel
def fastCert10_7889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7889 : checkCertificateFast 10 7889 fastCert10_7889=true := by decide +kernel
def fastCert10_7890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7890 : checkCertificateFast 10 7890 fastCert10_7890=true := by decide +kernel
def fastCert10_7891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7891 : checkCertificateFast 10 7891 fastCert10_7891=true := by decide +kernel
def fastCert10_7892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7892 : checkCertificateFast 10 7892 fastCert10_7892=true := by decide +kernel
def fastCert10_7893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7893 : checkCertificateFast 10 7893 fastCert10_7893=true := by decide +kernel
def fastCert10_7894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7894 : checkCertificateFast 10 7894 fastCert10_7894=true := by decide +kernel
def fastCert10_7895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7895 : checkCertificateFast 10 7895 fastCert10_7895=true := by decide +kernel
def fastCert10_7896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7896 : checkCertificateFast 10 7896 fastCert10_7896=true := by decide +kernel
def fastCert10_7897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7897 : checkCertificateFast 10 7897 fastCert10_7897=true := by decide +kernel
def fastCert10_7898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7898 : checkCertificateFast 10 7898 fastCert10_7898=true := by decide +kernel
def fastCert10_7899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7899 : checkCertificateFast 10 7899 fastCert10_7899=true := by decide +kernel
def fastCert10_7900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7900 : checkCertificateFast 10 7900 fastCert10_7900=true := by decide +kernel
def fastCert10_7901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7901 : checkCertificateFast 10 7901 fastCert10_7901=true := by decide +kernel
def fastCert10_7902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7902 : checkCertificateFast 10 7902 fastCert10_7902=true := by decide +kernel
def fastCert10_7903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_7903 : checkCertificateFast 10 7903 fastCert10_7903=true := by decide +kernel
def fastCert10_7904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7904 : checkCertificateFast 10 7904 fastCert10_7904=true := by decide +kernel
def fastCert10_7905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7905 : checkCertificateFast 10 7905 fastCert10_7905=true := by decide +kernel
def fastCert10_7906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7906 : checkCertificateFast 10 7906 fastCert10_7906=true := by decide +kernel
def fastCert10_7907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7907 : checkCertificateFast 10 7907 fastCert10_7907=true := by decide +kernel
def fastCert10_7908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7908 : checkCertificateFast 10 7908 fastCert10_7908=true := by decide +kernel
def fastCert10_7909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7909 : checkCertificateFast 10 7909 fastCert10_7909=true := by decide +kernel
def fastCert10_7910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7910 : checkCertificateFast 10 7910 fastCert10_7910=true := by decide +kernel
def fastCert10_7911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7911 : checkCertificateFast 10 7911 fastCert10_7911=true := by decide +kernel
def fastCert10_7912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7912 : checkCertificateFast 10 7912 fastCert10_7912=true := by decide +kernel
def fastCert10_7913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7913 : checkCertificateFast 10 7913 fastCert10_7913=true := by decide +kernel
def fastCert10_7914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7914 : checkCertificateFast 10 7914 fastCert10_7914=true := by decide +kernel
def fastCert10_7915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7915 : checkCertificateFast 10 7915 fastCert10_7915=true := by decide +kernel
def fastCert10_7916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7916 : checkCertificateFast 10 7916 fastCert10_7916=true := by decide +kernel
def fastCert10_7917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7917 : checkCertificateFast 10 7917 fastCert10_7917=true := by decide +kernel
def fastCert10_7918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7918 : checkCertificateFast 10 7918 fastCert10_7918=true := by decide +kernel
def fastCert10_7919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7919 : checkCertificateFast 10 7919 fastCert10_7919=true := by decide +kernel
def fastCert10_7920 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7920 : checkCertificateFast 10 7920 fastCert10_7920=true := by decide +kernel
def fastCert10_7921 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7921 : checkCertificateFast 10 7921 fastCert10_7921=true := by decide +kernel
def fastCert10_7922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_7922 : checkCertificateFast 10 7922 fastCert10_7922=true := by decide +kernel
def fastCert10_7923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_7923 : checkCertificateFast 10 7923 fastCert10_7923=true := by decide +kernel
def fastCert10_7924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7924 : checkCertificateFast 10 7924 fastCert10_7924=true := by decide +kernel
def fastCert10_7925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7925 : checkCertificateFast 10 7925 fastCert10_7925=true := by decide +kernel
def fastCert10_7926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7926 : checkCertificateFast 10 7926 fastCert10_7926=true := by decide +kernel
def fastCert10_7927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7927 : checkCertificateFast 10 7927 fastCert10_7927=true := by decide +kernel
def fastCert10_7928 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7928 : checkCertificateFast 10 7928 fastCert10_7928=true := by decide +kernel
def fastCert10_7929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7929 : checkCertificateFast 10 7929 fastCert10_7929=true := by decide +kernel
def fastCert10_7930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7930 : checkCertificateFast 10 7930 fastCert10_7930=true := by decide +kernel
def fastCert10_7931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7931 : checkCertificateFast 10 7931 fastCert10_7931=true := by decide +kernel
def fastCert10_7932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7932 : checkCertificateFast 10 7932 fastCert10_7932=true := by decide +kernel
def fastCert10_7933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7933 : checkCertificateFast 10 7933 fastCert10_7933=true := by decide +kernel
def fastCert10_7934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7934 : checkCertificateFast 10 7934 fastCert10_7934=true := by decide +kernel
def fastCert10_7935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_7935 : checkCertificateFast 10 7935 fastCert10_7935=true := by decide +kernel
def fastCert10_7936 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7936 : checkCertificateFast 10 7936 fastCert10_7936=true := by decide +kernel
def fastCert10_7937 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7937 : checkCertificateFast 10 7937 fastCert10_7937=true := by decide +kernel
def fastCert10_7938 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7938 : checkCertificateFast 10 7938 fastCert10_7938=true := by decide +kernel
def fastCert10_7939 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-3) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7939 : checkCertificateFast 10 7939 fastCert10_7939=true := by decide +kernel
def fastCert10_7940 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7940 : checkCertificateFast 10 7940 fastCert10_7940=true := by decide +kernel
def fastCert10_7941 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_7941 : checkCertificateFast 10 7941 fastCert10_7941=true := by decide +kernel
def fastCert10_7942 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7942 : checkCertificateFast 10 7942 fastCert10_7942=true := by decide +kernel
def fastCert10_7943 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7943 : checkCertificateFast 10 7943 fastCert10_7943=true := by decide +kernel
def fastCert10_7944 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7944 : checkCertificateFast 10 7944 fastCert10_7944=true := by decide +kernel
def fastCert10_7945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7945 : checkCertificateFast 10 7945 fastCert10_7945=true := by decide +kernel
def fastCert10_7946 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7946 : checkCertificateFast 10 7946 fastCert10_7946=true := by decide +kernel
def fastCert10_7947 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7947 : checkCertificateFast 10 7947 fastCert10_7947=true := by decide +kernel
def fastCert10_7948 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7948 : checkCertificateFast 10 7948 fastCert10_7948=true := by decide +kernel
def fastCert10_7949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7949 : checkCertificateFast 10 7949 fastCert10_7949=true := by decide +kernel
def fastCert10_7950 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7950 : checkCertificateFast 10 7950 fastCert10_7950=true := by decide +kernel
def fastCert10_7951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7951 : checkCertificateFast 10 7951 fastCert10_7951=true := by decide +kernel
def fastCert10_7952 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7952 : checkCertificateFast 10 7952 fastCert10_7952=true := by decide +kernel
def fastCert10_7953 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7953 : checkCertificateFast 10 7953 fastCert10_7953=true := by decide +kernel
def fastCert10_7954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7954 : checkCertificateFast 10 7954 fastCert10_7954=true := by decide +kernel
def fastCert10_7955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7955 : checkCertificateFast 10 7955 fastCert10_7955=true := by decide +kernel
def fastCert10_7956 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7956 : checkCertificateFast 10 7956 fastCert10_7956=true := by decide +kernel
def fastCert10_7957 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7957 : checkCertificateFast 10 7957 fastCert10_7957=true := by decide +kernel
def fastCert10_7958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7958 : checkCertificateFast 10 7958 fastCert10_7958=true := by decide +kernel
def fastCert10_7959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_7959 : checkCertificateFast 10 7959 fastCert10_7959=true := by decide +kernel
def fastCert10_7960 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_7960 : checkCertificateFast 10 7960 fastCert10_7960=true := by decide +kernel
def fastCert10_7961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7961 : checkCertificateFast 10 7961 fastCert10_7961=true := by decide +kernel
def fastCert10_7962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7962 : checkCertificateFast 10 7962 fastCert10_7962=true := by decide +kernel
def fastCert10_7963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7963 : checkCertificateFast 10 7963 fastCert10_7963=true := by decide +kernel
def fastCert10_7964 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase10_7964 : checkCertificateFast 10 7964 fastCert10_7964=true := by decide +kernel
def fastCert10_7965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7965 : checkCertificateFast 10 7965 fastCert10_7965=true := by decide +kernel
def fastCert10_7966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7966 : checkCertificateFast 10 7966 fastCert10_7966=true := by decide +kernel
def fastCert10_7967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_7967 : checkCertificateFast 10 7967 fastCert10_7967=true := by decide +kernel
def fastCert10_7968 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7968 : checkCertificateFast 10 7968 fastCert10_7968=true := by decide +kernel
def fastCert10_7969 : Certificate := ⟨8,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7969 : checkCertificateFast 10 7969 fastCert10_7969=true := by decide +kernel
def fastCert10_7970 : Certificate := ⟨8,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7970 : checkCertificateFast 10 7970 fastCert10_7970=true := by decide +kernel
def fastCert10_7971 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7971 : checkCertificateFast 10 7971 fastCert10_7971=true := by decide +kernel
def fastCert10_7972 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7972 : checkCertificateFast 10 7972 fastCert10_7972=true := by decide +kernel
def fastCert10_7973 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7973 : checkCertificateFast 10 7973 fastCert10_7973=true := by decide +kernel
def fastCert10_7974 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7974 : checkCertificateFast 10 7974 fastCert10_7974=true := by decide +kernel
def fastCert10_7975 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7975 : checkCertificateFast 10 7975 fastCert10_7975=true := by decide +kernel
def fastCert10_7976 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7976 : checkCertificateFast 10 7976 fastCert10_7976=true := by decide +kernel
def fastCert10_7977 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7977 : checkCertificateFast 10 7977 fastCert10_7977=true := by decide +kernel
def fastCert10_7978 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7978 : checkCertificateFast 10 7978 fastCert10_7978=true := by decide +kernel
def fastCert10_7979 : Certificate := ⟨12,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_7979 : checkCertificateFast 10 7979 fastCert10_7979=true := by decide +kernel
def fastCert10_7980 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7980 : checkCertificateFast 10 7980 fastCert10_7980=true := by decide +kernel
def fastCert10_7981 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7981 : checkCertificateFast 10 7981 fastCert10_7981=true := by decide +kernel
def fastCert10_7982 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7982 : checkCertificateFast 10 7982 fastCert10_7982=true := by decide +kernel
def fastCert10_7983 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7983 : checkCertificateFast 10 7983 fastCert10_7983=true := by decide +kernel
def fastCert10_7984 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_7984 : checkCertificateFast 10 7984 fastCert10_7984=true := by decide +kernel
def fastCert10_7985 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7985 : checkCertificateFast 10 7985 fastCert10_7985=true := by decide +kernel
def fastCert10_7986 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7986 : checkCertificateFast 10 7986 fastCert10_7986=true := by decide +kernel
def fastCert10_7987 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7987 : checkCertificateFast 10 7987 fastCert10_7987=true := by decide +kernel
def fastCert10_7988 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7988 : checkCertificateFast 10 7988 fastCert10_7988=true := by decide +kernel
def fastCert10_7989 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7989 : checkCertificateFast 10 7989 fastCert10_7989=true := by decide +kernel
def fastCert10_7990 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7990 : checkCertificateFast 10 7990 fastCert10_7990=true := by decide +kernel
def fastCert10_7991 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_7991 : checkCertificateFast 10 7991 fastCert10_7991=true := by decide +kernel
def fastCert10_7992 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_7992 : checkCertificateFast 10 7992 fastCert10_7992=true := by decide +kernel
def fastCert10_7993 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7993 : checkCertificateFast 10 7993 fastCert10_7993=true := by decide +kernel
def fastCert10_7994 : Certificate := ⟨23,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7994 : checkCertificateFast 10 7994 fastCert10_7994=true := by decide +kernel
def fastCert10_7995 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7995 : checkCertificateFast 10 7995 fastCert10_7995=true := by decide +kernel
def fastCert10_7996 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7996 : checkCertificateFast 10 7996 fastCert10_7996=true := by decide +kernel
def fastCert10_7997 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_7997 : checkCertificateFast 10 7997 fastCert10_7997=true := by decide +kernel
def fastCert10_7998 : Certificate := ⟨26,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_7998 : checkCertificateFast 10 7998 fastCert10_7998=true := by decide +kernel
def fastCert10_7999 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_7999 : checkCertificateFast 10 7999 fastCert10_7999=true := by decide +kernel
theorem aggregate_F10_007 : (checkCertificateFast 10 7000 fastCert10_7000=true) ∧ (checkCertificateFast 10 7001 fastCert10_7001=true) ∧ (checkCertificateFast 10 7002 fastCert10_7002=true) ∧ (checkCertificateFast 10 7003 fastCert10_7003=true) ∧ (checkCertificateFast 10 7004 fastCert10_7004=true) ∧ (checkCertificateFast 10 7005 fastCert10_7005=true) ∧ (checkCertificateFast 10 7006 fastCert10_7006=true) ∧ (checkCertificateFast 10 7007 fastCert10_7007=true) ∧ (checkCertificateFast 10 7008 fastCert10_7008=true) ∧ (checkCertificateFast 10 7009 fastCert10_7009=true) ∧ (checkCertificateFast 10 7010 fastCert10_7010=true) ∧ (checkCertificateFast 10 7011 fastCert10_7011=true) ∧ (checkCertificateFast 10 7012 fastCert10_7012=true) ∧ (checkCertificateFast 10 7013 fastCert10_7013=true) ∧ (checkCertificateFast 10 7014 fastCert10_7014=true) ∧ (checkCertificateFast 10 7015 fastCert10_7015=true) ∧ (checkCertificateFast 10 7016 fastCert10_7016=true) ∧ (checkCertificateFast 10 7017 fastCert10_7017=true) ∧ (checkCertificateFast 10 7018 fastCert10_7018=true) ∧ (checkCertificateFast 10 7019 fastCert10_7019=true) ∧ (checkCertificateFast 10 7020 fastCert10_7020=true) ∧ (checkCertificateFast 10 7021 fastCert10_7021=true) ∧ (checkCertificateFast 10 7022 fastCert10_7022=true) ∧ (checkCertificateFast 10 7023 fastCert10_7023=true) ∧ (checkCertificateFast 10 7024 fastCert10_7024=true) ∧ (checkCertificateFast 10 7025 fastCert10_7025=true) ∧ (checkCertificateFast 10 7026 fastCert10_7026=true) ∧ (checkCertificateFast 10 7027 fastCert10_7027=true) ∧ (checkCertificateFast 10 7028 fastCert10_7028=true) ∧ (checkCertificateFast 10 7029 fastCert10_7029=true) ∧ (checkCertificateFast 10 7030 fastCert10_7030=true) ∧ (checkCertificateFast 10 7031 fastCert10_7031=true) ∧ (checkCertificateFast 10 7032 fastCert10_7032=true) ∧ (checkCertificateFast 10 7033 fastCert10_7033=true) ∧ (checkCertificateFast 10 7034 fastCert10_7034=true) ∧ (checkCertificateFast 10 7035 fastCert10_7035=true) ∧ (checkCertificateFast 10 7036 fastCert10_7036=true) ∧ (checkCertificateFast 10 7037 fastCert10_7037=true) ∧ (checkCertificateFast 10 7038 fastCert10_7038=true) ∧ (checkCertificateFast 10 7039 fastCert10_7039=true) ∧ (checkCertificateFast 10 7040 fastCert10_7040=true) ∧ (checkCertificateFast 10 7041 fastCert10_7041=true) ∧ (checkCertificateFast 10 7042 fastCert10_7042=true) ∧ (checkCertificateFast 10 7043 fastCert10_7043=true) ∧ (checkCertificateFast 10 7044 fastCert10_7044=true) ∧ (checkCertificateFast 10 7045 fastCert10_7045=true) ∧ (checkCertificateFast 10 7046 fastCert10_7046=true) ∧ (checkCertificateFast 10 7047 fastCert10_7047=true) ∧ (checkCertificateFast 10 7048 fastCert10_7048=true) ∧ (checkCertificateFast 10 7049 fastCert10_7049=true) ∧ (checkCertificateFast 10 7050 fastCert10_7050=true) ∧ (checkCertificateFast 10 7051 fastCert10_7051=true) ∧ (checkCertificateFast 10 7052 fastCert10_7052=true) ∧ (checkCertificateFast 10 7053 fastCert10_7053=true) ∧ (checkCertificateFast 10 7054 fastCert10_7054=true) ∧ (checkCertificateFast 10 7055 fastCert10_7055=true) ∧ (checkCertificateFast 10 7056 fastCert10_7056=true) ∧ (checkCertificateFast 10 7057 fastCert10_7057=true) ∧ (checkCertificateFast 10 7058 fastCert10_7058=true) ∧ (checkCertificateFast 10 7059 fastCert10_7059=true) ∧ (checkCertificateFast 10 7060 fastCert10_7060=true) ∧ (checkCertificateFast 10 7061 fastCert10_7061=true) ∧ (checkCertificateFast 10 7062 fastCert10_7062=true) ∧ (checkCertificateFast 10 7063 fastCert10_7063=true) ∧ (checkCertificateFast 10 7064 fastCert10_7064=true) ∧ (checkCertificateFast 10 7065 fastCert10_7065=true) ∧ (checkCertificateFast 10 7066 fastCert10_7066=true) ∧ (checkCertificateFast 10 7067 fastCert10_7067=true) ∧ (checkCertificateFast 10 7068 fastCert10_7068=true) ∧ (checkCertificateFast 10 7069 fastCert10_7069=true) ∧ (checkCertificateFast 10 7070 fastCert10_7070=true) ∧ (checkCertificateFast 10 7071 fastCert10_7071=true) ∧ (checkCertificateFast 10 7072 fastCert10_7072=true) ∧ (checkCertificateFast 10 7073 fastCert10_7073=true) ∧ (checkCertificateFast 10 7074 fastCert10_7074=true) ∧ (checkCertificateFast 10 7075 fastCert10_7075=true) ∧ (checkCertificateFast 10 7076 fastCert10_7076=true) ∧ (checkCertificateFast 10 7077 fastCert10_7077=true) ∧ (checkCertificateFast 10 7078 fastCert10_7078=true) ∧ (checkCertificateFast 10 7079 fastCert10_7079=true) ∧ (checkCertificateFast 10 7080 fastCert10_7080=true) ∧ (checkCertificateFast 10 7081 fastCert10_7081=true) ∧ (checkCertificateFast 10 7082 fastCert10_7082=true) ∧ (checkCertificateFast 10 7083 fastCert10_7083=true) ∧ (checkCertificateFast 10 7084 fastCert10_7084=true) ∧ (checkCertificateFast 10 7085 fastCert10_7085=true) ∧ (checkCertificateFast 10 7086 fastCert10_7086=true) ∧ (checkCertificateFast 10 7087 fastCert10_7087=true) ∧ (checkCertificateFast 10 7088 fastCert10_7088=true) ∧ (checkCertificateFast 10 7089 fastCert10_7089=true) ∧ (checkCertificateFast 10 7090 fastCert10_7090=true) ∧ (checkCertificateFast 10 7091 fastCert10_7091=true) ∧ (checkCertificateFast 10 7092 fastCert10_7092=true) ∧ (checkCertificateFast 10 7093 fastCert10_7093=true) ∧ (checkCertificateFast 10 7094 fastCert10_7094=true) ∧ (checkCertificateFast 10 7095 fastCert10_7095=true) ∧ (checkCertificateFast 10 7096 fastCert10_7096=true) ∧ (checkCertificateFast 10 7097 fastCert10_7097=true) ∧ (checkCertificateFast 10 7098 fastCert10_7098=true) ∧ (checkCertificateFast 10 7099 fastCert10_7099=true) ∧ (checkCertificateFast 10 7100 fastCert10_7100=true) ∧ (checkCertificateFast 10 7101 fastCert10_7101=true) ∧ (checkCertificateFast 10 7102 fastCert10_7102=true) ∧ (checkCertificateFast 10 7103 fastCert10_7103=true) ∧ (checkCertificateFast 10 7104 fastCert10_7104=true) ∧ (checkCertificateFast 10 7105 fastCert10_7105=true) ∧ (checkCertificateFast 10 7106 fastCert10_7106=true) ∧ (checkCertificateFast 10 7107 fastCert10_7107=true) ∧ (checkCertificateFast 10 7108 fastCert10_7108=true) ∧ (checkCertificateFast 10 7109 fastCert10_7109=true) ∧ (checkCertificateFast 10 7110 fastCert10_7110=true) ∧ (checkCertificateFast 10 7111 fastCert10_7111=true) ∧ (checkCertificateFast 10 7112 fastCert10_7112=true) ∧ (checkCertificateFast 10 7113 fastCert10_7113=true) ∧ (checkCertificateFast 10 7114 fastCert10_7114=true) ∧ (checkCertificateFast 10 7115 fastCert10_7115=true) ∧ (checkCertificateFast 10 7116 fastCert10_7116=true) ∧ (checkCertificateFast 10 7117 fastCert10_7117=true) ∧ (checkCertificateFast 10 7118 fastCert10_7118=true) ∧ (checkCertificateFast 10 7119 fastCert10_7119=true) ∧ (checkCertificateFast 10 7120 fastCert10_7120=true) ∧ (checkCertificateFast 10 7121 fastCert10_7121=true) ∧ (checkCertificateFast 10 7122 fastCert10_7122=true) ∧ (checkCertificateFast 10 7123 fastCert10_7123=true) ∧ (checkCertificateFast 10 7124 fastCert10_7124=true) ∧ (checkCertificateFast 10 7125 fastCert10_7125=true) ∧ (checkCertificateFast 10 7126 fastCert10_7126=true) ∧ (checkCertificateFast 10 7127 fastCert10_7127=true) ∧ (checkCertificateFast 10 7128 fastCert10_7128=true) ∧ (checkCertificateFast 10 7129 fastCert10_7129=true) ∧ (checkCertificateFast 10 7130 fastCert10_7130=true) ∧ (checkCertificateFast 10 7131 fastCert10_7131=true) ∧ (checkCertificateFast 10 7132 fastCert10_7132=true) ∧ (checkCertificateFast 10 7133 fastCert10_7133=true) ∧ (checkCertificateFast 10 7134 fastCert10_7134=true) ∧ (checkCertificateFast 10 7135 fastCert10_7135=true) ∧ (checkCertificateFast 10 7136 fastCert10_7136=true) ∧ (checkCertificateFast 10 7137 fastCert10_7137=true) ∧ (checkCertificateFast 10 7138 fastCert10_7138=true) ∧ (checkCertificateFast 10 7139 fastCert10_7139=true) ∧ (checkCertificateFast 10 7140 fastCert10_7140=true) ∧ (checkCertificateFast 10 7141 fastCert10_7141=true) ∧ (checkCertificateFast 10 7142 fastCert10_7142=true) ∧ (checkCertificateFast 10 7143 fastCert10_7143=true) ∧ (checkCertificateFast 10 7144 fastCert10_7144=true) ∧ (checkCertificateFast 10 7145 fastCert10_7145=true) ∧ (checkCertificateFast 10 7146 fastCert10_7146=true) ∧ (checkCertificateFast 10 7147 fastCert10_7147=true) ∧ (checkCertificateFast 10 7148 fastCert10_7148=true) ∧ (checkCertificateFast 10 7149 fastCert10_7149=true) ∧ (checkCertificateFast 10 7150 fastCert10_7150=true) ∧ (checkCertificateFast 10 7151 fastCert10_7151=true) ∧ (checkCertificateFast 10 7152 fastCert10_7152=true) ∧ (checkCertificateFast 10 7153 fastCert10_7153=true) ∧ (checkCertificateFast 10 7154 fastCert10_7154=true) ∧ (checkCertificateFast 10 7155 fastCert10_7155=true) ∧ (checkCertificateFast 10 7156 fastCert10_7156=true) ∧ (checkCertificateFast 10 7157 fastCert10_7157=true) ∧ (checkCertificateFast 10 7158 fastCert10_7158=true) ∧ (checkCertificateFast 10 7159 fastCert10_7159=true) ∧ (checkCertificateFast 10 7160 fastCert10_7160=true) ∧ (checkCertificateFast 10 7161 fastCert10_7161=true) ∧ (checkCertificateFast 10 7162 fastCert10_7162=true) ∧ (checkCertificateFast 10 7163 fastCert10_7163=true) ∧ (checkCertificateFast 10 7164 fastCert10_7164=true) ∧ (checkCertificateFast 10 7165 fastCert10_7165=true) ∧ (checkCertificateFast 10 7166 fastCert10_7166=true) ∧ (checkCertificateFast 10 7167 fastCert10_7167=true) ∧ (checkCertificateFast 10 7168 fastCert10_7168=true) ∧ (checkCertificateFast 10 7169 fastCert10_7169=true) ∧ (checkCertificateFast 10 7170 fastCert10_7170=true) ∧ (checkCertificateFast 10 7171 fastCert10_7171=true) ∧ (checkCertificateFast 10 7172 fastCert10_7172=true) ∧ (checkCertificateFast 10 7173 fastCert10_7173=true) ∧ (checkCertificateFast 10 7174 fastCert10_7174=true) ∧ (checkCertificateFast 10 7175 fastCert10_7175=true) ∧ (checkCertificateFast 10 7176 fastCert10_7176=true) ∧ (checkCertificateFast 10 7177 fastCert10_7177=true) ∧ (checkCertificateFast 10 7178 fastCert10_7178=true) ∧ (checkCertificateFast 10 7179 fastCert10_7179=true) ∧ (checkCertificateFast 10 7180 fastCert10_7180=true) ∧ (checkCertificateFast 10 7181 fastCert10_7181=true) ∧ (checkCertificateFast 10 7182 fastCert10_7182=true) ∧ (checkCertificateFast 10 7183 fastCert10_7183=true) ∧ (checkCertificateFast 10 7184 fastCert10_7184=true) ∧ (checkCertificateFast 10 7185 fastCert10_7185=true) ∧ (checkCertificateFast 10 7186 fastCert10_7186=true) ∧ (checkCertificateFast 10 7187 fastCert10_7187=true) ∧ (checkCertificateFast 10 7188 fastCert10_7188=true) ∧ (checkCertificateFast 10 7189 fastCert10_7189=true) ∧ (checkCertificateFast 10 7190 fastCert10_7190=true) ∧ (checkCertificateFast 10 7191 fastCert10_7191=true) ∧ (checkCertificateFast 10 7192 fastCert10_7192=true) ∧ (checkCertificateFast 10 7193 fastCert10_7193=true) ∧ (checkCertificateFast 10 7194 fastCert10_7194=true) ∧ (checkCertificateFast 10 7195 fastCert10_7195=true) ∧ (checkCertificateFast 10 7196 fastCert10_7196=true) ∧ (checkCertificateFast 10 7197 fastCert10_7197=true) ∧ (checkCertificateFast 10 7198 fastCert10_7198=true) ∧ (checkCertificateFast 10 7199 fastCert10_7199=true) ∧ (checkCertificateFast 10 7200 fastCert10_7200=true) ∧ (checkCertificateFast 10 7201 fastCert10_7201=true) ∧ (checkCertificateFast 10 7202 fastCert10_7202=true) ∧ (checkCertificateFast 10 7203 fastCert10_7203=true) ∧ (checkCertificateFast 10 7204 fastCert10_7204=true) ∧ (checkCertificateFast 10 7205 fastCert10_7205=true) ∧ (checkCertificateFast 10 7206 fastCert10_7206=true) ∧ (checkCertificateFast 10 7207 fastCert10_7207=true) ∧ (checkCertificateFast 10 7208 fastCert10_7208=true) ∧ (checkCertificateFast 10 7209 fastCert10_7209=true) ∧ (checkCertificateFast 10 7210 fastCert10_7210=true) ∧ (checkCertificateFast 10 7211 fastCert10_7211=true) ∧ (checkCertificateFast 10 7212 fastCert10_7212=true) ∧ (checkCertificateFast 10 7213 fastCert10_7213=true) ∧ (checkCertificateFast 10 7214 fastCert10_7214=true) ∧ (checkCertificateFast 10 7215 fastCert10_7215=true) ∧ (checkCertificateFast 10 7216 fastCert10_7216=true) ∧ (checkCertificateFast 10 7217 fastCert10_7217=true) ∧ (checkCertificateFast 10 7218 fastCert10_7218=true) ∧ (checkCertificateFast 10 7219 fastCert10_7219=true) ∧ (checkCertificateFast 10 7220 fastCert10_7220=true) ∧ (checkCertificateFast 10 7221 fastCert10_7221=true) ∧ (checkCertificateFast 10 7222 fastCert10_7222=true) ∧ (checkCertificateFast 10 7223 fastCert10_7223=true) ∧ (checkCertificateFast 10 7224 fastCert10_7224=true) ∧ (checkCertificateFast 10 7225 fastCert10_7225=true) ∧ (checkCertificateFast 10 7226 fastCert10_7226=true) ∧ (checkCertificateFast 10 7227 fastCert10_7227=true) ∧ (checkCertificateFast 10 7228 fastCert10_7228=true) ∧ (checkCertificateFast 10 7229 fastCert10_7229=true) ∧ (checkCertificateFast 10 7230 fastCert10_7230=true) ∧ (checkCertificateFast 10 7231 fastCert10_7231=true) ∧ (checkCertificateFast 10 7232 fastCert10_7232=true) ∧ (checkCertificateFast 10 7233 fastCert10_7233=true) ∧ (checkCertificateFast 10 7234 fastCert10_7234=true) ∧ (checkCertificateFast 10 7235 fastCert10_7235=true) ∧ (checkCertificateFast 10 7236 fastCert10_7236=true) ∧ (checkCertificateFast 10 7237 fastCert10_7237=true) ∧ (checkCertificateFast 10 7238 fastCert10_7238=true) ∧ (checkCertificateFast 10 7239 fastCert10_7239=true) ∧ (checkCertificateFast 10 7240 fastCert10_7240=true) ∧ (checkCertificateFast 10 7241 fastCert10_7241=true) ∧ (checkCertificateFast 10 7242 fastCert10_7242=true) ∧ (checkCertificateFast 10 7243 fastCert10_7243=true) ∧ (checkCertificateFast 10 7244 fastCert10_7244=true) ∧ (checkCertificateFast 10 7245 fastCert10_7245=true) ∧ (checkCertificateFast 10 7246 fastCert10_7246=true) ∧ (checkCertificateFast 10 7247 fastCert10_7247=true) ∧ (checkCertificateFast 10 7248 fastCert10_7248=true) ∧ (checkCertificateFast 10 7249 fastCert10_7249=true) ∧ (checkCertificateFast 10 7250 fastCert10_7250=true) ∧ (checkCertificateFast 10 7251 fastCert10_7251=true) ∧ (checkCertificateFast 10 7252 fastCert10_7252=true) ∧ (checkCertificateFast 10 7253 fastCert10_7253=true) ∧ (checkCertificateFast 10 7254 fastCert10_7254=true) ∧ (checkCertificateFast 10 7255 fastCert10_7255=true) ∧ (checkCertificateFast 10 7256 fastCert10_7256=true) ∧ (checkCertificateFast 10 7257 fastCert10_7257=true) ∧ (checkCertificateFast 10 7258 fastCert10_7258=true) ∧ (checkCertificateFast 10 7259 fastCert10_7259=true) ∧ (checkCertificateFast 10 7260 fastCert10_7260=true) ∧ (checkCertificateFast 10 7261 fastCert10_7261=true) ∧ (checkCertificateFast 10 7262 fastCert10_7262=true) ∧ (checkCertificateFast 10 7263 fastCert10_7263=true) ∧ (checkCertificateFast 10 7264 fastCert10_7264=true) ∧ (checkCertificateFast 10 7265 fastCert10_7265=true) ∧ (checkCertificateFast 10 7266 fastCert10_7266=true) ∧ (checkCertificateFast 10 7267 fastCert10_7267=true) ∧ (checkCertificateFast 10 7268 fastCert10_7268=true) ∧ (checkCertificateFast 10 7269 fastCert10_7269=true) ∧ (checkCertificateFast 10 7270 fastCert10_7270=true) ∧ (checkCertificateFast 10 7271 fastCert10_7271=true) ∧ (checkCertificateFast 10 7272 fastCert10_7272=true) ∧ (checkCertificateFast 10 7273 fastCert10_7273=true) ∧ (checkCertificateFast 10 7274 fastCert10_7274=true) ∧ (checkCertificateFast 10 7275 fastCert10_7275=true) ∧ (checkCertificateFast 10 7276 fastCert10_7276=true) ∧ (checkCertificateFast 10 7277 fastCert10_7277=true) ∧ (checkCertificateFast 10 7278 fastCert10_7278=true) ∧ (checkCertificateFast 10 7279 fastCert10_7279=true) ∧ (checkCertificateFast 10 7280 fastCert10_7280=true) ∧ (checkCertificateFast 10 7281 fastCert10_7281=true) ∧ (checkCertificateFast 10 7282 fastCert10_7282=true) ∧ (checkCertificateFast 10 7283 fastCert10_7283=true) ∧ (checkCertificateFast 10 7284 fastCert10_7284=true) ∧ (checkCertificateFast 10 7285 fastCert10_7285=true) ∧ (checkCertificateFast 10 7286 fastCert10_7286=true) ∧ (checkCertificateFast 10 7287 fastCert10_7287=true) ∧ (checkCertificateFast 10 7288 fastCert10_7288=true) ∧ (checkCertificateFast 10 7289 fastCert10_7289=true) ∧ (checkCertificateFast 10 7290 fastCert10_7290=true) ∧ (checkCertificateFast 10 7291 fastCert10_7291=true) ∧ (checkCertificateFast 10 7292 fastCert10_7292=true) ∧ (checkCertificateFast 10 7293 fastCert10_7293=true) ∧ (checkCertificateFast 10 7294 fastCert10_7294=true) ∧ (checkCertificateFast 10 7295 fastCert10_7295=true) ∧ (checkCertificateFast 10 7296 fastCert10_7296=true) ∧ (checkCertificateFast 10 7297 fastCert10_7297=true) ∧ (checkCertificateFast 10 7298 fastCert10_7298=true) ∧ (checkCertificateFast 10 7299 fastCert10_7299=true) ∧ (checkCertificateFast 10 7300 fastCert10_7300=true) ∧ (checkCertificateFast 10 7301 fastCert10_7301=true) ∧ (checkCertificateFast 10 7302 fastCert10_7302=true) ∧ (checkCertificateFast 10 7303 fastCert10_7303=true) ∧ (checkCertificateFast 10 7304 fastCert10_7304=true) ∧ (checkCertificateFast 10 7305 fastCert10_7305=true) ∧ (checkCertificateFast 10 7306 fastCert10_7306=true) ∧ (checkCertificateFast 10 7307 fastCert10_7307=true) ∧ (checkCertificateFast 10 7308 fastCert10_7308=true) ∧ (checkCertificateFast 10 7309 fastCert10_7309=true) ∧ (checkCertificateFast 10 7310 fastCert10_7310=true) ∧ (checkCertificateFast 10 7311 fastCert10_7311=true) ∧ (checkCertificateFast 10 7312 fastCert10_7312=true) ∧ (checkCertificateFast 10 7313 fastCert10_7313=true) ∧ (checkCertificateFast 10 7314 fastCert10_7314=true) ∧ (checkCertificateFast 10 7315 fastCert10_7315=true) ∧ (checkCertificateFast 10 7316 fastCert10_7316=true) ∧ (checkCertificateFast 10 7317 fastCert10_7317=true) ∧ (checkCertificateFast 10 7318 fastCert10_7318=true) ∧ (checkCertificateFast 10 7319 fastCert10_7319=true) ∧ (checkCertificateFast 10 7320 fastCert10_7320=true) ∧ (checkCertificateFast 10 7321 fastCert10_7321=true) ∧ (checkCertificateFast 10 7322 fastCert10_7322=true) ∧ (checkCertificateFast 10 7323 fastCert10_7323=true) ∧ (checkCertificateFast 10 7324 fastCert10_7324=true) ∧ (checkCertificateFast 10 7325 fastCert10_7325=true) ∧ (checkCertificateFast 10 7326 fastCert10_7326=true) ∧ (checkCertificateFast 10 7327 fastCert10_7327=true) ∧ (checkCertificateFast 10 7328 fastCert10_7328=true) ∧ (checkCertificateFast 10 7329 fastCert10_7329=true) ∧ (checkCertificateFast 10 7330 fastCert10_7330=true) ∧ (checkCertificateFast 10 7331 fastCert10_7331=true) ∧ (checkCertificateFast 10 7332 fastCert10_7332=true) ∧ (checkCertificateFast 10 7333 fastCert10_7333=true) ∧ (checkCertificateFast 10 7334 fastCert10_7334=true) ∧ (checkCertificateFast 10 7335 fastCert10_7335=true) ∧ (checkCertificateFast 10 7336 fastCert10_7336=true) ∧ (checkCertificateFast 10 7337 fastCert10_7337=true) ∧ (checkCertificateFast 10 7338 fastCert10_7338=true) ∧ (checkCertificateFast 10 7339 fastCert10_7339=true) ∧ (checkCertificateFast 10 7340 fastCert10_7340=true) ∧ (checkCertificateFast 10 7341 fastCert10_7341=true) ∧ (checkCertificateFast 10 7342 fastCert10_7342=true) ∧ (checkCertificateFast 10 7343 fastCert10_7343=true) ∧ (checkCertificateFast 10 7344 fastCert10_7344=true) ∧ (checkCertificateFast 10 7345 fastCert10_7345=true) ∧ (checkCertificateFast 10 7346 fastCert10_7346=true) ∧ (checkCertificateFast 10 7347 fastCert10_7347=true) ∧ (checkCertificateFast 10 7348 fastCert10_7348=true) ∧ (checkCertificateFast 10 7349 fastCert10_7349=true) ∧ (checkCertificateFast 10 7350 fastCert10_7350=true) ∧ (checkCertificateFast 10 7351 fastCert10_7351=true) ∧ (checkCertificateFast 10 7352 fastCert10_7352=true) ∧ (checkCertificateFast 10 7353 fastCert10_7353=true) ∧ (checkCertificateFast 10 7354 fastCert10_7354=true) ∧ (checkCertificateFast 10 7355 fastCert10_7355=true) ∧ (checkCertificateFast 10 7356 fastCert10_7356=true) ∧ (checkCertificateFast 10 7357 fastCert10_7357=true) ∧ (checkCertificateFast 10 7358 fastCert10_7358=true) ∧ (checkCertificateFast 10 7359 fastCert10_7359=true) ∧ (checkCertificateFast 10 7360 fastCert10_7360=true) ∧ (checkCertificateFast 10 7361 fastCert10_7361=true) ∧ (checkCertificateFast 10 7362 fastCert10_7362=true) ∧ (checkCertificateFast 10 7363 fastCert10_7363=true) ∧ (checkCertificateFast 10 7364 fastCert10_7364=true) ∧ (checkCertificateFast 10 7365 fastCert10_7365=true) ∧ (checkCertificateFast 10 7366 fastCert10_7366=true) ∧ (checkCertificateFast 10 7367 fastCert10_7367=true) ∧ (checkCertificateFast 10 7368 fastCert10_7368=true) ∧ (checkCertificateFast 10 7369 fastCert10_7369=true) ∧ (checkCertificateFast 10 7370 fastCert10_7370=true) ∧ (checkCertificateFast 10 7371 fastCert10_7371=true) ∧ (checkCertificateFast 10 7372 fastCert10_7372=true) ∧ (checkCertificateFast 10 7373 fastCert10_7373=true) ∧ (checkCertificateFast 10 7374 fastCert10_7374=true) ∧ (checkCertificateFast 10 7375 fastCert10_7375=true) ∧ (checkCertificateFast 10 7376 fastCert10_7376=true) ∧ (checkCertificateFast 10 7377 fastCert10_7377=true) ∧ (checkCertificateFast 10 7378 fastCert10_7378=true) ∧ (checkCertificateFast 10 7379 fastCert10_7379=true) ∧ (checkCertificateFast 10 7380 fastCert10_7380=true) ∧ (checkCertificateFast 10 7381 fastCert10_7381=true) ∧ (checkCertificateFast 10 7382 fastCert10_7382=true) ∧ (checkCertificateFast 10 7383 fastCert10_7383=true) ∧ (checkCertificateFast 10 7384 fastCert10_7384=true) ∧ (checkCertificateFast 10 7385 fastCert10_7385=true) ∧ (checkCertificateFast 10 7386 fastCert10_7386=true) ∧ (checkCertificateFast 10 7387 fastCert10_7387=true) ∧ (checkCertificateFast 10 7388 fastCert10_7388=true) ∧ (checkCertificateFast 10 7389 fastCert10_7389=true) ∧ (checkCertificateFast 10 7390 fastCert10_7390=true) ∧ (checkCertificateFast 10 7391 fastCert10_7391=true) ∧ (checkCertificateFast 10 7392 fastCert10_7392=true) ∧ (checkCertificateFast 10 7393 fastCert10_7393=true) ∧ (checkCertificateFast 10 7394 fastCert10_7394=true) ∧ (checkCertificateFast 10 7395 fastCert10_7395=true) ∧ (checkCertificateFast 10 7396 fastCert10_7396=true) ∧ (checkCertificateFast 10 7397 fastCert10_7397=true) ∧ (checkCertificateFast 10 7398 fastCert10_7398=true) ∧ (checkCertificateFast 10 7399 fastCert10_7399=true) ∧ (checkCertificateFast 10 7400 fastCert10_7400=true) ∧ (checkCertificateFast 10 7401 fastCert10_7401=true) ∧ (checkCertificateFast 10 7402 fastCert10_7402=true) ∧ (checkCertificateFast 10 7403 fastCert10_7403=true) ∧ (checkCertificateFast 10 7404 fastCert10_7404=true) ∧ (checkCertificateFast 10 7405 fastCert10_7405=true) ∧ (checkCertificateFast 10 7406 fastCert10_7406=true) ∧ (checkCertificateFast 10 7407 fastCert10_7407=true) ∧ (checkCertificateFast 10 7408 fastCert10_7408=true) ∧ (checkCertificateFast 10 7409 fastCert10_7409=true) ∧ (checkCertificateFast 10 7410 fastCert10_7410=true) ∧ (checkCertificateFast 10 7411 fastCert10_7411=true) ∧ (checkCertificateFast 10 7412 fastCert10_7412=true) ∧ (checkCertificateFast 10 7413 fastCert10_7413=true) ∧ (checkCertificateFast 10 7414 fastCert10_7414=true) ∧ (checkCertificateFast 10 7415 fastCert10_7415=true) ∧ (checkCertificateFast 10 7416 fastCert10_7416=true) ∧ (checkCertificateFast 10 7417 fastCert10_7417=true) ∧ (checkCertificateFast 10 7418 fastCert10_7418=true) ∧ (checkCertificateFast 10 7419 fastCert10_7419=true) ∧ (checkCertificateFast 10 7420 fastCert10_7420=true) ∧ (checkCertificateFast 10 7421 fastCert10_7421=true) ∧ (checkCertificateFast 10 7422 fastCert10_7422=true) ∧ (checkCertificateFast 10 7423 fastCert10_7423=true) ∧ (checkCertificateFast 10 7424 fastCert10_7424=true) ∧ (checkCertificateFast 10 7425 fastCert10_7425=true) ∧ (checkCertificateFast 10 7426 fastCert10_7426=true) ∧ (checkCertificateFast 10 7427 fastCert10_7427=true) ∧ (checkCertificateFast 10 7428 fastCert10_7428=true) ∧ (checkCertificateFast 10 7429 fastCert10_7429=true) ∧ (checkCertificateFast 10 7430 fastCert10_7430=true) ∧ (checkCertificateFast 10 7431 fastCert10_7431=true) ∧ (checkCertificateFast 10 7432 fastCert10_7432=true) ∧ (checkCertificateFast 10 7433 fastCert10_7433=true) ∧ (checkCertificateFast 10 7434 fastCert10_7434=true) ∧ (checkCertificateFast 10 7435 fastCert10_7435=true) ∧ (checkCertificateFast 10 7436 fastCert10_7436=true) ∧ (checkCertificateFast 10 7437 fastCert10_7437=true) ∧ (checkCertificateFast 10 7438 fastCert10_7438=true) ∧ (checkCertificateFast 10 7439 fastCert10_7439=true) ∧ (checkCertificateFast 10 7440 fastCert10_7440=true) ∧ (checkCertificateFast 10 7441 fastCert10_7441=true) ∧ (checkCertificateFast 10 7442 fastCert10_7442=true) ∧ (checkCertificateFast 10 7443 fastCert10_7443=true) ∧ (checkCertificateFast 10 7444 fastCert10_7444=true) ∧ (checkCertificateFast 10 7445 fastCert10_7445=true) ∧ (checkCertificateFast 10 7446 fastCert10_7446=true) ∧ (checkCertificateFast 10 7447 fastCert10_7447=true) ∧ (checkCertificateFast 10 7448 fastCert10_7448=true) ∧ (checkCertificateFast 10 7449 fastCert10_7449=true) ∧ (checkCertificateFast 10 7450 fastCert10_7450=true) ∧ (checkCertificateFast 10 7451 fastCert10_7451=true) ∧ (checkCertificateFast 10 7452 fastCert10_7452=true) ∧ (checkCertificateFast 10 7453 fastCert10_7453=true) ∧ (checkCertificateFast 10 7454 fastCert10_7454=true) ∧ (checkCertificateFast 10 7455 fastCert10_7455=true) ∧ (checkCertificateFast 10 7456 fastCert10_7456=true) ∧ (checkCertificateFast 10 7457 fastCert10_7457=true) ∧ (checkCertificateFast 10 7458 fastCert10_7458=true) ∧ (checkCertificateFast 10 7459 fastCert10_7459=true) ∧ (checkCertificateFast 10 7460 fastCert10_7460=true) ∧ (checkCertificateFast 10 7461 fastCert10_7461=true) ∧ (checkCertificateFast 10 7462 fastCert10_7462=true) ∧ (checkCertificateFast 10 7463 fastCert10_7463=true) ∧ (checkCertificateFast 10 7464 fastCert10_7464=true) ∧ (checkCertificateFast 10 7465 fastCert10_7465=true) ∧ (checkCertificateFast 10 7466 fastCert10_7466=true) ∧ (checkCertificateFast 10 7467 fastCert10_7467=true) ∧ (checkCertificateFast 10 7468 fastCert10_7468=true) ∧ (checkCertificateFast 10 7469 fastCert10_7469=true) ∧ (checkCertificateFast 10 7470 fastCert10_7470=true) ∧ (checkCertificateFast 10 7471 fastCert10_7471=true) ∧ (checkCertificateFast 10 7472 fastCert10_7472=true) ∧ (checkCertificateFast 10 7473 fastCert10_7473=true) ∧ (checkCertificateFast 10 7474 fastCert10_7474=true) ∧ (checkCertificateFast 10 7475 fastCert10_7475=true) ∧ (checkCertificateFast 10 7476 fastCert10_7476=true) ∧ (checkCertificateFast 10 7477 fastCert10_7477=true) ∧ (checkCertificateFast 10 7478 fastCert10_7478=true) ∧ (checkCertificateFast 10 7479 fastCert10_7479=true) ∧ (checkCertificateFast 10 7480 fastCert10_7480=true) ∧ (checkCertificateFast 10 7481 fastCert10_7481=true) ∧ (checkCertificateFast 10 7482 fastCert10_7482=true) ∧ (checkCertificateFast 10 7483 fastCert10_7483=true) ∧ (checkCertificateFast 10 7484 fastCert10_7484=true) ∧ (checkCertificateFast 10 7485 fastCert10_7485=true) ∧ (checkCertificateFast 10 7486 fastCert10_7486=true) ∧ (checkCertificateFast 10 7487 fastCert10_7487=true) ∧ (checkCertificateFast 10 7488 fastCert10_7488=true) ∧ (checkCertificateFast 10 7489 fastCert10_7489=true) ∧ (checkCertificateFast 10 7490 fastCert10_7490=true) ∧ (checkCertificateFast 10 7491 fastCert10_7491=true) ∧ (checkCertificateFast 10 7492 fastCert10_7492=true) ∧ (checkCertificateFast 10 7493 fastCert10_7493=true) ∧ (checkCertificateFast 10 7494 fastCert10_7494=true) ∧ (checkCertificateFast 10 7495 fastCert10_7495=true) ∧ (checkCertificateFast 10 7496 fastCert10_7496=true) ∧ (checkCertificateFast 10 7497 fastCert10_7497=true) ∧ (checkCertificateFast 10 7498 fastCert10_7498=true) ∧ (checkCertificateFast 10 7499 fastCert10_7499=true) ∧ (checkCertificateFast 10 7500 fastCert10_7500=true) ∧ (checkCertificateFast 10 7501 fastCert10_7501=true) ∧ (checkCertificateFast 10 7502 fastCert10_7502=true) ∧ (checkCertificateFast 10 7503 fastCert10_7503=true) ∧ (checkCertificateFast 10 7504 fastCert10_7504=true) ∧ (checkCertificateFast 10 7505 fastCert10_7505=true) ∧ (checkCertificateFast 10 7506 fastCert10_7506=true) ∧ (checkCertificateFast 10 7507 fastCert10_7507=true) ∧ (checkCertificateFast 10 7508 fastCert10_7508=true) ∧ (checkCertificateFast 10 7509 fastCert10_7509=true) ∧ (checkCertificateFast 10 7510 fastCert10_7510=true) ∧ (checkCertificateFast 10 7511 fastCert10_7511=true) ∧ (checkCertificateFast 10 7512 fastCert10_7512=true) ∧ (checkCertificateFast 10 7513 fastCert10_7513=true) ∧ (checkCertificateFast 10 7514 fastCert10_7514=true) ∧ (checkCertificateFast 10 7515 fastCert10_7515=true) ∧ (checkCertificateFast 10 7516 fastCert10_7516=true) ∧ (checkCertificateFast 10 7517 fastCert10_7517=true) ∧ (checkCertificateFast 10 7518 fastCert10_7518=true) ∧ (checkCertificateFast 10 7519 fastCert10_7519=true) ∧ (checkCertificateFast 10 7520 fastCert10_7520=true) ∧ (checkCertificateFast 10 7521 fastCert10_7521=true) ∧ (checkCertificateFast 10 7522 fastCert10_7522=true) ∧ (checkCertificateFast 10 7523 fastCert10_7523=true) ∧ (checkCertificateFast 10 7524 fastCert10_7524=true) ∧ (checkCertificateFast 10 7525 fastCert10_7525=true) ∧ (checkCertificateFast 10 7526 fastCert10_7526=true) ∧ (checkCertificateFast 10 7527 fastCert10_7527=true) ∧ (checkCertificateFast 10 7528 fastCert10_7528=true) ∧ (checkCertificateFast 10 7529 fastCert10_7529=true) ∧ (checkCertificateFast 10 7530 fastCert10_7530=true) ∧ (checkCertificateFast 10 7531 fastCert10_7531=true) ∧ (checkCertificateFast 10 7532 fastCert10_7532=true) ∧ (checkCertificateFast 10 7533 fastCert10_7533=true) ∧ (checkCertificateFast 10 7534 fastCert10_7534=true) ∧ (checkCertificateFast 10 7535 fastCert10_7535=true) ∧ (checkCertificateFast 10 7536 fastCert10_7536=true) ∧ (checkCertificateFast 10 7537 fastCert10_7537=true) ∧ (checkCertificateFast 10 7538 fastCert10_7538=true) ∧ (checkCertificateFast 10 7539 fastCert10_7539=true) ∧ (checkCertificateFast 10 7540 fastCert10_7540=true) ∧ (checkCertificateFast 10 7541 fastCert10_7541=true) ∧ (checkCertificateFast 10 7542 fastCert10_7542=true) ∧ (checkCertificateFast 10 7543 fastCert10_7543=true) ∧ (checkCertificateFast 10 7544 fastCert10_7544=true) ∧ (checkCertificateFast 10 7545 fastCert10_7545=true) ∧ (checkCertificateFast 10 7546 fastCert10_7546=true) ∧ (checkCertificateFast 10 7547 fastCert10_7547=true) ∧ (checkCertificateFast 10 7548 fastCert10_7548=true) ∧ (checkCertificateFast 10 7549 fastCert10_7549=true) ∧ (checkCertificateFast 10 7550 fastCert10_7550=true) ∧ (checkCertificateFast 10 7551 fastCert10_7551=true) ∧ (checkCertificateFast 10 7552 fastCert10_7552=true) ∧ (checkCertificateFast 10 7553 fastCert10_7553=true) ∧ (checkCertificateFast 10 7554 fastCert10_7554=true) ∧ (checkCertificateFast 10 7555 fastCert10_7555=true) ∧ (checkCertificateFast 10 7556 fastCert10_7556=true) ∧ (checkCertificateFast 10 7557 fastCert10_7557=true) ∧ (checkCertificateFast 10 7558 fastCert10_7558=true) ∧ (checkCertificateFast 10 7559 fastCert10_7559=true) ∧ (checkCertificateFast 10 7560 fastCert10_7560=true) ∧ (checkCertificateFast 10 7561 fastCert10_7561=true) ∧ (checkCertificateFast 10 7562 fastCert10_7562=true) ∧ (checkCertificateFast 10 7563 fastCert10_7563=true) ∧ (checkCertificateFast 10 7564 fastCert10_7564=true) ∧ (checkCertificateFast 10 7565 fastCert10_7565=true) ∧ (checkCertificateFast 10 7566 fastCert10_7566=true) ∧ (checkCertificateFast 10 7567 fastCert10_7567=true) ∧ (checkCertificateFast 10 7568 fastCert10_7568=true) ∧ (checkCertificateFast 10 7569 fastCert10_7569=true) ∧ (checkCertificateFast 10 7570 fastCert10_7570=true) ∧ (checkCertificateFast 10 7571 fastCert10_7571=true) ∧ (checkCertificateFast 10 7572 fastCert10_7572=true) ∧ (checkCertificateFast 10 7573 fastCert10_7573=true) ∧ (checkCertificateFast 10 7574 fastCert10_7574=true) ∧ (checkCertificateFast 10 7575 fastCert10_7575=true) ∧ (checkCertificateFast 10 7576 fastCert10_7576=true) ∧ (checkCertificateFast 10 7577 fastCert10_7577=true) ∧ (checkCertificateFast 10 7578 fastCert10_7578=true) ∧ (checkCertificateFast 10 7579 fastCert10_7579=true) ∧ (checkCertificateFast 10 7580 fastCert10_7580=true) ∧ (checkCertificateFast 10 7581 fastCert10_7581=true) ∧ (checkCertificateFast 10 7582 fastCert10_7582=true) ∧ (checkCertificateFast 10 7583 fastCert10_7583=true) ∧ (checkCertificateFast 10 7584 fastCert10_7584=true) ∧ (checkCertificateFast 10 7585 fastCert10_7585=true) ∧ (checkCertificateFast 10 7586 fastCert10_7586=true) ∧ (checkCertificateFast 10 7587 fastCert10_7587=true) ∧ (checkCertificateFast 10 7588 fastCert10_7588=true) ∧ (checkCertificateFast 10 7589 fastCert10_7589=true) ∧ (checkCertificateFast 10 7590 fastCert10_7590=true) ∧ (checkCertificateFast 10 7591 fastCert10_7591=true) ∧ (checkCertificateFast 10 7592 fastCert10_7592=true) ∧ (checkCertificateFast 10 7593 fastCert10_7593=true) ∧ (checkCertificateFast 10 7594 fastCert10_7594=true) ∧ (checkCertificateFast 10 7595 fastCert10_7595=true) ∧ (checkCertificateFast 10 7596 fastCert10_7596=true) ∧ (checkCertificateFast 10 7597 fastCert10_7597=true) ∧ (checkCertificateFast 10 7598 fastCert10_7598=true) ∧ (checkCertificateFast 10 7599 fastCert10_7599=true) ∧ (checkCertificateFast 10 7600 fastCert10_7600=true) ∧ (checkCertificateFast 10 7601 fastCert10_7601=true) ∧ (checkCertificateFast 10 7602 fastCert10_7602=true) ∧ (checkCertificateFast 10 7603 fastCert10_7603=true) ∧ (checkCertificateFast 10 7604 fastCert10_7604=true) ∧ (checkCertificateFast 10 7605 fastCert10_7605=true) ∧ (checkCertificateFast 10 7606 fastCert10_7606=true) ∧ (checkCertificateFast 10 7607 fastCert10_7607=true) ∧ (checkCertificateFast 10 7608 fastCert10_7608=true) ∧ (checkCertificateFast 10 7609 fastCert10_7609=true) ∧ (checkCertificateFast 10 7610 fastCert10_7610=true) ∧ (checkCertificateFast 10 7611 fastCert10_7611=true) ∧ (checkCertificateFast 10 7612 fastCert10_7612=true) ∧ (checkCertificateFast 10 7613 fastCert10_7613=true) ∧ (checkCertificateFast 10 7614 fastCert10_7614=true) ∧ (checkCertificateFast 10 7615 fastCert10_7615=true) ∧ (checkCertificateFast 10 7616 fastCert10_7616=true) ∧ (checkCertificateFast 10 7617 fastCert10_7617=true) ∧ (checkCertificateFast 10 7618 fastCert10_7618=true) ∧ (checkCertificateFast 10 7619 fastCert10_7619=true) ∧ (checkCertificateFast 10 7620 fastCert10_7620=true) ∧ (checkCertificateFast 10 7621 fastCert10_7621=true) ∧ (checkCertificateFast 10 7622 fastCert10_7622=true) ∧ (checkCertificateFast 10 7623 fastCert10_7623=true) ∧ (checkCertificateFast 10 7624 fastCert10_7624=true) ∧ (checkCertificateFast 10 7625 fastCert10_7625=true) ∧ (checkCertificateFast 10 7626 fastCert10_7626=true) ∧ (checkCertificateFast 10 7627 fastCert10_7627=true) ∧ (checkCertificateFast 10 7628 fastCert10_7628=true) ∧ (checkCertificateFast 10 7629 fastCert10_7629=true) ∧ (checkCertificateFast 10 7630 fastCert10_7630=true) ∧ (checkCertificateFast 10 7631 fastCert10_7631=true) ∧ (checkCertificateFast 10 7632 fastCert10_7632=true) ∧ (checkCertificateFast 10 7633 fastCert10_7633=true) ∧ (checkCertificateFast 10 7634 fastCert10_7634=true) ∧ (checkCertificateFast 10 7635 fastCert10_7635=true) ∧ (checkCertificateFast 10 7636 fastCert10_7636=true) ∧ (checkCertificateFast 10 7637 fastCert10_7637=true) ∧ (checkCertificateFast 10 7638 fastCert10_7638=true) ∧ (checkCertificateFast 10 7639 fastCert10_7639=true) ∧ (checkCertificateFast 10 7640 fastCert10_7640=true) ∧ (checkCertificateFast 10 7641 fastCert10_7641=true) ∧ (checkCertificateFast 10 7642 fastCert10_7642=true) ∧ (checkCertificateFast 10 7643 fastCert10_7643=true) ∧ (checkCertificateFast 10 7644 fastCert10_7644=true) ∧ (checkCertificateFast 10 7645 fastCert10_7645=true) ∧ (checkCertificateFast 10 7646 fastCert10_7646=true) ∧ (checkCertificateFast 10 7647 fastCert10_7647=true) ∧ (checkCertificateFast 10 7648 fastCert10_7648=true) ∧ (checkCertificateFast 10 7649 fastCert10_7649=true) ∧ (checkCertificateFast 10 7650 fastCert10_7650=true) ∧ (checkCertificateFast 10 7651 fastCert10_7651=true) ∧ (checkCertificateFast 10 7652 fastCert10_7652=true) ∧ (checkCertificateFast 10 7653 fastCert10_7653=true) ∧ (checkCertificateFast 10 7654 fastCert10_7654=true) ∧ (checkCertificateFast 10 7655 fastCert10_7655=true) ∧ (checkCertificateFast 10 7656 fastCert10_7656=true) ∧ (checkCertificateFast 10 7657 fastCert10_7657=true) ∧ (checkCertificateFast 10 7658 fastCert10_7658=true) ∧ (checkCertificateFast 10 7659 fastCert10_7659=true) ∧ (checkCertificateFast 10 7660 fastCert10_7660=true) ∧ (checkCertificateFast 10 7661 fastCert10_7661=true) ∧ (checkCertificateFast 10 7662 fastCert10_7662=true) ∧ (checkCertificateFast 10 7663 fastCert10_7663=true) ∧ (checkCertificateFast 10 7664 fastCert10_7664=true) ∧ (checkCertificateFast 10 7665 fastCert10_7665=true) ∧ (checkCertificateFast 10 7666 fastCert10_7666=true) ∧ (checkCertificateFast 10 7667 fastCert10_7667=true) ∧ (checkCertificateFast 10 7668 fastCert10_7668=true) ∧ (checkCertificateFast 10 7669 fastCert10_7669=true) ∧ (checkCertificateFast 10 7670 fastCert10_7670=true) ∧ (checkCertificateFast 10 7671 fastCert10_7671=true) ∧ (checkCertificateFast 10 7672 fastCert10_7672=true) ∧ (checkCertificateFast 10 7673 fastCert10_7673=true) ∧ (checkCertificateFast 10 7674 fastCert10_7674=true) ∧ (checkCertificateFast 10 7675 fastCert10_7675=true) ∧ (checkCertificateFast 10 7676 fastCert10_7676=true) ∧ (checkCertificateFast 10 7677 fastCert10_7677=true) ∧ (checkCertificateFast 10 7678 fastCert10_7678=true) ∧ (checkCertificateFast 10 7679 fastCert10_7679=true) ∧ (checkCertificateFast 10 7680 fastCert10_7680=true) ∧ (checkCertificateFast 10 7681 fastCert10_7681=true) ∧ (checkCertificateFast 10 7682 fastCert10_7682=true) ∧ (checkCertificateFast 10 7683 fastCert10_7683=true) ∧ (checkCertificateFast 10 7684 fastCert10_7684=true) ∧ (checkCertificateFast 10 7685 fastCert10_7685=true) ∧ (checkCertificateFast 10 7686 fastCert10_7686=true) ∧ (checkCertificateFast 10 7687 fastCert10_7687=true) ∧ (checkCertificateFast 10 7688 fastCert10_7688=true) ∧ (checkCertificateFast 10 7689 fastCert10_7689=true) ∧ (checkCertificateFast 10 7690 fastCert10_7690=true) ∧ (checkCertificateFast 10 7691 fastCert10_7691=true) ∧ (checkCertificateFast 10 7692 fastCert10_7692=true) ∧ (checkCertificateFast 10 7693 fastCert10_7693=true) ∧ (checkCertificateFast 10 7694 fastCert10_7694=true) ∧ (checkCertificateFast 10 7695 fastCert10_7695=true) ∧ (checkCertificateFast 10 7696 fastCert10_7696=true) ∧ (checkCertificateFast 10 7697 fastCert10_7697=true) ∧ (checkCertificateFast 10 7698 fastCert10_7698=true) ∧ (checkCertificateFast 10 7699 fastCert10_7699=true) ∧ (checkCertificateFast 10 7700 fastCert10_7700=true) ∧ (checkCertificateFast 10 7701 fastCert10_7701=true) ∧ (checkCertificateFast 10 7702 fastCert10_7702=true) ∧ (checkCertificateFast 10 7703 fastCert10_7703=true) ∧ (checkCertificateFast 10 7704 fastCert10_7704=true) ∧ (checkCertificateFast 10 7705 fastCert10_7705=true) ∧ (checkCertificateFast 10 7706 fastCert10_7706=true) ∧ (checkCertificateFast 10 7707 fastCert10_7707=true) ∧ (checkCertificateFast 10 7708 fastCert10_7708=true) ∧ (checkCertificateFast 10 7709 fastCert10_7709=true) ∧ (checkCertificateFast 10 7710 fastCert10_7710=true) ∧ (checkCertificateFast 10 7711 fastCert10_7711=true) ∧ (checkCertificateFast 10 7712 fastCert10_7712=true) ∧ (checkCertificateFast 10 7713 fastCert10_7713=true) ∧ (checkCertificateFast 10 7714 fastCert10_7714=true) ∧ (checkCertificateFast 10 7715 fastCert10_7715=true) ∧ (checkCertificateFast 10 7716 fastCert10_7716=true) ∧ (checkCertificateFast 10 7717 fastCert10_7717=true) ∧ (checkCertificateFast 10 7718 fastCert10_7718=true) ∧ (checkCertificateFast 10 7719 fastCert10_7719=true) ∧ (checkCertificateFast 10 7720 fastCert10_7720=true) ∧ (checkCertificateFast 10 7721 fastCert10_7721=true) ∧ (checkCertificateFast 10 7722 fastCert10_7722=true) ∧ (checkCertificateFast 10 7723 fastCert10_7723=true) ∧ (checkCertificateFast 10 7724 fastCert10_7724=true) ∧ (checkCertificateFast 10 7725 fastCert10_7725=true) ∧ (checkCertificateFast 10 7726 fastCert10_7726=true) ∧ (checkCertificateFast 10 7727 fastCert10_7727=true) ∧ (checkCertificateFast 10 7728 fastCert10_7728=true) ∧ (checkCertificateFast 10 7729 fastCert10_7729=true) ∧ (checkCertificateFast 10 7730 fastCert10_7730=true) ∧ (checkCertificateFast 10 7731 fastCert10_7731=true) ∧ (checkCertificateFast 10 7732 fastCert10_7732=true) ∧ (checkCertificateFast 10 7733 fastCert10_7733=true) ∧ (checkCertificateFast 10 7734 fastCert10_7734=true) ∧ (checkCertificateFast 10 7735 fastCert10_7735=true) ∧ (checkCertificateFast 10 7736 fastCert10_7736=true) ∧ (checkCertificateFast 10 7737 fastCert10_7737=true) ∧ (checkCertificateFast 10 7738 fastCert10_7738=true) ∧ (checkCertificateFast 10 7739 fastCert10_7739=true) ∧ (checkCertificateFast 10 7740 fastCert10_7740=true) ∧ (checkCertificateFast 10 7741 fastCert10_7741=true) ∧ (checkCertificateFast 10 7742 fastCert10_7742=true) ∧ (checkCertificateFast 10 7743 fastCert10_7743=true) ∧ (checkCertificateFast 10 7744 fastCert10_7744=true) ∧ (checkCertificateFast 10 7745 fastCert10_7745=true) ∧ (checkCertificateFast 10 7746 fastCert10_7746=true) ∧ (checkCertificateFast 10 7747 fastCert10_7747=true) ∧ (checkCertificateFast 10 7748 fastCert10_7748=true) ∧ (checkCertificateFast 10 7749 fastCert10_7749=true) ∧ (checkCertificateFast 10 7750 fastCert10_7750=true) ∧ (checkCertificateFast 10 7751 fastCert10_7751=true) ∧ (checkCertificateFast 10 7752 fastCert10_7752=true) ∧ (checkCertificateFast 10 7753 fastCert10_7753=true) ∧ (checkCertificateFast 10 7754 fastCert10_7754=true) ∧ (checkCertificateFast 10 7755 fastCert10_7755=true) ∧ (checkCertificateFast 10 7756 fastCert10_7756=true) ∧ (checkCertificateFast 10 7757 fastCert10_7757=true) ∧ (checkCertificateFast 10 7758 fastCert10_7758=true) ∧ (checkCertificateFast 10 7759 fastCert10_7759=true) ∧ (checkCertificateFast 10 7760 fastCert10_7760=true) ∧ (checkCertificateFast 10 7761 fastCert10_7761=true) ∧ (checkCertificateFast 10 7762 fastCert10_7762=true) ∧ (checkCertificateFast 10 7763 fastCert10_7763=true) ∧ (checkCertificateFast 10 7764 fastCert10_7764=true) ∧ (checkCertificateFast 10 7765 fastCert10_7765=true) ∧ (checkCertificateFast 10 7766 fastCert10_7766=true) ∧ (checkCertificateFast 10 7767 fastCert10_7767=true) ∧ (checkCertificateFast 10 7768 fastCert10_7768=true) ∧ (checkCertificateFast 10 7769 fastCert10_7769=true) ∧ (checkCertificateFast 10 7770 fastCert10_7770=true) ∧ (checkCertificateFast 10 7771 fastCert10_7771=true) ∧ (checkCertificateFast 10 7772 fastCert10_7772=true) ∧ (checkCertificateFast 10 7773 fastCert10_7773=true) ∧ (checkCertificateFast 10 7774 fastCert10_7774=true) ∧ (checkCertificateFast 10 7775 fastCert10_7775=true) ∧ (checkCertificateFast 10 7776 fastCert10_7776=true) ∧ (checkCertificateFast 10 7777 fastCert10_7777=true) ∧ (checkCertificateFast 10 7778 fastCert10_7778=true) ∧ (checkCertificateFast 10 7779 fastCert10_7779=true) ∧ (checkCertificateFast 10 7780 fastCert10_7780=true) ∧ (checkCertificateFast 10 7781 fastCert10_7781=true) ∧ (checkCertificateFast 10 7782 fastCert10_7782=true) ∧ (checkCertificateFast 10 7783 fastCert10_7783=true) ∧ (checkCertificateFast 10 7784 fastCert10_7784=true) ∧ (checkCertificateFast 10 7785 fastCert10_7785=true) ∧ (checkCertificateFast 10 7786 fastCert10_7786=true) ∧ (checkCertificateFast 10 7787 fastCert10_7787=true) ∧ (checkCertificateFast 10 7788 fastCert10_7788=true) ∧ (checkCertificateFast 10 7789 fastCert10_7789=true) ∧ (checkCertificateFast 10 7790 fastCert10_7790=true) ∧ (checkCertificateFast 10 7791 fastCert10_7791=true) ∧ (checkCertificateFast 10 7792 fastCert10_7792=true) ∧ (checkCertificateFast 10 7793 fastCert10_7793=true) ∧ (checkCertificateFast 10 7794 fastCert10_7794=true) ∧ (checkCertificateFast 10 7795 fastCert10_7795=true) ∧ (checkCertificateFast 10 7796 fastCert10_7796=true) ∧ (checkCertificateFast 10 7797 fastCert10_7797=true) ∧ (checkCertificateFast 10 7798 fastCert10_7798=true) ∧ (checkCertificateFast 10 7799 fastCert10_7799=true) ∧ (checkCertificateFast 10 7800 fastCert10_7800=true) ∧ (checkCertificateFast 10 7801 fastCert10_7801=true) ∧ (checkCertificateFast 10 7802 fastCert10_7802=true) ∧ (checkCertificateFast 10 7803 fastCert10_7803=true) ∧ (checkCertificateFast 10 7804 fastCert10_7804=true) ∧ (checkCertificateFast 10 7805 fastCert10_7805=true) ∧ (checkCertificateFast 10 7806 fastCert10_7806=true) ∧ (checkCertificateFast 10 7807 fastCert10_7807=true) ∧ (checkCertificateFast 10 7808 fastCert10_7808=true) ∧ (checkCertificateFast 10 7809 fastCert10_7809=true) ∧ (checkCertificateFast 10 7810 fastCert10_7810=true) ∧ (checkCertificateFast 10 7811 fastCert10_7811=true) ∧ (checkCertificateFast 10 7812 fastCert10_7812=true) ∧ (checkCertificateFast 10 7813 fastCert10_7813=true) ∧ (checkCertificateFast 10 7814 fastCert10_7814=true) ∧ (checkCertificateFast 10 7815 fastCert10_7815=true) ∧ (checkCertificateFast 10 7816 fastCert10_7816=true) ∧ (checkCertificateFast 10 7817 fastCert10_7817=true) ∧ (checkCertificateFast 10 7818 fastCert10_7818=true) ∧ (checkCertificateFast 10 7819 fastCert10_7819=true) ∧ (checkCertificateFast 10 7820 fastCert10_7820=true) ∧ (checkCertificateFast 10 7821 fastCert10_7821=true) ∧ (checkCertificateFast 10 7822 fastCert10_7822=true) ∧ (checkCertificateFast 10 7823 fastCert10_7823=true) ∧ (checkCertificateFast 10 7824 fastCert10_7824=true) ∧ (checkCertificateFast 10 7825 fastCert10_7825=true) ∧ (checkCertificateFast 10 7826 fastCert10_7826=true) ∧ (checkCertificateFast 10 7827 fastCert10_7827=true) ∧ (checkCertificateFast 10 7828 fastCert10_7828=true) ∧ (checkCertificateFast 10 7829 fastCert10_7829=true) ∧ (checkCertificateFast 10 7830 fastCert10_7830=true) ∧ (checkCertificateFast 10 7831 fastCert10_7831=true) ∧ (checkCertificateFast 10 7832 fastCert10_7832=true) ∧ (checkCertificateFast 10 7833 fastCert10_7833=true) ∧ (checkCertificateFast 10 7834 fastCert10_7834=true) ∧ (checkCertificateFast 10 7835 fastCert10_7835=true) ∧ (checkCertificateFast 10 7836 fastCert10_7836=true) ∧ (checkCertificateFast 10 7837 fastCert10_7837=true) ∧ (checkCertificateFast 10 7838 fastCert10_7838=true) ∧ (checkCertificateFast 10 7839 fastCert10_7839=true) ∧ (checkCertificateFast 10 7840 fastCert10_7840=true) ∧ (checkCertificateFast 10 7841 fastCert10_7841=true) ∧ (checkCertificateFast 10 7842 fastCert10_7842=true) ∧ (checkCertificateFast 10 7843 fastCert10_7843=true) ∧ (checkCertificateFast 10 7844 fastCert10_7844=true) ∧ (checkCertificateFast 10 7845 fastCert10_7845=true) ∧ (checkCertificateFast 10 7846 fastCert10_7846=true) ∧ (checkCertificateFast 10 7847 fastCert10_7847=true) ∧ (checkCertificateFast 10 7848 fastCert10_7848=true) ∧ (checkCertificateFast 10 7849 fastCert10_7849=true) ∧ (checkCertificateFast 10 7850 fastCert10_7850=true) ∧ (checkCertificateFast 10 7851 fastCert10_7851=true) ∧ (checkCertificateFast 10 7852 fastCert10_7852=true) ∧ (checkCertificateFast 10 7853 fastCert10_7853=true) ∧ (checkCertificateFast 10 7854 fastCert10_7854=true) ∧ (checkCertificateFast 10 7855 fastCert10_7855=true) ∧ (checkCertificateFast 10 7856 fastCert10_7856=true) ∧ (checkCertificateFast 10 7857 fastCert10_7857=true) ∧ (checkCertificateFast 10 7858 fastCert10_7858=true) ∧ (checkCertificateFast 10 7859 fastCert10_7859=true) ∧ (checkCertificateFast 10 7860 fastCert10_7860=true) ∧ (checkCertificateFast 10 7861 fastCert10_7861=true) ∧ (checkCertificateFast 10 7862 fastCert10_7862=true) ∧ (checkCertificateFast 10 7863 fastCert10_7863=true) ∧ (checkCertificateFast 10 7864 fastCert10_7864=true) ∧ (checkCertificateFast 10 7865 fastCert10_7865=true) ∧ (checkCertificateFast 10 7866 fastCert10_7866=true) ∧ (checkCertificateFast 10 7867 fastCert10_7867=true) ∧ (checkCertificateFast 10 7868 fastCert10_7868=true) ∧ (checkCertificateFast 10 7869 fastCert10_7869=true) ∧ (checkCertificateFast 10 7870 fastCert10_7870=true) ∧ (checkCertificateFast 10 7871 fastCert10_7871=true) ∧ (checkCertificateFast 10 7872 fastCert10_7872=true) ∧ (checkCertificateFast 10 7873 fastCert10_7873=true) ∧ (checkCertificateFast 10 7874 fastCert10_7874=true) ∧ (checkCertificateFast 10 7875 fastCert10_7875=true) ∧ (checkCertificateFast 10 7876 fastCert10_7876=true) ∧ (checkCertificateFast 10 7877 fastCert10_7877=true) ∧ (checkCertificateFast 10 7878 fastCert10_7878=true) ∧ (checkCertificateFast 10 7879 fastCert10_7879=true) ∧ (checkCertificateFast 10 7880 fastCert10_7880=true) ∧ (checkCertificateFast 10 7881 fastCert10_7881=true) ∧ (checkCertificateFast 10 7882 fastCert10_7882=true) ∧ (checkCertificateFast 10 7883 fastCert10_7883=true) ∧ (checkCertificateFast 10 7884 fastCert10_7884=true) ∧ (checkCertificateFast 10 7885 fastCert10_7885=true) ∧ (checkCertificateFast 10 7886 fastCert10_7886=true) ∧ (checkCertificateFast 10 7887 fastCert10_7887=true) ∧ (checkCertificateFast 10 7888 fastCert10_7888=true) ∧ (checkCertificateFast 10 7889 fastCert10_7889=true) ∧ (checkCertificateFast 10 7890 fastCert10_7890=true) ∧ (checkCertificateFast 10 7891 fastCert10_7891=true) ∧ (checkCertificateFast 10 7892 fastCert10_7892=true) ∧ (checkCertificateFast 10 7893 fastCert10_7893=true) ∧ (checkCertificateFast 10 7894 fastCert10_7894=true) ∧ (checkCertificateFast 10 7895 fastCert10_7895=true) ∧ (checkCertificateFast 10 7896 fastCert10_7896=true) ∧ (checkCertificateFast 10 7897 fastCert10_7897=true) ∧ (checkCertificateFast 10 7898 fastCert10_7898=true) ∧ (checkCertificateFast 10 7899 fastCert10_7899=true) ∧ (checkCertificateFast 10 7900 fastCert10_7900=true) ∧ (checkCertificateFast 10 7901 fastCert10_7901=true) ∧ (checkCertificateFast 10 7902 fastCert10_7902=true) ∧ (checkCertificateFast 10 7903 fastCert10_7903=true) ∧ (checkCertificateFast 10 7904 fastCert10_7904=true) ∧ (checkCertificateFast 10 7905 fastCert10_7905=true) ∧ (checkCertificateFast 10 7906 fastCert10_7906=true) ∧ (checkCertificateFast 10 7907 fastCert10_7907=true) ∧ (checkCertificateFast 10 7908 fastCert10_7908=true) ∧ (checkCertificateFast 10 7909 fastCert10_7909=true) ∧ (checkCertificateFast 10 7910 fastCert10_7910=true) ∧ (checkCertificateFast 10 7911 fastCert10_7911=true) ∧ (checkCertificateFast 10 7912 fastCert10_7912=true) ∧ (checkCertificateFast 10 7913 fastCert10_7913=true) ∧ (checkCertificateFast 10 7914 fastCert10_7914=true) ∧ (checkCertificateFast 10 7915 fastCert10_7915=true) ∧ (checkCertificateFast 10 7916 fastCert10_7916=true) ∧ (checkCertificateFast 10 7917 fastCert10_7917=true) ∧ (checkCertificateFast 10 7918 fastCert10_7918=true) ∧ (checkCertificateFast 10 7919 fastCert10_7919=true) ∧ (checkCertificateFast 10 7920 fastCert10_7920=true) ∧ (checkCertificateFast 10 7921 fastCert10_7921=true) ∧ (checkCertificateFast 10 7922 fastCert10_7922=true) ∧ (checkCertificateFast 10 7923 fastCert10_7923=true) ∧ (checkCertificateFast 10 7924 fastCert10_7924=true) ∧ (checkCertificateFast 10 7925 fastCert10_7925=true) ∧ (checkCertificateFast 10 7926 fastCert10_7926=true) ∧ (checkCertificateFast 10 7927 fastCert10_7927=true) ∧ (checkCertificateFast 10 7928 fastCert10_7928=true) ∧ (checkCertificateFast 10 7929 fastCert10_7929=true) ∧ (checkCertificateFast 10 7930 fastCert10_7930=true) ∧ (checkCertificateFast 10 7931 fastCert10_7931=true) ∧ (checkCertificateFast 10 7932 fastCert10_7932=true) ∧ (checkCertificateFast 10 7933 fastCert10_7933=true) ∧ (checkCertificateFast 10 7934 fastCert10_7934=true) ∧ (checkCertificateFast 10 7935 fastCert10_7935=true) ∧ (checkCertificateFast 10 7936 fastCert10_7936=true) ∧ (checkCertificateFast 10 7937 fastCert10_7937=true) ∧ (checkCertificateFast 10 7938 fastCert10_7938=true) ∧ (checkCertificateFast 10 7939 fastCert10_7939=true) ∧ (checkCertificateFast 10 7940 fastCert10_7940=true) ∧ (checkCertificateFast 10 7941 fastCert10_7941=true) ∧ (checkCertificateFast 10 7942 fastCert10_7942=true) ∧ (checkCertificateFast 10 7943 fastCert10_7943=true) ∧ (checkCertificateFast 10 7944 fastCert10_7944=true) ∧ (checkCertificateFast 10 7945 fastCert10_7945=true) ∧ (checkCertificateFast 10 7946 fastCert10_7946=true) ∧ (checkCertificateFast 10 7947 fastCert10_7947=true) ∧ (checkCertificateFast 10 7948 fastCert10_7948=true) ∧ (checkCertificateFast 10 7949 fastCert10_7949=true) ∧ (checkCertificateFast 10 7950 fastCert10_7950=true) ∧ (checkCertificateFast 10 7951 fastCert10_7951=true) ∧ (checkCertificateFast 10 7952 fastCert10_7952=true) ∧ (checkCertificateFast 10 7953 fastCert10_7953=true) ∧ (checkCertificateFast 10 7954 fastCert10_7954=true) ∧ (checkCertificateFast 10 7955 fastCert10_7955=true) ∧ (checkCertificateFast 10 7956 fastCert10_7956=true) ∧ (checkCertificateFast 10 7957 fastCert10_7957=true) ∧ (checkCertificateFast 10 7958 fastCert10_7958=true) ∧ (checkCertificateFast 10 7959 fastCert10_7959=true) ∧ (checkCertificateFast 10 7960 fastCert10_7960=true) ∧ (checkCertificateFast 10 7961 fastCert10_7961=true) ∧ (checkCertificateFast 10 7962 fastCert10_7962=true) ∧ (checkCertificateFast 10 7963 fastCert10_7963=true) ∧ (checkCertificateFast 10 7964 fastCert10_7964=true) ∧ (checkCertificateFast 10 7965 fastCert10_7965=true) ∧ (checkCertificateFast 10 7966 fastCert10_7966=true) ∧ (checkCertificateFast 10 7967 fastCert10_7967=true) ∧ (checkCertificateFast 10 7968 fastCert10_7968=true) ∧ (checkCertificateFast 10 7969 fastCert10_7969=true) ∧ (checkCertificateFast 10 7970 fastCert10_7970=true) ∧ (checkCertificateFast 10 7971 fastCert10_7971=true) ∧ (checkCertificateFast 10 7972 fastCert10_7972=true) ∧ (checkCertificateFast 10 7973 fastCert10_7973=true) ∧ (checkCertificateFast 10 7974 fastCert10_7974=true) ∧ (checkCertificateFast 10 7975 fastCert10_7975=true) ∧ (checkCertificateFast 10 7976 fastCert10_7976=true) ∧ (checkCertificateFast 10 7977 fastCert10_7977=true) ∧ (checkCertificateFast 10 7978 fastCert10_7978=true) ∧ (checkCertificateFast 10 7979 fastCert10_7979=true) ∧ (checkCertificateFast 10 7980 fastCert10_7980=true) ∧ (checkCertificateFast 10 7981 fastCert10_7981=true) ∧ (checkCertificateFast 10 7982 fastCert10_7982=true) ∧ (checkCertificateFast 10 7983 fastCert10_7983=true) ∧ (checkCertificateFast 10 7984 fastCert10_7984=true) ∧ (checkCertificateFast 10 7985 fastCert10_7985=true) ∧ (checkCertificateFast 10 7986 fastCert10_7986=true) ∧ (checkCertificateFast 10 7987 fastCert10_7987=true) ∧ (checkCertificateFast 10 7988 fastCert10_7988=true) ∧ (checkCertificateFast 10 7989 fastCert10_7989=true) ∧ (checkCertificateFast 10 7990 fastCert10_7990=true) ∧ (checkCertificateFast 10 7991 fastCert10_7991=true) ∧ (checkCertificateFast 10 7992 fastCert10_7992=true) ∧ (checkCertificateFast 10 7993 fastCert10_7993=true) ∧ (checkCertificateFast 10 7994 fastCert10_7994=true) ∧ (checkCertificateFast 10 7995 fastCert10_7995=true) ∧ (checkCertificateFast 10 7996 fastCert10_7996=true) ∧ (checkCertificateFast 10 7997 fastCert10_7997=true) ∧ (checkCertificateFast 10 7998 fastCert10_7998=true) ∧ (checkCertificateFast 10 7999 fastCert10_7999=true) :=
  ⟨fastCase10_7000,fastCase10_7001,fastCase10_7002,fastCase10_7003,fastCase10_7004,fastCase10_7005,fastCase10_7006,fastCase10_7007,fastCase10_7008,fastCase10_7009,fastCase10_7010,fastCase10_7011,fastCase10_7012,fastCase10_7013,fastCase10_7014,fastCase10_7015,fastCase10_7016,fastCase10_7017,fastCase10_7018,fastCase10_7019,fastCase10_7020,fastCase10_7021,fastCase10_7022,fastCase10_7023,fastCase10_7024,fastCase10_7025,fastCase10_7026,fastCase10_7027,fastCase10_7028,fastCase10_7029,fastCase10_7030,fastCase10_7031,fastCase10_7032,fastCase10_7033,fastCase10_7034,fastCase10_7035,fastCase10_7036,fastCase10_7037,fastCase10_7038,fastCase10_7039,fastCase10_7040,fastCase10_7041,fastCase10_7042,fastCase10_7043,fastCase10_7044,fastCase10_7045,fastCase10_7046,fastCase10_7047,fastCase10_7048,fastCase10_7049,fastCase10_7050,fastCase10_7051,fastCase10_7052,fastCase10_7053,fastCase10_7054,fastCase10_7055,fastCase10_7056,fastCase10_7057,fastCase10_7058,fastCase10_7059,fastCase10_7060,fastCase10_7061,fastCase10_7062,fastCase10_7063,fastCase10_7064,fastCase10_7065,fastCase10_7066,fastCase10_7067,fastCase10_7068,fastCase10_7069,fastCase10_7070,fastCase10_7071,fastCase10_7072,fastCase10_7073,fastCase10_7074,fastCase10_7075,fastCase10_7076,fastCase10_7077,fastCase10_7078,fastCase10_7079,fastCase10_7080,fastCase10_7081,fastCase10_7082,fastCase10_7083,fastCase10_7084,fastCase10_7085,fastCase10_7086,fastCase10_7087,fastCase10_7088,fastCase10_7089,fastCase10_7090,fastCase10_7091,fastCase10_7092,fastCase10_7093,fastCase10_7094,fastCase10_7095,fastCase10_7096,fastCase10_7097,fastCase10_7098,fastCase10_7099,fastCase10_7100,fastCase10_7101,fastCase10_7102,fastCase10_7103,fastCase10_7104,fastCase10_7105,fastCase10_7106,fastCase10_7107,fastCase10_7108,fastCase10_7109,fastCase10_7110,fastCase10_7111,fastCase10_7112,fastCase10_7113,fastCase10_7114,fastCase10_7115,fastCase10_7116,fastCase10_7117,fastCase10_7118,fastCase10_7119,fastCase10_7120,fastCase10_7121,fastCase10_7122,fastCase10_7123,fastCase10_7124,fastCase10_7125,fastCase10_7126,fastCase10_7127,fastCase10_7128,fastCase10_7129,fastCase10_7130,fastCase10_7131,fastCase10_7132,fastCase10_7133,fastCase10_7134,fastCase10_7135,fastCase10_7136,fastCase10_7137,fastCase10_7138,fastCase10_7139,fastCase10_7140,fastCase10_7141,fastCase10_7142,fastCase10_7143,fastCase10_7144,fastCase10_7145,fastCase10_7146,fastCase10_7147,fastCase10_7148,fastCase10_7149,fastCase10_7150,fastCase10_7151,fastCase10_7152,fastCase10_7153,fastCase10_7154,fastCase10_7155,fastCase10_7156,fastCase10_7157,fastCase10_7158,fastCase10_7159,fastCase10_7160,fastCase10_7161,fastCase10_7162,fastCase10_7163,fastCase10_7164,fastCase10_7165,fastCase10_7166,fastCase10_7167,fastCase10_7168,fastCase10_7169,fastCase10_7170,fastCase10_7171,fastCase10_7172,fastCase10_7173,fastCase10_7174,fastCase10_7175,fastCase10_7176,fastCase10_7177,fastCase10_7178,fastCase10_7179,fastCase10_7180,fastCase10_7181,fastCase10_7182,fastCase10_7183,fastCase10_7184,fastCase10_7185,fastCase10_7186,fastCase10_7187,fastCase10_7188,fastCase10_7189,fastCase10_7190,fastCase10_7191,fastCase10_7192,fastCase10_7193,fastCase10_7194,fastCase10_7195,fastCase10_7196,fastCase10_7197,fastCase10_7198,fastCase10_7199,fastCase10_7200,fastCase10_7201,fastCase10_7202,fastCase10_7203,fastCase10_7204,fastCase10_7205,fastCase10_7206,fastCase10_7207,fastCase10_7208,fastCase10_7209,fastCase10_7210,fastCase10_7211,fastCase10_7212,fastCase10_7213,fastCase10_7214,fastCase10_7215,fastCase10_7216,fastCase10_7217,fastCase10_7218,fastCase10_7219,fastCase10_7220,fastCase10_7221,fastCase10_7222,fastCase10_7223,fastCase10_7224,fastCase10_7225,fastCase10_7226,fastCase10_7227,fastCase10_7228,fastCase10_7229,fastCase10_7230,fastCase10_7231,fastCase10_7232,fastCase10_7233,fastCase10_7234,fastCase10_7235,fastCase10_7236,fastCase10_7237,fastCase10_7238,fastCase10_7239,fastCase10_7240,fastCase10_7241,fastCase10_7242,fastCase10_7243,fastCase10_7244,fastCase10_7245,fastCase10_7246,fastCase10_7247,fastCase10_7248,fastCase10_7249,fastCase10_7250,fastCase10_7251,fastCase10_7252,fastCase10_7253,fastCase10_7254,fastCase10_7255,fastCase10_7256,fastCase10_7257,fastCase10_7258,fastCase10_7259,fastCase10_7260,fastCase10_7261,fastCase10_7262,fastCase10_7263,fastCase10_7264,fastCase10_7265,fastCase10_7266,fastCase10_7267,fastCase10_7268,fastCase10_7269,fastCase10_7270,fastCase10_7271,fastCase10_7272,fastCase10_7273,fastCase10_7274,fastCase10_7275,fastCase10_7276,fastCase10_7277,fastCase10_7278,fastCase10_7279,fastCase10_7280,fastCase10_7281,fastCase10_7282,fastCase10_7283,fastCase10_7284,fastCase10_7285,fastCase10_7286,fastCase10_7287,fastCase10_7288,fastCase10_7289,fastCase10_7290,fastCase10_7291,fastCase10_7292,fastCase10_7293,fastCase10_7294,fastCase10_7295,fastCase10_7296,fastCase10_7297,fastCase10_7298,fastCase10_7299,fastCase10_7300,fastCase10_7301,fastCase10_7302,fastCase10_7303,fastCase10_7304,fastCase10_7305,fastCase10_7306,fastCase10_7307,fastCase10_7308,fastCase10_7309,fastCase10_7310,fastCase10_7311,fastCase10_7312,fastCase10_7313,fastCase10_7314,fastCase10_7315,fastCase10_7316,fastCase10_7317,fastCase10_7318,fastCase10_7319,fastCase10_7320,fastCase10_7321,fastCase10_7322,fastCase10_7323,fastCase10_7324,fastCase10_7325,fastCase10_7326,fastCase10_7327,fastCase10_7328,fastCase10_7329,fastCase10_7330,fastCase10_7331,fastCase10_7332,fastCase10_7333,fastCase10_7334,fastCase10_7335,fastCase10_7336,fastCase10_7337,fastCase10_7338,fastCase10_7339,fastCase10_7340,fastCase10_7341,fastCase10_7342,fastCase10_7343,fastCase10_7344,fastCase10_7345,fastCase10_7346,fastCase10_7347,fastCase10_7348,fastCase10_7349,fastCase10_7350,fastCase10_7351,fastCase10_7352,fastCase10_7353,fastCase10_7354,fastCase10_7355,fastCase10_7356,fastCase10_7357,fastCase10_7358,fastCase10_7359,fastCase10_7360,fastCase10_7361,fastCase10_7362,fastCase10_7363,fastCase10_7364,fastCase10_7365,fastCase10_7366,fastCase10_7367,fastCase10_7368,fastCase10_7369,fastCase10_7370,fastCase10_7371,fastCase10_7372,fastCase10_7373,fastCase10_7374,fastCase10_7375,fastCase10_7376,fastCase10_7377,fastCase10_7378,fastCase10_7379,fastCase10_7380,fastCase10_7381,fastCase10_7382,fastCase10_7383,fastCase10_7384,fastCase10_7385,fastCase10_7386,fastCase10_7387,fastCase10_7388,fastCase10_7389,fastCase10_7390,fastCase10_7391,fastCase10_7392,fastCase10_7393,fastCase10_7394,fastCase10_7395,fastCase10_7396,fastCase10_7397,fastCase10_7398,fastCase10_7399,fastCase10_7400,fastCase10_7401,fastCase10_7402,fastCase10_7403,fastCase10_7404,fastCase10_7405,fastCase10_7406,fastCase10_7407,fastCase10_7408,fastCase10_7409,fastCase10_7410,fastCase10_7411,fastCase10_7412,fastCase10_7413,fastCase10_7414,fastCase10_7415,fastCase10_7416,fastCase10_7417,fastCase10_7418,fastCase10_7419,fastCase10_7420,fastCase10_7421,fastCase10_7422,fastCase10_7423,fastCase10_7424,fastCase10_7425,fastCase10_7426,fastCase10_7427,fastCase10_7428,fastCase10_7429,fastCase10_7430,fastCase10_7431,fastCase10_7432,fastCase10_7433,fastCase10_7434,fastCase10_7435,fastCase10_7436,fastCase10_7437,fastCase10_7438,fastCase10_7439,fastCase10_7440,fastCase10_7441,fastCase10_7442,fastCase10_7443,fastCase10_7444,fastCase10_7445,fastCase10_7446,fastCase10_7447,fastCase10_7448,fastCase10_7449,fastCase10_7450,fastCase10_7451,fastCase10_7452,fastCase10_7453,fastCase10_7454,fastCase10_7455,fastCase10_7456,fastCase10_7457,fastCase10_7458,fastCase10_7459,fastCase10_7460,fastCase10_7461,fastCase10_7462,fastCase10_7463,fastCase10_7464,fastCase10_7465,fastCase10_7466,fastCase10_7467,fastCase10_7468,fastCase10_7469,fastCase10_7470,fastCase10_7471,fastCase10_7472,fastCase10_7473,fastCase10_7474,fastCase10_7475,fastCase10_7476,fastCase10_7477,fastCase10_7478,fastCase10_7479,fastCase10_7480,fastCase10_7481,fastCase10_7482,fastCase10_7483,fastCase10_7484,fastCase10_7485,fastCase10_7486,fastCase10_7487,fastCase10_7488,fastCase10_7489,fastCase10_7490,fastCase10_7491,fastCase10_7492,fastCase10_7493,fastCase10_7494,fastCase10_7495,fastCase10_7496,fastCase10_7497,fastCase10_7498,fastCase10_7499,fastCase10_7500,fastCase10_7501,fastCase10_7502,fastCase10_7503,fastCase10_7504,fastCase10_7505,fastCase10_7506,fastCase10_7507,fastCase10_7508,fastCase10_7509,fastCase10_7510,fastCase10_7511,fastCase10_7512,fastCase10_7513,fastCase10_7514,fastCase10_7515,fastCase10_7516,fastCase10_7517,fastCase10_7518,fastCase10_7519,fastCase10_7520,fastCase10_7521,fastCase10_7522,fastCase10_7523,fastCase10_7524,fastCase10_7525,fastCase10_7526,fastCase10_7527,fastCase10_7528,fastCase10_7529,fastCase10_7530,fastCase10_7531,fastCase10_7532,fastCase10_7533,fastCase10_7534,fastCase10_7535,fastCase10_7536,fastCase10_7537,fastCase10_7538,fastCase10_7539,fastCase10_7540,fastCase10_7541,fastCase10_7542,fastCase10_7543,fastCase10_7544,fastCase10_7545,fastCase10_7546,fastCase10_7547,fastCase10_7548,fastCase10_7549,fastCase10_7550,fastCase10_7551,fastCase10_7552,fastCase10_7553,fastCase10_7554,fastCase10_7555,fastCase10_7556,fastCase10_7557,fastCase10_7558,fastCase10_7559,fastCase10_7560,fastCase10_7561,fastCase10_7562,fastCase10_7563,fastCase10_7564,fastCase10_7565,fastCase10_7566,fastCase10_7567,fastCase10_7568,fastCase10_7569,fastCase10_7570,fastCase10_7571,fastCase10_7572,fastCase10_7573,fastCase10_7574,fastCase10_7575,fastCase10_7576,fastCase10_7577,fastCase10_7578,fastCase10_7579,fastCase10_7580,fastCase10_7581,fastCase10_7582,fastCase10_7583,fastCase10_7584,fastCase10_7585,fastCase10_7586,fastCase10_7587,fastCase10_7588,fastCase10_7589,fastCase10_7590,fastCase10_7591,fastCase10_7592,fastCase10_7593,fastCase10_7594,fastCase10_7595,fastCase10_7596,fastCase10_7597,fastCase10_7598,fastCase10_7599,fastCase10_7600,fastCase10_7601,fastCase10_7602,fastCase10_7603,fastCase10_7604,fastCase10_7605,fastCase10_7606,fastCase10_7607,fastCase10_7608,fastCase10_7609,fastCase10_7610,fastCase10_7611,fastCase10_7612,fastCase10_7613,fastCase10_7614,fastCase10_7615,fastCase10_7616,fastCase10_7617,fastCase10_7618,fastCase10_7619,fastCase10_7620,fastCase10_7621,fastCase10_7622,fastCase10_7623,fastCase10_7624,fastCase10_7625,fastCase10_7626,fastCase10_7627,fastCase10_7628,fastCase10_7629,fastCase10_7630,fastCase10_7631,fastCase10_7632,fastCase10_7633,fastCase10_7634,fastCase10_7635,fastCase10_7636,fastCase10_7637,fastCase10_7638,fastCase10_7639,fastCase10_7640,fastCase10_7641,fastCase10_7642,fastCase10_7643,fastCase10_7644,fastCase10_7645,fastCase10_7646,fastCase10_7647,fastCase10_7648,fastCase10_7649,fastCase10_7650,fastCase10_7651,fastCase10_7652,fastCase10_7653,fastCase10_7654,fastCase10_7655,fastCase10_7656,fastCase10_7657,fastCase10_7658,fastCase10_7659,fastCase10_7660,fastCase10_7661,fastCase10_7662,fastCase10_7663,fastCase10_7664,fastCase10_7665,fastCase10_7666,fastCase10_7667,fastCase10_7668,fastCase10_7669,fastCase10_7670,fastCase10_7671,fastCase10_7672,fastCase10_7673,fastCase10_7674,fastCase10_7675,fastCase10_7676,fastCase10_7677,fastCase10_7678,fastCase10_7679,fastCase10_7680,fastCase10_7681,fastCase10_7682,fastCase10_7683,fastCase10_7684,fastCase10_7685,fastCase10_7686,fastCase10_7687,fastCase10_7688,fastCase10_7689,fastCase10_7690,fastCase10_7691,fastCase10_7692,fastCase10_7693,fastCase10_7694,fastCase10_7695,fastCase10_7696,fastCase10_7697,fastCase10_7698,fastCase10_7699,fastCase10_7700,fastCase10_7701,fastCase10_7702,fastCase10_7703,fastCase10_7704,fastCase10_7705,fastCase10_7706,fastCase10_7707,fastCase10_7708,fastCase10_7709,fastCase10_7710,fastCase10_7711,fastCase10_7712,fastCase10_7713,fastCase10_7714,fastCase10_7715,fastCase10_7716,fastCase10_7717,fastCase10_7718,fastCase10_7719,fastCase10_7720,fastCase10_7721,fastCase10_7722,fastCase10_7723,fastCase10_7724,fastCase10_7725,fastCase10_7726,fastCase10_7727,fastCase10_7728,fastCase10_7729,fastCase10_7730,fastCase10_7731,fastCase10_7732,fastCase10_7733,fastCase10_7734,fastCase10_7735,fastCase10_7736,fastCase10_7737,fastCase10_7738,fastCase10_7739,fastCase10_7740,fastCase10_7741,fastCase10_7742,fastCase10_7743,fastCase10_7744,fastCase10_7745,fastCase10_7746,fastCase10_7747,fastCase10_7748,fastCase10_7749,fastCase10_7750,fastCase10_7751,fastCase10_7752,fastCase10_7753,fastCase10_7754,fastCase10_7755,fastCase10_7756,fastCase10_7757,fastCase10_7758,fastCase10_7759,fastCase10_7760,fastCase10_7761,fastCase10_7762,fastCase10_7763,fastCase10_7764,fastCase10_7765,fastCase10_7766,fastCase10_7767,fastCase10_7768,fastCase10_7769,fastCase10_7770,fastCase10_7771,fastCase10_7772,fastCase10_7773,fastCase10_7774,fastCase10_7775,fastCase10_7776,fastCase10_7777,fastCase10_7778,fastCase10_7779,fastCase10_7780,fastCase10_7781,fastCase10_7782,fastCase10_7783,fastCase10_7784,fastCase10_7785,fastCase10_7786,fastCase10_7787,fastCase10_7788,fastCase10_7789,fastCase10_7790,fastCase10_7791,fastCase10_7792,fastCase10_7793,fastCase10_7794,fastCase10_7795,fastCase10_7796,fastCase10_7797,fastCase10_7798,fastCase10_7799,fastCase10_7800,fastCase10_7801,fastCase10_7802,fastCase10_7803,fastCase10_7804,fastCase10_7805,fastCase10_7806,fastCase10_7807,fastCase10_7808,fastCase10_7809,fastCase10_7810,fastCase10_7811,fastCase10_7812,fastCase10_7813,fastCase10_7814,fastCase10_7815,fastCase10_7816,fastCase10_7817,fastCase10_7818,fastCase10_7819,fastCase10_7820,fastCase10_7821,fastCase10_7822,fastCase10_7823,fastCase10_7824,fastCase10_7825,fastCase10_7826,fastCase10_7827,fastCase10_7828,fastCase10_7829,fastCase10_7830,fastCase10_7831,fastCase10_7832,fastCase10_7833,fastCase10_7834,fastCase10_7835,fastCase10_7836,fastCase10_7837,fastCase10_7838,fastCase10_7839,fastCase10_7840,fastCase10_7841,fastCase10_7842,fastCase10_7843,fastCase10_7844,fastCase10_7845,fastCase10_7846,fastCase10_7847,fastCase10_7848,fastCase10_7849,fastCase10_7850,fastCase10_7851,fastCase10_7852,fastCase10_7853,fastCase10_7854,fastCase10_7855,fastCase10_7856,fastCase10_7857,fastCase10_7858,fastCase10_7859,fastCase10_7860,fastCase10_7861,fastCase10_7862,fastCase10_7863,fastCase10_7864,fastCase10_7865,fastCase10_7866,fastCase10_7867,fastCase10_7868,fastCase10_7869,fastCase10_7870,fastCase10_7871,fastCase10_7872,fastCase10_7873,fastCase10_7874,fastCase10_7875,fastCase10_7876,fastCase10_7877,fastCase10_7878,fastCase10_7879,fastCase10_7880,fastCase10_7881,fastCase10_7882,fastCase10_7883,fastCase10_7884,fastCase10_7885,fastCase10_7886,fastCase10_7887,fastCase10_7888,fastCase10_7889,fastCase10_7890,fastCase10_7891,fastCase10_7892,fastCase10_7893,fastCase10_7894,fastCase10_7895,fastCase10_7896,fastCase10_7897,fastCase10_7898,fastCase10_7899,fastCase10_7900,fastCase10_7901,fastCase10_7902,fastCase10_7903,fastCase10_7904,fastCase10_7905,fastCase10_7906,fastCase10_7907,fastCase10_7908,fastCase10_7909,fastCase10_7910,fastCase10_7911,fastCase10_7912,fastCase10_7913,fastCase10_7914,fastCase10_7915,fastCase10_7916,fastCase10_7917,fastCase10_7918,fastCase10_7919,fastCase10_7920,fastCase10_7921,fastCase10_7922,fastCase10_7923,fastCase10_7924,fastCase10_7925,fastCase10_7926,fastCase10_7927,fastCase10_7928,fastCase10_7929,fastCase10_7930,fastCase10_7931,fastCase10_7932,fastCase10_7933,fastCase10_7934,fastCase10_7935,fastCase10_7936,fastCase10_7937,fastCase10_7938,fastCase10_7939,fastCase10_7940,fastCase10_7941,fastCase10_7942,fastCase10_7943,fastCase10_7944,fastCase10_7945,fastCase10_7946,fastCase10_7947,fastCase10_7948,fastCase10_7949,fastCase10_7950,fastCase10_7951,fastCase10_7952,fastCase10_7953,fastCase10_7954,fastCase10_7955,fastCase10_7956,fastCase10_7957,fastCase10_7958,fastCase10_7959,fastCase10_7960,fastCase10_7961,fastCase10_7962,fastCase10_7963,fastCase10_7964,fastCase10_7965,fastCase10_7966,fastCase10_7967,fastCase10_7968,fastCase10_7969,fastCase10_7970,fastCase10_7971,fastCase10_7972,fastCase10_7973,fastCase10_7974,fastCase10_7975,fastCase10_7976,fastCase10_7977,fastCase10_7978,fastCase10_7979,fastCase10_7980,fastCase10_7981,fastCase10_7982,fastCase10_7983,fastCase10_7984,fastCase10_7985,fastCase10_7986,fastCase10_7987,fastCase10_7988,fastCase10_7989,fastCase10_7990,fastCase10_7991,fastCase10_7992,fastCase10_7993,fastCase10_7994,fastCase10_7995,fastCase10_7996,fastCase10_7997,fastCase10_7998,fastCase10_7999⟩
#print axioms aggregate_F10_007
end KernelCatalog
