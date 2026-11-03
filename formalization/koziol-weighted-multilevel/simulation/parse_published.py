#!/usr/bin/env python3
"""Parse Koziol (2015) Appendices C-F into one cell per printed number.

Bias tables print the absolute bias as the main entry. The parenthetical entry
is the relative bias. Brackets are the multilevel marginal (population-averaged)
version of the same statistic. Intercepts have no relative bias because the
generating intercept is zero.
"""

import csv
import re
import sys
from collections import defaultdict

import fitz

PDF = sys.argv[1] if len(sys.argv) > 1 else "source/koziol2015.pdf"
OUT = sys.argv[2] if len(sys.argv) > 2 else "results/published_cells.csv"

EST = {
    "us.ics", "um.ccs", "um.ics", "ws.ics",
    "wtm.ccs", "wtm.ics", "wam.ccs", "wam.ics",
}
RI_ORDER = ["us.ics", "um.ccs", "ws.ics", "wtm.ccs", "wam.ccs"]
RC_ORDER = ["us.ics", "um.ccs", "um.ics", "ws.ics", "wtm.ccs", "wtm.ics", "wam.ccs", "wam.ics"]
CONDS = [(0.05, 5), (0.05, 20), (0.25, 5), (0.25, 20)]
NUM = re.compile(r"-?\d+\.\d+")
TABLE_META = {
    "C.1": ("bias", "RI", "noninformative"),
    "C.2": ("bias", "RI", "informative"),
    "C.3": ("bias", "RC", "noninformative"),
    "C.4": ("bias", "RC", "informative"),
    "D.1": ("mse", "RI", "noninformative"),
    "D.2": ("mse", "RI", "informative"),
    "D.3": ("mse", "RC", "noninformative"),
    "D.4": ("mse", "RC", "informative"),
    "E.1": ("coverage", "RI", "noninformative"),
    "E.2": ("coverage", "RI", "informative"),
    "E.3": ("coverage", "RC", "noninformative"),
    "E.4": ("coverage", "RC", "informative"),
    "F.1": ("rmse", "RI", None),
    "F.2": ("rmse", "RC", None),
}


def cluster_lines(words, tol=2.0):
    words = sorted(words, key=lambda w: (w[1], w[0]))
    lines = []
    for w in words:
        if lines and abs(w[1] - lines[-1][0]) <= tol:
            lines[-1][1].append(w)
            # keep the seed y stable
        else:
            lines.append([w[1], [w]])
    out = []
    for y, ws in lines:
        ws = sorted(ws, key=lambda w: w[0])
        out.append((y, ws))
    return out


def merge_brackets(ws):
    """Join split tokens such as '[0.000' + '(-0.005)]'."""
    raw = [(w[0], w[4]) for w in ws]
    joined = []
    i = 0
    while i < len(raw):
        x, t = raw[i]
        if t.startswith("[") and "]" not in t:
            parts = [t]
            j = i + 1
            while j < len(raw) and "]" not in raw[j][1]:
                parts.append(raw[j][1])
                j += 1
            if j < len(raw):
                parts.append(raw[j][1])
                j += 1
            joined.append((x, "".join(parts)))
            i = j
        else:
            joined.append((x, t))
            i += 1
    return joined


def classify(tok):
    if tok in EST:
        return ("est", tok)
    if NUM.fullmatch(tok):
        return ("num", float(tok))
    m = re.fullmatch(r"\((-?\d+\.\d+)\)", tok)
    if m:
        return ("paren", float(m.group(1)))
    m = re.fullmatch(r"\[(-?\d+\.\d+)\]", tok)
    if m:
        return ("brack", float(m.group(1)))
    m = re.fullmatch(r"\[(-?\d+\.\d+)\((-?\d+\.\d+)\)\]", tok)
    if m:
        return ("brack_pair", (float(m.group(1)), float(m.group(2))))
    return None


def line_items(ws):
    items = []
    for x, t in merge_brackets(ws):
        kind = classify(t)
        if kind:
            items.append((x, kind[0], kind[1]))
    return items


def table_id_from_lines(lines):
    for _, ws in lines:
        text = " ".join(w[4] for w in ws)
        m = re.search(r"Table\s+([CDEF]\.\d)\.", text)
        if m:
            return m.group(1)
    return None


def header_centers(lines):
    gammas = []
    rmse_cols = []
    for _, ws in lines:
        texts = [w[4] for w in ws]
        if any("00" in t and t.startswith("𝛾") or t.startswith("γ") for t in texts):
            for w in ws:
                if w[4] in ("𝛾00", "γ00", "𝛾01", "γ01", "𝛾10", "γ10", "𝛾11", "γ11"):
                    gammas.append(w[0])
        if any("𝑁𝑜𝑟𝑚𝑎𝑙" in t or "Normal" in t for t in texts):
            for w in ws:
                if "𝑁𝑜𝑟𝑚𝑎𝑙" in w[4] or "𝐵𝑒𝑟𝑛𝑜𝑢𝑙𝑙𝑖" in w[4] or "Normal" in w[4] or "Bernoulli" in w[4]:
                    rmse_cols.append(w[0])
    return gammas, rmse_cols


def snap_cells(items, columns, metric):
    """Snap (x, kind, value) tokens to named column centers.

    columns is a list of (name, x, extra) where extra is passed through.
    """
    xs = [c[1] for c in columns]
    gaps = [xs[i + 1] - xs[i] for i in range(len(xs) - 1)] or [80]
    # Printed numbers sit left of the header glyph. Nearest-column assignment
    # still decides the parameter; this limit only drops marks in the margin.
    limit = 58
    stat = {"bias": "bias", "mse": "mse", "coverage": "coverage", "rmse": "rmse"}[metric]
    buckets = {id(c): [] for c in columns}
    far = []
    for x, kind, val in items:
        col = min(columns, key=lambda c: abs(x - c[1]))
        if abs(x - col[1]) > limit:
            far.append((x, kind, val))
            continue
        buckets[id(col)].append((kind, val))
    rows = []
    bad = []
    for col in columns:
        got = buckets[id(col)]
        name, _, extra = col
        nums = [v for k, v in got if k == "num"]
        parens = [v for k, v in got if k == "paren"]
        bracks = [v for k, v in got if k == "brack"]
        pairs = [v for k, v in got if k == "brack_pair"]
        if len(nums) > 2 or len(parens) > 1 or len(bracks) > 1 or len(pairs) > 1:
            bad.append((name, extra, got))
        if len(nums) == 1:
            rows.append((name, stat, "cs", nums[0], extra))
        elif len(nums) == 2 and metric == "bias":
            # The continuation line repeats the intercept as an unbracketed marginal value.
            rows.append((name, stat, "cs", nums[0], extra))
            rows.append((name, stat, "marginal", nums[1], extra))
        elif len(nums) > 1:
            bad.append((name, extra, got))
        if len(parens) == 1:
            rows.append((name, "rel_bias", "cs", parens[0], extra))
        for val in bracks:
            rows.append((name, stat, "marginal", val, extra))
        for val in pairs:
            rows.append((name, stat, "marginal", val[0], extra))
            rows.append((name, "rel_bias", "marginal", val[1], extra))
    if far:
        bad.append(("far", None, far))
    return rows, bad


def parse_region(items, params, metric):
    """items are (kind, value) already restricted to one outcome."""
    rows = []
    i = 0
    # A bracket-only continuation still uses parameter order.
    bracket_only = items and all(it[0] in ("brack", "brack_pair", "paren") for it in items)
    if metric == "rmse":
        if not items:
            return rows, 0
        kind, val = items[0]
        if kind == "num":
            rows.append(("eta", "rmse", "cs", val))
            i = 1
        if i < len(items) and items[i][0] == "brack":
            rows.append(("eta", "rmse", "marginal", items[i][1]))
            i += 1
        return rows, i
    for param in params:
        if i >= len(items):
            break
        kind, val = items[i]
        if kind == "num":
            stat = {"bias": "bias", "mse": "mse", "coverage": "coverage"}[metric]
            rows.append((param, stat, "cs", val))
            i += 1
            if metric == "bias" and i < len(items) and items[i][0] == "paren" and param != "g00":
                rows.append((param, "rel_bias", "cs", items[i][1]))
                i += 1
            if i < len(items) and items[i][0] == "brack":
                rows.append((param, stat, "marginal", items[i][1]))
                i += 1
            elif i < len(items) and items[i][0] == "brack_pair":
                rows.append((param, stat, "marginal", items[i][1][0]))
                if metric == "bias" and param != "g00":
                    rows.append((param, "rel_bias", "marginal", items[i][1][1]))
                i += 1
            if metric == "bias" and i < len(items) and items[i][0] == "paren" and param != "g00":
                rows.append((param, "rel_bias", "marginal", items[i][1]))
                i += 1
        elif kind == "brack" and bracket_only:
            stat = {"bias": "bias", "mse": "mse", "coverage": "coverage"}[metric]
            rows.append((param, stat, "marginal", val))
            i += 1
        elif kind == "brack_pair" and bracket_only and metric == "bias":
            rows.append((param, "bias", "marginal", val[0]))
            if param != "g00":
                rows.append((param, "rel_bias", "marginal", val[1]))
            i += 1
        elif kind == "paren" and bracket_only and metric == "bias" and param != "g00":
            rows.append((param, "rel_bias", "cs", val))
            i += 1
        else:
            break
    return rows, i


def consume_pairs(items):
    """Turn [bias (rel)] joined tokens and adjacent paren-inside-bracket into pairs."""
    out = []
    i = 0
    while i < len(items):
        kind, val = items[i][1], items[i][2]
        x = items[i][0]
        if kind == "brack" and i + 1 < len(items) and items[i + 1][1] == "paren":
            # only treat as a pair when the paren sits inside the same bracket group,
            # which merge_brackets already joined. A following bare paren is relative bias.
            out.append((x, kind, val))
            i += 1
        else:
            out.append((x, kind, val))
            i += 1
    return out


def main():
    doc = fitz.open(PDF)
    records = []
    problems = []
    current = None
    centers = None
    rmse_centers = None
    for pi in range(199, doc.page_count):
        lines = cluster_lines(doc[pi].get_text("words"), tol=3.2)
        tid = table_id_from_lines(lines)
        if tid:
            current = tid
            g, r = header_centers(lines)
            if g:
                centers = g
            if r:
                rmse_centers = r
        if current is None or current not in TABLE_META:
            continue
        metric, model, design = TABLE_META[current]
        # Assemble estimator rows, attaching the parenthesis / bracket line beneath.
        rows = []
        pending = None
        seen_est = False
        for y, ws in lines:
            items = line_items(ws)
            ests = [it for it in items if it[1] == "est"]
            nums = [it for it in items if it[1] != "est"]
            if (not seen_est and nums and main.stash.get(current)
                    and all(it[1] in ("paren", "brack", "brack_pair") for it in nums)):
                # Relative-bias line carried from the estimator at the bottom of the previous page.
                main.stash[current][-1]["items"].extend(nums)
                continue
            if ests and nums:
                seen_est = True
                if pending:
                    rows.append(pending)
                pending = {"y": y, "est": ests[0][2], "items": nums, "page": pi + 1}
            elif pending and nums and (
                y - pending["y"] <= 4
                or any(it[1] in ("paren", "brack", "brack_pair") for it in nums)
            ):
                if y - pending["y"] <= 16:
                    pending["items"].extend(nums)
                else:
                    rows.append(pending)
                    pending = None
            elif pending and y - pending["y"] > 16:
                rows.append(pending)
                pending = None
        if pending:
            rows.append(pending)
        if not rows:
            continue
        stash = main.stash.setdefault(current, [])
        stash.extend(rows)
        if centers:
            main.centers[current] = centers
        if rmse_centers:
            main.rmse_centers[current] = rmse_centers
    # Second pass: assign conditions and split outcomes.
    for tid, rows in main.stash.items():
        metric, model, design = TABLE_META[tid]
        order = RI_ORDER if model == "RI" else RC_ORDER
        params = ["g00", "g01", "g10"] if model == "RI" else ["g00", "g01", "g10", "g11"]
        blocks = []
        cur = []
        for row in rows:
            if row["est"] == "us.ics" and cur:
                blocks.append(cur)
                cur = [row]
            else:
                cur.append(row)
        if cur:
            blocks.append(cur)
        for b in blocks:
            names = [r["est"] for r in b]
            if names != order:
                problems.append(f"{tid} p{b[0]['page']} order {names}")
        if len(blocks) != 4:
            problems.append(f"{tid} has {len(blocks)} blocks, expected 4")
        gammas = main.centers.get(tid) or []
        rcols = main.rmse_centers.get(tid) or []
        for bi, block in enumerate(blocks):
            icc, nj = CONDS[bi] if bi < 4 else (None, None)
            for row in block:
                items = consume_pairs(row["items"])
                if metric == "rmse":
                    if len(rcols) < 4:
                        problems.append(f"{tid} missing RMSE column centers")
                        continue
                    sides = [
                        ("noninformative", "normal"),
                        ("noninformative", "bernoulli"),
                        ("informative", "normal"),
                        ("informative", "bernoulli"),
                    ]
                    columns = [("eta", rcols[i], sides[i]) for i in range(4)]
                    parsed, bad = snap_cells(items, columns, "rmse")
                    for b in bad:
                        problems.append(f"{tid} p{row['page']} {row['est']} rmse {b}")
                    for param, stat, scale, value, extra in parsed:
                        des, outcome = extra
                        records.append(dict(
                            table=tid, metric=metric, model=model, design=des,
                            outcome=outcome, icc=icc, nj=nj, estimator=row["est"],
                            parameter=param, statistic=stat, scale=scale,
                            published=value, page=row["page"],
                        ))
                    continue
                need = 6 if model == "RI" else 8
                if len(gammas) < need:
                    problems.append(f"{tid} gamma centers {gammas}")
                    continue
                columns = []
                for outcome, base in (("normal", 0), ("bernoulli", len(params))):
                    for j, param in enumerate(params):
                        columns.append((param, gammas[base + j], outcome))
                parsed, bad = snap_cells(items, columns, metric)
                for b in bad:
                    problems.append(f"{tid} p{row['page']} {row['est']} icc={icc} nj={nj} {b}")
                for param, stat, scale, value, outcome in parsed:
                    if param == "g00" and stat == "rel_bias":
                        problems.append(f"{tid} relative bias on intercept {row['est']} {outcome}")
                        continue
                    records.append(dict(
                        table=tid, metric=metric, model=model, design=design,
                        outcome=outcome, icc=icc, nj=nj, estimator=row["est"],
                        parameter=param, statistic=stat, scale=scale,
                        published=value, page=row["page"],
                    ))
    fields = ["table", "metric", "model", "design", "outcome", "icc", "nj", "estimator",
              "parameter", "statistic", "scale", "published", "page"]
    with open(OUT, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(records)
    print(f"wrote {len(records)} cells to {OUT}")
    print(f"problems {len(problems)}")
    for p in problems[:40]:
        print(" -", p)


main.stash = {}
main.centers = {}
main.rmse_centers = {}

if __name__ == "__main__":
    main()
