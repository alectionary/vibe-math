The accepted point12 first marginals belong exactly to the full physical Z
matroid base polytope. This closes the unconditional first-moment rank gate for
that point. It does not settle the775-feature projection or any source cover
case.

The search used the6,980 physical Z bases archived by the earlier native775
witness10 run. It discarded all selected-X masks and second-moment information,
deduplicated their45 orbit-count columns, and solved only

    sum_l w_l = 1,
    sum_l w_l n_j(B_l) = 16 p_j,  j=0,...,44,
    w_l >= 0.

Exact FLINT correction recovered45 positive rational weights. Every retained
physical basis has128 distinct candidates and exactGF(2) rank128. The independent
consumer reconstructs the pools, counts and target directly, rechecks physical
phase and sector isomorphisms, checks every rotated basis, and verifies all45
count equations and720 physical marginal equations in rational arithmetic.
The cyclic mixture contains720 positive atoms counted with multiplicity, one
for each retained basis and each of its16 rotations, with weight w_l/16.

For every physical subset A, each such basis obeys

    |B intersection A| <= rank_Z(A).

Averaging gives sum_(j in A)p_(orbit(j))<=rank_Z(A), simultaneously for every
subset A, without enumerating rank inequalities. Total selection mass is128,
so this is full unconditional basis-polytope membership, rather than merely
passing a finite bank of rank rows. The checked sector isomorphism maps Z_j to
X_j and transfers the same first-marginal result to the X pool. These are
separate one-sector mixture statements; no joint X/Z dual frame is constructed.

The point is `coupling-results/anchor-witness12-rational.json.gz`, SHA256
`7230467da979f8c16cc1074cde3776c7d202af3025331ab436b16270fde4ebb4`.
The exact mixture is `coupling-results/unconditional-basis-mixture-witness12.json.gz`,
SHA256 `9579fd34cd08e22c602fcd36340dbae9a41e9363c8398bd810ab09aa676b05c1`.
Its independent receipt is
`coupling-results/unconditional-basis-mixture-witness12-independent.json`.

`recover_unconditional_basis_mixture.py` preserves the frozen target/archive and
source bindings. `verify_unconditional_basis_mixture.py` imports no recovery
routine and proves765 physical ranks:45 original bases and720 rotated bases.
Corrupted negative weights, total mass, basis elements, orbit counts, source
bindings and target bindings are rejected by the separate control receipt.
No prior exact point12 unconditional-mixture certificate was found in the
searched notes or mixture inventories before this run.

Consequently, adding more unconditional first-moment matroid rank inequalities
cannot exclude point12. Further separation must use information beyond those
inequalities, such as common profile distributions, conditional rank,
cross-sector coupling, second moments, or direct source constraints. The
original source interval and405-case cover are unchanged.
