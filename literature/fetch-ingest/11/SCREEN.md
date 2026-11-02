# Screen for fetch issue 11

- Fetch issue: https://github.com/alectionary/vibe-math/issues/11
- Manifest id: `fetch-11-bepress-dissunl-339-verified`
- SHA-256: `73578ca2735961d7f37539dfa92377691eda47746e5f554c2e1005f000bd2517`
- Pages: 92
- PDF bytes: 5422038
- Unicode characters in the extracted text: 159895
- Question count in this screen: 3

The manifest `question_screen.status` stays `not_screened`. The count is the number of author-stated directions below. None is a numbered conjecture, and none is in the coverage denominator.

## Same file as the existing record

This PDF is the file already stored as source-manifest id `2025-Morris` and research source [MorrisDissertation2025](../../RESEARCH-SOURCES.md#morrisdissertation2025--analysis-of-graph-based-decoders-for-quantum-low-density-parity-check-codes). The SHA-256 matches `literature/research-source-index.json` and `source-manifest.json`. Bibliography row F187 points at that seed.

The earlier comparison in [LOOP-LITERATURE.md](../../../formalization/cyclic-lifts/LOOP-LITERATURE.md) used Chapter 5, Section 5.2, Table 5.1, and the Chapter 6 redundancy sentence. Those notes stay the comparison with the lifted-product merger experiments. They are not restated here as new questions. L-P34-decoding-effects and L-P34-base-design remain that investigation's targets. The three directions below are the dissertation's own Chapter 6 sentences.

Checked 2026-11-02 against the extracted text of this PDF. Line numbers are 1-based `str.splitlines()` on that text. A form feed counts as a line break.

## What the dissertation establishes

Kirsten Morris, *Analysis of Graph-based Decoders for Quantum Low Density Parity Check Codes*, University of Nebraska–Lincoln, August 2025. Record: https://digitalcommons.unl.edu/dissunl/339/. Adviser Christine A. Kelley. The file has the repository cover and 92 pages.

Chapter 6, PDF page 85, states the three ideas the dissertation investigated. Absorbing sets remain problematic for the Gallager B decoder in the quantum setting. Those structures are connected to symmetric stabilizers and placed among harmful Tanner-graph structures, namely partitions of absorbing sets. Adding redundant rows to the parity-check matrix improved decoding for quantum CSS codes formed by Hamming codes and for hypergraph-product codes constructed from Hamming codes, without changing the codespace. Extracted lines 3194–3207.

## Open questions

All three are in the Chapter 6 conclusion. Present-day resolution and Lean discovery were not assessed.

1. [L-F187-nonabsorbing-failure-sets](../../OPEN-PROBLEMS.md#l-f187-nonabsorbing-failure-sets). PDF page 85, extracted lines 3208–3212. “characterizing failure inducing sets that are not absorbing sets remains open.” The next sentence says it would be interesting to see if there is an overlying combinatorial description of these failure-inducing sets. That sentence is the form they want for the characterization, not a second target.

2. [L-F187-gallager-b-convergence-bound](../../OPEN-PROBLEMS.md#l-f187-gallager-b-convergence-bound). PDF pages 85–86, extracted lines 3214–3221. The graphical characterization that guarantees convergence of Gallager B “is quite strong.” The authors want to know whether the condition could be lightened, “perhaps by relaxing the number of iterations until guaranteed convergence to more than two.” The words “than two” are on PDF page 86, whose running header is printed page 74.

3. [L-F187-redundancy-other-families](../../OPEN-PROBLEMS.md#l-f187-redundancy-other-families). PDF page 86, printed page 74, extracted lines 3222–3227. Redundancy was studied for CSS codes from Hamming codes and for the hypergraph products of those codes. The authors say it would be interesting to see the effect of redundancy on other QLDPC families, “like the lifted product [28] or balanced product [3] code constructions.”

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The dissertation text, including the bibliography | 2026-11-02 | No supplement and no deposit of this dissertation's programs. The only “Python” occurrence is bibliography item [34], Roffe's LDPC Python tools (2022), a cited package rather than a program deposited with this thesis. |
| Named code host or author repository in the dissertation | 2026-11-02 | None named, so none was opened. |
| Holland Computing Center acknowledgment | 2026-11-02 | Names where the BP+OSD runs were done. It is not a code deposit. |
