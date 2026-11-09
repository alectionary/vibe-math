"""Compatibility entry point for the shared structural citation check."""

import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[4] / "scripts" / "release"))
from citation_coverage import check_citations, study_errors  # noqa: E402,F401


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
