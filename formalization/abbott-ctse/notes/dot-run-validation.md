# What would have changed the archive run

29 October 2026. No new end-to-end archive run, and no new fit of the
Abbott models, was done for this note. The claims below were checked by
running the new tests on the archive's published numbers.

## Engine

The archive fit the models with a custom normal-theory likelihood. The
skill already said to use R and an SEM package. It did not make a
missing installation a recorded departure, so a run could change
engines without a ledger row.

`preflight.py` is that gate. On this Linux machine it exits 2:

```text
missing: Rscript, lavaan, OpenMx
reason: preferred engine is missing and no fallback record was given
```

The same command with a fallback file that has a name, a
justification, and an independent validation exits 0 and marks the
engine as a fallback. A name and a justification without the validation
are rejected. That is the behavior the archive run did not have: the
custom fit would have been either blocked or written down as a
departure, and the two-optimizer check the archive did perform would
have been the validation entry rather than a substitute for saying
which engine was missing.

R, lavaan, and OpenMx were not installed here, so this does not show
that the archive machine could have loaded them. The recipe is: install
R, lavaan, and OpenMx, rerun `preflight.py`, and expect exit 0 with
engine `lavaan+openmx`. Until that succeeds, the ledger row stays a
departure. The script uses the Python standard library and was checked
for GNU-only commands. It was not executed on macOS. The decision
function was called with `os` set to `Darwin` in
`test_fallback_needs_independent_validation`.

A justified fallback still does not make a plain maximum-likelihood
index comparable to a robust one. The comparability tests reject that
pair after the engine has been accepted.

## The .86 correlation

The archive's comparison called .8602 against the printed .86 a
partial result. `test_point_eight_six_is_a_numerical_match` returns
numerical `match` and scope `limited`, in separate fields, and does not
emit `partial`. `test_scope_stays_put_when_the_number_matches` uses the
same number with scope `exact` and scope `limited` and requires the
numerical field to stay `match`.

## Incomparable indices

The archive put a plain maximum-likelihood CFI beside the printed
robust CFI and gave the row a verdict. `test_core_plain_against_auxiliary_robust_is_flagged`
and `test_plain_ml_against_robust_chi_square_is_flagged` withhold the
numerical verdict. `test_srmr_with_the_same_variables_keeps_a_numerical_slot`
still allows SRMR when the record says both sides use correlation
residuals and the same variable set.

## The scaled difference

The archive already computed the documented value 74.3889 and did not
treat 52.457 as that test. The new check locks the same split, so a
later run cannot give the recovering expression the procedure's
verdict. `test_documented_formula_does_not_match_the_printed_refinement`
expects 74.3889 as the documented value, a numerical match only for
the other expression, and `procedure_validated` false.
`test_neither_expression_returns_the_printed_general_factor_line`
expects 7.2312 and 4.0234, neither of which is the printed −21.803,
and degrees of freedom 1 rather than 2.

## Diagnostics

The archive's 200 perturbation draws are kept by the skill as
exploratory, with a requested count, a completed count, and a failed
count, and they are not a confidence statement. The conditional
standard-deviation bound is kept the same way: it assumes the stated
0–100 range, and it does not lead the note. This labeling was checked
by reading the skill text against the archive's own description of
those draws. There is no new perturbation run.

## Command

From the repository root:

```sh
python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
python3 .agents/skills/replication-paper/scripts/preflight.py
python3 .agents/skills/replication-paper/scripts/checks.py
```

On 29 October 2026 the unit tests were 19 passed. The live preflight
exited 2 because Rscript, lavaan, and OpenMx were absent. The checks
script printed numerical `match`, scope `limited`, documented
difference 74.3889…, `procedure_validated False`, and
`incomparable_numerical None`. The frontmatter check
`quick_validate.py` reported the skill valid. That validator is not
part of this repository; it was run from a separate copy.
