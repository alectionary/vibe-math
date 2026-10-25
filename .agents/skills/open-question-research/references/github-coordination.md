# GitHub research coordination

Use a canonical issue for the research record, an immutable remote claim for
exclusive ownership, and an optional repository-linked GitHub Project for overview.
The mathematical inventory remains authoritative for resolution and Lean status.

## Check access and reuse existing records

Discover a connected GitHub tool or use authenticated `gh`. Check actual access
to the upstream repository's issues and Git contents; check the owner's Projects
only when a board is requested. With GitHub CLI, `gh auth status`, `gh repo view`,
and `gh project list --owner alectionary --format json` cover different capabilities. Classic OAuth tokens
need the `project` scope for Projects; fine-grained credentials need the
corresponding repository and owner Project permissions. Never print tokens.
Authentication, repository writes and Project writes are separate checks.
The classic token scope `read:project` permits listing but not creating or
editing Projects. If the user skips Projects, finish issues and claims without
requesting broader access or treating board failure as a repository-write block.

Search all issue states by canonical ID and inspect existing claims. Follow-up
IDs belong in the parent issue; claim the canonical parent unless investigators
explicitly agree to independent scopes. If issue creation races, consolidate
discussion in one canonical issue; duplicate issues do not grant ownership.

When a board is requested and accessible, reuse the repository-linked research
Project. If none exists and creating one
is authorized, create `vibe-math research` under `alectionary`, link it to
`alectionary/vibe-math`, and create a board view grouped by Status. Preserve
existing visibility. Do not call a default table a verified board view. Record
the returned project ID, number, board URL and field/option IDs; do not guess IDs.

With `gh`, discover projects and fields before using `gh project item-add` or
`gh project item-edit`. `gh project link` links a Project to a repository;
adding an issue alone does not establish that link. If the installed CLI lacks
view creation, inspect the current GitHub Projects API instead of claiming the
layout was configured. Use actual issues as items, not duplicate draft cards.

## Prepare the issue and acquire ownership

Put these in the issue: canonical ID, bounded follow-up ID, exact source and
question, hypotheses, answer contract, existing evidence, missing bridges,
stopping condition, work branch and claim state. Keep the issue useful to an
investigator who has not read the chat. For multiline CLI bodies, use a file
with `--body-file` so shell interpretation cannot alter mathematical notation.

Include a prior-work summary distinguishing an earlier proposal, finite search,
partial proof and completed result, with direct artifact links. Name precisely
what this block would add. Issue creation time is not the question's origin.
When research is deferred by the user, use **Reserved — awaiting user instruction
to begin**, retain the agreed reservation, and state that the study has not
started. Change to active only after research is authorized; do not infer that
authorization from acquiring a claim or editing the skill.

Create a unique work branch in an isolated clone/worktree. Commit the answer
contract and ownership metadata: unique session ID, UTC start time, canonical
ID, bounded scope, issue URL, work branch and intended next action. Publish
that commit on the work branch within the authorized scope. It is preparation,
not ownership. This keeps the claim's commit available on the server.

Acquire `refs/heads/claims/<canonical-id>` using GitHub's **Create a reference**
endpoint, pointing to that exact commit. For example, with shell variables
populated from verified values:

```sh
gh api --method POST repos/alectionary/vibe-math/git/refs \
  -f "ref=refs/heads/claims/$canonical_id" -f "sha=$claim_sha"
```

Proceed only after successful creation and a read-back of the exact reference
and ownership commit. An already-existing ref means another reservation exists;
other API failures do not all mean contention. If a request times out, inspect
the ref and unique commit metadata before retrying. An ordinary branch push,
including a non-force push, is insufficient: two agents can push the same base
SHA successfully. Keep the claim ref fixed while work commits advance separately.

If using a Project, add the issue and read it back with its Status. Use Todo for a
reserved next block, In Progress only while research runs, and an existing
blocked option when appropriate. Keep session ownership in the claim/issue,
not just the GitHub account assignee. Report separately if the reservation
succeeds but Project synchronization fails; do not create another claim or
another Project to hide a partial failure. An omitted board does not invalidate
an issue and successfully acquired claim.

## Handoff and release

Record the result, evidence, remaining question and next owner/action in the
issue. A reserved next block may remain Todo if the user requested a continuing
reservation; explicitly say who holds it. Otherwise release this session's claim
at block closeout. An elapsed timestamp is not an expiry or takeover permission.

Before release, read the claim and verify its session metadata. Delete only the
expected commit, using an expected-SHA operation such as:

```sh
git push --force-with-lease="refs/heads/claims/$canonical_id:$claim_sha" \
  origin ":refs/heads/claims/$canonical_id"
```

Preserve the work branch and evidence. Read back the issue, claim state and any
Project item before reporting success. Close an issue only if its stated question
is answered or explicitly retired; completion of one bounded follow-up can
leave the canonical source question open. During this workflow, do not merge
shared inventory changes or reset another agent's checkout implicitly.

## Verified repository example

The [October 25 reservation](https://github.com/alectionary/vibe-math/issues/1)
uses `claims/L-F25-distance-preservation` for follow-up
`RQ-F25-truncated-distance-12`. Creation and owner read-back succeeded; a second
create returned `422 Reference already exists` without changing the claim SHA.
Projects were explicitly skipped after a read-only Project token failed creation.
Use the live reference and issue for current ownership, not this dated example.
