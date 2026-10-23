# Fixed million-error original-versus-merged comparison

Freeze before new decoding. Compare the two previously verified representatives:
Previous best merges checks [0,75], Minimum 4 merges [42,119] (zero-based).
No candidate selection or changes to their matrices are allowed after outcomes.
Original and merged H_X span the same code; H_Z and coordinate labels stay fixed.
Both codes remain exact [[252,10,10]], connected, girth eight, variable degree
three and 756 edges. Merging changes 126 checks to 125, with one weight-twelve
check in place of two weight-six checks. This is a generator intervention,
not an isolated scalar-count intervention.

- Generate exactly 1,000,000 independent Bernoulli Z errors at p = 0.04 with
  Python Random seed 20261027. Consume 252 draws per pattern in coordinate
  order. The seed is an identifier, not a study date. Use the identical errors
  for all four representations, in batches of 20,000. Four million decoder
  executions are not four million independent channel samples.
- Unchanged minsum.cpp decode function: flooding, alpha 0.8, 100 iterations,
  twenty fractional bits, clipping, rounding, ties and first-syndrome-match
  stopping. Perfect syndrome, one Pauli sector, full unchanged H_Z-span scoring.
- Retain both within-code contrasts: merged minus original failure probability.
  Report paired 95% intervals and Bonferroni simultaneous 95% intervals across
  the two contrasts (each marginal interval is 97.5%). No optional stopping,
  tuning, extra noise levels, pooling with old samples, or adaptive extension.
- A wrapper inserts only hard-decision recording calls into a temporary copy
  of the frozen decode source. Record the first hard-decision divergence,
  differing common iterations, number/location of changed variables at first
  divergence, and terminal outcome for every pair. Compare wrapper outputs
  to the uninstrumented engine before decoding; compare selected actual-stream
  outcomes to the uninstrumented C++ and direct Python implementations.
- Aggregate exact recovery, stabilizer-equivalent success, syndrome failure
  and syndrome-matched logical failure; failure transitions; initial source-check
  syndromes; first-divergence histograms; and whether the true error contains
  one of the newly gained four-variable supports. Preserve compressed outcome
  streams and batch/full noise hashes for independent reconstruction.
- For each code retain the first three errors in each joint success/failure
  category and the first error in each ordered pair of the four terminal
  classes. Use their union, without choosing examples for narrative appeal.
  Save complete hard-decision histories for original and merged representations.
  Every history must match independent direct Python message equations.
  Annotate residual syndrome, stabilizer membership, changed variables and
  containment of a newly gained support in error/residual. This is descriptive,
  not proof that containment caused a failure.
- Verify the first-iteration rule: an original message on source row A has
  sign (-1)^sA; after merging it has sign (-1)^(sA XOR sB), with the same initial
  magnitude. The analogous rule holds on B. All other first-iteration check
  messages are unchanged. Test the resulting hard-decision rule on retained
  trajectories. No full edge-message history is asserted by this instrumentation.

The fixed decoder equations are unchanged; its factor-graph input changes.
Report measurements separately from local update arguments. Do not attribute
the entire FER difference to absorbing count, check degree, or the first-step
mechanism without additional evidence. This comparison addresses the merger
intervention under the stated controls, not general objective superiority.
