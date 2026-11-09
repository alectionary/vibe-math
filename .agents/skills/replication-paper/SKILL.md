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

## Blockers go to the person

The source's own path is its software, its printed or archived code with its
seeds, its data, and its files. When any part of it cannot be run or obtained
here, that is a blocker, and blockers are the person's decision, not a choice
to make quietly. Tell them as soon as it happens, before adopting anything
else for that part: what is blocked, what the source path would give that an
alternative cannot, and the ways to unblock it. Those ways include their own
computer (its shell, or computer use for apps such as Terminal, run through a
`.command` file when typing is not allowed), the session's network settings,
another host, and a data-use agreement. Replications never contact the
original authors, so do not offer that. Keep working on parts that
do not depend on the answer, but do not build the blocked part on a fallback
until they choose.

Exact reproduction raises the stakes. Run `scripts/checks.py seeds SOURCE` on
the source text: seeded code means the source's own engine can regenerate its
data exactly, so an engine fallback loses exactness and must be put to the
person.

Missing data is not yet missing evidence. Before an `input_unavailable` for
data, search the source for sufficient statistics: means, SDs, correlation or
covariance matrices and Ns reproduce regression, path, SEM and many mediation
models exactly. Record the search as `sufficient_statistics: {found, what,
sufficient, why}` (for an input that is not data, `{applies: false, why}`). If
the printed statistics suffice, reproduce from them; the done check rejects
`input_unavailable` with `sufficient: true`. If they fall short, say exactly
which moments are missing.

Figures are evidence too. List every published quantity the paper compares
against under the plan's `published_evidence`: `id`, `location`, `quantity`,
`value_source` (`table`, `text`, `figure_digitized`, `figure_not_digitized`)
and `plotted_in` (the figures that plot it, `[]` if none), and `agreement`
(`agree`, `disagree` or `not_compared`). A quantity read
from prose while a figure plots it is rejected: digitize the figure with
`scripts/digitize.py` (vector markers straight from the PDF's drawing paths,
or colour blobs in a raster image, calibrated with `Axis` from ticks,
gridlines or reference lines) and record `digitized_file` and
`reading_error` in data units, or record `figure_not_digitized` with a
`reason` and `reported_to_person`. Every tolerance against a digitized value
includes its reading error. Every plan carries both.

Record each engine fallback as JSON: `name`, `kind` (`blocked` or `domain`),
`justification`, `independent_validation`, `source_path`,
`exact_reproduction` (`possible`, `not_possible`, `unknown`) with
`exact_reproduction_evidence`, and for `blocked` also `lost`,
`unblock_options: [{option, outcome}]` and `decision`. `decision.by: person`
needs `date`, `channel` and `summary`; `by: unreachable` needs a `reason` and is
accepted only when exact reproduction was not possible anyway. `preflight.py
done` finds every such record in the study by its content and rejects an
incomplete one. A plan part whose `limit_kind` is `input_unavailable` or
`not_run` needs `reported_to_person: {date, channel, summary}`. These fields
record that the question was asked; they do not replace asking it. Name every
engine fallback and blocked part near the top of the pull request description.

## The source and every figure and table in it

Other authors' PDFs and documents (the source, supplements, articles) are
never committed; `preflight.py done` fails on any such file tracked outside
`paper/`. What is committed is the evidence read from the source:
those values are scientific statements. With the verified PDF in hand:

1. Record `source_locator` and `source_sha256`.
2. Run `scripts/source_items.py inventory SOURCE.pdf --out source-inventory.json`
   and commit the record; name it in `source_inventory`. It lists every figure
   and table caption with its page, classifies figures as vector, raster or
   none, and flags tables that mention means, SDs or correlations.
3. Under `source_items` (start from `source_items.py stub SOURCE.pdf`), give
   every item `use: read` with a `data_file` that holds the values (a table
   transcribed, a figure digitized with `scripts/digitize.py`), or
   `use: excluded` with a specific `reason` and `reported_to_person`. A table
   flagged for moments also records `sufficient_statistics`.

`preflight.py done` checks this with or without the PDF. When the PDF is here,
it must match `source_sha256` and a fresh inventory must equal the committed
one. When it is not, the committed record stands in for it, and the study can
be complete. Every source figure or table the paper cites must exist in the
inventory.

Only when there is neither the PDF nor a committed inventory is evidence
missing. Never substitute another file. Record `source_missing: {fetch_issue,
since, reason}` with the number of an open `fetch:` issue (the retrieval queue,
#9). The done check then reports the study as `incomplete` (exit 3): it can be
committed, but it is not done. Once the PDF is fetched, make and commit the
inventory and extracted values, remove `source_missing`, and close the issue.

## Every disagreement gets theories and tests

A result that disagrees with the source is the start of an investigation, not
its end. For each disagreement (a `mismatch` part, a `partly` part after a
complete run, or a `published_evidence` entry marked `agreement: disagree`):

1. State it exactly: what the source reports, what we find, where.
2. Write at least two competing hypotheses. One is always that the error is
   ours (our code, our reading of the source, our digitizing), and it is
   tested first. Others may be on the source's side (a step not printed, a
   step described but not well enough to reproduce, a printed formula that
   disagrees with the printed numbers) or neither (Monte Carlo noise, a
   threshold on a knife edge, the source's prose misdescribing its own figure).
3. For each hypothesis, say what we would observe if it were true, then test
   it: rerun the source's own code, refit, simulate the hypothesized mistake
   and compare it with the source's digitized values, or compute how far a
   value sits from a threshold in Monte Carlo standard errors. Read every
   disputed statement against the source's own digitized figures as well as
   against our run: if its figures contradict its text, the disagreement is
   with its prose, not its results. Use only directly read points for this;
   an occluded marker can carry a neighbouring series' value. Commit the
   outputs.
4. Conclude: explained, partly explained or unexplained; whose error (source,
   ours, both, neither, undetermined); and how sure we are. An error of ours
   is fixed, and the fix named, before the paper goes out.
5. Discuss each one in the paper under `\label{dis:<id>}`: the theories, the
   tests and what they showed, not only the verdict.

Record this in `DISAGREEMENTS.yaml` next to the plan (format in
`scripts/disagreements.py`). `preflight.py done` checks it mechanically: every
disagreement is covered; each entry has at least two hypotheses including a
tested one on our side; every test names committed files that exist; an
untested hypothesis says why and that the person was told; the conclusion and
`whose` follow from the verdicts; and the paper carries every label.

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

Every plan must classify every part whose status is
not `replicated`. `limit_kind` is one of, or a list of:

- `input_unavailable`: name `missing_input` and `looked_in`.
- `not_run`: give `cost_estimate`, `decision`, and `tractable`. Compute cost
  alone is not acceptable when `tractable` is true. A non-cost `justification`
  can explain the stop. A tractable part may also be declined for resources
  when the plan records `decision_by: project` and a `decision_reason`. That
  pair is this project's decision. It does not make the part impossible and
  it does not attribute the limit to the source. `decision` then says
  `declined for resources`, and `cost_estimate` stays.
- `theorem_finite_only`: `finite_checks` records the finite or exhaustive
  checks. A universal proof is not established.
- `out_of_scope`: `scope_reason` says why.

A part may list several kinds. Each non-replicated `reason` must be specific
to that part: the done check rejects a reason copied verbatim onto another
part, and generic templates such as "See named artifacts and limitations".
Each part's evidence paths must be specific to that part. The same path list
may not be repeated, and a path may not be listed twice inside one part.
There is one plan format: every check applies to every plan, old or new, so a
study can be re-replicated against the current standard. A `limit_schema` key
in an older plan is ignored.

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
- [ ] Every blocker on the source's own path (software, code and seeds, data, files) was reported to the person when it happened, with what it costs and how to unblock it, and they decided. `checks.py seeds` was run on the source; each fallback record and each `input_unavailable` or `not_run` part carries that decision.
- [ ] `source_sha256` and the committed `source_inventory` identify the source, and `source_items` covers every figure and table in it with committed values or a reported exclusion; or, with neither the PDF nor an inventory, the plan records `source_missing` with an open fetch issue and the study is reported as incomplete, not done. Other authors' PDFs and documents are never committed; the done check fails on any tracked outside `paper/`.
- [ ] Every published quantity compared is in `published_evidence` with its `value_source`; any quantity a figure plots was digitized (`scripts/digitize.py`, with its reading error) or the person was told why not. Every `input_unavailable` for data records the `sufficient_statistics` search, and none is marked unavailable when the printed moments suffice.
- [ ] Every disagreement is in `DISAGREEMENTS.yaml` with at least two tested-or-justified hypotheses (one that the error is ours, tested), committed test outputs, a conclusion, whose error and confidence, and a `\label{dis:<id>}` section in the paper; every `published_evidence` entry says `agreement`.
- [ ] The full design was run, or the reduced run is a last resort with a cost estimate, what was tried, and exact `N of M` counts in the abstract and the body.
- [ ] The headline verdict is no stronger than the headline parts that were run.
- [ ] Every part has a status, an evidence pointer, and a reason when the status requires one.
- [ ] Every part of `REPLICATION-PLAN.yaml` that is not `replicated` has its own `limit_kind` (`input_unavailable`, `not_run`, `theorem_finite_only`, or `out_of_scope`), a part-specific reason, and part-specific evidence. `preflight.py done` rejects copied reasons, generic templates such as "See named artifacts and limitations", a repeated evidence path, and a `not_run` part that lacks an estimate and a decision. A tractable `not_run` part needs a non-cost justification, or an explicit `decision_by: project` with a `decision_reason`, before a resource decline is accepted.
- [ ] No part was removed or narrowed against the first commit without a recorded reason.
- [ ] `preflight.py done` exits 0 (complete). Exit 3 means incomplete: no errors, but neither the source PDF nor a committed inventory of it is available, and that is recorded; the study is not done. That command also checks same-repository master paths and line anchors against `HEAD`, and the source-acquisition record when the manuscript calls a source or its pages unavailable. A live master 404 is a separate post-merge gate.
- [ ] Optional caption hints were reviewed.
- [ ] Each reported Published finding has a verbatim excerpt, page locator, claim type, and conditions. Those checks bind the record; row-by-row review is still required.
- [ ] Rendered pages for headline and Published entries were inspected when the PDF could be obtained. Text reading and visual inspection are recorded separately.
- [ ] Page 1 was compared visually with a reference paper that uses the shared approved preamble (for example the Kupzyk replication). The geometry check only measures the text block, title, and abstract inset.
- [ ] Before reporting the pull request, its description links the built primary PDF near the top: a reviewable `blob/<40-hex SHA or head branch>/<path>` link, and the intended `blob/master/<path>` link for that same path, labeled as live after merge. Run `scripts/pr_description.py` on the description and the delivery record. `preflight.py done` and `delivery_check.py` run that check when `--pr-body` is supplied.

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
and `scripts/delivery_check.py RECORD.json --root STUDY_ROOT`. Before reporting
a pull request, link the built primary PDF in the description and check it:

```sh
python3 .agents/skills/replication-paper/scripts/pr_description.py \
  --body pr-body.md --record delivery.json --root STUDY_ROOT \
  --head-branch BRANCH
```

Omit `--body` to read the description on stdin. Exit 0 means the description
has a reviewable blob link pinned to a 40-hex SHA or that head branch, and
the master link for the same path, both matching the record's primary PDF.
Pass `--pr-body pr-body.md --record delivery.json` to `preflight.py done`, or
`--pr-body pr-body.md` to `delivery_check.py`, to run the same check. Leaving
those arguments off does not change the older commands. Use delivery
contract version 2; see the editorial
reference for migration of historical records. Helper passes establish neither
scientific truth nor prose quality. Do not claim delivery complete without the
independent rendered review. Publication actions still require authorization.

## Release records

Alongside delivery, keep the shared release records from
[verified release](../verified-release/SKILL.md#4-keep-release-records-beside-the-result):
provenance bound to the scientific revision, an import map of results used but
not reproduced, a verification record that names what was not done, and a
one-command replay packet with pinned environments. The cold-reader review above
is this workflow's bound review record. Where this skill's delivery checks are
stricter, they govern.

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
