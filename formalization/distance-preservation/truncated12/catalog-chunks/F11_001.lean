import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert11_1000 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1000 : checkCertificateFast 11 1000 fastCert11_1000=true := by decide +kernel
def fastCert11_1001 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1001 : checkCertificateFast 11 1001 fastCert11_1001=true := by decide +kernel
def fastCert11_1002 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=17 then (1) else 0⟩
theorem fastCase11_1002 : checkCertificateFast 11 1002 fastCert11_1002=true := by decide +kernel
def fastCert11_1003 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=17 then (-1) else 0⟩
theorem fastCase11_1003 : checkCertificateFast 11 1003 fastCert11_1003=true := by decide +kernel
def fastCert11_1004 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1004 : checkCertificateFast 11 1004 fastCert11_1004=true := by decide +kernel
def fastCert11_1005 : Certificate := ⟨17,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1005 : checkCertificateFast 11 1005 fastCert11_1005=true := by decide +kernel
def fastCert11_1006 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1006 : checkCertificateFast 11 1006 fastCert11_1006=true := by decide +kernel
def fastCert11_1007 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1007 : checkCertificateFast 11 1007 fastCert11_1007=true := by decide +kernel
def fastCert11_1008 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1008 : checkCertificateFast 11 1008 fastCert11_1008=true := by decide +kernel
def fastCert11_1009 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-4) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1009 : checkCertificateFast 11 1009 fastCert11_1009=true := by decide +kernel
def fastCert11_1010 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (3) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1010 : checkCertificateFast 11 1010 fastCert11_1010=true := by decide +kernel
def fastCert11_1011 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1011 : checkCertificateFast 11 1011 fastCert11_1011=true := by decide +kernel
def fastCert11_1012 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1012 : checkCertificateFast 11 1012 fastCert11_1012=true := by decide +kernel
def fastCert11_1013 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1013 : checkCertificateFast 11 1013 fastCert11_1013=true := by decide +kernel
def fastCert11_1014 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1014 : checkCertificateFast 11 1014 fastCert11_1014=true := by decide +kernel
def fastCert11_1015 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1015 : checkCertificateFast 11 1015 fastCert11_1015=true := by decide +kernel
def fastCert11_1016 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1016 : checkCertificateFast 11 1016 fastCert11_1016=true := by decide +kernel
def fastCert11_1017 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (3) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=9 then (-4) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1017 : checkCertificateFast 11 1017 fastCert11_1017=true := by decide +kernel
def fastCert11_1018 : Certificate := ⟨20,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1018 : checkCertificateFast 11 1018 fastCert11_1018=true := by decide +kernel
def fastCert11_1019 : Certificate := ⟨17,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1019 : checkCertificateFast 11 1019 fastCert11_1019=true := by decide +kernel
def fastCert11_1020 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1020 : checkCertificateFast 11 1020 fastCert11_1020=true := by decide +kernel
def fastCert11_1021 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1021 : checkCertificateFast 11 1021 fastCert11_1021=true := by decide +kernel
def fastCert11_1022 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1022 : checkCertificateFast 11 1022 fastCert11_1022=true := by decide +kernel
def fastCert11_1023 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1023 : checkCertificateFast 11 1023 fastCert11_1023=true := by decide +kernel
def fastCert11_1024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1024 : checkCertificateFast 11 1024 fastCert11_1024=true := by decide +kernel
def fastCert11_1025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1025 : checkCertificateFast 11 1025 fastCert11_1025=true := by decide +kernel
def fastCert11_1026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1026 : checkCertificateFast 11 1026 fastCert11_1026=true := by decide +kernel
def fastCert11_1027 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1027 : checkCertificateFast 11 1027 fastCert11_1027=true := by decide +kernel
def fastCert11_1028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1028 : checkCertificateFast 11 1028 fastCert11_1028=true := by decide +kernel
def fastCert11_1029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1029 : checkCertificateFast 11 1029 fastCert11_1029=true := by decide +kernel
def fastCert11_1030 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1030 : checkCertificateFast 11 1030 fastCert11_1030=true := by decide +kernel
def fastCert11_1031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1031 : checkCertificateFast 11 1031 fastCert11_1031=true := by decide +kernel
def fastCert11_1032 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1032 : checkCertificateFast 11 1032 fastCert11_1032=true := by decide +kernel
def fastCert11_1033 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (4) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1033 : checkCertificateFast 11 1033 fastCert11_1033=true := by decide +kernel
def fastCert11_1034 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=17 then (-1) else 0⟩
theorem fastCase11_1034 : checkCertificateFast 11 1034 fastCert11_1034=true := by decide +kernel
def fastCert11_1035 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=17 then (1) else 0⟩
theorem fastCase11_1035 : checkCertificateFast 11 1035 fastCert11_1035=true := by decide +kernel
def fastCert11_1036 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1036 : checkCertificateFast 11 1036 fastCert11_1036=true := by decide +kernel
def fastCert11_1037 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1037 : checkCertificateFast 11 1037 fastCert11_1037=true := by decide +kernel
def fastCert11_1038 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1038 : checkCertificateFast 11 1038 fastCert11_1038=true := by decide +kernel
def fastCert11_1039 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1039 : checkCertificateFast 11 1039 fastCert11_1039=true := by decide +kernel
def fastCert11_1040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1040 : checkCertificateFast 11 1040 fastCert11_1040=true := by decide +kernel
def fastCert11_1041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1041 : checkCertificateFast 11 1041 fastCert11_1041=true := by decide +kernel
def fastCert11_1042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1042 : checkCertificateFast 11 1042 fastCert11_1042=true := by decide +kernel
def fastCert11_1043 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1043 : checkCertificateFast 11 1043 fastCert11_1043=true := by decide +kernel
def fastCert11_1044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1044 : checkCertificateFast 11 1044 fastCert11_1044=true := by decide +kernel
def fastCert11_1045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1045 : checkCertificateFast 11 1045 fastCert11_1045=true := by decide +kernel
def fastCert11_1046 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1046 : checkCertificateFast 11 1046 fastCert11_1046=true := by decide +kernel
def fastCert11_1047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1047 : checkCertificateFast 11 1047 fastCert11_1047=true := by decide +kernel
def fastCert11_1048 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1048 : checkCertificateFast 11 1048 fastCert11_1048=true := by decide +kernel
def fastCert11_1049 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1049 : checkCertificateFast 11 1049 fastCert11_1049=true := by decide +kernel
def fastCert11_1050 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=17 then (-1) else 0⟩
theorem fastCase11_1050 : checkCertificateFast 11 1050 fastCert11_1050=true := by decide +kernel
def fastCert11_1051 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=17 then (1) else 0⟩
theorem fastCase11_1051 : checkCertificateFast 11 1051 fastCert11_1051=true := by decide +kernel
def fastCert11_1052 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1052 : checkCertificateFast 11 1052 fastCert11_1052=true := by decide +kernel
def fastCert11_1053 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1053 : checkCertificateFast 11 1053 fastCert11_1053=true := by decide +kernel
def fastCert11_1054 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1054 : checkCertificateFast 11 1054 fastCert11_1054=true := by decide +kernel
def fastCert11_1055 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1055 : checkCertificateFast 11 1055 fastCert11_1055=true := by decide +kernel
def fastCert11_1056 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1056 : checkCertificateFast 11 1056 fastCert11_1056=true := by decide +kernel
def fastCert11_1057 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1057 : checkCertificateFast 11 1057 fastCert11_1057=true := by decide +kernel
def fastCert11_1058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1058 : checkCertificateFast 11 1058 fastCert11_1058=true := by decide +kernel
def fastCert11_1059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1059 : checkCertificateFast 11 1059 fastCert11_1059=true := by decide +kernel
def fastCert11_1060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1060 : checkCertificateFast 11 1060 fastCert11_1060=true := by decide +kernel
def fastCert11_1061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1061 : checkCertificateFast 11 1061 fastCert11_1061=true := by decide +kernel
def fastCert11_1062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1062 : checkCertificateFast 11 1062 fastCert11_1062=true := by decide +kernel
def fastCert11_1063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1063 : checkCertificateFast 11 1063 fastCert11_1063=true := by decide +kernel
def fastCert11_1064 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1064 : checkCertificateFast 11 1064 fastCert11_1064=true := by decide +kernel
def fastCert11_1065 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1065 : checkCertificateFast 11 1065 fastCert11_1065=true := by decide +kernel
def fastCert11_1066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-5) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (4) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=14 then (-3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1066 : checkCertificateFast 11 1066 fastCert11_1066=true := by decide +kernel
def fastCert11_1067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-5) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=14 then (-3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1067 : checkCertificateFast 11 1067 fastCert11_1067=true := by decide +kernel
def fastCert11_1068 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1068 : checkCertificateFast 11 1068 fastCert11_1068=true := by decide +kernel
def fastCert11_1069 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1069 : checkCertificateFast 11 1069 fastCert11_1069=true := by decide +kernel
def fastCert11_1070 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1070 : checkCertificateFast 11 1070 fastCert11_1070=true := by decide +kernel
def fastCert11_1071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1071 : checkCertificateFast 11 1071 fastCert11_1071=true := by decide +kernel
def fastCert11_1072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1072 : checkCertificateFast 11 1072 fastCert11_1072=true := by decide +kernel
def fastCert11_1073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1073 : checkCertificateFast 11 1073 fastCert11_1073=true := by decide +kernel
def fastCert11_1074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase11_1074 : checkCertificateFast 11 1074 fastCert11_1074=true := by decide +kernel
def fastCert11_1075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase11_1075 : checkCertificateFast 11 1075 fastCert11_1075=true := by decide +kernel
def fastCert11_1076 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1076 : checkCertificateFast 11 1076 fastCert11_1076=true := by decide +kernel
def fastCert11_1077 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1077 : checkCertificateFast 11 1077 fastCert11_1077=true := by decide +kernel
def fastCert11_1078 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1078 : checkCertificateFast 11 1078 fastCert11_1078=true := by decide +kernel
def fastCert11_1079 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1079 : checkCertificateFast 11 1079 fastCert11_1079=true := by decide +kernel
def fastCert11_1080 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1080 : checkCertificateFast 11 1080 fastCert11_1080=true := by decide +kernel
def fastCert11_1081 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1081 : checkCertificateFast 11 1081 fastCert11_1081=true := by decide +kernel
def fastCert11_1082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-4) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1082 : checkCertificateFast 11 1082 fastCert11_1082=true := by decide +kernel
def fastCert11_1083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-4) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1083 : checkCertificateFast 11 1083 fastCert11_1083=true := by decide +kernel
def fastCert11_1084 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1084 : checkCertificateFast 11 1084 fastCert11_1084=true := by decide +kernel
def fastCert11_1085 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1085 : checkCertificateFast 11 1085 fastCert11_1085=true := by decide +kernel
def fastCert11_1086 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1086 : checkCertificateFast 11 1086 fastCert11_1086=true := by decide +kernel
def fastCert11_1087 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1087 : checkCertificateFast 11 1087 fastCert11_1087=true := by decide +kernel
def fastCert11_1088 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1088 : checkCertificateFast 11 1088 fastCert11_1088=true := by decide +kernel
def fastCert11_1089 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1089 : checkCertificateFast 11 1089 fastCert11_1089=true := by decide +kernel
def fastCert11_1090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1090 : checkCertificateFast 11 1090 fastCert11_1090=true := by decide +kernel
def fastCert11_1091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (3) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-4) else if t=0 ∧ i=14 then (-3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1091 : checkCertificateFast 11 1091 fastCert11_1091=true := by decide +kernel
def fastCert11_1092 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1092 : checkCertificateFast 11 1092 fastCert11_1092=true := by decide +kernel
def fastCert11_1093 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1093 : checkCertificateFast 11 1093 fastCert11_1093=true := by decide +kernel
def fastCert11_1094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-3) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase11_1094 : checkCertificateFast 11 1094 fastCert11_1094=true := by decide +kernel
def fastCert11_1095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (4) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase11_1095 : checkCertificateFast 11 1095 fastCert11_1095=true := by decide +kernel
def fastCert11_1096 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1096 : checkCertificateFast 11 1096 fastCert11_1096=true := by decide +kernel
def fastCert11_1097 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1097 : checkCertificateFast 11 1097 fastCert11_1097=true := by decide +kernel
def fastCert11_1098 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1098 : checkCertificateFast 11 1098 fastCert11_1098=true := by decide +kernel
def fastCert11_1099 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase11_1099 : checkCertificateFast 11 1099 fastCert11_1099=true := by decide +kernel
def fastCert11_1100 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1100 : checkCertificateFast 11 1100 fastCert11_1100=true := by decide +kernel
def fastCert11_1101 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1101 : checkCertificateFast 11 1101 fastCert11_1101=true := by decide +kernel
def fastCert11_1102 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1102 : checkCertificateFast 11 1102 fastCert11_1102=true := by decide +kernel
def fastCert11_1103 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1103 : checkCertificateFast 11 1103 fastCert11_1103=true := by decide +kernel
def fastCert11_1104 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1104 : checkCertificateFast 11 1104 fastCert11_1104=true := by decide +kernel
def fastCert11_1105 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase11_1105 : checkCertificateFast 11 1105 fastCert11_1105=true := by decide +kernel
def fastCert11_1106 : Certificate := ⟨8,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1106 : checkCertificateFast 11 1106 fastCert11_1106=true := by decide +kernel
def fastCert11_1107 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1107 : checkCertificateFast 11 1107 fastCert11_1107=true := by decide +kernel
def fastCert11_1108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1108 : checkCertificateFast 11 1108 fastCert11_1108=true := by decide +kernel
def fastCert11_1109 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1109 : checkCertificateFast 11 1109 fastCert11_1109=true := by decide +kernel
def fastCert11_1110 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1110 : checkCertificateFast 11 1110 fastCert11_1110=true := by decide +kernel
def fastCert11_1111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-4) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1111 : checkCertificateFast 11 1111 fastCert11_1111=true := by decide +kernel
def fastCert11_1112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (3) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1112 : checkCertificateFast 11 1112 fastCert11_1112=true := by decide +kernel
def fastCert11_1113 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1113 : checkCertificateFast 11 1113 fastCert11_1113=true := by decide +kernel
def fastCert11_1114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1114 : checkCertificateFast 11 1114 fastCert11_1114=true := by decide +kernel
def fastCert11_1115 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1115 : checkCertificateFast 11 1115 fastCert11_1115=true := by decide +kernel
def fastCert11_1116 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1116 : checkCertificateFast 11 1116 fastCert11_1116=true := by decide +kernel
def fastCert11_1117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-3) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (4) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1117 : checkCertificateFast 11 1117 fastCert11_1117=true := by decide +kernel
def fastCert11_1118 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-3) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1118 : checkCertificateFast 11 1118 fastCert11_1118=true := by decide +kernel
def fastCert11_1119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (3) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-4) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1119 : checkCertificateFast 11 1119 fastCert11_1119=true := by decide +kernel
def fastCert11_1120 : Certificate := ⟨8,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1120 : checkCertificateFast 11 1120 fastCert11_1120=true := by decide +kernel
def fastCert11_1121 : Certificate := ⟨6,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1121 : checkCertificateFast 11 1121 fastCert11_1121=true := by decide +kernel
def fastCert11_1122 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1122 : checkCertificateFast 11 1122 fastCert11_1122=true := by decide +kernel
def fastCert11_1123 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1123 : checkCertificateFast 11 1123 fastCert11_1123=true := by decide +kernel
def fastCert11_1124 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1124 : checkCertificateFast 11 1124 fastCert11_1124=true := by decide +kernel
def fastCert11_1125 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1125 : checkCertificateFast 11 1125 fastCert11_1125=true := by decide +kernel
def fastCert11_1126 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1126 : checkCertificateFast 11 1126 fastCert11_1126=true := by decide +kernel
def fastCert11_1127 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1127 : checkCertificateFast 11 1127 fastCert11_1127=true := by decide +kernel
def fastCert11_1128 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1128 : checkCertificateFast 11 1128 fastCert11_1128=true := by decide +kernel
def fastCert11_1129 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1129 : checkCertificateFast 11 1129 fastCert11_1129=true := by decide +kernel
def fastCert11_1130 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1130 : checkCertificateFast 11 1130 fastCert11_1130=true := by decide +kernel
def fastCert11_1131 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1131 : checkCertificateFast 11 1131 fastCert11_1131=true := by decide +kernel
def fastCert11_1132 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1132 : checkCertificateFast 11 1132 fastCert11_1132=true := by decide +kernel
def fastCert11_1133 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1133 : checkCertificateFast 11 1133 fastCert11_1133=true := by decide +kernel
def fastCert11_1134 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1134 : checkCertificateFast 11 1134 fastCert11_1134=true := by decide +kernel
def fastCert11_1135 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1135 : checkCertificateFast 11 1135 fastCert11_1135=true := by decide +kernel
def fastCert11_1136 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1136 : checkCertificateFast 11 1136 fastCert11_1136=true := by decide +kernel
def fastCert11_1137 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1137 : checkCertificateFast 11 1137 fastCert11_1137=true := by decide +kernel
def fastCert11_1138 : Certificate := ⟨17,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1138 : checkCertificateFast 11 1138 fastCert11_1138=true := by decide +kernel
def fastCert11_1139 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1139 : checkCertificateFast 11 1139 fastCert11_1139=true := by decide +kernel
def fastCert11_1140 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1140 : checkCertificateFast 11 1140 fastCert11_1140=true := by decide +kernel
def fastCert11_1141 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1141 : checkCertificateFast 11 1141 fastCert11_1141=true := by decide +kernel
def fastCert11_1142 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1142 : checkCertificateFast 11 1142 fastCert11_1142=true := by decide +kernel
def fastCert11_1143 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1143 : checkCertificateFast 11 1143 fastCert11_1143=true := by decide +kernel
def fastCert11_1144 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1144 : checkCertificateFast 11 1144 fastCert11_1144=true := by decide +kernel
def fastCert11_1145 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1145 : checkCertificateFast 11 1145 fastCert11_1145=true := by decide +kernel
def fastCert11_1146 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1146 : checkCertificateFast 11 1146 fastCert11_1146=true := by decide +kernel
def fastCert11_1147 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1147 : checkCertificateFast 11 1147 fastCert11_1147=true := by decide +kernel
def fastCert11_1148 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1148 : checkCertificateFast 11 1148 fastCert11_1148=true := by decide +kernel
def fastCert11_1149 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1149 : checkCertificateFast 11 1149 fastCert11_1149=true := by decide +kernel
def fastCert11_1150 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1150 : checkCertificateFast 11 1150 fastCert11_1150=true := by decide +kernel
def fastCert11_1151 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1151 : checkCertificateFast 11 1151 fastCert11_1151=true := by decide +kernel
def fastCert11_1152 : Certificate := ⟨17,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1152 : checkCertificateFast 11 1152 fastCert11_1152=true := by decide +kernel
def fastCert11_1153 : Certificate := ⟨20,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1153 : checkCertificateFast 11 1153 fastCert11_1153=true := by decide +kernel
def fastCert11_1154 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1154 : checkCertificateFast 11 1154 fastCert11_1154=true := by decide +kernel
def fastCert11_1155 : Certificate := ⟨8,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1155 : checkCertificateFast 11 1155 fastCert11_1155=true := by decide +kernel
def fastCert11_1156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1156 : checkCertificateFast 11 1156 fastCert11_1156=true := by decide +kernel
def fastCert11_1157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1157 : checkCertificateFast 11 1157 fastCert11_1157=true := by decide +kernel
def fastCert11_1158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1158 : checkCertificateFast 11 1158 fastCert11_1158=true := by decide +kernel
def fastCert11_1159 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1159 : checkCertificateFast 11 1159 fastCert11_1159=true := by decide +kernel
def fastCert11_1160 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1160 : checkCertificateFast 11 1160 fastCert11_1160=true := by decide +kernel
def fastCert11_1161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1161 : checkCertificateFast 11 1161 fastCert11_1161=true := by decide +kernel
def fastCert11_1162 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1162 : checkCertificateFast 11 1162 fastCert11_1162=true := by decide +kernel
def fastCert11_1163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1163 : checkCertificateFast 11 1163 fastCert11_1163=true := by decide +kernel
def fastCert11_1164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1164 : checkCertificateFast 11 1164 fastCert11_1164=true := by decide +kernel
def fastCert11_1165 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1165 : checkCertificateFast 11 1165 fastCert11_1165=true := by decide +kernel
def fastCert11_1166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1166 : checkCertificateFast 11 1166 fastCert11_1166=true := by decide +kernel
def fastCert11_1167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1167 : checkCertificateFast 11 1167 fastCert11_1167=true := by decide +kernel
def fastCert11_1168 : Certificate := ⟨6,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1168 : checkCertificateFast 11 1168 fastCert11_1168=true := by decide +kernel
def fastCert11_1169 : Certificate := ⟨8,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1169 : checkCertificateFast 11 1169 fastCert11_1169=true := by decide +kernel
def fastCert11_1170 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1170 : checkCertificateFast 11 1170 fastCert11_1170=true := by decide +kernel
def fastCert11_1171 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1171 : checkCertificateFast 11 1171 fastCert11_1171=true := by decide +kernel
def fastCert11_1172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1172 : checkCertificateFast 11 1172 fastCert11_1172=true := by decide +kernel
def fastCert11_1173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1173 : checkCertificateFast 11 1173 fastCert11_1173=true := by decide +kernel
def fastCert11_1174 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1174 : checkCertificateFast 11 1174 fastCert11_1174=true := by decide +kernel
def fastCert11_1175 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1175 : checkCertificateFast 11 1175 fastCert11_1175=true := by decide +kernel
def fastCert11_1176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1176 : checkCertificateFast 11 1176 fastCert11_1176=true := by decide +kernel
def fastCert11_1177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1177 : checkCertificateFast 11 1177 fastCert11_1177=true := by decide +kernel
def fastCert11_1178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1178 : checkCertificateFast 11 1178 fastCert11_1178=true := by decide +kernel
def fastCert11_1179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1179 : checkCertificateFast 11 1179 fastCert11_1179=true := by decide +kernel
def fastCert11_1180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-4) else 0⟩
theorem fastCase11_1180 : checkCertificateFast 11 1180 fastCert11_1180=true := by decide +kernel
def fastCert11_1181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-4) else 0⟩
theorem fastCase11_1181 : checkCertificateFast 11 1181 fastCert11_1181=true := by decide +kernel
def fastCert11_1182 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1182 : checkCertificateFast 11 1182 fastCert11_1182=true := by decide +kernel
def fastCert11_1183 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1183 : checkCertificateFast 11 1183 fastCert11_1183=true := by decide +kernel
def fastCert11_1184 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1184 : checkCertificateFast 11 1184 fastCert11_1184=true := by decide +kernel
def fastCert11_1185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1185 : checkCertificateFast 11 1185 fastCert11_1185=true := by decide +kernel
def fastCert11_1186 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1186 : checkCertificateFast 11 1186 fastCert11_1186=true := by decide +kernel
def fastCert11_1187 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1187 : checkCertificateFast 11 1187 fastCert11_1187=true := by decide +kernel
def fastCert11_1188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1188 : checkCertificateFast 11 1188 fastCert11_1188=true := by decide +kernel
def fastCert11_1189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1189 : checkCertificateFast 11 1189 fastCert11_1189=true := by decide +kernel
def fastCert11_1190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1190 : checkCertificateFast 11 1190 fastCert11_1190=true := by decide +kernel
def fastCert11_1191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1191 : checkCertificateFast 11 1191 fastCert11_1191=true := by decide +kernel
def fastCert11_1192 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (4) else 0⟩
theorem fastCase11_1192 : checkCertificateFast 11 1192 fastCert11_1192=true := by decide +kernel
def fastCert11_1193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (4) else 0⟩
theorem fastCase11_1193 : checkCertificateFast 11 1193 fastCert11_1193=true := by decide +kernel
def fastCert11_1194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1194 : checkCertificateFast 11 1194 fastCert11_1194=true := by decide +kernel
def fastCert11_1195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1195 : checkCertificateFast 11 1195 fastCert11_1195=true := by decide +kernel
def fastCert11_1196 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1196 : checkCertificateFast 11 1196 fastCert11_1196=true := by decide +kernel
def fastCert11_1197 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1197 : checkCertificateFast 11 1197 fastCert11_1197=true := by decide +kernel
def fastCert11_1198 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1198 : checkCertificateFast 11 1198 fastCert11_1198=true := by decide +kernel
def fastCert11_1199 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1199 : checkCertificateFast 11 1199 fastCert11_1199=true := by decide +kernel
def fastCert11_1200 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1200 : checkCertificateFast 11 1200 fastCert11_1200=true := by decide +kernel
def fastCert11_1201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1201 : checkCertificateFast 11 1201 fastCert11_1201=true := by decide +kernel
def fastCert11_1202 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1202 : checkCertificateFast 11 1202 fastCert11_1202=true := by decide +kernel
def fastCert11_1203 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1203 : checkCertificateFast 11 1203 fastCert11_1203=true := by decide +kernel
def fastCert11_1204 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1204 : checkCertificateFast 11 1204 fastCert11_1204=true := by decide +kernel
def fastCert11_1205 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1205 : checkCertificateFast 11 1205 fastCert11_1205=true := by decide +kernel
def fastCert11_1206 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1206 : checkCertificateFast 11 1206 fastCert11_1206=true := by decide +kernel
def fastCert11_1207 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1207 : checkCertificateFast 11 1207 fastCert11_1207=true := by decide +kernel
def fastCert11_1208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1208 : checkCertificateFast 11 1208 fastCert11_1208=true := by decide +kernel
def fastCert11_1209 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1209 : checkCertificateFast 11 1209 fastCert11_1209=true := by decide +kernel
def fastCert11_1210 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1210 : checkCertificateFast 11 1210 fastCert11_1210=true := by decide +kernel
def fastCert11_1211 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1211 : checkCertificateFast 11 1211 fastCert11_1211=true := by decide +kernel
def fastCert11_1212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1212 : checkCertificateFast 11 1212 fastCert11_1212=true := by decide +kernel
def fastCert11_1213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1213 : checkCertificateFast 11 1213 fastCert11_1213=true := by decide +kernel
def fastCert11_1214 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1214 : checkCertificateFast 11 1214 fastCert11_1214=true := by decide +kernel
def fastCert11_1215 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1215 : checkCertificateFast 11 1215 fastCert11_1215=true := by decide +kernel
def fastCert11_1216 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1216 : checkCertificateFast 11 1216 fastCert11_1216=true := by decide +kernel
def fastCert11_1217 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1217 : checkCertificateFast 11 1217 fastCert11_1217=true := by decide +kernel
def fastCert11_1218 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1218 : checkCertificateFast 11 1218 fastCert11_1218=true := by decide +kernel
def fastCert11_1219 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1219 : checkCertificateFast 11 1219 fastCert11_1219=true := by decide +kernel
def fastCert11_1220 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1220 : checkCertificateFast 11 1220 fastCert11_1220=true := by decide +kernel
def fastCert11_1221 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1221 : checkCertificateFast 11 1221 fastCert11_1221=true := by decide +kernel
def fastCert11_1222 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1222 : checkCertificateFast 11 1222 fastCert11_1222=true := by decide +kernel
def fastCert11_1223 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase11_1223 : checkCertificateFast 11 1223 fastCert11_1223=true := by decide +kernel
def fastCert11_1224 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1224 : checkCertificateFast 11 1224 fastCert11_1224=true := by decide +kernel
def fastCert11_1225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1225 : checkCertificateFast 11 1225 fastCert11_1225=true := by decide +kernel
def fastCert11_1226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1226 : checkCertificateFast 11 1226 fastCert11_1226=true := by decide +kernel
def fastCert11_1227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1227 : checkCertificateFast 11 1227 fastCert11_1227=true := by decide +kernel
def fastCert11_1228 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1228 : checkCertificateFast 11 1228 fastCert11_1228=true := by decide +kernel
def fastCert11_1229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1229 : checkCertificateFast 11 1229 fastCert11_1229=true := by decide +kernel
def fastCert11_1230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1230 : checkCertificateFast 11 1230 fastCert11_1230=true := by decide +kernel
def fastCert11_1231 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1231 : checkCertificateFast 11 1231 fastCert11_1231=true := by decide +kernel
def fastCert11_1232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1232 : checkCertificateFast 11 1232 fastCert11_1232=true := by decide +kernel
def fastCert11_1233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1233 : checkCertificateFast 11 1233 fastCert11_1233=true := by decide +kernel
def fastCert11_1234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1234 : checkCertificateFast 11 1234 fastCert11_1234=true := by decide +kernel
def fastCert11_1235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1235 : checkCertificateFast 11 1235 fastCert11_1235=true := by decide +kernel
def fastCert11_1236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1236 : checkCertificateFast 11 1236 fastCert11_1236=true := by decide +kernel
def fastCert11_1237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1237 : checkCertificateFast 11 1237 fastCert11_1237=true := by decide +kernel
def fastCert11_1238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1238 : checkCertificateFast 11 1238 fastCert11_1238=true := by decide +kernel
def fastCert11_1239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1239 : checkCertificateFast 11 1239 fastCert11_1239=true := by decide +kernel
def fastCert11_1240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1240 : checkCertificateFast 11 1240 fastCert11_1240=true := by decide +kernel
def fastCert11_1241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1241 : checkCertificateFast 11 1241 fastCert11_1241=true := by decide +kernel
def fastCert11_1242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1242 : checkCertificateFast 11 1242 fastCert11_1242=true := by decide +kernel
def fastCert11_1243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1243 : checkCertificateFast 11 1243 fastCert11_1243=true := by decide +kernel
def fastCert11_1244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1244 : checkCertificateFast 11 1244 fastCert11_1244=true := by decide +kernel
def fastCert11_1245 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1245 : checkCertificateFast 11 1245 fastCert11_1245=true := by decide +kernel
def fastCert11_1246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1246 : checkCertificateFast 11 1246 fastCert11_1246=true := by decide +kernel
def fastCert11_1247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1247 : checkCertificateFast 11 1247 fastCert11_1247=true := by decide +kernel
def fastCert11_1248 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1248 : checkCertificateFast 11 1248 fastCert11_1248=true := by decide +kernel
def fastCert11_1249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1249 : checkCertificateFast 11 1249 fastCert11_1249=true := by decide +kernel
def fastCert11_1250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1250 : checkCertificateFast 11 1250 fastCert11_1250=true := by decide +kernel
def fastCert11_1251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1251 : checkCertificateFast 11 1251 fastCert11_1251=true := by decide +kernel
def fastCert11_1252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1252 : checkCertificateFast 11 1252 fastCert11_1252=true := by decide +kernel
def fastCert11_1253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1253 : checkCertificateFast 11 1253 fastCert11_1253=true := by decide +kernel
def fastCert11_1254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1254 : checkCertificateFast 11 1254 fastCert11_1254=true := by decide +kernel
def fastCert11_1255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1255 : checkCertificateFast 11 1255 fastCert11_1255=true := by decide +kernel
def fastCert11_1256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1256 : checkCertificateFast 11 1256 fastCert11_1256=true := by decide +kernel
def fastCert11_1257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1257 : checkCertificateFast 11 1257 fastCert11_1257=true := by decide +kernel
def fastCert11_1258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1258 : checkCertificateFast 11 1258 fastCert11_1258=true := by decide +kernel
def fastCert11_1259 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1259 : checkCertificateFast 11 1259 fastCert11_1259=true := by decide +kernel
def fastCert11_1260 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1260 : checkCertificateFast 11 1260 fastCert11_1260=true := by decide +kernel
def fastCert11_1261 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1261 : checkCertificateFast 11 1261 fastCert11_1261=true := by decide +kernel
def fastCert11_1262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1262 : checkCertificateFast 11 1262 fastCert11_1262=true := by decide +kernel
def fastCert11_1263 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1263 : checkCertificateFast 11 1263 fastCert11_1263=true := by decide +kernel
def fastCert11_1264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1264 : checkCertificateFast 11 1264 fastCert11_1264=true := by decide +kernel
def fastCert11_1265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1265 : checkCertificateFast 11 1265 fastCert11_1265=true := by decide +kernel
def fastCert11_1266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1266 : checkCertificateFast 11 1266 fastCert11_1266=true := by decide +kernel
def fastCert11_1267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1267 : checkCertificateFast 11 1267 fastCert11_1267=true := by decide +kernel
def fastCert11_1268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1268 : checkCertificateFast 11 1268 fastCert11_1268=true := by decide +kernel
def fastCert11_1269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1269 : checkCertificateFast 11 1269 fastCert11_1269=true := by decide +kernel
def fastCert11_1270 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1270 : checkCertificateFast 11 1270 fastCert11_1270=true := by decide +kernel
def fastCert11_1271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1271 : checkCertificateFast 11 1271 fastCert11_1271=true := by decide +kernel
def fastCert11_1272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1272 : checkCertificateFast 11 1272 fastCert11_1272=true := by decide +kernel
def fastCert11_1273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1273 : checkCertificateFast 11 1273 fastCert11_1273=true := by decide +kernel
def fastCert11_1274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1274 : checkCertificateFast 11 1274 fastCert11_1274=true := by decide +kernel
def fastCert11_1275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1275 : checkCertificateFast 11 1275 fastCert11_1275=true := by decide +kernel
def fastCert11_1276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1276 : checkCertificateFast 11 1276 fastCert11_1276=true := by decide +kernel
def fastCert11_1277 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1277 : checkCertificateFast 11 1277 fastCert11_1277=true := by decide +kernel
def fastCert11_1278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1278 : checkCertificateFast 11 1278 fastCert11_1278=true := by decide +kernel
def fastCert11_1279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1279 : checkCertificateFast 11 1279 fastCert11_1279=true := by decide +kernel
def fastCert11_1280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1280 : checkCertificateFast 11 1280 fastCert11_1280=true := by decide +kernel
def fastCert11_1281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1281 : checkCertificateFast 11 1281 fastCert11_1281=true := by decide +kernel
def fastCert11_1282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1282 : checkCertificateFast 11 1282 fastCert11_1282=true := by decide +kernel
def fastCert11_1283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1283 : checkCertificateFast 11 1283 fastCert11_1283=true := by decide +kernel
def fastCert11_1284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1284 : checkCertificateFast 11 1284 fastCert11_1284=true := by decide +kernel
def fastCert11_1285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1285 : checkCertificateFast 11 1285 fastCert11_1285=true := by decide +kernel
def fastCert11_1286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1286 : checkCertificateFast 11 1286 fastCert11_1286=true := by decide +kernel
def fastCert11_1287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1287 : checkCertificateFast 11 1287 fastCert11_1287=true := by decide +kernel
def fastCert11_1288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1288 : checkCertificateFast 11 1288 fastCert11_1288=true := by decide +kernel
def fastCert11_1289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1289 : checkCertificateFast 11 1289 fastCert11_1289=true := by decide +kernel
def fastCert11_1290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1290 : checkCertificateFast 11 1290 fastCert11_1290=true := by decide +kernel
def fastCert11_1291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1291 : checkCertificateFast 11 1291 fastCert11_1291=true := by decide +kernel
def fastCert11_1292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1292 : checkCertificateFast 11 1292 fastCert11_1292=true := by decide +kernel
def fastCert11_1293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1293 : checkCertificateFast 11 1293 fastCert11_1293=true := by decide +kernel
def fastCert11_1294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1294 : checkCertificateFast 11 1294 fastCert11_1294=true := by decide +kernel
def fastCert11_1295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1295 : checkCertificateFast 11 1295 fastCert11_1295=true := by decide +kernel
def fastCert11_1296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1296 : checkCertificateFast 11 1296 fastCert11_1296=true := by decide +kernel
def fastCert11_1297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1297 : checkCertificateFast 11 1297 fastCert11_1297=true := by decide +kernel
def fastCert11_1298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1298 : checkCertificateFast 11 1298 fastCert11_1298=true := by decide +kernel
def fastCert11_1299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1299 : checkCertificateFast 11 1299 fastCert11_1299=true := by decide +kernel
def fastCert11_1300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1300 : checkCertificateFast 11 1300 fastCert11_1300=true := by decide +kernel
def fastCert11_1301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1301 : checkCertificateFast 11 1301 fastCert11_1301=true := by decide +kernel
def fastCert11_1302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1302 : checkCertificateFast 11 1302 fastCert11_1302=true := by decide +kernel
def fastCert11_1303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1303 : checkCertificateFast 11 1303 fastCert11_1303=true := by decide +kernel
def fastCert11_1304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1304 : checkCertificateFast 11 1304 fastCert11_1304=true := by decide +kernel
def fastCert11_1305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1305 : checkCertificateFast 11 1305 fastCert11_1305=true := by decide +kernel
def fastCert11_1306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1306 : checkCertificateFast 11 1306 fastCert11_1306=true := by decide +kernel
def fastCert11_1307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1307 : checkCertificateFast 11 1307 fastCert11_1307=true := by decide +kernel
def fastCert11_1308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1308 : checkCertificateFast 11 1308 fastCert11_1308=true := by decide +kernel
def fastCert11_1309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1309 : checkCertificateFast 11 1309 fastCert11_1309=true := by decide +kernel
def fastCert11_1310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1310 : checkCertificateFast 11 1310 fastCert11_1310=true := by decide +kernel
def fastCert11_1311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1311 : checkCertificateFast 11 1311 fastCert11_1311=true := by decide +kernel
def fastCert11_1312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1312 : checkCertificateFast 11 1312 fastCert11_1312=true := by decide +kernel
def fastCert11_1313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1313 : checkCertificateFast 11 1313 fastCert11_1313=true := by decide +kernel
def fastCert11_1314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1314 : checkCertificateFast 11 1314 fastCert11_1314=true := by decide +kernel
def fastCert11_1315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1315 : checkCertificateFast 11 1315 fastCert11_1315=true := by decide +kernel
def fastCert11_1316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1316 : checkCertificateFast 11 1316 fastCert11_1316=true := by decide +kernel
def fastCert11_1317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1317 : checkCertificateFast 11 1317 fastCert11_1317=true := by decide +kernel
def fastCert11_1318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1318 : checkCertificateFast 11 1318 fastCert11_1318=true := by decide +kernel
def fastCert11_1319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1319 : checkCertificateFast 11 1319 fastCert11_1319=true := by decide +kernel
def fastCert11_1320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1320 : checkCertificateFast 11 1320 fastCert11_1320=true := by decide +kernel
def fastCert11_1321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1321 : checkCertificateFast 11 1321 fastCert11_1321=true := by decide +kernel
def fastCert11_1322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1322 : checkCertificateFast 11 1322 fastCert11_1322=true := by decide +kernel
def fastCert11_1323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1323 : checkCertificateFast 11 1323 fastCert11_1323=true := by decide +kernel
def fastCert11_1324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1324 : checkCertificateFast 11 1324 fastCert11_1324=true := by decide +kernel
def fastCert11_1325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1325 : checkCertificateFast 11 1325 fastCert11_1325=true := by decide +kernel
def fastCert11_1326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1326 : checkCertificateFast 11 1326 fastCert11_1326=true := by decide +kernel
def fastCert11_1327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1327 : checkCertificateFast 11 1327 fastCert11_1327=true := by decide +kernel
def fastCert11_1328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1328 : checkCertificateFast 11 1328 fastCert11_1328=true := by decide +kernel
def fastCert11_1329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1329 : checkCertificateFast 11 1329 fastCert11_1329=true := by decide +kernel
def fastCert11_1330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1330 : checkCertificateFast 11 1330 fastCert11_1330=true := by decide +kernel
def fastCert11_1331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1331 : checkCertificateFast 11 1331 fastCert11_1331=true := by decide +kernel
def fastCert11_1332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1332 : checkCertificateFast 11 1332 fastCert11_1332=true := by decide +kernel
def fastCert11_1333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1333 : checkCertificateFast 11 1333 fastCert11_1333=true := by decide +kernel
def fastCert11_1334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1334 : checkCertificateFast 11 1334 fastCert11_1334=true := by decide +kernel
def fastCert11_1335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1335 : checkCertificateFast 11 1335 fastCert11_1335=true := by decide +kernel
def fastCert11_1336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1336 : checkCertificateFast 11 1336 fastCert11_1336=true := by decide +kernel
def fastCert11_1337 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1337 : checkCertificateFast 11 1337 fastCert11_1337=true := by decide +kernel
def fastCert11_1338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1338 : checkCertificateFast 11 1338 fastCert11_1338=true := by decide +kernel
def fastCert11_1339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1339 : checkCertificateFast 11 1339 fastCert11_1339=true := by decide +kernel
def fastCert11_1340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1340 : checkCertificateFast 11 1340 fastCert11_1340=true := by decide +kernel
def fastCert11_1341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1341 : checkCertificateFast 11 1341 fastCert11_1341=true := by decide +kernel
def fastCert11_1342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1342 : checkCertificateFast 11 1342 fastCert11_1342=true := by decide +kernel
def fastCert11_1343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1343 : checkCertificateFast 11 1343 fastCert11_1343=true := by decide +kernel
def fastCert11_1344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1344 : checkCertificateFast 11 1344 fastCert11_1344=true := by decide +kernel
def fastCert11_1345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1345 : checkCertificateFast 11 1345 fastCert11_1345=true := by decide +kernel
def fastCert11_1346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1346 : checkCertificateFast 11 1346 fastCert11_1346=true := by decide +kernel
def fastCert11_1347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1347 : checkCertificateFast 11 1347 fastCert11_1347=true := by decide +kernel
def fastCert11_1348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1348 : checkCertificateFast 11 1348 fastCert11_1348=true := by decide +kernel
def fastCert11_1349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1349 : checkCertificateFast 11 1349 fastCert11_1349=true := by decide +kernel
def fastCert11_1350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1350 : checkCertificateFast 11 1350 fastCert11_1350=true := by decide +kernel
def fastCert11_1351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1351 : checkCertificateFast 11 1351 fastCert11_1351=true := by decide +kernel
def fastCert11_1352 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1352 : checkCertificateFast 11 1352 fastCert11_1352=true := by decide +kernel
def fastCert11_1353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1353 : checkCertificateFast 11 1353 fastCert11_1353=true := by decide +kernel
def fastCert11_1354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1354 : checkCertificateFast 11 1354 fastCert11_1354=true := by decide +kernel
def fastCert11_1355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1355 : checkCertificateFast 11 1355 fastCert11_1355=true := by decide +kernel
def fastCert11_1356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1356 : checkCertificateFast 11 1356 fastCert11_1356=true := by decide +kernel
def fastCert11_1357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1357 : checkCertificateFast 11 1357 fastCert11_1357=true := by decide +kernel
def fastCert11_1358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1358 : checkCertificateFast 11 1358 fastCert11_1358=true := by decide +kernel
def fastCert11_1359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1359 : checkCertificateFast 11 1359 fastCert11_1359=true := by decide +kernel
def fastCert11_1360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1360 : checkCertificateFast 11 1360 fastCert11_1360=true := by decide +kernel
def fastCert11_1361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1361 : checkCertificateFast 11 1361 fastCert11_1361=true := by decide +kernel
def fastCert11_1362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1362 : checkCertificateFast 11 1362 fastCert11_1362=true := by decide +kernel
def fastCert11_1363 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1363 : checkCertificateFast 11 1363 fastCert11_1363=true := by decide +kernel
def fastCert11_1364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1364 : checkCertificateFast 11 1364 fastCert11_1364=true := by decide +kernel
def fastCert11_1365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1365 : checkCertificateFast 11 1365 fastCert11_1365=true := by decide +kernel
def fastCert11_1366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1366 : checkCertificateFast 11 1366 fastCert11_1366=true := by decide +kernel
def fastCert11_1367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1367 : checkCertificateFast 11 1367 fastCert11_1367=true := by decide +kernel
def fastCert11_1368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1368 : checkCertificateFast 11 1368 fastCert11_1368=true := by decide +kernel
def fastCert11_1369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1369 : checkCertificateFast 11 1369 fastCert11_1369=true := by decide +kernel
def fastCert11_1370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1370 : checkCertificateFast 11 1370 fastCert11_1370=true := by decide +kernel
def fastCert11_1371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1371 : checkCertificateFast 11 1371 fastCert11_1371=true := by decide +kernel
def fastCert11_1372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1372 : checkCertificateFast 11 1372 fastCert11_1372=true := by decide +kernel
def fastCert11_1373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1373 : checkCertificateFast 11 1373 fastCert11_1373=true := by decide +kernel
def fastCert11_1374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1374 : checkCertificateFast 11 1374 fastCert11_1374=true := by decide +kernel
def fastCert11_1375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1375 : checkCertificateFast 11 1375 fastCert11_1375=true := by decide +kernel
def fastCert11_1376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1376 : checkCertificateFast 11 1376 fastCert11_1376=true := by decide +kernel
def fastCert11_1377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1377 : checkCertificateFast 11 1377 fastCert11_1377=true := by decide +kernel
def fastCert11_1378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1378 : checkCertificateFast 11 1378 fastCert11_1378=true := by decide +kernel
def fastCert11_1379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1379 : checkCertificateFast 11 1379 fastCert11_1379=true := by decide +kernel
def fastCert11_1380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1380 : checkCertificateFast 11 1380 fastCert11_1380=true := by decide +kernel
def fastCert11_1381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1381 : checkCertificateFast 11 1381 fastCert11_1381=true := by decide +kernel
def fastCert11_1382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1382 : checkCertificateFast 11 1382 fastCert11_1382=true := by decide +kernel
def fastCert11_1383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1383 : checkCertificateFast 11 1383 fastCert11_1383=true := by decide +kernel
def fastCert11_1384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1384 : checkCertificateFast 11 1384 fastCert11_1384=true := by decide +kernel
def fastCert11_1385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1385 : checkCertificateFast 11 1385 fastCert11_1385=true := by decide +kernel
def fastCert11_1386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1386 : checkCertificateFast 11 1386 fastCert11_1386=true := by decide +kernel
def fastCert11_1387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1387 : checkCertificateFast 11 1387 fastCert11_1387=true := by decide +kernel
def fastCert11_1388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1388 : checkCertificateFast 11 1388 fastCert11_1388=true := by decide +kernel
def fastCert11_1389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1389 : checkCertificateFast 11 1389 fastCert11_1389=true := by decide +kernel
def fastCert11_1390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1390 : checkCertificateFast 11 1390 fastCert11_1390=true := by decide +kernel
def fastCert11_1391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1391 : checkCertificateFast 11 1391 fastCert11_1391=true := by decide +kernel
def fastCert11_1392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1392 : checkCertificateFast 11 1392 fastCert11_1392=true := by decide +kernel
def fastCert11_1393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1393 : checkCertificateFast 11 1393 fastCert11_1393=true := by decide +kernel
def fastCert11_1394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1394 : checkCertificateFast 11 1394 fastCert11_1394=true := by decide +kernel
def fastCert11_1395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1395 : checkCertificateFast 11 1395 fastCert11_1395=true := by decide +kernel
def fastCert11_1396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1396 : checkCertificateFast 11 1396 fastCert11_1396=true := by decide +kernel
def fastCert11_1397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1397 : checkCertificateFast 11 1397 fastCert11_1397=true := by decide +kernel
def fastCert11_1398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1398 : checkCertificateFast 11 1398 fastCert11_1398=true := by decide +kernel
def fastCert11_1399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1399 : checkCertificateFast 11 1399 fastCert11_1399=true := by decide +kernel
def fastCert11_1400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1400 : checkCertificateFast 11 1400 fastCert11_1400=true := by decide +kernel
def fastCert11_1401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1401 : checkCertificateFast 11 1401 fastCert11_1401=true := by decide +kernel
def fastCert11_1402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1402 : checkCertificateFast 11 1402 fastCert11_1402=true := by decide +kernel
def fastCert11_1403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1403 : checkCertificateFast 11 1403 fastCert11_1403=true := by decide +kernel
def fastCert11_1404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1404 : checkCertificateFast 11 1404 fastCert11_1404=true := by decide +kernel
def fastCert11_1405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1405 : checkCertificateFast 11 1405 fastCert11_1405=true := by decide +kernel
def fastCert11_1406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1406 : checkCertificateFast 11 1406 fastCert11_1406=true := by decide +kernel
def fastCert11_1407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1407 : checkCertificateFast 11 1407 fastCert11_1407=true := by decide +kernel
def fastCert11_1408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1408 : checkCertificateFast 11 1408 fastCert11_1408=true := by decide +kernel
def fastCert11_1409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1409 : checkCertificateFast 11 1409 fastCert11_1409=true := by decide +kernel
def fastCert11_1410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1410 : checkCertificateFast 11 1410 fastCert11_1410=true := by decide +kernel
def fastCert11_1411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1411 : checkCertificateFast 11 1411 fastCert11_1411=true := by decide +kernel
def fastCert11_1412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1412 : checkCertificateFast 11 1412 fastCert11_1412=true := by decide +kernel
def fastCert11_1413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1413 : checkCertificateFast 11 1413 fastCert11_1413=true := by decide +kernel
def fastCert11_1414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1414 : checkCertificateFast 11 1414 fastCert11_1414=true := by decide +kernel
def fastCert11_1415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1415 : checkCertificateFast 11 1415 fastCert11_1415=true := by decide +kernel
def fastCert11_1416 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1416 : checkCertificateFast 11 1416 fastCert11_1416=true := by decide +kernel
def fastCert11_1417 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1417 : checkCertificateFast 11 1417 fastCert11_1417=true := by decide +kernel
def fastCert11_1418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1418 : checkCertificateFast 11 1418 fastCert11_1418=true := by decide +kernel
def fastCert11_1419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1419 : checkCertificateFast 11 1419 fastCert11_1419=true := by decide +kernel
def fastCert11_1420 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1420 : checkCertificateFast 11 1420 fastCert11_1420=true := by decide +kernel
def fastCert11_1421 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1421 : checkCertificateFast 11 1421 fastCert11_1421=true := by decide +kernel
def fastCert11_1422 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1422 : checkCertificateFast 11 1422 fastCert11_1422=true := by decide +kernel
def fastCert11_1423 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1423 : checkCertificateFast 11 1423 fastCert11_1423=true := by decide +kernel
def fastCert11_1424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1424 : checkCertificateFast 11 1424 fastCert11_1424=true := by decide +kernel
def fastCert11_1425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1425 : checkCertificateFast 11 1425 fastCert11_1425=true := by decide +kernel
def fastCert11_1426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1426 : checkCertificateFast 11 1426 fastCert11_1426=true := by decide +kernel
def fastCert11_1427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1427 : checkCertificateFast 11 1427 fastCert11_1427=true := by decide +kernel
def fastCert11_1428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1428 : checkCertificateFast 11 1428 fastCert11_1428=true := by decide +kernel
def fastCert11_1429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1429 : checkCertificateFast 11 1429 fastCert11_1429=true := by decide +kernel
def fastCert11_1430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1430 : checkCertificateFast 11 1430 fastCert11_1430=true := by decide +kernel
def fastCert11_1431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1431 : checkCertificateFast 11 1431 fastCert11_1431=true := by decide +kernel
def fastCert11_1432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1432 : checkCertificateFast 11 1432 fastCert11_1432=true := by decide +kernel
def fastCert11_1433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1433 : checkCertificateFast 11 1433 fastCert11_1433=true := by decide +kernel
def fastCert11_1434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1434 : checkCertificateFast 11 1434 fastCert11_1434=true := by decide +kernel
def fastCert11_1435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1435 : checkCertificateFast 11 1435 fastCert11_1435=true := by decide +kernel
def fastCert11_1436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1436 : checkCertificateFast 11 1436 fastCert11_1436=true := by decide +kernel
def fastCert11_1437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1437 : checkCertificateFast 11 1437 fastCert11_1437=true := by decide +kernel
def fastCert11_1438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1438 : checkCertificateFast 11 1438 fastCert11_1438=true := by decide +kernel
def fastCert11_1439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1439 : checkCertificateFast 11 1439 fastCert11_1439=true := by decide +kernel
def fastCert11_1440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1440 : checkCertificateFast 11 1440 fastCert11_1440=true := by decide +kernel
def fastCert11_1441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1441 : checkCertificateFast 11 1441 fastCert11_1441=true := by decide +kernel
def fastCert11_1442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1442 : checkCertificateFast 11 1442 fastCert11_1442=true := by decide +kernel
def fastCert11_1443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1443 : checkCertificateFast 11 1443 fastCert11_1443=true := by decide +kernel
def fastCert11_1444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1444 : checkCertificateFast 11 1444 fastCert11_1444=true := by decide +kernel
def fastCert11_1445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1445 : checkCertificateFast 11 1445 fastCert11_1445=true := by decide +kernel
def fastCert11_1446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1446 : checkCertificateFast 11 1446 fastCert11_1446=true := by decide +kernel
def fastCert11_1447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1447 : checkCertificateFast 11 1447 fastCert11_1447=true := by decide +kernel
def fastCert11_1448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1448 : checkCertificateFast 11 1448 fastCert11_1448=true := by decide +kernel
def fastCert11_1449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1449 : checkCertificateFast 11 1449 fastCert11_1449=true := by decide +kernel
def fastCert11_1450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1450 : checkCertificateFast 11 1450 fastCert11_1450=true := by decide +kernel
def fastCert11_1451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1451 : checkCertificateFast 11 1451 fastCert11_1451=true := by decide +kernel
def fastCert11_1452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1452 : checkCertificateFast 11 1452 fastCert11_1452=true := by decide +kernel
def fastCert11_1453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1453 : checkCertificateFast 11 1453 fastCert11_1453=true := by decide +kernel
def fastCert11_1454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1454 : checkCertificateFast 11 1454 fastCert11_1454=true := by decide +kernel
def fastCert11_1455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1455 : checkCertificateFast 11 1455 fastCert11_1455=true := by decide +kernel
def fastCert11_1456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1456 : checkCertificateFast 11 1456 fastCert11_1456=true := by decide +kernel
def fastCert11_1457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1457 : checkCertificateFast 11 1457 fastCert11_1457=true := by decide +kernel
def fastCert11_1458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1458 : checkCertificateFast 11 1458 fastCert11_1458=true := by decide +kernel
def fastCert11_1459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1459 : checkCertificateFast 11 1459 fastCert11_1459=true := by decide +kernel
def fastCert11_1460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1460 : checkCertificateFast 11 1460 fastCert11_1460=true := by decide +kernel
def fastCert11_1461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1461 : checkCertificateFast 11 1461 fastCert11_1461=true := by decide +kernel
def fastCert11_1462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1462 : checkCertificateFast 11 1462 fastCert11_1462=true := by decide +kernel
def fastCert11_1463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1463 : checkCertificateFast 11 1463 fastCert11_1463=true := by decide +kernel
def fastCert11_1464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1464 : checkCertificateFast 11 1464 fastCert11_1464=true := by decide +kernel
def fastCert11_1465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1465 : checkCertificateFast 11 1465 fastCert11_1465=true := by decide +kernel
def fastCert11_1466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1466 : checkCertificateFast 11 1466 fastCert11_1466=true := by decide +kernel
def fastCert11_1467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1467 : checkCertificateFast 11 1467 fastCert11_1467=true := by decide +kernel
def fastCert11_1468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1468 : checkCertificateFast 11 1468 fastCert11_1468=true := by decide +kernel
def fastCert11_1469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1469 : checkCertificateFast 11 1469 fastCert11_1469=true := by decide +kernel
def fastCert11_1470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1470 : checkCertificateFast 11 1470 fastCert11_1470=true := by decide +kernel
def fastCert11_1471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1471 : checkCertificateFast 11 1471 fastCert11_1471=true := by decide +kernel
def fastCert11_1472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1472 : checkCertificateFast 11 1472 fastCert11_1472=true := by decide +kernel
def fastCert11_1473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1473 : checkCertificateFast 11 1473 fastCert11_1473=true := by decide +kernel
def fastCert11_1474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1474 : checkCertificateFast 11 1474 fastCert11_1474=true := by decide +kernel
def fastCert11_1475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1475 : checkCertificateFast 11 1475 fastCert11_1475=true := by decide +kernel
def fastCert11_1476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1476 : checkCertificateFast 11 1476 fastCert11_1476=true := by decide +kernel
def fastCert11_1477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1477 : checkCertificateFast 11 1477 fastCert11_1477=true := by decide +kernel
def fastCert11_1478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1478 : checkCertificateFast 11 1478 fastCert11_1478=true := by decide +kernel
def fastCert11_1479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1479 : checkCertificateFast 11 1479 fastCert11_1479=true := by decide +kernel
def fastCert11_1480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1480 : checkCertificateFast 11 1480 fastCert11_1480=true := by decide +kernel
def fastCert11_1481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1481 : checkCertificateFast 11 1481 fastCert11_1481=true := by decide +kernel
def fastCert11_1482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1482 : checkCertificateFast 11 1482 fastCert11_1482=true := by decide +kernel
def fastCert11_1483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1483 : checkCertificateFast 11 1483 fastCert11_1483=true := by decide +kernel
def fastCert11_1484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1484 : checkCertificateFast 11 1484 fastCert11_1484=true := by decide +kernel
def fastCert11_1485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1485 : checkCertificateFast 11 1485 fastCert11_1485=true := by decide +kernel
def fastCert11_1486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1486 : checkCertificateFast 11 1486 fastCert11_1486=true := by decide +kernel
def fastCert11_1487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1487 : checkCertificateFast 11 1487 fastCert11_1487=true := by decide +kernel
def fastCert11_1488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1488 : checkCertificateFast 11 1488 fastCert11_1488=true := by decide +kernel
def fastCert11_1489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1489 : checkCertificateFast 11 1489 fastCert11_1489=true := by decide +kernel
def fastCert11_1490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1490 : checkCertificateFast 11 1490 fastCert11_1490=true := by decide +kernel
def fastCert11_1491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1491 : checkCertificateFast 11 1491 fastCert11_1491=true := by decide +kernel
def fastCert11_1492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1492 : checkCertificateFast 11 1492 fastCert11_1492=true := by decide +kernel
def fastCert11_1493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1493 : checkCertificateFast 11 1493 fastCert11_1493=true := by decide +kernel
def fastCert11_1494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1494 : checkCertificateFast 11 1494 fastCert11_1494=true := by decide +kernel
def fastCert11_1495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1495 : checkCertificateFast 11 1495 fastCert11_1495=true := by decide +kernel
def fastCert11_1496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1496 : checkCertificateFast 11 1496 fastCert11_1496=true := by decide +kernel
def fastCert11_1497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1497 : checkCertificateFast 11 1497 fastCert11_1497=true := by decide +kernel
def fastCert11_1498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1498 : checkCertificateFast 11 1498 fastCert11_1498=true := by decide +kernel
def fastCert11_1499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1499 : checkCertificateFast 11 1499 fastCert11_1499=true := by decide +kernel
def fastCert11_1500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1500 : checkCertificateFast 11 1500 fastCert11_1500=true := by decide +kernel
def fastCert11_1501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1501 : checkCertificateFast 11 1501 fastCert11_1501=true := by decide +kernel
def fastCert11_1502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1502 : checkCertificateFast 11 1502 fastCert11_1502=true := by decide +kernel
def fastCert11_1503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1503 : checkCertificateFast 11 1503 fastCert11_1503=true := by decide +kernel
def fastCert11_1504 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1504 : checkCertificateFast 11 1504 fastCert11_1504=true := by decide +kernel
def fastCert11_1505 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1505 : checkCertificateFast 11 1505 fastCert11_1505=true := by decide +kernel
def fastCert11_1506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1506 : checkCertificateFast 11 1506 fastCert11_1506=true := by decide +kernel
def fastCert11_1507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1507 : checkCertificateFast 11 1507 fastCert11_1507=true := by decide +kernel
def fastCert11_1508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1508 : checkCertificateFast 11 1508 fastCert11_1508=true := by decide +kernel
def fastCert11_1509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1509 : checkCertificateFast 11 1509 fastCert11_1509=true := by decide +kernel
def fastCert11_1510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1510 : checkCertificateFast 11 1510 fastCert11_1510=true := by decide +kernel
def fastCert11_1511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1511 : checkCertificateFast 11 1511 fastCert11_1511=true := by decide +kernel
def fastCert11_1512 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1512 : checkCertificateFast 11 1512 fastCert11_1512=true := by decide +kernel
def fastCert11_1513 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1513 : checkCertificateFast 11 1513 fastCert11_1513=true := by decide +kernel
def fastCert11_1514 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1514 : checkCertificateFast 11 1514 fastCert11_1514=true := by decide +kernel
def fastCert11_1515 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1515 : checkCertificateFast 11 1515 fastCert11_1515=true := by decide +kernel
def fastCert11_1516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1516 : checkCertificateFast 11 1516 fastCert11_1516=true := by decide +kernel
def fastCert11_1517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1517 : checkCertificateFast 11 1517 fastCert11_1517=true := by decide +kernel
def fastCert11_1518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1518 : checkCertificateFast 11 1518 fastCert11_1518=true := by decide +kernel
def fastCert11_1519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1519 : checkCertificateFast 11 1519 fastCert11_1519=true := by decide +kernel
def fastCert11_1520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1520 : checkCertificateFast 11 1520 fastCert11_1520=true := by decide +kernel
def fastCert11_1521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1521 : checkCertificateFast 11 1521 fastCert11_1521=true := by decide +kernel
def fastCert11_1522 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1522 : checkCertificateFast 11 1522 fastCert11_1522=true := by decide +kernel
def fastCert11_1523 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1523 : checkCertificateFast 11 1523 fastCert11_1523=true := by decide +kernel
def fastCert11_1524 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1524 : checkCertificateFast 11 1524 fastCert11_1524=true := by decide +kernel
def fastCert11_1525 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1525 : checkCertificateFast 11 1525 fastCert11_1525=true := by decide +kernel
def fastCert11_1526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1526 : checkCertificateFast 11 1526 fastCert11_1526=true := by decide +kernel
def fastCert11_1527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1527 : checkCertificateFast 11 1527 fastCert11_1527=true := by decide +kernel
def fastCert11_1528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1528 : checkCertificateFast 11 1528 fastCert11_1528=true := by decide +kernel
def fastCert11_1529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1529 : checkCertificateFast 11 1529 fastCert11_1529=true := by decide +kernel
def fastCert11_1530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1530 : checkCertificateFast 11 1530 fastCert11_1530=true := by decide +kernel
def fastCert11_1531 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1531 : checkCertificateFast 11 1531 fastCert11_1531=true := by decide +kernel
def fastCert11_1532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1532 : checkCertificateFast 11 1532 fastCert11_1532=true := by decide +kernel
def fastCert11_1533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1533 : checkCertificateFast 11 1533 fastCert11_1533=true := by decide +kernel
def fastCert11_1534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1534 : checkCertificateFast 11 1534 fastCert11_1534=true := by decide +kernel
def fastCert11_1535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1535 : checkCertificateFast 11 1535 fastCert11_1535=true := by decide +kernel
def fastCert11_1536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1536 : checkCertificateFast 11 1536 fastCert11_1536=true := by decide +kernel
def fastCert11_1537 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1537 : checkCertificateFast 11 1537 fastCert11_1537=true := by decide +kernel
def fastCert11_1538 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1538 : checkCertificateFast 11 1538 fastCert11_1538=true := by decide +kernel
def fastCert11_1539 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1539 : checkCertificateFast 11 1539 fastCert11_1539=true := by decide +kernel
def fastCert11_1540 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1540 : checkCertificateFast 11 1540 fastCert11_1540=true := by decide +kernel
def fastCert11_1541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1541 : checkCertificateFast 11 1541 fastCert11_1541=true := by decide +kernel
def fastCert11_1542 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1542 : checkCertificateFast 11 1542 fastCert11_1542=true := by decide +kernel
def fastCert11_1543 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1543 : checkCertificateFast 11 1543 fastCert11_1543=true := by decide +kernel
def fastCert11_1544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1544 : checkCertificateFast 11 1544 fastCert11_1544=true := by decide +kernel
def fastCert11_1545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1545 : checkCertificateFast 11 1545 fastCert11_1545=true := by decide +kernel
def fastCert11_1546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1546 : checkCertificateFast 11 1546 fastCert11_1546=true := by decide +kernel
def fastCert11_1547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1547 : checkCertificateFast 11 1547 fastCert11_1547=true := by decide +kernel
def fastCert11_1548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1548 : checkCertificateFast 11 1548 fastCert11_1548=true := by decide +kernel
def fastCert11_1549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1549 : checkCertificateFast 11 1549 fastCert11_1549=true := by decide +kernel
def fastCert11_1550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1550 : checkCertificateFast 11 1550 fastCert11_1550=true := by decide +kernel
def fastCert11_1551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1551 : checkCertificateFast 11 1551 fastCert11_1551=true := by decide +kernel
def fastCert11_1552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1552 : checkCertificateFast 11 1552 fastCert11_1552=true := by decide +kernel
def fastCert11_1553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1553 : checkCertificateFast 11 1553 fastCert11_1553=true := by decide +kernel
def fastCert11_1554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1554 : checkCertificateFast 11 1554 fastCert11_1554=true := by decide +kernel
def fastCert11_1555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1555 : checkCertificateFast 11 1555 fastCert11_1555=true := by decide +kernel
def fastCert11_1556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1556 : checkCertificateFast 11 1556 fastCert11_1556=true := by decide +kernel
def fastCert11_1557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1557 : checkCertificateFast 11 1557 fastCert11_1557=true := by decide +kernel
def fastCert11_1558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1558 : checkCertificateFast 11 1558 fastCert11_1558=true := by decide +kernel
def fastCert11_1559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1559 : checkCertificateFast 11 1559 fastCert11_1559=true := by decide +kernel
def fastCert11_1560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1560 : checkCertificateFast 11 1560 fastCert11_1560=true := by decide +kernel
def fastCert11_1561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1561 : checkCertificateFast 11 1561 fastCert11_1561=true := by decide +kernel
def fastCert11_1562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1562 : checkCertificateFast 11 1562 fastCert11_1562=true := by decide +kernel
def fastCert11_1563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1563 : checkCertificateFast 11 1563 fastCert11_1563=true := by decide +kernel
def fastCert11_1564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1564 : checkCertificateFast 11 1564 fastCert11_1564=true := by decide +kernel
def fastCert11_1565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1565 : checkCertificateFast 11 1565 fastCert11_1565=true := by decide +kernel
def fastCert11_1566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1566 : checkCertificateFast 11 1566 fastCert11_1566=true := by decide +kernel
def fastCert11_1567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1567 : checkCertificateFast 11 1567 fastCert11_1567=true := by decide +kernel
def fastCert11_1568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1568 : checkCertificateFast 11 1568 fastCert11_1568=true := by decide +kernel
def fastCert11_1569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1569 : checkCertificateFast 11 1569 fastCert11_1569=true := by decide +kernel
def fastCert11_1570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1570 : checkCertificateFast 11 1570 fastCert11_1570=true := by decide +kernel
def fastCert11_1571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1571 : checkCertificateFast 11 1571 fastCert11_1571=true := by decide +kernel
def fastCert11_1572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1572 : checkCertificateFast 11 1572 fastCert11_1572=true := by decide +kernel
def fastCert11_1573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1573 : checkCertificateFast 11 1573 fastCert11_1573=true := by decide +kernel
def fastCert11_1574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1574 : checkCertificateFast 11 1574 fastCert11_1574=true := by decide +kernel
def fastCert11_1575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1575 : checkCertificateFast 11 1575 fastCert11_1575=true := by decide +kernel
def fastCert11_1576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1576 : checkCertificateFast 11 1576 fastCert11_1576=true := by decide +kernel
def fastCert11_1577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1577 : checkCertificateFast 11 1577 fastCert11_1577=true := by decide +kernel
def fastCert11_1578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1578 : checkCertificateFast 11 1578 fastCert11_1578=true := by decide +kernel
def fastCert11_1579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1579 : checkCertificateFast 11 1579 fastCert11_1579=true := by decide +kernel
def fastCert11_1580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1580 : checkCertificateFast 11 1580 fastCert11_1580=true := by decide +kernel
def fastCert11_1581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1581 : checkCertificateFast 11 1581 fastCert11_1581=true := by decide +kernel
def fastCert11_1582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1582 : checkCertificateFast 11 1582 fastCert11_1582=true := by decide +kernel
def fastCert11_1583 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1583 : checkCertificateFast 11 1583 fastCert11_1583=true := by decide +kernel
def fastCert11_1584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1584 : checkCertificateFast 11 1584 fastCert11_1584=true := by decide +kernel
def fastCert11_1585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1585 : checkCertificateFast 11 1585 fastCert11_1585=true := by decide +kernel
def fastCert11_1586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1586 : checkCertificateFast 11 1586 fastCert11_1586=true := by decide +kernel
def fastCert11_1587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1587 : checkCertificateFast 11 1587 fastCert11_1587=true := by decide +kernel
def fastCert11_1588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1588 : checkCertificateFast 11 1588 fastCert11_1588=true := by decide +kernel
def fastCert11_1589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1589 : checkCertificateFast 11 1589 fastCert11_1589=true := by decide +kernel
def fastCert11_1590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1590 : checkCertificateFast 11 1590 fastCert11_1590=true := by decide +kernel
def fastCert11_1591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1591 : checkCertificateFast 11 1591 fastCert11_1591=true := by decide +kernel
def fastCert11_1592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1592 : checkCertificateFast 11 1592 fastCert11_1592=true := by decide +kernel
def fastCert11_1593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1593 : checkCertificateFast 11 1593 fastCert11_1593=true := by decide +kernel
def fastCert11_1594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1594 : checkCertificateFast 11 1594 fastCert11_1594=true := by decide +kernel
def fastCert11_1595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1595 : checkCertificateFast 11 1595 fastCert11_1595=true := by decide +kernel
def fastCert11_1596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1596 : checkCertificateFast 11 1596 fastCert11_1596=true := by decide +kernel
def fastCert11_1597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1597 : checkCertificateFast 11 1597 fastCert11_1597=true := by decide +kernel
def fastCert11_1598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1598 : checkCertificateFast 11 1598 fastCert11_1598=true := by decide +kernel
def fastCert11_1599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1599 : checkCertificateFast 11 1599 fastCert11_1599=true := by decide +kernel
def fastCert11_1600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1600 : checkCertificateFast 11 1600 fastCert11_1600=true := by decide +kernel
def fastCert11_1601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1601 : checkCertificateFast 11 1601 fastCert11_1601=true := by decide +kernel
def fastCert11_1602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1602 : checkCertificateFast 11 1602 fastCert11_1602=true := by decide +kernel
def fastCert11_1603 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1603 : checkCertificateFast 11 1603 fastCert11_1603=true := by decide +kernel
def fastCert11_1604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1604 : checkCertificateFast 11 1604 fastCert11_1604=true := by decide +kernel
def fastCert11_1605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1605 : checkCertificateFast 11 1605 fastCert11_1605=true := by decide +kernel
def fastCert11_1606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1606 : checkCertificateFast 11 1606 fastCert11_1606=true := by decide +kernel
def fastCert11_1607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1607 : checkCertificateFast 11 1607 fastCert11_1607=true := by decide +kernel
def fastCert11_1608 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1608 : checkCertificateFast 11 1608 fastCert11_1608=true := by decide +kernel
def fastCert11_1609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1609 : checkCertificateFast 11 1609 fastCert11_1609=true := by decide +kernel
def fastCert11_1610 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1610 : checkCertificateFast 11 1610 fastCert11_1610=true := by decide +kernel
def fastCert11_1611 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1611 : checkCertificateFast 11 1611 fastCert11_1611=true := by decide +kernel
def fastCert11_1612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1612 : checkCertificateFast 11 1612 fastCert11_1612=true := by decide +kernel
def fastCert11_1613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1613 : checkCertificateFast 11 1613 fastCert11_1613=true := by decide +kernel
def fastCert11_1614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1614 : checkCertificateFast 11 1614 fastCert11_1614=true := by decide +kernel
def fastCert11_1615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1615 : checkCertificateFast 11 1615 fastCert11_1615=true := by decide +kernel
def fastCert11_1616 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1616 : checkCertificateFast 11 1616 fastCert11_1616=true := by decide +kernel
def fastCert11_1617 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1617 : checkCertificateFast 11 1617 fastCert11_1617=true := by decide +kernel
def fastCert11_1618 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1618 : checkCertificateFast 11 1618 fastCert11_1618=true := by decide +kernel
def fastCert11_1619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1619 : checkCertificateFast 11 1619 fastCert11_1619=true := by decide +kernel
def fastCert11_1620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1620 : checkCertificateFast 11 1620 fastCert11_1620=true := by decide +kernel
def fastCert11_1621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1621 : checkCertificateFast 11 1621 fastCert11_1621=true := by decide +kernel
def fastCert11_1622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1622 : checkCertificateFast 11 1622 fastCert11_1622=true := by decide +kernel
def fastCert11_1623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1623 : checkCertificateFast 11 1623 fastCert11_1623=true := by decide +kernel
def fastCert11_1624 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1624 : checkCertificateFast 11 1624 fastCert11_1624=true := by decide +kernel
def fastCert11_1625 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1625 : checkCertificateFast 11 1625 fastCert11_1625=true := by decide +kernel
def fastCert11_1626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1626 : checkCertificateFast 11 1626 fastCert11_1626=true := by decide +kernel
def fastCert11_1627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1627 : checkCertificateFast 11 1627 fastCert11_1627=true := by decide +kernel
def fastCert11_1628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1628 : checkCertificateFast 11 1628 fastCert11_1628=true := by decide +kernel
def fastCert11_1629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1629 : checkCertificateFast 11 1629 fastCert11_1629=true := by decide +kernel
def fastCert11_1630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1630 : checkCertificateFast 11 1630 fastCert11_1630=true := by decide +kernel
def fastCert11_1631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase11_1631 : checkCertificateFast 11 1631 fastCert11_1631=true := by decide +kernel
def fastCert11_1632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1632 : checkCertificateFast 11 1632 fastCert11_1632=true := by decide +kernel
def fastCert11_1633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1633 : checkCertificateFast 11 1633 fastCert11_1633=true := by decide +kernel
def fastCert11_1634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1634 : checkCertificateFast 11 1634 fastCert11_1634=true := by decide +kernel
def fastCert11_1635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1635 : checkCertificateFast 11 1635 fastCert11_1635=true := by decide +kernel
def fastCert11_1636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1636 : checkCertificateFast 11 1636 fastCert11_1636=true := by decide +kernel
def fastCert11_1637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1637 : checkCertificateFast 11 1637 fastCert11_1637=true := by decide +kernel
def fastCert11_1638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1638 : checkCertificateFast 11 1638 fastCert11_1638=true := by decide +kernel
def fastCert11_1639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1639 : checkCertificateFast 11 1639 fastCert11_1639=true := by decide +kernel
def fastCert11_1640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1640 : checkCertificateFast 11 1640 fastCert11_1640=true := by decide +kernel
def fastCert11_1641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1641 : checkCertificateFast 11 1641 fastCert11_1641=true := by decide +kernel
def fastCert11_1642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1642 : checkCertificateFast 11 1642 fastCert11_1642=true := by decide +kernel
def fastCert11_1643 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=17 then (1) else 0⟩
theorem fastCase11_1643 : checkCertificateFast 11 1643 fastCert11_1643=true := by decide +kernel
def fastCert11_1644 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1644 : checkCertificateFast 11 1644 fastCert11_1644=true := by decide +kernel
def fastCert11_1645 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1645 : checkCertificateFast 11 1645 fastCert11_1645=true := by decide +kernel
def fastCert11_1646 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1646 : checkCertificateFast 11 1646 fastCert11_1646=true := by decide +kernel
def fastCert11_1647 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1647 : checkCertificateFast 11 1647 fastCert11_1647=true := by decide +kernel
def fastCert11_1648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1648 : checkCertificateFast 11 1648 fastCert11_1648=true := by decide +kernel
def fastCert11_1649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1649 : checkCertificateFast 11 1649 fastCert11_1649=true := by decide +kernel
def fastCert11_1650 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1650 : checkCertificateFast 11 1650 fastCert11_1650=true := by decide +kernel
def fastCert11_1651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1651 : checkCertificateFast 11 1651 fastCert11_1651=true := by decide +kernel
def fastCert11_1652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1652 : checkCertificateFast 11 1652 fastCert11_1652=true := by decide +kernel
def fastCert11_1653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1653 : checkCertificateFast 11 1653 fastCert11_1653=true := by decide +kernel
def fastCert11_1654 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1654 : checkCertificateFast 11 1654 fastCert11_1654=true := by decide +kernel
def fastCert11_1655 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1655 : checkCertificateFast 11 1655 fastCert11_1655=true := by decide +kernel
def fastCert11_1656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1656 : checkCertificateFast 11 1656 fastCert11_1656=true := by decide +kernel
def fastCert11_1657 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1657 : checkCertificateFast 11 1657 fastCert11_1657=true := by decide +kernel
def fastCert11_1658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1658 : checkCertificateFast 11 1658 fastCert11_1658=true := by decide +kernel
def fastCert11_1659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1659 : checkCertificateFast 11 1659 fastCert11_1659=true := by decide +kernel
def fastCert11_1660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1660 : checkCertificateFast 11 1660 fastCert11_1660=true := by decide +kernel
def fastCert11_1661 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1661 : checkCertificateFast 11 1661 fastCert11_1661=true := by decide +kernel
def fastCert11_1662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1662 : checkCertificateFast 11 1662 fastCert11_1662=true := by decide +kernel
def fastCert11_1663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1663 : checkCertificateFast 11 1663 fastCert11_1663=true := by decide +kernel
def fastCert11_1664 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1664 : checkCertificateFast 11 1664 fastCert11_1664=true := by decide +kernel
def fastCert11_1665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1665 : checkCertificateFast 11 1665 fastCert11_1665=true := by decide +kernel
def fastCert11_1666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1666 : checkCertificateFast 11 1666 fastCert11_1666=true := by decide +kernel
def fastCert11_1667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1667 : checkCertificateFast 11 1667 fastCert11_1667=true := by decide +kernel
def fastCert11_1668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1668 : checkCertificateFast 11 1668 fastCert11_1668=true := by decide +kernel
def fastCert11_1669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1669 : checkCertificateFast 11 1669 fastCert11_1669=true := by decide +kernel
def fastCert11_1670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1670 : checkCertificateFast 11 1670 fastCert11_1670=true := by decide +kernel
def fastCert11_1671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1671 : checkCertificateFast 11 1671 fastCert11_1671=true := by decide +kernel
def fastCert11_1672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1672 : checkCertificateFast 11 1672 fastCert11_1672=true := by decide +kernel
def fastCert11_1673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1673 : checkCertificateFast 11 1673 fastCert11_1673=true := by decide +kernel
def fastCert11_1674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1674 : checkCertificateFast 11 1674 fastCert11_1674=true := by decide +kernel
def fastCert11_1675 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1675 : checkCertificateFast 11 1675 fastCert11_1675=true := by decide +kernel
def fastCert11_1676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1676 : checkCertificateFast 11 1676 fastCert11_1676=true := by decide +kernel
def fastCert11_1677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1677 : checkCertificateFast 11 1677 fastCert11_1677=true := by decide +kernel
def fastCert11_1678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1678 : checkCertificateFast 11 1678 fastCert11_1678=true := by decide +kernel
def fastCert11_1679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1679 : checkCertificateFast 11 1679 fastCert11_1679=true := by decide +kernel
def fastCert11_1680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1680 : checkCertificateFast 11 1680 fastCert11_1680=true := by decide +kernel
def fastCert11_1681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1681 : checkCertificateFast 11 1681 fastCert11_1681=true := by decide +kernel
def fastCert11_1682 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1682 : checkCertificateFast 11 1682 fastCert11_1682=true := by decide +kernel
def fastCert11_1683 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1683 : checkCertificateFast 11 1683 fastCert11_1683=true := by decide +kernel
def fastCert11_1684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1684 : checkCertificateFast 11 1684 fastCert11_1684=true := by decide +kernel
def fastCert11_1685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1685 : checkCertificateFast 11 1685 fastCert11_1685=true := by decide +kernel
def fastCert11_1686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1686 : checkCertificateFast 11 1686 fastCert11_1686=true := by decide +kernel
def fastCert11_1687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1687 : checkCertificateFast 11 1687 fastCert11_1687=true := by decide +kernel
def fastCert11_1688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1688 : checkCertificateFast 11 1688 fastCert11_1688=true := by decide +kernel
def fastCert11_1689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1689 : checkCertificateFast 11 1689 fastCert11_1689=true := by decide +kernel
def fastCert11_1690 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1690 : checkCertificateFast 11 1690 fastCert11_1690=true := by decide +kernel
def fastCert11_1691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1691 : checkCertificateFast 11 1691 fastCert11_1691=true := by decide +kernel
def fastCert11_1692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1692 : checkCertificateFast 11 1692 fastCert11_1692=true := by decide +kernel
def fastCert11_1693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1693 : checkCertificateFast 11 1693 fastCert11_1693=true := by decide +kernel
def fastCert11_1694 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1694 : checkCertificateFast 11 1694 fastCert11_1694=true := by decide +kernel
def fastCert11_1695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1695 : checkCertificateFast 11 1695 fastCert11_1695=true := by decide +kernel
def fastCert11_1696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1696 : checkCertificateFast 11 1696 fastCert11_1696=true := by decide +kernel
def fastCert11_1697 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1697 : checkCertificateFast 11 1697 fastCert11_1697=true := by decide +kernel
def fastCert11_1698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1698 : checkCertificateFast 11 1698 fastCert11_1698=true := by decide +kernel
def fastCert11_1699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1699 : checkCertificateFast 11 1699 fastCert11_1699=true := by decide +kernel
def fastCert11_1700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1700 : checkCertificateFast 11 1700 fastCert11_1700=true := by decide +kernel
def fastCert11_1701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1701 : checkCertificateFast 11 1701 fastCert11_1701=true := by decide +kernel
def fastCert11_1702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1702 : checkCertificateFast 11 1702 fastCert11_1702=true := by decide +kernel
def fastCert11_1703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1703 : checkCertificateFast 11 1703 fastCert11_1703=true := by decide +kernel
def fastCert11_1704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1704 : checkCertificateFast 11 1704 fastCert11_1704=true := by decide +kernel
def fastCert11_1705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1705 : checkCertificateFast 11 1705 fastCert11_1705=true := by decide +kernel
def fastCert11_1706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1706 : checkCertificateFast 11 1706 fastCert11_1706=true := by decide +kernel
def fastCert11_1707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1707 : checkCertificateFast 11 1707 fastCert11_1707=true := by decide +kernel
def fastCert11_1708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1708 : checkCertificateFast 11 1708 fastCert11_1708=true := by decide +kernel
def fastCert11_1709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1709 : checkCertificateFast 11 1709 fastCert11_1709=true := by decide +kernel
def fastCert11_1710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1710 : checkCertificateFast 11 1710 fastCert11_1710=true := by decide +kernel
def fastCert11_1711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1711 : checkCertificateFast 11 1711 fastCert11_1711=true := by decide +kernel
def fastCert11_1712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1712 : checkCertificateFast 11 1712 fastCert11_1712=true := by decide +kernel
def fastCert11_1713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1713 : checkCertificateFast 11 1713 fastCert11_1713=true := by decide +kernel
def fastCert11_1714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1714 : checkCertificateFast 11 1714 fastCert11_1714=true := by decide +kernel
def fastCert11_1715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1715 : checkCertificateFast 11 1715 fastCert11_1715=true := by decide +kernel
def fastCert11_1716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1716 : checkCertificateFast 11 1716 fastCert11_1716=true := by decide +kernel
def fastCert11_1717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1717 : checkCertificateFast 11 1717 fastCert11_1717=true := by decide +kernel
def fastCert11_1718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1718 : checkCertificateFast 11 1718 fastCert11_1718=true := by decide +kernel
def fastCert11_1719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1719 : checkCertificateFast 11 1719 fastCert11_1719=true := by decide +kernel
def fastCert11_1720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1720 : checkCertificateFast 11 1720 fastCert11_1720=true := by decide +kernel
def fastCert11_1721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1721 : checkCertificateFast 11 1721 fastCert11_1721=true := by decide +kernel
def fastCert11_1722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1722 : checkCertificateFast 11 1722 fastCert11_1722=true := by decide +kernel
def fastCert11_1723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1723 : checkCertificateFast 11 1723 fastCert11_1723=true := by decide +kernel
def fastCert11_1724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1724 : checkCertificateFast 11 1724 fastCert11_1724=true := by decide +kernel
def fastCert11_1725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1725 : checkCertificateFast 11 1725 fastCert11_1725=true := by decide +kernel
def fastCert11_1726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1726 : checkCertificateFast 11 1726 fastCert11_1726=true := by decide +kernel
def fastCert11_1727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1727 : checkCertificateFast 11 1727 fastCert11_1727=true := by decide +kernel
def fastCert11_1728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1728 : checkCertificateFast 11 1728 fastCert11_1728=true := by decide +kernel
def fastCert11_1729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1729 : checkCertificateFast 11 1729 fastCert11_1729=true := by decide +kernel
def fastCert11_1730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1730 : checkCertificateFast 11 1730 fastCert11_1730=true := by decide +kernel
def fastCert11_1731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1731 : checkCertificateFast 11 1731 fastCert11_1731=true := by decide +kernel
def fastCert11_1732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1732 : checkCertificateFast 11 1732 fastCert11_1732=true := by decide +kernel
def fastCert11_1733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1733 : checkCertificateFast 11 1733 fastCert11_1733=true := by decide +kernel
def fastCert11_1734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1734 : checkCertificateFast 11 1734 fastCert11_1734=true := by decide +kernel
def fastCert11_1735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1735 : checkCertificateFast 11 1735 fastCert11_1735=true := by decide +kernel
def fastCert11_1736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1736 : checkCertificateFast 11 1736 fastCert11_1736=true := by decide +kernel
def fastCert11_1737 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1737 : checkCertificateFast 11 1737 fastCert11_1737=true := by decide +kernel
def fastCert11_1738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1738 : checkCertificateFast 11 1738 fastCert11_1738=true := by decide +kernel
def fastCert11_1739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1739 : checkCertificateFast 11 1739 fastCert11_1739=true := by decide +kernel
def fastCert11_1740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1740 : checkCertificateFast 11 1740 fastCert11_1740=true := by decide +kernel
def fastCert11_1741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1741 : checkCertificateFast 11 1741 fastCert11_1741=true := by decide +kernel
def fastCert11_1742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1742 : checkCertificateFast 11 1742 fastCert11_1742=true := by decide +kernel
def fastCert11_1743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1743 : checkCertificateFast 11 1743 fastCert11_1743=true := by decide +kernel
def fastCert11_1744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1744 : checkCertificateFast 11 1744 fastCert11_1744=true := by decide +kernel
def fastCert11_1745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1745 : checkCertificateFast 11 1745 fastCert11_1745=true := by decide +kernel
def fastCert11_1746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1746 : checkCertificateFast 11 1746 fastCert11_1746=true := by decide +kernel
def fastCert11_1747 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1747 : checkCertificateFast 11 1747 fastCert11_1747=true := by decide +kernel
def fastCert11_1748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1748 : checkCertificateFast 11 1748 fastCert11_1748=true := by decide +kernel
def fastCert11_1749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1749 : checkCertificateFast 11 1749 fastCert11_1749=true := by decide +kernel
def fastCert11_1750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1750 : checkCertificateFast 11 1750 fastCert11_1750=true := by decide +kernel
def fastCert11_1751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1751 : checkCertificateFast 11 1751 fastCert11_1751=true := by decide +kernel
def fastCert11_1752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1752 : checkCertificateFast 11 1752 fastCert11_1752=true := by decide +kernel
def fastCert11_1753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1753 : checkCertificateFast 11 1753 fastCert11_1753=true := by decide +kernel
def fastCert11_1754 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1754 : checkCertificateFast 11 1754 fastCert11_1754=true := by decide +kernel
def fastCert11_1755 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1755 : checkCertificateFast 11 1755 fastCert11_1755=true := by decide +kernel
def fastCert11_1756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1756 : checkCertificateFast 11 1756 fastCert11_1756=true := by decide +kernel
def fastCert11_1757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1757 : checkCertificateFast 11 1757 fastCert11_1757=true := by decide +kernel
def fastCert11_1758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1758 : checkCertificateFast 11 1758 fastCert11_1758=true := by decide +kernel
def fastCert11_1759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1759 : checkCertificateFast 11 1759 fastCert11_1759=true := by decide +kernel
def fastCert11_1760 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1760 : checkCertificateFast 11 1760 fastCert11_1760=true := by decide +kernel
def fastCert11_1761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1761 : checkCertificateFast 11 1761 fastCert11_1761=true := by decide +kernel
def fastCert11_1762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1762 : checkCertificateFast 11 1762 fastCert11_1762=true := by decide +kernel
def fastCert11_1763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1763 : checkCertificateFast 11 1763 fastCert11_1763=true := by decide +kernel
def fastCert11_1764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1764 : checkCertificateFast 11 1764 fastCert11_1764=true := by decide +kernel
def fastCert11_1765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1765 : checkCertificateFast 11 1765 fastCert11_1765=true := by decide +kernel
def fastCert11_1766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1766 : checkCertificateFast 11 1766 fastCert11_1766=true := by decide +kernel
def fastCert11_1767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1767 : checkCertificateFast 11 1767 fastCert11_1767=true := by decide +kernel
def fastCert11_1768 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1768 : checkCertificateFast 11 1768 fastCert11_1768=true := by decide +kernel
def fastCert11_1769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1769 : checkCertificateFast 11 1769 fastCert11_1769=true := by decide +kernel
def fastCert11_1770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1770 : checkCertificateFast 11 1770 fastCert11_1770=true := by decide +kernel
def fastCert11_1771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1771 : checkCertificateFast 11 1771 fastCert11_1771=true := by decide +kernel
def fastCert11_1772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1772 : checkCertificateFast 11 1772 fastCert11_1772=true := by decide +kernel
def fastCert11_1773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1773 : checkCertificateFast 11 1773 fastCert11_1773=true := by decide +kernel
def fastCert11_1774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1774 : checkCertificateFast 11 1774 fastCert11_1774=true := by decide +kernel
def fastCert11_1775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1775 : checkCertificateFast 11 1775 fastCert11_1775=true := by decide +kernel
def fastCert11_1776 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1776 : checkCertificateFast 11 1776 fastCert11_1776=true := by decide +kernel
def fastCert11_1777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1777 : checkCertificateFast 11 1777 fastCert11_1777=true := by decide +kernel
def fastCert11_1778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1778 : checkCertificateFast 11 1778 fastCert11_1778=true := by decide +kernel
def fastCert11_1779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1779 : checkCertificateFast 11 1779 fastCert11_1779=true := by decide +kernel
def fastCert11_1780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1780 : checkCertificateFast 11 1780 fastCert11_1780=true := by decide +kernel
def fastCert11_1781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1781 : checkCertificateFast 11 1781 fastCert11_1781=true := by decide +kernel
def fastCert11_1782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1782 : checkCertificateFast 11 1782 fastCert11_1782=true := by decide +kernel
def fastCert11_1783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1783 : checkCertificateFast 11 1783 fastCert11_1783=true := by decide +kernel
def fastCert11_1784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1784 : checkCertificateFast 11 1784 fastCert11_1784=true := by decide +kernel
def fastCert11_1785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1785 : checkCertificateFast 11 1785 fastCert11_1785=true := by decide +kernel
def fastCert11_1786 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1786 : checkCertificateFast 11 1786 fastCert11_1786=true := by decide +kernel
def fastCert11_1787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1787 : checkCertificateFast 11 1787 fastCert11_1787=true := by decide +kernel
def fastCert11_1788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1788 : checkCertificateFast 11 1788 fastCert11_1788=true := by decide +kernel
def fastCert11_1789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1789 : checkCertificateFast 11 1789 fastCert11_1789=true := by decide +kernel
def fastCert11_1790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1790 : checkCertificateFast 11 1790 fastCert11_1790=true := by decide +kernel
def fastCert11_1791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1791 : checkCertificateFast 11 1791 fastCert11_1791=true := by decide +kernel
def fastCert11_1792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1792 : checkCertificateFast 11 1792 fastCert11_1792=true := by decide +kernel
def fastCert11_1793 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1793 : checkCertificateFast 11 1793 fastCert11_1793=true := by decide +kernel
def fastCert11_1794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1794 : checkCertificateFast 11 1794 fastCert11_1794=true := by decide +kernel
def fastCert11_1795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1795 : checkCertificateFast 11 1795 fastCert11_1795=true := by decide +kernel
def fastCert11_1796 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1796 : checkCertificateFast 11 1796 fastCert11_1796=true := by decide +kernel
def fastCert11_1797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1797 : checkCertificateFast 11 1797 fastCert11_1797=true := by decide +kernel
def fastCert11_1798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1798 : checkCertificateFast 11 1798 fastCert11_1798=true := by decide +kernel
def fastCert11_1799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1799 : checkCertificateFast 11 1799 fastCert11_1799=true := by decide +kernel
def fastCert11_1800 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1800 : checkCertificateFast 11 1800 fastCert11_1800=true := by decide +kernel
def fastCert11_1801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1801 : checkCertificateFast 11 1801 fastCert11_1801=true := by decide +kernel
def fastCert11_1802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1802 : checkCertificateFast 11 1802 fastCert11_1802=true := by decide +kernel
def fastCert11_1803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1803 : checkCertificateFast 11 1803 fastCert11_1803=true := by decide +kernel
def fastCert11_1804 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1804 : checkCertificateFast 11 1804 fastCert11_1804=true := by decide +kernel
def fastCert11_1805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1805 : checkCertificateFast 11 1805 fastCert11_1805=true := by decide +kernel
def fastCert11_1806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1806 : checkCertificateFast 11 1806 fastCert11_1806=true := by decide +kernel
def fastCert11_1807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1807 : checkCertificateFast 11 1807 fastCert11_1807=true := by decide +kernel
def fastCert11_1808 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1808 : checkCertificateFast 11 1808 fastCert11_1808=true := by decide +kernel
def fastCert11_1809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1809 : checkCertificateFast 11 1809 fastCert11_1809=true := by decide +kernel
def fastCert11_1810 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1810 : checkCertificateFast 11 1810 fastCert11_1810=true := by decide +kernel
def fastCert11_1811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1811 : checkCertificateFast 11 1811 fastCert11_1811=true := by decide +kernel
def fastCert11_1812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1812 : checkCertificateFast 11 1812 fastCert11_1812=true := by decide +kernel
def fastCert11_1813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1813 : checkCertificateFast 11 1813 fastCert11_1813=true := by decide +kernel
def fastCert11_1814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1814 : checkCertificateFast 11 1814 fastCert11_1814=true := by decide +kernel
def fastCert11_1815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1815 : checkCertificateFast 11 1815 fastCert11_1815=true := by decide +kernel
def fastCert11_1816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1816 : checkCertificateFast 11 1816 fastCert11_1816=true := by decide +kernel
def fastCert11_1817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1817 : checkCertificateFast 11 1817 fastCert11_1817=true := by decide +kernel
def fastCert11_1818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1818 : checkCertificateFast 11 1818 fastCert11_1818=true := by decide +kernel
def fastCert11_1819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1819 : checkCertificateFast 11 1819 fastCert11_1819=true := by decide +kernel
def fastCert11_1820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1820 : checkCertificateFast 11 1820 fastCert11_1820=true := by decide +kernel
def fastCert11_1821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1821 : checkCertificateFast 11 1821 fastCert11_1821=true := by decide +kernel
def fastCert11_1822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1822 : checkCertificateFast 11 1822 fastCert11_1822=true := by decide +kernel
def fastCert11_1823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1823 : checkCertificateFast 11 1823 fastCert11_1823=true := by decide +kernel
def fastCert11_1824 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1824 : checkCertificateFast 11 1824 fastCert11_1824=true := by decide +kernel
def fastCert11_1825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1825 : checkCertificateFast 11 1825 fastCert11_1825=true := by decide +kernel
def fastCert11_1826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1826 : checkCertificateFast 11 1826 fastCert11_1826=true := by decide +kernel
def fastCert11_1827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1827 : checkCertificateFast 11 1827 fastCert11_1827=true := by decide +kernel
def fastCert11_1828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1828 : checkCertificateFast 11 1828 fastCert11_1828=true := by decide +kernel
def fastCert11_1829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1829 : checkCertificateFast 11 1829 fastCert11_1829=true := by decide +kernel
def fastCert11_1830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1830 : checkCertificateFast 11 1830 fastCert11_1830=true := by decide +kernel
def fastCert11_1831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1831 : checkCertificateFast 11 1831 fastCert11_1831=true := by decide +kernel
def fastCert11_1832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1832 : checkCertificateFast 11 1832 fastCert11_1832=true := by decide +kernel
def fastCert11_1833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1833 : checkCertificateFast 11 1833 fastCert11_1833=true := by decide +kernel
def fastCert11_1834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1834 : checkCertificateFast 11 1834 fastCert11_1834=true := by decide +kernel
def fastCert11_1835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1835 : checkCertificateFast 11 1835 fastCert11_1835=true := by decide +kernel
def fastCert11_1836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1836 : checkCertificateFast 11 1836 fastCert11_1836=true := by decide +kernel
def fastCert11_1837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1837 : checkCertificateFast 11 1837 fastCert11_1837=true := by decide +kernel
def fastCert11_1838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1838 : checkCertificateFast 11 1838 fastCert11_1838=true := by decide +kernel
def fastCert11_1839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1839 : checkCertificateFast 11 1839 fastCert11_1839=true := by decide +kernel
def fastCert11_1840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1840 : checkCertificateFast 11 1840 fastCert11_1840=true := by decide +kernel
def fastCert11_1841 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1841 : checkCertificateFast 11 1841 fastCert11_1841=true := by decide +kernel
def fastCert11_1842 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1842 : checkCertificateFast 11 1842 fastCert11_1842=true := by decide +kernel
def fastCert11_1843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1843 : checkCertificateFast 11 1843 fastCert11_1843=true := by decide +kernel
def fastCert11_1844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1844 : checkCertificateFast 11 1844 fastCert11_1844=true := by decide +kernel
def fastCert11_1845 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1845 : checkCertificateFast 11 1845 fastCert11_1845=true := by decide +kernel
def fastCert11_1846 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1846 : checkCertificateFast 11 1846 fastCert11_1846=true := by decide +kernel
def fastCert11_1847 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1847 : checkCertificateFast 11 1847 fastCert11_1847=true := by decide +kernel
def fastCert11_1848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1848 : checkCertificateFast 11 1848 fastCert11_1848=true := by decide +kernel
def fastCert11_1849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1849 : checkCertificateFast 11 1849 fastCert11_1849=true := by decide +kernel
def fastCert11_1850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1850 : checkCertificateFast 11 1850 fastCert11_1850=true := by decide +kernel
def fastCert11_1851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1851 : checkCertificateFast 11 1851 fastCert11_1851=true := by decide +kernel
def fastCert11_1852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1852 : checkCertificateFast 11 1852 fastCert11_1852=true := by decide +kernel
def fastCert11_1853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1853 : checkCertificateFast 11 1853 fastCert11_1853=true := by decide +kernel
def fastCert11_1854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1854 : checkCertificateFast 11 1854 fastCert11_1854=true := by decide +kernel
def fastCert11_1855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1855 : checkCertificateFast 11 1855 fastCert11_1855=true := by decide +kernel
def fastCert11_1856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1856 : checkCertificateFast 11 1856 fastCert11_1856=true := by decide +kernel
def fastCert11_1857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1857 : checkCertificateFast 11 1857 fastCert11_1857=true := by decide +kernel
def fastCert11_1858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1858 : checkCertificateFast 11 1858 fastCert11_1858=true := by decide +kernel
def fastCert11_1859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1859 : checkCertificateFast 11 1859 fastCert11_1859=true := by decide +kernel
def fastCert11_1860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1860 : checkCertificateFast 11 1860 fastCert11_1860=true := by decide +kernel
def fastCert11_1861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1861 : checkCertificateFast 11 1861 fastCert11_1861=true := by decide +kernel
def fastCert11_1862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1862 : checkCertificateFast 11 1862 fastCert11_1862=true := by decide +kernel
def fastCert11_1863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1863 : checkCertificateFast 11 1863 fastCert11_1863=true := by decide +kernel
def fastCert11_1864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1864 : checkCertificateFast 11 1864 fastCert11_1864=true := by decide +kernel
def fastCert11_1865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1865 : checkCertificateFast 11 1865 fastCert11_1865=true := by decide +kernel
def fastCert11_1866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1866 : checkCertificateFast 11 1866 fastCert11_1866=true := by decide +kernel
def fastCert11_1867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1867 : checkCertificateFast 11 1867 fastCert11_1867=true := by decide +kernel
def fastCert11_1868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1868 : checkCertificateFast 11 1868 fastCert11_1868=true := by decide +kernel
def fastCert11_1869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1869 : checkCertificateFast 11 1869 fastCert11_1869=true := by decide +kernel
def fastCert11_1870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1870 : checkCertificateFast 11 1870 fastCert11_1870=true := by decide +kernel
def fastCert11_1871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1871 : checkCertificateFast 11 1871 fastCert11_1871=true := by decide +kernel
def fastCert11_1872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1872 : checkCertificateFast 11 1872 fastCert11_1872=true := by decide +kernel
def fastCert11_1873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1873 : checkCertificateFast 11 1873 fastCert11_1873=true := by decide +kernel
def fastCert11_1874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1874 : checkCertificateFast 11 1874 fastCert11_1874=true := by decide +kernel
def fastCert11_1875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1875 : checkCertificateFast 11 1875 fastCert11_1875=true := by decide +kernel
def fastCert11_1876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1876 : checkCertificateFast 11 1876 fastCert11_1876=true := by decide +kernel
def fastCert11_1877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1877 : checkCertificateFast 11 1877 fastCert11_1877=true := by decide +kernel
def fastCert11_1878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1878 : checkCertificateFast 11 1878 fastCert11_1878=true := by decide +kernel
def fastCert11_1879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1879 : checkCertificateFast 11 1879 fastCert11_1879=true := by decide +kernel
def fastCert11_1880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1880 : checkCertificateFast 11 1880 fastCert11_1880=true := by decide +kernel
def fastCert11_1881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1881 : checkCertificateFast 11 1881 fastCert11_1881=true := by decide +kernel
def fastCert11_1882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1882 : checkCertificateFast 11 1882 fastCert11_1882=true := by decide +kernel
def fastCert11_1883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1883 : checkCertificateFast 11 1883 fastCert11_1883=true := by decide +kernel
def fastCert11_1884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1884 : checkCertificateFast 11 1884 fastCert11_1884=true := by decide +kernel
def fastCert11_1885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1885 : checkCertificateFast 11 1885 fastCert11_1885=true := by decide +kernel
def fastCert11_1886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1886 : checkCertificateFast 11 1886 fastCert11_1886=true := by decide +kernel
def fastCert11_1887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1887 : checkCertificateFast 11 1887 fastCert11_1887=true := by decide +kernel
def fastCert11_1888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1888 : checkCertificateFast 11 1888 fastCert11_1888=true := by decide +kernel
def fastCert11_1889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1889 : checkCertificateFast 11 1889 fastCert11_1889=true := by decide +kernel
def fastCert11_1890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1890 : checkCertificateFast 11 1890 fastCert11_1890=true := by decide +kernel
def fastCert11_1891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=17 then (1) else 0⟩
theorem fastCase11_1891 : checkCertificateFast 11 1891 fastCert11_1891=true := by decide +kernel
def fastCert11_1892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1892 : checkCertificateFast 11 1892 fastCert11_1892=true := by decide +kernel
def fastCert11_1893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1893 : checkCertificateFast 11 1893 fastCert11_1893=true := by decide +kernel
def fastCert11_1894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1894 : checkCertificateFast 11 1894 fastCert11_1894=true := by decide +kernel
def fastCert11_1895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1895 : checkCertificateFast 11 1895 fastCert11_1895=true := by decide +kernel
def fastCert11_1896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase11_1896 : checkCertificateFast 11 1896 fastCert11_1896=true := by decide +kernel
def fastCert11_1897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase11_1897 : checkCertificateFast 11 1897 fastCert11_1897=true := by decide +kernel
def fastCert11_1898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1898 : checkCertificateFast 11 1898 fastCert11_1898=true := by decide +kernel
def fastCert11_1899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1899 : checkCertificateFast 11 1899 fastCert11_1899=true := by decide +kernel
def fastCert11_1900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1900 : checkCertificateFast 11 1900 fastCert11_1900=true := by decide +kernel
def fastCert11_1901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1901 : checkCertificateFast 11 1901 fastCert11_1901=true := by decide +kernel
def fastCert11_1902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1902 : checkCertificateFast 11 1902 fastCert11_1902=true := by decide +kernel
def fastCert11_1903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1903 : checkCertificateFast 11 1903 fastCert11_1903=true := by decide +kernel
def fastCert11_1904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1904 : checkCertificateFast 11 1904 fastCert11_1904=true := by decide +kernel
def fastCert11_1905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1905 : checkCertificateFast 11 1905 fastCert11_1905=true := by decide +kernel
def fastCert11_1906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1906 : checkCertificateFast 11 1906 fastCert11_1906=true := by decide +kernel
def fastCert11_1907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1907 : checkCertificateFast 11 1907 fastCert11_1907=true := by decide +kernel
def fastCert11_1908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1908 : checkCertificateFast 11 1908 fastCert11_1908=true := by decide +kernel
def fastCert11_1909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1909 : checkCertificateFast 11 1909 fastCert11_1909=true := by decide +kernel
def fastCert11_1910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1910 : checkCertificateFast 11 1910 fastCert11_1910=true := by decide +kernel
def fastCert11_1911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1911 : checkCertificateFast 11 1911 fastCert11_1911=true := by decide +kernel
def fastCert11_1912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1912 : checkCertificateFast 11 1912 fastCert11_1912=true := by decide +kernel
def fastCert11_1913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1913 : checkCertificateFast 11 1913 fastCert11_1913=true := by decide +kernel
def fastCert11_1914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1914 : checkCertificateFast 11 1914 fastCert11_1914=true := by decide +kernel
def fastCert11_1915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1915 : checkCertificateFast 11 1915 fastCert11_1915=true := by decide +kernel
def fastCert11_1916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1916 : checkCertificateFast 11 1916 fastCert11_1916=true := by decide +kernel
def fastCert11_1917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1917 : checkCertificateFast 11 1917 fastCert11_1917=true := by decide +kernel
def fastCert11_1918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1918 : checkCertificateFast 11 1918 fastCert11_1918=true := by decide +kernel
def fastCert11_1919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1919 : checkCertificateFast 11 1919 fastCert11_1919=true := by decide +kernel
def fastCert11_1920 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1920 : checkCertificateFast 11 1920 fastCert11_1920=true := by decide +kernel
def fastCert11_1921 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1921 : checkCertificateFast 11 1921 fastCert11_1921=true := by decide +kernel
def fastCert11_1922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1922 : checkCertificateFast 11 1922 fastCert11_1922=true := by decide +kernel
def fastCert11_1923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1923 : checkCertificateFast 11 1923 fastCert11_1923=true := by decide +kernel
def fastCert11_1924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1924 : checkCertificateFast 11 1924 fastCert11_1924=true := by decide +kernel
def fastCert11_1925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1925 : checkCertificateFast 11 1925 fastCert11_1925=true := by decide +kernel
def fastCert11_1926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1926 : checkCertificateFast 11 1926 fastCert11_1926=true := by decide +kernel
def fastCert11_1927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1927 : checkCertificateFast 11 1927 fastCert11_1927=true := by decide +kernel
def fastCert11_1928 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1928 : checkCertificateFast 11 1928 fastCert11_1928=true := by decide +kernel
def fastCert11_1929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1929 : checkCertificateFast 11 1929 fastCert11_1929=true := by decide +kernel
def fastCert11_1930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1930 : checkCertificateFast 11 1930 fastCert11_1930=true := by decide +kernel
def fastCert11_1931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1931 : checkCertificateFast 11 1931 fastCert11_1931=true := by decide +kernel
def fastCert11_1932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1932 : checkCertificateFast 11 1932 fastCert11_1932=true := by decide +kernel
def fastCert11_1933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1933 : checkCertificateFast 11 1933 fastCert11_1933=true := by decide +kernel
def fastCert11_1934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1934 : checkCertificateFast 11 1934 fastCert11_1934=true := by decide +kernel
def fastCert11_1935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1935 : checkCertificateFast 11 1935 fastCert11_1935=true := by decide +kernel
def fastCert11_1936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1936 : checkCertificateFast 11 1936 fastCert11_1936=true := by decide +kernel
def fastCert11_1937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1937 : checkCertificateFast 11 1937 fastCert11_1937=true := by decide +kernel
def fastCert11_1938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1938 : checkCertificateFast 11 1938 fastCert11_1938=true := by decide +kernel
def fastCert11_1939 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1939 : checkCertificateFast 11 1939 fastCert11_1939=true := by decide +kernel
def fastCert11_1940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1940 : checkCertificateFast 11 1940 fastCert11_1940=true := by decide +kernel
def fastCert11_1941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1941 : checkCertificateFast 11 1941 fastCert11_1941=true := by decide +kernel
def fastCert11_1942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1942 : checkCertificateFast 11 1942 fastCert11_1942=true := by decide +kernel
def fastCert11_1943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1943 : checkCertificateFast 11 1943 fastCert11_1943=true := by decide +kernel
def fastCert11_1944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1944 : checkCertificateFast 11 1944 fastCert11_1944=true := by decide +kernel
def fastCert11_1945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1945 : checkCertificateFast 11 1945 fastCert11_1945=true := by decide +kernel
def fastCert11_1946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1946 : checkCertificateFast 11 1946 fastCert11_1946=true := by decide +kernel
def fastCert11_1947 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1947 : checkCertificateFast 11 1947 fastCert11_1947=true := by decide +kernel
def fastCert11_1948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1948 : checkCertificateFast 11 1948 fastCert11_1948=true := by decide +kernel
def fastCert11_1949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1949 : checkCertificateFast 11 1949 fastCert11_1949=true := by decide +kernel
def fastCert11_1950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1950 : checkCertificateFast 11 1950 fastCert11_1950=true := by decide +kernel
def fastCert11_1951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1951 : checkCertificateFast 11 1951 fastCert11_1951=true := by decide +kernel
def fastCert11_1952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1952 : checkCertificateFast 11 1952 fastCert11_1952=true := by decide +kernel
def fastCert11_1953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1953 : checkCertificateFast 11 1953 fastCert11_1953=true := by decide +kernel
def fastCert11_1954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1954 : checkCertificateFast 11 1954 fastCert11_1954=true := by decide +kernel
def fastCert11_1955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1955 : checkCertificateFast 11 1955 fastCert11_1955=true := by decide +kernel
def fastCert11_1956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1956 : checkCertificateFast 11 1956 fastCert11_1956=true := by decide +kernel
def fastCert11_1957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1957 : checkCertificateFast 11 1957 fastCert11_1957=true := by decide +kernel
def fastCert11_1958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1958 : checkCertificateFast 11 1958 fastCert11_1958=true := by decide +kernel
def fastCert11_1959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1959 : checkCertificateFast 11 1959 fastCert11_1959=true := by decide +kernel
def fastCert11_1960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1960 : checkCertificateFast 11 1960 fastCert11_1960=true := by decide +kernel
def fastCert11_1961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1961 : checkCertificateFast 11 1961 fastCert11_1961=true := by decide +kernel
def fastCert11_1962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1962 : checkCertificateFast 11 1962 fastCert11_1962=true := by decide +kernel
def fastCert11_1963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1963 : checkCertificateFast 11 1963 fastCert11_1963=true := by decide +kernel
def fastCert11_1964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1964 : checkCertificateFast 11 1964 fastCert11_1964=true := by decide +kernel
def fastCert11_1965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1965 : checkCertificateFast 11 1965 fastCert11_1965=true := by decide +kernel
def fastCert11_1966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1966 : checkCertificateFast 11 1966 fastCert11_1966=true := by decide +kernel
def fastCert11_1967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1967 : checkCertificateFast 11 1967 fastCert11_1967=true := by decide +kernel
def fastCert11_1968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1968 : checkCertificateFast 11 1968 fastCert11_1968=true := by decide +kernel
def fastCert11_1969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1969 : checkCertificateFast 11 1969 fastCert11_1969=true := by decide +kernel
def fastCert11_1970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1970 : checkCertificateFast 11 1970 fastCert11_1970=true := by decide +kernel
def fastCert11_1971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1971 : checkCertificateFast 11 1971 fastCert11_1971=true := by decide +kernel
def fastCert11_1972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1972 : checkCertificateFast 11 1972 fastCert11_1972=true := by decide +kernel
def fastCert11_1973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1973 : checkCertificateFast 11 1973 fastCert11_1973=true := by decide +kernel
def fastCert11_1974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1974 : checkCertificateFast 11 1974 fastCert11_1974=true := by decide +kernel
def fastCert11_1975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1975 : checkCertificateFast 11 1975 fastCert11_1975=true := by decide +kernel
def fastCert11_1976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1976 : checkCertificateFast 11 1976 fastCert11_1976=true := by decide +kernel
def fastCert11_1977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase11_1977 : checkCertificateFast 11 1977 fastCert11_1977=true := by decide +kernel
def fastCert11_1978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1978 : checkCertificateFast 11 1978 fastCert11_1978=true := by decide +kernel
def fastCert11_1979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1979 : checkCertificateFast 11 1979 fastCert11_1979=true := by decide +kernel
def fastCert11_1980 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1980 : checkCertificateFast 11 1980 fastCert11_1980=true := by decide +kernel
def fastCert11_1981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase11_1981 : checkCertificateFast 11 1981 fastCert11_1981=true := by decide +kernel
def fastCert11_1982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1982 : checkCertificateFast 11 1982 fastCert11_1982=true := by decide +kernel
def fastCert11_1983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1983 : checkCertificateFast 11 1983 fastCert11_1983=true := by decide +kernel
def fastCert11_1984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1984 : checkCertificateFast 11 1984 fastCert11_1984=true := by decide +kernel
def fastCert11_1985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1985 : checkCertificateFast 11 1985 fastCert11_1985=true := by decide +kernel
def fastCert11_1986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1986 : checkCertificateFast 11 1986 fastCert11_1986=true := by decide +kernel
def fastCert11_1987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1987 : checkCertificateFast 11 1987 fastCert11_1987=true := by decide +kernel
def fastCert11_1988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1988 : checkCertificateFast 11 1988 fastCert11_1988=true := by decide +kernel
def fastCert11_1989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1989 : checkCertificateFast 11 1989 fastCert11_1989=true := by decide +kernel
def fastCert11_1990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1990 : checkCertificateFast 11 1990 fastCert11_1990=true := by decide +kernel
def fastCert11_1991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1991 : checkCertificateFast 11 1991 fastCert11_1991=true := by decide +kernel
def fastCert11_1992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1992 : checkCertificateFast 11 1992 fastCert11_1992=true := by decide +kernel
def fastCert11_1993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1993 : checkCertificateFast 11 1993 fastCert11_1993=true := by decide +kernel
def fastCert11_1994 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1994 : checkCertificateFast 11 1994 fastCert11_1994=true := by decide +kernel
def fastCert11_1995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else if t=0 ∧ i=17 then (2) else 0⟩
theorem fastCase11_1995 : checkCertificateFast 11 1995 fastCert11_1995=true := by decide +kernel
def fastCert11_1996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1996 : checkCertificateFast 11 1996 fastCert11_1996=true := by decide +kernel
def fastCert11_1997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else if t=0 ∧ i=17 then (-2) else 0⟩
theorem fastCase11_1997 : checkCertificateFast 11 1997 fastCert11_1997=true := by decide +kernel
def fastCert11_1998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1998 : checkCertificateFast 11 1998 fastCert11_1998=true := by decide +kernel
def fastCert11_1999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase11_1999 : checkCertificateFast 11 1999 fastCert11_1999=true := by decide +kernel
theorem aggregate_F11_001 : (checkCertificateFast 11 1000 fastCert11_1000=true) ∧ (checkCertificateFast 11 1001 fastCert11_1001=true) ∧ (checkCertificateFast 11 1002 fastCert11_1002=true) ∧ (checkCertificateFast 11 1003 fastCert11_1003=true) ∧ (checkCertificateFast 11 1004 fastCert11_1004=true) ∧ (checkCertificateFast 11 1005 fastCert11_1005=true) ∧ (checkCertificateFast 11 1006 fastCert11_1006=true) ∧ (checkCertificateFast 11 1007 fastCert11_1007=true) ∧ (checkCertificateFast 11 1008 fastCert11_1008=true) ∧ (checkCertificateFast 11 1009 fastCert11_1009=true) ∧ (checkCertificateFast 11 1010 fastCert11_1010=true) ∧ (checkCertificateFast 11 1011 fastCert11_1011=true) ∧ (checkCertificateFast 11 1012 fastCert11_1012=true) ∧ (checkCertificateFast 11 1013 fastCert11_1013=true) ∧ (checkCertificateFast 11 1014 fastCert11_1014=true) ∧ (checkCertificateFast 11 1015 fastCert11_1015=true) ∧ (checkCertificateFast 11 1016 fastCert11_1016=true) ∧ (checkCertificateFast 11 1017 fastCert11_1017=true) ∧ (checkCertificateFast 11 1018 fastCert11_1018=true) ∧ (checkCertificateFast 11 1019 fastCert11_1019=true) ∧ (checkCertificateFast 11 1020 fastCert11_1020=true) ∧ (checkCertificateFast 11 1021 fastCert11_1021=true) ∧ (checkCertificateFast 11 1022 fastCert11_1022=true) ∧ (checkCertificateFast 11 1023 fastCert11_1023=true) ∧ (checkCertificateFast 11 1024 fastCert11_1024=true) ∧ (checkCertificateFast 11 1025 fastCert11_1025=true) ∧ (checkCertificateFast 11 1026 fastCert11_1026=true) ∧ (checkCertificateFast 11 1027 fastCert11_1027=true) ∧ (checkCertificateFast 11 1028 fastCert11_1028=true) ∧ (checkCertificateFast 11 1029 fastCert11_1029=true) ∧ (checkCertificateFast 11 1030 fastCert11_1030=true) ∧ (checkCertificateFast 11 1031 fastCert11_1031=true) ∧ (checkCertificateFast 11 1032 fastCert11_1032=true) ∧ (checkCertificateFast 11 1033 fastCert11_1033=true) ∧ (checkCertificateFast 11 1034 fastCert11_1034=true) ∧ (checkCertificateFast 11 1035 fastCert11_1035=true) ∧ (checkCertificateFast 11 1036 fastCert11_1036=true) ∧ (checkCertificateFast 11 1037 fastCert11_1037=true) ∧ (checkCertificateFast 11 1038 fastCert11_1038=true) ∧ (checkCertificateFast 11 1039 fastCert11_1039=true) ∧ (checkCertificateFast 11 1040 fastCert11_1040=true) ∧ (checkCertificateFast 11 1041 fastCert11_1041=true) ∧ (checkCertificateFast 11 1042 fastCert11_1042=true) ∧ (checkCertificateFast 11 1043 fastCert11_1043=true) ∧ (checkCertificateFast 11 1044 fastCert11_1044=true) ∧ (checkCertificateFast 11 1045 fastCert11_1045=true) ∧ (checkCertificateFast 11 1046 fastCert11_1046=true) ∧ (checkCertificateFast 11 1047 fastCert11_1047=true) ∧ (checkCertificateFast 11 1048 fastCert11_1048=true) ∧ (checkCertificateFast 11 1049 fastCert11_1049=true) ∧ (checkCertificateFast 11 1050 fastCert11_1050=true) ∧ (checkCertificateFast 11 1051 fastCert11_1051=true) ∧ (checkCertificateFast 11 1052 fastCert11_1052=true) ∧ (checkCertificateFast 11 1053 fastCert11_1053=true) ∧ (checkCertificateFast 11 1054 fastCert11_1054=true) ∧ (checkCertificateFast 11 1055 fastCert11_1055=true) ∧ (checkCertificateFast 11 1056 fastCert11_1056=true) ∧ (checkCertificateFast 11 1057 fastCert11_1057=true) ∧ (checkCertificateFast 11 1058 fastCert11_1058=true) ∧ (checkCertificateFast 11 1059 fastCert11_1059=true) ∧ (checkCertificateFast 11 1060 fastCert11_1060=true) ∧ (checkCertificateFast 11 1061 fastCert11_1061=true) ∧ (checkCertificateFast 11 1062 fastCert11_1062=true) ∧ (checkCertificateFast 11 1063 fastCert11_1063=true) ∧ (checkCertificateFast 11 1064 fastCert11_1064=true) ∧ (checkCertificateFast 11 1065 fastCert11_1065=true) ∧ (checkCertificateFast 11 1066 fastCert11_1066=true) ∧ (checkCertificateFast 11 1067 fastCert11_1067=true) ∧ (checkCertificateFast 11 1068 fastCert11_1068=true) ∧ (checkCertificateFast 11 1069 fastCert11_1069=true) ∧ (checkCertificateFast 11 1070 fastCert11_1070=true) ∧ (checkCertificateFast 11 1071 fastCert11_1071=true) ∧ (checkCertificateFast 11 1072 fastCert11_1072=true) ∧ (checkCertificateFast 11 1073 fastCert11_1073=true) ∧ (checkCertificateFast 11 1074 fastCert11_1074=true) ∧ (checkCertificateFast 11 1075 fastCert11_1075=true) ∧ (checkCertificateFast 11 1076 fastCert11_1076=true) ∧ (checkCertificateFast 11 1077 fastCert11_1077=true) ∧ (checkCertificateFast 11 1078 fastCert11_1078=true) ∧ (checkCertificateFast 11 1079 fastCert11_1079=true) ∧ (checkCertificateFast 11 1080 fastCert11_1080=true) ∧ (checkCertificateFast 11 1081 fastCert11_1081=true) ∧ (checkCertificateFast 11 1082 fastCert11_1082=true) ∧ (checkCertificateFast 11 1083 fastCert11_1083=true) ∧ (checkCertificateFast 11 1084 fastCert11_1084=true) ∧ (checkCertificateFast 11 1085 fastCert11_1085=true) ∧ (checkCertificateFast 11 1086 fastCert11_1086=true) ∧ (checkCertificateFast 11 1087 fastCert11_1087=true) ∧ (checkCertificateFast 11 1088 fastCert11_1088=true) ∧ (checkCertificateFast 11 1089 fastCert11_1089=true) ∧ (checkCertificateFast 11 1090 fastCert11_1090=true) ∧ (checkCertificateFast 11 1091 fastCert11_1091=true) ∧ (checkCertificateFast 11 1092 fastCert11_1092=true) ∧ (checkCertificateFast 11 1093 fastCert11_1093=true) ∧ (checkCertificateFast 11 1094 fastCert11_1094=true) ∧ (checkCertificateFast 11 1095 fastCert11_1095=true) ∧ (checkCertificateFast 11 1096 fastCert11_1096=true) ∧ (checkCertificateFast 11 1097 fastCert11_1097=true) ∧ (checkCertificateFast 11 1098 fastCert11_1098=true) ∧ (checkCertificateFast 11 1099 fastCert11_1099=true) ∧ (checkCertificateFast 11 1100 fastCert11_1100=true) ∧ (checkCertificateFast 11 1101 fastCert11_1101=true) ∧ (checkCertificateFast 11 1102 fastCert11_1102=true) ∧ (checkCertificateFast 11 1103 fastCert11_1103=true) ∧ (checkCertificateFast 11 1104 fastCert11_1104=true) ∧ (checkCertificateFast 11 1105 fastCert11_1105=true) ∧ (checkCertificateFast 11 1106 fastCert11_1106=true) ∧ (checkCertificateFast 11 1107 fastCert11_1107=true) ∧ (checkCertificateFast 11 1108 fastCert11_1108=true) ∧ (checkCertificateFast 11 1109 fastCert11_1109=true) ∧ (checkCertificateFast 11 1110 fastCert11_1110=true) ∧ (checkCertificateFast 11 1111 fastCert11_1111=true) ∧ (checkCertificateFast 11 1112 fastCert11_1112=true) ∧ (checkCertificateFast 11 1113 fastCert11_1113=true) ∧ (checkCertificateFast 11 1114 fastCert11_1114=true) ∧ (checkCertificateFast 11 1115 fastCert11_1115=true) ∧ (checkCertificateFast 11 1116 fastCert11_1116=true) ∧ (checkCertificateFast 11 1117 fastCert11_1117=true) ∧ (checkCertificateFast 11 1118 fastCert11_1118=true) ∧ (checkCertificateFast 11 1119 fastCert11_1119=true) ∧ (checkCertificateFast 11 1120 fastCert11_1120=true) ∧ (checkCertificateFast 11 1121 fastCert11_1121=true) ∧ (checkCertificateFast 11 1122 fastCert11_1122=true) ∧ (checkCertificateFast 11 1123 fastCert11_1123=true) ∧ (checkCertificateFast 11 1124 fastCert11_1124=true) ∧ (checkCertificateFast 11 1125 fastCert11_1125=true) ∧ (checkCertificateFast 11 1126 fastCert11_1126=true) ∧ (checkCertificateFast 11 1127 fastCert11_1127=true) ∧ (checkCertificateFast 11 1128 fastCert11_1128=true) ∧ (checkCertificateFast 11 1129 fastCert11_1129=true) ∧ (checkCertificateFast 11 1130 fastCert11_1130=true) ∧ (checkCertificateFast 11 1131 fastCert11_1131=true) ∧ (checkCertificateFast 11 1132 fastCert11_1132=true) ∧ (checkCertificateFast 11 1133 fastCert11_1133=true) ∧ (checkCertificateFast 11 1134 fastCert11_1134=true) ∧ (checkCertificateFast 11 1135 fastCert11_1135=true) ∧ (checkCertificateFast 11 1136 fastCert11_1136=true) ∧ (checkCertificateFast 11 1137 fastCert11_1137=true) ∧ (checkCertificateFast 11 1138 fastCert11_1138=true) ∧ (checkCertificateFast 11 1139 fastCert11_1139=true) ∧ (checkCertificateFast 11 1140 fastCert11_1140=true) ∧ (checkCertificateFast 11 1141 fastCert11_1141=true) ∧ (checkCertificateFast 11 1142 fastCert11_1142=true) ∧ (checkCertificateFast 11 1143 fastCert11_1143=true) ∧ (checkCertificateFast 11 1144 fastCert11_1144=true) ∧ (checkCertificateFast 11 1145 fastCert11_1145=true) ∧ (checkCertificateFast 11 1146 fastCert11_1146=true) ∧ (checkCertificateFast 11 1147 fastCert11_1147=true) ∧ (checkCertificateFast 11 1148 fastCert11_1148=true) ∧ (checkCertificateFast 11 1149 fastCert11_1149=true) ∧ (checkCertificateFast 11 1150 fastCert11_1150=true) ∧ (checkCertificateFast 11 1151 fastCert11_1151=true) ∧ (checkCertificateFast 11 1152 fastCert11_1152=true) ∧ (checkCertificateFast 11 1153 fastCert11_1153=true) ∧ (checkCertificateFast 11 1154 fastCert11_1154=true) ∧ (checkCertificateFast 11 1155 fastCert11_1155=true) ∧ (checkCertificateFast 11 1156 fastCert11_1156=true) ∧ (checkCertificateFast 11 1157 fastCert11_1157=true) ∧ (checkCertificateFast 11 1158 fastCert11_1158=true) ∧ (checkCertificateFast 11 1159 fastCert11_1159=true) ∧ (checkCertificateFast 11 1160 fastCert11_1160=true) ∧ (checkCertificateFast 11 1161 fastCert11_1161=true) ∧ (checkCertificateFast 11 1162 fastCert11_1162=true) ∧ (checkCertificateFast 11 1163 fastCert11_1163=true) ∧ (checkCertificateFast 11 1164 fastCert11_1164=true) ∧ (checkCertificateFast 11 1165 fastCert11_1165=true) ∧ (checkCertificateFast 11 1166 fastCert11_1166=true) ∧ (checkCertificateFast 11 1167 fastCert11_1167=true) ∧ (checkCertificateFast 11 1168 fastCert11_1168=true) ∧ (checkCertificateFast 11 1169 fastCert11_1169=true) ∧ (checkCertificateFast 11 1170 fastCert11_1170=true) ∧ (checkCertificateFast 11 1171 fastCert11_1171=true) ∧ (checkCertificateFast 11 1172 fastCert11_1172=true) ∧ (checkCertificateFast 11 1173 fastCert11_1173=true) ∧ (checkCertificateFast 11 1174 fastCert11_1174=true) ∧ (checkCertificateFast 11 1175 fastCert11_1175=true) ∧ (checkCertificateFast 11 1176 fastCert11_1176=true) ∧ (checkCertificateFast 11 1177 fastCert11_1177=true) ∧ (checkCertificateFast 11 1178 fastCert11_1178=true) ∧ (checkCertificateFast 11 1179 fastCert11_1179=true) ∧ (checkCertificateFast 11 1180 fastCert11_1180=true) ∧ (checkCertificateFast 11 1181 fastCert11_1181=true) ∧ (checkCertificateFast 11 1182 fastCert11_1182=true) ∧ (checkCertificateFast 11 1183 fastCert11_1183=true) ∧ (checkCertificateFast 11 1184 fastCert11_1184=true) ∧ (checkCertificateFast 11 1185 fastCert11_1185=true) ∧ (checkCertificateFast 11 1186 fastCert11_1186=true) ∧ (checkCertificateFast 11 1187 fastCert11_1187=true) ∧ (checkCertificateFast 11 1188 fastCert11_1188=true) ∧ (checkCertificateFast 11 1189 fastCert11_1189=true) ∧ (checkCertificateFast 11 1190 fastCert11_1190=true) ∧ (checkCertificateFast 11 1191 fastCert11_1191=true) ∧ (checkCertificateFast 11 1192 fastCert11_1192=true) ∧ (checkCertificateFast 11 1193 fastCert11_1193=true) ∧ (checkCertificateFast 11 1194 fastCert11_1194=true) ∧ (checkCertificateFast 11 1195 fastCert11_1195=true) ∧ (checkCertificateFast 11 1196 fastCert11_1196=true) ∧ (checkCertificateFast 11 1197 fastCert11_1197=true) ∧ (checkCertificateFast 11 1198 fastCert11_1198=true) ∧ (checkCertificateFast 11 1199 fastCert11_1199=true) ∧ (checkCertificateFast 11 1200 fastCert11_1200=true) ∧ (checkCertificateFast 11 1201 fastCert11_1201=true) ∧ (checkCertificateFast 11 1202 fastCert11_1202=true) ∧ (checkCertificateFast 11 1203 fastCert11_1203=true) ∧ (checkCertificateFast 11 1204 fastCert11_1204=true) ∧ (checkCertificateFast 11 1205 fastCert11_1205=true) ∧ (checkCertificateFast 11 1206 fastCert11_1206=true) ∧ (checkCertificateFast 11 1207 fastCert11_1207=true) ∧ (checkCertificateFast 11 1208 fastCert11_1208=true) ∧ (checkCertificateFast 11 1209 fastCert11_1209=true) ∧ (checkCertificateFast 11 1210 fastCert11_1210=true) ∧ (checkCertificateFast 11 1211 fastCert11_1211=true) ∧ (checkCertificateFast 11 1212 fastCert11_1212=true) ∧ (checkCertificateFast 11 1213 fastCert11_1213=true) ∧ (checkCertificateFast 11 1214 fastCert11_1214=true) ∧ (checkCertificateFast 11 1215 fastCert11_1215=true) ∧ (checkCertificateFast 11 1216 fastCert11_1216=true) ∧ (checkCertificateFast 11 1217 fastCert11_1217=true) ∧ (checkCertificateFast 11 1218 fastCert11_1218=true) ∧ (checkCertificateFast 11 1219 fastCert11_1219=true) ∧ (checkCertificateFast 11 1220 fastCert11_1220=true) ∧ (checkCertificateFast 11 1221 fastCert11_1221=true) ∧ (checkCertificateFast 11 1222 fastCert11_1222=true) ∧ (checkCertificateFast 11 1223 fastCert11_1223=true) ∧ (checkCertificateFast 11 1224 fastCert11_1224=true) ∧ (checkCertificateFast 11 1225 fastCert11_1225=true) ∧ (checkCertificateFast 11 1226 fastCert11_1226=true) ∧ (checkCertificateFast 11 1227 fastCert11_1227=true) ∧ (checkCertificateFast 11 1228 fastCert11_1228=true) ∧ (checkCertificateFast 11 1229 fastCert11_1229=true) ∧ (checkCertificateFast 11 1230 fastCert11_1230=true) ∧ (checkCertificateFast 11 1231 fastCert11_1231=true) ∧ (checkCertificateFast 11 1232 fastCert11_1232=true) ∧ (checkCertificateFast 11 1233 fastCert11_1233=true) ∧ (checkCertificateFast 11 1234 fastCert11_1234=true) ∧ (checkCertificateFast 11 1235 fastCert11_1235=true) ∧ (checkCertificateFast 11 1236 fastCert11_1236=true) ∧ (checkCertificateFast 11 1237 fastCert11_1237=true) ∧ (checkCertificateFast 11 1238 fastCert11_1238=true) ∧ (checkCertificateFast 11 1239 fastCert11_1239=true) ∧ (checkCertificateFast 11 1240 fastCert11_1240=true) ∧ (checkCertificateFast 11 1241 fastCert11_1241=true) ∧ (checkCertificateFast 11 1242 fastCert11_1242=true) ∧ (checkCertificateFast 11 1243 fastCert11_1243=true) ∧ (checkCertificateFast 11 1244 fastCert11_1244=true) ∧ (checkCertificateFast 11 1245 fastCert11_1245=true) ∧ (checkCertificateFast 11 1246 fastCert11_1246=true) ∧ (checkCertificateFast 11 1247 fastCert11_1247=true) ∧ (checkCertificateFast 11 1248 fastCert11_1248=true) ∧ (checkCertificateFast 11 1249 fastCert11_1249=true) ∧ (checkCertificateFast 11 1250 fastCert11_1250=true) ∧ (checkCertificateFast 11 1251 fastCert11_1251=true) ∧ (checkCertificateFast 11 1252 fastCert11_1252=true) ∧ (checkCertificateFast 11 1253 fastCert11_1253=true) ∧ (checkCertificateFast 11 1254 fastCert11_1254=true) ∧ (checkCertificateFast 11 1255 fastCert11_1255=true) ∧ (checkCertificateFast 11 1256 fastCert11_1256=true) ∧ (checkCertificateFast 11 1257 fastCert11_1257=true) ∧ (checkCertificateFast 11 1258 fastCert11_1258=true) ∧ (checkCertificateFast 11 1259 fastCert11_1259=true) ∧ (checkCertificateFast 11 1260 fastCert11_1260=true) ∧ (checkCertificateFast 11 1261 fastCert11_1261=true) ∧ (checkCertificateFast 11 1262 fastCert11_1262=true) ∧ (checkCertificateFast 11 1263 fastCert11_1263=true) ∧ (checkCertificateFast 11 1264 fastCert11_1264=true) ∧ (checkCertificateFast 11 1265 fastCert11_1265=true) ∧ (checkCertificateFast 11 1266 fastCert11_1266=true) ∧ (checkCertificateFast 11 1267 fastCert11_1267=true) ∧ (checkCertificateFast 11 1268 fastCert11_1268=true) ∧ (checkCertificateFast 11 1269 fastCert11_1269=true) ∧ (checkCertificateFast 11 1270 fastCert11_1270=true) ∧ (checkCertificateFast 11 1271 fastCert11_1271=true) ∧ (checkCertificateFast 11 1272 fastCert11_1272=true) ∧ (checkCertificateFast 11 1273 fastCert11_1273=true) ∧ (checkCertificateFast 11 1274 fastCert11_1274=true) ∧ (checkCertificateFast 11 1275 fastCert11_1275=true) ∧ (checkCertificateFast 11 1276 fastCert11_1276=true) ∧ (checkCertificateFast 11 1277 fastCert11_1277=true) ∧ (checkCertificateFast 11 1278 fastCert11_1278=true) ∧ (checkCertificateFast 11 1279 fastCert11_1279=true) ∧ (checkCertificateFast 11 1280 fastCert11_1280=true) ∧ (checkCertificateFast 11 1281 fastCert11_1281=true) ∧ (checkCertificateFast 11 1282 fastCert11_1282=true) ∧ (checkCertificateFast 11 1283 fastCert11_1283=true) ∧ (checkCertificateFast 11 1284 fastCert11_1284=true) ∧ (checkCertificateFast 11 1285 fastCert11_1285=true) ∧ (checkCertificateFast 11 1286 fastCert11_1286=true) ∧ (checkCertificateFast 11 1287 fastCert11_1287=true) ∧ (checkCertificateFast 11 1288 fastCert11_1288=true) ∧ (checkCertificateFast 11 1289 fastCert11_1289=true) ∧ (checkCertificateFast 11 1290 fastCert11_1290=true) ∧ (checkCertificateFast 11 1291 fastCert11_1291=true) ∧ (checkCertificateFast 11 1292 fastCert11_1292=true) ∧ (checkCertificateFast 11 1293 fastCert11_1293=true) ∧ (checkCertificateFast 11 1294 fastCert11_1294=true) ∧ (checkCertificateFast 11 1295 fastCert11_1295=true) ∧ (checkCertificateFast 11 1296 fastCert11_1296=true) ∧ (checkCertificateFast 11 1297 fastCert11_1297=true) ∧ (checkCertificateFast 11 1298 fastCert11_1298=true) ∧ (checkCertificateFast 11 1299 fastCert11_1299=true) ∧ (checkCertificateFast 11 1300 fastCert11_1300=true) ∧ (checkCertificateFast 11 1301 fastCert11_1301=true) ∧ (checkCertificateFast 11 1302 fastCert11_1302=true) ∧ (checkCertificateFast 11 1303 fastCert11_1303=true) ∧ (checkCertificateFast 11 1304 fastCert11_1304=true) ∧ (checkCertificateFast 11 1305 fastCert11_1305=true) ∧ (checkCertificateFast 11 1306 fastCert11_1306=true) ∧ (checkCertificateFast 11 1307 fastCert11_1307=true) ∧ (checkCertificateFast 11 1308 fastCert11_1308=true) ∧ (checkCertificateFast 11 1309 fastCert11_1309=true) ∧ (checkCertificateFast 11 1310 fastCert11_1310=true) ∧ (checkCertificateFast 11 1311 fastCert11_1311=true) ∧ (checkCertificateFast 11 1312 fastCert11_1312=true) ∧ (checkCertificateFast 11 1313 fastCert11_1313=true) ∧ (checkCertificateFast 11 1314 fastCert11_1314=true) ∧ (checkCertificateFast 11 1315 fastCert11_1315=true) ∧ (checkCertificateFast 11 1316 fastCert11_1316=true) ∧ (checkCertificateFast 11 1317 fastCert11_1317=true) ∧ (checkCertificateFast 11 1318 fastCert11_1318=true) ∧ (checkCertificateFast 11 1319 fastCert11_1319=true) ∧ (checkCertificateFast 11 1320 fastCert11_1320=true) ∧ (checkCertificateFast 11 1321 fastCert11_1321=true) ∧ (checkCertificateFast 11 1322 fastCert11_1322=true) ∧ (checkCertificateFast 11 1323 fastCert11_1323=true) ∧ (checkCertificateFast 11 1324 fastCert11_1324=true) ∧ (checkCertificateFast 11 1325 fastCert11_1325=true) ∧ (checkCertificateFast 11 1326 fastCert11_1326=true) ∧ (checkCertificateFast 11 1327 fastCert11_1327=true) ∧ (checkCertificateFast 11 1328 fastCert11_1328=true) ∧ (checkCertificateFast 11 1329 fastCert11_1329=true) ∧ (checkCertificateFast 11 1330 fastCert11_1330=true) ∧ (checkCertificateFast 11 1331 fastCert11_1331=true) ∧ (checkCertificateFast 11 1332 fastCert11_1332=true) ∧ (checkCertificateFast 11 1333 fastCert11_1333=true) ∧ (checkCertificateFast 11 1334 fastCert11_1334=true) ∧ (checkCertificateFast 11 1335 fastCert11_1335=true) ∧ (checkCertificateFast 11 1336 fastCert11_1336=true) ∧ (checkCertificateFast 11 1337 fastCert11_1337=true) ∧ (checkCertificateFast 11 1338 fastCert11_1338=true) ∧ (checkCertificateFast 11 1339 fastCert11_1339=true) ∧ (checkCertificateFast 11 1340 fastCert11_1340=true) ∧ (checkCertificateFast 11 1341 fastCert11_1341=true) ∧ (checkCertificateFast 11 1342 fastCert11_1342=true) ∧ (checkCertificateFast 11 1343 fastCert11_1343=true) ∧ (checkCertificateFast 11 1344 fastCert11_1344=true) ∧ (checkCertificateFast 11 1345 fastCert11_1345=true) ∧ (checkCertificateFast 11 1346 fastCert11_1346=true) ∧ (checkCertificateFast 11 1347 fastCert11_1347=true) ∧ (checkCertificateFast 11 1348 fastCert11_1348=true) ∧ (checkCertificateFast 11 1349 fastCert11_1349=true) ∧ (checkCertificateFast 11 1350 fastCert11_1350=true) ∧ (checkCertificateFast 11 1351 fastCert11_1351=true) ∧ (checkCertificateFast 11 1352 fastCert11_1352=true) ∧ (checkCertificateFast 11 1353 fastCert11_1353=true) ∧ (checkCertificateFast 11 1354 fastCert11_1354=true) ∧ (checkCertificateFast 11 1355 fastCert11_1355=true) ∧ (checkCertificateFast 11 1356 fastCert11_1356=true) ∧ (checkCertificateFast 11 1357 fastCert11_1357=true) ∧ (checkCertificateFast 11 1358 fastCert11_1358=true) ∧ (checkCertificateFast 11 1359 fastCert11_1359=true) ∧ (checkCertificateFast 11 1360 fastCert11_1360=true) ∧ (checkCertificateFast 11 1361 fastCert11_1361=true) ∧ (checkCertificateFast 11 1362 fastCert11_1362=true) ∧ (checkCertificateFast 11 1363 fastCert11_1363=true) ∧ (checkCertificateFast 11 1364 fastCert11_1364=true) ∧ (checkCertificateFast 11 1365 fastCert11_1365=true) ∧ (checkCertificateFast 11 1366 fastCert11_1366=true) ∧ (checkCertificateFast 11 1367 fastCert11_1367=true) ∧ (checkCertificateFast 11 1368 fastCert11_1368=true) ∧ (checkCertificateFast 11 1369 fastCert11_1369=true) ∧ (checkCertificateFast 11 1370 fastCert11_1370=true) ∧ (checkCertificateFast 11 1371 fastCert11_1371=true) ∧ (checkCertificateFast 11 1372 fastCert11_1372=true) ∧ (checkCertificateFast 11 1373 fastCert11_1373=true) ∧ (checkCertificateFast 11 1374 fastCert11_1374=true) ∧ (checkCertificateFast 11 1375 fastCert11_1375=true) ∧ (checkCertificateFast 11 1376 fastCert11_1376=true) ∧ (checkCertificateFast 11 1377 fastCert11_1377=true) ∧ (checkCertificateFast 11 1378 fastCert11_1378=true) ∧ (checkCertificateFast 11 1379 fastCert11_1379=true) ∧ (checkCertificateFast 11 1380 fastCert11_1380=true) ∧ (checkCertificateFast 11 1381 fastCert11_1381=true) ∧ (checkCertificateFast 11 1382 fastCert11_1382=true) ∧ (checkCertificateFast 11 1383 fastCert11_1383=true) ∧ (checkCertificateFast 11 1384 fastCert11_1384=true) ∧ (checkCertificateFast 11 1385 fastCert11_1385=true) ∧ (checkCertificateFast 11 1386 fastCert11_1386=true) ∧ (checkCertificateFast 11 1387 fastCert11_1387=true) ∧ (checkCertificateFast 11 1388 fastCert11_1388=true) ∧ (checkCertificateFast 11 1389 fastCert11_1389=true) ∧ (checkCertificateFast 11 1390 fastCert11_1390=true) ∧ (checkCertificateFast 11 1391 fastCert11_1391=true) ∧ (checkCertificateFast 11 1392 fastCert11_1392=true) ∧ (checkCertificateFast 11 1393 fastCert11_1393=true) ∧ (checkCertificateFast 11 1394 fastCert11_1394=true) ∧ (checkCertificateFast 11 1395 fastCert11_1395=true) ∧ (checkCertificateFast 11 1396 fastCert11_1396=true) ∧ (checkCertificateFast 11 1397 fastCert11_1397=true) ∧ (checkCertificateFast 11 1398 fastCert11_1398=true) ∧ (checkCertificateFast 11 1399 fastCert11_1399=true) ∧ (checkCertificateFast 11 1400 fastCert11_1400=true) ∧ (checkCertificateFast 11 1401 fastCert11_1401=true) ∧ (checkCertificateFast 11 1402 fastCert11_1402=true) ∧ (checkCertificateFast 11 1403 fastCert11_1403=true) ∧ (checkCertificateFast 11 1404 fastCert11_1404=true) ∧ (checkCertificateFast 11 1405 fastCert11_1405=true) ∧ (checkCertificateFast 11 1406 fastCert11_1406=true) ∧ (checkCertificateFast 11 1407 fastCert11_1407=true) ∧ (checkCertificateFast 11 1408 fastCert11_1408=true) ∧ (checkCertificateFast 11 1409 fastCert11_1409=true) ∧ (checkCertificateFast 11 1410 fastCert11_1410=true) ∧ (checkCertificateFast 11 1411 fastCert11_1411=true) ∧ (checkCertificateFast 11 1412 fastCert11_1412=true) ∧ (checkCertificateFast 11 1413 fastCert11_1413=true) ∧ (checkCertificateFast 11 1414 fastCert11_1414=true) ∧ (checkCertificateFast 11 1415 fastCert11_1415=true) ∧ (checkCertificateFast 11 1416 fastCert11_1416=true) ∧ (checkCertificateFast 11 1417 fastCert11_1417=true) ∧ (checkCertificateFast 11 1418 fastCert11_1418=true) ∧ (checkCertificateFast 11 1419 fastCert11_1419=true) ∧ (checkCertificateFast 11 1420 fastCert11_1420=true) ∧ (checkCertificateFast 11 1421 fastCert11_1421=true) ∧ (checkCertificateFast 11 1422 fastCert11_1422=true) ∧ (checkCertificateFast 11 1423 fastCert11_1423=true) ∧ (checkCertificateFast 11 1424 fastCert11_1424=true) ∧ (checkCertificateFast 11 1425 fastCert11_1425=true) ∧ (checkCertificateFast 11 1426 fastCert11_1426=true) ∧ (checkCertificateFast 11 1427 fastCert11_1427=true) ∧ (checkCertificateFast 11 1428 fastCert11_1428=true) ∧ (checkCertificateFast 11 1429 fastCert11_1429=true) ∧ (checkCertificateFast 11 1430 fastCert11_1430=true) ∧ (checkCertificateFast 11 1431 fastCert11_1431=true) ∧ (checkCertificateFast 11 1432 fastCert11_1432=true) ∧ (checkCertificateFast 11 1433 fastCert11_1433=true) ∧ (checkCertificateFast 11 1434 fastCert11_1434=true) ∧ (checkCertificateFast 11 1435 fastCert11_1435=true) ∧ (checkCertificateFast 11 1436 fastCert11_1436=true) ∧ (checkCertificateFast 11 1437 fastCert11_1437=true) ∧ (checkCertificateFast 11 1438 fastCert11_1438=true) ∧ (checkCertificateFast 11 1439 fastCert11_1439=true) ∧ (checkCertificateFast 11 1440 fastCert11_1440=true) ∧ (checkCertificateFast 11 1441 fastCert11_1441=true) ∧ (checkCertificateFast 11 1442 fastCert11_1442=true) ∧ (checkCertificateFast 11 1443 fastCert11_1443=true) ∧ (checkCertificateFast 11 1444 fastCert11_1444=true) ∧ (checkCertificateFast 11 1445 fastCert11_1445=true) ∧ (checkCertificateFast 11 1446 fastCert11_1446=true) ∧ (checkCertificateFast 11 1447 fastCert11_1447=true) ∧ (checkCertificateFast 11 1448 fastCert11_1448=true) ∧ (checkCertificateFast 11 1449 fastCert11_1449=true) ∧ (checkCertificateFast 11 1450 fastCert11_1450=true) ∧ (checkCertificateFast 11 1451 fastCert11_1451=true) ∧ (checkCertificateFast 11 1452 fastCert11_1452=true) ∧ (checkCertificateFast 11 1453 fastCert11_1453=true) ∧ (checkCertificateFast 11 1454 fastCert11_1454=true) ∧ (checkCertificateFast 11 1455 fastCert11_1455=true) ∧ (checkCertificateFast 11 1456 fastCert11_1456=true) ∧ (checkCertificateFast 11 1457 fastCert11_1457=true) ∧ (checkCertificateFast 11 1458 fastCert11_1458=true) ∧ (checkCertificateFast 11 1459 fastCert11_1459=true) ∧ (checkCertificateFast 11 1460 fastCert11_1460=true) ∧ (checkCertificateFast 11 1461 fastCert11_1461=true) ∧ (checkCertificateFast 11 1462 fastCert11_1462=true) ∧ (checkCertificateFast 11 1463 fastCert11_1463=true) ∧ (checkCertificateFast 11 1464 fastCert11_1464=true) ∧ (checkCertificateFast 11 1465 fastCert11_1465=true) ∧ (checkCertificateFast 11 1466 fastCert11_1466=true) ∧ (checkCertificateFast 11 1467 fastCert11_1467=true) ∧ (checkCertificateFast 11 1468 fastCert11_1468=true) ∧ (checkCertificateFast 11 1469 fastCert11_1469=true) ∧ (checkCertificateFast 11 1470 fastCert11_1470=true) ∧ (checkCertificateFast 11 1471 fastCert11_1471=true) ∧ (checkCertificateFast 11 1472 fastCert11_1472=true) ∧ (checkCertificateFast 11 1473 fastCert11_1473=true) ∧ (checkCertificateFast 11 1474 fastCert11_1474=true) ∧ (checkCertificateFast 11 1475 fastCert11_1475=true) ∧ (checkCertificateFast 11 1476 fastCert11_1476=true) ∧ (checkCertificateFast 11 1477 fastCert11_1477=true) ∧ (checkCertificateFast 11 1478 fastCert11_1478=true) ∧ (checkCertificateFast 11 1479 fastCert11_1479=true) ∧ (checkCertificateFast 11 1480 fastCert11_1480=true) ∧ (checkCertificateFast 11 1481 fastCert11_1481=true) ∧ (checkCertificateFast 11 1482 fastCert11_1482=true) ∧ (checkCertificateFast 11 1483 fastCert11_1483=true) ∧ (checkCertificateFast 11 1484 fastCert11_1484=true) ∧ (checkCertificateFast 11 1485 fastCert11_1485=true) ∧ (checkCertificateFast 11 1486 fastCert11_1486=true) ∧ (checkCertificateFast 11 1487 fastCert11_1487=true) ∧ (checkCertificateFast 11 1488 fastCert11_1488=true) ∧ (checkCertificateFast 11 1489 fastCert11_1489=true) ∧ (checkCertificateFast 11 1490 fastCert11_1490=true) ∧ (checkCertificateFast 11 1491 fastCert11_1491=true) ∧ (checkCertificateFast 11 1492 fastCert11_1492=true) ∧ (checkCertificateFast 11 1493 fastCert11_1493=true) ∧ (checkCertificateFast 11 1494 fastCert11_1494=true) ∧ (checkCertificateFast 11 1495 fastCert11_1495=true) ∧ (checkCertificateFast 11 1496 fastCert11_1496=true) ∧ (checkCertificateFast 11 1497 fastCert11_1497=true) ∧ (checkCertificateFast 11 1498 fastCert11_1498=true) ∧ (checkCertificateFast 11 1499 fastCert11_1499=true) ∧ (checkCertificateFast 11 1500 fastCert11_1500=true) ∧ (checkCertificateFast 11 1501 fastCert11_1501=true) ∧ (checkCertificateFast 11 1502 fastCert11_1502=true) ∧ (checkCertificateFast 11 1503 fastCert11_1503=true) ∧ (checkCertificateFast 11 1504 fastCert11_1504=true) ∧ (checkCertificateFast 11 1505 fastCert11_1505=true) ∧ (checkCertificateFast 11 1506 fastCert11_1506=true) ∧ (checkCertificateFast 11 1507 fastCert11_1507=true) ∧ (checkCertificateFast 11 1508 fastCert11_1508=true) ∧ (checkCertificateFast 11 1509 fastCert11_1509=true) ∧ (checkCertificateFast 11 1510 fastCert11_1510=true) ∧ (checkCertificateFast 11 1511 fastCert11_1511=true) ∧ (checkCertificateFast 11 1512 fastCert11_1512=true) ∧ (checkCertificateFast 11 1513 fastCert11_1513=true) ∧ (checkCertificateFast 11 1514 fastCert11_1514=true) ∧ (checkCertificateFast 11 1515 fastCert11_1515=true) ∧ (checkCertificateFast 11 1516 fastCert11_1516=true) ∧ (checkCertificateFast 11 1517 fastCert11_1517=true) ∧ (checkCertificateFast 11 1518 fastCert11_1518=true) ∧ (checkCertificateFast 11 1519 fastCert11_1519=true) ∧ (checkCertificateFast 11 1520 fastCert11_1520=true) ∧ (checkCertificateFast 11 1521 fastCert11_1521=true) ∧ (checkCertificateFast 11 1522 fastCert11_1522=true) ∧ (checkCertificateFast 11 1523 fastCert11_1523=true) ∧ (checkCertificateFast 11 1524 fastCert11_1524=true) ∧ (checkCertificateFast 11 1525 fastCert11_1525=true) ∧ (checkCertificateFast 11 1526 fastCert11_1526=true) ∧ (checkCertificateFast 11 1527 fastCert11_1527=true) ∧ (checkCertificateFast 11 1528 fastCert11_1528=true) ∧ (checkCertificateFast 11 1529 fastCert11_1529=true) ∧ (checkCertificateFast 11 1530 fastCert11_1530=true) ∧ (checkCertificateFast 11 1531 fastCert11_1531=true) ∧ (checkCertificateFast 11 1532 fastCert11_1532=true) ∧ (checkCertificateFast 11 1533 fastCert11_1533=true) ∧ (checkCertificateFast 11 1534 fastCert11_1534=true) ∧ (checkCertificateFast 11 1535 fastCert11_1535=true) ∧ (checkCertificateFast 11 1536 fastCert11_1536=true) ∧ (checkCertificateFast 11 1537 fastCert11_1537=true) ∧ (checkCertificateFast 11 1538 fastCert11_1538=true) ∧ (checkCertificateFast 11 1539 fastCert11_1539=true) ∧ (checkCertificateFast 11 1540 fastCert11_1540=true) ∧ (checkCertificateFast 11 1541 fastCert11_1541=true) ∧ (checkCertificateFast 11 1542 fastCert11_1542=true) ∧ (checkCertificateFast 11 1543 fastCert11_1543=true) ∧ (checkCertificateFast 11 1544 fastCert11_1544=true) ∧ (checkCertificateFast 11 1545 fastCert11_1545=true) ∧ (checkCertificateFast 11 1546 fastCert11_1546=true) ∧ (checkCertificateFast 11 1547 fastCert11_1547=true) ∧ (checkCertificateFast 11 1548 fastCert11_1548=true) ∧ (checkCertificateFast 11 1549 fastCert11_1549=true) ∧ (checkCertificateFast 11 1550 fastCert11_1550=true) ∧ (checkCertificateFast 11 1551 fastCert11_1551=true) ∧ (checkCertificateFast 11 1552 fastCert11_1552=true) ∧ (checkCertificateFast 11 1553 fastCert11_1553=true) ∧ (checkCertificateFast 11 1554 fastCert11_1554=true) ∧ (checkCertificateFast 11 1555 fastCert11_1555=true) ∧ (checkCertificateFast 11 1556 fastCert11_1556=true) ∧ (checkCertificateFast 11 1557 fastCert11_1557=true) ∧ (checkCertificateFast 11 1558 fastCert11_1558=true) ∧ (checkCertificateFast 11 1559 fastCert11_1559=true) ∧ (checkCertificateFast 11 1560 fastCert11_1560=true) ∧ (checkCertificateFast 11 1561 fastCert11_1561=true) ∧ (checkCertificateFast 11 1562 fastCert11_1562=true) ∧ (checkCertificateFast 11 1563 fastCert11_1563=true) ∧ (checkCertificateFast 11 1564 fastCert11_1564=true) ∧ (checkCertificateFast 11 1565 fastCert11_1565=true) ∧ (checkCertificateFast 11 1566 fastCert11_1566=true) ∧ (checkCertificateFast 11 1567 fastCert11_1567=true) ∧ (checkCertificateFast 11 1568 fastCert11_1568=true) ∧ (checkCertificateFast 11 1569 fastCert11_1569=true) ∧ (checkCertificateFast 11 1570 fastCert11_1570=true) ∧ (checkCertificateFast 11 1571 fastCert11_1571=true) ∧ (checkCertificateFast 11 1572 fastCert11_1572=true) ∧ (checkCertificateFast 11 1573 fastCert11_1573=true) ∧ (checkCertificateFast 11 1574 fastCert11_1574=true) ∧ (checkCertificateFast 11 1575 fastCert11_1575=true) ∧ (checkCertificateFast 11 1576 fastCert11_1576=true) ∧ (checkCertificateFast 11 1577 fastCert11_1577=true) ∧ (checkCertificateFast 11 1578 fastCert11_1578=true) ∧ (checkCertificateFast 11 1579 fastCert11_1579=true) ∧ (checkCertificateFast 11 1580 fastCert11_1580=true) ∧ (checkCertificateFast 11 1581 fastCert11_1581=true) ∧ (checkCertificateFast 11 1582 fastCert11_1582=true) ∧ (checkCertificateFast 11 1583 fastCert11_1583=true) ∧ (checkCertificateFast 11 1584 fastCert11_1584=true) ∧ (checkCertificateFast 11 1585 fastCert11_1585=true) ∧ (checkCertificateFast 11 1586 fastCert11_1586=true) ∧ (checkCertificateFast 11 1587 fastCert11_1587=true) ∧ (checkCertificateFast 11 1588 fastCert11_1588=true) ∧ (checkCertificateFast 11 1589 fastCert11_1589=true) ∧ (checkCertificateFast 11 1590 fastCert11_1590=true) ∧ (checkCertificateFast 11 1591 fastCert11_1591=true) ∧ (checkCertificateFast 11 1592 fastCert11_1592=true) ∧ (checkCertificateFast 11 1593 fastCert11_1593=true) ∧ (checkCertificateFast 11 1594 fastCert11_1594=true) ∧ (checkCertificateFast 11 1595 fastCert11_1595=true) ∧ (checkCertificateFast 11 1596 fastCert11_1596=true) ∧ (checkCertificateFast 11 1597 fastCert11_1597=true) ∧ (checkCertificateFast 11 1598 fastCert11_1598=true) ∧ (checkCertificateFast 11 1599 fastCert11_1599=true) ∧ (checkCertificateFast 11 1600 fastCert11_1600=true) ∧ (checkCertificateFast 11 1601 fastCert11_1601=true) ∧ (checkCertificateFast 11 1602 fastCert11_1602=true) ∧ (checkCertificateFast 11 1603 fastCert11_1603=true) ∧ (checkCertificateFast 11 1604 fastCert11_1604=true) ∧ (checkCertificateFast 11 1605 fastCert11_1605=true) ∧ (checkCertificateFast 11 1606 fastCert11_1606=true) ∧ (checkCertificateFast 11 1607 fastCert11_1607=true) ∧ (checkCertificateFast 11 1608 fastCert11_1608=true) ∧ (checkCertificateFast 11 1609 fastCert11_1609=true) ∧ (checkCertificateFast 11 1610 fastCert11_1610=true) ∧ (checkCertificateFast 11 1611 fastCert11_1611=true) ∧ (checkCertificateFast 11 1612 fastCert11_1612=true) ∧ (checkCertificateFast 11 1613 fastCert11_1613=true) ∧ (checkCertificateFast 11 1614 fastCert11_1614=true) ∧ (checkCertificateFast 11 1615 fastCert11_1615=true) ∧ (checkCertificateFast 11 1616 fastCert11_1616=true) ∧ (checkCertificateFast 11 1617 fastCert11_1617=true) ∧ (checkCertificateFast 11 1618 fastCert11_1618=true) ∧ (checkCertificateFast 11 1619 fastCert11_1619=true) ∧ (checkCertificateFast 11 1620 fastCert11_1620=true) ∧ (checkCertificateFast 11 1621 fastCert11_1621=true) ∧ (checkCertificateFast 11 1622 fastCert11_1622=true) ∧ (checkCertificateFast 11 1623 fastCert11_1623=true) ∧ (checkCertificateFast 11 1624 fastCert11_1624=true) ∧ (checkCertificateFast 11 1625 fastCert11_1625=true) ∧ (checkCertificateFast 11 1626 fastCert11_1626=true) ∧ (checkCertificateFast 11 1627 fastCert11_1627=true) ∧ (checkCertificateFast 11 1628 fastCert11_1628=true) ∧ (checkCertificateFast 11 1629 fastCert11_1629=true) ∧ (checkCertificateFast 11 1630 fastCert11_1630=true) ∧ (checkCertificateFast 11 1631 fastCert11_1631=true) ∧ (checkCertificateFast 11 1632 fastCert11_1632=true) ∧ (checkCertificateFast 11 1633 fastCert11_1633=true) ∧ (checkCertificateFast 11 1634 fastCert11_1634=true) ∧ (checkCertificateFast 11 1635 fastCert11_1635=true) ∧ (checkCertificateFast 11 1636 fastCert11_1636=true) ∧ (checkCertificateFast 11 1637 fastCert11_1637=true) ∧ (checkCertificateFast 11 1638 fastCert11_1638=true) ∧ (checkCertificateFast 11 1639 fastCert11_1639=true) ∧ (checkCertificateFast 11 1640 fastCert11_1640=true) ∧ (checkCertificateFast 11 1641 fastCert11_1641=true) ∧ (checkCertificateFast 11 1642 fastCert11_1642=true) ∧ (checkCertificateFast 11 1643 fastCert11_1643=true) ∧ (checkCertificateFast 11 1644 fastCert11_1644=true) ∧ (checkCertificateFast 11 1645 fastCert11_1645=true) ∧ (checkCertificateFast 11 1646 fastCert11_1646=true) ∧ (checkCertificateFast 11 1647 fastCert11_1647=true) ∧ (checkCertificateFast 11 1648 fastCert11_1648=true) ∧ (checkCertificateFast 11 1649 fastCert11_1649=true) ∧ (checkCertificateFast 11 1650 fastCert11_1650=true) ∧ (checkCertificateFast 11 1651 fastCert11_1651=true) ∧ (checkCertificateFast 11 1652 fastCert11_1652=true) ∧ (checkCertificateFast 11 1653 fastCert11_1653=true) ∧ (checkCertificateFast 11 1654 fastCert11_1654=true) ∧ (checkCertificateFast 11 1655 fastCert11_1655=true) ∧ (checkCertificateFast 11 1656 fastCert11_1656=true) ∧ (checkCertificateFast 11 1657 fastCert11_1657=true) ∧ (checkCertificateFast 11 1658 fastCert11_1658=true) ∧ (checkCertificateFast 11 1659 fastCert11_1659=true) ∧ (checkCertificateFast 11 1660 fastCert11_1660=true) ∧ (checkCertificateFast 11 1661 fastCert11_1661=true) ∧ (checkCertificateFast 11 1662 fastCert11_1662=true) ∧ (checkCertificateFast 11 1663 fastCert11_1663=true) ∧ (checkCertificateFast 11 1664 fastCert11_1664=true) ∧ (checkCertificateFast 11 1665 fastCert11_1665=true) ∧ (checkCertificateFast 11 1666 fastCert11_1666=true) ∧ (checkCertificateFast 11 1667 fastCert11_1667=true) ∧ (checkCertificateFast 11 1668 fastCert11_1668=true) ∧ (checkCertificateFast 11 1669 fastCert11_1669=true) ∧ (checkCertificateFast 11 1670 fastCert11_1670=true) ∧ (checkCertificateFast 11 1671 fastCert11_1671=true) ∧ (checkCertificateFast 11 1672 fastCert11_1672=true) ∧ (checkCertificateFast 11 1673 fastCert11_1673=true) ∧ (checkCertificateFast 11 1674 fastCert11_1674=true) ∧ (checkCertificateFast 11 1675 fastCert11_1675=true) ∧ (checkCertificateFast 11 1676 fastCert11_1676=true) ∧ (checkCertificateFast 11 1677 fastCert11_1677=true) ∧ (checkCertificateFast 11 1678 fastCert11_1678=true) ∧ (checkCertificateFast 11 1679 fastCert11_1679=true) ∧ (checkCertificateFast 11 1680 fastCert11_1680=true) ∧ (checkCertificateFast 11 1681 fastCert11_1681=true) ∧ (checkCertificateFast 11 1682 fastCert11_1682=true) ∧ (checkCertificateFast 11 1683 fastCert11_1683=true) ∧ (checkCertificateFast 11 1684 fastCert11_1684=true) ∧ (checkCertificateFast 11 1685 fastCert11_1685=true) ∧ (checkCertificateFast 11 1686 fastCert11_1686=true) ∧ (checkCertificateFast 11 1687 fastCert11_1687=true) ∧ (checkCertificateFast 11 1688 fastCert11_1688=true) ∧ (checkCertificateFast 11 1689 fastCert11_1689=true) ∧ (checkCertificateFast 11 1690 fastCert11_1690=true) ∧ (checkCertificateFast 11 1691 fastCert11_1691=true) ∧ (checkCertificateFast 11 1692 fastCert11_1692=true) ∧ (checkCertificateFast 11 1693 fastCert11_1693=true) ∧ (checkCertificateFast 11 1694 fastCert11_1694=true) ∧ (checkCertificateFast 11 1695 fastCert11_1695=true) ∧ (checkCertificateFast 11 1696 fastCert11_1696=true) ∧ (checkCertificateFast 11 1697 fastCert11_1697=true) ∧ (checkCertificateFast 11 1698 fastCert11_1698=true) ∧ (checkCertificateFast 11 1699 fastCert11_1699=true) ∧ (checkCertificateFast 11 1700 fastCert11_1700=true) ∧ (checkCertificateFast 11 1701 fastCert11_1701=true) ∧ (checkCertificateFast 11 1702 fastCert11_1702=true) ∧ (checkCertificateFast 11 1703 fastCert11_1703=true) ∧ (checkCertificateFast 11 1704 fastCert11_1704=true) ∧ (checkCertificateFast 11 1705 fastCert11_1705=true) ∧ (checkCertificateFast 11 1706 fastCert11_1706=true) ∧ (checkCertificateFast 11 1707 fastCert11_1707=true) ∧ (checkCertificateFast 11 1708 fastCert11_1708=true) ∧ (checkCertificateFast 11 1709 fastCert11_1709=true) ∧ (checkCertificateFast 11 1710 fastCert11_1710=true) ∧ (checkCertificateFast 11 1711 fastCert11_1711=true) ∧ (checkCertificateFast 11 1712 fastCert11_1712=true) ∧ (checkCertificateFast 11 1713 fastCert11_1713=true) ∧ (checkCertificateFast 11 1714 fastCert11_1714=true) ∧ (checkCertificateFast 11 1715 fastCert11_1715=true) ∧ (checkCertificateFast 11 1716 fastCert11_1716=true) ∧ (checkCertificateFast 11 1717 fastCert11_1717=true) ∧ (checkCertificateFast 11 1718 fastCert11_1718=true) ∧ (checkCertificateFast 11 1719 fastCert11_1719=true) ∧ (checkCertificateFast 11 1720 fastCert11_1720=true) ∧ (checkCertificateFast 11 1721 fastCert11_1721=true) ∧ (checkCertificateFast 11 1722 fastCert11_1722=true) ∧ (checkCertificateFast 11 1723 fastCert11_1723=true) ∧ (checkCertificateFast 11 1724 fastCert11_1724=true) ∧ (checkCertificateFast 11 1725 fastCert11_1725=true) ∧ (checkCertificateFast 11 1726 fastCert11_1726=true) ∧ (checkCertificateFast 11 1727 fastCert11_1727=true) ∧ (checkCertificateFast 11 1728 fastCert11_1728=true) ∧ (checkCertificateFast 11 1729 fastCert11_1729=true) ∧ (checkCertificateFast 11 1730 fastCert11_1730=true) ∧ (checkCertificateFast 11 1731 fastCert11_1731=true) ∧ (checkCertificateFast 11 1732 fastCert11_1732=true) ∧ (checkCertificateFast 11 1733 fastCert11_1733=true) ∧ (checkCertificateFast 11 1734 fastCert11_1734=true) ∧ (checkCertificateFast 11 1735 fastCert11_1735=true) ∧ (checkCertificateFast 11 1736 fastCert11_1736=true) ∧ (checkCertificateFast 11 1737 fastCert11_1737=true) ∧ (checkCertificateFast 11 1738 fastCert11_1738=true) ∧ (checkCertificateFast 11 1739 fastCert11_1739=true) ∧ (checkCertificateFast 11 1740 fastCert11_1740=true) ∧ (checkCertificateFast 11 1741 fastCert11_1741=true) ∧ (checkCertificateFast 11 1742 fastCert11_1742=true) ∧ (checkCertificateFast 11 1743 fastCert11_1743=true) ∧ (checkCertificateFast 11 1744 fastCert11_1744=true) ∧ (checkCertificateFast 11 1745 fastCert11_1745=true) ∧ (checkCertificateFast 11 1746 fastCert11_1746=true) ∧ (checkCertificateFast 11 1747 fastCert11_1747=true) ∧ (checkCertificateFast 11 1748 fastCert11_1748=true) ∧ (checkCertificateFast 11 1749 fastCert11_1749=true) ∧ (checkCertificateFast 11 1750 fastCert11_1750=true) ∧ (checkCertificateFast 11 1751 fastCert11_1751=true) ∧ (checkCertificateFast 11 1752 fastCert11_1752=true) ∧ (checkCertificateFast 11 1753 fastCert11_1753=true) ∧ (checkCertificateFast 11 1754 fastCert11_1754=true) ∧ (checkCertificateFast 11 1755 fastCert11_1755=true) ∧ (checkCertificateFast 11 1756 fastCert11_1756=true) ∧ (checkCertificateFast 11 1757 fastCert11_1757=true) ∧ (checkCertificateFast 11 1758 fastCert11_1758=true) ∧ (checkCertificateFast 11 1759 fastCert11_1759=true) ∧ (checkCertificateFast 11 1760 fastCert11_1760=true) ∧ (checkCertificateFast 11 1761 fastCert11_1761=true) ∧ (checkCertificateFast 11 1762 fastCert11_1762=true) ∧ (checkCertificateFast 11 1763 fastCert11_1763=true) ∧ (checkCertificateFast 11 1764 fastCert11_1764=true) ∧ (checkCertificateFast 11 1765 fastCert11_1765=true) ∧ (checkCertificateFast 11 1766 fastCert11_1766=true) ∧ (checkCertificateFast 11 1767 fastCert11_1767=true) ∧ (checkCertificateFast 11 1768 fastCert11_1768=true) ∧ (checkCertificateFast 11 1769 fastCert11_1769=true) ∧ (checkCertificateFast 11 1770 fastCert11_1770=true) ∧ (checkCertificateFast 11 1771 fastCert11_1771=true) ∧ (checkCertificateFast 11 1772 fastCert11_1772=true) ∧ (checkCertificateFast 11 1773 fastCert11_1773=true) ∧ (checkCertificateFast 11 1774 fastCert11_1774=true) ∧ (checkCertificateFast 11 1775 fastCert11_1775=true) ∧ (checkCertificateFast 11 1776 fastCert11_1776=true) ∧ (checkCertificateFast 11 1777 fastCert11_1777=true) ∧ (checkCertificateFast 11 1778 fastCert11_1778=true) ∧ (checkCertificateFast 11 1779 fastCert11_1779=true) ∧ (checkCertificateFast 11 1780 fastCert11_1780=true) ∧ (checkCertificateFast 11 1781 fastCert11_1781=true) ∧ (checkCertificateFast 11 1782 fastCert11_1782=true) ∧ (checkCertificateFast 11 1783 fastCert11_1783=true) ∧ (checkCertificateFast 11 1784 fastCert11_1784=true) ∧ (checkCertificateFast 11 1785 fastCert11_1785=true) ∧ (checkCertificateFast 11 1786 fastCert11_1786=true) ∧ (checkCertificateFast 11 1787 fastCert11_1787=true) ∧ (checkCertificateFast 11 1788 fastCert11_1788=true) ∧ (checkCertificateFast 11 1789 fastCert11_1789=true) ∧ (checkCertificateFast 11 1790 fastCert11_1790=true) ∧ (checkCertificateFast 11 1791 fastCert11_1791=true) ∧ (checkCertificateFast 11 1792 fastCert11_1792=true) ∧ (checkCertificateFast 11 1793 fastCert11_1793=true) ∧ (checkCertificateFast 11 1794 fastCert11_1794=true) ∧ (checkCertificateFast 11 1795 fastCert11_1795=true) ∧ (checkCertificateFast 11 1796 fastCert11_1796=true) ∧ (checkCertificateFast 11 1797 fastCert11_1797=true) ∧ (checkCertificateFast 11 1798 fastCert11_1798=true) ∧ (checkCertificateFast 11 1799 fastCert11_1799=true) ∧ (checkCertificateFast 11 1800 fastCert11_1800=true) ∧ (checkCertificateFast 11 1801 fastCert11_1801=true) ∧ (checkCertificateFast 11 1802 fastCert11_1802=true) ∧ (checkCertificateFast 11 1803 fastCert11_1803=true) ∧ (checkCertificateFast 11 1804 fastCert11_1804=true) ∧ (checkCertificateFast 11 1805 fastCert11_1805=true) ∧ (checkCertificateFast 11 1806 fastCert11_1806=true) ∧ (checkCertificateFast 11 1807 fastCert11_1807=true) ∧ (checkCertificateFast 11 1808 fastCert11_1808=true) ∧ (checkCertificateFast 11 1809 fastCert11_1809=true) ∧ (checkCertificateFast 11 1810 fastCert11_1810=true) ∧ (checkCertificateFast 11 1811 fastCert11_1811=true) ∧ (checkCertificateFast 11 1812 fastCert11_1812=true) ∧ (checkCertificateFast 11 1813 fastCert11_1813=true) ∧ (checkCertificateFast 11 1814 fastCert11_1814=true) ∧ (checkCertificateFast 11 1815 fastCert11_1815=true) ∧ (checkCertificateFast 11 1816 fastCert11_1816=true) ∧ (checkCertificateFast 11 1817 fastCert11_1817=true) ∧ (checkCertificateFast 11 1818 fastCert11_1818=true) ∧ (checkCertificateFast 11 1819 fastCert11_1819=true) ∧ (checkCertificateFast 11 1820 fastCert11_1820=true) ∧ (checkCertificateFast 11 1821 fastCert11_1821=true) ∧ (checkCertificateFast 11 1822 fastCert11_1822=true) ∧ (checkCertificateFast 11 1823 fastCert11_1823=true) ∧ (checkCertificateFast 11 1824 fastCert11_1824=true) ∧ (checkCertificateFast 11 1825 fastCert11_1825=true) ∧ (checkCertificateFast 11 1826 fastCert11_1826=true) ∧ (checkCertificateFast 11 1827 fastCert11_1827=true) ∧ (checkCertificateFast 11 1828 fastCert11_1828=true) ∧ (checkCertificateFast 11 1829 fastCert11_1829=true) ∧ (checkCertificateFast 11 1830 fastCert11_1830=true) ∧ (checkCertificateFast 11 1831 fastCert11_1831=true) ∧ (checkCertificateFast 11 1832 fastCert11_1832=true) ∧ (checkCertificateFast 11 1833 fastCert11_1833=true) ∧ (checkCertificateFast 11 1834 fastCert11_1834=true) ∧ (checkCertificateFast 11 1835 fastCert11_1835=true) ∧ (checkCertificateFast 11 1836 fastCert11_1836=true) ∧ (checkCertificateFast 11 1837 fastCert11_1837=true) ∧ (checkCertificateFast 11 1838 fastCert11_1838=true) ∧ (checkCertificateFast 11 1839 fastCert11_1839=true) ∧ (checkCertificateFast 11 1840 fastCert11_1840=true) ∧ (checkCertificateFast 11 1841 fastCert11_1841=true) ∧ (checkCertificateFast 11 1842 fastCert11_1842=true) ∧ (checkCertificateFast 11 1843 fastCert11_1843=true) ∧ (checkCertificateFast 11 1844 fastCert11_1844=true) ∧ (checkCertificateFast 11 1845 fastCert11_1845=true) ∧ (checkCertificateFast 11 1846 fastCert11_1846=true) ∧ (checkCertificateFast 11 1847 fastCert11_1847=true) ∧ (checkCertificateFast 11 1848 fastCert11_1848=true) ∧ (checkCertificateFast 11 1849 fastCert11_1849=true) ∧ (checkCertificateFast 11 1850 fastCert11_1850=true) ∧ (checkCertificateFast 11 1851 fastCert11_1851=true) ∧ (checkCertificateFast 11 1852 fastCert11_1852=true) ∧ (checkCertificateFast 11 1853 fastCert11_1853=true) ∧ (checkCertificateFast 11 1854 fastCert11_1854=true) ∧ (checkCertificateFast 11 1855 fastCert11_1855=true) ∧ (checkCertificateFast 11 1856 fastCert11_1856=true) ∧ (checkCertificateFast 11 1857 fastCert11_1857=true) ∧ (checkCertificateFast 11 1858 fastCert11_1858=true) ∧ (checkCertificateFast 11 1859 fastCert11_1859=true) ∧ (checkCertificateFast 11 1860 fastCert11_1860=true) ∧ (checkCertificateFast 11 1861 fastCert11_1861=true) ∧ (checkCertificateFast 11 1862 fastCert11_1862=true) ∧ (checkCertificateFast 11 1863 fastCert11_1863=true) ∧ (checkCertificateFast 11 1864 fastCert11_1864=true) ∧ (checkCertificateFast 11 1865 fastCert11_1865=true) ∧ (checkCertificateFast 11 1866 fastCert11_1866=true) ∧ (checkCertificateFast 11 1867 fastCert11_1867=true) ∧ (checkCertificateFast 11 1868 fastCert11_1868=true) ∧ (checkCertificateFast 11 1869 fastCert11_1869=true) ∧ (checkCertificateFast 11 1870 fastCert11_1870=true) ∧ (checkCertificateFast 11 1871 fastCert11_1871=true) ∧ (checkCertificateFast 11 1872 fastCert11_1872=true) ∧ (checkCertificateFast 11 1873 fastCert11_1873=true) ∧ (checkCertificateFast 11 1874 fastCert11_1874=true) ∧ (checkCertificateFast 11 1875 fastCert11_1875=true) ∧ (checkCertificateFast 11 1876 fastCert11_1876=true) ∧ (checkCertificateFast 11 1877 fastCert11_1877=true) ∧ (checkCertificateFast 11 1878 fastCert11_1878=true) ∧ (checkCertificateFast 11 1879 fastCert11_1879=true) ∧ (checkCertificateFast 11 1880 fastCert11_1880=true) ∧ (checkCertificateFast 11 1881 fastCert11_1881=true) ∧ (checkCertificateFast 11 1882 fastCert11_1882=true) ∧ (checkCertificateFast 11 1883 fastCert11_1883=true) ∧ (checkCertificateFast 11 1884 fastCert11_1884=true) ∧ (checkCertificateFast 11 1885 fastCert11_1885=true) ∧ (checkCertificateFast 11 1886 fastCert11_1886=true) ∧ (checkCertificateFast 11 1887 fastCert11_1887=true) ∧ (checkCertificateFast 11 1888 fastCert11_1888=true) ∧ (checkCertificateFast 11 1889 fastCert11_1889=true) ∧ (checkCertificateFast 11 1890 fastCert11_1890=true) ∧ (checkCertificateFast 11 1891 fastCert11_1891=true) ∧ (checkCertificateFast 11 1892 fastCert11_1892=true) ∧ (checkCertificateFast 11 1893 fastCert11_1893=true) ∧ (checkCertificateFast 11 1894 fastCert11_1894=true) ∧ (checkCertificateFast 11 1895 fastCert11_1895=true) ∧ (checkCertificateFast 11 1896 fastCert11_1896=true) ∧ (checkCertificateFast 11 1897 fastCert11_1897=true) ∧ (checkCertificateFast 11 1898 fastCert11_1898=true) ∧ (checkCertificateFast 11 1899 fastCert11_1899=true) ∧ (checkCertificateFast 11 1900 fastCert11_1900=true) ∧ (checkCertificateFast 11 1901 fastCert11_1901=true) ∧ (checkCertificateFast 11 1902 fastCert11_1902=true) ∧ (checkCertificateFast 11 1903 fastCert11_1903=true) ∧ (checkCertificateFast 11 1904 fastCert11_1904=true) ∧ (checkCertificateFast 11 1905 fastCert11_1905=true) ∧ (checkCertificateFast 11 1906 fastCert11_1906=true) ∧ (checkCertificateFast 11 1907 fastCert11_1907=true) ∧ (checkCertificateFast 11 1908 fastCert11_1908=true) ∧ (checkCertificateFast 11 1909 fastCert11_1909=true) ∧ (checkCertificateFast 11 1910 fastCert11_1910=true) ∧ (checkCertificateFast 11 1911 fastCert11_1911=true) ∧ (checkCertificateFast 11 1912 fastCert11_1912=true) ∧ (checkCertificateFast 11 1913 fastCert11_1913=true) ∧ (checkCertificateFast 11 1914 fastCert11_1914=true) ∧ (checkCertificateFast 11 1915 fastCert11_1915=true) ∧ (checkCertificateFast 11 1916 fastCert11_1916=true) ∧ (checkCertificateFast 11 1917 fastCert11_1917=true) ∧ (checkCertificateFast 11 1918 fastCert11_1918=true) ∧ (checkCertificateFast 11 1919 fastCert11_1919=true) ∧ (checkCertificateFast 11 1920 fastCert11_1920=true) ∧ (checkCertificateFast 11 1921 fastCert11_1921=true) ∧ (checkCertificateFast 11 1922 fastCert11_1922=true) ∧ (checkCertificateFast 11 1923 fastCert11_1923=true) ∧ (checkCertificateFast 11 1924 fastCert11_1924=true) ∧ (checkCertificateFast 11 1925 fastCert11_1925=true) ∧ (checkCertificateFast 11 1926 fastCert11_1926=true) ∧ (checkCertificateFast 11 1927 fastCert11_1927=true) ∧ (checkCertificateFast 11 1928 fastCert11_1928=true) ∧ (checkCertificateFast 11 1929 fastCert11_1929=true) ∧ (checkCertificateFast 11 1930 fastCert11_1930=true) ∧ (checkCertificateFast 11 1931 fastCert11_1931=true) ∧ (checkCertificateFast 11 1932 fastCert11_1932=true) ∧ (checkCertificateFast 11 1933 fastCert11_1933=true) ∧ (checkCertificateFast 11 1934 fastCert11_1934=true) ∧ (checkCertificateFast 11 1935 fastCert11_1935=true) ∧ (checkCertificateFast 11 1936 fastCert11_1936=true) ∧ (checkCertificateFast 11 1937 fastCert11_1937=true) ∧ (checkCertificateFast 11 1938 fastCert11_1938=true) ∧ (checkCertificateFast 11 1939 fastCert11_1939=true) ∧ (checkCertificateFast 11 1940 fastCert11_1940=true) ∧ (checkCertificateFast 11 1941 fastCert11_1941=true) ∧ (checkCertificateFast 11 1942 fastCert11_1942=true) ∧ (checkCertificateFast 11 1943 fastCert11_1943=true) ∧ (checkCertificateFast 11 1944 fastCert11_1944=true) ∧ (checkCertificateFast 11 1945 fastCert11_1945=true) ∧ (checkCertificateFast 11 1946 fastCert11_1946=true) ∧ (checkCertificateFast 11 1947 fastCert11_1947=true) ∧ (checkCertificateFast 11 1948 fastCert11_1948=true) ∧ (checkCertificateFast 11 1949 fastCert11_1949=true) ∧ (checkCertificateFast 11 1950 fastCert11_1950=true) ∧ (checkCertificateFast 11 1951 fastCert11_1951=true) ∧ (checkCertificateFast 11 1952 fastCert11_1952=true) ∧ (checkCertificateFast 11 1953 fastCert11_1953=true) ∧ (checkCertificateFast 11 1954 fastCert11_1954=true) ∧ (checkCertificateFast 11 1955 fastCert11_1955=true) ∧ (checkCertificateFast 11 1956 fastCert11_1956=true) ∧ (checkCertificateFast 11 1957 fastCert11_1957=true) ∧ (checkCertificateFast 11 1958 fastCert11_1958=true) ∧ (checkCertificateFast 11 1959 fastCert11_1959=true) ∧ (checkCertificateFast 11 1960 fastCert11_1960=true) ∧ (checkCertificateFast 11 1961 fastCert11_1961=true) ∧ (checkCertificateFast 11 1962 fastCert11_1962=true) ∧ (checkCertificateFast 11 1963 fastCert11_1963=true) ∧ (checkCertificateFast 11 1964 fastCert11_1964=true) ∧ (checkCertificateFast 11 1965 fastCert11_1965=true) ∧ (checkCertificateFast 11 1966 fastCert11_1966=true) ∧ (checkCertificateFast 11 1967 fastCert11_1967=true) ∧ (checkCertificateFast 11 1968 fastCert11_1968=true) ∧ (checkCertificateFast 11 1969 fastCert11_1969=true) ∧ (checkCertificateFast 11 1970 fastCert11_1970=true) ∧ (checkCertificateFast 11 1971 fastCert11_1971=true) ∧ (checkCertificateFast 11 1972 fastCert11_1972=true) ∧ (checkCertificateFast 11 1973 fastCert11_1973=true) ∧ (checkCertificateFast 11 1974 fastCert11_1974=true) ∧ (checkCertificateFast 11 1975 fastCert11_1975=true) ∧ (checkCertificateFast 11 1976 fastCert11_1976=true) ∧ (checkCertificateFast 11 1977 fastCert11_1977=true) ∧ (checkCertificateFast 11 1978 fastCert11_1978=true) ∧ (checkCertificateFast 11 1979 fastCert11_1979=true) ∧ (checkCertificateFast 11 1980 fastCert11_1980=true) ∧ (checkCertificateFast 11 1981 fastCert11_1981=true) ∧ (checkCertificateFast 11 1982 fastCert11_1982=true) ∧ (checkCertificateFast 11 1983 fastCert11_1983=true) ∧ (checkCertificateFast 11 1984 fastCert11_1984=true) ∧ (checkCertificateFast 11 1985 fastCert11_1985=true) ∧ (checkCertificateFast 11 1986 fastCert11_1986=true) ∧ (checkCertificateFast 11 1987 fastCert11_1987=true) ∧ (checkCertificateFast 11 1988 fastCert11_1988=true) ∧ (checkCertificateFast 11 1989 fastCert11_1989=true) ∧ (checkCertificateFast 11 1990 fastCert11_1990=true) ∧ (checkCertificateFast 11 1991 fastCert11_1991=true) ∧ (checkCertificateFast 11 1992 fastCert11_1992=true) ∧ (checkCertificateFast 11 1993 fastCert11_1993=true) ∧ (checkCertificateFast 11 1994 fastCert11_1994=true) ∧ (checkCertificateFast 11 1995 fastCert11_1995=true) ∧ (checkCertificateFast 11 1996 fastCert11_1996=true) ∧ (checkCertificateFast 11 1997 fastCert11_1997=true) ∧ (checkCertificateFast 11 1998 fastCert11_1998=true) ∧ (checkCertificateFast 11 1999 fastCert11_1999=true) :=
  ⟨fastCase11_1000,fastCase11_1001,fastCase11_1002,fastCase11_1003,fastCase11_1004,fastCase11_1005,fastCase11_1006,fastCase11_1007,fastCase11_1008,fastCase11_1009,fastCase11_1010,fastCase11_1011,fastCase11_1012,fastCase11_1013,fastCase11_1014,fastCase11_1015,fastCase11_1016,fastCase11_1017,fastCase11_1018,fastCase11_1019,fastCase11_1020,fastCase11_1021,fastCase11_1022,fastCase11_1023,fastCase11_1024,fastCase11_1025,fastCase11_1026,fastCase11_1027,fastCase11_1028,fastCase11_1029,fastCase11_1030,fastCase11_1031,fastCase11_1032,fastCase11_1033,fastCase11_1034,fastCase11_1035,fastCase11_1036,fastCase11_1037,fastCase11_1038,fastCase11_1039,fastCase11_1040,fastCase11_1041,fastCase11_1042,fastCase11_1043,fastCase11_1044,fastCase11_1045,fastCase11_1046,fastCase11_1047,fastCase11_1048,fastCase11_1049,fastCase11_1050,fastCase11_1051,fastCase11_1052,fastCase11_1053,fastCase11_1054,fastCase11_1055,fastCase11_1056,fastCase11_1057,fastCase11_1058,fastCase11_1059,fastCase11_1060,fastCase11_1061,fastCase11_1062,fastCase11_1063,fastCase11_1064,fastCase11_1065,fastCase11_1066,fastCase11_1067,fastCase11_1068,fastCase11_1069,fastCase11_1070,fastCase11_1071,fastCase11_1072,fastCase11_1073,fastCase11_1074,fastCase11_1075,fastCase11_1076,fastCase11_1077,fastCase11_1078,fastCase11_1079,fastCase11_1080,fastCase11_1081,fastCase11_1082,fastCase11_1083,fastCase11_1084,fastCase11_1085,fastCase11_1086,fastCase11_1087,fastCase11_1088,fastCase11_1089,fastCase11_1090,fastCase11_1091,fastCase11_1092,fastCase11_1093,fastCase11_1094,fastCase11_1095,fastCase11_1096,fastCase11_1097,fastCase11_1098,fastCase11_1099,fastCase11_1100,fastCase11_1101,fastCase11_1102,fastCase11_1103,fastCase11_1104,fastCase11_1105,fastCase11_1106,fastCase11_1107,fastCase11_1108,fastCase11_1109,fastCase11_1110,fastCase11_1111,fastCase11_1112,fastCase11_1113,fastCase11_1114,fastCase11_1115,fastCase11_1116,fastCase11_1117,fastCase11_1118,fastCase11_1119,fastCase11_1120,fastCase11_1121,fastCase11_1122,fastCase11_1123,fastCase11_1124,fastCase11_1125,fastCase11_1126,fastCase11_1127,fastCase11_1128,fastCase11_1129,fastCase11_1130,fastCase11_1131,fastCase11_1132,fastCase11_1133,fastCase11_1134,fastCase11_1135,fastCase11_1136,fastCase11_1137,fastCase11_1138,fastCase11_1139,fastCase11_1140,fastCase11_1141,fastCase11_1142,fastCase11_1143,fastCase11_1144,fastCase11_1145,fastCase11_1146,fastCase11_1147,fastCase11_1148,fastCase11_1149,fastCase11_1150,fastCase11_1151,fastCase11_1152,fastCase11_1153,fastCase11_1154,fastCase11_1155,fastCase11_1156,fastCase11_1157,fastCase11_1158,fastCase11_1159,fastCase11_1160,fastCase11_1161,fastCase11_1162,fastCase11_1163,fastCase11_1164,fastCase11_1165,fastCase11_1166,fastCase11_1167,fastCase11_1168,fastCase11_1169,fastCase11_1170,fastCase11_1171,fastCase11_1172,fastCase11_1173,fastCase11_1174,fastCase11_1175,fastCase11_1176,fastCase11_1177,fastCase11_1178,fastCase11_1179,fastCase11_1180,fastCase11_1181,fastCase11_1182,fastCase11_1183,fastCase11_1184,fastCase11_1185,fastCase11_1186,fastCase11_1187,fastCase11_1188,fastCase11_1189,fastCase11_1190,fastCase11_1191,fastCase11_1192,fastCase11_1193,fastCase11_1194,fastCase11_1195,fastCase11_1196,fastCase11_1197,fastCase11_1198,fastCase11_1199,fastCase11_1200,fastCase11_1201,fastCase11_1202,fastCase11_1203,fastCase11_1204,fastCase11_1205,fastCase11_1206,fastCase11_1207,fastCase11_1208,fastCase11_1209,fastCase11_1210,fastCase11_1211,fastCase11_1212,fastCase11_1213,fastCase11_1214,fastCase11_1215,fastCase11_1216,fastCase11_1217,fastCase11_1218,fastCase11_1219,fastCase11_1220,fastCase11_1221,fastCase11_1222,fastCase11_1223,fastCase11_1224,fastCase11_1225,fastCase11_1226,fastCase11_1227,fastCase11_1228,fastCase11_1229,fastCase11_1230,fastCase11_1231,fastCase11_1232,fastCase11_1233,fastCase11_1234,fastCase11_1235,fastCase11_1236,fastCase11_1237,fastCase11_1238,fastCase11_1239,fastCase11_1240,fastCase11_1241,fastCase11_1242,fastCase11_1243,fastCase11_1244,fastCase11_1245,fastCase11_1246,fastCase11_1247,fastCase11_1248,fastCase11_1249,fastCase11_1250,fastCase11_1251,fastCase11_1252,fastCase11_1253,fastCase11_1254,fastCase11_1255,fastCase11_1256,fastCase11_1257,fastCase11_1258,fastCase11_1259,fastCase11_1260,fastCase11_1261,fastCase11_1262,fastCase11_1263,fastCase11_1264,fastCase11_1265,fastCase11_1266,fastCase11_1267,fastCase11_1268,fastCase11_1269,fastCase11_1270,fastCase11_1271,fastCase11_1272,fastCase11_1273,fastCase11_1274,fastCase11_1275,fastCase11_1276,fastCase11_1277,fastCase11_1278,fastCase11_1279,fastCase11_1280,fastCase11_1281,fastCase11_1282,fastCase11_1283,fastCase11_1284,fastCase11_1285,fastCase11_1286,fastCase11_1287,fastCase11_1288,fastCase11_1289,fastCase11_1290,fastCase11_1291,fastCase11_1292,fastCase11_1293,fastCase11_1294,fastCase11_1295,fastCase11_1296,fastCase11_1297,fastCase11_1298,fastCase11_1299,fastCase11_1300,fastCase11_1301,fastCase11_1302,fastCase11_1303,fastCase11_1304,fastCase11_1305,fastCase11_1306,fastCase11_1307,fastCase11_1308,fastCase11_1309,fastCase11_1310,fastCase11_1311,fastCase11_1312,fastCase11_1313,fastCase11_1314,fastCase11_1315,fastCase11_1316,fastCase11_1317,fastCase11_1318,fastCase11_1319,fastCase11_1320,fastCase11_1321,fastCase11_1322,fastCase11_1323,fastCase11_1324,fastCase11_1325,fastCase11_1326,fastCase11_1327,fastCase11_1328,fastCase11_1329,fastCase11_1330,fastCase11_1331,fastCase11_1332,fastCase11_1333,fastCase11_1334,fastCase11_1335,fastCase11_1336,fastCase11_1337,fastCase11_1338,fastCase11_1339,fastCase11_1340,fastCase11_1341,fastCase11_1342,fastCase11_1343,fastCase11_1344,fastCase11_1345,fastCase11_1346,fastCase11_1347,fastCase11_1348,fastCase11_1349,fastCase11_1350,fastCase11_1351,fastCase11_1352,fastCase11_1353,fastCase11_1354,fastCase11_1355,fastCase11_1356,fastCase11_1357,fastCase11_1358,fastCase11_1359,fastCase11_1360,fastCase11_1361,fastCase11_1362,fastCase11_1363,fastCase11_1364,fastCase11_1365,fastCase11_1366,fastCase11_1367,fastCase11_1368,fastCase11_1369,fastCase11_1370,fastCase11_1371,fastCase11_1372,fastCase11_1373,fastCase11_1374,fastCase11_1375,fastCase11_1376,fastCase11_1377,fastCase11_1378,fastCase11_1379,fastCase11_1380,fastCase11_1381,fastCase11_1382,fastCase11_1383,fastCase11_1384,fastCase11_1385,fastCase11_1386,fastCase11_1387,fastCase11_1388,fastCase11_1389,fastCase11_1390,fastCase11_1391,fastCase11_1392,fastCase11_1393,fastCase11_1394,fastCase11_1395,fastCase11_1396,fastCase11_1397,fastCase11_1398,fastCase11_1399,fastCase11_1400,fastCase11_1401,fastCase11_1402,fastCase11_1403,fastCase11_1404,fastCase11_1405,fastCase11_1406,fastCase11_1407,fastCase11_1408,fastCase11_1409,fastCase11_1410,fastCase11_1411,fastCase11_1412,fastCase11_1413,fastCase11_1414,fastCase11_1415,fastCase11_1416,fastCase11_1417,fastCase11_1418,fastCase11_1419,fastCase11_1420,fastCase11_1421,fastCase11_1422,fastCase11_1423,fastCase11_1424,fastCase11_1425,fastCase11_1426,fastCase11_1427,fastCase11_1428,fastCase11_1429,fastCase11_1430,fastCase11_1431,fastCase11_1432,fastCase11_1433,fastCase11_1434,fastCase11_1435,fastCase11_1436,fastCase11_1437,fastCase11_1438,fastCase11_1439,fastCase11_1440,fastCase11_1441,fastCase11_1442,fastCase11_1443,fastCase11_1444,fastCase11_1445,fastCase11_1446,fastCase11_1447,fastCase11_1448,fastCase11_1449,fastCase11_1450,fastCase11_1451,fastCase11_1452,fastCase11_1453,fastCase11_1454,fastCase11_1455,fastCase11_1456,fastCase11_1457,fastCase11_1458,fastCase11_1459,fastCase11_1460,fastCase11_1461,fastCase11_1462,fastCase11_1463,fastCase11_1464,fastCase11_1465,fastCase11_1466,fastCase11_1467,fastCase11_1468,fastCase11_1469,fastCase11_1470,fastCase11_1471,fastCase11_1472,fastCase11_1473,fastCase11_1474,fastCase11_1475,fastCase11_1476,fastCase11_1477,fastCase11_1478,fastCase11_1479,fastCase11_1480,fastCase11_1481,fastCase11_1482,fastCase11_1483,fastCase11_1484,fastCase11_1485,fastCase11_1486,fastCase11_1487,fastCase11_1488,fastCase11_1489,fastCase11_1490,fastCase11_1491,fastCase11_1492,fastCase11_1493,fastCase11_1494,fastCase11_1495,fastCase11_1496,fastCase11_1497,fastCase11_1498,fastCase11_1499,fastCase11_1500,fastCase11_1501,fastCase11_1502,fastCase11_1503,fastCase11_1504,fastCase11_1505,fastCase11_1506,fastCase11_1507,fastCase11_1508,fastCase11_1509,fastCase11_1510,fastCase11_1511,fastCase11_1512,fastCase11_1513,fastCase11_1514,fastCase11_1515,fastCase11_1516,fastCase11_1517,fastCase11_1518,fastCase11_1519,fastCase11_1520,fastCase11_1521,fastCase11_1522,fastCase11_1523,fastCase11_1524,fastCase11_1525,fastCase11_1526,fastCase11_1527,fastCase11_1528,fastCase11_1529,fastCase11_1530,fastCase11_1531,fastCase11_1532,fastCase11_1533,fastCase11_1534,fastCase11_1535,fastCase11_1536,fastCase11_1537,fastCase11_1538,fastCase11_1539,fastCase11_1540,fastCase11_1541,fastCase11_1542,fastCase11_1543,fastCase11_1544,fastCase11_1545,fastCase11_1546,fastCase11_1547,fastCase11_1548,fastCase11_1549,fastCase11_1550,fastCase11_1551,fastCase11_1552,fastCase11_1553,fastCase11_1554,fastCase11_1555,fastCase11_1556,fastCase11_1557,fastCase11_1558,fastCase11_1559,fastCase11_1560,fastCase11_1561,fastCase11_1562,fastCase11_1563,fastCase11_1564,fastCase11_1565,fastCase11_1566,fastCase11_1567,fastCase11_1568,fastCase11_1569,fastCase11_1570,fastCase11_1571,fastCase11_1572,fastCase11_1573,fastCase11_1574,fastCase11_1575,fastCase11_1576,fastCase11_1577,fastCase11_1578,fastCase11_1579,fastCase11_1580,fastCase11_1581,fastCase11_1582,fastCase11_1583,fastCase11_1584,fastCase11_1585,fastCase11_1586,fastCase11_1587,fastCase11_1588,fastCase11_1589,fastCase11_1590,fastCase11_1591,fastCase11_1592,fastCase11_1593,fastCase11_1594,fastCase11_1595,fastCase11_1596,fastCase11_1597,fastCase11_1598,fastCase11_1599,fastCase11_1600,fastCase11_1601,fastCase11_1602,fastCase11_1603,fastCase11_1604,fastCase11_1605,fastCase11_1606,fastCase11_1607,fastCase11_1608,fastCase11_1609,fastCase11_1610,fastCase11_1611,fastCase11_1612,fastCase11_1613,fastCase11_1614,fastCase11_1615,fastCase11_1616,fastCase11_1617,fastCase11_1618,fastCase11_1619,fastCase11_1620,fastCase11_1621,fastCase11_1622,fastCase11_1623,fastCase11_1624,fastCase11_1625,fastCase11_1626,fastCase11_1627,fastCase11_1628,fastCase11_1629,fastCase11_1630,fastCase11_1631,fastCase11_1632,fastCase11_1633,fastCase11_1634,fastCase11_1635,fastCase11_1636,fastCase11_1637,fastCase11_1638,fastCase11_1639,fastCase11_1640,fastCase11_1641,fastCase11_1642,fastCase11_1643,fastCase11_1644,fastCase11_1645,fastCase11_1646,fastCase11_1647,fastCase11_1648,fastCase11_1649,fastCase11_1650,fastCase11_1651,fastCase11_1652,fastCase11_1653,fastCase11_1654,fastCase11_1655,fastCase11_1656,fastCase11_1657,fastCase11_1658,fastCase11_1659,fastCase11_1660,fastCase11_1661,fastCase11_1662,fastCase11_1663,fastCase11_1664,fastCase11_1665,fastCase11_1666,fastCase11_1667,fastCase11_1668,fastCase11_1669,fastCase11_1670,fastCase11_1671,fastCase11_1672,fastCase11_1673,fastCase11_1674,fastCase11_1675,fastCase11_1676,fastCase11_1677,fastCase11_1678,fastCase11_1679,fastCase11_1680,fastCase11_1681,fastCase11_1682,fastCase11_1683,fastCase11_1684,fastCase11_1685,fastCase11_1686,fastCase11_1687,fastCase11_1688,fastCase11_1689,fastCase11_1690,fastCase11_1691,fastCase11_1692,fastCase11_1693,fastCase11_1694,fastCase11_1695,fastCase11_1696,fastCase11_1697,fastCase11_1698,fastCase11_1699,fastCase11_1700,fastCase11_1701,fastCase11_1702,fastCase11_1703,fastCase11_1704,fastCase11_1705,fastCase11_1706,fastCase11_1707,fastCase11_1708,fastCase11_1709,fastCase11_1710,fastCase11_1711,fastCase11_1712,fastCase11_1713,fastCase11_1714,fastCase11_1715,fastCase11_1716,fastCase11_1717,fastCase11_1718,fastCase11_1719,fastCase11_1720,fastCase11_1721,fastCase11_1722,fastCase11_1723,fastCase11_1724,fastCase11_1725,fastCase11_1726,fastCase11_1727,fastCase11_1728,fastCase11_1729,fastCase11_1730,fastCase11_1731,fastCase11_1732,fastCase11_1733,fastCase11_1734,fastCase11_1735,fastCase11_1736,fastCase11_1737,fastCase11_1738,fastCase11_1739,fastCase11_1740,fastCase11_1741,fastCase11_1742,fastCase11_1743,fastCase11_1744,fastCase11_1745,fastCase11_1746,fastCase11_1747,fastCase11_1748,fastCase11_1749,fastCase11_1750,fastCase11_1751,fastCase11_1752,fastCase11_1753,fastCase11_1754,fastCase11_1755,fastCase11_1756,fastCase11_1757,fastCase11_1758,fastCase11_1759,fastCase11_1760,fastCase11_1761,fastCase11_1762,fastCase11_1763,fastCase11_1764,fastCase11_1765,fastCase11_1766,fastCase11_1767,fastCase11_1768,fastCase11_1769,fastCase11_1770,fastCase11_1771,fastCase11_1772,fastCase11_1773,fastCase11_1774,fastCase11_1775,fastCase11_1776,fastCase11_1777,fastCase11_1778,fastCase11_1779,fastCase11_1780,fastCase11_1781,fastCase11_1782,fastCase11_1783,fastCase11_1784,fastCase11_1785,fastCase11_1786,fastCase11_1787,fastCase11_1788,fastCase11_1789,fastCase11_1790,fastCase11_1791,fastCase11_1792,fastCase11_1793,fastCase11_1794,fastCase11_1795,fastCase11_1796,fastCase11_1797,fastCase11_1798,fastCase11_1799,fastCase11_1800,fastCase11_1801,fastCase11_1802,fastCase11_1803,fastCase11_1804,fastCase11_1805,fastCase11_1806,fastCase11_1807,fastCase11_1808,fastCase11_1809,fastCase11_1810,fastCase11_1811,fastCase11_1812,fastCase11_1813,fastCase11_1814,fastCase11_1815,fastCase11_1816,fastCase11_1817,fastCase11_1818,fastCase11_1819,fastCase11_1820,fastCase11_1821,fastCase11_1822,fastCase11_1823,fastCase11_1824,fastCase11_1825,fastCase11_1826,fastCase11_1827,fastCase11_1828,fastCase11_1829,fastCase11_1830,fastCase11_1831,fastCase11_1832,fastCase11_1833,fastCase11_1834,fastCase11_1835,fastCase11_1836,fastCase11_1837,fastCase11_1838,fastCase11_1839,fastCase11_1840,fastCase11_1841,fastCase11_1842,fastCase11_1843,fastCase11_1844,fastCase11_1845,fastCase11_1846,fastCase11_1847,fastCase11_1848,fastCase11_1849,fastCase11_1850,fastCase11_1851,fastCase11_1852,fastCase11_1853,fastCase11_1854,fastCase11_1855,fastCase11_1856,fastCase11_1857,fastCase11_1858,fastCase11_1859,fastCase11_1860,fastCase11_1861,fastCase11_1862,fastCase11_1863,fastCase11_1864,fastCase11_1865,fastCase11_1866,fastCase11_1867,fastCase11_1868,fastCase11_1869,fastCase11_1870,fastCase11_1871,fastCase11_1872,fastCase11_1873,fastCase11_1874,fastCase11_1875,fastCase11_1876,fastCase11_1877,fastCase11_1878,fastCase11_1879,fastCase11_1880,fastCase11_1881,fastCase11_1882,fastCase11_1883,fastCase11_1884,fastCase11_1885,fastCase11_1886,fastCase11_1887,fastCase11_1888,fastCase11_1889,fastCase11_1890,fastCase11_1891,fastCase11_1892,fastCase11_1893,fastCase11_1894,fastCase11_1895,fastCase11_1896,fastCase11_1897,fastCase11_1898,fastCase11_1899,fastCase11_1900,fastCase11_1901,fastCase11_1902,fastCase11_1903,fastCase11_1904,fastCase11_1905,fastCase11_1906,fastCase11_1907,fastCase11_1908,fastCase11_1909,fastCase11_1910,fastCase11_1911,fastCase11_1912,fastCase11_1913,fastCase11_1914,fastCase11_1915,fastCase11_1916,fastCase11_1917,fastCase11_1918,fastCase11_1919,fastCase11_1920,fastCase11_1921,fastCase11_1922,fastCase11_1923,fastCase11_1924,fastCase11_1925,fastCase11_1926,fastCase11_1927,fastCase11_1928,fastCase11_1929,fastCase11_1930,fastCase11_1931,fastCase11_1932,fastCase11_1933,fastCase11_1934,fastCase11_1935,fastCase11_1936,fastCase11_1937,fastCase11_1938,fastCase11_1939,fastCase11_1940,fastCase11_1941,fastCase11_1942,fastCase11_1943,fastCase11_1944,fastCase11_1945,fastCase11_1946,fastCase11_1947,fastCase11_1948,fastCase11_1949,fastCase11_1950,fastCase11_1951,fastCase11_1952,fastCase11_1953,fastCase11_1954,fastCase11_1955,fastCase11_1956,fastCase11_1957,fastCase11_1958,fastCase11_1959,fastCase11_1960,fastCase11_1961,fastCase11_1962,fastCase11_1963,fastCase11_1964,fastCase11_1965,fastCase11_1966,fastCase11_1967,fastCase11_1968,fastCase11_1969,fastCase11_1970,fastCase11_1971,fastCase11_1972,fastCase11_1973,fastCase11_1974,fastCase11_1975,fastCase11_1976,fastCase11_1977,fastCase11_1978,fastCase11_1979,fastCase11_1980,fastCase11_1981,fastCase11_1982,fastCase11_1983,fastCase11_1984,fastCase11_1985,fastCase11_1986,fastCase11_1987,fastCase11_1988,fastCase11_1989,fastCase11_1990,fastCase11_1991,fastCase11_1992,fastCase11_1993,fastCase11_1994,fastCase11_1995,fastCase11_1996,fastCase11_1997,fastCase11_1998,fastCase11_1999⟩
#print axioms aggregate_F11_001
end KernelCatalog
