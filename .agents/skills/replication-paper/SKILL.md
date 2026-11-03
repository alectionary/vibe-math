---
name: replication-paper
description: "Replicate a dissertation or published result using a committed replication plan, a complete evidence handoff, standalone verdict-first manuscript, independent cold-reader review, and verified delivery. Use for full-design replications, claim inventories, numerical comparisons, uncertainty, availability audits, replication papers and authorized PRs or announcements."
---

# Replication paper

Work in this order. Load only the current stage's instructions and required
artifacts. Apply the [first-page contract](references/first-page-contract.md)
for source identification, original findings and effect-magnitude comparisons.
Keep Published, Ours, and comparison separate. Every headline needs evidence-linked
finding text in its own rendered Published/Ours cells, even when scalar effects
are null. Require the `finding_attribution` source-by-source review; a null
comparison is never permission to erase a known finding.
For a dissertation, cover the whole dissertation: inventory every
substantive original claim, including theory, empirical results, simulations,
negative results and unavailable inputs. Do not substitute a convenient table
for its research questions. Complete coverage means every claim is accounted
for, not that every claim replicated. Follow the full-design rule and commit
the replication plan before any analysis. Use
[open-question research](../open-question-research/SKILL.md) for proof methods
when needed; keep its research chronology out of the manuscript.

## Full design

Replicate the dissertation's full design whenever that work is feasible:
every condition, arm, table, and analysis. A subset or a reduced replication
count is a last resort. It is allowed only with a written cost estimate, a
record of what was tried, the exact counts in the abstract and again in the
body (for example, `8 of 208`), and a headline verdict no stronger than the
runs that finished. Stopping at a headline-carrying subset is not a completed
replication. That stop has come up before, including Koziol (8 of 208
settings) and Chumney.

## Replication plan

The first research commit is `REPLICATION-PLAN.yaml` in the study directory.
That commit is the baseline, and it happens before any fit or simulation.
List the dissertation's substantive parts: studies and chapters, research
questions and hypotheses, analyses, simulation arms and conditions, and the
headline conclusions. Each part has a stable `id`, a `kind`, a short `label`,
and a `plan` note that says how we will replicate it.

Kinds are `study`, `chapter`, `research_question`, `hypothesis`, `analysis`,
`arm`, `condition`, and `headline`. Set `headline: true` on any part the
headline conclusion rests on, or use kind `headline`.

After the runs, set every part's `status` and `evidence`. Status is
`replicated`, `partly`, `mismatch`, `not_attempted`, or `input_unavailable`.
`evidence` points at the code or output that covers the part. Every status
except `replicated` needs a `reason`. `not_attempted` and `input_unavailable`
always need one. A grid records `design_count` in the first commit and
`run_count` when the run finishes. A run below the design count, including a
design count that was later edited downward, is a reduced run: the denominator
stays at the larger first-committed count, the status cannot be `replicated`,
and `subset_justification` supplies `cost_estimate` and `attempted`. The
abstract and the body both state that pair as `N of M`, such as `8 of 208`.

Removing a part, or changing its plan note, kind, label, or design count,
needs a recorded reason. A removal is `{id, reason}` under `removals`. The
done check diffs the current file against the first committed version and
fails when a part disappeared without that reason.

```yaml
schema_version: 1
dissertation: "Koziol (year). Title. Institution."
source_locator: "sources/dissertation.pdf"
parts:
  - id: ch4-grid
    kind: condition
    label: "Chapter 4 crossed settings"
    plan: "Replicate all 208 crossed settings."
    headline: true
    design_count: 208
    run_count: 208
    status: replicated
    evidence: "simulation/outputs/grid.csv"
removals: []
```

From the study root:

```sh
python3 .agents/skills/replication-paper/scripts/preflight.py done \
  --plan REPLICATION-PLAN.yaml --paper paper/paper.tex --root . \
  --analysis simulation/run.py
```

Exit 0 means the plan file is committed, every part has a status, a required
reason, and an evidence pointer, the plan was not silently shrunk, each
`--analysis` file was committed after the plan, and the paper's coverage
language is no stronger than the plan. Exit 2 is a failure. Repeat
`--analysis` for each analysis file. The engine probe is still the command
without `done`.

An optional caption hint can suggest parts the plan missed. The done check
does not read it, and the same text always produces the same list:

```sh
python3 .agents/skills/replication-paper/scripts/checks.py captions dissertation.txt
```

`pdftotext -layout` is used when the input is a PDF. Captions such as
`Table 3.2` and `Figure 4.1`, plus hypotheses, research questions, numbered
equations, and appendix tables, are hints only.

## Pre-done checklist

- [ ] `REPLICATION-PLAN.yaml` lists every substantive part and was committed before analysis.
- [ ] The full design was run, or the reduced run is a last resort with a cost estimate, what was tried, and exact `N of M` counts in the abstract and the body.
- [ ] The headline verdict is no stronger than the headline parts that were run.
- [ ] Every part has a status, an evidence pointer, and a reason when the status requires one.
- [ ] No part was removed or narrowed against the first commit without a recorded reason.
- [ ] `preflight.py done` exits 0.
- [ ] Optional caption hints were reviewed.

## 1. Research and evidence handoff

Read [evidence handoff](references/evidence-handoff.md) and
[research methods](references/research.md). Produce `evidence-packet.json` and
its named sources/results before drafting. Commit `REPLICATION-PLAN.yaml`
before the first fit or simulation, as specified under Replication plan.
Validate the packet with
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
citation helpers appropriate to the study, plus the [pre-done checklist](#pre-done-checklist)
and `scripts/delivery_check.py RECORD.json --root STUDY_ROOT`. Use delivery
contract version 2; see the editorial
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

For nonscalar headlines or unresolved scalar comparisons without a justified
tolerance, follow the explicit comparison-applicability extension in [first-page contract](references/first-page-contract.md). Preserve all component evidence and keep the scientific claim verdict separate
from an unestablished scalar magnitude. Never invent a numeric margin.
