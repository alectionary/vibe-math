# Clarabel assessment for the X512/Z512 case — no solver launched

Do not launch Clarabel on the full saved packet in this block. An interior-point
method is materially different from SCS, but this is not a solver-name change
with an already completed exact acceptance path. The PSD packing conversion and
rigorous semantic PSD-dual consumer remain unimplemented, while memory risk is
substantial. No constructor, factorization, optimization, installation or new
source retrieval was performed for this assessment.

The actual `coupling-results/sourcecase323200-conic22` packet has 76,008 variables,
325,107 conic rows and 4,064,161 nonzeros in A. Its cones comprise 636 equality
rows, 263,046 scalar nonnegative rows and 18 PSD blocks: sizes45,44, fourteen
size90 blocks, then45,45. The PSD packed dimension is61,425. The linear-only
packet has2,251,129 nonzeros; it is not the whole conic problem. The source-case
floor is1/16 and artificial margins are zero. The prior scaled SCS call spent
34.82 seconds in setup and134.11 seconds solving, with an invalid endpoint.

The locally installed Clarabel is0.11.1. Its CVXPY adapter uses upper-triangular
sqrt2 PSD packing; the saved SCS packet uses lower-triangular sqrt2 packing.
Each block therefore needs a checked permutation of A and b, with inverse
permutation of duals. Cone signs and scalar rows otherwise follow Ax+s=b.
The installed adapter's warm-start branch updates an existing solver; it does
not accept the saved SCS x/y/s as a fresh warm start. Settings expose a direct
KKT solver, chordal decomposition, time limits and max_threads; a future trial
would explicitly set max_threads=1 and enforce an external constructor/solve
wall and RSS cap at verified nice19.

The compressed A archive expands to roughly65.6MB of index/value/pointer arrays.
That number alone is misleading for an interior-point SDP. The packed PSD
dimensions are1035,990,fourteen4095,1035,1035. A dense upper scaling operator on
these packed blocks has119,510,775 entries, or956,086,200 bytes of doubles;
full storage would be1,911,681,000 bytes. KKT indices, numeric factors, fill and
workspace are additional. These are structural size estimates, **not measured
Clarabel allocations or a proved memory lower bound**. The installed wheel
does not expose its Rust implementation as local source. The dense Fourier
blocks provide no evident small-clique reduction; actual fill was not tested.
A safe2GB full-model trial is consequently not established by this review.

For a future exact dual, use semantic rational linear rows and the exact
Fourier matrices, not rounded canonical doubles. Round scalar inequality
multipliers to nonnegative rationals and certify each PSD multiplier as a
rational Gram matrix LL^T (or another exact PSD certificate). For necessary
rows Ux<=b, Ex=f and PSD blocks B_k(x)>=0, form

    α·(Ux−b) + ν·(Ex−f) − Σ trace(Z_k B_k(x)) = c+r·x <= 0.

The bounded probability variables satisfy0<=x<=1, including profile weights.
Thus c+Σ min(0,r_j)>0 proves infeasibility without exact stationarity. With
rigorous interval coefficient reconstruction, use the lower bound
c_lower+Σ min(0,r_j_lower). Exact algebraic/interval Fourier and sqrt2 handling,
all scalar variable bounds, and rational PSD multipliers must be independently
replayed. A floating `PrimalInfeasible` status is not this certificate.

The assessment uses the saved packet metadata, prior SCS log, installed
Clarabel settings and local CVXPY `clarabel_conif.py`/`scs_conif.py` only.
It makes no source-case exclusion, timing prediction, or claim that Clarabel
could never solve the model after a separate implementation/validation gate.
