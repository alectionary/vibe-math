# C16 literature-guided technique review

Session: codex-c16-literature-20261028T033734Z.
Started2026-10-28T03:37:34Z. Canonical target: L-F91-c16-unrestricted-width,
https://github.com/alectionary/vibe-math/issues/8 . Follow-up, not a new problem.
Base:3e138b22f2f93c5bcc7f2f56bae21afc31ea0971.
Work branch: research/c16-literature-20261028T033734.

The original width remains16 or18; best physical partial frame88/128. Exact
partial results require at least three of five thin families in each sector,
exclude three triple supports, and refute aggregate residue descent with an
explicit enlarged-pool frame. No full-width or Lean completion is claimed.

Answer contract: exact finite inverse-pool/induced-matching question -> identify
applicable established techniques and compare their full hypotheses -> primary
statements/proofs, explicit translation, ranked experiments with success/failure
criteria. Deliver a focused literature review and concrete next research plan;
do not substitute another unbounded solver campaign or promise completion time.

Priority routes: maximum induced matching / conflict graphs / strong edge
coloring; moment and local-consistency hierarchies; restricted rank-one identity
decompositions / product biorthogonal bases; local-ring reduction and lifting.
Read strongest primary matches and follow key citations. Reuse existing primary
texts and fetched campaign manifests before new retrieval. Bibliography-only
leads stay unreviewed; full-text question screens and access limits are explicit.

Coordinate through a create-only remote claim before substantive work. Preserve
results through existing PR17, keep required review intact, and release only this
session's expected claim SHA. Do not mutate issue8 or post external messages.

## Findings and recommendation

The strongest next computational experiment is a **conditioned moment lift on
the exact source pools**, following Gvozdenović–Laurent–Vallentin. It has a precise
mathematical extension beyond our current second moments. The most directly
matching induced-matching paper, Ahat–Ekim–Taşkın, mostly confirms a formulation
we already use; its Benders subproblem does not remove our unweighted feasibility
difficulty. Neither paper proves the C16 answer. A further long global run is
not justified by this review alone.

Four complete primary texts were screened: one reused SEA2025 text and three
newly acquired author/preprint PDFs. Relevant theorem statements and proofs
were inspected, including the hierarchy's block congruence and the finite-field
product-basis proof. Stacks Project Section10.20 supplies a separate classical
reference. Abstract-only and bibliography leads remain explicitly separate in
[the source/search ledger](literature-techniques-results/sources.json).

### Exact translations

Let A_ij = beta(X_i,Z_j), with entries interpreted as zero/one integers when
constructing a graph. Let G have the720 X and720 Z pool points as its two parts,
and edge ij precisely when A_ij=1. A k-pair frame is exactly an induced matching
of size k: after ordering its endpoints, the selected pairing matrix is I_k.
At k=128, pairing with the opposite endpoints proves both selected lists are
linearly independent in the128-dimensional binary logical space, hence bases.
This translation keeps every asymmetric frame. It does not assume a selected
frame is a cyclic orbit or an S-linear basis.

The equivalent stable-set graph H=L(G)^2 has an allowed pool pair as each vertex;
two vertices conflict if they share an endpoint or either cross-pairing is1.
This equivalence is standard and also stated in Ahat–Ekim–Taşkın, Section1.
The new literal diagnostic finds **99,808 edges** of G, density0.19253, and
X-degrees68..212. Thus H has99,808 vertices. A naive full square bit matrix alone
would need1,245,204,608 bytes, and a dense real moment matrix on H would be much
larger. The old43,936 figure is a B-identity carrier subproblem, not this graph.
[Diagnostic and replay](literature-techniques-results/diagnostic.json).

For endpoint selectors s_v, a matching is described by

    s_v in {0,1},
    s_v * (sum_{w in N(v)} s_w - 1) = 0,
    sum_X s_v = sum_Z s_v = 128.

This is exactly our current endpoint semantics. Independence and rank cuts add
valid information; merely renaming the model as induced matching adds no power.

### 1. Conditioned SDP blocks: highest priority, untested here

N. Gvozdenović, M. Laurent and F. Vallentin,
*Block-diagonal semidefinite programming hierarchies for0/1 programming*,
[primary preprint,19August2008](https://optimization-online.org/wp-content/uploads/2007/12/1859.pdf),
published in Operations Research Letters37(2009),27–31,
[publication record](https://ir.cwi.nl/pub/13249/).

Section2.3, Lemma2.2 and its proof replace a particular large moment matrix by
an exactly congruent block-diagonal system. Proposition2.5 compares the second
variant with Lovász–Schrijver. Section3 specializes to stable sets. These are
systematic lift-and-project constructions; convergence of a complete hierarchy
does not imply a cheap level will solve our instance. The paper also warns that
replacing all localizing constraints by edge equalities weakens its block
hierarchy. We must not claim its full strength after retaining only some blocks.

Here is a direct valid adaptation to our endpoint formulation. Put y_I=E[prod
_{i in I}s_i] and let q=(1,s_1,...,s_n). Our current PSD matrix is E[q q^T].
For an anchor a, introduce coherent third moments and impose

    M_a = E[s_a q q^T] >= 0,
    M_0 - M_a = E[(1-s_a) q q^T] >= 0,
    sum_{w in N(v)} y_{a,v,w} = y_{a,v}.

The last equality is the selected-degree equation multiplied by s_a. Repeated
indices collapse because s_i^2=s_i. Lift cardinality equations consistently as
well. These conditions hold for every real frame or distribution of frames:
for every real vector c, c^T M_a c=E[s_a(c^T q)^2]>=0, and similarly for1-s_a.
Thus no probability-positivity assumption over F2 is being made; positivity
belongs to the real distribution on binary selectors, as in our existing SDP.

This is new information relative to the basic second-moment model: its pair
correlations must now have compatible conditional correlations. It subsumes
the motivation behind our private-owner cuts but is not proved to dominate
every existing strengthened model unless all those constraints are retained.
With all anchors it has cubic rather than only quadratic moments. On1440
selectors there are496,627,680 distinct unordered triples before identities;
even cyclic folding leaves31,039,230 triple orbits. Full matrices are therefore
not the first implementation. A principal-submatrix pilot remains a valid
outer relaxation, with weaker strength and no claimed finite-level guarantee.

Use cyclic averaging of **moments**, not invariance of frames. Anchoring breaks
the old circulant block structure: a fixed-anchor matrix need not admit our old
Fourier decomposition. Translated blocks must share the same global y_I.

### 2. Induced-matching IP and Benders: attribution and a limited fallback

B. Ahat, T. Ekim and Z. C. Taşkın,
*Integer Programming Formulations and Benders Decomposition for the Maximum
Induced Matching Problem*, INFORMS Journal on Computing30(1),43–56(2018),
[DOI](https://pubsonline.informs.org/doi/10.1287/ijoc.2017.0764),
[full author manuscript](https://zctaskin.github.io/files/MIM.pdf).

Section2.1, equations(2b)–(2d), says a selected vertex must have exactly one
selected neighbor. Our `frame_cpsat.py` already enforces this with conditional
equalities, together with additional source rank constraints. This is existing
method overlap, not a new improvement. Our `orbit_benders.py` separately already
uses a count master and local shape infeasibility cuts; it is not the same
weighted decomposition as this paper.

The manuscript's Section3 master already contains induced-matching feasibility.
Its separable subproblem optimizes edge weights for fixed endpoints. For our
unweighted objective take vertex weights1/2 and edge weights0; that subproblem
then carries no objective information. Implementing it literally would not
attack the hard feasibility condition. Section4.2's neighborhood upper bounds
via weighted ordinary matching are worth checking cheaply, but improvement on
our bipartite graph is not established and may be zero. Do not port the full
Benders implementation on the strength of its abstract's dense-graph results.

### 3. Local-ring and product-basis theory: useful boundaries, no descent theorem

[Stacks Project, Lemma10.20.1](https://stacks.math.columbia.edu/tag/07RC)
parts(9)–(12) show that nilpotent-ideal reduction detects generation. Its proof
is exactly the repeated-ideal argument appropriate to epsilon^16=0. Our earlier
use to deduce an R-span from its residue span is sound. It says nothing about
preserving a finite dictionary under dualization. A binary basis of size128 is
not automatically an R-basis of size8 or an S-basis of size4. Imposing either
would discard unrestricted solutions. Nakayama is an ingredient we have already
used, not the missing residue-frame descent theorem.

Y. Yoshida, *Maximum Dimension of Subspaces with No Product Basis*,
[arXiv:2010.16293v1,30October2020](https://arxiv.org/pdf/2010.16293),
published in Linear Algebra and its Applications620(2021),228–241.
Theorem3.3 really does include finite fields: the bipartite case needs no
field-size restriction, and the multipartite case has an explicit size bound.
Proposition3.1's proof constructs a product basis of a hyperplane by reducing
a matrix to a rank normal form and applying invertible factor changes.
Those changes may leave our finite factors, scalar rays and allowed shifts.
Moreover it guarantees one product basis, not simultaneous membership of that
basis and its trace dual in two prescribed pools. S also has nilpotents and is
not a field. Consequently this theorem supplies neither a C16 obstruction nor
a C16 construction. Rejecting it solely because it came from complex quantum
information would have missed its actual finite-field theorem; the finite-pool
and dual-membership mismatches are the decisive reasons.

The enlarged21-by5 counterexample is an essential control for any new theory:
it preserves the residue sets, five thin orbits,61-dimensional thin modules,
projective thick directions and transpose exchange, yet has a full frame.
It adds twelve thick scalar R-rays. Any proposed obstruction must use exact
source scalar choices or another property that this example lacks. No searched
paper supplied that missing source-specific invariant.

### 4. Biclique / support-rank bounds: an explicit dead end for upper bound127

A. Ghosal and A. Karrenbauer, *Engineering Insights into Biclique Partitions and
Fractional Binary Ranks of Matrices*, SEA2025,
[primary full text](https://drops.dagstuhl.de/storage/00lipics/lipics-vol338-sea2025/html/LIPIcs.SEA.2025.18/LIPIcs.SEA.2025.18.html).
Sections2–4 concern ordinary-arithmetic binary factorization/biclique partition,
not rank over F2. Their isolation/fooling-set definition only forbids both
cross-entries being1; our induced matching requires both cross-entries0.
Those two invariants must not be equated despite the paper's terminology.

Our checked triangular128 support minor already supplies a128-element fooling
set. Every all-ones rectangle contains at most one of its diagonal entries, so
every fractional biclique cover costs at least128. Therefore a bound passing
through that cover number cannot give the needed strict upper bound below128.
The same witness blocks scalar support-rank<=127 over every field, as previously
proved. Their column-generation code solves a different optimization problem;
it is not a faster ready-made C16 search. This comparison strengthens the reason
to stop this route, rather than requesting more memory for it.

## A plan with decision gates and a completion criterion

The user requested a literature review. The following is a **proposed next
follow-up**, not an experiment run or a claim that another time block is booked.
There is no defensible calendar bound for resolving the original question.

| Stage | Concrete output | Continue only if |
| --- | --- | --- |
| A. Freeze coverage | Enumerate all13 admissible exact thin supports per sector, list169 ordered support pairs, and identify the91 pairs modulo the checked sector exchange. Keep the all-five/all-five case visible. | Every purported exclusion has an exact certificate and covers the declared source case. |
| B. Two-hour pilot cap | Implement coherent anchored third moments; start with two declared anchor orbits and principal blocks of at most97 rows. Freeze anchors/row sets before solving. Compare with the same base constraints and solver budget. | The encoder passes the controls below and separates a known feasible basic128-moment point, or proves a previously unresolved support case impossible. A timeout has neither meaning. |
| C. Strength test | First fix the old rational128-point and ask whether it extends; then release the pair moments and optimize on an unresolved original-pool support, including an early all-five test. Retain all old valid cuts in both arms. | There is an independently checked new inequality/global dual certificate, a newly certified whole support exclusion, or a physical frame above88. Rejecting one old fractional point alone is insufficient. |
| D. Proof or construction | Either verify a128-pair physical frame, or obtain a global bound strictly below128 / a complete collection of exclusion certificates covering all surviving cases. | This is the original completion criterion. A rational feasible relaxation, numerical infeasibility, or better partial frame is not completion. |

Stage B's two-hour cap is a proposed experiment budget, not a predicted solution
time. Include model construction, solve limits and cleanup within it, and reserve
preservation time separately. If the pilot does not pass its gate, archive that
failure and do not extend it by default. Reassess exact source scalar-ray
identities before spending more global compute. Exhaustive proof-producing SAT
remains a possible fallback only after demonstrating reduced complete coverage
and reporting a measured cost on a frozen cohort; old node rates cannot provide
a reliable finishing date.

The positive controls are the actual88-pair frame at cardinality88 and the
enlarged-pool128 frame in **its own** dictionary. Their orbit-averaged moments
must satisfy all applicable lifted constraints exactly. The negative controls
are the previously excluded two-family64-block and three triple supports. The
residue max7/8 problem is a separate small encoder control, not a valid quotient
substitute for the full source. Use exhaustive small-graph checks for the new
moment equations and independent rational/PSD consumers for any advertised
exclusion. Existing second-moment infeasibility certificates should continue to
verify because the new system retains the base system.

There are7 surviving triples,5 four-family supports and1 all-five support in
each sector. This is13, not three cases and not a percentage of the work done.
The169 ordered pairs reduce to91 under exchanging sectors, with no assertion
that all are individually feasible or equally difficult. The prior family
theorem removed zero of20,380 saved unresolved leaves. It is real partial
mathematics but not an observed speedup or evidence that the full search is near
completion.

## Deliverable and evidence accounting

| Requirement | Outcome | Evidence |
| --- | --- | --- |
| Applicable papers and hypotheses | Met | Four full-text comparisons above; primary links and hashes in sources.json. |
| Comparison with earlier work | Met | Endpoint/Benders overlap; existing owner/rank cuts; residue counterexample; support-rank barrier. |
| Concrete next plan | Met | Stages A–D, controls, bounded pilot and explicit stopping gates. |
| Demonstrated new speedup or C16 answer | None established | No new solver campaign; diagnostic only. Width16/18 and physical88 unchanged. |
| Question harvesting | Met for these four texts | New source screen and central inventory reconciliation; F153's older incomplete screen remains separate. |
| Service coverage | Bounded | Authenticated GitHub code/repository queries and signed-in X results in sources.json; not a universal absence or priority claim. |
| Lean completion | Not applicable to literature deliverable | No new Lean statement/proof or canonical C16 completion claimed. |
| Master integration | Pending required review | Preserved through existing PR17; branch checkpoint is not master publication. |
