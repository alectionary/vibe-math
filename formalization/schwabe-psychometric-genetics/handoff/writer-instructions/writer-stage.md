# Stage 2: isolated standalone writing

Inputs: validated evidence packet, its relevant hashed files, approved template
and style requirements, this file and the manuscript reference. Read no prior
manuscript versions or research conversation. A separate context is preferred;
record the actual isolation available on the host. Do not claim a fresh context
when a continuing session merely rereads the files.

Produce the editable manuscript, bibliography, rendered PDF and writer manifest:
`{writer, context: "fresh", packet_sha256, inputs: [{path, sha256}],
claim_map: {CLAIM_ID: "section/table/page"}, limitations_map:
{"0": "section/page", ...}}`. The input list includes the packet, template,
stage instructions, and all evidence actually supplied. Copy immutable snapshots
of the template and stage instructions into the study handoff directory and
record their original path/revision separately; all manifest paths are relative
to the study root. The limitation map covers
every packet limitation by zero-based index. The claim map covers every claim,
including blocked ones; a dedicated inventory appendix may carry supporting detail.
Record the first-page excerpts and table regions using the
[first-page contract](first-page-contract.md). Identify/cite the original work,
state its headline finding, and show signed effects, magnitude and direction.
These maps are audit aids, not proof of completeness. Same-context work sets
`context: "shared"` and is a draft pending an isolated writing pass.

Write the scientific conclusion from the final evidence, not from a sequence of
updates. The first sentence of both abstract and introduction states whether
we replicated, partly replicated, failed to replicate, or could not establish
the dissertation's headline findings. Give the published-versus-ours values
and qualifiers appropriate to the evidence. A blocked comparison must not be
called nonreplication. Put limits immediately after the verdict; do not let a
supporting success substitute for an unresolved composite headline.

Every sentence must make sense to a reader seeing this paper for the first time.
Exclude earlier drafts, "results remain unchanged", "latest continuation",
permission retries, delivery status, and internal reviewer/agent exchanges from
all scientific text, captions and appendices. Rewrite the claim substantively:
"The fitted effect was 0.12" instead of "The effect remains 0.12."
Do not simply replace a few suspect words.

Preserve necessary methodological sequence (pilot then confirmatory study),
exploratory choices, source/software versions, reproducible commands, provenance
and comparisons to prior literature. "The original sample remains unavailable"
can be a valid present scientific limitation. "Previous studies found..." can
be legitimate scholarship. Explain what a time reference refers to; the words
"remains" and "previous" are not prohibited.

If a fact or limitation is missing, return a specific question to research and
await an updated packet. Do not infer success from inventory coverage or hide
unresolved dissertation chapters to make the opening simpler.
