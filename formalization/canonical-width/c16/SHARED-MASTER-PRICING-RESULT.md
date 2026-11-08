# Shared-master pricing and projection: accepted negative result

The exact source-combination/pricing/minorant chain is accepted, but its final
inequality does **not** separate point22. The exact rational gap is stored in
`shared-master-results/phase-one-v1-residual-projection-independent.json`;
its approximate value is `-12146.42155154628`. The normalized valid owner row
has5,273 nonzero coefficients and maximum integer coefficient size109 bits.
It does not fit the old signed-int64 row path, and no model integration was
attempted.

Two bounded SoPlex attempts on the same unpinned restricted master did not
provide usable primal/dual vectors. The first saved basis file also lacks the
normal ENDATA terminator; it was not treated as a complete basis. A separately
authorized bounded HiGHS extraction supplied a complete finite named row-dual
vector. Its availability flag was not treated as dual feasibility or an
optimality certificate.

The executed versioned diagnostic selected exact rational source multipliers
from those decimal strings, clipped positive parent-inequality dual entries
explicitly, and recomputed the full symbolic source combination. It preserved
18,729 nonzero non-tau residuals rather than pretending they cancelled. The
independently accepted probability-bound certificate supplies `0<=v<=lambda[m]`
for every one of22,508 non-tau parent variables, including all32 new conditional
same-sector pair masses. Residuals in the five higher joint moments are handled by
their exact superset identities.

All32 sector-pattern full-basis prices were computed and independently checked
with the established physical domain and signed-prefix-rank consumer. Thirty
prices were negative; these are prices in an arbitrary exact source
combination, so negativity is not by itself a missing-column certificate for
an accepted restricted dual. The original exact coupled-eight-event law
provided a feasible16-atom low-moment law for the tiny projection LP; no capped
numerical primal was used.

The tiny exact16-variable/11-moment LP produced a rational primal and dual with
equal objectives. Its dual minorant was checked on all16 patterns and mapped
to the physical owner moments with factor one. Independent replay then
verified the final owner coefficients, positive integer normalization and
negative exact target gap. This proves a valid pin-free necessary row and its
evaluation at point22. It proves neither source feasibility nor infeasibility,
and it does not decide membership in the unrestricted shared-basis relaxation.

Key frozen evidence:

- `shared-master-results/pattern-local-probability-bounds-v1-independent.json`:
  45,016 actual-parent row-witness identities, five tau identities,60 elementary
  signed-bound cases and seven rejected mutations.
- `shared-master-results/phase-one-v1-residual-pricing-v2.json.gz` and its
  `-independent.json` receipt: exact rational source combination, all residuals
  and all32 physical prices. Producer time8.33 seconds; independent pricing
  replay time9.01 seconds for this saved instance.
- `shared-master-results/phase-one-v1-residual-minorant.*`: the tiny LP text,
  exact primal/dual, frozen bounded command and numerical run record.
- `shared-master-results/phase-one-v1-residual-projection.json` and its
  `-independent.json` receipt: the necessary row and exact negative gap.

The original exact-optimum path (`shared_master_price_domains.py`,
`shared_master_price_minorant.py`, `shared_master_price_projection.py`) was
prepared but not executed: its prerequisite accepted restricted optimum never
arrived. The SoPlex-text residual producer was likewise not executed on the
unavailable-vector stubs; only its small parser controls ran. The distinct
`shared_master_price_residual_v2.py` handles the named HiGHS JSON format without
misrepresenting it as a SoPlex or exact solver dual.

No further main solve, column loop, physical query, target refinement, full
source frame or source-case exclusion follows from this gate. The original
C16 width16/18 question, cover405, best physical partial88/128 and zero excluded
complete-source anchors are unchanged.
