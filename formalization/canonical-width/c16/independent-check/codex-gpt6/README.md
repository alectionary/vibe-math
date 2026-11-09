# Independent C16 frame check — Codex / GPT-6

This is a new implementation from the allowed specification and four coordinate
files. All required known-answer tests passed in the final integrated suite.
Real A/B/C all ended INCOMPLETE at their bounded limits; their mathematical
existence questions remain unresolved. Canonical results are in `results/`;
see `RESULTS.md` for the terminal report. Raw recorded runs remain in `final-outputs/` and
`bundle-outputs/`, with provenance describing their consolidation. Earlier diagnostic attempts are retained separately and
must not be mistaken for the final run.

Author: Codex, described by the runtime as an agent based on GPT-6. The **exact
model/version identifier is unavailable**. The directory name `codex-gpt6` is
descriptive, not a claim about an exact model build.

## Build and reproduce

Requires Python 3.12 and a C++20 compiler on Linux. Run these commands from this
directory, with the allowed files at their original
relative paths (`../SPEC.md`, `../inputs/`, and `../../pools/`):

```sh
python3 -m venv /tmp/c16-venv
/tmp/c16-venv/bin/pip install -r requirements-lock.txt
g++ -O3 -std=c++20 -Wall -Wextra -pedantic orbit_clique.cpp -o orbit_clique
g++ -O3 -std=c++20 -Wall -Wextra -pedantic bundle_clique.cpp -o bundle_clique
/tmp/c16-venv/bin/python test_clique.py
/tmp/c16-venv/bin/python test_bundle.py
/tmp/c16-venv/bin/python -u run_all.py > reproduction-suite.log 2>&1
/tmp/c16-venv/bin/python verify_outputs.py --directory reproduction-outputs --require-gate
```

The clean rerun writes `reproduction-outputs/` and preserves the archived
`results/`. To verify the delivered results without starting new searches, use
`python verify_outputs.py --directory results --require-gate` in the installed
environment.

`requirements.txt` pins the two direct solver packages; `requirements-lock.txt`
pins the complete installed Python environment. Recorded tools include Python
3.12, GCC/g++ 14.2.0, OR-Tools 9.15.6755, and python-sat 1.9.dev17 (Glucose4 wrapper, documented as Glucose 4.1).
Exact runtime/tool details, the Python compiler, and unavailable binary-build
identifiers are in `provenance.json`. The final primary search uses new C++ clique code and new Python counting code;
Glucose4 is the general fallback for a mapped matrix that fails the symmetry
check and has no immediately verified candidate. OR-Tools remains a dependency of the
shared Python module and is used by the preserved diagnostic backend.

The clean driver first verifies all pinned input hashes. The suite runs blocks01, blocks23, planted A/B/C, and real quarter, and asserts
all expected outcomes before writing `reproduction-outputs/tests-passed.json`. Only then
does it start real A/B/C. Expected answers occur only in test drivers/verifiers,
never as search constraints or returned counts. No planted index range is used
in any search. Optimized Python (`-O`/`PYTHONOPTIMIZE`) is rejected because it
would disable assertions used for validation. The suite removes stale gate
markers before starting.

Real A uses the orbit-clique backend; B/C use the weighted bundle backend.
`run_all.py` is the clean from-scratch reproduction driver: two child processes
run at most two searches concurrently, all pinned to the same first two available
Linux CPUs. Each final primary search is single threaded, and numerical library
thread counts are one. Each real class gets 7,200 seconds. Budgets are approximate:
model/graph construction, coloring, checking, and solver interrupt acknowledgement
are not forcibly interrupted. The paused SAT B diagnostic returned about 17 seconds
after its original deadline interrupt; its actual elapsed time is retained and
its status is INCOMPLETE.

The recorded development run first launched A (orbit) and B (SAT) after a full
six-test gate via `run_integrated_suite.py`. The subsequently reviewed bundle
backend reran planted B/C, validated the existing full gate and input hashes,
and launched weighted B/C via `run_bundle_real.py`. Weighted B used only the
remaining time in B's original two-hour window. These portfolio processes shared
the exact same two-CPU affinity; they never obtained additional experimental
cores. The redundant SAT B process was subsequently paused to give A and weighted
B one core each, with automatic resume at its original deadline; see
`portfolio-resource-events.json`. Its recorded wall time includes that pause.
The clean reproduction avoids this diagnostic overlap and uses the final
backends directly. All raw runs and interrupted diagnostics are preserved.

Individual commands, using the installed virtual environment (a standalone run
does not certify the test gate):

```sh
python orbit_backend.py --pools real --class A --seconds 7200 --output example-A.json
python orbit_backend.py --pools real --class quarter --seconds 7200 --output example-quarter.json
python bundle_backend.py --pools real --class B --seconds 7200 --output example-B.json
python bundle_backend.py --pools real --class C --seconds 7200 --output example-C.json
python solve.py --pools real --class blocks01 --seconds 7200 --output example-count.json
```

Every run saves and prints one JSON object with the specification's fields.
Adjacent `.log` files contain solver/search statistics; orbit runs also preserve
the derived `.matrix`. The suite logs contain start markers and witness-check
messages. For symmetry runs, `frames_found` counts returned witnesses (zero or
one), not all frames. For completed block runs it is the exact total. COMPLETE
with a witness is an existence decision; COMPLETE with zero is a completed
nonexistence search. INCOMPLETE never means nonexistence. Elapsed times and timeout outcomes depend
on hardware and scheduling; a fresh reproduction may explore a different number
of nodes within the same wall-time budget. Invalid models and
crashes fail instead of becoming negative decisions.

## Mathematical model

Each pairing is computed as the parity of `x[i] & z[j]`. Boolean variables select
indices on each side. Both side cardinalities are 128. Every selected X vertex
must have exactly one selected Z neighbor with pairing one, and vice versa.
This is exactly a 1-regular selected bipartite graph, hence a permutation
submatrix. Conversely, every frame satisfies these constraints. The selected
sets uniquely determine the matching; no ordering multiplicity is introduced.

### B/C: symmetric components and weighted cliques

For B set H=G; for C set H[i,j]=G[i,tau_8(j)]. Both then ask for H[S,S] to be a
permutation matrix. The real input matrices H are explicitly verified symmetric.
A symmetric permutation decomposes uniquely into fixed points and transpositions:
a candidate of weight one is an index with H[i,i]=1; a candidate of weight two is
{i,j} with zero diagonals and H[i,j]=1. Two candidates are compatible precisely
when all cross-entries between their index sets are zero. This also excludes
overlapping index sets. Thus a frame is exactly a compatibility clique of total
weight 128. For C, reconstructed columns are mapped back through tau_8.

The new weighted C++ search uses the same exhaustive branching and coloring
argument as the orbit search below, replacing each color's contribution by the
maximum candidate weight in that independent color class. At each prefix, the
bound uses the maximum within the prefix of its current color, plus the maxima
of earlier colors. This is a valid nondecreasing bound on additional clique
weight. The search accepts weight at least 128: a larger compatible matching is
impossible for vectors in dimension 128, and the direct checker still requires
exactly 128 distinct pairs.

The full planted matrices H do **not** satisfy this additional global symmetry.
The property is never assumed: a general fully verified candidate can settle a
positive instance without it; otherwise failure of the symmetry check routes
to the general SAT encoding. The initial explicit rejection of the planted
matrix is retained in `bundle-validation-rejection.log`. The final backend passes
both planted tests. This distinction is input-derived, never selected by a
hardcoded pool name or planted range.

### General SAT fallback: exact CNF

For B, X and Z selections with the same index share a variable. For C, the Z
selection at i is the X variable at tau_8(i). Thus the symmetry is exact, without
assuming that G is symmetric. Global cardinality uses a sequential-counter CNF
encoding from PySAT. Each selected-vertex degree-one requirement is a guarded
at-least-one clause and guarded at-most-one sequential counter. Every auxiliary
counter clause receives the negative selection guard. An inactive guard imposes
no constraint; an active guard enforces the original degree condition.

The generic backend also supports A/quarter by sharing variables within each
index orbit and dividing cardinality by orbit size. If a neighbor variable then
appears more than once, it must be false when that vertex is selected, since
its contribution would exceed one. Variables appearing once satisfy the guarded
exactly-one constraint. Identical constraints/cardinalities are deduplicated.
These transformations are equivalences, preserving every frame. Glucose4's
SAT/UNSAT result is trusted; no independently checkable UNSAT certificate is
produced. An interrupt timer uses its limited-solve API; UNKNOWN stays INCOMPLETE.

### A/quarter: exact orbit reduction and clique search

The program first verifies from the full input pairing matrix that
`G[tau_k(i),tau_k(j)] = G[i,j]`, for k=8 (A) or k=4 (quarter). If this property
fails, it rejects the reduction rather than claiming an answer. It then constructs
the index orbits of size q=16/k and explicitly checks that every orbit-pair block
has constant row and column degree.

For invariant selected sets, each selected row has total degree one. Therefore
its entire X orbit must meet exactly one selected Z orbit through a degree-one
block; all other selected cross-blocks must be zero. Conversely, choosing such
orbit pairs gives a frame. Each degree-one block is a candidate vertex. Two
vertices are compatible exactly when both cross-blocks are zero. This also
excludes sharing either orbit endpoint. A frame is therefore exactly a clique
of size 128/q (64 for A; 32 for quarter).

The new C++ search builds the compatibility bitsets, orders vertices by descending
degree, and recursively branches on clique extensions. At each node it greedily
colors the remaining graph into independent color classes. A clique can take
at most one vertex of each color. Vertices are visited in reverse color order;
after removing previously visited vertices, the remaining prefix is colored by
at most the current color bound. If current clique size plus this bound is below
the target, the whole remaining branch is impossible. Every possible extension
is otherwise visited. This proves the coloring pruning and exhaustiveness.
Timeouts propagate as INCOMPLETE; a positive result is reconstructed into original
indices and checked directly. No claim of a formal proof certificate is made.

### General positive-start heuristic

The backends try greedily building a diagonal matching in ascending and
then descending combined X/Z vector Hamming weight, breaking ties by index. An
index is added only if its diagonal pairing is one and both cross-pairings with
every earlier chosen index are zero. A complete candidate is used only if it
satisfies the requested symmetry. The clique backends directly check it; the SAT
backend first tries it as a full primary-variable assumption set. UNSAT under
those assumptions is never global UNSAT: unrestricted search follows. No hint
adds restrictions to the exhaustive fallback. This uses neither expected answers
nor planted indices. The final planted witnesses happened to be found by this
general heuristic and were verified from the vectors.

### Exact block counting

Each side is filtered independently by the required coordinate support mask.
The resulting bipartite graph is split into connected components. Components
cannot share endpoints or cross-pairings, so their induced-matching generating
polynomials multiply. Within a component, two edges conflict if they share an
endpoint or either cross-pairing is one. Induced matchings are exactly independent
sets in this edge-conflict graph. For a chosen edge e, the memoized recurrence is

    P(V) = P(V minus {e}) + u * P(V minus closed_neighborhood(e)).

The two branches partition matchings by whether e is absent or present, counting
each unordered matching once. The empty graph contributes 1. Polynomial
convolution combines components, using arbitrary-precision Python integers;
the degree-32 coefficient is the requested count. Isolated vertices cannot be
in a frame and contribute no edges. A positive coefficient also reconstructs a
witness. There is no counting skip. Blocks01 produces exactly 43,046,721; blocks23
has maximum induced-matching size 16 in this computation, so its degree-32 count is zero.

## Verification and review

Every reported witness is checked by direct parity calculations on the original
vectors, independently of the cached pairing matrix and solver constraints.
The checker verifies range, cardinality, distinct indices on both sides, all
matching and off-matching pairings, and the exact symmetry condition. Block
witnesses also have support checked. It prints the check requested in the spec.
`verify_outputs.py` repeats those checks and verifies the pinned input hashes.
Use `--require-gate` to additionally require every known-answer result to pass.

A separate read-only reviewer inspected the new implementations and allowed
specification only. It reviewed the degree model, rank bounds in the diagnostic
backend, CNF guards and assumption handling, orbit reduction, coloring proof,
and timeout semantics; no mathematical defects were found. Its assertion and
stale-marker hardening suggestions were adopted. See `REVIEW.md`.
`test_clique.py` additionally compares the C++ search with explicit subset
enumeration: all 81 ternary 2x2 matrices and 100 generated deterministic 4x4
matrices, totaling 346 SAT/UNSAT comparisons. All passed. `test_bundle.py` similarly passed 2,047 comparisons covering all 1,024 symmetric
4x4 binary matrices. These are newly generated software-validation fixtures, not
additional external scientific inputs.

## Provenance and independence

Repository: `alectionary/vibe-math`, branch
`research/c16-structural-20261027T173245`, pinned commit
`872a3a9467947f65a30df636a38a7556abd00a52`.
Full input SHA-256 hashes and the exact scientific read allowlist are recorded in
`provenance.json`. It contains only SPEC.md and the four files listed there.

The specification was the first repository/scientific source read, through the
GitHub file connector. Required generic environment-runtime instructions were
read before it; they contained no C16 research. The branch
was pinned using `git ls-remote`, and the five files were retrieved by exact path
at that commit. The initially read spec and pinned spec had Git blob SHA
`7c6ead184c0d1e34ce1c78050d99cd157e015ffd`. Raw bytes are preserved, including the
real coordinate files' missing final newline. No repository checkout, recursive
repository search, prior C16 code/results, papers, Lean files, commit messages or
diffs, PR discussions, research skills, or parent research history were read.
The parent supplied no scientific details beyond the allowed specification.

Only environment/network instructions, the non-secret network policy, installed
library APIs/package metadata, and generic compiler tools were consulted for
setup. The internal reviewer used the same scientific allowlist and ran no
experiments. There was no known accidental exposure to excluded research.
Procedural clean-room independence cannot establish algorithmic novelty or rule
out accidental convergence or pretrained exposure. Exact runtime model build
and some prebuilt solver build identifiers were unavailable and are explicitly
reported as such. The user subsequently authorized publication to a dedicated branch. No merge,
PR, or external comment was requested or made.

## Preserved diagnostic attempts

These attempts informed implementation choices using only allowed inputs. None
launched real runs, and none of their interrupted tests is counted as a decision:

- `initial-unhinted/`: initial CP-SAT model; planted B interrupted after 401.144 s.
- `hinted-before-rank/`: general weight hint added; quarter interrupted to add rank bounds.
- `rank-default-workers/`: sound rank bounds added; quarter interrupted to configure two full search workers.
- `outputs/` and `suite.log`: two-full-worker CP-SAT diagnostic, later stopped on quarter as INCOMPLETE.
- `sat-outputs/`, `sat-suite.log`, and `sat-diagnostic/`: pure-SAT tests; redundant quarter diagnostic manually terminated after the orbit backend decided it. Its manual-stop elapsed time is approximate and explicitly marked.
- `orbit-diagnostic/`: first completed quarter clique search, repeated in the final integrated gate.

Archived source copies are historical records; use top-level programs for their
correct relative input paths. CP-SAT's optional rank cuts bound selected vectors
supported in each union of coordinate blocks by their GF(2) rank. They are sound
because a permutation pairing forces selected vectors on each side to be linearly
independent. They are not needed by the final clique backends.

## Final result table

| Pools | Class | Status | Frames found | Seconds |
|---|---|---|---:|---:|
| real | blocks01 | COMPLETE | 43,046,721 | 0.044 |
| real | blocks23 | COMPLETE | 0 | 8.871 |
| planted1 | A | COMPLETE | 1 | 0.523 |
| planted1 | B | COMPLETE | 1 | 0.709 |
| planted1 | C | COMPLETE | 1 | 0.860 |
| real | quarter | COMPLETE | 0 | 2.936 |
| real | A | INCOMPLETE | 0 | 7200.333 |
| real | B | INCOMPLETE | 0 | 6699.480 |
| real | C | INCOMPLETE | 0 | 7200.395 |

For block tests, frames found is the exact count; otherwise it is returned witnesses.
INCOMPLETE is not a nonexistence decision. Sources and additional raw runs are
listed in `results/index.json`.
