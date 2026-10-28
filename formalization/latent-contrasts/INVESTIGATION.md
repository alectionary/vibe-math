# Orthogonal latent contrasts in Jeffries (2024)

Session `sess-jeffries-20261027T2155Z`. Canonical id `L-D055-orthogonal-latent-contrasts`. Bounded follow-up `RQ-D055-contrast-orthogonality`. Issue https://github.com/alectionary/vibe-math/issues/35. Work branch `cursor/jeffries-latent-contrasts-12b1`.

## Answer contract

Question: for the four contrast codes in Jeffries's Table 2.2, which sample-size-weighted products stay zero under equal group sizes and under the dissertation's imbalance pattern, and what values do equations (3.3)–(3.5) take on the printed latent means and after multiplication by the data-generating loading 0.7?

Intended answer: exact products and the three population contrasts on both scales.

Decisive evidence: `LatentContrasts/Orthogonality.lean`, built with `lake build`, and the 600 dpi crops of Table 2.2 and equations (3.3)–(3.5).

## Why this dissertation

The task is the next replicable University of Nebraska–Lincoln dissertation that uses factor analysis, after Mi (2009). Scores are 0, 1, or 2 on five checks: a formalizable claim, a published simulation or public dataset, an open-access copy, obtainable code or data, and a link to the catalog.

| Candidate | Formalizable | Simulation | Open copy | Code or data | Catalog | Decision |
|---|---:|---:|---:|---:|---:|---|
| Jeffries 2024, UNL-SEM-D055 | 2 | 2 | 2 | 1 | 2 | Selected |
| Kmail 2019, optimal design, UNL-SEM-D040 | 2 | 2 | 2 | 1 | 2 | Path model, no latent factor |
| Chumney 2013, small-sample SEM, UNL-SEM-D022 | 0 | 2 | 1 | 0 | 1 | Body was not in hand, and the claim is a simulation count |
| Green, curve-of-factors value-added | 1 | 2 | 0 | 0 | 1 | Open copy was not confirmed |
| Peugh 2006, specification searches, UNL-SEM-D004 | 1 | 2 | 0 | 0 | 1 | Not open-access; the author describes a path model |
| Koziol 2010, censored ordinal invariance | 1 | 2 | 2 | 0 | 0 | Master's thesis, outside the doctoral seed |
| Svoboda 2017, multilevel metric invariance | 1 | 2 | 2 | 0 | 0 | Master's thesis |
| Nord 2017, latent interaction with planned missingness | 1 | 2 | 2 | 0 | 0 | Master's thesis |

Jeffries wins because the design is a one-factor, four-indicator model, the contrast codes are explicit, Chapter IV prints a Monte Carlo, and the PDF is public. The companion article Jeffries and Bovaird (2026), catalog F119, DOI `10.1177/01466216261452255`, is not in hand. Fetch request: https://github.com/alectionary/vibe-math/issues/34.

The three theses are recorded here and were not added to the 99-dissertation seed.

## Source ledger

| Source | Found | Where it sits |
|---|---|---|
| Jeffries 2024 dissertation | 2026-10-27 | UNL-SEM-D055, screened, question count 0. PDF sha256 `a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3` |
| Jeffries and Bovaird 2026 | already F119 | `acquisition_requested`, issue 34 |
| Kmail 2019 and the Hindawi article | already D040 and F115 | Not selected. Path SEM |
| Chumney 2013 | already D022 | Not selected |
| Peugh 2006 | already D004 | Not selected |
| Koziol 2010, Svoboda 2017, Nord 2017 | 2026-10-27 | Master's theses. Not doctoral seed rows |

Direct `viewcontent` for the dissertation returned HTTP 403. The file used here is the Wayback `id_` object `https://web.archive.org/web/20250511025154id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1215&context=dissunl`. `pdfinfo` reports 191 pages, title and author matching Jeffries. `file(1)` is wrong about the page count and was not used.

Question screen: Chapter V, printed pages 139–142, asks for further simulations with non-normal or ordinal items, missing data, measurement non-invariance, formative models, and changing group membership. Those are empirical extensions. No author-stated mathematical conjecture was added to `questions.json`. The orthogonality identity is a project-derived follow-up, `RQ-D055-contrast-orthogonality`, and it is proved in this directory.

## Code and supplementary-material ledger

| Place checked | UTC date | Result |
|---|---|---|
| Dissertation Appendix A | 2026-10-27 | Obtained in the PDF above. Generation syntax only. Analysis model absent |
| GitHub repository search `Navigating Non-Orthogonality Jeffries` | 2026-10-27 | HTTP 200, 0 repositories |
| GitHub code search `Jeffries orthogonal latent` | 2026-10-27 | HTTP 429. Not a finished absence |
| OSF nodes with that dissertation title | 2026-10-27 | HTTP 200, 0 nodes |
| OSF `/v2/search/` | 2026-10-27 | HTTP 404 |
| Sage page for `10.1177/01466216261452255` | 2026-10-27 | HTTP 403. Supplement tab not readable |
| Unpaywall for that DOI | 2026-10-27 | Green location is the PubMed abstract. `url_for_pdf` is null |
| Europe PMC for that DOI | 2026-10-27 | `isOpenAccess` N, `hasPDF` N |
| Wayback for that DOI | 2026-10-27 | No snapshot |
| PMC13179297 | 2026-10-27 | HTTP 403. The page names an embargo through 2027-05-15 |
| R, simsem 0.5.16, lavaan 0.6.17, dynamic 1.1.0, as named in the dissertation | 2026-10-27 | lavaan 0.6.17 installed. simsem and dynamic not installed. The authors' scripts are not those packages |

Help request for the analysis script: https://github.com/alectionary/vibe-math/issues/33.

## What was checked before any difference was called a discrepancy

The 600 dpi crops of Table 2.2, equation (2.4), the population parameters, equations (3.3)–(3.5), Tables 4.1, 4.2, and 4.3, and the Appendix A lines for the intercept and for `c3` match the text layer. The Prince text layer is not the source of the sign or the contrast averages.

The identifications were then turned on one at a time. Marker scaling reproduces averages near -0.28, -0.14, and 0. Fixing the loadings at 0.7, or fixing the latent variance at 0.50, reproduces averages near -0.40, -0.20, and 0. Percent significant moves much less, because the standard error scales with the contrast. Both readings remain open until the analysis script is obtained. The note does not attribute the scale gap to an author error.
