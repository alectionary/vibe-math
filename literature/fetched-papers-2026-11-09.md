# Question screen of fetch issues 93–102 and 114

Checked 2026-11-09. Copyrighted PDFs are not committed. Another checkout reacquires a file from the stable id and checks the hash. The per-issue notes are under [fetch-ingest](fetch-ingest/).

| Issue | Record | Linked existing source | SHA-256 | Pages | Question count |
|---|---|---|---|---:|---:|
| [#93](https://github.com/alectionary/vibe-math/issues/93) | F189 | No bibliography row. Unmerged PR #90 is not a source on master. | `892f11399bca12d53b75bcc8131bef52539dd78f254d9117a20b253e9e7828e9` | 204 | 1 |
| [#94](https://github.com/alectionary/vibe-math/issues/94) | F190 | UNL-SEM-D067 and formalization/abbott-ctse | `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a` | 283 | 0 |
| [#95](https://github.com/alectionary/vibe-math/issues/95) | F191 | UNL-SEM-D022 and formalization/chumney-sem-small-samples | `1b067efef410ac3ae412e3a26a7b29bf1f8e50e935d219353fbe16ce8a853007` | 146 | 0 |
| [#96](https://github.com/alectionary/vibe-math/issues/96) | F192 | formalization/kupzyk-power-assumptions | `368dc575d9f744bf5ca5516873a633691d999fbdd5d19516994c64e10674896a` | 143 | 0 |
| [#97](https://github.com/alectionary/vibe-math/issues/97) | F193 | UNL-SEM-D055 and formalization/latent-contrasts, same bytes | `a21df98c20401491e6b4a1d00a21b6f7cee5551a00c04a89fb414ec6cfd469b3` | 191 | 0 |
| [#98](https://github.com/alectionary/vibe-math/issues/98) | F194 | formalization/polytomous-person-fit | `86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b` | 280 | 1 |
| [#99](https://github.com/alectionary/vibe-math/issues/99) | F195 | formalization/higgott-quantum-decoding | `3b5106e86960fc3516727b2eef22107f901dd77654bf709cf2cda3f855b236bb` | 266 | 6 |
| [#100](https://github.com/alectionary/vibe-math/issues/100) | F196 | formalization/denys-bosonic-pauli | `4cadbf1bbacdc7b21bb36479dbbadc0da5013c8c67f794bff0206d345e0b4156` | 169 | 7 |
| [#101](https://github.com/alectionary/vibe-math/issues/101) | F197 | formalization/moss-score-reliability | `0d4aa07b8fef0df14b47a43412a3356d652afed80e371a4be2712c417a5ad458` | 44 | 0 |
| [#102](https://github.com/alectionary/vibe-math/issues/102) | F198 | formalization/pesah-biased-cubic | `f08f3ede0cfbd5411ca20cc223d5bed079fa9aefd1484805ba80cfc1360a4ea0` | 66 | 6 |
| [#114](https://github.com/alectionary/vibe-math/issues/114) | F199 | formalization/koziol-weighted-multilevel | `b64a3c3fdeb43040875b88560b69d3b9b4f23c1a45b05f0834204e624a56eece` | 222 | 0 |

None of these papers already had an F-number. F189–F199 are the new rows. Jeffries is the same PDF as UNL-SEM-D055. Abbott's fetch hash is the abbott-ctse copy and is not the UNL-SEM-D067 seed hash; the seed hash stays. Chumney's campaign row now records the fetch hash and still sits outside the eight locked seed screens, so its campaign question count stays null.

## Hashes that differ from an earlier record

Issue 93: this file is SHA-256 `892f11399bca12d53b75bcc8131bef52539dd78f254d9117a20b253e9e7828e9`, 204 pages. The manifest notes name the issue's previously verified copy `9206b3d824077d36c86b4935ff7f19f64b3fdebde7746943b8a94500fe11e557`, described as 203 pages. Title and author match. The earlier file was not opened again.

Issue 96: this file is SHA-256 `368dc575d9f744bf5ca5516873a633691d999fbdd5d19516994c64e10674896a`, 143 pages. The manifest notes, and formalization/kupzyk-power-assumptions, name `c3b7af14877156cf6506e1c3c4ea57b23bcba6ce2139cf82bdce8417c451a1d1`, also described as 143 pages. Title and author match. The earlier file was not opened again.

Issue 94 is a third pair, already recorded in the abbott-ctse ledger: the fetch hash matches that replication, and the UNL-SEM-D067 seed hash is different. Both copies are described as 283 pages.

## Questions

Chen's one target is L-F189-rdd-mediation-ci-correction. Beck's one target is L-F194-polytomous-generalizations. Higgott's six targets are L-F195-realtime-decoder, L-F195-belief-matching-speed, L-F195-qldpc-decoder-runtime, L-F195-memory-in-computation, L-F195-sigf-other-codes, and L-F195-floquet-variants. Denys's seven targets are L-F196-qpsk-analytical-bound, L-F196-composable-general-attacks, L-F196-2t-universal-gates, L-F196-construction-relations, L-F196-exact-correction-criterion, L-F196-explicit-recovery, and L-F196-stabilizer-gate-tradeoff. Pesah's six targets are L-F198-bposd-improvements, L-F198-coprime-dimensions, L-F198-open-boundaries, L-F198-measurement-errors, L-F198-statphys-threshold, and L-F198-biased-2d-3d.

Abbott, Chumney, Kupzyk, Jeffries, Moss, and Koziol have question count 0. Their future-work passages are measurement development, simulation extensions, or findings the paper already states. Denys's general asymptotic-rate question is solved in Chapter 1 and is not a target.

Re-replication assessments, not redone here: [#103](https://github.com/alectionary/vibe-math/issues/103) Kupzyk, [#104](https://github.com/alectionary/vibe-math/issues/104) Koziol, [#105](https://github.com/alectionary/vibe-math/issues/105) Jeffries, [#106](https://github.com/alectionary/vibe-math/issues/106) Higgott, [#107](https://github.com/alectionary/vibe-math/issues/107) Pesah, [#108](https://github.com/alectionary/vibe-math/issues/108) Chumney, [#109](https://github.com/alectionary/vibe-math/issues/109) Beck, [#110](https://github.com/alectionary/vibe-math/issues/110) Abbott, [#111](https://github.com/alectionary/vibe-math/issues/111) Denys, [#112](https://github.com/alectionary/vibe-math/issues/112) Moss. Chen has no issue in that range. Issue #113 is the correlated-residual re-replication and is not one of these papers.

Present resolution and Lean discovery were not assessed. The counts live in the screen notes. The manifests stay `not_screened`.

## Closeout

**Question answered:** none. This block screened the eleven texts and recorded twenty-one author-stated directions. It did not prove any of them.

**Question still open:** the twenty-one ids above. Present-day resolution of each is unassessed. Six of the eleven papers contributed no inventory target.

**Next proposed target (follow-up):** A current-resolution check of L-F196-2t-universal-gates against later notes on the 2T-qutrit, before any formalization. The 2024 label in the thesis is not that check.
