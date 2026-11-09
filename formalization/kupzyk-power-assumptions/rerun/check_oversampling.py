"""Check the source's observation-loss heuristic on the completed exemplary scan."""
import argparse
import csv
import json
from decimal import Decimal, ROUND_CEILING, ROUND_HALF_UP
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("study", type=Path)
parser.add_argument("exemplary", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=True)
with (args.study / "outputs/targets.csv").open() as stream:
    targets = {int(r["cell"]): r for r in csv.DictReader(stream)}
with (args.exemplary / "threshold-scan.csv").open() as stream:
    scan = {(int(r["cell"]), int(r["J"])): r for r in csv.DictReader(stream)}
with (args.exemplary / "oversampling-v2.csv").open() as stream:
    participant = {(float(r["icc"]), float(r["attrition"])): r for r in csv.DictReader(stream)}
rows = []
for cell, target in sorted(targets.items()):
    attrition = float(target["attrition"])
    if attrition == 0 or float(target["treat"]) != .5 or int(target["size"]) != 1:
        continue
    icc = float(target["icc"])
    observation_loss = Decimal("1.5") * Decimal(str(attrition))
    reference = int(target["J"])
    fractional = Decimal(reference) * (1 + observation_loss)
    for label, rule in (("nearest", ROUND_HALF_UP), ("ceiling", ROUND_CEILING)):
        count = int(fractional.to_integral_value(rounding=rule))
        r = scan[cell, count]
        p = participant[icc, attrition]
        rows.append(dict(cell=cell,icc=icc,interval_dropout=attrition,
                         observation_loss=float(observation_loss),rule=label,
                         reference_clusters=reference,observation_clusters=count,
                         observation_mean_power=r["power"],below_80_fraction=r["below80"],
                         observation_masks=r["masks"],participant_clusters=p["J"],
                         participant_mean_power=p["power"]))
assert len(rows) == 12
with (args.output / "observation-loss-oversampling.csv").open("w") as stream:
    writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)


target_completers = Decimal("200")
loss = Decimal(".15")
source_enrollment = target_completers * (1 + loss)
corrected_enrollment = (target_completers / (1 - loss)).to_integral_value(rounding=ROUND_CEILING)
example = {
    "source_locator": "Kupzyk (2011), printed p. 100",
    "target_expected_completers": int(target_completers),
    "dropout_probability": float(loss),
    "source_enrollment": int(source_enrollment),
    "expected_completers_with_source_enrollment": float(source_enrollment * (1 - loss)),
    "minimum_enrollment_for_target_expectation": int(corrected_enrollment),
}
(args.output / "completers-arithmetic.json").write_text(json.dumps(example, indent=2) + "\n")
