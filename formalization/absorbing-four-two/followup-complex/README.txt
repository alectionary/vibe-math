COMPLEX-CHARACTER FOLLOW-UP TO THE (4,2) INVESTIGATION

Read RESEARCH-UPDATE.txt for the result and literature comparison, SOURCE-MAP.txt
for proof interfaces, and verification.json for exact source hashes and checks.
DERIVATION.txt explains the local correction and the factors four and N.
The first-block/ directory preserves the earlier artifact verbatim. Its dated
statements about an unfinished complex bridge describe that earlier snapshot;
the present follow-up closes that bridge.

General Lean proof: the standard complex character, negative-exponent DFT,
ordinary matrix-vector product, Euclidean norm, Parseval normalization, and
literal per-root (4,2) counting formula for every positive cyclic lift size.
The same sockets are connected to the actual 168-column source matrices and
their full complex evaluated M_j. The equal-M_j count obstruction is checked
with counts 49 and 35. Standard axioms only; no native-decision shortcut.

Literature: the complete Steiner-triple-system special case was already counted
in 1995. Expanded Tanner-graph ETS enumeration is established prior work.
The Fano-block exclusion of the three-check-group hypothesis is also Lean checked.
Read literature-followup.json for precise hypotheses, successful citation-index
snapshots, and unavailable full-text comparisons. Priority is unestablished.

REBUILD

Use Python >=3.9 and the exact Lean/mathlib versions in verification.json.
With an existing Lake project using those pins:

  python3 verify_followup.py --project /absolute/path/to/pinned/project

The verifier first recompiles all preserved checked base sources, then the new
sources in dependency order, checking hashes, unchanged inputs, exits and printed
axioms. It does not rely on prebuilt research .olean files from this archive.
Fresh full results are written to fresh-recheck.json. The --skip-base switch is
only for iterative local work and does not establish a fresh full rebuild.
The delivered fresh-logs/ files match the new-module compiler log hashes in that
record. standalone-entry-check.json separately records a successful public-entry
check using only this directory's Lake import configuration and fresh objects.

For a standalone setup, run lake update in this directory, fetch the pinned
mathlib cache, and then run python3 verify_followup.py. Relevant analytic cache
targets include Mathlib.Analysis.SpecialFunctions.Complex.CircleAddChar and
Mathlib.Analysis.InnerProductSpace.PiL2; the preserved base sources require their
own listed mathlib imports as well. This can require a substantial download.

SCOPE

This completes the standard-complex interpretation of the checked (4,2) formula.
The companion general (4,0) enumeration is outside this block. Ranks, connectivity
and the smaller 48-qubit finite count remain at their earlier recorded evidence
levels; no new distance or decoder-performance claim is made.
Canonical inventory: 187 entries, 111 eligible targets, 3 complete canonical Lean
targets. This follow-up adds zero canonical questions or complete canonical targets.

UNCHECKED DEVELOPMENT CANDIDATES

The candidates/ directory preserves the unsuccessful optional 48-column consumer
attempts. They are excluded from the checked module list and default build.
followup-candidates.json records interruptions, the final bounded timeout, source
hashes and the unchecked dependent complex consumer. These files are research
leads, not complete Lean certificates. The 192/72 counts retain their earlier
independent exact Python/C++ evidence.
