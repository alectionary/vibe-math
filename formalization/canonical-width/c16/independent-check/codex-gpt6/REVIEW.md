# Internal read-only review

A separate review agent was authorized to read only the newly written solve.py,
run_suite.py, the allowed SPEC.md, and (if needed) its four listed inputs. It
reported that it read the two new programs and SPEC.md only, ran no experiments,
and saw no excluded content.

Findings: the Boolean encoding, symmetry equalities, conflict graph, counting
recurrence, component polynomial product, and direct witness checker are sound.
UNKNOWN is correctly reported as INCOMPLETE. Solver infeasibility remains a
trusted computational result without a formal proof certificate.

Hardening recommendations adopted:

- Reject optimized Python execution, because -O removes assertions and could
  otherwise allow the known-answer gate and witness checks to be bypassed.
- Clear the suite success marker before a rerun, avoiding stale certification.
- Describe the time limit as approximate: setup, counting bookkeeping, and final
  checking are not forcibly terminated.

The original active suite ran without Python optimization in a fresh directory;
the first two hardening changes do not change its search or validation behavior.

The same reviewer also checked the later generic weight-order hint. It confirmed
that the hint uses no planted indices, its 128 diagonal pairs are compatible,
its closure check is correct for every class, and add_hint adds no constraints.
It found no defects and performed no experiments or excluded-content reads.

The reviewer also confirmed the later GF(2) rank cuts: selected vectors must
be independent; highest-pivot XOR elimination computes rank correctly; block
union filtering and deduplication preserve all valid frames. No defects found.

The alternative CNF backend was reviewed separately. The reviewer confirmed the
symmetry quotient cardinalities, repeated-neighbor exclusions, guarded counters,
assumption fallback, and timeout handling. It noted the same approximate budget
limitation for construction/checking. No mathematical defects were found and no
experiments or excluded-content reads were performed.

The weighted bundle reduction and color-bound implementation were also reviewed.
The reviewer confirmed fixed-point/two-cycle decomposition, zero cross-block
compatibility, C column remapping, and prefix sums of maximum weights per color.
The only reporting issue found (fallback elapsed time excluding preliminary work)
was fixed. All real matrix symmetry assumptions are checked directly.
