import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_3000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3000 : checkCertificateFast 10 3000 fastCert10_3000=true := by decide +kernel
def fastCert10_3001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3001 : checkCertificateFast 10 3001 fastCert10_3001=true := by decide +kernel
def fastCert10_3002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3002 : checkCertificateFast 10 3002 fastCert10_3002=true := by decide +kernel
def fastCert10_3003 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3003 : checkCertificateFast 10 3003 fastCert10_3003=true := by decide +kernel
def fastCert10_3004 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3004 : checkCertificateFast 10 3004 fastCert10_3004=true := by decide +kernel
def fastCert10_3005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3005 : checkCertificateFast 10 3005 fastCert10_3005=true := by decide +kernel
def fastCert10_3006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3006 : checkCertificateFast 10 3006 fastCert10_3006=true := by decide +kernel
def fastCert10_3007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3007 : checkCertificateFast 10 3007 fastCert10_3007=true := by decide +kernel
def fastCert10_3008 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_3008 : checkCertificateFast 10 3008 fastCert10_3008=true := by decide +kernel
def fastCert10_3009 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_3009 : checkCertificateFast 10 3009 fastCert10_3009=true := by decide +kernel
def fastCert10_3010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3010 : checkCertificateFast 10 3010 fastCert10_3010=true := by decide +kernel
def fastCert10_3011 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-4) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3011 : checkCertificateFast 10 3011 fastCert10_3011=true := by decide +kernel
def fastCert10_3012 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3012 : checkCertificateFast 10 3012 fastCert10_3012=true := by decide +kernel
def fastCert10_3013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (-4) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3013 : checkCertificateFast 10 3013 fastCert10_3013=true := by decide +kernel
def fastCert10_3014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3014 : checkCertificateFast 10 3014 fastCert10_3014=true := by decide +kernel
def fastCert10_3015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3015 : checkCertificateFast 10 3015 fastCert10_3015=true := by decide +kernel
def fastCert10_3016 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3016 : checkCertificateFast 10 3016 fastCert10_3016=true := by decide +kernel
def fastCert10_3017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3017 : checkCertificateFast 10 3017 fastCert10_3017=true := by decide +kernel
def fastCert10_3018 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3018 : checkCertificateFast 10 3018 fastCert10_3018=true := by decide +kernel
def fastCert10_3019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3019 : checkCertificateFast 10 3019 fastCert10_3019=true := by decide +kernel
def fastCert10_3020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3020 : checkCertificateFast 10 3020 fastCert10_3020=true := by decide +kernel
def fastCert10_3021 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3021 : checkCertificateFast 10 3021 fastCert10_3021=true := by decide +kernel
def fastCert10_3022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3022 : checkCertificateFast 10 3022 fastCert10_3022=true := by decide +kernel
def fastCert10_3023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3023 : checkCertificateFast 10 3023 fastCert10_3023=true := by decide +kernel
def fastCert10_3024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3024 : checkCertificateFast 10 3024 fastCert10_3024=true := by decide +kernel
def fastCert10_3025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3025 : checkCertificateFast 10 3025 fastCert10_3025=true := by decide +kernel
def fastCert10_3026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-5) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (4) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3026 : checkCertificateFast 10 3026 fastCert10_3026=true := by decide +kernel
def fastCert10_3027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-4) else if t=0 ∧ i=1 then (23) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (18) else if t=0 ∧ i=4 then (18) else if t=0 ∧ i=5 then (8) else if t=0 ∧ i=6 then (-25) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (12) else if t=0 ∧ i=11 then (-14) else if t=0 ∧ i=12 then (-12) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (24) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3027 : checkCertificateFast 10 3027 fastCert10_3027=true := by decide +kernel
def fastCert10_3028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3028 : checkCertificateFast 10 3028 fastCert10_3028=true := by decide +kernel
def fastCert10_3029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3029 : checkCertificateFast 10 3029 fastCert10_3029=true := by decide +kernel
def fastCert10_3030 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3030 : checkCertificateFast 10 3030 fastCert10_3030=true := by decide +kernel
def fastCert10_3031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3031 : checkCertificateFast 10 3031 fastCert10_3031=true := by decide +kernel
def fastCert10_3032 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3032 : checkCertificateFast 10 3032 fastCert10_3032=true := by decide +kernel
def fastCert10_3033 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3033 : checkCertificateFast 10 3033 fastCert10_3033=true := by decide +kernel
def fastCert10_3034 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3034 : checkCertificateFast 10 3034 fastCert10_3034=true := by decide +kernel
def fastCert10_3035 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3035 : checkCertificateFast 10 3035 fastCert10_3035=true := by decide +kernel
def fastCert10_3036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3036 : checkCertificateFast 10 3036 fastCert10_3036=true := by decide +kernel
def fastCert10_3037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3037 : checkCertificateFast 10 3037 fastCert10_3037=true := by decide +kernel
def fastCert10_3038 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3038 : checkCertificateFast 10 3038 fastCert10_3038=true := by decide +kernel
def fastCert10_3039 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3039 : checkCertificateFast 10 3039 fastCert10_3039=true := by decide +kernel
def fastCert10_3040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3040 : checkCertificateFast 10 3040 fastCert10_3040=true := by decide +kernel
def fastCert10_3041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3041 : checkCertificateFast 10 3041 fastCert10_3041=true := by decide +kernel
def fastCert10_3042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_3042 : checkCertificateFast 10 3042 fastCert10_3042=true := by decide +kernel
def fastCert10_3043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-4) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3043 : checkCertificateFast 10 3043 fastCert10_3043=true := by decide +kernel
def fastCert10_3044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_3044 : checkCertificateFast 10 3044 fastCert10_3044=true := by decide +kernel
def fastCert10_3045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3045 : checkCertificateFast 10 3045 fastCert10_3045=true := by decide +kernel
def fastCert10_3046 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3046 : checkCertificateFast 10 3046 fastCert10_3046=true := by decide +kernel
def fastCert10_3047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3047 : checkCertificateFast 10 3047 fastCert10_3047=true := by decide +kernel
def fastCert10_3048 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3048 : checkCertificateFast 10 3048 fastCert10_3048=true := by decide +kernel
def fastCert10_3049 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3049 : checkCertificateFast 10 3049 fastCert10_3049=true := by decide +kernel
def fastCert10_3050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3050 : checkCertificateFast 10 3050 fastCert10_3050=true := by decide +kernel
def fastCert10_3051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3051 : checkCertificateFast 10 3051 fastCert10_3051=true := by decide +kernel
def fastCert10_3052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3052 : checkCertificateFast 10 3052 fastCert10_3052=true := by decide +kernel
def fastCert10_3053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3053 : checkCertificateFast 10 3053 fastCert10_3053=true := by decide +kernel
def fastCert10_3054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3054 : checkCertificateFast 10 3054 fastCert10_3054=true := by decide +kernel
def fastCert10_3055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3055 : checkCertificateFast 10 3055 fastCert10_3055=true := by decide +kernel
def fastCert10_3056 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_3056 : checkCertificateFast 10 3056 fastCert10_3056=true := by decide +kernel
def fastCert10_3057 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_3057 : checkCertificateFast 10 3057 fastCert10_3057=true := by decide +kernel
def fastCert10_3058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (3) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=6 then (-5) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (4) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3058 : checkCertificateFast 10 3058 fastCert10_3058=true := by decide +kernel
def fastCert10_3059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3059 : checkCertificateFast 10 3059 fastCert10_3059=true := by decide +kernel
def fastCert10_3060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3060 : checkCertificateFast 10 3060 fastCert10_3060=true := by decide +kernel
def fastCert10_3061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3061 : checkCertificateFast 10 3061 fastCert10_3061=true := by decide +kernel
def fastCert10_3062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3062 : checkCertificateFast 10 3062 fastCert10_3062=true := by decide +kernel
def fastCert10_3063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3063 : checkCertificateFast 10 3063 fastCert10_3063=true := by decide +kernel
def fastCert10_3064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3064 : checkCertificateFast 10 3064 fastCert10_3064=true := by decide +kernel
def fastCert10_3065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3065 : checkCertificateFast 10 3065 fastCert10_3065=true := by decide +kernel
def fastCert10_3066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3066 : checkCertificateFast 10 3066 fastCert10_3066=true := by decide +kernel
def fastCert10_3067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3067 : checkCertificateFast 10 3067 fastCert10_3067=true := by decide +kernel
def fastCert10_3068 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3068 : checkCertificateFast 10 3068 fastCert10_3068=true := by decide +kernel
def fastCert10_3069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3069 : checkCertificateFast 10 3069 fastCert10_3069=true := by decide +kernel
def fastCert10_3070 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3070 : checkCertificateFast 10 3070 fastCert10_3070=true := by decide +kernel
def fastCert10_3071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3071 : checkCertificateFast 10 3071 fastCert10_3071=true := by decide +kernel
def fastCert10_3072 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3072 : checkCertificateFast 10 3072 fastCert10_3072=true := by decide +kernel
def fastCert10_3073 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3073 : checkCertificateFast 10 3073 fastCert10_3073=true := by decide +kernel
def fastCert10_3074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3074 : checkCertificateFast 10 3074 fastCert10_3074=true := by decide +kernel
def fastCert10_3075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3075 : checkCertificateFast 10 3075 fastCert10_3075=true := by decide +kernel
def fastCert10_3076 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3076 : checkCertificateFast 10 3076 fastCert10_3076=true := by decide +kernel
def fastCert10_3077 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3077 : checkCertificateFast 10 3077 fastCert10_3077=true := by decide +kernel
def fastCert10_3078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3078 : checkCertificateFast 10 3078 fastCert10_3078=true := by decide +kernel
def fastCert10_3079 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3079 : checkCertificateFast 10 3079 fastCert10_3079=true := by decide +kernel
def fastCert10_3080 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3080 : checkCertificateFast 10 3080 fastCert10_3080=true := by decide +kernel
def fastCert10_3081 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3081 : checkCertificateFast 10 3081 fastCert10_3081=true := by decide +kernel
def fastCert10_3082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3082 : checkCertificateFast 10 3082 fastCert10_3082=true := by decide +kernel
def fastCert10_3083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3083 : checkCertificateFast 10 3083 fastCert10_3083=true := by decide +kernel
def fastCert10_3084 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3084 : checkCertificateFast 10 3084 fastCert10_3084=true := by decide +kernel
def fastCert10_3085 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3085 : checkCertificateFast 10 3085 fastCert10_3085=true := by decide +kernel
def fastCert10_3086 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3086 : checkCertificateFast 10 3086 fastCert10_3086=true := by decide +kernel
def fastCert10_3087 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3087 : checkCertificateFast 10 3087 fastCert10_3087=true := by decide +kernel
def fastCert10_3088 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3088 : checkCertificateFast 10 3088 fastCert10_3088=true := by decide +kernel
def fastCert10_3089 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3089 : checkCertificateFast 10 3089 fastCert10_3089=true := by decide +kernel
def fastCert10_3090 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3090 : checkCertificateFast 10 3090 fastCert10_3090=true := by decide +kernel
def fastCert10_3091 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3091 : checkCertificateFast 10 3091 fastCert10_3091=true := by decide +kernel
def fastCert10_3092 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3092 : checkCertificateFast 10 3092 fastCert10_3092=true := by decide +kernel
def fastCert10_3093 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3093 : checkCertificateFast 10 3093 fastCert10_3093=true := by decide +kernel
def fastCert10_3094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3094 : checkCertificateFast 10 3094 fastCert10_3094=true := by decide +kernel
def fastCert10_3095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3095 : checkCertificateFast 10 3095 fastCert10_3095=true := by decide +kernel
def fastCert10_3096 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3096 : checkCertificateFast 10 3096 fastCert10_3096=true := by decide +kernel
def fastCert10_3097 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3097 : checkCertificateFast 10 3097 fastCert10_3097=true := by decide +kernel
def fastCert10_3098 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3098 : checkCertificateFast 10 3098 fastCert10_3098=true := by decide +kernel
def fastCert10_3099 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3099 : checkCertificateFast 10 3099 fastCert10_3099=true := by decide +kernel
def fastCert10_3100 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3100 : checkCertificateFast 10 3100 fastCert10_3100=true := by decide +kernel
def fastCert10_3101 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3101 : checkCertificateFast 10 3101 fastCert10_3101=true := by decide +kernel
def fastCert10_3102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3102 : checkCertificateFast 10 3102 fastCert10_3102=true := by decide +kernel
def fastCert10_3103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3103 : checkCertificateFast 10 3103 fastCert10_3103=true := by decide +kernel
def fastCert10_3104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3104 : checkCertificateFast 10 3104 fastCert10_3104=true := by decide +kernel
def fastCert10_3105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3105 : checkCertificateFast 10 3105 fastCert10_3105=true := by decide +kernel
def fastCert10_3106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3106 : checkCertificateFast 10 3106 fastCert10_3106=true := by decide +kernel
def fastCert10_3107 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3107 : checkCertificateFast 10 3107 fastCert10_3107=true := by decide +kernel
def fastCert10_3108 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3108 : checkCertificateFast 10 3108 fastCert10_3108=true := by decide +kernel
def fastCert10_3109 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3109 : checkCertificateFast 10 3109 fastCert10_3109=true := by decide +kernel
def fastCert10_3110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3110 : checkCertificateFast 10 3110 fastCert10_3110=true := by decide +kernel
def fastCert10_3111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3111 : checkCertificateFast 10 3111 fastCert10_3111=true := by decide +kernel
def fastCert10_3112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3112 : checkCertificateFast 10 3112 fastCert10_3112=true := by decide +kernel
def fastCert10_3113 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3113 : checkCertificateFast 10 3113 fastCert10_3113=true := by decide +kernel
def fastCert10_3114 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3114 : checkCertificateFast 10 3114 fastCert10_3114=true := by decide +kernel
def fastCert10_3115 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3115 : checkCertificateFast 10 3115 fastCert10_3115=true := by decide +kernel
def fastCert10_3116 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3116 : checkCertificateFast 10 3116 fastCert10_3116=true := by decide +kernel
def fastCert10_3117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3117 : checkCertificateFast 10 3117 fastCert10_3117=true := by decide +kernel
def fastCert10_3118 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3118 : checkCertificateFast 10 3118 fastCert10_3118=true := by decide +kernel
def fastCert10_3119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3119 : checkCertificateFast 10 3119 fastCert10_3119=true := by decide +kernel
def fastCert10_3120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3120 : checkCertificateFast 10 3120 fastCert10_3120=true := by decide +kernel
def fastCert10_3121 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3121 : checkCertificateFast 10 3121 fastCert10_3121=true := by decide +kernel
def fastCert10_3122 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3122 : checkCertificateFast 10 3122 fastCert10_3122=true := by decide +kernel
def fastCert10_3123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3123 : checkCertificateFast 10 3123 fastCert10_3123=true := by decide +kernel
def fastCert10_3124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3124 : checkCertificateFast 10 3124 fastCert10_3124=true := by decide +kernel
def fastCert10_3125 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3125 : checkCertificateFast 10 3125 fastCert10_3125=true := by decide +kernel
def fastCert10_3126 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3126 : checkCertificateFast 10 3126 fastCert10_3126=true := by decide +kernel
def fastCert10_3127 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3127 : checkCertificateFast 10 3127 fastCert10_3127=true := by decide +kernel
def fastCert10_3128 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3128 : checkCertificateFast 10 3128 fastCert10_3128=true := by decide +kernel
def fastCert10_3129 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3129 : checkCertificateFast 10 3129 fastCert10_3129=true := by decide +kernel
def fastCert10_3130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3130 : checkCertificateFast 10 3130 fastCert10_3130=true := by decide +kernel
def fastCert10_3131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3131 : checkCertificateFast 10 3131 fastCert10_3131=true := by decide +kernel
def fastCert10_3132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3132 : checkCertificateFast 10 3132 fastCert10_3132=true := by decide +kernel
def fastCert10_3133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3133 : checkCertificateFast 10 3133 fastCert10_3133=true := by decide +kernel
def fastCert10_3134 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3134 : checkCertificateFast 10 3134 fastCert10_3134=true := by decide +kernel
def fastCert10_3135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3135 : checkCertificateFast 10 3135 fastCert10_3135=true := by decide +kernel
def fastCert10_3136 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3136 : checkCertificateFast 10 3136 fastCert10_3136=true := by decide +kernel
def fastCert10_3137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3137 : checkCertificateFast 10 3137 fastCert10_3137=true := by decide +kernel
def fastCert10_3138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3138 : checkCertificateFast 10 3138 fastCert10_3138=true := by decide +kernel
def fastCert10_3139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3139 : checkCertificateFast 10 3139 fastCert10_3139=true := by decide +kernel
def fastCert10_3140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3140 : checkCertificateFast 10 3140 fastCert10_3140=true := by decide +kernel
def fastCert10_3141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3141 : checkCertificateFast 10 3141 fastCert10_3141=true := by decide +kernel
def fastCert10_3142 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3142 : checkCertificateFast 10 3142 fastCert10_3142=true := by decide +kernel
def fastCert10_3143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3143 : checkCertificateFast 10 3143 fastCert10_3143=true := by decide +kernel
def fastCert10_3144 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3144 : checkCertificateFast 10 3144 fastCert10_3144=true := by decide +kernel
def fastCert10_3145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3145 : checkCertificateFast 10 3145 fastCert10_3145=true := by decide +kernel
def fastCert10_3146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3146 : checkCertificateFast 10 3146 fastCert10_3146=true := by decide +kernel
def fastCert10_3147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3147 : checkCertificateFast 10 3147 fastCert10_3147=true := by decide +kernel
def fastCert10_3148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3148 : checkCertificateFast 10 3148 fastCert10_3148=true := by decide +kernel
def fastCert10_3149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3149 : checkCertificateFast 10 3149 fastCert10_3149=true := by decide +kernel
def fastCert10_3150 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3150 : checkCertificateFast 10 3150 fastCert10_3150=true := by decide +kernel
def fastCert10_3151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3151 : checkCertificateFast 10 3151 fastCert10_3151=true := by decide +kernel
def fastCert10_3152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3152 : checkCertificateFast 10 3152 fastCert10_3152=true := by decide +kernel
def fastCert10_3153 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3153 : checkCertificateFast 10 3153 fastCert10_3153=true := by decide +kernel
def fastCert10_3154 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3154 : checkCertificateFast 10 3154 fastCert10_3154=true := by decide +kernel
def fastCert10_3155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3155 : checkCertificateFast 10 3155 fastCert10_3155=true := by decide +kernel
def fastCert10_3156 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3156 : checkCertificateFast 10 3156 fastCert10_3156=true := by decide +kernel
def fastCert10_3157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3157 : checkCertificateFast 10 3157 fastCert10_3157=true := by decide +kernel
def fastCert10_3158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3158 : checkCertificateFast 10 3158 fastCert10_3158=true := by decide +kernel
def fastCert10_3159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3159 : checkCertificateFast 10 3159 fastCert10_3159=true := by decide +kernel
def fastCert10_3160 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3160 : checkCertificateFast 10 3160 fastCert10_3160=true := by decide +kernel
def fastCert10_3161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3161 : checkCertificateFast 10 3161 fastCert10_3161=true := by decide +kernel
def fastCert10_3162 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3162 : checkCertificateFast 10 3162 fastCert10_3162=true := by decide +kernel
def fastCert10_3163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3163 : checkCertificateFast 10 3163 fastCert10_3163=true := by decide +kernel
def fastCert10_3164 : Certificate := ⟨33,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3164 : checkCertificateFast 10 3164 fastCert10_3164=true := by decide +kernel
def fastCert10_3165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3165 : checkCertificateFast 10 3165 fastCert10_3165=true := by decide +kernel
def fastCert10_3166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3166 : checkCertificateFast 10 3166 fastCert10_3166=true := by decide +kernel
def fastCert10_3167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3167 : checkCertificateFast 10 3167 fastCert10_3167=true := by decide +kernel
def fastCert10_3168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3168 : checkCertificateFast 10 3168 fastCert10_3168=true := by decide +kernel
def fastCert10_3169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3169 : checkCertificateFast 10 3169 fastCert10_3169=true := by decide +kernel
def fastCert10_3170 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3170 : checkCertificateFast 10 3170 fastCert10_3170=true := by decide +kernel
def fastCert10_3171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3171 : checkCertificateFast 10 3171 fastCert10_3171=true := by decide +kernel
def fastCert10_3172 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3172 : checkCertificateFast 10 3172 fastCert10_3172=true := by decide +kernel
def fastCert10_3173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3173 : checkCertificateFast 10 3173 fastCert10_3173=true := by decide +kernel
def fastCert10_3174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3174 : checkCertificateFast 10 3174 fastCert10_3174=true := by decide +kernel
def fastCert10_3175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3175 : checkCertificateFast 10 3175 fastCert10_3175=true := by decide +kernel
def fastCert10_3176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3176 : checkCertificateFast 10 3176 fastCert10_3176=true := by decide +kernel
def fastCert10_3177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3177 : checkCertificateFast 10 3177 fastCert10_3177=true := by decide +kernel
def fastCert10_3178 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3178 : checkCertificateFast 10 3178 fastCert10_3178=true := by decide +kernel
def fastCert10_3179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3179 : checkCertificateFast 10 3179 fastCert10_3179=true := by decide +kernel
def fastCert10_3180 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3180 : checkCertificateFast 10 3180 fastCert10_3180=true := by decide +kernel
def fastCert10_3181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3181 : checkCertificateFast 10 3181 fastCert10_3181=true := by decide +kernel
def fastCert10_3182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3182 : checkCertificateFast 10 3182 fastCert10_3182=true := by decide +kernel
def fastCert10_3183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3183 : checkCertificateFast 10 3183 fastCert10_3183=true := by decide +kernel
def fastCert10_3184 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3184 : checkCertificateFast 10 3184 fastCert10_3184=true := by decide +kernel
def fastCert10_3185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3185 : checkCertificateFast 10 3185 fastCert10_3185=true := by decide +kernel
def fastCert10_3186 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3186 : checkCertificateFast 10 3186 fastCert10_3186=true := by decide +kernel
def fastCert10_3187 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3187 : checkCertificateFast 10 3187 fastCert10_3187=true := by decide +kernel
def fastCert10_3188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3188 : checkCertificateFast 10 3188 fastCert10_3188=true := by decide +kernel
def fastCert10_3189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3189 : checkCertificateFast 10 3189 fastCert10_3189=true := by decide +kernel
def fastCert10_3190 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3190 : checkCertificateFast 10 3190 fastCert10_3190=true := by decide +kernel
def fastCert10_3191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3191 : checkCertificateFast 10 3191 fastCert10_3191=true := by decide +kernel
def fastCert10_3192 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3192 : checkCertificateFast 10 3192 fastCert10_3192=true := by decide +kernel
def fastCert10_3193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3193 : checkCertificateFast 10 3193 fastCert10_3193=true := by decide +kernel
def fastCert10_3194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3194 : checkCertificateFast 10 3194 fastCert10_3194=true := by decide +kernel
def fastCert10_3195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3195 : checkCertificateFast 10 3195 fastCert10_3195=true := by decide +kernel
def fastCert10_3196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3196 : checkCertificateFast 10 3196 fastCert10_3196=true := by decide +kernel
def fastCert10_3197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3197 : checkCertificateFast 10 3197 fastCert10_3197=true := by decide +kernel
def fastCert10_3198 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3198 : checkCertificateFast 10 3198 fastCert10_3198=true := by decide +kernel
def fastCert10_3199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3199 : checkCertificateFast 10 3199 fastCert10_3199=true := by decide +kernel
def fastCert10_3200 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3200 : checkCertificateFast 10 3200 fastCert10_3200=true := by decide +kernel
def fastCert10_3201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3201 : checkCertificateFast 10 3201 fastCert10_3201=true := by decide +kernel
def fastCert10_3202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3202 : checkCertificateFast 10 3202 fastCert10_3202=true := by decide +kernel
def fastCert10_3203 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3203 : checkCertificateFast 10 3203 fastCert10_3203=true := by decide +kernel
def fastCert10_3204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3204 : checkCertificateFast 10 3204 fastCert10_3204=true := by decide +kernel
def fastCert10_3205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3205 : checkCertificateFast 10 3205 fastCert10_3205=true := by decide +kernel
def fastCert10_3206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3206 : checkCertificateFast 10 3206 fastCert10_3206=true := by decide +kernel
def fastCert10_3207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3207 : checkCertificateFast 10 3207 fastCert10_3207=true := by decide +kernel
def fastCert10_3208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3208 : checkCertificateFast 10 3208 fastCert10_3208=true := by decide +kernel
def fastCert10_3209 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3209 : checkCertificateFast 10 3209 fastCert10_3209=true := by decide +kernel
def fastCert10_3210 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3210 : checkCertificateFast 10 3210 fastCert10_3210=true := by decide +kernel
def fastCert10_3211 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3211 : checkCertificateFast 10 3211 fastCert10_3211=true := by decide +kernel
def fastCert10_3212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3212 : checkCertificateFast 10 3212 fastCert10_3212=true := by decide +kernel
def fastCert10_3213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3213 : checkCertificateFast 10 3213 fastCert10_3213=true := by decide +kernel
def fastCert10_3214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3214 : checkCertificateFast 10 3214 fastCert10_3214=true := by decide +kernel
def fastCert10_3215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3215 : checkCertificateFast 10 3215 fastCert10_3215=true := by decide +kernel
def fastCert10_3216 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3216 : checkCertificateFast 10 3216 fastCert10_3216=true := by decide +kernel
def fastCert10_3217 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3217 : checkCertificateFast 10 3217 fastCert10_3217=true := by decide +kernel
def fastCert10_3218 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3218 : checkCertificateFast 10 3218 fastCert10_3218=true := by decide +kernel
def fastCert10_3219 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3219 : checkCertificateFast 10 3219 fastCert10_3219=true := by decide +kernel
def fastCert10_3220 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3220 : checkCertificateFast 10 3220 fastCert10_3220=true := by decide +kernel
def fastCert10_3221 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3221 : checkCertificateFast 10 3221 fastCert10_3221=true := by decide +kernel
def fastCert10_3222 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3222 : checkCertificateFast 10 3222 fastCert10_3222=true := by decide +kernel
def fastCert10_3223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3223 : checkCertificateFast 10 3223 fastCert10_3223=true := by decide +kernel
def fastCert10_3224 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3224 : checkCertificateFast 10 3224 fastCert10_3224=true := by decide +kernel
def fastCert10_3225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3225 : checkCertificateFast 10 3225 fastCert10_3225=true := by decide +kernel
def fastCert10_3226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3226 : checkCertificateFast 10 3226 fastCert10_3226=true := by decide +kernel
def fastCert10_3227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3227 : checkCertificateFast 10 3227 fastCert10_3227=true := by decide +kernel
def fastCert10_3228 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3228 : checkCertificateFast 10 3228 fastCert10_3228=true := by decide +kernel
def fastCert10_3229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3229 : checkCertificateFast 10 3229 fastCert10_3229=true := by decide +kernel
def fastCert10_3230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3230 : checkCertificateFast 10 3230 fastCert10_3230=true := by decide +kernel
def fastCert10_3231 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3231 : checkCertificateFast 10 3231 fastCert10_3231=true := by decide +kernel
def fastCert10_3232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3232 : checkCertificateFast 10 3232 fastCert10_3232=true := by decide +kernel
def fastCert10_3233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3233 : checkCertificateFast 10 3233 fastCert10_3233=true := by decide +kernel
def fastCert10_3234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3234 : checkCertificateFast 10 3234 fastCert10_3234=true := by decide +kernel
def fastCert10_3235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3235 : checkCertificateFast 10 3235 fastCert10_3235=true := by decide +kernel
def fastCert10_3236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3236 : checkCertificateFast 10 3236 fastCert10_3236=true := by decide +kernel
def fastCert10_3237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3237 : checkCertificateFast 10 3237 fastCert10_3237=true := by decide +kernel
def fastCert10_3238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3238 : checkCertificateFast 10 3238 fastCert10_3238=true := by decide +kernel
def fastCert10_3239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3239 : checkCertificateFast 10 3239 fastCert10_3239=true := by decide +kernel
def fastCert10_3240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3240 : checkCertificateFast 10 3240 fastCert10_3240=true := by decide +kernel
def fastCert10_3241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3241 : checkCertificateFast 10 3241 fastCert10_3241=true := by decide +kernel
def fastCert10_3242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3242 : checkCertificateFast 10 3242 fastCert10_3242=true := by decide +kernel
def fastCert10_3243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3243 : checkCertificateFast 10 3243 fastCert10_3243=true := by decide +kernel
def fastCert10_3244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3244 : checkCertificateFast 10 3244 fastCert10_3244=true := by decide +kernel
def fastCert10_3245 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3245 : checkCertificateFast 10 3245 fastCert10_3245=true := by decide +kernel
def fastCert10_3246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3246 : checkCertificateFast 10 3246 fastCert10_3246=true := by decide +kernel
def fastCert10_3247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3247 : checkCertificateFast 10 3247 fastCert10_3247=true := by decide +kernel
def fastCert10_3248 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3248 : checkCertificateFast 10 3248 fastCert10_3248=true := by decide +kernel
def fastCert10_3249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3249 : checkCertificateFast 10 3249 fastCert10_3249=true := by decide +kernel
def fastCert10_3250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3250 : checkCertificateFast 10 3250 fastCert10_3250=true := by decide +kernel
def fastCert10_3251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3251 : checkCertificateFast 10 3251 fastCert10_3251=true := by decide +kernel
def fastCert10_3252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3252 : checkCertificateFast 10 3252 fastCert10_3252=true := by decide +kernel
def fastCert10_3253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3253 : checkCertificateFast 10 3253 fastCert10_3253=true := by decide +kernel
def fastCert10_3254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3254 : checkCertificateFast 10 3254 fastCert10_3254=true := by decide +kernel
def fastCert10_3255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3255 : checkCertificateFast 10 3255 fastCert10_3255=true := by decide +kernel
def fastCert10_3256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3256 : checkCertificateFast 10 3256 fastCert10_3256=true := by decide +kernel
def fastCert10_3257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3257 : checkCertificateFast 10 3257 fastCert10_3257=true := by decide +kernel
def fastCert10_3258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3258 : checkCertificateFast 10 3258 fastCert10_3258=true := by decide +kernel
def fastCert10_3259 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3259 : checkCertificateFast 10 3259 fastCert10_3259=true := by decide +kernel
def fastCert10_3260 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3260 : checkCertificateFast 10 3260 fastCert10_3260=true := by decide +kernel
def fastCert10_3261 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3261 : checkCertificateFast 10 3261 fastCert10_3261=true := by decide +kernel
def fastCert10_3262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3262 : checkCertificateFast 10 3262 fastCert10_3262=true := by decide +kernel
def fastCert10_3263 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3263 : checkCertificateFast 10 3263 fastCert10_3263=true := by decide +kernel
def fastCert10_3264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3264 : checkCertificateFast 10 3264 fastCert10_3264=true := by decide +kernel
def fastCert10_3265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3265 : checkCertificateFast 10 3265 fastCert10_3265=true := by decide +kernel
def fastCert10_3266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3266 : checkCertificateFast 10 3266 fastCert10_3266=true := by decide +kernel
def fastCert10_3267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3267 : checkCertificateFast 10 3267 fastCert10_3267=true := by decide +kernel
def fastCert10_3268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3268 : checkCertificateFast 10 3268 fastCert10_3268=true := by decide +kernel
def fastCert10_3269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3269 : checkCertificateFast 10 3269 fastCert10_3269=true := by decide +kernel
def fastCert10_3270 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3270 : checkCertificateFast 10 3270 fastCert10_3270=true := by decide +kernel
def fastCert10_3271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3271 : checkCertificateFast 10 3271 fastCert10_3271=true := by decide +kernel
def fastCert10_3272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3272 : checkCertificateFast 10 3272 fastCert10_3272=true := by decide +kernel
def fastCert10_3273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3273 : checkCertificateFast 10 3273 fastCert10_3273=true := by decide +kernel
def fastCert10_3274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3274 : checkCertificateFast 10 3274 fastCert10_3274=true := by decide +kernel
def fastCert10_3275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3275 : checkCertificateFast 10 3275 fastCert10_3275=true := by decide +kernel
def fastCert10_3276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-3) else if t=0 ∧ i=1 then (4) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (-3) else if t=0 ∧ i=6 then (-5) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (3) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3276 : checkCertificateFast 10 3276 fastCert10_3276=true := by decide +kernel
def fastCert10_3277 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3277 : checkCertificateFast 10 3277 fastCert10_3277=true := by decide +kernel
def fastCert10_3278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3278 : checkCertificateFast 10 3278 fastCert10_3278=true := by decide +kernel
def fastCert10_3279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3279 : checkCertificateFast 10 3279 fastCert10_3279=true := by decide +kernel
def fastCert10_3280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3280 : checkCertificateFast 10 3280 fastCert10_3280=true := by decide +kernel
def fastCert10_3281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3281 : checkCertificateFast 10 3281 fastCert10_3281=true := by decide +kernel
def fastCert10_3282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3282 : checkCertificateFast 10 3282 fastCert10_3282=true := by decide +kernel
def fastCert10_3283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3283 : checkCertificateFast 10 3283 fastCert10_3283=true := by decide +kernel
def fastCert10_3284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3284 : checkCertificateFast 10 3284 fastCert10_3284=true := by decide +kernel
def fastCert10_3285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3285 : checkCertificateFast 10 3285 fastCert10_3285=true := by decide +kernel
def fastCert10_3286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3286 : checkCertificateFast 10 3286 fastCert10_3286=true := by decide +kernel
def fastCert10_3287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3287 : checkCertificateFast 10 3287 fastCert10_3287=true := by decide +kernel
def fastCert10_3288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (-5) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (5) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3288 : checkCertificateFast 10 3288 fastCert10_3288=true := by decide +kernel
def fastCert10_3289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3289 : checkCertificateFast 10 3289 fastCert10_3289=true := by decide +kernel
def fastCert10_3290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (3) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (-6) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (5) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3290 : checkCertificateFast 10 3290 fastCert10_3290=true := by decide +kernel
def fastCert10_3291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3291 : checkCertificateFast 10 3291 fastCert10_3291=true := by decide +kernel
def fastCert10_3292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (4) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3292 : checkCertificateFast 10 3292 fastCert10_3292=true := by decide +kernel
def fastCert10_3293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3293 : checkCertificateFast 10 3293 fastCert10_3293=true := by decide +kernel
def fastCert10_3294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3294 : checkCertificateFast 10 3294 fastCert10_3294=true := by decide +kernel
def fastCert10_3295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3295 : checkCertificateFast 10 3295 fastCert10_3295=true := by decide +kernel
def fastCert10_3296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3296 : checkCertificateFast 10 3296 fastCert10_3296=true := by decide +kernel
def fastCert10_3297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3297 : checkCertificateFast 10 3297 fastCert10_3297=true := by decide +kernel
def fastCert10_3298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3298 : checkCertificateFast 10 3298 fastCert10_3298=true := by decide +kernel
def fastCert10_3299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3299 : checkCertificateFast 10 3299 fastCert10_3299=true := by decide +kernel
def fastCert10_3300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3300 : checkCertificateFast 10 3300 fastCert10_3300=true := by decide +kernel
def fastCert10_3301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3301 : checkCertificateFast 10 3301 fastCert10_3301=true := by decide +kernel
def fastCert10_3302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3302 : checkCertificateFast 10 3302 fastCert10_3302=true := by decide +kernel
def fastCert10_3303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3303 : checkCertificateFast 10 3303 fastCert10_3303=true := by decide +kernel
def fastCert10_3304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3304 : checkCertificateFast 10 3304 fastCert10_3304=true := by decide +kernel
def fastCert10_3305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3305 : checkCertificateFast 10 3305 fastCert10_3305=true := by decide +kernel
def fastCert10_3306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (3) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-3) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3306 : checkCertificateFast 10 3306 fastCert10_3306=true := by decide +kernel
def fastCert10_3307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3307 : checkCertificateFast 10 3307 fastCert10_3307=true := by decide +kernel
def fastCert10_3308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3308 : checkCertificateFast 10 3308 fastCert10_3308=true := by decide +kernel
def fastCert10_3309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3309 : checkCertificateFast 10 3309 fastCert10_3309=true := by decide +kernel
def fastCert10_3310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3310 : checkCertificateFast 10 3310 fastCert10_3310=true := by decide +kernel
def fastCert10_3311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3311 : checkCertificateFast 10 3311 fastCert10_3311=true := by decide +kernel
def fastCert10_3312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3312 : checkCertificateFast 10 3312 fastCert10_3312=true := by decide +kernel
def fastCert10_3313 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3313 : checkCertificateFast 10 3313 fastCert10_3313=true := by decide +kernel
def fastCert10_3314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_3314 : checkCertificateFast 10 3314 fastCert10_3314=true := by decide +kernel
def fastCert10_3315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3315 : checkCertificateFast 10 3315 fastCert10_3315=true := by decide +kernel
def fastCert10_3316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3316 : checkCertificateFast 10 3316 fastCert10_3316=true := by decide +kernel
def fastCert10_3317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3317 : checkCertificateFast 10 3317 fastCert10_3317=true := by decide +kernel
def fastCert10_3318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3318 : checkCertificateFast 10 3318 fastCert10_3318=true := by decide +kernel
def fastCert10_3319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3319 : checkCertificateFast 10 3319 fastCert10_3319=true := by decide +kernel
def fastCert10_3320 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3320 : checkCertificateFast 10 3320 fastCert10_3320=true := by decide +kernel
def fastCert10_3321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3321 : checkCertificateFast 10 3321 fastCert10_3321=true := by decide +kernel
def fastCert10_3322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (4) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (5) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3322 : checkCertificateFast 10 3322 fastCert10_3322=true := by decide +kernel
def fastCert10_3323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3323 : checkCertificateFast 10 3323 fastCert10_3323=true := by decide +kernel
def fastCert10_3324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3324 : checkCertificateFast 10 3324 fastCert10_3324=true := by decide +kernel
def fastCert10_3325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3325 : checkCertificateFast 10 3325 fastCert10_3325=true := by decide +kernel
def fastCert10_3326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3326 : checkCertificateFast 10 3326 fastCert10_3326=true := by decide +kernel
def fastCert10_3327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3327 : checkCertificateFast 10 3327 fastCert10_3327=true := by decide +kernel
def fastCert10_3328 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3328 : checkCertificateFast 10 3328 fastCert10_3328=true := by decide +kernel
def fastCert10_3329 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3329 : checkCertificateFast 10 3329 fastCert10_3329=true := by decide +kernel
def fastCert10_3330 : Certificate := ⟨12,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3330 : checkCertificateFast 10 3330 fastCert10_3330=true := by decide +kernel
def fastCert10_3331 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3331 : checkCertificateFast 10 3331 fastCert10_3331=true := by decide +kernel
def fastCert10_3332 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3332 : checkCertificateFast 10 3332 fastCert10_3332=true := by decide +kernel
def fastCert10_3333 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3333 : checkCertificateFast 10 3333 fastCert10_3333=true := by decide +kernel
def fastCert10_3334 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3334 : checkCertificateFast 10 3334 fastCert10_3334=true := by decide +kernel
def fastCert10_3335 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3335 : checkCertificateFast 10 3335 fastCert10_3335=true := by decide +kernel
def fastCert10_3336 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3336 : checkCertificateFast 10 3336 fastCert10_3336=true := by decide +kernel
def fastCert10_3337 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3337 : checkCertificateFast 10 3337 fastCert10_3337=true := by decide +kernel
def fastCert10_3338 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3338 : checkCertificateFast 10 3338 fastCert10_3338=true := by decide +kernel
def fastCert10_3339 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3339 : checkCertificateFast 10 3339 fastCert10_3339=true := by decide +kernel
def fastCert10_3340 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3340 : checkCertificateFast 10 3340 fastCert10_3340=true := by decide +kernel
def fastCert10_3341 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3341 : checkCertificateFast 10 3341 fastCert10_3341=true := by decide +kernel
def fastCert10_3342 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3342 : checkCertificateFast 10 3342 fastCert10_3342=true := by decide +kernel
def fastCert10_3343 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3343 : checkCertificateFast 10 3343 fastCert10_3343=true := by decide +kernel
def fastCert10_3344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3344 : checkCertificateFast 10 3344 fastCert10_3344=true := by decide +kernel
def fastCert10_3345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3345 : checkCertificateFast 10 3345 fastCert10_3345=true := by decide +kernel
def fastCert10_3346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3346 : checkCertificateFast 10 3346 fastCert10_3346=true := by decide +kernel
def fastCert10_3347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3347 : checkCertificateFast 10 3347 fastCert10_3347=true := by decide +kernel
def fastCert10_3348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3348 : checkCertificateFast 10 3348 fastCert10_3348=true := by decide +kernel
def fastCert10_3349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3349 : checkCertificateFast 10 3349 fastCert10_3349=true := by decide +kernel
def fastCert10_3350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3350 : checkCertificateFast 10 3350 fastCert10_3350=true := by decide +kernel
def fastCert10_3351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3351 : checkCertificateFast 10 3351 fastCert10_3351=true := by decide +kernel
def fastCert10_3352 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3352 : checkCertificateFast 10 3352 fastCert10_3352=true := by decide +kernel
def fastCert10_3353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3353 : checkCertificateFast 10 3353 fastCert10_3353=true := by decide +kernel
def fastCert10_3354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3354 : checkCertificateFast 10 3354 fastCert10_3354=true := by decide +kernel
def fastCert10_3355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3355 : checkCertificateFast 10 3355 fastCert10_3355=true := by decide +kernel
def fastCert10_3356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3356 : checkCertificateFast 10 3356 fastCert10_3356=true := by decide +kernel
def fastCert10_3357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3357 : checkCertificateFast 10 3357 fastCert10_3357=true := by decide +kernel
def fastCert10_3358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3358 : checkCertificateFast 10 3358 fastCert10_3358=true := by decide +kernel
def fastCert10_3359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3359 : checkCertificateFast 10 3359 fastCert10_3359=true := by decide +kernel
def fastCert10_3360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3360 : checkCertificateFast 10 3360 fastCert10_3360=true := by decide +kernel
def fastCert10_3361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3361 : checkCertificateFast 10 3361 fastCert10_3361=true := by decide +kernel
def fastCert10_3362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3362 : checkCertificateFast 10 3362 fastCert10_3362=true := by decide +kernel
def fastCert10_3363 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3363 : checkCertificateFast 10 3363 fastCert10_3363=true := by decide +kernel
def fastCert10_3364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3364 : checkCertificateFast 10 3364 fastCert10_3364=true := by decide +kernel
def fastCert10_3365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3365 : checkCertificateFast 10 3365 fastCert10_3365=true := by decide +kernel
def fastCert10_3366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3366 : checkCertificateFast 10 3366 fastCert10_3366=true := by decide +kernel
def fastCert10_3367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3367 : checkCertificateFast 10 3367 fastCert10_3367=true := by decide +kernel
def fastCert10_3368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3368 : checkCertificateFast 10 3368 fastCert10_3368=true := by decide +kernel
def fastCert10_3369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3369 : checkCertificateFast 10 3369 fastCert10_3369=true := by decide +kernel
def fastCert10_3370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_3370 : checkCertificateFast 10 3370 fastCert10_3370=true := by decide +kernel
def fastCert10_3371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3371 : checkCertificateFast 10 3371 fastCert10_3371=true := by decide +kernel
def fastCert10_3372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3372 : checkCertificateFast 10 3372 fastCert10_3372=true := by decide +kernel
def fastCert10_3373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3373 : checkCertificateFast 10 3373 fastCert10_3373=true := by decide +kernel
def fastCert10_3374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3374 : checkCertificateFast 10 3374 fastCert10_3374=true := by decide +kernel
def fastCert10_3375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3375 : checkCertificateFast 10 3375 fastCert10_3375=true := by decide +kernel
def fastCert10_3376 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3376 : checkCertificateFast 10 3376 fastCert10_3376=true := by decide +kernel
def fastCert10_3377 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3377 : checkCertificateFast 10 3377 fastCert10_3377=true := by decide +kernel
def fastCert10_3378 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3378 : checkCertificateFast 10 3378 fastCert10_3378=true := by decide +kernel
def fastCert10_3379 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3379 : checkCertificateFast 10 3379 fastCert10_3379=true := by decide +kernel
def fastCert10_3380 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3380 : checkCertificateFast 10 3380 fastCert10_3380=true := by decide +kernel
def fastCert10_3381 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3381 : checkCertificateFast 10 3381 fastCert10_3381=true := by decide +kernel
def fastCert10_3382 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3382 : checkCertificateFast 10 3382 fastCert10_3382=true := by decide +kernel
def fastCert10_3383 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3383 : checkCertificateFast 10 3383 fastCert10_3383=true := by decide +kernel
def fastCert10_3384 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3384 : checkCertificateFast 10 3384 fastCert10_3384=true := by decide +kernel
def fastCert10_3385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-3) else if t=0 ∧ i=2 then (-3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-3) else if t=0 ∧ i=8 then (3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=16 then (-3) else 0⟩
theorem fastCase10_3385 : checkCertificateFast 10 3385 fastCert10_3385=true := by decide +kernel
def fastCert10_3386 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3386 : checkCertificateFast 10 3386 fastCert10_3386=true := by decide +kernel
def fastCert10_3387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3387 : checkCertificateFast 10 3387 fastCert10_3387=true := by decide +kernel
def fastCert10_3388 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3388 : checkCertificateFast 10 3388 fastCert10_3388=true := by decide +kernel
def fastCert10_3389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3389 : checkCertificateFast 10 3389 fastCert10_3389=true := by decide +kernel
def fastCert10_3390 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3390 : checkCertificateFast 10 3390 fastCert10_3390=true := by decide +kernel
def fastCert10_3391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3391 : checkCertificateFast 10 3391 fastCert10_3391=true := by decide +kernel
def fastCert10_3392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_3392 : checkCertificateFast 10 3392 fastCert10_3392=true := by decide +kernel
def fastCert10_3393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3393 : checkCertificateFast 10 3393 fastCert10_3393=true := by decide +kernel
def fastCert10_3394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3394 : checkCertificateFast 10 3394 fastCert10_3394=true := by decide +kernel
def fastCert10_3395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3395 : checkCertificateFast 10 3395 fastCert10_3395=true := by decide +kernel
def fastCert10_3396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3396 : checkCertificateFast 10 3396 fastCert10_3396=true := by decide +kernel
def fastCert10_3397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3397 : checkCertificateFast 10 3397 fastCert10_3397=true := by decide +kernel
def fastCert10_3398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3398 : checkCertificateFast 10 3398 fastCert10_3398=true := by decide +kernel
def fastCert10_3399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3399 : checkCertificateFast 10 3399 fastCert10_3399=true := by decide +kernel
def fastCert10_3400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3400 : checkCertificateFast 10 3400 fastCert10_3400=true := by decide +kernel
def fastCert10_3401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3401 : checkCertificateFast 10 3401 fastCert10_3401=true := by decide +kernel
def fastCert10_3402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3402 : checkCertificateFast 10 3402 fastCert10_3402=true := by decide +kernel
def fastCert10_3403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3403 : checkCertificateFast 10 3403 fastCert10_3403=true := by decide +kernel
def fastCert10_3404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3404 : checkCertificateFast 10 3404 fastCert10_3404=true := by decide +kernel
def fastCert10_3405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3405 : checkCertificateFast 10 3405 fastCert10_3405=true := by decide +kernel
def fastCert10_3406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3406 : checkCertificateFast 10 3406 fastCert10_3406=true := by decide +kernel
def fastCert10_3407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3407 : checkCertificateFast 10 3407 fastCert10_3407=true := by decide +kernel
def fastCert10_3408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3408 : checkCertificateFast 10 3408 fastCert10_3408=true := by decide +kernel
def fastCert10_3409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3409 : checkCertificateFast 10 3409 fastCert10_3409=true := by decide +kernel
def fastCert10_3410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_3410 : checkCertificateFast 10 3410 fastCert10_3410=true := by decide +kernel
def fastCert10_3411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3411 : checkCertificateFast 10 3411 fastCert10_3411=true := by decide +kernel
def fastCert10_3412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3412 : checkCertificateFast 10 3412 fastCert10_3412=true := by decide +kernel
def fastCert10_3413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3413 : checkCertificateFast 10 3413 fastCert10_3413=true := by decide +kernel
def fastCert10_3414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3414 : checkCertificateFast 10 3414 fastCert10_3414=true := by decide +kernel
def fastCert10_3415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3415 : checkCertificateFast 10 3415 fastCert10_3415=true := by decide +kernel
def fastCert10_3416 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3416 : checkCertificateFast 10 3416 fastCert10_3416=true := by decide +kernel
def fastCert10_3417 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3417 : checkCertificateFast 10 3417 fastCert10_3417=true := by decide +kernel
def fastCert10_3418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3418 : checkCertificateFast 10 3418 fastCert10_3418=true := by decide +kernel
def fastCert10_3419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3419 : checkCertificateFast 10 3419 fastCert10_3419=true := by decide +kernel
def fastCert10_3420 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3420 : checkCertificateFast 10 3420 fastCert10_3420=true := by decide +kernel
def fastCert10_3421 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3421 : checkCertificateFast 10 3421 fastCert10_3421=true := by decide +kernel
def fastCert10_3422 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3422 : checkCertificateFast 10 3422 fastCert10_3422=true := by decide +kernel
def fastCert10_3423 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3423 : checkCertificateFast 10 3423 fastCert10_3423=true := by decide +kernel
def fastCert10_3424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3424 : checkCertificateFast 10 3424 fastCert10_3424=true := by decide +kernel
def fastCert10_3425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3425 : checkCertificateFast 10 3425 fastCert10_3425=true := by decide +kernel
def fastCert10_3426 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3426 : checkCertificateFast 10 3426 fastCert10_3426=true := by decide +kernel
def fastCert10_3427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3427 : checkCertificateFast 10 3427 fastCert10_3427=true := by decide +kernel
def fastCert10_3428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3428 : checkCertificateFast 10 3428 fastCert10_3428=true := by decide +kernel
def fastCert10_3429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3429 : checkCertificateFast 10 3429 fastCert10_3429=true := by decide +kernel
def fastCert10_3430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3430 : checkCertificateFast 10 3430 fastCert10_3430=true := by decide +kernel
def fastCert10_3431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3431 : checkCertificateFast 10 3431 fastCert10_3431=true := by decide +kernel
def fastCert10_3432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3432 : checkCertificateFast 10 3432 fastCert10_3432=true := by decide +kernel
def fastCert10_3433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3433 : checkCertificateFast 10 3433 fastCert10_3433=true := by decide +kernel
def fastCert10_3434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (4) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3434 : checkCertificateFast 10 3434 fastCert10_3434=true := by decide +kernel
def fastCert10_3435 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3435 : checkCertificateFast 10 3435 fastCert10_3435=true := by decide +kernel
def fastCert10_3436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3436 : checkCertificateFast 10 3436 fastCert10_3436=true := by decide +kernel
def fastCert10_3437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3437 : checkCertificateFast 10 3437 fastCert10_3437=true := by decide +kernel
def fastCert10_3438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3438 : checkCertificateFast 10 3438 fastCert10_3438=true := by decide +kernel
def fastCert10_3439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3439 : checkCertificateFast 10 3439 fastCert10_3439=true := by decide +kernel
def fastCert10_3440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_3440 : checkCertificateFast 10 3440 fastCert10_3440=true := by decide +kernel
def fastCert10_3441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3441 : checkCertificateFast 10 3441 fastCert10_3441=true := by decide +kernel
def fastCert10_3442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3442 : checkCertificateFast 10 3442 fastCert10_3442=true := by decide +kernel
def fastCert10_3443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3443 : checkCertificateFast 10 3443 fastCert10_3443=true := by decide +kernel
def fastCert10_3444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3444 : checkCertificateFast 10 3444 fastCert10_3444=true := by decide +kernel
def fastCert10_3445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3445 : checkCertificateFast 10 3445 fastCert10_3445=true := by decide +kernel
def fastCert10_3446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3446 : checkCertificateFast 10 3446 fastCert10_3446=true := by decide +kernel
def fastCert10_3447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3447 : checkCertificateFast 10 3447 fastCert10_3447=true := by decide +kernel
def fastCert10_3448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3448 : checkCertificateFast 10 3448 fastCert10_3448=true := by decide +kernel
def fastCert10_3449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3449 : checkCertificateFast 10 3449 fastCert10_3449=true := by decide +kernel
def fastCert10_3450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3450 : checkCertificateFast 10 3450 fastCert10_3450=true := by decide +kernel
def fastCert10_3451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3451 : checkCertificateFast 10 3451 fastCert10_3451=true := by decide +kernel
def fastCert10_3452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3452 : checkCertificateFast 10 3452 fastCert10_3452=true := by decide +kernel
def fastCert10_3453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3453 : checkCertificateFast 10 3453 fastCert10_3453=true := by decide +kernel
def fastCert10_3454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3454 : checkCertificateFast 10 3454 fastCert10_3454=true := by decide +kernel
def fastCert10_3455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3455 : checkCertificateFast 10 3455 fastCert10_3455=true := by decide +kernel
def fastCert10_3456 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3456 : checkCertificateFast 10 3456 fastCert10_3456=true := by decide +kernel
def fastCert10_3457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3457 : checkCertificateFast 10 3457 fastCert10_3457=true := by decide +kernel
def fastCert10_3458 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3458 : checkCertificateFast 10 3458 fastCert10_3458=true := by decide +kernel
def fastCert10_3459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3459 : checkCertificateFast 10 3459 fastCert10_3459=true := by decide +kernel
def fastCert10_3460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3460 : checkCertificateFast 10 3460 fastCert10_3460=true := by decide +kernel
def fastCert10_3461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3461 : checkCertificateFast 10 3461 fastCert10_3461=true := by decide +kernel
def fastCert10_3462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3462 : checkCertificateFast 10 3462 fastCert10_3462=true := by decide +kernel
def fastCert10_3463 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3463 : checkCertificateFast 10 3463 fastCert10_3463=true := by decide +kernel
def fastCert10_3464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3464 : checkCertificateFast 10 3464 fastCert10_3464=true := by decide +kernel
def fastCert10_3465 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3465 : checkCertificateFast 10 3465 fastCert10_3465=true := by decide +kernel
def fastCert10_3466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3466 : checkCertificateFast 10 3466 fastCert10_3466=true := by decide +kernel
def fastCert10_3467 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3467 : checkCertificateFast 10 3467 fastCert10_3467=true := by decide +kernel
def fastCert10_3468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3468 : checkCertificateFast 10 3468 fastCert10_3468=true := by decide +kernel
def fastCert10_3469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3469 : checkCertificateFast 10 3469 fastCert10_3469=true := by decide +kernel
def fastCert10_3470 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=13 then (3) else 0⟩
theorem fastCase10_3470 : checkCertificateFast 10 3470 fastCert10_3470=true := by decide +kernel
def fastCert10_3471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3471 : checkCertificateFast 10 3471 fastCert10_3471=true := by decide +kernel
def fastCert10_3472 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3472 : checkCertificateFast 10 3472 fastCert10_3472=true := by decide +kernel
def fastCert10_3473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3473 : checkCertificateFast 10 3473 fastCert10_3473=true := by decide +kernel
def fastCert10_3474 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3474 : checkCertificateFast 10 3474 fastCert10_3474=true := by decide +kernel
def fastCert10_3475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3475 : checkCertificateFast 10 3475 fastCert10_3475=true := by decide +kernel
def fastCert10_3476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3476 : checkCertificateFast 10 3476 fastCert10_3476=true := by decide +kernel
def fastCert10_3477 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3477 : checkCertificateFast 10 3477 fastCert10_3477=true := by decide +kernel
def fastCert10_3478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3478 : checkCertificateFast 10 3478 fastCert10_3478=true := by decide +kernel
def fastCert10_3479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3479 : checkCertificateFast 10 3479 fastCert10_3479=true := by decide +kernel
def fastCert10_3480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3480 : checkCertificateFast 10 3480 fastCert10_3480=true := by decide +kernel
def fastCert10_3481 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3481 : checkCertificateFast 10 3481 fastCert10_3481=true := by decide +kernel
def fastCert10_3482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3482 : checkCertificateFast 10 3482 fastCert10_3482=true := by decide +kernel
def fastCert10_3483 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3483 : checkCertificateFast 10 3483 fastCert10_3483=true := by decide +kernel
def fastCert10_3484 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3484 : checkCertificateFast 10 3484 fastCert10_3484=true := by decide +kernel
def fastCert10_3485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3485 : checkCertificateFast 10 3485 fastCert10_3485=true := by decide +kernel
def fastCert10_3486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3486 : checkCertificateFast 10 3486 fastCert10_3486=true := by decide +kernel
def fastCert10_3487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3487 : checkCertificateFast 10 3487 fastCert10_3487=true := by decide +kernel
def fastCert10_3488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3488 : checkCertificateFast 10 3488 fastCert10_3488=true := by decide +kernel
def fastCert10_3489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3489 : checkCertificateFast 10 3489 fastCert10_3489=true := by decide +kernel
def fastCert10_3490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3490 : checkCertificateFast 10 3490 fastCert10_3490=true := by decide +kernel
def fastCert10_3491 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3491 : checkCertificateFast 10 3491 fastCert10_3491=true := by decide +kernel
def fastCert10_3492 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3492 : checkCertificateFast 10 3492 fastCert10_3492=true := by decide +kernel
def fastCert10_3493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3493 : checkCertificateFast 10 3493 fastCert10_3493=true := by decide +kernel
def fastCert10_3494 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3494 : checkCertificateFast 10 3494 fastCert10_3494=true := by decide +kernel
def fastCert10_3495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3495 : checkCertificateFast 10 3495 fastCert10_3495=true := by decide +kernel
def fastCert10_3496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3496 : checkCertificateFast 10 3496 fastCert10_3496=true := by decide +kernel
def fastCert10_3497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3497 : checkCertificateFast 10 3497 fastCert10_3497=true := by decide +kernel
def fastCert10_3498 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3498 : checkCertificateFast 10 3498 fastCert10_3498=true := by decide +kernel
def fastCert10_3499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3499 : checkCertificateFast 10 3499 fastCert10_3499=true := by decide +kernel
def fastCert10_3500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3500 : checkCertificateFast 10 3500 fastCert10_3500=true := by decide +kernel
def fastCert10_3501 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3501 : checkCertificateFast 10 3501 fastCert10_3501=true := by decide +kernel
def fastCert10_3502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3502 : checkCertificateFast 10 3502 fastCert10_3502=true := by decide +kernel
def fastCert10_3503 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3503 : checkCertificateFast 10 3503 fastCert10_3503=true := by decide +kernel
def fastCert10_3504 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3504 : checkCertificateFast 10 3504 fastCert10_3504=true := by decide +kernel
def fastCert10_3505 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3505 : checkCertificateFast 10 3505 fastCert10_3505=true := by decide +kernel
def fastCert10_3506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3506 : checkCertificateFast 10 3506 fastCert10_3506=true := by decide +kernel
def fastCert10_3507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3507 : checkCertificateFast 10 3507 fastCert10_3507=true := by decide +kernel
def fastCert10_3508 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3508 : checkCertificateFast 10 3508 fastCert10_3508=true := by decide +kernel
def fastCert10_3509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3509 : checkCertificateFast 10 3509 fastCert10_3509=true := by decide +kernel
def fastCert10_3510 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3510 : checkCertificateFast 10 3510 fastCert10_3510=true := by decide +kernel
def fastCert10_3511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3511 : checkCertificateFast 10 3511 fastCert10_3511=true := by decide +kernel
def fastCert10_3512 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3512 : checkCertificateFast 10 3512 fastCert10_3512=true := by decide +kernel
def fastCert10_3513 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3513 : checkCertificateFast 10 3513 fastCert10_3513=true := by decide +kernel
def fastCert10_3514 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3514 : checkCertificateFast 10 3514 fastCert10_3514=true := by decide +kernel
def fastCert10_3515 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3515 : checkCertificateFast 10 3515 fastCert10_3515=true := by decide +kernel
def fastCert10_3516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3516 : checkCertificateFast 10 3516 fastCert10_3516=true := by decide +kernel
def fastCert10_3517 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3517 : checkCertificateFast 10 3517 fastCert10_3517=true := by decide +kernel
def fastCert10_3518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3518 : checkCertificateFast 10 3518 fastCert10_3518=true := by decide +kernel
def fastCert10_3519 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3519 : checkCertificateFast 10 3519 fastCert10_3519=true := by decide +kernel
def fastCert10_3520 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3520 : checkCertificateFast 10 3520 fastCert10_3520=true := by decide +kernel
def fastCert10_3521 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3521 : checkCertificateFast 10 3521 fastCert10_3521=true := by decide +kernel
def fastCert10_3522 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3522 : checkCertificateFast 10 3522 fastCert10_3522=true := by decide +kernel
def fastCert10_3523 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3523 : checkCertificateFast 10 3523 fastCert10_3523=true := by decide +kernel
def fastCert10_3524 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3524 : checkCertificateFast 10 3524 fastCert10_3524=true := by decide +kernel
def fastCert10_3525 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3525 : checkCertificateFast 10 3525 fastCert10_3525=true := by decide +kernel
def fastCert10_3526 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3526 : checkCertificateFast 10 3526 fastCert10_3526=true := by decide +kernel
def fastCert10_3527 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3527 : checkCertificateFast 10 3527 fastCert10_3527=true := by decide +kernel
def fastCert10_3528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3528 : checkCertificateFast 10 3528 fastCert10_3528=true := by decide +kernel
def fastCert10_3529 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3529 : checkCertificateFast 10 3529 fastCert10_3529=true := by decide +kernel
def fastCert10_3530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3530 : checkCertificateFast 10 3530 fastCert10_3530=true := by decide +kernel
def fastCert10_3531 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3531 : checkCertificateFast 10 3531 fastCert10_3531=true := by decide +kernel
def fastCert10_3532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3532 : checkCertificateFast 10 3532 fastCert10_3532=true := by decide +kernel
def fastCert10_3533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3533 : checkCertificateFast 10 3533 fastCert10_3533=true := by decide +kernel
def fastCert10_3534 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3534 : checkCertificateFast 10 3534 fastCert10_3534=true := by decide +kernel
def fastCert10_3535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3535 : checkCertificateFast 10 3535 fastCert10_3535=true := by decide +kernel
def fastCert10_3536 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3536 : checkCertificateFast 10 3536 fastCert10_3536=true := by decide +kernel
def fastCert10_3537 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3537 : checkCertificateFast 10 3537 fastCert10_3537=true := by decide +kernel
def fastCert10_3538 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3538 : checkCertificateFast 10 3538 fastCert10_3538=true := by decide +kernel
def fastCert10_3539 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3539 : checkCertificateFast 10 3539 fastCert10_3539=true := by decide +kernel
def fastCert10_3540 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3540 : checkCertificateFast 10 3540 fastCert10_3540=true := by decide +kernel
def fastCert10_3541 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3541 : checkCertificateFast 10 3541 fastCert10_3541=true := by decide +kernel
def fastCert10_3542 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3542 : checkCertificateFast 10 3542 fastCert10_3542=true := by decide +kernel
def fastCert10_3543 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3543 : checkCertificateFast 10 3543 fastCert10_3543=true := by decide +kernel
def fastCert10_3544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3544 : checkCertificateFast 10 3544 fastCert10_3544=true := by decide +kernel
def fastCert10_3545 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3545 : checkCertificateFast 10 3545 fastCert10_3545=true := by decide +kernel
def fastCert10_3546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3546 : checkCertificateFast 10 3546 fastCert10_3546=true := by decide +kernel
def fastCert10_3547 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3547 : checkCertificateFast 10 3547 fastCert10_3547=true := by decide +kernel
def fastCert10_3548 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3548 : checkCertificateFast 10 3548 fastCert10_3548=true := by decide +kernel
def fastCert10_3549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3549 : checkCertificateFast 10 3549 fastCert10_3549=true := by decide +kernel
def fastCert10_3550 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3550 : checkCertificateFast 10 3550 fastCert10_3550=true := by decide +kernel
def fastCert10_3551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3551 : checkCertificateFast 10 3551 fastCert10_3551=true := by decide +kernel
def fastCert10_3552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3552 : checkCertificateFast 10 3552 fastCert10_3552=true := by decide +kernel
def fastCert10_3553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3553 : checkCertificateFast 10 3553 fastCert10_3553=true := by decide +kernel
def fastCert10_3554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3554 : checkCertificateFast 10 3554 fastCert10_3554=true := by decide +kernel
def fastCert10_3555 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3555 : checkCertificateFast 10 3555 fastCert10_3555=true := by decide +kernel
def fastCert10_3556 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3556 : checkCertificateFast 10 3556 fastCert10_3556=true := by decide +kernel
def fastCert10_3557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3557 : checkCertificateFast 10 3557 fastCert10_3557=true := by decide +kernel
def fastCert10_3558 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3558 : checkCertificateFast 10 3558 fastCert10_3558=true := by decide +kernel
def fastCert10_3559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3559 : checkCertificateFast 10 3559 fastCert10_3559=true := by decide +kernel
def fastCert10_3560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3560 : checkCertificateFast 10 3560 fastCert10_3560=true := by decide +kernel
def fastCert10_3561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3561 : checkCertificateFast 10 3561 fastCert10_3561=true := by decide +kernel
def fastCert10_3562 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3562 : checkCertificateFast 10 3562 fastCert10_3562=true := by decide +kernel
def fastCert10_3563 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3563 : checkCertificateFast 10 3563 fastCert10_3563=true := by decide +kernel
def fastCert10_3564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3564 : checkCertificateFast 10 3564 fastCert10_3564=true := by decide +kernel
def fastCert10_3565 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3565 : checkCertificateFast 10 3565 fastCert10_3565=true := by decide +kernel
def fastCert10_3566 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3566 : checkCertificateFast 10 3566 fastCert10_3566=true := by decide +kernel
def fastCert10_3567 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3567 : checkCertificateFast 10 3567 fastCert10_3567=true := by decide +kernel
def fastCert10_3568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3568 : checkCertificateFast 10 3568 fastCert10_3568=true := by decide +kernel
def fastCert10_3569 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3569 : checkCertificateFast 10 3569 fastCert10_3569=true := by decide +kernel
def fastCert10_3570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3570 : checkCertificateFast 10 3570 fastCert10_3570=true := by decide +kernel
def fastCert10_3571 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3571 : checkCertificateFast 10 3571 fastCert10_3571=true := by decide +kernel
def fastCert10_3572 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3572 : checkCertificateFast 10 3572 fastCert10_3572=true := by decide +kernel
def fastCert10_3573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3573 : checkCertificateFast 10 3573 fastCert10_3573=true := by decide +kernel
def fastCert10_3574 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3574 : checkCertificateFast 10 3574 fastCert10_3574=true := by decide +kernel
def fastCert10_3575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3575 : checkCertificateFast 10 3575 fastCert10_3575=true := by decide +kernel
def fastCert10_3576 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3576 : checkCertificateFast 10 3576 fastCert10_3576=true := by decide +kernel
def fastCert10_3577 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3577 : checkCertificateFast 10 3577 fastCert10_3577=true := by decide +kernel
def fastCert10_3578 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3578 : checkCertificateFast 10 3578 fastCert10_3578=true := by decide +kernel
def fastCert10_3579 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3579 : checkCertificateFast 10 3579 fastCert10_3579=true := by decide +kernel
def fastCert10_3580 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3580 : checkCertificateFast 10 3580 fastCert10_3580=true := by decide +kernel
def fastCert10_3581 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3581 : checkCertificateFast 10 3581 fastCert10_3581=true := by decide +kernel
def fastCert10_3582 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3582 : checkCertificateFast 10 3582 fastCert10_3582=true := by decide +kernel
def fastCert10_3583 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3583 : checkCertificateFast 10 3583 fastCert10_3583=true := by decide +kernel
def fastCert10_3584 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3584 : checkCertificateFast 10 3584 fastCert10_3584=true := by decide +kernel
def fastCert10_3585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3585 : checkCertificateFast 10 3585 fastCert10_3585=true := by decide +kernel
def fastCert10_3586 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3586 : checkCertificateFast 10 3586 fastCert10_3586=true := by decide +kernel
def fastCert10_3587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3587 : checkCertificateFast 10 3587 fastCert10_3587=true := by decide +kernel
def fastCert10_3588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3588 : checkCertificateFast 10 3588 fastCert10_3588=true := by decide +kernel
def fastCert10_3589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3589 : checkCertificateFast 10 3589 fastCert10_3589=true := by decide +kernel
def fastCert10_3590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3590 : checkCertificateFast 10 3590 fastCert10_3590=true := by decide +kernel
def fastCert10_3591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3591 : checkCertificateFast 10 3591 fastCert10_3591=true := by decide +kernel
def fastCert10_3592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3592 : checkCertificateFast 10 3592 fastCert10_3592=true := by decide +kernel
def fastCert10_3593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-23) else if t=0 ∧ i=1 then (21) else if t=0 ∧ i=2 then (10) else if t=0 ∧ i=3 then (7) else if t=0 ∧ i=4 then (-14) else if t=0 ∧ i=5 then (-18) else if t=0 ∧ i=6 then (21) else if t=0 ∧ i=7 then (21) else if t=0 ∧ i=8 then (-10) else if t=0 ∧ i=10 then (5) else if t=0 ∧ i=11 then (37) else if t=0 ∧ i=12 then (-5) else if t=0 ∧ i=13 then (-42) else if t=0 ∧ i=16 then (10) else 0⟩
theorem fastCase10_3593 : checkCertificateFast 10 3593 fastCert10_3593=true := by decide +kernel
def fastCert10_3594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3594 : checkCertificateFast 10 3594 fastCert10_3594=true := by decide +kernel
def fastCert10_3595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3595 : checkCertificateFast 10 3595 fastCert10_3595=true := by decide +kernel
def fastCert10_3596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3596 : checkCertificateFast 10 3596 fastCert10_3596=true := by decide +kernel
def fastCert10_3597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3597 : checkCertificateFast 10 3597 fastCert10_3597=true := by decide +kernel
def fastCert10_3598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (-3) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3598 : checkCertificateFast 10 3598 fastCert10_3598=true := by decide +kernel
def fastCert10_3599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3599 : checkCertificateFast 10 3599 fastCert10_3599=true := by decide +kernel
def fastCert10_3600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3600 : checkCertificateFast 10 3600 fastCert10_3600=true := by decide +kernel
def fastCert10_3601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3601 : checkCertificateFast 10 3601 fastCert10_3601=true := by decide +kernel
def fastCert10_3602 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3602 : checkCertificateFast 10 3602 fastCert10_3602=true := by decide +kernel
def fastCert10_3603 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3603 : checkCertificateFast 10 3603 fastCert10_3603=true := by decide +kernel
def fastCert10_3604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3604 : checkCertificateFast 10 3604 fastCert10_3604=true := by decide +kernel
def fastCert10_3605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3605 : checkCertificateFast 10 3605 fastCert10_3605=true := by decide +kernel
def fastCert10_3606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3606 : checkCertificateFast 10 3606 fastCert10_3606=true := by decide +kernel
def fastCert10_3607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3607 : checkCertificateFast 10 3607 fastCert10_3607=true := by decide +kernel
def fastCert10_3608 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3608 : checkCertificateFast 10 3608 fastCert10_3608=true := by decide +kernel
def fastCert10_3609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3609 : checkCertificateFast 10 3609 fastCert10_3609=true := by decide +kernel
def fastCert10_3610 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3610 : checkCertificateFast 10 3610 fastCert10_3610=true := by decide +kernel
def fastCert10_3611 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3611 : checkCertificateFast 10 3611 fastCert10_3611=true := by decide +kernel
def fastCert10_3612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3612 : checkCertificateFast 10 3612 fastCert10_3612=true := by decide +kernel
def fastCert10_3613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3613 : checkCertificateFast 10 3613 fastCert10_3613=true := by decide +kernel
def fastCert10_3614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3614 : checkCertificateFast 10 3614 fastCert10_3614=true := by decide +kernel
def fastCert10_3615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3615 : checkCertificateFast 10 3615 fastCert10_3615=true := by decide +kernel
def fastCert10_3616 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3616 : checkCertificateFast 10 3616 fastCert10_3616=true := by decide +kernel
def fastCert10_3617 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3617 : checkCertificateFast 10 3617 fastCert10_3617=true := by decide +kernel
def fastCert10_3618 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3618 : checkCertificateFast 10 3618 fastCert10_3618=true := by decide +kernel
def fastCert10_3619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3619 : checkCertificateFast 10 3619 fastCert10_3619=true := by decide +kernel
def fastCert10_3620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3620 : checkCertificateFast 10 3620 fastCert10_3620=true := by decide +kernel
def fastCert10_3621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3621 : checkCertificateFast 10 3621 fastCert10_3621=true := by decide +kernel
def fastCert10_3622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3622 : checkCertificateFast 10 3622 fastCert10_3622=true := by decide +kernel
def fastCert10_3623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3623 : checkCertificateFast 10 3623 fastCert10_3623=true := by decide +kernel
def fastCert10_3624 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3624 : checkCertificateFast 10 3624 fastCert10_3624=true := by decide +kernel
def fastCert10_3625 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3625 : checkCertificateFast 10 3625 fastCert10_3625=true := by decide +kernel
def fastCert10_3626 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3626 : checkCertificateFast 10 3626 fastCert10_3626=true := by decide +kernel
def fastCert10_3627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3627 : checkCertificateFast 10 3627 fastCert10_3627=true := by decide +kernel
def fastCert10_3628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3628 : checkCertificateFast 10 3628 fastCert10_3628=true := by decide +kernel
def fastCert10_3629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3629 : checkCertificateFast 10 3629 fastCert10_3629=true := by decide +kernel
def fastCert10_3630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3630 : checkCertificateFast 10 3630 fastCert10_3630=true := by decide +kernel
def fastCert10_3631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3631 : checkCertificateFast 10 3631 fastCert10_3631=true := by decide +kernel
def fastCert10_3632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3632 : checkCertificateFast 10 3632 fastCert10_3632=true := by decide +kernel
def fastCert10_3633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3633 : checkCertificateFast 10 3633 fastCert10_3633=true := by decide +kernel
def fastCert10_3634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3634 : checkCertificateFast 10 3634 fastCert10_3634=true := by decide +kernel
def fastCert10_3635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_3635 : checkCertificateFast 10 3635 fastCert10_3635=true := by decide +kernel
def fastCert10_3636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3636 : checkCertificateFast 10 3636 fastCert10_3636=true := by decide +kernel
def fastCert10_3637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3637 : checkCertificateFast 10 3637 fastCert10_3637=true := by decide +kernel
def fastCert10_3638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3638 : checkCertificateFast 10 3638 fastCert10_3638=true := by decide +kernel
def fastCert10_3639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3639 : checkCertificateFast 10 3639 fastCert10_3639=true := by decide +kernel
def fastCert10_3640 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3640 : checkCertificateFast 10 3640 fastCert10_3640=true := by decide +kernel
def fastCert10_3641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3641 : checkCertificateFast 10 3641 fastCert10_3641=true := by decide +kernel
def fastCert10_3642 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3642 : checkCertificateFast 10 3642 fastCert10_3642=true := by decide +kernel
def fastCert10_3643 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3643 : checkCertificateFast 10 3643 fastCert10_3643=true := by decide +kernel
def fastCert10_3644 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3644 : checkCertificateFast 10 3644 fastCert10_3644=true := by decide +kernel
def fastCert10_3645 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3645 : checkCertificateFast 10 3645 fastCert10_3645=true := by decide +kernel
def fastCert10_3646 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3646 : checkCertificateFast 10 3646 fastCert10_3646=true := by decide +kernel
def fastCert10_3647 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3647 : checkCertificateFast 10 3647 fastCert10_3647=true := by decide +kernel
def fastCert10_3648 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3648 : checkCertificateFast 10 3648 fastCert10_3648=true := by decide +kernel
def fastCert10_3649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3649 : checkCertificateFast 10 3649 fastCert10_3649=true := by decide +kernel
def fastCert10_3650 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3650 : checkCertificateFast 10 3650 fastCert10_3650=true := by decide +kernel
def fastCert10_3651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3651 : checkCertificateFast 10 3651 fastCert10_3651=true := by decide +kernel
def fastCert10_3652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3652 : checkCertificateFast 10 3652 fastCert10_3652=true := by decide +kernel
def fastCert10_3653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3653 : checkCertificateFast 10 3653 fastCert10_3653=true := by decide +kernel
def fastCert10_3654 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3654 : checkCertificateFast 10 3654 fastCert10_3654=true := by decide +kernel
def fastCert10_3655 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3655 : checkCertificateFast 10 3655 fastCert10_3655=true := by decide +kernel
def fastCert10_3656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3656 : checkCertificateFast 10 3656 fastCert10_3656=true := by decide +kernel
def fastCert10_3657 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3657 : checkCertificateFast 10 3657 fastCert10_3657=true := by decide +kernel
def fastCert10_3658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3658 : checkCertificateFast 10 3658 fastCert10_3658=true := by decide +kernel
def fastCert10_3659 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3659 : checkCertificateFast 10 3659 fastCert10_3659=true := by decide +kernel
def fastCert10_3660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3660 : checkCertificateFast 10 3660 fastCert10_3660=true := by decide +kernel
def fastCert10_3661 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3661 : checkCertificateFast 10 3661 fastCert10_3661=true := by decide +kernel
def fastCert10_3662 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3662 : checkCertificateFast 10 3662 fastCert10_3662=true := by decide +kernel
def fastCert10_3663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3663 : checkCertificateFast 10 3663 fastCert10_3663=true := by decide +kernel
def fastCert10_3664 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3664 : checkCertificateFast 10 3664 fastCert10_3664=true := by decide +kernel
def fastCert10_3665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3665 : checkCertificateFast 10 3665 fastCert10_3665=true := by decide +kernel
def fastCert10_3666 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3666 : checkCertificateFast 10 3666 fastCert10_3666=true := by decide +kernel
def fastCert10_3667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3667 : checkCertificateFast 10 3667 fastCert10_3667=true := by decide +kernel
def fastCert10_3668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3668 : checkCertificateFast 10 3668 fastCert10_3668=true := by decide +kernel
def fastCert10_3669 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3669 : checkCertificateFast 10 3669 fastCert10_3669=true := by decide +kernel
def fastCert10_3670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3670 : checkCertificateFast 10 3670 fastCert10_3670=true := by decide +kernel
def fastCert10_3671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3671 : checkCertificateFast 10 3671 fastCert10_3671=true := by decide +kernel
def fastCert10_3672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3672 : checkCertificateFast 10 3672 fastCert10_3672=true := by decide +kernel
def fastCert10_3673 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3673 : checkCertificateFast 10 3673 fastCert10_3673=true := by decide +kernel
def fastCert10_3674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3674 : checkCertificateFast 10 3674 fastCert10_3674=true := by decide +kernel
def fastCert10_3675 : Certificate := ⟨18,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3675 : checkCertificateFast 10 3675 fastCert10_3675=true := by decide +kernel
def fastCert10_3676 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3676 : checkCertificateFast 10 3676 fastCert10_3676=true := by decide +kernel
def fastCert10_3677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3677 : checkCertificateFast 10 3677 fastCert10_3677=true := by decide +kernel
def fastCert10_3678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3678 : checkCertificateFast 10 3678 fastCert10_3678=true := by decide +kernel
def fastCert10_3679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3679 : checkCertificateFast 10 3679 fastCert10_3679=true := by decide +kernel
def fastCert10_3680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3680 : checkCertificateFast 10 3680 fastCert10_3680=true := by decide +kernel
def fastCert10_3681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3681 : checkCertificateFast 10 3681 fastCert10_3681=true := by decide +kernel
def fastCert10_3682 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3682 : checkCertificateFast 10 3682 fastCert10_3682=true := by decide +kernel
def fastCert10_3683 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3683 : checkCertificateFast 10 3683 fastCert10_3683=true := by decide +kernel
def fastCert10_3684 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3684 : checkCertificateFast 10 3684 fastCert10_3684=true := by decide +kernel
def fastCert10_3685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3685 : checkCertificateFast 10 3685 fastCert10_3685=true := by decide +kernel
def fastCert10_3686 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3686 : checkCertificateFast 10 3686 fastCert10_3686=true := by decide +kernel
def fastCert10_3687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3687 : checkCertificateFast 10 3687 fastCert10_3687=true := by decide +kernel
def fastCert10_3688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3688 : checkCertificateFast 10 3688 fastCert10_3688=true := by decide +kernel
def fastCert10_3689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3689 : checkCertificateFast 10 3689 fastCert10_3689=true := by decide +kernel
def fastCert10_3690 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3690 : checkCertificateFast 10 3690 fastCert10_3690=true := by decide +kernel
def fastCert10_3691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3691 : checkCertificateFast 10 3691 fastCert10_3691=true := by decide +kernel
def fastCert10_3692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3692 : checkCertificateFast 10 3692 fastCert10_3692=true := by decide +kernel
def fastCert10_3693 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3693 : checkCertificateFast 10 3693 fastCert10_3693=true := by decide +kernel
def fastCert10_3694 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3694 : checkCertificateFast 10 3694 fastCert10_3694=true := by decide +kernel
def fastCert10_3695 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3695 : checkCertificateFast 10 3695 fastCert10_3695=true := by decide +kernel
def fastCert10_3696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3696 : checkCertificateFast 10 3696 fastCert10_3696=true := by decide +kernel
def fastCert10_3697 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3697 : checkCertificateFast 10 3697 fastCert10_3697=true := by decide +kernel
def fastCert10_3698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3698 : checkCertificateFast 10 3698 fastCert10_3698=true := by decide +kernel
def fastCert10_3699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3699 : checkCertificateFast 10 3699 fastCert10_3699=true := by decide +kernel
def fastCert10_3700 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3700 : checkCertificateFast 10 3700 fastCert10_3700=true := by decide +kernel
def fastCert10_3701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3701 : checkCertificateFast 10 3701 fastCert10_3701=true := by decide +kernel
def fastCert10_3702 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3702 : checkCertificateFast 10 3702 fastCert10_3702=true := by decide +kernel
def fastCert10_3703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3703 : checkCertificateFast 10 3703 fastCert10_3703=true := by decide +kernel
def fastCert10_3704 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3704 : checkCertificateFast 10 3704 fastCert10_3704=true := by decide +kernel
def fastCert10_3705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3705 : checkCertificateFast 10 3705 fastCert10_3705=true := by decide +kernel
def fastCert10_3706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3706 : checkCertificateFast 10 3706 fastCert10_3706=true := by decide +kernel
def fastCert10_3707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3707 : checkCertificateFast 10 3707 fastCert10_3707=true := by decide +kernel
def fastCert10_3708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3708 : checkCertificateFast 10 3708 fastCert10_3708=true := by decide +kernel
def fastCert10_3709 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3709 : checkCertificateFast 10 3709 fastCert10_3709=true := by decide +kernel
def fastCert10_3710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3710 : checkCertificateFast 10 3710 fastCert10_3710=true := by decide +kernel
def fastCert10_3711 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3711 : checkCertificateFast 10 3711 fastCert10_3711=true := by decide +kernel
def fastCert10_3712 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3712 : checkCertificateFast 10 3712 fastCert10_3712=true := by decide +kernel
def fastCert10_3713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3713 : checkCertificateFast 10 3713 fastCert10_3713=true := by decide +kernel
def fastCert10_3714 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3714 : checkCertificateFast 10 3714 fastCert10_3714=true := by decide +kernel
def fastCert10_3715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3715 : checkCertificateFast 10 3715 fastCert10_3715=true := by decide +kernel
def fastCert10_3716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3716 : checkCertificateFast 10 3716 fastCert10_3716=true := by decide +kernel
def fastCert10_3717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3717 : checkCertificateFast 10 3717 fastCert10_3717=true := by decide +kernel
def fastCert10_3718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3718 : checkCertificateFast 10 3718 fastCert10_3718=true := by decide +kernel
def fastCert10_3719 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3719 : checkCertificateFast 10 3719 fastCert10_3719=true := by decide +kernel
def fastCert10_3720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3720 : checkCertificateFast 10 3720 fastCert10_3720=true := by decide +kernel
def fastCert10_3721 : Certificate := ⟨20,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3721 : checkCertificateFast 10 3721 fastCert10_3721=true := by decide +kernel
def fastCert10_3722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3722 : checkCertificateFast 10 3722 fastCert10_3722=true := by decide +kernel
def fastCert10_3723 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3723 : checkCertificateFast 10 3723 fastCert10_3723=true := by decide +kernel
def fastCert10_3724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3724 : checkCertificateFast 10 3724 fastCert10_3724=true := by decide +kernel
def fastCert10_3725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3725 : checkCertificateFast 10 3725 fastCert10_3725=true := by decide +kernel
def fastCert10_3726 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3726 : checkCertificateFast 10 3726 fastCert10_3726=true := by decide +kernel
def fastCert10_3727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3727 : checkCertificateFast 10 3727 fastCert10_3727=true := by decide +kernel
def fastCert10_3728 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3728 : checkCertificateFast 10 3728 fastCert10_3728=true := by decide +kernel
def fastCert10_3729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3729 : checkCertificateFast 10 3729 fastCert10_3729=true := by decide +kernel
def fastCert10_3730 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_3730 : checkCertificateFast 10 3730 fastCert10_3730=true := by decide +kernel
def fastCert10_3731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3731 : checkCertificateFast 10 3731 fastCert10_3731=true := by decide +kernel
def fastCert10_3732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3732 : checkCertificateFast 10 3732 fastCert10_3732=true := by decide +kernel
def fastCert10_3733 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3733 : checkCertificateFast 10 3733 fastCert10_3733=true := by decide +kernel
def fastCert10_3734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3734 : checkCertificateFast 10 3734 fastCert10_3734=true := by decide +kernel
def fastCert10_3735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3735 : checkCertificateFast 10 3735 fastCert10_3735=true := by decide +kernel
def fastCert10_3736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3736 : checkCertificateFast 10 3736 fastCert10_3736=true := by decide +kernel
def fastCert10_3737 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3737 : checkCertificateFast 10 3737 fastCert10_3737=true := by decide +kernel
def fastCert10_3738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3738 : checkCertificateFast 10 3738 fastCert10_3738=true := by decide +kernel
def fastCert10_3739 : Certificate := ⟨20,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3739 : checkCertificateFast 10 3739 fastCert10_3739=true := by decide +kernel
def fastCert10_3740 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3740 : checkCertificateFast 10 3740 fastCert10_3740=true := by decide +kernel
def fastCert10_3741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3741 : checkCertificateFast 10 3741 fastCert10_3741=true := by decide +kernel
def fastCert10_3742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3742 : checkCertificateFast 10 3742 fastCert10_3742=true := by decide +kernel
def fastCert10_3743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3743 : checkCertificateFast 10 3743 fastCert10_3743=true := by decide +kernel
def fastCert10_3744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3744 : checkCertificateFast 10 3744 fastCert10_3744=true := by decide +kernel
def fastCert10_3745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3745 : checkCertificateFast 10 3745 fastCert10_3745=true := by decide +kernel
def fastCert10_3746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3746 : checkCertificateFast 10 3746 fastCert10_3746=true := by decide +kernel
def fastCert10_3747 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3747 : checkCertificateFast 10 3747 fastCert10_3747=true := by decide +kernel
def fastCert10_3748 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3748 : checkCertificateFast 10 3748 fastCert10_3748=true := by decide +kernel
def fastCert10_3749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3749 : checkCertificateFast 10 3749 fastCert10_3749=true := by decide +kernel
def fastCert10_3750 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3750 : checkCertificateFast 10 3750 fastCert10_3750=true := by decide +kernel
def fastCert10_3751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3751 : checkCertificateFast 10 3751 fastCert10_3751=true := by decide +kernel
def fastCert10_3752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3752 : checkCertificateFast 10 3752 fastCert10_3752=true := by decide +kernel
def fastCert10_3753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3753 : checkCertificateFast 10 3753 fastCert10_3753=true := by decide +kernel
def fastCert10_3754 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3754 : checkCertificateFast 10 3754 fastCert10_3754=true := by decide +kernel
def fastCert10_3755 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3755 : checkCertificateFast 10 3755 fastCert10_3755=true := by decide +kernel
def fastCert10_3756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3756 : checkCertificateFast 10 3756 fastCert10_3756=true := by decide +kernel
def fastCert10_3757 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3757 : checkCertificateFast 10 3757 fastCert10_3757=true := by decide +kernel
def fastCert10_3758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3758 : checkCertificateFast 10 3758 fastCert10_3758=true := by decide +kernel
def fastCert10_3759 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3759 : checkCertificateFast 10 3759 fastCert10_3759=true := by decide +kernel
def fastCert10_3760 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3760 : checkCertificateFast 10 3760 fastCert10_3760=true := by decide +kernel
def fastCert10_3761 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3761 : checkCertificateFast 10 3761 fastCert10_3761=true := by decide +kernel
def fastCert10_3762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3762 : checkCertificateFast 10 3762 fastCert10_3762=true := by decide +kernel
def fastCert10_3763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3763 : checkCertificateFast 10 3763 fastCert10_3763=true := by decide +kernel
def fastCert10_3764 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3764 : checkCertificateFast 10 3764 fastCert10_3764=true := by decide +kernel
def fastCert10_3765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3765 : checkCertificateFast 10 3765 fastCert10_3765=true := by decide +kernel
def fastCert10_3766 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_3766 : checkCertificateFast 10 3766 fastCert10_3766=true := by decide +kernel
def fastCert10_3767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3767 : checkCertificateFast 10 3767 fastCert10_3767=true := by decide +kernel
def fastCert10_3768 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3768 : checkCertificateFast 10 3768 fastCert10_3768=true := by decide +kernel
def fastCert10_3769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3769 : checkCertificateFast 10 3769 fastCert10_3769=true := by decide +kernel
def fastCert10_3770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3770 : checkCertificateFast 10 3770 fastCert10_3770=true := by decide +kernel
def fastCert10_3771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3771 : checkCertificateFast 10 3771 fastCert10_3771=true := by decide +kernel
def fastCert10_3772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3772 : checkCertificateFast 10 3772 fastCert10_3772=true := by decide +kernel
def fastCert10_3773 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3773 : checkCertificateFast 10 3773 fastCert10_3773=true := by decide +kernel
def fastCert10_3774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3774 : checkCertificateFast 10 3774 fastCert10_3774=true := by decide +kernel
def fastCert10_3775 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_3775 : checkCertificateFast 10 3775 fastCert10_3775=true := by decide +kernel
def fastCert10_3776 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3776 : checkCertificateFast 10 3776 fastCert10_3776=true := by decide +kernel
def fastCert10_3777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3777 : checkCertificateFast 10 3777 fastCert10_3777=true := by decide +kernel
def fastCert10_3778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3778 : checkCertificateFast 10 3778 fastCert10_3778=true := by decide +kernel
def fastCert10_3779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3779 : checkCertificateFast 10 3779 fastCert10_3779=true := by decide +kernel
def fastCert10_3780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3780 : checkCertificateFast 10 3780 fastCert10_3780=true := by decide +kernel
def fastCert10_3781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3781 : checkCertificateFast 10 3781 fastCert10_3781=true := by decide +kernel
def fastCert10_3782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3782 : checkCertificateFast 10 3782 fastCert10_3782=true := by decide +kernel
def fastCert10_3783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3783 : checkCertificateFast 10 3783 fastCert10_3783=true := by decide +kernel
def fastCert10_3784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3784 : checkCertificateFast 10 3784 fastCert10_3784=true := by decide +kernel
def fastCert10_3785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3785 : checkCertificateFast 10 3785 fastCert10_3785=true := by decide +kernel
def fastCert10_3786 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3786 : checkCertificateFast 10 3786 fastCert10_3786=true := by decide +kernel
def fastCert10_3787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3787 : checkCertificateFast 10 3787 fastCert10_3787=true := by decide +kernel
def fastCert10_3788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3788 : checkCertificateFast 10 3788 fastCert10_3788=true := by decide +kernel
def fastCert10_3789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3789 : checkCertificateFast 10 3789 fastCert10_3789=true := by decide +kernel
def fastCert10_3790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3790 : checkCertificateFast 10 3790 fastCert10_3790=true := by decide +kernel
def fastCert10_3791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3791 : checkCertificateFast 10 3791 fastCert10_3791=true := by decide +kernel
def fastCert10_3792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3792 : checkCertificateFast 10 3792 fastCert10_3792=true := by decide +kernel
def fastCert10_3793 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3793 : checkCertificateFast 10 3793 fastCert10_3793=true := by decide +kernel
def fastCert10_3794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3794 : checkCertificateFast 10 3794 fastCert10_3794=true := by decide +kernel
def fastCert10_3795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3795 : checkCertificateFast 10 3795 fastCert10_3795=true := by decide +kernel
def fastCert10_3796 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3796 : checkCertificateFast 10 3796 fastCert10_3796=true := by decide +kernel
def fastCert10_3797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3797 : checkCertificateFast 10 3797 fastCert10_3797=true := by decide +kernel
def fastCert10_3798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3798 : checkCertificateFast 10 3798 fastCert10_3798=true := by decide +kernel
def fastCert10_3799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3799 : checkCertificateFast 10 3799 fastCert10_3799=true := by decide +kernel
def fastCert10_3800 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3800 : checkCertificateFast 10 3800 fastCert10_3800=true := by decide +kernel
def fastCert10_3801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3801 : checkCertificateFast 10 3801 fastCert10_3801=true := by decide +kernel
def fastCert10_3802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3802 : checkCertificateFast 10 3802 fastCert10_3802=true := by decide +kernel
def fastCert10_3803 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3803 : checkCertificateFast 10 3803 fastCert10_3803=true := by decide +kernel
def fastCert10_3804 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3804 : checkCertificateFast 10 3804 fastCert10_3804=true := by decide +kernel
def fastCert10_3805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3805 : checkCertificateFast 10 3805 fastCert10_3805=true := by decide +kernel
def fastCert10_3806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3806 : checkCertificateFast 10 3806 fastCert10_3806=true := by decide +kernel
def fastCert10_3807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3807 : checkCertificateFast 10 3807 fastCert10_3807=true := by decide +kernel
def fastCert10_3808 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3808 : checkCertificateFast 10 3808 fastCert10_3808=true := by decide +kernel
def fastCert10_3809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3809 : checkCertificateFast 10 3809 fastCert10_3809=true := by decide +kernel
def fastCert10_3810 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3810 : checkCertificateFast 10 3810 fastCert10_3810=true := by decide +kernel
def fastCert10_3811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3811 : checkCertificateFast 10 3811 fastCert10_3811=true := by decide +kernel
def fastCert10_3812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3812 : checkCertificateFast 10 3812 fastCert10_3812=true := by decide +kernel
def fastCert10_3813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3813 : checkCertificateFast 10 3813 fastCert10_3813=true := by decide +kernel
def fastCert10_3814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3814 : checkCertificateFast 10 3814 fastCert10_3814=true := by decide +kernel
def fastCert10_3815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3815 : checkCertificateFast 10 3815 fastCert10_3815=true := by decide +kernel
def fastCert10_3816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3816 : checkCertificateFast 10 3816 fastCert10_3816=true := by decide +kernel
def fastCert10_3817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3817 : checkCertificateFast 10 3817 fastCert10_3817=true := by decide +kernel
def fastCert10_3818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3818 : checkCertificateFast 10 3818 fastCert10_3818=true := by decide +kernel
def fastCert10_3819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3819 : checkCertificateFast 10 3819 fastCert10_3819=true := by decide +kernel
def fastCert10_3820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3820 : checkCertificateFast 10 3820 fastCert10_3820=true := by decide +kernel
def fastCert10_3821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3821 : checkCertificateFast 10 3821 fastCert10_3821=true := by decide +kernel
def fastCert10_3822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3822 : checkCertificateFast 10 3822 fastCert10_3822=true := by decide +kernel
def fastCert10_3823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3823 : checkCertificateFast 10 3823 fastCert10_3823=true := by decide +kernel
def fastCert10_3824 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3824 : checkCertificateFast 10 3824 fastCert10_3824=true := by decide +kernel
def fastCert10_3825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3825 : checkCertificateFast 10 3825 fastCert10_3825=true := by decide +kernel
def fastCert10_3826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3826 : checkCertificateFast 10 3826 fastCert10_3826=true := by decide +kernel
def fastCert10_3827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3827 : checkCertificateFast 10 3827 fastCert10_3827=true := by decide +kernel
def fastCert10_3828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3828 : checkCertificateFast 10 3828 fastCert10_3828=true := by decide +kernel
def fastCert10_3829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3829 : checkCertificateFast 10 3829 fastCert10_3829=true := by decide +kernel
def fastCert10_3830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3830 : checkCertificateFast 10 3830 fastCert10_3830=true := by decide +kernel
def fastCert10_3831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3831 : checkCertificateFast 10 3831 fastCert10_3831=true := by decide +kernel
def fastCert10_3832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3832 : checkCertificateFast 10 3832 fastCert10_3832=true := by decide +kernel
def fastCert10_3833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3833 : checkCertificateFast 10 3833 fastCert10_3833=true := by decide +kernel
def fastCert10_3834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3834 : checkCertificateFast 10 3834 fastCert10_3834=true := by decide +kernel
def fastCert10_3835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3835 : checkCertificateFast 10 3835 fastCert10_3835=true := by decide +kernel
def fastCert10_3836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3836 : checkCertificateFast 10 3836 fastCert10_3836=true := by decide +kernel
def fastCert10_3837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3837 : checkCertificateFast 10 3837 fastCert10_3837=true := by decide +kernel
def fastCert10_3838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3838 : checkCertificateFast 10 3838 fastCert10_3838=true := by decide +kernel
def fastCert10_3839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3839 : checkCertificateFast 10 3839 fastCert10_3839=true := by decide +kernel
def fastCert10_3840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3840 : checkCertificateFast 10 3840 fastCert10_3840=true := by decide +kernel
def fastCert10_3841 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3841 : checkCertificateFast 10 3841 fastCert10_3841=true := by decide +kernel
def fastCert10_3842 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3842 : checkCertificateFast 10 3842 fastCert10_3842=true := by decide +kernel
def fastCert10_3843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3843 : checkCertificateFast 10 3843 fastCert10_3843=true := by decide +kernel
def fastCert10_3844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3844 : checkCertificateFast 10 3844 fastCert10_3844=true := by decide +kernel
def fastCert10_3845 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3845 : checkCertificateFast 10 3845 fastCert10_3845=true := by decide +kernel
def fastCert10_3846 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3846 : checkCertificateFast 10 3846 fastCert10_3846=true := by decide +kernel
def fastCert10_3847 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3847 : checkCertificateFast 10 3847 fastCert10_3847=true := by decide +kernel
def fastCert10_3848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3848 : checkCertificateFast 10 3848 fastCert10_3848=true := by decide +kernel
def fastCert10_3849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3849 : checkCertificateFast 10 3849 fastCert10_3849=true := by decide +kernel
def fastCert10_3850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3850 : checkCertificateFast 10 3850 fastCert10_3850=true := by decide +kernel
def fastCert10_3851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3851 : checkCertificateFast 10 3851 fastCert10_3851=true := by decide +kernel
def fastCert10_3852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_3852 : checkCertificateFast 10 3852 fastCert10_3852=true := by decide +kernel
def fastCert10_3853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3853 : checkCertificateFast 10 3853 fastCert10_3853=true := by decide +kernel
def fastCert10_3854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3854 : checkCertificateFast 10 3854 fastCert10_3854=true := by decide +kernel
def fastCert10_3855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3855 : checkCertificateFast 10 3855 fastCert10_3855=true := by decide +kernel
def fastCert10_3856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3856 : checkCertificateFast 10 3856 fastCert10_3856=true := by decide +kernel
def fastCert10_3857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3857 : checkCertificateFast 10 3857 fastCert10_3857=true := by decide +kernel
def fastCert10_3858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3858 : checkCertificateFast 10 3858 fastCert10_3858=true := by decide +kernel
def fastCert10_3859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3859 : checkCertificateFast 10 3859 fastCert10_3859=true := by decide +kernel
def fastCert10_3860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3860 : checkCertificateFast 10 3860 fastCert10_3860=true := by decide +kernel
def fastCert10_3861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3861 : checkCertificateFast 10 3861 fastCert10_3861=true := by decide +kernel
def fastCert10_3862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3862 : checkCertificateFast 10 3862 fastCert10_3862=true := by decide +kernel
def fastCert10_3863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3863 : checkCertificateFast 10 3863 fastCert10_3863=true := by decide +kernel
def fastCert10_3864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3864 : checkCertificateFast 10 3864 fastCert10_3864=true := by decide +kernel
def fastCert10_3865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_3865 : checkCertificateFast 10 3865 fastCert10_3865=true := by decide +kernel
def fastCert10_3866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3866 : checkCertificateFast 10 3866 fastCert10_3866=true := by decide +kernel
def fastCert10_3867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3867 : checkCertificateFast 10 3867 fastCert10_3867=true := by decide +kernel
def fastCert10_3868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3868 : checkCertificateFast 10 3868 fastCert10_3868=true := by decide +kernel
def fastCert10_3869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3869 : checkCertificateFast 10 3869 fastCert10_3869=true := by decide +kernel
def fastCert10_3870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3870 : checkCertificateFast 10 3870 fastCert10_3870=true := by decide +kernel
def fastCert10_3871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3871 : checkCertificateFast 10 3871 fastCert10_3871=true := by decide +kernel
def fastCert10_3872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3872 : checkCertificateFast 10 3872 fastCert10_3872=true := by decide +kernel
def fastCert10_3873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3873 : checkCertificateFast 10 3873 fastCert10_3873=true := by decide +kernel
def fastCert10_3874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3874 : checkCertificateFast 10 3874 fastCert10_3874=true := by decide +kernel
def fastCert10_3875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3875 : checkCertificateFast 10 3875 fastCert10_3875=true := by decide +kernel
def fastCert10_3876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3876 : checkCertificateFast 10 3876 fastCert10_3876=true := by decide +kernel
def fastCert10_3877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3877 : checkCertificateFast 10 3877 fastCert10_3877=true := by decide +kernel
def fastCert10_3878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3878 : checkCertificateFast 10 3878 fastCert10_3878=true := by decide +kernel
def fastCert10_3879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3879 : checkCertificateFast 10 3879 fastCert10_3879=true := by decide +kernel
def fastCert10_3880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3880 : checkCertificateFast 10 3880 fastCert10_3880=true := by decide +kernel
def fastCert10_3881 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3881 : checkCertificateFast 10 3881 fastCert10_3881=true := by decide +kernel
def fastCert10_3882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3882 : checkCertificateFast 10 3882 fastCert10_3882=true := by decide +kernel
def fastCert10_3883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3883 : checkCertificateFast 10 3883 fastCert10_3883=true := by decide +kernel
def fastCert10_3884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3884 : checkCertificateFast 10 3884 fastCert10_3884=true := by decide +kernel
def fastCert10_3885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3885 : checkCertificateFast 10 3885 fastCert10_3885=true := by decide +kernel
def fastCert10_3886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3886 : checkCertificateFast 10 3886 fastCert10_3886=true := by decide +kernel
def fastCert10_3887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3887 : checkCertificateFast 10 3887 fastCert10_3887=true := by decide +kernel
def fastCert10_3888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3888 : checkCertificateFast 10 3888 fastCert10_3888=true := by decide +kernel
def fastCert10_3889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_3889 : checkCertificateFast 10 3889 fastCert10_3889=true := by decide +kernel
def fastCert10_3890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3890 : checkCertificateFast 10 3890 fastCert10_3890=true := by decide +kernel
def fastCert10_3891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3891 : checkCertificateFast 10 3891 fastCert10_3891=true := by decide +kernel
def fastCert10_3892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3892 : checkCertificateFast 10 3892 fastCert10_3892=true := by decide +kernel
def fastCert10_3893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3893 : checkCertificateFast 10 3893 fastCert10_3893=true := by decide +kernel
def fastCert10_3894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3894 : checkCertificateFast 10 3894 fastCert10_3894=true := by decide +kernel
def fastCert10_3895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3895 : checkCertificateFast 10 3895 fastCert10_3895=true := by decide +kernel
def fastCert10_3896 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3896 : checkCertificateFast 10 3896 fastCert10_3896=true := by decide +kernel
def fastCert10_3897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3897 : checkCertificateFast 10 3897 fastCert10_3897=true := by decide +kernel
def fastCert10_3898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3898 : checkCertificateFast 10 3898 fastCert10_3898=true := by decide +kernel
def fastCert10_3899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3899 : checkCertificateFast 10 3899 fastCert10_3899=true := by decide +kernel
def fastCert10_3900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3900 : checkCertificateFast 10 3900 fastCert10_3900=true := by decide +kernel
def fastCert10_3901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3901 : checkCertificateFast 10 3901 fastCert10_3901=true := by decide +kernel
def fastCert10_3902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3902 : checkCertificateFast 10 3902 fastCert10_3902=true := by decide +kernel
def fastCert10_3903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3903 : checkCertificateFast 10 3903 fastCert10_3903=true := by decide +kernel
def fastCert10_3904 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3904 : checkCertificateFast 10 3904 fastCert10_3904=true := by decide +kernel
def fastCert10_3905 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3905 : checkCertificateFast 10 3905 fastCert10_3905=true := by decide +kernel
def fastCert10_3906 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3906 : checkCertificateFast 10 3906 fastCert10_3906=true := by decide +kernel
def fastCert10_3907 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3907 : checkCertificateFast 10 3907 fastCert10_3907=true := by decide +kernel
def fastCert10_3908 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3908 : checkCertificateFast 10 3908 fastCert10_3908=true := by decide +kernel
def fastCert10_3909 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_3909 : checkCertificateFast 10 3909 fastCert10_3909=true := by decide +kernel
def fastCert10_3910 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3910 : checkCertificateFast 10 3910 fastCert10_3910=true := by decide +kernel
def fastCert10_3911 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3911 : checkCertificateFast 10 3911 fastCert10_3911=true := by decide +kernel
def fastCert10_3912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3912 : checkCertificateFast 10 3912 fastCert10_3912=true := by decide +kernel
def fastCert10_3913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3913 : checkCertificateFast 10 3913 fastCert10_3913=true := by decide +kernel
def fastCert10_3914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3914 : checkCertificateFast 10 3914 fastCert10_3914=true := by decide +kernel
def fastCert10_3915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3915 : checkCertificateFast 10 3915 fastCert10_3915=true := by decide +kernel
def fastCert10_3916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3916 : checkCertificateFast 10 3916 fastCert10_3916=true := by decide +kernel
def fastCert10_3917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3917 : checkCertificateFast 10 3917 fastCert10_3917=true := by decide +kernel
def fastCert10_3918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3918 : checkCertificateFast 10 3918 fastCert10_3918=true := by decide +kernel
def fastCert10_3919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3919 : checkCertificateFast 10 3919 fastCert10_3919=true := by decide +kernel
def fastCert10_3920 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3920 : checkCertificateFast 10 3920 fastCert10_3920=true := by decide +kernel
def fastCert10_3921 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3921 : checkCertificateFast 10 3921 fastCert10_3921=true := by decide +kernel
def fastCert10_3922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3922 : checkCertificateFast 10 3922 fastCert10_3922=true := by decide +kernel
def fastCert10_3923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3923 : checkCertificateFast 10 3923 fastCert10_3923=true := by decide +kernel
def fastCert10_3924 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3924 : checkCertificateFast 10 3924 fastCert10_3924=true := by decide +kernel
def fastCert10_3925 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3925 : checkCertificateFast 10 3925 fastCert10_3925=true := by decide +kernel
def fastCert10_3926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3926 : checkCertificateFast 10 3926 fastCert10_3926=true := by decide +kernel
def fastCert10_3927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3927 : checkCertificateFast 10 3927 fastCert10_3927=true := by decide +kernel
def fastCert10_3928 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3928 : checkCertificateFast 10 3928 fastCert10_3928=true := by decide +kernel
def fastCert10_3929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3929 : checkCertificateFast 10 3929 fastCert10_3929=true := by decide +kernel
def fastCert10_3930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3930 : checkCertificateFast 10 3930 fastCert10_3930=true := by decide +kernel
def fastCert10_3931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3931 : checkCertificateFast 10 3931 fastCert10_3931=true := by decide +kernel
def fastCert10_3932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3932 : checkCertificateFast 10 3932 fastCert10_3932=true := by decide +kernel
def fastCert10_3933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3933 : checkCertificateFast 10 3933 fastCert10_3933=true := by decide +kernel
def fastCert10_3934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3934 : checkCertificateFast 10 3934 fastCert10_3934=true := by decide +kernel
def fastCert10_3935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3935 : checkCertificateFast 10 3935 fastCert10_3935=true := by decide +kernel
def fastCert10_3936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3936 : checkCertificateFast 10 3936 fastCert10_3936=true := by decide +kernel
def fastCert10_3937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_3937 : checkCertificateFast 10 3937 fastCert10_3937=true := by decide +kernel
def fastCert10_3938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3938 : checkCertificateFast 10 3938 fastCert10_3938=true := by decide +kernel
def fastCert10_3939 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_3939 : checkCertificateFast 10 3939 fastCert10_3939=true := by decide +kernel
def fastCert10_3940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3940 : checkCertificateFast 10 3940 fastCert10_3940=true := by decide +kernel
def fastCert10_3941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3941 : checkCertificateFast 10 3941 fastCert10_3941=true := by decide +kernel
def fastCert10_3942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3942 : checkCertificateFast 10 3942 fastCert10_3942=true := by decide +kernel
def fastCert10_3943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3943 : checkCertificateFast 10 3943 fastCert10_3943=true := by decide +kernel
def fastCert10_3944 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3944 : checkCertificateFast 10 3944 fastCert10_3944=true := by decide +kernel
def fastCert10_3945 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3945 : checkCertificateFast 10 3945 fastCert10_3945=true := by decide +kernel
def fastCert10_3946 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3946 : checkCertificateFast 10 3946 fastCert10_3946=true := by decide +kernel
def fastCert10_3947 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3947 : checkCertificateFast 10 3947 fastCert10_3947=true := by decide +kernel
def fastCert10_3948 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3948 : checkCertificateFast 10 3948 fastCert10_3948=true := by decide +kernel
def fastCert10_3949 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3949 : checkCertificateFast 10 3949 fastCert10_3949=true := by decide +kernel
def fastCert10_3950 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3950 : checkCertificateFast 10 3950 fastCert10_3950=true := by decide +kernel
def fastCert10_3951 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_3951 : checkCertificateFast 10 3951 fastCert10_3951=true := by decide +kernel
def fastCert10_3952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3952 : checkCertificateFast 10 3952 fastCert10_3952=true := by decide +kernel
def fastCert10_3953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_3953 : checkCertificateFast 10 3953 fastCert10_3953=true := by decide +kernel
def fastCert10_3954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3954 : checkCertificateFast 10 3954 fastCert10_3954=true := by decide +kernel
def fastCert10_3955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3955 : checkCertificateFast 10 3955 fastCert10_3955=true := by decide +kernel
def fastCert10_3956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3956 : checkCertificateFast 10 3956 fastCert10_3956=true := by decide +kernel
def fastCert10_3957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3957 : checkCertificateFast 10 3957 fastCert10_3957=true := by decide +kernel
def fastCert10_3958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_3958 : checkCertificateFast 10 3958 fastCert10_3958=true := by decide +kernel
def fastCert10_3959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3959 : checkCertificateFast 10 3959 fastCert10_3959=true := by decide +kernel
def fastCert10_3960 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3960 : checkCertificateFast 10 3960 fastCert10_3960=true := by decide +kernel
def fastCert10_3961 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3961 : checkCertificateFast 10 3961 fastCert10_3961=true := by decide +kernel
def fastCert10_3962 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3962 : checkCertificateFast 10 3962 fastCert10_3962=true := by decide +kernel
def fastCert10_3963 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3963 : checkCertificateFast 10 3963 fastCert10_3963=true := by decide +kernel
def fastCert10_3964 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3964 : checkCertificateFast 10 3964 fastCert10_3964=true := by decide +kernel
def fastCert10_3965 : Certificate := ⟨18,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3965 : checkCertificateFast 10 3965 fastCert10_3965=true := by decide +kernel
def fastCert10_3966 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3966 : checkCertificateFast 10 3966 fastCert10_3966=true := by decide +kernel
def fastCert10_3967 : Certificate := ⟨18,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3967 : checkCertificateFast 10 3967 fastCert10_3967=true := by decide +kernel
def fastCert10_3968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3968 : checkCertificateFast 10 3968 fastCert10_3968=true := by decide +kernel
def fastCert10_3969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3969 : checkCertificateFast 10 3969 fastCert10_3969=true := by decide +kernel
def fastCert10_3970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3970 : checkCertificateFast 10 3970 fastCert10_3970=true := by decide +kernel
def fastCert10_3971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3971 : checkCertificateFast 10 3971 fastCert10_3971=true := by decide +kernel
def fastCert10_3972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3972 : checkCertificateFast 10 3972 fastCert10_3972=true := by decide +kernel
def fastCert10_3973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3973 : checkCertificateFast 10 3973 fastCert10_3973=true := by decide +kernel
def fastCert10_3974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3974 : checkCertificateFast 10 3974 fastCert10_3974=true := by decide +kernel
def fastCert10_3975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3975 : checkCertificateFast 10 3975 fastCert10_3975=true := by decide +kernel
def fastCert10_3976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3976 : checkCertificateFast 10 3976 fastCert10_3976=true := by decide +kernel
def fastCert10_3977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3977 : checkCertificateFast 10 3977 fastCert10_3977=true := by decide +kernel
def fastCert10_3978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3978 : checkCertificateFast 10 3978 fastCert10_3978=true := by decide +kernel
def fastCert10_3979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_3979 : checkCertificateFast 10 3979 fastCert10_3979=true := by decide +kernel
def fastCert10_3980 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3980 : checkCertificateFast 10 3980 fastCert10_3980=true := by decide +kernel
def fastCert10_3981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3981 : checkCertificateFast 10 3981 fastCert10_3981=true := by decide +kernel
def fastCert10_3982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3982 : checkCertificateFast 10 3982 fastCert10_3982=true := by decide +kernel
def fastCert10_3983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3983 : checkCertificateFast 10 3983 fastCert10_3983=true := by decide +kernel
def fastCert10_3984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3984 : checkCertificateFast 10 3984 fastCert10_3984=true := by decide +kernel
def fastCert10_3985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3985 : checkCertificateFast 10 3985 fastCert10_3985=true := by decide +kernel
def fastCert10_3986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3986 : checkCertificateFast 10 3986 fastCert10_3986=true := by decide +kernel
def fastCert10_3987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_3987 : checkCertificateFast 10 3987 fastCert10_3987=true := by decide +kernel
def fastCert10_3988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3988 : checkCertificateFast 10 3988 fastCert10_3988=true := by decide +kernel
def fastCert10_3989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3989 : checkCertificateFast 10 3989 fastCert10_3989=true := by decide +kernel
def fastCert10_3990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3990 : checkCertificateFast 10 3990 fastCert10_3990=true := by decide +kernel
def fastCert10_3991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3991 : checkCertificateFast 10 3991 fastCert10_3991=true := by decide +kernel
def fastCert10_3992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3992 : checkCertificateFast 10 3992 fastCert10_3992=true := by decide +kernel
def fastCert10_3993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3993 : checkCertificateFast 10 3993 fastCert10_3993=true := by decide +kernel
def fastCert10_3994 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_3994 : checkCertificateFast 10 3994 fastCert10_3994=true := by decide +kernel
def fastCert10_3995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_3995 : checkCertificateFast 10 3995 fastCert10_3995=true := by decide +kernel
def fastCert10_3996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_3996 : checkCertificateFast 10 3996 fastCert10_3996=true := by decide +kernel
def fastCert10_3997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_3997 : checkCertificateFast 10 3997 fastCert10_3997=true := by decide +kernel
def fastCert10_3998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3998 : checkCertificateFast 10 3998 fastCert10_3998=true := by decide +kernel
def fastCert10_3999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_3999 : checkCertificateFast 10 3999 fastCert10_3999=true := by decide +kernel
theorem aggregate_F10_003 : (checkCertificateFast 10 3000 fastCert10_3000=true) ∧ (checkCertificateFast 10 3001 fastCert10_3001=true) ∧ (checkCertificateFast 10 3002 fastCert10_3002=true) ∧ (checkCertificateFast 10 3003 fastCert10_3003=true) ∧ (checkCertificateFast 10 3004 fastCert10_3004=true) ∧ (checkCertificateFast 10 3005 fastCert10_3005=true) ∧ (checkCertificateFast 10 3006 fastCert10_3006=true) ∧ (checkCertificateFast 10 3007 fastCert10_3007=true) ∧ (checkCertificateFast 10 3008 fastCert10_3008=true) ∧ (checkCertificateFast 10 3009 fastCert10_3009=true) ∧ (checkCertificateFast 10 3010 fastCert10_3010=true) ∧ (checkCertificateFast 10 3011 fastCert10_3011=true) ∧ (checkCertificateFast 10 3012 fastCert10_3012=true) ∧ (checkCertificateFast 10 3013 fastCert10_3013=true) ∧ (checkCertificateFast 10 3014 fastCert10_3014=true) ∧ (checkCertificateFast 10 3015 fastCert10_3015=true) ∧ (checkCertificateFast 10 3016 fastCert10_3016=true) ∧ (checkCertificateFast 10 3017 fastCert10_3017=true) ∧ (checkCertificateFast 10 3018 fastCert10_3018=true) ∧ (checkCertificateFast 10 3019 fastCert10_3019=true) ∧ (checkCertificateFast 10 3020 fastCert10_3020=true) ∧ (checkCertificateFast 10 3021 fastCert10_3021=true) ∧ (checkCertificateFast 10 3022 fastCert10_3022=true) ∧ (checkCertificateFast 10 3023 fastCert10_3023=true) ∧ (checkCertificateFast 10 3024 fastCert10_3024=true) ∧ (checkCertificateFast 10 3025 fastCert10_3025=true) ∧ (checkCertificateFast 10 3026 fastCert10_3026=true) ∧ (checkCertificateFast 10 3027 fastCert10_3027=true) ∧ (checkCertificateFast 10 3028 fastCert10_3028=true) ∧ (checkCertificateFast 10 3029 fastCert10_3029=true) ∧ (checkCertificateFast 10 3030 fastCert10_3030=true) ∧ (checkCertificateFast 10 3031 fastCert10_3031=true) ∧ (checkCertificateFast 10 3032 fastCert10_3032=true) ∧ (checkCertificateFast 10 3033 fastCert10_3033=true) ∧ (checkCertificateFast 10 3034 fastCert10_3034=true) ∧ (checkCertificateFast 10 3035 fastCert10_3035=true) ∧ (checkCertificateFast 10 3036 fastCert10_3036=true) ∧ (checkCertificateFast 10 3037 fastCert10_3037=true) ∧ (checkCertificateFast 10 3038 fastCert10_3038=true) ∧ (checkCertificateFast 10 3039 fastCert10_3039=true) ∧ (checkCertificateFast 10 3040 fastCert10_3040=true) ∧ (checkCertificateFast 10 3041 fastCert10_3041=true) ∧ (checkCertificateFast 10 3042 fastCert10_3042=true) ∧ (checkCertificateFast 10 3043 fastCert10_3043=true) ∧ (checkCertificateFast 10 3044 fastCert10_3044=true) ∧ (checkCertificateFast 10 3045 fastCert10_3045=true) ∧ (checkCertificateFast 10 3046 fastCert10_3046=true) ∧ (checkCertificateFast 10 3047 fastCert10_3047=true) ∧ (checkCertificateFast 10 3048 fastCert10_3048=true) ∧ (checkCertificateFast 10 3049 fastCert10_3049=true) ∧ (checkCertificateFast 10 3050 fastCert10_3050=true) ∧ (checkCertificateFast 10 3051 fastCert10_3051=true) ∧ (checkCertificateFast 10 3052 fastCert10_3052=true) ∧ (checkCertificateFast 10 3053 fastCert10_3053=true) ∧ (checkCertificateFast 10 3054 fastCert10_3054=true) ∧ (checkCertificateFast 10 3055 fastCert10_3055=true) ∧ (checkCertificateFast 10 3056 fastCert10_3056=true) ∧ (checkCertificateFast 10 3057 fastCert10_3057=true) ∧ (checkCertificateFast 10 3058 fastCert10_3058=true) ∧ (checkCertificateFast 10 3059 fastCert10_3059=true) ∧ (checkCertificateFast 10 3060 fastCert10_3060=true) ∧ (checkCertificateFast 10 3061 fastCert10_3061=true) ∧ (checkCertificateFast 10 3062 fastCert10_3062=true) ∧ (checkCertificateFast 10 3063 fastCert10_3063=true) ∧ (checkCertificateFast 10 3064 fastCert10_3064=true) ∧ (checkCertificateFast 10 3065 fastCert10_3065=true) ∧ (checkCertificateFast 10 3066 fastCert10_3066=true) ∧ (checkCertificateFast 10 3067 fastCert10_3067=true) ∧ (checkCertificateFast 10 3068 fastCert10_3068=true) ∧ (checkCertificateFast 10 3069 fastCert10_3069=true) ∧ (checkCertificateFast 10 3070 fastCert10_3070=true) ∧ (checkCertificateFast 10 3071 fastCert10_3071=true) ∧ (checkCertificateFast 10 3072 fastCert10_3072=true) ∧ (checkCertificateFast 10 3073 fastCert10_3073=true) ∧ (checkCertificateFast 10 3074 fastCert10_3074=true) ∧ (checkCertificateFast 10 3075 fastCert10_3075=true) ∧ (checkCertificateFast 10 3076 fastCert10_3076=true) ∧ (checkCertificateFast 10 3077 fastCert10_3077=true) ∧ (checkCertificateFast 10 3078 fastCert10_3078=true) ∧ (checkCertificateFast 10 3079 fastCert10_3079=true) ∧ (checkCertificateFast 10 3080 fastCert10_3080=true) ∧ (checkCertificateFast 10 3081 fastCert10_3081=true) ∧ (checkCertificateFast 10 3082 fastCert10_3082=true) ∧ (checkCertificateFast 10 3083 fastCert10_3083=true) ∧ (checkCertificateFast 10 3084 fastCert10_3084=true) ∧ (checkCertificateFast 10 3085 fastCert10_3085=true) ∧ (checkCertificateFast 10 3086 fastCert10_3086=true) ∧ (checkCertificateFast 10 3087 fastCert10_3087=true) ∧ (checkCertificateFast 10 3088 fastCert10_3088=true) ∧ (checkCertificateFast 10 3089 fastCert10_3089=true) ∧ (checkCertificateFast 10 3090 fastCert10_3090=true) ∧ (checkCertificateFast 10 3091 fastCert10_3091=true) ∧ (checkCertificateFast 10 3092 fastCert10_3092=true) ∧ (checkCertificateFast 10 3093 fastCert10_3093=true) ∧ (checkCertificateFast 10 3094 fastCert10_3094=true) ∧ (checkCertificateFast 10 3095 fastCert10_3095=true) ∧ (checkCertificateFast 10 3096 fastCert10_3096=true) ∧ (checkCertificateFast 10 3097 fastCert10_3097=true) ∧ (checkCertificateFast 10 3098 fastCert10_3098=true) ∧ (checkCertificateFast 10 3099 fastCert10_3099=true) ∧ (checkCertificateFast 10 3100 fastCert10_3100=true) ∧ (checkCertificateFast 10 3101 fastCert10_3101=true) ∧ (checkCertificateFast 10 3102 fastCert10_3102=true) ∧ (checkCertificateFast 10 3103 fastCert10_3103=true) ∧ (checkCertificateFast 10 3104 fastCert10_3104=true) ∧ (checkCertificateFast 10 3105 fastCert10_3105=true) ∧ (checkCertificateFast 10 3106 fastCert10_3106=true) ∧ (checkCertificateFast 10 3107 fastCert10_3107=true) ∧ (checkCertificateFast 10 3108 fastCert10_3108=true) ∧ (checkCertificateFast 10 3109 fastCert10_3109=true) ∧ (checkCertificateFast 10 3110 fastCert10_3110=true) ∧ (checkCertificateFast 10 3111 fastCert10_3111=true) ∧ (checkCertificateFast 10 3112 fastCert10_3112=true) ∧ (checkCertificateFast 10 3113 fastCert10_3113=true) ∧ (checkCertificateFast 10 3114 fastCert10_3114=true) ∧ (checkCertificateFast 10 3115 fastCert10_3115=true) ∧ (checkCertificateFast 10 3116 fastCert10_3116=true) ∧ (checkCertificateFast 10 3117 fastCert10_3117=true) ∧ (checkCertificateFast 10 3118 fastCert10_3118=true) ∧ (checkCertificateFast 10 3119 fastCert10_3119=true) ∧ (checkCertificateFast 10 3120 fastCert10_3120=true) ∧ (checkCertificateFast 10 3121 fastCert10_3121=true) ∧ (checkCertificateFast 10 3122 fastCert10_3122=true) ∧ (checkCertificateFast 10 3123 fastCert10_3123=true) ∧ (checkCertificateFast 10 3124 fastCert10_3124=true) ∧ (checkCertificateFast 10 3125 fastCert10_3125=true) ∧ (checkCertificateFast 10 3126 fastCert10_3126=true) ∧ (checkCertificateFast 10 3127 fastCert10_3127=true) ∧ (checkCertificateFast 10 3128 fastCert10_3128=true) ∧ (checkCertificateFast 10 3129 fastCert10_3129=true) ∧ (checkCertificateFast 10 3130 fastCert10_3130=true) ∧ (checkCertificateFast 10 3131 fastCert10_3131=true) ∧ (checkCertificateFast 10 3132 fastCert10_3132=true) ∧ (checkCertificateFast 10 3133 fastCert10_3133=true) ∧ (checkCertificateFast 10 3134 fastCert10_3134=true) ∧ (checkCertificateFast 10 3135 fastCert10_3135=true) ∧ (checkCertificateFast 10 3136 fastCert10_3136=true) ∧ (checkCertificateFast 10 3137 fastCert10_3137=true) ∧ (checkCertificateFast 10 3138 fastCert10_3138=true) ∧ (checkCertificateFast 10 3139 fastCert10_3139=true) ∧ (checkCertificateFast 10 3140 fastCert10_3140=true) ∧ (checkCertificateFast 10 3141 fastCert10_3141=true) ∧ (checkCertificateFast 10 3142 fastCert10_3142=true) ∧ (checkCertificateFast 10 3143 fastCert10_3143=true) ∧ (checkCertificateFast 10 3144 fastCert10_3144=true) ∧ (checkCertificateFast 10 3145 fastCert10_3145=true) ∧ (checkCertificateFast 10 3146 fastCert10_3146=true) ∧ (checkCertificateFast 10 3147 fastCert10_3147=true) ∧ (checkCertificateFast 10 3148 fastCert10_3148=true) ∧ (checkCertificateFast 10 3149 fastCert10_3149=true) ∧ (checkCertificateFast 10 3150 fastCert10_3150=true) ∧ (checkCertificateFast 10 3151 fastCert10_3151=true) ∧ (checkCertificateFast 10 3152 fastCert10_3152=true) ∧ (checkCertificateFast 10 3153 fastCert10_3153=true) ∧ (checkCertificateFast 10 3154 fastCert10_3154=true) ∧ (checkCertificateFast 10 3155 fastCert10_3155=true) ∧ (checkCertificateFast 10 3156 fastCert10_3156=true) ∧ (checkCertificateFast 10 3157 fastCert10_3157=true) ∧ (checkCertificateFast 10 3158 fastCert10_3158=true) ∧ (checkCertificateFast 10 3159 fastCert10_3159=true) ∧ (checkCertificateFast 10 3160 fastCert10_3160=true) ∧ (checkCertificateFast 10 3161 fastCert10_3161=true) ∧ (checkCertificateFast 10 3162 fastCert10_3162=true) ∧ (checkCertificateFast 10 3163 fastCert10_3163=true) ∧ (checkCertificateFast 10 3164 fastCert10_3164=true) ∧ (checkCertificateFast 10 3165 fastCert10_3165=true) ∧ (checkCertificateFast 10 3166 fastCert10_3166=true) ∧ (checkCertificateFast 10 3167 fastCert10_3167=true) ∧ (checkCertificateFast 10 3168 fastCert10_3168=true) ∧ (checkCertificateFast 10 3169 fastCert10_3169=true) ∧ (checkCertificateFast 10 3170 fastCert10_3170=true) ∧ (checkCertificateFast 10 3171 fastCert10_3171=true) ∧ (checkCertificateFast 10 3172 fastCert10_3172=true) ∧ (checkCertificateFast 10 3173 fastCert10_3173=true) ∧ (checkCertificateFast 10 3174 fastCert10_3174=true) ∧ (checkCertificateFast 10 3175 fastCert10_3175=true) ∧ (checkCertificateFast 10 3176 fastCert10_3176=true) ∧ (checkCertificateFast 10 3177 fastCert10_3177=true) ∧ (checkCertificateFast 10 3178 fastCert10_3178=true) ∧ (checkCertificateFast 10 3179 fastCert10_3179=true) ∧ (checkCertificateFast 10 3180 fastCert10_3180=true) ∧ (checkCertificateFast 10 3181 fastCert10_3181=true) ∧ (checkCertificateFast 10 3182 fastCert10_3182=true) ∧ (checkCertificateFast 10 3183 fastCert10_3183=true) ∧ (checkCertificateFast 10 3184 fastCert10_3184=true) ∧ (checkCertificateFast 10 3185 fastCert10_3185=true) ∧ (checkCertificateFast 10 3186 fastCert10_3186=true) ∧ (checkCertificateFast 10 3187 fastCert10_3187=true) ∧ (checkCertificateFast 10 3188 fastCert10_3188=true) ∧ (checkCertificateFast 10 3189 fastCert10_3189=true) ∧ (checkCertificateFast 10 3190 fastCert10_3190=true) ∧ (checkCertificateFast 10 3191 fastCert10_3191=true) ∧ (checkCertificateFast 10 3192 fastCert10_3192=true) ∧ (checkCertificateFast 10 3193 fastCert10_3193=true) ∧ (checkCertificateFast 10 3194 fastCert10_3194=true) ∧ (checkCertificateFast 10 3195 fastCert10_3195=true) ∧ (checkCertificateFast 10 3196 fastCert10_3196=true) ∧ (checkCertificateFast 10 3197 fastCert10_3197=true) ∧ (checkCertificateFast 10 3198 fastCert10_3198=true) ∧ (checkCertificateFast 10 3199 fastCert10_3199=true) ∧ (checkCertificateFast 10 3200 fastCert10_3200=true) ∧ (checkCertificateFast 10 3201 fastCert10_3201=true) ∧ (checkCertificateFast 10 3202 fastCert10_3202=true) ∧ (checkCertificateFast 10 3203 fastCert10_3203=true) ∧ (checkCertificateFast 10 3204 fastCert10_3204=true) ∧ (checkCertificateFast 10 3205 fastCert10_3205=true) ∧ (checkCertificateFast 10 3206 fastCert10_3206=true) ∧ (checkCertificateFast 10 3207 fastCert10_3207=true) ∧ (checkCertificateFast 10 3208 fastCert10_3208=true) ∧ (checkCertificateFast 10 3209 fastCert10_3209=true) ∧ (checkCertificateFast 10 3210 fastCert10_3210=true) ∧ (checkCertificateFast 10 3211 fastCert10_3211=true) ∧ (checkCertificateFast 10 3212 fastCert10_3212=true) ∧ (checkCertificateFast 10 3213 fastCert10_3213=true) ∧ (checkCertificateFast 10 3214 fastCert10_3214=true) ∧ (checkCertificateFast 10 3215 fastCert10_3215=true) ∧ (checkCertificateFast 10 3216 fastCert10_3216=true) ∧ (checkCertificateFast 10 3217 fastCert10_3217=true) ∧ (checkCertificateFast 10 3218 fastCert10_3218=true) ∧ (checkCertificateFast 10 3219 fastCert10_3219=true) ∧ (checkCertificateFast 10 3220 fastCert10_3220=true) ∧ (checkCertificateFast 10 3221 fastCert10_3221=true) ∧ (checkCertificateFast 10 3222 fastCert10_3222=true) ∧ (checkCertificateFast 10 3223 fastCert10_3223=true) ∧ (checkCertificateFast 10 3224 fastCert10_3224=true) ∧ (checkCertificateFast 10 3225 fastCert10_3225=true) ∧ (checkCertificateFast 10 3226 fastCert10_3226=true) ∧ (checkCertificateFast 10 3227 fastCert10_3227=true) ∧ (checkCertificateFast 10 3228 fastCert10_3228=true) ∧ (checkCertificateFast 10 3229 fastCert10_3229=true) ∧ (checkCertificateFast 10 3230 fastCert10_3230=true) ∧ (checkCertificateFast 10 3231 fastCert10_3231=true) ∧ (checkCertificateFast 10 3232 fastCert10_3232=true) ∧ (checkCertificateFast 10 3233 fastCert10_3233=true) ∧ (checkCertificateFast 10 3234 fastCert10_3234=true) ∧ (checkCertificateFast 10 3235 fastCert10_3235=true) ∧ (checkCertificateFast 10 3236 fastCert10_3236=true) ∧ (checkCertificateFast 10 3237 fastCert10_3237=true) ∧ (checkCertificateFast 10 3238 fastCert10_3238=true) ∧ (checkCertificateFast 10 3239 fastCert10_3239=true) ∧ (checkCertificateFast 10 3240 fastCert10_3240=true) ∧ (checkCertificateFast 10 3241 fastCert10_3241=true) ∧ (checkCertificateFast 10 3242 fastCert10_3242=true) ∧ (checkCertificateFast 10 3243 fastCert10_3243=true) ∧ (checkCertificateFast 10 3244 fastCert10_3244=true) ∧ (checkCertificateFast 10 3245 fastCert10_3245=true) ∧ (checkCertificateFast 10 3246 fastCert10_3246=true) ∧ (checkCertificateFast 10 3247 fastCert10_3247=true) ∧ (checkCertificateFast 10 3248 fastCert10_3248=true) ∧ (checkCertificateFast 10 3249 fastCert10_3249=true) ∧ (checkCertificateFast 10 3250 fastCert10_3250=true) ∧ (checkCertificateFast 10 3251 fastCert10_3251=true) ∧ (checkCertificateFast 10 3252 fastCert10_3252=true) ∧ (checkCertificateFast 10 3253 fastCert10_3253=true) ∧ (checkCertificateFast 10 3254 fastCert10_3254=true) ∧ (checkCertificateFast 10 3255 fastCert10_3255=true) ∧ (checkCertificateFast 10 3256 fastCert10_3256=true) ∧ (checkCertificateFast 10 3257 fastCert10_3257=true) ∧ (checkCertificateFast 10 3258 fastCert10_3258=true) ∧ (checkCertificateFast 10 3259 fastCert10_3259=true) ∧ (checkCertificateFast 10 3260 fastCert10_3260=true) ∧ (checkCertificateFast 10 3261 fastCert10_3261=true) ∧ (checkCertificateFast 10 3262 fastCert10_3262=true) ∧ (checkCertificateFast 10 3263 fastCert10_3263=true) ∧ (checkCertificateFast 10 3264 fastCert10_3264=true) ∧ (checkCertificateFast 10 3265 fastCert10_3265=true) ∧ (checkCertificateFast 10 3266 fastCert10_3266=true) ∧ (checkCertificateFast 10 3267 fastCert10_3267=true) ∧ (checkCertificateFast 10 3268 fastCert10_3268=true) ∧ (checkCertificateFast 10 3269 fastCert10_3269=true) ∧ (checkCertificateFast 10 3270 fastCert10_3270=true) ∧ (checkCertificateFast 10 3271 fastCert10_3271=true) ∧ (checkCertificateFast 10 3272 fastCert10_3272=true) ∧ (checkCertificateFast 10 3273 fastCert10_3273=true) ∧ (checkCertificateFast 10 3274 fastCert10_3274=true) ∧ (checkCertificateFast 10 3275 fastCert10_3275=true) ∧ (checkCertificateFast 10 3276 fastCert10_3276=true) ∧ (checkCertificateFast 10 3277 fastCert10_3277=true) ∧ (checkCertificateFast 10 3278 fastCert10_3278=true) ∧ (checkCertificateFast 10 3279 fastCert10_3279=true) ∧ (checkCertificateFast 10 3280 fastCert10_3280=true) ∧ (checkCertificateFast 10 3281 fastCert10_3281=true) ∧ (checkCertificateFast 10 3282 fastCert10_3282=true) ∧ (checkCertificateFast 10 3283 fastCert10_3283=true) ∧ (checkCertificateFast 10 3284 fastCert10_3284=true) ∧ (checkCertificateFast 10 3285 fastCert10_3285=true) ∧ (checkCertificateFast 10 3286 fastCert10_3286=true) ∧ (checkCertificateFast 10 3287 fastCert10_3287=true) ∧ (checkCertificateFast 10 3288 fastCert10_3288=true) ∧ (checkCertificateFast 10 3289 fastCert10_3289=true) ∧ (checkCertificateFast 10 3290 fastCert10_3290=true) ∧ (checkCertificateFast 10 3291 fastCert10_3291=true) ∧ (checkCertificateFast 10 3292 fastCert10_3292=true) ∧ (checkCertificateFast 10 3293 fastCert10_3293=true) ∧ (checkCertificateFast 10 3294 fastCert10_3294=true) ∧ (checkCertificateFast 10 3295 fastCert10_3295=true) ∧ (checkCertificateFast 10 3296 fastCert10_3296=true) ∧ (checkCertificateFast 10 3297 fastCert10_3297=true) ∧ (checkCertificateFast 10 3298 fastCert10_3298=true) ∧ (checkCertificateFast 10 3299 fastCert10_3299=true) ∧ (checkCertificateFast 10 3300 fastCert10_3300=true) ∧ (checkCertificateFast 10 3301 fastCert10_3301=true) ∧ (checkCertificateFast 10 3302 fastCert10_3302=true) ∧ (checkCertificateFast 10 3303 fastCert10_3303=true) ∧ (checkCertificateFast 10 3304 fastCert10_3304=true) ∧ (checkCertificateFast 10 3305 fastCert10_3305=true) ∧ (checkCertificateFast 10 3306 fastCert10_3306=true) ∧ (checkCertificateFast 10 3307 fastCert10_3307=true) ∧ (checkCertificateFast 10 3308 fastCert10_3308=true) ∧ (checkCertificateFast 10 3309 fastCert10_3309=true) ∧ (checkCertificateFast 10 3310 fastCert10_3310=true) ∧ (checkCertificateFast 10 3311 fastCert10_3311=true) ∧ (checkCertificateFast 10 3312 fastCert10_3312=true) ∧ (checkCertificateFast 10 3313 fastCert10_3313=true) ∧ (checkCertificateFast 10 3314 fastCert10_3314=true) ∧ (checkCertificateFast 10 3315 fastCert10_3315=true) ∧ (checkCertificateFast 10 3316 fastCert10_3316=true) ∧ (checkCertificateFast 10 3317 fastCert10_3317=true) ∧ (checkCertificateFast 10 3318 fastCert10_3318=true) ∧ (checkCertificateFast 10 3319 fastCert10_3319=true) ∧ (checkCertificateFast 10 3320 fastCert10_3320=true) ∧ (checkCertificateFast 10 3321 fastCert10_3321=true) ∧ (checkCertificateFast 10 3322 fastCert10_3322=true) ∧ (checkCertificateFast 10 3323 fastCert10_3323=true) ∧ (checkCertificateFast 10 3324 fastCert10_3324=true) ∧ (checkCertificateFast 10 3325 fastCert10_3325=true) ∧ (checkCertificateFast 10 3326 fastCert10_3326=true) ∧ (checkCertificateFast 10 3327 fastCert10_3327=true) ∧ (checkCertificateFast 10 3328 fastCert10_3328=true) ∧ (checkCertificateFast 10 3329 fastCert10_3329=true) ∧ (checkCertificateFast 10 3330 fastCert10_3330=true) ∧ (checkCertificateFast 10 3331 fastCert10_3331=true) ∧ (checkCertificateFast 10 3332 fastCert10_3332=true) ∧ (checkCertificateFast 10 3333 fastCert10_3333=true) ∧ (checkCertificateFast 10 3334 fastCert10_3334=true) ∧ (checkCertificateFast 10 3335 fastCert10_3335=true) ∧ (checkCertificateFast 10 3336 fastCert10_3336=true) ∧ (checkCertificateFast 10 3337 fastCert10_3337=true) ∧ (checkCertificateFast 10 3338 fastCert10_3338=true) ∧ (checkCertificateFast 10 3339 fastCert10_3339=true) ∧ (checkCertificateFast 10 3340 fastCert10_3340=true) ∧ (checkCertificateFast 10 3341 fastCert10_3341=true) ∧ (checkCertificateFast 10 3342 fastCert10_3342=true) ∧ (checkCertificateFast 10 3343 fastCert10_3343=true) ∧ (checkCertificateFast 10 3344 fastCert10_3344=true) ∧ (checkCertificateFast 10 3345 fastCert10_3345=true) ∧ (checkCertificateFast 10 3346 fastCert10_3346=true) ∧ (checkCertificateFast 10 3347 fastCert10_3347=true) ∧ (checkCertificateFast 10 3348 fastCert10_3348=true) ∧ (checkCertificateFast 10 3349 fastCert10_3349=true) ∧ (checkCertificateFast 10 3350 fastCert10_3350=true) ∧ (checkCertificateFast 10 3351 fastCert10_3351=true) ∧ (checkCertificateFast 10 3352 fastCert10_3352=true) ∧ (checkCertificateFast 10 3353 fastCert10_3353=true) ∧ (checkCertificateFast 10 3354 fastCert10_3354=true) ∧ (checkCertificateFast 10 3355 fastCert10_3355=true) ∧ (checkCertificateFast 10 3356 fastCert10_3356=true) ∧ (checkCertificateFast 10 3357 fastCert10_3357=true) ∧ (checkCertificateFast 10 3358 fastCert10_3358=true) ∧ (checkCertificateFast 10 3359 fastCert10_3359=true) ∧ (checkCertificateFast 10 3360 fastCert10_3360=true) ∧ (checkCertificateFast 10 3361 fastCert10_3361=true) ∧ (checkCertificateFast 10 3362 fastCert10_3362=true) ∧ (checkCertificateFast 10 3363 fastCert10_3363=true) ∧ (checkCertificateFast 10 3364 fastCert10_3364=true) ∧ (checkCertificateFast 10 3365 fastCert10_3365=true) ∧ (checkCertificateFast 10 3366 fastCert10_3366=true) ∧ (checkCertificateFast 10 3367 fastCert10_3367=true) ∧ (checkCertificateFast 10 3368 fastCert10_3368=true) ∧ (checkCertificateFast 10 3369 fastCert10_3369=true) ∧ (checkCertificateFast 10 3370 fastCert10_3370=true) ∧ (checkCertificateFast 10 3371 fastCert10_3371=true) ∧ (checkCertificateFast 10 3372 fastCert10_3372=true) ∧ (checkCertificateFast 10 3373 fastCert10_3373=true) ∧ (checkCertificateFast 10 3374 fastCert10_3374=true) ∧ (checkCertificateFast 10 3375 fastCert10_3375=true) ∧ (checkCertificateFast 10 3376 fastCert10_3376=true) ∧ (checkCertificateFast 10 3377 fastCert10_3377=true) ∧ (checkCertificateFast 10 3378 fastCert10_3378=true) ∧ (checkCertificateFast 10 3379 fastCert10_3379=true) ∧ (checkCertificateFast 10 3380 fastCert10_3380=true) ∧ (checkCertificateFast 10 3381 fastCert10_3381=true) ∧ (checkCertificateFast 10 3382 fastCert10_3382=true) ∧ (checkCertificateFast 10 3383 fastCert10_3383=true) ∧ (checkCertificateFast 10 3384 fastCert10_3384=true) ∧ (checkCertificateFast 10 3385 fastCert10_3385=true) ∧ (checkCertificateFast 10 3386 fastCert10_3386=true) ∧ (checkCertificateFast 10 3387 fastCert10_3387=true) ∧ (checkCertificateFast 10 3388 fastCert10_3388=true) ∧ (checkCertificateFast 10 3389 fastCert10_3389=true) ∧ (checkCertificateFast 10 3390 fastCert10_3390=true) ∧ (checkCertificateFast 10 3391 fastCert10_3391=true) ∧ (checkCertificateFast 10 3392 fastCert10_3392=true) ∧ (checkCertificateFast 10 3393 fastCert10_3393=true) ∧ (checkCertificateFast 10 3394 fastCert10_3394=true) ∧ (checkCertificateFast 10 3395 fastCert10_3395=true) ∧ (checkCertificateFast 10 3396 fastCert10_3396=true) ∧ (checkCertificateFast 10 3397 fastCert10_3397=true) ∧ (checkCertificateFast 10 3398 fastCert10_3398=true) ∧ (checkCertificateFast 10 3399 fastCert10_3399=true) ∧ (checkCertificateFast 10 3400 fastCert10_3400=true) ∧ (checkCertificateFast 10 3401 fastCert10_3401=true) ∧ (checkCertificateFast 10 3402 fastCert10_3402=true) ∧ (checkCertificateFast 10 3403 fastCert10_3403=true) ∧ (checkCertificateFast 10 3404 fastCert10_3404=true) ∧ (checkCertificateFast 10 3405 fastCert10_3405=true) ∧ (checkCertificateFast 10 3406 fastCert10_3406=true) ∧ (checkCertificateFast 10 3407 fastCert10_3407=true) ∧ (checkCertificateFast 10 3408 fastCert10_3408=true) ∧ (checkCertificateFast 10 3409 fastCert10_3409=true) ∧ (checkCertificateFast 10 3410 fastCert10_3410=true) ∧ (checkCertificateFast 10 3411 fastCert10_3411=true) ∧ (checkCertificateFast 10 3412 fastCert10_3412=true) ∧ (checkCertificateFast 10 3413 fastCert10_3413=true) ∧ (checkCertificateFast 10 3414 fastCert10_3414=true) ∧ (checkCertificateFast 10 3415 fastCert10_3415=true) ∧ (checkCertificateFast 10 3416 fastCert10_3416=true) ∧ (checkCertificateFast 10 3417 fastCert10_3417=true) ∧ (checkCertificateFast 10 3418 fastCert10_3418=true) ∧ (checkCertificateFast 10 3419 fastCert10_3419=true) ∧ (checkCertificateFast 10 3420 fastCert10_3420=true) ∧ (checkCertificateFast 10 3421 fastCert10_3421=true) ∧ (checkCertificateFast 10 3422 fastCert10_3422=true) ∧ (checkCertificateFast 10 3423 fastCert10_3423=true) ∧ (checkCertificateFast 10 3424 fastCert10_3424=true) ∧ (checkCertificateFast 10 3425 fastCert10_3425=true) ∧ (checkCertificateFast 10 3426 fastCert10_3426=true) ∧ (checkCertificateFast 10 3427 fastCert10_3427=true) ∧ (checkCertificateFast 10 3428 fastCert10_3428=true) ∧ (checkCertificateFast 10 3429 fastCert10_3429=true) ∧ (checkCertificateFast 10 3430 fastCert10_3430=true) ∧ (checkCertificateFast 10 3431 fastCert10_3431=true) ∧ (checkCertificateFast 10 3432 fastCert10_3432=true) ∧ (checkCertificateFast 10 3433 fastCert10_3433=true) ∧ (checkCertificateFast 10 3434 fastCert10_3434=true) ∧ (checkCertificateFast 10 3435 fastCert10_3435=true) ∧ (checkCertificateFast 10 3436 fastCert10_3436=true) ∧ (checkCertificateFast 10 3437 fastCert10_3437=true) ∧ (checkCertificateFast 10 3438 fastCert10_3438=true) ∧ (checkCertificateFast 10 3439 fastCert10_3439=true) ∧ (checkCertificateFast 10 3440 fastCert10_3440=true) ∧ (checkCertificateFast 10 3441 fastCert10_3441=true) ∧ (checkCertificateFast 10 3442 fastCert10_3442=true) ∧ (checkCertificateFast 10 3443 fastCert10_3443=true) ∧ (checkCertificateFast 10 3444 fastCert10_3444=true) ∧ (checkCertificateFast 10 3445 fastCert10_3445=true) ∧ (checkCertificateFast 10 3446 fastCert10_3446=true) ∧ (checkCertificateFast 10 3447 fastCert10_3447=true) ∧ (checkCertificateFast 10 3448 fastCert10_3448=true) ∧ (checkCertificateFast 10 3449 fastCert10_3449=true) ∧ (checkCertificateFast 10 3450 fastCert10_3450=true) ∧ (checkCertificateFast 10 3451 fastCert10_3451=true) ∧ (checkCertificateFast 10 3452 fastCert10_3452=true) ∧ (checkCertificateFast 10 3453 fastCert10_3453=true) ∧ (checkCertificateFast 10 3454 fastCert10_3454=true) ∧ (checkCertificateFast 10 3455 fastCert10_3455=true) ∧ (checkCertificateFast 10 3456 fastCert10_3456=true) ∧ (checkCertificateFast 10 3457 fastCert10_3457=true) ∧ (checkCertificateFast 10 3458 fastCert10_3458=true) ∧ (checkCertificateFast 10 3459 fastCert10_3459=true) ∧ (checkCertificateFast 10 3460 fastCert10_3460=true) ∧ (checkCertificateFast 10 3461 fastCert10_3461=true) ∧ (checkCertificateFast 10 3462 fastCert10_3462=true) ∧ (checkCertificateFast 10 3463 fastCert10_3463=true) ∧ (checkCertificateFast 10 3464 fastCert10_3464=true) ∧ (checkCertificateFast 10 3465 fastCert10_3465=true) ∧ (checkCertificateFast 10 3466 fastCert10_3466=true) ∧ (checkCertificateFast 10 3467 fastCert10_3467=true) ∧ (checkCertificateFast 10 3468 fastCert10_3468=true) ∧ (checkCertificateFast 10 3469 fastCert10_3469=true) ∧ (checkCertificateFast 10 3470 fastCert10_3470=true) ∧ (checkCertificateFast 10 3471 fastCert10_3471=true) ∧ (checkCertificateFast 10 3472 fastCert10_3472=true) ∧ (checkCertificateFast 10 3473 fastCert10_3473=true) ∧ (checkCertificateFast 10 3474 fastCert10_3474=true) ∧ (checkCertificateFast 10 3475 fastCert10_3475=true) ∧ (checkCertificateFast 10 3476 fastCert10_3476=true) ∧ (checkCertificateFast 10 3477 fastCert10_3477=true) ∧ (checkCertificateFast 10 3478 fastCert10_3478=true) ∧ (checkCertificateFast 10 3479 fastCert10_3479=true) ∧ (checkCertificateFast 10 3480 fastCert10_3480=true) ∧ (checkCertificateFast 10 3481 fastCert10_3481=true) ∧ (checkCertificateFast 10 3482 fastCert10_3482=true) ∧ (checkCertificateFast 10 3483 fastCert10_3483=true) ∧ (checkCertificateFast 10 3484 fastCert10_3484=true) ∧ (checkCertificateFast 10 3485 fastCert10_3485=true) ∧ (checkCertificateFast 10 3486 fastCert10_3486=true) ∧ (checkCertificateFast 10 3487 fastCert10_3487=true) ∧ (checkCertificateFast 10 3488 fastCert10_3488=true) ∧ (checkCertificateFast 10 3489 fastCert10_3489=true) ∧ (checkCertificateFast 10 3490 fastCert10_3490=true) ∧ (checkCertificateFast 10 3491 fastCert10_3491=true) ∧ (checkCertificateFast 10 3492 fastCert10_3492=true) ∧ (checkCertificateFast 10 3493 fastCert10_3493=true) ∧ (checkCertificateFast 10 3494 fastCert10_3494=true) ∧ (checkCertificateFast 10 3495 fastCert10_3495=true) ∧ (checkCertificateFast 10 3496 fastCert10_3496=true) ∧ (checkCertificateFast 10 3497 fastCert10_3497=true) ∧ (checkCertificateFast 10 3498 fastCert10_3498=true) ∧ (checkCertificateFast 10 3499 fastCert10_3499=true) ∧ (checkCertificateFast 10 3500 fastCert10_3500=true) ∧ (checkCertificateFast 10 3501 fastCert10_3501=true) ∧ (checkCertificateFast 10 3502 fastCert10_3502=true) ∧ (checkCertificateFast 10 3503 fastCert10_3503=true) ∧ (checkCertificateFast 10 3504 fastCert10_3504=true) ∧ (checkCertificateFast 10 3505 fastCert10_3505=true) ∧ (checkCertificateFast 10 3506 fastCert10_3506=true) ∧ (checkCertificateFast 10 3507 fastCert10_3507=true) ∧ (checkCertificateFast 10 3508 fastCert10_3508=true) ∧ (checkCertificateFast 10 3509 fastCert10_3509=true) ∧ (checkCertificateFast 10 3510 fastCert10_3510=true) ∧ (checkCertificateFast 10 3511 fastCert10_3511=true) ∧ (checkCertificateFast 10 3512 fastCert10_3512=true) ∧ (checkCertificateFast 10 3513 fastCert10_3513=true) ∧ (checkCertificateFast 10 3514 fastCert10_3514=true) ∧ (checkCertificateFast 10 3515 fastCert10_3515=true) ∧ (checkCertificateFast 10 3516 fastCert10_3516=true) ∧ (checkCertificateFast 10 3517 fastCert10_3517=true) ∧ (checkCertificateFast 10 3518 fastCert10_3518=true) ∧ (checkCertificateFast 10 3519 fastCert10_3519=true) ∧ (checkCertificateFast 10 3520 fastCert10_3520=true) ∧ (checkCertificateFast 10 3521 fastCert10_3521=true) ∧ (checkCertificateFast 10 3522 fastCert10_3522=true) ∧ (checkCertificateFast 10 3523 fastCert10_3523=true) ∧ (checkCertificateFast 10 3524 fastCert10_3524=true) ∧ (checkCertificateFast 10 3525 fastCert10_3525=true) ∧ (checkCertificateFast 10 3526 fastCert10_3526=true) ∧ (checkCertificateFast 10 3527 fastCert10_3527=true) ∧ (checkCertificateFast 10 3528 fastCert10_3528=true) ∧ (checkCertificateFast 10 3529 fastCert10_3529=true) ∧ (checkCertificateFast 10 3530 fastCert10_3530=true) ∧ (checkCertificateFast 10 3531 fastCert10_3531=true) ∧ (checkCertificateFast 10 3532 fastCert10_3532=true) ∧ (checkCertificateFast 10 3533 fastCert10_3533=true) ∧ (checkCertificateFast 10 3534 fastCert10_3534=true) ∧ (checkCertificateFast 10 3535 fastCert10_3535=true) ∧ (checkCertificateFast 10 3536 fastCert10_3536=true) ∧ (checkCertificateFast 10 3537 fastCert10_3537=true) ∧ (checkCertificateFast 10 3538 fastCert10_3538=true) ∧ (checkCertificateFast 10 3539 fastCert10_3539=true) ∧ (checkCertificateFast 10 3540 fastCert10_3540=true) ∧ (checkCertificateFast 10 3541 fastCert10_3541=true) ∧ (checkCertificateFast 10 3542 fastCert10_3542=true) ∧ (checkCertificateFast 10 3543 fastCert10_3543=true) ∧ (checkCertificateFast 10 3544 fastCert10_3544=true) ∧ (checkCertificateFast 10 3545 fastCert10_3545=true) ∧ (checkCertificateFast 10 3546 fastCert10_3546=true) ∧ (checkCertificateFast 10 3547 fastCert10_3547=true) ∧ (checkCertificateFast 10 3548 fastCert10_3548=true) ∧ (checkCertificateFast 10 3549 fastCert10_3549=true) ∧ (checkCertificateFast 10 3550 fastCert10_3550=true) ∧ (checkCertificateFast 10 3551 fastCert10_3551=true) ∧ (checkCertificateFast 10 3552 fastCert10_3552=true) ∧ (checkCertificateFast 10 3553 fastCert10_3553=true) ∧ (checkCertificateFast 10 3554 fastCert10_3554=true) ∧ (checkCertificateFast 10 3555 fastCert10_3555=true) ∧ (checkCertificateFast 10 3556 fastCert10_3556=true) ∧ (checkCertificateFast 10 3557 fastCert10_3557=true) ∧ (checkCertificateFast 10 3558 fastCert10_3558=true) ∧ (checkCertificateFast 10 3559 fastCert10_3559=true) ∧ (checkCertificateFast 10 3560 fastCert10_3560=true) ∧ (checkCertificateFast 10 3561 fastCert10_3561=true) ∧ (checkCertificateFast 10 3562 fastCert10_3562=true) ∧ (checkCertificateFast 10 3563 fastCert10_3563=true) ∧ (checkCertificateFast 10 3564 fastCert10_3564=true) ∧ (checkCertificateFast 10 3565 fastCert10_3565=true) ∧ (checkCertificateFast 10 3566 fastCert10_3566=true) ∧ (checkCertificateFast 10 3567 fastCert10_3567=true) ∧ (checkCertificateFast 10 3568 fastCert10_3568=true) ∧ (checkCertificateFast 10 3569 fastCert10_3569=true) ∧ (checkCertificateFast 10 3570 fastCert10_3570=true) ∧ (checkCertificateFast 10 3571 fastCert10_3571=true) ∧ (checkCertificateFast 10 3572 fastCert10_3572=true) ∧ (checkCertificateFast 10 3573 fastCert10_3573=true) ∧ (checkCertificateFast 10 3574 fastCert10_3574=true) ∧ (checkCertificateFast 10 3575 fastCert10_3575=true) ∧ (checkCertificateFast 10 3576 fastCert10_3576=true) ∧ (checkCertificateFast 10 3577 fastCert10_3577=true) ∧ (checkCertificateFast 10 3578 fastCert10_3578=true) ∧ (checkCertificateFast 10 3579 fastCert10_3579=true) ∧ (checkCertificateFast 10 3580 fastCert10_3580=true) ∧ (checkCertificateFast 10 3581 fastCert10_3581=true) ∧ (checkCertificateFast 10 3582 fastCert10_3582=true) ∧ (checkCertificateFast 10 3583 fastCert10_3583=true) ∧ (checkCertificateFast 10 3584 fastCert10_3584=true) ∧ (checkCertificateFast 10 3585 fastCert10_3585=true) ∧ (checkCertificateFast 10 3586 fastCert10_3586=true) ∧ (checkCertificateFast 10 3587 fastCert10_3587=true) ∧ (checkCertificateFast 10 3588 fastCert10_3588=true) ∧ (checkCertificateFast 10 3589 fastCert10_3589=true) ∧ (checkCertificateFast 10 3590 fastCert10_3590=true) ∧ (checkCertificateFast 10 3591 fastCert10_3591=true) ∧ (checkCertificateFast 10 3592 fastCert10_3592=true) ∧ (checkCertificateFast 10 3593 fastCert10_3593=true) ∧ (checkCertificateFast 10 3594 fastCert10_3594=true) ∧ (checkCertificateFast 10 3595 fastCert10_3595=true) ∧ (checkCertificateFast 10 3596 fastCert10_3596=true) ∧ (checkCertificateFast 10 3597 fastCert10_3597=true) ∧ (checkCertificateFast 10 3598 fastCert10_3598=true) ∧ (checkCertificateFast 10 3599 fastCert10_3599=true) ∧ (checkCertificateFast 10 3600 fastCert10_3600=true) ∧ (checkCertificateFast 10 3601 fastCert10_3601=true) ∧ (checkCertificateFast 10 3602 fastCert10_3602=true) ∧ (checkCertificateFast 10 3603 fastCert10_3603=true) ∧ (checkCertificateFast 10 3604 fastCert10_3604=true) ∧ (checkCertificateFast 10 3605 fastCert10_3605=true) ∧ (checkCertificateFast 10 3606 fastCert10_3606=true) ∧ (checkCertificateFast 10 3607 fastCert10_3607=true) ∧ (checkCertificateFast 10 3608 fastCert10_3608=true) ∧ (checkCertificateFast 10 3609 fastCert10_3609=true) ∧ (checkCertificateFast 10 3610 fastCert10_3610=true) ∧ (checkCertificateFast 10 3611 fastCert10_3611=true) ∧ (checkCertificateFast 10 3612 fastCert10_3612=true) ∧ (checkCertificateFast 10 3613 fastCert10_3613=true) ∧ (checkCertificateFast 10 3614 fastCert10_3614=true) ∧ (checkCertificateFast 10 3615 fastCert10_3615=true) ∧ (checkCertificateFast 10 3616 fastCert10_3616=true) ∧ (checkCertificateFast 10 3617 fastCert10_3617=true) ∧ (checkCertificateFast 10 3618 fastCert10_3618=true) ∧ (checkCertificateFast 10 3619 fastCert10_3619=true) ∧ (checkCertificateFast 10 3620 fastCert10_3620=true) ∧ (checkCertificateFast 10 3621 fastCert10_3621=true) ∧ (checkCertificateFast 10 3622 fastCert10_3622=true) ∧ (checkCertificateFast 10 3623 fastCert10_3623=true) ∧ (checkCertificateFast 10 3624 fastCert10_3624=true) ∧ (checkCertificateFast 10 3625 fastCert10_3625=true) ∧ (checkCertificateFast 10 3626 fastCert10_3626=true) ∧ (checkCertificateFast 10 3627 fastCert10_3627=true) ∧ (checkCertificateFast 10 3628 fastCert10_3628=true) ∧ (checkCertificateFast 10 3629 fastCert10_3629=true) ∧ (checkCertificateFast 10 3630 fastCert10_3630=true) ∧ (checkCertificateFast 10 3631 fastCert10_3631=true) ∧ (checkCertificateFast 10 3632 fastCert10_3632=true) ∧ (checkCertificateFast 10 3633 fastCert10_3633=true) ∧ (checkCertificateFast 10 3634 fastCert10_3634=true) ∧ (checkCertificateFast 10 3635 fastCert10_3635=true) ∧ (checkCertificateFast 10 3636 fastCert10_3636=true) ∧ (checkCertificateFast 10 3637 fastCert10_3637=true) ∧ (checkCertificateFast 10 3638 fastCert10_3638=true) ∧ (checkCertificateFast 10 3639 fastCert10_3639=true) ∧ (checkCertificateFast 10 3640 fastCert10_3640=true) ∧ (checkCertificateFast 10 3641 fastCert10_3641=true) ∧ (checkCertificateFast 10 3642 fastCert10_3642=true) ∧ (checkCertificateFast 10 3643 fastCert10_3643=true) ∧ (checkCertificateFast 10 3644 fastCert10_3644=true) ∧ (checkCertificateFast 10 3645 fastCert10_3645=true) ∧ (checkCertificateFast 10 3646 fastCert10_3646=true) ∧ (checkCertificateFast 10 3647 fastCert10_3647=true) ∧ (checkCertificateFast 10 3648 fastCert10_3648=true) ∧ (checkCertificateFast 10 3649 fastCert10_3649=true) ∧ (checkCertificateFast 10 3650 fastCert10_3650=true) ∧ (checkCertificateFast 10 3651 fastCert10_3651=true) ∧ (checkCertificateFast 10 3652 fastCert10_3652=true) ∧ (checkCertificateFast 10 3653 fastCert10_3653=true) ∧ (checkCertificateFast 10 3654 fastCert10_3654=true) ∧ (checkCertificateFast 10 3655 fastCert10_3655=true) ∧ (checkCertificateFast 10 3656 fastCert10_3656=true) ∧ (checkCertificateFast 10 3657 fastCert10_3657=true) ∧ (checkCertificateFast 10 3658 fastCert10_3658=true) ∧ (checkCertificateFast 10 3659 fastCert10_3659=true) ∧ (checkCertificateFast 10 3660 fastCert10_3660=true) ∧ (checkCertificateFast 10 3661 fastCert10_3661=true) ∧ (checkCertificateFast 10 3662 fastCert10_3662=true) ∧ (checkCertificateFast 10 3663 fastCert10_3663=true) ∧ (checkCertificateFast 10 3664 fastCert10_3664=true) ∧ (checkCertificateFast 10 3665 fastCert10_3665=true) ∧ (checkCertificateFast 10 3666 fastCert10_3666=true) ∧ (checkCertificateFast 10 3667 fastCert10_3667=true) ∧ (checkCertificateFast 10 3668 fastCert10_3668=true) ∧ (checkCertificateFast 10 3669 fastCert10_3669=true) ∧ (checkCertificateFast 10 3670 fastCert10_3670=true) ∧ (checkCertificateFast 10 3671 fastCert10_3671=true) ∧ (checkCertificateFast 10 3672 fastCert10_3672=true) ∧ (checkCertificateFast 10 3673 fastCert10_3673=true) ∧ (checkCertificateFast 10 3674 fastCert10_3674=true) ∧ (checkCertificateFast 10 3675 fastCert10_3675=true) ∧ (checkCertificateFast 10 3676 fastCert10_3676=true) ∧ (checkCertificateFast 10 3677 fastCert10_3677=true) ∧ (checkCertificateFast 10 3678 fastCert10_3678=true) ∧ (checkCertificateFast 10 3679 fastCert10_3679=true) ∧ (checkCertificateFast 10 3680 fastCert10_3680=true) ∧ (checkCertificateFast 10 3681 fastCert10_3681=true) ∧ (checkCertificateFast 10 3682 fastCert10_3682=true) ∧ (checkCertificateFast 10 3683 fastCert10_3683=true) ∧ (checkCertificateFast 10 3684 fastCert10_3684=true) ∧ (checkCertificateFast 10 3685 fastCert10_3685=true) ∧ (checkCertificateFast 10 3686 fastCert10_3686=true) ∧ (checkCertificateFast 10 3687 fastCert10_3687=true) ∧ (checkCertificateFast 10 3688 fastCert10_3688=true) ∧ (checkCertificateFast 10 3689 fastCert10_3689=true) ∧ (checkCertificateFast 10 3690 fastCert10_3690=true) ∧ (checkCertificateFast 10 3691 fastCert10_3691=true) ∧ (checkCertificateFast 10 3692 fastCert10_3692=true) ∧ (checkCertificateFast 10 3693 fastCert10_3693=true) ∧ (checkCertificateFast 10 3694 fastCert10_3694=true) ∧ (checkCertificateFast 10 3695 fastCert10_3695=true) ∧ (checkCertificateFast 10 3696 fastCert10_3696=true) ∧ (checkCertificateFast 10 3697 fastCert10_3697=true) ∧ (checkCertificateFast 10 3698 fastCert10_3698=true) ∧ (checkCertificateFast 10 3699 fastCert10_3699=true) ∧ (checkCertificateFast 10 3700 fastCert10_3700=true) ∧ (checkCertificateFast 10 3701 fastCert10_3701=true) ∧ (checkCertificateFast 10 3702 fastCert10_3702=true) ∧ (checkCertificateFast 10 3703 fastCert10_3703=true) ∧ (checkCertificateFast 10 3704 fastCert10_3704=true) ∧ (checkCertificateFast 10 3705 fastCert10_3705=true) ∧ (checkCertificateFast 10 3706 fastCert10_3706=true) ∧ (checkCertificateFast 10 3707 fastCert10_3707=true) ∧ (checkCertificateFast 10 3708 fastCert10_3708=true) ∧ (checkCertificateFast 10 3709 fastCert10_3709=true) ∧ (checkCertificateFast 10 3710 fastCert10_3710=true) ∧ (checkCertificateFast 10 3711 fastCert10_3711=true) ∧ (checkCertificateFast 10 3712 fastCert10_3712=true) ∧ (checkCertificateFast 10 3713 fastCert10_3713=true) ∧ (checkCertificateFast 10 3714 fastCert10_3714=true) ∧ (checkCertificateFast 10 3715 fastCert10_3715=true) ∧ (checkCertificateFast 10 3716 fastCert10_3716=true) ∧ (checkCertificateFast 10 3717 fastCert10_3717=true) ∧ (checkCertificateFast 10 3718 fastCert10_3718=true) ∧ (checkCertificateFast 10 3719 fastCert10_3719=true) ∧ (checkCertificateFast 10 3720 fastCert10_3720=true) ∧ (checkCertificateFast 10 3721 fastCert10_3721=true) ∧ (checkCertificateFast 10 3722 fastCert10_3722=true) ∧ (checkCertificateFast 10 3723 fastCert10_3723=true) ∧ (checkCertificateFast 10 3724 fastCert10_3724=true) ∧ (checkCertificateFast 10 3725 fastCert10_3725=true) ∧ (checkCertificateFast 10 3726 fastCert10_3726=true) ∧ (checkCertificateFast 10 3727 fastCert10_3727=true) ∧ (checkCertificateFast 10 3728 fastCert10_3728=true) ∧ (checkCertificateFast 10 3729 fastCert10_3729=true) ∧ (checkCertificateFast 10 3730 fastCert10_3730=true) ∧ (checkCertificateFast 10 3731 fastCert10_3731=true) ∧ (checkCertificateFast 10 3732 fastCert10_3732=true) ∧ (checkCertificateFast 10 3733 fastCert10_3733=true) ∧ (checkCertificateFast 10 3734 fastCert10_3734=true) ∧ (checkCertificateFast 10 3735 fastCert10_3735=true) ∧ (checkCertificateFast 10 3736 fastCert10_3736=true) ∧ (checkCertificateFast 10 3737 fastCert10_3737=true) ∧ (checkCertificateFast 10 3738 fastCert10_3738=true) ∧ (checkCertificateFast 10 3739 fastCert10_3739=true) ∧ (checkCertificateFast 10 3740 fastCert10_3740=true) ∧ (checkCertificateFast 10 3741 fastCert10_3741=true) ∧ (checkCertificateFast 10 3742 fastCert10_3742=true) ∧ (checkCertificateFast 10 3743 fastCert10_3743=true) ∧ (checkCertificateFast 10 3744 fastCert10_3744=true) ∧ (checkCertificateFast 10 3745 fastCert10_3745=true) ∧ (checkCertificateFast 10 3746 fastCert10_3746=true) ∧ (checkCertificateFast 10 3747 fastCert10_3747=true) ∧ (checkCertificateFast 10 3748 fastCert10_3748=true) ∧ (checkCertificateFast 10 3749 fastCert10_3749=true) ∧ (checkCertificateFast 10 3750 fastCert10_3750=true) ∧ (checkCertificateFast 10 3751 fastCert10_3751=true) ∧ (checkCertificateFast 10 3752 fastCert10_3752=true) ∧ (checkCertificateFast 10 3753 fastCert10_3753=true) ∧ (checkCertificateFast 10 3754 fastCert10_3754=true) ∧ (checkCertificateFast 10 3755 fastCert10_3755=true) ∧ (checkCertificateFast 10 3756 fastCert10_3756=true) ∧ (checkCertificateFast 10 3757 fastCert10_3757=true) ∧ (checkCertificateFast 10 3758 fastCert10_3758=true) ∧ (checkCertificateFast 10 3759 fastCert10_3759=true) ∧ (checkCertificateFast 10 3760 fastCert10_3760=true) ∧ (checkCertificateFast 10 3761 fastCert10_3761=true) ∧ (checkCertificateFast 10 3762 fastCert10_3762=true) ∧ (checkCertificateFast 10 3763 fastCert10_3763=true) ∧ (checkCertificateFast 10 3764 fastCert10_3764=true) ∧ (checkCertificateFast 10 3765 fastCert10_3765=true) ∧ (checkCertificateFast 10 3766 fastCert10_3766=true) ∧ (checkCertificateFast 10 3767 fastCert10_3767=true) ∧ (checkCertificateFast 10 3768 fastCert10_3768=true) ∧ (checkCertificateFast 10 3769 fastCert10_3769=true) ∧ (checkCertificateFast 10 3770 fastCert10_3770=true) ∧ (checkCertificateFast 10 3771 fastCert10_3771=true) ∧ (checkCertificateFast 10 3772 fastCert10_3772=true) ∧ (checkCertificateFast 10 3773 fastCert10_3773=true) ∧ (checkCertificateFast 10 3774 fastCert10_3774=true) ∧ (checkCertificateFast 10 3775 fastCert10_3775=true) ∧ (checkCertificateFast 10 3776 fastCert10_3776=true) ∧ (checkCertificateFast 10 3777 fastCert10_3777=true) ∧ (checkCertificateFast 10 3778 fastCert10_3778=true) ∧ (checkCertificateFast 10 3779 fastCert10_3779=true) ∧ (checkCertificateFast 10 3780 fastCert10_3780=true) ∧ (checkCertificateFast 10 3781 fastCert10_3781=true) ∧ (checkCertificateFast 10 3782 fastCert10_3782=true) ∧ (checkCertificateFast 10 3783 fastCert10_3783=true) ∧ (checkCertificateFast 10 3784 fastCert10_3784=true) ∧ (checkCertificateFast 10 3785 fastCert10_3785=true) ∧ (checkCertificateFast 10 3786 fastCert10_3786=true) ∧ (checkCertificateFast 10 3787 fastCert10_3787=true) ∧ (checkCertificateFast 10 3788 fastCert10_3788=true) ∧ (checkCertificateFast 10 3789 fastCert10_3789=true) ∧ (checkCertificateFast 10 3790 fastCert10_3790=true) ∧ (checkCertificateFast 10 3791 fastCert10_3791=true) ∧ (checkCertificateFast 10 3792 fastCert10_3792=true) ∧ (checkCertificateFast 10 3793 fastCert10_3793=true) ∧ (checkCertificateFast 10 3794 fastCert10_3794=true) ∧ (checkCertificateFast 10 3795 fastCert10_3795=true) ∧ (checkCertificateFast 10 3796 fastCert10_3796=true) ∧ (checkCertificateFast 10 3797 fastCert10_3797=true) ∧ (checkCertificateFast 10 3798 fastCert10_3798=true) ∧ (checkCertificateFast 10 3799 fastCert10_3799=true) ∧ (checkCertificateFast 10 3800 fastCert10_3800=true) ∧ (checkCertificateFast 10 3801 fastCert10_3801=true) ∧ (checkCertificateFast 10 3802 fastCert10_3802=true) ∧ (checkCertificateFast 10 3803 fastCert10_3803=true) ∧ (checkCertificateFast 10 3804 fastCert10_3804=true) ∧ (checkCertificateFast 10 3805 fastCert10_3805=true) ∧ (checkCertificateFast 10 3806 fastCert10_3806=true) ∧ (checkCertificateFast 10 3807 fastCert10_3807=true) ∧ (checkCertificateFast 10 3808 fastCert10_3808=true) ∧ (checkCertificateFast 10 3809 fastCert10_3809=true) ∧ (checkCertificateFast 10 3810 fastCert10_3810=true) ∧ (checkCertificateFast 10 3811 fastCert10_3811=true) ∧ (checkCertificateFast 10 3812 fastCert10_3812=true) ∧ (checkCertificateFast 10 3813 fastCert10_3813=true) ∧ (checkCertificateFast 10 3814 fastCert10_3814=true) ∧ (checkCertificateFast 10 3815 fastCert10_3815=true) ∧ (checkCertificateFast 10 3816 fastCert10_3816=true) ∧ (checkCertificateFast 10 3817 fastCert10_3817=true) ∧ (checkCertificateFast 10 3818 fastCert10_3818=true) ∧ (checkCertificateFast 10 3819 fastCert10_3819=true) ∧ (checkCertificateFast 10 3820 fastCert10_3820=true) ∧ (checkCertificateFast 10 3821 fastCert10_3821=true) ∧ (checkCertificateFast 10 3822 fastCert10_3822=true) ∧ (checkCertificateFast 10 3823 fastCert10_3823=true) ∧ (checkCertificateFast 10 3824 fastCert10_3824=true) ∧ (checkCertificateFast 10 3825 fastCert10_3825=true) ∧ (checkCertificateFast 10 3826 fastCert10_3826=true) ∧ (checkCertificateFast 10 3827 fastCert10_3827=true) ∧ (checkCertificateFast 10 3828 fastCert10_3828=true) ∧ (checkCertificateFast 10 3829 fastCert10_3829=true) ∧ (checkCertificateFast 10 3830 fastCert10_3830=true) ∧ (checkCertificateFast 10 3831 fastCert10_3831=true) ∧ (checkCertificateFast 10 3832 fastCert10_3832=true) ∧ (checkCertificateFast 10 3833 fastCert10_3833=true) ∧ (checkCertificateFast 10 3834 fastCert10_3834=true) ∧ (checkCertificateFast 10 3835 fastCert10_3835=true) ∧ (checkCertificateFast 10 3836 fastCert10_3836=true) ∧ (checkCertificateFast 10 3837 fastCert10_3837=true) ∧ (checkCertificateFast 10 3838 fastCert10_3838=true) ∧ (checkCertificateFast 10 3839 fastCert10_3839=true) ∧ (checkCertificateFast 10 3840 fastCert10_3840=true) ∧ (checkCertificateFast 10 3841 fastCert10_3841=true) ∧ (checkCertificateFast 10 3842 fastCert10_3842=true) ∧ (checkCertificateFast 10 3843 fastCert10_3843=true) ∧ (checkCertificateFast 10 3844 fastCert10_3844=true) ∧ (checkCertificateFast 10 3845 fastCert10_3845=true) ∧ (checkCertificateFast 10 3846 fastCert10_3846=true) ∧ (checkCertificateFast 10 3847 fastCert10_3847=true) ∧ (checkCertificateFast 10 3848 fastCert10_3848=true) ∧ (checkCertificateFast 10 3849 fastCert10_3849=true) ∧ (checkCertificateFast 10 3850 fastCert10_3850=true) ∧ (checkCertificateFast 10 3851 fastCert10_3851=true) ∧ (checkCertificateFast 10 3852 fastCert10_3852=true) ∧ (checkCertificateFast 10 3853 fastCert10_3853=true) ∧ (checkCertificateFast 10 3854 fastCert10_3854=true) ∧ (checkCertificateFast 10 3855 fastCert10_3855=true) ∧ (checkCertificateFast 10 3856 fastCert10_3856=true) ∧ (checkCertificateFast 10 3857 fastCert10_3857=true) ∧ (checkCertificateFast 10 3858 fastCert10_3858=true) ∧ (checkCertificateFast 10 3859 fastCert10_3859=true) ∧ (checkCertificateFast 10 3860 fastCert10_3860=true) ∧ (checkCertificateFast 10 3861 fastCert10_3861=true) ∧ (checkCertificateFast 10 3862 fastCert10_3862=true) ∧ (checkCertificateFast 10 3863 fastCert10_3863=true) ∧ (checkCertificateFast 10 3864 fastCert10_3864=true) ∧ (checkCertificateFast 10 3865 fastCert10_3865=true) ∧ (checkCertificateFast 10 3866 fastCert10_3866=true) ∧ (checkCertificateFast 10 3867 fastCert10_3867=true) ∧ (checkCertificateFast 10 3868 fastCert10_3868=true) ∧ (checkCertificateFast 10 3869 fastCert10_3869=true) ∧ (checkCertificateFast 10 3870 fastCert10_3870=true) ∧ (checkCertificateFast 10 3871 fastCert10_3871=true) ∧ (checkCertificateFast 10 3872 fastCert10_3872=true) ∧ (checkCertificateFast 10 3873 fastCert10_3873=true) ∧ (checkCertificateFast 10 3874 fastCert10_3874=true) ∧ (checkCertificateFast 10 3875 fastCert10_3875=true) ∧ (checkCertificateFast 10 3876 fastCert10_3876=true) ∧ (checkCertificateFast 10 3877 fastCert10_3877=true) ∧ (checkCertificateFast 10 3878 fastCert10_3878=true) ∧ (checkCertificateFast 10 3879 fastCert10_3879=true) ∧ (checkCertificateFast 10 3880 fastCert10_3880=true) ∧ (checkCertificateFast 10 3881 fastCert10_3881=true) ∧ (checkCertificateFast 10 3882 fastCert10_3882=true) ∧ (checkCertificateFast 10 3883 fastCert10_3883=true) ∧ (checkCertificateFast 10 3884 fastCert10_3884=true) ∧ (checkCertificateFast 10 3885 fastCert10_3885=true) ∧ (checkCertificateFast 10 3886 fastCert10_3886=true) ∧ (checkCertificateFast 10 3887 fastCert10_3887=true) ∧ (checkCertificateFast 10 3888 fastCert10_3888=true) ∧ (checkCertificateFast 10 3889 fastCert10_3889=true) ∧ (checkCertificateFast 10 3890 fastCert10_3890=true) ∧ (checkCertificateFast 10 3891 fastCert10_3891=true) ∧ (checkCertificateFast 10 3892 fastCert10_3892=true) ∧ (checkCertificateFast 10 3893 fastCert10_3893=true) ∧ (checkCertificateFast 10 3894 fastCert10_3894=true) ∧ (checkCertificateFast 10 3895 fastCert10_3895=true) ∧ (checkCertificateFast 10 3896 fastCert10_3896=true) ∧ (checkCertificateFast 10 3897 fastCert10_3897=true) ∧ (checkCertificateFast 10 3898 fastCert10_3898=true) ∧ (checkCertificateFast 10 3899 fastCert10_3899=true) ∧ (checkCertificateFast 10 3900 fastCert10_3900=true) ∧ (checkCertificateFast 10 3901 fastCert10_3901=true) ∧ (checkCertificateFast 10 3902 fastCert10_3902=true) ∧ (checkCertificateFast 10 3903 fastCert10_3903=true) ∧ (checkCertificateFast 10 3904 fastCert10_3904=true) ∧ (checkCertificateFast 10 3905 fastCert10_3905=true) ∧ (checkCertificateFast 10 3906 fastCert10_3906=true) ∧ (checkCertificateFast 10 3907 fastCert10_3907=true) ∧ (checkCertificateFast 10 3908 fastCert10_3908=true) ∧ (checkCertificateFast 10 3909 fastCert10_3909=true) ∧ (checkCertificateFast 10 3910 fastCert10_3910=true) ∧ (checkCertificateFast 10 3911 fastCert10_3911=true) ∧ (checkCertificateFast 10 3912 fastCert10_3912=true) ∧ (checkCertificateFast 10 3913 fastCert10_3913=true) ∧ (checkCertificateFast 10 3914 fastCert10_3914=true) ∧ (checkCertificateFast 10 3915 fastCert10_3915=true) ∧ (checkCertificateFast 10 3916 fastCert10_3916=true) ∧ (checkCertificateFast 10 3917 fastCert10_3917=true) ∧ (checkCertificateFast 10 3918 fastCert10_3918=true) ∧ (checkCertificateFast 10 3919 fastCert10_3919=true) ∧ (checkCertificateFast 10 3920 fastCert10_3920=true) ∧ (checkCertificateFast 10 3921 fastCert10_3921=true) ∧ (checkCertificateFast 10 3922 fastCert10_3922=true) ∧ (checkCertificateFast 10 3923 fastCert10_3923=true) ∧ (checkCertificateFast 10 3924 fastCert10_3924=true) ∧ (checkCertificateFast 10 3925 fastCert10_3925=true) ∧ (checkCertificateFast 10 3926 fastCert10_3926=true) ∧ (checkCertificateFast 10 3927 fastCert10_3927=true) ∧ (checkCertificateFast 10 3928 fastCert10_3928=true) ∧ (checkCertificateFast 10 3929 fastCert10_3929=true) ∧ (checkCertificateFast 10 3930 fastCert10_3930=true) ∧ (checkCertificateFast 10 3931 fastCert10_3931=true) ∧ (checkCertificateFast 10 3932 fastCert10_3932=true) ∧ (checkCertificateFast 10 3933 fastCert10_3933=true) ∧ (checkCertificateFast 10 3934 fastCert10_3934=true) ∧ (checkCertificateFast 10 3935 fastCert10_3935=true) ∧ (checkCertificateFast 10 3936 fastCert10_3936=true) ∧ (checkCertificateFast 10 3937 fastCert10_3937=true) ∧ (checkCertificateFast 10 3938 fastCert10_3938=true) ∧ (checkCertificateFast 10 3939 fastCert10_3939=true) ∧ (checkCertificateFast 10 3940 fastCert10_3940=true) ∧ (checkCertificateFast 10 3941 fastCert10_3941=true) ∧ (checkCertificateFast 10 3942 fastCert10_3942=true) ∧ (checkCertificateFast 10 3943 fastCert10_3943=true) ∧ (checkCertificateFast 10 3944 fastCert10_3944=true) ∧ (checkCertificateFast 10 3945 fastCert10_3945=true) ∧ (checkCertificateFast 10 3946 fastCert10_3946=true) ∧ (checkCertificateFast 10 3947 fastCert10_3947=true) ∧ (checkCertificateFast 10 3948 fastCert10_3948=true) ∧ (checkCertificateFast 10 3949 fastCert10_3949=true) ∧ (checkCertificateFast 10 3950 fastCert10_3950=true) ∧ (checkCertificateFast 10 3951 fastCert10_3951=true) ∧ (checkCertificateFast 10 3952 fastCert10_3952=true) ∧ (checkCertificateFast 10 3953 fastCert10_3953=true) ∧ (checkCertificateFast 10 3954 fastCert10_3954=true) ∧ (checkCertificateFast 10 3955 fastCert10_3955=true) ∧ (checkCertificateFast 10 3956 fastCert10_3956=true) ∧ (checkCertificateFast 10 3957 fastCert10_3957=true) ∧ (checkCertificateFast 10 3958 fastCert10_3958=true) ∧ (checkCertificateFast 10 3959 fastCert10_3959=true) ∧ (checkCertificateFast 10 3960 fastCert10_3960=true) ∧ (checkCertificateFast 10 3961 fastCert10_3961=true) ∧ (checkCertificateFast 10 3962 fastCert10_3962=true) ∧ (checkCertificateFast 10 3963 fastCert10_3963=true) ∧ (checkCertificateFast 10 3964 fastCert10_3964=true) ∧ (checkCertificateFast 10 3965 fastCert10_3965=true) ∧ (checkCertificateFast 10 3966 fastCert10_3966=true) ∧ (checkCertificateFast 10 3967 fastCert10_3967=true) ∧ (checkCertificateFast 10 3968 fastCert10_3968=true) ∧ (checkCertificateFast 10 3969 fastCert10_3969=true) ∧ (checkCertificateFast 10 3970 fastCert10_3970=true) ∧ (checkCertificateFast 10 3971 fastCert10_3971=true) ∧ (checkCertificateFast 10 3972 fastCert10_3972=true) ∧ (checkCertificateFast 10 3973 fastCert10_3973=true) ∧ (checkCertificateFast 10 3974 fastCert10_3974=true) ∧ (checkCertificateFast 10 3975 fastCert10_3975=true) ∧ (checkCertificateFast 10 3976 fastCert10_3976=true) ∧ (checkCertificateFast 10 3977 fastCert10_3977=true) ∧ (checkCertificateFast 10 3978 fastCert10_3978=true) ∧ (checkCertificateFast 10 3979 fastCert10_3979=true) ∧ (checkCertificateFast 10 3980 fastCert10_3980=true) ∧ (checkCertificateFast 10 3981 fastCert10_3981=true) ∧ (checkCertificateFast 10 3982 fastCert10_3982=true) ∧ (checkCertificateFast 10 3983 fastCert10_3983=true) ∧ (checkCertificateFast 10 3984 fastCert10_3984=true) ∧ (checkCertificateFast 10 3985 fastCert10_3985=true) ∧ (checkCertificateFast 10 3986 fastCert10_3986=true) ∧ (checkCertificateFast 10 3987 fastCert10_3987=true) ∧ (checkCertificateFast 10 3988 fastCert10_3988=true) ∧ (checkCertificateFast 10 3989 fastCert10_3989=true) ∧ (checkCertificateFast 10 3990 fastCert10_3990=true) ∧ (checkCertificateFast 10 3991 fastCert10_3991=true) ∧ (checkCertificateFast 10 3992 fastCert10_3992=true) ∧ (checkCertificateFast 10 3993 fastCert10_3993=true) ∧ (checkCertificateFast 10 3994 fastCert10_3994=true) ∧ (checkCertificateFast 10 3995 fastCert10_3995=true) ∧ (checkCertificateFast 10 3996 fastCert10_3996=true) ∧ (checkCertificateFast 10 3997 fastCert10_3997=true) ∧ (checkCertificateFast 10 3998 fastCert10_3998=true) ∧ (checkCertificateFast 10 3999 fastCert10_3999=true) :=
  ⟨fastCase10_3000,fastCase10_3001,fastCase10_3002,fastCase10_3003,fastCase10_3004,fastCase10_3005,fastCase10_3006,fastCase10_3007,fastCase10_3008,fastCase10_3009,fastCase10_3010,fastCase10_3011,fastCase10_3012,fastCase10_3013,fastCase10_3014,fastCase10_3015,fastCase10_3016,fastCase10_3017,fastCase10_3018,fastCase10_3019,fastCase10_3020,fastCase10_3021,fastCase10_3022,fastCase10_3023,fastCase10_3024,fastCase10_3025,fastCase10_3026,fastCase10_3027,fastCase10_3028,fastCase10_3029,fastCase10_3030,fastCase10_3031,fastCase10_3032,fastCase10_3033,fastCase10_3034,fastCase10_3035,fastCase10_3036,fastCase10_3037,fastCase10_3038,fastCase10_3039,fastCase10_3040,fastCase10_3041,fastCase10_3042,fastCase10_3043,fastCase10_3044,fastCase10_3045,fastCase10_3046,fastCase10_3047,fastCase10_3048,fastCase10_3049,fastCase10_3050,fastCase10_3051,fastCase10_3052,fastCase10_3053,fastCase10_3054,fastCase10_3055,fastCase10_3056,fastCase10_3057,fastCase10_3058,fastCase10_3059,fastCase10_3060,fastCase10_3061,fastCase10_3062,fastCase10_3063,fastCase10_3064,fastCase10_3065,fastCase10_3066,fastCase10_3067,fastCase10_3068,fastCase10_3069,fastCase10_3070,fastCase10_3071,fastCase10_3072,fastCase10_3073,fastCase10_3074,fastCase10_3075,fastCase10_3076,fastCase10_3077,fastCase10_3078,fastCase10_3079,fastCase10_3080,fastCase10_3081,fastCase10_3082,fastCase10_3083,fastCase10_3084,fastCase10_3085,fastCase10_3086,fastCase10_3087,fastCase10_3088,fastCase10_3089,fastCase10_3090,fastCase10_3091,fastCase10_3092,fastCase10_3093,fastCase10_3094,fastCase10_3095,fastCase10_3096,fastCase10_3097,fastCase10_3098,fastCase10_3099,fastCase10_3100,fastCase10_3101,fastCase10_3102,fastCase10_3103,fastCase10_3104,fastCase10_3105,fastCase10_3106,fastCase10_3107,fastCase10_3108,fastCase10_3109,fastCase10_3110,fastCase10_3111,fastCase10_3112,fastCase10_3113,fastCase10_3114,fastCase10_3115,fastCase10_3116,fastCase10_3117,fastCase10_3118,fastCase10_3119,fastCase10_3120,fastCase10_3121,fastCase10_3122,fastCase10_3123,fastCase10_3124,fastCase10_3125,fastCase10_3126,fastCase10_3127,fastCase10_3128,fastCase10_3129,fastCase10_3130,fastCase10_3131,fastCase10_3132,fastCase10_3133,fastCase10_3134,fastCase10_3135,fastCase10_3136,fastCase10_3137,fastCase10_3138,fastCase10_3139,fastCase10_3140,fastCase10_3141,fastCase10_3142,fastCase10_3143,fastCase10_3144,fastCase10_3145,fastCase10_3146,fastCase10_3147,fastCase10_3148,fastCase10_3149,fastCase10_3150,fastCase10_3151,fastCase10_3152,fastCase10_3153,fastCase10_3154,fastCase10_3155,fastCase10_3156,fastCase10_3157,fastCase10_3158,fastCase10_3159,fastCase10_3160,fastCase10_3161,fastCase10_3162,fastCase10_3163,fastCase10_3164,fastCase10_3165,fastCase10_3166,fastCase10_3167,fastCase10_3168,fastCase10_3169,fastCase10_3170,fastCase10_3171,fastCase10_3172,fastCase10_3173,fastCase10_3174,fastCase10_3175,fastCase10_3176,fastCase10_3177,fastCase10_3178,fastCase10_3179,fastCase10_3180,fastCase10_3181,fastCase10_3182,fastCase10_3183,fastCase10_3184,fastCase10_3185,fastCase10_3186,fastCase10_3187,fastCase10_3188,fastCase10_3189,fastCase10_3190,fastCase10_3191,fastCase10_3192,fastCase10_3193,fastCase10_3194,fastCase10_3195,fastCase10_3196,fastCase10_3197,fastCase10_3198,fastCase10_3199,fastCase10_3200,fastCase10_3201,fastCase10_3202,fastCase10_3203,fastCase10_3204,fastCase10_3205,fastCase10_3206,fastCase10_3207,fastCase10_3208,fastCase10_3209,fastCase10_3210,fastCase10_3211,fastCase10_3212,fastCase10_3213,fastCase10_3214,fastCase10_3215,fastCase10_3216,fastCase10_3217,fastCase10_3218,fastCase10_3219,fastCase10_3220,fastCase10_3221,fastCase10_3222,fastCase10_3223,fastCase10_3224,fastCase10_3225,fastCase10_3226,fastCase10_3227,fastCase10_3228,fastCase10_3229,fastCase10_3230,fastCase10_3231,fastCase10_3232,fastCase10_3233,fastCase10_3234,fastCase10_3235,fastCase10_3236,fastCase10_3237,fastCase10_3238,fastCase10_3239,fastCase10_3240,fastCase10_3241,fastCase10_3242,fastCase10_3243,fastCase10_3244,fastCase10_3245,fastCase10_3246,fastCase10_3247,fastCase10_3248,fastCase10_3249,fastCase10_3250,fastCase10_3251,fastCase10_3252,fastCase10_3253,fastCase10_3254,fastCase10_3255,fastCase10_3256,fastCase10_3257,fastCase10_3258,fastCase10_3259,fastCase10_3260,fastCase10_3261,fastCase10_3262,fastCase10_3263,fastCase10_3264,fastCase10_3265,fastCase10_3266,fastCase10_3267,fastCase10_3268,fastCase10_3269,fastCase10_3270,fastCase10_3271,fastCase10_3272,fastCase10_3273,fastCase10_3274,fastCase10_3275,fastCase10_3276,fastCase10_3277,fastCase10_3278,fastCase10_3279,fastCase10_3280,fastCase10_3281,fastCase10_3282,fastCase10_3283,fastCase10_3284,fastCase10_3285,fastCase10_3286,fastCase10_3287,fastCase10_3288,fastCase10_3289,fastCase10_3290,fastCase10_3291,fastCase10_3292,fastCase10_3293,fastCase10_3294,fastCase10_3295,fastCase10_3296,fastCase10_3297,fastCase10_3298,fastCase10_3299,fastCase10_3300,fastCase10_3301,fastCase10_3302,fastCase10_3303,fastCase10_3304,fastCase10_3305,fastCase10_3306,fastCase10_3307,fastCase10_3308,fastCase10_3309,fastCase10_3310,fastCase10_3311,fastCase10_3312,fastCase10_3313,fastCase10_3314,fastCase10_3315,fastCase10_3316,fastCase10_3317,fastCase10_3318,fastCase10_3319,fastCase10_3320,fastCase10_3321,fastCase10_3322,fastCase10_3323,fastCase10_3324,fastCase10_3325,fastCase10_3326,fastCase10_3327,fastCase10_3328,fastCase10_3329,fastCase10_3330,fastCase10_3331,fastCase10_3332,fastCase10_3333,fastCase10_3334,fastCase10_3335,fastCase10_3336,fastCase10_3337,fastCase10_3338,fastCase10_3339,fastCase10_3340,fastCase10_3341,fastCase10_3342,fastCase10_3343,fastCase10_3344,fastCase10_3345,fastCase10_3346,fastCase10_3347,fastCase10_3348,fastCase10_3349,fastCase10_3350,fastCase10_3351,fastCase10_3352,fastCase10_3353,fastCase10_3354,fastCase10_3355,fastCase10_3356,fastCase10_3357,fastCase10_3358,fastCase10_3359,fastCase10_3360,fastCase10_3361,fastCase10_3362,fastCase10_3363,fastCase10_3364,fastCase10_3365,fastCase10_3366,fastCase10_3367,fastCase10_3368,fastCase10_3369,fastCase10_3370,fastCase10_3371,fastCase10_3372,fastCase10_3373,fastCase10_3374,fastCase10_3375,fastCase10_3376,fastCase10_3377,fastCase10_3378,fastCase10_3379,fastCase10_3380,fastCase10_3381,fastCase10_3382,fastCase10_3383,fastCase10_3384,fastCase10_3385,fastCase10_3386,fastCase10_3387,fastCase10_3388,fastCase10_3389,fastCase10_3390,fastCase10_3391,fastCase10_3392,fastCase10_3393,fastCase10_3394,fastCase10_3395,fastCase10_3396,fastCase10_3397,fastCase10_3398,fastCase10_3399,fastCase10_3400,fastCase10_3401,fastCase10_3402,fastCase10_3403,fastCase10_3404,fastCase10_3405,fastCase10_3406,fastCase10_3407,fastCase10_3408,fastCase10_3409,fastCase10_3410,fastCase10_3411,fastCase10_3412,fastCase10_3413,fastCase10_3414,fastCase10_3415,fastCase10_3416,fastCase10_3417,fastCase10_3418,fastCase10_3419,fastCase10_3420,fastCase10_3421,fastCase10_3422,fastCase10_3423,fastCase10_3424,fastCase10_3425,fastCase10_3426,fastCase10_3427,fastCase10_3428,fastCase10_3429,fastCase10_3430,fastCase10_3431,fastCase10_3432,fastCase10_3433,fastCase10_3434,fastCase10_3435,fastCase10_3436,fastCase10_3437,fastCase10_3438,fastCase10_3439,fastCase10_3440,fastCase10_3441,fastCase10_3442,fastCase10_3443,fastCase10_3444,fastCase10_3445,fastCase10_3446,fastCase10_3447,fastCase10_3448,fastCase10_3449,fastCase10_3450,fastCase10_3451,fastCase10_3452,fastCase10_3453,fastCase10_3454,fastCase10_3455,fastCase10_3456,fastCase10_3457,fastCase10_3458,fastCase10_3459,fastCase10_3460,fastCase10_3461,fastCase10_3462,fastCase10_3463,fastCase10_3464,fastCase10_3465,fastCase10_3466,fastCase10_3467,fastCase10_3468,fastCase10_3469,fastCase10_3470,fastCase10_3471,fastCase10_3472,fastCase10_3473,fastCase10_3474,fastCase10_3475,fastCase10_3476,fastCase10_3477,fastCase10_3478,fastCase10_3479,fastCase10_3480,fastCase10_3481,fastCase10_3482,fastCase10_3483,fastCase10_3484,fastCase10_3485,fastCase10_3486,fastCase10_3487,fastCase10_3488,fastCase10_3489,fastCase10_3490,fastCase10_3491,fastCase10_3492,fastCase10_3493,fastCase10_3494,fastCase10_3495,fastCase10_3496,fastCase10_3497,fastCase10_3498,fastCase10_3499,fastCase10_3500,fastCase10_3501,fastCase10_3502,fastCase10_3503,fastCase10_3504,fastCase10_3505,fastCase10_3506,fastCase10_3507,fastCase10_3508,fastCase10_3509,fastCase10_3510,fastCase10_3511,fastCase10_3512,fastCase10_3513,fastCase10_3514,fastCase10_3515,fastCase10_3516,fastCase10_3517,fastCase10_3518,fastCase10_3519,fastCase10_3520,fastCase10_3521,fastCase10_3522,fastCase10_3523,fastCase10_3524,fastCase10_3525,fastCase10_3526,fastCase10_3527,fastCase10_3528,fastCase10_3529,fastCase10_3530,fastCase10_3531,fastCase10_3532,fastCase10_3533,fastCase10_3534,fastCase10_3535,fastCase10_3536,fastCase10_3537,fastCase10_3538,fastCase10_3539,fastCase10_3540,fastCase10_3541,fastCase10_3542,fastCase10_3543,fastCase10_3544,fastCase10_3545,fastCase10_3546,fastCase10_3547,fastCase10_3548,fastCase10_3549,fastCase10_3550,fastCase10_3551,fastCase10_3552,fastCase10_3553,fastCase10_3554,fastCase10_3555,fastCase10_3556,fastCase10_3557,fastCase10_3558,fastCase10_3559,fastCase10_3560,fastCase10_3561,fastCase10_3562,fastCase10_3563,fastCase10_3564,fastCase10_3565,fastCase10_3566,fastCase10_3567,fastCase10_3568,fastCase10_3569,fastCase10_3570,fastCase10_3571,fastCase10_3572,fastCase10_3573,fastCase10_3574,fastCase10_3575,fastCase10_3576,fastCase10_3577,fastCase10_3578,fastCase10_3579,fastCase10_3580,fastCase10_3581,fastCase10_3582,fastCase10_3583,fastCase10_3584,fastCase10_3585,fastCase10_3586,fastCase10_3587,fastCase10_3588,fastCase10_3589,fastCase10_3590,fastCase10_3591,fastCase10_3592,fastCase10_3593,fastCase10_3594,fastCase10_3595,fastCase10_3596,fastCase10_3597,fastCase10_3598,fastCase10_3599,fastCase10_3600,fastCase10_3601,fastCase10_3602,fastCase10_3603,fastCase10_3604,fastCase10_3605,fastCase10_3606,fastCase10_3607,fastCase10_3608,fastCase10_3609,fastCase10_3610,fastCase10_3611,fastCase10_3612,fastCase10_3613,fastCase10_3614,fastCase10_3615,fastCase10_3616,fastCase10_3617,fastCase10_3618,fastCase10_3619,fastCase10_3620,fastCase10_3621,fastCase10_3622,fastCase10_3623,fastCase10_3624,fastCase10_3625,fastCase10_3626,fastCase10_3627,fastCase10_3628,fastCase10_3629,fastCase10_3630,fastCase10_3631,fastCase10_3632,fastCase10_3633,fastCase10_3634,fastCase10_3635,fastCase10_3636,fastCase10_3637,fastCase10_3638,fastCase10_3639,fastCase10_3640,fastCase10_3641,fastCase10_3642,fastCase10_3643,fastCase10_3644,fastCase10_3645,fastCase10_3646,fastCase10_3647,fastCase10_3648,fastCase10_3649,fastCase10_3650,fastCase10_3651,fastCase10_3652,fastCase10_3653,fastCase10_3654,fastCase10_3655,fastCase10_3656,fastCase10_3657,fastCase10_3658,fastCase10_3659,fastCase10_3660,fastCase10_3661,fastCase10_3662,fastCase10_3663,fastCase10_3664,fastCase10_3665,fastCase10_3666,fastCase10_3667,fastCase10_3668,fastCase10_3669,fastCase10_3670,fastCase10_3671,fastCase10_3672,fastCase10_3673,fastCase10_3674,fastCase10_3675,fastCase10_3676,fastCase10_3677,fastCase10_3678,fastCase10_3679,fastCase10_3680,fastCase10_3681,fastCase10_3682,fastCase10_3683,fastCase10_3684,fastCase10_3685,fastCase10_3686,fastCase10_3687,fastCase10_3688,fastCase10_3689,fastCase10_3690,fastCase10_3691,fastCase10_3692,fastCase10_3693,fastCase10_3694,fastCase10_3695,fastCase10_3696,fastCase10_3697,fastCase10_3698,fastCase10_3699,fastCase10_3700,fastCase10_3701,fastCase10_3702,fastCase10_3703,fastCase10_3704,fastCase10_3705,fastCase10_3706,fastCase10_3707,fastCase10_3708,fastCase10_3709,fastCase10_3710,fastCase10_3711,fastCase10_3712,fastCase10_3713,fastCase10_3714,fastCase10_3715,fastCase10_3716,fastCase10_3717,fastCase10_3718,fastCase10_3719,fastCase10_3720,fastCase10_3721,fastCase10_3722,fastCase10_3723,fastCase10_3724,fastCase10_3725,fastCase10_3726,fastCase10_3727,fastCase10_3728,fastCase10_3729,fastCase10_3730,fastCase10_3731,fastCase10_3732,fastCase10_3733,fastCase10_3734,fastCase10_3735,fastCase10_3736,fastCase10_3737,fastCase10_3738,fastCase10_3739,fastCase10_3740,fastCase10_3741,fastCase10_3742,fastCase10_3743,fastCase10_3744,fastCase10_3745,fastCase10_3746,fastCase10_3747,fastCase10_3748,fastCase10_3749,fastCase10_3750,fastCase10_3751,fastCase10_3752,fastCase10_3753,fastCase10_3754,fastCase10_3755,fastCase10_3756,fastCase10_3757,fastCase10_3758,fastCase10_3759,fastCase10_3760,fastCase10_3761,fastCase10_3762,fastCase10_3763,fastCase10_3764,fastCase10_3765,fastCase10_3766,fastCase10_3767,fastCase10_3768,fastCase10_3769,fastCase10_3770,fastCase10_3771,fastCase10_3772,fastCase10_3773,fastCase10_3774,fastCase10_3775,fastCase10_3776,fastCase10_3777,fastCase10_3778,fastCase10_3779,fastCase10_3780,fastCase10_3781,fastCase10_3782,fastCase10_3783,fastCase10_3784,fastCase10_3785,fastCase10_3786,fastCase10_3787,fastCase10_3788,fastCase10_3789,fastCase10_3790,fastCase10_3791,fastCase10_3792,fastCase10_3793,fastCase10_3794,fastCase10_3795,fastCase10_3796,fastCase10_3797,fastCase10_3798,fastCase10_3799,fastCase10_3800,fastCase10_3801,fastCase10_3802,fastCase10_3803,fastCase10_3804,fastCase10_3805,fastCase10_3806,fastCase10_3807,fastCase10_3808,fastCase10_3809,fastCase10_3810,fastCase10_3811,fastCase10_3812,fastCase10_3813,fastCase10_3814,fastCase10_3815,fastCase10_3816,fastCase10_3817,fastCase10_3818,fastCase10_3819,fastCase10_3820,fastCase10_3821,fastCase10_3822,fastCase10_3823,fastCase10_3824,fastCase10_3825,fastCase10_3826,fastCase10_3827,fastCase10_3828,fastCase10_3829,fastCase10_3830,fastCase10_3831,fastCase10_3832,fastCase10_3833,fastCase10_3834,fastCase10_3835,fastCase10_3836,fastCase10_3837,fastCase10_3838,fastCase10_3839,fastCase10_3840,fastCase10_3841,fastCase10_3842,fastCase10_3843,fastCase10_3844,fastCase10_3845,fastCase10_3846,fastCase10_3847,fastCase10_3848,fastCase10_3849,fastCase10_3850,fastCase10_3851,fastCase10_3852,fastCase10_3853,fastCase10_3854,fastCase10_3855,fastCase10_3856,fastCase10_3857,fastCase10_3858,fastCase10_3859,fastCase10_3860,fastCase10_3861,fastCase10_3862,fastCase10_3863,fastCase10_3864,fastCase10_3865,fastCase10_3866,fastCase10_3867,fastCase10_3868,fastCase10_3869,fastCase10_3870,fastCase10_3871,fastCase10_3872,fastCase10_3873,fastCase10_3874,fastCase10_3875,fastCase10_3876,fastCase10_3877,fastCase10_3878,fastCase10_3879,fastCase10_3880,fastCase10_3881,fastCase10_3882,fastCase10_3883,fastCase10_3884,fastCase10_3885,fastCase10_3886,fastCase10_3887,fastCase10_3888,fastCase10_3889,fastCase10_3890,fastCase10_3891,fastCase10_3892,fastCase10_3893,fastCase10_3894,fastCase10_3895,fastCase10_3896,fastCase10_3897,fastCase10_3898,fastCase10_3899,fastCase10_3900,fastCase10_3901,fastCase10_3902,fastCase10_3903,fastCase10_3904,fastCase10_3905,fastCase10_3906,fastCase10_3907,fastCase10_3908,fastCase10_3909,fastCase10_3910,fastCase10_3911,fastCase10_3912,fastCase10_3913,fastCase10_3914,fastCase10_3915,fastCase10_3916,fastCase10_3917,fastCase10_3918,fastCase10_3919,fastCase10_3920,fastCase10_3921,fastCase10_3922,fastCase10_3923,fastCase10_3924,fastCase10_3925,fastCase10_3926,fastCase10_3927,fastCase10_3928,fastCase10_3929,fastCase10_3930,fastCase10_3931,fastCase10_3932,fastCase10_3933,fastCase10_3934,fastCase10_3935,fastCase10_3936,fastCase10_3937,fastCase10_3938,fastCase10_3939,fastCase10_3940,fastCase10_3941,fastCase10_3942,fastCase10_3943,fastCase10_3944,fastCase10_3945,fastCase10_3946,fastCase10_3947,fastCase10_3948,fastCase10_3949,fastCase10_3950,fastCase10_3951,fastCase10_3952,fastCase10_3953,fastCase10_3954,fastCase10_3955,fastCase10_3956,fastCase10_3957,fastCase10_3958,fastCase10_3959,fastCase10_3960,fastCase10_3961,fastCase10_3962,fastCase10_3963,fastCase10_3964,fastCase10_3965,fastCase10_3966,fastCase10_3967,fastCase10_3968,fastCase10_3969,fastCase10_3970,fastCase10_3971,fastCase10_3972,fastCase10_3973,fastCase10_3974,fastCase10_3975,fastCase10_3976,fastCase10_3977,fastCase10_3978,fastCase10_3979,fastCase10_3980,fastCase10_3981,fastCase10_3982,fastCase10_3983,fastCase10_3984,fastCase10_3985,fastCase10_3986,fastCase10_3987,fastCase10_3988,fastCase10_3989,fastCase10_3990,fastCase10_3991,fastCase10_3992,fastCase10_3993,fastCase10_3994,fastCase10_3995,fastCase10_3996,fastCase10_3997,fastCase10_3998,fastCase10_3999⟩
#print axioms aggregate_F10_003
end KernelCatalog
