---
name: verified-release
description: "Confirm, record and publish a finished research result: evidence labels, independent confirmation (certificates, spec-only checkers, cross-vendor agents), Lean axiom reports, provenance and import maps, replay packets, bound review records, master publication and announcements. Use after the science of an open-question or replication study is done, or to audit an existing result."
---

# Verified release

Use this skill once a result exists and must be confirmed, recorded and published.
[Open-question research](../open-question-research/SKILL.md) and
[replication paper](../replication-paper/SKILL.md) hand off here. Those skills
own their science and manuscript rules; where they set a stricter rule (for
example replication-paper's delivery checks), follow theirs. This skill adds
the shared release practice. Repository specifics, scripts and the worked
example are in [vibe-math notes](references/vibe-math.md); file templates are in
[release records](references/release-records.md).

## Commit identity

Make every commit as `alectionary <alectionary@users.noreply.github.com>`.
Once per clone, run `git config core.hooksPath .githooks` so `commit-msg` and
`pre-push` reject consumer-domain author, committer, and message addresses
(noreply addresses stay allowed). Details are in
[CONTRIBUTING.md](../../../CONTRIBUTING.md).

## 1. Ledger every claim with its evidence

Give each claim one evidence label and keep it in notes, paper and announcement:

| Evidence | What it supports |
|---|---|
| General Lean proof | The exact formal implication, under its declared premises and axioms. |
| Concrete Lean certificate | The specified instance and data, under the reported axioms. |
| Certified computation | A computation whose output certificate was accepted by an independent checker. |
| Written proof | An ordinary argument, with unformalized bridges named. |
| Exact finite computation | The explicitly enumerated finite domain. |
| Sampled experiment | Outcomes under the recorded sampling protocol. |
| Search lead / unresolved | A candidate or gap, not an established result. |

For manuscript releases, require the shared
[citation coverage gate](references/citations.md) and a rendered citation review.

Before calling a release complete, add a requirement-to-evidence table to the
reproducibility record: **met**, **partial**, **access-limited** or **not
applicable**, each with a concrete location. Never report a build, run, push or
check you did not see succeed. Exit 137 is out of memory, not success.

## 2. Plan the independent confirmation early

Decide how the result will be independently confirmed while the main search or
analysis is being designed. Estimate the cost first, and ask what the cheapest
*independent* check is; re-solving with a second method is not the only option.

- **Certificates.** An exhaustive search should write a proof certificate (for
  example its search tree) that a separate checker can verify much faster than
  the search ran. Keep a fast reference checker of your own, in a compiled
  language when certificates are large.
- **Spec-only implementations.** For an independent checker or replication, write a
  self-contained spec: definitions, data formats, checking rules with their
  soundness argument, file hashes, and known-answer tests. Those tests must
  include a passing case, deliberately altered inputs that must be rejected, and
  a planted positive case that must be found. Forbid reading our code and
  manuscript; require the implementer to regenerate derived inputs from raw
  data. Answer that implementer only with spec clarifications, and record each
  one in the spec.
- **Different hands.** Prefer an implementer from a different model vendor, or a
  person. An agent writing kernel-checked proofs may have full context, since the
  kernel, not independence, carries the trust.
- **Rerun before citing.** Rebuild or rerun every external result yourself. Read
  the exact theorem statement and its axioms, and compare invariants (node
  counts, hashes, item counts) with your own runs before the paper cites it.

## 3. Report what formal proofs trust

For Lean work, produce an **axiom report**: every declaration's `#print axioms`
compared with the standard three (`propext`, `Classical.choice`, `Quot.sound`).

- `sorryAx` or any project-defined axiom fails the release.
- Compiled-evaluation axioms (`native_decide`, `Lean.ofReduceBool`) are disclosed
  per theorem in the report and in the paper, then accepted or rejected by the
  repository's current policy ([vibe-math notes](references/vibe-math.md#lean-trust-policy)).
- A strict mode that fails on anything beyond the standard three, and a self-test
  with deliberately bad declarations, show the gate works.
- State where trust rests outside the kernel: data generators, external theorems,
  compilers. Mathematical imports go in the import map (section 4).

## 4. Keep release records beside the result

Each released result gets one folder whose records separate concerns
([templates](references/release-records.md)):

- **README:** the exact answer, its scope, and its evidence labels.
- **PROVENANCE:** the *scientific revision* that holds the reviewed science
  (commit and tree), separate from later delivery commits that only change prose
  or packaging. It also lists every source file's path, Git blob and SHA-256.
- **IMPORTS:** each external theorem or published result the argument uses but
  does not check, with its locator and where it is used.
- **VERIFICATION:** what was checked and how. It keeps four things apart: source
  identity, finite execution, independent review or implementation, and
  kernel-checked proof. It also names what was *not* done, such as "no independent
  Lean rebuild in this environment".
- **REVIEWS:** each review names a reviewer who did not author the reviewed part.
  It states the exact claim and the verdict (ACCEPT, ACCEPT WITH CHANGES or REJECT),
  bound to the scientific revision, tree and file hashes. Review components
  separately, then review their composition into the final claim.
- **ATTRIBUTION:** authors, agents with model and version, and the license of each
  part; never relicense third-party material.

## 5. Ship a replay packet

Give a reader one command that re-verifies the release from files alone:

- a script that checks every input hash, reruns the checks, and prints a fixed
  expected status line (for example `PASS_<RESULT>`);
- an expected run time per step. Optional long steps (an hour-long certificate check, a
  full Lean build) are separate flags;
- pinned environments: `lake-manifest.json` and toolchain for Lean, exact
  interpreter and compiler versions, and any lock file. Record versions known to
  break reproduction, not just one that works;
- no network or private-repository access at replay time. Large data is split
  under host limits, with a hash for each part and for the reassembled file.

## 6. Coordinate several agents in the open

- One GitHub issue per agent or workstream: start, milestones, blockers, at least
  hourly status while active, and a note when pausing. Treat silence or a missing
  push as a status to chase, not as progress.
- One branch and file prefix per agent, so parallel efforts never edit the same files.
- For a critical-path proof, consider two agents in parallel and keep whichever
  finishes and verifies first; close the other with thanks, preserving its branch.
- Thank and credit each agent in the issue and in the release's attribution.

## 7. Publish and verify on the default branch

- Settle access before the work depends on it: push rights (for example the
  GitHub app on the repository), branch rules such as required reviews, and size
  limits for each transfer route. Raise a required-review rule with the user
  before merging past it.
- Merge cited agent branches with an ordinary merge, not a squash, so pinned
  commit links stay in the default branch's history.
- Link each artifact to the default branch and to its pinned commit. Audit every
  link in the final PDF against the repository, file and line anchor; a link
  checker that only finds broken links does not catch a wrong anchor.
- Commit the built PDF where the repository keeps papers, and add the result to
  the repository's results index with exact scope and verification status.
- After merging, close only the issues the release completes. Keep an issue
  open while its source question remains open, and post a status comment.

## 8. Announcement

Draft only; posting needs authorization. Name the source question's author and
precise reference (arXiv identifier, DOI or both), state exactly what is answered
and what remains open, name the languages and tools used, credit every agent,
and link the PDF on the default branch. Offer a thread under the platform's
length limit and a single long version.

## Credits

Sections 3–5 adopt practices observed in the public releases of
[Mira-Cult/math](https://github.com/mira-cult/math): strict axiom gates,
one-command replay packets, reviews bound to scientific revisions, import maps
and pinned environments. Their text is not reproduced; that repository has no
license.
