# Question screen of seven fetched papers

Checked 2026-11-02. [Manifests and screen notes](fetch-ingest/) · [SEM source ledger](unl-sem/works.json) · [Canonical inventory](OPEN-PROBLEMS.md).

Each issue's note at `fetch-ingest/<issue>/SCREEN.md` copies the findings in this file. The move from `fetch-manifests/` does not add a finding.

This screen consumes the verified fetch manifests for issues 25, 26, 27, 28, 29, 30, and 63. Each file is outcome `verified`, completeness `complete_body`, and the extracted text is readable. Copyrighted PDFs are not committed. The repository ignores `*.pdf`, and full texts stay in ignored `local-extraction/` when a checkout has them. Another checkout reacquires a file from the stable id and checks the hash below. `text_characters` counts Unicode code points. `byte_length` is the PDF size in bytes.

| Issue | Record | Inspected file | SHA-256 | Pages | PDF bytes | Text characters | Question count |
|---|---|---|---|---:|---:|---:|---:|
| [#25](https://github.com/alectionary/vibe-math/issues/25) | F182 | UNL faculty copy of Le and Clarke, *Statistical Analysis and Data Mining* 13 (2020), 113–133. DOI [10.1002/sam.11450](https://doi.org/10.1002/sam.11450) | `255187936be0c14fa254ca59e50e121bea9dc3c943e77eff13ca8b665a608a3c` | 22 | 2883611 | 145119 | 1 |
| [#26](https://github.com/alectionary/vibe-math/issues/26) | F183 | Yang, Li, Fu, and Liu, *Briefings in Bioinformatics* 15(5), 814–822; advance access 29 August 2013. DOI [10.1093/bib/bbt061](https://doi.org/10.1093/bib/bbt061) | `480f4f39ee6f5efd396188213fcf1994e4b86dae5e45ead344eb4721f16fe284` | 9 | 246102 | 58373 | 0 |
| [#27](https://github.com/alectionary/vibe-math/issues/27) | F184 | HHS Public Access author manuscript, not the publisher version. DeWeese and Osborne, *Journal of the World Aquaculture Society* 52(5), 1009–1030, October 2021. DOI [10.1111/jwas.12782](https://doi.org/10.1111/jwas.12782). PMC8562568 | `48dd4be4d8f6bcb18a949754307023a5ee214cbb9c0192ea0e05942341026c8e` | 28 | 939379 | 148324 | 0 |
| [#28](https://github.com/alectionary/vibe-math/issues/28) | F185 | Fear et al., *BMC Systems Biology* (2015) 9:53. DOI [10.1186/s12918-015-0200-0](https://doi.org/10.1186/s12918-015-0200-0). PMC4558766 | `a48a816f33c0fd03c29644d7bc8b318300641a99a3f42524a9b7aabbdfa9c3c8` | 17 | 2317490 | 113183 | 0 |
| [#29](https://github.com/alectionary/vibe-math/issues/29) | F186 | Igolkina et al., *BMC Genomics* 21(Suppl 8):490 (2020). DOI [10.1186/s12864-020-06833-2](https://doi.org/10.1186/s12864-020-06833-2). PMC7385891 | `894f49317639aad6cbeadcd70bf7c69780821714f87c5bee8bc6218d045770f5` | 11 | 2154042 | 65553 | 0 |
| [#30](https://github.com/alectionary/vibe-math/issues/30) | F150 | Campbell et al., *Crop Science* 43 (2003), 1493–1505. DOI [10.2135/cropsci2003.1493](https://doi.org/10.2135/cropsci2003.1493). UNL agronomy faculty copy | `7e70f3b1916c0cff5cf79f118c2d5d33c57b63062d8705a9474da3c135e9de3a` | 13 | 165180 | 161095 | 0 |
| [#63](https://github.com/alectionary/vibe-math/issues/63) | F173 | Cunningham, *Journal of Combinatorial Theory, Series B* 36 (1984), 161–188. DOI [10.1016/0095-8956(84)90023-6](https://doi.org/10.1016/0095-8956(84)90023-6). Scan with a text layer | `d7ad1675aa9882a226ab0b9349beac0ab51f467deb57b900d4274b26e6360715` | 28 | 1759454 | 77611 | 1 |

Line numbers below are 1-based lines of `str.splitlines()` on the extracted text. A two-column page interleaves the columns, so a line range can contain the neighboring column. A form-feed is a line break in that count.

## F182 — In praise of partially interpretable predictors

Tri Le and Bertrand S. Clarke. The stored file is the UNL DigitalCommons faculty copy of the 2020 journal article, including the repository cover. Stable link: [10.1002/sam.11450](https://doi.org/10.1002/sam.11450).

The paper compares linear models, Priestley–Chao and Nadaraya–Watson smoothers, and stacking combinations on mean squared error. Theorems 3.1–3.3 give asymptotic MSE and IMSE comparisons for the linear and partially linear predictors. Section 4 computes examples, including a 100-point subset of the Nebraska wheat measurements in Campbell et al. (F150). Section 5 argues that a blended interpretable and uninterpretable predictor often has smaller MSE than either extreme, under caveats on complexity, model error, and sample size.

**Recorded direction.** [L-F182-stacking-mse-asymptotics](OPEN-PROBLEMS.md#l-f182-stacking-mse-asymptotics). In Section 3.2 the authors conjecture that Clause 1 of Theorem 3.3 can be combined with Clause 2 or Clause 3 to give asymptotic pointwise MSE forms for the (PC, LM) and (NW, LM) predictors. They do not write those forms, and they say the combination looks too complicated for a clean comparison. Extracted lines 890–908. This is a method direction until the expression and the hypotheses of those clauses are fixed. Present resolution and Lean discovery were not assessed.

The same paragraph says the nonlinearity of stacking seems to block existing results for (STK, PC), (STK, PC)−LM, and STK−(PC, LM). That is a limitation of the argument they use, not a second target. Section 5’s tradeoff between interpretability and MSE is the paper’s methodological stance, not a numbered conjecture.

## F183 — An efficient approach to large-scale genotype–phenotype association analyses

Runqing Yang, Hongwang Li, Lina Fu, and Yongxin Liu. Advance access 29 August 2013; *Briefings in Bioinformatics* 15(5), 814–822. [10.1093/bib/bbt061](https://doi.org/10.1093/bib/bbt061).

The paper defines a conditional phenotype of each trait given the others, estimates it by shrinkage, and then runs separate LASSO coordinate-descent association scans. The authors say the procedure matches a staged structural-equation solution and, in their simulations, matches joint mapping in estimation and detection power. The yeast eQTL analysis is an application. No numbered conjecture or unanswered mathematical statement is left in the discussion. The sentence that grouped LASSO “will potentially increase the power” describes the proposed method. Zhu’s remark that no attempt was made to locate multi-trait QTLs refers to earlier conditional-variance work, not to an open problem in this paper.

Question count 0.

## F184 — Understanding the metabolome and metagenome as extended phenotypes

Kelly J. DeWeese and Melisa G. Osborne. The stored file is the HHS Public Access author manuscript, “Published in final edited form as” *Journal of the World Aquaculture Society* 52(5), 1009–1030, October 2021. It is not the publisher PDF. The manuscript title ends “domestication and improvement.” The fetch request title said “selection.” The DOI, authors, and journal citation match, so the identity is the requested article. [10.1111/jwas.12782](https://doi.org/10.1111/jwas.12782).

This is a review of metabolomic and metagenomic tools for macroalgae aquaculture. It describes structural equation models and QTL mapping as existing tools, including Mi et al. (2010), and says those applications have not been run on the seaweed microbiome. The conclusions ask for further empirical study of host–microbe associations, breeding, and omics pipelines. Those are aquaculture and biology directions. No explicit mathematical conjecture is stated.

Question count 0.

## F185 — The wright stuff: reimagining path analysis reveals novel components of the sex determination hierarchy in Drosophila melanogaster

Justin M. Fear, Michelle N. Arbeitman, Matthew P. Salomon, Justin E. Dalton, John Tower, Sergey V. Nuzhdin, and Lauren M. McIntyre. *BMC Systems Biology* (2015) 9:53. [10.1186/s12918-015-0200-0](https://doi.org/10.1186/s12918-015-0200-0).

The paper fits structural equation models to expression in two *Drosophila* populations and reports an expanded sex-hierarchy network, including a *fru* to *Sxl* link found in both populations, 754 candidate genes, and enrichment for sex-biased splicing. A *dsx* null experiment is used as a check. The conclusions state those biological findings. “The question of how to validate the addition of genes” is discussed and answered in the paper by literature overlap and the mutant experiment. It is not left as a mathematical target.

Question count 0. Code and data locations are in the ledger below. They were not needed to screen the text.

## F186 — Multi-trait multi-locus SEM model discriminates SNPs of different effects

Anna A. Igolkina, Georgy Meshcheryakov, Maria V. Gretsova, Sergey V. Nuzhdin, and Maria G. Samsonova. *BMC Genomics* 21(Suppl 8):490 (2020). [10.1186/s12864-020-06833-2](https://doi.org/10.1186/s12864-020-06833-2).

The paper defines mtmlSEM, an extension of a LISREL model with SNP columns that are restricted to a single nonzero entry, and separates single-trait and pleiotropic effects. Parameters are estimated by maximum likelihood after polychoric or polyserial correlations, with Gibbs sampling when the parameter count is large. On 404 chickpea accessions and 16 traits the authors report about 230 associated SNPs, about 60 of them pleiotropic, and prediction accuracy comparable to the breeding-value figures they cite. The sentence that applicability in genomic-selection studies “requires further investigation” does not fix an estimand, a model class beyond the name, or a success guarantee. It stays an application request, not an inventory target.

Question count 0.

## F150 — Identification of QTLs and environmental interactions associated with agronomic traits on chromosome 3A of wheat

B. T. Campbell, P. S. Baenziger, K. S. Gill, K. M. Eskridge, H. Budak, M. Erayman, I. Dweikat, and Y. Yen. *Crop Science* 43, July–August 2003, 1493–1505. The stored file is the UNL agronomy faculty copy. [10.2135/cropsci2003.1493](https://doi.org/10.2135/cropsci2003.1493).

This record already existed with a null question count because the complete file had not been stored. The conclusions report QTL and QTL-by-environment results for 98 recombinant inbred chromosome lines evaluated in seven Nebraska environments from 1999 through 2001. They localize agronomic-trait QTLs to three regions of chromosome 3A and describe magnitude and crossover interactions. The authors say the conclusions apply to this population and these environments. No explicit mathematical conjecture is stated. The question count is now 0. The earlier phenotypic-correlation reading used in the correlated-residual notes was not re-measured in this screen.

## F173 — Testing membership in matroid polyhedra

William H. Cunningham. *Journal of Combinatorial Theory, Series B* 36 (1984), 161–188. The file is a scan with a text layer, not an OCR pass. [10.1016/0095-8956(84)90023-6](https://doi.org/10.1016/0095-8956(84)90023-6).

The paper gives a strongly polynomial combinatorial algorithm, Algorithm 4.1, for testing membership in the matroid polyhedron, using an independence oracle and a grand augmentation along a shortest dipath. Section 5 records linear descriptions of the blocking and anti-blocking polyhedra of common bases as Corollaries 5.4 and 5.5, and attributes the statements to consequences derived in other papers and conjectured by Fulkerson. Those corollaries are proved here. The sketch that begins “we conjecture that a grand augmentation might be constructed” is then defined formally, and the text later says “This proves the validity of the grand augmentation” (extracted line 678). Those passages are not open targets.

**Recorded target.** [L-F173-strongly-polynomial-sfm](OPEN-PROBLEMS.md#l-f173-strongly-polynomial-sfm). Section 6, printed page 182 (PDF page 22), states that it is an important open problem to find a strongly polynomial algorithm for submodular function minimization, or even a practical combinatorial method that runs in polynomial time. Extracted lines 973–976. The rendered page was compared with the text layer for that sentence. The wording matches, including “strongly polynomial” and “practical combinatorial method which runs in polynomial time.” The text layer drops the empty-set glyph in the next display, where the page shows \(f(A)=g(A)+x(A)-g(\emptyset)\). That display is not the open-problem statement. The paper then gives partial polymatroid and matroid-rank cases and says that no analog of the Section 4 refinement is known for the general polymatroid. The 1984 text leaves the general problem open. Whether a later paper solved it was not checked. Lean discovery was not assessed.

The source was read because the C16 width investigation named this membership algorithm. Nothing in this screen transfers Cunningham’s complexity bound to that repair, and this screen does not change the status of L-F91-c16-unrestricted-width.

## Code and supplementary material

| Place checked | UTC date | Result |
|---|---|---|
| F182, the article, for a named supplement or program | 2026-11-02 | No supplement and no deposited program. Section 4 names R `persp3d()` as the plotting function. |
| F182, publisher or author code host | 2026-11-02 | None named. Not opened as a code deposit. |
| F183, the article | 2026-11-02 | “Supplementary data are available online at http://bib.oxfordjournals.org/.” No code host is named. LASSO coordinate descent is the method, not a deposited program. |
| F183, current article page https://academic.oup.com/bib/article/15/5/814/2422308 | 2026-11-02 | HTTP 403. The supplement file was not obtained. |
| F184, the author manuscript | 2026-11-02 | No supplement file and no code deposit named. |
| F185, software-availability paragraph | 2026-11-02 | SAS PROC CALIS is the named SEM product. SEMNET is at https://github.com/McIntyre-Lab/semnet. Project scripts are at https://github.com/McIntyre-Lab/papers/tree/master/fear_sem_sd_2015. Both GitHub pages returned HTTP 200. Neither repository was cloned. |
| F185, GEO GSE67400 landing page | 2026-11-02 | HTTP 200. The RNA-seq archive was not downloaded. |
| F186, data-and-materials paragraph | 2026-11-02 | Scripts and data are named at https://github.com/iganna/mtmlSEM.git. That page returned HTTP 200. The repository was not cloned. The paper also names the `semopy` package. |
| F186, DOI landing https://doi.org/10.1186/s12864-020-06833-2 | 2026-11-02 | HTTP 200. The page says supplementary information accompanies the article. Those files were not downloaded. |
| F150, the article | 2026-11-02 | No supplement and no program named in the methods or conclusions. |
| F173, the article | 2026-11-02 | No supplement and no program. The algorithms are in the paper. |

No help issue was filed. The question screen does not depend on those uncloned repositories or on the Yang supplement.

## Closeout

**Question answered:** none. This block screened the seven texts and recorded two author-stated directions. It did not prove either one.

**Question still open:** L-F182-stacking-mse-asymptotics, whose asymptotic expressions are not written in Le and Clarke. L-F173-strongly-polynomial-sfm, as stated in Cunningham’s 1984 Section 6. Present-day resolution of both is unassessed. The other five papers have no additional explicit mathematical target in this screen.

**Next proposed target (follow-up):** A current-resolution check of L-F173-strongly-polynomial-sfm against later combinatorial algorithms for submodular function minimization, before any formalization. The 1984 label is not that check.
