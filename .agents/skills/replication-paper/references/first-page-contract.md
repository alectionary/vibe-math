# First-page source and effect-magnitude contract

- [Scientific requirements](#scientific-requirements)
- [Research packet](#research-packet)
- [Writer manifest](#writer-manifest)
- [Mapped existing tables](#mapped-existing-tables)
- [Checks and limits](#checks-and-limits)

## Scientific requirements

Identify and cite the replicated dissertation/article in the abstract, state its
original headline finding, and give our verdict and evidence. Preserve a readable
verdict-first opening, for example: "We partly replicated Smith's (2020) finding
that A reduces error relative to B: ...". A source name without the reported finding,
or a verdict without identifying its source, is incomplete. Verify author, year,
title, institution/venue and source locator against the actual work; do not invent
metadata. Cover every component of a composite headline and retain evidence limits.

Center the body of the opening results table on the page, including the top
and bottom rules. Keep the caption and notes readable in the text block.
The delivery check measures the outer horizontal rules in the declared
table region of the exact PDF when using the shared academic title template.

On page 1, add an **Effect magnitude** column alongside the published and our
signed effect values. Its labels are `smaller`, `same`, `larger`, or `not established`.
Specify the scientific contrast/estimand, units, positive meaning, and tolerance.
Magnitude compares absolute sizes of the SAME signed scientific contrast, never
ours-minus-source reproduction error or conveniently selected raw parameters.
For ratios, define a scientifically justified contrast relative to its null (e.g.
ratio minus one) before applying this comparison. Retain the raw results elsewhere.

Display direction separately: `same direction`, `reversed direction`,
`zero vs nonzero`, or `not established`. Equal absolute sizes with opposite signs
are `same` magnitude AND `reversed direction`, not a successful replication.
Unresolved or unstable estimates require `not established` magnitude, even if
available point estimates happen to agree. Preserve a diagnostic direction or
reversal when finite signed estimates exist; do not claim inferential support
for it. Use `not established` direction only when the signed comparison cannot
be computed. Do not round away a nonzero effect's sign. An effect within its
row's tolerance of zero counts as zero for direction (its sign carries no
information), so such a row is `zero vs nonzero` against a clearly nonzero one.
A published value read from a figure uses `kind: "measurement"`: the value is
the recorded reading error itself (unrounded, or rounded down), with
`source_file` naming where it is recorded; never round a margin up so that a
label changes, and never call a margin `prespecified` unless the plan set it
before the results were seen. Define each contrast against its null (for a rejection rate, minus the nominal
level), so that zero means "no effect".

Define a nonnegative tolerance using source rounding precision (half a unit in
its last printed decimal, summing the input bounds for a derived contrast) or
a prespecified, scientifically justified margin.
Do not silently choose a margin after looking at results. These magnitude labels
are descriptive point-estimate comparisons, separate from uncertainty-supported
inference. Include the caption wording "Descriptive point estimates; not equivalence."
(or another note explicitly saying "point estimates" and "not equivalence").
Nonsignificance or overlapping intervals cannot establish equivalence. Preserve
uncertainty/multiplicity qualifications and explain missing source uncertainty.

## Research packet

Add `replicated_work` to `evidence-packet.json` with string fields `kind` (`article`
or `dissertation`), `authors`, `year`, `title`, `institution_or_venue`, `identifier`
(DOI/stable source URL), `verification_locator`, and nonempty `artifact_ids` pointing
to its hashed evidence. Keep original headline statements in the existing claims.

Add `headline_effects`, covering every headline claim. A resolved row is:

```json
{
  "id": "E1", "claim_id": "C1", "contrast_index": 0,
  "estimand": "B minus A", "units": "percent",
  "positive_means": "A has lower error",
  "published_effect": 13.184, "ours_effect": 13.208,
  "estimate_status": "resolved", "display_decimals": 3,
  "tolerance": {"kind": "rounding", "value": 0.0005,
    "decimals": 3, "basis": "Half the source's printed unit"},
  "magnitude": "larger", "direction": "same direction",
  "interpretation": "descriptive point estimates; not equivalence",
  "uncertainty_statement": "Original simulation error is unknown."
}
```

`contrast_index` selects the zero-based `claims[claim_id].contrasts` entry. Its
scientific definition, units, positive meaning and published/ours values must
match exactly. A claim may have multiple effect rows/conditions. For `unresolved`
or `unstable` estimates, supply `unresolved_reason`; use null values where absent,
`contrast_index: null` when no contrast can be computed, and `not established`
for magnitude. Preserve computed diagnostic direction when finite estimates
exist; otherwise its direction is also `not established`. A nonnumeric/theoretical headline uses the explicit applicability contract below.
Never invent a tolerance or scalar effect to satisfy the validator. Scalar rows
with a justified tolerance retain it even when the estimate is unavailable.
A prespecified tolerance uses `kind: "prespecified"`, `value`, and `basis`.
For a derived linear contrast, a rounding tolerance may replace `decimals` with
`components: [{"decimals": 1, "weight": 1}, {"decimals": 1, "weight": 1}]`.
`weight` is the absolute coefficient of that input; the tolerance must equal the
sum of the weighted half-unit rounding bounds. Two endpoints rounded to 0.1 thus
allow 0.10 for their difference. The basis must explain the input precisions and
weights; the reviewer verifies the derivation and source precision.

## Writer manifest

Add `first_page` to the existing hash-bound writer manifest. Coordinates are
PDF points `[left, top, right, bottom]` on page 1, measured from the FINAL PDF;
example rectangles below are illustrative, not template coordinates to copy.

```json
{
  "first_page": {
    "abstract": {
      "bbox": [45, 45, 555, 225], "citation_key": "smith2020",
      "source_identification": "Smith (2020)", "source_citation": "Smith (2020)",
      "original_finding": "reported lower error for A",
      "verdict_evidence": "We partly replicated the headline",
      "claim_ids": ["C1"]
    },
    "table": {
      "bbox": [45, 235, 555, 320], "magnitude_heading": "Effect magnitude",
      "comparison_note": "Descriptive point estimates; not equivalence.",
      "rows": [{"effect_id": "E1", "bbox": [45, 255, 555, 275],
        "estimand_text": "B minus A", "tolerance_text": "tolerance 0.0005"}]
    }
  }
}
```

Use exact rendered excerpts. The original-finding and verdict/evidence excerpts must also occur as ordinary
prose in the LaTeX abstract;
choose excerpts without math macros or embedded citations. The citation key must
occur in an abstract `cite`, `citep`, `citet`, `parencite` or `textcite` command.
Numeric citation text such as `[1]` is allowed in `source_citation`; the separate
identification excerpt names the replicated work and may be generated by a
citation macro. Both are checked in the rendered abstract region. The reviewer verifies that the citation key identifies the correct work.

Table rows must contain, in order: published signed effect, ours, magnitude label,
and direction label. Include the estimand label in each row; units and its declared
numeric tolerance may be in the row or caption within the table region. Use fixed
`display_decimals` with half-up rounding, with ungrouped bare numeric cells
(no arithmetic expressions or attached intervals between these columns); absent scalar comparison values display `not established`. This convention
never applies to the separate Published/Ours finding cells: preserve their
source statements, results or specific audited absence explanations.
Row regions must not overlap. Match all effect IDs once. The paper may include
other columns such as scientific verdict; a magnitude label does not replace it.

## Mapped existing tables

Do not rewrite a scientifically valid existing table just to match the simple
row order above. An explicit deterministic adapter can instead supply `display`
on each row. This validates individual cell rectangles (inside the page-1 table
and notes region), not arbitrary text elsewhere:

```json
{
  "display": {
    "form": "absolute_with_endpoints", "decimals": [1, 3],
    "magnitude_bbox": [389, 516, 471, 541],
    "direction_bbox": [334, 516, 387, 541],
    "values_bbox": [389, 527, 471, 541],
    "published_endpoints": {"values": [28.4, 6.5], "decimals": 1,
      "bbox": [169, 516, 232, 541]},
    "ours_endpoints": {"values": [27.407, 6.490], "decimals": 3,
      "bbox": [239, 516, 329, 541]}
  }
}
```

The magnitude cell begins with the computed label (optional colon or footnote
marker). Direction cells accept `Same`/`same direction`, `Reversed`/`reversed
direction`/`reversed point estimate`, `zero vs nonzero`, or `not established`.
For `absolute_with_endpoints`, the values cell shows the source/ours absolute
magnitudes, with an optional arrow or `to`; the endpoint cells show U / D. Their
subtracted signs must match the signed effects and their differences must agree
within the combined display-rounding bound. State D minus U and the units in the
caption. This prevents absolute magnitudes from hiding a sign reversal.

For `form: "signed"`, the values cell shows the signed effects with the two
specified display precisions; no endpoint fields are needed. A diagnostic signed
pair may appear in the table footnote for an unstable estimate, while its row
magnitude remains `not established`. If an effect is absent (null), only the
magnitude/direction cells are checked; its source bound or missing-value qualifier
still needs the source-fidelity review. A nonzero effect may not round to zero.

## Checks and limits

The existing `delivery_check.py RECORD --root STUDY` invokes `first_page.py`;
there is no second delivery command. `stage_checks.py packet` validates the new
research fields before handoff. Current acceptance fails when metadata/fields,
abstract citation, declared original-finding excerpt, table heading, signed values,
computed magnitude/direction or tolerance are absent or incoherent. It compares
source-abstract excerpts with text extracted from page-1 rectangles, so stale or
source-only edits cannot pass. Rebuild and refresh the usual source/PDF/manifest
hashes after editing. Historical `--legacy-audit` behavior is unchanged.

Add page-specific editorial passes for `abstract_source_fidelity` and
`effect_magnitude_fidelity` to the existing hash-bound review checks. Verify the
original headline, bibliographic identity, completeness of effect rows, estimand
meaning, tolerance rationale and uncertainty interpretation against source pages.
The deterministic checks verify declared text presence and arithmetic, not whether
an excerpt truly expresses the source's finding or a prespecified margin was
honestly chosen. They currently support a LaTeX `abstract` environment and
extractable PDF text; unsupported source layouts require implementing and testing
an equivalent extractor, not a silent bypass. Rendered layout/legibility and
scientific fidelity still require independent human/editorial judgment.


A study-native evidence schema may use an explicit deterministic adapter to map
its existing fields into this contract. The focused Python API is
`check_data(packet, writer, source_text, pdf_path, editorial_checks)`; it applies
the same first-page checks without imposing file names on the native artifacts.
An adapter must preserve values, units, status, tolerances, claim mappings and
actual review decisions, not infer a passing review or fabricate missing fields.
Record the input hashes and mapping, test it against the actual PDF, and report
this as a focused first-page result. It is not full delivery acceptance: the
existing delivery command still validates the complete hash-bound record.

## Comparison applicability (v2 extension)

Omitted `comparison_kind` means `scalar` and preserves the existing contract.
Choose applicability from the source claim, not the observed replication outcome.
Scientific claim status (`replicated`, nonreplication, blocked, etc. in the claim
inventory) is independent of whether a scalar magnitude exists. Do not demote a
headline, fabricate zero/average/max margins, or substitute precision for power.

Two explicit exceptions are supported in `headline_effects`:

- `comparison_kind: "nonscalar"`: a qualitative/theoretical proposition or a
  multicomponent parent with no scientifically justified scalar aggregate.
  Declare `comparison_kind: "nonscalar"` on the referenced source claim too.
  Set both effects, `contrast_index`, and `display_decimals` to null. Set
  `estimate_status: "unresolved"` (magnitude only), `magnitude` and `direction`
  to `"not established"`, and retain `unresolved_reason` and uncertainty.
  Use `tolerance: {"kind": "not_applicable", "value": null, "basis": "..."}`.
  Supply `applicability_reason`, `component_claim_ids` matching the source claim
  exactly (all references must exist), and `component_contrast_indices` listing
  every parent contrast index, or empty lists for a purely qualitative claim.
  The latter needs `contrast_not_applicable` on its source claim.
- `comparison_kind: "scalar_unestablished"`: a specified scalar contrast with
  no defensible source precision or prespecified
  margin. Keep its valid `contrast_index` and all available values. Use
  `tolerance: {"kind": "unestablished", "value": null, "basis": "..."}`,
  `applicability_reason`, unresolved magnitude status/reason and magnitude
  `"not established"`. Direction is computed for finite pairs, otherwise also
  `"not established"`. Display precision is required only for available values.
  Declare this missing-margin classification on the source claim (or its indexed
  contrast for a component). Finite pairs retain their computed signed direction
  and verified displayed values, while magnitude stays not established. Existing
  justified tolerances cannot be discarded to evade arithmetic; the reviewer
  must verify the stated absence of a defensible margin. No exception is inferred
  merely from nulls.

Nonscalar parents additionally supply `component_comparisons`, one ordinary
scalar or scalar_unestablished effect record for each parent contrast, with the
same parent claim_id, exact contrast_index and unique effect id. These records
are validated recursively against the retained source contrasts, including
numeric tolerances, magnitude and direction whenever applicable. They are
**evidence-only** and are not additional first-page rows. Thus a 108-cell grid
keeps all 108 comparisons without inventing a pooled gain or printing 108 rows.
A single numeric contrast cannot be disguised as a nonscalar parent.

In the writer table mapping, each exception row requires `applicability_text`
found verbatim (normalized) in both manuscript source and rendered row,
`estimand_text`, and `display` containing `magnitude_bbox` and `direction_bbox`.
Magnitude must show `not established`; direction preserves a finite scalar pair's
computed sign, otherwise it also shows `not established`. For one-sided scalar evidence,
also supply `values_bbox` and `form: "signed"`; show the available fixed-precision
value and `not established` for its missing counterpart in source/ours order.
No fabricated numeric tolerance or display precision is required for nulls.
The ordinary table note distinguishes point estimates from equivalence; prose
must make clear that this applies to scalar comparisons, not qualitative claims.

Any exception requires an additional editorial check `comparison_applicability`
with `verdict: "pass"` and nonempty page-1 findings (`page`, `location`, `finding`).
The hash-bound reviewer must assess source support for applicability, completeness
of parent/components, retained uncertainty and separation of claim verdict from
magnitude. Mechanical checks cannot establish that a semantic classification is
honest. Scalar comparison/arithmetic semantics and historical audit behavior are
unchanged. Current acceptance of scalar packets and adapters additionally
requires the mandatory finding and column mappings below. Old attempted nonscalar packets require explicit new mappings and
fresh review; do not backfill an attestation.

## Published and Ours finding cells (mandatory)

Keep three different things separate: **the published finding**, **our finding**,
and **their comparison**. A null scalar effect means that a scalar comparison is
undefined or unavailable. It does not mean a theorem, qualitative result,
multicomponent result, or finite replication result is absent. Never render a
known finding as a generic replication verdict in Published or Ours. This rule
also applies to scalar rows: raw findings/endpoints and signed effects may be
shown separately, with the existing arithmetic checks retained.

When several rows share one claim (two contrasts of the same headline), a row may carry its own `findings` with the same structure; its page-1 cells then match the row's text, so rows do not repeat each other.

Every headline claim requires `findings.published` and `findings.ours`:

```json
{
  "findings": {
    "published": {
      "text": "Corrects errors through (d-1)/2 under the stated oracle assumptions",
      "state": "reported", "artifact_ids": ["thesis"],
      "locator": "Chapter 3, Theorem 1, PDF page 44",
      "source_excerpt": "decoded from error of weight up to (d-1)/2",
      "page_locator": "PDF page 44",
      "claim_type": "theorem",
      "conditions": "Any [[n,k,d]] hypergraph product; classical decoder oracles for the seed matrices and their transposes",
      "component_claim_ids": [], "component_contrast_indices": []
    },
    "ours": {
      "text": "1061 guaranteed-range finite errors passed; universal theorem not reproved",
      "state": "observed", "artifact_ids": ["exact-results"],
      "locator": "cases[*].adversarial_errors; finite checks only",
      "component_claim_ids": [], "component_contrast_indices": []
    }
  }
}
```

`artifact_ids` must be nonempty references to this claim's hashed packet artifacts.
Each `locator` identifies the relevant passage, result field, or acquisition
record. The concise `text` must be independently checked against that evidence;
it need not reproduce the full claim value verbatim. Preserve theorem conditions,
conjectural versus proved status, estimator and experiment conditions, and limits.

A Published finding with state `reported` also carries:

- `source_excerpt`: a short verbatim passage from the source, at least a few words, and not itself a placeholder.
- `page_locator`: a page locator containing a page cue and a number, such as `PDF page 44` or `pp. 70-71`.
- `claim_type`: one of `theorem`, `numerical estimate`, `conjecture`, `open question`, or `other`.
- `conditions`: the assumptions and conditions under which that reported finding holds.

When bundled source text exists, mark that packet artifact with `"role": "bundled_source"`. The normalized excerpt must then occur in that text. Normalization collapses whitespace and compatible dashes; it does not interpret notation. If no bundled source is marked, the excerpt is still required and the occurrence check is skipped.

Status wording must not contradict the recorded type. A `conjecture` or `open question` must not be called proved, and wording that describes a finite check must not call that check a universal proof. Negated wording such as "not proved" or "no general proof" is consistent with those limits. The check looks at the finding text, its conditions, optional `status_wording`, and manuscript sentences that contain the finding text.

States are `reported` or `not_reported` for Published, and `observed`,
`not_obtained` or `not_assessed` for Ours. An absent state requires `reason`, a
null corresponding claim `published.value` or `ours.value`, and its explicit
`unavailable_reason`. A `not_reported` Published finding also requires `search`
with `corpus` (what was searched), `where` (the bounded location), and `terms`
(a string or a nonempty list). A locator by itself does not document that search.
Absence is audited evidence, never inferred from a null
`published_effect` or `ours_effect`. A known qualitative parent and a genuinely
unreported statistic must remain distinct claims/components. For example,
"Power benefit asserted; no numerical power experiment reported" preserves the
qualitative claim; a numeric power component may separately be `not_reported`.
Generic full-cell placeholders fail even when reworded, including differences of
case, whitespace, and punctuation: "Not established here.", "No finding.", and
"nothing reported" are placeholders. The match ignores short filler words and
rejects a cell whose remaining tokens are only verdict vocabulary. It is not a
list of synonyms for the scientific content. A sentence that names a specific
result, such as "No numerical power difference reported.", is not a placeholder.
These checks bind declared excerpts, locators, types, and conditions to the
record. They do not prove what the sentence means. Row-by-row review of every
Published and Ours cell remains mandatory.

For each side, retain `component_claim_ids` exactly from the claim (or `[]`) and
`component_contrast_indices` containing every index in the claim's `contrasts`
(or `[]`). These bindings make omissions detectable; source-by-source review must
still judge whether the summary faithfully covers all components. A numeric
family must not hide its known estimates behind "no pooled scalar".

Each mapped first-page row additionally requires `published_text`,
`published_bbox`, `ours_text`, and `ours_bbox`. Text must match the corresponding
claim finding and exactly match normalized text extracted from its own rendered
cell. Both rectangles must lie wholly in that row and table, must not overlap,
and Published must be left of Ours. Do not point a cell rectangle at a caption,
another row, or repeated text elsewhere. Comparison labels are checked separately.
This validation always runs, including nonscalar rows with both effects null;
legacy records lacking finding evidence do not pass current acceptance.

Require a fresh `finding_attribution` editorial check with explicit page-1
findings. Review every Published and Ours cell against its own cited evidence,
including all components, and record any missing or unsupported finding as a
failure. Correct cell geometry, known words, hashes, and arithmetic do not
establish semantic fidelity. Preserve historical records; never retrofit a pass.

Bind cell identity to actual table headers, not just left-to-right order. The
`first_page.table` mapping must also declare `published_column_bbox`,
`ours_column_bbox`, `published_heading_bbox`, `ours_heading_bbox`,
`published_heading` ("Published" or "Published finding"), and `ours_heading`
("Ours" or "Our finding"). Each header rectangle spans exactly its declared
column's horizontal extent and extracts exactly its heading before all data rows. Columns lie inside
the table, are ordered and do not overlap. Each finding cell must be inside its
own headed column as well as its row. Mapping duplicate text in a claim,
comparison, caption or neighboring column cannot satisfy this contract.
