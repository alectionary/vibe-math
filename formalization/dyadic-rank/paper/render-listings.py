"""Render Lean Unicode as TeX math escapes without changing the checked source."""

import json
from pathlib import Path

root = Path(__file__).resolve().parent
glyphs = json.loads((root / "listings/glyph-map.json").read_text())["unicode_to_math"]
source = (root / "artifact/DyadicRank/Recursive.lean").read_text()
rendered = "".join("(*@$" + glyphs[c] + "$@*)" if c in glyphs else c for c in source)
assert not any(ord(c) > 127 for c in rendered), "Add missing glyphs to glyph-map.json"
recovered = rendered
for character, math in glyphs.items():
    recovered = recovered.replace("(*@$" + math + "$@*)", character)
assert recovered == source, "Glyph conversion must preserve the complete source"
assert rendered.count("\n") == source.count("\n")
(root / "listings/Recursive.lean.tex").write_text(rendered)
