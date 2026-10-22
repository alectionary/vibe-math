"""Audit the general structural proofs; optionally repeat Lean kernel checking."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "formalization/dyadic-rank"
DATA = ROOT / "formalization/cyclic-lifts"
manifest = json.loads((DATA / "structure-verification.json").read_text())
for filename, digest in manifest["sha256"].items():
    assert hashlib.sha256((ROOT / filename).read_bytes()).hexdigest() == digest, filename

source = (LEAN / "CyclicStructure.lean").read_text()
# Strip comments before checking for forbidden proof escapes.
code = re.sub(r"/\-.*?\-/", "", source, flags=re.S)
code = re.sub(r"--[^\n]*", "", code)
assert not re.search(r"\b(sorry|admit|axiom|native_decide|unsafe)\b", code)
assert "public import CyclicLift" in source
declared = set(re.findall(r"^(?:@\[simp\] )?theorem (\w+)", source, re.M))
declared.add("absorbing_cycle_equiv")
assert declared == set(manifest["audited_declarations"])


def audit_log(log):
    assert "error:" not in log and "sorryAx" not in log
    reports = re.findall(r"'CyclicStructure\.(\w+)' depends on axioms: \[([^\]]*)\]", log)
    assert len(reports) == len(declared) == 29
    assert {name for name, _ in reports} == declared
    for name, axioms in reports:
        assert set(axioms.split(", ")) <= {"propext", "Classical.choice", "Quot.sound"}, name


audit_log((DATA / "structure-checks.log").read_text())
if "--recheck-lean" in sys.argv[1:]:
    run = subprocess.run(
        ["lake", "-f", "lakefile-cyclic.toml", "env", "lean", "CyclicStructure.lean"],
        cwd=LEAN, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
    )
    assert run.returncode == 0, run.stdout
    audit_log(run.stdout)
print("Validated 29 general structural declarations, exact audit coverage, source hashes, and standard logical axioms."
      + (" Fresh Lean kernel check passed." if "--recheck-lean" in sys.argv[1:] else ""))
