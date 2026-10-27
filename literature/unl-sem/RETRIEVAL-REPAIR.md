# Dissertation retrieval correction

Follow-up to [issue #5](https://github.com/alectionary/vibe-math/issues/5) and [PR #6](https://github.com/alectionary/vibe-math/pull/6), October 26, 2026. The PR description is unchanged.

Earlier fetch failures did **not** establish that the dissertations were inaccessible. This continuation reopened all 99 archive records, followed all 99 Download controls (127 requests including alternate records), resolved94 publisher records through the publisher-documented OpenURL route, and ran99 exact-title PDF-discovery queries. The archive download responses were browser challenges. The browser extension connection itself failed before site interaction; this is a tool failure, not an access restriction.

## Recovered texts and source questions

Seven complete dissertations were recovered and question-screened; one additional PDF contains only nine pages of front matter and is not counted as a full text. One complete PDF had garbled character mapping; all 188 pages were OCRed and a relevant page visually checked. No new precise mathematical conjecture or completed proof was recorded. The source-stated empirical and measurement-development directions below remain visible rather than being mislabeled as zero research questions.

| Seed | Complete PDF pages | Main future-work locator | Source-stated direction |
| --- | ---: | --- | --- |
| UNL-SEM-D016 — Hosek, Angela M | [310](https://fileserver-az.core.ac.uk/download/17246756.pdf) | Limitations and future directions, printed pp225–234 (PDF pp238–247) | Test teacher/student communication and group-identity relationships in different populations and student–student interactions. Develop or refine measures of shared social identity in instructional contexts. |
| UNL-SEM-D017 — Sarah J. Beal | [203](https://www.mobt3ath.com/uplode/book/book-22677.pdf) | Future Directions, printed pp109–116 (PDF pp119–126) | Validate and compare definitions and measures of future orientation. Study domain/affect-specific measurement structures across populations, ages and time. |
| UNL-SEM-D066 — Kristin H. Javorsky | [170](https://fileserver-az.core.ac.uk/download/20266573.pdf) | Interpretation, implications and future directions, printed pp102–115 (PDF pp113–126) | Compare word/punctuation versus icon knowledge and technology-exposure groups. Refine interactivity items, examine developmental dimensionality, and test retention of dynamically taught knowledge. |
| UNL-SEM-D067 — Daniel H. Abbott | [283](https://www.proquest.com/docview/305217740) | Research Questions, printed p10 (PDF p24); future-work passages printed pp137–155 and Future Research pp197–203 (PDF pp211–217) | Develop revised CTSE/CPSE inventories and short forms using smaller indicator subsets. Explore forced-choice/conjoint measurement instead of Likert-type responses. Test longitudinal and intervention hypotheses about creative self-efficacy and creative expression. |
| UNL-SEM-D079 — Tanya I. Razzhavaikina | [242](https://www.proquest.com/docview/304839716) | Limitations and Implications for Research, printed pp165–173 (PDF pp181–189) | Replicate across mandated-client populations, therapists, settings and counseling stages. Develop therapy-specific hope measures and collect larger samples or independent ratings. |
| UNL-SEM-D084 — Bejerano, Arleen R | [188](https://fileserver-az.core.ac.uk/download/20266887.pdf) | Limitations of Study and Directions for Future Research, printed pp122–125 (PDF pp134–137); complete body OCRed | Examine demographic and transition-duration differences in college adaptation. Replace observed composites with multidimensional latent constructs and test additional mediators or situational variables. |
| UNL-SEM-D089 — Stacy Tiemeyer | [298](https://fileserver-az.core.ac.uk/download/189479071.pdf) | Methodological limitations, printed pp72–75 (PDF pp83–86); Conclusion pp171–172 (PDF pp182–183) | Explore harmonized data repositories for cross-survey imputation applications. Refine pregnancy-intention measurement and use longitudinal data and broader populations. |

The two mathematical follow-up formulations in [seed-screening.json](seed-screening.json) are **project-derived**: short-form information loss under a fixed factor model, and joint-distribution identification under a specified cross-survey bridge model. The dissertation authors did not pose those exact mathematical questions. These formulations are outside the canonical question/eligible-target counts.

## Remaining routes and scope

The 94 inspected ProQuest pages comprise two open-access PDF pages and 92 preview pages that explicitly describe institutional access or purchasing the complete text. This observation applies to that publisher route only; some corresponding dissertations also have public copies elsewhere. Five archive records have no established ProQuest route in this pass. The current cohort therefore has seven recovered complete texts, one partial preview and 91 records without a recovered PDF. The 92 records lacking complete texts retain null question counts. No blanket inaccessibility status is used.

The mirrors also recovered three associated articles, including one previously selected access gap. These were screened separately: physiological adaptation, marketing-capability replication and couple-level fertility-intention questions require empirical observations. The associated bibliography now contains 41 source works, 24 full-text screens and 17 remaining source-work text gaps. The shared inventory retains 373 canonical entries, 150 precise eligible targets and six completed Lean targets; bibliography/source-screen totals become 176/146. The seven dissertation screens are recorded separately from those source-work counts and from the original 20 complete reviews.

## Evidence and verification

- [Every seed's archive/publisher route and current disposition](retrieval-audit.json).
- [Complete dissertation PDF identities, hashes and extraction/OCR methods](seed-source-manifest.json).
- [Question-screen locators, source-stated directions and mathematical suitability](seed-screening.json).
- [99 exact-title discovery queries and metadata-only result leads](retrieval-searches.json).
- Official publisher [OpenURL instructions](https://supportcenter.clarivate.com/articledetail?id=kA0400000004JHqCAM) establish the publication-number resolver syntax. Temporary signed PDF tokens and copyrighted bodies are excluded from Git.

The dated first-pass and CFA expansion snapshots remain historical. Current generated reports and CSV use the corrected per-seed dispositions. Earlier403 attempts remain in the ledgers as route failures. The repository research skill now records archive/publisher redirects, the supported browser-extension fallback, complete-versus-preview validation and OCR when text extraction is garbled.

| Requirement | Evidence | Outcome |
| --- | --- | --- |
| Revisit every original retrieval gap | retrieval-audit.json: 99 rows, 94 publisher records, 99 title queries | Met for bounded route attempts; 92 complete-text recoveries remain outstanding |
| Screen each recovered complete dissertation | seed-screening.json and seed-source-manifest.json:seven sources | Met; applied/empirical directions distinguished from mathematical targets |
| Reject partial or unreadable extraction as a full review | D018 nine-page front matter excluded; D084 all 188 pages OCRed | Met |
| Preserve prior evidence and correct current labels | dissertations.json access_history/current access; generated report and CSV | Met |
| Publish updates through existing PR without editing its description | PR #6 branch and read-back verification | Verified at handoff |

Question answered: earlier route-failure labels were corrected for all 99 seed records, and seven recovered dissertations received source-question screens. No mathematical conjecture was resolved.

Question still open: source-question harvesting from the92 dissertation bodies not yet recovered in full, plus17 associated source-work text gaps.

Next proposed target — follow-up: restore the supported Edge connection to handle the archive's browser challenges, then continue the remaining complete-text recoveries; mathematical follow-up formulations are separate optional research targets.
