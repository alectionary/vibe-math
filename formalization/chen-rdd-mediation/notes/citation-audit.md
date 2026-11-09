# Chen citation audit

The revision retains every one of the ten citation keys in the earlier paper
and adds fourteen references. The [citation inventory](../citation-inventory.json)
maps each reference to evidence of use and to a manuscript section.

- The recorded versions of [dplyr](https://cran.r-project.org/src/contrib/Archive/dplyr/),
  [tidyr](https://cran.r-project.org/src/contrib/Archive/tidyr/),
  [purrr](https://cran.r-project.org/src/contrib/Archive/purrr/),
  [data.table](https://cran.r-project.org/src/contrib/Archive/data.table/),
  [stringi](https://cran.r-project.org/src/contrib/Archive/stringi/) and
  [digest](https://cran.r-project.org/src/contrib/Archive/digest/) were matched
  against the exact CRAN archive releases and the
  [R replay session](../r-reproduction/out-full/session.txt).
  The archived DESCRIPTION files supply authors, title and release date.
  The archived stringi CITATION file supplies its recommended title.
- The [run record](run-record.md) identifies both Python and NumPy versions
  and the scikit-learn version. The language reference points to the
  [Python project](https://www.python.org/). The NumPy and scikit-learn
  references link the [recommended NumPy paper](https://numpy.org/citing-numpy/)
  and [scikit-learn article](https://jmlr.org/papers/v12/pedregosa11a.html).
- The archived code uses [PyMuPDF](https://github.com/pymupdf/PyMuPDF),
  [pandas](https://pandas.pydata.org/about/citing.html), and
  [SciPy](https://scipy.org/citing-scipy/). Their historical versions are
  unrecorded. The bibliography gives the PyMuPDF project and the
  recommended papers for pandas and SciPy.
  [Pillow](https://python-pillow.org/) decodes raster figures.
  The packet builder uses [PyYAML](https://pyyaml.org/) for YAML records and
  [Poppler](https://poppler.freedesktop.org/) for PDF text. The historical
  versions of these tools are unrecorded as well.
- The revised PDF was built with
  [Tectonic 0.17.0](https://tectonic-typesetting.github.io/en-US/).
