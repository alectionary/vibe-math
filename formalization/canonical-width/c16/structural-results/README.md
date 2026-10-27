# Frozen C16 structural comparison

Canonical question `L-F91-c16-unrestricted-width` remains open: width16 or18;
best independently checked physical partial frame88 pairs. The source is Lee,
arXiv:2610.06820v1, Proposition9/equation50. This directory records a continuation,
not a new source-authored question. No Lean completion is claimed.

[Scope and written proofs](../STRUCTURAL-COMPARISON.md) ·
[Source-pool completeness](../INDEPENDENT-ENUMERATION.md) ·
[Earlier corrected monomial exclusions](../FOUR-HOURS.md) ·
[Prior global-search handoff](../SIX-HOURS.md).

| Result | Evidence | Conclusion |
|---|---|---|
| Basic degree-two cyclic SDP | Exact rational point, direct pool-equation replay, interval PSD checks | This particular necessary relaxation admits128 and cannot exclude a full frame. It does not construct one. |
| Quarter-turn invariant frame | Source-derived CNF and independently checked DRAT | No full frame invariant under T^4; orders8/16 also excluded. |
| Half-turn invariant frame |120-second and600-second searches | UNKNOWN; no exclusion. |
| Local owner-allocation Hall test | Frozen200-row conditional comparison and67072 literal controls |5327/34116 feasible phase choices removed, zero newly excluded whole holdout rows. |
| Count/flow master | Exact replay of returned points and397 new shape cuts | Both strengthened and baseline searches unresolved; no established overall speedup. |
| Cyclic filtration | Two exact rank implementations | Whole-pool ranks8j; no new global obstruction. |

The strict diagonal dominance PSD proof uses rational preconditioners and256-bit Arb
intervals. Numerical Cholesky factors only choose a preconditioner; interval
arithmetic proves positivity. The independent consumer rebuilds all1440
conditional-degree equations from the720-element logical pools and uses the
full16-term Fourier sum. Controls reject altered first/pair moments and an
indefinite block. The rational certificate is compressed as
`c16-structural-sdp-certified.rational.json.gz`.

For a full frozen replay, install the versions in `environment.json`, build
DRAT-trim at the recorded source commit, and run from the repository root:

```sh
OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 VECLIB_MAXIMUM_THREADS=1 python formalization/canonical-width/c16/replay_structural.py --drat-trim /path/to/drat-trim --output /tmp/c16-structural-replay.json
```

The replay regenerates each successful source CNF byte for byte and checks its
proof again. Without `--drat-trim`, proof rechecking is explicitly skipped.
Large complete proofs are gzip-compressed; incomplete time-limit proofs are not
preserved as certificates. `inputs/` holds immutable model inputs; the replay
unpacks them in a temporary directory. Numeric runs, including failed imports,
poorly conditioned attempts and wall limits, remain visible in their dated JSON
and logs. An `optimal_inaccurate` status never substitutes for the exact
certificate. Experiments with a phase-support restriction are witness searches
inside a relaxation; their failure is not a necessary-condition obstruction.

The source-ID collision at integration was resolved centrally: historical C16
F99/F100 are now F143/F144. Frozen earlier reports and extraction filenames keep
their original IDs. The newly published Majorana/magic-distillation F99/F100
records and their canonical questions were retained unchanged. New canonical
entry, eligible-target and complete Lean-target deltas for this block are all0.
