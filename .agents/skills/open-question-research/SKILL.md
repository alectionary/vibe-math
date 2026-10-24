---
name: open-question-research
description: "Investigate an open mathematical question or conjecture in vibe-math: verify the source and prior art, explore proofs or counterexamples, and develop Lean evidence within a bounded target. Use for starting, continuing, or assessing these investigations, not unrelated repository maintenance."
---

# Open Question Research

Apply the lessons in the repository's [README](../../../README.md), especially
its research guidance, and the relevant parts of [RESEARCH-LESSONS.md](../../../RESEARCH-LESSONS.md).
Locate the repository from this skill directory; command examples and research
paths below are relative to its root. Read the target's existing notes and
verification records before assuming a source question remains unanswered.

## Establish the target and stopping point

Start with a short statement of the exact source question, what this repository
already answers, and whether this task is a **new problem** or a **follow-up**.
Reuse the canonical inventory identifier across equivalent formulations and
repeated source occurrences. Distinguish author-posed questions, numbered
conjectures, broad research directions and our own proposed tasks.

Define a bounded deliverable and stopping condition suited to the user's request:
for example, an exact statement/proof, an independently verified counterexample,
a decisive structural lemma, or one frozen controlled comparison. Honor an
explicit time or computation budget. A completed core theorem does not silently
authorize an indefinite consequences program. Explain the depth/breadth choice
before substantial expansion; continue already authorized follow-ups without
asking for routine implementation decisions. If no target was specified, use the
inventory and prior progress to recommend one; do not substitute another round
on a completed problem without saying so.

Use [the investigation worksheet](references/investigation.md) in the target's
existing notes or a suitably named new research note. Keep it proportional to the
task; it is a working record, not a reason to create empty files or a new taxonomy.

## Freeze meaning and inspect the literature

- Record the source version/date, precise page or section, and the actual question.
  Credit the discovery source, the source posing the question and earlier applicable
  results separately. A paper's historical open label is not a current-status check.
- Write the informal statement and intended Lean interface together. Check objects,
  field, quantifiers, every hypothesis, direction of implication, definitions,
  nonemptiness and boundary cases. An accidental strengthening of assumptions or
  weakening of the conclusion answers a different question.
- Build a small translation table for equivalent structures, invariants and
  terminology. Search primary literature before expensive implementation, using
  those translations as well as the source's words. Follow references backward,
  citations forward, and the authors' and coauthors' downstream work. Scholar or
  similar indexes and author repositories are useful discovery routes; record
  their actual coverage and access failures. Include public GitHub repositories/code
  and accessible X.com research posts in the prior-art audit, as well as classical
  literature. Record exact queries, authentication/access limitations, result caps,
  inspected matches and dates. Test search filters with a known-positive sanity
  query; discard negative results from unsupported or ineffective qualifiers.
  Absence from a bounded or capped search is not evidence of global absence.
- Read candidate theorem statements, hypotheses, relevant proofs and errata.
  Compare the **full target**, including earlier general theorems that imply it;
  checking component lemmas alone is insufficient. Justify translations instead
  of treating analogies as equivalences. Revisit the search after a decisive lemma
  supplies better search vocabulary. Keep unavailable full texts as leads.
- Keep mathematical novelty, proof-method novelty, formalization priority and the
  artifact's concrete contribution separate. State the strongest supported finding
  plainly, once, with attribution. When appropriate, use "earliest complete answer
  known to us" with the recorded search scope; a negative search does not prove
  first-ever priority. Avoid repeated generic qualifications.

## Develop a proof or counterexample with useful formal scope

Test small and boundary examples first, then choose searches that could
distinguish explanations. Use exact arithmetic where required. Record exhaustive
versus sampled scope, seeds, constraints and saved witnesses. Independently verify
and, when useful, reduce a counterexample. No counterexample found is not a proof.

Compare proof routes by missing formal infrastructure as well as informal length.
Prove the smallest decisive structural lemma early. Prefer reusable abstractions
that expose the property actually needed rather than carrying unnecessary
assumptions. Maintain a list of mathematical and formalization obstructions.

Prove the bridges: source objects to formal definitions, abstract graphs to actual
matrices, arithmetic closure to a **simple** cycle, and numerical certificates to
the specified update equations. Make counting conventions explicit. Check public
theorem signatures as carefully as proof bodies; Lean does not validate a paper
translation or a literature claim by compiling a different statement.

Maintain these evidence labels in notes and public claims:

| Evidence | What it supports |
|---|---|
| General Lean proof | The exact formal implication under its declared premises. |
| Concrete Lean certificate | The specified instance, data and mathematical model. |
| Written proof | An ordinary argument, with unformalized bridges identified. |
| Exact finite computation | The explicitly enumerated finite domain. |
| Sampled experiment | Outcomes and uncertainty under the recorded sampling protocol. |
| Search lead / unresolved | A candidate or gap, not an established result. |

Run checks appropriate to changed proofs and dependencies, with pinned toolchains,
axiom reports and independent consumer examples where useful. Preserve historical
manifests at their publication revisions; do not rewrite frozen scientific inputs
or inflate coverage by counting helper lemmas as newly solved source problems.
For coverage fractions, state the canonical target cohort and denominator.

## When the follow-up concerns experiments or decoder trajectories

Read the experimental lessons in RESEARCH-LESSONS.md when this mode applies.
Establish the estimand and controls before generating costly data. For coding
comparisons, check exact distance as well as length and dimension; same-code
representations may still change check degrees, count and routing. Score quantum
recovery modulo the stabilizer span when that is the model's success criterion.

Freeze mechanisms, detector definitions, code/channel/decoder/stopping settings,
seeds and hashes before fresh holdout data. Retain unsuccessful candidates and
do not silently retrain or pool independent samples. Count rescues and losses,
not just marked failures; report uncertainty for paired contrasts.

Distinguish hard decisions from full message states, local effects from complete
reachable executions, finite-horizon persistence from infinite trapping, and late
verification from early prediction. A certificate covering many failed trajectories
can explain little of a **net** deterioration. A descriptive partition is not a
causal pathway. Separate checked mathematical updates, implementation replay,
sampling and statistical conclusions. Stop a weak route at its bounded endpoint
and record what it failed to establish.

## Report, preserve and hand off

Compare the final result directly with the source request: identify precisely what
was answered, what was answered only partially, and what remains open. Measure
progress by canonical mathematical targets, not declaration counts or paper pages.
Explain specific remaining gaps without presenting every follow-up as necessary
to finish an already completed theorem.

Reconcile discoveries with the shared inventory before closing a research block:
link used sources, source-stated questions, canonical occurrences, resolution and
Lean evidence, remaining project-derived tasks, and planning records. Use the
existing files under `literature/` and `planning/`, with an explicit cohort delta
when adding targets. Deduplicate equivalent questions; do not promote our own
follow-ups into author-posed questions. Mark new source/current-resolution/Lean
searches and difficulty assessments unassessed where applicable. Regenerate the
reports and run their bookkeeping validators; paper-only notes are not sufficient
integration. The [October 23 reconciliation](../../../literature/RESEARCH-RECONCILIATION.md)
illustrates the distinctions without changing frozen experiment inputs.

When writing or revising a research paper:

- Keep a proof-to-Lean table covering every proof created for the manuscript,
  including counting bijections, certificate soundness, matrix/source translations,
  finite-instance verification and applications. Give every such proof a faithful
  Lean version with the same objects, quantifiers and hypotheses. Build and audit
  those versions before presenting the corresponding paper claims as proved.
  Supporting lemmas or an exact external computation do not replace a missing
  theorem bridge. Keep incomplete proofs explicitly outside the proved results;
  do not silently narrow the requested result or disguise an equivalent conclusion
  as a new premise to obtain apparent formal coverage.
- Show meaningful Lean statements, dependencies and proof excerpts. Include direct
  clickable repository file links for the complete proofs (not just a directory or
  theorem name), and immutable commit-pinned links for reproducibility. Verify
  that the linked Lean sources and imported research modules are checked into the
  repository. When publication is authorized, push them with the paper and check
  that the public links resolve to the verified sources.
- Cite the discovery source, original question and applicable predecessors.
  Include a reference chronology table: source, earliest relevant preprint/date,
  inspected version/publication milestone, this paper's dated revision, and the
  explicit elapsed-time delta. Label date precision and approximation rather than
  inventing a day for a year-only source. Distinguish an ingredient's age from the
  duration of an unsolved problem. Record elapsed investigation time to the answer
  and later formalization/manuscript revisions separately.
- Clearly label an expanded paper versus a new research target. Validate the PDF,
  source archive, hashes, proof-coverage table, reference-date arithmetic and public
  URLs before delivery. Commit/push only within the user's existing authorization.

Preserve the repository's anonymity conventions in public artifacts and Git
identity. This skill does not itself authorize publication, external messages,
new scheduled tasks or changes to unrelated projects. Apply the user's existing
authorization to the actual requested actions.

Finish each research block with:

**Question answered:** exact claim and evidence, or explicitly none completed.

**Question still open:** the specific unresolved part and the current result's limit.

**Next proposed target:** a bounded next action, labeled **new problem** or **follow-up**.
