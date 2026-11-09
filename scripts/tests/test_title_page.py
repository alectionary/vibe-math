"""Regression checks for the restored Kupzyk title-page layout."""

from pathlib import Path
import sys
from tempfile import TemporaryDirectory
import unittest

import fitz

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "release"))
import title_page

REFERENCE = Path(__file__).resolve().parents[2] / (
    "formalization/kupzyk-power-assumptions/paper/"
    "simplifying_assumptions_in_power_analysis__a_replication_of_kupzyk_2011.pdf"
)
SOURCE = r"""\documentclass[11pt]{article}
\title{Simplifying assumptions in power analysis:\\A replication of Kupzyk (2011)}
\date{29 October 2026}
\begin{document}
\input{academic-title.tex}
\begin{abstract}
Verdict.
\end{abstract}
\end{document}
"""


class TitlePage(unittest.TestCase):
    def setUp(self):
        folder = TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        (self.root / "academic-title.tex").write_bytes(title_page.ASSET.read_bytes())
        self.source = self.root / "paper.tex"
        self.source.write_text(SOURCE)
        self.pdf = self.source.with_suffix(".pdf")

    def test_original_academic_title_passes(self):
        self.pdf.write_bytes(REFERENCE.read_bytes())
        self.assertEqual(title_page.check(self.source), [])

    def test_blank_date_and_local_title_override_fail(self):
        self.source.write_text(SOURCE.replace(r"\date{29 October 2026}", r"\date{}")
                               .replace(r"\begin{document}", r"\renewcommand{\@maketitle}{Override}\begin{document}"))
        errors = title_page.check(self.source)
        self.assertTrue(any("explicit day" in error for error in errors), errors)
        self.assertTrue(any("local override" in error for error in errors), errors)

    def test_larger_neighbor_is_never_used(self):
        other = self.root / "older-replication.pdf"
        other.write_bytes(REFERENCE.read_bytes())
        self.assertIsNone(title_page.exact_pdf(self.source))
        self.assertEqual(title_page.check(self.source), ["title page: exact manuscript PDF is required"])
        with fitz.open(REFERENCE) as reference, fitz.open() as one_page:
            one_page.insert_pdf(reference, from_page=0, to_page=0)
            one_page.save(self.pdf)
        self.assertGreater(other.stat().st_size, self.pdf.stat().st_size)
        self.assertEqual(title_page.exact_pdf(self.source), self.pdf)
        self.assertEqual(title_page.check(self.source), [])

    def test_pdf_with_compressed_title_spacing_fails(self):
        with fitz.open(REFERENCE) as reference, fitz.open() as compressed:
            page = compressed.new_page(width=612, height=792)
            upper = fitz.Rect(0, 0, 612, 150)
            lower = fitz.Rect(0, 150, 612, 792)
            page.show_pdf_page(upper, reference, 0, clip=upper)
            page.show_pdf_page(fitz.Rect(0, 110, 612, 752), reference, 0, clip=lower)
            compressed.save(self.pdf)
        errors = title_page.check(self.source)
        self.assertIn("title page: title-to-date spacing is outside the approved range", errors)


if __name__ == "__main__":
    unittest.main()
