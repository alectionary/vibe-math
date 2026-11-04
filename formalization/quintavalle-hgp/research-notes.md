# Research and scope record

This is an incomplete whole-dissertation replication attempt, with a complete chapter/appendix accounting. Successful finite checks are not universal proofs. The research plan was committed before analysis (`37d61d0b`), with explicit appendix reconciliation in `bde0771d`.

## Decisive computational evidence

`results/exact_checks.json` records exact binary computations. The six named code instances are planar distance 3 and 5, toric distance 2 and 3, and the source's 65- and 98-qubit Hamming constructions. Below-half-distance phase-flip error tests cover 1,061 errors. All 8,192 physical phase-error patterns of planar3 and all 256 of toric2 are classified, retaining failures outside the guarantee. The logical-line basis is additionally checked for all 256 ordered pairs of binary 2-by-2 seed matrices. These share seed inputs and definitions with the construction; an independent integer-XOR rank algorithm guards a subset of implementation assumptions.

All 9 of 9 Chapter 4 Appendix B rows match n, k, seed distance and maximum stabilizer weight. Quantum distances here inherit the cited HGP theorem; they were not exhaustively searched. The rate computations are retained separately. The rendered Hamming matrices on PDF pages 68 and 69 were inspected; the phase convention is not settled by those matrices.

`results/independent_checks.json` compares independent sparse tensor construction with all 19 archived original Hx and metacheck matrices. All match entry for entry. It also checks rank, CSS identities, logical independence and toric syndrome-validity checks. An initial sparse rank failure came from treating explicitly stored zero entries as ones; removing zeros resolves all 19 instances. This was our implementation defect.

For the 12-qubit 3D surface instance, all 4,096 error words yield 128 syndrome classes. The exact shadow-decoder check covers 31,232 syndrome/error-noise pairs. Reduced weight follows the source definition (minimum among all same-syndrome errors), not minimization only modulo stabilizers. This is a finite diagnostic of confinement and the residual bound, not a proof of a sustainable threshold.

## Gate comparisons and checks on our side

Square Hadamard-SWAP and CZ-S checks preserve both stabilizer support and phase for every tested instance. Literal sibling-CZ has 16 negative generator images in the source's 98-qubit symmetric Hamming example. A separate computational-basis calculation evaluates the CZ phase on the zero word and each X-generator word and obtains the same sign failures. This is independent of the Pauli conjugation implementation. A Z-Pauli correction solves the resulting sign syndrome for truly symmetric seeds and repairs all signs, but changes the implemented gate.

The cyclic 3-by-3 repetition seed satisfies the source's weaker equality-of-images definition, yet literal same-coordinate sibling Hadamard-SWAP fails stabilizer support preservation. Restricting to truly symmetric matrices removes that support failure; it does not remove the Hamming sibling-CZ sign failure. Finite diagonal-twin Z-sector distances are 3 (planar3), 2 (toric2), and 3 (toric3), rather than the extracted floor(d/2) equality. Reading that expression as a conservative lower bound changes its interpretation. Exact X-sector/fully formal generalization has not been certified.

These are retained as candidate source-comparison gaps. They are not established source errors. The thesis PDF was obtained and read. PDF pages 67–69 (zero-based pages 66–68) and the gate figures on pages 70–72 were inspected. The drawings match their captions. The weaker symmetry and Pauli-frame conventions are not settled by those drawings. The arXiv author manuscript is not the thesis. No formal proof is claimed.

Round-robin scheduling passes all 361 ordered support-size pairs from 1 through 19. Ideal logical CZ action is checked on all 256 left/right logical pairs of the 98-qubit example. These checks do not validate intermediate noisy correction or a gate threshold. Two ideal injection branches are algebraically checked as a related diagnostic. The rendered injection circuits on PDF page 72 were inspected; noisy injection was not run.

## Numerical design and measured stopping basis

ReShape runs cover a reconstructed toric grid of 56 settings, 10,000 trials each (560,000 total), at the four distances explicitly discussed in the source text. Uniform and binomial generators contribute 5,000 trials each. The independent generic GF(2) and batched recurrence decoders agree off even-distance ties; source tie/complement choices are not known. The exact source probability grid and random (3,4) seeds were not recovered, so this is not full Figure 4 reproduction. Wilson intervals and a prespecified 56-cell Bonferroni family describe only our binomial sampling error. Original sampling uncertainty is unknown.

The pinned original BP+OSD-twice implementation was run on eight reconstructed failure-subroutine conditions (four q values, with/without repair), each with 10,000 trials. L=5, data p=0.1, one noisy cycle, then the original program's final perfect-measurement round with fresh data noise. Source production depth and exact point grid are not recovered. Default BP methods differ between original toric and surface demo inputs; these are retained rather than silently standardized.

The Release code-capacity grid finished at 10,000 trials for toric L=5, 7, 9, 11 and surface L=5, 7, 9. Two toric L=11 points, p=.18 and p=.20, were topped up to 10,000 after an eight-hour limit. Combined failures are 257 and 2,374. Toric L=9 and L=11 cross between p=.21 and p=.215, beside the reported 21.55(1)%. Surface L=3 aborts in the pinned binary before any trial. Surface L=11 matrices are absent. No critical-exponent fit and no sweep comparison were computed.

The N=8 curves at L=5 and L=7 finished. Toric sizes cross between p=.025 and p=.03. Surface sizes cross between p=.03 and p=.035. The N=8 grids at L=9 and L=11 were declined for this project's compute limit, about 54 CPU-hours per toric L=11 point. That limit is ours. MWPM is not in the archive. The below-threshold wing still has fewer than 25 failures at the smallest probabilities, so no suppression slope was fit.

Thus 0 of 4 sustainable threshold estimates, 0 of 2 code-capacity fits, 0 of 2 suppression exponents, and 0 of 3 random-product code performance analyses are fully reproduced. The finished curves are not those fits. Denominators are not reduced.

## Theory accounting

Chapter 3 Appendices A–C supply complement existence, the product homology decomposition and the invariant/correctness proof. Finite tests cover these constructions but are not a new universal proof. Chapter 4 Appendix A supplies strongly triangular reduction; our RREF kernel coordinates independently verify the needed line pairing, not its exact implementation or asymptotic cost. Chapter 5 Appendix A's closeness-weight lemmas and percolation proof, Appendix C's inheritance lemmas, and Appendix D's expander argument were inventoried but not independently re-proved or formalized. Appendix B is covered computationally by matrix/locality checks, while Appendix E's fits remain unrun because adequate comparable data were not produced. Chapter 6's open problems remain open. The introductory and overview chapters are background/synthesis, not independent original empirical studies.
