# Independent numerical and mathematical review

Reviewer: independent-computation agent, 2026-10-30. Scope: scientific implementation and preserved numerical results for the twelve selected Figure 3.2 conditions. This is a technical audit, not the rendered-paper review. No baseline computation was changed during this audit.

## Mathematical audit

The primary implementation in `replicate.py` correctly uses the group-average encoding from the thesis for the three specified seeds. Its coefficient `conj(g[:,0])` selects the logical-zero fiducial in the intertwiner, and metric whitening normalizes the two logical columns in the coherent-state Gram inner product. Duplicate coherent points are combined before this normalization. The tested encoding Gram error is below 8e-16.

The Gram function has the correct normalized coherent overlap, including its complex phase. The output factor is a square root of the attenuated-state Gram matrix. The environment factor must be transposed in each logical channel block: tracing `|e_i><e_j|` supplies `<e_j|e_i>`. The implementation uses this transpose correctly. This gives an exact finite-span representation of pure loss for these finite coherent superpositions; the primary method has no photon-number truncation.

The SDP objective is the entanglement fidelity for a maximally mixed logical qubit with optimal trace-preserving recovery, not a worst-case fidelity. With logical-first vector ordering, H is the encoded-channel Choi matrix divided by d^2=4. The positive semidefinite variable J is the unnormalized Choi matrix of the recovery adjoint and obeys J00+J11=I. The objective Tr(HJ) equals the Kraus expression sum |Tr(R K E)|^2/4. H has trace 1/2 as expected (observed deviation below 9e-16); its smallest observed eigenvalue is at least -8.31e-17.

The equality multiplier Y gives the dual constraint I_2 tensor Y - H >= 0 and dual objective Tr(Y). The PSD clipping and partial-trace whitening used for the primal repair preserve positivity mathematically and enforce the trace constraint. Shifting Y by the negative minimum dual slack eigenvalue repairs dual feasibility mathematically. Numerical eigendecompositions and arithmetic are not outward rounded: these are floating-point feasibility-repaired brackets, not rigorous interval certificates. Singular normalization or whitening would require explicit handling outside the present selected conditions; the code does not purport to cover alpha=0.

`diagnostics.py` constructs the flagged one-photon erasure channel correctly. Its optimum is 1-3 gamma/4, giving F=0.9925 at gamma=0.01 and F=0.25 for complete replacement. No-loss coherent-code checks have expected F=1. These checks test the dimension normalization and recovery objective, not just solver convergence. The independent finite-Fock implementation additionally checks its actual no-loss and complete-loss channel construction, returning 1.000000000000069 and 0.2500000000000001.

## Independent construction and agreement

`independent_check.py` does not import the primary channel or recovery builder. It builds the odd-first/even-second cat code directly in the two-mode Fock basis and swaps modes for logical one. For the extended group, the central-phase sum imposes total photon number congruent to 1 modulo 4. It applies explicit binomial pure-loss Kraus operators, compresses the physical output by SVD, builds H from the resulting Kraus images, and imposes the partial-trace constraints component by component. SCS replaces the primary Clarabel solver.

This is implementation and solver cross-validation, not fully independent end-to-end replication: both implementations use the same thesis definitions, selected amplitudes, physical assumptions, entanglement-fidelity objective, NumPy/SciPy ecosystem and CVXPY frontend. They share no primary encoding or channel implementation. The reviewer had access to the primary implementation and results.

All twelve independent SCS solves reported `optimal`. The maximum absolute primary-versus-independent fidelity difference is **1.0857550303278174e-8**, at extended alpha=0.9326530612244898. It is far smaller than the substantive published-marker differences at the higher extended amplitudes.

At the largest amplitude, increasing the per-mode Fock cutoff from 32 to 40 and the total lost-photon cutoff from 8 to 10 changes any of the three infidelities by at most **5.43e-11**. At cutoff 32 the largest analytic encoding trace-distance bound is 3.90e-9 and the omitted-loss probability bound is 3.02e-15. At cutoff 40 these improve to 5.23e-13 and 1.79e-19. The latter run discards at most 3.29e-27 in squared SVD singular weight. These tail bounds and the convergence experiment address distinct numerical approximations; they do not convert solver output into a formal proof.

## Solver statuses and brackets

Nine primary Clarabel conditions reported `optimal`. The extended conditions at alpha=0.49183673469387756, 0.9326530612244898 and 1.5204081632653061 reported **`optimal_inaccurate`** and must remain labeled as such. No selected condition was discarded or replaced. Across all twelve primary conditions, the repaired fidelity-bracket width ranges from 4.5987746943865204e-10 to 2.0624939633950845e-7. The maximum unrepaired trace-constraint residual is 3.00e-11; after repair it is below 2.07e-14.

The extended alpha=1.5204081632653061 primary fidelity bracket is [0.998361240144119, 0.9983614463935153], width 2.0625e-7. At alpha=2.010204081632653 it is [0.9988670952656689, 0.9988670969974327], width 1.7318e-9. Infidelity bounds reverse the fidelity endpoints. Raw optimum estimates should not be presented as guaranteed bounds.

## What the SCS tolerance study does and does not explain

All sixteen sensitivity solves reported `optimal`, despite substantially different numerical feasibility gaps. Solver status alone is therefore insufficient evidence of numerical accuracy.

| Extended alpha | SCS tolerance | Infidelity | Repaired fidelity-gap width |
|---|---:|---:|---:|
| 1.520408 | 1e-4 | 0.00211148151 | 0.00303899 |
| 1.520408 | 1e-5 | 0.00164656475 | 3.04380e-5 |
| 1.520408 | 1e-7 | 0.00163876954 | 1.56198e-7 |
| 1.520408 | 1e-9 | 0.00163874965 | 8.67002e-11 |
| 2.010204 | 1e-4 | 0.00126670490 | 0.00108635 |
| 2.010204 | 1e-5 | 0.00117521517 | 1.60851e-4 |
| 2.010204 | 1e-7 | 0.00113310713 | 1.60953e-6 |
| 2.010204 | 1e-9 | 0.00113290387 | 4.01649e-10 |

At alpha=1.520408, the extracted thesis marker is approximately 0.00164617278. The SCS 1e-5 raw estimate is only 3.92e-7 above that marker, whereas the tight estimate is approximately 7.42e-6 below it. However, the loose solve has a 3.04e-5 repaired gap and a primal minimum eigenvalue about -5.50e-5. This is evidence that solver tolerance can plausibly produce an error of the relevant magnitude; it is **not** identification of the original solver or confirmation that its result was accurate.

At alpha=2.010204, the extracted marker is approximately 0.00114670490. The tight SCS estimate is about 1.38010e-5 below it (about 1.20% of the source infidelity). The marker lies between tested loose and tight estimates, but no tested tolerance specifically reproduces it. Original solver settings and raw data remain unresolved. The tolerance experiment cannot establish the cause of the source discrepancy or justify silently choosing a looser estimate to match it.

## Remaining interpretation limits

- Only twelve selected conditions are independently checked; this is not reconstruction of the entire curve or a global optimum over encodings.
- The comparison fixes coherent amplitude, not average photon number. It does not establish an energy-matched ranking of codes.
- Enlarging the group does not uniformly worsen these tested results: the imaginary code is better near alpha=1.52, while the extended code is better near alpha=2.01. Signed contrasts and this reversal must be retained.
- Source-marker extraction envelopes describe PDF coordinate reading only. They are not statistical confidence intervals and do not cover undocumented original optimization error.
- The calculation is deterministic. Sampling standard errors, significance claims or an invented Monte Carlo multiplicity correction would be inappropriate; simultaneous numerical envelopes can instead be declared for the finite comparison family.
- The coherent source model, fixed loss convention and thesis encoding definitions are shared assumptions. Agreement between implementations cannot rule out a shared interpretation error. Endpoint checks and source review reduce, but do not remove, that risk.

## Audited file hashes (SHA-256)

These identify the reviewed bytes, independently of subsequent paper or metadata edits.

```
836329d422c78ef7b97df6792025e734fda62b6d570ad895f534eb0c393f55c0  replicate.py
d56d9debd47391b50774158004440e93c0bd2965611509e5a520db5b2824903c  diagnostics.py
c169726a0811bfaf32f9d8b9828490af7f618cf6a842f2fc6f91e8201940023b  independent_check.py
f5de10a64b40d62d096e50a29d101f130850fa4bbd90e5729a9e8e6cebf7ecc6  outputs/primary.json
a8cfb30d01066bc30b1c3cfbe6a6d8190b6f289afca1790e7b188742b91c70ef  outputs/independent.json
61dc4b84462be4b7ae5801988d70d8426f8ac60b96eeefbb445693288b3a5565  outputs/solver_sensitivity.json
```

Supporting records: `outputs/independent.json`, `outputs/independent_convergence.json`, `outputs/primary.json`, `outputs/solver_sensitivity.json`, and `outputs/normalization.json`. The scientific implementation is consistent with the stated bounded scope. Delivery still requires the separate rendered-main-paper review and the parent workflow's provenance and PR checks.
