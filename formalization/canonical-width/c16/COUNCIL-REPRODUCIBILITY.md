# C16 recovery and replay for a new investigator

The GitHub branch is the durable source. The former `/private/tmp` worktrees
and runtime directories are disposable. On October 31, the former shared-master
worktree was absent, so a fresh durable checkout was restored from published
commit `e264f4775a73365ebdb5d73f502a518d02de3540`. No scientific files were
modified and no new mathematical replay or optimizer run was needed for the
documentation handoff.

## Obtain the handoff

On a new machine, use a fresh destination. The following limits checkout to
the C16 work and its relevant records; repository-root files are included by
Git's cone mode. Omit sparse checkout if broader repository work is needed.

```sh
git clone --filter=blob:none --no-checkout --single-branch \
  --branch research/c16-shared-master-20261030T2207 \
  https://github.com/alectionary/vibe-math.git c16-takeover
cd c16-takeover
git sparse-checkout set formalization/canonical-width/c16 .agents literature planning
git checkout
git rev-parse HEAD
git status --short
```

Compare HEAD to the takeover commit linked at the top of issue 8. Read
`C16-START-HERE.md`. The immutable scientific publication is `e264f477...`;
the later handoff commit adds documentation and an integrity receipt only.
The original five-stage replay is recorded in
`shared-master-results/clean-replay-3129963.json` and its adjacent inventory.

## Absolute-path limitation in the frozen replay

This corrects the broad portability wording at the end of the earlier
`SHARED-MASTER-RESUME.md`; preserve that historical file unchanged.

The frozen controller and worker map the executing source root and two older
worktree roots. They do **not** also map the original shared-master root when
executing from an arbitrary new directory. The final projection JSON and tiny
solver command contain paths under
`/private/tmp/c16-shared-master-20261030T2207/formalization/canonical-width/c16`.
A differently located source checkout is therefore not an accepted unmodified
replay source. This was found by inspection of the source bindings and resolver;
it does not invalidate the original accepted replay.

Two options are available:

1. Recreate a clean checkout at the exact historical path and scientific
   checkpoint below, without overwriting anything already there.
2. Write a **new versioned alias adapter** and independently test its path/hash
   restrictions before claiming arbitrary-location replay. This handoff does
   not implement or validate that adapter.

Do not change paths inside frozen input JSON, solver commands or consumers;
that changes the hash-bound scientific record. A symlink is not a sufficient
substitute when `Path.resolve()` resolves it to a different root.

## Unmodified certificate replay recipe (macOS/POSIX)

Prepare a clean source checkout at
`/private/tmp/c16-shared-master-20261030T2207`, with HEAD exactly
`3129963fcac399fe3422429aeed7247dbc2c9dd1`. It must contain the whole C16 directory.
On this Mac an old worktree registration may remain even though its directory
is gone. Inspect `git worktree list --porcelain` before choosing recovery;
do not force past an occupied path or overwrite another investigator's work.
A fresh independent clone at the absent historical path also avoids stale
worktree registration. Retain the durable handoff checkout separately.

The static dependency audit found Python, Git, NumPy and SciPy. The recorded
runtime was Python 3.12.14, NumPy 2.5.4 and SciPy 1.18.1. Create/verify a fresh
virtual environment; do not assume `/private/tmp/c16-venv` survives. HiGHS,
SoPlex, GMP and MPFR are **not needed for these five saved-certificate gates**;
their hashes in the records describe the original solver provenance. Any new
optimization needs its own verified solver setup and fresh runner/deadline.

From the historical checkout's `formalization/canonical-width/c16` directory,
replace the interpreter placeholder and choose unused output paths:

```sh
env OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 \
  VECLIB_MAXIMUM_THREADS=1 NUMEXPR_NUM_THREADS=1 BLIS_NUM_THREADS=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  nice -n 19 /path/to/replay-venv/bin/python -B \
  replay_shared_master_checkpoint.py \
  --checkpoint 3129963fcac399fe3422429aeed7247dbc2c9dd1 \
  --plan shared-master-results/clean-replay-plan-v1.json \
  --copy-root /private/tmp/c16-takeover-replay-20261031 \
  --output shared-master-results/takeover-replay-20261031.json
```

The controller requires exact niceness 19, all six thread variables equal to 1,
a clean tracked HEAD matching `--checkpoint`, an absent copy directory outside
the source, and an unused output receipt. It checks Git blobs and SHA-256,
copies the declared closure, and launches five consumers. Each stage has a
180-second cap; no optimizer runs, and workers reject process creation.
Budget at least 866.7 MB for the copied closure in addition to checkout/runtime.

The accepted historical replay had 2,164 inputs totaling 866,710,319 bytes,
five passing stages, zero original research reads and 41.83 seconds elapsed.
That is a historical measurement, not a promised runtime on another machine.
The October 31 handoff performs a fresh byte/Git integrity check against that
saved closure, **not a fresh execution of those five mathematical gates**.
Its receipt is `council-handoff-results/artifact-integrity-20261031.json`.

Preserve any new replay outputs under new names. Accept only all five stated
statuses with unchanged input bytes and the declared access boundary; do not
turn a failed replay into a pass by weakening path or hash checks.
