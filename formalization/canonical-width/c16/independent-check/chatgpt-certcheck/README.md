# Independent C16 certificate checker

Author: ChatGPT, OpenAI, 2026-11-07. **The exact model identifier/version is
not exposed by this execution runtime.** No more specific model/version claim
can be verified. The `chatgpt` directory/branch token is a product identifier,
not an invented model version.

Base: `research/c16-structural-20261027T173245` at
`420c5db40a889e5c92ad01b5af8ea17df09d36a6`.
Branch: `independent/c16-certcheck-chatgpt-20261107`.

## Independence and scope

Written from `CERT-SPEC.md` and `SPEC.md` only. No search code, reference checker,
paper, Lean files, other C16 scripts, or previous result files were read or
reused. Repository contents were cloned, but only explicitly allowed inputs
were inspected. A separate internal review examined this new implementation
against the same specifications, not the original implementation.

As stated on issue #76, CERT-SPEC is the controlling assignment; SPEC supplies
definitions and pools. CERT-SPEC's explicit input exceptions and known-answer
tests supersede SPEC's separate search assignment. This is a certificate
checker, not an independent exhaustive-search program or solver. No external
solver is used. Python standard libraries authenticate inputs/orchestrate;
C++17 and zlib implement the actual verification.

## Build and run

From repository root:

```sh
python3 formalization/canonical-width/c16/independent-check/chatgpt-certcheck/run.py all
```

Requires Python 3 and a C++17 compiler named `g++`, plus zlib development files.
Verified with GCC 14.2.0 and Python 3.12.14. Build alone:

```sh
cd formalization/canonical-width/c16/independent-check/chatgpt-certcheck
g++ -O3 -std=c++17 -Wall -Wextra check.cpp -lz -o check
```

`run.py tests` runs the mandatory tests and local mutations. `swap`, `half`,
and `swapT8` each rerun that gate and then the selected real class. `all`
runs the gate followed by all three real certificate groups sequentially.
It writes `results-<mode>.jsonl` and prints identical JSON lines. Each real
class's line aggregates every shard, including repeated upper-tree nodes.
Times measure the C++ process (input construction plus checking), not compilation
or Python hashing. A failed assertion stops the runner before subsequent groups.

**Use the Python entry point for authenticated checks.** Before parsing any input,
it checks all 21 manifest entries' full SHA-256 values and lengths, then rechecks
selected inputs immediately before each run. The low-level C++ executable does
not itself authenticate bytes; its CLI is `check CLASS XPOOL ZPOOL INSTANCE
CERT...`. All shards must be supplied together. Locally generated mutations and derived shard fixtures are
explicitly labeled and are the only deliberate exception to manifest membership.
The manifest is taken from the pinned repository commit, not independently signed.

## Method

* Parse pool integers with coordinate 0 as the low bit; reconstruct every entry
  of G by parity of AND. Check the real-pool sanity count of 99,808 ones.
* Enumerate every ordered pair, close its orbit under the specified generator,
  sort each orbit, and keep precisely the partial frames. Compare the complete
  generated set to the instance's pair sets; disallow duplicates and reject
  missing/extra items or differing vectors/mask/dimensions. Item line order is
  retained for interpreting certificate IDs; pair order is immaterial.
* Construct each item's entire 128-by-128 outer-product sum. Stream gzip records
  rather than loading the search tree. Maintain residual, chosen items and live
  items from scratch using the specified Done exclusion and pair compatibility.
* For rank leaves, form bases for the live X-vector span and live Z-vector span,
  first using index-count/span-rank upper bounds when already below need; otherwise
  compute their pairing matrix and perform binary elimination. This is exact:
  writing the original vectors in these bases factors G as U H V^T with U,V
  full-column-rank. Left/right inverses show rank(G)=rank(H).
* Require exact cover membership/uniqueness, valid residual entries, size checks,
  and complete EOF after `END COMPLETE`. F cannot establish nonexistence.
  At need zero independently verify and print the full frame before reporting
  FRAME, as required; no nonexistence conclusion is made from its remaining file.
* Permit S only at the declared shard depth. Require all unique shard IDs, equal
  metadata, identical boundary paths, residual-entry choices, live-item states,
  and ordered covers, and exactly one C/K owner per boundary child. Comparing
  live states prevents a different earlier child order from silently changing
  the state another shard is purportedly proving. Paths determine P and residual.

## Why acceptance proves nonexistence

The identity-pairing condition on a 128-pair frame makes its X and Z matrices
invertible, so its outer-product sum is identity. A frame extending P therefore
has remaining sum equal to the computed residual. A set residual bit needs at
least one covering item. At a branch take the first covering item belonging to
that frame: all earlier children are absent, and all other remaining items are
compatible, so the frame survives into exactly the checked child state. An
oversized item cannot fit. An empty cover contradicts the required residual bit.
A rank leaf contradicts the identity pairing of size `need` on the remaining
pairs, which would have rank at least `need`. Matching, uniquely covered shard
boundary states supply the omitted subproofs. Induction from leaves to the root
therefore rules out any frame in the class. No search heuristic is trusted.

## Tests and results

Full machine-readable records (including the planted frame) are in
`results-all.jsonl`. The result table below is generated from those completed records.

Known-answer requirements: quarter ACCEPT with 15,088 nodes; all three supplied
bad certificates REJECT; planted quarter FRAME with all 128 pairs checked.
Local tests: dropped child, changed entry (including an in-range zero residual
bit), R-to-E, E-to-R, changed item ID (including an in-range invalid cover item),
illegal unsharded S, and trailing data. These target semantic verification, not
just a failed checksum; locally altered certificates go directly to C++ after
all original inputs are authenticated.

Additional shard tests derive a two-file root split directly from the
authenticated quarter certificate. The valid pair is ACCEPT; a missing file,
duplicate C/K ownership, and duplicate shard IDs are each REJECT. These are
reproducibly generated in a temporary directory by `run.py`, not obtained from
any search/reference implementation. `results-all.jsonl` contains these additional checks. The final all-mode run
includes every mandatory and added test before the real checks. An earlier
unoptimized half run was stopped without a conclusion; no unfinished
verification is counted as acceptance.

### Completed run table

| Run | Result | Items | Nodes | Rank leaves | Empty leaves | Seconds |
|---|---|---:|---:|---:|---:|---:|
| test-quarter.cert.gz | ACCEPT | 8,940 | 15,088 | 12,830 | 805 | 1.3271 |
| test-bad-1.cert.gz | REJECT | 8,940 | 251 | 238 | 0 | 0.0574877 |
| test-bad-2.cert.gz | REJECT | 8,940 | 1 | 0 | 0 | 0.0384542 |
| test-bad-3.cert.gz | REJECT | 8,940 | 3 | 0 | 0 | 0.0378449 |
| test-planted.cert.gz | FRAME | 11,904 | 26,008 | 23,398 | 844 | 1.82446 |
| mutation:drop-child | REJECT | 8,940 | 1 | 0 | 0 | 0.0384036 |
| mutation:change-entry | REJECT | 8,940 | 1 | 0 | 0 | 0.0394162 |
| mutation:R-to-E | REJECT | 8,940 | 3 | 0 | 0 | 0.0405984 |
| mutation:E-to-R | REJECT | 8,940 | 251 | 238 | 0 | 0.0535505 |
| mutation:change-item-id | REJECT | 8,940 | 1 | 0 | 0 | 0.0352571 |
| mutation:unsharded-S | REJECT | 8,940 | 1 | 0 | 0 | 0.0360277 |
| mutation:trailing-data | REJECT | 8,940 | 15,088 | 12,830 | 805 | 1.29258 |
| mutation:valid-two-shard-split | ACCEPT | 8,940 | 15,089 | 12,830 | 805 | 1.27327 |
| mutation:missing-shard | REJECT | 8,940 | 6,806 | 5,846 | 325 | 0.585247 |
| mutation:duplicate-shard-ownership | REJECT | 8,940 | 13,612 | 11,692 | 650 | 1.15265 |
| mutation:duplicate-shard-id | REJECT | 8,940 | 15,089 | 12,830 | 805 | 1.29333 |
| swap | ACCEPT | 7,936 | 69,180 | 12,308 | 32,008 | 3.32191 |
| half | ACCEPT | 38,192 | 9,996,689 | 8,166,970 | 295,645 | 828.59 |
| swapT8 | ACCEPT | 49,904 | 50,404,337 | 41,881,074 | 1,065,196 | 3992.7 |

### Final verification

All 21 manifest-listed files passed full SHA-256 and byte-length checks, both
before use and again after completion. The complete runner exited zero. The
C++ build used `-Wall -Wextra` without warnings; Python byte-compilation passed.
No whole-repository build or unrelated test suite was run, respecting the
independence boundary. `provenance.json` pins the verifier, runner, manifest and
result-file hashes. The planted frame is explicitly included in the JSON line.

Interpretations were coordinated on [issue #76](https://github.com/alectionary/vibe-math/issues/76),
including the certificate author's confirmation in
[comment 6711198680](https://github.com/alectionary/vibe-math/issues/76#issuecomment-6711198680).
