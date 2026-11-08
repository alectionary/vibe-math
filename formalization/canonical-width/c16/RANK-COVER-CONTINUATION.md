# C16 rank-strengthened cover continuation

This is a follow-up on `L-F91-c16-unrestricted-width`, not a new author-posed
question. Original width remains16 or18; physical partial frame88/128; the
starting sufficient cover is418. No new source answer is claimed.

Question/source → answer → evidence: apply the4102 already checked original
rank witnesses to compact cover necessity models; seek a checked reduction or
one frozen matched comparison; require physical reconstruction and DRAT replay.
The precise scope and retained deadline are in `rank-cover-results/scope.json`.

If a full frame yields a compatible partial signature matching by deleting
pairs, every negative selected-vector nogood remains satisfied. Thus these
full-basis consequences can soundly strengthen the partial necessity test.
This does not make them valid for arbitrary partial frames, and the121 lower
bound for the old criterion does not apply to the stronger one. Positive
witness cuts in the cover master must therefore be filtered accordingly.

## Result

**No cover reduction or original-width answer.** The sufficient cover remains
418, original width remains16 or18, and the best checked physical partial
frame remains88/128. Zero full source anchors were completed.

The frozen4102 original rank certificates yield64096 distinct translated
index patterns per sector. They reject40 of2552 saved partial witnesses,
where the frozen cohort retains the first saved witness for each class support.
This does not establish that every witness on one of those40 supports fails.
Twenty-eight rejected witnesses have exactly one class beyond the parent
100-class omitted set; those28 classes form the controlled trial cohort.

| Frozen cohort | Baseline SAT / UNKNOWN | Strengthened SAT / UNKNOWN | UNSAT |
| --- | ---: | ---: | ---: |
| Original short rank cuts,28 matched cases | 28 /0 | 24 /4 | 0 |
| One mixed-rank refinement, same28 cases | 28 /0 | 24 /4 | 0 |

Every call has a25-second wall limit. The first8 targets were frozen before
their calls; the remaining20 targets were frozen as a separate continuation,
using the same ascending domain-size and canonical-class selection rule. The
second cohort was frozen only after deriving cuts from the first cohort; it is
an adaptive refinement, not an independent holdout. Variant order alternates;
two case workers run concurrently. Complete inputs and all positive assignments
are retained. There are112 calls in total:104 SAT,8 UNKNOWN,0 UNSAT.

Both independent consumers reconstruct all518400 physical pairings, replay the
4102 source rank witnesses, rebuild each baseline CNF, and check the complete
set of appended negative owner clauses. They verify every saved SAT assignment
and its physical partial matching. UNKNOWN supplies no exclusion. No DRAT proof
was produced or needed for these positive results.

## Why the next rank test was justified

The existing [`rank_oracle.py`](rank_oracle.py) already implements a general
full-basis rank obstruction. This continuation applies it to the24 new partial
witnesses that survive the short cuts; it does not introduce a new rank theorem.

For a selected independent X set S of size k, let Z0 be the listed Z vectors
orthogonal to every member of S. A full dual frame containing S needs128-k
independent partners in Z0, hence rank(Z0) must be128-k. If the rank is smaller,
there is an annihilator W of Z0 outside span(S). This certifies the negative
clause forbidding simultaneous selection of S. The same argument holds with
sectors exchanged. Deleting selected vectors preserves such negative clauses.

All24 replacement witnesses fail this necessary condition in at least one
sector. Greedy deletion of selected indices, followed by the old witness-based
core reduction, produces47 directly checked annihilator certificates. Their
core sizes range from4 to9: one size4, two size5, nineteen size6, seventeen
size7, seven size8 and one size9. Cyclic translation gives744 additional index
patterns, disjoint from the original64096; sector exchange applies them in
either sector. The refined family therefore has64840 patterns per sector.

These certificates prove that these24 particular partial matchings cannot
extend to full source frames. The refinement oracle nevertheless finds
alternative partial matchings in24 cases; four calls time out. The UNKNOWN
class sets differ by one between rounds. No anchor can be removed on that basis.

## Cost and interpretation

In the first matched cohort, summed solver-call wall times are67.50 seconds
for baseline and135.20 seconds for the rank variant, counting timed-out calls
at their actual wall time. In the refinement cohort they are70.21 and147.46
seconds. These are single pilot measurements with concurrent workers, not a
statistical benchmark or a global finishing-time estimate. They provide no
evidence of an acceleration here. CNF construction and source replay are
outside those solver-call totals.

The strengthened criterion is logically useful: it rejects physically valid
partial witnesses which the old criterion accepts. That has not translated
into a smaller cover. The old121 fractional lower bound remains restricted to
the original signature/compatibility criterion; it does not transfer to the
rank-strengthened criterion. No lessons-learned recommendation claiming a
runtime improvement is added.

## Reproduction and handoff

Use the existing `/private/tmp/c16-venv/bin/python` environment (Python3.12,
PySAT1.9.dev17, CaDiCaL195). Run from the repository root:

```sh
python formalization/canonical-width/c16/audit_rank_cover_witnesses.py --chain formalization/canonical-width/c16/algebraic-results/exchange/chain.json --output formalization/canonical-width/c16/rank-cover-results/witness-audit.json
python formalization/canonical-width/c16/rank_cover_comparison.py --chain formalization/canonical-width/c16/algebraic-results/exchange/chain.json --audit formalization/canonical-width/c16/rank-cover-results/witness-audit.json --output formalization/canonical-width/c16/rank-cover-results/comparison.json --cases 8 --seconds 25 --workers 2
python formalization/canonical-width/c16/rank_cover_comparison.py --chain formalization/canonical-width/c16/algebraic-results/exchange/chain.json --audit formalization/canonical-width/c16/rank-cover-results/witness-audit.json --output formalization/canonical-width/c16/rank-cover-results/remaining/comparison.json --offset 8 --cases 20 --seconds 25 --workers 2
python formalization/canonical-width/c16/verify_rank_cover_comparison.py --folder formalization/canonical-width/c16/rank-cover-results --output formalization/canonical-width/c16/rank-cover-results/independent-check.json
python formalization/canonical-width/c16/mixed_rank_cover_cuts.py --folder formalization/canonical-width/c16/rank-cover-results --output formalization/canonical-width/c16/rank-cover-results/mixed-rank-cuts.json
python formalization/canonical-width/c16/verify_mixed_rank_cover_cuts.py --certificate formalization/canonical-width/c16/rank-cover-results/mixed-rank-cuts.json --output formalization/canonical-width/c16/rank-cover-results/mixed-rank-independent.json
python formalization/canonical-width/c16/rank_cover_comparison.py --chain formalization/canonical-width/c16/algebraic-results/exchange/chain.json --audit formalization/canonical-width/c16/rank-cover-results/witness-audit.json --output formalization/canonical-width/c16/rank-cover-results/refined/comparison.json --cases 28 --seconds 25 --workers 2 --extra-cuts formalization/canonical-width/c16/rank-cover-results/mixed-rank-cuts.json
python formalization/canonical-width/c16/verify_rank_cover_comparison.py --folder formalization/canonical-width/c16/rank-cover-results --refined --output formalization/canonical-width/c16/rank-cover-results/refined-independent-check.json
```

Create the `remaining` and `refined` output directories before regenerating.
To consume the saved results, run the two comparison consumers and the mixed
rank consumer only; no solver is needed. Regenerating solver calls may change
models and elapsed times. Historical scientific manifests are unchanged.

**Question answered:** the frozen rank family and one mixed-rank refinement
do not produce a checked cover improvement in these28 trials. Every saved
positive result and all47 mixed-rank certificates have independent physical
consumers. This is a finite pilot outcome, not a proof that the approach cannot
work.

**Question still open:** whether the original pools contain a128-pair frame;
equivalently, whether the unrestricted source width is16 or18.

**Next proposed target — follow-up:** a bounded adaptive rank-separation test,
learning minimized mixed-family obstructions from successive compact witnesses
at one frozen anchor. Require an independently checked final UNSAT input for a
cover removal, or preserve the surviving necessary-condition witness at the
budget limit. The present results do not justify an open-ended run or a predicted
finishing time.

| Requirement | Status | Evidence / limit |
| --- | --- | --- |
| Frozen comparison | Met | Three `frozen-targets.json` files and all112 saved inputs |
| Physical independent replay | Met | `rank-cover-results/independent-check.json`, `refined-independent-check.json` |
| New obstruction verification | Met | `mixed-rank-independent.json`;47 direct annihilators; zero-witness negative control |
| SAT model checks | Met |104 complete assignments and physical partial matchings; incomplete-model negative control |
| Source question | Partial | Width16/18 and cover418 unchanged;0 full cases completed |
| Literature / Lean completion | Not applicable | Application of existing local rank method; no new paper retrieved or Lean target claimed |
| Publication | Pending review | Existing PR17; required master review preserved; no bypass or auto-merge |
