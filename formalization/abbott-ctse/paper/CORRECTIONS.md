# Correction, 29 October 2026

This note corrects one identification in the replication of Abbott
(2010). The replication note, `paper.tex`, and the fit outputs are
unchanged.

The comparison table gives the scaled difference for the three residual
correlations a verdict of match, because an algebra on the printed
inputs returns 52.457. The displayed formula, with \(T\) defined as the
scaled chi-square, is \((T_0-T_1)/c_d\). That identification is wrong.
The arithmetic is not.

## What was printed

The dissertation's page 130, reproduced in
[figures/refined_fit.png](https://github.com/alectionary/vibe-math/blob/master/formalization/abbott-ctse/paper/figures/refined_fit.png),
reports a Satorra–Bentler scaled chi-square difference,
\(\chi^2(3)=52.457\), and cites Satorra (2000) and Satorra and Bentler
(2001). The same page prints the refined-model line
\(\chi^2(178)=295.571\), Scaling \(=1.463\). The initial model is
\(\chi^2(181)=350.161\), Scaling \(=1.456\). Page 131 prints the
general-factor line \(\chi^2(179)=319.462\), Scaling \(=1.488\), and a
scaled difference \(\chi^2(2)=-21.803\).

The replication note reads those chi-squares as the scaled statistics
and the scaling factors as the constants \(c\) for which the product is
the normal-theory chi-square. That reading is the one the rest of the
note uses. For the implied-structure model the product
\(526.884\times 1.357=714.98\) matches the fitted normal-theory
chi-square 715.13. The printed Akaike gaps sit close to the same
products. The initial-model gap is \(52830.056-52758.669=71.387\), and
\((350.161\times 1.456-295.571\times 1.463)-2\times 3=71.414\). The
general-factor gap is \(52799.519-52758.669=40.850\), and
\((319.462\times 1.488-295.571\times 1.463)-2\times 1=40.939\). These
are checks on the printed summaries. They support the reading. They do
not say how the printed difference was produced.

## The documented formula

Satorra and Bentler (2001) put the normal-theory chi-square difference
in the numerator. With \(c_d=(d_0 c_0-d_1 c_1)/(d_0-d_1)\), the scaled
difference is \((T^{\mathrm{ML}}_0-T^{\mathrm{ML}}_1)/c_d\). They state
that the difference of the two scaled goodness-of-fit statistics is not
that test.

The Mplus hand calculation,
[Chi-square difference testing](https://www.statmodel.com/chidiff.shtml),
writes the same quantity for a scaled chi-square \(T\) as
\((T_0 c_0-T_1 c_1)/c_d\), because \(T c\) is the normal-theory
chi-square. The quotient \((T_0-T_1)/c_d\), using those scaled values,
is a different expression.

On the printed inputs the two expressions are:

| Comparison | \((T_0-T_1)/c_d\) | Documented \((T_0 c_0-T_1 c_1)/c_d\) | Printed |
| --- | ---: | ---: | --- |
| Initial against refined | 52.4568, which rounds to 52.457, on 3 df | 74.3889 on 3 df | 52.457 on 3 df |
| General factor against refined | 4.0234 on 1 df | 7.2312 on 1 df | −21.803 on 2 df |

The first expression recovers the printed 52.457. The documented
expression does not. Neither expression returns −21.803, and the
printed model degrees of freedom differ by 1, not by 2. The table's
"no match" on that second line stands. The number the note puts in the
"ours" cell, +4.02, is the non-documented expression. The documented
value on these inputs is 7.2312 on 1 degree of freedom.

The code already stored both quotients. In
[fit_models.R](https://github.com/alectionary/vibe-math/blob/master/formalization/abbott-ctse/simulation/fit_models.R#L417-L424)
the column `diff_scaled_over_cd` is \((T_0-T_1)/c_d\), and
`diff_unscaled_over_cd` is the documented quotient. The names are easy
to read backwards. The values are in
[satorra_printed.csv](https://github.com/alectionary/vibe-math/blob/master/formalization/abbott-ctse/simulation/out/satorra_printed.csv).

The separate row for the normal-theory difference, 77.41 against the
fitted difference 75.08, is the numerator of the documented test. The
note does not call that row the scaled difference. That comparison
stands.

## What this does not settle

Recovering 52.457 shows that the printed refinement statistic equals
\((T_0-T_1)/c_d\) on the printed scaled chi-squares. It does not show
that this was the calculation in the original session, and it does not
show that the documented test was failed by the participant data. The
loglikelihood form of the Mplus difference uses different scaling
factors, and those factors are not printed. A correlation fixed at 1 is
a boundary restriction, so a chi-square reference for the general-factor
comparison would need its own justification even after the algebra is
settled. The original Mplus output is the record that would separate a
hand calculation on the scaled statistics, a different correction
factor, and a transcription of the printed line.

The recomputation is exact decimal arithmetic in Python 3.12.3
([python.org](https://www.python.org/)). No structural-equation program
entered it. The same arithmetic is the fixture in
`.agents/skills/replication-paper/fixtures/abbott_regression.json`.

## Reference

Satorra, A., and Bentler, P. M. (2001). A scaled difference chi-square
test statistic for moment structure analysis. *Psychometrika*, 66,
507–514. [10.1007/BF02296192](https://doi.org/10.1007/BF02296192).
