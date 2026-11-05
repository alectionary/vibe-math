"""Record public source attempts before a paper calls a source or its pages unavailable.

Text that was read and pages that were visually inspected are different records.
Visual inspection of the pages that support headline and Published entries is a
pre-merge requirement whenever the PDF is obtainable. A completed route log does
not prove that a page means what the manuscript says.
"""
import json
import re
from pathlib import Path

ROUTES = ('repository_record', 'direct_pdf', 'institutional_repository', 'arxiv_or_author')
RECORD_NAME = 'provenance/source-acquisition.json'

# The source document or its pages, not an unreproduced experiment or a missing fit.
_UNAVAILABLE = re.compile(
    r'(?:source|thesis|dissertation)\s+(?:pdf|text|document|bytes?).{0,50}'
    r'(?:unavailable|not available|not retrieved|not bundled|could not be obtained)'
    r'|pdf\s+(?:bytes?|file|document|ink).{0,50}'
    r'(?:unavailable|not available|not retrieved|not bundled|were not retrieved|was not retrieved)'
    r'|unread\s+(?:source\s+)?(?:pdf|ink|pages?)'
    r'|(?:source|thesis|pdf)\s+ink\s+(?:was|were)\s+not\s+(?:retrieved|inspected|available)'
    r'|original bytes unavailable'
    r'|(?:could not|cannot)\s+(?:obtain|download|retrieve).{0,40}(?:pdf|thesis|dissertation)',
    re.I | re.S)


def claims_source_unavailable(paper):
    return isinstance(paper, str) and bool(_UNAVAILABLE.search(paper))


def _pages(value):
    return isinstance(value, list) and bool(value) and all(type(page) is int and page >= 1 for page in value)


def errors_for(record, paper):
    """Validate one acquisition record. `record` is an object or None when the file is missing."""
    errors = []
    unavailable = claims_source_unavailable(paper)
    if record is None:
        if unavailable:
            errors.append('acquisition: public route attempts must be recorded before calling the source or its pages unavailable')
        return errors
    if not isinstance(record, dict):
        return ['acquisition: record must be an object']
    attempts = record.get('routes')
    by_route = {}
    if not isinstance(attempts, list):
        errors.append('acquisition: routes list required')
        attempts = []
    for item in attempts:
        if not isinstance(item, dict) or item.get('route') not in ROUTES:
            errors.append('acquisition: each attempt needs a known route')
            continue
        route = item['route']
        if route in by_route:
            errors.append('acquisition: duplicate route ' + route)
        by_route[route] = item
        if not isinstance(item.get('target'), str) or not item['target'].strip():
            errors.append('acquisition: ' + route + ' target required')
        result = item.get('result')
        if not isinstance(result, str) or not result.strip() or result.strip().lower() in ('not attempted', 'skipped', 'todo'):
            errors.append('acquisition: ' + route + ' result required')
    for route in ROUTES:
        if route not in by_route:
            errors.append('acquisition: missing attempt ' + route)
    text_read = record.get('text_read')
    rendered = record.get('rendered_pages_inspected')
    if text_read is not None and rendered is not None and text_read == rendered:
        errors.append('acquisition: text read and rendered-page inspection must be separate records')
    if not isinstance(text_read, dict) or text_read.get('mode') != 'text' or text_read.get('done') is not True:
        errors.append('acquisition: text_read must record done text reading, separately from visual inspection')
    obtainable = record.get('pdf_obtainable')
    if obtainable is True:
        if unavailable:
            errors.append('acquisition: PDF was obtained; do not call the source or its pages unavailable')
        if not isinstance(rendered, dict) or rendered.get('mode') != 'visual' or rendered.get('done') is not True:
            errors.append('acquisition: visual inspection of headline and Published pages is required before merge')
        pages = rendered.get('pages') if isinstance(rendered, dict) else None
        needed = record.get('headline_pages')
        if not _pages(needed):
            errors.append('acquisition: headline_pages required when the PDF is obtainable')
        elif not _pages(pages) or not set(needed).issubset(set(pages)):
            errors.append('acquisition: inspected pages must cover every headline and Published support page')
    elif obtainable is False:
        if not isinstance(rendered, dict) or rendered.get('mode') != 'visual' or rendered.get('done') is not False:
            errors.append('acquisition: record that rendered pages were not inspected when the PDF was not obtained')
    else:
        errors.append('acquisition: pdf_obtainable boolean required')
    return errors


def load(root):
    path = Path(root) / RECORD_NAME
    if not path.is_file():
        return None
    try:
        return json.loads(path.read_text(encoding='utf-8'))
    except (OSError, UnicodeError, ValueError):
        return {'_unreadable': True}


def acquisition_errors(root, paper):
    record = load(root)
    if isinstance(record, dict) and record.get('_unreadable'):
        return ['acquisition: provenance/source-acquisition.json is unreadable']
    if record is None and not claims_source_unavailable(paper or ''):
        return []
    return errors_for(record, paper or '')
