# Stage 3: cold-reader review and acceptance

## Review order

Use an independent person or fresh reviewer context, separate from research and
writing. First supply only the current main PDF and these review criteria. Inspect
the rendered pages, not just extracted text. Record the cold pass before opening
the packet, prior reviews, source or research notes. Then supply the evidence
packet, writer manifest and sources to check all headline components, claim
coverage, signed contrasts, uncertainty and substantive limitations. No research
conversation or previous manuscript is needed. Preserve a rejected review as
provenance; do not copy its passing claims onto a changed PDF.

A new record uses `contract_version: 2` in the existing delivery JSON. Add
`packet: {path, sha256}` and `writer_manifest: {path, sha256}` (both committed
at artifact_revision). Retain existing primary/source, build_inputs and remote
verification fields. `review` retains PDF/source/build-input hashes and reviewer.
Add `packet_sha256`, `writer_manifest_sha256`, and:

```
"editorial": {
  "verdict": "pass",
  "context": "fresh",
  "read_order": ["rendered_manuscript", "evidence_packet"],
  "checks": {
    "abstract_verdict_first": {"verdict": "pass", "findings": [
      {"page": 1, "location": "abstract, sentence 1", "finding": "Quote the opening and explain its composite verdict."}]},
    ...
  },
  "phrase_dispositions": [{"cue_id": "...", "verdict": "pass", "reason": "..."}]
}
```

Require the same explicit pass/fail findings structure for all seven checks:
`abstract_verdict_first`, `introduction_verdict_first`, `standalone_prose`,
`headline_fidelity`, `claim_coverage`, `limitations_preserved`,
`scientific_process_distinction`. Each needs positive PDF page numbers, specific
locations and observations, including at least one finding even on pass. Check
both the abstract and introduction independently. For a missing item, cite the
page/section where it should appear. A summary "looks good" is inadequate.
`editorial.verdict` must be `fail` if any check fails. Missing checks block delivery.
Do not set pass merely because hashes, numerical tests or citation checks pass.

From the study root, run `python3 /path/to/skill/scripts/stage_checks.py cues PAPER.tex` for narrow phrase cues with stable IDs and
source line numbers; review every flagged occurrence in its rendered context.
Record each ID once in `phrase_dispositions`, with pass only for an explained
legitimate usage. A failing disposition blocks delivery. This scanner reads the
main source and declared text build inputs during delivery; source lines are not
PDF page evidence. It cannot parse all prose or detect every buried verdict.
Read the entire PDF, including tables, captions and appendices. Absence of cues
is not a standalone-prose pass. Simple words such as "previous" are not banned.

After edits, rerender and independently re-review exact final bytes. New hashes
invalidate the old review, including included table/figure/bibliography hashes.
Reviewers must compare all claim-map entries and limitations against the packet;
the checker verifies mapping keys and hashes, not semantic fidelity or honesty.
An independent agent is an editorial aid, not a replacement for human scientific
and editorial judgment. Human review is still needed before relying on the paper.

## Migration and testing

Default delivery checks require version 2. Historical records lacking this
contract fail current acceptance. Version 2 also requires the
[final-PDF link inventory and review](pdf-link-review.md). For reproducibility audits only, use
`delivery_check.py RECORD --root STUDY_ROOT --legacy-audit`: it runs the historical
structural checks and reports `current_acceptance: false`, even if they pass.
Do not edit historical study artifacts or add fictional fresh-context attestations.
To deliver a newly revised paper, build a complete packet and real writer/reviewer
records against the new bytes. Preserve old provenance separately.

Run the helper suite from the repository root:
`python3 -m unittest discover -s .agents/skills/replication-paper/tests -v`.
Negative fixtures include correct numbers with a buried verdict and a verdict-first
abstract that depends on a previous draft. Those must fail editorial acceptance;
word searches alone cannot decide their scientific meaning. Historical helper
APIs remain available through an explicit legacy audit, not a default bypass.
