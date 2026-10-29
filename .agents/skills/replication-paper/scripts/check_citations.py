"""Check ordinary LaTeX citation integrity; semantic coverage needs human review.

Pass included reference files explicitly. Supports cite, citep, citet (optional
notes/stars), bibitem keys and ordinary BibTeX entries; not a full TeX parser.
"""
import argparse
from collections import Counter
import json
from pathlib import Path
import re


def check_citations(paper, references, log=None):
    def uncomment(text):
        return re.sub(r"(?<!\\)%[^\n]*", "", text)

    paper = uncomment(paper)
    refs = uncomment(references)
    cited = set()
    for group in re.findall(r"\\cite(?:p|t)?\*?(?:\[[^\]]*\]){0,2}\{([^}]+)\}", paper):
        cited.update(k.strip() for k in group.split(",") if k.strip())
    keys = re.findall(r"\\bibitem(?:\[[^\]]*\])?\{([^}]+)\}", refs)
    keys += re.findall(r"(?im)^\s*@(?!comment\b|string\b|preamble\b)\w+\s*\{\s*([^,\s]+)\s*,", refs)
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


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("paper", type=Path)
    p.add_argument("--references", type=Path, nargs="+", required=True)
    p.add_argument("--log", type=Path)
    a = p.parse_args()
    result = check_citations(a.paper.read_text(), "\n".join(x.read_text() for x in a.references),
                             a.log.read_text(errors="replace") if a.log else None)
    print(json.dumps(result, indent=2))
    raise SystemExit(bool(result["errors"]))
