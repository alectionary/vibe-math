"""The paper names no commits or branches of its own repository; links go to master."""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import commit_refs  # noqa: E402


def git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args], check=True, capture_output=True, text=True).stdout.strip()


class CommitRefs(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        git(self.root, "init", "-q", "-b", "master")
        git(self.root, "config", "user.email", "t@example.com")
        git(self.root, "config", "user.name", "t")
        git(self.root, "remote", "add", "origin", "https://github.com/own/repo.git")
        (self.root / "a.txt").write_text("a\n")
        git(self.root, "add", "-A")
        git(self.root, "commit", "-q", "-m", "a")
        self.sha = git(self.root, "rev-parse", "HEAD")
        git(self.root, "branch", "replication/study-2021")

    def errors(self, text):
        return commit_refs.commit_reference_errors(text, self.root)

    def test_clean_paper_passes(self):
        self.assertEqual(self.errors(
            "Code is at https://github.com/own/repo/blob/master/a.txt and "
            "https://github.com/own/repo/tree/master/study. Source SHA-256 "
            "9206b3d824077d36c86b4935ff7f19f64b3fdebde7746943b8a94500fe11e557. Seeds 18374788."), [])

    def test_commit_hash_full_or_short_fails(self):
        self.assertTrue(self.errors(f"The code revision is {self.sha}."))
        self.assertTrue(self.errors(f"Run at revision {self.sha[:9]}."))

    def test_unlabelled_40_hex_fails_but_labelled_file_hash_passes(self):
        self.assertTrue(self.errors("revision " + "ab12" * 10))
        self.assertEqual(self.errors("sha256 " + "ab12" * 10), [])

    def test_working_branch_named_fails(self):
        self.assertTrue(self.errors(r"on branch \texttt{replication/study-2021}"))

    def test_non_master_links_fail(self):
        for url in (f"https://github.com/own/repo/blob/{self.sha}/a.txt",
                    "https://github.com/own/repo/tree/replication/study-2021/x",
                    f"https://github.com/own/repo/commit/{self.sha}",
                    f"https://raw.githubusercontent.com/own/repo/{self.sha}/a.txt"):
            self.assertTrue(self.errors(url), url)

    def test_other_repositories_and_issue_links_pass(self):
        self.assertEqual(self.errors("https://github.com/other/x/commit/" + "c" * 40 + " sha256"), [])
        self.assertEqual(self.errors("https://github.com/own/repo/issues/92"), [])


if __name__ == "__main__":
    unittest.main()
