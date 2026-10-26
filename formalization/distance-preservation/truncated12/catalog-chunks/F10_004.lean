import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_4000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4000 : checkCertificateFast 10 4000 fastCert10_4000=true := by decide +kernel
def fastCert10_4001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4001 : checkCertificateFast 10 4001 fastCert10_4001=true := by decide +kernel
def fastCert10_4002 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4002 : checkCertificateFast 10 4002 fastCert10_4002=true := by decide +kernel
def fastCert10_4003 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4003 : checkCertificateFast 10 4003 fastCert10_4003=true := by decide +kernel
def fastCert10_4004 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4004 : checkCertificateFast 10 4004 fastCert10_4004=true := by decide +kernel
def fastCert10_4005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4005 : checkCertificateFast 10 4005 fastCert10_4005=true := by decide +kernel
def fastCert10_4006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4006 : checkCertificateFast 10 4006 fastCert10_4006=true := by decide +kernel
def fastCert10_4007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4007 : checkCertificateFast 10 4007 fastCert10_4007=true := by decide +kernel
def fastCert10_4008 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4008 : checkCertificateFast 10 4008 fastCert10_4008=true := by decide +kernel
def fastCert10_4009 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4009 : checkCertificateFast 10 4009 fastCert10_4009=true := by decide +kernel
def fastCert10_4010 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4010 : checkCertificateFast 10 4010 fastCert10_4010=true := by decide +kernel
def fastCert10_4011 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4011 : checkCertificateFast 10 4011 fastCert10_4011=true := by decide +kernel
def fastCert10_4012 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4012 : checkCertificateFast 10 4012 fastCert10_4012=true := by decide +kernel
def fastCert10_4013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4013 : checkCertificateFast 10 4013 fastCert10_4013=true := by decide +kernel
def fastCert10_4014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4014 : checkCertificateFast 10 4014 fastCert10_4014=true := by decide +kernel
def fastCert10_4015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4015 : checkCertificateFast 10 4015 fastCert10_4015=true := by decide +kernel
def fastCert10_4016 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4016 : checkCertificateFast 10 4016 fastCert10_4016=true := by decide +kernel
def fastCert10_4017 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4017 : checkCertificateFast 10 4017 fastCert10_4017=true := by decide +kernel
def fastCert10_4018 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4018 : checkCertificateFast 10 4018 fastCert10_4018=true := by decide +kernel
def fastCert10_4019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_4019 : checkCertificateFast 10 4019 fastCert10_4019=true := by decide +kernel
def fastCert10_4020 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4020 : checkCertificateFast 10 4020 fastCert10_4020=true := by decide +kernel
def fastCert10_4021 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4021 : checkCertificateFast 10 4021 fastCert10_4021=true := by decide +kernel
def fastCert10_4022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4022 : checkCertificateFast 10 4022 fastCert10_4022=true := by decide +kernel
def fastCert10_4023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4023 : checkCertificateFast 10 4023 fastCert10_4023=true := by decide +kernel
def fastCert10_4024 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4024 : checkCertificateFast 10 4024 fastCert10_4024=true := by decide +kernel
def fastCert10_4025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4025 : checkCertificateFast 10 4025 fastCert10_4025=true := by decide +kernel
def fastCert10_4026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_4026 : checkCertificateFast 10 4026 fastCert10_4026=true := by decide +kernel
def fastCert10_4027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4027 : checkCertificateFast 10 4027 fastCert10_4027=true := by decide +kernel
def fastCert10_4028 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4028 : checkCertificateFast 10 4028 fastCert10_4028=true := by decide +kernel
def fastCert10_4029 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4029 : checkCertificateFast 10 4029 fastCert10_4029=true := by decide +kernel
def fastCert10_4030 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4030 : checkCertificateFast 10 4030 fastCert10_4030=true := by decide +kernel
def fastCert10_4031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4031 : checkCertificateFast 10 4031 fastCert10_4031=true := by decide +kernel
def fastCert10_4032 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4032 : checkCertificateFast 10 4032 fastCert10_4032=true := by decide +kernel
def fastCert10_4033 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4033 : checkCertificateFast 10 4033 fastCert10_4033=true := by decide +kernel
def fastCert10_4034 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4034 : checkCertificateFast 10 4034 fastCert10_4034=true := by decide +kernel
def fastCert10_4035 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4035 : checkCertificateFast 10 4035 fastCert10_4035=true := by decide +kernel
def fastCert10_4036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4036 : checkCertificateFast 10 4036 fastCert10_4036=true := by decide +kernel
def fastCert10_4037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4037 : checkCertificateFast 10 4037 fastCert10_4037=true := by decide +kernel
def fastCert10_4038 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4038 : checkCertificateFast 10 4038 fastCert10_4038=true := by decide +kernel
def fastCert10_4039 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4039 : checkCertificateFast 10 4039 fastCert10_4039=true := by decide +kernel
def fastCert10_4040 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4040 : checkCertificateFast 10 4040 fastCert10_4040=true := by decide +kernel
def fastCert10_4041 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4041 : checkCertificateFast 10 4041 fastCert10_4041=true := by decide +kernel
def fastCert10_4042 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4042 : checkCertificateFast 10 4042 fastCert10_4042=true := by decide +kernel
def fastCert10_4043 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4043 : checkCertificateFast 10 4043 fastCert10_4043=true := by decide +kernel
def fastCert10_4044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4044 : checkCertificateFast 10 4044 fastCert10_4044=true := by decide +kernel
def fastCert10_4045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4045 : checkCertificateFast 10 4045 fastCert10_4045=true := by decide +kernel
def fastCert10_4046 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4046 : checkCertificateFast 10 4046 fastCert10_4046=true := by decide +kernel
def fastCert10_4047 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4047 : checkCertificateFast 10 4047 fastCert10_4047=true := by decide +kernel
def fastCert10_4048 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4048 : checkCertificateFast 10 4048 fastCert10_4048=true := by decide +kernel
def fastCert10_4049 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4049 : checkCertificateFast 10 4049 fastCert10_4049=true := by decide +kernel
def fastCert10_4050 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4050 : checkCertificateFast 10 4050 fastCert10_4050=true := by decide +kernel
def fastCert10_4051 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4051 : checkCertificateFast 10 4051 fastCert10_4051=true := by decide +kernel
def fastCert10_4052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4052 : checkCertificateFast 10 4052 fastCert10_4052=true := by decide +kernel
def fastCert10_4053 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4053 : checkCertificateFast 10 4053 fastCert10_4053=true := by decide +kernel
def fastCert10_4054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4054 : checkCertificateFast 10 4054 fastCert10_4054=true := by decide +kernel
def fastCert10_4055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4055 : checkCertificateFast 10 4055 fastCert10_4055=true := by decide +kernel
def fastCert10_4056 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4056 : checkCertificateFast 10 4056 fastCert10_4056=true := by decide +kernel
def fastCert10_4057 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4057 : checkCertificateFast 10 4057 fastCert10_4057=true := by decide +kernel
def fastCert10_4058 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4058 : checkCertificateFast 10 4058 fastCert10_4058=true := by decide +kernel
def fastCert10_4059 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4059 : checkCertificateFast 10 4059 fastCert10_4059=true := by decide +kernel
def fastCert10_4060 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4060 : checkCertificateFast 10 4060 fastCert10_4060=true := by decide +kernel
def fastCert10_4061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4061 : checkCertificateFast 10 4061 fastCert10_4061=true := by decide +kernel
def fastCert10_4062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4062 : checkCertificateFast 10 4062 fastCert10_4062=true := by decide +kernel
def fastCert10_4063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4063 : checkCertificateFast 10 4063 fastCert10_4063=true := by decide +kernel
def fastCert10_4064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4064 : checkCertificateFast 10 4064 fastCert10_4064=true := by decide +kernel
def fastCert10_4065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_4065 : checkCertificateFast 10 4065 fastCert10_4065=true := by decide +kernel
def fastCert10_4066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4066 : checkCertificateFast 10 4066 fastCert10_4066=true := by decide +kernel
def fastCert10_4067 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4067 : checkCertificateFast 10 4067 fastCert10_4067=true := by decide +kernel
def fastCert10_4068 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4068 : checkCertificateFast 10 4068 fastCert10_4068=true := by decide +kernel
def fastCert10_4069 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4069 : checkCertificateFast 10 4069 fastCert10_4069=true := by decide +kernel
def fastCert10_4070 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4070 : checkCertificateFast 10 4070 fastCert10_4070=true := by decide +kernel
def fastCert10_4071 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4071 : checkCertificateFast 10 4071 fastCert10_4071=true := by decide +kernel
def fastCert10_4072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4072 : checkCertificateFast 10 4072 fastCert10_4072=true := by decide +kernel
def fastCert10_4073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4073 : checkCertificateFast 10 4073 fastCert10_4073=true := by decide +kernel
def fastCert10_4074 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4074 : checkCertificateFast 10 4074 fastCert10_4074=true := by decide +kernel
def fastCert10_4075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4075 : checkCertificateFast 10 4075 fastCert10_4075=true := by decide +kernel
def fastCert10_4076 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4076 : checkCertificateFast 10 4076 fastCert10_4076=true := by decide +kernel
def fastCert10_4077 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4077 : checkCertificateFast 10 4077 fastCert10_4077=true := by decide +kernel
def fastCert10_4078 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4078 : checkCertificateFast 10 4078 fastCert10_4078=true := by decide +kernel
def fastCert10_4079 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4079 : checkCertificateFast 10 4079 fastCert10_4079=true := by decide +kernel
def fastCert10_4080 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4080 : checkCertificateFast 10 4080 fastCert10_4080=true := by decide +kernel
def fastCert10_4081 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4081 : checkCertificateFast 10 4081 fastCert10_4081=true := by decide +kernel
def fastCert10_4082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4082 : checkCertificateFast 10 4082 fastCert10_4082=true := by decide +kernel
def fastCert10_4083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4083 : checkCertificateFast 10 4083 fastCert10_4083=true := by decide +kernel
def fastCert10_4084 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4084 : checkCertificateFast 10 4084 fastCert10_4084=true := by decide +kernel
def fastCert10_4085 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4085 : checkCertificateFast 10 4085 fastCert10_4085=true := by decide +kernel
def fastCert10_4086 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4086 : checkCertificateFast 10 4086 fastCert10_4086=true := by decide +kernel
def fastCert10_4087 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4087 : checkCertificateFast 10 4087 fastCert10_4087=true := by decide +kernel
def fastCert10_4088 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4088 : checkCertificateFast 10 4088 fastCert10_4088=true := by decide +kernel
def fastCert10_4089 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4089 : checkCertificateFast 10 4089 fastCert10_4089=true := by decide +kernel
def fastCert10_4090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4090 : checkCertificateFast 10 4090 fastCert10_4090=true := by decide +kernel
def fastCert10_4091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4091 : checkCertificateFast 10 4091 fastCert10_4091=true := by decide +kernel
def fastCert10_4092 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4092 : checkCertificateFast 10 4092 fastCert10_4092=true := by decide +kernel
def fastCert10_4093 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4093 : checkCertificateFast 10 4093 fastCert10_4093=true := by decide +kernel
def fastCert10_4094 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4094 : checkCertificateFast 10 4094 fastCert10_4094=true := by decide +kernel
def fastCert10_4095 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4095 : checkCertificateFast 10 4095 fastCert10_4095=true := by decide +kernel
def fastCert10_4096 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4096 : checkCertificateFast 10 4096 fastCert10_4096=true := by decide +kernel
def fastCert10_4097 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4097 : checkCertificateFast 10 4097 fastCert10_4097=true := by decide +kernel
def fastCert10_4098 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4098 : checkCertificateFast 10 4098 fastCert10_4098=true := by decide +kernel
def fastCert10_4099 : Certificate := ⟨7,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4099 : checkCertificateFast 10 4099 fastCert10_4099=true := by decide +kernel
def fastCert10_4100 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4100 : checkCertificateFast 10 4100 fastCert10_4100=true := by decide +kernel
def fastCert10_4101 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4101 : checkCertificateFast 10 4101 fastCert10_4101=true := by decide +kernel
def fastCert10_4102 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4102 : checkCertificateFast 10 4102 fastCert10_4102=true := by decide +kernel
def fastCert10_4103 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4103 : checkCertificateFast 10 4103 fastCert10_4103=true := by decide +kernel
def fastCert10_4104 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4104 : checkCertificateFast 10 4104 fastCert10_4104=true := by decide +kernel
def fastCert10_4105 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4105 : checkCertificateFast 10 4105 fastCert10_4105=true := by decide +kernel
def fastCert10_4106 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4106 : checkCertificateFast 10 4106 fastCert10_4106=true := by decide +kernel
def fastCert10_4107 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4107 : checkCertificateFast 10 4107 fastCert10_4107=true := by decide +kernel
def fastCert10_4108 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4108 : checkCertificateFast 10 4108 fastCert10_4108=true := by decide +kernel
def fastCert10_4109 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4109 : checkCertificateFast 10 4109 fastCert10_4109=true := by decide +kernel
def fastCert10_4110 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4110 : checkCertificateFast 10 4110 fastCert10_4110=true := by decide +kernel
def fastCert10_4111 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4111 : checkCertificateFast 10 4111 fastCert10_4111=true := by decide +kernel
def fastCert10_4112 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4112 : checkCertificateFast 10 4112 fastCert10_4112=true := by decide +kernel
def fastCert10_4113 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4113 : checkCertificateFast 10 4113 fastCert10_4113=true := by decide +kernel
def fastCert10_4114 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4114 : checkCertificateFast 10 4114 fastCert10_4114=true := by decide +kernel
def fastCert10_4115 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4115 : checkCertificateFast 10 4115 fastCert10_4115=true := by decide +kernel
def fastCert10_4116 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4116 : checkCertificateFast 10 4116 fastCert10_4116=true := by decide +kernel
def fastCert10_4117 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4117 : checkCertificateFast 10 4117 fastCert10_4117=true := by decide +kernel
def fastCert10_4118 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4118 : checkCertificateFast 10 4118 fastCert10_4118=true := by decide +kernel
def fastCert10_4119 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4119 : checkCertificateFast 10 4119 fastCert10_4119=true := by decide +kernel
def fastCert10_4120 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4120 : checkCertificateFast 10 4120 fastCert10_4120=true := by decide +kernel
def fastCert10_4121 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4121 : checkCertificateFast 10 4121 fastCert10_4121=true := by decide +kernel
def fastCert10_4122 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4122 : checkCertificateFast 10 4122 fastCert10_4122=true := by decide +kernel
def fastCert10_4123 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4123 : checkCertificateFast 10 4123 fastCert10_4123=true := by decide +kernel
def fastCert10_4124 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4124 : checkCertificateFast 10 4124 fastCert10_4124=true := by decide +kernel
def fastCert10_4125 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4125 : checkCertificateFast 10 4125 fastCert10_4125=true := by decide +kernel
def fastCert10_4126 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4126 : checkCertificateFast 10 4126 fastCert10_4126=true := by decide +kernel
def fastCert10_4127 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4127 : checkCertificateFast 10 4127 fastCert10_4127=true := by decide +kernel
def fastCert10_4128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4128 : checkCertificateFast 10 4128 fastCert10_4128=true := by decide +kernel
def fastCert10_4129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4129 : checkCertificateFast 10 4129 fastCert10_4129=true := by decide +kernel
def fastCert10_4130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4130 : checkCertificateFast 10 4130 fastCert10_4130=true := by decide +kernel
def fastCert10_4131 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4131 : checkCertificateFast 10 4131 fastCert10_4131=true := by decide +kernel
def fastCert10_4132 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4132 : checkCertificateFast 10 4132 fastCert10_4132=true := by decide +kernel
def fastCert10_4133 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4133 : checkCertificateFast 10 4133 fastCert10_4133=true := by decide +kernel
def fastCert10_4134 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4134 : checkCertificateFast 10 4134 fastCert10_4134=true := by decide +kernel
def fastCert10_4135 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4135 : checkCertificateFast 10 4135 fastCert10_4135=true := by decide +kernel
def fastCert10_4136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4136 : checkCertificateFast 10 4136 fastCert10_4136=true := by decide +kernel
def fastCert10_4137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4137 : checkCertificateFast 10 4137 fastCert10_4137=true := by decide +kernel
def fastCert10_4138 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4138 : checkCertificateFast 10 4138 fastCert10_4138=true := by decide +kernel
def fastCert10_4139 : Certificate := ⟨19,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4139 : checkCertificateFast 10 4139 fastCert10_4139=true := by decide +kernel
def fastCert10_4140 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4140 : checkCertificateFast 10 4140 fastCert10_4140=true := by decide +kernel
def fastCert10_4141 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4141 : checkCertificateFast 10 4141 fastCert10_4141=true := by decide +kernel
def fastCert10_4142 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4142 : checkCertificateFast 10 4142 fastCert10_4142=true := by decide +kernel
def fastCert10_4143 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4143 : checkCertificateFast 10 4143 fastCert10_4143=true := by decide +kernel
def fastCert10_4144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4144 : checkCertificateFast 10 4144 fastCert10_4144=true := by decide +kernel
def fastCert10_4145 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4145 : checkCertificateFast 10 4145 fastCert10_4145=true := by decide +kernel
def fastCert10_4146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4146 : checkCertificateFast 10 4146 fastCert10_4146=true := by decide +kernel
def fastCert10_4147 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4147 : checkCertificateFast 10 4147 fastCert10_4147=true := by decide +kernel
def fastCert10_4148 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4148 : checkCertificateFast 10 4148 fastCert10_4148=true := by decide +kernel
def fastCert10_4149 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4149 : checkCertificateFast 10 4149 fastCert10_4149=true := by decide +kernel
def fastCert10_4150 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4150 : checkCertificateFast 10 4150 fastCert10_4150=true := by decide +kernel
def fastCert10_4151 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4151 : checkCertificateFast 10 4151 fastCert10_4151=true := by decide +kernel
def fastCert10_4152 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4152 : checkCertificateFast 10 4152 fastCert10_4152=true := by decide +kernel
def fastCert10_4153 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4153 : checkCertificateFast 10 4153 fastCert10_4153=true := by decide +kernel
def fastCert10_4154 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4154 : checkCertificateFast 10 4154 fastCert10_4154=true := by decide +kernel
def fastCert10_4155 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4155 : checkCertificateFast 10 4155 fastCert10_4155=true := by decide +kernel
def fastCert10_4156 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4156 : checkCertificateFast 10 4156 fastCert10_4156=true := by decide +kernel
def fastCert10_4157 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4157 : checkCertificateFast 10 4157 fastCert10_4157=true := by decide +kernel
def fastCert10_4158 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4158 : checkCertificateFast 10 4158 fastCert10_4158=true := by decide +kernel
def fastCert10_4159 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4159 : checkCertificateFast 10 4159 fastCert10_4159=true := by decide +kernel
def fastCert10_4160 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4160 : checkCertificateFast 10 4160 fastCert10_4160=true := by decide +kernel
def fastCert10_4161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4161 : checkCertificateFast 10 4161 fastCert10_4161=true := by decide +kernel
def fastCert10_4162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4162 : checkCertificateFast 10 4162 fastCert10_4162=true := by decide +kernel
def fastCert10_4163 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4163 : checkCertificateFast 10 4163 fastCert10_4163=true := by decide +kernel
def fastCert10_4164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4164 : checkCertificateFast 10 4164 fastCert10_4164=true := by decide +kernel
def fastCert10_4165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4165 : checkCertificateFast 10 4165 fastCert10_4165=true := by decide +kernel
def fastCert10_4166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4166 : checkCertificateFast 10 4166 fastCert10_4166=true := by decide +kernel
def fastCert10_4167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4167 : checkCertificateFast 10 4167 fastCert10_4167=true := by decide +kernel
def fastCert10_4168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4168 : checkCertificateFast 10 4168 fastCert10_4168=true := by decide +kernel
def fastCert10_4169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4169 : checkCertificateFast 10 4169 fastCert10_4169=true := by decide +kernel
def fastCert10_4170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4170 : checkCertificateFast 10 4170 fastCert10_4170=true := by decide +kernel
def fastCert10_4171 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4171 : checkCertificateFast 10 4171 fastCert10_4171=true := by decide +kernel
def fastCert10_4172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4172 : checkCertificateFast 10 4172 fastCert10_4172=true := by decide +kernel
def fastCert10_4173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4173 : checkCertificateFast 10 4173 fastCert10_4173=true := by decide +kernel
def fastCert10_4174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4174 : checkCertificateFast 10 4174 fastCert10_4174=true := by decide +kernel
def fastCert10_4175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4175 : checkCertificateFast 10 4175 fastCert10_4175=true := by decide +kernel
def fastCert10_4176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4176 : checkCertificateFast 10 4176 fastCert10_4176=true := by decide +kernel
def fastCert10_4177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4177 : checkCertificateFast 10 4177 fastCert10_4177=true := by decide +kernel
def fastCert10_4178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4178 : checkCertificateFast 10 4178 fastCert10_4178=true := by decide +kernel
def fastCert10_4179 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4179 : checkCertificateFast 10 4179 fastCert10_4179=true := by decide +kernel
def fastCert10_4180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4180 : checkCertificateFast 10 4180 fastCert10_4180=true := by decide +kernel
def fastCert10_4181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4181 : checkCertificateFast 10 4181 fastCert10_4181=true := by decide +kernel
def fastCert10_4182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4182 : checkCertificateFast 10 4182 fastCert10_4182=true := by decide +kernel
def fastCert10_4183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4183 : checkCertificateFast 10 4183 fastCert10_4183=true := by decide +kernel
def fastCert10_4184 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4184 : checkCertificateFast 10 4184 fastCert10_4184=true := by decide +kernel
def fastCert10_4185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4185 : checkCertificateFast 10 4185 fastCert10_4185=true := by decide +kernel
def fastCert10_4186 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4186 : checkCertificateFast 10 4186 fastCert10_4186=true := by decide +kernel
def fastCert10_4187 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4187 : checkCertificateFast 10 4187 fastCert10_4187=true := by decide +kernel
def fastCert10_4188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4188 : checkCertificateFast 10 4188 fastCert10_4188=true := by decide +kernel
def fastCert10_4189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4189 : checkCertificateFast 10 4189 fastCert10_4189=true := by decide +kernel
def fastCert10_4190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4190 : checkCertificateFast 10 4190 fastCert10_4190=true := by decide +kernel
def fastCert10_4191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4191 : checkCertificateFast 10 4191 fastCert10_4191=true := by decide +kernel
def fastCert10_4192 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4192 : checkCertificateFast 10 4192 fastCert10_4192=true := by decide +kernel
def fastCert10_4193 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4193 : checkCertificateFast 10 4193 fastCert10_4193=true := by decide +kernel
def fastCert10_4194 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4194 : checkCertificateFast 10 4194 fastCert10_4194=true := by decide +kernel
def fastCert10_4195 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4195 : checkCertificateFast 10 4195 fastCert10_4195=true := by decide +kernel
def fastCert10_4196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4196 : checkCertificateFast 10 4196 fastCert10_4196=true := by decide +kernel
def fastCert10_4197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4197 : checkCertificateFast 10 4197 fastCert10_4197=true := by decide +kernel
def fastCert10_4198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4198 : checkCertificateFast 10 4198 fastCert10_4198=true := by decide +kernel
def fastCert10_4199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4199 : checkCertificateFast 10 4199 fastCert10_4199=true := by decide +kernel
def fastCert10_4200 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4200 : checkCertificateFast 10 4200 fastCert10_4200=true := by decide +kernel
def fastCert10_4201 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4201 : checkCertificateFast 10 4201 fastCert10_4201=true := by decide +kernel
def fastCert10_4202 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4202 : checkCertificateFast 10 4202 fastCert10_4202=true := by decide +kernel
def fastCert10_4203 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4203 : checkCertificateFast 10 4203 fastCert10_4203=true := by decide +kernel
def fastCert10_4204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4204 : checkCertificateFast 10 4204 fastCert10_4204=true := by decide +kernel
def fastCert10_4205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4205 : checkCertificateFast 10 4205 fastCert10_4205=true := by decide +kernel
def fastCert10_4206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4206 : checkCertificateFast 10 4206 fastCert10_4206=true := by decide +kernel
def fastCert10_4207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4207 : checkCertificateFast 10 4207 fastCert10_4207=true := by decide +kernel
def fastCert10_4208 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4208 : checkCertificateFast 10 4208 fastCert10_4208=true := by decide +kernel
def fastCert10_4209 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4209 : checkCertificateFast 10 4209 fastCert10_4209=true := by decide +kernel
def fastCert10_4210 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4210 : checkCertificateFast 10 4210 fastCert10_4210=true := by decide +kernel
def fastCert10_4211 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4211 : checkCertificateFast 10 4211 fastCert10_4211=true := by decide +kernel
def fastCert10_4212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4212 : checkCertificateFast 10 4212 fastCert10_4212=true := by decide +kernel
def fastCert10_4213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4213 : checkCertificateFast 10 4213 fastCert10_4213=true := by decide +kernel
def fastCert10_4214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4214 : checkCertificateFast 10 4214 fastCert10_4214=true := by decide +kernel
def fastCert10_4215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4215 : checkCertificateFast 10 4215 fastCert10_4215=true := by decide +kernel
def fastCert10_4216 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4216 : checkCertificateFast 10 4216 fastCert10_4216=true := by decide +kernel
def fastCert10_4217 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4217 : checkCertificateFast 10 4217 fastCert10_4217=true := by decide +kernel
def fastCert10_4218 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4218 : checkCertificateFast 10 4218 fastCert10_4218=true := by decide +kernel
def fastCert10_4219 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4219 : checkCertificateFast 10 4219 fastCert10_4219=true := by decide +kernel
def fastCert10_4220 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4220 : checkCertificateFast 10 4220 fastCert10_4220=true := by decide +kernel
def fastCert10_4221 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4221 : checkCertificateFast 10 4221 fastCert10_4221=true := by decide +kernel
def fastCert10_4222 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4222 : checkCertificateFast 10 4222 fastCert10_4222=true := by decide +kernel
def fastCert10_4223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4223 : checkCertificateFast 10 4223 fastCert10_4223=true := by decide +kernel
def fastCert10_4224 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4224 : checkCertificateFast 10 4224 fastCert10_4224=true := by decide +kernel
def fastCert10_4225 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4225 : checkCertificateFast 10 4225 fastCert10_4225=true := by decide +kernel
def fastCert10_4226 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4226 : checkCertificateFast 10 4226 fastCert10_4226=true := by decide +kernel
def fastCert10_4227 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4227 : checkCertificateFast 10 4227 fastCert10_4227=true := by decide +kernel
def fastCert10_4228 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4228 : checkCertificateFast 10 4228 fastCert10_4228=true := by decide +kernel
def fastCert10_4229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4229 : checkCertificateFast 10 4229 fastCert10_4229=true := by decide +kernel
def fastCert10_4230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4230 : checkCertificateFast 10 4230 fastCert10_4230=true := by decide +kernel
def fastCert10_4231 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4231 : checkCertificateFast 10 4231 fastCert10_4231=true := by decide +kernel
def fastCert10_4232 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4232 : checkCertificateFast 10 4232 fastCert10_4232=true := by decide +kernel
def fastCert10_4233 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4233 : checkCertificateFast 10 4233 fastCert10_4233=true := by decide +kernel
def fastCert10_4234 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4234 : checkCertificateFast 10 4234 fastCert10_4234=true := by decide +kernel
def fastCert10_4235 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4235 : checkCertificateFast 10 4235 fastCert10_4235=true := by decide +kernel
def fastCert10_4236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4236 : checkCertificateFast 10 4236 fastCert10_4236=true := by decide +kernel
def fastCert10_4237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4237 : checkCertificateFast 10 4237 fastCert10_4237=true := by decide +kernel
def fastCert10_4238 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4238 : checkCertificateFast 10 4238 fastCert10_4238=true := by decide +kernel
def fastCert10_4239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4239 : checkCertificateFast 10 4239 fastCert10_4239=true := by decide +kernel
def fastCert10_4240 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4240 : checkCertificateFast 10 4240 fastCert10_4240=true := by decide +kernel
def fastCert10_4241 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4241 : checkCertificateFast 10 4241 fastCert10_4241=true := by decide +kernel
def fastCert10_4242 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_4242 : checkCertificateFast 10 4242 fastCert10_4242=true := by decide +kernel
def fastCert10_4243 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4243 : checkCertificateFast 10 4243 fastCert10_4243=true := by decide +kernel
def fastCert10_4244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4244 : checkCertificateFast 10 4244 fastCert10_4244=true := by decide +kernel
def fastCert10_4245 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4245 : checkCertificateFast 10 4245 fastCert10_4245=true := by decide +kernel
def fastCert10_4246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4246 : checkCertificateFast 10 4246 fastCert10_4246=true := by decide +kernel
def fastCert10_4247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4247 : checkCertificateFast 10 4247 fastCert10_4247=true := by decide +kernel
def fastCert10_4248 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4248 : checkCertificateFast 10 4248 fastCert10_4248=true := by decide +kernel
def fastCert10_4249 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4249 : checkCertificateFast 10 4249 fastCert10_4249=true := by decide +kernel
def fastCert10_4250 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4250 : checkCertificateFast 10 4250 fastCert10_4250=true := by decide +kernel
def fastCert10_4251 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4251 : checkCertificateFast 10 4251 fastCert10_4251=true := by decide +kernel
def fastCert10_4252 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4252 : checkCertificateFast 10 4252 fastCert10_4252=true := by decide +kernel
def fastCert10_4253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4253 : checkCertificateFast 10 4253 fastCert10_4253=true := by decide +kernel
def fastCert10_4254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4254 : checkCertificateFast 10 4254 fastCert10_4254=true := by decide +kernel
def fastCert10_4255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4255 : checkCertificateFast 10 4255 fastCert10_4255=true := by decide +kernel
def fastCert10_4256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4256 : checkCertificateFast 10 4256 fastCert10_4256=true := by decide +kernel
def fastCert10_4257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4257 : checkCertificateFast 10 4257 fastCert10_4257=true := by decide +kernel
def fastCert10_4258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4258 : checkCertificateFast 10 4258 fastCert10_4258=true := by decide +kernel
def fastCert10_4259 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4259 : checkCertificateFast 10 4259 fastCert10_4259=true := by decide +kernel
def fastCert10_4260 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4260 : checkCertificateFast 10 4260 fastCert10_4260=true := by decide +kernel
def fastCert10_4261 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4261 : checkCertificateFast 10 4261 fastCert10_4261=true := by decide +kernel
def fastCert10_4262 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4262 : checkCertificateFast 10 4262 fastCert10_4262=true := by decide +kernel
def fastCert10_4263 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4263 : checkCertificateFast 10 4263 fastCert10_4263=true := by decide +kernel
def fastCert10_4264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4264 : checkCertificateFast 10 4264 fastCert10_4264=true := by decide +kernel
def fastCert10_4265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4265 : checkCertificateFast 10 4265 fastCert10_4265=true := by decide +kernel
def fastCert10_4266 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4266 : checkCertificateFast 10 4266 fastCert10_4266=true := by decide +kernel
def fastCert10_4267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4267 : checkCertificateFast 10 4267 fastCert10_4267=true := by decide +kernel
def fastCert10_4268 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4268 : checkCertificateFast 10 4268 fastCert10_4268=true := by decide +kernel
def fastCert10_4269 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4269 : checkCertificateFast 10 4269 fastCert10_4269=true := by decide +kernel
def fastCert10_4270 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4270 : checkCertificateFast 10 4270 fastCert10_4270=true := by decide +kernel
def fastCert10_4271 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4271 : checkCertificateFast 10 4271 fastCert10_4271=true := by decide +kernel
def fastCert10_4272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4272 : checkCertificateFast 10 4272 fastCert10_4272=true := by decide +kernel
def fastCert10_4273 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4273 : checkCertificateFast 10 4273 fastCert10_4273=true := by decide +kernel
def fastCert10_4274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4274 : checkCertificateFast 10 4274 fastCert10_4274=true := by decide +kernel
def fastCert10_4275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4275 : checkCertificateFast 10 4275 fastCert10_4275=true := by decide +kernel
def fastCert10_4276 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4276 : checkCertificateFast 10 4276 fastCert10_4276=true := by decide +kernel
def fastCert10_4277 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4277 : checkCertificateFast 10 4277 fastCert10_4277=true := by decide +kernel
def fastCert10_4278 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4278 : checkCertificateFast 10 4278 fastCert10_4278=true := by decide +kernel
def fastCert10_4279 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4279 : checkCertificateFast 10 4279 fastCert10_4279=true := by decide +kernel
def fastCert10_4280 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4280 : checkCertificateFast 10 4280 fastCert10_4280=true := by decide +kernel
def fastCert10_4281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4281 : checkCertificateFast 10 4281 fastCert10_4281=true := by decide +kernel
def fastCert10_4282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4282 : checkCertificateFast 10 4282 fastCert10_4282=true := by decide +kernel
def fastCert10_4283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4283 : checkCertificateFast 10 4283 fastCert10_4283=true := by decide +kernel
def fastCert10_4284 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4284 : checkCertificateFast 10 4284 fastCert10_4284=true := by decide +kernel
def fastCert10_4285 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4285 : checkCertificateFast 10 4285 fastCert10_4285=true := by decide +kernel
def fastCert10_4286 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4286 : checkCertificateFast 10 4286 fastCert10_4286=true := by decide +kernel
def fastCert10_4287 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4287 : checkCertificateFast 10 4287 fastCert10_4287=true := by decide +kernel
def fastCert10_4288 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4288 : checkCertificateFast 10 4288 fastCert10_4288=true := by decide +kernel
def fastCert10_4289 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4289 : checkCertificateFast 10 4289 fastCert10_4289=true := by decide +kernel
def fastCert10_4290 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4290 : checkCertificateFast 10 4290 fastCert10_4290=true := by decide +kernel
def fastCert10_4291 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4291 : checkCertificateFast 10 4291 fastCert10_4291=true := by decide +kernel
def fastCert10_4292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4292 : checkCertificateFast 10 4292 fastCert10_4292=true := by decide +kernel
def fastCert10_4293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4293 : checkCertificateFast 10 4293 fastCert10_4293=true := by decide +kernel
def fastCert10_4294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4294 : checkCertificateFast 10 4294 fastCert10_4294=true := by decide +kernel
def fastCert10_4295 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4295 : checkCertificateFast 10 4295 fastCert10_4295=true := by decide +kernel
def fastCert10_4296 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4296 : checkCertificateFast 10 4296 fastCert10_4296=true := by decide +kernel
def fastCert10_4297 : Certificate := ⟨8,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4297 : checkCertificateFast 10 4297 fastCert10_4297=true := by decide +kernel
def fastCert10_4298 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4298 : checkCertificateFast 10 4298 fastCert10_4298=true := by decide +kernel
def fastCert10_4299 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4299 : checkCertificateFast 10 4299 fastCert10_4299=true := by decide +kernel
def fastCert10_4300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4300 : checkCertificateFast 10 4300 fastCert10_4300=true := by decide +kernel
def fastCert10_4301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4301 : checkCertificateFast 10 4301 fastCert10_4301=true := by decide +kernel
def fastCert10_4302 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4302 : checkCertificateFast 10 4302 fastCert10_4302=true := by decide +kernel
def fastCert10_4303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4303 : checkCertificateFast 10 4303 fastCert10_4303=true := by decide +kernel
def fastCert10_4304 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4304 : checkCertificateFast 10 4304 fastCert10_4304=true := by decide +kernel
def fastCert10_4305 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4305 : checkCertificateFast 10 4305 fastCert10_4305=true := by decide +kernel
def fastCert10_4306 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4306 : checkCertificateFast 10 4306 fastCert10_4306=true := by decide +kernel
def fastCert10_4307 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4307 : checkCertificateFast 10 4307 fastCert10_4307=true := by decide +kernel
def fastCert10_4308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4308 : checkCertificateFast 10 4308 fastCert10_4308=true := by decide +kernel
def fastCert10_4309 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4309 : checkCertificateFast 10 4309 fastCert10_4309=true := by decide +kernel
def fastCert10_4310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4310 : checkCertificateFast 10 4310 fastCert10_4310=true := by decide +kernel
def fastCert10_4311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4311 : checkCertificateFast 10 4311 fastCert10_4311=true := by decide +kernel
def fastCert10_4312 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4312 : checkCertificateFast 10 4312 fastCert10_4312=true := by decide +kernel
def fastCert10_4313 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4313 : checkCertificateFast 10 4313 fastCert10_4313=true := by decide +kernel
def fastCert10_4314 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4314 : checkCertificateFast 10 4314 fastCert10_4314=true := by decide +kernel
def fastCert10_4315 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4315 : checkCertificateFast 10 4315 fastCert10_4315=true := by decide +kernel
def fastCert10_4316 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4316 : checkCertificateFast 10 4316 fastCert10_4316=true := by decide +kernel
def fastCert10_4317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4317 : checkCertificateFast 10 4317 fastCert10_4317=true := by decide +kernel
def fastCert10_4318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4318 : checkCertificateFast 10 4318 fastCert10_4318=true := by decide +kernel
def fastCert10_4319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4319 : checkCertificateFast 10 4319 fastCert10_4319=true := by decide +kernel
def fastCert10_4320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4320 : checkCertificateFast 10 4320 fastCert10_4320=true := by decide +kernel
def fastCert10_4321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4321 : checkCertificateFast 10 4321 fastCert10_4321=true := by decide +kernel
def fastCert10_4322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4322 : checkCertificateFast 10 4322 fastCert10_4322=true := by decide +kernel
def fastCert10_4323 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4323 : checkCertificateFast 10 4323 fastCert10_4323=true := by decide +kernel
def fastCert10_4324 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_4324 : checkCertificateFast 10 4324 fastCert10_4324=true := by decide +kernel
def fastCert10_4325 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4325 : checkCertificateFast 10 4325 fastCert10_4325=true := by decide +kernel
def fastCert10_4326 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4326 : checkCertificateFast 10 4326 fastCert10_4326=true := by decide +kernel
def fastCert10_4327 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4327 : checkCertificateFast 10 4327 fastCert10_4327=true := by decide +kernel
def fastCert10_4328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4328 : checkCertificateFast 10 4328 fastCert10_4328=true := by decide +kernel
def fastCert10_4329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4329 : checkCertificateFast 10 4329 fastCert10_4329=true := by decide +kernel
def fastCert10_4330 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4330 : checkCertificateFast 10 4330 fastCert10_4330=true := by decide +kernel
def fastCert10_4331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4331 : checkCertificateFast 10 4331 fastCert10_4331=true := by decide +kernel
def fastCert10_4332 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4332 : checkCertificateFast 10 4332 fastCert10_4332=true := by decide +kernel
def fastCert10_4333 : Certificate := ⟨8,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4333 : checkCertificateFast 10 4333 fastCert10_4333=true := by decide +kernel
def fastCert10_4334 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4334 : checkCertificateFast 10 4334 fastCert10_4334=true := by decide +kernel
def fastCert10_4335 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4335 : checkCertificateFast 10 4335 fastCert10_4335=true := by decide +kernel
def fastCert10_4336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4336 : checkCertificateFast 10 4336 fastCert10_4336=true := by decide +kernel
def fastCert10_4337 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4337 : checkCertificateFast 10 4337 fastCert10_4337=true := by decide +kernel
def fastCert10_4338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4338 : checkCertificateFast 10 4338 fastCert10_4338=true := by decide +kernel
def fastCert10_4339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4339 : checkCertificateFast 10 4339 fastCert10_4339=true := by decide +kernel
def fastCert10_4340 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4340 : checkCertificateFast 10 4340 fastCert10_4340=true := by decide +kernel
def fastCert10_4341 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4341 : checkCertificateFast 10 4341 fastCert10_4341=true := by decide +kernel
def fastCert10_4342 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4342 : checkCertificateFast 10 4342 fastCert10_4342=true := by decide +kernel
def fastCert10_4343 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4343 : checkCertificateFast 10 4343 fastCert10_4343=true := by decide +kernel
def fastCert10_4344 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4344 : checkCertificateFast 10 4344 fastCert10_4344=true := by decide +kernel
def fastCert10_4345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4345 : checkCertificateFast 10 4345 fastCert10_4345=true := by decide +kernel
def fastCert10_4346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4346 : checkCertificateFast 10 4346 fastCert10_4346=true := by decide +kernel
def fastCert10_4347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4347 : checkCertificateFast 10 4347 fastCert10_4347=true := by decide +kernel
def fastCert10_4348 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4348 : checkCertificateFast 10 4348 fastCert10_4348=true := by decide +kernel
def fastCert10_4349 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4349 : checkCertificateFast 10 4349 fastCert10_4349=true := by decide +kernel
def fastCert10_4350 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4350 : checkCertificateFast 10 4350 fastCert10_4350=true := by decide +kernel
def fastCert10_4351 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4351 : checkCertificateFast 10 4351 fastCert10_4351=true := by decide +kernel
def fastCert10_4352 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4352 : checkCertificateFast 10 4352 fastCert10_4352=true := by decide +kernel
def fastCert10_4353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4353 : checkCertificateFast 10 4353 fastCert10_4353=true := by decide +kernel
def fastCert10_4354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4354 : checkCertificateFast 10 4354 fastCert10_4354=true := by decide +kernel
def fastCert10_4355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4355 : checkCertificateFast 10 4355 fastCert10_4355=true := by decide +kernel
def fastCert10_4356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4356 : checkCertificateFast 10 4356 fastCert10_4356=true := by decide +kernel
def fastCert10_4357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4357 : checkCertificateFast 10 4357 fastCert10_4357=true := by decide +kernel
def fastCert10_4358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4358 : checkCertificateFast 10 4358 fastCert10_4358=true := by decide +kernel
def fastCert10_4359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4359 : checkCertificateFast 10 4359 fastCert10_4359=true := by decide +kernel
def fastCert10_4360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4360 : checkCertificateFast 10 4360 fastCert10_4360=true := by decide +kernel
def fastCert10_4361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4361 : checkCertificateFast 10 4361 fastCert10_4361=true := by decide +kernel
def fastCert10_4362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4362 : checkCertificateFast 10 4362 fastCert10_4362=true := by decide +kernel
def fastCert10_4363 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4363 : checkCertificateFast 10 4363 fastCert10_4363=true := by decide +kernel
def fastCert10_4364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4364 : checkCertificateFast 10 4364 fastCert10_4364=true := by decide +kernel
def fastCert10_4365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4365 : checkCertificateFast 10 4365 fastCert10_4365=true := by decide +kernel
def fastCert10_4366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4366 : checkCertificateFast 10 4366 fastCert10_4366=true := by decide +kernel
def fastCert10_4367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4367 : checkCertificateFast 10 4367 fastCert10_4367=true := by decide +kernel
def fastCert10_4368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4368 : checkCertificateFast 10 4368 fastCert10_4368=true := by decide +kernel
def fastCert10_4369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4369 : checkCertificateFast 10 4369 fastCert10_4369=true := by decide +kernel
def fastCert10_4370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4370 : checkCertificateFast 10 4370 fastCert10_4370=true := by decide +kernel
def fastCert10_4371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4371 : checkCertificateFast 10 4371 fastCert10_4371=true := by decide +kernel
def fastCert10_4372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4372 : checkCertificateFast 10 4372 fastCert10_4372=true := by decide +kernel
def fastCert10_4373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4373 : checkCertificateFast 10 4373 fastCert10_4373=true := by decide +kernel
def fastCert10_4374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4374 : checkCertificateFast 10 4374 fastCert10_4374=true := by decide +kernel
def fastCert10_4375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4375 : checkCertificateFast 10 4375 fastCert10_4375=true := by decide +kernel
def fastCert10_4376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4376 : checkCertificateFast 10 4376 fastCert10_4376=true := by decide +kernel
def fastCert10_4377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4377 : checkCertificateFast 10 4377 fastCert10_4377=true := by decide +kernel
def fastCert10_4378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4378 : checkCertificateFast 10 4378 fastCert10_4378=true := by decide +kernel
def fastCert10_4379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4379 : checkCertificateFast 10 4379 fastCert10_4379=true := by decide +kernel
def fastCert10_4380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4380 : checkCertificateFast 10 4380 fastCert10_4380=true := by decide +kernel
def fastCert10_4381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4381 : checkCertificateFast 10 4381 fastCert10_4381=true := by decide +kernel
def fastCert10_4382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4382 : checkCertificateFast 10 4382 fastCert10_4382=true := by decide +kernel
def fastCert10_4383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4383 : checkCertificateFast 10 4383 fastCert10_4383=true := by decide +kernel
def fastCert10_4384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4384 : checkCertificateFast 10 4384 fastCert10_4384=true := by decide +kernel
def fastCert10_4385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (3) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_4385 : checkCertificateFast 10 4385 fastCert10_4385=true := by decide +kernel
def fastCert10_4386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4386 : checkCertificateFast 10 4386 fastCert10_4386=true := by decide +kernel
def fastCert10_4387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4387 : checkCertificateFast 10 4387 fastCert10_4387=true := by decide +kernel
def fastCert10_4388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4388 : checkCertificateFast 10 4388 fastCert10_4388=true := by decide +kernel
def fastCert10_4389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4389 : checkCertificateFast 10 4389 fastCert10_4389=true := by decide +kernel
def fastCert10_4390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4390 : checkCertificateFast 10 4390 fastCert10_4390=true := by decide +kernel
def fastCert10_4391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4391 : checkCertificateFast 10 4391 fastCert10_4391=true := by decide +kernel
def fastCert10_4392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4392 : checkCertificateFast 10 4392 fastCert10_4392=true := by decide +kernel
def fastCert10_4393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4393 : checkCertificateFast 10 4393 fastCert10_4393=true := by decide +kernel
def fastCert10_4394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4394 : checkCertificateFast 10 4394 fastCert10_4394=true := by decide +kernel
def fastCert10_4395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4395 : checkCertificateFast 10 4395 fastCert10_4395=true := by decide +kernel
def fastCert10_4396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4396 : checkCertificateFast 10 4396 fastCert10_4396=true := by decide +kernel
def fastCert10_4397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4397 : checkCertificateFast 10 4397 fastCert10_4397=true := by decide +kernel
def fastCert10_4398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4398 : checkCertificateFast 10 4398 fastCert10_4398=true := by decide +kernel
def fastCert10_4399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4399 : checkCertificateFast 10 4399 fastCert10_4399=true := by decide +kernel
def fastCert10_4400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4400 : checkCertificateFast 10 4400 fastCert10_4400=true := by decide +kernel
def fastCert10_4401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4401 : checkCertificateFast 10 4401 fastCert10_4401=true := by decide +kernel
def fastCert10_4402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4402 : checkCertificateFast 10 4402 fastCert10_4402=true := by decide +kernel
def fastCert10_4403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4403 : checkCertificateFast 10 4403 fastCert10_4403=true := by decide +kernel
def fastCert10_4404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4404 : checkCertificateFast 10 4404 fastCert10_4404=true := by decide +kernel
def fastCert10_4405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4405 : checkCertificateFast 10 4405 fastCert10_4405=true := by decide +kernel
def fastCert10_4406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4406 : checkCertificateFast 10 4406 fastCert10_4406=true := by decide +kernel
def fastCert10_4407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4407 : checkCertificateFast 10 4407 fastCert10_4407=true := by decide +kernel
def fastCert10_4408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4408 : checkCertificateFast 10 4408 fastCert10_4408=true := by decide +kernel
def fastCert10_4409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4409 : checkCertificateFast 10 4409 fastCert10_4409=true := by decide +kernel
def fastCert10_4410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4410 : checkCertificateFast 10 4410 fastCert10_4410=true := by decide +kernel
def fastCert10_4411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4411 : checkCertificateFast 10 4411 fastCert10_4411=true := by decide +kernel
def fastCert10_4412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4412 : checkCertificateFast 10 4412 fastCert10_4412=true := by decide +kernel
def fastCert10_4413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4413 : checkCertificateFast 10 4413 fastCert10_4413=true := by decide +kernel
def fastCert10_4414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4414 : checkCertificateFast 10 4414 fastCert10_4414=true := by decide +kernel
def fastCert10_4415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4415 : checkCertificateFast 10 4415 fastCert10_4415=true := by decide +kernel
def fastCert10_4416 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4416 : checkCertificateFast 10 4416 fastCert10_4416=true := by decide +kernel
def fastCert10_4417 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4417 : checkCertificateFast 10 4417 fastCert10_4417=true := by decide +kernel
def fastCert10_4418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4418 : checkCertificateFast 10 4418 fastCert10_4418=true := by decide +kernel
def fastCert10_4419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4419 : checkCertificateFast 10 4419 fastCert10_4419=true := by decide +kernel
def fastCert10_4420 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4420 : checkCertificateFast 10 4420 fastCert10_4420=true := by decide +kernel
def fastCert10_4421 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4421 : checkCertificateFast 10 4421 fastCert10_4421=true := by decide +kernel
def fastCert10_4422 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4422 : checkCertificateFast 10 4422 fastCert10_4422=true := by decide +kernel
def fastCert10_4423 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4423 : checkCertificateFast 10 4423 fastCert10_4423=true := by decide +kernel
def fastCert10_4424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4424 : checkCertificateFast 10 4424 fastCert10_4424=true := by decide +kernel
def fastCert10_4425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4425 : checkCertificateFast 10 4425 fastCert10_4425=true := by decide +kernel
def fastCert10_4426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4426 : checkCertificateFast 10 4426 fastCert10_4426=true := by decide +kernel
def fastCert10_4427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4427 : checkCertificateFast 10 4427 fastCert10_4427=true := by decide +kernel
def fastCert10_4428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4428 : checkCertificateFast 10 4428 fastCert10_4428=true := by decide +kernel
def fastCert10_4429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4429 : checkCertificateFast 10 4429 fastCert10_4429=true := by decide +kernel
def fastCert10_4430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4430 : checkCertificateFast 10 4430 fastCert10_4430=true := by decide +kernel
def fastCert10_4431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4431 : checkCertificateFast 10 4431 fastCert10_4431=true := by decide +kernel
def fastCert10_4432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4432 : checkCertificateFast 10 4432 fastCert10_4432=true := by decide +kernel
def fastCert10_4433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4433 : checkCertificateFast 10 4433 fastCert10_4433=true := by decide +kernel
def fastCert10_4434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4434 : checkCertificateFast 10 4434 fastCert10_4434=true := by decide +kernel
def fastCert10_4435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4435 : checkCertificateFast 10 4435 fastCert10_4435=true := by decide +kernel
def fastCert10_4436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4436 : checkCertificateFast 10 4436 fastCert10_4436=true := by decide +kernel
def fastCert10_4437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4437 : checkCertificateFast 10 4437 fastCert10_4437=true := by decide +kernel
def fastCert10_4438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4438 : checkCertificateFast 10 4438 fastCert10_4438=true := by decide +kernel
def fastCert10_4439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4439 : checkCertificateFast 10 4439 fastCert10_4439=true := by decide +kernel
def fastCert10_4440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4440 : checkCertificateFast 10 4440 fastCert10_4440=true := by decide +kernel
def fastCert10_4441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4441 : checkCertificateFast 10 4441 fastCert10_4441=true := by decide +kernel
def fastCert10_4442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4442 : checkCertificateFast 10 4442 fastCert10_4442=true := by decide +kernel
def fastCert10_4443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4443 : checkCertificateFast 10 4443 fastCert10_4443=true := by decide +kernel
def fastCert10_4444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4444 : checkCertificateFast 10 4444 fastCert10_4444=true := by decide +kernel
def fastCert10_4445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4445 : checkCertificateFast 10 4445 fastCert10_4445=true := by decide +kernel
def fastCert10_4446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4446 : checkCertificateFast 10 4446 fastCert10_4446=true := by decide +kernel
def fastCert10_4447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4447 : checkCertificateFast 10 4447 fastCert10_4447=true := by decide +kernel
def fastCert10_4448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4448 : checkCertificateFast 10 4448 fastCert10_4448=true := by decide +kernel
def fastCert10_4449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4449 : checkCertificateFast 10 4449 fastCert10_4449=true := by decide +kernel
def fastCert10_4450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4450 : checkCertificateFast 10 4450 fastCert10_4450=true := by decide +kernel
def fastCert10_4451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4451 : checkCertificateFast 10 4451 fastCert10_4451=true := by decide +kernel
def fastCert10_4452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4452 : checkCertificateFast 10 4452 fastCert10_4452=true := by decide +kernel
def fastCert10_4453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4453 : checkCertificateFast 10 4453 fastCert10_4453=true := by decide +kernel
def fastCert10_4454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4454 : checkCertificateFast 10 4454 fastCert10_4454=true := by decide +kernel
def fastCert10_4455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4455 : checkCertificateFast 10 4455 fastCert10_4455=true := by decide +kernel
def fastCert10_4456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4456 : checkCertificateFast 10 4456 fastCert10_4456=true := by decide +kernel
def fastCert10_4457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4457 : checkCertificateFast 10 4457 fastCert10_4457=true := by decide +kernel
def fastCert10_4458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4458 : checkCertificateFast 10 4458 fastCert10_4458=true := by decide +kernel
def fastCert10_4459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_4459 : checkCertificateFast 10 4459 fastCert10_4459=true := by decide +kernel
def fastCert10_4460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4460 : checkCertificateFast 10 4460 fastCert10_4460=true := by decide +kernel
def fastCert10_4461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4461 : checkCertificateFast 10 4461 fastCert10_4461=true := by decide +kernel
def fastCert10_4462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4462 : checkCertificateFast 10 4462 fastCert10_4462=true := by decide +kernel
def fastCert10_4463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4463 : checkCertificateFast 10 4463 fastCert10_4463=true := by decide +kernel
def fastCert10_4464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-5) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (4) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (5) else if t=0 ∧ i=13 then (-3) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4464 : checkCertificateFast 10 4464 fastCert10_4464=true := by decide +kernel
def fastCert10_4465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4465 : checkCertificateFast 10 4465 fastCert10_4465=true := by decide +kernel
def fastCert10_4466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4466 : checkCertificateFast 10 4466 fastCert10_4466=true := by decide +kernel
def fastCert10_4467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4467 : checkCertificateFast 10 4467 fastCert10_4467=true := by decide +kernel
def fastCert10_4468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4468 : checkCertificateFast 10 4468 fastCert10_4468=true := by decide +kernel
def fastCert10_4469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4469 : checkCertificateFast 10 4469 fastCert10_4469=true := by decide +kernel
def fastCert10_4470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4470 : checkCertificateFast 10 4470 fastCert10_4470=true := by decide +kernel
def fastCert10_4471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4471 : checkCertificateFast 10 4471 fastCert10_4471=true := by decide +kernel
def fastCert10_4472 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4472 : checkCertificateFast 10 4472 fastCert10_4472=true := by decide +kernel
def fastCert10_4473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4473 : checkCertificateFast 10 4473 fastCert10_4473=true := by decide +kernel
def fastCert10_4474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4474 : checkCertificateFast 10 4474 fastCert10_4474=true := by decide +kernel
def fastCert10_4475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4475 : checkCertificateFast 10 4475 fastCert10_4475=true := by decide +kernel
def fastCert10_4476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4476 : checkCertificateFast 10 4476 fastCert10_4476=true := by decide +kernel
def fastCert10_4477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4477 : checkCertificateFast 10 4477 fastCert10_4477=true := by decide +kernel
def fastCert10_4478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4478 : checkCertificateFast 10 4478 fastCert10_4478=true := by decide +kernel
def fastCert10_4479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4479 : checkCertificateFast 10 4479 fastCert10_4479=true := by decide +kernel
def fastCert10_4480 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4480 : checkCertificateFast 10 4480 fastCert10_4480=true := by decide +kernel
def fastCert10_4481 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4481 : checkCertificateFast 10 4481 fastCert10_4481=true := by decide +kernel
def fastCert10_4482 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4482 : checkCertificateFast 10 4482 fastCert10_4482=true := by decide +kernel
def fastCert10_4483 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4483 : checkCertificateFast 10 4483 fastCert10_4483=true := by decide +kernel
def fastCert10_4484 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4484 : checkCertificateFast 10 4484 fastCert10_4484=true := by decide +kernel
def fastCert10_4485 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4485 : checkCertificateFast 10 4485 fastCert10_4485=true := by decide +kernel
def fastCert10_4486 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4486 : checkCertificateFast 10 4486 fastCert10_4486=true := by decide +kernel
def fastCert10_4487 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4487 : checkCertificateFast 10 4487 fastCert10_4487=true := by decide +kernel
def fastCert10_4488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4488 : checkCertificateFast 10 4488 fastCert10_4488=true := by decide +kernel
def fastCert10_4489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4489 : checkCertificateFast 10 4489 fastCert10_4489=true := by decide +kernel
def fastCert10_4490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4490 : checkCertificateFast 10 4490 fastCert10_4490=true := by decide +kernel
def fastCert10_4491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4491 : checkCertificateFast 10 4491 fastCert10_4491=true := by decide +kernel
def fastCert10_4492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4492 : checkCertificateFast 10 4492 fastCert10_4492=true := by decide +kernel
def fastCert10_4493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4493 : checkCertificateFast 10 4493 fastCert10_4493=true := by decide +kernel
def fastCert10_4494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4494 : checkCertificateFast 10 4494 fastCert10_4494=true := by decide +kernel
def fastCert10_4495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4495 : checkCertificateFast 10 4495 fastCert10_4495=true := by decide +kernel
def fastCert10_4496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4496 : checkCertificateFast 10 4496 fastCert10_4496=true := by decide +kernel
def fastCert10_4497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4497 : checkCertificateFast 10 4497 fastCert10_4497=true := by decide +kernel
def fastCert10_4498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4498 : checkCertificateFast 10 4498 fastCert10_4498=true := by decide +kernel
def fastCert10_4499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4499 : checkCertificateFast 10 4499 fastCert10_4499=true := by decide +kernel
def fastCert10_4500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4500 : checkCertificateFast 10 4500 fastCert10_4500=true := by decide +kernel
def fastCert10_4501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_4501 : checkCertificateFast 10 4501 fastCert10_4501=true := by decide +kernel
def fastCert10_4502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4502 : checkCertificateFast 10 4502 fastCert10_4502=true := by decide +kernel
def fastCert10_4503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4503 : checkCertificateFast 10 4503 fastCert10_4503=true := by decide +kernel
def fastCert10_4504 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4504 : checkCertificateFast 10 4504 fastCert10_4504=true := by decide +kernel
def fastCert10_4505 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4505 : checkCertificateFast 10 4505 fastCert10_4505=true := by decide +kernel
def fastCert10_4506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4506 : checkCertificateFast 10 4506 fastCert10_4506=true := by decide +kernel
def fastCert10_4507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4507 : checkCertificateFast 10 4507 fastCert10_4507=true := by decide +kernel
def fastCert10_4508 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4508 : checkCertificateFast 10 4508 fastCert10_4508=true := by decide +kernel
def fastCert10_4509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4509 : checkCertificateFast 10 4509 fastCert10_4509=true := by decide +kernel
def fastCert10_4510 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4510 : checkCertificateFast 10 4510 fastCert10_4510=true := by decide +kernel
def fastCert10_4511 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4511 : checkCertificateFast 10 4511 fastCert10_4511=true := by decide +kernel
def fastCert10_4512 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4512 : checkCertificateFast 10 4512 fastCert10_4512=true := by decide +kernel
def fastCert10_4513 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4513 : checkCertificateFast 10 4513 fastCert10_4513=true := by decide +kernel
def fastCert10_4514 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4514 : checkCertificateFast 10 4514 fastCert10_4514=true := by decide +kernel
def fastCert10_4515 : Certificate := ⟨7,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4515 : checkCertificateFast 10 4515 fastCert10_4515=true := by decide +kernel
def fastCert10_4516 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4516 : checkCertificateFast 10 4516 fastCert10_4516=true := by decide +kernel
def fastCert10_4517 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4517 : checkCertificateFast 10 4517 fastCert10_4517=true := by decide +kernel
def fastCert10_4518 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4518 : checkCertificateFast 10 4518 fastCert10_4518=true := by decide +kernel
def fastCert10_4519 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4519 : checkCertificateFast 10 4519 fastCert10_4519=true := by decide +kernel
def fastCert10_4520 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4520 : checkCertificateFast 10 4520 fastCert10_4520=true := by decide +kernel
def fastCert10_4521 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4521 : checkCertificateFast 10 4521 fastCert10_4521=true := by decide +kernel
def fastCert10_4522 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4522 : checkCertificateFast 10 4522 fastCert10_4522=true := by decide +kernel
def fastCert10_4523 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4523 : checkCertificateFast 10 4523 fastCert10_4523=true := by decide +kernel
def fastCert10_4524 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4524 : checkCertificateFast 10 4524 fastCert10_4524=true := by decide +kernel
def fastCert10_4525 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4525 : checkCertificateFast 10 4525 fastCert10_4525=true := by decide +kernel
def fastCert10_4526 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4526 : checkCertificateFast 10 4526 fastCert10_4526=true := by decide +kernel
def fastCert10_4527 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4527 : checkCertificateFast 10 4527 fastCert10_4527=true := by decide +kernel
def fastCert10_4528 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (3) else 0⟩
theorem fastCase10_4528 : checkCertificateFast 10 4528 fastCert10_4528=true := by decide +kernel
def fastCert10_4529 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_4529 : checkCertificateFast 10 4529 fastCert10_4529=true := by decide +kernel
def fastCert10_4530 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4530 : checkCertificateFast 10 4530 fastCert10_4530=true := by decide +kernel
def fastCert10_4531 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4531 : checkCertificateFast 10 4531 fastCert10_4531=true := by decide +kernel
def fastCert10_4532 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4532 : checkCertificateFast 10 4532 fastCert10_4532=true := by decide +kernel
def fastCert10_4533 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4533 : checkCertificateFast 10 4533 fastCert10_4533=true := by decide +kernel
def fastCert10_4534 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4534 : checkCertificateFast 10 4534 fastCert10_4534=true := by decide +kernel
def fastCert10_4535 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4535 : checkCertificateFast 10 4535 fastCert10_4535=true := by decide +kernel
def fastCert10_4536 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4536 : checkCertificateFast 10 4536 fastCert10_4536=true := by decide +kernel
def fastCert10_4537 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4537 : checkCertificateFast 10 4537 fastCert10_4537=true := by decide +kernel
def fastCert10_4538 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4538 : checkCertificateFast 10 4538 fastCert10_4538=true := by decide +kernel
def fastCert10_4539 : Certificate := ⟨7,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4539 : checkCertificateFast 10 4539 fastCert10_4539=true := by decide +kernel
def fastCert10_4540 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4540 : checkCertificateFast 10 4540 fastCert10_4540=true := by decide +kernel
def fastCert10_4541 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4541 : checkCertificateFast 10 4541 fastCert10_4541=true := by decide +kernel
def fastCert10_4542 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4542 : checkCertificateFast 10 4542 fastCert10_4542=true := by decide +kernel
def fastCert10_4543 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4543 : checkCertificateFast 10 4543 fastCert10_4543=true := by decide +kernel
def fastCert10_4544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4544 : checkCertificateFast 10 4544 fastCert10_4544=true := by decide +kernel
def fastCert10_4545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4545 : checkCertificateFast 10 4545 fastCert10_4545=true := by decide +kernel
def fastCert10_4546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_4546 : checkCertificateFast 10 4546 fastCert10_4546=true := by decide +kernel
def fastCert10_4547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_4547 : checkCertificateFast 10 4547 fastCert10_4547=true := by decide +kernel
def fastCert10_4548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4548 : checkCertificateFast 10 4548 fastCert10_4548=true := by decide +kernel
def fastCert10_4549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4549 : checkCertificateFast 10 4549 fastCert10_4549=true := by decide +kernel
def fastCert10_4550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4550 : checkCertificateFast 10 4550 fastCert10_4550=true := by decide +kernel
def fastCert10_4551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4551 : checkCertificateFast 10 4551 fastCert10_4551=true := by decide +kernel
def fastCert10_4552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4552 : checkCertificateFast 10 4552 fastCert10_4552=true := by decide +kernel
def fastCert10_4553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4553 : checkCertificateFast 10 4553 fastCert10_4553=true := by decide +kernel
def fastCert10_4554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_4554 : checkCertificateFast 10 4554 fastCert10_4554=true := by decide +kernel
def fastCert10_4555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_4555 : checkCertificateFast 10 4555 fastCert10_4555=true := by decide +kernel
def fastCert10_4556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4556 : checkCertificateFast 10 4556 fastCert10_4556=true := by decide +kernel
def fastCert10_4557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4557 : checkCertificateFast 10 4557 fastCert10_4557=true := by decide +kernel
def fastCert10_4558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4558 : checkCertificateFast 10 4558 fastCert10_4558=true := by decide +kernel
def fastCert10_4559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4559 : checkCertificateFast 10 4559 fastCert10_4559=true := by decide +kernel
def fastCert10_4560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4560 : checkCertificateFast 10 4560 fastCert10_4560=true := by decide +kernel
def fastCert10_4561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4561 : checkCertificateFast 10 4561 fastCert10_4561=true := by decide +kernel
def fastCert10_4562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4562 : checkCertificateFast 10 4562 fastCert10_4562=true := by decide +kernel
def fastCert10_4563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4563 : checkCertificateFast 10 4563 fastCert10_4563=true := by decide +kernel
def fastCert10_4564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4564 : checkCertificateFast 10 4564 fastCert10_4564=true := by decide +kernel
def fastCert10_4565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4565 : checkCertificateFast 10 4565 fastCert10_4565=true := by decide +kernel
def fastCert10_4566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4566 : checkCertificateFast 10 4566 fastCert10_4566=true := by decide +kernel
def fastCert10_4567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4567 : checkCertificateFast 10 4567 fastCert10_4567=true := by decide +kernel
def fastCert10_4568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4568 : checkCertificateFast 10 4568 fastCert10_4568=true := by decide +kernel
def fastCert10_4569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4569 : checkCertificateFast 10 4569 fastCert10_4569=true := by decide +kernel
def fastCert10_4570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4570 : checkCertificateFast 10 4570 fastCert10_4570=true := by decide +kernel
def fastCert10_4571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4571 : checkCertificateFast 10 4571 fastCert10_4571=true := by decide +kernel
def fastCert10_4572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4572 : checkCertificateFast 10 4572 fastCert10_4572=true := by decide +kernel
def fastCert10_4573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4573 : checkCertificateFast 10 4573 fastCert10_4573=true := by decide +kernel
def fastCert10_4574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4574 : checkCertificateFast 10 4574 fastCert10_4574=true := by decide +kernel
def fastCert10_4575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4575 : checkCertificateFast 10 4575 fastCert10_4575=true := by decide +kernel
def fastCert10_4576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4576 : checkCertificateFast 10 4576 fastCert10_4576=true := by decide +kernel
def fastCert10_4577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4577 : checkCertificateFast 10 4577 fastCert10_4577=true := by decide +kernel
def fastCert10_4578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4578 : checkCertificateFast 10 4578 fastCert10_4578=true := by decide +kernel
def fastCert10_4579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4579 : checkCertificateFast 10 4579 fastCert10_4579=true := by decide +kernel
def fastCert10_4580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4580 : checkCertificateFast 10 4580 fastCert10_4580=true := by decide +kernel
def fastCert10_4581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4581 : checkCertificateFast 10 4581 fastCert10_4581=true := by decide +kernel
def fastCert10_4582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4582 : checkCertificateFast 10 4582 fastCert10_4582=true := by decide +kernel
def fastCert10_4583 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4583 : checkCertificateFast 10 4583 fastCert10_4583=true := by decide +kernel
def fastCert10_4584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4584 : checkCertificateFast 10 4584 fastCert10_4584=true := by decide +kernel
def fastCert10_4585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4585 : checkCertificateFast 10 4585 fastCert10_4585=true := by decide +kernel
def fastCert10_4586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4586 : checkCertificateFast 10 4586 fastCert10_4586=true := by decide +kernel
def fastCert10_4587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4587 : checkCertificateFast 10 4587 fastCert10_4587=true := by decide +kernel
def fastCert10_4588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4588 : checkCertificateFast 10 4588 fastCert10_4588=true := by decide +kernel
def fastCert10_4589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4589 : checkCertificateFast 10 4589 fastCert10_4589=true := by decide +kernel
def fastCert10_4590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4590 : checkCertificateFast 10 4590 fastCert10_4590=true := by decide +kernel
def fastCert10_4591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4591 : checkCertificateFast 10 4591 fastCert10_4591=true := by decide +kernel
def fastCert10_4592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4592 : checkCertificateFast 10 4592 fastCert10_4592=true := by decide +kernel
def fastCert10_4593 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4593 : checkCertificateFast 10 4593 fastCert10_4593=true := by decide +kernel
def fastCert10_4594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4594 : checkCertificateFast 10 4594 fastCert10_4594=true := by decide +kernel
def fastCert10_4595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_4595 : checkCertificateFast 10 4595 fastCert10_4595=true := by decide +kernel
def fastCert10_4596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4596 : checkCertificateFast 10 4596 fastCert10_4596=true := by decide +kernel
def fastCert10_4597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4597 : checkCertificateFast 10 4597 fastCert10_4597=true := by decide +kernel
def fastCert10_4598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4598 : checkCertificateFast 10 4598 fastCert10_4598=true := by decide +kernel
def fastCert10_4599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4599 : checkCertificateFast 10 4599 fastCert10_4599=true := by decide +kernel
def fastCert10_4600 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4600 : checkCertificateFast 10 4600 fastCert10_4600=true := by decide +kernel
def fastCert10_4601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4601 : checkCertificateFast 10 4601 fastCert10_4601=true := by decide +kernel
def fastCert10_4602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_4602 : checkCertificateFast 10 4602 fastCert10_4602=true := by decide +kernel
def fastCert10_4603 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_4603 : checkCertificateFast 10 4603 fastCert10_4603=true := by decide +kernel
def fastCert10_4604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4604 : checkCertificateFast 10 4604 fastCert10_4604=true := by decide +kernel
def fastCert10_4605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4605 : checkCertificateFast 10 4605 fastCert10_4605=true := by decide +kernel
def fastCert10_4606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4606 : checkCertificateFast 10 4606 fastCert10_4606=true := by decide +kernel
def fastCert10_4607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4607 : checkCertificateFast 10 4607 fastCert10_4607=true := by decide +kernel
def fastCert10_4608 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4608 : checkCertificateFast 10 4608 fastCert10_4608=true := by decide +kernel
def fastCert10_4609 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4609 : checkCertificateFast 10 4609 fastCert10_4609=true := by decide +kernel
def fastCert10_4610 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4610 : checkCertificateFast 10 4610 fastCert10_4610=true := by decide +kernel
def fastCert10_4611 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4611 : checkCertificateFast 10 4611 fastCert10_4611=true := by decide +kernel
def fastCert10_4612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4612 : checkCertificateFast 10 4612 fastCert10_4612=true := by decide +kernel
def fastCert10_4613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4613 : checkCertificateFast 10 4613 fastCert10_4613=true := by decide +kernel
def fastCert10_4614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4614 : checkCertificateFast 10 4614 fastCert10_4614=true := by decide +kernel
def fastCert10_4615 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4615 : checkCertificateFast 10 4615 fastCert10_4615=true := by decide +kernel
def fastCert10_4616 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4616 : checkCertificateFast 10 4616 fastCert10_4616=true := by decide +kernel
def fastCert10_4617 : Certificate := ⟨22,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4617 : checkCertificateFast 10 4617 fastCert10_4617=true := by decide +kernel
def fastCert10_4618 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4618 : checkCertificateFast 10 4618 fastCert10_4618=true := by decide +kernel
def fastCert10_4619 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4619 : checkCertificateFast 10 4619 fastCert10_4619=true := by decide +kernel
def fastCert10_4620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4620 : checkCertificateFast 10 4620 fastCert10_4620=true := by decide +kernel
def fastCert10_4621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4621 : checkCertificateFast 10 4621 fastCert10_4621=true := by decide +kernel
def fastCert10_4622 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4622 : checkCertificateFast 10 4622 fastCert10_4622=true := by decide +kernel
def fastCert10_4623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4623 : checkCertificateFast 10 4623 fastCert10_4623=true := by decide +kernel
def fastCert10_4624 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4624 : checkCertificateFast 10 4624 fastCert10_4624=true := by decide +kernel
def fastCert10_4625 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4625 : checkCertificateFast 10 4625 fastCert10_4625=true := by decide +kernel
def fastCert10_4626 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4626 : checkCertificateFast 10 4626 fastCert10_4626=true := by decide +kernel
def fastCert10_4627 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4627 : checkCertificateFast 10 4627 fastCert10_4627=true := by decide +kernel
def fastCert10_4628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4628 : checkCertificateFast 10 4628 fastCert10_4628=true := by decide +kernel
def fastCert10_4629 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4629 : checkCertificateFast 10 4629 fastCert10_4629=true := by decide +kernel
def fastCert10_4630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4630 : checkCertificateFast 10 4630 fastCert10_4630=true := by decide +kernel
def fastCert10_4631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4631 : checkCertificateFast 10 4631 fastCert10_4631=true := by decide +kernel
def fastCert10_4632 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4632 : checkCertificateFast 10 4632 fastCert10_4632=true := by decide +kernel
def fastCert10_4633 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4633 : checkCertificateFast 10 4633 fastCert10_4633=true := by decide +kernel
def fastCert10_4634 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4634 : checkCertificateFast 10 4634 fastCert10_4634=true := by decide +kernel
def fastCert10_4635 : Certificate := ⟨22,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4635 : checkCertificateFast 10 4635 fastCert10_4635=true := by decide +kernel
def fastCert10_4636 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4636 : checkCertificateFast 10 4636 fastCert10_4636=true := by decide +kernel
def fastCert10_4637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4637 : checkCertificateFast 10 4637 fastCert10_4637=true := by decide +kernel
def fastCert10_4638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4638 : checkCertificateFast 10 4638 fastCert10_4638=true := by decide +kernel
def fastCert10_4639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4639 : checkCertificateFast 10 4639 fastCert10_4639=true := by decide +kernel
def fastCert10_4640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4640 : checkCertificateFast 10 4640 fastCert10_4640=true := by decide +kernel
def fastCert10_4641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4641 : checkCertificateFast 10 4641 fastCert10_4641=true := by decide +kernel
def fastCert10_4642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4642 : checkCertificateFast 10 4642 fastCert10_4642=true := by decide +kernel
def fastCert10_4643 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4643 : checkCertificateFast 10 4643 fastCert10_4643=true := by decide +kernel
def fastCert10_4644 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4644 : checkCertificateFast 10 4644 fastCert10_4644=true := by decide +kernel
def fastCert10_4645 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4645 : checkCertificateFast 10 4645 fastCert10_4645=true := by decide +kernel
def fastCert10_4646 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4646 : checkCertificateFast 10 4646 fastCert10_4646=true := by decide +kernel
def fastCert10_4647 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4647 : checkCertificateFast 10 4647 fastCert10_4647=true := by decide +kernel
def fastCert10_4648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4648 : checkCertificateFast 10 4648 fastCert10_4648=true := by decide +kernel
def fastCert10_4649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4649 : checkCertificateFast 10 4649 fastCert10_4649=true := by decide +kernel
def fastCert10_4650 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4650 : checkCertificateFast 10 4650 fastCert10_4650=true := by decide +kernel
def fastCert10_4651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4651 : checkCertificateFast 10 4651 fastCert10_4651=true := by decide +kernel
def fastCert10_4652 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4652 : checkCertificateFast 10 4652 fastCert10_4652=true := by decide +kernel
def fastCert10_4653 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4653 : checkCertificateFast 10 4653 fastCert10_4653=true := by decide +kernel
def fastCert10_4654 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4654 : checkCertificateFast 10 4654 fastCert10_4654=true := by decide +kernel
def fastCert10_4655 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4655 : checkCertificateFast 10 4655 fastCert10_4655=true := by decide +kernel
def fastCert10_4656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4656 : checkCertificateFast 10 4656 fastCert10_4656=true := by decide +kernel
def fastCert10_4657 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4657 : checkCertificateFast 10 4657 fastCert10_4657=true := by decide +kernel
def fastCert10_4658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4658 : checkCertificateFast 10 4658 fastCert10_4658=true := by decide +kernel
def fastCert10_4659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4659 : checkCertificateFast 10 4659 fastCert10_4659=true := by decide +kernel
def fastCert10_4660 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4660 : checkCertificateFast 10 4660 fastCert10_4660=true := by decide +kernel
def fastCert10_4661 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4661 : checkCertificateFast 10 4661 fastCert10_4661=true := by decide +kernel
def fastCert10_4662 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4662 : checkCertificateFast 10 4662 fastCert10_4662=true := by decide +kernel
def fastCert10_4663 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4663 : checkCertificateFast 10 4663 fastCert10_4663=true := by decide +kernel
def fastCert10_4664 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4664 : checkCertificateFast 10 4664 fastCert10_4664=true := by decide +kernel
def fastCert10_4665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4665 : checkCertificateFast 10 4665 fastCert10_4665=true := by decide +kernel
def fastCert10_4666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4666 : checkCertificateFast 10 4666 fastCert10_4666=true := by decide +kernel
def fastCert10_4667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4667 : checkCertificateFast 10 4667 fastCert10_4667=true := by decide +kernel
def fastCert10_4668 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4668 : checkCertificateFast 10 4668 fastCert10_4668=true := by decide +kernel
def fastCert10_4669 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4669 : checkCertificateFast 10 4669 fastCert10_4669=true := by decide +kernel
def fastCert10_4670 : Certificate := ⟨12,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4670 : checkCertificateFast 10 4670 fastCert10_4670=true := by decide +kernel
def fastCert10_4671 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4671 : checkCertificateFast 10 4671 fastCert10_4671=true := by decide +kernel
def fastCert10_4672 : Certificate := ⟨0,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=1 then (-1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=7 then (-1) else if t=2 ∧ i=2 then (-1) else if t=2 ∧ i=3 then (1) else if t=2 ∧ i=8 then (1) else if t=2 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4672 : checkCertificateFast 10 4672 fastCert10_4672=true := by decide +kernel
def fastCert10_4673 : Certificate := ⟨28,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4673 : checkCertificateFast 10 4673 fastCert10_4673=true := by decide +kernel
def fastCert10_4674 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4674 : checkCertificateFast 10 4674 fastCert10_4674=true := by decide +kernel
def fastCert10_4675 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4675 : checkCertificateFast 10 4675 fastCert10_4675=true := by decide +kernel
def fastCert10_4676 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4676 : checkCertificateFast 10 4676 fastCert10_4676=true := by decide +kernel
def fastCert10_4677 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4677 : checkCertificateFast 10 4677 fastCert10_4677=true := by decide +kernel
def fastCert10_4678 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4678 : checkCertificateFast 10 4678 fastCert10_4678=true := by decide +kernel
def fastCert10_4679 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4679 : checkCertificateFast 10 4679 fastCert10_4679=true := by decide +kernel
def fastCert10_4680 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4680 : checkCertificateFast 10 4680 fastCert10_4680=true := by decide +kernel
def fastCert10_4681 : Certificate := ⟨27,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4681 : checkCertificateFast 10 4681 fastCert10_4681=true := by decide +kernel
def fastCert10_4682 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4682 : checkCertificateFast 10 4682 fastCert10_4682=true := by decide +kernel
def fastCert10_4683 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4683 : checkCertificateFast 10 4683 fastCert10_4683=true := by decide +kernel
def fastCert10_4684 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4684 : checkCertificateFast 10 4684 fastCert10_4684=true := by decide +kernel
def fastCert10_4685 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4685 : checkCertificateFast 10 4685 fastCert10_4685=true := by decide +kernel
def fastCert10_4686 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4686 : checkCertificateFast 10 4686 fastCert10_4686=true := by decide +kernel
def fastCert10_4687 : Certificate := ⟨13,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4687 : checkCertificateFast 10 4687 fastCert10_4687=true := by decide +kernel
def fastCert10_4688 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4688 : checkCertificateFast 10 4688 fastCert10_4688=true := by decide +kernel
def fastCert10_4689 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4689 : checkCertificateFast 10 4689 fastCert10_4689=true := by decide +kernel
def fastCert10_4690 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4690 : checkCertificateFast 10 4690 fastCert10_4690=true := by decide +kernel
def fastCert10_4691 : Certificate := ⟨28,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4691 : checkCertificateFast 10 4691 fastCert10_4691=true := by decide +kernel
def fastCert10_4692 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4692 : checkCertificateFast 10 4692 fastCert10_4692=true := by decide +kernel
def fastCert10_4693 : Certificate := ⟨20,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4693 : checkCertificateFast 10 4693 fastCert10_4693=true := by decide +kernel
def fastCert10_4694 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4694 : checkCertificateFast 10 4694 fastCert10_4694=true := by decide +kernel
def fastCert10_4695 : Certificate := ⟨20,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4695 : checkCertificateFast 10 4695 fastCert10_4695=true := by decide +kernel
def fastCert10_4696 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4696 : checkCertificateFast 10 4696 fastCert10_4696=true := by decide +kernel
def fastCert10_4697 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4697 : checkCertificateFast 10 4697 fastCert10_4697=true := by decide +kernel
def fastCert10_4698 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4698 : checkCertificateFast 10 4698 fastCert10_4698=true := by decide +kernel
def fastCert10_4699 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4699 : checkCertificateFast 10 4699 fastCert10_4699=true := by decide +kernel
def fastCert10_4700 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4700 : checkCertificateFast 10 4700 fastCert10_4700=true := by decide +kernel
def fastCert10_4701 : Certificate := ⟨34,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4701 : checkCertificateFast 10 4701 fastCert10_4701=true := by decide +kernel
def fastCert10_4702 : Certificate := ⟨35,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4702 : checkCertificateFast 10 4702 fastCert10_4702=true := by decide +kernel
def fastCert10_4703 : Certificate := ⟨6,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4703 : checkCertificateFast 10 4703 fastCert10_4703=true := by decide +kernel
def fastCert10_4704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4704 : checkCertificateFast 10 4704 fastCert10_4704=true := by decide +kernel
def fastCert10_4705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4705 : checkCertificateFast 10 4705 fastCert10_4705=true := by decide +kernel
def fastCert10_4706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4706 : checkCertificateFast 10 4706 fastCert10_4706=true := by decide +kernel
def fastCert10_4707 : Certificate := ⟨8,fun t i => if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4707 : checkCertificateFast 10 4707 fastCert10_4707=true := by decide +kernel
def fastCert10_4708 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4708 : checkCertificateFast 10 4708 fastCert10_4708=true := by decide +kernel
def fastCert10_4709 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4709 : checkCertificateFast 10 4709 fastCert10_4709=true := by decide +kernel
def fastCert10_4710 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4710 : checkCertificateFast 10 4710 fastCert10_4710=true := by decide +kernel
def fastCert10_4711 : Certificate := ⟨8,fun t i => if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4711 : checkCertificateFast 10 4711 fastCert10_4711=true := by decide +kernel
def fastCert10_4712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4712 : checkCertificateFast 10 4712 fastCert10_4712=true := by decide +kernel
def fastCert10_4713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4713 : checkCertificateFast 10 4713 fastCert10_4713=true := by decide +kernel
def fastCert10_4714 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4714 : checkCertificateFast 10 4714 fastCert10_4714=true := by decide +kernel
def fastCert10_4715 : Certificate := ⟨36,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4715 : checkCertificateFast 10 4715 fastCert10_4715=true := by decide +kernel
def fastCert10_4716 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4716 : checkCertificateFast 10 4716 fastCert10_4716=true := by decide +kernel
def fastCert10_4717 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4717 : checkCertificateFast 10 4717 fastCert10_4717=true := by decide +kernel
def fastCert10_4718 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4718 : checkCertificateFast 10 4718 fastCert10_4718=true := by decide +kernel
def fastCert10_4719 : Certificate := ⟨17,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4719 : checkCertificateFast 10 4719 fastCert10_4719=true := by decide +kernel
def fastCert10_4720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4720 : checkCertificateFast 10 4720 fastCert10_4720=true := by decide +kernel
def fastCert10_4721 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4721 : checkCertificateFast 10 4721 fastCert10_4721=true := by decide +kernel
def fastCert10_4722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4722 : checkCertificateFast 10 4722 fastCert10_4722=true := by decide +kernel
def fastCert10_4723 : Certificate := ⟨37,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4723 : checkCertificateFast 10 4723 fastCert10_4723=true := by decide +kernel
def fastCert10_4724 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4724 : checkCertificateFast 10 4724 fastCert10_4724=true := by decide +kernel
def fastCert10_4725 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4725 : checkCertificateFast 10 4725 fastCert10_4725=true := by decide +kernel
def fastCert10_4726 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4726 : checkCertificateFast 10 4726 fastCert10_4726=true := by decide +kernel
def fastCert10_4727 : Certificate := ⟨10,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4727 : checkCertificateFast 10 4727 fastCert10_4727=true := by decide +kernel
def fastCert10_4728 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4728 : checkCertificateFast 10 4728 fastCert10_4728=true := by decide +kernel
def fastCert10_4729 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4729 : checkCertificateFast 10 4729 fastCert10_4729=true := by decide +kernel
def fastCert10_4730 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4730 : checkCertificateFast 10 4730 fastCert10_4730=true := by decide +kernel
def fastCert10_4731 : Certificate := ⟨6,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4731 : checkCertificateFast 10 4731 fastCert10_4731=true := by decide +kernel
def fastCert10_4732 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4732 : checkCertificateFast 10 4732 fastCert10_4732=true := by decide +kernel
def fastCert10_4733 : Certificate := ⟨17,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4733 : checkCertificateFast 10 4733 fastCert10_4733=true := by decide +kernel
def fastCert10_4734 : Certificate := ⟨10,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4734 : checkCertificateFast 10 4734 fastCert10_4734=true := by decide +kernel
def fastCert10_4735 : Certificate := ⟨10,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4735 : checkCertificateFast 10 4735 fastCert10_4735=true := by decide +kernel
def fastCert10_4736 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4736 : checkCertificateFast 10 4736 fastCert10_4736=true := by decide +kernel
def fastCert10_4737 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4737 : checkCertificateFast 10 4737 fastCert10_4737=true := by decide +kernel
def fastCert10_4738 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4738 : checkCertificateFast 10 4738 fastCert10_4738=true := by decide +kernel
def fastCert10_4739 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4739 : checkCertificateFast 10 4739 fastCert10_4739=true := by decide +kernel
def fastCert10_4740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4740 : checkCertificateFast 10 4740 fastCert10_4740=true := by decide +kernel
def fastCert10_4741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4741 : checkCertificateFast 10 4741 fastCert10_4741=true := by decide +kernel
def fastCert10_4742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4742 : checkCertificateFast 10 4742 fastCert10_4742=true := by decide +kernel
def fastCert10_4743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4743 : checkCertificateFast 10 4743 fastCert10_4743=true := by decide +kernel
def fastCert10_4744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4744 : checkCertificateFast 10 4744 fastCert10_4744=true := by decide +kernel
def fastCert10_4745 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4745 : checkCertificateFast 10 4745 fastCert10_4745=true := by decide +kernel
def fastCert10_4746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4746 : checkCertificateFast 10 4746 fastCert10_4746=true := by decide +kernel
def fastCert10_4747 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4747 : checkCertificateFast 10 4747 fastCert10_4747=true := by decide +kernel
def fastCert10_4748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4748 : checkCertificateFast 10 4748 fastCert10_4748=true := by decide +kernel
def fastCert10_4749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4749 : checkCertificateFast 10 4749 fastCert10_4749=true := by decide +kernel
def fastCert10_4750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4750 : checkCertificateFast 10 4750 fastCert10_4750=true := by decide +kernel
def fastCert10_4751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4751 : checkCertificateFast 10 4751 fastCert10_4751=true := by decide +kernel
def fastCert10_4752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4752 : checkCertificateFast 10 4752 fastCert10_4752=true := by decide +kernel
def fastCert10_4753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4753 : checkCertificateFast 10 4753 fastCert10_4753=true := by decide +kernel
def fastCert10_4754 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4754 : checkCertificateFast 10 4754 fastCert10_4754=true := by decide +kernel
def fastCert10_4755 : Certificate := ⟨19,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (3) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_4755 : checkCertificateFast 10 4755 fastCert10_4755=true := by decide +kernel
def fastCert10_4756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4756 : checkCertificateFast 10 4756 fastCert10_4756=true := by decide +kernel
def fastCert10_4757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4757 : checkCertificateFast 10 4757 fastCert10_4757=true := by decide +kernel
def fastCert10_4758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4758 : checkCertificateFast 10 4758 fastCert10_4758=true := by decide +kernel
def fastCert10_4759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4759 : checkCertificateFast 10 4759 fastCert10_4759=true := by decide +kernel
def fastCert10_4760 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4760 : checkCertificateFast 10 4760 fastCert10_4760=true := by decide +kernel
def fastCert10_4761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4761 : checkCertificateFast 10 4761 fastCert10_4761=true := by decide +kernel
def fastCert10_4762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4762 : checkCertificateFast 10 4762 fastCert10_4762=true := by decide +kernel
def fastCert10_4763 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4763 : checkCertificateFast 10 4763 fastCert10_4763=true := by decide +kernel
def fastCert10_4764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4764 : checkCertificateFast 10 4764 fastCert10_4764=true := by decide +kernel
def fastCert10_4765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4765 : checkCertificateFast 10 4765 fastCert10_4765=true := by decide +kernel
def fastCert10_4766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4766 : checkCertificateFast 10 4766 fastCert10_4766=true := by decide +kernel
def fastCert10_4767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4767 : checkCertificateFast 10 4767 fastCert10_4767=true := by decide +kernel
def fastCert10_4768 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4768 : checkCertificateFast 10 4768 fastCert10_4768=true := by decide +kernel
def fastCert10_4769 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4769 : checkCertificateFast 10 4769 fastCert10_4769=true := by decide +kernel
def fastCert10_4770 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4770 : checkCertificateFast 10 4770 fastCert10_4770=true := by decide +kernel
def fastCert10_4771 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4771 : checkCertificateFast 10 4771 fastCert10_4771=true := by decide +kernel
def fastCert10_4772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4772 : checkCertificateFast 10 4772 fastCert10_4772=true := by decide +kernel
def fastCert10_4773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4773 : checkCertificateFast 10 4773 fastCert10_4773=true := by decide +kernel
def fastCert10_4774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4774 : checkCertificateFast 10 4774 fastCert10_4774=true := by decide +kernel
def fastCert10_4775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4775 : checkCertificateFast 10 4775 fastCert10_4775=true := by decide +kernel
def fastCert10_4776 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4776 : checkCertificateFast 10 4776 fastCert10_4776=true := by decide +kernel
def fastCert10_4777 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4777 : checkCertificateFast 10 4777 fastCert10_4777=true := by decide +kernel
def fastCert10_4778 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4778 : checkCertificateFast 10 4778 fastCert10_4778=true := by decide +kernel
def fastCert10_4779 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4779 : checkCertificateFast 10 4779 fastCert10_4779=true := by decide +kernel
def fastCert10_4780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4780 : checkCertificateFast 10 4780 fastCert10_4780=true := by decide +kernel
def fastCert10_4781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4781 : checkCertificateFast 10 4781 fastCert10_4781=true := by decide +kernel
def fastCert10_4782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4782 : checkCertificateFast 10 4782 fastCert10_4782=true := by decide +kernel
def fastCert10_4783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_4783 : checkCertificateFast 10 4783 fastCert10_4783=true := by decide +kernel
def fastCert10_4784 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4784 : checkCertificateFast 10 4784 fastCert10_4784=true := by decide +kernel
def fastCert10_4785 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4785 : checkCertificateFast 10 4785 fastCert10_4785=true := by decide +kernel
def fastCert10_4786 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4786 : checkCertificateFast 10 4786 fastCert10_4786=true := by decide +kernel
def fastCert10_4787 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4787 : checkCertificateFast 10 4787 fastCert10_4787=true := by decide +kernel
def fastCert10_4788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4788 : checkCertificateFast 10 4788 fastCert10_4788=true := by decide +kernel
def fastCert10_4789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4789 : checkCertificateFast 10 4789 fastCert10_4789=true := by decide +kernel
def fastCert10_4790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4790 : checkCertificateFast 10 4790 fastCert10_4790=true := by decide +kernel
def fastCert10_4791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_4791 : checkCertificateFast 10 4791 fastCert10_4791=true := by decide +kernel
def fastCert10_4792 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=5 then (-1) else if t=1 ∧ i=7 then (1) else if t=1 ∧ i=10 then (1) else if t=1 ∧ i=11 then (1) else if t=1 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4792 : checkCertificateFast 10 4792 fastCert10_4792=true := by decide +kernel
def fastCert10_4793 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4793 : checkCertificateFast 10 4793 fastCert10_4793=true := by decide +kernel
def fastCert10_4794 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4794 : checkCertificateFast 10 4794 fastCert10_4794=true := by decide +kernel
def fastCert10_4795 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4795 : checkCertificateFast 10 4795 fastCert10_4795=true := by decide +kernel
def fastCert10_4796 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4796 : checkCertificateFast 10 4796 fastCert10_4796=true := by decide +kernel
def fastCert10_4797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4797 : checkCertificateFast 10 4797 fastCert10_4797=true := by decide +kernel
def fastCert10_4798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4798 : checkCertificateFast 10 4798 fastCert10_4798=true := by decide +kernel
def fastCert10_4799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4799 : checkCertificateFast 10 4799 fastCert10_4799=true := by decide +kernel
def fastCert10_4800 : Certificate := ⟨1,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=6 then (-1) else if t=1 ∧ i=7 then (1) else 0⟩
theorem fastCase10_4800 : checkCertificateFast 10 4800 fastCert10_4800=true := by decide +kernel
def fastCert10_4801 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4801 : checkCertificateFast 10 4801 fastCert10_4801=true := by decide +kernel
def fastCert10_4802 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4802 : checkCertificateFast 10 4802 fastCert10_4802=true := by decide +kernel
def fastCert10_4803 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4803 : checkCertificateFast 10 4803 fastCert10_4803=true := by decide +kernel
def fastCert10_4804 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4804 : checkCertificateFast 10 4804 fastCert10_4804=true := by decide +kernel
def fastCert10_4805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4805 : checkCertificateFast 10 4805 fastCert10_4805=true := by decide +kernel
def fastCert10_4806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4806 : checkCertificateFast 10 4806 fastCert10_4806=true := by decide +kernel
def fastCert10_4807 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4807 : checkCertificateFast 10 4807 fastCert10_4807=true := by decide +kernel
def fastCert10_4808 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4808 : checkCertificateFast 10 4808 fastCert10_4808=true := by decide +kernel
def fastCert10_4809 : Certificate := ⟨27,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_4809 : checkCertificateFast 10 4809 fastCert10_4809=true := by decide +kernel
def fastCert10_4810 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4810 : checkCertificateFast 10 4810 fastCert10_4810=true := by decide +kernel
def fastCert10_4811 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4811 : checkCertificateFast 10 4811 fastCert10_4811=true := by decide +kernel
def fastCert10_4812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4812 : checkCertificateFast 10 4812 fastCert10_4812=true := by decide +kernel
def fastCert10_4813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4813 : checkCertificateFast 10 4813 fastCert10_4813=true := by decide +kernel
def fastCert10_4814 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4814 : checkCertificateFast 10 4814 fastCert10_4814=true := by decide +kernel
def fastCert10_4815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4815 : checkCertificateFast 10 4815 fastCert10_4815=true := by decide +kernel
def fastCert10_4816 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4816 : checkCertificateFast 10 4816 fastCert10_4816=true := by decide +kernel
def fastCert10_4817 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4817 : checkCertificateFast 10 4817 fastCert10_4817=true := by decide +kernel
def fastCert10_4818 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_4818 : checkCertificateFast 10 4818 fastCert10_4818=true := by decide +kernel
def fastCert10_4819 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4819 : checkCertificateFast 10 4819 fastCert10_4819=true := by decide +kernel
def fastCert10_4820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4820 : checkCertificateFast 10 4820 fastCert10_4820=true := by decide +kernel
def fastCert10_4821 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4821 : checkCertificateFast 10 4821 fastCert10_4821=true := by decide +kernel
def fastCert10_4822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4822 : checkCertificateFast 10 4822 fastCert10_4822=true := by decide +kernel
def fastCert10_4823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4823 : checkCertificateFast 10 4823 fastCert10_4823=true := by decide +kernel
def fastCert10_4824 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4824 : checkCertificateFast 10 4824 fastCert10_4824=true := by decide +kernel
def fastCert10_4825 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4825 : checkCertificateFast 10 4825 fastCert10_4825=true := by decide +kernel
def fastCert10_4826 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4826 : checkCertificateFast 10 4826 fastCert10_4826=true := by decide +kernel
def fastCert10_4827 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_4827 : checkCertificateFast 10 4827 fastCert10_4827=true := by decide +kernel
def fastCert10_4828 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4828 : checkCertificateFast 10 4828 fastCert10_4828=true := by decide +kernel
def fastCert10_4829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4829 : checkCertificateFast 10 4829 fastCert10_4829=true := by decide +kernel
def fastCert10_4830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4830 : checkCertificateFast 10 4830 fastCert10_4830=true := by decide +kernel
def fastCert10_4831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4831 : checkCertificateFast 10 4831 fastCert10_4831=true := by decide +kernel
def fastCert10_4832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4832 : checkCertificateFast 10 4832 fastCert10_4832=true := by decide +kernel
def fastCert10_4833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4833 : checkCertificateFast 10 4833 fastCert10_4833=true := by decide +kernel
def fastCert10_4834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4834 : checkCertificateFast 10 4834 fastCert10_4834=true := by decide +kernel
def fastCert10_4835 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4835 : checkCertificateFast 10 4835 fastCert10_4835=true := by decide +kernel
def fastCert10_4836 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4836 : checkCertificateFast 10 4836 fastCert10_4836=true := by decide +kernel
def fastCert10_4837 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4837 : checkCertificateFast 10 4837 fastCert10_4837=true := by decide +kernel
def fastCert10_4838 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4838 : checkCertificateFast 10 4838 fastCert10_4838=true := by decide +kernel
def fastCert10_4839 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4839 : checkCertificateFast 10 4839 fastCert10_4839=true := by decide +kernel
def fastCert10_4840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4840 : checkCertificateFast 10 4840 fastCert10_4840=true := by decide +kernel
def fastCert10_4841 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4841 : checkCertificateFast 10 4841 fastCert10_4841=true := by decide +kernel
def fastCert10_4842 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4842 : checkCertificateFast 10 4842 fastCert10_4842=true := by decide +kernel
def fastCert10_4843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4843 : checkCertificateFast 10 4843 fastCert10_4843=true := by decide +kernel
def fastCert10_4844 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4844 : checkCertificateFast 10 4844 fastCert10_4844=true := by decide +kernel
def fastCert10_4845 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4845 : checkCertificateFast 10 4845 fastCert10_4845=true := by decide +kernel
def fastCert10_4846 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4846 : checkCertificateFast 10 4846 fastCert10_4846=true := by decide +kernel
def fastCert10_4847 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4847 : checkCertificateFast 10 4847 fastCert10_4847=true := by decide +kernel
def fastCert10_4848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4848 : checkCertificateFast 10 4848 fastCert10_4848=true := by decide +kernel
def fastCert10_4849 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4849 : checkCertificateFast 10 4849 fastCert10_4849=true := by decide +kernel
def fastCert10_4850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4850 : checkCertificateFast 10 4850 fastCert10_4850=true := by decide +kernel
def fastCert10_4851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4851 : checkCertificateFast 10 4851 fastCert10_4851=true := by decide +kernel
def fastCert10_4852 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4852 : checkCertificateFast 10 4852 fastCert10_4852=true := by decide +kernel
def fastCert10_4853 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4853 : checkCertificateFast 10 4853 fastCert10_4853=true := by decide +kernel
def fastCert10_4854 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4854 : checkCertificateFast 10 4854 fastCert10_4854=true := by decide +kernel
def fastCert10_4855 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4855 : checkCertificateFast 10 4855 fastCert10_4855=true := by decide +kernel
def fastCert10_4856 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4856 : checkCertificateFast 10 4856 fastCert10_4856=true := by decide +kernel
def fastCert10_4857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4857 : checkCertificateFast 10 4857 fastCert10_4857=true := by decide +kernel
def fastCert10_4858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4858 : checkCertificateFast 10 4858 fastCert10_4858=true := by decide +kernel
def fastCert10_4859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4859 : checkCertificateFast 10 4859 fastCert10_4859=true := by decide +kernel
def fastCert10_4860 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4860 : checkCertificateFast 10 4860 fastCert10_4860=true := by decide +kernel
def fastCert10_4861 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4861 : checkCertificateFast 10 4861 fastCert10_4861=true := by decide +kernel
def fastCert10_4862 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4862 : checkCertificateFast 10 4862 fastCert10_4862=true := by decide +kernel
def fastCert10_4863 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4863 : checkCertificateFast 10 4863 fastCert10_4863=true := by decide +kernel
def fastCert10_4864 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4864 : checkCertificateFast 10 4864 fastCert10_4864=true := by decide +kernel
def fastCert10_4865 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4865 : checkCertificateFast 10 4865 fastCert10_4865=true := by decide +kernel
def fastCert10_4866 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4866 : checkCertificateFast 10 4866 fastCert10_4866=true := by decide +kernel
def fastCert10_4867 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4867 : checkCertificateFast 10 4867 fastCert10_4867=true := by decide +kernel
def fastCert10_4868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4868 : checkCertificateFast 10 4868 fastCert10_4868=true := by decide +kernel
def fastCert10_4869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4869 : checkCertificateFast 10 4869 fastCert10_4869=true := by decide +kernel
def fastCert10_4870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4870 : checkCertificateFast 10 4870 fastCert10_4870=true := by decide +kernel
def fastCert10_4871 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4871 : checkCertificateFast 10 4871 fastCert10_4871=true := by decide +kernel
def fastCert10_4872 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4872 : checkCertificateFast 10 4872 fastCert10_4872=true := by decide +kernel
def fastCert10_4873 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4873 : checkCertificateFast 10 4873 fastCert10_4873=true := by decide +kernel
def fastCert10_4874 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4874 : checkCertificateFast 10 4874 fastCert10_4874=true := by decide +kernel
def fastCert10_4875 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4875 : checkCertificateFast 10 4875 fastCert10_4875=true := by decide +kernel
def fastCert10_4876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4876 : checkCertificateFast 10 4876 fastCert10_4876=true := by decide +kernel
def fastCert10_4877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4877 : checkCertificateFast 10 4877 fastCert10_4877=true := by decide +kernel
def fastCert10_4878 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4878 : checkCertificateFast 10 4878 fastCert10_4878=true := by decide +kernel
def fastCert10_4879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4879 : checkCertificateFast 10 4879 fastCert10_4879=true := by decide +kernel
def fastCert10_4880 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4880 : checkCertificateFast 10 4880 fastCert10_4880=true := by decide +kernel
def fastCert10_4881 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4881 : checkCertificateFast 10 4881 fastCert10_4881=true := by decide +kernel
def fastCert10_4882 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4882 : checkCertificateFast 10 4882 fastCert10_4882=true := by decide +kernel
def fastCert10_4883 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4883 : checkCertificateFast 10 4883 fastCert10_4883=true := by decide +kernel
def fastCert10_4884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4884 : checkCertificateFast 10 4884 fastCert10_4884=true := by decide +kernel
def fastCert10_4885 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4885 : checkCertificateFast 10 4885 fastCert10_4885=true := by decide +kernel
def fastCert10_4886 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4886 : checkCertificateFast 10 4886 fastCert10_4886=true := by decide +kernel
def fastCert10_4887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4887 : checkCertificateFast 10 4887 fastCert10_4887=true := by decide +kernel
def fastCert10_4888 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4888 : checkCertificateFast 10 4888 fastCert10_4888=true := by decide +kernel
def fastCert10_4889 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4889 : checkCertificateFast 10 4889 fastCert10_4889=true := by decide +kernel
def fastCert10_4890 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4890 : checkCertificateFast 10 4890 fastCert10_4890=true := by decide +kernel
def fastCert10_4891 : Certificate := ⟨22,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4891 : checkCertificateFast 10 4891 fastCert10_4891=true := by decide +kernel
def fastCert10_4892 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4892 : checkCertificateFast 10 4892 fastCert10_4892=true := by decide +kernel
def fastCert10_4893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4893 : checkCertificateFast 10 4893 fastCert10_4893=true := by decide +kernel
def fastCert10_4894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4894 : checkCertificateFast 10 4894 fastCert10_4894=true := by decide +kernel
def fastCert10_4895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4895 : checkCertificateFast 10 4895 fastCert10_4895=true := by decide +kernel
def fastCert10_4896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4896 : checkCertificateFast 10 4896 fastCert10_4896=true := by decide +kernel
def fastCert10_4897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4897 : checkCertificateFast 10 4897 fastCert10_4897=true := by decide +kernel
def fastCert10_4898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4898 : checkCertificateFast 10 4898 fastCert10_4898=true := by decide +kernel
def fastCert10_4899 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4899 : checkCertificateFast 10 4899 fastCert10_4899=true := by decide +kernel
def fastCert10_4900 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4900 : checkCertificateFast 10 4900 fastCert10_4900=true := by decide +kernel
def fastCert10_4901 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4901 : checkCertificateFast 10 4901 fastCert10_4901=true := by decide +kernel
def fastCert10_4902 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4902 : checkCertificateFast 10 4902 fastCert10_4902=true := by decide +kernel
def fastCert10_4903 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4903 : checkCertificateFast 10 4903 fastCert10_4903=true := by decide +kernel
def fastCert10_4904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4904 : checkCertificateFast 10 4904 fastCert10_4904=true := by decide +kernel
def fastCert10_4905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4905 : checkCertificateFast 10 4905 fastCert10_4905=true := by decide +kernel
def fastCert10_4906 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4906 : checkCertificateFast 10 4906 fastCert10_4906=true := by decide +kernel
def fastCert10_4907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4907 : checkCertificateFast 10 4907 fastCert10_4907=true := by decide +kernel
def fastCert10_4908 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4908 : checkCertificateFast 10 4908 fastCert10_4908=true := by decide +kernel
def fastCert10_4909 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4909 : checkCertificateFast 10 4909 fastCert10_4909=true := by decide +kernel
def fastCert10_4910 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4910 : checkCertificateFast 10 4910 fastCert10_4910=true := by decide +kernel
def fastCert10_4911 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4911 : checkCertificateFast 10 4911 fastCert10_4911=true := by decide +kernel
def fastCert10_4912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4912 : checkCertificateFast 10 4912 fastCert10_4912=true := by decide +kernel
def fastCert10_4913 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4913 : checkCertificateFast 10 4913 fastCert10_4913=true := by decide +kernel
def fastCert10_4914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4914 : checkCertificateFast 10 4914 fastCert10_4914=true := by decide +kernel
def fastCert10_4915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4915 : checkCertificateFast 10 4915 fastCert10_4915=true := by decide +kernel
def fastCert10_4916 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4916 : checkCertificateFast 10 4916 fastCert10_4916=true := by decide +kernel
def fastCert10_4917 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4917 : checkCertificateFast 10 4917 fastCert10_4917=true := by decide +kernel
def fastCert10_4918 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4918 : checkCertificateFast 10 4918 fastCert10_4918=true := by decide +kernel
def fastCert10_4919 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4919 : checkCertificateFast 10 4919 fastCert10_4919=true := by decide +kernel
def fastCert10_4920 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4920 : checkCertificateFast 10 4920 fastCert10_4920=true := by decide +kernel
def fastCert10_4921 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4921 : checkCertificateFast 10 4921 fastCert10_4921=true := by decide +kernel
def fastCert10_4922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4922 : checkCertificateFast 10 4922 fastCert10_4922=true := by decide +kernel
def fastCert10_4923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4923 : checkCertificateFast 10 4923 fastCert10_4923=true := by decide +kernel
def fastCert10_4924 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4924 : checkCertificateFast 10 4924 fastCert10_4924=true := by decide +kernel
def fastCert10_4925 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4925 : checkCertificateFast 10 4925 fastCert10_4925=true := by decide +kernel
def fastCert10_4926 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4926 : checkCertificateFast 10 4926 fastCert10_4926=true := by decide +kernel
def fastCert10_4927 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_4927 : checkCertificateFast 10 4927 fastCert10_4927=true := by decide +kernel
def fastCert10_4928 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4928 : checkCertificateFast 10 4928 fastCert10_4928=true := by decide +kernel
def fastCert10_4929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4929 : checkCertificateFast 10 4929 fastCert10_4929=true := by decide +kernel
def fastCert10_4930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4930 : checkCertificateFast 10 4930 fastCert10_4930=true := by decide +kernel
def fastCert10_4931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4931 : checkCertificateFast 10 4931 fastCert10_4931=true := by decide +kernel
def fastCert10_4932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4932 : checkCertificateFast 10 4932 fastCert10_4932=true := by decide +kernel
def fastCert10_4933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4933 : checkCertificateFast 10 4933 fastCert10_4933=true := by decide +kernel
def fastCert10_4934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4934 : checkCertificateFast 10 4934 fastCert10_4934=true := by decide +kernel
def fastCert10_4935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4935 : checkCertificateFast 10 4935 fastCert10_4935=true := by decide +kernel
def fastCert10_4936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4936 : checkCertificateFast 10 4936 fastCert10_4936=true := by decide +kernel
def fastCert10_4937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4937 : checkCertificateFast 10 4937 fastCert10_4937=true := by decide +kernel
def fastCert10_4938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4938 : checkCertificateFast 10 4938 fastCert10_4938=true := by decide +kernel
def fastCert10_4939 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_4939 : checkCertificateFast 10 4939 fastCert10_4939=true := by decide +kernel
def fastCert10_4940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4940 : checkCertificateFast 10 4940 fastCert10_4940=true := by decide +kernel
def fastCert10_4941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4941 : checkCertificateFast 10 4941 fastCert10_4941=true := by decide +kernel
def fastCert10_4942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4942 : checkCertificateFast 10 4942 fastCert10_4942=true := by decide +kernel
def fastCert10_4943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4943 : checkCertificateFast 10 4943 fastCert10_4943=true := by decide +kernel
def fastCert10_4944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4944 : checkCertificateFast 10 4944 fastCert10_4944=true := by decide +kernel
def fastCert10_4945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4945 : checkCertificateFast 10 4945 fastCert10_4945=true := by decide +kernel
def fastCert10_4946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4946 : checkCertificateFast 10 4946 fastCert10_4946=true := by decide +kernel
def fastCert10_4947 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_4947 : checkCertificateFast 10 4947 fastCert10_4947=true := by decide +kernel
def fastCert10_4948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4948 : checkCertificateFast 10 4948 fastCert10_4948=true := by decide +kernel
def fastCert10_4949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4949 : checkCertificateFast 10 4949 fastCert10_4949=true := by decide +kernel
def fastCert10_4950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4950 : checkCertificateFast 10 4950 fastCert10_4950=true := by decide +kernel
def fastCert10_4951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4951 : checkCertificateFast 10 4951 fastCert10_4951=true := by decide +kernel
def fastCert10_4952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4952 : checkCertificateFast 10 4952 fastCert10_4952=true := by decide +kernel
def fastCert10_4953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4953 : checkCertificateFast 10 4953 fastCert10_4953=true := by decide +kernel
def fastCert10_4954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_4954 : checkCertificateFast 10 4954 fastCert10_4954=true := by decide +kernel
def fastCert10_4955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_4955 : checkCertificateFast 10 4955 fastCert10_4955=true := by decide +kernel
def fastCert10_4956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4956 : checkCertificateFast 10 4956 fastCert10_4956=true := by decide +kernel
def fastCert10_4957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_4957 : checkCertificateFast 10 4957 fastCert10_4957=true := by decide +kernel
def fastCert10_4958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4958 : checkCertificateFast 10 4958 fastCert10_4958=true := by decide +kernel
def fastCert10_4959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4959 : checkCertificateFast 10 4959 fastCert10_4959=true := by decide +kernel
def fastCert10_4960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4960 : checkCertificateFast 10 4960 fastCert10_4960=true := by decide +kernel
def fastCert10_4961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4961 : checkCertificateFast 10 4961 fastCert10_4961=true := by decide +kernel
def fastCert10_4962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4962 : checkCertificateFast 10 4962 fastCert10_4962=true := by decide +kernel
def fastCert10_4963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4963 : checkCertificateFast 10 4963 fastCert10_4963=true := by decide +kernel
def fastCert10_4964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4964 : checkCertificateFast 10 4964 fastCert10_4964=true := by decide +kernel
def fastCert10_4965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4965 : checkCertificateFast 10 4965 fastCert10_4965=true := by decide +kernel
def fastCert10_4966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4966 : checkCertificateFast 10 4966 fastCert10_4966=true := by decide +kernel
def fastCert10_4967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4967 : checkCertificateFast 10 4967 fastCert10_4967=true := by decide +kernel
def fastCert10_4968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4968 : checkCertificateFast 10 4968 fastCert10_4968=true := by decide +kernel
def fastCert10_4969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4969 : checkCertificateFast 10 4969 fastCert10_4969=true := by decide +kernel
def fastCert10_4970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4970 : checkCertificateFast 10 4970 fastCert10_4970=true := by decide +kernel
def fastCert10_4971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4971 : checkCertificateFast 10 4971 fastCert10_4971=true := by decide +kernel
def fastCert10_4972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4972 : checkCertificateFast 10 4972 fastCert10_4972=true := by decide +kernel
def fastCert10_4973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4973 : checkCertificateFast 10 4973 fastCert10_4973=true := by decide +kernel
def fastCert10_4974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4974 : checkCertificateFast 10 4974 fastCert10_4974=true := by decide +kernel
def fastCert10_4975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4975 : checkCertificateFast 10 4975 fastCert10_4975=true := by decide +kernel
def fastCert10_4976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4976 : checkCertificateFast 10 4976 fastCert10_4976=true := by decide +kernel
def fastCert10_4977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4977 : checkCertificateFast 10 4977 fastCert10_4977=true := by decide +kernel
def fastCert10_4978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4978 : checkCertificateFast 10 4978 fastCert10_4978=true := by decide +kernel
def fastCert10_4979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4979 : checkCertificateFast 10 4979 fastCert10_4979=true := by decide +kernel
def fastCert10_4980 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4980 : checkCertificateFast 10 4980 fastCert10_4980=true := by decide +kernel
def fastCert10_4981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4981 : checkCertificateFast 10 4981 fastCert10_4981=true := by decide +kernel
def fastCert10_4982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4982 : checkCertificateFast 10 4982 fastCert10_4982=true := by decide +kernel
def fastCert10_4983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4983 : checkCertificateFast 10 4983 fastCert10_4983=true := by decide +kernel
def fastCert10_4984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4984 : checkCertificateFast 10 4984 fastCert10_4984=true := by decide +kernel
def fastCert10_4985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4985 : checkCertificateFast 10 4985 fastCert10_4985=true := by decide +kernel
def fastCert10_4986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4986 : checkCertificateFast 10 4986 fastCert10_4986=true := by decide +kernel
def fastCert10_4987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4987 : checkCertificateFast 10 4987 fastCert10_4987=true := by decide +kernel
def fastCert10_4988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4988 : checkCertificateFast 10 4988 fastCert10_4988=true := by decide +kernel
def fastCert10_4989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4989 : checkCertificateFast 10 4989 fastCert10_4989=true := by decide +kernel
def fastCert10_4990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4990 : checkCertificateFast 10 4990 fastCert10_4990=true := by decide +kernel
def fastCert10_4991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4991 : checkCertificateFast 10 4991 fastCert10_4991=true := by decide +kernel
def fastCert10_4992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4992 : checkCertificateFast 10 4992 fastCert10_4992=true := by decide +kernel
def fastCert10_4993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4993 : checkCertificateFast 10 4993 fastCert10_4993=true := by decide +kernel
def fastCert10_4994 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_4994 : checkCertificateFast 10 4994 fastCert10_4994=true := by decide +kernel
def fastCert10_4995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_4995 : checkCertificateFast 10 4995 fastCert10_4995=true := by decide +kernel
def fastCert10_4996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4996 : checkCertificateFast 10 4996 fastCert10_4996=true := by decide +kernel
def fastCert10_4997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4997 : checkCertificateFast 10 4997 fastCert10_4997=true := by decide +kernel
def fastCert10_4998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_4998 : checkCertificateFast 10 4998 fastCert10_4998=true := by decide +kernel
def fastCert10_4999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_4999 : checkCertificateFast 10 4999 fastCert10_4999=true := by decide +kernel
theorem aggregate_F10_004 : (checkCertificateFast 10 4000 fastCert10_4000=true) ∧ (checkCertificateFast 10 4001 fastCert10_4001=true) ∧ (checkCertificateFast 10 4002 fastCert10_4002=true) ∧ (checkCertificateFast 10 4003 fastCert10_4003=true) ∧ (checkCertificateFast 10 4004 fastCert10_4004=true) ∧ (checkCertificateFast 10 4005 fastCert10_4005=true) ∧ (checkCertificateFast 10 4006 fastCert10_4006=true) ∧ (checkCertificateFast 10 4007 fastCert10_4007=true) ∧ (checkCertificateFast 10 4008 fastCert10_4008=true) ∧ (checkCertificateFast 10 4009 fastCert10_4009=true) ∧ (checkCertificateFast 10 4010 fastCert10_4010=true) ∧ (checkCertificateFast 10 4011 fastCert10_4011=true) ∧ (checkCertificateFast 10 4012 fastCert10_4012=true) ∧ (checkCertificateFast 10 4013 fastCert10_4013=true) ∧ (checkCertificateFast 10 4014 fastCert10_4014=true) ∧ (checkCertificateFast 10 4015 fastCert10_4015=true) ∧ (checkCertificateFast 10 4016 fastCert10_4016=true) ∧ (checkCertificateFast 10 4017 fastCert10_4017=true) ∧ (checkCertificateFast 10 4018 fastCert10_4018=true) ∧ (checkCertificateFast 10 4019 fastCert10_4019=true) ∧ (checkCertificateFast 10 4020 fastCert10_4020=true) ∧ (checkCertificateFast 10 4021 fastCert10_4021=true) ∧ (checkCertificateFast 10 4022 fastCert10_4022=true) ∧ (checkCertificateFast 10 4023 fastCert10_4023=true) ∧ (checkCertificateFast 10 4024 fastCert10_4024=true) ∧ (checkCertificateFast 10 4025 fastCert10_4025=true) ∧ (checkCertificateFast 10 4026 fastCert10_4026=true) ∧ (checkCertificateFast 10 4027 fastCert10_4027=true) ∧ (checkCertificateFast 10 4028 fastCert10_4028=true) ∧ (checkCertificateFast 10 4029 fastCert10_4029=true) ∧ (checkCertificateFast 10 4030 fastCert10_4030=true) ∧ (checkCertificateFast 10 4031 fastCert10_4031=true) ∧ (checkCertificateFast 10 4032 fastCert10_4032=true) ∧ (checkCertificateFast 10 4033 fastCert10_4033=true) ∧ (checkCertificateFast 10 4034 fastCert10_4034=true) ∧ (checkCertificateFast 10 4035 fastCert10_4035=true) ∧ (checkCertificateFast 10 4036 fastCert10_4036=true) ∧ (checkCertificateFast 10 4037 fastCert10_4037=true) ∧ (checkCertificateFast 10 4038 fastCert10_4038=true) ∧ (checkCertificateFast 10 4039 fastCert10_4039=true) ∧ (checkCertificateFast 10 4040 fastCert10_4040=true) ∧ (checkCertificateFast 10 4041 fastCert10_4041=true) ∧ (checkCertificateFast 10 4042 fastCert10_4042=true) ∧ (checkCertificateFast 10 4043 fastCert10_4043=true) ∧ (checkCertificateFast 10 4044 fastCert10_4044=true) ∧ (checkCertificateFast 10 4045 fastCert10_4045=true) ∧ (checkCertificateFast 10 4046 fastCert10_4046=true) ∧ (checkCertificateFast 10 4047 fastCert10_4047=true) ∧ (checkCertificateFast 10 4048 fastCert10_4048=true) ∧ (checkCertificateFast 10 4049 fastCert10_4049=true) ∧ (checkCertificateFast 10 4050 fastCert10_4050=true) ∧ (checkCertificateFast 10 4051 fastCert10_4051=true) ∧ (checkCertificateFast 10 4052 fastCert10_4052=true) ∧ (checkCertificateFast 10 4053 fastCert10_4053=true) ∧ (checkCertificateFast 10 4054 fastCert10_4054=true) ∧ (checkCertificateFast 10 4055 fastCert10_4055=true) ∧ (checkCertificateFast 10 4056 fastCert10_4056=true) ∧ (checkCertificateFast 10 4057 fastCert10_4057=true) ∧ (checkCertificateFast 10 4058 fastCert10_4058=true) ∧ (checkCertificateFast 10 4059 fastCert10_4059=true) ∧ (checkCertificateFast 10 4060 fastCert10_4060=true) ∧ (checkCertificateFast 10 4061 fastCert10_4061=true) ∧ (checkCertificateFast 10 4062 fastCert10_4062=true) ∧ (checkCertificateFast 10 4063 fastCert10_4063=true) ∧ (checkCertificateFast 10 4064 fastCert10_4064=true) ∧ (checkCertificateFast 10 4065 fastCert10_4065=true) ∧ (checkCertificateFast 10 4066 fastCert10_4066=true) ∧ (checkCertificateFast 10 4067 fastCert10_4067=true) ∧ (checkCertificateFast 10 4068 fastCert10_4068=true) ∧ (checkCertificateFast 10 4069 fastCert10_4069=true) ∧ (checkCertificateFast 10 4070 fastCert10_4070=true) ∧ (checkCertificateFast 10 4071 fastCert10_4071=true) ∧ (checkCertificateFast 10 4072 fastCert10_4072=true) ∧ (checkCertificateFast 10 4073 fastCert10_4073=true) ∧ (checkCertificateFast 10 4074 fastCert10_4074=true) ∧ (checkCertificateFast 10 4075 fastCert10_4075=true) ∧ (checkCertificateFast 10 4076 fastCert10_4076=true) ∧ (checkCertificateFast 10 4077 fastCert10_4077=true) ∧ (checkCertificateFast 10 4078 fastCert10_4078=true) ∧ (checkCertificateFast 10 4079 fastCert10_4079=true) ∧ (checkCertificateFast 10 4080 fastCert10_4080=true) ∧ (checkCertificateFast 10 4081 fastCert10_4081=true) ∧ (checkCertificateFast 10 4082 fastCert10_4082=true) ∧ (checkCertificateFast 10 4083 fastCert10_4083=true) ∧ (checkCertificateFast 10 4084 fastCert10_4084=true) ∧ (checkCertificateFast 10 4085 fastCert10_4085=true) ∧ (checkCertificateFast 10 4086 fastCert10_4086=true) ∧ (checkCertificateFast 10 4087 fastCert10_4087=true) ∧ (checkCertificateFast 10 4088 fastCert10_4088=true) ∧ (checkCertificateFast 10 4089 fastCert10_4089=true) ∧ (checkCertificateFast 10 4090 fastCert10_4090=true) ∧ (checkCertificateFast 10 4091 fastCert10_4091=true) ∧ (checkCertificateFast 10 4092 fastCert10_4092=true) ∧ (checkCertificateFast 10 4093 fastCert10_4093=true) ∧ (checkCertificateFast 10 4094 fastCert10_4094=true) ∧ (checkCertificateFast 10 4095 fastCert10_4095=true) ∧ (checkCertificateFast 10 4096 fastCert10_4096=true) ∧ (checkCertificateFast 10 4097 fastCert10_4097=true) ∧ (checkCertificateFast 10 4098 fastCert10_4098=true) ∧ (checkCertificateFast 10 4099 fastCert10_4099=true) ∧ (checkCertificateFast 10 4100 fastCert10_4100=true) ∧ (checkCertificateFast 10 4101 fastCert10_4101=true) ∧ (checkCertificateFast 10 4102 fastCert10_4102=true) ∧ (checkCertificateFast 10 4103 fastCert10_4103=true) ∧ (checkCertificateFast 10 4104 fastCert10_4104=true) ∧ (checkCertificateFast 10 4105 fastCert10_4105=true) ∧ (checkCertificateFast 10 4106 fastCert10_4106=true) ∧ (checkCertificateFast 10 4107 fastCert10_4107=true) ∧ (checkCertificateFast 10 4108 fastCert10_4108=true) ∧ (checkCertificateFast 10 4109 fastCert10_4109=true) ∧ (checkCertificateFast 10 4110 fastCert10_4110=true) ∧ (checkCertificateFast 10 4111 fastCert10_4111=true) ∧ (checkCertificateFast 10 4112 fastCert10_4112=true) ∧ (checkCertificateFast 10 4113 fastCert10_4113=true) ∧ (checkCertificateFast 10 4114 fastCert10_4114=true) ∧ (checkCertificateFast 10 4115 fastCert10_4115=true) ∧ (checkCertificateFast 10 4116 fastCert10_4116=true) ∧ (checkCertificateFast 10 4117 fastCert10_4117=true) ∧ (checkCertificateFast 10 4118 fastCert10_4118=true) ∧ (checkCertificateFast 10 4119 fastCert10_4119=true) ∧ (checkCertificateFast 10 4120 fastCert10_4120=true) ∧ (checkCertificateFast 10 4121 fastCert10_4121=true) ∧ (checkCertificateFast 10 4122 fastCert10_4122=true) ∧ (checkCertificateFast 10 4123 fastCert10_4123=true) ∧ (checkCertificateFast 10 4124 fastCert10_4124=true) ∧ (checkCertificateFast 10 4125 fastCert10_4125=true) ∧ (checkCertificateFast 10 4126 fastCert10_4126=true) ∧ (checkCertificateFast 10 4127 fastCert10_4127=true) ∧ (checkCertificateFast 10 4128 fastCert10_4128=true) ∧ (checkCertificateFast 10 4129 fastCert10_4129=true) ∧ (checkCertificateFast 10 4130 fastCert10_4130=true) ∧ (checkCertificateFast 10 4131 fastCert10_4131=true) ∧ (checkCertificateFast 10 4132 fastCert10_4132=true) ∧ (checkCertificateFast 10 4133 fastCert10_4133=true) ∧ (checkCertificateFast 10 4134 fastCert10_4134=true) ∧ (checkCertificateFast 10 4135 fastCert10_4135=true) ∧ (checkCertificateFast 10 4136 fastCert10_4136=true) ∧ (checkCertificateFast 10 4137 fastCert10_4137=true) ∧ (checkCertificateFast 10 4138 fastCert10_4138=true) ∧ (checkCertificateFast 10 4139 fastCert10_4139=true) ∧ (checkCertificateFast 10 4140 fastCert10_4140=true) ∧ (checkCertificateFast 10 4141 fastCert10_4141=true) ∧ (checkCertificateFast 10 4142 fastCert10_4142=true) ∧ (checkCertificateFast 10 4143 fastCert10_4143=true) ∧ (checkCertificateFast 10 4144 fastCert10_4144=true) ∧ (checkCertificateFast 10 4145 fastCert10_4145=true) ∧ (checkCertificateFast 10 4146 fastCert10_4146=true) ∧ (checkCertificateFast 10 4147 fastCert10_4147=true) ∧ (checkCertificateFast 10 4148 fastCert10_4148=true) ∧ (checkCertificateFast 10 4149 fastCert10_4149=true) ∧ (checkCertificateFast 10 4150 fastCert10_4150=true) ∧ (checkCertificateFast 10 4151 fastCert10_4151=true) ∧ (checkCertificateFast 10 4152 fastCert10_4152=true) ∧ (checkCertificateFast 10 4153 fastCert10_4153=true) ∧ (checkCertificateFast 10 4154 fastCert10_4154=true) ∧ (checkCertificateFast 10 4155 fastCert10_4155=true) ∧ (checkCertificateFast 10 4156 fastCert10_4156=true) ∧ (checkCertificateFast 10 4157 fastCert10_4157=true) ∧ (checkCertificateFast 10 4158 fastCert10_4158=true) ∧ (checkCertificateFast 10 4159 fastCert10_4159=true) ∧ (checkCertificateFast 10 4160 fastCert10_4160=true) ∧ (checkCertificateFast 10 4161 fastCert10_4161=true) ∧ (checkCertificateFast 10 4162 fastCert10_4162=true) ∧ (checkCertificateFast 10 4163 fastCert10_4163=true) ∧ (checkCertificateFast 10 4164 fastCert10_4164=true) ∧ (checkCertificateFast 10 4165 fastCert10_4165=true) ∧ (checkCertificateFast 10 4166 fastCert10_4166=true) ∧ (checkCertificateFast 10 4167 fastCert10_4167=true) ∧ (checkCertificateFast 10 4168 fastCert10_4168=true) ∧ (checkCertificateFast 10 4169 fastCert10_4169=true) ∧ (checkCertificateFast 10 4170 fastCert10_4170=true) ∧ (checkCertificateFast 10 4171 fastCert10_4171=true) ∧ (checkCertificateFast 10 4172 fastCert10_4172=true) ∧ (checkCertificateFast 10 4173 fastCert10_4173=true) ∧ (checkCertificateFast 10 4174 fastCert10_4174=true) ∧ (checkCertificateFast 10 4175 fastCert10_4175=true) ∧ (checkCertificateFast 10 4176 fastCert10_4176=true) ∧ (checkCertificateFast 10 4177 fastCert10_4177=true) ∧ (checkCertificateFast 10 4178 fastCert10_4178=true) ∧ (checkCertificateFast 10 4179 fastCert10_4179=true) ∧ (checkCertificateFast 10 4180 fastCert10_4180=true) ∧ (checkCertificateFast 10 4181 fastCert10_4181=true) ∧ (checkCertificateFast 10 4182 fastCert10_4182=true) ∧ (checkCertificateFast 10 4183 fastCert10_4183=true) ∧ (checkCertificateFast 10 4184 fastCert10_4184=true) ∧ (checkCertificateFast 10 4185 fastCert10_4185=true) ∧ (checkCertificateFast 10 4186 fastCert10_4186=true) ∧ (checkCertificateFast 10 4187 fastCert10_4187=true) ∧ (checkCertificateFast 10 4188 fastCert10_4188=true) ∧ (checkCertificateFast 10 4189 fastCert10_4189=true) ∧ (checkCertificateFast 10 4190 fastCert10_4190=true) ∧ (checkCertificateFast 10 4191 fastCert10_4191=true) ∧ (checkCertificateFast 10 4192 fastCert10_4192=true) ∧ (checkCertificateFast 10 4193 fastCert10_4193=true) ∧ (checkCertificateFast 10 4194 fastCert10_4194=true) ∧ (checkCertificateFast 10 4195 fastCert10_4195=true) ∧ (checkCertificateFast 10 4196 fastCert10_4196=true) ∧ (checkCertificateFast 10 4197 fastCert10_4197=true) ∧ (checkCertificateFast 10 4198 fastCert10_4198=true) ∧ (checkCertificateFast 10 4199 fastCert10_4199=true) ∧ (checkCertificateFast 10 4200 fastCert10_4200=true) ∧ (checkCertificateFast 10 4201 fastCert10_4201=true) ∧ (checkCertificateFast 10 4202 fastCert10_4202=true) ∧ (checkCertificateFast 10 4203 fastCert10_4203=true) ∧ (checkCertificateFast 10 4204 fastCert10_4204=true) ∧ (checkCertificateFast 10 4205 fastCert10_4205=true) ∧ (checkCertificateFast 10 4206 fastCert10_4206=true) ∧ (checkCertificateFast 10 4207 fastCert10_4207=true) ∧ (checkCertificateFast 10 4208 fastCert10_4208=true) ∧ (checkCertificateFast 10 4209 fastCert10_4209=true) ∧ (checkCertificateFast 10 4210 fastCert10_4210=true) ∧ (checkCertificateFast 10 4211 fastCert10_4211=true) ∧ (checkCertificateFast 10 4212 fastCert10_4212=true) ∧ (checkCertificateFast 10 4213 fastCert10_4213=true) ∧ (checkCertificateFast 10 4214 fastCert10_4214=true) ∧ (checkCertificateFast 10 4215 fastCert10_4215=true) ∧ (checkCertificateFast 10 4216 fastCert10_4216=true) ∧ (checkCertificateFast 10 4217 fastCert10_4217=true) ∧ (checkCertificateFast 10 4218 fastCert10_4218=true) ∧ (checkCertificateFast 10 4219 fastCert10_4219=true) ∧ (checkCertificateFast 10 4220 fastCert10_4220=true) ∧ (checkCertificateFast 10 4221 fastCert10_4221=true) ∧ (checkCertificateFast 10 4222 fastCert10_4222=true) ∧ (checkCertificateFast 10 4223 fastCert10_4223=true) ∧ (checkCertificateFast 10 4224 fastCert10_4224=true) ∧ (checkCertificateFast 10 4225 fastCert10_4225=true) ∧ (checkCertificateFast 10 4226 fastCert10_4226=true) ∧ (checkCertificateFast 10 4227 fastCert10_4227=true) ∧ (checkCertificateFast 10 4228 fastCert10_4228=true) ∧ (checkCertificateFast 10 4229 fastCert10_4229=true) ∧ (checkCertificateFast 10 4230 fastCert10_4230=true) ∧ (checkCertificateFast 10 4231 fastCert10_4231=true) ∧ (checkCertificateFast 10 4232 fastCert10_4232=true) ∧ (checkCertificateFast 10 4233 fastCert10_4233=true) ∧ (checkCertificateFast 10 4234 fastCert10_4234=true) ∧ (checkCertificateFast 10 4235 fastCert10_4235=true) ∧ (checkCertificateFast 10 4236 fastCert10_4236=true) ∧ (checkCertificateFast 10 4237 fastCert10_4237=true) ∧ (checkCertificateFast 10 4238 fastCert10_4238=true) ∧ (checkCertificateFast 10 4239 fastCert10_4239=true) ∧ (checkCertificateFast 10 4240 fastCert10_4240=true) ∧ (checkCertificateFast 10 4241 fastCert10_4241=true) ∧ (checkCertificateFast 10 4242 fastCert10_4242=true) ∧ (checkCertificateFast 10 4243 fastCert10_4243=true) ∧ (checkCertificateFast 10 4244 fastCert10_4244=true) ∧ (checkCertificateFast 10 4245 fastCert10_4245=true) ∧ (checkCertificateFast 10 4246 fastCert10_4246=true) ∧ (checkCertificateFast 10 4247 fastCert10_4247=true) ∧ (checkCertificateFast 10 4248 fastCert10_4248=true) ∧ (checkCertificateFast 10 4249 fastCert10_4249=true) ∧ (checkCertificateFast 10 4250 fastCert10_4250=true) ∧ (checkCertificateFast 10 4251 fastCert10_4251=true) ∧ (checkCertificateFast 10 4252 fastCert10_4252=true) ∧ (checkCertificateFast 10 4253 fastCert10_4253=true) ∧ (checkCertificateFast 10 4254 fastCert10_4254=true) ∧ (checkCertificateFast 10 4255 fastCert10_4255=true) ∧ (checkCertificateFast 10 4256 fastCert10_4256=true) ∧ (checkCertificateFast 10 4257 fastCert10_4257=true) ∧ (checkCertificateFast 10 4258 fastCert10_4258=true) ∧ (checkCertificateFast 10 4259 fastCert10_4259=true) ∧ (checkCertificateFast 10 4260 fastCert10_4260=true) ∧ (checkCertificateFast 10 4261 fastCert10_4261=true) ∧ (checkCertificateFast 10 4262 fastCert10_4262=true) ∧ (checkCertificateFast 10 4263 fastCert10_4263=true) ∧ (checkCertificateFast 10 4264 fastCert10_4264=true) ∧ (checkCertificateFast 10 4265 fastCert10_4265=true) ∧ (checkCertificateFast 10 4266 fastCert10_4266=true) ∧ (checkCertificateFast 10 4267 fastCert10_4267=true) ∧ (checkCertificateFast 10 4268 fastCert10_4268=true) ∧ (checkCertificateFast 10 4269 fastCert10_4269=true) ∧ (checkCertificateFast 10 4270 fastCert10_4270=true) ∧ (checkCertificateFast 10 4271 fastCert10_4271=true) ∧ (checkCertificateFast 10 4272 fastCert10_4272=true) ∧ (checkCertificateFast 10 4273 fastCert10_4273=true) ∧ (checkCertificateFast 10 4274 fastCert10_4274=true) ∧ (checkCertificateFast 10 4275 fastCert10_4275=true) ∧ (checkCertificateFast 10 4276 fastCert10_4276=true) ∧ (checkCertificateFast 10 4277 fastCert10_4277=true) ∧ (checkCertificateFast 10 4278 fastCert10_4278=true) ∧ (checkCertificateFast 10 4279 fastCert10_4279=true) ∧ (checkCertificateFast 10 4280 fastCert10_4280=true) ∧ (checkCertificateFast 10 4281 fastCert10_4281=true) ∧ (checkCertificateFast 10 4282 fastCert10_4282=true) ∧ (checkCertificateFast 10 4283 fastCert10_4283=true) ∧ (checkCertificateFast 10 4284 fastCert10_4284=true) ∧ (checkCertificateFast 10 4285 fastCert10_4285=true) ∧ (checkCertificateFast 10 4286 fastCert10_4286=true) ∧ (checkCertificateFast 10 4287 fastCert10_4287=true) ∧ (checkCertificateFast 10 4288 fastCert10_4288=true) ∧ (checkCertificateFast 10 4289 fastCert10_4289=true) ∧ (checkCertificateFast 10 4290 fastCert10_4290=true) ∧ (checkCertificateFast 10 4291 fastCert10_4291=true) ∧ (checkCertificateFast 10 4292 fastCert10_4292=true) ∧ (checkCertificateFast 10 4293 fastCert10_4293=true) ∧ (checkCertificateFast 10 4294 fastCert10_4294=true) ∧ (checkCertificateFast 10 4295 fastCert10_4295=true) ∧ (checkCertificateFast 10 4296 fastCert10_4296=true) ∧ (checkCertificateFast 10 4297 fastCert10_4297=true) ∧ (checkCertificateFast 10 4298 fastCert10_4298=true) ∧ (checkCertificateFast 10 4299 fastCert10_4299=true) ∧ (checkCertificateFast 10 4300 fastCert10_4300=true) ∧ (checkCertificateFast 10 4301 fastCert10_4301=true) ∧ (checkCertificateFast 10 4302 fastCert10_4302=true) ∧ (checkCertificateFast 10 4303 fastCert10_4303=true) ∧ (checkCertificateFast 10 4304 fastCert10_4304=true) ∧ (checkCertificateFast 10 4305 fastCert10_4305=true) ∧ (checkCertificateFast 10 4306 fastCert10_4306=true) ∧ (checkCertificateFast 10 4307 fastCert10_4307=true) ∧ (checkCertificateFast 10 4308 fastCert10_4308=true) ∧ (checkCertificateFast 10 4309 fastCert10_4309=true) ∧ (checkCertificateFast 10 4310 fastCert10_4310=true) ∧ (checkCertificateFast 10 4311 fastCert10_4311=true) ∧ (checkCertificateFast 10 4312 fastCert10_4312=true) ∧ (checkCertificateFast 10 4313 fastCert10_4313=true) ∧ (checkCertificateFast 10 4314 fastCert10_4314=true) ∧ (checkCertificateFast 10 4315 fastCert10_4315=true) ∧ (checkCertificateFast 10 4316 fastCert10_4316=true) ∧ (checkCertificateFast 10 4317 fastCert10_4317=true) ∧ (checkCertificateFast 10 4318 fastCert10_4318=true) ∧ (checkCertificateFast 10 4319 fastCert10_4319=true) ∧ (checkCertificateFast 10 4320 fastCert10_4320=true) ∧ (checkCertificateFast 10 4321 fastCert10_4321=true) ∧ (checkCertificateFast 10 4322 fastCert10_4322=true) ∧ (checkCertificateFast 10 4323 fastCert10_4323=true) ∧ (checkCertificateFast 10 4324 fastCert10_4324=true) ∧ (checkCertificateFast 10 4325 fastCert10_4325=true) ∧ (checkCertificateFast 10 4326 fastCert10_4326=true) ∧ (checkCertificateFast 10 4327 fastCert10_4327=true) ∧ (checkCertificateFast 10 4328 fastCert10_4328=true) ∧ (checkCertificateFast 10 4329 fastCert10_4329=true) ∧ (checkCertificateFast 10 4330 fastCert10_4330=true) ∧ (checkCertificateFast 10 4331 fastCert10_4331=true) ∧ (checkCertificateFast 10 4332 fastCert10_4332=true) ∧ (checkCertificateFast 10 4333 fastCert10_4333=true) ∧ (checkCertificateFast 10 4334 fastCert10_4334=true) ∧ (checkCertificateFast 10 4335 fastCert10_4335=true) ∧ (checkCertificateFast 10 4336 fastCert10_4336=true) ∧ (checkCertificateFast 10 4337 fastCert10_4337=true) ∧ (checkCertificateFast 10 4338 fastCert10_4338=true) ∧ (checkCertificateFast 10 4339 fastCert10_4339=true) ∧ (checkCertificateFast 10 4340 fastCert10_4340=true) ∧ (checkCertificateFast 10 4341 fastCert10_4341=true) ∧ (checkCertificateFast 10 4342 fastCert10_4342=true) ∧ (checkCertificateFast 10 4343 fastCert10_4343=true) ∧ (checkCertificateFast 10 4344 fastCert10_4344=true) ∧ (checkCertificateFast 10 4345 fastCert10_4345=true) ∧ (checkCertificateFast 10 4346 fastCert10_4346=true) ∧ (checkCertificateFast 10 4347 fastCert10_4347=true) ∧ (checkCertificateFast 10 4348 fastCert10_4348=true) ∧ (checkCertificateFast 10 4349 fastCert10_4349=true) ∧ (checkCertificateFast 10 4350 fastCert10_4350=true) ∧ (checkCertificateFast 10 4351 fastCert10_4351=true) ∧ (checkCertificateFast 10 4352 fastCert10_4352=true) ∧ (checkCertificateFast 10 4353 fastCert10_4353=true) ∧ (checkCertificateFast 10 4354 fastCert10_4354=true) ∧ (checkCertificateFast 10 4355 fastCert10_4355=true) ∧ (checkCertificateFast 10 4356 fastCert10_4356=true) ∧ (checkCertificateFast 10 4357 fastCert10_4357=true) ∧ (checkCertificateFast 10 4358 fastCert10_4358=true) ∧ (checkCertificateFast 10 4359 fastCert10_4359=true) ∧ (checkCertificateFast 10 4360 fastCert10_4360=true) ∧ (checkCertificateFast 10 4361 fastCert10_4361=true) ∧ (checkCertificateFast 10 4362 fastCert10_4362=true) ∧ (checkCertificateFast 10 4363 fastCert10_4363=true) ∧ (checkCertificateFast 10 4364 fastCert10_4364=true) ∧ (checkCertificateFast 10 4365 fastCert10_4365=true) ∧ (checkCertificateFast 10 4366 fastCert10_4366=true) ∧ (checkCertificateFast 10 4367 fastCert10_4367=true) ∧ (checkCertificateFast 10 4368 fastCert10_4368=true) ∧ (checkCertificateFast 10 4369 fastCert10_4369=true) ∧ (checkCertificateFast 10 4370 fastCert10_4370=true) ∧ (checkCertificateFast 10 4371 fastCert10_4371=true) ∧ (checkCertificateFast 10 4372 fastCert10_4372=true) ∧ (checkCertificateFast 10 4373 fastCert10_4373=true) ∧ (checkCertificateFast 10 4374 fastCert10_4374=true) ∧ (checkCertificateFast 10 4375 fastCert10_4375=true) ∧ (checkCertificateFast 10 4376 fastCert10_4376=true) ∧ (checkCertificateFast 10 4377 fastCert10_4377=true) ∧ (checkCertificateFast 10 4378 fastCert10_4378=true) ∧ (checkCertificateFast 10 4379 fastCert10_4379=true) ∧ (checkCertificateFast 10 4380 fastCert10_4380=true) ∧ (checkCertificateFast 10 4381 fastCert10_4381=true) ∧ (checkCertificateFast 10 4382 fastCert10_4382=true) ∧ (checkCertificateFast 10 4383 fastCert10_4383=true) ∧ (checkCertificateFast 10 4384 fastCert10_4384=true) ∧ (checkCertificateFast 10 4385 fastCert10_4385=true) ∧ (checkCertificateFast 10 4386 fastCert10_4386=true) ∧ (checkCertificateFast 10 4387 fastCert10_4387=true) ∧ (checkCertificateFast 10 4388 fastCert10_4388=true) ∧ (checkCertificateFast 10 4389 fastCert10_4389=true) ∧ (checkCertificateFast 10 4390 fastCert10_4390=true) ∧ (checkCertificateFast 10 4391 fastCert10_4391=true) ∧ (checkCertificateFast 10 4392 fastCert10_4392=true) ∧ (checkCertificateFast 10 4393 fastCert10_4393=true) ∧ (checkCertificateFast 10 4394 fastCert10_4394=true) ∧ (checkCertificateFast 10 4395 fastCert10_4395=true) ∧ (checkCertificateFast 10 4396 fastCert10_4396=true) ∧ (checkCertificateFast 10 4397 fastCert10_4397=true) ∧ (checkCertificateFast 10 4398 fastCert10_4398=true) ∧ (checkCertificateFast 10 4399 fastCert10_4399=true) ∧ (checkCertificateFast 10 4400 fastCert10_4400=true) ∧ (checkCertificateFast 10 4401 fastCert10_4401=true) ∧ (checkCertificateFast 10 4402 fastCert10_4402=true) ∧ (checkCertificateFast 10 4403 fastCert10_4403=true) ∧ (checkCertificateFast 10 4404 fastCert10_4404=true) ∧ (checkCertificateFast 10 4405 fastCert10_4405=true) ∧ (checkCertificateFast 10 4406 fastCert10_4406=true) ∧ (checkCertificateFast 10 4407 fastCert10_4407=true) ∧ (checkCertificateFast 10 4408 fastCert10_4408=true) ∧ (checkCertificateFast 10 4409 fastCert10_4409=true) ∧ (checkCertificateFast 10 4410 fastCert10_4410=true) ∧ (checkCertificateFast 10 4411 fastCert10_4411=true) ∧ (checkCertificateFast 10 4412 fastCert10_4412=true) ∧ (checkCertificateFast 10 4413 fastCert10_4413=true) ∧ (checkCertificateFast 10 4414 fastCert10_4414=true) ∧ (checkCertificateFast 10 4415 fastCert10_4415=true) ∧ (checkCertificateFast 10 4416 fastCert10_4416=true) ∧ (checkCertificateFast 10 4417 fastCert10_4417=true) ∧ (checkCertificateFast 10 4418 fastCert10_4418=true) ∧ (checkCertificateFast 10 4419 fastCert10_4419=true) ∧ (checkCertificateFast 10 4420 fastCert10_4420=true) ∧ (checkCertificateFast 10 4421 fastCert10_4421=true) ∧ (checkCertificateFast 10 4422 fastCert10_4422=true) ∧ (checkCertificateFast 10 4423 fastCert10_4423=true) ∧ (checkCertificateFast 10 4424 fastCert10_4424=true) ∧ (checkCertificateFast 10 4425 fastCert10_4425=true) ∧ (checkCertificateFast 10 4426 fastCert10_4426=true) ∧ (checkCertificateFast 10 4427 fastCert10_4427=true) ∧ (checkCertificateFast 10 4428 fastCert10_4428=true) ∧ (checkCertificateFast 10 4429 fastCert10_4429=true) ∧ (checkCertificateFast 10 4430 fastCert10_4430=true) ∧ (checkCertificateFast 10 4431 fastCert10_4431=true) ∧ (checkCertificateFast 10 4432 fastCert10_4432=true) ∧ (checkCertificateFast 10 4433 fastCert10_4433=true) ∧ (checkCertificateFast 10 4434 fastCert10_4434=true) ∧ (checkCertificateFast 10 4435 fastCert10_4435=true) ∧ (checkCertificateFast 10 4436 fastCert10_4436=true) ∧ (checkCertificateFast 10 4437 fastCert10_4437=true) ∧ (checkCertificateFast 10 4438 fastCert10_4438=true) ∧ (checkCertificateFast 10 4439 fastCert10_4439=true) ∧ (checkCertificateFast 10 4440 fastCert10_4440=true) ∧ (checkCertificateFast 10 4441 fastCert10_4441=true) ∧ (checkCertificateFast 10 4442 fastCert10_4442=true) ∧ (checkCertificateFast 10 4443 fastCert10_4443=true) ∧ (checkCertificateFast 10 4444 fastCert10_4444=true) ∧ (checkCertificateFast 10 4445 fastCert10_4445=true) ∧ (checkCertificateFast 10 4446 fastCert10_4446=true) ∧ (checkCertificateFast 10 4447 fastCert10_4447=true) ∧ (checkCertificateFast 10 4448 fastCert10_4448=true) ∧ (checkCertificateFast 10 4449 fastCert10_4449=true) ∧ (checkCertificateFast 10 4450 fastCert10_4450=true) ∧ (checkCertificateFast 10 4451 fastCert10_4451=true) ∧ (checkCertificateFast 10 4452 fastCert10_4452=true) ∧ (checkCertificateFast 10 4453 fastCert10_4453=true) ∧ (checkCertificateFast 10 4454 fastCert10_4454=true) ∧ (checkCertificateFast 10 4455 fastCert10_4455=true) ∧ (checkCertificateFast 10 4456 fastCert10_4456=true) ∧ (checkCertificateFast 10 4457 fastCert10_4457=true) ∧ (checkCertificateFast 10 4458 fastCert10_4458=true) ∧ (checkCertificateFast 10 4459 fastCert10_4459=true) ∧ (checkCertificateFast 10 4460 fastCert10_4460=true) ∧ (checkCertificateFast 10 4461 fastCert10_4461=true) ∧ (checkCertificateFast 10 4462 fastCert10_4462=true) ∧ (checkCertificateFast 10 4463 fastCert10_4463=true) ∧ (checkCertificateFast 10 4464 fastCert10_4464=true) ∧ (checkCertificateFast 10 4465 fastCert10_4465=true) ∧ (checkCertificateFast 10 4466 fastCert10_4466=true) ∧ (checkCertificateFast 10 4467 fastCert10_4467=true) ∧ (checkCertificateFast 10 4468 fastCert10_4468=true) ∧ (checkCertificateFast 10 4469 fastCert10_4469=true) ∧ (checkCertificateFast 10 4470 fastCert10_4470=true) ∧ (checkCertificateFast 10 4471 fastCert10_4471=true) ∧ (checkCertificateFast 10 4472 fastCert10_4472=true) ∧ (checkCertificateFast 10 4473 fastCert10_4473=true) ∧ (checkCertificateFast 10 4474 fastCert10_4474=true) ∧ (checkCertificateFast 10 4475 fastCert10_4475=true) ∧ (checkCertificateFast 10 4476 fastCert10_4476=true) ∧ (checkCertificateFast 10 4477 fastCert10_4477=true) ∧ (checkCertificateFast 10 4478 fastCert10_4478=true) ∧ (checkCertificateFast 10 4479 fastCert10_4479=true) ∧ (checkCertificateFast 10 4480 fastCert10_4480=true) ∧ (checkCertificateFast 10 4481 fastCert10_4481=true) ∧ (checkCertificateFast 10 4482 fastCert10_4482=true) ∧ (checkCertificateFast 10 4483 fastCert10_4483=true) ∧ (checkCertificateFast 10 4484 fastCert10_4484=true) ∧ (checkCertificateFast 10 4485 fastCert10_4485=true) ∧ (checkCertificateFast 10 4486 fastCert10_4486=true) ∧ (checkCertificateFast 10 4487 fastCert10_4487=true) ∧ (checkCertificateFast 10 4488 fastCert10_4488=true) ∧ (checkCertificateFast 10 4489 fastCert10_4489=true) ∧ (checkCertificateFast 10 4490 fastCert10_4490=true) ∧ (checkCertificateFast 10 4491 fastCert10_4491=true) ∧ (checkCertificateFast 10 4492 fastCert10_4492=true) ∧ (checkCertificateFast 10 4493 fastCert10_4493=true) ∧ (checkCertificateFast 10 4494 fastCert10_4494=true) ∧ (checkCertificateFast 10 4495 fastCert10_4495=true) ∧ (checkCertificateFast 10 4496 fastCert10_4496=true) ∧ (checkCertificateFast 10 4497 fastCert10_4497=true) ∧ (checkCertificateFast 10 4498 fastCert10_4498=true) ∧ (checkCertificateFast 10 4499 fastCert10_4499=true) ∧ (checkCertificateFast 10 4500 fastCert10_4500=true) ∧ (checkCertificateFast 10 4501 fastCert10_4501=true) ∧ (checkCertificateFast 10 4502 fastCert10_4502=true) ∧ (checkCertificateFast 10 4503 fastCert10_4503=true) ∧ (checkCertificateFast 10 4504 fastCert10_4504=true) ∧ (checkCertificateFast 10 4505 fastCert10_4505=true) ∧ (checkCertificateFast 10 4506 fastCert10_4506=true) ∧ (checkCertificateFast 10 4507 fastCert10_4507=true) ∧ (checkCertificateFast 10 4508 fastCert10_4508=true) ∧ (checkCertificateFast 10 4509 fastCert10_4509=true) ∧ (checkCertificateFast 10 4510 fastCert10_4510=true) ∧ (checkCertificateFast 10 4511 fastCert10_4511=true) ∧ (checkCertificateFast 10 4512 fastCert10_4512=true) ∧ (checkCertificateFast 10 4513 fastCert10_4513=true) ∧ (checkCertificateFast 10 4514 fastCert10_4514=true) ∧ (checkCertificateFast 10 4515 fastCert10_4515=true) ∧ (checkCertificateFast 10 4516 fastCert10_4516=true) ∧ (checkCertificateFast 10 4517 fastCert10_4517=true) ∧ (checkCertificateFast 10 4518 fastCert10_4518=true) ∧ (checkCertificateFast 10 4519 fastCert10_4519=true) ∧ (checkCertificateFast 10 4520 fastCert10_4520=true) ∧ (checkCertificateFast 10 4521 fastCert10_4521=true) ∧ (checkCertificateFast 10 4522 fastCert10_4522=true) ∧ (checkCertificateFast 10 4523 fastCert10_4523=true) ∧ (checkCertificateFast 10 4524 fastCert10_4524=true) ∧ (checkCertificateFast 10 4525 fastCert10_4525=true) ∧ (checkCertificateFast 10 4526 fastCert10_4526=true) ∧ (checkCertificateFast 10 4527 fastCert10_4527=true) ∧ (checkCertificateFast 10 4528 fastCert10_4528=true) ∧ (checkCertificateFast 10 4529 fastCert10_4529=true) ∧ (checkCertificateFast 10 4530 fastCert10_4530=true) ∧ (checkCertificateFast 10 4531 fastCert10_4531=true) ∧ (checkCertificateFast 10 4532 fastCert10_4532=true) ∧ (checkCertificateFast 10 4533 fastCert10_4533=true) ∧ (checkCertificateFast 10 4534 fastCert10_4534=true) ∧ (checkCertificateFast 10 4535 fastCert10_4535=true) ∧ (checkCertificateFast 10 4536 fastCert10_4536=true) ∧ (checkCertificateFast 10 4537 fastCert10_4537=true) ∧ (checkCertificateFast 10 4538 fastCert10_4538=true) ∧ (checkCertificateFast 10 4539 fastCert10_4539=true) ∧ (checkCertificateFast 10 4540 fastCert10_4540=true) ∧ (checkCertificateFast 10 4541 fastCert10_4541=true) ∧ (checkCertificateFast 10 4542 fastCert10_4542=true) ∧ (checkCertificateFast 10 4543 fastCert10_4543=true) ∧ (checkCertificateFast 10 4544 fastCert10_4544=true) ∧ (checkCertificateFast 10 4545 fastCert10_4545=true) ∧ (checkCertificateFast 10 4546 fastCert10_4546=true) ∧ (checkCertificateFast 10 4547 fastCert10_4547=true) ∧ (checkCertificateFast 10 4548 fastCert10_4548=true) ∧ (checkCertificateFast 10 4549 fastCert10_4549=true) ∧ (checkCertificateFast 10 4550 fastCert10_4550=true) ∧ (checkCertificateFast 10 4551 fastCert10_4551=true) ∧ (checkCertificateFast 10 4552 fastCert10_4552=true) ∧ (checkCertificateFast 10 4553 fastCert10_4553=true) ∧ (checkCertificateFast 10 4554 fastCert10_4554=true) ∧ (checkCertificateFast 10 4555 fastCert10_4555=true) ∧ (checkCertificateFast 10 4556 fastCert10_4556=true) ∧ (checkCertificateFast 10 4557 fastCert10_4557=true) ∧ (checkCertificateFast 10 4558 fastCert10_4558=true) ∧ (checkCertificateFast 10 4559 fastCert10_4559=true) ∧ (checkCertificateFast 10 4560 fastCert10_4560=true) ∧ (checkCertificateFast 10 4561 fastCert10_4561=true) ∧ (checkCertificateFast 10 4562 fastCert10_4562=true) ∧ (checkCertificateFast 10 4563 fastCert10_4563=true) ∧ (checkCertificateFast 10 4564 fastCert10_4564=true) ∧ (checkCertificateFast 10 4565 fastCert10_4565=true) ∧ (checkCertificateFast 10 4566 fastCert10_4566=true) ∧ (checkCertificateFast 10 4567 fastCert10_4567=true) ∧ (checkCertificateFast 10 4568 fastCert10_4568=true) ∧ (checkCertificateFast 10 4569 fastCert10_4569=true) ∧ (checkCertificateFast 10 4570 fastCert10_4570=true) ∧ (checkCertificateFast 10 4571 fastCert10_4571=true) ∧ (checkCertificateFast 10 4572 fastCert10_4572=true) ∧ (checkCertificateFast 10 4573 fastCert10_4573=true) ∧ (checkCertificateFast 10 4574 fastCert10_4574=true) ∧ (checkCertificateFast 10 4575 fastCert10_4575=true) ∧ (checkCertificateFast 10 4576 fastCert10_4576=true) ∧ (checkCertificateFast 10 4577 fastCert10_4577=true) ∧ (checkCertificateFast 10 4578 fastCert10_4578=true) ∧ (checkCertificateFast 10 4579 fastCert10_4579=true) ∧ (checkCertificateFast 10 4580 fastCert10_4580=true) ∧ (checkCertificateFast 10 4581 fastCert10_4581=true) ∧ (checkCertificateFast 10 4582 fastCert10_4582=true) ∧ (checkCertificateFast 10 4583 fastCert10_4583=true) ∧ (checkCertificateFast 10 4584 fastCert10_4584=true) ∧ (checkCertificateFast 10 4585 fastCert10_4585=true) ∧ (checkCertificateFast 10 4586 fastCert10_4586=true) ∧ (checkCertificateFast 10 4587 fastCert10_4587=true) ∧ (checkCertificateFast 10 4588 fastCert10_4588=true) ∧ (checkCertificateFast 10 4589 fastCert10_4589=true) ∧ (checkCertificateFast 10 4590 fastCert10_4590=true) ∧ (checkCertificateFast 10 4591 fastCert10_4591=true) ∧ (checkCertificateFast 10 4592 fastCert10_4592=true) ∧ (checkCertificateFast 10 4593 fastCert10_4593=true) ∧ (checkCertificateFast 10 4594 fastCert10_4594=true) ∧ (checkCertificateFast 10 4595 fastCert10_4595=true) ∧ (checkCertificateFast 10 4596 fastCert10_4596=true) ∧ (checkCertificateFast 10 4597 fastCert10_4597=true) ∧ (checkCertificateFast 10 4598 fastCert10_4598=true) ∧ (checkCertificateFast 10 4599 fastCert10_4599=true) ∧ (checkCertificateFast 10 4600 fastCert10_4600=true) ∧ (checkCertificateFast 10 4601 fastCert10_4601=true) ∧ (checkCertificateFast 10 4602 fastCert10_4602=true) ∧ (checkCertificateFast 10 4603 fastCert10_4603=true) ∧ (checkCertificateFast 10 4604 fastCert10_4604=true) ∧ (checkCertificateFast 10 4605 fastCert10_4605=true) ∧ (checkCertificateFast 10 4606 fastCert10_4606=true) ∧ (checkCertificateFast 10 4607 fastCert10_4607=true) ∧ (checkCertificateFast 10 4608 fastCert10_4608=true) ∧ (checkCertificateFast 10 4609 fastCert10_4609=true) ∧ (checkCertificateFast 10 4610 fastCert10_4610=true) ∧ (checkCertificateFast 10 4611 fastCert10_4611=true) ∧ (checkCertificateFast 10 4612 fastCert10_4612=true) ∧ (checkCertificateFast 10 4613 fastCert10_4613=true) ∧ (checkCertificateFast 10 4614 fastCert10_4614=true) ∧ (checkCertificateFast 10 4615 fastCert10_4615=true) ∧ (checkCertificateFast 10 4616 fastCert10_4616=true) ∧ (checkCertificateFast 10 4617 fastCert10_4617=true) ∧ (checkCertificateFast 10 4618 fastCert10_4618=true) ∧ (checkCertificateFast 10 4619 fastCert10_4619=true) ∧ (checkCertificateFast 10 4620 fastCert10_4620=true) ∧ (checkCertificateFast 10 4621 fastCert10_4621=true) ∧ (checkCertificateFast 10 4622 fastCert10_4622=true) ∧ (checkCertificateFast 10 4623 fastCert10_4623=true) ∧ (checkCertificateFast 10 4624 fastCert10_4624=true) ∧ (checkCertificateFast 10 4625 fastCert10_4625=true) ∧ (checkCertificateFast 10 4626 fastCert10_4626=true) ∧ (checkCertificateFast 10 4627 fastCert10_4627=true) ∧ (checkCertificateFast 10 4628 fastCert10_4628=true) ∧ (checkCertificateFast 10 4629 fastCert10_4629=true) ∧ (checkCertificateFast 10 4630 fastCert10_4630=true) ∧ (checkCertificateFast 10 4631 fastCert10_4631=true) ∧ (checkCertificateFast 10 4632 fastCert10_4632=true) ∧ (checkCertificateFast 10 4633 fastCert10_4633=true) ∧ (checkCertificateFast 10 4634 fastCert10_4634=true) ∧ (checkCertificateFast 10 4635 fastCert10_4635=true) ∧ (checkCertificateFast 10 4636 fastCert10_4636=true) ∧ (checkCertificateFast 10 4637 fastCert10_4637=true) ∧ (checkCertificateFast 10 4638 fastCert10_4638=true) ∧ (checkCertificateFast 10 4639 fastCert10_4639=true) ∧ (checkCertificateFast 10 4640 fastCert10_4640=true) ∧ (checkCertificateFast 10 4641 fastCert10_4641=true) ∧ (checkCertificateFast 10 4642 fastCert10_4642=true) ∧ (checkCertificateFast 10 4643 fastCert10_4643=true) ∧ (checkCertificateFast 10 4644 fastCert10_4644=true) ∧ (checkCertificateFast 10 4645 fastCert10_4645=true) ∧ (checkCertificateFast 10 4646 fastCert10_4646=true) ∧ (checkCertificateFast 10 4647 fastCert10_4647=true) ∧ (checkCertificateFast 10 4648 fastCert10_4648=true) ∧ (checkCertificateFast 10 4649 fastCert10_4649=true) ∧ (checkCertificateFast 10 4650 fastCert10_4650=true) ∧ (checkCertificateFast 10 4651 fastCert10_4651=true) ∧ (checkCertificateFast 10 4652 fastCert10_4652=true) ∧ (checkCertificateFast 10 4653 fastCert10_4653=true) ∧ (checkCertificateFast 10 4654 fastCert10_4654=true) ∧ (checkCertificateFast 10 4655 fastCert10_4655=true) ∧ (checkCertificateFast 10 4656 fastCert10_4656=true) ∧ (checkCertificateFast 10 4657 fastCert10_4657=true) ∧ (checkCertificateFast 10 4658 fastCert10_4658=true) ∧ (checkCertificateFast 10 4659 fastCert10_4659=true) ∧ (checkCertificateFast 10 4660 fastCert10_4660=true) ∧ (checkCertificateFast 10 4661 fastCert10_4661=true) ∧ (checkCertificateFast 10 4662 fastCert10_4662=true) ∧ (checkCertificateFast 10 4663 fastCert10_4663=true) ∧ (checkCertificateFast 10 4664 fastCert10_4664=true) ∧ (checkCertificateFast 10 4665 fastCert10_4665=true) ∧ (checkCertificateFast 10 4666 fastCert10_4666=true) ∧ (checkCertificateFast 10 4667 fastCert10_4667=true) ∧ (checkCertificateFast 10 4668 fastCert10_4668=true) ∧ (checkCertificateFast 10 4669 fastCert10_4669=true) ∧ (checkCertificateFast 10 4670 fastCert10_4670=true) ∧ (checkCertificateFast 10 4671 fastCert10_4671=true) ∧ (checkCertificateFast 10 4672 fastCert10_4672=true) ∧ (checkCertificateFast 10 4673 fastCert10_4673=true) ∧ (checkCertificateFast 10 4674 fastCert10_4674=true) ∧ (checkCertificateFast 10 4675 fastCert10_4675=true) ∧ (checkCertificateFast 10 4676 fastCert10_4676=true) ∧ (checkCertificateFast 10 4677 fastCert10_4677=true) ∧ (checkCertificateFast 10 4678 fastCert10_4678=true) ∧ (checkCertificateFast 10 4679 fastCert10_4679=true) ∧ (checkCertificateFast 10 4680 fastCert10_4680=true) ∧ (checkCertificateFast 10 4681 fastCert10_4681=true) ∧ (checkCertificateFast 10 4682 fastCert10_4682=true) ∧ (checkCertificateFast 10 4683 fastCert10_4683=true) ∧ (checkCertificateFast 10 4684 fastCert10_4684=true) ∧ (checkCertificateFast 10 4685 fastCert10_4685=true) ∧ (checkCertificateFast 10 4686 fastCert10_4686=true) ∧ (checkCertificateFast 10 4687 fastCert10_4687=true) ∧ (checkCertificateFast 10 4688 fastCert10_4688=true) ∧ (checkCertificateFast 10 4689 fastCert10_4689=true) ∧ (checkCertificateFast 10 4690 fastCert10_4690=true) ∧ (checkCertificateFast 10 4691 fastCert10_4691=true) ∧ (checkCertificateFast 10 4692 fastCert10_4692=true) ∧ (checkCertificateFast 10 4693 fastCert10_4693=true) ∧ (checkCertificateFast 10 4694 fastCert10_4694=true) ∧ (checkCertificateFast 10 4695 fastCert10_4695=true) ∧ (checkCertificateFast 10 4696 fastCert10_4696=true) ∧ (checkCertificateFast 10 4697 fastCert10_4697=true) ∧ (checkCertificateFast 10 4698 fastCert10_4698=true) ∧ (checkCertificateFast 10 4699 fastCert10_4699=true) ∧ (checkCertificateFast 10 4700 fastCert10_4700=true) ∧ (checkCertificateFast 10 4701 fastCert10_4701=true) ∧ (checkCertificateFast 10 4702 fastCert10_4702=true) ∧ (checkCertificateFast 10 4703 fastCert10_4703=true) ∧ (checkCertificateFast 10 4704 fastCert10_4704=true) ∧ (checkCertificateFast 10 4705 fastCert10_4705=true) ∧ (checkCertificateFast 10 4706 fastCert10_4706=true) ∧ (checkCertificateFast 10 4707 fastCert10_4707=true) ∧ (checkCertificateFast 10 4708 fastCert10_4708=true) ∧ (checkCertificateFast 10 4709 fastCert10_4709=true) ∧ (checkCertificateFast 10 4710 fastCert10_4710=true) ∧ (checkCertificateFast 10 4711 fastCert10_4711=true) ∧ (checkCertificateFast 10 4712 fastCert10_4712=true) ∧ (checkCertificateFast 10 4713 fastCert10_4713=true) ∧ (checkCertificateFast 10 4714 fastCert10_4714=true) ∧ (checkCertificateFast 10 4715 fastCert10_4715=true) ∧ (checkCertificateFast 10 4716 fastCert10_4716=true) ∧ (checkCertificateFast 10 4717 fastCert10_4717=true) ∧ (checkCertificateFast 10 4718 fastCert10_4718=true) ∧ (checkCertificateFast 10 4719 fastCert10_4719=true) ∧ (checkCertificateFast 10 4720 fastCert10_4720=true) ∧ (checkCertificateFast 10 4721 fastCert10_4721=true) ∧ (checkCertificateFast 10 4722 fastCert10_4722=true) ∧ (checkCertificateFast 10 4723 fastCert10_4723=true) ∧ (checkCertificateFast 10 4724 fastCert10_4724=true) ∧ (checkCertificateFast 10 4725 fastCert10_4725=true) ∧ (checkCertificateFast 10 4726 fastCert10_4726=true) ∧ (checkCertificateFast 10 4727 fastCert10_4727=true) ∧ (checkCertificateFast 10 4728 fastCert10_4728=true) ∧ (checkCertificateFast 10 4729 fastCert10_4729=true) ∧ (checkCertificateFast 10 4730 fastCert10_4730=true) ∧ (checkCertificateFast 10 4731 fastCert10_4731=true) ∧ (checkCertificateFast 10 4732 fastCert10_4732=true) ∧ (checkCertificateFast 10 4733 fastCert10_4733=true) ∧ (checkCertificateFast 10 4734 fastCert10_4734=true) ∧ (checkCertificateFast 10 4735 fastCert10_4735=true) ∧ (checkCertificateFast 10 4736 fastCert10_4736=true) ∧ (checkCertificateFast 10 4737 fastCert10_4737=true) ∧ (checkCertificateFast 10 4738 fastCert10_4738=true) ∧ (checkCertificateFast 10 4739 fastCert10_4739=true) ∧ (checkCertificateFast 10 4740 fastCert10_4740=true) ∧ (checkCertificateFast 10 4741 fastCert10_4741=true) ∧ (checkCertificateFast 10 4742 fastCert10_4742=true) ∧ (checkCertificateFast 10 4743 fastCert10_4743=true) ∧ (checkCertificateFast 10 4744 fastCert10_4744=true) ∧ (checkCertificateFast 10 4745 fastCert10_4745=true) ∧ (checkCertificateFast 10 4746 fastCert10_4746=true) ∧ (checkCertificateFast 10 4747 fastCert10_4747=true) ∧ (checkCertificateFast 10 4748 fastCert10_4748=true) ∧ (checkCertificateFast 10 4749 fastCert10_4749=true) ∧ (checkCertificateFast 10 4750 fastCert10_4750=true) ∧ (checkCertificateFast 10 4751 fastCert10_4751=true) ∧ (checkCertificateFast 10 4752 fastCert10_4752=true) ∧ (checkCertificateFast 10 4753 fastCert10_4753=true) ∧ (checkCertificateFast 10 4754 fastCert10_4754=true) ∧ (checkCertificateFast 10 4755 fastCert10_4755=true) ∧ (checkCertificateFast 10 4756 fastCert10_4756=true) ∧ (checkCertificateFast 10 4757 fastCert10_4757=true) ∧ (checkCertificateFast 10 4758 fastCert10_4758=true) ∧ (checkCertificateFast 10 4759 fastCert10_4759=true) ∧ (checkCertificateFast 10 4760 fastCert10_4760=true) ∧ (checkCertificateFast 10 4761 fastCert10_4761=true) ∧ (checkCertificateFast 10 4762 fastCert10_4762=true) ∧ (checkCertificateFast 10 4763 fastCert10_4763=true) ∧ (checkCertificateFast 10 4764 fastCert10_4764=true) ∧ (checkCertificateFast 10 4765 fastCert10_4765=true) ∧ (checkCertificateFast 10 4766 fastCert10_4766=true) ∧ (checkCertificateFast 10 4767 fastCert10_4767=true) ∧ (checkCertificateFast 10 4768 fastCert10_4768=true) ∧ (checkCertificateFast 10 4769 fastCert10_4769=true) ∧ (checkCertificateFast 10 4770 fastCert10_4770=true) ∧ (checkCertificateFast 10 4771 fastCert10_4771=true) ∧ (checkCertificateFast 10 4772 fastCert10_4772=true) ∧ (checkCertificateFast 10 4773 fastCert10_4773=true) ∧ (checkCertificateFast 10 4774 fastCert10_4774=true) ∧ (checkCertificateFast 10 4775 fastCert10_4775=true) ∧ (checkCertificateFast 10 4776 fastCert10_4776=true) ∧ (checkCertificateFast 10 4777 fastCert10_4777=true) ∧ (checkCertificateFast 10 4778 fastCert10_4778=true) ∧ (checkCertificateFast 10 4779 fastCert10_4779=true) ∧ (checkCertificateFast 10 4780 fastCert10_4780=true) ∧ (checkCertificateFast 10 4781 fastCert10_4781=true) ∧ (checkCertificateFast 10 4782 fastCert10_4782=true) ∧ (checkCertificateFast 10 4783 fastCert10_4783=true) ∧ (checkCertificateFast 10 4784 fastCert10_4784=true) ∧ (checkCertificateFast 10 4785 fastCert10_4785=true) ∧ (checkCertificateFast 10 4786 fastCert10_4786=true) ∧ (checkCertificateFast 10 4787 fastCert10_4787=true) ∧ (checkCertificateFast 10 4788 fastCert10_4788=true) ∧ (checkCertificateFast 10 4789 fastCert10_4789=true) ∧ (checkCertificateFast 10 4790 fastCert10_4790=true) ∧ (checkCertificateFast 10 4791 fastCert10_4791=true) ∧ (checkCertificateFast 10 4792 fastCert10_4792=true) ∧ (checkCertificateFast 10 4793 fastCert10_4793=true) ∧ (checkCertificateFast 10 4794 fastCert10_4794=true) ∧ (checkCertificateFast 10 4795 fastCert10_4795=true) ∧ (checkCertificateFast 10 4796 fastCert10_4796=true) ∧ (checkCertificateFast 10 4797 fastCert10_4797=true) ∧ (checkCertificateFast 10 4798 fastCert10_4798=true) ∧ (checkCertificateFast 10 4799 fastCert10_4799=true) ∧ (checkCertificateFast 10 4800 fastCert10_4800=true) ∧ (checkCertificateFast 10 4801 fastCert10_4801=true) ∧ (checkCertificateFast 10 4802 fastCert10_4802=true) ∧ (checkCertificateFast 10 4803 fastCert10_4803=true) ∧ (checkCertificateFast 10 4804 fastCert10_4804=true) ∧ (checkCertificateFast 10 4805 fastCert10_4805=true) ∧ (checkCertificateFast 10 4806 fastCert10_4806=true) ∧ (checkCertificateFast 10 4807 fastCert10_4807=true) ∧ (checkCertificateFast 10 4808 fastCert10_4808=true) ∧ (checkCertificateFast 10 4809 fastCert10_4809=true) ∧ (checkCertificateFast 10 4810 fastCert10_4810=true) ∧ (checkCertificateFast 10 4811 fastCert10_4811=true) ∧ (checkCertificateFast 10 4812 fastCert10_4812=true) ∧ (checkCertificateFast 10 4813 fastCert10_4813=true) ∧ (checkCertificateFast 10 4814 fastCert10_4814=true) ∧ (checkCertificateFast 10 4815 fastCert10_4815=true) ∧ (checkCertificateFast 10 4816 fastCert10_4816=true) ∧ (checkCertificateFast 10 4817 fastCert10_4817=true) ∧ (checkCertificateFast 10 4818 fastCert10_4818=true) ∧ (checkCertificateFast 10 4819 fastCert10_4819=true) ∧ (checkCertificateFast 10 4820 fastCert10_4820=true) ∧ (checkCertificateFast 10 4821 fastCert10_4821=true) ∧ (checkCertificateFast 10 4822 fastCert10_4822=true) ∧ (checkCertificateFast 10 4823 fastCert10_4823=true) ∧ (checkCertificateFast 10 4824 fastCert10_4824=true) ∧ (checkCertificateFast 10 4825 fastCert10_4825=true) ∧ (checkCertificateFast 10 4826 fastCert10_4826=true) ∧ (checkCertificateFast 10 4827 fastCert10_4827=true) ∧ (checkCertificateFast 10 4828 fastCert10_4828=true) ∧ (checkCertificateFast 10 4829 fastCert10_4829=true) ∧ (checkCertificateFast 10 4830 fastCert10_4830=true) ∧ (checkCertificateFast 10 4831 fastCert10_4831=true) ∧ (checkCertificateFast 10 4832 fastCert10_4832=true) ∧ (checkCertificateFast 10 4833 fastCert10_4833=true) ∧ (checkCertificateFast 10 4834 fastCert10_4834=true) ∧ (checkCertificateFast 10 4835 fastCert10_4835=true) ∧ (checkCertificateFast 10 4836 fastCert10_4836=true) ∧ (checkCertificateFast 10 4837 fastCert10_4837=true) ∧ (checkCertificateFast 10 4838 fastCert10_4838=true) ∧ (checkCertificateFast 10 4839 fastCert10_4839=true) ∧ (checkCertificateFast 10 4840 fastCert10_4840=true) ∧ (checkCertificateFast 10 4841 fastCert10_4841=true) ∧ (checkCertificateFast 10 4842 fastCert10_4842=true) ∧ (checkCertificateFast 10 4843 fastCert10_4843=true) ∧ (checkCertificateFast 10 4844 fastCert10_4844=true) ∧ (checkCertificateFast 10 4845 fastCert10_4845=true) ∧ (checkCertificateFast 10 4846 fastCert10_4846=true) ∧ (checkCertificateFast 10 4847 fastCert10_4847=true) ∧ (checkCertificateFast 10 4848 fastCert10_4848=true) ∧ (checkCertificateFast 10 4849 fastCert10_4849=true) ∧ (checkCertificateFast 10 4850 fastCert10_4850=true) ∧ (checkCertificateFast 10 4851 fastCert10_4851=true) ∧ (checkCertificateFast 10 4852 fastCert10_4852=true) ∧ (checkCertificateFast 10 4853 fastCert10_4853=true) ∧ (checkCertificateFast 10 4854 fastCert10_4854=true) ∧ (checkCertificateFast 10 4855 fastCert10_4855=true) ∧ (checkCertificateFast 10 4856 fastCert10_4856=true) ∧ (checkCertificateFast 10 4857 fastCert10_4857=true) ∧ (checkCertificateFast 10 4858 fastCert10_4858=true) ∧ (checkCertificateFast 10 4859 fastCert10_4859=true) ∧ (checkCertificateFast 10 4860 fastCert10_4860=true) ∧ (checkCertificateFast 10 4861 fastCert10_4861=true) ∧ (checkCertificateFast 10 4862 fastCert10_4862=true) ∧ (checkCertificateFast 10 4863 fastCert10_4863=true) ∧ (checkCertificateFast 10 4864 fastCert10_4864=true) ∧ (checkCertificateFast 10 4865 fastCert10_4865=true) ∧ (checkCertificateFast 10 4866 fastCert10_4866=true) ∧ (checkCertificateFast 10 4867 fastCert10_4867=true) ∧ (checkCertificateFast 10 4868 fastCert10_4868=true) ∧ (checkCertificateFast 10 4869 fastCert10_4869=true) ∧ (checkCertificateFast 10 4870 fastCert10_4870=true) ∧ (checkCertificateFast 10 4871 fastCert10_4871=true) ∧ (checkCertificateFast 10 4872 fastCert10_4872=true) ∧ (checkCertificateFast 10 4873 fastCert10_4873=true) ∧ (checkCertificateFast 10 4874 fastCert10_4874=true) ∧ (checkCertificateFast 10 4875 fastCert10_4875=true) ∧ (checkCertificateFast 10 4876 fastCert10_4876=true) ∧ (checkCertificateFast 10 4877 fastCert10_4877=true) ∧ (checkCertificateFast 10 4878 fastCert10_4878=true) ∧ (checkCertificateFast 10 4879 fastCert10_4879=true) ∧ (checkCertificateFast 10 4880 fastCert10_4880=true) ∧ (checkCertificateFast 10 4881 fastCert10_4881=true) ∧ (checkCertificateFast 10 4882 fastCert10_4882=true) ∧ (checkCertificateFast 10 4883 fastCert10_4883=true) ∧ (checkCertificateFast 10 4884 fastCert10_4884=true) ∧ (checkCertificateFast 10 4885 fastCert10_4885=true) ∧ (checkCertificateFast 10 4886 fastCert10_4886=true) ∧ (checkCertificateFast 10 4887 fastCert10_4887=true) ∧ (checkCertificateFast 10 4888 fastCert10_4888=true) ∧ (checkCertificateFast 10 4889 fastCert10_4889=true) ∧ (checkCertificateFast 10 4890 fastCert10_4890=true) ∧ (checkCertificateFast 10 4891 fastCert10_4891=true) ∧ (checkCertificateFast 10 4892 fastCert10_4892=true) ∧ (checkCertificateFast 10 4893 fastCert10_4893=true) ∧ (checkCertificateFast 10 4894 fastCert10_4894=true) ∧ (checkCertificateFast 10 4895 fastCert10_4895=true) ∧ (checkCertificateFast 10 4896 fastCert10_4896=true) ∧ (checkCertificateFast 10 4897 fastCert10_4897=true) ∧ (checkCertificateFast 10 4898 fastCert10_4898=true) ∧ (checkCertificateFast 10 4899 fastCert10_4899=true) ∧ (checkCertificateFast 10 4900 fastCert10_4900=true) ∧ (checkCertificateFast 10 4901 fastCert10_4901=true) ∧ (checkCertificateFast 10 4902 fastCert10_4902=true) ∧ (checkCertificateFast 10 4903 fastCert10_4903=true) ∧ (checkCertificateFast 10 4904 fastCert10_4904=true) ∧ (checkCertificateFast 10 4905 fastCert10_4905=true) ∧ (checkCertificateFast 10 4906 fastCert10_4906=true) ∧ (checkCertificateFast 10 4907 fastCert10_4907=true) ∧ (checkCertificateFast 10 4908 fastCert10_4908=true) ∧ (checkCertificateFast 10 4909 fastCert10_4909=true) ∧ (checkCertificateFast 10 4910 fastCert10_4910=true) ∧ (checkCertificateFast 10 4911 fastCert10_4911=true) ∧ (checkCertificateFast 10 4912 fastCert10_4912=true) ∧ (checkCertificateFast 10 4913 fastCert10_4913=true) ∧ (checkCertificateFast 10 4914 fastCert10_4914=true) ∧ (checkCertificateFast 10 4915 fastCert10_4915=true) ∧ (checkCertificateFast 10 4916 fastCert10_4916=true) ∧ (checkCertificateFast 10 4917 fastCert10_4917=true) ∧ (checkCertificateFast 10 4918 fastCert10_4918=true) ∧ (checkCertificateFast 10 4919 fastCert10_4919=true) ∧ (checkCertificateFast 10 4920 fastCert10_4920=true) ∧ (checkCertificateFast 10 4921 fastCert10_4921=true) ∧ (checkCertificateFast 10 4922 fastCert10_4922=true) ∧ (checkCertificateFast 10 4923 fastCert10_4923=true) ∧ (checkCertificateFast 10 4924 fastCert10_4924=true) ∧ (checkCertificateFast 10 4925 fastCert10_4925=true) ∧ (checkCertificateFast 10 4926 fastCert10_4926=true) ∧ (checkCertificateFast 10 4927 fastCert10_4927=true) ∧ (checkCertificateFast 10 4928 fastCert10_4928=true) ∧ (checkCertificateFast 10 4929 fastCert10_4929=true) ∧ (checkCertificateFast 10 4930 fastCert10_4930=true) ∧ (checkCertificateFast 10 4931 fastCert10_4931=true) ∧ (checkCertificateFast 10 4932 fastCert10_4932=true) ∧ (checkCertificateFast 10 4933 fastCert10_4933=true) ∧ (checkCertificateFast 10 4934 fastCert10_4934=true) ∧ (checkCertificateFast 10 4935 fastCert10_4935=true) ∧ (checkCertificateFast 10 4936 fastCert10_4936=true) ∧ (checkCertificateFast 10 4937 fastCert10_4937=true) ∧ (checkCertificateFast 10 4938 fastCert10_4938=true) ∧ (checkCertificateFast 10 4939 fastCert10_4939=true) ∧ (checkCertificateFast 10 4940 fastCert10_4940=true) ∧ (checkCertificateFast 10 4941 fastCert10_4941=true) ∧ (checkCertificateFast 10 4942 fastCert10_4942=true) ∧ (checkCertificateFast 10 4943 fastCert10_4943=true) ∧ (checkCertificateFast 10 4944 fastCert10_4944=true) ∧ (checkCertificateFast 10 4945 fastCert10_4945=true) ∧ (checkCertificateFast 10 4946 fastCert10_4946=true) ∧ (checkCertificateFast 10 4947 fastCert10_4947=true) ∧ (checkCertificateFast 10 4948 fastCert10_4948=true) ∧ (checkCertificateFast 10 4949 fastCert10_4949=true) ∧ (checkCertificateFast 10 4950 fastCert10_4950=true) ∧ (checkCertificateFast 10 4951 fastCert10_4951=true) ∧ (checkCertificateFast 10 4952 fastCert10_4952=true) ∧ (checkCertificateFast 10 4953 fastCert10_4953=true) ∧ (checkCertificateFast 10 4954 fastCert10_4954=true) ∧ (checkCertificateFast 10 4955 fastCert10_4955=true) ∧ (checkCertificateFast 10 4956 fastCert10_4956=true) ∧ (checkCertificateFast 10 4957 fastCert10_4957=true) ∧ (checkCertificateFast 10 4958 fastCert10_4958=true) ∧ (checkCertificateFast 10 4959 fastCert10_4959=true) ∧ (checkCertificateFast 10 4960 fastCert10_4960=true) ∧ (checkCertificateFast 10 4961 fastCert10_4961=true) ∧ (checkCertificateFast 10 4962 fastCert10_4962=true) ∧ (checkCertificateFast 10 4963 fastCert10_4963=true) ∧ (checkCertificateFast 10 4964 fastCert10_4964=true) ∧ (checkCertificateFast 10 4965 fastCert10_4965=true) ∧ (checkCertificateFast 10 4966 fastCert10_4966=true) ∧ (checkCertificateFast 10 4967 fastCert10_4967=true) ∧ (checkCertificateFast 10 4968 fastCert10_4968=true) ∧ (checkCertificateFast 10 4969 fastCert10_4969=true) ∧ (checkCertificateFast 10 4970 fastCert10_4970=true) ∧ (checkCertificateFast 10 4971 fastCert10_4971=true) ∧ (checkCertificateFast 10 4972 fastCert10_4972=true) ∧ (checkCertificateFast 10 4973 fastCert10_4973=true) ∧ (checkCertificateFast 10 4974 fastCert10_4974=true) ∧ (checkCertificateFast 10 4975 fastCert10_4975=true) ∧ (checkCertificateFast 10 4976 fastCert10_4976=true) ∧ (checkCertificateFast 10 4977 fastCert10_4977=true) ∧ (checkCertificateFast 10 4978 fastCert10_4978=true) ∧ (checkCertificateFast 10 4979 fastCert10_4979=true) ∧ (checkCertificateFast 10 4980 fastCert10_4980=true) ∧ (checkCertificateFast 10 4981 fastCert10_4981=true) ∧ (checkCertificateFast 10 4982 fastCert10_4982=true) ∧ (checkCertificateFast 10 4983 fastCert10_4983=true) ∧ (checkCertificateFast 10 4984 fastCert10_4984=true) ∧ (checkCertificateFast 10 4985 fastCert10_4985=true) ∧ (checkCertificateFast 10 4986 fastCert10_4986=true) ∧ (checkCertificateFast 10 4987 fastCert10_4987=true) ∧ (checkCertificateFast 10 4988 fastCert10_4988=true) ∧ (checkCertificateFast 10 4989 fastCert10_4989=true) ∧ (checkCertificateFast 10 4990 fastCert10_4990=true) ∧ (checkCertificateFast 10 4991 fastCert10_4991=true) ∧ (checkCertificateFast 10 4992 fastCert10_4992=true) ∧ (checkCertificateFast 10 4993 fastCert10_4993=true) ∧ (checkCertificateFast 10 4994 fastCert10_4994=true) ∧ (checkCertificateFast 10 4995 fastCert10_4995=true) ∧ (checkCertificateFast 10 4996 fastCert10_4996=true) ∧ (checkCertificateFast 10 4997 fastCert10_4997=true) ∧ (checkCertificateFast 10 4998 fastCert10_4998=true) ∧ (checkCertificateFast 10 4999 fastCert10_4999=true) :=
  ⟨fastCase10_4000,fastCase10_4001,fastCase10_4002,fastCase10_4003,fastCase10_4004,fastCase10_4005,fastCase10_4006,fastCase10_4007,fastCase10_4008,fastCase10_4009,fastCase10_4010,fastCase10_4011,fastCase10_4012,fastCase10_4013,fastCase10_4014,fastCase10_4015,fastCase10_4016,fastCase10_4017,fastCase10_4018,fastCase10_4019,fastCase10_4020,fastCase10_4021,fastCase10_4022,fastCase10_4023,fastCase10_4024,fastCase10_4025,fastCase10_4026,fastCase10_4027,fastCase10_4028,fastCase10_4029,fastCase10_4030,fastCase10_4031,fastCase10_4032,fastCase10_4033,fastCase10_4034,fastCase10_4035,fastCase10_4036,fastCase10_4037,fastCase10_4038,fastCase10_4039,fastCase10_4040,fastCase10_4041,fastCase10_4042,fastCase10_4043,fastCase10_4044,fastCase10_4045,fastCase10_4046,fastCase10_4047,fastCase10_4048,fastCase10_4049,fastCase10_4050,fastCase10_4051,fastCase10_4052,fastCase10_4053,fastCase10_4054,fastCase10_4055,fastCase10_4056,fastCase10_4057,fastCase10_4058,fastCase10_4059,fastCase10_4060,fastCase10_4061,fastCase10_4062,fastCase10_4063,fastCase10_4064,fastCase10_4065,fastCase10_4066,fastCase10_4067,fastCase10_4068,fastCase10_4069,fastCase10_4070,fastCase10_4071,fastCase10_4072,fastCase10_4073,fastCase10_4074,fastCase10_4075,fastCase10_4076,fastCase10_4077,fastCase10_4078,fastCase10_4079,fastCase10_4080,fastCase10_4081,fastCase10_4082,fastCase10_4083,fastCase10_4084,fastCase10_4085,fastCase10_4086,fastCase10_4087,fastCase10_4088,fastCase10_4089,fastCase10_4090,fastCase10_4091,fastCase10_4092,fastCase10_4093,fastCase10_4094,fastCase10_4095,fastCase10_4096,fastCase10_4097,fastCase10_4098,fastCase10_4099,fastCase10_4100,fastCase10_4101,fastCase10_4102,fastCase10_4103,fastCase10_4104,fastCase10_4105,fastCase10_4106,fastCase10_4107,fastCase10_4108,fastCase10_4109,fastCase10_4110,fastCase10_4111,fastCase10_4112,fastCase10_4113,fastCase10_4114,fastCase10_4115,fastCase10_4116,fastCase10_4117,fastCase10_4118,fastCase10_4119,fastCase10_4120,fastCase10_4121,fastCase10_4122,fastCase10_4123,fastCase10_4124,fastCase10_4125,fastCase10_4126,fastCase10_4127,fastCase10_4128,fastCase10_4129,fastCase10_4130,fastCase10_4131,fastCase10_4132,fastCase10_4133,fastCase10_4134,fastCase10_4135,fastCase10_4136,fastCase10_4137,fastCase10_4138,fastCase10_4139,fastCase10_4140,fastCase10_4141,fastCase10_4142,fastCase10_4143,fastCase10_4144,fastCase10_4145,fastCase10_4146,fastCase10_4147,fastCase10_4148,fastCase10_4149,fastCase10_4150,fastCase10_4151,fastCase10_4152,fastCase10_4153,fastCase10_4154,fastCase10_4155,fastCase10_4156,fastCase10_4157,fastCase10_4158,fastCase10_4159,fastCase10_4160,fastCase10_4161,fastCase10_4162,fastCase10_4163,fastCase10_4164,fastCase10_4165,fastCase10_4166,fastCase10_4167,fastCase10_4168,fastCase10_4169,fastCase10_4170,fastCase10_4171,fastCase10_4172,fastCase10_4173,fastCase10_4174,fastCase10_4175,fastCase10_4176,fastCase10_4177,fastCase10_4178,fastCase10_4179,fastCase10_4180,fastCase10_4181,fastCase10_4182,fastCase10_4183,fastCase10_4184,fastCase10_4185,fastCase10_4186,fastCase10_4187,fastCase10_4188,fastCase10_4189,fastCase10_4190,fastCase10_4191,fastCase10_4192,fastCase10_4193,fastCase10_4194,fastCase10_4195,fastCase10_4196,fastCase10_4197,fastCase10_4198,fastCase10_4199,fastCase10_4200,fastCase10_4201,fastCase10_4202,fastCase10_4203,fastCase10_4204,fastCase10_4205,fastCase10_4206,fastCase10_4207,fastCase10_4208,fastCase10_4209,fastCase10_4210,fastCase10_4211,fastCase10_4212,fastCase10_4213,fastCase10_4214,fastCase10_4215,fastCase10_4216,fastCase10_4217,fastCase10_4218,fastCase10_4219,fastCase10_4220,fastCase10_4221,fastCase10_4222,fastCase10_4223,fastCase10_4224,fastCase10_4225,fastCase10_4226,fastCase10_4227,fastCase10_4228,fastCase10_4229,fastCase10_4230,fastCase10_4231,fastCase10_4232,fastCase10_4233,fastCase10_4234,fastCase10_4235,fastCase10_4236,fastCase10_4237,fastCase10_4238,fastCase10_4239,fastCase10_4240,fastCase10_4241,fastCase10_4242,fastCase10_4243,fastCase10_4244,fastCase10_4245,fastCase10_4246,fastCase10_4247,fastCase10_4248,fastCase10_4249,fastCase10_4250,fastCase10_4251,fastCase10_4252,fastCase10_4253,fastCase10_4254,fastCase10_4255,fastCase10_4256,fastCase10_4257,fastCase10_4258,fastCase10_4259,fastCase10_4260,fastCase10_4261,fastCase10_4262,fastCase10_4263,fastCase10_4264,fastCase10_4265,fastCase10_4266,fastCase10_4267,fastCase10_4268,fastCase10_4269,fastCase10_4270,fastCase10_4271,fastCase10_4272,fastCase10_4273,fastCase10_4274,fastCase10_4275,fastCase10_4276,fastCase10_4277,fastCase10_4278,fastCase10_4279,fastCase10_4280,fastCase10_4281,fastCase10_4282,fastCase10_4283,fastCase10_4284,fastCase10_4285,fastCase10_4286,fastCase10_4287,fastCase10_4288,fastCase10_4289,fastCase10_4290,fastCase10_4291,fastCase10_4292,fastCase10_4293,fastCase10_4294,fastCase10_4295,fastCase10_4296,fastCase10_4297,fastCase10_4298,fastCase10_4299,fastCase10_4300,fastCase10_4301,fastCase10_4302,fastCase10_4303,fastCase10_4304,fastCase10_4305,fastCase10_4306,fastCase10_4307,fastCase10_4308,fastCase10_4309,fastCase10_4310,fastCase10_4311,fastCase10_4312,fastCase10_4313,fastCase10_4314,fastCase10_4315,fastCase10_4316,fastCase10_4317,fastCase10_4318,fastCase10_4319,fastCase10_4320,fastCase10_4321,fastCase10_4322,fastCase10_4323,fastCase10_4324,fastCase10_4325,fastCase10_4326,fastCase10_4327,fastCase10_4328,fastCase10_4329,fastCase10_4330,fastCase10_4331,fastCase10_4332,fastCase10_4333,fastCase10_4334,fastCase10_4335,fastCase10_4336,fastCase10_4337,fastCase10_4338,fastCase10_4339,fastCase10_4340,fastCase10_4341,fastCase10_4342,fastCase10_4343,fastCase10_4344,fastCase10_4345,fastCase10_4346,fastCase10_4347,fastCase10_4348,fastCase10_4349,fastCase10_4350,fastCase10_4351,fastCase10_4352,fastCase10_4353,fastCase10_4354,fastCase10_4355,fastCase10_4356,fastCase10_4357,fastCase10_4358,fastCase10_4359,fastCase10_4360,fastCase10_4361,fastCase10_4362,fastCase10_4363,fastCase10_4364,fastCase10_4365,fastCase10_4366,fastCase10_4367,fastCase10_4368,fastCase10_4369,fastCase10_4370,fastCase10_4371,fastCase10_4372,fastCase10_4373,fastCase10_4374,fastCase10_4375,fastCase10_4376,fastCase10_4377,fastCase10_4378,fastCase10_4379,fastCase10_4380,fastCase10_4381,fastCase10_4382,fastCase10_4383,fastCase10_4384,fastCase10_4385,fastCase10_4386,fastCase10_4387,fastCase10_4388,fastCase10_4389,fastCase10_4390,fastCase10_4391,fastCase10_4392,fastCase10_4393,fastCase10_4394,fastCase10_4395,fastCase10_4396,fastCase10_4397,fastCase10_4398,fastCase10_4399,fastCase10_4400,fastCase10_4401,fastCase10_4402,fastCase10_4403,fastCase10_4404,fastCase10_4405,fastCase10_4406,fastCase10_4407,fastCase10_4408,fastCase10_4409,fastCase10_4410,fastCase10_4411,fastCase10_4412,fastCase10_4413,fastCase10_4414,fastCase10_4415,fastCase10_4416,fastCase10_4417,fastCase10_4418,fastCase10_4419,fastCase10_4420,fastCase10_4421,fastCase10_4422,fastCase10_4423,fastCase10_4424,fastCase10_4425,fastCase10_4426,fastCase10_4427,fastCase10_4428,fastCase10_4429,fastCase10_4430,fastCase10_4431,fastCase10_4432,fastCase10_4433,fastCase10_4434,fastCase10_4435,fastCase10_4436,fastCase10_4437,fastCase10_4438,fastCase10_4439,fastCase10_4440,fastCase10_4441,fastCase10_4442,fastCase10_4443,fastCase10_4444,fastCase10_4445,fastCase10_4446,fastCase10_4447,fastCase10_4448,fastCase10_4449,fastCase10_4450,fastCase10_4451,fastCase10_4452,fastCase10_4453,fastCase10_4454,fastCase10_4455,fastCase10_4456,fastCase10_4457,fastCase10_4458,fastCase10_4459,fastCase10_4460,fastCase10_4461,fastCase10_4462,fastCase10_4463,fastCase10_4464,fastCase10_4465,fastCase10_4466,fastCase10_4467,fastCase10_4468,fastCase10_4469,fastCase10_4470,fastCase10_4471,fastCase10_4472,fastCase10_4473,fastCase10_4474,fastCase10_4475,fastCase10_4476,fastCase10_4477,fastCase10_4478,fastCase10_4479,fastCase10_4480,fastCase10_4481,fastCase10_4482,fastCase10_4483,fastCase10_4484,fastCase10_4485,fastCase10_4486,fastCase10_4487,fastCase10_4488,fastCase10_4489,fastCase10_4490,fastCase10_4491,fastCase10_4492,fastCase10_4493,fastCase10_4494,fastCase10_4495,fastCase10_4496,fastCase10_4497,fastCase10_4498,fastCase10_4499,fastCase10_4500,fastCase10_4501,fastCase10_4502,fastCase10_4503,fastCase10_4504,fastCase10_4505,fastCase10_4506,fastCase10_4507,fastCase10_4508,fastCase10_4509,fastCase10_4510,fastCase10_4511,fastCase10_4512,fastCase10_4513,fastCase10_4514,fastCase10_4515,fastCase10_4516,fastCase10_4517,fastCase10_4518,fastCase10_4519,fastCase10_4520,fastCase10_4521,fastCase10_4522,fastCase10_4523,fastCase10_4524,fastCase10_4525,fastCase10_4526,fastCase10_4527,fastCase10_4528,fastCase10_4529,fastCase10_4530,fastCase10_4531,fastCase10_4532,fastCase10_4533,fastCase10_4534,fastCase10_4535,fastCase10_4536,fastCase10_4537,fastCase10_4538,fastCase10_4539,fastCase10_4540,fastCase10_4541,fastCase10_4542,fastCase10_4543,fastCase10_4544,fastCase10_4545,fastCase10_4546,fastCase10_4547,fastCase10_4548,fastCase10_4549,fastCase10_4550,fastCase10_4551,fastCase10_4552,fastCase10_4553,fastCase10_4554,fastCase10_4555,fastCase10_4556,fastCase10_4557,fastCase10_4558,fastCase10_4559,fastCase10_4560,fastCase10_4561,fastCase10_4562,fastCase10_4563,fastCase10_4564,fastCase10_4565,fastCase10_4566,fastCase10_4567,fastCase10_4568,fastCase10_4569,fastCase10_4570,fastCase10_4571,fastCase10_4572,fastCase10_4573,fastCase10_4574,fastCase10_4575,fastCase10_4576,fastCase10_4577,fastCase10_4578,fastCase10_4579,fastCase10_4580,fastCase10_4581,fastCase10_4582,fastCase10_4583,fastCase10_4584,fastCase10_4585,fastCase10_4586,fastCase10_4587,fastCase10_4588,fastCase10_4589,fastCase10_4590,fastCase10_4591,fastCase10_4592,fastCase10_4593,fastCase10_4594,fastCase10_4595,fastCase10_4596,fastCase10_4597,fastCase10_4598,fastCase10_4599,fastCase10_4600,fastCase10_4601,fastCase10_4602,fastCase10_4603,fastCase10_4604,fastCase10_4605,fastCase10_4606,fastCase10_4607,fastCase10_4608,fastCase10_4609,fastCase10_4610,fastCase10_4611,fastCase10_4612,fastCase10_4613,fastCase10_4614,fastCase10_4615,fastCase10_4616,fastCase10_4617,fastCase10_4618,fastCase10_4619,fastCase10_4620,fastCase10_4621,fastCase10_4622,fastCase10_4623,fastCase10_4624,fastCase10_4625,fastCase10_4626,fastCase10_4627,fastCase10_4628,fastCase10_4629,fastCase10_4630,fastCase10_4631,fastCase10_4632,fastCase10_4633,fastCase10_4634,fastCase10_4635,fastCase10_4636,fastCase10_4637,fastCase10_4638,fastCase10_4639,fastCase10_4640,fastCase10_4641,fastCase10_4642,fastCase10_4643,fastCase10_4644,fastCase10_4645,fastCase10_4646,fastCase10_4647,fastCase10_4648,fastCase10_4649,fastCase10_4650,fastCase10_4651,fastCase10_4652,fastCase10_4653,fastCase10_4654,fastCase10_4655,fastCase10_4656,fastCase10_4657,fastCase10_4658,fastCase10_4659,fastCase10_4660,fastCase10_4661,fastCase10_4662,fastCase10_4663,fastCase10_4664,fastCase10_4665,fastCase10_4666,fastCase10_4667,fastCase10_4668,fastCase10_4669,fastCase10_4670,fastCase10_4671,fastCase10_4672,fastCase10_4673,fastCase10_4674,fastCase10_4675,fastCase10_4676,fastCase10_4677,fastCase10_4678,fastCase10_4679,fastCase10_4680,fastCase10_4681,fastCase10_4682,fastCase10_4683,fastCase10_4684,fastCase10_4685,fastCase10_4686,fastCase10_4687,fastCase10_4688,fastCase10_4689,fastCase10_4690,fastCase10_4691,fastCase10_4692,fastCase10_4693,fastCase10_4694,fastCase10_4695,fastCase10_4696,fastCase10_4697,fastCase10_4698,fastCase10_4699,fastCase10_4700,fastCase10_4701,fastCase10_4702,fastCase10_4703,fastCase10_4704,fastCase10_4705,fastCase10_4706,fastCase10_4707,fastCase10_4708,fastCase10_4709,fastCase10_4710,fastCase10_4711,fastCase10_4712,fastCase10_4713,fastCase10_4714,fastCase10_4715,fastCase10_4716,fastCase10_4717,fastCase10_4718,fastCase10_4719,fastCase10_4720,fastCase10_4721,fastCase10_4722,fastCase10_4723,fastCase10_4724,fastCase10_4725,fastCase10_4726,fastCase10_4727,fastCase10_4728,fastCase10_4729,fastCase10_4730,fastCase10_4731,fastCase10_4732,fastCase10_4733,fastCase10_4734,fastCase10_4735,fastCase10_4736,fastCase10_4737,fastCase10_4738,fastCase10_4739,fastCase10_4740,fastCase10_4741,fastCase10_4742,fastCase10_4743,fastCase10_4744,fastCase10_4745,fastCase10_4746,fastCase10_4747,fastCase10_4748,fastCase10_4749,fastCase10_4750,fastCase10_4751,fastCase10_4752,fastCase10_4753,fastCase10_4754,fastCase10_4755,fastCase10_4756,fastCase10_4757,fastCase10_4758,fastCase10_4759,fastCase10_4760,fastCase10_4761,fastCase10_4762,fastCase10_4763,fastCase10_4764,fastCase10_4765,fastCase10_4766,fastCase10_4767,fastCase10_4768,fastCase10_4769,fastCase10_4770,fastCase10_4771,fastCase10_4772,fastCase10_4773,fastCase10_4774,fastCase10_4775,fastCase10_4776,fastCase10_4777,fastCase10_4778,fastCase10_4779,fastCase10_4780,fastCase10_4781,fastCase10_4782,fastCase10_4783,fastCase10_4784,fastCase10_4785,fastCase10_4786,fastCase10_4787,fastCase10_4788,fastCase10_4789,fastCase10_4790,fastCase10_4791,fastCase10_4792,fastCase10_4793,fastCase10_4794,fastCase10_4795,fastCase10_4796,fastCase10_4797,fastCase10_4798,fastCase10_4799,fastCase10_4800,fastCase10_4801,fastCase10_4802,fastCase10_4803,fastCase10_4804,fastCase10_4805,fastCase10_4806,fastCase10_4807,fastCase10_4808,fastCase10_4809,fastCase10_4810,fastCase10_4811,fastCase10_4812,fastCase10_4813,fastCase10_4814,fastCase10_4815,fastCase10_4816,fastCase10_4817,fastCase10_4818,fastCase10_4819,fastCase10_4820,fastCase10_4821,fastCase10_4822,fastCase10_4823,fastCase10_4824,fastCase10_4825,fastCase10_4826,fastCase10_4827,fastCase10_4828,fastCase10_4829,fastCase10_4830,fastCase10_4831,fastCase10_4832,fastCase10_4833,fastCase10_4834,fastCase10_4835,fastCase10_4836,fastCase10_4837,fastCase10_4838,fastCase10_4839,fastCase10_4840,fastCase10_4841,fastCase10_4842,fastCase10_4843,fastCase10_4844,fastCase10_4845,fastCase10_4846,fastCase10_4847,fastCase10_4848,fastCase10_4849,fastCase10_4850,fastCase10_4851,fastCase10_4852,fastCase10_4853,fastCase10_4854,fastCase10_4855,fastCase10_4856,fastCase10_4857,fastCase10_4858,fastCase10_4859,fastCase10_4860,fastCase10_4861,fastCase10_4862,fastCase10_4863,fastCase10_4864,fastCase10_4865,fastCase10_4866,fastCase10_4867,fastCase10_4868,fastCase10_4869,fastCase10_4870,fastCase10_4871,fastCase10_4872,fastCase10_4873,fastCase10_4874,fastCase10_4875,fastCase10_4876,fastCase10_4877,fastCase10_4878,fastCase10_4879,fastCase10_4880,fastCase10_4881,fastCase10_4882,fastCase10_4883,fastCase10_4884,fastCase10_4885,fastCase10_4886,fastCase10_4887,fastCase10_4888,fastCase10_4889,fastCase10_4890,fastCase10_4891,fastCase10_4892,fastCase10_4893,fastCase10_4894,fastCase10_4895,fastCase10_4896,fastCase10_4897,fastCase10_4898,fastCase10_4899,fastCase10_4900,fastCase10_4901,fastCase10_4902,fastCase10_4903,fastCase10_4904,fastCase10_4905,fastCase10_4906,fastCase10_4907,fastCase10_4908,fastCase10_4909,fastCase10_4910,fastCase10_4911,fastCase10_4912,fastCase10_4913,fastCase10_4914,fastCase10_4915,fastCase10_4916,fastCase10_4917,fastCase10_4918,fastCase10_4919,fastCase10_4920,fastCase10_4921,fastCase10_4922,fastCase10_4923,fastCase10_4924,fastCase10_4925,fastCase10_4926,fastCase10_4927,fastCase10_4928,fastCase10_4929,fastCase10_4930,fastCase10_4931,fastCase10_4932,fastCase10_4933,fastCase10_4934,fastCase10_4935,fastCase10_4936,fastCase10_4937,fastCase10_4938,fastCase10_4939,fastCase10_4940,fastCase10_4941,fastCase10_4942,fastCase10_4943,fastCase10_4944,fastCase10_4945,fastCase10_4946,fastCase10_4947,fastCase10_4948,fastCase10_4949,fastCase10_4950,fastCase10_4951,fastCase10_4952,fastCase10_4953,fastCase10_4954,fastCase10_4955,fastCase10_4956,fastCase10_4957,fastCase10_4958,fastCase10_4959,fastCase10_4960,fastCase10_4961,fastCase10_4962,fastCase10_4963,fastCase10_4964,fastCase10_4965,fastCase10_4966,fastCase10_4967,fastCase10_4968,fastCase10_4969,fastCase10_4970,fastCase10_4971,fastCase10_4972,fastCase10_4973,fastCase10_4974,fastCase10_4975,fastCase10_4976,fastCase10_4977,fastCase10_4978,fastCase10_4979,fastCase10_4980,fastCase10_4981,fastCase10_4982,fastCase10_4983,fastCase10_4984,fastCase10_4985,fastCase10_4986,fastCase10_4987,fastCase10_4988,fastCase10_4989,fastCase10_4990,fastCase10_4991,fastCase10_4992,fastCase10_4993,fastCase10_4994,fastCase10_4995,fastCase10_4996,fastCase10_4997,fastCase10_4998,fastCase10_4999⟩
#print axioms aggregate_F10_004
end KernelCatalog
