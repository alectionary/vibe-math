"""The shared preamble and page-1 geometry are checked apart from the science."""
import sys
import tempfile
import unittest
from pathlib import Path

import fitz

SKILL = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL / 'scripts'))
import layout  # noqa: E402

PREAMBLE = (SKILL / 'assets' / 'approved-preamble.tex').read_text(encoding='utf-8')


def article(extra):
    return PREAMBLE + extra


class SourceLayout(unittest.TestCase):
    def test_shared_preamble_and_maketitle_pass(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'approved-preamble.tex').write_text(PREAMBLE, encoding='utf-8')
            tex_path = root / 'paper.tex'
            tex_path.write_text(
                '\\input{approved-preamble.tex}\n\\title{A title}\n\\date{3 November 2026}\n'
                '\\begin{document}\\maketitle\\begin{abstract}Verdict.\\end{abstract}\\end{document}\n',
                encoding='utf-8')
            self.assertEqual(layout.source_layout_errors(tex_path.read_text(encoding='utf-8'), tex_path), [])

    def test_plan_fixture_without_a_title_is_not_a_layout_paper(self):
        tex = '\\documentclass{article}\n\\begin{document}\\begin{abstract}We replicated the headline.\\end{abstract}\\end{document}\n'
        self.assertEqual(layout.source_layout_errors(tex), [])

    def test_narrow_geometry_and_a_pasted_preamble_fail(self):
        tex = article('\n\\newgeometry{margin=0.55in}\n\\begin{document}{\\Large\\bfseries Title}\\end{document}\n')
        errors = layout.source_layout_errors(tex)
        self.assertTrue(any('newgeometry' in item for item in errors))
        self.assertTrue(any('maketitle' in item for item in errors))
        self.assertTrue(any('must input' in item for item in errors))

    def test_divergent_preamble_file_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'approved-preamble.tex').write_text(PREAMBLE.replace('0.82in', '0.55in'), encoding='utf-8')
            tex_path = root / 'paper.tex'
            tex_path.write_text('\\input{approved-preamble.tex}\n\\title{T}\n\\begin{document}\\maketitle\\end{document}\n', encoding='utf-8')
            self.assertTrue(any('differs' in item for item in layout.source_layout_errors(tex_path.read_text(encoding='utf-8'), tex_path)))


def _page(path, left, title_size, title_font, abstract_x):
    with fitz.open() as doc:
        page = doc.new_page(width=612, height=792)
        font = fitz.Font(title_font)
        title = 'A replication title'
        width = font.text_length(title, fontsize=title_size)
        page.insert_text(((612 - width) / 2, 120), title, fontsize=title_size, fontname=title_font)
        page.insert_text((280, 250), 'Abstract', fontsize=10, fontname='tibo')
        page.insert_text((abstract_x, 275), 'We replicated the headline result on this opening page.', fontsize=10, fontname='tiro')
        rule = 'm'
        body = fitz.Font('tiro')
        while body.text_length(rule, fontsize=10) < 612 - left - 70:
            rule += 'm'
        page.insert_text((left, 420), rule, fontsize=10, fontname='tiro')
        page.insert_text((300, 760), '1', fontsize=10, fontname='tiro')
        doc.save(path)


class PageGeometry(unittest.TestCase):
    def test_series_margins_and_title_pass(self):
        with tempfile.TemporaryDirectory() as tmp:
            pdf = Path(tmp) / 'paper.pdf'
            _page(pdf, 59, 17.2, 'tiro', 101)
            self.assertEqual(layout.page1_geometry_errors(pdf), [])

    def test_narrow_page_and_small_bold_title_fail(self):
        with tempfile.TemporaryDirectory() as tmp:
            pdf = Path(tmp) / 'paper.pdf'
            _page(pdf, 39, 14.4, 'tibo', 67)
            errors = layout.page1_geometry_errors(pdf)
            self.assertTrue(any('left margin' in item or 'wider' in item for item in errors), errors)
            self.assertTrue(any('title' in item for item in errors), errors)


if __name__ == '__main__':
    unittest.main()
