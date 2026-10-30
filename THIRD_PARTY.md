# Rights and provenance inventory

Audit baseline: `1dbe3fbab99c8c43dbc8bc7abafff663d9898b4c` (master after PR #59),
2026-10-30. Read this together with [LICENSING.md](LICENSING.md).

## Coverage and limits

All **5,183 tracked paths** were inventoried by type and location, including
955 Lean, 405 Python, 48 R and 32 C++ files; these counts include vendor and
archival duplicates. Source text was searched for license, copyright,
copy/adaptation, source URL and package-use indicators. Selected implementations,
provenance records, dependency manifests and source headers were read manually.
This was a practical static audit, not a line-by-line ownership investigation or
a complete software bill of materials. No research code was executed.

The scope rules select **1,209 code paths** at this baseline (888 Lean, 292
Python, 29 C++), subject to the original-code/third-party exceptions. They do
not certify those paths' ownership. The two existing license files listed below
were compared byte-for-byte with their pinned upstream versions and preserved.
The ten retained Bolza circuits and parameter CSV also match their pinned upstream
files byte-for-byte. Of 53 vendor files at the baseline, 52 match upstream; the
remaining difference is the recorded SciPy import patch. This change adds a
comment identifying that modification without altering execution.
All nine tracked ZIP archives had their entry lists inspected; none contained a
file named for LICENSE, COPYING or NOTICE. Archive payloads were not individually
rights-cleared. The archives and unpacked paper artifacts are excluded rather
than silently rewritten; future redistribution bundles need their own notices.

The root `LICENSE` is the unmodified standard Apache-2.0 text, byte-identical to
[Apache's published repository copy](https://github.com/apache/.github/blob/main/LICENSE)
as retrieved for this audit (SHA-256
`c71d239df91726fc519c6eb72d318ec65820627232b2f796219e87dcf35d0ab4`).
No invented copyright notice has been appended.

## Retained quantum inputs and generator

Paths in this section are relative to `formalization/higgott-quantum-decoding/`.

| Material | Provenance and existing terms | Treatment |
| --- | --- | --- |
| `inputs/bolza/*.stim`, `inputs/semi_hyperbolic_parameters.csv` | Oscar Higgott's `hyperbolic-floquet-data`, revision `457975f0d6c67b3a505aacf44589d36779f5dcc1`; [Apache-2.0 LICENSE](https://github.com/oscarhiggott/hyperbolic-floquet-data/blob/457975f0d6c67b3a505aacf44589d36779f5dcc1/LICENSE), retained as `inputs/bolza_LICENSE` | Imported material, not original VibeMath code. The upstream [README attribution](https://github.com/oscarhiggott/hyperbolic-floquet-data/blob/457975f0d6c67b3a505aacf44589d36779f5dcc1/README.md#attribution) requests citation of Oscar Higgott and Nikolas P. Breuckmann, *Constructions and performance of hyperbolic and semi-hyperbolic Floquet codes* (2023), [arXiv:2308.03750](https://arxiv.org/abs/2308.03750). Preserve that credit and the supplied license. |
| `vendor/honeycomb-boundaries/` | Strilanc's planar-honeycomb generator, revision `cc33baac44c7831bd643db81d0053f8ec6eae9d8`; [Apache-2.0 LICENSE](https://github.com/Strilanc/honeycomb-boundaries/blob/cc33baac44c7831bd643db81d0053f8ec6eae9d8/LICENSE), retained in the vendor directory together with its README | Existing upstream license applies. `src/hcb/tools/analysis/probability_util.py` changes the SciPy `LinregressResult` import; the exact existing patch is in `provenance/honeycomb_scipy_compat.patch`. |
| `circuits.py`, `prepare_historical_circuits.py`, `circuits/`, `historical_circuits/`, revision scripts and generated outputs | `circuits.py` preserves imported Bolza schedules, replaces noise channels and changes duration; `planar()` calls the vendored generator. Historical circuits serialize these constructions. | Entire investigation is held outside the new grant. Generator execution does not by itself resolve rights in outputs; retained source schedules and adaptations require separate treatment. Keep both upstream licenses and provenance when redistributing these constructions. |
| `source-evidence/`, source excerpts and evidence appendix | Higgott dissertation; see `source-evidence/README.md`, crop manifests and `provenance/source_audit.md` | Excluded. Public access and inclusion as research evidence are not an Apache grant. Underlying dissertation rights and any applicable permissions remain separate. |

The upstream license appendices contain example copyright placeholders, not
named copyright notices for VibeMath. No copyright holder is inferred from them.

## R, SEM and latent-factor material held for review

- `formalization/latent-contrasts/osf/` contains **nine imported R files**, plus
  results, from Jeffries and Bovaird's [OSF project q9yu8](https://osf.io/q9yu8/).
  Its local README records retrieval on 2026-10-27. No license grant for these
  copies is recorded locally. Public download access does not settle permission
  to relicense. Excluded until the exact source license/permission is established.
- `formalization/polytomous-person-fit/simulation/personfit.R` explicitly says
  `fast_HiT` is the `se = FALSE` branch of `mokken::coefH`, and other functions
  follow complete-data branches of `PerFit::Gnormed.poly` and `PerFit::U3poly`.
  The pinned CRAN mirror declarations are GPL (>= 2):
  [mokken 3.1.2 DESCRIPTION](https://github.com/cran/mokken/blob/5afc93a8c268a63fdfe2d98ab08bbf05593e23b4/DESCRIPTION)
  and [PerFit 1.4.7 DESCRIPTION](https://github.com/cran/PerFit/blob/c9df433cba3d7b03d16284e832d55785cb90464c/DESCRIPTION).
  Formula reimplementation versus copied/adapted expression has not been
  established; exclude the implementation and callers pending source comparison
  and determination of applicable notices/distribution terms.
- `formalization/kupzyk-power-assumptions/scripts/model.R` identifies itself as
  a translation of Kupzyk (2011), Appendices A/B. The source-expression rights
  and translation boundary need review; this is not merely a package dependency.
- Abbott, Chumney, latent-contrasts, person-fit and Kupzyk R workflows call
  third-party packages. For example, [lavaan 0.6-19 DESCRIPTION](https://github.com/cran/lavaan/blob/73a0759141abe0cb12dbb0c7783f8419133e022f/DESCRIPTION),
  [lme4 1.1-37](https://github.com/cran/lme4/blob/1.1-37/DESCRIPTION), and
  [nlme 3.1-168](https://github.com/cran/nlme/blob/3.1-168/DESCRIPTION) declare
  GPL (>= 2); [OpenMx 2.21.13](https://github.com/cran/OpenMx/blob/2.21.13/DESCRIPTION)
  declares Apache-2.0. These are representative recorded versions, not a complete
  dependency audit or a claim that all investigations use the same versions.

All 48 R files are held outside the new grant. Mere use of an interpreter/tool,
calling or linking a package, copying its implementation and distributing a
combined work are different facts. This audit does not conclude either that
all such scripts must be GPL or that an Apache label clears redistribution of
any combination. Resolve actual copies, versions and distribution boundaries
before extending the grant to this material.

## Lean, mathlib and original computations

`formalization/dyadic-rank/lake-manifest.json` and
`formalization/correlated-residuals/lake-manifest.json` pin mathlib at
[5f7b4198d22a9c82e1c698a379334fe128095c82](https://github.com/leanprover-community/mathlib4/blob/5f7b4198d22a9c82e1c698a379334fe128095c82/LICENSE)
and [79e94a093aff4a60fb1b1f92d9681e407124c2ca](https://github.com/leanprover-community/mathlib4/blob/79e94a093aff4a60fb1b1f92d9681e407124c2ca/LICENSE).
Both license files were retrieved and identify Apache-2.0. Toolchain files pin
Lean [v4.36.0-rc1](https://github.com/leanprover/lean4/blob/v4.36.0-rc1/LICENSE)
and [v4.22.0](https://github.com/leanprover/lean4/blob/v4.22.0/LICENSE), also Apache-2.0.
The manifests additionally identify transitive Lake dependencies; those retain
their own terms and are not relicensed here.

Reviewed examples such as `DyadicRank/Basic.lean` import Mathlib, cite the source
mathematics and define this project's formal objects; `DyadicRank/SmallCases.lean`
proves local certificates. `formalization/absorbing-four-two/direct.cpp` implements
an exhaustive checker, and `formalization/correlated-residuals/delta_method.py`
implements a local variance calculation using NumPy. These support including
original proof/checking code without claiming the underlying mathematical results
or upstream implementations. No copying provenance was identified for these
examples. A search is not proof that other files contain no copied fragments.
Retain upstream headers/notices if copying is later identified; imports alone
are not a transfer of authorship. Building/distributing dependencies or binaries
requires checking their own license and notice requirements.

## Remaining review decisions

Confirm authority for any independently owned contributions; Git author labels
and repository ownership alone cannot establish it. Resolve the OSF grant,
package-derived person-fit code and dissertation translation before licensing R.
Separate the Higgott wrappers/outputs if a narrower future inclusion is desired.
Choose content licenses separately if wanted, and establish scholarly citation
credits before adding CFF metadata. None of these exclusions removes or changes
research evidence, package versions, proof behavior or existing permissions.

## Moss score-reliability replication (2026-10-30)

`formalization/moss-score-reliability/inputs/` retains unmodified `bfi.rda`,
`bfi.Rd` and DESCRIPTION from William Revelle's psychTools1.9.12, CRAN mirror
revision `eeb778ab5e334c454ccb6a87de0c9d7cafe1da73`, with its GPL(>=2)
declaration and GPL-2 text. Source attribution and file hashes are retained.
The original analysis code is **not copied**: its DESCRIPTION and LICENSE.md
conflict (CC BY-SA4.0 versus CC BY4.0); a hash-pinned external replay is documented.
One limited attributed Table3 source crop, the manuscript, data, results and all
new R wrappers remain outside the root Apache grant under LICENSING.md.
No whole dissertation or new content license is included; see this study's
`provenance/rights.json` and `inputs/NOTICE.md`.
