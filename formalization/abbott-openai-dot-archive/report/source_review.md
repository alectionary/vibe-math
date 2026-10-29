# Source, design, and claim review

## What did the dissertation claim?

The dissertation asks how creative self-efficacy is structured and measured, how it relates to other constructs, whether revised items improve the measurement model, and how participants' experiences give those results context. Its headline answer is a provisional two-dimension model: creative thinking self-efficacy (CTSE) and creative performance self-efficacy (CPSE), supported after post-hoc residual-correlation refinements, associated with openness and an earlier self-efficacy measure, preferred to the tested rivals by AIC, and accompanied by seven qualitative themes. These are **Abbott's original findings**, not a conclusion that the present reconstruction has established an empirical replication.

The source is Daniel H. Abbott, *Constructing a creative self-efficacy inventory: A mixed methods inquiry*, University of Nebraska-Lincoln, May 2010. The official landing page is <https://digitalcommons.unl.edu/cehsdiss/68/> and the full PDF is <https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1067&context=cehsdiss>. The examined copy has SHA-256 `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`, 7,626,437 bytes, and 283 PDF pages. Printed page 1 is PDF page 15. The archive copy's PDF metadata records 2026-08-30 processing by Appligent pdfHarmony 2.0 / Prince 15.4.1; May 2010 is the dissertation date, not this binary's creation date. This distinction does not imply that the substantive text changed.

## Which hypotheses were tested?

All six hypotheses were judged supported in the dissertation (printed p. 152 / PDF p. 166). The table below records the original decisions and operational tests, not replication verdicts.

| Claim | Original operational test and finding | Source |
|---|---|---|
| H1: The Revised model has adequate psychometric support | Initial model failed the specified close-fit rule; three residual covariances were added. Refined model: scaled chi-square 295.571, df 178, scaling 1.463, CFI .954, RMSEA .046, SRMR .057, AIC 52758.669. Original decision: supported. | pp. 102-103, 129-130; Appendix J p. 253 |
| H2: No general factor of creative self-efficacy | Rival fixes CTSE variance, CPSE variance, and their covariance to 1, while freeing their scale-setting loadings. Rival: scaled chi-square 319.462, df 179, CFI .945, AIC 52799.519. Its reported scaled difference test is negative and declared uninterpretable. Preference rests on fit/AIC/composite-validity comparisons. Original decision: supported. | pp. 103-104, 130-131; Appendix J pp. 253-254 |
| H3: BCSE is related to creative self-efficacy | Expanded model includes three Beghetto creative self-efficacy (BCSE) items and four openness items, with added residual covariances. Table 4.1 gives BCSE correlations with CTSE .53 and CPSE .69. Original decision: supported. | pp. 104-106, 134-137; Table 4.1 p. 135 |
| H4: Openness is related to creative self-efficacy | Same expanded model; Table 4.1 gives openness correlations with CTSE .45 and CPSE .53. Original decision: supported. | pp. 104-106, 134-137; Table 4.1 p. 135 |
| H5: Revised model outperforms theoretically justified rivals | With the same full manifest-item set, unused items are saturated correlates. Revised AIC 76438.957; All AIC 76674.046; Held AIC 76777.647. All and Held fail the stated close-fit criteria. Original decision: supported. | pp. 106-110, 138-145 |
| H6: Revised model outperforms empirically justified rivals | Principal-axis factoring and hierarchical clustering motivate Implied Structure and Implied Indicators models. AIC 76503.431 and 76570.611, respectively, versus Revised 76438.957. Original decision: supported. | pp. 110-113, 144-154 |

H2's implemented restriction is narrower than the broad verbal claim. Fixing both higher-order variances and their covariance to 1 makes the two standardized higher-order factors perfectly correlated. A reconstruction of that rival does not adjudicate every possible general-factor or bifactor model. H6's wording changes from “no worse” on p. 66 to “better” on p. 124; the consistently stated decision rule is preference by lower AIC. These distinctions should be preserved rather than silently broadening what a model comparison establishes.

## What were the data and analysis procedures?

The quantitative study used 308 respondents, including 93 males and 215 females, recruited from educational-psychology cognition, learning, or development classes in Fall 2009. Participants were undergraduates at a large Midwestern research university, predominantly pre-service teachers. The mean age is reported as 20.71 years (SD 1.92). Of these, 297 respondents supplied complete observations (90 males, 207 females; mean age 20.69, SD 1.93). Table 3.2 separately labels its descriptive matrix as **n = 296**; the document does not resolve that difference (pp. 84-85, 93-95, 125).

The quantitative instruments comprise 16 CTSE items, 12 CPSE items, 3 BCSE items, and 4 openness items, plus demographics. CTSE and CPSE responses were requested on a 0-100 confidence scale. The Revised model selects 21 CTSE/CPSE indicators, three per first-order factor; CTSE has four first-order factors (fluency, flexibility, originality, elaboration), and CPSE has three (domain, field, personality). BCSE and openness are used for the external-relation models (pp. 86-90, 100-101; Appendices D and J).

The original fitting procedure explicitly uses full-information maximum likelihood (FIML) with the Mplus MLR estimator, robust standard errors, and scaled chi-square statistics. Missing values are declared `MISSING = .` in Appendix J. Therefore a single rounded correlation matrix does not reproduce the individual response patterns, FIML likelihood, or robust correction. Refitting a covariance matrix is a meaningful limited reconstruction, not the original empirical rerun (pp. 96-98, Appendix J).

The document identifies Mplus **5.2** in Appendix J. It also names R (R Development Core Team, 2009), SAS (SAS Institute, 2008), `car::cookd`, `MASS::stdres`, Ranpura's KMO procedure, `GPArotation` oblimin rotation, and `hclust`/`pvclust` for clustering. Exact R, SAS, and package versions are not specified in the inspected methods and reference entries. Google Docs collected survey responses and exported CSV; instant-messaging clients recorded qualitative interviews. These are original software descriptions, not the versions used by our computation (pp. 91-99, 113, 117-121).

## What qualitative findings should be preserved?

The qualitative component was an explanatory follow-up, not a second test of the measurement model. Eight participants were selected, two in each high/low CTSE and high/low CPSE group, after 33 invitations (reported response rate 24.2%). Quantitative CTSE and CPSE means were correlated at .77, making clean extreme-case selection difficult. Interviews were text-based instant messages lasting about 30-45 minutes, using Google Talk, MSN, Facebook, or Yahoo IM. Participants were not told their group rankings until after the interviews (pp. 115-120, 157-162).

Abbott reports seven themes, with disconfirming material retained: **dark feelings** in low CTSE, **training** in high CTSE, **joy** across low and high CTSE, **normal** in low CPSE, **constraints** in high CPSE, **recognition** across low and high CPSE, and **internal blocking** in seven of eight participants. The source emphasizes that the last theme depends partly on differently worded follow-up prompts: one participant was asked about “challenges” rather than stopping/blocking and emphasized external obstacles (pp. 163-177; Table 4.7 pp. 174-175; Table 4.8 p. 177).

These are the author's situated qualitative interpretations, not frequency estimates for a population. The document provides excerpts, participant descriptions, the interview protocol, and photographs of coding sheets. Appendix L (printed p. 269, PDF p. 283) visibly contains **two photographed coding sheets on one PDF page**, explaining its reference to “two pages”; it is not evidence that an additional PDF page is missing. It does not provide a complete machine-readable transcript corpus or an independent recoding record. This replication preserves the reported themes and examines documentation; it does not claim to have rerun the interviews or replicated their coding.

## Which limitations does the original source acknowledge?

The original conclusions are explicitly provisional. The source identifies observational design, a narrow university/pre-service-teacher sample, no direct validation against creative-thinking or creative-performance measures, and possible effects of online survey collection. It also acknowledges post-hoc modification of the model, low voluntary interview participation, no nonverbal interview cues, interviewer authority, and inconsistent wording of the blocking question. Its mixed-method integration supplies factor-level rather than item-level context (pp. 155, 196, 206-208).

The missing original participant file limits additional checks. Neither the exact missingness pattern nor outlier diagnostics, Mardia tests, robust standard errors, factor-score selection of interviewees, or raw-data model likelihoods can be recovered from the printed correlation matrix. A population-level claim that an intervention raises creativity is beyond this dissertation's observational results; the dissertation itself proposes such interventions as future work.

## What source ambiguities remain?

The questionnaire-to-variable mapping needs the original codebook. Table 3.3's selected item wordings are not transparently identical to the selection implied by Appendix J variable names. For example, Appendix J selects `CPDOMA1 CPDOMA3 CPDOMA4` and `CPFIEL2 CPFIEL3 CPFIEL4`, whereas Table 3.3 lists the first three domain and field wordings in Table 3.1/Appendix D. Elaboration also has four questionnaire items but names spanning `CTELAB2` through `CTELAB5`, and the model uses 3/4/5. Appendix D gives question order but no variable IDs. Without the data dictionary, the ordering-to-ID inference is only an assumption, not a demonstrated contradiction. The computational reconstruction should freeze Appendix J's identifiers and leave semantic reconciliation unresolved. This is not assigned a numerical replication-failure verdict. The source ink was checked in 600 dpi crops: [Table 3.3](../outputs/source_crops/table_3_3_selection.png), [Appendix J](../outputs/source_crops/appendix_j_h1_selection.png), and [Appendix D ordering](../outputs/source_crops/appendix_d_domain_field_order.png). Regenerate these and the [Appendix L photograph](../outputs/source_crops/appendix_l_coding_sheets.png) with `python scripts/crop_source_mapping.py --pdf /tmp/abbott-unl.pdf`; [script](../scripts/crop_source_mapping.py) and [manifest](../outputs/source_crops/manifest.json) record crops, hashes, and software versions. This is a local artifact with no publication commit.

The power-analysis input is only partly documented. Page 96 promises population values and Mplus code in Appendix I, but the two appendix pages supply an analysis summary and selected parameter output, not full `MONTECARLO` / `MODEL POPULATION` input, all residual variances, or the full run log. Appendix I records 10,000 requested and completed replications, n = 200, seed 0, and selected statistics. Those printed statistics can be checked; recreating the original Monte Carlo experiment requires more input.

## What further research does the dissertation propose?

The forward-looking passages contain proposed research, not results established in the dissertation. The source screen distinguishes testable hypotheses from broad measurement-development directions; it does not claim to establish their current literature status.

| Source proposal | Type | Printed pages |
|---|---|---|
| Replicate CTSE-CPSE association and the four-factor CTSE / three-factor CPSE structure (hypotheses A-C) | Explicit replication hypotheses | 192 |
| Test whether CTSE and CPSE predict BCSE and openness (D-E) | Explicit replication hypotheses; observational association does not itself establish causation | 192 |
| Test high CTSE with training-seeking and low CTSE with dark-feeling moods (F-G) | New testable hypotheses from qualitative themes | 193 |
| Test high CPSE with constraints-seeking and low CPSE with reported normalcy (H-I) | New testable hypotheses from qualitative themes | 193 |
| Explain why training/internal control in this sample differs from external control in the earlier blogger study | Research direction | 188 |
| Clarify experience, constraints, creativity, and self-efficacy relations | Research direction | 189 |
| Determine whether internal blocking is common generally or specific to extreme CTSE/CPSE groups; standardize blocking/challenge prompts | Research direction | 176, 190, 208 |
| Replace weak indicators, consider domain-specific inventories, and develop short CTSE/CPSE forms | Measurement-development directions | 197-199 |
| Examine forced-choice conjoint measurement as an alternative to rating scales | Measurement-development direction | 199 |
| Repeatedly measure self-efficacy and creative expression to test temporal ordering | Longitudinal hypothesis | 200-201 |
| Compare control, behavioral-model, and cognitive-model interventions; test mediated changes in creative expression | Proposed randomized experiment | 201-202 |
| Fit a conditional associative latent growth model relating CTSE, creative thinking, CPSE, and creative performance; explore joy/dark feelings as predictors | Hypothetical model, not fitted data | 203-204 |

## What is available and what would close the gaps?

The full dissertation, its rounded descriptive matrix, its model syntax, the questionnaire and interview protocol, and selected outputs are available in the examined PDF. The bounded search ledger in [`../sources/availability_ledger.md`](../sources/availability_ledger.md) records the archive pages, document inspection, indexed repository searches, and GitHub code searches. No original respondent-level file or full interview corpus was obtained. An identified author-controlled GitHub account was not established, so the skill's every-repository clone step remains unperformed; indexed web search is not a substitute for that step or direct authenticated OSF/GitLab/Zenodo coverage.

The highest-value next input is a lawful, appropriately de-identified original dataset with the variable dictionary, preprocessing steps, missing-value coding, and Mplus 5.2 output. Those materials would allow FIML/MLR reruns and resolve the matrix's n = 296 versus 297 complete cases, item-ID mapping, and robust correction. Full power-model input would allow the separate Monte Carlo rerun. Qualitative recoding would require appropriately shareable full transcripts and the coding protocol, not just excerpts. No author contact or data request was made. The consent documents and IRB material describe restricted investigator access and three-year retention; they do not establish that raw records still exist or may now be publicly released (pp. 246, 248, 268).
