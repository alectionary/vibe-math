# Beck (2023) person-fit Monte Carlo

Source: Mark F. Beck, *The Examination of Nonparametric Person-Fit Statistics as Appropriate Measures of Response Bias in Ordered Polytomous Items* (Ph.D. dissertation, University of Nebraska–Lincoln, May 2023). https://digitalcommons.unl.edu/cehsdiss/425

PDF sha256 `86c3bb482efadc385cd52f7ea12dc33c50b9b70b4ce6111aedb075a12968f62b`, 280 pages, from the Wayback snapshot `20240907085051` of `viewcontent.cgi?article=1436&context=cehsdiss`. The PDF is not in git.

## Code and supplementary-material ledger

| Place checked | UTC date | Result |
|---|---|---|
| Landing page `https://digitalcommons.unl.edu/cehsdiss/425` | 2026-10-28 | HTML obtained. The citation PDF URL is `https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1436&context=cehsdiss`. |
| That viewcontent URL, curl | 2026-10-28 | Cloudflare challenge HTML, 5,856 bytes. Not a PDF. |
| Same URL, headless Chrome | 2026-10-28 | Cloudflare verification page. No PDF. |
| Wayback availability API | 2026-10-28 | Snapshot `20240907085051` available. |
| Wayback `id_` download of that snapshot | 2026-10-28 | PDF obtained. Hash above. |
| Dissertation text, search for a named script, OSF project, GitHub repository, or Zenodo deposit | 2026-10-28 | No sentence names a deposit. Beck (2015) is cited as the source of the factor structure and of the `ltm` ranges behind Tables A2 and A3. |
| GitHub user `MFBeck`, both public repositories cloned (`Hello_Jenkins`, `jenkins_test`) | 2026-10-28 | Jenkins demonstrations. No simulation code. |
| OSF API search for the dissertation | 2026-10-28 | No matching records. |
| Zenodo API search for this dissertation title | 2026-10-28 | No matching record. The unfiltered query returns unrelated works. |
| GitLab API search `person-fit Beck` | 2026-10-28 | Empty project list. |
| Beck (2015), master's thesis, ProQuest 1588285 | 2026-10-28 | Not retrieved. |

## What the dissertation does not contain

The magnitude of ε in Equation 26. The seven-option boundary uniforms. The realized boundary draws, item samples, and random seed. The careless-item fraction. Package versions. Which tail of U3 and of the normed Guttman errors the 5th percentile is applied to.

The prose on page 61 says the latent means range from −0.001 to 0.092. Table A1 prints 0, 0.02, 0.03, and 0.09. The prose on page 66 says the socially desirable means are one standard deviation below the base means. Those four printed values, −0.982, −0.964, −0.903, and −0.868, are the operational means. Subtracting each Table A1 standard deviation from the Table A1 mean does not recover them.
