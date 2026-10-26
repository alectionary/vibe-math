import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert7_0 : Certificate := ⟨0,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=7 then (-1) else if t=2 ∧ i=0 then (-1) else if t=2 ∧ i=1 then (1) else if t=2 ∧ i=9 then (1) else if t=2 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_0 : checkCertificateFast 7 0 fastCert7_0=true := by decide +kernel
def fastCert7_1 : Certificate := ⟨1,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=1 ∧ i=0 then (1) else if t=1 ∧ i=1 then (-1) else if t=1 ∧ i=6 then (-1) else if t=1 ∧ i=7 then (1) else 0⟩
theorem fastCase7_1 : checkCertificateFast 7 1 fastCert7_1=true := by decide +kernel
def fastCert7_2 : Certificate := ⟨2,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_2 : checkCertificateFast 7 2 fastCert7_2=true := by decide +kernel
def fastCert7_3 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_3 : checkCertificateFast 7 3 fastCert7_3=true := by decide +kernel
def fastCert7_4 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_4 : checkCertificateFast 7 4 fastCert7_4=true := by decide +kernel
def fastCert7_5 : Certificate := ⟨4,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_5 : checkCertificateFast 7 5 fastCert7_5=true := by decide +kernel
def fastCert7_6 : Certificate := ⟨5,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_6 : checkCertificateFast 7 6 fastCert7_6=true := by decide +kernel
def fastCert7_7 : Certificate := ⟨6,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else 0⟩
theorem fastCase7_7 : checkCertificateFast 7 7 fastCert7_7=true := by decide +kernel
def fastCert7_8 : Certificate := ⟨7,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_8 : checkCertificateFast 7 8 fastCert7_8=true := by decide +kernel
def fastCert7_9 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_9 : checkCertificateFast 7 9 fastCert7_9=true := by decide +kernel
def fastCert7_10 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_10 : checkCertificateFast 7 10 fastCert7_10=true := by decide +kernel
def fastCert7_11 : Certificate := ⟨8,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else 0⟩
theorem fastCase7_11 : checkCertificateFast 7 11 fastCert7_11=true := by decide +kernel
def fastCert7_12 : Certificate := ⟨9,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=9 then (1) else if t=1 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_12 : checkCertificateFast 7 12 fastCert7_12=true := by decide +kernel
def fastCert7_13 : Certificate := ⟨10,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_13 : checkCertificateFast 7 13 fastCert7_13=true := by decide +kernel
def fastCert7_14 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_14 : checkCertificateFast 7 14 fastCert7_14=true := by decide +kernel
def fastCert7_15 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_15 : checkCertificateFast 7 15 fastCert7_15=true := by decide +kernel
def fastCert7_16 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_16 : checkCertificateFast 7 16 fastCert7_16=true := by decide +kernel
def fastCert7_17 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_17 : checkCertificateFast 7 17 fastCert7_17=true := by decide +kernel
def fastCert7_18 : Certificate := ⟨11,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_18 : checkCertificateFast 7 18 fastCert7_18=true := by decide +kernel
def fastCert7_19 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_19 : checkCertificateFast 7 19 fastCert7_19=true := by decide +kernel
def fastCert7_20 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_20 : checkCertificateFast 7 20 fastCert7_20=true := by decide +kernel
def fastCert7_21 : Certificate := ⟨14,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_21 : checkCertificateFast 7 21 fastCert7_21=true := by decide +kernel
def fastCert7_22 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_22 : checkCertificateFast 7 22 fastCert7_22=true := by decide +kernel
def fastCert7_23 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_23 : checkCertificateFast 7 23 fastCert7_23=true := by decide +kernel
def fastCert7_24 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_24 : checkCertificateFast 7 24 fastCert7_24=true := by decide +kernel
def fastCert7_25 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_25 : checkCertificateFast 7 25 fastCert7_25=true := by decide +kernel
def fastCert7_26 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_26 : checkCertificateFast 7 26 fastCert7_26=true := by decide +kernel
def fastCert7_27 : Certificate := ⟨15,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_27 : checkCertificateFast 7 27 fastCert7_27=true := by decide +kernel
def fastCert7_28 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_28 : checkCertificateFast 7 28 fastCert7_28=true := by decide +kernel
def fastCert7_29 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_29 : checkCertificateFast 7 29 fastCert7_29=true := by decide +kernel
def fastCert7_30 : Certificate := ⟨16,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_30 : checkCertificateFast 7 30 fastCert7_30=true := by decide +kernel
def fastCert7_31 : Certificate := ⟨17,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_31 : checkCertificateFast 7 31 fastCert7_31=true := by decide +kernel
def fastCert7_32 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_32 : checkCertificateFast 7 32 fastCert7_32=true := by decide +kernel
def fastCert7_33 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_33 : checkCertificateFast 7 33 fastCert7_33=true := by decide +kernel
def fastCert7_34 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else 0⟩
theorem fastCase7_34 : checkCertificateFast 7 34 fastCert7_34=true := by decide +kernel
def fastCert7_35 : Certificate := ⟨20,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else 0⟩
theorem fastCase7_35 : checkCertificateFast 7 35 fastCert7_35=true := by decide +kernel
def fastCert7_36 : Certificate := ⟨21,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=1 ∧ i=6 then (-1) else if t=1 ∧ i=8 then (1) else if t=1 ∧ i=9 then (1) else if t=1 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_36 : checkCertificateFast 7 36 fastCert7_36=true := by decide +kernel
def fastCert7_37 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_37 : checkCertificateFast 7 37 fastCert7_37=true := by decide +kernel
def fastCert7_38 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_38 : checkCertificateFast 7 38 fastCert7_38=true := by decide +kernel
def fastCert7_39 : Certificate := ⟨7,fun t i => if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_39 : checkCertificateFast 7 39 fastCert7_39=true := by decide +kernel
def fastCert7_40 : Certificate := ⟨7,fun t i => if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_40 : checkCertificateFast 7 40 fastCert7_40=true := by decide +kernel
def fastCert7_41 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else 0⟩
theorem fastCase7_41 : checkCertificateFast 7 41 fastCert7_41=true := by decide +kernel
def fastCert7_42 : Certificate := ⟨24,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_42 : checkCertificateFast 7 42 fastCert7_42=true := by decide +kernel
def fastCert7_43 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_43 : checkCertificateFast 7 43 fastCert7_43=true := by decide +kernel
def fastCert7_44 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_44 : checkCertificateFast 7 44 fastCert7_44=true := by decide +kernel
def fastCert7_45 : Certificate := ⟨1,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=1 ∧ i=1 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=4 then (-1) else if t=1 ∧ i=7 then (1) else if t=1 ∧ i=8 then (-1) else if t=1 ∧ i=9 then (-1) else if t=1 ∧ i=10 then (1) else 0⟩
theorem fastCase7_45 : checkCertificateFast 7 45 fastCert7_45=true := by decide +kernel
def fastCert7_46 : Certificate := ⟨1,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=2 then (-1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=5 then (-1) else if t=1 ∧ i=7 then (-1) else if t=1 ∧ i=8 then (1) else if t=1 ∧ i=9 then (-1) else if t=1 ∧ i=11 then (1) else 0⟩
theorem fastCase7_46 : checkCertificateFast 7 46 fastCert7_46=true := by decide +kernel
def fastCert7_47 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else 0⟩
theorem fastCase7_47 : checkCertificateFast 7 47 fastCert7_47=true := by decide +kernel
def fastCert7_48 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_48 : checkCertificateFast 7 48 fastCert7_48=true := by decide +kernel
def fastCert7_49 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else 0⟩
theorem fastCase7_49 : checkCertificateFast 7 49 fastCert7_49=true := by decide +kernel
def fastCert7_50 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_50 : checkCertificateFast 7 50 fastCert7_50=true := by decide +kernel
def fastCert7_51 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_51 : checkCertificateFast 7 51 fastCert7_51=true := by decide +kernel
def fastCert7_52 : Certificate := ⟨14,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_52 : checkCertificateFast 7 52 fastCert7_52=true := by decide +kernel
def fastCert7_53 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=11 then (-2) else 0⟩
theorem fastCase7_53 : checkCertificateFast 7 53 fastCert7_53=true := by decide +kernel
def fastCert7_54 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_54 : checkCertificateFast 7 54 fastCert7_54=true := by decide +kernel
def fastCert7_55 : Certificate := ⟨25,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_55 : checkCertificateFast 7 55 fastCert7_55=true := by decide +kernel
def fastCert7_56 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_56 : checkCertificateFast 7 56 fastCert7_56=true := by decide +kernel
def fastCert7_57 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_57 : checkCertificateFast 7 57 fastCert7_57=true := by decide +kernel
def fastCert7_58 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_58 : checkCertificateFast 7 58 fastCert7_58=true := by decide +kernel
def fastCert7_59 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_59 : checkCertificateFast 7 59 fastCert7_59=true := by decide +kernel
def fastCert7_60 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else 0⟩
theorem fastCase7_60 : checkCertificateFast 7 60 fastCert7_60=true := by decide +kernel
def fastCert7_61 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_61 : checkCertificateFast 7 61 fastCert7_61=true := by decide +kernel
def fastCert7_62 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_62 : checkCertificateFast 7 62 fastCert7_62=true := by decide +kernel
def fastCert7_63 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_63 : checkCertificateFast 7 63 fastCert7_63=true := by decide +kernel
def fastCert7_64 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_64 : checkCertificateFast 7 64 fastCert7_64=true := by decide +kernel
def fastCert7_65 : Certificate := ⟨28,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_65 : checkCertificateFast 7 65 fastCert7_65=true := by decide +kernel
def fastCert7_66 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_66 : checkCertificateFast 7 66 fastCert7_66=true := by decide +kernel
def fastCert7_67 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_67 : checkCertificateFast 7 67 fastCert7_67=true := by decide +kernel
def fastCert7_68 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_68 : checkCertificateFast 7 68 fastCert7_68=true := by decide +kernel
def fastCert7_69 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_69 : checkCertificateFast 7 69 fastCert7_69=true := by decide +kernel
def fastCert7_70 : Certificate := ⟨15,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else 0⟩
theorem fastCase7_70 : checkCertificateFast 7 70 fastCert7_70=true := by decide +kernel
def fastCert7_71 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_71 : checkCertificateFast 7 71 fastCert7_71=true := by decide +kernel
def fastCert7_72 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_72 : checkCertificateFast 7 72 fastCert7_72=true := by decide +kernel
def fastCert7_73 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_73 : checkCertificateFast 7 73 fastCert7_73=true := by decide +kernel
def fastCert7_74 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_74 : checkCertificateFast 7 74 fastCert7_74=true := by decide +kernel
def fastCert7_75 : Certificate := ⟨14,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_75 : checkCertificateFast 7 75 fastCert7_75=true := by decide +kernel
def fastCert7_76 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_76 : checkCertificateFast 7 76 fastCert7_76=true := by decide +kernel
def fastCert7_77 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_77 : checkCertificateFast 7 77 fastCert7_77=true := by decide +kernel
def fastCert7_78 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_78 : checkCertificateFast 7 78 fastCert7_78=true := by decide +kernel
def fastCert7_79 : Certificate := ⟨27,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_79 : checkCertificateFast 7 79 fastCert7_79=true := by decide +kernel
def fastCert7_80 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_80 : checkCertificateFast 7 80 fastCert7_80=true := by decide +kernel
def fastCert7_81 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_81 : checkCertificateFast 7 81 fastCert7_81=true := by decide +kernel
def fastCert7_82 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_82 : checkCertificateFast 7 82 fastCert7_82=true := by decide +kernel
def fastCert7_83 : Certificate := ⟨28,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_83 : checkCertificateFast 7 83 fastCert7_83=true := by decide +kernel
def fastCert7_84 : Certificate := ⟨29,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=5 then (1) else if t=1 ∧ i=9 then (1) else if t=1 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_84 : checkCertificateFast 7 84 fastCert7_84=true := by decide +kernel
def fastCert7_85 : Certificate := ⟨25,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_85 : checkCertificateFast 7 85 fastCert7_85=true := by decide +kernel
def fastCert7_86 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else 0⟩
theorem fastCase7_86 : checkCertificateFast 7 86 fastCert7_86=true := by decide +kernel
def fastCert7_87 : Certificate := ⟨18,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_87 : checkCertificateFast 7 87 fastCert7_87=true := by decide +kernel
def fastCert7_88 : Certificate := ⟨18,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_88 : checkCertificateFast 7 88 fastCert7_88=true := by decide +kernel
def fastCert7_89 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_89 : checkCertificateFast 7 89 fastCert7_89=true := by decide +kernel
def fastCert7_90 : Certificate := ⟨19,fun t i => if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_90 : checkCertificateFast 7 90 fastCert7_90=true := by decide +kernel
def fastCert7_91 : Certificate := ⟨19,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_91 : checkCertificateFast 7 91 fastCert7_91=true := by decide +kernel
def fastCert7_92 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else 0⟩
theorem fastCase7_92 : checkCertificateFast 7 92 fastCert7_92=true := by decide +kernel
def fastCert7_93 : Certificate := ⟨15,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_93 : checkCertificateFast 7 93 fastCert7_93=true := by decide +kernel
def fastCert7_94 : Certificate := ⟨14,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_94 : checkCertificateFast 7 94 fastCert7_94=true := by decide +kernel
def fastCert7_95 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_95 : checkCertificateFast 7 95 fastCert7_95=true := by decide +kernel
def fastCert7_96 : Certificate := ⟨30,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_96 : checkCertificateFast 7 96 fastCert7_96=true := by decide +kernel
def fastCert7_97 : Certificate := ⟨25,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_97 : checkCertificateFast 7 97 fastCert7_97=true := by decide +kernel
def fastCert7_98 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_98 : checkCertificateFast 7 98 fastCert7_98=true := by decide +kernel
def fastCert7_99 : Certificate := ⟨1,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_99 : checkCertificateFast 7 99 fastCert7_99=true := by decide +kernel
def fastCert7_100 : Certificate := ⟨1,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_100 : checkCertificateFast 7 100 fastCert7_100=true := by decide +kernel
def fastCert7_101 : Certificate := ⟨26,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_101 : checkCertificateFast 7 101 fastCert7_101=true := by decide +kernel
def fastCert7_102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_102 : checkCertificateFast 7 102 fastCert7_102=true := by decide +kernel
def fastCert7_103 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_103 : checkCertificateFast 7 103 fastCert7_103=true := by decide +kernel
def fastCert7_104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_104 : checkCertificateFast 7 104 fastCert7_104=true := by decide +kernel
def fastCert7_105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_105 : checkCertificateFast 7 105 fastCert7_105=true := by decide +kernel
def fastCert7_106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_106 : checkCertificateFast 7 106 fastCert7_106=true := by decide +kernel
def fastCert7_107 : Certificate := ⟨23,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_107 : checkCertificateFast 7 107 fastCert7_107=true := by decide +kernel
def fastCert7_108 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_108 : checkCertificateFast 7 108 fastCert7_108=true := by decide +kernel
def fastCert7_109 : Certificate := ⟨25,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_109 : checkCertificateFast 7 109 fastCert7_109=true := by decide +kernel
def fastCert7_110 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_110 : checkCertificateFast 7 110 fastCert7_110=true := by decide +kernel
def fastCert7_111 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_111 : checkCertificateFast 7 111 fastCert7_111=true := by decide +kernel
def fastCert7_112 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_112 : checkCertificateFast 7 112 fastCert7_112=true := by decide +kernel
def fastCert7_113 : Certificate := ⟨26,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_113 : checkCertificateFast 7 113 fastCert7_113=true := by decide +kernel
def fastCert7_114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_114 : checkCertificateFast 7 114 fastCert7_114=true := by decide +kernel
def fastCert7_115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_115 : checkCertificateFast 7 115 fastCert7_115=true := by decide +kernel
def fastCert7_116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_116 : checkCertificateFast 7 116 fastCert7_116=true := by decide +kernel
def fastCert7_117 : Certificate := ⟨15,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_117 : checkCertificateFast 7 117 fastCert7_117=true := by decide +kernel
def fastCert7_118 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_118 : checkCertificateFast 7 118 fastCert7_118=true := by decide +kernel
def fastCert7_119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_119 : checkCertificateFast 7 119 fastCert7_119=true := by decide +kernel
def fastCert7_120 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_120 : checkCertificateFast 7 120 fastCert7_120=true := by decide +kernel
def fastCert7_121 : Certificate := ⟨19,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_121 : checkCertificateFast 7 121 fastCert7_121=true := by decide +kernel
def fastCert7_122 : Certificate := ⟨19,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_122 : checkCertificateFast 7 122 fastCert7_122=true := by decide +kernel
def fastCert7_123 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_123 : checkCertificateFast 7 123 fastCert7_123=true := by decide +kernel
def fastCert7_124 : Certificate := ⟨15,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_124 : checkCertificateFast 7 124 fastCert7_124=true := by decide +kernel
def fastCert7_125 : Certificate := ⟨19,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_125 : checkCertificateFast 7 125 fastCert7_125=true := by decide +kernel
def fastCert7_126 : Certificate := ⟨31,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=5 then (1) else if t=1 ∧ i=6 then (1) else if t=1 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_126 : checkCertificateFast 7 126 fastCert7_126=true := by decide +kernel
def fastCert7_127 : Certificate := ⟨27,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_127 : checkCertificateFast 7 127 fastCert7_127=true := by decide +kernel
def fastCert7_128 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_128 : checkCertificateFast 7 128 fastCert7_128=true := by decide +kernel
def fastCert7_129 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_129 : checkCertificateFast 7 129 fastCert7_129=true := by decide +kernel
def fastCert7_130 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else 0⟩
theorem fastCase7_130 : checkCertificateFast 7 130 fastCert7_130=true := by decide +kernel
def fastCert7_131 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_131 : checkCertificateFast 7 131 fastCert7_131=true := by decide +kernel
def fastCert7_132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_132 : checkCertificateFast 7 132 fastCert7_132=true := by decide +kernel
def fastCert7_133 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_133 : checkCertificateFast 7 133 fastCert7_133=true := by decide +kernel
def fastCert7_134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_134 : checkCertificateFast 7 134 fastCert7_134=true := by decide +kernel
def fastCert7_135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else 0⟩
theorem fastCase7_135 : checkCertificateFast 7 135 fastCert7_135=true := by decide +kernel
def fastCert7_136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_136 : checkCertificateFast 7 136 fastCert7_136=true := by decide +kernel
def fastCert7_137 : Certificate := ⟨23,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else 0⟩
theorem fastCase7_137 : checkCertificateFast 7 137 fastCert7_137=true := by decide +kernel
def fastCert7_138 : Certificate := ⟨32,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=1 ∧ i=0 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=3 then (1) else if t=1 ∧ i=5 then (-1) else 0⟩
theorem fastCase7_138 : checkCertificateFast 7 138 fastCert7_138=true := by decide +kernel
def fastCert7_139 : Certificate := ⟨27,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase7_139 : checkCertificateFast 7 139 fastCert7_139=true := by decide +kernel
def fastCert7_140 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else 0⟩
theorem fastCase7_140 : checkCertificateFast 7 140 fastCert7_140=true := by decide +kernel
def fastCert7_141 : Certificate := ⟨1,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=1 ∧ i=1 then (-1) else if t=1 ∧ i=2 then (1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=4 then (1) else if t=1 ∧ i=7 then (1) else if t=1 ∧ i=8 then (-1) else if t=1 ∧ i=9 then (1) else if t=1 ∧ i=10 then (-1) else 0⟩
theorem fastCase7_141 : checkCertificateFast 7 141 fastCert7_141=true := by decide +kernel
def fastCert7_142 : Certificate := ⟨1,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=1 ∧ i=1 then (1) else if t=1 ∧ i=2 then (-1) else if t=1 ∧ i=3 then (-1) else if t=1 ∧ i=5 then (1) else if t=1 ∧ i=7 then (-1) else if t=1 ∧ i=8 then (1) else if t=1 ∧ i=9 then (1) else if t=1 ∧ i=11 then (-1) else 0⟩
theorem fastCase7_142 : checkCertificateFast 7 142 fastCert7_142=true := by decide +kernel
def fastCert7_143 : Certificate := ⟨28,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase7_143 : checkCertificateFast 7 143 fastCert7_143=true := by decide +kernel
theorem aggregate_F7_000 : (checkCertificateFast 7 0 fastCert7_0=true) ∧ (checkCertificateFast 7 1 fastCert7_1=true) ∧ (checkCertificateFast 7 2 fastCert7_2=true) ∧ (checkCertificateFast 7 3 fastCert7_3=true) ∧ (checkCertificateFast 7 4 fastCert7_4=true) ∧ (checkCertificateFast 7 5 fastCert7_5=true) ∧ (checkCertificateFast 7 6 fastCert7_6=true) ∧ (checkCertificateFast 7 7 fastCert7_7=true) ∧ (checkCertificateFast 7 8 fastCert7_8=true) ∧ (checkCertificateFast 7 9 fastCert7_9=true) ∧ (checkCertificateFast 7 10 fastCert7_10=true) ∧ (checkCertificateFast 7 11 fastCert7_11=true) ∧ (checkCertificateFast 7 12 fastCert7_12=true) ∧ (checkCertificateFast 7 13 fastCert7_13=true) ∧ (checkCertificateFast 7 14 fastCert7_14=true) ∧ (checkCertificateFast 7 15 fastCert7_15=true) ∧ (checkCertificateFast 7 16 fastCert7_16=true) ∧ (checkCertificateFast 7 17 fastCert7_17=true) ∧ (checkCertificateFast 7 18 fastCert7_18=true) ∧ (checkCertificateFast 7 19 fastCert7_19=true) ∧ (checkCertificateFast 7 20 fastCert7_20=true) ∧ (checkCertificateFast 7 21 fastCert7_21=true) ∧ (checkCertificateFast 7 22 fastCert7_22=true) ∧ (checkCertificateFast 7 23 fastCert7_23=true) ∧ (checkCertificateFast 7 24 fastCert7_24=true) ∧ (checkCertificateFast 7 25 fastCert7_25=true) ∧ (checkCertificateFast 7 26 fastCert7_26=true) ∧ (checkCertificateFast 7 27 fastCert7_27=true) ∧ (checkCertificateFast 7 28 fastCert7_28=true) ∧ (checkCertificateFast 7 29 fastCert7_29=true) ∧ (checkCertificateFast 7 30 fastCert7_30=true) ∧ (checkCertificateFast 7 31 fastCert7_31=true) ∧ (checkCertificateFast 7 32 fastCert7_32=true) ∧ (checkCertificateFast 7 33 fastCert7_33=true) ∧ (checkCertificateFast 7 34 fastCert7_34=true) ∧ (checkCertificateFast 7 35 fastCert7_35=true) ∧ (checkCertificateFast 7 36 fastCert7_36=true) ∧ (checkCertificateFast 7 37 fastCert7_37=true) ∧ (checkCertificateFast 7 38 fastCert7_38=true) ∧ (checkCertificateFast 7 39 fastCert7_39=true) ∧ (checkCertificateFast 7 40 fastCert7_40=true) ∧ (checkCertificateFast 7 41 fastCert7_41=true) ∧ (checkCertificateFast 7 42 fastCert7_42=true) ∧ (checkCertificateFast 7 43 fastCert7_43=true) ∧ (checkCertificateFast 7 44 fastCert7_44=true) ∧ (checkCertificateFast 7 45 fastCert7_45=true) ∧ (checkCertificateFast 7 46 fastCert7_46=true) ∧ (checkCertificateFast 7 47 fastCert7_47=true) ∧ (checkCertificateFast 7 48 fastCert7_48=true) ∧ (checkCertificateFast 7 49 fastCert7_49=true) ∧ (checkCertificateFast 7 50 fastCert7_50=true) ∧ (checkCertificateFast 7 51 fastCert7_51=true) ∧ (checkCertificateFast 7 52 fastCert7_52=true) ∧ (checkCertificateFast 7 53 fastCert7_53=true) ∧ (checkCertificateFast 7 54 fastCert7_54=true) ∧ (checkCertificateFast 7 55 fastCert7_55=true) ∧ (checkCertificateFast 7 56 fastCert7_56=true) ∧ (checkCertificateFast 7 57 fastCert7_57=true) ∧ (checkCertificateFast 7 58 fastCert7_58=true) ∧ (checkCertificateFast 7 59 fastCert7_59=true) ∧ (checkCertificateFast 7 60 fastCert7_60=true) ∧ (checkCertificateFast 7 61 fastCert7_61=true) ∧ (checkCertificateFast 7 62 fastCert7_62=true) ∧ (checkCertificateFast 7 63 fastCert7_63=true) ∧ (checkCertificateFast 7 64 fastCert7_64=true) ∧ (checkCertificateFast 7 65 fastCert7_65=true) ∧ (checkCertificateFast 7 66 fastCert7_66=true) ∧ (checkCertificateFast 7 67 fastCert7_67=true) ∧ (checkCertificateFast 7 68 fastCert7_68=true) ∧ (checkCertificateFast 7 69 fastCert7_69=true) ∧ (checkCertificateFast 7 70 fastCert7_70=true) ∧ (checkCertificateFast 7 71 fastCert7_71=true) ∧ (checkCertificateFast 7 72 fastCert7_72=true) ∧ (checkCertificateFast 7 73 fastCert7_73=true) ∧ (checkCertificateFast 7 74 fastCert7_74=true) ∧ (checkCertificateFast 7 75 fastCert7_75=true) ∧ (checkCertificateFast 7 76 fastCert7_76=true) ∧ (checkCertificateFast 7 77 fastCert7_77=true) ∧ (checkCertificateFast 7 78 fastCert7_78=true) ∧ (checkCertificateFast 7 79 fastCert7_79=true) ∧ (checkCertificateFast 7 80 fastCert7_80=true) ∧ (checkCertificateFast 7 81 fastCert7_81=true) ∧ (checkCertificateFast 7 82 fastCert7_82=true) ∧ (checkCertificateFast 7 83 fastCert7_83=true) ∧ (checkCertificateFast 7 84 fastCert7_84=true) ∧ (checkCertificateFast 7 85 fastCert7_85=true) ∧ (checkCertificateFast 7 86 fastCert7_86=true) ∧ (checkCertificateFast 7 87 fastCert7_87=true) ∧ (checkCertificateFast 7 88 fastCert7_88=true) ∧ (checkCertificateFast 7 89 fastCert7_89=true) ∧ (checkCertificateFast 7 90 fastCert7_90=true) ∧ (checkCertificateFast 7 91 fastCert7_91=true) ∧ (checkCertificateFast 7 92 fastCert7_92=true) ∧ (checkCertificateFast 7 93 fastCert7_93=true) ∧ (checkCertificateFast 7 94 fastCert7_94=true) ∧ (checkCertificateFast 7 95 fastCert7_95=true) ∧ (checkCertificateFast 7 96 fastCert7_96=true) ∧ (checkCertificateFast 7 97 fastCert7_97=true) ∧ (checkCertificateFast 7 98 fastCert7_98=true) ∧ (checkCertificateFast 7 99 fastCert7_99=true) ∧ (checkCertificateFast 7 100 fastCert7_100=true) ∧ (checkCertificateFast 7 101 fastCert7_101=true) ∧ (checkCertificateFast 7 102 fastCert7_102=true) ∧ (checkCertificateFast 7 103 fastCert7_103=true) ∧ (checkCertificateFast 7 104 fastCert7_104=true) ∧ (checkCertificateFast 7 105 fastCert7_105=true) ∧ (checkCertificateFast 7 106 fastCert7_106=true) ∧ (checkCertificateFast 7 107 fastCert7_107=true) ∧ (checkCertificateFast 7 108 fastCert7_108=true) ∧ (checkCertificateFast 7 109 fastCert7_109=true) ∧ (checkCertificateFast 7 110 fastCert7_110=true) ∧ (checkCertificateFast 7 111 fastCert7_111=true) ∧ (checkCertificateFast 7 112 fastCert7_112=true) ∧ (checkCertificateFast 7 113 fastCert7_113=true) ∧ (checkCertificateFast 7 114 fastCert7_114=true) ∧ (checkCertificateFast 7 115 fastCert7_115=true) ∧ (checkCertificateFast 7 116 fastCert7_116=true) ∧ (checkCertificateFast 7 117 fastCert7_117=true) ∧ (checkCertificateFast 7 118 fastCert7_118=true) ∧ (checkCertificateFast 7 119 fastCert7_119=true) ∧ (checkCertificateFast 7 120 fastCert7_120=true) ∧ (checkCertificateFast 7 121 fastCert7_121=true) ∧ (checkCertificateFast 7 122 fastCert7_122=true) ∧ (checkCertificateFast 7 123 fastCert7_123=true) ∧ (checkCertificateFast 7 124 fastCert7_124=true) ∧ (checkCertificateFast 7 125 fastCert7_125=true) ∧ (checkCertificateFast 7 126 fastCert7_126=true) ∧ (checkCertificateFast 7 127 fastCert7_127=true) ∧ (checkCertificateFast 7 128 fastCert7_128=true) ∧ (checkCertificateFast 7 129 fastCert7_129=true) ∧ (checkCertificateFast 7 130 fastCert7_130=true) ∧ (checkCertificateFast 7 131 fastCert7_131=true) ∧ (checkCertificateFast 7 132 fastCert7_132=true) ∧ (checkCertificateFast 7 133 fastCert7_133=true) ∧ (checkCertificateFast 7 134 fastCert7_134=true) ∧ (checkCertificateFast 7 135 fastCert7_135=true) ∧ (checkCertificateFast 7 136 fastCert7_136=true) ∧ (checkCertificateFast 7 137 fastCert7_137=true) ∧ (checkCertificateFast 7 138 fastCert7_138=true) ∧ (checkCertificateFast 7 139 fastCert7_139=true) ∧ (checkCertificateFast 7 140 fastCert7_140=true) ∧ (checkCertificateFast 7 141 fastCert7_141=true) ∧ (checkCertificateFast 7 142 fastCert7_142=true) ∧ (checkCertificateFast 7 143 fastCert7_143=true) :=
  ⟨fastCase7_0,fastCase7_1,fastCase7_2,fastCase7_3,fastCase7_4,fastCase7_5,fastCase7_6,fastCase7_7,fastCase7_8,fastCase7_9,fastCase7_10,fastCase7_11,fastCase7_12,fastCase7_13,fastCase7_14,fastCase7_15,fastCase7_16,fastCase7_17,fastCase7_18,fastCase7_19,fastCase7_20,fastCase7_21,fastCase7_22,fastCase7_23,fastCase7_24,fastCase7_25,fastCase7_26,fastCase7_27,fastCase7_28,fastCase7_29,fastCase7_30,fastCase7_31,fastCase7_32,fastCase7_33,fastCase7_34,fastCase7_35,fastCase7_36,fastCase7_37,fastCase7_38,fastCase7_39,fastCase7_40,fastCase7_41,fastCase7_42,fastCase7_43,fastCase7_44,fastCase7_45,fastCase7_46,fastCase7_47,fastCase7_48,fastCase7_49,fastCase7_50,fastCase7_51,fastCase7_52,fastCase7_53,fastCase7_54,fastCase7_55,fastCase7_56,fastCase7_57,fastCase7_58,fastCase7_59,fastCase7_60,fastCase7_61,fastCase7_62,fastCase7_63,fastCase7_64,fastCase7_65,fastCase7_66,fastCase7_67,fastCase7_68,fastCase7_69,fastCase7_70,fastCase7_71,fastCase7_72,fastCase7_73,fastCase7_74,fastCase7_75,fastCase7_76,fastCase7_77,fastCase7_78,fastCase7_79,fastCase7_80,fastCase7_81,fastCase7_82,fastCase7_83,fastCase7_84,fastCase7_85,fastCase7_86,fastCase7_87,fastCase7_88,fastCase7_89,fastCase7_90,fastCase7_91,fastCase7_92,fastCase7_93,fastCase7_94,fastCase7_95,fastCase7_96,fastCase7_97,fastCase7_98,fastCase7_99,fastCase7_100,fastCase7_101,fastCase7_102,fastCase7_103,fastCase7_104,fastCase7_105,fastCase7_106,fastCase7_107,fastCase7_108,fastCase7_109,fastCase7_110,fastCase7_111,fastCase7_112,fastCase7_113,fastCase7_114,fastCase7_115,fastCase7_116,fastCase7_117,fastCase7_118,fastCase7_119,fastCase7_120,fastCase7_121,fastCase7_122,fastCase7_123,fastCase7_124,fastCase7_125,fastCase7_126,fastCase7_127,fastCase7_128,fastCase7_129,fastCase7_130,fastCase7_131,fastCase7_132,fastCase7_133,fastCase7_134,fastCase7_135,fastCase7_136,fastCase7_137,fastCase7_138,fastCase7_139,fastCase7_140,fastCase7_141,fastCase7_142,fastCase7_143⟩
#print axioms aggregate_F7_000
end KernelCatalog
