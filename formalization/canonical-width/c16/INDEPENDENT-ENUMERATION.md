# Independent low-weight pool enumeration

This is an independent finite computation, with a written completeness argument. It is not a Lean certificate and does not decide the existence of a 128-pair weight-16 frame.

## Inputs and result

`make_enumeration_input.py` reconstructs the binary checks directly from equation (50), without importing the author's search. Its balanced check matrices agree row-for-row with the released physical matrices. Each 32-row trace block is expanded to its 48 equivalent binary checks; the rank remains 480. The 128 independent detector rows complete the opposite stabilizer space to rank 608.

`enumerate_physical.cpp` is a fresh implementation of the odd-check branching method in Appendix A of arXiv:2610.06820v1. The saved run processes all 68 roots at weight bound 17: 47,708,679 nodes in 56.1066 seconds. It finds exactly 45 normalized nontrivial physical orbits, all of weight 16, equal to the published orbit list. Each has 16 translates, giving 720 physical representatives. The implementation has a different traversal and node count from the author's program. It does not import that program's exclusions.

The frozen input, output, logs, source/binary hashes and compiler identity are in `four-hours-results/enumeration/manifest.json`. `verify_independent_enumeration.py` independently checks the input construction, all recorded masks, syndromes and detector values, normalized orbit equality, 68 completed roots and node total. It does not replay the traversal itself. Rebuilding and rerunning the C++ executable supplies that check. `test_physical_enumerator.py` also exhausts 24 small binary matrices and confirms coverage of all 610 support-minimal kernel words; extra emitted kernel words are allowed.

## Why the traversal is complete

Call a nonzero kernel support irreducible if it contains no proper nonempty kernel support. Fix an irreducible target support S within the weight bound. At a proper nonempty prefix U of S, the syndrome cannot vanish: otherwise U is a proper nonempty kernel support. For any odd check at U, the remaining set S minus U contains an odd, hence nonzero, number of available neighbors of that check. Branches select the first such neighbor in the branch order and forbid earlier neighbors. Thus one branch retains S, and distinct branches partition possible target extensions. Forbidding earlier neighbors is confined to that branch's descendants and undone on return.

The weight budget never cuts a target within the bound. The packing bound selects odd checks with disjoint available-variable neighborhoods. Each requires a distinct additional variable, so a target needs at least as many remaining positions as the packing size. This bound is a necessary condition, not a heuristic exclusion.

Any irreducible support has a lowest occupied binary block. A cyclic translation places an occupied position of that block at position zero. The corresponding one of the 68 roots permits the target and excludes only earlier blocks. Consequently the complete root traversal covers all irreducible nontrivial supports of weight at most 17, modulo translation. A zero-syndrome stopping rule loses no such support.

A shortest nontrivial logical support is irreducible. If it split into a proper nonempty kernel support and its nonempty complement, at least one summand would remain nontrivial modulo stabilizers and would be lighter. The enumeration therefore proves the sector distance is 16. Every column of the check matrix is nonzero, so every nonzero kernel support has weight at least two. Any nontrivial word of weight at most 17 that were reducible would split into a nontrivial summand of weight at least 16 and a nonzero kernel summand of weight at least two. That is impossible. Hence all nontrivial words through weight 17 are irreducible, and the enumeration gives the complete pool through that bound.

## Both sectors and mixed Paulis

The physical tensor-transpose permutation is checked to be an involution on all 1088 qubits. It exchanges the two check row spaces exactly (each combined rank is 480). This transfers the enumeration result to the other sector. Independent physical arithmetic checks every one of the 720 representatives per sector and the complete 720-by-720 support-union table; its minimum is 26.

For a mixed Pauli of weight at most 17, both CSS components cannot have nontrivial logical classes, since their support union would have weight at least 26. Removing a trivial stabilizer component leaves its pure logical component, does not increase support, and preserves all logical commutation pairings. Every remaining nontrivial pure component through weight 17 is in a weight-16 pool class. Thus any unrestricted canonical frame of width at most 17 would yield a pure-sector canonical frame drawn from these pools. The independently verified width-18 frame and distance-16 lower bound therefore give f(C^LP_16,9) in {16,18}. The unresolved finite question remains whether the pools contain 128 dual pairs.

## Reproduction

```sh
clang++ -O3 -std=c++17 enumerate_physical.cpp -o /tmp/c16-enumerate
python make_enumeration_input.py --help
/tmp/c16-enumerate four-hours-results/enumeration/input.txt /tmp/c16-enumeration.json 17 0 68 1800
python test_physical_enumerator.py --binary /tmp/c16-enumerate
python verify_independent_enumeration.py
```

Use Python 3.10 or later for `int.bit_count`. The result is a reproducible computational completeness argument; checking the traversal in a proof assistant remains open.
