# Structural equation modeling: UNL dissertation seed and downstream work

Checked October 26, 2026. [Tracking issue](https://github.com/alectionary/vibe-math/issues/5) · [Dissertation CSV](dissertations.csv) · [Author search outcomes](authors.json) · [Formalization suitability](FORMALIZATION.md) · [Shared question index](../OPEN-PROBLEMS.md).

This pass adds **58 doctoral-dissertation metadata records** and searches subsequent publications for every seed author. It verifies **26 selected article/letter records linked to 18 authors**, screens **14 readable article full texts**, and adds **8 source-stated statistical method directions** to the shared inventory. Two pairs of repeated QTL directions are merged. These eight need a precise model and success guarantee before becoming theorem targets; the eligible-target count remains **150**, and no new proof is claimed.

The dissertation registry is a discovery seed, not 58 completed full-text reviews. All dissertation question counts remain **unassessed (null)**. Public archive landing pages were readable through indexed web results, but native access to all 18 original public-copy routes returned HTTP403, as did two actual download links tested through the web tool. The remaining 40 original records link to the ProQuest catalog. A further public-copy record for Evertson was discovered during this pass, bringing located public-copy records to **19**; a public record does not establish successful PDF retrieval. [UNL explains its access arrangements here](https://digitalcommons.unl.edu/dissertations/).

## Scope and counts

| Measure | Result |
| --- | ---: |
| Dissertations dated 2001 onward identified in the original survey | 58 |
| Original seed overlaps with the existing 20-dissertation review catalog | 0 |
| Seed authors with recorded downstream searches | 58 |
| Authors linked to selected verified publication records | 18 |
| Selected article/letter records | 26 |
| Post-dissertation publication records | 25 |
| Same-year publication with ordering unverified | 1 |
| Readable article full texts screened | 14 |
| Selected articles with incomplete full-text access | 12 |
| Dissertation full texts screened | 0 |
| Added statistical method directions | 8 |
| Added precise conjectures / completed proofs | 0 / 0 |

The original survey searched dates from 2001 onward; its located dissertations span 2003–2025. Missing years are not asserted to have zero qualifying dissertations. The original seed has 10 methods-oriented and 48 applied dissertations. This pass records 130 additional discovery/copy/verification queries, including one author/topic query for each seed. Author/coauthor links rely on primary article metadata, topical continuity and affiliations/coauthors; matching names alone is insufficient. Bibliographic leads outside the 26 selected verified works remain in the discovery log, without author attribution or question counts.

This is a bounded first-hop search, not a census of every coauthor's career or a recursive citation crawl. [Queries/results](searches.json), [all discovery result dispositions](discovery-results.json), [retrieval evidence](extra-retrieval-attempts.json), and [service access](service-access.json) preserve its actual coverage. Earlier work recovered during searches is not relabeled post-dissertation progress.

## Mathematical suitability

The included directions concern QTL model discrimination, missing observations, mixed outcomes, residual covariance, nonlinear models, experimental design effects, and dynamic fit-index calibration. Their statements can ultimately involve distributions, estimators, matrices and algorithmic guarantees. They are not claims that any proposed method universally improves power.

The screen excludes intervention effects, attitudes, leadership/satisfaction associations, instrument replication in new populations, clinical effects, stakeholder theories, and ecological observations when answering them requires new data. An SEM equation in a paper does not turn every research question in that paper into a mathematical conjecture. The [suitability worksheet](FORMALIZATION.md) gives the missing assumptions for each retained direction and separates three project-derived formalization starting points from author-posed research questions.

## Downstream results that change interpretation

Peugh and Feldon's 2020 fit-assessment article called for wider testing of equivalence testing. Their own 2024 letter reports unfavorable subsequent simulations and withdraws the recommendation. The 2020 study request is therefore historical context; the separate 2024 dynamic-fit questions are indexed. This is a published methodological correction, not a universal mathematical disproof.

Mi and coauthors' 2011 gene–environment SEM paper is related later development of an agenda discussed in the 2010 QTL papers. Its inspected abstract does not establish complete equivalence to the earlier QTL-mapping/model-design directions. Kmail–Eskridge's 2022 D-optimal design paper and Jeffries–Bovaird's 2026 latent-contrast paper are verified follow-on records; their full-text question screens remain access-limited.

## Newly recorded method directions

### L-F103-pleiotropy-linked

Develop a Bayes-factor test distinguishing pleiotropic QTL effects from closely linked QTL.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072) — Section6 Discussion and conclusion, future-work paragraph.

Statement gate: Specify the competing latent-genotype models, priors, marginal likelihoods, and identifiability/separation assumptions.

### L-F103-missing-phenotypes

Extend the Bayesian multi-trait SEM procedure to missing phenotypic observations.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072) — Section6 Discussion and conclusion.

Statement gate: Specify missingness, imputation distribution, estimator, and a consistency or error guarantee; imputation itself is not a proof of validity.

### L-F103-mixed-outcomes

Develop multi-trait SEM methods supporting mixed binary and continuous traits.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072) — Section6 Discussion and conclusion, final methodological paragraph, [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf) — Discussion, PDF viewer p21 (printed p19).

Statement gate: Fix latent/observed links and a joint probability model; choose an identifiable parameterization and a specific inferential guarantee.

### L-F103-experimental-design

Extend multi-trait QTL SEM to include environments, blocks and gene–environment interactions.

Source: [F103](https://www.cambridge.org/core/journals/genetics-research/article/bayesian-mixture-structural-equation-modelling-in-multipletrait-qtl-mapping/0F0C5E2E9FF8E6E2A1BFE0A4FF11C072) — Section6 Discussion and conclusion, final paragraph, [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf) — Discussion, PDF viewer pp20–21.

Statement gate: Fix random-effect covariance and interaction structure before stating identifiability or estimator guarantees.

### L-F102-correlated-residuals

Extend the multi-trait QTL SEM analysis to correlated residual errors.

Source: [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf) — Discussion, PDF viewer p20 (printed p18).

Statement gate: Specify a positive-definite residual covariance class and structural zero restrictions; unrestricted residual dependence can change identifiability.

### L-F102-nonlinear-traits

Extend the linear multi-trait QTL SEM to nonlinear trait relationships.

Source: [F102](https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf) — Discussion, PDF viewer p20 (printed p18).

Statement gate: Specify the nonlinear family, noise assumptions, and the particular existence, identifiability or estimation claim; the source gives an allometric example, not a general theorem.

### L-F106-dynamic-fit-robustness

Determine how direct-discrepancy dynamic fit indices perform across SEM types, sample sizes, distributions and missingness.

Source: [F106](https://pmc.ncbi.nlm.nih.gov/articles/PMC11659859/) — Letter, final paragraph before References.

Statement gate: Define a family of SEMs, null/alternative discrepancy thresholds, simulation calibration, and a finite-sample error/coverage criterion.

### L-F106-dynamic-fit-multilevel

Develop direct-discrepancy dynamic fit index procedures for multiple-group or multilevel analyses.

Source: [F106](https://pmc.ncbi.nlm.nih.gov/articles/PMC11659859/) — Letter, final paragraph before References.

Statement gate: The authors identify unavailable multiple-group/multilevel support. Specify model class and a level/power guarantee before proposing a theorem.

## Every selected downstream work and its screen outcome

| ID / year | Work | Seed authors | Full-text question outcome |
| --- | --- | --- | --- |
| F102 / 2010 | [Regression-Based Multi-Trait QTL Mapping Using a Structural Equation Model](https://doi.org/10.2202/1544-6115.1552) | Mi, Xiaojuan | 4 recorded directions |
| F103 / 2010 | [Bayesian mixture structural equation modelling in multiple-trait QTL mapping](https://doi.org/10.1017/S0016672310000236) | Mi, Xiaojuan | 4 recorded directions |
| F104 / 2013 | [Analyzing Mixed-Dyadic Data Using Structural Equation Models](https://doi.org/10.1080/10705511.2013.769395) | Peugh, James L | No additional suitable explicit mathematical target recorded |
| F105 / 2020 | [“How Well Does Your Structural Equation Model Fit Your Data?”: Is Marcoulides and Yuan’s Equivalence Test the Answer?](https://doi.org/10.1187/cbe.20-01-0016) | Peugh, James L | No additional suitable explicit mathematical target recorded |
| F106 / 2024 | [The Answer is “No”: A Comment on Peugh and Feldon (2020)](https://doi.org/10.1187/cbe.24-07-0182) | Peugh, James L | 2 recorded directions |
| F107 / 2021 | [Incorporating Molecular Markers and Causal Structure among Traits Using a Smith-Hazel Index and Structural Equation Models](https://doi.org/10.3390/agronomy11101953) | Hidalgo-Contreras, Juan Valente | No additional suitable explicit mathematical target recorded |
| F108 / 2017 | [Developmental etiologies of alcohol use and their relations to parent and peer influences over adolescence and young adulthood: A genetically informed approach](https://doi.org/10.1111/acer.13506) | Deutsch, Arielle R | No additional suitable explicit mathematical target recorded |
| F109 / 2018 | [Future orientation in adolescent and young adult cancer survivors and unaffected peers](https://doi.org/10.1002/pon.4588) | Sarah J. Beal | No additional suitable explicit mathematical target recorded |
| F110 / 2024 | [Participatory modeling for high complexity, multi-system issues: challenges and recommendations for balancing qualitative understanding and quantitative questions](https://doi.org/10.1002/sdr.1765) | Deutsch, Arielle R | No additional suitable explicit mathematical target recorded |
| F111 / 2022 | [Comprehensive Sexuality Education Improves Primary Students’ Explicit and Implicit Attitudes Toward Homosexuality](https://doi.org/10.1080/19317611.2022.2067282) | Liu, Wenli | No additional suitable explicit mathematical target recorded |
| F112 / 2019 | [Selection and socialization influences on adolescent alcohol use: The individual and joint contexts of neighborhood disadvantage and population density](https://doi.org/10.1080/10826084.2019.1608247) | Deutsch, Arielle R | No additional suitable explicit mathematical target recorded |
| F113 / 2022 | [Developing and validating a comprehensive measure of coordination in patient aligned care teams](https://doi.org/10.1186/s12913-022-08590-2) | Lester, Houston F | No additional suitable explicit mathematical target recorded |
| F114 / 2024 | [Teacher Leadership, Wellbeing, and Intent to Leave in US Rural Schools: Evidence from the 2020–21 National Teacher and Principal Survey](https://doi.org/10.3390/educsci14070758) | Engle, Jordan C | No additional suitable explicit mathematical target recorded |
| F115 / 2022 | [D-Optimal Design for a Causal Structure for Completely Randomized and Random Blocked Experiments](https://doi.org/10.1155/2022/7299086) | Kmail, Zaher M | Unassessed: full-text access gap |
| F116 / 2023 | [Equivalence testing to judge model fit: A Monte Carlo simulation](https://doi.org/10.1037/met0000591) | Peugh, James L | Unassessed: full-text access gap |
| F117 / 2026 | [When Nesting is Nuisance in Cluster Sampled Longitudinal Research](https://doi.org/10.1080/00273171.2026.2720958) | Peugh, James L | Unassessed: full-text access gap |
| F118 / 2011 | [The Comparative Performance of Conditional Independence Indices](https://doi.org/10.1177/0146621611407909) | Kim, Doyoung | Unassessed: full-text access gap |
| F119 / 2026 | [Examining the accuracy of orthogonal latent mean comparisons in unbalanced conditions](https://doi.org/10.1177/01466216261452255) | Jeffries, Jay B. | Unassessed: full-text access gap |
| F120 / 2015 | [An ecological perspective on rural, low-income mothers' health](https://doi.org/10.1080/19371918.2014.969860) | Bice-Wigington, Tiffany | Unassessed: full-text access gap |
| F121 / 2018 | [Direct and Indirect Effects of Nebraska Motor Vehicle Drivers’ Characteristics on Inattentive Driving at Highway-Rail Grade Crossings](https://doi.org/10.1177/0361198118794067) | Zhao, Shanshan | Unassessed: full-text access gap |
| F122 / 2009 | [Communicative and Relational Dimensions of Shared Family Identity and Relational Intentions in Mother-in-Law/Daughter-in-Law Relationships: Developing a Conceptual Model for Mother-in-Law/Daughter-in-Law Research](https://doi.org/10.1080/10570310802636334) | Rittenour, Christine E | Unassessed: full-text access gap |
| F123 / 2022 | [Bridging the Gap: The Predictive Roles of Emotion Dysregulation and Stalking-related Attitudes on Offline and Online Stalking and Intrusive Harassment](https://doi.org/10.1177/08862605211043590) | Maria Rosa Viñas-Racionero | Unassessed: full-text access gap |
| F124 / 2010 | [Satisficing Among Reluctant Respondents in a Cross-National Context](https://academic.oup.com/poq/article/74/5/956/1816917) | Kaminska, Olena | Unassessed: full-text access gap |
| F125 / 2026 | [Like night and day: a review of nocturnal predator communities and predation in annual row crop agroecosystems](https://pmc.ncbi.nlm.nih.gov/articles/PMC13186587/) | Stowe, Hannah E. | No additional suitable explicit mathematical target recorded |
| F126 / 2007 | [Structural equation modelling for studying genotype × environment interactions of physiological traits affecting yield in wheat](https://doi.org/10.1017/S0021859607006806) | Dhungana, Prabhakar | Unassessed: full-text access gap |
| F127 / 2011 | [Structural Equation Modeling of Gene–Environment Interactions in Coronary Heart Disease](https://doi.org/10.1111/j.1469-1809.2010.00634.x) | Mi, Xiaojuan | Unassessed: full-text access gap |

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

## Dissertation seed

All rows below are archive metadata/abstract records; full-text question harvesting remains access-limited. The separate original 20 full dissertation reviews and their frozen audit denominator are preserved.

| Seed | Year | Author / dissertation | Located public-copy record |
| --- | --- | --- | --- |
| UNL-SEM-D001 | 2003 | Liu, Wenli — [Factors influencing parental involvement in sexuality education for adolescents in the People's Republic of China](https://digitalcommons.unl.edu/dissertations/AAI3098171/) | Not located in this search |
| UNL-SEM-D002 | 2004 | Park, Hyesung — [Factors that affect information technology adoption by teachers](https://digitalcommons.unl.edu/dissertations/AAI3126960/) | Not located in this search |
| UNL-SEM-D003 | 2004 | Dhungana, Prabhakar — [Structural equation modeling of genotype x environment interaction](https://digitalcommons.unl.edu/dissertations/AAI3152605/) | Not located in this search |
| UNL-SEM-D004 | 2006 | Peugh, James L — [Specification searches in multilevel structural equation modeling: A Monte Carlo investigation](https://digitalcommons.unl.edu/dissertations/AAI3229555/) | Not located in this search |
| UNL-SEM-D005 | 2007 | Kim, Doyoung — [Assessing the relative performance of local item dependence indexes](https://digitalcommons.unl.edu/dissertations/AAI3249671/) | Not located in this search |
| UNL-SEM-D006 | 2007 | Daubert, Sara Jo — [Exploring the relationship of motivation and environmental attitudes to Servant Leadership](https://digitalcommons.unl.edu/dissertations/AAI3293927/) | Not located in this search |
| UNL-SEM-D007 | 2007 | Lieske, Jody L — [Relational victimization and internalizing outcomes: Do self -referent attribution tendencies matter?](https://digitalcommons.unl.edu/dissertations/AAI3293921/) | Not located in this search |
| UNL-SEM-D008 | 2007 | Zolnikov, Bryan J — [The association among neuropsychological functioning, response styles, cognitive content, and the severity of depression in people diagnosed with end -stage liver disease evaluated for a liver transplant: A structural equation model](https://digitalcommons.unl.edu/dissertations/AAI3278160/) | Not located in this search |
| UNL-SEM-D009 | 2008 | Kim, Jongheon — [An integrative analysis of transactional e -government web usage: The trust -risk model and Technology Acceptance Model perspectives](https://digitalcommons.unl.edu/dissertations/AAI3338898/) | Not located in this search |
| UNL-SEM-D010 | 2008 | LeClair-Underberg, Cassandra — [Communicatively coping with miscarriage: The impact of emotional support and narrative coherence on women's individual and relational well -being](https://digitalcommons.unl.edu/dissertations/AAI3326863/) | Not located in this search |
| UNL-SEM-D011 | 2009 | Rittenour, Christine E — [Communication and shared family identity in mother-in-law/daughter-in-law relationships: Implications for relational outcomes and future family functioning](https://digitalcommons.unl.edu/dissertations/AAI3350455/) | Not located in this search |
| UNL-SEM-D012 | 2009 | Hammonds, Joshua R — [Establishing a model of Communication Privacy Management theory: Examining the criteria that predict an emerging adult's likelihood to reveal private information to their parents](https://digitalcommons.unl.edu/dissertations/AAI3379241/) | Not located in this search |
| UNL-SEM-D013 | 2009 | Mi, Xiaojuan — [Genetic applications using structural equation modeling](https://digitalcommons.unl.edu/dissertations/AAI3350451/) | Not located in this search |
| UNL-SEM-D014 | 2009 | Kaminska, Olena — [Satisficing among reluctant respondents in a cross -national context](https://digitalcommons.unl.edu/dissertations/AAI3366966/) | Not located in this search |
| UNL-SEM-D015 | 2009 | Bonin, Michel F — [Vulnerability factors low control and high negative affect in the development of social anxiety and the use of safety behaviors](https://digitalcommons.unl.edu/dissertations/AAI3358954/) | Not located in this search |
| UNL-SEM-D016 | 2011 | Hosek, Angela M — [Extending intergroup theorizing to the instructional context: Testing a model of teacher communication behaviors, credibility, group-based categorization, and instructional outcomes](https://digitalcommons.unl.edu/dissertations/AAI3466790/) | Not located in this search |
| UNL-SEM-D017 | 2011 | Sarah J. Beal — [The Development of Future Orientation: Underpinnings and Related Constructs](https://digitalcommons.unl.edu/psychdiss/32/) | Yes |
| UNL-SEM-D018 | 2011 | Lee, DonHee — [The impact of supply chain innovation on organizational performance: An empirical study in the health care organization](https://digitalcommons.unl.edu/businessdiss/17/) | Yes |
| UNL-SEM-D019 | 2011 | Bice-Wigington, Tiffany — [Understanding mesosystemic influences on reported health among rural low-income women: A structural equation analysis](https://digitalcommons.unl.edu/cehsdiss/97/) | Yes |
| UNL-SEM-D020 | 2012 | Deutsch, Arielle R — [A Test of a Conceptual Model of Sexual Self-Concept and its Relation to Other Dimensions of Sexuality](https://digitalcommons.unl.edu/psychdiss/48/) | Yes |
| UNL-SEM-D021 | 2013 | Olson, Mark E — [Making the Grade: Do Nebraska Teachers and Administrators Working in Public Schools in 7th–12th Grade Settings Agree About What Constitutes Sound Grading Practice?](https://digitalcommons.unl.edu/dissertations/AAI3565006/) | Not located in this search |
| UNL-SEM-D022 | 2013 | Chumney, Frances L — [Structural equation models with small samples: A comparative study of four approaches](https://digitalcommons.unl.edu/cehsdiss/189/) | Yes |
| UNL-SEM-D023 | 2013 | Lee, Dong Hyun — [The role of Triple-A in green supply chain management practices and organizational performance](https://digitalcommons.unl.edu/dissertations/AAI3558860/) | Not located in this search |
| UNL-SEM-D024 | 2014 | Hidalgo-Contreras, Juan Valente — [Incorporating causal structure among traits using a multitrait genomic selection index](https://digitalcommons.unl.edu/dissertations/AAI3636123/) | Not located in this search |
| UNL-SEM-D025 | 2014 | Sainath, Jyothsna — [Structural equation mixed models with an application to small area estimation](https://digitalcommons.unl.edu/dissertations/AAI3632751/) | Not located in this search |
| UNL-SEM-D026 | 2014 | Collins, Adam Marlin — [The social-ecology from child maltreatment to dating violence: The impact of bullying](https://digitalcommons.unl.edu/dissertations/AAI3630836/) | Not located in this search |
| UNL-SEM-D027 | 2015 | Tu, Xiaoqing — [A Longitudinal Examination of the Transactional Associations Among Child Emotion Regulation, Parenting Practices, and Family Contextual Factors Across the First Three Years](https://digitalcommons.unl.edu/dissertations/AAI3718723/) | Not located in this search |
| UNL-SEM-D028 | 2015 | Martinez, Leslie N — [Construction of an anti-Mexican American bias scale and its validation](https://digitalcommons.unl.edu/psychdiss/82/) | Yes |
| UNL-SEM-D029 | 2015 | Cao, Yichun — [Motivation of Chinese frontline employees in a foreign-funded manufacturing company: A mixed methods study](https://digitalcommons.unl.edu/dissertations/AAI3685475/) | Not located in this search |
| UNL-SEM-D030 | 2016 | Zhao, Shanshan — [An investigation of motor vehicle driver inattention and its effects at highway-rail grade crossings](https://digitalcommons.unl.edu/civilengdiss/96/) | Yes |
| UNL-SEM-D031 | 2016 | Katherine M. Kidwell — [Sleep, Executive Control, and Psychopathology in Children: A Longitudinal Study and an Examination of Brief Sleep Treatment](https://digitalcommons.unl.edu/psychdiss/89/) | Yes |
| UNL-SEM-D032 | 2016 | Hope, Meredith O — [The impact of peer victimization in high school on first-year undergraduates' psychosocial adjustment and academic performance](https://digitalcommons.unl.edu/dissertations/AAI10143736/) | Not located in this search |
| UNL-SEM-D033 | 2017 | Zulfiqar, Najia — [Bidirectional Longitudinal Associations Between Teacher-Child and Parent-Child Relationship Quality and Children's Academic Competence](https://digitalcommons.unl.edu/dissertations/AAI10272856/) | Not located in this search |
| UNL-SEM-D034 | 2017 | Lester, Houston F — [Informative Hypotheses as a Methodological Middle-Ground to Detect Interpretational Confounding in Formative Measurement Models](https://digitalcommons.unl.edu/dissertations/AAI10608702/) | Not located in this search |
| UNL-SEM-D035 | 2017 | Jolly, Sushma — [Undergraduate Online Courses: Teaching, Cognitive, and Social Presence](https://digitalcommons.unl.edu/dissertations/AAI10637881/) | Not located in this search |
| UNL-SEM-D036 | 2018 | Maria Rosa Viñas-Racionero — [A Multifactorial Model of Threat Assessment Activity Applied to Educational Settings](https://digitalcommons.unl.edu/psychdiss/108/) | Yes |
| UNL-SEM-D037 | 2018 | Sarah A. Taylor — [Exploring Adolescent Dating Violence in Rural Communities: A Mixed Methods Study](https://digitalcommons.unl.edu/cehsdiss/319/) | Yes |
| UNL-SEM-D038 | 2018 | Chapla, Brooke A — [Shared Perceptions of the Classroom Environment and the Impact of Teacher Efficacy](https://digitalcommons.unl.edu/dissertations/AAI10980873/) | Not located in this search |
| UNL-SEM-D039 | 2018 | Venkateswaran, Kavitha Dharmalingam — [Social Class, Asian American Stereotypes, and Perceptions of Shame: An Investigation Within Career Construction Theory](https://digitalcommons.unl.edu/dissertations/AAI10841259/) | Not located in this search |
| UNL-SEM-D040 | 2019 | Kmail, Zaher M — [Optimal Design for a Causal Structure](https://digitalcommons.unl.edu/statisticsdiss/21/) | Yes |
| UNL-SEM-D041 | 2019 | Emery, Alexandra Kristine Dahl — [The Protective Influence of Self-Compassion Against Internalized Racism Among African Americans](https://digitalcommons.unl.edu/dissertations/AAI27997710/) | Not located in this search |
| UNL-SEM-D042 | 2020 | Zajdel, Alyssa A — [Stigmatized Virginity and Masculinity: Exploring in Non-virgin Cisgender Heterosexual Men](https://digitalcommons.unl.edu/dissertations/AAI28025219/) | Not located in this search |
| UNL-SEM-D043 | 2020 | Christian, Bohdan M — [The Effects of School Leadership on Teachers’ Professional Practices on Teacher’s Classroom Practice: Evidence from TALIS 2013 US Data](https://digitalcommons.unl.edu/dissertations/AAI28001905/) | Not located in this search |
| UNL-SEM-D044 | 2020 | Evertson, David W — [The Influence of Principal Leadership on Teacher Collaboration: Does Effective Professional Development Mediate This Effect?](https://digitalcommons.unl.edu/dissertations/AAI27833241/) | Yes |
| UNL-SEM-D045 | 2020 | Cassidy, Kendal — [Well-Being in Trans and Gender Diverse Individuals: An Investigation of Chosen Family Support](https://digitalcommons.unl.edu/cehsdiss/364/) | Yes |
| UNL-SEM-D046 | 2021 | Abebe, Fitsum F — [Pre-Service Teachers’ Technological Pedagogical Content Knowledge(Tpack) Self-Efficacy and Development in K-6 Math](https://digitalcommons.unl.edu/dissertations/AAI28652898/) | Not located in this search |
| UNL-SEM-D047 | 2022 | Bell, Haley L — [Effects of Trans Discrimination on Mental Health through Social Support](https://digitalcommons.unl.edu/dissertations/AAI29162859/) | Not located in this search |
| UNL-SEM-D048 | 2022 | Kennedy, Joseph L. D — [Sexual Assault on College Campuses: Adapting and Updating Protective Behavioral Strategies](https://digitalcommons.unl.edu/dissertations/AAI29257178/) | Not located in this search |
| UNL-SEM-D049 | 2022 | Lukesh, Amanda R — [Teacher-Leader, Teacher-Teacher, and Teacher-Student Relationships: Which Makes a Difference in Teacher Self-Efficacy in US Middle Schools](https://digitalcommons.unl.edu/dissertations/AAI29168484/) | Not located in this search |
| UNL-SEM-D050 | 2022 | Roth, Taylor — [The Stress-Buffering Effect of Receiving Social Support on Resilience in Families of Children with Medical Complexity](https://digitalcommons.unl.edu/dissertations/AAI29167462/) | Not located in this search |
| UNL-SEM-D051 | 2023 | Engle, Jordan C — [Distributed Leadership and Its Effect on Rural Teacher Job Satisfaction and Intent to Leave or Move](https://digitalcommons.unl.edu/dissertations/AAI30575773/) | Not located in this search |
| UNL-SEM-D052 | 2023 | Collins, Elizabeth I — [How to Do QuantCrit: A Reflexive Account of Applying Critical Quantitative Methods to a Study of Black Women in STEM](https://digitalcommons.unl.edu/cehsedaddiss/351/) | Yes |
| UNL-SEM-D053 | 2023 | Dammann, Anna Johnson — [Moderators of the Associations Between Early Childhood Sleep Problems and Elementary School Developmental Outcomes](https://digitalcommons.unl.edu/dissertations/AAI30570301/) | Not located in this search |
| UNL-SEM-D054 | 2024 | McGonigal, Patrick T — [Identity-Driven Targeted Violence: Attending to Identity, Emotion, and Personality-Related Predictors of Attitudinal and Behavioral Prejudice](https://digitalcommons.unl.edu/dissunl/64/) | Yes |
| UNL-SEM-D055 | 2024 | Jeffries, Jay B. — [Navigating Non-Orthogonality: Exploring Latent Mean Differences in Unbalanced Conditions](https://digitalcommons.unl.edu/dissunl/216/) | Yes |
| UNL-SEM-D056 | 2024 | Karen M. Alexander Glueckert — [The Relationship Between General and Content-Specific Classroom Practices and K-6 Student Math Achievement: A Multi-Method Analysis](https://digitalcommons.unl.edu/dissunl/60/) | Yes |
| UNL-SEM-D057 | 2025 | Stowe, Hannah E. — [Landscape Effects on the Beneficial Arthropod Community in Agriculturally Dominated Environments](https://digitalcommons.unl.edu/dissunl/281/) | Yes |
| UNL-SEM-D058 | 2025 | Miramonti, Amelia Anne — [Youth Sport Participation and Cognitive Development: The Need for Improved Measurement](https://digitalcommons.unl.edu/dissunl/314/) | Yes |

## Inventory integration and reproducibility

The shared inventory grows **363→371 entries**, while precise eligible targets stay **150** and complete Lean targets stay **6**. The shared article/letter bibliography grows **135→161 records** and full-text screens **122→136**. The 58 dissertation metadata seeds are counted separately from article screens and from the earlier 20 complete dissertation reviews.

`works.json` supplies seed links, exact acquisition outcomes, source hashes and version/date notes. `screening.json` records exclusions and requirement evidence. Current-resolution checks and Lean proof discovery for the eight directions remain unassessed; no theorem or historical-priority claim is made. Sources are linked and copyrighted full texts remain in ignored local storage. HTML extraction line numbers belong to the saved copy; PDF viewer pages include publisher cover sheets.

Rebuild reports with `python3 scripts/build_unl_sem_report.py`, `python3 scripts/build_open_problem_report.py`, and `python3 scripts/build_current_difficulty_report.py`. Validate with `python3 scripts/validate_unl_sem_seed.py`, `python3 scripts/validate_open_problems.py`, `python3 scripts/validate_current_difficulty.py`, and `python3 scripts/validate_literature.py`. The new validation checks seed coverage, source/target links, null-versus-zero distinctions, hashes when local copies exist, and the exact cohort delta.

No new social theory was added to the mathematical inventory. No author-stated empirical question was relabeled a conjecture. The three proposed implementation starting points in `FORMALIZATION.md` remain outside the canonical question count.
