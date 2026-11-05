"""Public routes and visual inspection are required before a source is called unavailable."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / 'scripts'))
import source_acquisition  # noqa: E402


def record(**updates):
    base = {
        'pdf_obtainable': True,
        'routes': [
            {'route': 'repository_record', 'target': 'https://example.edu/id/1', 'result': 'bibliographic record 200'},
            {'route': 'direct_pdf', 'target': 'https://example.edu/id/1/thesis.pdf', 'result': 'PDF 200'},
            {'route': 'institutional_repository', 'target': 'https://example.edu/eprint/1', 'result': 'same repository, PDF linked'},
            {'route': 'arxiv_or_author', 'target': 'https://arxiv.org/pdf/0000.00000', 'result': 'author manuscript, not the full dissertation'},
        ],
        'text_read': {'mode': 'text', 'done': True, 'source': 'sources/thesis.txt'},
        'rendered_pages_inspected': {'mode': 'visual', 'done': True, 'pages': [4, 12]},
        'headline_pages': [4, 12],
    }
    base.update(updates)
    return base


class Acquisition(unittest.TestCase):
    def test_unavailable_wording_requires_attempts_and_separate_inspection(self):
        paper = 'The thesis PDF was not retrieved and the source ink was not inspected.'
        self.assertTrue(source_acquisition.claims_source_unavailable(paper))
        self.assertTrue(any('public route' in item for item in source_acquisition.errors_for(None, paper)))
        self.assertFalse(source_acquisition.claims_source_unavailable('The Figure 2 setup was unavailable.'))
        incomplete = record()
        incomplete['routes'] = [item for item in incomplete['routes'] if item['route'] != 'direct_pdf']
        self.assertTrue(any('direct_pdf' in item for item in source_acquisition.errors_for(incomplete, paper)))
        copied = record()
        copied['rendered_pages_inspected'] = copied['text_read']
        self.assertTrue(any('separate records' in item for item in source_acquisition.errors_for(copied, 'The full text was read.')))

    def test_obtainable_pdf_requires_visual_coverage_before_merge(self):
        good = record()
        self.assertEqual(source_acquisition.errors_for(good, 'The full text was read and the rendered pages were inspected.'), [])
        skipped = record()
        skipped['rendered_pages_inspected'] = {'mode': 'visual', 'done': False, 'pages': []}
        self.assertTrue(any('visual inspection' in item for item in source_acquisition.errors_for(skipped, 'Pages were read as text.')))
        narrow = record()
        narrow['rendered_pages_inspected']['pages'] = [4]
        self.assertTrue(any('cover every headline' in item for item in source_acquisition.errors_for(narrow, 'Inspected page 4.')))
        denied = record(pdf_obtainable=False)
        denied['rendered_pages_inspected'] = {'mode': 'visual', 'done': False, 'pages': []}
        paper = 'The dissertation PDF was not retrieved.'
        self.assertEqual(source_acquisition.errors_for(denied, paper), [])

    def test_obtained_pdf_cannot_be_called_unavailable(self):
        paper = 'The source PDF bytes were not retrieved.'
        self.assertTrue(any('do not call the source' in item for item in source_acquisition.errors_for(record(), paper)))

    def test_done_reads_the_study_record(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'provenance').mkdir()
            (root / 'provenance' / 'source-acquisition.json').write_text(json.dumps(record()), encoding='utf-8')
            self.assertEqual(source_acquisition.acquisition_errors(root, 'The rendered pages were inspected.'), [])
            (root / 'provenance' / 'source-acquisition.json').write_text('{', encoding='utf-8')
            self.assertTrue(source_acquisition.acquisition_errors(root, 'No availability claim.'))


if __name__ == '__main__':
    unittest.main()
