# Inverse-pool continuation: replay and scope

The original C16 width remains **16 or18**, with a checked physical partial
frame of88/128 pairs. No Lean target is completed here. The four-hour block
runs2026-10-27T20:22:23Z through2026-10-28T00:22:23Z; this is its working
artifact bundle. See `../INVERSE-FOUR-HOURS.md` for the mathematical statements.

## Checked results

1. Every full original minimum-pool frame uses **at least three thin families
   in each sector**. The finite span/annihilator bridge forces a64-dimensional
   block if a sector uses only two; its necessary moment SDP has an exact dual
   contradiction. Sector exchange transfers the obstruction.
2. Three specific three-family supports, `{0,1,2}`, `{0,1,4}` and `{1,2,4}`,
   are excluded independently in either sector by exact source-rank SDP duals.
   Seven other triples and four/five-family frames remain open.
3. Aggregate residue descent fails even with the original ring, residue point
   sets, exact five thin-factor orbits, thick projective directions,61-dimensional
   thin modules and transpose exchange retained. The explicit enlarged pools
   have1680 points per sector (21-by5 dictionaries), adding12 thick scalar
   R-rays. The full128-pair witness is **not an original-pool frame**.

The dual certificates have two independent positivity routes. The original
consumer uses256-bit Arb Fourier bounds. The primary new route splits the cyclic
representation into integer periodic-difference subspaces and checks rational
congruences by **integer matrix multiplication and strict diagonal dominance**.
It performs no floating-point operations. Numerical optimization finds candidates;
it is not part of either proof consumer.

## Primary replay

From the repository root with Python3.12, `python-flint`0.9.0 installed:

```sh
python formalization/canonical-width/c16/verify_three_thin_theorem.py formalization/canonical-width/c16/inverse-four-hour-results/block4-dual64.json --rational-psd formalization/canonical-width/c16/inverse-four-hour-results/block4-rational-PSD.json.gz --output /tmp/c16-three-thin-check.json
python formalization/canonical-width/c16/rank_moment_dual.py formalization/canonical-width/c16/inverse-four-hour-results/rank-dual012.json.gz --rational-psd formalization/canonical-width/c16/inverse-four-hour-results/rank-dual012-rational-PSD.json.gz --output /tmp/c16-rank012-check.json
python formalization/canonical-width/c16/rank_moment_dual.py formalization/canonical-width/c16/inverse-four-hour-results/rank-dual014.json.gz --rational-psd formalization/canonical-width/c16/inverse-four-hour-results/rank-dual014-rational-PSD.json.gz --output /tmp/c16-rank014-check.json
python formalization/canonical-width/c16/rank_moment_dual.py formalization/canonical-width/c16/inverse-four-hour-results/rank-dual124.json.gz --rational-psd formalization/canonical-width/c16/inverse-four-hour-results/rank-dual124-rational-PSD.json.gz --output /tmp/c16-rank124-check.json
python formalization/canonical-width/c16/verify_inverse_lift.py formalization/canonical-width/c16/inverse-four-hour-results/canonical-exact-thin-counterexample.json --output /tmp/c16-enlarged-check.json
```

Omit `--rational-psd` to use the separate Arb route (NumPy/SciPy also required).
`test_block_moment_dual.py`, `test_rank_moment_dual.py` and
`test_rational_cyclic_psd.py` provide known physical/identity controls and rejected
corruptions. The normal form itself is rechecked by
`verify_pool_inverse_structure.py`; it checks all518400 original pool pairings.

To regenerate a rational PSD preconditioner, run `rational_cyclic_psd.py DUAL
--generate --preconditioners OUTPUT.json.gz --output CHECK.json` with NumPy/SciPy.
The supplied preconditioners are only untrusted integer matrices: replay checks
their complete congruence and every diagonal-dominance inequality exactly.

To regenerate a numerical rank dual, extract the `rank_rectangles` with
`conditional:true` from the corresponding decompressed certificate, and pass
that list to `certify_rank_moment_dual.py --families ... --rank-X
.../rank-rectangle-X.json --rank-Z .../rank-rectangle-Z.json --conditional-cuts
LIST.json --output OUTPUT.json`. CVXPY1.9.3/SCS3.3.1 are discovery dependencies.
A numerical status is not a replacement for replay of the resulting exact dual.

## Experiments and limitations

`rank-rectangle-*.txt` supplies45 cyclic orbits of16 vectors, ordered by thin
family then thick type. `source_rank_rectangles.cpp` regenerates the6283
nontrivial rectangular rank bounds per sector. Rank-dual consumers recompute
applicable ranks independently using epsilon-polynomial arithmetic.

`thin-frontier-screen.json` screens all20380 frozen unresolved search leaves:
zero are newly excluded. `basis-walk-comparison.json` compares fixed200000-step
runs for two seeds: the three-family constraint and short-word tie-breaker do
not improve the previous physical88-pair result. Best new full-basis walks give
84 allowed duals. Period-two14-pair progress is only a projected problem.

The full-source strengthened moment models, half-turn model and several integer
models remain uncertified/undecided. `optimal_inaccurate`, a positive objective,
UNKNOWN, or a time limit is never treated as an exclusion or a frame. In
particular the principal-block margin trial fails the independent full-PSD
check; see `joint-margin-numeric-check.json`.

The Boolean triangle, source-circuit and affine-integer-form experiments retain
arbitrary source frames. The latter use S(S-1)>=0 for an integer affine form S;
FLINT LLL discovers candidate inequalities, and exact Boolean/translation
controls check their expansion. This demonstrates separation of tested fractional
moments, not a completed global proof or runtime speedup.

`experiment-recipes/` preserves historical owned commands with their original
scratch paths and bounded settings. Rebind those paths to the archived inputs
before replay. The main proof consumers and reusable cut discovery modules use
repository-relative sources. `prior-art-access.json` records actual bounded
GitHub/X searches, the unopened academic lead and remaining coverage gaps.
No OpenAI/math code was imported or built in this block.
