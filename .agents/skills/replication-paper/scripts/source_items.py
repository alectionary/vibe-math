"""Inventory every figure and table in the source, and gate the plan on it.

The plan's own lists say what was compared; this module reads the source PDF
itself, so a figure or table that nobody listed still fails the done check.

    python3 source_items.py inventory SOURCE.pdf     # JSON: every caption found
    python3 source_items.py inventory SOURCE.pdf --out source-inventory.json
                                                     # the record to commit with the study
    python3 source_items.py stub SOURCE.pdf          # YAML to paste under source_items:

A caption is a line that starts with "Figure N" or "Table N" (N may be dotted,
such as 4.12) and is set apart from body text: in bold, or followed by a
capitalised title, and not on a list-of-figures/tables page or in a sentence
("Figure 4.12 shows ..."). Each label is reported once, at the page of its
caption. Figures are classified by what the page holds:

  vector   many drawing paths and no large image: values can be read exactly
           from the paths (digitize.py vector)
  raster   a large embedded image: values can be read from colours
           (digitize.py raster)
  none     neither (a figure made of text, or one that failed to embed)

Tables whose page mentions correlations, covariances, means or standard
deviations are flagged `moments`: they may hold sufficient statistics.

Gate (`source_items_errors`): the plan's `source_items` must name every label in
the inventory, and only those, each with `use: read` and a `data_file` that
exists and holds data, or `use: excluded` with a `reason` and
`reported_to_person`. A `moments` table also needs `sufficient_statistics`.
Every number is put to work: a read table records `identity_checks` (the
relations among its printed numbers, checked), and an excluded item records
`uses_considered` for consistency, reconstruction and evidence, each not
useful with a reason; an item with a use is read instead.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

LABEL = re.compile(r"^\s*(Figure|Table)\s+([A-Z]?\d+(?:\.\d+)*)\b\.?\s*(.*)$")
VERB = re.compile(r"^(?:\(?[a-z]\)?\s*)?(shows?|displays?|depicts?|presents?|illustrates?|gives?|"
                  r"summari[sz]es?|lists?|reports?|provides?|contains?|indicates?|is|are|was|were|"
                  r"and|or|to|in|of|for|with|as|from|on|at|by|that|which|also|below|above|,|;|\))\b", re.I)
MOMENTS = re.compile(r"correlation|covariance|\bmeans?\b|standard deviation|\bSDs?\b|descriptive statistics", re.I)
LISTING = re.compile(r"^\s*LIST OF (FIGURES|TABLES)\b|^\s*List of (Figures|Tables)\s*$", re.M)
DOTS = re.compile(r"(?:\.\s?){6,}\s*[0-9ivxlc]+\s*$", re.M)
LEADER = re.compile(r"(\.\s?){4,}\s*\d+\s*$|\s\d+\s*$")


def _lines(page):
    """Yield (text, bold) for each line on the page."""
    for block in page.get_text("dict")["blocks"]:
        for line in block.get("lines", []):
            spans = [s for s in line["spans"] if s["text"].strip()]
            if not spans:
                continue
            text = "".join(s["text"] for s in spans).strip()
            first = spans[0]
            bold = bool(first["flags"] & 16) or "bold" in first["font"].lower()
            yield text, bold


def _figure_mode(page) -> str:
    area = page.rect.width * page.rect.height
    for img in page.get_images(full=True):
        try:
            for r in page.get_image_rects(img[0]):
                if r.width * r.height >= 0.08 * area:
                    return "raster"
        except Exception:
            continue
    if len(page.get_drawings()) >= 150:
        return "vector"
    return "none"


def inventory(pdf_path) -> list:
    import fitz

    found = {}
    with fitz.open(pdf_path) as doc:
        for index, page in enumerate(doc):
            lines = list(_lines(page))
            text = page.get_text()
            labels_here = sum(1 for t, _ in lines if LABEL.match(t))
            dot_leaders = len(DOTS.findall(text))
            listing = (LISTING.search(text) is not None
                       or (labels_here >= 1 and dot_leaders >= 2)
                       or (labels_here >= 4 and not page.get_images() and len(page.get_drawings()) < 20
                           and sum(1 for t, _ in lines if LEADER.search(t)) >= 2))
            if listing:
                continue          # list of figures or tables
            for k, (line, bold) in enumerate(lines):
                m = LABEL.match(line)
                if not m:
                    continue
                kind, number, rest = m.group(1).lower(), m.group(2), m.group(3).strip()
                if LEADER.search(line) and not bold:
                    continue
                if rest and VERB.match(rest) and not bold:
                    continue      # "Figure 4.12 shows ..." in running text
                if rest and not rest[0].isupper() and not bold:
                    continue      # a reference broken across lines ("Figure 4." / "31a), ...")
                if not bold and not rest and k + 1 < len(lines) and VERB.match(lines[k + 1][0]):
                    continue
                label = f"{kind.title()} {number}"
                title = rest or (lines[k + 1][0] if k + 1 < len(lines) else "")
                score = (2 if bold else 0) + (1 if rest and not VERB.match(rest) else 0)
                prior = found.get(label)
                if prior and prior["_score"] >= score:
                    continue
                item = {"label": label, "kind": kind, "page": index + 1, "title": title[:160], "_score": score}
                if kind == "figure":
                    item["mode"] = _figure_mode(page)
                else:
                    item["moments"] = bool(MOMENTS.search(title) or MOMENTS.search(text))
                found[label] = item
    out = []
    for item in sorted(found.values(), key=lambda i: (i["page"], i["label"])):
        item.pop("_score")
        out.append(item)
    return out


def _has_data(path: Path) -> bool:
    try:
        if path.suffix == ".json":
            data = json.loads(path.read_text(encoding="utf-8"))
            return bool(data)
        lines = [ln for ln in path.read_text(encoding="utf-8", errors="replace").splitlines() if ln.strip()]
        return len(lines) >= 2
    except OSError:
        return False


USES = ("consistency", "reconstruction", "evidence")


def _identity_errors(label, entry, root) -> list:
    """A table of numbers is checked against the identities that relate them.

    `identity_checks` lists each relation (an effect equals a product of paths, a
    total equals its parts, a statistic equals estimate / SE, df match n) with
    `holds` and the committed `file` that shows it. A failing identity names the
    `disagreement` that analyses it. A table with no such relation (a design
    table) says `identity_checks: none` with `identity_reason`.
    """
    checks = entry.get("identity_checks")
    if checks == "none":
        reason = entry.get("identity_reason")
        if not isinstance(reason, str) or len(reason.strip()) < 12:
            return [f"source_items {label}: identity_checks none requires identity_reason"]
        return []
    if not isinstance(checks, list) or not checks:
        return [f"source_items {label}: record identity_checks (relations among its printed numbers, "
                "checked) or identity_checks: none with identity_reason"]
    errors = []
    for c in checks:
        if not isinstance(c, dict) or not isinstance(c.get("identity"), str) or type(c.get("holds")) is not bool:
            errors.append(f"source_items {label}: each identity check needs identity and holds (true/false)")
            continue
        f = c.get("file")
        if not isinstance(f, str) or not (Path(root) / f).exists():
            errors.append(f"source_items {label}: identity check '{c['identity'][:40]}' needs a committed file")
        if c["holds"] is False and not (isinstance(c.get("disagreement"), str) and c["disagreement"].strip()):
            errors.append(f"source_items {label}: a failing identity names the disagreement that analyses it")
    return errors


def _uses_considered_errors(label, entry, root) -> list:
    """Before a figure or table is set aside, each way it could still help is considered.

    `uses_considered` answers, for consistency (identities with other printed
    numbers), reconstruction (recovering data or moments to rerun the analysis)
    and evidence (bearing on a disagreement, such as how the source coded a
    variable in its other analyses): `{useful: false, why}`. If any use is
    found, the item is read, not excluded.
    """
    uc = entry.get("uses_considered")
    if not isinstance(uc, dict):
        return [f"source_items {label}: excluded items record uses_considered "
                "{consistency, reconstruction, evidence}: {useful, why}"]
    errors = []
    for key in USES:
        v = uc.get(key)
        if not isinstance(v, dict) or type(v.get("useful")) is not bool \
                or not isinstance(v.get("why"), str) or len(v["why"].strip()) < 12:
            errors.append(f"source_items {label}: uses_considered.{key} needs useful (true/false) and a specific why")
        elif v["useful"]:
            errors.append(f"source_items {label}: uses_considered.{key} is useful, so read it (use: read) "
                          "instead of excluding it")
    return errors


def source_items_errors(plan, items, root) -> list:
    """Compare the plan's `source_items` with the inventory `items` read from the source."""
    root = Path(root)
    listed = plan.get("source_items") if isinstance(plan, dict) else None
    if not isinstance(listed, list):
        return [f"source_items: required; the source has {len(items)} figures and tables "
                "(run scripts/source_items.py stub SOURCE.pdf)"]
    errors = []
    by_label = {}
    for entry in listed:
        if not isinstance(entry, dict) or not isinstance(entry.get("label"), str):
            errors.append("source_items: each entry needs a label")
            continue
        if entry["label"] in by_label:
            errors.append(f"source_items {entry['label']}: listed twice")
        by_label[entry["label"]] = entry
    known = {i["label"]: i for i in items}
    for label in by_label:
        if label not in known:
            errors.append(f"source_items {label}: not a caption in the source")
    for label, item in known.items():
        entry = by_label.get(label)
        where = f"p. {item['page']}" + (f", {item['mode']}" if item["kind"] == "figure" else "")
        if entry is None:
            errors.append(f"source_items: {label} ({where}) is in the source but not in the plan")
            continue
        use = entry.get("use")
        if use == "read":
            data_file = entry.get("data_file")
            if not isinstance(data_file, str) or not data_file.strip():
                errors.append(f"source_items {label}: use read requires data_file")
            elif not _has_data(root / data_file):
                errors.append(f"source_items {label}: data_file {data_file} is missing or empty")
            if item["kind"] == "table":
                errors.extend(_identity_errors(label, entry, root))
        elif use == "excluded":
            errors.extend(_uses_considered_errors(label, entry, root))
            if not isinstance(entry.get("reason"), str) or len(entry["reason"].strip()) < 12:
                errors.append(f"source_items {label}: use excluded requires a specific reason")
            report = entry.get("reported_to_person")
            if not isinstance(report, dict) or not all(
                    isinstance(report.get(k), str) and report[k].strip() for k in ("date", "channel", "summary")):
                errors.append(f"source_items {label}: use excluded requires reported_to_person "
                              "{date, channel, summary}")
        else:
            errors.append(f"source_items {label}: use must be read or excluded")
        if item["kind"] == "table" and item.get("moments"):
            stats = entry.get("sufficient_statistics")
            if not isinstance(stats, dict) or type(stats.get("sufficient")) is not bool \
                    or not isinstance(stats.get("why"), str) or not stats["why"].strip():
                errors.append(f"source_items {label}: the page mentions means, SDs or correlations; "
                              "record sufficient_statistics {found, what, sufficient, why}")
    return errors


CITE = re.compile(r"\b(Figure|Table)s?\s+([A-Z]?\d+\.\d+(?:\.\d+)*)")


def cited_label_errors(paper_text, items) -> list:
    """A source figure or table the paper cites (dotted labels such as 4.12) must exist in the source."""
    known = {i["label"] for i in items}
    errors = []
    for kind, number in sorted(set(CITE.findall(paper_text or ""))):
        label = f"{kind} {number}"
        if label not in known:
            errors.append(f"paper: cites {label}, which is not a caption in the source")
    return errors


def stub(items) -> str:
    out = ["source_items:"]
    for i in items:
        note = f"p. {i['page']}" + (f", {i['mode']}" if i["kind"] == "figure" else
                                    (", moments" if i.get("moments") else ""))
        out.append(f"  - label: {json.dumps(i['label'])}   # {note}: {i['title'][:70]}")
        out.append("    use:            # read (data_file: ...) or excluded (reason, reported_to_person)")
    return "\n".join(out) + "\n"


def inventory_record(pdf_path) -> dict:
    """The inventory with the identity of the PDF it was read from, to commit with the study.

    The PDF itself may not be redistributable; this record and the values read
    from each item are what later sessions check against.
    """
    import hashlib

    import fitz

    data = Path(pdf_path).read_bytes()
    with fitz.open(pdf_path) as doc:
        pages = doc.page_count
    return {"source_sha256": hashlib.sha256(data).hexdigest(), "page_count": pages,
            "tool": "replication-paper/scripts/source_items.py", "items": inventory(pdf_path)}


def load_inventory_record(path) -> dict:
    data = json.loads(Path(path).read_text(encoding="utf-8"))
    if not isinstance(data, dict) or not isinstance(data.get("items"), list) \
            or not re.fullmatch(r"[0-9a-f]{64}", str(data.get("source_sha256", ""))):
        raise ValueError("not a source inventory record")
    return data


def main(argv=None) -> int:
    args = list(sys.argv[1:] if argv is None else argv)
    if len(args) == 4 and args[0] == "inventory" and args[2] == "--out":
        record = inventory_record(args[1])
        Path(args[3]).write_text(json.dumps(record, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"{len(record['items'])} items from {record['page_count']} pages -> {args[3]}")
        return 0
    if len(args) == 2 and args[0] in ("inventory", "stub"):
        items = inventory(args[1])
        if args[0] == "inventory":
            json.dump(items, sys.stdout, indent=1)
            sys.stdout.write("\n")
        else:
            sys.stdout.write(stub(items))
        return 0
    sys.stderr.write(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main())
