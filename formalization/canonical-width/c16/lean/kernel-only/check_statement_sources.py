#!/usr/bin/env python3
"""Check every existing named declaration's signature against the frozen base.

This source check complements the 37 compiled examples in StatementCheck.lean.
It also verifies that files outside the three proof-conversion modules, including
the paper, have not changed. New audit/report files do not affect this check.
"""
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parent.parent
BASE = "36c7dc91ce530d20443ea4dbfa7dd05a81fe3603"
REPO_PATH = "formalization/canonical-width/c16/lean/"


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True)


def signatures(source):
    # Existing C16 declaration headers contain no ':=' or 'where' inside types.
    # Preserve tokens exactly (apart from whitespace); permit added helper lemmas.
    pattern = r"^(?:(?:private|protected|noncomputable)\s+)*(theorem|lemma|def|abbrev|structure|inductive)\s+(\S+?)(?=\s|:)(.*?)(?::=|\bwhere\b)"
    return [(kind, name, " ".join(header.split()))
            for kind, name, header in re.findall(pattern, source, re.M | re.S)]


checked = 0
for path in sorted(ROOT.glob("*.lean")):
    old = git("show", BASE + ":" + REPO_PATH + path.name)
    new = path.read_text()
    old_headers = signatures(old)
    old_names = {(kind, name) for kind, name, _ in old_headers}
    new_headers = [h for h in signatures(new) if h[:2] in old_names]
    assert old_headers == new_headers, "signature changed: " + path.name
    if path.name not in {"Aut.lean", "Pools.lean", "Code.lean"}:
        assert old == new, "unexpected original source change: " + path.name
    checked += len(old_headers)
assert not git("diff", BASE, "--", "../paper/symmetric-frames.tex"), "paper changed"
print("STATEMENT SOURCE CHECK PASS:", checked, "original named signatures unchanged; paper unchanged")
