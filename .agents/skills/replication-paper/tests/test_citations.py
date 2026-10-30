import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location("citations", Path(__file__).parents[1]/"scripts/check_citations.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
check = module.check_citations


class CitationTests(unittest.TestCase):
    def test_missing_scholarly_apparatus(self):
        self.assertEqual(len(check("Source: https://example.org", "")["errors"]), 2)

    def test_notes_multiple_keys_and_bibtex(self):
        self.assertFalse(check(r"\citep[see][pp. 2--3]{a,b} \citet*{a}",
                               "@article{a, title={A}}\n@book{b, title={B}}")["errors"])

    def test_unresolved_unused_duplicate(self):
        result = check(r"\cite{x}", r"\bibitem[Author(2020)]{a} A \bibitem{a} B")
        self.assertEqual(len(result["errors"]), 3)

    def test_comments_do_not_count(self):
        result = check("% \\cite{x}\n\\cite{a}", r"\bibitem{a} A")
        self.assertFalse(result["errors"])

    def test_log_gate(self):
        self.assertTrue(check(r"\cite{a}", r"\bibitem{a} A", "Package natbib Warning: Citation `a' undefined")["errors"])

    def test_valid_author_year(self):
        self.assertFalse(check(r"\citet{a}", r"\bibitem[Author et al.(2020)]{a} A", "Output written")["errors"])
