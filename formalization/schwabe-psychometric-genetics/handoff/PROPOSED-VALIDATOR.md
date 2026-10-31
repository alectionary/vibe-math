# Pinned proposed validation tooling

This study uses proposed skill commit `a322dd8b40bba924516df55c121d147aeb0b377a`
(PR66, unmerged), explicitly authorized for isolated validation. It is not a
claim that current master contains this extension. No reusable skill files or
frozen scientific code were changed in this branch.

From the repository root, obtain the exact tooling into a fresh temporary directory:

```sh
git fetch origin a322dd8b40bba924516df55c121d147aeb0b377a
mkdir -p /tmp/schwabe-skill-proposed-a322dd8
git archive a322dd8b40bba924516df55c121d147aeb0b377a .agents/skills/replication-paper | tar -x -C /tmp/schwabe-skill-proposed-a322dd8
```

Use `handoff/claim-specification-applicability.json` as the final packet builder's
source specification, and the staged proposed `scripts/stage_checks.py` as its
validator. The original source inventory remains unchanged. The derivative adds
only explicit comparison-applicability declarations; its recursive diff audit
retains every original value, condition, contrast and relationship.

Continue to pass the ORIGINAL `handoff/claim-specification.json` to the frozen
Chapter6 mapper, which is hash-pinned to that reviewed input. Join its outputs by
the identical IDs and retained contrasts into the final applicability-aware packet.
Do not change the mapper or infer different scientific verdicts from schema fields.

Nonscalar parents retain all component IDs and all indexed parent comparisons;
those comparisons remain evidence even when only the parent is displayed on page1.
Actual packet and manuscript acceptance require the proposed contract's checks,
including the fresh review's `comparison_applicability` finding. Tool installation
and fixture passes are not scientific or editorial acceptance.
