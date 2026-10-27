#!/usr/bin/env python3
"""Total effects (I - B)^{-1} G for the glyph reading of equation (7).

B = M and G carries the three unary minuses measured in glyphs.json.
The (1, 3) entry is 3/4, which is the 0.75 in Table 2. The QTL2 row of
the same product is 3/8, -7/16, 3/8. Table 2 prints -0.435 and 0.065
where this arithmetic gives -7/16 = -0.4375 and, for the indirect piece
of that row's middle entry, 1/16 = 0.0625.

From the repository root:

    python3 formalization/correlated-residuals/simulation/table2_totals.py
"""

from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path

F = Fraction


def eye():
    return [[F(1 if i == j else 0) for j in range(3)] for i in range(3)]


def matmul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)]
        for i in range(3)
    ]


def sub(a, b):
    return [[a[i][j] - b[i][j] for j in range(3)] for i in range(3)]


def inverse(m):
    aug = [row[:] + [F(int(i == j)) for j in range(3)] for i, row in enumerate(m)]
    for i in range(3):
        pivot = aug[i][i]
        if pivot == 0:
            raise SystemExit("singular I - B")
        aug[i] = [x / pivot for x in aug[i]]
        for r in range(3):
            if r == i:
                continue
            factor = aug[r][i]
            aug[r] = [aug[r][c] - factor * aug[i][c] for c in range(6)]
    return [row[3:] for row in aug]


def glyph_matrices():
    b = [
        [F(0), F(1, 2), F(1, 4)],
        [F(0), F(0), F(-1, 2)],
        [F(0), F(0), F(0)],
    ]
    g = [
        [F(-1, 8), F(1, 4), F(1, 2)],
        [F(1, 2), F(-1, 2), F(1, 2)],
        [F(1, 4), F(-1, 8), F(1, 4)],
    ]
    return b, g


def as_strings(m):
    return [[str(entry) for entry in row] for row in m]


def main():
    b, g = glyph_matrices()
    total = matmul(inverse(sub(eye(), b)), g)
    indirect_qtl2_y2 = F(1, 16)
    report = {
        "reading": "glyph: B = M, three unary minuses on G",
        "B": as_strings(b),
        "G": as_strings(g),
        "total_I_minus_B_inv_G": as_strings(total),
        "qtl3_on_y1": str(total[0][2]),
        "matches_table2_three_quarters": total[0][2] == F(3, 4),
        "qtl2_row": as_strings([total[1]]),
        "qtl2_middle": str(total[1][1]),
        "qtl2_middle_decimal": float(total[1][1]),
        "indirect_piece_printed_against": str(indirect_qtl2_y2),
        "printed_table2_qtl2": ["-0.435", "0.065"],
        "exact_decimals_at_those_cells": [-0.4375, 0.0625],
        "note": (
            "Table 2 prints -0.435 and 0.065. The exact total-effect entry "
            "is -7/16 = -0.4375. The indirect piece 1/16 = 0.0625 is the "
            "comparison used for the printed 0.065. Both differences are "
            "recorded as a source discrepancy under this reading, not as "
            "an established misprint."
        ),
    }
    if not report["matches_table2_three_quarters"]:
        raise SystemExit("glyph total effect of QTL3 on Y1 is not 3/4")
    if total[1][1] != F(-7, 16):
        raise SystemExit("QTL2 middle total is not -7/16")
    out = Path(__file__).resolve().parent / "out" / "table2_totals.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "qtl3_on_y1": report["qtl3_on_y1"],
        "qtl2_middle": report["qtl2_middle"],
        "wrote": str(out),
    }, indent=2))


if __name__ == "__main__":
    main()
