# Editorial failure analysis and proposed skill checks

Inspected 2026-10-30. Latest remote master fetched and verified at
`e2b553c06c872d8008061a26d05831e572e54789`; the local replication-paper skill
and supporting files have no differences from that revision. This is an
investigation record, not a reusable skill change.

## Diagnosis supported by the artifacts

The delivered abstract at ed52777 began with a status sentence rather than the
required explicit replication verdict. Its narrative also described preserved
milestones, what the follow-up now proved and an earlier stage's open obligations.
The first sentence is identical at dc7e94f,7f805a9 and ed52777. Drafting added
findings and corrected selected stale scientific limitations without rebuilding
the paper's narrative from the final claim inventory. The review record checked
retention of headline values, numerical uncertainty and layout; it did not
require a quotation of the actual verdict sentence or a standalone-reader pass.
Those are observable process facts. Context overload may contribute, but the
available evidence does not establish it as the cause or excuse the failure.

The instructions were not absent:

- `.agents/skills/replication-paper/SKILL.md`, lines94–114: the first sentence
  must state replicated/partly replicated/not replicated and the source-versus-
  ours headline values; limitations and reversals precede supporting results.
- Lines163–167 prohibit process details in the abstract/opening.
- Lines177–207 require writing for a reader without the working conversation,
  separating findings, reproduction instructions and provenance, and omitting
  operational chatter that does not affect interpretation.
- Lines28–47 require independent main-PDF review and explicitly say helper tests
  do not establish manuscript compliance.

The error therefore includes non-enforcement of explicit existing requirements.
Preserving scientific evidence was incorrectly translated into preserving a
story about successive deliveries. Historical source-code revisions and adaptive
experimental sequences can be scientifically necessary; draft milestones and
approval history are not explanations of the result.

## Supporting-file inspection

`delivery_check.py` validates file bytes, revisions, remote copies, build inputs
and review hashes. At lines65–72 it accepts a nonempty reviewer string and
nonempty text for six review categories. It does not parse the abstract, quote
its first sentence, compare a headline claim with the manuscript or assess
standalone prose. Its docstring and output correctly call this structural
validation, so this is a missing editorial layer rather than a defect in its
advertised hashing function.

`tests/test_delivery.py` lines13–14 explicitly accept generic `page evidence`
strings in the valid fixture. Its tests reject stale hashes, omitted reviews,
wrong artifact roles and invalid URLs; there is no negative fixture for a
status-led abstract or revision-dependent narrative. `check_citations.py` checks
citation-key integrity, not whether a passage supports a claim. `checks.py`
validates numerical precision/comparability; `contrast_checks.py` validates
structured signed contrasts and coverage. None reads manuscript prose to enforce
the editorial contract. These useful checks should be retained and not described
as substitutes for semantic review.

`agents/openai.yaml` supplies a single broad default prompt to replicate, write
and open a PR. It defines no phase-specific input packet. The approved preamble
is a typography asset, not a narrative template. The skill has734lines and
6087words, combining acquisition, engines, SEM-specific comparison details,
writing, delivery and announcement instructions. That exceeds the skill-design
guidance's suggested500-line core and roughly5000-word loaded body. Size is a
risk factor, not proof that instructions were lost.

The companion open-question skill requests publication/reference chronology
(lines405–420), including material prior manuscripts. It does not require a
progress diary or permission history in the scientific narrative. The replication
skill's reference to that workflow for proofs and chronology would benefit from
an explicit boundary: retain scientifically relevant source/publication dates,
not internal draft state. The replication skill otherwise already distinguishes
provenance from scientific exposition.

The skill still opens with a selected published-result scope. A whole-dissertation
request needs an explicit scope mode and complete claim inventory, including
analytical/software results and exclusions. This separate scope gap does not
explain or excuse the editorial failure in a completed manuscript.

## Recommended changes, not implemented here

1. **Enforce the existing writing contract.** Require the exact abstract first
   sentence, headline claim ID and source/result evidence anchors in the review
   record. Require independent judgments of verdict accuracy and the ordering
   verdict -> evidence limit -> reversal -> supporting results. Check that the
   introduction and conclusion answer the same scientific question.
2. **Add a cold-reader gate.** Give a reviewer only the current manuscript/PDF,
   frozen claim inventory, source excerpts and result tables. Do not supply draft
   history, prior reviews, desired review outcome or a summary of the fix. Require
   quotations and page locations for issues, corrective decisions and re-review
   after changes. Record reviewer identity, supplied inputs and limits honestly.
3. **Add conservative editorial lint, not a word ban.** Flag temporal/project
   constructions such as 'at the earlier milestone' or 'the latest continuation'.
   Require contextual adjudication. Accept mathematical parameter preservation,
   remaining variables, historical source versions and explicitly described
   adaptive design when relevant. A regex pass cannot establish standalone prose.
4. **Test actual failure examples.** Include status-led abstracts, support-first
   verdicts, a contradictory conclusion, project history hidden in an appendix,
   and stale scientific limitations. Include passing controls for legitimate
   mathematical/experimental temporal language. Test semantic review as well as
   structural schemas; generic review strings must not count as editorial proof.
5. **Use a short orchestrator with bounded phase packets.** Separate (a) scope,
   source availability and authority, (b) frozen comparisons and experiments,
   (c) evidence interpretation, (d) manuscript composition from final findings,
   (e) cold-reader/rendered review, and (f) delivery/remote verification. Each
   handoff contains artifacts, decisions and explicit limits, not the full chat
   or a compressed diary. Load domain-specific engines and announcement guidance
   only in the relevant phase. This can be references/substeps within one skill;
   several separately discoverable skills are not necessary initially.
6. **Keep acceptance explicit.** A whole-dissertation inventory requires a result
   or attempted blocker for every substantive claim, not universal numerical
   success. Public coordination-branch requirements and authorization must be
   identified at setup, not discovered after scientific work. Those requirements
   belong in workflow records, not the paper's narrative.

Priority: enforce the standalone editorial gate first, then simplify phase
loading. Merely adding another paragraph repeating the same instruction is
unlikely to address the observed failure. A phase split may reduce interference,
but only prospective tests can establish that it improves reliability.

## Evaluation in this revision

The manuscript is rewritten around current scientific claims and limitations.
No simulation, fit, proof, raw-result or reference-code input is changed. A
separate reviewer receives current manuscript/source/results without drafting
history or previous reviews. Its findings and the rendered-page checks are
recorded separately. This evaluates the proposed review boundary on this case;
it is not evidence that a modified reusable skill generalizes, because no skill
was modified and no cross-task evaluation was run.

The cold-reader evaluation found concrete residual defects in the first rewrite:
the compliance table still mentioned an approved preamble, replacement of
inapplicable SEM engines and review/remote-byte workflow; the artifact appendix
explained pending-merge navigation. These were not scientific findings and were
removed or restated directly. The recommendation to use a title containing
'remains unresolved' was not adopted: the current topical title is appropriate,
and the abstract/introduction already supply the required outcome-first verdict.

One concrete instruction interaction deserves correction in the skill: its
blanket master-link requirement produces nonworking scientific links before a
research PR is merged and encourages lifecycle explanations inside a paper.
For this manuscript, immutable snapshots provide source/code/evidence links;
current-manuscript links are supplied in the PR/delivery record. This scoped
deviation prioritizes working reader-facing references and the user's standalone
paper requirement. Publication status and template/engine-preflight provenance
are documented outside the scientific narrative. No source or engine change is
hidden by removing workflow wording.

A further wording risk is the skill's line123 story cue, 'what gave us trouble
and how we fixed it'. It can be read as a progress narrative unless constrained
to scientific problems, diagnostic evidence and methodological consequences.
That interpretation does not override the explicit standalone-reader requirement;
the proposed phase guide should state the distinction at the composition gate.
