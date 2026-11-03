# Source and software availability, 2026-11-03 UTC

The thesis PDF was obtained. Its text was read (122 pages), and the rendered pages that support the headline and Published entries were inspected. Reading the text and inspecting the rendered pages are separate records. The route log is `provenance/source-acquisition.json`. The PDF file is not stored in this repository.

| Place checked | Result |
|---|---|
| Sheffield/White Rose thesis record, https://etheses.whiterose.ac.uk/id/eprint/32300/ | HTTP 200. Bibliographic identity matches: 2022 Sheffield PhD, title *Hypergraph product codes: a bridge to scalable quantum computers*. CC BY-NC-ND 4.0 is listed for the thesis. |
| Direct thesis PDF, https://etheses.whiterose.ac.uk/id/eprint/32300/1/AOQ_thesis.pdf | HTTP 200. PDF 1.5, 3,501,858 bytes, 122 pages, sha256 `dfed564052ab4068274f22efcddabbe3dc8890b3b020209bc70be0196d0cfe3f`. An earlier direct download in this study returned HTTP 403; this retry succeeded. |
| Institutional repository alternatives | White Rose eTheses is the repository that holds the file. https://eprints.whiterose.ac.uk/id/eprint/32300/ returned HTTP 404. A ProQuest document view for the same numeric id redirected and did not return the thesis. |
| Author manuscript, https://arxiv.org/pdf/2204.10812 | HTTP 200 for `2204.10812v3.pdf`. That file is an author manuscript, not the 122-page thesis. |
| Embedded articles inside the thesis | Theorem statements, tables, and figures used for the Published column were read from the thesis PDF and checked against `sources/browser-extraction.txt`. |
| https://github.com/MikeVasmer/single_shot_3D_HGP | Obtained original MIT C++ source and pinned BP+OSD dependency, vendored without source changes. Contains toric sizes 2–13 and surface sizes 3–9; does not contain source surface L=11, random-code seeds, production grid, raw figure data, fit notebooks or an MWPM first-stage implementation. |
| Referenced https://github.com/quantumgizmos/bp_osd | Obtained pinned historical dependency `74f86d3ef00f04bbb90a043dfef52e92a091f4d3` through the original submodule. |
| Author-name searches on GitHub, GitLab, OSF and Zenodo | No verified primary-author account or matching additional thesis supplement found in returned results. Search coverage is incomplete. |
| Publisher supplementary tabs and an exhaustive author-account repository inventory | Not completed. No author was contacted and no acquisition issue was opened. |

Rendered pages inspected for the headline and Published entries: PDF pages 44, 52, 63, 67, 68, 69, 70, 71, 72, 85, 86, 94, 95, 96, 114 and 119. Pages 67–69 are the zero-based pages 66–68 named in the earlier note. Chapter 4 Figures 1–6 on pages 67–72 were part of that inspection. The geometric partitions, round-robin coloring, and injection circuits match their captions. Those drawings do not settle the phase convention.

Unrecovered original grids and inputs still prevent exact numerical comparisons. They do not make the source's reported conclusions false.
