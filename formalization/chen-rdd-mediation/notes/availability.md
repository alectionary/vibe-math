# Source-data availability (RQ2, Head Start Impact Study)

Checked 2026-11-08 (UTC).

| Place checked | UTC date | Result |
|---|---|---|
| Chen (2021), Chapter 3, Dataset | 2026-11-08 | Uses the HSIS **restricted-use** dataset from ICPSR, accessed under agreement; 3,721 children after excluding crossovers and no-shows, 2,697 with a wave-1 spelling score. |
| [ICPSR 29462, Head Start Impact Study 2002-2006](https://www.icpsr.umich.edu/web/ICPSR/studies/29462) | 2026-11-08 | Documentation and **public-use** data files are downloadable after free ICPSR sign-in; restricted-use files need a signed Restricted Data Use Agreement through ICPSR's contracting system and are not available for direct download. |
| [ICPSR 36968, HSIS 2002-2008 with Center Analysis File](https://www.icpsr.umich.edu/web/ICPSR/studies/36968) | 2026-11-08 | Related restricted collection; not checked further. |
| Chen (2021), appendices | 2026-11-08 | No analysis data or Mplus input for RQ2 is printed; Appendices A-B cover only the simulation. |

**Status.** The restricted-use files the dissertation used are not obtainable here. Whether the
public-use files contain the variables used (treatment assignment, Woodcock-Johnson III spelling
at waves 1 and 3, parent-reported minutes the child enjoys being read to at wave 2, caregiver
age, child age, child gender) has not been checked: downloading them needs an ICPSR sign-in
and acceptance of ICPSR's terms, which only the repository owner can give. Even with those
files, a public-use replication would be a different dataset from the one analysed.

**What is replicated without the data.** `secondary/table_arithmetic.py` recomputes all 24
differences and standardized biases printed in Tables 4.6-4.7 from the printed estimates. All
24 differences match (printed as RCT minus RDD). All 24 SB values match only when the divisor
is the printed standard error of the RCT **estimate**; equation 3.12 states the divisor is the
standard deviation of the RCT **outcome**.
