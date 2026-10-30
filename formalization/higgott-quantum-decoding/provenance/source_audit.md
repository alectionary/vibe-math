# Source audit, 2026-10-30

Source: Oscar Higgott, *Practical and Efficient Quantum Error Correction*, UCL doctoral thesis, institutional year 2024. The title page says submitted October 1, 2023. Library identity: libfile_bd6cc8a2cc288191aa6c0418f4ff661d. Local PDF bytes remain unavailable; the Library text is accessible. Source-page crops are being supplied independently.

Read: chapter 7, printed pages 149–180; relevant decoder definitions, pages 41–56; Appendix E, page 240; front matter pages 1–12; conclusions pages 181–183. Other dissertation chapters have not been fully reviewed or replicated. The extracted passages in this preparation directory are source-reading records, not newly authored findings.

## Selected result and metric

The target is the small-example comparison in section 7.3.3 and Figure 7.14a, with Table 7.2 parameters as supporting checks. Figure 7.14b is conditional on reconstructing and independently checking the missing noisy 64-qubit circuits and running all three planar comparison sizes (d=2,3,4), not just the favorable d=3 comparison.

Page 173, Figure 7.11 caption explicitly defines logical failure throughout the study as ANY encoded logical qubit failing. Page 175, Figure 7.12 caption transforms the single-patch rate into 1-(1-p_log)^674. For Figure 7.14 we therefore use 0.5*[1-(1-p_X)^4 + 1-(1-p_Z)^4] for four independent planar patches, and the average of X- and Z-basis four-observable block failures for Bolza. The average per-observable failure rate is a different estimand.

## EM3 noise

Page 164 specifies a probability-p uniform mixture over 32 Pauli/measurement-flip possibilities, including identity/no flip; preparation and readout error probability is p/2. A direct independent convolution of the supplied circuit's 31 nonidentity binary generators gives the prescribed joint distribution when q=[1-(1-p)^(1/16)]/2. At p=.001 the maximum absolute discrepancy is 7.8e-16. Supplied circuit q is rounded to 3.12647e-05; reconstruction must use the full-precision expression and preserve correlated events. The simulation-only measurement qubit indexed 16 does not count as physical EM3 hardware.

## Duration remains unresolved

Page 157 defines one round as three subrounds, and page 162 explicitly describes six subrounds as two rounds. Figure 7.14 says 16 rounds. The supplied clean circuits contain exactly 96 MPP layers, so their 96-subround filename is accurate and corresponds to 32 of those rounds. Pilot rates at p=.001 for the 96-subround circuits are about .25. Do not relabel 96 as 16 rounds. Compare both 48 and 96 subrounds, preserving initial/final boundary operations, and compare the no-correction curve as well as corrected rates against the independently digitized figure.

## Logical basis remains unresolved

The source repository explicitly states its Bolza representatives differ from the paper's symplectic basis. For any invertible binary transformation A within a measured four-dimensional logical sector, e=0 iff Ae=0, so the block-failure event is basis-invariant. This algebra alone does not prove that the supplied operators span the published sector. That span/rank check remains necessary; it would not justify comparing average per-observable error rates.

## Preparation checks

All ten supplied l=1/l=2 circuits produced zero detector and observable events in 4096 noiseless samples each. Stim found graphlike distance two for all six supplied noisy l=1 circuits (X/Z, EM3/SD6/DP1). These checks validate supplied circuit data, not independent lattice construction. The 64-qubit noisy circuit distances remain uncomputed. R/lavaan/OpenMx SEM requirements are not applicable to this quantum decoding study.

## Pilot plan

Before final runs: verify the basis span, reconstruct 48-subround boundaries, independently construct the EM3 channel from categorical events, compare against supplied 96-subround EM3 circuits, and validate planar generator outputs after authorization. Use a fixed-shot grid p=(0.0005,0.001,0.002,0.005,0.01,0.02), both bases and both durations. Start with 4096 shots per arm, then fixed 200000 shots per arm where feasible. Keep batch size at most 8192, one process initially, and checkpoints per condition. Use simultaneous uncertainty bands with documented multiplicity, and distinguish figure-digitization uncertainty from Monte Carlo uncertainty. No timing claim is portable beyond this machine.

The l=1 EM3 pilot took about .05 seconds per 4096 shots including construction and noiseless checks; the pilot suggests a modest final workload, but all planar and l=2 arms require their own measured timing before committing to final sample counts.

External comparator code has been read but not executed or installed. Its execution remains pending explicit authorization, as instructed by the coordinating reviewer. No publication is authorized.

## Superseding completion checkpoint

The user subsequently authorized external generator execution. Primary and diagnostic simulations, historical software, independent optimizers/channels, and all comparator arms are complete. Preparation-only pending statements above are chronological records, not current blockers. See checkpoint.json, README.md, and the final report for current results. Source-page crops are delivered as Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf, Library libfile_00168a0941b881918bd1d5086249da3a.
