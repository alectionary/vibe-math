"""Pre-merge HEAD checks are separate from live master fetches."""
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / 'scripts'))
import pdf_links  # noqa: E402
import preflight  # noqa: E402


class BranchTargets(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.git('init', '-q', '-b', 'master')
        self.git('config', 'user.email', 'test@example.com')
        self.git('config', 'user.name', 'Test')
        self.git('config', 'commit.gpgsign', 'false')
        (self.root / 'results.txt').write_text('alpha\nbeta\n', encoding='utf-8')
        (self.root / 'notes').mkdir()
        (self.root / 'notes' / 'readme.md').write_text('symbol target\n', encoding='utf-8')
        self.git('add', '.')
        self.git('commit', '-q', '-m', 'files')
        self.git('remote', 'add', 'origin', 'https://github.com/a/b.git')

    def git(self, *args):
        completed = subprocess.run(['git', '-C', str(self.root), *args], check=False, capture_output=True, text=True)
        self.assertEqual(completed.returncode, 0, completed.stderr)
        return completed

    def test_head_paths_anchors_and_symbols(self):
        good = 'See https://github.com/a/b/blob/master/results.txt#L1 and https://github.com/a/b/tree/master/notes.'
        wrapped = r'\href{https://github.com/a/b/blob/master/results.txt}{\path{results.txt}}'
        self.assertEqual(pdf_links.branch_target_errors(good, self.root), [])
        self.assertEqual(pdf_links.branch_target_errors(wrapped, self.root), [])
        missing = 'https://github.com/a/b/blob/master/missing.txt'
        self.assertTrue(any('not in HEAD' in item for item in pdf_links.branch_target_errors(missing, self.root)))
        swapped = 'https://github.com/a/b/tree/master/results.txt'
        self.assertTrue(any('expected tree' in item for item in pdf_links.branch_target_errors(swapped, self.root)))
        low = 'https://github.com/a/b/blob/master/results.txt#L9'
        self.assertTrue(any('outside' in item for item in pdf_links.branch_target_errors(low, self.root)))
        uri = 'https://github.com/a/b/blob/master/notes/readme.md#L1'
        inventory = {'links': [{'uri': uri, 'symbol': 'symbol'}]}
        self.assertEqual(pdf_links.branch_target_errors(uri, self.root, inventory=inventory), [])
        inventory['links'][0]['symbol'] = 'absent'
        self.assertTrue(pdf_links.branch_target_errors(uri, self.root, inventory=inventory))

    def test_other_repositories_and_live_master_are_not_premerge_failures(self):
        foreign = 'https://github.com/other/repo/blob/master/missing.txt'
        self.assertEqual(pdf_links.branch_target_errors(foreign, self.root), [])

    def test_post_merge_fetches_live_urls(self):
        class Response:
            status = 200
            def __init__(self, body=b'alpha\nbeta\n'):
                self.body = body
            def read(self):
                return self.body
            def __enter__(self):
                return self
            def __exit__(self, *args):
                return False
        seen = []
        def opener(url, timeout=20):
            seen.append(url)
            if url.endswith('missing.txt'):
                raise OSError('404')
            return Response()
        paper = 'https://github.com/a/b/blob/master/results.txt#L2'
        self.assertEqual(pdf_links.post_merge_errors(paper, 'a/b', opener=opener), [])
        self.assertTrue(any(url == 'https://github.com/a/b/blob/master/results.txt' for url in seen))
        self.assertTrue(any('raw.githubusercontent.com' in url for url in seen))
        bad = pdf_links.post_merge_errors('https://github.com/a/b/blob/master/missing.txt', 'a/b', opener=opener)
        self.assertTrue(bad)

    def test_done_wires_the_head_check_and_ignores_live_404(self):
        plan = (
            'schema_version: 1\n'
            'dissertation: "Example (2020). A dissertation. Example University."\n'
            'source_locator: sources/dissertation.pdf\n'
            'parts:\n'
            '- id: headline-result\n  kind: headline\n  label: Headline comparison\n'
            '  plan: Run every cell the headline conclusion uses.\n'
            '  status: replicated\n  evidence: results.txt\n'
            'removals: []\n'
            'published_evidence:\n'
            '- id: table-1\n  location: Table 1\n  quantity: headline estimate\n'
            '  value_source: table\n  plotted_in: []\n  agreement: agree\n'
            'source_items: []\n'
            'source_missing:\n  fetch_issue: 1\n  since: "2026-11-08"\n'
            '  reason: test study without a source PDF\n'
        )
        (self.root / 'REPLICATION-PLAN.yaml').write_text(plan, encoding='utf-8')
        self.git('add', 'REPLICATION-PLAN.yaml')
        self.git('commit', '-q', '-m', 'plan')
        paper = (
            '\\begin{abstract}\nWe replicated the headline result of Example (2020).\n\\end{abstract}\n'
            'https://github.com/a/b/blob/master/results.txt#L1\n'
        )
        (self.root / 'paper.tex').write_text(paper, encoding='utf-8')
        decision = preflight.done_check(self.root, 'REPLICATION-PLAN.yaml', 'paper.tex')
        self.assertEqual(decision['errors'], [], decision)
        self.assertEqual(decision['status'], 'incomplete', decision)
        (self.root / 'paper.tex').write_text(paper + 'https://github.com/a/b/blob/master/results.txt#L40\n', encoding='utf-8')
        decision = preflight.done_check(self.root, 'REPLICATION-PLAN.yaml', 'paper.tex')
        self.assertFalse(decision['accepted'])
        self.assertTrue(any('outside' in item for item in decision['errors']))


if __name__ == '__main__':
    unittest.main()
