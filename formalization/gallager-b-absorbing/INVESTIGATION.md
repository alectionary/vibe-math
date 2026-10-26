Issue: https://github.com/alectionary/vibe-math/issues/2

## Target and authorization
Canonical target: **L-P09-all-absorbing**. New investigation of a previously inventoried question; not another distance-preservation follow-up.

**Question:** Under the syndrome-based Gallager-B decoder of Morris, Pllaha and Kelley, *Absorbing Sets in Quantum LDPC Codes*, arXiv:2307.14532v2, Section VI, is every absorbing set a trapping set?
Source: https://arxiv.org/html/2307.14532v2

## Answer contract
Source question → a proof with faithful hypotheses and quantifiers, or an independently verified counterexample → exact source-to-model comparison, complete written proof, matching checked Lean evidence, reproducible artifacts and a standalone paper.

The source's initialization, update schedule, thresholds/tie rules, ambient Tanner graph, trapping definition and quantum recovery convention must be frozen before interpreting experiments. Finite failure through a cutoff is not infinite trapping; a recovered full support need not refute a definition quantifying over subsets.

## Prior work and remaining gap
- Previously proposed in the inventory and October 25 candidate review.
- Existing absorbing-set counts, distance-preservation theorems and min-sum trajectories do not establish this decoder-specific claim.
- No exact completed proof/counterexample is recorded for this canonical target.
- Search of all issue states returned only the distinct F25 issue mentioning this reserve; no canonical P09 issue or claim existed at access check.

## Scope and stopping condition
User authorizes research and repository publication with a six-hour budget, starting 2026-10-26 06:22:37 UTC; deadline 12:22:37 UTC. Pursue the exact question, first audit primary definitions and current literature, then small exact examples and proof/counterexample development. Publish only claims supported by the completed evidence; report an unresolved outcome if no decisive answer is verified by the deadline.

## Coordination
Session: gallager-20261026T062237Z-01a176d9
Work branch: research/L-P09-all-absorbing-20261026T062237Z
Isolated checkout: /private/tmp/vibe-math-review
Claim: refs/heads/claims/L-P09-all-absorbing (pending creation).
Owner: this authorized Codex session. Status: setup in progress; substantial research begins after exclusive claim read-back.
Next action: commit answer contract, publish work branch, create claim reference with create-only API, then inspect source and literature.
No GitHub Project requested.

## Verified answer and meaning
The unrestricted statement is false under the inspected v2 definitions. The 7x7 matrix H[a,v]=a dot v on nonzero F2^3 vectors is (7,0)-absorbing. All 128 input subsets are accepted at initialization or after the first full zero-initialized, zero-tie Gallager-B iteration. Both hard-decision and outgoing-edge syndrome conventions match. A halted decoder is extended by its constant terminal output for eventual-convergence statements.

The same H in the two Steane sectors still permits logical miscorrections. A separate actual fourteen-coordinate CSS pair HX=diag(H,H), HZ=diag(K,G), with G=rows1,2,4 of H and K=[G;ones], corrects every supported Z-error on the first block modulo the complete HZ span. The second block has a checked nontrivial logical. This uses redundant checks, degree4 and four-cycles; the selected component is connected but the ambient CSS graph is disconnected. No high-girth, column-weight3, distance, or both-sector recovery assertion is made.

## Verification
A clean standalone Lean4.36.0-rc1 build of all 26 theorems completed successfully, including the actual fourteen-coordinate update/syndrome/rowspan bridge. Only Std is imported. The axiom reports contain only propext, Classical.choice and Quot.sound; no admitted proof or native decision shortcut is used. The independently implemented literal-matrix verifier exhausts all128 inputs and checks full CSS commutation, complete stabilizer spans and a nontrivial logical witness. See verification.json, lean-build.log and independent-verification.log.

## Time accounting and resumption
The original six-hour deadline was 2026-10-26T12:22:37Z. The complete verified artifact was not delivered by that deadline. Verification.json records the clean build at 13:21:31Z. The user subsequently instructed "Can you resume"; publication, source reconciliation and visual QA continue under that instruction. This is explicitly an overrun, not a result claimed delivered inside six hours. No unverified discovery-time estimate is inferred from file timestamps.

## Prior work and searches
Current primary comparison: arXiv:2307.14532v2, source PDF pages2-3 (decoder and definitions), Sections IV and VI. Journal metadata is available but the journal full text requires a subscription. Hamming's syndrome construction and Steane's CSS construction are established ingredients, not claimed as new. GitHub and signed-in X received bounded searches; see prior-art.json for queries, controls and access limits.
