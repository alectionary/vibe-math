# Direct full-basis cuts in the source SAT models: bounded gate

The accepted 775/1512 inequalities are valid before cyclic averaging, but the current compact SAT owner flags denote endpoints of a **partial** matching. Substituting those flags for complete source selections is unsound. The signed coefficients make deletion of zero-signature frame edges non-monotone. No source SAT run was launched by this gate.

## Exact unaveraged Boolean form

Use full-selection bits `P[t]=X[512+t]` and `Q[j,b]=Z[16j+b]`. The accepted 775 form is

`c0 + c1 sum(P) + sum(h=1..8) c[h+1] sum(t) P[t]P[t+h] + sum(j,b) c[10+j] Q[j,b] + sum(j,h,t) c[55+16j+h] P[t]Q[j,t+h] <= B`.

All phase arithmetic is modulo16. In particular, the `h=8` self-product appears twice when monomials are consolidated. No factor16 belongs in this unaveraged formula; that factor belongs to its moment expectation. The 1512 extension adds `Q[a]`, `Q[a]P[t]`, and `Q[a]Q[j]` with the recorded coefficients. `Q[a]^2=Q[a]`; its16mixed products already occur among the old cross products.

`full_basis_boolean_gate.py` independently expands these polynomials and compares them with literal feature evaluation on104 arbitrary Boolean controls. The two forms agree exactly. The source upper bounds are unchanged and are bound to their independently accepted bank receipts.

For each distinct product introduce `y=uv`, with clauses `(-y,u)`, `(-y,v)`, `(y,-u,-v)`. The eight-entry truth table is checked. Convert a negative coefficient `-a*y` into `a*(1-y)-a`; add `a` to the right-hand side.256 signed-PB controls check this exact identity. Consolidate duplicate monomials and divide coefficients by their gcd, flooring the integer right-hand side if needed. No coefficient is clipped or rounded in this bridge.

An exact binary-adder CNF is a possible final encoding. XOR2 requires four clauses; AND2 and OR2 require three. A full adder uses two XORs, two ANDs, and one OR. For a constant upper bound, each zero bit gives a comparator clause forbidding that sum bit when all higher bits equal the bound. The saved counts are deterministic conservative costs of a balanced-adder construction with false-constant simplification; they are not claims of an optimal encoder, an emitted CNF, or an accepted DRAT bridge. Production encoding still needs independent clause reconstruction and corruption controls before any source exclusion can be accepted.

## Why existing compact models need extra variables

`signature_cover.encode` keeps nonzero-signature edges. `global_four_signature.setup` and `word_kept_anchor_domain_signature.setup` define owners exactly as disjunctions of those retained edges and allow at most16 signature events. They do not select128vectors per sector. Their arbitrary partial SAT solutions cannot be evaluated as full bases.

For one oriented orbit32 row,736new full-selection flags suffice:16Pflags and720Qflags. Both sector orientations together require the full1440flags. Old owner flags imply their corresponding full flags; the reverse implication is invalid because a full selection may be paired through a deleted zero-signature edge.

Useful source-necessary additions are `sum Q=128`, accepted P-profile nogoods, and `P[t] -> sum_{j:A[512+t,j]=1} Q[j]=1`. Existing selected owners must remain compatible with full opposite flags: for a compact owner `u_i` and full opposite `Q_j` with pairing1, use `(-u_i,-Q_j,e_ij)` if that retained edge exists, otherwise `(-u_i,-Q_j)`. This factors compatibility through owner flags rather than repeating all exclusions for every edge. Apply the analogous condition between a fullPphase and selected opposite owner. These implications preserve every source frame and connect the new flags to the existing partial matching.

## Bounded completion test and independent attribution

For a saved physical matching `M={(x_i,z_i)}`, let `I,J` be its endpoint sets. Every containing source frame uses only

`E_X = I union {x: x is orthogonal to every z in J}`,

`E_Z = J union {z: z is orthogonal to every x in I}`.

Enumerate every accepted orbit32 Pmask extending `I` and contained in `E_X`. For1512rows enumerate both anchor states, fixing or deleting that Qanchor. Once P and the anchor state are fixed, the objective is linear in Q. Retain all mandatory Jvertices and fill the remaining slots to128 using the smallest signed weights in the eligible pool. This is an exact minimum over a relaxation of physical completion: omitted rank/ownership constraints only enlarge the domain. If every such minimum exceeds the accepted upper bound, the matching cannot extend. No feasible completion is asserted when the test does not exclude it.

The bounded cohort was the first and last32 records of each saved global-trial and global-four-trial, plus physical88:129configurations. Three accepted rows were tested: first775cut and both1512cuts, giving387tests. Independent literal consumer `verify_full_basis_boolean_gate.py` rebuilt physical compatibility and reproduced every minimum by explicit sorted signed weights, without NumPy or producer feature/weight code.

195row/configuration tests were already impossible by eligible count or Pprofile. Four positive bound tests concern only two13-pair configurations, global-four records3527 and3528. Both were already rejected by saved domain-forced-propagation cuts. Their eligibleXrank is67; eligibleZranks are102 and101. Ordinary rank therefore explains all observed bound pruning. This cohort demonstrates no incremental gain from the new rows. Physical88 has only93eligible opposite vectors, so that particular fixed matching cannot extend; this says nothing about whether a different larger partial frame exists.

Across all6908saved partial configurations, direct endpoint-only evaluation produces8882positive row/configuration values among the13rows screened. These are diagnostic only and are not source-valid pruning evidence.

## Encoding cost and the accepted scale64 simplification

The original13rows together use12359distinct products and37077shared AND-definition clauses. A straightforward exact weighted adder costs about2.30–2.48million clauses per row. Eagerly adding all of them is not justified by this gate.

The subsequently independently accepted gauge-rounded bank is `native775-witness9-gauge-rounded.json.gz`, SHA `e2e3973bf0d0d40cd9e44674c3f19cc2881f8e2b998636e1d70f7741115fe5ec`; receipt SHA `db40ff09f26ab4e9303c6682dd8da4e09e73a9da4147fbe3a3515cb015ff3ca3`. Its scale64rows are indices0 and7, each with bound0,301nonzero features, and maximum consolidated Boolean coefficient64. These rounded coefficients were independently repriced and accepted; validity is not inferred from rounding the old cut.

Each scale64row has4792products plus16linear terms. Product definitions cost14376clauses; the weighted adders cost133458 and133577clauses, respectively, plus15/14comparator clauses. The existing kmtotalizer encoding of `sum Q=128` costs45741clauses and7748auxiliary variables. This is about17times smaller per PB row than the original first775adder. The cost artifact includes all14accepted rounded variants and explicitly identifies indices0 and7 as the simple pair.

A natural next experiment is the current retained405case `(32,32,0)`, which forces a relevant Pphase and an opposite anchor. After independent Boolean/CNF translation controls, run two20-second matched trials on the same frozen compact-plus-full-flag model, one without the scale64row and one with row0. Preserve both UNKNOWN outcomes, timing, models, and input hashes. Any UNSAT result still requires independent physical CNF regeneration and DRAT verification, plus the existing cover binding. This proposal has not been executed.

The local PySAT PB wrapper currently fails to import because its optional `pindakaas` dependency is absent. No dependency was installed. The gate-count construction avoids that dependency; selecting or implementing a production PB encoder remains an implementation task.
