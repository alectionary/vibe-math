"""The paper must be up to date with the evidence a reviewer is shown alongside it."""

import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import paper_freshness  # noqa: E402


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def git(root, *args):
    subprocess.run(["git", "-C", str(root), *args], check=True, capture_output=True)


class Study:
    """A minimal study: plan, one result, packet, writer manifest, paper."""

    def __init__(self, context="fresh"):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        git(self.root, "init", "-q")
        git(self.root, "config", "user.email", "t@example.com")
        git(self.root, "config", "user.name", "t")
        (self.root / "results").mkdir()
        (self.root / "paper").mkdir()
        (self.root / "REPLICATION-PLAN.yaml").write_text("parts: []\n")
        (self.root / "results" / "cells.csv").write_text("a,b\n1,2\n")
        (self.root / "paper" / "p.tex").write_text("paper\n")
        packet = {"artifacts": [
            {"id": "plan", "path": "REPLICATION-PLAN.yaml", "sha256": sha(self.root / "REPLICATION-PLAN.yaml")},
            {"id": "pdf", "path": "source/source.pdf", "sha256": "0" * 64},  # not in git: skipped
        ]}
        (self.root / "evidence-packet.json").write_text(json.dumps(packet))
        manifest = {
            "context": context,
            "packet_sha256": sha(self.root / "evidence-packet.json"),
            "inputs": [{"path": "results/cells.csv", "sha256": sha(self.root / "results" / "cells.csv")}],
            "outputs": [{"path": "paper/p.tex", "sha256": sha(self.root / "paper" / "p.tex")}],
        }
        (self.root / "writer-manifest.json").write_text(json.dumps(manifest))
        self.commit("initial\n\nPaper: updated")

    def commit(self, message):
        git(self.root, "add", "-A")
        git(self.root, "commit", "-q", "-m", message)

    def state(self):
        return paper_freshness.freshness(self.root)


class FreshnessTests(unittest.TestCase):
    def test_current(self):
        s = Study()
        self.assertEqual(s.state()["state"], "current")

    def test_shared_context_is_draft(self):
        s = Study(context="shared")
        st = s.state()
        self.assertEqual(st["state"], "draft")
        self.assertIn("isolated writing pass", st["draft"][0])

    def test_changed_writer_input_is_stale(self):
        s = Study()
        (s.root / "results" / "cells.csv").write_text("a,b\n1,3\n")
        st = s.state()
        self.assertEqual(st["state"], "stale")
        self.assertIn("paper stale: writer input results/cells.csv changed", st["stale"])

    def test_changed_packet_input_is_stale(self):
        s = Study()
        (s.root / "REPLICATION-PLAN.yaml").write_text("parts: [x]\n")
        self.assertIn("paper stale: packet input REPLICATION-PLAN.yaml changed", s.state()["stale"])

    def test_rebuilt_packet_is_stale(self):
        s = Study()
        (s.root / "evidence-packet.json").write_text('{"artifacts": []}')
        self.assertTrue(any("evidence-packet.json changed after the paper" in e for e in s.state()["stale"]))

    def test_new_unread_evidence_is_stale(self):
        s = Study()
        (s.root / "results" / "new_test.json").write_text("{}")
        s.commit("new test\n\nPaper: pending")
        self.assertIn("paper stale: results/new_test.json is committed evidence the writer did not read",
                      s.state()["stale"])

    def test_paper_edited_after_manifest_is_stale(self):
        s = Study()
        (s.root / "paper" / "p.tex").write_text("paper, edited\n")
        self.assertTrue(any("paper output paper/p.tex changed" in e for e in s.state()["stale"]))

    def test_no_manifest_is_absent(self):
        s = Study()
        (s.root / "writer-manifest.json").unlink()
        self.assertEqual(s.state()["state"], "absent")


class TrailerTests(unittest.TestCase):
    def test_commit_without_trailer_fails(self):
        s = Study()
        base = subprocess.run(["git", "-C", str(s.root), "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
        (s.root / "results" / "cells.csv").write_text("a,b\n9,9\n")
        s.commit("rerun")
        errors = paper_freshness.commit_errors(s.root, base)
        self.assertEqual(len(errors), 1)
        self.assertIn("without a 'Paper:", errors[0])

    def test_trailers_and_paper_only_commits_pass(self):
        s = Study()
        base = subprocess.run(["git", "-C", str(s.root), "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
        (s.root / "results" / "cells.csv").write_text("a,b\n9,9\n")
        s.commit("rerun\n\nPaper: not-needed the rerun changes no printed number")
        (s.root / "results" / "cells.csv").write_text("a,b\n8,8\n")
        s.commit("rerun 2\n\nPaper: pending")
        (s.root / "paper" / "p.tex").write_text("revised\n")
        s.commit("revise paper")
        self.assertEqual(paper_freshness.commit_errors(s.root, base), [])

    def test_not_needed_requires_a_reason(self):
        s = Study()
        base = subprocess.run(["git", "-C", str(s.root), "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
        (s.root / "results" / "cells.csv").write_text("a,b\n9,9\n")
        s.commit("rerun\n\nPaper: not-needed")
        self.assertEqual(len(paper_freshness.commit_errors(s.root, base)), 1)


if __name__ == "__main__":
    unittest.main()
