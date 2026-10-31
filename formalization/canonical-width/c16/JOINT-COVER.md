# C16 paired basis cover with 518 cases

Every full minimum-pool frame for the fixed source code has a simultaneous
cyclic translate and optional sector exchange containing one of **518 listed
pairs**. This improves the earlier 1,082-case cover by using both members of
the dual basis. All 518 completion problems remain unresolved; the canonical
width is still **16 or 18**, and the best verified physical partial frame has
88 pairs. This is a written proof with independently replayed exact finite
certificates, without a new Lean completion.

The source target is `L-F91-c16-unrestricted-width`, Lee,
[arXiv:2610.06820v1](https://arxiv.org/html/2610.06820v1), Proposition 9 and
equation (50). The complete low-weight pool bridge is preserved in
[the independent enumeration report](INDEPENDENT-ENUMERATION.md).
The new list is in [source-witness-cover.json](joint-cover-results/source-witness-cover.json).

## A dual expansion forces a pair in a smaller set

Write the source logical pairing as the ordinary dot product on
\(V=\mathbb F_2^{128}\). Let \((x_i,z_i)_{i=1}^{128}\) be any full dual frame,
so \(x_i\cdot z_j=\delta_{ij}\). For arbitrary \(u,v\in V\),

\[
 u=\sum_i(u\cdot z_i)x_i,
 \qquad
 u\cdot v=\sum_i(u\cdot z_i)(x_i\cdot v).
\]

Choose \(u\cdot v=1\). The right side is odd, so at least one selected pair
satisfies both \(u\cdot z_i=1\) and \(x_i\cdot v=1\). Therefore the allowed
source edges in the rectangle

\[
 \{x:x\cdot v=1\}\ \times\ \{z:u\cdot z=1\}
\]

meet every full frame. Neither witness needs to be selected in the frame.
This implication requires a full dual basis; a partial frame does not suffice.

Use the actual source witnesses \(u=X_{608}\), \(v=Z_{608}\), in zero-based
pool order. Their pairing is 1. For each allowed pair orbit \((a,b,h)\), test
whether some phase \(t\in\{0,\ldots,15\}\) satisfies

\[
 (X_{16a+t}\cdot v)(u\cdot Z_{16b+(t+h\bmod16)})=1.
\]

There are **1,019** such oriented common-translation pair orbits. Sector
exchange identifies \((a,b,h)\) with \((b,a,-h\bmod16)\), leaving **518**
classes. A selected pair supplied by the dual expansion has one of those
classes. Translating that pair to phase zero, and exchanging sectors when
needed, proves the cover. This changes coordinates on a candidate frame; it
does not require that the frame itself be invariant.

For an alternative graph proof, let \(A\) be the complete binary source pairing
matrix. Its rank over \(\mathbb F_2\) is 128. If a frame selects row indices
\(I\) and ordered column indices \(J\), then \(A[I,J]=I_{128}\) and the rank
factorization identity is \(A=A[:,J]A[I,:]\). Its entry at the witness pair
is exactly the displayed dual expansion. This version uses only the actual
finite pairing matrix and its rank.

## What the finite optimization establishes

[find_source_witness_cover.py](find_source_witness_cover.py) checks all 6,238
allowed source witness pairs modulo simultaneous translation. Among these
witnesses, 518 is the minimum cover size, attained by the normalized pair
\((X_{608},Z_{608})\). This is not a minimum over arbitrary logical witnesses,
linear functionals, or frame-specific covers.

[verify_joint_cover.py](verify_joint_cover.py) independently reconstructs all
518,400 pairings from the 1,088-qubit physical supports. It verifies the rank
128 and both symmetry actions, rebuilds the 518-case list by literal endpoint
translations, and checks every one of the 6,238 witness costs by enumerating
actual rectangle edges. It also checks 10,852 small full-basis expansion
identities and rejects three corrupted cover records.

The 518-case list has 181 cases in common with the earlier 1,082-case list and
337 outside it. Thus this is a replacement sufficient cover. The other old
cases have not been excluded, and cases in either cover can overlap in their
full-frame completions. The 52.1 percent reduction in starting cases is not a
measured runtime gain.

## Linear identities cannot delete a case from this cover

For every full frame,

\[
 \sum_i x_i z_i^{\mathsf T}=I_{128}.
\]

Any binary linear functional \(L\) on these 128-by-128 matrices with
\(L(I)=1\) consequently supplies a cover: some selected atom has
\(L(x_i z_i^{\mathsf T})=1\). The preceding rectangle uses
\(L(xz^{\mathsf T})=(x\cdot v)(u\cdot z)\).

Let \(C\) be the 518 symmetry classes, and let \(W\) be the span of all allowed
source atoms whose classes lie outside \(C\). There are 83,504 such actual
atoms. The certificate supplies **16,368 independent atoms** in \(W\), so
\(\dim W\ge16368\). The sixteen simultaneous translates \(L_t\) of the
rectangle functional are independent, annihilate \(W\), and each satisfies
\(L_t(I)=1\). The ambient matrix space has dimension 16,384. It follows that

\[
 \dim W=16368,\qquad W^\perp=\operatorname{span}\{L_0,\ldots,L_{15}\}.
\]

Suppose a functional \(L'\) with \(L'(I)=1\) gives a cover contained in \(C\).
It must annihilate \(W\), hence \(L'=\sum_t c_t L_t\) with \(\sum_t c_t=1\).
Write \(f(s)=\sum_t c_t s^t\). Over \(\mathbb F_2\),
\(s^{16}-1=(s+1)^{16}\), and \(f(1)=1\); therefore \(f\) is a unit modulo
\(s^{16}-1\). On each translation orbit, the evaluations of \(L'\) are an
invertible cyclic convolution of the evaluations of \(L_0\). An orbit has
identically zero evaluations for one if and only if it does for the other.
This remains true after the two orientations are identified by sector exchange.
Consequently \(L'\) gives exactly \(C\).

Thus **no trace-one linear identity gives a proper subcover of these 518
classes**. This does not rule out a smaller linear cover that uses different
classes, a nonlinear cover, or an argument excluding individual completions.

[linear-cover-pruning.json](joint-cover-results/linear-cover-pruning.json)
contains the 16,368 atom indices and a direct functional. The producer uses
high-pivot elimination on logical outer products.
[verify_linear_cover_barrier.py](verify_linear_cover_barrier.py) regenerates
coordinates from physical canonical seed pairings, transposes the atoms, and
passes them to the separate low-pivot [rank consumer](check_binary_rank.cpp).
It independently checks the rank, the sixteen translated functionals, their
traces, and the direct functional's support. Identity and repeated-row controls
check the rank consumer's acceptance and rejection paths.

## The graph equivalence route gives no additional merging

Fixing an allowed pair \((x,z)\) leaves the X points in \(\ker z\) and Z points
in \(\ker x\). Their induced bipartite pairing graph must contain a matching
of size 127 with no additional cross edges. Conversely any such matching
completes the fixed pair.

For every one of the old 1,082 starting pairs, the residual graph has a different
degree histogram, even after allowing exchange of its two sides. Therefore
these 1,082 residual graphs are pairwise nonisomorphic. All residual pairing
matrices have rank 127; basic conditional rank excludes none. These are exact
finite statements about these graphs, not a prohibition on more general
mathematical reductions between their completion questions.

As a separate discovery check, pynauty 2.8.8.1 reports the full source graph
automorphism group has order 32, generated by the already used translation and
exchange action. The degree certificates independently establish the residual
nonisomorphism result without requiring nauty. The package was consulted through
its [primary documentation](https://github.com/pdobsan/pynauty); no new research
paper was acquired or counted in this block.

## A bounded joint rank family does not separate the old relaxation

For subsets \(S\) of X points and \(T\) of Z points, selected matching edges
inside \(S\times T\) form an identity minor of \(A[S,T]\). Their number is at
most \(\operatorname{rank}_{\mathbb F_2}A[S,T]\). The inequality also holds for
expected edge indicators, so it is a valid moment cut.

All 91,125 cuts with one side a single source orbit and the other one or two
source orbits, including both orientations, pass at the earlier exact rational
128-point relaxation. Independent replay computes ranks through the
multiplicity at \(t=1\) of the cyclic pairing polynomials, instead of the
producer's binary elimination. All these bounds also pass on the physical
88-pair witness. No statement about larger or phase-specific subsets follows.

## Replay and next proof target

From the repository root, using Python 3.12 and a C++17 compiler:

```sh
clang++ -std=c++17 -O3 formalization/canonical-width/c16/check_binary_rank.cpp -o /tmp/c16-check-binary-rank
python formalization/canonical-width/c16/verify_joint_cover.py --output /tmp/c16-cover-replay.json
python formalization/canonical-width/c16/verify_linear_cover_barrier.py --rank-checker /tmp/c16-check-binary-rank --output /tmp/c16-linear-replay.json
python formalization/canonical-width/c16/verify_joint_rank_cuts.py --output /tmp/c16-joint-rank-replay.json
```

These consumers use the Python standard library and the preserved physical
reconstruction helpers; nauty and numerical solvers are unnecessary. Discovery
scripts and outputs are preserved under [joint-cover-results](joint-cover-results).
The 1,082 residual signatures are gzip compressed.

The next follow-up should seek a **nonlinear condition shared by many of the
518 cases**, using the full inverse identities or the exact source dictionaries.
A first gate is an inequality that excludes the saved fractional 128-point
solution and has an independent source proof. Alternatively, a case exclusion
requires a checked obstruction; a 128-pair physical completion would settle
width 16. More linear combinations contained in this cover cannot shrink it.
No practical finishing-time bound has been established.

| Deliverable | Status | Evidence |
| --- | --- | --- |
| Audit all 1,082 residual graph equivalences | Met | Distinct exact side-degree histograms; independent physical replay |
| Test a genuinely joint source condition | Met | Dual-expansion cover518; 91,125 separate joint-rank cuts screened |
| Verify a useful theoretical boundary | Met | Outside rank16368 and16 translated annihilators; written convolution proof |
| Preserve original finite dictionaries | Met | Complete physical-pairing replay and regenerated canonical coordinates |
| Resolve canonical width or add a Lean completion | Not achieved | Width16/18 and physical88 unchanged |
| Integrate to master | Pending | Existing PR17 requires review; no bypass authorized |

**Question answered:** the finite source-pair witness strategy has minimum cover
518; the old 1,082 residual graphs are pairwise nonisomorphic; no trace-one
linear functional gives a proper subcover of the particular 518-case list.

**Question still open:** existence of a full 128-pair source frame, equivalently
the unrestricted width16/18 question.

**Next proposed target:** follow-up — derive and independently verify a nonlinear
source restriction shared by a family of the 518 completion cases.
