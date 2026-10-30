# Evidence packet assembly (not scientific adjudication)

`build_evidence_packet.py` consumes the whole-dissertation source audit and an
explicit scientific-adjudication file. It does not inspect production exports,
infer a verdict, certify a reviewer, choose a tolerance, or generate missing
numbers. A final packet awaits terminal results and root scientific adjudication.
Source specifications own the claim statements, roles, locators, published values,
conditions, chapter/appendix inventory and actual source audit. The adapter joins
adjudications by the exact claim-ID set and passes the result through the read-only
v2 `stage_checks.py` and `first_page.py` contracts. Structural validity does not
certify that a source inventory is complete or that a claimed prespecification is
historically true.

```sh
python3 handoff/build_evidence_packet.py \
  --root . --spec handoff/claim-specification.json \
  --adjudication handoff/scientific-adjudication.json \
  --validator /tmp/schwabe-skill-v2/.agents/skills/replication-paper/scripts/stage_checks.py \
  --output handoff/evidence-packet.json --dry-run
```

Remove `--dry-run` only after scientific adjudication. Output and adjacent
`.assembly.json` manifest must not exist: the helper refuses overwrites. The
manifest records specification/adjudication/helper/validator hashes, complete
packet hash, explicit adjudicator attribution, mapping and unresolved source
specification notes. No writer or editorial review attestation is created.
Hashes refer to actual bytes; no network fetch or publication takes place.

## Required root-supplied adjudication

Top-level fields:

- `claim_specification_sha256`: exact source-audit JSON hash.
- `adjudication`: actual `adjudicator`, `adjudicated_utc`, `basis`, `scope` strings.
  Do not fill these with a future reviewer or a claimed review that did not occur.
- `dissertation`: verified citation and stable locator string.
- `synthesis`, `limitations`: explicit composite conclusion and nonempty limits
  linked to claim IDs. Do not average away unresolved headline components.
- `artifacts`: additional `{id,path,sha256}` declarations (hash optional for newly
  selected files, computed by helper; declared hashes must match). Include result,
  methods, availability and runnable-reproduction evidence, with study-relative
  paths. IDs must be unique across the source specification and result list.
- `claims`: exactly one row for every source claim ID; no omission or new ID.
- `headline_effects`: explicit first-page-contract rows for every headline,
  including unresolved/theoretical rows. The helper validates supplied labels
  against the validator; it does not assign `resolved`, `same` or a tolerance.

Each claim adjudication must supply `id`, `ours` (`value`, `units`, explicit
`unavailable_reason` for null), `methods`, `uncertainty`, `multiplicity`, `status`,
`status_reason`, `numerical`, `reconstruction_scope`, `reproduction_deviation`,
nonempty `limitations`, nonempty `artifact_ids`, and `stopping` with `reason`,
`attempted`, `untested`, `resource_basis`, `next_evidence`. Source-owned fields
cannot be overridden. Refine a source ambiguity in the audited specification,
then hash/adjudicate that version rather than silently rewriting it here.

Supply `contrasts` in source order as `{contrast_index, ours, unavailable_reason}`.
An empty list is required when the source specification has no contrasts. The
source definition, units, positive meaning and published value are carried
verbatim; ours-minus-source remains a separate reproduction-deviation field.

Headline effects require the exact fields in `first-page-contract.md`. A
`prespecified` tolerance additionally requires `tolerance_provenance` with
`recorded_utc`, `prespecification_scope`, `basis` and nonempty `artifact_ids`.
This records actual evidence of when/for what the margin was chosen, not proof
that it was scientifically justified. The quarter-PDF-point figure extraction
bound is not printed source rounding. If supported by the frozen dated analysis
plan it may be explicitly adjudicated as a pre-production *descriptive extraction
margin*, with known-baseline scope disclosed. It is not an equivalence margin.
Unknown source estimand/procedure or unstable estimates must remain unresolved;
a diagnostic direction may still be available. A theorem's exact-identity zero
criterion must be explicitly justified for an inapplicable/nonnumeric comparison,
not invented as a measured effect. If no honest tolerance exists, report that
contract conflict: the current v2 validator requires a numeric tolerance even for
unresolved rows. The helper does not bypass that requirement.

The full dissertation may be declared at `source-local/thesis_I_Schwabe.pdf`
with `local_only: true` and acquisition/license metadata. The helper preserves
these metadata and hashes the existing file; it never copies or publishes it.
The source-local PDF must remain gitignored and excluded from redistribution.

## Integrity fixtures

`python3 handoff/test_evidence_packet.py` uses synthetic temporary data and the
read-only validator. It tests explicit unresolved values, source preservation,
missing/overridden claims, invented success with missing results, missing
contrasts/tolerances, unsupported prespecification and stale input/artifact hashes.
Synthetic reviewer labels are explicitly fixtures and are never written into
an actual study packet. No baseline or production outcomes are read.

## Source hierarchy and non-scalar results

Every source-owned claim field is copied, including parent/component links,
section IDs, source uncertainty and multiplicity, and scientific relations.
Structured source conditions are retained as `source_conditions` and encoded
losslessly as deterministic JSON text in the contract's textual `conditions`.
All source contrasts (including every grid cell, condition and tolerance) remain
in `source_contrasts`; corresponding packet contrasts preserve these fields and
add only explicitly adjudicated `ours` values. Packet-level source ambiguities
and explicit limits are preserved. Adjudications cannot overwrite relation keys.
A qualitative whole-grid headline has no automatically chosen scalar: retain its
exact textual published proposition, complete component links and all grid
contrasts. An unresolved headline effect must honestly explain why no unique
scalar exists. Neither grid averaging nor a convenient-cell substitution is
performed by this helper.
