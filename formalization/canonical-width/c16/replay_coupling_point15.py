#!/usr/bin/env python3
"""Replay the seven frozen point15 acceptance commands into a fresh directory.

This is a portable execution wrapper, not a mathematical certificate consumer.
The original exact consumers and their frozen inputs remain unchanged.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
FROZEN = ROOT / "coupling-results/final-clean-checkpoint0957/frozen.json"
POINT = ROOT / "coupling-results/integer-witness15-rational.json.gz"
OLD_OUTPUT = Path("/private/tmp/c16-clean-replay0957")
NAMES = [
    "point15-old-replay", "point15-unified-exact", "point15-projected-exact",
    "point15-basis-exact", "point15-global-moment-screen",
    "point15-all-triples", "point15-triple-distributions",
]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--stage-seconds", type=int, default=180)
    args = parser.parse_args()
    out = args.output_dir.resolve()
    assert not out.exists(), "Use a new output directory; never overwrite a receipt."
    assert args.stage_seconds > 0
    frozen = json.loads(FROZEN.read_text())
    commands = frozen["commands"][:7]
    assert [name for name, _ in commands] == NAMES
    # Validate all 689 original scientific inputs before running anything.
    bindings = frozen["input_and_source_hashes"]
    assert len(bindings) == 689
    assert all(sha(ROOT / path) == digest for path, digest in bindings.items())
    out.mkdir(parents=True)
    env = dict(os.environ)
    for key in ("OPENBLAS_NUM_THREADS", "OMP_NUM_THREADS", "MKL_NUM_THREADS",
                "VECLIB_MAXIMUM_THREADS", "NUMEXPR_NUM_THREADS"):
        env[key] = "1"
    rows = []
    for name, original in commands:
        command = [sys.executable]
        for arg in original[1:]:
            path = Path(arg)
            if path.is_absolute():
                assert path.parent == OLD_OUTPUT, (name, arg)
                arg = str(out / path.name)
            command.append(arg)
        started = time.monotonic()
        timed_out = False
        with (out / (name + ".log")).open("w") as log:
            try:
                run = subprocess.run(command, cwd=ROOT, env=env, stdout=log,
                                     stderr=subprocess.STDOUT,
                                     timeout=args.stage_seconds)
                returncode = run.returncode
            except subprocess.TimeoutExpired:
                returncode = None
                timed_out = True
        receipt = Path(command[command.index("--output") + 1])
        status = "NO_RECEIPT"
        if receipt.exists():
            status = json.loads(receipt.read_text()).get("status", "NO_STATUS")
        row = {"stage": name, "command": command, "returncode": returncode,
               "timed_out": timed_out, "status": status,
               "seconds": time.monotonic() - started,
               "receipt_sha256": sha(receipt) if receipt.exists() else None}
        rows.append(row)
        print(json.dumps({k: row[k] for k in ("stage", "returncode", "status")}),
              flush=True)
        if returncode != 0 or not status.startswith("PASS"):
            break
    unchanged = all(sha(ROOT / path) == digest for path, digest in bindings.items())
    recovered = out / "point15-recovered.json.gz"
    identical = recovered.exists() and sha(recovered) == sha(POINT)
    accepted = (len(rows) == 7 and all(row["returncode"] == 0 and
                row["status"].startswith("PASS") for row in rows)
                and unchanged and identical)
    summary = {
        "status": "PASS_SEVEN_POINT15_STAGES" if accepted else "NOT_ACCEPTED",
        "source_C16_answered": False,
        "scope": "Listed finite relaxation at point15 only; no physical frame claim.",
        "frozen_manifest_sha256": sha(FROZEN), "wrapper_sha256": sha(__file__),
        "point_sha256": sha(POINT), "scientific_input_bindings": len(bindings),
        "all_inputs_unchanged": unchanged, "byte_identical_recovery": identical,
        "stages": rows,
    }
    (out / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    print(summary["status"], flush=True)
    return 0 if accepted else 1


if __name__ == "__main__":
    sys.exit(main())
