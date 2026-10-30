# PDF repository-link audit and correction

Audit baseline: 6a0d42dbbd6d115d734c01c246b7e0616e668133.

The replication skill explicitly says "Code and data links in papers point at
`master`" (line246) and requires `blob/master` file navigation in the artifacts
appendix (lines265–269). Lines35–38 separately require a current-commit PDF
link for draft-PR review; lines197–199 distinguish master navigation from an
immutable reproduction revision. Those roles must not be conflated.

The baseline PDF had80annotations:50URI links and30in-document links.
34repository URI annotations (30unique targets) incorrectly used commit-pinned
file navigation:32annotations at ae9d1e8 and2at ed52777. Examples included
coverage.json onp2, analytical-completion.md onp12 and the reproduction READMEs
in AppendixA. These were commit URLs, not working-branch names, but still
violated the master-navigation rule.

The manuscript-wide repo macro had been changed to an immutable commit during
the standalone editorial rewrite. The recorded review accepted immutable file
snapshots. The frozen writer packet omitted the role-specific link requirement.
The delivery checker verifies pinned downloaded artifacts and accepts a textual
links-review field; it does not inspect PDF annotations for master navigation.
Thus a passing hash/delivery check was not evidence of this policy's compliance.
The failure was an incorrect editorial decision and a missing enforcement step,
not an absent skill instruction.

The corrected PDF uses38master navigation annotations covering32unique paths,
including clickable manuscript/bibliography filenames. A separate explicitly
labeled immutable reproduction-commit citation preserves provenance. External
source and software version citations are unchanged. The current-commit review
PDF link is supplied outside the manuscript in the PR and response.

check_repository_links.py checks every PDF URI, rejects unapproved internal
roles, and verifies each master destination path against the branch tree. It
reports master availability separately. At the audited remote master revision
e2b553c06c872d8008061a26d05831e572e54789, all32paths are absent: they await merge.
No live-master availability is asserted. This status belongs in this repository
record and delivery response, not operational chatter in the scientific paper.

The separate reviewer inspected changed pages19–21 and verified pages1–18 have
identical render bytes. All85annotations were inspected:38navigation,1provenance,
16external and30internal. No scientific result or reusable skill was changed.
