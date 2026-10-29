# Grokbot's assessment of the two Abbott replications

29 October 2026. This is Grokbot's assessment for issue 50. Grokbot is
the analysis merged from pull request 47, in `formalization/abbott-ctse/`.
The other report is the unmerged archive at commit
`af093699a8d3fa3471851615727e4b40603be234`. The comparison written from
that archive is a set of claims to check, not evidence.

The sources for the verdicts below are the merged note and its code,
the archive's note and its stored fits, the page crops of the
dissertation, the Mplus difference page, and Satorra and Bentler
(2001). No new fit was run.

## A. Claims about the merged note

| Claim | Verdict | What the artifacts show |
| --- | --- | --- |
| Both runs used skill revision `055e330`, blob `db47095` | Partly true | The reviewed head contains that blob, because it merges `055e330`. The analysis commit `2b0150c` does not. Its parent is `55086ee`, and the skill blob there is `057e11a`. The difference is the headline-first paragraph and one checklist line. The archive records `055e330` and `db47095` in `sources/provenance.json`. That blob is the file at that commit. The record is the archive's own statement that the file was read. |
| The merged note is the more usable account of the fits, and it uses lavaan and OpenMx | Confirmed, as a reading of the two texts | The merged note leads with the degrees of freedom, the residual index, the parsimony order, and the robust indices it does not recover. The archive note puts scope caveats and a single word, partial, on most rows. The merged fits are lavaan 0.6.17 and OpenMx 2.21.11. The archive fits are a custom normal-theory likelihood. This does not make every number in the merged note right. |
| .8602 against .86 was mishandled in the merged note | Not supported | The merged comparison table has no such row. Its expanded correlation is .8615, which also rounds to .86 at two decimals. The archive table calls .8602 against .86 partial. The numerical match and the limited scope are both real. They are an archive labeling problem. |
| The merged prose treats \((T_0-T_1)/c_d\), with \(T\) scaled, as the scaled difference, and calls 52.457 a match | Confirmed | The displayed formula defines \(T\) as the scaled chi-square and divides \(T_0-T_1\) by \(c_d\). That returns 52.4568, which rounds to the printed 52.457. The documented value on the same inputs is 74.3889. The code stores both. The verdict word attaches the match to the scaled difference. That identification is wrong. The correction is `paper/CORRECTIONS.md`. |
| The three rounding draws were offered as evidence of robustness | Not supported | The note says the draws did not converge and are not used as a tolerance. The output file has three rows, each missing. The comment above the function says thirty draws; the call uses three. Three non-convergences are not a band. The sentence "did not return a stable band" says more than those three rows show. That is looseness of wording, not a robustness claim, and it is not a correction of the fit record. |
| After rescaling the archive fits from \(N\) to \(N-1\), eight shared chi-squares agree within .014 | Confirmed for that pairing | From the archive's stored fit values, \(F\times 295\) against the merged nlminb Wishart chi-squares: initial, refined, general, span against the archive's external refined model, all, held, implied structure, and implied indicators. The largest gap is 0.0135, on the implied-indicators model. Refined is 450.690013 against 450.690326. The merged saturated-auxiliary chi-square, 678.873, is 0.018 from the archive's external refined fit and is not one of those eight. |
| The archive's 200 perturbations and the bounded standard-deviation check should be discarded because the merged note omitted them | Not supported | The archive JSON describes the 200 draws as exploratory, not as sampling uncertainty, and all 200 completed. The standard-deviation bound is conditional on a 0–100 range. Both are worth keeping in a supporting section. They do not lead either note. |

## The scaled difference

The dissertation page names a Satorra–Bentler scaled difference and
prints \(\chi^2(3)=52.457\), beside \(\chi^2(178)=295.571\) and
Scaling \(=1.463\). Satorra and Bentler (2001) put the normal-theory
chi-square difference in the numerator and divide by
\(c_d=(d_0 c_0-d_1 c_1)/(d_0-d_1)\). They write that the difference of
the two scaled goodness-of-fit statistics is not that test. The Mplus
page writes the same quantity, when \(T\) is the scaled chi-square, as
\((T_0 c_0-T_1 c_1)/c_d\), because \(T c\) is the normal-theory
chi-square.

The merged note's own implied-structure check treats the printed
chi-square as scaled in that sense: \(526.884\times 1.357=714.98\)
against a fitted normal-theory chi-square of 715.13. The printed
Akaike gaps sit within a tenth of \((T_0 c_0-T_1 c_1)-2\Delta d\).
Under that reading, which the note elsewhere relies on, the documented
refinement statistic is 74.3889 on 3 degrees of freedom, not 52.457.
The quotient that recovers 52.457 is \((T_0-T_1)/c_d\) with the scaled
values. Calling that quotient the scaled difference, and giving it a
match, was a mistake in the prose.

The general-factor line is a separate cell. The printed model degrees
of freedom differ by 1. The printed difference is −21.803 on 2 degrees
of freedom. The documented expression returns 7.2312 on 1 degree of
freedom. The other expression returns 4.0234 on 1 degree of freedom.
The merged verdict "no match" stands. The figure +4.02 in the "ours"
cell is the non-documented expression.

The normal-theory difference in the merged table, 77.41 against the
fitted 75.08, verdict close, is the numerator of the documented test.
The note does not call that row the scaled difference. It stands.

What the printed 52.457 does establish is that the displayed
refinement statistic equals \((T_0-T_1)/c_d\) on the printed scaled
chi-squares. It does not establish which calculation produced the
line. The loglikelihood route needs scaling factors that are not
printed. A correlation fixed at 1 is a boundary case, so the reference
distribution for the general-factor comparison is not settled by the
algebra. The original Mplus output is the missing record. None of this
is a finding that the dissertation's calculation has been identified.

The recomputation is in `paper/CORRECTIONS.md`. Python 3.12.3 did the
decimal arithmetic. The historical note was not edited.

## B. Problems in the archive run, and the skill gap

The archive run was weaker in the reader-facing account and in the
choice of engine. Some of that is a missing rule. Some of it is a rule
that was already there.

The skill said to fit models in R with an SEM package. It did not
require a preflight, and it did not require a departure to be written
down before a custom likelihood. The archive used SciPy. That is the
gap the engine preflight closes. The archive's two optimizers and
gradient check are a real validation. They belong in the fallback
record. They do not replace the record.

The skill's single verdict list included `partial` for a mixed claim.
The archive used that word for .8602 against .86, and for a plain
maximum-likelihood CFI against a robust CFI. The first is a numerical
match at two decimals, with limited scope. The second should not have
a numerical verdict. Those are the two-axis rule and the comparability
record. The merged note already separated several of these cases in
prose. The skill had not made the separation a check.

The archive note opens with the research question and a scope caveat.
The skill revision it records already said to report the original
headline first, whether it matched or not. That opening is a failure
to follow an instruction that was present, not evidence that the
instruction was missing. The stricter rule, that the first sentence is
our verdict, was added after both runs. It is already in the skill. It
is not repeated here.

The archive's scaled-difference arithmetic used the documented
formula. On that point the archive was right and the merged prose was
not. The skill said to check the formulas. It did not say that
recovering a printed number is a different claim from computing the
named procedure. That missing sentence is what let the merged note
call the recovering expression a match. The new check is there because
the merged note needed it.

The 200 draws and the range check are useful and were labeled, in the
archive JSON, as exploratory and conditional. The skill did not tell a
later note to keep them, to report the convergence count, and to stop
them leading the answer. The merged note's three failed draws show the
other failure mode: a short failed attempt described as not returning
a stable band. The diagnostic section covers both.

## C. What in the merged note should change

One correction survives. The scaled-difference formula was
misidentified, and the match on 52.457 was a match to the wrong
expression. `paper/CORRECTIONS.md` records it. The note and the outputs
stay as they were.

The refined CFI and RMSEA row places plain maximum-likelihood values
beside the printed robust values and says partial. The paragraphs
around the table say that the robust indices are not recovered and that
the comparison used is the normal-theory chi-square and the
standardized residual. A later table would flag the CFI pair and give
no numerical verdict. That is a change to the template. It is not a
second correction. The conclusion that the robust indices are not
reproduced from this matrix is already what the note says.

No other challenged number in the merged note was shown to be a false
result. The degrees of freedom, the parsimony order, the standardized
residual, the unscaled implied-structure chi-square, and the
normal-theory difference of 77.41 against 75.08 stand on the checks in
the note.

## The six questions in the issue

1. **Instructions, compliance, tools, and reporting.** The skill files
   differ by the headline-first paragraph, as section A says. The
   engine gap and the verdict gap are missing checks. The archive
   opening is a missed instruction that was already written down.
   Reporting choices, including how much diagnostic material leads,
   are separate from both.

2. **Numerical agreement and scope.** .8602 and .86 are a numerical
   match at two decimals. The reconstruction from a rounded matrix is
   limited in scope. The archive collapsed those. The merged note did
   not make that particular mistake. The skill now keeps the columns
   apart, and .0578 against .057 at three decimals stays `close`,
   because it rounds to .058.

3. **Comparability before a verdict.** The merged note did this for
   the chi-square, by comparing normal-theory values with \(T c\), and
   for SRMR. It did not do it in the CFI cell. The archive gave
   verdicts to plain-versus-robust and core-versus-auxiliary indices.
   The checker now withholds those.

4. **The scaled difference.** Section A and the correction. Printed
   arithmetic was recovered. The procedure named on the dissertation
   page was not the expression that recovered it. Original output
   would still be required to say where 52.457 came from.

5. **Sensitivity checks.** The three failed draws are not a robustness
   result, and the merged note does not say they are. They are also
   not a band. The archive's 200 completed draws stay as exploratory
   diagnostics. The standard-deviation bound stays, conditional on the
   0–100 range. Recomputing it gives a maximum of about 43.52 at the
   edge of the printed mean, against a printed 52.3. That
   incompatibility is conditional on the range. It is not a statement
   about a person.

6. **Usefulness of the report.** On the two texts, the merged note is
   easier to read and answers the fit question sooner. The archive
   note is more useful on the documented difference formula, the range
   check, and the perturbation count. A later note should take the
   merged note's order and the archive's formula, and put the
   diagnostics after the verdicts. The answer-first opening is already
   required. The excerpt in `notes/before-after-excerpt.md` shows the
   combined shape.

## What was not taken from the other proposals

Issue 43's full claim ledger, second-reviewer protocol, and
vintage checks are a different project. The comparability record and
the split between a numerical result and an unavailable input are the
parts that this case actually needed. Issue 44's corrected headline
rule, and issue 51's answer-first abstract, open-item investigation,
announcement post, and self-review list, are already in the skill.
They are not copied again.

## How the skill changes were checked

`notes/dot-run-validation.md` records the commands. Nineteen unit
tests passed. The live preflight on this machine exited 2 because
Rscript, lavaan, and OpenMx are not installed. No new end-to-end run
of either report was performed.
