# Interrupted analytical work: saved checkpoint

2026-10-30. These files preserve completed bounded checks from the interrupted
session. They have not yet received the full independent scientific review or
been incorporated into the reviewed main manuscript. The 17-page PDF and its
review at dc7e94fabbed9ba11abc0b0c6f096fea85d5ab25 are unchanged.

Saved results: OSD exhaustive comparison (682 matrices, 20,748 consistent
order/syndrome cases, three implementations); rhombic cellulation comparison
for L=2,4,6,8,10; and restricted-support loop stress checks. The latter found
four logical failures at L=2 and prior 1e-12, reproduced by historical code.
These are outside the dissertation's production sizes and probability grids;
they do not refute its reported finite curves. Interpretation remains under review.
No new physical-noise campaign was running when execution resumed. The Python
process remaining from the previous session was defunct, not computing.

From repository root, the completed checks can be repeated with:

```sh
PYTHONPATH=/tmp/slot2-deps OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/followup/check_osd_exhaustive.py
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/followup/check_rhombic_cellulation.py
OPENBLAS_NUM_THREADS=1 python formalization/pesah-biased-cubic/followup/check_rhombic_loop.py
```

The OSD command requires the external historical source at `/tmp/bn3d-2021`
(revision 686560e5d03c2e5d31f6c6260b03756af03a7e93); it is not bundled or licensed
by this repository. Reference dependencies are external as documented in the
study README. The saved loop reference check used that same historical loader,
F as integer triangle incidence, each saved input, and `bp_osd_decoder` with
`max_bp_iter=10`; the independent reproducible wrapper remains to be saved.

An attempted BP exact-zero-message experiment failed an assertion before writing
results. Floating-point construction of the intended zero LLR is a suspected
cause, not a finding. No BP counterexample is asserted from that failed attempt.

Next: review the rhombic general cellulation/distance argument, verify ideal
majority probabilities and their assumptions, complete written OSD and quantum
interpretation bridges, and integrate accepted findings into a freshly reviewed
paper. `acceptance-scope.json` distinguishes necessary original claims from
optional formalization of inherited background. Whole-dissertation work is open.
PR-description update remains paused because its previous error was not classified.
