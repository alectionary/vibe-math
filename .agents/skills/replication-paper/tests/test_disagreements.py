"""Every disagreement is analysed: competing theories, our side tested, a conclusion."""

from __future__ import annotations

import copy
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / "scripts"))

import disagreements  # noqa: E402

REPORT = {"date": "2026-11-08", "channel": "chat", "summary": "told; agreed to leave it untested"}
PLAN = {
    "parts": [{"id": "bias-table", "status": "mismatch"}, {"id": "headline", "status": "replicated"}],
    "published_evidence": [{"id": "fig-4-16", "agreement": "disagree"}, {"id": "table-4-8", "agreement": "agree"}],
}
PAPER = "\\section{Disagreements}\\label{dis:h-absent} ..."


def good_entry():
    return {
        "id": "h-absent",
        "claim": "MINT bias is about -ah in every cell",
        "ours": "MINT bias is within .01 of zero",
        "covers": ["bias-table", "fig-4-16"],
        "hypotheses": [
            {"id": "our-code", "side": "ours", "statement": "our estimator mishandles h",
             "prediction": "her printed R code would recover h where ours does not",
             "test": {"method": "replay her seeded R code", "files": ["out/estimates.csv"]},
             "result": "her code recovers h with slope 0.998", "verdict": "ruled_out"},
            {"id": "no-interaction", "side": "source", "statement": "her data had no interaction",
             "prediction": "her rejection rates match ours with h set to 0",
             "test": {"method": "compare digitized rates with our h=0 cells", "files": ["results/agree.csv"]},
             "result": "85-100% agreement", "verdict": "supported"},
        ],
        "conclusion": "explained", "whose": "source", "confidence": "high",
    }


class Disagreements(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        for f in ("out/estimates.csv", "results/agree.csv"):
            (self.root / f).parent.mkdir(parents=True, exist_ok=True)
            (self.root / f).write_text("x\n1\n", encoding="utf-8")

    def write(self, entries):
        import yaml
        (self.root / "DISAGREEMENTS.yaml").write_text(yaml.safe_dump({"disagreements": entries}), encoding="utf-8")

    def check(self, plan=PLAN, paper=PAPER):
        return disagreements.disagreement_errors(self.root, plan, paper)

    def test_a_disagreement_without_a_record_fails(self):
        errs = self.check()
        self.assertTrue(any("DISAGREEMENTS.yaml is required" in e and "bias-table" in e and "fig-4-16" in e for e in errs))
        self.assertEqual(disagreements.disagreement_errors(self.root, {"parts": [{"id": "x", "status": "replicated"}]}, ""), [])

    def test_a_complete_analysis_passes(self):
        self.write([good_entry()])
        self.assertEqual(self.check(), [])

    def test_every_disagreement_must_be_covered(self):
        e = good_entry()
        e["covers"] = ["bias-table"]
        self.write([e])
        self.assertTrue(any("fig-4-16" in x and "not covered" in x for x in self.check()))
        e["covers"] = ["bias-table", "fig-4-16", "nonexistent"]
        self.write([e])
        self.assertTrue(any("nonexistent" in x for x in self.check()))

    def test_competing_theories_and_our_side_are_required(self):
        e = good_entry()
        e["hypotheses"] = e["hypotheses"][1:]
        self.write([e])
        errs = self.check()
        self.assertTrue(any("at least two hypotheses" in x for x in errs))
        self.assertTrue(any("error is ours" in x for x in errs))
        e = good_entry()
        e["hypotheses"][0].update(verdict="untested", untested_reason="no time", reported_to_person=REPORT)
        self.write([e])
        self.assertTrue(any("error is ours" in x for x in self.check()))

    def test_tests_must_point_at_committed_results(self):
        e = good_entry()
        e["hypotheses"][1]["test"]["files"] = ["results/missing.csv"]
        e["hypotheses"][1]["result"] = ""
        self.write([e])
        errs = self.check()
        self.assertTrue(any("results/missing.csv does not exist" in x for x in errs))
        self.assertTrue(any("result is required" in x for x in errs))

    def test_untested_theories_need_a_reason_and_the_person(self):
        e = good_entry()
        e["hypotheses"].append({"id": "plot-labels", "side": "source", "statement": "figure labels swapped",
                                "prediction": "bias pattern would follow another factor", "verdict": "untested"})
        self.write([e])
        errs = self.check()
        self.assertTrue(any("untested_reason" in x for x in errs))
        self.assertTrue(any("reported_to_person" in x for x in errs))

    def test_conclusion_and_whose_follow_from_the_tests(self):
        e = good_entry()
        e["hypotheses"][1]["verdict"] = "inconclusive"
        self.write([e])
        self.assertTrue(any("explained needs a supported hypothesis" in x for x in self.check()))
        e = good_entry()
        e["conclusion"] = "unexplained"
        self.write([e])
        self.assertTrue(any("at least partly explained" in x for x in self.check()))
        e = good_entry()
        e["whose"] = "neither"
        self.write([e])
        self.assertTrue(any("supported hypothesis is on the source side" in x for x in self.check()))

    def test_our_errors_need_a_fix(self):
        e = good_entry()
        e["hypotheses"][0]["verdict"] = "supported"
        e["hypotheses"][1]["verdict"] = "ruled_out"
        e["whose"] = "ours"
        self.write([e])
        self.assertTrue(any("fixed_in" in x for x in self.check()))
        e["fixed_in"] = "commit abc123: estimator corrected"
        self.write([e])
        self.assertEqual(self.check(), [])

    def test_the_paper_discusses_each_disagreement(self):
        self.write([good_entry()])
        self.assertTrue(any("\\label{dis:h-absent}" in x for x in self.check(paper="no labels here")))

    def test_complete_partly_runs_count_as_disagreements(self):
        plan = copy.deepcopy(PLAN)
        plan["parts"][0]["status"] = "partly"
        plan["published_evidence"][0]["agreement"] = "agree"
        self.assertEqual(disagreements.triggers(plan), {})
        plan["parts"][0]["run_complete"] = True
        self.assertIn("bias-table", disagreements.triggers(plan))


if __name__ == "__main__":
    unittest.main()
