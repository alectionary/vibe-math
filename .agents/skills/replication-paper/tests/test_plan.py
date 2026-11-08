"""Done-check tests for the replication plan and optional caption hints.

From the repository root:

    python3 -m unittest discover -s .agents/skills/replication-paper/tests -v
"""

from __future__ import annotations

import contextlib
import copy
import io
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / "scripts"))

import checks  # noqa: E402
import preflight  # noqa: E402

CAPTIONS = SKILL / "fixtures" / "caption_sample.txt"
DONE_FIELDS = (
    "status",
    "reason",
    "evidence",
    "run_count",
    "subset_justification",
    "plan_change_reason",
)


def tex(abstract, body):
    return (
        "\\documentclass{article}\n\\begin{document}\n\\begin{abstract}\n"
        + abstract
        + "\n\\end{abstract}\n"
        + body
        + "\n\\end{document}\n"
    )


def plan(parts, removals=None):
    return {
        "schema_version": 1,
        "dissertation": "Example (2020). A dissertation. Example University.",
        "source_locator": "sources/dissertation.pdf",
        "parts": parts,
        "removals": [] if removals is None else removals,
    }


def headline(**updates):
    part = {
        "id": "headline-result",
        "kind": "headline",
        "label": "Headline comparison",
        "plan": "Run every cell the headline conclusion uses.",
        "status": "replicated",
        "evidence": "outputs/headline.csv",
    }
    part.update(updates)
    return part


def chapter(**updates):
    part = {
        "id": "chapter-1",
        "kind": "chapter",
        "label": "Chapter 1",
        "plan": "Reproduce the Chapter 1 analysis.",
        "status": "replicated",
        "evidence": "outputs/chapter1.csv",
    }
    part.update(updates)
    return part


def baseline_of(data):
    copied = copy.deepcopy(data)
    for part in copied["parts"]:
        for key in DONE_FIELDS:
            part.pop(key, None)
    return copied


def errors(data, paper, baseline=None):
    if baseline is None:
        baseline = baseline_of(data)
    return checks.replication_plan_errors(data, baseline, paper)


FULL_PAPER = tex(
    "We replicated the headline result of Example (2020): published 1.0 versus ours 1.0.",
    "Chapter 1 matches the published table.",
)


class PlanDone(unittest.TestCase):
    def test_full_plan_matches_a_replicated_paper(self):
        found = errors(plan([headline(), chapter()]), FULL_PAPER)
        self.assertEqual(found, [])

    def test_same_input_returns_the_same_errors(self):
        data = plan([headline(status=None), chapter()])
        paper = FULL_PAPER
        base = baseline_of(plan([headline(), chapter()]))
        self.assertEqual(
            checks.replication_plan_errors(data, base, paper),
            checks.replication_plan_errors(copy.deepcopy(data), copy.deepcopy(base), paper),
        )

    def test_missing_status_fails(self):
        data = plan([headline(), chapter()])
        del data["parts"][0]["status"]
        found = errors(data, FULL_PAPER)
        self.assertIn(
            "part headline-result: status must be one of replicated, partly, mismatch, "
            "not_attempted, input_unavailable",
            found,
        )

    def test_not_attempted_and_unavailable_need_reasons(self):
        for status in ("not_attempted", "input_unavailable", "partly", "mismatch"):
            data = plan([headline(status=status, reason="  "), chapter()])
            found = errors(data, FULL_PAPER)
            self.assertIn(f"part headline-result: {status} requires a reason", found)

    def test_replicated_part_does_not_need_a_reason(self):
        data = plan([headline(), chapter()])
        self.assertNotIn("reason", data["parts"][0])
        self.assertEqual(errors(data, FULL_PAPER), [])

    def test_evidence_is_required(self):
        data = plan([headline(evidence=" "), chapter()])
        self.assertIn("part headline-result: evidence required", errors(data, FULL_PAPER))

    def test_removed_part_needs_a_recorded_reason(self):
        current = plan([headline()])
        base = baseline_of(plan([headline(), chapter()]))
        found = errors(current, FULL_PAPER, base)
        self.assertIn("part chapter-1: removed without a recorded reason", found)

    def test_recorded_removal_is_not_a_silent_shrink(self):
        current = plan(
            [headline()],
            removals=[{"id": "chapter-1", "reason": "Duplicate of the headline part."}],
        )
        base = baseline_of(plan([headline(), chapter()]))
        paper = tex(
            "We replicated the headline result of Example (2020): published 1.0 versus ours 1.0.",
            "The duplicate chapter entry was removed from the plan.",
        )
        self.assertEqual(errors(current, paper, base), [])

    def test_unknown_removal_fails(self):
        data = plan([headline(), chapter()], removals=[{"id": "missing", "reason": "No such part."}])
        self.assertIn(
            "removal missing: not in the first committed plan",
            errors(data, FULL_PAPER),
        )

    def test_plan_note_change_needs_a_reason(self):
        data = plan([headline(plan="Run eight cells."), chapter()])
        base = baseline_of(plan([headline(), chapter()]))
        found = errors(data, FULL_PAPER, base)
        self.assertTrue(any("plan_change_reason" in item and "headline-result" in item for item in found))
        data["parts"][0]["plan_change_reason"] = "The first note said every cell; this records the edit."
        self.assertFalse(any("plan_change_reason" in item for item in errors(data, FULL_PAPER, base)))

    def test_shrinking_the_design_count_keeps_the_original_denominator(self):
        data = plan(
            [
                headline(
                    design_count=8,
                    run_count=8,
                    plan_change_reason="The first plan counted 208 settings.",
                ),
                chapter(),
            ]
        )
        base = baseline_of(data)
        base["parts"][0]["design_count"] = 208
        paper = tex(
            "We replicated the headline result on 8 of 8 settings.",
            "See the grid.",
        )
        found = errors(data, paper, base)
        self.assertIn(
            "part headline-result: status replicated overstates a reduced run (8 of 208)",
            found,
        )
        self.assertIn("paper: abstract omits exact count 8 of 208", found)

    def test_reduced_run_passes_when_the_paper_states_the_count(self):
        data = plan(
            [
                headline(
                    status="partly",
                    reason="The full grid did not finish.",
                    design_count=208,
                    run_count=8,
                    subset_justification={
                        "cost_estimate": "208 settings at about 40 minutes each is about 139 CPU-hours; the budget was 6 hours.",
                        "attempted": "Ran one setting from each estimator family, then stopped.",
                    },
                ),
                chapter(),
            ]
        )
        paper = tex(
            "We partly replicated the headline result of Example (2020): 8 of 208 settings.",
            "The pilot covered 8 of 208 settings. Chapter 1 matched the published table.",
        )
        self.assertEqual(errors(data, paper), [])

    def test_reduced_run_cannot_be_called_replicated(self):
        data = plan(
            [
                headline(
                    status="partly",
                    reason="Only a pilot finished.",
                    design_count=208,
                    run_count=8,
                    subset_justification={
                        "cost_estimate": "About 139 CPU-hours for the full grid.",
                        "attempted": "Ran 8 settings and recorded the projected cost.",
                    },
                ),
                chapter(),
            ]
        )
        paper = tex(
            "We replicated the headline result of Example (2020): 8 of 208 settings.",
            "The pilot covered 8 of 208 settings.",
        )
        found = errors(data, paper)
        self.assertIn(
            "paper: abstract verdict overstates the plan (replicated; plan allows partly)",
            found,
        )
        self.assertIn(
            "paper: headline wording overstates the plan (replicated; plan allows partly)",
            found,
        )

    def test_body_must_repeat_the_exact_count(self):
        data = plan(
            [
                headline(
                    status="partly",
                    reason="Only a pilot finished.",
                    design_count=208,
                    run_count=8,
                    subset_justification={
                        "cost_estimate": "About 139 CPU-hours for the full grid.",
                        "attempted": "Ran 8 settings and recorded the projected cost.",
                    },
                ),
                chapter(),
            ]
        )
        paper = tex(
            "We partly replicated the headline result of Example (2020): 8 of 208 settings.",
            "Chapter 1 matched the published table.",
        )
        self.assertIn("paper: body omits exact count 8 of 208", errors(data, paper))

    def test_subset_justification_requires_cost_and_attempts(self):
        data = plan(
            [
                headline(
                    status="partly",
                    reason="Only a pilot finished.",
                    design_count=208,
                    run_count=8,
                    subset_justification={"cost_estimate": "About 139 CPU-hours."},
                ),
                chapter(),
            ]
        )
        paper = tex(
            "We partly replicated the headline result of Example (2020): 8 of 208 settings.",
            "The pilot covered 8 of 208 settings.",
        )
        self.assertIn(
            "part headline-result: subset_justification.attempted required",
            errors(data, paper),
        )

    def test_full_design_claim_fails_when_a_part_was_not_run(self):
        data = plan(
            [
                headline(),
                chapter(
                    status="not_attempted",
                    reason="The Chapter 1 data file was not used because the estimated refit took longer than the budget.",
                ),
            ]
        )
        paper = tex(
            "We replicated the headline result of Example (2020): published 1.0 versus ours 1.0.",
            "We fully replicated the dissertation. Chapter 1 remains open.",
        )
        found = errors(data, paper)
        self.assertTrue(any(item.startswith("paper: coverage claim overstates the plan") for item in found))

    def test_negated_full_claim_and_tex_comments_do_not_count(self):
        data = plan(
            [
                headline(),
                chapter(status="not_attempted", reason="The source file for Chapter 1 was unreadable."),
            ]
        )
        paper = (
            "\\documentclass{article}\n"
            "% We fully replicated the whole dissertation.\n"
            "\\begin{document}\n\\begin{abstract}\n"
            "We replicated the headline result of Example (2020): published 1.0 versus ours 1.0.\n"
            "\\end{abstract}\n"
            "This note does not fully replicate the dissertation.\n"
            "\\end{document}\n"
        )
        self.assertEqual(errors(data, paper), [])

    def test_mismatch_is_not_a_partial_replication(self):
        data = plan(
            [headline(status="mismatch", reason="The sign reversed."), chapter()]
        )
        paper = tex(
            "We partly replicated the headline result of Example (2020).",
            "Chapter 1 matched.",
        )
        self.assertIn(
            "paper: abstract verdict overstates the plan (partly; plan allows not_replicated)",
            errors(data, paper),
        )

    def test_unavailable_input_is_not_called_a_failed_replication(self):
        data = plan(
            [
                headline(status="input_unavailable", reason="The original data were not released."),
                chapter(),
            ]
        )
        overstated = tex(
            "The headline result is not replicated.",
            "Chapter 1 matched.",
        )
        honest = tex(
            "The headline comparison is not established.",
            "Chapter 1 matched. The headline comparison is not established.",
        )
        self.assertIn(
            "paper: abstract verdict overstates the plan (not_replicated; plan allows blocked)",
            errors(data, overstated),
        )
        self.assertEqual(errors(data, honest), [])

    def test_duplicate_id_fails(self):
        data = plan([headline(), headline()])
        self.assertIn("part headline-result: duplicate id", errors(data, FULL_PAPER))

    def test_uncommitted_baseline_fails(self):
        found = checks.replication_plan_errors(plan([headline(), chapter()]), None, FULL_PAPER)
        self.assertIn("plan: first committed version is required", found)


class CaptionHints(unittest.TestCase):
    def test_fixture_text_is_stable(self):
        text = CAPTIONS.read_text(encoding="utf-8")
        expected = [
            {
                "id": "figure:4.1",
                "kind": "figure",
                "number": "4.1",
                "page": 1,
                "caption": "Recovery curves for the four methods.",
            },
            {
                "id": "table:3.2",
                "kind": "table",
                "number": "3.2",
                "page": 1,
                "caption": "Bias by estimator",
            },
            {
                "id": "appendix_table:A.1",
                "kind": "appendix_table",
                "number": "A.1",
                "page": 2,
                "caption": "Seed list",
            },
            {
                "id": "appendix_table:B.2",
                "kind": "appendix_table",
                "number": "B.2",
                "page": 2,
                "caption": "Supplementary counts",
            },
            {
                "id": "equation:4.2",
                "kind": "equation",
                "number": "4.2",
                "page": 2,
                "caption": "The scaled difference.",
            },
            {
                "id": "hypothesis:2",
                "kind": "hypothesis",
                "number": "2",
                "page": 2,
                "caption": "The robust estimator reduces bias.",
            },
            {
                "id": "research_question:1",
                "kind": "research_question",
                "number": "1",
                "page": 2,
                "caption": "Does the ordering hold at n = 100?",
            },
        ]
        self.assertEqual(checks.caption_hints(text), expected)
        self.assertEqual(checks.caption_hints(text), checks.caption_hints(text))

    def test_captions_command_prints_the_fixture(self):
        completed = subprocess.run(
            [sys.executable, str(SKILL / "scripts" / "checks.py"), "captions", str(CAPTIONS)],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(completed.returncode, 0, completed.stderr)
        self.assertEqual(json.loads(completed.stdout), checks.caption_hints(CAPTIONS.read_text(encoding="utf-8")))

    def test_pdf_failure_is_reported(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "empty.pdf"
            path.write_bytes(b"not a pdf")
            with self.assertRaises(RuntimeError):
                checks.read_source_text(path)


class PlanGit(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        hooks = self.root / "empty-hooks"
        hooks.mkdir()
        self._git("init", "-q", "-b", "master")
        self._git("config", "user.email", "test@example.com")
        self._git("config", "user.name", "Test")
        self._git("config", "commit.gpgsign", "false")
        self._git("config", "core.hooksPath", str(hooks))

    def _git(self, *args):
        completed = subprocess.run(
            ["git", "-C", str(self.root), *args],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(completed.returncode, 0, completed.stderr)
        return completed

    def _write(self, relative, text):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        return path

    def _commit_plan(self, data, message):
        self._write("REPLICATION-PLAN.yaml", _dump(data))
        self._git("add", "REPLICATION-PLAN.yaml")
        self._git("commit", "-q", "-m", message)

    def test_working_tree_shrink_is_caught_against_the_first_commit(self):
        original = baseline_of(plan([headline(), chapter()]))
        self._commit_plan(original, "plan the full design")
        shrunk = plan([headline()])
        self._write("REPLICATION-PLAN.yaml", _dump(shrunk))
        self._write("paper.tex", FULL_PAPER)
        decision = preflight.done_check(self.root, "REPLICATION-PLAN.yaml", "paper.tex")
        self.assertFalse(decision["accepted"])
        self.assertIn("part chapter-1: removed without a recorded reason", decision["errors"])
        self.assertIsNotNone(decision["baseline_revision"])

    def test_plan_commit_precedes_analysis(self):
        original = baseline_of(plan([headline(), chapter()]))
        self._commit_plan(original, "plan the full design")
        self._write("sim/run.py", "print('analysis')\n")
        self._git("add", "sim/run.py")
        finished = plan([headline(), chapter()])
        self._write("REPLICATION-PLAN.yaml", _dump(finished))
        self._git("add", "REPLICATION-PLAN.yaml")
        self._git("commit", "-q", "-m", "run the analysis")
        self._write("paper.tex", FULL_PAPER)
        decision = preflight.done_check(
            self.root,
            "REPLICATION-PLAN.yaml",
            "paper.tex",
            ["sim/run.py"],
        )
        self.assertEqual(decision["errors"], [], decision)
        self.assertTrue(decision["accepted"])

    def test_analysis_in_the_plan_commit_fails(self):
        self._write("REPLICATION-PLAN.yaml", _dump(plan([headline(), chapter()])))
        self._write("sim/run.py", "print('analysis')\n")
        self._git("add", "REPLICATION-PLAN.yaml", "sim/run.py")
        self._git("commit", "-q", "-m", "plan and analysis together")
        self._write("paper.tex", FULL_PAPER)
        decision = preflight.done_check(
            self.root,
            "REPLICATION-PLAN.yaml",
            "paper.tex",
            ["sim/run.py"],
        )
        self.assertFalse(decision["accepted"])
        self.assertIn(
            "analysis sim/run.py: plan was not committed before this analysis",
            decision["errors"],
        )

    def test_uncommitted_plan_fails(self):
        self._write("README.md", "study\n")
        self._git("add", "README.md")
        self._git("commit", "-q", "-m", "readme")
        self._write("REPLICATION-PLAN.yaml", _dump(plan([headline(), chapter()])))
        self._write("paper.tex", FULL_PAPER)
        decision = preflight.done_check(self.root, "REPLICATION-PLAN.yaml", "paper.tex")
        self.assertIn("plan: first committed version is required", decision["errors"])

    def test_rename_still_uses_the_first_blob(self):
        original = baseline_of(plan([headline(), chapter()]))
        self._commit_plan(original, "plan the full design")
        (self.root / "study").mkdir()
        self._git("mv", "REPLICATION-PLAN.yaml", "study/REPLICATION-PLAN.yaml")
        finished = plan([headline(), chapter()])
        self._write("study/REPLICATION-PLAN.yaml", _dump(finished))
        self._write("sim/run.py", "print('analysis')\n")
        self._git("add", "-A")
        self._git("commit", "-q", "-m", "move the plan and run")
        self._write("paper.tex", FULL_PAPER)
        decision = preflight.done_check(
            self.root,
            "study/REPLICATION-PLAN.yaml",
            "paper.tex",
            ["sim/run.py"],
        )
        self.assertEqual(decision["errors"], [], decision)

    def test_done_command_rejects_a_missing_plan(self):
        with contextlib.redirect_stderr(io.StringIO()):
            with self.assertRaises(SystemExit) as caught:
                preflight.main(["done"])
        self.assertEqual(caught.exception.code, 2)


PARTIAL_PAPER = tex(
    "We could not establish the headline result.",
    "The remaining parts are unresolved.",
)


def limited(part_id, evidence, **updates):
    part = {
        "id": part_id,
        "kind": "analysis",
        "label": part_id,
        "plan": f"Carry out {part_id}.",
        "status": "partly",
        "reason": f"{part_id} stopped after the finite matrix check in its own notes.",
        "evidence": evidence,
        "limit_kind": ["theorem_finite_only"],
        "finite_checks": f"Exhaustive check on the {part_id} example; no universal proof.",
    }
    part.update(updates)
    return part


class LimitKinds(unittest.TestCase):
    def test_plans_without_the_schema_keep_shared_boilerplate(self):
        shared = "See named artifacts and limitations."
        data = plan([
            headline(status="partly", reason=shared, evidence="notes.md"),
            chapter(status="partly", reason=shared, evidence="notes.md"),
        ])
        found = errors(data, PARTIAL_PAPER)
        self.assertFalse(any("limit_kind" in item or "generic template" in item for item in found))

    def test_schema_requires_a_specific_kind_reason_and_evidence(self):
        data = plan([
            headline(
                status="partly",
                reason="See named artifacts and limitations.",
                evidence="notes.md; notes.md",
            ),
            chapter(
                status="partly",
                reason="See named artifacts and limitations.",
                evidence="notes.md",
            ),
        ])
        data["limit_schema"] = 1
        found = errors(data, PARTIAL_PAPER)
        self.assertTrue(any("limit_kind required" in item for item in found))
        self.assertTrue(any("generic template" in item for item in found))
        self.assertTrue(any("reason duplicates" in item for item in found))
        self.assertTrue(any("evidence path is repeated" in item for item in found))
        self.assertTrue(any("evidence is not part-specific" in item for item in found))

    def test_each_limit_kind_keeps_its_own_facts(self):
        good = plan([
            headline(),
            limited("reshape-cost", "results/reshape_cost.json", status="not_attempted",
                    reason="Oracle call counts were not executed; the script is results/reshape_cost.py.",
                    limit_kind=[{"kind": "not_run"}],
                    cost_estimate="About 1 CPU-minute for the six worked examples.",
                    decision="Not run in this pass.",
                    tractable=True,
                    justification="The count is a short exact calculation, deferred only because the oracle implementation was still being checked."),
            limited("reshape-random", "sources/random-search.md", status="input_unavailable",
                    reason="The (3,4) seed matrices are not in the archived repository.",
                    limit_kind=["input_unavailable"],
                    missing_input="original (3,4) seed matrices",
                    looked_in="sources/browser-extraction.txt and the code archive"),
        ])
        good["limit_schema"] = 1
        self.assertEqual(errors(good, PARTIAL_PAPER), [])
        costly = plan([
            headline(),
            limited("reshape-cost", "results/reshape_cost.json", status="not_attempted",
                    reason="The resource count was left for later.",
                    limit_kind=["not_run"],
                    cost_estimate="1 CPU-minute",
                    decision="1 CPU-minute",
                    tractable=True,
                    justification="1 CPU-minute"),
        ])
        costly["limit_schema"] = 1
        found = errors(costly, PARTIAL_PAPER)
        self.assertTrue(any("compute cost alone is not acceptable" in item for item in found))
        declined = plan([
            headline(),
            limited("threshold-table", "results/threshold_decision.json", status="partly",
                    reason="The N=8 grid at L=9 and L=11 is tractable and was declined for this project's compute limit.",
                    limit_kind=["not_run"],
                    cost_estimate="About 54 CPU-hours per toric L=11 point, several days on 4 cores.",
                    decision="declined for resources",
                    tractable=True,
                    decision_by="project",
                    decision_reason="The source design can be run. This project declines L=9 and L=11 at N=8 because one toric L=11 point is about 54 CPU-hours and the grid is several days on 4 cores."),
        ])
        declined["limit_schema"] = 1
        self.assertEqual(errors(declined, PARTIAL_PAPER), [])
        unnamed = copy.deepcopy(declined)
        unnamed["parts"][1]["decision_reason"] = "See named artifacts and limitations."
        self.assertTrue(any("decision_reason" in item or "compute cost alone" in item
                            for item in errors(unnamed, PARTIAL_PAPER)))

    def test_several_limit_kinds_can_apply_to_one_part(self):
        data = plan([
            headline(),
            limited(
                "confinement-stochastic",
                "results/confinement_audit.md",
                reason="Theorem 2 was checked on one 12-qubit complex; the percolation proof was not redone.",
                limit_kind=["theorem_finite_only", "out_of_scope"],
                finite_checks="31,232 residual checks on 12 qubits.",
                scope_reason="A new general proof is outside this finite audit.",
            ),
        ])
        data["limit_schema"] = 1
        self.assertEqual(errors(data, PARTIAL_PAPER), [])


def _dump(data):
    import yaml

    return yaml.safe_dump(data, sort_keys=False)


if __name__ == "__main__":
    unittest.main()
