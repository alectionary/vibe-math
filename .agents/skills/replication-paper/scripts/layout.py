"""Page-1 layout against the shared preamble. Not a prose or science check.

A manuscript that inputs the shared approved preamble is measured against that
file and against page 1 of its PDF. Papers that keep a copied preamble are
left alone. Comparing an opted-in page with a reference paper in the series
is still required; these numbers do not judge whether the page looks finished.
"""
import importlib.util
import re
from pathlib import Path

_spec = importlib.util.spec_from_file_location(
    "research_title_page", Path(__file__).resolve().parents[4] / "scripts/release/title_page.py")
title_page = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(title_page)

MARGIN_IN = 0.82
TITLE_PT = 17.28  # \LARGE in the 11pt article class used by the preamble.


def preamble_file():
    return Path(__file__).resolve().parents[1] / 'assets' / 'approved-preamble.tex'


def uses_series_preamble(tex):
    """Only manuscripts that input the shared preamble are measured.

    Older papers keep their own copied preamble and ``\\maketitle``. They are
    not failed for declining this check.
    """
    return isinstance(tex, str) and bool(re.search(r'\\input\{[^}]*approved-preamble\.tex\}', tex))


def source_layout_errors(tex, tex_path=None):
    if not uses_series_preamble(tex):
        return []
    errors = []
    if '\\newgeometry' in tex:
        errors.append('layout: newgeometry overrides the shared preamble')
    if re.search(r'\\usepackage\s*\[[^\]]*margin\s*=\s*(?!0\.82\s*in)', tex):
        errors.append('layout: page margin must stay 0.82in from the shared preamble')
    if '\\maketitle' not in tex and not title_page.uses_template(tex):
        errors.append('layout: the series title block uses maketitle')
    matched = False
    expected = preamble_file().read_bytes()
    for raw in re.findall(r'\\input\{([^}]+)\}', tex):
        if not raw.replace('\\', '/').endswith('approved-preamble.tex'):
            continue
        matched = True
        if tex_path is None:
            continue
        resolved = (Path(tex_path).resolve().parent / raw).resolve()
        try:
            actual = resolved.read_bytes()
        except OSError:
            errors.append('layout: approved preamble input does not resolve')
            continue
        if actual != expected:
            errors.append('layout: input preamble differs from the shared approved preamble')
    if not matched:
        errors.append('layout: manuscript must input the shared approved preamble')
    return errors


def _spans(page):
    found = []
    for block in page.get_text('dict')['blocks']:
        if block.get('type') != 0:
            continue
        for line in block['lines']:
            for span in line['spans']:
                if span['text'].strip():
                    found.append(span)
    return found


def _body(spans, height):
    body = []
    for span in spans:
        text = span['text'].strip()
        if span['bbox'][1] > height - 48 and re.fullmatch(r'\d{1,3}', text):
            continue
        body.append(span)
    return body


def page1_geometry_errors(pdf_path):
    """Compare page 1 with the preamble's letter page, 0.82in block, and \\LARGE title."""
    try:
        import fitz
    except ImportError as exc:
        return ['layout: PyMuPDF unavailable; install scripts/requirements.txt']
    margin = MARGIN_IN * 72
    try:
        with fitz.open(pdf_path) as doc:
            if not doc.is_pdf or doc.needs_pass or not len(doc):
                return ['layout: unreadable PDF']
            page = doc[0]
            if abs(page.rect.width - 612) > 2 or abs(page.rect.height - 792) > 2:
                return ['layout: page 1 is not letter size']
            spans = _spans(page)
            body = _body(spans, page.rect.height)
            if not body:
                return ['layout: page 1 has no text']
            left = min(span['bbox'][0] for span in body)
            right_gap = page.rect.width - max(span['bbox'][2] for span in body)
            bottom_gap = page.rect.height - max(span['bbox'][3] for span in body)
            used = page.rect.width - left - right_gap
            text_width = page.rect.width - 2 * margin
            errors = []
            if left < margin - 3:
                errors.append('layout: page 1 text enters the left margin')
            if right_gap < margin - 3:
                errors.append('layout: page 1 text enters the right margin')
            if used > text_width + 6:
                errors.append('layout: page 1 text block is wider than the preamble')
            if used < text_width - 40:
                errors.append('layout: page 1 text does not use the preamble text block')
            if bottom_gap < margin - 12:
                errors.append('layout: page 1 text enters the bottom margin')
            titles = [span for span in body if span['size'] >= 16]
            if not titles:
                errors.append('layout: page 1 title is missing or smaller than the series title')
            else:
                for span in titles:
                    bold = 'BX' in span['font'] or 'Bold' in span['font']
                    if bold or abs(span['size'] - TITLE_PT) > 1.2:
                        errors.append('layout: page 1 title must use the preamble \\LARGE roman title')
                        break
                    mid = (span['bbox'][0] + span['bbox'][2]) / 2
                    if abs(mid - page.rect.width / 2) > 12:
                        errors.append('layout: page 1 title is not centered')
                        break
            abstract = [span for span in body if span['text'].strip() == 'Abstract']
            if not abstract:
                errors.append('layout: page 1 abstract heading is missing')
            else:
                label = abstract[0]
                band = [span for span in body if label['bbox'][3] + 1 < span['bbox'][1] < label['bbox'][3] + 40]
                if not band or min(span['bbox'][0] for span in band) < margin + 18:
                    errors.append('layout: abstract body is not inset from the text block')
            return errors
    except (OSError, RuntimeError, ValueError) as exc:
        return ['layout: page 1 geometry check failed: ' + type(exc).__name__]


def layout_errors(tex, tex_path=None, pdf_path=None):
    errors = source_layout_errors(tex, tex_path)
    if pdf_path is not None and uses_series_preamble(tex):
        errors.extend(page1_geometry_errors(pdf_path))
    return errors


def paper_pdf(paper_path):
    return title_page.exact_pdf(paper_path)


def title_errors(tex, source, pdf, required=False):
    if required or title_page.uses_template(tex):
        return title_page.check(source, pdf)
    return []
