# Finite frame models and certified rank cuts

These programs address the 720-by-720 binary pairing matrix after the physical reduction in `INDEPENDENT-ENUMERATION.md`. They do not assume regularity of a putative frame. Pool coordinates are distinct nonzero vectors in F₂¹²⁸, and both pools span that space.

## Exact global formulations

A selection of 128 X and 128 Z pool vectors is a canonical frame precisely when its pairing submatrix is a permutation matrix. `frame_sat.py` encodes selected-vertex degree exactly one. Shared threshold gates count whether a neighborhood contains at least one or at least two selected vertices. The gate construction was exhaustively checked on 4032 threshold truth cases, including neighborhoods of size one.

`frame_private.py` selects 128 X vectors S. A Z vector is private when it pairs with exactly one member of S. For every pool X vector, the formula requires an anticommuting private Z vector. In particular every selected X has a private Z; choosing one for each gives an identity Gram matrix, so the selection is independent and the chosen partners are distinct. Conversely a full canonical frame satisfies every such clause: its Z basis detects every nonzero pool X vector. The additional positive-degree clauses for all pool Z vectors are valid because S spans. When pool Z coordinates are distinct, exactly 128 Z vectors are private: their labels on the basis S are the 128 unit vectors. Optional exact-private-count constraints are therefore necessary, not a regularity restriction.

`frame_rank.py` selects X vectors using 720 primary variables. The oracle requires the selected set to be independent and the not-false pool to span dimension 128. At a complete assignment these conditions force exactly 128 selected vectors. It further requires the Z vectors pairing at most once with the selection to span dimension 128. Their nonzero labels on an X basis are unit vectors; spanning then supplies all 128 private partners. Thus the complete-assignment test is equivalent to a full pool frame.

## Algebraic clauses

Every clause written by `rank_oracle.py` has one of these checkable certificates.

- `x_circuit`: the listed X vectors XOR to zero. They cannot all belong to a basis.
- `x_available`: a nonzero functional μ. Every spanning X set contains a vector on which μ is one, giving a positive clause over all such pool vectors.
- `z_eligible`: a selected subset T and a nonzero μ annihilating every Z vector that pairs at most once with T. The Z basis of any completing frame would lie in this pool, so it cannot span.
- `z_zero`: an independent selected subset T and μ outside span(T), annihilating every Z vector orthogonal to T. If T had size m in a full frame, its other 128−m dual Z basis members would span ann(T). The supplied witness proves that the available zero pool has smaller span. Greedy shortening retains this same directly checked witness.
- `z_private`: a nonzero μ. A full private Z basis must contain a private vector on which μ is one. Counter literals express this condition directly.

A cyclic translate of a valid clause remains valid. The verifier can either check every expanded certificate separately or check the base certificate plus the complete translation action on both pools. Translation is an orthogonal coordinate permutation, so it preserves all XOR, pairing and span conditions. Neither mode assumes a translation-invariant frame.

`small_obstructions.cpp` exhausts all 3,871,815 unordered three-X translation classes. It records 771 rank-obstruction orbits including one two-X obstruction, and five three-X dependence orbits. Another 718 triple classes contain the already excluded pair and need no new rank test. The 12,416 recorded translated clauses were checked individually and also by the equivariant verifier. This is a complete enumeration of these small necessary obstructions, not a global frame exclusion.

## Propagation and native acceleration

An X vector in the span of the current selected set closes an explicit XOR circuit and is forced false. A coloop of the not-false X pool belongs to every basis, giving a unit instance of an `x_available` clause. Coloop detection carries Gaussian-elimination provenance tags and was compared against brute-force deletion ranks on 300 random matrices.

The Z pool orthogonal to T must span ann(T). Every coloop of that pool must occur among the corresponding dual basis members. A proposed additional X vector pairing with two such indispensable Z vectors is impossible. `rank_units.cpp` optionally checks all single-vector extensions with exact binary rank. It is only an accelerator: for every reported exclusion, the Python caller reconstructs an independent algebraic witness, and `verify_log` checks it again. Native and Python extension lists agree on four complete source-pool controls (720 proposed extensions each). A positive identity-frame control and a negative dependent-X control also pass; 708 basis-propagation clauses and 582 opposite-coloop unit clauses have direct certificates.

## Restricted monomial searches

`seed4_coloop.cpp` retains every partner whose seed-4 block restricts to the required unit vector on the kept monomials; omitted positions are unrestricted. After r fixed pairs, the surviving X pool must span dimension 128−r. The final quotient search propagates mandatory basis members and partitions exhaustive branches. `seed4_prefix_coloop.cpp` additionally uses mandatory survivors at selected prefix depths to reject incompatible future partners. Every skipped partner accounts for its entire remaining Cartesian-product suffix, so the domain-coverage total is retained.

The quotient implementations agree with independent exhaustive X-basis enumeration on 111 positive and 1299 negative small full-rank examples. Node caps, interruptions and process time limits remain unresolved cases. A complete negative monomial search excludes only frames containing the prescribed monomials; it never excludes frames with fewer such monomials.

## Proof status

A SAT answer must be converted to 128 physical pairs and checked with `verify_partial_frame.py`. A global UNSAT answer needs the exact model, verification of every additional algebraic clause, and an independently checked propositional proof. DRAT-trim has verified the small oracle-UNSAT control. No global UNSAT certificate or Lean certificate has been obtained. Time limits and heuristic construction failures do not decide the width.

## Iterated mandatory-pool propagation

`forced_propagation.h` keeps the entire potential X and Z bases active. A full basis must span dimension 128 on each side. Every active-pool coloop is mandatory. For a mandatory independent set M on either side, the opposite vectors orthogonal to M must span its full annihilator; their coloops are mandatory too. A candidate pairing with two mandatory opposite vectors cannot be selected. Two mandatory vectors that anticommute must pair with each other, excluding their other potential partners. Repeating these necessary deductions reaches a fixed point or a contradiction. Active pools only shrink and mandatory sets only grow, so the procedure terminates.

The C++ procedure retains all 318 feasible small controls in a collection of 2417 exhaustive small instances, rejecting 1792 and leaving 625 possible (including those 318). It does not purport to decide all remaining instances. `forced_propagation.py` supplies a separate exact Python replay using different Gaussian pivot order. Clauses of kind `forced_propagation` are accepted only when that replay derives a contradiction from the prescribed X set. Their evidence is a checked finite propagation trace/algorithm with the written necessity argument above, rather than a single annihilator witness or a Lean certificate.

A fixed-seed comparison on 10,000 source-pool sets at each size 3 through 8 found 961 additional exclusions beyond the independence, zero-pool rank and eligible-pool rank tests. Every retained core and all translated clauses are replayable. This sampling rate is descriptive; it is not an exhaustive exclusion at those sizes. The exhaustive two-X run gained no new forbidden pair beyond the one known translation class; its 704-color graph bound is still too weak.

Two attractive shortcuts fail on small exact examples. Free cyclic symmetry does not generally turn an arbitrary dual frame into a regular frame (`four-hours-results/experiments/equivariance-counterexample.json`). Even for a symmetric pairing matrix and one common candidate pool, a dual basis need not yield a principal permutation submatrix. With the ordinary dot product on F₂⁴, S=[12,3,14,8] has dual T=[7,1,3,12]; their common pool [1,3,7,8,12,14] contains no principal four-vector permutation submatrix (all 15 subsets checked). Thus the separate principal-frame construction model is a restricted search, not an equivalent reduction.

## Watching both sectors and retaining search work

`dual_rank_oracle.py` maps the private-Z counter literals to a second, transposed rank oracle. The X and Z observers share CDCL's decision levels, but write separate algebraic logs. Positive and negative selector signs are translated explicitly; controls retain identity bases and reject a dependent Z selection, with both logs checked independently. In the source pools the pairing matrix is symmetric, so the same-index monomial exclusion can also be imposed on the selected Z indices. The optional two-sector cap is derived from that checked symmetry and the existing monomial exclusion, not assumed for arbitrary input pools.

`global_quotient_bounded.cpp` runs the full-pool partitioned search, optionally using a previously proved bound on the number of seed-4 monomials. Its mandatory-member and nonmonomial-rank prunes are necessary conditions on a completing basis. The bounded implementation agrees with independent exhaustive enumeration on 373 positive and 1630 negative small instances. Exact-key memoization had zero hits in the first million source nodes and was not extended.

`quotient_frontier.h` and `global_frontier.cpp` preserve every unvisited child when a node/time cap is reached. Instead of abandoning unexplored siblings, the engine finishes enumerating the parent partitions and exports their active pools, already fixed canonical pairs and remaining monomial allowance. Each exported task is a complete residual search problem. The checkpoint controls exhaust 2003 small instances: all1652 valid frames still unsearched were exported exactly once, and18985 residual tasks were checked independently. `replay_frontier.py` preserves the task tree and every queued/interrupted leaf. Completing some tasks is partial progress; a global obstruction requires every exported leaf to be resolved, together with the root traversal and its explicitly recorded prior monomial bound. A frontier file or a node limit alone is never an UNSAT result.

`materialize_pool_frame.py` converts any candidate pool result into physical supports for `verify_partial_frame.py`. Its88-pair control passes physical syndrome and full Gram checks. A future128-pair SAT result therefore has a ready independent physical validation path.
