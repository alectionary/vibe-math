"""Reproduce the omissions that passed structural LaTeX checks in Kupzyk v2."""

import json
from pathlib import Path
import sys
from tempfile import TemporaryDirectory
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "release"))
from citation_coverage import check_citations, study_errors


class CitationCoverage(unittest.TestCase):
    def setUp(self):
        scratch = TemporaryDirectory()
        self.addCleanup(scratch.cleanup)
        self.root = Path(scratch.name)
        (self.root / "runtime.txt").write_text("R 4.5.3; the code uses lmerTest.")
        (self.root / "prior.tex").write_text(r"\bibitem{oldR}R.\bibitem{oldSas}SAS.")
        self.inventory = {
            "repository": "alectionary/vibe-math",
            "software_sections": ["Reproducibility"],
            "items": [
                {"subject": "Dissertation", "evidence": "runtime.txt", "key": "study", "section": "Methods"},
                {"subject": "Satterthwaite", "evidence": "runtime.txt", "key": "lmerTest", "section": "Methods"},
                {"subject": "R", "evidence": "runtime.txt", "key": "r", "section": "Reproducibility",
                 "software": {"version": "4.5.3", "url": "https://www.r-project.org/"}},
            ],
            "previous": {
                "references": "prior.tex",
                "retained": {"oldR": "r"},
                "dropped": {"oldSas": "The rerun uses an R implementation."},
            },
        }
        self.repro = (
            r"\section{Reproducibility}\href{https://www.r-project.org/}{R 4.5.3}"
            r"\href{https://github.com/alectionary/vibe-math/blob/master/runtime.txt}{runtime.txt}"
        )

    def check(self, source):
        (self.root / "main.tex").write_text(source)
        (self.root / "citation-inventory.json").write_text(json.dumps(self.inventory))
        return study_errors(self.root, "main.tex")

    def test_link_only_and_plain_text_method_both_fail(self):
        source = (r"\section{Methods}\cite{study} The Satterthwaite approximation."
                  + self.repro + r"\begin{thebibliography}{1}\bibitem{study}Example.\end{thebibliography}")
        self.assertEqual(check_citations(source, source)["errors"], [])
        errors = self.check(source)
        for subject in ("Satterthwaite", "R"):
            self.assertTrue(any(f"{subject}: missing \\cite" in error for error in errors), errors)
            self.assertTrue(any(f"{subject}: missing References entry" in error for error in errors), errors)

    def test_corrected_manuscript_with_included_methods_and_references(self):
        (self.root / "methods.tex").write_text(r"\section{Methods}\cite{study}\subsection{Tests}\citep{lmerTest}")
        (self.root / "refs.tex").write_text(
            r"\begin{thebibliography}{3}\bibitem{study}S.\bibitem{lmerTest}L.\bibitem{r}R.\end{thebibliography}")
        source = r"\input{methods}" + self.repro + r"\cite{r}\input{refs}"
        self.assertEqual(self.check(source), [])
        self.inventory["previous"]["dropped"].clear()
        self.assertIn("previous reference 'oldSas' has no disposition", self.check(source))

    def test_unlisted_software_link_and_citation_in_wrong_section(self):
        source = (
            r"\section{Methods}\cite{study,r,lmerTest}"
            + self.repro + r"\href{https://pyyaml.org/}{PyYAML 6.0.3}"
            + r"\section{Introduction}\href{https://cran.r-project.org/package=Matrix}{Matrix}"
            + r"\begin{thebibliography}{3}\bibitem{study}S.\bibitem{lmerTest}L.\bibitem{r}R.\end{thebibliography}"
        )
        errors = self.check(source)
        self.assertTrue(any("unaccounted external link https://pyyaml.org/" in e for e in errors), errors)
        self.assertIn("unaccounted package or versioned link https://cran.r-project.org/package=Matrix", errors)
        self.assertIn("R: missing \\cite{r} in 'Reproducibility'", errors)

    def test_missing_inventory_cannot_pass(self):
        (self.root / "main.tex").write_text(r"\section{Methods}")
        self.assertIn("citation-inventory.json", study_errors(self.root, "main.tex")[0])
