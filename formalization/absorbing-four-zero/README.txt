A STRONGER (3,6)-REGULAR COUNTEREXAMPLE, CHECKED IN THE SAME BLOCK

PaschCubicTrade.lean provides two actual140-variable,70-check QC-GHP models
with column degree3, check degree6 and no Tanner four-cycles. Their full complex
M_j matrices agree at every frequency, but their (4,0) counts are77 and105.
This removes the check-degree9 limitation of the earlier273-variable witness.
The273-variable182/147case remains as a second checked consumer.

The smaller pair uses the elementary Pasch trade extended by six triples.
Label the six edges of K4 by0,...,5. On these labels take either the four
stars or the four triangles, and append {edge-label,6+endpoint1,6+endpoint2}
for every edge. Both incidence systems are cubic/linear with the same integer
point Gram. The first has one Pasch; the second has five. The generic HGP
formula gives7*1+10*7=77 and7*5+10*7=105 after the cyclic Fano lift.

The construction K_X+_mu H is classical: Prażmowska–Prażmowski2016,
Section3 following Propositions3.2–3.3 (the relevant statements/proofs were read):
https://doi.org/10.1007/s00373-016-1681-3
No novelty is claimed for these10_3configurations or their Pasch trade/counts.
The checked deliverable is the exact source-incidence/evaluated-matrix bridge.

Independent C++ enumeration tested all15,329,615four-subsets of each140-column
model. Direct binary-kernel and induced degree0/2 counts both agree77/105.
See cubic-trade-counts.json, independent-quad140-counts.jsonl and the explicit
source140-columns.json data.

FOUR-VARIABLE ABSORBING COUNTS: THE (4,0) FOLLOW-UP

The recorded counting target is answered within its stated cubic/no-four-cycle
scope. The source's proposed use of M_j alone is refuted; corrected positive
formulas use full incidence data. See RESEARCH-NOTE.txt for the readable result,
DERIVATION.txt for definitions/proofs, and verification.json for the exact
checked scope and elapsed time.

This is the second component of L-F16-other-absorbing, from Abiad–Castriota's
QC-GHP paper. Beezer2001 is a classical comparison source. His minimal-basis
Conjecture4.1 is a different question; it was indexed here, not solved here.

MAIN RESULTS

* N40 is exactly the weight-four coefficient of the binary kernel. Therefore
  MacWilliams identities already imply a general classical full-incidence count.
* The explicit cyclic formula is N/24 times the normalized root sum of
  Fourier-energy/N minus root-check energy minus the common-neighbor count.
  Both this formula and the preserved (4,2) formula are now checked in Lean.
* Actual273-variable QC-GHP examples have identical full evaluated complex M_j
  at every frequency but (4,0) counts182 and147. Their source incidence, counts,
  full-M equality and impossibility conclusion are Lean checked. An independent
  C++ oracle also tested 452,775,960 four-subsets across the two examples.
* Beezer's complete 17-page final journal PDF was read and indexed. His reduction
  leaves Pasch as a generator input. Three separate source targets/directions
  are inventoried, only one eligible for theorem coverage; their full current-
  resolution/Lean/difficulty assessments remain unassessed.

EVIDENCE AND LIMITS

19 new checked Lean modules build on42 unchanged checked modules preserved under
prior/. Only standard axioms propext,Classical.choice,Quot.sound are permitted;
no sorry,admit,native_decide or custom axioms are used in the checked modules.
The prior archive also preserves explicitly labeled historical unchecked
candidates; they are not imports or counted checked modules.

MacWilliams1963 supplies the classical baseline. The transform itself and the
separate pair-XOR formula have written proofs and exact finite checks here;
they are not new Lean MacWilliams theorems. The substantive checked deliverable
is the source translation/correction and the exact cyclic/source-matrix bridge.
No mathematical/formalization priority, quantum minimum distance, code rank or
decoder-performance claim is made. Three named unavailable final/full-text
comparisons remain in prior-art.json. Earlier dated artifacts are unchanged.

REPRODUCTION

Pinned Lean: leanprover/lean4:v4.36.0-rc1
Pinned mathlib:5f7b4198d22a9c82e1c698a379334fe128095c82

After extracting the source archive, obtain the pinned mathlib dependencies
using Lake, or provide an existing project with those exact pinned dependencies:

  python3 verify_sources.py --project /path/to/pinned/project

This rebuilds all 61 listed research modules from source into .recheck/, and
checks payload/source hashes and printed axioms. It leaves historical sources
and manifests unchanged. No research .olean files are distributed.

For standalone Lake imports, lakefile.toml lists all three source libraries;
the public entry is AbsorbingFourCounts.lean. The final artifact includes a
separate fresh standalone entry check using generated research objects and no
manually supplied research-source LEAN_PATH entries.

Exact finite checks use Python>=3.10 for int.bit_count:

  python3 exact_counts.py

An independent C++17 check can be built and run with:

  c++ -O3 -std=c++17 independent_quad_check.cpp -o quad-check
  ./quad-check < source273-input.txt

The full academic PDF and its extraction remain local research inputs; the
archive contains our review, question index, acquisition hash and primary URLs.

X AND GITHUB PRIOR-ART EXTENSION (October24)

Direct X Latest searches and public GitHub repository/indexed searches were
completed. The exact queries, visible-result limits and source comparisons are
in social-prior-art.json. A public Lean binary MacWilliams theorem was found:
https://github.com/pefch-k/lean-coding-theory-macwilliams-identity
Both Lean files were read at pinned commit8848ddeeff36408d9b6f13f229a82d568c006424.
They contain no sorry/admit/custom-axiom/native_decide tokens, but were not built
or axiom-audited here. This is relevant pre-existing formalized background; it
does not contain the absorbing/Pasch/cyclic-source bridge in its two-file tree.
A separate GitHub finite Pasch-count report was also read; its code link returned
404 and its reported computation is not independently certified here.
No matching independent proof was identified in the bounded X results; our own
earlier announcement was excluded as independent prior art. These searches do
not establish global absence or priority.

CLASSICAL DATA IDENTIFICATION
Both10_3bases were matched, by explicit checked incidence relabellings, to
Krčadinac's public data accompanying Abreu–Funk–Krčadinac–Labbate,
Strongly regular configurations,arXiv2104.04880v2(2021),laterDCC90(2022).
https://arxiv.org/abs/2104.04880v2
https://web.math.pmf.unizg.hr/~krcko/results/srconf/10-3-3-4.txt
The star base matches dataset item2; the triangle base matches item1.
See classical-cubic-comparison.json for the explicit maps and exact-data hash.
The preprint introduction and relevant Section3 passages were read; the full
2022journal revision was not compared. No novelty for the base examples is claimed.

Fresh-check provenance is phased:59unchanged final source checks from the
initial clean build, then the new cubic consumer and changed public entry.
All61final module hashes are checked, and the standalone Lake entry is checked
using only these freshly generated objects and pinned dependencies.
