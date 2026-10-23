# Fixed-code decoder trajectory follow-up

This is an adaptive structural investigation after the existing benchmark, not a new objective-selection experiment. Initial exploratory traces and syndrome-colored partition checks already identify error pair {0,17} in X sector of Construction 3.10 profile 2, representative 0, as a candidate for a seven-message-class / three-belief-class obstruction. Its profile-0 counterpart succeeds in five iterations. This observation determines the proof witness and must not be described as outcome-blind selection.

## Boundaries

Use only existing 32-qubit Construction 3.10 profiles 0 and 2, both existing representatives, both sectors. Keep pX=pZ=0.02, normalization 0.8, integer arithmetic scale 2^20, saturation +/-50*scale, 50 iterations, uniform priors, flooding updates and stabilizer-equivalent scoring. No new code search, Monte Carlo population, channel, optimization weight or modified decoder.

Trace every binary pair in those eight Tanner-graph instances: at most 3,968 pair trajectories. Compare instrumented outputs with the archived sector responses and unchanged original C++ decoder. Retain logical failures, syndrome failures and successful trajectories. Never infer periodicity of the full message state from recurring hard decisions. Record exact state repetitions only if present before stopping.

## Structural certificate

Compute message partitions using outgoing check-update signatures that retain the set of incoming message classes and the parity of each class multiplicity. These determine the min-sum magnitude and sign, respectively. Variable-update signatures retain full multisets of incoming check-message classes. Begin with uniform variable-to-check messages and refine until stable; derive a partition of posterior beliefs. A syndrome outside the span of the binary syndrome vectors of posterior-class supports cannot be reached by any invariant hard decision. Check this certificate directly on the graph, separately from trajectory observations.

Focus Lean work on an all-iterations obstruction for the identified profile-2 witness, proving that the actual integer min-sum update preserves the message partition and that every resulting hard decision has zero syndrome despite a nonzero target. A general iteration-invariance lemma and a concrete graph/update bridge are preferable to assuming decoder equivariance. Explicitly separate the mathematical Lean model from execution of C++; verify the bridge by exact update arithmetic and independent reference comparisons.

## Reporting and stop condition

Use the exhaustive pair census to quantify which part of the existing low-weight deterioration is explained by the obstruction. Do not equate this with an explanation of the full moderate-noise FER difference. Preserve prior-art credit for symmetry/degeneracy trapping in iterative quantum decoding. Stop after the fixed census, witness traces, a checked all-iterations obstruction if attainable, and the updated scope assessment. Do not redesign the decoder or expand to 96 qubits in this step.
