# Stage 1: complete evidence handoff

Read the research reference for domain checks. Freeze `evidence-packet.json`
with `schema_version: 1`, using the contract below. Paths are relative to the
study root; retain reproducible files there. Validate with `stage_checks.py`.
Include the verified `replicated_work` metadata and signed `headline_effects`
rows defined by the [first-page contract](first-page-contract.md).
The validator checks declared coverage and file hashes, not whether an author
has omitted a claim. A source-reading inventory audit is mandatory.

## Packet contract

- `scope`: `whole_dissertation`; `dissertation`: citation and stable source locator.
- `artifacts`: nonempty list of `{id, path, sha256}` for source pages, results,
  methods, availability records and reproduction instructions. Include the
  dissertation itself when available; otherwise document the access limit.
- `sections`: every chapter and appendix as `{id, locator, claim_ids,
  exclusion_reason}`. Empty claim lists require a scientific reason (e.g.,
  bibliography only), never "not investigated". Claims may span sections.
- `inventory_audit`: `{reviewer, source_artifact_ids, rationale}` stating how
  all substantive original claims were reconciled to those sections. Preserve
  inaccessible sections as unresolved claims with exact source/access limits.
- `claims`: nonempty list of records below; use stable, unique IDs.
- `headline_order`: ordered IDs of all headline claims, with failed or unresolved
  components visible; `synthesis`: the composite verdict and its evidence limits.
  Do not average away a missed headline with many supporting matches.
- `limitations`: nonempty list (or an explicit statement that none was identified)
  of scientific limits, each linked to claim IDs in its text. Preserve negative
  results, untested explanations, failed draws, unknown original counts, shared
  inputs, reconstruction scope, and unavailability. Do not include retry logs.

Each claim requires:

| Field | Content |
| --- | --- |
| `id`, `statement`, `level` | Original scientific claim; level `headline` or `supporting`. Split composite claims. |
| `source_locator`, `artifact_ids` | Page/table/equation/figure and hashed source/result files. |
| `published`, `ours` | Objects `{value, units, unavailable_reason}`; value is a number or an exact textual theoretical result. Null needs an explicit reason. Never invent missing values. |
| `conditions` | Populations, models, sample sizes and grid cells; identify expected and completed coverage. |
| `contrasts` | List of `{definition, units, positive_means, published, ours}` with signed scientific effects. Values may be null with `unavailable_reason`. Explain no contrast in `contrast_not_applicable` when empty. Ours-minus-source deviations are separate `reproduction_deviation` text. |
| `methods`, `uncertainty`, `multiplicity` | Procedure/comparability, tolerances, uncertainty components, family sizes and corrections, independence assumptions and exploratory vs confirmatory choices; explicit reasons if inapplicable. |
| `status`, `status_reason` | `replicated`, `partly_replicated`, `not_replicated`, `not_established`, or `blocked`, with evidence. Nonreplication needs a feasible comparable test; unavailable or insufficient evidence is not failure to replicate. |
| `numerical`, `reconstruction_scope` | Separate rounding agreement and reconstruction assessment, including inapplicable/withheld reasons. These do not determine scientific success alone. |
| `limitations`, `stopping` | Nonempty text/list of limits; stopping object `{reason, attempted, untested, resource_basis, next_evidence}`. Record null results and budgets; for completed claims state why further work is unnecessary. |

For resource/feasibility stops, estimate cost, describe actual budget and feasible
subset, say why further work cannot change or cannot yet establish the conclusion,
and name the evidence that could resolve it. Do not launch unlimited computation
or fabricate a test to fill the inventory. Account for every arm even when blocked.
Distinguish a blocked action from scientific evidence. Operational logs stay in
provenance; the packet carries only their scientific consequence.

Commit/freeze the packet before writer handoff and record its SHA-256 in the
writer manifest. If research changes, issue a new packet hash and repeat writing
and review for affected claims. Never silently overwrite the primary result.

For nonscalar headlines or unresolved scalar comparisons without a justified
tolerance, follow the explicit comparison-applicability extension in [first-page contract](first-page-contract.md). Preserve all component evidence and keep the scientific claim verdict separate
from an unestablished scalar magnitude. Never invent a numeric margin.
