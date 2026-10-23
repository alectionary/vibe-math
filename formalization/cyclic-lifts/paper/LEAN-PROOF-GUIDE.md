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

## October 23 logical-support supplement

The updated source bundle additionally contains `CyclicLogicalSix.lean`, with ten audited declarations. It verifies an explicit baseline logical word, its dual nonmembership witness, and an identically shaped stabilizer support. The graph expansion, local `K3,3` adjacency and complete stabilizer-span distinction are checked. The full weight-six census and distance bounds are computational, not Lean-certified enumeration. This supplement is included in the bundle; it is not part of the historical immutable revision linked above. The original 118-report count remains historical and separate.

From the bundle's `artifact/formalization/dyadic-rank`, run:

```sh
lake -f lakefile-cyclic.toml env lean CyclicLogicalSix.lean
```

## October 23 trajectory and entry supplement

The chronology now includes later distance controls, same-code representation interventions, local obstructions, persistence and complete trajectories, followed by entry dynamics and independent confirmation. The full follow-up Lean sources are frozen at `c5561734e1b91c55911703ef4930f6e718624453`. They supplement the original proof revision rather than changing its historical 118-report count.

| Complete Lean module | Contribution |
|---|---|
| [CyclicMergedMessages.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicMergedMessages.lean) | Merger message identity, attenuation and first-divergence locality. |
| [CyclicMergedWitnesses.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicMergedWitnesses.lean) | Actual matrices, equal kernels and local obstruction certificates. |
| [CyclicDecoderPersistence.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderPersistence.lean) | Finite interval enclosure and persistence. |
| [CyclicDecoderParity.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderParity.lean) | Parity preservation under synchronized flips. |
| [CyclicDecoderTubes.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderTubes.lean) | Four complete finite-horizon tube certificates. |
| [CyclicDecoderReachability.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderReachability.lean) | Two complete from-prior stopping comparisons. |
| [CyclicDecoderEntry.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntry.lean) | Generic propagation locality and margin lemmas. |
| [CyclicDecoderEntryInitial.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryInitial.lean) | Initial message and hard-decision criterion. |
| [CyclicDecoderEntryCone.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryCone.lean) | Concrete possible-influence cones. |
| [CyclicDecoderEntryExamples.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryExamples.lean) | Soft-only and delayed entry joined to final stopping results. |
| [CyclicDecoderEntryDelayed.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryDelayed.lean) | Exact second-update delayed activation. |
| [CyclicDecoderEntryChannel.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryChannel.lean) | Finite independent Bernoulli parity moments. |
| [CyclicDecoderEntryBias.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryBias.lean) | Exact signed moments for the actual gate supports. |
| [CyclicDecoderEntryAudit.lean](https://github.com/alectionary/vibe-math/blob/c5561734e1b91c55911703ef4930f6e718624453/formalization/dyadic-rank/CyclicDecoderEntryAudit.lean) | Entry-theorem axiom audit. |

All local imported Lean modules, generated trajectory data and concrete proof files are included in the refreshed source bundle. In particular, the `CyclicDecoderReachData`, `CyclicDecoderReachProofs`, `CyclicDecoderTubeData` and `CyclicDecoderTubes` subdirectories are required; the linked top-level modules are not standalone snippets.

With the pinned dependencies available, enter `artifact/formalization/dyadic-rank` and run:

```sh
lake -f lakefile-cyclic.toml env lean CyclicMergedWitnesses.lean
lake -f lakefile-cyclic.toml env lean CyclicDecoderTubes.lean
lake -f lakefile-cyclic.toml env lean CyclicDecoderAudit.lean
lake -f lakefile-cyclic.toml env lean CyclicDecoderEntryAudit.lean
```

The bundle contains importable `.lean` sources, not compiled `.olean` files. Build local imported modules in dependency order first. The included `scripts/check_cyclic_paper_followups.py` performs that ordering and checks these four entry points; the generated reachability proofs can take several minutes. The unchanged research build logs are included as historical verification records. Sampling, C++ execution, finite optimization, exact-distance searches and aggregate statistical comparisons are not Lean FER proofs. No new trajectories or scientific results were generated for this paper revision.
