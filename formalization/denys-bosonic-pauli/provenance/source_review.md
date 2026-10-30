# Independent source review: Denys (2024), Figure 3.2

Reviewer: source_review, independently reading the source before seeing any replication results.
Date: 2026-10-30. No simulation output or primary implementation was used for extraction.

## Source identity and access

The title page states *Quantum key distribution and quantum error correction with bosonic systems*, Aurélie Denys, doctoral thesis in Informatique, Sorbonne Université, publicly defended 5 April 2024, directed by Anthony Leverrier. The author's own website links `PhDThesisAurelieDenys.pdf` as the manuscript (index.html line 60).
Repository: https://github.com/aurelie-denys/aurelie-denys.github.io ; revision `5aefd7b6caca97df7bf49ece36c6c91ba955d0fc`.
PDF SHA256: `4cadbf1bbacdc7b21bb36479dbbadc0da5013c8c67f794bff0206d345e0b4156`.
No LICENSE or explicit redistribution license was found in that repository, and the website does not declare one. Publicly readable is not Apache-licensed. Keep the full thesis outside the PR; label the limited, attributed evidence excerpts as third-party material excluded from the repository's Apache grant. This review does not make a legal determination about source rights.

## Code and channel definitions verified

- Figure 3.2, printed/PDF page 150: equal-phase code, group <X,Z>, seed |alpha>|alpha>; imaginary-phase code, same group, seed |alpha>|i alpha>; extended code, group <i,X,Z>, seed |alpha>|exp(i pi/4) alpha>. Labels verified against rendered figure legend, not extracted text alone.
- Pages 148–149, Eqs. 3.52–3.61 define the order-eight group, identity logical representation, and seed Sigma=|0>. Eq. 3.60 gives |0bar> proportional to c1(alpha) c0(beta); Eq. 3.61 gives |1bar> proportional to c0(beta) c1(alpha). Here ck(z)=|z>+(-1)^k|-z> is unnormalised. The code states must be normalized.
- The extended group's state is reconstructed using the general group-sum map, Eqs. 3.1–3.2, p140, and coherent-state action Eq. 3.10, p142. Page150 supplies the group and seed, but not expanded state coefficients for this arm. This is a documented reconstruction, not an original-code replay.
- Pure loss is gamma=.01 for each mode; amplitude attenuation is sqrt(1-gamma). Eq.3.64, p151 gives two-mode product Kraus operators, agreeing with the single-mode convention in Eqs.2.124–2.125, p131. Do not use amplitude attenuation 1-gamma.
- Entanglement fidelity is defined in Eq.2.97, p128, using normalized maximally entangled state. Recovery is optimized for fixed encoding. It is not a biconvex search over encodings for Figure3.2.
- Eqs.2.101–2.120 use normalized Choi-like XE and XR with trace constraint Tr_A(XR)=I/d. Tr(XR ME) has the correct fidelity normalization. Equivalently, an unnormalized recovery-adjoint Choi J with Tr_A(J)=I uses objective Tr(J ME)/d. A transient reviewer concern about a missing factor was checked and withdrawn before results.

## Resolved and unresolved source readings

The Figure3.2 caption says 'Entanglement fidelity', but the logarithmic axis explicitly says 'entanglement infidelity', and the paragraph immediately below calls the plotted quantity infidelity after optimal recovery. The graph is 1-F, not F. This is a caption-label ambiguity, not a replication failure.

The imaginary-phase and extended-group curves cross at approximately alpha=1.85. The source prose says the larger group 'appears to degrade' protection, but that is not a uniform pointwise claim across the plotted alpha range: extended is worse near the imaginary-phase optimum and better near alpha=2. The paper must distinguish best attainable performance in the displayed range from a same-alpha comparison. At the selected alpha=2.0102040816, extended-minus-imaginary infidelity is negative (about -0.0004414).

The caption refers to the dual-rail value at alpha=0. The rendered actual marker grid starts at alpha=.1, not zero. The zero-amplitude limit can be checked separately and should not be described as an extracted plotted marker.

The source has 50 blue markers, 46 orange markers, and 50 green markers. Orange is missing inferred grid indices [2,18,19,24]. No reason is given in this figure; missing markers are not evidence of nonconvergence. No original solver residuals or numerical error bounds are available from these PDF points.

## Vector extraction and selected inventory

`extract_source.py` extracts marker centers from PDF drawing paths; it does not use plot line interpolation. Axis coordinates are calibrated from rendered labels at alpha=0,2.5 and log10(infidelity)=-3,-2. Marker x-coordinates align with alpha=.1+2.4*i/49 to within 0.000183106 PDF points. Numerical coordinates use the exact inferred grid, not the slightly rounded PDF x values.

The agreed bounded inventory selects common grid indices [8,17,29,39], alpha=[.49183673469387756,.9326530612244898,1.5204081632653061,2.010204081632653], all three arms, 12 comparisons.

| alpha | equal phase | imaginary phase | extended Pauli |
|---|---:|---:|---:|
| .491836735 | .00686810049 | .00525327478 | .00718981645 |
| .932653061 | .00945812105 | .00153393571 | .00445092399 |
| 1.520408163 | .02259699969 | .00053571953 | .00164617278 |
| 2.010204082 | .03881255768 | .00158811510 | .00114670490 |

Full values, coordinates, missing-point inventory and deterministic extraction envelopes are in `source_values.json`. The envelope independently perturbs marker y and both log-axis tick coordinates by ±.05 PDF points, a conservative allowance far larger than coordinate/grid residuals. This bounds coordinate extraction under the declared model; it does not bound original optimization error, establish statistical coverage, or assign original printed precision. There is no Monte Carlo sampling in this extraction. Display rounding of extracted values must not be represented as the dissertation's numeric reporting precision.

Signed source contrasts are saved in `source_contrasts.json`: phase_gain = equal_phase minus imaginary_phase infidelity (positive favors imaginary); enlargement_cost = extended_pauli minus imaginary_phase infidelity (positive disfavors enlargement). These contrasts are distinct from ours-minus-source deviations.

## Evidence and independent-check boundaries

`crop_source.py` calls pdftoppm at 600dpi; `crop_manifest.json` records source/page/rectangle/commands/hashes. Crops cover Figure3.2, Eq3.57–3.61, Eq3.64, the general group map, and the coherent-state representation. Page150 was also inspected as a full rendered page in `page150.png`.

This review independently verifies source reading and vector extraction only. It shares the same thesis PDF and mathematical definitions as the primary computation. It does not independently validate code, solver implementation, numerical optimization results, or the eventual main manuscript. A separate rendered-main-PDF review remains pending.
