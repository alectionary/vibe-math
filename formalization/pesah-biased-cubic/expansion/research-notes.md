# Whole-dissertation expansion: working findings

Status: open. Stage 1 pure-X results and their immutable reproduction revision remain preserved. Whole-dissertation coverage is in coverage.json; this expansion does not relabel that partial milestone complete.

## Pure-Z reconstruction

The generalized Pauli path passed 480 historical dense-reference correction comparisons, including pure X, pure Z, finite Z bias and depolarizing noise. It shares the graph, NumPy, errors and host; the independent component is dense versus sparse/integer decoder implementation. A categorical draw preserves Y-induced correlation between binary components. The initial pilot predicts approximately 2405 seconds for 8800 all-size production trials; actual high-noise costs may differ. CPU and memory limits apply per size, with deterministic checkpoint resume.

## Rhombic convention conflict

The dissertation's prose specifies Z cube and X triangle stabilizers (pp.30–32), consistent with its high pure-Z threshold. Historical commit 686560e5d03c2e5d31f6c6260b03756af03a7e93 instead constructs X cubes and Z triangles. Independently constructed dissertation-convention matrices match the historical matrices exactly after a global X/Z exchange, including logical operators, at L=2,4,6,8,10. Neither convention changes code parameters, but it exchanges labeled noise directions. Therefore running the historical source without an explicit convention mapping cannot replicate the labeled thesis comparisons. Both mapped and unmapped interpretations must remain visible in validation; the commit is not confirmed as the original production version.

## Analytical finite checks

Both geometries encode exactly three qubits at the five tested sizes. Logical witnesses have weights L and L^2 (cubic), L and 2L^2 (rhombic under prose convention). Witness weights give upper bounds, not proof of minimum distances. Restricted first-axis detection nullities are L^2 for cubic point chains, L for cubic loop planes, and zero for rhombic triangles. These verify the finite reductions and unique rhombic restricted-axis recovery, without proving BP-OSD attains the optimal 50% limits.

## Source numerical caveat

Figure 3.4 visibly shows the deformed point-sector failure plateau near 0.5 and total plateau near 0.875. The source calls the deformed pure-Z threshold unresolved and reports >36%, not an exact 36%. Finite-size fits near saturation must not be presented as precise resolved thresholds.
