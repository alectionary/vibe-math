# Exact LP route for the fixed-law owner-star model

Read-only technical assessment, 2026-10-30. No solver installation, build, model solve, large download, or new cohort was performed. The Mac responsiveness hold remains in force. This note is a proposed future gate, not an accepted mathematical endpoint.

## Recommendation and present evidence

After the resource hold is lifted, prefer one bounded SoPlex exact-feasibility trial on the original rational semantic rows, with the artificial common margin removed or fixed to zero. This directly addresses the five tiny-slack failures of the existing recovery. It can pivot away from a numerically wrong active face instead of requiring us to guess that face. QSopt_ex is a credible alternative, but its modern Mac packaging and selected distribution's licensing require more care; there is no reason to set up both before testing one.

The current model has 7,943 allocation parameters, 20 equality rows and 35,898 inequality rows, including 1,429 accepted owner-star rows. Its numerical formulation adds one common margin variable. `two_basis_joint_fixed_star.py` prepares exact rational expressions first, then converts normalized rows to floating point. The SciPy `highs-ipm` call disables presolve, maximizes the margin, and saves only `x` in the numerical archive. It does not retain a HiGHS basis or dual certificate. The numerical optimal margin is approximately 5.06e-11; the recovered result is explicitly `EXACT_JOINT_FIXED_RECOVERY_FAILED`. These observations do not establish infeasibility.

Bindings for this assessment:

- Producer `two_basis_joint_fixed_star.py`: SHA256 `dec073fc5f2784bc29a0e50be5e0fc88d6ced202a2c48acb3fab9cd0524b5573`.
- Frozen input `two-basis-results/joint-fixed-star-original-cuts-point22.frozen.json`: SHA256 `386b94a5f491ad66d044f109ff796e3ab491c922b7b24a59d4693494962464e3`.
- Point22: SHA256 `4945dd10a5ec76c54311466ab0594b0c7b8fc2071eab4ae9a783a87143baad8f`.
- Anchors X[80,512], Z[186,433], with the specific fixed rational lambda stored in the frozen input. The five higher-pattern masses are zero by this chosen law.

The repository Markdown search found no earlier SoPlex/QSopt_ex assessment. No `soplex`, `esolver`, or `qsopt_ex` executable was found on PATH. This is not a complete installed-package inventory.

## Supported solver capabilities

| Requirement | SoPlex evidence | QSopt_ex evidence |
|---|---|---|
| Rational input and exact endpoints | Official exact mode parses rational data and combines iterative refinement, rational reconstruction/factorization and precision boosting. | Original authors describe an exact rational solver and callable GMP library; maintained fork exposes its exact solver. |
| Primal and infeasibility certificate extraction | API provides rational primal, dual, reduced cost, slack and Farkas vectors; availability and feasibility have separate status predicates. | Exact solver API accepts primal/dual output arrays and a basis; implementation has an exact infeasibility test and rational certificate output. A CLI status alone is insufficient. |
| Warm basis | API `setBasis`/`getBasis`; basis-file read/write. README supports any regular starting basis. | `QSexact_solver` accepts a basis argument; CLI `-B` reads and `-b` writes a basis. |
| Sparse data and resource risk | Sparse rational row/column APIs, row/column simplex representations. No model-specific peak-memory guarantee. | Sparse LP implementation; CLI has CPU/memory-limit options. OS enforcement and exact-factorization memory still need testing. |

SoPlex's documented exact settings are `feastol=0`, `opttol=0`, `solvemode=2`, `syncmode=1`; use `readmode=1` for exact file parsing and `checkmode=2` for rational final checking. Its bundled `settings/exact.set` is the documented starting point. Default floating-point mode is not sufficient. These are current online documentation claims, not a pinned locally tested build. [Official exact-mode guide](https://soplex.zib.de/doc/html/EXACT.php).

The SoPlex API also exposes `getBasisInverseTimesVecRational`, which requests rational factorization as needed. Its `hasSol` predicate explicitly does not itself assert feasibility. We must require the appropriate status and retrieve the exact values for independent checking. [Official API source](https://raw.githubusercontent.com/scipopt/soplex/master/src/soplex.h).

The main SoPlex repository describes sparse revised simplex, regular-basis hot starts, iterative refinement, precision boosting, exact rational LU and continued-fraction reconstruction. These establish suitability of the mechanism, not a running-time prediction for this model. [Official README](https://raw.githubusercontent.com/scipopt/soplex/master/README.md).

The QSopt_ex source shows initial/final basis flags, precision selection and rational solution output. Its exact implementation checks rational primal/dual feasibility after approximate solves and can increase arithmetic precision. We should use the callable API or explicitly verified output fields for a Farkas witness rather than assume the default CLI file contains every required certificate component. [Solver CLI source](https://raw.githubusercontent.com/jonls/qsopt-ex/master/esolver/esolver.c), [exact implementation](https://raw.githubusercontent.com/jonls/qsopt-ex/master/qsopt_ex/exact.c), [exact API header](https://sources.debian.org/src/qsopt-ex/2.5.10.3-2/qsopt_ex/exact.h).

## Mac, licensing and memory gates

SoPlex's source is Apache-2.0. Its official CMake instructions cover macOS; the documented exact configuration uses Boost and GMP, with MPFR available for higher precision. The Homebrew registry currently lists an Apple Silicon bottle and dependencies Boost, GMP and MPFR. This makes a native Mac path concrete, but does not establish compatibility with this particular machine, its OS version, or every exact-mode feature. Before any future setup, identify architecture/version and pin the package/source version and enabled arithmetic backends. No package installation is authorized by this assessment. [Official installation guide](https://raw.githubusercontent.com/scipopt/soplex/master/INSTALL.md), [Homebrew package registry](https://formulae.brew.sh/formula/soplex).

The original QSopt_ex author page reports testing on Mac OS 10.5; that is not evidence of present Apple Silicon support. The maintained fork documents GCC/Clang, GMP and an Autotools/libtool build, and declares GPL-3-or-later. Its README explicitly says the original research-use permission does not extend to fork modifications. The older author-page licensing wording is inconsistent with the fork's declaration; select and inspect one distribution's actual license rather than mix statements across releases. No legal conclusion or modern architecture guarantee is claimed. [Original authors](https://www.math.uwaterloo.ca/~bico/qsopt/ex/), [maintained fork README](https://raw.githubusercontent.com/jonls/qsopt-ex/master/README.md).

Additional official Homebrew metadata was checked remotely. The formula's test explicitly invokes exact mode (`-f0 -o0 --readmode=1 --solvemode=2`), and its build disables PaPILO. The JSON response supplies arm64 Tahoe, Sequoia and Sonoma bottle URLs and hashes. However, the responses are not version-consistent: the HTML page reports 8.1.0, whereas the JSON/formula response identifies 8.0.3 and JSON `generated_date=2026-07-20`. Preserve this discrepancy; do not combine the HTML version with an older bottle hash. This evidence supports a potential installation without local compilation, subject to a fresh architecture/OS/dependency/bottle match. Future setup should stop if it would require source builds. [Official formula source](https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/s/soplex.rb), [official JSON metadata](https://formulae.brew.sh/api/formula/soplex.json).

Neither source supplies a useful RAM bound for our instance. Sparse input does not prevent fill-in or growth of rational numerators and denominators. Report semantic nonzeros and coefficient bit lengths before launch; monitor actual peak memory externally. Do not instantiate a dense 35,918-square rational basis matrix, and do not infer a RAM estimate solely from the 7,943 variable count. A process memory limit may terminate allocation abruptly, so preserve the input and logs before solving. Native OS memory-limit behavior must be tested separately; it is not a proof mechanism.

## HiGHS basis reconstruction versus exact refinement

HiGHS exposes basis statuses, ordered basic variables and basis solves. Basic-variable IDs distinguish structural columns from row activities. These operations are numerical; they can identify a candidate combinatorial basis but do not supply a rational certificate. The existing SciPy archive contains no basis, so reusing a HiGHS basis would require a new native-API run and explicit capture. [Official HiGHS advanced API](https://ergo-code.github.io/HiGHS/dev/guide/advanced/).

A direct exact reconstruction can avoid a huge active-face Gaussian elimination. Write the original rows as `s=A x`, with the exact lower/upper bounds of each row activity. Let C be the basic structural columns and R the nonbasic row activities. After the identity columns for basic row activities are eliminated, a regular basis has |C|=|R| and the only solve needed is

`A[R,C] x[C] = s[R] - A[R,N] x[N]`,

where N denotes nonbasic structural columns and their exact bound values. Then reconstruct all row activities and check all original bounds. This system has order at most the number of structural variables (7,943 for margin-free feasibility), although it can still be too dense or have large rational fill. The relation follows by eliminating the row-activity identity block; it does not require trusting HiGHS numerical inverses.

Important gates are exact original row names/order, correct lower/upper/fixed/free statuses, exact nonbasic bound values, a nonsingular reconstructed submatrix, and a complete rational replay. Enum values and basis-file conventions must not be copied blindly between libraries. A free nonbasic variable at a numerical zero still needs an explicitly verified status convention. A bad or singular candidate basis, or a rational basic solution that violates a bound, rejects only that basis. It does not show infeasibility.

Direct reconstruction is an attractive cheap first check if a validated basis is already available and its reduced factorization is small. Here no such basis was saved, and five tiny slacks make the active face uncertain. SoPlex refinement is preferable as the first exact-solver route because it can make further simplex changes and then return an exact endpoint. Both routes still have possible fill/bit-growth costs; neither warrants an unbounded attempt.

## Exact input and independent acceptance bridge

Use the rational expressions returned by semantic model preparation, not the floating normalized CSR matrix or values read back from a decimal MPS export. Preserve hashes of point, fixed lambda, allocation elimination maps, accepted rank/star banks and their independent receipts. Assign stable row and variable names.

For a text input path, clear denominators separately in each row using a positive row LCM, preserving an explicit row-scale map. Then emit integer coefficients/RHS, explicit free structural variables and exact fixed bounds, and enable exact parsing. Avoid a global LCM. Alternatively use the rational sparse API directly, constructing rationals from integer numerator/denominator data. Slash-fraction text grammar has not been assumed. A parser roundtrip should compare every rational coefficient and bound before solving.

The first real instance should have objective zero and no artificial margin. Removing the margin does not remove any source-valid inequality. It asks exactly whether the chosen fixed law has an allocation satisfying the listed necessary constraints; feasibility on a boundary is acceptable.

For an exact primal, reconstruct all yX/yZ values through the saved elimination expressions and independently verify the original 7,200 target equations, boxes, bucket counts, 4,229 listed physical rank rows, and 1,429 star inequalities, as well as all fixed lambda/anchor conditions. Reuse `verify_two_basis_joint_fixed_star.py` through a narrow new output adapter; do not accept the solver's internal feasibility flag as this replay. A positive endpoint proves only feasibility of the listed fixed-law allocation relaxation, not full conditional matroid membership or a physical source frame.

For an infeasibility result, export rational multipliers on original semantic rows and explicit variable bounds. Convert all inequalities to one fixed orientation; require nonnegative inequality multipliers, unrestricted equality multipliers, exact cancellation of variable coefficients and a strict contradictory constant. Every positive normalization must be reversed exactly. If using residual correction instead, derive bounds for the actual reduced variables from the elimination expressions or retain explicit physical box rows; do not assume arbitrary reduced parameters lie in [0,1]. The existing semantic Farkas pattern is reusable, but its unrelated 76,008-variable source-case compiler is not the joint-model row map.

Exact infeasibility of this fixed-lambda model would exclude that chosen law for point22. It would not exclude point22 with a different lambda, the general five-parameter joint model, or any source case. The zero higher-pattern masses are a chosen face, not a universal source restriction.

## One bounded future experiment

1. After the resource hold is lifted and solver setup is separately authorized, pin one SoPlex build with exact arithmetic. Use tiny rational feasible/infeasible and degenerate/free-variable examples to test exact input, primal/Farkas extraction, row scaling and deliberate certificate corruption. Include one near-boundary non-dyadic example. No real-model inference from these controls.
2. Freeze a margin-free semantic model, row maps and input roundtrip receipt. Use one process, one thread, low priority, a 120-second internal limit and a 150-second external wall limit, with an explicit memory ceiling appropriate to the responsive-Mac requirement. Save logs and any exact endpoint before exit. These are proposed caps, not promised sufficient time.
3. Independently replay an exact primal or exact Farkas certificate. On timeout, memory limit, missing certificate, incorrect rational input, or failed replay, retain the negative diagnostic and stop. Do not launch a second solver automatically or interpret numerical status as a theorem.

All remote repository links in this note were inspected as current documentation on 2026-10-30; they are not immutable source checkouts. A future executable gate must record the actual version/commit, binary hash, arithmetic configuration and exact input hash.
