The saved point12 prefix extension is a sound necessary relaxation. An
independent replay reconstructed all1,227,154 entries of its two sparse
matrices exactly from the physical pools. It also rechecked1399 selected rank
prefixes,2848 forbidden-profile witnesses, the4597-mask universe and291 rotation
classes, physical sector/phase symmetries,291 lifted physical bases, and198,400
literal rotation-feature equalities. The receipt is
`coupling-results/prefix-extension-witness12-independent-audit.json`.

The feature map is correct: y for physical Z_(j,b) contributes to n_j and to
d_(j,b-t) for every selected phase t. The mass variable carries the constant,
cardinality, and autocorrelation coordinates. The target has factor16. A mass
variable is the total probability of a rotation class, not the probability of
one physical mask. After rotating a sampled mask to its representative, rotate
its Z selection by the same amount. The invariant feature vector is unchanged.
A deterministic choice of canonical rotation works even for masks with a
stabilizer; requiring the conditional y variables themselves to be invariant
under the stabilizer is unnecessary.

Every owner bin has total mass lambda. Nonnegativity therefore implies each
owner y<=lambda. Each zero variable explicitly satisfies this bound and the
zero pool has total mass(128-|P|)lambda. A retained prefix A adds
sum_(j in A)y_j<=rank(A)lambda. Prefixes of full pool rank are implied by the
zero total and nonnegativity; independent prefixes are implied by individual
y<=lambda bounds. Skipping those rows and deduplicating identical subsets within
one pattern is valid. Including only the final position of a tied weight group
retains everything required for the two selected signed support chains. All
coefficients fit the int16 construction without accumulation overflow.

This is an outer approximation of full775 membership. The1399 selected prefix
rows prove only those rows, not every rank inequality of every zero matroid.
It can separate a point jointly through the shared profile masses even when
that point satisfies the two originating projected cuts. Conversely a feasible
point in this extension need not belong to the full775 hull, and even exact775
membership would not prove a source completion or consistency across all orbit
profiles.

Both the original presolve-off120-second run and the new presolve-on120-second
run timed out. The original version saved no primal or dual candidate. The new
version reported both `primal_value_valid=false` and `dual_value_valid=false`.
Its E/U matrices are entry-for-entry identical and its saved rank-row metadata
is byte-identical to the audited version; this comparison is preserved in
`prefix-extension-witness12-presolve-matrix-comparison.json`. There is presently
no vector to recover and no direction to reprice. A saved basis alone has no
feasibility interpretation.

If a later run yields row duals, extract the first775 equality multipliers,
try both signs, and round at explicit integer scales. Recompute the exact
global support with the complete291-domain full-basis oracle, then require the
unchanged independent consumer to prove the signed prefix bounds, physical
symmetry, and strict rational target gap. A phase-I dual or an infeasible solver
status is only a way to propose a direction. Full repricing removes the need
to trust floating stationarity or the limited rank-prefix outer approximation.

There is also a direct exact finite-LP certificate route because all its
variables are explicitly in[0,1]. Write E x=b and U x<=0. For rational equality
multipliers a and nonnegative inequality multipliers z, compute

    r = E^T a + U^T z,
    L = sum_j min(0,r_j).

Every feasible point satisfies L<=r.x<=a.b. Thus the strict rational inequality
a.b<L proves this finite extension infeasible. This certificate tolerates
nonzero stationarity residuals; the box contribution L accounts for them
exactly. Coefficients are integers and b is the saved exact rational target,
so no Fourier interval computation is needed for this particular extension.
The first775 entries of a determine a projected feature direction; full oracle
repricing will generally give a sharper and more reusable physical cut.

If a numerical primal becomes available, recover an exact rational solution
and check every equality, inequality, and box bound before reporting finite
extension feasibility. Eliminate exact zero variables and active y=lambda
relations first, then exploit the fact that every non-feature row is local to
one mask. Avoid a dense133070-variable rational solve. After such recovery,
full matroid membership remains a separate task: either decompose each positive
mask block into exact full-basis mixtures or certify all its rank inequalities.
The selected prefixes alone are insufficient. No further LP was run by this
audit, and no root-owned producer or result was modified.
