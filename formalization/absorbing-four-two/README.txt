Incidence-corrected elementary (4,2) counts
October 23, 2026 — bounded research block
Canonical inventory target: L-F16-other-absorbing, (4,2) component only.

Read RESEARCH-NOTE.txt for the theorem, complete written argument, source
comparison, explicit witness and evidence boundaries. Read verification.json for
the final successful checks and file hashes. fresh-core-recheck.json records
a separate successful rebuild of all 29 core modules from the extracted ZIP. prior-art.json records inspected
primary sources and access gaps. The combined inventory target also asks for
(4,0); this block does not mark that combined target complete.

Main result
For every finite binary Tanner graph with variable degree three and no
four-cycles, let W_uv be the proper common variable neighbors of an ordered
adjacent pair u,v, excluding variables on their shared check, and let t=|W_uv|.
Then

  4 N42 + sum_uv ||H 1_W_uv||^2 = sum_uv (t^2+2t).

Each W has at most four variables. For a cyclic lift, ordered-root normalization
reduces the count to representatives ((p,0),(q,d)). The finite-character Fourier energy
identity is checked in Lean; its standard complex exponential/norm specialization
is an ordinary written proof. Independent exact integer computations,
not floating point evaluations, supply the numerical counts.

The proposed M_j-only route is obstructed: two connected [[168,6]] QC-GHP codes
have identical full integer X-check Gram matrices (hence identical M_j at every
frequency) but N42=49 and N42=35. Their 12x12 cubic bases are in
cubic-matched-twelve.json (its label B denotes A-prime, not the fixed circulant B).
The counts, full check-Gram equality, evaluated M_j equality and CSS commutation
also have checked structural Lean proofs in the tensor incidence model. Binary
ranks and connectedness are exact external computations. Distance is
unspecified. No decoder comparison is made.

A smaller additional witness uses ell=24, a=1+x+x^5,
b=1+x^2+x^10 and b'=1+x^2+x^16=x^2*b(x^-1). Both are connected [[48,4]]
generalized-bicycle constructions with equal scalar M_j at all frequencies,
but N42=192 versus 72. Their N40 values differ (0 versus 24); the 168-qubit
pair above additionally matches N40. See gb48-fresh-results.json and the
verification manifest for the exact finite/formal evidence distinctions.

Reproduction
1. Run `python3 reproduce.py` from any directory with Python >=3.10 and a C++17
   compiler available. It independently expands X/Z, verifies CSS commutation,
   degrees, absence of four-cycles, connectedness, binary ranks and equal integer
   Gram matrices, checks the socket/Fourier expression, and runs a separate C++
   direct enumeration of all 32,018,910 four-subsets in each graph. It also checks
   the source's 882-variable example. Results go to fresh-check-results.json.
   The complex check has a rounding tolerance and is not evidence of exactness.

   For the smaller witness, run `python3 reproduce_gb48.py`. It independently
   checks both 48-qubit constructions and enumerates every 194,580 four-subsets
   per graph, using the separate C++ checker as well as Python definitions.

2. Lean is pinned by lean-toolchain and lakefile.toml. In a fresh environment,
   obtain the pinned mathlib dependency/cache, then run `python3 verify_lean.py`.
   Alternatively supply `--project /path/to/an/existing/pinned/lake/project`.
   Inside the research repository the existing sibling dyadic-rank project has
   the same pins. This direct runner builds the modules in dependency order,
   saves logs and a recheck-results.json, and stops at the first failure.
   Concrete finite checks can take substantially longer than general proofs.
   The default module list is taken from verification.json, excluding candidate
   certificates that did not finish. Original audit results and the precise scope of every successful module are
   recorded in verification.json; a source file's presence alone is not a check.

3. validation.py generates the frozen small-code validation domain and
   exhaustive-cases.txt. Compile `c++ -O3 -std=c++17 batch_direct.cpp -o batch_direct`
   and run `./batch_direct exhaustive-cases.txt` to independently check it. The
   recorded run checks 7,274 codes and 2,680,323,732 four-subsets. This is an exact
   finite-domain check, not a substitute for the general proof.

Formal interfaces
- GlobalCounting.count42 counts four-variable subsets whose incident check
  degrees are at most two and whose odd-check count is two. The separate
  counted_support_is_absorbing theorem proves that under cubicity/no-four-cycles
  these are exactly absorbing sets in the source's strict-majority convention.
  “Fully absorbing” is a stronger classical condition and is not imposed here.
- PairRootBridge.corrected_count_identity is the general theorem. The ordered
  root correspondence and factor four are proved, not asserted computationally.
- CyclicNormalization uses finite additive groups and an explicit socket-to-
  incidence map. There is no prime-lift assumption. FiniteFourier, SocketFourier,
  SocketIncidence and CyclicFourierCount prove the finite-character Fourier
  identity, including the incidence action and energy, for a faithful character
  satisfying star(psi a)=psi(-a). The standard complex exponential/norm
  specialization remains a written bridge. SocketCompletion and CompletionBridge
  prove the modular completion model and recovery of proper common neighbors;
  the Python implementation is validated separately.
- Concrete finite certificates and source-matrix bridge modules are labeled by
  their actual successful build status in verification.json.
- HGPPatterns and HGPCounts prove the product count from the base counts,
  giving 49 and 35 without a large finite reduction over 168 variables.
  HGPGramObstruction, HGPCSS and HGPSpectral prove the corresponding full Gram
  obstruction, CSS commutation, and obstruction from the actual evaluated
  rectangular matrices D_j=[A|beta_j I]. IncidenceEquivalence proves count
  invariance under renumbering; QuantumReindex checks the actual renumbering,
  transferring 49 and 35 to the source construction and literal Fin 168 tables.

All axiom reports are audited for sorryAx and external axioms. Standard Lean
axioms propext, Classical.choice and Quot.sound may occur. No native_decide is
used. The archive excludes prebuilt research .oleans, downloaded papers and
copyrighted source text. Older/superseded exploratory witnesses are not relied
on for the reduced counterexample. No external publication is authorized.
