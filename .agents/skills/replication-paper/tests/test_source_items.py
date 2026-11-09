"""The source gate reads figures and tables from the source PDF itself.

The PDFs here are synthetic test documents with known captions, built inside each
test; they stand in for no real source.
"""

from __future__ import annotations

import hashlib
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / "scripts"))

import preflight  # noqa: E402
import source_items  # noqa: E402

HAVE_FITZ = importlib.util.find_spec("fitz") is not None
REPORT = {"date": "2026-11-08", "channel": "chat", "summary": "told the person; they agreed"}


def synthetic_source(path: Path) -> None:
    """Four pages: a list of figures, a vector figure, a table of means, a text-only figure."""
    import fitz

    doc = fitz.open()
    p = doc.new_page()
    p.insert_text((72, 72), "LIST OF FIGURES")
    p.insert_text((72, 100), "Figure 1.1 Bias by sample size ........................ 2")
    p.insert_text((72, 120), "Figure 2.2 Path diagram ............................... 4")
    p = doc.new_page()
    p.insert_text((72, 60), "As Figure 1.1 shows, bias falls with n.")
    for i in range(160):
        x, y = 80 + (i % 40) * 10, 100 + (i // 40) * 30
        p.draw_rect(fitz.Rect(x, y, x + 3, y + 3), color=(1, 0, 0), fill=(1, 0, 0))
    p.insert_text((72, 300), "Figure 1.1 Bias by Sample Size and Effect Size")
    p = doc.new_page()
    p.insert_text((72, 72), "Table 2.1 Means and Standard Deviations of the Study Variables")
    p.insert_text((72, 100), "x   0.10   1.00")
    p = doc.new_page()
    p.insert_text((72, 72), "Figure 2.2 Path Diagram of the Mediation Model")
    doc.save(path)


@unittest.skipUnless(HAVE_FITZ, "needs PyMuPDF")
class Inventory(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.pdf = self.root / "sources" / "dissertation.pdf"
        self.pdf.parent.mkdir()
        synthetic_source(self.pdf)
        self.items = source_items.inventory(self.pdf)

    def test_captions_are_found_once_and_classified(self):
        by = {i["label"]: i for i in self.items}
        self.assertEqual(sorted(by), ["Figure 1.1", "Figure 2.2", "Table 2.1"])
        self.assertEqual(by["Figure 1.1"]["page"], 2)        # not the list of figures, not the sentence
        self.assertEqual(by["Figure 1.1"]["mode"], "vector")
        self.assertEqual(by["Figure 2.2"]["mode"], "none")
        self.assertTrue(by["Table 2.1"]["moments"])

    def test_every_item_must_be_read_or_excluded(self):
        self.assertTrue(any("source_items: required" in e for e in source_items.source_items_errors({}, self.items, self.root)))
        plan = {"source_items": [{"label": "Figure 1.1", "use": "read", "data_file": "results/fig11.csv"}]}
        errs = source_items.source_items_errors(plan, self.items, self.root)
        self.assertTrue(any("Figure 2.2 (p. 4, none) is in the source but not in the plan" in e for e in errs))
        self.assertTrue(any("Table 2.1" in e and "not in the plan" in e for e in errs))
        self.assertTrue(any("data_file results/fig11.csv is missing or empty" in e for e in errs))

    def test_a_complete_listing_passes(self):
        (self.root / "results").mkdir()
        (self.root / "results" / "fig11.csv").write_text("n,bias\n500,0.01\n", encoding="utf-8")
        plan = {"source_items": [
            {"label": "Figure 1.1", "use": "read", "data_file": "results/fig11.csv"},
            {"label": "Figure 2.2", "use": "excluded", "reason": "a path diagram; it plots no values",
             "reported_to_person": REPORT},
            {"label": "Table 2.1", "use": "read", "data_file": "results/fig11.csv",
             "sufficient_statistics": {"found": True, "what": "means and SDs", "sufficient": False,
                                       "why": "no correlations, so the covariances cannot be rebuilt"}},
        ]}
        self.assertEqual(source_items.source_items_errors(plan, self.items, self.root), [])
        plan["source_items"][1].pop("reported_to_person")
        plan["source_items"][2].pop("sufficient_statistics")
        plan["source_items"].append({"label": "Figure 9.9", "use": "read", "data_file": "results/fig11.csv"})
        errs = source_items.source_items_errors(plan, self.items, self.root)
        self.assertTrue(any("Figure 2.2: use excluded requires reported_to_person" in e for e in errs))
        self.assertTrue(any("Table 2.1" in e and "sufficient_statistics" in e for e in errs))
        self.assertTrue(any("Figure 9.9: not a caption in the source" in e for e in errs))

    def test_the_paper_cannot_cite_a_label_the_source_lacks(self):
        errs = source_items.cited_label_errors("Chen's Figure 1.1 and Table 7.4 show ...", self.items)
        self.assertEqual(errs, ["paper: cites Table 7.4, which is not a caption in the source"])


@unittest.skipUnless(HAVE_FITZ, "needs PyMuPDF")
class SourceGate(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.plan = {"source_locator": "sources/dissertation.pdf", "source_items": []}

    def gate(self):
        return preflight.source_gate(self.root, self.plan, "")

    def test_missing_source_must_be_recorded_and_makes_the_study_incomplete(self):
        errors, incomplete = self.gate()
        self.assertTrue(any("no source_missing record" in e for e in errors))
        self.plan["source_missing"] = {"fetch_issue": 93, "since": "2026-11-08", "reason": "not stored after review"}
        errors, incomplete = self.gate()
        self.assertEqual(errors, [])
        self.assertEqual(len(incomplete), 1)
        self.assertIn("fetch issue #93", incomplete[0])
        self.plan["source_missing"] = {"since": "2026-11-08", "reason": "x"}
        errors, _ = self.gate()
        self.assertTrue(any("fetch_issue" in e for e in errors))

    def test_present_source_must_match_its_recorded_hash(self):
        pdf = self.root / "sources" / "dissertation.pdf"
        pdf.parent.mkdir()
        synthetic_source(pdf)
        errors, _ = self.gate()
        self.assertTrue(any("source_sha256" in e for e in errors))
        self.plan["source_sha256"] = "0" * 64
        errors, _ = self.gate()
        self.assertTrue(any("does not match source_sha256" in e for e in errors))
        self.plan["source_sha256"] = hashlib.sha256(pdf.read_bytes()).hexdigest()
        errors, incomplete = self.gate()
        self.assertEqual(incomplete, [])
        self.assertTrue(any("Figure 1.1" in e and "not in the plan" in e for e in errors))
        self.plan["source_missing"] = {"fetch_issue": 93, "since": "2026-11-08", "reason": "old record"}
        errors, _ = self.gate()
        self.assertTrue(any("remove source_missing" in e for e in errors))


if __name__ == "__main__":
    unittest.main()
