import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_1000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1000 : checkCertificateFast 10 1000 fastCert10_1000=true := by decide +kernel
def fastCert10_1001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1001 : checkCertificateFast 10 1001 fastCert10_1001=true := by decide +kernel
def fastCert10_1002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1002 : checkCertificateFast 10 1002 fastCert10_1002=true := by decide +kernel
def fastCert10_1003 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1003 : checkCertificateFast 10 1003 fastCert10_1003=true := by decide +kernel
def fastCert10_1004 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1004 : checkCertificateFast 10 1004 fastCert10_1004=true := by decide +kernel
def fastCert10_1005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1005 : checkCertificateFast 10 1005 fastCert10_1005=true := by decide +kernel
def fastCert10_1006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1006 : checkCertificateFast 10 1006 fastCert10_1006=true := by decide +kernel
def fastCert10_1007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1007 : checkCertificateFast 10 1007 fastCert10_1007=true := by decide +kernel
def fastCert10_1008 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1008 : checkCertificateFast 10 1008 fastCert10_1008=true := by decide +kernel
def fastCert10_1009 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1009 : checkCertificateFast 10 1009 fastCert10_1009=true := by decide +kernel
def fastCert10_1010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1010 : checkCertificateFast 10 1010 fastCert10_1010=true := by decide +kernel
def fastCert10_1011 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1011 : checkCertificateFast 10 1011 fastCert10_1011=true := by decide +kernel
def fastCert10_1012 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1012 : checkCertificateFast 10 1012 fastCert10_1012=true := by decide +kernel
def fastCert10_1013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1013 : checkCertificateFast 10 1013 fastCert10_1013=true := by decide +kernel
def fastCert10_1014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1014 : checkCertificateFast 10 1014 fastCert10_1014=true := by decide +kernel
def fastCert10_1015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1015 : checkCertificateFast 10 1015 fastCert10_1015=true := by decide +kernel
def fastCert10_1016 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1016 : checkCertificateFast 10 1016 fastCert10_1016=true := by decide +kernel
def fastCert10_1017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1017 : checkCertificateFast 10 1017 fastCert10_1017=true := by decide +kernel
def fastCert10_1018 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1018 : checkCertificateFast 10 1018 fastCert10_1018=true := by decide +kernel
def fastCert10_1019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1019 : checkCertificateFast 10 1019 fastCert10_1019=true := by decide +kernel
def fastCert10_1020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1020 : checkCertificateFast 10 1020 fastCert10_1020=true := by decide +kernel
def fastCert10_1021 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1021 : checkCertificateFast 10 1021 fastCert10_1021=true := by decide +kernel
def fastCert10_1022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1022 : checkCertificateFast 10 1022 fastCert10_1022=true := by decide +kernel
def fastCert10_1023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1023 : checkCertificateFast 10 1023 fastCert10_1023=true := by decide +kernel
def fastCert10_1024 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1024 : checkCertificateFast 10 1024 fastCert10_1024=true := by decide +kernel
def fastCert10_1025 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1025 : checkCertificateFast 10 1025 fastCert10_1025=true := by decide +kernel
def fastCert10_1026 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1026 : checkCertificateFast 10 1026 fastCert10_1026=true := by decide +kernel
def fastCert10_1027 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1027 : checkCertificateFast 10 1027 fastCert10_1027=true := by decide +kernel
def fastCert10_1028 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1028 : checkCertificateFast 10 1028 fastCert10_1028=true := by decide +kernel
def fastCert10_1029 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1029 : checkCertificateFast 10 1029 fastCert10_1029=true := by decide +kernel
def fastCert10_1030 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1030 : checkCertificateFast 10 1030 fastCert10_1030=true := by decide +kernel
def fastCert10_1031 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1031 : checkCertificateFast 10 1031 fastCert10_1031=true := by decide +kernel
def fastCert10_1032 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1032 : checkCertificateFast 10 1032 fastCert10_1032=true := by decide +kernel
def fastCert10_1033 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1033 : checkCertificateFast 10 1033 fastCert10_1033=true := by decide +kernel
def fastCert10_1034 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1034 : checkCertificateFast 10 1034 fastCert10_1034=true := by decide +kernel
def fastCert10_1035 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1035 : checkCertificateFast 10 1035 fastCert10_1035=true := by decide +kernel
def fastCert10_1036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1036 : checkCertificateFast 10 1036 fastCert10_1036=true := by decide +kernel
def fastCert10_1037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1037 : checkCertificateFast 10 1037 fastCert10_1037=true := by decide +kernel
def fastCert10_1038 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1038 : checkCertificateFast 10 1038 fastCert10_1038=true := by decide +kernel
def fastCert10_1039 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1039 : checkCertificateFast 10 1039 fastCert10_1039=true := by decide +kernel
def fastCert10_1040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1040 : checkCertificateFast 10 1040 fastCert10_1040=true := by decide +kernel
def fastCert10_1041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1041 : checkCertificateFast 10 1041 fastCert10_1041=true := by decide +kernel
def fastCert10_1042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1042 : checkCertificateFast 10 1042 fastCert10_1042=true := by decide +kernel
def fastCert10_1043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1043 : checkCertificateFast 10 1043 fastCert10_1043=true := by decide +kernel
def fastCert10_1044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1044 : checkCertificateFast 10 1044 fastCert10_1044=true := by decide +kernel
def fastCert10_1045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1045 : checkCertificateFast 10 1045 fastCert10_1045=true := by decide +kernel
def fastCert10_1046 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1046 : checkCertificateFast 10 1046 fastCert10_1046=true := by decide +kernel
def fastCert10_1047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1047 : checkCertificateFast 10 1047 fastCert10_1047=true := by decide +kernel
def fastCert10_1048 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1048 : checkCertificateFast 10 1048 fastCert10_1048=true := by decide +kernel
def fastCert10_1049 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1049 : checkCertificateFast 10 1049 fastCert10_1049=true := by decide +kernel
def fastCert10_1050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1050 : checkCertificateFast 10 1050 fastCert10_1050=true := by decide +kernel
def fastCert10_1051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1051 : checkCertificateFast 10 1051 fastCert10_1051=true := by decide +kernel
def fastCert10_1052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1052 : checkCertificateFast 10 1052 fastCert10_1052=true := by decide +kernel
def fastCert10_1053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1053 : checkCertificateFast 10 1053 fastCert10_1053=true := by decide +kernel
def fastCert10_1054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1054 : checkCertificateFast 10 1054 fastCert10_1054=true := by decide +kernel
def fastCert10_1055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1055 : checkCertificateFast 10 1055 fastCert10_1055=true := by decide +kernel
def fastCert10_1056 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1056 : checkCertificateFast 10 1056 fastCert10_1056=true := by decide +kernel
def fastCert10_1057 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1057 : checkCertificateFast 10 1057 fastCert10_1057=true := by decide +kernel
def fastCert10_1058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1058 : checkCertificateFast 10 1058 fastCert10_1058=true := by decide +kernel
def fastCert10_1059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_1059 : checkCertificateFast 10 1059 fastCert10_1059=true := by decide +kernel
def fastCert10_1060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1060 : checkCertificateFast 10 1060 fastCert10_1060=true := by decide +kernel
def fastCert10_1061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1061 : checkCertificateFast 10 1061 fastCert10_1061=true := by decide +kernel
def fastCert10_1062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1062 : checkCertificateFast 10 1062 fastCert10_1062=true := by decide +kernel
def fastCert10_1063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1063 : checkCertificateFast 10 1063 fastCert10_1063=true := by decide +kernel
def fastCert10_1064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1064 : checkCertificateFast 10 1064 fastCert10_1064=true := by decide +kernel
def fastCert10_1065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (3) else 0⟩
theorem fastCase10_1065 : checkCertificateFast 10 1065 fastCert10_1065=true := by decide +kernel
def fastCert10_1066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1066 : checkCertificateFast 10 1066 fastCert10_1066=true := by decide +kernel
def fastCert10_1067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_1067 : checkCertificateFast 10 1067 fastCert10_1067=true := by decide +kernel
def fastCert10_1068 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1068 : checkCertificateFast 10 1068 fastCert10_1068=true := by decide +kernel
def fastCert10_1069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1069 : checkCertificateFast 10 1069 fastCert10_1069=true := by decide +kernel
def fastCert10_1070 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1070 : checkCertificateFast 10 1070 fastCert10_1070=true := by decide +kernel
def fastCert10_1071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1071 : checkCertificateFast 10 1071 fastCert10_1071=true := by decide +kernel
def fastCert10_1072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=9 then (-3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=16 then (3) else 0⟩
theorem fastCase10_1072 : checkCertificateFast 10 1072 fastCert10_1072=true := by decide +kernel
def fastCert10_1073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-3) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_1073 : checkCertificateFast 10 1073 fastCert10_1073=true := by decide +kernel
def fastCert10_1074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1074 : checkCertificateFast 10 1074 fastCert10_1074=true := by decide +kernel
def fastCert10_1075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=6 then (3) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1075 : checkCertificateFast 10 1075 fastCert10_1075=true := by decide +kernel
def fastCert10_1076 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1076 : checkCertificateFast 10 1076 fastCert10_1076=true := by decide +kernel
def fastCert10_1077 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1077 : checkCertificateFast 10 1077 fastCert10_1077=true := by decide +kernel
def fastCert10_1078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1078 : checkCertificateFast 10 1078 fastCert10_1078=true := by decide +kernel
def fastCert10_1079 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1079 : checkCertificateFast 10 1079 fastCert10_1079=true := by decide +kernel
def fastCert10_1080 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1080 : checkCertificateFast 10 1080 fastCert10_1080=true := by decide +kernel
def fastCert10_1081 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_1081 : checkCertificateFast 10 1081 fastCert10_1081=true := by decide +kernel
def fastCert10_1082 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1082 : checkCertificateFast 10 1082 fastCert10_1082=true := by decide +kernel
def fastCert10_1083 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1083 : checkCertificateFast 10 1083 fastCert10_1083=true := by decide +kernel
def fastCert10_1084 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1084 : checkCertificateFast 10 1084 fastCert10_1084=true := by decide +kernel
def fastCert10_1085 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1085 : checkCertificateFast 10 1085 fastCert10_1085=true := by decide +kernel
def fastCert10_1086 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1086 : checkCertificateFast 10 1086 fastCert10_1086=true := by decide +kernel
def fastCert10_1087 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1087 : checkCertificateFast 10 1087 fastCert10_1087=true := by decide +kernel
def fastCert10_1088 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1088 : checkCertificateFast 10 1088 fastCert10_1088=true := by decide +kernel
def fastCert10_1089 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1089 : checkCertificateFast 10 1089 fastCert10_1089=true := by decide +kernel
def fastCert10_1090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1090 : checkCertificateFast 10 1090 fastCert10_1090=true := by decide +kernel
def fastCert10_1091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1091 : checkCertificateFast 10 1091 fastCert10_1091=true := by decide +kernel
def fastCert10_1092 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1092 : checkCertificateFast 10 1092 fastCert10_1092=true := by decide +kernel
def fastCert10_1093 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1093 : checkCertificateFast 10 1093 fastCert10_1093=true := by decide +kernel
def fastCert10_1094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1094 : checkCertificateFast 10 1094 fastCert10_1094=true := by decide +kernel
def fastCert10_1095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1095 : checkCertificateFast 10 1095 fastCert10_1095=true := by decide +kernel
def fastCert10_1096 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1096 : checkCertificateFast 10 1096 fastCert10_1096=true := by decide +kernel
def fastCert10_1097 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1097 : checkCertificateFast 10 1097 fastCert10_1097=true := by decide +kernel
def fastCert10_1098 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1098 : checkCertificateFast 10 1098 fastCert10_1098=true := by decide +kernel
def fastCert10_1099 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1099 : checkCertificateFast 10 1099 fastCert10_1099=true := by decide +kernel
def fastCert10_1100 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1100 : checkCertificateFast 10 1100 fastCert10_1100=true := by decide +kernel
def fastCert10_1101 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1101 : checkCertificateFast 10 1101 fastCert10_1101=true := by decide +kernel
def fastCert10_1102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1102 : checkCertificateFast 10 1102 fastCert10_1102=true := by decide +kernel
def fastCert10_1103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1103 : checkCertificateFast 10 1103 fastCert10_1103=true := by decide +kernel
def fastCert10_1104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1104 : checkCertificateFast 10 1104 fastCert10_1104=true := by decide +kernel
def fastCert10_1105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1105 : checkCertificateFast 10 1105 fastCert10_1105=true := by decide +kernel
def fastCert10_1106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1106 : checkCertificateFast 10 1106 fastCert10_1106=true := by decide +kernel
def fastCert10_1107 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1107 : checkCertificateFast 10 1107 fastCert10_1107=true := by decide +kernel
def fastCert10_1108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1108 : checkCertificateFast 10 1108 fastCert10_1108=true := by decide +kernel
def fastCert10_1109 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1109 : checkCertificateFast 10 1109 fastCert10_1109=true := by decide +kernel
def fastCert10_1110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1110 : checkCertificateFast 10 1110 fastCert10_1110=true := by decide +kernel
def fastCert10_1111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1111 : checkCertificateFast 10 1111 fastCert10_1111=true := by decide +kernel
def fastCert10_1112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1112 : checkCertificateFast 10 1112 fastCert10_1112=true := by decide +kernel
def fastCert10_1113 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1113 : checkCertificateFast 10 1113 fastCert10_1113=true := by decide +kernel
def fastCert10_1114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1114 : checkCertificateFast 10 1114 fastCert10_1114=true := by decide +kernel
def fastCert10_1115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1115 : checkCertificateFast 10 1115 fastCert10_1115=true := by decide +kernel
def fastCert10_1116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1116 : checkCertificateFast 10 1116 fastCert10_1116=true := by decide +kernel
def fastCert10_1117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1117 : checkCertificateFast 10 1117 fastCert10_1117=true := by decide +kernel
def fastCert10_1118 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1118 : checkCertificateFast 10 1118 fastCert10_1118=true := by decide +kernel
def fastCert10_1119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1119 : checkCertificateFast 10 1119 fastCert10_1119=true := by decide +kernel
def fastCert10_1120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1120 : checkCertificateFast 10 1120 fastCert10_1120=true := by decide +kernel
def fastCert10_1121 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1121 : checkCertificateFast 10 1121 fastCert10_1121=true := by decide +kernel
def fastCert10_1122 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1122 : checkCertificateFast 10 1122 fastCert10_1122=true := by decide +kernel
def fastCert10_1123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1123 : checkCertificateFast 10 1123 fastCert10_1123=true := by decide +kernel
def fastCert10_1124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1124 : checkCertificateFast 10 1124 fastCert10_1124=true := by decide +kernel
def fastCert10_1125 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1125 : checkCertificateFast 10 1125 fastCert10_1125=true := by decide +kernel
def fastCert10_1126 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1126 : checkCertificateFast 10 1126 fastCert10_1126=true := by decide +kernel
def fastCert10_1127 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1127 : checkCertificateFast 10 1127 fastCert10_1127=true := by decide +kernel
def fastCert10_1128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1128 : checkCertificateFast 10 1128 fastCert10_1128=true := by decide +kernel
def fastCert10_1129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1129 : checkCertificateFast 10 1129 fastCert10_1129=true := by decide +kernel
def fastCert10_1130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1130 : checkCertificateFast 10 1130 fastCert10_1130=true := by decide +kernel
def fastCert10_1131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1131 : checkCertificateFast 10 1131 fastCert10_1131=true := by decide +kernel
def fastCert10_1132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1132 : checkCertificateFast 10 1132 fastCert10_1132=true := by decide +kernel
def fastCert10_1133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1133 : checkCertificateFast 10 1133 fastCert10_1133=true := by decide +kernel
def fastCert10_1134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1134 : checkCertificateFast 10 1134 fastCert10_1134=true := by decide +kernel
def fastCert10_1135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1135 : checkCertificateFast 10 1135 fastCert10_1135=true := by decide +kernel
def fastCert10_1136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1136 : checkCertificateFast 10 1136 fastCert10_1136=true := by decide +kernel
def fastCert10_1137 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1137 : checkCertificateFast 10 1137 fastCert10_1137=true := by decide +kernel
def fastCert10_1138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1138 : checkCertificateFast 10 1138 fastCert10_1138=true := by decide +kernel
def fastCert10_1139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1139 : checkCertificateFast 10 1139 fastCert10_1139=true := by decide +kernel
def fastCert10_1140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1140 : checkCertificateFast 10 1140 fastCert10_1140=true := by decide +kernel
def fastCert10_1141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1141 : checkCertificateFast 10 1141 fastCert10_1141=true := by decide +kernel
def fastCert10_1142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1142 : checkCertificateFast 10 1142 fastCert10_1142=true := by decide +kernel
def fastCert10_1143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1143 : checkCertificateFast 10 1143 fastCert10_1143=true := by decide +kernel
def fastCert10_1144 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1144 : checkCertificateFast 10 1144 fastCert10_1144=true := by decide +kernel
def fastCert10_1145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1145 : checkCertificateFast 10 1145 fastCert10_1145=true := by decide +kernel
def fastCert10_1146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1146 : checkCertificateFast 10 1146 fastCert10_1146=true := by decide +kernel
def fastCert10_1147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1147 : checkCertificateFast 10 1147 fastCert10_1147=true := by decide +kernel
def fastCert10_1148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1148 : checkCertificateFast 10 1148 fastCert10_1148=true := by decide +kernel
def fastCert10_1149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1149 : checkCertificateFast 10 1149 fastCert10_1149=true := by decide +kernel
def fastCert10_1150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1150 : checkCertificateFast 10 1150 fastCert10_1150=true := by decide +kernel
def fastCert10_1151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1151 : checkCertificateFast 10 1151 fastCert10_1151=true := by decide +kernel
def fastCert10_1152 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1152 : checkCertificateFast 10 1152 fastCert10_1152=true := by decide +kernel
def fastCert10_1153 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1153 : checkCertificateFast 10 1153 fastCert10_1153=true := by decide +kernel
def fastCert10_1154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1154 : checkCertificateFast 10 1154 fastCert10_1154=true := by decide +kernel
def fastCert10_1155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1155 : checkCertificateFast 10 1155 fastCert10_1155=true := by decide +kernel
def fastCert10_1156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1156 : checkCertificateFast 10 1156 fastCert10_1156=true := by decide +kernel
def fastCert10_1157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1157 : checkCertificateFast 10 1157 fastCert10_1157=true := by decide +kernel
def fastCert10_1158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1158 : checkCertificateFast 10 1158 fastCert10_1158=true := by decide +kernel
def fastCert10_1159 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1159 : checkCertificateFast 10 1159 fastCert10_1159=true := by decide +kernel
def fastCert10_1160 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1160 : checkCertificateFast 10 1160 fastCert10_1160=true := by decide +kernel
def fastCert10_1161 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1161 : checkCertificateFast 10 1161 fastCert10_1161=true := by decide +kernel
def fastCert10_1162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1162 : checkCertificateFast 10 1162 fastCert10_1162=true := by decide +kernel
def fastCert10_1163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1163 : checkCertificateFast 10 1163 fastCert10_1163=true := by decide +kernel
def fastCert10_1164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1164 : checkCertificateFast 10 1164 fastCert10_1164=true := by decide +kernel
def fastCert10_1165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1165 : checkCertificateFast 10 1165 fastCert10_1165=true := by decide +kernel
def fastCert10_1166 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1166 : checkCertificateFast 10 1166 fastCert10_1166=true := by decide +kernel
def fastCert10_1167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1167 : checkCertificateFast 10 1167 fastCert10_1167=true := by decide +kernel
def fastCert10_1168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1168 : checkCertificateFast 10 1168 fastCert10_1168=true := by decide +kernel
def fastCert10_1169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1169 : checkCertificateFast 10 1169 fastCert10_1169=true := by decide +kernel
def fastCert10_1170 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1170 : checkCertificateFast 10 1170 fastCert10_1170=true := by decide +kernel
def fastCert10_1171 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1171 : checkCertificateFast 10 1171 fastCert10_1171=true := by decide +kernel
def fastCert10_1172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1172 : checkCertificateFast 10 1172 fastCert10_1172=true := by decide +kernel
def fastCert10_1173 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_1173 : checkCertificateFast 10 1173 fastCert10_1173=true := by decide +kernel
def fastCert10_1174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1174 : checkCertificateFast 10 1174 fastCert10_1174=true := by decide +kernel
def fastCert10_1175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1175 : checkCertificateFast 10 1175 fastCert10_1175=true := by decide +kernel
def fastCert10_1176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1176 : checkCertificateFast 10 1176 fastCert10_1176=true := by decide +kernel
def fastCert10_1177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1177 : checkCertificateFast 10 1177 fastCert10_1177=true := by decide +kernel
def fastCert10_1178 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1178 : checkCertificateFast 10 1178 fastCert10_1178=true := by decide +kernel
def fastCert10_1179 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1179 : checkCertificateFast 10 1179 fastCert10_1179=true := by decide +kernel
def fastCert10_1180 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1180 : checkCertificateFast 10 1180 fastCert10_1180=true := by decide +kernel
def fastCert10_1181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1181 : checkCertificateFast 10 1181 fastCert10_1181=true := by decide +kernel
def fastCert10_1182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1182 : checkCertificateFast 10 1182 fastCert10_1182=true := by decide +kernel
def fastCert10_1183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1183 : checkCertificateFast 10 1183 fastCert10_1183=true := by decide +kernel
def fastCert10_1184 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1184 : checkCertificateFast 10 1184 fastCert10_1184=true := by decide +kernel
def fastCert10_1185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1185 : checkCertificateFast 10 1185 fastCert10_1185=true := by decide +kernel
def fastCert10_1186 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1186 : checkCertificateFast 10 1186 fastCert10_1186=true := by decide +kernel
def fastCert10_1187 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1187 : checkCertificateFast 10 1187 fastCert10_1187=true := by decide +kernel
def fastCert10_1188 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1188 : checkCertificateFast 10 1188 fastCert10_1188=true := by decide +kernel
def fastCert10_1189 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1189 : checkCertificateFast 10 1189 fastCert10_1189=true := by decide +kernel
def fastCert10_1190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1190 : checkCertificateFast 10 1190 fastCert10_1190=true := by decide +kernel
def fastCert10_1191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1191 : checkCertificateFast 10 1191 fastCert10_1191=true := by decide +kernel
def fastCert10_1192 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1192 : checkCertificateFast 10 1192 fastCert10_1192=true := by decide +kernel
def fastCert10_1193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1193 : checkCertificateFast 10 1193 fastCert10_1193=true := by decide +kernel
def fastCert10_1194 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1194 : checkCertificateFast 10 1194 fastCert10_1194=true := by decide +kernel
def fastCert10_1195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1195 : checkCertificateFast 10 1195 fastCert10_1195=true := by decide +kernel
def fastCert10_1196 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1196 : checkCertificateFast 10 1196 fastCert10_1196=true := by decide +kernel
def fastCert10_1197 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1197 : checkCertificateFast 10 1197 fastCert10_1197=true := by decide +kernel
def fastCert10_1198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1198 : checkCertificateFast 10 1198 fastCert10_1198=true := by decide +kernel
def fastCert10_1199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1199 : checkCertificateFast 10 1199 fastCert10_1199=true := by decide +kernel
def fastCert10_1200 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1200 : checkCertificateFast 10 1200 fastCert10_1200=true := by decide +kernel
def fastCert10_1201 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1201 : checkCertificateFast 10 1201 fastCert10_1201=true := by decide +kernel
def fastCert10_1202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1202 : checkCertificateFast 10 1202 fastCert10_1202=true := by decide +kernel
def fastCert10_1203 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1203 : checkCertificateFast 10 1203 fastCert10_1203=true := by decide +kernel
def fastCert10_1204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1204 : checkCertificateFast 10 1204 fastCert10_1204=true := by decide +kernel
def fastCert10_1205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1205 : checkCertificateFast 10 1205 fastCert10_1205=true := by decide +kernel
def fastCert10_1206 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1206 : checkCertificateFast 10 1206 fastCert10_1206=true := by decide +kernel
def fastCert10_1207 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1207 : checkCertificateFast 10 1207 fastCert10_1207=true := by decide +kernel
def fastCert10_1208 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1208 : checkCertificateFast 10 1208 fastCert10_1208=true := by decide +kernel
def fastCert10_1209 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1209 : checkCertificateFast 10 1209 fastCert10_1209=true := by decide +kernel
def fastCert10_1210 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1210 : checkCertificateFast 10 1210 fastCert10_1210=true := by decide +kernel
def fastCert10_1211 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1211 : checkCertificateFast 10 1211 fastCert10_1211=true := by decide +kernel
def fastCert10_1212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1212 : checkCertificateFast 10 1212 fastCert10_1212=true := by decide +kernel
def fastCert10_1213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1213 : checkCertificateFast 10 1213 fastCert10_1213=true := by decide +kernel
def fastCert10_1214 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1214 : checkCertificateFast 10 1214 fastCert10_1214=true := by decide +kernel
def fastCert10_1215 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1215 : checkCertificateFast 10 1215 fastCert10_1215=true := by decide +kernel
def fastCert10_1216 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1216 : checkCertificateFast 10 1216 fastCert10_1216=true := by decide +kernel
def fastCert10_1217 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1217 : checkCertificateFast 10 1217 fastCert10_1217=true := by decide +kernel
def fastCert10_1218 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1218 : checkCertificateFast 10 1218 fastCert10_1218=true := by decide +kernel
def fastCert10_1219 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1219 : checkCertificateFast 10 1219 fastCert10_1219=true := by decide +kernel
def fastCert10_1220 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1220 : checkCertificateFast 10 1220 fastCert10_1220=true := by decide +kernel
def fastCert10_1221 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1221 : checkCertificateFast 10 1221 fastCert10_1221=true := by decide +kernel
def fastCert10_1222 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1222 : checkCertificateFast 10 1222 fastCert10_1222=true := by decide +kernel
def fastCert10_1223 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1223 : checkCertificateFast 10 1223 fastCert10_1223=true := by decide +kernel
def fastCert10_1224 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1224 : checkCertificateFast 10 1224 fastCert10_1224=true := by decide +kernel
def fastCert10_1225 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1225 : checkCertificateFast 10 1225 fastCert10_1225=true := by decide +kernel
def fastCert10_1226 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1226 : checkCertificateFast 10 1226 fastCert10_1226=true := by decide +kernel
def fastCert10_1227 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1227 : checkCertificateFast 10 1227 fastCert10_1227=true := by decide +kernel
def fastCert10_1228 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1228 : checkCertificateFast 10 1228 fastCert10_1228=true := by decide +kernel
def fastCert10_1229 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1229 : checkCertificateFast 10 1229 fastCert10_1229=true := by decide +kernel
def fastCert10_1230 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1230 : checkCertificateFast 10 1230 fastCert10_1230=true := by decide +kernel
def fastCert10_1231 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1231 : checkCertificateFast 10 1231 fastCert10_1231=true := by decide +kernel
def fastCert10_1232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1232 : checkCertificateFast 10 1232 fastCert10_1232=true := by decide +kernel
def fastCert10_1233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1233 : checkCertificateFast 10 1233 fastCert10_1233=true := by decide +kernel
def fastCert10_1234 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1234 : checkCertificateFast 10 1234 fastCert10_1234=true := by decide +kernel
def fastCert10_1235 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1235 : checkCertificateFast 10 1235 fastCert10_1235=true := by decide +kernel
def fastCert10_1236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1236 : checkCertificateFast 10 1236 fastCert10_1236=true := by decide +kernel
def fastCert10_1237 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1237 : checkCertificateFast 10 1237 fastCert10_1237=true := by decide +kernel
def fastCert10_1238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1238 : checkCertificateFast 10 1238 fastCert10_1238=true := by decide +kernel
def fastCert10_1239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1239 : checkCertificateFast 10 1239 fastCert10_1239=true := by decide +kernel
def fastCert10_1240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1240 : checkCertificateFast 10 1240 fastCert10_1240=true := by decide +kernel
def fastCert10_1241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1241 : checkCertificateFast 10 1241 fastCert10_1241=true := by decide +kernel
def fastCert10_1242 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1242 : checkCertificateFast 10 1242 fastCert10_1242=true := by decide +kernel
def fastCert10_1243 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1243 : checkCertificateFast 10 1243 fastCert10_1243=true := by decide +kernel
def fastCert10_1244 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1244 : checkCertificateFast 10 1244 fastCert10_1244=true := by decide +kernel
def fastCert10_1245 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1245 : checkCertificateFast 10 1245 fastCert10_1245=true := by decide +kernel
def fastCert10_1246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1246 : checkCertificateFast 10 1246 fastCert10_1246=true := by decide +kernel
def fastCert10_1247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1247 : checkCertificateFast 10 1247 fastCert10_1247=true := by decide +kernel
def fastCert10_1248 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1248 : checkCertificateFast 10 1248 fastCert10_1248=true := by decide +kernel
def fastCert10_1249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1249 : checkCertificateFast 10 1249 fastCert10_1249=true := by decide +kernel
def fastCert10_1250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1250 : checkCertificateFast 10 1250 fastCert10_1250=true := by decide +kernel
def fastCert10_1251 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1251 : checkCertificateFast 10 1251 fastCert10_1251=true := by decide +kernel
def fastCert10_1252 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1252 : checkCertificateFast 10 1252 fastCert10_1252=true := by decide +kernel
def fastCert10_1253 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1253 : checkCertificateFast 10 1253 fastCert10_1253=true := by decide +kernel
def fastCert10_1254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1254 : checkCertificateFast 10 1254 fastCert10_1254=true := by decide +kernel
def fastCert10_1255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1255 : checkCertificateFast 10 1255 fastCert10_1255=true := by decide +kernel
def fastCert10_1256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1256 : checkCertificateFast 10 1256 fastCert10_1256=true := by decide +kernel
def fastCert10_1257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1257 : checkCertificateFast 10 1257 fastCert10_1257=true := by decide +kernel
def fastCert10_1258 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1258 : checkCertificateFast 10 1258 fastCert10_1258=true := by decide +kernel
def fastCert10_1259 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1259 : checkCertificateFast 10 1259 fastCert10_1259=true := by decide +kernel
def fastCert10_1260 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1260 : checkCertificateFast 10 1260 fastCert10_1260=true := by decide +kernel
def fastCert10_1261 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1261 : checkCertificateFast 10 1261 fastCert10_1261=true := by decide +kernel
def fastCert10_1262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1262 : checkCertificateFast 10 1262 fastCert10_1262=true := by decide +kernel
def fastCert10_1263 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1263 : checkCertificateFast 10 1263 fastCert10_1263=true := by decide +kernel
def fastCert10_1264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1264 : checkCertificateFast 10 1264 fastCert10_1264=true := by decide +kernel
def fastCert10_1265 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1265 : checkCertificateFast 10 1265 fastCert10_1265=true := by decide +kernel
def fastCert10_1266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1266 : checkCertificateFast 10 1266 fastCert10_1266=true := by decide +kernel
def fastCert10_1267 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1267 : checkCertificateFast 10 1267 fastCert10_1267=true := by decide +kernel
def fastCert10_1268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1268 : checkCertificateFast 10 1268 fastCert10_1268=true := by decide +kernel
def fastCert10_1269 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1269 : checkCertificateFast 10 1269 fastCert10_1269=true := by decide +kernel
def fastCert10_1270 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1270 : checkCertificateFast 10 1270 fastCert10_1270=true := by decide +kernel
def fastCert10_1271 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1271 : checkCertificateFast 10 1271 fastCert10_1271=true := by decide +kernel
def fastCert10_1272 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1272 : checkCertificateFast 10 1272 fastCert10_1272=true := by decide +kernel
def fastCert10_1273 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1273 : checkCertificateFast 10 1273 fastCert10_1273=true := by decide +kernel
def fastCert10_1274 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1274 : checkCertificateFast 10 1274 fastCert10_1274=true := by decide +kernel
def fastCert10_1275 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1275 : checkCertificateFast 10 1275 fastCert10_1275=true := by decide +kernel
def fastCert10_1276 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1276 : checkCertificateFast 10 1276 fastCert10_1276=true := by decide +kernel
def fastCert10_1277 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1277 : checkCertificateFast 10 1277 fastCert10_1277=true := by decide +kernel
def fastCert10_1278 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1278 : checkCertificateFast 10 1278 fastCert10_1278=true := by decide +kernel
def fastCert10_1279 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1279 : checkCertificateFast 10 1279 fastCert10_1279=true := by decide +kernel
def fastCert10_1280 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1280 : checkCertificateFast 10 1280 fastCert10_1280=true := by decide +kernel
def fastCert10_1281 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1281 : checkCertificateFast 10 1281 fastCert10_1281=true := by decide +kernel
def fastCert10_1282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1282 : checkCertificateFast 10 1282 fastCert10_1282=true := by decide +kernel
def fastCert10_1283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1283 : checkCertificateFast 10 1283 fastCert10_1283=true := by decide +kernel
def fastCert10_1284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1284 : checkCertificateFast 10 1284 fastCert10_1284=true := by decide +kernel
def fastCert10_1285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1285 : checkCertificateFast 10 1285 fastCert10_1285=true := by decide +kernel
def fastCert10_1286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1286 : checkCertificateFast 10 1286 fastCert10_1286=true := by decide +kernel
def fastCert10_1287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1287 : checkCertificateFast 10 1287 fastCert10_1287=true := by decide +kernel
def fastCert10_1288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1288 : checkCertificateFast 10 1288 fastCert10_1288=true := by decide +kernel
def fastCert10_1289 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1289 : checkCertificateFast 10 1289 fastCert10_1289=true := by decide +kernel
def fastCert10_1290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1290 : checkCertificateFast 10 1290 fastCert10_1290=true := by decide +kernel
def fastCert10_1291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1291 : checkCertificateFast 10 1291 fastCert10_1291=true := by decide +kernel
def fastCert10_1292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1292 : checkCertificateFast 10 1292 fastCert10_1292=true := by decide +kernel
def fastCert10_1293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1293 : checkCertificateFast 10 1293 fastCert10_1293=true := by decide +kernel
def fastCert10_1294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1294 : checkCertificateFast 10 1294 fastCert10_1294=true := by decide +kernel
def fastCert10_1295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1295 : checkCertificateFast 10 1295 fastCert10_1295=true := by decide +kernel
def fastCert10_1296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1296 : checkCertificateFast 10 1296 fastCert10_1296=true := by decide +kernel
def fastCert10_1297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1297 : checkCertificateFast 10 1297 fastCert10_1297=true := by decide +kernel
def fastCert10_1298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1298 : checkCertificateFast 10 1298 fastCert10_1298=true := by decide +kernel
def fastCert10_1299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1299 : checkCertificateFast 10 1299 fastCert10_1299=true := by decide +kernel
def fastCert10_1300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1300 : checkCertificateFast 10 1300 fastCert10_1300=true := by decide +kernel
def fastCert10_1301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1301 : checkCertificateFast 10 1301 fastCert10_1301=true := by decide +kernel
def fastCert10_1302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1302 : checkCertificateFast 10 1302 fastCert10_1302=true := by decide +kernel
def fastCert10_1303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1303 : checkCertificateFast 10 1303 fastCert10_1303=true := by decide +kernel
def fastCert10_1304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1304 : checkCertificateFast 10 1304 fastCert10_1304=true := by decide +kernel
def fastCert10_1305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1305 : checkCertificateFast 10 1305 fastCert10_1305=true := by decide +kernel
def fastCert10_1306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1306 : checkCertificateFast 10 1306 fastCert10_1306=true := by decide +kernel
def fastCert10_1307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1307 : checkCertificateFast 10 1307 fastCert10_1307=true := by decide +kernel
def fastCert10_1308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1308 : checkCertificateFast 10 1308 fastCert10_1308=true := by decide +kernel
def fastCert10_1309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1309 : checkCertificateFast 10 1309 fastCert10_1309=true := by decide +kernel
def fastCert10_1310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1310 : checkCertificateFast 10 1310 fastCert10_1310=true := by decide +kernel
def fastCert10_1311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1311 : checkCertificateFast 10 1311 fastCert10_1311=true := by decide +kernel
def fastCert10_1312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1312 : checkCertificateFast 10 1312 fastCert10_1312=true := by decide +kernel
def fastCert10_1313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1313 : checkCertificateFast 10 1313 fastCert10_1313=true := by decide +kernel
def fastCert10_1314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1314 : checkCertificateFast 10 1314 fastCert10_1314=true := by decide +kernel
def fastCert10_1315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1315 : checkCertificateFast 10 1315 fastCert10_1315=true := by decide +kernel
def fastCert10_1316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1316 : checkCertificateFast 10 1316 fastCert10_1316=true := by decide +kernel
def fastCert10_1317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1317 : checkCertificateFast 10 1317 fastCert10_1317=true := by decide +kernel
def fastCert10_1318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1318 : checkCertificateFast 10 1318 fastCert10_1318=true := by decide +kernel
def fastCert10_1319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1319 : checkCertificateFast 10 1319 fastCert10_1319=true := by decide +kernel
def fastCert10_1320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1320 : checkCertificateFast 10 1320 fastCert10_1320=true := by decide +kernel
def fastCert10_1321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1321 : checkCertificateFast 10 1321 fastCert10_1321=true := by decide +kernel
def fastCert10_1322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1322 : checkCertificateFast 10 1322 fastCert10_1322=true := by decide +kernel
def fastCert10_1323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1323 : checkCertificateFast 10 1323 fastCert10_1323=true := by decide +kernel
def fastCert10_1324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1324 : checkCertificateFast 10 1324 fastCert10_1324=true := by decide +kernel
def fastCert10_1325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1325 : checkCertificateFast 10 1325 fastCert10_1325=true := by decide +kernel
def fastCert10_1326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1326 : checkCertificateFast 10 1326 fastCert10_1326=true := by decide +kernel
def fastCert10_1327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1327 : checkCertificateFast 10 1327 fastCert10_1327=true := by decide +kernel
def fastCert10_1328 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1328 : checkCertificateFast 10 1328 fastCert10_1328=true := by decide +kernel
def fastCert10_1329 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1329 : checkCertificateFast 10 1329 fastCert10_1329=true := by decide +kernel
def fastCert10_1330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1330 : checkCertificateFast 10 1330 fastCert10_1330=true := by decide +kernel
def fastCert10_1331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1331 : checkCertificateFast 10 1331 fastCert10_1331=true := by decide +kernel
def fastCert10_1332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1332 : checkCertificateFast 10 1332 fastCert10_1332=true := by decide +kernel
def fastCert10_1333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1333 : checkCertificateFast 10 1333 fastCert10_1333=true := by decide +kernel
def fastCert10_1334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1334 : checkCertificateFast 10 1334 fastCert10_1334=true := by decide +kernel
def fastCert10_1335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1335 : checkCertificateFast 10 1335 fastCert10_1335=true := by decide +kernel
def fastCert10_1336 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1336 : checkCertificateFast 10 1336 fastCert10_1336=true := by decide +kernel
def fastCert10_1337 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1337 : checkCertificateFast 10 1337 fastCert10_1337=true := by decide +kernel
def fastCert10_1338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1338 : checkCertificateFast 10 1338 fastCert10_1338=true := by decide +kernel
def fastCert10_1339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1339 : checkCertificateFast 10 1339 fastCert10_1339=true := by decide +kernel
def fastCert10_1340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1340 : checkCertificateFast 10 1340 fastCert10_1340=true := by decide +kernel
def fastCert10_1341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1341 : checkCertificateFast 10 1341 fastCert10_1341=true := by decide +kernel
def fastCert10_1342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1342 : checkCertificateFast 10 1342 fastCert10_1342=true := by decide +kernel
def fastCert10_1343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1343 : checkCertificateFast 10 1343 fastCert10_1343=true := by decide +kernel
def fastCert10_1344 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1344 : checkCertificateFast 10 1344 fastCert10_1344=true := by decide +kernel
def fastCert10_1345 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1345 : checkCertificateFast 10 1345 fastCert10_1345=true := by decide +kernel
def fastCert10_1346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1346 : checkCertificateFast 10 1346 fastCert10_1346=true := by decide +kernel
def fastCert10_1347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1347 : checkCertificateFast 10 1347 fastCert10_1347=true := by decide +kernel
def fastCert10_1348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1348 : checkCertificateFast 10 1348 fastCert10_1348=true := by decide +kernel
def fastCert10_1349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1349 : checkCertificateFast 10 1349 fastCert10_1349=true := by decide +kernel
def fastCert10_1350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1350 : checkCertificateFast 10 1350 fastCert10_1350=true := by decide +kernel
def fastCert10_1351 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1351 : checkCertificateFast 10 1351 fastCert10_1351=true := by decide +kernel
def fastCert10_1352 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1352 : checkCertificateFast 10 1352 fastCert10_1352=true := by decide +kernel
def fastCert10_1353 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1353 : checkCertificateFast 10 1353 fastCert10_1353=true := by decide +kernel
def fastCert10_1354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1354 : checkCertificateFast 10 1354 fastCert10_1354=true := by decide +kernel
def fastCert10_1355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1355 : checkCertificateFast 10 1355 fastCert10_1355=true := by decide +kernel
def fastCert10_1356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1356 : checkCertificateFast 10 1356 fastCert10_1356=true := by decide +kernel
def fastCert10_1357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1357 : checkCertificateFast 10 1357 fastCert10_1357=true := by decide +kernel
def fastCert10_1358 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1358 : checkCertificateFast 10 1358 fastCert10_1358=true := by decide +kernel
def fastCert10_1359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1359 : checkCertificateFast 10 1359 fastCert10_1359=true := by decide +kernel
def fastCert10_1360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1360 : checkCertificateFast 10 1360 fastCert10_1360=true := by decide +kernel
def fastCert10_1361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1361 : checkCertificateFast 10 1361 fastCert10_1361=true := by decide +kernel
def fastCert10_1362 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1362 : checkCertificateFast 10 1362 fastCert10_1362=true := by decide +kernel
def fastCert10_1363 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1363 : checkCertificateFast 10 1363 fastCert10_1363=true := by decide +kernel
def fastCert10_1364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1364 : checkCertificateFast 10 1364 fastCert10_1364=true := by decide +kernel
def fastCert10_1365 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1365 : checkCertificateFast 10 1365 fastCert10_1365=true := by decide +kernel
def fastCert10_1366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1366 : checkCertificateFast 10 1366 fastCert10_1366=true := by decide +kernel
def fastCert10_1367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1367 : checkCertificateFast 10 1367 fastCert10_1367=true := by decide +kernel
def fastCert10_1368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1368 : checkCertificateFast 10 1368 fastCert10_1368=true := by decide +kernel
def fastCert10_1369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1369 : checkCertificateFast 10 1369 fastCert10_1369=true := by decide +kernel
def fastCert10_1370 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1370 : checkCertificateFast 10 1370 fastCert10_1370=true := by decide +kernel
def fastCert10_1371 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1371 : checkCertificateFast 10 1371 fastCert10_1371=true := by decide +kernel
def fastCert10_1372 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1372 : checkCertificateFast 10 1372 fastCert10_1372=true := by decide +kernel
def fastCert10_1373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1373 : checkCertificateFast 10 1373 fastCert10_1373=true := by decide +kernel
def fastCert10_1374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1374 : checkCertificateFast 10 1374 fastCert10_1374=true := by decide +kernel
def fastCert10_1375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1375 : checkCertificateFast 10 1375 fastCert10_1375=true := by decide +kernel
def fastCert10_1376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1376 : checkCertificateFast 10 1376 fastCert10_1376=true := by decide +kernel
def fastCert10_1377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1377 : checkCertificateFast 10 1377 fastCert10_1377=true := by decide +kernel
def fastCert10_1378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1378 : checkCertificateFast 10 1378 fastCert10_1378=true := by decide +kernel
def fastCert10_1379 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1379 : checkCertificateFast 10 1379 fastCert10_1379=true := by decide +kernel
def fastCert10_1380 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1380 : checkCertificateFast 10 1380 fastCert10_1380=true := by decide +kernel
def fastCert10_1381 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1381 : checkCertificateFast 10 1381 fastCert10_1381=true := by decide +kernel
def fastCert10_1382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1382 : checkCertificateFast 10 1382 fastCert10_1382=true := by decide +kernel
def fastCert10_1383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1383 : checkCertificateFast 10 1383 fastCert10_1383=true := by decide +kernel
def fastCert10_1384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1384 : checkCertificateFast 10 1384 fastCert10_1384=true := by decide +kernel
def fastCert10_1385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1385 : checkCertificateFast 10 1385 fastCert10_1385=true := by decide +kernel
def fastCert10_1386 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1386 : checkCertificateFast 10 1386 fastCert10_1386=true := by decide +kernel
def fastCert10_1387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1387 : checkCertificateFast 10 1387 fastCert10_1387=true := by decide +kernel
def fastCert10_1388 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1388 : checkCertificateFast 10 1388 fastCert10_1388=true := by decide +kernel
def fastCert10_1389 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1389 : checkCertificateFast 10 1389 fastCert10_1389=true := by decide +kernel
def fastCert10_1390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1390 : checkCertificateFast 10 1390 fastCert10_1390=true := by decide +kernel
def fastCert10_1391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1391 : checkCertificateFast 10 1391 fastCert10_1391=true := by decide +kernel
def fastCert10_1392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1392 : checkCertificateFast 10 1392 fastCert10_1392=true := by decide +kernel
def fastCert10_1393 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1393 : checkCertificateFast 10 1393 fastCert10_1393=true := by decide +kernel
def fastCert10_1394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1394 : checkCertificateFast 10 1394 fastCert10_1394=true := by decide +kernel
def fastCert10_1395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1395 : checkCertificateFast 10 1395 fastCert10_1395=true := by decide +kernel
def fastCert10_1396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1396 : checkCertificateFast 10 1396 fastCert10_1396=true := by decide +kernel
def fastCert10_1397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1397 : checkCertificateFast 10 1397 fastCert10_1397=true := by decide +kernel
def fastCert10_1398 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1398 : checkCertificateFast 10 1398 fastCert10_1398=true := by decide +kernel
def fastCert10_1399 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1399 : checkCertificateFast 10 1399 fastCert10_1399=true := by decide +kernel
def fastCert10_1400 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1400 : checkCertificateFast 10 1400 fastCert10_1400=true := by decide +kernel
def fastCert10_1401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1401 : checkCertificateFast 10 1401 fastCert10_1401=true := by decide +kernel
def fastCert10_1402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1402 : checkCertificateFast 10 1402 fastCert10_1402=true := by decide +kernel
def fastCert10_1403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1403 : checkCertificateFast 10 1403 fastCert10_1403=true := by decide +kernel
def fastCert10_1404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1404 : checkCertificateFast 10 1404 fastCert10_1404=true := by decide +kernel
def fastCert10_1405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1405 : checkCertificateFast 10 1405 fastCert10_1405=true := by decide +kernel
def fastCert10_1406 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1406 : checkCertificateFast 10 1406 fastCert10_1406=true := by decide +kernel
def fastCert10_1407 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1407 : checkCertificateFast 10 1407 fastCert10_1407=true := by decide +kernel
def fastCert10_1408 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1408 : checkCertificateFast 10 1408 fastCert10_1408=true := by decide +kernel
def fastCert10_1409 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1409 : checkCertificateFast 10 1409 fastCert10_1409=true := by decide +kernel
def fastCert10_1410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1410 : checkCertificateFast 10 1410 fastCert10_1410=true := by decide +kernel
def fastCert10_1411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1411 : checkCertificateFast 10 1411 fastCert10_1411=true := by decide +kernel
def fastCert10_1412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1412 : checkCertificateFast 10 1412 fastCert10_1412=true := by decide +kernel
def fastCert10_1413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1413 : checkCertificateFast 10 1413 fastCert10_1413=true := by decide +kernel
def fastCert10_1414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1414 : checkCertificateFast 10 1414 fastCert10_1414=true := by decide +kernel
def fastCert10_1415 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1415 : checkCertificateFast 10 1415 fastCert10_1415=true := by decide +kernel
def fastCert10_1416 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1416 : checkCertificateFast 10 1416 fastCert10_1416=true := by decide +kernel
def fastCert10_1417 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_1417 : checkCertificateFast 10 1417 fastCert10_1417=true := by decide +kernel
def fastCert10_1418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1418 : checkCertificateFast 10 1418 fastCert10_1418=true := by decide +kernel
def fastCert10_1419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1419 : checkCertificateFast 10 1419 fastCert10_1419=true := by decide +kernel
def fastCert10_1420 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1420 : checkCertificateFast 10 1420 fastCert10_1420=true := by decide +kernel
def fastCert10_1421 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1421 : checkCertificateFast 10 1421 fastCert10_1421=true := by decide +kernel
def fastCert10_1422 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1422 : checkCertificateFast 10 1422 fastCert10_1422=true := by decide +kernel
def fastCert10_1423 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1423 : checkCertificateFast 10 1423 fastCert10_1423=true := by decide +kernel
def fastCert10_1424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1424 : checkCertificateFast 10 1424 fastCert10_1424=true := by decide +kernel
def fastCert10_1425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1425 : checkCertificateFast 10 1425 fastCert10_1425=true := by decide +kernel
def fastCert10_1426 : Certificate := ⟨13,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1426 : checkCertificateFast 10 1426 fastCert10_1426=true := by decide +kernel
def fastCert10_1427 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1427 : checkCertificateFast 10 1427 fastCert10_1427=true := by decide +kernel
def fastCert10_1428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1428 : checkCertificateFast 10 1428 fastCert10_1428=true := by decide +kernel
def fastCert10_1429 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1429 : checkCertificateFast 10 1429 fastCert10_1429=true := by decide +kernel
def fastCert10_1430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1430 : checkCertificateFast 10 1430 fastCert10_1430=true := by decide +kernel
def fastCert10_1431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1431 : checkCertificateFast 10 1431 fastCert10_1431=true := by decide +kernel
def fastCert10_1432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1432 : checkCertificateFast 10 1432 fastCert10_1432=true := by decide +kernel
def fastCert10_1433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1433 : checkCertificateFast 10 1433 fastCert10_1433=true := by decide +kernel
def fastCert10_1434 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1434 : checkCertificateFast 10 1434 fastCert10_1434=true := by decide +kernel
def fastCert10_1435 : Certificate := ⟨13,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1435 : checkCertificateFast 10 1435 fastCert10_1435=true := by decide +kernel
def fastCert10_1436 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1436 : checkCertificateFast 10 1436 fastCert10_1436=true := by decide +kernel
def fastCert10_1437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1437 : checkCertificateFast 10 1437 fastCert10_1437=true := by decide +kernel
def fastCert10_1438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1438 : checkCertificateFast 10 1438 fastCert10_1438=true := by decide +kernel
def fastCert10_1439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1439 : checkCertificateFast 10 1439 fastCert10_1439=true := by decide +kernel
def fastCert10_1440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1440 : checkCertificateFast 10 1440 fastCert10_1440=true := by decide +kernel
def fastCert10_1441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1441 : checkCertificateFast 10 1441 fastCert10_1441=true := by decide +kernel
def fastCert10_1442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1442 : checkCertificateFast 10 1442 fastCert10_1442=true := by decide +kernel
def fastCert10_1443 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1443 : checkCertificateFast 10 1443 fastCert10_1443=true := by decide +kernel
def fastCert10_1444 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1444 : checkCertificateFast 10 1444 fastCert10_1444=true := by decide +kernel
def fastCert10_1445 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1445 : checkCertificateFast 10 1445 fastCert10_1445=true := by decide +kernel
def fastCert10_1446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1446 : checkCertificateFast 10 1446 fastCert10_1446=true := by decide +kernel
def fastCert10_1447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1447 : checkCertificateFast 10 1447 fastCert10_1447=true := by decide +kernel
def fastCert10_1448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1448 : checkCertificateFast 10 1448 fastCert10_1448=true := by decide +kernel
def fastCert10_1449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1449 : checkCertificateFast 10 1449 fastCert10_1449=true := by decide +kernel
def fastCert10_1450 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1450 : checkCertificateFast 10 1450 fastCert10_1450=true := by decide +kernel
def fastCert10_1451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1451 : checkCertificateFast 10 1451 fastCert10_1451=true := by decide +kernel
def fastCert10_1452 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1452 : checkCertificateFast 10 1452 fastCert10_1452=true := by decide +kernel
def fastCert10_1453 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1453 : checkCertificateFast 10 1453 fastCert10_1453=true := by decide +kernel
def fastCert10_1454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1454 : checkCertificateFast 10 1454 fastCert10_1454=true := by decide +kernel
def fastCert10_1455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1455 : checkCertificateFast 10 1455 fastCert10_1455=true := by decide +kernel
def fastCert10_1456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1456 : checkCertificateFast 10 1456 fastCert10_1456=true := by decide +kernel
def fastCert10_1457 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1457 : checkCertificateFast 10 1457 fastCert10_1457=true := by decide +kernel
def fastCert10_1458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1458 : checkCertificateFast 10 1458 fastCert10_1458=true := by decide +kernel
def fastCert10_1459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1459 : checkCertificateFast 10 1459 fastCert10_1459=true := by decide +kernel
def fastCert10_1460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1460 : checkCertificateFast 10 1460 fastCert10_1460=true := by decide +kernel
def fastCert10_1461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1461 : checkCertificateFast 10 1461 fastCert10_1461=true := by decide +kernel
def fastCert10_1462 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1462 : checkCertificateFast 10 1462 fastCert10_1462=true := by decide +kernel
def fastCert10_1463 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1463 : checkCertificateFast 10 1463 fastCert10_1463=true := by decide +kernel
def fastCert10_1464 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1464 : checkCertificateFast 10 1464 fastCert10_1464=true := by decide +kernel
def fastCert10_1465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1465 : checkCertificateFast 10 1465 fastCert10_1465=true := by decide +kernel
def fastCert10_1466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1466 : checkCertificateFast 10 1466 fastCert10_1466=true := by decide +kernel
def fastCert10_1467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1467 : checkCertificateFast 10 1467 fastCert10_1467=true := by decide +kernel
def fastCert10_1468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1468 : checkCertificateFast 10 1468 fastCert10_1468=true := by decide +kernel
def fastCert10_1469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1469 : checkCertificateFast 10 1469 fastCert10_1469=true := by decide +kernel
def fastCert10_1470 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1470 : checkCertificateFast 10 1470 fastCert10_1470=true := by decide +kernel
def fastCert10_1471 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_1471 : checkCertificateFast 10 1471 fastCert10_1471=true := by decide +kernel
def fastCert10_1472 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1472 : checkCertificateFast 10 1472 fastCert10_1472=true := by decide +kernel
def fastCert10_1473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1473 : checkCertificateFast 10 1473 fastCert10_1473=true := by decide +kernel
def fastCert10_1474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1474 : checkCertificateFast 10 1474 fastCert10_1474=true := by decide +kernel
def fastCert10_1475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1475 : checkCertificateFast 10 1475 fastCert10_1475=true := by decide +kernel
def fastCert10_1476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1476 : checkCertificateFast 10 1476 fastCert10_1476=true := by decide +kernel
def fastCert10_1477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1477 : checkCertificateFast 10 1477 fastCert10_1477=true := by decide +kernel
def fastCert10_1478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1478 : checkCertificateFast 10 1478 fastCert10_1478=true := by decide +kernel
def fastCert10_1479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1479 : checkCertificateFast 10 1479 fastCert10_1479=true := by decide +kernel
def fastCert10_1480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1480 : checkCertificateFast 10 1480 fastCert10_1480=true := by decide +kernel
def fastCert10_1481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1481 : checkCertificateFast 10 1481 fastCert10_1481=true := by decide +kernel
def fastCert10_1482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1482 : checkCertificateFast 10 1482 fastCert10_1482=true := by decide +kernel
def fastCert10_1483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1483 : checkCertificateFast 10 1483 fastCert10_1483=true := by decide +kernel
def fastCert10_1484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1484 : checkCertificateFast 10 1484 fastCert10_1484=true := by decide +kernel
def fastCert10_1485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1485 : checkCertificateFast 10 1485 fastCert10_1485=true := by decide +kernel
def fastCert10_1486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1486 : checkCertificateFast 10 1486 fastCert10_1486=true := by decide +kernel
def fastCert10_1487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1487 : checkCertificateFast 10 1487 fastCert10_1487=true := by decide +kernel
def fastCert10_1488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1488 : checkCertificateFast 10 1488 fastCert10_1488=true := by decide +kernel
def fastCert10_1489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1489 : checkCertificateFast 10 1489 fastCert10_1489=true := by decide +kernel
def fastCert10_1490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1490 : checkCertificateFast 10 1490 fastCert10_1490=true := by decide +kernel
def fastCert10_1491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1491 : checkCertificateFast 10 1491 fastCert10_1491=true := by decide +kernel
def fastCert10_1492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1492 : checkCertificateFast 10 1492 fastCert10_1492=true := by decide +kernel
def fastCert10_1493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1493 : checkCertificateFast 10 1493 fastCert10_1493=true := by decide +kernel
def fastCert10_1494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1494 : checkCertificateFast 10 1494 fastCert10_1494=true := by decide +kernel
def fastCert10_1495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1495 : checkCertificateFast 10 1495 fastCert10_1495=true := by decide +kernel
def fastCert10_1496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1496 : checkCertificateFast 10 1496 fastCert10_1496=true := by decide +kernel
def fastCert10_1497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1497 : checkCertificateFast 10 1497 fastCert10_1497=true := by decide +kernel
def fastCert10_1498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1498 : checkCertificateFast 10 1498 fastCert10_1498=true := by decide +kernel
def fastCert10_1499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1499 : checkCertificateFast 10 1499 fastCert10_1499=true := by decide +kernel
def fastCert10_1500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1500 : checkCertificateFast 10 1500 fastCert10_1500=true := by decide +kernel
def fastCert10_1501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1501 : checkCertificateFast 10 1501 fastCert10_1501=true := by decide +kernel
def fastCert10_1502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1502 : checkCertificateFast 10 1502 fastCert10_1502=true := by decide +kernel
def fastCert10_1503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1503 : checkCertificateFast 10 1503 fastCert10_1503=true := by decide +kernel
def fastCert10_1504 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1504 : checkCertificateFast 10 1504 fastCert10_1504=true := by decide +kernel
def fastCert10_1505 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1505 : checkCertificateFast 10 1505 fastCert10_1505=true := by decide +kernel
def fastCert10_1506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1506 : checkCertificateFast 10 1506 fastCert10_1506=true := by decide +kernel
def fastCert10_1507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1507 : checkCertificateFast 10 1507 fastCert10_1507=true := by decide +kernel
def fastCert10_1508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1508 : checkCertificateFast 10 1508 fastCert10_1508=true := by decide +kernel
def fastCert10_1509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1509 : checkCertificateFast 10 1509 fastCert10_1509=true := by decide +kernel
def fastCert10_1510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1510 : checkCertificateFast 10 1510 fastCert10_1510=true := by decide +kernel
def fastCert10_1511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1511 : checkCertificateFast 10 1511 fastCert10_1511=true := by decide +kernel
def fastCert10_1512 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1512 : checkCertificateFast 10 1512 fastCert10_1512=true := by decide +kernel
def fastCert10_1513 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1513 : checkCertificateFast 10 1513 fastCert10_1513=true := by decide +kernel
def fastCert10_1514 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1514 : checkCertificateFast 10 1514 fastCert10_1514=true := by decide +kernel
def fastCert10_1515 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1515 : checkCertificateFast 10 1515 fastCert10_1515=true := by decide +kernel
def fastCert10_1516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1516 : checkCertificateFast 10 1516 fastCert10_1516=true := by decide +kernel
def fastCert10_1517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1517 : checkCertificateFast 10 1517 fastCert10_1517=true := by decide +kernel
def fastCert10_1518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1518 : checkCertificateFast 10 1518 fastCert10_1518=true := by decide +kernel
def fastCert10_1519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1519 : checkCertificateFast 10 1519 fastCert10_1519=true := by decide +kernel
def fastCert10_1520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1520 : checkCertificateFast 10 1520 fastCert10_1520=true := by decide +kernel
def fastCert10_1521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1521 : checkCertificateFast 10 1521 fastCert10_1521=true := by decide +kernel
def fastCert10_1522 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1522 : checkCertificateFast 10 1522 fastCert10_1522=true := by decide +kernel
def fastCert10_1523 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1523 : checkCertificateFast 10 1523 fastCert10_1523=true := by decide +kernel
def fastCert10_1524 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1524 : checkCertificateFast 10 1524 fastCert10_1524=true := by decide +kernel
def fastCert10_1525 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1525 : checkCertificateFast 10 1525 fastCert10_1525=true := by decide +kernel
def fastCert10_1526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1526 : checkCertificateFast 10 1526 fastCert10_1526=true := by decide +kernel
def fastCert10_1527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1527 : checkCertificateFast 10 1527 fastCert10_1527=true := by decide +kernel
def fastCert10_1528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1528 : checkCertificateFast 10 1528 fastCert10_1528=true := by decide +kernel
def fastCert10_1529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1529 : checkCertificateFast 10 1529 fastCert10_1529=true := by decide +kernel
def fastCert10_1530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1530 : checkCertificateFast 10 1530 fastCert10_1530=true := by decide +kernel
def fastCert10_1531 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1531 : checkCertificateFast 10 1531 fastCert10_1531=true := by decide +kernel
def fastCert10_1532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1532 : checkCertificateFast 10 1532 fastCert10_1532=true := by decide +kernel
def fastCert10_1533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1533 : checkCertificateFast 10 1533 fastCert10_1533=true := by decide +kernel
def fastCert10_1534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1534 : checkCertificateFast 10 1534 fastCert10_1534=true := by decide +kernel
def fastCert10_1535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1535 : checkCertificateFast 10 1535 fastCert10_1535=true := by decide +kernel
def fastCert10_1536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1536 : checkCertificateFast 10 1536 fastCert10_1536=true := by decide +kernel
def fastCert10_1537 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1537 : checkCertificateFast 10 1537 fastCert10_1537=true := by decide +kernel
def fastCert10_1538 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1538 : checkCertificateFast 10 1538 fastCert10_1538=true := by decide +kernel
def fastCert10_1539 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1539 : checkCertificateFast 10 1539 fastCert10_1539=true := by decide +kernel
def fastCert10_1540 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1540 : checkCertificateFast 10 1540 fastCert10_1540=true := by decide +kernel
def fastCert10_1541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1541 : checkCertificateFast 10 1541 fastCert10_1541=true := by decide +kernel
def fastCert10_1542 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1542 : checkCertificateFast 10 1542 fastCert10_1542=true := by decide +kernel
def fastCert10_1543 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1543 : checkCertificateFast 10 1543 fastCert10_1543=true := by decide +kernel
def fastCert10_1544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1544 : checkCertificateFast 10 1544 fastCert10_1544=true := by decide +kernel
def fastCert10_1545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1545 : checkCertificateFast 10 1545 fastCert10_1545=true := by decide +kernel
def fastCert10_1546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1546 : checkCertificateFast 10 1546 fastCert10_1546=true := by decide +kernel
def fastCert10_1547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1547 : checkCertificateFast 10 1547 fastCert10_1547=true := by decide +kernel
def fastCert10_1548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1548 : checkCertificateFast 10 1548 fastCert10_1548=true := by decide +kernel
def fastCert10_1549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1549 : checkCertificateFast 10 1549 fastCert10_1549=true := by decide +kernel
def fastCert10_1550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1550 : checkCertificateFast 10 1550 fastCert10_1550=true := by decide +kernel
def fastCert10_1551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1551 : checkCertificateFast 10 1551 fastCert10_1551=true := by decide +kernel
def fastCert10_1552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1552 : checkCertificateFast 10 1552 fastCert10_1552=true := by decide +kernel
def fastCert10_1553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1553 : checkCertificateFast 10 1553 fastCert10_1553=true := by decide +kernel
def fastCert10_1554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1554 : checkCertificateFast 10 1554 fastCert10_1554=true := by decide +kernel
def fastCert10_1555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1555 : checkCertificateFast 10 1555 fastCert10_1555=true := by decide +kernel
def fastCert10_1556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1556 : checkCertificateFast 10 1556 fastCert10_1556=true := by decide +kernel
def fastCert10_1557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1557 : checkCertificateFast 10 1557 fastCert10_1557=true := by decide +kernel
def fastCert10_1558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1558 : checkCertificateFast 10 1558 fastCert10_1558=true := by decide +kernel
def fastCert10_1559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1559 : checkCertificateFast 10 1559 fastCert10_1559=true := by decide +kernel
def fastCert10_1560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1560 : checkCertificateFast 10 1560 fastCert10_1560=true := by decide +kernel
def fastCert10_1561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1561 : checkCertificateFast 10 1561 fastCert10_1561=true := by decide +kernel
def fastCert10_1562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1562 : checkCertificateFast 10 1562 fastCert10_1562=true := by decide +kernel
def fastCert10_1563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1563 : checkCertificateFast 10 1563 fastCert10_1563=true := by decide +kernel
def fastCert10_1564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1564 : checkCertificateFast 10 1564 fastCert10_1564=true := by decide +kernel
def fastCert10_1565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1565 : checkCertificateFast 10 1565 fastCert10_1565=true := by decide +kernel
def fastCert10_1566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1566 : checkCertificateFast 10 1566 fastCert10_1566=true := by decide +kernel
def fastCert10_1567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1567 : checkCertificateFast 10 1567 fastCert10_1567=true := by decide +kernel
def fastCert10_1568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1568 : checkCertificateFast 10 1568 fastCert10_1568=true := by decide +kernel
def fastCert10_1569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1569 : checkCertificateFast 10 1569 fastCert10_1569=true := by decide +kernel
def fastCert10_1570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1570 : checkCertificateFast 10 1570 fastCert10_1570=true := by decide +kernel
def fastCert10_1571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1571 : checkCertificateFast 10 1571 fastCert10_1571=true := by decide +kernel
def fastCert10_1572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1572 : checkCertificateFast 10 1572 fastCert10_1572=true := by decide +kernel
def fastCert10_1573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1573 : checkCertificateFast 10 1573 fastCert10_1573=true := by decide +kernel
def fastCert10_1574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1574 : checkCertificateFast 10 1574 fastCert10_1574=true := by decide +kernel
def fastCert10_1575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1575 : checkCertificateFast 10 1575 fastCert10_1575=true := by decide +kernel
def fastCert10_1576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1576 : checkCertificateFast 10 1576 fastCert10_1576=true := by decide +kernel
def fastCert10_1577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1577 : checkCertificateFast 10 1577 fastCert10_1577=true := by decide +kernel
def fastCert10_1578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1578 : checkCertificateFast 10 1578 fastCert10_1578=true := by decide +kernel
def fastCert10_1579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1579 : checkCertificateFast 10 1579 fastCert10_1579=true := by decide +kernel
def fastCert10_1580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1580 : checkCertificateFast 10 1580 fastCert10_1580=true := by decide +kernel
def fastCert10_1581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1581 : checkCertificateFast 10 1581 fastCert10_1581=true := by decide +kernel
def fastCert10_1582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1582 : checkCertificateFast 10 1582 fastCert10_1582=true := by decide +kernel
def fastCert10_1583 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1583 : checkCertificateFast 10 1583 fastCert10_1583=true := by decide +kernel
def fastCert10_1584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1584 : checkCertificateFast 10 1584 fastCert10_1584=true := by decide +kernel
def fastCert10_1585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1585 : checkCertificateFast 10 1585 fastCert10_1585=true := by decide +kernel
def fastCert10_1586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1586 : checkCertificateFast 10 1586 fastCert10_1586=true := by decide +kernel
def fastCert10_1587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1587 : checkCertificateFast 10 1587 fastCert10_1587=true := by decide +kernel
def fastCert10_1588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1588 : checkCertificateFast 10 1588 fastCert10_1588=true := by decide +kernel
def fastCert10_1589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1589 : checkCertificateFast 10 1589 fastCert10_1589=true := by decide +kernel
def fastCert10_1590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1590 : checkCertificateFast 10 1590 fastCert10_1590=true := by decide +kernel
def fastCert10_1591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1591 : checkCertificateFast 10 1591 fastCert10_1591=true := by decide +kernel
def fastCert10_1592 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1592 : checkCertificateFast 10 1592 fastCert10_1592=true := by decide +kernel
def fastCert10_1593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1593 : checkCertificateFast 10 1593 fastCert10_1593=true := by decide +kernel
def fastCert10_1594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1594 : checkCertificateFast 10 1594 fastCert10_1594=true := by decide +kernel
def fastCert10_1595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1595 : checkCertificateFast 10 1595 fastCert10_1595=true := by decide +kernel
def fastCert10_1596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1596 : checkCertificateFast 10 1596 fastCert10_1596=true := by decide +kernel
def fastCert10_1597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1597 : checkCertificateFast 10 1597 fastCert10_1597=true := by decide +kernel
def fastCert10_1598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1598 : checkCertificateFast 10 1598 fastCert10_1598=true := by decide +kernel
def fastCert10_1599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1599 : checkCertificateFast 10 1599 fastCert10_1599=true := by decide +kernel
def fastCert10_1600 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1600 : checkCertificateFast 10 1600 fastCert10_1600=true := by decide +kernel
def fastCert10_1601 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1601 : checkCertificateFast 10 1601 fastCert10_1601=true := by decide +kernel
def fastCert10_1602 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1602 : checkCertificateFast 10 1602 fastCert10_1602=true := by decide +kernel
def fastCert10_1603 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1603 : checkCertificateFast 10 1603 fastCert10_1603=true := by decide +kernel
def fastCert10_1604 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1604 : checkCertificateFast 10 1604 fastCert10_1604=true := by decide +kernel
def fastCert10_1605 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1605 : checkCertificateFast 10 1605 fastCert10_1605=true := by decide +kernel
def fastCert10_1606 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1606 : checkCertificateFast 10 1606 fastCert10_1606=true := by decide +kernel
def fastCert10_1607 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1607 : checkCertificateFast 10 1607 fastCert10_1607=true := by decide +kernel
def fastCert10_1608 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1608 : checkCertificateFast 10 1608 fastCert10_1608=true := by decide +kernel
def fastCert10_1609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1609 : checkCertificateFast 10 1609 fastCert10_1609=true := by decide +kernel
def fastCert10_1610 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1610 : checkCertificateFast 10 1610 fastCert10_1610=true := by decide +kernel
def fastCert10_1611 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1611 : checkCertificateFast 10 1611 fastCert10_1611=true := by decide +kernel
def fastCert10_1612 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1612 : checkCertificateFast 10 1612 fastCert10_1612=true := by decide +kernel
def fastCert10_1613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1613 : checkCertificateFast 10 1613 fastCert10_1613=true := by decide +kernel
def fastCert10_1614 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1614 : checkCertificateFast 10 1614 fastCert10_1614=true := by decide +kernel
def fastCert10_1615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1615 : checkCertificateFast 10 1615 fastCert10_1615=true := by decide +kernel
def fastCert10_1616 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1616 : checkCertificateFast 10 1616 fastCert10_1616=true := by decide +kernel
def fastCert10_1617 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1617 : checkCertificateFast 10 1617 fastCert10_1617=true := by decide +kernel
def fastCert10_1618 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1618 : checkCertificateFast 10 1618 fastCert10_1618=true := by decide +kernel
def fastCert10_1619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1619 : checkCertificateFast 10 1619 fastCert10_1619=true := by decide +kernel
def fastCert10_1620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1620 : checkCertificateFast 10 1620 fastCert10_1620=true := by decide +kernel
def fastCert10_1621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1621 : checkCertificateFast 10 1621 fastCert10_1621=true := by decide +kernel
def fastCert10_1622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1622 : checkCertificateFast 10 1622 fastCert10_1622=true := by decide +kernel
def fastCert10_1623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1623 : checkCertificateFast 10 1623 fastCert10_1623=true := by decide +kernel
def fastCert10_1624 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1624 : checkCertificateFast 10 1624 fastCert10_1624=true := by decide +kernel
def fastCert10_1625 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1625 : checkCertificateFast 10 1625 fastCert10_1625=true := by decide +kernel
def fastCert10_1626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1626 : checkCertificateFast 10 1626 fastCert10_1626=true := by decide +kernel
def fastCert10_1627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1627 : checkCertificateFast 10 1627 fastCert10_1627=true := by decide +kernel
def fastCert10_1628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1628 : checkCertificateFast 10 1628 fastCert10_1628=true := by decide +kernel
def fastCert10_1629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1629 : checkCertificateFast 10 1629 fastCert10_1629=true := by decide +kernel
def fastCert10_1630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1630 : checkCertificateFast 10 1630 fastCert10_1630=true := by decide +kernel
def fastCert10_1631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1631 : checkCertificateFast 10 1631 fastCert10_1631=true := by decide +kernel
def fastCert10_1632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1632 : checkCertificateFast 10 1632 fastCert10_1632=true := by decide +kernel
def fastCert10_1633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1633 : checkCertificateFast 10 1633 fastCert10_1633=true := by decide +kernel
def fastCert10_1634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_1634 : checkCertificateFast 10 1634 fastCert10_1634=true := by decide +kernel
def fastCert10_1635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_1635 : checkCertificateFast 10 1635 fastCert10_1635=true := by decide +kernel
def fastCert10_1636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1636 : checkCertificateFast 10 1636 fastCert10_1636=true := by decide +kernel
def fastCert10_1637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1637 : checkCertificateFast 10 1637 fastCert10_1637=true := by decide +kernel
def fastCert10_1638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1638 : checkCertificateFast 10 1638 fastCert10_1638=true := by decide +kernel
def fastCert10_1639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1639 : checkCertificateFast 10 1639 fastCert10_1639=true := by decide +kernel
def fastCert10_1640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1640 : checkCertificateFast 10 1640 fastCert10_1640=true := by decide +kernel
def fastCert10_1641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1641 : checkCertificateFast 10 1641 fastCert10_1641=true := by decide +kernel
def fastCert10_1642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_1642 : checkCertificateFast 10 1642 fastCert10_1642=true := by decide +kernel
def fastCert10_1643 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1643 : checkCertificateFast 10 1643 fastCert10_1643=true := by decide +kernel
def fastCert10_1644 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1644 : checkCertificateFast 10 1644 fastCert10_1644=true := by decide +kernel
def fastCert10_1645 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1645 : checkCertificateFast 10 1645 fastCert10_1645=true := by decide +kernel
def fastCert10_1646 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1646 : checkCertificateFast 10 1646 fastCert10_1646=true := by decide +kernel
def fastCert10_1647 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1647 : checkCertificateFast 10 1647 fastCert10_1647=true := by decide +kernel
def fastCert10_1648 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1648 : checkCertificateFast 10 1648 fastCert10_1648=true := by decide +kernel
def fastCert10_1649 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1649 : checkCertificateFast 10 1649 fastCert10_1649=true := by decide +kernel
def fastCert10_1650 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1650 : checkCertificateFast 10 1650 fastCert10_1650=true := by decide +kernel
def fastCert10_1651 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1651 : checkCertificateFast 10 1651 fastCert10_1651=true := by decide +kernel
def fastCert10_1652 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1652 : checkCertificateFast 10 1652 fastCert10_1652=true := by decide +kernel
def fastCert10_1653 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1653 : checkCertificateFast 10 1653 fastCert10_1653=true := by decide +kernel
def fastCert10_1654 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1654 : checkCertificateFast 10 1654 fastCert10_1654=true := by decide +kernel
def fastCert10_1655 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1655 : checkCertificateFast 10 1655 fastCert10_1655=true := by decide +kernel
def fastCert10_1656 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1656 : checkCertificateFast 10 1656 fastCert10_1656=true := by decide +kernel
def fastCert10_1657 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1657 : checkCertificateFast 10 1657 fastCert10_1657=true := by decide +kernel
def fastCert10_1658 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1658 : checkCertificateFast 10 1658 fastCert10_1658=true := by decide +kernel
def fastCert10_1659 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1659 : checkCertificateFast 10 1659 fastCert10_1659=true := by decide +kernel
def fastCert10_1660 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1660 : checkCertificateFast 10 1660 fastCert10_1660=true := by decide +kernel
def fastCert10_1661 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1661 : checkCertificateFast 10 1661 fastCert10_1661=true := by decide +kernel
def fastCert10_1662 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1662 : checkCertificateFast 10 1662 fastCert10_1662=true := by decide +kernel
def fastCert10_1663 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1663 : checkCertificateFast 10 1663 fastCert10_1663=true := by decide +kernel
def fastCert10_1664 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1664 : checkCertificateFast 10 1664 fastCert10_1664=true := by decide +kernel
def fastCert10_1665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1665 : checkCertificateFast 10 1665 fastCert10_1665=true := by decide +kernel
def fastCert10_1666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1666 : checkCertificateFast 10 1666 fastCert10_1666=true := by decide +kernel
def fastCert10_1667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1667 : checkCertificateFast 10 1667 fastCert10_1667=true := by decide +kernel
def fastCert10_1668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1668 : checkCertificateFast 10 1668 fastCert10_1668=true := by decide +kernel
def fastCert10_1669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1669 : checkCertificateFast 10 1669 fastCert10_1669=true := by decide +kernel
def fastCert10_1670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1670 : checkCertificateFast 10 1670 fastCert10_1670=true := by decide +kernel
def fastCert10_1671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1671 : checkCertificateFast 10 1671 fastCert10_1671=true := by decide +kernel
def fastCert10_1672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1672 : checkCertificateFast 10 1672 fastCert10_1672=true := by decide +kernel
def fastCert10_1673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1673 : checkCertificateFast 10 1673 fastCert10_1673=true := by decide +kernel
def fastCert10_1674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1674 : checkCertificateFast 10 1674 fastCert10_1674=true := by decide +kernel
def fastCert10_1675 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1675 : checkCertificateFast 10 1675 fastCert10_1675=true := by decide +kernel
def fastCert10_1676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1676 : checkCertificateFast 10 1676 fastCert10_1676=true := by decide +kernel
def fastCert10_1677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1677 : checkCertificateFast 10 1677 fastCert10_1677=true := by decide +kernel
def fastCert10_1678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1678 : checkCertificateFast 10 1678 fastCert10_1678=true := by decide +kernel
def fastCert10_1679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1679 : checkCertificateFast 10 1679 fastCert10_1679=true := by decide +kernel
def fastCert10_1680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1680 : checkCertificateFast 10 1680 fastCert10_1680=true := by decide +kernel
def fastCert10_1681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1681 : checkCertificateFast 10 1681 fastCert10_1681=true := by decide +kernel
def fastCert10_1682 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_1682 : checkCertificateFast 10 1682 fastCert10_1682=true := by decide +kernel
def fastCert10_1683 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1683 : checkCertificateFast 10 1683 fastCert10_1683=true := by decide +kernel
def fastCert10_1684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1684 : checkCertificateFast 10 1684 fastCert10_1684=true := by decide +kernel
def fastCert10_1685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1685 : checkCertificateFast 10 1685 fastCert10_1685=true := by decide +kernel
def fastCert10_1686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1686 : checkCertificateFast 10 1686 fastCert10_1686=true := by decide +kernel
def fastCert10_1687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1687 : checkCertificateFast 10 1687 fastCert10_1687=true := by decide +kernel
def fastCert10_1688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1688 : checkCertificateFast 10 1688 fastCert10_1688=true := by decide +kernel
def fastCert10_1689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1689 : checkCertificateFast 10 1689 fastCert10_1689=true := by decide +kernel
def fastCert10_1690 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1690 : checkCertificateFast 10 1690 fastCert10_1690=true := by decide +kernel
def fastCert10_1691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_1691 : checkCertificateFast 10 1691 fastCert10_1691=true := by decide +kernel
def fastCert10_1692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1692 : checkCertificateFast 10 1692 fastCert10_1692=true := by decide +kernel
def fastCert10_1693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1693 : checkCertificateFast 10 1693 fastCert10_1693=true := by decide +kernel
def fastCert10_1694 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1694 : checkCertificateFast 10 1694 fastCert10_1694=true := by decide +kernel
def fastCert10_1695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1695 : checkCertificateFast 10 1695 fastCert10_1695=true := by decide +kernel
def fastCert10_1696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1696 : checkCertificateFast 10 1696 fastCert10_1696=true := by decide +kernel
def fastCert10_1697 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1697 : checkCertificateFast 10 1697 fastCert10_1697=true := by decide +kernel
def fastCert10_1698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1698 : checkCertificateFast 10 1698 fastCert10_1698=true := by decide +kernel
def fastCert10_1699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1699 : checkCertificateFast 10 1699 fastCert10_1699=true := by decide +kernel
def fastCert10_1700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1700 : checkCertificateFast 10 1700 fastCert10_1700=true := by decide +kernel
def fastCert10_1701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1701 : checkCertificateFast 10 1701 fastCert10_1701=true := by decide +kernel
def fastCert10_1702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1702 : checkCertificateFast 10 1702 fastCert10_1702=true := by decide +kernel
def fastCert10_1703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1703 : checkCertificateFast 10 1703 fastCert10_1703=true := by decide +kernel
def fastCert10_1704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1704 : checkCertificateFast 10 1704 fastCert10_1704=true := by decide +kernel
def fastCert10_1705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1705 : checkCertificateFast 10 1705 fastCert10_1705=true := by decide +kernel
def fastCert10_1706 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1706 : checkCertificateFast 10 1706 fastCert10_1706=true := by decide +kernel
def fastCert10_1707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1707 : checkCertificateFast 10 1707 fastCert10_1707=true := by decide +kernel
def fastCert10_1708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1708 : checkCertificateFast 10 1708 fastCert10_1708=true := by decide +kernel
def fastCert10_1709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1709 : checkCertificateFast 10 1709 fastCert10_1709=true := by decide +kernel
def fastCert10_1710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1710 : checkCertificateFast 10 1710 fastCert10_1710=true := by decide +kernel
def fastCert10_1711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1711 : checkCertificateFast 10 1711 fastCert10_1711=true := by decide +kernel
def fastCert10_1712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1712 : checkCertificateFast 10 1712 fastCert10_1712=true := by decide +kernel
def fastCert10_1713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1713 : checkCertificateFast 10 1713 fastCert10_1713=true := by decide +kernel
def fastCert10_1714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1714 : checkCertificateFast 10 1714 fastCert10_1714=true := by decide +kernel
def fastCert10_1715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1715 : checkCertificateFast 10 1715 fastCert10_1715=true := by decide +kernel
def fastCert10_1716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1716 : checkCertificateFast 10 1716 fastCert10_1716=true := by decide +kernel
def fastCert10_1717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1717 : checkCertificateFast 10 1717 fastCert10_1717=true := by decide +kernel
def fastCert10_1718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1718 : checkCertificateFast 10 1718 fastCert10_1718=true := by decide +kernel
def fastCert10_1719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1719 : checkCertificateFast 10 1719 fastCert10_1719=true := by decide +kernel
def fastCert10_1720 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1720 : checkCertificateFast 10 1720 fastCert10_1720=true := by decide +kernel
def fastCert10_1721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1721 : checkCertificateFast 10 1721 fastCert10_1721=true := by decide +kernel
def fastCert10_1722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1722 : checkCertificateFast 10 1722 fastCert10_1722=true := by decide +kernel
def fastCert10_1723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1723 : checkCertificateFast 10 1723 fastCert10_1723=true := by decide +kernel
def fastCert10_1724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1724 : checkCertificateFast 10 1724 fastCert10_1724=true := by decide +kernel
def fastCert10_1725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1725 : checkCertificateFast 10 1725 fastCert10_1725=true := by decide +kernel
def fastCert10_1726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1726 : checkCertificateFast 10 1726 fastCert10_1726=true := by decide +kernel
def fastCert10_1727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1727 : checkCertificateFast 10 1727 fastCert10_1727=true := by decide +kernel
def fastCert10_1728 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1728 : checkCertificateFast 10 1728 fastCert10_1728=true := by decide +kernel
def fastCert10_1729 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1729 : checkCertificateFast 10 1729 fastCert10_1729=true := by decide +kernel
def fastCert10_1730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1730 : checkCertificateFast 10 1730 fastCert10_1730=true := by decide +kernel
def fastCert10_1731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1731 : checkCertificateFast 10 1731 fastCert10_1731=true := by decide +kernel
def fastCert10_1732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1732 : checkCertificateFast 10 1732 fastCert10_1732=true := by decide +kernel
def fastCert10_1733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1733 : checkCertificateFast 10 1733 fastCert10_1733=true := by decide +kernel
def fastCert10_1734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1734 : checkCertificateFast 10 1734 fastCert10_1734=true := by decide +kernel
def fastCert10_1735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1735 : checkCertificateFast 10 1735 fastCert10_1735=true := by decide +kernel
def fastCert10_1736 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1736 : checkCertificateFast 10 1736 fastCert10_1736=true := by decide +kernel
def fastCert10_1737 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1737 : checkCertificateFast 10 1737 fastCert10_1737=true := by decide +kernel
def fastCert10_1738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1738 : checkCertificateFast 10 1738 fastCert10_1738=true := by decide +kernel
def fastCert10_1739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1739 : checkCertificateFast 10 1739 fastCert10_1739=true := by decide +kernel
def fastCert10_1740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1740 : checkCertificateFast 10 1740 fastCert10_1740=true := by decide +kernel
def fastCert10_1741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1741 : checkCertificateFast 10 1741 fastCert10_1741=true := by decide +kernel
def fastCert10_1742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1742 : checkCertificateFast 10 1742 fastCert10_1742=true := by decide +kernel
def fastCert10_1743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1743 : checkCertificateFast 10 1743 fastCert10_1743=true := by decide +kernel
def fastCert10_1744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1744 : checkCertificateFast 10 1744 fastCert10_1744=true := by decide +kernel
def fastCert10_1745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1745 : checkCertificateFast 10 1745 fastCert10_1745=true := by decide +kernel
def fastCert10_1746 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1746 : checkCertificateFast 10 1746 fastCert10_1746=true := by decide +kernel
def fastCert10_1747 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1747 : checkCertificateFast 10 1747 fastCert10_1747=true := by decide +kernel
def fastCert10_1748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1748 : checkCertificateFast 10 1748 fastCert10_1748=true := by decide +kernel
def fastCert10_1749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1749 : checkCertificateFast 10 1749 fastCert10_1749=true := by decide +kernel
def fastCert10_1750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1750 : checkCertificateFast 10 1750 fastCert10_1750=true := by decide +kernel
def fastCert10_1751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1751 : checkCertificateFast 10 1751 fastCert10_1751=true := by decide +kernel
def fastCert10_1752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1752 : checkCertificateFast 10 1752 fastCert10_1752=true := by decide +kernel
def fastCert10_1753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1753 : checkCertificateFast 10 1753 fastCert10_1753=true := by decide +kernel
def fastCert10_1754 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1754 : checkCertificateFast 10 1754 fastCert10_1754=true := by decide +kernel
def fastCert10_1755 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1755 : checkCertificateFast 10 1755 fastCert10_1755=true := by decide +kernel
def fastCert10_1756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1756 : checkCertificateFast 10 1756 fastCert10_1756=true := by decide +kernel
def fastCert10_1757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1757 : checkCertificateFast 10 1757 fastCert10_1757=true := by decide +kernel
def fastCert10_1758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1758 : checkCertificateFast 10 1758 fastCert10_1758=true := by decide +kernel
def fastCert10_1759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1759 : checkCertificateFast 10 1759 fastCert10_1759=true := by decide +kernel
def fastCert10_1760 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1760 : checkCertificateFast 10 1760 fastCert10_1760=true := by decide +kernel
def fastCert10_1761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1761 : checkCertificateFast 10 1761 fastCert10_1761=true := by decide +kernel
def fastCert10_1762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1762 : checkCertificateFast 10 1762 fastCert10_1762=true := by decide +kernel
def fastCert10_1763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1763 : checkCertificateFast 10 1763 fastCert10_1763=true := by decide +kernel
def fastCert10_1764 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1764 : checkCertificateFast 10 1764 fastCert10_1764=true := by decide +kernel
def fastCert10_1765 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1765 : checkCertificateFast 10 1765 fastCert10_1765=true := by decide +kernel
def fastCert10_1766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1766 : checkCertificateFast 10 1766 fastCert10_1766=true := by decide +kernel
def fastCert10_1767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1767 : checkCertificateFast 10 1767 fastCert10_1767=true := by decide +kernel
def fastCert10_1768 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1768 : checkCertificateFast 10 1768 fastCert10_1768=true := by decide +kernel
def fastCert10_1769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1769 : checkCertificateFast 10 1769 fastCert10_1769=true := by decide +kernel
def fastCert10_1770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1770 : checkCertificateFast 10 1770 fastCert10_1770=true := by decide +kernel
def fastCert10_1771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1771 : checkCertificateFast 10 1771 fastCert10_1771=true := by decide +kernel
def fastCert10_1772 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1772 : checkCertificateFast 10 1772 fastCert10_1772=true := by decide +kernel
def fastCert10_1773 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1773 : checkCertificateFast 10 1773 fastCert10_1773=true := by decide +kernel
def fastCert10_1774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1774 : checkCertificateFast 10 1774 fastCert10_1774=true := by decide +kernel
def fastCert10_1775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1775 : checkCertificateFast 10 1775 fastCert10_1775=true := by decide +kernel
def fastCert10_1776 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1776 : checkCertificateFast 10 1776 fastCert10_1776=true := by decide +kernel
def fastCert10_1777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1777 : checkCertificateFast 10 1777 fastCert10_1777=true := by decide +kernel
def fastCert10_1778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1778 : checkCertificateFast 10 1778 fastCert10_1778=true := by decide +kernel
def fastCert10_1779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1779 : checkCertificateFast 10 1779 fastCert10_1779=true := by decide +kernel
def fastCert10_1780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1780 : checkCertificateFast 10 1780 fastCert10_1780=true := by decide +kernel
def fastCert10_1781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1781 : checkCertificateFast 10 1781 fastCert10_1781=true := by decide +kernel
def fastCert10_1782 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1782 : checkCertificateFast 10 1782 fastCert10_1782=true := by decide +kernel
def fastCert10_1783 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1783 : checkCertificateFast 10 1783 fastCert10_1783=true := by decide +kernel
def fastCert10_1784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1784 : checkCertificateFast 10 1784 fastCert10_1784=true := by decide +kernel
def fastCert10_1785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1785 : checkCertificateFast 10 1785 fastCert10_1785=true := by decide +kernel
def fastCert10_1786 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1786 : checkCertificateFast 10 1786 fastCert10_1786=true := by decide +kernel
def fastCert10_1787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1787 : checkCertificateFast 10 1787 fastCert10_1787=true := by decide +kernel
def fastCert10_1788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1788 : checkCertificateFast 10 1788 fastCert10_1788=true := by decide +kernel
def fastCert10_1789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1789 : checkCertificateFast 10 1789 fastCert10_1789=true := by decide +kernel
def fastCert10_1790 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1790 : checkCertificateFast 10 1790 fastCert10_1790=true := by decide +kernel
def fastCert10_1791 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1791 : checkCertificateFast 10 1791 fastCert10_1791=true := by decide +kernel
def fastCert10_1792 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1792 : checkCertificateFast 10 1792 fastCert10_1792=true := by decide +kernel
def fastCert10_1793 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1793 : checkCertificateFast 10 1793 fastCert10_1793=true := by decide +kernel
def fastCert10_1794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1794 : checkCertificateFast 10 1794 fastCert10_1794=true := by decide +kernel
def fastCert10_1795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1795 : checkCertificateFast 10 1795 fastCert10_1795=true := by decide +kernel
def fastCert10_1796 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1796 : checkCertificateFast 10 1796 fastCert10_1796=true := by decide +kernel
def fastCert10_1797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1797 : checkCertificateFast 10 1797 fastCert10_1797=true := by decide +kernel
def fastCert10_1798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1798 : checkCertificateFast 10 1798 fastCert10_1798=true := by decide +kernel
def fastCert10_1799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1799 : checkCertificateFast 10 1799 fastCert10_1799=true := by decide +kernel
def fastCert10_1800 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1800 : checkCertificateFast 10 1800 fastCert10_1800=true := by decide +kernel
def fastCert10_1801 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1801 : checkCertificateFast 10 1801 fastCert10_1801=true := by decide +kernel
def fastCert10_1802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1802 : checkCertificateFast 10 1802 fastCert10_1802=true := by decide +kernel
def fastCert10_1803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1803 : checkCertificateFast 10 1803 fastCert10_1803=true := by decide +kernel
def fastCert10_1804 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1804 : checkCertificateFast 10 1804 fastCert10_1804=true := by decide +kernel
def fastCert10_1805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1805 : checkCertificateFast 10 1805 fastCert10_1805=true := by decide +kernel
def fastCert10_1806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1806 : checkCertificateFast 10 1806 fastCert10_1806=true := by decide +kernel
def fastCert10_1807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1807 : checkCertificateFast 10 1807 fastCert10_1807=true := by decide +kernel
def fastCert10_1808 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1808 : checkCertificateFast 10 1808 fastCert10_1808=true := by decide +kernel
def fastCert10_1809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1809 : checkCertificateFast 10 1809 fastCert10_1809=true := by decide +kernel
def fastCert10_1810 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1810 : checkCertificateFast 10 1810 fastCert10_1810=true := by decide +kernel
def fastCert10_1811 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1811 : checkCertificateFast 10 1811 fastCert10_1811=true := by decide +kernel
def fastCert10_1812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1812 : checkCertificateFast 10 1812 fastCert10_1812=true := by decide +kernel
def fastCert10_1813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1813 : checkCertificateFast 10 1813 fastCert10_1813=true := by decide +kernel
def fastCert10_1814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1814 : checkCertificateFast 10 1814 fastCert10_1814=true := by decide +kernel
def fastCert10_1815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1815 : checkCertificateFast 10 1815 fastCert10_1815=true := by decide +kernel
def fastCert10_1816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1816 : checkCertificateFast 10 1816 fastCert10_1816=true := by decide +kernel
def fastCert10_1817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1817 : checkCertificateFast 10 1817 fastCert10_1817=true := by decide +kernel
def fastCert10_1818 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1818 : checkCertificateFast 10 1818 fastCert10_1818=true := by decide +kernel
def fastCert10_1819 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1819 : checkCertificateFast 10 1819 fastCert10_1819=true := by decide +kernel
def fastCert10_1820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1820 : checkCertificateFast 10 1820 fastCert10_1820=true := by decide +kernel
def fastCert10_1821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1821 : checkCertificateFast 10 1821 fastCert10_1821=true := by decide +kernel
def fastCert10_1822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1822 : checkCertificateFast 10 1822 fastCert10_1822=true := by decide +kernel
def fastCert10_1823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1823 : checkCertificateFast 10 1823 fastCert10_1823=true := by decide +kernel
def fastCert10_1824 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1824 : checkCertificateFast 10 1824 fastCert10_1824=true := by decide +kernel
def fastCert10_1825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1825 : checkCertificateFast 10 1825 fastCert10_1825=true := by decide +kernel
def fastCert10_1826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1826 : checkCertificateFast 10 1826 fastCert10_1826=true := by decide +kernel
def fastCert10_1827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1827 : checkCertificateFast 10 1827 fastCert10_1827=true := by decide +kernel
def fastCert10_1828 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1828 : checkCertificateFast 10 1828 fastCert10_1828=true := by decide +kernel
def fastCert10_1829 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1829 : checkCertificateFast 10 1829 fastCert10_1829=true := by decide +kernel
def fastCert10_1830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1830 : checkCertificateFast 10 1830 fastCert10_1830=true := by decide +kernel
def fastCert10_1831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1831 : checkCertificateFast 10 1831 fastCert10_1831=true := by decide +kernel
def fastCert10_1832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1832 : checkCertificateFast 10 1832 fastCert10_1832=true := by decide +kernel
def fastCert10_1833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1833 : checkCertificateFast 10 1833 fastCert10_1833=true := by decide +kernel
def fastCert10_1834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1834 : checkCertificateFast 10 1834 fastCert10_1834=true := by decide +kernel
def fastCert10_1835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1835 : checkCertificateFast 10 1835 fastCert10_1835=true := by decide +kernel
def fastCert10_1836 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1836 : checkCertificateFast 10 1836 fastCert10_1836=true := by decide +kernel
def fastCert10_1837 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1837 : checkCertificateFast 10 1837 fastCert10_1837=true := by decide +kernel
def fastCert10_1838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1838 : checkCertificateFast 10 1838 fastCert10_1838=true := by decide +kernel
def fastCert10_1839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1839 : checkCertificateFast 10 1839 fastCert10_1839=true := by decide +kernel
def fastCert10_1840 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1840 : checkCertificateFast 10 1840 fastCert10_1840=true := by decide +kernel
def fastCert10_1841 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1841 : checkCertificateFast 10 1841 fastCert10_1841=true := by decide +kernel
def fastCert10_1842 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1842 : checkCertificateFast 10 1842 fastCert10_1842=true := by decide +kernel
def fastCert10_1843 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1843 : checkCertificateFast 10 1843 fastCert10_1843=true := by decide +kernel
def fastCert10_1844 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1844 : checkCertificateFast 10 1844 fastCert10_1844=true := by decide +kernel
def fastCert10_1845 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1845 : checkCertificateFast 10 1845 fastCert10_1845=true := by decide +kernel
def fastCert10_1846 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1846 : checkCertificateFast 10 1846 fastCert10_1846=true := by decide +kernel
def fastCert10_1847 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_1847 : checkCertificateFast 10 1847 fastCert10_1847=true := by decide +kernel
def fastCert10_1848 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1848 : checkCertificateFast 10 1848 fastCert10_1848=true := by decide +kernel
def fastCert10_1849 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1849 : checkCertificateFast 10 1849 fastCert10_1849=true := by decide +kernel
def fastCert10_1850 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1850 : checkCertificateFast 10 1850 fastCert10_1850=true := by decide +kernel
def fastCert10_1851 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1851 : checkCertificateFast 10 1851 fastCert10_1851=true := by decide +kernel
def fastCert10_1852 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1852 : checkCertificateFast 10 1852 fastCert10_1852=true := by decide +kernel
def fastCert10_1853 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1853 : checkCertificateFast 10 1853 fastCert10_1853=true := by decide +kernel
def fastCert10_1854 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1854 : checkCertificateFast 10 1854 fastCert10_1854=true := by decide +kernel
def fastCert10_1855 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_1855 : checkCertificateFast 10 1855 fastCert10_1855=true := by decide +kernel
def fastCert10_1856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_1856 : checkCertificateFast 10 1856 fastCert10_1856=true := by decide +kernel
def fastCert10_1857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1857 : checkCertificateFast 10 1857 fastCert10_1857=true := by decide +kernel
def fastCert10_1858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1858 : checkCertificateFast 10 1858 fastCert10_1858=true := by decide +kernel
def fastCert10_1859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1859 : checkCertificateFast 10 1859 fastCert10_1859=true := by decide +kernel
def fastCert10_1860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1860 : checkCertificateFast 10 1860 fastCert10_1860=true := by decide +kernel
def fastCert10_1861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1861 : checkCertificateFast 10 1861 fastCert10_1861=true := by decide +kernel
def fastCert10_1862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1862 : checkCertificateFast 10 1862 fastCert10_1862=true := by decide +kernel
def fastCert10_1863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1863 : checkCertificateFast 10 1863 fastCert10_1863=true := by decide +kernel
def fastCert10_1864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_1864 : checkCertificateFast 10 1864 fastCert10_1864=true := by decide +kernel
def fastCert10_1865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_1865 : checkCertificateFast 10 1865 fastCert10_1865=true := by decide +kernel
def fastCert10_1866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1866 : checkCertificateFast 10 1866 fastCert10_1866=true := by decide +kernel
def fastCert10_1867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1867 : checkCertificateFast 10 1867 fastCert10_1867=true := by decide +kernel
def fastCert10_1868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1868 : checkCertificateFast 10 1868 fastCert10_1868=true := by decide +kernel
def fastCert10_1869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1869 : checkCertificateFast 10 1869 fastCert10_1869=true := by decide +kernel
def fastCert10_1870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1870 : checkCertificateFast 10 1870 fastCert10_1870=true := by decide +kernel
def fastCert10_1871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1871 : checkCertificateFast 10 1871 fastCert10_1871=true := by decide +kernel
def fastCert10_1872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1872 : checkCertificateFast 10 1872 fastCert10_1872=true := by decide +kernel
def fastCert10_1873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1873 : checkCertificateFast 10 1873 fastCert10_1873=true := by decide +kernel
def fastCert10_1874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1874 : checkCertificateFast 10 1874 fastCert10_1874=true := by decide +kernel
def fastCert10_1875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1875 : checkCertificateFast 10 1875 fastCert10_1875=true := by decide +kernel
def fastCert10_1876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1876 : checkCertificateFast 10 1876 fastCert10_1876=true := by decide +kernel
def fastCert10_1877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1877 : checkCertificateFast 10 1877 fastCert10_1877=true := by decide +kernel
def fastCert10_1878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1878 : checkCertificateFast 10 1878 fastCert10_1878=true := by decide +kernel
def fastCert10_1879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1879 : checkCertificateFast 10 1879 fastCert10_1879=true := by decide +kernel
def fastCert10_1880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1880 : checkCertificateFast 10 1880 fastCert10_1880=true := by decide +kernel
def fastCert10_1881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1881 : checkCertificateFast 10 1881 fastCert10_1881=true := by decide +kernel
def fastCert10_1882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_1882 : checkCertificateFast 10 1882 fastCert10_1882=true := by decide +kernel
def fastCert10_1883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1883 : checkCertificateFast 10 1883 fastCert10_1883=true := by decide +kernel
def fastCert10_1884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1884 : checkCertificateFast 10 1884 fastCert10_1884=true := by decide +kernel
def fastCert10_1885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1885 : checkCertificateFast 10 1885 fastCert10_1885=true := by decide +kernel
def fastCert10_1886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1886 : checkCertificateFast 10 1886 fastCert10_1886=true := by decide +kernel
def fastCert10_1887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1887 : checkCertificateFast 10 1887 fastCert10_1887=true := by decide +kernel
def fastCert10_1888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1888 : checkCertificateFast 10 1888 fastCert10_1888=true := by decide +kernel
def fastCert10_1889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1889 : checkCertificateFast 10 1889 fastCert10_1889=true := by decide +kernel
def fastCert10_1890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1890 : checkCertificateFast 10 1890 fastCert10_1890=true := by decide +kernel
def fastCert10_1891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1891 : checkCertificateFast 10 1891 fastCert10_1891=true := by decide +kernel
def fastCert10_1892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1892 : checkCertificateFast 10 1892 fastCert10_1892=true := by decide +kernel
def fastCert10_1893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1893 : checkCertificateFast 10 1893 fastCert10_1893=true := by decide +kernel
def fastCert10_1894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1894 : checkCertificateFast 10 1894 fastCert10_1894=true := by decide +kernel
def fastCert10_1895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1895 : checkCertificateFast 10 1895 fastCert10_1895=true := by decide +kernel
def fastCert10_1896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1896 : checkCertificateFast 10 1896 fastCert10_1896=true := by decide +kernel
def fastCert10_1897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1897 : checkCertificateFast 10 1897 fastCert10_1897=true := by decide +kernel
def fastCert10_1898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_1898 : checkCertificateFast 10 1898 fastCert10_1898=true := by decide +kernel
def fastCert10_1899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1899 : checkCertificateFast 10 1899 fastCert10_1899=true := by decide +kernel
def fastCert10_1900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1900 : checkCertificateFast 10 1900 fastCert10_1900=true := by decide +kernel
def fastCert10_1901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1901 : checkCertificateFast 10 1901 fastCert10_1901=true := by decide +kernel
def fastCert10_1902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1902 : checkCertificateFast 10 1902 fastCert10_1902=true := by decide +kernel
def fastCert10_1903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1903 : checkCertificateFast 10 1903 fastCert10_1903=true := by decide +kernel
def fastCert10_1904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1904 : checkCertificateFast 10 1904 fastCert10_1904=true := by decide +kernel
def fastCert10_1905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1905 : checkCertificateFast 10 1905 fastCert10_1905=true := by decide +kernel
def fastCert10_1906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1906 : checkCertificateFast 10 1906 fastCert10_1906=true := by decide +kernel
def fastCert10_1907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1907 : checkCertificateFast 10 1907 fastCert10_1907=true := by decide +kernel
def fastCert10_1908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1908 : checkCertificateFast 10 1908 fastCert10_1908=true := by decide +kernel
def fastCert10_1909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1909 : checkCertificateFast 10 1909 fastCert10_1909=true := by decide +kernel
def fastCert10_1910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1910 : checkCertificateFast 10 1910 fastCert10_1910=true := by decide +kernel
def fastCert10_1911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1911 : checkCertificateFast 10 1911 fastCert10_1911=true := by decide +kernel
def fastCert10_1912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_1912 : checkCertificateFast 10 1912 fastCert10_1912=true := by decide +kernel
def fastCert10_1913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_1913 : checkCertificateFast 10 1913 fastCert10_1913=true := by decide +kernel
def fastCert10_1914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1914 : checkCertificateFast 10 1914 fastCert10_1914=true := by decide +kernel
def fastCert10_1915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_1915 : checkCertificateFast 10 1915 fastCert10_1915=true := by decide +kernel
def fastCert10_1916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1916 : checkCertificateFast 10 1916 fastCert10_1916=true := by decide +kernel
def fastCert10_1917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1917 : checkCertificateFast 10 1917 fastCert10_1917=true := by decide +kernel
def fastCert10_1918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1918 : checkCertificateFast 10 1918 fastCert10_1918=true := by decide +kernel
def fastCert10_1919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_1919 : checkCertificateFast 10 1919 fastCert10_1919=true := by decide +kernel
def fastCert10_1920 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1920 : checkCertificateFast 10 1920 fastCert10_1920=true := by decide +kernel
def fastCert10_1921 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1921 : checkCertificateFast 10 1921 fastCert10_1921=true := by decide +kernel
def fastCert10_1922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1922 : checkCertificateFast 10 1922 fastCert10_1922=true := by decide +kernel
def fastCert10_1923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1923 : checkCertificateFast 10 1923 fastCert10_1923=true := by decide +kernel
def fastCert10_1924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1924 : checkCertificateFast 10 1924 fastCert10_1924=true := by decide +kernel
def fastCert10_1925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1925 : checkCertificateFast 10 1925 fastCert10_1925=true := by decide +kernel
def fastCert10_1926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1926 : checkCertificateFast 10 1926 fastCert10_1926=true := by decide +kernel
def fastCert10_1927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1927 : checkCertificateFast 10 1927 fastCert10_1927=true := by decide +kernel
def fastCert10_1928 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1928 : checkCertificateFast 10 1928 fastCert10_1928=true := by decide +kernel
def fastCert10_1929 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1929 : checkCertificateFast 10 1929 fastCert10_1929=true := by decide +kernel
def fastCert10_1930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1930 : checkCertificateFast 10 1930 fastCert10_1930=true := by decide +kernel
def fastCert10_1931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1931 : checkCertificateFast 10 1931 fastCert10_1931=true := by decide +kernel
def fastCert10_1932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1932 : checkCertificateFast 10 1932 fastCert10_1932=true := by decide +kernel
def fastCert10_1933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1933 : checkCertificateFast 10 1933 fastCert10_1933=true := by decide +kernel
def fastCert10_1934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1934 : checkCertificateFast 10 1934 fastCert10_1934=true := by decide +kernel
def fastCert10_1935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1935 : checkCertificateFast 10 1935 fastCert10_1935=true := by decide +kernel
def fastCert10_1936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1936 : checkCertificateFast 10 1936 fastCert10_1936=true := by decide +kernel
def fastCert10_1937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1937 : checkCertificateFast 10 1937 fastCert10_1937=true := by decide +kernel
def fastCert10_1938 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1938 : checkCertificateFast 10 1938 fastCert10_1938=true := by decide +kernel
def fastCert10_1939 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1939 : checkCertificateFast 10 1939 fastCert10_1939=true := by decide +kernel
def fastCert10_1940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1940 : checkCertificateFast 10 1940 fastCert10_1940=true := by decide +kernel
def fastCert10_1941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1941 : checkCertificateFast 10 1941 fastCert10_1941=true := by decide +kernel
def fastCert10_1942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1942 : checkCertificateFast 10 1942 fastCert10_1942=true := by decide +kernel
def fastCert10_1943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1943 : checkCertificateFast 10 1943 fastCert10_1943=true := by decide +kernel
def fastCert10_1944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1944 : checkCertificateFast 10 1944 fastCert10_1944=true := by decide +kernel
def fastCert10_1945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1945 : checkCertificateFast 10 1945 fastCert10_1945=true := by decide +kernel
def fastCert10_1946 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1946 : checkCertificateFast 10 1946 fastCert10_1946=true := by decide +kernel
def fastCert10_1947 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1947 : checkCertificateFast 10 1947 fastCert10_1947=true := by decide +kernel
def fastCert10_1948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1948 : checkCertificateFast 10 1948 fastCert10_1948=true := by decide +kernel
def fastCert10_1949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1949 : checkCertificateFast 10 1949 fastCert10_1949=true := by decide +kernel
def fastCert10_1950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1950 : checkCertificateFast 10 1950 fastCert10_1950=true := by decide +kernel
def fastCert10_1951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1951 : checkCertificateFast 10 1951 fastCert10_1951=true := by decide +kernel
def fastCert10_1952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1952 : checkCertificateFast 10 1952 fastCert10_1952=true := by decide +kernel
def fastCert10_1953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1953 : checkCertificateFast 10 1953 fastCert10_1953=true := by decide +kernel
def fastCert10_1954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1954 : checkCertificateFast 10 1954 fastCert10_1954=true := by decide +kernel
def fastCert10_1955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1955 : checkCertificateFast 10 1955 fastCert10_1955=true := by decide +kernel
def fastCert10_1956 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1956 : checkCertificateFast 10 1956 fastCert10_1956=true := by decide +kernel
def fastCert10_1957 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1957 : checkCertificateFast 10 1957 fastCert10_1957=true := by decide +kernel
def fastCert10_1958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1958 : checkCertificateFast 10 1958 fastCert10_1958=true := by decide +kernel
def fastCert10_1959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1959 : checkCertificateFast 10 1959 fastCert10_1959=true := by decide +kernel
def fastCert10_1960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1960 : checkCertificateFast 10 1960 fastCert10_1960=true := by decide +kernel
def fastCert10_1961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_1961 : checkCertificateFast 10 1961 fastCert10_1961=true := by decide +kernel
def fastCert10_1962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1962 : checkCertificateFast 10 1962 fastCert10_1962=true := by decide +kernel
def fastCert10_1963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1963 : checkCertificateFast 10 1963 fastCert10_1963=true := by decide +kernel
def fastCert10_1964 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1964 : checkCertificateFast 10 1964 fastCert10_1964=true := by decide +kernel
def fastCert10_1965 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_1965 : checkCertificateFast 10 1965 fastCert10_1965=true := by decide +kernel
def fastCert10_1966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1966 : checkCertificateFast 10 1966 fastCert10_1966=true := by decide +kernel
def fastCert10_1967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1967 : checkCertificateFast 10 1967 fastCert10_1967=true := by decide +kernel
def fastCert10_1968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1968 : checkCertificateFast 10 1968 fastCert10_1968=true := by decide +kernel
def fastCert10_1969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1969 : checkCertificateFast 10 1969 fastCert10_1969=true := by decide +kernel
def fastCert10_1970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1970 : checkCertificateFast 10 1970 fastCert10_1970=true := by decide +kernel
def fastCert10_1971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1971 : checkCertificateFast 10 1971 fastCert10_1971=true := by decide +kernel
def fastCert10_1972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1972 : checkCertificateFast 10 1972 fastCert10_1972=true := by decide +kernel
def fastCert10_1973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1973 : checkCertificateFast 10 1973 fastCert10_1973=true := by decide +kernel
def fastCert10_1974 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1974 : checkCertificateFast 10 1974 fastCert10_1974=true := by decide +kernel
def fastCert10_1975 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1975 : checkCertificateFast 10 1975 fastCert10_1975=true := by decide +kernel
def fastCert10_1976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1976 : checkCertificateFast 10 1976 fastCert10_1976=true := by decide +kernel
def fastCert10_1977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1977 : checkCertificateFast 10 1977 fastCert10_1977=true := by decide +kernel
def fastCert10_1978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_1978 : checkCertificateFast 10 1978 fastCert10_1978=true := by decide +kernel
def fastCert10_1979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1979 : checkCertificateFast 10 1979 fastCert10_1979=true := by decide +kernel
def fastCert10_1980 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1980 : checkCertificateFast 10 1980 fastCert10_1980=true := by decide +kernel
def fastCert10_1981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_1981 : checkCertificateFast 10 1981 fastCert10_1981=true := by decide +kernel
def fastCert10_1982 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_1982 : checkCertificateFast 10 1982 fastCert10_1982=true := by decide +kernel
def fastCert10_1983 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_1983 : checkCertificateFast 10 1983 fastCert10_1983=true := by decide +kernel
def fastCert10_1984 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1984 : checkCertificateFast 10 1984 fastCert10_1984=true := by decide +kernel
def fastCert10_1985 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1985 : checkCertificateFast 10 1985 fastCert10_1985=true := by decide +kernel
def fastCert10_1986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1986 : checkCertificateFast 10 1986 fastCert10_1986=true := by decide +kernel
def fastCert10_1987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1987 : checkCertificateFast 10 1987 fastCert10_1987=true := by decide +kernel
def fastCert10_1988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1988 : checkCertificateFast 10 1988 fastCert10_1988=true := by decide +kernel
def fastCert10_1989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1989 : checkCertificateFast 10 1989 fastCert10_1989=true := by decide +kernel
def fastCert10_1990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1990 : checkCertificateFast 10 1990 fastCert10_1990=true := by decide +kernel
def fastCert10_1991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1991 : checkCertificateFast 10 1991 fastCert10_1991=true := by decide +kernel
def fastCert10_1992 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1992 : checkCertificateFast 10 1992 fastCert10_1992=true := by decide +kernel
def fastCert10_1993 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1993 : checkCertificateFast 10 1993 fastCert10_1993=true := by decide +kernel
def fastCert10_1994 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1994 : checkCertificateFast 10 1994 fastCert10_1994=true := by decide +kernel
def fastCert10_1995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1995 : checkCertificateFast 10 1995 fastCert10_1995=true := by decide +kernel
def fastCert10_1996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1996 : checkCertificateFast 10 1996 fastCert10_1996=true := by decide +kernel
def fastCert10_1997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_1997 : checkCertificateFast 10 1997 fastCert10_1997=true := by decide +kernel
def fastCert10_1998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1998 : checkCertificateFast 10 1998 fastCert10_1998=true := by decide +kernel
def fastCert10_1999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_1999 : checkCertificateFast 10 1999 fastCert10_1999=true := by decide +kernel
theorem aggregate_F10_001 : (checkCertificateFast 10 1000 fastCert10_1000=true) ∧ (checkCertificateFast 10 1001 fastCert10_1001=true) ∧ (checkCertificateFast 10 1002 fastCert10_1002=true) ∧ (checkCertificateFast 10 1003 fastCert10_1003=true) ∧ (checkCertificateFast 10 1004 fastCert10_1004=true) ∧ (checkCertificateFast 10 1005 fastCert10_1005=true) ∧ (checkCertificateFast 10 1006 fastCert10_1006=true) ∧ (checkCertificateFast 10 1007 fastCert10_1007=true) ∧ (checkCertificateFast 10 1008 fastCert10_1008=true) ∧ (checkCertificateFast 10 1009 fastCert10_1009=true) ∧ (checkCertificateFast 10 1010 fastCert10_1010=true) ∧ (checkCertificateFast 10 1011 fastCert10_1011=true) ∧ (checkCertificateFast 10 1012 fastCert10_1012=true) ∧ (checkCertificateFast 10 1013 fastCert10_1013=true) ∧ (checkCertificateFast 10 1014 fastCert10_1014=true) ∧ (checkCertificateFast 10 1015 fastCert10_1015=true) ∧ (checkCertificateFast 10 1016 fastCert10_1016=true) ∧ (checkCertificateFast 10 1017 fastCert10_1017=true) ∧ (checkCertificateFast 10 1018 fastCert10_1018=true) ∧ (checkCertificateFast 10 1019 fastCert10_1019=true) ∧ (checkCertificateFast 10 1020 fastCert10_1020=true) ∧ (checkCertificateFast 10 1021 fastCert10_1021=true) ∧ (checkCertificateFast 10 1022 fastCert10_1022=true) ∧ (checkCertificateFast 10 1023 fastCert10_1023=true) ∧ (checkCertificateFast 10 1024 fastCert10_1024=true) ∧ (checkCertificateFast 10 1025 fastCert10_1025=true) ∧ (checkCertificateFast 10 1026 fastCert10_1026=true) ∧ (checkCertificateFast 10 1027 fastCert10_1027=true) ∧ (checkCertificateFast 10 1028 fastCert10_1028=true) ∧ (checkCertificateFast 10 1029 fastCert10_1029=true) ∧ (checkCertificateFast 10 1030 fastCert10_1030=true) ∧ (checkCertificateFast 10 1031 fastCert10_1031=true) ∧ (checkCertificateFast 10 1032 fastCert10_1032=true) ∧ (checkCertificateFast 10 1033 fastCert10_1033=true) ∧ (checkCertificateFast 10 1034 fastCert10_1034=true) ∧ (checkCertificateFast 10 1035 fastCert10_1035=true) ∧ (checkCertificateFast 10 1036 fastCert10_1036=true) ∧ (checkCertificateFast 10 1037 fastCert10_1037=true) ∧ (checkCertificateFast 10 1038 fastCert10_1038=true) ∧ (checkCertificateFast 10 1039 fastCert10_1039=true) ∧ (checkCertificateFast 10 1040 fastCert10_1040=true) ∧ (checkCertificateFast 10 1041 fastCert10_1041=true) ∧ (checkCertificateFast 10 1042 fastCert10_1042=true) ∧ (checkCertificateFast 10 1043 fastCert10_1043=true) ∧ (checkCertificateFast 10 1044 fastCert10_1044=true) ∧ (checkCertificateFast 10 1045 fastCert10_1045=true) ∧ (checkCertificateFast 10 1046 fastCert10_1046=true) ∧ (checkCertificateFast 10 1047 fastCert10_1047=true) ∧ (checkCertificateFast 10 1048 fastCert10_1048=true) ∧ (checkCertificateFast 10 1049 fastCert10_1049=true) ∧ (checkCertificateFast 10 1050 fastCert10_1050=true) ∧ (checkCertificateFast 10 1051 fastCert10_1051=true) ∧ (checkCertificateFast 10 1052 fastCert10_1052=true) ∧ (checkCertificateFast 10 1053 fastCert10_1053=true) ∧ (checkCertificateFast 10 1054 fastCert10_1054=true) ∧ (checkCertificateFast 10 1055 fastCert10_1055=true) ∧ (checkCertificateFast 10 1056 fastCert10_1056=true) ∧ (checkCertificateFast 10 1057 fastCert10_1057=true) ∧ (checkCertificateFast 10 1058 fastCert10_1058=true) ∧ (checkCertificateFast 10 1059 fastCert10_1059=true) ∧ (checkCertificateFast 10 1060 fastCert10_1060=true) ∧ (checkCertificateFast 10 1061 fastCert10_1061=true) ∧ (checkCertificateFast 10 1062 fastCert10_1062=true) ∧ (checkCertificateFast 10 1063 fastCert10_1063=true) ∧ (checkCertificateFast 10 1064 fastCert10_1064=true) ∧ (checkCertificateFast 10 1065 fastCert10_1065=true) ∧ (checkCertificateFast 10 1066 fastCert10_1066=true) ∧ (checkCertificateFast 10 1067 fastCert10_1067=true) ∧ (checkCertificateFast 10 1068 fastCert10_1068=true) ∧ (checkCertificateFast 10 1069 fastCert10_1069=true) ∧ (checkCertificateFast 10 1070 fastCert10_1070=true) ∧ (checkCertificateFast 10 1071 fastCert10_1071=true) ∧ (checkCertificateFast 10 1072 fastCert10_1072=true) ∧ (checkCertificateFast 10 1073 fastCert10_1073=true) ∧ (checkCertificateFast 10 1074 fastCert10_1074=true) ∧ (checkCertificateFast 10 1075 fastCert10_1075=true) ∧ (checkCertificateFast 10 1076 fastCert10_1076=true) ∧ (checkCertificateFast 10 1077 fastCert10_1077=true) ∧ (checkCertificateFast 10 1078 fastCert10_1078=true) ∧ (checkCertificateFast 10 1079 fastCert10_1079=true) ∧ (checkCertificateFast 10 1080 fastCert10_1080=true) ∧ (checkCertificateFast 10 1081 fastCert10_1081=true) ∧ (checkCertificateFast 10 1082 fastCert10_1082=true) ∧ (checkCertificateFast 10 1083 fastCert10_1083=true) ∧ (checkCertificateFast 10 1084 fastCert10_1084=true) ∧ (checkCertificateFast 10 1085 fastCert10_1085=true) ∧ (checkCertificateFast 10 1086 fastCert10_1086=true) ∧ (checkCertificateFast 10 1087 fastCert10_1087=true) ∧ (checkCertificateFast 10 1088 fastCert10_1088=true) ∧ (checkCertificateFast 10 1089 fastCert10_1089=true) ∧ (checkCertificateFast 10 1090 fastCert10_1090=true) ∧ (checkCertificateFast 10 1091 fastCert10_1091=true) ∧ (checkCertificateFast 10 1092 fastCert10_1092=true) ∧ (checkCertificateFast 10 1093 fastCert10_1093=true) ∧ (checkCertificateFast 10 1094 fastCert10_1094=true) ∧ (checkCertificateFast 10 1095 fastCert10_1095=true) ∧ (checkCertificateFast 10 1096 fastCert10_1096=true) ∧ (checkCertificateFast 10 1097 fastCert10_1097=true) ∧ (checkCertificateFast 10 1098 fastCert10_1098=true) ∧ (checkCertificateFast 10 1099 fastCert10_1099=true) ∧ (checkCertificateFast 10 1100 fastCert10_1100=true) ∧ (checkCertificateFast 10 1101 fastCert10_1101=true) ∧ (checkCertificateFast 10 1102 fastCert10_1102=true) ∧ (checkCertificateFast 10 1103 fastCert10_1103=true) ∧ (checkCertificateFast 10 1104 fastCert10_1104=true) ∧ (checkCertificateFast 10 1105 fastCert10_1105=true) ∧ (checkCertificateFast 10 1106 fastCert10_1106=true) ∧ (checkCertificateFast 10 1107 fastCert10_1107=true) ∧ (checkCertificateFast 10 1108 fastCert10_1108=true) ∧ (checkCertificateFast 10 1109 fastCert10_1109=true) ∧ (checkCertificateFast 10 1110 fastCert10_1110=true) ∧ (checkCertificateFast 10 1111 fastCert10_1111=true) ∧ (checkCertificateFast 10 1112 fastCert10_1112=true) ∧ (checkCertificateFast 10 1113 fastCert10_1113=true) ∧ (checkCertificateFast 10 1114 fastCert10_1114=true) ∧ (checkCertificateFast 10 1115 fastCert10_1115=true) ∧ (checkCertificateFast 10 1116 fastCert10_1116=true) ∧ (checkCertificateFast 10 1117 fastCert10_1117=true) ∧ (checkCertificateFast 10 1118 fastCert10_1118=true) ∧ (checkCertificateFast 10 1119 fastCert10_1119=true) ∧ (checkCertificateFast 10 1120 fastCert10_1120=true) ∧ (checkCertificateFast 10 1121 fastCert10_1121=true) ∧ (checkCertificateFast 10 1122 fastCert10_1122=true) ∧ (checkCertificateFast 10 1123 fastCert10_1123=true) ∧ (checkCertificateFast 10 1124 fastCert10_1124=true) ∧ (checkCertificateFast 10 1125 fastCert10_1125=true) ∧ (checkCertificateFast 10 1126 fastCert10_1126=true) ∧ (checkCertificateFast 10 1127 fastCert10_1127=true) ∧ (checkCertificateFast 10 1128 fastCert10_1128=true) ∧ (checkCertificateFast 10 1129 fastCert10_1129=true) ∧ (checkCertificateFast 10 1130 fastCert10_1130=true) ∧ (checkCertificateFast 10 1131 fastCert10_1131=true) ∧ (checkCertificateFast 10 1132 fastCert10_1132=true) ∧ (checkCertificateFast 10 1133 fastCert10_1133=true) ∧ (checkCertificateFast 10 1134 fastCert10_1134=true) ∧ (checkCertificateFast 10 1135 fastCert10_1135=true) ∧ (checkCertificateFast 10 1136 fastCert10_1136=true) ∧ (checkCertificateFast 10 1137 fastCert10_1137=true) ∧ (checkCertificateFast 10 1138 fastCert10_1138=true) ∧ (checkCertificateFast 10 1139 fastCert10_1139=true) ∧ (checkCertificateFast 10 1140 fastCert10_1140=true) ∧ (checkCertificateFast 10 1141 fastCert10_1141=true) ∧ (checkCertificateFast 10 1142 fastCert10_1142=true) ∧ (checkCertificateFast 10 1143 fastCert10_1143=true) ∧ (checkCertificateFast 10 1144 fastCert10_1144=true) ∧ (checkCertificateFast 10 1145 fastCert10_1145=true) ∧ (checkCertificateFast 10 1146 fastCert10_1146=true) ∧ (checkCertificateFast 10 1147 fastCert10_1147=true) ∧ (checkCertificateFast 10 1148 fastCert10_1148=true) ∧ (checkCertificateFast 10 1149 fastCert10_1149=true) ∧ (checkCertificateFast 10 1150 fastCert10_1150=true) ∧ (checkCertificateFast 10 1151 fastCert10_1151=true) ∧ (checkCertificateFast 10 1152 fastCert10_1152=true) ∧ (checkCertificateFast 10 1153 fastCert10_1153=true) ∧ (checkCertificateFast 10 1154 fastCert10_1154=true) ∧ (checkCertificateFast 10 1155 fastCert10_1155=true) ∧ (checkCertificateFast 10 1156 fastCert10_1156=true) ∧ (checkCertificateFast 10 1157 fastCert10_1157=true) ∧ (checkCertificateFast 10 1158 fastCert10_1158=true) ∧ (checkCertificateFast 10 1159 fastCert10_1159=true) ∧ (checkCertificateFast 10 1160 fastCert10_1160=true) ∧ (checkCertificateFast 10 1161 fastCert10_1161=true) ∧ (checkCertificateFast 10 1162 fastCert10_1162=true) ∧ (checkCertificateFast 10 1163 fastCert10_1163=true) ∧ (checkCertificateFast 10 1164 fastCert10_1164=true) ∧ (checkCertificateFast 10 1165 fastCert10_1165=true) ∧ (checkCertificateFast 10 1166 fastCert10_1166=true) ∧ (checkCertificateFast 10 1167 fastCert10_1167=true) ∧ (checkCertificateFast 10 1168 fastCert10_1168=true) ∧ (checkCertificateFast 10 1169 fastCert10_1169=true) ∧ (checkCertificateFast 10 1170 fastCert10_1170=true) ∧ (checkCertificateFast 10 1171 fastCert10_1171=true) ∧ (checkCertificateFast 10 1172 fastCert10_1172=true) ∧ (checkCertificateFast 10 1173 fastCert10_1173=true) ∧ (checkCertificateFast 10 1174 fastCert10_1174=true) ∧ (checkCertificateFast 10 1175 fastCert10_1175=true) ∧ (checkCertificateFast 10 1176 fastCert10_1176=true) ∧ (checkCertificateFast 10 1177 fastCert10_1177=true) ∧ (checkCertificateFast 10 1178 fastCert10_1178=true) ∧ (checkCertificateFast 10 1179 fastCert10_1179=true) ∧ (checkCertificateFast 10 1180 fastCert10_1180=true) ∧ (checkCertificateFast 10 1181 fastCert10_1181=true) ∧ (checkCertificateFast 10 1182 fastCert10_1182=true) ∧ (checkCertificateFast 10 1183 fastCert10_1183=true) ∧ (checkCertificateFast 10 1184 fastCert10_1184=true) ∧ (checkCertificateFast 10 1185 fastCert10_1185=true) ∧ (checkCertificateFast 10 1186 fastCert10_1186=true) ∧ (checkCertificateFast 10 1187 fastCert10_1187=true) ∧ (checkCertificateFast 10 1188 fastCert10_1188=true) ∧ (checkCertificateFast 10 1189 fastCert10_1189=true) ∧ (checkCertificateFast 10 1190 fastCert10_1190=true) ∧ (checkCertificateFast 10 1191 fastCert10_1191=true) ∧ (checkCertificateFast 10 1192 fastCert10_1192=true) ∧ (checkCertificateFast 10 1193 fastCert10_1193=true) ∧ (checkCertificateFast 10 1194 fastCert10_1194=true) ∧ (checkCertificateFast 10 1195 fastCert10_1195=true) ∧ (checkCertificateFast 10 1196 fastCert10_1196=true) ∧ (checkCertificateFast 10 1197 fastCert10_1197=true) ∧ (checkCertificateFast 10 1198 fastCert10_1198=true) ∧ (checkCertificateFast 10 1199 fastCert10_1199=true) ∧ (checkCertificateFast 10 1200 fastCert10_1200=true) ∧ (checkCertificateFast 10 1201 fastCert10_1201=true) ∧ (checkCertificateFast 10 1202 fastCert10_1202=true) ∧ (checkCertificateFast 10 1203 fastCert10_1203=true) ∧ (checkCertificateFast 10 1204 fastCert10_1204=true) ∧ (checkCertificateFast 10 1205 fastCert10_1205=true) ∧ (checkCertificateFast 10 1206 fastCert10_1206=true) ∧ (checkCertificateFast 10 1207 fastCert10_1207=true) ∧ (checkCertificateFast 10 1208 fastCert10_1208=true) ∧ (checkCertificateFast 10 1209 fastCert10_1209=true) ∧ (checkCertificateFast 10 1210 fastCert10_1210=true) ∧ (checkCertificateFast 10 1211 fastCert10_1211=true) ∧ (checkCertificateFast 10 1212 fastCert10_1212=true) ∧ (checkCertificateFast 10 1213 fastCert10_1213=true) ∧ (checkCertificateFast 10 1214 fastCert10_1214=true) ∧ (checkCertificateFast 10 1215 fastCert10_1215=true) ∧ (checkCertificateFast 10 1216 fastCert10_1216=true) ∧ (checkCertificateFast 10 1217 fastCert10_1217=true) ∧ (checkCertificateFast 10 1218 fastCert10_1218=true) ∧ (checkCertificateFast 10 1219 fastCert10_1219=true) ∧ (checkCertificateFast 10 1220 fastCert10_1220=true) ∧ (checkCertificateFast 10 1221 fastCert10_1221=true) ∧ (checkCertificateFast 10 1222 fastCert10_1222=true) ∧ (checkCertificateFast 10 1223 fastCert10_1223=true) ∧ (checkCertificateFast 10 1224 fastCert10_1224=true) ∧ (checkCertificateFast 10 1225 fastCert10_1225=true) ∧ (checkCertificateFast 10 1226 fastCert10_1226=true) ∧ (checkCertificateFast 10 1227 fastCert10_1227=true) ∧ (checkCertificateFast 10 1228 fastCert10_1228=true) ∧ (checkCertificateFast 10 1229 fastCert10_1229=true) ∧ (checkCertificateFast 10 1230 fastCert10_1230=true) ∧ (checkCertificateFast 10 1231 fastCert10_1231=true) ∧ (checkCertificateFast 10 1232 fastCert10_1232=true) ∧ (checkCertificateFast 10 1233 fastCert10_1233=true) ∧ (checkCertificateFast 10 1234 fastCert10_1234=true) ∧ (checkCertificateFast 10 1235 fastCert10_1235=true) ∧ (checkCertificateFast 10 1236 fastCert10_1236=true) ∧ (checkCertificateFast 10 1237 fastCert10_1237=true) ∧ (checkCertificateFast 10 1238 fastCert10_1238=true) ∧ (checkCertificateFast 10 1239 fastCert10_1239=true) ∧ (checkCertificateFast 10 1240 fastCert10_1240=true) ∧ (checkCertificateFast 10 1241 fastCert10_1241=true) ∧ (checkCertificateFast 10 1242 fastCert10_1242=true) ∧ (checkCertificateFast 10 1243 fastCert10_1243=true) ∧ (checkCertificateFast 10 1244 fastCert10_1244=true) ∧ (checkCertificateFast 10 1245 fastCert10_1245=true) ∧ (checkCertificateFast 10 1246 fastCert10_1246=true) ∧ (checkCertificateFast 10 1247 fastCert10_1247=true) ∧ (checkCertificateFast 10 1248 fastCert10_1248=true) ∧ (checkCertificateFast 10 1249 fastCert10_1249=true) ∧ (checkCertificateFast 10 1250 fastCert10_1250=true) ∧ (checkCertificateFast 10 1251 fastCert10_1251=true) ∧ (checkCertificateFast 10 1252 fastCert10_1252=true) ∧ (checkCertificateFast 10 1253 fastCert10_1253=true) ∧ (checkCertificateFast 10 1254 fastCert10_1254=true) ∧ (checkCertificateFast 10 1255 fastCert10_1255=true) ∧ (checkCertificateFast 10 1256 fastCert10_1256=true) ∧ (checkCertificateFast 10 1257 fastCert10_1257=true) ∧ (checkCertificateFast 10 1258 fastCert10_1258=true) ∧ (checkCertificateFast 10 1259 fastCert10_1259=true) ∧ (checkCertificateFast 10 1260 fastCert10_1260=true) ∧ (checkCertificateFast 10 1261 fastCert10_1261=true) ∧ (checkCertificateFast 10 1262 fastCert10_1262=true) ∧ (checkCertificateFast 10 1263 fastCert10_1263=true) ∧ (checkCertificateFast 10 1264 fastCert10_1264=true) ∧ (checkCertificateFast 10 1265 fastCert10_1265=true) ∧ (checkCertificateFast 10 1266 fastCert10_1266=true) ∧ (checkCertificateFast 10 1267 fastCert10_1267=true) ∧ (checkCertificateFast 10 1268 fastCert10_1268=true) ∧ (checkCertificateFast 10 1269 fastCert10_1269=true) ∧ (checkCertificateFast 10 1270 fastCert10_1270=true) ∧ (checkCertificateFast 10 1271 fastCert10_1271=true) ∧ (checkCertificateFast 10 1272 fastCert10_1272=true) ∧ (checkCertificateFast 10 1273 fastCert10_1273=true) ∧ (checkCertificateFast 10 1274 fastCert10_1274=true) ∧ (checkCertificateFast 10 1275 fastCert10_1275=true) ∧ (checkCertificateFast 10 1276 fastCert10_1276=true) ∧ (checkCertificateFast 10 1277 fastCert10_1277=true) ∧ (checkCertificateFast 10 1278 fastCert10_1278=true) ∧ (checkCertificateFast 10 1279 fastCert10_1279=true) ∧ (checkCertificateFast 10 1280 fastCert10_1280=true) ∧ (checkCertificateFast 10 1281 fastCert10_1281=true) ∧ (checkCertificateFast 10 1282 fastCert10_1282=true) ∧ (checkCertificateFast 10 1283 fastCert10_1283=true) ∧ (checkCertificateFast 10 1284 fastCert10_1284=true) ∧ (checkCertificateFast 10 1285 fastCert10_1285=true) ∧ (checkCertificateFast 10 1286 fastCert10_1286=true) ∧ (checkCertificateFast 10 1287 fastCert10_1287=true) ∧ (checkCertificateFast 10 1288 fastCert10_1288=true) ∧ (checkCertificateFast 10 1289 fastCert10_1289=true) ∧ (checkCertificateFast 10 1290 fastCert10_1290=true) ∧ (checkCertificateFast 10 1291 fastCert10_1291=true) ∧ (checkCertificateFast 10 1292 fastCert10_1292=true) ∧ (checkCertificateFast 10 1293 fastCert10_1293=true) ∧ (checkCertificateFast 10 1294 fastCert10_1294=true) ∧ (checkCertificateFast 10 1295 fastCert10_1295=true) ∧ (checkCertificateFast 10 1296 fastCert10_1296=true) ∧ (checkCertificateFast 10 1297 fastCert10_1297=true) ∧ (checkCertificateFast 10 1298 fastCert10_1298=true) ∧ (checkCertificateFast 10 1299 fastCert10_1299=true) ∧ (checkCertificateFast 10 1300 fastCert10_1300=true) ∧ (checkCertificateFast 10 1301 fastCert10_1301=true) ∧ (checkCertificateFast 10 1302 fastCert10_1302=true) ∧ (checkCertificateFast 10 1303 fastCert10_1303=true) ∧ (checkCertificateFast 10 1304 fastCert10_1304=true) ∧ (checkCertificateFast 10 1305 fastCert10_1305=true) ∧ (checkCertificateFast 10 1306 fastCert10_1306=true) ∧ (checkCertificateFast 10 1307 fastCert10_1307=true) ∧ (checkCertificateFast 10 1308 fastCert10_1308=true) ∧ (checkCertificateFast 10 1309 fastCert10_1309=true) ∧ (checkCertificateFast 10 1310 fastCert10_1310=true) ∧ (checkCertificateFast 10 1311 fastCert10_1311=true) ∧ (checkCertificateFast 10 1312 fastCert10_1312=true) ∧ (checkCertificateFast 10 1313 fastCert10_1313=true) ∧ (checkCertificateFast 10 1314 fastCert10_1314=true) ∧ (checkCertificateFast 10 1315 fastCert10_1315=true) ∧ (checkCertificateFast 10 1316 fastCert10_1316=true) ∧ (checkCertificateFast 10 1317 fastCert10_1317=true) ∧ (checkCertificateFast 10 1318 fastCert10_1318=true) ∧ (checkCertificateFast 10 1319 fastCert10_1319=true) ∧ (checkCertificateFast 10 1320 fastCert10_1320=true) ∧ (checkCertificateFast 10 1321 fastCert10_1321=true) ∧ (checkCertificateFast 10 1322 fastCert10_1322=true) ∧ (checkCertificateFast 10 1323 fastCert10_1323=true) ∧ (checkCertificateFast 10 1324 fastCert10_1324=true) ∧ (checkCertificateFast 10 1325 fastCert10_1325=true) ∧ (checkCertificateFast 10 1326 fastCert10_1326=true) ∧ (checkCertificateFast 10 1327 fastCert10_1327=true) ∧ (checkCertificateFast 10 1328 fastCert10_1328=true) ∧ (checkCertificateFast 10 1329 fastCert10_1329=true) ∧ (checkCertificateFast 10 1330 fastCert10_1330=true) ∧ (checkCertificateFast 10 1331 fastCert10_1331=true) ∧ (checkCertificateFast 10 1332 fastCert10_1332=true) ∧ (checkCertificateFast 10 1333 fastCert10_1333=true) ∧ (checkCertificateFast 10 1334 fastCert10_1334=true) ∧ (checkCertificateFast 10 1335 fastCert10_1335=true) ∧ (checkCertificateFast 10 1336 fastCert10_1336=true) ∧ (checkCertificateFast 10 1337 fastCert10_1337=true) ∧ (checkCertificateFast 10 1338 fastCert10_1338=true) ∧ (checkCertificateFast 10 1339 fastCert10_1339=true) ∧ (checkCertificateFast 10 1340 fastCert10_1340=true) ∧ (checkCertificateFast 10 1341 fastCert10_1341=true) ∧ (checkCertificateFast 10 1342 fastCert10_1342=true) ∧ (checkCertificateFast 10 1343 fastCert10_1343=true) ∧ (checkCertificateFast 10 1344 fastCert10_1344=true) ∧ (checkCertificateFast 10 1345 fastCert10_1345=true) ∧ (checkCertificateFast 10 1346 fastCert10_1346=true) ∧ (checkCertificateFast 10 1347 fastCert10_1347=true) ∧ (checkCertificateFast 10 1348 fastCert10_1348=true) ∧ (checkCertificateFast 10 1349 fastCert10_1349=true) ∧ (checkCertificateFast 10 1350 fastCert10_1350=true) ∧ (checkCertificateFast 10 1351 fastCert10_1351=true) ∧ (checkCertificateFast 10 1352 fastCert10_1352=true) ∧ (checkCertificateFast 10 1353 fastCert10_1353=true) ∧ (checkCertificateFast 10 1354 fastCert10_1354=true) ∧ (checkCertificateFast 10 1355 fastCert10_1355=true) ∧ (checkCertificateFast 10 1356 fastCert10_1356=true) ∧ (checkCertificateFast 10 1357 fastCert10_1357=true) ∧ (checkCertificateFast 10 1358 fastCert10_1358=true) ∧ (checkCertificateFast 10 1359 fastCert10_1359=true) ∧ (checkCertificateFast 10 1360 fastCert10_1360=true) ∧ (checkCertificateFast 10 1361 fastCert10_1361=true) ∧ (checkCertificateFast 10 1362 fastCert10_1362=true) ∧ (checkCertificateFast 10 1363 fastCert10_1363=true) ∧ (checkCertificateFast 10 1364 fastCert10_1364=true) ∧ (checkCertificateFast 10 1365 fastCert10_1365=true) ∧ (checkCertificateFast 10 1366 fastCert10_1366=true) ∧ (checkCertificateFast 10 1367 fastCert10_1367=true) ∧ (checkCertificateFast 10 1368 fastCert10_1368=true) ∧ (checkCertificateFast 10 1369 fastCert10_1369=true) ∧ (checkCertificateFast 10 1370 fastCert10_1370=true) ∧ (checkCertificateFast 10 1371 fastCert10_1371=true) ∧ (checkCertificateFast 10 1372 fastCert10_1372=true) ∧ (checkCertificateFast 10 1373 fastCert10_1373=true) ∧ (checkCertificateFast 10 1374 fastCert10_1374=true) ∧ (checkCertificateFast 10 1375 fastCert10_1375=true) ∧ (checkCertificateFast 10 1376 fastCert10_1376=true) ∧ (checkCertificateFast 10 1377 fastCert10_1377=true) ∧ (checkCertificateFast 10 1378 fastCert10_1378=true) ∧ (checkCertificateFast 10 1379 fastCert10_1379=true) ∧ (checkCertificateFast 10 1380 fastCert10_1380=true) ∧ (checkCertificateFast 10 1381 fastCert10_1381=true) ∧ (checkCertificateFast 10 1382 fastCert10_1382=true) ∧ (checkCertificateFast 10 1383 fastCert10_1383=true) ∧ (checkCertificateFast 10 1384 fastCert10_1384=true) ∧ (checkCertificateFast 10 1385 fastCert10_1385=true) ∧ (checkCertificateFast 10 1386 fastCert10_1386=true) ∧ (checkCertificateFast 10 1387 fastCert10_1387=true) ∧ (checkCertificateFast 10 1388 fastCert10_1388=true) ∧ (checkCertificateFast 10 1389 fastCert10_1389=true) ∧ (checkCertificateFast 10 1390 fastCert10_1390=true) ∧ (checkCertificateFast 10 1391 fastCert10_1391=true) ∧ (checkCertificateFast 10 1392 fastCert10_1392=true) ∧ (checkCertificateFast 10 1393 fastCert10_1393=true) ∧ (checkCertificateFast 10 1394 fastCert10_1394=true) ∧ (checkCertificateFast 10 1395 fastCert10_1395=true) ∧ (checkCertificateFast 10 1396 fastCert10_1396=true) ∧ (checkCertificateFast 10 1397 fastCert10_1397=true) ∧ (checkCertificateFast 10 1398 fastCert10_1398=true) ∧ (checkCertificateFast 10 1399 fastCert10_1399=true) ∧ (checkCertificateFast 10 1400 fastCert10_1400=true) ∧ (checkCertificateFast 10 1401 fastCert10_1401=true) ∧ (checkCertificateFast 10 1402 fastCert10_1402=true) ∧ (checkCertificateFast 10 1403 fastCert10_1403=true) ∧ (checkCertificateFast 10 1404 fastCert10_1404=true) ∧ (checkCertificateFast 10 1405 fastCert10_1405=true) ∧ (checkCertificateFast 10 1406 fastCert10_1406=true) ∧ (checkCertificateFast 10 1407 fastCert10_1407=true) ∧ (checkCertificateFast 10 1408 fastCert10_1408=true) ∧ (checkCertificateFast 10 1409 fastCert10_1409=true) ∧ (checkCertificateFast 10 1410 fastCert10_1410=true) ∧ (checkCertificateFast 10 1411 fastCert10_1411=true) ∧ (checkCertificateFast 10 1412 fastCert10_1412=true) ∧ (checkCertificateFast 10 1413 fastCert10_1413=true) ∧ (checkCertificateFast 10 1414 fastCert10_1414=true) ∧ (checkCertificateFast 10 1415 fastCert10_1415=true) ∧ (checkCertificateFast 10 1416 fastCert10_1416=true) ∧ (checkCertificateFast 10 1417 fastCert10_1417=true) ∧ (checkCertificateFast 10 1418 fastCert10_1418=true) ∧ (checkCertificateFast 10 1419 fastCert10_1419=true) ∧ (checkCertificateFast 10 1420 fastCert10_1420=true) ∧ (checkCertificateFast 10 1421 fastCert10_1421=true) ∧ (checkCertificateFast 10 1422 fastCert10_1422=true) ∧ (checkCertificateFast 10 1423 fastCert10_1423=true) ∧ (checkCertificateFast 10 1424 fastCert10_1424=true) ∧ (checkCertificateFast 10 1425 fastCert10_1425=true) ∧ (checkCertificateFast 10 1426 fastCert10_1426=true) ∧ (checkCertificateFast 10 1427 fastCert10_1427=true) ∧ (checkCertificateFast 10 1428 fastCert10_1428=true) ∧ (checkCertificateFast 10 1429 fastCert10_1429=true) ∧ (checkCertificateFast 10 1430 fastCert10_1430=true) ∧ (checkCertificateFast 10 1431 fastCert10_1431=true) ∧ (checkCertificateFast 10 1432 fastCert10_1432=true) ∧ (checkCertificateFast 10 1433 fastCert10_1433=true) ∧ (checkCertificateFast 10 1434 fastCert10_1434=true) ∧ (checkCertificateFast 10 1435 fastCert10_1435=true) ∧ (checkCertificateFast 10 1436 fastCert10_1436=true) ∧ (checkCertificateFast 10 1437 fastCert10_1437=true) ∧ (checkCertificateFast 10 1438 fastCert10_1438=true) ∧ (checkCertificateFast 10 1439 fastCert10_1439=true) ∧ (checkCertificateFast 10 1440 fastCert10_1440=true) ∧ (checkCertificateFast 10 1441 fastCert10_1441=true) ∧ (checkCertificateFast 10 1442 fastCert10_1442=true) ∧ (checkCertificateFast 10 1443 fastCert10_1443=true) ∧ (checkCertificateFast 10 1444 fastCert10_1444=true) ∧ (checkCertificateFast 10 1445 fastCert10_1445=true) ∧ (checkCertificateFast 10 1446 fastCert10_1446=true) ∧ (checkCertificateFast 10 1447 fastCert10_1447=true) ∧ (checkCertificateFast 10 1448 fastCert10_1448=true) ∧ (checkCertificateFast 10 1449 fastCert10_1449=true) ∧ (checkCertificateFast 10 1450 fastCert10_1450=true) ∧ (checkCertificateFast 10 1451 fastCert10_1451=true) ∧ (checkCertificateFast 10 1452 fastCert10_1452=true) ∧ (checkCertificateFast 10 1453 fastCert10_1453=true) ∧ (checkCertificateFast 10 1454 fastCert10_1454=true) ∧ (checkCertificateFast 10 1455 fastCert10_1455=true) ∧ (checkCertificateFast 10 1456 fastCert10_1456=true) ∧ (checkCertificateFast 10 1457 fastCert10_1457=true) ∧ (checkCertificateFast 10 1458 fastCert10_1458=true) ∧ (checkCertificateFast 10 1459 fastCert10_1459=true) ∧ (checkCertificateFast 10 1460 fastCert10_1460=true) ∧ (checkCertificateFast 10 1461 fastCert10_1461=true) ∧ (checkCertificateFast 10 1462 fastCert10_1462=true) ∧ (checkCertificateFast 10 1463 fastCert10_1463=true) ∧ (checkCertificateFast 10 1464 fastCert10_1464=true) ∧ (checkCertificateFast 10 1465 fastCert10_1465=true) ∧ (checkCertificateFast 10 1466 fastCert10_1466=true) ∧ (checkCertificateFast 10 1467 fastCert10_1467=true) ∧ (checkCertificateFast 10 1468 fastCert10_1468=true) ∧ (checkCertificateFast 10 1469 fastCert10_1469=true) ∧ (checkCertificateFast 10 1470 fastCert10_1470=true) ∧ (checkCertificateFast 10 1471 fastCert10_1471=true) ∧ (checkCertificateFast 10 1472 fastCert10_1472=true) ∧ (checkCertificateFast 10 1473 fastCert10_1473=true) ∧ (checkCertificateFast 10 1474 fastCert10_1474=true) ∧ (checkCertificateFast 10 1475 fastCert10_1475=true) ∧ (checkCertificateFast 10 1476 fastCert10_1476=true) ∧ (checkCertificateFast 10 1477 fastCert10_1477=true) ∧ (checkCertificateFast 10 1478 fastCert10_1478=true) ∧ (checkCertificateFast 10 1479 fastCert10_1479=true) ∧ (checkCertificateFast 10 1480 fastCert10_1480=true) ∧ (checkCertificateFast 10 1481 fastCert10_1481=true) ∧ (checkCertificateFast 10 1482 fastCert10_1482=true) ∧ (checkCertificateFast 10 1483 fastCert10_1483=true) ∧ (checkCertificateFast 10 1484 fastCert10_1484=true) ∧ (checkCertificateFast 10 1485 fastCert10_1485=true) ∧ (checkCertificateFast 10 1486 fastCert10_1486=true) ∧ (checkCertificateFast 10 1487 fastCert10_1487=true) ∧ (checkCertificateFast 10 1488 fastCert10_1488=true) ∧ (checkCertificateFast 10 1489 fastCert10_1489=true) ∧ (checkCertificateFast 10 1490 fastCert10_1490=true) ∧ (checkCertificateFast 10 1491 fastCert10_1491=true) ∧ (checkCertificateFast 10 1492 fastCert10_1492=true) ∧ (checkCertificateFast 10 1493 fastCert10_1493=true) ∧ (checkCertificateFast 10 1494 fastCert10_1494=true) ∧ (checkCertificateFast 10 1495 fastCert10_1495=true) ∧ (checkCertificateFast 10 1496 fastCert10_1496=true) ∧ (checkCertificateFast 10 1497 fastCert10_1497=true) ∧ (checkCertificateFast 10 1498 fastCert10_1498=true) ∧ (checkCertificateFast 10 1499 fastCert10_1499=true) ∧ (checkCertificateFast 10 1500 fastCert10_1500=true) ∧ (checkCertificateFast 10 1501 fastCert10_1501=true) ∧ (checkCertificateFast 10 1502 fastCert10_1502=true) ∧ (checkCertificateFast 10 1503 fastCert10_1503=true) ∧ (checkCertificateFast 10 1504 fastCert10_1504=true) ∧ (checkCertificateFast 10 1505 fastCert10_1505=true) ∧ (checkCertificateFast 10 1506 fastCert10_1506=true) ∧ (checkCertificateFast 10 1507 fastCert10_1507=true) ∧ (checkCertificateFast 10 1508 fastCert10_1508=true) ∧ (checkCertificateFast 10 1509 fastCert10_1509=true) ∧ (checkCertificateFast 10 1510 fastCert10_1510=true) ∧ (checkCertificateFast 10 1511 fastCert10_1511=true) ∧ (checkCertificateFast 10 1512 fastCert10_1512=true) ∧ (checkCertificateFast 10 1513 fastCert10_1513=true) ∧ (checkCertificateFast 10 1514 fastCert10_1514=true) ∧ (checkCertificateFast 10 1515 fastCert10_1515=true) ∧ (checkCertificateFast 10 1516 fastCert10_1516=true) ∧ (checkCertificateFast 10 1517 fastCert10_1517=true) ∧ (checkCertificateFast 10 1518 fastCert10_1518=true) ∧ (checkCertificateFast 10 1519 fastCert10_1519=true) ∧ (checkCertificateFast 10 1520 fastCert10_1520=true) ∧ (checkCertificateFast 10 1521 fastCert10_1521=true) ∧ (checkCertificateFast 10 1522 fastCert10_1522=true) ∧ (checkCertificateFast 10 1523 fastCert10_1523=true) ∧ (checkCertificateFast 10 1524 fastCert10_1524=true) ∧ (checkCertificateFast 10 1525 fastCert10_1525=true) ∧ (checkCertificateFast 10 1526 fastCert10_1526=true) ∧ (checkCertificateFast 10 1527 fastCert10_1527=true) ∧ (checkCertificateFast 10 1528 fastCert10_1528=true) ∧ (checkCertificateFast 10 1529 fastCert10_1529=true) ∧ (checkCertificateFast 10 1530 fastCert10_1530=true) ∧ (checkCertificateFast 10 1531 fastCert10_1531=true) ∧ (checkCertificateFast 10 1532 fastCert10_1532=true) ∧ (checkCertificateFast 10 1533 fastCert10_1533=true) ∧ (checkCertificateFast 10 1534 fastCert10_1534=true) ∧ (checkCertificateFast 10 1535 fastCert10_1535=true) ∧ (checkCertificateFast 10 1536 fastCert10_1536=true) ∧ (checkCertificateFast 10 1537 fastCert10_1537=true) ∧ (checkCertificateFast 10 1538 fastCert10_1538=true) ∧ (checkCertificateFast 10 1539 fastCert10_1539=true) ∧ (checkCertificateFast 10 1540 fastCert10_1540=true) ∧ (checkCertificateFast 10 1541 fastCert10_1541=true) ∧ (checkCertificateFast 10 1542 fastCert10_1542=true) ∧ (checkCertificateFast 10 1543 fastCert10_1543=true) ∧ (checkCertificateFast 10 1544 fastCert10_1544=true) ∧ (checkCertificateFast 10 1545 fastCert10_1545=true) ∧ (checkCertificateFast 10 1546 fastCert10_1546=true) ∧ (checkCertificateFast 10 1547 fastCert10_1547=true) ∧ (checkCertificateFast 10 1548 fastCert10_1548=true) ∧ (checkCertificateFast 10 1549 fastCert10_1549=true) ∧ (checkCertificateFast 10 1550 fastCert10_1550=true) ∧ (checkCertificateFast 10 1551 fastCert10_1551=true) ∧ (checkCertificateFast 10 1552 fastCert10_1552=true) ∧ (checkCertificateFast 10 1553 fastCert10_1553=true) ∧ (checkCertificateFast 10 1554 fastCert10_1554=true) ∧ (checkCertificateFast 10 1555 fastCert10_1555=true) ∧ (checkCertificateFast 10 1556 fastCert10_1556=true) ∧ (checkCertificateFast 10 1557 fastCert10_1557=true) ∧ (checkCertificateFast 10 1558 fastCert10_1558=true) ∧ (checkCertificateFast 10 1559 fastCert10_1559=true) ∧ (checkCertificateFast 10 1560 fastCert10_1560=true) ∧ (checkCertificateFast 10 1561 fastCert10_1561=true) ∧ (checkCertificateFast 10 1562 fastCert10_1562=true) ∧ (checkCertificateFast 10 1563 fastCert10_1563=true) ∧ (checkCertificateFast 10 1564 fastCert10_1564=true) ∧ (checkCertificateFast 10 1565 fastCert10_1565=true) ∧ (checkCertificateFast 10 1566 fastCert10_1566=true) ∧ (checkCertificateFast 10 1567 fastCert10_1567=true) ∧ (checkCertificateFast 10 1568 fastCert10_1568=true) ∧ (checkCertificateFast 10 1569 fastCert10_1569=true) ∧ (checkCertificateFast 10 1570 fastCert10_1570=true) ∧ (checkCertificateFast 10 1571 fastCert10_1571=true) ∧ (checkCertificateFast 10 1572 fastCert10_1572=true) ∧ (checkCertificateFast 10 1573 fastCert10_1573=true) ∧ (checkCertificateFast 10 1574 fastCert10_1574=true) ∧ (checkCertificateFast 10 1575 fastCert10_1575=true) ∧ (checkCertificateFast 10 1576 fastCert10_1576=true) ∧ (checkCertificateFast 10 1577 fastCert10_1577=true) ∧ (checkCertificateFast 10 1578 fastCert10_1578=true) ∧ (checkCertificateFast 10 1579 fastCert10_1579=true) ∧ (checkCertificateFast 10 1580 fastCert10_1580=true) ∧ (checkCertificateFast 10 1581 fastCert10_1581=true) ∧ (checkCertificateFast 10 1582 fastCert10_1582=true) ∧ (checkCertificateFast 10 1583 fastCert10_1583=true) ∧ (checkCertificateFast 10 1584 fastCert10_1584=true) ∧ (checkCertificateFast 10 1585 fastCert10_1585=true) ∧ (checkCertificateFast 10 1586 fastCert10_1586=true) ∧ (checkCertificateFast 10 1587 fastCert10_1587=true) ∧ (checkCertificateFast 10 1588 fastCert10_1588=true) ∧ (checkCertificateFast 10 1589 fastCert10_1589=true) ∧ (checkCertificateFast 10 1590 fastCert10_1590=true) ∧ (checkCertificateFast 10 1591 fastCert10_1591=true) ∧ (checkCertificateFast 10 1592 fastCert10_1592=true) ∧ (checkCertificateFast 10 1593 fastCert10_1593=true) ∧ (checkCertificateFast 10 1594 fastCert10_1594=true) ∧ (checkCertificateFast 10 1595 fastCert10_1595=true) ∧ (checkCertificateFast 10 1596 fastCert10_1596=true) ∧ (checkCertificateFast 10 1597 fastCert10_1597=true) ∧ (checkCertificateFast 10 1598 fastCert10_1598=true) ∧ (checkCertificateFast 10 1599 fastCert10_1599=true) ∧ (checkCertificateFast 10 1600 fastCert10_1600=true) ∧ (checkCertificateFast 10 1601 fastCert10_1601=true) ∧ (checkCertificateFast 10 1602 fastCert10_1602=true) ∧ (checkCertificateFast 10 1603 fastCert10_1603=true) ∧ (checkCertificateFast 10 1604 fastCert10_1604=true) ∧ (checkCertificateFast 10 1605 fastCert10_1605=true) ∧ (checkCertificateFast 10 1606 fastCert10_1606=true) ∧ (checkCertificateFast 10 1607 fastCert10_1607=true) ∧ (checkCertificateFast 10 1608 fastCert10_1608=true) ∧ (checkCertificateFast 10 1609 fastCert10_1609=true) ∧ (checkCertificateFast 10 1610 fastCert10_1610=true) ∧ (checkCertificateFast 10 1611 fastCert10_1611=true) ∧ (checkCertificateFast 10 1612 fastCert10_1612=true) ∧ (checkCertificateFast 10 1613 fastCert10_1613=true) ∧ (checkCertificateFast 10 1614 fastCert10_1614=true) ∧ (checkCertificateFast 10 1615 fastCert10_1615=true) ∧ (checkCertificateFast 10 1616 fastCert10_1616=true) ∧ (checkCertificateFast 10 1617 fastCert10_1617=true) ∧ (checkCertificateFast 10 1618 fastCert10_1618=true) ∧ (checkCertificateFast 10 1619 fastCert10_1619=true) ∧ (checkCertificateFast 10 1620 fastCert10_1620=true) ∧ (checkCertificateFast 10 1621 fastCert10_1621=true) ∧ (checkCertificateFast 10 1622 fastCert10_1622=true) ∧ (checkCertificateFast 10 1623 fastCert10_1623=true) ∧ (checkCertificateFast 10 1624 fastCert10_1624=true) ∧ (checkCertificateFast 10 1625 fastCert10_1625=true) ∧ (checkCertificateFast 10 1626 fastCert10_1626=true) ∧ (checkCertificateFast 10 1627 fastCert10_1627=true) ∧ (checkCertificateFast 10 1628 fastCert10_1628=true) ∧ (checkCertificateFast 10 1629 fastCert10_1629=true) ∧ (checkCertificateFast 10 1630 fastCert10_1630=true) ∧ (checkCertificateFast 10 1631 fastCert10_1631=true) ∧ (checkCertificateFast 10 1632 fastCert10_1632=true) ∧ (checkCertificateFast 10 1633 fastCert10_1633=true) ∧ (checkCertificateFast 10 1634 fastCert10_1634=true) ∧ (checkCertificateFast 10 1635 fastCert10_1635=true) ∧ (checkCertificateFast 10 1636 fastCert10_1636=true) ∧ (checkCertificateFast 10 1637 fastCert10_1637=true) ∧ (checkCertificateFast 10 1638 fastCert10_1638=true) ∧ (checkCertificateFast 10 1639 fastCert10_1639=true) ∧ (checkCertificateFast 10 1640 fastCert10_1640=true) ∧ (checkCertificateFast 10 1641 fastCert10_1641=true) ∧ (checkCertificateFast 10 1642 fastCert10_1642=true) ∧ (checkCertificateFast 10 1643 fastCert10_1643=true) ∧ (checkCertificateFast 10 1644 fastCert10_1644=true) ∧ (checkCertificateFast 10 1645 fastCert10_1645=true) ∧ (checkCertificateFast 10 1646 fastCert10_1646=true) ∧ (checkCertificateFast 10 1647 fastCert10_1647=true) ∧ (checkCertificateFast 10 1648 fastCert10_1648=true) ∧ (checkCertificateFast 10 1649 fastCert10_1649=true) ∧ (checkCertificateFast 10 1650 fastCert10_1650=true) ∧ (checkCertificateFast 10 1651 fastCert10_1651=true) ∧ (checkCertificateFast 10 1652 fastCert10_1652=true) ∧ (checkCertificateFast 10 1653 fastCert10_1653=true) ∧ (checkCertificateFast 10 1654 fastCert10_1654=true) ∧ (checkCertificateFast 10 1655 fastCert10_1655=true) ∧ (checkCertificateFast 10 1656 fastCert10_1656=true) ∧ (checkCertificateFast 10 1657 fastCert10_1657=true) ∧ (checkCertificateFast 10 1658 fastCert10_1658=true) ∧ (checkCertificateFast 10 1659 fastCert10_1659=true) ∧ (checkCertificateFast 10 1660 fastCert10_1660=true) ∧ (checkCertificateFast 10 1661 fastCert10_1661=true) ∧ (checkCertificateFast 10 1662 fastCert10_1662=true) ∧ (checkCertificateFast 10 1663 fastCert10_1663=true) ∧ (checkCertificateFast 10 1664 fastCert10_1664=true) ∧ (checkCertificateFast 10 1665 fastCert10_1665=true) ∧ (checkCertificateFast 10 1666 fastCert10_1666=true) ∧ (checkCertificateFast 10 1667 fastCert10_1667=true) ∧ (checkCertificateFast 10 1668 fastCert10_1668=true) ∧ (checkCertificateFast 10 1669 fastCert10_1669=true) ∧ (checkCertificateFast 10 1670 fastCert10_1670=true) ∧ (checkCertificateFast 10 1671 fastCert10_1671=true) ∧ (checkCertificateFast 10 1672 fastCert10_1672=true) ∧ (checkCertificateFast 10 1673 fastCert10_1673=true) ∧ (checkCertificateFast 10 1674 fastCert10_1674=true) ∧ (checkCertificateFast 10 1675 fastCert10_1675=true) ∧ (checkCertificateFast 10 1676 fastCert10_1676=true) ∧ (checkCertificateFast 10 1677 fastCert10_1677=true) ∧ (checkCertificateFast 10 1678 fastCert10_1678=true) ∧ (checkCertificateFast 10 1679 fastCert10_1679=true) ∧ (checkCertificateFast 10 1680 fastCert10_1680=true) ∧ (checkCertificateFast 10 1681 fastCert10_1681=true) ∧ (checkCertificateFast 10 1682 fastCert10_1682=true) ∧ (checkCertificateFast 10 1683 fastCert10_1683=true) ∧ (checkCertificateFast 10 1684 fastCert10_1684=true) ∧ (checkCertificateFast 10 1685 fastCert10_1685=true) ∧ (checkCertificateFast 10 1686 fastCert10_1686=true) ∧ (checkCertificateFast 10 1687 fastCert10_1687=true) ∧ (checkCertificateFast 10 1688 fastCert10_1688=true) ∧ (checkCertificateFast 10 1689 fastCert10_1689=true) ∧ (checkCertificateFast 10 1690 fastCert10_1690=true) ∧ (checkCertificateFast 10 1691 fastCert10_1691=true) ∧ (checkCertificateFast 10 1692 fastCert10_1692=true) ∧ (checkCertificateFast 10 1693 fastCert10_1693=true) ∧ (checkCertificateFast 10 1694 fastCert10_1694=true) ∧ (checkCertificateFast 10 1695 fastCert10_1695=true) ∧ (checkCertificateFast 10 1696 fastCert10_1696=true) ∧ (checkCertificateFast 10 1697 fastCert10_1697=true) ∧ (checkCertificateFast 10 1698 fastCert10_1698=true) ∧ (checkCertificateFast 10 1699 fastCert10_1699=true) ∧ (checkCertificateFast 10 1700 fastCert10_1700=true) ∧ (checkCertificateFast 10 1701 fastCert10_1701=true) ∧ (checkCertificateFast 10 1702 fastCert10_1702=true) ∧ (checkCertificateFast 10 1703 fastCert10_1703=true) ∧ (checkCertificateFast 10 1704 fastCert10_1704=true) ∧ (checkCertificateFast 10 1705 fastCert10_1705=true) ∧ (checkCertificateFast 10 1706 fastCert10_1706=true) ∧ (checkCertificateFast 10 1707 fastCert10_1707=true) ∧ (checkCertificateFast 10 1708 fastCert10_1708=true) ∧ (checkCertificateFast 10 1709 fastCert10_1709=true) ∧ (checkCertificateFast 10 1710 fastCert10_1710=true) ∧ (checkCertificateFast 10 1711 fastCert10_1711=true) ∧ (checkCertificateFast 10 1712 fastCert10_1712=true) ∧ (checkCertificateFast 10 1713 fastCert10_1713=true) ∧ (checkCertificateFast 10 1714 fastCert10_1714=true) ∧ (checkCertificateFast 10 1715 fastCert10_1715=true) ∧ (checkCertificateFast 10 1716 fastCert10_1716=true) ∧ (checkCertificateFast 10 1717 fastCert10_1717=true) ∧ (checkCertificateFast 10 1718 fastCert10_1718=true) ∧ (checkCertificateFast 10 1719 fastCert10_1719=true) ∧ (checkCertificateFast 10 1720 fastCert10_1720=true) ∧ (checkCertificateFast 10 1721 fastCert10_1721=true) ∧ (checkCertificateFast 10 1722 fastCert10_1722=true) ∧ (checkCertificateFast 10 1723 fastCert10_1723=true) ∧ (checkCertificateFast 10 1724 fastCert10_1724=true) ∧ (checkCertificateFast 10 1725 fastCert10_1725=true) ∧ (checkCertificateFast 10 1726 fastCert10_1726=true) ∧ (checkCertificateFast 10 1727 fastCert10_1727=true) ∧ (checkCertificateFast 10 1728 fastCert10_1728=true) ∧ (checkCertificateFast 10 1729 fastCert10_1729=true) ∧ (checkCertificateFast 10 1730 fastCert10_1730=true) ∧ (checkCertificateFast 10 1731 fastCert10_1731=true) ∧ (checkCertificateFast 10 1732 fastCert10_1732=true) ∧ (checkCertificateFast 10 1733 fastCert10_1733=true) ∧ (checkCertificateFast 10 1734 fastCert10_1734=true) ∧ (checkCertificateFast 10 1735 fastCert10_1735=true) ∧ (checkCertificateFast 10 1736 fastCert10_1736=true) ∧ (checkCertificateFast 10 1737 fastCert10_1737=true) ∧ (checkCertificateFast 10 1738 fastCert10_1738=true) ∧ (checkCertificateFast 10 1739 fastCert10_1739=true) ∧ (checkCertificateFast 10 1740 fastCert10_1740=true) ∧ (checkCertificateFast 10 1741 fastCert10_1741=true) ∧ (checkCertificateFast 10 1742 fastCert10_1742=true) ∧ (checkCertificateFast 10 1743 fastCert10_1743=true) ∧ (checkCertificateFast 10 1744 fastCert10_1744=true) ∧ (checkCertificateFast 10 1745 fastCert10_1745=true) ∧ (checkCertificateFast 10 1746 fastCert10_1746=true) ∧ (checkCertificateFast 10 1747 fastCert10_1747=true) ∧ (checkCertificateFast 10 1748 fastCert10_1748=true) ∧ (checkCertificateFast 10 1749 fastCert10_1749=true) ∧ (checkCertificateFast 10 1750 fastCert10_1750=true) ∧ (checkCertificateFast 10 1751 fastCert10_1751=true) ∧ (checkCertificateFast 10 1752 fastCert10_1752=true) ∧ (checkCertificateFast 10 1753 fastCert10_1753=true) ∧ (checkCertificateFast 10 1754 fastCert10_1754=true) ∧ (checkCertificateFast 10 1755 fastCert10_1755=true) ∧ (checkCertificateFast 10 1756 fastCert10_1756=true) ∧ (checkCertificateFast 10 1757 fastCert10_1757=true) ∧ (checkCertificateFast 10 1758 fastCert10_1758=true) ∧ (checkCertificateFast 10 1759 fastCert10_1759=true) ∧ (checkCertificateFast 10 1760 fastCert10_1760=true) ∧ (checkCertificateFast 10 1761 fastCert10_1761=true) ∧ (checkCertificateFast 10 1762 fastCert10_1762=true) ∧ (checkCertificateFast 10 1763 fastCert10_1763=true) ∧ (checkCertificateFast 10 1764 fastCert10_1764=true) ∧ (checkCertificateFast 10 1765 fastCert10_1765=true) ∧ (checkCertificateFast 10 1766 fastCert10_1766=true) ∧ (checkCertificateFast 10 1767 fastCert10_1767=true) ∧ (checkCertificateFast 10 1768 fastCert10_1768=true) ∧ (checkCertificateFast 10 1769 fastCert10_1769=true) ∧ (checkCertificateFast 10 1770 fastCert10_1770=true) ∧ (checkCertificateFast 10 1771 fastCert10_1771=true) ∧ (checkCertificateFast 10 1772 fastCert10_1772=true) ∧ (checkCertificateFast 10 1773 fastCert10_1773=true) ∧ (checkCertificateFast 10 1774 fastCert10_1774=true) ∧ (checkCertificateFast 10 1775 fastCert10_1775=true) ∧ (checkCertificateFast 10 1776 fastCert10_1776=true) ∧ (checkCertificateFast 10 1777 fastCert10_1777=true) ∧ (checkCertificateFast 10 1778 fastCert10_1778=true) ∧ (checkCertificateFast 10 1779 fastCert10_1779=true) ∧ (checkCertificateFast 10 1780 fastCert10_1780=true) ∧ (checkCertificateFast 10 1781 fastCert10_1781=true) ∧ (checkCertificateFast 10 1782 fastCert10_1782=true) ∧ (checkCertificateFast 10 1783 fastCert10_1783=true) ∧ (checkCertificateFast 10 1784 fastCert10_1784=true) ∧ (checkCertificateFast 10 1785 fastCert10_1785=true) ∧ (checkCertificateFast 10 1786 fastCert10_1786=true) ∧ (checkCertificateFast 10 1787 fastCert10_1787=true) ∧ (checkCertificateFast 10 1788 fastCert10_1788=true) ∧ (checkCertificateFast 10 1789 fastCert10_1789=true) ∧ (checkCertificateFast 10 1790 fastCert10_1790=true) ∧ (checkCertificateFast 10 1791 fastCert10_1791=true) ∧ (checkCertificateFast 10 1792 fastCert10_1792=true) ∧ (checkCertificateFast 10 1793 fastCert10_1793=true) ∧ (checkCertificateFast 10 1794 fastCert10_1794=true) ∧ (checkCertificateFast 10 1795 fastCert10_1795=true) ∧ (checkCertificateFast 10 1796 fastCert10_1796=true) ∧ (checkCertificateFast 10 1797 fastCert10_1797=true) ∧ (checkCertificateFast 10 1798 fastCert10_1798=true) ∧ (checkCertificateFast 10 1799 fastCert10_1799=true) ∧ (checkCertificateFast 10 1800 fastCert10_1800=true) ∧ (checkCertificateFast 10 1801 fastCert10_1801=true) ∧ (checkCertificateFast 10 1802 fastCert10_1802=true) ∧ (checkCertificateFast 10 1803 fastCert10_1803=true) ∧ (checkCertificateFast 10 1804 fastCert10_1804=true) ∧ (checkCertificateFast 10 1805 fastCert10_1805=true) ∧ (checkCertificateFast 10 1806 fastCert10_1806=true) ∧ (checkCertificateFast 10 1807 fastCert10_1807=true) ∧ (checkCertificateFast 10 1808 fastCert10_1808=true) ∧ (checkCertificateFast 10 1809 fastCert10_1809=true) ∧ (checkCertificateFast 10 1810 fastCert10_1810=true) ∧ (checkCertificateFast 10 1811 fastCert10_1811=true) ∧ (checkCertificateFast 10 1812 fastCert10_1812=true) ∧ (checkCertificateFast 10 1813 fastCert10_1813=true) ∧ (checkCertificateFast 10 1814 fastCert10_1814=true) ∧ (checkCertificateFast 10 1815 fastCert10_1815=true) ∧ (checkCertificateFast 10 1816 fastCert10_1816=true) ∧ (checkCertificateFast 10 1817 fastCert10_1817=true) ∧ (checkCertificateFast 10 1818 fastCert10_1818=true) ∧ (checkCertificateFast 10 1819 fastCert10_1819=true) ∧ (checkCertificateFast 10 1820 fastCert10_1820=true) ∧ (checkCertificateFast 10 1821 fastCert10_1821=true) ∧ (checkCertificateFast 10 1822 fastCert10_1822=true) ∧ (checkCertificateFast 10 1823 fastCert10_1823=true) ∧ (checkCertificateFast 10 1824 fastCert10_1824=true) ∧ (checkCertificateFast 10 1825 fastCert10_1825=true) ∧ (checkCertificateFast 10 1826 fastCert10_1826=true) ∧ (checkCertificateFast 10 1827 fastCert10_1827=true) ∧ (checkCertificateFast 10 1828 fastCert10_1828=true) ∧ (checkCertificateFast 10 1829 fastCert10_1829=true) ∧ (checkCertificateFast 10 1830 fastCert10_1830=true) ∧ (checkCertificateFast 10 1831 fastCert10_1831=true) ∧ (checkCertificateFast 10 1832 fastCert10_1832=true) ∧ (checkCertificateFast 10 1833 fastCert10_1833=true) ∧ (checkCertificateFast 10 1834 fastCert10_1834=true) ∧ (checkCertificateFast 10 1835 fastCert10_1835=true) ∧ (checkCertificateFast 10 1836 fastCert10_1836=true) ∧ (checkCertificateFast 10 1837 fastCert10_1837=true) ∧ (checkCertificateFast 10 1838 fastCert10_1838=true) ∧ (checkCertificateFast 10 1839 fastCert10_1839=true) ∧ (checkCertificateFast 10 1840 fastCert10_1840=true) ∧ (checkCertificateFast 10 1841 fastCert10_1841=true) ∧ (checkCertificateFast 10 1842 fastCert10_1842=true) ∧ (checkCertificateFast 10 1843 fastCert10_1843=true) ∧ (checkCertificateFast 10 1844 fastCert10_1844=true) ∧ (checkCertificateFast 10 1845 fastCert10_1845=true) ∧ (checkCertificateFast 10 1846 fastCert10_1846=true) ∧ (checkCertificateFast 10 1847 fastCert10_1847=true) ∧ (checkCertificateFast 10 1848 fastCert10_1848=true) ∧ (checkCertificateFast 10 1849 fastCert10_1849=true) ∧ (checkCertificateFast 10 1850 fastCert10_1850=true) ∧ (checkCertificateFast 10 1851 fastCert10_1851=true) ∧ (checkCertificateFast 10 1852 fastCert10_1852=true) ∧ (checkCertificateFast 10 1853 fastCert10_1853=true) ∧ (checkCertificateFast 10 1854 fastCert10_1854=true) ∧ (checkCertificateFast 10 1855 fastCert10_1855=true) ∧ (checkCertificateFast 10 1856 fastCert10_1856=true) ∧ (checkCertificateFast 10 1857 fastCert10_1857=true) ∧ (checkCertificateFast 10 1858 fastCert10_1858=true) ∧ (checkCertificateFast 10 1859 fastCert10_1859=true) ∧ (checkCertificateFast 10 1860 fastCert10_1860=true) ∧ (checkCertificateFast 10 1861 fastCert10_1861=true) ∧ (checkCertificateFast 10 1862 fastCert10_1862=true) ∧ (checkCertificateFast 10 1863 fastCert10_1863=true) ∧ (checkCertificateFast 10 1864 fastCert10_1864=true) ∧ (checkCertificateFast 10 1865 fastCert10_1865=true) ∧ (checkCertificateFast 10 1866 fastCert10_1866=true) ∧ (checkCertificateFast 10 1867 fastCert10_1867=true) ∧ (checkCertificateFast 10 1868 fastCert10_1868=true) ∧ (checkCertificateFast 10 1869 fastCert10_1869=true) ∧ (checkCertificateFast 10 1870 fastCert10_1870=true) ∧ (checkCertificateFast 10 1871 fastCert10_1871=true) ∧ (checkCertificateFast 10 1872 fastCert10_1872=true) ∧ (checkCertificateFast 10 1873 fastCert10_1873=true) ∧ (checkCertificateFast 10 1874 fastCert10_1874=true) ∧ (checkCertificateFast 10 1875 fastCert10_1875=true) ∧ (checkCertificateFast 10 1876 fastCert10_1876=true) ∧ (checkCertificateFast 10 1877 fastCert10_1877=true) ∧ (checkCertificateFast 10 1878 fastCert10_1878=true) ∧ (checkCertificateFast 10 1879 fastCert10_1879=true) ∧ (checkCertificateFast 10 1880 fastCert10_1880=true) ∧ (checkCertificateFast 10 1881 fastCert10_1881=true) ∧ (checkCertificateFast 10 1882 fastCert10_1882=true) ∧ (checkCertificateFast 10 1883 fastCert10_1883=true) ∧ (checkCertificateFast 10 1884 fastCert10_1884=true) ∧ (checkCertificateFast 10 1885 fastCert10_1885=true) ∧ (checkCertificateFast 10 1886 fastCert10_1886=true) ∧ (checkCertificateFast 10 1887 fastCert10_1887=true) ∧ (checkCertificateFast 10 1888 fastCert10_1888=true) ∧ (checkCertificateFast 10 1889 fastCert10_1889=true) ∧ (checkCertificateFast 10 1890 fastCert10_1890=true) ∧ (checkCertificateFast 10 1891 fastCert10_1891=true) ∧ (checkCertificateFast 10 1892 fastCert10_1892=true) ∧ (checkCertificateFast 10 1893 fastCert10_1893=true) ∧ (checkCertificateFast 10 1894 fastCert10_1894=true) ∧ (checkCertificateFast 10 1895 fastCert10_1895=true) ∧ (checkCertificateFast 10 1896 fastCert10_1896=true) ∧ (checkCertificateFast 10 1897 fastCert10_1897=true) ∧ (checkCertificateFast 10 1898 fastCert10_1898=true) ∧ (checkCertificateFast 10 1899 fastCert10_1899=true) ∧ (checkCertificateFast 10 1900 fastCert10_1900=true) ∧ (checkCertificateFast 10 1901 fastCert10_1901=true) ∧ (checkCertificateFast 10 1902 fastCert10_1902=true) ∧ (checkCertificateFast 10 1903 fastCert10_1903=true) ∧ (checkCertificateFast 10 1904 fastCert10_1904=true) ∧ (checkCertificateFast 10 1905 fastCert10_1905=true) ∧ (checkCertificateFast 10 1906 fastCert10_1906=true) ∧ (checkCertificateFast 10 1907 fastCert10_1907=true) ∧ (checkCertificateFast 10 1908 fastCert10_1908=true) ∧ (checkCertificateFast 10 1909 fastCert10_1909=true) ∧ (checkCertificateFast 10 1910 fastCert10_1910=true) ∧ (checkCertificateFast 10 1911 fastCert10_1911=true) ∧ (checkCertificateFast 10 1912 fastCert10_1912=true) ∧ (checkCertificateFast 10 1913 fastCert10_1913=true) ∧ (checkCertificateFast 10 1914 fastCert10_1914=true) ∧ (checkCertificateFast 10 1915 fastCert10_1915=true) ∧ (checkCertificateFast 10 1916 fastCert10_1916=true) ∧ (checkCertificateFast 10 1917 fastCert10_1917=true) ∧ (checkCertificateFast 10 1918 fastCert10_1918=true) ∧ (checkCertificateFast 10 1919 fastCert10_1919=true) ∧ (checkCertificateFast 10 1920 fastCert10_1920=true) ∧ (checkCertificateFast 10 1921 fastCert10_1921=true) ∧ (checkCertificateFast 10 1922 fastCert10_1922=true) ∧ (checkCertificateFast 10 1923 fastCert10_1923=true) ∧ (checkCertificateFast 10 1924 fastCert10_1924=true) ∧ (checkCertificateFast 10 1925 fastCert10_1925=true) ∧ (checkCertificateFast 10 1926 fastCert10_1926=true) ∧ (checkCertificateFast 10 1927 fastCert10_1927=true) ∧ (checkCertificateFast 10 1928 fastCert10_1928=true) ∧ (checkCertificateFast 10 1929 fastCert10_1929=true) ∧ (checkCertificateFast 10 1930 fastCert10_1930=true) ∧ (checkCertificateFast 10 1931 fastCert10_1931=true) ∧ (checkCertificateFast 10 1932 fastCert10_1932=true) ∧ (checkCertificateFast 10 1933 fastCert10_1933=true) ∧ (checkCertificateFast 10 1934 fastCert10_1934=true) ∧ (checkCertificateFast 10 1935 fastCert10_1935=true) ∧ (checkCertificateFast 10 1936 fastCert10_1936=true) ∧ (checkCertificateFast 10 1937 fastCert10_1937=true) ∧ (checkCertificateFast 10 1938 fastCert10_1938=true) ∧ (checkCertificateFast 10 1939 fastCert10_1939=true) ∧ (checkCertificateFast 10 1940 fastCert10_1940=true) ∧ (checkCertificateFast 10 1941 fastCert10_1941=true) ∧ (checkCertificateFast 10 1942 fastCert10_1942=true) ∧ (checkCertificateFast 10 1943 fastCert10_1943=true) ∧ (checkCertificateFast 10 1944 fastCert10_1944=true) ∧ (checkCertificateFast 10 1945 fastCert10_1945=true) ∧ (checkCertificateFast 10 1946 fastCert10_1946=true) ∧ (checkCertificateFast 10 1947 fastCert10_1947=true) ∧ (checkCertificateFast 10 1948 fastCert10_1948=true) ∧ (checkCertificateFast 10 1949 fastCert10_1949=true) ∧ (checkCertificateFast 10 1950 fastCert10_1950=true) ∧ (checkCertificateFast 10 1951 fastCert10_1951=true) ∧ (checkCertificateFast 10 1952 fastCert10_1952=true) ∧ (checkCertificateFast 10 1953 fastCert10_1953=true) ∧ (checkCertificateFast 10 1954 fastCert10_1954=true) ∧ (checkCertificateFast 10 1955 fastCert10_1955=true) ∧ (checkCertificateFast 10 1956 fastCert10_1956=true) ∧ (checkCertificateFast 10 1957 fastCert10_1957=true) ∧ (checkCertificateFast 10 1958 fastCert10_1958=true) ∧ (checkCertificateFast 10 1959 fastCert10_1959=true) ∧ (checkCertificateFast 10 1960 fastCert10_1960=true) ∧ (checkCertificateFast 10 1961 fastCert10_1961=true) ∧ (checkCertificateFast 10 1962 fastCert10_1962=true) ∧ (checkCertificateFast 10 1963 fastCert10_1963=true) ∧ (checkCertificateFast 10 1964 fastCert10_1964=true) ∧ (checkCertificateFast 10 1965 fastCert10_1965=true) ∧ (checkCertificateFast 10 1966 fastCert10_1966=true) ∧ (checkCertificateFast 10 1967 fastCert10_1967=true) ∧ (checkCertificateFast 10 1968 fastCert10_1968=true) ∧ (checkCertificateFast 10 1969 fastCert10_1969=true) ∧ (checkCertificateFast 10 1970 fastCert10_1970=true) ∧ (checkCertificateFast 10 1971 fastCert10_1971=true) ∧ (checkCertificateFast 10 1972 fastCert10_1972=true) ∧ (checkCertificateFast 10 1973 fastCert10_1973=true) ∧ (checkCertificateFast 10 1974 fastCert10_1974=true) ∧ (checkCertificateFast 10 1975 fastCert10_1975=true) ∧ (checkCertificateFast 10 1976 fastCert10_1976=true) ∧ (checkCertificateFast 10 1977 fastCert10_1977=true) ∧ (checkCertificateFast 10 1978 fastCert10_1978=true) ∧ (checkCertificateFast 10 1979 fastCert10_1979=true) ∧ (checkCertificateFast 10 1980 fastCert10_1980=true) ∧ (checkCertificateFast 10 1981 fastCert10_1981=true) ∧ (checkCertificateFast 10 1982 fastCert10_1982=true) ∧ (checkCertificateFast 10 1983 fastCert10_1983=true) ∧ (checkCertificateFast 10 1984 fastCert10_1984=true) ∧ (checkCertificateFast 10 1985 fastCert10_1985=true) ∧ (checkCertificateFast 10 1986 fastCert10_1986=true) ∧ (checkCertificateFast 10 1987 fastCert10_1987=true) ∧ (checkCertificateFast 10 1988 fastCert10_1988=true) ∧ (checkCertificateFast 10 1989 fastCert10_1989=true) ∧ (checkCertificateFast 10 1990 fastCert10_1990=true) ∧ (checkCertificateFast 10 1991 fastCert10_1991=true) ∧ (checkCertificateFast 10 1992 fastCert10_1992=true) ∧ (checkCertificateFast 10 1993 fastCert10_1993=true) ∧ (checkCertificateFast 10 1994 fastCert10_1994=true) ∧ (checkCertificateFast 10 1995 fastCert10_1995=true) ∧ (checkCertificateFast 10 1996 fastCert10_1996=true) ∧ (checkCertificateFast 10 1997 fastCert10_1997=true) ∧ (checkCertificateFast 10 1998 fastCert10_1998=true) ∧ (checkCertificateFast 10 1999 fastCert10_1999=true) :=
  ⟨fastCase10_1000,fastCase10_1001,fastCase10_1002,fastCase10_1003,fastCase10_1004,fastCase10_1005,fastCase10_1006,fastCase10_1007,fastCase10_1008,fastCase10_1009,fastCase10_1010,fastCase10_1011,fastCase10_1012,fastCase10_1013,fastCase10_1014,fastCase10_1015,fastCase10_1016,fastCase10_1017,fastCase10_1018,fastCase10_1019,fastCase10_1020,fastCase10_1021,fastCase10_1022,fastCase10_1023,fastCase10_1024,fastCase10_1025,fastCase10_1026,fastCase10_1027,fastCase10_1028,fastCase10_1029,fastCase10_1030,fastCase10_1031,fastCase10_1032,fastCase10_1033,fastCase10_1034,fastCase10_1035,fastCase10_1036,fastCase10_1037,fastCase10_1038,fastCase10_1039,fastCase10_1040,fastCase10_1041,fastCase10_1042,fastCase10_1043,fastCase10_1044,fastCase10_1045,fastCase10_1046,fastCase10_1047,fastCase10_1048,fastCase10_1049,fastCase10_1050,fastCase10_1051,fastCase10_1052,fastCase10_1053,fastCase10_1054,fastCase10_1055,fastCase10_1056,fastCase10_1057,fastCase10_1058,fastCase10_1059,fastCase10_1060,fastCase10_1061,fastCase10_1062,fastCase10_1063,fastCase10_1064,fastCase10_1065,fastCase10_1066,fastCase10_1067,fastCase10_1068,fastCase10_1069,fastCase10_1070,fastCase10_1071,fastCase10_1072,fastCase10_1073,fastCase10_1074,fastCase10_1075,fastCase10_1076,fastCase10_1077,fastCase10_1078,fastCase10_1079,fastCase10_1080,fastCase10_1081,fastCase10_1082,fastCase10_1083,fastCase10_1084,fastCase10_1085,fastCase10_1086,fastCase10_1087,fastCase10_1088,fastCase10_1089,fastCase10_1090,fastCase10_1091,fastCase10_1092,fastCase10_1093,fastCase10_1094,fastCase10_1095,fastCase10_1096,fastCase10_1097,fastCase10_1098,fastCase10_1099,fastCase10_1100,fastCase10_1101,fastCase10_1102,fastCase10_1103,fastCase10_1104,fastCase10_1105,fastCase10_1106,fastCase10_1107,fastCase10_1108,fastCase10_1109,fastCase10_1110,fastCase10_1111,fastCase10_1112,fastCase10_1113,fastCase10_1114,fastCase10_1115,fastCase10_1116,fastCase10_1117,fastCase10_1118,fastCase10_1119,fastCase10_1120,fastCase10_1121,fastCase10_1122,fastCase10_1123,fastCase10_1124,fastCase10_1125,fastCase10_1126,fastCase10_1127,fastCase10_1128,fastCase10_1129,fastCase10_1130,fastCase10_1131,fastCase10_1132,fastCase10_1133,fastCase10_1134,fastCase10_1135,fastCase10_1136,fastCase10_1137,fastCase10_1138,fastCase10_1139,fastCase10_1140,fastCase10_1141,fastCase10_1142,fastCase10_1143,fastCase10_1144,fastCase10_1145,fastCase10_1146,fastCase10_1147,fastCase10_1148,fastCase10_1149,fastCase10_1150,fastCase10_1151,fastCase10_1152,fastCase10_1153,fastCase10_1154,fastCase10_1155,fastCase10_1156,fastCase10_1157,fastCase10_1158,fastCase10_1159,fastCase10_1160,fastCase10_1161,fastCase10_1162,fastCase10_1163,fastCase10_1164,fastCase10_1165,fastCase10_1166,fastCase10_1167,fastCase10_1168,fastCase10_1169,fastCase10_1170,fastCase10_1171,fastCase10_1172,fastCase10_1173,fastCase10_1174,fastCase10_1175,fastCase10_1176,fastCase10_1177,fastCase10_1178,fastCase10_1179,fastCase10_1180,fastCase10_1181,fastCase10_1182,fastCase10_1183,fastCase10_1184,fastCase10_1185,fastCase10_1186,fastCase10_1187,fastCase10_1188,fastCase10_1189,fastCase10_1190,fastCase10_1191,fastCase10_1192,fastCase10_1193,fastCase10_1194,fastCase10_1195,fastCase10_1196,fastCase10_1197,fastCase10_1198,fastCase10_1199,fastCase10_1200,fastCase10_1201,fastCase10_1202,fastCase10_1203,fastCase10_1204,fastCase10_1205,fastCase10_1206,fastCase10_1207,fastCase10_1208,fastCase10_1209,fastCase10_1210,fastCase10_1211,fastCase10_1212,fastCase10_1213,fastCase10_1214,fastCase10_1215,fastCase10_1216,fastCase10_1217,fastCase10_1218,fastCase10_1219,fastCase10_1220,fastCase10_1221,fastCase10_1222,fastCase10_1223,fastCase10_1224,fastCase10_1225,fastCase10_1226,fastCase10_1227,fastCase10_1228,fastCase10_1229,fastCase10_1230,fastCase10_1231,fastCase10_1232,fastCase10_1233,fastCase10_1234,fastCase10_1235,fastCase10_1236,fastCase10_1237,fastCase10_1238,fastCase10_1239,fastCase10_1240,fastCase10_1241,fastCase10_1242,fastCase10_1243,fastCase10_1244,fastCase10_1245,fastCase10_1246,fastCase10_1247,fastCase10_1248,fastCase10_1249,fastCase10_1250,fastCase10_1251,fastCase10_1252,fastCase10_1253,fastCase10_1254,fastCase10_1255,fastCase10_1256,fastCase10_1257,fastCase10_1258,fastCase10_1259,fastCase10_1260,fastCase10_1261,fastCase10_1262,fastCase10_1263,fastCase10_1264,fastCase10_1265,fastCase10_1266,fastCase10_1267,fastCase10_1268,fastCase10_1269,fastCase10_1270,fastCase10_1271,fastCase10_1272,fastCase10_1273,fastCase10_1274,fastCase10_1275,fastCase10_1276,fastCase10_1277,fastCase10_1278,fastCase10_1279,fastCase10_1280,fastCase10_1281,fastCase10_1282,fastCase10_1283,fastCase10_1284,fastCase10_1285,fastCase10_1286,fastCase10_1287,fastCase10_1288,fastCase10_1289,fastCase10_1290,fastCase10_1291,fastCase10_1292,fastCase10_1293,fastCase10_1294,fastCase10_1295,fastCase10_1296,fastCase10_1297,fastCase10_1298,fastCase10_1299,fastCase10_1300,fastCase10_1301,fastCase10_1302,fastCase10_1303,fastCase10_1304,fastCase10_1305,fastCase10_1306,fastCase10_1307,fastCase10_1308,fastCase10_1309,fastCase10_1310,fastCase10_1311,fastCase10_1312,fastCase10_1313,fastCase10_1314,fastCase10_1315,fastCase10_1316,fastCase10_1317,fastCase10_1318,fastCase10_1319,fastCase10_1320,fastCase10_1321,fastCase10_1322,fastCase10_1323,fastCase10_1324,fastCase10_1325,fastCase10_1326,fastCase10_1327,fastCase10_1328,fastCase10_1329,fastCase10_1330,fastCase10_1331,fastCase10_1332,fastCase10_1333,fastCase10_1334,fastCase10_1335,fastCase10_1336,fastCase10_1337,fastCase10_1338,fastCase10_1339,fastCase10_1340,fastCase10_1341,fastCase10_1342,fastCase10_1343,fastCase10_1344,fastCase10_1345,fastCase10_1346,fastCase10_1347,fastCase10_1348,fastCase10_1349,fastCase10_1350,fastCase10_1351,fastCase10_1352,fastCase10_1353,fastCase10_1354,fastCase10_1355,fastCase10_1356,fastCase10_1357,fastCase10_1358,fastCase10_1359,fastCase10_1360,fastCase10_1361,fastCase10_1362,fastCase10_1363,fastCase10_1364,fastCase10_1365,fastCase10_1366,fastCase10_1367,fastCase10_1368,fastCase10_1369,fastCase10_1370,fastCase10_1371,fastCase10_1372,fastCase10_1373,fastCase10_1374,fastCase10_1375,fastCase10_1376,fastCase10_1377,fastCase10_1378,fastCase10_1379,fastCase10_1380,fastCase10_1381,fastCase10_1382,fastCase10_1383,fastCase10_1384,fastCase10_1385,fastCase10_1386,fastCase10_1387,fastCase10_1388,fastCase10_1389,fastCase10_1390,fastCase10_1391,fastCase10_1392,fastCase10_1393,fastCase10_1394,fastCase10_1395,fastCase10_1396,fastCase10_1397,fastCase10_1398,fastCase10_1399,fastCase10_1400,fastCase10_1401,fastCase10_1402,fastCase10_1403,fastCase10_1404,fastCase10_1405,fastCase10_1406,fastCase10_1407,fastCase10_1408,fastCase10_1409,fastCase10_1410,fastCase10_1411,fastCase10_1412,fastCase10_1413,fastCase10_1414,fastCase10_1415,fastCase10_1416,fastCase10_1417,fastCase10_1418,fastCase10_1419,fastCase10_1420,fastCase10_1421,fastCase10_1422,fastCase10_1423,fastCase10_1424,fastCase10_1425,fastCase10_1426,fastCase10_1427,fastCase10_1428,fastCase10_1429,fastCase10_1430,fastCase10_1431,fastCase10_1432,fastCase10_1433,fastCase10_1434,fastCase10_1435,fastCase10_1436,fastCase10_1437,fastCase10_1438,fastCase10_1439,fastCase10_1440,fastCase10_1441,fastCase10_1442,fastCase10_1443,fastCase10_1444,fastCase10_1445,fastCase10_1446,fastCase10_1447,fastCase10_1448,fastCase10_1449,fastCase10_1450,fastCase10_1451,fastCase10_1452,fastCase10_1453,fastCase10_1454,fastCase10_1455,fastCase10_1456,fastCase10_1457,fastCase10_1458,fastCase10_1459,fastCase10_1460,fastCase10_1461,fastCase10_1462,fastCase10_1463,fastCase10_1464,fastCase10_1465,fastCase10_1466,fastCase10_1467,fastCase10_1468,fastCase10_1469,fastCase10_1470,fastCase10_1471,fastCase10_1472,fastCase10_1473,fastCase10_1474,fastCase10_1475,fastCase10_1476,fastCase10_1477,fastCase10_1478,fastCase10_1479,fastCase10_1480,fastCase10_1481,fastCase10_1482,fastCase10_1483,fastCase10_1484,fastCase10_1485,fastCase10_1486,fastCase10_1487,fastCase10_1488,fastCase10_1489,fastCase10_1490,fastCase10_1491,fastCase10_1492,fastCase10_1493,fastCase10_1494,fastCase10_1495,fastCase10_1496,fastCase10_1497,fastCase10_1498,fastCase10_1499,fastCase10_1500,fastCase10_1501,fastCase10_1502,fastCase10_1503,fastCase10_1504,fastCase10_1505,fastCase10_1506,fastCase10_1507,fastCase10_1508,fastCase10_1509,fastCase10_1510,fastCase10_1511,fastCase10_1512,fastCase10_1513,fastCase10_1514,fastCase10_1515,fastCase10_1516,fastCase10_1517,fastCase10_1518,fastCase10_1519,fastCase10_1520,fastCase10_1521,fastCase10_1522,fastCase10_1523,fastCase10_1524,fastCase10_1525,fastCase10_1526,fastCase10_1527,fastCase10_1528,fastCase10_1529,fastCase10_1530,fastCase10_1531,fastCase10_1532,fastCase10_1533,fastCase10_1534,fastCase10_1535,fastCase10_1536,fastCase10_1537,fastCase10_1538,fastCase10_1539,fastCase10_1540,fastCase10_1541,fastCase10_1542,fastCase10_1543,fastCase10_1544,fastCase10_1545,fastCase10_1546,fastCase10_1547,fastCase10_1548,fastCase10_1549,fastCase10_1550,fastCase10_1551,fastCase10_1552,fastCase10_1553,fastCase10_1554,fastCase10_1555,fastCase10_1556,fastCase10_1557,fastCase10_1558,fastCase10_1559,fastCase10_1560,fastCase10_1561,fastCase10_1562,fastCase10_1563,fastCase10_1564,fastCase10_1565,fastCase10_1566,fastCase10_1567,fastCase10_1568,fastCase10_1569,fastCase10_1570,fastCase10_1571,fastCase10_1572,fastCase10_1573,fastCase10_1574,fastCase10_1575,fastCase10_1576,fastCase10_1577,fastCase10_1578,fastCase10_1579,fastCase10_1580,fastCase10_1581,fastCase10_1582,fastCase10_1583,fastCase10_1584,fastCase10_1585,fastCase10_1586,fastCase10_1587,fastCase10_1588,fastCase10_1589,fastCase10_1590,fastCase10_1591,fastCase10_1592,fastCase10_1593,fastCase10_1594,fastCase10_1595,fastCase10_1596,fastCase10_1597,fastCase10_1598,fastCase10_1599,fastCase10_1600,fastCase10_1601,fastCase10_1602,fastCase10_1603,fastCase10_1604,fastCase10_1605,fastCase10_1606,fastCase10_1607,fastCase10_1608,fastCase10_1609,fastCase10_1610,fastCase10_1611,fastCase10_1612,fastCase10_1613,fastCase10_1614,fastCase10_1615,fastCase10_1616,fastCase10_1617,fastCase10_1618,fastCase10_1619,fastCase10_1620,fastCase10_1621,fastCase10_1622,fastCase10_1623,fastCase10_1624,fastCase10_1625,fastCase10_1626,fastCase10_1627,fastCase10_1628,fastCase10_1629,fastCase10_1630,fastCase10_1631,fastCase10_1632,fastCase10_1633,fastCase10_1634,fastCase10_1635,fastCase10_1636,fastCase10_1637,fastCase10_1638,fastCase10_1639,fastCase10_1640,fastCase10_1641,fastCase10_1642,fastCase10_1643,fastCase10_1644,fastCase10_1645,fastCase10_1646,fastCase10_1647,fastCase10_1648,fastCase10_1649,fastCase10_1650,fastCase10_1651,fastCase10_1652,fastCase10_1653,fastCase10_1654,fastCase10_1655,fastCase10_1656,fastCase10_1657,fastCase10_1658,fastCase10_1659,fastCase10_1660,fastCase10_1661,fastCase10_1662,fastCase10_1663,fastCase10_1664,fastCase10_1665,fastCase10_1666,fastCase10_1667,fastCase10_1668,fastCase10_1669,fastCase10_1670,fastCase10_1671,fastCase10_1672,fastCase10_1673,fastCase10_1674,fastCase10_1675,fastCase10_1676,fastCase10_1677,fastCase10_1678,fastCase10_1679,fastCase10_1680,fastCase10_1681,fastCase10_1682,fastCase10_1683,fastCase10_1684,fastCase10_1685,fastCase10_1686,fastCase10_1687,fastCase10_1688,fastCase10_1689,fastCase10_1690,fastCase10_1691,fastCase10_1692,fastCase10_1693,fastCase10_1694,fastCase10_1695,fastCase10_1696,fastCase10_1697,fastCase10_1698,fastCase10_1699,fastCase10_1700,fastCase10_1701,fastCase10_1702,fastCase10_1703,fastCase10_1704,fastCase10_1705,fastCase10_1706,fastCase10_1707,fastCase10_1708,fastCase10_1709,fastCase10_1710,fastCase10_1711,fastCase10_1712,fastCase10_1713,fastCase10_1714,fastCase10_1715,fastCase10_1716,fastCase10_1717,fastCase10_1718,fastCase10_1719,fastCase10_1720,fastCase10_1721,fastCase10_1722,fastCase10_1723,fastCase10_1724,fastCase10_1725,fastCase10_1726,fastCase10_1727,fastCase10_1728,fastCase10_1729,fastCase10_1730,fastCase10_1731,fastCase10_1732,fastCase10_1733,fastCase10_1734,fastCase10_1735,fastCase10_1736,fastCase10_1737,fastCase10_1738,fastCase10_1739,fastCase10_1740,fastCase10_1741,fastCase10_1742,fastCase10_1743,fastCase10_1744,fastCase10_1745,fastCase10_1746,fastCase10_1747,fastCase10_1748,fastCase10_1749,fastCase10_1750,fastCase10_1751,fastCase10_1752,fastCase10_1753,fastCase10_1754,fastCase10_1755,fastCase10_1756,fastCase10_1757,fastCase10_1758,fastCase10_1759,fastCase10_1760,fastCase10_1761,fastCase10_1762,fastCase10_1763,fastCase10_1764,fastCase10_1765,fastCase10_1766,fastCase10_1767,fastCase10_1768,fastCase10_1769,fastCase10_1770,fastCase10_1771,fastCase10_1772,fastCase10_1773,fastCase10_1774,fastCase10_1775,fastCase10_1776,fastCase10_1777,fastCase10_1778,fastCase10_1779,fastCase10_1780,fastCase10_1781,fastCase10_1782,fastCase10_1783,fastCase10_1784,fastCase10_1785,fastCase10_1786,fastCase10_1787,fastCase10_1788,fastCase10_1789,fastCase10_1790,fastCase10_1791,fastCase10_1792,fastCase10_1793,fastCase10_1794,fastCase10_1795,fastCase10_1796,fastCase10_1797,fastCase10_1798,fastCase10_1799,fastCase10_1800,fastCase10_1801,fastCase10_1802,fastCase10_1803,fastCase10_1804,fastCase10_1805,fastCase10_1806,fastCase10_1807,fastCase10_1808,fastCase10_1809,fastCase10_1810,fastCase10_1811,fastCase10_1812,fastCase10_1813,fastCase10_1814,fastCase10_1815,fastCase10_1816,fastCase10_1817,fastCase10_1818,fastCase10_1819,fastCase10_1820,fastCase10_1821,fastCase10_1822,fastCase10_1823,fastCase10_1824,fastCase10_1825,fastCase10_1826,fastCase10_1827,fastCase10_1828,fastCase10_1829,fastCase10_1830,fastCase10_1831,fastCase10_1832,fastCase10_1833,fastCase10_1834,fastCase10_1835,fastCase10_1836,fastCase10_1837,fastCase10_1838,fastCase10_1839,fastCase10_1840,fastCase10_1841,fastCase10_1842,fastCase10_1843,fastCase10_1844,fastCase10_1845,fastCase10_1846,fastCase10_1847,fastCase10_1848,fastCase10_1849,fastCase10_1850,fastCase10_1851,fastCase10_1852,fastCase10_1853,fastCase10_1854,fastCase10_1855,fastCase10_1856,fastCase10_1857,fastCase10_1858,fastCase10_1859,fastCase10_1860,fastCase10_1861,fastCase10_1862,fastCase10_1863,fastCase10_1864,fastCase10_1865,fastCase10_1866,fastCase10_1867,fastCase10_1868,fastCase10_1869,fastCase10_1870,fastCase10_1871,fastCase10_1872,fastCase10_1873,fastCase10_1874,fastCase10_1875,fastCase10_1876,fastCase10_1877,fastCase10_1878,fastCase10_1879,fastCase10_1880,fastCase10_1881,fastCase10_1882,fastCase10_1883,fastCase10_1884,fastCase10_1885,fastCase10_1886,fastCase10_1887,fastCase10_1888,fastCase10_1889,fastCase10_1890,fastCase10_1891,fastCase10_1892,fastCase10_1893,fastCase10_1894,fastCase10_1895,fastCase10_1896,fastCase10_1897,fastCase10_1898,fastCase10_1899,fastCase10_1900,fastCase10_1901,fastCase10_1902,fastCase10_1903,fastCase10_1904,fastCase10_1905,fastCase10_1906,fastCase10_1907,fastCase10_1908,fastCase10_1909,fastCase10_1910,fastCase10_1911,fastCase10_1912,fastCase10_1913,fastCase10_1914,fastCase10_1915,fastCase10_1916,fastCase10_1917,fastCase10_1918,fastCase10_1919,fastCase10_1920,fastCase10_1921,fastCase10_1922,fastCase10_1923,fastCase10_1924,fastCase10_1925,fastCase10_1926,fastCase10_1927,fastCase10_1928,fastCase10_1929,fastCase10_1930,fastCase10_1931,fastCase10_1932,fastCase10_1933,fastCase10_1934,fastCase10_1935,fastCase10_1936,fastCase10_1937,fastCase10_1938,fastCase10_1939,fastCase10_1940,fastCase10_1941,fastCase10_1942,fastCase10_1943,fastCase10_1944,fastCase10_1945,fastCase10_1946,fastCase10_1947,fastCase10_1948,fastCase10_1949,fastCase10_1950,fastCase10_1951,fastCase10_1952,fastCase10_1953,fastCase10_1954,fastCase10_1955,fastCase10_1956,fastCase10_1957,fastCase10_1958,fastCase10_1959,fastCase10_1960,fastCase10_1961,fastCase10_1962,fastCase10_1963,fastCase10_1964,fastCase10_1965,fastCase10_1966,fastCase10_1967,fastCase10_1968,fastCase10_1969,fastCase10_1970,fastCase10_1971,fastCase10_1972,fastCase10_1973,fastCase10_1974,fastCase10_1975,fastCase10_1976,fastCase10_1977,fastCase10_1978,fastCase10_1979,fastCase10_1980,fastCase10_1981,fastCase10_1982,fastCase10_1983,fastCase10_1984,fastCase10_1985,fastCase10_1986,fastCase10_1987,fastCase10_1988,fastCase10_1989,fastCase10_1990,fastCase10_1991,fastCase10_1992,fastCase10_1993,fastCase10_1994,fastCase10_1995,fastCase10_1996,fastCase10_1997,fastCase10_1998,fastCase10_1999⟩
#print axioms aggregate_F10_001
end KernelCatalog
