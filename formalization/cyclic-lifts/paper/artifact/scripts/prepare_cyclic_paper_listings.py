"""Regenerate verbatim paper excerpts with reversible Unicode-to-TeX escapes."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
OUT = (ROOT.parent / 'listings' if (ROOT.parent / 'main.tex').is_file()
       else ROOT / 'formalization/cyclic-lifts/paper/listings')
GIRTH = 'formalization/dyadic-rank/CyclicLift/GirthCharacterization.lean'
STRUCTURE = 'formalization/dyadic-rank/CyclicStructure.lean'
CHARS = {
    '∀': r'\forall', '≠': r'\ne', '→': r'\to', '←': r'\leftarrow', '⟨': r'\langle',
    '⟩': r'\rangle', '∧': r'\land', '∨': r'\lor', '¬': r'\neg',
    '≤': r'\le', '∈': r'\in', '∉': r'\notin', 'ℕ': r'\mathbb N',
    '↔': r'\leftrightarrow', '∃': r'\exists', '≃': r'\simeq',
    '⊕': r'\oplus', '∪': r'\cup', '⊆': r'\subseteq', '▸': r'\triangleright',
    '·': r'\cdot',
}
records = {}


def render(name, filename, start, end=None, signature=False):
    source = (ROOT / filename).read_text()
    begin = source.index(start)
    stop = source.index(end, begin) if end else source.index('\n\n', begin)
    raw = source[begin:stop].rstrip()
    if signature:
        raw = raw.split(' := by')[0]
    assert all(ord(c) < 128 or c in CHARS for c in raw), set(c for c in raw if ord(c) > 127) - CHARS.keys()
    rendered = ''.join('(*@$' + CHARS[c] + '$@*)' if c in CHARS else c for c in raw)
    # Verify exact reversibility, including every space and Unicode character.
    inverse = {v: k for k, v in CHARS.items()}
    decoded = re.sub(r'\(\*@\$(.*?)\$@\*\)', lambda m: inverse[m[1]], rendered)
    assert decoded == raw
    (OUT / (name + '.tex')).write_text(rendered + '\n')
    records[name] = {
        'source': filename, 'start_line': source[:begin].count('\n') + 1,
        'end_line': source[:begin + len(raw)].count('\n') + 1,
        'kind': 'signature' if signature else 'verbatim contiguous excerpt',
        'raw_utf8_sha256': hashlib.sha256(raw.encode()).hexdigest(),
    }


render('source-answer', 'formalization/dyadic-rank/CyclicSourceQuestion.lean',
       'theorem sufficient_rectangle_conditions')
render('matrix-characterization', GIRTH, 'theorem matrixTanner_hX_girth_characterization')
render('absorbing-characterization', STRUCTURE, 'theorem absorbing_iff_cycle')
render('absorbing-bijection', STRUCTURE, 'noncomputable def absorbing_cycle_equiv')
render('stopping-statement', STRUCTURE, 'theorem stopping_card_ge_twice_degree', signature=True)
render('mixed-cycle-construction', GIRTH, 'def mixedEight')
render('mixed-cycle-simple', GIRTH, 'theorem mixedEight_isCycle')
render('stopping-disjointness', STRUCTURE, '  have znw :', '  let first :')
render('stopping-count', STRUCTURE, '  have hcard := Finset.card_le_card hsub', '\n\n')
(OUT / 'character-map.json').write_text(json.dumps(CHARS, indent=2, ensure_ascii=False) + '\n')
(OUT / 'excerpts.json').write_text(json.dumps(records, indent=2) + '\n')
print(f'Generated and round-trip checked {len(records)} source excerpts.')
