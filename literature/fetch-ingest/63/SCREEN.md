# Screen for fetch issue 63

- Fetch issue: https://github.com/alectionary/vibe-math/issues/63
- Manifest id: `vibe-math-63-worker-20261102`
- SHA-256: `d7ad1675aa9882a226ab0b9349beac0ab51f467deb57b900d4274b26e6360715`
- Pages: 28
- Record: F173
- Question count in this screen: 1

This note copies the 2026-11-02 screen in [fetched-papers-2026-11-02.md](../../fetched-papers-2026-11-02.md). It does not add a finding. The manifest `question_screen.status` stays `not_screened`.

## What the paper establishes

William H. Cunningham, *Testing membership in matroid polyhedra*. *Journal of Combinatorial Theory, Series B* 36 (1984), 161–188. The file is a scan with a text layer, not an OCR pass. https://doi.org/10.1016/0095-8956(84)90023-6.

The paper gives a strongly polynomial combinatorial algorithm, Algorithm 4.1, for testing membership in the matroid polyhedron, using an independence oracle and a grand augmentation along a shortest dipath. Section 5 records linear descriptions of the blocking and anti-blocking polyhedra of common bases as Corollaries 5.4 and 5.5, and attributes the statements to consequences derived in other papers and conjectured by Fulkerson. Those corollaries are proved here. The sketch that begins “we conjecture that a grand augmentation might be constructed” is then defined formally, and the text later says “This proves the validity of the grand augmentation” (extracted line 678). Those passages are not open targets.

## Open questions

[L-F173-strongly-polynomial-sfm](../../OPEN-PROBLEMS.md#l-f173-strongly-polynomial-sfm). Section 6, printed page 182 (PDF page 22), states that it is an important open problem to find a strongly polynomial algorithm for submodular function minimization, or even a practical combinatorial method that runs in polynomial time. Extracted lines 973–976. The rendered page was compared with the text layer for that sentence. The wording matches, including “strongly polynomial” and “practical combinatorial method which runs in polynomial time.” The text layer drops the empty-set glyph in the next display, where the page shows \(f(A)=g(A)+x(A)-g(\emptyset)\). That display is not the open-problem statement. The paper then gives partial polymatroid and matroid-rank cases and says that no analog of the Section 4 refinement is known for the general polymatroid. The 1984 text leaves the general problem open. Whether a later paper solved it was not checked. Lean discovery was not assessed.

The source was read because the C16 width investigation named this membership algorithm. Nothing in this screen transfers Cunningham’s complexity bound to that repair, and this screen does not change the status of L-F91-c16-unrestricted-width.
