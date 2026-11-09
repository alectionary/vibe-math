# Screen for fetch issue 102

- Fetch issue: https://github.com/alectionary/vibe-math/issues/102
- Manifest id: `vibe-math-102-worker-20261109`
- SHA-256: `f08f3ede0cfbd5411ca20cc223d5bed079fa9aefd1484805ba80cfc1360a4ea0`
- Pages: 66
- PDF bytes: 2697804
- Unicode characters in the extracted text: 120577
- Question count in this screen: 6
- Bibliography row: F198, linking [formalization/pesah-biased-cubic](../../../formalization/pesah-biased-cubic/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches the thesis hash in that replication's evidence manifest. Re-replication assessment: [#107](https://github.com/alectionary/vibe-math/issues/107). This note does not redo that replication.

## What the thesis establishes

Arthur Pesah, *Tailoring 3D topological codes and decoders to biased noise*, MRes thesis, University College London, submitted 1 September 2021. Fetched file: https://github.com/artix41/artix41.github.io/blob/b4f401e0c12b44be4c69318e0015f70d8a3d3f98/assets/pdf/master-thesis-ucl.pdf.

The thesis deforms the 3D toric code in the manner of the XZZX surface code, compares SweepMatch and BP-OSD under biased noise, and reports thresholds for the cubic and rhombic lattices. Chapter 4 says the manuscript results are still preliminary and lists more lattice sizes and a finite-size scaling revision as work the authors plan before publication. That publication list is not an inventory target. The six avenues that follow are.

## Open questions

Present resolution and Lean discovery were not assessed. All six are in Chapter 4, extracted lines 2013–2042.

1. [L-F198-bposd-improvements](../../OPEN-PROBLEMS.md#l-f198-bposd-improvements). Item 1, lines 2015–2022. Improve BP-OSD, including message noise or memory effects for degeneracy, and higher-order OSD.

2. [L-F198-coprime-dimensions](../../OPEN-PROBLEMS.md#l-f198-coprime-dimensions). Item 2, lines 2024–2026. Threshold of the 3D code with coprime dimensions.

3. [L-F198-open-boundaries](../../OPEN-PROBLEMS.md#l-f198-open-boundaries). Item 3, lines 2028–2030. Non-periodic boundary conditions.

4. [L-F198-measurement-errors](../../OPEN-PROBLEMS.md#l-f198-measurement-errors). Item 4, lines 2032–2033. Measurement errors in the threshold estimates.

5. [L-F198-statphys-threshold](../../OPEN-PROBLEMS.md#l-f198-statphys-threshold). Item 5, lines 2035–2037. A statistical-physics model for the deformed-code threshold. Lines 236–237 already leave that evaluation as future work. The conclusion says collaborators had started it.

6. [L-F198-biased-2d-3d](../../OPEN-PROBLEMS.md#l-f198-biased-2d-3d). Item 6, lines 2039–2042. Repeat a cited 2D-versus-3D comparison with deformations and biased noise.

The interface remark at lines 1399–1403, that the viewer might suggest new deformations, is not a separate target.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The thesis, software sentences | 2026-11-09 | BP-OSD and the rhombic code were implemented in the collaboration library `bn3d`. No URL for that library is printed. Lines 1401–1403 say the authors consider putting the interface online. It is not given as a URL. |
| Named code host | 2026-11-09 | None printed, so none was opened. |

No help issue was filed.
