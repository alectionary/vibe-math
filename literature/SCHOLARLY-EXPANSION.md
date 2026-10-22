# Coauthor and citation search expansion

This pass was checked October 22, 2026. Its counts below describe the earlier expansion snapshot. The later [Edge Scholar/X continuation](BROWSER-SEARCH.md) brings the current inventory to 181 entries, 108 eligible targets and 58 paper records.

The search adds **21 full-text paper screens** and **57 canonical entries**, including **27 mathematical targets** eligible for coverage tracking. The other 30 entries are directions, formulation or method requests, or statements held after counterchecks. Repeated questions share an existing canonical entry. See the updated [inventory](OPEN-PROBLEMS.md), [searchable table](open-problems.html), and [structured review](scholarly-expansion-review.json).

## Counts and scope

| Measure | Earlier cohort | Expanded cohort |
| --- | ---: | ---: |
| Canonical inventory entries | 114 | 171 |
| Eligible mathematical targets | 74 | 101 |
| Article and preprint records | 31 | 52 |
| Full texts screened, including withdrawn history | 30 | 51 |
| Eligible targets with a complete verified Lean proof | 1/74 (1.35%) | 1/101 (0.99%) |
| Additional identified Lean statements without a build audit | 0 | 1 |

The proof count is unchanged: the dyadic rank/support theorem remains the completed Lean target. The lower percentage reflects the larger denominator. Five eligible additions have **unassessed Lean discovery**; they are not treated as evidence of absence. Other additions received bounded family-level searches, not exhaustive declaration searches. Completed source-posed targets remain in their cohort so that later progress does not remove them from the denominator.

The 21 additions comprise five papers by dissertation authors and 16 related coauthor or external papers. They include earlier work recovered through the new search, overlapping versions, and later developments. They are not 21 independent post-dissertation contributions. The earlier [difficulty estimates](../planning/LEAN-DIFFICULTY.md) remain a 114-entry snapshot; the 57 additions have not received effort estimates.

## New questions and downstream references

**Neural codes and oriented matroids.** Kunin, Lienkaemper and Rosen’s earlier paper supplies questions about polytope realizations, decidability, minimal oriented matroids above a code, and missing-codeword links. Jeffs and Trang explicitly restate the polytope-realization conjecture as Conjecture 1.3 and report the affirmative planar case. Their covering-relation results are related progress, not a general resolution. The restatement is a second occurrence of **L-F07-Q6.3**, not another problem. [Earlier questions](https://arxiv.org/html/2002.03542v2), [later restatement](https://arxiv.org/html/2512.04241v1).

**Replicable learning beyond geometric partitions.** The recovered Dixon–Pavan–Vander Woude–Vinodchandran paper is explicitly used by later coauthor work on bandits and reinforcement learning. The bandit paper asks about a list-size lower bound in a specified regret regime and changes to UCB; the RL paper proposes extensions beyond tabular models and discrete actions. These are different targets from optimal secluded partitions. The inventory holds questions without specified guarantees outside the denominator. [Earlier framework](https://arxiv.org/html/2304.02240v1), [ICLR bandit paper](https://proceedings.iclr.cc/paper_files/paper/2025/file/0faa0019b0a8fcab8e6476bc43078e2e-Paper-Conference.pdf), [RL directions](https://arxiv.org/html/2512.00553v1).

**A later algorithmic answer in differential privacy.** Canonne, Su and Vadhan connect randomness-efficient privacy mechanisms to the rounding schemes of Vander Woude and coauthors. They ask for efficient mechanisms and improved randomness/accuracy tradeoffs. Ghentiyala subsequently gives a polynomial-time construction with a closely related tradeoff. The logarithmic-randomness specialization still has a larger error term than the near-optimal accuracy sought in the separate question. **L-F14-efficient** records the parameterized answer; **L-F14-accuracy** remains a distinct target. [Original future-work questions, PDF page 8](https://drops.dagstuhl.de/storage/00lipics/lipics-vol325-itcs2025/LIPIcs.ITCS.2025.27/LIPIcs.ITCS.2025.27.pdf), [later construction and parameters](https://arxiv.org/html/2510.16959v1).

**Quantum-code uptake outside the original author group.** Abiad and Castriota explicitly cite Morris–Pllaha–Kelley and give a restricted enumeration of elementary (3,3) absorbing sets for column-weight-three, girth-at-least-six QC-GHP codes. Their remaining questions concern further counts and informative stopping-set bounds. This is linked to **L-P09-structured** as restricted progress. Separate dyadic-code papers cite Martinez’s work and the later Gómez-Fonseca–Matthews–Morris–Pllaha paper, establishing additional citation uptake without repeating the rank/support conjecture. [Absorbing-set enumeration and open problems](https://arxiv.org/html/2607.13666v1), [dyadic construction references](https://arxiv.org/html/2601.08636v1), [later quasi-dyadic construction](https://arxiv.org/html/2609.24201v1).

**Additional mathematical families.** The additions also include Wright and coauthors’ questions about tri-plane crossing and bridge invariants, Kara–Lew’s questions about polarized neural ideals, and work by Larios and coauthors on Voigt models and data assimilation. Model changes and different invariants receive separate targets. [Surface questions, Section 6](https://arxiv.org/html/2302.08431v1), [polarized-ideal questions](https://arxiv.org/html/2602.16993v1), [Voigt variations](https://arxiv.org/html/2605.05139v1), [assimilation smallness question](https://arxiv.org/html/2508.07492v1).

## Counterchecks and formalization status

Two graph statements require care before scheduling a general proof.

- **P29, Conjecture 1:** the literal connected-graph bound needs an order restriction. Under its definition, the initial graph K2 never returns under exact-distance-two iteration, so its periodicity is zero, while the proposed upper bound is minus one. The entry is held for clarification; an intended repaired statement is not substituted. [Definition 1 and Conjecture 1](https://arxiv.org/html/2606.25493v1).
- **P32, Conjecture 5:** the relaxed bound of at most 55 triangles on 99 vertices under diamond and K2,3 exclusions fails an exact finite check. Eleven 3-by-3 rook graphs, joined by ten bridges, have **99 vertices and 66 triangles**. Adjacent pairs have at most one common neighbor, and any pair has at most two, excluding both forbidden subgraphs even as non-induced subgraphs. This graph is not degree-14 regular and does **not** settle Conway’s strongly regular graph problem. The preprint itself leaves certificate formalization for future work. [Stated bound and certificate discussion](https://arxiv.org/html/2610.16266v1).

The construction and checks are reproducible with `python3 scripts/check_expansion_graphs.py`; [recorded results](expansion-graph-checks.json) distinguish Python verification from Lean verification. No novelty or priority claim is made for these counterchecks. An earlier [IRSI public note dated October 20](https://irsi.ai/notes/frontiermath-open/) already reports counterexamples to P32 Conjecture 5, with 169 and 120 triangles. It is AI-authored and not peer reviewed; the 169-triangle example has not been independently reconstructed here.

For Conway’s original existence question, Mathlib contains **`SimpleGraph.conway_99` as a `proof_wanted` statement**. This is recorded as an identified Lean statement without a build audit, not a verified proof or an established nonexistence result. [Pinned public source](https://github.com/leanprover-community/mathlib4/blob/0db93bb44438a03c84317df5f033136cdd14c91f/Wanted/Combinatorics/SimpleGraph/StronglyRegular.lean).

## Search evidence and remaining limits

All 20 dissertation authors received another name/topic search. Targeted coauthor groups span neural codes, support varieties, fluid–structure PDEs, statistical prediction, coding theory, configurations, differential operators, fluid regularization, surface topology, replicability and saturation. Coauthor connections are identified individually in the bibliography; an advisor or topic connection is not presented as a citation.

Two direct Google Scholar queries were inaccessible through the web tool. No successful Google Scholar search is claimed for that web-tool pass; the subsequent [Edge continuation](BROWSER-SEARCH.md) successfully searched Scholar and X. Alternatives included native OpenAlex lookups, DBLP, author bibliographies, arXiv manuscripts and official proceedings. OpenAlex supplied 26 successful and four failed lexical author/coauthor queries, six successful exact-title searches, and six successful bounded forward-citation lookups. The first lexical searches produced many irrelevant name matches, so metadata alone did not establish authorship. Exact-title searches and primary texts supplied stronger matches. Sparse citation results missed references independently present in the manuscripts; zero results do not establish zero citations.

The [60 recorded web queries](scholarly-expansion-searches.json) cover author/topic, coauthor, title, follow-up and Lean discovery. They are batched discovery records, not 60 independent comprehensive database searches. New Lean discovery comprises eight GitHub code queries capped at ten hits each and seven lexical queries in the pinned Mathlib tree. The strongly-regular-graph query reached its cap. Retrieved candidates were compared with the mathematical objects; financial replication, Voigt special functions, and topological absorbing sets do not match these targets. No new external Lean artifact was built or axiom-audited. Five eligible targets retain unassessed discovery status.

The expansion is bounded rather than a census of every coauthor’s publications or a recursive traversal of the citation graph. Two candidates remain explicit: a full-text question screen for *Replicability in High Dimensional Statistics*, and a manuscript listed as submitted on Gómez-Fonseca’s bibliography without a verified public text. Neither is included in the 21 new full-text screens. P10’s earlier licensed-text gap also remains.

Evidence files:

- [OpenAlex author/coauthor discovery](expansion-openalex-author-searches.json), [exact-title searches](expansion-openalex-title-searches.json), and [forward citations](expansion-openalex-forward-citations.json).
- [Primary retrieval attempts and hashes](scholarly-expansion-retrievals.json), [source manifest](downstream-source-manifest.json), and [record dispositions, merges and pending candidates](scholarly-expansion-review.json).
- [GitHub Lean searches](expansion-github-lean-searches.json), [candidate comparisons](expansion-lean-candidates.json), and [local Mathlib queries](expansion-local-lean-searches.json).

Full manuscript snapshots and extracted text remain in ignored local storage. Public records provide source URLs, hashes and exact extraction locations. The extraction script is [available here](../scripts/extract_literature_expansion.py); its PDF branch uses `pypdf`.
