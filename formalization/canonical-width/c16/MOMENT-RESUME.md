# C16 moment research: exact continuation point

The user explicitly restored the goal. It is **not paused** and the source
question is **not answered**. The four-hour block began2026-10-30T00:25:01Z
and ends04:25:01Z. Its experimental runs are finished. The source remains
width16 or18, sufficient selected-pair cover405, physical partial frame88/128,
and zero full source anchors excluded. Do not restart an old cover sweep or
count a local-moment exclusion as a full source case.

Scientific revision: `2c0824788c162ab24579c7311b08f112ec9d747b`.
Work branch: `research/c16-moments-20261030T0025`.
PR17: <https://github.com/alectionary/vibe-math/pull/17>.
Issue8: <https://github.com/alectionary/vibe-math/issues/8>.
The PR requires review; no master integration is claimed. The active goal and
remote research claim are distinct: acquire a fresh create-only claim before a
new block after this block's claim is released. Existing user authorization to
continue is not a request to pause again.

## What is certified

`moment-resumption-results/boolean-rational1.json.gz`, SHA-256
`d1b45692b268f5618b9ea710befcc5f1bdacbd86ef4014da354e2a1b492011b8`, is an
exact feasible point of the listed old families,280 closed-rank rows,all213662
saved global-obstruction conditional rows,and every Boolean triple. It is not a
physical frame or a common distribution on all events.

Two final additions strictly exclude that point:

- `final-point-rank-probe.json`: five independently checked conditional-rank
  rows. Maximum exact violation `33902180140403/562949953421312`.
- `common-profile32-projected-pruned.json`: an independently checked12-anchor
  shared-orbit functional involving **only first/second moments**, with exact
  violation `5539176242857167/565201753234997248`. The shape weights are free;
  do not reintroduce the caveat belonging only to the earlier fixed-weight cut.

The intersection with these final additions has **not been solved**. This is
where research should continue. The global SAT trial remainsUNKNOWN; its saved
physical/source/CNF replay passes. No newly acquired paper or Lean completion
is hidden in these auxiliary results.

## Immediate implementation and mathematical gate

Use the existing full-profile necessary model and its adaptive row mechanism.
The last feasible numerical seed is `boolean-interior1.npz`; the final old-family
active row file is `boolean-active1.json`. Preserve both source-rank banks:
`closed-rank-bank-augmented.json` with its independent receipt, and the five-row
`final-point-rank-probe.json` with its independent receipt. Retain the Boolean
banks `consolidated-all-triples.json` and `boolean-all-triples0.json`, and screen
all triples again after solving. A zero response from a bounded rank separator
is not complete rank-polytope membership.

The projected shared-profile cut has an especially simple translation. If
`u = cut['unconditional_coefficients']`, `o=32`, and each retained anchor has
sector B in S/T, orbit a, and coefficients c_0,...,c_16, impose

    u_0 + 16 u_1 p_o + 16 sum_{h=1..8} u_{h+1} S_h[o,o]
      + sum_anchors (c_0 p_a + sum_{h=0..15} c_{h+1} B_h[a,o]) <= 0.

Here `u=[-1,-16,8,8,6,7,8,7,7,4]`, and phases9..15 use the transposed
phase16-h matrices. The saved certificate supplies all anchor coefficients.
Before using a new compiler, compare its row with this exact rational evaluation
and with literal32-action cyclic/sector averaging. The function's independent
all-mask verifier does not depend on a conic solver or LP status.

`unified_boolean_interior_model.py` is a **sufficient witness generator**: it
imposes positive PSD and Boolean margins. A failure or infeasible result there
cannot exclude source frames. To seek an obstruction, the model must remove
those artificial margins and retain only necessary conditions. An accepted
obstruction needs exact dual/source verification, not a numerical status.
A recovered feasible point must pass every family, all triples and the new
projected cut, not only the active row subset.

A bounded next gate is one necessary-model compilation with exact translation
controls, a capped solve, and exact feasibility/obstruction recovery. If another
feasible point is certified, its missing shared-distribution conditions can be
probed with the same hinge-function method. Do not infer a finishing-time bound
from these steps or run indefinite row generation without a new stopping gate.

## Reproduce the exact acceptance checks

Run from `formalization/canonical-width/c16`. The session used Python3.12 with
numpy, scipy1.18.1, python-flint, cvxpy1.9.3 and SCS3.3.1. Set the BLAS/OpenMP
thread limits to1. The environment is `/private/tmp/c16-venv/bin/python` on the
current Mac; rebuilding it elsewhere does not require the exploratory solvers
for the integer shared-profile and rank consumers beyond their imports.

```sh
python verify_unified_moment_point.py \
  --certificate moment-resumption-results/boolean-rational1.json.gz \
  --old-replay moment-resumption-results/boolean-old-replay1.json \
  --matroid-cuts moment-resumption-results/closed-rank-bank-augmented.json \
  --matroid-replays moment-resumption-results/closed-rank-bank-augmented-independent.json \
  --separating-cuts moment-resumption-results/final-point-rank-probe.json \
  --separating-replay moment-resumption-results/final-point-rank-probe-independent.json \
  --output /tmp/c16-unified-replay.json
python verify_all_triple_distributions.py \
  --point moment-resumption-results/boolean-rational1.json.gz \
  --output /tmp/c16-triple-replay.json
python verify_common_profile_cut.py \
  --bank moment-resumption-results/common-profile32-projected-pruned.json \
  --point moment-resumption-results/boolean-rational1.json.gz \
  --output /tmp/c16-projected-replay.json
```

The complete ten-stage clean replay, including global conditional consequences,
closure dominance and both profile-cut variants, is saved in
`moment-resumption-results/final-clean-replay/`. Its frozen commands use the
old temporary checkout path; adjust paths when relocating. It completed in
44.46seconds with a clean worktree before and after. The unchanged full global
source/CNF replay took430.23seconds separately and is not part of that44-second
number. Deliberately corrupted projected certificates are kept under
`final-negative-controls/` and must be rejected.

The separate runtime-integration branch remains parked and unadopted. Its53
checks and slower median benchmark do not belong to this research result.
