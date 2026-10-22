# Counterexample search for dyadic rank and support

Exact computations found no counterexamples among **45,543 distinct conditioned signatures**, up to matrices of size **1024 × 1024**. Only the conditioned spaces through dimension 4 were exhausted. The larger searches are samples and structured tests, not Lean proofs.

A candidate signature must have even coefficient parity and zero XOR of its support indices, yet rank exactly half the matrix size. Odd coefficient parity gives full rank; this exclusion is proved in Lean in `parity_zero_of_half_rank`. Every recorded tested signature satisfies both conditioning equations.

| Dimension | Matrix size | Distinct signatures tested | Scope | Largest observed rank | Counterexample rank |
| --- | --- | ---: | --- | ---: | ---: |
| 1 | 2 × 2 | 1 | Exhaustive conditioned space | 0 | 1 |
| 2 | 4 × 4 | 2 | Exhaustive conditioned space | 1 | 2 |
| 3 | 8 × 8 | 16 | Exhaustive conditioned space | 2 | 4 |
| 4 | 16 × 16 | 2,048 | Exhaustive conditioned space | 6 | 8 |
| 5 | 32 × 32 | 23,909 | Sampled and structured | 12 | 16 |
| 6 | 64 × 64 | 12,282 | Sampled and structured | 28 | 32 |
| 7 | 128 × 128 | 4,300 | Sampled and structured | 56 | 64 |
| 8 | 256 × 256 | 1,700 | Sampled and structured | 120 | 128 |
| 9 | 512 × 512 | 701 | Sampled and structured | 240 | 256 |
| 10 | 1024 × 1024 | 584 | Sampled and structured | 496 | 512 |

## Methods and checks

`search.py` uses binary integers for matrix rows and exact Gaussian elimination over F₂. Row `x` is obtained from the signature by the permutation `y ↦ x XOR y`. The random seed is `20261021`. Uniform conditioned sampling chooses all free bits, then solves the parity and coordinate-XOR equations using pivots at index 0 and the unit-vector indices. The conditioned space has dimension `2^ell - ell - 1`.

The structured families are sums of affine planes, disjoint-pair quadratics in the augmentation variables `t_i=1+g_i`, and those quadratics perturbed by terms of degree at least three. These families are not uniformly sampled. Per-family attempt counts can include duplicates; the main counts deduplicate signatures within each dimension. Recorded larger-space coverage is tiny, and no probability of truth follows.

[results.json](results.json) records rank histograms, largest-rank signatures, source hash, and a digest of the ordered signature/rank pairs. The first three distinct signatures in each dimension, when available, were cross-checked by a separate rank implementation that constructs entries directly and pivots from the opposite end. `validate_search.py` additionally checks all 276 unrestricted signatures through dimension 3 against that implementation, verifies the square identity directly, checks projection and exhaustive enumeration, and independently recomputes each recorded largest-rank witness. These checks do not turn the results into Lean proofs.

```sh
python3 search.py
python3 validate_search.py
```

Run from this directory. The first command regenerates `results.json`; elapsed times may differ, but the seed, counts and result digests should agree on reruns. Standard Python is sufficient. If a counterexample is found, the code records its signature and rank; it would still need independent checking and a Lean certificate.

The observed maxima suggest a rank gap worth investigating, but no general formula or bound beyond the proved half-rank upper bound is asserted. The unrestricted theorem is now proved by the [direct Lean induction](../INDUCTIVE-PROOF.md), independently of these computations.
