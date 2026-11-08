# Exact C16 pool inversion study

The original canonical target is **open**: width16 or18, best physical partial
frame88 pairs, no new Lean completion. This directory records the authorized
follow-up of 27 October 2026. [Written proofs and limits](../INVERSION.md).

The main certificate is `normal-form.json`: fixed ambient coordinates and
adjoint dual coordinates, complete rank-one tensor pools, nine-by-five
Cartesian dictionaries, thin-factor congruences, all1,024 type-rank profiles,
and the explicit transpose sector-exchange map. It is an exact source
representation. It does not assert a tensor-product form for a selected basis.

| Artifact | Established result | Limit |
|---|---|---|
| `normal-form.json`, independent consumer | All1,440 pool vectors and518,400 pairings retained; three types span at most125 | Necessary basis restrictions, no global nonexistence |
| `quotient1*` | Reduced dimension8 pool maximum exactly7, with witness and DRAT | Full-frame residue descent is unproved for the source |
| `counterexamples.json` | Generic cyclic descent and generic trace-product ruling reductions are false | Counterexamples do not satisfy all source-specific hypotheses |
| `triangular-support.json` | Every scalar matrix with exactly this support has rank>=128 over every field | The triangular minor has336 extra upper entries; it is not a frame |
| `omega-screen.json` | No candidate pair is removed by the first auxiliary-neighbor screen | No global parity obstruction or speedup demonstrated |
| `quotient2*`, `identity-quotient*` | Bounded trials returned UNKNOWN | No negative certificate, no full-C16 trial |
| `cartesian-*-control*` | Two specific small period-two controls are UNSAT with checked proofs | No general classification or lifting theorem |
| `controlled-factors.json` | All11 explicitly fixed-left-factor cases have right rank61<64 | Does not exclude arbitrary factor-line constructions |

From the repository root, the independent algebraic consumer uses only Python's
standard library:

```sh
python formalization/canonical-width/c16/verify_pool_inverse_structure.py formalization/canonical-width/c16/inversion-results/normal-form.json --output /tmp/c16-normal-form-check.json
```

For the full replay, use Python3.12 and `python-sat==1.9.dev17`, and build
DRAT-trim at the commit in `environment.json`:

```sh
python formalization/canonical-width/c16/replay_inversion.py --drat-trim /path/to/drat-trim --output /tmp/c16-inversion-replay.json
```

This checks57 frozen hashes, all coordinate/pool/type identities, a known
physical88-pair rank control, five rejected corruptions, two literal
counterexamples,19,645 small identity-decomposition controls, byte-for-byte
regeneration of five CNFs, the reduced seven-pair witness, the triangular
support minor, and all three successful DRAT proofs. Omitting `--drat-trim`
explicitly marks external proof replay as not requested. `verification.json`
records the complete successful replay including DRAT. None of these checks
adds a complete Lean target.

To regenerate the algebraic certificate:

```sh
python formalization/canonical-width/c16/pool_inverse_structure.py --output /tmp/c16-normal-form.json
```

The optional diagnostics `screen_inverse_omega.py` and
`screen_fixed_factor_construction.py` take the normal-form certificate as their
positional argument and `--output` for a new JSON file. They reproduce bounded
method checks. `quotient_inverse_model.py` takes `--period`, `--target`,
`--seconds`, `--kissat`, `--drat-trim`, and `--output`. Its default target is the
reduced dimension. A quotient result is explicitly labelled as such.
`inverse_identity_model.py` uses the pinned OR-Tools version and only permits
period1 or2; it has both a solver budget and its own child-process wall limit.
These commands are optional experiments, not part of proving the original
question. Solver runtimes need not reproduce exactly.

CNF and complete DRAT files are deterministically gzip-compressed. The unknown
period-two run's incomplete123MiB trace is omitted; its size/hash is retained
in `incomplete-trace-metadata.json`. The failed initial identity-model run,
which used an out-of-range random seed, is retained as a log; the retry and
its UNKNOWN output use the corrected seed. It is not counted as a solver result.

The source hashes bind to the original logical pools, already independently
bridged to the physical source construction in the previous study. The
manifest also pins reused encoder and pool-consumer dependencies. Historical
library-assessment notes are supporting software inspection, not an imported
Lean proof or a full-text literature screen. Current-resolution, exact-target
Lean discovery, earlier manuscript screens and authenticated X coverage remain
explicitly incomplete in [the access ledger](../inversion-prior-art.json).
