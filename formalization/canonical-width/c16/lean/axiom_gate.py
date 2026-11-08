#!/usr/bin/env python3
"""Audit every declaration owned by a C16 Lean library module.

Run `lake build` first, then `python3 axiom_gate.py [--strict] [--self-test]`.
The temporary Lean command enumerates the environment (including private and
generated declarations), executes #print axioms, and emits machine-readable
records using the same Lean.collectAxioms operation. No source-name regex is
used to discover declarations. Exit 0: policy accepted; 1: forbidden axioms;
2: compilation, enumeration, or output-integrity failure.
"""

import argparse
from collections import Counter
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent
STANDARD = {"propext", "Classical.choice", "Quot.sound"}
PREFIX = "C16_AXIOM_RECORD "


def classify(axioms):
    extra = set(axioms) - STANDARD
    if not extra:
        return "KERNEL"
    # These are the native_decide dependencies produced by the pinned toolchain.
    # Do not permit arbitrary names merely containing 'native_decide'.
    if all(a == "Lean.ofReduceBool" or
           re.fullmatch(r".+\._native\.native_decide\.ax_[0-9]+_[0-9]+", a)
           for a in extra):
        return "NATIVE"
    return "FORBIDDEN"


def accepted(records, strict):
    return all(classify(r["axioms"]) == "KERNEL" or
               (not strict and classify(r["axioms"]) == "NATIVE")
               for r in records)


def lean_source(modules, probes=False):
    imports = "\n".join("import " + m for m in modules)
    # Deliberately bad declarations exist ONLY in an ephemeral self-test file.
    bad = """
namespace AxiomGateProbe
theorem admitted : False := by sorry
axiom custom : False
theorem customUser : False := custom
theorem native : (List.range 5).length = 5 := by native_decide
theorem clean : True := True.intro
end AxiomGateProbe
""" if probes else ""
    module_names = ", ".join("`" + m for m in modules)
    return imports + "\nimport Lean\n" + bad + "\n" + r'''
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let owned : Array Name := #[MODULE_NAMES]
  let names := env.constants.toList.filterMap fun (name, _) =>
    let isOwned := match env.getModuleIdxFor? name with
      | some idx => owned.contains env.header.moduleNames[idx]!
      | none => PROBES && (`AxiomGateProbe).isPrefixOf name
    if isOwned then some name else none
  for name in names.toArray.qsort Name.lt do
    elabCommand (← `(#print axioms $(mkIdent name)))
    let axs ← collectAxioms name
    let record := Json.mkObj [("name", toJson name.toString),
      ("axioms", toJson (axs.map Name.toString))]
    liftIO <| IO.println ("C16_AXIOM_RECORD " ++ record.compress)
  liftIO <| IO.println s!"C16_AXIOM_COUNT {names.length}"
'''.replace("MODULE_NAMES", module_names).replace("PROBES", str(probes).lower())


def audit(modules, probes=False):
    with tempfile.TemporaryDirectory(prefix="c16-axiom-gate-") as tmp:
        source = Path(tmp) / "Audit.lean"
        source.write_text(lean_source(modules, probes))
        run = subprocess.run(["lake", "env", "lean", str(source)], cwd=ROOT,
                             text=True, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT)
    # Keep the literal #print axioms output, as well as the per-declaration verdict.
    print(run.stdout, end="")
    if run.returncode:
        raise RuntimeError("Lean audit exited " + str(run.returncode))
    records = [json.loads(line[len(PREFIX):]) for line in run.stdout.splitlines()
               if line.startswith(PREFIX)]
    counts = re.findall(r"^C16_AXIOM_COUNT ([0-9]+)$", run.stdout, re.M)
    if len(counts) != 1 or int(counts[0]) != len(records) or not records:
        raise RuntimeError("missing, empty, or inconsistent declaration enumeration")
    if len({r["name"] for r in records}) != len(records):
        raise RuntimeError("duplicate declaration records")
    return records


def self_test():
    records = audit(["Std"], probes=True)
    probes = {r["name"]: r for r in records if r["name"].startswith("AxiomGateProbe.")}
    expected = {"admitted": "FORBIDDEN", "custom": "FORBIDDEN",
                "customUser": "FORBIDDEN", "native": "NATIVE", "clean": "KERNEL"}
    for name, status in expected.items():
        record = probes["AxiomGateProbe." + name]
        assert classify(record["axioms"]) == status, record
        assert accepted([record], False) == (status != "FORBIDDEN"), record
        assert accepted([record], True) == (status == "KERNEL"), record
        print("SELF-TEST", name, status, json.dumps(record["axioms"]))
    assert "sorryAx" in probes["AxiomGateProbe.admitted"]["axioms"]
    assert "AxiomGateProbe.custom" in probes["AxiomGateProbe.customUser"]["axioms"]
    assert classify(["fake.native_decide.custom"]) == "FORBIDDEN"
    print("SELF-TEST PASS: sorry, custom axiom, native evaluation, and clean proof detected")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--strict", action="store_true")
    parser.add_argument("--self-test", action="store_true", help="run isolated probes only")
    parser.add_argument("--json", type=Path, help="write machine-readable declaration report")
    args = parser.parse_args()
    try:
        if args.self_test:
            self_test()
            return 0
        fresh = subprocess.run(["lake", "--no-build", "build"], cwd=ROOT,
                               text=True, stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT)
        print(fresh.stdout, end="")
        print("BUILD FRESHNESS EXIT", fresh.returncode)
        if fresh.returncode:
            raise RuntimeError("library build is missing or stale; run lake build first")
        # All local library sources; exclude no declarations by namespace or visibility.
        modules = sorted(p.stem for p in ROOT.glob("*.lean"))
        records = audit(modules)
        for r in records:
            r["status"] = classify(r["axioms"])
            print(r["status"], r["name"], json.dumps(r["axioms"]))
        if args.json:
            args.json.write_text(json.dumps(records, indent=2) + "\n")
        counts = Counter(r["status"] for r in records)
        result = accepted(records, args.strict)
        print("AXIOM GATE", "STRICT" if args.strict else "DEFAULT",
              "PASS" if result else "FAIL", "declarations=" + str(len(records)),
              " ".join(k + "=" + str(counts[k]) for k in ["KERNEL", "NATIVE", "FORBIDDEN"]))
        return 0 if result else 1
    except (RuntimeError, OSError, ValueError, KeyError, AssertionError) as error:
        print("AXIOM GATE ERROR:", error, file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
