# Bounded exact full-selector source-case trial

The baseline and the baseline plus accepted scale64 cut0 both returned UNKNOWN under separate 120-second solver budgets. No source case is excluded and no physical frame was found. The source cover remains 405; this trial gives no measurable benefit from the cut.

The fixed case is X512/Z512, equivalently (32,32,0). All 720 X flags and all 720 Z flags are present, with exactly 128 selected in each sector. Every pool row has positive selected opposite degree, and every selected row and column has degree at most one. Consequently the selected 128 by 128 physical pairing matrix is a permutation matrix. A satisfying assignment would be a genuine 128-pair source frame after literal physical verification. This is stronger than the earlier partial owner-completion SAT model.

The independent bridge rebuilt the physical pairing matrix, shared threshold counters, two full-cardinality blocks, and fixed-anchor units. It checked the added PB clauses by exact variable relabelling of the prior independently controlled implementation, using the unchanged accepted integer coefficients and bound. Baseline has 213,376 variables and 842,378 clauses; augmented has 257,096 variables and 990,227 clauses. The only difference is the 147,849-clause cut appendix. No other projected rows or rank caps were added.

The sequential trials use CaDiCaL195 through python-sat with fixed seed 20261030 and proof collection enabled. The outer controller terminated each worker after 120 seconds following solver readiness. Outer times include startup and were 120.609 and 120.608 seconds. Neither produced a model or completed proof; no solver statistics were recovered after termination. Therefore no speed or search-effort improvement is claimed.

The prepared independent SAT consumer would replay every literal CNF clause, exactly 128 selected indices in each sector, all 16,384 pairings, both physical ranks, and the integer cut. Its positive-frame branch was not exercised here. An UNSAT case requires independent proof replay before any exclusion. No further SAT run is part of this bounded gate.
