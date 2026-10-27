#!/usr/bin/env python3
"""Binomial probability of the printed SEM powers 64, 77, and 96.

The baseline 1000-replicate scan stores rates in
simulation/out/assumptions/baseline.json under summary.wide.sem.
Mi et al. (2010) Table 1 is a 100-replicate experiment. This script
evaluates

    P(K1=64) P(K2=77) P(K3=96)

with Ki ~ Binomial(100, p_i) and p_i the baseline rate. The product
treats the three QTL counts as independent. They are computed from the
same replicates, so the product is an order-of-magnitude figure under
that extra assumption.

From the repository root:

    python3 formalization/correlated-residuals/simulation/printed_probability.py
"""

from __future__ import annotations

import json
from pathlib import Path

from scipy.stats import binom

ROOT = Path(__file__).resolve().parent
BASELINE = ROOT / "out" / "assumptions" / "baseline.json"
OUT = ROOT / "out" / "printed_probability.json"
PRINTED = (64, 77, 96)


def main():
    payload = json.loads(BASELINE.read_text())
    rates = payload["summary"]["wide"]["sem"]
    if len(rates) != 3:
        raise SystemExit("baseline wide SEM summary is not a triple")
    terms = []
    product = 1.0
    for count, rate in zip(PRINTED, rates):
        p = float(rate) / 100.0
        pmf = float(binom.pmf(count, 100, p))
        terms.append({"printed_count": count, "baseline_percent": rate, "rate": p, "pmf": pmf})
        product *= pmf
    report = {
        "baseline_file": "simulation/out/assumptions/baseline.json",
        "baseline_seed": payload["spec"]["seed"],
        "baseline_reps": payload["n_reps"],
        "printed_replicates": 100,
        "independence": (
            "The product multiplies three binomial pmfs. The three detections "
            "come from the same replicates, so they are not independent."
        ),
        "terms": terms,
        "product": product,
    }
    OUT.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({"product": product, "wrote": str(OUT)}, indent=2))


if __name__ == "__main__":
    main()
