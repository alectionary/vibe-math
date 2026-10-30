# Resume the C16 coupling investigation

The original question remains **width16 or18**. A conclusive answer requires
an independently verified physical128-pair weight16 frame, or a complete
source-valid obstruction to every such frame. The sufficient cover remains
405, best checked partial frame88/128, and full source anchors excluded0.
No new Lean completion is claimed.

The six-hour block began2026-10-30 05:14:33Z and ends11:14:33Z. Its work branch
is `research/c16-coupling-20261030T0514`; PR17 uses
`research/c16-structural-20261027T173245`. See issue8 for the final published
commit and coordination-claim status. The old user-requested pause was
revoked. An expired computation budget or released coordination claim is not
a pause of the research objective. A new authorized block must check and
acquire its own create-only claim; do not reuse this block's ownership SHA.

## Exact starting point and scope

Use `coupling-results/integer-witness15-rational.json.gz`, SHA256
`5f9a622e68a3c1e842ae13a5a5b18cf06b388515b5821d17eda2389375b290ef`.
It satisfies the recorded finite intersection:54 partner rows,234 added
integer-form rows,308 rank rows, older conditional/circuit/legacy families,
PSD and profile constraints, and every Boolean triple. Its seven-stage
summary is `coupling-results/integer-witness15-checks-summary.json`.
This is a fractional necessary-model point, not a full frame.

The complete effective discovery command and all source bindings are in
`coupling-results/integer-witness15-frozen.json`; the human-readable lineage
is `coupling-results/integer-witness15-derived-command.json`. Last command-line overrides
control the effective margins. Positive margins are sufficient-only aids
to rational recovery: their infeasibility cannot prove the necessary model
infeasible. Use a new trial name and new files for any successor.

Do not transfer certificates between points:

| Certificate | Frozen point | What it establishes |
|---|---|---|
| Unconditional45-basis mixture | witness12 | Every unconditional rank inequality holds |
| 27 lattice certificates plus exact anchor40 mixture | witness12 | 28 individual present-conditioned rank laws hold;12 cuts and5 inconclusive anchors are separately recorded |
| Two four-X count extensions | witness10 | Exact feasibility of the selected count-only extensions |
| Two two-X/two-Z count extensions | witness12 | Exact feasibility with common anchor patterns, without rank or unanchored mutual pairing |
| Latest anchor40 exchange state | witness15 | Valid exact mixture with nonzero residual; membership remains inconclusive |

The anchor17 eager/lazy witness12 states and the anchor40 witness15 state
are preserved for restart. Their errors are positive. The union of the two
anchor17 column sets also produced no usable primal result. Neither a
timeout nor a numerical UNKNOWN supports an infeasibility claim.

## Recheck before extending

On the original Mac, the interpreter is `/private/tmp/c16-venv/bin/python`.
The recorded runtime is Python3.12.14, NumPy2.5.4, SciPy1.18.1,
CVXPY1.9.3 and SCS3.3.1; exact recovery also uses python-flint.
The frozen native library is platform-specific; rebuild and revalidate its
kernel before using it on a different platform. Existing exact consumers
provide the acceptance boundary.

From `formalization/canonical-width/c16`, run:

```sh
/private/tmp/c16-venv/bin/python replay_coupling_point15.py \
  --output-dir /private/tmp/c16-new-point15-replay
```

Choose a nonexistent output directory. The wrapper checks689 scientific
input hashes before and after, runs the original seven consumers, and
requires byte-identical rational recovery. Read the final summary: a zero
exit code from an individual solver is not the acceptance criterion.
For a new machine, select a suitable interpreter with the recorded packages.

The broader36-stage source replay is archived under
`coupling-results/final-clean-checkpoint0957/`, at immutable commit
`1e852eea43956cbc38759e5182e6f3df9bb782d7`. The later clean checkout of
`043a5bdca1b1691dee56e8ea164d959776729680` replays fourteen fresh stages,
including the seven exchange checks and seven point15 checks, and verifies
all old source bindings are unchanged. Its archive is
`coupling-results/final-clean-checkpoint043a5bd/`.
Historical source-pool/cover proof chains were not rerun in this block;
their prior evidence remains explicitly separate.

## Follow-up gates

The main unresolved issue is compatibility of the individual distributions.
Use the precise derivation in
`coupling-results/exchange-to-joint-profile-next-gate.txt`:
the775-coordinate single-orbit projection is a convex hull of complete
physical compatible-basis columns. A candidate separator is accepted only
after exact maximization over every allowed profile and independent physical
replay. A positive numerical master objective is insufficient. Membership
requires exact nonnegative weights, or exact conditional basis mixtures for
every positive profile block with all shared equations satisfied.

The180-second small-master pilot at witness15 is inconclusive. It retained
312 active and1431 historical columns; all767 proposed normals had
nonpositive exact gaps. It is an implementation successor to earlier L1
pilots, not a new relaxation or a demonstrated source-search speedup.
The saved sample's missing14 feature directions are not universal identities:
physical counterexamples are preserved by the final affine-span diagnostic.
The independently checked772-column seed proves the full auxiliary affine
dimension is771. Only the three known homogeneous identities can be
eliminated. Use `coupling-results/saved-span-affine-completion.columns.npz`
as a span seed if useful; its positive weights do not represent the target.

A stronger structural follow-up is to upgrade the existing two-X/two-Z
count model to full physical bases on both sectors. Fix one of its16 anchor
patterns, contract forced zero-pool elements, fix required owner choices,
delete absent anchors and optimize signed weights by exact matroid greedy.
The two sector optimizations separate within a fixed pattern; the shared
pattern weights remain coupled in the master. This retains rank on both
sides while still relaxing unanchored mutual pairing. The derivation and
required source/mapping controls are in `two_sided_full_basis_next_gate.md`;
complete those controls before a timed pilot. No two-sided2X+2Z full-basis
oracle has yet been implemented; the existing four-X oracle is one-sided.

Set a finite gate budget before running it. Accept either an exact projected
cut, exact membership in the stated relaxation, or an explicit inconclusive
endpoint. Reinsert any accepted cut into the combined necessary model and
repeat exact recovery. A projected cut excludes the saved fractional point;
only infeasibility of a source-necessary system would prove width18.

## Literature and publication

F173, Cunningham1984, is an abstract-level algorithm lead. The full-text
request is [issue63](https://github.com/alectionary/vibe-math/issues/63).
Inspect its actual algorithm and proof before claiming that our exchange
implementation has a polynomial runtime bound. Question count remains null
until a complete readable text is screened. No paper or library result is
needed to validate the already checked exchange endpoint.

Update the existing canonical records, not a new source-question entry.
Keep failed recoveries, negative gates and exact-point scopes. Required
master review remains in force; do not bypass it. The final report contains
the requirement-to-evidence table and publication status.
