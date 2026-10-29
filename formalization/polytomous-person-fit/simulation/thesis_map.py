#!/usr/bin/env python3
"""Compare Beck (2015) Table A3 loadings with the dissertation discrimination ranges.

The loadings and residuals are a transcription of the thesis appendix, checked against the PDF.
a = lambda / sqrt(residual), and the logistic form multiplies by 1.702.
"""

import csv
import math
from pathlib import Path

CFA = {
    "Anger": [(.61, .63), (.68, .54), (.71, .49), (.78, .39), (.81, .34), (.83, .31), (.78, .39)],
    "Avoid": [(.77, .41), (.76, .43), (.88, .22), (.73, .48), (.86, .26), (.81, .35), (.84, .30)],
    "Alcohol": [(.83, .32), (.88, .22), (.90, .19), (.85, .28), (.69, .53), (.88, .22), (.91, .17)],
    "Agora": [(.74, .45), (.61, .63), (.75, .44), (.84, .29), (.60, .64), (.83, .31), (.78, .39)],
}
# Stated uniform endpoints in Beck (2023), and the realized Table A3 blocks.
DISS = {
    "a1": (1.895, 3.296),
    "a2": (2.657, 4.668),
    "a3": (2.851, 6.651),
    "a4": (1.803, 3.837),
}


def main() -> None:
    out = Path("out") if Path("out").exists() else Path("simulation/out")
    rows = []
    print("factor   n   a min   a max   1.702*a min  1.702*a max")
    for name, items in CFA.items():
        a = [lam / math.sqrt(res) for lam, res in items]
        ad = [1.702 * x for x in a]
        print(f"{name:8} {len(a):2d} {min(a):7.3f} {max(a):7.3f} {min(ad):12.3f} {max(ad):11.3f}")
        for (lam, res), ai, adi in zip(items, a, ad):
            rows.append(dict(factor=name, lambda_=lam, residual=res, a=round(ai, 4), a_logistic=round(adi, 4)))
    with (out / "thesis_lambda_to_a.csv").open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print("dissertation stated ranges", DISS)
    print("wrote", out / "thesis_lambda_to_a.csv")


if __name__ == "__main__":
    main()
