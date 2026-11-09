# Source-data availability (RQ2, Head Start Impact Study)

Checked 2026-11-08 (UTC).

| Place checked | UTC date | Result |
|---|---|---|
| Chen (2021), Chapter 3, Dataset | 2026-11-08 | Uses the HSIS **restricted-use** dataset from ICPSR, accessed under agreement; 3,721 children after excluding crossovers and no-shows, 2,697 with a wave-1 spelling score. |
| [ICPSR 29462, Head Start Impact Study 2002-2006](https://www.icpsr.umich.edu/web/ICPSR/studies/29462) | 2026-11-08 | The study page offers a public download after free ICPSR sign-in and lists restricted-use files that need a signed Restricted Data Use Agreement through ICPSR's contracting system. The page wording suggests public-use data files; the next row records that the actual public download contains none. |
| ICPSR 29462 public download, version V7 (2018-02-08), `ICPSR_29462-V7.zip`, downloaded by the repository owner after free sign-in | 2026-11-08 | 58 files, 454 MB unpacked: user guide, overview, tips, instrument matrix, webinar, and codebooks/questionnaires for DS0001-DS0030. **No data files.** The manifest lists only documentation for every dataset, so the public route provides no analysable HSIS data. |
| [ICPSR 36968, HSIS 2002-2008 with Center Analysis File](https://www.icpsr.umich.edu/web/ICPSR/studies/36968) | 2026-11-08 | Related restricted collection; not checked further. |
| Restricted-use application by the repository owner | 2026-11-08 | The repository owner applied for the HSIS restricted-use data and could not obtain it (recorded in `REPLICATION-PLAN.yaml`, part `study-dissertation`, `reported_to_person`). |
| Chen (2021), appendices | 2026-11-08 | No analysis data or Mplus input for RQ2 is printed; Appendices A-B cover only the simulation. |

**Status: input unavailable.** The data files exist only as restricted-use files under a signed
ICPSR Restricted Data Use Agreement, which this project does not hold. The free public download
(checked above) contains documentation and codebooks only. RQ2's analyses (Tables 4.2-4.7,
Figures 4.1-4.11) therefore cannot be rerun.

**What is replicated without the data.** `secondary/table_arithmetic.py` recomputes all 24
differences and standardized biases printed in Tables 4.6-4.7 from the printed estimates. All
24 differences match (printed as RCT minus RDD). All 24 SB values match only when the divisor
is the printed standard error of the RCT **estimate**; equation 3.12 states the divisor is the
standard deviation of the RCT **outcome**.
