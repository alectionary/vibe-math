# Code and supplementary-material ledger

Date of the search: 2026-11-02 (UTC).

| Place checked | UTC date | Result |
|---|---|---|
| Dissertation PDF, DigitalCommons landing `https://digitalcommons.unl.edu/cehsdiss/229/` and download `viewcontent.cgi?article=1231&context=cehsdiss` | 2026-11-02 | Landing HTML obtained. Direct curl of the PDF returned HTTP 403 with `cf-mitigated: challenge`. Headless Chrome received a Cloudflare interstitial. The Internet Archive snapshot `https://web.archive.org/web/20240725015242id_/https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1231&context=cehsdiss` returned the PDF. sha256 `b64a3c3fdeb43040875b88560b69d3b9b4f23c1a45b05f0834204e624a56eece`, 222 pages, title page matches Natalie A. Koziol, May 2015, adviser James A. Bovaird. |
| Dissertation text for a named supplement or program archive | 2026-11-02 | Appendix A prints part of the R generator. Page 76 names Mplus Version 7 for estimation. No URL, OSF project, or deposited syntax file is named. |
| Figshare record of the 2017 article, `10.6084/m9.figshare.4743673` | 2026-11-02 | One file, `hmbr_a_1292115_sm3492.docx`, md5 `12e1e163d79e59c824e55cb071b87e01`. It repeats simulation tables. It does not contain Mplus or R programs. |
| GitHub user search for Koziol and repository search for the dissertation | 2026-11-02 | User search returned no accounts. Repository search returned 0. A code search for the generator string `u0j.rv.scaled` was rate-limited and then returned no hits. |
| OSF API search | 2026-11-02 | `api.osf.io` returned not-found for the title query used. No project was opened. |
| Zenodo record search | 2026-11-02 | Queries for Koziol and multilevel weights did not return this dissertation. |
| Software named on the page that names it | 2026-11-02 | Mplus 7 (estimation) and R with MASS (generation). Neither the original Mplus input files nor the saved replicate files were obtained. |

The generator fragment in Appendix A was obtained. The estimation programs were not. A help issue was not opened: the GitHub client available in this run is read-only.
