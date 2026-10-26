import FastCatalogChecker
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace KernelCatalog
def fastCert10_2000 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2000 : checkCertificateFast 10 2000 fastCert10_2000=true := by decide +kernel
def fastCert10_2001 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2001 : checkCertificateFast 10 2001 fastCert10_2001=true := by decide +kernel
def fastCert10_2002 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2002 : checkCertificateFast 10 2002 fastCert10_2002=true := by decide +kernel
def fastCert10_2003 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2003 : checkCertificateFast 10 2003 fastCert10_2003=true := by decide +kernel
def fastCert10_2004 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2004 : checkCertificateFast 10 2004 fastCert10_2004=true := by decide +kernel
def fastCert10_2005 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2005 : checkCertificateFast 10 2005 fastCert10_2005=true := by decide +kernel
def fastCert10_2006 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2006 : checkCertificateFast 10 2006 fastCert10_2006=true := by decide +kernel
def fastCert10_2007 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2007 : checkCertificateFast 10 2007 fastCert10_2007=true := by decide +kernel
def fastCert10_2008 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2008 : checkCertificateFast 10 2008 fastCert10_2008=true := by decide +kernel
def fastCert10_2009 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2009 : checkCertificateFast 10 2009 fastCert10_2009=true := by decide +kernel
def fastCert10_2010 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2010 : checkCertificateFast 10 2010 fastCert10_2010=true := by decide +kernel
def fastCert10_2011 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2011 : checkCertificateFast 10 2011 fastCert10_2011=true := by decide +kernel
def fastCert10_2012 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2012 : checkCertificateFast 10 2012 fastCert10_2012=true := by decide +kernel
def fastCert10_2013 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2013 : checkCertificateFast 10 2013 fastCert10_2013=true := by decide +kernel
def fastCert10_2014 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2014 : checkCertificateFast 10 2014 fastCert10_2014=true := by decide +kernel
def fastCert10_2015 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2015 : checkCertificateFast 10 2015 fastCert10_2015=true := by decide +kernel
def fastCert10_2016 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2016 : checkCertificateFast 10 2016 fastCert10_2016=true := by decide +kernel
def fastCert10_2017 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2017 : checkCertificateFast 10 2017 fastCert10_2017=true := by decide +kernel
def fastCert10_2018 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2018 : checkCertificateFast 10 2018 fastCert10_2018=true := by decide +kernel
def fastCert10_2019 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2019 : checkCertificateFast 10 2019 fastCert10_2019=true := by decide +kernel
def fastCert10_2020 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_2020 : checkCertificateFast 10 2020 fastCert10_2020=true := by decide +kernel
def fastCert10_2021 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2021 : checkCertificateFast 10 2021 fastCert10_2021=true := by decide +kernel
def fastCert10_2022 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2022 : checkCertificateFast 10 2022 fastCert10_2022=true := by decide +kernel
def fastCert10_2023 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2023 : checkCertificateFast 10 2023 fastCert10_2023=true := by decide +kernel
def fastCert10_2024 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2024 : checkCertificateFast 10 2024 fastCert10_2024=true := by decide +kernel
def fastCert10_2025 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2025 : checkCertificateFast 10 2025 fastCert10_2025=true := by decide +kernel
def fastCert10_2026 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2026 : checkCertificateFast 10 2026 fastCert10_2026=true := by decide +kernel
def fastCert10_2027 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2027 : checkCertificateFast 10 2027 fastCert10_2027=true := by decide +kernel
def fastCert10_2028 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2028 : checkCertificateFast 10 2028 fastCert10_2028=true := by decide +kernel
def fastCert10_2029 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_2029 : checkCertificateFast 10 2029 fastCert10_2029=true := by decide +kernel
def fastCert10_2030 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2030 : checkCertificateFast 10 2030 fastCert10_2030=true := by decide +kernel
def fastCert10_2031 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2031 : checkCertificateFast 10 2031 fastCert10_2031=true := by decide +kernel
def fastCert10_2032 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2032 : checkCertificateFast 10 2032 fastCert10_2032=true := by decide +kernel
def fastCert10_2033 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2033 : checkCertificateFast 10 2033 fastCert10_2033=true := by decide +kernel
def fastCert10_2034 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2034 : checkCertificateFast 10 2034 fastCert10_2034=true := by decide +kernel
def fastCert10_2035 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2035 : checkCertificateFast 10 2035 fastCert10_2035=true := by decide +kernel
def fastCert10_2036 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2036 : checkCertificateFast 10 2036 fastCert10_2036=true := by decide +kernel
def fastCert10_2037 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2037 : checkCertificateFast 10 2037 fastCert10_2037=true := by decide +kernel
def fastCert10_2038 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2038 : checkCertificateFast 10 2038 fastCert10_2038=true := by decide +kernel
def fastCert10_2039 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2039 : checkCertificateFast 10 2039 fastCert10_2039=true := by decide +kernel
def fastCert10_2040 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2040 : checkCertificateFast 10 2040 fastCert10_2040=true := by decide +kernel
def fastCert10_2041 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2041 : checkCertificateFast 10 2041 fastCert10_2041=true := by decide +kernel
def fastCert10_2042 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2042 : checkCertificateFast 10 2042 fastCert10_2042=true := by decide +kernel
def fastCert10_2043 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2043 : checkCertificateFast 10 2043 fastCert10_2043=true := by decide +kernel
def fastCert10_2044 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2044 : checkCertificateFast 10 2044 fastCert10_2044=true := by decide +kernel
def fastCert10_2045 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2045 : checkCertificateFast 10 2045 fastCert10_2045=true := by decide +kernel
def fastCert10_2046 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2046 : checkCertificateFast 10 2046 fastCert10_2046=true := by decide +kernel
def fastCert10_2047 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2047 : checkCertificateFast 10 2047 fastCert10_2047=true := by decide +kernel
def fastCert10_2048 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2048 : checkCertificateFast 10 2048 fastCert10_2048=true := by decide +kernel
def fastCert10_2049 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2049 : checkCertificateFast 10 2049 fastCert10_2049=true := by decide +kernel
def fastCert10_2050 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_2050 : checkCertificateFast 10 2050 fastCert10_2050=true := by decide +kernel
def fastCert10_2051 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2051 : checkCertificateFast 10 2051 fastCert10_2051=true := by decide +kernel
def fastCert10_2052 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2052 : checkCertificateFast 10 2052 fastCert10_2052=true := by decide +kernel
def fastCert10_2053 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2053 : checkCertificateFast 10 2053 fastCert10_2053=true := by decide +kernel
def fastCert10_2054 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2054 : checkCertificateFast 10 2054 fastCert10_2054=true := by decide +kernel
def fastCert10_2055 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2055 : checkCertificateFast 10 2055 fastCert10_2055=true := by decide +kernel
def fastCert10_2056 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2056 : checkCertificateFast 10 2056 fastCert10_2056=true := by decide +kernel
def fastCert10_2057 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2057 : checkCertificateFast 10 2057 fastCert10_2057=true := by decide +kernel
def fastCert10_2058 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2058 : checkCertificateFast 10 2058 fastCert10_2058=true := by decide +kernel
def fastCert10_2059 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_2059 : checkCertificateFast 10 2059 fastCert10_2059=true := by decide +kernel
def fastCert10_2060 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2060 : checkCertificateFast 10 2060 fastCert10_2060=true := by decide +kernel
def fastCert10_2061 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2061 : checkCertificateFast 10 2061 fastCert10_2061=true := by decide +kernel
def fastCert10_2062 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2062 : checkCertificateFast 10 2062 fastCert10_2062=true := by decide +kernel
def fastCert10_2063 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2063 : checkCertificateFast 10 2063 fastCert10_2063=true := by decide +kernel
def fastCert10_2064 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2064 : checkCertificateFast 10 2064 fastCert10_2064=true := by decide +kernel
def fastCert10_2065 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2065 : checkCertificateFast 10 2065 fastCert10_2065=true := by decide +kernel
def fastCert10_2066 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2066 : checkCertificateFast 10 2066 fastCert10_2066=true := by decide +kernel
def fastCert10_2067 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2067 : checkCertificateFast 10 2067 fastCert10_2067=true := by decide +kernel
def fastCert10_2068 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2068 : checkCertificateFast 10 2068 fastCert10_2068=true := by decide +kernel
def fastCert10_2069 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2069 : checkCertificateFast 10 2069 fastCert10_2069=true := by decide +kernel
def fastCert10_2070 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2070 : checkCertificateFast 10 2070 fastCert10_2070=true := by decide +kernel
def fastCert10_2071 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2071 : checkCertificateFast 10 2071 fastCert10_2071=true := by decide +kernel
def fastCert10_2072 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2072 : checkCertificateFast 10 2072 fastCert10_2072=true := by decide +kernel
def fastCert10_2073 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2073 : checkCertificateFast 10 2073 fastCert10_2073=true := by decide +kernel
def fastCert10_2074 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2074 : checkCertificateFast 10 2074 fastCert10_2074=true := by decide +kernel
def fastCert10_2075 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2075 : checkCertificateFast 10 2075 fastCert10_2075=true := by decide +kernel
def fastCert10_2076 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2076 : checkCertificateFast 10 2076 fastCert10_2076=true := by decide +kernel
def fastCert10_2077 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2077 : checkCertificateFast 10 2077 fastCert10_2077=true := by decide +kernel
def fastCert10_2078 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2078 : checkCertificateFast 10 2078 fastCert10_2078=true := by decide +kernel
def fastCert10_2079 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2079 : checkCertificateFast 10 2079 fastCert10_2079=true := by decide +kernel
def fastCert10_2080 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2080 : checkCertificateFast 10 2080 fastCert10_2080=true := by decide +kernel
def fastCert10_2081 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2081 : checkCertificateFast 10 2081 fastCert10_2081=true := by decide +kernel
def fastCert10_2082 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2082 : checkCertificateFast 10 2082 fastCert10_2082=true := by decide +kernel
def fastCert10_2083 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2083 : checkCertificateFast 10 2083 fastCert10_2083=true := by decide +kernel
def fastCert10_2084 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2084 : checkCertificateFast 10 2084 fastCert10_2084=true := by decide +kernel
def fastCert10_2085 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2085 : checkCertificateFast 10 2085 fastCert10_2085=true := by decide +kernel
def fastCert10_2086 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2086 : checkCertificateFast 10 2086 fastCert10_2086=true := by decide +kernel
def fastCert10_2087 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2087 : checkCertificateFast 10 2087 fastCert10_2087=true := by decide +kernel
def fastCert10_2088 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2088 : checkCertificateFast 10 2088 fastCert10_2088=true := by decide +kernel
def fastCert10_2089 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2089 : checkCertificateFast 10 2089 fastCert10_2089=true := by decide +kernel
def fastCert10_2090 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2090 : checkCertificateFast 10 2090 fastCert10_2090=true := by decide +kernel
def fastCert10_2091 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2091 : checkCertificateFast 10 2091 fastCert10_2091=true := by decide +kernel
def fastCert10_2092 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2092 : checkCertificateFast 10 2092 fastCert10_2092=true := by decide +kernel
def fastCert10_2093 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2093 : checkCertificateFast 10 2093 fastCert10_2093=true := by decide +kernel
def fastCert10_2094 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2094 : checkCertificateFast 10 2094 fastCert10_2094=true := by decide +kernel
def fastCert10_2095 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2095 : checkCertificateFast 10 2095 fastCert10_2095=true := by decide +kernel
def fastCert10_2096 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2096 : checkCertificateFast 10 2096 fastCert10_2096=true := by decide +kernel
def fastCert10_2097 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2097 : checkCertificateFast 10 2097 fastCert10_2097=true := by decide +kernel
def fastCert10_2098 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2098 : checkCertificateFast 10 2098 fastCert10_2098=true := by decide +kernel
def fastCert10_2099 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_2099 : checkCertificateFast 10 2099 fastCert10_2099=true := by decide +kernel
def fastCert10_2100 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2100 : checkCertificateFast 10 2100 fastCert10_2100=true := by decide +kernel
def fastCert10_2101 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2101 : checkCertificateFast 10 2101 fastCert10_2101=true := by decide +kernel
def fastCert10_2102 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2102 : checkCertificateFast 10 2102 fastCert10_2102=true := by decide +kernel
def fastCert10_2103 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2103 : checkCertificateFast 10 2103 fastCert10_2103=true := by decide +kernel
def fastCert10_2104 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2104 : checkCertificateFast 10 2104 fastCert10_2104=true := by decide +kernel
def fastCert10_2105 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2105 : checkCertificateFast 10 2105 fastCert10_2105=true := by decide +kernel
def fastCert10_2106 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else 0⟩
theorem fastCase10_2106 : checkCertificateFast 10 2106 fastCert10_2106=true := by decide +kernel
def fastCert10_2107 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2107 : checkCertificateFast 10 2107 fastCert10_2107=true := by decide +kernel
def fastCert10_2108 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2108 : checkCertificateFast 10 2108 fastCert10_2108=true := by decide +kernel
def fastCert10_2109 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2109 : checkCertificateFast 10 2109 fastCert10_2109=true := by decide +kernel
def fastCert10_2110 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2110 : checkCertificateFast 10 2110 fastCert10_2110=true := by decide +kernel
def fastCert10_2111 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2111 : checkCertificateFast 10 2111 fastCert10_2111=true := by decide +kernel
def fastCert10_2112 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2112 : checkCertificateFast 10 2112 fastCert10_2112=true := by decide +kernel
def fastCert10_2113 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2113 : checkCertificateFast 10 2113 fastCert10_2113=true := by decide +kernel
def fastCert10_2114 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2114 : checkCertificateFast 10 2114 fastCert10_2114=true := by decide +kernel
def fastCert10_2115 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2115 : checkCertificateFast 10 2115 fastCert10_2115=true := by decide +kernel
def fastCert10_2116 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2116 : checkCertificateFast 10 2116 fastCert10_2116=true := by decide +kernel
def fastCert10_2117 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2117 : checkCertificateFast 10 2117 fastCert10_2117=true := by decide +kernel
def fastCert10_2118 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2118 : checkCertificateFast 10 2118 fastCert10_2118=true := by decide +kernel
def fastCert10_2119 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2119 : checkCertificateFast 10 2119 fastCert10_2119=true := by decide +kernel
def fastCert10_2120 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2120 : checkCertificateFast 10 2120 fastCert10_2120=true := by decide +kernel
def fastCert10_2121 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2121 : checkCertificateFast 10 2121 fastCert10_2121=true := by decide +kernel
def fastCert10_2122 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2122 : checkCertificateFast 10 2122 fastCert10_2122=true := by decide +kernel
def fastCert10_2123 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2123 : checkCertificateFast 10 2123 fastCert10_2123=true := by decide +kernel
def fastCert10_2124 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2124 : checkCertificateFast 10 2124 fastCert10_2124=true := by decide +kernel
def fastCert10_2125 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2125 : checkCertificateFast 10 2125 fastCert10_2125=true := by decide +kernel
def fastCert10_2126 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2126 : checkCertificateFast 10 2126 fastCert10_2126=true := by decide +kernel
def fastCert10_2127 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2127 : checkCertificateFast 10 2127 fastCert10_2127=true := by decide +kernel
def fastCert10_2128 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2128 : checkCertificateFast 10 2128 fastCert10_2128=true := by decide +kernel
def fastCert10_2129 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2129 : checkCertificateFast 10 2129 fastCert10_2129=true := by decide +kernel
def fastCert10_2130 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2130 : checkCertificateFast 10 2130 fastCert10_2130=true := by decide +kernel
def fastCert10_2131 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2131 : checkCertificateFast 10 2131 fastCert10_2131=true := by decide +kernel
def fastCert10_2132 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2132 : checkCertificateFast 10 2132 fastCert10_2132=true := by decide +kernel
def fastCert10_2133 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2133 : checkCertificateFast 10 2133 fastCert10_2133=true := by decide +kernel
def fastCert10_2134 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2134 : checkCertificateFast 10 2134 fastCert10_2134=true := by decide +kernel
def fastCert10_2135 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2135 : checkCertificateFast 10 2135 fastCert10_2135=true := by decide +kernel
def fastCert10_2136 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2136 : checkCertificateFast 10 2136 fastCert10_2136=true := by decide +kernel
def fastCert10_2137 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2137 : checkCertificateFast 10 2137 fastCert10_2137=true := by decide +kernel
def fastCert10_2138 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2138 : checkCertificateFast 10 2138 fastCert10_2138=true := by decide +kernel
def fastCert10_2139 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2139 : checkCertificateFast 10 2139 fastCert10_2139=true := by decide +kernel
def fastCert10_2140 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2140 : checkCertificateFast 10 2140 fastCert10_2140=true := by decide +kernel
def fastCert10_2141 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2141 : checkCertificateFast 10 2141 fastCert10_2141=true := by decide +kernel
def fastCert10_2142 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2142 : checkCertificateFast 10 2142 fastCert10_2142=true := by decide +kernel
def fastCert10_2143 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2143 : checkCertificateFast 10 2143 fastCert10_2143=true := by decide +kernel
def fastCert10_2144 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2144 : checkCertificateFast 10 2144 fastCert10_2144=true := by decide +kernel
def fastCert10_2145 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2145 : checkCertificateFast 10 2145 fastCert10_2145=true := by decide +kernel
def fastCert10_2146 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_2146 : checkCertificateFast 10 2146 fastCert10_2146=true := by decide +kernel
def fastCert10_2147 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2147 : checkCertificateFast 10 2147 fastCert10_2147=true := by decide +kernel
def fastCert10_2148 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2148 : checkCertificateFast 10 2148 fastCert10_2148=true := by decide +kernel
def fastCert10_2149 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2149 : checkCertificateFast 10 2149 fastCert10_2149=true := by decide +kernel
def fastCert10_2150 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2150 : checkCertificateFast 10 2150 fastCert10_2150=true := by decide +kernel
def fastCert10_2151 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2151 : checkCertificateFast 10 2151 fastCert10_2151=true := by decide +kernel
def fastCert10_2152 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2152 : checkCertificateFast 10 2152 fastCert10_2152=true := by decide +kernel
def fastCert10_2153 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2153 : checkCertificateFast 10 2153 fastCert10_2153=true := by decide +kernel
def fastCert10_2154 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2154 : checkCertificateFast 10 2154 fastCert10_2154=true := by decide +kernel
def fastCert10_2155 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2155 : checkCertificateFast 10 2155 fastCert10_2155=true := by decide +kernel
def fastCert10_2156 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2156 : checkCertificateFast 10 2156 fastCert10_2156=true := by decide +kernel
def fastCert10_2157 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2157 : checkCertificateFast 10 2157 fastCert10_2157=true := by decide +kernel
def fastCert10_2158 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2158 : checkCertificateFast 10 2158 fastCert10_2158=true := by decide +kernel
def fastCert10_2159 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2159 : checkCertificateFast 10 2159 fastCert10_2159=true := by decide +kernel
def fastCert10_2160 : Certificate := ⟨12,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2160 : checkCertificateFast 10 2160 fastCert10_2160=true := by decide +kernel
def fastCert10_2161 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2161 : checkCertificateFast 10 2161 fastCert10_2161=true := by decide +kernel
def fastCert10_2162 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2162 : checkCertificateFast 10 2162 fastCert10_2162=true := by decide +kernel
def fastCert10_2163 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2163 : checkCertificateFast 10 2163 fastCert10_2163=true := by decide +kernel
def fastCert10_2164 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2164 : checkCertificateFast 10 2164 fastCert10_2164=true := by decide +kernel
def fastCert10_2165 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2165 : checkCertificateFast 10 2165 fastCert10_2165=true := by decide +kernel
def fastCert10_2166 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2166 : checkCertificateFast 10 2166 fastCert10_2166=true := by decide +kernel
def fastCert10_2167 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2167 : checkCertificateFast 10 2167 fastCert10_2167=true := by decide +kernel
def fastCert10_2168 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2168 : checkCertificateFast 10 2168 fastCert10_2168=true := by decide +kernel
def fastCert10_2169 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2169 : checkCertificateFast 10 2169 fastCert10_2169=true := by decide +kernel
def fastCert10_2170 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2170 : checkCertificateFast 10 2170 fastCert10_2170=true := by decide +kernel
def fastCert10_2171 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2171 : checkCertificateFast 10 2171 fastCert10_2171=true := by decide +kernel
def fastCert10_2172 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2172 : checkCertificateFast 10 2172 fastCert10_2172=true := by decide +kernel
def fastCert10_2173 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2173 : checkCertificateFast 10 2173 fastCert10_2173=true := by decide +kernel
def fastCert10_2174 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2174 : checkCertificateFast 10 2174 fastCert10_2174=true := by decide +kernel
def fastCert10_2175 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2175 : checkCertificateFast 10 2175 fastCert10_2175=true := by decide +kernel
def fastCert10_2176 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2176 : checkCertificateFast 10 2176 fastCert10_2176=true := by decide +kernel
def fastCert10_2177 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2177 : checkCertificateFast 10 2177 fastCert10_2177=true := by decide +kernel
def fastCert10_2178 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2178 : checkCertificateFast 10 2178 fastCert10_2178=true := by decide +kernel
def fastCert10_2179 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2179 : checkCertificateFast 10 2179 fastCert10_2179=true := by decide +kernel
def fastCert10_2180 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2180 : checkCertificateFast 10 2180 fastCert10_2180=true := by decide +kernel
def fastCert10_2181 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2181 : checkCertificateFast 10 2181 fastCert10_2181=true := by decide +kernel
def fastCert10_2182 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2182 : checkCertificateFast 10 2182 fastCert10_2182=true := by decide +kernel
def fastCert10_2183 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2183 : checkCertificateFast 10 2183 fastCert10_2183=true := by decide +kernel
def fastCert10_2184 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2184 : checkCertificateFast 10 2184 fastCert10_2184=true := by decide +kernel
def fastCert10_2185 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2185 : checkCertificateFast 10 2185 fastCert10_2185=true := by decide +kernel
def fastCert10_2186 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2186 : checkCertificateFast 10 2186 fastCert10_2186=true := by decide +kernel
def fastCert10_2187 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2187 : checkCertificateFast 10 2187 fastCert10_2187=true := by decide +kernel
def fastCert10_2188 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2188 : checkCertificateFast 10 2188 fastCert10_2188=true := by decide +kernel
def fastCert10_2189 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2189 : checkCertificateFast 10 2189 fastCert10_2189=true := by decide +kernel
def fastCert10_2190 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2190 : checkCertificateFast 10 2190 fastCert10_2190=true := by decide +kernel
def fastCert10_2191 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2191 : checkCertificateFast 10 2191 fastCert10_2191=true := by decide +kernel
def fastCert10_2192 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2192 : checkCertificateFast 10 2192 fastCert10_2192=true := by decide +kernel
def fastCert10_2193 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2193 : checkCertificateFast 10 2193 fastCert10_2193=true := by decide +kernel
def fastCert10_2194 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2194 : checkCertificateFast 10 2194 fastCert10_2194=true := by decide +kernel
def fastCert10_2195 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2195 : checkCertificateFast 10 2195 fastCert10_2195=true := by decide +kernel
def fastCert10_2196 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2196 : checkCertificateFast 10 2196 fastCert10_2196=true := by decide +kernel
def fastCert10_2197 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2197 : checkCertificateFast 10 2197 fastCert10_2197=true := by decide +kernel
def fastCert10_2198 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2198 : checkCertificateFast 10 2198 fastCert10_2198=true := by decide +kernel
def fastCert10_2199 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2199 : checkCertificateFast 10 2199 fastCert10_2199=true := by decide +kernel
def fastCert10_2200 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2200 : checkCertificateFast 10 2200 fastCert10_2200=true := by decide +kernel
def fastCert10_2201 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2201 : checkCertificateFast 10 2201 fastCert10_2201=true := by decide +kernel
def fastCert10_2202 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2202 : checkCertificateFast 10 2202 fastCert10_2202=true := by decide +kernel
def fastCert10_2203 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2203 : checkCertificateFast 10 2203 fastCert10_2203=true := by decide +kernel
def fastCert10_2204 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2204 : checkCertificateFast 10 2204 fastCert10_2204=true := by decide +kernel
def fastCert10_2205 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2205 : checkCertificateFast 10 2205 fastCert10_2205=true := by decide +kernel
def fastCert10_2206 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2206 : checkCertificateFast 10 2206 fastCert10_2206=true := by decide +kernel
def fastCert10_2207 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2207 : checkCertificateFast 10 2207 fastCert10_2207=true := by decide +kernel
def fastCert10_2208 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2208 : checkCertificateFast 10 2208 fastCert10_2208=true := by decide +kernel
def fastCert10_2209 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2209 : checkCertificateFast 10 2209 fastCert10_2209=true := by decide +kernel
def fastCert10_2210 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_2210 : checkCertificateFast 10 2210 fastCert10_2210=true := by decide +kernel
def fastCert10_2211 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_2211 : checkCertificateFast 10 2211 fastCert10_2211=true := by decide +kernel
def fastCert10_2212 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2212 : checkCertificateFast 10 2212 fastCert10_2212=true := by decide +kernel
def fastCert10_2213 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2213 : checkCertificateFast 10 2213 fastCert10_2213=true := by decide +kernel
def fastCert10_2214 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2214 : checkCertificateFast 10 2214 fastCert10_2214=true := by decide +kernel
def fastCert10_2215 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2215 : checkCertificateFast 10 2215 fastCert10_2215=true := by decide +kernel
def fastCert10_2216 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2216 : checkCertificateFast 10 2216 fastCert10_2216=true := by decide +kernel
def fastCert10_2217 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2217 : checkCertificateFast 10 2217 fastCert10_2217=true := by decide +kernel
def fastCert10_2218 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_2218 : checkCertificateFast 10 2218 fastCert10_2218=true := by decide +kernel
def fastCert10_2219 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2219 : checkCertificateFast 10 2219 fastCert10_2219=true := by decide +kernel
def fastCert10_2220 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2220 : checkCertificateFast 10 2220 fastCert10_2220=true := by decide +kernel
def fastCert10_2221 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2221 : checkCertificateFast 10 2221 fastCert10_2221=true := by decide +kernel
def fastCert10_2222 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2222 : checkCertificateFast 10 2222 fastCert10_2222=true := by decide +kernel
def fastCert10_2223 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2223 : checkCertificateFast 10 2223 fastCert10_2223=true := by decide +kernel
def fastCert10_2224 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (7) else if t=0 ∧ i=1 then (-5) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-8) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=6 then (5) else if t=0 ∧ i=7 then (-5) else if t=0 ∧ i=9 then (5) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=16 then (-5) else 0⟩
theorem fastCase10_2224 : checkCertificateFast 10 2224 fastCert10_2224=true := by decide +kernel
def fastCert10_2225 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2225 : checkCertificateFast 10 2225 fastCert10_2225=true := by decide +kernel
def fastCert10_2226 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2226 : checkCertificateFast 10 2226 fastCert10_2226=true := by decide +kernel
def fastCert10_2227 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2227 : checkCertificateFast 10 2227 fastCert10_2227=true := by decide +kernel
def fastCert10_2228 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2228 : checkCertificateFast 10 2228 fastCert10_2228=true := by decide +kernel
def fastCert10_2229 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2229 : checkCertificateFast 10 2229 fastCert10_2229=true := by decide +kernel
def fastCert10_2230 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2230 : checkCertificateFast 10 2230 fastCert10_2230=true := by decide +kernel
def fastCert10_2231 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2231 : checkCertificateFast 10 2231 fastCert10_2231=true := by decide +kernel
def fastCert10_2232 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-3) else if t=0 ∧ i=8 then (-3) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-4) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (3) else if t=0 ∧ i=16 then (3) else 0⟩
theorem fastCase10_2232 : checkCertificateFast 10 2232 fastCert10_2232=true := by decide +kernel
def fastCert10_2233 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2233 : checkCertificateFast 10 2233 fastCert10_2233=true := by decide +kernel
def fastCert10_2234 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2234 : checkCertificateFast 10 2234 fastCert10_2234=true := by decide +kernel
def fastCert10_2235 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2235 : checkCertificateFast 10 2235 fastCert10_2235=true := by decide +kernel
def fastCert10_2236 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2236 : checkCertificateFast 10 2236 fastCert10_2236=true := by decide +kernel
def fastCert10_2237 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2237 : checkCertificateFast 10 2237 fastCert10_2237=true := by decide +kernel
def fastCert10_2238 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2238 : checkCertificateFast 10 2238 fastCert10_2238=true := by decide +kernel
def fastCert10_2239 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2239 : checkCertificateFast 10 2239 fastCert10_2239=true := by decide +kernel
def fastCert10_2240 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2240 : checkCertificateFast 10 2240 fastCert10_2240=true := by decide +kernel
def fastCert10_2241 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2241 : checkCertificateFast 10 2241 fastCert10_2241=true := by decide +kernel
def fastCert10_2242 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2242 : checkCertificateFast 10 2242 fastCert10_2242=true := by decide +kernel
def fastCert10_2243 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2243 : checkCertificateFast 10 2243 fastCert10_2243=true := by decide +kernel
def fastCert10_2244 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2244 : checkCertificateFast 10 2244 fastCert10_2244=true := by decide +kernel
def fastCert10_2245 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2245 : checkCertificateFast 10 2245 fastCert10_2245=true := by decide +kernel
def fastCert10_2246 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2246 : checkCertificateFast 10 2246 fastCert10_2246=true := by decide +kernel
def fastCert10_2247 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2247 : checkCertificateFast 10 2247 fastCert10_2247=true := by decide +kernel
def fastCert10_2248 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2248 : checkCertificateFast 10 2248 fastCert10_2248=true := by decide +kernel
def fastCert10_2249 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2249 : checkCertificateFast 10 2249 fastCert10_2249=true := by decide +kernel
def fastCert10_2250 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2250 : checkCertificateFast 10 2250 fastCert10_2250=true := by decide +kernel
def fastCert10_2251 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2251 : checkCertificateFast 10 2251 fastCert10_2251=true := by decide +kernel
def fastCert10_2252 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2252 : checkCertificateFast 10 2252 fastCert10_2252=true := by decide +kernel
def fastCert10_2253 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2253 : checkCertificateFast 10 2253 fastCert10_2253=true := by decide +kernel
def fastCert10_2254 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2254 : checkCertificateFast 10 2254 fastCert10_2254=true := by decide +kernel
def fastCert10_2255 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2255 : checkCertificateFast 10 2255 fastCert10_2255=true := by decide +kernel
def fastCert10_2256 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2256 : checkCertificateFast 10 2256 fastCert10_2256=true := by decide +kernel
def fastCert10_2257 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2257 : checkCertificateFast 10 2257 fastCert10_2257=true := by decide +kernel
def fastCert10_2258 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2258 : checkCertificateFast 10 2258 fastCert10_2258=true := by decide +kernel
def fastCert10_2259 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2259 : checkCertificateFast 10 2259 fastCert10_2259=true := by decide +kernel
def fastCert10_2260 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2260 : checkCertificateFast 10 2260 fastCert10_2260=true := by decide +kernel
def fastCert10_2261 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2261 : checkCertificateFast 10 2261 fastCert10_2261=true := by decide +kernel
def fastCert10_2262 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2262 : checkCertificateFast 10 2262 fastCert10_2262=true := by decide +kernel
def fastCert10_2263 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2263 : checkCertificateFast 10 2263 fastCert10_2263=true := by decide +kernel
def fastCert10_2264 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2264 : checkCertificateFast 10 2264 fastCert10_2264=true := by decide +kernel
def fastCert10_2265 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2265 : checkCertificateFast 10 2265 fastCert10_2265=true := by decide +kernel
def fastCert10_2266 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2266 : checkCertificateFast 10 2266 fastCert10_2266=true := by decide +kernel
def fastCert10_2267 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2267 : checkCertificateFast 10 2267 fastCert10_2267=true := by decide +kernel
def fastCert10_2268 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2268 : checkCertificateFast 10 2268 fastCert10_2268=true := by decide +kernel
def fastCert10_2269 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2269 : checkCertificateFast 10 2269 fastCert10_2269=true := by decide +kernel
def fastCert10_2270 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2270 : checkCertificateFast 10 2270 fastCert10_2270=true := by decide +kernel
def fastCert10_2271 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2271 : checkCertificateFast 10 2271 fastCert10_2271=true := by decide +kernel
def fastCert10_2272 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2272 : checkCertificateFast 10 2272 fastCert10_2272=true := by decide +kernel
def fastCert10_2273 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2273 : checkCertificateFast 10 2273 fastCert10_2273=true := by decide +kernel
def fastCert10_2274 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2274 : checkCertificateFast 10 2274 fastCert10_2274=true := by decide +kernel
def fastCert10_2275 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (4) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2275 : checkCertificateFast 10 2275 fastCert10_2275=true := by decide +kernel
def fastCert10_2276 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2276 : checkCertificateFast 10 2276 fastCert10_2276=true := by decide +kernel
def fastCert10_2277 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2277 : checkCertificateFast 10 2277 fastCert10_2277=true := by decide +kernel
def fastCert10_2278 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2278 : checkCertificateFast 10 2278 fastCert10_2278=true := by decide +kernel
def fastCert10_2279 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2279 : checkCertificateFast 10 2279 fastCert10_2279=true := by decide +kernel
def fastCert10_2280 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2280 : checkCertificateFast 10 2280 fastCert10_2280=true := by decide +kernel
def fastCert10_2281 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2281 : checkCertificateFast 10 2281 fastCert10_2281=true := by decide +kernel
def fastCert10_2282 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=3 then (4) else if t=0 ∧ i=5 then (4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-3) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2282 : checkCertificateFast 10 2282 fastCert10_2282=true := by decide +kernel
def fastCert10_2283 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2283 : checkCertificateFast 10 2283 fastCert10_2283=true := by decide +kernel
def fastCert10_2284 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2284 : checkCertificateFast 10 2284 fastCert10_2284=true := by decide +kernel
def fastCert10_2285 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2285 : checkCertificateFast 10 2285 fastCert10_2285=true := by decide +kernel
def fastCert10_2286 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2286 : checkCertificateFast 10 2286 fastCert10_2286=true := by decide +kernel
def fastCert10_2287 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2287 : checkCertificateFast 10 2287 fastCert10_2287=true := by decide +kernel
def fastCert10_2288 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2288 : checkCertificateFast 10 2288 fastCert10_2288=true := by decide +kernel
def fastCert10_2289 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2289 : checkCertificateFast 10 2289 fastCert10_2289=true := by decide +kernel
def fastCert10_2290 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2290 : checkCertificateFast 10 2290 fastCert10_2290=true := by decide +kernel
def fastCert10_2291 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2291 : checkCertificateFast 10 2291 fastCert10_2291=true := by decide +kernel
def fastCert10_2292 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2292 : checkCertificateFast 10 2292 fastCert10_2292=true := by decide +kernel
def fastCert10_2293 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2293 : checkCertificateFast 10 2293 fastCert10_2293=true := by decide +kernel
def fastCert10_2294 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2294 : checkCertificateFast 10 2294 fastCert10_2294=true := by decide +kernel
def fastCert10_2295 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2295 : checkCertificateFast 10 2295 fastCert10_2295=true := by decide +kernel
def fastCert10_2296 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=4 then (-4) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (3) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2296 : checkCertificateFast 10 2296 fastCert10_2296=true := by decide +kernel
def fastCert10_2297 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2297 : checkCertificateFast 10 2297 fastCert10_2297=true := by decide +kernel
def fastCert10_2298 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2298 : checkCertificateFast 10 2298 fastCert10_2298=true := by decide +kernel
def fastCert10_2299 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2299 : checkCertificateFast 10 2299 fastCert10_2299=true := by decide +kernel
def fastCert10_2300 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2300 : checkCertificateFast 10 2300 fastCert10_2300=true := by decide +kernel
def fastCert10_2301 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2301 : checkCertificateFast 10 2301 fastCert10_2301=true := by decide +kernel
def fastCert10_2302 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2302 : checkCertificateFast 10 2302 fastCert10_2302=true := by decide +kernel
def fastCert10_2303 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2303 : checkCertificateFast 10 2303 fastCert10_2303=true := by decide +kernel
def fastCert10_2304 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2304 : checkCertificateFast 10 2304 fastCert10_2304=true := by decide +kernel
def fastCert10_2305 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2305 : checkCertificateFast 10 2305 fastCert10_2305=true := by decide +kernel
def fastCert10_2306 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2306 : checkCertificateFast 10 2306 fastCert10_2306=true := by decide +kernel
def fastCert10_2307 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2307 : checkCertificateFast 10 2307 fastCert10_2307=true := by decide +kernel
def fastCert10_2308 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2308 : checkCertificateFast 10 2308 fastCert10_2308=true := by decide +kernel
def fastCert10_2309 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2309 : checkCertificateFast 10 2309 fastCert10_2309=true := by decide +kernel
def fastCert10_2310 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2310 : checkCertificateFast 10 2310 fastCert10_2310=true := by decide +kernel
def fastCert10_2311 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2311 : checkCertificateFast 10 2311 fastCert10_2311=true := by decide +kernel
def fastCert10_2312 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2312 : checkCertificateFast 10 2312 fastCert10_2312=true := by decide +kernel
def fastCert10_2313 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2313 : checkCertificateFast 10 2313 fastCert10_2313=true := by decide +kernel
def fastCert10_2314 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2314 : checkCertificateFast 10 2314 fastCert10_2314=true := by decide +kernel
def fastCert10_2315 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2315 : checkCertificateFast 10 2315 fastCert10_2315=true := by decide +kernel
def fastCert10_2316 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2316 : checkCertificateFast 10 2316 fastCert10_2316=true := by decide +kernel
def fastCert10_2317 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2317 : checkCertificateFast 10 2317 fastCert10_2317=true := by decide +kernel
def fastCert10_2318 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2318 : checkCertificateFast 10 2318 fastCert10_2318=true := by decide +kernel
def fastCert10_2319 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2319 : checkCertificateFast 10 2319 fastCert10_2319=true := by decide +kernel
def fastCert10_2320 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2320 : checkCertificateFast 10 2320 fastCert10_2320=true := by decide +kernel
def fastCert10_2321 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2321 : checkCertificateFast 10 2321 fastCert10_2321=true := by decide +kernel
def fastCert10_2322 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2322 : checkCertificateFast 10 2322 fastCert10_2322=true := by decide +kernel
def fastCert10_2323 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2323 : checkCertificateFast 10 2323 fastCert10_2323=true := by decide +kernel
def fastCert10_2324 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2324 : checkCertificateFast 10 2324 fastCert10_2324=true := by decide +kernel
def fastCert10_2325 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2325 : checkCertificateFast 10 2325 fastCert10_2325=true := by decide +kernel
def fastCert10_2326 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2326 : checkCertificateFast 10 2326 fastCert10_2326=true := by decide +kernel
def fastCert10_2327 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2327 : checkCertificateFast 10 2327 fastCert10_2327=true := by decide +kernel
def fastCert10_2328 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2328 : checkCertificateFast 10 2328 fastCert10_2328=true := by decide +kernel
def fastCert10_2329 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2329 : checkCertificateFast 10 2329 fastCert10_2329=true := by decide +kernel
def fastCert10_2330 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2330 : checkCertificateFast 10 2330 fastCert10_2330=true := by decide +kernel
def fastCert10_2331 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2331 : checkCertificateFast 10 2331 fastCert10_2331=true := by decide +kernel
def fastCert10_2332 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2332 : checkCertificateFast 10 2332 fastCert10_2332=true := by decide +kernel
def fastCert10_2333 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2333 : checkCertificateFast 10 2333 fastCert10_2333=true := by decide +kernel
def fastCert10_2334 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2334 : checkCertificateFast 10 2334 fastCert10_2334=true := by decide +kernel
def fastCert10_2335 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2335 : checkCertificateFast 10 2335 fastCert10_2335=true := by decide +kernel
def fastCert10_2336 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2336 : checkCertificateFast 10 2336 fastCert10_2336=true := by decide +kernel
def fastCert10_2337 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2337 : checkCertificateFast 10 2337 fastCert10_2337=true := by decide +kernel
def fastCert10_2338 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2338 : checkCertificateFast 10 2338 fastCert10_2338=true := by decide +kernel
def fastCert10_2339 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2339 : checkCertificateFast 10 2339 fastCert10_2339=true := by decide +kernel
def fastCert10_2340 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2340 : checkCertificateFast 10 2340 fastCert10_2340=true := by decide +kernel
def fastCert10_2341 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2341 : checkCertificateFast 10 2341 fastCert10_2341=true := by decide +kernel
def fastCert10_2342 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2342 : checkCertificateFast 10 2342 fastCert10_2342=true := by decide +kernel
def fastCert10_2343 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2343 : checkCertificateFast 10 2343 fastCert10_2343=true := by decide +kernel
def fastCert10_2344 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2344 : checkCertificateFast 10 2344 fastCert10_2344=true := by decide +kernel
def fastCert10_2345 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2345 : checkCertificateFast 10 2345 fastCert10_2345=true := by decide +kernel
def fastCert10_2346 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2346 : checkCertificateFast 10 2346 fastCert10_2346=true := by decide +kernel
def fastCert10_2347 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2347 : checkCertificateFast 10 2347 fastCert10_2347=true := by decide +kernel
def fastCert10_2348 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2348 : checkCertificateFast 10 2348 fastCert10_2348=true := by decide +kernel
def fastCert10_2349 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2349 : checkCertificateFast 10 2349 fastCert10_2349=true := by decide +kernel
def fastCert10_2350 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2350 : checkCertificateFast 10 2350 fastCert10_2350=true := by decide +kernel
def fastCert10_2351 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2351 : checkCertificateFast 10 2351 fastCert10_2351=true := by decide +kernel
def fastCert10_2352 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2352 : checkCertificateFast 10 2352 fastCert10_2352=true := by decide +kernel
def fastCert10_2353 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2353 : checkCertificateFast 10 2353 fastCert10_2353=true := by decide +kernel
def fastCert10_2354 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2354 : checkCertificateFast 10 2354 fastCert10_2354=true := by decide +kernel
def fastCert10_2355 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2355 : checkCertificateFast 10 2355 fastCert10_2355=true := by decide +kernel
def fastCert10_2356 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2356 : checkCertificateFast 10 2356 fastCert10_2356=true := by decide +kernel
def fastCert10_2357 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2357 : checkCertificateFast 10 2357 fastCert10_2357=true := by decide +kernel
def fastCert10_2358 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2358 : checkCertificateFast 10 2358 fastCert10_2358=true := by decide +kernel
def fastCert10_2359 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2359 : checkCertificateFast 10 2359 fastCert10_2359=true := by decide +kernel
def fastCert10_2360 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2360 : checkCertificateFast 10 2360 fastCert10_2360=true := by decide +kernel
def fastCert10_2361 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2361 : checkCertificateFast 10 2361 fastCert10_2361=true := by decide +kernel
def fastCert10_2362 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2362 : checkCertificateFast 10 2362 fastCert10_2362=true := by decide +kernel
def fastCert10_2363 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2363 : checkCertificateFast 10 2363 fastCert10_2363=true := by decide +kernel
def fastCert10_2364 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2364 : checkCertificateFast 10 2364 fastCert10_2364=true := by decide +kernel
def fastCert10_2365 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2365 : checkCertificateFast 10 2365 fastCert10_2365=true := by decide +kernel
def fastCert10_2366 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2366 : checkCertificateFast 10 2366 fastCert10_2366=true := by decide +kernel
def fastCert10_2367 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2367 : checkCertificateFast 10 2367 fastCert10_2367=true := by decide +kernel
def fastCert10_2368 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2368 : checkCertificateFast 10 2368 fastCert10_2368=true := by decide +kernel
def fastCert10_2369 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2369 : checkCertificateFast 10 2369 fastCert10_2369=true := by decide +kernel
def fastCert10_2370 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2370 : checkCertificateFast 10 2370 fastCert10_2370=true := by decide +kernel
def fastCert10_2371 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2371 : checkCertificateFast 10 2371 fastCert10_2371=true := by decide +kernel
def fastCert10_2372 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2372 : checkCertificateFast 10 2372 fastCert10_2372=true := by decide +kernel
def fastCert10_2373 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2373 : checkCertificateFast 10 2373 fastCert10_2373=true := by decide +kernel
def fastCert10_2374 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2374 : checkCertificateFast 10 2374 fastCert10_2374=true := by decide +kernel
def fastCert10_2375 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2375 : checkCertificateFast 10 2375 fastCert10_2375=true := by decide +kernel
def fastCert10_2376 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2376 : checkCertificateFast 10 2376 fastCert10_2376=true := by decide +kernel
def fastCert10_2377 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2377 : checkCertificateFast 10 2377 fastCert10_2377=true := by decide +kernel
def fastCert10_2378 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2378 : checkCertificateFast 10 2378 fastCert10_2378=true := by decide +kernel
def fastCert10_2379 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2379 : checkCertificateFast 10 2379 fastCert10_2379=true := by decide +kernel
def fastCert10_2380 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2380 : checkCertificateFast 10 2380 fastCert10_2380=true := by decide +kernel
def fastCert10_2381 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2381 : checkCertificateFast 10 2381 fastCert10_2381=true := by decide +kernel
def fastCert10_2382 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2382 : checkCertificateFast 10 2382 fastCert10_2382=true := by decide +kernel
def fastCert10_2383 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2383 : checkCertificateFast 10 2383 fastCert10_2383=true := by decide +kernel
def fastCert10_2384 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2384 : checkCertificateFast 10 2384 fastCert10_2384=true := by decide +kernel
def fastCert10_2385 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2385 : checkCertificateFast 10 2385 fastCert10_2385=true := by decide +kernel
def fastCert10_2386 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2386 : checkCertificateFast 10 2386 fastCert10_2386=true := by decide +kernel
def fastCert10_2387 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2387 : checkCertificateFast 10 2387 fastCert10_2387=true := by decide +kernel
def fastCert10_2388 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2388 : checkCertificateFast 10 2388 fastCert10_2388=true := by decide +kernel
def fastCert10_2389 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2389 : checkCertificateFast 10 2389 fastCert10_2389=true := by decide +kernel
def fastCert10_2390 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2390 : checkCertificateFast 10 2390 fastCert10_2390=true := by decide +kernel
def fastCert10_2391 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2391 : checkCertificateFast 10 2391 fastCert10_2391=true := by decide +kernel
def fastCert10_2392 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2392 : checkCertificateFast 10 2392 fastCert10_2392=true := by decide +kernel
def fastCert10_2393 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2393 : checkCertificateFast 10 2393 fastCert10_2393=true := by decide +kernel
def fastCert10_2394 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2394 : checkCertificateFast 10 2394 fastCert10_2394=true := by decide +kernel
def fastCert10_2395 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2395 : checkCertificateFast 10 2395 fastCert10_2395=true := by decide +kernel
def fastCert10_2396 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2396 : checkCertificateFast 10 2396 fastCert10_2396=true := by decide +kernel
def fastCert10_2397 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2397 : checkCertificateFast 10 2397 fastCert10_2397=true := by decide +kernel
def fastCert10_2398 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2398 : checkCertificateFast 10 2398 fastCert10_2398=true := by decide +kernel
def fastCert10_2399 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2399 : checkCertificateFast 10 2399 fastCert10_2399=true := by decide +kernel
def fastCert10_2400 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2400 : checkCertificateFast 10 2400 fastCert10_2400=true := by decide +kernel
def fastCert10_2401 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2401 : checkCertificateFast 10 2401 fastCert10_2401=true := by decide +kernel
def fastCert10_2402 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2402 : checkCertificateFast 10 2402 fastCert10_2402=true := by decide +kernel
def fastCert10_2403 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2403 : checkCertificateFast 10 2403 fastCert10_2403=true := by decide +kernel
def fastCert10_2404 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2404 : checkCertificateFast 10 2404 fastCert10_2404=true := by decide +kernel
def fastCert10_2405 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2405 : checkCertificateFast 10 2405 fastCert10_2405=true := by decide +kernel
def fastCert10_2406 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2406 : checkCertificateFast 10 2406 fastCert10_2406=true := by decide +kernel
def fastCert10_2407 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2407 : checkCertificateFast 10 2407 fastCert10_2407=true := by decide +kernel
def fastCert10_2408 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2408 : checkCertificateFast 10 2408 fastCert10_2408=true := by decide +kernel
def fastCert10_2409 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2409 : checkCertificateFast 10 2409 fastCert10_2409=true := by decide +kernel
def fastCert10_2410 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2410 : checkCertificateFast 10 2410 fastCert10_2410=true := by decide +kernel
def fastCert10_2411 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2411 : checkCertificateFast 10 2411 fastCert10_2411=true := by decide +kernel
def fastCert10_2412 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2412 : checkCertificateFast 10 2412 fastCert10_2412=true := by decide +kernel
def fastCert10_2413 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2413 : checkCertificateFast 10 2413 fastCert10_2413=true := by decide +kernel
def fastCert10_2414 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2414 : checkCertificateFast 10 2414 fastCert10_2414=true := by decide +kernel
def fastCert10_2415 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2415 : checkCertificateFast 10 2415 fastCert10_2415=true := by decide +kernel
def fastCert10_2416 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2416 : checkCertificateFast 10 2416 fastCert10_2416=true := by decide +kernel
def fastCert10_2417 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2417 : checkCertificateFast 10 2417 fastCert10_2417=true := by decide +kernel
def fastCert10_2418 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2418 : checkCertificateFast 10 2418 fastCert10_2418=true := by decide +kernel
def fastCert10_2419 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2419 : checkCertificateFast 10 2419 fastCert10_2419=true := by decide +kernel
def fastCert10_2420 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2420 : checkCertificateFast 10 2420 fastCert10_2420=true := by decide +kernel
def fastCert10_2421 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2421 : checkCertificateFast 10 2421 fastCert10_2421=true := by decide +kernel
def fastCert10_2422 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2422 : checkCertificateFast 10 2422 fastCert10_2422=true := by decide +kernel
def fastCert10_2423 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2423 : checkCertificateFast 10 2423 fastCert10_2423=true := by decide +kernel
def fastCert10_2424 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2424 : checkCertificateFast 10 2424 fastCert10_2424=true := by decide +kernel
def fastCert10_2425 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2425 : checkCertificateFast 10 2425 fastCert10_2425=true := by decide +kernel
def fastCert10_2426 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2426 : checkCertificateFast 10 2426 fastCert10_2426=true := by decide +kernel
def fastCert10_2427 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2427 : checkCertificateFast 10 2427 fastCert10_2427=true := by decide +kernel
def fastCert10_2428 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2428 : checkCertificateFast 10 2428 fastCert10_2428=true := by decide +kernel
def fastCert10_2429 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2429 : checkCertificateFast 10 2429 fastCert10_2429=true := by decide +kernel
def fastCert10_2430 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2430 : checkCertificateFast 10 2430 fastCert10_2430=true := by decide +kernel
def fastCert10_2431 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2431 : checkCertificateFast 10 2431 fastCert10_2431=true := by decide +kernel
def fastCert10_2432 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2432 : checkCertificateFast 10 2432 fastCert10_2432=true := by decide +kernel
def fastCert10_2433 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2433 : checkCertificateFast 10 2433 fastCert10_2433=true := by decide +kernel
def fastCert10_2434 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2434 : checkCertificateFast 10 2434 fastCert10_2434=true := by decide +kernel
def fastCert10_2435 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-4) else if t=0 ∧ i=7 then (6) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (4) else if t=0 ∧ i=14 then (-6) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2435 : checkCertificateFast 10 2435 fastCert10_2435=true := by decide +kernel
def fastCert10_2436 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2436 : checkCertificateFast 10 2436 fastCert10_2436=true := by decide +kernel
def fastCert10_2437 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-2) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (4) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2437 : checkCertificateFast 10 2437 fastCert10_2437=true := by decide +kernel
def fastCert10_2438 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2438 : checkCertificateFast 10 2438 fastCert10_2438=true := by decide +kernel
def fastCert10_2439 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2439 : checkCertificateFast 10 2439 fastCert10_2439=true := by decide +kernel
def fastCert10_2440 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2440 : checkCertificateFast 10 2440 fastCert10_2440=true := by decide +kernel
def fastCert10_2441 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2441 : checkCertificateFast 10 2441 fastCert10_2441=true := by decide +kernel
def fastCert10_2442 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2442 : checkCertificateFast 10 2442 fastCert10_2442=true := by decide +kernel
def fastCert10_2443 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2443 : checkCertificateFast 10 2443 fastCert10_2443=true := by decide +kernel
def fastCert10_2444 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2444 : checkCertificateFast 10 2444 fastCert10_2444=true := by decide +kernel
def fastCert10_2445 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2445 : checkCertificateFast 10 2445 fastCert10_2445=true := by decide +kernel
def fastCert10_2446 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2446 : checkCertificateFast 10 2446 fastCert10_2446=true := by decide +kernel
def fastCert10_2447 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2447 : checkCertificateFast 10 2447 fastCert10_2447=true := by decide +kernel
def fastCert10_2448 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2448 : checkCertificateFast 10 2448 fastCert10_2448=true := by decide +kernel
def fastCert10_2449 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2449 : checkCertificateFast 10 2449 fastCert10_2449=true := by decide +kernel
def fastCert10_2450 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2450 : checkCertificateFast 10 2450 fastCert10_2450=true := by decide +kernel
def fastCert10_2451 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (6) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (5) else if t=0 ∧ i=4 then (4) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-6) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (4) else if t=0 ∧ i=11 then (-4) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (6) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2451 : checkCertificateFast 10 2451 fastCert10_2451=true := by decide +kernel
def fastCert10_2452 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2452 : checkCertificateFast 10 2452 fastCert10_2452=true := by decide +kernel
def fastCert10_2453 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=13 then (-2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2453 : checkCertificateFast 10 2453 fastCert10_2453=true := by decide +kernel
def fastCert10_2454 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2454 : checkCertificateFast 10 2454 fastCert10_2454=true := by decide +kernel
def fastCert10_2455 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2455 : checkCertificateFast 10 2455 fastCert10_2455=true := by decide +kernel
def fastCert10_2456 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2456 : checkCertificateFast 10 2456 fastCert10_2456=true := by decide +kernel
def fastCert10_2457 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2457 : checkCertificateFast 10 2457 fastCert10_2457=true := by decide +kernel
def fastCert10_2458 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2458 : checkCertificateFast 10 2458 fastCert10_2458=true := by decide +kernel
def fastCert10_2459 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2459 : checkCertificateFast 10 2459 fastCert10_2459=true := by decide +kernel
def fastCert10_2460 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2460 : checkCertificateFast 10 2460 fastCert10_2460=true := by decide +kernel
def fastCert10_2461 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2461 : checkCertificateFast 10 2461 fastCert10_2461=true := by decide +kernel
def fastCert10_2462 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2462 : checkCertificateFast 10 2462 fastCert10_2462=true := by decide +kernel
def fastCert10_2463 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2463 : checkCertificateFast 10 2463 fastCert10_2463=true := by decide +kernel
def fastCert10_2464 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2464 : checkCertificateFast 10 2464 fastCert10_2464=true := by decide +kernel
def fastCert10_2465 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2465 : checkCertificateFast 10 2465 fastCert10_2465=true := by decide +kernel
def fastCert10_2466 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2466 : checkCertificateFast 10 2466 fastCert10_2466=true := by decide +kernel
def fastCert10_2467 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2467 : checkCertificateFast 10 2467 fastCert10_2467=true := by decide +kernel
def fastCert10_2468 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2468 : checkCertificateFast 10 2468 fastCert10_2468=true := by decide +kernel
def fastCert10_2469 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=1 then (-2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (-4) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2469 : checkCertificateFast 10 2469 fastCert10_2469=true := by decide +kernel
def fastCert10_2470 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2470 : checkCertificateFast 10 2470 fastCert10_2470=true := by decide +kernel
def fastCert10_2471 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2471 : checkCertificateFast 10 2471 fastCert10_2471=true := by decide +kernel
def fastCert10_2472 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2472 : checkCertificateFast 10 2472 fastCert10_2472=true := by decide +kernel
def fastCert10_2473 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2473 : checkCertificateFast 10 2473 fastCert10_2473=true := by decide +kernel
def fastCert10_2474 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2474 : checkCertificateFast 10 2474 fastCert10_2474=true := by decide +kernel
def fastCert10_2475 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=7 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-2) else 0⟩
theorem fastCase10_2475 : checkCertificateFast 10 2475 fastCert10_2475=true := by decide +kernel
def fastCert10_2476 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2476 : checkCertificateFast 10 2476 fastCert10_2476=true := by decide +kernel
def fastCert10_2477 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2477 : checkCertificateFast 10 2477 fastCert10_2477=true := by decide +kernel
def fastCert10_2478 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2478 : checkCertificateFast 10 2478 fastCert10_2478=true := by decide +kernel
def fastCert10_2479 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2479 : checkCertificateFast 10 2479 fastCert10_2479=true := by decide +kernel
def fastCert10_2480 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2480 : checkCertificateFast 10 2480 fastCert10_2480=true := by decide +kernel
def fastCert10_2481 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2481 : checkCertificateFast 10 2481 fastCert10_2481=true := by decide +kernel
def fastCert10_2482 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2482 : checkCertificateFast 10 2482 fastCert10_2482=true := by decide +kernel
def fastCert10_2483 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2483 : checkCertificateFast 10 2483 fastCert10_2483=true := by decide +kernel
def fastCert10_2484 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2484 : checkCertificateFast 10 2484 fastCert10_2484=true := by decide +kernel
def fastCert10_2485 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=13 then (2) else if t=0 ∧ i=15 then (2) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2485 : checkCertificateFast 10 2485 fastCert10_2485=true := by decide +kernel
def fastCert10_2486 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2486 : checkCertificateFast 10 2486 fastCert10_2486=true := by decide +kernel
def fastCert10_2487 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2487 : checkCertificateFast 10 2487 fastCert10_2487=true := by decide +kernel
def fastCert10_2488 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2488 : checkCertificateFast 10 2488 fastCert10_2488=true := by decide +kernel
def fastCert10_2489 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2489 : checkCertificateFast 10 2489 fastCert10_2489=true := by decide +kernel
def fastCert10_2490 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2490 : checkCertificateFast 10 2490 fastCert10_2490=true := by decide +kernel
def fastCert10_2491 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2491 : checkCertificateFast 10 2491 fastCert10_2491=true := by decide +kernel
def fastCert10_2492 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2492 : checkCertificateFast 10 2492 fastCert10_2492=true := by decide +kernel
def fastCert10_2493 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2493 : checkCertificateFast 10 2493 fastCert10_2493=true := by decide +kernel
def fastCert10_2494 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2494 : checkCertificateFast 10 2494 fastCert10_2494=true := by decide +kernel
def fastCert10_2495 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2495 : checkCertificateFast 10 2495 fastCert10_2495=true := by decide +kernel
def fastCert10_2496 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2496 : checkCertificateFast 10 2496 fastCert10_2496=true := by decide +kernel
def fastCert10_2497 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2497 : checkCertificateFast 10 2497 fastCert10_2497=true := by decide +kernel
def fastCert10_2498 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2498 : checkCertificateFast 10 2498 fastCert10_2498=true := by decide +kernel
def fastCert10_2499 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2499 : checkCertificateFast 10 2499 fastCert10_2499=true := by decide +kernel
def fastCert10_2500 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2500 : checkCertificateFast 10 2500 fastCert10_2500=true := by decide +kernel
def fastCert10_2501 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2501 : checkCertificateFast 10 2501 fastCert10_2501=true := by decide +kernel
def fastCert10_2502 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2502 : checkCertificateFast 10 2502 fastCert10_2502=true := by decide +kernel
def fastCert10_2503 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2503 : checkCertificateFast 10 2503 fastCert10_2503=true := by decide +kernel
def fastCert10_2504 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2504 : checkCertificateFast 10 2504 fastCert10_2504=true := by decide +kernel
def fastCert10_2505 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2505 : checkCertificateFast 10 2505 fastCert10_2505=true := by decide +kernel
def fastCert10_2506 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2506 : checkCertificateFast 10 2506 fastCert10_2506=true := by decide +kernel
def fastCert10_2507 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2507 : checkCertificateFast 10 2507 fastCert10_2507=true := by decide +kernel
def fastCert10_2508 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2508 : checkCertificateFast 10 2508 fastCert10_2508=true := by decide +kernel
def fastCert10_2509 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2509 : checkCertificateFast 10 2509 fastCert10_2509=true := by decide +kernel
def fastCert10_2510 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2510 : checkCertificateFast 10 2510 fastCert10_2510=true := by decide +kernel
def fastCert10_2511 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2511 : checkCertificateFast 10 2511 fastCert10_2511=true := by decide +kernel
def fastCert10_2512 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2512 : checkCertificateFast 10 2512 fastCert10_2512=true := by decide +kernel
def fastCert10_2513 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2513 : checkCertificateFast 10 2513 fastCert10_2513=true := by decide +kernel
def fastCert10_2514 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2514 : checkCertificateFast 10 2514 fastCert10_2514=true := by decide +kernel
def fastCert10_2515 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2515 : checkCertificateFast 10 2515 fastCert10_2515=true := by decide +kernel
def fastCert10_2516 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2516 : checkCertificateFast 10 2516 fastCert10_2516=true := by decide +kernel
def fastCert10_2517 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2517 : checkCertificateFast 10 2517 fastCert10_2517=true := by decide +kernel
def fastCert10_2518 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2518 : checkCertificateFast 10 2518 fastCert10_2518=true := by decide +kernel
def fastCert10_2519 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2519 : checkCertificateFast 10 2519 fastCert10_2519=true := by decide +kernel
def fastCert10_2520 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2520 : checkCertificateFast 10 2520 fastCert10_2520=true := by decide +kernel
def fastCert10_2521 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2521 : checkCertificateFast 10 2521 fastCert10_2521=true := by decide +kernel
def fastCert10_2522 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2522 : checkCertificateFast 10 2522 fastCert10_2522=true := by decide +kernel
def fastCert10_2523 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2523 : checkCertificateFast 10 2523 fastCert10_2523=true := by decide +kernel
def fastCert10_2524 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2524 : checkCertificateFast 10 2524 fastCert10_2524=true := by decide +kernel
def fastCert10_2525 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2525 : checkCertificateFast 10 2525 fastCert10_2525=true := by decide +kernel
def fastCert10_2526 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2526 : checkCertificateFast 10 2526 fastCert10_2526=true := by decide +kernel
def fastCert10_2527 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2527 : checkCertificateFast 10 2527 fastCert10_2527=true := by decide +kernel
def fastCert10_2528 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2528 : checkCertificateFast 10 2528 fastCert10_2528=true := by decide +kernel
def fastCert10_2529 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2529 : checkCertificateFast 10 2529 fastCert10_2529=true := by decide +kernel
def fastCert10_2530 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2530 : checkCertificateFast 10 2530 fastCert10_2530=true := by decide +kernel
def fastCert10_2531 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2531 : checkCertificateFast 10 2531 fastCert10_2531=true := by decide +kernel
def fastCert10_2532 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_2532 : checkCertificateFast 10 2532 fastCert10_2532=true := by decide +kernel
def fastCert10_2533 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2533 : checkCertificateFast 10 2533 fastCert10_2533=true := by decide +kernel
def fastCert10_2534 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2534 : checkCertificateFast 10 2534 fastCert10_2534=true := by decide +kernel
def fastCert10_2535 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2535 : checkCertificateFast 10 2535 fastCert10_2535=true := by decide +kernel
def fastCert10_2536 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2536 : checkCertificateFast 10 2536 fastCert10_2536=true := by decide +kernel
def fastCert10_2537 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2537 : checkCertificateFast 10 2537 fastCert10_2537=true := by decide +kernel
def fastCert10_2538 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2538 : checkCertificateFast 10 2538 fastCert10_2538=true := by decide +kernel
def fastCert10_2539 : Certificate := ⟨11,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2539 : checkCertificateFast 10 2539 fastCert10_2539=true := by decide +kernel
def fastCert10_2540 : Certificate := ⟨18,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2540 : checkCertificateFast 10 2540 fastCert10_2540=true := by decide +kernel
def fastCert10_2541 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2541 : checkCertificateFast 10 2541 fastCert10_2541=true := by decide +kernel
def fastCert10_2542 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2542 : checkCertificateFast 10 2542 fastCert10_2542=true := by decide +kernel
def fastCert10_2543 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2543 : checkCertificateFast 10 2543 fastCert10_2543=true := by decide +kernel
def fastCert10_2544 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2544 : checkCertificateFast 10 2544 fastCert10_2544=true := by decide +kernel
def fastCert10_2545 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2545 : checkCertificateFast 10 2545 fastCert10_2545=true := by decide +kernel
def fastCert10_2546 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2546 : checkCertificateFast 10 2546 fastCert10_2546=true := by decide +kernel
def fastCert10_2547 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2547 : checkCertificateFast 10 2547 fastCert10_2547=true := by decide +kernel
def fastCert10_2548 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2548 : checkCertificateFast 10 2548 fastCert10_2548=true := by decide +kernel
def fastCert10_2549 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2549 : checkCertificateFast 10 2549 fastCert10_2549=true := by decide +kernel
def fastCert10_2550 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2550 : checkCertificateFast 10 2550 fastCert10_2550=true := by decide +kernel
def fastCert10_2551 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2551 : checkCertificateFast 10 2551 fastCert10_2551=true := by decide +kernel
def fastCert10_2552 : Certificate := ⟨12,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2552 : checkCertificateFast 10 2552 fastCert10_2552=true := by decide +kernel
def fastCert10_2553 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2553 : checkCertificateFast 10 2553 fastCert10_2553=true := by decide +kernel
def fastCert10_2554 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2554 : checkCertificateFast 10 2554 fastCert10_2554=true := by decide +kernel
def fastCert10_2555 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2555 : checkCertificateFast 10 2555 fastCert10_2555=true := by decide +kernel
def fastCert10_2556 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2556 : checkCertificateFast 10 2556 fastCert10_2556=true := by decide +kernel
def fastCert10_2557 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2557 : checkCertificateFast 10 2557 fastCert10_2557=true := by decide +kernel
def fastCert10_2558 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2558 : checkCertificateFast 10 2558 fastCert10_2558=true := by decide +kernel
def fastCert10_2559 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2559 : checkCertificateFast 10 2559 fastCert10_2559=true := by decide +kernel
def fastCert10_2560 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2560 : checkCertificateFast 10 2560 fastCert10_2560=true := by decide +kernel
def fastCert10_2561 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2561 : checkCertificateFast 10 2561 fastCert10_2561=true := by decide +kernel
def fastCert10_2562 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2562 : checkCertificateFast 10 2562 fastCert10_2562=true := by decide +kernel
def fastCert10_2563 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2563 : checkCertificateFast 10 2563 fastCert10_2563=true := by decide +kernel
def fastCert10_2564 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2564 : checkCertificateFast 10 2564 fastCert10_2564=true := by decide +kernel
def fastCert10_2565 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2565 : checkCertificateFast 10 2565 fastCert10_2565=true := by decide +kernel
def fastCert10_2566 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2566 : checkCertificateFast 10 2566 fastCert10_2566=true := by decide +kernel
def fastCert10_2567 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2567 : checkCertificateFast 10 2567 fastCert10_2567=true := by decide +kernel
def fastCert10_2568 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2568 : checkCertificateFast 10 2568 fastCert10_2568=true := by decide +kernel
def fastCert10_2569 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2569 : checkCertificateFast 10 2569 fastCert10_2569=true := by decide +kernel
def fastCert10_2570 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2570 : checkCertificateFast 10 2570 fastCert10_2570=true := by decide +kernel
def fastCert10_2571 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2571 : checkCertificateFast 10 2571 fastCert10_2571=true := by decide +kernel
def fastCert10_2572 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2572 : checkCertificateFast 10 2572 fastCert10_2572=true := by decide +kernel
def fastCert10_2573 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2573 : checkCertificateFast 10 2573 fastCert10_2573=true := by decide +kernel
def fastCert10_2574 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2574 : checkCertificateFast 10 2574 fastCert10_2574=true := by decide +kernel
def fastCert10_2575 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2575 : checkCertificateFast 10 2575 fastCert10_2575=true := by decide +kernel
def fastCert10_2576 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2576 : checkCertificateFast 10 2576 fastCert10_2576=true := by decide +kernel
def fastCert10_2577 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2577 : checkCertificateFast 10 2577 fastCert10_2577=true := by decide +kernel
def fastCert10_2578 : Certificate := ⟨13,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2578 : checkCertificateFast 10 2578 fastCert10_2578=true := by decide +kernel
def fastCert10_2579 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2579 : checkCertificateFast 10 2579 fastCert10_2579=true := by decide +kernel
def fastCert10_2580 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2580 : checkCertificateFast 10 2580 fastCert10_2580=true := by decide +kernel
def fastCert10_2581 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2581 : checkCertificateFast 10 2581 fastCert10_2581=true := by decide +kernel
def fastCert10_2582 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2582 : checkCertificateFast 10 2582 fastCert10_2582=true := by decide +kernel
def fastCert10_2583 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2583 : checkCertificateFast 10 2583 fastCert10_2583=true := by decide +kernel
def fastCert10_2584 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2584 : checkCertificateFast 10 2584 fastCert10_2584=true := by decide +kernel
def fastCert10_2585 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2585 : checkCertificateFast 10 2585 fastCert10_2585=true := by decide +kernel
def fastCert10_2586 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2586 : checkCertificateFast 10 2586 fastCert10_2586=true := by decide +kernel
def fastCert10_2587 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2587 : checkCertificateFast 10 2587 fastCert10_2587=true := by decide +kernel
def fastCert10_2588 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2588 : checkCertificateFast 10 2588 fastCert10_2588=true := by decide +kernel
def fastCert10_2589 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2589 : checkCertificateFast 10 2589 fastCert10_2589=true := by decide +kernel
def fastCert10_2590 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2590 : checkCertificateFast 10 2590 fastCert10_2590=true := by decide +kernel
def fastCert10_2591 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2591 : checkCertificateFast 10 2591 fastCert10_2591=true := by decide +kernel
def fastCert10_2592 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2592 : checkCertificateFast 10 2592 fastCert10_2592=true := by decide +kernel
def fastCert10_2593 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2593 : checkCertificateFast 10 2593 fastCert10_2593=true := by decide +kernel
def fastCert10_2594 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2594 : checkCertificateFast 10 2594 fastCert10_2594=true := by decide +kernel
def fastCert10_2595 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2595 : checkCertificateFast 10 2595 fastCert10_2595=true := by decide +kernel
def fastCert10_2596 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else 0⟩
theorem fastCase10_2596 : checkCertificateFast 10 2596 fastCert10_2596=true := by decide +kernel
def fastCert10_2597 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2597 : checkCertificateFast 10 2597 fastCert10_2597=true := by decide +kernel
def fastCert10_2598 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2598 : checkCertificateFast 10 2598 fastCert10_2598=true := by decide +kernel
def fastCert10_2599 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2599 : checkCertificateFast 10 2599 fastCert10_2599=true := by decide +kernel
def fastCert10_2600 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2600 : checkCertificateFast 10 2600 fastCert10_2600=true := by decide +kernel
def fastCert10_2601 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2601 : checkCertificateFast 10 2601 fastCert10_2601=true := by decide +kernel
def fastCert10_2602 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2602 : checkCertificateFast 10 2602 fastCert10_2602=true := by decide +kernel
def fastCert10_2603 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2603 : checkCertificateFast 10 2603 fastCert10_2603=true := by decide +kernel
def fastCert10_2604 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2604 : checkCertificateFast 10 2604 fastCert10_2604=true := by decide +kernel
def fastCert10_2605 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2605 : checkCertificateFast 10 2605 fastCert10_2605=true := by decide +kernel
def fastCert10_2606 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2606 : checkCertificateFast 10 2606 fastCert10_2606=true := by decide +kernel
def fastCert10_2607 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2607 : checkCertificateFast 10 2607 fastCert10_2607=true := by decide +kernel
def fastCert10_2608 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2608 : checkCertificateFast 10 2608 fastCert10_2608=true := by decide +kernel
def fastCert10_2609 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2609 : checkCertificateFast 10 2609 fastCert10_2609=true := by decide +kernel
def fastCert10_2610 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2610 : checkCertificateFast 10 2610 fastCert10_2610=true := by decide +kernel
def fastCert10_2611 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2611 : checkCertificateFast 10 2611 fastCert10_2611=true := by decide +kernel
def fastCert10_2612 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2612 : checkCertificateFast 10 2612 fastCert10_2612=true := by decide +kernel
def fastCert10_2613 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2613 : checkCertificateFast 10 2613 fastCert10_2613=true := by decide +kernel
def fastCert10_2614 : Certificate := ⟨13,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2614 : checkCertificateFast 10 2614 fastCert10_2614=true := by decide +kernel
def fastCert10_2615 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2615 : checkCertificateFast 10 2615 fastCert10_2615=true := by decide +kernel
def fastCert10_2616 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2616 : checkCertificateFast 10 2616 fastCert10_2616=true := by decide +kernel
def fastCert10_2617 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2617 : checkCertificateFast 10 2617 fastCert10_2617=true := by decide +kernel
def fastCert10_2618 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2618 : checkCertificateFast 10 2618 fastCert10_2618=true := by decide +kernel
def fastCert10_2619 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2619 : checkCertificateFast 10 2619 fastCert10_2619=true := by decide +kernel
def fastCert10_2620 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2620 : checkCertificateFast 10 2620 fastCert10_2620=true := by decide +kernel
def fastCert10_2621 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2621 : checkCertificateFast 10 2621 fastCert10_2621=true := by decide +kernel
def fastCert10_2622 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2622 : checkCertificateFast 10 2622 fastCert10_2622=true := by decide +kernel
def fastCert10_2623 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2623 : checkCertificateFast 10 2623 fastCert10_2623=true := by decide +kernel
def fastCert10_2624 : Certificate := ⟨12,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2624 : checkCertificateFast 10 2624 fastCert10_2624=true := by decide +kernel
def fastCert10_2625 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2625 : checkCertificateFast 10 2625 fastCert10_2625=true := by decide +kernel
def fastCert10_2626 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2626 : checkCertificateFast 10 2626 fastCert10_2626=true := by decide +kernel
def fastCert10_2627 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2627 : checkCertificateFast 10 2627 fastCert10_2627=true := by decide +kernel
def fastCert10_2628 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2628 : checkCertificateFast 10 2628 fastCert10_2628=true := by decide +kernel
def fastCert10_2629 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2629 : checkCertificateFast 10 2629 fastCert10_2629=true := by decide +kernel
def fastCert10_2630 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2630 : checkCertificateFast 10 2630 fastCert10_2630=true := by decide +kernel
def fastCert10_2631 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2631 : checkCertificateFast 10 2631 fastCert10_2631=true := by decide +kernel
def fastCert10_2632 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2632 : checkCertificateFast 10 2632 fastCert10_2632=true := by decide +kernel
def fastCert10_2633 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2633 : checkCertificateFast 10 2633 fastCert10_2633=true := by decide +kernel
def fastCert10_2634 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2634 : checkCertificateFast 10 2634 fastCert10_2634=true := by decide +kernel
def fastCert10_2635 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2635 : checkCertificateFast 10 2635 fastCert10_2635=true := by decide +kernel
def fastCert10_2636 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2636 : checkCertificateFast 10 2636 fastCert10_2636=true := by decide +kernel
def fastCert10_2637 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2637 : checkCertificateFast 10 2637 fastCert10_2637=true := by decide +kernel
def fastCert10_2638 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2638 : checkCertificateFast 10 2638 fastCert10_2638=true := by decide +kernel
def fastCert10_2639 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2639 : checkCertificateFast 10 2639 fastCert10_2639=true := by decide +kernel
def fastCert10_2640 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2640 : checkCertificateFast 10 2640 fastCert10_2640=true := by decide +kernel
def fastCert10_2641 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2641 : checkCertificateFast 10 2641 fastCert10_2641=true := by decide +kernel
def fastCert10_2642 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2642 : checkCertificateFast 10 2642 fastCert10_2642=true := by decide +kernel
def fastCert10_2643 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2643 : checkCertificateFast 10 2643 fastCert10_2643=true := by decide +kernel
def fastCert10_2644 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2644 : checkCertificateFast 10 2644 fastCert10_2644=true := by decide +kernel
def fastCert10_2645 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2645 : checkCertificateFast 10 2645 fastCert10_2645=true := by decide +kernel
def fastCert10_2646 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2646 : checkCertificateFast 10 2646 fastCert10_2646=true := by decide +kernel
def fastCert10_2647 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2647 : checkCertificateFast 10 2647 fastCert10_2647=true := by decide +kernel
def fastCert10_2648 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2648 : checkCertificateFast 10 2648 fastCert10_2648=true := by decide +kernel
def fastCert10_2649 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2649 : checkCertificateFast 10 2649 fastCert10_2649=true := by decide +kernel
def fastCert10_2650 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2650 : checkCertificateFast 10 2650 fastCert10_2650=true := by decide +kernel
def fastCert10_2651 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2651 : checkCertificateFast 10 2651 fastCert10_2651=true := by decide +kernel
def fastCert10_2652 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2652 : checkCertificateFast 10 2652 fastCert10_2652=true := by decide +kernel
def fastCert10_2653 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2653 : checkCertificateFast 10 2653 fastCert10_2653=true := by decide +kernel
def fastCert10_2654 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2654 : checkCertificateFast 10 2654 fastCert10_2654=true := by decide +kernel
def fastCert10_2655 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2655 : checkCertificateFast 10 2655 fastCert10_2655=true := by decide +kernel
def fastCert10_2656 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2656 : checkCertificateFast 10 2656 fastCert10_2656=true := by decide +kernel
def fastCert10_2657 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2657 : checkCertificateFast 10 2657 fastCert10_2657=true := by decide +kernel
def fastCert10_2658 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2658 : checkCertificateFast 10 2658 fastCert10_2658=true := by decide +kernel
def fastCert10_2659 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2659 : checkCertificateFast 10 2659 fastCert10_2659=true := by decide +kernel
def fastCert10_2660 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2660 : checkCertificateFast 10 2660 fastCert10_2660=true := by decide +kernel
def fastCert10_2661 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2661 : checkCertificateFast 10 2661 fastCert10_2661=true := by decide +kernel
def fastCert10_2662 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2662 : checkCertificateFast 10 2662 fastCert10_2662=true := by decide +kernel
def fastCert10_2663 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2663 : checkCertificateFast 10 2663 fastCert10_2663=true := by decide +kernel
def fastCert10_2664 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2664 : checkCertificateFast 10 2664 fastCert10_2664=true := by decide +kernel
def fastCert10_2665 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2665 : checkCertificateFast 10 2665 fastCert10_2665=true := by decide +kernel
def fastCert10_2666 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2666 : checkCertificateFast 10 2666 fastCert10_2666=true := by decide +kernel
def fastCert10_2667 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2667 : checkCertificateFast 10 2667 fastCert10_2667=true := by decide +kernel
def fastCert10_2668 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2668 : checkCertificateFast 10 2668 fastCert10_2668=true := by decide +kernel
def fastCert10_2669 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2669 : checkCertificateFast 10 2669 fastCert10_2669=true := by decide +kernel
def fastCert10_2670 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2670 : checkCertificateFast 10 2670 fastCert10_2670=true := by decide +kernel
def fastCert10_2671 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2671 : checkCertificateFast 10 2671 fastCert10_2671=true := by decide +kernel
def fastCert10_2672 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2672 : checkCertificateFast 10 2672 fastCert10_2672=true := by decide +kernel
def fastCert10_2673 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2673 : checkCertificateFast 10 2673 fastCert10_2673=true := by decide +kernel
def fastCert10_2674 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2674 : checkCertificateFast 10 2674 fastCert10_2674=true := by decide +kernel
def fastCert10_2675 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2675 : checkCertificateFast 10 2675 fastCert10_2675=true := by decide +kernel
def fastCert10_2676 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2676 : checkCertificateFast 10 2676 fastCert10_2676=true := by decide +kernel
def fastCert10_2677 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2677 : checkCertificateFast 10 2677 fastCert10_2677=true := by decide +kernel
def fastCert10_2678 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2678 : checkCertificateFast 10 2678 fastCert10_2678=true := by decide +kernel
def fastCert10_2679 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2679 : checkCertificateFast 10 2679 fastCert10_2679=true := by decide +kernel
def fastCert10_2680 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2680 : checkCertificateFast 10 2680 fastCert10_2680=true := by decide +kernel
def fastCert10_2681 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2681 : checkCertificateFast 10 2681 fastCert10_2681=true := by decide +kernel
def fastCert10_2682 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2682 : checkCertificateFast 10 2682 fastCert10_2682=true := by decide +kernel
def fastCert10_2683 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (3) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2683 : checkCertificateFast 10 2683 fastCert10_2683=true := by decide +kernel
def fastCert10_2684 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2684 : checkCertificateFast 10 2684 fastCert10_2684=true := by decide +kernel
def fastCert10_2685 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2685 : checkCertificateFast 10 2685 fastCert10_2685=true := by decide +kernel
def fastCert10_2686 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2686 : checkCertificateFast 10 2686 fastCert10_2686=true := by decide +kernel
def fastCert10_2687 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2687 : checkCertificateFast 10 2687 fastCert10_2687=true := by decide +kernel
def fastCert10_2688 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2688 : checkCertificateFast 10 2688 fastCert10_2688=true := by decide +kernel
def fastCert10_2689 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2689 : checkCertificateFast 10 2689 fastCert10_2689=true := by decide +kernel
def fastCert10_2690 : Certificate := ⟨3,fun t i => if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2690 : checkCertificateFast 10 2690 fastCert10_2690=true := by decide +kernel
def fastCert10_2691 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2691 : checkCertificateFast 10 2691 fastCert10_2691=true := by decide +kernel
def fastCert10_2692 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2692 : checkCertificateFast 10 2692 fastCert10_2692=true := by decide +kernel
def fastCert10_2693 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2693 : checkCertificateFast 10 2693 fastCert10_2693=true := by decide +kernel
def fastCert10_2694 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2694 : checkCertificateFast 10 2694 fastCert10_2694=true := by decide +kernel
def fastCert10_2695 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2695 : checkCertificateFast 10 2695 fastCert10_2695=true := by decide +kernel
def fastCert10_2696 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2696 : checkCertificateFast 10 2696 fastCert10_2696=true := by decide +kernel
def fastCert10_2697 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2697 : checkCertificateFast 10 2697 fastCert10_2697=true := by decide +kernel
def fastCert10_2698 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2698 : checkCertificateFast 10 2698 fastCert10_2698=true := by decide +kernel
def fastCert10_2699 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2699 : checkCertificateFast 10 2699 fastCert10_2699=true := by decide +kernel
def fastCert10_2700 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2700 : checkCertificateFast 10 2700 fastCert10_2700=true := by decide +kernel
def fastCert10_2701 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2701 : checkCertificateFast 10 2701 fastCert10_2701=true := by decide +kernel
def fastCert10_2702 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2702 : checkCertificateFast 10 2702 fastCert10_2702=true := by decide +kernel
def fastCert10_2703 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2703 : checkCertificateFast 10 2703 fastCert10_2703=true := by decide +kernel
def fastCert10_2704 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2704 : checkCertificateFast 10 2704 fastCert10_2704=true := by decide +kernel
def fastCert10_2705 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2705 : checkCertificateFast 10 2705 fastCert10_2705=true := by decide +kernel
def fastCert10_2706 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2706 : checkCertificateFast 10 2706 fastCert10_2706=true := by decide +kernel
def fastCert10_2707 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2707 : checkCertificateFast 10 2707 fastCert10_2707=true := by decide +kernel
def fastCert10_2708 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2708 : checkCertificateFast 10 2708 fastCert10_2708=true := by decide +kernel
def fastCert10_2709 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2709 : checkCertificateFast 10 2709 fastCert10_2709=true := by decide +kernel
def fastCert10_2710 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2710 : checkCertificateFast 10 2710 fastCert10_2710=true := by decide +kernel
def fastCert10_2711 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2711 : checkCertificateFast 10 2711 fastCert10_2711=true := by decide +kernel
def fastCert10_2712 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2712 : checkCertificateFast 10 2712 fastCert10_2712=true := by decide +kernel
def fastCert10_2713 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2713 : checkCertificateFast 10 2713 fastCert10_2713=true := by decide +kernel
def fastCert10_2714 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2714 : checkCertificateFast 10 2714 fastCert10_2714=true := by decide +kernel
def fastCert10_2715 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2715 : checkCertificateFast 10 2715 fastCert10_2715=true := by decide +kernel
def fastCert10_2716 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-3) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2716 : checkCertificateFast 10 2716 fastCert10_2716=true := by decide +kernel
def fastCert10_2717 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2717 : checkCertificateFast 10 2717 fastCert10_2717=true := by decide +kernel
def fastCert10_2718 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2718 : checkCertificateFast 10 2718 fastCert10_2718=true := by decide +kernel
def fastCert10_2719 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2719 : checkCertificateFast 10 2719 fastCert10_2719=true := by decide +kernel
def fastCert10_2720 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2720 : checkCertificateFast 10 2720 fastCert10_2720=true := by decide +kernel
def fastCert10_2721 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2721 : checkCertificateFast 10 2721 fastCert10_2721=true := by decide +kernel
def fastCert10_2722 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2722 : checkCertificateFast 10 2722 fastCert10_2722=true := by decide +kernel
def fastCert10_2723 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2723 : checkCertificateFast 10 2723 fastCert10_2723=true := by decide +kernel
def fastCert10_2724 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2724 : checkCertificateFast 10 2724 fastCert10_2724=true := by decide +kernel
def fastCert10_2725 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2725 : checkCertificateFast 10 2725 fastCert10_2725=true := by decide +kernel
def fastCert10_2726 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2726 : checkCertificateFast 10 2726 fastCert10_2726=true := by decide +kernel
def fastCert10_2727 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2727 : checkCertificateFast 10 2727 fastCert10_2727=true := by decide +kernel
def fastCert10_2728 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2728 : checkCertificateFast 10 2728 fastCert10_2728=true := by decide +kernel
def fastCert10_2729 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2729 : checkCertificateFast 10 2729 fastCert10_2729=true := by decide +kernel
def fastCert10_2730 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2730 : checkCertificateFast 10 2730 fastCert10_2730=true := by decide +kernel
def fastCert10_2731 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2731 : checkCertificateFast 10 2731 fastCert10_2731=true := by decide +kernel
def fastCert10_2732 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2732 : checkCertificateFast 10 2732 fastCert10_2732=true := by decide +kernel
def fastCert10_2733 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2733 : checkCertificateFast 10 2733 fastCert10_2733=true := by decide +kernel
def fastCert10_2734 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2734 : checkCertificateFast 10 2734 fastCert10_2734=true := by decide +kernel
def fastCert10_2735 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2735 : checkCertificateFast 10 2735 fastCert10_2735=true := by decide +kernel
def fastCert10_2736 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2736 : checkCertificateFast 10 2736 fastCert10_2736=true := by decide +kernel
def fastCert10_2737 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2737 : checkCertificateFast 10 2737 fastCert10_2737=true := by decide +kernel
def fastCert10_2738 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2738 : checkCertificateFast 10 2738 fastCert10_2738=true := by decide +kernel
def fastCert10_2739 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2739 : checkCertificateFast 10 2739 fastCert10_2739=true := by decide +kernel
def fastCert10_2740 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2740 : checkCertificateFast 10 2740 fastCert10_2740=true := by decide +kernel
def fastCert10_2741 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2741 : checkCertificateFast 10 2741 fastCert10_2741=true := by decide +kernel
def fastCert10_2742 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2742 : checkCertificateFast 10 2742 fastCert10_2742=true := by decide +kernel
def fastCert10_2743 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2743 : checkCertificateFast 10 2743 fastCert10_2743=true := by decide +kernel
def fastCert10_2744 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2744 : checkCertificateFast 10 2744 fastCert10_2744=true := by decide +kernel
def fastCert10_2745 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2745 : checkCertificateFast 10 2745 fastCert10_2745=true := by decide +kernel
def fastCert10_2746 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (3) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-2) else if t=0 ∧ i=12 then (-2) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2746 : checkCertificateFast 10 2746 fastCert10_2746=true := by decide +kernel
def fastCert10_2747 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2747 : checkCertificateFast 10 2747 fastCert10_2747=true := by decide +kernel
def fastCert10_2748 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2748 : checkCertificateFast 10 2748 fastCert10_2748=true := by decide +kernel
def fastCert10_2749 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2749 : checkCertificateFast 10 2749 fastCert10_2749=true := by decide +kernel
def fastCert10_2750 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2750 : checkCertificateFast 10 2750 fastCert10_2750=true := by decide +kernel
def fastCert10_2751 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2751 : checkCertificateFast 10 2751 fastCert10_2751=true := by decide +kernel
def fastCert10_2752 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2752 : checkCertificateFast 10 2752 fastCert10_2752=true := by decide +kernel
def fastCert10_2753 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2753 : checkCertificateFast 10 2753 fastCert10_2753=true := by decide +kernel
def fastCert10_2754 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2754 : checkCertificateFast 10 2754 fastCert10_2754=true := by decide +kernel
def fastCert10_2755 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2755 : checkCertificateFast 10 2755 fastCert10_2755=true := by decide +kernel
def fastCert10_2756 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2756 : checkCertificateFast 10 2756 fastCert10_2756=true := by decide +kernel
def fastCert10_2757 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2757 : checkCertificateFast 10 2757 fastCert10_2757=true := by decide +kernel
def fastCert10_2758 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2758 : checkCertificateFast 10 2758 fastCert10_2758=true := by decide +kernel
def fastCert10_2759 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2759 : checkCertificateFast 10 2759 fastCert10_2759=true := by decide +kernel
def fastCert10_2760 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2760 : checkCertificateFast 10 2760 fastCert10_2760=true := by decide +kernel
def fastCert10_2761 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2761 : checkCertificateFast 10 2761 fastCert10_2761=true := by decide +kernel
def fastCert10_2762 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2762 : checkCertificateFast 10 2762 fastCert10_2762=true := by decide +kernel
def fastCert10_2763 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2763 : checkCertificateFast 10 2763 fastCert10_2763=true := by decide +kernel
def fastCert10_2764 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2764 : checkCertificateFast 10 2764 fastCert10_2764=true := by decide +kernel
def fastCert10_2765 : Certificate := ⟨11,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2765 : checkCertificateFast 10 2765 fastCert10_2765=true := by decide +kernel
def fastCert10_2766 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2766 : checkCertificateFast 10 2766 fastCert10_2766=true := by decide +kernel
def fastCert10_2767 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2767 : checkCertificateFast 10 2767 fastCert10_2767=true := by decide +kernel
def fastCert10_2768 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2768 : checkCertificateFast 10 2768 fastCert10_2768=true := by decide +kernel
def fastCert10_2769 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2769 : checkCertificateFast 10 2769 fastCert10_2769=true := by decide +kernel
def fastCert10_2770 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2770 : checkCertificateFast 10 2770 fastCert10_2770=true := by decide +kernel
def fastCert10_2771 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2771 : checkCertificateFast 10 2771 fastCert10_2771=true := by decide +kernel
def fastCert10_2772 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2772 : checkCertificateFast 10 2772 fastCert10_2772=true := by decide +kernel
def fastCert10_2773 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2773 : checkCertificateFast 10 2773 fastCert10_2773=true := by decide +kernel
def fastCert10_2774 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2774 : checkCertificateFast 10 2774 fastCert10_2774=true := by decide +kernel
def fastCert10_2775 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2775 : checkCertificateFast 10 2775 fastCert10_2775=true := by decide +kernel
def fastCert10_2776 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2776 : checkCertificateFast 10 2776 fastCert10_2776=true := by decide +kernel
def fastCert10_2777 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2777 : checkCertificateFast 10 2777 fastCert10_2777=true := by decide +kernel
def fastCert10_2778 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2778 : checkCertificateFast 10 2778 fastCert10_2778=true := by decide +kernel
def fastCert10_2779 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2779 : checkCertificateFast 10 2779 fastCert10_2779=true := by decide +kernel
def fastCert10_2780 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2780 : checkCertificateFast 10 2780 fastCert10_2780=true := by decide +kernel
def fastCert10_2781 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2781 : checkCertificateFast 10 2781 fastCert10_2781=true := by decide +kernel
def fastCert10_2782 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2782 : checkCertificateFast 10 2782 fastCert10_2782=true := by decide +kernel
def fastCert10_2783 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2783 : checkCertificateFast 10 2783 fastCert10_2783=true := by decide +kernel
def fastCert10_2784 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2784 : checkCertificateFast 10 2784 fastCert10_2784=true := by decide +kernel
def fastCert10_2785 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2785 : checkCertificateFast 10 2785 fastCert10_2785=true := by decide +kernel
def fastCert10_2786 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2786 : checkCertificateFast 10 2786 fastCert10_2786=true := by decide +kernel
def fastCert10_2787 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2787 : checkCertificateFast 10 2787 fastCert10_2787=true := by decide +kernel
def fastCert10_2788 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2788 : checkCertificateFast 10 2788 fastCert10_2788=true := by decide +kernel
def fastCert10_2789 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2789 : checkCertificateFast 10 2789 fastCert10_2789=true := by decide +kernel
def fastCert10_2790 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2790 : checkCertificateFast 10 2790 fastCert10_2790=true := by decide +kernel
def fastCert10_2791 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2791 : checkCertificateFast 10 2791 fastCert10_2791=true := by decide +kernel
def fastCert10_2792 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2792 : checkCertificateFast 10 2792 fastCert10_2792=true := by decide +kernel
def fastCert10_2793 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2793 : checkCertificateFast 10 2793 fastCert10_2793=true := by decide +kernel
def fastCert10_2794 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (3) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (3) else if t=0 ∧ i=10 then (2) else if t=0 ∧ i=11 then (2) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-3) else 0⟩
theorem fastCase10_2794 : checkCertificateFast 10 2794 fastCert10_2794=true := by decide +kernel
def fastCert10_2795 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2795 : checkCertificateFast 10 2795 fastCert10_2795=true := by decide +kernel
def fastCert10_2796 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2796 : checkCertificateFast 10 2796 fastCert10_2796=true := by decide +kernel
def fastCert10_2797 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2797 : checkCertificateFast 10 2797 fastCert10_2797=true := by decide +kernel
def fastCert10_2798 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2798 : checkCertificateFast 10 2798 fastCert10_2798=true := by decide +kernel
def fastCert10_2799 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2799 : checkCertificateFast 10 2799 fastCert10_2799=true := by decide +kernel
def fastCert10_2800 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2800 : checkCertificateFast 10 2800 fastCert10_2800=true := by decide +kernel
def fastCert10_2801 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2801 : checkCertificateFast 10 2801 fastCert10_2801=true := by decide +kernel
def fastCert10_2802 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2802 : checkCertificateFast 10 2802 fastCert10_2802=true := by decide +kernel
def fastCert10_2803 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2803 : checkCertificateFast 10 2803 fastCert10_2803=true := by decide +kernel
def fastCert10_2804 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2804 : checkCertificateFast 10 2804 fastCert10_2804=true := by decide +kernel
def fastCert10_2805 : Certificate := ⟨12,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2805 : checkCertificateFast 10 2805 fastCert10_2805=true := by decide +kernel
def fastCert10_2806 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2806 : checkCertificateFast 10 2806 fastCert10_2806=true := by decide +kernel
def fastCert10_2807 : Certificate := ⟨12,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2807 : checkCertificateFast 10 2807 fastCert10_2807=true := by decide +kernel
def fastCert10_2808 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2808 : checkCertificateFast 10 2808 fastCert10_2808=true := by decide +kernel
def fastCert10_2809 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2809 : checkCertificateFast 10 2809 fastCert10_2809=true := by decide +kernel
def fastCert10_2810 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2810 : checkCertificateFast 10 2810 fastCert10_2810=true := by decide +kernel
def fastCert10_2811 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2811 : checkCertificateFast 10 2811 fastCert10_2811=true := by decide +kernel
def fastCert10_2812 : Certificate := ⟨11,fun t i => if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2812 : checkCertificateFast 10 2812 fastCert10_2812=true := by decide +kernel
def fastCert10_2813 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2813 : checkCertificateFast 10 2813 fastCert10_2813=true := by decide +kernel
def fastCert10_2814 : Certificate := ⟨11,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2814 : checkCertificateFast 10 2814 fastCert10_2814=true := by decide +kernel
def fastCert10_2815 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2815 : checkCertificateFast 10 2815 fastCert10_2815=true := by decide +kernel
def fastCert10_2816 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-2) else 0⟩
theorem fastCase10_2816 : checkCertificateFast 10 2816 fastCert10_2816=true := by decide +kernel
def fastCert10_2817 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2817 : checkCertificateFast 10 2817 fastCert10_2817=true := by decide +kernel
def fastCert10_2818 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2818 : checkCertificateFast 10 2818 fastCert10_2818=true := by decide +kernel
def fastCert10_2819 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2819 : checkCertificateFast 10 2819 fastCert10_2819=true := by decide +kernel
def fastCert10_2820 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2820 : checkCertificateFast 10 2820 fastCert10_2820=true := by decide +kernel
def fastCert10_2821 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2821 : checkCertificateFast 10 2821 fastCert10_2821=true := by decide +kernel
def fastCert10_2822 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2822 : checkCertificateFast 10 2822 fastCert10_2822=true := by decide +kernel
def fastCert10_2823 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2823 : checkCertificateFast 10 2823 fastCert10_2823=true := by decide +kernel
def fastCert10_2824 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2824 : checkCertificateFast 10 2824 fastCert10_2824=true := by decide +kernel
def fastCert10_2825 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2825 : checkCertificateFast 10 2825 fastCert10_2825=true := by decide +kernel
def fastCert10_2826 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2826 : checkCertificateFast 10 2826 fastCert10_2826=true := by decide +kernel
def fastCert10_2827 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (2) else if t=0 ∧ i=4 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2827 : checkCertificateFast 10 2827 fastCert10_2827=true := by decide +kernel
def fastCert10_2828 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2828 : checkCertificateFast 10 2828 fastCert10_2828=true := by decide +kernel
def fastCert10_2829 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2829 : checkCertificateFast 10 2829 fastCert10_2829=true := by decide +kernel
def fastCert10_2830 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2830 : checkCertificateFast 10 2830 fastCert10_2830=true := by decide +kernel
def fastCert10_2831 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2831 : checkCertificateFast 10 2831 fastCert10_2831=true := by decide +kernel
def fastCert10_2832 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2832 : checkCertificateFast 10 2832 fastCert10_2832=true := by decide +kernel
def fastCert10_2833 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2833 : checkCertificateFast 10 2833 fastCert10_2833=true := by decide +kernel
def fastCert10_2834 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (2) else 0⟩
theorem fastCase10_2834 : checkCertificateFast 10 2834 fastCert10_2834=true := by decide +kernel
def fastCert10_2835 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=9 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (2) else 0⟩
theorem fastCase10_2835 : checkCertificateFast 10 2835 fastCert10_2835=true := by decide +kernel
def fastCert10_2836 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2836 : checkCertificateFast 10 2836 fastCert10_2836=true := by decide +kernel
def fastCert10_2837 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2837 : checkCertificateFast 10 2837 fastCert10_2837=true := by decide +kernel
def fastCert10_2838 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2838 : checkCertificateFast 10 2838 fastCert10_2838=true := by decide +kernel
def fastCert10_2839 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2839 : checkCertificateFast 10 2839 fastCert10_2839=true := by decide +kernel
def fastCert10_2840 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2840 : checkCertificateFast 10 2840 fastCert10_2840=true := by decide +kernel
def fastCert10_2841 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2841 : checkCertificateFast 10 2841 fastCert10_2841=true := by decide +kernel
def fastCert10_2842 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2842 : checkCertificateFast 10 2842 fastCert10_2842=true := by decide +kernel
def fastCert10_2843 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=3 then (-2) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (-1) else 0⟩
theorem fastCase10_2843 : checkCertificateFast 10 2843 fastCert10_2843=true := by decide +kernel
def fastCert10_2844 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2844 : checkCertificateFast 10 2844 fastCert10_2844=true := by decide +kernel
def fastCert10_2845 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2845 : checkCertificateFast 10 2845 fastCert10_2845=true := by decide +kernel
def fastCert10_2846 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2846 : checkCertificateFast 10 2846 fastCert10_2846=true := by decide +kernel
def fastCert10_2847 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2847 : checkCertificateFast 10 2847 fastCert10_2847=true := by decide +kernel
def fastCert10_2848 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2848 : checkCertificateFast 10 2848 fastCert10_2848=true := by decide +kernel
def fastCert10_2849 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2849 : checkCertificateFast 10 2849 fastCert10_2849=true := by decide +kernel
def fastCert10_2850 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2850 : checkCertificateFast 10 2850 fastCert10_2850=true := by decide +kernel
def fastCert10_2851 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2851 : checkCertificateFast 10 2851 fastCert10_2851=true := by decide +kernel
def fastCert10_2852 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2852 : checkCertificateFast 10 2852 fastCert10_2852=true := by decide +kernel
def fastCert10_2853 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2853 : checkCertificateFast 10 2853 fastCert10_2853=true := by decide +kernel
def fastCert10_2854 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2854 : checkCertificateFast 10 2854 fastCert10_2854=true := by decide +kernel
def fastCert10_2855 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2855 : checkCertificateFast 10 2855 fastCert10_2855=true := by decide +kernel
def fastCert10_2856 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2856 : checkCertificateFast 10 2856 fastCert10_2856=true := by decide +kernel
def fastCert10_2857 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2857 : checkCertificateFast 10 2857 fastCert10_2857=true := by decide +kernel
def fastCert10_2858 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2858 : checkCertificateFast 10 2858 fastCert10_2858=true := by decide +kernel
def fastCert10_2859 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2859 : checkCertificateFast 10 2859 fastCert10_2859=true := by decide +kernel
def fastCert10_2860 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2860 : checkCertificateFast 10 2860 fastCert10_2860=true := by decide +kernel
def fastCert10_2861 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2861 : checkCertificateFast 10 2861 fastCert10_2861=true := by decide +kernel
def fastCert10_2862 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2862 : checkCertificateFast 10 2862 fastCert10_2862=true := by decide +kernel
def fastCert10_2863 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2863 : checkCertificateFast 10 2863 fastCert10_2863=true := by decide +kernel
def fastCert10_2864 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=8 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=15 then (2) else 0⟩
theorem fastCase10_2864 : checkCertificateFast 10 2864 fastCert10_2864=true := by decide +kernel
def fastCert10_2865 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=9 then (2) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=16 then (-2) else 0⟩
theorem fastCase10_2865 : checkCertificateFast 10 2865 fastCert10_2865=true := by decide +kernel
def fastCert10_2866 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2866 : checkCertificateFast 10 2866 fastCert10_2866=true := by decide +kernel
def fastCert10_2867 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2867 : checkCertificateFast 10 2867 fastCert10_2867=true := by decide +kernel
def fastCert10_2868 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2868 : checkCertificateFast 10 2868 fastCert10_2868=true := by decide +kernel
def fastCert10_2869 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2869 : checkCertificateFast 10 2869 fastCert10_2869=true := by decide +kernel
def fastCert10_2870 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2870 : checkCertificateFast 10 2870 fastCert10_2870=true := by decide +kernel
def fastCert10_2871 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2871 : checkCertificateFast 10 2871 fastCert10_2871=true := by decide +kernel
def fastCert10_2872 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-2) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (2) else if t=0 ∧ i=9 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=12 then (2) else if t=0 ∧ i=15 then (-2) else if t=0 ∧ i=16 then (-1) else 0⟩
theorem fastCase10_2872 : checkCertificateFast 10 2872 fastCert10_2872=true := by decide +kernel
def fastCert10_2873 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2873 : checkCertificateFast 10 2873 fastCert10_2873=true := by decide +kernel
def fastCert10_2874 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2874 : checkCertificateFast 10 2874 fastCert10_2874=true := by decide +kernel
def fastCert10_2875 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=7 then (-2) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (2) else 0⟩
theorem fastCase10_2875 : checkCertificateFast 10 2875 fastCert10_2875=true := by decide +kernel
def fastCert10_2876 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2876 : checkCertificateFast 10 2876 fastCert10_2876=true := by decide +kernel
def fastCert10_2877 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2877 : checkCertificateFast 10 2877 fastCert10_2877=true := by decide +kernel
def fastCert10_2878 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2878 : checkCertificateFast 10 2878 fastCert10_2878=true := by decide +kernel
def fastCert10_2879 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2879 : checkCertificateFast 10 2879 fastCert10_2879=true := by decide +kernel
def fastCert10_2880 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2880 : checkCertificateFast 10 2880 fastCert10_2880=true := by decide +kernel
def fastCert10_2881 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2881 : checkCertificateFast 10 2881 fastCert10_2881=true := by decide +kernel
def fastCert10_2882 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2882 : checkCertificateFast 10 2882 fastCert10_2882=true := by decide +kernel
def fastCert10_2883 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2883 : checkCertificateFast 10 2883 fastCert10_2883=true := by decide +kernel
def fastCert10_2884 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2884 : checkCertificateFast 10 2884 fastCert10_2884=true := by decide +kernel
def fastCert10_2885 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2885 : checkCertificateFast 10 2885 fastCert10_2885=true := by decide +kernel
def fastCert10_2886 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2886 : checkCertificateFast 10 2886 fastCert10_2886=true := by decide +kernel
def fastCert10_2887 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2887 : checkCertificateFast 10 2887 fastCert10_2887=true := by decide +kernel
def fastCert10_2888 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2888 : checkCertificateFast 10 2888 fastCert10_2888=true := by decide +kernel
def fastCert10_2889 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2889 : checkCertificateFast 10 2889 fastCert10_2889=true := by decide +kernel
def fastCert10_2890 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2890 : checkCertificateFast 10 2890 fastCert10_2890=true := by decide +kernel
def fastCert10_2891 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2891 : checkCertificateFast 10 2891 fastCert10_2891=true := by decide +kernel
def fastCert10_2892 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2892 : checkCertificateFast 10 2892 fastCert10_2892=true := by decide +kernel
def fastCert10_2893 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2893 : checkCertificateFast 10 2893 fastCert10_2893=true := by decide +kernel
def fastCert10_2894 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2894 : checkCertificateFast 10 2894 fastCert10_2894=true := by decide +kernel
def fastCert10_2895 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2895 : checkCertificateFast 10 2895 fastCert10_2895=true := by decide +kernel
def fastCert10_2896 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2896 : checkCertificateFast 10 2896 fastCert10_2896=true := by decide +kernel
def fastCert10_2897 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2897 : checkCertificateFast 10 2897 fastCert10_2897=true := by decide +kernel
def fastCert10_2898 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2898 : checkCertificateFast 10 2898 fastCert10_2898=true := by decide +kernel
def fastCert10_2899 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2899 : checkCertificateFast 10 2899 fastCert10_2899=true := by decide +kernel
def fastCert10_2900 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2900 : checkCertificateFast 10 2900 fastCert10_2900=true := by decide +kernel
def fastCert10_2901 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2901 : checkCertificateFast 10 2901 fastCert10_2901=true := by decide +kernel
def fastCert10_2902 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2902 : checkCertificateFast 10 2902 fastCert10_2902=true := by decide +kernel
def fastCert10_2903 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2903 : checkCertificateFast 10 2903 fastCert10_2903=true := by decide +kernel
def fastCert10_2904 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2904 : checkCertificateFast 10 2904 fastCert10_2904=true := by decide +kernel
def fastCert10_2905 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2905 : checkCertificateFast 10 2905 fastCert10_2905=true := by decide +kernel
def fastCert10_2906 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2906 : checkCertificateFast 10 2906 fastCert10_2906=true := by decide +kernel
def fastCert10_2907 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2907 : checkCertificateFast 10 2907 fastCert10_2907=true := by decide +kernel
def fastCert10_2908 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2908 : checkCertificateFast 10 2908 fastCert10_2908=true := by decide +kernel
def fastCert10_2909 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2909 : checkCertificateFast 10 2909 fastCert10_2909=true := by decide +kernel
def fastCert10_2910 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2910 : checkCertificateFast 10 2910 fastCert10_2910=true := by decide +kernel
def fastCert10_2911 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2911 : checkCertificateFast 10 2911 fastCert10_2911=true := by decide +kernel
def fastCert10_2912 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2912 : checkCertificateFast 10 2912 fastCert10_2912=true := by decide +kernel
def fastCert10_2913 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2913 : checkCertificateFast 10 2913 fastCert10_2913=true := by decide +kernel
def fastCert10_2914 : Certificate := ⟨6,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2914 : checkCertificateFast 10 2914 fastCert10_2914=true := by decide +kernel
def fastCert10_2915 : Certificate := ⟨14,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (2) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2915 : checkCertificateFast 10 2915 fastCert10_2915=true := by decide +kernel
def fastCert10_2916 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2916 : checkCertificateFast 10 2916 fastCert10_2916=true := by decide +kernel
def fastCert10_2917 : Certificate := ⟨22,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=10 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else 0⟩
theorem fastCase10_2917 : checkCertificateFast 10 2917 fastCert10_2917=true := by decide +kernel
def fastCert10_2918 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2918 : checkCertificateFast 10 2918 fastCert10_2918=true := by decide +kernel
def fastCert10_2919 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2919 : checkCertificateFast 10 2919 fastCert10_2919=true := by decide +kernel
def fastCert10_2920 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2920 : checkCertificateFast 10 2920 fastCert10_2920=true := by decide +kernel
def fastCert10_2921 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2921 : checkCertificateFast 10 2921 fastCert10_2921=true := by decide +kernel
def fastCert10_2922 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2922 : checkCertificateFast 10 2922 fastCert10_2922=true := by decide +kernel
def fastCert10_2923 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2923 : checkCertificateFast 10 2923 fastCert10_2923=true := by decide +kernel
def fastCert10_2924 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2924 : checkCertificateFast 10 2924 fastCert10_2924=true := by decide +kernel
def fastCert10_2925 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2925 : checkCertificateFast 10 2925 fastCert10_2925=true := by decide +kernel
def fastCert10_2926 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2926 : checkCertificateFast 10 2926 fastCert10_2926=true := by decide +kernel
def fastCert10_2927 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2927 : checkCertificateFast 10 2927 fastCert10_2927=true := by decide +kernel
def fastCert10_2928 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2928 : checkCertificateFast 10 2928 fastCert10_2928=true := by decide +kernel
def fastCert10_2929 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2929 : checkCertificateFast 10 2929 fastCert10_2929=true := by decide +kernel
def fastCert10_2930 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2930 : checkCertificateFast 10 2930 fastCert10_2930=true := by decide +kernel
def fastCert10_2931 : Certificate := ⟨3,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2931 : checkCertificateFast 10 2931 fastCert10_2931=true := by decide +kernel
def fastCert10_2932 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2932 : checkCertificateFast 10 2932 fastCert10_2932=true := by decide +kernel
def fastCert10_2933 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2933 : checkCertificateFast 10 2933 fastCert10_2933=true := by decide +kernel
def fastCert10_2934 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2934 : checkCertificateFast 10 2934 fastCert10_2934=true := by decide +kernel
def fastCert10_2935 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2935 : checkCertificateFast 10 2935 fastCert10_2935=true := by decide +kernel
def fastCert10_2936 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2936 : checkCertificateFast 10 2936 fastCert10_2936=true := by decide +kernel
def fastCert10_2937 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2937 : checkCertificateFast 10 2937 fastCert10_2937=true := by decide +kernel
def fastCert10_2938 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2938 : checkCertificateFast 10 2938 fastCert10_2938=true := by decide +kernel
def fastCert10_2939 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2939 : checkCertificateFast 10 2939 fastCert10_2939=true := by decide +kernel
def fastCert10_2940 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2940 : checkCertificateFast 10 2940 fastCert10_2940=true := by decide +kernel
def fastCert10_2941 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2941 : checkCertificateFast 10 2941 fastCert10_2941=true := by decide +kernel
def fastCert10_2942 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2942 : checkCertificateFast 10 2942 fastCert10_2942=true := by decide +kernel
def fastCert10_2943 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2943 : checkCertificateFast 10 2943 fastCert10_2943=true := by decide +kernel
def fastCert10_2944 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2944 : checkCertificateFast 10 2944 fastCert10_2944=true := by decide +kernel
def fastCert10_2945 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2945 : checkCertificateFast 10 2945 fastCert10_2945=true := by decide +kernel
def fastCert10_2946 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2946 : checkCertificateFast 10 2946 fastCert10_2946=true := by decide +kernel
def fastCert10_2947 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2947 : checkCertificateFast 10 2947 fastCert10_2947=true := by decide +kernel
def fastCert10_2948 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2948 : checkCertificateFast 10 2948 fastCert10_2948=true := by decide +kernel
def fastCert10_2949 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2949 : checkCertificateFast 10 2949 fastCert10_2949=true := by decide +kernel
def fastCert10_2950 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (2) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2950 : checkCertificateFast 10 2950 fastCert10_2950=true := by decide +kernel
def fastCert10_2951 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (-1) else if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else 0⟩
theorem fastCase10_2951 : checkCertificateFast 10 2951 fastCert10_2951=true := by decide +kernel
def fastCert10_2952 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2952 : checkCertificateFast 10 2952 fastCert10_2952=true := by decide +kernel
def fastCert10_2953 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2953 : checkCertificateFast 10 2953 fastCert10_2953=true := by decide +kernel
def fastCert10_2954 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2954 : checkCertificateFast 10 2954 fastCert10_2954=true := by decide +kernel
def fastCert10_2955 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2955 : checkCertificateFast 10 2955 fastCert10_2955=true := by decide +kernel
def fastCert10_2956 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2956 : checkCertificateFast 10 2956 fastCert10_2956=true := by decide +kernel
def fastCert10_2957 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2957 : checkCertificateFast 10 2957 fastCert10_2957=true := by decide +kernel
def fastCert10_2958 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2958 : checkCertificateFast 10 2958 fastCert10_2958=true := by decide +kernel
def fastCert10_2959 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2959 : checkCertificateFast 10 2959 fastCert10_2959=true := by decide +kernel
def fastCert10_2960 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2960 : checkCertificateFast 10 2960 fastCert10_2960=true := by decide +kernel
def fastCert10_2961 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2961 : checkCertificateFast 10 2961 fastCert10_2961=true := by decide +kernel
def fastCert10_2962 : Certificate := ⟨11,fun t i => if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2962 : checkCertificateFast 10 2962 fastCert10_2962=true := by decide +kernel
def fastCert10_2963 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=10 then (-1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (-2) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2963 : checkCertificateFast 10 2963 fastCert10_2963=true := by decide +kernel
def fastCert10_2964 : Certificate := ⟨3,fun t i => if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else if t=0 ∧ i=14 then (-1) else if t=0 ∧ i=15 then (1) else 0⟩
theorem fastCase10_2964 : checkCertificateFast 10 2964 fastCert10_2964=true := by decide +kernel
def fastCert10_2965 : Certificate := ⟨3,fun t i => if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2965 : checkCertificateFast 10 2965 fastCert10_2965=true := by decide +kernel
def fastCert10_2966 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2966 : checkCertificateFast 10 2966 fastCert10_2966=true := by decide +kernel
def fastCert10_2967 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=14 then (-1) else 0⟩
theorem fastCase10_2967 : checkCertificateFast 10 2967 fastCert10_2967=true := by decide +kernel
def fastCert10_2968 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2968 : checkCertificateFast 10 2968 fastCert10_2968=true := by decide +kernel
def fastCert10_2969 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=11 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2969 : checkCertificateFast 10 2969 fastCert10_2969=true := by decide +kernel
def fastCert10_2970 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2970 : checkCertificateFast 10 2970 fastCert10_2970=true := by decide +kernel
def fastCert10_2971 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2971 : checkCertificateFast 10 2971 fastCert10_2971=true := by decide +kernel
def fastCert10_2972 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2972 : checkCertificateFast 10 2972 fastCert10_2972=true := by decide +kernel
def fastCert10_2973 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=3 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2973 : checkCertificateFast 10 2973 fastCert10_2973=true := by decide +kernel
def fastCert10_2974 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2974 : checkCertificateFast 10 2974 fastCert10_2974=true := by decide +kernel
def fastCert10_2975 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (-1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=9 then (-1) else 0⟩
theorem fastCase10_2975 : checkCertificateFast 10 2975 fastCert10_2975=true := by decide +kernel
def fastCert10_2976 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2976 : checkCertificateFast 10 2976 fastCert10_2976=true := by decide +kernel
def fastCert10_2977 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2977 : checkCertificateFast 10 2977 fastCert10_2977=true := by decide +kernel
def fastCert10_2978 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=4 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-2) else if t=0 ∧ i=7 then (-1) else if t=0 ∧ i=8 then (1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=14 then (2) else if t=0 ∧ i=15 then (-1) else 0⟩
theorem fastCase10_2978 : checkCertificateFast 10 2978 fastCert10_2978=true := by decide +kernel
def fastCert10_2979 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2979 : checkCertificateFast 10 2979 fastCert10_2979=true := by decide +kernel
def fastCert10_2980 : Certificate := ⟨22,fun t i => if t=0 ∧ i=5 then (-1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=12 then (1) else if t=0 ∧ i=13 then (-1) else 0⟩
theorem fastCase10_2980 : checkCertificateFast 10 2980 fastCert10_2980=true := by decide +kernel
def fastCert10_2981 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else if t=0 ∧ i=15 then (-1) else if t=0 ∧ i=16 then (1) else 0⟩
theorem fastCase10_2981 : checkCertificateFast 10 2981 fastCert10_2981=true := by decide +kernel
def fastCert10_2982 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2982 : checkCertificateFast 10 2982 fastCert10_2982=true := by decide +kernel
def fastCert10_2983 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=12 then (-1) else if t=0 ∧ i=14 then (1) else 0⟩
theorem fastCase10_2983 : checkCertificateFast 10 2983 fastCert10_2983=true := by decide +kernel
def fastCert10_2984 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2984 : checkCertificateFast 10 2984 fastCert10_2984=true := by decide +kernel
def fastCert10_2985 : Certificate := ⟨3,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=11 then (-1) else if t=0 ∧ i=13 then (1) else 0⟩
theorem fastCase10_2985 : checkCertificateFast 10 2985 fastCert10_2985=true := by decide +kernel
def fastCert10_2986 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2986 : checkCertificateFast 10 2986 fastCert10_2986=true := by decide +kernel
def fastCert10_2987 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2987 : checkCertificateFast 10 2987 fastCert10_2987=true := by decide +kernel
def fastCert10_2988 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2988 : checkCertificateFast 10 2988 fastCert10_2988=true := by decide +kernel
def fastCert10_2989 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2989 : checkCertificateFast 10 2989 fastCert10_2989=true := by decide +kernel
def fastCert10_2990 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2990 : checkCertificateFast 10 2990 fastCert10_2990=true := by decide +kernel
def fastCert10_2991 : Certificate := ⟨3,fun t i => if t=0 ∧ i=1 then (1) else if t=0 ∧ i=2 then (1) else if t=0 ∧ i=6 then (-1) else if t=0 ∧ i=7 then (1) else if t=0 ∧ i=8 then (-1) else if t=0 ∧ i=9 then (1) else 0⟩
theorem fastCase10_2991 : checkCertificateFast 10 2991 fastCert10_2991=true := by decide +kernel
def fastCert10_2992 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2992 : checkCertificateFast 10 2992 fastCert10_2992=true := by decide +kernel
def fastCert10_2993 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2993 : checkCertificateFast 10 2993 fastCert10_2993=true := by decide +kernel
def fastCert10_2994 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2994 : checkCertificateFast 10 2994 fastCert10_2994=true := by decide +kernel
def fastCert10_2995 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2995 : checkCertificateFast 10 2995 fastCert10_2995=true := by decide +kernel
def fastCert10_2996 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2996 : checkCertificateFast 10 2996 fastCert10_2996=true := by decide +kernel
def fastCert10_2997 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2997 : checkCertificateFast 10 2997 fastCert10_2997=true := by decide +kernel
def fastCert10_2998 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2998 : checkCertificateFast 10 2998 fastCert10_2998=true := by decide +kernel
def fastCert10_2999 : Certificate := ⟨11,fun t i => if t=0 ∧ i=0 then (1) else if t=0 ∧ i=1 then (-1) else if t=0 ∧ i=4 then (-1) else if t=0 ∧ i=5 then (1) else if t=0 ∧ i=6 then (1) else if t=0 ∧ i=7 then (-1) else 0⟩
theorem fastCase10_2999 : checkCertificateFast 10 2999 fastCert10_2999=true := by decide +kernel
theorem aggregate_F10_002 : (checkCertificateFast 10 2000 fastCert10_2000=true) ∧ (checkCertificateFast 10 2001 fastCert10_2001=true) ∧ (checkCertificateFast 10 2002 fastCert10_2002=true) ∧ (checkCertificateFast 10 2003 fastCert10_2003=true) ∧ (checkCertificateFast 10 2004 fastCert10_2004=true) ∧ (checkCertificateFast 10 2005 fastCert10_2005=true) ∧ (checkCertificateFast 10 2006 fastCert10_2006=true) ∧ (checkCertificateFast 10 2007 fastCert10_2007=true) ∧ (checkCertificateFast 10 2008 fastCert10_2008=true) ∧ (checkCertificateFast 10 2009 fastCert10_2009=true) ∧ (checkCertificateFast 10 2010 fastCert10_2010=true) ∧ (checkCertificateFast 10 2011 fastCert10_2011=true) ∧ (checkCertificateFast 10 2012 fastCert10_2012=true) ∧ (checkCertificateFast 10 2013 fastCert10_2013=true) ∧ (checkCertificateFast 10 2014 fastCert10_2014=true) ∧ (checkCertificateFast 10 2015 fastCert10_2015=true) ∧ (checkCertificateFast 10 2016 fastCert10_2016=true) ∧ (checkCertificateFast 10 2017 fastCert10_2017=true) ∧ (checkCertificateFast 10 2018 fastCert10_2018=true) ∧ (checkCertificateFast 10 2019 fastCert10_2019=true) ∧ (checkCertificateFast 10 2020 fastCert10_2020=true) ∧ (checkCertificateFast 10 2021 fastCert10_2021=true) ∧ (checkCertificateFast 10 2022 fastCert10_2022=true) ∧ (checkCertificateFast 10 2023 fastCert10_2023=true) ∧ (checkCertificateFast 10 2024 fastCert10_2024=true) ∧ (checkCertificateFast 10 2025 fastCert10_2025=true) ∧ (checkCertificateFast 10 2026 fastCert10_2026=true) ∧ (checkCertificateFast 10 2027 fastCert10_2027=true) ∧ (checkCertificateFast 10 2028 fastCert10_2028=true) ∧ (checkCertificateFast 10 2029 fastCert10_2029=true) ∧ (checkCertificateFast 10 2030 fastCert10_2030=true) ∧ (checkCertificateFast 10 2031 fastCert10_2031=true) ∧ (checkCertificateFast 10 2032 fastCert10_2032=true) ∧ (checkCertificateFast 10 2033 fastCert10_2033=true) ∧ (checkCertificateFast 10 2034 fastCert10_2034=true) ∧ (checkCertificateFast 10 2035 fastCert10_2035=true) ∧ (checkCertificateFast 10 2036 fastCert10_2036=true) ∧ (checkCertificateFast 10 2037 fastCert10_2037=true) ∧ (checkCertificateFast 10 2038 fastCert10_2038=true) ∧ (checkCertificateFast 10 2039 fastCert10_2039=true) ∧ (checkCertificateFast 10 2040 fastCert10_2040=true) ∧ (checkCertificateFast 10 2041 fastCert10_2041=true) ∧ (checkCertificateFast 10 2042 fastCert10_2042=true) ∧ (checkCertificateFast 10 2043 fastCert10_2043=true) ∧ (checkCertificateFast 10 2044 fastCert10_2044=true) ∧ (checkCertificateFast 10 2045 fastCert10_2045=true) ∧ (checkCertificateFast 10 2046 fastCert10_2046=true) ∧ (checkCertificateFast 10 2047 fastCert10_2047=true) ∧ (checkCertificateFast 10 2048 fastCert10_2048=true) ∧ (checkCertificateFast 10 2049 fastCert10_2049=true) ∧ (checkCertificateFast 10 2050 fastCert10_2050=true) ∧ (checkCertificateFast 10 2051 fastCert10_2051=true) ∧ (checkCertificateFast 10 2052 fastCert10_2052=true) ∧ (checkCertificateFast 10 2053 fastCert10_2053=true) ∧ (checkCertificateFast 10 2054 fastCert10_2054=true) ∧ (checkCertificateFast 10 2055 fastCert10_2055=true) ∧ (checkCertificateFast 10 2056 fastCert10_2056=true) ∧ (checkCertificateFast 10 2057 fastCert10_2057=true) ∧ (checkCertificateFast 10 2058 fastCert10_2058=true) ∧ (checkCertificateFast 10 2059 fastCert10_2059=true) ∧ (checkCertificateFast 10 2060 fastCert10_2060=true) ∧ (checkCertificateFast 10 2061 fastCert10_2061=true) ∧ (checkCertificateFast 10 2062 fastCert10_2062=true) ∧ (checkCertificateFast 10 2063 fastCert10_2063=true) ∧ (checkCertificateFast 10 2064 fastCert10_2064=true) ∧ (checkCertificateFast 10 2065 fastCert10_2065=true) ∧ (checkCertificateFast 10 2066 fastCert10_2066=true) ∧ (checkCertificateFast 10 2067 fastCert10_2067=true) ∧ (checkCertificateFast 10 2068 fastCert10_2068=true) ∧ (checkCertificateFast 10 2069 fastCert10_2069=true) ∧ (checkCertificateFast 10 2070 fastCert10_2070=true) ∧ (checkCertificateFast 10 2071 fastCert10_2071=true) ∧ (checkCertificateFast 10 2072 fastCert10_2072=true) ∧ (checkCertificateFast 10 2073 fastCert10_2073=true) ∧ (checkCertificateFast 10 2074 fastCert10_2074=true) ∧ (checkCertificateFast 10 2075 fastCert10_2075=true) ∧ (checkCertificateFast 10 2076 fastCert10_2076=true) ∧ (checkCertificateFast 10 2077 fastCert10_2077=true) ∧ (checkCertificateFast 10 2078 fastCert10_2078=true) ∧ (checkCertificateFast 10 2079 fastCert10_2079=true) ∧ (checkCertificateFast 10 2080 fastCert10_2080=true) ∧ (checkCertificateFast 10 2081 fastCert10_2081=true) ∧ (checkCertificateFast 10 2082 fastCert10_2082=true) ∧ (checkCertificateFast 10 2083 fastCert10_2083=true) ∧ (checkCertificateFast 10 2084 fastCert10_2084=true) ∧ (checkCertificateFast 10 2085 fastCert10_2085=true) ∧ (checkCertificateFast 10 2086 fastCert10_2086=true) ∧ (checkCertificateFast 10 2087 fastCert10_2087=true) ∧ (checkCertificateFast 10 2088 fastCert10_2088=true) ∧ (checkCertificateFast 10 2089 fastCert10_2089=true) ∧ (checkCertificateFast 10 2090 fastCert10_2090=true) ∧ (checkCertificateFast 10 2091 fastCert10_2091=true) ∧ (checkCertificateFast 10 2092 fastCert10_2092=true) ∧ (checkCertificateFast 10 2093 fastCert10_2093=true) ∧ (checkCertificateFast 10 2094 fastCert10_2094=true) ∧ (checkCertificateFast 10 2095 fastCert10_2095=true) ∧ (checkCertificateFast 10 2096 fastCert10_2096=true) ∧ (checkCertificateFast 10 2097 fastCert10_2097=true) ∧ (checkCertificateFast 10 2098 fastCert10_2098=true) ∧ (checkCertificateFast 10 2099 fastCert10_2099=true) ∧ (checkCertificateFast 10 2100 fastCert10_2100=true) ∧ (checkCertificateFast 10 2101 fastCert10_2101=true) ∧ (checkCertificateFast 10 2102 fastCert10_2102=true) ∧ (checkCertificateFast 10 2103 fastCert10_2103=true) ∧ (checkCertificateFast 10 2104 fastCert10_2104=true) ∧ (checkCertificateFast 10 2105 fastCert10_2105=true) ∧ (checkCertificateFast 10 2106 fastCert10_2106=true) ∧ (checkCertificateFast 10 2107 fastCert10_2107=true) ∧ (checkCertificateFast 10 2108 fastCert10_2108=true) ∧ (checkCertificateFast 10 2109 fastCert10_2109=true) ∧ (checkCertificateFast 10 2110 fastCert10_2110=true) ∧ (checkCertificateFast 10 2111 fastCert10_2111=true) ∧ (checkCertificateFast 10 2112 fastCert10_2112=true) ∧ (checkCertificateFast 10 2113 fastCert10_2113=true) ∧ (checkCertificateFast 10 2114 fastCert10_2114=true) ∧ (checkCertificateFast 10 2115 fastCert10_2115=true) ∧ (checkCertificateFast 10 2116 fastCert10_2116=true) ∧ (checkCertificateFast 10 2117 fastCert10_2117=true) ∧ (checkCertificateFast 10 2118 fastCert10_2118=true) ∧ (checkCertificateFast 10 2119 fastCert10_2119=true) ∧ (checkCertificateFast 10 2120 fastCert10_2120=true) ∧ (checkCertificateFast 10 2121 fastCert10_2121=true) ∧ (checkCertificateFast 10 2122 fastCert10_2122=true) ∧ (checkCertificateFast 10 2123 fastCert10_2123=true) ∧ (checkCertificateFast 10 2124 fastCert10_2124=true) ∧ (checkCertificateFast 10 2125 fastCert10_2125=true) ∧ (checkCertificateFast 10 2126 fastCert10_2126=true) ∧ (checkCertificateFast 10 2127 fastCert10_2127=true) ∧ (checkCertificateFast 10 2128 fastCert10_2128=true) ∧ (checkCertificateFast 10 2129 fastCert10_2129=true) ∧ (checkCertificateFast 10 2130 fastCert10_2130=true) ∧ (checkCertificateFast 10 2131 fastCert10_2131=true) ∧ (checkCertificateFast 10 2132 fastCert10_2132=true) ∧ (checkCertificateFast 10 2133 fastCert10_2133=true) ∧ (checkCertificateFast 10 2134 fastCert10_2134=true) ∧ (checkCertificateFast 10 2135 fastCert10_2135=true) ∧ (checkCertificateFast 10 2136 fastCert10_2136=true) ∧ (checkCertificateFast 10 2137 fastCert10_2137=true) ∧ (checkCertificateFast 10 2138 fastCert10_2138=true) ∧ (checkCertificateFast 10 2139 fastCert10_2139=true) ∧ (checkCertificateFast 10 2140 fastCert10_2140=true) ∧ (checkCertificateFast 10 2141 fastCert10_2141=true) ∧ (checkCertificateFast 10 2142 fastCert10_2142=true) ∧ (checkCertificateFast 10 2143 fastCert10_2143=true) ∧ (checkCertificateFast 10 2144 fastCert10_2144=true) ∧ (checkCertificateFast 10 2145 fastCert10_2145=true) ∧ (checkCertificateFast 10 2146 fastCert10_2146=true) ∧ (checkCertificateFast 10 2147 fastCert10_2147=true) ∧ (checkCertificateFast 10 2148 fastCert10_2148=true) ∧ (checkCertificateFast 10 2149 fastCert10_2149=true) ∧ (checkCertificateFast 10 2150 fastCert10_2150=true) ∧ (checkCertificateFast 10 2151 fastCert10_2151=true) ∧ (checkCertificateFast 10 2152 fastCert10_2152=true) ∧ (checkCertificateFast 10 2153 fastCert10_2153=true) ∧ (checkCertificateFast 10 2154 fastCert10_2154=true) ∧ (checkCertificateFast 10 2155 fastCert10_2155=true) ∧ (checkCertificateFast 10 2156 fastCert10_2156=true) ∧ (checkCertificateFast 10 2157 fastCert10_2157=true) ∧ (checkCertificateFast 10 2158 fastCert10_2158=true) ∧ (checkCertificateFast 10 2159 fastCert10_2159=true) ∧ (checkCertificateFast 10 2160 fastCert10_2160=true) ∧ (checkCertificateFast 10 2161 fastCert10_2161=true) ∧ (checkCertificateFast 10 2162 fastCert10_2162=true) ∧ (checkCertificateFast 10 2163 fastCert10_2163=true) ∧ (checkCertificateFast 10 2164 fastCert10_2164=true) ∧ (checkCertificateFast 10 2165 fastCert10_2165=true) ∧ (checkCertificateFast 10 2166 fastCert10_2166=true) ∧ (checkCertificateFast 10 2167 fastCert10_2167=true) ∧ (checkCertificateFast 10 2168 fastCert10_2168=true) ∧ (checkCertificateFast 10 2169 fastCert10_2169=true) ∧ (checkCertificateFast 10 2170 fastCert10_2170=true) ∧ (checkCertificateFast 10 2171 fastCert10_2171=true) ∧ (checkCertificateFast 10 2172 fastCert10_2172=true) ∧ (checkCertificateFast 10 2173 fastCert10_2173=true) ∧ (checkCertificateFast 10 2174 fastCert10_2174=true) ∧ (checkCertificateFast 10 2175 fastCert10_2175=true) ∧ (checkCertificateFast 10 2176 fastCert10_2176=true) ∧ (checkCertificateFast 10 2177 fastCert10_2177=true) ∧ (checkCertificateFast 10 2178 fastCert10_2178=true) ∧ (checkCertificateFast 10 2179 fastCert10_2179=true) ∧ (checkCertificateFast 10 2180 fastCert10_2180=true) ∧ (checkCertificateFast 10 2181 fastCert10_2181=true) ∧ (checkCertificateFast 10 2182 fastCert10_2182=true) ∧ (checkCertificateFast 10 2183 fastCert10_2183=true) ∧ (checkCertificateFast 10 2184 fastCert10_2184=true) ∧ (checkCertificateFast 10 2185 fastCert10_2185=true) ∧ (checkCertificateFast 10 2186 fastCert10_2186=true) ∧ (checkCertificateFast 10 2187 fastCert10_2187=true) ∧ (checkCertificateFast 10 2188 fastCert10_2188=true) ∧ (checkCertificateFast 10 2189 fastCert10_2189=true) ∧ (checkCertificateFast 10 2190 fastCert10_2190=true) ∧ (checkCertificateFast 10 2191 fastCert10_2191=true) ∧ (checkCertificateFast 10 2192 fastCert10_2192=true) ∧ (checkCertificateFast 10 2193 fastCert10_2193=true) ∧ (checkCertificateFast 10 2194 fastCert10_2194=true) ∧ (checkCertificateFast 10 2195 fastCert10_2195=true) ∧ (checkCertificateFast 10 2196 fastCert10_2196=true) ∧ (checkCertificateFast 10 2197 fastCert10_2197=true) ∧ (checkCertificateFast 10 2198 fastCert10_2198=true) ∧ (checkCertificateFast 10 2199 fastCert10_2199=true) ∧ (checkCertificateFast 10 2200 fastCert10_2200=true) ∧ (checkCertificateFast 10 2201 fastCert10_2201=true) ∧ (checkCertificateFast 10 2202 fastCert10_2202=true) ∧ (checkCertificateFast 10 2203 fastCert10_2203=true) ∧ (checkCertificateFast 10 2204 fastCert10_2204=true) ∧ (checkCertificateFast 10 2205 fastCert10_2205=true) ∧ (checkCertificateFast 10 2206 fastCert10_2206=true) ∧ (checkCertificateFast 10 2207 fastCert10_2207=true) ∧ (checkCertificateFast 10 2208 fastCert10_2208=true) ∧ (checkCertificateFast 10 2209 fastCert10_2209=true) ∧ (checkCertificateFast 10 2210 fastCert10_2210=true) ∧ (checkCertificateFast 10 2211 fastCert10_2211=true) ∧ (checkCertificateFast 10 2212 fastCert10_2212=true) ∧ (checkCertificateFast 10 2213 fastCert10_2213=true) ∧ (checkCertificateFast 10 2214 fastCert10_2214=true) ∧ (checkCertificateFast 10 2215 fastCert10_2215=true) ∧ (checkCertificateFast 10 2216 fastCert10_2216=true) ∧ (checkCertificateFast 10 2217 fastCert10_2217=true) ∧ (checkCertificateFast 10 2218 fastCert10_2218=true) ∧ (checkCertificateFast 10 2219 fastCert10_2219=true) ∧ (checkCertificateFast 10 2220 fastCert10_2220=true) ∧ (checkCertificateFast 10 2221 fastCert10_2221=true) ∧ (checkCertificateFast 10 2222 fastCert10_2222=true) ∧ (checkCertificateFast 10 2223 fastCert10_2223=true) ∧ (checkCertificateFast 10 2224 fastCert10_2224=true) ∧ (checkCertificateFast 10 2225 fastCert10_2225=true) ∧ (checkCertificateFast 10 2226 fastCert10_2226=true) ∧ (checkCertificateFast 10 2227 fastCert10_2227=true) ∧ (checkCertificateFast 10 2228 fastCert10_2228=true) ∧ (checkCertificateFast 10 2229 fastCert10_2229=true) ∧ (checkCertificateFast 10 2230 fastCert10_2230=true) ∧ (checkCertificateFast 10 2231 fastCert10_2231=true) ∧ (checkCertificateFast 10 2232 fastCert10_2232=true) ∧ (checkCertificateFast 10 2233 fastCert10_2233=true) ∧ (checkCertificateFast 10 2234 fastCert10_2234=true) ∧ (checkCertificateFast 10 2235 fastCert10_2235=true) ∧ (checkCertificateFast 10 2236 fastCert10_2236=true) ∧ (checkCertificateFast 10 2237 fastCert10_2237=true) ∧ (checkCertificateFast 10 2238 fastCert10_2238=true) ∧ (checkCertificateFast 10 2239 fastCert10_2239=true) ∧ (checkCertificateFast 10 2240 fastCert10_2240=true) ∧ (checkCertificateFast 10 2241 fastCert10_2241=true) ∧ (checkCertificateFast 10 2242 fastCert10_2242=true) ∧ (checkCertificateFast 10 2243 fastCert10_2243=true) ∧ (checkCertificateFast 10 2244 fastCert10_2244=true) ∧ (checkCertificateFast 10 2245 fastCert10_2245=true) ∧ (checkCertificateFast 10 2246 fastCert10_2246=true) ∧ (checkCertificateFast 10 2247 fastCert10_2247=true) ∧ (checkCertificateFast 10 2248 fastCert10_2248=true) ∧ (checkCertificateFast 10 2249 fastCert10_2249=true) ∧ (checkCertificateFast 10 2250 fastCert10_2250=true) ∧ (checkCertificateFast 10 2251 fastCert10_2251=true) ∧ (checkCertificateFast 10 2252 fastCert10_2252=true) ∧ (checkCertificateFast 10 2253 fastCert10_2253=true) ∧ (checkCertificateFast 10 2254 fastCert10_2254=true) ∧ (checkCertificateFast 10 2255 fastCert10_2255=true) ∧ (checkCertificateFast 10 2256 fastCert10_2256=true) ∧ (checkCertificateFast 10 2257 fastCert10_2257=true) ∧ (checkCertificateFast 10 2258 fastCert10_2258=true) ∧ (checkCertificateFast 10 2259 fastCert10_2259=true) ∧ (checkCertificateFast 10 2260 fastCert10_2260=true) ∧ (checkCertificateFast 10 2261 fastCert10_2261=true) ∧ (checkCertificateFast 10 2262 fastCert10_2262=true) ∧ (checkCertificateFast 10 2263 fastCert10_2263=true) ∧ (checkCertificateFast 10 2264 fastCert10_2264=true) ∧ (checkCertificateFast 10 2265 fastCert10_2265=true) ∧ (checkCertificateFast 10 2266 fastCert10_2266=true) ∧ (checkCertificateFast 10 2267 fastCert10_2267=true) ∧ (checkCertificateFast 10 2268 fastCert10_2268=true) ∧ (checkCertificateFast 10 2269 fastCert10_2269=true) ∧ (checkCertificateFast 10 2270 fastCert10_2270=true) ∧ (checkCertificateFast 10 2271 fastCert10_2271=true) ∧ (checkCertificateFast 10 2272 fastCert10_2272=true) ∧ (checkCertificateFast 10 2273 fastCert10_2273=true) ∧ (checkCertificateFast 10 2274 fastCert10_2274=true) ∧ (checkCertificateFast 10 2275 fastCert10_2275=true) ∧ (checkCertificateFast 10 2276 fastCert10_2276=true) ∧ (checkCertificateFast 10 2277 fastCert10_2277=true) ∧ (checkCertificateFast 10 2278 fastCert10_2278=true) ∧ (checkCertificateFast 10 2279 fastCert10_2279=true) ∧ (checkCertificateFast 10 2280 fastCert10_2280=true) ∧ (checkCertificateFast 10 2281 fastCert10_2281=true) ∧ (checkCertificateFast 10 2282 fastCert10_2282=true) ∧ (checkCertificateFast 10 2283 fastCert10_2283=true) ∧ (checkCertificateFast 10 2284 fastCert10_2284=true) ∧ (checkCertificateFast 10 2285 fastCert10_2285=true) ∧ (checkCertificateFast 10 2286 fastCert10_2286=true) ∧ (checkCertificateFast 10 2287 fastCert10_2287=true) ∧ (checkCertificateFast 10 2288 fastCert10_2288=true) ∧ (checkCertificateFast 10 2289 fastCert10_2289=true) ∧ (checkCertificateFast 10 2290 fastCert10_2290=true) ∧ (checkCertificateFast 10 2291 fastCert10_2291=true) ∧ (checkCertificateFast 10 2292 fastCert10_2292=true) ∧ (checkCertificateFast 10 2293 fastCert10_2293=true) ∧ (checkCertificateFast 10 2294 fastCert10_2294=true) ∧ (checkCertificateFast 10 2295 fastCert10_2295=true) ∧ (checkCertificateFast 10 2296 fastCert10_2296=true) ∧ (checkCertificateFast 10 2297 fastCert10_2297=true) ∧ (checkCertificateFast 10 2298 fastCert10_2298=true) ∧ (checkCertificateFast 10 2299 fastCert10_2299=true) ∧ (checkCertificateFast 10 2300 fastCert10_2300=true) ∧ (checkCertificateFast 10 2301 fastCert10_2301=true) ∧ (checkCertificateFast 10 2302 fastCert10_2302=true) ∧ (checkCertificateFast 10 2303 fastCert10_2303=true) ∧ (checkCertificateFast 10 2304 fastCert10_2304=true) ∧ (checkCertificateFast 10 2305 fastCert10_2305=true) ∧ (checkCertificateFast 10 2306 fastCert10_2306=true) ∧ (checkCertificateFast 10 2307 fastCert10_2307=true) ∧ (checkCertificateFast 10 2308 fastCert10_2308=true) ∧ (checkCertificateFast 10 2309 fastCert10_2309=true) ∧ (checkCertificateFast 10 2310 fastCert10_2310=true) ∧ (checkCertificateFast 10 2311 fastCert10_2311=true) ∧ (checkCertificateFast 10 2312 fastCert10_2312=true) ∧ (checkCertificateFast 10 2313 fastCert10_2313=true) ∧ (checkCertificateFast 10 2314 fastCert10_2314=true) ∧ (checkCertificateFast 10 2315 fastCert10_2315=true) ∧ (checkCertificateFast 10 2316 fastCert10_2316=true) ∧ (checkCertificateFast 10 2317 fastCert10_2317=true) ∧ (checkCertificateFast 10 2318 fastCert10_2318=true) ∧ (checkCertificateFast 10 2319 fastCert10_2319=true) ∧ (checkCertificateFast 10 2320 fastCert10_2320=true) ∧ (checkCertificateFast 10 2321 fastCert10_2321=true) ∧ (checkCertificateFast 10 2322 fastCert10_2322=true) ∧ (checkCertificateFast 10 2323 fastCert10_2323=true) ∧ (checkCertificateFast 10 2324 fastCert10_2324=true) ∧ (checkCertificateFast 10 2325 fastCert10_2325=true) ∧ (checkCertificateFast 10 2326 fastCert10_2326=true) ∧ (checkCertificateFast 10 2327 fastCert10_2327=true) ∧ (checkCertificateFast 10 2328 fastCert10_2328=true) ∧ (checkCertificateFast 10 2329 fastCert10_2329=true) ∧ (checkCertificateFast 10 2330 fastCert10_2330=true) ∧ (checkCertificateFast 10 2331 fastCert10_2331=true) ∧ (checkCertificateFast 10 2332 fastCert10_2332=true) ∧ (checkCertificateFast 10 2333 fastCert10_2333=true) ∧ (checkCertificateFast 10 2334 fastCert10_2334=true) ∧ (checkCertificateFast 10 2335 fastCert10_2335=true) ∧ (checkCertificateFast 10 2336 fastCert10_2336=true) ∧ (checkCertificateFast 10 2337 fastCert10_2337=true) ∧ (checkCertificateFast 10 2338 fastCert10_2338=true) ∧ (checkCertificateFast 10 2339 fastCert10_2339=true) ∧ (checkCertificateFast 10 2340 fastCert10_2340=true) ∧ (checkCertificateFast 10 2341 fastCert10_2341=true) ∧ (checkCertificateFast 10 2342 fastCert10_2342=true) ∧ (checkCertificateFast 10 2343 fastCert10_2343=true) ∧ (checkCertificateFast 10 2344 fastCert10_2344=true) ∧ (checkCertificateFast 10 2345 fastCert10_2345=true) ∧ (checkCertificateFast 10 2346 fastCert10_2346=true) ∧ (checkCertificateFast 10 2347 fastCert10_2347=true) ∧ (checkCertificateFast 10 2348 fastCert10_2348=true) ∧ (checkCertificateFast 10 2349 fastCert10_2349=true) ∧ (checkCertificateFast 10 2350 fastCert10_2350=true) ∧ (checkCertificateFast 10 2351 fastCert10_2351=true) ∧ (checkCertificateFast 10 2352 fastCert10_2352=true) ∧ (checkCertificateFast 10 2353 fastCert10_2353=true) ∧ (checkCertificateFast 10 2354 fastCert10_2354=true) ∧ (checkCertificateFast 10 2355 fastCert10_2355=true) ∧ (checkCertificateFast 10 2356 fastCert10_2356=true) ∧ (checkCertificateFast 10 2357 fastCert10_2357=true) ∧ (checkCertificateFast 10 2358 fastCert10_2358=true) ∧ (checkCertificateFast 10 2359 fastCert10_2359=true) ∧ (checkCertificateFast 10 2360 fastCert10_2360=true) ∧ (checkCertificateFast 10 2361 fastCert10_2361=true) ∧ (checkCertificateFast 10 2362 fastCert10_2362=true) ∧ (checkCertificateFast 10 2363 fastCert10_2363=true) ∧ (checkCertificateFast 10 2364 fastCert10_2364=true) ∧ (checkCertificateFast 10 2365 fastCert10_2365=true) ∧ (checkCertificateFast 10 2366 fastCert10_2366=true) ∧ (checkCertificateFast 10 2367 fastCert10_2367=true) ∧ (checkCertificateFast 10 2368 fastCert10_2368=true) ∧ (checkCertificateFast 10 2369 fastCert10_2369=true) ∧ (checkCertificateFast 10 2370 fastCert10_2370=true) ∧ (checkCertificateFast 10 2371 fastCert10_2371=true) ∧ (checkCertificateFast 10 2372 fastCert10_2372=true) ∧ (checkCertificateFast 10 2373 fastCert10_2373=true) ∧ (checkCertificateFast 10 2374 fastCert10_2374=true) ∧ (checkCertificateFast 10 2375 fastCert10_2375=true) ∧ (checkCertificateFast 10 2376 fastCert10_2376=true) ∧ (checkCertificateFast 10 2377 fastCert10_2377=true) ∧ (checkCertificateFast 10 2378 fastCert10_2378=true) ∧ (checkCertificateFast 10 2379 fastCert10_2379=true) ∧ (checkCertificateFast 10 2380 fastCert10_2380=true) ∧ (checkCertificateFast 10 2381 fastCert10_2381=true) ∧ (checkCertificateFast 10 2382 fastCert10_2382=true) ∧ (checkCertificateFast 10 2383 fastCert10_2383=true) ∧ (checkCertificateFast 10 2384 fastCert10_2384=true) ∧ (checkCertificateFast 10 2385 fastCert10_2385=true) ∧ (checkCertificateFast 10 2386 fastCert10_2386=true) ∧ (checkCertificateFast 10 2387 fastCert10_2387=true) ∧ (checkCertificateFast 10 2388 fastCert10_2388=true) ∧ (checkCertificateFast 10 2389 fastCert10_2389=true) ∧ (checkCertificateFast 10 2390 fastCert10_2390=true) ∧ (checkCertificateFast 10 2391 fastCert10_2391=true) ∧ (checkCertificateFast 10 2392 fastCert10_2392=true) ∧ (checkCertificateFast 10 2393 fastCert10_2393=true) ∧ (checkCertificateFast 10 2394 fastCert10_2394=true) ∧ (checkCertificateFast 10 2395 fastCert10_2395=true) ∧ (checkCertificateFast 10 2396 fastCert10_2396=true) ∧ (checkCertificateFast 10 2397 fastCert10_2397=true) ∧ (checkCertificateFast 10 2398 fastCert10_2398=true) ∧ (checkCertificateFast 10 2399 fastCert10_2399=true) ∧ (checkCertificateFast 10 2400 fastCert10_2400=true) ∧ (checkCertificateFast 10 2401 fastCert10_2401=true) ∧ (checkCertificateFast 10 2402 fastCert10_2402=true) ∧ (checkCertificateFast 10 2403 fastCert10_2403=true) ∧ (checkCertificateFast 10 2404 fastCert10_2404=true) ∧ (checkCertificateFast 10 2405 fastCert10_2405=true) ∧ (checkCertificateFast 10 2406 fastCert10_2406=true) ∧ (checkCertificateFast 10 2407 fastCert10_2407=true) ∧ (checkCertificateFast 10 2408 fastCert10_2408=true) ∧ (checkCertificateFast 10 2409 fastCert10_2409=true) ∧ (checkCertificateFast 10 2410 fastCert10_2410=true) ∧ (checkCertificateFast 10 2411 fastCert10_2411=true) ∧ (checkCertificateFast 10 2412 fastCert10_2412=true) ∧ (checkCertificateFast 10 2413 fastCert10_2413=true) ∧ (checkCertificateFast 10 2414 fastCert10_2414=true) ∧ (checkCertificateFast 10 2415 fastCert10_2415=true) ∧ (checkCertificateFast 10 2416 fastCert10_2416=true) ∧ (checkCertificateFast 10 2417 fastCert10_2417=true) ∧ (checkCertificateFast 10 2418 fastCert10_2418=true) ∧ (checkCertificateFast 10 2419 fastCert10_2419=true) ∧ (checkCertificateFast 10 2420 fastCert10_2420=true) ∧ (checkCertificateFast 10 2421 fastCert10_2421=true) ∧ (checkCertificateFast 10 2422 fastCert10_2422=true) ∧ (checkCertificateFast 10 2423 fastCert10_2423=true) ∧ (checkCertificateFast 10 2424 fastCert10_2424=true) ∧ (checkCertificateFast 10 2425 fastCert10_2425=true) ∧ (checkCertificateFast 10 2426 fastCert10_2426=true) ∧ (checkCertificateFast 10 2427 fastCert10_2427=true) ∧ (checkCertificateFast 10 2428 fastCert10_2428=true) ∧ (checkCertificateFast 10 2429 fastCert10_2429=true) ∧ (checkCertificateFast 10 2430 fastCert10_2430=true) ∧ (checkCertificateFast 10 2431 fastCert10_2431=true) ∧ (checkCertificateFast 10 2432 fastCert10_2432=true) ∧ (checkCertificateFast 10 2433 fastCert10_2433=true) ∧ (checkCertificateFast 10 2434 fastCert10_2434=true) ∧ (checkCertificateFast 10 2435 fastCert10_2435=true) ∧ (checkCertificateFast 10 2436 fastCert10_2436=true) ∧ (checkCertificateFast 10 2437 fastCert10_2437=true) ∧ (checkCertificateFast 10 2438 fastCert10_2438=true) ∧ (checkCertificateFast 10 2439 fastCert10_2439=true) ∧ (checkCertificateFast 10 2440 fastCert10_2440=true) ∧ (checkCertificateFast 10 2441 fastCert10_2441=true) ∧ (checkCertificateFast 10 2442 fastCert10_2442=true) ∧ (checkCertificateFast 10 2443 fastCert10_2443=true) ∧ (checkCertificateFast 10 2444 fastCert10_2444=true) ∧ (checkCertificateFast 10 2445 fastCert10_2445=true) ∧ (checkCertificateFast 10 2446 fastCert10_2446=true) ∧ (checkCertificateFast 10 2447 fastCert10_2447=true) ∧ (checkCertificateFast 10 2448 fastCert10_2448=true) ∧ (checkCertificateFast 10 2449 fastCert10_2449=true) ∧ (checkCertificateFast 10 2450 fastCert10_2450=true) ∧ (checkCertificateFast 10 2451 fastCert10_2451=true) ∧ (checkCertificateFast 10 2452 fastCert10_2452=true) ∧ (checkCertificateFast 10 2453 fastCert10_2453=true) ∧ (checkCertificateFast 10 2454 fastCert10_2454=true) ∧ (checkCertificateFast 10 2455 fastCert10_2455=true) ∧ (checkCertificateFast 10 2456 fastCert10_2456=true) ∧ (checkCertificateFast 10 2457 fastCert10_2457=true) ∧ (checkCertificateFast 10 2458 fastCert10_2458=true) ∧ (checkCertificateFast 10 2459 fastCert10_2459=true) ∧ (checkCertificateFast 10 2460 fastCert10_2460=true) ∧ (checkCertificateFast 10 2461 fastCert10_2461=true) ∧ (checkCertificateFast 10 2462 fastCert10_2462=true) ∧ (checkCertificateFast 10 2463 fastCert10_2463=true) ∧ (checkCertificateFast 10 2464 fastCert10_2464=true) ∧ (checkCertificateFast 10 2465 fastCert10_2465=true) ∧ (checkCertificateFast 10 2466 fastCert10_2466=true) ∧ (checkCertificateFast 10 2467 fastCert10_2467=true) ∧ (checkCertificateFast 10 2468 fastCert10_2468=true) ∧ (checkCertificateFast 10 2469 fastCert10_2469=true) ∧ (checkCertificateFast 10 2470 fastCert10_2470=true) ∧ (checkCertificateFast 10 2471 fastCert10_2471=true) ∧ (checkCertificateFast 10 2472 fastCert10_2472=true) ∧ (checkCertificateFast 10 2473 fastCert10_2473=true) ∧ (checkCertificateFast 10 2474 fastCert10_2474=true) ∧ (checkCertificateFast 10 2475 fastCert10_2475=true) ∧ (checkCertificateFast 10 2476 fastCert10_2476=true) ∧ (checkCertificateFast 10 2477 fastCert10_2477=true) ∧ (checkCertificateFast 10 2478 fastCert10_2478=true) ∧ (checkCertificateFast 10 2479 fastCert10_2479=true) ∧ (checkCertificateFast 10 2480 fastCert10_2480=true) ∧ (checkCertificateFast 10 2481 fastCert10_2481=true) ∧ (checkCertificateFast 10 2482 fastCert10_2482=true) ∧ (checkCertificateFast 10 2483 fastCert10_2483=true) ∧ (checkCertificateFast 10 2484 fastCert10_2484=true) ∧ (checkCertificateFast 10 2485 fastCert10_2485=true) ∧ (checkCertificateFast 10 2486 fastCert10_2486=true) ∧ (checkCertificateFast 10 2487 fastCert10_2487=true) ∧ (checkCertificateFast 10 2488 fastCert10_2488=true) ∧ (checkCertificateFast 10 2489 fastCert10_2489=true) ∧ (checkCertificateFast 10 2490 fastCert10_2490=true) ∧ (checkCertificateFast 10 2491 fastCert10_2491=true) ∧ (checkCertificateFast 10 2492 fastCert10_2492=true) ∧ (checkCertificateFast 10 2493 fastCert10_2493=true) ∧ (checkCertificateFast 10 2494 fastCert10_2494=true) ∧ (checkCertificateFast 10 2495 fastCert10_2495=true) ∧ (checkCertificateFast 10 2496 fastCert10_2496=true) ∧ (checkCertificateFast 10 2497 fastCert10_2497=true) ∧ (checkCertificateFast 10 2498 fastCert10_2498=true) ∧ (checkCertificateFast 10 2499 fastCert10_2499=true) ∧ (checkCertificateFast 10 2500 fastCert10_2500=true) ∧ (checkCertificateFast 10 2501 fastCert10_2501=true) ∧ (checkCertificateFast 10 2502 fastCert10_2502=true) ∧ (checkCertificateFast 10 2503 fastCert10_2503=true) ∧ (checkCertificateFast 10 2504 fastCert10_2504=true) ∧ (checkCertificateFast 10 2505 fastCert10_2505=true) ∧ (checkCertificateFast 10 2506 fastCert10_2506=true) ∧ (checkCertificateFast 10 2507 fastCert10_2507=true) ∧ (checkCertificateFast 10 2508 fastCert10_2508=true) ∧ (checkCertificateFast 10 2509 fastCert10_2509=true) ∧ (checkCertificateFast 10 2510 fastCert10_2510=true) ∧ (checkCertificateFast 10 2511 fastCert10_2511=true) ∧ (checkCertificateFast 10 2512 fastCert10_2512=true) ∧ (checkCertificateFast 10 2513 fastCert10_2513=true) ∧ (checkCertificateFast 10 2514 fastCert10_2514=true) ∧ (checkCertificateFast 10 2515 fastCert10_2515=true) ∧ (checkCertificateFast 10 2516 fastCert10_2516=true) ∧ (checkCertificateFast 10 2517 fastCert10_2517=true) ∧ (checkCertificateFast 10 2518 fastCert10_2518=true) ∧ (checkCertificateFast 10 2519 fastCert10_2519=true) ∧ (checkCertificateFast 10 2520 fastCert10_2520=true) ∧ (checkCertificateFast 10 2521 fastCert10_2521=true) ∧ (checkCertificateFast 10 2522 fastCert10_2522=true) ∧ (checkCertificateFast 10 2523 fastCert10_2523=true) ∧ (checkCertificateFast 10 2524 fastCert10_2524=true) ∧ (checkCertificateFast 10 2525 fastCert10_2525=true) ∧ (checkCertificateFast 10 2526 fastCert10_2526=true) ∧ (checkCertificateFast 10 2527 fastCert10_2527=true) ∧ (checkCertificateFast 10 2528 fastCert10_2528=true) ∧ (checkCertificateFast 10 2529 fastCert10_2529=true) ∧ (checkCertificateFast 10 2530 fastCert10_2530=true) ∧ (checkCertificateFast 10 2531 fastCert10_2531=true) ∧ (checkCertificateFast 10 2532 fastCert10_2532=true) ∧ (checkCertificateFast 10 2533 fastCert10_2533=true) ∧ (checkCertificateFast 10 2534 fastCert10_2534=true) ∧ (checkCertificateFast 10 2535 fastCert10_2535=true) ∧ (checkCertificateFast 10 2536 fastCert10_2536=true) ∧ (checkCertificateFast 10 2537 fastCert10_2537=true) ∧ (checkCertificateFast 10 2538 fastCert10_2538=true) ∧ (checkCertificateFast 10 2539 fastCert10_2539=true) ∧ (checkCertificateFast 10 2540 fastCert10_2540=true) ∧ (checkCertificateFast 10 2541 fastCert10_2541=true) ∧ (checkCertificateFast 10 2542 fastCert10_2542=true) ∧ (checkCertificateFast 10 2543 fastCert10_2543=true) ∧ (checkCertificateFast 10 2544 fastCert10_2544=true) ∧ (checkCertificateFast 10 2545 fastCert10_2545=true) ∧ (checkCertificateFast 10 2546 fastCert10_2546=true) ∧ (checkCertificateFast 10 2547 fastCert10_2547=true) ∧ (checkCertificateFast 10 2548 fastCert10_2548=true) ∧ (checkCertificateFast 10 2549 fastCert10_2549=true) ∧ (checkCertificateFast 10 2550 fastCert10_2550=true) ∧ (checkCertificateFast 10 2551 fastCert10_2551=true) ∧ (checkCertificateFast 10 2552 fastCert10_2552=true) ∧ (checkCertificateFast 10 2553 fastCert10_2553=true) ∧ (checkCertificateFast 10 2554 fastCert10_2554=true) ∧ (checkCertificateFast 10 2555 fastCert10_2555=true) ∧ (checkCertificateFast 10 2556 fastCert10_2556=true) ∧ (checkCertificateFast 10 2557 fastCert10_2557=true) ∧ (checkCertificateFast 10 2558 fastCert10_2558=true) ∧ (checkCertificateFast 10 2559 fastCert10_2559=true) ∧ (checkCertificateFast 10 2560 fastCert10_2560=true) ∧ (checkCertificateFast 10 2561 fastCert10_2561=true) ∧ (checkCertificateFast 10 2562 fastCert10_2562=true) ∧ (checkCertificateFast 10 2563 fastCert10_2563=true) ∧ (checkCertificateFast 10 2564 fastCert10_2564=true) ∧ (checkCertificateFast 10 2565 fastCert10_2565=true) ∧ (checkCertificateFast 10 2566 fastCert10_2566=true) ∧ (checkCertificateFast 10 2567 fastCert10_2567=true) ∧ (checkCertificateFast 10 2568 fastCert10_2568=true) ∧ (checkCertificateFast 10 2569 fastCert10_2569=true) ∧ (checkCertificateFast 10 2570 fastCert10_2570=true) ∧ (checkCertificateFast 10 2571 fastCert10_2571=true) ∧ (checkCertificateFast 10 2572 fastCert10_2572=true) ∧ (checkCertificateFast 10 2573 fastCert10_2573=true) ∧ (checkCertificateFast 10 2574 fastCert10_2574=true) ∧ (checkCertificateFast 10 2575 fastCert10_2575=true) ∧ (checkCertificateFast 10 2576 fastCert10_2576=true) ∧ (checkCertificateFast 10 2577 fastCert10_2577=true) ∧ (checkCertificateFast 10 2578 fastCert10_2578=true) ∧ (checkCertificateFast 10 2579 fastCert10_2579=true) ∧ (checkCertificateFast 10 2580 fastCert10_2580=true) ∧ (checkCertificateFast 10 2581 fastCert10_2581=true) ∧ (checkCertificateFast 10 2582 fastCert10_2582=true) ∧ (checkCertificateFast 10 2583 fastCert10_2583=true) ∧ (checkCertificateFast 10 2584 fastCert10_2584=true) ∧ (checkCertificateFast 10 2585 fastCert10_2585=true) ∧ (checkCertificateFast 10 2586 fastCert10_2586=true) ∧ (checkCertificateFast 10 2587 fastCert10_2587=true) ∧ (checkCertificateFast 10 2588 fastCert10_2588=true) ∧ (checkCertificateFast 10 2589 fastCert10_2589=true) ∧ (checkCertificateFast 10 2590 fastCert10_2590=true) ∧ (checkCertificateFast 10 2591 fastCert10_2591=true) ∧ (checkCertificateFast 10 2592 fastCert10_2592=true) ∧ (checkCertificateFast 10 2593 fastCert10_2593=true) ∧ (checkCertificateFast 10 2594 fastCert10_2594=true) ∧ (checkCertificateFast 10 2595 fastCert10_2595=true) ∧ (checkCertificateFast 10 2596 fastCert10_2596=true) ∧ (checkCertificateFast 10 2597 fastCert10_2597=true) ∧ (checkCertificateFast 10 2598 fastCert10_2598=true) ∧ (checkCertificateFast 10 2599 fastCert10_2599=true) ∧ (checkCertificateFast 10 2600 fastCert10_2600=true) ∧ (checkCertificateFast 10 2601 fastCert10_2601=true) ∧ (checkCertificateFast 10 2602 fastCert10_2602=true) ∧ (checkCertificateFast 10 2603 fastCert10_2603=true) ∧ (checkCertificateFast 10 2604 fastCert10_2604=true) ∧ (checkCertificateFast 10 2605 fastCert10_2605=true) ∧ (checkCertificateFast 10 2606 fastCert10_2606=true) ∧ (checkCertificateFast 10 2607 fastCert10_2607=true) ∧ (checkCertificateFast 10 2608 fastCert10_2608=true) ∧ (checkCertificateFast 10 2609 fastCert10_2609=true) ∧ (checkCertificateFast 10 2610 fastCert10_2610=true) ∧ (checkCertificateFast 10 2611 fastCert10_2611=true) ∧ (checkCertificateFast 10 2612 fastCert10_2612=true) ∧ (checkCertificateFast 10 2613 fastCert10_2613=true) ∧ (checkCertificateFast 10 2614 fastCert10_2614=true) ∧ (checkCertificateFast 10 2615 fastCert10_2615=true) ∧ (checkCertificateFast 10 2616 fastCert10_2616=true) ∧ (checkCertificateFast 10 2617 fastCert10_2617=true) ∧ (checkCertificateFast 10 2618 fastCert10_2618=true) ∧ (checkCertificateFast 10 2619 fastCert10_2619=true) ∧ (checkCertificateFast 10 2620 fastCert10_2620=true) ∧ (checkCertificateFast 10 2621 fastCert10_2621=true) ∧ (checkCertificateFast 10 2622 fastCert10_2622=true) ∧ (checkCertificateFast 10 2623 fastCert10_2623=true) ∧ (checkCertificateFast 10 2624 fastCert10_2624=true) ∧ (checkCertificateFast 10 2625 fastCert10_2625=true) ∧ (checkCertificateFast 10 2626 fastCert10_2626=true) ∧ (checkCertificateFast 10 2627 fastCert10_2627=true) ∧ (checkCertificateFast 10 2628 fastCert10_2628=true) ∧ (checkCertificateFast 10 2629 fastCert10_2629=true) ∧ (checkCertificateFast 10 2630 fastCert10_2630=true) ∧ (checkCertificateFast 10 2631 fastCert10_2631=true) ∧ (checkCertificateFast 10 2632 fastCert10_2632=true) ∧ (checkCertificateFast 10 2633 fastCert10_2633=true) ∧ (checkCertificateFast 10 2634 fastCert10_2634=true) ∧ (checkCertificateFast 10 2635 fastCert10_2635=true) ∧ (checkCertificateFast 10 2636 fastCert10_2636=true) ∧ (checkCertificateFast 10 2637 fastCert10_2637=true) ∧ (checkCertificateFast 10 2638 fastCert10_2638=true) ∧ (checkCertificateFast 10 2639 fastCert10_2639=true) ∧ (checkCertificateFast 10 2640 fastCert10_2640=true) ∧ (checkCertificateFast 10 2641 fastCert10_2641=true) ∧ (checkCertificateFast 10 2642 fastCert10_2642=true) ∧ (checkCertificateFast 10 2643 fastCert10_2643=true) ∧ (checkCertificateFast 10 2644 fastCert10_2644=true) ∧ (checkCertificateFast 10 2645 fastCert10_2645=true) ∧ (checkCertificateFast 10 2646 fastCert10_2646=true) ∧ (checkCertificateFast 10 2647 fastCert10_2647=true) ∧ (checkCertificateFast 10 2648 fastCert10_2648=true) ∧ (checkCertificateFast 10 2649 fastCert10_2649=true) ∧ (checkCertificateFast 10 2650 fastCert10_2650=true) ∧ (checkCertificateFast 10 2651 fastCert10_2651=true) ∧ (checkCertificateFast 10 2652 fastCert10_2652=true) ∧ (checkCertificateFast 10 2653 fastCert10_2653=true) ∧ (checkCertificateFast 10 2654 fastCert10_2654=true) ∧ (checkCertificateFast 10 2655 fastCert10_2655=true) ∧ (checkCertificateFast 10 2656 fastCert10_2656=true) ∧ (checkCertificateFast 10 2657 fastCert10_2657=true) ∧ (checkCertificateFast 10 2658 fastCert10_2658=true) ∧ (checkCertificateFast 10 2659 fastCert10_2659=true) ∧ (checkCertificateFast 10 2660 fastCert10_2660=true) ∧ (checkCertificateFast 10 2661 fastCert10_2661=true) ∧ (checkCertificateFast 10 2662 fastCert10_2662=true) ∧ (checkCertificateFast 10 2663 fastCert10_2663=true) ∧ (checkCertificateFast 10 2664 fastCert10_2664=true) ∧ (checkCertificateFast 10 2665 fastCert10_2665=true) ∧ (checkCertificateFast 10 2666 fastCert10_2666=true) ∧ (checkCertificateFast 10 2667 fastCert10_2667=true) ∧ (checkCertificateFast 10 2668 fastCert10_2668=true) ∧ (checkCertificateFast 10 2669 fastCert10_2669=true) ∧ (checkCertificateFast 10 2670 fastCert10_2670=true) ∧ (checkCertificateFast 10 2671 fastCert10_2671=true) ∧ (checkCertificateFast 10 2672 fastCert10_2672=true) ∧ (checkCertificateFast 10 2673 fastCert10_2673=true) ∧ (checkCertificateFast 10 2674 fastCert10_2674=true) ∧ (checkCertificateFast 10 2675 fastCert10_2675=true) ∧ (checkCertificateFast 10 2676 fastCert10_2676=true) ∧ (checkCertificateFast 10 2677 fastCert10_2677=true) ∧ (checkCertificateFast 10 2678 fastCert10_2678=true) ∧ (checkCertificateFast 10 2679 fastCert10_2679=true) ∧ (checkCertificateFast 10 2680 fastCert10_2680=true) ∧ (checkCertificateFast 10 2681 fastCert10_2681=true) ∧ (checkCertificateFast 10 2682 fastCert10_2682=true) ∧ (checkCertificateFast 10 2683 fastCert10_2683=true) ∧ (checkCertificateFast 10 2684 fastCert10_2684=true) ∧ (checkCertificateFast 10 2685 fastCert10_2685=true) ∧ (checkCertificateFast 10 2686 fastCert10_2686=true) ∧ (checkCertificateFast 10 2687 fastCert10_2687=true) ∧ (checkCertificateFast 10 2688 fastCert10_2688=true) ∧ (checkCertificateFast 10 2689 fastCert10_2689=true) ∧ (checkCertificateFast 10 2690 fastCert10_2690=true) ∧ (checkCertificateFast 10 2691 fastCert10_2691=true) ∧ (checkCertificateFast 10 2692 fastCert10_2692=true) ∧ (checkCertificateFast 10 2693 fastCert10_2693=true) ∧ (checkCertificateFast 10 2694 fastCert10_2694=true) ∧ (checkCertificateFast 10 2695 fastCert10_2695=true) ∧ (checkCertificateFast 10 2696 fastCert10_2696=true) ∧ (checkCertificateFast 10 2697 fastCert10_2697=true) ∧ (checkCertificateFast 10 2698 fastCert10_2698=true) ∧ (checkCertificateFast 10 2699 fastCert10_2699=true) ∧ (checkCertificateFast 10 2700 fastCert10_2700=true) ∧ (checkCertificateFast 10 2701 fastCert10_2701=true) ∧ (checkCertificateFast 10 2702 fastCert10_2702=true) ∧ (checkCertificateFast 10 2703 fastCert10_2703=true) ∧ (checkCertificateFast 10 2704 fastCert10_2704=true) ∧ (checkCertificateFast 10 2705 fastCert10_2705=true) ∧ (checkCertificateFast 10 2706 fastCert10_2706=true) ∧ (checkCertificateFast 10 2707 fastCert10_2707=true) ∧ (checkCertificateFast 10 2708 fastCert10_2708=true) ∧ (checkCertificateFast 10 2709 fastCert10_2709=true) ∧ (checkCertificateFast 10 2710 fastCert10_2710=true) ∧ (checkCertificateFast 10 2711 fastCert10_2711=true) ∧ (checkCertificateFast 10 2712 fastCert10_2712=true) ∧ (checkCertificateFast 10 2713 fastCert10_2713=true) ∧ (checkCertificateFast 10 2714 fastCert10_2714=true) ∧ (checkCertificateFast 10 2715 fastCert10_2715=true) ∧ (checkCertificateFast 10 2716 fastCert10_2716=true) ∧ (checkCertificateFast 10 2717 fastCert10_2717=true) ∧ (checkCertificateFast 10 2718 fastCert10_2718=true) ∧ (checkCertificateFast 10 2719 fastCert10_2719=true) ∧ (checkCertificateFast 10 2720 fastCert10_2720=true) ∧ (checkCertificateFast 10 2721 fastCert10_2721=true) ∧ (checkCertificateFast 10 2722 fastCert10_2722=true) ∧ (checkCertificateFast 10 2723 fastCert10_2723=true) ∧ (checkCertificateFast 10 2724 fastCert10_2724=true) ∧ (checkCertificateFast 10 2725 fastCert10_2725=true) ∧ (checkCertificateFast 10 2726 fastCert10_2726=true) ∧ (checkCertificateFast 10 2727 fastCert10_2727=true) ∧ (checkCertificateFast 10 2728 fastCert10_2728=true) ∧ (checkCertificateFast 10 2729 fastCert10_2729=true) ∧ (checkCertificateFast 10 2730 fastCert10_2730=true) ∧ (checkCertificateFast 10 2731 fastCert10_2731=true) ∧ (checkCertificateFast 10 2732 fastCert10_2732=true) ∧ (checkCertificateFast 10 2733 fastCert10_2733=true) ∧ (checkCertificateFast 10 2734 fastCert10_2734=true) ∧ (checkCertificateFast 10 2735 fastCert10_2735=true) ∧ (checkCertificateFast 10 2736 fastCert10_2736=true) ∧ (checkCertificateFast 10 2737 fastCert10_2737=true) ∧ (checkCertificateFast 10 2738 fastCert10_2738=true) ∧ (checkCertificateFast 10 2739 fastCert10_2739=true) ∧ (checkCertificateFast 10 2740 fastCert10_2740=true) ∧ (checkCertificateFast 10 2741 fastCert10_2741=true) ∧ (checkCertificateFast 10 2742 fastCert10_2742=true) ∧ (checkCertificateFast 10 2743 fastCert10_2743=true) ∧ (checkCertificateFast 10 2744 fastCert10_2744=true) ∧ (checkCertificateFast 10 2745 fastCert10_2745=true) ∧ (checkCertificateFast 10 2746 fastCert10_2746=true) ∧ (checkCertificateFast 10 2747 fastCert10_2747=true) ∧ (checkCertificateFast 10 2748 fastCert10_2748=true) ∧ (checkCertificateFast 10 2749 fastCert10_2749=true) ∧ (checkCertificateFast 10 2750 fastCert10_2750=true) ∧ (checkCertificateFast 10 2751 fastCert10_2751=true) ∧ (checkCertificateFast 10 2752 fastCert10_2752=true) ∧ (checkCertificateFast 10 2753 fastCert10_2753=true) ∧ (checkCertificateFast 10 2754 fastCert10_2754=true) ∧ (checkCertificateFast 10 2755 fastCert10_2755=true) ∧ (checkCertificateFast 10 2756 fastCert10_2756=true) ∧ (checkCertificateFast 10 2757 fastCert10_2757=true) ∧ (checkCertificateFast 10 2758 fastCert10_2758=true) ∧ (checkCertificateFast 10 2759 fastCert10_2759=true) ∧ (checkCertificateFast 10 2760 fastCert10_2760=true) ∧ (checkCertificateFast 10 2761 fastCert10_2761=true) ∧ (checkCertificateFast 10 2762 fastCert10_2762=true) ∧ (checkCertificateFast 10 2763 fastCert10_2763=true) ∧ (checkCertificateFast 10 2764 fastCert10_2764=true) ∧ (checkCertificateFast 10 2765 fastCert10_2765=true) ∧ (checkCertificateFast 10 2766 fastCert10_2766=true) ∧ (checkCertificateFast 10 2767 fastCert10_2767=true) ∧ (checkCertificateFast 10 2768 fastCert10_2768=true) ∧ (checkCertificateFast 10 2769 fastCert10_2769=true) ∧ (checkCertificateFast 10 2770 fastCert10_2770=true) ∧ (checkCertificateFast 10 2771 fastCert10_2771=true) ∧ (checkCertificateFast 10 2772 fastCert10_2772=true) ∧ (checkCertificateFast 10 2773 fastCert10_2773=true) ∧ (checkCertificateFast 10 2774 fastCert10_2774=true) ∧ (checkCertificateFast 10 2775 fastCert10_2775=true) ∧ (checkCertificateFast 10 2776 fastCert10_2776=true) ∧ (checkCertificateFast 10 2777 fastCert10_2777=true) ∧ (checkCertificateFast 10 2778 fastCert10_2778=true) ∧ (checkCertificateFast 10 2779 fastCert10_2779=true) ∧ (checkCertificateFast 10 2780 fastCert10_2780=true) ∧ (checkCertificateFast 10 2781 fastCert10_2781=true) ∧ (checkCertificateFast 10 2782 fastCert10_2782=true) ∧ (checkCertificateFast 10 2783 fastCert10_2783=true) ∧ (checkCertificateFast 10 2784 fastCert10_2784=true) ∧ (checkCertificateFast 10 2785 fastCert10_2785=true) ∧ (checkCertificateFast 10 2786 fastCert10_2786=true) ∧ (checkCertificateFast 10 2787 fastCert10_2787=true) ∧ (checkCertificateFast 10 2788 fastCert10_2788=true) ∧ (checkCertificateFast 10 2789 fastCert10_2789=true) ∧ (checkCertificateFast 10 2790 fastCert10_2790=true) ∧ (checkCertificateFast 10 2791 fastCert10_2791=true) ∧ (checkCertificateFast 10 2792 fastCert10_2792=true) ∧ (checkCertificateFast 10 2793 fastCert10_2793=true) ∧ (checkCertificateFast 10 2794 fastCert10_2794=true) ∧ (checkCertificateFast 10 2795 fastCert10_2795=true) ∧ (checkCertificateFast 10 2796 fastCert10_2796=true) ∧ (checkCertificateFast 10 2797 fastCert10_2797=true) ∧ (checkCertificateFast 10 2798 fastCert10_2798=true) ∧ (checkCertificateFast 10 2799 fastCert10_2799=true) ∧ (checkCertificateFast 10 2800 fastCert10_2800=true) ∧ (checkCertificateFast 10 2801 fastCert10_2801=true) ∧ (checkCertificateFast 10 2802 fastCert10_2802=true) ∧ (checkCertificateFast 10 2803 fastCert10_2803=true) ∧ (checkCertificateFast 10 2804 fastCert10_2804=true) ∧ (checkCertificateFast 10 2805 fastCert10_2805=true) ∧ (checkCertificateFast 10 2806 fastCert10_2806=true) ∧ (checkCertificateFast 10 2807 fastCert10_2807=true) ∧ (checkCertificateFast 10 2808 fastCert10_2808=true) ∧ (checkCertificateFast 10 2809 fastCert10_2809=true) ∧ (checkCertificateFast 10 2810 fastCert10_2810=true) ∧ (checkCertificateFast 10 2811 fastCert10_2811=true) ∧ (checkCertificateFast 10 2812 fastCert10_2812=true) ∧ (checkCertificateFast 10 2813 fastCert10_2813=true) ∧ (checkCertificateFast 10 2814 fastCert10_2814=true) ∧ (checkCertificateFast 10 2815 fastCert10_2815=true) ∧ (checkCertificateFast 10 2816 fastCert10_2816=true) ∧ (checkCertificateFast 10 2817 fastCert10_2817=true) ∧ (checkCertificateFast 10 2818 fastCert10_2818=true) ∧ (checkCertificateFast 10 2819 fastCert10_2819=true) ∧ (checkCertificateFast 10 2820 fastCert10_2820=true) ∧ (checkCertificateFast 10 2821 fastCert10_2821=true) ∧ (checkCertificateFast 10 2822 fastCert10_2822=true) ∧ (checkCertificateFast 10 2823 fastCert10_2823=true) ∧ (checkCertificateFast 10 2824 fastCert10_2824=true) ∧ (checkCertificateFast 10 2825 fastCert10_2825=true) ∧ (checkCertificateFast 10 2826 fastCert10_2826=true) ∧ (checkCertificateFast 10 2827 fastCert10_2827=true) ∧ (checkCertificateFast 10 2828 fastCert10_2828=true) ∧ (checkCertificateFast 10 2829 fastCert10_2829=true) ∧ (checkCertificateFast 10 2830 fastCert10_2830=true) ∧ (checkCertificateFast 10 2831 fastCert10_2831=true) ∧ (checkCertificateFast 10 2832 fastCert10_2832=true) ∧ (checkCertificateFast 10 2833 fastCert10_2833=true) ∧ (checkCertificateFast 10 2834 fastCert10_2834=true) ∧ (checkCertificateFast 10 2835 fastCert10_2835=true) ∧ (checkCertificateFast 10 2836 fastCert10_2836=true) ∧ (checkCertificateFast 10 2837 fastCert10_2837=true) ∧ (checkCertificateFast 10 2838 fastCert10_2838=true) ∧ (checkCertificateFast 10 2839 fastCert10_2839=true) ∧ (checkCertificateFast 10 2840 fastCert10_2840=true) ∧ (checkCertificateFast 10 2841 fastCert10_2841=true) ∧ (checkCertificateFast 10 2842 fastCert10_2842=true) ∧ (checkCertificateFast 10 2843 fastCert10_2843=true) ∧ (checkCertificateFast 10 2844 fastCert10_2844=true) ∧ (checkCertificateFast 10 2845 fastCert10_2845=true) ∧ (checkCertificateFast 10 2846 fastCert10_2846=true) ∧ (checkCertificateFast 10 2847 fastCert10_2847=true) ∧ (checkCertificateFast 10 2848 fastCert10_2848=true) ∧ (checkCertificateFast 10 2849 fastCert10_2849=true) ∧ (checkCertificateFast 10 2850 fastCert10_2850=true) ∧ (checkCertificateFast 10 2851 fastCert10_2851=true) ∧ (checkCertificateFast 10 2852 fastCert10_2852=true) ∧ (checkCertificateFast 10 2853 fastCert10_2853=true) ∧ (checkCertificateFast 10 2854 fastCert10_2854=true) ∧ (checkCertificateFast 10 2855 fastCert10_2855=true) ∧ (checkCertificateFast 10 2856 fastCert10_2856=true) ∧ (checkCertificateFast 10 2857 fastCert10_2857=true) ∧ (checkCertificateFast 10 2858 fastCert10_2858=true) ∧ (checkCertificateFast 10 2859 fastCert10_2859=true) ∧ (checkCertificateFast 10 2860 fastCert10_2860=true) ∧ (checkCertificateFast 10 2861 fastCert10_2861=true) ∧ (checkCertificateFast 10 2862 fastCert10_2862=true) ∧ (checkCertificateFast 10 2863 fastCert10_2863=true) ∧ (checkCertificateFast 10 2864 fastCert10_2864=true) ∧ (checkCertificateFast 10 2865 fastCert10_2865=true) ∧ (checkCertificateFast 10 2866 fastCert10_2866=true) ∧ (checkCertificateFast 10 2867 fastCert10_2867=true) ∧ (checkCertificateFast 10 2868 fastCert10_2868=true) ∧ (checkCertificateFast 10 2869 fastCert10_2869=true) ∧ (checkCertificateFast 10 2870 fastCert10_2870=true) ∧ (checkCertificateFast 10 2871 fastCert10_2871=true) ∧ (checkCertificateFast 10 2872 fastCert10_2872=true) ∧ (checkCertificateFast 10 2873 fastCert10_2873=true) ∧ (checkCertificateFast 10 2874 fastCert10_2874=true) ∧ (checkCertificateFast 10 2875 fastCert10_2875=true) ∧ (checkCertificateFast 10 2876 fastCert10_2876=true) ∧ (checkCertificateFast 10 2877 fastCert10_2877=true) ∧ (checkCertificateFast 10 2878 fastCert10_2878=true) ∧ (checkCertificateFast 10 2879 fastCert10_2879=true) ∧ (checkCertificateFast 10 2880 fastCert10_2880=true) ∧ (checkCertificateFast 10 2881 fastCert10_2881=true) ∧ (checkCertificateFast 10 2882 fastCert10_2882=true) ∧ (checkCertificateFast 10 2883 fastCert10_2883=true) ∧ (checkCertificateFast 10 2884 fastCert10_2884=true) ∧ (checkCertificateFast 10 2885 fastCert10_2885=true) ∧ (checkCertificateFast 10 2886 fastCert10_2886=true) ∧ (checkCertificateFast 10 2887 fastCert10_2887=true) ∧ (checkCertificateFast 10 2888 fastCert10_2888=true) ∧ (checkCertificateFast 10 2889 fastCert10_2889=true) ∧ (checkCertificateFast 10 2890 fastCert10_2890=true) ∧ (checkCertificateFast 10 2891 fastCert10_2891=true) ∧ (checkCertificateFast 10 2892 fastCert10_2892=true) ∧ (checkCertificateFast 10 2893 fastCert10_2893=true) ∧ (checkCertificateFast 10 2894 fastCert10_2894=true) ∧ (checkCertificateFast 10 2895 fastCert10_2895=true) ∧ (checkCertificateFast 10 2896 fastCert10_2896=true) ∧ (checkCertificateFast 10 2897 fastCert10_2897=true) ∧ (checkCertificateFast 10 2898 fastCert10_2898=true) ∧ (checkCertificateFast 10 2899 fastCert10_2899=true) ∧ (checkCertificateFast 10 2900 fastCert10_2900=true) ∧ (checkCertificateFast 10 2901 fastCert10_2901=true) ∧ (checkCertificateFast 10 2902 fastCert10_2902=true) ∧ (checkCertificateFast 10 2903 fastCert10_2903=true) ∧ (checkCertificateFast 10 2904 fastCert10_2904=true) ∧ (checkCertificateFast 10 2905 fastCert10_2905=true) ∧ (checkCertificateFast 10 2906 fastCert10_2906=true) ∧ (checkCertificateFast 10 2907 fastCert10_2907=true) ∧ (checkCertificateFast 10 2908 fastCert10_2908=true) ∧ (checkCertificateFast 10 2909 fastCert10_2909=true) ∧ (checkCertificateFast 10 2910 fastCert10_2910=true) ∧ (checkCertificateFast 10 2911 fastCert10_2911=true) ∧ (checkCertificateFast 10 2912 fastCert10_2912=true) ∧ (checkCertificateFast 10 2913 fastCert10_2913=true) ∧ (checkCertificateFast 10 2914 fastCert10_2914=true) ∧ (checkCertificateFast 10 2915 fastCert10_2915=true) ∧ (checkCertificateFast 10 2916 fastCert10_2916=true) ∧ (checkCertificateFast 10 2917 fastCert10_2917=true) ∧ (checkCertificateFast 10 2918 fastCert10_2918=true) ∧ (checkCertificateFast 10 2919 fastCert10_2919=true) ∧ (checkCertificateFast 10 2920 fastCert10_2920=true) ∧ (checkCertificateFast 10 2921 fastCert10_2921=true) ∧ (checkCertificateFast 10 2922 fastCert10_2922=true) ∧ (checkCertificateFast 10 2923 fastCert10_2923=true) ∧ (checkCertificateFast 10 2924 fastCert10_2924=true) ∧ (checkCertificateFast 10 2925 fastCert10_2925=true) ∧ (checkCertificateFast 10 2926 fastCert10_2926=true) ∧ (checkCertificateFast 10 2927 fastCert10_2927=true) ∧ (checkCertificateFast 10 2928 fastCert10_2928=true) ∧ (checkCertificateFast 10 2929 fastCert10_2929=true) ∧ (checkCertificateFast 10 2930 fastCert10_2930=true) ∧ (checkCertificateFast 10 2931 fastCert10_2931=true) ∧ (checkCertificateFast 10 2932 fastCert10_2932=true) ∧ (checkCertificateFast 10 2933 fastCert10_2933=true) ∧ (checkCertificateFast 10 2934 fastCert10_2934=true) ∧ (checkCertificateFast 10 2935 fastCert10_2935=true) ∧ (checkCertificateFast 10 2936 fastCert10_2936=true) ∧ (checkCertificateFast 10 2937 fastCert10_2937=true) ∧ (checkCertificateFast 10 2938 fastCert10_2938=true) ∧ (checkCertificateFast 10 2939 fastCert10_2939=true) ∧ (checkCertificateFast 10 2940 fastCert10_2940=true) ∧ (checkCertificateFast 10 2941 fastCert10_2941=true) ∧ (checkCertificateFast 10 2942 fastCert10_2942=true) ∧ (checkCertificateFast 10 2943 fastCert10_2943=true) ∧ (checkCertificateFast 10 2944 fastCert10_2944=true) ∧ (checkCertificateFast 10 2945 fastCert10_2945=true) ∧ (checkCertificateFast 10 2946 fastCert10_2946=true) ∧ (checkCertificateFast 10 2947 fastCert10_2947=true) ∧ (checkCertificateFast 10 2948 fastCert10_2948=true) ∧ (checkCertificateFast 10 2949 fastCert10_2949=true) ∧ (checkCertificateFast 10 2950 fastCert10_2950=true) ∧ (checkCertificateFast 10 2951 fastCert10_2951=true) ∧ (checkCertificateFast 10 2952 fastCert10_2952=true) ∧ (checkCertificateFast 10 2953 fastCert10_2953=true) ∧ (checkCertificateFast 10 2954 fastCert10_2954=true) ∧ (checkCertificateFast 10 2955 fastCert10_2955=true) ∧ (checkCertificateFast 10 2956 fastCert10_2956=true) ∧ (checkCertificateFast 10 2957 fastCert10_2957=true) ∧ (checkCertificateFast 10 2958 fastCert10_2958=true) ∧ (checkCertificateFast 10 2959 fastCert10_2959=true) ∧ (checkCertificateFast 10 2960 fastCert10_2960=true) ∧ (checkCertificateFast 10 2961 fastCert10_2961=true) ∧ (checkCertificateFast 10 2962 fastCert10_2962=true) ∧ (checkCertificateFast 10 2963 fastCert10_2963=true) ∧ (checkCertificateFast 10 2964 fastCert10_2964=true) ∧ (checkCertificateFast 10 2965 fastCert10_2965=true) ∧ (checkCertificateFast 10 2966 fastCert10_2966=true) ∧ (checkCertificateFast 10 2967 fastCert10_2967=true) ∧ (checkCertificateFast 10 2968 fastCert10_2968=true) ∧ (checkCertificateFast 10 2969 fastCert10_2969=true) ∧ (checkCertificateFast 10 2970 fastCert10_2970=true) ∧ (checkCertificateFast 10 2971 fastCert10_2971=true) ∧ (checkCertificateFast 10 2972 fastCert10_2972=true) ∧ (checkCertificateFast 10 2973 fastCert10_2973=true) ∧ (checkCertificateFast 10 2974 fastCert10_2974=true) ∧ (checkCertificateFast 10 2975 fastCert10_2975=true) ∧ (checkCertificateFast 10 2976 fastCert10_2976=true) ∧ (checkCertificateFast 10 2977 fastCert10_2977=true) ∧ (checkCertificateFast 10 2978 fastCert10_2978=true) ∧ (checkCertificateFast 10 2979 fastCert10_2979=true) ∧ (checkCertificateFast 10 2980 fastCert10_2980=true) ∧ (checkCertificateFast 10 2981 fastCert10_2981=true) ∧ (checkCertificateFast 10 2982 fastCert10_2982=true) ∧ (checkCertificateFast 10 2983 fastCert10_2983=true) ∧ (checkCertificateFast 10 2984 fastCert10_2984=true) ∧ (checkCertificateFast 10 2985 fastCert10_2985=true) ∧ (checkCertificateFast 10 2986 fastCert10_2986=true) ∧ (checkCertificateFast 10 2987 fastCert10_2987=true) ∧ (checkCertificateFast 10 2988 fastCert10_2988=true) ∧ (checkCertificateFast 10 2989 fastCert10_2989=true) ∧ (checkCertificateFast 10 2990 fastCert10_2990=true) ∧ (checkCertificateFast 10 2991 fastCert10_2991=true) ∧ (checkCertificateFast 10 2992 fastCert10_2992=true) ∧ (checkCertificateFast 10 2993 fastCert10_2993=true) ∧ (checkCertificateFast 10 2994 fastCert10_2994=true) ∧ (checkCertificateFast 10 2995 fastCert10_2995=true) ∧ (checkCertificateFast 10 2996 fastCert10_2996=true) ∧ (checkCertificateFast 10 2997 fastCert10_2997=true) ∧ (checkCertificateFast 10 2998 fastCert10_2998=true) ∧ (checkCertificateFast 10 2999 fastCert10_2999=true) :=
  ⟨fastCase10_2000,fastCase10_2001,fastCase10_2002,fastCase10_2003,fastCase10_2004,fastCase10_2005,fastCase10_2006,fastCase10_2007,fastCase10_2008,fastCase10_2009,fastCase10_2010,fastCase10_2011,fastCase10_2012,fastCase10_2013,fastCase10_2014,fastCase10_2015,fastCase10_2016,fastCase10_2017,fastCase10_2018,fastCase10_2019,fastCase10_2020,fastCase10_2021,fastCase10_2022,fastCase10_2023,fastCase10_2024,fastCase10_2025,fastCase10_2026,fastCase10_2027,fastCase10_2028,fastCase10_2029,fastCase10_2030,fastCase10_2031,fastCase10_2032,fastCase10_2033,fastCase10_2034,fastCase10_2035,fastCase10_2036,fastCase10_2037,fastCase10_2038,fastCase10_2039,fastCase10_2040,fastCase10_2041,fastCase10_2042,fastCase10_2043,fastCase10_2044,fastCase10_2045,fastCase10_2046,fastCase10_2047,fastCase10_2048,fastCase10_2049,fastCase10_2050,fastCase10_2051,fastCase10_2052,fastCase10_2053,fastCase10_2054,fastCase10_2055,fastCase10_2056,fastCase10_2057,fastCase10_2058,fastCase10_2059,fastCase10_2060,fastCase10_2061,fastCase10_2062,fastCase10_2063,fastCase10_2064,fastCase10_2065,fastCase10_2066,fastCase10_2067,fastCase10_2068,fastCase10_2069,fastCase10_2070,fastCase10_2071,fastCase10_2072,fastCase10_2073,fastCase10_2074,fastCase10_2075,fastCase10_2076,fastCase10_2077,fastCase10_2078,fastCase10_2079,fastCase10_2080,fastCase10_2081,fastCase10_2082,fastCase10_2083,fastCase10_2084,fastCase10_2085,fastCase10_2086,fastCase10_2087,fastCase10_2088,fastCase10_2089,fastCase10_2090,fastCase10_2091,fastCase10_2092,fastCase10_2093,fastCase10_2094,fastCase10_2095,fastCase10_2096,fastCase10_2097,fastCase10_2098,fastCase10_2099,fastCase10_2100,fastCase10_2101,fastCase10_2102,fastCase10_2103,fastCase10_2104,fastCase10_2105,fastCase10_2106,fastCase10_2107,fastCase10_2108,fastCase10_2109,fastCase10_2110,fastCase10_2111,fastCase10_2112,fastCase10_2113,fastCase10_2114,fastCase10_2115,fastCase10_2116,fastCase10_2117,fastCase10_2118,fastCase10_2119,fastCase10_2120,fastCase10_2121,fastCase10_2122,fastCase10_2123,fastCase10_2124,fastCase10_2125,fastCase10_2126,fastCase10_2127,fastCase10_2128,fastCase10_2129,fastCase10_2130,fastCase10_2131,fastCase10_2132,fastCase10_2133,fastCase10_2134,fastCase10_2135,fastCase10_2136,fastCase10_2137,fastCase10_2138,fastCase10_2139,fastCase10_2140,fastCase10_2141,fastCase10_2142,fastCase10_2143,fastCase10_2144,fastCase10_2145,fastCase10_2146,fastCase10_2147,fastCase10_2148,fastCase10_2149,fastCase10_2150,fastCase10_2151,fastCase10_2152,fastCase10_2153,fastCase10_2154,fastCase10_2155,fastCase10_2156,fastCase10_2157,fastCase10_2158,fastCase10_2159,fastCase10_2160,fastCase10_2161,fastCase10_2162,fastCase10_2163,fastCase10_2164,fastCase10_2165,fastCase10_2166,fastCase10_2167,fastCase10_2168,fastCase10_2169,fastCase10_2170,fastCase10_2171,fastCase10_2172,fastCase10_2173,fastCase10_2174,fastCase10_2175,fastCase10_2176,fastCase10_2177,fastCase10_2178,fastCase10_2179,fastCase10_2180,fastCase10_2181,fastCase10_2182,fastCase10_2183,fastCase10_2184,fastCase10_2185,fastCase10_2186,fastCase10_2187,fastCase10_2188,fastCase10_2189,fastCase10_2190,fastCase10_2191,fastCase10_2192,fastCase10_2193,fastCase10_2194,fastCase10_2195,fastCase10_2196,fastCase10_2197,fastCase10_2198,fastCase10_2199,fastCase10_2200,fastCase10_2201,fastCase10_2202,fastCase10_2203,fastCase10_2204,fastCase10_2205,fastCase10_2206,fastCase10_2207,fastCase10_2208,fastCase10_2209,fastCase10_2210,fastCase10_2211,fastCase10_2212,fastCase10_2213,fastCase10_2214,fastCase10_2215,fastCase10_2216,fastCase10_2217,fastCase10_2218,fastCase10_2219,fastCase10_2220,fastCase10_2221,fastCase10_2222,fastCase10_2223,fastCase10_2224,fastCase10_2225,fastCase10_2226,fastCase10_2227,fastCase10_2228,fastCase10_2229,fastCase10_2230,fastCase10_2231,fastCase10_2232,fastCase10_2233,fastCase10_2234,fastCase10_2235,fastCase10_2236,fastCase10_2237,fastCase10_2238,fastCase10_2239,fastCase10_2240,fastCase10_2241,fastCase10_2242,fastCase10_2243,fastCase10_2244,fastCase10_2245,fastCase10_2246,fastCase10_2247,fastCase10_2248,fastCase10_2249,fastCase10_2250,fastCase10_2251,fastCase10_2252,fastCase10_2253,fastCase10_2254,fastCase10_2255,fastCase10_2256,fastCase10_2257,fastCase10_2258,fastCase10_2259,fastCase10_2260,fastCase10_2261,fastCase10_2262,fastCase10_2263,fastCase10_2264,fastCase10_2265,fastCase10_2266,fastCase10_2267,fastCase10_2268,fastCase10_2269,fastCase10_2270,fastCase10_2271,fastCase10_2272,fastCase10_2273,fastCase10_2274,fastCase10_2275,fastCase10_2276,fastCase10_2277,fastCase10_2278,fastCase10_2279,fastCase10_2280,fastCase10_2281,fastCase10_2282,fastCase10_2283,fastCase10_2284,fastCase10_2285,fastCase10_2286,fastCase10_2287,fastCase10_2288,fastCase10_2289,fastCase10_2290,fastCase10_2291,fastCase10_2292,fastCase10_2293,fastCase10_2294,fastCase10_2295,fastCase10_2296,fastCase10_2297,fastCase10_2298,fastCase10_2299,fastCase10_2300,fastCase10_2301,fastCase10_2302,fastCase10_2303,fastCase10_2304,fastCase10_2305,fastCase10_2306,fastCase10_2307,fastCase10_2308,fastCase10_2309,fastCase10_2310,fastCase10_2311,fastCase10_2312,fastCase10_2313,fastCase10_2314,fastCase10_2315,fastCase10_2316,fastCase10_2317,fastCase10_2318,fastCase10_2319,fastCase10_2320,fastCase10_2321,fastCase10_2322,fastCase10_2323,fastCase10_2324,fastCase10_2325,fastCase10_2326,fastCase10_2327,fastCase10_2328,fastCase10_2329,fastCase10_2330,fastCase10_2331,fastCase10_2332,fastCase10_2333,fastCase10_2334,fastCase10_2335,fastCase10_2336,fastCase10_2337,fastCase10_2338,fastCase10_2339,fastCase10_2340,fastCase10_2341,fastCase10_2342,fastCase10_2343,fastCase10_2344,fastCase10_2345,fastCase10_2346,fastCase10_2347,fastCase10_2348,fastCase10_2349,fastCase10_2350,fastCase10_2351,fastCase10_2352,fastCase10_2353,fastCase10_2354,fastCase10_2355,fastCase10_2356,fastCase10_2357,fastCase10_2358,fastCase10_2359,fastCase10_2360,fastCase10_2361,fastCase10_2362,fastCase10_2363,fastCase10_2364,fastCase10_2365,fastCase10_2366,fastCase10_2367,fastCase10_2368,fastCase10_2369,fastCase10_2370,fastCase10_2371,fastCase10_2372,fastCase10_2373,fastCase10_2374,fastCase10_2375,fastCase10_2376,fastCase10_2377,fastCase10_2378,fastCase10_2379,fastCase10_2380,fastCase10_2381,fastCase10_2382,fastCase10_2383,fastCase10_2384,fastCase10_2385,fastCase10_2386,fastCase10_2387,fastCase10_2388,fastCase10_2389,fastCase10_2390,fastCase10_2391,fastCase10_2392,fastCase10_2393,fastCase10_2394,fastCase10_2395,fastCase10_2396,fastCase10_2397,fastCase10_2398,fastCase10_2399,fastCase10_2400,fastCase10_2401,fastCase10_2402,fastCase10_2403,fastCase10_2404,fastCase10_2405,fastCase10_2406,fastCase10_2407,fastCase10_2408,fastCase10_2409,fastCase10_2410,fastCase10_2411,fastCase10_2412,fastCase10_2413,fastCase10_2414,fastCase10_2415,fastCase10_2416,fastCase10_2417,fastCase10_2418,fastCase10_2419,fastCase10_2420,fastCase10_2421,fastCase10_2422,fastCase10_2423,fastCase10_2424,fastCase10_2425,fastCase10_2426,fastCase10_2427,fastCase10_2428,fastCase10_2429,fastCase10_2430,fastCase10_2431,fastCase10_2432,fastCase10_2433,fastCase10_2434,fastCase10_2435,fastCase10_2436,fastCase10_2437,fastCase10_2438,fastCase10_2439,fastCase10_2440,fastCase10_2441,fastCase10_2442,fastCase10_2443,fastCase10_2444,fastCase10_2445,fastCase10_2446,fastCase10_2447,fastCase10_2448,fastCase10_2449,fastCase10_2450,fastCase10_2451,fastCase10_2452,fastCase10_2453,fastCase10_2454,fastCase10_2455,fastCase10_2456,fastCase10_2457,fastCase10_2458,fastCase10_2459,fastCase10_2460,fastCase10_2461,fastCase10_2462,fastCase10_2463,fastCase10_2464,fastCase10_2465,fastCase10_2466,fastCase10_2467,fastCase10_2468,fastCase10_2469,fastCase10_2470,fastCase10_2471,fastCase10_2472,fastCase10_2473,fastCase10_2474,fastCase10_2475,fastCase10_2476,fastCase10_2477,fastCase10_2478,fastCase10_2479,fastCase10_2480,fastCase10_2481,fastCase10_2482,fastCase10_2483,fastCase10_2484,fastCase10_2485,fastCase10_2486,fastCase10_2487,fastCase10_2488,fastCase10_2489,fastCase10_2490,fastCase10_2491,fastCase10_2492,fastCase10_2493,fastCase10_2494,fastCase10_2495,fastCase10_2496,fastCase10_2497,fastCase10_2498,fastCase10_2499,fastCase10_2500,fastCase10_2501,fastCase10_2502,fastCase10_2503,fastCase10_2504,fastCase10_2505,fastCase10_2506,fastCase10_2507,fastCase10_2508,fastCase10_2509,fastCase10_2510,fastCase10_2511,fastCase10_2512,fastCase10_2513,fastCase10_2514,fastCase10_2515,fastCase10_2516,fastCase10_2517,fastCase10_2518,fastCase10_2519,fastCase10_2520,fastCase10_2521,fastCase10_2522,fastCase10_2523,fastCase10_2524,fastCase10_2525,fastCase10_2526,fastCase10_2527,fastCase10_2528,fastCase10_2529,fastCase10_2530,fastCase10_2531,fastCase10_2532,fastCase10_2533,fastCase10_2534,fastCase10_2535,fastCase10_2536,fastCase10_2537,fastCase10_2538,fastCase10_2539,fastCase10_2540,fastCase10_2541,fastCase10_2542,fastCase10_2543,fastCase10_2544,fastCase10_2545,fastCase10_2546,fastCase10_2547,fastCase10_2548,fastCase10_2549,fastCase10_2550,fastCase10_2551,fastCase10_2552,fastCase10_2553,fastCase10_2554,fastCase10_2555,fastCase10_2556,fastCase10_2557,fastCase10_2558,fastCase10_2559,fastCase10_2560,fastCase10_2561,fastCase10_2562,fastCase10_2563,fastCase10_2564,fastCase10_2565,fastCase10_2566,fastCase10_2567,fastCase10_2568,fastCase10_2569,fastCase10_2570,fastCase10_2571,fastCase10_2572,fastCase10_2573,fastCase10_2574,fastCase10_2575,fastCase10_2576,fastCase10_2577,fastCase10_2578,fastCase10_2579,fastCase10_2580,fastCase10_2581,fastCase10_2582,fastCase10_2583,fastCase10_2584,fastCase10_2585,fastCase10_2586,fastCase10_2587,fastCase10_2588,fastCase10_2589,fastCase10_2590,fastCase10_2591,fastCase10_2592,fastCase10_2593,fastCase10_2594,fastCase10_2595,fastCase10_2596,fastCase10_2597,fastCase10_2598,fastCase10_2599,fastCase10_2600,fastCase10_2601,fastCase10_2602,fastCase10_2603,fastCase10_2604,fastCase10_2605,fastCase10_2606,fastCase10_2607,fastCase10_2608,fastCase10_2609,fastCase10_2610,fastCase10_2611,fastCase10_2612,fastCase10_2613,fastCase10_2614,fastCase10_2615,fastCase10_2616,fastCase10_2617,fastCase10_2618,fastCase10_2619,fastCase10_2620,fastCase10_2621,fastCase10_2622,fastCase10_2623,fastCase10_2624,fastCase10_2625,fastCase10_2626,fastCase10_2627,fastCase10_2628,fastCase10_2629,fastCase10_2630,fastCase10_2631,fastCase10_2632,fastCase10_2633,fastCase10_2634,fastCase10_2635,fastCase10_2636,fastCase10_2637,fastCase10_2638,fastCase10_2639,fastCase10_2640,fastCase10_2641,fastCase10_2642,fastCase10_2643,fastCase10_2644,fastCase10_2645,fastCase10_2646,fastCase10_2647,fastCase10_2648,fastCase10_2649,fastCase10_2650,fastCase10_2651,fastCase10_2652,fastCase10_2653,fastCase10_2654,fastCase10_2655,fastCase10_2656,fastCase10_2657,fastCase10_2658,fastCase10_2659,fastCase10_2660,fastCase10_2661,fastCase10_2662,fastCase10_2663,fastCase10_2664,fastCase10_2665,fastCase10_2666,fastCase10_2667,fastCase10_2668,fastCase10_2669,fastCase10_2670,fastCase10_2671,fastCase10_2672,fastCase10_2673,fastCase10_2674,fastCase10_2675,fastCase10_2676,fastCase10_2677,fastCase10_2678,fastCase10_2679,fastCase10_2680,fastCase10_2681,fastCase10_2682,fastCase10_2683,fastCase10_2684,fastCase10_2685,fastCase10_2686,fastCase10_2687,fastCase10_2688,fastCase10_2689,fastCase10_2690,fastCase10_2691,fastCase10_2692,fastCase10_2693,fastCase10_2694,fastCase10_2695,fastCase10_2696,fastCase10_2697,fastCase10_2698,fastCase10_2699,fastCase10_2700,fastCase10_2701,fastCase10_2702,fastCase10_2703,fastCase10_2704,fastCase10_2705,fastCase10_2706,fastCase10_2707,fastCase10_2708,fastCase10_2709,fastCase10_2710,fastCase10_2711,fastCase10_2712,fastCase10_2713,fastCase10_2714,fastCase10_2715,fastCase10_2716,fastCase10_2717,fastCase10_2718,fastCase10_2719,fastCase10_2720,fastCase10_2721,fastCase10_2722,fastCase10_2723,fastCase10_2724,fastCase10_2725,fastCase10_2726,fastCase10_2727,fastCase10_2728,fastCase10_2729,fastCase10_2730,fastCase10_2731,fastCase10_2732,fastCase10_2733,fastCase10_2734,fastCase10_2735,fastCase10_2736,fastCase10_2737,fastCase10_2738,fastCase10_2739,fastCase10_2740,fastCase10_2741,fastCase10_2742,fastCase10_2743,fastCase10_2744,fastCase10_2745,fastCase10_2746,fastCase10_2747,fastCase10_2748,fastCase10_2749,fastCase10_2750,fastCase10_2751,fastCase10_2752,fastCase10_2753,fastCase10_2754,fastCase10_2755,fastCase10_2756,fastCase10_2757,fastCase10_2758,fastCase10_2759,fastCase10_2760,fastCase10_2761,fastCase10_2762,fastCase10_2763,fastCase10_2764,fastCase10_2765,fastCase10_2766,fastCase10_2767,fastCase10_2768,fastCase10_2769,fastCase10_2770,fastCase10_2771,fastCase10_2772,fastCase10_2773,fastCase10_2774,fastCase10_2775,fastCase10_2776,fastCase10_2777,fastCase10_2778,fastCase10_2779,fastCase10_2780,fastCase10_2781,fastCase10_2782,fastCase10_2783,fastCase10_2784,fastCase10_2785,fastCase10_2786,fastCase10_2787,fastCase10_2788,fastCase10_2789,fastCase10_2790,fastCase10_2791,fastCase10_2792,fastCase10_2793,fastCase10_2794,fastCase10_2795,fastCase10_2796,fastCase10_2797,fastCase10_2798,fastCase10_2799,fastCase10_2800,fastCase10_2801,fastCase10_2802,fastCase10_2803,fastCase10_2804,fastCase10_2805,fastCase10_2806,fastCase10_2807,fastCase10_2808,fastCase10_2809,fastCase10_2810,fastCase10_2811,fastCase10_2812,fastCase10_2813,fastCase10_2814,fastCase10_2815,fastCase10_2816,fastCase10_2817,fastCase10_2818,fastCase10_2819,fastCase10_2820,fastCase10_2821,fastCase10_2822,fastCase10_2823,fastCase10_2824,fastCase10_2825,fastCase10_2826,fastCase10_2827,fastCase10_2828,fastCase10_2829,fastCase10_2830,fastCase10_2831,fastCase10_2832,fastCase10_2833,fastCase10_2834,fastCase10_2835,fastCase10_2836,fastCase10_2837,fastCase10_2838,fastCase10_2839,fastCase10_2840,fastCase10_2841,fastCase10_2842,fastCase10_2843,fastCase10_2844,fastCase10_2845,fastCase10_2846,fastCase10_2847,fastCase10_2848,fastCase10_2849,fastCase10_2850,fastCase10_2851,fastCase10_2852,fastCase10_2853,fastCase10_2854,fastCase10_2855,fastCase10_2856,fastCase10_2857,fastCase10_2858,fastCase10_2859,fastCase10_2860,fastCase10_2861,fastCase10_2862,fastCase10_2863,fastCase10_2864,fastCase10_2865,fastCase10_2866,fastCase10_2867,fastCase10_2868,fastCase10_2869,fastCase10_2870,fastCase10_2871,fastCase10_2872,fastCase10_2873,fastCase10_2874,fastCase10_2875,fastCase10_2876,fastCase10_2877,fastCase10_2878,fastCase10_2879,fastCase10_2880,fastCase10_2881,fastCase10_2882,fastCase10_2883,fastCase10_2884,fastCase10_2885,fastCase10_2886,fastCase10_2887,fastCase10_2888,fastCase10_2889,fastCase10_2890,fastCase10_2891,fastCase10_2892,fastCase10_2893,fastCase10_2894,fastCase10_2895,fastCase10_2896,fastCase10_2897,fastCase10_2898,fastCase10_2899,fastCase10_2900,fastCase10_2901,fastCase10_2902,fastCase10_2903,fastCase10_2904,fastCase10_2905,fastCase10_2906,fastCase10_2907,fastCase10_2908,fastCase10_2909,fastCase10_2910,fastCase10_2911,fastCase10_2912,fastCase10_2913,fastCase10_2914,fastCase10_2915,fastCase10_2916,fastCase10_2917,fastCase10_2918,fastCase10_2919,fastCase10_2920,fastCase10_2921,fastCase10_2922,fastCase10_2923,fastCase10_2924,fastCase10_2925,fastCase10_2926,fastCase10_2927,fastCase10_2928,fastCase10_2929,fastCase10_2930,fastCase10_2931,fastCase10_2932,fastCase10_2933,fastCase10_2934,fastCase10_2935,fastCase10_2936,fastCase10_2937,fastCase10_2938,fastCase10_2939,fastCase10_2940,fastCase10_2941,fastCase10_2942,fastCase10_2943,fastCase10_2944,fastCase10_2945,fastCase10_2946,fastCase10_2947,fastCase10_2948,fastCase10_2949,fastCase10_2950,fastCase10_2951,fastCase10_2952,fastCase10_2953,fastCase10_2954,fastCase10_2955,fastCase10_2956,fastCase10_2957,fastCase10_2958,fastCase10_2959,fastCase10_2960,fastCase10_2961,fastCase10_2962,fastCase10_2963,fastCase10_2964,fastCase10_2965,fastCase10_2966,fastCase10_2967,fastCase10_2968,fastCase10_2969,fastCase10_2970,fastCase10_2971,fastCase10_2972,fastCase10_2973,fastCase10_2974,fastCase10_2975,fastCase10_2976,fastCase10_2977,fastCase10_2978,fastCase10_2979,fastCase10_2980,fastCase10_2981,fastCase10_2982,fastCase10_2983,fastCase10_2984,fastCase10_2985,fastCase10_2986,fastCase10_2987,fastCase10_2988,fastCase10_2989,fastCase10_2990,fastCase10_2991,fastCase10_2992,fastCase10_2993,fastCase10_2994,fastCase10_2995,fastCase10_2996,fastCase10_2997,fastCase10_2998,fastCase10_2999⟩
#print axioms aggregate_F10_002
end KernelCatalog
