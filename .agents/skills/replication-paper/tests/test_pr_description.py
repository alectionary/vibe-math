"""PR descriptions must link the recorded primary PDF twice."""
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / 'scripts'))
import pr_description  # noqa: E402

PDF = 'formalization/example-study/paper/finite_audit.pdf'
SHA = '8367ea10b34ec6628866805892b340620328de9f'
REPO = 'alectionary/vibe-math'


def record():
    return {'repository': REPO, 'primary': {'path': 'paper/finite_audit.pdf', 'role': 'manuscript'}}


def link(ref):
    return f'https://github.com/{REPO}/blob/{ref}/{PDF}'


def study(tmp):
    root = Path(tmp)
    subprocess.check_call(['git', 'init', '-q', str(root)])
    study_dir = root / 'formalization' / 'example-study'
    paper = study_dir / 'paper'
    paper.mkdir(parents=True)
    (paper / 'finite_audit.pdf').write_bytes(b'%PDF-1.4\n')
    return study_dir


class Description(unittest.TestCase):
    def test_sha_pin_and_master_link_pass(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            body = f'Review the built paper: {link(SHA)}\n\nLive after merge: {link("master")}\n'
            self.assertEqual(pr_description.description_errors(body, record(), root), [])

    def test_head_branch_pin_passes_when_named(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            branch = 'cursor/example-paper-d2e8'
            body = f'{link(branch)}\nLive after merge: {link("master")}\n'
            self.assertEqual(
                pr_description.description_errors(body, record(), root, head_branch=branch), [])
            self.assertTrue(any(
                'reviewable' in item
                for item in pr_description.description_errors(body, record(), root)))

    def test_missing_reviewable_or_master_link_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            only_master = pr_description.description_errors(link('master'), record(), root)
            self.assertEqual(only_master, ['pr: reviewable primary PDF link required'])
            only_sha = pr_description.description_errors(link(SHA), record(), root)
            self.assertEqual(only_sha, ['pr: master primary PDF link required'])

    def test_path_must_match_the_recorded_primary_pdf(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            other = link(SHA).replace('finite_audit.pdf', 'notes.pdf')
            master = link('master').replace('finite_audit.pdf', 'notes.pdf')
            errors = pr_description.description_errors(other + '\n' + master, record(), root)
            self.assertIn('pr: reviewable primary PDF link required', errors)
            self.assertIn('pr: master primary PDF link required', errors)

    def test_other_repository_and_short_sha_do_not_count(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            body = (
                f'https://github.com/other/repo/blob/{SHA}/{PDF}\n'
                f'https://github.com/{REPO}/blob/{SHA[:12]}/{PDF}\n'
                f'{link("master")}\n')
            self.assertEqual(
                pr_description.description_errors(body, record(), root),
                ['pr: reviewable primary PDF link required'])

    def test_cli_reads_a_file_and_stdin(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            record_path = root / 'delivery.json'
            record_path.write_text(json.dumps(record()), encoding='utf-8')
            body = f'{link(SHA)}\nLive after merge: {link("master")}\n'
            body_path = root / 'pr.md'
            body_path.write_text(body, encoding='utf-8')
            script = SKILL / 'scripts' / 'pr_description.py'
            command = [sys.executable, str(script), '--record', str(record_path), '--root', str(root)]
            from_file = subprocess.run(command + ['--body', str(body_path)], capture_output=True, text=True)
            self.assertEqual(from_file.returncode, 0, from_file.stdout + from_file.stderr)
            self.assertTrue(json.loads(from_file.stdout)['accepted'])
            from_stdin = subprocess.run(command, input='no links\n', capture_output=True, text=True)
            self.assertEqual(from_stdin.returncode, 2)
            self.assertFalse(json.loads(from_stdin.stdout)['accepted'])

    def test_preflight_and_delivery_check_accept_the_body_as_optional_input(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = study(tmp)
            body_path = root / 'pr.md'
            body_path.write_text('no links\n', encoding='utf-8')
            record_path = root / 'delivery.json'
            record_path.write_text(json.dumps(record()), encoding='utf-8')
            preflight = subprocess.run(
                [sys.executable, str(SKILL / 'scripts' / 'preflight.py'), 'done',
                 '--plan', 'REPLICATION-PLAN.yaml', '--paper', 'paper/finite_audit.pdf',
                 '--root', str(root), '--pr-body', str(body_path), '--record', str(record_path)],
                capture_output=True, text=True)
            self.assertEqual(preflight.returncode, 2, preflight.stdout + preflight.stderr)
            decision = json.loads(preflight.stdout)
            self.assertIn('pr: reviewable primary PDF link required', decision['errors'])
            self.assertFalse(decision['accepted'])
            delivery = subprocess.run(
                [sys.executable, str(SKILL / 'scripts' / 'delivery_check.py'), str(record_path),
                 '--root', str(root), '--pr-body', str(body_path)],
                capture_output=True, text=True)
            self.assertNotEqual(delivery.returncode, 0)
            self.assertIn('pr: reviewable primary PDF link required', json.loads(delivery.stdout)['errors'])


if __name__ == '__main__':
    unittest.main()
