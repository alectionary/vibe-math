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
be computed. Do not round away a nonzero effect's sign.

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
exist; otherwise its direction is also `not established`. A nonnumeric/theoretical headline must be accounted for this way
with an explicit reason, not forced into a numerical magnitude claim. Keep a
justified comparison tolerance even when the test cannot yet be performed.
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
(no arithmetic expressions or attached intervals between these columns); absent values display `not established`.
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
