# October 23 research-to-inventory reconciliation

The main girth result and earlier distance work were already indexed, but the
canonical entries stopped before the later representation, persistence and entry
studies. Several inspected sources remained only in the paper's literature notes.
This update joins that knowledge to the shared inventory without treating
supporting Lean lemmas as additional solved open questions.

[Source bibliography](RESEARCH-SOURCES.md) · [Structured update record](research-reconciliation.json) · [Searchable inventory](open-problems.html)

## What changed

- Indexed 21 sources used in the investigation, preserving full-text, abstract-only,
  inaccessible-paper and software-lead distinctions. Some already had central records;
  this is not 21 newly discovered papers.
- Linked six later research milestones and their Lean sources under the existing
  P34 decoding/design targets. The full girth target remains completed; the broader
  decoding targets are marked partially addressed.
- Added two previously identified primary papers to the main bibliography and
  recorded six source-posed questions/directions from their inspected passages.
- Retained the three existing F16 spectral questions without duplicating them.
  Our different cyclic LP construction does not settle their QC-GHP/GB formulas.
- Recorded five project-derived follow-ups separately from author-posed questions.

## Newly indexed source questions

| Canonical ID | Source question or direction | Coverage | Source locator |
|---|---|---|---|
| [L-F25-distance-preservation](OPEN-PROBLEMS.md#l-f25-distance-preservation) | Find sufficient base-matrix constraints ensuring equality of the quantum and classical minimum distances in the stated type-I LP construction. | Specific target | [F25: Section VI, next-step and structured-code distance-preservation directions](https://arxiv.org/html/2503.07567v1) |
| [L-F25-general-protographs](OPEN-PROBLEMS.md#l-f25-general-protographs) | Extend the type-I LP distance and problematic-structure analysis to more general protographs. | Broad direction | [F25: Section II-A and Section VI](https://arxiv.org/html/2503.07567v1) |
| [L-F25-hardware-entries](OPEN-PROBLEMS.md#l-f25-hardware-entries) | Investigate circulant-entry choices that ease hardware constraints. | Broad direction | [F25: Section VI, final future-work sentence](https://arxiv.org/html/2503.07567v1) |
| [L-F26-exact-distance](OPEN-PROBLEMS.md#l-f26-exact-distance) | Determine the exact X/Z quantum distances of the fixed randomized P=64 lift of B15, currently certified between 18 and 192 in the source. | Specific target | [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3) |
| [L-F26-logical-qubit-lifts](OPEN-PROBLEMS.md#l-f26-logical-qubit-lifts) | Construct connected CSS-preserving CPM lifts with additional nonconstant left-kernel vectors that increase logical-qubit count while retaining the targeted short-cycle constraints. | Specific target | [F26: Section 8, final future-work direction](https://arxiv.org/html/2604.27817v3) |
| [L-F26-replicated-comparisons](OPEN-PROBLEMS.md#l-f26-replicated-comparisons) | Extend repair/decoder comparisons and replicated statistics across multiple lifted instances. | Broad direction | [F26: Section 7 limitations and Section 8](https://arxiv.org/html/2604.27817v3) |

These are newly inventoried, not newly posed today. Their source-described open
status is historical; no new current-resolution or matching Lean search was
performed here. Relevant sections were screened, not every line of either paper.

The inventory grows from **181 to 187 canonical entries** and from **108 to 111
eligible targets**. Complete checked targets remain **3**: the historical cohort
is still **3/108 (2.78%)**, while the expanded cohort is **3/111 (2.70%)**.
The two new sources make **60** article/preprint records; the **57** full-text
screens remain unchanged, with two additional relevant-section screens. New
planning records are explicitly unassessed rather than assigned invented estimates.

## Our remaining follow-ups, not extra source questions

- **RQ-P34-aggregate-entry:** Explain the remaining net representation-dependent decoding deterioration through early, reachable message mechanisms. Status: partial; exact examples and onset/propagation proofs exist, aggregate mechanism remains incomplete.
- **RQ-P34-count-causality:** Isolate the effect of absorbing-set count from check degrees, routing and logical structure. Status: open; existing interventions identify representation effects, not count alone.
- **RQ-P34-early-predictor:** Find an early failure predictor with independent holdout performance beyond baseline error hardness. Status: partial; initial-activity associations weaken under hardness controls; late tubes certify persistence.
- **RQ-P34-objective-ranking:** Identify when cycle-only, absorbing-only or joint objectives predict superior decoding. Status: open; no universally superior objective established.
- **RQ-P34-error-floor:** Derive a quantitative error-floor predictor for the stated model from structural and dynamical properties. Status: open; finite inventories and experiments do not supply a general law.

These remain attached to `L-P34-decoding-effects` and outside the coverage denominator.
Their wording is ours; it is not attributed as an exact question from the source authors.
Negative recurrence/invariant-box searches and the limited net explanatory coverage
remain visible in the linked records.

## Keeping the knowledge connected next time

After a bounded investigation, reconcile the central bibliography, canonical
occurrences, resolution/Lean evidence, derived follow-ups and planning records.
Deduplicate by mathematical content, not title. Add source-authored questions only
after reading their passages, and keep research leads and our proposed next steps
distinct. Regenerate the reports and validate the explicit cohort delta.
Historical experiment manifests continue to refer to their original publication
revisions; this documentation update does not rewrite frozen scientific inputs.
