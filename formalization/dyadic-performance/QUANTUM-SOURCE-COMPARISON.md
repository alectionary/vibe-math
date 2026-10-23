# Matching the quantum experiment to P11

The primary source is Gómez-Fonseca, Matthews, Morris and Pllaha, [*Combinatorial Analysis of Dyadic and Quasi-Dyadic Codes*, arXiv:2605.01942v1](https://arxiv.org/html/2605.01942v1). This comparison uses its Constructions 3.10 and 3.11, Equations (8) and (9). Those passages were read in the primary HTML and checked against the saved source text. The [prior-art review](PRIOR-ART.md) records the broader decoding context. This experiment uses literal source constructions at explicitly chosen sizes, rather than recreating the authors' simulation curves.

## Construction 3.10

With zero-based indices the implemented block arrays are

```text
HX_left[i,j]  = P_(x[sigma^i(j)])
HX_right[i,j] = P_(y[sigma^i(j)])
HZ_left[i,j]  = P_(y[tau^i(j)])
HZ_right[i,j] = P_(x[tau^i(j)])
```

This is the displayed source formula with the index origin shifted. The experiment sets `omega=4`, retains all four rows, fixes `sigma=(0 1 2 3)`, samples all six possible four-cycles for `tau`, and uses labels in `F₂²`. It fixes `x[0]=0`; a common translation of every variable fiber absorbs a common added label in every block. No assumption that arbitrary sampled labels commute is made: block-label parity implements Equation (8), followed by direct verification of every binary X/Z row dot product.

Only connected instances with ranks `(12,12)` and exact sector distances `(4,4)` enter the comparison. Their quantum parameters are `[[32,8,4]]`.

## Construction 3.11

For `v=6`, the source's four alternating rows become, writing `0` for `P_0` and `a,...,f` for the six labels,

```text
0 a 0 b 0 c 0 d 0 e 0 f
f 0 a 0 b 0 c 0 d 0 e 0
0 f 0 e 0 d 0 c 0 b 0 a
a 0 f 0 e 0 d 0 c 0 b 0
```

Set `HX=HZ` equal to this array. All four displayed rows are retained; this is not the three-row truncation used in one source figure. Labels lie in `F₂³`. Choosing the fixed permutation to be `P_0` amounts to a common translation of all variable fibers. Direct binary self-orthogonality is verified for each accepted instance.

Only connected instances with ranks `(28,28)` and exact sector distances `(4,4)` enter this comparison. Their quantum parameters are `[[96,40,4]]`. The two construction strata have different lengths and dimensions; no pooled between-construction performance ranking is made.

## Binary expansion, quantum distance and success

Every block is expanded using `P_s[a,b]=1` iff `a XOR b=s`, independently checking edge enumeration against dense matrix entries. These are binary CSS stabilizer checks, with `HX HZᵀ=0` and `k=n-rank(HX)-rank(HZ)`.

The distances are

```text
dZ = min weight in ker(HX) outside rowspan(HZ)
dX = min weight in ker(HZ) outside rowspan(HX).
```

Every kernel support of weights one through four is enumerated by column and pair syndromes. Full row-span membership, not membership among just the displayed generators, distinguishes stabilizers from logical operators. The absence of non-stabilizer supports below four and a non-stabilizer witness of weight four certify each sector's distance exactly. If both sector distances are four, the full CSS distance is four: a nontrivial mixed Pauli has at least one nontrivial component, while a pure sector witness attains four.

For residual components `rX,rZ`, success is `rX ∈ rowspan(HX)` and `rZ ∈ rowspan(HZ)`. Nonzero residual stabilizers are successes. A residual in both syndrome kernels but outside either stabilizer span is a logical failure. This is the essential change from the earlier classical exact-error criterion. Each decoder receives only its parity checks, syndrome and prior; injected errors and stabilizer spans are used to generate observations and score outcomes, not to select a correction.

The noise model has independent binary X and Z components with probability `p` each and perfect measurements. It is a code-capacity Pauli model, not a depolarizing or circuit-level simulation. The [protocol](QUANTUM-PROTOCOL.md) fixes selection policies and fresh noise before quantum decoder outcomes are generated.

## Connection to the source question

The experiment directly studies the performance-objective direction in P11 Section 7 using its CSS matrices. It preserves dimension and exact quantum distance within each comparison, and includes cycles, absorbing spectra, a joint score and shortest-cycle priority. Low-weight zero-syndrome spectra are annotated as stabilizer or logical so a raw absorbing count is not confused with a count of harmful logical operators.

This is finite empirical evidence for selected source subfamilies. It does not establish a universally best objective, an asymptotic error floor, a theorem about every dyadic CSS construction, or a new Lean result. The separate Lean forbidden-set completeness theorem remains unchanged.
