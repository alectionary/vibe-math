"""Extract retrieved expansion sources; keep copyrighted full texts in ignored storage.

Run after restoring the retrievals listed in literature/scholarly-expansion-retrievals.json.
HTML equations use their alttext rather than duplicate MathML renderings. Line references
in the inventory refer to this extraction, not to publisher HTML line numbers.
"""
from html.parser import HTMLParser
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parent.parent


class ArticleText(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
        self.skip = 0

    def handle_starttag(self, tag, attrs):
        if tag in ('script', 'style', 'math', 'svg'):
            if tag == 'math' and not self.skip:
                self.parts.append(dict(attrs).get('alttext', ''))
            self.skip += 1
        if not self.skip and tag in ('p', 'div', 'section', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'tr'):
            self.parts.append('\n')

    def handle_endtag(self, tag):
        if tag in ('script', 'style', 'math', 'svg'):
            self.skip = max(0, self.skip - 1)
        if not self.skip and tag in ('p', 'div', 'section', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'tr'):
            self.parts.append('\n')

    def handle_data(self, data):
        if not self.skip:
            self.parts.append(data)


def extract(record):
    path = ROOT / record['local_file']
    if path.suffix == '.pdf':
        from pypdf import PdfReader
        text = '\n'.join(f'PDF PAGE {i}\n{page.extract_text() or ""}'
                         for i, page in enumerate(PdfReader(path).pages, 1))
    else:
        parser = ArticleText()
        parser.feed(path.read_text())
        text = ''.join(parser.parts)
    return '\n'.join(line for raw in text.splitlines()
                     if (line := re.sub(r'\s+', ' ', raw).strip())) + '\n'


if __name__ == '__main__':
    records = json.loads((ROOT / 'literature/scholarly-expansion-retrievals.json').read_text())
    latest = {r['paper_id']: r for r in records if r['status'] == 'retrieved'}
    for paper_id, record in latest.items():
        text = extract(record)
        (ROOT / 'local-extraction/literature' / f'{paper_id}.txt').write_text(text)
        print(paper_id, len(text.splitlines()), 'lines')
