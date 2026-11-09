"""Summarize atomic CSV checkpoints; report attempted and successful fits separately."""
import argparse
import csv
from collections import defaultdict
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("checkpoints", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()
keys = ("beta", "se", "person_intercept", "person_slope", "cluster_intercept",
        "cluster_slope", "residual", "icc_hat", "bw", "od", "boundary", "retried")
groups = defaultdict(lambda: defaultdict(float))
seen = set()
for path in sorted(args.checkpoints.glob("*-*.csv")):
    with path.open(newline="") as f:
        row, = csv.DictReader(f)
    key = (row["arm"], int(row["cell"]), int(row["block"]))
    assert key not in seen and int(row["attempted"]) == 200
    seen.add(key)
    for k in ("attempted", "valid", *keys, *(k + "_sq" for k in keys)):
        groups[key[:2]][k] += float(row[k])
with args.output.open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["arm", "cell", "attempted", "valid",
                     *(column for k in keys for column in (k + "_mean", k + "_mcse"))])
    for (arm, cell), group in sorted(groups.items()):
        n = int(group["valid"])
        out = [arm, cell, int(group["attempted"]), n]
        for k in keys:
            out.extend([group[k]/n if n else "",
                        (max(0, group[k+"_sq"]-group[k]**2/n)/(n*(n-1)))**.5 if n>1 else ""])
        writer.writerow(out)
