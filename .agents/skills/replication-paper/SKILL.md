---
name: replication-paper
description: "Replicate a dissertation or published result using a complete evidence handoff, standalone verdict-first manuscript, independent cold-reader review, and verified delivery. Use for claim inventories, numerical comparisons, uncertainty, availability audits, replication papers and authorized PRs or announcements."
---

# Replication paper

Work in this order. Load only the current stage's instructions and required
artifacts. Apply the [first-page contract](references/first-page-contract.md)
for source identification, original findings and effect-magnitude comparisons.
For a dissertation, cover the whole dissertation: inventory every
substantive original claim, including theory, empirical results, simulations,
negative results and unavailable inputs. Do not substitute a convenient table
for its research questions. Complete coverage means every claim is accounted
for, not that every claim replicated. Use
[open-question research](../open-question-research/SKILL.md) for proof methods
when needed; keep its research chronology out of the manuscript.

## 1. Research and evidence handoff

Read [evidence handoff](references/evidence-handoff.md) and
[research methods](references/research.md). Produce `evidence-packet.json` and
its named sources/results before drafting. Validate the packet with
`scripts/stage_checks.py packet PACKET --root STUDY_ROOT`. Reconcile the inventory
against every dissertation chapter and appendix, not just completed experiments.
Scientific unknowns and justified feasibility stops are legitimate outputs;
concealing them or treating them as successful replications is not.

## 2. Standalone manuscript

Read [writer stage](references/writer-stage.md) and
[manuscript requirements](references/manuscript.md). Give a fresh writer only the
validated packet, relevant source/evidence files, approved template, and these
writing instructions. Do not forward research chat, previous manuscript drafts,
progress reports, or permission/release history. Write a standalone paper whose
abstract and introduction begin with the headline verdict, published-versus-ours
results, then evidence limits and consequential reversals.

## 3. Cold-reader review and acceptance

Read [editorial review](references/editorial-review.md). An independent reviewer
first reads the current rendered main paper without the evidence packet or
research conversation, records page-specific editorial judgments, then checks
claims against the packet and sources. Explicit failing or missing judgments
block acceptance even when hashes and numbers are correct. Fix and rebuild,
then obtain review bound to the exact new PDF, source and build inputs.

## 4. Authorized delivery

Read [delivery requirements](references/delivery.md) for template, citations,
remote-byte verification, PR and announcement rules. Apply the mandatory
[final-PDF link audit](references/pdf-link-review.md): generate and independently
review an annotation inventory, then re-extract destinations during delivery
acceptance. Master navigation and commit-pinned review delivery are separate.
Run the numerical and
citation helpers appropriate to the study, plus `scripts/delivery_check.py
RECORD.json --root STUDY_ROOT`. Use delivery contract version 2; see the editorial
reference for migration of historical records. Helper passes establish neither
scientific truth nor prose quality. Do not claim delivery complete without the
independent rendered review. Publication actions still require authorization.

## Portable phase boundaries

These stages use files and ordinary commands on Dot, Grokbot, or another host;
no named product tool is required. Where available, start separate writer and
reviewer contexts with only their allowlisted inputs. Otherwise prepare the
handoffs and use a separate session or independent person. A same-context pass
may improve a draft but must be labeled as such: never certify it as independent
or hide that the independent review is pending. Record actual context exposure,
not an assumed reset. Do not explain failures as context-window exhaustion
without evidence. Return scientific questions to the research stage; do not
quietly invent missing evidence while writing.

## Skill maintenance

Install `scripts/requirements.txt` for final-PDF annotation extraction.
Run `python3 -m unittest discover -s .agents/skills/replication-paper/tests -v`
from the repository root and the skill-creator `scripts/quick_validate.py` with
PyYAML. Test rejected as well as accepted evidence/review records. Phrase scans
are review cues, never a word ban or a certification that prose stands alone.
Do not retrofit passing attestations into historical study artifacts.
