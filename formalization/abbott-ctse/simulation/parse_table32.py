#!/usr/bin/env python3
"""Read Table 3.2 from the Abbott (2010) text layer and write the matrix.

The PDF is not in git. Pass --pdf, or pass --text from an existing
pdftotext -layout extraction. The committed CSV is the input the fits use.
This script rewrites that CSV only when --write is set, and it always
prints whether the text layer matches the committed file.
"""

from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from pathlib import Path

# Printed row order in Table 3.2, mapped onto the Appendix J names.
# CTELAB1 is not in the table. The tenth row is printed CPFI; it sits
# between CPF2 and CPF4, so it is the third field item.
ANALYSIS_NAMES = [
    "BCSE1", "BCSE2", "BCSE3",
    "CPDOMA1", "CPDOMA2", "CPDOMA3", "CPDOMA4",
    "CPFIEL1", "CPFIEL2", "CPFIEL3", "CPFIEL4",
    "CPPERS1", "CPPERS2", "CPPERS3", "CPPERS4",
    "CTELAB2", "CTELAB3", "CTELAB4", "CTELAB5",
    "CTFLEX1", "CTFLEX2", "CTFLEX3", "CTFLEX4",
    "CTFLUE1", "CTFLUE2", "CTFLUE3", "CTFLUE4",
    "CTORIG1", "CTORIG2", "CTORIG3", "CTORIG4",
    "Open1", "Open2", "Open3", "Open4",
    "Sex", "Age",
]


def pdftotext(pdf: Path) -> str:
    out = subprocess.check_output(
        ["pdftotext", "-layout", "-f", "108", "-l", "109", str(pdf)],
        text=True,
    )
    return out


def table_pages(text: str) -> str:
    if "\f" not in text:
        return text
    kept = []
    for page in text.split("\f"):
        if "1: BCSE1" in page or "22: CTFx3" in page:
            kept.append(page)
    if not kept:
        raise SystemExit("Table 3.2 pages were not found in the text")
    return "\n".join(kept)


def parse_rows(text: str) -> list[tuple[int, str, list[float]]]:
    text = table_pages(text)
    rows = []
    seen = set()
    for line in text.splitlines():
        match = re.match(r"\s*(\d+):\s*(\S+)\s+(.*)$", line)
        if not match:
            continue
        idx = int(match.group(1))
        label = match.group(2)
        rest = match.group(3).replace("–", "-").replace("—", "-")
        nums = [float(tok) for tok in re.findall(r"-?\d*\.\d+", rest)]
        if idx in seen:
            previous = next(row for row in rows if row[0] == idx)
            if previous[2] != nums or previous[1] != label:
                raise SystemExit(f"row {idx} disagrees across copies: {previous} vs {(idx, label, nums)}")
            continue
        seen.add(idx)
        rows.append((idx, label, nums))
    rows.sort(key=lambda row: row[0])
    return rows


def matrix_from_rows(rows: list[tuple[int, str, list[float]]]):
    if [idx for idx, _, _ in rows] != list(range(1, 38)):
        raise SystemExit(f"expected rows 1..37, got {[r[0] for r in rows]}")
    means, sds = [], []
    corr = [[0.0] * 37 for _ in range(37)]
    labels = []
    for idx, label, nums in rows:
        if len(nums) != idx + 1:
            raise SystemExit(
                f"row {idx} {label} has {len(nums)} numbers, expected {idx + 1}"
            )
        labels.append(label)
        means.append(nums[0])
        sds.append(nums[1])
        for j, value in enumerate(nums[2:]):
            corr[idx - 1][j] = value
            corr[j][idx - 1] = value
        corr[idx - 1][idx - 1] = 1.0
    return labels, means, sds, corr


def write_csv(path: Path, labels, means, sds, corr) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(
            ["printed_label", "analysis_name", "mean", "sd", *ANALYSIS_NAMES]
        )
        for i, name in enumerate(ANALYSIS_NAMES):
            writer.writerow(
                [labels[i], name, means[i], sds[i], *[f"{corr[i][j]:.2f}" for j in range(37)]]
            )


def read_committed(path: Path):
    with path.open() as handle:
        rows = list(csv.reader(handle))
    body = rows[1:]
    labels = [row[0] for row in body]
    means = [float(row[2]) for row in body]
    sds = [float(row[3]) for row in body]
    corr = [[float(x) for x in row[4:]] for row in body]
    return labels, means, sds, corr


def main() -> None:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser()
    parser.add_argument("--pdf", type=Path)
    parser.add_argument("--text", type=Path)
    parser.add_argument("--csv", type=Path, default=here / "table32.csv")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.pdf:
        text = pdftotext(args.pdf)
    elif args.text:
        text = args.text.read_text(errors="replace")
    else:
        raise SystemExit("pass --pdf or --text")
    labels, means, sds, corr = matrix_from_rows(parse_rows(text))
    if args.csv.exists() and not args.write:
        old = read_committed(args.csv)
        same = old == (labels, means, sds, corr)
        print(f"matches_committed {same}")
        if not same:
            sys.exit(1)
    if args.write or not args.csv.exists():
        write_csv(args.csv, labels, means, sds, corr)
        print(f"wrote {args.csv}")
    print("rows 37 labels", " ".join(labels))


if __name__ == "__main__":
    main()
