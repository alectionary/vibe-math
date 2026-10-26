# A connected CSS absorbing set without Gallager-B trapping

This is a **project-derived strengthening** of the completed `L-P09-all-absorbing` counterexample, coordinated in [issue #2](https://github.com/alectionary/vibe-math/issues/2). It does not count as another solved source question. The earlier [seven-variable proof and disconnected fourteen-coordinate CSS example](../README.md) remain preserved.

The explicit fifteen-coordinate CSS pair has rank seven in each sector and encodes one qubit. Its actual decoding Tanner graph includes fifteen distinct checks and fifteen variables and is connected. The first seven variables are a `(7,0)`-absorbing set. All 128 supported binary Z-errors are accepted at initialization or after one Gallager-B iteration, under both the hard-decision and outgoing-extrinsic syndrome tests. Every residual lies in the **entire actual opposite Z-stabilizer span**.

The stabilizer space has **no product decomposition across any nontrivial physical partition**. Fourteen actual X/Z row overlaps form a spanning tree: every proper cut crosses an overlap and produces anticommuting restricted stabilizers. Thus connectivity is accompanied by intrinsic coupling, rather than merely a generator change joining an isolated stabilizer-state block. This refers to physical partitions; it is not an obstruction to global Clifford decoding.

[Paper PDF](paper/main.pdf) · [Complete Lean source](Connected.lean) · [Verification](verification.json) · [Independent verifier](verify.py) · [Full certificate](certificate.json) · [Source archive](research-source.zip)

## Exact scope

The directly inspected motivating source is Morris, Pllaha and Kelley, arXiv:2307.14532v2, May 10, 2024, Section VI; source definitions and rules are in Definitions 3/5 and Section II-B. The paper distinguishes dynamical trapping from logical miscorrection. Its journal full text was access restricted; no unchanged journal wording is asserted.

The new theorem concerns an **asymmetric CSS pair**, decoding Z-errors with HX and measuring residuals modulo HZ. It does not resolve an interpretation requiring the decoded matrix itself to span the error-type stabilizers, or requiring HX=HZ. Redundant checks and four-cycles are allowed; maximal X check weight is five and maximal X variable degree is nine. Auxiliary C has X-variable degree one. No distance, high-girth, degree-three or both-sector recovery theorem is claimed. A nontrivial decoded-sector logical supported entirely on A would be incompatible with correcting every supported error; the concrete absence statement is checked as `no_supported_Z_logical`.

## Reproduce

Use the pinned `lean-toolchain` (Lean 4.36.0-rc1), importing only Std:

```sh
python3 build.py --lean /path/to/lean
python3 verify.py --check
python3 paper/make_paper.py --tectonic /path/to/tectonic
python3 package.py
```

Every theorem is audited for standard dependencies only: propext, Classical.choice, Quot.sound. Finite proofs use kernel `decide`; the cut argument uses structural Boolean propagation and proof-producing `bv_normalize`. No `native_decide`, `bv_decide`, admitted term or compiler oracle is permitted. The independent verifier uses literal binary row lists and separate message calculations; it imports neither the search program nor the Lean module.

`candidate.json` preserves the rejected fourteen-coordinate single-CNOT route: hard recovery succeeds, but sixteen inputs fail the outgoing-edge syndrome test. `candidate15.json` is the accepted repair. The extra coupled auxiliary check supplies the zero vote needed to suppress unwanted exterior messages. The search was a bounded construction experiment, not a classification of all couplings. Its fixed fourteen-coordinate input is archived in `predecessor-input.json` with the original certificate hash; the source bundle is self-contained for this replay. The development search uses Python3.10 or newer.

## Answer and remaining work

**Question answered:** Does the successful absorbing-support example persist with a connected actual decoding graph, positive encoded dimension, and no isolated physical product factor? Yes, for the explicit fifteen-qubit asymmetric CSS pair and the specified stopped decoder.

**Question still open:** Symmetric CSS, prescribed degree/girth and both-Pauli-sector variants are not established here. Their current literature status is unassessed.

**Next proposed target:** A new project-derived task: freeze the exact symmetric-CSS variant and check whether its stabilizer convention restores an obstruction before searching for another example. This campaign is not started by this artifact.
