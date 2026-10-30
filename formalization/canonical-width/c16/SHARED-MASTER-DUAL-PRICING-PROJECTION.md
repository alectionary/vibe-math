# Exact dual bridge for the shared basis master

The new restricted master keeps the full22,513 symbolic owner/capacity/eight-event
variables. It omits the five higher-moment pins and retains all32 sector-pattern
blocks. The first frozen archive has1,642 physical bases,70,235 total variables
and169,657 rows. Its artificial objective is the sum of positive and negative
link errors. A positive restricted optimum alone is not a source obstruction.

The normalized exact min-LP dual uses signed multipliers `pi` on equality rows
and nonpositive multipliers on `<=` rows. Every variable is explicitly free in
the LP; the intended nonnegativity conditions are named rows. Acceptance checks
the complete stationarity identity `A^T*pi=objective`, all dual row signs, the
exact primal rows and equality of rational primal/dual objectives.

The source-row convention is `expression<=0`, so its multipliers are `-pi`.
On a source frame the link errors have value zero. Exclude the basis-weight and
error nonnegativity rows, retain all source-valid parent rows, and substitute
zero for those artificial errors. For a block whose rows are

    sum_B w_B - lambda_m = 0,
    sum_B w_B*1[j in B] + eplus_j - eminus_j - y_j = 0,

the resulting source expression is

    G(F) + sum_(s,m,B) a_sm(B)*w_smB <= 0,
    a_sm(B) = -pi_mass_sm - sum_(j in B) pi_link_smj.

The finite-variable part is the parent combination with weights `-pi`, plus
`pi_mass*lambda` and `pi_link*y`. It must cancel **all22,513 coordinates**,
including the shared edge variables and32 same-sector pair masses. This
unpinned model permits no unexplained higher-moment residual. The owner part
must satisfy `G(F_current)=D`, the accepted restricted objective. For each
archived basis, stationarity additionally gives
`a_sm(B)=-pi_nonnegative_weight_B>=0`. Error stationarity gives
`pi_link-pi_nonnegative_eplus=1` and
`-pi_link-pi_nonnegative_eminus=1`, hence `abs(pi_link)<=1`.

An exact signed full-basis minimum

    mu_sm = min_B a_sm(B)

includes the mass constant. It is obtained by maximizing the negated element
weights with the existing physical oracle. The independent consumer rebuilds
the conditional domains and checks physical bases, forced/deleted anchors,
unit-owner bins, joint forced-zero contraction and every signed rank prefix.
It checks both sectors for all16 patterns, including zero-mass patterns.
Negative minima are allowed. They prevent extension of the same restricted
dual by nonnegative column-bound rows, but can still contribute to a valid
projected inequality.

Because `w>=0` and each block sums to `lambda_m`,

    G(F) + sum_m K_m*lambda_m <= 0,
    K_m = mu_Xm + mu_Zm.

If a future pinned certificate is used, first lift it symbolically to the full
source rows and remove its pin rows. A removed source multiplier `h*tau` leaves
residual `r=-h`. The higher coordinates are **joint moments**:
`tau_h=sum_(m containing h)lambda_m`, for `h=7,11,13,14,15`. Add
`sum_(h contained in m)r_h` to each `K_m`; pattern15 receives all five residuals.
The present unpinned master has zero such residual and needs no pin correction.

For the eleven features indexed by
`LOW=[0,1,2,4,8,3,5,9,6,10,12]`, solve only the tiny projection LP

    minimize K.lambda
    subject to sum_(m containing h)lambda_m = q_h, lambda>=0.

It has16 variables,11 equality rows and16 explicit nonnegative rows. A rational
dual `d_h` gives the quadratic minorant
`b(m)=sum_(h contained in m)d_h<=K_m`. Checking these16 inequalities is enough
for validity. The saved exact primal and equal objective certify the best
minorant value for this fixed low-moment target. This is an ordinary finite-LP
duality calculation, not a new mathematical method.

The resulting necessary owner row is

    G(F) + sum_h d_h*q_h(F) <= 0.

The accepted physical symmetry mapping gives factor-one low moments; there is
no additional factor16 or32. Rational coefficients are converted to integers
using a positive common-denominator/GCD scale, and both the rational gap and
scaled integer violation are retained. Only a strictly positive independently
checked gap excludes the current target. A nonpositive value is preserved as
an inconclusive projection result. Neither result by itself resolves the
original C16 width question or constructs a full source frame.

`shared_master_price_algebra.py` contains the source-combination arithmetic.
Its frozen tiny consumer checks exact min-LP dual signs, archive and error
stationarity, finite cancellation, a negative full price despite a positive
restricted objective, the joint-moment map and the minorant normalization.
There are six rejected mutations. Those controls use no optimizer or physical
oracle and are not a substitute for actual dual replay.

The production files are `shared_master_price_domains.py` (all32 prices),
`shared_master_price_minorant.py` (bounded exact16-atom LP), and
`shared_master_price_projection.py` (candidate owner-row adapter). Independent
acceptance is split between `verify_shared_master_projection.py` and
`verify_shared_master_minorant.py`, preserving each consumer's frozen bytes.
The accepted restricted endpoint remains a prerequisite. No producer result,
solver log status or artificial seed is substituted for these proofs.
