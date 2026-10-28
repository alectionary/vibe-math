#!/usr/bin/env python3
"""Read Beck (2023) and write the discrimination matrix and the printed tables.

Usage:
  python3 extract_published.py /path/to/beck.pdf out
"""

from __future__ import annotations

import csv
import re
import sys
from pathlib import Path

from pypdf import PdfReader


def page_text(reader: PdfReader) -> str:
    parts = []
    for i, page in enumerate(reader.pages):
        parts.append(f"\n\n===== PAGE {i + 1} =====\n")
        parts.append(page.extract_text() or "")
    return "".join(parts)


def section(text: str, start: str, end: str) -> str:
    i = text.find(start)
    if i < 0:
        raise SystemExit(f"missing start marker {start!r}")
    j = text.find(end, i + len(start))
    if j < 0:
        raise SystemExit(f"missing end marker {end!r}")
    return text[i:j]


def discriminations(text: str, out: Path) -> None:
    block = section(text, "Item Discrimination Parameters that will be used for Data Generation", "Table A4")
    rows = []
    for line in block.splitlines():
        nums = re.findall(r"\d+\.\d+", line)
        if len(nums) == 4:
            rows.append([float(x) for x in nums])
    if len(rows) != 144:
        raise SystemExit(f"Table A3 has {len(rows)} rows, expected 144")
    # Primary loading is the largest entry. Items 1-36, 37-72, 73-108, 109-144.
    for block_i, start in enumerate(range(0, 144, 36)):
        for r in rows[start : start + 36]:
            primary = max(range(4), key=lambda j: r[j])
            if primary != block_i:
                raise SystemExit(f"row {start} primary column {primary}, expected {block_i}: {r}")
    with out.open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["item", "factor", "a1", "a2", "a3", "a4"])
        for i, r in enumerate(rows, start=1):
            w.writerow([i, (i - 1) // 36 + 1, *r])


def parse_classification(text: str, out: Path) -> list[dict]:
    a6 = text.rfind("Table A6")
    if a6 < 0:
        raise SystemExit("Table A6 not found")
    bstart = text.find("APPENDIX B", a6)
    block = text[a6:bstart]
    chunks = re.split(r"\n(?=Table A\d+)", block)
    records = []
    for chunk in chunks:
        m = re.match(r"Table (A\d+)", chunk)
        if not m:
            continue
        table = m.group(1)
        # Title up to the column header.
        title = " ".join(chunk.splitlines()[1:4])
        title = re.sub(r"\s+", " ", title)
        percent = table not in {"A24", "A25", "A26"}
        lines = chunk.splitlines()
        mode = None
        for line in lines:
            line = line.strip()
            if re.match(r"Dimensions?\b", line):
                mode = "dimension"
                continue
            if re.match(r"Response\b", line) or re.match(r"Categories\b", line):
                if "NPV" in line or line == "Response" or line.startswith("Response"):
                    mode = "categories" if "NPV" in line or line.startswith("Categories") else "categories_pending"
                if line == "Response":
                    mode = "categories_pending"
                continue
            if mode == "categories_pending" and line.startswith("Categories"):
                mode = "categories"
                continue
            if re.match(r"Test Length\b", line) or line == "Test":
                mode = "length" if "NPV" in line else "length_pending"
                continue
            if mode == "length_pending" and line.startswith("Length"):
                mode = "length"
                continue
            if re.match(r"Aberrancy\b", line):
                mode = "aberrancy"
                continue
            if mode is None:
                continue
            parts = line.split()
            if mode == "aberrancy" and parts and parts[0] in {
                "Acquiescence", "Disacquiescence", "Midpoint", "Extreme", "Social", "Careless", "MEAN",
            }:
                if len(parts) < 5:
                    continue
                label, npv, ppv, sens, spec = parts[0], *map(float, parts[1:5])
                records.append(dict(table=table, margin="aberrancy", level=label,
                                     npv=npv, ppv=ppv, sensitivity=sens, specificity=spec,
                                     sens_spec_scale="proportion"))
                continue
            if len(parts) >= 5 and re.fullmatch(r"\d+", parts[0]):
                level = parts[0]
                npv, ppv, sens, spec = map(float, parts[1:5])
                margin = {"dimension": "dimension", "categories": "categories", "length": "length"}[mode]
                if percent:
                    sens /= 100.0
                    spec /= 100.0
                records.append(dict(table=table, margin=margin, level=level,
                                     npv=npv, ppv=ppv, sensitivity=sens, specificity=spec,
                                     sens_spec_scale="percent" if percent else "proportion"))
    if len(records) < 100:
        raise SystemExit(f"only {len(records)} classification rows")
    with out.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(records[0].keys()))
        w.writeheader()
        w.writerows(records)
    return records


def identity(records: list[dict], out: Path) -> None:
    """If exactly 50 of 1000 respondents are flagged and 100 are aberrant,
    specificity, PPV, and NPV are functions of sensitivity."""
    rows = []
    for rec in records:
        s = rec["sensitivity"]
        tp = 100.0 * s
        fp = 50.0 - tp
        spec = (900.0 - fp) / 900.0
        ppv = tp / 50.0 if tp >= 0 else float("nan")
        npv = (850.0 + tp) / 950.0
        rows.append({
            **rec,
            "spec_from_sens": spec,
            "ppv_from_sens": ppv,
            "npv_from_sens": npv,
            "d_spec": rec["specificity"] - spec,
            "d_ppv": rec["ppv"] - ppv,
            "d_npv": rec["npv"] - npv,
        })
    with out.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)


def anova(text: str, out: Path) -> None:
    start = text.rfind("APPENDIX C")
    if start < 0:
        raise SystemExit("APPENDIX C not found")
    block = text[start:]
    # Drop page furniture.
    block = re.sub(r"===== PAGE \d+ =====", "\n", block)
    block = re.sub(r"(?m)^\s*\d{2,3}\s*$", "\n", block)
    raw_lines = [re.sub(r"\s+", " ", ln).strip() for ln in block.splitlines()]
    raw_lines = [ln for ln in raw_lines if ln]
    effects = ("dim:resp:leng", "dim:resp", "dim:leng", "resp:leng", "residual", "dim", "resp", "leng")
    records = []
    table = None
    outcome = None
    buf = ""
    for ln in raw_lines:
        m = re.match(r"Table (C\d+)", ln)
        if m:
            table = m.group(1)
            buf = ""
            continue
        if ln.startswith("Parameter "):
            buf = ""
            continue
        if ln == "Mean" or ln.startswith("Sq"):
            continue
        ln = ln.replace("residuals", "residual")
        buf = (buf + " " + ln).strip()
        # An outcome name may prefix the first effect.
        om = re.match(r"^(Sensitivity|Specificity|NPV|PPV)\b(.*)$", buf)
        if om:
            outcome = om.group(1)
            buf = om.group(2).strip()
        matched = None
        for eff in effects:
            if buf.startswith(eff + " ") or buf == eff:
                matched = eff
                break
        if not matched or table is None or outcome is None:
            continue
        rest = buf[len(matched):].strip()
        nums = re.findall(r"-?\d+\.\d+|\d+", rest)
        # Sum Sq, df, Mean Sq, F, partial omega. Residual F and omega may be blank.
        if matched == "residual":
            if len(nums) < 3:
                continue
            ss, df, ms = map(float, nums[:3])
            fval, omega = "", ""
        else:
            if len(nums) < 5:
                # Keep accumulating if the row was split across a page.
                continue
            ss, df, ms, fval, omega = nums[:5]
            ss, df, ms, fval, omega = float(ss), float(df), float(ms), float(fval), float(omega)
        records.append(dict(table=table, outcome=outcome, effect=matched,
                            ss=ss, df=df, ms=ms, f=fval, omega=omega))
        buf = ""
    with out.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(records[0].keys()))
        w.writeheader()
        w.writerows(records)
    from collections import Counter
    counts = Counter((r["table"], r["outcome"]) for r in records)
    bad = [k for k, v in sorted(counts.items()) if v != 8]
    if bad or len(records) != 18 * 4 * 8:
        raise SystemExit(f"only {len(records)} ANOVA rows; incomplete {bad[:12]}")
    check_anova(records, out.with_name("anova_check.csv"))


def check_anova(records: list[dict], out: Path) -> None:
    """Partial omega squared and F from the printed sums of squares."""
    groups: dict[tuple, list] = {}
    for r in records:
        groups.setdefault((r["table"], r["outcome"]), []).append(r)
    rows = []
    for key, items in groups.items():
        # Effect degrees of freedom plus the residual equal N - 1.
        resid = next(r for r in items if r["effect"] == "residual")
        n_obs = resid["df"] + sum(r["df"] for r in items if r["effect"] != "residual") + 1
        for r in items:
            if r["effect"] == "residual" or r["f"] == "":
                continue
            # Partial omega squared from the printed F. Reconstructing F from
            # sums of squares that are printed to two decimals is unstable,
            # because the error mean square is smaller than that rounding.
            num = r["df"] * (r["f"] - 1.0)
            omega_hat = num / (num + n_obs)
            rows.append({
                "table": r["table"], "outcome": r["outcome"], "effect": r["effect"],
                "f_printed": r["f"],
                "omega_printed": r["omega"],
                "omega_from_f": round(omega_hat, 4),
                "d_omega": r["omega"] - omega_hat,
                "N": n_obs,
            })
    with out.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    # Printed omega is two decimals. A gap inside 0.005 is the rounding unit.
    big = [r for r in rows if abs(r["d_omega"]) > 0.0055]
    print(f"ANOVA arithmetic: {len(rows)} effects, N={rows[0]['N']}, {len(big)} omega gaps above 0.0055")


def main() -> None:
    pdf = Path(sys.argv[1])
    out = Path(sys.argv[2])
    out.mkdir(parents=True, exist_ok=True)
    text = page_text(PdfReader(str(pdf)))
    (out / "dissertation_text.txt").write_text(text)
    discriminations(text, out / "discriminations.csv")
    records = parse_classification(text, out / "published_classification.csv")
    identity(records, out / "identity_residuals.csv")
    anova(text, out / "published_anova.csv")
    print(f"wrote {len(records)} classification rows to {out}")


if __name__ == "__main__":
    main()
