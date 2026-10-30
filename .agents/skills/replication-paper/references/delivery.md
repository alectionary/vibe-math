# Delivery reference

- [Manuscript and delivery acceptance](#manuscript-and-delivery-acceptance)
- [Pull request](#pull-request)
- [What this is](#what-this-is)
- [Question](#question)
- [What ties together](#what-ties-together)
- [Findings](#findings)
- [Map of the note](#map-of-the-note)
- [How to check it](#how-to-check-it)
- [Open issues and next steps](#open-issues-and-next-steps)
- [Announcement post](#announcement-post)

Read only for the corresponding stage in [SKILL.md](../SKILL.md).

## Manuscript and delivery acceptance

Reuse the latest user-approved manuscript template. Record its path and revision;
compare the rendered main paper against it. The bundled
[approved preamble](../assets/approved-preamble.tex) preserves the Kupzyk layout.
Keep semantic subject-specific adaptations separate from style changes. Record
and justify necessary deviations; do not silently invent a new layout.

Before declaring delivery complete, independently review the rendered **main
manuscript**, not merely its source, helper tests, or appendix. Check first-page
findings, tables, scalable fonts, citations, copied compliance and availability
rows, filename links, and the distinction between findings and execution details.
Record reviewer, PDF hash, source hash, and evidence for each review item.
Passing helper tests never establishes manuscript compliance. Apply the
[final-PDF link audit](pdf-link-review.md); a nonempty links note does not
replace extraction and validation of the actual URI annotations.

When a draft PR is authorized, put an accessible current-commit primary PDF link
first, followed by editable source/bibliography and linked evidence. Fetch the
remote primary PDF and evidence, compare their hashes with local artifacts, and
record the URLs and downloaded paths. An appendix never substitutes for the
main paper. If a transfer channel fails, use another authorized channel; otherwise
report delivery incomplete. Do not request publication approval again when given.
Run [delivery_check.py](../scripts/delivery_check.py) on the delivery record using
`python3 scripts/delivery_check.py RECORD.json --root STUDY_ROOT` from this skill.
The checker validates files/hashes and required review records, not scientific
truth or whether a reviewer actually read a page. A fresh independent manual
review remains required. Manually verify the declared build inputs are complete,
all URLs belong to the intended repository, and the reproduction revision contains
the documented code and inputs. Revalidate after any manuscript/PDF change.

Record the historical run baseline separately from the immutable revision that
actually contains reproducible code and inputs. Preserve prior analysis when
adding confirmation or diagnostics. Never silently replace the primary result.
For each independent check, name shared inputs, engine, graph, and implementation;
qualify partial independence instead of claiming a second end-to-end replication.
Justify a tolerance by source precision or scientific consequences, and distinguish
it from sampling uncertainty. Label margins selected after inspection exploratory;
use direct resource/performance tradeoffs when no equivalence margin is justified.

## Pull request

Write the description for a reader who has not read the paper. Use the same
prose rules as the note. No language-model authorship statement, and no
opening about how the files were produced.

```markdown
## What this is

One sentence on the paper being replicated and where the note lives.

## Question

The research question, in plain words, and what the original work reported
or concluded. Do not write "the author claims".

## What ties together

Which part is the original work, which part is ours, and which numbers are
taken from other papers.

## Findings

Our verdict on the headline first, with the published-versus-ours numbers,
then what our evidence does not establish, then any reversal with both sets
of numbers. One sentence per headline result. Name any probability caveat,
including an independence assumption.

## Map of the note

One sentence per section, in the note's order: the question that section
answers and its answer.

## How to check it

The README commands that regenerate the table, the crops, and the proofs.
Say which inputs are not in git.

## Open issues and next steps

The stopping statement for what is still unresolved: what was tried, what
each attempt gave, and the next check. Link the acquisition or help issue
when one is open.
```

## Announcement post

When an X announcement is requested, draft one substantive single post, not a
thread or an artificially terse teaser. Use clear, natural prose, no hype and no
model-authorship statement. Give the findings enough room to be understood;
there is no fixed word quota. Drafting never authorizes posting.

The post has four parts, in this order:

1. Identify the dissertation author, full title, institutional year, institution
   and verified adviser(s). Verify names and roles from the source; do not guess.
   If these facts are unresolved, mark the draft incomplete rather than inventing
   them. State dissertation-wide coverage and its limits accurately. Inventory coverage
   never establishes universal replication success. The bounded historical example
   below is not permission to narrow a new dissertation study.
2. Give the composite headline verdict and published-versus-replicated numbers,
   with unambiguous scientific direction. Distinguish exact resource/result
   agreement from performance or other claims not established. Supporting checks
   do not substitute for an unreplicated headline component.
3. Explain the relevant uncertainty and multiplicity families in plain language.
   Separate our sampling error, extraction bounds and unknown original sampling
   uncertainty. Mention material point-estimate reversals and unresolved inputs;
   do not infer a statistically established source ranking from missing counts,
   establish equivalence from overlapping bands, or allege author error.
4. Close with the published **main-paper PDF**, using the GitHub page URL below.
   A repository folder, source appendix or editable source is not that deliverable.

### Public announcement URL

Use exactly this public-link form:

```text
https://github.com/<owner>/<repo>/blob/master/<path>/<descriptive_filename>.pdf
```

Use the actual verified PDF path on master. Do not substitute
`raw.githubusercontent.com`, a working branch, a commit-pinned review URL,
private/sandbox URLs, download URLs, query parameters or fragments. Confirm the
GitHub PDF page resolves to the intended published main paper before describing
it as available. A successful format check alone is not publication verification.
If the paper is not merged, prepare the draft with the intended master PDF link
and explicitly mark it not yet available; do not claim publication.

This rule applies only to the public announcement. Preserve immutable commit
links and downloaded-byte checks for pre-merge artifact review; raw URLs remain
appropriate for that internal verification. Use
[announcement_url.py](../scripts/announcement_url.py) to check the announcement URL
against the known repository and PDF path; manually verify destination, current
publication status, adviser facts and scientific accuracy.

### Substantive example draft

This Higgott example illustrates the content and approved closing URL. The
supervisors are verified in the institutional dissertation acknowledgments,
printed page 6 ([dissertation](https://discovery.ucl.ac.uk/id/eprint/10186408/)).
It is not permission to post. Adapt scope, numbers and uncertainty to the actual study.

```text
Oscar Higgott's Practical and Efficient Quantum Error Correction (Ph.D. dissertation, University College London, institutional year 2024; supervisors Nikolas Breuckmann and Dan Browne) examines quantum error correction. We replicated a bounded small-code comparison in Chapter 7, principally Figure 7.14a, rather than the whole dissertation.

We partly replicated the headline. The Bolza memory protects four logical qubits with 16 rather than 96 physical qubits—an exact sixfold saving—but comparable failure-rate performance is not established. At physical error probability .001, the published figure gives Bolza .13390 and four planar copies .12977; our fresh estimates are .13772 and .12925. Bolza therefore has higher estimated failure risk in both comparisons at this point.

Our reconstructed difference is .00847 with a simultaneous half-width .00135 across five selected contrasts. Six of ten source comparisons exceed Bonferroni-adjusted conditional bands based on our sampling uncertainty plus extraction bounds. Original simulation counts are unavailable, so these are not complete two-sample uncertainty comparisons or evidence of author error. At .01, the source point estimates put Bolza below planar (.73440 versus .74158), while ours put it above (.74941 versus .74040); the source ranking is not statistically established. The exact production configuration and published logical-path correspondence remain unresolved. The result supports a resource/performance tradeoff, not established equivalence.

Replication paper: https://github.com/alectionary/vibe-math/blob/master/formalization/higgott-quantum-decoding/paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf
```
