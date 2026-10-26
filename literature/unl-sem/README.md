# SEM, CFA and related measurement-model dissertation seed

Checked October 26, 2026. [PR #6](https://github.com/alectionary/vibe-math/pull/6) · [Tracking issue #5](https://github.com/alectionary/vibe-math/issues/5) · [Dissertation CSV](dissertations.csv) · [CFA expansion](CFA-EXPANSION.md) · [Retrieval correction](RETRIEVAL-REPAIR.md) · [Formalization suitability](FORMALIZATION.md) · [Shared questions](../OPEN-PROBLEMS.md).

The expanded seed contains **89 SEM/CFA, growth/path or latent-measurement dissertations**, plus **10 explicitly adjacent IRT/latent-class/exploratory-factor or scale-structure dissertations** (99 records total). These are doctoral-dissertation records from 2001 onward; 7 now have complete-text question screens. All 99 authors have recorded downstream searches. The bibliography contains **41 selected source works**, with **24 readable full texts screened** and **10 source-stated statistical methods directions** indexed.

The CFA expansion adds 41 dissertations: 31 core records and 10 adjacent records. It corrects the initial literal-SEM search's omission of Daniel H. Abbott's 2010 dissertation. Public and ProQuest catalog copies are merged, not counted twice. [The original 58-record pass](FIRST-PASS.md) is a historical snapshot, not the current total.

## Current counts

| Measure | Count |
| --- | ---: |
| Core SEM/CFA/growth/path/measurement dissertation records | 89 |
| Adjacent IRT/latent-class/exploratory-factor dissertation records | 10 |
| Total deduplicated dissertation metadata records | 99 |
| Authors with recorded downstream searches | 99 |
| Authors linked to verified selected author/coauthor records | 29 |
| Selected source works, including earlier background and independent citation followups | 41 |
| Full source texts screened | 24 |
| Selected source works with full-text gaps | 17 |
| Located public-copy dissertation records | 41 |
| Completed dissertation full-text screens | 7 |
| Front-matter-only previews, excluded from full screens | 1 |
| Dissertation complete texts not yet recovered | 92 |
| Statistical methods directions indexed | 10 |
| Added precise theorem targets / completed proofs | 0 / 0 |

**Corrected retrieval scope:** all 99 archive records and Download controls were revisited. Seven complete dissertations were recovered and screened; one nine-page front-matter preview is excluded. The 92 records lacking a recovered complete text retain null question counts. Direct archive download attempts encountered browser challenges, which do not establish paywalls. Of 94 inspected ProQuest records, two offer open-access downloads and 92 offer a preview plus institutional-access/purchase options; this describes those publisher routes, not availability elsewhere. The 17 associated source-work text gaps also retain null counts. [Per-record evidence and recovered dissertation questions](RETRIEVAL-REPAIR.md).

## Search and inclusion criteria

The first pass searched explicit structural-equation terminology. The continuation adds confirmatory factor analysis, measurement models/invariance, latent growth, factor structure, bifactor/factor-mixture models, path analysis and related latent-variable terms. IRT and latent-class models are a separately labeled adjacent cohort. Generic regression, exploratory-factor-only leads without qualifying model evidence, keyword-only matches, master's theses, posters, articles and pre-2001 dissertations do not enter the core dissertation count. One proposed-but-unexecuted CFA with exploratory scale analysis is retained as an adjacent record; it is not counted as completed core CFA.

[Queries and result dispositions](searches.json), [CFA candidate decisions](cfa-discovery-decisions.json), [author outcomes](authors.json), and [source acquisitions](works.json) record the search. Name-only matches do not establish identity. Citation-only followups are distinguished from author/coauthor publications; the Griffin/Marincic name transition and the Hawley/Shaw identity lead are not asserted without a verified primary bridge. Earlier background is not relabeled post-dissertation work. This bounded search is not a publication census or recursive bibliography crawl.

## Mathematical suitability

The retained directions concern QTL methods, model-fit calibration, sampling accuracy and latent interpretation effects. Each has a separate statement gate describing mathematical objects, estimands and guarantees that must be fixed. Source-stated simulation requests are not promoted into universal bounds. Empirical questions about attitudes, leadership, instrument validity in a new population, clinical outcomes, or ecological observations stay outside mathematical target counts. See [the suitability worksheet](FORMALIZATION.md).

Peugh and Feldon's 2024 letter withdraws their 2020 fit-assessment recommendation after subsequent simulations. That historical request is not indexed as a fresh conjecture. The later dynamic-fit questions remain distinct. Mi et al.'s 2011 gene–environment SEM is recorded as related progress on the 2010 agenda, without claiming a full model-equivalence comparison from its abstract.

## Indexed statistical methods directions

### L-F103-pleiotropy-linked

Develop a Bayes-factor test distinguishing pleiotropic QTL effects from closely linked QTL.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072), Section6 Discussion and conclusion, future-work paragraph.

Statement gate: Specify the competing latent-genotype models, priors, marginal likelihoods, and identifiability/separation assumptions.

### L-F103-missing-phenotypes

Extend the Bayesian multi-trait SEM procedure to missing phenotypic observations.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072), Section6 Discussion and conclusion.

Statement gate: Specify missingness, imputation distribution, estimator, and a consistency or error guarantee; imputation itself is not a proof of validity.

### L-F103-mixed-outcomes

Develop multi-trait SEM methods supporting mixed binary and continuous traits.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072), Section6 Discussion and conclusion, final methodological paragraph; [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf), Discussion, PDF viewer p21 (printed p19).

Statement gate: Fix latent/observed links and a joint probability model; choose an identifiable parameterization and a specific inferential guarantee.

### L-F103-experimental-design

Extend multi-trait QTL SEM to include environments, blocks and gene–environment interactions.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072), Section6 Discussion and conclusion, final paragraph; [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf), Discussion, PDF viewer pp20–21.

Statement gate: Fix random-effect covariance and interaction structure before stating identifiability or estimator guarantees.

### L-F102-correlated-residuals

Extend the multi-trait QTL SEM analysis to correlated residual errors.

Source: [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf), Discussion, PDF viewer p20 (printed p18).

Statement gate: Specify a positive-definite residual covariance class and structural zero restrictions; unrestricted residual dependence can change identifiability.

### L-F102-nonlinear-traits

Extend the linear multi-trait QTL SEM to nonlinear trait relationships.

Source: [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf), Discussion, PDF viewer p20 (printed p18).

Statement gate: Specify the nonlinear family, noise assumptions, and the particular existence, identifiability or estimation claim; the source gives an allometric example, not a general theorem.

### L-F106-dynamic-fit-robustness

Determine how direct-discrepancy dynamic fit indices perform across SEM types, sample sizes, distributions and missingness.

Source: [F106](https://pmc.ncbi.nlm.nih.gov/articles/PMC11659859/), Letter, final paragraph before References.

Statement gate: Define a family of SEMs, null/alternative discrepancy thresholds, simulation calibration, and a finite-sample error/coverage criterion.

### L-F106-dynamic-fit-multilevel

Develop direct-discrepancy dynamic fit index procedures for multiple-group or multilevel analyses.

Source: [F106](https://pmc.ncbi.nlm.nih.gov/articles/PMC11659859/), Letter, final paragraph before References.

Statement gate: The authors identify unavailable multiple-group/multilevel support. Specify model class and a level/power guarantee before proposing a theorem.

### L-F132-subset-score-precision

Characterize how item-subset selection affects the accuracy of Angoff minimum-passing-score estimates.

Source: [F132](https://files.eric.ed.gov/fulltext/ED475369.pdf), Discussion, PDF viewer p13 (printed p12).

Statement gate: Specify the item-by-judge probability matrix, subset-sampling design, allocation/weighting and an error or coverage criterion relative to the full-test score.

### L-F134-interpretation-detection

Evaluate when latent-variable models reliably detect individual differences in the interpretation of vague quantifiers.

Source: [F134](https://www.researchgate.net/publication/274557890_On_the_Use_of_Latent_Variable_Models_to_Detect_Differences_in_the_Interpretation_of_Vague_Quantifiers), Discussion, printed p142; author-uploaded transcription webL1579–1585.

Statement gate: Specify ordinal responses, substantive factors, response-style factors/classes, identification constraints and a detection/error criterion. Separate identifiable model distinctions from labels that observations cannot distinguish.

## Selected source works and their outcomes

| ID/year | Work | Relationship | Full-text outcome |
| --- | --- | --- | --- |
| F102/2010 | [Regression-Based Multi-Trait QTL Mapping Using a Structural Equation Model](https://doi.org/10.2202/1544-6115.1552) | post_dissertation_publication | 4 method directions |
| F103/2010 | [Bayesian mixture structural equation modelling in multiple-trait QTL mapping](https://doi.org/10.1017/S0016672310000236) | post_dissertation_publication | 4 method directions |
| F104/2013 | [Analyzing Mixed-Dyadic Data Using Structural Equation Models](https://doi.org/10.1080/10705511.2013.769395) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F105/2020 | [“How Well Does Your Structural Equation Model Fit Your Data?”: Is Marcoulides and Yuan’s Equivalence Test the Answer?](https://doi.org/10.1187/cbe.20-01-0016) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F106/2024 | [The Answer is “No”: A Comment on Peugh and Feldon (2020)](https://doi.org/10.1187/cbe.24-07-0182) | post_dissertation_publication | 2 method directions |
| F107/2021 | [Incorporating Molecular Markers and Causal Structure among Traits Using a Smith-Hazel Index and Structural Equation Models](https://doi.org/10.3390/agronomy11101953) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F108/2017 | [Developmental etiologies of alcohol use and their relations to parent and peer influences over adolescence and young adulthood: A genetically informed approach](https://doi.org/10.1111/acer.13506) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F109/2018 | [Future orientation in adolescent and young adult cancer survivors and unaffected peers](https://doi.org/10.1002/pon.4588) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F110/2024 | [Participatory modeling for high complexity, multi-system issues: challenges and recommendations for balancing qualitative understanding and quantitative questions](https://doi.org/10.1002/sdr.1765) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F111/2022 | [Comprehensive Sexuality Education Improves Primary Students’ Explicit and Implicit Attitudes Toward Homosexuality](https://doi.org/10.1080/19317611.2022.2067282) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F112/2019 | [Selection and socialization influences on adolescent alcohol use: The individual and joint contexts of neighborhood disadvantage and population density](https://doi.org/10.1080/10826084.2019.1608247) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F113/2022 | [Developing and validating a comprehensive measure of coordination in patient aligned care teams](https://doi.org/10.1186/s12913-022-08590-2) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F114/2024 | [Teacher Leadership, Wellbeing, and Intent to Leave in US Rural Schools: Evidence from the 2020–21 National Teacher and Principal Survey](https://doi.org/10.3390/educsci14070758) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F115/2022 | [D-Optimal Design for a Causal Structure for Completely Randomized and Random Blocked Experiments](https://doi.org/10.1155/2022/7299086) | post_dissertation_publication | Unassessed: full-text gap |
| F116/2023 | [Equivalence testing to judge model fit: A Monte Carlo simulation](https://doi.org/10.1037/met0000591) | post_dissertation_publication | Unassessed: full-text gap |
| F117/2026 | [When Nesting is Nuisance in Cluster Sampled Longitudinal Research](https://doi.org/10.1080/00273171.2026.2720958) | post_dissertation_publication | Unassessed: full-text gap |
| F118/2011 | [The Comparative Performance of Conditional Independence Indices](https://doi.org/10.1177/0146621611407909) | post_dissertation_publication | Unassessed: full-text gap |
| F119/2026 | [Examining the accuracy of orthogonal latent mean comparisons in unbalanced conditions](https://doi.org/10.1177/01466216261452255) | post_dissertation_publication | Unassessed: full-text gap |
| F120/2015 | [An ecological perspective on rural, low-income mothers' health](https://doi.org/10.1080/19371918.2014.969860) | post_dissertation_publication | Unassessed: full-text gap |
| F121/2018 | [Direct and Indirect Effects of Nebraska Motor Vehicle Drivers’ Characteristics on Inattentive Driving at Highway-Rail Grade Crossings](https://doi.org/10.1177/0361198118794067) | post_dissertation_publication | Unassessed: full-text gap |
| F122/2009 | [Communicative and Relational Dimensions of Shared Family Identity and Relational Intentions in Mother-in-Law/Daughter-in-Law Relationships: Developing a Conceptual Model for Mother-in-Law/Daughter-in-Law Research](https://doi.org/10.1080/10570310802636334) | same_year_as_dissertation_order_unverified | Unassessed: full-text gap |
| F123/2022 | [Bridging the Gap: The Predictive Roles of Emotion Dysregulation and Stalking-related Attitudes on Offline and Online Stalking and Intrusive Harassment](https://doi.org/10.1177/08862605211043590) | post_dissertation_publication | Unassessed: full-text gap |
| F124/2010 | [Satisficing Among Reluctant Respondents in a Cross-National Context](https://academic.oup.com/poq/article/74/5/956/1816917) | post_dissertation_publication | Unassessed: full-text gap |
| F125/2026 | [Like night and day: a review of nocturnal predator communities and predation in annual row crop agroecosystems](https://pmc.ncbi.nlm.nih.gov/articles/PMC13186587/) | post_dissertation_publication | No suitable additional explicit mathematical target recorded |
| F126/2007 | [Structural equation modelling for studying genotype × environment interactions of physiological traits affecting yield in wheat](https://doi.org/10.1017/S0021859607006806) | post_dissertation_publication | Unassessed: full-text gap |
| F127/2011 | [Structural Equation Modeling of Gene–Environment Interactions in Coronary Heart Disease](https://doi.org/10.1111/j.1469-1809.2010.00634.x) | post_dissertation_publication | Unassessed: full-text gap |
| F128/2024 | [Development and initial validation of a creative self-efficacy scale for undergraduates: categorical confirmatory factor analysis and multidimensional item response theory](https://doi.org/10.3389/feduc.2023.1306532) | independent_citation_followup | No suitable additional explicit mathematical target recorded |
| F129/2022 | [Creative Self-Eﬃcacy Scale for Children and Adolescents (CASES): A Development and Validation Study](https://doi.org/10.21500/20112084.5410) | independent_citation_followup | No suitable additional explicit mathematical target recorded |
| F130/2020 | [Development and Evaluation of the Nebraska Assessment of Computing Knowledge](https://doi.org/10.3389/fcomp.2020.00011) | post_dissertation_author_work | No suitable additional explicit mathematical target recorded |
| F131/2024 | [Adverse Childhood Experiences among Adolescent Girls in Residential Treatment: Relationship with Trauma Symptoms, Substance Use, and Delinquency](https://doi.org/10.1007/s40653-024-00654-1) | post_dissertation_author_work | No suitable additional explicit mathematical target recorded |
| F132/2003 | [The Use of Subsets of Test Questions in an Angoff Standard Setting Method](https://files.eric.ed.gov/fulltext/ED475369.pdf) | pre_dissertation_background | 1 method directions |
| F133/2012 | [Measurement Models for Behavioral Frequencies: A Comparison Between Numerically and Vaguely Quantified Reports](https://www.mathematica.org/publications/measurement-models-for-behavioral-frequencies-a-comparison-between-numerically-and-vaguely-quantified-reports) | post_dissertation_author_work | Unassessed: full-text gap |
| F134/2013 | [On the Use of Latent Variable Models to Detect Differences in the Interpretation of Vague Quantifiers](https://doi.org/10.1093/poq/nfs072) | independent_citation_followup_identity_alias_not_asserted | 1 method directions |
| F135/2014 | [Aging and religious participation in late life](https://doi.org/10.1007/s10943-013-9741-y) | post_dissertation_author_work | Unassessed: full-text gap |
| F136/2011 | [Children's participation in foster care hearings](https://doi.org/10.1016/j.chiabu.2010.12.007) | post_dissertation_author_work | Unassessed: full-text gap |
| F137/2016 | [Peer victimization and prosocial behavior trajectories: Exploring sources of resilience for victims](https://doi.org/10.1016/j.appdev.2016.01.009) | post_dissertation_author_work | Unassessed: full-text gap |
| F138/2005 | [Flood and Psychological Well-Being: Direct, Mediating, and Moderating Effects](https://doi.org/10.1177/028072700502300102) | post_dissertation_author_work | Unassessed: full-text gap |
| F139/2015 | [Dispersion of marketing capabilities: Impact on marketing’s influence and business unit outcomes](https://doi.org/10.1007/s11747-014-0420-7) | post_dissertation_author_work | No suitable additional explicit mathematical target recorded |
| F140/2025 | [More than intentions: Importance of motherhood predicts first but not subsequent births](https://doi.org/10.1016/j.alcr.2025.100708) | post_dissertation_author_work | No suitable additional explicit mathematical target recorded |
| F141/2017 | [Greater Neural Adaptations following High- vs. Low-Load Resistance Training](https://doi.org/10.3389/fphys.2017.00331) | pre_dissertation_background | No suitable additional explicit mathematical target recorded |
| F142/2019 | [Partner congruence on fertility intentions and values: Implications for birth outcomes](https://doi.org/10.1177/0265407518787232) | post_dissertation_author_work | No suitable additional explicit mathematical target recorded |

## Excluded or historical passages

- **F104, Introduction; Additional Resources, PDF viewer pp23–24:** Tutorial supplies dyadic specifications and model-fit corrections; no additional explicit unresolved mathematical target found in the full-text screen. Pedagogical questions answered by the paper are not open conjectures.
- **F105, Final caveats, extracted lines537–558:** Small-sample/model/data robustness is a historical study request. The same authors’ 2024 letter reports later simulations and rejects their earlier recommendation. Kept as dated evidence, not added as a fresh open conjecture.
- **F107, Sections4–5, PDF viewer pp12–13:** Reported efficiency improvements concern the evaluated wheat data. The paper does not pose a universal dominance conjecture, so no such conjecture is invented.
- **F108, Limitations and future directions, lines883–904:** Age/sex-specific genetic and environmental effects are empirical questions. Reported non-convergence is an observation, not an author-stated impossibility or convergence conjecture.
- **F109, Section4.2 Study limitations, lines363–364:** Replication, population diversity and clinical behavioral associations require observations; no purely mathematical open target recorded.
- **F110, Challenges/recommendations; final discussion, PDF viewer pp21–22:** Stakeholder participation, aggregation choices and practical model-building recommendations do not supply an explicit mathematical statement. No formal guarantee is inferred from the word model.
- **F111, Limitations and Conclusion, lines1129–1134:** Larger/more general samples and educational intervention effects are empirical and social-science questions.
- **F112, Limitations and Future Directions, lines1085–1104:** Demographic/contextual differences and modern-sample replication are empirical. The paper’s four introductory research questions are addressed in its study, not leftover mathematical conjectures.
- **F113, Limitations and research/practice implications, lines173–185:** Instrument validation, patient roles and links to healthcare outcomes are empirical. Low sample variability does not state a general identifiability theorem.
- **F114, Section7 Future Research, PDF viewer pp12–13:** Leadership responsibilities, teacher/principal satisfaction and multilevel empirical follow-up do not pose a mathematical guarantee; multilevel terminology alone is insufficient.
- **F125, The Nocturnal Ecology Research Gap; Conclusion:** Predator identification, diel ecology, sampling observations and climate responses need empirical ecological investigation; no explicit mathematical conjecture extracted.
- **F128, Section4.1 and limitations:** Cross-population validation, associations and empirical measurement invariance are data-dependent. No author-stated mathematical guarantee is invented.
- **F129, Final discussion:** Developmental dimensions, sociocultural influences and temporal reliability/scale validation require observations; not mathematical conjectures.
- **F130, Discussion/Limitations, extracted lines532–534:** Race/ethnicity and international-student DIF, population replication and correlations with other assessments are empirical validation questions.
- **F131, Strengths and Limitations, extracted lines965–967:** Longitudinal causal ordering and multi-informant clinical assessments require new observations, not a proof of the social/clinical theory.
- **F140, Section5.1 Limitations and future directions, lines1007–1031:** Attitudes, social-location interactions and improved fertility-intention measurements are empirical; no mathematical open statement extracted.
- **F141, Discussion, PDF pp13–14:** Muscle glycogen/water and neural-adaptation questions require physiological observations; no explicit mathematical target recorded.
- **F142, Discussion, PDF pp18–19:** Changes in partner intentions and values across time require couple-level longitudinal observations; no mathematical conjecture recorded.
- **F139, Limitations and directions for future research, PDF p17 (printed p47):** Country/industry replication, additional capabilities and moderators, larger samples and longitudinal/network data are empirical research directions, not a mathematical theorem claim.

## Dissertation registry

Seven rows now have complete-text question screens, identified in the final column. The original 20 fully reviewed dissertations remain a separate historical cohort.

| Seed/year | Author and dissertation | Model family | Public-copy record | Full-text disposition |
| --- | --- | --- | --- | --- |
| UNL-SEM-D001/2003 | Liu, Wenli — [Factors influencing parental involvement in sexuality education for adolescents in the People's Republic of China](https://digitalcommons.unl.edu/dissertations/AAI3098171/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D002/2004 | Park, Hyesung — [Factors that affect information technology adoption by teachers](https://digitalcommons.unl.edu/dissertations/AAI3126960/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D003/2004 | Dhungana, Prabhakar — [Structural equation modeling of genotype x environment interaction](https://digitalcommons.unl.edu/dissertations/AAI3152605/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D004/2006 | Peugh, James L — [Specification searches in multilevel structural equation modeling: A Monte Carlo investigation](https://digitalcommons.unl.edu/dissertations/AAI3229555/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D005/2007 | Kim, Doyoung — [Assessing the relative performance of local item dependence indexes](https://digitalcommons.unl.edu/dissertations/AAI3249671/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D006/2007 | Daubert, Sara Jo — [Exploring the relationship of motivation and environmental attitudes to Servant Leadership](https://digitalcommons.unl.edu/dissertations/AAI3293927/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D007/2007 | Lieske, Jody L — [Relational victimization and internalizing outcomes: Do self -referent attribution tendencies matter?](https://digitalcommons.unl.edu/dissertations/AAI3293921/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D008/2007 | Zolnikov, Bryan J — [The association among neuropsychological functioning, response styles, cognitive content, and the severity of depression in people diagnosed with end -stage liver disease evaluated for a liver transplant: A structural equation model](https://digitalcommons.unl.edu/dissertations/AAI3278160/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D009/2008 | Kim, Jongheon — [An integrative analysis of transactional e -government web usage: The trust -risk model and Technology Acceptance Model perspectives](https://digitalcommons.unl.edu/dissertations/AAI3338898/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D010/2008 | LeClair-Underberg, Cassandra — [Communicatively coping with miscarriage: The impact of emotional support and narrative coherence on women's individual and relational well -being](https://digitalcommons.unl.edu/dissertations/AAI3326863/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D011/2009 | Rittenour, Christine E — [Communication and shared family identity in mother-in-law/daughter-in-law relationships: Implications for relational outcomes and future family functioning](https://digitalcommons.unl.edu/dissertations/AAI3350455/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D012/2009 | Hammonds, Joshua R — [Establishing a model of Communication Privacy Management theory: Examining the criteria that predict an emerging adult's likelihood to reveal private information to their parents](https://digitalcommons.unl.edu/dissertations/AAI3379241/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D013/2009 | Mi, Xiaojuan — [Genetic applications using structural equation modeling](https://digitalcommons.unl.edu/dissertations/AAI3350451/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D014/2009 | Kaminska, Olena — [Satisficing among reluctant respondents in a cross -national context](https://digitalcommons.unl.edu/dissertations/AAI3366966/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D015/2009 | Bonin, Michel F — [Vulnerability factors low control and high negative affect in the development of social anxiety and the use of safety behaviors](https://digitalcommons.unl.edu/dissertations/AAI3358954/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D016/2011 | Hosek, Angela M — [Extending intergroup theorizing to the instructional context: Testing a model of teacher communication behaviors, credibility, group-based categorization, and instructional outcomes](https://digitalcommons.unl.edu/dissertations/AAI3466790/) | explicit_SEM | Not located | Complete text screened |
| UNL-SEM-D017/2011 | Sarah J. Beal — [The Development of Future Orientation: Underpinnings and Related Constructs](https://digitalcommons.unl.edu/psychdiss/32/) | explicit_SEM | Located | Complete text screened |
| UNL-SEM-D018/2011 | Lee, DonHee — [The impact of supply chain innovation on organizational performance: An empirical study in the health care organization](https://digitalcommons.unl.edu/businessdiss/17/) | explicit_SEM | Located | Front matter only; unscreened |
| UNL-SEM-D019/2011 | Bice-Wigington, Tiffany — [Understanding mesosystemic influences on reported health among rural low-income women: A structural equation analysis](https://digitalcommons.unl.edu/cehsdiss/97/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D020/2012 | Deutsch, Arielle R — [A Test of a Conceptual Model of Sexual Self-Concept and its Relation to Other Dimensions of Sexuality](https://digitalcommons.unl.edu/psychdiss/48/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D021/2013 | Olson, Mark E — [Making the Grade: Do Nebraska Teachers and Administrators Working in Public Schools in 7th–12th Grade Settings Agree About What Constitutes Sound Grading Practice?](https://digitalcommons.unl.edu/dissertations/AAI3565006/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D022/2013 | Chumney, Frances L — [Structural equation models with small samples: A comparative study of four approaches](https://digitalcommons.unl.edu/cehsdiss/189/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D023/2013 | Lee, Dong Hyun — [The role of Triple-A in green supply chain management practices and organizational performance](https://digitalcommons.unl.edu/dissertations/AAI3558860/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D024/2014 | Hidalgo-Contreras, Juan Valente — [Incorporating causal structure among traits using a multitrait genomic selection index](https://digitalcommons.unl.edu/dissertations/AAI3636123/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D025/2014 | Sainath, Jyothsna — [Structural equation mixed models with an application to small area estimation](https://digitalcommons.unl.edu/dissertations/AAI3632751/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D026/2014 | Collins, Adam Marlin — [The social-ecology from child maltreatment to dating violence: The impact of bullying](https://digitalcommons.unl.edu/dissertations/AAI3630836/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D027/2015 | Tu, Xiaoqing — [A Longitudinal Examination of the Transactional Associations Among Child Emotion Regulation, Parenting Practices, and Family Contextual Factors Across the First Three Years](https://digitalcommons.unl.edu/dissertations/AAI3718723/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D028/2015 | Martinez, Leslie N — [Construction of an anti-Mexican American bias scale and its validation](https://digitalcommons.unl.edu/psychdiss/82/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D029/2015 | Cao, Yichun — [Motivation of Chinese frontline employees in a foreign-funded manufacturing company: A mixed methods study](https://digitalcommons.unl.edu/dissertations/AAI3685475/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D030/2016 | Zhao, Shanshan — [An investigation of motor vehicle driver inattention and its effects at highway-rail grade crossings](https://digitalcommons.unl.edu/civilengdiss/96/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D031/2016 | Katherine M. Kidwell — [Sleep, Executive Control, and Psychopathology in Children: A Longitudinal Study and an Examination of Brief Sleep Treatment](https://digitalcommons.unl.edu/psychdiss/89/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D032/2016 | Hope, Meredith O — [The impact of peer victimization in high school on first-year undergraduates' psychosocial adjustment and academic performance](https://digitalcommons.unl.edu/dissertations/AAI10143736/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D033/2017 | Zulfiqar, Najia — [Bidirectional Longitudinal Associations Between Teacher-Child and Parent-Child Relationship Quality and Children's Academic Competence](https://digitalcommons.unl.edu/dissertations/AAI10272856/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D034/2017 | Lester, Houston F — [Informative Hypotheses as a Methodological Middle-Ground to Detect Interpretational Confounding in Formative Measurement Models](https://digitalcommons.unl.edu/dissertations/AAI10608702/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D035/2017 | Jolly, Sushma — [Undergraduate Online Courses: Teaching, Cognitive, and Social Presence](https://digitalcommons.unl.edu/dissertations/AAI10637881/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D036/2018 | Maria Rosa Viñas-Racionero — [A Multifactorial Model of Threat Assessment Activity Applied to Educational Settings](https://digitalcommons.unl.edu/psychdiss/108/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D037/2018 | Sarah A. Taylor — [Exploring Adolescent Dating Violence in Rural Communities: A Mixed Methods Study](https://digitalcommons.unl.edu/cehsdiss/319/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D038/2018 | Chapla, Brooke A — [Shared Perceptions of the Classroom Environment and the Impact of Teacher Efficacy](https://digitalcommons.unl.edu/dissertations/AAI10980873/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D039/2018 | Venkateswaran, Kavitha Dharmalingam — [Social Class, Asian American Stereotypes, and Perceptions of Shame: An Investigation Within Career Construction Theory](https://digitalcommons.unl.edu/dissertations/AAI10841259/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D040/2019 | Kmail, Zaher M — [Optimal Design for a Causal Structure](https://digitalcommons.unl.edu/statisticsdiss/21/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D041/2019 | Emery, Alexandra Kristine Dahl — [The Protective Influence of Self-Compassion Against Internalized Racism Among African Americans](https://digitalcommons.unl.edu/dissertations/AAI27997710/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D042/2020 | Zajdel, Alyssa A — [Stigmatized Virginity and Masculinity: Exploring in Non-virgin Cisgender Heterosexual Men](https://digitalcommons.unl.edu/dissertations/AAI28025219/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D043/2020 | Christian, Bohdan M — [The Effects of School Leadership on Teachers’ Professional Practices on Teacher’s Classroom Practice: Evidence from TALIS 2013 US Data](https://digitalcommons.unl.edu/dissertations/AAI28001905/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D044/2020 | Evertson, David W — [The Influence of Principal Leadership on Teacher Collaboration: Does Effective Professional Development Mediate This Effect?](https://digitalcommons.unl.edu/dissertations/AAI27833241/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D045/2020 | Cassidy, Kendal — [Well-Being in Trans and Gender Diverse Individuals: An Investigation of Chosen Family Support](https://digitalcommons.unl.edu/cehsdiss/364/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D046/2021 | Abebe, Fitsum F — [Pre-Service Teachers’ Technological Pedagogical Content Knowledge(Tpack) Self-Efficacy and Development in K-6 Math](https://digitalcommons.unl.edu/dissertations/AAI28652898/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D047/2022 | Bell, Haley L — [Effects of Trans Discrimination on Mental Health through Social Support](https://digitalcommons.unl.edu/dissertations/AAI29162859/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D048/2022 | Kennedy, Joseph L. D — [Sexual Assault on College Campuses: Adapting and Updating Protective Behavioral Strategies](https://digitalcommons.unl.edu/dissertations/AAI29257178/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D049/2022 | Lukesh, Amanda R — [Teacher-Leader, Teacher-Teacher, and Teacher-Student Relationships: Which Makes a Difference in Teacher Self-Efficacy in US Middle Schools](https://digitalcommons.unl.edu/dissertations/AAI29168484/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D050/2022 | Roth, Taylor — [The Stress-Buffering Effect of Receiving Social Support on Resilience in Families of Children with Medical Complexity](https://digitalcommons.unl.edu/dissertations/AAI29167462/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D051/2023 | Engle, Jordan C — [Distributed Leadership and Its Effect on Rural Teacher Job Satisfaction and Intent to Leave or Move](https://digitalcommons.unl.edu/dissertations/AAI30575773/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D052/2023 | Collins, Elizabeth I — [How to Do QuantCrit: A Reflexive Account of Applying Critical Quantitative Methods to a Study of Black Women in STEM](https://digitalcommons.unl.edu/cehsedaddiss/351/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D053/2023 | Dammann, Anna Johnson — [Moderators of the Associations Between Early Childhood Sleep Problems and Elementary School Developmental Outcomes](https://digitalcommons.unl.edu/dissertations/AAI30570301/) | explicit_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D054/2024 | McGonigal, Patrick T — [Identity-Driven Targeted Violence: Attending to Identity, Emotion, and Personality-Related Predictors of Attitudinal and Behavioral Prejudice](https://digitalcommons.unl.edu/dissunl/64/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D055/2024 | Jeffries, Jay B. — [Navigating Non-Orthogonality: Exploring Latent Mean Differences in Unbalanced Conditions](https://digitalcommons.unl.edu/dissunl/216/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D056/2024 | Karen M. Alexander Glueckert — [The Relationship Between General and Content-Specific Classroom Practices and K-6 Student Math Achievement: A Multi-Method Analysis](https://digitalcommons.unl.edu/dissunl/60/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D057/2025 | Stowe, Hannah E. — [Landscape Effects on the Beneficial Arthropod Community in Agriculturally Dominated Environments](https://digitalcommons.unl.edu/dissunl/281/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D058/2025 | Miramonti, Amelia Anne — [Youth Sport Participation and Cognitive Development: The Need for Improved Measurement](https://digitalcommons.unl.edu/dissunl/314/) | explicit_SEM | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D059/2009 | David T. Bentz — [Online and Face-to-Face Classes: A Comparative Analysis of Teaching Presence and Instructor Satisfaction](https://digitalcommons.unl.edu/cehsdiss/53/) | CFA | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D060/2024 | Wick, Kelley Marie — [Development of A Multidimensional Measure of Wellbeing for Emerging Adults Utilizing a Convergent Parallel Mixed Method Design](https://digitalcommons.unl.edu/dissunl/198/) | CFA | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D061/2017 | Scott R. Frohn — [AN EVALUATION AND REVISION OF THE CHILDREN’S BEHAVIOR QUESTIONNAIRE EFFORTFUL CONTROL SCALES](https://digitalcommons.unl.edu/cehsdiss/292/) | CFA/invariance | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D062/2016 | Ana Lucía Córdova Cazar — [Wellbeing and Data Quality in the American Time Use Survey (ATUS) from a Total Survey Error Perspective](https://digitalcommons.unl.edu/sramdiss/10/) | CFA | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D063/2016 | Alyssa Lundahl — [Tired, Hungry, and Grumpy: Understanding the Direct and Indirect Relationships among Child Temperament, Sleep Problems, Feeding Styles, and Weight Outcomes](https://digitalcommons.unl.edu/psychdiss/83/) | CFA | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D064/2009 | Bergman, Robert D — [Testing the measurement invariance of the Likert and graphic rating scales under two conditions of scale numeric presentation](https://digitalcommons.unl.edu/dissertations/AAI3360158/) | measurement_invariance | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D065/2012 | Leslie H. Shaw — [Incorporating Latent Variable Outcomes in Value-Added Assessment: An Evaluation of Univariate and Multivariate Measurement Model Structures](https://digitalcommons.unl.edu/cehsdiss/162/) | latent_measurement/value_added | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D066/2014 | Kristin H. Javorsky — [Digital Print Concepts: Conceptualizing a Modern Framework for Measuring Emerging Knowledge](https://digitalcommons.unl.edu/teachlearnstudent/39/) | second_order_measurement | Located | Complete text screened |
| UNL-SEM-D067/2010 | Daniel H. Abbott — [CONSTRUCTING A CREATIVE SELF-EFFICACY INVENTORY: A MIXED METHODS INQUIRY](https://digitalcommons.unl.edu/cehsdiss/68/) | CFA | Located | Complete text screened |
| UNL-SEM-D068/2021 | Grace Sullivan — [Individual Differences in Social Responsiveness, Social Experiences, and Oxytocin System Genetic Variation in Depression Symptom Severity](https://digitalcommons.unl.edu/psychdiss/119/) | latent_measurement | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D069/2012 | Kuan-Yuan Wang — [Aging and Religious Participation in Late Life](https://digitalcommons.unl.edu/cehsdiss/160/) | latent_growth | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D070/2009 | Ashley, Gregory Charles — [Self-awareness: What is it and what does it predict?](https://digitalcommons.unl.edu/dissertations/AAI3359349/) | CFA | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D071/2018 | Moen, Amanda L — [Evaluation of the Psychometric Properties of the Teacher Efficacy for Promoting Partnership Measure](https://digitalcommons.unl.edu/dissertations/AAI10826065/) | CFA | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D072/2009 | Twila Wingrove — [A Comparison of Two Theoretical Models of Procedural Justice in the Context of Child Protection Proceedings](https://digitalcommons.unl.edu/psychdiss/8/) | CFA | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D073/2003 | Goertzen, Brent J — [Role of managers' and direct reports' ethic of virtue on leader -member exchanges](https://digitalcommons.unl.edu/dissertations/AAI3102566/) | CFA | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D074/2007 | Clarke, Brandy L — [Parental self-efficacy: Examination of a protective factor for parents of low -income with young children](https://digitalcommons.unl.edu/dissertations/AAI3283928/) | CFA | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D075/2013 | Xiaoyun Zhang — [STRESS, COPING, AND DEPRESSION IN ADOLESCENTS： A LONGITUDINAL ANALYSIS OF DATA FROM NATIONAL LONGITUDINAL STUDY OF ADOLESCENT HEALTH](https://digitalcommons.unl.edu/cehsdiss/185/) | latent_growth | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D076/2007 | Johnson, Katherine A — [Gender differences in the acquisition of self-control over time](https://digitalcommons.unl.edu/dissertations/AAI3284308/) | latent_growth | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D077/2018 | Lanyan Ding — [Depression among Chinese LBC: Understanding Depression in context of a family-oriented culture](https://digitalcommons.unl.edu/cehsdiss/323/) | latent_growth | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D078/2013 | Emily R. Griese — [Peer Victimization and Prosocial Behavior Trajectories: Exploring a Potential Source of Resilience for Victims](https://digitalcommons.unl.edu/cehsdiss/178/) | latent_growth_mixture | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D079/2007 | Tanya I. Razzhavaikina — [MANDATORY COUNSELING: A MIXED METHODS STUDY OF FACTORS THAT CONTRIBUTE TO THE DEVELOPMENT OF THE WORKING ALLIANCE](https://digitalcommons.unl.edu/cehsdiss/10/) | latent_growth | Located | Complete text screened |
| UNL-SEM-D080/2013 | Kutaka, Traci — [Young children's beliefs about the self as a learner and producer of mathematics: A mixed methods study](https://digitalcommons.unl.edu/dissertations/AAI3558618/) | measurement_invariance | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D081/2018 | Markeya S. Peteranetz — [The Influence of Context on Metacognition and Its Measurement](https://digitalcommons.unl.edu/cehsdiss/303/) | bifactor | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D082/2018 | Jarrett, Tara A — [Risk Factors, Self-compassion, and Burnout in Medical Students: Examining Relationships Through Path Analysis](https://digitalcommons.unl.edu/dissertations/AAI10842490/) | path_analysis | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D083/2012 | Jones, Kathleen — [The relationship of nature experiences in childhood and young adulthood to psychosocial well-being](https://digitalcommons.unl.edu/dissertations/AAI3546322/) | path_analysis | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D084/2014 | Bejerano, Arleen R — [An examination of the role of social support, coping strategies, and individual characteristics in students' adaptation to college](https://digitalcommons.unl.edu/dissertations/AAI3618647/) | path_analysis | Located | Complete text screened |
| UNL-SEM-D085/2004 | Stimpson, Jim — [Disaster, well -being, and sense of control: Testing a reciprocal path in the stress process model](https://digitalcommons.unl.edu/dissertations/AAI3126968/) | path_analysis | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D086/2010 | Griffith, Jakari N — [The influence of pre-training positive Psychological Capital development on training motivation](https://digitalcommons.unl.edu/dissertations/AAI3412917/) | path_analysis | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D087/2009 | Krush, Michael T — [The dispersion of marketing capabilities and its effects on marketing strategy execution, business relationships and business unit performance](https://digitalcommons.unl.edu/dissertations/AAI3365712/) | path_model | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D088/2011 | Marincic, Jamie Lynn — [Vague quantifiers of behavioral frequency: An investigation of the nature and consequences of differences in interpretation](https://digitalcommons.unl.edu/dissertations/AAI3481268/) | factor_mixture | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D089/2018 | Stacy Tiemeyer — [Examining Retrospective Measurement of Ambivalence About First Births and Psychological Well-being Using a Hybrid Cross-survey Multiple Imputation Approach](https://digitalcommons.unl.edu/sociologydiss/52/) | adjacent_latent_class | Located | Complete text screened |
| UNL-SEM-D090/2023 | Akemi E. Mii — [Adverse Childhood Experiences among Adolescent Girls in Residential Treatment: Relationship with Trauma Symptoms, Substance Use, and Delinquency](https://digitalcommons.unl.edu/psychdiss/129/) | adjacent_latent_class | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D091/2002 | Roos, Linda Lee — [Testing the robustness of item response theory equating to violation of the condition of equivalent item difficulty parameters in both the extant pool and infused items: A comparison of the effects on true -score and observed -score equating](https://digitalcommons.unl.edu/dissertations/AAI3041360/) | adjacent_IRT | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D092/2005 | Ferdous, Abdullah A — [Item Response Theory-based approaches for computing cut scores from an Angoff -based standard setting study](https://digitalcommons.unl.edu/dissertations/AAI3167457/) | adjacent_IRT | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D093/2021 | Haddadi, Ahmed Humood — [To D or Not to D: Some Methodological and Estimation Perspectives on the D-Scoring Method of Measurement](https://digitalcommons.unl.edu/dissertations/AAI28712747/) | adjacent_IRT_DSM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D094/2018 | Arthur, Ann M — [Enhancing Ability Estimation with Test-taking Strategies](https://digitalcommons.unl.edu/dissertations/AAI10845741/) | adjacent_IRT | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D095/2021 | Ji Guo — [Explore Student Engagement in the Learning Management System: A Learning Analytics Approach](https://digitalcommons.unl.edu/dissertations/AAI28865621/) | PLS_SEM | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D096/2016 | Claire T. Hauser — [Shame and Resilience Among Mental Health Trainees: A Scale Construction Study](https://digitalcommons.unl.edu/cehsdiss/267/) | adjacent_exploratory_factor_or_scale_structure | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D097/2001 | Carlson, Deborah Jean — [Development and validation of a college resilience questionnaire](https://digitalcommons.unl.edu/dissertations/AAI3016308/) | adjacent_exploratory_factor_or_scale_structure | Not located | Retrieval incomplete; unassessed |
| UNL-SEM-D098/2016 | Jonathon David Sikorski — [Examination of the NU Data Knowledge Scale](https://digitalcommons.unl.edu/cehsdiss/265/) | adjacent_exploratory_factor_or_scale_structure | Located | Retrieval incomplete; unassessed |
| UNL-SEM-D099/2022 | Kozikowski Yancey, Chelsea Bethany — [Examining Links between Multidimensional Stress and Health Outcomes in a Pediatric Sample from Low-Income Families](https://digitalcommons.unl.edu/dissertations/AAI29322439/) | adjacent_proposed_CFA_and_exploratory_scale_analysis | Not located | Retrieval incomplete; unassessed |

## Inventory integration and verification

Across both seed passes the shared inventory grows 363→373 entries, while precise eligible targets stay 150 and complete Lean targets stay 6. Source-work records grow 135→176 and full-text source screens 122→146. Seven recovered dissertation question screens are separate from article/work screen counts and from the original 20 complete dissertation reviews.

Sources have versions, exact locators and hashes. F134's hash identifies a complete author-uploaded web transcription, not original PDF bytes. Copyrighted bodies remain in ignored storage. Current resolution, Lean discovery and implementation difficulty for the added directions remain unassessed; no mathematical result or priority claim is made.

Rebuild with `python3 scripts/build_unl_sem_report.py`, `python3 scripts/build_open_problem_report.py`, and `python3 scripts/build_current_difficulty_report.py`. Validate with `validate_unl_sem_seed.py`, `validate_open_problems.py`, `validate_current_difficulty.py`, `validate_literature.py`, `validate.py`, and `git diff --check`. The original first-pass audit is preserved in `FIRST-PASS.md`; current cohort requirements are in `screening.json` and `cfa-expansion.json`.
