# Fresh fit diagnostics and general binary-algebra milestone

Whole-dissertation objective remains **open**. Preserve all earlier primary, normalized and wider-grid outputs. This follow-up uses 112000 fresh trials, frozen configs and source-independent grids; it does not replace earlier fits. The original pure-X results remain untouched.

## Reproduce

Use the pinned Python dependencies and original native OSD build in `../expansion/README.md`. From the repository root, run each config with `expansion/run.py CONFIG OUTPUT`; the three configs here have corresponding `.json` output filenames without `-config`. At most two concurrent runners, each capped at 2GiB/2400CPU seconds. Pilots are excluded from production counts. Then:

```
python formalization/pesah-biased-cubic/followup/analyze_fresh.py
python formalization/pesah-biased-cubic/followup/validate.py
LEAN=/path/to/lean-4.22.0/bin/lean sh formalization/pesah-biased-cubic/followup/lean/build.sh
```

Lean uses Std only, version4.22.0 (commit ba2cbbf09d4978f416e0ebd1fceeebc2c4138c05). The official Linux archive SHA256 is85097a4d659fe388193a5efb0c413b880e101f1290cc41d00eb60847b18f064e. No Mathlib or downloaded proof dependency. Build logs list axioms; no `sorry`, `admit`, `native_decide` or added axioms. Binary Pauli semantics are explicit in `lean/Hadamard.lean`.

## Findings and uncertainty

All112000 trials completed with zero invalid corrections. Two-worker wall time722.614seconds; individual runs722.341,98.017,409.122seconds, peak RSS67348,70708,67684KiB. Largest-size pilots cost3.170,.364,2.460seconds per60trials respectively.144 generator/seed pairs are fresh and disjoint from the previous expanded seeds.

| Family | Local quadratic estimate | Bounded logistic estimate | Logistic deviance/16df | Interpretation |
|---|---:|---:|---:|---|
| Cubic Z eta5 U |20.5414%|20.5725%|137.219|Scaling model rejected; no stable asymptotic threshold|
| Rhombic X eta100 U |1.05866%|1.08223%|56.699|Scaling model rejected; size-pair drift persists|

Both quadratic fits have physical monotone predictions on the frozen grid, unlike earlier wider fits. This does not validate their scaling assumption. Logistic approximate goodness-of-fit p-values2.52e-21 and1.86e-6 reject that particular model. A subsequent frozen parametric-bootstrap test also rejects both quadratic models: zero of2000refits per family exceed observed deviances138.190/41.372; add-one p=.000500, MonteCarlo95percent upper bound=.001843. This plug-in diagnostic is not exact finite-sample testing; see numerical-stopping.md. Logistic profile bands are diagnostics under a rejected model, not reliable threshold intervals. Source eta5 has no uniquely identified plotted target (methods/figure discrepancy); no invented source comparison.

Cubic eta5 upward crossing roots for L4/6,4/8,4/10 are23.0704%,21.7571%,20.3394%. Remaining size pairs fail the predeclared uniqueness/stability guard. Rhombic eta100 roots for L4/6,4/8,4/10 are1.16486%,1.12861%,1.07830%; remaining pairs fail that guard. Twelve-pair nominal Bonferroni bootstrap intervals condition on uniqueness and finite linear interpolation; they are not asymptotic threshold coverage.

Deformed cubic Z eta100: at L10, p=.20 gives total/point/loop .494/.494/0; at .28, .521/.513/.018; at .40, .887/.513/.764. These describe separated sector changes, not a causal explanation or proof of asymptotic limits. Eleven of72 signed adjacent-size/sector contrasts exclude zero under conservative simultaneous exact-binomial intervals; all72 are retained. No global threshold is fitted to this plateau. Point and loop counts share trials; joint counts are reconstructed only after verifying zero invalid corrections.

`validation.json` independently aggregates raw counts and computes scalar likelihood deviance; it shares raw data/model definitions and is not a second physical simulation. Analysis uses NumPy/SciPy and the unchanged supplied ten-iteration BP/OSD. Unknown original production settings, finite-size bias and source Monte Carlo error remain outside these uncertainty bands.

## Proof coverage and semantic audit

| Dissertation obligation | Exact formal result | Still outside the theorem |
|---|---|---|
| Local Hadamard preserves parameters,2.3.3/3.2 | `binary_parameters_preserved`: arbitrary finite n and arbitrary mask preserve binary isotropic subgroup, basis-witness rank, normalizer quotient and logical minimum weight. `first_axis_parameters` instantiates n=3L³ and Python first-third mask. | Hilbert-space dimension/phase-admissibility bridge, concrete lattice k/d formulas, sector-specific CSS distances |
| Cubic restricted chains,3.2.1 | `chain_kernel`: periodic first-axis differences vanish iff constant along each x-chain, for all positive L | Full incidence-to-difference translation is manually audited, not extracted from Python; finite cardinal/rank counting and probability limit not formalized |
| Cubic restricted planes,3.4 | `plane_kernel`: periodic y/z differences vanish iff constant on each yz-plane, for all positive L | Same incidence/counting/probability limits |
| Rhombic restricted triangle injectivity,3.5.2 | `actual_two_corner_family_injective`: the restricted formulas for orientations0 and2 expose every first-axis coordinate by choosing baseX=vertex parity | Formula-to-code bridge manually audited; full rhombic periodic checkerboard construction and global Pauli convention remain separate; no odd-lattice physical claim |

The corner formula comes directly from `expansion/geometry.py`: each triangle has one edge per axis, and first-axis inward bit is baseX XOR vertex parity. Under first-axis-only error the other terms vanish. Orientations0 and2 supply baseX0/1. Choosing baseX equal to parity makes inward0, exposing the unshifted edge. This is a general formula proof, not merely the trivial observation-map helper in CyclicKernel. Finite geometry checks from the prior milestone still provide separate implementation evidence.

Manual semantic review checked coefficient-list length in span/independence, support counting, full-qubit symplectic fold, normalizer-minus-stabilizer definition, existence of exact-distance witness, arbitrary-mask quantifiers and the source's first-third swap. Axiom output contains only propext/Quot.sound. No theorem is a new mathematical discovery. No claim of a fully formalized Hilbert-space code or general cubic/rhombic homology theorem.

Remaining feasible work: arbitrary-L cubic/rhombic commutation/homology/rank and distance lower bounds; source-incidence/counting bridges; ideal-majority probability limit; general BP/OSD algorithm correctness; model-adequacy work for unstable fits. General proof and finite numerical evidence remain distinct. Historical LEMON and original Three.js access remain blocked; no retry or substitute-equivalence claim.

Coordination: after the initial denial, the user explicitly authorized the exact public claim branch. A single authorized retry succeeded and remote readback verified claims/quantum-slot2-20261030 at edb0cb62e0f09d8287a07f017613a06461070644. The prerequisite is now met; no denied dependency was retried. Proposed upfront authorization guidance is in proposed-skill-improvements.md; no reusable skill edit. See cubic-proof-bridge.md for new general cubic incidence/kernel proofs and609792finite cross-language entry matches. Whole-study scope remains open.

Newest cubic proof continuation: see `cubic-homology.md` for the kernel-checked three-bit cohomology classification, exact minimum nontrivial cocycle weight L², and finite-coordinate zero-holonomy adapter. Rank/X-distance written consequences remain distinguished from general Lean proofs. Full dissertation remains open.
