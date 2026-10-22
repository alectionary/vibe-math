# Complete Lean proof: source and reproduction guide

The PDF contains principal declarations, a dependency diagram, the complete
mixed eight-cycle construction and absorbing-support equivalence, and substantive
stopping-bound excerpts. **The complete proof is in the linked Lean files below**,
including every helper lemma; no proof body has been replaced by the excerpts.

[Browse the entire formalization at the immutable source revision](https://github.com/alectionary/vibe-math/tree/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank).

The source revision is `5dbda826fb9d385cf5528694f6908d28bc94054d`. Paper-only
edits after that revision do not change the formal proof. To get all the sources,
configuration, audits and data offline, [download the complete manuscript source
bundle](https://github.com/alectionary/vibe-math/raw/refs/heads/master/formalization/cyclic-lifts/paper/cyclic-lift-girth-eight-source.zip).
This download tracks the current draft; its two SHA-256 manifests identify its
exact file contents. The immutable links below identify the Lean revision.

| Complete file | Role |
| --- | --- |
| [CyclicLift/Basic.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/Basic.lean) | Voltage lifts, four-cycle predicates, native graph foundations. |
| [CyclicLift/Bipartite.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/Bipartite.lean) | Tanner incidence and bipartite short-cycle reduction. |
| [CyclicLift/LiftedProduct.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/LiftedProduct.lean) | Actual binary matrix, product support, graph equality and rectangle criterion. |
| [CyclicLift/ShortCycles.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/ShortCycles.lean) | Explicit walks, simple six-cycles and native bridges. |
| [CyclicLift/SixCharacterization.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/SixCharacterization.lean) | Both directions of the hexagon/six-cycle criterion. |
| [CyclicLift/GirthCharacterization.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean) | Constructive eight-cycle and full matrix/rectangle-pair girth characterization. |
| [CyclicLift/SmallCases.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/SmallCases.lean) | Small symbolic and concrete instances. |
| [CyclicLift/LargerCases.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicLift/LargerCases.lean) | Larger certificates and the rectangle-only obstruction. |
| [CyclicStructure.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicStructure.lean) | Complete 651-line general absorbing-support bijection and stopping-bound development. |
| [CyclicSourceQuestion.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicSourceQuestion.lean) | Source-question corollaries. |
| [CyclicDecoding.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicDecoding.lean) | General two-error syndrome bound and concrete incidence certificates. |
| [CyclicOptimized.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicOptimized.lean) | Selected candidates' girth certificates. |
| [CyclicChecks.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicChecks.lean) | Independent consumer and 75 core axiom reports. |
| [CyclicPriorArtChecks.lean](https://github.com/alectionary/vibe-math/blob/5dbda826fb9d385cf5528694f6908d28bc94054d/formalization/dyadic-rank/CyclicPriorArtChecks.lean) | Three separately audited comparison declarations; outside the 118 count. |

`CyclicLift.lean` is the library entry point. The core plus four supplementary
consumers contain 2,064 lines, including comments and module declarations. The
118 audit reports comprise 75 + 3 + 8 + 3 + 29, including helper lemmas and
certificates rather than 118 independent research results.

## Reproduce the kernel checks

Install the pinned Lean toolchain, extract the bundle, and enter
`artifact/formalization/dyadic-rank`:

```sh
lake -f lakefile-cyclic.toml exe cache get
lake -f lakefile-cyclic.toml build CyclicLift
lake -f lakefile-cyclic.toml env lean CyclicChecks.lean
lake -f lakefile-cyclic.toml env lean CyclicSourceQuestion.lean
lake -f lakefile-cyclic.toml env lean CyclicDecoding.lean
lake -f lakefile-cyclic.toml env lean CyclicOptimized.lean
lake -f lakefile-cyclic.toml env lean CyclicStructure.lean
```

Build the explicit `CyclicLift` target: the inherited configuration also names
an unrelated library that is not part of this bundle. Lean is pinned to
4.36.0-rc1 and Mathlib to `5f7b4198d22a9c82e1c698a379334fe128095c82`.
Dependency source/binaries must be downloaded separately. From the `artifact`
root, `python3 scripts/validate_cyclic_structure.py --recheck-lean` repeats the
structural kernel check and checks source hashes and all 29 audit reports.
The artifact README gives the separate computational validation commands.

The repository's `scripts/prepare_cyclic_paper_listings.py` regenerates the nine
PDF excerpts from source. `listings/excerpts.json` records source paths, line
ranges and raw excerpt hashes; `listings/character-map.json` records the
reversible Unicode escapes. The script verifies every excerpt's round trip.

## Exact formal scope

Lean checks the general girth characterization, the absorbing-support/eight-cycle
bijection, its count equality and minimum-size exclusion, the general `2*d`
stopping lower bound, the two-error syndrome bound, and the indicated finite
certificates. Observed axioms are only `propext`, `Classical.choice`, `Quot.sound`.
The four odd checks in the elementary `(4,4)` profile, companion-stabilizer
identification, and conductance argument retain written proofs. Search optimality
and decoding experiments have computational audits, not Lean proofs.
