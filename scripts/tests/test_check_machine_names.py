"""The staged-file machine-hostname check."""

import gzip
import io
import os
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "check_machine_names.py"
sys.path.insert(0, str(SCRIPT.parent))
import check_machine_names as names  # noqa: E402

LABEL_A = "Mac" + "Book"
LABEL_B = "i" + "Mac"
LABEL_C = "Mac" + "-mini"
LABEL_D = "Mac" + " mini"
LABEL_E = "Mac" + "mini"
LOCAL = ".local"


def host_token() -> str:
    return "Desk-" + LABEL_A + LOCAL


def git(root, *args, env=None):
    return subprocess.run(
        ["git", "-C", str(root), *args],
        check=False,
        capture_output=True,
        text=True,
        env=env,
    )


class Matcher(unittest.TestCase):
    def test_banner_and_machine_names_fail(self):
        banner = (
            "c Mon Oct 26 19:48:48 PDT 2026 Darwin " + host_token() + " 27.0.0 arm64\n"
        ).encode()
        hits = names.scan_bytes("solver.log", banner)
        self.assertEqual(len(hits), 1, hits)
        self.assertIn(host_token(), hits[0])
        self.assertIn(":1:", hits[0])

        for text in (LABEL_A, "Office-" + LABEL_B, LABEL_C, LABEL_D, LABEL_E, "my-host" + LOCAL):
            hits = names.scan_bytes("notes.txt", (text + "\n").encode())
            self.assertTrue(hits, text)

    def test_code_dimacs_and_git_range_pass(self):
        samples = [
            "self.local = 1\n",
            "producer.local_score(mask)\n",
            "sf.local\n",
            "FourColumnClassification.local\n",
            "Bicycle.Family.local\n",
            "An update uses remote..local.\n",
            "parsed a DIMACS file\n",
            "plain" + LOCAL + "\n",
        ]
        for text in samples:
            self.assertEqual(names.scan_bytes("code.py", text.encode()), [], text)

    def test_email_domain_without_a_hyphen_fails(self):
        text = "write to user@plain" + LOCAL + "\n"
        hits = names.scan_bytes("note.md", text.encode())
        self.assertEqual(len(hits), 1, hits)
        self.assertIn("plain" + LOCAL, hits[0])

    def test_gzip_and_zip_members_are_scanned(self):
        banner = ("Darwin " + host_token() + " arm64\n").encode()
        hits = names.scan_bytes("run.log.gz", gzip.compress(banner))
        self.assertTrue(any("(gzip)" in hit and host_token() in hit for hit in hits), hits)
        buffer = io.BytesIO()
        with zipfile.ZipFile(buffer, "w") as archive:
            archive.writestr("solver.log", banner)
        hits = names.scan_bytes("artifact.zip", buffer.getvalue())
        self.assertTrue(any("zip:solver.log" in hit for hit in hits), hits)

    def test_doc_tokens_and_span_allowlist(self):
        self.assertEqual(names.scan_bytes("CONTRIBUTING.md", (LABEL_A + "\n").encode()), [])
        self.assertEqual(names.scan_bytes("AGENTS.md", (LABEL_B + "\n").encode()), [])
        self.assertEqual(names.scan_bytes("README.md", (LABEL_C + "\n").encode()), [])
        longer = names.scan_bytes("CONTRIBUTING.md", ("Desk-" + LABEL_A + "\n").encode())
        self.assertTrue(longer, longer)
        plain = names.scan_bytes("notes.txt", (LABEL_A + "\n").encode())
        self.assertTrue(plain, plain)

        excerpt = "quoted " + ("Desk-" + LABEL_A) + " example"
        payload = (excerpt + "\n" + ("Desk-" + LABEL_A) + "\n").encode()
        original = names.SPAN_EXEMPTIONS
        names.SPAN_EXEMPTIONS = (("notes.txt", excerpt),)
        try:
            hits = names.scan_bytes("notes.txt", payload)
        finally:
            names.SPAN_EXEMPTIONS = original
        self.assertEqual(len(hits), 1, hits)
        self.assertIn("Desk-" + LABEL_A, hits[0])
        self.assertNotIn("quoted", hits[0])

    def test_remote_dot_local_excerpt_is_allowlisted(self):
        self.assertIn(
            ("scripts/check_commit_emails.py", "remote..local"),
            names.SPAN_EXEMPTIONS,
        )
        text = (ROOT / "scripts" / "check_commit_emails.py").read_bytes()
        self.assertEqual(names.scan_bytes("scripts/check_commit_emails.py", text), [])


def place_hooks(root: Path):
    scripts = root / "scripts"
    scripts.mkdir()
    shutil.copy(ROOT / "scripts" / "check_commit_emails.py", scripts / "check_commit_emails.py")
    shutil.copy(SCRIPT, scripts / "check_machine_names.py")
    shutil.copytree(ROOT / ".githooks", root / ".githooks")


def init_repo(root: Path):
    completed = git(root, "init", "-q", "-b", "master")
    if completed.returncode != 0:
        raise AssertionError(completed.stderr)
    for args in (
        ("config", "user.name", "alectionary"),
        ("config", "user.email", "alectionary@users.noreply.github.com"),
        ("config", "commit.gpgsign", "false"),
        ("config", "core.hooksPath", ".githooks"),
    ):
        completed = git(root, *args)
        if completed.returncode != 0:
            raise AssertionError(completed.stderr)


class HookAndCi(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name) / "repo"
        self.root.mkdir()
        init_repo(self.root)
        place_hooks(self.root)

    def commit(self, message, filename="notes.txt", content=None, verify=True):
        path = self.root / filename
        path.write_text(content if content is not None else message + "\n", encoding="utf-8")
        git(self.root, "add", filename)
        cmd = [
            "git",
            "-C",
            str(self.root),
            "-c",
            "user.email=alectionary@users.noreply.github.com",
            "-c",
            "user.name=alectionary",
            "-c",
            "commit.gpgsign=false",
            "commit",
            "-m",
            message,
        ]
        if not verify:
            cmd.append("--no-verify")
        return subprocess.run(cmd, check=False, capture_output=True, text=True)

    def test_hook_is_executable_and_rejects_then_accepts(self):
        mode = os.stat(ROOT / ".githooks" / "pre-commit").st_mode
        self.assertTrue(mode & stat.S_IXUSR)
        blocked = self.commit("record a banner", filename="solver.log", content="Darwin " + host_token() + "\n")
        self.assertNotEqual(blocked.returncode, 0, blocked.stdout + blocked.stderr)
        self.assertIn(host_token(), blocked.stderr)
        self.assertEqual(git(self.root, "rev-parse", "--verify", "HEAD").returncode, 128)

        allowed = self.commit("record a result", filename="solver.log", content="self.local = 1\n")
        self.assertEqual(allowed.returncode, 0, allowed.stderr)

    def test_ci_ignores_an_unchanged_published_file(self):
        seeded = self.commit(
            "already published",
            filename="old.log",
            content="Darwin " + host_token() + "\n",
            verify=False,
        )
        self.assertEqual(seeded.returncode, 0, seeded.stderr)
        published = git(self.root, "rev-parse", "HEAD").stdout.strip()
        added = self.commit("new work", filename="notes.txt", content="no machine name\n")
        self.assertEqual(added.returncode, 0, added.stderr)
        head = git(self.root, "rev-parse", "HEAD").stdout.strip()
        env = os.environ.copy()
        env.update(
            {
                "GITHUB_EVENT_NAME": "pull_request",
                "PR_BASE": published,
                "PR_HEAD": head,
                "DEFAULT_BRANCH": "master",
            }
        )
        completed = subprocess.run(
            [sys.executable, str(SCRIPT), "ci", "--repo", str(self.root)],
            check=False,
            capture_output=True,
            text=True,
            env=env,
        )
        self.assertEqual(completed.returncode, 0, completed.stdout + completed.stderr)
        self.assertIn("checked 1 file", completed.stdout)
        self.assertNotIn(host_token(), completed.stderr)

        leaked = self.commit(
            "touch the old log",
            filename="old.log",
            content="Darwin " + host_token() + "\nstill here\n",
        )
        self.assertNotEqual(leaked.returncode, 0, leaked.stdout + leaked.stderr)


class WorkflowFile(unittest.TestCase):
    def test_workflow_runs_the_checker_on_the_same_range(self):
        text = (ROOT / ".github/workflows/commit-email-domains.yml").read_text(encoding="utf-8")
        self.assertIn("scripts/check_machine_names.py ci", text)
        self.assertIn("PR_BASE:", text)
        self.assertIn("PUSH_BEFORE:", text)


if __name__ == "__main__":
    unittest.main()
