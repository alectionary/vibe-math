# Screen for fetch issue 100

- Fetch issue: https://github.com/alectionary/vibe-math/issues/100
- Manifest id: `vibe-math-100-worker-20261109`
- SHA-256: `4cadbf1bbacdc7b21bb36479dbbadc0da5013c8c67f794bff0206d345e0b4156`
- Pages: 169
- PDF bytes: 3264677
- Unicode characters in the extracted text: 682580
- Question count in this screen: 7
- Bibliography row: F196, linking [formalization/denys-bosonic-pauli](../../../formalization/denys-bosonic-pauli/README.md)

The manifest `question_screen.status` stays `not_screened`. Checked 2026-11-09. Line numbers are 1-based `str.splitlines()` on the extracted text. A form feed counts as a line break. The fetch hash matches the thesis hash in that replication's source evidence. Re-replication assessment: [#111](https://github.com/alectionary/vibe-math/issues/111). This note does not redo that replication.

## What the thesis establishes

Aurélie Denys, *Quantum key distribution and quantum error correction with bosonic systems*, 2024. The fetched file is the PDF pinned at https://github.com/aurelie-denys/aurelie-denys.github.io/blob/5aefd7b6caca97df7bf49ece36c6c91ba955d0fc/PhDThesisAurelieDenys.pdf.

Chapter 1 gives an analytical bound on the asymptotic secret key rate of discretely modulated continuous-variable QKD under collective attacks. The pressing open question named at lines 4733–4737, a computable bound for arbitrary modulation, is the problem the chapter says it solves. That solved statement is not an inventory target. Chapters 2 and 3 construct multimode bosonic codes, including the 2T-qutrit and a two-mode qubit with a universal gate set built from passive Gaussian Cliffords plus controlled-rotation CZ and T.

## Open questions

Present resolution and Lean discovery were not assessed.

1. [L-F196-qpsk-analytical-bound](../../OPEN-PROBLEMS.md#l-f196-qpsk-analytical-bound). Chapter 1, extracted lines 4776–4779. For QPSK, the bound agrees with one reference and is more pessimistic than another, and the text asks whether a tighter analytical bound can be derived.

2. [L-F196-composable-general-attacks](../../OPEN-PROBLEMS.md#l-f196-composable-general-attacks). Chapter 4, extracted lines 9217–9219. A composable finite-size proof against general attacks is what is needed and is not given. Lines 6288–6289 leave the optimality of collective attacks among general attacks for later work. Those two sentences are one target.

3. [L-F196-2t-universal-gates](../../OPEN-PROBLEMS.md#l-f196-2t-universal-gates). Chapter 2, extracted lines 8095–8096. Whether the 2T-qutrit, or the 2T-qubit, has a universal gate set. The universal set later claimed for the two-mode Clifford code is a different code.

4. [L-F196-construction-relations](../../OPEN-PROBLEMS.md#l-f196-construction-relations). Chapter 4, extracted lines 9278–9281. How the coset, representation, and quantum-spherical constructions relate when one code comes from more than one of them.

5. [L-F196-exact-correction-criterion](../../OPEN-PROBLEMS.md#l-f196-exact-correction-criterion). Chapter 4, extracted lines 9287–9292. A criterion, of the kind cited for spin codes, for when the general constructions exactly correct physically relevant errors.

6. [L-F196-explicit-recovery](../../OPEN-PROBLEMS.md#l-f196-explicit-recovery). Chapter 4, extracted lines 9292–9293. Explicit error-correction procedures for these codes.

7. [L-F196-stabilizer-gate-tradeoff](../../OPEN-PROBLEMS.md#l-f196-stabilizer-gate-tradeoff). Chapter 4, extracted lines 9294–9296. Whether a trade-off between the number of stabilisers and the number of easily implemented gates exists, and how to quantify it. The Clifford code is given as an example that is not a stabiliser code.

The sentences on other constellations, other representations, and multi-qubit applications (lines 9203–9208 and 9299–9308) stay inside those directions. The claim that 64-state constellations are enough for the deployment question is a result of the thesis, not an open target.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| The thesis, software sentences | 2026-11-09 | Line 7490 says the Python files for the numerical analysis are available on Gitlab. No URL is printed. CVXPY and SCS are cited solvers. |
| Author Gitlab URL | 2026-11-09 | Not opened, because the thesis does not give one. |
| SCS citation, lines 9627–9628, https://github.com/cvxgrp/scs | 2026-11-09 | The cited solver, not the thesis scripts. The repository was not cloned. |

No help issue was filed. A missing URL is not a help issue when the sentence does not say the files are available only by email.
