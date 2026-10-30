[pure_x_thresholds_of_deformed_cubic_codes__replication_of_pesah_2021.pdf](https://github.com/alectionary/vibe-math/blob/abfdecb145fc1ef6f35a71c38d751dd721adec08/formalization/pesah-biased-cubic/paper/pure_x_thresholds_of_deformed_cubic_codes__replication_of_pesah_2021.pdf)

## What this is

A nine-page main paper and runnable numerical reconstruction of Arthur Pesah's *Tailoring 3D topological codes and decoders to biased noise* (UCL Master of Research dissertation, 1 September 2021; supervisor Dan Browne). This is an MRes dissertation, not his later PhD thesis. Initial doctoral screening did not yield an accessible suitable source with the required local evidence; the selected work bears the requested dissertation designation. The user did not specifically request Pesah or a doctoral substitution.

## Question and bounded scope

Does a Hadamard stabilizer deformation improve cubic-code tolerance of pure X noise under BP-OSD decoding? Table 3.1/Figure 3.5 reports 2.9% undeformed versus 7.4% deformed. Both arms are reconstructed at all published sizes, L=4,6,8,10, with 16,000 fresh trials over a new crossover grid. The dissertation's larger pure-Z result, rhombic code, other biases, SweepMatch and circuit noise remain outside scope.

## Findings

We partly replicate the selected headline: reported thresholds 2.9% and 7.4%, reconstructed 2.388% and 7.570%. The signed deformation advantage is +4.5 percentage points in the source and +5.182 in our primary fit. No headline reversal occurs. None of the three numerical comparisons matches at printed 0.1-point precision.

The undeformed gap lies outside a Bonferroni-adjusted conditional band; the deformed gap and signed difference lie inside. Original simulation counts and fit settings are unknown, so these are not full two-sample comparisons or equivalence findings. The primary advantage has a conditional simultaneous interval of [4.466, 5.897] points. Excluding one probability endpoint moves the undeformed estimate to 2.805–2.850%, showing substantial fit-window sensitivity. This is not evidence of author error.

## What ties together

The complete 66-page source supplies the code family, noise model, deformation, comparison and scaling formula. A historically plausible pre-submission bn3d commit is preserved in PanQEC. Our separately written incidence construction, sparse min-sum and integer OSD implementation matched historical matrices and all 240 test corrections. These checks share source definitions, error vectors, NumPy and machine; they are not a fully independent end-to-end replication.

Separate PCG64 and scalar MT19937 data generators each supplied 250 trials per condition; none of 32 generator comparisons exceeded its adjusted normal band. All 16,000 primary trials remain in the denominators, with zero uncorrected syndromes. All 800 bootstrap arm fits converged. Both source arms retain 192,648,1536,3000 qubits: zero deformation cost at every size.

## Map of the note

The opening states the selected headline and limits. The numerical section separates rounding, reconstruction scope and conditional uncertainty. Methods and assumptions identify shared dependencies and supplied settings. Ambiguities and sensitivity checks preserve the primary analysis while varying iterations, sorting, fitting objective, probability window, lattice-size range and generator. Dated availability/compliance ledger rows are copied into the main paper. References and an artifacts appendix link visible actual filenames, including editable manuscript and bibliography.

## How to check it

Follow `formalization/pesah-biased-cubic/README.md`: run the pilot, two-generator production simulation, iteration/tie diagnostics, analysis, original-reference validation, evidence crops, manuscript asset generation and LaTeX build. Source PDF and historical third-party code are fetched separately at immutable GitHub revisions. Only limited attributed source crops are retained; the full dissertation and historical code are not redistributed or relicensed.

The resource pilot preceded production; the main run used 773 wall seconds and 58.3 MiB resident memory within a 2,400-CPU-second / 2-GiB cap. The quantum engine departure is justified in preflight; SEM software is not applicable. Master navigation links await merge. No merge, author contact or X post is authorized by this PR.

## Open issue and next step

The original trial-level production archive, job inputs, environment and fit window would settle the largest remaining uncertainty. Current sensitivity checks explain much of the undeformed gap but do not identify its original cause.


Remote PDF, manuscript, bibliography, two evidence crops, evidence manifest, analysis and primary results were downloaded and SHA256 verified (8/8). [Editable manuscript](https://github.com/alectionary/vibe-math/blob/abfdecb145fc1ef6f35a71c38d751dd721adec08/formalization/pesah-biased-cubic/paper/manuscript.tex), [bibliography](https://github.com/alectionary/vibe-math/blob/abfdecb145fc1ef6f35a71c38d751dd721adec08/formalization/pesah-biased-cubic/paper/references.bib). Runnable reproduction: `47f111b60fbf668edc8fa6dfb4fb6a398d6da933`.
