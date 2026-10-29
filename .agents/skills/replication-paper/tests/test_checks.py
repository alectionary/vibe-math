"""Regression checks for numerical precision, scope, and comparability.

From the repository root:

    python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
"""

from __future__ import annotations

import json
import subprocess
import sys
import unittest
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / "scripts"))

import checks  # noqa: E402
import preflight  # noqa: E402

FIXTURE = json.loads((SKILL / "fixtures" / "abbott_regression.json").read_text())


class NumericalAndScope(unittest.TestCase):
    def test_point_eight_six_is_a_numerical_match(self):
        row = FIXTURE["rounding_match"]
        axes = checks.two_axis(row["published"], row["ours"], row["decimals"], row["scope"])
        self.assertEqual(axes["numerical"], "match")
        self.assertEqual(axes["scope"], "limited")
        self.assertIsNone(axes["verdict"])
        self.assertNotIn("partial", axes.values())

    def test_scope_stays_put_when_the_number_matches(self):
        exact = checks.two_axis("0.86", "0.8602", 2, "exact")
        limited = checks.two_axis("0.86", "0.8602", 2, "limited")
        self.assertEqual(exact["numerical"], limited["numerical"])
        self.assertNotEqual(exact["scope"], limited["scope"])

    def test_third_decimal_that_does_not_round_is_close(self):
        row = FIXTURE["third_decimal_close"]
        axes = checks.two_axis(row["published"], row["ours"], row["decimals"], row["scope"])
        self.assertEqual(axes["numerical"], "close")
        self.assertEqual(axes["scope"], "limited")

    def test_clear_mismatch(self):
        self.assertEqual(checks.numerical_verdict("52.457", "74.3889", 3), "mismatch")


class Comparability(unittest.TestCase):
    def test_core_plain_against_auxiliary_robust_is_flagged(self):
        case = FIXTURE["incomparable"][0]
        decision = checks.comparability(case["left"], case["right"], case["index"])
        self.assertFalse(decision["verdict_allowed"])
        self.assertIsNone(decision["numerical"])
        self.assertIn("robust", decision["flag"])
        self.assertIn("variable", decision["flag"])

    def test_plain_ml_against_robust_chi_square_is_flagged(self):
        case = FIXTURE["incomparable"][1]
        decision = checks.comparability(case["left"], case["right"], case["index"])
        self.assertFalse(decision["verdict_allowed"])
        self.assertIsNone(decision["numerical"])
        self.assertIn("robust", decision["flag"])
        self.assertNotIn("variable", decision["flag"])

    def test_srmr_with_the_same_variables_keeps_a_numerical_slot(self):
        case = FIXTURE["comparable_srmr"]
        decision = checks.comparability(case["left"], case["right"], case["index"])
        self.assertTrue(decision["verdict_allowed"])
        self.assertIsNone(decision["flag"])

    def test_incomplete_record_is_flagged(self):
        case = FIXTURE["comparable_srmr"]
        left = dict(case["left"])
        del left["baseline"]
        decision = checks.comparability(left, case["right"], case["index"])
        self.assertFalse(decision["verdict_allowed"])
        self.assertIsNone(decision["numerical"])
        self.assertIn("baseline", decision["flag"])


class ScaledDifference(unittest.TestCase):
    def _pair(self, name):
        pair = FIXTURE["scaled_difference"][name]
        result = checks.scaled_chi_square_difference(
            pair["t0"], pair["df0"], pair["c0"], pair["t1"], pair["df1"], pair["c1"]
        )
        judged = checks.procedure_comparison(pair["printed"], result, pair["decimals"])
        return pair, result, judged

    def test_documented_formula_does_not_match_the_printed_refinement(self):
        pair, result, judged = self._pair("initial_versus_refined")
        self.assertEqual(result["df"], Decimal(3))
        documented = result["documented"].quantize(Decimal("0.0001"), rounding=ROUND_HALF_UP)
        recovered = result["arithmetic_recovery"].quantize(Decimal("0.0001"), rounding=ROUND_HALF_UP)
        self.assertEqual(documented, Decimal("74.3889"))
        self.assertEqual(recovered, Decimal("52.4568"))
        self.assertEqual(judged["procedure_numerical"], "mismatch")
        self.assertEqual(judged["arithmetic_recovery_numerical"], "match")
        self.assertFalse(judged["procedure_validated"])
        self.assertEqual(pair["printed_df"], 3)

    def test_neither_expression_returns_the_printed_general_factor_line(self):
        pair, result, judged = self._pair("general_versus_refined")
        self.assertEqual(result["df"], Decimal(1))
        self.assertNotEqual(pair["printed_df"], int(result["df"]))
        documented = result["documented"].quantize(Decimal("0.0001"), rounding=ROUND_HALF_UP)
        recovered = result["arithmetic_recovery"].quantize(Decimal("0.0001"), rounding=ROUND_HALF_UP)
        self.assertEqual(documented, Decimal("7.2312"))
        self.assertEqual(recovered, Decimal("4.0234"))
        self.assertEqual(judged["procedure_numerical"], "mismatch")
        self.assertEqual(judged["arithmetic_recovery_numerical"], "mismatch")
        self.assertFalse(judged["procedure_validated"])

    def test_recovery_is_not_labeled_as_the_procedure(self):
        _, result, judged = self._pair("initial_versus_refined")
        self.assertNotEqual(result["documented"], result["arithmetic_recovery"])
        self.assertIn("statmodel.com/chidiff.shtml", result["source"])
        self.assertIn("2001", result["procedure"])
        self.assertFalse(judged["procedure_validated"])


class LedgerAndEngine(unittest.TestCase):
    def test_departure_without_justification_is_rejected(self):
        problems = checks.validate_ledger(
            [
                {
                    "requirement": "Fit in R with lavaan and OpenMx",
                    "status": "departed",
                    "evidence": "SciPy normal-theory fit",
                    "justification": "",
                }
            ]
        )
        self.assertTrue(problems)

    def test_justified_departure_is_accepted(self):
        problems = checks.validate_ledger(
            [
                {
                    "requirement": "Fit in R with lavaan and OpenMx",
                    "status": "departed",
                    "evidence": "preflight reported Rscript missing",
                    "justification": "R could not be installed on this machine",
                }
            ]
        )
        self.assertEqual(problems, [])

    def test_missing_engine_without_fallback_is_not_accepted(self):
        decision = preflight.assess(
            {"os": "Linux", "rscript": None, "lavaan": None, "openmx": None}
        )
        self.assertFalse(decision["accepted"])
        self.assertIsNone(decision["engine"])

    def test_fallback_needs_independent_validation(self):
        bare = preflight.assess(
            {"os": "Darwin", "rscript": None, "lavaan": None, "openmx": None},
            {"name": "scipy", "justification": "R was not installed"},
        )
        self.assertFalse(bare["accepted"])
        ready = preflight.assess(
            {"os": "Darwin", "rscript": None, "lavaan": None, "openmx": None},
            {
                "name": "scipy",
                "justification": "Rscript was not on the path and could not be installed",
                "independent_validation": "L-BFGS-B and SLSQP agreed to 1e-12 on the same discrepancy",
            },
        )
        self.assertTrue(ready["accepted"])
        self.assertTrue(ready["fallback"])
        self.assertEqual(ready["engine"], "scipy")

    def test_preferred_engine_does_not_need_a_fallback(self):
        decision = preflight.assess(
            {
                "os": "Linux",
                "rscript": "/usr/bin/Rscript",
                "r_version": "R version 4.3.3",
                "lavaan": "0.6.17",
                "openmx": "2.21.11",
            }
        )
        self.assertTrue(decision["accepted"])
        self.assertEqual(decision["engine"], "lavaan+openmx")
        self.assertFalse(decision["fallback"])

    def test_live_probe_names_the_operating_system(self):
        record = preflight.probe()
        self.assertIn(record["os"], ("Linux", "Darwin"))
        self.assertIn("rscript", record)

    def test_preflight_source_has_no_gnu_only_commands(self):
        text = (SKILL / "scripts" / "preflight.py").read_text()
        for banned in ("readlink -f", "stat -c", "sed -i", "grep -P", "wget "):
            self.assertNotIn(banned, text)


class Commands(unittest.TestCase):
    def test_checks_script_prints_the_split(self):
        completed = subprocess.run(
            [sys.executable, str(SKILL / "scripts" / "checks.py")],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(completed.returncode, 0, completed.stderr)
        self.assertIn('"numerical": "match"', completed.stdout)
        self.assertIn('"scope": "limited"', completed.stdout)
        self.assertIn("procedure_validated False", completed.stdout)
        self.assertIn("incomparable_numerical None", completed.stdout)


if __name__ == "__main__":
    unittest.main()
