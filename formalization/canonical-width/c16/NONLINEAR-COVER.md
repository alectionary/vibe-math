# C16 nonlinear cover with 505 cases

Every full original minimum-pool frame has a simultaneous cyclic translate and
optional sector exchange containing one of **505 listed pairs**. This is a
proper subcover of the earlier518-case cover: thirteen representatives can be
removed together by using sixteen simultaneous dual-expansion identities and
the compatibility of selected pairs. The reduction is13/518, or about2.5percent.
All505 completion cases remain unresolved; canonical width remains16 or18 and
the best verified physical partial frame remains88.

The motivating target is `L-F91-c16-unrestricted-width`, Lee,
[arXiv:2610.06820v1](https://arxiv.org/html/2610.06820v1), Proposition9 and
equation50. The complete source-pool bridge is in
[INDEPENDENT-ENUMERATION.md](INDEPENDENT-ENUMERATION.md); the preceding cover
and its linear-subcover obstruction are in [JOINT-COVER.md](JOINT-COVER.md).
The new [independently checked case list](matrix-witness-results/signature-cover-505-independent.json)
contains original pool indices, normalized orbit tuples and unresolved statuses.

## Sixteen signatures and pair compatibility give the cover

Let \(u_t=X_{608+t}\), \(v_t=Z_{608+t}\), for \(0\le t<16\). Every
\(u_t\cdot v_t=1\). For an allowed source edge \(e=(x,z)\), define

\[
 s(e)_t=(x\cdot v_t)(u_t\cdot z)\in\mathbb F_2.
\]

If \(F=\{(x_i,z_i)\}_{i=1}^{128}\) is a full dual frame, dual expansion gives

\[
 \bigoplus_{e\in F}s(e)=(1,\ldots,1).
\]

The same conclusion follows directly from the physical pairing matrix's
rank128 and the rank factorization through its selected identity minor. Thus
the rule applies to arbitrary asymmetric frames, without a chosen-frame
invariance assumption.

Let \(C\) be the518 symmetry classes with nonzero signature, as proved in the
preceding report. All allowed edges outside \(C\) have zero signature. Remove
the following thirteen classes, using zero-based tuples\((a,b,h)\):

```text
(3,32,12)  (3,38,3)   (7,26,1)   (11,26,14)
(22,32,2)  (22,32,3)  (24,32,0)  (25,25,0)
(26,31,0)  (26,34,2)  (26,40,5)  (31,32,14)
(38,44,9)
```

Call this removed set \(R\), and set \(D=C\setminus R\). If a full frame
avoided \(D\), its selected edges in \(C\) would all belong to \(R\). They
would form a partial induced matching with XOR signature65535. An induced
matching has distinct endpoints and both ordinary cross-pairings zero for
every two different selected edges.

The source has400 actual allowed edges in the thirteen classes. The exact
CNF for a partial induced matching among those edges with XOR signature65535
is **UNSAT**, with a checked DRAT proof. This contradicts the required
signature of any full frame avoiding \(D\). Therefore \(D\) is a sufficient
cover, and \(|D|=505\).

This does not exclude the thirteen removed classes from full frames. A full
frame may contain edges from them as well as from \(D\). Nor does it complete
any of the retained505 cases. It reduces the number of starting representatives
needed for a complete conditional proof, without establishing a runtime gain.

## The proof is independently checked in physical coordinates

[signature_cover.py](signature_cover.py) constructs the logical-coordinate
discovery models and certificate. The final certificate uses the uncompressed
edge-signature encoding:2294 variables,15750 clauses, and no monomial occupancy
cap or restricted-support premise. A variable selects each of the400 edges.
Endpoint flags, source cross-edge clauses and at-most-one endpoint constraints
enforce an induced matching. Sixteen XOR chains enforce the target signature.

[verify_signature_cover.py](verify_signature_cover.py) independently rebuilds
all518400 pairings from the1088-qubit physical supports. It checks rank128,
the sixteen witness pairings, simultaneous translation and sector exchange,
the518-class support and the new505-class partition. Its separate encoder
regenerates the CNF byte for byte, then DRAT-trim checks the saved proof.
An empty proof is rejected. Literal enumeration checks both edge-signature and
compressed-signature encodings on4096 small signed bipartite graphs, totaling
235298 Boolean assignment controls.

These are written proofs and exact externally checked finite certificates;
there is no new Lean completion. Discovery solvers are unnecessary for replay.
The pinned DRAT-trim source is
[2e3b2dc0ecf938addbd779d42877b6ed69d9a985](https://github.com/marijnheule/drat-trim/tree/2e3b2dc0ecf938addbd779d42877b6ed69d9a985).

## Why the earlier linear obstruction does not prevent this reduction

The earlier rank16368 certificate proves that no single trace-one linear
functional gives a proper subcover of \(C\). The new argument requires all
sixteen binary identities and the induced-matching condition simultaneously.
The latter is nonlinear in the edge indicators. Linear representability of a
target syndrome does not ensure it can be represented by compatible edges.
Consequently the505-class subcover respects the earlier linear obstruction.

There is also a useful compression for discovery. The16304 nonzero-signature
edges realize only672 distinct signatures. In any partial induced matching,
delete all edges of a signature that occurs an even number of times, and keep
one representative when its multiplicity is odd. Deletion preserves induced
matching compatibility and the total XOR. Conversely, if a compatible edge
collection has signature-presence XOR equal to the target, keeping one edge
per present signature supplies an actual matching with that XOR. This proves
an equivalence of existence between the edge-XOR and signature-presence models.
The4096 signed-graph controls check that equivalence. Compression is useful
for discovery; the published505-cover proof does not depend on it.

## Broader matrix witnesses and determinant tests

The bounded arbitrary-vector search makes6235 trace-one witness comparisons.
The structured matrix search makes65152 comparisons: all single off-diagonal,
paired-diagonal and symmetric off-diagonal unit perturbations of the old
matrix, plus odd sums involving a256-element source-functional list. Neither
search finds a cover below518. The saved best matrices are independently
checked after regenerating canonical coordinates from physical seed pairings.
These observations do not establish a minimum over arbitrary matrices or an
independently exhaustive negative certificate for every discovery comparison.

The determinant pilot fixes each of the518 earlier anchor pairs \((x_0,z_0)\).
For translated witnesses, remaining frame pairs must satisfy

\[
 H_{rs}=u_r\cdot v_s+(u_r\cdot z_0)(x_0\cdot v_s)
       =\sum_{i\ne0}(u_r\cdot z_i)(x_i\cdot v_s).
\]

For a principal2-by-2 minor with determinant1, Cauchy–Binet forces two distinct
compatible remaining pairs whose two determinant factors are both1. The pilot
checks all120 principal minors per anchor. Its26964 nonzero conditions each
have an explicit compatible two-edge witness in the exact original pools.
Thus this separately tested minor-existence family excludes no anchor.
It does not show simultaneous consistency of all minors, and does not test
all nonprincipal minors or a complete exterior-square relaxation.

[verify_matrix_witness_pilot.py](verify_matrix_witness_pilot.py) checks all
26964 witnesses directly against physical pairings and105502 small full-basis
Cauchy–Binet controls. The determinant formula itself follows by expanding
\(\det(U^{\mathsf T}ZX^{\mathsf T}V)\) and grouping the two-index terms.

## Limits of the current signature model

All505 retained starting pairs have explicit compatible partial matchings
containing the anchor and satisfying the sixteen signature equations. Their
sizes range from7 to17, and all are independently checked. These are not
full128-frame completions. They prove that this particular signature-necessity
test cannot exclude any one of the retained anchors by itself.

In addition,85 of the original518 classes each have a checked partial signature
matching supported entirely within that single class. Any cover proved solely
by the current16-signature/induced-matching UNSAT criterion must retain those85
classes. This is a method-specific lower bound, not a lower bound for arbitrary
covers and not evidence that any class has a full completion. The achieved
upper bound within this method is505; no optimum has been established.

The counterexample-guided exchange trials, native-XOR trials and a diagnostic
using the older monomial cap produce no stronger checked result. Their SAT,
UNSAT-discovery and unknown outcomes are preserved separately. An initial
Python timer did not reliably bound solver calls while the solver held the
GIL; subsequent comparisons use native time/conflict limits and a separate
process timeout for proof generation. The bounded research block stays below
its two-hour ceiling. No continuous CPU-hour claim follows from wall time.

## A concrete independent identity for the next follow up

For anchor `X03-Z03-h00`, the saved eight-pair partial matching passes all
sixteen current identities. Let \(S=\sum x_i z_i^{\mathsf T}\) for these eight
pairs. Their Gram identity gives \(S^2=S\) and \(\operatorname{rank}S=8\), so
\(I-S\) is a nonzero projector of rank120. A nonzero residual identifies a
mandatory full-basis equation missed by the current model.

[select_residual_witness.py](select_residual_witness.py) selects the source
witness \((X_{705},Z_{705})\). Its required full-basis value is1, while the
saved partial matching gives0. The sixteen translates increase the functional
span rank from16 to32. These statements are independently checked, including
the residual projector and its rank. This rejects the saved partial matching;
it does not exclude the anchor.

The next bounded follow-up is to add that second witness orbit to the exact
fixed-anchor model, retaining every newly nonzero-signature source edge.
Additional identities should be selected from subsequent matrix residuals,
so each one demonstrably rejects a spurious configuration. The acceptance
gate is a checked anchored obstruction or a physical128-pair frame. That next
solver comparison has **not been run**. No finishing-time estimate is available.

## Replay and preservation

With Python3.12 and the pinned DRAT-trim executable:

```sh
python formalization/canonical-width/c16/verify_signature_cover.py --certificate formalization/canonical-width/c16/matrix-witness-results/signature-cover-505.json --drat-trim /path/to/drat-trim --output /tmp/c16-cover505-check.json
python formalization/canonical-width/c16/verify_matrix_witness_pilot.py --output /tmp/c16-matrix-pilot-check.json
```

The consumers use the Python standard library and preserved physical
reconstruction helpers. Discovery used native XOR solving, CaDiCaL proof
generation, a small CP-SAT exchange master and exact C++ bitset comparisons.
The [PySAT API](https://pysathq.github.io/docs/html/api/solvers.html) was consulted
as software documentation. No new research paper or canonical source target
is added by this block. The earlier literature collection is unchanged.
Historical manifests remain pinned to their original scientific revisions:
overnight175 files at398596d82f5b8eda184103f1510eca82daef6a99, and joint-cover42
files at62ff155fcd39364bb3b251a0da38c8821cddc711. Later central progress records
do not rewrite those manifests.

| Deliverable | Status | Evidence |
| --- | --- | --- |
| Test broader auxiliary vectors and structured matrices | Met | Frozen6235/65152 comparison records; saved best witnesses independently checked |
| Test a faithful conditional determinant family | Met |26964 physical minor witnesses and105502 full-basis controls |
| Obtain a proved reduction below518 | Met |505-case proper subcover; physical CNF regeneration and DRAT verification |
| Assess the remaining signature model | Met |505 anchored partial witnesses;85 single-class witnesses |
| Select a concrete stronger formula | Met | Residual rank120, rejecting witness705/705, functional rank16to32 |
| Resolve source width or complete a source case | Not achieved | Width16/18 and physical88 unchanged; all505 full completions open |
| Integrate to master | Pending | PR17 requires review; no bypass authorized |

**Question answered:** a complete505-case nonlinear subcover exists, with an
independently checked exact proof. The stated bounded witness and determinant
comparisons and method-specific partial certificates are complete.

**Question still open:** existence of a full128-pair source frame, equivalently
the original width16/18 question.

**Next proposed target:** follow-up — test the residual-selected second witness
orbit on the explicit anchor, then accept only a checked obstruction or actual
physical128-pair completion as case progress.
