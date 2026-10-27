#!/usr/bin/env python3
"""Re-measure the equation-(7) glyph boxes on Man850 page 10.

The committed reading is simulation/out/qtl1/glyphs.json. This script
reads character boxes from the same PDF and checks that the equals sign,
the opening parenthesis of M, and the four unary minuses fall at those
coordinates. The PDF is not in git. Pass the local copy with --pdf.

Example, from the repository root:

    python3 formalization/correlated-residuals/simulation/measure_glyphs.py \\
        --pdf local-extraction/literature/unl-sem/mi-qtl2010.pdf \\
        --check formalization/correlated-residuals/simulation/out/qtl1/glyphs.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

# Private-use glyphs in the Man850 text layer.
MINUS = "\uf02d"
EQUALS = "\uf03d"
LPAREN = "\uf0e6"

# (cell label, expected x0, expected y0), one decimal place.
MINUS_CELLS = (
    ("G11 = -0.125", 245.2, 109.3),
    ("M23 = -0.5", 189.1, 124.3),
    ("G22 = -0.5", 311.2, 124.3),
    ("G32 = -0.125", 311.2, 139.3),
)


def _round1(value: float) -> float:
    return round(float(value) + 0.0, 1)


def character_boxes(page) -> list[dict]:
    raw = page.get_text("rawdict")
    boxes = []
    for block in raw["blocks"]:
        if block.get("type") != 0:
            continue
        for line in block["lines"]:
            for span in line["spans"]:
                for char in span["chars"]:
                    x0, y0, x1, y1 = char["bbox"]
                    boxes.append(
                        {
                            "c": char["c"],
                            "x0": _round1(x0),
                            "y0": _round1(y0),
                            "x1": _round1(x1),
                            "y1": _round1(y1),
                        }
                    )
    return boxes


def measure(pdf_path: Path) -> dict:
    import fitz

    doc = fitz.open(pdf_path)
    if doc.page_count < 10:
        raise SystemExit(f"{pdf_path} has {doc.page_count} pages; equation (7) is on page 10")
    boxes = character_boxes(doc[9])
    equals = [b for b in boxes if b["c"] == EQUALS and 100 < b["y0"] < 160]
    if len(equals) != 1:
        raise SystemExit(f"expected one equals sign in equation (7), found {len(equals)}")
    paren = [
        b
        for b in boxes
        if b["c"] == LPAREN and 105 <= b["y0"] <= 115 and b["x0"] < 200
    ]
    if not paren:
        raise SystemExit("opening parenthesis of M was not found")
    paren = min(paren, key=lambda b: b["x0"])
    minuses = [
        b
        for b in boxes
        if b["c"] == MINUS and 100 < b["y0"] < 160 and b["x0"] < 420
    ]
    assigned = []
    used = set()
    for label, x0, y0 in MINUS_CELLS:
        matches = [
            i
            for i, b in enumerate(minuses)
            if i not in used and b["x0"] == x0 and b["y0"] == y0
        ]
        if len(matches) != 1:
            raise SystemExit(f"minus for {label} at ({x0}, {y0}) matched {len(matches)} glyphs")
        used.add(matches[0])
        b = minuses[matches[0]]
        assigned.append(b | {"cell": label})
    extra = [minuses[i] for i in range(len(minuses)) if i not in used]
    if extra:
        raise SystemExit(f"unexpected minus glyphs in equation (7): {extra}")
    if not (equals[0]["x1"] < paren["x0"]):
        raise SystemExit("equals sign does not end before the parenthesis of M")
    between = [
        b
        for b in minuses
        if equals[0]["x1"] < b["x0"] < paren["x0"]
    ]
    payload = {
        "source": "Man850.pdf page 10, equation (7), character boxes from the PDF content stream",
        "equals_ends_x": equals[0]["x1"],
        "matrix_parenthesis_starts_x": paren["x0"],
        "no_minus_between_equals_and_M": len(between) == 0,
        "minuses": [
            {
                "x0": b["x0"],
                "x1": b["x1"],
                "y": b["y0"],
                "touches": _touch(b),
                "cell": b["cell"],
            }
            for b in assigned
        ],
        "unsigned_entries": {
            "M_row1": ["0", "0.5", "0.25"],
            "M_row2": ["0", "0", "-0.5"],
            "M_row3": ["0", "0", "0"],
            "G_qtl1": ["-0.125", "0.5", "0.25"],
            "G_qtl2": ["0.25", "-0.5", "-0.125"],
            "G_qtl3": ["0.5", "0.5", "0.25"],
        },
        "note": (
            "Each minus ends on the first digit of the number it signs. "
            "No other minus is present in the equation. A sign or magnitude "
            "other than this list is not a second reading of these glyphs."
        ),
    }
    return payload


def _touch(box: dict) -> str:
    # The committed file records which digit the minus abuts. These four
    # sentences are the labels for the four cells above, not a second measurement.
    touches = {
        "G11 = -0.125": "0.125 at x=250.7 y=110.4",
        "M23 = -0.5": "0.5 at x=194.5 y=125.4",
        "G22 = -0.5": "0.5 at x=316.7 y=125.4",
        "G32 = -0.125": "0.125 at x=316.7 y=140.4",
    }
    return touches[box["cell"]]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pdf", type=Path, required=True)
    parser.add_argument("--check", type=Path, help="committed glyphs.json to compare")
    parser.add_argument("--write", type=Path, help="write the measurement JSON here")
    args = parser.parse_args()
    payload = measure(args.pdf)
    text = json.dumps(payload, indent=2) + "\n"
    if args.write:
        args.write.write_text(text)
    if args.check:
        committed = json.loads(args.check.read_text())
        if committed != payload:
            raise SystemExit("measurement does not match the committed glyphs.json")
        print(f"matches {args.check}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
