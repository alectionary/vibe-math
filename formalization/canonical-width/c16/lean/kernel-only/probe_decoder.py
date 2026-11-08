#!/usr/bin/env python3
"""Bounded priority-1 experiments, using the unchanged decoder and source data.

Run from any directory after lake build. Output is JSON with each Lean exit code
and diagnostic; exit 0 of this collector does NOT mean the Lean proofs passed.
No alternate encoding is substituted into the certificate theorem.
"""
import json
from pathlib import Path
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
PROBES = [
    ("array_tiny", "import CertGPTData", "(decode #[1,1,0,1,1,0]).isSome = true"),
    ("text_tiny", "import CertGPTData", '(decodeText "1 1 0 1 1 0").isSome = true'),
    ("split_tiny", "import CertGPTData", '("1 1 0".splitOn " ") = ["1", "1", "0"]'),
    ("nat_tiny", "import CertGPTData", '("1".toNat?) = some 1'),
]
for n in [1, 4, 16, 64]:
    text = " ".join(map(str, [n, n, 0] + [2**127 + 1] * (2*n) + [0]))
    PROBES.append(("text_vectors_" + str(n), "import CertGPTData",
                   "(decodeText " + json.dumps(text) + ").isSome = true"))
PROBES += [
    ("swap_pools_ok", "import CertGPTPool", "swapPoolsOK = true"),
    ("swap_check_ok", "import CertGPTRun", "swapCertificateOK = true"),
]

records = []
with tempfile.TemporaryDirectory(prefix="c16-decoder-probes-") as tmp:
    path = Path(tmp) / "Probe.lean"
    for name, imports, goal in PROBES:
        path.write_text(imports + "\nopen C16Frames.CertGPT\n"
                        "set_option maxRecDepth 10000\n"
                        "set_option maxHeartbeats 0\n"
                        "example : " + goal + " := by decide +kernel\n")
        start = time.monotonic()
        try:
            run = subprocess.run(["lake", "env", "lean", str(path)], cwd=ROOT,
                                 text=True, stdout=subprocess.PIPE,
                                 stderr=subprocess.STDOUT, timeout=60)
            record = dict(name=name, exit_code=run.returncode, output=run.stdout)
        except subprocess.TimeoutExpired as error:
            record = dict(name=name, exit_code=None, timeout_seconds=60,
                          output=(error.stdout or b"").decode())
        record["wall_seconds"] = time.monotonic() - start
        records.append(record)
print(json.dumps(records, indent=2))
