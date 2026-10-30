# Public archival availability audit: Higgott Figure 7.14a

Date: 2026-10-30. Independent source-review findings supplied with repository-history and public API inspection. This is a bounded search for per-basis counts, exact circuits/commands, plotting inputs, decoder settings, and dependency versions. No author contact occurred.

## Outcome and checked sources

No original figure-production bundle was located. This does not establish that no bundle exists. The comparator's historical dependency pins and noise changes were recovered, but neither identifies Higgott's production choices.

| Source | Scope | Finding |
|---|---|---|
| [hyperbolic-floquet-data](https://github.com/oscarhiggott/hyperbolic-floquet-data) at 457975f0d6c67b3a505aacf44589d36779f5dcc1 | One public branch, no tags/releases; all 11 reachable commits, 2023-08-07 to 2023-09-20; 516 historical paths | 512 Stim files, two parameter CSVs, README, LICENSE; no figure scripts, trial/failure arrays, locks or production commands. |
| [honeycomb-boundaries](https://github.com/Strilanc/honeycomb-boundaries) at cc33baac44c7831bd643db81d0053f8ec6eae9d8 | Main plus fix_em3_boundary_noise (3269233894fea378593a24bbbf47179a501605f1); 52 reachable commits, 58 historical paths | 53 Python files plus CI, README, requirements, license, gitignore. No shot-count arrays, including deleted paths. |
| [v1-arXiv release](https://github.com/Strilanc/honeycomb-boundaries/releases/tag/v1-arXiv) | Commit 4525294458960efef375601a039fba6b0b84767b; no uploaded assets | Release explicitly describes arXiv:2202.11845, the planar paper, not Higgott's figure. |
| [arXiv v2 source](https://arxiv.org/src/2308.03750v2) | 25 archive members; SHA256 8f0c7a3e69e09bb17a46397cf4063d536778b810c318794f6c4ec4eaa17e7027 | Manuscript, bibliography and figures, including target panel; no raw counts/logs/scripts. Extends earlier v1 audit. |
| [Owner repository list](https://api.github.com/users/oscarhiggott/repos?per_page=100&type=owner) | 18 repositories; plausible circuit/decoder HEAD path indexes screened | No target production-bundle path found; not an exhaustive content/history audit of every repository. |
| [Publisher supplement endpoint](https://journals.aps.org/prxquantum/supplemental/10.1103/PRXQuantum.5.040327) | Direct web retrieval attempted | Inaccessible, not proven absent. Exact-title/arXiv-ID searches with supplemental data and Zenodo found no other identified run archive. |

Related HEAD trees inspected: StimCircuits 93b4283148286cb3eb307870164132ac28ef06a7; slowmatch 15f9ae44998917200f2fe35f65bb44f0fd612cc0; BeliefMatching 4458c278bbec273c8c1a26411dadccc49222f8ef; PyMatching 6f63b2b9474ba0fa7e511fe52bffdce858a06984; Stim 197d9a64ea0734cf83a610601223f34fc6065ada. This screening does not cover private repositories or unadvertised archives. Zenodo 14238944 was inspected and excluded as Google's unrelated color-code dataset.

## Meaningful historical evidence

The noisy Bolza files entered in [e5d6a68](https://github.com/oscarhiggott/hyperbolic-floquet-data/commit/e5d6a682d46b918fe1c3b52ce8cded092d044af6); DP1 and parameter files entered in [87eccb4](https://github.com/oscarhiggott/hyperbolic-floquet-data/commit/87eccb431c537b46d85de2e84c67197b8f6079dd). Neither adds target run counts.

Comparator requirements introduced in [497528a](https://github.com/Strilanc/honeycomb-boundaries/commit/497528a3ea9f1ec8e38b92b14330e30dadfef107) pin Stim/StimCirq 1.8.0, PyMatching 0.6.0, NumPy 1.22.1, SciPy 1.7.3, Matplotlib 3.5.1, cirq-web 0.13.1 and pytest 6.2.5. They are repository pins, not a Higgott environment lock.

[9842c69](https://github.com/Strilanc/honeycomb-boundaries/commit/9842c6909c14f0ca0d3845b470824cdfa34c5111), 2022-03-24, adds correlated single-body boundary noise in EM3_v3; v2 already correlates pairs. [5d2fcbf](https://github.com/Strilanc/honeycomb-boundaries/commit/5d2fcbf06b944b3ac396bc7388675825891faa39), 2022-03-28, adds SDEM3. [512bc7d](https://github.com/Strilanc/honeycomb-boundaries/commit/512bc7d611a087a6e161f92e2b7b99e3c58d905e), 2022-04-11, switches plotting filters to v3. Thus citing the repository does not uniquely select the production model.

The comparator supports pymatching, internal, and internal_correlated decoders; its internal binary is described as non-public. That is not evidence Higgott used it. Generic collection commands derive durations from distance and are not the Figure 7.14a production command.

## Remaining inputs and stopping boundary

Still unrecovered: original X/Z trials/failures, seeds/stopping rules; exact Bolza observable configuration and generation command; planar boundary variant; decoder version/options/graph/ties; figure-specific lock and plotting-data link. Relevant histories/releases and identified archives are now exhausted within this bounded search. A newly supplied archive or author-provided run record is required for exact procedural recovery. No author contact is authorized or performed.

The independent reviewer retains API responses, history indexes and diffs outside this checkout. This readable audit records the findings and public commit URLs; those raw responses are not represented as bundled here.
