# Three-term quotient obstruction: bounded continuation

Canonical target: `L-F91-c16-unrestricted-width`, existing issue8 (read-only).
Session: `c16-three-term-20261029T1448`.
Work branch: `research/c16-three-term-20261029T1448`.
Prepared at2026-10-29T14:48Z; interrupted before claiming or beginning experiments.
Research resumed at2026-10-29T17:00:28Z.
Baseline:9d9977b2e4134bb4f3a50177f0e0f12545e4150f.

This is a follow-up to the proposed three-term gate in STRATEGY-REASSESSMENT.md.
The source question remains whether the unrestricted canonical width of the
fixed source C16 code is16 or18. The independently checked sufficient cover
has409 selected-pair cases, the physical partial frame has88/128 pairs, and no
full source anchor is solved. The independent source-pool enumeration and
mixed-Pauli reduction are preserved; no source Lean completion is claimed.

Question/source → intended answer → decisive evidence: determine whether the
general short-word lemma at order3 gives source obstructions missed by the
order2 implementation, then test whether those obstructions reduce a frozen
compact necessity model. An algebraic certificate must be checked independently;
any cover removal additionally requires regenerated ordinary CNF/DRAT proof and
the existing cover-domain induction. A128-pair physical construction or complete
global nonexistence proof would answer the original question.

For selected opposite vectors J, let L=span(J). If w+L has no representation
using at most d source vectors, a full dual basis containing J must have at
least d+1 selected detecting vectors outside J. If the complete detecting pool
has at most d vectors, J is impossible. Such an all-negative exclusion survives
deleting pairs. At d=3, exact pair-sum tables test three-term membership by
scanning single labels. The new work must also search detecting supports of
size3; changing the membership test alone cannot strengthen the old size2 gate.

Bounded plan and stopping rule:

1. Implement the size3 detecting-support and quotient-membership test, and check
   it against exhaustive small controls and an independent Python consumer.
2. Freeze a retrospective source cohort and a deterministic generated cohort;
   compare order2 and order3 on the same inputs. Distinguish a stronger source
   predicate from new full-case progress.
3. If the gate produces independently verified new source obstructions, run at
   most three frozen600-second compact refinement tests, each with a bounded
   ordinary proof/replay budget. Otherwise stop the route with its precise
   negative result. Do not launch an unbounded exhaustive full-frame search.
4. Preserve positive controls, unsuccessful trials, source hashes, inventory
   scope, and clean replay. Update PR17 through the existing review process and
   release only this session's exact claim. No issue messages, auto-merge,
   schedules or sub-agents are authorized by this note.

No new paper is needed to state this elementary extension. Previously inspected
literature and its reading limits remain in strategy-results/literature-ledger.json.
Any additional paper consultation must be recorded and screened at its actual
reading scope. The bounded GitHub source/ownership check finds no intervening
PR or master change. Authenticated X coverage remains unperformed.
