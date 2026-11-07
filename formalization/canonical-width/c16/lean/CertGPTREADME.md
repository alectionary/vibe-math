# ChatGPT certificate checker: partial formalization

**Status: `no_swap_frame` is not proved.** This branch must not be cited as a
kernel-checked nonexistence theorem. It supplies an executable checker, a proved
search kernel, and concrete mathematical bridges, but the final soundness
instance and root correspondence remain open.

Branch: `independent/c16-lean-cert-chatgpt-20261107`, based on research commit
`7cdf520a98801f24bd5c9cbd33f0373be33549ff`.

Author: OpenAI ChatGPT. The exact model/version identifier is not exposed to this
execution; no more specific identifier is asserted. Toolchain:
`leanprover/lean4:v4.36.0-rc1`; Mathlib
`5f7b4198d22a9c82e1c698a379334fe128095c82`.

## Files and trust boundary

* `CertGPTKernel.lean`: total fuelled tree checker; ordered C/K children, explicit
  eligibility, positive need, F/S rejection. `check_sound` and
  `check_no_completion` have explicit `RulesSound` hypotheses. Ten small kernel
  reduction tests exercise branches, fuel, sibling exclusion and rejection.
* `CertGPTBits.lean`, `CertGPTRank.lean`: executable parity and Gaussian span
  counter, with proofs relating them to coordinate dot products and matrix rank.
* `CertGPTCheck.lean`: unsharded swap/quarter orbit regeneration, table validation,
  R/E/B checking, sibling exclusion, K validation, and FRAME reporting. Both a
  flat-stream runner (with statistics) and an adapter to the proved tree kernel
  are provided. Rank leaves use the permitted one-sided vector-rank upper bound.
* `CertGPTData.lean`, `CertGPTGen.py`, `CertGPTTest.lean`: strict authenticated
  input conversion and executable harness. SHA-256/gzip/text parsing in Python
  are outside the formal kernel; the Lean checker rechecks orbit/table content.
* `CertGPTFrames.lean`: generic pair frames, projection to `C16Frames.IsFrame`,
  swap-orbit decomposition/disjointness/partial-frame facts, and outer-product
  identity for a full-cardinality frame.
* `CertGPTFrameCheck.lean`: executable partial-frame test implies the mathematical
  pair-frame predicate.
* `CertGPTSound.lean`: residual parity, coverage, removal, size and live-state
  transition lemmas. These are mathematical facts, not assumed nonexistence.

No `axiom`, `sorry`, or `admit` is introduced. The generic proof obligations are
ordinary hypotheses; they are **not discharged for the concrete checker**.

## Reuse and independence

Read #77/#78 and files on `independent/c16-lean-cert-20261107` read-only. No edits,
commits or pushes were made to that branch. `CertGPTBits.lean` and
`CertGPTRank.lean` adapt the other branch's `CertRun.lean` / `CertSound.lean`
parity and Gaussian-count implementation/proofs (Grok/xAI), preserving their
mathematics while separating generic vector proofs from concrete pool evaluation.
The projection-to-IsFrame proof in `CertGPTFrames.lean` was informed by its
`CertCheck.lean`; attribution is also in the source. The remaining checker,
generator, tree-kernel proof and orbit/residual bridges were developed here.
The specification explicitly permits this reuse: independence of authorship is
not the Lean trust boundary. The reference Python checker was also permitted.

## Reproduction

From this directory, with the pinned toolchain:

```sh
lake update
lake build
python3 CertGPTGen.py ../restricted-frames-20261031/certificates/swap.inst \
  ../restricted-frames-20261031/certificates/swap.cert.gz /tmp/swap.input
lake env lean --run CertGPTTest.lean /tmp/swap.input swap
```

`lean --run` uses an interpreter and is substantially slower than native code.
The test log records native runs. The parser accepts only a complete unsharded
header and terminal `END COMPLETE`; S records cannot establish acceptance.
Quarter, the three bad fixtures and planted inputs use the analogous command,
with `--pools planted` for planted data and `quarter` for the runner's class.

## Remaining obligations

1. Establish all `RulesSound (concreteRules d)` fields from one coherent
   completion invariant, including the imperative residual update and rank-leaf
   connection to the remaining induced matching.
2. Prove `validateItems = true` means exactly all admissible swap orbits occur,
   and connect the union/cardinality of those items to a full pair frame.
3. Connect actual `PoolData.xArr/zArr`, parsed instance, generated certificate,
   and root completion invariant without trusting the Python decoder as proof.
4. Instantiate the soundness theorem and derive the requested `no_swap_frame`,
   then print its axioms. Until then there is no target-theorem axioms output.

See `CertGPTResults.json` and `CertGPT*.log` for actual checked outcomes. A
successful executable run, a successful generic proof, or a successful full
build does not discharge the obligations above.
