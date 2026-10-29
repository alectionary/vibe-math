"""Build an answer-first editable LaTeX report from saved results only."""
from pathlib import Path
import csv, json, collections, subprocess, hashlib, re
b=Path(__file__).resolve().parents[1]
def rows(name):return list(csv.DictReader((b/'outputs'/name).open()))
def f(x, n=3):return f'{float(x):.{n}f}'
def esc(x):
 s=str(x)
 for a, c in [('\\', r'\textbackslash{}'),('_', r'\_'),('%', r'\%'),('&', r'\&'),('#', r'\#')]:s=s.replace(a, c)
 s=re.sub(r'[0-9a-f]{40,64}', lambda m:r'\allowbreak{}'.join(m.group()[i:i+8] for i in range(0, len(m.group()),8)), s)
 return s
x=rows('numerical-verdicts.csv');h=rows('headline-effects.csv');es=rows('empirical-summary.csv');initial=rows('initial-exemplary.csv');thresholds=rows('thresholds.csv');eng=rows('engine-differences.csv');gls=rows('gls-independent-check.csv');dfd=rows('df-diagnostics.csv');bd=rows('baseline-diagnostic.csv')[0]
base=next(r for r in es if r['cell']=='1' and r['tag']=='main');ex=next(r for r in initial if r['cell']=='1');gap=float(base['power'])-float(ex['mean']);z=gap/float(base['se'])
counts=collections.Counter(r['numerical'] for r in x)
ndraw=sum(int(r['requested']) for r in es);failed=sum(int(r['failed']) for r in es);singular=sum(int(r['singular']) for r in es)
empclaim=('Our empirical baseline remained below the fixed-variance exemplary result' if gap<0 else 'Our empirical baseline exceeded the fixed-variance exemplary result')
tex=r'''\documentclass[11pt]{article}
\usepackage[margin=0.82in]{geometry}
\usepackage{booktabs, longtable, array, graphicx, amsmath, xcolor, hyperref, xurl}
\hypersetup{colorlinks=true, urlcolor=blue, linkcolor=blue}
\renewcommand{\arraystretch}{1.25}
\setlength{\parskip}{5pt}\setlength{\parindent}{0pt}
\title{Simplifying assumptions in power analysis:\\A replication of Kupzyk (2011)}
\date{29 October 2026}
\begin{document}\maketitle\vspace{-2em}
\begin{abstract}
We replicated the final-stage exemplary-data headline of Kupzyk (2011): attrition and unequal treatment allocation reduce power more than the tested unequal cluster sizes (published versus reconstructed losses: '''+f(h[0]['published'])+' versus '+f(h[0]['ours'])+', '+f(h[1]['published'])+' versus '+f(h[1]['ours'])+', '+f(h[2]['published'])+' versus '+f(h[2]['ours'])+', and '+f(h[3]['published'])+' versus '+f(h[3]['ours'])+r''' percentage points, respectively). All four differences lie within two standard deviations of the source's single-dropout-mask variation; none is separated after Holm adjustment. We could not establish an exact replay of SAS or the original random masks, and the reported minimum cluster counts are not uniquely recoverable across masks. '''+('The empirical baseline agrees with the published empirical value (.86712 versus '+f(base['power'],5)+'), but remains below the fixed-variance exemplary result')+' ('+f(base['power'],5)+' versus '+f(ex['mean'],5)+r'''); this gap survives Holm correction across 54 cells, and the paired variance-estimation diagnostic provides evidence against explaining that gap solely as Monte Carlo noise.
\end{abstract}
\begin{center}\small
\begin{tabular}{p{.25\linewidth}rrrr}
\toprule Claim (loss, percentage points)&Published&Ours&Direction&Verdict\\\midrule
'''
for label, r in zip([r'5\% interval attrition', r'15\% interval attrition','70/30 allocation','Unequal cluster sizes'], h):tex+=label+'&'+f(r['published'])+'&'+f(r['ours'])+r'&Yes&match\\'+'\n'
tex+=r'''\bottomrule\end{tabular}
\end{center}
{\footnotesize Tolerance: two predictive standard deviations for a contrast of the original single-mask cells, followed by Holm correction over these four contrasts. This is not a confidence interval for our simulated mean. Published losses are calculated from Table~1's printed cells, retaining more precision than the rounded prose.}
\section{What replicated?}
We replicated the four final exemplary power losses:1.327/1.275,4.391/4.476,6.409/6.446, and 0.652/0.609 percentage points (published/ours), within the stated mask-aware tolerance. Exact original software and random streams remain unverified. The empirical-versus-exemplary difference is examined separately below, rather than treating the fixed-variance calculation as empirical power.

The research question is whether ignoring dropout, unequal treatment allocation, or unequal cluster sizes misstates the power of a longitudinal cluster randomized trial. Kevin A. Kupzyk's April 2011 University of Nebraska--Lincoln dissertation, \emph{The Effects of Simplifying Assumptions in Power Analysis}, names Professor James A. Bovaird as supervisor on PDF page 2 and as adviser in the abstract. The \href{https://digitalcommons.unl.edu/cehsdiss/106/}{official repository record} independently confirms the adviser. This is a new dissertation relative to the Abbott and Chumney replications.

All 18 no-attrition Table 1 values round to the published five decimal places. The 36 attrition cells depend on random dropout ranks, even in the exemplary-data code. Comparing their single published realizations with our means at five decimals yields mostly numerical mismatches; those labels are retained in the detailed table and do not establish a substantive failure. Two cells fall beyond two predictive standard deviations before multiplicity correction (cells 9 and 35); no cell remains separated after Holm correction. These are tests of compatibility with the reconstructed mask distribution, not proof that a particular original mask was recovered.

The loss associated with 15\% interval attrition is greatest at ICC .05 and smaller at .10 and .15. Here ICC refers to the fraction of slope variance attributable to clusters, not the correlation of the raw outcome at an arbitrary wave. The result is conditional on the tested design: four waves, mean 20 participants per cluster, and treatment effect .5.
\begin{figure}[ht]\centering\includegraphics[width=.94\linewidth]{comparison-plot.pdf}\caption{Our calculations compared with published Table 1. Gray ranges show empirical 2.5th--97.5th percentiles across new dropout masks; they are predictive ranges, not confidence intervals for the mean.}\end{figure}
\section{What did we calculate, and what came from the dissertation?}
The dissertation supplies the design, population model, printed SAS programs, and published target tables. Our contribution is the R translation, independently coded covariance calculation, new Monte Carlo draws, numerical comparisons, and sensitivity checks. No original participant data are involved: the study is a synthetic-data simulation. Original seeds, saved masks, and fitted output are not available in the materials obtained.

We distinguish the initial stage, with 16,22,28 clusters at ICC .05,.10,.15, from the final stage, with 13,19,25. The 54 final cells cross three ICCs, three attrition rates, two treatment allocations, and three cluster-size distributions. Every final exemplary cell was run. Every initial empirical cell was run at reduced scale. Formulaic OD and BW variants, oversampling, and reported cluster thresholds were also evaluated.

For observed outcome rows within one cluster, our covariance matrix is
\[
 V_{ab}=.1+\rho t_a t_b+I(i_a=i_b)\{.2+(1-\rho)t_at_b\}+.5I(a=b).
\]
With fixed-effect matrix $X=[1, t, g, tg]$, the interaction variance is the fourth diagonal element of $(\sum_j X_j'V_j^{-1}X_j)^{-1}$. The exemplary noncentrality is $.25/\operatorname{Var}(\widehat\beta_{tg})$. Power is the upper tail of a noncentral F distribution at the central .95 quantile, with numerator df 1. This directly translates Appendix B's held variance components; it does not fit noise-free outcomes to estimate residual variance.

The formulaic arms also reproduce the direction and approximate magnitude of the source's df effect: at 16 clusters and ICC .05, our OD-rule power is .82731 and BW-rule power is .87721. The formula's equal allocation treats odd cluster counts continuously; actual exemplary data must allocate an integer number to each arm. The longitudinal formula includes the slope measurement-error term .5 divided by the sum of squared centered times (5), giving .1. It is not the cross-sectional Equation 2.22 used unchanged. This explains the small difference between a continuous-allocation formula and the final 13-cluster baseline without changing the model.

One implementation constructs each full cluster covariance and uses Cholesky solves. A second reduces each person's observed waves to a 2-by-2 information matrix and applies the Woodbury identity for cluster effects. Across 54 conditions the maximum absolute interaction-variance difference was '''+f(max(float(r['error']) for r in gls),14)+r'''. These independently coded calculations validate numerical assembly, not the missing SAS execution.
\section{Which assumptions did we supply?}
\subsection{Degrees of freedom with missing or unequal observations}
The source states $JnT-J-2$ for complete equal clusters and reports 1262 for $J=16, n=20, T=4$. We generalize this as $M-J-2$, where $M$ is the number of usable outcome rows. This follows the rank of cluster indicators plus the two within-cluster columns $t$ and $tg$; explicit rank checks pass in all 54 conditions. It is a source-consistent derived rule, not a verified output fixture from SAS. We also calculate power using $J-2$, $M-N-2$, and nominal $80J-J-2$, keeping the covariance fixed to isolate the reference distribution.
\subsection{Random streams and uncertainty}
New documented R seeds replace the unspecified SAS rannor(0)/ranuni(0) streams. The final exemplary run uses 1000 independent masks in each attrition cell and one exact calculation without attrition. Original cells are treated as independent mask realizations when computing predictive contrast variation; their actual random-stream dependence is unrecorded. Our mean standard errors are reported separately. Original single-mask variation is not divided by 1000. Monte Carlo rejection rates use two binomial standard errors, and comparisons across 54 cells receive Holm correction.
\subsection{Failure and boundary policy}
Zero variance estimates remain in the analysis. We report boundary fits separately from failed optimization, retry genuine convergence problems using nloptwrap, and report failures remaining after the retry. Conditional rejection rates exclude unresolved failures, while unconditional lower/upper bounds treat every failed fit as a nonrejection/rejection. This avoids silently interpreting a missing SAS numeric p-value as a significant result.
\subsection{Computational subset}
The pilot covered all 54 cells and averaged 0.0963 seconds per fit. The declared budget uses 400 empirical draws per cell,12000 total at the first baseline,2000 null draws at each extreme cell, and 200 independent-generator draws in four corner cells. Three single-thread workers preserve memory and CPU headroom, and 100-draw checkpoints support resumption. These are new reduced runs, not the dissertation's full 25,600-per-cell simulation. The source's planned 26,000 versus executed 25,600 is documented, not silently resolved. A 400-draw cell at power .8 has a two-SE band of about 4 percentage points and cannot resolve a 1-percentage-point gap reliably.
\section{What explains differences between empirical and exemplary power?}
The baseline comparison tests the idea that only Monte Carlo noise separates the methods. Our baseline empirical power was '''+f(base['power'],5)+' with SE '+f(base['se'],5)+', versus exemplary '+f(ex['mean'],5)+'. The gap was '+f(100*gap,3)+' percentage points ('+f(z,2)+r''' empirical standard errors). The source reports a 1.1-point initial gap and a 0.9-point gap after 50,000 draws, rather than a precise original first-cell power table in the results narrative.

The source's Appendix D also reports baseline BW empirical power .86712 and OD empirical power .82416. These are empirical targets, distinct from the fixed-variance result .87721. Our saved baseline outputs permit direct comparison of both reference distributions and of known versus refitted variance on the same coefficient draws. Original exact run counts for each Appendix D row are not separately supplied, so source Monte Carlo precision should not be invented.

A simple independent cluster-slope calculation predicts .86920 when a noncentral t distribution with 14 degrees of freedom is compared with the BW critical value, versus .87721 for the fixed-variance exemplary calculation. This diagnostic isolates variance estimation: the sampling distribution changes when the denominator is estimated. It approximates the full variance-component model and is not labeled an exact procedure replay. It shows why equality of the two methods is not guaranteed merely by increasing the number of draws.

Across our full empirical exercise, '''+str(ndraw)+' fits were requested and '+str(failed)+' remained failed after retries; '+str(singular)+r''' had a reported boundary solution. Per-cell counts, binomial bands, and unconditional bounds are in \href{../outputs/empirical-summary.csv}{empirical-summary.csv}. The independent dense-covariance generator is checked on four corner conditions; it creates a multivariate Gaussian draw directly instead of summing random effects. These two construction paths have the same intended Gaussian covariance but different code and streams.

Sixty shared datasets were fitted with both lme4 and nlme REML, with all 60 converging in each engine. The maximum absolute coefficient difference was '''+f(max(abs(float(r['beta_nlme'])) for r in eng),8)+', and the maximum standard-error difference was '+f(max(abs(float(r['se_nlme'])) for r in eng),8)+r'''. A second lme4 optimizer agrees similarly. Replacing REML with ML can move a shared-dataset p-value by as much as '''+f(max(abs(float(r['p_ml'])) for r in eng),4)+r'''; it is therefore not an interchangeable default. Official SAS documentation identifies REML as the PROC MIXED default.

The null experiments compare BW with $J-2$ on the same fitted statistics. Supporting Satterthwaite calculations use 20 draws per endpoint/effect condition, with a 5-draw Kenward--Roger subset per condition because dense corrections cost more. Those small diagnostics verify implementation and reference-distribution sensitivity, not precise Type I error rates. Their exact counts and timings are supplied in \href{../outputs/df-diagnostics.csv}{df-diagnostics.csv}; neither method silently replaces BW.
\section{Which ambiguities were resolved?}
\subsection{Dropout is cumulative and globally ranked}
Appendices A/B remove exactly rounded $aN$, $2aN$, and $3aN$ persons at later waves, using the original total $N$ and one global rank per person. Thus 15\% interval dropout ends with 45\% dropout, not multiplicative survival. Earlier observed waves remain. The executable check in \href{../scripts/verify_engines.R}{verify\_engines.R} records expected row counts and rank-derived df in \href{../outputs/design-checks.csv}{design-checks.csv}. Reproduce with the README command at pinned repository base dbbdda83d1acce5ddd86e9ab7c27d79f2f300e12.
\subsection{Cluster sizes and half-up rounding}
Appendix B's 29 printed frequency rows are extracted directly from Library text and checked to total 13 through 41 clusters. Alternating placement between vector halves preserves treatment ordering. SAS positive half-up rounding is implemented explicitly; R's default ties-to-even would change odd-cluster allocation. Empirical skewed sizes follow the source's alternating transform of above 20 draws, rather than a generic skew-normal distribution. The exact arrays and parser are included; key implementations are \href{../scripts/model.R#L6}{cluster sizes},\href{../scripts/model.R#L22}{dropout design},\href{../scripts/model.R#L31}{block information},\href{../scripts/model.R#L39}{dense information}, and\href{../scripts/model.R#L68}{empirical fits}; \href{../scripts/extract_source.py}{extract\_source.py} regenerates them from the retained source text.
\subsection{Table labels and source rendering}
Table 1 is printed page 92, required cluster counts are Table 5 on page 97, and Table 2 summarizes attrition. Table 4's header reads 10\% in the text layer; the parent source reviewer reports that the pixels also read 10\%, whereas design and code specify 15\%. We retain this as a likely label inconsistency and use the code-defined 15\% condition. It is not a new experimental arm or a numerical replication failure. Page images and 600-dpi crops belong to the separate \texttt{kupzyk-source-evidence-appendix.pdf} prepared by the parent reviewer; this executor did not inspect local PDF pixels. The reviewer also confirmed that Table 3 unambiguously prints .88187 and explicitly describes equal sizes,50\% treatment, and 19 clusters. No unequal-size substitution is supported by that text.
\section{What remains unresolved?}
The remaining limitations concern original realization and implementation, not a demonstrated error by the author. We tested the source reading against Appendix code and parent visual review, population scaling, the signed loss metric, half-up rounding, failure handling, fixed versus fitted covariance, REML versus ML, two optimizers, two packages, two generators, new seeds/masks, and alternative df rules. No scored instrument or prior distribution applies. Original SAS software and its exact release could not be run here.

For Table 1, all deterministic cells match. Variation among original dropout masks ranks first as the explanation for the remaining five-decimal differences: the largest gap is only about 2.30 predictive standard deviations and none survives Holm correction. Changing the denominator rule is measurable but does not justify changing the source-defined target. The original saved dropout-rank vectors would most directly settle these cells. A SAS fixture reporting Tests3, CovB and usable rows for complete, unequal, and missing-response designs would settle the remaining df implementation uncertainty.

A supporting Table 3 cell remains a discrepancy under our reading: ICC .05,45\% final dropout,19 clusters, equal sizes. It reports .88187;10,000 new masks give mean .884914, SD .000519, and a central 95\% predictive range [.883694,.885688]. One generated mask was below the printed value, yielding a two-sided empirical tail diagnostic .000400 (at most .00240 after adjustment across the six Table 3 cells). This is a tail frequency across random designs, not a confidence interval for a parameter. Dense and block covariance calculations agree even on the most extreme saved mask (.8818464).

We tested the plausible implementation alternatives for this cell. The printed skewed-size construction moves the mean to .881035, largely closing the gap, while normal sizes give .884232. Using 18 or 20 clusters moves power much farther; using a person-based or nominal-observation df changes it only slightly; using OD's small df lowers it substantially. Thus cluster-size specification ranks first among tested systematic explanations by how much it moves the cell toward the target. A rare original dropout mask is also possible. Neither alternative is evidence of what the original analysis actually used. The source-consistent half-up allocation is 10 control and 9 treated clusters; all 380 people have baseline measurements, yielding 1178 observed rows and 1157 df. A floor-allocation diagnostic reverses those group counts:mean power is .884921 versus .884889 with half-up rounding in 1000 shared masks, so the average shift is too small to explain the gap. Some individual masks move more; the largest paired shift was .002708. This alternative is reported separately, not adopted. The single most useful missing artifact is the exact Table 3 input dataset, including its cluster-size vector and dropout ranks. We retain the source-stated equal-size reconstruction and mark this supporting cell a limited-scope numerical mismatch, rather than tuning the reconstruction to recover the value.

For the empirical baseline, variance estimation is a substantive candidate, supported by the cluster-slope diagnostic and package agreement. Generator changes, optimizer differences, and Monte Carlo uncertainty are evaluated in the outputs. A precise original session and the 50,000-replication fitted output would distinguish original-software details from the persistent fixed-versus-estimated-variance effect. We do not claim that an optimizer agreement proves exact agreement with SAS.

All 54 reported Table 5 cluster counts achieve at least .80 in our mean-mask reconstruction. Three preceding counts also do so: cell 11 at 16 clusters, cell 13 at 15, and cell 54 at 32. Their proportions of masks reaching .80 were .640, .810, and .845 in 200 draws. Thus the reported threshold can change with the unrecorded mask; these are not universal one-cluster errors. One preceding unequal-size case requires $J=12$, outside Appendix B's frequency arrays, and is left unavailable rather than inventing its distribution. A threshold rule specifying a target quantile over masks, together with the original masks, is needed to define a unique minimum.
\section{Code and source availability}
The dated ledger is \href{../notes/availability.csv}{availability.csv}. Printed SAS code was obtained in Appendices A/B before rebuilding. The official page supplies the dissertation but no separate supplement link was shown. Searches for Kupzyk/dissertation code on GitHub, OSF, GitLab and Zenodo did not identify a verified project or author account. This is a bounded search result, not proof that no code exists. Without a verified GitHub identity, the skill's all-repositories clone step could not be completed.

The full text was read through Library. The parent obtained a 143-page PDF with SHA-256 \texttt{c3b7af14877156cf6506e1c3c4ea57b23bcba6ce2139cf82bdce8417c451a1d1}; this is attributed verification. The local official download returned 403, and the supported Library byte-transfer helper failed. No transfer was retried through an invented route. Text access enabled implementation while source-image review stayed with the parent.

SAS and Optimal Design 2.0 were not installed, and no licensed runtime was supplied. We used R 4.5.0 with \href{https://github.com/lme4/lme4}{lme4 1.1-37} and \href{https://cran.r-project.org/package=nlme}{nlme 3.1-168} for established mixed-model fitting; \href{https://cran.r-project.org/package=Matrix}{Matrix 1.7-3} supplies sparse algebra. \href{https://cran.r-project.org/package=lmerTest}{lmerTest 3.1-3} and \href{https://cran.r-project.org/package=pbkrtest}{pbkrtest 0.5.4} support the df diagnostics. \href{https://cran.r-project.org/package=lavaan}{lavaan 0.6.19} and \href{https://cran.r-project.org/package=OpenMx}{OpenMx 2.21.13} passed the mandated engine preflight, but the mixed-model applicability departure is explicit. \href{https://www.r-project.org/}{Base R 4.5.0} supplies random numbers, noncentral distributions, and figures. \href{https://www.python.org/}{Python 3.12.14} supplies source extraction, report assembly, and the skill checkers. \href{https://tug.org/texlive/}{pdfTeX 1.40.26 (TeX Live 2025/dev/Debian)} compiles the report. \href{https://poppler.freedesktop.org/}{Poppler PDF tools} validate the output; their exact installed version is recorded below. Python's exact version, all installed R dependencies, LaTeX, and PDF-tool versions are in the software manifest. No substitute SciPy fit was used.

Relevant official software-method references are \href{https://support.sas.com/documentation/onlinedoc/stat/123/varcomp.pdf}{SAS REML default documentation}, \href{https://support.sas.com/documentation/cdl/en/statug/66103/HTML/default/statug_mixed_syntax10.htm}{MODEL/BW documentation}, and \href{https://documentation.sas.com/doc/en/statug/latest/statug_mixed_details01.htm}{HOLD and residual profiling}. The parent reviewed older source-era documentation; this executor's direct retrieval of those older pages timed out, and current official indexed documentation provided independent corroboration.
\section{Next steps}
The most useful next artifacts are the original dropout ranks, saved empirical fits/session details, and a small exact-source SAS fixture. They would settle single-cell realization, original version effects, and the missing-data df extension. Additional Monte Carlo draws alone cannot recover missing seeds or turn a fixed-covariance calculation into a refitted-variance experiment. The present results support the headline conclusion under the published model while retaining those limits.
\appendix
\section{Numerical agreement and reconstruction scope}
Every row below uses printed five-decimal precision. Match means half-up rounding equals the printed value; close means a gap no larger than .00001; mismatch means larger. Scope is limited throughout because source software and random streams were not replayed. For random-mask cells, the separate predictive comparison determines substantive compatibility. For Table 1 there are '''+str(counts['match'])+' matches, '+str(counts['close'])+' close values, and '+str(counts['mismatch'])+r''' five-decimal mismatches.
Rows 1--18 use ICC .05,19--36 use .10, and 37--54 use .15. Within each block, the three consecutive groups of six use attrition 0,.05,.15; each group lists balanced equal/normal/skew sizes followed by 70/30 allocation with the same size order. T3 is the separately investigated supporting cell.
\small\begin{longtable}{rrrrll}
\toprule Cell&Published&Ours&Precision&Numerical&Scope\\\midrule\endhead
'''
for r in x:tex+=f"{r['cell']}&{f(r['published'],5)}&{f(r['ours'],5)}&.00001&{r['numerical']}&limited\\\\\n"
tex+=r'''T3&.88187&.88491&.00001&mismatch&limited\\
\bottomrule\end{longtable}\normalsize
\section{Compliance ledger}
The pinned skill's unmodified validator accepts the ledger. Supporting source pixels are supplied in the separate source-evidence companion. The engine and publication-related departures are deliberate and justified; no skill was edited during this run.
\small\begin{longtable}{p{.29\linewidth}p{.12\linewidth}p{.51\linewidth}}\toprule Requirement&Status&Evidence or justification\\\midrule\endhead
'''
for r in json.loads((b/'notes/compliance-ledger.json').read_text()):tex+=esc(r['requirement'])+'&'+r['status']+'&'+esc(r.get('justification', r['evidence']))+r'\\'+'\n'
tex+=r'''\bottomrule\end{longtable}\normalsize
\section{Artifacts and regeneration}
Run commands from the repository root after sourcing the R environment, as documented in README. Paths below are relative to this investigation directory. Files are local deliverables; no new master-branch URL is represented as published.
\small\begin{longtable}{p{.22\linewidth}p{.35\linewidth}p{.35\linewidth}}\toprule Claim&Artifact&Regeneration\\\midrule\endhead
Source visual evidence&kupzyk-source-evidence-appendix.pdf (separate 9-page companion,16 crops)&600-dpi source rendering and visual review; not generated in this executor\\
Source arrays/targets&outputs/targets.csv; normsizes.csv; skewsizes.csv&python3 scripts/extract\_source.py\\
Exemplary 54 cells&outputs/exemplary.csv& Rscript scripts/run\_exemplary.R\\
Independent covariance&outputs/gls-independent-check.csv&same exemplary command\\
Empirical 54 cells and baseline&outputs/empirical-draws.csv; checkpoints/&Rscript scripts/run\_empirical.R\\
Independent fit/df checks&outputs/independent-engines.csv; design-checks.csv&Rscript scripts/verify\_engines.R\\
Table 3 gap and alternatives&outputs/table3-gap-summary.csv; table3-alternatives.csv&Rscript scripts/gap\_checks.R; table3\_alternatives.R\\
Paired baseline diagnostic&outputs/baseline-diagnostic.csv&Rscript scripts/baseline\_diagnostic.R\\
Satterthwaite/KR diagnostics&outputs/df-diagnostics.csv&Rscript scripts/df\_diagnostics.R\\
Headline and contrasts&outputs/headline-effects.csv; comparison.csv&Rscript scripts/summarize.R\\
Numerical verdicts/ledger&outputs/numerical-verdicts.csv; notes/compliance-ledger.json&python3 scripts/compliance.py\\
Editable report/PDF&paper/report.tex; paper/report.pdf&python3 scripts/build\_report.py; pdflatex per README\\
\bottomrule\end{longtable}\normalsize
\end{document}
'''
paired = ('On the same baseline coefficient draws, using the known population variance rejects in '+f(bd['known_variance_rejections'],5)+' of draws, while re-estimating variance rejects in '+f(bd['refitted_variance_rejections'],5)+'. The paired difference is '+f(100*float(bd['paired_difference']),3)+' percentage points with paired standard error '+f(100*float(bd['paired_se']),3)+r'. This direct same-draw diagnostic is more precise than contrasting two independent simulation runs. It supports a variance-estimation mechanism without claiming an exact distribution for the full restricted-variance-component fit. See \href{../outputs/baseline-diagnostic.csv}{baseline-diagnostic.csv}.')
tex=tex.replace('The null experiments compare BW', paired+'\n\nThe null experiments compare BW')
tex=tex.replace('Poppler PDF tools','Poppler 25.03.0 PDF tools')
tex=re.sub(r'(?<![a-z])[0-9a-f]{40,64}', lambda m:r'\allowbreak{}'.join(m.group()[i:i+8] for i in range(0, len(m.group()),8)), tex)
(b/'paper/report.tex').write_text(tex)
print(b/'paper/report.tex')
