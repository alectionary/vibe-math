#!/usr/bin/env python3
"""Build the readable replication note from report/replication_note.md.

Requires ReportLab and Pillow. Run from any directory:
    python scripts/build_report.py

The source Markdown is authoritative; this renderer changes presentation only.
External Markdown links remain clickable. Relative artifact links are displayed
as bundle-relative paths rather than non-portable file hyperlinks.
"""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import platform
import re
from importlib.metadata import version
from pathlib import Path

from PIL import Image as PILImage
from reportlab import rl_config
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    BaseDocTemplate, Frame, Image, KeepTogether, PageBreak, PageTemplate,
    Paragraph, Spacer, Table, TableStyle,
)

ROOT = Path(__file__).resolve().parents[1]
FONT_DIRS = [
    Path('/usr/share/fonts/truetype/dejavu'),
    Path('/usr/local/share/fonts'),
]
PAGE_WIDTH, PAGE_HEIGHT = letter
MARGIN = 54
TEXT_WIDTH = PAGE_WIDTH - 2 * MARGIN


def find_font(filename: str) -> Path:
    for directory in FONT_DIRS:
        path = directory / filename
        if path.is_file():
            return path
    # ReportLab includes Bitstream Vera for environments without DejaVu.
    import reportlab
    fallback = {
        'DejaVuSerif.ttf': 'Vera.ttf',
        'DejaVuSerif-Bold.ttf': 'VeraBd.ttf',
        'DejaVuSerif-Italic.ttf': 'VeraIt.ttf',
        'DejaVuSerif-BoldItalic.ttf': 'VeraBI.ttf',
        'DejaVuSans.ttf': 'Vera.ttf',
        'DejaVuSans-Bold.ttf': 'VeraBd.ttf',
        'DejaVuSans-Oblique.ttf': 'VeraIt.ttf',
        'DejaVuSans-BoldOblique.ttf': 'VeraBI.ttf',
        'DejaVuSansMono.ttf': 'Vera.ttf',
    }
    path = Path(reportlab.__file__).parent / 'fonts' / fallback[filename]
    if path.is_file():
        return path
    raise FileNotFoundError(f'Required font not found: {filename}')


def register_fonts() -> dict[str, str]:
    filenames = {
        'ReportSerif': 'DejaVuSerif.ttf',
        'ReportSerif-Bold': 'DejaVuSerif-Bold.ttf',
        'ReportSerif-Italic': 'DejaVuSerif-Italic.ttf',
        'ReportSerif-BoldItalic': 'DejaVuSerif-BoldItalic.ttf',
        'ReportSans': 'DejaVuSans.ttf',
        'ReportSans-Bold': 'DejaVuSans-Bold.ttf',
        'ReportSans-Italic': 'DejaVuSans-Oblique.ttf',
        'ReportSans-BoldItalic': 'DejaVuSans-BoldOblique.ttf',
        'ReportMono': 'DejaVuSansMono.ttf',
    }
    used = {}
    for name, filename in filenames.items():
        path = find_font(filename)
        pdfmetrics.registerFont(TTFont(name, str(path)))
        used[name] = str(path)
    for family in ('ReportSerif', 'ReportSans'):
        pdfmetrics.registerFontFamily(
            family, normal=family, bold=f'{family}-Bold',
            italic=f'{family}-Italic', boldItalic=f'{family}-BoldItalic',
        )
    return used


def normalize(text: str) -> str:
    # Avoid visually ambiguous exotic hyphens without changing wording.
    text = text.translate(str.maketrans({'\u2010': '-', '\u2011': '-', '\u2212': '-'}))
    # These are spacing corrections only; all numbers and substantive wording
    # remain unchanged, and the source Markdown is not edited.
    spacing = {
        'the35': 'the 35', 'the28': 'the 28', 'the21': 'the 21',
        'May2010': 'May 2010', '283pages': '283 pages',
        'Table3.2': 'Table 3.2', 'AppendixJ': 'Appendix J',
        'AppendixI': 'Appendix I', 'Mplus5.2': 'Mplus 5.2',
        'n200,10,000replications,seed0': 'n200, 10,000 replications, seed 0',
        'R(2009citation)': 'R (2009 citation)',
        'SAS(2008citation)': 'SAS (2008 citation)',
        'revision055e3308': 'revision 055e3308',
    }
    for before, after in spacing.items():
        text = text.replace(before, after)
    return text


INLINE = re.compile(r'(`[^`]+`|\*\*[^*]+\*\*|\*[^*]+\*|\[[^\]]+\]\([^)]+\))')


def inline(text: str, *, table: bool = False) -> str:
    result = []
    for token in INLINE.split(normalize(text)):
        if not token:
            continue
        if token.startswith('`') and token.endswith('`'):
            size = '8.6' if table else '9.3'
            result.append(f'<font name="ReportMono" size="{size}">{html.escape(token[1:-1])}</font>')
        elif token.startswith('**') and token.endswith('**'):
            result.append(f'<b>{html.escape(token[2:-2])}</b>')
        elif token.startswith('*') and token.endswith('*'):
            result.append(f'<i>{html.escape(token[1:-1])}</i>')
        elif token.startswith('['):
            match = re.fullmatch(r'\[([^\]]+)\]\(([^)]+)\)', token)
            assert match
            label, target = match.groups()
            if target.startswith(('https://', 'http://')):
                result.append(f'<a href="{html.escape(target, quote=True)}" color="#000000"><u>{html.escape(label)}</u></a>')
            else:
                path = (ROOT / 'report' / target).resolve().relative_to(ROOT)
                # The linked artifact name alone is retained when it already
                # names the target; otherwise append its unambiguous local path.
                label_text = html.escape(label)
                if str(path) != label:
                    label_text += f' <font name="ReportSans" size="8.8">({html.escape(str(path))})</font>'
                result.append(label_text)
        else:
            result.append(html.escape(token))
    return ''.join(result)


def styles() -> dict[str, ParagraphStyle]:
    common = dict(textColor=colors.black, alignment=TA_LEFT, allowWidows=0,
                  allowOrphans=0, splitLongWords=1)
    body = ParagraphStyle('Body', fontName='ReportSerif', fontSize=10.5,
                          leading=15.1, spaceAfter=8.4, **common)
    return {
        'body': body,
        'title': ParagraphStyle('Title', fontName='ReportSans-Bold', fontSize=22,
                               leading=27.5, spaceAfter=19, keepWithNext=True, **common),
        'h2': ParagraphStyle('Heading2', fontName='ReportSans-Bold', fontSize=14.4,
                            leading=18.5, spaceBefore=16, spaceAfter=8.2,
                            keepWithNext=True, **common),
        'h3': ParagraphStyle('Heading3', fontName='ReportSans-Bold', fontSize=11.4,
                            leading=15.2, spaceBefore=10.5, spaceAfter=5.5,
                            keepWithNext=True, **common),
        'caption': ParagraphStyle('Caption', fontName='ReportSans', fontSize=9,
                                 leading=12, spaceBefore=5, spaceAfter=11,
                                 **common),
        'cell': ParagraphStyle('Cell', fontName='ReportSans', fontSize=8.7,
                              leading=11.6, spaceAfter=0, **common),
        'cellhead': ParagraphStyle('CellHead', fontName='ReportSans-Bold', fontSize=9,
                                  leading=11.8, spaceAfter=0, **common),
    }


class ReportDoc(BaseDocTemplate):
    def __init__(self, path: Path):
        super().__init__(str(path), pagesize=letter, rightMargin=MARGIN,
                         leftMargin=MARGIN, topMargin=55, bottomMargin=53,
                         title='Replication of Daniel Abbott 2010 dissertation',
                         author='', subject='Published summary reconstruction and evidence review',
                         pageCompression=1, allowSplitting=1)
        self.heading_count = 0
        self.page_count = 0
        frame = Frame(MARGIN, self.bottomMargin, TEXT_WIDTH,
                      PAGE_HEIGHT - self.topMargin - self.bottomMargin,
                      leftPadding=0, rightPadding=0, topPadding=0, bottomPadding=0)
        self.addPageTemplates(PageTemplate(id='normal', frames=[frame], onPage=self.decorate))

    def decorate(self, canvas, doc):
        canvas.saveState()
        if doc.page > 1:
            canvas.setFont('ReportSans', 8)
            canvas.drawString(MARGIN, PAGE_HEIGHT - 32, 'Abbott dissertation replication')
        canvas.setFont('ReportSans', 8)
        canvas.drawRightString(PAGE_WIDTH - MARGIN, 30, str(doc.page))
        canvas.restoreState()
        self.page_count = max(self.page_count, doc.page)

    def afterFlowable(self, flowable):
        if isinstance(flowable, Paragraph) and flowable.style.name in ('Heading2', 'Heading3'):
            self.heading_count += 1
            key = f'section-{self.heading_count}'
            self.canv.bookmarkPage(key)
            self.canv.addOutlineEntry(flowable.getPlainText(), key,
                                      level=0 if flowable.style.name == 'Heading2' else 1)


def make_table(lines: list[str], sty: dict[str, ParagraphStyle],
               widths: list[float] | None = None) -> Table:
    rows = [[cell.strip().replace('\\|', '|')
             for cell in re.split(r'(?<!\\)\|', line.strip().strip('|'))] for line in lines]
    rows = [row for row in rows if not all(re.fullmatch(r':?-+:?', cell) for cell in row)]
    ncols = len(rows[0])
    if widths is not None:
        pass
    elif ncols == 4:
        widths = [123, 128, 204, 49]
    elif ncols == 3:
        widths = [137, 187, 180]
    else:
        widths = [TEXT_WIDTH / ncols] * ncols
    data = []
    is_artifacts = rows[0][0] == 'Claim or task'
    for i, row in enumerate(rows):
        formatted_row = []
        for j, cell in enumerate(row):
            content = inline(cell, table=True)
            if is_artifacts and i > 0 and j == 1:
                content = content.replace('; ', ';<br/>')
                content = content.replace(' and sem_fits.csv', '<br/>and sem_fits.csv')
            formatted_row.append(Paragraph(content, sty['cellhead' if i == 0 else 'cell']))
        data.append(formatted_row)
    table = Table(data, colWidths=widths, repeatRows=1, hAlign='LEFT',
                  spaceBefore=3, spaceAfter=12, splitByRow=1)
    vertical_padding = 4.5 if rows[0][0] == 'Place checked' else 7
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#eeeeee')),
        ('TEXTCOLOR', (0, 0), (-1, -1), colors.black),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('LEFTPADDING', (0, 0), (-1, -1), 6),
        ('RIGHTPADDING', (0, 0), (-1, -1), 6),
        ('TOPPADDING', (0, 0), (-1, -1), vertical_padding),
        ('BOTTOMPADDING', (0, 0), (-1, -1), vertical_padding),
        ('LINEABOVE', (0, 0), (-1, 0), 0.7, colors.black),
        ('LINEBELOW', (0, 0), (-1, 0), 0.5, colors.black),
        ('LINEBELOW', (0, 1), (-1, -1), 0.25, colors.HexColor('#aaaaaa')),
    ]))
    return table


def availability_appendix(sty: dict[str, ParagraphStyle]):
    """Copy all ledger rows, omitting only the long route/query column.

    The full four-column original is supplied separately in the local bundle.
    Result/limit wording is not summarized or altered by this renderer.
    """
    ledger = ROOT / 'sources/availability_ledger.md'
    lines = ledger.read_text(encoding='utf-8').splitlines()
    rows = []
    for line in lines:
        if not line.startswith('|'):
            continue
        cells = [part.strip() for part in re.split(r'(?<!\\)\|', line.strip().strip('|'))]
        if len(cells) != 4:
            raise ValueError(f'Unexpected availability ledger row: {line}')
        rows.append('| ' + ' | '.join(cells[k] for k in (0, 1, 3)) + ' |')
    scope = next(line for line in lines if line.startswith('**Scope:**'))
    gap_index = lines.index('## What would resolve the availability gap?')
    gap = next(line for line in lines[gap_index + 1:] if line.strip())
    story = [
        Paragraph('Dated source and code availability ledger', sty['h2']),
        Paragraph(inline(scope), sty['body']),
        Paragraph('All 22 ledger entries are reproduced below. Exact routes and search queries '
                  'remain in the full local ledger at '
                  '<font name="ReportMono" size="9.3">sources/availability_ledger.md</font>.', sty['body']),
        Paragraph('What would resolve the availability gap', sty['h3']),
        Paragraph(inline(gap), sty['body']),
        make_table(rows, sty, widths=[119, 68, 317]),
    ]
    return story, len(rows) - 2


def make_story(source: Path, sty: dict[str, ParagraphStyle]):
    lines = source.read_text(encoding='utf-8').splitlines()
    story = []
    i = 0
    external_links = []
    figures = []
    while i < len(lines):
        line = lines[i].strip()
        if not line:
            i += 1
            continue
        if line.startswith('#'):
            match = re.fullmatch(r'(#{1,3}) (.+)', line)
            if not match:
                raise ValueError(f'Unsupported heading: {line}')
            level, content = match.groups()
            style = {1: 'title', 2: 'h2', 3: 'h3'}[len(level)]
            story.append(Paragraph(inline(content), sty[style]))
            i += 1
        elif line.startswith('|'):
            table_lines = []
            while i < len(lines) and lines[i].strip().startswith('|'):
                table_lines.append(lines[i]); i += 1
            story.append(make_table(table_lines, sty))
        elif line.startswith('!['):
            match = re.fullmatch(r'!\[([^\]]*)\]\(([^)]+)\)', line)
            if not match:
                raise ValueError(f'Unsupported image: {line}')
            label, relative = match.groups()
            path = (source.parent / relative).resolve()
            with PILImage.open(path) as source_image:
                width, height = source_image.size
            figure = Image(str(path), width=TEXT_WIDTH, height=TEXT_WIDTH * height / width)
            figure.hAlign = 'LEFT'
            caption = Paragraph(html.escape(label), sty['caption'])
            story.append(KeepTogether([Spacer(1, 5), figure, caption]))
            figures.append(str(path.relative_to(ROOT)))
            i += 1
        else:
            para = [line]
            i += 1
            while i < len(lines) and lines[i].strip() and not lines[i].startswith(('#', '|', '![')):
                para.append(lines[i].strip()); i += 1
            text = ' '.join(para)
            external_links += re.findall(r'\[[^\]]+\]\((https?://[^)]+)\)', text)
            story.append(Paragraph(inline(text), sty['body']))
    return story, sorted(set(external_links)), figures


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, default=ROOT / 'report/replication_note.md')
    parser.add_argument('--output', type=Path, default=ROOT / 'report/abbott_replication.pdf')
    args = parser.parse_args()
    args.source = args.source.resolve()
    args.output = args.output.resolve()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    rl_config.invariant = 1
    fonts = register_fonts()
    story, links, figures = make_story(args.source, styles())
    appendix, ledger_rows = availability_appendix(styles())
    story.extend(appendix)
    doc = ReportDoc(args.output)
    doc.build(story)
    manifest = {
        'source': str(args.source.relative_to(ROOT)),
        'source_sha256': sha256(args.source),
        'output': str(args.output.relative_to(ROOT)),
        'output_sha256': sha256(args.output),
        'builder': 'scripts/build_report.py',
        'builder_sha256': sha256(Path(__file__)),
        'pages': doc.page_count,
        'page_size': 'US Letter portrait',
        'software': {'python': platform.python_version(),
                     'reportlab': version('reportlab'), 'Pillow': version('Pillow')},
        'fonts': fonts,
        'external_hyperlinks': links,
        'figures': figures,
        'availability_appendix': {
            'source': 'sources/availability_ledger.md',
            'source_sha256': sha256(ROOT / 'sources/availability_ledger.md'),
            'rows': ledger_rows,
            'columns': ['Place checked', 'UTC date', 'Result and limit'],
            'omitted_column': 'Exact route/query or local evidence; retained in full source ledger',
        },
        'local_links': 'Displayed as bundle-relative paths; not file hyperlinks',
        'visual_qa': 'Pending separate raster inspection',
    }
    manifest_path = ROOT / 'outputs/report_build.json'
    manifest_path.write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'pdf': str(args.output), 'pages': doc.page_count,
                      'build_manifest': str(manifest_path)}, indent=2))


if __name__ == '__main__':
    main()
