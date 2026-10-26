import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_0 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_0 : checkCertificateFast 10 0 fastCert10_0=true := by decide +kernel
def fastCert10_1 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_1 : checkCertificateFast 10 1 fastCert10_1=true := by decide +kernel
def fastCert10_2 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2 : checkCertificateFast 10 2 fastCert10_2=true := by decide +kernel
def fastCert10_3 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_3 : checkCertificateFast 10 3 fastCert10_3=true := by decide +kernel
def fastCert10_4 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_4 : checkCertificateFast 10 4 fastCert10_4=true := by decide +kernel
def fastCert10_5 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_5 : checkCertificateFast 10 5 fastCert10_5=true := by decide +kernel
def fastCert10_6 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_6 : checkCertificateFast 10 6 fastCert10_6=true := by decide +kernel
def fastCert10_7 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_7 : checkCertificateFast 10 7 fastCert10_7=true := by decide +kernel
def fastCert10_8 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_8 : checkCertificateFast 10 8 fastCert10_8=true := by decide +kernel
def fastCert10_9 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_9 : checkCertificateFast 10 9 fastCert10_9=true := by decide +kernel
def fastCert10_10 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_10 : checkCertificateFast 10 10 fastCert10_10=true := by decide +kernel
def fastCert10_11 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_11 : checkCertificateFast 10 11 fastCert10_11=true := by decide +kernel
def fastCert10_12 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_12 : checkCertificateFast 10 12 fastCert10_12=true := by decide +kernel
def fastCert10_13 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_13 : checkCertificateFast 10 13 fastCert10_13=true := by decide +kernel
def fastCert10_14 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_14 : checkCertificateFast 10 14 fastCert10_14=true := by decide +kernel
def fastCert10_15 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_15 : checkCertificateFast 10 15 fastCert10_15=true := by decide +kernel
def fastCert10_16 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_16 : checkCertificateFast 10 16 fastCert10_16=true := by decide +kernel
def fastCert10_17 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_17 : checkCertificateFast 10 17 fastCert10_17=true := by decide +kernel
def fastCert10_18 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_18 : checkCertificateFast 10 18 fastCert10_18=true := by decide +kernel
def fastCert10_19 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_19 : checkCertificateFast 10 19 fastCert10_19=true := by decide +kernel
def fastCert10_20 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_20 : checkCertificateFast 10 20 fastCert10_20=true := by decide +kernel
def fastCert10_21 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_21 : checkCertificateFast 10 21 fastCert10_21=true := by decide +kernel
def fastCert10_22 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_22 : checkCertificateFast 10 22 fastCert10_22=true := by decide +kernel
def fastCert10_23 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_23 : checkCertificateFast 10 23 fastCert10_23=true := by decide +kernel
def fastCert10_24 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_24 : checkCertificateFast 10 24 fastCert10_24=true := by decide +kernel
def fastCert10_25 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_25 : checkCertificateFast 10 25 fastCert10_25=true := by decide +kernel
def fastCert10_26 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_26 : checkCertificateFast 10 26 fastCert10_26=true := by decide +kernel
def fastCert10_27 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_27 : checkCertificateFast 10 27 fastCert10_27=true := by decide +kernel
def fastCert10_28 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_28 : checkCertificateFast 10 28 fastCert10_28=true := by decide +kernel
def fastCert10_29 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_29 : checkCertificateFast 10 29 fastCert10_29=true := by decide +kernel
def fastCert10_30 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_30 : checkCertificateFast 10 30 fastCert10_30=true := by decide +kernel
def fastCert10_31 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_31 : checkCertificateFast 10 31 fastCert10_31=true := by decide +kernel
def fastCert10_32 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_32 : checkCertificateFast 10 32 fastCert10_32=true := by decide +kernel
def fastCert10_33 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_33 : checkCertificateFast 10 33 fastCert10_33=true := by decide +kernel
def fastCert10_34 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_34 : checkCertificateFast 10 34 fastCert10_34=true := by decide +kernel
def fastCert10_35 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_35 : checkCertificateFast 10 35 fastCert10_35=true := by decide +kernel
def fastCert10_36 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_36 : checkCertificateFast 10 36 fastCert10_36=true := by decide +kernel
def fastCert10_37 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_37 : checkCertificateFast 10 37 fastCert10_37=true := by decide +kernel
def fastCert10_38 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_38 : checkCertificateFast 10 38 fastCert10_38=true := by decide +kernel
def fastCert10_39 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_39 : checkCertificateFast 10 39 fastCert10_39=true := by decide +kernel
def fastCert10_40 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_40 : checkCertificateFast 10 40 fastCert10_40=true := by decide +kernel
def fastCert10_41 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_41 : checkCertificateFast 10 41 fastCert10_41=true := by decide +kernel
def fastCert10_42 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_42 : checkCertificateFast 10 42 fastCert10_42=true := by decide +kernel
def fastCert10_43 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_43 : checkCertificateFast 10 43 fastCert10_43=true := by decide +kernel
def fastCert10_44 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_44 : checkCertificateFast 10 44 fastCert10_44=true := by decide +kernel
def fastCert10_45 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_45 : checkCertificateFast 10 45 fastCert10_45=true := by decide +kernel
def fastCert10_46 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_46 : checkCertificateFast 10 46 fastCert10_46=true := by decide +kernel
def fastCert10_47 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_47 : checkCertificateFast 10 47 fastCert10_47=true := by decide +kernel
def fastCert10_48 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_48 : checkCertificateFast 10 48 fastCert10_48=true := by decide +kernel
def fastCert10_49 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_49 : checkCertificateFast 10 49 fastCert10_49=true := by decide +kernel
def fastCert10_50 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_50 : checkCertificateFast 10 50 fastCert10_50=true := by decide +kernel
def fastCert10_51 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_51 : checkCertificateFast 10 51 fastCert10_51=true := by decide +kernel
def fastCert10_52 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_52 : checkCertificateFast 10 52 fastCert10_52=true := by decide +kernel
def fastCert10_53 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_53 : checkCertificateFast 10 53 fastCert10_53=true := by decide +kernel
def fastCert10_54 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_54 : checkCertificateFast 10 54 fastCert10_54=true := by decide +kernel
def fastCert10_55 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_55 : checkCertificateFast 10 55 fastCert10_55=true := by decide +kernel
def fastCert10_56 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_56 : checkCertificateFast 10 56 fastCert10_56=true := by decide +kernel
def fastCert10_57 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_57 : checkCertificateFast 10 57 fastCert10_57=true := by decide +kernel
def fastCert10_58 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_58 : checkCertificateFast 10 58 fastCert10_58=true := by decide +kernel
def fastCert10_59 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_59 : checkCertificateFast 10 59 fastCert10_59=true := by decide +kernel
def fastCert10_60 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_60 : checkCertificateFast 10 60 fastCert10_60=true := by decide +kernel
def fastCert10_61 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_61 : checkCertificateFast 10 61 fastCert10_61=true := by decide +kernel
def fastCert10_62 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_62 : checkCertificateFast 10 62 fastCert10_62=true := by decide +kernel
def fastCert10_63 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_63 : checkCertificateFast 10 63 fastCert10_63=true := by decide +kernel
def fastCert10_64 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_64 : checkCertificateFast 10 64 fastCert10_64=true := by decide +kernel
def fastCert10_65 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_65 : checkCertificateFast 10 65 fastCert10_65=true := by decide +kernel
def fastCert10_66 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_66 : checkCertificateFast 10 66 fastCert10_66=true := by decide +kernel
def fastCert10_67 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_67 : checkCertificateFast 10 67 fastCert10_67=true := by decide +kernel
def fastCert10_68 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_68 : checkCertificateFast 10 68 fastCert10_68=true := by decide +kernel
def fastCert10_69 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_69 : checkCertificateFast 10 69 fastCert10_69=true := by decide +kernel
def fastCert10_70 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_70 : checkCertificateFast 10 70 fastCert10_70=true := by decide +kernel
def fastCert10_71 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_71 : checkCertificateFast 10 71 fastCert10_71=true := by decide +kernel
def fastCert10_72 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_72 : checkCertificateFast 10 72 fastCert10_72=true := by decide +kernel
def fastCert10_73 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_73 : checkCertificateFast 10 73 fastCert10_73=true := by decide +kernel
def fastCert10_74 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_74 : checkCertificateFast 10 74 fastCert10_74=true := by decide +kernel
def fastCert10_75 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_75 : checkCertificateFast 10 75 fastCert10_75=true := by decide +kernel
def fastCert10_76 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_76 : checkCertificateFast 10 76 fastCert10_76=true := by decide +kernel
def fastCert10_77 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_77 : checkCertificateFast 10 77 fastCert10_77=true := by decide +kernel
def fastCert10_78 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_78 : checkCertificateFast 10 78 fastCert10_78=true := by decide +kernel
def fastCert10_79 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_79 : checkCertificateFast 10 79 fastCert10_79=true := by decide +kernel
def fastCert10_80 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_80 : checkCertificateFast 10 80 fastCert10_80=true := by decide +kernel
def fastCert10_81 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_81 : checkCertificateFast 10 81 fastCert10_81=true := by decide +kernel
def fastCert10_82 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-4) else 0⟩
theorem fastCase10_82 : checkCertificateFast 10 82 fastCert10_82=true := by decide +kernel
def fastCert10_83 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_83 : checkCertificateFast 10 83 fastCert10_83=true := by decide +kernel
def fastCert10_84 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_84 : checkCertificateFast 10 84 fastCert10_84=true := by decide +kernel
def fastCert10_85 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_85 : checkCertificateFast 10 85 fastCert10_85=true := by decide +kernel
def fastCert10_86 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_86 : checkCertificateFast 10 86 fastCert10_86=true := by decide +kernel
def fastCert10_87 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_87 : checkCertificateFast 10 87 fastCert10_87=true := by decide +kernel
def fastCert10_88 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_88 : checkCertificateFast 10 88 fastCert10_88=true := by decide +kernel
def fastCert10_89 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_89 : checkCertificateFast 10 89 fastCert10_89=true := by decide +kernel
def fastCert10_90 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_90 : checkCertificateFast 10 90 fastCert10_90=true := by decide +kernel
def fastCert10_91 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_91 : checkCertificateFast 10 91 fastCert10_91=true := by decide +kernel
def fastCert10_92 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_92 : checkCertificateFast 10 92 fastCert10_92=true := by decide +kernel
def fastCert10_93 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_93 : checkCertificateFast 10 93 fastCert10_93=true := by decide +kernel
def fastCert10_94 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_94 : checkCertificateFast 10 94 fastCert10_94=true := by decide +kernel
def fastCert10_95 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_95 : checkCertificateFast 10 95 fastCert10_95=true := by decide +kernel
def fastCert10_96 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_96 : checkCertificateFast 10 96 fastCert10_96=true := by decide +kernel
def fastCert10_97 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_97 : checkCertificateFast 10 97 fastCert10_97=true := by decide +kernel
def fastCert10_98 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_98 : checkCertificateFast 10 98 fastCert10_98=true := by decide +kernel
def fastCert10_99 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_99 : checkCertificateFast 10 99 fastCert10_99=true := by decide +kernel
def fastCert10_100 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_100 : checkCertificateFast 10 100 fastCert10_100=true := by decide +kernel
def fastCert10_101 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_101 : checkCertificateFast 10 101 fastCert10_101=true := by decide +kernel
def fastCert10_102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_102 : checkCertificateFast 10 102 fastCert10_102=true := by decide +kernel
def fastCert10_103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_103 : checkCertificateFast 10 103 fastCert10_103=true := by decide +kernel
def fastCert10_104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_104 : checkCertificateFast 10 104 fastCert10_104=true := by decide +kernel
def fastCert10_105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_105 : checkCertificateFast 10 105 fastCert10_105=true := by decide +kernel
def fastCert10_106 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_106 : checkCertificateFast 10 106 fastCert10_106=true := by decide +kernel
def fastCert10_107 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_107 : checkCertificateFast 10 107 fastCert10_107=true := by decide +kernel
def fastCert10_108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_108 : checkCertificateFast 10 108 fastCert10_108=true := by decide +kernel
def fastCert10_109 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_109 : checkCertificateFast 10 109 fastCert10_109=true := by decide +kernel
def fastCert10_110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_110 : checkCertificateFast 10 110 fastCert10_110=true := by decide +kernel
def fastCert10_111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_111 : checkCertificateFast 10 111 fastCert10_111=true := by decide +kernel
def fastCert10_112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_112 : checkCertificateFast 10 112 fastCert10_112=true := by decide +kernel
def fastCert10_113 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_113 : checkCertificateFast 10 113 fastCert10_113=true := by decide +kernel
def fastCert10_114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_114 : checkCertificateFast 10 114 fastCert10_114=true := by decide +kernel
def fastCert10_115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_115 : checkCertificateFast 10 115 fastCert10_115=true := by decide +kernel
def fastCert10_116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_116 : checkCertificateFast 10 116 fastCert10_116=true := by decide +kernel
def fastCert10_117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_117 : checkCertificateFast 10 117 fastCert10_117=true := by decide +kernel
def fastCert10_118 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_118 : checkCertificateFast 10 118 fastCert10_118=true := by decide +kernel
def fastCert10_119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_119 : checkCertificateFast 10 119 fastCert10_119=true := by decide +kernel
def fastCert10_120 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_120 : checkCertificateFast 10 120 fastCert10_120=true := by decide +kernel
def fastCert10_121 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_121 : checkCertificateFast 10 121 fastCert10_121=true := by decide +kernel
def fastCert10_122 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_122 : checkCertificateFast 10 122 fastCert10_122=true := by decide +kernel
def fastCert10_123 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_123 : checkCertificateFast 10 123 fastCert10_123=true := by decide +kernel
def fastCert10_124 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_124 : checkCertificateFast 10 124 fastCert10_124=true := by decide +kernel
def fastCert10_125 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_125 : checkCertificateFast 10 125 fastCert10_125=true := by decide +kernel
def fastCert10_126 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_126 : checkCertificateFast 10 126 fastCert10_126=true := by decide +kernel
def fastCert10_127 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_127 : checkCertificateFast 10 127 fastCert10_127=true := by decide +kernel
def fastCert10_128 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_128 : checkCertificateFast 10 128 fastCert10_128=true := by decide +kernel
def fastCert10_129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_129 : checkCertificateFast 10 129 fastCert10_129=true := by decide +kernel
def fastCert10_130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_130 : checkCertificateFast 10 130 fastCert10_130=true := by decide +kernel
def fastCert10_131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_131 : checkCertificateFast 10 131 fastCert10_131=true := by decide +kernel
def fastCert10_132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_132 : checkCertificateFast 10 132 fastCert10_132=true := by decide +kernel
def fastCert10_133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_133 : checkCertificateFast 10 133 fastCert10_133=true := by decide +kernel
def fastCert10_134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_134 : checkCertificateFast 10 134 fastCert10_134=true := by decide +kernel
def fastCert10_135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_135 : checkCertificateFast 10 135 fastCert10_135=true := by decide +kernel
def fastCert10_136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_136 : checkCertificateFast 10 136 fastCert10_136=true := by decide +kernel
def fastCert10_137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_137 : checkCertificateFast 10 137 fastCert10_137=true := by decide +kernel
def fastCert10_138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_138 : checkCertificateFast 10 138 fastCert10_138=true := by decide +kernel
def fastCert10_139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_139 : checkCertificateFast 10 139 fastCert10_139=true := by decide +kernel
def fastCert10_140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_140 : checkCertificateFast 10 140 fastCert10_140=true := by decide +kernel
def fastCert10_141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_141 : checkCertificateFast 10 141 fastCert10_141=true := by decide +kernel
def fastCert10_142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_142 : checkCertificateFast 10 142 fastCert10_142=true := by decide +kernel
def fastCert10_143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_143 : checkCertificateFast 10 143 fastCert10_143=true := by decide +kernel
def fastCert10_144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_144 : checkCertificateFast 10 144 fastCert10_144=true := by decide +kernel
def fastCert10_145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_145 : checkCertificateFast 10 145 fastCert10_145=true := by decide +kernel
def fastCert10_146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_146 : checkCertificateFast 10 146 fastCert10_146=true := by decide +kernel
def fastCert10_147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_147 : checkCertificateFast 10 147 fastCert10_147=true := by decide +kernel
def fastCert10_148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_148 : checkCertificateFast 10 148 fastCert10_148=true := by decide +kernel
def fastCert10_149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_149 : checkCertificateFast 10 149 fastCert10_149=true := by decide +kernel
def fastCert10_150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_150 : checkCertificateFast 10 150 fastCert10_150=true := by decide +kernel
def fastCert10_151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_151 : checkCertificateFast 10 151 fastCert10_151=true := by decide +kernel
def fastCert10_152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_152 : checkCertificateFast 10 152 fastCert10_152=true := by decide +kernel
def fastCert10_153 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_153 : checkCertificateFast 10 153 fastCert10_153=true := by decide +kernel
def fastCert10_154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_154 : checkCertificateFast 10 154 fastCert10_154=true := by decide +kernel
def fastCert10_155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_155 : checkCertificateFast 10 155 fastCert10_155=true := by decide +kernel
def fastCert10_156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_156 : checkCertificateFast 10 156 fastCert10_156=true := by decide +kernel
def fastCert10_157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_157 : checkCertificateFast 10 157 fastCert10_157=true := by decide +kernel
def fastCert10_158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_158 : checkCertificateFast 10 158 fastCert10_158=true := by decide +kernel
def fastCert10_159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_159 : checkCertificateFast 10 159 fastCert10_159=true := by decide +kernel
def fastCert10_160 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_160 : checkCertificateFast 10 160 fastCert10_160=true := by decide +kernel
def fastCert10_161 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_161 : checkCertificateFast 10 161 fastCert10_161=true := by decide +kernel
def fastCert10_162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_162 : checkCertificateFast 10 162 fastCert10_162=true := by decide +kernel
def fastCert10_163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_163 : checkCertificateFast 10 163 fastCert10_163=true := by decide +kernel
def fastCert10_164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_164 : checkCertificateFast 10 164 fastCert10_164=true := by decide +kernel
def fastCert10_165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_165 : checkCertificateFast 10 165 fastCert10_165=true := by decide +kernel
def fastCert10_166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_166 : checkCertificateFast 10 166 fastCert10_166=true := by decide +kernel
def fastCert10_167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_167 : checkCertificateFast 10 167 fastCert10_167=true := by decide +kernel
def fastCert10_168 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_168 : checkCertificateFast 10 168 fastCert10_168=true := by decide +kernel
def fastCert10_169 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_169 : checkCertificateFast 10 169 fastCert10_169=true := by decide +kernel
def fastCert10_170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_170 : checkCertificateFast 10 170 fastCert10_170=true := by decide +kernel
def fastCert10_171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_171 : checkCertificateFast 10 171 fastCert10_171=true := by decide +kernel
def fastCert10_172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_172 : checkCertificateFast 10 172 fastCert10_172=true := by decide +kernel
def fastCert10_173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_173 : checkCertificateFast 10 173 fastCert10_173=true := by decide +kernel
def fastCert10_174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_174 : checkCertificateFast 10 174 fastCert10_174=true := by decide +kernel
def fastCert10_175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_175 : checkCertificateFast 10 175 fastCert10_175=true := by decide +kernel
def fastCert10_176 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_176 : checkCertificateFast 10 176 fastCert10_176=true := by decide +kernel
def fastCert10_177 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_177 : checkCertificateFast 10 177 fastCert10_177=true := by decide +kernel
def fastCert10_178 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_178 : checkCertificateFast 10 178 fastCert10_178=true := by decide +kernel
def fastCert10_179 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_179 : checkCertificateFast 10 179 fastCert10_179=true := by decide +kernel
def fastCert10_180 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_180 : checkCertificateFast 10 180 fastCert10_180=true := by decide +kernel
def fastCert10_181 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_181 : checkCertificateFast 10 181 fastCert10_181=true := by decide +kernel
def fastCert10_182 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_182 : checkCertificateFast 10 182 fastCert10_182=true := by decide +kernel
def fastCert10_183 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_183 : checkCertificateFast 10 183 fastCert10_183=true := by decide +kernel
def fastCert10_184 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_184 : checkCertificateFast 10 184 fastCert10_184=true := by decide +kernel
def fastCert10_185 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_185 : checkCertificateFast 10 185 fastCert10_185=true := by decide +kernel
def fastCert10_186 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_186 : checkCertificateFast 10 186 fastCert10_186=true := by decide +kernel
def fastCert10_187 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_187 : checkCertificateFast 10 187 fastCert10_187=true := by decide +kernel
def fastCert10_188 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_188 : checkCertificateFast 10 188 fastCert10_188=true := by decide +kernel
def fastCert10_189 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_189 : checkCertificateFast 10 189 fastCert10_189=true := by decide +kernel
def fastCert10_190 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_190 : checkCertificateFast 10 190 fastCert10_190=true := by decide +kernel
def fastCert10_191 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_191 : checkCertificateFast 10 191 fastCert10_191=true := by decide +kernel
def fastCert10_192 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_192 : checkCertificateFast 10 192 fastCert10_192=true := by decide +kernel
def fastCert10_193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_193 : checkCertificateFast 10 193 fastCert10_193=true := by decide +kernel
def fastCert10_194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_194 : checkCertificateFast 10 194 fastCert10_194=true := by decide +kernel
def fastCert10_195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_195 : checkCertificateFast 10 195 fastCert10_195=true := by decide +kernel
def fastCert10_196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_196 : checkCertificateFast 10 196 fastCert10_196=true := by decide +kernel
def fastCert10_197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_197 : checkCertificateFast 10 197 fastCert10_197=true := by decide +kernel
def fastCert10_198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_198 : checkCertificateFast 10 198 fastCert10_198=true := by decide +kernel
def fastCert10_199 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_199 : checkCertificateFast 10 199 fastCert10_199=true := by decide +kernel
def fastCert10_200 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_200 : checkCertificateFast 10 200 fastCert10_200=true := by decide +kernel
def fastCert10_201 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_201 : checkCertificateFast 10 201 fastCert10_201=true := by decide +kernel
def fastCert10_202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_202 : checkCertificateFast 10 202 fastCert10_202=true := by decide +kernel
def fastCert10_203 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_203 : checkCertificateFast 10 203 fastCert10_203=true := by decide +kernel
def fastCert10_204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_204 : checkCertificateFast 10 204 fastCert10_204=true := by decide +kernel
def fastCert10_205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_205 : checkCertificateFast 10 205 fastCert10_205=true := by decide +kernel
def fastCert10_206 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_206 : checkCertificateFast 10 206 fastCert10_206=true := by decide +kernel
def fastCert10_207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_207 : checkCertificateFast 10 207 fastCert10_207=true := by decide +kernel
def fastCert10_208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_208 : checkCertificateFast 10 208 fastCert10_208=true := by decide +kernel
def fastCert10_209 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_209 : checkCertificateFast 10 209 fastCert10_209=true := by decide +kernel
def fastCert10_210 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_210 : checkCertificateFast 10 210 fastCert10_210=true := by decide +kernel
def fastCert10_211 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_211 : checkCertificateFast 10 211 fastCert10_211=true := by decide +kernel
def fastCert10_212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_212 : checkCertificateFast 10 212 fastCert10_212=true := by decide +kernel
def fastCert10_213 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_213 : checkCertificateFast 10 213 fastCert10_213=true := by decide +kernel
def fastCert10_214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_214 : checkCertificateFast 10 214 fastCert10_214=true := by decide +kernel
def fastCert10_215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_215 : checkCertificateFast 10 215 fastCert10_215=true := by decide +kernel
def fastCert10_216 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_216 : checkCertificateFast 10 216 fastCert10_216=true := by decide +kernel
def fastCert10_217 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_217 : checkCertificateFast 10 217 fastCert10_217=true := by decide +kernel
def fastCert10_218 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_218 : checkCertificateFast 10 218 fastCert10_218=true := by decide +kernel
def fastCert10_219 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_219 : checkCertificateFast 10 219 fastCert10_219=true := by decide +kernel
def fastCert10_220 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_220 : checkCertificateFast 10 220 fastCert10_220=true := by decide +kernel
def fastCert10_221 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_221 : checkCertificateFast 10 221 fastCert10_221=true := by decide +kernel
def fastCert10_222 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_222 : checkCertificateFast 10 222 fastCert10_222=true := by decide +kernel
def fastCert10_223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_223 : checkCertificateFast 10 223 fastCert10_223=true := by decide +kernel
def fastCert10_224 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_224 : checkCertificateFast 10 224 fastCert10_224=true := by decide +kernel
def fastCert10_225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_225 : checkCertificateFast 10 225 fastCert10_225=true := by decide +kernel
def fastCert10_226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_226 : checkCertificateFast 10 226 fastCert10_226=true := by decide +kernel
def fastCert10_227 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_227 : checkCertificateFast 10 227 fastCert10_227=true := by decide +kernel
def fastCert10_228 : Certificate := ⟨7,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_228 : checkCertificateFast 10 228 fastCert10_228=true := by decide +kernel
def fastCert10_229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_229 : checkCertificateFast 10 229 fastCert10_229=true := by decide +kernel
def fastCert10_230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_230 : checkCertificateFast 10 230 fastCert10_230=true := by decide +kernel
def fastCert10_231 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_231 : checkCertificateFast 10 231 fastCert10_231=true := by decide +kernel
def fastCert10_232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_232 : checkCertificateFast 10 232 fastCert10_232=true := by decide +kernel
def fastCert10_233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_233 : checkCertificateFast 10 233 fastCert10_233=true := by decide +kernel
def fastCert10_234 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_234 : checkCertificateFast 10 234 fastCert10_234=true := by decide +kernel
def fastCert10_235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_235 : checkCertificateFast 10 235 fastCert10_235=true := by decide +kernel
def fastCert10_236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_236 : checkCertificateFast 10 236 fastCert10_236=true := by decide +kernel
def fastCert10_237 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_237 : checkCertificateFast 10 237 fastCert10_237=true := by decide +kernel
def fastCert10_238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_238 : checkCertificateFast 10 238 fastCert10_238=true := by decide +kernel
def fastCert10_239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_239 : checkCertificateFast 10 239 fastCert10_239=true := by decide +kernel
def fastCert10_240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_240 : checkCertificateFast 10 240 fastCert10_240=true := by decide +kernel
def fastCert10_241 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_241 : checkCertificateFast 10 241 fastCert10_241=true := by decide +kernel
def fastCert10_242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_242 : checkCertificateFast 10 242 fastCert10_242=true := by decide +kernel
def fastCert10_243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_243 : checkCertificateFast 10 243 fastCert10_243=true := by decide +kernel
def fastCert10_244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_244 : checkCertificateFast 10 244 fastCert10_244=true := by decide +kernel
def fastCert10_245 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_245 : checkCertificateFast 10 245 fastCert10_245=true := by decide +kernel
def fastCert10_246 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_246 : checkCertificateFast 10 246 fastCert10_246=true := by decide +kernel
def fastCert10_247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_247 : checkCertificateFast 10 247 fastCert10_247=true := by decide +kernel
def fastCert10_248 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_248 : checkCertificateFast 10 248 fastCert10_248=true := by decide +kernel
def fastCert10_249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_249 : checkCertificateFast 10 249 fastCert10_249=true := by decide +kernel
def fastCert10_250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_250 : checkCertificateFast 10 250 fastCert10_250=true := by decide +kernel
def fastCert10_251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_251 : checkCertificateFast 10 251 fastCert10_251=true := by decide +kernel
def fastCert10_252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_252 : checkCertificateFast 10 252 fastCert10_252=true := by decide +kernel
def fastCert10_253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_253 : checkCertificateFast 10 253 fastCert10_253=true := by decide +kernel
def fastCert10_254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_254 : checkCertificateFast 10 254 fastCert10_254=true := by decide +kernel
def fastCert10_255 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_255 : checkCertificateFast 10 255 fastCert10_255=true := by decide +kernel
def fastCert10_256 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_256 : checkCertificateFast 10 256 fastCert10_256=true := by decide +kernel
def fastCert10_257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_257 : checkCertificateFast 10 257 fastCert10_257=true := by decide +kernel
def fastCert10_258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_258 : checkCertificateFast 10 258 fastCert10_258=true := by decide +kernel
def fastCert10_259 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_259 : checkCertificateFast 10 259 fastCert10_259=true := by decide +kernel
def fastCert10_260 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_260 : checkCertificateFast 10 260 fastCert10_260=true := by decide +kernel
def fastCert10_261 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_261 : checkCertificateFast 10 261 fastCert10_261=true := by decide +kernel
def fastCert10_262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_262 : checkCertificateFast 10 262 fastCert10_262=true := by decide +kernel
def fastCert10_263 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_263 : checkCertificateFast 10 263 fastCert10_263=true := by decide +kernel
def fastCert10_264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_264 : checkCertificateFast 10 264 fastCert10_264=true := by decide +kernel
def fastCert10_265 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_265 : checkCertificateFast 10 265 fastCert10_265=true := by decide +kernel
def fastCert10_266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_266 : checkCertificateFast 10 266 fastCert10_266=true := by decide +kernel
def fastCert10_267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_267 : checkCertificateFast 10 267 fastCert10_267=true := by decide +kernel
def fastCert10_268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_268 : checkCertificateFast 10 268 fastCert10_268=true := by decide +kernel
def fastCert10_269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_269 : checkCertificateFast 10 269 fastCert10_269=true := by decide +kernel
def fastCert10_270 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_270 : checkCertificateFast 10 270 fastCert10_270=true := by decide +kernel
def fastCert10_271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_271 : checkCertificateFast 10 271 fastCert10_271=true := by decide +kernel
def fastCert10_272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_272 : checkCertificateFast 10 272 fastCert10_272=true := by decide +kernel
def fastCert10_273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_273 : checkCertificateFast 10 273 fastCert10_273=true := by decide +kernel
def fastCert10_274 : Certificate := ⟨13,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_274 : checkCertificateFast 10 274 fastCert10_274=true := by decide +kernel
def fastCert10_275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_275 : checkCertificateFast 10 275 fastCert10_275=true := by decide +kernel
def fastCert10_276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_276 : checkCertificateFast 10 276 fastCert10_276=true := by decide +kernel
def fastCert10_277 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_277 : checkCertificateFast 10 277 fastCert10_277=true := by decide +kernel
def fastCert10_278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_278 : checkCertificateFast 10 278 fastCert10_278=true := by decide +kernel
def fastCert10_279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_279 : checkCertificateFast 10 279 fastCert10_279=true := by decide +kernel
def fastCert10_280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_280 : checkCertificateFast 10 280 fastCert10_280=true := by decide +kernel
def fastCert10_281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_281 : checkCertificateFast 10 281 fastCert10_281=true := by decide +kernel
def fastCert10_282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_282 : checkCertificateFast 10 282 fastCert10_282=true := by decide +kernel
def fastCert10_283 : Certificate := ⟨13,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_283 : checkCertificateFast 10 283 fastCert10_283=true := by decide +kernel
def fastCert10_284 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_284 : checkCertificateFast 10 284 fastCert10_284=true := by decide +kernel
def fastCert10_285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_285 : checkCertificateFast 10 285 fastCert10_285=true := by decide +kernel
def fastCert10_286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_286 : checkCertificateFast 10 286 fastCert10_286=true := by decide +kernel
def fastCert10_287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_287 : checkCertificateFast 10 287 fastCert10_287=true := by decide +kernel
def fastCert10_288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_288 : checkCertificateFast 10 288 fastCert10_288=true := by decide +kernel
def fastCert10_289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_289 : checkCertificateFast 10 289 fastCert10_289=true := by decide +kernel
def fastCert10_290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_290 : checkCertificateFast 10 290 fastCert10_290=true := by decide +kernel
def fastCert10_291 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_291 : checkCertificateFast 10 291 fastCert10_291=true := by decide +kernel
def fastCert10_292 : Certificate := ⟨8,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_292 : checkCertificateFast 10 292 fastCert10_292=true := by decide +kernel
def fastCert10_293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_293 : checkCertificateFast 10 293 fastCert10_293=true := by decide +kernel
def fastCert10_294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_294 : checkCertificateFast 10 294 fastCert10_294=true := by decide +kernel
def fastCert10_295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_295 : checkCertificateFast 10 295 fastCert10_295=true := by decide +kernel
def fastCert10_296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_296 : checkCertificateFast 10 296 fastCert10_296=true := by decide +kernel
def fastCert10_297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_297 : checkCertificateFast 10 297 fastCert10_297=true := by decide +kernel
def fastCert10_298 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_298 : checkCertificateFast 10 298 fastCert10_298=true := by decide +kernel
def fastCert10_299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_299 : checkCertificateFast 10 299 fastCert10_299=true := by decide +kernel
def fastCert10_300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_300 : checkCertificateFast 10 300 fastCert10_300=true := by decide +kernel
def fastCert10_301 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_301 : checkCertificateFast 10 301 fastCert10_301=true := by decide +kernel
def fastCert10_302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_302 : checkCertificateFast 10 302 fastCert10_302=true := by decide +kernel
def fastCert10_303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_303 : checkCertificateFast 10 303 fastCert10_303=true := by decide +kernel
def fastCert10_304 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_304 : checkCertificateFast 10 304 fastCert10_304=true := by decide +kernel
def fastCert10_305 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_305 : checkCertificateFast 10 305 fastCert10_305=true := by decide +kernel
def fastCert10_306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_306 : checkCertificateFast 10 306 fastCert10_306=true := by decide +kernel
def fastCert10_307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_307 : checkCertificateFast 10 307 fastCert10_307=true := by decide +kernel
def fastCert10_308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_308 : checkCertificateFast 10 308 fastCert10_308=true := by decide +kernel
def fastCert10_309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_309 : checkCertificateFast 10 309 fastCert10_309=true := by decide +kernel
def fastCert10_310 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_310 : checkCertificateFast 10 310 fastCert10_310=true := by decide +kernel
def fastCert10_311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_311 : checkCertificateFast 10 311 fastCert10_311=true := by decide +kernel
def fastCert10_312 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_312 : checkCertificateFast 10 312 fastCert10_312=true := by decide +kernel
def fastCert10_313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_313 : checkCertificateFast 10 313 fastCert10_313=true := by decide +kernel
def fastCert10_314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_314 : checkCertificateFast 10 314 fastCert10_314=true := by decide +kernel
def fastCert10_315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_315 : checkCertificateFast 10 315 fastCert10_315=true := by decide +kernel
def fastCert10_316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_316 : checkCertificateFast 10 316 fastCert10_316=true := by decide +kernel
def fastCert10_317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_317 : checkCertificateFast 10 317 fastCert10_317=true := by decide +kernel
def fastCert10_318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_318 : checkCertificateFast 10 318 fastCert10_318=true := by decide +kernel
def fastCert10_319 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_319 : checkCertificateFast 10 319 fastCert10_319=true := by decide +kernel
def fastCert10_320 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_320 : checkCertificateFast 10 320 fastCert10_320=true := by decide +kernel
def fastCert10_321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_321 : checkCertificateFast 10 321 fastCert10_321=true := by decide +kernel
def fastCert10_322 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_322 : checkCertificateFast 10 322 fastCert10_322=true := by decide +kernel
def fastCert10_323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_323 : checkCertificateFast 10 323 fastCert10_323=true := by decide +kernel
def fastCert10_324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_324 : checkCertificateFast 10 324 fastCert10_324=true := by decide +kernel
def fastCert10_325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_325 : checkCertificateFast 10 325 fastCert10_325=true := by decide +kernel
def fastCert10_326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_326 : checkCertificateFast 10 326 fastCert10_326=true := by decide +kernel
def fastCert10_327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_327 : checkCertificateFast 10 327 fastCert10_327=true := by decide +kernel
def fastCert10_328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_328 : checkCertificateFast 10 328 fastCert10_328=true := by decide +kernel
def fastCert10_329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_329 : checkCertificateFast 10 329 fastCert10_329=true := by decide +kernel
def fastCert10_330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_330 : checkCertificateFast 10 330 fastCert10_330=true := by decide +kernel
def fastCert10_331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_331 : checkCertificateFast 10 331 fastCert10_331=true := by decide +kernel
def fastCert10_332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_332 : checkCertificateFast 10 332 fastCert10_332=true := by decide +kernel
def fastCert10_333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_333 : checkCertificateFast 10 333 fastCert10_333=true := by decide +kernel
def fastCert10_334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_334 : checkCertificateFast 10 334 fastCert10_334=true := by decide +kernel
def fastCert10_335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_335 : checkCertificateFast 10 335 fastCert10_335=true := by decide +kernel
def fastCert10_336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_336 : checkCertificateFast 10 336 fastCert10_336=true := by decide +kernel
def fastCert10_337 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_337 : checkCertificateFast 10 337 fastCert10_337=true := by decide +kernel
def fastCert10_338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_338 : checkCertificateFast 10 338 fastCert10_338=true := by decide +kernel
def fastCert10_339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_339 : checkCertificateFast 10 339 fastCert10_339=true := by decide +kernel
def fastCert10_340 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_340 : checkCertificateFast 10 340 fastCert10_340=true := by decide +kernel
def fastCert10_341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_341 : checkCertificateFast 10 341 fastCert10_341=true := by decide +kernel
def fastCert10_342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_342 : checkCertificateFast 10 342 fastCert10_342=true := by decide +kernel
def fastCert10_343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_343 : checkCertificateFast 10 343 fastCert10_343=true := by decide +kernel
def fastCert10_344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_344 : checkCertificateFast 10 344 fastCert10_344=true := by decide +kernel
def fastCert10_345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_345 : checkCertificateFast 10 345 fastCert10_345=true := by decide +kernel
def fastCert10_346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_346 : checkCertificateFast 10 346 fastCert10_346=true := by decide +kernel
def fastCert10_347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_347 : checkCertificateFast 10 347 fastCert10_347=true := by decide +kernel
def fastCert10_348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_348 : checkCertificateFast 10 348 fastCert10_348=true := by decide +kernel
def fastCert10_349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_349 : checkCertificateFast 10 349 fastCert10_349=true := by decide +kernel
def fastCert10_350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_350 : checkCertificateFast 10 350 fastCert10_350=true := by decide +kernel
def fastCert10_351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_351 : checkCertificateFast 10 351 fastCert10_351=true := by decide +kernel
def fastCert10_352 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_352 : checkCertificateFast 10 352 fastCert10_352=true := by decide +kernel
def fastCert10_353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_353 : checkCertificateFast 10 353 fastCert10_353=true := by decide +kernel
def fastCert10_354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_354 : checkCertificateFast 10 354 fastCert10_354=true := by decide +kernel
def fastCert10_355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_355 : checkCertificateFast 10 355 fastCert10_355=true := by decide +kernel
def fastCert10_356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_356 : checkCertificateFast 10 356 fastCert10_356=true := by decide +kernel
def fastCert10_357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_357 : checkCertificateFast 10 357 fastCert10_357=true := by decide +kernel
def fastCert10_358 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_358 : checkCertificateFast 10 358 fastCert10_358=true := by decide +kernel
def fastCert10_359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_359 : checkCertificateFast 10 359 fastCert10_359=true := by decide +kernel
def fastCert10_360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_360 : checkCertificateFast 10 360 fastCert10_360=true := by decide +kernel
def fastCert10_361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_361 : checkCertificateFast 10 361 fastCert10_361=true := by decide +kernel
def fastCert10_362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_362 : checkCertificateFast 10 362 fastCert10_362=true := by decide +kernel
def fastCert10_363 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_363 : checkCertificateFast 10 363 fastCert10_363=true := by decide +kernel
def fastCert10_364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_364 : checkCertificateFast 10 364 fastCert10_364=true := by decide +kernel
def fastCert10_365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_365 : checkCertificateFast 10 365 fastCert10_365=true := by decide +kernel
def fastCert10_366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_366 : checkCertificateFast 10 366 fastCert10_366=true := by decide +kernel
def fastCert10_367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_367 : checkCertificateFast 10 367 fastCert10_367=true := by decide +kernel
def fastCert10_368 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_368 : checkCertificateFast 10 368 fastCert10_368=true := by decide +kernel
def fastCert10_369 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_369 : checkCertificateFast 10 369 fastCert10_369=true := by decide +kernel
def fastCert10_370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_370 : checkCertificateFast 10 370 fastCert10_370=true := by decide +kernel
def fastCert10_371 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_371 : checkCertificateFast 10 371 fastCert10_371=true := by decide +kernel
def fastCert10_372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_372 : checkCertificateFast 10 372 fastCert10_372=true := by decide +kernel
def fastCert10_373 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_373 : checkCertificateFast 10 373 fastCert10_373=true := by decide +kernel
def fastCert10_374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_374 : checkCertificateFast 10 374 fastCert10_374=true := by decide +kernel
def fastCert10_375 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_375 : checkCertificateFast 10 375 fastCert10_375=true := by decide +kernel
def fastCert10_376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_376 : checkCertificateFast 10 376 fastCert10_376=true := by decide +kernel
def fastCert10_377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_377 : checkCertificateFast 10 377 fastCert10_377=true := by decide +kernel
def fastCert10_378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_378 : checkCertificateFast 10 378 fastCert10_378=true := by decide +kernel
def fastCert10_379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_379 : checkCertificateFast 10 379 fastCert10_379=true := by decide +kernel
def fastCert10_380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_380 : checkCertificateFast 10 380 fastCert10_380=true := by decide +kernel
def fastCert10_381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_381 : checkCertificateFast 10 381 fastCert10_381=true := by decide +kernel
def fastCert10_382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_382 : checkCertificateFast 10 382 fastCert10_382=true := by decide +kernel
def fastCert10_383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_383 : checkCertificateFast 10 383 fastCert10_383=true := by decide +kernel
def fastCert10_384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_384 : checkCertificateFast 10 384 fastCert10_384=true := by decide +kernel
def fastCert10_385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_385 : checkCertificateFast 10 385 fastCert10_385=true := by decide +kernel
def fastCert10_386 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_386 : checkCertificateFast 10 386 fastCert10_386=true := by decide +kernel
def fastCert10_387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_387 : checkCertificateFast 10 387 fastCert10_387=true := by decide +kernel
def fastCert10_388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_388 : checkCertificateFast 10 388 fastCert10_388=true := by decide +kernel
def fastCert10_389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_389 : checkCertificateFast 10 389 fastCert10_389=true := by decide +kernel
def fastCert10_390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_390 : checkCertificateFast 10 390 fastCert10_390=true := by decide +kernel
def fastCert10_391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_391 : checkCertificateFast 10 391 fastCert10_391=true := by decide +kernel
def fastCert10_392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_392 : checkCertificateFast 10 392 fastCert10_392=true := by decide +kernel
def fastCert10_393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_393 : checkCertificateFast 10 393 fastCert10_393=true := by decide +kernel
def fastCert10_394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_394 : checkCertificateFast 10 394 fastCert10_394=true := by decide +kernel
def fastCert10_395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_395 : checkCertificateFast 10 395 fastCert10_395=true := by decide +kernel
def fastCert10_396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_396 : checkCertificateFast 10 396 fastCert10_396=true := by decide +kernel
def fastCert10_397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_397 : checkCertificateFast 10 397 fastCert10_397=true := by decide +kernel
def fastCert10_398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_398 : checkCertificateFast 10 398 fastCert10_398=true := by decide +kernel
def fastCert10_399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_399 : checkCertificateFast 10 399 fastCert10_399=true := by decide +kernel
def fastCert10_400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_400 : checkCertificateFast 10 400 fastCert10_400=true := by decide +kernel
def fastCert10_401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_401 : checkCertificateFast 10 401 fastCert10_401=true := by decide +kernel
def fastCert10_402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_402 : checkCertificateFast 10 402 fastCert10_402=true := by decide +kernel
def fastCert10_403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_403 : checkCertificateFast 10 403 fastCert10_403=true := by decide +kernel
def fastCert10_404 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_404 : checkCertificateFast 10 404 fastCert10_404=true := by decide +kernel
def fastCert10_405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_405 : checkCertificateFast 10 405 fastCert10_405=true := by decide +kernel
def fastCert10_406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_406 : checkCertificateFast 10 406 fastCert10_406=true := by decide +kernel
def fastCert10_407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_407 : checkCertificateFast 10 407 fastCert10_407=true := by decide +kernel
def fastCert10_408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_408 : checkCertificateFast 10 408 fastCert10_408=true := by decide +kernel
def fastCert10_409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_409 : checkCertificateFast 10 409 fastCert10_409=true := by decide +kernel
def fastCert10_410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_410 : checkCertificateFast 10 410 fastCert10_410=true := by decide +kernel
def fastCert10_411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_411 : checkCertificateFast 10 411 fastCert10_411=true := by decide +kernel
def fastCert10_412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_412 : checkCertificateFast 10 412 fastCert10_412=true := by decide +kernel
def fastCert10_413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_413 : checkCertificateFast 10 413 fastCert10_413=true := by decide +kernel
def fastCert10_414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_414 : checkCertificateFast 10 414 fastCert10_414=true := by decide +kernel
def fastCert10_415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_415 : checkCertificateFast 10 415 fastCert10_415=true := by decide +kernel
def fastCert10_416 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_416 : checkCertificateFast 10 416 fastCert10_416=true := by decide +kernel
def fastCert10_417 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_417 : checkCertificateFast 10 417 fastCert10_417=true := by decide +kernel
def fastCert10_418 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_418 : checkCertificateFast 10 418 fastCert10_418=true := by decide +kernel
def fastCert10_419 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_419 : checkCertificateFast 10 419 fastCert10_419=true := by decide +kernel
def fastCert10_420 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_420 : checkCertificateFast 10 420 fastCert10_420=true := by decide +kernel
def fastCert10_421 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_421 : checkCertificateFast 10 421 fastCert10_421=true := by decide +kernel
def fastCert10_422 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_422 : checkCertificateFast 10 422 fastCert10_422=true := by decide +kernel
def fastCert10_423 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_423 : checkCertificateFast 10 423 fastCert10_423=true := by decide +kernel
def fastCert10_424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_424 : checkCertificateFast 10 424 fastCert10_424=true := by decide +kernel
def fastCert10_425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_425 : checkCertificateFast 10 425 fastCert10_425=true := by decide +kernel
def fastCert10_426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_426 : checkCertificateFast 10 426 fastCert10_426=true := by decide +kernel
def fastCert10_427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_427 : checkCertificateFast 10 427 fastCert10_427=true := by decide +kernel
def fastCert10_428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_428 : checkCertificateFast 10 428 fastCert10_428=true := by decide +kernel
def fastCert10_429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_429 : checkCertificateFast 10 429 fastCert10_429=true := by decide +kernel
def fastCert10_430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_430 : checkCertificateFast 10 430 fastCert10_430=true := by decide +kernel
def fastCert10_431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_431 : checkCertificateFast 10 431 fastCert10_431=true := by decide +kernel
def fastCert10_432 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_432 : checkCertificateFast 10 432 fastCert10_432=true := by decide +kernel
def fastCert10_433 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_433 : checkCertificateFast 10 433 fastCert10_433=true := by decide +kernel
def fastCert10_434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_434 : checkCertificateFast 10 434 fastCert10_434=true := by decide +kernel
def fastCert10_435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_435 : checkCertificateFast 10 435 fastCert10_435=true := by decide +kernel
def fastCert10_436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_436 : checkCertificateFast 10 436 fastCert10_436=true := by decide +kernel
def fastCert10_437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_437 : checkCertificateFast 10 437 fastCert10_437=true := by decide +kernel
def fastCert10_438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_438 : checkCertificateFast 10 438 fastCert10_438=true := by decide +kernel
def fastCert10_439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_439 : checkCertificateFast 10 439 fastCert10_439=true := by decide +kernel
def fastCert10_440 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_440 : checkCertificateFast 10 440 fastCert10_440=true := by decide +kernel
def fastCert10_441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_441 : checkCertificateFast 10 441 fastCert10_441=true := by decide +kernel
def fastCert10_442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_442 : checkCertificateFast 10 442 fastCert10_442=true := by decide +kernel
def fastCert10_443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_443 : checkCertificateFast 10 443 fastCert10_443=true := by decide +kernel
def fastCert10_444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_444 : checkCertificateFast 10 444 fastCert10_444=true := by decide +kernel
def fastCert10_445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_445 : checkCertificateFast 10 445 fastCert10_445=true := by decide +kernel
def fastCert10_446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_446 : checkCertificateFast 10 446 fastCert10_446=true := by decide +kernel
def fastCert10_447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_447 : checkCertificateFast 10 447 fastCert10_447=true := by decide +kernel
def fastCert10_448 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_448 : checkCertificateFast 10 448 fastCert10_448=true := by decide +kernel
def fastCert10_449 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_449 : checkCertificateFast 10 449 fastCert10_449=true := by decide +kernel
def fastCert10_450 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_450 : checkCertificateFast 10 450 fastCert10_450=true := by decide +kernel
def fastCert10_451 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_451 : checkCertificateFast 10 451 fastCert10_451=true := by decide +kernel
def fastCert10_452 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_452 : checkCertificateFast 10 452 fastCert10_452=true := by decide +kernel
def fastCert10_453 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_453 : checkCertificateFast 10 453 fastCert10_453=true := by decide +kernel
def fastCert10_454 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_454 : checkCertificateFast 10 454 fastCert10_454=true := by decide +kernel
def fastCert10_455 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_455 : checkCertificateFast 10 455 fastCert10_455=true := by decide +kernel
def fastCert10_456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_456 : checkCertificateFast 10 456 fastCert10_456=true := by decide +kernel
def fastCert10_457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_457 : checkCertificateFast 10 457 fastCert10_457=true := by decide +kernel
def fastCert10_458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_458 : checkCertificateFast 10 458 fastCert10_458=true := by decide +kernel
def fastCert10_459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_459 : checkCertificateFast 10 459 fastCert10_459=true := by decide +kernel
def fastCert10_460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_460 : checkCertificateFast 10 460 fastCert10_460=true := by decide +kernel
def fastCert10_461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_461 : checkCertificateFast 10 461 fastCert10_461=true := by decide +kernel
def fastCert10_462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_462 : checkCertificateFast 10 462 fastCert10_462=true := by decide +kernel
def fastCert10_463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_463 : checkCertificateFast 10 463 fastCert10_463=true := by decide +kernel
def fastCert10_464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_464 : checkCertificateFast 10 464 fastCert10_464=true := by decide +kernel
def fastCert10_465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_465 : checkCertificateFast 10 465 fastCert10_465=true := by decide +kernel
def fastCert10_466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_466 : checkCertificateFast 10 466 fastCert10_466=true := by decide +kernel
def fastCert10_467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_467 : checkCertificateFast 10 467 fastCert10_467=true := by decide +kernel
def fastCert10_468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_468 : checkCertificateFast 10 468 fastCert10_468=true := by decide +kernel
def fastCert10_469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_469 : checkCertificateFast 10 469 fastCert10_469=true := by decide +kernel
def fastCert10_470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_470 : checkCertificateFast 10 470 fastCert10_470=true := by decide +kernel
def fastCert10_471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_471 : checkCertificateFast 10 471 fastCert10_471=true := by decide +kernel
def fastCert10_472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_472 : checkCertificateFast 10 472 fastCert10_472=true := by decide +kernel
def fastCert10_473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_473 : checkCertificateFast 10 473 fastCert10_473=true := by decide +kernel
def fastCert10_474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_474 : checkCertificateFast 10 474 fastCert10_474=true := by decide +kernel
def fastCert10_475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_475 : checkCertificateFast 10 475 fastCert10_475=true := by decide +kernel
def fastCert10_476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_476 : checkCertificateFast 10 476 fastCert10_476=true := by decide +kernel
def fastCert10_477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_477 : checkCertificateFast 10 477 fastCert10_477=true := by decide +kernel
def fastCert10_478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_478 : checkCertificateFast 10 478 fastCert10_478=true := by decide +kernel
def fastCert10_479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_479 : checkCertificateFast 10 479 fastCert10_479=true := by decide +kernel
def fastCert10_480 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_480 : checkCertificateFast 10 480 fastCert10_480=true := by decide +kernel
def fastCert10_481 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_481 : checkCertificateFast 10 481 fastCert10_481=true := by decide +kernel
def fastCert10_482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_482 : checkCertificateFast 10 482 fastCert10_482=true := by decide +kernel
def fastCert10_483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_483 : checkCertificateFast 10 483 fastCert10_483=true := by decide +kernel
def fastCert10_484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_484 : checkCertificateFast 10 484 fastCert10_484=true := by decide +kernel
def fastCert10_485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_485 : checkCertificateFast 10 485 fastCert10_485=true := by decide +kernel
def fastCert10_486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_486 : checkCertificateFast 10 486 fastCert10_486=true := by decide +kernel
def fastCert10_487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_487 : checkCertificateFast 10 487 fastCert10_487=true := by decide +kernel
def fastCert10_488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_488 : checkCertificateFast 10 488 fastCert10_488=true := by decide +kernel
def fastCert10_489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_489 : checkCertificateFast 10 489 fastCert10_489=true := by decide +kernel
def fastCert10_490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_490 : checkCertificateFast 10 490 fastCert10_490=true := by decide +kernel
def fastCert10_491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_491 : checkCertificateFast 10 491 fastCert10_491=true := by decide +kernel
def fastCert10_492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_492 : checkCertificateFast 10 492 fastCert10_492=true := by decide +kernel
def fastCert10_493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_493 : checkCertificateFast 10 493 fastCert10_493=true := by decide +kernel
def fastCert10_494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_494 : checkCertificateFast 10 494 fastCert10_494=true := by decide +kernel
def fastCert10_495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_495 : checkCertificateFast 10 495 fastCert10_495=true := by decide +kernel
def fastCert10_496 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_496 : checkCertificateFast 10 496 fastCert10_496=true := by decide +kernel
def fastCert10_497 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-3) else 0⟩
theorem fastCase10_497 : checkCertificateFast 10 497 fastCert10_497=true := by decide +kernel
def fastCert10_498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_498 : checkCertificateFast 10 498 fastCert10_498=true := by decide +kernel
def fastCert10_499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_499 : checkCertificateFast 10 499 fastCert10_499=true := by decide +kernel
def fastCert10_500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_500 : checkCertificateFast 10 500 fastCert10_500=true := by decide +kernel
def fastCert10_501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_501 : checkCertificateFast 10 501 fastCert10_501=true := by decide +kernel
def fastCert10_502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_502 : checkCertificateFast 10 502 fastCert10_502=true := by decide +kernel
def fastCert10_503 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_503 : checkCertificateFast 10 503 fastCert10_503=true := by decide +kernel
def fastCert10_504 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_504 : checkCertificateFast 10 504 fastCert10_504=true := by decide +kernel
def fastCert10_505 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_505 : checkCertificateFast 10 505 fastCert10_505=true := by decide +kernel
def fastCert10_506 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_506 : checkCertificateFast 10 506 fastCert10_506=true := by decide +kernel
def fastCert10_507 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_507 : checkCertificateFast 10 507 fastCert10_507=true := by decide +kernel
def fastCert10_508 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_508 : checkCertificateFast 10 508 fastCert10_508=true := by decide +kernel
def fastCert10_509 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_509 : checkCertificateFast 10 509 fastCert10_509=true := by decide +kernel
def fastCert10_510 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_510 : checkCertificateFast 10 510 fastCert10_510=true := by decide +kernel
def fastCert10_511 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_511 : checkCertificateFast 10 511 fastCert10_511=true := by decide +kernel
def fastCert10_512 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_512 : checkCertificateFast 10 512 fastCert10_512=true := by decide +kernel
def fastCert10_513 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_513 : checkCertificateFast 10 513 fastCert10_513=true := by decide +kernel
def fastCert10_514 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_514 : checkCertificateFast 10 514 fastCert10_514=true := by decide +kernel
def fastCert10_515 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_515 : checkCertificateFast 10 515 fastCert10_515=true := by decide +kernel
def fastCert10_516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_516 : checkCertificateFast 10 516 fastCert10_516=true := by decide +kernel
def fastCert10_517 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_517 : checkCertificateFast 10 517 fastCert10_517=true := by decide +kernel
def fastCert10_518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_518 : checkCertificateFast 10 518 fastCert10_518=true := by decide +kernel
def fastCert10_519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_519 : checkCertificateFast 10 519 fastCert10_519=true := by decide +kernel
def fastCert10_520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_520 : checkCertificateFast 10 520 fastCert10_520=true := by decide +kernel
def fastCert10_521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_521 : checkCertificateFast 10 521 fastCert10_521=true := by decide +kernel
def fastCert10_522 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_522 : checkCertificateFast 10 522 fastCert10_522=true := by decide +kernel
def fastCert10_523 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_523 : checkCertificateFast 10 523 fastCert10_523=true := by decide +kernel
def fastCert10_524 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_524 : checkCertificateFast 10 524 fastCert10_524=true := by decide +kernel
def fastCert10_525 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_525 : checkCertificateFast 10 525 fastCert10_525=true := by decide +kernel
def fastCert10_526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_526 : checkCertificateFast 10 526 fastCert10_526=true := by decide +kernel
def fastCert10_527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_527 : checkCertificateFast 10 527 fastCert10_527=true := by decide +kernel
def fastCert10_528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_528 : checkCertificateFast 10 528 fastCert10_528=true := by decide +kernel
def fastCert10_529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_529 : checkCertificateFast 10 529 fastCert10_529=true := by decide +kernel
def fastCert10_530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_530 : checkCertificateFast 10 530 fastCert10_530=true := by decide +kernel
def fastCert10_531 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_531 : checkCertificateFast 10 531 fastCert10_531=true := by decide +kernel
def fastCert10_532 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_532 : checkCertificateFast 10 532 fastCert10_532=true := by decide +kernel
def fastCert10_533 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_533 : checkCertificateFast 10 533 fastCert10_533=true := by decide +kernel
def fastCert10_534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_534 : checkCertificateFast 10 534 fastCert10_534=true := by decide +kernel
def fastCert10_535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_535 : checkCertificateFast 10 535 fastCert10_535=true := by decide +kernel
def fastCert10_536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_536 : checkCertificateFast 10 536 fastCert10_536=true := by decide +kernel
def fastCert10_537 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_537 : checkCertificateFast 10 537 fastCert10_537=true := by decide +kernel
def fastCert10_538 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_538 : checkCertificateFast 10 538 fastCert10_538=true := by decide +kernel
def fastCert10_539 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_539 : checkCertificateFast 10 539 fastCert10_539=true := by decide +kernel
def fastCert10_540 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_540 : checkCertificateFast 10 540 fastCert10_540=true := by decide +kernel
def fastCert10_541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_541 : checkCertificateFast 10 541 fastCert10_541=true := by decide +kernel
def fastCert10_542 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_542 : checkCertificateFast 10 542 fastCert10_542=true := by decide +kernel
def fastCert10_543 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_543 : checkCertificateFast 10 543 fastCert10_543=true := by decide +kernel
def fastCert10_544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_544 : checkCertificateFast 10 544 fastCert10_544=true := by decide +kernel
def fastCert10_545 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_545 : checkCertificateFast 10 545 fastCert10_545=true := by decide +kernel
def fastCert10_546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_546 : checkCertificateFast 10 546 fastCert10_546=true := by decide +kernel
def fastCert10_547 : Certificate := ⟨6,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_547 : checkCertificateFast 10 547 fastCert10_547=true := by decide +kernel
def fastCert10_548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_548 : checkCertificateFast 10 548 fastCert10_548=true := by decide +kernel
def fastCert10_549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_549 : checkCertificateFast 10 549 fastCert10_549=true := by decide +kernel
def fastCert10_550 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_550 : checkCertificateFast 10 550 fastCert10_550=true := by decide +kernel
def fastCert10_551 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_551 : checkCertificateFast 10 551 fastCert10_551=true := by decide +kernel
def fastCert10_552 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_552 : checkCertificateFast 10 552 fastCert10_552=true := by decide +kernel
def fastCert10_553 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_553 : checkCertificateFast 10 553 fastCert10_553=true := by decide +kernel
def fastCert10_554 : Certificate := ⟨17,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_554 : checkCertificateFast 10 554 fastCert10_554=true := by decide +kernel
def fastCert10_555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_555 : checkCertificateFast 10 555 fastCert10_555=true := by decide +kernel
def fastCert10_556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_556 : checkCertificateFast 10 556 fastCert10_556=true := by decide +kernel
def fastCert10_557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_557 : checkCertificateFast 10 557 fastCert10_557=true := by decide +kernel
def fastCert10_558 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_558 : checkCertificateFast 10 558 fastCert10_558=true := by decide +kernel
def fastCert10_559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_559 : checkCertificateFast 10 559 fastCert10_559=true := by decide +kernel
def fastCert10_560 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_560 : checkCertificateFast 10 560 fastCert10_560=true := by decide +kernel
def fastCert10_561 : Certificate := ⟨10,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_561 : checkCertificateFast 10 561 fastCert10_561=true := by decide +kernel
def fastCert10_562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_562 : checkCertificateFast 10 562 fastCert10_562=true := by decide +kernel
def fastCert10_563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_563 : checkCertificateFast 10 563 fastCert10_563=true := by decide +kernel
def fastCert10_564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_564 : checkCertificateFast 10 564 fastCert10_564=true := by decide +kernel
def fastCert10_565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_565 : checkCertificateFast 10 565 fastCert10_565=true := by decide +kernel
def fastCert10_566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_566 : checkCertificateFast 10 566 fastCert10_566=true := by decide +kernel
def fastCert10_567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_567 : checkCertificateFast 10 567 fastCert10_567=true := by decide +kernel
def fastCert10_568 : Certificate := ⟨10,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_568 : checkCertificateFast 10 568 fastCert10_568=true := by decide +kernel
def fastCert10_569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_569 : checkCertificateFast 10 569 fastCert10_569=true := by decide +kernel
def fastCert10_570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_570 : checkCertificateFast 10 570 fastCert10_570=true := by decide +kernel
def fastCert10_571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_571 : checkCertificateFast 10 571 fastCert10_571=true := by decide +kernel
def fastCert10_572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_572 : checkCertificateFast 10 572 fastCert10_572=true := by decide +kernel
def fastCert10_573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_573 : checkCertificateFast 10 573 fastCert10_573=true := by decide +kernel
def fastCert10_574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_574 : checkCertificateFast 10 574 fastCert10_574=true := by decide +kernel
def fastCert10_575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_575 : checkCertificateFast 10 575 fastCert10_575=true := by decide +kernel
def fastCert10_576 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_576 : checkCertificateFast 10 576 fastCert10_576=true := by decide +kernel
def fastCert10_577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_577 : checkCertificateFast 10 577 fastCert10_577=true := by decide +kernel
def fastCert10_578 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_578 : checkCertificateFast 10 578 fastCert10_578=true := by decide +kernel
def fastCert10_579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_579 : checkCertificateFast 10 579 fastCert10_579=true := by decide +kernel
def fastCert10_580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_580 : checkCertificateFast 10 580 fastCert10_580=true := by decide +kernel
def fastCert10_581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_581 : checkCertificateFast 10 581 fastCert10_581=true := by decide +kernel
def fastCert10_582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_582 : checkCertificateFast 10 582 fastCert10_582=true := by decide +kernel
def fastCert10_583 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_583 : checkCertificateFast 10 583 fastCert10_583=true := by decide +kernel
def fastCert10_584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_584 : checkCertificateFast 10 584 fastCert10_584=true := by decide +kernel
def fastCert10_585 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_585 : checkCertificateFast 10 585 fastCert10_585=true := by decide +kernel
def fastCert10_586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_586 : checkCertificateFast 10 586 fastCert10_586=true := by decide +kernel
def fastCert10_587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_587 : checkCertificateFast 10 587 fastCert10_587=true := by decide +kernel
def fastCert10_588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_588 : checkCertificateFast 10 588 fastCert10_588=true := by decide +kernel
def fastCert10_589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_589 : checkCertificateFast 10 589 fastCert10_589=true := by decide +kernel
def fastCert10_590 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_590 : checkCertificateFast 10 590 fastCert10_590=true := by decide +kernel
def fastCert10_591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_591 : checkCertificateFast 10 591 fastCert10_591=true := by decide +kernel
def fastCert10_592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_592 : checkCertificateFast 10 592 fastCert10_592=true := by decide +kernel
def fastCert10_593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_593 : checkCertificateFast 10 593 fastCert10_593=true := by decide +kernel
def fastCert10_594 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_594 : checkCertificateFast 10 594 fastCert10_594=true := by decide +kernel
def fastCert10_595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_595 : checkCertificateFast 10 595 fastCert10_595=true := by decide +kernel
def fastCert10_596 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_596 : checkCertificateFast 10 596 fastCert10_596=true := by decide +kernel
def fastCert10_597 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_597 : checkCertificateFast 10 597 fastCert10_597=true := by decide +kernel
def fastCert10_598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_598 : checkCertificateFast 10 598 fastCert10_598=true := by decide +kernel
def fastCert10_599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_599 : checkCertificateFast 10 599 fastCert10_599=true := by decide +kernel
def fastCert10_600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_600 : checkCertificateFast 10 600 fastCert10_600=true := by decide +kernel
def fastCert10_601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_601 : checkCertificateFast 10 601 fastCert10_601=true := by decide +kernel
def fastCert10_602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_602 : checkCertificateFast 10 602 fastCert10_602=true := by decide +kernel
def fastCert10_603 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_603 : checkCertificateFast 10 603 fastCert10_603=true := by decide +kernel
def fastCert10_604 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_604 : checkCertificateFast 10 604 fastCert10_604=true := by decide +kernel
def fastCert10_605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_605 : checkCertificateFast 10 605 fastCert10_605=true := by decide +kernel
def fastCert10_606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_606 : checkCertificateFast 10 606 fastCert10_606=true := by decide +kernel
def fastCert10_607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_607 : checkCertificateFast 10 607 fastCert10_607=true := by decide +kernel
def fastCert10_608 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_608 : checkCertificateFast 10 608 fastCert10_608=true := by decide +kernel
def fastCert10_609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_609 : checkCertificateFast 10 609 fastCert10_609=true := by decide +kernel
def fastCert10_610 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_610 : checkCertificateFast 10 610 fastCert10_610=true := by decide +kernel
def fastCert10_611 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_611 : checkCertificateFast 10 611 fastCert10_611=true := by decide +kernel
def fastCert10_612 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_612 : checkCertificateFast 10 612 fastCert10_612=true := by decide +kernel
def fastCert10_613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_613 : checkCertificateFast 10 613 fastCert10_613=true := by decide +kernel
def fastCert10_614 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_614 : checkCertificateFast 10 614 fastCert10_614=true := by decide +kernel
def fastCert10_615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_615 : checkCertificateFast 10 615 fastCert10_615=true := by decide +kernel
def fastCert10_616 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_616 : checkCertificateFast 10 616 fastCert10_616=true := by decide +kernel
def fastCert10_617 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_617 : checkCertificateFast 10 617 fastCert10_617=true := by decide +kernel
def fastCert10_618 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_618 : checkCertificateFast 10 618 fastCert10_618=true := by decide +kernel
def fastCert10_619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_619 : checkCertificateFast 10 619 fastCert10_619=true := by decide +kernel
def fastCert10_620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_620 : checkCertificateFast 10 620 fastCert10_620=true := by decide +kernel
def fastCert10_621 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_621 : checkCertificateFast 10 621 fastCert10_621=true := by decide +kernel
def fastCert10_622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_622 : checkCertificateFast 10 622 fastCert10_622=true := by decide +kernel
def fastCert10_623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_623 : checkCertificateFast 10 623 fastCert10_623=true := by decide +kernel
def fastCert10_624 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_624 : checkCertificateFast 10 624 fastCert10_624=true := by decide +kernel
def fastCert10_625 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_625 : checkCertificateFast 10 625 fastCert10_625=true := by decide +kernel
def fastCert10_626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_626 : checkCertificateFast 10 626 fastCert10_626=true := by decide +kernel
def fastCert10_627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_627 : checkCertificateFast 10 627 fastCert10_627=true := by decide +kernel
def fastCert10_628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_628 : checkCertificateFast 10 628 fastCert10_628=true := by decide +kernel
def fastCert10_629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_629 : checkCertificateFast 10 629 fastCert10_629=true := by decide +kernel
def fastCert10_630 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_630 : checkCertificateFast 10 630 fastCert10_630=true := by decide +kernel
def fastCert10_631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_631 : checkCertificateFast 10 631 fastCert10_631=true := by decide +kernel
def fastCert10_632 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_632 : checkCertificateFast 10 632 fastCert10_632=true := by decide +kernel
def fastCert10_633 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_633 : checkCertificateFast 10 633 fastCert10_633=true := by decide +kernel
def fastCert10_634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_634 : checkCertificateFast 10 634 fastCert10_634=true := by decide +kernel
def fastCert10_635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_635 : checkCertificateFast 10 635 fastCert10_635=true := by decide +kernel
def fastCert10_636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_636 : checkCertificateFast 10 636 fastCert10_636=true := by decide +kernel
def fastCert10_637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_637 : checkCertificateFast 10 637 fastCert10_637=true := by decide +kernel
def fastCert10_638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_638 : checkCertificateFast 10 638 fastCert10_638=true := by decide +kernel
def fastCert10_639 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_639 : checkCertificateFast 10 639 fastCert10_639=true := by decide +kernel
def fastCert10_640 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_640 : checkCertificateFast 10 640 fastCert10_640=true := by decide +kernel
def fastCert10_641 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_641 : checkCertificateFast 10 641 fastCert10_641=true := by decide +kernel
def fastCert10_642 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_642 : checkCertificateFast 10 642 fastCert10_642=true := by decide +kernel
def fastCert10_643 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_643 : checkCertificateFast 10 643 fastCert10_643=true := by decide +kernel
def fastCert10_644 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_644 : checkCertificateFast 10 644 fastCert10_644=true := by decide +kernel
def fastCert10_645 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_645 : checkCertificateFast 10 645 fastCert10_645=true := by decide +kernel
def fastCert10_646 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_646 : checkCertificateFast 10 646 fastCert10_646=true := by decide +kernel
def fastCert10_647 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_647 : checkCertificateFast 10 647 fastCert10_647=true := by decide +kernel
def fastCert10_648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_648 : checkCertificateFast 10 648 fastCert10_648=true := by decide +kernel
def fastCert10_649 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_649 : checkCertificateFast 10 649 fastCert10_649=true := by decide +kernel
def fastCert10_650 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_650 : checkCertificateFast 10 650 fastCert10_650=true := by decide +kernel
def fastCert10_651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_651 : checkCertificateFast 10 651 fastCert10_651=true := by decide +kernel
def fastCert10_652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_652 : checkCertificateFast 10 652 fastCert10_652=true := by decide +kernel
def fastCert10_653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_653 : checkCertificateFast 10 653 fastCert10_653=true := by decide +kernel
def fastCert10_654 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_654 : checkCertificateFast 10 654 fastCert10_654=true := by decide +kernel
def fastCert10_655 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_655 : checkCertificateFast 10 655 fastCert10_655=true := by decide +kernel
def fastCert10_656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_656 : checkCertificateFast 10 656 fastCert10_656=true := by decide +kernel
def fastCert10_657 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_657 : checkCertificateFast 10 657 fastCert10_657=true := by decide +kernel
def fastCert10_658 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-4) else 0⟩
theorem fastCase10_658 : checkCertificateFast 10 658 fastCert10_658=true := by decide +kernel
def fastCert10_659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_659 : checkCertificateFast 10 659 fastCert10_659=true := by decide +kernel
def fastCert10_660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_660 : checkCertificateFast 10 660 fastCert10_660=true := by decide +kernel
def fastCert10_661 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_661 : checkCertificateFast 10 661 fastCert10_661=true := by decide +kernel
def fastCert10_662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_662 : checkCertificateFast 10 662 fastCert10_662=true := by decide +kernel
def fastCert10_663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_663 : checkCertificateFast 10 663 fastCert10_663=true := by decide +kernel
def fastCert10_664 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_664 : checkCertificateFast 10 664 fastCert10_664=true := by decide +kernel
def fastCert10_665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_665 : checkCertificateFast 10 665 fastCert10_665=true := by decide +kernel
def fastCert10_666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_666 : checkCertificateFast 10 666 fastCert10_666=true := by decide +kernel
def fastCert10_667 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_667 : checkCertificateFast 10 667 fastCert10_667=true := by decide +kernel
def fastCert10_668 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_668 : checkCertificateFast 10 668 fastCert10_668=true := by decide +kernel
def fastCert10_669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_669 : checkCertificateFast 10 669 fastCert10_669=true := by decide +kernel
def fastCert10_670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_670 : checkCertificateFast 10 670 fastCert10_670=true := by decide +kernel
def fastCert10_671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_671 : checkCertificateFast 10 671 fastCert10_671=true := by decide +kernel
def fastCert10_672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_672 : checkCertificateFast 10 672 fastCert10_672=true := by decide +kernel
def fastCert10_673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_673 : checkCertificateFast 10 673 fastCert10_673=true := by decide +kernel
def fastCert10_674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_674 : checkCertificateFast 10 674 fastCert10_674=true := by decide +kernel
def fastCert10_675 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_675 : checkCertificateFast 10 675 fastCert10_675=true := by decide +kernel
def fastCert10_676 : Certificate := ⟨18,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_676 : checkCertificateFast 10 676 fastCert10_676=true := by decide +kernel
def fastCert10_677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_677 : checkCertificateFast 10 677 fastCert10_677=true := by decide +kernel
def fastCert10_678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_678 : checkCertificateFast 10 678 fastCert10_678=true := by decide +kernel
def fastCert10_679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_679 : checkCertificateFast 10 679 fastCert10_679=true := by decide +kernel
def fastCert10_680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_680 : checkCertificateFast 10 680 fastCert10_680=true := by decide +kernel
def fastCert10_681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_681 : checkCertificateFast 10 681 fastCert10_681=true := by decide +kernel
def fastCert10_682 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_682 : checkCertificateFast 10 682 fastCert10_682=true := by decide +kernel
def fastCert10_683 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_683 : checkCertificateFast 10 683 fastCert10_683=true := by decide +kernel
def fastCert10_684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_684 : checkCertificateFast 10 684 fastCert10_684=true := by decide +kernel
def fastCert10_685 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_685 : checkCertificateFast 10 685 fastCert10_685=true := by decide +kernel
def fastCert10_686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_686 : checkCertificateFast 10 686 fastCert10_686=true := by decide +kernel
def fastCert10_687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_687 : checkCertificateFast 10 687 fastCert10_687=true := by decide +kernel
def fastCert10_688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_688 : checkCertificateFast 10 688 fastCert10_688=true := by decide +kernel
def fastCert10_689 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_689 : checkCertificateFast 10 689 fastCert10_689=true := by decide +kernel
def fastCert10_690 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_690 : checkCertificateFast 10 690 fastCert10_690=true := by decide +kernel
def fastCert10_691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_691 : checkCertificateFast 10 691 fastCert10_691=true := by decide +kernel
def fastCert10_692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_692 : checkCertificateFast 10 692 fastCert10_692=true := by decide +kernel
def fastCert10_693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_693 : checkCertificateFast 10 693 fastCert10_693=true := by decide +kernel
def fastCert10_694 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_694 : checkCertificateFast 10 694 fastCert10_694=true := by decide +kernel
def fastCert10_695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_695 : checkCertificateFast 10 695 fastCert10_695=true := by decide +kernel
def fastCert10_696 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_696 : checkCertificateFast 10 696 fastCert10_696=true := by decide +kernel
def fastCert10_697 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_697 : checkCertificateFast 10 697 fastCert10_697=true := by decide +kernel
def fastCert10_698 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_698 : checkCertificateFast 10 698 fastCert10_698=true := by decide +kernel
def fastCert10_699 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_699 : checkCertificateFast 10 699 fastCert10_699=true := by decide +kernel
def fastCert10_700 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_700 : checkCertificateFast 10 700 fastCert10_700=true := by decide +kernel
def fastCert10_701 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_701 : checkCertificateFast 10 701 fastCert10_701=true := by decide +kernel
def fastCert10_702 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_702 : checkCertificateFast 10 702 fastCert10_702=true := by decide +kernel
def fastCert10_703 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_703 : checkCertificateFast 10 703 fastCert10_703=true := by decide +kernel
def fastCert10_704 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_704 : checkCertificateFast 10 704 fastCert10_704=true := by decide +kernel
def fastCert10_705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_705 : checkCertificateFast 10 705 fastCert10_705=true := by decide +kernel
def fastCert10_706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_706 : checkCertificateFast 10 706 fastCert10_706=true := by decide +kernel
def fastCert10_707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_707 : checkCertificateFast 10 707 fastCert10_707=true := by decide +kernel
def fastCert10_708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_708 : checkCertificateFast 10 708 fastCert10_708=true := by decide +kernel
def fastCert10_709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_709 : checkCertificateFast 10 709 fastCert10_709=true := by decide +kernel
def fastCert10_710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_710 : checkCertificateFast 10 710 fastCert10_710=true := by decide +kernel
def fastCert10_711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_711 : checkCertificateFast 10 711 fastCert10_711=true := by decide +kernel
def fastCert10_712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_712 : checkCertificateFast 10 712 fastCert10_712=true := by decide +kernel
def fastCert10_713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_713 : checkCertificateFast 10 713 fastCert10_713=true := by decide +kernel
def fastCert10_714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_714 : checkCertificateFast 10 714 fastCert10_714=true := by decide +kernel
def fastCert10_715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_715 : checkCertificateFast 10 715 fastCert10_715=true := by decide +kernel
def fastCert10_716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_716 : checkCertificateFast 10 716 fastCert10_716=true := by decide +kernel
def fastCert10_717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_717 : checkCertificateFast 10 717 fastCert10_717=true := by decide +kernel
def fastCert10_718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_718 : checkCertificateFast 10 718 fastCert10_718=true := by decide +kernel
def fastCert10_719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_719 : checkCertificateFast 10 719 fastCert10_719=true := by decide +kernel
def fastCert10_720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_720 : checkCertificateFast 10 720 fastCert10_720=true := by decide +kernel
def fastCert10_721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_721 : checkCertificateFast 10 721 fastCert10_721=true := by decide +kernel
def fastCert10_722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_722 : checkCertificateFast 10 722 fastCert10_722=true := by decide +kernel
def fastCert10_723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_723 : checkCertificateFast 10 723 fastCert10_723=true := by decide +kernel
def fastCert10_724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_724 : checkCertificateFast 10 724 fastCert10_724=true := by decide +kernel
def fastCert10_725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_725 : checkCertificateFast 10 725 fastCert10_725=true := by decide +kernel
def fastCert10_726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_726 : checkCertificateFast 10 726 fastCert10_726=true := by decide +kernel
def fastCert10_727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_727 : checkCertificateFast 10 727 fastCert10_727=true := by decide +kernel
def fastCert10_728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_728 : checkCertificateFast 10 728 fastCert10_728=true := by decide +kernel
def fastCert10_729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_729 : checkCertificateFast 10 729 fastCert10_729=true := by decide +kernel
def fastCert10_730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_730 : checkCertificateFast 10 730 fastCert10_730=true := by decide +kernel
def fastCert10_731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_731 : checkCertificateFast 10 731 fastCert10_731=true := by decide +kernel
def fastCert10_732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_732 : checkCertificateFast 10 732 fastCert10_732=true := by decide +kernel
def fastCert10_733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_733 : checkCertificateFast 10 733 fastCert10_733=true := by decide +kernel
def fastCert10_734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_734 : checkCertificateFast 10 734 fastCert10_734=true := by decide +kernel
def fastCert10_735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_735 : checkCertificateFast 10 735 fastCert10_735=true := by decide +kernel
def fastCert10_736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_736 : checkCertificateFast 10 736 fastCert10_736=true := by decide +kernel
def fastCert10_737 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_737 : checkCertificateFast 10 737 fastCert10_737=true := by decide +kernel
def fastCert10_738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_738 : checkCertificateFast 10 738 fastCert10_738=true := by decide +kernel
def fastCert10_739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_739 : checkCertificateFast 10 739 fastCert10_739=true := by decide +kernel
def fastCert10_740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_740 : checkCertificateFast 10 740 fastCert10_740=true := by decide +kernel
def fastCert10_741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_741 : checkCertificateFast 10 741 fastCert10_741=true := by decide +kernel
def fastCert10_742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_742 : checkCertificateFast 10 742 fastCert10_742=true := by decide +kernel
def fastCert10_743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_743 : checkCertificateFast 10 743 fastCert10_743=true := by decide +kernel
def fastCert10_744 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_744 : checkCertificateFast 10 744 fastCert10_744=true := by decide +kernel
def fastCert10_745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_745 : checkCertificateFast 10 745 fastCert10_745=true := by decide +kernel
def fastCert10_746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_746 : checkCertificateFast 10 746 fastCert10_746=true := by decide +kernel
def fastCert10_747 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_747 : checkCertificateFast 10 747 fastCert10_747=true := by decide +kernel
def fastCert10_748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_748 : checkCertificateFast 10 748 fastCert10_748=true := by decide +kernel
def fastCert10_749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_749 : checkCertificateFast 10 749 fastCert10_749=true := by decide +kernel
def fastCert10_750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_750 : checkCertificateFast 10 750 fastCert10_750=true := by decide +kernel
def fastCert10_751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_751 : checkCertificateFast 10 751 fastCert10_751=true := by decide +kernel
def fastCert10_752 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_752 : checkCertificateFast 10 752 fastCert10_752=true := by decide +kernel
def fastCert10_753 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_753 : checkCertificateFast 10 753 fastCert10_753=true := by decide +kernel
def fastCert10_754 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_754 : checkCertificateFast 10 754 fastCert10_754=true := by decide +kernel
def fastCert10_755 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_755 : checkCertificateFast 10 755 fastCert10_755=true := by decide +kernel
def fastCert10_756 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_756 : checkCertificateFast 10 756 fastCert10_756=true := by decide +kernel
def fastCert10_757 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_757 : checkCertificateFast 10 757 fastCert10_757=true := by decide +kernel
def fastCert10_758 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_758 : checkCertificateFast 10 758 fastCert10_758=true := by decide +kernel
def fastCert10_759 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_759 : checkCertificateFast 10 759 fastCert10_759=true := by decide +kernel
def fastCert10_760 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_760 : checkCertificateFast 10 760 fastCert10_760=true := by decide +kernel
def fastCert10_761 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_761 : checkCertificateFast 10 761 fastCert10_761=true := by decide +kernel
def fastCert10_762 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_762 : checkCertificateFast 10 762 fastCert10_762=true := by decide +kernel
def fastCert10_763 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_763 : checkCertificateFast 10 763 fastCert10_763=true := by decide +kernel
def fastCert10_764 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_764 : checkCertificateFast 10 764 fastCert10_764=true := by decide +kernel
def fastCert10_765 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_765 : checkCertificateFast 10 765 fastCert10_765=true := by decide +kernel
def fastCert10_766 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_766 : checkCertificateFast 10 766 fastCert10_766=true := by decide +kernel
def fastCert10_767 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_767 : checkCertificateFast 10 767 fastCert10_767=true := by decide +kernel
def fastCert10_768 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_768 : checkCertificateFast 10 768 fastCert10_768=true := by decide +kernel
def fastCert10_769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_769 : checkCertificateFast 10 769 fastCert10_769=true := by decide +kernel
def fastCert10_770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_770 : checkCertificateFast 10 770 fastCert10_770=true := by decide +kernel
def fastCert10_771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_771 : checkCertificateFast 10 771 fastCert10_771=true := by decide +kernel
def fastCert10_772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_772 : checkCertificateFast 10 772 fastCert10_772=true := by decide +kernel
def fastCert10_773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_773 : checkCertificateFast 10 773 fastCert10_773=true := by decide +kernel
def fastCert10_774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_774 : checkCertificateFast 10 774 fastCert10_774=true := by decide +kernel
def fastCert10_775 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_775 : checkCertificateFast 10 775 fastCert10_775=true := by decide +kernel
def fastCert10_776 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_776 : checkCertificateFast 10 776 fastCert10_776=true := by decide +kernel
def fastCert10_777 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_777 : checkCertificateFast 10 777 fastCert10_777=true := by decide +kernel
def fastCert10_778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_778 : checkCertificateFast 10 778 fastCert10_778=true := by decide +kernel
def fastCert10_779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_779 : checkCertificateFast 10 779 fastCert10_779=true := by decide +kernel
def fastCert10_780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_780 : checkCertificateFast 10 780 fastCert10_780=true := by decide +kernel
def fastCert10_781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_781 : checkCertificateFast 10 781 fastCert10_781=true := by decide +kernel
def fastCert10_782 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_782 : checkCertificateFast 10 782 fastCert10_782=true := by decide +kernel
def fastCert10_783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_783 : checkCertificateFast 10 783 fastCert10_783=true := by decide +kernel
def fastCert10_784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_784 : checkCertificateFast 10 784 fastCert10_784=true := by decide +kernel
def fastCert10_785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_785 : checkCertificateFast 10 785 fastCert10_785=true := by decide +kernel
def fastCert10_786 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_786 : checkCertificateFast 10 786 fastCert10_786=true := by decide +kernel
def fastCert10_787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_787 : checkCertificateFast 10 787 fastCert10_787=true := by decide +kernel
def fastCert10_788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_788 : checkCertificateFast 10 788 fastCert10_788=true := by decide +kernel
def fastCert10_789 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_789 : checkCertificateFast 10 789 fastCert10_789=true := by decide +kernel
def fastCert10_790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_790 : checkCertificateFast 10 790 fastCert10_790=true := by decide +kernel
def fastCert10_791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_791 : checkCertificateFast 10 791 fastCert10_791=true := by decide +kernel
def fastCert10_792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_792 : checkCertificateFast 10 792 fastCert10_792=true := by decide +kernel
def fastCert10_793 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_793 : checkCertificateFast 10 793 fastCert10_793=true := by decide +kernel
def fastCert10_794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_794 : checkCertificateFast 10 794 fastCert10_794=true := by decide +kernel
def fastCert10_795 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_795 : checkCertificateFast 10 795 fastCert10_795=true := by decide +kernel
def fastCert10_796 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_796 : checkCertificateFast 10 796 fastCert10_796=true := by decide +kernel
def fastCert10_797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_797 : checkCertificateFast 10 797 fastCert10_797=true := by decide +kernel
def fastCert10_798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_798 : checkCertificateFast 10 798 fastCert10_798=true := by decide +kernel
def fastCert10_799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_799 : checkCertificateFast 10 799 fastCert10_799=true := by decide +kernel
def fastCert10_800 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_800 : checkCertificateFast 10 800 fastCert10_800=true := by decide +kernel
def fastCert10_801 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_801 : checkCertificateFast 10 801 fastCert10_801=true := by decide +kernel
def fastCert10_802 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_802 : checkCertificateFast 10 802 fastCert10_802=true := by decide +kernel
def fastCert10_803 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_803 : checkCertificateFast 10 803 fastCert10_803=true := by decide +kernel
def fastCert10_804 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_804 : checkCertificateFast 10 804 fastCert10_804=true := by decide +kernel
def fastCert10_805 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_805 : checkCertificateFast 10 805 fastCert10_805=true := by decide +kernel
def fastCert10_806 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_806 : checkCertificateFast 10 806 fastCert10_806=true := by decide +kernel
def fastCert10_807 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_807 : checkCertificateFast 10 807 fastCert10_807=true := by decide +kernel
def fastCert10_808 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_808 : checkCertificateFast 10 808 fastCert10_808=true := by decide +kernel
def fastCert10_809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_809 : checkCertificateFast 10 809 fastCert10_809=true := by decide +kernel
def fastCert10_810 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_810 : checkCertificateFast 10 810 fastCert10_810=true := by decide +kernel
def fastCert10_811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_811 : checkCertificateFast 10 811 fastCert10_811=true := by decide +kernel
def fastCert10_812 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_812 : checkCertificateFast 10 812 fastCert10_812=true := by decide +kernel
def fastCert10_813 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_813 : checkCertificateFast 10 813 fastCert10_813=true := by decide +kernel
def fastCert10_814 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_814 : checkCertificateFast 10 814 fastCert10_814=true := by decide +kernel
def fastCert10_815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_815 : checkCertificateFast 10 815 fastCert10_815=true := by decide +kernel
def fastCert10_816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_816 : checkCertificateFast 10 816 fastCert10_816=true := by decide +kernel
def fastCert10_817 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_817 : checkCertificateFast 10 817 fastCert10_817=true := by decide +kernel
def fastCert10_818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_818 : checkCertificateFast 10 818 fastCert10_818=true := by decide +kernel
def fastCert10_819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_819 : checkCertificateFast 10 819 fastCert10_819=true := by decide +kernel
def fastCert10_820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_820 : checkCertificateFast 10 820 fastCert10_820=true := by decide +kernel
def fastCert10_821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_821 : checkCertificateFast 10 821 fastCert10_821=true := by decide +kernel
def fastCert10_822 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_822 : checkCertificateFast 10 822 fastCert10_822=true := by decide +kernel
def fastCert10_823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_823 : checkCertificateFast 10 823 fastCert10_823=true := by decide +kernel
def fastCert10_824 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_824 : checkCertificateFast 10 824 fastCert10_824=true := by decide +kernel
def fastCert10_825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_825 : checkCertificateFast 10 825 fastCert10_825=true := by decide +kernel
def fastCert10_826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_826 : checkCertificateFast 10 826 fastCert10_826=true := by decide +kernel
def fastCert10_827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_827 : checkCertificateFast 10 827 fastCert10_827=true := by decide +kernel
def fastCert10_828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_828 : checkCertificateFast 10 828 fastCert10_828=true := by decide +kernel
def fastCert10_829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_829 : checkCertificateFast 10 829 fastCert10_829=true := by decide +kernel
def fastCert10_830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_830 : checkCertificateFast 10 830 fastCert10_830=true := by decide +kernel
def fastCert10_831 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_831 : checkCertificateFast 10 831 fastCert10_831=true := by decide +kernel
def fastCert10_832 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_832 : checkCertificateFast 10 832 fastCert10_832=true := by decide +kernel
def fastCert10_833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_833 : checkCertificateFast 10 833 fastCert10_833=true := by decide +kernel
def fastCert10_834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_834 : checkCertificateFast 10 834 fastCert10_834=true := by decide +kernel
def fastCert10_835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_835 : checkCertificateFast 10 835 fastCert10_835=true := by decide +kernel
def fastCert10_836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_836 : checkCertificateFast 10 836 fastCert10_836=true := by decide +kernel
def fastCert10_837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_837 : checkCertificateFast 10 837 fastCert10_837=true := by decide +kernel
def fastCert10_838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_838 : checkCertificateFast 10 838 fastCert10_838=true := by decide +kernel
def fastCert10_839 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_839 : checkCertificateFast 10 839 fastCert10_839=true := by decide +kernel
def fastCert10_840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_840 : checkCertificateFast 10 840 fastCert10_840=true := by decide +kernel
def fastCert10_841 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_841 : checkCertificateFast 10 841 fastCert10_841=true := by decide +kernel
def fastCert10_842 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_842 : checkCertificateFast 10 842 fastCert10_842=true := by decide +kernel
def fastCert10_843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_843 : checkCertificateFast 10 843 fastCert10_843=true := by decide +kernel
def fastCert10_844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_844 : checkCertificateFast 10 844 fastCert10_844=true := by decide +kernel
def fastCert10_845 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_845 : checkCertificateFast 10 845 fastCert10_845=true := by decide +kernel
def fastCert10_846 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_846 : checkCertificateFast 10 846 fastCert10_846=true := by decide +kernel
def fastCert10_847 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_847 : checkCertificateFast 10 847 fastCert10_847=true := by decide +kernel
def fastCert10_848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_848 : checkCertificateFast 10 848 fastCert10_848=true := by decide +kernel
def fastCert10_849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_849 : checkCertificateFast 10 849 fastCert10_849=true := by decide +kernel
def fastCert10_850 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_850 : checkCertificateFast 10 850 fastCert10_850=true := by decide +kernel
def fastCert10_851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_851 : checkCertificateFast 10 851 fastCert10_851=true := by decide +kernel
def fastCert10_852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_852 : checkCertificateFast 10 852 fastCert10_852=true := by decide +kernel
def fastCert10_853 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_853 : checkCertificateFast 10 853 fastCert10_853=true := by decide +kernel
def fastCert10_854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_854 : checkCertificateFast 10 854 fastCert10_854=true := by decide +kernel
def fastCert10_855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_855 : checkCertificateFast 10 855 fastCert10_855=true := by decide +kernel
def fastCert10_856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_856 : checkCertificateFast 10 856 fastCert10_856=true := by decide +kernel
def fastCert10_857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_857 : checkCertificateFast 10 857 fastCert10_857=true := by decide +kernel
def fastCert10_858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_858 : checkCertificateFast 10 858 fastCert10_858=true := by decide +kernel
def fastCert10_859 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_859 : checkCertificateFast 10 859 fastCert10_859=true := by decide +kernel
def fastCert10_860 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_860 : checkCertificateFast 10 860 fastCert10_860=true := by decide +kernel
def fastCert10_861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_861 : checkCertificateFast 10 861 fastCert10_861=true := by decide +kernel
def fastCert10_862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_862 : checkCertificateFast 10 862 fastCert10_862=true := by decide +kernel
def fastCert10_863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_863 : checkCertificateFast 10 863 fastCert10_863=true := by decide +kernel
def fastCert10_864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_864 : checkCertificateFast 10 864 fastCert10_864=true := by decide +kernel
def fastCert10_865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_865 : checkCertificateFast 10 865 fastCert10_865=true := by decide +kernel
def fastCert10_866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_866 : checkCertificateFast 10 866 fastCert10_866=true := by decide +kernel
def fastCert10_867 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_867 : checkCertificateFast 10 867 fastCert10_867=true := by decide +kernel
def fastCert10_868 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_868 : checkCertificateFast 10 868 fastCert10_868=true := by decide +kernel
def fastCert10_869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_869 : checkCertificateFast 10 869 fastCert10_869=true := by decide +kernel
def fastCert10_870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_870 : checkCertificateFast 10 870 fastCert10_870=true := by decide +kernel
def fastCert10_871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_871 : checkCertificateFast 10 871 fastCert10_871=true := by decide +kernel
def fastCert10_872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_872 : checkCertificateFast 10 872 fastCert10_872=true := by decide +kernel
def fastCert10_873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_873 : checkCertificateFast 10 873 fastCert10_873=true := by decide +kernel
def fastCert10_874 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_874 : checkCertificateFast 10 874 fastCert10_874=true := by decide +kernel
def fastCert10_875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_875 : checkCertificateFast 10 875 fastCert10_875=true := by decide +kernel
def fastCert10_876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_876 : checkCertificateFast 10 876 fastCert10_876=true := by decide +kernel
def fastCert10_877 : Certificate := ⟨8,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_877 : checkCertificateFast 10 877 fastCert10_877=true := by decide +kernel
def fastCert10_878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_878 : checkCertificateFast 10 878 fastCert10_878=true := by decide +kernel
def fastCert10_879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_879 : checkCertificateFast 10 879 fastCert10_879=true := by decide +kernel
def fastCert10_880 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_880 : checkCertificateFast 10 880 fastCert10_880=true := by decide +kernel
def fastCert10_881 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_881 : checkCertificateFast 10 881 fastCert10_881=true := by decide +kernel
def fastCert10_882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_882 : checkCertificateFast 10 882 fastCert10_882=true := by decide +kernel
def fastCert10_883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_883 : checkCertificateFast 10 883 fastCert10_883=true := by decide +kernel
def fastCert10_884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_884 : checkCertificateFast 10 884 fastCert10_884=true := by decide +kernel
def fastCert10_885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_885 : checkCertificateFast 10 885 fastCert10_885=true := by decide +kernel
def fastCert10_886 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_886 : checkCertificateFast 10 886 fastCert10_886=true := by decide +kernel
def fastCert10_887 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_887 : checkCertificateFast 10 887 fastCert10_887=true := by decide +kernel
def fastCert10_888 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_888 : checkCertificateFast 10 888 fastCert10_888=true := by decide +kernel
def fastCert10_889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_889 : checkCertificateFast 10 889 fastCert10_889=true := by decide +kernel
def fastCert10_890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_890 : checkCertificateFast 10 890 fastCert10_890=true := by decide +kernel
def fastCert10_891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_891 : checkCertificateFast 10 891 fastCert10_891=true := by decide +kernel
def fastCert10_892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_892 : checkCertificateFast 10 892 fastCert10_892=true := by decide +kernel
def fastCert10_893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_893 : checkCertificateFast 10 893 fastCert10_893=true := by decide +kernel
def fastCert10_894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_894 : checkCertificateFast 10 894 fastCert10_894=true := by decide +kernel
def fastCert10_895 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_895 : checkCertificateFast 10 895 fastCert10_895=true := by decide +kernel
def fastCert10_896 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_896 : checkCertificateFast 10 896 fastCert10_896=true := by decide +kernel
def fastCert10_897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_897 : checkCertificateFast 10 897 fastCert10_897=true := by decide +kernel
def fastCert10_898 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_898 : checkCertificateFast 10 898 fastCert10_898=true := by decide +kernel
def fastCert10_899 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_899 : checkCertificateFast 10 899 fastCert10_899=true := by decide +kernel
def fastCert10_900 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_900 : checkCertificateFast 10 900 fastCert10_900=true := by decide +kernel
def fastCert10_901 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_901 : checkCertificateFast 10 901 fastCert10_901=true := by decide +kernel
def fastCert10_902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_902 : checkCertificateFast 10 902 fastCert10_902=true := by decide +kernel
def fastCert10_903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_903 : checkCertificateFast 10 903 fastCert10_903=true := by decide +kernel
def fastCert10_904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_904 : checkCertificateFast 10 904 fastCert10_904=true := by decide +kernel
def fastCert10_905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_905 : checkCertificateFast 10 905 fastCert10_905=true := by decide +kernel
def fastCert10_906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_906 : checkCertificateFast 10 906 fastCert10_906=true := by decide +kernel
def fastCert10_907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_907 : checkCertificateFast 10 907 fastCert10_907=true := by decide +kernel
def fastCert10_908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_908 : checkCertificateFast 10 908 fastCert10_908=true := by decide +kernel
def fastCert10_909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_909 : checkCertificateFast 10 909 fastCert10_909=true := by decide +kernel
def fastCert10_910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_910 : checkCertificateFast 10 910 fastCert10_910=true := by decide +kernel
def fastCert10_911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_911 : checkCertificateFast 10 911 fastCert10_911=true := by decide +kernel
def fastCert10_912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_912 : checkCertificateFast 10 912 fastCert10_912=true := by decide +kernel
def fastCert10_913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_913 : checkCertificateFast 10 913 fastCert10_913=true := by decide +kernel
def fastCert10_914 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_914 : checkCertificateFast 10 914 fastCert10_914=true := by decide +kernel
def fastCert10_915 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_915 : checkCertificateFast 10 915 fastCert10_915=true := by decide +kernel
def fastCert10_916 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_916 : checkCertificateFast 10 916 fastCert10_916=true := by decide +kernel
def fastCert10_917 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_917 : checkCertificateFast 10 917 fastCert10_917=true := by decide +kernel
def fastCert10_918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_918 : checkCertificateFast 10 918 fastCert10_918=true := by decide +kernel
def fastCert10_919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_919 : checkCertificateFast 10 919 fastCert10_919=true := by decide +kernel
def fastCert10_920 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_920 : checkCertificateFast 10 920 fastCert10_920=true := by decide +kernel
def fastCert10_921 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_921 : checkCertificateFast 10 921 fastCert10_921=true := by decide +kernel
def fastCert10_922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_922 : checkCertificateFast 10 922 fastCert10_922=true := by decide +kernel
def fastCert10_923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_923 : checkCertificateFast 10 923 fastCert10_923=true := by decide +kernel
def fastCert10_924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_924 : checkCertificateFast 10 924 fastCert10_924=true := by decide +kernel
def fastCert10_925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_925 : checkCertificateFast 10 925 fastCert10_925=true := by decide +kernel
def fastCert10_926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_926 : checkCertificateFast 10 926 fastCert10_926=true := by decide +kernel
def fastCert10_927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_927 : checkCertificateFast 10 927 fastCert10_927=true := by decide +kernel
def fastCert10_928 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_928 : checkCertificateFast 10 928 fastCert10_928=true := by decide +kernel
def fastCert10_929 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_929 : checkCertificateFast 10 929 fastCert10_929=true := by decide +kernel
def fastCert10_930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_930 : checkCertificateFast 10 930 fastCert10_930=true := by decide +kernel
def fastCert10_931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_931 : checkCertificateFast 10 931 fastCert10_931=true := by decide +kernel
def fastCert10_932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_932 : checkCertificateFast 10 932 fastCert10_932=true := by decide +kernel
def fastCert10_933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_933 : checkCertificateFast 10 933 fastCert10_933=true := by decide +kernel
def fastCert10_934 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_934 : checkCertificateFast 10 934 fastCert10_934=true := by decide +kernel
def fastCert10_935 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_935 : checkCertificateFast 10 935 fastCert10_935=true := by decide +kernel
def fastCert10_936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_936 : checkCertificateFast 10 936 fastCert10_936=true := by decide +kernel
def fastCert10_937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_937 : checkCertificateFast 10 937 fastCert10_937=true := by decide +kernel
def fastCert10_938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_938 : checkCertificateFast 10 938 fastCert10_938=true := by decide +kernel
def fastCert10_939 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_939 : checkCertificateFast 10 939 fastCert10_939=true := by decide +kernel
def fastCert10_940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_940 : checkCertificateFast 10 940 fastCert10_940=true := by decide +kernel
def fastCert10_941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_941 : checkCertificateFast 10 941 fastCert10_941=true := by decide +kernel
def fastCert10_942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_942 : checkCertificateFast 10 942 fastCert10_942=true := by decide +kernel
def fastCert10_943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_943 : checkCertificateFast 10 943 fastCert10_943=true := by decide +kernel
def fastCert10_944 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_944 : checkCertificateFast 10 944 fastCert10_944=true := by decide +kernel
def fastCert10_945 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_945 : checkCertificateFast 10 945 fastCert10_945=true := by decide +kernel
def fastCert10_946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_946 : checkCertificateFast 10 946 fastCert10_946=true := by decide +kernel
def fastCert10_947 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_947 : checkCertificateFast 10 947 fastCert10_947=true := by decide +kernel
def fastCert10_948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_948 : checkCertificateFast 10 948 fastCert10_948=true := by decide +kernel
def fastCert10_949 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_949 : checkCertificateFast 10 949 fastCert10_949=true := by decide +kernel
def fastCert10_950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_950 : checkCertificateFast 10 950 fastCert10_950=true := by decide +kernel
def fastCert10_951 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_951 : checkCertificateFast 10 951 fastCert10_951=true := by decide +kernel
def fastCert10_952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_952 : checkCertificateFast 10 952 fastCert10_952=true := by decide +kernel
def fastCert10_953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_953 : checkCertificateFast 10 953 fastCert10_953=true := by decide +kernel
def fastCert10_954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_954 : checkCertificateFast 10 954 fastCert10_954=true := by decide +kernel
def fastCert10_955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_955 : checkCertificateFast 10 955 fastCert10_955=true := by decide +kernel
def fastCert10_956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_956 : checkCertificateFast 10 956 fastCert10_956=true := by decide +kernel
def fastCert10_957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_957 : checkCertificateFast 10 957 fastCert10_957=true := by decide +kernel
def fastCert10_958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_958 : checkCertificateFast 10 958 fastCert10_958=true := by decide +kernel
def fastCert10_959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_959 : checkCertificateFast 10 959 fastCert10_959=true := by decide +kernel
def fastCert10_960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_960 : checkCertificateFast 10 960 fastCert10_960=true := by decide +kernel
def fastCert10_961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_961 : checkCertificateFast 10 961 fastCert10_961=true := by decide +kernel
def fastCert10_962 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_962 : checkCertificateFast 10 962 fastCert10_962=true := by decide +kernel
def fastCert10_963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_963 : checkCertificateFast 10 963 fastCert10_963=true := by decide +kernel
def fastCert10_964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_964 : checkCertificateFast 10 964 fastCert10_964=true := by decide +kernel
def fastCert10_965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_965 : checkCertificateFast 10 965 fastCert10_965=true := by decide +kernel
def fastCert10_966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_966 : checkCertificateFast 10 966 fastCert10_966=true := by decide +kernel
def fastCert10_967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_967 : checkCertificateFast 10 967 fastCert10_967=true := by decide +kernel
def fastCert10_968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_968 : checkCertificateFast 10 968 fastCert10_968=true := by decide +kernel
def fastCert10_969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_969 : checkCertificateFast 10 969 fastCert10_969=true := by decide +kernel
def fastCert10_970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_970 : checkCertificateFast 10 970 fastCert10_970=true := by decide +kernel
def fastCert10_971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_971 : checkCertificateFast 10 971 fastCert10_971=true := by decide +kernel
def fastCert10_972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_972 : checkCertificateFast 10 972 fastCert10_972=true := by decide +kernel
def fastCert10_973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_973 : checkCertificateFast 10 973 fastCert10_973=true := by decide +kernel
def fastCert10_974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_974 : checkCertificateFast 10 974 fastCert10_974=true := by decide +kernel
def fastCert10_975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_975 : checkCertificateFast 10 975 fastCert10_975=true := by decide +kernel
def fastCert10_976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_976 : checkCertificateFast 10 976 fastCert10_976=true := by decide +kernel
def fastCert10_977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_977 : checkCertificateFast 10 977 fastCert10_977=true := by decide +kernel
def fastCert10_978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_978 : checkCertificateFast 10 978 fastCert10_978=true := by decide +kernel
def fastCert10_979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_979 : checkCertificateFast 10 979 fastCert10_979=true := by decide +kernel
def fastCert10_980 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_980 : checkCertificateFast 10 980 fastCert10_980=true := by decide +kernel
def fastCert10_981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_981 : checkCertificateFast 10 981 fastCert10_981=true := by decide +kernel
def fastCert10_982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_982 : checkCertificateFast 10 982 fastCert10_982=true := by decide +kernel
def fastCert10_983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_983 : checkCertificateFast 10 983 fastCert10_983=true := by decide +kernel
def fastCert10_984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_984 : checkCertificateFast 10 984 fastCert10_984=true := by decide +kernel
def fastCert10_985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_985 : checkCertificateFast 10 985 fastCert10_985=true := by decide +kernel
def fastCert10_986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_986 : checkCertificateFast 10 986 fastCert10_986=true := by decide +kernel
def fastCert10_987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_987 : checkCertificateFast 10 987 fastCert10_987=true := by decide +kernel
def fastCert10_988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_988 : checkCertificateFast 10 988 fastCert10_988=true := by decide +kernel
def fastCert10_989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_989 : checkCertificateFast 10 989 fastCert10_989=true := by decide +kernel
def fastCert10_990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_990 : checkCertificateFast 10 990 fastCert10_990=true := by decide +kernel
def fastCert10_991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_991 : checkCertificateFast 10 991 fastCert10_991=true := by decide +kernel
def fastCert10_992 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_992 : checkCertificateFast 10 992 fastCert10_992=true := by decide +kernel
def fastCert10_993 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_993 : checkCertificateFast 10 993 fastCert10_993=true := by decide +kernel
def fastCert10_994 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_994 : checkCertificateFast 10 994 fastCert10_994=true := by decide +kernel
def fastCert10_995 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_995 : checkCertificateFast 10 995 fastCert10_995=true := by decide +kernel
def fastCert10_996 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_996 : checkCertificateFast 10 996 fastCert10_996=true := by decide +kernel
def fastCert10_997 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_997 : checkCertificateFast 10 997 fastCert10_997=true := by decide +kernel
def fastCert10_998 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_998 : checkCertificateFast 10 998 fastCert10_998=true := by decide +kernel
def fastCert10_999 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_999 : checkCertificateFast 10 999 fastCert10_999=true := by decide +kernel
theorem aggregate_F10_000 : (checkCertificateFast 10 0 fastCert10_0=true) ∧ (checkCertificateFast 10 1 fastCert10_1=true) ∧ (checkCertificateFast 10 2 fastCert10_2=true) ∧ (checkCertificateFast 10 3 fastCert10_3=true) ∧ (checkCertificateFast 10 4 fastCert10_4=true) ∧ (checkCertificateFast 10 5 fastCert10_5=true) ∧ (checkCertificateFast 10 6 fastCert10_6=true) ∧ (checkCertificateFast 10 7 fastCert10_7=true) ∧ (checkCertificateFast 10 8 fastCert10_8=true) ∧ (checkCertificateFast 10 9 fastCert10_9=true) ∧ (checkCertificateFast 10 10 fastCert10_10=true) ∧ (checkCertificateFast 10 11 fastCert10_11=true) ∧ (checkCertificateFast 10 12 fastCert10_12=true) ∧ (checkCertificateFast 10 13 fastCert10_13=true) ∧ (checkCertificateFast 10 14 fastCert10_14=true) ∧ (checkCertificateFast 10 15 fastCert10_15=true) ∧ (checkCertificateFast 10 16 fastCert10_16=true) ∧ (checkCertificateFast 10 17 fastCert10_17=true) ∧ (checkCertificateFast 10 18 fastCert10_18=true) ∧ (checkCertificateFast 10 19 fastCert10_19=true) ∧ (checkCertificateFast 10 20 fastCert10_20=true) ∧ (checkCertificateFast 10 21 fastCert10_21=true) ∧ (checkCertificateFast 10 22 fastCert10_22=true) ∧ (checkCertificateFast 10 23 fastCert10_23=true) ∧ (checkCertificateFast 10 24 fastCert10_24=true) ∧ (checkCertificateFast 10 25 fastCert10_25=true) ∧ (checkCertificateFast 10 26 fastCert10_26=true) ∧ (checkCertificateFast 10 27 fastCert10_27=true) ∧ (checkCertificateFast 10 28 fastCert10_28=true) ∧ (checkCertificateFast 10 29 fastCert10_29=true) ∧ (checkCertificateFast 10 30 fastCert10_30=true) ∧ (checkCertificateFast 10 31 fastCert10_31=true) ∧ (checkCertificateFast 10 32 fastCert10_32=true) ∧ (checkCertificateFast 10 33 fastCert10_33=true) ∧ (checkCertificateFast 10 34 fastCert10_34=true) ∧ (checkCertificateFast 10 35 fastCert10_35=true) ∧ (checkCertificateFast 10 36 fastCert10_36=true) ∧ (checkCertificateFast 10 37 fastCert10_37=true) ∧ (checkCertificateFast 10 38 fastCert10_38=true) ∧ (checkCertificateFast 10 39 fastCert10_39=true) ∧ (checkCertificateFast 10 40 fastCert10_40=true) ∧ (checkCertificateFast 10 41 fastCert10_41=true) ∧ (checkCertificateFast 10 42 fastCert10_42=true) ∧ (checkCertificateFast 10 43 fastCert10_43=true) ∧ (checkCertificateFast 10 44 fastCert10_44=true) ∧ (checkCertificateFast 10 45 fastCert10_45=true) ∧ (checkCertificateFast 10 46 fastCert10_46=true) ∧ (checkCertificateFast 10 47 fastCert10_47=true) ∧ (checkCertificateFast 10 48 fastCert10_48=true) ∧ (checkCertificateFast 10 49 fastCert10_49=true) ∧ (checkCertificateFast 10 50 fastCert10_50=true) ∧ (checkCertificateFast 10 51 fastCert10_51=true) ∧ (checkCertificateFast 10 52 fastCert10_52=true) ∧ (checkCertificateFast 10 53 fastCert10_53=true) ∧ (checkCertificateFast 10 54 fastCert10_54=true) ∧ (checkCertificateFast 10 55 fastCert10_55=true) ∧ (checkCertificateFast 10 56 fastCert10_56=true) ∧ (checkCertificateFast 10 57 fastCert10_57=true) ∧ (checkCertificateFast 10 58 fastCert10_58=true) ∧ (checkCertificateFast 10 59 fastCert10_59=true) ∧ (checkCertificateFast 10 60 fastCert10_60=true) ∧ (checkCertificateFast 10 61 fastCert10_61=true) ∧ (checkCertificateFast 10 62 fastCert10_62=true) ∧ (checkCertificateFast 10 63 fastCert10_63=true) ∧ (checkCertificateFast 10 64 fastCert10_64=true) ∧ (checkCertificateFast 10 65 fastCert10_65=true) ∧ (checkCertificateFast 10 66 fastCert10_66=true) ∧ (checkCertificateFast 10 67 fastCert10_67=true) ∧ (checkCertificateFast 10 68 fastCert10_68=true) ∧ (checkCertificateFast 10 69 fastCert10_69=true) ∧ (checkCertificateFast 10 70 fastCert10_70=true) ∧ (checkCertificateFast 10 71 fastCert10_71=true) ∧ (checkCertificateFast 10 72 fastCert10_72=true) ∧ (checkCertificateFast 10 73 fastCert10_73=true) ∧ (checkCertificateFast 10 74 fastCert10_74=true) ∧ (checkCertificateFast 10 75 fastCert10_75=true) ∧ (checkCertificateFast 10 76 fastCert10_76=true) ∧ (checkCertificateFast 10 77 fastCert10_77=true) ∧ (checkCertificateFast 10 78 fastCert10_78=true) ∧ (checkCertificateFast 10 79 fastCert10_79=true) ∧ (checkCertificateFast 10 80 fastCert10_80=true) ∧ (checkCertificateFast 10 81 fastCert10_81=true) ∧ (checkCertificateFast 10 82 fastCert10_82=true) ∧ (checkCertificateFast 10 83 fastCert10_83=true) ∧ (checkCertificateFast 10 84 fastCert10_84=true) ∧ (checkCertificateFast 10 85 fastCert10_85=true) ∧ (checkCertificateFast 10 86 fastCert10_86=true) ∧ (checkCertificateFast 10 87 fastCert10_87=true) ∧ (checkCertificateFast 10 88 fastCert10_88=true) ∧ (checkCertificateFast 10 89 fastCert10_89=true) ∧ (checkCertificateFast 10 90 fastCert10_90=true) ∧ (checkCertificateFast 10 91 fastCert10_91=true) ∧ (checkCertificateFast 10 92 fastCert10_92=true) ∧ (checkCertificateFast 10 93 fastCert10_93=true) ∧ (checkCertificateFast 10 94 fastCert10_94=true) ∧ (checkCertificateFast 10 95 fastCert10_95=true) ∧ (checkCertificateFast 10 96 fastCert10_96=true) ∧ (checkCertificateFast 10 97 fastCert10_97=true) ∧ (checkCertificateFast 10 98 fastCert10_98=true) ∧ (checkCertificateFast 10 99 fastCert10_99=true) ∧ (checkCertificateFast 10 100 fastCert10_100=true) ∧ (checkCertificateFast 10 101 fastCert10_101=true) ∧ (checkCertificateFast 10 102 fastCert10_102=true) ∧ (checkCertificateFast 10 103 fastCert10_103=true) ∧ (checkCertificateFast 10 104 fastCert10_104=true) ∧ (checkCertificateFast 10 105 fastCert10_105=true) ∧ (checkCertificateFast 10 106 fastCert10_106=true) ∧ (checkCertificateFast 10 107 fastCert10_107=true) ∧ (checkCertificateFast 10 108 fastCert10_108=true) ∧ (checkCertificateFast 10 109 fastCert10_109=true) ∧ (checkCertificateFast 10 110 fastCert10_110=true) ∧ (checkCertificateFast 10 111 fastCert10_111=true) ∧ (checkCertificateFast 10 112 fastCert10_112=true) ∧ (checkCertificateFast 10 113 fastCert10_113=true) ∧ (checkCertificateFast 10 114 fastCert10_114=true) ∧ (checkCertificateFast 10 115 fastCert10_115=true) ∧ (checkCertificateFast 10 116 fastCert10_116=true) ∧ (checkCertificateFast 10 117 fastCert10_117=true) ∧ (checkCertificateFast 10 118 fastCert10_118=true) ∧ (checkCertificateFast 10 119 fastCert10_119=true) ∧ (checkCertificateFast 10 120 fastCert10_120=true) ∧ (checkCertificateFast 10 121 fastCert10_121=true) ∧ (checkCertificateFast 10 122 fastCert10_122=true) ∧ (checkCertificateFast 10 123 fastCert10_123=true) ∧ (checkCertificateFast 10 124 fastCert10_124=true) ∧ (checkCertificateFast 10 125 fastCert10_125=true) ∧ (checkCertificateFast 10 126 fastCert10_126=true) ∧ (checkCertificateFast 10 127 fastCert10_127=true) ∧ (checkCertificateFast 10 128 fastCert10_128=true) ∧ (checkCertificateFast 10 129 fastCert10_129=true) ∧ (checkCertificateFast 10 130 fastCert10_130=true) ∧ (checkCertificateFast 10 131 fastCert10_131=true) ∧ (checkCertificateFast 10 132 fastCert10_132=true) ∧ (checkCertificateFast 10 133 fastCert10_133=true) ∧ (checkCertificateFast 10 134 fastCert10_134=true) ∧ (checkCertificateFast 10 135 fastCert10_135=true) ∧ (checkCertificateFast 10 136 fastCert10_136=true) ∧ (checkCertificateFast 10 137 fastCert10_137=true) ∧ (checkCertificateFast 10 138 fastCert10_138=true) ∧ (checkCertificateFast 10 139 fastCert10_139=true) ∧ (checkCertificateFast 10 140 fastCert10_140=true) ∧ (checkCertificateFast 10 141 fastCert10_141=true) ∧ (checkCertificateFast 10 142 fastCert10_142=true) ∧ (checkCertificateFast 10 143 fastCert10_143=true) ∧ (checkCertificateFast 10 144 fastCert10_144=true) ∧ (checkCertificateFast 10 145 fastCert10_145=true) ∧ (checkCertificateFast 10 146 fastCert10_146=true) ∧ (checkCertificateFast 10 147 fastCert10_147=true) ∧ (checkCertificateFast 10 148 fastCert10_148=true) ∧ (checkCertificateFast 10 149 fastCert10_149=true) ∧ (checkCertificateFast 10 150 fastCert10_150=true) ∧ (checkCertificateFast 10 151 fastCert10_151=true) ∧ (checkCertificateFast 10 152 fastCert10_152=true) ∧ (checkCertificateFast 10 153 fastCert10_153=true) ∧ (checkCertificateFast 10 154 fastCert10_154=true) ∧ (checkCertificateFast 10 155 fastCert10_155=true) ∧ (checkCertificateFast 10 156 fastCert10_156=true) ∧ (checkCertificateFast 10 157 fastCert10_157=true) ∧ (checkCertificateFast 10 158 fastCert10_158=true) ∧ (checkCertificateFast 10 159 fastCert10_159=true) ∧ (checkCertificateFast 10 160 fastCert10_160=true) ∧ (checkCertificateFast 10 161 fastCert10_161=true) ∧ (checkCertificateFast 10 162 fastCert10_162=true) ∧ (checkCertificateFast 10 163 fastCert10_163=true) ∧ (checkCertificateFast 10 164 fastCert10_164=true) ∧ (checkCertificateFast 10 165 fastCert10_165=true) ∧ (checkCertificateFast 10 166 fastCert10_166=true) ∧ (checkCertificateFast 10 167 fastCert10_167=true) ∧ (checkCertificateFast 10 168 fastCert10_168=true) ∧ (checkCertificateFast 10 169 fastCert10_169=true) ∧ (checkCertificateFast 10 170 fastCert10_170=true) ∧ (checkCertificateFast 10 171 fastCert10_171=true) ∧ (checkCertificateFast 10 172 fastCert10_172=true) ∧ (checkCertificateFast 10 173 fastCert10_173=true) ∧ (checkCertificateFast 10 174 fastCert10_174=true) ∧ (checkCertificateFast 10 175 fastCert10_175=true) ∧ (checkCertificateFast 10 176 fastCert10_176=true) ∧ (checkCertificateFast 10 177 fastCert10_177=true) ∧ (checkCertificateFast 10 178 fastCert10_178=true) ∧ (checkCertificateFast 10 179 fastCert10_179=true) ∧ (checkCertificateFast 10 180 fastCert10_180=true) ∧ (checkCertificateFast 10 181 fastCert10_181=true) ∧ (checkCertificateFast 10 182 fastCert10_182=true) ∧ (checkCertificateFast 10 183 fastCert10_183=true) ∧ (checkCertificateFast 10 184 fastCert10_184=true) ∧ (checkCertificateFast 10 185 fastCert10_185=true) ∧ (checkCertificateFast 10 186 fastCert10_186=true) ∧ (checkCertificateFast 10 187 fastCert10_187=true) ∧ (checkCertificateFast 10 188 fastCert10_188=true) ∧ (checkCertificateFast 10 189 fastCert10_189=true) ∧ (checkCertificateFast 10 190 fastCert10_190=true) ∧ (checkCertificateFast 10 191 fastCert10_191=true) ∧ (checkCertificateFast 10 192 fastCert10_192=true) ∧ (checkCertificateFast 10 193 fastCert10_193=true) ∧ (checkCertificateFast 10 194 fastCert10_194=true) ∧ (checkCertificateFast 10 195 fastCert10_195=true) ∧ (checkCertificateFast 10 196 fastCert10_196=true) ∧ (checkCertificateFast 10 197 fastCert10_197=true) ∧ (checkCertificateFast 10 198 fastCert10_198=true) ∧ (checkCertificateFast 10 199 fastCert10_199=true) ∧ (checkCertificateFast 10 200 fastCert10_200=true) ∧ (checkCertificateFast 10 201 fastCert10_201=true) ∧ (checkCertificateFast 10 202 fastCert10_202=true) ∧ (checkCertificateFast 10 203 fastCert10_203=true) ∧ (checkCertificateFast 10 204 fastCert10_204=true) ∧ (checkCertificateFast 10 205 fastCert10_205=true) ∧ (checkCertificateFast 10 206 fastCert10_206=true) ∧ (checkCertificateFast 10 207 fastCert10_207=true) ∧ (checkCertificateFast 10 208 fastCert10_208=true) ∧ (checkCertificateFast 10 209 fastCert10_209=true) ∧ (checkCertificateFast 10 210 fastCert10_210=true) ∧ (checkCertificateFast 10 211 fastCert10_211=true) ∧ (checkCertificateFast 10 212 fastCert10_212=true) ∧ (checkCertificateFast 10 213 fastCert10_213=true) ∧ (checkCertificateFast 10 214 fastCert10_214=true) ∧ (checkCertificateFast 10 215 fastCert10_215=true) ∧ (checkCertificateFast 10 216 fastCert10_216=true) ∧ (checkCertificateFast 10 217 fastCert10_217=true) ∧ (checkCertificateFast 10 218 fastCert10_218=true) ∧ (checkCertificateFast 10 219 fastCert10_219=true) ∧ (checkCertificateFast 10 220 fastCert10_220=true) ∧ (checkCertificateFast 10 221 fastCert10_221=true) ∧ (checkCertificateFast 10 222 fastCert10_222=true) ∧ (checkCertificateFast 10 223 fastCert10_223=true) ∧ (checkCertificateFast 10 224 fastCert10_224=true) ∧ (checkCertificateFast 10 225 fastCert10_225=true) ∧ (checkCertificateFast 10 226 fastCert10_226=true) ∧ (checkCertificateFast 10 227 fastCert10_227=true) ∧ (checkCertificateFast 10 228 fastCert10_228=true) ∧ (checkCertificateFast 10 229 fastCert10_229=true) ∧ (checkCertificateFast 10 230 fastCert10_230=true) ∧ (checkCertificateFast 10 231 fastCert10_231=true) ∧ (checkCertificateFast 10 232 fastCert10_232=true) ∧ (checkCertificateFast 10 233 fastCert10_233=true) ∧ (checkCertificateFast 10 234 fastCert10_234=true) ∧ (checkCertificateFast 10 235 fastCert10_235=true) ∧ (checkCertificateFast 10 236 fastCert10_236=true) ∧ (checkCertificateFast 10 237 fastCert10_237=true) ∧ (checkCertificateFast 10 238 fastCert10_238=true) ∧ (checkCertificateFast 10 239 fastCert10_239=true) ∧ (checkCertificateFast 10 240 fastCert10_240=true) ∧ (checkCertificateFast 10 241 fastCert10_241=true) ∧ (checkCertificateFast 10 242 fastCert10_242=true) ∧ (checkCertificateFast 10 243 fastCert10_243=true) ∧ (checkCertificateFast 10 244 fastCert10_244=true) ∧ (checkCertificateFast 10 245 fastCert10_245=true) ∧ (checkCertificateFast 10 246 fastCert10_246=true) ∧ (checkCertificateFast 10 247 fastCert10_247=true) ∧ (checkCertificateFast 10 248 fastCert10_248=true) ∧ (checkCertificateFast 10 249 fastCert10_249=true) ∧ (checkCertificateFast 10 250 fastCert10_250=true) ∧ (checkCertificateFast 10 251 fastCert10_251=true) ∧ (checkCertificateFast 10 252 fastCert10_252=true) ∧ (checkCertificateFast 10 253 fastCert10_253=true) ∧ (checkCertificateFast 10 254 fastCert10_254=true) ∧ (checkCertificateFast 10 255 fastCert10_255=true) ∧ (checkCertificateFast 10 256 fastCert10_256=true) ∧ (checkCertificateFast 10 257 fastCert10_257=true) ∧ (checkCertificateFast 10 258 fastCert10_258=true) ∧ (checkCertificateFast 10 259 fastCert10_259=true) ∧ (checkCertificateFast 10 260 fastCert10_260=true) ∧ (checkCertificateFast 10 261 fastCert10_261=true) ∧ (checkCertificateFast 10 262 fastCert10_262=true) ∧ (checkCertificateFast 10 263 fastCert10_263=true) ∧ (checkCertificateFast 10 264 fastCert10_264=true) ∧ (checkCertificateFast 10 265 fastCert10_265=true) ∧ (checkCertificateFast 10 266 fastCert10_266=true) ∧ (checkCertificateFast 10 267 fastCert10_267=true) ∧ (checkCertificateFast 10 268 fastCert10_268=true) ∧ (checkCertificateFast 10 269 fastCert10_269=true) ∧ (checkCertificateFast 10 270 fastCert10_270=true) ∧ (checkCertificateFast 10 271 fastCert10_271=true) ∧ (checkCertificateFast 10 272 fastCert10_272=true) ∧ (checkCertificateFast 10 273 fastCert10_273=true) ∧ (checkCertificateFast 10 274 fastCert10_274=true) ∧ (checkCertificateFast 10 275 fastCert10_275=true) ∧ (checkCertificateFast 10 276 fastCert10_276=true) ∧ (checkCertificateFast 10 277 fastCert10_277=true) ∧ (checkCertificateFast 10 278 fastCert10_278=true) ∧ (checkCertificateFast 10 279 fastCert10_279=true) ∧ (checkCertificateFast 10 280 fastCert10_280=true) ∧ (checkCertificateFast 10 281 fastCert10_281=true) ∧ (checkCertificateFast 10 282 fastCert10_282=true) ∧ (checkCertificateFast 10 283 fastCert10_283=true) ∧ (checkCertificateFast 10 284 fastCert10_284=true) ∧ (checkCertificateFast 10 285 fastCert10_285=true) ∧ (checkCertificateFast 10 286 fastCert10_286=true) ∧ (checkCertificateFast 10 287 fastCert10_287=true) ∧ (checkCertificateFast 10 288 fastCert10_288=true) ∧ (checkCertificateFast 10 289 fastCert10_289=true) ∧ (checkCertificateFast 10 290 fastCert10_290=true) ∧ (checkCertificateFast 10 291 fastCert10_291=true) ∧ (checkCertificateFast 10 292 fastCert10_292=true) ∧ (checkCertificateFast 10 293 fastCert10_293=true) ∧ (checkCertificateFast 10 294 fastCert10_294=true) ∧ (checkCertificateFast 10 295 fastCert10_295=true) ∧ (checkCertificateFast 10 296 fastCert10_296=true) ∧ (checkCertificateFast 10 297 fastCert10_297=true) ∧ (checkCertificateFast 10 298 fastCert10_298=true) ∧ (checkCertificateFast 10 299 fastCert10_299=true) ∧ (checkCertificateFast 10 300 fastCert10_300=true) ∧ (checkCertificateFast 10 301 fastCert10_301=true) ∧ (checkCertificateFast 10 302 fastCert10_302=true) ∧ (checkCertificateFast 10 303 fastCert10_303=true) ∧ (checkCertificateFast 10 304 fastCert10_304=true) ∧ (checkCertificateFast 10 305 fastCert10_305=true) ∧ (checkCertificateFast 10 306 fastCert10_306=true) ∧ (checkCertificateFast 10 307 fastCert10_307=true) ∧ (checkCertificateFast 10 308 fastCert10_308=true) ∧ (checkCertificateFast 10 309 fastCert10_309=true) ∧ (checkCertificateFast 10 310 fastCert10_310=true) ∧ (checkCertificateFast 10 311 fastCert10_311=true) ∧ (checkCertificateFast 10 312 fastCert10_312=true) ∧ (checkCertificateFast 10 313 fastCert10_313=true) ∧ (checkCertificateFast 10 314 fastCert10_314=true) ∧ (checkCertificateFast 10 315 fastCert10_315=true) ∧ (checkCertificateFast 10 316 fastCert10_316=true) ∧ (checkCertificateFast 10 317 fastCert10_317=true) ∧ (checkCertificateFast 10 318 fastCert10_318=true) ∧ (checkCertificateFast 10 319 fastCert10_319=true) ∧ (checkCertificateFast 10 320 fastCert10_320=true) ∧ (checkCertificateFast 10 321 fastCert10_321=true) ∧ (checkCertificateFast 10 322 fastCert10_322=true) ∧ (checkCertificateFast 10 323 fastCert10_323=true) ∧ (checkCertificateFast 10 324 fastCert10_324=true) ∧ (checkCertificateFast 10 325 fastCert10_325=true) ∧ (checkCertificateFast 10 326 fastCert10_326=true) ∧ (checkCertificateFast 10 327 fastCert10_327=true) ∧ (checkCertificateFast 10 328 fastCert10_328=true) ∧ (checkCertificateFast 10 329 fastCert10_329=true) ∧ (checkCertificateFast 10 330 fastCert10_330=true) ∧ (checkCertificateFast 10 331 fastCert10_331=true) ∧ (checkCertificateFast 10 332 fastCert10_332=true) ∧ (checkCertificateFast 10 333 fastCert10_333=true) ∧ (checkCertificateFast 10 334 fastCert10_334=true) ∧ (checkCertificateFast 10 335 fastCert10_335=true) ∧ (checkCertificateFast 10 336 fastCert10_336=true) ∧ (checkCertificateFast 10 337 fastCert10_337=true) ∧ (checkCertificateFast 10 338 fastCert10_338=true) ∧ (checkCertificateFast 10 339 fastCert10_339=true) ∧ (checkCertificateFast 10 340 fastCert10_340=true) ∧ (checkCertificateFast 10 341 fastCert10_341=true) ∧ (checkCertificateFast 10 342 fastCert10_342=true) ∧ (checkCertificateFast 10 343 fastCert10_343=true) ∧ (checkCertificateFast 10 344 fastCert10_344=true) ∧ (checkCertificateFast 10 345 fastCert10_345=true) ∧ (checkCertificateFast 10 346 fastCert10_346=true) ∧ (checkCertificateFast 10 347 fastCert10_347=true) ∧ (checkCertificateFast 10 348 fastCert10_348=true) ∧ (checkCertificateFast 10 349 fastCert10_349=true) ∧ (checkCertificateFast 10 350 fastCert10_350=true) ∧ (checkCertificateFast 10 351 fastCert10_351=true) ∧ (checkCertificateFast 10 352 fastCert10_352=true) ∧ (checkCertificateFast 10 353 fastCert10_353=true) ∧ (checkCertificateFast 10 354 fastCert10_354=true) ∧ (checkCertificateFast 10 355 fastCert10_355=true) ∧ (checkCertificateFast 10 356 fastCert10_356=true) ∧ (checkCertificateFast 10 357 fastCert10_357=true) ∧ (checkCertificateFast 10 358 fastCert10_358=true) ∧ (checkCertificateFast 10 359 fastCert10_359=true) ∧ (checkCertificateFast 10 360 fastCert10_360=true) ∧ (checkCertificateFast 10 361 fastCert10_361=true) ∧ (checkCertificateFast 10 362 fastCert10_362=true) ∧ (checkCertificateFast 10 363 fastCert10_363=true) ∧ (checkCertificateFast 10 364 fastCert10_364=true) ∧ (checkCertificateFast 10 365 fastCert10_365=true) ∧ (checkCertificateFast 10 366 fastCert10_366=true) ∧ (checkCertificateFast 10 367 fastCert10_367=true) ∧ (checkCertificateFast 10 368 fastCert10_368=true) ∧ (checkCertificateFast 10 369 fastCert10_369=true) ∧ (checkCertificateFast 10 370 fastCert10_370=true) ∧ (checkCertificateFast 10 371 fastCert10_371=true) ∧ (checkCertificateFast 10 372 fastCert10_372=true) ∧ (checkCertificateFast 10 373 fastCert10_373=true) ∧ (checkCertificateFast 10 374 fastCert10_374=true) ∧ (checkCertificateFast 10 375 fastCert10_375=true) ∧ (checkCertificateFast 10 376 fastCert10_376=true) ∧ (checkCertificateFast 10 377 fastCert10_377=true) ∧ (checkCertificateFast 10 378 fastCert10_378=true) ∧ (checkCertificateFast 10 379 fastCert10_379=true) ∧ (checkCertificateFast 10 380 fastCert10_380=true) ∧ (checkCertificateFast 10 381 fastCert10_381=true) ∧ (checkCertificateFast 10 382 fastCert10_382=true) ∧ (checkCertificateFast 10 383 fastCert10_383=true) ∧ (checkCertificateFast 10 384 fastCert10_384=true) ∧ (checkCertificateFast 10 385 fastCert10_385=true) ∧ (checkCertificateFast 10 386 fastCert10_386=true) ∧ (checkCertificateFast 10 387 fastCert10_387=true) ∧ (checkCertificateFast 10 388 fastCert10_388=true) ∧ (checkCertificateFast 10 389 fastCert10_389=true) ∧ (checkCertificateFast 10 390 fastCert10_390=true) ∧ (checkCertificateFast 10 391 fastCert10_391=true) ∧ (checkCertificateFast 10 392 fastCert10_392=true) ∧ (checkCertificateFast 10 393 fastCert10_393=true) ∧ (checkCertificateFast 10 394 fastCert10_394=true) ∧ (checkCertificateFast 10 395 fastCert10_395=true) ∧ (checkCertificateFast 10 396 fastCert10_396=true) ∧ (checkCertificateFast 10 397 fastCert10_397=true) ∧ (checkCertificateFast 10 398 fastCert10_398=true) ∧ (checkCertificateFast 10 399 fastCert10_399=true) ∧ (checkCertificateFast 10 400 fastCert10_400=true) ∧ (checkCertificateFast 10 401 fastCert10_401=true) ∧ (checkCertificateFast 10 402 fastCert10_402=true) ∧ (checkCertificateFast 10 403 fastCert10_403=true) ∧ (checkCertificateFast 10 404 fastCert10_404=true) ∧ (checkCertificateFast 10 405 fastCert10_405=true) ∧ (checkCertificateFast 10 406 fastCert10_406=true) ∧ (checkCertificateFast 10 407 fastCert10_407=true) ∧ (checkCertificateFast 10 408 fastCert10_408=true) ∧ (checkCertificateFast 10 409 fastCert10_409=true) ∧ (checkCertificateFast 10 410 fastCert10_410=true) ∧ (checkCertificateFast 10 411 fastCert10_411=true) ∧ (checkCertificateFast 10 412 fastCert10_412=true) ∧ (checkCertificateFast 10 413 fastCert10_413=true) ∧ (checkCertificateFast 10 414 fastCert10_414=true) ∧ (checkCertificateFast 10 415 fastCert10_415=true) ∧ (checkCertificateFast 10 416 fastCert10_416=true) ∧ (checkCertificateFast 10 417 fastCert10_417=true) ∧ (checkCertificateFast 10 418 fastCert10_418=true) ∧ (checkCertificateFast 10 419 fastCert10_419=true) ∧ (checkCertificateFast 10 420 fastCert10_420=true) ∧ (checkCertificateFast 10 421 fastCert10_421=true) ∧ (checkCertificateFast 10 422 fastCert10_422=true) ∧ (checkCertificateFast 10 423 fastCert10_423=true) ∧ (checkCertificateFast 10 424 fastCert10_424=true) ∧ (checkCertificateFast 10 425 fastCert10_425=true) ∧ (checkCertificateFast 10 426 fastCert10_426=true) ∧ (checkCertificateFast 10 427 fastCert10_427=true) ∧ (checkCertificateFast 10 428 fastCert10_428=true) ∧ (checkCertificateFast 10 429 fastCert10_429=true) ∧ (checkCertificateFast 10 430 fastCert10_430=true) ∧ (checkCertificateFast 10 431 fastCert10_431=true) ∧ (checkCertificateFast 10 432 fastCert10_432=true) ∧ (checkCertificateFast 10 433 fastCert10_433=true) ∧ (checkCertificateFast 10 434 fastCert10_434=true) ∧ (checkCertificateFast 10 435 fastCert10_435=true) ∧ (checkCertificateFast 10 436 fastCert10_436=true) ∧ (checkCertificateFast 10 437 fastCert10_437=true) ∧ (checkCertificateFast 10 438 fastCert10_438=true) ∧ (checkCertificateFast 10 439 fastCert10_439=true) ∧ (checkCertificateFast 10 440 fastCert10_440=true) ∧ (checkCertificateFast 10 441 fastCert10_441=true) ∧ (checkCertificateFast 10 442 fastCert10_442=true) ∧ (checkCertificateFast 10 443 fastCert10_443=true) ∧ (checkCertificateFast 10 444 fastCert10_444=true) ∧ (checkCertificateFast 10 445 fastCert10_445=true) ∧ (checkCertificateFast 10 446 fastCert10_446=true) ∧ (checkCertificateFast 10 447 fastCert10_447=true) ∧ (checkCertificateFast 10 448 fastCert10_448=true) ∧ (checkCertificateFast 10 449 fastCert10_449=true) ∧ (checkCertificateFast 10 450 fastCert10_450=true) ∧ (checkCertificateFast 10 451 fastCert10_451=true) ∧ (checkCertificateFast 10 452 fastCert10_452=true) ∧ (checkCertificateFast 10 453 fastCert10_453=true) ∧ (checkCertificateFast 10 454 fastCert10_454=true) ∧ (checkCertificateFast 10 455 fastCert10_455=true) ∧ (checkCertificateFast 10 456 fastCert10_456=true) ∧ (checkCertificateFast 10 457 fastCert10_457=true) ∧ (checkCertificateFast 10 458 fastCert10_458=true) ∧ (checkCertificateFast 10 459 fastCert10_459=true) ∧ (checkCertificateFast 10 460 fastCert10_460=true) ∧ (checkCertificateFast 10 461 fastCert10_461=true) ∧ (checkCertificateFast 10 462 fastCert10_462=true) ∧ (checkCertificateFast 10 463 fastCert10_463=true) ∧ (checkCertificateFast 10 464 fastCert10_464=true) ∧ (checkCertificateFast 10 465 fastCert10_465=true) ∧ (checkCertificateFast 10 466 fastCert10_466=true) ∧ (checkCertificateFast 10 467 fastCert10_467=true) ∧ (checkCertificateFast 10 468 fastCert10_468=true) ∧ (checkCertificateFast 10 469 fastCert10_469=true) ∧ (checkCertificateFast 10 470 fastCert10_470=true) ∧ (checkCertificateFast 10 471 fastCert10_471=true) ∧ (checkCertificateFast 10 472 fastCert10_472=true) ∧ (checkCertificateFast 10 473 fastCert10_473=true) ∧ (checkCertificateFast 10 474 fastCert10_474=true) ∧ (checkCertificateFast 10 475 fastCert10_475=true) ∧ (checkCertificateFast 10 476 fastCert10_476=true) ∧ (checkCertificateFast 10 477 fastCert10_477=true) ∧ (checkCertificateFast 10 478 fastCert10_478=true) ∧ (checkCertificateFast 10 479 fastCert10_479=true) ∧ (checkCertificateFast 10 480 fastCert10_480=true) ∧ (checkCertificateFast 10 481 fastCert10_481=true) ∧ (checkCertificateFast 10 482 fastCert10_482=true) ∧ (checkCertificateFast 10 483 fastCert10_483=true) ∧ (checkCertificateFast 10 484 fastCert10_484=true) ∧ (checkCertificateFast 10 485 fastCert10_485=true) ∧ (checkCertificateFast 10 486 fastCert10_486=true) ∧ (checkCertificateFast 10 487 fastCert10_487=true) ∧ (checkCertificateFast 10 488 fastCert10_488=true) ∧ (checkCertificateFast 10 489 fastCert10_489=true) ∧ (checkCertificateFast 10 490 fastCert10_490=true) ∧ (checkCertificateFast 10 491 fastCert10_491=true) ∧ (checkCertificateFast 10 492 fastCert10_492=true) ∧ (checkCertificateFast 10 493 fastCert10_493=true) ∧ (checkCertificateFast 10 494 fastCert10_494=true) ∧ (checkCertificateFast 10 495 fastCert10_495=true) ∧ (checkCertificateFast 10 496 fastCert10_496=true) ∧ (checkCertificateFast 10 497 fastCert10_497=true) ∧ (checkCertificateFast 10 498 fastCert10_498=true) ∧ (checkCertificateFast 10 499 fastCert10_499=true) ∧ (checkCertificateFast 10 500 fastCert10_500=true) ∧ (checkCertificateFast 10 501 fastCert10_501=true) ∧ (checkCertificateFast 10 502 fastCert10_502=true) ∧ (checkCertificateFast 10 503 fastCert10_503=true) ∧ (checkCertificateFast 10 504 fastCert10_504=true) ∧ (checkCertificateFast 10 505 fastCert10_505=true) ∧ (checkCertificateFast 10 506 fastCert10_506=true) ∧ (checkCertificateFast 10 507 fastCert10_507=true) ∧ (checkCertificateFast 10 508 fastCert10_508=true) ∧ (checkCertificateFast 10 509 fastCert10_509=true) ∧ (checkCertificateFast 10 510 fastCert10_510=true) ∧ (checkCertificateFast 10 511 fastCert10_511=true) ∧ (checkCertificateFast 10 512 fastCert10_512=true) ∧ (checkCertificateFast 10 513 fastCert10_513=true) ∧ (checkCertificateFast 10 514 fastCert10_514=true) ∧ (checkCertificateFast 10 515 fastCert10_515=true) ∧ (checkCertificateFast 10 516 fastCert10_516=true) ∧ (checkCertificateFast 10 517 fastCert10_517=true) ∧ (checkCertificateFast 10 518 fastCert10_518=true) ∧ (checkCertificateFast 10 519 fastCert10_519=true) ∧ (checkCertificateFast 10 520 fastCert10_520=true) ∧ (checkCertificateFast 10 521 fastCert10_521=true) ∧ (checkCertificateFast 10 522 fastCert10_522=true) ∧ (checkCertificateFast 10 523 fastCert10_523=true) ∧ (checkCertificateFast 10 524 fastCert10_524=true) ∧ (checkCertificateFast 10 525 fastCert10_525=true) ∧ (checkCertificateFast 10 526 fastCert10_526=true) ∧ (checkCertificateFast 10 527 fastCert10_527=true) ∧ (checkCertificateFast 10 528 fastCert10_528=true) ∧ (checkCertificateFast 10 529 fastCert10_529=true) ∧ (checkCertificateFast 10 530 fastCert10_530=true) ∧ (checkCertificateFast 10 531 fastCert10_531=true) ∧ (checkCertificateFast 10 532 fastCert10_532=true) ∧ (checkCertificateFast 10 533 fastCert10_533=true) ∧ (checkCertificateFast 10 534 fastCert10_534=true) ∧ (checkCertificateFast 10 535 fastCert10_535=true) ∧ (checkCertificateFast 10 536 fastCert10_536=true) ∧ (checkCertificateFast 10 537 fastCert10_537=true) ∧ (checkCertificateFast 10 538 fastCert10_538=true) ∧ (checkCertificateFast 10 539 fastCert10_539=true) ∧ (checkCertificateFast 10 540 fastCert10_540=true) ∧ (checkCertificateFast 10 541 fastCert10_541=true) ∧ (checkCertificateFast 10 542 fastCert10_542=true) ∧ (checkCertificateFast 10 543 fastCert10_543=true) ∧ (checkCertificateFast 10 544 fastCert10_544=true) ∧ (checkCertificateFast 10 545 fastCert10_545=true) ∧ (checkCertificateFast 10 546 fastCert10_546=true) ∧ (checkCertificateFast 10 547 fastCert10_547=true) ∧ (checkCertificateFast 10 548 fastCert10_548=true) ∧ (checkCertificateFast 10 549 fastCert10_549=true) ∧ (checkCertificateFast 10 550 fastCert10_550=true) ∧ (checkCertificateFast 10 551 fastCert10_551=true) ∧ (checkCertificateFast 10 552 fastCert10_552=true) ∧ (checkCertificateFast 10 553 fastCert10_553=true) ∧ (checkCertificateFast 10 554 fastCert10_554=true) ∧ (checkCertificateFast 10 555 fastCert10_555=true) ∧ (checkCertificateFast 10 556 fastCert10_556=true) ∧ (checkCertificateFast 10 557 fastCert10_557=true) ∧ (checkCertificateFast 10 558 fastCert10_558=true) ∧ (checkCertificateFast 10 559 fastCert10_559=true) ∧ (checkCertificateFast 10 560 fastCert10_560=true) ∧ (checkCertificateFast 10 561 fastCert10_561=true) ∧ (checkCertificateFast 10 562 fastCert10_562=true) ∧ (checkCertificateFast 10 563 fastCert10_563=true) ∧ (checkCertificateFast 10 564 fastCert10_564=true) ∧ (checkCertificateFast 10 565 fastCert10_565=true) ∧ (checkCertificateFast 10 566 fastCert10_566=true) ∧ (checkCertificateFast 10 567 fastCert10_567=true) ∧ (checkCertificateFast 10 568 fastCert10_568=true) ∧ (checkCertificateFast 10 569 fastCert10_569=true) ∧ (checkCertificateFast 10 570 fastCert10_570=true) ∧ (checkCertificateFast 10 571 fastCert10_571=true) ∧ (checkCertificateFast 10 572 fastCert10_572=true) ∧ (checkCertificateFast 10 573 fastCert10_573=true) ∧ (checkCertificateFast 10 574 fastCert10_574=true) ∧ (checkCertificateFast 10 575 fastCert10_575=true) ∧ (checkCertificateFast 10 576 fastCert10_576=true) ∧ (checkCertificateFast 10 577 fastCert10_577=true) ∧ (checkCertificateFast 10 578 fastCert10_578=true) ∧ (checkCertificateFast 10 579 fastCert10_579=true) ∧ (checkCertificateFast 10 580 fastCert10_580=true) ∧ (checkCertificateFast 10 581 fastCert10_581=true) ∧ (checkCertificateFast 10 582 fastCert10_582=true) ∧ (checkCertificateFast 10 583 fastCert10_583=true) ∧ (checkCertificateFast 10 584 fastCert10_584=true) ∧ (checkCertificateFast 10 585 fastCert10_585=true) ∧ (checkCertificateFast 10 586 fastCert10_586=true) ∧ (checkCertificateFast 10 587 fastCert10_587=true) ∧ (checkCertificateFast 10 588 fastCert10_588=true) ∧ (checkCertificateFast 10 589 fastCert10_589=true) ∧ (checkCertificateFast 10 590 fastCert10_590=true) ∧ (checkCertificateFast 10 591 fastCert10_591=true) ∧ (checkCertificateFast 10 592 fastCert10_592=true) ∧ (checkCertificateFast 10 593 fastCert10_593=true) ∧ (checkCertificateFast 10 594 fastCert10_594=true) ∧ (checkCertificateFast 10 595 fastCert10_595=true) ∧ (checkCertificateFast 10 596 fastCert10_596=true) ∧ (checkCertificateFast 10 597 fastCert10_597=true) ∧ (checkCertificateFast 10 598 fastCert10_598=true) ∧ (checkCertificateFast 10 599 fastCert10_599=true) ∧ (checkCertificateFast 10 600 fastCert10_600=true) ∧ (checkCertificateFast 10 601 fastCert10_601=true) ∧ (checkCertificateFast 10 602 fastCert10_602=true) ∧ (checkCertificateFast 10 603 fastCert10_603=true) ∧ (checkCertificateFast 10 604 fastCert10_604=true) ∧ (checkCertificateFast 10 605 fastCert10_605=true) ∧ (checkCertificateFast 10 606 fastCert10_606=true) ∧ (checkCertificateFast 10 607 fastCert10_607=true) ∧ (checkCertificateFast 10 608 fastCert10_608=true) ∧ (checkCertificateFast 10 609 fastCert10_609=true) ∧ (checkCertificateFast 10 610 fastCert10_610=true) ∧ (checkCertificateFast 10 611 fastCert10_611=true) ∧ (checkCertificateFast 10 612 fastCert10_612=true) ∧ (checkCertificateFast 10 613 fastCert10_613=true) ∧ (checkCertificateFast 10 614 fastCert10_614=true) ∧ (checkCertificateFast 10 615 fastCert10_615=true) ∧ (checkCertificateFast 10 616 fastCert10_616=true) ∧ (checkCertificateFast 10 617 fastCert10_617=true) ∧ (checkCertificateFast 10 618 fastCert10_618=true) ∧ (checkCertificateFast 10 619 fastCert10_619=true) ∧ (checkCertificateFast 10 620 fastCert10_620=true) ∧ (checkCertificateFast 10 621 fastCert10_621=true) ∧ (checkCertificateFast 10 622 fastCert10_622=true) ∧ (checkCertificateFast 10 623 fastCert10_623=true) ∧ (checkCertificateFast 10 624 fastCert10_624=true) ∧ (checkCertificateFast 10 625 fastCert10_625=true) ∧ (checkCertificateFast 10 626 fastCert10_626=true) ∧ (checkCertificateFast 10 627 fastCert10_627=true) ∧ (checkCertificateFast 10 628 fastCert10_628=true) ∧ (checkCertificateFast 10 629 fastCert10_629=true) ∧ (checkCertificateFast 10 630 fastCert10_630=true) ∧ (checkCertificateFast 10 631 fastCert10_631=true) ∧ (checkCertificateFast 10 632 fastCert10_632=true) ∧ (checkCertificateFast 10 633 fastCert10_633=true) ∧ (checkCertificateFast 10 634 fastCert10_634=true) ∧ (checkCertificateFast 10 635 fastCert10_635=true) ∧ (checkCertificateFast 10 636 fastCert10_636=true) ∧ (checkCertificateFast 10 637 fastCert10_637=true) ∧ (checkCertificateFast 10 638 fastCert10_638=true) ∧ (checkCertificateFast 10 639 fastCert10_639=true) ∧ (checkCertificateFast 10 640 fastCert10_640=true) ∧ (checkCertificateFast 10 641 fastCert10_641=true) ∧ (checkCertificateFast 10 642 fastCert10_642=true) ∧ (checkCertificateFast 10 643 fastCert10_643=true) ∧ (checkCertificateFast 10 644 fastCert10_644=true) ∧ (checkCertificateFast 10 645 fastCert10_645=true) ∧ (checkCertificateFast 10 646 fastCert10_646=true) ∧ (checkCertificateFast 10 647 fastCert10_647=true) ∧ (checkCertificateFast 10 648 fastCert10_648=true) ∧ (checkCertificateFast 10 649 fastCert10_649=true) ∧ (checkCertificateFast 10 650 fastCert10_650=true) ∧ (checkCertificateFast 10 651 fastCert10_651=true) ∧ (checkCertificateFast 10 652 fastCert10_652=true) ∧ (checkCertificateFast 10 653 fastCert10_653=true) ∧ (checkCertificateFast 10 654 fastCert10_654=true) ∧ (checkCertificateFast 10 655 fastCert10_655=true) ∧ (checkCertificateFast 10 656 fastCert10_656=true) ∧ (checkCertificateFast 10 657 fastCert10_657=true) ∧ (checkCertificateFast 10 658 fastCert10_658=true) ∧ (checkCertificateFast 10 659 fastCert10_659=true) ∧ (checkCertificateFast 10 660 fastCert10_660=true) ∧ (checkCertificateFast 10 661 fastCert10_661=true) ∧ (checkCertificateFast 10 662 fastCert10_662=true) ∧ (checkCertificateFast 10 663 fastCert10_663=true) ∧ (checkCertificateFast 10 664 fastCert10_664=true) ∧ (checkCertificateFast 10 665 fastCert10_665=true) ∧ (checkCertificateFast 10 666 fastCert10_666=true) ∧ (checkCertificateFast 10 667 fastCert10_667=true) ∧ (checkCertificateFast 10 668 fastCert10_668=true) ∧ (checkCertificateFast 10 669 fastCert10_669=true) ∧ (checkCertificateFast 10 670 fastCert10_670=true) ∧ (checkCertificateFast 10 671 fastCert10_671=true) ∧ (checkCertificateFast 10 672 fastCert10_672=true) ∧ (checkCertificateFast 10 673 fastCert10_673=true) ∧ (checkCertificateFast 10 674 fastCert10_674=true) ∧ (checkCertificateFast 10 675 fastCert10_675=true) ∧ (checkCertificateFast 10 676 fastCert10_676=true) ∧ (checkCertificateFast 10 677 fastCert10_677=true) ∧ (checkCertificateFast 10 678 fastCert10_678=true) ∧ (checkCertificateFast 10 679 fastCert10_679=true) ∧ (checkCertificateFast 10 680 fastCert10_680=true) ∧ (checkCertificateFast 10 681 fastCert10_681=true) ∧ (checkCertificateFast 10 682 fastCert10_682=true) ∧ (checkCertificateFast 10 683 fastCert10_683=true) ∧ (checkCertificateFast 10 684 fastCert10_684=true) ∧ (checkCertificateFast 10 685 fastCert10_685=true) ∧ (checkCertificateFast 10 686 fastCert10_686=true) ∧ (checkCertificateFast 10 687 fastCert10_687=true) ∧ (checkCertificateFast 10 688 fastCert10_688=true) ∧ (checkCertificateFast 10 689 fastCert10_689=true) ∧ (checkCertificateFast 10 690 fastCert10_690=true) ∧ (checkCertificateFast 10 691 fastCert10_691=true) ∧ (checkCertificateFast 10 692 fastCert10_692=true) ∧ (checkCertificateFast 10 693 fastCert10_693=true) ∧ (checkCertificateFast 10 694 fastCert10_694=true) ∧ (checkCertificateFast 10 695 fastCert10_695=true) ∧ (checkCertificateFast 10 696 fastCert10_696=true) ∧ (checkCertificateFast 10 697 fastCert10_697=true) ∧ (checkCertificateFast 10 698 fastCert10_698=true) ∧ (checkCertificateFast 10 699 fastCert10_699=true) ∧ (checkCertificateFast 10 700 fastCert10_700=true) ∧ (checkCertificateFast 10 701 fastCert10_701=true) ∧ (checkCertificateFast 10 702 fastCert10_702=true) ∧ (checkCertificateFast 10 703 fastCert10_703=true) ∧ (checkCertificateFast 10 704 fastCert10_704=true) ∧ (checkCertificateFast 10 705 fastCert10_705=true) ∧ (checkCertificateFast 10 706 fastCert10_706=true) ∧ (checkCertificateFast 10 707 fastCert10_707=true) ∧ (checkCertificateFast 10 708 fastCert10_708=true) ∧ (checkCertificateFast 10 709 fastCert10_709=true) ∧ (checkCertificateFast 10 710 fastCert10_710=true) ∧ (checkCertificateFast 10 711 fastCert10_711=true) ∧ (checkCertificateFast 10 712 fastCert10_712=true) ∧ (checkCertificateFast 10 713 fastCert10_713=true) ∧ (checkCertificateFast 10 714 fastCert10_714=true) ∧ (checkCertificateFast 10 715 fastCert10_715=true) ∧ (checkCertificateFast 10 716 fastCert10_716=true) ∧ (checkCertificateFast 10 717 fastCert10_717=true) ∧ (checkCertificateFast 10 718 fastCert10_718=true) ∧ (checkCertificateFast 10 719 fastCert10_719=true) ∧ (checkCertificateFast 10 720 fastCert10_720=true) ∧ (checkCertificateFast 10 721 fastCert10_721=true) ∧ (checkCertificateFast 10 722 fastCert10_722=true) ∧ (checkCertificateFast 10 723 fastCert10_723=true) ∧ (checkCertificateFast 10 724 fastCert10_724=true) ∧ (checkCertificateFast 10 725 fastCert10_725=true) ∧ (checkCertificateFast 10 726 fastCert10_726=true) ∧ (checkCertificateFast 10 727 fastCert10_727=true) ∧ (checkCertificateFast 10 728 fastCert10_728=true) ∧ (checkCertificateFast 10 729 fastCert10_729=true) ∧ (checkCertificateFast 10 730 fastCert10_730=true) ∧ (checkCertificateFast 10 731 fastCert10_731=true) ∧ (checkCertificateFast 10 732 fastCert10_732=true) ∧ (checkCertificateFast 10 733 fastCert10_733=true) ∧ (checkCertificateFast 10 734 fastCert10_734=true) ∧ (checkCertificateFast 10 735 fastCert10_735=true) ∧ (checkCertificateFast 10 736 fastCert10_736=true) ∧ (checkCertificateFast 10 737 fastCert10_737=true) ∧ (checkCertificateFast 10 738 fastCert10_738=true) ∧ (checkCertificateFast 10 739 fastCert10_739=true) ∧ (checkCertificateFast 10 740 fastCert10_740=true) ∧ (checkCertificateFast 10 741 fastCert10_741=true) ∧ (checkCertificateFast 10 742 fastCert10_742=true) ∧ (checkCertificateFast 10 743 fastCert10_743=true) ∧ (checkCertificateFast 10 744 fastCert10_744=true) ∧ (checkCertificateFast 10 745 fastCert10_745=true) ∧ (checkCertificateFast 10 746 fastCert10_746=true) ∧ (checkCertificateFast 10 747 fastCert10_747=true) ∧ (checkCertificateFast 10 748 fastCert10_748=true) ∧ (checkCertificateFast 10 749 fastCert10_749=true) ∧ (checkCertificateFast 10 750 fastCert10_750=true) ∧ (checkCertificateFast 10 751 fastCert10_751=true) ∧ (checkCertificateFast 10 752 fastCert10_752=true) ∧ (checkCertificateFast 10 753 fastCert10_753=true) ∧ (checkCertificateFast 10 754 fastCert10_754=true) ∧ (checkCertificateFast 10 755 fastCert10_755=true) ∧ (checkCertificateFast 10 756 fastCert10_756=true) ∧ (checkCertificateFast 10 757 fastCert10_757=true) ∧ (checkCertificateFast 10 758 fastCert10_758=true) ∧ (checkCertificateFast 10 759 fastCert10_759=true) ∧ (checkCertificateFast 10 760 fastCert10_760=true) ∧ (checkCertificateFast 10 761 fastCert10_761=true) ∧ (checkCertificateFast 10 762 fastCert10_762=true) ∧ (checkCertificateFast 10 763 fastCert10_763=true) ∧ (checkCertificateFast 10 764 fastCert10_764=true) ∧ (checkCertificateFast 10 765 fastCert10_765=true) ∧ (checkCertificateFast 10 766 fastCert10_766=true) ∧ (checkCertificateFast 10 767 fastCert10_767=true) ∧ (checkCertificateFast 10 768 fastCert10_768=true) ∧ (checkCertificateFast 10 769 fastCert10_769=true) ∧ (checkCertificateFast 10 770 fastCert10_770=true) ∧ (checkCertificateFast 10 771 fastCert10_771=true) ∧ (checkCertificateFast 10 772 fastCert10_772=true) ∧ (checkCertificateFast 10 773 fastCert10_773=true) ∧ (checkCertificateFast 10 774 fastCert10_774=true) ∧ (checkCertificateFast 10 775 fastCert10_775=true) ∧ (checkCertificateFast 10 776 fastCert10_776=true) ∧ (checkCertificateFast 10 777 fastCert10_777=true) ∧ (checkCertificateFast 10 778 fastCert10_778=true) ∧ (checkCertificateFast 10 779 fastCert10_779=true) ∧ (checkCertificateFast 10 780 fastCert10_780=true) ∧ (checkCertificateFast 10 781 fastCert10_781=true) ∧ (checkCertificateFast 10 782 fastCert10_782=true) ∧ (checkCertificateFast 10 783 fastCert10_783=true) ∧ (checkCertificateFast 10 784 fastCert10_784=true) ∧ (checkCertificateFast 10 785 fastCert10_785=true) ∧ (checkCertificateFast 10 786 fastCert10_786=true) ∧ (checkCertificateFast 10 787 fastCert10_787=true) ∧ (checkCertificateFast 10 788 fastCert10_788=true) ∧ (checkCertificateFast 10 789 fastCert10_789=true) ∧ (checkCertificateFast 10 790 fastCert10_790=true) ∧ (checkCertificateFast 10 791 fastCert10_791=true) ∧ (checkCertificateFast 10 792 fastCert10_792=true) ∧ (checkCertificateFast 10 793 fastCert10_793=true) ∧ (checkCertificateFast 10 794 fastCert10_794=true) ∧ (checkCertificateFast 10 795 fastCert10_795=true) ∧ (checkCertificateFast 10 796 fastCert10_796=true) ∧ (checkCertificateFast 10 797 fastCert10_797=true) ∧ (checkCertificateFast 10 798 fastCert10_798=true) ∧ (checkCertificateFast 10 799 fastCert10_799=true) ∧ (checkCertificateFast 10 800 fastCert10_800=true) ∧ (checkCertificateFast 10 801 fastCert10_801=true) ∧ (checkCertificateFast 10 802 fastCert10_802=true) ∧ (checkCertificateFast 10 803 fastCert10_803=true) ∧ (checkCertificateFast 10 804 fastCert10_804=true) ∧ (checkCertificateFast 10 805 fastCert10_805=true) ∧ (checkCertificateFast 10 806 fastCert10_806=true) ∧ (checkCertificateFast 10 807 fastCert10_807=true) ∧ (checkCertificateFast 10 808 fastCert10_808=true) ∧ (checkCertificateFast 10 809 fastCert10_809=true) ∧ (checkCertificateFast 10 810 fastCert10_810=true) ∧ (checkCertificateFast 10 811 fastCert10_811=true) ∧ (checkCertificateFast 10 812 fastCert10_812=true) ∧ (checkCertificateFast 10 813 fastCert10_813=true) ∧ (checkCertificateFast 10 814 fastCert10_814=true) ∧ (checkCertificateFast 10 815 fastCert10_815=true) ∧ (checkCertificateFast 10 816 fastCert10_816=true) ∧ (checkCertificateFast 10 817 fastCert10_817=true) ∧ (checkCertificateFast 10 818 fastCert10_818=true) ∧ (checkCertificateFast 10 819 fastCert10_819=true) ∧ (checkCertificateFast 10 820 fastCert10_820=true) ∧ (checkCertificateFast 10 821 fastCert10_821=true) ∧ (checkCertificateFast 10 822 fastCert10_822=true) ∧ (checkCertificateFast 10 823 fastCert10_823=true) ∧ (checkCertificateFast 10 824 fastCert10_824=true) ∧ (checkCertificateFast 10 825 fastCert10_825=true) ∧ (checkCertificateFast 10 826 fastCert10_826=true) ∧ (checkCertificateFast 10 827 fastCert10_827=true) ∧ (checkCertificateFast 10 828 fastCert10_828=true) ∧ (checkCertificateFast 10 829 fastCert10_829=true) ∧ (checkCertificateFast 10 830 fastCert10_830=true) ∧ (checkCertificateFast 10 831 fastCert10_831=true) ∧ (checkCertificateFast 10 832 fastCert10_832=true) ∧ (checkCertificateFast 10 833 fastCert10_833=true) ∧ (checkCertificateFast 10 834 fastCert10_834=true) ∧ (checkCertificateFast 10 835 fastCert10_835=true) ∧ (checkCertificateFast 10 836 fastCert10_836=true) ∧ (checkCertificateFast 10 837 fastCert10_837=true) ∧ (checkCertificateFast 10 838 fastCert10_838=true) ∧ (checkCertificateFast 10 839 fastCert10_839=true) ∧ (checkCertificateFast 10 840 fastCert10_840=true) ∧ (checkCertificateFast 10 841 fastCert10_841=true) ∧ (checkCertificateFast 10 842 fastCert10_842=true) ∧ (checkCertificateFast 10 843 fastCert10_843=true) ∧ (checkCertificateFast 10 844 fastCert10_844=true) ∧ (checkCertificateFast 10 845 fastCert10_845=true) ∧ (checkCertificateFast 10 846 fastCert10_846=true) ∧ (checkCertificateFast 10 847 fastCert10_847=true) ∧ (checkCertificateFast 10 848 fastCert10_848=true) ∧ (checkCertificateFast 10 849 fastCert10_849=true) ∧ (checkCertificateFast 10 850 fastCert10_850=true) ∧ (checkCertificateFast 10 851 fastCert10_851=true) ∧ (checkCertificateFast 10 852 fastCert10_852=true) ∧ (checkCertificateFast 10 853 fastCert10_853=true) ∧ (checkCertificateFast 10 854 fastCert10_854=true) ∧ (checkCertificateFast 10 855 fastCert10_855=true) ∧ (checkCertificateFast 10 856 fastCert10_856=true) ∧ (checkCertificateFast 10 857 fastCert10_857=true) ∧ (checkCertificateFast 10 858 fastCert10_858=true) ∧ (checkCertificateFast 10 859 fastCert10_859=true) ∧ (checkCertificateFast 10 860 fastCert10_860=true) ∧ (checkCertificateFast 10 861 fastCert10_861=true) ∧ (checkCertificateFast 10 862 fastCert10_862=true) ∧ (checkCertificateFast 10 863 fastCert10_863=true) ∧ (checkCertificateFast 10 864 fastCert10_864=true) ∧ (checkCertificateFast 10 865 fastCert10_865=true) ∧ (checkCertificateFast 10 866 fastCert10_866=true) ∧ (checkCertificateFast 10 867 fastCert10_867=true) ∧ (checkCertificateFast 10 868 fastCert10_868=true) ∧ (checkCertificateFast 10 869 fastCert10_869=true) ∧ (checkCertificateFast 10 870 fastCert10_870=true) ∧ (checkCertificateFast 10 871 fastCert10_871=true) ∧ (checkCertificateFast 10 872 fastCert10_872=true) ∧ (checkCertificateFast 10 873 fastCert10_873=true) ∧ (checkCertificateFast 10 874 fastCert10_874=true) ∧ (checkCertificateFast 10 875 fastCert10_875=true) ∧ (checkCertificateFast 10 876 fastCert10_876=true) ∧ (checkCertificateFast 10 877 fastCert10_877=true) ∧ (checkCertificateFast 10 878 fastCert10_878=true) ∧ (checkCertificateFast 10 879 fastCert10_879=true) ∧ (checkCertificateFast 10 880 fastCert10_880=true) ∧ (checkCertificateFast 10 881 fastCert10_881=true) ∧ (checkCertificateFast 10 882 fastCert10_882=true) ∧ (checkCertificateFast 10 883 fastCert10_883=true) ∧ (checkCertificateFast 10 884 fastCert10_884=true) ∧ (checkCertificateFast 10 885 fastCert10_885=true) ∧ (checkCertificateFast 10 886 fastCert10_886=true) ∧ (checkCertificateFast 10 887 fastCert10_887=true) ∧ (checkCertificateFast 10 888 fastCert10_888=true) ∧ (checkCertificateFast 10 889 fastCert10_889=true) ∧ (checkCertificateFast 10 890 fastCert10_890=true) ∧ (checkCertificateFast 10 891 fastCert10_891=true) ∧ (checkCertificateFast 10 892 fastCert10_892=true) ∧ (checkCertificateFast 10 893 fastCert10_893=true) ∧ (checkCertificateFast 10 894 fastCert10_894=true) ∧ (checkCertificateFast 10 895 fastCert10_895=true) ∧ (checkCertificateFast 10 896 fastCert10_896=true) ∧ (checkCertificateFast 10 897 fastCert10_897=true) ∧ (checkCertificateFast 10 898 fastCert10_898=true) ∧ (checkCertificateFast 10 899 fastCert10_899=true) ∧ (checkCertificateFast 10 900 fastCert10_900=true) ∧ (checkCertificateFast 10 901 fastCert10_901=true) ∧ (checkCertificateFast 10 902 fastCert10_902=true) ∧ (checkCertificateFast 10 903 fastCert10_903=true) ∧ (checkCertificateFast 10 904 fastCert10_904=true) ∧ (checkCertificateFast 10 905 fastCert10_905=true) ∧ (checkCertificateFast 10 906 fastCert10_906=true) ∧ (checkCertificateFast 10 907 fastCert10_907=true) ∧ (checkCertificateFast 10 908 fastCert10_908=true) ∧ (checkCertificateFast 10 909 fastCert10_909=true) ∧ (checkCertificateFast 10 910 fastCert10_910=true) ∧ (checkCertificateFast 10 911 fastCert10_911=true) ∧ (checkCertificateFast 10 912 fastCert10_912=true) ∧ (checkCertificateFast 10 913 fastCert10_913=true) ∧ (checkCertificateFast 10 914 fastCert10_914=true) ∧ (checkCertificateFast 10 915 fastCert10_915=true) ∧ (checkCertificateFast 10 916 fastCert10_916=true) ∧ (checkCertificateFast 10 917 fastCert10_917=true) ∧ (checkCertificateFast 10 918 fastCert10_918=true) ∧ (checkCertificateFast 10 919 fastCert10_919=true) ∧ (checkCertificateFast 10 920 fastCert10_920=true) ∧ (checkCertificateFast 10 921 fastCert10_921=true) ∧ (checkCertificateFast 10 922 fastCert10_922=true) ∧ (checkCertificateFast 10 923 fastCert10_923=true) ∧ (checkCertificateFast 10 924 fastCert10_924=true) ∧ (checkCertificateFast 10 925 fastCert10_925=true) ∧ (checkCertificateFast 10 926 fastCert10_926=true) ∧ (checkCertificateFast 10 927 fastCert10_927=true) ∧ (checkCertificateFast 10 928 fastCert10_928=true) ∧ (checkCertificateFast 10 929 fastCert10_929=true) ∧ (checkCertificateFast 10 930 fastCert10_930=true) ∧ (checkCertificateFast 10 931 fastCert10_931=true) ∧ (checkCertificateFast 10 932 fastCert10_932=true) ∧ (checkCertificateFast 10 933 fastCert10_933=true) ∧ (checkCertificateFast 10 934 fastCert10_934=true) ∧ (checkCertificateFast 10 935 fastCert10_935=true) ∧ (checkCertificateFast 10 936 fastCert10_936=true) ∧ (checkCertificateFast 10 937 fastCert10_937=true) ∧ (checkCertificateFast 10 938 fastCert10_938=true) ∧ (checkCertificateFast 10 939 fastCert10_939=true) ∧ (checkCertificateFast 10 940 fastCert10_940=true) ∧ (checkCertificateFast 10 941 fastCert10_941=true) ∧ (checkCertificateFast 10 942 fastCert10_942=true) ∧ (checkCertificateFast 10 943 fastCert10_943=true) ∧ (checkCertificateFast 10 944 fastCert10_944=true) ∧ (checkCertificateFast 10 945 fastCert10_945=true) ∧ (checkCertificateFast 10 946 fastCert10_946=true) ∧ (checkCertificateFast 10 947 fastCert10_947=true) ∧ (checkCertificateFast 10 948 fastCert10_948=true) ∧ (checkCertificateFast 10 949 fastCert10_949=true) ∧ (checkCertificateFast 10 950 fastCert10_950=true) ∧ (checkCertificateFast 10 951 fastCert10_951=true) ∧ (checkCertificateFast 10 952 fastCert10_952=true) ∧ (checkCertificateFast 10 953 fastCert10_953=true) ∧ (checkCertificateFast 10 954 fastCert10_954=true) ∧ (checkCertificateFast 10 955 fastCert10_955=true) ∧ (checkCertificateFast 10 956 fastCert10_956=true) ∧ (checkCertificateFast 10 957 fastCert10_957=true) ∧ (checkCertificateFast 10 958 fastCert10_958=true) ∧ (checkCertificateFast 10 959 fastCert10_959=true) ∧ (checkCertificateFast 10 960 fastCert10_960=true) ∧ (checkCertificateFast 10 961 fastCert10_961=true) ∧ (checkCertificateFast 10 962 fastCert10_962=true) ∧ (checkCertificateFast 10 963 fastCert10_963=true) ∧ (checkCertificateFast 10 964 fastCert10_964=true) ∧ (checkCertificateFast 10 965 fastCert10_965=true) ∧ (checkCertificateFast 10 966 fastCert10_966=true) ∧ (checkCertificateFast 10 967 fastCert10_967=true) ∧ (checkCertificateFast 10 968 fastCert10_968=true) ∧ (checkCertificateFast 10 969 fastCert10_969=true) ∧ (checkCertificateFast 10 970 fastCert10_970=true) ∧ (checkCertificateFast 10 971 fastCert10_971=true) ∧ (checkCertificateFast 10 972 fastCert10_972=true) ∧ (checkCertificateFast 10 973 fastCert10_973=true) ∧ (checkCertificateFast 10 974 fastCert10_974=true) ∧ (checkCertificateFast 10 975 fastCert10_975=true) ∧ (checkCertificateFast 10 976 fastCert10_976=true) ∧ (checkCertificateFast 10 977 fastCert10_977=true) ∧ (checkCertificateFast 10 978 fastCert10_978=true) ∧ (checkCertificateFast 10 979 fastCert10_979=true) ∧ (checkCertificateFast 10 980 fastCert10_980=true) ∧ (checkCertificateFast 10 981 fastCert10_981=true) ∧ (checkCertificateFast 10 982 fastCert10_982=true) ∧ (checkCertificateFast 10 983 fastCert10_983=true) ∧ (checkCertificateFast 10 984 fastCert10_984=true) ∧ (checkCertificateFast 10 985 fastCert10_985=true) ∧ (checkCertificateFast 10 986 fastCert10_986=true) ∧ (checkCertificateFast 10 987 fastCert10_987=true) ∧ (checkCertificateFast 10 988 fastCert10_988=true) ∧ (checkCertificateFast 10 989 fastCert10_989=true) ∧ (checkCertificateFast 10 990 fastCert10_990=true) ∧ (checkCertificateFast 10 991 fastCert10_991=true) ∧ (checkCertificateFast 10 992 fastCert10_992=true) ∧ (checkCertificateFast 10 993 fastCert10_993=true) ∧ (checkCertificateFast 10 994 fastCert10_994=true) ∧ (checkCertificateFast 10 995 fastCert10_995=true) ∧ (checkCertificateFast 10 996 fastCert10_996=true) ∧ (checkCertificateFast 10 997 fastCert10_997=true) ∧ (checkCertificateFast 10 998 fastCert10_998=true) ∧ (checkCertificateFast 10 999 fastCert10_999=true) :=
  ⟨fastCase10_0,fastCase10_1,fastCase10_2,fastCase10_3,fastCase10_4,fastCase10_5,fastCase10_6,fastCase10_7,fastCase10_8,fastCase10_9,fastCase10_10,fastCase10_11,fastCase10_12,fastCase10_13,fastCase10_14,fastCase10_15,fastCase10_16,fastCase10_17,fastCase10_18,fastCase10_19,fastCase10_20,fastCase10_21,fastCase10_22,fastCase10_23,fastCase10_24,fastCase10_25,fastCase10_26,fastCase10_27,fastCase10_28,fastCase10_29,fastCase10_30,fastCase10_31,fastCase10_32,fastCase10_33,fastCase10_34,fastCase10_35,fastCase10_36,fastCase10_37,fastCase10_38,fastCase10_39,fastCase10_40,fastCase10_41,fastCase10_42,fastCase10_43,fastCase10_44,fastCase10_45,fastCase10_46,fastCase10_47,fastCase10_48,fastCase10_49,fastCase10_50,fastCase10_51,fastCase10_52,fastCase10_53,fastCase10_54,fastCase10_55,fastCase10_56,fastCase10_57,fastCase10_58,fastCase10_59,fastCase10_60,fastCase10_61,fastCase10_62,fastCase10_63,fastCase10_64,fastCase10_65,fastCase10_66,fastCase10_67,fastCase10_68,fastCase10_69,fastCase10_70,fastCase10_71,fastCase10_72,fastCase10_73,fastCase10_74,fastCase10_75,fastCase10_76,fastCase10_77,fastCase10_78,fastCase10_79,fastCase10_80,fastCase10_81,fastCase10_82,fastCase10_83,fastCase10_84,fastCase10_85,fastCase10_86,fastCase10_87,fastCase10_88,fastCase10_89,fastCase10_90,fastCase10_91,fastCase10_92,fastCase10_93,fastCase10_94,fastCase10_95,fastCase10_96,fastCase10_97,fastCase10_98,fastCase10_99,fastCase10_100,fastCase10_101,fastCase10_102,fastCase10_103,fastCase10_104,fastCase10_105,fastCase10_106,fastCase10_107,fastCase10_108,fastCase10_109,fastCase10_110,fastCase10_111,fastCase10_112,fastCase10_113,fastCase10_114,fastCase10_115,fastCase10_116,fastCase10_117,fastCase10_118,fastCase10_119,fastCase10_120,fastCase10_121,fastCase10_122,fastCase10_123,fastCase10_124,fastCase10_125,fastCase10_126,fastCase10_127,fastCase10_128,fastCase10_129,fastCase10_130,fastCase10_131,fastCase10_132,fastCase10_133,fastCase10_134,fastCase10_135,fastCase10_136,fastCase10_137,fastCase10_138,fastCase10_139,fastCase10_140,fastCase10_141,fastCase10_142,fastCase10_143,fastCase10_144,fastCase10_145,fastCase10_146,fastCase10_147,fastCase10_148,fastCase10_149,fastCase10_150,fastCase10_151,fastCase10_152,fastCase10_153,fastCase10_154,fastCase10_155,fastCase10_156,fastCase10_157,fastCase10_158,fastCase10_159,fastCase10_160,fastCase10_161,fastCase10_162,fastCase10_163,fastCase10_164,fastCase10_165,fastCase10_166,fastCase10_167,fastCase10_168,fastCase10_169,fastCase10_170,fastCase10_171,fastCase10_172,fastCase10_173,fastCase10_174,fastCase10_175,fastCase10_176,fastCase10_177,fastCase10_178,fastCase10_179,fastCase10_180,fastCase10_181,fastCase10_182,fastCase10_183,fastCase10_184,fastCase10_185,fastCase10_186,fastCase10_187,fastCase10_188,fastCase10_189,fastCase10_190,fastCase10_191,fastCase10_192,fastCase10_193,fastCase10_194,fastCase10_195,fastCase10_196,fastCase10_197,fastCase10_198,fastCase10_199,fastCase10_200,fastCase10_201,fastCase10_202,fastCase10_203,fastCase10_204,fastCase10_205,fastCase10_206,fastCase10_207,fastCase10_208,fastCase10_209,fastCase10_210,fastCase10_211,fastCase10_212,fastCase10_213,fastCase10_214,fastCase10_215,fastCase10_216,fastCase10_217,fastCase10_218,fastCase10_219,fastCase10_220,fastCase10_221,fastCase10_222,fastCase10_223,fastCase10_224,fastCase10_225,fastCase10_226,fastCase10_227,fastCase10_228,fastCase10_229,fastCase10_230,fastCase10_231,fastCase10_232,fastCase10_233,fastCase10_234,fastCase10_235,fastCase10_236,fastCase10_237,fastCase10_238,fastCase10_239,fastCase10_240,fastCase10_241,fastCase10_242,fastCase10_243,fastCase10_244,fastCase10_245,fastCase10_246,fastCase10_247,fastCase10_248,fastCase10_249,fastCase10_250,fastCase10_251,fastCase10_252,fastCase10_253,fastCase10_254,fastCase10_255,fastCase10_256,fastCase10_257,fastCase10_258,fastCase10_259,fastCase10_260,fastCase10_261,fastCase10_262,fastCase10_263,fastCase10_264,fastCase10_265,fastCase10_266,fastCase10_267,fastCase10_268,fastCase10_269,fastCase10_270,fastCase10_271,fastCase10_272,fastCase10_273,fastCase10_274,fastCase10_275,fastCase10_276,fastCase10_277,fastCase10_278,fastCase10_279,fastCase10_280,fastCase10_281,fastCase10_282,fastCase10_283,fastCase10_284,fastCase10_285,fastCase10_286,fastCase10_287,fastCase10_288,fastCase10_289,fastCase10_290,fastCase10_291,fastCase10_292,fastCase10_293,fastCase10_294,fastCase10_295,fastCase10_296,fastCase10_297,fastCase10_298,fastCase10_299,fastCase10_300,fastCase10_301,fastCase10_302,fastCase10_303,fastCase10_304,fastCase10_305,fastCase10_306,fastCase10_307,fastCase10_308,fastCase10_309,fastCase10_310,fastCase10_311,fastCase10_312,fastCase10_313,fastCase10_314,fastCase10_315,fastCase10_316,fastCase10_317,fastCase10_318,fastCase10_319,fastCase10_320,fastCase10_321,fastCase10_322,fastCase10_323,fastCase10_324,fastCase10_325,fastCase10_326,fastCase10_327,fastCase10_328,fastCase10_329,fastCase10_330,fastCase10_331,fastCase10_332,fastCase10_333,fastCase10_334,fastCase10_335,fastCase10_336,fastCase10_337,fastCase10_338,fastCase10_339,fastCase10_340,fastCase10_341,fastCase10_342,fastCase10_343,fastCase10_344,fastCase10_345,fastCase10_346,fastCase10_347,fastCase10_348,fastCase10_349,fastCase10_350,fastCase10_351,fastCase10_352,fastCase10_353,fastCase10_354,fastCase10_355,fastCase10_356,fastCase10_357,fastCase10_358,fastCase10_359,fastCase10_360,fastCase10_361,fastCase10_362,fastCase10_363,fastCase10_364,fastCase10_365,fastCase10_366,fastCase10_367,fastCase10_368,fastCase10_369,fastCase10_370,fastCase10_371,fastCase10_372,fastCase10_373,fastCase10_374,fastCase10_375,fastCase10_376,fastCase10_377,fastCase10_378,fastCase10_379,fastCase10_380,fastCase10_381,fastCase10_382,fastCase10_383,fastCase10_384,fastCase10_385,fastCase10_386,fastCase10_387,fastCase10_388,fastCase10_389,fastCase10_390,fastCase10_391,fastCase10_392,fastCase10_393,fastCase10_394,fastCase10_395,fastCase10_396,fastCase10_397,fastCase10_398,fastCase10_399,fastCase10_400,fastCase10_401,fastCase10_402,fastCase10_403,fastCase10_404,fastCase10_405,fastCase10_406,fastCase10_407,fastCase10_408,fastCase10_409,fastCase10_410,fastCase10_411,fastCase10_412,fastCase10_413,fastCase10_414,fastCase10_415,fastCase10_416,fastCase10_417,fastCase10_418,fastCase10_419,fastCase10_420,fastCase10_421,fastCase10_422,fastCase10_423,fastCase10_424,fastCase10_425,fastCase10_426,fastCase10_427,fastCase10_428,fastCase10_429,fastCase10_430,fastCase10_431,fastCase10_432,fastCase10_433,fastCase10_434,fastCase10_435,fastCase10_436,fastCase10_437,fastCase10_438,fastCase10_439,fastCase10_440,fastCase10_441,fastCase10_442,fastCase10_443,fastCase10_444,fastCase10_445,fastCase10_446,fastCase10_447,fastCase10_448,fastCase10_449,fastCase10_450,fastCase10_451,fastCase10_452,fastCase10_453,fastCase10_454,fastCase10_455,fastCase10_456,fastCase10_457,fastCase10_458,fastCase10_459,fastCase10_460,fastCase10_461,fastCase10_462,fastCase10_463,fastCase10_464,fastCase10_465,fastCase10_466,fastCase10_467,fastCase10_468,fastCase10_469,fastCase10_470,fastCase10_471,fastCase10_472,fastCase10_473,fastCase10_474,fastCase10_475,fastCase10_476,fastCase10_477,fastCase10_478,fastCase10_479,fastCase10_480,fastCase10_481,fastCase10_482,fastCase10_483,fastCase10_484,fastCase10_485,fastCase10_486,fastCase10_487,fastCase10_488,fastCase10_489,fastCase10_490,fastCase10_491,fastCase10_492,fastCase10_493,fastCase10_494,fastCase10_495,fastCase10_496,fastCase10_497,fastCase10_498,fastCase10_499,fastCase10_500,fastCase10_501,fastCase10_502,fastCase10_503,fastCase10_504,fastCase10_505,fastCase10_506,fastCase10_507,fastCase10_508,fastCase10_509,fastCase10_510,fastCase10_511,fastCase10_512,fastCase10_513,fastCase10_514,fastCase10_515,fastCase10_516,fastCase10_517,fastCase10_518,fastCase10_519,fastCase10_520,fastCase10_521,fastCase10_522,fastCase10_523,fastCase10_524,fastCase10_525,fastCase10_526,fastCase10_527,fastCase10_528,fastCase10_529,fastCase10_530,fastCase10_531,fastCase10_532,fastCase10_533,fastCase10_534,fastCase10_535,fastCase10_536,fastCase10_537,fastCase10_538,fastCase10_539,fastCase10_540,fastCase10_541,fastCase10_542,fastCase10_543,fastCase10_544,fastCase10_545,fastCase10_546,fastCase10_547,fastCase10_548,fastCase10_549,fastCase10_550,fastCase10_551,fastCase10_552,fastCase10_553,fastCase10_554,fastCase10_555,fastCase10_556,fastCase10_557,fastCase10_558,fastCase10_559,fastCase10_560,fastCase10_561,fastCase10_562,fastCase10_563,fastCase10_564,fastCase10_565,fastCase10_566,fastCase10_567,fastCase10_568,fastCase10_569,fastCase10_570,fastCase10_571,fastCase10_572,fastCase10_573,fastCase10_574,fastCase10_575,fastCase10_576,fastCase10_577,fastCase10_578,fastCase10_579,fastCase10_580,fastCase10_581,fastCase10_582,fastCase10_583,fastCase10_584,fastCase10_585,fastCase10_586,fastCase10_587,fastCase10_588,fastCase10_589,fastCase10_590,fastCase10_591,fastCase10_592,fastCase10_593,fastCase10_594,fastCase10_595,fastCase10_596,fastCase10_597,fastCase10_598,fastCase10_599,fastCase10_600,fastCase10_601,fastCase10_602,fastCase10_603,fastCase10_604,fastCase10_605,fastCase10_606,fastCase10_607,fastCase10_608,fastCase10_609,fastCase10_610,fastCase10_611,fastCase10_612,fastCase10_613,fastCase10_614,fastCase10_615,fastCase10_616,fastCase10_617,fastCase10_618,fastCase10_619,fastCase10_620,fastCase10_621,fastCase10_622,fastCase10_623,fastCase10_624,fastCase10_625,fastCase10_626,fastCase10_627,fastCase10_628,fastCase10_629,fastCase10_630,fastCase10_631,fastCase10_632,fastCase10_633,fastCase10_634,fastCase10_635,fastCase10_636,fastCase10_637,fastCase10_638,fastCase10_639,fastCase10_640,fastCase10_641,fastCase10_642,fastCase10_643,fastCase10_644,fastCase10_645,fastCase10_646,fastCase10_647,fastCase10_648,fastCase10_649,fastCase10_650,fastCase10_651,fastCase10_652,fastCase10_653,fastCase10_654,fastCase10_655,fastCase10_656,fastCase10_657,fastCase10_658,fastCase10_659,fastCase10_660,fastCase10_661,fastCase10_662,fastCase10_663,fastCase10_664,fastCase10_665,fastCase10_666,fastCase10_667,fastCase10_668,fastCase10_669,fastCase10_670,fastCase10_671,fastCase10_672,fastCase10_673,fastCase10_674,fastCase10_675,fastCase10_676,fastCase10_677,fastCase10_678,fastCase10_679,fastCase10_680,fastCase10_681,fastCase10_682,fastCase10_683,fastCase10_684,fastCase10_685,fastCase10_686,fastCase10_687,fastCase10_688,fastCase10_689,fastCase10_690,fastCase10_691,fastCase10_692,fastCase10_693,fastCase10_694,fastCase10_695,fastCase10_696,fastCase10_697,fastCase10_698,fastCase10_699,fastCase10_700,fastCase10_701,fastCase10_702,fastCase10_703,fastCase10_704,fastCase10_705,fastCase10_706,fastCase10_707,fastCase10_708,fastCase10_709,fastCase10_710,fastCase10_711,fastCase10_712,fastCase10_713,fastCase10_714,fastCase10_715,fastCase10_716,fastCase10_717,fastCase10_718,fastCase10_719,fastCase10_720,fastCase10_721,fastCase10_722,fastCase10_723,fastCase10_724,fastCase10_725,fastCase10_726,fastCase10_727,fastCase10_728,fastCase10_729,fastCase10_730,fastCase10_731,fastCase10_732,fastCase10_733,fastCase10_734,fastCase10_735,fastCase10_736,fastCase10_737,fastCase10_738,fastCase10_739,fastCase10_740,fastCase10_741,fastCase10_742,fastCase10_743,fastCase10_744,fastCase10_745,fastCase10_746,fastCase10_747,fastCase10_748,fastCase10_749,fastCase10_750,fastCase10_751,fastCase10_752,fastCase10_753,fastCase10_754,fastCase10_755,fastCase10_756,fastCase10_757,fastCase10_758,fastCase10_759,fastCase10_760,fastCase10_761,fastCase10_762,fastCase10_763,fastCase10_764,fastCase10_765,fastCase10_766,fastCase10_767,fastCase10_768,fastCase10_769,fastCase10_770,fastCase10_771,fastCase10_772,fastCase10_773,fastCase10_774,fastCase10_775,fastCase10_776,fastCase10_777,fastCase10_778,fastCase10_779,fastCase10_780,fastCase10_781,fastCase10_782,fastCase10_783,fastCase10_784,fastCase10_785,fastCase10_786,fastCase10_787,fastCase10_788,fastCase10_789,fastCase10_790,fastCase10_791,fastCase10_792,fastCase10_793,fastCase10_794,fastCase10_795,fastCase10_796,fastCase10_797,fastCase10_798,fastCase10_799,fastCase10_800,fastCase10_801,fastCase10_802,fastCase10_803,fastCase10_804,fastCase10_805,fastCase10_806,fastCase10_807,fastCase10_808,fastCase10_809,fastCase10_810,fastCase10_811,fastCase10_812,fastCase10_813,fastCase10_814,fastCase10_815,fastCase10_816,fastCase10_817,fastCase10_818,fastCase10_819,fastCase10_820,fastCase10_821,fastCase10_822,fastCase10_823,fastCase10_824,fastCase10_825,fastCase10_826,fastCase10_827,fastCase10_828,fastCase10_829,fastCase10_830,fastCase10_831,fastCase10_832,fastCase10_833,fastCase10_834,fastCase10_835,fastCase10_836,fastCase10_837,fastCase10_838,fastCase10_839,fastCase10_840,fastCase10_841,fastCase10_842,fastCase10_843,fastCase10_844,fastCase10_845,fastCase10_846,fastCase10_847,fastCase10_848,fastCase10_849,fastCase10_850,fastCase10_851,fastCase10_852,fastCase10_853,fastCase10_854,fastCase10_855,fastCase10_856,fastCase10_857,fastCase10_858,fastCase10_859,fastCase10_860,fastCase10_861,fastCase10_862,fastCase10_863,fastCase10_864,fastCase10_865,fastCase10_866,fastCase10_867,fastCase10_868,fastCase10_869,fastCase10_870,fastCase10_871,fastCase10_872,fastCase10_873,fastCase10_874,fastCase10_875,fastCase10_876,fastCase10_877,fastCase10_878,fastCase10_879,fastCase10_880,fastCase10_881,fastCase10_882,fastCase10_883,fastCase10_884,fastCase10_885,fastCase10_886,fastCase10_887,fastCase10_888,fastCase10_889,fastCase10_890,fastCase10_891,fastCase10_892,fastCase10_893,fastCase10_894,fastCase10_895,fastCase10_896,fastCase10_897,fastCase10_898,fastCase10_899,fastCase10_900,fastCase10_901,fastCase10_902,fastCase10_903,fastCase10_904,fastCase10_905,fastCase10_906,fastCase10_907,fastCase10_908,fastCase10_909,fastCase10_910,fastCase10_911,fastCase10_912,fastCase10_913,fastCase10_914,fastCase10_915,fastCase10_916,fastCase10_917,fastCase10_918,fastCase10_919,fastCase10_920,fastCase10_921,fastCase10_922,fastCase10_923,fastCase10_924,fastCase10_925,fastCase10_926,fastCase10_927,fastCase10_928,fastCase10_929,fastCase10_930,fastCase10_931,fastCase10_932,fastCase10_933,fastCase10_934,fastCase10_935,fastCase10_936,fastCase10_937,fastCase10_938,fastCase10_939,fastCase10_940,fastCase10_941,fastCase10_942,fastCase10_943,fastCase10_944,fastCase10_945,fastCase10_946,fastCase10_947,fastCase10_948,fastCase10_949,fastCase10_950,fastCase10_951,fastCase10_952,fastCase10_953,fastCase10_954,fastCase10_955,fastCase10_956,fastCase10_957,fastCase10_958,fastCase10_959,fastCase10_960,fastCase10_961,fastCase10_962,fastCase10_963,fastCase10_964,fastCase10_965,fastCase10_966,fastCase10_967,fastCase10_968,fastCase10_969,fastCase10_970,fastCase10_971,fastCase10_972,fastCase10_973,fastCase10_974,fastCase10_975,fastCase10_976,fastCase10_977,fastCase10_978,fastCase10_979,fastCase10_980,fastCase10_981,fastCase10_982,fastCase10_983,fastCase10_984,fastCase10_985,fastCase10_986,fastCase10_987,fastCase10_988,fastCase10_989,fastCase10_990,fastCase10_991,fastCase10_992,fastCase10_993,fastCase10_994,fastCase10_995,fastCase10_996,fastCase10_997,fastCase10_998,fastCase10_999⟩
#print axioms aggregate_F10_000
end KernelCatalog
