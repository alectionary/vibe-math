# C16 strategy reassessment and six-hour continuation

Canonical target: `L-F91-c16-unrestricted-width`, issue8 (read-only).
Session: `c16-strategy-20261029T0321`; work branch
`research/c16-strategy-20261029T0321`.
Authorized start:2026-10-29T03:21:21Z; deadline:2026-10-29T09:21:21Z.
Baseline:ffaa9f6f3513e1b91f34aac5741703ad39402d22.

The original question is whether the fixed source code has unrestricted
canonical width16 or18. A physical128-pair frame in the complete720-vector
minimum pools proves16; a complete justified nonexistence proof proves18.
Current evidence: physical88/128, sufficient selected-pair cover418,
zero completed full source anchors. The last rank-cover pilot produced
47 checked mixed-rank obstructions but no smaller cover or acceleration.

Question/source → intended answer → decisive evidence: reassess structural,
literature and existing-code routes to the full128-pair decision; identify
and pursue a decisive restricted lemma or construction test with explicit
source bridges. Exact independent certificates are required for exclusions
or constructions. No time-to-discovery estimate is asserted.

First phase: compare the strongest structural routes with the already tested
relaxations, search primary papers and public code using the resulting precise
translations, and freeze bounded tests before expensive implementation.
Later phases pursue the best-supported route, with explicit stop conditions
and time reserved for independent replay, source/question accounting,
preservation, required-review publication and expected-SHA claim release.

No sub-agents, issue messages, new schedules, master bypass or auto-merge.
Use the existing PR17 for authorized repository publication. Read-only issue
policy persists. New literature must be indexed and full accessible texts
screened for author-stated questions before closeout.

## First checked result

The sufficient selected-pair cover is now **417**, down from418. The source
width remains16 or18; physical partial frame88/128; no full source anchor has
been completed. `strategy-results/cover-417.json` binds the new case manifest.

The frozen class(26,32,15), normalized to physical pool indices416/527, is
removed from the cover. Pure zero-domain rank refinement found a six-pair
partial matching with residual pool ranks122 on both sides. It has167
residual X candidates and205 residual Z candidates. Thus these separate rank
tests alone cannot reject it. Any submatching also passes them: the removed
pairs' private partners complement the original residual span.

Mandatory-pool propagation rejects this witness. In particular, the residual
Z pool has a coloop at102 with no residual X vector giving its unique private
column. More generally the already implemented propagation alternates basis
coloops, zero-domain coloops, mandatory independence, unique partners and pool
filtering. A native implementation discovers clauses; a new independent
low-pivot consumer checks every forced coloop by a physical covector supported
on that pool point alone. This is a new application of the existing propagation
principle, not a new general rank theorem.

The local refinement has101 positive partial models and201 minimized source
clauses before UNSAT. A fresh ordinary CaDiCaL run produces a DRAT proof;
independent physical input regeneration and DRAT replay pass, including an
empty-proof rejection and10214 directly checked coloop covectors. The entire
parent418 proof chain also replays, including63 new anchored proofs and its
recursive base. Both pieces are needed for the cover417 conclusion.

Why this is a cover reduction: a hypothetical full frame avoiding the new
retained list would project to a compatible nonzero-signature matching inside
the old100 omitted classes plus c. Delete zero-XOR subsets until signatures
are linearly independent. The old omitted-set UNSAT premise forces some pair
in c to remain. Translate and exchange sectors to normalize that pair to the
fixed anchor. Universal negative full-basis clauses remain valid after deleting
pairs. The new anchored UNSAT certificate then gives a contradiction. This
does not exclude c from frames which use a different retained class.

## Signature normalization and the next bounded gate

Every finite binary vector family with a specified XOR sum has an independent
subfamily with the same sum: delete a nonempty zero-XOR dependent subset until
none remains. For the16-bit signature map, at most16 pairs remain. Compatibility
and all negative selected-vector/pair consequences survive deletion. The
normalization can therefore be imposed on compact necessity models, including
source-rank and mandatory-propagation clauses. For an anchored cover-extension
argument the old omitted-set UNSAT premise is essential, as above.

This is an exact reformulation, not a stronger unconditioned signature-cover
criterion. Adding lazily learned zero-XOR signature-circuit clauses merely
enforces this normal form. The old121 packing lower bound is unchanged by this
normalization alone, but does not transfer to the stronger source-closure
criterion. Global pilots of500 rank-only and1000 closure refinements ended at
their round caps without a source decision. A separate1000-round matroid/closure
pilot also remains unresolved. These bounded failures are retained.
