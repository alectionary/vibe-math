# Dated source, code, and supplementary-material ledger

**Scope:** bounded availability audit on 2026-10-29 UTC for Daniel H. Abbott's May 2010 UNL dissertation. This records what was actually inspected or queried, not proof of global absence. **Result:** full dissertation and embedded Mplus analysis syntax obtained; original respondent-level data, full preprocessing code, complete simulation input, and interview corpus were not obtained. It would be incorrect to describe this as “no original code exists.”

| Place checked | UTC date | Exact route/query or local evidence | Result and limit |
|---|---|---|---|
| Official open dissertation record | 2026-10-29 | <https://digitalcommons.unl.edu/cehsdiss/68/>; opened with web reader | Title, author, May2010 date, abstract, and Download link present; no separate data/supplement link in returned page. |
| Official legacy catalog record | 2026-10-29 | <https://digitalcommons.unl.edu/dissertations/AAI3402936/>; opened with web reader | Same title/author/abstract, campus-access/ILL guidance and Download link; no separate data/supplement link in returned page. This route's campus guidance does not negate the obtained open full text. |
| Full official PDF supplied to this workspace by parent | 2026-10-29 | <https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1067&context=cehsdiss>; `/tmp/abbott-unl.pdf` | Obtained. SHA256 `a3c381d6f6295e917806834364b7f55fc35684b3db53174a53c3564feab4d70a`; 7,626,437 bytes; 283pages. This subtask verified local file/document rather than downloading a second copy. |
| Table3.2 | 2026-10-29 | Printed pp94-95 / PDF108-109 | Rounded correlation matrix, means, SDs, n296 obtained. Not respondent-level data or exact FIML sufficient statistics. |
| AppendixJ | 2026-10-29 | Printed pp253-261 / PDF267-275 | Original model input syntax and Mplus5.2 headers obtained. Input names local `CohortsTwo.dat`; file itself not embedded or linked. Multiple command titles mention `COMMANDMPLUS.PL`; generator source not embedded. |
| AppendixI and methods promise | 2026-10-29 | Printed p96 and pp251-252 / PDF110,265-266 | Methods says Mplus power code appears here. Actual appendix supplies summary and selected output, n200,10,000replications,seed0. Full generating/analysis syntax and complete residual variances not supplied in the two pages. |
| Questionnaire/protocol/coding sheets | 2026-10-29 | AppendixD pp240-243; AppendixE244-245; AppendixL269 | Questionnaire and interview protocol obtained. Final PDF page visually inspected: two photographed coding sheets on one page; no complete interview transcripts. Published participant excerpts elsewhere are not a complete corpus. |
| Data collection and retention descriptions | 2026-10-29 | pp91-92,117-121,246,248,268 | Google Docs CSV export, IM transcripts, private investigator storage and three-year retention described. No deposit link or promise of public raw-data access located. No conclusion about current retention or lawful release is drawn. |
| Named software in the source | 2026-10-29 | pp92,96-99,113,117-121; AppendixJ; references | Mplus5.2, R(2009citation), SAS(2008citation), car/MASS/GPArotation/pvclust, Google Docs and IM tools identified. Versions of R/SAS/packages not pinned by the source passages. Named public software is not author analysis code. |
| Full-text search for code/data routes | 2026-10-29 | Local `grep -niE 'github\|zenodo\|osf\|supplement\|data.*availab\|available.*data\|program\|software\|version\|CohortsTwo\|http' sources/dissertation.txt` and relevant context read | No named public original-study repository or raw dataset deposit found. Bibliography links include general software/procedures, not `CohortsTwo.dat`. |
| Indexed OSF discovery | 2026-10-29 | Web search `"Abbott" "creative self-efficacy"`, domains=`osf.io` | Empty search results in this bounded query. No specific OSF project identified. Not a direct authenticated OSF search and not exhaustive coverage. |
| Indexed Zenodo discovery | 2026-10-29 | Web search `"Abbott" "creative self-efficacy"`, domains=`zenodo.org` | Empty search results in this bounded query. No original-study deposition identified. Not a direct authenticated Zenodo search and not exhaustive coverage. |
| Indexed GitLab discovery | 2026-10-29 | Web search `"Abbott" "creative self-efficacy"`, domains=`gitlab.com` | Empty search results in this bounded query. No author project identified. Not direct authenticated GitLab coverage. |
| Indexed GitHub/author discovery | 2026-10-29 | Web searches `"Daniel H. Abbott" github`; `"Daniel Abbott" "Nebraska" "GitHub"`; `"creative self efficacy" "Abbott"` restricted to github.com/gitlab.com | No verified author-owned account or original-study repository surfaced. Broad queries also returned unrelated people/content; those were not treated as the author. |
| GitHub file search | 2026-10-29 | Connected GitHub `search(query="CohortsTwo.dat", topn=10)` | Empty result list. Default-branch/indexed code search only. |
| GitHub file search | 2026-10-29 | Connected GitHub `search(query="CTFLUE CPFIEL", topn=10)` | Empty result list. Default-branch/indexed code search only. |
| GitHub title search | 2026-10-29 | Connected GitHub `search(query="Constructing a creative self-efficacy inventory", topn=10)` | Ten returned excerpts were broad token matches unrelated to this dataset, not a verified title match. Search was capped and query was not exact-phrase matching; cannot infer global absence. |
| GitHub positive control | 2026-10-29 | Connected GitHub `search(query="replication-paper", repository_name="alectionary/vibe-math", topn=5)` | Found known skill and references, including immutable revision055e3308bf142c9b1e7ab300298712f09acf61d1. Establishes that connector search returned a known-positive file, not completeness of negative global searches. |
| Broader filename/title discovery | 2026-10-29 | Web queries `"CohortsTwo.dat"`, `"CohortsTwo.dat" "Abbott"`, `"CohortsTwo"`, `"Constructing a creative self-efficacy inventory" data code supplement` | Official dissertation and downstream citations surfaced; no original respondent file identified. CohortsTwo query also produced unrelated joined words; discarded. |
| Every repository on an author-owned GitHub account | 2026-10-29 | Not run | **Unperformed skill step:** author account not verified. No repositories were cloned. A bounded indexed search must not be presented as fulfilling this requirement. |
| Direct authenticated OSF/GitLab/Zenodo inventory | 2026-10-29 | Not run | **Coverage limit:** only indexed web discovery performed; no identified project to inspect directly. |
| Author contact / access request | 2026-10-29 | Not run | Outside this task's authorization. No email, message, issue, PR, or public allegation made. |

## What would resolve the availability gap?

A verified author/archive deposit or an appropriately authorized, de-identified original `CohortsTwo.dat`, accompanying variable dictionary and preprocessing code, and original Mplus outputs would allow the individual-level FIML/MLR rerun. Full AppendixI input would allow the original power simulation to be replayed. The qualitative component would require a lawful, shareable full transcript corpus and coding record. Consent and retention restrictions must be respected; no promise that these records still exist is made.

## Reproduce the local source checks

```sh
sha256sum /tmp/abbott-unl.pdf
pdfinfo /tmp/abbott-unl.pdf
pdftotext -layout /tmp/abbott-unl.pdf sources/dissertation.txt
grep -niE 'github|zenodo|osf|supplement|data.*availab|available.*data|program|software|version|CohortsTwo|http' sources/dissertation.txt
pdftoppm -f 283 -l 283 -png -r 150 -singlefile /tmp/abbott-unl.pdf outputs/appendix_l
```

Commands run from the replication directory. Browser/search results are time-dependent and may differ when rerun. The date and bounded method above, rather than an unavailable claim, are the record.
