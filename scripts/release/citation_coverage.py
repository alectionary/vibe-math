"""Validate ordinary LaTeX citations against a reviewed source inventory."""
import argparse
from collections import Counter
import json
from pathlib import Path
import re
from urllib.parse import urlsplit


def uncomment(text):
    return re.sub(r"(?<!\\)%[^\n]*", "", text)


def citation_keys(text):
    groups = re.findall(r"\\(?:cite(?:p|t|alp|alt)?|parencite|textcite)\*?(?:\[[^\]]*\]){0,2}\{([^}]+)\}", uncomment(text))
    return {key.strip() for group in groups for key in group.split(",") if key.strip()}


def bibliography_keys(text):
    refs = uncomment(text)
    keys = re.findall(r"\\bibitem(?:\[[^\]]*\])?\{([^}]+)\}", refs)
    keys += re.findall(r"(?im)^\s*@(?!(?:comment|string|preamble)\b)\w+\s*\{\s*([^,\s]+)\s*,", refs)
    return keys


def check_citations(paper, references, log=None):
    cited = citation_keys(paper)
    keys = bibliography_keys(references)
    defined = set(keys)
    errors = []
    if not cited:
        errors.append("No in-text citations found")
    if not defined:
        errors.append("No bibliography entries found")
    for label, values in (("Undefined citations", cited-defined),
                          ("Uncited references", defined-cited),
                          ("Duplicate references", {k for k,v in Counter(keys).items() if v > 1})):
        if values:
            errors.append(label + ": " + ", ".join(sorted(values)))
    if log is not None and re.search(r"(?:Citation.*undefined|undefined citations|undefined references|multiply defined)", log, re.I):
        errors.append("Build log contains unresolved or duplicate references")
    return {"citations": len(cited), "references": len(defined), "errors": errors,
            "limit": "Structural integrity only; verify claim support and source locators separately"}


# Retain a section's child subsections. Treat bibliography content separately.
HEADING = re.compile(r"\\(chapter|section|subsection|subsubsection)\*?(?:\[[^\]]*\])?\{((?:[^{}]|\{[^{}]*\})+)\}")
LEVEL = {"chapter": 0, "section": 1, "subsection": 2, "subsubsection": 3}
HREF = re.compile(r"\\href\{(https?://[^{}\s]+)\}\{([^{}]*)\}")
LINK = re.compile(r"\\(?:href|url)\{(https?://[^{}\s]+)\}")
INCLUDE = re.compile(r"\\(?:input|include)\{([^{}]+)\}")
BIBLIOGRAPHY = re.compile(r"\\begin\{thebibliography\}.*?\\end\{thebibliography\}", re.DOTALL)


def sections(text):
    headings = list(HEADING.finditer(text))
    spans = {}
    for index, heading in enumerate(headings):
        command, title = heading.groups()
        end = next(
            (later.start() for later in headings[index + 1:] if LEVEL[later[1]] <= LEVEL[command]),
            len(text),
        )
        spans.setdefault(" ".join(title.split()), []).append(text[heading.end():end])
    return spans


def relative_file(root, name):
    if not isinstance(name, str) or not name or Path(name).is_absolute():
        raise ValueError("expected a relative file path")
    path = (root / name).resolve()
    if not path.is_relative_to(root) or not path.is_file():
        raise ValueError(f"file is missing or outside the study: {name}")
    return path


def tex_source(path, root, ancestors=()):
    if path in ancestors:
        raise ValueError(f"recursive TeX input: {path.name}")
    text = uncomment(path.read_text(encoding="utf-8"))

    def expand(match):
        target = Path(match[1])
        if target.is_absolute() or "\\" in match[1]:
            return match[0]
        if not target.suffix:
            target = target.with_suffix(".tex")
        candidate = (path.parent / target).resolve()
        if not candidate.is_relative_to(root) or not candidate.is_file():
            return match[0]
        return tex_source(candidate, root, (*ancestors, path))

    return INCLUDE.sub(expand, text)


def nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def coverage_errors(root, paper, inventory):
    if not isinstance(inventory, dict):
        return ["inventory must be an object"]
    items = inventory.get("items")
    if not isinstance(items, list) or not items:
        return ["inventory must contain at least one citation item"]

    def read(name):
        return relative_file(root, name).read_text(encoding="utf-8")

    references = inventory.get("references", [])
    if not isinstance(references, list):
        return ["references must list any separate bibliography files"]
    try:
        # TeX input files are already expanded in paper. Separate .bib sources
        # belong here when the bibliography is supplied through BibTeX.
        bibliography = paper + "\n" + "\n".join(read(name) for name in references)
    except (OSError, UnicodeError, ValueError) as exc:
        return [f"bibliography: {exc}"]

    body = BIBLIOGRAPHY.sub("", uncomment(paper))
    errors = check_citations(body, bibliography)["errors"]
    spans = sections(body)
    keys = set()
    defined = set(bibliography_keys(bibliography))
    declared_links = {}
    audited_sections = inventory.get("software_sections", [])
    if not isinstance(audited_sections, list) or not all(nonempty(name) for name in audited_sections):
        return errors + ["software_sections must list manuscript section titles"]
    if len(set(audited_sections)) != len(audited_sections):
        errors.append("software_sections contains duplicate titles")

    for index, item in enumerate(items, 1):
        fields = ("subject", "evidence", "key", "section")
        if not isinstance(item, dict) or not all(nonempty(item.get(field)) for field in fields):
            errors.append(f"item {index}: subject, evidence, key, and section are required")
            continue
        subject, evidence, key, section = (item[field] for field in fields)
        keys.add(key)
        try:
            relative_file(root, evidence)
        except ValueError as exc:
            errors.append(f"{subject}: {exc}")
        blocks = spans.get(section, [])
        if len(blocks) != 1:
            errors.append(f"{subject}: section {section!r} must occur exactly once")
        elif key not in citation_keys(blocks[0]):
            errors.append(f"{subject}: missing \\cite{{{key}}} in {section!r}")
        if key not in defined:
            errors.append(f"{subject}: missing References entry {key!r}")

        if "software" in item:
            software = item["software"]
            if (not isinstance(software, dict) or not nonempty(software.get("version"))
                    or not nonempty(software.get("url"))):
                errors.append(f"{subject}: software version and official URL are required")
                continue
            url, version = software["url"], software["version"]
            if not re.fullmatch(r"https?://[^{}\s]+", url):
                errors.append(f"{subject}: invalid software URL {url!r}")
            if section not in audited_sections:
                errors.append(f"{subject}: list {section!r} in software_sections")
            declared_links.setdefault(section, set()).add(url)
            if len(blocks) == 1:
                link_with_version = (
                    r"\\href\{" + re.escape(url) + r"\}\{[^{}]*"
                    + r"(?<![\w.])" + re.escape(version) + r"(?![\w.])[^{}]*\}"
                )
                if not re.search(link_with_version, blocks[0]):
                    errors.append(f"{subject}: expected version {version} in the link to {url} in {section!r}")

    repository = inventory.get("repository", "")
    if repository and (not isinstance(repository, str) or not re.fullmatch(r"[\w.-]+/[\w.-]+", repository)):
        return errors + ["repository must have GitHub owner/name form"]
    own_repo = f"https://github.com/{repository}/" if repository else None
    other_links = inventory.get("other_links", {})
    if not isinstance(other_links, dict) or not all(nonempty(reason) for reason in other_links.values()):
        return errors + ["other_links must map nonsoftware URLs to reasons"]
    for section in audited_sections:
        blocks = spans.get(section, [])
        if len(blocks) != 1:
            errors.append(f"software audit section {section!r} must occur exactly once")
            continue
        for url in sorted(set(LINK.findall(blocks[0]))):
            if own_repo and url.startswith(own_repo):
                continue
            if url not in declared_links.get(section, set()) and url not in other_links:
                errors.append(f"software audit {section!r}: unaccounted external link {url}")

    # Common package registries and versioned link labels also catch software
    # links outside the declared sections, or an omitted software section.
    all_declared = set().union(*declared_links.values())
    registries = {"cran.r-project.org", "cloud.r-project.org", "pypi.org", "ctan.org"}
    candidates = {url for url, label in HREF.findall(body) if re.search(r"\b\d+\.\d+", label)}
    candidates.update(url for url in LINK.findall(body) if urlsplit(url).hostname in registries)
    for url in sorted(candidates - all_declared - other_links.keys()):
        if not own_repo or not url.startswith(own_repo):
            errors.append(f"unaccounted package or versioned link {url}")

    if "previous" in inventory:
        previous = inventory["previous"]
        if not isinstance(previous, dict):
            return errors + ["previous must identify the earlier bibliography and its dispositions"]
        try:
            earlier = set(bibliography_keys(read(previous.get("references"))))
        except (OSError, UnicodeError, ValueError) as exc:
            return errors + [f"previous bibliography: {exc}"]
        retained, dropped = previous.get("retained"), previous.get("dropped")
        if not earlier or not all(
            isinstance(group, dict) and all(nonempty(value) for value in group.values())
            for group in (retained, dropped)
        ):
            return errors + ["previous bibliography needs keys, retained mappings, and concrete dropped reasons"]
        for key in sorted(earlier - (retained.keys() | dropped.keys())):
            errors.append(f"previous reference {key!r} has no disposition")
        for key in sorted(retained.keys() & dropped.keys()):
            errors.append(f"previous reference {key!r} is both retained and dropped")
        for key in sorted((retained.keys() | dropped.keys()) - earlier):
            errors.append(f"unknown previous reference {key!r}")
        for old, new in retained.items():
            if new not in keys:
                errors.append(f"previous reference {old!r} maps to untracked citation {new!r}")
    return errors


def study_errors(root, paper, inventory="citation-inventory.json"):
    root = Path(root).resolve()
    paper = Path(paper)
    try:
        manuscript = paper.resolve() if paper.is_absolute() else (root / paper).resolve()
        manuscript.relative_to(root)
        if manuscript.suffix.lower() != ".tex":
            raise ValueError("provide the editable LaTeX manuscript")
        record = json.loads(relative_file(root, inventory).read_text(encoding="utf-8"))
        return coverage_errors(root, tex_source(manuscript, root), record)
    except (OSError, UnicodeError, ValueError) as exc:
        return [f"citation coverage: {exc}"]


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--paper", required=True, help="LaTeX source, relative to the study root")
    parser.add_argument("--inventory", default="citation-inventory.json", help="Study-relative inventory path")
    args = parser.parse_args(argv)
    errors = study_errors(args.root, args.paper, args.inventory)
    print(json.dumps({"accepted": not errors, "errors": errors}, indent=2))
    return 2 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
