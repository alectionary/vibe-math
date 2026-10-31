# Orbit 15: one exact phase-I calibration at current point 22

The frozen 3,225-column archive has exact restricted L1 distance
approximately **0.8686600975674751** from the selected-conditioned zero-pool
target. The accepted primal has 524 positive physical basis weights. This
is a restricted-archive result, not a source obstruction or a membership proof.

The single SoPlex call finished in 34.66 seconds with 376,422,400 bytes maximum
sampled RSS. It used verified nice 19, one thread, a 60-second internal limit,
90-second external limit, and 2GB memory cap. The independent consumer checked
the complete rational LP, every physical column, exact primal feasibility,
dual stationarity, nonnegative-row signs, and equality of primal and dual
objectives. The full physical maximum-basis pricing gap is approximately
**−7.566543111283561**. Its maximizing basis has phase-I reduced-cost violation
approximately **8.435203208851036**, so the archive is still missing a useful
physical column. That column was not added and no further solve was run.

The initial endpoint replay stopped at a strict parser mismatch: SoPlex's
optimal dual section ends with `All other dual values are zero.`. The old
reader accepted only primal/generic terminators. The raw files, old reader,
old consumer, and failure report are preserved. The versioned reader accepts
that exact terminator only for the dual kind; the consumer still checks the
full objective and row stationarity identities directly. Seven parser
corruptions and the original eight phase-I corruptions were rejected.

Files:

- Preparation: `two-basis-results/singleton-o15-batch64-phase-one-point22.json`
  and matching `-independent.json`.
- Raw solve: the same prefix plus `-solve` and its frozen manifest, primal,
  dual, log, basis, and RSS trace.
- Exact endpoint: the same prefix plus `-endpoint-v2-independent.json`,
  SHA `26b4349443cdd00868c6e61f65613aa60d1fef52476300049a96646776f2d720`.
- Preserved format failure: the same prefix plus `-endpoint-v1-failure.json`.
- Mathematical scope: `SINGLETON-PHASE-ONE.md` and its bound peer review.

All findings concern orbit 15 at the exact point-22 input. No source-frame
claim, other-anchor claim, or global C16 answer follows. The original 16/18
interval and 405-case cover are unchanged.
