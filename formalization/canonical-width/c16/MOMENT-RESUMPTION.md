# C16 resumed moment and obstruction investigation

Current verified result (30 October, 03:53Z): the user-restored goal is active.
Width remains 16 or 18, the sufficient cover 405, best physical partial frame
88/128, and zero full source anchors excluded. A single exact rational point
satisfies the combined finite moment families, 280 closed-span rank rows,
213,662 saved global-obstruction conditional rows, and every Boolean triple.
A new shared orbit-distribution inequality using only first/second moments
strictly excludes that point, independently of auxiliary profile weights.
Five further independently checked rank cuts also exclude it. The intersection
with these final new inequalities has not yet been decided.

Canonical target: `L-F91-c16-unrestricted-width` (issues3 and8).
Session: `c16-moments-20261030T0025`.
Branch: `research/c16-moments-20261030T0025`.
Baseline: `806665b75d552de2fe85864bd4b1f76299d902e2`.
Start:2026-10-30T00:25:01Z. Hard deadline:2026-10-30T04:25:01Z
(29 October,5:25–9:25p.m. America/Los_Angeles).

The user explicitly revoked the pause and restored the goal. Its active state
was read back before this block. This is a continuation of the original source
question, not a new target or a new claim of resolution. Width16 or18 remains
open; the sufficient cover is405, best physical partial frame88/128, and zero
full source anchors are excluded. The separate runtime-integration branch is
parked and is not adopted or modified here.

Answer contract: determine whether a full128-pair weight16 source frame exists
or is impossible. The next bounded gate tests the independently justified
conditioned moment inequalities from source forbidden patterns, including all
four already checked word-obstruction pair classes. Every full frame induces
a feasible moment point, so a complete exact infeasibility certificate would
exclude all frames. A checked rational feasible point only establishes a
limitation of this relaxation; a numerical status settles neither question.

Before substantial work, create an exclusive remote claim pointing at this
contract commit. Preserve all frozen earlier inputs and rejected candidates.
New result files live in `moment-resumption-results/`. Validate source binding,
matrix translation and necessary-versus-sufficient scope before interpreting
solver results. Positive pair certificates suffice for adding their clauses;
the earlier16200 negative pair screen need not be assumed independently checked.

Initial gates: independently replay the four positive pair certificates and
derive their zero moment entries; freeze a bounded necessary-model numerical
pilot with the full forbidden-pattern matrix. If it produces useful dual
evidence, recover and independently check an exact obstruction. If feasible,
try exact point recovery before concluding this relaxation remains inadequate.
Optional global order4 continuation requires zero-round source/CNF validation
before a frozen trial. No more cover-case sweep merely to reduce405 by a few.

Reserve the final30minutes for independent verification, preservation,
inventory/reconciliation and publication through PR17. Required review is not
bypassed. Update the authorized issue handoff and release only this session's
exact claim. Do not mark the original objective complete without a physically
checked128-pair frame or a complete justified obstruction. No subagents,
automatic schedules, broad literature campaign or runtime rewrite is planned.

## Active checkpoint,30 October01:09Z

The source question is still unanswered. The sufficient selected-pair cover
remains405; zero full source anchors are excluded and the best physical partial
frame remains88/128. This checkpoint does not close the four-hour block.

All four positive word-pair certificates were independently checked using both
literal cosets and the low-pivot consumer. Their moment faces, together with the
old forbidden-pattern bank, give31408 distinct coefficient rows. The older
compiler produced31412 anchor-tagged rows after its own deduplication; there are
31683 raw anchor instances before either deduplication. The coefficient sets
agree exactly. The old rational profile point violates47 distinct rows.
See `moment-resumption-results/preparation.json`.

The necessary-model SCS run finished numerically `optimal` in29.18seconds,
with maximum reported constraint violation1.62e-8. Five attempts to recover an
exact point are **rejected**, with each candidate and failure retained in
`recovery-attempts.json`. The last candidate satisfies the old exact linear
constraints and all31683 raw pattern inequalities, but fails the interval PSD
consumer; numerical block minima range down to about-2.80e-8. It is not a
feasibility certificate. A300-second all-constraint margin trial and600-second
PSD-only margin trial both returned inaccurate candidates and no certificate.
Strict-margin searches are sufficient-witness searches: failure cannot exclude
source frames.

### Conditional detector capacity through five, and two disjoint pairs

For a mandatory opposite set J, let U_J be all pool vectors annihilating J.
The evaluation vectors `(u dot w : u in U_J)` form a binary linear code.
A systematic parity-check matrix H gives an exact characterization: a subset
D is a detecting support if and only if the XOR of its H columns is zero.
For a fixed previously forbidden child K of size2,3,or4 and |D|<=5, the
remaining D\K has at most3 elements. Single- and pair-syndrome tables therefore
enumerate every such support without enumerating arbitrary five-subsets.

In a hypothetical full frame, at most|D|-1 selected basis vectors can lie in D
when D contains a forbidden child. Expanding w in the dual basis would then
express w modulo span(J) using at most|D|-1 opposite-pool words. The absence of
such a short expression is an obstruction. If D contains two **disjoint**
forbidden pairs, at most|D|-2 can be selected, so supports through6 need only
a short-word check through4. Disjointness is essential to that two-unit loss.

Both algorithms pass literal small-dimensional controls, including positive
five-detector examples and positive six-detector/two-pair direct-sum examples.
They yield **zero new obstructions** on the frozen383-case cohort (the already
excluded pair[416,512] is omitted from the older384-case cohort). Independent
replay reduces physical evaluation rows rather than pool vectors, checks
parity-check orthogonality and rank, and reproduces complete zero-hit coverage:
669902 eligible child instances for the first method and84341 disjoint-pair
bundles for the second. This rules out these precise compositions on this
cohort; it does not establish extendibility. Evidence:
`moment-resumption-results/conditioned-detector-independent.json`.

### Shrinking a fixed obstruction by a hitting set

Suppose w has detecting support D relative to J, and no expression with at most
q words modulo span(J). For every u outside D with u dot w=1, a smaller J'
must retain a j with u dot v_j=1. These are hitting-set clauses on J. Any
subset hitting them preserves D. Also span(J') is contained in span(J), so
the short-word impossibility remains true. This proves that a minimum hitting
set gives the smallest mandatory subset **for this fixed witness and support**;
another witness may give a smaller obstruction.

`minimize_four_witness.py` implements that argument for word orders1..4.
Twelve saved source witnesses pass independent physical/coset replay before
and after minimization. Direct physical enumeration of15706 smaller subsets
independently verifies the reported minima. Some11-choice witnesses shrink
to8 or9 choices; the earlier adaptive search already found some smaller clauses
by changing witnesses, so this is not a new minimum-clause theorem or a new
source-case exclusion. Its purpose is inexpensive automatic shortening during
the current global run.

### Combining previously separate moment restrictions

The earlier private-partner ownership theorem says that for distinct same-sector
i,k, `E[x_i x_k] + sum_{z common neighbor of i,k} E[x_i z] <= E[x_i]`.
It had not been included in the profile/capacity/forbidden-pattern model used
above. A physical-coordinate compiler now produces32355 sector-folded rows
(64710 before sector averaging). Every common-neighbor set agrees with the
earlier polynomial formula, and every row passes the exact cyclic/sector average
of the checked88-pair matching.

These rows reject213 entries of the older certified profile point and248 of the
latest PSD-rejected candidate. This is a genuine separation of those points,
not an infeasibility proof. A bounded necessary-model trial now combines the
ownership rows with the full profile, capacity, weighted and forbidden-pattern
constraints. The ownership theorem is reused; no new source paper or novelty
claim is introduced. Evidence: `physical-owner-preparation.json` in the result
directory.

### Global source-domain run in progress

The full source-domain zero-round model passes independent reconstruction of
all518400 physical pairings,4102 old rank certificates,20022 imported source
clauses and331 signature circuits. It permits all99808 source edges and fixes
no anchor. Its1128820-clause input hash is
`02499f07955d1dd3db63a69175d30381af08b8e613c4ef1c3614b2ea669aa0cb`.
The prepared order-four producer needed its consumer corrected from the old
order-three class to `FourTermConsumer` before use. The independently checked
hitting-set minimizer is applied to newly emitted word clauses.

One3600-second run began at01:02:07Z, frozen in
`moment-resumption-results/global-four-frozen.json`. Its result remains pending
at this checkpoint. A complete independently checked UNSAT proof would exclude
all full source frames. A partial SAT witness or timeout would leave width16
versus18 open. No matched runtime-speedup claim is made.

## Active checkpoint,30 October02:04Z

The source answer and cover are unchanged. The ownership-combined numerical
model returned `optimal` after209.73seconds, with maximum reported violation
1.97e-6. That numerical point violates11 of the older conditioned circuit rows
and182 other older linear rows (6rank-rectangle,118Boolean-triangle,58integer-form).
Thus the separate successful numerical relaxations cannot be substituted for
their intersection. This is a checked reason to combine the restrictions, not
an infeasibility result.

### Physical combination of existing degree-two restrictions

The polynomial-coordinate circuit classes were translated through the checked
normal form back to physical pool indices. The160old sector classes fold to80.
Their zero sums and minimal ranks were recomputed in both physical pools under
all16shifts (2560checks). The115200 distinct conditioned circuit rows agree
coefficient-wise with the old compiler; all pass the exact averaged88-pair
control. `physical-rank-preparation.json` and `physical-circuit-independent.json`
record the checks. The physical rank bank hash is
`8a7c6e806ca0eda3cf44635b3720ef381a3966439688645cd320ee592d54b17f`.

The older rank-rectangle, Boolean-triangle and integer-form restrictions were
also translated, including orbit rephasing. There are12849distinct rows:
11773rectangle rows,739triangle rows and337integer-form rows. Independent
physical checks cover6283rectangles in both sectors,16literal triangle truth
checks,10612integer-form Boolean checks and72900old-coordinate moment entries.
Every row passes the exact88-pair control. See
`physical-legacy-linear-preparation.json`. These are reused theorems and sources;
this block's contribution is their checked combination with the newer profile,
capacity and forbidden-pattern restrictions.

The cardinality equations force known null vectors of the zero-frequency PSD
blocks. Deleting their final coordinates is an equivalent PSD test: if a known
kernel vector has nonzero last coordinate, the whole symmetric matrix is
`B P B^T` for its retained principal block P and
`B = [I; -v_prefix^T/v_last]`. Exact reconstruction was checked on the existing
affine-feasible candidate. That candidate still fails PSD; this reconstruction
does not certify it.

The circuit/ownership combination and the full listed-family combination each
hit a1020-second outer limit before a terminal solver result. Their status files
now say `UNKNOWN_OUTER_WALL_LIMIT`, linked to their exit records. No numeric
infeasibility or feasible point was obtained from these two runs.

### Removing profile auxiliary variables, and solver diagnostics

The full profile model uses43473convex-combination weights in addition to32535
independent moment variables. An outer formulation replaces those weights by
supporting inequalities. Its initial7290inequalities use every signed single
coordinate and signed pair of the9local profile features for each of45orbits.
Every bound is recomputed as an exact integer maximum over all shapes of its
own orbit;7042626shape/cut instances were checked. Across the45orbits there are
43473shapes. This removes the43473auxiliary variables but initially weakens the
relaxation. It is not a reduction in the405cover cases, nor a same-strength
runtime improvement. Future separation can add valid integer support directions;
failure of a numerical separator is not exact hull membership.

The fresh unchanged hull consumer passes all43473shapes,1437309unexcluded phase
patterns and518400physical pairings, with the prior critical cap11 as an explicit
dependency. An initial replay failed its hash guard because the compressed
profile file was supplied instead of the recorded uncompressed file. Decoded
JSON equality was checked and the correct dependency passed in48.17seconds.
Both attempts are retained in `profile-hull-audit-input-correction.json` and
`profile-hulls-corrected-independent.json`; no data or hash guard was weakened.

The direct outer-model solver hit its900-second outer limit. The indirect
pilot returned `optimal_inaccurate` after50iterations and445.66seconds total,
with maximum constraint violation0.1606. It spent377.40of410.17solver seconds
in linear solves. The configured300-second solver cap was only checked at
coarse iteration boundaries. This candidate is neither a feasible point nor
an obstruction. A separately frozen180-second pilot tests `rho_x=0.01` on the
same outer constraint set. A separately frozen300-second HiGHS run tests the
full-profile **linear** relaxation, dropping all PSD blocks. Both are pending
at this checkpoint; neither numerical status alone can settle the source.

### Completed global trial, replay pending

The3600-second global run ended `UNKNOWN_OUTER_WALL_LIMIT` after3557saved
records. It emitted6713new same-sector closure obstructions and198new signature
circuits, for26735total source cuts and529total signature circuits. Every new
source cut came from closure; the order-four stage and fixed-witness minimizer
were not reached for new cuts. The new cut cardinalities range from3through13,
including one triple. A full independent physical/CNF/record replay is running.
No source anchor is excluded and there is no full frame. These additional
clauses are reusable proof-search input, not a mathematical resolution or a
measured reduction of the sufficient cover.

## Adaptive basis inequalities, 30 October 02:25Z

A new separation routine uses the basis requirement directly. Let I be a
selected independent set in one physical pool. For any subset K, `|I∩K|` is at
most `rank(K)`. If a same-sector vector a is required to be selected, the
stronger bound is `rank(K∪{a}) − 1[a∉K]`: when a is outside K, its inclusion
uses one dimension of that union. Multiplying by the selection indicator for a
and averaging gives a necessary degree-two moment inequality. For an opposite-
sector K, the unconditioned rank bound is valid after conditioning on a.

The previous rectangle bounds use particular subsets K. The new routine chooses
arbitrary K from a fractional candidate without enumerating all subsets. It
approximates projection onto the convex hull of basis indicators, using a
maximum-weight basis oracle at each step. The oracle sorts weights and accepts
independent vectors greedily; requiring a fixes that element first, equivalently
contracting it. Adding a constant to all weights preserves the maximizing bases
because their cardinality is fixed. The implementation reference is SageMath's
[greedy maximum-weight independent-set documentation](https://doc.sagemath.org/html/en/reference/matroids/sage/matroids/matroid.html#sage.matroids.matroid.Matroid.max_weight_independent),
recorded in the shared source ledger; Sage itself was not run. No new research
paper or author-posed question was acquired in this block.

At each projection step, threshold prefixes of the residual weight ordering
are tested for rank violations. Floating-point optimization only proposes K.
The saved inequality uses an integer rank, checked independently by low-pivot
elimination from the physical source. Thus a faulty or prematurely stopped
projection can miss a cut, but cannot validate an incorrect bound through the
consumer. This bounded implementation is not a complete matroid-polytope
membership algorithm, and nonseparation is not a feasibility certificate.

The first exploratory screen of the older ownership-combined candidate took
59.06 seconds across 90 conditioned queries and found 45 rank inequalities:
20 same-sector and 25 opposite-sector. Of these, 38 have numerical violations
above 1e-4; the maximum is about 1.09434. The remaining seven are near the older
solver's tolerance. All 45 pass 1,440 independent shifted/sector rank checks;
reduced-bound corruptions are rejected. The compiler also agrees with literal
32-symmetry averaging on 540 arbitrary-selection controls. Small literal
matroids check 17,496 greedy optima, 122,472 prefix bounds and 17,024 conditional
independent-set inequalities, including positive and nonviolating controls.
The exploratory run was recorded after completion, explicitly not presented as
preregistered or as a runtime comparison. Files: `matroid-owner0*.json`,
`matroid-small-controls.json`, and `matroid-matrix-independent.json`.

Loading all 115,200 circuit rows and 12,849 legacy rows had been expensive.
An adaptive model retains full ownership/profile/forbidden constraints and adds
only violated rows from those two fixed families, then screens the result
against every omitted row. Its first round added 9 circuit and 181 legacy rows;
a 600-second run remained inaccurate, with another 13 circuit and 31 legacy
rows above 1e-5. Repeated solver rescaling consumed substantial time.

A fixed-scale warm start was then tested with the expanded active rows and the
45 checked rank cuts. The first attempt stopped before solving because CVXPY
had replaced the IDs of nonnegative profile-weight variables. Its failure is
preserved as `unified-matroid-warm0`; the corrected mapping follows the recorded
attribute-reduction map and checks every canonical coordinate exactly once.
The corrected `warm1` trial returned numerical `optimal` in 39.59 seconds
including preparation, with maximum reported violation 6.75e-13. Its candidate
passes all 115,200 circuit rows numerically but violates two omitted legacy rows,
by up to 0.09003. The next active trial includes those two rows. This is a useful
working numerical route, not an exact feasible point or a proof of the source
answer, and no matched speedup factor is claimed.

The earlier global trial now has a complete independent PASS: all 26,735 source
cuts, 529 signature circuits, 3,557 saved partial records, and the final
1,346,804-clause input were reconstructed. It checked 820,012 forced covectors.
The run's outcome remains UNKNOWN; no UNSAT proof was produced.

## Exact checkpoint, 30 October 02:30Z

**The previously combined finite relaxation is feasible, and the new conditional
rank family strictly strengthens it.** This is an exact result about the
relaxation; the original width is still 16 or 18.

The `warm2` candidate was recovered as 76,008 rational values. The unchanged
profile consumer rechecks all 636 affine equations, 43,473 nonnegative profile
weights, capacity/conditional/weighted constraints, the physical moment
conditions and 256-bit interval PSD certificates. A separate exact consumer
then checks every one of the 31,683 raw conditioned forbidden-pattern rows,
32,355 ownership rows, 115,200 circuit rows, 12,849 legacy linear rows and the
first 45 conditional matroid rows. Every check passes. The feasible certificate
hash is `21f3d329f66e5f7c57dd51d9c66a7157dc0c40a2e822374f7e7ea90ef1b818aa`.
Evidence: `warm2-rational-candidate.json.gz`,
`warm2-rational-old-family-replay.json`, and `warm2-unified-exact.json`.

Consequently, further numerical effort on exactly those finite constraint
families cannot yield a valid infeasibility proof. A stronger necessary
condition is required. The broader conditional-rank search supplies one:
42 further independently checked inequalities were found from `warm1`, and
41 of them strictly reject the recovered `warm2` rational point. The largest
exact violation is `500387259403211/1125899906842624`, approximately 0.444433.
This proves strict strengthening, without claiming the new intersection is
infeasible. The new bank is `matroid-warm1.json`; its independent rank consumer
is `matroid-warm1-independent.json`. A bounded model now includes both banks.

This closes the earlier exact-recovery gap for the listed relaxation and gives
a concrete next mathematical direction: conditional rank inequalities on
arbitrary physical subsets, selected by a greedy basis oracle. It neither
constructs a joint distribution on frames nor reduces the 405-case cover.
No full source anchor or the source width is settled.

## Conditional faces and span closure, 30 October 02:54Z

Selecting a physical X vector a forces exactly one selected Z vector to pair
nontrivially with it. The other 127 selected Z vectors lie in its orthogonal
pool and form a basis of that rank-127 hyperplane. Conversely, any basis of the
orthogonal pool together with one nonorthogonal vector is a basis of the whole
space. This does not guarantee compatibility with the rest of an X frame, but
it identifies the exact face relevant to this conditional basis relaxation.
The separator can work directly in the orthogonal pool instead of approaching
that face through convex combinations of off-face bases.

`verify_zero_pool_face.py` checks this decomposition on all bases in the complete
binary pools of dimensions 2, 3 and 4, and independently recomputes all 90
representative physical orthogonal-pool ranks. The first source pilot finds
24 further rank cuts in 54.28 seconds; every cut passes the unchanged independent
rank consumer. It is a bounded separation result, not full polytope membership.
An eight-round controller alternates this search with the broader basis search,
checks every new bank exactly, and screens each numerical point against all
saved circuit and legacy rows. It has its own 03:25Z stopping boundary, before
the block's verification reserve. Intermediate candidates are not source frames.

There is also an exact strengthening that needs no numerical optimization.
Replace a rank subset K by all physical pool vectors in its span. The rank is
unchanged while the left side increases by nonnegative moments. For a selected
same-sector anchor, first include the anchor in K; its new diagonal term equals
its marginal and cancels the one-unit bound adjustment. Then close the augmented
span. A full-rank closure is the whole pool and its inequality follows from fixed
cardinality. This dominance argument is replayed coefficient by coefficient.

On the first 149 accumulated rank cuts, closure gives 131 unique nontrivial
cuts: seven inputs are already implied by cardinality and the rest of the
reduction comes from duplicate closures. It strengthens 133 inputs by a total
of 1,814 additional nonnegative moment terms. Independent low-pivot replay
reconstructs every complete closure and verifies every dominance relation.
Evidence: `closed-rank-bank0-independent.json` and
`closed-rank-bank0-dominance.json`. The closed bank numerically rejects 63 rows
at the later loop-2 candidate, by up to 0.57784. This last separation is numerical;
the rank bounds and dominance statement are exact. The 149-to-131 reduction is
in a relaxation row bank, **not** in the 405-case source cover.

The exact older-family feasible point and its 41 strict rank-cut separations
also pass in a detached clean checkout of
`a423fbe913ea02a7fa536e6994151fe65100f9d6`; that worktree remains clean.
See `clean-unified-replay.json` and `clean-replay-provenance.json`.
Current planning now records the explicit resumption rather than the historical
pause. Reconciliation and planning validators pass with unchanged counts:
424 canonical entries, 160 eligible targets, 204 paper records, 165 full-text
screens and six complete Lean targets. The source index has one new software-
documentation record (132 total); that does not add an academic paper or question.

## Consolidated rank point and complete Boolean-triple checks, 03:30Z

The eight-round rank loop ended after its fixed eight rounds. Its 311 raw rank
rows reduce by exact closure and deduplication to 260 proper-span rows. A frozen
comparison of corrective and ordinary zero-pool projections found 21 cuts at
the same 21 anchors in both runs. Corrective projection took 217.87 seconds
versus 96.32 seconds, with different subsets at 15 anchors; it did not improve
anchor coverage on this cohort and is not adopted as a general improvement.
Both banks pass independent physical-rank replay. Adding them and closing spans
gives 280 distinct proper-span rows. “Proper-span” only means rank below 128;
it does not assert irredundancy relative to every other constraint family.

The resulting combined model has an exact feasible point,
`consolidated-small-pivot-rational.json.gz`, SHA-256
`c2a8629cdf85e41c15705b2b51749ae680d7ded24108f15f02f8cc66c066f4c1`.
The standard profile/physical/interval-PSD consumer passes, and
`consolidated-unified-exact.json` passes every ownership, circuit, legacy and
280 closed-rank row. An earlier recovery excluded small positive pivot weights
and failed rank recovery; retaining weights above 1e-10 instead of 1e-6 fixes
that producer issue without changing any exact acceptance condition. The earlier
closed-final candidate's failed PSD recovery is also preserved.

An additional exact screen consumes all 26,735 source obstructions from the
independently replayed unrestricted global run and its 4,102 initial rank
obstructions. For a forbidden event set E and an event a in E,

    sum_{b in E, b != a} E[a b] <= (|E| - 2) E[a].

This follows pointwise: if a is selected, not every other event can be selected.
The formula also applies to mixed X/Z forbidden sets. Under simultaneous phase
rotation and sector swap, E[a b] is the S or T moment at relative phase b-a.
All 213,662 rows, including duplicates, pass exactly. Signature circuits of the
selected projection are deliberately excluded: they are not full-frame forbidden
sets. The global certificate and its independent replay are byte-bound to their
immutable published a423fbe revision. Independent literal group-average controls
cover 16,788 comparisons on 541 selected obstruction sets, including all saved
mixed and fourth-order kinds. See `consolidated-global-moment-screen.json` and
`new-moment-translations-independent.json`.

A bounded joint-marginal probe then tested 128 frozen sets of 12 events. It
enumerates all 4,096 local patterns and retains those meeting necessary physical
independence and cross-pairing degree restrictions. One LP dual yields an exact
separation. Its support simplifies to the ordinary Boolean triangle

    E[a b] + E[a c] - E[b c] <= E[a].

Independent replay checks that particular cut on all 4,096 assignments, without
trusting the producer's physical filtering. This is a missing elementary row,
not a new structural theorem. The other 127 numerical zero objectives are not
exact local-feasibility certificates.

That observation motivates a complete, rather than sampled, three-event screen.
For marginals p_a,p_b,p_c and pair moments q_ab,q_ac,q_bc, let t be the probability
of all three events. The eight atom probabilities are nonnegative exactly when

    max(0, q_ab+q_ac-p_a, q_ab+q_bc-p_b, q_ac+q_bc-p_c)
      <= t <= min(q_ab, q_ac, q_bc, 1-p_a-p_b-p_c+q_ab+q_ac+q_bc).

Given the existing pair bounds, this interval is nonempty precisely when the
three triangle inequalities and the union inequality hold. Each comes directly
from the eight Boolean assignments. This characterizes a distribution for each
triple separately, not one consistent distribution over all 1,440 events.

`complete_boolean_triples.py` checks all centers in the 45 representative X
orbits and all distinct other event pairs. Cyclic rotation and sector symmetry
cover every physical center. It checks 93,117,690 rows including symmetry
duplicates. Integer lower/upper enclosures at denominator 2^50 certify negative
slacks in batches; every uncertain row uses exact rational arithmetic. This is
not a floating tolerance test. The consolidated point violates exactly 118
rows, all saved. The initial strengthened solve is numerical only and exposes
one omitted legacy row plus two further triangles; the next trial includes them.
No new full source exclusion follows from any of these separation results.

## Exact triple-consistent point and a shared-profile obstruction, 03:45Z

The corrected Boolean trial has an accepted rational point,
`boolean-rational1.json.gz`, SHA-256
`d1b45692b268f5618b9ea710befcc5f1bdacbd86ef4014da354e2a1b492011b8`.
The profile/physical/interval consumer, full ownership/circuit/legacy/280-rank
consumer, and all 213,662 global conditional rows pass. The complete triangle
and union screen also passes all 93,117,690 checked rows.

A second consumer, `verify_all_triple_distributions.py`, imports neither that
screen nor its compiler. It uses a common exact integer denominator and directly
constructs the eight atom probabilities at the lower endpoint of the interval
above. It checks 46,558,845 triple representatives including symmetry duplicates,
with 372,470,760 nonnegative atom checks, in 27.34 seconds. Thus each physical
triple separately admits a rational distribution. No common distribution over
all events is implied. The 128-set local 12-event follow-up finds no further
exact cut; its numerical zero objectives do not certify feasibility.

The next coupling uses an entire orbit's 16 phase indicators, not just triples.
Let P be its selected phase mask, s(P) its autocorrelation shape, and A_a the
selection indicator of an anchor in either sector. A full frame induces a single
unconditional distribution g(P), shared by all the subdistributions
Pr(P,A_a=1). Those subdistributions are dominated by g(P), reproduce the pair
moments, and vanish whenever physical rank or cross-pairing rules make that
anchor incompatible with P. Cyclic averaging makes g constant on each rotation
class. The old relaxation fixed only shape weights and separate moment bounds;
it did not require these common subdistributions.

For integer affine functions L_a(P), define a bound B_s by

    B_s >= max_{rotation classes C of shape s}
             (1/|C|) sum_{P in C} sum_{a compatible with P} max(0,L_a(P)).

Then every source frame satisfies

    sum_a E[A_a L_a(P)] <= sum_s B_s Pr(s(P)=s).

This follows pointwise from A_a L_a(P) <= max(0,L_a(P)), with zero contribution
for physically incompatible selected anchors, followed by cyclic averaging.
The left side uses only anchor marginals and phase pair moments; the right side
uses the existing shape weights. This derivation does not assume independence
of anchors, and the bound is valid even though the LP permits such independence.

The all-90-anchor orbit32 pilot yields an integer functional with 14 nonzero
anchor rows. Independent replay enumerates all 65,536 phase masks by direct
contained-obstruction tests, retains the same 4,597 allowed masks, recomputes
physical ranks with the opposite pivot convention, and checks every allowed
mask's 16-rotation bound. Its exact violation at the accepted point is

    1837544431757296417 / 72345824414079647744 = approximately 0.02539945.

Evidence: `common-profile32-all.json` and
`common-profile32-independent.json`. The positive result is a strict
strengthening of the **extended** moment/profile relaxation: changing auxiliary
shape weights while keeping the same first/second moments might remove it.
A separate bounded pilot frees those weights to test that distinction; it is
not presumed infeasible. Orbit27's ten-anchor and all-90-anchor pilots produce
no exact cut. Their near-zero, slightly negative numerical phase-I objectives
are solver-tolerance effects, not exact feasibility certificates.

The free-profile-weight 90-anchor orbit32 LP reached its 120-second solver
limit (122.02 seconds total) without a primal solution or exact cut. This is
UNKNOWN, not feasibility or infeasibility. A final 180-second conditional-rank
probe completed 61 of the 90 ordered anchor queries and found five further cuts.
All five independently replay and strictly reject the exact Boolean-consistent
point, with maximum violation `33902180140403/562949953421312`, approximately
0.06022237. The frozen settings were recorded at launch after the process started
but before its result; this is an exploratory probe, not a preregistered holdout.
Neither the finite 280-row bank nor the bounded rank separator is complete for
all conditional matroid inequalities. See `final-point-rank-separation-exact.json`.

## Next bounded follow-up and stopping gate

This is a **follow-up** to the same source question. The next model should combine
the five newly checked rank rows with the shared-profile inequality, keeping the
complete triple screen as an acceptance gate. Recover an exact feasible point
before enlarging that model again; alternatively, recover an exact dual
infeasibility certificate for the necessary model. A failed strict-interior
search is not such a certificate. The numerical generator may retain its
interior margins only for witness production.

The central structural question is whether orbit32 admits a shared unconditional
phase distribution when its shape weights are allowed to vary at the saved
first/second moments. A bounded sparse LP or its explicit hinge-function dual
is the next focused test. A certificate involving only first/second moments
would remove the current auxiliary-weight caveat. A numerical timeout or a
successful fixed-weight separation does not remove it.

No further cover sweep, broad literature campaign or runtime rewrite is warranted
by this block. The finite constraints now have exact feasibility evidence, while
the coupled distribution and still-incomplete conditional matroid families have
concrete separating certificates to work from. Neither route has a demonstrated
end-to-end finishing bound. A full physically checked 128-pair frame or a complete
source-valid obstruction is still required to answer width16 versus18.

## Removing the profile-weight caveat, 03:53Z

The large free-weight pilot's timeout is not the endpoint. Restricting its
anchor list to the 14 rows supporting the earlier functional gives a much
smaller necessary model (32,107 variables) while retaining a potential
infeasibility implication. That free-weight LP returns a separating candidate
in 8.35 seconds. The exact consumer then verifies it independently. Its
unconditional coefficients apply to

    (1, E|P|, E|P intersect (P+1)|, ..., E|P intersect (P+8)|)

and are `[-1,-16,8,8,6,7,8,7,7,4]`. These expectations equal 1,16p_32, and
16S_h[32,32]. Together with the saved anchor linear forms, the resulting
functional is at most zero for every allowed cyclic mask class. The source
inequality therefore involves **only first and second moments**, without fixing
the shape weights. The earlier projection caveat is resolved for this new cut;
it remains a correct limitation of the first fixed-weight certificate.

The exact violation is
`5539176242857167/565201753234997248`, approximately 0.0098003522. Removing
entirely nonpositive anchor functionals leaves their hinge contribution zero;
replaying the unchanged class bound yields a cleaner 12-anchor certificate with
the same violation. The primary final pair is
`common-profile32-projected-pruned.json` and
`common-profile32-projected-pruned-independent.json`. The consumer enumerates
all 4,597 allowed masks, checks every 16-rotation class bound, independently
recomputes 482 physical ranks, and rejects a lowered tight bound. The unpruned
free-weight result and the earlier timeout remain saved.

This proves a strict strengthening of the finite relaxation even after
projection to its first/second moments. Equivalently, this particular accepted
moment point cannot have the shared orbit32/anchor distributions required by
full source frames, despite every triple having a distribution. It does not
prove that all feasible points of the old relaxation fail, or that the newly
strengthened relaxation is infeasible. No source frame or complete obstruction
has been produced. The next solve should include this projected inequality
and the five final rank rows; the earlier fixed-weight inequality is optional
additional information. No solve of that final intersection is claimed here.

## Requirement-to-evidence record

| Requirement | Status | Evidence and limit |
|---|---|---|
| Restore goal and continue authorized block | Met | Goal read back active; pause explicitly revoked; timed block and owned remote claim recorded |
| Answer width16 versus18 | Partial | Still open; no full128-pair witness or complete obstruction; cover405 and partial88 unchanged |
| Exact structural progress | Met | Conditional zero-pool face, span-closure dominance, exact finite-relaxation feasibility, complete triple distributions, and projected shared-profile separating inequality |
| Independent source binding and acceptance | Met for stated auxiliary claims | Physical rank/closure consumers, exact rational and interval PSD replay, immutable global source replay, all-mask shared-profile consumer |
| Preserve failed and limited trials | Met | Recovery rejections, full-model timeouts, negative detector cohorts, unhelpful corrective comparison, numerical-only local probes, free90-anchor timeout |
| Clean-checkout final replay | Met | Ten consumers pass from immutable2c0824788c162ab24579c7311b08f112ec9d747b in44.46seconds; clean before/after; `final-clean-replay/summary.json` |
| Inventory and source reconciliation | Met |424 canonical,160 eligible,204 papers,165 full screens,6 Lean complete; zero source-resolution delta, one software-doc index row |
| Literature harvest | Not applicable to new papers | No new paper acquired in this block; Sage documentation indexed as software, not a paper or author question |
| Publication on master | Pending required review | PR17 is the authorized integration route; work branch is a checkpoint until master integration |
| Resumable next action | Met | Final exact point and separating cuts, bounded next necessary-model solve and explicit source acceptance gate |

## Preservation and independent replay

The scientific checkpoint is `2c0824788c162ab24579c7311b08f112ec9d747b`.
Ten independently callable consumers pass in a detached clean checkout, with
outputs kept outside that checkout. The replay covers augmented rank validity,
span-closure dominance, final rank validity and strict separation, full combined
exact moments/PSD, global-obstruction moment consequences, the complete Boolean
triple screen, direct exact triple distributions, and fixed/projected/pruned
shared-profile inequalities. The checkout is clean before and after all checks.
Elapsed replay time is44.46seconds. Commands, logs and hash-bound receipts are
in `moment-resumption-results/final-clean-replay/`. The earlier global physical
CNF replay remains an unchanged immutable dependency; its430-second replay is
not silently counted as part of this44-second check.

Concurrent master `4c78e0d9ec4fcdc0289d17b90e5ac40f0eaf5d4c` was merged without
conflicts as `4d390f38df27407a5e5d5815931ded931119f1e3`. Those independent
replication changes do not touch the C16 scientific inputs or central ledgers.
The exact research artifacts remain identical to the scientific checkpoint.
PR17 still reports `REVIEW_REQUIRED`, so publication to master is pending.
The user-restored goal has not been marked paused or mathematically complete.

Three deliberately corrupted copies of the final projected certificate are
also rejected from the clean checkout: an invalid class bound, a false claimed
violation, and a wrong point hash. These are rejection controls, not source
certificates. Their separate receipt is `final-negative-controls/summary.json`.
[Exact resumption instructions](MOMENT-RESUME.md) give the next row translation,
model-scope distinction, acceptance commands and remaining gap.

## Finite mathematical kernel and formalization boundary

The shared-profile argument can be stated without any LP. Let M be a finite
rotation-stable mask set, G the16 cyclic rotations, and I a finite anchor set.
Let g:M→Q be nonnegative and rotation invariant. For each anchor a, let
q_a:M→Q satisfy0<=q_a(P)<=g(P), with q_a(P)=0 whenever the physical compatibility
predicate K_a(P) is false. Let F be rotation invariant and L_a any rational
function on masks. Define

    H(P) = F(P) + sum_{a:K_a(P)} max(0,L_a(P)).

If sum_{h in G} H(hP)<=0 for every P in M, then

    sum_P g(P) F(P) + sum_{a,P} q_a(P) L_a(P) <= 0.

Proof: for compatible masks, q_a L_a<=g max(0,L_a) by splitting on the sign
of L_a and using0<=q_a<=g; for incompatible masks q_a=0. Summing bounds the
left side by sum_P g(P)H(P). Reindexing each finite rotation sum and using
invariance of g shows that16 times this bound equals
sum_P g(P) sum_h H(hP), which is nonpositive. Divide by16. Normalization of g
is needed to interpret probabilities, but not for this inequality.

For the projected certificate, F is the saved linear combination of the constant,
mask weight and eight autocorrelations; L_a are the saved affine phase forms.
The consumer checks the hypothesis for every allowed mask exactly. A full frame
provides g and q after cyclic/sector averaging. This is the explicit bridge
between the finite certificate and the necessary source moment inequality.

An intended Lean interface would take finite types M/I/G, a finite group action
on M, rational g/q/F/L, invariance, domination and compatibility hypotheses,
then conclude the displayed finite-sum inequality. Its proof needs finite-sum
reindexing and ordered-ring inequalities. The physical pool-to-mask hypotheses
and the concrete all-mask certificate would be separate declarations. This
interface and written proof are not a compiled Lean result, and no Lean coverage
count changes.

The published70ab504 tree contains all567 manifest artifacts with matching Git
blob identifiers and byte sizes (170,645,233 bytes total). The recursive GitHub
tree is untruncated. `remote-publication.json` records this check. Both research
and PR branches point to the validated checkpoint; master remains pending review.

A final source-bridge audit checks sector averaging explicitly, rather than
leaving it implicit in the older folded-coordinate consumers. The two physical
pools each have rank128. The256-bit graph sets for X_i→Z_i and for one phase
rotation in each pool also each have rank128, proving those index maps extend
to linear isomorphisms. All518,400 cross pairings agree under sector swap, and
all518,400 agree under the phase generator. Therefore both operations map every
full Gram-identity source frame to another such frame. Averaging over their32
actions preserves all source-valid necessities and justifies the common S/T
coordinates used by the new projected inequality. The exact standalone receipt
is `symmetry-bridge-independent.json`; no assertion of physical completion or
new source resolution is involved.

The additional physical-symmetry consumer also passes from a clean detached
checkout of `fdb305e080590c4dfc4f77a903198b0866c8ea21`;
`symmetry-bridge-clean-provenance.json` binds its receipt. At04:15:19Z the owned
claim was deleted with its exact expected-SHA lease and verified absent, after
both branches held the published results. This releases the bounded block's
coordination claim; it does **not** pause or complete the user's original goal.
No research computation remains running. A continuation should acquire a fresh
create-only claim and use the saved exact point and final new cuts.

**Question answered:** the listed finite moment relaxation, including every
Boolean triple, is exactly feasible; the final projected shared-orbit inequality
and five new rank inequalities strictly strengthen it.

**Question still open:** the original width16 versus18, and feasibility of the
intersection after those final added inequalities. No full source anchor is solved.

**Next proposed target:** follow-up, compile the final projected row and rank
bank into the necessary model, with exact translation controls and a capped
solve/recovery gate as described in `MOMENT-RESUME.md`.
