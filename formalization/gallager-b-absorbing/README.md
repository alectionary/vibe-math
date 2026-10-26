# An absorbing set without Gallager-B trapping

**L-P09-all-absorbing is answered negatively for the unrestricted question in arXiv:2307.14532v2, Section VI.** The full seven-variable simplex-check graph is (7,0)-absorbing, but every one of its 128 input error supports is accepted at initialization or after one full syndrome-based Gallager-B iteration.

[Paper](paper/main.pdf) · [Editable source](paper/main.tex) · [Complete Lean proof](Counterexample.lean) · [Verification](verification.json) · [All input cases](certificate.json) · [Complete source bundle](research-source.zip) · [Publication hashes](publication-manifest.json) · [Tracking issue #2](https://github.com/alectionary/vibe-math/issues/2).

The result uses zero initialization, strict extrinsic majority and zero ties. Both hard-decision and outgoing-extrinsic syndrome calculations match. A stopped decoder has constant terminal output, so no supported error creates the persistent mismatch/nonconvergence of the source's Definition3.

Syndrome acceptance is distinct from quantum recovery. A separate fourteen-qubit CSS pair proves that every supported error **in the decoded Z sector** is corrected modulo the entire opposite stabilizer span. The other block has a checked nontrivial logical operator. The actual matrices and fourteen-coordinate decoder calculation are included in Lean.

Scope: redundant checks, degree4 and Tanner four-cycles are allowed. The selected component is connected; the ambient CSS graph has two components. This does not settle connected-ambient, high-girth, prescribed-degree or selected-logical-support variants. Journal-version full text was access restricted; the exact source compared is the accessible v2 preprint.

## Reproduce

Use the pinned Lean toolchain, with no Mathlib dependency:

```sh
python3 build.py --lean /path/to/lean-4.36.0-rc1/bin/lean
python3 verify.py --check
```

The build checks all26 theorems and reconstructs the independent 128-error certificate. Only standard Lean axioms occur; no admitted proof or native decision oracle is used. The Python verifier requires Python3.10 or newer. The PDF follows the repository's established LaTeX format and includes a substantive proof appendix.

The original six-hour delivery window was missed. The user's subsequent resume instruction authorized finishing verification and publication; see [investigation record](INVESTIGATION.md) for the explicit timing and scope.

**Question answered:** the unrestricted absorbing-implies-trapping statement, by a fully checked counterexample.

**Question still open:** any suitably formulated connected-ambient/high-girth/selected-logical-support variant; no claim that these variants remain open in the global literature.

**Next proposed target (follow-up):** formulate and test the connected-ambient variant before launching another research campaign. No further campaign is started by this artifact.
