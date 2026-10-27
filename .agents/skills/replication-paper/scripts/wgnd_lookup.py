#!/usr/bin/env python3
"""Look up a given name in a local copy of WGND 2.0.

The dictionary is Raffo (2021), "WGND 2.0", Harvard Dataverse,
https://doi.org/10.7910/DVN/MSEGSJ, CC0 1.0. The method is Lax Martínez,
Saenz de Juano-i-Ribes, Yin, Le Feuvre, Hamdan-Livramento, Saito, and Raffo
(2021), WIPO Economic Research Working Paper No. 64.

This script reads the name-gender-code file and, for a pronoun, the sources
file. It does not download those files during a lookup. ``--download`` fetches
the original CSVs and checks their published MD5 sums. The full files stay
outside git. ``--self-check`` uses the small CC0 extracts under testdata/.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import sys
import unicodedata
import urllib.request
from decimal import Decimal
from pathlib import Path

DOI = "10.7910/DVN/MSEGSJ"
DATASET_API = (
    "https://dataverse.harvard.edu/api/datasets/:persistentId/"
    "?persistentId=doi:10.7910/DVN/MSEGSJ"
)
THRESHOLD = Decimal("0.9")
MINIMUM_COUNT = 30

# Published MD5 and size of the original CSVs (Dataverse version 1.1).
FILES = {
    "names": {
        "original_name": "wgnd_2_0_name-gender-code.csv",
        "label": "wgnd_2_0_name-gender-code.tab",
        "md5": "c35e61bddfa2841fb89aa793dcd9b9f9",
        "size": 91229769,
    },
    "sources": {
        "original_name": "wgnd_2_0_sources.csv",
        "label": "wgnd_2_0_sources.tab",
        "md5": "dca1a4548196fed0c597f63a4a64dc38",
        "size": 137854765,
    },
}

# Toneless Hanyu Pinyin syllables, ASCII, ü written as v after l/n.
# Used only to space a concatenated given name such as "xiaojuan".
SYLLABLES = frozenset(
    """
    a ai an ang ao ba bai ban bang bao bei ben beng bi bian biao bie bin bing
    bo bu ca cai can cang cao ce cen ceng cha chai chan chang chao che chen
    cheng chi chong chou chu chua chuai chuan chuang chui chun chuo ci cong cou
    cu cuan cui cun cuo da dai dan dang dao de dei den deng di dia dian diao
    die ding diu dong dou du duan dui dun duo e ei en eng er fa fan fang fei
    fen feng fo fou fu ga gai gan gang gao ge gei gen geng gong gou gu gua guai
    guan guang gui gun guo ha hai han hang hao he hei hen heng hong hou hu hua
    huai huan huang hui hun huo ji jia jian jiang jiao jie jin jing jiong jiu
    ju juan jue jun ka kai kan kang kao ke ken keng kong kou ku kua kuai kuan
    kuang kui kun kuo la lai lan lang lao le lei leng li lia lian liang liao
    lie lin ling liu lo long lou lu luan lun luo lv lve ma mai man mang mao me
    mei men meng mi mian miao mie min ming miu mo mou mu na nai nan nang nao ne
    nei nen neng ni nian niang niao nie nin ning niu nong nou nu nuan nuo nv
    nve o ou pa pai pan pang pao pei pen peng pi pian piao pie pin ping po pou
    pu qi qia qian qiang qiao qie qin qing qiong qiu qu quan que qun ran rang
    rao re ren reng ri rong rou ru rua ruan rui run ruo sa sai san sang sao se
    sen seng sha shai shan shang shao she shei shen sheng shi shou shu shua
    shuai shuan shuang shui shun shuo si song sou su suan sui sun suo ta tai
    tan tang tao te teng ti tian tiao tie ting tong tou tu tuan tui tun tuo wa
    wai wan wang wei wen weng wo wu xi xia xian xiang xiao xie xin xing xiong
    xiu xu xuan xue xun ya yan yang yao ye yi yin ying yo yong you yu yuan yue
    yun za zai zan zang zao ze zei zen zeng zha zhai zhan zhang zhao zhe zhei
    zhen zheng zhi zhong zhou zhu zhua zhuai zhuan zhuang zhui zhun zhuo zi
    zong zou zu zuan zui zun zuo
    """.split()
)


def script_dir() -> Path:
    return Path(__file__).resolve().parent


def casefold_name(name: str) -> str:
    text = unicodedata.normalize("NFKC", name).strip().casefold()
    return " ".join(text.split())


def strip_accents(name: str) -> str:
    decomposed = unicodedata.normalize("NFD", name)
    return "".join(ch for ch in decomposed if not unicodedata.combining(ch))


def segmentations(token: str) -> list[tuple[str, ...]]:
    """All covers of token by two or three pinyin syllables."""
    if not token.isascii() or not token.isalpha():
        return []
    found: list[tuple[str, ...]] = []

    def walk(start: int, parts: list[str]) -> None:
        if len(parts) > 3:
            return
        if start == len(token):
            if len(parts) >= 2:
                found.append(tuple(parts))
            return
        for end in range(start + 1, len(token) + 1):
            piece = token[start:end]
            if piece in SYLLABLES:
                parts.append(piece)
                walk(end, parts)
                parts.pop()

    walk(0, [])
    return found


def candidate_forms(given: str) -> list[tuple[str, str, tuple[str, ...]]]:
    """(form, kind, syllables) in lookup order. kind is exact or pinyin."""
    raw = casefold_name(given)
    plain = strip_accents(raw)
    forms: list[tuple[str, str, tuple[str, ...]]] = [(raw, "exact", ())]
    if plain != raw:
        forms.append((plain, "exact", ()))
    token = plain.replace(" ", "").replace("-", "")
    if " " in plain or "-" in plain:
        return forms
    for parts in segmentations(token):
        forms.append((" ".join(parts), "pinyin-spacing", parts))
        if len(parts) == 2:
            forms.append(("-".join(parts), "pinyin-hyphen", parts))
    return forms


def _decimal(text: str) -> Decimal:
    return Decimal(text.strip())


def load_matches(path: Path, wanted: set[str], country: str | None) -> dict:
    """name -> country -> gender -> original weight string."""
    found: dict[str, dict[str, dict[str, str]]] = {}
    with path.open(newline="", encoding="utf-8") as handle:
        header = handle.readline()
        delimiter = "\t" if "\t" in header else ","
        handle.seek(0)
        reader = csv.DictReader(handle, delimiter=delimiter)
        for row in reader:
            name = casefold_name(row["name"])
            if name not in wanted:
                continue
            code = row["code"].strip().upper()
            if country and code != country:
                continue
            gender = row["gender"].strip().upper()
            found.setdefault(name, {}).setdefault(code, {})[gender] = row["wgt"].strip()
    return found


def load_counts(path: Path, wanted: set[str], country: str | None) -> dict:
    """name -> country -> gender -> (nobs sum, source labels)."""
    found: dict[str, dict[str, dict[str, list]]] = {}
    with path.open(newline="", encoding="utf-8") as handle:
        header = handle.readline()
        delimiter = "\t" if "\t" in header else ","
        handle.seek(0)
        reader = csv.DictReader(handle, delimiter=delimiter)
        for row in reader:
            name = casefold_name(row["name"])
            if name not in wanted:
                continue
            code = row["code"].strip().upper()
            if country and code != country:
                continue
            gender = row["gender"].strip().upper()
            try:
                nobs = int(row["nobs"].strip())
            except (KeyError, ValueError):
                nobs = 0
            slot = found.setdefault(name, {}).setdefault(code, {}).setdefault(
                gender, [0, []]
            )
            # The largest single source. Adding sources would count the same
            # people twice when a census row and a web row both list the name.
            slot[0] = max(slot[0], nobs)
            src = row.get("src", "").strip()
            if src and src not in slot[1]:
                slot[1].append(src)
    return found


def choose_form(
    forms: list[tuple[str, str, tuple[str, ...]]],
    table: dict,
    country: str,
) -> tuple[str, str, tuple[str, ...], list[str]] | None:
    """Pick the country row. Exact spelling wins. One pinyin split may fill a gap."""
    exact = [item for item in forms if item[1] == "exact"]
    for form, kind, parts in exact:
        if country in table.get(form, {}):
            return form, kind, parts, []
    hits: dict[tuple[str, ...], list[tuple[str, str]]] = {}
    for form, kind, parts in forms:
        if kind == "exact" or not parts:
            continue
        if country in table.get(form, {}):
            hits.setdefault(parts, []).append((form, kind))
    if len(hits) != 1:
        return None
    parts, spellings = next(iter(hits.items()))
    spellings.sort(key=lambda item: 0 if item[1] == "pinyin-spacing" else 1)
    chosen, kind = spellings[0]
    others = [form for form, _kind in spellings[1:]]
    return chosen, kind, parts, others


def pronoun_for(weights: dict[str, str], counts: dict[str, list] | None) -> tuple[str, str]:
    female = _decimal(weights["F"]) if "F" in weights else Decimal(0)
    male = _decimal(weights["M"]) if "M" in weights else Decimal(0)
    if female >= THRESHOLD and female > male:
        winner = "F"
    elif male >= THRESHOLD and male > female:
        winner = "M"
    else:
        return "none", "weight below 0.9"
    if counts is None:
        return "none", "sources file required"
    count = counts.get(winner, [0, []])[0]
    if count < MINIMUM_COUNT:
        return "none", "count below 30"
    pronoun = "she/her" if winner == "F" else "he/him"
    return pronoun, "weight at least 0.9 and count at least 30"


def format_record(
    given: str,
    country: str | None,
    forms: list[tuple[str, str, tuple[str, ...]]],
    table: dict,
    counts: dict | None,
) -> str:
    lines = [f"name: {given}", f"country: {country or ''}"]
    if not country:
        lines.extend(
            [
                "matched_form:",
                "pronoun: none",
                "reason: country required",
                "reference: surname",
            ]
        )
        return "\n".join(lines)

    chosen = choose_form(forms, table, country)
    if chosen is None:
        lines.extend(
            [
                "matched_form:",
                "pronoun: none",
                "reason: name absent" if not _any_country(forms, table) else "ambiguous spelling",
                "reference: surname",
            ]
        )
        return "\n".join(lines)

    form, kind, _parts, others = chosen
    weights = table[form][country]
    gender_counts = None if counts is None else counts.get(form, {}).get(country)
    pronoun, reason = pronoun_for(weights, gender_counts)
    lines.append(f"matched_form: {form}")
    lines.append(f"match_type: {kind}")
    for gender, label in (("F", "weight_F"), ("M", "weight_M"), ("?", "weight_unknown")):
        if gender in weights:
            lines.append(f"{label}: {weights[gender]}")
    if gender_counts is not None:
        source_labels = {"F": "sources_F", "M": "sources_M", "?": "sources_unknown"}
        for gender, label in (("F", "count_F"), ("M", "count_M"), ("?", "count_unknown")):
            if gender in gender_counts:
                lines.append(f"{label}: {gender_counts[gender][0]}")
                lines.append(
                    f"{source_labels[gender]}: {','.join(gender_counts[gender][1])}"
                )
    if others:
        lines.append(f"other_spellings: {', '.join(others)}")
    lines.append(f"pronoun: {pronoun}")
    lines.append(f"reason: {reason}")
    lines.append("reference: surname")
    return "\n".join(lines)


def _any_country(forms, table) -> bool:
    return any(table.get(form) for form, _kind, _parts in forms)


def lookup(names: list[str], country: str | None, names_path: Path, sources_path: Path | None) -> str:
    wanted: set[str] = set()
    prepared = []
    for name in names:
        forms = candidate_forms(name)
        prepared.append((name, forms))
        wanted.update(form for form, _kind, _parts in forms)
    table = load_matches(names_path, wanted, country)
    counts = None if sources_path is None else load_counts(sources_path, wanted, country)
    blocks = [
        f"source_doi: {DOI}",
        "source_file: wgnd_2_0_name-gender-code",
        f"threshold: {THRESHOLD}",
        f"minimum_count: {MINIMUM_COUNT}",
    ]
    body = [format_record(name, country, forms, table, counts) for name, forms in prepared]
    return "\n".join(blocks) + "\n\n" + "\n\n".join(body) + "\n"


def _md5(path: Path) -> str:
    digest = hashlib.md5()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def download(dest: Path) -> None:
    import json

    dest.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(DATASET_API, timeout=120) as response:
        payload = json.load(response)
    files = payload["data"]["latestVersion"]["files"]
    by_label = {item["label"]: item["dataFile"]["id"] for item in files}
    for spec in FILES.values():
        file_id = by_label[spec["label"]]
        url = (
            "https://dataverse.harvard.edu/api/access/datafile/"
            f"{file_id}?format=original"
        )
        target = dest / spec["original_name"]
        print(f"download {spec['original_name']} -> {target}", file=sys.stderr)
        urllib.request.urlretrieve(url, target)
        size = target.stat().st_size
        digest = _md5(target)
        if size != spec["size"] or digest != spec["md5"]:
            raise SystemExit(
                f"{target.name}: size {size} md5 {digest}, "
                f"expected size {spec['size']} md5 {spec['md5']}"
            )
        print(f"checked {target.name} md5 {digest}", file=sys.stderr)


def _record_map(text: str) -> dict[str, dict[str, str]]:
    records: dict[str, dict[str, str]] = {}
    current: dict[str, str] | None = None
    key = ""
    for line in text.splitlines():
        if not line.strip():
            current = None
            continue
        if ":" not in line:
            continue
        field, value = line.split(":", 1)
        value = value.strip()
        if field == "name":
            key = value.casefold()
            current = {}
            records[key] = current
        elif current is not None:
            current[field] = value
    return records


def self_check() -> None:
    root = script_dir() / "testdata"
    names_path = root / "wgnd_name_gender_code_examples.csv"
    sources_path = root / "wgnd_sources_examples.csv"
    text = lookup(
        ["Xiaojuan", "Xiaoyan", "Elizabeth", "Andrea", "Priya", "Haruki", "Notaname"],
        "CN",
        names_path,
        sources_path,
    )
    # Country-specific calls.
    cases = {
        ("Xiaojuan", "CN"): {
            "matched_form": "xiao juan",
            "match_type": "pinyin-spacing",
            "weight_F": ".47200927",
            "weight_M": ".027990742",
            "weight_unknown": ".5",
            "pronoun": "none",
            "reason": "weight below 0.9",
        },
        ("Xiaojuan", "ES"): {
            "matched_form": "xiaojuan",
            "match_type": "exact",
            "weight_F": "1",
            "count_F": "90",
            "pronoun": "she/her",
            "reason": "weight at least 0.9 and count at least 30",
        },
        ("Xiaojuan", "CH"): {
            "matched_form": "xiaojuan",
            "pronoun": "none",
            "reason": "count below 30",
            "count_F": "7",
        },
        ("Xiaoyan", "CN"): {
            "matched_form": "xiaoyan",
            "weight_F": "1",
            "count_F": "1",
            "pronoun": "none",
            "reason": "count below 30",
        },
        ("Elizabeth", "US"): {
            "matched_form": "elizabeth",
            "pronoun": "she/her",
            "weight_F": ".99676567",
        },
        ("Andrea", "US"): {"pronoun": "she/her", "matched_form": "andrea"},
        ("Andrea", "IT"): {"pronoun": "none", "reason": "count below 30", "weight_M": "1"},
        ("Priya", "IN"): {"pronoun": "none", "reason": "weight below 0.9"},
        ("Haruki", "JP"): {"pronoun": "none", "reason": "weight below 0.9"},
    }
    failures = []
    for (name, country), expected in cases.items():
        report = lookup([name], country, names_path, sources_path)
        got = _record_map(report)[name.casefold()]
        for field, value in expected.items():
            if got.get(field) != value:
                failures.append(f"{name}/{country} {field}: {got.get(field)!r} != {value!r}")
    missing = lookup(["Notaname"], "CN", names_path, sources_path)
    if _record_map(missing)["notaname"].get("reason") != "name absent":
        failures.append("absent name was not reported as absent")
    no_country = lookup(["Elizabeth"], None, names_path, sources_path)
    if _record_map(no_country)["elizabeth"].get("reason") != "country required":
        failures.append("missing country was not refused")
    splits = segmentations("xiaojuan")
    if ("xiao", "juan") not in splits:
        failures.append(f"xiaojuan segmentation missed xiao+juan: {splits}")
    # The China decision must not borrow the Swiss or Spanish row.
    china = _record_map(lookup(["Xiaojuan"], "CN", names_path, sources_path))["xiaojuan"]
    if china.get("pronoun") != "none" or china.get("matched_form") != "xiao juan":
        failures.append(f"China Xiaojuan borrowed another country: {china}")
    if "source_doi: 10.7910/DVN/MSEGSJ" not in text:
        failures.append("doi missing from report")
    if failures:
        raise SystemExit("self-check failed:\n" + "\n".join(failures))
    print("self-check passed")


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Look up given-name gender weights in WGND 2.0.")
    parser.add_argument("names", nargs="*", help="Given names. Surnames are not looked up.")
    parser.add_argument("--country", help="ISO 3166-1 alpha-2 country of origin, when known.")
    parser.add_argument("--data", type=Path, help="Local wgnd_2_0_name-gender-code.csv.")
    parser.add_argument("--sources", type=Path, help="Local wgnd_2_0_sources.csv.")
    parser.add_argument("--download", type=Path, help="Directory in which to save the original CSVs.")
    parser.add_argument("--self-check", action="store_true", help="Run the fixture checks.")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(sys.argv[1:] if argv is None else argv)
    if args.self_check:
        self_check()
        return 0
    if args.download:
        download(args.download)
        if not args.names:
            return 0
        if args.data is None:
            args.data = args.download / FILES["names"]["original_name"]
        if args.sources is None:
            args.sources = args.download / FILES["sources"]["original_name"]
    if not args.names or args.data is None:
        raise SystemExit("usage: wgnd_lookup.py --data FILE [--sources FILE] --country XX NAME")
    country = args.country.upper() if args.country else None
    if country and (len(country) != 2 or not country.isalpha()):
        raise SystemExit("country must be a two-letter ISO code")
    sys.stdout.write(lookup(args.names, country, args.data, args.sources))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
