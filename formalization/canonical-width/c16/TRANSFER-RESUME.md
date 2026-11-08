# Paused C16 research handoff

Paused at the user's request on 2026-10-29, after the running structural pair
screen completed. No research solver or screen is left running. The original
four-hour deadline was23:30:58UTC; the pause supersedes that remaining budget.
Do not resume automatically. Acquire a new create-only canonical claim when
the user resumes; the old session's claim is released at publication closeout.

The original question is still width16 or18. The sufficient selected-pair
cover is405, the best physical partial frame is88/128, and zero full source
anchors are excluded. See [the report](TRANSFER-FOUR-HOURS.md) and
[verification inventory](transfer-results/verification.json).

## What is finished

- Six frozen held-out compact trials independently prove UNSAT, including
  ordinary DRAT and empty-proof rejection from clean revision56024d4. The
  seeded proof in each pair yields the checked408→405 cover induction.
- Independent complete replay of384 selected smaller subsets finds one strict
  order-four obstruction: Z416 and Z512 cannot coexist in a full frame.
  Cyclic shifts and sector exchange give32 clauses. Old complete order3 and
  unrestricted propagation accept that smaller subset.
- All16200 canonical source pairs were screened by the producer. Four positive
  word-obstruction classes replay independently: (368,589), (368,622),
  (400,496), (416,512), of orders3,3,3,4. Pair(336,438) is separately rank
  deficient and was already known. The negative decisions of this full
  pair catalog have NOT received an independent complete replay.
- Four source clauses of sizes8,6,8,6 were mined from the first global
  closure-passing11-pair configuration; certificates, physical trial bindings
  and28 single deletions check independently.
- The50-minute full48/48 anchor and30-minute global necessity trials are
  UNKNOWN. Their inputs and final global cut/CNF/model-record replay are saved.

## Recommended next bounded step

The existing6576 forbidden-pattern clauses imply31408 distinct conditioned
second-moment inequalities. Exact screening finds47 violations of the old
rational point, including the two pair zero faces. The sparse matrix agrees
exactly with the separate rational screen. This gives a concrete structural
route beyond repeating compact-case searches.

1. Before expanding the solver campaign, independently replay the full pair
   catalog if a completeness claim will be used. Positive clauses already have
   certificate checks; no global conclusion requires treating negative tests
   as extendibility.
2. Run a bounded numerical pilot of `profile_moment_forbidden.py` with
   `--forbidden-patterns relevant-results/seed-cuts.json
   transfer-results/four-term/gate.json` and the other arguments in
   `transfer-results/moment-pair-corrected-frozen.json`. This model is prepared
   but **has never been run**. Add the two other order-three pair classes from
   the pair catalog only after source-binding their moment faces as well.
3. Require an exact rational feasible-point replay or an independently checked
   exact infeasibility certificate. An SCS status, positive numerical margin,
   or failure to recover a point is not an answer. The saved
   `moment-pair-exact.json.gz` is a **rejected candidate**, with a negative
   profile weight; it must never be cited as a feasible certificate.
4. Alternatively, `global_four_signature.py` and
   `verify_global_four_signature.py` are prepared but **not trial-validated**.
   First run a zero-round source/CNF check and small controls. Reuse only
   independently checked universal cuts. Converting domain cuts to universal
   ones is justified only for the saved global full-domain trial, after
   checking that its allowed pair domain equals the complete source domain.
   Freeze the exact initial input and time cap before a new global trial.

## Reproducibility and limits

Use `/private/tmp/c16-venv/bin/python`, Kissat at
`/private/tmp/c16-kissat/build/kissat`, and DRAT checker at
`/private/tmp/c16-drat-trim/drat-trim` on this machine. Native libraries are
`/private/tmp/c16-{domain-propagation,conditional-word,sparse-quotient}.dylib`.
Source and binary hashes are in frozen records; rebuild on another machine.

The original strict-margin producer masked only one entry of a symmetric
forced-zero face. `profile_moment_pair_faces.py` repairs that optional
witness-search mask and preserves the original failed artifact. The corrected
numerical trial still failed exact recovery. Necessary-model source validity
and the exact consumers were not weakened.

The capacity-child gate found no gain on384 cases, even with1620 old small
children. The new direct order-four obstruction is a different successful
step. Do not attribute it to the failed capacity-child composition.

No new papers, source targets, Lean completions, full frames or full-anchor
exclusions were obtained. Prior literature/access gaps remain unchanged.
Publication is through PR17; master remains subject to required review. The
user explicitly authorized an issue handoff at this pause.
