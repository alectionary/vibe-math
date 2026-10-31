# Lightweight review during the low-load hold

This is a code/theorem review, not an independent replay of the general model,
its sparse packet, or the 15,121 augmented physical domains. No new solver,
model import, full model replay or large-array construction was run for this
review. All subprocesses previously launched by the reviewing agent had exited.

## General shared law

Reviewed sources: `two_basis_joint_general_model.py`,
`two_basis_joint_general_prepare.py`, and `two_basis_structure_general_law.md`.
The model module inspected has SHA256
`9d9ae284cf1f678aa0729e49fc2aa44bce44b3498391527defa3818ed262063e`.

The construction is mathematically consistent. The sixteen pattern masses
are affine Möbius expressions in the eleven low anchor moments and the five
shared triple/quadruple moments. It retains all sixteen nonnegativity rows.
For each sector coordinate it eliminates only the source-forced/deleted
entries. It then row-reduces the five conditional-moment equations on the
structurally free pattern entries. The same exact row operations act on the
feature/tau right sides. Free entries become explicit variables and every
residual consistency row is retained.

The fixed-law local-face routine is not called. Neither tau=0 nor the previous
law's tight local-box facets appear among the general-model constraints.
Reference tau=0 is used only to reconstruct an already accepted allocation.
Own-anchor residual equations are low-moment identities: summing their
forced pattern masses produces a singleton or pair moment, so these identities
do not silently fix any high moment. Other coordinate blocks have the full
five-row moment map in the supplied source preparation.

Bucket equations, both box bounds and accepted physical contracted-rank rows
are retained for all sixteen patterns. `bank_rows` does not apply a positive
reference-mass filter; in particular, the geometry rows previously omitted at
zero reference mass return in this model. There is no division by a variable
pattern mass and no product of a margin variable with a mass variable.

The equality and inequality descriptors support exact feature-row extraction:
equality multipliers may have either sign, inequality multipliers must be
nonnegative, and every allocation/tau coefficient must cancel exactly. This
gives a valid necessary feature inequality; numerical infeasibility alone does
not do so. Arbitrary owner-star T coefficients need the planned extension from
the 7211-feature subset to constant plus the canonical owner moment vector.

The reported 13,393 variables, exact reference and sparse packet remain producer
evidence pending the held independent replay. The proposed independent gate is
to rebuild the Möbius map, check local affine dimensions and residual row spans,
rebuild every semantic descriptor and physical rank, compare all sparse packet
entries, and replay the accepted reference directly against all target rows.

## One-probe owner lift

Reviewed sources: `CONDITIONAL-OWNER-LIFT.md`,
`probe_augmented_owner_domains.py`, and the frozen independent sector-domain
routine in `verify_two_sided_full_basis_oracle.py`.

Condition an actual frame on anchor pattern m and probe selection. The selected
opposite-sector basis belongs to the augmented domain, so its weighted marginal
w belongs to a_m B_m^i. The residual branch belongs to the original domain,
giving z_m-w in (lambda_m-a_m) B_m. The residual domain intentionally imposes no
condition from probe absence. Cross moments require sum_m w_mj=T(i,j) for all
opposite coordinates. If the augmented domain is empty, its event has zero
probability, hence a_m=0 and w_m=0. This implication is source-valid and does
not require an integrality claim about the larger lifted system.

For either domain, selected opposite anchors are independent and define the
evaluation map. Allowed vectors have zero or unit signatures. Distinct unit
bins each supply exactly one owner; their images are independent. The zero
vectors supply a basis of the kernel, after joint contraction of all forced
zero anchors and deletion of absent own anchors. A forced unit anchor fixes
its owner bin. Dependent forced zero anchors, a forced multibit signature,
duplicate forced owners, an empty required bin, or deficient zero rank reject
the domain. Conversely, a full contracted zero basis and one element per
required owner bin lift to a full physical basis with the required anchors.
This establishes the stated auxiliary matroid/simplex decomposition.

The lift contains the owner-star constraints but does not establish a joint
full-frame law across probes or sectors. No integrality or polynomial-time
algorithm for that coupled lift is asserted by this review.

The negative domain screen records 512 exhaustive dimension-three domain
controls, 208 feasible domains, and no positive-coordinate domain rejection.
The metadata field `physical_full_bases_per_domain: 35` should be read as 35
candidate three-subsets of seven vectors; only 28 are bases before anchor
conditioning. This wording does not affect the literal rank-filtered controls.
The screen binds input bytes but does not itself verify allocation receipts or
that the supplied configs correspond to the allocations. Its current inputs
were independently accepted separately. Any future acceptance wrapper should
check those bindings explicitly and retain the narrow negative-screen scope.

No source width, cover-case or full-frame claim changes.
