"""Positive and negative cases for the consumer-domain commit checker."""

import os
import shutil
import stat
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / "scripts" / "check_commit_emails.py"
sys.path.insert(0, str(SCRIPT.parent))
import check_commit_emails as checker  # noqa: E402


BLOCKED = [
    "someone@gmail.com",
    "someone@googlemail.com",
    "someone@hotmail.com",
    "someone@hotmail.co.uk",
    "someone@outlook.com",
    "someone@outlook.co.uk",
    "someone@live.com",
    "someone@live.co.uk",
    "someone@msn.com",
    "someone@yahoo.com",
    "someone@yahoo.co.jp",
    "someone@mail.yahoo.com",
    "someone@icloud.com",
    "someone@me.com",
    "someone@aol.com",
    "someone@proton.me",
    "someone@protonmail.com",
    "Someone@Gmail.COM",
    "someone@mail.gmail.com",
]

ALLOWED = [
    "alectionary@users.noreply.github.com",
    "12345678+alectionary@users.noreply.github.com",
    "noreply@github.com",
    "noreply@gmail.com",
    "noreply+bot@outlook.com",
    "someone@example.com",
    "someone@example.org",
    "someone@notgmail.com",
    "someone@livejournal.com",
    "someone@yahoo-inc.com",
    "someone@protonmail.ch",
    "someone@pm.me",
    "someone@users.noreply.github.com",
]


def git(root, *args, env=None):
    completed = subprocess.run(
        ["git", "-C", str(root), *args],
        check=False,
        capture_output=True,
        text=True,
        env=env,
    )
    return completed


class Domains(unittest.TestCase):
    def test_blocked_examples(self):
        for email in BLOCKED:
            self.assertTrue(checker.is_blocked_email(email), email)

    def test_allowed_examples(self):
        for email in ALLOWED:
            self.assertFalse(checker.is_blocked_email(email), email)

    def test_longer_labels_are_not_wildcards(self):
        self.assertFalse(checker.is_consumer_domain("livejournal.com"))
        self.assertFalse(checker.is_consumer_domain("notgmail.com"))
        self.assertFalse(checker.is_consumer_domain("yahoo-inc.com"))
        self.assertTrue(checker.is_consumer_domain("hotmail.co.uk"))
        self.assertTrue(checker.is_consumer_domain("mail.yahoo.com"))

    def test_noreply_local_part_overrides_a_consumer_domain(self):
        self.assertTrue(checker.is_noreply("noreply@gmail.com"))
        self.assertTrue(checker.is_noreply("NoReply+x@outlook.com"))
        self.assertFalse(checker.is_noreply("someone+noreply@gmail.com"))
        self.assertTrue(checker.is_noreply("noreply@github.com"))
        self.assertTrue(checker.is_noreply("7+name@users.noreply.github.com"))


class Messages(unittest.TestCase):
    def test_trailers_and_body(self):
        message = textwrap.dedent(
            """\
            Fix the widget

            Details are in the notes. Reach someone@gmail.com if needed.

            Co-authored-by: Sam <someone@yahoo.com>
            Signed-off-by: Sam <someone@outlook.com>
            See also someone@proton.me.
            """
        )
        hits = checker.message_hits(message)
        self.assertEqual(
            [(kind, email) for kind, email, _line in hits],
            [
                ("message", "someone@gmail.com"),
                ("trailer", "someone@yahoo.com"),
                ("trailer", "someone@outlook.com"),
                ("message", "someone@proton.me"),
            ],
        )

    def test_noreply_trailers_and_web_merge_committer_pass(self):
        message = textwrap.dedent(
            """\
            Merge pull request #6 from example/branch

            Co-authored-by: alectionary <alectionary@users.noreply.github.com>
            Signed-off-by: GitHub <noreply@github.com>
            """
        )
        errors = checker.commit_errors(
            "this commit",
            "person@example.com",
            "noreply@github.com",
            message,
        )
        self.assertEqual(errors, [])

    def test_duplicate_address_is_reported_once(self):
        message = "See someone@gmail.com and also someone@gmail.com."
        self.assertEqual(len(checker.message_hits(message)), 1)

    def test_ident_parsing(self):
        ident = "A U Thor <someone@gmail.com> 1112911993 -0700"
        self.assertEqual(checker.email_from_ident(ident), "someone@gmail.com")
        with self.assertRaises(checker.CheckerError):
            checker.email_from_ident("no address here")


class CommandLine(unittest.TestCase):
    def run_commit_msg(self, message, author, committer):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "COMMIT_EDITMSG"
            path.write_text(message, encoding="utf-8")
            return subprocess.run(
                [
                    sys.executable,
                    str(SCRIPT),
                    "commit-msg",
                    "--message-file",
                    str(path),
                    "--author-ident",
                    author,
                    "--committer-ident",
                    committer,
                ],
                check=False,
                capture_output=True,
                text=True,
            )

    def test_commit_msg_rejects_author_and_allows_noreply_committer(self):
        failed = self.run_commit_msg(
            "A clean message\n",
            "A <someone@gmail.com> 0 +0000",
            "GitHub <noreply@github.com> 0 +0000",
        )
        self.assertEqual(failed.returncode, 1, failed.stdout + failed.stderr)
        self.assertIn("author email", failed.stderr)
        self.assertIn("someone@gmail.com", failed.stderr)

        passed = self.run_commit_msg(
            "Co-authored-by: alectionary <alectionary@users.noreply.github.com>\n",
            "A <alectionary@users.noreply.github.com> 0 +0000",
            "GitHub <noreply@github.com> 0 +0000",
        )
        self.assertEqual(passed.returncode, 0, passed.stderr)
        self.assertEqual(passed.stderr, "")

    def test_commit_msg_rejects_a_body_address(self):
        failed = self.run_commit_msg(
            "Notes mention someone@proton.me.\n",
            "A <person@example.com> 0 +0000",
            "A <person@example.com> 0 +0000",
        )
        self.assertEqual(failed.returncode, 1)
        self.assertIn("message contains", failed.stderr)
        self.assertIn("someone@proton.me", failed.stderr)


def place_hooks(root: Path):
    scripts = root / "scripts"
    scripts.mkdir()
    shutil.copy(SCRIPT, scripts / "check_commit_emails.py")
    hooks = root / ".githooks"
    shutil.copytree(ROOT / ".githooks", hooks)
    skill_scripts = ROOT / ".agents/skills/replication-paper/scripts"
    paper_dst = root / ".agents/skills/replication-paper/scripts/hooks/pre-push"
    paper_dst.parent.mkdir(parents=True)
    shutil.copy(skill_scripts / "hooks" / "pre-push", paper_dst)
    shutil.copy(skill_scripts / "paper_freshness.py", paper_dst.parent.parent / "paper_freshness.py")
    os.chmod(paper_dst, os.stat(paper_dst).st_mode | stat.S_IEXEC)


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


class HooksAndRanges(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name) / "repo"
        self.root.mkdir()
        init_repo(self.root)
        place_hooks(self.root)

    def commit(self, message, email="alectionary@users.noreply.github.com", verify=True):
        path = self.root / "notes.txt"
        path.write_text(message + "\n", encoding="utf-8")
        git(self.root, "add", "notes.txt")
        cmd = [
            "git",
            "-C",
            str(self.root),
            "-c",
            f"user.email={email}",
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

    def test_hooks_are_executable(self):
        for name in ("commit-msg", "pre-push"):
            mode = os.stat(ROOT / ".githooks" / name).st_mode
            self.assertTrue(mode & stat.S_IXUSR, name)

    def test_commit_msg_hook_rejects_then_accepts(self):
        blocked = self.commit("use a consumer mailbox", email="someone@gmail.com")
        self.assertNotEqual(blocked.returncode, 0, blocked.stdout + blocked.stderr)
        self.assertIn("someone@gmail.com", blocked.stderr)
        self.assertEqual(git(self.root, "rev-parse", "--verify", "HEAD").returncode, 128)

        body = self.commit(
            "body mentions someone@aol.com",
            email="alectionary@users.noreply.github.com",
        )
        self.assertNotEqual(body.returncode, 0)
        self.assertIn("someone@aol.com", body.stderr)

        allowed = self.commit("record the placeholder identity")
        self.assertEqual(allowed.returncode, 0, allowed.stderr)
        author = git(self.root, "log", "-1", "--format=%ae").stdout.strip()
        self.assertEqual(author, "alectionary@users.noreply.github.com")

    def test_pre_push_ignores_published_history_and_blocks_a_new_consumer_commit(self):
        bare = Path(self.tmp.name) / "remote.git"
        subprocess.run(
            ["git", "init", "-q", "--bare", "-b", "master", str(bare)],
            check=True,
        )
        seeded = self.commit("old published commit", email="someone@gmail.com", verify=False)
        self.assertEqual(seeded.returncode, 0, seeded.stderr)
        git(self.root, "remote", "add", "origin", str(bare))
        pushed = git(self.root, "push", "--no-verify", "-u", "origin", "master")
        self.assertEqual(pushed.returncode, 0, pushed.stderr)

        good = self.commit("a new allowed commit")
        self.assertEqual(good.returncode, 0, good.stderr)
        update = git(self.root, "push", "origin", "master")
        self.assertEqual(update.returncode, 0, update.stderr)
        self.assertIn("checked 1 commit", update.stdout)

        feature = git(self.root, "checkout", "-q", "-b", "feature")
        self.assertEqual(feature.returncode, 0, feature.stderr)
        added = self.commit("branch commit")
        self.assertEqual(added.returncode, 0, added.stderr)
        new_branch = git(self.root, "push", "-u", "origin", "feature")
        self.assertEqual(new_branch.returncode, 0, new_branch.stderr)
        self.assertIn("checked 1 commit", new_branch.stdout)

        bad = self.commit("slipped through commit-msg", email="someone@yahoo.com", verify=False)
        self.assertEqual(bad.returncode, 0, bad.stderr)
        denied = git(self.root, "push", "origin", "feature")
        self.assertNotEqual(denied.returncode, 0)
        self.assertIn("someone@yahoo.com", denied.stderr)
        self.assertNotIn("someone@gmail.com", denied.stderr)

    def test_ci_ranges_skip_old_history(self):
        self.commit("already on the default branch", email="someone@hotmail.com", verify=False)
        published = git(self.root, "rev-parse", "HEAD").stdout.strip()
        branched = git(self.root, "checkout", "-q", "-b", "feature")
        self.assertEqual(branched.returncode, 0, branched.stderr)
        self.commit("new work")
        head = git(self.root, "rev-parse", "HEAD").stdout.strip()
        zero = "0" * 40

        resolved = checker.resolve_ci_range(
            str(self.root),
            "pull_request",
            pr_base=published,
            pr_head=head,
        )
        self.assertEqual(resolved, (published, head))
        errors = checker.check_shas(
            str(self.root), checker.rev_list(str(self.root), f"{published}..{head}")
        )
        self.assertEqual(errors, [])

        new_branch = checker.resolve_ci_range(
            str(self.root),
            "push",
            push_before=zero,
            push_after=head,
            default_branch="master",
        )
        base, after = new_branch
        shas = checker.rev_list(str(self.root), f"{base}..{after}")
        self.assertEqual(shas, [head])
        self.assertEqual(checker.check_shas(str(self.root), shas), [])

        incremental = checker.resolve_ci_range(
            str(self.root),
            "push",
            push_before=published,
            push_after=head,
            default_branch="master",
        )
        self.assertEqual(incremental, (published, head))
        self.assertIsNone(
            checker.resolve_ci_range(
                str(self.root),
                "push",
                push_before=head,
                push_after=zero,
                default_branch="master",
            )
        )

    def test_ci_command_flags_only_the_new_commit(self):
        self.commit("published", email="someone@icloud.com", verify=False)
        published = git(self.root, "rev-parse", "HEAD").stdout.strip()
        self.commit("incoming", email="someone@me.com", verify=False)
        incoming = git(self.root, "rev-parse", "HEAD").stdout.strip()
        env = os.environ.copy()
        env.update(
            {
                "GITHUB_EVENT_NAME": "pull_request",
                "PR_BASE": published,
                "PR_HEAD": incoming,
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
        self.assertEqual(completed.returncode, 1, completed.stdout + completed.stderr)
        self.assertIn("someone@me.com", completed.stderr)
        self.assertNotIn("someone@icloud.com", completed.stderr)
        self.assertIn("across 1 commit", completed.stderr)


class WorkflowFile(unittest.TestCase):
    def test_workflow_triggers_and_calls_the_checker(self):
        text = (ROOT / ".github/workflows/commit-email-domains.yml").read_text(encoding="utf-8")
        self.assertIn("pull_request:", text)
        self.assertIn("push:", text)
        self.assertIn("scripts/check_commit_emails.py ci", text)
        self.assertIn("PR_BASE:", text)
        self.assertIn("PUSH_BEFORE:", text)


if __name__ == "__main__":
    unittest.main()
