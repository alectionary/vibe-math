# Cubic periodic cohomology and distance: exact evidence boundaries

This is a substantive continuation of the whole-dissertation objective, not a claim of complete coverage. The verified public claim remains reserved. All earlier numerical outputs remain unchanged; no further experiments were run on the rejected models.

## Kernel-checked general results

`lean/CubicPotential.lean` defines binary edge cochains on Nat³, periodic with positive period L, and the three plaquette-closure equations. This is a coordinate representation of functions on the finite periodic cell. It does not assume that closed fields are exact on a torus.

1. `closed_field_has_potential` constructs an explicit potential on the unwrapped lattice. It integrates along x at y=z=0, then y at z=0, then z. Closure and a proved XOR telescoping identity give all three derivatives. This potential need not be periodic.
2. `period_obstructions` proves that each period shift of any potential changes it by a position-independent bit. These are precisely the three cycle sums.
3. `periodic_potential_iff` proves that a periodic potential exists exactly when all three cycle sums vanish.
4. `all_holonomies_realized` constructs seam representatives for every three-bit label. It deliberately uses seams, not constant fields, because constant fields have zero cycle sum for even L.
5. `holonomy_classification` proves that two closed periodic cochains differ by a periodic gradient exactly when their labels agree, and that every label occurs. This is an explicit classification by three Boolean coordinates; no unsupported dimension assertion is embedded in a hypothesis.

`lean/CubicDistance.lean` proves:

6. `parallel_loop_flux`: closure makes the axis cycle sum the same on every parallel line.
7. `nontrivial_closed_weight`: a nonzero cycle bit forces at least one occupied edge in each of L² disjoint parallel lines, hence weight at least L².
8. `minimum_nontrivial_cocycle_weight`: an explicit seam has weight L² and nonzero holonomy, so the lower bound is attained in this periodic coordinate model.

All these general statements compile with Lean4.22.0/Std. Reported axioms now include **propext, Quot.sound and Classical.choice** for the existence/classification/attainment statements. No added axiom, sorry, admitted theorem or native_decide is used. Earlier reports listing only propext/Quot.sound apply to their earlier theorem set; they must not be reused unchanged for this milestone.

## Independent consumers and source connection

`HomologyConsumer.lean` constructs periodic gradients plus seam representatives for all8labels, two input potentials, and L2,3,4,5,6. Its exported potential, holonomy and weight are checked independently with Python's actual V/F/logical-string matrices. All80fields and21120gradient entries pass; period jumps equal the claimed labels, source F syndromes vanish, source logical strings read the same labels, and all nonzero-label weights satisfy the bound. Odd and even sizes and nonzero holonomies are included. This is not exhaustive finite enumeration; the general claim rests on the kernel proof. Inputs and periodic/axis conventions are shared; the matrix implementation and Lean path integration are distinct.

The prior609792entry consumer check remains separate evidence. The actual finite Python code is indexed by axis-major Fin-L triples; the new proofs use periodic Nat-coordinate functions. Restriction to a fundamental cell and periodic extension are mathematically inverse, and the plaquette formulas agree, but this adapter and arbitrary-size array flattening are **not yet formalized in Lean**. The physical source matrix claim excludes L1, where repeated-edge assignment differs from the abstract XOR convention. No rhombic result follows from this cubic theorem.

## Written rank consequence (not a Lean matrix-rank theorem)

For L>=2, identify periodic functions with their values on the L³ vertices. The vertex-gradient kernel is the one-dimensional constant subspace (proved separately in CubicIncidence.lean). Thus the vertex row space has dimension L³-1 by rank-nullity. The holonomy map is linear (XOR cycle sums), onto F2³, with kernel exactly the periodic gradients. The new classification therefore gives dim ker(F)=L³-1+3=L³+2. Rank-nullity on the 3L³ edges gives rank(F)=2L³-2. Since face/vertex incidence products vanish, the CSS count is 3L³-(L³-1)-(2L³-2)=3.

The general mathematical argument is explicit, but finite-dimensional rank-nullity, linearity/cardinality conversion, the Nat-periodic/finite-matrix adapter and the CSS Hilbert-space interpretation are not all kernel-checked. Do not label the numerical rank formulas as a completed Lean theorem.

## Written X-distance consequence (not a Lean cycle-distance theorem)

The Z-type cochain classification above is dual to cycle classes under the finite binary dot product. Nondegeneracy follows from the annihilator identity (ker F)perp = image(F transpose) and rank-nullity. A cycle not in the face-boundary space therefore pairs nontrivially with at least one seam representative. Translated parallel seams differ by a vertex gradient (the gradient of a slab indicator), so a zero-vertex-syndrome cycle has the same nonzero pairing with all L disjoint parallel seams. It must contain at least one edge in each, hence weight>=L. A straight periodic axis string has L edges, zero vertex syndrome and nonzero seam pairing, attaining the bound.

This argument identifies the missing proof interfaces: finite bilinear annihilator duality, slab-gradient identity, disjoint support counting and the actual cycle/source matrix adapter. Those steps are not yet general Lean theorems. It must not be conflated with the newly formalized cocycle L² bound or the earlier finite distance certificates.

## Remaining obligations

- Formal finite-coordinate/source-matrix adapter, rank/counting conversion and quantum CSS/Hilbert interpretation.
- General Lean cycle duality/X-distance bridge described above.
- Full rhombic parity closure, cube/triangle commutation, homology, rank and distances under the disclosed Pauli convention.
- Ideal repetition-component counting, majority/tie behavior and Bernoulli asymptotic probability bounds. Actual BP-OSD thresholds are distinct.
- General row-operation/pivot/loop-invariant proof for the actual OSD solver; BP numerical behavior and optimality remain separate.
- No further fits on the two rejected grids without a justified replacement model and prospective experiment.

## PR-description failure

The earlier metadata call retained only isError=true; its raw reason was not saved. Available tool discovery exposes no tool-call-history retrieval, and the available stored results are subsequent read-only PR snapshots, not that failed response. No prohibited session files were inspected. Readback showed the branch updated but description unchanged. It cannot be classified safely as an ordinary API error versus approval denial, so the description write remains paused and has not been retried. The prepared corrected description is /tmp/pesah-proof-pr-body.md; publication of later scientific artifacts remains separately authorized.
