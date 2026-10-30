The exact exchange repair closes anchor40's previously inconclusive
present-conditioned Z-basis law at point12. It does not construct a joint
profile law, a complete dual frame, or a source cover-case witness.

The repository search found sector-exchange dual and partial-frame neighborhood
code, but no existing rational basis-mixture repair with the exchange graph
used here. `local_frame_exchange.py` performs a different bounded search for
physical partial-frame extensions. The new work uses fresh point12 targets and
the already saved point12 numerical basis mixtures; it reuses no point8
certificate.

Let E be the positive-target part of the zero-evaluation pool of one selected
X anchor. Its rank is127. Let q have total127, and let x be the marginal of an
exact probability distribution on physical bases of E. Numerical seed weights
are converted to their exact binary rational values and normalized exactly.
Every positive basis is independently rank checked before repair.

For every positive-weight basis B, a directed edge i->j is available when
i belongs to B, j does not, and B-i+j is another basis. Fundamental-circuit
coordinates compute these edges by exact binary elimination with augmented
unit coordinates. A path from an x-surplus s to a q-deficit t has one original
basis witness for each edge. If a basis B is used m_B times, take

    delta=min(x_s-q_s, q_t-x_t, min_B weight(B)/m_B).

Subtract m_B*delta from every original basis and add delta to the exchanged
basis for each path edge. Coalescing equal bases preserves total mass1 and
nonnegativity. Intermediate incidence changes cancel, leaving only-delta at s
and+delta at t. The positive marginal error decreases by exactly delta. The
multiplicity divisor is necessary: the independent repeated-basis control
permits delta1/6, while ignoring multiplicity would use1/4 and overspend a
basis of mass1/3.

For a complete exchange graph, let R be the vertices reachable from every
surplus. If no deficit is reachable, put C=E minus R. For every positive B,
the fundamental circuit of any j in C outside B must be contained in
(B intersect C) union{j}; otherwise there is an outgoing edge from R. Hence
B intersect C spans C and has cardinality rank(C). Averaging gives

    x(C)=rank(C)<q(C).

The implementation also directly recomputes physical rank(C), checks that
every positive B has this intersection cardinality, and checks the strict
rational target violation before emitting a rank cut. This final validation
does not rely on numerical residuals or a solver status.

The first version searches direct surplus-to-deficit edges and then the full
graph. A separately frozen successor first tries graphs from the8 and32
largest-mass bases for valid augmentations. Failure of those restricted
searches has no certificate meaning: complete-graph reachability is still the
fallback before the no-path branch. Both versions preserve the exact current
basis distribution and720-coordinate conditional target on timeout. The lazy
successor accepts these exact states for a future restart. No finite or
polynomial termination theorem is claimed from strict error decrease alone.

Independent finite controls cover2,944 states and21,732 literal exchange edges,
with2,642 valid path steps,250 directly verified rank cuts and52 matched states.
They include repeated-basis multiplicity and an incomplete-graph false-cut
control. The independent proof review is
`coupling-results/basis-exchange-repair-proof-review.txt`; the control receipt is
`coupling-results/basis-exchange-repair-lemma-independent.json`. The producer's
smaller controls are preserved separately for both versions.

Anchor40 started with positive marginal error approximately3.58e-13. In623
single-edge augmentations and8.41 seconds, repair reached exact equality.
Its956 zero-pool bases and96 unit probabilities represent91,776 implicit full
rank128 basis components. Each unit vector has anchor evaluation one, while
the entire zero span has evaluation zero, so every product component is a
full physical basis. Independent consumers reconstruct all720 exact target
coordinates, all basis ranks, zero/unit masses, nonnegative probabilities,
and physical symmetries; corrupted certificates are rejected.

The accepted anchor40 bank is
`coupling-results/singleton-exchange-witness12-o40.json`, SHA256
`e0e30250f6bba5d91272296c901f1bb88f4820aed9bdeecc47e8cb52e7a0c0ff`.
The existing generic consumer's receipt is the same prefix plus
`-independent.json`, SHA256
`22e92cc138882c19c1756dd2ebb78f0b7e09452b061ebe31894462ac3c2bdfa5`.
A second terminal consumer supplied by the independent audit agent proves
the full conditional marginal mixture directly, without using the search
trajectory.

The original anchor17 run stopped at480 seconds after158 augmentations,
preserving600 exact physical zero bases. Its positive error decreased from
about0.01416967 to0.00991779. An independent state consumer validates every
physical basis, the exact probability mass, the target binding and the exact
nonzero residual. This is a resumable state, not membership or nonmembership.
The separately frozen lazy comparison stopped at400 seconds with723 exact
bases and positive error about0.00712024. Its independently checked state is
also resumable. The two repair caps total880 seconds; both runs remain
inconclusive for anchor17 and neither produced a rank cut. The terminal states
and exact residuals are preserved in the final inventory; no additional run
is authorized by that inventory.

Anchor40's accepted repair supplements the earlier point12 singleton cohort:
it adds an exact conditional mixture where the bounded Wolfe/lattice stage
was inconclusive. The original cohort artifacts remain unchanged. All source
width and cover conclusions remain unchanged as well.
