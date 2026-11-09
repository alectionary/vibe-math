"""Validate the shared academic title block against page one of its exact PDF."""

import argparse
import json
from pathlib import Path
import re

ASSET = (Path(__file__).resolve().parents[2] / ".agents" / "skills"
         / "verified-release" / "assets" / "academic-title.tex")
TITLE_INPUT = re.compile(r"\\input\s*\{((?:[^{}]*/)?academic-title\.tex)\}")
DATE = re.compile(r"\\date\s*\{([^{}]*)\}")
DATE_TEXT = re.compile(r"(?:\d{1,2} [A-Za-z]+|[A-Za-z]+ \d{1,2},?) \d{4}")


def uncomment(source):
    return re.sub(r"(?<!\\)%[^\n]*", "", source)


def uses_template(source):
    return TITLE_INPUT.search(uncomment(source)) is not None


def exact_pdf(source):
    """Never use a neighboring PDF as a substitute for the manuscript."""
    candidate = Path(source).with_suffix(".pdf")
    return candidate if candidate.is_file() else None


def source_errors(tex, path):
    tex = uncomment(tex)
    errors = []
    inputs = TITLE_INPUT.findall(tex)
    if len(inputs) != 1:
        errors.append("title page: input the shared academic-title.tex exactly once")
    else:
        try:
            if (path.parent / inputs[0]).read_bytes() != ASSET.read_bytes():
                errors.append("title page: academic-title.tex differs from the approved template")
        except OSError:
            errors.append("title page: academic-title.tex input does not resolve")

    dates = DATE.findall(tex)
    if len(dates) != 1 or not DATE_TEXT.fullmatch(" ".join(dates[0].split())):
        errors.append("title page: supply one explicit day, month and year")
    if not re.search(r"\\title\s*\{\s*[^\s}]", tex):
        errors.append("title page: supply an explicit title")
    if re.search(r"\\@?maketitle\b", tex):
        errors.append("title page: use the shared input for maketitle without a local override")
    opening = re.search(r"\\begin\s*\{document\}(.*?)\\begin\s*\{abstract\}", tex, re.S)
    if not opening or not TITLE_INPUT.fullmatch(opening[1].strip()):
        errors.append("title page: put the shared title input directly before the abstract")
    return errors


def page_lines(page):
    for block in page.get_text("dict")["blocks"]:
        for line in block.get("lines", []):
            spans = [span for span in line["spans"] if span["text"].strip()]
            if spans:
                yield line["bbox"], spans, " ".join("".join(s["text"] for s in spans).split())


def rendered_errors(pdf, date, has_author=False):
    try:
        import fitz
        with fitz.open(pdf) as doc:
            if not doc.is_pdf or not len(doc):
                return ["title page: unreadable PDF"]
            page = doc[0]
            width, height = page.rect.width, page.rect.height
            lines = sorted(page_lines(page), key=lambda line: line[1][0]["origin"][1])
    except (ImportError, OSError, RuntimeError, ValueError) as exc:
        return [f"title page: cannot inspect PDF ({type(exc).__name__})"]

    errors = []
    if abs(width - 612) > 2 or abs(height - 792) > 2:
        errors.append("title page: expected a US Letter page")

    def baseline(line):
        return line[1][0]["origin"][1]

    def centered(line):
        return abs((line[0][0] + line[0][2] - width) / 2) <= 5

    def roman_at(line, points):
        return all(
            abs(span["size"] - points) <= 0.6
            and span["flags"] & (2 | 16) == 0  # italic or bold
            and re.search(r"CMR\d|LMRoman|Latin.?Modern.?Roman", span["font"], re.I)
            for span in line[1]
        )

    abstracts = [line for line in lines if line[2] == "Abstract"]
    date_lines = [line for line in lines if line[2] == date]
    if len(abstracts) != 1 or len(date_lines) != 1 or baseline(date_lines[0]) >= baseline(abstracts[0]):
        return errors + ["title page: expected the declared date above the Abstract heading"]
    date_line, abstract = date_lines[0], abstracts[0]
    title_area = [line for line in lines if baseline(line) < baseline(date_line)]
    title = [line for line in title_area if all(span["size"] >= 15 for span in line[1])]
    if not title:
        return errors + ["title page: no title lines found"]
    if (title_area[:len(title)] != title or (not has_author and title_area != title)
            or any(not centered(line) or not roman_at(line, 17.22) for line in title)):
        errors.append("title page: title lines must be centered 17.2 pt Computer Modern or Latin Modern roman")
    if not centered(date_line) or not roman_at(date_line, 11.96):
        errors.append("title page: date must be centered 12 pt Computer Modern or Latin Modern roman")
    if not 110 <= baseline(title[0]) <= 118:
        errors.append("title page: first title baseline is outside the approved range")
    if any(not 20 <= baseline(second) - baseline(first) <= 24 for first, second in zip(title, title[1:])):
        errors.append("title page: title line spacing is outside the approved range")
    date_gap = baseline(date_line) - baseline(title[-1])
    # Standard article reserves different space for absent and explicitly empty
    # author fields. A named author block may need extra rows.
    if not 62 <= date_gap <= (115 if has_author else 76):
        errors.append("title page: title-to-date spacing is outside the approved range")
    if not 30 <= baseline(abstract) - baseline(date_line) <= 39:
        errors.append("title page: date-to-abstract spacing is outside the approved range")
    return errors


def check(source, pdf=None):
    source = Path(source).resolve()
    try:
        tex = source.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        return [f"title page: cannot read editable manuscript ({type(exc).__name__})"]
    errors = source_errors(tex, source)
    if errors:
        return errors
    pdf = Path(pdf) if pdf is not None else exact_pdf(source)
    if pdf is None or not pdf.is_file():
        return ["title page: exact manuscript PDF is required"]
    tex = uncomment(tex)
    date = " ".join(DATE.findall(tex)[0].split())
    has_author = re.search(r"\\author\s*\{\s*[^\s}]", tex) is not None
    return rendered_errors(pdf, date, has_author=has_author)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--paper", required=True, type=Path, help="Editable LaTeX manuscript")
    parser.add_argument("--pdf", type=Path, help="Exact rendered PDF from the delivery record")
    args = parser.parse_args(argv)
    errors = check(args.paper, args.pdf)
    print(json.dumps({"accepted": not errors, "errors": errors}, indent=2))
    return 2 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
