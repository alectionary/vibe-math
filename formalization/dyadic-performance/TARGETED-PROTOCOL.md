# Bounded disagreement and low weight failure study

Fixed before new decoding. This follow-up uses only the existing quantum candidate records: no new source family, size, channel, decoder or optimization weighting. The targets are objective disagreement, the contrasting optimization effects, and a precise low-weight failure bound. It is an adaptive follow-up, not the original benchmark's prespecified test.

## Geometry audit and representative cap

Audit all 384 existing evaluation candidates per construction. Group by the individual X/Z graph cycle and absorbing spectra and their low-weight stabilizer/logical spectra. There are seven observed profiles in 3.10 and four in 3.11. Audit the ranking of every profile pair under the existing objectives, including pairs with equal total cycle counts. This is a finite inventory of the saved sample, not an exhaustive classification of the construction.

For each profile choose exactly two parameter instances, sorted lexicographically by canonical JSON parameters, taking the second from a different original pool. Do not use decoding outcomes to choose them. This caps the study at 22 existing CSS pairs. Preserve the original dimensions, distances, check representations and binary message arithmetic.

## Exhaustive low weight errors

Freeze normalization 0.8, 50 iterations and the sector prior/error probability 0.02. Decode every binary error of weights zero through two in each sector. Since X and Z decoders are separate deterministic functions, combine these responses to evaluate every Pauli error of physical weight at most two, including Y errors. This covers 4,561 Pauli patterns per 32-qubit pair and 41,329 per 96-qubit pair without redundant decoder runs. Score modulo full stabilizer spans as before.

Record exact failure counts by physical weight and component weight, syndrome/logical failure type, and whether the failing binary pair is itself absorbing. For the 32-qubit cases additionally record containment in four-variable absorbing supports, with their odd-check counts. These are finite diagnostic correspondences, not assumptions that all absorbing sets fail.

Weight each Pauli pattern with its actual independent-component channel probability at 0.02. The resulting low-weight failure mass is an exact contribution and hence a lower bound on the full frame error probability, up to numerical probability evaluation. It is not automatically an asymptotic error-floor formula: the matched-prior decoder may change its response when the prior changes, particularly under message saturation.

## General ambiguity bound

Within this finite error set, group patterns by full CSS syndrome and by stabilizer coset. A deterministic syndrome decoder can recover at most one coset per syndrome. The total error mass minus the sum, over syndromes, of the largest represented coset mass is a decoder-independent lower bound. Compare observed low-weight failure mass with this bound, keeping the gap specific to the truncated error ensemble. Use the established stabilizer-coset decoding principle, not a new-theorem priority claim. Prove the bound and, if feasible within the existing Lean environment, check its reusable finite and subgroup ingredients without expanding algebraic infrastructure.

## Fresh fixed-code validation

For each construction and representative index generate 20,000 fresh quantum frames with seed `20261120+100000*family_index+100*representative_index`; share these across all profiles in that replicate. Use only the fixed primary setting. This is 80,000 independent sampled channel frames, 440,000 nominal representative-frame evaluations and 880,000 sector decodes.

Compare the two observed 3.10 discordant profile pairs, with the same representative index and paired noise. Report conditional paired normal intervals using stratified per-representative variances, 95% descriptive intervals and 97.5% intervals for the two planned discordance contrasts. These intervals concern the fixed selected representatives and Monte Carlo sampling, not a population of new code designs. Retain all profile results, not just the favorable pair. Measure how much fresh-sample failure mass is explained by the exact low-weight contribution and how well profile-level low-weight results agree between representatives.

## Stop condition

Finish with the finite ranking audit, the 22-code exact low-weight response table, the two matched disagreement comparisons, and the proved ambiguity bound. Identify which of the three research gaps was narrowed. Do not launch larger code searches, decoder changes, extra noise points or an open-ended formalization project in this step.
