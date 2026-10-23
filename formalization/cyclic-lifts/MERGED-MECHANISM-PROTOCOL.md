# Message-level follow-up of the fixed merger experiment

Use only the saved million-error experiment, its exact four matrices, error
stream and decoder parameters. No new random samples, codes, channel changes,
decoder tuning or feedback interventions. The original minsum.cpp remains
unchanged; a temporary instrumented copy records incoming edge messages and
computed check messages without changing updates or stopping.

Replay every code/error pair whose original and merged syndrome-match flags
differ: 20,683 for Previous best and 20,498 for Minimum 4, or 41,181 pairs.
Both directions are retained: losing and gaining syndrome convergence. This
is outcome-conditioned mechanism analysis of a fixed sample, not a new
confirmatory performance experiment. Replay the 45 previously selected full
history pairs too when needed for validation, without adding hand-picked errors.

At the first check-message divergence between actual trajectories:

1. Verify that incoming messages agree under the physical edge bijection.
2. Verify that all changed messages lie on the merged source checks.
3. Recompute each source message using the excluded-edge minimum and full
   parity of the other source side. The merged magnitude is normalized
   min(own excluded minimum, other full minimum); its sign is the own sign
   multiplied by the other side's effective parity sign.
4. Classify the onset as sign reversal only, magnitude attenuation only, or
   both (possibly on different source edges). Record counts in both syndrome
   transition directions and their net differences. These classifications
   locate a cause of first message divergence, not a sufficient condition
   for eventual syndrome failure.

For each recorded state, also evaluate the other representation's local
source-check update at those *same incoming messages*, retaining all common
check outputs. This is a diagnostic algebraic evaluation, not a modified
decoder run: it never feeds those messages into a subsequent iteration.
Record whether an originally accepting update would cease to match syndrome,
or whether a merged accepting update requires the merger at its current
state. For failed trajectories, record whether the same-state alternative
update would accept at any observed iteration. Quantify these witnesses
without assuming they explain all excess failures or prove the alternative
trajectory would visit that state.

Retain deterministic first examples per code, transition direction and onset
class, plus first accepting-state obstruction witnesses. Full q/r histories
are transient; store replay hashes, compact per-case summaries and the local
integer inputs/messages/posteriors needed to reproduce retained witnesses.
Compare replay terminal outputs with the saved experiment and independently
check retained states against direct Python message equations.

Formalize the exact min-sum merge identity, monotone magnitude bound, parity
sign reversal, a syndrome obstruction from a changed decision, and concrete
local witnesses in Lean. Use exact rounding and clipping. Clearly distinguish
the kernel-checked local mathematics and finite witness checks from external
validation that the unchanged C++ decoder reached those states. Do not claim
a complete Lean verification of the C++ decoder or all 100-step executions.
