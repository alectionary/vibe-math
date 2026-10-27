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

Before calling a recommendation new, check the canonical issue (including
closed issues), inventory, research notes and verification records for earlier
work on the exact formulation. Report separately whether it was previously
proposed, computationally explored, partially proved, or completely answered.
An unanswered follow-up can be the best next target; label it as a continuation
and link the prior evidence rather than presenting it as an untouched problem.

Define a bounded deliverable and stopping condition suited to the user's request:
for example, an exact statement/proof, an independently verified counterexample,
a decisive structural lemma, or one frozen controlled comparison. Honor an
explicit time or computation budget. A completed core theorem does not silently
authorize an indefinite consequences program. Explain the depth/breadth choice
before substantial expansion; continue already authorized follow-ups without
asking for routine implementation decisions. If no target was specified, use the
inventory and prior progress to recommend one; do not substitute another round
on a completed problem without saying so.

When recommending the next question, briefly compare the strongest candidates
from the inventory and explain the choice: mathematical payoff, evidence that
our results or an existing theorem do not already settle it, a plausible decisive
lemma or counterexample route, and the cost of faithful Lean formalization.
Prefer a complete answer to a meaningful bounded question over an easy auxiliary
lemma. A difficult general question may justify a restricted target, but label
the restriction before starting and retain the original target's status.

Write a short answer contract in the working notes: **question and source →
intended answer → decisive evidence**. Explain why the answer would matter
(e.g. determining missing information, refuting a proposed criterion, giving an
exact count or enabling a construction). Update this contract when the result
changes; do not let a successful computation silently redefine the question.

Use [the investigation worksheet](references/investigation.md) in the target's
existing notes or a suitably named new research note. Keep it proportional to the
task; it is a working record, not a reason to create empty files or a new taxonomy.

## Coordinate the investigation with an issue and claim

Before starting a research block, coordinate by canonical inventory ID in the
shared upstream repository, even if only one agent is currently visible. Use
an issue and remote claim together; use a repository-linked GitHub Project when
requested and accessible. A locally
checked-out branch is not a shared claim; issue assignees also cannot distinguish
sessions using one account. Read [GitHub coordination](references/github-coordination.md)
for access checks, setup, verification and handoff details.

Before new full-text retrieval in that block, consume immutable fetch manifests
already posted for the active campaign. Follow
[document acquisition](../document-acquisition-queue/SKILL.md). This agent is
the only writer of the canonical ledgers. Merging a fetched PDF does not
complete a question screen. Unreadable text and a front-matter preview keep a
null question count.

Use one GitHub issue per canonical target for discussion, scope, progress and
handoff; search open and closed issues before creating one. If using a Project,
add that real issue and reuse the existing board rather than creating a board
per agent. Missing Project access does not block issue/claim coordination.
Keep mathematical resolution and Lean
coverage in the existing inventory; a claim means work is reserved, not solved.

Keep the issue current with the exact bounded question, prior attempts and their
outcomes, remaining gap, evidence links, owner and next action. Creating a new
issue does not make the mathematical question new. Reuse the parent issue for
successive follow-ups and preserve their distinct scopes and outcomes.

Distinguish selection/reservation from permission to conduct the study. When
the user asks only for setup or says they will tell us when to begin, record
**Reserved — awaiting user instruction to begin** in the issue and stop after
the authorized coordination work. Do not launch literature campaigns, searches,
experiments or proof work on that reservation. A request that already authorizes
research needs no additional start confirmation.

Reserve `refs/heads/claims/<canonical-id>` with a **create-only remote reference
operation**, such as GitHub's create-reference API. Point it at a commit recording
a unique session identifier, UTC start time, bounded scope, issue URL and separate
work branch. Prepare that commit on the work branch first. Begin substantial
research only after the server confirms creation. Checking for absence and then
performing an ordinary push is not an exclusive reservation; never force-update
an existing claim. If creation conflicts or its outcome is uncertain, inspect
the remote claim and resolve ownership before proceeding. Choose another target
when it is already owned; resume only a claim belonging to this session or an
explicitly handed-off investigation.

Use a separate worktree or clone and a unique work branch per investigation.
Initially reserve the whole canonical target, including restricted follow-ups;
split it only after the investigators agree on nonoverlapping scopes. Record
progress and handoffs in the issue. At completion or release, preserve the work
branch and evidence, update the issue, and remove only this session's claim using
an expected-SHA check. An old timestamp alone does not authorize taking over a
claim. Keep the issue and any Project status consistent with the actual work and claim: reserved
for a future block is Todo; active research is In Progress. Record a blocked
reason or handoff in the issue, using existing board options. Releasing a claim
does not mean the source question is answered. Mark a block Done only with its
outcome and evidence recorded; do not close an unanswered canonical question
merely because a bounded follow-up finished.

For this repository, finished work belongs on `master` unless the user explicitly
requests a draft, branch-only delivery or another destination. Within the user's
authorized publication scope, integrate all completed artifacts and their required
sources, certificates, verification records, inventory updates and skill changes
before reporting delivery complete. A pushed work branch is a checkpoint, not
completion of publication. Verify the actual files on remote `master`, compare
artifact hashes with the validated copies, and give working `master` URLs alongside
immutable proof links. Follow the integration steps in
[GitHub coordination](references/github-coordination.md#integrate-finished-work).
If integration is blocked, state that publication is pending and why; partial work
may remain on its work branch with an explicit handoff.

If shared repository write access is unavailable, prepare the exact issue body
and answer contract, and report which remote operations remain pending. Continue
source inspection or independent preparation without presenting the target as
reserved. If only Project access is missing, complete the issue and claim and
report the board as skipped or pending according to the user's instructions.
Verify actual server state after each stage;
a local draft, CLI installation or proposed command is not a successful trial.
Perform GitHub writes within the user's authorized scope; this convention does
not itself authorize publishing or spawning additional agents.

## Freeze meaning and inspect the literature

For investigations requiring GitHub or X coverage, make a brief, read-only access
check early. Discover the current environment's tools rather than assuming another
machine's installations, accounts or browser connection. Prefer an applicable
GitHub connector or authenticated `gh` CLI; for X, use an applicable connector or
the user's signed-in browser extension when available. Respect explicit browser
choices and follow the selected tool's current instructions. Read
[research access and setup](references/research-access.md) when selecting a route,
setting up another machine, or diagnosing blocked access.

Search execution is opportunistic; accounting for required searches is mandatory.
Attempt a bounded pass early. If blocked, record the pending searches and continue
independent research. Retry at useful phase boundaries or after a meaningful
access change, including the user reporting that the computer is ready. Before
closeout, complete each required service search or explicitly record its access
gap and the resulting coverage limit. Do not silently count indexed web results
as authenticated service coverage, poll repeatedly, or wait indefinitely for UI
access. Record actual successful operations, not just installed tools.

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
  plainly, once, with attribution. An ordinary theorem or counterexample claim
  needs no generic priority disclaimer. Record concrete prior-art comparisons and
  unresolved access gaps in the evidence ledger; make historical priority claims
  only when separately supported.

## Harvest questions from every encountered paper

During each investigation, keep a deduplicated ledger of papers actually found
or consulted, including classical predecessors, surveys, secondary leads and
later versions. This happens automatically with the research; do not wait for a
separate inventory request. Bibliography-only citations need not trigger an
unbounded recursive search.

For every accessible full text, screen numbered conjectures/questions, unknown
existence cases, introductions, conclusions and future-work passages; read the
surrounding definitions and context. Extract author-stated targets beyond the
immediate problem being researched. Check addenda and later statements in the
same paper before calling a passage open. Preserve original versus discovery
authorship, exact version/date, locator and source hash. Merge equivalent
questions; link genuinely different restricted cases. Separate precise targets,
broad directions, held formulations and known solved/refuted historical claims.

Before closeout, give every paper/version an explicit outcome: linked inventory
entries, a completed screen with no additional explicit target found, or a named
access/version gap. An abstract, empty successful response or unreadable scan
cannot justify a zero-question result. Try reasonable primary/author copies,
use OCR and visually check relevant pages when needed, and retain unresolved
leads without inventing bibliographic details. A failed HTTP fetch is a failure of
that retrieval route, not evidence that a work is paywalled. Follow the archive's
actual Download link and any publisher landing page; when available, attempt the
user's supported browser extension before declaring an access gap. Distinguish
browser-connection failure from site restrictions. See [full-text retrieval](references/research-access.md#retrieve-full-text-before-recording-an-access-gap)
for redirects, cookie banners and temporary PDF links. When those attempts still
do not verify a complete text, hand the source to
[document acquisition](../document-acquisition-queue/SKILL.md) instead of
stalling. Search for an existing fetch issue, file a `fetch-request` when none
exists, record `acquisition_requested` as that skill describes, and continue
independent work. A preview or unreadable extraction stays a null question
count. Add the findings to the shared inventory and planning records, leave
unperformed current-resolution/Lean checks
unassessed, regenerate reports and validate source coverage and cohort deltas.
The [complete absorbing-set source screen](../../../literature/RESEARCH-QUESTION-SCREENING.md)
illustrates this workflow and the distinction between downloaded, consulted,
screened and question-contributing papers.

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

Before closing a proof, try to break the final statement. Recheck the full
quantifiers, degenerate cases and source-to-formal translation; for a family,
test exceptional parameter regimes as well as the easiest instances. Check
necessity versus sufficiency, lower bounds versus exact values, ordered versus
unordered counts, and component results versus the full construction when those
distinctions apply. Use an independent representation or reconstruction for
concrete witnesses where practical, rather than reusing the generator's own
assumptions. Repair failures or narrow the stated conclusion explicitly.

Trace the headline claim through the source question, manuscript theorem,
Lean statement, dependencies and verification record. Do not substitute a
successful build for this semantic comparison.

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

- Inspect representative earlier papers in the repository before choosing the
  manuscript format. Reuse their established typography, theorem/proof structure,
  citation style and source workflow unless the user requests a departure or the
  task requires one; explain a necessary departure. Supporting verification
  requirements do not by themselves justify replacing the paper's visual style.
- Organize the exposition around the answer contract: source question and its
  motivation → exact answer → decisive theorem and proof → implications and
  limits. Explain how a source question motivates any replacement problem;
  distinguish cited mathematical results from claims established in the paper
  without narrating the work session. Give each main section a clear mathematical role;
  introduce constructions as existence witnesses, parameter improvements,
  sharpness results or obstructions as appropriate. Put comparisons beside the
  claims they assess, and keep search mechanics and inventory bookkeeping in
  supporting material when they interrupt the argument.
- Omit the manuscript author line unless the user explicitly requests one. Do not
  substitute a collective label such as "Project Contributors". Preserve source
  author attribution in citations and the question/source/answer table.
- Lead with the proved result, counterexample or completed characterization.
  Identify each motivating source question by author, date, version and exact
  remark/conjecture/section, then give its specific answer and theorem/proof link.
  Use an opening question/source/answer table when several targets are involved.
  Separate results established in this paper from cited results of earlier work,
  and source-posed questions from our own follow-ups. Do not relabel a research
  direction as a numbered conjecture. Describe completed proofs as proofs or
  theorems rather than diminishing them as preliminary research notes.
- Credit classical ingredients in related work. Keep concrete access and search
  limitations in one relevant passage or evidence ledger; avoid generic repeated
  priority disclaimers in the abstract, introduction and conclusion. An ordinary
  result claim does not require a universal claim to historical priority. Retain
  mathematical hypotheses and limits that determine what the theorem proves.
  Keep routine retrieval failures in the supporting ledger. An unavailable source
  alone is not a reason to cast doubt on a proved result, speculate that unseen
  work invalidates or subsumes it, or hedge an ordinary theorem claim. Give
  precise overlap attribution when an inspected source actually supports it.
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
- Include a substantive, organized Lean appendix in the PDF, following the
  [stopping-bound paper's proof appendix](../../../formalization/stopping-bound/stronger/supplement.tex):
  explain the definitions and source bridges, print complete central proof bodies,
  show their dependency structure, and provide current and commit-pinned source
  links with declaration-level anchors. Explain the chain from source definitions
  through the decisive lemmas to the conclusion; place complete central proof
  bodies beside that explanation. Whole-module listings alone do not satisfy this
  requirement. Keep complete supporting sources available and linked. A coverage
  table, external guide or source archive supplements this exposition; it does not
  replace it. Review the rendered appendix against that example before delivery.
- Cite the discovery source, original question and applicable predecessors in
  the manuscript, distinguishing discovery credit from mathematical authority.
  A discovery record only in a repository ledger is insufficient.
  Include a reference chronology table: source, earliest relevant preprint/date,
  inspected version/publication milestone, this paper's dated revision, and the
  explicit elapsed-time delta. Place the chronology and a readable central-source
  comparison in the main text by default, near the introduction or related work;
  explain a necessary departure from this or the established manuscript style.
  Account for central predecessors, inspected versions and the present manuscript,
  including prior repository manuscripts when materially used. Label internal
  manuscript dates as such, not external publication dates. Explicitly signpost
  any complete supporting ledger kept in an appendix. Measure deltas to the
  stated manuscript revision date, not a moving reading date. Label date precision
  and approximation rather than
  inventing a day for a year-only source. Distinguish an ingredient's age from the
  duration of an unsolved problem. Record elapsed investigation time to the answer
  and later formalization/manuscript revisions separately in reproducibility
  records, not in the manuscript narrative unless the user requests that history.
- Present the manuscript as a standalone mathematical argument. Internal drafts,
  checkpoint builds and GitHub commits do not establish an externally announced
  publication or justify calling the paper "expanded", "updated" or "revised".
  Use a plain manuscript date by default. Use version-comparison language only
  for an established externally announced version or at the user's request.
  Keep investigation timelines, drafting decisions, session history and revision
  logs in reproducibility records unless the user asks for them in the paper.
  Cite related repository results by mathematical statement and source, without
  turning the manuscript into an account of when they were produced.
- Validate the PDF,
  source archive, hashes, proof-coverage table, reference-date arithmetic and public
  URLs before delivery. Review the rendered PDF as a reader: can the original
  question, specific answer, main proof, implications, chronology comparison and
  complete proof links be located readily? Check narrative hierarchy and style
  continuity as well as mechanical presence; a required table buried without
  signposting is not sufficient. Check the title/date line, abstract, introduction,
  conclusion, appendices and announcement for internal draft-history framing;
  preserve technical uses such as expanded matrices and cited source-version
  dates. Test discoverability in the final rendered PDF: locate the question,
  answer, chronology, proof explanation and remaining limitations without
  searching long source listings. Format/presence validators alone do not
  establish this reader-facing check. Commit/push only within the user's existing
  authorization.

Before claiming a manuscript/research block complete, add a proportionate
requirement-to-evidence table to its existing reproducibility report. For each
applicable deliverable requirement, record **met**, **partial**, **access-limited**
or **not applicable**, with a concrete final-PDF page/section or file/declaration
and a reason for any exception. Check the locations against the final artifact.
Surface an outstanding limitation in the user-facing handoff when it prevents a
requested deliverable or affects a specific mathematical claim. Keep routine
search coverage and unavailable-source records in the supporting ledger; do not
turn an unavailable paper into speculative doubt about correctness, originality
or publishability. State proved results with their mathematical hypotheses.
Historical-priority claims require their own evidence, but an ordinary theorem
claim does not require an exhaustive literature audit or a generic disclaimer.
This table records evidence, not a new approval step or authorization to expand
research indefinitely.

When an announcement is requested, draft a short X post containing the exact
answered question, the source authors and precise reference (DOI or arXiv,
plus the relevant locator), the main answer and the GitHub folder containing
the final PDF and proof links. Keep only the terminology needed to understand
the contribution; use the requested length rather than an automatic long thread.
Lead with the motivating question, then explain the answer, its mathematical
mechanism and the logical follow-on findings. State what remains open and the
next direction when relevant. Integrate accurate search terms naturally so
researchers can find the work. Verify that the linked public revision contains
the announced PDF and proofs before handing off a publication-ready draft.
Check that compression preserves restrictions and distinguishes this paper's
results from cited work. Announce the paper directly; internal drafting does not
  make the first external announcement an "expanded paper" or an "update".
  Drafting an announcement does not authorize posting.

Preserve the repository's anonymity conventions in public artifacts and Git
identity. This skill does not itself authorize publication, external messages,
new scheduled tasks or changes to unrelated projects. Apply the user's existing
authorization to the actual requested actions.

When editing this skill itself, validate its frontmatter with the
`skill-creator` skill's `scripts/quick_validate.py`. That validator requires
PyYAML. Use a workspace virtual environment, ensure the dependency with
`python -m pip install PyYAML`, and run the validator with that same Python
interpreter. Reuse an existing environment when it already has the dependency.

Finish each research block with:

**Question answered:** exact claim and evidence, or explicitly none completed.

**Question still open:** the specific unresolved part and the current result's limit.

**Next proposed target:** a bounded next action, labeled **new problem** or **follow-up**.
