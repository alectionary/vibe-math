# Source evidence for Higgott, Chapter 7

This directory supports, but does not replace, the [replication paper](../paper/sixfold_qubit_savings__a_replication_of_higgott_bolza_codes.pdf). It documents the source interpretation behind the bounded Table 7.2 / Figure 7.14a replication, not a replication of the entire dissertation.

## Read first

- [Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf](Higgott_Chapter_7_Figure_7_14_Source_Evidence_Appendix.pdf): five-page illustrated source audit.
- [figure_7_14a_vector_points.csv](figure_7_14a_vector_points.csv): 32 figure-derived marker values, not original experimental or simulation counts.
- [vector_extraction_metadata.json](vector_extraction_metadata.json): axis calibration, source hashes, affine alignment, and extraction tolerance.
- [extract_figure_points.py](extract_figure_points.py): portable, hash-checked vector extraction; reads PDFs and does not execute downloaded research code.
- [crop_manifest.json](crop_manifest.json): page numbers, 600-dpi crop rectangles, and original image hashes.
- [artifact_hashes.json](artifact_hashes.json): SHA256 and Git blob SHA1 for every other file in this evidence directory.

## Source excerpts

| Source point | Evidence |
|---|---|
| Six subrounds correspond to two rounds, p.162 | [caption_p162_600dpi.png](caption_p162_600dpi.png) |
| EM3 noise definition, p.164 | [em3_noise_definition_p164_600dpi.png](em3_noise_definition_p164_600dpi.png) |
| Block-error metric, p.173 | [caption_p173_600dpi.png](caption_p173_600dpi.png) |
| Code parameters, p.174 | [table_7_2_p174_600dpi.png](table_7_2_p174_600dpi.png) |
| Independent-copy transformation, p.175 | [caption_p175_600dpi.png](caption_p175_600dpi.png) |
| Figure 7.14 and caption, p.178 | [figure_7_14_caption_p178_600dpi.png](figure_7_14_caption_p178_600dpi.png) |

The original author is Oscar Higgott. Source: [UCL dissertation record](https://discovery.ucl.ac.uk/id/eprint/10186408/), *Practical and Efficient Quantum Error Correction* (institutional year 2024; submitted October 2023). Only selected research-relevant excerpts are reproduced here; full source PDF and archive are not redistributed.

## Interpretation limits

Original shot counts and raw logical-error observations were not available in the inspected materials. CSV intervals propagate a conservative ±0.05 PDF-point coordinate tolerance; they are **not Monte Carlo confidence intervals**. The 32 marker centers from the arXiv vector panel align with thesis Figure 7.14a to a maximum residual of approximately 0.0000147 thesis PDF points. This establishes graphical agreement, not access to underlying counts.

The metric is any logical failure within the encoded block, not an average per logical qubit. Four independent planar patches are combined per basis as `1 - (1 - p_patch)^4`, followed by the X/Z average. Figure 7.14 specifies 16 rounds; six subrounds equal two rounds. The main paper, not this appendix, evaluates duration choices and the resulting replication verdicts. The sixfold physical-qubit comparison is scoped to direct-pair-measurement EM3, not universal hardware equivalence.

## Reproduce vector extraction

Requires Python 3, PyMuPDF, and NumPy; verified with PyMuPDF 1.26.6 and NumPy 2.3.5 on Linux. A network connection is needed only to obtain the original sources. Use a disposable directory outside the repository for downloaded copyrighted source documents.

```sh
python3 -m venv /tmp/higgott-evidence-venv
. /tmp/higgott-evidence-venv/bin/activate
python -m pip install PyMuPDF==1.26.6 numpy==2.3.5
mkdir -p /tmp/higgott-source-inputs
curl -L --fail https://discovery.ucl.ac.uk/id/eprint/10186408/2/higgott_thesis_final_version.pdf -o /tmp/higgott-source-inputs/thesis.pdf
curl -L --fail https://arxiv.org/src/2308.03750v1 -o /tmp/higgott-source-inputs/source.tar
# Extract only the selected data panel; do not execute archive contents.
tar -xOf /tmp/higgott-source-inputs/source.tar figures/bolza_l1_vs_planar_honeycomb_em3.pdf > /tmp/higgott-source-inputs/panel.pdf
# Run from this source-evidence directory:
python extract_figure_points.py \
  --thesis /tmp/higgott-source-inputs/thesis.pdf \
  --panel /tmp/higgott-source-inputs/panel.pdf \
  --archive /tmp/higgott-source-inputs/source.tar \
  --output-dir /tmp/higgott-source-inputs/regenerated
cmp figure_7_14a_vector_points.csv /tmp/higgott-source-inputs/regenerated/figure_7_14a_vector_points.csv
cmp vector_extraction_metadata.json /tmp/higgott-source-inputs/regenerated/vector_extraction_metadata.json
```

Expected: 32 rows plus a CSV header, and metadata reporting `point_count: 32`. The packaged script regenerated both files byte-for-byte against the pinned sources. Small numerical differences may occur with other library versions; the input hash checks deliberately reject changed source files. Do not reinterpret a failed download or different archive as evidence against the dissertation.

To regenerate crops, open the hash-matched thesis with PyMuPDF, select each `pdf_page_0based` from `crop_manifest.json`, and render its `crop_bbox_pdf_points` using `page.get_pixmap(clip=fitz.Rect(*bbox), dpi=600)`. Image bytes can depend on renderer version; provenance records the exact reviewed files.
