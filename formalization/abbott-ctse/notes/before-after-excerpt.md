# Before and after: how a later Abbott note would open

This excerpt shows the structure the skill now requires. It is not a
replacement of `paper/paper.tex`. That note is unchanged. The formula
correction is `paper/CORRECTIONS.md`.

The answer-first opening below is the rule already recorded from the
Chumney note. The new pieces are the comparability record, the two
verdict columns, and the split between a documented procedure and an
expression that recovers a printed number.

## Before

The abstract opens with the research question. One verdict covers each
row.

| Claim | Published | Ours | Verdict |
| --- | --- | --- | --- |
| Scaled difference for three residual correlations | 52.457 on 3 df | 52.457 from the printed inputs | match |
| Refined model, CFI and RMSEA | .954 and .046 | .939 and .072, maximum likelihood | partial |

The formula displayed for the first row is \((T_0-T_1)/c_d\), with
\(T\) the scaled chi-square.

## After

The revised model's robust comparative fit index and root mean square
error of approximation are not recovered from the printed correlation
matrix. What this evidence does not establish is the original
full-information robust fit: the input is the rounded Table 3.2 matrix,
not the participant file. The degrees of freedom, the parsimony order,
and the standardized residual do come back.

Comparability, filled before the verdicts. Our side: normal-theory
maximum likelihood, Wishart multiplier \(N-1\), \(n=296\), saturated
means, the stated variable set, no robust correction. Printed side:
robust maximum likelihood, full-information maximum likelihood, the
sample that includes incomplete rows, scaling correction printed beside
the chi-square.

| Claim | Published | Ours | Precision | Numerical | Scope |
| --- | --- | --- | --- | --- | --- |
| CTSE with CPSE | .86 | .8602 | two decimals | match | limited |
| Refined SRMR, same variable set, correlation residuals | .057 | .0578 | three decimals | close | limited |
| Refined CFI, plain ML against printed MLR | .954 | .939 | — | flagged, no verdict | limited |
| Documented scaled difference, initial against refined | 52.457 | 74.3889 | three decimals | mismatch | limited: printed inputs only |
| \((T_0-T_1)/c_d\) on the scaled chi-squares | 52.457 | 52.4568 | three decimals | match of that expression | not the documented procedure |

.8602 is the archive's refined-model correlation. The merged fit's
expanded correlation, .8615, has the same numerical verdict. Both round
half up to .86. The scope stays limited. The CFI pair is withheld
because one side is plain maximum likelihood and the other is the
robust index. The last row recovers the printed 52.457 and is not given
the procedure's verdict. The documented value, 74.3889, does not match
the printed 52.457.
